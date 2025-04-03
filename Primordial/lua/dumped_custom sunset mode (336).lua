local check = menu.add_checkbox("world changer", "custom sunset mode")
local x = menu.add_slider("world changer", "x pos", -100, 100)
local y = menu.add_slider("world changer", "y pos", -100, 100)

local sunset_ref = menu.find("visuals", "other", "world", "sunset mode")

local x_pos, y_pos = cvars.cl_csm_rot_x, cvars.cl_csm_rot_y

callbacks.add(e_callbacks.PAINT, function()
    if check:get() ~= true then
        x_pos:set_int(0) 
        y_pos:set_int(0)
        return
    end

    local int = sunset_ref:get() == true and 1 or -1

    cvars.cl_csm_rot_override:set_int(int)
    cvars.cl_csm_shadows:set_int(int)

    local x_val, y_val = x:get(), y:get()
    
    x_pos:set_int(x_val)
    y_pos:set_int(y_val)
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    x_pos:set_int(0)
    y_pos:set_int(0)
end)