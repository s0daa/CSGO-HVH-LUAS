local air_strafe = ui.reference("Misc", "Movement", "Air strafe")
local enable_it = ui.new_checkbox("Misc", "Movement", "Jumpscout")

client.set_event_callback("setup_command", function(c)
    if (ui.get(enable_it)) then
        local vel_x, vel_y = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
        local vel = math.sqrt(vel_x^2 + vel_y^2)
        ui.set(air_strafe, not (c.in_jump and (vel < 10)) or ui.is_menu_open())
    end
end)