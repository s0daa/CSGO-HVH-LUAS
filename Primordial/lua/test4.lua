local 
menu_find, render_create_font, client_log_screen, engine_exec, ui_new_button, ui_new_checkbox, ui_new_selection, ui_new_slider, ui_new_text, ui_new_multi_selection, ui_set_group_column, render_rect_fade, render_rect_filled, render_rect, render_text, render_get_text_size, render_push_clip, render_progress_circle, render_pop_clip, exploits_force_uncharge, exploits_get_charge, exploits_block_recharge, exploits_allow_recharge, callbacks_add, antiaim_get_manual, antiaim_get_desync_side, antiaim_is_inverting_desync, global_cur_time, entity_get_local_player, math_sqrt, math_pow, math_floor, math_max, math_sin, string_format, render_get_screen_size = 
menu.find, render.create_font, client.log_screen, engine.execute_cmd, menu.add_button, menu.add_checkbox, menu.add_selection, menu.add_slider, menu.add_text, menu.add_multi_selection, menu.set_group_column, render.rect_fade, render.rect_filled, render.rect, render.text, render.get_text_size, render.push_clip, render.progress_circle, render.pop_clip, exploits.force_uncharge, exploits.get_charge, exploits.block_recharge, exploits.allow_recharge, callbacks.add, antiaim.get_manual_override, antiaim.get_desync_side, antiaim.is_inverting_desync, global_vars.cur_time, entity_list.get_local_player, math.sqrt, math.pow, math.floor, math.max, math.sin, string.format, render.get_screen_size

local slowmotion = menu_find("misc", "main", "movement", "slow walk")
local fl_type = {}
local fl_types = { "Slow walk", "Stand", "Move", "Air", "Duck" }
local cus_fl = ui_new_checkbox("MixoSync:Fakelag", "Adaptive Choke")
local fakelag_list = ui_new_selection("MixoSync:Fakelag", "Choke states", fl_types)
for i=1, #fl_types do
    fl_type[i] = {
        fl = ui_new_slider("MixoSync:Fakelag", "[" .. fl_types[i] .. "] Choke", 1, 16, 1, 0, " ticks"),
    }
end

local is_air
local final_choke = 0
local lp_speed = function() return math_sqrt(math_pow(entity_get_local_player():get_prop("m_vecVelocity[0]"), 2) + math_pow(entity_get_local_player():get_prop("m_vecVelocity[1]"), 2)) end
callbacks_add(e_callbacks.RUN_COMMAND, function(cmd, pre_cmd)
    local local_player = entity_get_local_player()
    if not local_player or not local_player:is_alive() then return end

    if local_player:has_player_flag(e_player_flags.ON_GROUND) == false or pre_cmd:has_player_flag(e_player_flags.ON_GROUND) == false then is_air = true else is_air = false end
end)

local fl_state = function()
    local local_player = entity_get_local_player()

    if is_air then
        return "Air"
    elseif slowmotion[2]:get() then
        return "Slow walk"
    elseif local_player:has_player_flag(e_player_flags.DUCKING) then
        return "Duck"
    elseif lp_speed() > 5 then
        return "Move"
    else
        return "Stand"        
    end
end

callbacks_add(e_callbacks.ANTIAIM, function(ctx)
    local local_player = entity_get_local_player()
    if not local_player or not local_player:is_alive() then return end
    local choke_cmd =  engine.get_choked_commands()

    local fl_even
    if cus_fl:get() then
        for k, v in pairs(fl_types) do
            if fl_state() == fakelag_list:get_item_name(k) then
                final_choke = fl_type[k].fl:get()
                fl_even = fl_type[k].fl:get() % 2 == 0 and true or false
            end
        end

        if fl_even then
            if choke_cmd < final_choke then ctx:set_fakelag(true) else ctx:set_fakelag(false) end
        else
            if choke_cmd <= final_choke then ctx:set_fakelag(true) else ctx:set_fakelag(false) end      
        end

        if choke_cmd == 0 then final_choke = 0 end
    end
end)

local function menu_visible_set()
    if not menu.is_open() then return end
    for i=1, #fl_types do
        local menu_show = fakelag_list:get_item_name(fakelag_list:get()) == fl_types[i] and cus_fl:get()
        fl_type[i].fl:set_visible(menu_show)
    end
    fakelag_list:set_visible(cus_fl:get()) 
end

callbacks_add(e_callbacks.PAINT, menu_visible_set)