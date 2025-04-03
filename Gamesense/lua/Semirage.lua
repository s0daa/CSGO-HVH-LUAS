local var_0_0 = client.camera_angles
local var_0_1 = client.create_interface
local var_0_2 = client.delay_call
local var_0_3 = client.eye_position
local var_0_4 = client.find_signature
local var_0_5 = client.latency
local var_0_6 = client.register_esp_flag
local var_0_7 = client.reload_active_scripts
local var_0_8 = client.screen_size
local var_0_9 = client.set_event_callback
local var_0_10 = client.trace_line
local var_0_11 = client.update_player_list
local var_0_12 = client.userid_to_entindex
local var_0_13 = database.read
local var_0_14 = database.write
local var_0_15 = entity.get_classname
local var_0_16 = entity.get_local_player
local var_0_17 = entity.get_player_name
local var_0_18 = entity.get_player_weapon
local var_0_19 = entity.get_players
local var_0_20 = entity.get_prop
local var_0_21 = entity.hitbox_position
local var_0_22 = entity.is_alive
local var_0_23 = entity.is_enemy
local var_0_24 = error
local var_0_25 = globals.absoluteframetime
local var_0_26 = globals.curtime
local var_0_27 = math.abs
local var_0_28 = math.atan2
local var_0_29 = math.cos
local var_0_30 = math.floor
local var_0_31 = math.pow
local var_0_32 = math.rad
local var_0_33 = math.sin
local var_0_34 = math.sqrt
local var_0_35 = plist.get
local var_0_36 = renderer.indicator
local var_0_37 = renderer.text
local var_0_38 = renderer.world_to_screen
local var_0_39 = string.format
local var_0_40 = ui.get
local var_0_41 = ui.new_color_picker
local var_0_42 = ui.new_combobox
local var_0_43 = ui.new_hotkey
local var_0_44 = ui.new_label
local var_0_45 = ui.new_multiselect
local var_0_46 = ui.new_slider
local var_0_47 = ui.reference
local var_0_48 = ui.set
local var_0_49 = require
local var_0_50 = ui.set_callback
local var_0_51 = ui.set_visible
local var_0_52 = pairs
local var_0_53 = print
local var_0_54 = var_0_49("gamesense/uix")
local var_0_55 = var_0_13("location") or "LUA - A"
local var_0_56 = {
	rage = {
		enabled = {
			var_0_47("RAGE", "Aimbot", "Enabled")
		},
		fire = var_0_47("RAGE", "Other", "Automatic fire"),
		penetration = var_0_47("RAGE", "Other", "Automatic penetration"),
		fov = var_0_47("RAGE", "Other", "Maximum FOV"),
		baim = var_0_47("RAGE", "Aimbot", "Force body aim"),
		logs = var_0_47("RAGE", "Other", "Log misses due to spread"),
		fake_duck = var_0_47("RAGE", "Other", "Duck peek assist")
	},
	aa = {
		enabled = var_0_47("AA", "Anti-aimbot angles", "Enabled"),
		pitch = var_0_47("AA", "Anti-aimbot angles", "Pitch"),
		yaw_base = var_0_47("AA", "Anti-aimbot angles", "Yaw base"),
		yaw = {
			var_0_47("AA", "Anti-aimbot angles", "Yaw")
		},
		yaw_jitter = {
			var_0_47("AA", "Anti-aimbot angles", "Yaw jitter")
		},
		body_yaw = {
			var_0_47("AA", "Anti-aimbot angles", "Body yaw")
		},
		fs_body_yaw = var_0_47("AA", "Anti-aimbot angles", "Freestanding body yaw"),
		edge_yaw = var_0_47("AA", "Anti-aimbot angles", "Edge yaw"),
		fs = {
			var_0_47("AA", "Anti-aimbot angles", "Freestanding")
		},
		slow_motion = {
			var_0_47("AA", "Other", "Slow motion")
		}
	},
	players = {
		body_yaw = var_0_47("PLAYERS", "Adjustments", "Force body yaw"),
		body_yaw_value = var_0_47("PLAYERS", "Adjustments", "Force body yaw value"),
		whitelist = var_0_47("PLAYERS", "Adjustments", "Add to whitelist"),
		apply_all = var_0_47("PLAYERS", "Adjustments", "Apply to all"),
		reset_all = var_0_47("PLAYERS", "Players", "Reset all"),
		lists = var_0_47("PLAYERS", "Players", "Player list")
	},
	useless_features = {
		double_tap = {
			var_0_47("RAGE", "Aimbot", "Double tap")
		},
		double_tap_hitchance = var_0_47("RAGE", "Aimbot", "Double tap hit chance"),
		double_tap_fl_limit = var_0_47("RAGE", "Aimbot", "Double tap fake lag limit"),
		double_tap_options = var_0_47("RAGE", "Aimbot", "Double tap quick stop"),
		on_shot_aa = {
			var_0_47("AA", "Other", "On shot anti-aim")
		},
		fake_peek = var_0_47("AA", "Other", "Fake peek")
	},
	location = var_0_42("MISC", "Miscellaneous", "Location ui semirage", "RAGE - Other", "LUA - A", "LUA - B")
}

if var_0_55 == "RAGE - Other" then
	tab, container = "RAGE", "Other"

	var_0_48(var_0_56.location, "RAGE - Other")
elseif var_0_55 == "LUA - A" then
	tab, container = "LUA", "A"

	var_0_48(var_0_56.location, "LUA - A")
elseif var_0_55 == "LUA - B" then
	tab, container = "LUA", "B"

	var_0_48(var_0_56.location, "LUA - B")
end

local var_0_57 = {
	improvements_modes = {
		"Snipers",
		"Deagle",
		"Pistols",
		"Others"
	},
	improvements_nades = {
		"Smoke",
		"Flash"
	},
	penetration = {
		"On hotkey",
		"Visible"
	},
	dynamicfov = {
		"Snipers",
		"Deagle",
		"Pistols",
		"Others"
	},
	aa_type = {
		"Manual",
		"Dynamic"
	},
	aa_mode = {
		"Safe",
		"Unsafe"
	},
	aa_lby = {
		"Off",
		"Sway",
		"Opposite",
		"Eye yaw"
	},
	aa_security = {
		"Minimized",
		"Velocity",
		"Fake duck",
		"FPS",
		"Ping",
		"Choke",
		"Loss",
		"Hide sliders"
	},
	aa_indicators = {
		"Crosshair",
		"Arrow"
	},
	indicators_types = {
		"Default",
		"Crosshair"
	},
	indicators = {
		"Bruteforce",
		"FOV",
		"Automatic fire",
		"Automatic penetration",
		"Force body aim"
	},
	flags = {
		"FAKE",
		"Bruteforce"
	}
}
local var_0_58 = {
	rage = {
		enabled = var_0_54.new_checkbox(tab, container, "Semirage"),
		improvements = var_0_54.new_checkbox(tab, container, "Improvements"),
		improvements_mode = {
			var_0_45(tab, container, "Aimbot improvements", var_0_57.improvements_modes)
		},
		improvements_hotkey = var_0_43(tab, container, "\naimbot_improvements_modes", true, 1),
		improvements_nades = {
			var_0_45(tab, container, "Disable aimbot", var_0_57.improvements_nades)
		},
		fire = var_0_54.new_checkbox(tab, container, "Automatic fire"),
		fire_hotkey = var_0_43(tab, container, "Automatic fire", true),
		penetration = var_0_54.new_checkbox(tab, container, "Automatic penetration"),
		penetration_hotkey = var_0_43(tab, container, "Automatic penetration", true),
		penetration_mode = {
			var_0_45(tab, container, "\npenetration_modes", var_0_57.penetration)
		},
		penetreation_slider = var_0_46(tab, container, "when X hitboxes visible", 0, 12, 2, true),
		dynamicfov = var_0_54.new_checkbox(tab, container, "Dynamic FOV"),
		dynamicfov_mode = var_0_42(tab, container, "\ndynamic_fov_modes", var_0_57.dynamicfov),
		dynamicfov_autofactor = var_0_46(tab, container, "Dynamic FOV auto factor", 0, 250, 100, true, "x", 0.01),
		dynamicfov_min_snipers = var_0_46(tab, container, "Snipers Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_snipers = var_0_46(tab, container, "Snipers Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_deagle = var_0_46(tab, container, "Deagle Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_deagle = var_0_46(tab, container, "Deagle Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_pistols = var_0_46(tab, container, "Pistols Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_pistols = var_0_46(tab, container, "Pistols Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_others = var_0_46(tab, container, "Others Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_others = var_0_46(tab, container, "Others Dynamic FOV max", 1, 180, 10, true, "°", 1),
		bruteforce = var_0_54.new_checkbox(tab, container, "Bruteforce"),
		bruteforce_hotkey = var_0_43(tab, container, "\bbuteforce_hotkey", true),
		advanced_logs = var_0_54.new_checkbox(tab, container, "Advanced logs")
	},
	aa = {
		enabled = var_0_54.new_checkbox("AA", "Anti-aimbot angles", "Legit AA"),
		type = var_0_42("AA", "Anti-aimbot angles", "\naa_type", var_0_57.aa_type),
		hotkey = var_0_43("AA", "Anti-aimbot angles", "\naa_hotkey", true),
		mode = var_0_42("AA", "Anti-aimbot angles", "Freestanding mode", var_0_57.aa_mode),
		mode_hotkey = var_0_43("AA", "Anti-aimbot angles", "\nfreestanding_mode_hotkey", true),
		lby_target = var_0_42("AA", "Anti-aimbot angles", "Lower body yaw target", var_0_57.aa_lby),
		security = {
			var_0_45("AA", "Anti-aimbot angles", "Security", var_0_57.aa_security)
		},
		velocity = var_0_46("AA", "Anti-aimbot angles", "Velocity max", 1, 250, 150, true, "u"),
		fps = var_0_46("AA", "Anti-aimbot angles", "FPS min", 0, 300, 60),
		ping = var_0_46("AA", "Anti-aimbot angles", "Ping min", 1, 200, 80, true, "ms"),
		choke = var_0_46("AA", "Anti-aimbot angles", "Choke min", 1, 10, 2, true, "%"),
		loss = var_0_46("AA", "Anti-aimbot angles", "Loss min", 1, 10, 2, true, "%"),
		indicators = var_0_42("AA", "Anti-aimbot angles", "Indicators", var_0_57.aa_indicators),
		label_text = var_0_44("AA", "Anti-aimbot angles", "Color for the text"),
		color_text = var_0_41("AA", "Anti-aimbot angles", "\ncolor_for_the_text", 180, 238, 0, 255),
		label_real = var_0_44("AA", "Anti-aimbot angles", "Color for your real"),
		color_arrow_real = var_0_41("AA", "Anti-aimbot angles", "\ncolor_for_the_real", 180, 238, 0, 255),
		label_fake = var_0_44("AA", "Anti-aimbot angles", "Color for your fake"),
		color_arrow_fake = var_0_41("AA", "Anti-aimbot angles", "\ncolor_for_the_fake", 255, 0, 0, 255)
	},
	visuals = {
		indicators = var_0_54.new_checkbox(tab, container, "Indicators"),
		indicators_type = var_0_42(tab, container, "\nindicators_types", var_0_57.indicators_types),
		indicaotrs_color = var_0_41(tab, container, "\nindicators_color", 180, 238, 0, 255),
		indicators_mode = {
			var_0_45(tab, container, "Indicators modes", var_0_57.indicators)
		},
		flags = var_0_54.new_checkbox(tab, container, "Flags"),
		flags_mode = {
			var_0_45(tab, container, "\nflags_modes", var_0_57.flags)
		}
	}
}
local var_0_59 = {
	CWeaponFamas = "Others",
	CWeaponAug = "Others",
	CAK47 = "Others",
	CWeaponTec9 = "Pistols",
	CWeaponElite = "Pistols",
	CWeaponGlock = "Pistols",
	CWeaponP250 = "Pistols",
	CWeaponHKP2000 = "Pistols",
	CWeaponFiveSeven = "Pistols",
	CDEagle = "Deagle",
	CWeaponSSG08 = "Snipers",
	CWeaponAWP = "Snipers",
	CWeaponSCAR20 = "Snipers",
	CWeaponG3SG1 = "Snipers",
	CKnife = "Others",
	CWeaponXM1014 = "Others",
	CWeaponSawedoff = "Others",
	CWeaponNOVA = "Others",
	CWeaponMag7 = "Others",
	CWeaponNegev = "Others",
	CWeaponM249 = "Others",
	CWeaponUMP45 = "Others",
	CWeaponP90 = "Others",
	CWeaponBizon = "Others",
	CWeaponMP9 = "Others",
	CWeaponMP7 = "Others",
	CWeaponSG556 = "Others",
	CWeaponM4A1 = "Others",
	CWeaponGalilAR = "Others"
}
local var_0_60 = {
	in_fov = false,
	bruteforce = false,
	fire_improvements = false,
	fire = false,
	ft_prev = 0,
	hit_side = 0,
	last_hit = 0,
	last_side = 0,
	side = 1,
	visible_hitboxes = 0,
	hitgroup_names = {
		"generic",
		"head",
		"chest",
		"stomach",
		"left arm",
		"right arm",
		"left leg",
		"right leg",
		"neck",
		"?",
		"gear"
	},
	DEG_TO_RAD = math.pi / 180,
	RAD_TO_DEG = 180 / math.pi
}
local var_0_61 = var_0_49("ffi")
local var_0_62 = "U\x8B\xEC\x83\xEC\b\x8B\x15\xCC\xCC\xCC\xCC\x0FW"
local var_0_63 = var_0_4("client.dll", var_0_62) or var_0_24("client_find_signature problem")
local var_0_64 = var_0_61.cast(var_0_61.typeof("bool(__thiscall*)(float, float, float, float, float, float, short)"), var_0_63) or var_0_24("ffi.cast problem")
local var_0_65 = vtable_bind("engine.dll", "VEngineClient014", 196, "bool(__thiscall*)(void*)")
local var_0_66 = 0
local var_0_67 = 1
local var_0_68 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
local var_0_69 = vtable_thunk(11, "float(__thiscall*)(void*, int)")
local var_0_70 = vtable_thunk(12, "float(__thiscall*)(void*, int)")

local function var_0_71(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_0 do
		if arg_1_0[iter_1_0] == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_72(arg_2_0)
	local var_2_0, var_2_1, var_2_2 = var_0_20(arg_2_0, "m_vecVelocity")

	return var_0_30(var_0_34(var_2_0 * var_2_0 + var_2_1 * var_2_1 + var_2_2 * var_2_2) + 0.5)
end

local function var_0_73(arg_3_0, arg_3_1)
	local var_3_0 = 10^(arg_3_1 or 0)

	return var_0_30(arg_3_0 * var_3_0 + 0.5) / var_3_0
end

local function var_0_74()
	var_0_60.ft_prev = var_0_60.ft_prev * 0.9 + var_0_25() * 0.1

	return var_0_73(1 / var_0_60.ft_prev)
end

local function var_0_75()
	if var_0_58.aa.enabled:get() then
		var_0_48(var_0_56.aa.pitch, "Off")
		var_0_48(var_0_56.aa.yaw_base, "Local view")
		var_0_48(var_0_56.aa.yaw[1], "Off")
		var_0_48(var_0_56.aa.yaw_jitter[1], "Off")
		var_0_48(var_0_56.aa.body_yaw[1], "Static")
		var_0_48(var_0_56.aa.fs_body_yaw, false)
		var_0_48(var_0_56.aa.edge_yaw, false)
		var_0_48(var_0_56.aa.fs[1], "-")
	else
		var_0_48(var_0_56.aa.pitch, "Off")
		var_0_48(var_0_56.aa.yaw_base, "Local view")
		var_0_48(var_0_56.aa.yaw[1], "Off")
		var_0_48(var_0_56.aa.yaw_jitter[1], "Off")
		var_0_48(var_0_56.aa.body_yaw[1], "Off")
		var_0_48(var_0_56.aa.fs_body_yaw, false)
		var_0_48(var_0_56.aa.edge_yaw, false)
		var_0_48(var_0_56.aa.fs[1], "-")
	end
end

local function var_0_76(arg_6_0)
	if arg_6_0 == false then
		var_0_51(var_0_56.useless_features.double_tap[1], arg_6_0)
		var_0_51(var_0_56.useless_features.double_tap[2], arg_6_0)
		var_0_51(var_0_56.useless_features.double_tap_hitchance, arg_6_0)
		var_0_51(var_0_56.useless_features.double_tap_fl_limit, arg_6_0)
		var_0_51(var_0_56.useless_features.double_tap_options, arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[1], arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[1], arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[2], arg_6_0)
		var_0_51(var_0_56.useless_features.fake_peek, arg_6_0)
	else
		var_0_51(var_0_56.useless_features.double_tap[1], arg_6_0)
		var_0_51(var_0_56.useless_features.double_tap[2], arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[1], arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[1], arg_6_0)
		var_0_51(var_0_56.useless_features.on_shot_aa[2], arg_6_0)
		var_0_51(var_0_56.useless_features.fake_peek, arg_6_0)
	end
end

local function var_0_77(arg_7_0)
	var_0_51(var_0_56.aa.enabled, arg_7_0)
	var_0_51(var_0_56.aa.pitch, arg_7_0)
	var_0_51(var_0_56.aa.yaw_base, arg_7_0)
	var_0_51(var_0_56.aa.yaw[1], arg_7_0)
	var_0_51(var_0_56.aa.yaw[2], false)
	var_0_51(var_0_56.aa.yaw_jitter[1], arg_7_0)
	var_0_51(var_0_56.aa.yaw_jitter[2], false)
	var_0_51(var_0_56.aa.body_yaw[1], arg_7_0)
	var_0_51(var_0_56.aa.body_yaw[2], false)
	var_0_51(var_0_56.aa.fs_body_yaw, false)
	var_0_51(var_0_56.aa.edge_yaw, arg_7_0)
	var_0_51(var_0_56.aa.fs[1], arg_7_0)
	var_0_51(var_0_56.aa.fs[2], arg_7_0)
end

local function var_0_78(arg_8_0)
	local var_8_0 = var_0_40(arg_8_0)

	var_0_14("location", var_8_0)
	var_0_7()
end

var_0_50(var_0_56.location, var_0_78)

local function var_0_79(arg_9_0)
	local var_9_0 = var_0_40(var_0_58.rage.improvements_hotkey)
	local var_9_1 = var_0_40(var_0_58.rage.improvements_mode[1])
	local var_9_2 = var_0_59[var_0_15(var_0_18(var_0_16()))]

	if var_9_0 and var_0_71(var_9_1, var_9_2) then
		var_0_60.fire_improvements = true
	else
		var_0_60.fire_improvements = false
	end
end

local function var_0_80()
	local var_10_0 = var_0_40(var_0_58.rage.improvements_nades[1])

	if var_0_71(var_10_0, "Smoke") then
		var_0_11()

		local var_10_1 = var_0_16()
		local var_10_2 = {
			var_0_21(var_10_1, 0)
		}

		for iter_10_0, iter_10_1 in var_0_52(var_0_19(true)) do
			var_0_48(var_0_56.players.lists, iter_10_1)

			local var_10_3 = {
				var_0_21(iter_10_1, 0)
			}

			var_0_48(var_0_56.players.whitelist, var_0_64(var_10_2[1], var_10_2[2], var_10_2[3], var_10_3[1], var_10_3[2], var_10_3[3], 1))
		end
	end
end

local function var_0_81(arg_11_0)
	local var_11_0 = var_0_40(var_0_58.rage.improvements_nades[1])
	local var_11_1 = var_0_71(var_11_0, "Flash")
	local var_11_2 = var_0_16()

	if var_0_12(arg_11_0.userid) == var_11_2 and var_11_1 then
		var_0_2(0.1, function()
			local var_12_0 = var_0_20(var_11_2, "m_flFlashDuration")

			if var_12_0 >= 1 then
				var_0_48(var_0_56.rage.enabled[1], false)
				var_0_2(var_12_0, function()
					var_0_48(var_0_56.rage.enabled[1], true)
				end)
			end
		end)
	end
end

local function var_0_82(arg_14_0, arg_14_1)
	var_0_51(var_0_58.rage.improvements_mode[1], arg_14_1)
	var_0_51(var_0_58.rage.improvements_hotkey, arg_14_1)
	var_0_51(var_0_58.rage.improvements_nades[1], arg_14_1)
end

local function var_0_83(arg_15_0)
	if var_0_40(var_0_58.rage.fire_hotkey) then
		var_0_60.fire = true
	else
		var_0_60.fire = false
	end
end

local function var_0_84(arg_16_0, arg_16_1)
	var_0_51(var_0_58.rage.fire_hotkey, arg_16_1)
end

local function var_0_85()
	local var_17_0 = var_0_19(true)
	local var_17_1 = var_0_16()
	local var_17_2, var_17_3, var_17_4 = var_0_3()
	local var_17_5 = var_0_60.visible_hitboxes
	local var_17_6 = var_0_40(var_0_58.rage.penetreation_slider)

	for iter_17_0 = 1, #var_17_0 do
		local var_17_7 = var_17_0[iter_17_0]
		local var_17_8 = 0

		for iter_17_1 = 0, 18 do
			local var_17_9, var_17_10, var_17_11 = var_0_21(var_17_7, iter_17_1)
			local var_17_12, var_17_13 = var_0_10(var_17_1, var_17_2, var_17_3, var_17_4, var_17_9, var_17_10, var_17_11)

			if var_17_13 == var_17_7 and var_0_38(var_17_9, var_17_10, var_17_11) then
				var_17_8 = var_17_8 + 1
			end
		end

		if var_17_6 <= var_17_8 then
			return true
		end
	end

	return false
end

local function var_0_86()
	local var_18_0 = var_0_16()

	if not var_0_22(var_18_0) then
		return
	end

	local var_18_1 = var_0_40(var_0_58.rage.penetration_mode[1])
	local var_18_2 = var_0_71(var_18_1, "On hotkey")
	local var_18_3 = var_0_71(var_18_1, "Visible")
	local var_18_4 = var_0_40(var_0_58.rage.penetration_hotkey)

	if var_18_2 and var_18_4 or var_18_3 and var_0_85() then
		var_0_48(var_0_56.rage.penetration, true)
	else
		var_0_48(var_0_56.rage.penetration, false)
	end
end

local function var_0_87(arg_19_0)
	local var_19_0 = var_0_58.rage.penetration:get() and var_0_40(arg_19_0) or ""
	local var_19_1 = var_0_71(var_19_0, "On hotkey")
	local var_19_2 = var_0_71(var_19_0, "Visible")

	var_0_51(var_0_58.rage.penetration_hotkey, var_19_1)
	var_0_51(var_0_58.rage.penetreation_slider, var_19_2)
end

local function var_0_88(arg_20_0, arg_20_1)
	var_0_51(var_0_58.rage.penetration_mode[1], arg_20_1)
	var_0_51(var_0_58.rage.penetreation_slider, arg_20_1)
	var_0_87(var_0_58.rage.penetration_mode[1])
end

local function var_0_89()
	local var_21_0 = var_0_40(var_0_58.rage.dynamicfov_mode)
	local var_21_1 = var_0_40(var_0_58.rage.dynamicfov_autofactor)
	local var_21_2
	local var_21_3

	if var_21_0 == "Snipers" then
		var_21_2 = var_0_40(var_0_58.rage.dynamicfov_max_snipers)
		var_21_3 = var_0_40(var_0_58.rage.dynamicfov_min_snipers)
	elseif var_21_0 == "Deagle" then
		var_21_2 = var_0_40(var_0_58.rage.dynamicfov_max_deagle)
		var_21_3 = var_0_40(var_0_58.rage.dynamicfov_min_deagle)
	elseif var_21_0 == "Pistols" then
		var_21_2 = var_0_40(var_0_58.rage.dynamicfov_max_pistols)
		var_21_3 = var_0_40(var_0_58.rage.dynamicfov_min_pistols)
	elseif var_21_0 == "Others" then
		var_21_2 = var_0_40(var_0_58.rage.dynamicfov_max_others)
		var_21_3 = var_0_40(var_0_58.rage.dynamicfov_min_others)
	end

	if var_21_1 == nil or var_21_2 == nil or var_21_3 == nil then
		return
	end

	local var_21_4 = var_0_40(var_0_56.rage.fov)
	local var_21_5 = var_21_4
	local var_21_6 = var_0_19(true)

	if var_21_2 < var_21_3 then
		var_21_2, var_21_3 = var_21_3, var_21_2
	end

	if #var_21_6 ~= 0 then
		local var_21_7, var_21_8, var_21_9 = var_0_3()
		local var_21_10, var_21_11 = var_0_0()

		var_0_60.closest_enemy = nil

		local var_21_12 = 999999999

		for iter_21_0 = 1, #var_21_6 do
			local var_21_13 = var_21_6[iter_21_0]
			local var_21_14, var_21_15, var_21_16 = var_0_21(var_21_13, 0)
			local var_21_17 = var_21_14 - var_21_7
			local var_21_18 = var_21_15 - var_21_8
			local var_21_19 = var_21_16 - var_21_9
			local var_21_20 = var_0_28(var_21_18, var_21_17) * 180 / math.pi
			local var_21_21 = -(var_0_28(var_21_19, var_0_34(var_0_31(var_21_17, 2) + var_0_31(var_21_18, 2))) * 180 / math.pi)
			local var_21_22 = var_0_27(var_21_11 % 360 - var_21_20 % 360) % 360
			local var_21_23 = var_0_27(var_21_10 - var_21_21) % 360

			if var_21_22 > 180 then
				var_21_22 = 360 - var_21_22
			end

			local var_21_24 = var_0_34(var_0_31(var_21_22, 2) + var_0_31(var_21_23, 2))

			if var_21_24 < var_21_12 then
				var_21_12 = var_21_24
				var_0_60.closest_enemy = var_21_13
			end
		end

		if var_0_60.closest_enemy ~= nil then
			local var_21_25, var_21_26, var_21_27 = var_0_21(var_0_60.closest_enemy, 0)

			var_21_5 = 3800 / var_0_34(var_0_31(var_21_7 - var_21_25, 2) + var_0_31(var_21_8 - var_21_26, 2) + var_0_31(var_21_9 - var_21_27, 2)) * (var_0_40(var_0_58.rage.dynamicfov_autofactor) * 0.01)

			if var_21_2 < var_21_5 then
				var_21_5 = var_21_2
			elseif var_21_5 < var_21_3 then
				var_21_5 = var_21_3
			end
		end

		var_21_5 = var_0_30(var_21_5 + 0.5)

		if var_21_12 < var_21_5 then
			var_0_60.in_fov = true
		else
			var_0_60.in_fov = false
		end
	else
		var_21_5 = var_21_3
		var_0_60.in_fov = false
	end

	if var_21_5 ~= var_21_4 and (var_21_0 == "Snipers" or var_21_0 == "Deagle" or var_21_0 == "Pistols" or var_21_0 == "Others") then
		var_0_48(var_0_56.rage.fov, var_21_5)
	end
end

local function var_0_90(arg_22_0)
	local var_22_0 = var_0_16()
	local var_22_1 = var_0_18(var_22_0)
	local var_22_2 = var_0_15(var_22_1)

	if var_0_59[var_22_2] then
		var_0_48(var_0_58.rage.dynamicfov_mode, var_0_59[var_22_2])
	end
end

local function var_0_91(arg_23_0)
	local var_23_0 = var_0_58.rage.dynamicfov:get() and var_0_40(arg_23_0) or ""

	var_0_51(var_0_58.rage.dynamicfov_min_snipers, var_23_0 == "Snipers")
	var_0_51(var_0_58.rage.dynamicfov_max_snipers, var_23_0 == "Snipers")
	var_0_51(var_0_58.rage.dynamicfov_min_deagle, var_23_0 == "Deagle")
	var_0_51(var_0_58.rage.dynamicfov_max_deagle, var_23_0 == "Deagle")
	var_0_51(var_0_58.rage.dynamicfov_min_pistols, var_23_0 == "Pistols")
	var_0_51(var_0_58.rage.dynamicfov_max_pistols, var_23_0 == "Pistols")
	var_0_51(var_0_58.rage.dynamicfov_min_others, var_23_0 == "Others")
	var_0_51(var_0_58.rage.dynamicfov_max_others, var_23_0 == "Others")
end

local function var_0_92(arg_24_0, arg_24_1)
	var_0_51(var_0_58.rage.dynamicfov_mode, arg_24_1)
	var_0_51(var_0_58.rage.dynamicfov_autofactor, arg_24_1)
	var_0_91(var_0_58.rage.dynamicfov_mode)
end

local function var_0_93()
	local var_25_0 = var_0_40(var_0_56.players.body_yaw_value)

	var_0_11()

	if var_25_0 == 0 then
		var_0_48(var_0_56.players.body_yaw, true)
		var_0_48(var_0_56.players.body_yaw_value, 60)
		var_0_48(var_0_56.players.apply_all, true)

		var_0_60.bruteforce = false
	elseif var_25_0 == 60 then
		var_0_48(var_0_56.players.body_yaw, true)
		var_0_48(var_0_56.players.body_yaw_value, -60)
		var_0_48(var_0_56.players.apply_all, true)

		var_0_60.bruteforce = false
	elseif var_25_0 == -60 then
		var_0_48(var_0_56.players.reset_all, true)

		var_0_60.bruteforce = false
	end
end

local function var_0_94(arg_26_0)
	if var_0_40(var_0_58.rage.bruteforce_hotkey) then
		if var_0_60.bruteforce then
			var_0_93()

			var_0_60.bruteforce = false
		end
	else
		var_0_60.bruteforce = true
	end
end

local function var_0_95(arg_27_0, arg_27_1)
	var_0_51(var_0_58.rage.bruteforce_hotkey, arg_27_1)
end

local function var_0_96(arg_28_0)
	local var_28_0 = var_0_60.hitgroup_names[arg_28_0.hitgroup + 1] or "?"

	var_0_53(var_0_39("Missed %s (%s) due to %s", var_0_17(arg_28_0.target), var_28_0, arg_28_0.reason))
end

local function var_0_97(arg_29_0, arg_29_1)
	var_0_51(var_0_56.rage.logs, not arg_29_1)
	var_0_48(var_0_56.rage.logs, false)
end

local function var_0_98()
	local var_30_0 = var_0_16()

	if not var_0_22(var_30_0) then
		return
	end

	local var_30_1 = var_0_40(var_0_58.visuals.indicators_type)
	local var_30_2 = var_0_40(var_0_58.visuals.indicators_mode[1])
	local var_30_3 = var_0_71(var_30_2, "Bruteforce")
	local var_30_4 = var_0_71(var_30_2, "FOV")
	local var_30_5 = var_0_71(var_30_2, "Automatic fire")
	local var_30_6 = var_0_71(var_30_2, "Automatic penetration")
	local var_30_7 = var_0_71(var_30_2, "Force body aim")
	local var_30_8 = var_0_40(var_0_56.rage.fov)
	local var_30_9 = var_0_40(var_0_56.players.body_yaw_value)
	local var_30_10 = var_0_40(var_0_56.rage.fire)
	local var_30_11 = var_0_40(var_0_56.rage.penetration)
	local var_30_12 = var_0_40(var_0_56.rage.baim)
	local var_30_13, var_30_14, var_30_15, var_30_16 = var_0_40(var_0_58.visuals.indicaotrs_color)
	local var_30_17, var_30_18 = var_0_8()
	local var_30_19 = var_30_17 / 2
	local var_30_20 = var_30_18 / 2

	if var_30_1 == "Default" then
		if var_30_3 then
			if var_30_9 == 60 then
				var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "B:RIGHT")
			elseif var_30_9 == -60 then
				var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "B:LEFT")
			elseif var_30_9 == 0 then
				var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "B:OFF")
			end
		end

		if var_30_4 then
			var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "FOV: ", var_30_8, "°")
		end

		if var_30_5 and var_30_10 then
			var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "TM")
		end

		if var_30_6 and var_30_11 then
			var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "AW")
		end

		if var_30_7 and var_30_12 then
			var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "BAIM")
		end
	elseif var_30_1 == "Crosshair" then
		if var_30_3 then
			if var_30_9 == 60 then
				var_0_37(var_30_19, var_30_20 + 60, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "B:RIGHT")
			elseif var_30_9 == -60 then
				var_0_37(var_30_19, var_30_20 + 60, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "B:LEFT")
			elseif var_30_9 == 0 then
				var_0_37(var_30_19, var_30_20 + 60, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "B:OFF")
			end
		end

		if var_30_4 then
			var_0_36(var_30_13, var_30_14, var_30_15, var_30_16, "FOV: ", var_30_8, "°")
		end

		if var_30_5 and var_30_10 then
			var_0_37(var_30_19, var_30_20 + 30, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "TM")
		else
			var_0_37(var_30_19, var_30_20 + 30, 0, 0, 0, 50, "dcb", 0, "TM")
		end

		if var_30_6 and var_30_11 then
			var_0_37(var_30_19, var_30_20 + 40, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "AW")
		else
			var_0_37(var_30_19, var_30_20 + 40, 0, 0, 0, 50, "dcb", 0, "AW")
		end

		if var_30_7 and var_30_12 then
			var_0_37(var_30_19, var_30_20 + 50, var_30_13, var_30_14, var_30_15, var_30_16, "dcb", 0, "BAIM")
		else
			var_0_37(var_30_19, var_30_20 + 50, 0, 0, 0, 50, "dcb", 0, "BAIM")
		end
	end
end

local function var_0_99(arg_31_0, arg_31_1)
	var_0_51(var_0_58.visuals.indicaotrs_color, arg_31_1)
	var_0_51(var_0_58.visuals.indicators_type, arg_31_1)
	var_0_51(var_0_58.visuals.indicators_mode[1], arg_31_1)
end

local function var_0_100(arg_32_0, arg_32_1)
	var_0_51(var_0_58.visuals.flags_mode[1], arg_32_1)
end

local function var_0_101(arg_33_0)
	local var_33_0 = var_0_58.aa.enabled:get() and var_0_40(arg_33_0) or ""
	local var_33_1 = var_0_71(var_33_0, "Hide sliders")
	local var_33_2 = var_0_71(var_33_0, "Velocity") and not var_33_1
	local var_33_3 = var_0_71(var_33_0, "FPS") and not var_33_1
	local var_33_4 = var_0_71(var_33_0, "Ping") and not var_33_1
	local var_33_5 = var_0_71(var_33_0, "Choke") and not var_33_1
	local var_33_6 = var_0_71(var_33_0, "Loss") and not var_33_1

	var_0_51(var_0_58.aa.velocity, var_33_2)
	var_0_51(var_0_58.aa.fps, var_33_3)
	var_0_51(var_0_58.aa.ping, var_33_4)
	var_0_51(var_0_58.aa.choke, var_33_5)
	var_0_51(var_0_58.aa.loss, var_33_6)
end

local function var_0_102(arg_34_0)
	local var_34_0 = var_0_58.aa.enabled:get() and var_0_40(arg_34_0)

	if var_34_0 == "Crosshair" then
		var_0_51(var_0_58.aa.label_text, true)
		var_0_51(var_0_58.aa.color_text, true)
		var_0_51(var_0_58.aa.label_real, false)
		var_0_51(var_0_58.aa.color_arrow_real, false)
		var_0_51(var_0_58.aa.label_fake, false)
		var_0_51(var_0_58.aa.color_arrow_fake, false)
	elseif var_34_0 == "Arrow" then
		var_0_51(var_0_58.aa.label_text, false)
		var_0_51(var_0_58.aa.color_text, false)
		var_0_51(var_0_58.aa.label_real, true)
		var_0_51(var_0_58.aa.color_arrow_real, true)
		var_0_51(var_0_58.aa.label_fake, true)
		var_0_51(var_0_58.aa.color_arrow_fake, true)
	else
		var_0_51(var_0_58.aa.label_text, false)
		var_0_51(var_0_58.aa.color_text, false)
		var_0_51(var_0_58.aa.label_real, false)
		var_0_51(var_0_58.aa.color_arrow_real, false)
		var_0_51(var_0_58.aa.label_fake, false)
		var_0_51(var_0_58.aa.color_arrow_fake, false)
	end
end

local function var_0_103(arg_35_0)
	local var_35_0 = var_0_58.aa.enabled:get() and var_0_40(arg_35_0)

	if var_35_0 == "Manual" then
		var_0_51(var_0_58.aa.hotkey, true)
		var_0_51(var_0_58.aa.mode, false)
		var_0_51(var_0_58.aa.mode_hotkey, false)
	elseif var_35_0 == "Dynamic" then
		var_0_51(var_0_58.aa.hotkey, false)
		var_0_51(var_0_58.aa.mode, true)
		var_0_51(var_0_58.aa.mode_hotkey, true)
	else
		var_0_51(var_0_58.aa.hotkey, false)
		var_0_51(var_0_58.aa.mode, false)
		var_0_51(var_0_58.aa.mode_hotkey, false)
	end
end

local function var_0_104()
	local var_36_0 = var_0_16()

	if not var_0_22(var_36_0) then
		return
	end

	local var_36_1 = var_0_40(var_0_58.aa.indicators)
	local var_36_2 = var_0_40(var_0_56.aa.body_yaw[2])
	local var_36_3 = var_0_40(var_0_58.aa.mode)
	local var_36_4, var_36_5 = var_0_8()
	local var_36_6 = var_36_4 / 2
	local var_36_7 = var_36_5 / 2

	if var_36_3 == "Unsafe" then
		var_0_37(var_36_6, var_36_7 - 30, 255, 0, 0, 255, "dcb", 0, "⚠ UNSAFE ⚠")
	end

	if var_36_1 == "Crosshair" then
		local var_36_8, var_36_9, var_36_10, var_36_11 = var_0_40(var_0_58.aa.color_text)

		if var_36_2 > 0 then
			var_0_37(var_36_6, var_36_7 + 70, var_36_8, var_36_9, var_36_10, var_36_11, "dcb", 0, "RIGHT")
		elseif var_36_2 < 0 then
			var_0_37(var_36_6, var_36_7 + 70, var_36_8, var_36_9, var_36_10, var_36_11, "dcb", 0, "LEFT")
		end
	elseif var_36_1 == "Arrow" then
		local var_36_12, var_36_13, var_36_14, var_36_15 = var_0_40(var_0_58.aa.color_arrow_real)
		local var_36_16, var_36_17, var_36_18, var_36_19 = var_0_40(var_0_58.aa.color_arrow_fake)

		if var_36_2 > 0 then
			var_0_37(var_36_6 - 60, var_36_7, var_36_16, var_36_17, var_36_18, var_36_19, "+dcb", 0, "‹")
			var_0_37(var_36_6 + 60, var_36_7, var_36_12, var_36_13, var_36_14, var_36_15, "+dcb", 0, "›")
		elseif var_36_2 < 0 then
			var_0_37(var_36_6 - 60, var_36_7, var_36_12, var_36_13, var_36_14, var_36_15, "+dcb", 0, "‹")
			var_0_37(var_36_6 + 60, var_36_7, var_36_16, var_36_17, var_36_18, var_36_19, "+dcb", 0, "›")
		end
	end
end

local function var_0_105(arg_37_0)
	local var_37_0 = var_0_58.aa.enabled:get()

	if not var_37_0 then
		return
	end

	var_0_77(not var_37_0)

	local var_37_1 = var_0_68()
	local var_37_2 = var_0_69(var_37_1, var_0_67) * 10
	local var_37_3 = var_0_70(var_37_1, var_0_67) * 10
	local var_37_4 = var_0_40(var_0_58.aa.security[1])
	local var_37_5 = var_0_71(var_37_4, "Minimized")
	local var_37_6 = var_0_71(var_37_4, "Velocity")
	local var_37_7 = var_0_71(var_37_4, "Fake duck")
	local var_37_8 = var_0_71(var_37_4, "FPS")
	local var_37_9 = var_0_71(var_37_4, "Ping")
	local var_37_10 = var_0_71(var_37_4, "Choke")
	local var_37_11 = var_0_71(var_37_4, "Loss")
	local var_37_12 = var_0_40(var_0_56.rage.fake_duck)
	local var_37_13 = var_0_40(var_0_58.aa.fps)
	local var_37_14 = var_0_40(var_0_58.aa.ping)
	local var_37_15 = var_0_40(var_0_58.aa.choke)
	local var_37_16 = var_0_40(var_0_58.aa.loss)
	local var_37_17 = var_0_40(var_0_58.aa.velocity)
	local var_37_18 = entity.get_local_player()
	local var_37_19 = var_0_72(var_37_18)

	if var_37_6 and var_37_17 < var_37_19 or (arg_37_0.in_use or arg_37_0.in_attack or arg_37_0.in_attack2) == 1 then
		var_0_60.disable_aa = true
	elseif var_0_60.disable_aa then
		var_0_48(var_0_56.aa.enabled, true)

		var_0_60.disable_aa = false
	end

	if var_0_40(var_0_58.aa.mode_hotkey) then
		var_0_48(var_0_58.aa.mode, "Unsafe")

		var_0_60.last_side = 0
	else
		var_0_48(var_0_58.aa.mode, "Safe")

		var_0_60.last_side = 0
	end

	if var_37_5 and not var_0_65() or var_37_7 and var_37_12 or var_37_8 and var_37_13 > var_0_74() or var_37_9 and var_37_14 < var_0_73(var_0_5() * 1000) or var_37_10 and var_37_15 < var_37_3 or var_37_11 and var_37_16 < var_37_2 or var_0_60.disable_aa then
		return var_0_48(var_0_56.aa.enabled, false)
	else
		var_0_48(var_0_56.aa.enabled, true)
	end

	local var_37_20 = var_0_40(var_0_58.aa.type)
	local var_37_21 = var_0_40(var_0_58.aa.hotkey)

	if not var_0_60.disable_aa and var_37_20 == "Manual" then
		if var_37_21 then
			var_0_48(var_0_56.aa.body_yaw[2], 60)
		else
			var_0_48(var_0_56.aa.body_yaw[2], -60)
		end
	elseif not var_0_60.disabled_aa and var_37_20 == "Dynamic" then
		local var_37_22 = var_0_26()

		if var_0_60.hit_side ~= 0 and var_37_22 - var_0_60.last_hit > 5 then
			var_0_60.last_side = 0
			var_0_60.last_hit = 0
			var_0_60.last_side = 0
		end

		local var_37_23 = var_0_40(var_0_58.aa.mode)
		local var_37_24, var_37_25, var_37_26 = var_0_3()
		local var_37_27, var_37_28 = var_0_0()
		local var_37_29 = {
			left = 0,
			right = 0
		}

		for iter_37_0 = var_37_28 - 90, var_37_28 + 90, 30 do
			if iter_37_0 ~= var_37_28 then
				local var_37_30 = var_0_32(iter_37_0)
				local var_37_31 = var_37_24 + 256 * var_0_29(var_37_30)
				local var_37_32 = var_37_25 + 256 * var_0_33(var_37_30)
				local var_37_33 = var_37_26
				local var_37_34 = var_0_10(var_37_18, var_37_24, var_37_25, var_37_26, var_37_31, var_37_32, var_37_33)
				local var_37_35 = iter_37_0 < var_37_28 and "left" or "right"

				var_37_29[var_37_35] = var_37_29[var_37_35] + var_37_34
			end
		end

		var_0_60.side = var_37_29.left < var_37_29.right and 1 or 2

		if var_0_60.side == var_0_60.last_side then
			return
		end

		var_0_60.last_side = var_0_60.side

		if var_0_60.hit_side ~= 0 then
			var_0_60.side = var_0_60.hit_side == 1 and 2 or 1
		end
	end
end

local function var_0_106(arg_38_0, arg_38_1)
	if var_0_58.rage.enabled:get() then
		local var_38_0 = var_0_58.aa.enabled:get()
	end

	var_0_51(var_0_58.aa.type, arg_38_1)
	var_0_51(var_0_58.aa.lby_target, arg_38_1)
	var_0_51(var_0_58.aa.indicators, arg_38_1)
	var_0_51(var_0_58.aa.security[1], arg_38_1)
	var_0_51(var_0_58.aa.velocity, arg_38_1)
	var_0_103(var_0_58.aa.type)
	var_0_102(var_0_58.aa.indicators)
	var_0_101(var_0_58.aa.security[1])
end

local function var_0_107(arg_39_0, arg_39_1)
	local var_39_0 = var_0_58.rage.enabled:get()

	var_0_58.rage.improvements:show()
	var_0_58.rage.fire:show()
	var_0_58.rage.penetration:show()
	var_0_58.rage.dynamicfov:show()
	var_0_58.rage.bruteforce:show()
	var_0_58.rage.advanced_logs:show()
	var_0_58.visuals.indicators:show()
	var_0_58.visuals.flags:show()
	var_0_58.aa.enabled:show()
	var_0_76(not var_39_0)
	var_0_77(not var_39_0)

	if not var_39_0 then
		var_0_58.rage.improvements:set(false)
		var_0_58.rage.improvements:hide()
		var_0_58.rage.fire:set(false)
		var_0_58.rage.fire:hide()
		var_0_58.rage.penetration:set(false)
		var_0_58.rage.penetration:hide()
		var_0_58.rage.dynamicfov:set(false)
		var_0_58.rage.dynamicfov:hide()
		var_0_58.rage.bruteforce:set(false)
		var_0_58.rage.bruteforce:hide()
		var_0_58.rage.advanced_logs:set(false)
		var_0_58.rage.advanced_logs:hide()
		var_0_58.visuals.indicators:set(false)
		var_0_58.visuals.indicators:hide()
		var_0_58.visuals.flags:set(false)
		var_0_58.visuals.flags:hide()
		var_0_58.aa.enabled:set(false)
		var_0_58.aa.enabled:hide()
	end
end

;(function()
	var_0_87(var_0_58.rage.penetration_mode[1])
	var_0_50(var_0_58.rage.penetration_mode[1], var_0_87)
	var_0_91(var_0_58.rage.dynamicfov_mode)
	var_0_50(var_0_58.rage.dynamicfov_mode, var_0_91)
	var_0_103(var_0_58.aa.type)
	var_0_50(var_0_58.aa.type, var_0_103)
	var_0_102(var_0_58.aa.indicators)
	var_0_50(var_0_58.aa.indicators, var_0_102)
	var_0_101(var_0_58.aa.security[1])
	var_0_50(var_0_58.aa.security[1], var_0_101)
	var_0_58.rage.enabled:on("change", var_0_107)
	var_0_58.rage.improvements:on("change", var_0_82)
	var_0_58.rage.improvements:on("player_blind", var_0_81)
	var_0_58.rage.improvements:on("run_command", var_0_80)
	var_0_58.rage.improvements:on("setup_command", var_0_79)
	var_0_58.rage.fire:on("change", var_0_84)
	var_0_58.rage.fire:on("setup_command", var_0_83)
	var_0_58.rage.penetration:on("change", var_0_88)
	var_0_58.rage.penetration:on("paint", var_0_86)
	var_0_58.rage.dynamicfov:on("change", var_0_92)
	var_0_58.rage.dynamicfov:on("run_command", var_0_89)
	var_0_58.rage.dynamicfov:on("setup_command", var_0_90)
	var_0_58.rage.bruteforce:on("change", var_0_95)
	var_0_58.rage.bruteforce:on("setup_command", var_0_94)
	var_0_58.rage.advanced_logs:on("change", var_0_97)
	var_0_58.rage.advanced_logs:on("aim_miss", var_0_96)
	var_0_58.visuals.indicators:on("change", var_0_99)
	var_0_58.visuals.indicators:on("paint", var_0_98)
	var_0_58.visuals.flags:on("change", var_0_100)
	var_0_58.aa.enabled:on("change", var_0_106)
	var_0_58.aa.enabled:on("setup_command", var_0_105)
	var_0_58.aa.enabled:on("paint", var_0_104)
	var_0_9("run_command", function()
		if not var_0_58.rage.enabled:get() then
			return
		end

		var_0_75()

		if var_0_60.fire or var_0_60.fire_improvements then
			var_0_48(var_0_56.rage.fire, true)
			var_0_48(var_0_56.rage.enabled[2], "Always on")
		else
			var_0_48(var_0_56.rage.fire, false)
			var_0_48(var_0_56.rage.enabled[2], "On hotkey")
		end
	end)
	var_0_9("shutdown", function()
		var_0_51(var_0_56.rage.logs, true)
		var_0_48(var_0_56.players.reset_all, true)
		var_0_76(true)
		var_0_77(true)
	end)
	var_0_6("FAKE", 255, 0, 0, function(arg_43_0)
		local var_43_0 = var_0_58.visuals.flags:get()
		local var_43_1 = var_0_40(var_0_58.visuals.flags_mode[1])
		local var_43_2 = var_0_71(var_43_1, "FAKE")

		if var_0_23(arg_43_0) and var_43_0 and var_43_2 then
			return var_0_35(arg_43_0, "Correction active")
		end
	end)
	var_0_6("RIGHT", 255, 0, 0, function(arg_44_0)
		local var_44_0 = var_0_40(var_0_56.players.body_yaw_value)
		local var_44_1 = var_0_58.visuals.flags:get()
		local var_44_2 = var_0_40(var_0_58.visuals.flags_mode[1])
		local var_44_3 = var_0_71(var_44_2, "Bruteforce")

		if var_44_0 == 60 and var_44_1 and var_44_3 and var_0_23(arg_44_0) then
			return var_0_35(arg_44_0, "Force body yaw value")
		end
	end)
	var_0_6("LEFT", 255, 0, 0, function(arg_45_0)
		local var_45_0 = var_0_40(var_0_56.players.body_yaw_value)
		local var_45_1 = var_0_58.visuals.flags:get()
		local var_45_2 = var_0_40(var_0_58.visuals.flags_mode[1])
		local var_45_3 = var_0_71(var_45_2, "Bruteforce")

		if var_45_0 == -60 and var_45_1 and var_45_3 and var_0_23(arg_45_0) then
			return var_0_35(arg_45_0, "Force body yaw value")
		end
	end)
end)()
