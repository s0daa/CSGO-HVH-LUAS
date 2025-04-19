slot0 = require("gamesense/chat")
slot1 = ui.get
slot3 = {
	[slot8] = "{" .. slot8:gsub("[ %-]", ""):lower() .. "}"
}

for slot7, slot8 in pairs({
	"Red",
	"Dark Red",
	"Light Red",
	"Violet",
	"Purple",
	"Blue",
	"Dark Blue",
	"Blue-Grey",
	"Green",
	"Light Green",
	"Lime",
	"Yellow",
	"Orange",
	"White",
	"Grey"
}) do
	-- Nothing
end

ui.set(ui.new_combobox("MISC", "Miscellaneous", "Custom colors", slot2), "Green")
ui.set(ui.new_combobox("MISC", "Miscellaneous", "\nCustom color 2", slot2), "Green")
ui.set(ui.new_textbox("MISC", "Miscellaneous", "Custom prefix"), database.read("roundDamageLogJessica") or "FACEIT^")
ui.set_visible(slot5, false)
ui.set_visible(slot6, false)
ui.set_visible(slot7, false)

slot8 = {}
slot9 = {}

function slot10()
	slot1 = {}

	for slot5 = 1, globals.maxplayers() do
		if entity.get_prop(entity.get_player_resource(), "m_bConnected", slot5) == 1 and entity.is_enemy(slot5) then
			table.insert(slot1, slot5)
		end
	end

	return slot1
end

function slot11()
	table.clear(uv0)
	table.clear(uv1)
end

function slot12(slot0)
	if entity.is_enemy(client.userid_to_entindex(slot0.userid) == entity.get_local_player() and client.userid_to_entindex(slot0.attacker) or slot2) and (slot4 and slot2 or slot1) == slot3 then
		slot6 = slot4 and uv0 or uv1
		slot6[slot5] = slot6[slot5] or {}
		slot6[slot5].damage = (slot6[slot5].damage or 0) + slot0.dmg_health
		slot6[slot5].count = (slot6[slot5].count or 0) + 1
	end
end

function slot13(slot0, slot1, slot2, slot3)
	return string.format("%s%s: [%s%d / %d hits%s]", slot3, slot0, slot2, slot1.damage or 0, slot1.count or 0, slot3)
end

function slot14()
	client.delay_call(0.2, function ()
		for slot4, slot5 in ipairs(uv1()) do
			slot8 = uv2[ui.get(uv4)]

			uv8.print(string.format("%s[%s%s%s] %s %s %s- %s%s %s(%s%d hp%s)", slot8, uv2[ui.get(uv3)], ui.get(uv0), slot8, uv5("To", uv6[slot5] or {}, slot7, slot8), uv5("From", uv7[slot5] or {}, slot7, slot8), slot8, slot8, entity.get_player_name(slot5), slot8, slot7, (entity.get_esp_data(slot5) or {}).health or 0, slot8))
		end

		uv9()
	end)
end

function slot15()
	database.write("roundDamageLogJessica", uv0(uv1))
end

ui.set_callback(ui.new_checkbox("MISC", "Miscellaneous", "Chat damage logging"), function ()
	slot1 = ui.get(uv0) and client.set_event_callback or client.unset_event_callback

	slot1("player_hurt", uv1)
	slot1("round_end", uv2)
	slot1("level_init", uv3)
	slot1("shutdown", uv4)
	ui.set_visible(uv5, slot0)
	ui.set_visible(uv6, slot0)
	ui.set_visible(uv7, slot0)

	if not slot0 then
		uv3()
	end
end)
