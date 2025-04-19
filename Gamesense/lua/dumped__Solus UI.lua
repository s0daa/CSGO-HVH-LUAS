local var_0_0 = bit.band
local var_0_1 = bit.lshift
local var_0_2 = client.color_log
local var_0_3 = client.create_interface
local var_0_4 = client.delay_call
local var_0_5 = client.find_signature
local var_0_6 = client.key_state
local var_0_7 = client.reload_active_scripts
local var_0_8 = client.screen_size
local var_0_9 = client.set_event_callback
local var_0_10 = client.system_time
local var_0_11 = client.timestamp
local var_0_12 = client.unset_event_callback
local var_0_13 = database.read
local var_0_14 = database.write
local var_0_15 = entity.get_classname
local var_0_16 = entity.get_local_player
local var_0_17 = entity.get_origin
local var_0_18 = entity.get_player_name
local var_0_19 = entity.get_prop
local var_0_20 = entity.get_steam64
local var_0_21 = entity.is_alive
local var_0_22 = globals.framecount
local var_0_23 = globals.realtime
local var_0_24 = math.ceil
local var_0_25 = math.floor
local var_0_26 = math.max
local var_0_27 = math.min
local var_0_28 = panorama.loadstring
local var_0_29 = renderer.gradient
local var_0_30 = renderer.line
local var_0_31 = renderer.rectangle
local var_0_32 = table.concat
local var_0_33 = table.insert
local var_0_34 = table.remove
local var_0_35 = table.sort
local var_0_36 = ui.get
local var_0_37 = ui.is_menu_open
local var_0_38 = ui.mouse_position
local var_0_39 = ui.new_checkbox
local var_0_40 = ui.new_color_picker
local var_0_41 = ui.new_combobox
local var_0_42 = ui.new_slider
local var_0_43 = ui.set
local var_0_44 = ui.set_visible
local var_0_45 = setmetatable
local var_0_46 = pairs
local var_0_47 = error
local var_0_48 = globals.absoluteframetime
local var_0_49 = globals.curtime
local var_0_50 = globals.frametime
local var_0_51 = globals.maxplayers
local var_0_52 = globals.tickcount
local var_0_53 = globals.tickinterval
local var_0_54 = math.abs
local var_0_55 = type
local var_0_56 = pcall
local var_0_57 = renderer.circle_outline
local var_0_58 = renderer.load_rgba
local var_0_59 = renderer.measure_text
local var_0_60 = renderer.text
local var_0_61 = renderer.texture
local var_0_62 = tostring
local var_0_63 = ui.name
local var_0_64 = ui.new_button
local var_0_65 = ui.new_hotkey
local var_0_66 = ui.new_label
local var_0_67 = ui.new_listbox
local var_0_68 = ui.new_textbox
local var_0_69 = ui.reference
local var_0_70 = ui.set_callback
local var_0_71 = ui.update
local var_0_72 = unpack
local var_0_73 = tonumber
local var_0_74 = require("ffi")
local var_0_75 = require("vector")
local var_0_76 = require("gamesense/images")
local var_0_77 = require("gamesense/antiaim_funcs")

local function var_0_78(arg_1_0, arg_1_1, arg_1_2)
	return (function()
		local var_2_0 = {}
		local var_2_1
		local var_2_2
		local var_2_3
		local var_2_4
		local var_2_5
		local var_2_6
		local var_2_7
		local var_2_8
		local var_2_9
		local var_2_10
		local var_2_11
		local var_2_12
		local var_2_13
		local var_2_14
		local var_2_15 = {
			__index = {
				drag = function(arg_3_0, ...)
					local var_3_0, var_3_1 = arg_3_0:get()
					local var_3_2, var_3_3 = var_2_0.drag(var_3_0, var_3_1, ...)

					if var_3_0 ~= var_3_2 or var_3_1 ~= var_3_3 then
						arg_3_0:set(var_3_2, var_3_3)
					end

					return var_3_2, var_3_3
				end,
				set = function(arg_4_0, arg_4_1, arg_4_2)
					local var_4_0, var_4_1 = var_0_8()

					var_0_43(arg_4_0.x_reference, arg_4_1 / var_4_0 * arg_4_0.res)
					var_0_43(arg_4_0.y_reference, arg_4_2 / var_4_1 * arg_4_0.res)
				end,
				get = function(arg_5_0)
					local var_5_0, var_5_1 = var_0_8()

					return var_0_36(arg_5_0.x_reference) / arg_5_0.res * var_5_0, var_0_36(arg_5_0.y_reference) / arg_5_0.res * var_5_1
				end
			}
		}

		function var_2_0.new(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			arg_6_3 = arg_6_3 or 10000

			local var_6_0, var_6_1 = var_0_8()
			local var_6_2 = var_0_42("LUA", "A", arg_6_0 .. " window position", 0, arg_6_3, arg_6_1 / var_6_0 * arg_6_3)
			local var_6_3 = var_0_42("LUA", "A", "\n" .. arg_6_0 .. " window position y", 0, arg_6_3, arg_6_2 / var_6_1 * arg_6_3)

			var_0_44(var_6_2, false)
			var_0_44(var_6_3, false)

			return var_0_45({
				name = arg_6_0,
				x_reference = var_6_2,
				y_reference = var_6_3,
				res = arg_6_3
			}, var_2_15)
		end

		function var_2_0.drag(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
			if var_0_22() ~= var_2_1 then
				var_2_2 = var_0_37()
				var_2_5, var_2_6 = var_2_3, var_2_4
				var_2_3, var_2_4 = var_0_38()
				var_2_8 = var_2_7
				var_2_7 = var_0_6(1) == true
				var_2_12 = var_2_11
				var_2_11 = {}
				var_2_14 = var_2_13
				var_2_13 = false
				var_2_9, var_2_10 = var_0_8()
			end

			if var_2_2 and var_2_8 ~= nil and (not var_2_8 or var_2_14) and var_2_7 and arg_7_0 < var_2_5 and arg_7_1 < var_2_6 and var_2_5 < arg_7_0 + arg_7_2 and var_2_6 < arg_7_1 + arg_7_3 then
				var_2_13 = true
				arg_7_0, arg_7_1 = arg_7_0 + var_2_3 - var_2_5, arg_7_1 + var_2_4 - var_2_6

				if not arg_7_5 then
					arg_7_0 = var_0_26(0, var_0_27(var_2_9 - arg_7_2, arg_7_0))
					arg_7_1 = var_0_26(0, var_0_27(var_2_10 - arg_7_3, arg_7_1))
				end
			end

			var_0_33(var_2_11, {
				arg_7_0,
				arg_7_1,
				arg_7_2,
				arg_7_3
			})

			return arg_7_0, arg_7_1, arg_7_2, arg_7_3
		end

		return var_2_0
	end)().new(arg_1_0, arg_1_1, arg_1_2)
end

local function var_0_79()
	local var_8_0 = {
		renderer_line = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			var_0_30(arg_9_1.x, arg_9_1.y, arg_9_2.x, arg_9_2.y, arg_9_3.r, arg_9_3.g, arg_9_3.b, arg_9_3.a)
		end,
		renderer_rectangle_outlined = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			var_0_30(arg_10_1.x, arg_10_1.y, arg_10_1.x, arg_10_2.y, arg_10_3.r, arg_10_3.g, arg_10_3.b, arg_10_3.a)
			var_0_30(arg_10_1.x, arg_10_1.y, arg_10_2.x, arg_10_1.y, arg_10_3.r, arg_10_3.g, arg_10_3.b, arg_10_3.a)
			var_0_30(arg_10_2.x, arg_10_1.y, arg_10_2.x, arg_10_2.y, arg_10_3.r, arg_10_3.g, arg_10_3.b, arg_10_3.a)
			var_0_30(arg_10_1.x, arg_10_2.y, arg_10_2.x, arg_10_2.y, arg_10_3.r, arg_10_3.g, arg_10_3.b, arg_10_3.a)
		end,
		renderer_rectangle_filled = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			local var_11_0 = arg_11_2.x - arg_11_1.x
			local var_11_1 = arg_11_2.y - arg_11_1.y

			if var_11_0 < 0 then
				if var_11_1 < 0 then
					var_0_31(arg_11_2.x, arg_11_2.y, -var_11_0, -var_11_1, arg_11_3.r, arg_11_3.g, arg_11_3.b, arg_11_3.a)
				else
					var_0_31(arg_11_2.x, arg_11_1.y, -var_11_0, var_11_1, arg_11_3.r, arg_11_3.g, arg_11_3.b, arg_11_3.a)
				end
			elseif var_11_1 < 0 then
				var_0_31(arg_11_1.x, arg_11_2.y, var_11_0, -var_11_1, arg_11_3.r, arg_11_3.g, arg_11_3.b, arg_11_3.a)
			else
				var_0_31(arg_11_1.x, arg_11_1.y, var_11_0, var_11_1, arg_11_3.r, arg_11_3.g, arg_11_3.b, arg_11_3.a)
			end
		end,
		renderer_rectangle_outlined = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			var_0_30(arg_12_1.x, arg_12_1.y, arg_12_1.x, arg_12_2.y, arg_12_3.r, arg_12_3.g, arg_12_3.b, arg_12_3.a)
			var_0_30(arg_12_1.x, arg_12_1.y, arg_12_2.x, arg_12_1.y, arg_12_3.r, arg_12_3.g, arg_12_3.b, arg_12_3.a)
			var_0_30(arg_12_2.x, arg_12_1.y, arg_12_2.x, arg_12_2.y, arg_12_3.r, arg_12_3.g, arg_12_3.b, arg_12_3.a)
			var_0_30(arg_12_1.x, arg_12_2.y, arg_12_2.x, arg_12_2.y, arg_12_3.r, arg_12_3.g, arg_12_3.b, arg_12_3.a)
		end,
		renderer_rectangle_filled_gradient = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			local var_13_0 = arg_13_2.x - arg_13_1.x
			local var_13_1 = arg_13_2.y - arg_13_1.y

			if var_13_0 < 0 then
				if var_13_1 < 0 then
					var_0_29(arg_13_2.x, arg_13_2.y, -var_13_0, -var_13_1, arg_13_3.r, arg_13_3.g, arg_13_3.b, arg_13_3.a, arg_13_4.r, arg_13_4.g, arg_13_4.b, arg_13_4.a, arg_13_5)
				else
					var_0_29(arg_13_2.x, arg_13_1.y, -var_13_0, var_13_1, arg_13_3.r, arg_13_3.g, arg_13_3.b, arg_13_3.a, arg_13_4.r, arg_13_4.g, arg_13_4.b, arg_13_4.a, arg_13_5)
				end
			elseif var_13_1 < 0 then
				var_0_29(arg_13_1.x, arg_13_2.y, var_13_0, -var_13_1, arg_13_4.r, arg_13_4.g, arg_13_4.b, arg_13_4.a, arg_13_3.r, arg_13_3.g, arg_13_3.b, arg_13_3.a, arg_13_5)
			else
				var_0_29(arg_13_1.x, arg_13_1.y, var_13_0, var_13_1, arg_13_4.r, arg_13_4.g, arg_13_4.b, arg_13_4.a, arg_13_3.r, arg_13_3.g, arg_13_3.b, arg_13_3.a, arg_13_5)
			end
		end
	}

	function var_8_0.draw(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6)
		local var_14_0 = arg_14_2
		local var_14_1 = arg_14_5.clr_1

		arg_14_2 = 0
		arg_14_3 = arg_14_3 - var_14_0
		arg_14_5.h = arg_14_5.h - arg_14_5.thickness

		if arg_14_6 then
			var_8_0:renderer_rectangle_outlined({
				x = arg_14_5.x,
				y = arg_14_5.y
			}, {
				x = arg_14_5.x + arg_14_5.w - 1,
				y = arg_14_5.y + arg_14_5.h - 1 + arg_14_5.thickness
			}, {
				r = var_14_1[1],
				g = var_14_1[2],
				b = var_14_1[3],
				a = var_14_1[4]
			})
		end

		if arg_14_2 == arg_14_3 then
			var_8_0:renderer_line({
				x = arg_14_5.x,
				y = arg_14_5.y + arg_14_5.h
			}, {
				x = arg_14_5.x + arg_14_5.w,
				y = arg_14_5.y + arg_14_5.h
			}, {
				r = var_14_1[1],
				g = var_14_1[2],
				b = var_14_1[3],
				a = var_14_1[4]
			})

			return
		end

		local var_14_2 = arg_14_5.w / (arg_14_4 - 1)
		local var_14_3 = arg_14_3 - arg_14_2

		for iter_14_0 = 1, arg_14_4 - 1 do
			local var_14_4 = {
				(arg_14_1[iter_14_0] - var_14_0) / var_14_3,
				(arg_14_1[iter_14_0 + 1] - var_14_0) / var_14_3
			}
			local var_14_5 = {
				{
					x = arg_14_5.x + var_14_2 * (iter_14_0 - 1),
					y = arg_14_5.y + arg_14_5.h - arg_14_5.h * var_14_4[1]
				},
				{
					x = arg_14_5.x + var_14_2 * iter_14_0,
					y = arg_14_5.y + arg_14_5.h - arg_14_5.h * var_14_4[2]
				}
			}

			for iter_14_1 = 1, arg_14_5.thickness do
				var_8_0:renderer_line({
					x = var_14_5[1].x,
					y = var_14_5[1].y + iter_14_1 - 1
				}, {
					x = var_14_5[2].x,
					y = var_14_5[2].y + iter_14_1 - 1
				}, {
					r = var_14_1[1],
					g = var_14_1[2],
					b = var_14_1[3],
					a = var_14_1[4]
				})
			end
		end
	end

	function var_8_0.draw_histogram(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6)
		local var_15_0 = arg_15_2

		arg_15_2 = 0
		arg_15_3 = arg_15_3 - var_15_0

		if arg_15_6 then
			var_8_0:renderer_rectangle_outlined({
				x = arg_15_5.x,
				y = arg_15_5.y
			}, {
				x = arg_15_5.x + arg_15_5.w - 1,
				y = arg_15_5.y + arg_15_5.h - 1
			}, {
				r = 255,
				b = 255,
				g = 255,
				a = 255
			})
		end

		local var_15_1 = arg_15_5.w / (arg_15_4 - 1)
		local var_15_2 = arg_15_3 - arg_15_2

		for iter_15_0 = 1, arg_15_4 - 1 do
			local var_15_3 = {
				(arg_15_1[iter_15_0] - var_15_0) / var_15_2,
				(arg_15_1[iter_15_0 + 1] - var_15_0) / var_15_2
			}
			local var_15_4 = {
				{
					x = var_0_25(arg_15_5.x + var_15_1 * (iter_15_0 - 1)),
					y = var_0_25(arg_15_5.y + arg_15_5.h - arg_15_5.h * var_15_3[1])
				},
				{
					x = var_0_25(arg_15_5.x + var_15_1 * iter_15_0),
					y = var_0_25(arg_15_5.y + arg_15_5.h)
				},
				isZero = var_0_25(arg_15_5.y + arg_15_5.h) == var_0_25(arg_15_5.y + arg_15_5.h - arg_15_5.h * var_15_3[1])
			}

			if arg_15_5.sDrawBar == "fill" then
				var_8_0:renderer_rectangle_filled({
					x = var_15_4[1].x,
					y = var_15_4[1].y
				}, {
					x = var_15_4[2].x,
					y = var_15_4[2].y
				}, {
					r = arg_15_5.clr_1[1],
					g = arg_15_5.clr_1[2],
					b = arg_15_5.clr_1[3],
					a = arg_15_5.clr_1[4]
				})
			elseif arg_15_5.sDrawBar == "gradient_fadeout" then
				var_8_0:renderer_rectangle_filled_gradient({
					x = var_15_4[1].x,
					y = var_15_4[1].y
				}, {
					x = var_15_4[2].x,
					y = var_15_4[2].y
				}, {
					a = 0,
					r = arg_15_5.clr_1[1],
					g = arg_15_5.clr_1[2],
					b = arg_15_5.clr_1[3]
				}, {
					r = arg_15_5.clr_1[1],
					g = arg_15_5.clr_1[2],
					b = arg_15_5.clr_1[3],
					a = arg_15_5.clr_1[4]
				}, false)
			elseif arg_15_5.sDrawBar == "gradient_fadein" then
				var_8_0:renderer_rectangle_filled_gradient({
					x = var_15_4[1].x,
					y = var_15_4[1].y
				}, {
					x = var_15_4[2].x,
					y = var_15_4[2].y
				}, {
					r = arg_15_5.clr_1[1],
					g = arg_15_5.clr_1[2],
					b = arg_15_5.clr_1[3],
					a = arg_15_5.clr_1[4]
				}, {
					a = 0,
					r = arg_15_5.clr_1[1],
					g = arg_15_5.clr_1[2],
					b = arg_15_5.clr_1[3]
				}, false)
			end

			if arg_15_5.bDrawPeeks and not var_15_4.isZero then
				var_8_0:renderer_line({
					x = var_15_4[1].x,
					y = var_15_4[1].y
				}, {
					x = var_15_4[2].x,
					y = var_15_4[1].y
				}, {
					r = arg_15_5.clr_2[1],
					g = arg_15_5.clr_2[2],
					b = arg_15_5.clr_2[3],
					a = arg_15_5.clr_2[4]
				})
			end
		end
	end

	return var_8_0
end

local function var_0_80(arg_16_0, arg_16_1)
	local var_16_0 = {}

	for iter_16_0 = 1, arg_16_1 do
		var_16_0[iter_16_0] = arg_16_0
	end

	return var_16_0
end

local function var_0_81(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0

	if arg_17_2 or var_17_0[#var_17_0] ~= arg_17_1 then
		var_0_33(var_17_0, arg_17_1)
		var_0_34(var_17_0, 1)
	end

	arg_17_0 = var_17_0
end

local function var_0_82(arg_18_0)
	local var_18_0 = 0
	local var_18_1 = 0

	for iter_18_0, iter_18_1 in var_0_46(arg_18_0) do
		var_18_1 = var_18_1 + iter_18_1
		var_18_0 = var_18_0 + 1
	end

	return var_18_1 / var_18_0
end

local function var_0_83(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0
	local var_19_1
	local var_19_2
	local var_19_3 = var_0_25(arg_19_0 * 6)
	local var_19_4 = arg_19_0 * 6 - var_19_3
	local var_19_5 = arg_19_2 * (1 - arg_19_1)
	local var_19_6 = arg_19_2 * (1 - var_19_4 * arg_19_1)
	local var_19_7 = arg_19_2 * (1 - (1 - var_19_4) * arg_19_1)
	local var_19_8 = var_19_3 % 6

	if var_19_8 == 0 then
		var_19_0, var_19_1, var_19_2 = arg_19_2, var_19_7, var_19_5
	elseif var_19_8 == 1 then
		var_19_0, var_19_1, var_19_2 = var_19_6, arg_19_2, var_19_5
	elseif var_19_8 == 2 then
		var_19_0, var_19_1, var_19_2 = var_19_5, arg_19_2, var_19_7
	elseif var_19_8 == 3 then
		var_19_0, var_19_1, var_19_2 = var_19_5, var_19_6, arg_19_2
	elseif var_19_8 == 4 then
		var_19_0, var_19_1, var_19_2 = var_19_7, var_19_5, arg_19_2
	elseif var_19_8 == 5 then
		var_19_0, var_19_1, var_19_2 = arg_19_2, var_19_5, var_19_6
	end

	return var_19_0 * 255, var_19_1 * 255, var_19_2 * 255, arg_19_3 * 255
end

local function var_0_84(arg_20_0)
	local function var_20_0(arg_21_0, arg_21_1)
		local var_21_0 = {}

		for iter_21_0 in var_0_46(arg_21_0) do
			var_0_33(var_21_0, iter_21_0)
		end

		var_0_35(var_21_0, arg_21_1)

		local var_21_1 = 0

		return function()
			var_21_1 = var_21_1 + 1

			if var_21_0[var_21_1] == nil then
				return nil
			else
				return var_21_0[var_21_1], arg_21_0[var_21_0[var_21_1]]
			end
		end
	end

	local var_20_1 = {
		get = function(arg_23_0)
			local var_23_0 = 0
			local var_23_1 = {}

			for iter_23_0, iter_23_1 in var_20_0(package.solus_notes) do
				if iter_23_1 == true then
					var_23_0 = var_23_0 + 1
					var_23_1[#var_23_1 + 1] = {
						iter_23_0,
						var_23_0
					}
				end
			end

			for iter_23_2 = 1, #var_23_1 do
				if var_23_1[iter_23_2][1] == arg_20_0 then
					return arg_23_0(var_23_1[iter_23_2][2] - 1)
				end
			end
		end,
		set_state = function(arg_24_0)
			package.solus_notes[arg_20_0] = arg_24_0

			var_0_35(package.solus_notes)
		end,
		unset = function()
			var_0_12("shutdown", callback)
		end
	}

	var_0_9("shutdown", function()
		if package.solus_notes[arg_20_0] ~= nil then
			package.solus_notes[arg_20_0] = nil
		end
	end)

	if package.solus_notes == nil then
		package.solus_notes = {}
	end

	return var_20_1
end

local function var_0_85(arg_27_0)
	if arg_27_0 == nil then
		return 0
	end

	if #arg_27_0 == 0 then
		local var_27_0 = 0

		for iter_27_0 in var_0_46(arg_27_0) do
			var_27_0 = var_27_0 + 1
		end

		return var_27_0
	end

	return #arg_27_0
end

local function var_0_86(arg_28_0, arg_28_1)
	for iter_28_0 = 1, #arg_28_0 do
		if arg_28_0[iter_28_0] == arg_28_1 then
			return true
		end
	end

	return false
end

local function var_0_87(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	return {
		min = arg_29_0,
		max = arg_29_1,
		init_val = arg_29_2,
		scale = arg_29_3,
		value = arg_29_2
	}
end

local function var_0_88(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0 == nil or arg_30_0 == "" or arg_30_1 == nil or arg_30_1 == "" or arg_30_2 == nil or arg_30_2 == {} then
		var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(arg_30_0))
		var_0_2(255, 0, 0, "Error occured while parsing data")
		var_0_47()
	end

	local var_30_0 = var_0_13(arg_30_1)
	local var_30_1 = false
	local var_30_2 = false
	local var_30_3 = {}

	if var_30_0 == nil then
		var_30_0, var_30_1 = arg_30_2, true
	else
		for iter_30_0 in var_0_46(var_30_0) do
			local var_30_4 = false

			for iter_30_1 in var_0_46(arg_30_2) do
				if iter_30_0 == iter_30_1 then
					var_30_4 = true
				end
			end

			if not var_30_4 then
				var_30_0[iter_30_0] = nil
			end
		end

		for iter_30_2, iter_30_3 in var_0_46(arg_30_2) do
			if var_30_0[iter_30_2] == nil then
				var_30_0[iter_30_2], var_30_2 = iter_30_3, true
				var_30_3[#var_30_3 + 1] = "*" .. iter_30_2
			else
				local var_30_5 = false

				for iter_30_4, iter_30_5 in var_0_46(iter_30_3) do
					if iter_30_4 ~= "keybinds" and var_30_0[iter_30_2][iter_30_4] == nil or var_0_55(iter_30_5) ~= var_0_55(var_30_0[iter_30_2][iter_30_4]) then
						var_30_0[iter_30_2][iter_30_4], var_30_2 = iter_30_5, true

						if not var_30_5 then
							var_30_3[#var_30_3 + 1] = "*" .. iter_30_2
							var_30_5 = true
						end
					end
				end
			end
		end

		if #var_30_3 > 0 then
			var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(arg_30_0))
			var_0_2(255, 255, 255, ("Repairing %d sector(s) \x01\x00"):format(#var_30_3))
			var_0_2(155, 220, 220, ("[ %s ]"):format(var_0_32(var_30_3, " ")))
		end
	end

	if var_30_1 or var_30_2 then
		var_0_14(arg_30_1, var_30_0)
	end

	return var_30_0, arg_30_2
end

local var_0_89 = "solus"
local var_0_90 = "solus"
local var_0_91 = {
	"LUA",
	"A",
	"B"
}
local var_0_92 = {
	"Solid",
	"Fade",
	"Dynamic fade"
}
local var_0_93 = {}
local var_0_94 = true
local var_0_95
local var_0_96 = var_0_39("CONFIG", "Presets", "Watermark")
local var_0_97 = var_0_39("CONFIG", "Presets", "Spectators")
local var_0_98 = var_0_39("CONFIG", "Presets", "Hotkey list")
local var_0_99 = var_0_39("CONFIG", "Presets", "Anti-aimbot indication")
local var_0_100 = var_0_39("CONFIG", "Presets", "Frequency update information")
local var_0_101 = var_0_41("CONFIG", "Presets", "Solus Palette", var_0_92)
local var_0_102 = var_0_40("CONFIG", "Presets", "Solus Global color", 142, 165, 229, 85)
local var_0_103 = var_0_42("CONFIG", "Presets", "Fade offset", 1, 1000, 825, false, nil, 0.001)
local var_0_104 = var_0_42("CONFIG", "Presets", "Fade frequency", 1, 100, 10, false, nil, 0.01)
local var_0_105 = var_0_42("CONFIG", "Presets", "Fade split ratio", 0, 100, 100, false, nil, 0.01)
local var_0_106, var_0_107 = var_0_88(var_0_89, var_0_90, {
	watermark = {
		gc_state = true,
		beta_status = true,
		nickname = "",
		style = var_0_87(1, 4, 1, 1)
	},
	spectators = {
		avatars = true,
		auto_position = true
	},
	keybinds = {
		{
			ui_offset = 2,
			custom_name = "Legit aimbot",
			require = "",
			reference = {
				"legit",
				"aimbot",
				"Enabled"
			}
		},
		{
			ui_offset = 2,
			custom_name = "Legit triggerbot",
			require = "",
			reference = {
				"legit",
				"triggerbot",
				"Enabled"
			}
		},
		{
			ui_offset = 2,
			custom_name = "Rage aimbot",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Enabled"
			}
		},
		{
			ui_offset = 1,
			custom_name = "Safe point",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Force safe point"
			}
		},
		{
			ui_offset = 2,
			custom_name = "Damage override",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Minimum damage override"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Quick stop"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"rage",
				"other",
				"Quick peek assist"
			}
		},
		{
			ui_offset = 1,
			custom_name = "",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Force body aim"
			}
		},
		{
			ui_offset = 1,
			custom_name = "",
			require = "",
			reference = {
				"rage",
				"other",
				"Duck peek assist"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"rage",
				"aimbot",
				"Double tap"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"aa",
				"anti-aimbot angles",
				"Freestanding"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"aa",
				"other",
				"Slow motion"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"aa",
				"other",
				"On shot anti-aim"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"aa",
				"other",
				"Fake peek"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"movement",
				"Z-Hop"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"movement",
				"Pre-speed"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"movement",
				"Blockbot"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"movement",
				"Jump at edge"
			}
		},
		{
			ui_offset = 1,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"miscellaneous",
				"Last second defuse"
			}
		},
		{
			ui_offset = 1,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"miscellaneous",
				"Free look"
			}
		},
		{
			ui_offset = 2,
			custom_name = "",
			require = "",
			reference = {
				"misc",
				"miscellaneous",
				"Ping spike"
			}
		},
		{
			ui_offset = 2,
			custom_name = "Grenade release",
			require = "",
			reference = {
				"misc",
				"miscellaneous",
				"Automatic grenade release"
			}
		},
		{
			ui_offset = 1,
			custom_name = "Visuals",
			require = "",
			reference = {
				"visuals",
				"player esp",
				"Activation type"
			}
		}
	}
})

local function var_0_108()
	local var_31_0, var_31_1, var_31_2, var_31_3 = var_0_36(var_0_102)
	local var_31_4 = var_0_36(var_0_101)

	if var_31_4 ~= var_0_92[1] then
		local var_31_5 = var_0_36(var_0_105) / 100
		local var_31_6 = var_31_4 == var_0_92[3] and var_0_23() * (var_0_36(var_0_104) / 100) or var_0_36(var_0_103) / 1000

		var_31_0, var_31_1, var_31_2 = var_0_83(var_31_6, 1, 1, 1)
		var_31_0, var_31_1, var_31_2 = var_31_0 * var_31_5, var_31_1 * var_31_5, var_31_2 * var_31_5
	end

	return var_31_0, var_31_1, var_31_2, var_31_3
end

local function var_0_109(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = {
		{
			255,
			0,
			0
		},
		{
			237,
			27,
			3
		},
		{
			235,
			63,
			6
		},
		{
			229,
			104,
			8
		},
		{
			228,
			126,
			10
		},
		{
			220,
			169,
			16
		},
		{
			213,
			201,
			19
		},
		{
			176,
			205,
			10
		},
		{
			124,
			195,
			13
		}
	}

	arg_32_2 = (function(arg_33_0, arg_33_1, arg_33_2)
		local var_33_0 = arg_33_1 / (arg_33_1 < arg_33_0 and arg_33_1 or arg_33_0)

		arg_33_2 = arg_33_2 or arg_33_1

		local var_33_1 = arg_33_2 / var_33_0

		var_33_1 = var_33_1 >= 0 and var_0_25(var_33_1 + 0.5) or var_0_24(var_33_1 - 0.5)

		return var_33_1
	end)(arg_32_0, arg_32_1, #var_32_0)

	return var_32_0[arg_32_2 <= 1 and 1 or arg_32_2][1], var_32_0[arg_32_2 <= 1 and 1 or arg_32_2][2], var_32_0[arg_32_2 <= 1 and 1 or arg_32_2][3], arg_32_2
end

local var_0_110 = {
	watermark = function()
		local var_34_0 = var_0_84("a_watermark")
		local var_34_1 = {
			"gamesense",
			"gamesense.pub",
			"skeet",
			"skeet.cc"
		}
		local var_34_2 = var_0_56(var_0_69, "misc", "Settings", "Crash logs")
		local var_34_3 = var_0_28(" return MyPersonaAPI.GetName() ")
		local var_34_4 = var_0_28(" return MyPersonaAPI.IsConnectedToGC() ")
		local var_34_5 = var_0_74.typeof("void***")
		local var_34_6 = var_0_74.typeof("float(__thiscall*)(void*, int)")
		local var_34_7 = var_0_3("engine.dll", "VEngineClient014") or var_0_47("VEngineClient014 wasnt found", 2)
		local var_34_8 = var_0_74.cast(var_34_5, var_34_7) or var_0_47("rawivengineclient is nil", 2)
		local var_34_9 = var_0_74.cast("bool(__thiscall*)(void*)", var_34_8[0][26]) or var_0_47("is_in_game is nil")

		local function var_34_10()
			local var_35_0 = var_0_36(var_0_96)
			local var_35_1, var_35_2, var_35_3, var_35_4 = var_0_108()

			var_34_0.set_state(var_35_0)
			var_34_0.get(function(arg_36_0)
				local var_36_0 = var_0_106.watermark or {}
				local var_36_1 = var_36_0.nickname and var_0_62(var_36_0.nickname) or ""
				local var_36_2 = (var_36_0.suffix and var_0_62(var_36_0.suffix) or ""):gsub("beta", "")

				if var_36_0.beta_status and var_34_2 and (not var_36_2 or #var_36_2 < 1) then
					var_36_2 = "beta"
				end

				local var_36_3 = {
					var_0_10()
				}
				local var_36_4 = ("%02d:%02d:%02d"):format(var_36_3[1], var_36_3[2], var_36_3[3])
				local var_36_5 = not var_36_0.gc_state or var_34_4()
				local var_36_6 = not var_36_5 and "     " or ""
				local var_36_7 = #var_36_1 > 0 and var_36_1 or var_34_3()
				local var_36_8 = ("%s%s"):format(var_34_1[var_36_0.style and var_36_0.style.value or 1] or var_34_1[1], #var_36_2 > 0 and (" [%s]"):format(var_36_2) or "")
				local var_36_9 = ("%s%s | %s | %s"):format(var_36_6, var_36_8, var_36_7, var_36_4)

				if var_34_9(var_34_9) == true then
					local var_36_10 = client.latency() * 1000
					local var_36_11 = var_36_10 > 5 and (" | delay: %dms"):format(var_36_10) or ""

					var_36_9 = ("%s%s | %s%s | %s"):format(var_36_6, var_36_8, var_36_7, var_36_11, var_36_4)
				end

				local var_36_12 = 18
				local var_36_13 = var_0_59(nil, var_36_9) + 8
				local var_36_14 = var_0_8()
				local var_36_15 = 10 + 25 * arg_36_0
				local var_36_16 = var_36_14 - var_36_13 - 10

				if var_0_36(var_0_101) == var_0_92[1] then
					var_0_31(var_36_16, var_36_15, var_36_13, 2, var_35_1, var_35_2, var_35_3, 255)
				else
					var_0_29(var_36_16, var_36_15, var_36_13 / 2 + 1, 2, var_35_2, var_35_3, var_35_1, 255, var_35_1, var_35_2, var_35_3, 255, true)
					var_0_29(var_36_16 + var_36_13 / 2, var_36_15, var_36_13 - var_36_13 / 2, 2, var_35_1, var_35_2, var_35_3, 255, var_35_3, var_35_1, var_35_2, 255, true)
				end

				var_0_31(var_36_16, var_36_15 + 2, var_36_13, var_36_12, 17, 17, 17, var_35_4)
				var_0_60(var_36_16 + 4, var_36_15 + 4, 255, 255, 255, 255, "d", 0, var_36_9)

				if not var_36_5 then
					local var_36_17 = var_0_23() * 1.5

					if var_36_17 % 2 <= 1 then
						var_0_57(var_36_16 + 10, var_36_15 + 11, 89, 119, 239, 255, 5, 0, var_36_17 % 1, 2)
					else
						var_0_57(var_36_16 + 10, var_36_15 + 11, 89, 119, 239, 255, 5, var_36_17 % 1 * 370, 1 - var_36_17 % 1, 2)
					end
				end
			end)
		end

		var_0_9("paint_ui", var_34_10)
	end,
	spectators = function()
		local var_37_0 = {
			var_0_8()
		}
		local var_37_1 = {
			var_37_0[1] - var_37_0[1] * cvar.safezonex:get_float(),
			var_37_0[2] * cvar.safezoney:get_float()
		}
		local var_37_2 = var_0_78("Spectators", var_37_1[1] / 1.385, var_37_1[2] / 2)
		local var_37_3 = 0
		local var_37_4 = {}
		local var_37_5 = {}
		local var_37_6 = {}

		local function var_37_7()
			local var_38_0 = var_0_16()
			local var_38_1 = {}
			local var_38_2 = var_38_0

			for iter_38_0 = 1, var_0_51() do
				if var_0_15(iter_38_0) == "CCSPlayer" then
					local var_38_3 = var_0_19(iter_38_0, "m_iObserverMode")
					local var_38_4 = var_0_19(iter_38_0, "m_hObserverTarget")

					if var_38_4 ~= nil and var_38_4 <= 64 and not var_0_21(iter_38_0) and (var_38_3 == 4 or var_38_3 == 5) then
						if var_38_1[var_38_4] == nil then
							var_38_1[var_38_4] = {}
						end

						if iter_38_0 == var_38_0 then
							var_38_2 = var_38_4
						end

						var_0_33(var_38_1[var_38_4], iter_38_0)
					end
				end
			end

			return var_38_1, var_38_2
		end

		local function var_37_8()
			local var_39_0 = var_0_106.spectators or {}
			local var_39_1 = var_0_36(var_0_97)
			local var_39_2 = var_0_37()
			local var_39_3 = 8 * var_0_50()
			local var_39_4 = false
			local var_39_5 = 85
			local var_39_6 = var_0_16()
			local var_39_7, var_39_8 = var_37_7()

			for iter_39_0 = 1, 64 do
				var_37_6[iter_39_0] = {
					active = false,
					idx = iter_39_0
				}
			end

			if var_39_7[var_39_8] ~= nil then
				for iter_39_1, iter_39_2 in var_0_46(var_39_7[var_39_8]) do
					var_37_6[iter_39_2] = {
						idx = iter_39_2,
						active = (function()
							if iter_39_2 == var_39_6 then
								return false
							end

							return true
						end)(),
						avatar = (function()
							if not var_39_0.avatars then
								return nil
							end

							local var_41_0 = var_0_20(iter_39_2)
							local var_41_1 = var_0_76.get_steam_avatar(var_41_0)

							if var_41_0 == nil or var_41_1 == nil then
								return nil
							end

							if var_37_5[iter_39_2] == nil or var_37_5[iter_39_2].conts ~= var_41_1.contents then
								var_37_5[iter_39_2] = {
									conts = var_41_1.contents,
									texture = var_0_58(var_41_1.contents, var_41_1.width, var_41_1.height)
								}
							end

							return var_37_5[iter_39_2].texture
						end)()
					}
				end
			end

			for iter_39_3, iter_39_4 in var_0_46(var_37_6) do
				local var_39_9 = iter_39_4.idx
				local var_39_10 = var_0_18(iter_39_4.idx)

				if iter_39_4.active then
					var_39_4 = true

					if var_37_4[var_39_9] == nil then
						var_37_4[var_39_9] = {
							active = true,
							offset = 0,
							alpha = 0
						}
					end

					local var_39_11 = var_0_59(nil, var_39_10)

					var_37_4[var_39_9].active = true
					var_37_4[var_39_9].offset = var_39_11
					var_37_4[var_39_9].alpha = var_37_4[var_39_9].alpha + var_39_3
					var_37_4[var_39_9].avatar = iter_39_4.avatar
					var_37_4[var_39_9].name = var_39_10

					if var_37_4[var_39_9].alpha > 1 then
						var_37_4[var_39_9].alpha = 1
					end
				elseif var_37_4[var_39_9] ~= nil then
					var_37_4[var_39_9].active = false
					var_37_4[var_39_9].alpha = var_37_4[var_39_9].alpha - var_39_3

					if var_37_4[var_39_9].alpha <= 0 then
						var_37_4[var_39_9] = nil
					end
				end

				if var_37_4[var_39_9] ~= nil and var_39_5 < var_37_4[var_39_9].offset then
					var_39_5 = var_37_4[var_39_9].offset
				end
			end

			if var_39_2 and not var_39_4 then
				local var_39_12 = " "
				local var_39_13 = var_0_59(nil, var_39_12)

				var_39_4 = true
				var_39_5 = var_39_5 < var_39_13 and var_39_13 or var_39_5
				var_37_4[var_39_12] = {
					active = true,
					name = "",
					alpha = 1,
					offset = var_39_13
				}
			end

			local var_39_14 = "spectators"
			local var_39_15, var_39_16 = var_37_2:get()
			local var_39_17, var_39_18, var_39_19, var_39_20 = var_0_108()
			local var_39_21 = 23
			local var_39_22 = 55 + var_39_5
			local var_39_23 = 50
			local var_39_24 = var_39_22 - (var_39_0.avatars and 0 or 17)
			local var_39_25 = var_39_0.auto_position and var_39_15 + var_39_24 / 2 > ({
				var_0_8()
			})[1] / 2

			if var_0_36(var_0_101) == var_0_92[1] then
				var_0_31(var_39_15, var_39_16, var_39_24, 2, var_39_17, var_39_18, var_39_19, var_37_3 * 255)
			else
				var_0_29(var_39_15, var_39_16, var_39_24 / 2 + 1, 2, var_39_18, var_39_19, var_39_17, var_37_3 * 255, var_39_17, var_39_18, var_39_19, var_37_3 * 255, true)
				var_0_29(var_39_15 + var_39_24 / 2, var_39_16, var_39_24 - var_39_24 / 2, 2, var_39_17, var_39_18, var_39_19, var_37_3 * 255, var_39_19, var_39_17, var_39_18, var_37_3 * 255, true)
			end

			var_0_31(var_39_15, var_39_16 + 2, var_39_24, 18, 17, 17, 17, var_37_3 * var_39_20)
			var_0_60(var_39_15 - var_0_59(nil, var_39_14) / 2 + var_39_24 / 2, var_39_16 + 4, 255, 255, 255, var_37_3 * 255, "d", 0, var_39_14)

			for iter_39_5, iter_39_6 in var_0_46(var_37_4) do
				local var_39_26, var_39_27 = var_0_59(nil, iter_39_6.name)

				var_0_60(var_39_15 + (iter_39_6.avatar and not var_39_25 and var_39_27 or -5) + 10, var_39_16 + var_39_21, 255, 255, 255, var_37_3 * iter_39_6.alpha * 255, "d", 0, iter_39_6.name)

				if iter_39_6.avatar ~= nil then
					var_0_61(iter_39_6.avatar, var_39_15 + (var_39_25 and var_39_24 - 15 or 5), var_39_16 + var_39_21, var_39_27, var_39_27, 255, 255, 255, var_37_3 * iter_39_6.alpha * 255, "fd")
				end

				var_39_21 = var_39_21 + 15
			end

			var_37_2:drag(var_39_24, (3 + 15 * var_0_85(var_37_4)) * 2)

			if var_39_1 and var_0_85(var_37_4) > 0 and var_39_4 then
				var_37_3 = var_37_3 + var_39_3

				if var_37_3 > 1 then
					var_37_3 = 1
				end
			else
				var_37_3 = var_37_3 - var_39_3

				if var_37_3 < 0 then
					var_37_3 = 0
				end
			end

			if var_39_2 then
				var_37_4[" "] = nil
			end
		end

		var_0_9("paint", var_37_8)
	end,
	keybinds = function()
		local var_42_0 = {
			var_0_8()
		}
		local var_42_1 = {
			var_42_0[1] - var_42_0[1] * cvar.safezonex:get_float(),
			var_42_0[2] * cvar.safezoney:get_float()
		}
		local var_42_2 = var_0_78("Keybinds", var_42_1[1] / 1.385, var_42_1[2] / 2.5)
		local var_42_3 = 0
		local var_42_4 = {}
		local var_42_5 = {
			"holding",
			"toggled",
			"disabled"
		}
		local var_42_6 = {
			rage = {
				"weapon type",
				"aimbot",
				"other"
			},
			aa = {
				"anti-aimbot angles",
				"fake lag",
				"other"
			},
			legit = {
				"weapon type",
				"aimbot",
				"triggerbot",
				"other"
			},
			visuals = {
				"player esp",
				"colored models",
				"other esp",
				"effects"
			},
			misc = {
				"miscellaneous",
				"movement",
				"settings"
			},
			skins = {
				"knife options",
				"glove options",
				"weapon skin"
			},
			players = {
				"players",
				"adjustments"
			},
			config = {
				"presets",
				"lua"
			},
			lua = {
				"a",
				"b"
			}
		}

		local function var_42_7(...)
			if var_0_56(var_0_69, ...) then
				return true
			end
		end

		local function var_42_8(arg_44_0)
			local var_44_0 = {}
			local var_44_1 = arg_44_0.custom_name
			local var_44_2 = {
				var_0_69(var_0_72(arg_44_0.reference))
			}

			for iter_44_0 = 1, #var_44_2 do
				if iter_44_0 <= arg_44_0.ui_offset then
					var_44_0[iter_44_0] = var_44_2[iter_44_0]
				end
			end

			var_44_1 = var_44_1 and #var_0_62(var_44_1) > 0 and var_44_1 or nil
			arg_44_0.reference[3] = arg_44_0.ui_offset == 2 and var_0_63(var_44_0[1]) or arg_44_0.reference[3]
			var_0_93[var_44_1 or arg_44_0.reference[3] or "?"] = {
				reference = arg_44_0.reference,
				ui_offset = arg_44_0.ui_offset,
				custom_name = var_44_1,
				custom_file = arg_44_0.require,
				collected = var_44_0
			}

			return true
		end

		local function var_42_9(arg_45_0)
			local var_45_0 = arg_45_0.reference

			if var_45_0 == nil or var_42_6[var_45_0[1]:lower()] == nil or not var_0_86(var_42_6[var_45_0[1]:lower()], var_45_0[2]:lower()) then
				return false
			end

			if var_42_7(var_0_72(var_45_0)) then
				return var_42_8(arg_45_0)
			elseif var_0_56(require, arg_45_0.require) and var_42_7(var_0_72(var_45_0)) then
				return var_42_8(arg_45_0)
			else
				local var_45_1 = arg_45_0.require and #arg_45_0.require > 0 and arg_45_0.require .. ".lua" or "-"

				var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
				var_0_2(155, 220, 220, ("Unable to reference hotkey: %s [ %s ]"):format(var_45_0[3], var_45_1))
			end

			return false
		end

		local function var_42_10()
			local var_46_0 = var_0_36(var_0_98)
			local var_46_1 = var_0_37()
			local var_46_2 = 8 * var_0_50()
			local var_46_3 = false
			local var_46_4 = 66

			if var_0_94 == true then
				var_0_93 = {}
				var_42_4 = {}

				for iter_46_0, iter_46_1 in var_0_46(var_0_106.keybinds or {}) do
					var_42_9({
						reference = iter_46_1.reference,
						custom_name = iter_46_1.custom_name,
						ui_offset = iter_46_1.ui_offset or 1,
						require = iter_46_1.require
					})
				end

				var_0_94 = false
			end

			for iter_46_2, iter_46_3 in var_0_46(var_0_93) do
				local var_46_5 = true
				local var_46_6 = iter_46_3.collected
				local var_46_7 = var_0_85(var_46_6)
				local var_46_8 = {
					var_0_36(var_46_6[var_46_7])
				}

				if var_46_7 > 1 then
					var_46_5 = var_0_36(var_46_6[1])
				end

				if var_46_5 and var_46_8[2] ~= 0 and (var_46_8[2] == 3 and not var_46_8[1] or var_46_8[2] ~= 3 and var_46_8[1]) then
					var_46_3 = true

					if var_42_4[iter_46_2] == nil then
						var_42_4[iter_46_2] = {
							active = true,
							mode = "",
							offset = 0,
							alpha = 0
						}
					end

					local var_46_9 = var_0_59(nil, iter_46_2)

					var_42_4[iter_46_2].active = true
					var_42_4[iter_46_2].offset = var_46_9
					var_42_4[iter_46_2].mode = var_42_5[var_46_8[2]]
					var_42_4[iter_46_2].alpha = var_42_4[iter_46_2].alpha + var_46_2

					if var_42_4[iter_46_2].alpha > 1 then
						var_42_4[iter_46_2].alpha = 1
					end
				elseif var_42_4[iter_46_2] ~= nil then
					var_42_4[iter_46_2].active = false
					var_42_4[iter_46_2].alpha = var_42_4[iter_46_2].alpha - var_46_2

					if var_42_4[iter_46_2].alpha <= 0 then
						var_42_4[iter_46_2] = nil
					end
				end

				if var_42_4[iter_46_2] ~= nil and var_46_4 < var_42_4[iter_46_2].offset then
					var_46_4 = var_42_4[iter_46_2].offset
				end
			end

			if var_46_1 and not var_46_3 then
				local var_46_10 = "Menu toggled"
				local var_46_11 = var_0_59(nil, var_46_10)

				var_46_3 = true
				var_46_4 = var_46_4 < var_46_11 and var_46_11 or var_46_4
				var_42_4[var_46_10] = {
					active = true,
					mode = "~",
					alpha = 1,
					offset = var_46_11
				}
			end

			local var_46_12 = "keybinds"
			local var_46_13, var_46_14 = var_42_2:get()
			local var_46_15, var_46_16, var_46_17, var_46_18 = var_0_108()
			local var_46_19 = 23
			local var_46_20 = 75 + var_46_4
			local var_46_21 = 50

			if var_0_36(var_0_101) == var_0_92[1] then
				var_0_31(var_46_13, var_46_14, var_46_20, 2, var_46_15, var_46_16, var_46_17, var_42_3 * 255)
			else
				var_0_29(var_46_13, var_46_14, var_46_20 / 2 + 1, 2, var_46_16, var_46_17, var_46_15, var_42_3 * 255, var_46_15, var_46_16, var_46_17, var_42_3 * 255, true)
				var_0_29(var_46_13 + var_46_20 / 2, var_46_14, var_46_20 - var_46_20 / 2, 2, var_46_15, var_46_16, var_46_17, var_42_3 * 255, var_46_17, var_46_15, var_46_16, var_42_3 * 255, true)
			end

			var_0_31(var_46_13, var_46_14 + 2, var_46_20, 18, 17, 17, 17, var_42_3 * var_46_18)
			var_0_60(var_46_13 - var_0_59(nil, var_46_12) / 2 + var_46_20 / 2, var_46_14 + 4, 255, 255, 255, var_42_3 * 255, "d", 0, var_46_12)

			for iter_46_4, iter_46_5 in var_0_46(var_42_4) do
				local var_46_22 = "[" .. (iter_46_5.mode or "?") .. "]"

				var_0_60(var_46_13 + 5, var_46_14 + var_46_19, 255, 255, 255, var_42_3 * iter_46_5.alpha * 255, "d", 0, iter_46_4)
				var_0_60(var_46_13 + var_46_20 - var_0_59(nil, var_46_22) - 5, var_46_14 + var_46_19, 255, 255, 255, var_42_3 * iter_46_5.alpha * 255, "d", 0, var_46_22)

				var_46_19 = var_46_19 + 15
			end

			var_42_2:drag(var_46_20, (3 + 15 * var_0_85(var_42_4)) * 2)

			if var_46_0 and var_0_85(var_42_4) > 0 and var_46_3 then
				var_42_3 = var_42_3 + var_46_2

				if var_42_3 > 1 then
					var_42_3 = 1
				end
			else
				var_42_3 = var_42_3 - var_46_2

				if var_42_3 < 0 then
					var_42_3 = 0
				end
			end

			if var_46_1 then
				var_42_4["Menu toggled"] = nil
			end
		end

		var_0_95 = var_42_9

		var_0_9("paint", var_42_10)
	end,
	antiaim = function()
		local var_47_0 = var_0_84("a_wbantiaim")
		local var_47_1 = var_0_80(0, 2)
		local var_47_2 = var_0_80(0, 3)
		local var_47_3 = 0
		local var_47_4 = 0
		local var_47_5 = 0
		local var_47_6 = 0
		local var_47_7 = 0
		local var_47_8 = 0
		local var_47_9
		local var_47_10 = 0

		local function var_47_11(arg_48_0)
			local var_48_0 = var_0_16()

			if arg_48_0.chokedcommands == 0 then
				local var_48_1 = var_0_75(var_0_17(var_48_0))

				if var_47_9 ~= nil then
					var_47_8 = (var_48_1 - var_47_9):length2dsqr()

					var_0_81(var_47_2, var_47_8, true)
				end

				var_0_81(var_47_1, var_0_54(var_0_77.get_desync(1)), true)

				var_47_6 = var_47_7
				var_47_9 = var_48_1
			end

			var_47_10 = var_0_82(var_47_2) > 3200 and 1 or var_0_77.get_tickbase_shifting() > 0 and 2 or 0
			var_47_7 = arg_48_0.chokedcommands
		end

		local function var_47_12()
			var_47_0.set_state(false)

			local var_49_0 = var_0_16()

			if var_49_0 == nil or not var_0_21(var_49_0) then
				return
			end

			local var_49_1 = var_0_36(var_0_99)
			local var_49_2, var_49_3, var_49_4, var_49_5 = var_0_108()

			var_47_0.set_state(var_49_1)
			var_47_0.get(function(arg_50_0)
				local var_50_0 = {
					var_0_36(var_0_102)
				}
				local var_50_1 = ""
				local var_50_2 = false
				local var_50_3 = 150
				local var_50_4 = 150
				local var_50_5 = 150
				local var_50_6 = var_0_50() * 3.75
				local var_50_7 = 1200 + var_0_26(0, var_0_82(var_47_2) - 3800)
				local var_50_8 = var_0_54(var_0_27(var_47_8 - 3800, var_50_7) / var_50_7 * 100)

				if var_47_4 ~= var_50_8 and var_47_5 < var_0_23() then
					var_47_5 = var_0_23() + 0.005
					var_47_4 = var_47_4 + (var_50_8 < var_47_4 and -1 or 1)
				end

				var_47_3 = var_47_3 + (var_47_10 == 1 and var_50_6 or -var_50_6)
				var_47_3 = var_47_3 > 1 and 1 or var_47_3
				var_47_3 = var_47_3 < 0 and 0 or var_47_3

				if var_47_10 == 2 then
					var_50_1, var_47_3, var_47_4 = " | SHIFTING", 0, 0
					var_50_3, var_50_4, var_50_5 = 228, 126, 10
				elseif var_47_3 > 0.1 then
					var_50_1 = " | dst:          "
				end

				local var_50_9 = ("FL: %s%s"):format((function()
					if var_0_73(var_47_6) < 10 then
						return "  " .. var_47_6
					end

					return var_47_6
				end)(), var_50_1)
				local var_50_10 = 17
				local var_50_11 = var_0_59(nil, var_50_9) + 8
				local var_50_12 = var_0_8()
				local var_50_13 = 10 + 25 * arg_50_0
				local var_50_14 = var_50_12 - var_50_11 - 10

				var_0_29(var_50_14, var_50_13 + var_50_10, var_50_11 / 2, 1, 0, 0, 0, 25, var_50_3, var_50_4, var_50_5, 255, true)
				var_0_29(var_50_14 + var_50_11 / 2, var_50_13 + var_50_10, var_50_11 - var_50_11 / 2, 1, var_50_3, var_50_4, var_50_5, 255, 0, 0, 0, 25, true)
				var_0_31(var_50_14, var_50_13, var_50_11, var_50_10, 17, 17, 17, var_49_5)
				var_0_60(var_50_14 + 4, var_50_13 + 2, 255, 255, 255, 255, "d", 0, var_50_9)

				if var_47_3 > 0 then
					var_0_29(var_50_14 + var_50_11 - var_0_59(nil, " | dst: ") + 2, var_50_13 + 6, var_0_27(100, var_47_4) / 100 * 24, 5, var_50_0[1], var_50_0[2], var_50_0[3], var_47_3 * 220, var_50_0[1], var_50_0[2], var_50_0[3], var_47_3 * 25, true)
				end

				local var_50_15 = var_0_77.get_balance_adjust()
				local var_50_16, var_50_17, var_50_18 = var_0_109(var_0_54(var_0_77.get_desync()), 30)
				local var_50_19 = (var_50_15.next_update - var_0_49()) / 1.1 * 1
				local var_50_20 = var_50_15.updating and var_50_19 >= 0 and "     " or ""
				local var_50_21 = ("%sFAKE (%.1f°)"):format(var_50_20, var_0_82(var_47_1))
				local var_50_22 = 18
				local var_50_23 = var_0_59(nil, var_50_21) + 8
				local var_50_24 = {
					var_50_16 - var_50_16 / 100 * 50,
					var_50_17 - var_50_17 / 100 * 50,
					var_50_18 - var_50_18 / 100 * 50
				}

				var_0_29(var_50_14 - var_50_23 - 6, var_50_13, 2, var_50_22 / 2, var_50_24[1], var_50_24[2], var_50_24[3], 0, var_50_16, var_50_17, var_50_18, 255, false)
				var_0_29(var_50_14 - var_50_23 - 6, var_50_13 + var_50_22 / 2, 2, var_50_22 / 2, var_50_16, var_50_17, var_50_18, 255, var_50_24[1], var_50_24[2], var_50_24[3], 0, false)
				var_0_29(var_50_14 - var_50_23 - 4, var_50_13, var_50_23 / 2, var_50_22, 17, 17, 17, 25, 17, 17, 17, var_49_5, true)
				var_0_29(var_50_14 - var_50_23 - 4 + var_50_23 / 2, var_50_13, var_50_23 / 2, var_50_22, 17, 17, 17, var_49_5, 17, 17, 17, 25, true)
				var_0_60(var_50_14 - var_50_23, var_50_13 + 2, 255, 255, 255, 255, "d", 0, var_50_21)

				if var_50_15.updating and var_50_19 >= 0 then
					var_0_57(var_50_14 - var_50_23 + 6, var_50_13 + 8.5, 89, 119, 239, 255, 5, 0, var_50_19, 2)
				end
			end)
		end

		var_0_9("setup_command", var_47_11)
		var_0_9("paint_ui", var_47_12)
	end,
	ilstate = function()
		local var_52_0 = var_0_84("a_winput")
		local var_52_1 = var_0_79()

		local function var_52_2(arg_53_0)
			if arg_53_0 < 1 then
				return ("%.2f"):format(arg_53_0)
			end

			if arg_53_0 < 10 then
				return ("%.1f"):format(arg_53_0)
			end

			return ("%d"):format(arg_53_0)
		end

		local var_52_3 = var_0_5("engine.dll", "\xFF\xE1")
		local var_52_4 = var_0_74.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, const char*)", var_52_3)
		local var_52_5 = var_0_74.cast("uint32_t(__fastcall*)(unsigned int, unsigned int, uint32_t, const char*)", var_52_3)
		local var_52_6 = var_0_74.cast("uint32_t**", var_0_74.cast("uint32_t", var_0_5("engine.dll", "\xFF\x15\xCC\xCC\xCC̣\xCC\xCC\xCC\xCC\xEB\x05")) + 2)[0][0]
		local var_52_7 = var_0_74.cast("uint32_t**", var_0_74.cast("uint32_t", var_0_5("engine.dll", "\xFF\x15\xCC\xCC\xCC̅\xC0t\v")) + 2)[0][0]
		local var_52_8 = (function(arg_54_0, arg_54_1, arg_54_2)
			local var_54_0 = var_0_74.typeof(arg_54_2)

			return function(...)
				return var_0_74.cast(var_54_0, var_52_3)(var_52_5(var_52_6, 0, var_52_4(var_52_7, 0, arg_54_0), arg_54_1), 0, ...)
			end
		end)("user32.dll", "EnumDisplaySettingsA", "int(__fastcall*)(unsigned int, unsigned int, unsigned int, unsigned long, void*)")
		local var_52_9 = var_0_74.new("struct { char pad_0[120]; unsigned long dmDisplayFrequency; char pad_2[32]; }[1]")

		local function var_52_10(arg_56_0, arg_56_1)
			local var_56_0 = {}

			for iter_56_0 = 1, arg_56_1 do
				var_56_0[iter_56_0] = arg_56_0
			end

			return var_56_0
		end

		local function var_52_11(arg_57_0, arg_57_1, arg_57_2)
			local var_57_0 = arg_57_0

			if arg_57_2 or var_57_0[#var_57_0] ~= arg_57_1 then
				var_0_33(var_57_0, arg_57_1)
				var_0_34(var_57_0, 1)
			end

			arg_57_0 = var_57_0
		end

		local function var_52_12(arg_58_0)
			local var_58_0 = 0
			local var_58_1 = 0

			for iter_58_0, iter_58_1 in var_0_46(arg_58_0) do
				var_58_1 = var_58_1 + iter_58_1
				var_58_0 = var_58_0 + 1
			end

			return var_58_1 / var_58_0
		end

		local var_52_13 = var_0_11()
		local var_52_14 = var_52_10(0, 90)
		local var_52_15 = var_52_10(0, 30)
		local var_52_16 = 0
		local var_52_17 = 0

		local function var_52_18()
			var_52_13 = var_0_11()
		end

		local function var_52_19()
			var_52_11(var_52_14, var_0_11() - var_52_13)
		end

		var_0_9("post_render", var_52_18)
		var_0_9("pre_render", var_52_19)
		var_52_8(0, 4294967295, var_52_9[0])

		local function var_52_20()
			var_52_16 = 0.9 * var_52_16 + 0.09999999999999998 * var_0_48()

			var_52_11(var_52_15, var_0_54(var_52_17 - 1 / var_52_16), true)

			var_52_17 = 1 / var_52_16

			local var_61_0 = var_0_36(var_0_100)
			local var_61_1, var_61_2, var_61_3, var_61_4 = var_0_108()

			var_52_0.set_state(var_61_0)
			var_52_0.get(function(arg_62_0)
				local var_62_0 = var_52_12(var_52_14)
				local var_62_1 = var_0_73(var_52_9[0].dmDisplayFrequency)
				local var_62_2 = ("%sms / %dhz"):format(var_52_2(var_62_0), var_62_1)
				local var_62_3 = {
					var_0_109(15 - var_62_0, 15)
				}
				local var_62_4 = 18
				local var_62_5 = var_0_59(nil, var_62_2) + 8
				local var_62_6 = var_0_8()
				local var_62_7 = 10 + 25 * arg_62_0
				local var_62_8 = var_62_6 - var_62_5 - 10

				var_0_29(var_62_8, var_62_7 + var_62_4, var_62_5 / 2, 1, 0, 0, 0, 25, var_62_3[1], var_62_3[2], var_62_3[3], 255, true)
				var_0_29(var_62_8 + var_62_5 / 2, var_62_7 + var_62_4, var_62_5 - var_62_5 / 2, 1, var_62_3[1], var_62_3[2], var_62_3[3], 255, 0, 0, 0, 25, true)
				var_0_31(var_62_8, var_62_7, var_62_5, var_62_4, 17, 17, 17, var_61_4)
				var_0_60(var_62_8 + 4, var_62_7 + 2, 255, 255, 255, 255, "d", 0, var_62_2)

				local var_62_9 = "IO | "
				local var_62_10 = var_62_9 .. "       "
				local var_62_11 = 18
				local var_62_12 = var_0_59(nil, var_62_10) + 8
				local var_62_13 = var_0_59(nil, var_62_9) + 4
				local var_62_14, var_62_15, var_62_16 = var_0_36(var_0_102)
				local var_62_17 = {
					var_62_0,
					1,
					3,
					var_52_12(var_52_15) / 4,
					0
				}
				local var_62_18 = var_0_27(var_0_72(var_62_17))
				local var_62_19 = var_0_26(var_0_72(var_62_17))

				var_0_31(var_62_8 - var_62_12 - 4, var_62_7, var_62_12, var_62_11, 17, 17, 17, var_61_4)
				var_0_60(var_62_8 - var_62_12, var_62_7 + 2, 255, 255, 255, 255, "d", 0, var_62_10)
				var_52_1:draw_histogram(var_62_17, 0, var_62_19, #var_62_17, {
					thickness = 1,
					bDrawPeeks = false,
					sDrawBar = "gradient_fadein",
					x = var_62_8 - var_62_12 - 4 + var_62_13,
					y = var_62_7 + 4,
					w = var_62_12 - var_62_13 - 4,
					h = var_62_11 - 8,
					clr_1 = {
						var_62_14,
						var_62_15,
						var_62_16,
						255
					},
					clr_2 = {
						0,
						127,
						255,
						255
					}
				}, false)
			end)
		end

		var_0_9("paint_ui", var_52_20)
	end,
	editor = function()
		local function var_63_0()
			local var_64_0 = var_0_39(var_0_91[1], var_0_91[2], "Solus Data editor")
			local var_64_1 = {}
			local var_64_2 = {}

			local function var_64_3()
				return
			end

			for iter_64_0, iter_64_1 in var_0_46(var_0_106) do
				if iter_64_0 ~= "keybinds" then
					var_0_33(var_64_1, var_0_66(var_0_91[1], var_0_91[2], iter_64_0:upper()))

					for iter_64_2, iter_64_3 in var_0_46(iter_64_1) do
						local var_64_4 = var_0_55(iter_64_3)
						local var_64_5 = {
							string = function()
								local var_66_0
								local var_66_1 = var_0_66(var_0_91[1], var_0_91[2], ("\t  > %s \n %s:%s"):format(iter_64_2, iter_64_0, iter_64_2))
								local var_66_2 = var_0_68(var_0_91[1], var_0_91[2], ("%s:%s"):format(iter_64_0, iter_64_2))

								var_0_43(var_66_2, var_0_106[iter_64_0][iter_64_2])

								local function var_66_3()
									var_0_106[iter_64_0][iter_64_2] = var_0_36(var_66_2)

									var_0_4(0.01, function()
										var_66_3()
									end)
								end

								var_66_3()

								return {
									var_66_1,
									var_66_2
								}
							end,
							boolean = function()
								local var_69_0 = var_0_39(var_0_91[1], var_0_91[2], ("\t  > %s \n %s:%s"):format(iter_64_2, iter_64_0, iter_64_2))

								var_0_43(var_69_0, iter_64_3)
								var_0_70(var_69_0, function(arg_70_0)
									var_0_106[iter_64_0][iter_64_2] = var_0_36(arg_70_0)
								end)

								return {
									var_69_0
								}
							end,
							table = function()
								local var_71_0 = var_0_42(var_0_91[1], var_0_91[2], ("\t  > %s \n %s:%s"):format(iter_64_2, iter_64_0, iter_64_2), iter_64_3.min, iter_64_3.max, iter_64_3.init_val, true, nil, iter_64_3.scale)

								var_0_43(var_71_0, iter_64_3.value or iter_64_3.init_val)
								var_0_70(var_71_0, function(arg_72_0)
									var_0_106[iter_64_0][iter_64_2].value = var_0_36(arg_72_0)
								end)

								return {
									var_71_0
								}
							end
						}

						if var_64_5[var_64_4] ~= nil then
							for iter_64_4, iter_64_5 in var_0_46(var_64_5[var_64_4]()) do
								var_0_33(var_64_1, iter_64_5)
							end
						end
					end
				end
			end

			local function var_64_6()
				var_0_43(var_64_0, false)

				for iter_73_0, iter_73_1 in var_0_46(var_64_1) do
					var_64_2[iter_73_1] = var_0_36(iter_73_1)
				end
			end

			local function var_64_7()
				var_0_43(var_64_0, false)

				for iter_74_0, iter_74_1 in var_0_46(var_64_1) do
					if var_64_2[iter_74_1] ~= nil then
						var_0_43(iter_74_1, var_64_2[iter_74_1])

						var_64_2[iter_74_1] = nil
					end
				end
			end

			var_0_9("pre_config_save", function()
				var_64_6()
			end)
			var_0_9("post_config_save", function()
				var_64_7()
			end)
			var_0_9("pre_config_load", function()
				var_64_6()
			end)
			var_0_9("post_config_load", function()
				var_64_7()
			end)

			local function var_64_8()
				local var_79_0 = var_0_36(var_64_0)

				for iter_79_0, iter_79_1 in var_0_46(var_64_1) do
					var_0_44(iter_79_1, var_79_0)
				end
			end

			var_0_70(var_64_0, var_64_8)
			var_64_8()
		end

		local function var_63_1()
			local function var_80_0(arg_81_0)
				local var_81_0 = {}

				for iter_81_0 in var_0_46(arg_81_0) do
					var_0_33(var_81_0, iter_81_0)
				end

				var_0_35(var_81_0, function(arg_82_0, arg_82_1)
					return arg_82_0:lower() < arg_82_1:lower()
				end)

				local var_81_1 = {
					"» Create new keybind"
				}

				for iter_81_1 = 1, #var_81_0 do
					var_0_33(var_81_1, var_81_0[iter_81_1])
				end

				return var_81_1
			end

			local function var_80_1()
				local var_83_0 = {}

				for iter_83_0, iter_83_1 in var_0_46(var_0_106.keybinds) do
					local var_83_1 = iter_83_1.custom_name

					var_83_1 = var_83_1 and #var_0_62(var_83_1) > 0 and var_83_1 or nil
					var_83_0[var_83_1 or iter_83_1.reference[3] or "?"] = {
						hotkey_id = iter_83_0,
						reference = iter_83_1.reference,
						custom_name = iter_83_1.custom_name,
						ui_offset = iter_83_1.ui_offset,
						require = iter_83_1.require
					}
				end

				return var_83_0
			end

			local var_80_2
			local var_80_3
			local var_80_4, var_80_5 = {
				ui_offset = 1,
				custom_name = "",
				require = "",
				reference = {
					"",
					"",
					""
				}
			}, {
				"Basic",
				"Extended"
			}
			local var_80_6 = var_80_1()
			local var_80_7 = var_80_0(var_80_6)
			local var_80_8 = var_0_39(var_0_91[1], var_0_91[2], "Solus Hotkey editor")
			local var_80_9 = var_0_67(var_0_91[1], var_0_91[2], "Solus Keybinds", var_80_7)
			local var_80_10 = {
				var_0_39(var_0_91[1], var_0_91[2], "Custom hotkey"),
				var_0_66(var_0_91[1], var_0_91[2], "File name (without \".lua\")"),
				var_0_68(var_0_91[1], var_0_91[2], "solus:keybinds:required_file")
			}
			local var_80_11 = {
				var_0_39(var_0_91[1], var_0_91[2], "Custom name"),
				var_0_66(var_0_91[1], var_0_91[2], "Original name"),
				var_0_68(var_0_91[1], var_0_91[2], "solus:keybinds:custom_name")
			}
			local var_80_12 = {
				var_0_66(var_0_91[1], var_0_91[2], "Reference"),
				var_0_68(var_0_91[1], var_0_91[2], "solus:keybinds:reference1"),
				var_0_68(var_0_91[1], var_0_91[2], "solus:keybinds:reference2"),
				var_0_68(var_0_91[1], var_0_91[2], "solus:keybinds:reference3")
			}
			local var_80_13 = {
				var_0_41(var_0_91[1], var_0_91[2], "Hotkey type", var_80_5),
				var_0_65(var_0_91[1], var_0_91[3], ("Example: %s"):format(var_80_5[1])),
				var_0_39(var_0_91[1], var_0_91[3], ("Example: %s"):format(var_80_5[2])),
				var_0_65(var_0_91[1], var_0_91[3], " ", true),
				var_0_41(var_0_91[1], var_0_91[3], ("Example: %s"):format(var_80_5[2]), "-"),
				var_0_65(var_0_91[1], var_0_91[3], " ", true)
			}
			local var_80_14 = var_0_64(var_0_91[1], var_0_91[2], "Save Changes", function()
				local var_84_0 = var_80_7[var_0_36(var_80_9) + 1] or var_80_7[1]
				local var_84_1 = var_0_36(var_80_13[1]) == var_80_5[2] and 2 or 1
				local var_84_2 = {
					var_0_36(var_80_12[2]):lower(),
					var_0_36(var_80_12[3]):lower(),
					var_0_36(var_80_12[4])
				}
				local var_84_3 = var_0_36(var_80_11[1]) and var_0_36(var_80_11[3]) or ""

				if var_84_0 ~= var_80_7[1] then
					local var_84_4 = var_80_6[var_84_0]

					if var_84_4 ~= nil then
						var_0_106.keybinds[var_84_4.hotkey_id] = {
							ui_offset = var_84_1,
							reference = var_84_2,
							require = var_0_36(var_80_10[1]) and var_0_36(var_80_10[3]):lower() or "",
							custom_name = var_84_3
						}
					end
				else
					local var_84_5 = true
					local var_84_6 = {
						ui_offset = var_84_1,
						reference = var_84_2,
						require = var_0_36(var_80_10[1]) and var_0_36(var_80_10[3]) or "",
						custom_name = var_84_3
					}
					local var_84_7 = {
						var_84_6.reference[1]:lower(),
						var_84_6.reference[2]:lower(),
						var_84_6.reference[3]:lower()
					}

					for iter_84_0, iter_84_1 in var_0_46(var_0_106.keybinds) do
						local var_84_8 = {
							iter_84_1.reference[1]:lower(),
							iter_84_1.reference[2]:lower(),
							iter_84_1.reference[3]:lower()
						}

						if var_84_8[1] == var_84_7[1] and var_84_8[2] == var_84_7[2] and var_84_8[3] == var_84_7[3] then
							var_84_5 = false

							break
						end
					end

					if var_84_5 and var_0_95(var_84_6) then
						var_0_106.keybinds[#var_0_106.keybinds + 1] = var_84_6

						var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
						var_0_2(255, 255, 255, "Created hotkey \x01\x00")
						var_0_2(155, 220, 220, ("[ %s ]"):format(var_0_32(var_84_6.reference, " > ")))
					end

					if not var_84_5 then
						var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
						var_0_2(255, 255, 255, "Could'nt create hotkey \x01\x00")
						var_0_2(155, 220, 220, "[ keybind already exists ]")
						var_0_47()
					end
				end

				var_0_94 = true
				var_80_6 = var_80_1()
				var_80_7 = var_80_0(var_80_6)

				var_0_71(var_80_9, var_80_7)
				var_80_3(var_80_9)
				var_80_2()
			end)
			local var_80_15 = var_0_64(var_0_91[1], var_0_91[2], "Delete Hotkey", function()
				local var_85_0 = var_80_7[var_0_36(var_80_9) + 1] or var_80_7[1]

				if var_85_0 ~= var_80_7[1] then
					local var_85_1 = var_80_6[var_85_0]

					var_0_106.keybinds[var_85_1.hotkey_id] = nil

					local var_85_2 = {}

					for iter_85_0 = 1, #var_0_106.keybinds do
						if var_0_106.keybinds[iter_85_0] ~= nil then
							var_85_2[#var_85_2 + 1] = var_0_106.keybinds[iter_85_0]
						end
					end

					var_0_106.keybinds = var_85_2

					var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
					var_0_2(255, 255, 255, "Removed hotkey \x01\x00")
					var_0_2(155, 220, 220, ("[ %s ]"):format(var_0_32(var_85_1.reference, " > ")))

					var_0_94 = true
					var_80_6 = var_80_1()
					var_80_7 = var_80_0(var_80_6)

					var_0_71(var_80_9, var_80_7)
					var_80_3(var_80_9)
					var_80_2()
				end
			end)

			function var_80_2()
				local var_86_0 = var_0_36(var_80_8)
				local var_86_1 = var_0_36(var_80_9) == 0

				var_0_44(var_80_9, var_86_0)
				var_0_44(var_80_10[1], var_86_0 and var_86_1)
				var_0_44(var_80_10[2], var_86_0 and var_0_36(var_80_10[1]) and var_86_1)
				var_0_44(var_80_10[3], var_86_0 and var_0_36(var_80_10[1]) and var_86_1)
				var_0_44(var_80_11[1], var_86_0)
				var_0_44(var_80_11[2], var_86_0 and var_0_36(var_80_11[1]) and not var_86_1)
				var_0_44(var_80_11[3], var_86_0 and var_0_36(var_80_11[1]))
				var_0_44(var_80_12[1], var_86_0)
				var_0_44(var_80_12[2], var_86_0 and var_86_1)
				var_0_44(var_80_12[3], var_86_0 and var_86_1)
				var_0_44(var_80_12[4], var_86_0 and var_86_1)
				var_0_44(var_80_14, var_86_0)
				var_0_44(var_80_15, var_86_0 and not var_86_1)

				for iter_86_0 = 1, #var_80_13 do
					var_0_44(var_80_13[iter_86_0], var_86_0 and var_86_1)
				end
			end

			function var_80_3(arg_87_0)
				local var_87_0 = var_80_6
				local var_87_1 = var_80_7[var_0_36(arg_87_0) + 1] or var_80_7[1]
				local var_87_2 = var_87_0[var_87_1]

				if var_87_2 == nil then
					var_87_2 = var_80_4
				end

				local var_87_3 = {
					require = {
						#var_87_2.require > 0,
						var_87_2.require or ""
					},
					custom_name = {
						var_87_2.custom_name ~= "",
						("Original name: %s"):format(var_87_2.reference[3]),
						var_87_2.custom_name
					},
					reference = {
						("Reference: %s > %s (%d)"):format(var_87_2.reference[1], var_87_2.reference[2], var_87_2.ui_offset),
						var_87_2.reference[1],
						var_87_2.reference[2],
						var_87_2.reference[3]
					},
					ui_offset = var_87_2.ui_offset
				}

				var_0_43(var_80_12[1], var_87_1 ~= var_80_7[1] and var_87_3.reference[1] or "Reference")
				var_0_43(var_80_10[1], var_87_3.require[1])
				var_0_43(var_80_10[3], var_87_3.require[2])
				var_0_43(var_80_11[1], var_87_3.custom_name[1])
				var_0_43(var_80_11[2], var_87_3.custom_name[2])
				var_0_43(var_80_11[3], var_87_3.custom_name[3])
				var_0_43(var_80_12[2], var_87_3.reference[2])
				var_0_43(var_80_12[3], var_87_3.reference[3])
				var_0_43(var_80_12[4], var_87_3.reference[4])
				var_0_43(var_80_13[1], var_80_5[var_87_3.ui_offset])
				var_80_2()
			end

			var_0_9("pre_config_save", function()
				var_0_43(var_80_8, false)
			end)
			var_0_9("post_config_load", function()
				var_0_43(var_80_8, false)
			end)
			var_0_70(var_80_8, var_80_2)
			var_0_70(var_80_9, var_80_3)
			var_0_70(var_80_10[1], var_80_2)
			var_0_70(var_80_11[1], var_80_2)
			var_80_2()

			return var_80_8
		end

		var_0_9("console_input", function(arg_90_0)
			local var_90_0 = arg_90_0:gsub(" ", "")
			local var_90_1 = {
				["solus:watermark:set_suffix"] = function()
					var_0_106.watermark.suffix = ""

					var_0_14(var_0_90, var_0_106)
					var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
					var_0_2(155, 220, 220, "Suffix is now active")
					var_0_7()
				end,
				["solus:watermark:unset_suffix"] = function()
					var_0_106.watermark.suffix = nil

					var_0_14(var_0_90, var_0_106)
					var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
					var_0_2(155, 220, 220, "Suffix is now inactive")
					var_0_7()
				end,
				["solus:reset"] = function()
					for iter_93_0 in var_0_46(var_0_106) do
						var_0_106[iter_93_0] = iter_93_0 == "keybinds" and var_0_106.keybinds or {}
					end

					var_0_14(var_0_90, var_0_106)
					var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
					var_0_2(255, 0, 0, "Wiping data sectors")
					var_0_7()
				end,
				["solus:keybinds:reset"] = function()
					var_0_106.keybinds = var_0_107.keybinds

					var_0_14(var_0_90, var_0_106)
					var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
					var_0_2(255, 0, 0, "Wiping keybinds sector")
					var_0_7()
				end
			}

			if var_90_1[var_90_0] ~= nil then
				var_90_1[var_90_0]()

				return true
			end
		end)
		var_63_0()
		var_63_1()
	end
}

var_0_110.watermark()
var_0_110.spectators()
var_0_110.keybinds()
var_0_110.antiaim()
var_0_110.ilstate()
var_0_4(0.1, var_0_110.editor)
var_0_9("shutdown", function()
	var_0_14(var_0_90, var_0_106)
end)

local function var_0_111()
	local var_96_0 = var_0_36(var_0_101)

	var_0_44(var_0_103, var_96_0 ~= var_0_92[1] and var_96_0 == var_0_92[2])
	var_0_44(var_0_104, var_96_0 ~= var_0_92[1] and var_96_0 == var_0_92[3])
	var_0_44(var_0_105, var_96_0 ~= var_0_92[1])
end

var_0_70(var_0_101, var_0_111)
var_0_111()

local var_0_112 = database.read("solusfix")

if var_0_112 == nil or var_0_112 ~= 1 then
	database.write("solusfix", 1)

	var_0_106.keybinds = var_0_107.keybinds

	var_0_14(var_0_90, var_0_106)
	var_0_2(216, 181, 121, ("[%s] \x01\x00"):format(var_0_89))
	var_0_2(255, 0, 0, "Wiping keybinds sector")
	var_0_7()
end
