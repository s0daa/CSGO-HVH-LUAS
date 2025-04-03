local enable = menu.add_checkbox('force onshot', 'force onshot | key: ')
local key = enable:add_keybind('key')
local enable_flag = menu.add_checkbox('force onshot', 'show esp flag')

local force_onshot = function (ctx)
    if not enable:get() or not key:get() then return end

    local players = entity_list.get_players()
    for _ , player in pairs(players) do
        if player:is_enemy() and player:is_alive() then
            local player_index = player:get_index()
            local player_weapon = player:get_active_weapon()
            if player_weapon then
                if (global_vars.cur_time() - player_weapon:get_prop('m_fLastShotTime') > 0.5) then
                    ctx:ignore_target(player_index)
                end
            end
        end
    end
end

local function on_player_esp(ctx)
    if ctx.dormant or not enable:get() or not key:get() or not enable_flag:get() then
        return
    end

    if ctx.player:get_active_weapon():get_prop('m_fLastShotTime') then
        if not (global_vars.cur_time() - ctx.player:get_active_weapon():get_prop('m_fLastShotTime') > 0.5) then
            ctx:add_flag("FORCE ON-SHOT", color_t(255, 0, 0, 255))
        end
    end
end

callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)
callbacks.add(e_callbacks.TARGET_SELECTION, force_onshot) -- target_selection