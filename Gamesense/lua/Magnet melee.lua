local var_0_0 = require("bit")
local var_0_1 = require("gamesense/uilib")
local var_0_2 = require("vector")
local var_0_3 = entity.get_origin
local var_0_4 = 31
local var_0_5 = var_0_1.new_checkbox("RAGE", "Other", "Melee magnet")
local var_0_6 = var_0_1.new_multiselect("RAGE", "Other", "Melee magnet options", "Zeus magnet", "Knife magnet", "Forwards AA on knife")

local function var_0_7(arg_1_0)
	local var_1_0 = 40000
	local var_1_1
	local var_1_2
	local var_1_3 = entity.get_players(true)

	for iter_1_0 = 1, #var_1_3 do
		local var_1_4 = var_1_3[iter_1_0]
		local var_1_5 = var_0_2(var_0_3(var_1_4))
		local var_1_6 = var_1_5:distsqr(arg_1_0)

		if var_1_6 < var_1_0 and not plist.get(var_1_4, "Add to whitelist") then
			var_1_0 = var_1_6
			var_1_1 = var_1_4
			var_1_2 = var_1_5
		end
	end

	return var_1_1, var_1_2
end

local function var_0_8(arg_2_0)
	local var_2_0 = entity.get_local_player()
	local var_2_1 = entity.get_player_weapon(var_2_0)

	if var_2_1 then
		local var_2_2 = var_0_2(client.eye_position())
		local var_2_3, var_2_4 = var_0_7(var_2_2)

		if var_2_3 then
			local var_2_5, var_2_6 = client.trace_line(var_2_0, var_2_2.x, var_2_2.y, var_2_2.z, var_2_4.x, var_2_4.y, var_2_4.z)

			if var_2_5 >= 1 or var_2_6 == var_2_3 then
				local var_2_7, var_2_8 = var_2_2:to(var_2_4):angles()

				if entity.get_classname(var_2_1) == "CKnife" and var_0_6:contains("Knife magnet") then
					if var_0_0.band(entity.get_prop(var_2_0, "m_fFlags"), 1) ~= 1 then
						arg_2_0.move_yaw = var_2_8
						arg_2_0.forwardmove = 450
					end
				elseif entity.get_prop(var_2_1, "m_iItemDefinitionIndex") == var_0_4 and var_0_6:contains("Zeus magnet") then
					arg_2_0.move_yaw = var_2_8
					arg_2_0.forwardmove = 450
				end

				local var_2_9 = entity.get_player_weapon(var_2_3)

				if var_2_9 and entity.get_classname(var_2_9) == "CKnife" and var_0_6:contains("Forwards AA on knife") then
					arg_2_0.yaw = var_2_8
					arg_2_0.pitch = 89
				end
			end
		end
	end
end

var_0_5:add_event_callback("setup_command", var_0_8)
var_0_6:set_parent(var_0_5)
var_0_5:invoke()
