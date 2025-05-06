slidewalk = ui.reference("AA", "other", "leg movement")
enable = ui.new_checkbox("AA", "other", "LEG FUYCJKER UFF $$$$")

client.set_event_callback("net_update_end", function()
	if ui.get(enable) then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
	end
end)

client.set_event_callback("run_command", function(ctx)
    if ui.get(enable) then
	p = client.random_int(1, 3)
	if p == 1 then
		ui.set(slidewalk, "Off")
	elseif p == 2 then
       ui.set(slidewalk, "Always slide")
    elseif p == 3 then
		ui.set(slidewalk, "Off")
    end
    ui.set_visible(slidewalk, false)
else
    ui.set_visible(slidewalk, true)
end
end)