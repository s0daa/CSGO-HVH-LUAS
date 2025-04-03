local rocket_enabled = menu.add_checkbox("ragdolls", "rocket mode", true)
local timescale_slider = menu.add_slider("ragdolls", "timescale", 0.1, 2, 0.1, 0.01)
timescale_slider:set(cvars.cl_phys_timescale:get_float())

local function apply_tweaks()
    if cvars.cl_phys_timescale:get_float() ~= timescale_slider:get() then
        cvars.cl_phys_timescale:set_float(timescale_slider:get())
        print("lizzy | cl_phys_timescale set to " .. timescale_slider:get())
    end

    if rocket_enabled:get() and cvars.cl_ragdoll_gravity:get_int() ~= -10000 then
        cvars.cl_ragdoll_gravity:set_int(-10000)
        print("lizzy | cl_ragdoll_gravity set to -10000")
    end
    if not rocket_enabled:get() and cvars.cl_ragdoll_gravity:get_int() ~= 600 then
        cvars.cl_ragdoll_gravity:set_int(600)
        print("lizzy | cl_ragdoll_gravity set to 600")
    end
end

callbacks.add(e_callbacks.PAINT, apply_tweaks)