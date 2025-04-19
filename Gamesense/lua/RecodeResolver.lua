--[[

ReCoded by Ziwer & Soliaruty <3

]]

local ffi = require "ffi"

local resolver_tab = {
    enable = ui.new_checkbox("RAGE", "Other", "Advanced Resolver"),
    mode = ui.new_combobox("RAGE", "Other", "Resolver Strategy", {
        "Adaptive ML", 
        "Bruteforce", 
        "Extended Resolver", 
        "Velocity",
        "Ai Loggic"
    }),
    confidence = ui.new_slider("RAGE", "Other", "Resolver Confidence", 0, 100, 75, true, "%"),
    options = ui.new_multiselect("RAGE", "Other", "Resolver Features", {
        "Logic Correction", 
        "Angle Desync Randomization",
        "Anti-Bruteforce (dont bruteforce enemy)",
        "Extended Backtrack",
        "Bruteforce Loggic"
    }),
    debug_overlay = ui.new_checkbox("RAGE", "Other", "🐛 Debug Visualization")
}

local resolver_data = setmetatable({}, {__mode = "k"})

local math_utils = {
    normalize_angle = function(angle)
        return angle - math.floor(angle / 360 + 0.5) * 360
    end,
    
    calculate_angle_deviation = function(a1, a2)
        return math.abs(math_utils.normalize_angle(a1 - a2))
    end,
    
    weighted_average = function(values, weights)
        local total_value, total_weight = 0, 0
        for i, value in ipairs(values) do
            local weight = weights[i] or 1
            total_value = total_value + value * weight
            total_weight = total_weight + weight
        end
        return total_value / total_weight
    end
}

local motion_analyzer = {
    get_velocity_vector = function(player)
        local vx = entity.get_prop(player, "m_vecVelocity[0]") or 0
        local vy = entity.get_prop(player, "m_vecVelocity[1]") or 0
        return math.sqrt(vx * vx + vy * vy)
    end,
    
    analyze_movement_pattern = function(player)
        local data = resolver_data[player]
        if not data or #data.velocity_history < 5 then return 0 end
        
        local direction_changes = 0
        for i = 2, #data.velocity_history do
            if data.velocity_history[i] * data.velocity_history[i-1] < 0 then
                direction_changes = direction_changes + 1
            end
        end
        
        return direction_changes / #data.velocity_history
    end
}

local function init_player_data(player)
    if not resolver_data[player] then
        resolver_data[player] = {
            angle_history = {},
            velocity_history = {},
            desync_patterns = {},
            missed_shots = 0,
            hit_shots = 0,
            last_resolve_angle = 0,
            learning_rate = 0.1
        }
    end
end

local ml_resolver = {
    train = function(player, hit, angle)
        local data = resolver_data[player]
        if not data then return end
        
        if hit then
            data.hit_shots = data.hit_shots + 1
            table.insert(data.angle_history, angle)
        else
            data.missed_shots = data.missed_shots + 1
            data.learning_rate = data.learning_rate * 1.2  
        end
        
        if #data.angle_history > 10 then
            table.remove(data.angle_history, 1)
        end
    end,
    
    predict_angle = function(player)
        local data = resolver_data[player]
        if not data or #data.angle_history < 3 then return 0 end
        
        local weights = {}
        for i = 1, #data.angle_history do
            weights[i] = i  
        end
        
        return math_utils.weighted_average(data.angle_history, weights)
    end
}

local function advanced_resolver(player)
    init_player_data(player)
    local data = resolver_data[player]
    
    local pitch = entity.get_prop(player, "m_angEyeAngles[0]")
    local yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    
    if not pitch or not yaw then return end
    
    local mode = ui.get(resolver_tab.mode)
    local confidence = ui.get(resolver_tab.confidence) / 100
    local velocity = motion_analyzer.get_velocity_vector(player)
    
    local resolver_angle = 0
    
    if mode == "Adaptive ML" then
        resolver_angle = ml_resolver.predict_angle(player)
        
        if velocity > 10 then
            resolver_angle = resolver_angle * (1 + velocity / 100)
        end
    
    elseif mode == "Hybrid Bruteforce" then
        local stages = {0, 30, -30, 45, -45, 58, -58}
        local stage_index = (data.missed_shots % #stages) + 1
        resolver_angle = stages[stage_index]    
    elseif mode == "Positional Resolver" then
        local movement_pattern = motion_analyzer.analyze_movement_pattern(player)
        resolver_angle = movement_pattern * 45    
    elseif mode == "Velocity Analysis" then
        resolver_angle = velocity > 10 and (velocity > 100 and 45 or 30) or 0
    elseif mode == "Neural Pattern" then
        resolver_angle = data.last_resolve_angle * 1.2
    end
    
    if ui.get(resolver_tab.options, "Angle Randomization") then
        resolver_angle = resolver_angle + math.random(-10, 10)
    end
    
    if ui.get(resolver_tab.options, "Anti-Bruteforce") then
        resolver_angle = resolver_angle * (1 + data.missed_shots * 0.05)
    end   

    local final_angle = math_utils.normalize_angle(yaw + resolver_angle * confidence)
    entity.set_prop(player, "m_angEyeAngles[1]", final_angle)
    
    data.last_resolve_angle = resolver_angle
    table.insert(data.velocity_history, velocity)
    if #data.velocity_history > 10 then
        table.remove(data.velocity_history, 1)
    end
end

client.set_event_callback("aim_hit", function(e)
    ml_resolver.train(e.target, true, entity.get_prop(e.target, "m_angEyeAngles[1]"))
end)

client.set_event_callback("aim_miss", function(e)
    ml_resolver.train(e.target, false, entity.get_prop(e.target, "m_angEyeAngles[1]"))
end)

client.set_event_callback("setup_command", function(cmd)
    if not ui.get(resolver_tab.enable) then return end
    
    local players = entity.get_players(true)
    for i = 1, #players do
        advanced_resolver(players[i])
    end
end)

client.set_event_callback("paint", function()
    if not ui.get(resolver_tab.debug_overlay) then return end
    
    local x, y = 10, 500
    for player, data in pairs(resolver_data) do
        local name = entity.get_player_name(player)
        renderer.text(x, y, 255, 255, 255, 255, "", 0, 
            string.format("%s: Hits: %d, Misses: %d, Last Angle: %.2f", 
            name, data.hit_shots, data.missed_shots, data.last_resolve_angle))
        y = y + 15
    end
end)

local function handle_resolver_visibility()
    local is_enabled = ui.get(resolver_tab.enable)
    ui.set_visible(resolver_tab.mode, is_enabled)
    ui.set_visible(resolver_tab.confidence, is_enabled)
    ui.set_visible(resolver_tab.options, is_enabled)
    ui.set_visible(resolver_tab.debug_overlay, is_enabled)
end

ui.set_callback(resolver_tab.enable, handle_resolver_visibility)
handle_resolver_visibility()