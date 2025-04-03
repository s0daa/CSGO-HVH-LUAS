local get, set_prop, get_prop, cb, slider, get_all, add_event, get_lp, is_alive = ui.get, entity.set_prop, entity.get_prop, ui.new_checkbox, ui.new_slider, entity.get_all, client.set_event_callback, entity.get_local_player, entity.is_alive
local m_enable = cb("misc", "miscellaneous", "Ragdoll launcher")
local m_mult = slider("misc", "miscellaneous", "\n ragdoll_launcher_multiplier", 0, 250, 0)
local function launch_ragdoll(ragdoll)
    local mult = get(m_mult)
    local force_x, force_y, force_z = get_prop(ragdoll, "m_vecForce")
    local ragdollvelocity_x, ragdollvelocity_y, ragdollvelocity_z = get_prop(ragdoll, "m_vecRagdollVelocity")
    set_prop(ragdoll, "m_vecForce", force_x * mult, force_y * mult, force_z * mult)
    set_prop(ragdoll, "m_vecRagdollVelocity", ragdollvelocity_x * mult, ragdollvelocity_y * mult, ragdollvelocity_z * mult)
end
add_event("net_update_end", function()
    if get(m_enable) == false then return end
    local me = get_lp()
    if me == nil or me == 0 then return end
    if not is_alive(me) then return end
    local ragdolls = get_all("CCSRagdoll")
    for i=1, #ragdolls do 
        local ragdoll = ragdolls[i]
        if ragdoll == nil then return end
        launch_ragdoll(ragdoll)
    end
end)