local anti_aim = require 'gamesense/antiaim_funcs'
local body_yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') }

client.set_event_callback('setup_command', function(c)
    if c.chokedcommands ~= 0 then
        return
    end

    if anti_aim.get_overlap() > 0.615 then
        ui.set(body_yaw[1], 'Static')
        ui.set(body_yaw[2], anti_aim.get_desync(1) > 0 and -180 or 180)
    end
end)
