local find, get, set = ui.reference, ui.get, ui.set
local set_event = client.set_event_callback
local get_prop, get_local = entity.get_prop, entity.get_local_player
local air_strafe = find("Misc", "Movement", "Air strafe")
set_event("setup_command", function(c)
    local vel_x, vel_y = get_prop(get_local(), "m_vecVelocity")
    local vel = math.sqrt(vel_x^2 + vel_y^2)
    
    if c.in_jump and vel < 10 then
        set(air_strafe, false)
    else
        set(air_strafe, true)
    end
end) 