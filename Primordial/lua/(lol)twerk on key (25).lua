--| Register the UI element(s)
local twerk_keybind = menu.add_text("los the lua man", "twerk"):add_keybind("twerk_key")

--| The setup command callback function
local function on_setup_command(user_cmd)
    -- Check if the twerk bind is pressed
    if not twerk_keybind:get() then
        return
    end

    -- Add IN_BULLRUSH to the buttons to prevent crouch cooldown
    if not user_cmd:has_button(e_cmd_buttons.BULLRUSH) then
        user_cmd:add_button(e_cmd_buttons.BULLRUSH)
    end

    -- Twerk with a 8 tick interval
    if global_vars.tick_count() % 16 < 8 then
        user_cmd:add_button(e_cmd_buttons.DUCK)
    end
end

--| Register the setup command callback
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)