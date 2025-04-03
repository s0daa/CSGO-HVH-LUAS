local var_0_0 = bit.band
local var_0_1 = client.camera_angles
local var_0_2 = client.color_log
local var_0_3 = client.exec
local var_0_4 = client.eye_position
local var_0_5 = client.key_state
local var_0_6 = client.register_esp_flag
local var_0_7 = client.screen_size
local var_0_8 = client.trace_line
local var_0_9 = client.userid_to_entindex
local var_0_10 = entity.get_game_rules
local var_0_11 = entity.get_local_player
local var_0_12 = entity.get_origin
local var_0_13 = entity.get_prop
local var_0_14 = entity.is_alive
local var_0_15 = globals.curtime
local var_0_16 = globals.frametime
local var_0_17 = globals.mapname
local var_0_18 = globals.tickinterval
local var_0_19 = json.parse
local var_0_20 = json.stringify
local var_0_21 = math.abs
local var_0_22 = math.atan2
local var_0_23 = math.ceil
local var_0_24 = math.cos
local var_0_25 = math.deg
local var_0_26 = math.floor
local var_0_27 = math.min
local var_0_28 = math.rad
local var_0_29 = math.sin
local var_0_30 = math.sqrt
local var_0_31 = pairs
local var_0_32 = renderer.indicator
local var_0_33 = renderer.line
local var_0_34 = renderer.text
local var_0_35 = renderer.world_to_screen
local var_0_36 = string.format
local var_0_37 = string.len
local var_0_38 = type
local var_0_39 = ui.get
local var_0_40 = ui.new_button
local var_0_41 = ui.new_checkbox
local var_0_42 = ui.new_combobox
local var_0_43 = ui.new_hotkey
local var_0_44 = ui.new_multiselect
local var_0_45 = ui.new_slider
local var_0_46 = ui.new_textbox
local var_0_47 = ui.reference
local var_0_48 = tostring
local var_0_49 = readfile
local var_0_50 = ui.set
local var_0_51 = ui.set_callback
local var_0_52 = writefile
local var_0_53 = ipairs
local var_0_54 = ui.set_visible
local var_0_55 = require("vector")

local function var_0_56(...)
	local var_1_0 = {
		...
	}
	local var_1_1 = {
		255,
		255,
		255
	}
	local var_1_2
	local var_1_3 = "No text"
	local var_1_4 = #var_1_0

	for iter_1_0, iter_1_1 in var_0_31(var_1_0) do
		if var_0_38(iter_1_1) == "table" then
			iter_1_1[1] = iter_1_1[1] or 255
			iter_1_1[2] = iter_1_1[2] or 255
			iter_1_1[3] = iter_1_1[3] or 255
			var_1_1 = iter_1_1
		else
			local var_1_5 = iter_1_1

			var_0_2(var_1_1[1], var_1_1[2], var_1_1[3], var_1_5 .. (iter_1_0 == var_1_4 and "" or "\x00"))
		end
	end

	return var_0_56
end

local var_0_57 = false
local var_0_58 = false
local var_0_59
local var_0_60 = false
local var_0_61 = {
	ideal_yaw = 0,
	last_yaw = 0
}
local var_0_62 = {
	["Left SW"] = {
		-450,
		450,
		90
	},
	["Right SW"] = {
		-450,
		450,
		-90
	},
	BW = {
		-450,
		450,
		180
	},
	W = {
		-450,
		450,
		90,
		-90
	},
	A = {
		-450,
		450,
		0,
		180
	},
	S = {
		-450,
		450,
		180,
		0
	},
	D = {
		-450,
		450,
		-90,
		90
	}
}
local var_0_63 = {
	["1"] = "Started Recording",
	["2"] = "Stopped Recording",
	["0"] = "Cleared Recording"
}
local var_0_64 = {
	["0"] = "Stopped Playback",
	["1"] = "Started Playback"
}
local var_0_65
local var_0_66
local var_0_67 = {}
local var_0_68 = 0
local var_0_69 = 0
local var_0_70 = false
local var_0_71 = false
local var_0_72 = 0
local var_0_73
local var_0_74 = {
	var_0_7()
}
local var_0_75 = var_0_74[1] / 2
local var_0_76 = var_0_74[2] / 2
local var_0_77 = var_0_74[2] / 10
local var_0_78 = var_0_41("Misc", "Movement", "Crescent")
local var_0_79 = var_0_44("Misc", "Movement", "\nIndicators", {
	"Recorder",
	"Bhop Style",
	"1HP Flash"
})
local var_0_80 = var_0_43("Misc", "Movement", "Jumpbug")
local var_0_81 = var_0_47("MISC", "Movement", "Bunny hop")
local var_0_82 = var_0_41("Misc", "Movement", "Bhop Styles")
local var_0_83 = var_0_43("Misc", "Movement", "Bind", true)
local var_0_84 = var_0_42("Misc", "Movement", "\n", {
	"Left SW",
	"Right SW",
	"BW",
	"W",
	"A",
	"S",
	"D"
})
local var_0_85 = var_0_41("Misc", "Movement", "Optimizer")
local var_0_86 = var_0_45("Misc", "Movement", "Strength", 0, 100, 50, true, "%")
local var_0_87 = var_0_45("Misc", "Movement", "Threshold", 250, 350, 280, true)
local var_0_88 = var_0_41("Misc", "Movement", "Recorder")
local var_0_89 = var_0_44("Misc", "Movement", "\nOptions", {
	"Auto Align",
	"Silent Angles",
	"Visualize Trail"
})
local var_0_90 = var_0_40("Misc", "Movement", "Start/Stop Recording", function()
	var_0_68 = (var_0_68 + 1) % 3

	var_0_56({
		0,
		175,
		240
	}, "[Crescent] ", {
		255,
		255,
		255
	}, var_0_63[var_0_48(var_0_68)])
	var_0_3("playvol buttons\\blip1 1")

	if var_0_68 == 1 then
		var_0_65 = var_0_55(var_0_13(var_0_11(), "m_vecOrigin"))
	elseif var_0_68 == 2 then
		var_0_66 = var_0_55(var_0_13(var_0_11(), "m_vecOrigin"))
	else
		var_0_65, var_0_66, var_0_67 = nil, nil, {}
	end
end)
local var_0_91 = var_0_40("Misc", "Movement", "Play/Stop Playback", function()
	var_0_69 = (var_0_69 + 1) % 2

	var_0_56({
		0,
		175,
		240
	}, "[Crescent] ", {
		255,
		255,
		255
	}, var_0_64[var_0_48(var_0_69)])
	var_0_3("playvol buttons\\blip1 1")

	var_0_70 = var_0_69 == 0
end)
local var_0_92 = var_0_40("Misc", "Movement", "Clear Recording", function()
	var_0_65, var_0_66, var_0_67, var_0_68, var_0_69, var_0_70, var_0_71, var_0_72, var_0_73 = nil, nil, {}, 0, 0, false, false, 0, 0
end)
local var_0_93 = var_0_46("Misc", "Movement", "Name")
local var_0_94 = var_0_40("Misc", "Movement", "Import Recording", function()
	if var_0_39(var_0_93) == "" then
		return
	end

	var_0_67 = {}

	local var_5_0 = var_0_49("csgo\\" .. var_0_39(var_0_93) .. ".json")
	local var_5_1 = var_0_19(var_5_0)

	for iter_5_0 = 1, #var_5_1 do
		var_0_67[#var_0_67 + 1] = {
			var_5_1[iter_5_0][1],
			var_5_1[iter_5_0][2],
			var_5_1[iter_5_0][3],
			var_5_1[iter_5_0][4],
			var_5_1[iter_5_0][5],
			var_5_1[iter_5_0][6],
			var_5_1[iter_5_0][7],
			var_5_1[iter_5_0][8],
			var_5_1[iter_5_0][9],
			var_5_1[iter_5_0][10],
			var_5_1[iter_5_0][11],
			var_5_1[iter_5_0][12]
		}
	end

	var_0_65 = var_0_55(var_5_1[1][13], var_5_1[1][14], var_5_1[1][15])
	var_0_66 = var_0_55(var_5_1[1][16], var_5_1[1][17], var_5_1[1][18])
	var_0_70, var_0_72, var_0_71, var_0_68, var_0_73 = false, 0, false, 2, 0

	var_0_56({
		0,
		175,
		240
	}, "[Crescent] ", {
		255,
		255,
		255
	}, "Imported Recording from ", {
		0,
		175,
		240
	}, "csgo\\" .. var_0_39(var_0_93) .. ".json")
	var_0_50(var_0_93, "")
end)
local var_0_95 = var_0_40("Misc", "Movement", "Export Recording", function()
	if var_0_39(var_0_93) == "" and var_0_68 ~= 2 then
		return
	end

	local var_6_0 = {}

	for iter_6_0 = 1, #var_0_67 do
		var_6_0[#var_6_0 + 1] = {
			var_0_67[iter_6_0][1],
			var_0_67[iter_6_0][2],
			var_0_67[iter_6_0][3],
			var_0_67[iter_6_0][4],
			var_0_67[iter_6_0][5],
			var_0_67[iter_6_0][6],
			var_0_67[iter_6_0][7],
			var_0_67[iter_6_0][8],
			var_0_67[iter_6_0][9],
			var_0_67[iter_6_0][10],
			var_0_67[iter_6_0][11],
			var_0_67[iter_6_0][12],
			var_0_65.x,
			var_0_65.y,
			var_0_65.z,
			var_0_66.x,
			var_0_66.y,
			var_0_66.z
		}
	end

	local var_6_1 = var_0_20(var_6_0)

	var_0_52("csgo\\" .. var_0_39(var_0_93) .. ".json", var_6_1)
	var_0_3("playvol buttons\\blip1 1")
	var_0_56({
		0,
		175,
		240
	}, "[Crescent] ", {
		255,
		255,
		255
	}, "Exported Recording to ", {
		0,
		175,
		240
	}, "csgo\\" .. var_0_39(var_0_93) .. ".json")
	var_0_50(var_0_93, "")
end)
local var_0_96 = {
	var_0_79,
	var_0_80,
	var_0_82,
	var_0_85,
	var_0_88
}
local var_0_97 = {
	var_0_83,
	var_0_84
}
local var_0_98 = {
	var_0_86,
	var_0_87
}
local var_0_99 = {
	var_0_89,
	var_0_90,
	var_0_91,
	var_0_92,
	var_0_93,
	var_0_94,
	var_0_95
}

local function var_0_100(arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in var_0_31(arg_7_0) do
		if iter_7_1 == arg_7_1 then
			return true
		end
	end

	return false
end

local function var_0_101(arg_8_0)
	return arg_8_0 ~= arg_8_0
end

local function var_0_102(arg_9_0, arg_9_1, arg_9_2)
	return arg_9_0 < arg_9_1 and arg_9_1 or arg_9_2 < arg_9_0 and arg_9_2 or arg_9_0
end

local function var_0_103(arg_10_0)
	while arg_10_0 >= 180 do
		arg_10_0 = arg_10_0 - 360
	end

	while arg_10_0 <= -180 do
		arg_10_0 = arg_10_0 + 360
	end

	return arg_10_0
end

local function var_0_104(arg_11_0, arg_11_1, arg_11_2)
	return arg_11_0 + (arg_11_1 - arg_11_0) * arg_11_2
end

local function var_0_105(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	return arg_12_0 - var_0_102((arg_12_4 - arg_12_2) / -(arg_12_2 - arg_12_3), 0, 1) * (arg_12_0 - arg_12_1)
end

local function var_0_106(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0 * math.pi / 180
	local var_13_1 = arg_13_1 * math.pi / 180
	local var_13_2 = var_0_29(var_13_1)
	local var_13_3 = var_0_24(var_13_1)
	local var_13_4 = var_0_29(var_13_0)
	local var_13_5 = var_0_24(var_13_0)

	return var_13_5 * var_13_3, var_13_5 * var_13_2, -var_13_4
end

local function var_0_107(arg_14_0)
	local var_14_0 = 16
	local var_14_1 = 10
	local var_14_2 = 10
	local var_14_3 = 360
	local var_14_4 = 10
	local var_14_5 = 180
	local var_14_6 = var_0_55(var_0_13(arg_14_0, "m_vecOrigin"))
	local var_14_7 = var_0_55(var_0_13(arg_14_0, "m_vecVelocity"))

	if not var_14_6.x then
		return
	end

	if var_14_7.z == 0 then
		return
	end

	local var_14_8 = var_0_18()

	px = var_14_6.x + var_14_7.x * var_14_8
	py = var_14_6.y + var_14_7.y * var_14_8
	pz = var_14_6.z + var_14_7.z * var_14_8

	local var_14_9 = false
	local var_14_10 = false

	for iter_14_0 = 0, var_14_2, var_14_2 / var_14_4 do
		for iter_14_1 = 0, var_14_3, var_14_3 / var_14_5 do
			local var_14_11, var_14_12, var_14_13 = var_0_106(0, iter_14_1)
			local var_14_14 = px + var_14_11 * iter_14_0
			local var_14_15 = py + var_14_12 * iter_14_0
			local var_14_16 = pz + var_14_13 * iter_14_0
			local var_14_17 = var_0_8(arg_14_0, var_14_14, var_14_15, var_14_16, var_14_14, var_14_15, var_14_16 - 256)

			if var_14_0 > 256 * var_14_17 then
				var_14_9 = true
			end

			if var_14_1 > 256 * var_14_17 then
				var_14_10 = true

				return var_14_9, var_14_10
			end
		end
	end

	return var_14_9, var_14_10
end

local function var_0_108(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
	local var_15_0 = 4
	local var_15_1 = {
		arg_15_0,
		arg_15_1
	}

	for iter_15_0 = arg_15_5, arg_15_4 + arg_15_5, var_15_0 do
		local var_15_2 = var_0_28(iter_15_0)
		local var_15_3 = var_0_55(arg_15_3 * var_0_24(var_15_2) + arg_15_0, arg_15_3 * var_0_29(var_15_2) + arg_15_1, arg_15_2)
		local var_15_4 = {
			arg_15_0,
			arg_15_1
		}

		var_15_4.x, var_15_4.y = var_0_35(var_15_3.x, var_15_3.y, var_15_3.z)

		if var_15_4.x and var_15_1.x then
			var_0_33(var_15_4.x, var_15_4.y, var_15_1.x, var_15_1.y, arg_15_6, arg_15_7, arg_15_8, arg_15_9)
		end

		var_15_1.x, var_15_1.y = var_15_4.x, var_15_4.y
	end
end

local function var_0_109()
	local var_16_0 = var_0_11()

	if not var_0_14(var_16_0) then
		return
	end

	if var_0_39(var_0_80) then
		var_0_32(117, 205, 13, 255, "JB")
	end

	if var_0_100(var_0_39(var_0_79), "Recorder") and var_0_67[var_0_73] ~= nil and not var_0_71 then
		var_0_34(var_0_75, var_0_76 + var_0_77, 255, 255, 255, 255, "cbd", 0, var_0_36(" %d / %d (%d%%)", var_0_73, #var_0_67, var_0_23(var_0_73 / #var_0_67 * 100)))
	end

	if var_0_100(var_0_39(var_0_79), "Bhop Style") and var_0_39(var_0_82) then
		local var_16_1 = var_0_13(var_16_0, "m_fFlags")
		local var_16_2

		var_16_2 = var_0_0(var_16_1, 1) ~= 0

		local var_16_3 = var_0_39(var_0_83) and {
			117,
			205,
			13,
			255
		} or {
			255,
			0,
			0,
			100
		}

		var_0_34(var_0_75, var_0_76 + var_0_77 + 25, var_16_3[1], var_16_3[2], var_16_3[3], var_16_3[4], "cbd", 0, var_0_39(var_0_84))
	end

	if var_0_39(var_0_88) and var_0_100(var_0_39(var_0_89), "Visualize Trail") and var_0_67 and #var_0_67 > 0 then
		for iter_16_0, iter_16_1 in var_0_53(var_0_67) do
			if iter_16_1[1] ~= var_0_17() then
				return
			end

			local var_16_4 = {
				var_0_35(iter_16_1[4], iter_16_1[5], iter_16_1[6])
			}

			if iter_16_0 == 1 then
				if var_16_4[1] and var_16_4[2] then
					var_0_33(var_16_4[1], var_16_4[2], var_16_4[1] - 1, var_16_4[2] - 1, 255, 255, 255, 255)
				end
			else
				local var_16_5 = {
					var_0_35(var_0_67[iter_16_0 - 1][4], var_0_67[iter_16_0 - 1][5], var_0_67[iter_16_0 - 1][6])
				}

				if var_16_5[1] and var_16_5[2] then
					var_0_33(var_16_4[1], var_16_4[2], var_16_5[1], var_16_5[2], 255, 255, 255, 255)
				end
			end
		end
	end

	if var_0_65 and var_0_66 then
		local var_16_6 = var_0_55(var_0_12(var_16_0))
		local var_16_7 = var_16_6:dist(var_0_65)
		local var_16_8 = var_16_6:dist(var_0_66)
		local var_16_9 = var_16_7 <= 40 and {
			74,
			199,
			113,
			255
		} or {
			255,
			110,
			110,
			255
		}
		local var_16_10 = var_16_8 <= 40 and {
			74,
			199,
			113,
			255
		} or {
			255,
			110,
			110,
			255
		}

		var_0_108(var_0_65.x, var_0_65.y, var_0_65.z, 25, 360, 0, var_16_9[1], var_16_9[2], var_16_9[3], var_16_9[4])
		var_0_108(var_0_66.x, var_0_66.y, var_0_66.z, 25, 360, 0, var_16_10[1], var_16_10[2], var_16_10[3], var_16_10[4])
	end
end

local function var_0_110(arg_17_0)
	local var_17_0 = var_0_11()
	local var_17_1 = var_0_13(var_17_0, "m_fFlags")
	local var_17_2 = var_0_0(var_17_1, 1) ~= 0
	local var_17_3 = var_0_13(var_0_10(), "m_bIsValveDS")
	local var_17_4 = var_0_55(var_0_13(var_17_0, "m_vecOrigin"))
	local var_17_5 = var_0_55(var_0_13(var_17_0, "m_vecVelocity"))
	local var_17_6 = var_0_55(var_0_1())
	local var_17_7 = var_0_55(var_0_4())
	local var_17_8 = var_0_26(var_0_30(var_17_5.x * var_17_5.x + var_17_5.y * var_17_5.y) + 0.5)

	if var_0_68 == 1 then
		var_0_67[#var_0_67 + 1] = {
			var_0_17(),
			arg_17_0.in_jump,
			arg_17_0.in_duck,
			var_17_4.x,
			var_17_4.y,
			var_17_4.z,
			var_0_15(),
			arg_17_0.move_yaw,
			arg_17_0.forwardmove,
			arg_17_0.sidemove,
			var_17_6.x,
			var_17_6.y
		}
	elseif var_0_68 == 2 then
		if var_0_67[1][1] ~= var_0_17() then
			return
		end

		if var_0_69 == 1 then
			if var_0_100(var_0_39(var_0_89), "Auto Align") and not var_0_70 then
				local var_17_9 = var_17_4:dist(var_0_65)
				local var_17_10 = var_0_55(var_0_67[1][11], var_0_67[1][12], 0)
				local var_17_11 = var_17_6:dist(var_17_10)

				if var_17_9 < 1 and var_17_9 > -1 and var_17_11 < 1 and var_17_11 > -1 then
					var_0_70 = true
					var_0_71 = false
				else
					local var_17_12 = var_0_55(var_17_6.x - var_17_10.x, var_17_6.y - var_17_10.y, 0)
					local var_17_13 = var_0_30(var_17_12.x * var_17_12.x + var_17_12.y * var_17_12.y)

					var_17_12.x, var_17_12.y = var_17_12.x / var_17_13, var_17_12.y / var_17_13

					local var_17_14 = var_0_27(1, var_17_13 / 3) * 0.5
					local var_17_15 = (var_17_14 + var_0_21(var_17_13 * (1 - var_17_14))) * var_0_16() * 15 * 2
					local var_17_16 = var_17_6.x - var_17_12.x * var_17_15 * 0.1
					local var_17_17 = var_17_6.y - var_17_12.y * var_17_15 * 0.1
					local var_17_18 = var_17_4:to(var_0_65)
					local var_17_19, var_17_20 = var_17_18:angles()
					local var_17_21 = var_17_4:dist(var_0_65)
					local var_17_22 = var_0_105(450, 30, 500, 50, var_17_21)

					var_0_1(var_17_16, var_17_17)

					arg_17_0.move_yaw = var_17_20
					arg_17_0.sidemove = 0
					arg_17_0.forwardmove = var_0_27(450, var_17_18:length() * var_17_22)
				end
			elseif var_0_72 == 0 then
				if arg_17_0.command_number ~= nil then
					var_0_72 = arg_17_0.command_number
				end
			else
				var_0_73 = arg_17_0.command_number - var_0_72

				if var_0_67[var_0_73] ~= nil and not var_0_71 then
					arg_17_0.in_jump = var_0_67[var_0_73][2]
					arg_17_0.in_duck = var_0_67[var_0_73][3]
					arg_17_0.move_yaw = var_0_67[var_0_73][8]
					arg_17_0.forwardmove = var_0_67[var_0_73][9]
					arg_17_0.sidemove = var_0_67[var_0_73][10]

					if var_0_100(var_0_39(var_0_89), "Silent Angles") then
						arg_17_0.pitch = var_0_67[var_0_73][11]
						arg_17_0.yaw = var_0_67[var_0_73][12]
					else
						var_0_1(var_0_67[var_0_73][11], var_0_67[var_0_73][12])
					end

					if var_0_73 == #var_0_67 then
						var_0_70 = false
						var_0_73 = 0
						var_0_72 = 0
						var_0_71 = true

						var_0_50(var_0_91, true)
					end
				end
			end
		end
	end

	if (arg_17_0.in_jump or not var_17_2) and var_0_39(var_0_82) and var_0_39(var_0_83) then
		local var_17_23 = var_0_39(var_0_84)
		local var_17_24 = var_0_62[var_17_23]

		if var_0_37(var_17_23) == 1 then
			if var_0_5(65) then
				arg_17_0.sidemove = var_17_24[1]
				arg_17_0.yaw = arg_17_0.yaw + var_17_24[3]
			elseif var_0_5(68) then
				arg_17_0.sidemove = var_17_24[2]
				arg_17_0.yaw = arg_17_0.yaw + var_17_24[4]
			end
		else
			arg_17_0.yaw = arg_17_0.yaw + var_17_24[3]

			if var_0_5(65) then
				arg_17_0.sidemove = var_17_24[1]
			elseif var_0_5(68) then
				arg_17_0.sidemove = var_17_24[2]
			end
		end
	end

	if var_0_39(var_0_85) and not var_17_2 then
		if var_0_69 == 1 then
			return
		end

		local var_17_25 = var_0_39(var_0_86)
		local var_17_26 = var_0_39(var_0_87)
		local var_17_27 = var_0_105(var_17_25, 20, var_0_87, 1300, var_17_8) / 100
		local var_17_28 = var_0_55()

		var_17_28.x = var_17_4.x + var_17_5.x * var_0_18() * 3
		var_17_28.y = var_17_4.y + var_17_5.y * var_0_18() * 3

		if arg_17_0.forwardmove ~= 0 or arg_17_0.sidemove == 0 or var_17_8 < var_17_26 or var_0_21(var_17_6.y - var_0_61.last_yaw) < 0.1 then
			var_0_61.last_yaw = var_17_6.y

			return
		else
			local var_17_29 = var_0_22(var_17_5.y, var_17_5.x)
			local var_17_30 = var_0_103(var_17_6.y - var_0_25(var_17_29))

			if arg_17_0.sidemove < 0 then
				var_0_61.ideal_yaw = var_17_6.y + var_0_21(var_17_30)
				arg_17_0.in_moveright = 0
			elseif arg_17_0.sidemove > 0 then
				var_0_61.ideal_yaw = var_17_6.y - var_17_30
				arg_17_0.in_moveleft = 0
			end

			if var_0_61.ideal_yaw and var_17_6.y and var_17_27 and var_17_8 > 0 then
				local var_17_31 = var_0_103(var_0_104(var_17_6.y, var_0_61.ideal_yaw, var_17_27))

				var_0_1(var_0_1(), var_17_31)

				var_0_61.last_yaw = var_17_6.y
			end
		end
	end

	if not var_0_39(var_0_80) then
		if var_0_60 then
			var_0_50(var_0_81, var_0_59)

			var_0_59 = nil
			var_0_60 = false
		end

		if var_0_57 then
			var_0_57 = false
		end

		if var_0_58 then
			var_0_58 = false
		end

		return
	end

	if not var_0_59 then
		var_0_59 = var_0_39(var_0_81)
	end

	local var_17_32, var_17_33 = var_0_107(var_17_0)

	if var_17_33 and var_0_58 and var_17_5.z <= 0 then
		if arg_17_0.command_number % 2 == 0 then
			arg_17_0.in_jump = true
		else
			arg_17_0.in_jump = false
		end
	end

	if var_17_32 or var_0_57 then
		arg_17_0.in_duck = true
		var_0_57 = true
	end

	if var_17_33 or var_0_58 then
		var_0_50(var_0_81, false)

		arg_17_0.in_duck = false
		arg_17_0.in_jump = true
		var_0_58 = true
		var_0_60 = true
	end

	if not var_17_32 and not var_17_33 and var_0_60 then
		var_0_50(var_0_81, var_0_59)

		var_0_59 = nil
		var_0_60 = false
		var_0_57 = false
		var_0_58 = false
	end
end

local function var_0_111(arg_18_0)
	local var_18_0 = var_0_13(arg_18_0, "m_iHealth")

	return var_0_100(var_0_39(var_0_79), "1HP Flash") and var_18_0 == 1
end

local function var_0_112()
	var_0_65, var_0_66, var_0_67, var_0_68, var_0_69, var_0_70, var_0_71, var_0_72, var_0_73, var_0_61.last_yaw, var_0_61.ideal_yaw = nil, nil, {}, 0, 0, false, false, 0, 0, 0, 0
end

local function var_0_113(arg_20_0)
	local var_20_0 = arg_20_0 and client.set_event_callback or client.unset_event_callback

	var_20_0("setup_command", var_0_110)
	var_20_0("paint", var_0_109)
	var_20_0("round_start", var_0_112)
	var_20_0("client_disconnect", var_0_112)
	var_20_0("level_init", var_0_112)
	var_20_0("player_connect_full", function(arg_21_0)
		if var_0_9(arg_21_0.userid) == var_0_11() then
			var_0_112()
		end
	end)
end

local function var_0_114(arg_22_0)
	local var_22_0 = var_0_39(arg_22_0)

	for iter_22_0 = 1, #var_0_96 do
		var_0_54(var_0_96[iter_22_0], var_22_0)
	end

	var_0_113(var_22_0)
end

local function var_0_115(arg_23_0)
	local var_23_0 = var_0_39(arg_23_0)

	for iter_23_0 = 1, #var_0_99 do
		var_0_54(var_0_99[iter_23_0], var_23_0)
	end
end

local function var_0_116(arg_24_0)
	local var_24_0 = var_0_39(arg_24_0)

	for iter_24_0 = 1, #var_0_97 do
		var_0_54(var_0_97[iter_24_0], var_24_0)
	end
end

local function var_0_117(arg_25_0)
	local var_25_0 = var_0_39(arg_25_0)

	for iter_25_0 = 1, #var_0_98 do
		var_0_54(var_0_98[iter_25_0], var_25_0)
	end
end

var_0_51(var_0_88, var_0_115)
var_0_51(var_0_78, var_0_114)
var_0_51(var_0_82, var_0_116)
var_0_51(var_0_85, var_0_117)
var_0_6("1HP", 255, 0, 0, var_0_111)
var_0_117(var_0_85)
var_0_116(var_0_82)
var_0_115(var_0_88)
var_0_114(var_0_78)
