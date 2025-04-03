local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = {
	[0] = "Yellow",
	"Purple",
	"Green",
	"Blue",
	"Orange",
	[-1] = "Grey"
}
local var_0_2 = 0.8
local var_0_3 = ui.new_multiselect("VISUALS", "Other ESP", "Informant", {
	"Persona",
	"Competitive color",
	"Damage dealt",
	"Weapon",
	"Current health",
	"Last known location"
})
local var_0_4 = {}
local var_0_5 = {}

function cleanup_last_place_name(arg_1_0)
	return ((arg_1_0 .. " "):gsub("%u[%l ]", function(arg_2_0)
		return " " .. arg_2_0
	end):gsub("^%s+", ""):gsub("%s+$", ""))
end

function is_warmup()
	return entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1
end

function get_color(arg_4_0)
	return entity.get_prop(entity.get_player_resource(), "m_iCompTeammateColor", arg_4_0)
end

function get_enemies_from_resource()
	local var_5_0 = entity.get_prop(entity.get_local_player(), "m_iTeamNum")
	local var_5_1 = entity.get_player_resource()
	local var_5_2 = {}

	for iter_5_0 = 0, globals.maxplayers() do
		if entity.get_prop(var_5_1, "m_bAlive", iter_5_0) == 1 and entity.get_prop(var_5_1, "m_iTeam", iter_5_0) ~= var_5_0 then
			table.insert(var_5_2, iter_5_0)
		end
	end

	return var_5_2
end

function get_health(arg_6_0)
	return entity.get_prop(arg_6_0, "m_iHealth")
end

function get_weapon_definition_index(arg_7_0)
	local var_7_0 = entity.get_player_weapon(arg_7_0)

	if var_7_0 ~= nil then
		return entity.get_prop(var_7_0, "m_iItemDefinitionIndex")
	end

	return nil
end

function get_last_location(arg_8_0)
	return entity.get_prop(arg_8_0, "m_szLastPlaceName") or "Unknown"
end

function is_in_table(arg_9_0, arg_9_1)
	for iter_9_0 = 1, #arg_9_0 do
		if arg_9_0[iter_9_0] == arg_9_1 then
			return true
		end
	end

	return false
end

function get_informant(arg_10_0)
	return {
		Persona = entity.get_player_name(arg_10_0),
		["Competitive color"] = var_0_1[get_color(arg_10_0)],
		["Damage dealt"] = var_0_5[arg_10_0] ~= nil and "-" .. var_0_5[arg_10_0] .. " HP" or nil,
		Weapon = "Holding the " .. var_0_0[get_weapon_definition_index(arg_10_0)].name,
		["Current health"] = "Currently has " .. get_health(arg_10_0) .. " HP",
		["Last known location"] = "Last seen @ " .. cleanup_last_place_name(get_last_location(arg_10_0))
	}
end

function push_to_log(arg_11_0)
	local var_11_0 = ui.get(var_0_3)
	local var_11_1 = get_informant(arg_11_0)
	local var_11_2 = {}

	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		if iter_11_1 ~= nil and is_in_table(var_11_0, iter_11_0) then
			table.insert(var_11_2, iter_11_1)
		end
	end

	if #var_11_2 > 0 then
		table.insert(var_0_4, table.concat(var_11_2, " | "))
	end
end

function on_player_death(arg_12_0)
	local var_12_0 = entity.get_local_player()

	if is_warmup() or client.userid_to_entindex(arg_12_0.userid) ~= var_12_0 or arg_12_0.attacker == arg_12_0.userid or arg_12_0.attacker == 0 then
		return
	end

	local var_12_1 = client.userid_to_entindex(arg_12_0.attacker)

	if var_12_1 ~= nil and var_0_5[var_12_1] == nil then
		push_to_log(var_12_1)
	end

	local var_12_2 = get_enemies_from_resource()

	for iter_12_0, iter_12_1 in pairs(var_0_5) do
		if is_in_table(var_12_2, iter_12_0) then
			push_to_log(iter_12_0)
		end
	end

	for iter_12_2 = 1, #var_0_4 do
		client.delay_call(iter_12_2 * var_0_2, client.exec, "say_team ", var_0_4[iter_12_2])
	end
end

function on_player_spawn(arg_13_0)
	local var_13_0 = entity.get_local_player()

	if client.userid_to_entindex(arg_13_0.userid) ~= var_13_0 then
		return
	end

	var_0_4 = {}
	var_0_5 = {}
end

function on_player_hurt(arg_14_0)
	local var_14_0 = entity.get_local_player()

	if client.userid_to_entindex(arg_14_0.attacker) ~= var_14_0 then
		return
	end

	local var_14_1 = client.userid_to_entindex(arg_14_0.userid)
	local var_14_2 = var_0_5[var_14_1]

	if var_14_2 == nil then
		var_14_2 = 0
	end

	var_0_5[var_14_1] = var_14_2 + arg_14_0.dmg_health
end

function on_informant_ui_callback()
	local var_15_0 = #ui.get(var_0_3) > 0 and client.set_event_callback or client.unset_event_callback

	var_15_0("player_death", on_player_death)
	var_15_0("player_spawn", on_player_spawn)
	var_15_0("player_hurt", on_player_hurt)
end

ui.set_callback(var_0_3, on_informant_ui_callback)
on_informant_ui_callback()
