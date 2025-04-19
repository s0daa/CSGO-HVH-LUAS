slot0 = client.camera_angles
slot1 = client.create_interface
slot2 = client.delay_call
slot3 = client.eye_position
slot4 = client.find_signature
slot5 = client.latency
slot6 = client.register_esp_flag
slot7 = client.reload_active_scripts
slot8 = client.screen_size
slot9 = client.set_event_callback
slot10 = client.trace_line
slot11 = client.update_player_list
slot12 = client.userid_to_entindex
slot14 = database.write
slot15 = entity.get_classname
slot16 = entity.get_local_player
slot17 = entity.get_player_name
slot18 = entity.get_player_weapon
slot19 = entity.get_players
slot20 = entity.get_prop
slot21 = entity.hitbox_position
slot22 = entity.is_alive
slot23 = entity.is_enemy
slot24 = error
slot25 = globals.absoluteframetime
slot26 = globals.curtime
slot27 = math.abs
slot28 = math.atan2
slot29 = math.cos
slot30 = math.floor
slot31 = math.pow
slot32 = math.rad
slot33 = math.sin
slot34 = math.sqrt
slot35 = plist.get
slot36 = renderer.indicator
slot37 = renderer.text
slot38 = renderer.world_to_screen
slot39 = string.format
slot40 = ui.get
slot41 = ui.new_color_picker
slot43 = ui.new_hotkey
slot44 = ui.new_label
slot45 = ui.new_multiselect
slot46 = ui.new_slider
slot47 = ui.reference
slot50 = ui.set_callback
slot51 = ui.set_visible
slot52 = pairs
slot53 = print
slot54 = require("gamesense/uix")

if (database.read("location") or "LUA - A") == "RAGE - Other" then
	container = "Other"
	tab = "RAGE"

	ui.set(({
		rage = {
			enabled = {
				slot47("RAGE", "Aimbot", "Enabled")
			},
			fire = slot47("RAGE", "Other", "Automatic fire"),
			penetration = slot47("RAGE", "Other", "Automatic penetration"),
			fov = slot47("RAGE", "Other", "Maximum FOV"),
			baim = slot47("RAGE", "Aimbot", "Force body aim"),
			logs = slot47("RAGE", "Other", "Log misses due to spread"),
			fake_duck = slot47("RAGE", "Other", "Duck peek assist")
		},
		aa = {
			enabled = slot47("AA", "Anti-aimbot angles", "Enabled"),
			pitch = slot47("AA", "Anti-aimbot angles", "Pitch"),
			yaw_base = slot47("AA", "Anti-aimbot angles", "Yaw base"),
			yaw = {
				slot47("AA", "Anti-aimbot angles", "Yaw")
			},
			yaw_jitter = {
				slot47("AA", "Anti-aimbot angles", "Yaw jitter")
			},
			body_yaw = {
				slot47("AA", "Anti-aimbot angles", "Body yaw")
			},
			fs_body_yaw = slot47("AA", "Anti-aimbot angles", "Freestanding body yaw"),
			edge_yaw = slot47("AA", "Anti-aimbot angles", "Edge yaw"),
			fs = {
				slot47("AA", "Anti-aimbot angles", "Freestanding")
			},
			slow_motion = {
				slot47("AA", "Other", "Slow motion")
			}
		},
		players = {
			body_yaw = slot47("PLAYERS", "Adjustments", "Force body yaw"),
			body_yaw_value = slot47("PLAYERS", "Adjustments", "Force body yaw value"),
			whitelist = slot47("PLAYERS", "Adjustments", "Add to whitelist"),
			apply_all = slot47("PLAYERS", "Adjustments", "Apply to all"),
			reset_all = slot47("PLAYERS", "Players", "Reset all"),
			lists = slot47("PLAYERS", "Players", "Player list")
		},
		useless_features = {
			double_tap = {
				slot47("RAGE", "Aimbot", "Double tap")
			},
			double_tap_hitchance = slot47("RAGE", "Aimbot", "Double tap hit chance"),
			double_tap_fl_limit = slot47("RAGE", "Aimbot", "Double tap fake lag limit"),
			double_tap_options = slot47("RAGE", "Aimbot", "Double tap quick stop"),
			on_shot_aa = {
				slot47("AA", "Other", "On shot anti-aim")
			},
			fake_peek = slot47("AA", "Other", "Fake peek")
		},
		location = ui.new_combobox("MISC", "Miscellaneous", "Location ui semirage", "RAGE - Other", "LUA - A", "LUA - B")
	}).location, "RAGE - Other")
elseif slot55 == "LUA - A" then
	container = "A"
	tab = "LUA"

	slot48(slot56.location, "LUA - A")
elseif slot55 == "LUA - B" then
	container = "B"
	tab = "LUA"

	slot48(slot56.location, "LUA - B")
end

slot57 = {
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
slot58 = {
	rage = {
		enabled = slot54.new_checkbox(tab, container, "Semirage"),
		improvements = slot54.new_checkbox(tab, container, "Improvements"),
		improvements_mode = {
			slot45(tab, container, "Aimbot improvements", slot57.improvements_modes)
		},
		improvements_hotkey = slot43(tab, container, "\naimbot_improvements_modes", true, 1),
		improvements_nades = {
			slot45(tab, container, "Disable aimbot", slot57.improvements_nades)
		},
		fire = slot54.new_checkbox(tab, container, "Automatic fire"),
		fire_hotkey = slot43(tab, container, "Automatic fire", true),
		penetration = slot54.new_checkbox(tab, container, "Automatic penetration"),
		penetration_hotkey = slot43(tab, container, "Automatic penetration", true),
		penetration_mode = {
			slot45(tab, container, "\npenetration_modes", slot57.penetration)
		},
		penetreation_slider = slot46(tab, container, "when X hitboxes visible", 0, 12, 2, true),
		dynamicfov = slot54.new_checkbox(tab, container, "Dynamic FOV"),
		dynamicfov_mode = slot42(tab, container, "\ndynamic_fov_modes", slot57.dynamicfov),
		dynamicfov_autofactor = slot46(tab, container, "Dynamic FOV auto factor", 0, 250, 100, true, "x", 0.01),
		dynamicfov_min_snipers = slot46(tab, container, "Snipers Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_snipers = slot46(tab, container, "Snipers Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_deagle = slot46(tab, container, "Deagle Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_deagle = slot46(tab, container, "Deagle Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_pistols = slot46(tab, container, "Pistols Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_pistols = slot46(tab, container, "Pistols Dynamic FOV max", 1, 180, 10, true, "°", 1),
		dynamicfov_min_others = slot46(tab, container, "Others Dynamic FOV min", 1, 180, 3, true, "°", 1),
		dynamicfov_max_others = slot46(tab, container, "Others Dynamic FOV max", 1, 180, 10, true, "°", 1),
		bruteforce = slot54.new_checkbox(tab, container, "Bruteforce"),
		bruteforce_hotkey = slot43(tab, container, "buteforce_hotkey", true),
		advanced_logs = slot54.new_checkbox(tab, container, "Advanced logs")
	},
	aa = {
		enabled = slot54.new_checkbox("AA", "Anti-aimbot angles", "Legit AA"),
		type = slot42("AA", "Anti-aimbot angles", "\naa_type", slot57.aa_type),
		hotkey = slot43("AA", "Anti-aimbot angles", "\naa_hotkey", true),
		mode = slot42("AA", "Anti-aimbot angles", "Freestanding mode", slot57.aa_mode),
		mode_hotkey = slot43("AA", "Anti-aimbot angles", "\nfreestanding_mode_hotkey", true),
		lby_target = slot42("AA", "Anti-aimbot angles", "Lower body yaw target", slot57.aa_lby),
		security = {
			slot45("AA", "Anti-aimbot angles", "Security", slot57.aa_security)
		},
		velocity = slot46("AA", "Anti-aimbot angles", "Velocity max", 1, 250, 150, true, "u"),
		fps = slot46("AA", "Anti-aimbot angles", "FPS min", 0, 300, 60),
		ping = slot46("AA", "Anti-aimbot angles", "Ping min", 1, 200, 80, true, "ms"),
		choke = slot46("AA", "Anti-aimbot angles", "Choke min", 1, 10, 2, true, "%"),
		loss = slot46("AA", "Anti-aimbot angles", "Loss min", 1, 10, 2, true, "%"),
		indicators = slot42("AA", "Anti-aimbot angles", "Indicators", slot57.aa_indicators),
		label_text = slot44("AA", "Anti-aimbot angles", "Color for the text"),
		color_text = slot41("AA", "Anti-aimbot angles", "\ncolor_for_the_text", 180, 238, 0, 255),
		label_real = slot44("AA", "Anti-aimbot angles", "Color for your real"),
		color_arrow_real = slot41("AA", "Anti-aimbot angles", "\ncolor_for_the_real", 180, 238, 0, 255),
		label_fake = slot44("AA", "Anti-aimbot angles", "Color for your fake"),
		color_arrow_fake = slot41("AA", "Anti-aimbot angles", "\ncolor_for_the_fake", 255, 0, 0, 255)
	},
	visuals = {
		indicators = slot54.new_checkbox(tab, container, "Indicators"),
		indicators_type = slot42(tab, container, "\nindicators_types", slot57.indicators_types),
		indicaotrs_color = slot41(tab, container, "\nindicators_color", 180, 238, 0, 255),
		indicators_mode = {
			slot45(tab, container, "Indicators modes", slot57.indicators)
		},
		flags = slot54.new_checkbox(tab, container, "Flags"),
		flags_mode = {
			slot45(tab, container, "\nflags_modes", slot57.flags)
		}
	}
}
slot59 = {
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
	CWeaponGalilAR = "Others",
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
	CWeaponG3SG1 = "Snipers"
}
slot60 = {
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
slot61 = slot49("ffi")
slot64 = slot61.cast(slot61.typeof("bool(__thiscall*)(float, float, float, float, float, float, short)"), slot4("client.dll", "U\\x8b\\xec\\x83\\xec\\x8b\\xcc\\xcc\\xcc\\xccW") or slot24("client_find_signature problem")) or slot24("ffi.cast problem")
slot65 = vtable_bind("engine.dll", "VEngineClient014", 196, "bool(__thiscall*)(void*)")
slot66 = 0
slot67 = 1
slot68 = vtable_bind("engine.dll", "VEngineClient014", 78, "void*(__thiscall*)(void*)")
slot69 = vtable_thunk(11, "float(__thiscall*)(void*, int)")
slot70 = vtable_thunk(12, "float(__thiscall*)(void*, int)")

function slot71(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot72(slot0)
	slot1, slot2, slot3 = uv0(slot0, "m_vecVelocity")

	return uv1(uv2(slot1 * slot1 + slot2 * slot2 + slot3 * slot3) + 0.5)
end

function slot73(slot0, slot1)
	slot2 = 10^(slot1 or 0)

	return uv0(slot0 * slot2 + 0.5) / slot2
end

function slot74()
	uv0.ft_prev = uv0.ft_prev * 0.9 + uv1() * 0.1

	return uv2(1 / uv0.ft_prev)
end

function slot75()
	if uv0.aa.enabled:get() then
		uv1(uv2.aa.pitch, "Off")
		uv1(uv2.aa.yaw_base, "Local view")
		uv1(uv2.aa.yaw[1], "Off")
		uv1(uv2.aa.yaw_jitter[1], "Off")
		uv1(uv2.aa.body_yaw[1], "Static")
		uv1(uv2.aa.fs_body_yaw, false)
		uv1(uv2.aa.edge_yaw, false)
		uv1(uv2.aa.fs[1], "-")
	else
		uv1(uv2.aa.pitch, "Off")
		uv1(uv2.aa.yaw_base, "Local view")
		uv1(uv2.aa.yaw[1], "Off")
		uv1(uv2.aa.yaw_jitter[1], "Off")
		uv1(uv2.aa.body_yaw[1], "Off")
		uv1(uv2.aa.fs_body_yaw, false)
		uv1(uv2.aa.edge_yaw, false)
		uv1(uv2.aa.fs[1], "-")
	end
end

function slot76(slot0)
	if slot0 == false then
		uv0(uv1.useless_features.double_tap[1], slot0)
		uv0(uv1.useless_features.double_tap[2], slot0)
		uv0(uv1.useless_features.double_tap_hitchance, slot0)
		uv0(uv1.useless_features.double_tap_fl_limit, slot0)
		uv0(uv1.useless_features.double_tap_options, slot0)
		uv0(uv1.useless_features.on_shot_aa[1], slot0)
		uv0(uv1.useless_features.on_shot_aa[1], slot0)
		uv0(uv1.useless_features.on_shot_aa[2], slot0)
		uv0(uv1.useless_features.fake_peek, slot0)
	else
		uv0(uv1.useless_features.double_tap[1], slot0)
		uv0(uv1.useless_features.double_tap[2], slot0)
		uv0(uv1.useless_features.on_shot_aa[1], slot0)
		uv0(uv1.useless_features.on_shot_aa[1], slot0)
		uv0(uv1.useless_features.on_shot_aa[2], slot0)
		uv0(uv1.useless_features.fake_peek, slot0)
	end
end

function slot77(slot0)
	uv0(uv1.aa.enabled, slot0)
	uv0(uv1.aa.pitch, slot0)
	uv0(uv1.aa.yaw_base, slot0)
	uv0(uv1.aa.yaw[1], slot0)
	uv0(uv1.aa.yaw[2], false)
	uv0(uv1.aa.yaw_jitter[1], slot0)
	uv0(uv1.aa.yaw_jitter[2], false)
	uv0(uv1.aa.body_yaw[1], slot0)
	uv0(uv1.aa.body_yaw[2], false)
	uv0(uv1.aa.fs_body_yaw, false)
	uv0(uv1.aa.edge_yaw, slot0)
	uv0(uv1.aa.fs[1], slot0)
	uv0(uv1.aa.fs[2], slot0)
end

slot50(slot56.location, function (slot0)
	uv1("location", uv0(slot0))
	uv2()
end)

function slot79(slot0)
	if uv0(uv1.rage.improvements_hotkey) and uv6(uv0(uv1.rage.improvements_mode[1]), uv2[uv3(uv4(uv5()))]) then
		uv7.fire_improvements = true
	else
		uv7.fire_improvements = false
	end
end

function slot80()
	if uv2(uv0(uv1.rage.improvements_nades[1]), "Smoke") then
		uv3()

		slot3 = {
			uv5(uv4(), 0)
		}

		for slot7, slot8 in uv6(uv7(true)) do
			uv8(uv9.players.lists, slot8)

			slot9 = {
				uv5(slot8, 0)
			}

			uv8(uv9.players.whitelist, uv10(slot3[1], slot3[2], slot3[3], slot9[1], slot9[2], slot9[3], 1))
		end
	end
end

function slot81(slot0)
	if uv4(slot0.userid) == uv3() and uv2(uv0(uv1.rage.improvements_nades[1]), "Flash") then
		uv5(0.1, function ()
			if uv0(uv1, "m_flFlashDuration") >= 1 then
				uv2(uv3.rage.enabled[1], false)
				uv4(slot0, function ()
					uv0(uv1.rage.enabled[1], true)
				end)
			end
		end)
	end
end

function slot82(slot0, slot1)
	uv0(uv1.rage.improvements_mode[1], slot1)
	uv0(uv1.rage.improvements_hotkey, slot1)
	uv0(uv1.rage.improvements_nades[1], slot1)
end

function slot83(slot0)
	if uv0(uv1.rage.fire_hotkey) then
		uv2.fire = true
	else
		uv2.fire = false
	end
end

function slot84(slot0, slot1)
	uv0(uv1.rage.fire_hotkey, slot1)
end

function slot85()
	slot1 = uv1()
	slot2, slot3, slot4 = uv2()
	slot5 = uv3.visible_hitboxes
	slot6 = uv4(uv5.rage.penetreation_slider)

	for slot10 = 1, #uv0(true) do
		slot11 = slot0[slot10]

		for slot16 = 0, 18 do
			slot17, slot18, slot19 = uv6(slot11, slot16)
			slot20, slot21 = uv7(slot1, slot2, slot3, slot4, slot17, slot18, slot19)

			if slot21 == slot11 and uv8(slot17, slot18, slot19) then
				slot12 = 0 + 1
			end
		end

		if slot6 <= slot12 then
			return true
		end
	end

	return false
end

function slot86()
	if not uv1(uv0()) then
		return
	end

	slot2 = uv2(uv3.rage.penetration_mode[1])

	if uv4(slot2, "On hotkey") and uv2(uv3.rage.penetration_hotkey) or uv4(slot2, "Visible") and uv5() then
		uv6(uv7.rage.penetration, true)
	else
		uv6(uv7.rage.penetration, false)
	end
end

function slot87(slot0)
	slot1 = uv0.rage.penetration:get() and uv1(slot0) or ""

	uv3(uv0.rage.penetration_hotkey, uv2(slot1, "On hotkey"))
	uv3(uv0.rage.penetreation_slider, uv2(slot1, "Visible"))
end

function slot88(slot0, slot1)
	uv0(uv1.rage.penetration_mode[1], slot1)
	uv0(uv1.rage.penetreation_slider, slot1)
	uv2(uv1.rage.penetration_mode[1])
end

function slot89()
	slot1 = uv0(uv1.rage.dynamicfov_autofactor)
	slot2, slot3 = nil

	if uv0(uv1.rage.dynamicfov_mode) == "Snipers" then
		slot2 = uv0(uv1.rage.dynamicfov_max_snipers)
		slot3 = uv0(uv1.rage.dynamicfov_min_snipers)
	elseif slot0 == "Deagle" then
		slot2 = uv0(uv1.rage.dynamicfov_max_deagle)
		slot3 = uv0(uv1.rage.dynamicfov_min_deagle)
	elseif slot0 == "Pistols" then
		slot2 = uv0(uv1.rage.dynamicfov_max_pistols)
		slot3 = uv0(uv1.rage.dynamicfov_min_pistols)
	elseif slot0 == "Others" then
		slot2 = uv0(uv1.rage.dynamicfov_max_others)
		slot3 = uv0(uv1.rage.dynamicfov_min_others)
	end

	if slot1 == nil or slot2 == nil or slot3 == nil then
		return
	end

	slot5 = uv0(uv2.rage.fov)
	slot6 = uv3(true)

	if slot2 < slot3 then
		slot3 = slot2
		slot2 = slot3
	end

	if #slot6 ~= 0 then
		slot7, slot8, slot9 = uv4()
		slot10, slot11 = uv5()
		uv6.closest_enemy = nil
		slot12 = 999999999

		for slot16 = 1, #slot6 do
			slot18, slot19, slot20 = uv7(slot6[slot16], 0)
			slot21 = slot18 - slot7
			slot22 = slot19 - slot8
			slot27 = uv11(slot10 - -(uv8(slot20 - slot9, uv9(uv10(slot21, 2) + uv10(slot22, 2))) * 180 / math.pi)) % 360

			if uv11(slot11 % 360 - uv8(slot22, slot21) * 180 / math.pi % 360) % 360 > 180 then
				slot26 = 360 - slot26
			end

			if uv9(uv10(slot26, 2) + uv10(slot27, 2)) < slot12 then
				slot12 = slot28
				uv6.closest_enemy = slot17
			end
		end

		if uv6.closest_enemy ~= nil then
			slot13, slot14, slot15 = uv7(uv6.closest_enemy, 0)

			if slot2 < 3800 / uv9(uv10(slot7 - slot13, 2) + uv10(slot8 - slot14, 2) + uv10(slot9 - slot15, 2)) * uv0(uv1.rage.dynamicfov_autofactor) * 0.01 then
				slot5 = slot2
			elseif slot5 < slot3 then
				slot5 = slot3
			end
		end

		if slot12 < uv12(slot5 + 0.5) then
			uv6.in_fov = true
		else
			uv6.in_fov = false
		end
	else
		slot5 = slot3
		uv6.in_fov = false
	end

	if slot5 ~= slot4 and (slot0 == "Snipers" or slot0 == "Deagle" or slot0 == "Pistols" or slot0 == "Others") then
		uv13(uv2.rage.fov, slot5)
	end
end

function slot90(slot0)
	if uv3[uv2(uv1(uv0()))] then
		uv4(uv5.rage.dynamicfov_mode, uv3[slot3])
	end
end

function slot91(slot0)
	slot1 = uv0.rage.dynamicfov:get() and uv1(slot0) or ""

	uv2(uv0.rage.dynamicfov_min_snipers, slot1 == "Snipers")
	uv2(uv0.rage.dynamicfov_max_snipers, slot1 == "Snipers")
	uv2(uv0.rage.dynamicfov_min_deagle, slot1 == "Deagle")
	uv2(uv0.rage.dynamicfov_max_deagle, slot1 == "Deagle")
	uv2(uv0.rage.dynamicfov_min_pistols, slot1 == "Pistols")
	uv2(uv0.rage.dynamicfov_max_pistols, slot1 == "Pistols")
	uv2(uv0.rage.dynamicfov_min_others, slot1 == "Others")
	uv2(uv0.rage.dynamicfov_max_others, slot1 == "Others")
end

function slot92(slot0, slot1)
	uv0(uv1.rage.dynamicfov_mode, slot1)
	uv0(uv1.rage.dynamicfov_autofactor, slot1)
	uv2(uv1.rage.dynamicfov_mode)
end

function slot93()
	uv2()

	if uv0(uv1.players.body_yaw_value) == 0 then
		uv3(uv1.players.body_yaw, true)
		uv3(uv1.players.body_yaw_value, 60)
		uv3(uv1.players.apply_all, true)

		uv4.bruteforce = false
	elseif slot0 == 60 then
		uv3(uv1.players.body_yaw, true)
		uv3(uv1.players.body_yaw_value, -60)
		uv3(uv1.players.apply_all, true)

		uv4.bruteforce = false
	elseif slot0 == -60 then
		uv3(uv1.players.reset_all, true)

		uv4.bruteforce = false
	end
end

function slot94(slot0)
	if uv0(uv1.rage.bruteforce_hotkey) then
		if uv2.bruteforce then
			uv3()

			uv2.bruteforce = false
		end
	else
		uv2.bruteforce = true
	end
end

function slot95(slot0, slot1)
	uv0(uv1.rage.bruteforce_hotkey, slot1)
end

function slot96(slot0)
	uv1(uv2("Missed %s (%s) due to %s", uv3(slot0.target), uv0.hitgroup_names[slot0.hitgroup + 1] or "?", slot0.reason))
end

function slot97(slot0, slot1)
	uv0(uv1.rage.logs, not slot1)
	uv2(uv1.rage.logs, false)
end

function slot98()
	if not uv1(uv0()) then
		return
	end

	slot3 = uv2(uv3.visuals.indicators_mode[1])
	slot5 = uv4(slot3, "FOV")
	slot6 = uv4(slot3, "Automatic fire")
	slot7 = uv4(slot3, "Automatic penetration")
	slot8 = uv4(slot3, "Force body aim")
	slot9 = uv2(uv5.rage.fov)
	slot11 = uv2(uv5.rage.fire)
	slot12 = uv2(uv5.rage.penetration)
	slot13 = uv2(uv5.rage.baim)
	slot14, slot15, slot16, slot17 = uv2(uv3.visuals.indicaotrs_color)
	slot18, slot19 = uv6()
	slot20 = slot18 / 2
	slot21 = slot19 / 2

	if uv2(uv3.visuals.indicators_type) == "Default" then
		if uv4(slot3, "Bruteforce") then
			if uv2(uv5.players.body_yaw_value) == 60 then
				uv7(slot14, slot15, slot16, slot17, "B:RIGHT")
			elseif slot10 == -60 then
				uv7(slot14, slot15, slot16, slot17, "B:LEFT")
			elseif slot10 == 0 then
				uv7(slot14, slot15, slot16, slot17, "B:OFF")
			end
		end

		if slot5 then
			uv7(slot14, slot15, slot16, slot17, "FOV: ", slot9, "°")
		end

		if slot6 and slot11 then
			uv7(slot14, slot15, slot16, slot17, "TM")
		end

		if slot7 and slot12 then
			uv7(slot14, slot15, slot16, slot17, "AW")
		end

		if slot8 and slot13 then
			uv7(slot14, slot15, slot16, slot17, "BAIM")
		end
	elseif slot2 == "Crosshair" then
		if slot4 then
			if slot10 == 60 then
				uv8(slot20, slot21 + 60, slot14, slot15, slot16, slot17, "dcb", 0, "B:RIGHT")
			elseif slot10 == -60 then
				uv8(slot20, slot21 + 60, slot14, slot15, slot16, slot17, "dcb", 0, "B:LEFT")
			elseif slot10 == 0 then
				uv8(slot20, slot21 + 60, slot14, slot15, slot16, slot17, "dcb", 0, "B:OFF")
			end
		end

		if slot5 then
			uv7(slot14, slot15, slot16, slot17, "FOV: ", slot9, "°")
		end

		if slot6 and slot11 then
			uv8(slot20, slot21 + 30, slot14, slot15, slot16, slot17, "dcb", 0, "TM")
		else
			uv8(slot20, slot21 + 30, 0, 0, 0, 50, "dcb", 0, "TM")
		end

		if slot7 and slot12 then
			uv8(slot20, slot21 + 40, slot14, slot15, slot16, slot17, "dcb", 0, "AW")
		else
			uv8(slot20, slot21 + 40, 0, 0, 0, 50, "dcb", 0, "AW")
		end

		if slot8 and slot13 then
			uv8(slot20, slot21 + 50, slot14, slot15, slot16, slot17, "dcb", 0, "BAIM")
		else
			uv8(slot20, slot21 + 50, 0, 0, 0, 50, "dcb", 0, "BAIM")
		end
	end
end

function slot99(slot0, slot1)
	uv0(uv1.visuals.indicaotrs_color, slot1)
	uv0(uv1.visuals.indicators_type, slot1)
	uv0(uv1.visuals.indicators_mode[1], slot1)
end

function slot100(slot0, slot1)
	uv0(uv1.visuals.flags_mode[1], slot1)
end

function slot101(slot0)
	slot1 = uv0.aa.enabled:get() and uv1(slot0) or ""
	slot2 = uv2(slot1, "Hide sliders")

	uv3(uv0.aa.velocity, uv2(slot1, "Velocity") and not slot2)
	uv3(uv0.aa.fps, uv2(slot1, "FPS") and not slot2)
	uv3(uv0.aa.ping, uv2(slot1, "Ping") and not slot2)
	uv3(uv0.aa.choke, uv2(slot1, "Choke") and not slot2)
	uv3(uv0.aa.loss, uv2(slot1, "Loss") and not slot2)
end

function slot102(slot0)
	if (uv0.aa.enabled:get() and uv1(slot0)) == "Crosshair" then
		uv2(uv0.aa.label_text, true)
		uv2(uv0.aa.color_text, true)
		uv2(uv0.aa.label_real, false)
		uv2(uv0.aa.color_arrow_real, false)
		uv2(uv0.aa.label_fake, false)
		uv2(uv0.aa.color_arrow_fake, false)
	elseif slot1 == "Arrow" then
		uv2(uv0.aa.label_text, false)
		uv2(uv0.aa.color_text, false)
		uv2(uv0.aa.label_real, true)
		uv2(uv0.aa.color_arrow_real, true)
		uv2(uv0.aa.label_fake, true)
		uv2(uv0.aa.color_arrow_fake, true)
	else
		uv2(uv0.aa.label_text, false)
		uv2(uv0.aa.color_text, false)
		uv2(uv0.aa.label_real, false)
		uv2(uv0.aa.color_arrow_real, false)
		uv2(uv0.aa.label_fake, false)
		uv2(uv0.aa.color_arrow_fake, false)
	end
end

function slot103(slot0)
	if (uv0.aa.enabled:get() and uv1(slot0)) == "Manual" then
		uv2(uv0.aa.hotkey, true)
		uv2(uv0.aa.mode, false)
		uv2(uv0.aa.mode_hotkey, false)
	elseif slot1 == "Dynamic" then
		uv2(uv0.aa.hotkey, false)
		uv2(uv0.aa.mode, true)
		uv2(uv0.aa.mode_hotkey, true)
	else
		uv2(uv0.aa.hotkey, false)
		uv2(uv0.aa.mode, false)
		uv2(uv0.aa.mode_hotkey, false)
	end
end

function slot104()
	if not uv1(uv0()) then
		return
	end

	slot2 = uv2(uv3.aa.indicators)
	slot3 = uv2(uv4.aa.body_yaw[2])
	slot5, slot6 = uv5()

	if uv2(uv3.aa.mode) == "Unsafe" then
		uv6(slot5 / 2, slot6 / 2 - 30, 255, 0, 0, 255, "dcb", 0, "⚠ UNSAFE ⚠")
	end

	if slot2 == "Crosshair" then
		slot9, slot10, slot11, slot12 = uv2(uv3.aa.color_text)

		if slot3 > 0 then
			uv6(slot7, slot8 + 70, slot9, slot10, slot11, slot12, "dcb", 0, "RIGHT")
		elseif slot3 < 0 then
			uv6(slot7, slot8 + 70, slot9, slot10, slot11, slot12, "dcb", 0, "LEFT")
		end
	elseif slot2 == "Arrow" then
		slot9, slot10, slot11, slot12 = uv2(uv3.aa.color_arrow_real)
		slot13, slot14, slot15, slot16 = uv2(uv3.aa.color_arrow_fake)

		if slot3 > 0 then
			uv6(slot7 - 60, slot8, slot13, slot14, slot15, slot16, "+dcb", 0, "‹")
			uv6(slot7 + 60, slot8, slot9, slot10, slot11, slot12, "+dcb", 0, "›")
		elseif slot3 < 0 then
			uv6(slot7 - 60, slot8, slot9, slot10, slot11, slot12, "+dcb", 0, "‹")
			uv6(slot7 + 60, slot8, slot13, slot14, slot15, slot16, "+dcb", 0, "›")
		end
	end
end

function slot105(slot0)
	if not uv0.aa.enabled:get() then
		return
	end

	uv1(not slot1)

	slot2 = uv2()
	slot3 = uv3(slot2, uv4) * 10
	slot4 = uv5(slot2, uv4) * 10
	slot5 = uv6(uv0.aa.security[1])
	slot6 = uv7(slot5, "Minimized")
	slot8 = uv7(slot5, "Fake duck")
	slot9 = uv7(slot5, "FPS")
	slot10 = uv7(slot5, "Ping")
	slot11 = uv7(slot5, "Choke")
	slot12 = uv7(slot5, "Loss")
	slot13 = uv6(uv8.rage.fake_duck)
	slot14 = uv6(uv0.aa.fps)
	slot15 = uv6(uv0.aa.ping)
	slot16 = uv6(uv0.aa.choke)
	slot17 = uv6(uv0.aa.loss)

	if uv7(slot5, "Velocity") and uv6(uv0.aa.velocity) < uv9(entity.get_local_player()) or (slot0.in_use or slot0.in_attack or slot0.in_attack2) == 1 then
		uv10.disable_aa = true
	elseif uv10.disable_aa then
		uv11(uv8.aa.enabled, true)

		uv10.disable_aa = false
	end

	if uv6(uv0.aa.mode_hotkey) then
		uv11(uv0.aa.mode, "Unsafe")

		uv10.last_side = 0
	else
		uv11(uv0.aa.mode, "Safe")

		uv10.last_side = 0
	end

	if slot6 and not uv12() or slot8 and slot13 or slot9 and uv13() < slot14 or slot10 and slot15 < uv14(uv15() * 1000) or slot11 and slot16 < slot4 or slot12 and slot17 < slot3 or uv10.disable_aa then
		return uv11(uv8.aa.enabled, false)
	else
		uv11(uv8.aa.enabled, true)
	end

	if not uv10.disable_aa and uv6(uv0.aa.type) == "Manual" then
		if uv6(uv0.aa.hotkey) then
			uv11(uv8.aa.body_yaw[2], 60)
		else
			uv11(uv8.aa.body_yaw[2], -60)
		end
	elseif not uv10.disabled_aa and slot22 == "Dynamic" then
		if uv10.hit_side ~= 0 and uv16() - uv10.last_hit > 5 then
			uv10.last_side = 0
			uv10.last_hit = 0
			uv10.last_side = 0
		end

		slot25 = uv6(uv0.aa.mode)
		slot26, slot27, slot28 = uv17()
		slot29, slot30 = uv18()
		slot31 = {
			left = 0,
			right = 0
		}

		for slot35 = slot30 - 90, slot30 + 90, 30 do
			if slot35 ~= slot30 then
				slot36 = uv19(slot35)
				slot41 = slot35 < slot30 and "left" or "right"
				slot31[slot41] = slot31[slot41] + uv22(slot19, slot26, slot27, slot28, slot26 + 256 * uv20(slot36), slot27 + 256 * uv21(slot36), slot28)
			end
		end

		uv10.side = slot31.left < slot31.right and 1 or 2

		if uv10.side == uv10.last_side then
			return
		end

		uv10.last_side = uv10.side

		if uv10.hit_side ~= 0 then
			uv10.side = uv10.hit_side == 1 and 2 or 1
		end
	end
end

function slot106(slot0, slot1)
	slot2 = uv0.rage.enabled:get() and uv0.aa.enabled:get()

	uv1(uv0.aa.type, slot1)
	uv1(uv0.aa.lby_target, slot1)
	uv1(uv0.aa.indicators, slot1)
	uv1(uv0.aa.security[1], slot1)
	uv1(uv0.aa.velocity, slot1)
	uv2(uv0.aa.type)
	uv3(uv0.aa.indicators)
	uv4(uv0.aa.security[1])
end

function slot107(slot0, slot1)
	slot2 = uv0.rage.enabled:get()

	uv0.rage.improvements:show()
	uv0.rage.fire:show()
	uv0.rage.penetration:show()
	uv0.rage.dynamicfov:show()
	uv0.rage.bruteforce:show()
	uv0.rage.advanced_logs:show()
	uv0.visuals.indicators:show()
	uv0.visuals.flags:show()
	uv0.aa.enabled:show()
	uv1(not slot2)
	uv2(not slot2)

	if not slot2 then
		uv0.rage.improvements:set(false)
		uv0.rage.improvements:hide()
		uv0.rage.fire:set(false)
		uv0.rage.fire:hide()
		uv0.rage.penetration:set(false)
		uv0.rage.penetration:hide()
		uv0.rage.dynamicfov:set(false)
		uv0.rage.dynamicfov:hide()
		uv0.rage.bruteforce:set(false)
		uv0.rage.bruteforce:hide()
		uv0.rage.advanced_logs:set(false)
		uv0.rage.advanced_logs:hide()
		uv0.visuals.indicators:set(false)
		uv0.visuals.indicators:hide()
		uv0.visuals.flags:set(false)
		uv0.visuals.flags:hide()
		uv0.aa.enabled:set(false)
		uv0.aa.enabled:hide()
	end
end

function ()
	uv0(uv1.rage.penetration_mode[1])
	uv2(uv1.rage.penetration_mode[1], uv0)
	uv3(uv1.rage.dynamicfov_mode)
	uv2(uv1.rage.dynamicfov_mode, uv3)
	uv4(uv1.aa.type)
	uv2(uv1.aa.type, uv4)
	uv5(uv1.aa.indicators)
	uv2(uv1.aa.indicators, uv5)
	uv6(uv1.aa.security[1])
	uv2(uv1.aa.security[1], uv6)
	uv1.rage.enabled:on("change", uv7)
	uv1.rage.improvements:on("change", uv8)
	uv1.rage.improvements:on("player_blind", uv9)
	uv1.rage.improvements:on("run_command", uv10)
	uv1.rage.improvements:on("setup_command", uv11)
	uv1.rage.fire:on("change", uv12)
	uv1.rage.fire:on("setup_command", uv13)
	uv1.rage.penetration:on("change", uv14)
	uv1.rage.penetration:on("paint", uv15)
	uv1.rage.dynamicfov:on("change", uv16)
	uv1.rage.dynamicfov:on("run_command", uv17)
	uv1.rage.dynamicfov:on("setup_command", uv18)
	uv1.rage.bruteforce:on("change", uv19)
	uv1.rage.bruteforce:on("setup_command", uv20)
	uv1.rage.advanced_logs:on("change", uv21)
	uv1.rage.advanced_logs:on("aim_miss", uv22)
	uv1.visuals.indicators:on("change", uv23)
	uv1.visuals.indicators:on("paint", uv24)
	uv1.visuals.flags:on("change", uv25)
	uv1.aa.enabled:on("change", uv26)
	uv1.aa.enabled:on("setup_command", uv27)
	uv1.aa.enabled:on("paint", uv28)
	uv29("run_command", function ()
		if not uv0.rage.enabled:get() then
			return
		end

		uv1()

		if uv2.fire or uv2.fire_improvements then
			uv3(uv4.rage.fire, true)
			uv3(uv4.rage.enabled[2], "Always on")
		else
			uv3(uv4.rage.fire, false)
			uv3(uv4.rage.enabled[2], "On hotkey")
		end
	end)
	uv29("shutdown", function ()
		uv0(uv1.rage.logs, true)
		uv2(uv1.players.reset_all, true)
		uv3(true)
		uv4(true)
	end)
	uv37("FAKE", 255, 0, 0, function (slot0)
		if uv3(slot0) and uv0.visuals.flags:get() and uv2(uv1(uv0.visuals.flags_mode[1]), "FAKE") then
			return uv4(slot0, "Correction active")
		end
	end)
	uv37("RIGHT", 255, 0, 0, function (slot0)
		if uv0(uv1.players.body_yaw_value) == 60 and uv2.visuals.flags:get() and uv3(uv0(uv2.visuals.flags_mode[1]), "Bruteforce") and uv4(slot0) then
			return uv5(slot0, "Force body yaw value")
		end
	end)
	uv37("LEFT", 255, 0, 0, function (slot0)
		if uv0(uv1.players.body_yaw_value) == -60 and uv2.visuals.flags:get() and uv3(uv0(uv2.visuals.flags_mode[1]), "Bruteforce") and uv4(slot0) then
			return uv5(slot0, "Force body yaw value")
		end
	end)
end()
