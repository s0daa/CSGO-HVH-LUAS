-- Useless since this feature has been removed by eso long time ago
﻿local var_0_0 = require("gamesense/uix")
local var_0_1 = client
local var_0_2 = entity
local var_0_3 = ui
local var_0_4 = var_0_1.userid_to_entindex
local var_0_5 = var_0_1.set_event_callback
local var_0_6 = var_0_1.random_int
local var_0_7 = var_0_1.unset_event_callback
local var_0_8 = var_0_2.get_local_player
local var_0_9 = var_0_2.is_enemy
local var_0_10 = var_0_3.set
local var_0_11 = var_0_3.get
local var_0_12 = var_0_3.reference
local var_0_13 = var_0_3.new_checkbox
--local var_0_14
--local var_0_15

local function var_0_16(arg_1_0)
	local var_1_0 = var_0_4(arg_1_0.attacker)

	if var_0_4(arg_1_0.userid) == var_0_8() and var_0_9(var_1_0) then
		var_0_10(var_0_15, var_0_6(0, 60))
	end
end

;(function()
	--var_0_14 = var_0_0.new_checkbox("AA", "Anti-aimbot angles", "Randomize fake yaw limit")
	--var_0_15 = var_0_12("AA", "Anti-aimbot angles", "Fake yaw limit")

	var_0_14:on("player_hurt", var_0_16)
end)()
