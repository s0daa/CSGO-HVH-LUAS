local var_0_0 = ui.get
local var_0_1 = ui.set
local var_0_2 = entity.get_player_weapon
local var_0_3 = entity.get_players
local var_0_4 = entity.get_local_player
local var_0_5 = entity.get_prop
local var_0_6 = entity.hitbox_position
local var_0_7 = entity.is_alive
local var_0_8 = entity.is_dormant
local var_0_9 = globals.chokedcommands
local var_0_10 = globals.curtime
local var_0_11 = globals.tickcount
local var_0_12 = globals.tickinterval
local var_0_13 = globals.mapname
local var_0_14 = plist.get
local var_0_15 = plist.set
local var_0_16 = client.trace_line
local var_0_17 = client.latency
local var_0_18 = client.set_clan_tag
local var_0_19 = client.screen_size
local var_0_20 = client.eye_position
local var_0_21 = entity.get_all
local var_0_22 = renderer.world_to_screen
local var_0_23 = renderer.indicator
local var_0_24 = string.format
local var_0_25 = string.sub
local var_0_26 = bit.band
local var_0_27 = math.abs
local var_0_28 = math.floor
local var_0_29 = math.min
local var_0_30 = math.max
local var_0_31 = math.sqrt
local var_0_32 = math.pow
local var_0_33 = string.rep
local var_0_34 = string.sub
local var_0_35 = require("gamesense/csgo_weapons")
local var_0_36 = require("ffi")
local var_0_37 = require("vector")
local var_0_38 = {
	right_foot = 12,
	left_foot = 11,
	right_thigh = 8,
	left_thigh = 7,
	chest = 5,
	thorax = 4,
	body = 3,
	pelvis = 2,
	head = 0,
	right_forearm = 18,
	right_upper_arm = 17,
	left_forearm = 16,
	left_upper_arm = 15,
	right_hand = 14,
	left_hand = 13
}
local var_0_39 = {
	onground = bit.lshift(1, 0),
	fakeclient = bit.lshift(1, 9)
}
local var_0_40 = {
	awp = 9,
	r8_revolver = 64
}
local var_0_41 = {
	f3 = 114,
	xbutton2 = 6
}
local var_0_42 = 15
local var_0_43 = var_0_36.cast(var_0_36.typeof("bool(__cdecl*)(float flFromX, float flFromY, float flFromZ, float flToX, float flToY, float flToZ)"), client.find_signature("client.dll", "U\x8B\xEC\x83\xEC\b\x8B\x15\xCC\xCC\xCC\xCC\x0F") or error("client.dll!::LineGoesThroughSmoke could not be found. Signature is outdated."))
local var_0_44 = "nyaahook!"
local var_0_45 = 32
local var_0_46 = 3.3
local var_0_47 = 0.03
local var_0_48 = 4000
local var_0_49 = 4
local var_0_50 = 1500
local var_0_51 = 100
local var_0_52 = {
	var_0_38.head,
	var_0_38.left_foot,
	var_0_38.right_foot,
	var_0_38.left_hand,
	var_0_38.right_hand
}
local var_0_53 = 17
local var_0_54 = {
	var_0_38.left_hand,
	var_0_38.right_hand,
	var_0_38.left_foot,
	var_0_38.right_foot,
	var_0_38.head,
	var_0_38.left_thigh,
	var_0_38.right_thigh,
	var_0_38.left_upper_arm,
	var_0_38.right_upper_arm,
	var_0_38.left_forearm,
	var_0_38.right_forearm,
	var_0_38.pelvis,
	var_0_38.body,
	var_0_38.chest,
	var_0_38.thorax
}
local var_0_55 = 30
local var_0_56 = {
	{
		0,
		0
	},
	{
		var_0_55,
		0
	},
	{
		-var_0_55,
		0
	},
	{
		0,
		var_0_55
	},
	{
		0,
		-var_0_55
	}
}
local var_0_57 = 75
local var_0_58 = {
	smg = "Submachine Gun",
	machinegun = "Machine gun",
	pistol = "Pistol",
	sniperrifle = "Sniper rifle",
	shotgun = "Shotgun",
	rifle = "Rifle"
}
local var_0_59, var_0_60 = ui.reference("RAGE", "Aimbot", "Enabled")
local var_0_61 = ui.reference("RAGE", "Aimbot", "Avoid unsafe hitboxes")
local var_0_62 = ui.reference("RAGE", "Other", "Automatic fire")
local var_0_63 = ui.reference("RAGE", "Other", "Automatic penetration")
local var_0_64 = ui.reference("RAGE", "Other", "Maximum FOV")
local var_0_65 = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
local var_0_66 = ui.new_checkbox("LUA", "A", "nyaahook!")
local var_0_67 = ui.new_checkbox("LUA", "A", "Dynamic FOV")
local var_0_68 = ui.new_color_picker("LUA", "A", "Dynamic FOV", 255, 255, 255, 0)
local var_0_69 = ui.new_slider("LUA", "A", "Minimum FOV", 1, 35, 3, true, "°", 1)
local var_0_70 = ui.new_slider("LUA", "A", "Maximum FOV", 1, 35, 15, true, "°", 1)
local var_0_71 = ui.new_checkbox("LUA", "A", "Automatic fire")
local var_0_72 = ui.new_hotkey("LUA", "A", "Automatic fire", true, var_0_41.xbutton2)
local var_0_73 = ui.new_checkbox("LUA", "A", "Automatic penetration")
local var_0_74 = ui.new_hotkey("LUA", "A", "Automatic penetration", true, var_0_41.f3)
local var_0_75 = ui.new_color_picker("LUA", "A", "Automatic penetration", 255, 255, 255, 0)
local var_0_76 = ui.new_slider("LUA", "A", "Minimum visible hitboxes", 0, 4, 0, true, "", 1, {
	[0] = "Disabled",
	"1+/hotkey",
	"2+/hotkey",
	"3+/hotkey",
	"4+/hotkey"
})
local var_0_77 = ui.new_checkbox("LUA", "A", "Automatic penetration overrides visibility")
local var_0_78 = ui.new_checkbox("LUA", "A", "Prioritize AWP users")
local var_0_79 = ui.new_checkbox("LUA", "A", "Rage aimbot delay")
local var_0_80 = ui.new_slider("LUA", "A", "Rage aimbot reaction time", 1, 200, 125, true, "ms")
local var_0_81 = ui.new_checkbox("LUA", "A", "Ignore airborne enemies")
local var_0_82 = ui.new_slider("LUA", "A", "Post-jump reaction time", 0, 1000, 500, true, "ms", 1, {
	[0] = "∞",
	[1000] = "1s"
})
local var_0_83 = ui.new_checkbox("LUA", "A", "Ignore enemies behind smokes")
local var_0_84 = ui.new_checkbox("LUA", "A", "Do not fire while blind")
local var_0_85 = ui.new_slider("LUA", "A", "Blindness duration threshold", 1, 100, 44, true, "s", 0.05, {
	[100] = "∞"
})
local var_0_86 = ui.new_checkbox("LUA", "A", "Force head safety on legit anti-aim users")
local var_0_87 = ui.new_checkbox("LUA", "A", "Extra rage aimbot hotkeys")
local var_0_88 = ui.new_multiselect("LUA", "A", "Hotkey ignored weapon groups", {
	"Pistol",
	"Submachine Gun",
	"Rifle",
	"Shotgun",
	"Machine gun",
	"Sniper rifle"
})
local var_0_89 = ui.new_slider("LUA", "A", "Rage aimbot hotkey count", 1, 5, 2, true)
local var_0_90 = {}

for iter_0_0 = 1, 5 do
	var_0_90[iter_0_0] = ui.new_hotkey("LUA", "A", var_0_24("Rage aimbot hotkey #%d", iter_0_0), false)
end

local var_0_91 = ui.new_checkbox("LUA", "A", "Clan tag spammer")
local var_0_92
local var_0_93 = 0
local var_0_94 = 0
local var_0_95 = {}
local var_0_96 = {}
local var_0_97 = {}
local var_0_98 = {}
local var_0_99 = {}
local var_0_100
local var_0_101
local var_0_102 = false
local var_0_103 = 0
local var_0_104
local var_0_105 = false

local function var_0_106()
	return var_0_13() ~= nil
end

local function var_0_107(arg_2_0)
	local var_2_0 = var_0_2(arg_2_0)

	if var_2_0 ~= nil then
		return var_0_5(var_2_0, "m_iItemDefinitionIndex")
	end

	return nil
end

local function var_0_108(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_2 >= var_0_50 then
		return arg_3_0
	elseif arg_3_2 <= var_0_51 then
		return arg_3_1
	end

	return var_0_29(arg_3_1, var_0_30(arg_3_0, var_0_48 / arg_3_2))
end

local function var_0_109(arg_4_0)
	local var_4_0 = var_0_3(true)

	for iter_4_0 = 1, #var_4_0 do
		arg_4_0(var_4_0[iter_4_0])
	end
end

local function var_0_110(arg_5_0)
	return arg_5_0 ~= nil and not var_0_8(arg_5_0) and var_0_7(arg_5_0)
end

local function var_0_111()
	local var_6_0 = var_0_4()
	local var_6_1 = var_0_37(var_0_20())
	local var_6_2 = var_0_48

	var_0_109(function(arg_7_0)
		local var_7_0 = var_0_37(var_0_6(arg_7_0, var_0_38.head))
		local var_7_1 = var_6_1:dist(var_7_0)

		if var_7_1 < var_6_2 then
			var_6_2 = var_7_1
		end
	end)

	return var_6_2
end

local function var_0_112(arg_8_0, arg_8_1)
	for iter_8_0 = 1, #arg_8_0 do
		if arg_8_0[iter_8_0] == arg_8_1 then
			return true
		end
	end

	return false
end

local function var_0_113()
	return var_0_0(var_0_59) and var_0_0(var_0_60)
end

local function var_0_114()
	return var_0_0(var_0_74) and var_0_0(var_0_77)
end

local function var_0_115()
	local var_11_0, var_11_1 = var_0_19()

	return {
		var_11_0 / 2,
		var_11_1 / 2
	}
end

local function var_0_116(arg_12_0, arg_12_1)
	return var_0_31(var_0_32(arg_12_0[1] - arg_12_1[1], 2) + var_0_32(arg_12_0[2] - arg_12_1[2], 2))
end

local function var_0_117()
	local var_13_0 = var_0_115()
	local var_13_1
	local var_13_2 = 8192

	var_0_109(function(arg_14_0)
		local var_14_0, var_14_1, var_14_2 = var_0_6(arg_14_0, var_0_38.head)
		local var_14_3, var_14_4 = var_0_22(var_14_0, var_14_1, var_14_2)

		if var_14_3 == nil then
			return
		end

		local var_14_5 = var_0_116(var_13_0, {
			var_14_3,
			var_14_4
		})

		if var_14_5 < var_13_2 then
			var_13_2 = var_14_5
			var_13_1 = arg_14_0
		end
	end)

	return var_13_1
end

local function var_0_118(arg_15_0)
	if arg_15_0 >= #var_0_44 then
		arg_15_0 = var_0_45 - arg_15_0
	end

	return var_0_34(var_0_44, 1, arg_15_0)
end

local function var_0_119(arg_16_0)
	local var_16_0 = var_0_118(arg_16_0)

	return var_16_0 .. var_0_33(" ", var_0_42 - #var_16_0)
end

local function var_0_120()
	return var_0_10() + var_0_17()
end

local function var_0_121()
	local var_18_0 = #var_0_44

	if not var_0_102 then
		var_18_0 = var_0_28(var_0_120() * var_0_46) % var_0_45
	end

	return var_0_119(var_18_0)
end

local function var_0_122()
	var_0_93 = 0
	var_0_94 = 0
	var_0_99 = {}
	var_0_100 = nil
	var_0_95 = {}
	var_0_96 = {}
	var_0_97 = {}
	var_0_103 = 0
	var_0_102 = false
end

local function var_0_123()
	if not var_0_113() and var_0_11() % var_0_49 ~= 0 then
		return
	end

	local var_20_0 = var_0_0(var_0_69)
	local var_20_1 = var_0_0(var_0_70)
	local var_20_2 = var_20_0

	if var_20_0 ~= var_20_1 then
		var_20_2 = var_0_108(var_20_0, var_20_1, var_0_111())
	end

	var_0_1(var_0_64, var_20_2)
end

local function var_0_124()
	var_0_1(var_0_62, var_0_0(var_0_72))
end

local function var_0_125()
	local var_22_0 = var_0_0(var_0_73)
	local var_22_1 = var_0_0(var_0_79)

	if not var_22_0 and not var_22_1 then
		return
	end

	local var_22_2 = var_0_10()
	local var_22_3 = var_0_0(var_0_74)

	if var_0_110(var_0_100) then
		local var_22_4 = var_0_0(var_0_76)
		local var_22_5 = var_0_4()
		local var_22_6, var_22_7, var_22_8 = var_0_20()
		local var_22_9 = 0

		for iter_22_0 = 1, #var_0_54 do
			local var_22_10, var_22_11, var_22_12 = var_0_6(var_0_100, var_0_54[iter_22_0])

			if var_22_10 == nil then
				break
			end

			local var_22_13, var_22_14 = var_0_16(var_22_5, var_22_6, var_22_7, var_22_8, var_22_10, var_22_11, var_22_12)

			if var_22_14 == var_0_100 then
				var_22_9 = var_22_9 + 1

				if var_0_97[var_0_100] == nil then
					var_0_97[var_0_100] = var_22_2
				end

				if not var_22_0 then
					break
				end
			end

			if not var_22_3 and var_22_4 > 0 and var_22_4 <= var_22_9 then
				var_22_3 = true

				break
			end
		end

		local var_22_15 = var_0_0(var_0_80) / 1000

		if var_0_97[var_0_100] ~= nil then
			if var_22_9 == 0 then
				var_0_97[var_0_100] = nil
			elseif not var_0_114() and var_22_1 and var_22_2 < var_0_97[var_0_100] + var_22_15 then
				var_0_98[var_0_100] = true
			end
		end
	end

	if var_22_0 then
		var_0_1(var_0_63, var_22_3)
	end
end

local function var_0_126()
	local var_23_0 = false
	local var_23_1 = var_0_4()
	local var_23_2 = var_0_107(var_23_1)

	if not var_0_112(var_0_0(var_0_88), var_0_58[var_0_35[var_23_2].type]) then
		local var_23_3 = var_0_0(var_0_89)

		for iter_23_0 = 1, var_23_3 do
			if var_0_0(var_0_90[iter_23_0]) then
				var_23_0 = true

				break
			end
		end
	end

	var_0_1(var_0_60, var_23_0 and "Always on" or "On hotkey")
end

local function var_0_127()
	var_0_109(function(arg_25_0)
		var_0_15(arg_25_0, "High priority", var_0_107(arg_25_0) == var_0_40.awp)
	end)
end

local function var_0_128()
	if var_0_114() then
		return
	end

	local var_26_0 = false
	local var_26_1 = var_0_21("CSmokeGrenadeProjectile")
	local var_26_2 = var_0_11()
	local var_26_3 = var_0_12()

	for iter_26_0 = 1, #var_26_1 do
		if var_0_5(var_26_1[iter_26_0], "m_bDidSmokeEffect") == 1 and var_26_2 < var_0_5(var_26_1[iter_26_0], "m_nSmokeEffectTickBegin") + var_0_53 / var_26_3 then
			var_26_0 = true
		end
	end

	if not var_26_0 then
		return
	end

	local var_26_4, var_26_5, var_26_6 = var_0_20()

	var_0_109(function(arg_27_0)
		if var_0_98[arg_27_0] then
			return
		end

		local var_27_0 = true

		for iter_27_0 = 1, #var_0_52 do
			if not var_27_0 then
				break
			end

			local var_27_1 = var_0_37(var_0_6(arg_27_0, var_0_52[iter_27_0]))

			for iter_27_1 = 1, #var_0_56 do
				if not var_0_43(var_26_4, var_26_5, var_26_6, var_27_1.x + var_0_56[iter_27_1][1], var_27_1.y + var_0_56[iter_27_1][2], var_27_1.z) then
					var_27_0 = false

					break
				end
			end
		end

		if var_27_0 then
			var_0_98[arg_27_0] = true
		end
	end)
end

local function var_0_129()
	local var_28_0 = var_0_0(var_0_82) / 1000
	local var_28_1 = var_0_10()

	var_0_109(function(arg_29_0)
		if var_0_96[arg_29_0] == nil then
			return
		end

		if var_0_26(var_0_5(arg_29_0, "m_fFlags"), var_0_39.onground) > 0 then
			return
		end

		if var_28_0 == 0 or var_28_1 < var_0_96[arg_29_0] + var_28_0 then
			var_0_98[arg_29_0] = true
		end
	end)
end

local function var_0_130()
	if not var_0_113() or var_0_114() then
		return
	end

	local var_30_0 = var_0_4()
	local var_30_1 = var_0_107(var_30_0)
	local var_30_2 = var_0_34(var_0_35[var_30_1].type, 1, 1)

	if var_30_2 ~= "p" and var_30_2 ~= "s" and var_30_2 ~= "r" and var_30_2 ~= "m" then
		return
	end

	local var_30_3 = var_0_5(var_30_0, "m_flFlashDuration")
	local var_30_4 = var_0_0(var_0_85) * 0.05
	local var_30_5 = var_0_10()

	if var_30_3 > 0 then
		if var_0_93 == 0 then
			var_0_94 = var_30_5
		end

		if var_30_5 - var_0_94 < var_30_3 - var_30_4 then
			var_0_109(function(arg_31_0)
				var_0_98[arg_31_0] = true
			end)
		end
	end

	var_0_93 = var_30_3
end

local function var_0_131()
	local var_32_0 = var_0_12()
	local var_32_1 = 16

	var_0_109(function(arg_33_0)
		if var_0_26(var_0_5(arg_33_0, "m_fFlags"), var_0_39.fakeclient) > 0 then
			return
		end

		local var_33_0 = var_0_5(arg_33_0, "m_flSimulationTime")
		local var_33_1 = var_0_5(arg_33_0, "m_angEyeAngles[0]")
		local var_33_2
		local var_33_3

		if var_0_95[arg_33_0] == nil or not var_0_14(arg_33_0, "Correction active") then
			-- block empty
		elseif var_0_37(var_0_5(arg_33_0, "m_vecVelocity")):length2d() < 0.01 then
			-- block empty
		else
			local var_33_4 = (var_33_0 - var_0_95[arg_33_0]) / var_32_0

			if var_33_4 <= 1 or var_33_4 > var_32_1 then
				-- block empty
			elseif var_0_27(var_33_1) <= var_0_57 then
				var_0_99[arg_33_0] = true
			end
		end

		var_0_95[arg_33_0] = var_33_0
	end)

	local var_32_2 = var_0_0(var_0_61)

	if var_0_99[var_0_100] then
		if var_32_2[1] ~= "Head" then
			var_32_2[#var_32_2 + 1] = "Head"
		end
	elseif var_32_2[1] == "Head" then
		var_32_2[1] = ""
	end

	var_0_1(var_0_61, var_32_2)
end

local function var_0_132()
	var_0_109(function(arg_35_0)
		var_0_15(arg_35_0, "Add to whitelist", var_0_98[arg_35_0])
	end)

	var_0_98 = {}
end

local function var_0_133()
	local var_36_0 = var_0_120()

	if not var_0_105 and (var_36_0 - var_0_103 < var_0_47 or var_0_9() > 0) then
		return
	end

	local var_36_1 = var_0_121()

	if var_36_1 ~= var_0_104 or var_0_105 then
		var_0_18(var_36_1)

		var_0_104 = var_36_1
		var_0_105 = false
	end

	var_0_103 = var_36_0
end

local function var_0_134()
	if var_0_0(var_0_91) then
		var_0_133()
	end
end

local function var_0_135()
	local var_38_0 = {
		{
			var_0_67,
			var_0_123
		},
		{
			var_0_71,
			var_0_124
		},
		{
			var_0_87,
			var_0_126
		},
		{
			var_0_78,
			var_0_127
		},
		{
			var_0_81,
			var_0_129
		},
		{
			var_0_84,
			var_0_130
		},
		{
			var_0_83,
			var_0_128
		},
		{
			var_0_86,
			var_0_131
		}
	}

	for iter_38_0 = 1, #var_38_0 do
		if var_0_0(var_38_0[iter_38_0][1]) then
			var_38_0[iter_38_0][2]()
		end
	end

	var_0_125()
	var_0_132()
end

local function var_0_136()
	local var_39_0, var_39_1, var_39_2, var_39_3 = var_0_0(var_0_68)

	if var_39_3 > 0 then
		var_0_23(var_39_0, var_39_1, var_39_2, var_39_3, var_0_24("FOV: %d°", var_0_0(var_0_64)))
	end
end

local function var_0_137()
	if not var_0_0(var_0_74) then
		return
	end

	local var_40_0, var_40_1, var_40_2, var_40_3 = var_0_0(var_0_75)

	if var_40_3 > 0 then
		var_0_23(var_40_0, var_40_1, var_40_2, var_40_3, "AWALL")
	end
end

local function var_0_138()
	if not var_0_7(var_0_4()) then
		return
	end

	local var_41_0 = {
		{
			var_0_67,
			var_0_136
		},
		{
			var_0_73,
			var_0_137
		}
	}

	for iter_41_0 = 1, #var_41_0 do
		if var_0_0(var_41_0[iter_41_0][1]) then
			var_41_0[iter_41_0][2]()
		end
	end

	local var_41_1 = var_0_11()

	if var_41_1 ~= var_0_101 then
		var_0_100 = var_0_117()
		var_0_101 = var_41_1
	end
end

local function var_0_139(arg_42_0)
	if client.userid_to_entindex(arg_42_0.userid) == var_0_4() then
		var_0_122()
	end
end

local function var_0_140(arg_43_0)
	local var_43_0 = client.userid_to_entindex(arg_43_0.userid)

	var_0_96[var_43_0] = var_0_10()
end

local function var_0_141()
	var_0_122()
end

local function var_0_142()
	var_0_102 = true
end

local function var_0_143(arg_46_0, arg_46_1)
	for iter_46_0 = 1, #arg_46_0 do
		ui.set_callback(arg_46_0[iter_46_0], arg_46_1)
	end

	for iter_46_1 = 1, #arg_46_0 do
		arg_46_1(arg_46_0[iter_46_1])
	end
end

local function var_0_144(arg_47_0, arg_47_1)
	for iter_47_0 = 1, #arg_47_0 do
		ui.set_visible(arg_47_0[iter_47_0], arg_47_1)
	end
end

local function var_0_145(arg_48_0)
	local var_48_0 = arg_48_0 and client.set_event_callback or client.unset_event_callback

	var_48_0("net_update_end", var_0_134)
	var_48_0("run_command", var_0_135)
	var_48_0("paint", var_0_138)
	var_48_0("player_spawn", var_0_139)
	var_48_0("player_jump", var_0_140)
	var_48_0("round_start", var_0_141)
	var_48_0("cs_win_panel_match", var_0_142)
	var_48_0("cs_win_panel_round", var_0_142)
	var_48_0("cs_pre_restart", var_0_142)
end

local function var_0_146()
	local var_49_0 = var_0_0(var_0_66)

	var_0_144({
		var_0_67,
		var_0_71,
		var_0_72,
		var_0_73,
		var_0_74,
		var_0_77,
		var_0_76,
		var_0_78,
		var_0_79,
		var_0_81,
		var_0_83,
		var_0_84,
		var_0_86,
		var_0_87,
		var_0_88,
		var_0_89,
		var_0_91
	}, var_49_0)

	local var_49_1 = var_0_0(var_0_67)

	var_0_144({
		var_0_68,
		var_0_69,
		var_0_70
	}, var_49_0 and var_49_1)

	local var_49_2 = var_0_0(var_0_73)

	var_0_144({
		var_0_77,
		var_0_76,
		var_0_75
	}, var_49_0 and var_49_2)

	local var_49_3 = var_0_0(var_0_79)

	var_0_144({
		var_0_80
	}, var_49_0 and var_49_3)

	local var_49_4 = var_0_0(var_0_81)

	var_0_144({
		var_0_82
	}, var_49_0 and var_49_4)

	local var_49_5 = var_0_0(var_0_84)

	var_0_144({
		var_0_85
	}, var_49_0 and var_49_5)

	local var_49_6 = var_0_0(var_0_87)

	var_0_144({
		var_0_89,
		var_0_88
	}, var_49_0 and var_49_6)

	local var_49_7 = var_0_0(var_0_89)

	for iter_49_0 = 1, #var_0_90 do
		var_0_144({
			var_0_90[iter_49_0]
		}, var_49_0 and var_49_6 and iter_49_0 <= var_49_7)
	end

	if var_49_0 ~= var_0_92 then
		var_0_145(var_49_0)
	end

	var_0_92 = var_49_0
end

local function var_0_147(arg_50_0)
	local var_50_0 = var_0_0(arg_50_0)

	if arg_50_0 == var_0_69 and var_50_0 > var_0_0(var_0_70) then
		var_0_1(var_0_70, var_50_0)
	elseif arg_50_0 == var_0_70 and var_50_0 < var_0_0(var_0_69) then
		var_0_1(var_0_69, var_50_0)
	end
end

local function var_0_148(arg_51_0)
	if arg_51_0 == var_0_65 and var_0_0(arg_51_0) then
		var_0_1(var_0_91, false)
	elseif arg_51_0 == var_0_91 then
		if var_0_0(arg_51_0) then
			var_0_1(var_0_65, false)
		else
			client.delay_call(var_0_12(), function()
				cvar.cl_clanid:invoke_callback()
			end)
		end
	end
end

var_0_143({
	var_0_66,
	var_0_67,
	var_0_73,
	var_0_79,
	var_0_81,
	var_0_84,
	var_0_87,
	var_0_89
}, var_0_146)
var_0_143({
	var_0_69,
	var_0_70
}, var_0_147)
var_0_143({
	var_0_65,
	var_0_91
}, var_0_148)
