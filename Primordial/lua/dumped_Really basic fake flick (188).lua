local yaw_base = menu.find("antiaim", "main", "angles", "yaw add")
local fake_lag_value = menu.find("antiaim", "main", "fakelag", "amount")

function do_fake_flick()
    fake_lag_value:set(15)
    local desync_inverted = antiaim.is_inverting_desync()
    local g_vars_tick = global_vars.tick_count()
        if g_vars_tick % 64 > 62 then
            yaw_base:set(desync_inverted and 90 or -90)
        else
            yaw_base:set(0)
        end
end

callbacks.add(e_callbacks.PAINT, do_fake_flick)