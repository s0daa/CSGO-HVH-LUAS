local friendly_fire = menu.add_text("Friendly fire", "friendly_fire")
local friendly_fire_ref = friendly_fire:add_keybind("friendly_fire_toggle")

function on_setup_move(cmd)
    cvars["mp_teammates_are_enemies"]:set_int(friendly_fire_ref:get() and 1 or 0)
end

callbacks.add(e_callbacks.SETUP_COMMAND,on_setup_move)