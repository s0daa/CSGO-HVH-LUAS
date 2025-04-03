local var_0_0 = 15
local var_0_1 = ui.new_checkbox("CONFIG", "Presets", "Third person animation")
local var_0_2 = {
	ui.reference("Visuals", "Effects", "Force third person (alive)")
}
local var_0_3 = ui.new_slider("CONFIG", "Presets", "Third person distance", 0, 180, 100)
local var_0_4 = ui.new_slider("CONFIG", "Presets", "Third person zoom speed", 1, 100, 25, true, "%", 1)

client.set_event_callback("paint_ui", function()
	if ui.get(var_0_1) then
		local var_1_0 = entity.get_local_player()

		if not entity.is_alive(var_1_0) or not ui.get(var_0_2[1]) or not ui.get(var_0_2[2]) then
			var_0_0 = 15
		else
			local var_1_1 = ui.get(var_0_3)
			local var_1_2 = (var_1_1 - var_0_0) / ui.get(var_0_4)

			var_0_0 = var_0_0 + (var_1_1 > var_0_0 and var_1_2 or -var_1_2)
			var_0_0 = var_1_1 < var_0_0 and var_1_1 or var_0_0

			cvar.cam_idealdist:set_float(var_0_0)
		end
	end
end)
