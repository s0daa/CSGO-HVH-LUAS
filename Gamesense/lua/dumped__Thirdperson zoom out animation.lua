slot0 = 15
slot1 = ui.new_checkbox("CONFIG", "Presets", "Third person animation")
slot2 = {
	ui.reference("Visuals", "Effects", "Force third person (alive)")
}
slot3 = ui.new_slider("CONFIG", "Presets", "Third person distance", 0, 180, 100)
slot4 = ui.new_slider("CONFIG", "Presets", "Third person zoom speed", 1, 100, 25, true, "%", 1)

client.set_event_callback("paint_ui", function ()
	if ui.get(uv0) then
		if not entity.is_alive(entity.get_local_player()) or not ui.get(uv1[1]) or not ui.get(uv1[2]) then
			uv2 = 15
		else
			slot1 = ui.get(uv3)
			slot2 = (slot1 - uv2) / ui.get(uv4)
			uv2 = uv2 + (uv2 < slot1 and slot2 or -slot2)
			uv2 = slot1 < uv2 and slot1 or uv2

			cvar.cam_idealdist:set_float(uv2)
		end
	end
end)
