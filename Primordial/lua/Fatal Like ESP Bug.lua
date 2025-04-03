local cl_ragdoll_physics_enable = cvars.cl_ragdoll_physics_enable
local skeet_rags = menu.add_checkbox("Fatal","Fatal ESP bug")

local function skeet()
    local value = skeet_rags:get() and 0 or 1
    if cl_ragdoll_physics_enable:get_int() ~= value then
        cl_ragdoll_physics_enable:set_int(value)
    end
end

callbacks.add(e_callbacks.PAINT, skeet)