local var_0_0 = ui.new_checkbox("MISC", "Miscellaneous", "Auto plant")
local var_0_1 = ui.new_hotkey("MISC", "Miscellaneous", "Auto plant hotkey", true)
local var_0_2

client.set_event_callback("setup_command", function(arg_1_0)
	if not ui.get(var_0_0) then
		return
	end

	local var_1_0 = entity.get_local_player()

	if (arg_1_0.in_use == 1 or arg_1_0.in_attack == 1 or ui.get(var_0_1)) and entity.get_classname(entity.get_player_weapon(var_1_0)) == "CC4" then
		local var_1_1 = entity.get_prop(var_1_0, "m_bInBombZone") == 1 and bit.band(entity.get_prop(var_1_0, "m_fFlags"), 1) == 1

		if var_1_1 == false or var_0_2 == false then
			arg_1_0.in_use, arg_1_0.in_attack = 0, 0
		elseif var_1_1 then
			arg_1_0.in_attack = 1
		end

		var_0_2 = var_1_1
	else
		var_0_2 = nil
	end
end)
