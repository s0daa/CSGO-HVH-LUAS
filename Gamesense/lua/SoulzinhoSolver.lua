-- Advanced Resolver Helper for GameSense.pub

-- Define resolver settings in the menu
local resolver_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Enhanced Resolver")
local resolver_debug = ui.new_checkbox("AA", "Anti-aimbot angles", "Enhanced Resolver Debug")
local resolver_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Enhanced Resolver Mode", "Standard", "Adaptive", "Experimental", "Advanced", "Predictive", "Complex", "Custom")
local resolver_iterations = ui.new_slider("AA", "Anti-aimbot angles", "Enhanced Resolver Iterations", 1, 10, 1, true, "", 1)
local resolver_backtrack = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Enhanced Backtracking")
local resolver_predictive = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Enhanced Predictive Adjustments")
local resolver_spin = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Spin Resolver")
local resolver_fakelag = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Fake Lag Resolver")
local resolver_desync = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Desync Resolver")
local resolver_delay = ui.new_slider("AA", "Anti-aimbot angles", "Resolver Delay (ms)", 0, 1000, 0, true, "ms", 1)
local resolver_complexity = ui.new_slider("AA", "Anti-aimbot angles", "Resolver Complexity", 1, 100, 50, true, "", 1)

-- Cached data for resolver logic
local cached_yaw = {}
local cached_lby = {}
local player_states = {}
local shot_history = {}
local desync_cache = {}
local last_resolved_time = {}

-- Utility functions
local function normalize_angle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

local function calculate_delta(angle1, angle2)
    if angle1 == nil or angle2 == nil then
        return 0
    end
    return math.abs(normalize_angle(angle1 - angle2))
end

local function get_max_desync_delta(player)
    return (entity.get_prop(player, "m_flPoseParameter", 11) * 58) + 0.5
end

local function update_player_state(player)
    if not player_states[player] then
        player_states[player] = { shots_fired = 0, hits = 0, misses = 0, desync_detected = false, last_yaw = nil }
    end
end

local function log_debug(message)
    if ui.get(resolver_debug) then
        client.log(message)
    end
end

local function log_resolver(player, mode, yaw)
    if ui.get(resolver_debug) then
        log_debug("Resolved Player: " .. player .. " Yaw: " .. yaw .. " Mode: " .. mode)
    end
end

local function get_random_factor()
    return math.random() * ui.get(resolver_complexity) / 100
end

-- Resolver logic
local function resolve_standard(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 35 then
        local new_yaw = normalize_angle(player_yaw + get_max_desync_delta(player))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Standard", player_yaw)
end

local function resolve_adaptive(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 35 then
        local max_desync = get_max_desync_delta(player)
        local new_yaw = normalize_angle(player_yaw + max_desync)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Adaptive", player_yaw)
end

local function resolve_experimental(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 35 then
        local max_desync = get_max_desync_delta(player)
        local iterations = ui.get(resolver_iterations)
        
        for i = 1, iterations do
            local new_yaw = normalize_angle(player_yaw + (i * (max_desync / iterations)))
            entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        end
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Experimental", player_yaw)
end

local function resolve_advanced(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 35 then
        local new_yaw = normalize_angle(player_yaw + max_desync * 0.75)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    elseif lby_delta > 35 then
        local new_yaw = normalize_angle(player_lby + max_desync * 0.75)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Advanced", player_yaw)
end

local function resolve_predictive(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    
    if yaw_delta > 35 then
        local predicted_yaw = normalize_angle(player_yaw + (yaw_delta / 2))
        entity.set_prop(player, "m_angEyeAngles[1]", predicted_yaw)
    elseif lby_delta > 35 then
        local predicted_yaw = normalize_angle(player_lby + (lby_delta / 2))
        entity.set_prop(player, "m_angEyeAngles[1]", predicted_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Predictive", player_yaw)
end

local function resolve_complex(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    local random_factor = get_random_factor()
    
    if yaw_delta > 35 then
        local new_yaw = normalize_angle(player_yaw + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    elseif lby_delta > 35 then
        local new_yaw = normalize_angle(player_lby + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Complex", player_yaw)
end

-- Continued from previous script...

-- Custom Resolver
local function resolve_custom(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local max_desync = get_max_desync_delta(player)
    local yaw_delta = calculate_delta(player_yaw, cached_yaw[player])
    local lby_delta = calculate_delta(player_lby, cached_lby[player])
    local random_factor = get_random_factor()
    
    if yaw_delta > 35 then
        local new_yaw = normalize_angle(player_yaw + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    elseif lby_delta > 35 then
        local new_yaw = normalize_angle(player_lby + max_desync * random_factor)
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        local new_yaw = normalize_angle(player_yaw + (max_desync * random_factor / 2))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    end
    
    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Custom", player_yaw)
end

-- Main resolver function
local function resolver(player)
    local resolver_type = ui.get(resolver_mode)
    
    if resolver_type == "Standard" then
        resolve_standard(player)
    elseif resolver_type == "Adaptive" then
        resolve_adaptive(player)
    elseif resolver_type == "Experimental" then
        resolve_experimental(player)
    elseif resolver_type == "Advanced" then
        resolve_advanced(player)
    elseif resolver_type == "Predictive" then
        resolve_predictive(player)
    elseif resolver_type == "Complex" then
        resolve_complex(player)
    elseif resolver_type == "Custom" then
        resolve_custom(player)
    end
end

local backtrack_cache = {}

-- Backtrack Resolver
local function backtrack_enemy(player)
    if not backtrack_cache[player] then
        backtrack_cache[player] = {}
    end

    -- Add the current simulation time to the backtrack cache
    table.insert(backtrack_cache[player], entity.get_prop(player, "m_flSimulationTime"))

    -- Limit the size of the cache (for example, keep the last 5 records)
    if #backtrack_cache[player] > 5 then
        table.remove(backtrack_cache[player], 1)
    end

    -- Implement your backtracking logic here
    local last_record = backtrack_cache[player][#backtrack_cache[player]]
    if last_record then
        entity.set_prop(player, "m_flSimulationTime", last_record)
    end
end

-- Predictive Resolver
local function predictive_resolver(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local velocity = { entity.get_prop(player, "m_vecVelocity[0]"), entity.get_prop(player, "m_vecVelocity[1]") }
    local velocity_length = math.sqrt(velocity[1]^2 + velocity[2]^2)
    
    if velocity_length > 0.1 then
        local new_yaw = normalize_angle(player_yaw + (velocity_length / 10))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end
end

-- Spin Resolver
local function spin_resolver(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local spin_angle = (globals.tickcount() % 360)
    local new_yaw = normalize_angle(player_yaw + spin_angle)
    entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
end

-- Fake Lag Resolver
local function fakelag_resolver(player)
    local player_velocity = { entity.get_prop(player, "m_vecVelocity[0]"), entity.get_prop(player, "m_vecVelocity[1]") }
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local velocity_length = math.sqrt(player_velocity[1]^2 + player_velocity[2]^2)
    
    if velocity_length < 5 then
        local new_yaw = normalize_angle(player_yaw + get_max_desync_delta(player))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    end
end

-- Desync Resolver
local function desync_resolver(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local desync_delta = get_max_desync_delta(player)
    
    if desync_cache[player] then
        local previous_desync = desync_cache[player]
        local desync_change = math.abs(desync_delta - previous_desync)
        
        if desync_change > 10 then
            local new_yaw = normalize_angle(player_yaw + desync_change)
            entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
        end
    end
    
    desync_cache[player] = desync_delta
end

-- Advanced Anti-Aim Handling
local function resolve_advanced_aim(player)
    local player_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local player_lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    
    local max_desync = get_max_desync_delta(player)
    local random_factor = get_random_factor()

    if calculate_delta(player_yaw, player_lby) > 35 then
        local new_yaw = normalize_angle(player_yaw + (max_desync * random_factor))
        entity.set_prop(player, "m_angEyeAngles[1]", new_yaw)
    else
        entity.set_prop(player, "m_angEyeAngles[1]", player_lby)
    end

    cached_yaw[player] = player_yaw
    cached_lby[player] = player_lby

    log_resolver(player, "Advanced Aim", player_yaw)
end

-- Event to trigger advanced anti-aim handling
client.set_event_callback("paint", function()
    if ui.get(resolver_enabled) then
        local players = entity.get_players(true)
        for i = 1, #players do
            local player = players[i]
            resolver(player)
            resolve_advanced_aim(player) -- Call the advanced aim resolver
            if ui.get(resolver_backtrack) then
                backtrack_enemy(player)
            end
            if ui.get(resolver_predictive) then
                predictive_resolver(player)
            end
            if ui.get(resolver_spin) then
                spin_resolver(player)
            end
            if ui.get(resolver_fakelag) then
                fakelag_resolver(player)
            end
            if ui.get(resolver_desync) then
                desync_resolver(player)
            end
        end
    end
end)

-- Log initialization
client.log("Advanced Anti-Aim and Lag Compensation Resolver initialized.")
client.log("Enhanced Resolver script running.")

-- Additional features and debugging

-- Function to track shots fired, hits, and misses
local function track_shots(player, event_type)
    if not player_states[player] then
        update_player_state(player)
    end

    if event_type == "fire" then
        player_states[player].shots_fired = player_states[player].shots_fired + 1
        log_debug("Shot fired by player: " .. player .. " Total shots: " .. player_states[player].shots_fired)
    elseif event_type == "hit" then
        player_states[player].hits = player_states[player].hits + 1
        log_debug("Shot hit by player: " .. player .. " Total hits: " .. player_states[player].hits)
    elseif event_type == "miss" then
        player_states[player].misses = player_states[player].misses + 1
        log_debug("Shot missed by player: " .. player .. " Total misses: " .. player_states[player].misses)
    end
end

-- Event callbacks for tracking shots, hits, and misses
client.set_event_callback("weapon_fire", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "fire")
    end
end)

client.set_event_callback("player_hurt", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "hit")
    end
end)

client.set_event_callback("player_death", function(event)
    local player = client.userid_to_entindex(event.userid)
    if player then
        track_shots(player, "miss")
    end
end)

-- UI Enhancements (Optional)
-- Here you can add more advanced UI elements or features as needed for customization.

-- End of script
