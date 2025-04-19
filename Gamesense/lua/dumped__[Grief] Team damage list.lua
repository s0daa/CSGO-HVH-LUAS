slot0 = client.key_state
slot1 = client.userid_to_entindex
slot3 = database.write
slot4 = entity.get_local_player
slot5 = entity.get_player_name
slot6 = entity.get_prop
slot7 = entity.get_steam64
slot8 = renderer.rectangle
slot9 = renderer.text
slot10 = ui.get
slot11 = ui.is_menu_open
slot12 = ui.mouse_position
slot16 = pairs
slot18 = cvar.mp_td_dmgtokick
slot19 = entity.get_player_resource
slot20 = client.set_event_callback
slot21 = client.unset_event_callback
slot22 = math.min
slot23 = table.remove

function slot24(slot0, slot1, slot2, slot3, slot4, slot5)
	return slot2 <= slot0 and slot0 <= slot4 and slot3 <= slot1 and slot1 <= slot5
end

slot26 = database.read("teamdmg_pos") or {
	300,
	30
}
slot27 = slot26[1]
slot28 = slot26[2]
slot29, slot30, slot31 = nil

function slot32(slot0, slot1, slot2, slot3)
	if not uv0() then
		return uv1, uv2
	end

	if uv3(1) then
		slot5, slot6 = uv4()

		if not uv5 then
			if uv6(slot5, slot6, slot0, slot1, slot0 + slot2, slot1 + slot3) then
				uv5 = true
				uv8 = slot6 - slot1
				uv7 = slot5 - slot0
			end
		else
			uv2 = slot6 - uv8
			uv1 = slot5 - uv7
		end
	else
		uv5 = false
	end

	return uv1, uv2
end

slot33 = ui.new_combobox("lua", "a", "Show Teammates Damage/Kills", "Off", "Without Colors", "Matchmaking Colors", "Matchmaking Color Names")
slot34 = ui.new_hotkey("lua", "a", "hotkey", true)
slot35 = ui.new_checkbox("lua", "a", "Remove from list when over amount")
slot37, slot38, slot39 = client.system_time()
slot41 = function (slot0)
	for slot5 in uv0(slot0) do
		slot1 = 0 + 1
	end

	return slot1
end((slot2("teamdmg_pos_last") or {})[slot37 .. slot38] or {})
slot42 = {
	255,
	255,
	255,
	255
}
slot43 = nil
slot44 = {
	{
		200,
		200,
		200,
		255,
		"BOT"
	},
	{
		200,
		200,
		200,
		255,
		"Gray"
	},
	{
		255,
		255,
		0,
		255,
		"Yellow"
	},
	{
		110,
		0,
		255,
		255,
		"Purple"
	},
	{
		0,
		200,
		0,
		255,
		"Green"
	},
	{
		0,
		75,
		255,
		255,
		"Blue"
	},
	{
		255,
		145,
		0,
		255,
		"Orange"
	}
}

function slot45(slot0)
	slot3 = uv1()

	if uv0(slot0.attacker) == uv0(slot0.userid) then
		return
	end

	slot4 = uv2()

	if uv3(slot4, "m_iTeam", slot1) ~= uv3(slot4, "m_iTeam", slot3) or uv3(slot4, "m_iTeam", slot2) ~= slot5 then
		return
	end

	if uv4(slot1) == 0 then
		return
	end

	if not uv5[slot8] then
		uv5[slot8] = {
			0,
			0,
			uv6(slot1),
			uv7,
			uv8[uv3(slot4, "m_iCompTeammateColor", slot1) + 3],
			slot1
		}
		uv9 = uv9 + 1
	end

	if not slot0.health then
		uv5[slot8][1] = uv5[slot8][1] + 1
	else
		uv5[slot8][2] = uv5[slot8][2] + slot0.dmg_health
	end

	uv5[slot8][4] = uv10 == "Without Colors" and uv7 or uv5[slot8][5]
	uv5[slot8][3] = uv10 == "Matchmaking Color Names" and uv5[slot8][5][5] or uv6(slot1)
end

function slot46()
	if not uv0(uv1) then
		return
	end

	slot0, slot1 = uv2(uv3, uv4, 200, 20)

	uv5(slot0, slot1, 200, 20, 37, 37, 37, 250)

	slot11 = "Player List"

	uv6(slot0 + 100, slot1 + 10, 255, 255, 255, 255, "cd", 0, slot11)
	uv5(slot0, slot1 + 20, 200, uv7 * 10 + 10, 33, 33, 33, 180)

	slot2 = slot1 + 25
	slot3 = uv8:get_int()
	slot5 = 0
	slot7 = uv11(uv10(), "m_iTeam", uv12())

	for slot11, slot12 in uv13(uv14) do
		slot14 = slot12[4]

		uv6(slot0 + 5, slot2 + slot5, slot14[1], slot14[2], slot14[3], slot14[4], "ld", 42, slot12[3])
		uv5(slot0 + 50, slot2 + slot5 - 3 + 7, 100, 6, 13, 13, 13, 230)
		uv5(slot0 + 51, slot2 + slot5 - 2 + 7, 98 * uv15(slot12[2] / slot3, 1), 4, 49, 233, 93, 255)
		uv6(slot0 + 100, slot2 + slot5 + 7, 255, 255, 255, 255, "c-d", 0, slot12[2] .. "/" .. slot3)
		uv6(slot0 + 195, slot2 + slot5, 255, 255, 255, 255, "rd", 0, slot12[1] .. " Kills")

		slot5 = slot5 + 11

		if uv0(uv9) and (slot12[1] >= 3 or slot3 <= slot12[2]) then
			uv16(uv14, slot11)
		end

		if uv11(slot6, "m_iTeam", slot12[6]) ~= slot7 then
			uv16(uv14, slot11)
		end
	end
end

function slot48()
	uv0("teamdmg_pos", {
		uv1,
		uv2
	})

	slot0, slot1 = client.system_time()

	uv0("teamdmg_pos_last", {
		[slot0 .. slot1] = uv3
	})
end

function slot49(slot0)
	slot2 = uv0(slot0) ~= "Off" and uv1 or uv2
	uv3 = slot1

	slot2("player_hurt", uv4)
	slot2("player_death", uv4)
	slot2("paint", uv5)
	slot2("cs_win_panel_match", uv6)
	slot2("shutdown", uv7)
end

slot49(slot33)
ui.set_callback(slot33, slot49)
ui.new_button("lua", "a", "Reset List", function (slot0)
	uv1 = 0
	uv0 = {}
end)
