local ui = {
    weapon_selection = menu.add_multi_selection("AIMBOT HELPER -> CONFIGURATION", "weapon selection", {"auto", "scout", "awp", "deagle", "revolver", "pistols", "other"}),
    debug_enabled = menu.add_checkbox("AIMBOT HELPER -> DEBUG", "debug", true),
    delay_limit = menu.add_slider("AIMBOT HELPER -> DEBUG", "delay ticks limit", 1, 64),
    pause_limit = menu.add_slider("AIMBOT HELPER -> DEBUG", "delay break ticks", 1, 64),
    backtrack_sepatator = menu.add_separator("AIMBOT HELPER -> DEBUG"),
    backtrack_ticks_limit = menu.add_slider("AIMBOT HELPER -> DEBUG", "backtrack ticks limit", 1, 64)
}

local variables = {
    player_delay_count = {},
    player_break_count = {},
    player_velocity_history = {},
    weapon_list = {
        ["weapon_g3sg1"] = 1,
        ["weapon_scar20"] = 1,
        ["weapon_ssg08"] = 2,
        ["weapon_awp"] = 3,
        ["weapon_deagle"] = 4,
        ["weapon_revolver"] = 5
    }
}

local utilities = {
    get_active_weapon = function(weapon) 
        if variables.weapon_list[weapon.console_name] then 
            return variables.weapon_list[weapon.console_name]
        else 
            if weapon.type == e_weapon_types.PISTOLS then 
                return 6
            else 
                return 7
            end 
        end 
    end
}

callbacks.add(e_callbacks.HITSCAN, function(ctx, cmd, unpred_data)
    if not ui.weapon_selection:get(utilities.get_active_weapon(entity_list.get_local_player():get_active_weapon():get_weapon_data())) then return end 

    local target_health = ctx.player:get_prop("m_iHealth")
    local current_target_velocity = math.sqrt(ctx.player:get_prop("m_vecVelocity[0]")*ctx.player:get_prop("m_vecVelocity[0]") + ctx.player:get_prop("m_vecVelocity[1]")*ctx.player:get_prop("m_vecVelocity[1]") + ctx.player:get_prop("m_vecVelocity[2]")*ctx.player:get_prop("m_vecVelocity[2]"))
    local max_target_velocity = ctx.player:get_prop("m_flMaxspeed")

    local unpred_velocity = math.sqrt(unpred_data.velocity.x*unpred_data.velocity.x + unpred_data.velocity.y*unpred_data.velocity.y + unpred_data.velocity.z*unpred_data.velocity.z)

    if target_health < 92 then 
        ctx:set_hitscan_group_state(e_hitscan_groups.HEAD, false) 

        ctx:set_min_dmg(target_health)
        ctx:set_damage_accuracy(100)
        ctx:set_hitscan_group_state(e_hitscan_groups.CHEST, true, true) 
        ctx:set_hitscan_group_state(e_hitscan_groups.STOMACH, true, true) 
    end

    if variables.player_velocity_history[ctx.player:get_index()] then
        if #variables.player_velocity_history[ctx.player:get_index()] > 64 then 
            variables.player_velocity_history[ctx.player:get_index()] = {}
        end 
    end

    if not variables.player_velocity_history[ctx.player:get_index()] then 
        variables.player_velocity_history[ctx.player:get_index()] = {current_target_velocity}
    else 
        local table = variables.player_velocity_history[ctx.player:get_index()]
        table[#table+1] = current_target_velocity 

        variables.player_velocity_history[ctx.player:get_index()] = table
    end 

    if not variables.player_delay_count[ctx.player:get_index()] then 
        variables.player_delay_count[ctx.player:get_index()] = 0
        variables.player_break_count[ctx.player:get_index()] = 0 
    end 

    if variables.player_break_count[ctx.player:get_index()] > 0 then 
        variables.player_break_count[ctx.player:get_index()] = variables.player_break_count[ctx.player:get_index()] - 1 
        if ui.debug_enabled:get() then 
            print("delaying shot breaking due to delay limit reached | ticks left - "..variables.player_break_count[ctx.player:get_index()].."")
        end 

        return 
    end 

    if variables.player_delay_count[ctx.player:get_index()] >= ui.delay_limit:get() then 
        variables.player_break_count[ctx.player:get_index()] = ui.pause_limit:get()
        variables.player_delay_count[ctx.player:get_index()] = 0
        return 
    end 

    local backtracking = false
    if variables.player_velocity_history[ctx.player:get_index()] then 
        for i=1, #variables.player_velocity_history[ctx.player:get_index()] do 
            if variables.player_velocity_history[ctx.player:get_index()][#variables.player_velocity_history[ctx.player:get_index()]-i] == current_target_velocity then 
                if ui.backtrack_ticks_limit:get() < i then 
                    if ui.debug_enabled:get() then 
                        print("delaying shot due to backtrack ticks limit reached | ticks - ("..i.."/"..ui.backtrack_ticks_limit:get()..")")
                    end 

                    ctx:set_safepoint_state(true)
                else 
                    if ui.debug_enabled:get() then 
                        print("backtracking | ticks - "..i.."")
                    end 
                end 

                return 
            end 
        end 
    end 

    if not unpred_data.velocity or not unpred_data.move then return end 

    if unpred_velocity > max_target_velocity or unpred_velocity < current_target_velocity or current_target_velocity > unpred_velocity then
        if ui.debug_enabled:get() then 
            print("delaying shot due to mis-prediction | velocity - ("..current_target_velocity.."/"..unpred_velocity..")")
        end 

        ctx:set_safepoint_state(true)
        
        variables.player_delay_count[ctx.player:get_index()] = variables.player_delay_count[ctx.player:get_index()] + 1
    end 
end)