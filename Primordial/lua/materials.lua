local invert = 1
local yaw_mod_d = 54

local add_r, add_l = 18, -18

local sides = menu.find("antiaim","main", "desync","side#stand")


callbacks.add(e_callbacks.ANTIAIM, function (ctx, cmd)
    local yaw = cmd.viewangles.y - 180
    local side = antiaim.get_desync_side() == 2

    if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then
        return
    end

    yaw = yaw + (side and add_r or add_l)
    yaw = yaw + (yaw_mod_d / 2) * invert

    ctx:set_yaw(yaw)
    sides:set(invert == -1 and 2 or 3)
    
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function (cmd)
    if engine.get_choked_commands() == 0 then
        invert = invert * -1
    end
end)