local var_0_0 = bit.band
local var_0_1 = client.set_event_callback
local var_0_2 = entity.get_bounding_box
local var_0_3 = entity.get_local_player
local var_0_4 = entity.get_players
local var_0_5 = entity.get_prop
local var_0_6 = entity.hitbox_position
local var_0_7 = entity.is_alive
local var_0_8 = math.ceil
local var_0_9 = math.pow
local var_0_10 = math.sqrt
local var_0_11 = renderer.line
local var_0_12 = renderer.text
local var_0_13 = renderer.world_to_screen
local var_0_14 = ui.get
local var_0_15 = ui.new_checkbox("lua", "a", "Enable revolver helper")

local function var_0_16(arg_1_0, arg_1_1, arg_1_2)
	return {
		x = arg_1_0 or 0,
		y = arg_1_1 or 0,
		z = arg_1_2 or 0
	}
end

local function var_0_17(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	return var_0_8(var_0_10(var_0_9(arg_2_0 - arg_2_3, 2) + var_0_9(arg_2_1 - arg_2_4, 2) + var_0_9(arg_2_2 - arg_2_5, 2)))
end

local function var_0_18(arg_3_0, arg_3_1)
	if arg_3_0 == nil then
		return
	end

	if arg_3_1 == nil then
		return
	end

	local var_3_0 = var_0_5(var_0_5(arg_3_0, "m_hActiveWeapon"), "m_iItemDefinitionIndex")

	if var_3_0 == nil then
		return
	end

	local var_3_1 = var_0_0(var_3_0, 65535)
	local var_3_2 = var_0_16(var_0_5(arg_3_0, "m_vecOrigin"))
	local var_3_3 = var_0_16(var_0_5(arg_3_1, "m_vecOrigin"))
	local var_3_4 = var_0_17(var_3_2.x, var_3_2.y, var_3_2.z, var_3_3.x, var_3_3.y, var_3_3.z)
	local var_3_5 = var_0_5(arg_3_1, "m_ArmorValue") == 0

	if var_3_1 ~= 64 or not var_3_5 then
		return 0
	end

	if var_3_4 < 585 and var_3_4 > 511 then
		return 1
	elseif var_3_4 < 511 then
		return 2
	else
		return 0
	end
end

local function var_0_19(arg_4_0, arg_4_1)
	local var_4_0, var_4_1, var_4_2, var_4_3, var_4_4 = var_0_2(arg_4_0)

	if var_4_0 == nil or var_4_4 == 0 then
		return
	end

	local var_4_5 = var_4_0 / 2 + var_4_2 / 2
	local var_4_6 = name == "" and -8 or 0

	if arg_4_1 == 1 then
		var_0_12(var_4_5, var_4_1 - 20 + var_4_6, 255, 0, 0, 255, "cb", 0, "DMG")
	else
		var_0_12(var_4_5, var_4_1 - 20 + var_4_6, 50, 205, 50, 255, "cb", 0, "DMG+")
	end
end

local function var_0_20()
	if not var_0_14(var_0_15) then
		return
	end

	local var_5_0 = var_0_3()

	if var_5_0 == nil then
		return
	end

	if not var_0_7(var_5_0) then
		return
	end

	local var_5_1 = var_0_4(true)

	if #var_5_1 == nil or #var_5_1 == 0 then
		return
	end

	for iter_5_0 = 1, #var_5_1 do
		local var_5_2 = var_5_1[iter_5_0]

		if var_5_2 ~= nil and var_5_2 ~= var_0_3() then
			local var_5_3 = var_0_16(var_0_6(var_5_2, 13))
			local var_5_4 = var_0_16(var_0_6(var_5_0, 3))
			local var_5_5, var_5_6 = var_0_13(var_5_3.x, var_5_3.y, var_5_3.z)
			local var_5_7, var_5_8 = var_0_13(var_5_4.x, var_5_4.y, var_5_4.z)
			local var_5_9 = var_0_18(var_5_0, var_5_2)
			local var_5_10 = var_0_18(var_5_2, var_5_0)

			if var_5_9 ~= 0 and var_5_9 ~= nil then
				var_0_19(var_5_2, var_5_9)
			end

			if var_5_10 ~= 0 and var_5_10 ~= nil and var_5_5 ~= nil and var_5_7 ~= nil and var_5_6 ~= nil and var_5_8 ~= nil then
				var_0_11(var_5_5, var_5_6, var_5_7, var_5_8, 255, 0, 0, 255)
			end
		end
	end
end

local function var_0_21(arg_6_0)
	if ui.get(arg_6_0) then
		client.set_event_callback("paint", var_0_20)
	else
		client.unset_event_callback("paint", var_0_20)
	end
end

ui.set_callback(var_0_15, var_0_21)
