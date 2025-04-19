slot0 = client.latency
slot1 = client.set_clan_tag
slot2 = client.log
slot3 = client.draw_rectangle
slot4 = client.draw_indicator
slot5 = client.draw_circle_outline
slot6 = client.timestamp
slot7 = client.world_to_screen
slot8 = client.userid_to_entindex
slot9 = client.draw_circle
slot10 = client.draw_gradient
slot11 = client.set_event_callback
slot12 = client.screen_size
slot13 = client.trace_line
slot14 = client.draw_text
slot15 = client.color_log
slot16 = client.system_time
slot17 = client.delay_call
slot18 = client.visible
slot19 = client.exec
slot20 = client.open_panorama_context
slot21 = client.set_cvar
slot22 = client.eye_position
slot23 = client.draw_hitboxes
slot24 = client.get_cvar
slot25 = client.draw_line
slot26 = client.camera_angles
slot27 = client.draw_debug_text
slot28 = client.random_int
slot29 = client.random_float
slot30 = entity.get_local_player
slot31 = entity.is_enemy
slot32 = entity.get_bounding_box
slot33 = entity.is_dormant
slot34 = entity.get_steam64
slot35 = entity.get_player_name
slot36 = entity.hitbox_position
slot37 = entity.get_game_rules
slot38 = entity.get_all
slot39 = entity.set_prop
slot40 = entity.is_alive
slot41 = entity.get_player_weapon
slot42 = entity.get_prop
slot43 = entity.get_players
slot44 = entity.get_classname
slot45 = globals.realtime
slot46 = globals.absoluteframetime
slot47 = globals.tickcount
slot48 = globals.lastoutgoingcommand
slot49 = globals.curtime
slot50 = globals.mapname
slot51 = globals.tickinterval
slot52 = globals.framecount
slot53 = globals.frametime
slot54 = globals.maxplayers
slot55 = ui.new_slider
slot56 = ui.new_combobox
slot57 = ui.reference
slot58 = ui.is_menu_open
slot59 = ui.set_visible
slot60 = ui.new_textbox
slot61 = ui.new_color_picker
slot62 = ui.set_callback
slot63 = ui.set
slot64 = ui.new_checkbox
slot65 = ui.new_hotkey
slot66 = ui.new_button
slot67 = ui.new_multiselect
slot68 = ui.get
slot69 = math.ceil
slot70 = math.tan
slot71 = math.cos
slot72 = math.sinh
slot73 = math.pi
slot74 = math.max
slot75 = math.atan2
slot76 = math.floor
slot77 = math.sqrt
slot78 = math.deg
slot79 = math.atan
slot80 = math.fmod
slot81 = math.acos
slot82 = math.pow
slot83 = math.abs
slot84 = math.min
slot85 = math.sin
slot86 = math.log
slot87 = math.exp
slot88 = math.cosh
slot89 = math.asin
slot90 = math.rad
slot91 = table.sort
slot92 = table.remove
slot93 = table.concat
slot94 = table.insert
slot95 = string.find
slot96 = string.format
slot97 = string.gsub
slot98 = string.len
slot99 = string.gmatch
slot100 = string.match
slot101 = string.reverse
slot102 = string.upper
slot103 = string.lower
slot104 = string.sub
slot105 = renderer.line
slot106 = renderer.indicator
slot107 = renderer.world_to_screen
slot108 = renderer.circle_outline
slot109 = renderer.rectangle
slot110 = renderer.gradient
slot111 = renderer.circle
slot112 = renderer.text
slot113 = ui.new_multiselect("VISUALS", "Other ESP", "Grenades: Timer ", "Text", "Bar")
slot114 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Smoke radius")
slot115 = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Smoke radius", 61, 147, 250, 180)
slot116 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov radius")
slot117 = ui.new_color_picker("VISUALS", "Other ESP", "Grenades: Molotov radius", 255, 63, 63, 190)
slot118 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Molotov team")
slot119 = ui.new_checkbox("VISUALS", "Other ESP", "Grenades: Timer")

ui.set_callback(slot119, function ()
	if uv0(uv1) and #uv0(uv2) == 0 then
		uv3(uv2, {
			"Text"
		})
		uv3(uv1, false)
	end
end)
ui.set_visible(slot119, false)

slot121 = 125
slot122 = 17.55
slot123 = 7
slot124 = {}
slot125 = {}
slot126 = {}
slot127 = {}
slot128 = true
slot129 = 26
slot130 = 8

function slot131(slot0, slot1, slot2, slot3)
	return uv0((slot2 - slot0)^2 + (slot3 - slot1)^2)
end

function slot132(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot133(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10)
	slot11 = slot8 == nil and true or slot8

	if slot9 == nil then
		-- Nothing
	end

	slot12 = slot9
	slot14 = 4

	if ((slot10 ~= nil or not true) and not slot10 or slot2 <= 2 or slot14 <= 2) and slot2 <= 0 and slot14 <= 0 then
		error("Invalid arguments. Width and/or height too small")
	end

	slot15 = uv0(0, uv1(1, slot7))
	slot20 = 0
	slot21 = 0

	if slot13 then
		slot19 = slot14 - 2
		slot18 = slot2 - 2
		slot17 = slot1 + 1
		slot16 = slot0 + 1
	end

	if slot12 then
		slot20 = slot18 - uv2(slot18 * slot15)
	end

	if not slot11 then
		slot14 = slot2
		slot2 = slot14
		slot19 = slot18
		slot18 = slot19
		slot21 = slot20
		slot20 = slot21
	end

	if slot13 then
		uv3(slot0, slot1, slot2, slot14, 16, 16, 16, 170)
	end

	uv3(slot16 + slot20, slot17 + slot21, slot18, slot19, slot3, slot4, slot5, slot6)

	return slot16 + slot20, slot17 + slot21, slot18, slot19
end

function slot134(slot0)
	return uv0(slot0) == "CCSPlayer"
end

function slot135(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	return (slot3 - slot0) * slot6 + slot0, (slot4 - slot1) * slot6 + slot1, (slot5 - slot2) * slot6 + slot2
end

function slot136(slot0, slot1, slot2, slot3, slot4, slot5)
	return uv0((slot3 - slot0)^2 + (slot4 - slot1)^2 + (slot5 - slot2)^2)
end

function slot137(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	slot10 = -1
	slot11 = slot1
	slot12 = slot2
	slot13 = slot3
	slot14 = -1
	slot15 = 1

	while (slot10 == -1 or slot10 ~= 0 and slot0(slot10)) and 0 < 1 and slot15 <= (slot7 or 10) do
		slot16, slot10 = uv0(slot10, slot11, slot12, slot13, slot4, slot5, slot6)
		slot11, slot12, slot13 = uv1(slot11, slot12, slot13, slot4, slot5, slot6, slot16)
		slot15 = slot15 + 1
	end

	return uv2(slot1, slot2, slot3, slot11, slot12, slot13) / uv2(slot1, slot2, slot3, slot4, slot5, slot6), slot10
end

function slot138(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12)
	slot14 = slot9 ~= nil and slot9 or 1
	slot15 = slot10 ~= nil and slot10 or false
	slot18, slot19 = nil

	for slot23 = slot11 ~= nil and slot11 or 0, (slot12 ~= nil and slot12 or 1) * 360, slot8 ~= nil and slot8 or 3 do
		slot24 = uv0(slot23)
		slot25 = slot3 * uv1(slot24) + slot0
		slot26 = slot3 * uv2(slot24) + slot1
		slot27 = slot2
		slot28 = 256
		slot29, slot30 = uv3(-1, slot25, slot26, slot27 + slot28 / 2, slot25, slot26, slot27 - slot28 / 2)

		if slot29 > 0 and slot29 < 1 then
			slot27 = slot27 + slot28 / 2 - slot28 * slot29
		end

		slot31, slot32 = uv4(slot25, slot26, slot27)

		if slot31 ~= nil and slot18 ~= nil then
			for slot36 = 1, slot14 do
				slot37 = slot36 - 1

				uv5(slot31, slot32 - slot37, slot18, slot19 - slot37, slot4, slot5, slot6, slot7)
			end

			if slot15 then
				slot33 = slot7 / 255 * 160

				uv5(slot31, slot32 - slot14, slot18, slot19 - slot14, 16, 16, 16, slot33)
				uv5(slot31, slot32 + 1, slot18, slot19 + 1, 16, 16, 16, slot33)
			end
		end

		slot19 = slot32
		slot18 = slot31
	end
end

function slot139(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12)
	slot14 = slot9 ~= nil and slot9 or 1
	slot15 = slot10 ~= nil and slot10 or false

	for slot23 = slot11 ~= nil and slot11 or 0, (slot12 ~= nil and slot12 or 1) * 360, slot8 ~= nil and slot8 or 3 do
		slot24 = uv0(slot23)
		slot28, slot29 = uv3(slot3 * uv1(slot24) + slot0, slot3 * uv2(slot24) + slot1, slot2)

		if slot28 ~= nil and nil ~= nil then
			for slot33 = 1, slot14 do
				slot34 = slot33 - 1

				uv4(slot28, slot29 - slot34, slot18, slot19 - slot34, slot4, slot5, slot6, slot7)
			end

			if slot15 then
				slot30 = slot7 / 255 * 160

				uv4(slot28, slot29 - slot14, slot18, slot19 - slot14, 16, 16, 16, slot30)
				uv4(slot28, slot29 + 1, slot18, slot19 + 1, 16, 16, 16, slot30)
			end
		end

		slot19 = slot29
		slot18 = slot28
	end
end

function slot140(slot0, slot1, slot2)
	return slot1 + (slot1 - slot0) * slot2
end

function slot141(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	return (slot3 - slot0) * slot6 + slot0, (slot4 - slot1) * slot6 + slot1, (slot5 - slot2) * slot6 + slot2
end

function slot142(slot0)
	return uv0(slot0, "m_fireCount") ~= nil and slot1 > 0
end

client.set_event_callback("player_connect_full", function (slot0)
	if uv0(slot0.userid) == uv1() then
		uv2 = {}
		uv3 = {}
	end
end)
client.set_event_callback("run_command", function (slot0)
	if not uv0(uv1) then
		return
	end

	uv2 = {}
	uv3 = {}
	uv4 = uv5("CInferno")

	if #uv4 == 0 then
		return
	end

	slot1 = uv6()

	for slot5 = 1, #uv4 do
		if uv7(uv4[slot5]) then
			slot7, slot8, slot9 = uv8(slot6, "m_vecOrigin")
			slot10 = 40
			slot11 = 0
			slot12, slot13, slot14 = nil
			slot15 = {}
			slot16 = {}
			slot17 = 0
			slot18, slot19 = nil

			for slot23 = 1, 64 do
				if uv8(slot6, "m_bFireIsBurning", slot23) == 1 then
					uv9(slot15, {
						uv8(slot6, "m_fireXDelta", slot23),
						uv8(slot6, "m_fireYDelta", slot23),
						uv8(slot6, "m_fireZDelta", slot23)
					})
				end
			end

			for slot23 = 1, #slot15 do
				slot25, slot26, slot27 = unpack(slot15[slot23])

				for slot31 = 1, #slot15 do
					slot32 = slot15[slot31]

					if slot17 < uv10(slot25, slot26, slot32[1], slot32[2]) then
						slot17 = slot33
						slot18 = slot24
						slot19 = slot32
					end
				end
			end

			if slot18 ~= nil and slot19 ~= nil then
				slot20 = slot7 + slot18[1]
				slot21 = slot8 + slot18[2]
				slot22 = slot9 + slot18[3]
				slot23 = slot7 + slot19[1]
				slot24 = slot8 + slot19[2]
				slot25 = slot9 + slot19[3]
				slot26, slot27, slot28 = uv11(slot18[1], slot18[2], slot18[3], slot19[1], slot19[2], slot19[3], 0.5)
				uv2[slot6] = {
					slot7 + slot26,
					slot8 + slot27,
					slot9 + slot28,
					slot17 / 2 + slot10
				}
				uv3[slot6] = slot15
			end
		end
	end
end)
client.set_event_callback("paint", function ()
	slot0 = uv0(uv1)
	slot2 = #uv0(uv2) > 0
	slot3 = uv0(uv3)
	slot4 = uv0(uv4)

	if uv5() == nil or not uv6(slot5) or uv7(slot5, "m_MoveType") == uv8 then
		uv9()
	end

	if slot4 then
		slot6, slot7, slot8, slot9 = uv0(uv10)

		for slot13 = 1, #uv11 do
			if uv12[uv11[slot13]] ~= nil then
				slot15, slot16, slot17, slot18 = unpack(uv12[slot14])
				slot19 = 1

				if uv13[grenade] ~= nil then
					slot19 = uv14(0, 1 - (curtime - uv13[grenade]) / uv15)
				end

				uv16(slot15, slot16, slot17, slot18, slot6, slot7, slot8, slot9 * slot19, 9, 1, true)
			end
		end
	end

	if slot0 or slot2 or slot3 then
		slot6 = uv17("CSmokeGrenadeProjectile")
		slot7 = uv18()
		slot8 = uv19()
		slot9 = uv20()

		if slot2 or slot3 then
			slot10 = uv13
			uv13 = {}

			for slot14 = 1, #uv11 do
				if uv21(uv11[slot14]) then
					uv13[slot15] = slot10[slot15] ~= nil and slot10[slot15] or slot9

					uv22(slot6, slot15)
				end
			end
		end

		for slot13 = 1, #slot6 do
			slot16, slot17, slot18 = nil
			slot19 = 1

			if uv23(slot6[slot13]) == "CSmokeGrenadeProjectile" then
				slot20, slot21, slot22 = uv7(slot14, "m_vecOrigin")
				slot17, slot18 = uv24(slot20, slot21, slot22)

				if slot17 ~= nil and uv7(slot14, "m_bDidSmokeEffect") == 1 and uv7(slot14, "m_nSmokeEffectTickBegin") ~= nil and slot8 * (slot7 - slot24) > 0 and uv25 - slot25 > 0 then
					if slot2 then
						slot19 = 1 - slot25 / uv25
						slot16 = uv26("%.1f", uv25 - slot25)
					end

					if slot0 then
						slot26, slot27, slot28, slot29 = uv0(uv27)
						slot30 = uv28

						if slot25 < 0.3 then
							slot30 = slot30 * 0.6 + slot30 * slot25 / 0.3 * 0.4
							slot29 = slot29 * slot25 / 0.3
						end

						if uv25 - slot25 < 1 then
							slot30 = slot30 * ((uv25 - slot25) / 1 * 0.3 + 0.7)
						end

						uv16(slot20, slot21, slot22, slot30, slot26, slot27, slot28, slot29 * uv29(1, slot19 * 1.3), 9, 1, true)
					end
				end
			elseif slot15 == "CInferno" and (slot2 or slot3) then
				slot20, slot21, slot22 = uv7(slot14, "m_vecOrigin")
				slot23, slot18 = uv24(slot20, slot21, slot22)

				if slot23 ~= nil then
					if slot2 and uv13[slot14] ~= nil then
						slot23 = slot9 - uv13[slot14]
						slot19 = uv14(0, 1 - slot23 / uv15)
						slot16 = uv26("%.1f", uv14(0, uv15 - slot23))
					end

					if slot3 then
						slot24 = false

						if uv7(slot14, "m_hOwnerEntity") ~= nil and tonumber(uv30("mp_friendlyfire")) == 0 and slot23 ~= slot5 and not uv31(slot23) then
							slot24 = true
						end

						if slot24 then
							uv32(slot17 - 19, slot18 + 5, 149, 184, 6, 255 * slot19, nil, 0, "✔")
						else
							uv32(slot17 - 19, slot18 + 4, 230, 21, 21, 255 * slot19, nil, 0, "❌")
						end
					end
				end
			end

			if slot17 ~= nil and slot16 ~= nil then
				if slot19 < 0.08 then
					slot20 = 255 * slot19 / 0.08
				end

				if uv33(slot1, "Bar") then
					slot22, slot23, slot24, slot25 = uv34(slot17 - uv35 / 2 + 1, slot18 + 16 + (uv33(slot1, "Bar") and uv33(slot1, "Text") and 1 or 0), uv35, 255, 255, 255, slot20, slot19, true)

					if uv33(slot1, "Text") and slot19 < 0.56 then
						uv32(slot22 + slot24 + 5, slot18 + 18 + slot21, 255, 255, 255, slot20 * 0.7, "c-", 150, slot16)
					end
				elseif uv33(slot1, "Text") then
					uv32(slot17, slot18 + 20, 255, 255, 255, uv14(30, slot19 * 255), "c-", 150, slot16, "  S")
				end
			end
		end
	end
end)
