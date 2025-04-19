local ffi = require "ffi"

local function contains(tbl, val)
    if not tbl then return false end
    for i=1, #tbl do
        if tbl[i] == val then return true end
    end
    return false
end

local ui_elements = {
    enable = ui.new_checkbox("RAGE", "Aimbot", "Enhanced Prediction Control"),
    mode = ui.new_combobox("RAGE", "Aimbot", "Interpolation Mode", {"Minimum", "Medium", "High", "Adaptive", "Dynamic", "Aggressive"}),
    indicator = ui.new_checkbox("RAGE", "Aimbot", "Show Indicator"),
    adaptive_options = ui.new_multiselect("RAGE", "Aimbot", "Adaptive Options", {
        "Auto Speed Adjust",
        "Ping Compensation",
        "Smart Interp",
        "Movement Predict",
        "Crouch Predict",
        "Advanced Calculation"
    }),
    min_speed = ui.new_slider("RAGE", "Aimbot", "Min Speed Threshold", 0, 250, 100, true, "u"),
    max_ping = ui.new_slider("RAGE", "Aimbot", "Max Ping Compensation", 0, 200, 80, true, "ms"),
    crouch_predict = ui.new_slider("RAGE", "Aimbot", "Crouch Prediction", 0, 100, 50, true, "%"),
    indicator_style = ui.new_combobox("RAGE", "Aimbot", "Indicator Style", {"Simple", "Detailed", "Minimal"}),
    prediction_strength = ui.new_slider("RAGE", "Aimbot", "Prediction Strength", 0, 100, 50, true, "%"),
    reaction_time = ui.new_slider("RAGE", "Aimbot", "Reaction Time", 0, 100, 20, true, "ms"),
    prefire = ui.new_checkbox("RAGE", "Aimbot", "Auto Prefire"),
    aggressive_options = ui.new_multiselect("RAGE", "Aimbot", "Aggressive Options", {
        "Quick Shot",
        "Early Prediction",
        "Fast Recovery"
    }),
    anti_defensive = ui.new_checkbox("RAGE", "Aimbot", "Anti Defensive"),
    anti_defensive_options = ui.new_multiselect("RAGE", "Aimbot", "Anti Defensive Options", {
        "Instant Double Tap",
        "Aggressive Prediction",
        "Early Shot",
        "Break LC",
        "Force Backtrack",
        "Smart Prediction"
    }),
    defensive_strength = ui.new_slider("RAGE", "Aimbot", "Defensive Strength", 1, 100, 50, true, "%"),
    defensive_indicator = ui.new_checkbox("RAGE", "Aimbot", "Show Defensive Indicator"),
    configs = ui.new_combobox("RAGE", "Aimbot", "Weapon Configs", {
        "Default",
        "AWP",
        "Scout",
        "AK47/M4",
        "Deagle/R8",
        "Pistols",
        "Auto",
        "SMG"
    })
}

local configs = {
    ["Default"] = {
        mode = "Dynamic",
        prediction = 75,
        adaptive = {"Auto Speed Adjust", "Ping Compensation", "Movement Predict"},
        min_speed = 90,
        crouch = 65,
        anti_defensive = true,
        defensive_strength = 65,
        defensive_options = {"Smart Prediction", "Aggressive Prediction"}
    },
    ["AWP"] = {
        mode = "Aggressive",
        prediction = 85,
        reaction = 8,
        prefire = true,
        aggressive = {"Quick Shot", "Early Prediction"},
        crouch = 80,
        anti_defensive = true,
        defensive_strength = 80,
        defensive_options = {"Smart Prediction", "Early Shot"}
    },
    ["Scout"] = {
        mode = "Aggressive",
        prediction = 80,
        reaction = 12,
        prefire = true,
        aggressive = {"Quick Shot", "Early Prediction"},
        crouch = 75,
        anti_defensive = true,
        defensive_strength = 75,
        defensive_options = {"Smart Prediction", "Early Shot"}
    },
    ["AK47/M4"] = {
        mode = "Dynamic",
        prediction = 70,
        adaptive = {"Auto Speed Adjust", "Ping Compensation", "Smart Interp", "Movement Predict"},
        min_speed = 85,
        max_ping = client.latency() * 1000 + 20,
        crouch = 65,
        anti_defensive = true,
        defensive_strength = 60,
        defensive_options = {"Smart Prediction", "Aggressive Prediction"}
    },
    ["Deagle/R8"] = {
        mode = "Dynamic",
        prediction = 75,
        reaction = 10,
        aggressive = {"Quick Shot"},
        crouch = 70,
        anti_defensive = true,
        defensive_strength = 70,
        defensive_options = {"Smart Prediction"}
    },
    ["Pistols"] = {
        mode = "Dynamic",
        prediction = 65,
        adaptive = {"Auto Speed Adjust", "Movement Predict"},
        min_speed = 90,
        crouch = 60,
        anti_defensive = true,
        defensive_strength = 55,
        defensive_options = {"Smart Prediction"}
    },
    ["Auto"] = {
        mode = "Adaptive",
        prediction = 75,
        adaptive = {"Auto Speed Adjust", "Ping Compensation", "Movement Predict"},
        min_speed = 100,
        crouch = 70,
        anti_defensive = true,
        defensive_strength = 75,
        defensive_options = {"Smart Prediction", "Aggressive Prediction"}
    },
    ["SMG"] = {
        mode = "Dynamic",
        prediction = 65,
        adaptive = {"Speed Adjust", "Movement Predict"},
        min_speed = 110,
        crouch = 60,
        anti_defensive = true,
        defensive_strength = 50,
        defensive_options = {"Smart Prediction"}
    }
}

local original_values = {
    interp = cvar.cl_interp:get_float(),
    interp_ratio = cvar.cl_interp_ratio:get_int(),
    interpolate = cvar.cl_interpolate:get_int()
}

local function get_server_settings()
    return {
        tickrate = cvar.sv_maxcmdrate:get_int(),
        updaterate = cvar.cl_updaterate:get_int(),
        maxupdaterate = cvar.sv_maxupdaterate:get_int(),
        lerp_ratio = cvar.cl_interp_ratio:get_int()
    }
end

local function apply_weapon_config()
    local local_player = entity.get_local_player()
    local weapon = entity.get_player_weapon(local_player)
    if weapon then
        local weapon_id = entity.get_prop(weapon, "m_iItemDefinitionIndex")
        local current_config = "Default"
        
        if weapon_id == 40 then -- Scout
            current_config = "Scout"
        elseif weapon_id == 9 then -- AWP
            current_config = "AWP"
        elseif weapon_id == 7 or weapon_id == 8 or weapon_id == 10 or weapon_id == 13 then -- Auto Snipers
            current_config = "Auto"
        elseif weapon_id == 1 or weapon_id == 64 then -- Deagle/R8
            current_config = "Deagle/R8"
        elseif weapon_id == 7 or weapon_id == 16 or weapon_id == 60 then -- AK/M4
            current_config = "AK47/M4"
        elseif weapon_id == 2 or weapon_id == 3 or weapon_id == 4 or weapon_id == 30 or weapon_id == 32 or weapon_id == 36 or weapon_id == 61 or weapon_id == 63 then -- Pistols
            current_config = "Pistols"
        elseif weapon_id == 17 or weapon_id == 19 or weapon_id == 23 or weapon_id == 24 or weapon_id == 26 or weapon_id == 33 or weapon_id == 34 then -- SMGs
            current_config = "SMG"
        end
        
        local cfg = configs[current_config]
        ui.set(ui_elements.mode, cfg.mode)
        ui.set(ui_elements.prediction_strength, cfg.prediction)
        ui.set(ui_elements.crouch_predict, cfg.crouch)
        
        if cfg.reaction then
            ui.set(ui_elements.reaction_time, cfg.reaction)
        end
        
        if cfg.prefire ~= nil then
            ui.set(ui_elements.prefire, cfg.prefire)
        end
        
        if cfg.aggressive then
            ui.set(ui_elements.aggressive_options, cfg.aggressive)
        end
        
        if cfg.adaptive then
            ui.set(ui_elements.adaptive_options, cfg.adaptive)
        end
        
        if cfg.min_speed then
            ui.set(ui_elements.min_speed, cfg.min_speed)
        end
        
        if cfg.max_ping then
            ui.set(ui_elements.max_ping, cfg.max_ping)
        end

        if cfg.anti_defensive ~= nil then
            ui.set(ui_elements.anti_defensive, cfg.anti_defensive)
        end

        if cfg.defensive_strength then
            ui.set(ui_elements.defensive_strength, cfg.defensive_strength)
        end

        if cfg.defensive_options then
            ui.set(ui_elements.anti_defensive_options, cfg.defensive_options)
        end
    end
end

ui_elements.load_config = ui.new_button("RAGE", "Aimbot", "Load Config", function()
    local selected = ui.get(ui_elements.configs)
    local cfg = configs[selected]
    
    ui.set(ui_elements.mode, cfg.mode)
    ui.set(ui_elements.prediction_strength, cfg.prediction)
    ui.set(ui_elements.crouch_predict, cfg.crouch)
    
    if cfg.reaction then
        ui.set(ui_elements.reaction_time, cfg.reaction)
    end
    
    if cfg.prefire ~= nil then
        ui.set(ui_elements.prefire, cfg.prefire)
    end
    
    if cfg.aggressive then
        ui.set(ui_elements.aggressive_options, cfg.aggressive)
    end
    
    if cfg.adaptive then
        ui.set(ui_elements.adaptive_options, cfg.adaptive)
    end
    
    if cfg.min_speed then
        ui.set(ui_elements.min_speed, cfg.min_speed)
    end
    
    if cfg.max_ping then
        ui.set(ui_elements.max_ping, cfg.max_ping)
    end

    if cfg.anti_defensive ~= nil then
        ui.set(ui_elements.anti_defensive, cfg.anti_defensive)
    end

    if cfg.defensive_strength then
        ui.set(ui_elements.defensive_strength, cfg.defensive_strength)
    end

    if cfg.defensive_options then
        ui.set(ui_elements.anti_defensive_options, cfg.defensive_options)
    end
end)

local function handle_anti_defensive(cmd)
    if not ui.get(ui_elements.anti_defensive) then return end
    
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end
    
    local target = client.current_threat()
    if not target then return end
    
    local options = ui.get(ui_elements.anti_defensive_options)
    local strength = ui.get(ui_elements.defensive_strength) / 100
    
    local simulation_time = entity.get_prop(target, "m_flSimulationTime")
    local old_simulation_time = entity.get_prop(target, "m_flOldSimulationTime")
    local target_velocity = {x = entity.get_prop(target, "m_vecVelocity[0]"), y = entity.get_prop(target, "m_vecVelocity[1]")}
    local speed = math.sqrt(target_velocity.x * target_velocity.x + target_velocity.y * target_velocity.y)
    
    if simulation_time and old_simulation_time then
        local delta = simulation_time - old_simulation_time
        if delta > 0.2 or speed < 1.01 then
            if contains(options, "Instant Double Tap") then
                cvar.cl_clock_correction:set_int(0)
                cmd.force_defensive = true
                cmd.quick_stop = true
            end
            
            if contains(options, "Aggressive Prediction") then
                local current_interp = cvar.cl_interp:get_float()
                cvar.cl_interp:set_float(current_interp * (1 + strength))
                cmd.force_defensive = true
            end
            
            if contains(options, "Early Shot") then
                cmd.force_defensive = true
                cmd.quick_stop = true
                if speed < 1.01 then
                    cmd.force_defensive = true
                end
            end
            
            if contains(options, "Break LC") then
                cmd.force_defensive = true
                cmd.allow_send_packet = false
                if delta > 0.22 then
                    cmd.force_defensive = true
                end
            end

            if contains(options, "Force Backtrack") then
                cmd.force_defensive = true
                cmd.tickbase_shift = 16
            end

            if contains(options, "Smart Prediction") then
                local ping = client.latency() * 1000
                local adaptive_strength = math.min(1, ping / 100) * strength
                cvar.cl_interp:set_float(cvar.cl_interp:get_float() * (1 + adaptive_strength))
                if speed < 1.01 then
                    cmd.force_defensive = true
                end
            end
        end
    end
end

local function draw_defensive_indicator()
    if not ui.get(ui_elements.defensive_indicator) then return end
    
    local target = client.current_threat()
    if not target then return end
    
    local simulation_time = entity.get_prop(target, "m_flSimulationTime")
    local old_simulation_time = entity.get_prop(target, "m_flOldSimulationTime")
    
    if simulation_time and old_simulation_time then
        local delta = simulation_time - old_simulation_time
        if delta > 0.2 then
            local screen_width, screen_height = client.screen_size()
            renderer.text(screen_width / 2, screen_height - 80, 255, 0, 0, 255, "c", 0, "DEFENSIVE")
        end
    end
end

local function calculate_advanced_interp(mode, speed, ping, is_crouching, movement_data)
    local server = get_server_settings()
    local base_values = {
        ['Minimum'] = 0.007725,
        ['Medium'] = 0.015875,
        ['High'] = 0.020000,
        ['Adaptive'] = math.max(0.007725,1/server.tickrate),
        ['Dynamic'] = math.max(0.007725,(1/server.tickrate)*(1+(ping/1000))),
        ['Aggressive'] = 0.005725
    }
    
    local interp = base_values[mode] or base_values['Minimum']
    local prediction_strength = ui.get(ui_elements.prediction_strength) / 100
    
    if mode == "Aggressive" then
        interp = interp * 0.55
        if speed > 150 then
            interp = interp * 0.70
        end
        if contains(ui.get(ui_elements.aggressive_options), "Quick Shot") then
            interp = interp * 0.75
        end
        if is_crouching then
            interp = interp * 0.80
        end
    end
    
    if mode == "Adaptive" or mode == "Dynamic" then
        if speed > ui.get(ui_elements.min_speed) then
            local speed_factor = math.min(speed / 250, 1) * prediction_strength
            interp = interp * (1 + speed_factor * 0.4)
        end
        
        if ping > 0 then
            local ping_factor = math.min(ping / ui.get(ui_elements.max_ping), 1) * prediction_strength
            interp = interp * (1 + ping_factor * 0.25)
        end
    end
    
    if is_crouching then
        local crouch_factor = ui.get(ui_elements.crouch_predict) / 100
        interp = interp * (1 + crouch_factor * prediction_strength * 0.8)
    end
    
    return math.min(math.max(interp, 0.005725), 0.1)
end

local function enhanced_prediction(cmd)
    if not ui.get(ui_elements.enable) then
        cvar.cl_interp:set_float(original_values.interp)
        cvar.cl_interp_ratio:set_int(original_values.interp_ratio)
        cvar.cl_interpolate:set_int(original_values.interpolate)
        return nil
    end

    local selected_mode = ui.get(ui_elements.mode)
    local target = client.current_threat()
    
    if not target or not entity.is_alive(target) then return nil end

    local velocity = {
        x = entity.get_prop(target, "m_vecVelocity[0]") or 0,
        y = entity.get_prop(target, "m_vecVelocity[1]") or 0,
        z = entity.get_prop(target, "m_vecVelocity[2]") or 0
    }
    
    local speed = math.sqrt(velocity.x * velocity.x + velocity.y * velocity.y)
    local is_crouching = bit.band(entity.get_prop(target, "m_fFlags") or 0, 4) == 4
    local ping = client.latency() * 1000
    
    local movement_data = {
        speed = speed,
        is_crouching = is_crouching,
        velocity = velocity
    }
    
    if selected_mode == "Aggressive" and cmd then
        local aggressive_options = ui.get(ui_elements.aggressive_options)
        local reaction_time = ui.get(ui_elements.reaction_time) / 1000
        
        if contains(aggressive_options, "Early Prediction") then
            local x, y, z = entity.get_prop(target, "m_vecOrigin")
            if x and y and z then
                local predicted_pos = {
                    x = x + velocity.x * reaction_time,
                    y = y + velocity.y * reaction_time,
                    z = z + velocity.z * reaction_time
                }
                return predicted_pos
            end
        end
    end
    
    local interp_value = calculate_advanced_interp(
        selected_mode,
        speed,
        ping,
        is_crouching,
        movement_data
    )
    
    cvar.cl_interp_ratio:set_int(2)
    cvar.cl_interpolate:set_int(1)
    cvar.cl_interp:set_float(interp_value)
    
    return {
        interp = interp_value,
        mode = selected_mode,
        target_speed = speed,
        ping = ping,
        is_crouching = is_crouching,
        movement_data = movement_data
    }
end

local function draw_indicator(prediction_data)
    if not ui.get(ui_elements.indicator) or not prediction_data then return end

    local screen_width, screen_height = client.screen_size()
    local x = screen_width / 2
    local y = screen_height - 100
    
    local style = ui.get(ui_elements.indicator_style)
    local r, g, b, a = 255, 255, 255, 255
    
    if prediction_data.mode == "Adaptive" then
        r, g, b = 0, 255, 0
    elseif prediction_data.mode == "Dynamic" then
        r, g, b = 0, 191, 255
    elseif prediction_data.mode == "Aggressive" then
        r, g, b = 255, 0, 0
    end
    
    if style == "Detailed" then
        renderer.text(x, y - 30, r, g, b, a, "c", 0, "Enhanced Prediction")
        renderer.text(x, y - 15, r, g, b, a, "c", 0, string.format("Mode: %s", prediction_data.mode))
        renderer.text(x, y, r, g, b, a, "c", 0, string.format("Interp: %.6f", prediction_data.interp))
        renderer.text(x, y + 15, r, g, b, a, "c", 0, string.format("Speed: %.1f | Ping: %dms", 
            prediction_data.target_speed, prediction_data.ping))
        if prediction_data.is_crouching then
            renderer.text(x, y + 30, 255, 165, 0, a, "c", 0, "DUCK")
        end
    elseif style == "Simple" then
        local status = prediction_data.is_crouching and " [DUCK]" or ""
        renderer.text(x, y, r, g, b, a, "c", 0, 
            string.format("PRED: %s (%.6f)%s", prediction_data.mode, prediction_data.interp, status))
    else
        renderer.text(x, y, r, g, b, a, "c", 0, string.format("PRED: %s", prediction_data.mode))
    end
end

client.set_event_callback("setup_command", function(cmd)
    handle_anti_defensive(cmd)
    local prediction_data = enhanced_prediction(cmd)
    if prediction_data then
        client.fire_event("prediction_update", prediction_data)
    end
end)

client.set_event_callback("paint", function()
    if not ui.get(ui_elements.enable) then return end
    local prediction_data = enhanced_prediction()
    if prediction_data then
        draw_indicator(prediction_data)
        draw_defensive_indicator()
    end
end)

client.set_event_callback("weapon_fire", apply_weapon_config)
client.set_event_callback("item_equip", apply_weapon_config)

client.set_event_callback("shutdown", function()
    cvar.cl_interp:set_float(original_values.interp)
    cvar.cl_interp_ratio:set_int(original_values.interp_ratio)
    cvar.cl_interpolate:set_int(original_values.interpolate)
end)

local function handle_menu_visibility()
    local enabled = ui.get(ui_elements.enable)
    local mode = ui.get(ui_elements.mode)
    
    ui.set_visible(ui_elements.mode, enabled)
    ui.set_visible(ui_elements.indicator, enabled)
    ui.set_visible(ui_elements.adaptive_options, enabled and (mode == "Adaptive" or mode == "Dynamic"))
    ui.set_visible(ui_elements.min_speed, enabled and (mode == "Adaptive" or mode == "Dynamic"))
    ui.set_visible(ui_elements.max_ping, enabled and (mode == "Adaptive" or mode == "Dynamic"))
    ui.set_visible(ui_elements.crouch_predict, enabled)
    ui.set_visible(ui_elements.prediction_strength, enabled)
    ui.set_visible(ui_elements.indicator_style, enabled and ui.get(ui_elements.indicator))
    ui.set_visible(ui_elements.reaction_time, enabled and mode == "Aggressive")
    ui.set_visible(ui_elements.prefire, enabled and mode == "Aggressive")
    ui.set_visible(ui_elements.aggressive_options, enabled and mode == "Aggressive")
    ui.set_visible(ui_elements.configs, enabled)
    ui.set_visible(ui_elements.load_config, enabled)
    ui.set_visible(ui_elements.anti_defensive, enabled)
    ui.set_visible(ui_elements.anti_defensive_options, enabled and ui.get(ui_elements.anti_defensive))
    ui.set_visible(ui_elements.defensive_strength, enabled and ui.get(ui_elements.anti_defensive))
    ui.set_visible(ui_elements.defensive_indicator, enabled and ui.get(ui_elements.anti_defensive))
end

ui.set_callback(ui_elements.enable, handle_menu_visibility)
ui.set_callback(ui_elements.mode, handle_menu_visibility)
ui.set_callback(ui_elements.indicator, handle_menu_visibility)
ui.set_callback(ui_elements.anti_defensive, handle_menu_visibility)
handle_menu_visibility()