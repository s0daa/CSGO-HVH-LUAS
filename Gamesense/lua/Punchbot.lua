local var_0_0 = client.eye_position
local var_0_1 = client.camera_angles
local var_0_2 = client.visible
local var_0_3 = client.trace_line
local var_0_4 = renderer.text
local var_0_5 = renderer.world_to_screen
local var_0_6 = entity.get_prop
local var_0_7 = entity.get_all
local var_0_8 = entity.get_local_player
local var_0_9 = math.deg
local var_0_10 = math.atan2
local var_0_11 = math.sqrt
local var_0_12 = math.pow
local var_0_13 = ui.get
local var_0_14 = ui.new_checkbox
local var_0_15 = ui.new_hotkey
local var_0_16 = entity.get_player_resource
local var_0_17 = entity.get_classname
local var_0_18 = entity.get_prop
local var_0_19 = entity.get_origin
local var_0_20 = entity.get_local_player
local var_0_21 = table.insert
local var_0_22 = entity.get_player_weapon
local var_0_23 = bit.band
local var_0_24 = entity.hitbox_position
local var_0_25 = entity.is_enemy
local var_0_26 = var_0_14("Misc", "Miscellaneous", "Punchbot")
local var_0_27 = var_0_15("Misc", "Miscellaneous", "Punchbot", true)
local var_0_28 = var_0_14("Misc", "Miscellaneous", "Punchbot Silent aim")
local var_0_29 = var_0_14("Misc", "Miscellaneous", "Punchbot Ignore Team Check")
local var_0_30 = require("vector")

local function var_0_31()
	local var_1_0 = var_0_16()
	local var_1_1 = {}
	local var_1_2 = var_0_20()

	for iter_1_0 = 1, 64 do
		if var_0_17(iter_1_0) == "CCSPlayer" and var_0_18(var_1_0, "m_bAlive", iter_1_0) == 1 and var_1_2 ~= iter_1_0 then
			local var_1_3 = var_0_13(var_0_29)

			if not var_1_3 and var_0_25(iter_1_0) then
				var_0_21(var_1_1, iter_1_0)
			elseif var_1_3 then
				var_0_21(var_1_1, iter_1_0)
			end
		end
	end

	if #var_1_1 ~= 0 then
		local var_1_4 = var_0_30(var_0_19(var_1_2))
		local var_1_5
		local var_1_6 = 999999999

		for iter_1_1 = 1, #var_1_1 do
			local var_1_7 = var_1_1[iter_1_1]
			local var_1_8 = var_0_30(var_0_19(var_1_7))
			local var_1_9 = var_1_4:dist(var_1_8)

			if var_1_9 < var_1_6 then
				var_1_6 = var_1_9
				var_1_5 = var_1_7
			end
		end

		if var_1_5 ~= nil and var_1_6 ~= 999999999 then
			for iter_1_2 = 0, 18 do
				local var_1_10 = var_0_20()
				local var_1_11 = var_0_30(var_0_0())
				local var_1_12 = var_0_30(var_0_24(var_1_5, iter_1_2))
				local var_1_13 = var_1_11:dist(var_1_12)
				local var_1_14, var_1_15 = var_0_3(var_1_10, var_1_11.x, var_1_11.y, var_1_11.z, var_1_12.x, var_1_12.y, var_1_12.z)

				if var_1_15 ~= var_1_5 then
					var_1_13 = 999999
				end

				if var_1_13 < 80 then
					return var_1_12
				end
			end
		end
	end

	return nil
end

client.set_event_callback("setup_command", function(arg_2_0)
	local var_2_0 = var_0_20()

	if not var_2_0 or var_0_18(var_2_0, "m_lifeState") ~= 0 then
		return
	end

	local var_2_1 = var_0_22(var_2_0)

	if not var_2_1 then
		return
	end

	local var_2_2 = var_0_23(var_0_18(var_2_1, "m_iItemDefinitionIndex"), 65535)

	if var_0_13(var_0_26) and var_2_2 == 69 then
		local var_2_3 = var_0_31()

		if var_2_3 ~= nil then
			local var_2_4, var_2_5 = var_0_30(var_0_0()):to(var_2_3):angles()

			if var_0_13(var_0_27) then
				if var_0_13(var_0_28) then
					arg_2_0.pitch = var_2_4
					arg_2_0.yaw = var_2_5
					arg_2_0.in_attack = 1
				else
					var_0_1(var_2_4, var_2_5)

					arg_2_0.in_attack = 1
				end
			end
		end
	end
end)
