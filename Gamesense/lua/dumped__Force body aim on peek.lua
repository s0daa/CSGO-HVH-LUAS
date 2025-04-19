slot0 = require("vector")
slot1 = require("gamesense/entity")
slot2 = require("gamesense/antiaim_funcs")
slot3 = require("gamesense/csgo_weapons")
slot7 = ui.new_slider("RAGE", "Other", "Trace add distance", 5, 50, 20, true, "u")
slot11, slot12 = ui.reference("Rage", "Other", "Double tap")
slot13 = false
slot14 = {
	2,
	3,
	4,
	5,
	7,
	8
}
slot15 = {}
slot16 = nil

function slot17(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true, slot5
		end
	end

	return false, -1
end

function slot18(slot0, slot1, slot2)
	return slot1 + uv0(slot0:get_prop("m_vecVelocity")) * slot2 * globals.tickinterval()
end

function slot19(slot0)
	for slot4, slot5 in ipairs(slot0) do
		plist.set(slot5:get_entindex(), "Override prefer body aim", "-")
	end
end

function slot20(slot0)
	slot1 = uv0(slot0:get_prop("m_vecOrigin"))
	slot1.z = slot1.z + slot0:get_prop("m_vecViewOffset[2]")

	return slot1
end

function slot21(slot0, slot1)
	slot2, slot3 = slot0:to(slot1):vectors()
	slot4 = slot0:clone() + slot2
	slot4.z = slot0.z
	slot5 = ui.get(uv0)

	return {
		slot4,
		slot4 + slot2 * slot5,
		slot4 - slot2 * slot5
	}
end

function slot22(slot0, slot1, slot2, slot3)
	slot7 = 0

	for slot11, slot12 in ipairs(uv2(slot2 and uv0(slot0, uv1(slot0), 5) or uv1(slot0), uv1(slot1))) do
		slot13 = 0

		for slot17 = 1, #uv3 do
			slot18 = uv4(slot1:hitbox_position(uv3[slot17]))
			slot19, slot20 = slot0:trace_bullet(slot12.x, slot12.y, slot12.z, slot18.x, slot18.y, slot18.z, false)

			if slot7 < slot20 then
				slot7 = slot20
			end

			if slot13 < slot20 then
				slot13 = slot20
			end
		end

		if slot3 then
			slot15 = uv4(renderer.world_to_screen(slot12:unpack()))
			slot16 = uv4(renderer.world_to_screen(slot4:unpack()))

			if uv4(renderer.world_to_screen(slot5:unpack())):length() ~= 0 and slot15:length() ~= 0 and slot16:length() ~= 0 then
				renderer.text(slot15.x, slot15.y, 255, 0, 0, 255, "d+", 0, string.format("%s", slot13))
				renderer.line(slot14.x, slot14.y, slot15.x, slot15.y, 255, 255, 255, 255)
				renderer.line(slot15.x, slot15.y, slot16.x, slot16.y, 255, 255, 255, 255)
			end
		end
	end

	return slot7
end

function slot23(slot0)
	return slot0 and slot0.cycletime and slot0.cycletime >= 0.2 and slot0.cycletime <= 0.3
end

function slot24(slot0, slot1, slot2)
	if slot1 <= slot2 then
		return true
	end

	if ui.get(uv0) and ui.get(uv1) and uv2.get_tickbase_shifting() > 2 and uv3(ui.get(uv4), "Double tap") then
		return uv5(slot0) and slot1 <= slot2 * 2
	end

	return false
end

function slot25(slot0)
	if uv0.new(client.current_threat()) == nil then
		return
	end

	if uv1(uv2, slot1:get_entindex()) then
		return
	end

	slot3 = slot1:get_entindex()
	slot5 = uv4(uv0.get_local_player(), slot1, uv1(ui.get(uv3), "Extrapolate local player"), slot0)

	if slot0 then
		return
	end

	slot9 = uv6(uv5(slot2:get_player_weapon():get_entindex()), slot1:get_prop("m_iHealth"), slot5)

	if uv7 ~= nil and uv7:get_entindex() ~= slot3 then
		plist.set(uv7:get_entindex(), "Override prefer body aim", "-")
	end

	uv7 = slot1

	plist.set(slot3, "Override prefer body aim", slot9 and "Force" or "-")
end

function slot26(slot0)
	uv0(false)
end

function slot27()
	uv0(true)
end

function slot28(slot0)
	return ui.get(uv0) and plist.get(slot0, "Override prefer body aim") == "Force" and not uv1(uv2, slot0)
end

function slot29()
	slot0 = uv0(ui.get(uv1), "I'm an advanced user") and ui.get(uv2)

	ui.set_visible(uv3, slot0)
	ui.set_visible(uv4, slot0)
	slot0 and ui.get(uv3) and client.set_event_callback or client.unset_event_callback("paint", uv5)
end

function slot30()
	slot1 = ui.get(uv0) and client.set_event_callback or client.unset_event_callback

	slot1("setup_command", uv1)
	slot1("round_prestart", function ()
		uv0(uv1.get_players(true))
	end)

	if not uv4 then
		client.register_esp_flag("FORCE", 255, 255, 255, uv5)

		uv4 = true
	end

	ui.set_visible(uv6, slot0)
	uv7()
end

ui.set_callback(ui.new_checkbox("RAGE", "Other", "Force baim on lethal"), slot30)
ui.set_callback(ui.new_multiselect("RAGE", "Other", "\n", "Extrapolate local player", "Double tap", "I'm an advanced user"), slot29)
ui.set_callback(ui.new_checkbox("RAGE", "Other", "Visualise calculations"), slot29)
slot30()
ui.set_callback(ui.new_checkbox("PLAYERS", "Adjustments", "Ignore force baim calculations"), function (slot0)
	slot2 = ui.get(uv0)
	slot3, slot4 = uv1(uv2, ui.get(uv0))

	if ui.get(slot0) and not slot3 then
		table.insert(uv2, slot2)
		plist.set(slot2, "Override prefer body aim", "-")
		client.update_player_list()
	elseif not slot1 and slot3 then
		table.remove(uv2, slot4)
	end
end)
ui.set_callback(ui.reference("PLAYERS", "Players", "Player list"), function (slot0)
	ui.set(uv0, uv1(uv2, ui.get(slot0)))
end)
ui.set_callback(ui.reference("PLAYERS", "Players", "Reset all"), function ()
	uv0 = {}

	ui.set(uv1, false)
end)
