local menu_items = {
    key = menu.add_text("general", "enable"):add_keybind("key"),
    visible_only = menu.add_checkbox("general", "visible only"),
}

function on_run_command(cmd)
    local local_player = entity_list.get_local_player()

    if not menu_items.key:get() then
        return
    end

    if not client.can_fire() then
        return
    end

    local weapon = local_player:get_active_weapon()
    if weapon == nil then
        return
    end

    local weapon_data = weapon:get_weapon_data()
    if weapon_data == nil then
        return
    end

    local start_pos = local_player:get_eye_position()
    local end_pos = start_pos + cmd.viewangles:to_vector():scaled(weapon_data.range)

    local bullet_data = trace.bullet(start_pos, end_pos)
    if not bullet_data.valid then
        return
    end

    if bullet_data.hit_player:is_enemy() then
        if menu_items.visible_only:get() and bullet_data.pen_count > 0 then
            return
        end

        cmd:add_button(e_cmd_buttons.ATTACK)
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, on_run_command)