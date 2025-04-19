slot0 = ui.new_checkbox("RAGE", "Other", "Force body aim if lethal")
slot1 = ui.new_multiselect("RAGE", "Other", "Enabled weapons", {
	"Scout",
	"Awp",
	"Auto",
	"R8 revolver",
	"Deagle",
	"Other"
})
slot2 = require("gamesense/csgo_weapons")
slot3 = require("vector")

function slot4(slot0, slot1)
	for slot5, slot6 in ipairs(ui.get(slot0)) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

function slot5(slot0)
	if (slot0 == 38 or slot0 == 11) and uv0(uv1, "Auto") then
		return true
	elseif slot0 == 40 and uv0(uv1, "Scout") then
		return true
	elseif slot0 == 9 and uv0(uv1, "Awp") then
		return true
	elseif slot0 == 64 and uv0(uv1, "R8 revolver") then
		return true
	elseif slot0 == 1 and uv0(uv1, "Deagle") then
		return true
	elseif uv0(uv1, "Other") then
		return true
	end

	return false
end

function slot6(slot0)
	if entity.get_local_player() == nil or not entity.is_alive(slot1) then
		return
	end

	slot3 = uv0(entity.get_prop(slot1, "m_vecAbsOrigin")):dist(uv0(entity.get_prop(slot0, "m_vecOrigin")))
	slot4 = entity.get_prop(slot0, "m_iHealth")

	if entity.get_player_weapon(entity.get_local_player()) == nil then
		return
	end

	if entity.get_prop(slot5, "m_iItemDefinitionIndex") == nil then
		return
	end

	if uv1[slot6] == nil then
		return
	end

	if not uv2(slot6) or not ui.get(uv3) then
		return
	end

	slot8 = slot7.damage * math.pow(slot7.range_modifier, slot3 * 0.002) * 1.25
	slot10 = slot8 * slot7.armor_ratio * 0.5

	if entity.get_prop(slot0, "m_ArmorValue") < slot8 - slot8 * slot7.armor_ratio * 0.5 * 0.5 then
		slot10 = slot8 - slot9 / 0.5
	end

	return slot4 <= slot10
end

client.set_event_callback("run_command", function ()
	for slot4 = 1, #entity.get_players(true) do
		if slot0[slot4] == nil then
			return
		end

		plist.set(slot0[slot4], "Override prefer body aim", uv0(slot0[slot4]) and "Force" or "-")
	end
end)
client.set_event_callback("paint_ui", function ()
	ui.set_visible(uv0, ui.get(uv1))
end)
client.register_esp_flag("BAIM", 255, 20, 20, function (slot0)
	return uv0(slot0)
end)
