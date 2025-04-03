local var_0_0 = client.register_esp_flag
local var_0_1 = entity.is_enemy
local var_0_2 = plist.get

var_0_0("FAKE", 255, 255, 255, function(arg_1_0)
	if var_0_1(arg_1_0) then
		return var_0_2(arg_1_0, "Correction active")
	end
end)
