weapons_name = {"ssg08", "awp"}
master_switch = menu.add_checkbox("Teleport in air", "Master Switch", false)
teleport_weapons = menu.add_multi_selection("Teleport in air","Weapons", weapons_name)

function teleport_in_air()
    if not master_switch:get() then return end
    if engine.is_connected() ~= true and entity_list.get_local_player() == nil then return end
    local weapon = entity_list.get_local_player():get_active_weapon()
    weapon_name = weapon:get_name()
    local correct_weapon = false
    local enemies_only = entity_list.get_players(true) 
    is_scout, is_awp = weapon_name == "ssg08", weapon_name == "awp"
    for i, weapons in pairs({
        is_scout,
        is_awp,
        not (is_scout or is_awp)
    }) do
        if (teleport_weapons:get(i) and weapons) then
            correct_weapon = true
        end
    end
    for i, enemy in pairs(enemies_only) do 
        if enemy ~= nil and enemy:is_alive() then 
            local trace_result = trace.bullet(entity_list.get_local_player():get_eye_position(), enemy:get_eye_position(), enemy, entity_list.get_local_player())
            if trace_result.hit_player and not (entity_list.get_local_player():has_player_flag(e_player_flags.ON_GROUND)) and correct_weapon then 
                exploits.block_recharge()
                exploits.force_uncharge()
            end
        end
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, teleport_in_air)
callbacks.add(e_callbacks.PAINT, function()
    teleport_weapons:set_visible(master_switch:get())
end)