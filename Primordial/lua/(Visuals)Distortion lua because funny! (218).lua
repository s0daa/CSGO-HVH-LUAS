local enable_distortion = menu.add_checkbox("synth aa", "enable distortion")
local distortion_amt    = menu.add_slider("synth aa", "distortion amount", 0, 180)
local distortion_speed  = menu.add_slider("synth aa", "distortion speed", 0, 10)
local yaw_add           = menu.find("antiaim", "main", "angles", "yaw add")

local sin = math.sin
math.sin = function (x) 
    return sin(rad(x)) 
end

callbacks.add(e_callbacks.ANTIAIM, function()
    if not enable_distortion:get() then return end
    if not engine.is_in_game() then return end

    yaw_add:set(sin(global_vars.cur_time() * distortion_speed:get()) * distortion_amt:get())
end)