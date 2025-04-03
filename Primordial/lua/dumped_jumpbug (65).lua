local jumpbug_enable = menu.add_checkbox("movement", "jumpbug")
local jumpbug_keybind = jumpbug_enable:add_keybind("jb key")
local bhop_menu_boolean_checkbox = menu.find("misc", "main", "movement", "bunnyhop")

callbacks.add(e_callbacks.RUN_COMMAND, function(cmd, unpred) 
    local local_player = entity_list:get_local_player()
    local is_on_ground = local_player:has_player_flag(e_player_flags.ON_GROUND)
    local was_on_ground = unpred:has_player_flag(e_player_flags.ON_GROUND)

    if not jumpbug_enable:get() or not jumpbug_keybind:get() then
        bhop_menu_boolean_checkbox:set(true)
        return end

    bhop_menu_boolean_checkbox:set(false)

    if is_on_ground and not was_on_ground then
        cmd:add_button(e_cmd_buttons.DUCK)
        cmd:remove_button(e_cmd_buttons.JUMP)
    end
end)