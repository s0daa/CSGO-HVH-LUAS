local ui_new_hotkey, ui_get, entity_get_player_weapon, entity_get_local_player, entity_get_prop, globals_tickinterval, client_exec, client_set_event_callback = ui.new_hotkey, ui.get, entity.get_player_weapon, entity.get_local_player, entity.get_prop, globals.tickinterval, client.exec, client.set_event_callback

local last_swap = 0; 

local hotkey = ui_new_hotkey("RAGE", "Other", "Deagle quick switch")

local function run_command(e)

	if not ui_get(hotkey) then return end

	local current_weapon = entity_get_player_weapon(entity_get_local_player())
	local m_nTickBase = entity_get_prop(entity_get_local_player(), "m_nTickBase")
	local m_fLastShotTime = entity_get_prop(current_weapon, "m_fLastShotTime")

	if last_swap == 2147483647 then
		last_swap = m_nTickBase * globals_tickinterval()
		client_exec("slot1")
	else
		if bit.band(65535, entity_get_prop(entity_get_player_weapon(entity_get_local_player()), "m_iItemDefinitionIndex")) == 9 then
			if m_fLastShotTime > last_swap then
				last_swap = 2147483647
			        client_exec("slot3")
				end
		else
			last_swap = m_nTickBase * globals_tickinterval()
		end
	end
end

client_set_event_callback("run_command", run_command)