local cache = { }
local script = {
    menu = { "RAGE", "Other" },
    mode = { "Offensive", "Defensive" },

    active = false,
    time = -0.26,
    max_time = 0,

    reference = {
        rage = { ui.reference("RAGE", "Aimbot", "Enabled") },
        hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),

        fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
        onshot = { ui.reference("AA", "Other", "On shot anti-aim") },

        double_tap = { ui.reference("RAGE", "Other", "Double tap") },
        double_tap_mode = ui.reference("RAGE", "Other", "Double tap mode"),
    }
}

function script:call(func, name, ...)
    if func == nil then
        return
    end

    local end_name = name[2] == nil and "" or name[2]

    if name[1] ~= nil then
        end_name = end_name ~= "" and (end_name .. " ") or end_name
        end_name = end_name .. "\n " .. name[1]
    end

    return func(self.menu[1], self.menu[2], end_name, ...)
end

function script:multi_exec(func, list)
    if func ~= nil then
        for ref, val in pairs(list) do
            func(ref, val)
        end
    end
end

local menu = {
    active = script:call(ui.new_checkbox, { "cfs_active", "Crim fire" }),
    switch_hk = script:call(ui.new_hotkey, { "cfs_hotkey", "Crim fire hotkey" }, true),
    mode = script:call(ui.new_combobox, { "cfs_mode", nil }, script.mode),
    
    handling = script:call(ui.new_checkbox, { "cfs_handling", "Handling double tap" }),
    hcfix = script:call(ui.new_checkbox, { "cfs_hcfix", "Hit chance precision" }),

    safe_activation = script:call(ui.new_checkbox, { "cfs_safe_activation", "Safe activation" }),
}

local _ialpha, _iplm = 0, true
local ui_get, ui_set = ui.get, ui.set
local entity_get_prop = entity.get_prop

local function cache_process(condition, should_call, a, b)
    local name = tostring(condition)
    cache[name] = cache[name] ~= nil and cache[name] or ui_get(condition)

    if should_call then
        if type(a) == "function" then a() else
            ui_set(condition, a)
        end
    else
        if cache[name] ~= nil then
            if b ~= nil and type(b) == "function" then
                b(cache[name])
            else
                ui_set(condition, cache[name])
            end

            cache[name] = nil
        end
    end
end

local menu_callback = function(e)
    local active = e ~= nil and ui_get(menu.active)
    local mode = ui_get(menu.mode)

    local ref = script.reference
    
    script:multi_exec(ui.set_visible, {
        [menu.mode] = active,
        [menu.handling] = active,
        [menu.hcfix] = active,

        [menu.safe_activation] = active and mode == script.mode[1],

        -- double tap reference
        [ref.double_tap[1]] = not active,
        [ref.double_tap[2]] = not active,
        [ref.double_tap_mode] = not active,
    })
end

menu_callback(menu.active)
ui.set_callback(menu.active, menu_callback)
ui.set_callback(menu.mode, menu_callback)

client.set_event_callback("shutdown", menu_callback)
client.set_event_callback("predict_command", function()
    menu_callback(true)

    script.active = ui_get(menu.active) and ui_get(menu.switch_hk)
    script.time = -0.26

    local safe = true

    local me = entity.get_local_player()
    local weapon = entity.get_player_weapon(me)

    local ref = script.reference
    local mode = ui_get(menu.mode)

    if script.active then
        script:multi_exec(ui_set, {
            [ref.double_tap_mode] = mode,
            [ref.double_tap[2]] = "always on"
        })

        local game_rules = entity.get_game_rules()

        local is_valve_ds = entity_get_prop(game_rules, "m_bIsValveDS") == 0
        local in_freeze_period = entity_get_prop(game_rules, "m_bFreezePeriod") == 0

        script.active = weapon ~= nil and is_valve_ds and in_freeze_period
    end

    if ui_get(menu.handling) then
        local weapon_name = entity.get_classname(weapon)
        local idx = entity_get_prop(weapon, "m_iItemDefinitionIndex")

        if weapon_name == nil or idx == nil then
            script.active = false
            return
        end

        local item = bit.band(idx, 0xFFFF)

        local fd_active = ui_get(ref.fake_duck)
        local os_active = ui_get(ref.onshot[1]) and ui_get(ref.onshot[2])

        if  fd_active or os_active or weapon_name == "CKnife" or 
            item == 64 or (item > 42 and item < 49) then

            script.active = false
        end
    end

    local m_flNextAttack = entity_get_prop(me, "m_flNextAttack")
    local next_attack = entity_get_prop(weapon, "m_flNextPrimaryAttack")

    if next_attack == nil then
        script.active = false
        return
    end

    local max_time = 0.69
    local current_time = globals.curtime()
    local m_flAttackTime = next_attack + 0.5

    local m_flNextAttack = m_flNextAttack + 0.5
    local shift_time = m_flAttackTime - current_time

    if m_flAttackTime < m_flNextAttack then
        max_time = 1.52
        shift_time = m_flNextAttack - current_time
    end

    script.time = shift_time
    script.max_time = max_time

    local is_safe = max_time ~= 1.52 and shift_time > 0.1

    if ui_get(menu.hcfix) then
        local shots_fired = entity_get_prop(me, "m_iShotsFired")

        cache_process(ref.hitchance, script.active and is_safe and shots_fired > 0 and shift_time >= (max_time - 0.1), 0)
    end

    if mode == script.mode[1] and not ui_get(menu.safe_activation) and is_safe then
        safe = false
    end

    ui_set(ref.double_tap[1], script.active and safe)
end)

client.set_event_callback("paint", function()
    local setup_alpha = function(maximum_alpha)
        _ialpha = _ialpha == nil and maximum_alpha or _ialpha
        _iplm = _iplm == nil and true or _iplm
    
        if _ialpha > (maximum_alpha+30) then 
            _ialpha = (maximum_alpha+30)
            _iplm = true
        end
    
        if _ialpha < 15 then 
            _ialpha = 15
            _iplm = false
        end
    
        local frame = 1 / 0.005 * globals.frametime()
        _ialpha = (_iplm and (_ialpha - frame) or (_ialpha + frame))
    
        local a = _ialpha < 30 and 30 or _ialpha
        return (a > maximum_alpha and maximum_alpha or a)
    end

    local me = entity.get_local_player()

    if not script.active or not entity.is_alive(me) then
        return
    end

    local shift_time, max_time = 
        script.time, script.max_time

    local y = renderer.indicator(255, 255, 255, script.time > 0 and setup_alpha(180) or 180, "CF")

    if ui_get(menu.mode) == script.mode[1] and shift_time > -0.26 and max_time > shift_time then
        shift_time = shift_time < 0 and 0 or shift_time

        renderer.rectangle(10, y + 26, 30, 5, 0, 0, 0, 150)
        renderer.rectangle(11, y + 27, (28 / max_time) * (max_time - shift_time), 3, 133, 197, 12, 255)
    end
end)
