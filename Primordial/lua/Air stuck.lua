ref_air_stuck = menu.add_checkbox("RageBot","Air stuck", false)
ref_air_stuck_key = ref_air_stuck:add_keybind("airstuck key")

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    if ref_air_stuck:get() and ref_air_stuck_key:get() then
        cmd.tick_count = 0x7FFFFFFF
        cmd.command_number = 0x7FFFFFFF
    end
end)