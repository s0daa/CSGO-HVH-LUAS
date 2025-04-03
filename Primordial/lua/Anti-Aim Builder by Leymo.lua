-- Find Menuvars
local var_antiaim_main_angles_yawadd = menu.find( "antiaim", "main", "angles", "yaw add" )
local var_antiaim_main_angles_jittermode = menu.find( "antiaim", "main", "angles", "jitter mode" )
local var_antiaim_main_angles_jitteradd = menu.find( "antiaim", "main", "angles", "jitter add" )
local var_antiaim_main_angles_bodylean = menu.find( "antiaim", "main", "angles", "body lean" )
local var_antiaim_main_angles_bodyleanvalue = menu.find( "antiaim", "main", "angles", "body lean value" )
local var_antiaim_main_desync_stand_side = menu.find( "antiaim", "main", "desync", "stand", "side" )
local var_antiaim_main_desync_stand_leftamount = menu.find( "antiaim", "main", "desync", "stand", "left amount" )
local var_antiaim_main_desync_stand_rightamount = menu.find( "antiaim", "main", "desync", "stand", "right amount" )

local conditions_list = { "standing", "walking", "running", "jumping", "crouching" }
local master_table = { }
local settings_table = { }

local resync_all_angles = menu.add_checkbox("antiaim", "resync angles")
local condition_to_view = menu.add_selection("antiaim", "condition", conditions_list)
local condition_to_use = menu.add_multi_selection("antiaim", "conditions to use", { "walking", "running", "jumping", "crouching" })

for _, condition in pairs(conditions_list) do
    local i = 1
    while i <= 3 do
        table.insert(master_table, 0) -- Fake/Real/Roll Switch State
        table.insert(master_table, 0) -- Fake/Real/Roll Jitter State
        table.insert(master_table, 0) -- Fake/Real/Roll Switch Ticks
        table.insert(master_table, 0) -- Fake/Real/Roll Jitter Ticks
        table.insert(master_table, 0) -- Fake/Real/Roll Jitter Delay
        table.insert(master_table, 0) -- Fake/Real/Roll Switch Offset
        table.insert(master_table, 0) -- Fake/Real/Roll Jitter Offset
        i = i + 1
    end
end

for _, condition in pairs(conditions_list) do
    local i = 1
    while i <= 3 do
        local prefix = "[" .. condition .. "] "
        local tab = i == 1 and "fake" or i == 2 and "real" or i == 3 and "roll" or ""
        local max_offset = tab == "fake" and 180 or tab == "real" and 100 or tab == "roll" and 50

        table.insert(settings_table, menu.add_slider(tab, prefix .. "base offset", -max_offset, max_offset))
        table.insert(settings_table, menu.add_checkbox(tab, prefix .. "switch"))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "first switch offset", -max_offset, max_offset))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "first switch duration", 1, 40))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "second switch offset", -max_offset, max_offset))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "second switch duration", 1, 40))
        table.insert(settings_table, menu.add_checkbox(tab, prefix .. "jitter"))
        table.insert(settings_table, menu.add_checkbox(tab, prefix .. "randomize offset"))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "first jitter offset", -max_offset, max_offset))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "second jitter offset", -max_offset, max_offset))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "min delay", 1, 10))
        table.insert(settings_table, menu.add_slider(tab, prefix .. "max delay", 1, 10))
        i = i + 1
    end
end

local reset_vars = function()
    local tick_count = global_vars.tick_count()

    for _, var in pairs(master_table) do
        master_table[_] = 0
    end
end

local entries_count = 21
local settings_count = 36
local get_index_for_condition = function(condition_to_look_for)
    for _, condition in pairs(conditions_list) do
        if condition == condition_to_look_for then
            return { entries_count * (_ - 1), settings_count * (_ - 1) }
        end
    end

    return { 0, 0 }
end

local get_local_conditon = function()
    local local_player = entity_list.get_local_player()

    if local_player == nil then return "standing" end
    
    local velocity_0 = local_player:get_prop("m_vecVelocity[0]")
    local velocity_1 = local_player:get_prop("m_vecVelocity[1]")
    local velocity_2 = local_player:get_prop("m_vecVelocity[2]")

    local crouch_key = input.find_key_bound_to_binding("duck")

    if velocity_0 == nil or velocity_1 == nil or velocity_2 == nil then return "standing" end

    if input.is_key_held(crouch_key) and condition_to_use:get(4) then
        return "crouching"
    elseif velocity_0 < 3 and velocity_0 > -3 and velocity_1 < 3 and velocity_1 > -3 then
        return "standing"
    elseif velocity_2 ~= 0 and condition_to_use:get(3) then
        return "jumping"
    elseif menu.find( "misc", "main", "movement", "slow walk" )[2]:get() and condition_to_use:get(1) then
        return "walking"
    elseif condition_to_use:get(2) then
        return "running"
    end

    return "standing"
end

local run_antiaim = function(var_index, setting_index)
    local tick_count = global_vars.tick_count()

    local i = 1
    while i <= 3 do
        local extended_var_offset = (entries_count / 3) * (i - 1)
        local extended_set_offset = (settings_count / 3) * (i - 1)

        local var_switch_state = extended_var_offset + var_index + 1
        local var_jitter_state = extended_var_offset + var_index + 2
        local var_switch_ticks = extended_var_offset + var_index + 3
        local var_jitter_ticks = extended_var_offset + var_index + 4
        local var_jitter_delay = extended_var_offset + var_index + 5
        local var_switch_offset = extended_var_offset + var_index + 6
        local var_jitter_offset = extended_var_offset + var_index + 7
    
        local set_base_offset = extended_set_offset + setting_index + 1
        local set_switch_enable = extended_set_offset + setting_index + 2
        local set_switch_first_offset = extended_set_offset + setting_index + 3
        local set_switch_first_duration = extended_set_offset + setting_index + 4
        local set_switch_second_offset = extended_set_offset + setting_index + 5
        local set_switch_second_duration = extended_set_offset + setting_index + 6
        local set_jitter_enable = extended_set_offset + setting_index + 7
        local set_jitter_randomize = extended_set_offset + setting_index + 8
        local set_jitter_first_offset = extended_set_offset + setting_index + 9
        local set_jitter_second_offset = extended_set_offset + setting_index + 10
        local set_jitter_min_delay = extended_set_offset + setting_index + 11
        local set_jitter_max_delay = extended_set_offset + setting_index + 12

        if master_table[var_switch_ticks] > tick_count then
            master_table[var_switch_ticks] = tick_count
        end

        if master_table[var_jitter_ticks] > tick_count then
            master_table[var_jitter_ticks] = tick_count
        end

        -- Switch
        if master_table[var_switch_state] == 0 and tick_count - master_table[var_switch_ticks] > settings_table[set_switch_first_duration]:get() then
            master_table[var_switch_state] = 1
            master_table[var_switch_ticks] = tick_count
        elseif master_table[var_switch_state] == 1 and tick_count - master_table[var_switch_ticks] > settings_table[set_switch_second_duration]:get() then
            master_table[var_switch_state] = 0
            master_table[var_switch_ticks] = tick_count
        end

        master_table[var_switch_offset] = settings_table[set_base_offset]:get() + (settings_table[set_switch_enable]:get() and (master_table[var_switch_state] == 0 and settings_table[set_switch_first_offset]:get() or settings_table[set_switch_second_offset]:get()) or 0)

        -- Jitter
        if not settings_table[set_jitter_enable]:get() then
            master_table[var_jitter_offset] = 0
            goto skipjitter
        end

        if tick_count - master_table[var_jitter_ticks] > master_table[var_jitter_delay] then
            master_table[var_jitter_state] = master_table[var_jitter_state] == 0 and 1 or 0

            if settings_table[set_jitter_randomize]:get() then
                master_table[var_jitter_offset] = math.random(math.min(settings_table[set_jitter_first_offset]:get(), settings_table[set_jitter_second_offset]:get()), math.max(settings_table[set_jitter_first_offset]:get(), settings_table[set_jitter_second_offset]:get()))
            else
                if master_table[var_jitter_state] == 0 then
                    master_table[var_jitter_offset] = settings_table[set_jitter_first_offset]:get()
                elseif master_table[var_jitter_state] == 1 then
                    master_table[var_jitter_offset] = settings_table[set_jitter_second_offset]:get()
                end
            end
            
            master_table[var_jitter_delay] = math.random(math.min(settings_table[set_jitter_min_delay]:get(), settings_table[set_jitter_max_delay]:get()), math.max(settings_table[set_jitter_min_delay]:get(), settings_table[set_jitter_max_delay]:get()))
            master_table[var_jitter_ticks] = tick_count
        end

        ::skipjitter::

        i = i + 1
    end
end

local run_script = function()
    if resync_all_angles:get() then
        reset_vars()
        resync_all_angles:set(false)
    end

    for _, condition in pairs(conditions_list) do
        run_antiaim(get_index_for_condition(condition)[1], get_index_for_condition(condition)[2])
    end

    local base_index = get_index_for_condition(get_local_conditon())[1]
    local fake_angle = master_table[base_index + 6] + master_table[base_index + 7]
    local real_angle = master_table[base_index + 13] + master_table[base_index + 14]
    local roll_angle = master_table[base_index + 20] + master_table[base_index + 21]

    --print("Condition: " .. get_local_conditon() .. "     Fake: " .. fake_angle .. "     Real: " .. real_angle .. "     Roll: " .. roll_angle)

    var_antiaim_main_angles_yawadd:set(fake_angle)
    var_antiaim_main_angles_jittermode:set(1)
    var_antiaim_main_angles_jitteradd:set(0)
    if roll_angle ~= 0 then
        var_antiaim_main_angles_bodylean:set(2)
    end
    var_antiaim_main_angles_bodyleanvalue:set(roll_angle)
    var_antiaim_main_desync_stand_side:set(real_angle > 0 and 2 or 3)
    var_antiaim_main_desync_stand_leftamount:set(math.abs(real_angle))
    var_antiaim_main_desync_stand_rightamount:set(math.abs(real_angle))
end

local control_visibility = function()
    for _, setting in pairs(settings_table) do
        local setting_name = setting:get_name()
        local prefix = "[" .. condition_to_view:get_item_name(condition_to_view:get()) .. "]"
        local should_show = setting_name:find(prefix, 1, true) ~= nil

        setting:set_visible(should_show)
    end
end

local function on_event(event)
    if event.name == "round_start" then
        reset_vars()
    end
end

callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.PAINT, run_script)
callbacks.add(e_callbacks.PAINT, control_visibility)