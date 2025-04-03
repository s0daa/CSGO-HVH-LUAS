local var_0_0 = client.register_esp_flag
local var_0_1 = client.trace_bullet
local var_0_2 = entity.get_local_player
local var_0_3 = entity.get_prop
local var_0_4 = entity.hitbox_position
local var_0_5 = entity.is_alive
local var_0_6 = entity.is_enemy

var_0_0("LETHAL", 255, 0, 0, function(arg_1_0)
	if var_0_5(var_0_2()) and var_0_6(arg_1_0) then
		local var_1_0 = {
			var_0_4(arg_1_0, "pelvis")
		}

		if #var_1_0 == 3 then
			local var_1_1, var_1_2 = var_0_1(var_0_2(), var_1_0[1] - 1, var_1_0[2] - 1, var_1_0[3] - 1, var_1_0[1], var_1_0[2], var_1_0[3], true)

			return var_1_2 >= var_0_3(arg_1_0, "m_iHealth")
		end
	end
end)
