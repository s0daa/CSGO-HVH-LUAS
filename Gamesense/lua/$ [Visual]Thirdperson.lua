local tp_distance = ui.new_slider("Misc", "Settings", "Thirdperson distance", 0, 200, 150)

client.set_event_callback('paint', function()
    cvar.cam_idealdist:set_int(ui.get(tp_distance))
end)