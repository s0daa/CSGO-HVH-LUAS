local enabled = menu.add_checkbox("rainbow hud", "enable")
local interval = menu.add_slider("rainbow hud", "interval (ms)", 0, 5000)

local color = 1
local prev_time = global_vars.cur_time()
local original_color = cvars.cl_hud_color:get_int()

callbacks.add(e_callbacks.PAINT, function()
    if not enabled:get() then
        return
    end

    if global_vars.cur_time() - prev_time >= (interval:get() / 1000) then
        prev_time = global_vars.cur_time()

        cvars.cl_hud_color:set_int(color)

        color = color + 1

        if color > 9 then
            color = 1
        end
    end
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    cvars.cl_hud_color:set_int(original_color)
end)