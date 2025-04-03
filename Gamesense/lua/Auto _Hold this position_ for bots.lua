local var_0_0 = require("bit").band
local var_0_1 = entity.get_prop
local var_0_2 = entity.get_players
local var_0_3 = entity.is_enemy
local var_0_4 = client.exec

local function var_0_5(arg_1_0)
	local var_1_0 = var_0_2()

	if var_1_0 == nil then
		return
	end

	for iter_1_0 = 1, #var_1_0 do
		local var_1_1 = var_1_0[iter_1_0]

		if not var_0_3(var_1_1) then
			local var_1_2 = var_0_1(var_1_1, "m_fFlags")

			if var_1_2 and var_0_0(var_1_2, 512) == 512 then
				var_0_4("holdpos")

				return
			end
		end
	end
end

client.set_event_callback("round_freeze_end", var_0_5)
