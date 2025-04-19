slot0 = ui.get
slot1 = ui.set
slot2 = entity.get_player_weapon
slot3 = entity.get_players
slot4 = entity.get_local_player
slot5 = entity.get_prop
slot6 = entity.hitbox_position
slot7 = entity.is_alive
slot8 = entity.is_dormant
slot9 = globals.chokedcommands
slot10 = globals.curtime
slot11 = globals.tickcount
slot12 = globals.tickinterval
slot13 = globals.mapname
slot14 = plist.get
slot15 = plist.set
slot16 = client.trace_line
slot17 = client.latency
slot18 = client.set_clan_tag
slot19 = client.screen_size
slot20 = client.eye_position
slot21 = entity.get_all
slot22 = renderer.world_to_screen
slot23 = renderer.indicator
slot25 = string.sub
slot26 = bit.band
slot27 = math.abs
slot28 = math.floor
slot29 = math.min
slot30 = math.max
slot31 = math.sqrt
slot32 = math.pow
slot33 = string.rep
slot34 = string.sub
slot35 = require("gamesense/csgo_weapons")
slot36 = require("ffi")
slot37 = require("vector")
slot38 = {
	thorax = 4,
	body = 3,
	pelvis = 2,
	head = 0,
	right_forearm = 18,
	right_upper_arm = 17,
	left_forearm = 16,
	left_upper_arm = 15,
	right_hand = 14,
	left_hand = 13,
	right_foot = 12,
	left_foot = 11,
	right_thigh = 8,
	left_thigh = 7,
	chest = 5
}
slot39 = {
	onground = bit.lshift(1, 0),
	fakeclient = bit.lshift(1, 9)
}
slot40 = {
	awp = 9,
	r8_revolver = 64
}
slot41 = {
	f3 = 114,
	xbutton2 = 6
}
slot42 = 15
slot43 = slot36.cast(slot36.typeof("bool(__cdecl*)(float flFromX, float flFromY, float flFromZ, float flToX, float flToY, float flToZ)"), client.find_signature("client.dll", "U\\x8b\\xec\\x83\\xec\\x8b\\xcc\\xcc\\xcc\\xcc") or error("client.dll!::LineGoesThroughSmoke could not be found. Signature is outdated."))
slot44 = "nyaahook!"
slot45 = 32
slot46 = 3.3
slot47 = 0.03
slot48 = 4000
slot49 = 4
slot50 = 1500
slot51 = 100
slot52 = {
	slot38.head,
	slot38.left_foot,
	slot38.right_foot,
	slot38.left_hand,
	slot38.right_hand
}
slot53 = 17
slot54 = {
	slot38.left_hand,
	slot38.right_hand,
	slot38.left_foot,
	slot38.right_foot,
	slot38.head,
	slot38.left_thigh,
	slot38.right_thigh,
	slot38.left_upper_arm,
	slot38.right_upper_arm,
	slot38.left_forearm,
	slot38.right_forearm,
	slot38.pelvis,
	slot38.body,
	slot38.chest,
	slot38.thorax
}
slot55 = 30
slot56 = {
	{
		0,
		0
	},
	{
		slot55,
		0
	},
	{
		-slot55,
		0
	},
	{
		0,
		slot55
	},
	{
		0,
		-slot55
	}
}
slot57 = 75
slot58 = {
	smg = "Submachine Gun",
	machinegun = "Machine gun",
	pistol = "Pistol",
	sniperrifle = "Sniper rifle",
	shotgun = "Shotgun",
	rifle = "Rifle"
}
slot59, slot60 = ui.reference("RAGE", "Aimbot", "Enabled")
slot61 = ui.reference("RAGE", "Aimbot", "Avoid unsafe hitboxes")
slot62 = ui.reference("RAGE", "Other", "Automatic fire")
slot63 = ui.reference("RAGE", "Other", "Automatic penetration")
slot64 = ui.reference("RAGE", "Other", "Maximum FOV")
slot65 = ui.reference("MISC", "Miscellaneous", "Clan tag spammer")
slot66 = ui.new_checkbox("LUA", "A", "nyaahook!")
slot67 = ui.new_checkbox("LUA", "A", "Dynamic FOV")
slot68 = ui.new_color_picker("LUA", "A", "Dynamic FOV", 255, 255, 255, 0)
slot69 = ui.new_slider("LUA", "A", "Minimum FOV", 1, 35, 3, true, "°", 1)
slot70 = ui.new_slider("LUA", "A", "Maximum FOV", 1, 35, 15, true, "°", 1)
slot71 = ui.new_checkbox("LUA", "A", "Automatic fire")
slot72 = ui.new_hotkey("LUA", "A", "Automatic fire", true, slot41.xbutton2)
slot73 = ui.new_checkbox("LUA", "A", "Automatic penetration")
slot74 = ui.new_hotkey("LUA", "A", "Automatic penetration", true, slot41.f3)
slot75 = ui.new_color_picker("LUA", "A", "Automatic penetration", 255, 255, 255, 0)
slot76 = ui.new_slider("LUA", "A", "Minimum visible hitboxes", 0, 4, 0, true, "", 1, {
	[0] = "Disabled",
	"1+/hotkey",
	"2+/hotkey",
	"3+/hotkey",
	"4+/hotkey"
})
slot77 = ui.new_checkbox("LUA", "A", "Automatic penetration overrides visibility")
slot78 = ui.new_checkbox("LUA", "A", "Prioritize AWP users")
slot79 = ui.new_checkbox("LUA", "A", "Rage aimbot delay")
slot80 = ui.new_slider("LUA", "A", "Rage aimbot reaction time", 1, 200, 125, true, "ms")
slot81 = ui.new_checkbox("LUA", "A", "Ignore airborne enemies")
slot82 = ui.new_slider("LUA", "A", "Post-jump reaction time", 0, 1000, 500, true, "ms", 1, {
	[0] = "∞",
	[1000.0] = "1s"
})
slot83 = ui.new_checkbox("LUA", "A", "Ignore enemies behind smokes")
slot84 = ui.new_checkbox("LUA", "A", "Do not fire while blind")
slot85 = ui.new_slider("LUA", "A", "Blindness duration threshold", 1, 100, 44, true, "s", 0.05, {
	[100.0] = "∞"
})
slot86 = ui.new_checkbox("LUA", "A", "Force head safety on legit anti-aim users")
slot87 = ui.new_checkbox("LUA", "A", "Extra rage aimbot hotkeys")
slot88 = ui.new_multiselect("LUA", "A", "Hotkey ignored weapon groups", {
	"Pistol",
	"Submachine Gun",
	"Rifle",
	"Shotgun",
	"Machine gun",
	"Sniper rifle"
})
slot89 = ui.new_slider("LUA", "A", "Rage aimbot hotkey count", 1, 5, 2, true)
slot90 = {
	[slot94] = ui.new_hotkey("LUA", "A", string.format("Rage aimbot hotkey #%d", slot94), false)
}

for slot94 = 1, 5 do
end

slot92 = nil
slot93 = 0
slot94 = 0
slot95 = {}
slot96 = {}
slot97 = {}
slot98 = {}
slot99 = {}
slot100, slot101 = nil
slot102 = false
slot103 = 0
slot104 = nil
slot105 = false

function slot106()
	return uv0() ~= nil
end

function slot107(slot0)
	if uv0(slot0) ~= nil then
		return uv1(slot1, "m_iItemDefinitionIndex")
	end

	return nil
end

function slot108(slot0, slot1, slot2)
	if uv0 <= slot2 then
		return slot0
	elseif slot2 <= uv1 then
		return slot1
	end

	return uv2(slot1, uv3(slot0, uv4 / slot2))
end

function slot109(slot0)
	for slot5 = 1, #uv0(true) do
		slot0(slot1[slot5])
	end
end

function slot110(slot0)
	return slot0 ~= nil and not uv0(slot0) and uv1(slot0)
end

function slot111()
	slot0 = uv0()
	slot1 = uv1(uv2())

	uv4(function (slot0)
		if uv3:dist(uv0(uv1(slot0, uv2.head))) < uv4 then
			uv4 = slot2
		end
	end)

	return uv3
end

function slot112(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot113()
	return uv0(uv1) and uv0(uv2)
end

function slot114()
	return uv0(uv1) and uv0(uv2)
end

function slot115()
	slot0, slot1 = uv0()

	return {
		slot0 / 2,
		slot1 / 2
	}
end

function slot116(slot0, slot1)
	return uv0(uv1(slot0[1] - slot1[1], 2) + uv1(slot0[2] - slot1[2], 2))
end

function slot117()
	slot0 = uv0()
	slot2 = 8192

	uv1(function (slot0)
		slot1, slot2, slot3 = uv0(slot0, uv1.head)
		slot4, slot5 = uv2(slot1, slot2, slot3)

		if slot4 == nil then
			return
		end

		if uv3(uv4, {
			slot4,
			slot5
		}) < uv5 then
			uv5 = slot6
			uv6 = slot0
		end
	end)

	return nil
end

function slot118(slot0)
	if slot0 >= #uv0 then
		slot0 = uv1 - slot0
	end

	return uv2(uv0, 1, slot0)
end

function slot119(slot0)
	slot1 = uv0(slot0)

	return slot1 .. uv1(" ", uv2 - #slot1)
end

function slot120()
	return uv0() + uv1()
end

function slot121()
	slot0 = #uv0

	if not uv1 then
		slot0 = uv2(uv3() * uv4) % uv5
	end

	return uv6(slot0)
end

function slot122()
	uv0 = 0
	uv1 = 0
	uv2 = {}
	uv3 = nil
	uv4 = {}
	uv5 = {}
	uv6 = {}
	uv7 = 0
	uv8 = false
end

function slot123()
	if not uv0() and uv1() % uv2 ~= 0 then
		return
	end

	slot0 = uv3(uv4)
	slot2 = slot0

	if slot0 ~= uv3(uv5) then
		slot2 = uv6(slot0, slot1, uv7())
	end

	uv8(uv9, slot2)
end

function slot124()
	uv0(uv1, uv2(uv3))
end

function slot125()
	if not uv0(uv1) and not uv0(uv2) then
		return
	end

	slot2 = uv3()
	slot3 = uv0(uv4)

	if uv5(uv6) then
		slot4 = uv0(uv7)
		slot5 = uv8()
		slot6, slot7, slot8 = uv9()
		slot9 = 0

		for slot13 = 1, #uv10 do
			slot14, slot15, slot16 = uv11(uv6, uv10[slot13])

			if slot14 == nil then
				break
			end

			slot17, slot18 = uv12(slot5, slot6, slot7, slot8, slot14, slot15, slot16)

			if slot18 == uv6 then
				slot9 = slot9 + 1

				if uv13[uv6] == nil then
					uv13[uv6] = slot2
				end

				if not slot0 then
					break
				end
			end

			if not slot3 and slot4 > 0 and slot4 <= slot9 then
				slot3 = true

				break
			end
		end

		slot10 = uv0(uv14) / 1000

		if uv13[uv6] ~= nil then
			if slot9 == 0 then
				uv13[uv6] = nil
			elseif not uv15() and slot1 and slot2 < uv13[uv6] + slot10 then
				uv16[uv6] = true
			end
		end
	end

	if slot0 then
		uv17(uv18, slot3)
	end
end

function slot126()
	slot0 = false

	if not uv2(uv3(uv4), uv5[uv6[uv1(uv0())].type]) then
		for slot7 = 1, uv3(uv7) do
			if uv3(uv8[slot7]) then
				slot0 = true

				break
			end
		end
	end

	uv9(uv10, slot0 and "Always on" or "On hotkey")
end

function slot127()
	uv0(function (slot0)
		uv0(slot0, "High priority", uv1(slot0) == uv2.awp)
	end)
end

function slot128()
	if uv0() then
		return
	end

	slot0 = false

	for slot7 = 1, #uv1("CSmokeGrenadeProjectile") do
		if uv4(slot1[slot7], "m_bDidSmokeEffect") == 1 and uv2() < uv4(slot1[slot7], "m_nSmokeEffectTickBegin") + uv5 / uv3() then
			slot0 = true
		end
	end

	if not slot0 then
		return
	end

	slot4, slot5, slot6 = uv6()

	uv7(function (slot0)
		if uv0[slot0] then
			return
		end

		for slot5 = 1, #uv1 do
			if not true then
				break
			end

			slot6 = uv2(uv3(slot0, uv1[slot5]))

			for slot10 = 1, #uv4 do
				if not uv5(uv6, uv7, uv8, slot6.x + uv4[slot10][1], slot6.y + uv4[slot10][2], slot6.z) then
					slot1 = false

					break
				end
			end
		end

		if slot1 then
			uv0[slot0] = true
		end
	end)
end

function slot129()
	slot0 = uv0(uv1) / 1000
	slot1 = uv2()

	uv3(function (slot0)
		if uv0[slot0] == nil then
			return
		end

		if uv1(uv2(slot0, "m_fFlags"), uv3.onground) > 0 then
			return
		end

		if uv4 == 0 or uv5 < uv0[slot0] + uv4 then
			uv6[slot0] = true
		end
	end)
end

function slot130()
	if not uv0() or uv1() then
		return
	end

	if uv4(uv5[uv3(uv2())].type, 1, 1) ~= "p" and slot2 ~= "s" and slot2 ~= "r" and slot2 ~= "m" then
		return
	end

	slot4 = uv7(uv8) * 0.05
	slot5 = uv9()

	if uv6(slot0, "m_flFlashDuration") > 0 then
		if uv10 == 0 then
			uv11 = slot5
		end

		if slot5 - uv11 < slot3 - slot4 then
			uv12(function (slot0)
				uv0[slot0] = true
			end)
		end
	end

	uv10 = slot3
end

function slot131()
	slot0 = uv0()
	slot1 = 16

	uv1(function (slot0)
		if uv0(uv1(slot0, "m_fFlags"), uv2.fakeclient) > 0 then
			return
		end

		slot1 = uv1(slot0, "m_flSimulationTime")
		slot2 = uv1(slot0, "m_angEyeAngles[0]")
		slot3, slot4 = nil

		if uv3[slot0] ~= nil then
			if not uv4(slot0, "Correction active") then
				-- Nothing
			elseif uv5(uv1(slot0, "m_vecVelocity")):length2d() < 0.01 then
				-- Nothing
			elseif (slot1 - uv3[slot0]) / uv6 > 1 then
				if uv7 < slot3 then
					-- Nothing
				elseif uv8(slot2) <= uv9 then
					uv10[slot0] = true
				end
			end
		end

		uv3[slot0] = slot1
	end)

	slot2 = uv11(uv12)

	if uv10[uv13] then
		if slot2[1] ~= "Head" then
			slot2[#slot2 + 1] = "Head"
		end
	elseif slot2[1] == "Head" then
		slot2[1] = ""
	end

	uv14(uv12, slot2)
end

function slot132()
	uv0(function (slot0)
		uv0(slot0, "Add to whitelist", uv1[slot0])
	end)

	uv2 = {}
end

function slot133()
	if not uv1 and (uv0() - uv2 < uv3 or uv4() > 0) then
		return
	end

	if uv5() ~= uv6 or uv1 then
		uv7(slot1)

		uv6 = slot1
		uv1 = false
	end

	uv2 = slot0
end

function slot134()
	if uv0(uv1) then
		uv2()
	end
end

function slot135()
	for slot4 = 1, #{
		{
			uv0,
			uv1
		},
		{
			uv2,
			uv3
		},
		{
			uv4,
			uv5
		},
		{
			uv6,
			uv7
		},
		{
			uv8,
			uv9
		},
		{
			uv10,
			uv11
		},
		{
			uv12,
			uv13
		},
		{
			uv14,
			uv15
		}
	} do
		if uv16(slot0[slot4][1]) then
			slot0[slot4][2]()
		end
	end

	uv17()
	uv18()
end

function slot136()
	slot0, slot1, slot2, slot3 = uv0(uv1)

	if slot3 > 0 then
		uv2(slot0, slot1, slot2, slot3, uv3("FOV: %d°", uv0(uv4)))
	end
end

function slot137()
	if not uv0(uv1) then
		return
	end

	slot0, slot1, slot2, slot3 = uv0(uv2)

	if slot3 > 0 then
		uv3(slot0, slot1, slot2, slot3, "AWALL")
	end
end

function slot138()
	if not uv0(uv1()) then
		return
	end

	for slot4 = 1, #{
		{
			uv2,
			uv3
		},
		{
			uv4,
			uv5
		}
	} do
		if uv6(slot0[slot4][1]) then
			slot0[slot4][2]()
		end
	end

	if uv7() ~= uv8 then
		uv9 = uv10()
		uv8 = slot1
	end
end

function slot139(slot0)
	if client.userid_to_entindex(slot0.userid) == uv0() then
		uv1()
	end
end

function slot140(slot0)
	uv0[client.userid_to_entindex(slot0.userid)] = uv1()
end

function slot141()
	uv0()
end

function slot142()
	uv0 = true
end

function slot143(slot0, slot1)
	for slot5 = 1, #slot0 do
		ui.set_callback(slot0[slot5], slot1)
	end

	for slot5 = 1, #slot0 do
		slot1(slot0[slot5])
	end
end

function slot144(slot0, slot1)
	for slot5 = 1, #slot0 do
		ui.set_visible(slot0[slot5], slot1)
	end
end

function slot145(slot0)
	slot1 = slot0 and client.set_event_callback or client.unset_event_callback

	slot1("net_update_end", uv0)
	slot1("run_command", uv1)
	slot1("paint", uv2)
	slot1("player_spawn", uv3)
	slot1("player_jump", uv4)
	slot1("round_start", uv5)
	slot1("cs_win_panel_match", uv6)
	slot1("cs_win_panel_round", uv6)
	slot1("cs_pre_restart", uv6)
end

slot143({
	slot66,
	slot67,
	slot73,
	slot79,
	slot81,
	slot84,
	slot87,
	slot89
}, function ()
	slot0 = uv0(uv1)

	uv2({
		uv3,
		uv4,
		uv5,
		uv6,
		uv7,
		uv8,
		uv9,
		uv10,
		uv11,
		uv12,
		uv13,
		uv14,
		uv15,
		uv16,
		uv17,
		uv18,
		uv19
	}, slot0)
	uv2({
		uv20,
		uv21,
		uv22
	}, slot0 and uv0(uv3))
	uv2({
		uv8,
		uv9,
		uv23
	}, slot0 and uv0(uv6))
	uv2({
		uv24
	}, slot0 and uv0(uv11))
	uv2({
		uv25
	}, slot0 and uv0(uv12))
	uv2({
		uv26
	}, slot0 and uv0(uv14))
	uv2({
		uv18,
		uv17
	}, slot0 and uv0(uv16))

	for slot11 = 1, #uv27 do
		uv2({
			uv27[slot11]
		}, slot0 and slot6 and slot11 <= uv0(uv18))
	end

	if slot0 ~= uv28 then
		uv29(slot0)
	end

	uv28 = slot0
end)
slot143({
	slot69,
	slot70
}, function (slot0)
	slot1 = uv0(slot0)

	if slot0 == uv1 and uv0(uv2) < slot1 then
		uv3(uv2, slot1)
	elseif slot0 == uv2 and slot1 < uv0(uv1) then
		uv3(uv1, slot1)
	end
end)
slot143({
	slot65,
	ui.new_checkbox("LUA", "A", "Clan tag spammer")
}, function (slot0)
	if slot0 == uv0 and uv1(slot0) then
		uv2(uv3, false)
	elseif slot0 == uv3 then
		if uv1(slot0) then
			uv2(uv0, false)
		else
			client.delay_call(uv4(), function ()
				cvar.cl_clanid:invoke_callback()
			end)
		end
	end
end)
