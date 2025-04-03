local var_0_0 = client.latency
local var_0_1 = client.set_clan_tag
local var_0_2 = client.log
local var_0_3 = client.draw_rectangle
local var_0_4 = client.draw_indicator
local var_0_5 = client.draw_circle_outline
local var_0_6 = client.timestamp
local var_0_7 = client.world_to_screen
local var_0_8 = client.userid_to_entindex
local var_0_9 = client.draw_circle
local var_0_10 = client.draw_gradient
local var_0_11 = client.set_event_callback
local var_0_12 = client.screen_size
local var_0_13 = client.trace_line
local var_0_14 = client.draw_text
local var_0_15 = client.color_log
local var_0_16 = client.system_time
local var_0_17 = client.delay_call
local var_0_18 = client.visible
local var_0_19 = client.exec
local var_0_20 = client.open_panorama_context
local var_0_21 = client.set_cvar
local var_0_22 = client.eye_position
local var_0_23 = client.draw_hitboxes
local var_0_24 = client.get_cvar
local var_0_25 = client.draw_line
local var_0_26 = client.camera_angles
local var_0_27 = client.draw_debug_text
local var_0_28 = client.random_int
local var_0_29 = client.random_float
local var_0_30 = entity.get_local_player
local var_0_31 = entity.is_enemy
local var_0_32 = entity.get_bounding_box
local var_0_33 = entity.is_dormant
local var_0_34 = entity.get_steam64
local var_0_35 = entity.get_player_name
local var_0_36 = entity.hitbox_position
local var_0_37 = entity.get_game_rules
local var_0_38 = entity.get_all
local var_0_39 = entity.set_prop
local var_0_40 = entity.is_alive
local var_0_41 = entity.get_player_weapon
local var_0_42 = entity.get_prop
local var_0_43 = entity.get_players
local var_0_44 = entity.get_classname
local var_0_45 = globals.realtime
local var_0_46 = globals.absoluteframetime
local var_0_47 = globals.tickcount
local var_0_48 = globals.lastoutgoingcommand
local var_0_49 = globals.curtime
local var_0_50 = globals.mapname
local var_0_51 = globals.tickinterval
local var_0_52 = globals.framecount
local var_0_53 = globals.frametime
local var_0_54 = globals.maxplayers
local var_0_55 = ui.new_slider
local var_0_56 = ui.new_combobox
local var_0_57 = ui.reference
local var_0_58 = ui.is_menu_open
local var_0_59 = ui.set_visible
local var_0_60 = ui.new_textbox
local var_0_61 = ui.new_color_picker
local var_0_62 = ui.set_callback
local var_0_63 = ui.set
local var_0_64 = ui.new_checkbox
local var_0_65 = ui.new_hotkey
local var_0_66 = ui.new_button
local var_0_67 = ui.new_multiselect
local var_0_68 = ui.get
local var_0_69 = math.ceil
local var_0_70 = math.tan
local var_0_71 = math.cos
local var_0_72 = math.sinh
local var_0_73 = math.pi
local var_0_74 = math.max
local var_0_75 = math.atan2
local var_0_76 = math.floor
local var_0_77 = math.sqrt
local var_0_78 = math.deg
local var_0_79 = math.atan
local var_0_80 = math.fmod
local var_0_81 = math.acos
local var_0_82 = math.pow
local var_0_83 = math.abs
local var_0_84 = math.min
local var_0_85 = math.sin
local var_0_86 = math.log
local var_0_87 = math.exp
local var_0_88 = math.cosh
local var_0_89 = math.asin
local var_0_90 = math.rad
local var_0_91 = table.sort
local var_0_92 = table.remove
local var_0_93 = table.concat
local var_0_94 = table.insert
local var_0_95 = string.find
local var_0_96 = string.format
local var_0_97 = string.gsub
local var_0_98 = string.len
local var_0_99 = string.gmatch
local var_0_100 = string.match
local var_0_101 = string.reverse
local var_0_102 = string.upper
local var_0_103 = string.lower
local var_0_104 = string.sub
local var_0_105 = renderer.line
local var_0_106 = renderer.indicator
local var_0_107 = renderer.world_to_screen
local var_0_108 = renderer.circle_outline
local var_0_109 = renderer.rectangle
local var_0_110 = renderer.gradient
local var_0_111 = renderer.circle
local var_0_112 = renderer.text
local var_0_113 = ui.new_multiselect("VISUALS", "Other ESP", "Grenades: Timer ", "Text", "Bar")
local var_0_114 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Smoke radius")
local var_0_115 = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Smoke radius", 61, 147, 250, 180)
local var_0_116 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov radius")
local var_0_117 = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Molotov radius", 255, 63, 63, 190)
local var_0_118 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov team")
local var_0_119 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Timer")

local function var_0_120()
	if var_0_68(var_0_119) and #var_0_68(var_0_113) == 0 then
		var_0_63(var_0_113, {
			"Text"
		})
		var_0_63(var_0_119, false)
	end
end

ui.set_callback(var_0_119, var_0_120)
ui.set_visible(var_0_119, false)

local var_0_121 = 125
local var_0_122 = 17.55
local var_0_123 = 7
local var_0_124 = {}
local var_0_125 = {}
local var_0_126 = {}
local var_0_127 = {}
local var_0_128 = true
local var_0_129 = 26
local var_0_130 = 8

local function var_0_131(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	return var_0_77((arg_2_2 - arg_2_0)^2 + (arg_2_3 - arg_2_1)^2)
end

local function var_0_132(arg_3_0, arg_3_1)
	for iter_3_0 = 1, #arg_3_0 do
		if arg_3_0[iter_3_0] == arg_3_1 then
			return true
		end
	end

	return false
end

local function var_0_133(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
	local var_4_0 = arg_4_8 == nil and true or arg_4_8

	if arg_4_9 == nil then
		-- block empty
	end

	local var_4_1 = arg_4_9
	local var_4_2 = arg_4_10 == nil and true or arg_4_10
	local var_4_3 = 4

	if (not var_4_2 or not (arg_4_2 > 2) or not (var_4_3 > 2)) and not (arg_4_2 > 0) and not (var_4_3 > 0) then
		error("Invalid arguments. Width and/or height too small")
	end

	local var_4_4 = var_0_74(0, var_0_84(1, arg_4_7))
	local var_4_5 = arg_4_0
	local var_4_6 = arg_4_1
	local var_4_7 = arg_4_2
	local var_4_8 = var_4_3
	local var_4_9 = 0
	local var_4_10 = 0

	if var_4_2 then
		var_4_7, var_4_8 = var_4_7 - 2, var_4_8 - 2
		var_4_5, var_4_6 = var_4_5 + 1, var_4_6 + 1
	end

	local var_4_11 = var_4_7
	local var_4_12 = var_0_69(var_4_7 * var_4_4)

	if var_4_1 then
		var_4_9 = var_4_11 - var_4_12
	end

	if not var_4_0 then
		arg_4_2, var_4_3 = var_4_3, arg_4_2
		var_4_12, var_4_8 = var_4_8, var_4_12
		var_4_9, var_4_10 = var_4_10, var_4_9
	end

	local var_4_13 = 16
	local var_4_14 = 16
	local var_4_15 = 16
	local var_4_16 = 170

	if var_4_2 then
		var_0_109(arg_4_0, arg_4_1, arg_4_2, var_4_3, var_4_13, var_4_14, var_4_15, var_4_16)
	end

	var_0_109(var_4_5 + var_4_9, var_4_6 + var_4_10, var_4_12, var_4_8, arg_4_3, arg_4_4, arg_4_5, arg_4_6)

	return var_4_5 + var_4_9, var_4_6 + var_4_10, var_4_12, var_4_8
end

local function var_0_134(arg_5_0)
	return var_0_44(arg_5_0) == "CCSPlayer"
end

local function var_0_135(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = (arg_6_3 - arg_6_0) * arg_6_6 + arg_6_0
	local var_6_1 = (arg_6_4 - arg_6_1) * arg_6_6 + arg_6_1
	local var_6_2 = (arg_6_5 - arg_6_2) * arg_6_6 + arg_6_2

	return var_6_0, var_6_1, var_6_2
end

local function var_0_136(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	return var_0_77((arg_7_3 - arg_7_0)^2 + (arg_7_4 - arg_7_1)^2 + (arg_7_5 - arg_7_2)^2)
end

local function var_0_137(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = arg_8_7 or 10
	local var_8_1 = 0
	local var_8_2 = -1
	local var_8_3 = arg_8_1
	local var_8_4 = arg_8_2
	local var_8_5 = arg_8_3
	local var_8_6 = -1
	local var_8_7 = 1

	while (var_8_2 == -1 or var_8_2 ~= 0 and arg_8_0(var_8_2)) and var_8_1 < 1 and var_8_7 <= var_8_0 do
		var_8_1, var_8_2 = var_0_13(var_8_2, var_8_3, var_8_4, var_8_5, arg_8_4, arg_8_5, arg_8_6)
		var_8_3, var_8_4, var_8_5 = var_0_135(var_8_3, var_8_4, var_8_5, arg_8_4, arg_8_5, arg_8_6, var_8_1)
		var_8_7 = var_8_7 + 1
	end

	return var_0_136(arg_8_1, arg_8_2, arg_8_3, var_8_3, var_8_4, var_8_5) / var_0_136(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6), var_8_2
end

local function var_0_138(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12)
	local var_9_0 = arg_9_8 ~= nil and arg_9_8 or 3
	local var_9_1 = arg_9_9 ~= nil and arg_9_9 or 1
	local var_9_2 = arg_9_10 ~= nil and arg_9_10 or false
	local var_9_3 = arg_9_11 ~= nil and arg_9_11 or 0
	local var_9_4 = arg_9_12 ~= nil and arg_9_12 or 1
	local var_9_5
	local var_9_6

	for iter_9_0 = var_9_3, var_9_4 * 360, var_9_0 do
		local var_9_7 = var_0_90(iter_9_0)
		local var_9_8 = arg_9_3 * var_0_71(var_9_7) + arg_9_0
		local var_9_9 = arg_9_3 * var_0_85(var_9_7) + arg_9_1
		local var_9_10 = arg_9_2
		local var_9_11 = 256
		local var_9_12, var_9_13 = var_0_13(-1, var_9_8, var_9_9, var_9_10 + var_9_11 / 2, var_9_8, var_9_9, var_9_10 - var_9_11 / 2)

		if var_9_12 > 0 and var_9_12 < 1 then
			var_9_10 = var_9_10 + var_9_11 / 2 - var_9_11 * var_9_12
		end

		local var_9_14, var_9_15 = var_0_107(var_9_8, var_9_9, var_9_10)

		if var_9_14 ~= nil and var_9_5 ~= nil then
			for iter_9_1 = 1, var_9_1 do
				local var_9_16 = iter_9_1 - 1

				var_0_105(var_9_14, var_9_15 - var_9_16, var_9_5, var_9_6 - var_9_16, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
			end

			if var_9_2 then
				local var_9_17 = arg_9_7 / 255 * 160

				var_0_105(var_9_14, var_9_15 - var_9_1, var_9_5, var_9_6 - var_9_1, 16, 16, 16, var_9_17)
				var_0_105(var_9_14, var_9_15 + 1, var_9_5, var_9_6 + 1, 16, 16, 16, var_9_17)
			end
		end

		var_9_5, var_9_6 = var_9_14, var_9_15
	end
end

local function var_0_139(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7, arg_10_8, arg_10_9, arg_10_10, arg_10_11, arg_10_12)
	local var_10_0 = arg_10_8 ~= nil and arg_10_8 or 3
	local var_10_1 = arg_10_9 ~= nil and arg_10_9 or 1
	local var_10_2 = arg_10_10 ~= nil and arg_10_10 or false
	local var_10_3 = arg_10_11 ~= nil and arg_10_11 or 0
	local var_10_4 = arg_10_12 ~= nil and arg_10_12 or 1
	local var_10_5
	local var_10_6

	for iter_10_0 = var_10_3, var_10_4 * 360, var_10_0 do
		local var_10_7 = var_0_90(iter_10_0)
		local var_10_8 = arg_10_3 * var_0_71(var_10_7) + arg_10_0
		local var_10_9 = arg_10_3 * var_0_85(var_10_7) + arg_10_1
		local var_10_10 = arg_10_2
		local var_10_11, var_10_12 = var_0_107(var_10_8, var_10_9, var_10_10)

		if var_10_11 ~= nil and var_10_5 ~= nil then
			for iter_10_1 = 1, var_10_1 do
				local var_10_13 = iter_10_1 - 1

				var_0_105(var_10_11, var_10_12 - var_10_13, var_10_5, var_10_6 - var_10_13, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
			end

			if var_10_2 then
				local var_10_14 = arg_10_7 / 255 * 160

				var_0_105(var_10_11, var_10_12 - var_10_1, var_10_5, var_10_6 - var_10_1, 16, 16, 16, var_10_14)
				var_0_105(var_10_11, var_10_12 + 1, var_10_5, var_10_6 + 1, 16, 16, 16, var_10_14)
			end
		end

		var_10_5, var_10_6 = var_10_11, var_10_12
	end
end

local function var_0_140(arg_11_0, arg_11_1, arg_11_2)
	return arg_11_1 + (arg_11_1 - arg_11_0) * arg_11_2
end

local function var_0_141(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = (arg_12_3 - arg_12_0) * arg_12_6 + arg_12_0
	local var_12_1 = (arg_12_4 - arg_12_1) * arg_12_6 + arg_12_1
	local var_12_2 = (arg_12_5 - arg_12_2) * arg_12_6 + arg_12_2

	return var_12_0, var_12_1, var_12_2
end

local function var_0_142(arg_13_0)
	local var_13_0 = var_0_42(arg_13_0, "m_fireCount")

	return var_13_0 ~= nil and var_13_0 > 0
end

local function var_0_143(arg_14_0)
	if var_0_8(arg_14_0.userid) == var_0_30() then
		var_0_124 = {}
		var_0_125 = {}
	end
end

client.set_event_callback("player_connect_full", var_0_143)

local function var_0_144(arg_15_0)
	if not var_0_68(var_0_116) then
		return
	end

	var_0_125 = {}
	var_0_127 = {}
	var_0_124 = var_0_38("CInferno")

	if #var_0_124 == 0 then
		return
	end

	local var_15_0 = var_0_49()

	for iter_15_0 = 1, #var_0_124 do
		local var_15_1 = var_0_124[iter_15_0]

		if var_0_142(var_15_1) then
			local var_15_2, var_15_3, var_15_4 = var_0_42(var_15_1, "m_vecOrigin")
			local var_15_5 = 40
			local var_15_6 = 0
			local var_15_7
			local var_15_8
			local var_15_9
			local var_15_10 = {}
			local var_15_11 = {}
			local var_15_12 = 0
			local var_15_13
			local var_15_14

			for iter_15_1 = 1, 64 do
				if var_0_42(var_15_1, "m_bFireIsBurning", iter_15_1) == 1 then
					local var_15_15 = var_0_42(var_15_1, "m_fireXDelta", iter_15_1)
					local var_15_16 = var_0_42(var_15_1, "m_fireYDelta", iter_15_1)
					local var_15_17 = var_0_42(var_15_1, "m_fireZDelta", iter_15_1)

					var_0_94(var_15_10, {
						var_15_15,
						var_15_16,
						var_15_17
					})
				end
			end

			for iter_15_2 = 1, #var_15_10 do
				local var_15_18 = var_15_10[iter_15_2]
				local var_15_19, var_15_20, var_15_21 = unpack(var_15_18)

				for iter_15_3 = 1, #var_15_10 do
					local var_15_22 = var_15_10[iter_15_3]
					local var_15_23 = var_0_131(var_15_19, var_15_20, var_15_22[1], var_15_22[2])

					if var_15_12 < var_15_23 then
						var_15_12 = var_15_23
						var_15_13 = var_15_18
						var_15_14 = var_15_22
					end
				end
			end

			if var_15_13 ~= nil and var_15_14 ~= nil then
				local var_15_24 = var_15_2 + var_15_13[1]
				local var_15_25 = var_15_3 + var_15_13[2]
				local var_15_26 = var_15_4 + var_15_13[3]
				local var_15_27 = var_15_2 + var_15_14[1]
				local var_15_28 = var_15_3 + var_15_14[2]
				local var_15_29 = var_15_4 + var_15_14[3]
				local var_15_30, var_15_31, var_15_32 = var_0_141(var_15_13[1], var_15_13[2], var_15_13[3], var_15_14[1], var_15_14[2], var_15_14[3], 0.5)
				local var_15_33 = var_15_2 + var_15_30
				local var_15_34 = var_15_3 + var_15_31
				local var_15_35 = var_15_4 + var_15_32
				local var_15_36 = var_15_12 / 2 + var_15_5

				var_0_125[var_15_1] = {
					var_15_33,
					var_15_34,
					var_15_35,
					var_15_36
				}
				var_0_127[var_15_1] = var_15_10
			end
		end
	end
end

client.set_event_callback("run_command", var_0_144)

local function var_0_145()
	local var_16_0 = var_0_68(var_0_114)
	local var_16_1 = var_0_68(var_0_113)
	local var_16_2 = #var_16_1 > 0
	local var_16_3 = var_0_68(var_0_118)
	local var_16_4 = var_0_68(var_0_116)
	local var_16_5 = var_0_30()

	if var_16_5 == nil or not var_0_40(var_16_5) or var_0_42(var_16_5, "m_MoveType") == var_0_130 then
		var_0_144()
	end

	if var_16_4 then
		local var_16_6, var_16_7, var_16_8, var_16_9 = var_0_68(var_0_117)

		for iter_16_0 = 1, #var_0_124 do
			local var_16_10 = var_0_124[iter_16_0]

			if var_0_125[var_16_10] ~= nil then
				local var_16_11, var_16_12, var_16_13, var_16_14 = unpack(var_0_125[var_16_10])
				local var_16_15 = 1

				if var_0_126[grenade] ~= nil then
					local var_16_16 = curtime - var_0_126[grenade]

					var_16_15 = var_0_74(0, 1 - var_16_16 / var_0_123)
				end

				var_0_139(var_16_11, var_16_12, var_16_13, var_16_14, var_16_6, var_16_7, var_16_8, var_16_9 * var_16_15, 9, 1, true)
			end
		end
	end

	if var_16_0 or var_16_2 or var_16_3 then
		local var_16_17 = var_0_38("CSmokeGrenadeProjectile")
		local var_16_18 = var_0_47()
		local var_16_19 = var_0_51()
		local var_16_20 = var_0_49()

		if var_16_2 or var_16_3 then
			local var_16_21 = var_0_126

			var_0_126 = {}

			for iter_16_1 = 1, #var_0_124 do
				local var_16_22 = var_0_124[iter_16_1]

				if var_0_142(var_16_22) then
					var_0_126[var_16_22] = var_16_21[var_16_22] ~= nil and var_16_21[var_16_22] or var_16_20

					var_0_94(var_16_17, var_16_22)
				end
			end
		end

		for iter_16_2 = 1, #var_16_17 do
			local var_16_23 = var_16_17[iter_16_2]
			local var_16_24 = var_0_44(var_16_23)
			local var_16_25
			local var_16_26
			local var_16_27
			local var_16_28 = 1

			if var_16_24 == "CSmokeGrenadeProjectile" then
				local var_16_29, var_16_30, var_16_31 = var_0_42(var_16_23, "m_vecOrigin")

				var_16_26, var_16_27 = var_0_107(var_16_29, var_16_30, var_16_31)

				local var_16_32 = var_0_42(var_16_23, "m_bDidSmokeEffect") == 1

				if var_16_26 ~= nil and var_16_32 then
					local var_16_33 = var_0_42(var_16_23, "m_nSmokeEffectTickBegin")

					if var_16_33 ~= nil then
						local var_16_34 = var_16_19 * (var_16_18 - var_16_33)

						if var_16_34 > 0 and var_0_122 - var_16_34 > 0 then
							if var_16_2 then
								var_16_28 = 1 - var_16_34 / var_0_122
								var_16_25 = var_0_96("%.1f", var_0_122 - var_16_34)
							end

							if var_16_0 then
								local var_16_35, var_16_36, var_16_37, var_16_38 = var_0_68(var_0_115)
								local var_16_39 = var_0_121

								if var_16_34 < 0.3 then
									var_16_39 = var_16_39 * 0.6 + var_16_39 * (var_16_34 / 0.3) * 0.4
									var_16_38 = var_16_38 * (var_16_34 / 0.3)
								end

								if var_0_122 - var_16_34 < 1 then
									var_16_39 = var_16_39 * ((var_0_122 - var_16_34) / 1 * 0.3 + 0.7)
								end

								var_0_139(var_16_29, var_16_30, var_16_31, var_16_39, var_16_35, var_16_36, var_16_37, var_16_38 * var_0_84(1, var_16_28 * 1.3), 9, 1, true)
							end
						end
					end
				end
			elseif var_16_24 == "CInferno" and (var_16_2 or var_16_3) then
				local var_16_40, var_16_41, var_16_42 = var_0_42(var_16_23, "m_vecOrigin")

				var_16_26, var_16_27 = var_0_107(var_16_40, var_16_41, var_16_42)

				if var_16_26 ~= nil then
					if var_16_2 and var_0_126[var_16_23] ~= nil then
						local var_16_43 = var_16_20 - var_0_126[var_16_23]

						var_16_28 = var_0_74(0, 1 - var_16_43 / var_0_123)
						var_16_25 = var_0_96("%.1f", var_0_74(0, var_0_123 - var_16_43))
					end

					if var_16_3 then
						local var_16_44 = var_0_42(var_16_23, "m_hOwnerEntity")
						local var_16_45 = false

						if var_16_44 ~= nil and tonumber(var_0_24("mp_friendlyfire")) == 0 and var_16_44 ~= var_16_5 and not var_0_31(var_16_44) then
							var_16_45 = true
						end

						if var_16_45 then
							var_0_112(var_16_26 - 19, var_16_27 + 5, 149, 184, 6, 255 * var_16_28, nil, 0, "✔")
						else
							var_0_112(var_16_26 - 19, var_16_27 + 4, 230, 21, 21, 255 * var_16_28, nil, 0, "❌")
						end
					end
				end
			end

			if var_16_26 ~= nil and var_16_25 ~= nil then
				local var_16_46 = 255

				if var_16_28 < 0.08 then
					var_16_46 = var_16_46 * var_16_28 / 0.08
				end

				if var_0_132(var_16_1, "Bar") then
					local var_16_47 = var_0_132(var_16_1, "Bar") and var_0_132(var_16_1, "Text") and 1 or 0
					local var_16_48, var_16_49, var_16_50, var_16_51 = var_0_133(var_16_26 - var_0_129 / 2 + 1, var_16_27 + 16 + var_16_47, var_0_129, 255, 255, 255, var_16_46, var_16_28, true)

					if var_0_132(var_16_1, "Text") and var_16_28 < 0.56 then
						var_0_112(var_16_48 + var_16_50 + 5, var_16_27 + 18 + var_16_47, 255, 255, 255, var_16_46 * 0.7, "c-", 150, var_16_25)
					end
				elseif var_0_132(var_16_1, "Text") then
					var_0_112(var_16_26, var_16_27 + 20, 255, 255, 255, var_0_74(30, var_16_28 * 255), "c-", 150, var_16_25, "  S")
				end
			end
		end
	end
end

client.set_event_callback("paint", var_0_145)
