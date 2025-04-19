slot0 = require("gamesense/csgo_weapons")
slot1 = {
	[0] = "Yellow",
	"Purple",
	"Green",
	"Blue",
	"Orange",
	[-1.0] = "Grey"
}
slot2 = 0.8
slot4 = {}
slot5 = {}

function cleanup_last_place_name(slot0)
	return (slot0 .. " "):gsub("%u[%l ]", function (slot0)
		return " " .. slot0
	end):gsub("^%s+", ""):gsub("%s+$", "")
end

function is_warmup()
	return entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1
end

function get_color(slot0)
	return entity.get_prop(entity.get_player_resource(), "m_iCompTeammateColor", slot0)
end

function get_enemies_from_resource()
	slot1 = entity.get_player_resource()
	slot2 = {}

	for slot6 = 0, globals.maxplayers() do
		if entity.get_prop(slot1, "m_bAlive", slot6) == 1 and entity.get_prop(slot1, "m_iTeam", slot6) ~= entity.get_prop(entity.get_local_player(), "m_iTeamNum") then
			table.insert(slot2, slot6)
		end
	end

	return slot2
end

function get_health(slot0)
	return entity.get_prop(slot0, "m_iHealth")
end

function get_weapon_definition_index(slot0)
	if entity.get_player_weapon(slot0) ~= nil then
		return entity.get_prop(slot1, "m_iItemDefinitionIndex")
	end

	return nil
end

function get_last_location(slot0)
	return entity.get_prop(slot0, "m_szLastPlaceName") or "Unknown"
end

function is_in_table(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function get_informant(slot0)
	return {
		Persona = entity.get_player_name(slot0),
		["Competitive color"] = uv0[get_color(slot0)],
		["Damage dealt"] = uv1[slot0] ~= nil and "-" .. uv1[slot0] .. " HP" or nil,
		Weapon = "Holding the " .. uv2[get_weapon_definition_index(slot0)].name,
		["Current health"] = "Currently has " .. get_health(slot0) .. " HP",
		["Last known location"] = "Last seen @ " .. cleanup_last_place_name(get_last_location(slot0))
	}
end

function push_to_log(slot0)
	slot3 = {}

	for slot7, slot8 in pairs(get_informant(slot0)) do
		if slot8 ~= nil and is_in_table(ui.get(uv0), slot7) then
			table.insert(slot3, slot8)
		end
	end

	if #slot3 > 0 then
		table.insert(uv1, table.concat(slot3, " | "))
	end
end

function on_player_death(slot0)
	if is_warmup() or client.userid_to_entindex(slot0.userid) ~= entity.get_local_player() or slot0.attacker == slot0.userid or slot0.attacker == 0 then
		return
	end

	if client.userid_to_entindex(slot0.attacker) ~= nil and uv0[slot2] == nil then
		push_to_log(slot2)
	end

	for slot7, slot8 in pairs(uv0) do
		if is_in_table(get_enemies_from_resource(), slot7) then
			push_to_log(slot7)
		end
	end

	for slot7 = 1, #uv1 do
		client.delay_call(slot7 * uv2, client.exec, "say_team ", uv1[slot7])
	end
end

function on_player_spawn(slot0)
	if client.userid_to_entindex(slot0.userid) ~= entity.get_local_player() then
		return
	end

	uv0 = {}
	uv1 = {}
end

function on_player_hurt(slot0)
	if client.userid_to_entindex(slot0.attacker) ~= entity.get_local_player() then
		return
	end

	if uv0[client.userid_to_entindex(slot0.userid)] == nil then
		slot3 = 0
	end

	uv0[slot2] = slot3 + slot0.dmg_health
end

function on_informant_ui_callback()
	slot0 = #ui.get(uv0) > 0 and client.set_event_callback or client.unset_event_callback

	slot0("player_death", on_player_death)
	slot0("player_spawn", on_player_spawn)
	slot0("player_hurt", on_player_hurt)
end

ui.set_callback(ui.new_multiselect("VISUALS", "Other ESP", "Informant", {
	"Persona",
	"Competitive color",
	"Damage dealt",
	"Weapon",
	"Current health",
	"Last known location"
}), on_informant_ui_callback)
on_informant_ui_callback()
