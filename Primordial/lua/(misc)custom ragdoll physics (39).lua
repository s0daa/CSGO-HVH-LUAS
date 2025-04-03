local ragdoll_state = menu.add_selection("ragdoll physics", "ragdoll physics", {"normal", "disabled", "0 gravity", "launch to space"})

local function on_paint()
    if ragdoll_state:get() == 2 then
        cvars.cl_ragdoll_physics_enable:set_int(0)
    else
        cvars.cl_ragdoll_physics_enable:set_int(1)
    end

    if ragdoll_state:get() == 3 then
        cvars.cl_ragdoll_gravity:set_int(0)
    elseif ragdoll_state:get() == 4 then
        cvars.cl_ragdoll_gravity:set_int(-10000)
    else
        cvars.cl_ragdoll_gravity:set_int(600)
    end
end

local function on_unload()
    cvars.cl_ragdoll_gravity:set_int(600)
    cvars.cl_ragdoll_physics_enable:set_int(1)
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.SHUTDOWN, on_unload)