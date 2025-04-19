slot2 = entity.get_players
slot3 = entity.get_prop
slot4 = plist.get
slot5 = plist.set
slot6 = ui.get
slot10 = ui.set_callback
slot11 = ui.set_visible
slot12 = require("bit")
slot13 = ui.new_checkbox("RAGE", "Other", "Force safe point conditions")
slot14 = ui.new_multiselect("RAGE", "Other", "\nbox", "Duck", "X > HP", "In air")
slot15 = ui.new_slider("RAGE", "Other", "X > HP", 1, 100, 70, true, "HP", 1)

function slot16(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot17(slot0)
	uv2(uv3, uv1(uv0(slot0), "X > HP"))
end

function slot18(slot0)
	slot1 = uv0(slot0)

	uv1(uv2, slot1)
	uv1(uv3, slot1)
	uv4(uv2)
end

client.set_event_callback("paint", function ()
	if not uv0(uv1) then
		return
	end

	if #uv0(uv2) == 0 then
		return
	end

	for slot9 = 1, #uv4(true) do
		if uv3(slot1, "Duck") and uv5(slot5[slot9], "m_flDuckAmount") >= 0.7 or uv3(slot1, "X > HP") and uv5(slot10, "m_iHealth") <= uv0(uv6) or uv3(slot1, "In air") and uv7.band(uv5(slot10, "m_fFlags"), 1) == 0 then
			uv8(slot10, "Override safe point", "On")
		else
			uv8(slot10, "Override safe point", "-")
		end
	end
end)
client.register_esp_flag("SP", 204, 204, 0, function (slot0)
	return uv0(uv1) and uv2(slot0, "Override safe point") == "On"
end)
slot18(slot13)
slot10(slot13, slot18)
slot17(slot14)
slot10(slot14, slot17)
