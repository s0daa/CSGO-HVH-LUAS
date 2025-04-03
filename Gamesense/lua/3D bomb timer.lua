local var_0_0 = ui.new_checkbox("VISUALS", "Other ESP", "Enable C4 Timer")
local var_0_1 = ui.new_color_picker("VISUALS", "Other ESP", "C4 Timer Color")
local var_0_2 = ui.new_slider("VISUALS", "Other ESP", "Radius", 20, 100, 50, true, "%")
local var_0_3 = ui.new_slider("VISUALS", "Other ESP", "Oval", 0, 50, 0, true, "%")

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = arg_1_0 - arg_1_3
	local var_1_1 = arg_1_1 - arg_1_4
	local var_1_2 = arg_1_2 - arg_1_5
	local var_1_3 = math.sqrt(var_1_0 * var_1_0 + var_1_1 * var_1_1)
	local var_1_4 = math.deg(math.atan(var_1_2 / var_1_3))
	local var_1_5 = math.deg(math.atan(var_1_1 / var_1_0))

	return var_1_4, var_1_5
end

local function var_0_5(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0, var_2_1 = client.screen_size()
	local var_2_2, var_2_3, var_2_4 = client.camera_angles()
	local var_2_5, var_2_6 = var_0_4(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_7 = math.rad(var_2_3 - var_2_6 - 90)

	if var_2_7 < 0 and var_2_7 > -math.pi then
		var_2_7 = var_2_7 + math.pi
	end

	local var_2_8 = var_2_0 * 0.5 + var_2_0 * (0.5 + ui.get(var_0_3) / 100) * arg_2_6 * math.cos(var_2_7)
	local var_2_9 = var_2_1 * 0.5 + var_2_0 * 0.5 * arg_2_6 * math.sin(var_2_7)

	return var_2_8, var_2_9
end

local function var_0_6()
	local var_3_0 = entity.get_all("CPlantedC4")

	for iter_3_0 = 1, #var_3_0 do
		local var_3_1 = var_3_0[iter_3_0]
		local var_3_2 = entity.get_prop(var_3_1, "m_flC4Blow")

		if var_3_2 < globals.curtime() then
			return
		end

		local var_3_3 = math.floor((var_3_2 - globals.curtime()) * 10) / 10
		local var_3_4 = var_3_3 / cvar.mp_c4timer:get_int()

		if var_3_3 <= 0 or var_3_3 == nil then
			return
		end

		local var_3_5, var_3_6, var_3_7 = entity.get_origin(entity.get_local_player())
		local var_3_8, var_3_9, var_3_10 = entity.get_origin(var_3_1)
		local var_3_11, var_3_12 = renderer.world_to_screen(var_3_8, var_3_9, var_3_10)
		local var_3_13, var_3_14, var_3_15, var_3_16 = ui.get(var_0_1)

		if var_3_11 ~= nil and var_3_12 ~= nil then
			renderer.circle_outline(var_3_11, var_3_12, 0, 0, 0, 200, 25, 270, 1, 8)
			renderer.circle_outline(var_3_11, var_3_12, var_3_13, var_3_14, var_3_15, var_3_16, 25, 270, var_3_4, 8)
			renderer.text(var_3_11, var_3_12, 255, 255, 255, 255, "c", 0, var_3_3)
		else
			local var_3_17, var_3_18 = var_0_5(var_3_8, var_3_9, var_3_10, var_3_5, var_3_6, var_3_7, ui.get(var_0_2) / 200)

			renderer.circle_outline(var_3_17, var_3_18, 0, 0, 0, 200, 25, 270, 1, 8)
			renderer.circle_outline(var_3_17, var_3_18, var_3_13, var_3_14, var_3_15, var_3_16, 25, 270, var_3_4, 8)
			renderer.text(var_3_17, var_3_18, 255, 255, 255, 255, "c", 0, var_3_3)
		end
	end
end

ui.set_callback(var_0_0, function()
	if ui.get(var_0_0) then
		client.set_event_callback("paint", var_0_6)
	else
		client.unset_event_callback("paint", var_0_6)
	end
end)
