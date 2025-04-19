slot0 = false
slot1 = false
slot2 = false
slot3 = false
slot4 = false
slot5 = false
slot6 = false
slot7 = true
slot8 = "nil"
slot9 = ui.get
slot10 = ui.set
slot11 = ui.reference
slot12 = ui.new_checkbox
slot14 = ui.new_combobox
slot16 = ui.set_visible
slot17 = ui.set_callback
slot18 = client.color_log
slot19 = client.set_event_callback
slot20 = client.unset_event_callback
slot22 = client.userid_to_entindex
slot23 = client.delay_call
slot24 = client.exec
slot25 = entity.get_local_player
slot26 = entity.get_prop
slot27 = globals.mapname
slot28 = string.rep
slot29 = string.len
slot30 = string.sub
slot31 = slot11("MISC", "Miscellaneous", "Steal player name")
slot32 = slot11("MISC", "Miscellaneous", "Clan tag spammer")
slot33 = cvar.name:get_string()
slot34 = client.set_clan_tag

function slot35(slot0)
	cvar.name:set_string(slot0)
end

slot19("player_connect_full", function (slot0)
	if uv0(slot0.userid) == uv1() and uv2() ~= nil then
		uv3 = true
	end
end)

slot36 = {
	Cooldown = "abandoned the match and received a ",
	Ban = "has been permanently banned from official CS:GO servers."
}
slot37 = {
	["2-Hrs"] = "2 hour competitive matchmaking cooldown.",
	["24-Hrs"] = "24 hour competitive matchmaking cooldown.",
	["30-Mins"] = "30 minute competitive matchmaking cooldown.",
	["7-Days"] = "7 day competitive matchmaking cooldown."
}
slot38 = slot12("LUA", "A", "Enable Troll-Name")
slot39 = slot12("LUA", "A", "CleanChat on initial change")
slot42 = slot14("LUA", "A", "Ban Length", "30-Mins", "2-Hrs", "24-Hrs", "7-Days")
slot43 = ui.new_label("LUA", "A", "Player Name")
slot44 = ui.new_textbox("LUA", "A", "Textbox")
slot45 = ui.new_slider("LUA", "A", "Gap Value", 1, 20, 1, true)

function slot46()
	uv0 = false
	uv1 = false
	uv2 = false
	uv3 = false
	uv4 = false
	uv5 = false
end

function slot47(slot0)
	uv0 = slot0

	uv1(3, 198, 252, "Current Input: " .. uv0)

	return true
end

function slot48()
	for slot4 = 1, #uv0(uv1) do
		if slot0[slot4] ~= "Auto-Disconnect" then
			uv2 = false
		end

		if slot0[slot4] ~= "Auto-Disconnect-Dmg" then
			uv3 = false
		end

		if slot0[slot4] ~= "Auto-Revert Name" then
			uv4 = false
		end

		if slot0[slot4] ~= "Hide Name Change" then
			uv5 = false
		end

		if slot0[slot4] ~= "Use Console Value" then
			uv6 = false
		end

		if slot0[slot4] ~= "Custom Gap Value" then
			uv7 = false
		end
	end

	for slot4 = 1, #slot0 do
		if slot0[slot4] == "Auto-Disconnect" then
			uv2 = true
		end

		if slot0[slot4] == "Auto-Disconnect-Dmg" then
			uv3 = true
		end

		if slot0[slot4] == "Auto-Revert Name" then
			uv4 = true
		end

		if slot0[slot4] == "Hide Name Change" then
			uv5 = true
		end

		if slot0[slot4] == "Use Console Value" then
			uv6 = true
		end

		if slot0[slot4] == "Custom Gap Value" then
			uv7 = true
		end
	end

	if next(uv0(uv1)) == nil then
		uv8()
	end
end

function slot50()
	slot1 = uv1(uv3)
	slot2 = ""
	slot3 = ""
	slot4 = ""
	slot5 = nil
	uv4 = false
	slot4 = uv5 and uv6 or uv1(uv7)

	if uv1(uv2) == "Cooldown" then
		slot0 = uv0[uv1(uv2)] .. uv8[uv1(uv9)]
	end

	slot6 = uv10(slot4 .. slot0)

	if uv13 then
		uv14()
		uv15(" " .. slot4 .. " " .. (slot0 .. ((not uv11 or uv12("ᅠ", GapValue)) and " ")) .. " ? ")
		uv16(0.8, uv17, "disconnect")
		uv16(5.2, function ()
			uv0(uv1, false)
			print("Automatically disconnected from the server after setting Banned-Name.")
		end)
	elseif uv20 then
		if uv10(slot4) > 12 then
			uv21(252, 3, 3, "Clamped the clantag, don't use \"Hide Name Change\" if the input is more than 12 chars.")
		end

		uv14(" " .. uv22(slot4, 0, 12) .. "\n")
		uv15("" .. slot8 .. "You")
	else
		uv14()
		uv15(" " .. slot4 .. " " .. slot8 .. "You")
	end

	print(slot6)
end

slot51 = ui.new_button("LUA", "A", "Set Name", function ()
	slot0 = uv0(uv1)

	uv2(uv3, true)
	uv4("\n\\xad\\xad\\xad\\xad")
	uv5(0, function ()
		if uv0 and uv1 and uv2(uv3) then
			uv4(0.01, uv5, "Say " .. uv6(" ﷽﷽", 40))
			print("Spammed the chat in an attempt to hide the initial name change.")
		end
	end)
	uv5(0.2, uv12)
end)

function ()
	slot0 = uv0(uv1)

	uv2(uv3, slot0)
	uv2(uv4, slot0)
	uv2(uv5, slot0)
	uv2(uv6, slot0)
	uv2(uv7, slot0)
	uv2(uv8, slot0)

	if slot0 then
		uv9 = cvar.name:get_string()
		uv10 = true
	elseif uv10 == true then
		uv11(uv9)
		uv12()
		uv13()

		uv10 = false
	end

	uv14()
end()
slot17(ui.new_multiselect("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Disconnect-Dmg", "Auto-Revert Name", "Hide Name Change", "Use Console Value", "Custom Gap Value"), function ()
	if uv0(uv1) then
		uv2()

		if uv0(uv3) == "Cooldown" then
			uv4(uv5, true)
		else
			uv4(uv5, false)
		end

		if uv6 then
			uv4(uv7, true)
		else
			uv4(uv7, false)
		end

		if uv8 then
			uv9(uv10, false)
			uv4(uv11, true)
		else
			uv4(uv11, false)
		end

		if uv12 then
			uv13("clear")
			uv14(181, 252, 3, "Simply enter the text you want as input.")
			uv14(252, 3, 3, "WARNING: The game will not process any console inputs until you turn off \"Use Console Value\" or the main checkbox for the script.")
			uv14(3, 252, 169, "Last Input: " .. uv15)
			uv4(uv16, false)
			uv4(uv17, false)
			uv18("console_input", uv19)
		else
			uv4(uv16, true)
			uv4(uv17, true)
			uv13("clear")
			uv20("console_input", uv19)
		end
	else
		uv4(uv16, false)
		uv4(uv5, false)
		uv4(uv17, false)
		uv4(uv7, false)
		uv4(uv11, false)
		uv20("console_input", uv19)
	end
end)
slot17(slot14("LUA", "A", "Name Type", "Ban", "Cooldown"), function ()
	uv0()
end)

function slot54(slot0)
	if uv2(slot0.attacker) == slot1 and uv1(uv2(slot0.userid), "m_iTeamNum") == uv1(uv0(), "m_iTeamNum") then
		if uv3 then
			uv4(uv5, false)
			print("Reverted name and disabled the main checkbox for the script.")
		end

		if uv6 then
			uv4(uv5, false)
			uv7("Disconnect")
			print("Disconnected from the server after reverting name.")
		end
	end
end

function slot55(slot0)
	uv0()
	uv1(slot0) and uv2 or uv3("player_hurt", uv4)
end

slot19("shutdown", function ()
	uv0(uv1, false)
end)
slot55(slot38)
slot17(slot38, slot55)
