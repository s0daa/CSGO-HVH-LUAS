local text = menu.add_text("door spam", "enable")
local keybind = text:add_keybind("yo")

local switch = false

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    if keybind:get() then
        if switch then
            cmd:add_button(e_cmd_buttons.USE)
        end

        switch = not switch
    end
end)