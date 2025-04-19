local skeet do
    skeet = { }

    skeet.weapon_type = ui.reference('Rage', 'Weapon type', 'Weapon type')
    skeet.accuracy_boost = ui.reference('Rage', 'Other', 'Accuracy boost')
    skeet.delay_shot = ui.reference('Rage', 'Other', 'Delay shot')
    skeet.avoid_unsafe = ui.reference('Rage', 'Aimbot', 'Avoid unsafe hitboxes')
    skeet.hitchance = ui.reference('Rage', 'Aimbot', 'Minimum hit chance')
    skeet.ping_spike = { ui.reference('Misc', 'Miscellaneous', 'Ping spike') }
    skeet.damage_override = { ui.reference('Rage', 'Aimbot', 'Minimum damage override') }
    skeet.auto_scope = ui.reference('Rage', 'Aimbot', 'Automatic scope')
    skeet.auto_stop = select(3, ui.reference('Rage', 'Aimbot', 'Quick stop'))
    skeet.auto_peek = { ui.reference('Rage', 'Other', 'Quick peek assist') }
    skeet.dt = { ui.reference('Rage', 'Aimbot', 'Double tap') }
    skeet.hide = { ui.reference('AA', 'Other', 'On shot anti-aim') }
end

do
    table.convert = function(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for i = 1, #tbl do
            final[ tbl[i] ] = true
        end

        return final
    end

    table.invert = function(tbl)
        if tbl == nil then
            return { }
        end

        local final = { }

        for name, enabled in next, tbl do
            if enabled then
                final[ #final + 1 ] = name
            end
        end

        return final
    end
end

do
    ui.new_label('Rage', 'Aimbot', '           Adaptive Section        ')
    local accuracy_boost = ui.new_combobox('Rage', 'Aimbot', 'Accuracy Boost', { 'Low', 'Medium', 'High', 'Maximum' })
    local delay_shot = ui.new_checkbox('Rage', 'Aimbot', 'Delay Shot')
    local delay_shot_key = ui.new_hotkey('Rage', 'Aimbot', '\n Delay shot key', true)

    local ping_spike = ui.new_checkbox('Rage', 'Aimbot', 'Ping Spike', 1)
    local ping_spike_key = ui.new_hotkey('Rage', 'Aimbot', '\nPing Spike Key', true)
    local ping_spike_val = ui.new_slider('Rage', 'Aimbot', '\nPing Spike Val', 1, 200, 100, true, 'ms')

    client.set_event_callback('paint_ui', function ()
        ui.set(skeet.delay_shot, ui.get(delay_shot) and ui.get(delay_shot_key))
        ui.set(skeet.accuracy_boost, ui.get(accuracy_boost))

        do
            local active = ui.get(ping_spike_key)

            ui.set(skeet.ping_spike[1], ui.get(ping_spike))
            ui.set(skeet.ping_spike[2], active and 'Always on' or 'On hotkey')
            ui.set(skeet.ping_spike[3], ui.get(ping_spike_val))
        end
    end)

    local function ping_spike_cb()
        ui.set_visible(ping_spike_val, ui.get(ping_spike))
    end

    ui.set_callback(ping_spike, ping_spike_cb)
    ping_spike_cb()
end

local avoid_unsafe do
    avoid_unsafe = { }

    local list = { }

    local hitboxes = ui.new_multiselect('Rage', 'Aimbot', 'Avoid Unsafe on Min. Damage', { 'Head', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet' })

    function avoid_unsafe.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.avoid_unsafe, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function avoid_unsafe.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.avoid_unsafe)
        end

        ui.set(skeet.avoid_unsafe, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(skeet.damage_override[1]) and ui.get(skeet.damage_override[2]) then
            local value = ui.get(hitboxes)
            avoid_unsafe.set(wpn, value)
            return
        end

        if list[wpn] ~= nil then
            ui.set(skeet.avoid_unsafe, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', avoid_unsafe.backups)
    client.set_event_callback('pre_config_save', avoid_unsafe.backups)
end

local hitchance do
    hitchance = { }
    local list = { }

    local master = ui.new_checkbox('Rage', 'Aimbot', 'Custom Hitchance')
    local on_hotkey = ui.new_slider('Rage', 'Aimbot', 'On Key Hitchance', 0, 100, 50, true, '%', 1, {[0] = 'Off'})
    local hotkey = ui.new_hotkey('Rage', 'Aimbot', '\n On Key Hitchance', true)
    local in_air = ui.new_slider('Rage', 'Aimbot', 'In Air', 0, 100, 50, true, '%', 1, {[0] = 'Off'})
    local no_scope = ui.new_slider('Rage', 'Aimbot', 'No Scope', 0, 100, 50, true, '%', 1, {[0] = 'Off'})
    local quick_peek = ui.new_slider('Rage', 'Aimbot', 'On Auto Peek', 0, 100, 50, true, '%', 1, {[0] = 'Off'})

    local can_scope = {
        ['G3SG1 / SCAR-20'] = true,
        ['SSG 08'] = true,
        ['AWP'] = true,
        ['Rifles'] = true
    }

    local function cb()
        local val = ui.get(master)
        local wpn = ui.get(skeet.weapon_type)

        ui.set_visible(on_hotkey, val)
        ui.set_visible(hotkey, val)
        ui.set_visible(in_air, val)
        ui.set_visible(quick_peek, val)
        ui.set_visible(no_scope, val and can_scope[wpn])
    end

    ui.set_callback(master, cb)
    ui.set_callback(hotkey, cb)

    cb()

    function hitchance.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.hitchance, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function hitchance.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.hitchance)
        end

        ui.set(skeet.hitchance, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(master) then
            if ui.get(hotkey) then
                local value = ui.get(on_hotkey)

                if value ~= 0 then
                    renderer.indicator(255, 255, 255, 200, 'PREDICT')
                    hitchance.set(wpn, value)
                    return
                end
            end

            if bit.band(entity.get_prop(me, 'm_fFlags'), 1) == 0 then
                local value = ui.get(in_air)

                if value ~= 0 then
                    hitchance.set(wpn, value)
                    return
                end
            end

            if can_scope[wpn] and entity.get_prop(me, 'm_bIsScoped') == 0 then
                local value = ui.get(no_scope)

                if value ~= 0 then
                    hitchance.set(wpn, value)
                    return
                end
            end

            if ui.get(skeet.auto_peek[1]) and ui.get(skeet.auto_peek[2]) then
                local value = ui.get(quick_peek)
                if value ~= 0 then
                    hitchance.set(wpn, value)
                    return
                end
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.hitchance, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', hitchance.backups)
    client.set_event_callback('pre_config_save', hitchance.backups)
end

local early do
    early = { }

    local list = { }

    local enabled = ui.new_checkbox('Rage', 'Aimbot', 'Early on Auto Peek')

    function early.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.auto_stop, v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    function early.set(weapon, value)
        if list[weapon] == nil then
            list[weapon] = ui.get(skeet.auto_stop)
        end

        ui.set(skeet.auto_stop, value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local wpn = ui.get(skeet.weapon_type)

        if ui.get(enabled) then
            if ui.get(skeet.auto_peek[1]) and ui.get(skeet.auto_peek[2]) then
                local convert = table.convert(ui.get(skeet.auto_stop))
                if not convert['Early'] then
                    convert['Early'] = true
                end

                early.set(wpn, table.invert(convert))
                return
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.auto_stop, list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', early.backups)
    client.set_event_callback('pre_config_save', early.backups)
end

local deagle do
    deagle = { }

    local list = { }

    local enabled = ui.new_checkbox('Rage', 'Aimbot', 'DT on Deagle')

    local function cb()
        ui.set_visible(enabled, ui.get(skeet.weapon_type) == 'Desert Eagle')
    end

    ui.set_callback(skeet.weapon_type, cb)
    cb()

    function deagle.backups()
        local prev = ui.get(skeet.weapon_type)

        for k, v in pairs(list) do
            ui.set(skeet.weapon_type, k)
            ui.set(skeet.dt[2], v)

            list[k] = nil
        end

        ui.set(skeet.weapon_type, prev)
    end

    local hotkey_modes = { [0] = 'Always on', "On hotkey", "Toggle", "Off hotkey" }

    function deagle.set(weapon, value)
        if list[weapon] == nil then
            local is_active, mode = ui.get(skeet.dt[2])
            list[weapon] = hotkey_modes[ mode ]
        end

        ui.set(skeet.dt[2], value)
    end

    client.set_event_callback('paint_ui', function ()
        local me = entity.get_local_player()
        if me == nil or not entity.is_alive(me) then
            return
        end

        local weapon = entity.get_player_weapon(me)
        if weapon == nil then
            return
        end

        local classname = entity.get_classname(weapon)
        local wpn = ui.get(skeet.weapon_type)

        if ui.get(enabled) then
            if wpn == 'Desert Eagle' and classname == 'CDEagle' then
                deagle.set(wpn, ui.get(skeet.hide[2]) and 'On hotkey' or 'Always on')
                return
            end
        end

        if list[wpn] ~= nil then
            ui.set(skeet.dt[2], list[wpn])
            list[wpn] = nil
        end
    end)

    client.set_event_callback('shutdown', deagle.backups)
    client.set_event_callback('pre_config_save', deagle.backups)
end