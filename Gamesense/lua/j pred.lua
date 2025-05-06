
local vector = require("vector")


local HISTORY_SIZE = 64 -- Number of ticks to keep in history
local PATTERN_SIZE = 8 -- Max pattern size to detect
local PREDICTION_STRENGTH = 0.85 -- How much to rely on prediction vs current angle
local UPDATE_FREQUENCY = 1 -- Update prediction every X ticks


local ui_enabled = ui.new_checkbox("RAGE", "Other", "Enable jitter prediction")
local ui_prediction_strength = ui.new_slider("RAGE", "Other", "Prediction strength", 0, 100, 85, true, "%")
local ui_visualization = ui.new_checkbox("RAGE", "Other", "Visualize prediction")
local ui_debug = ui.new_checkbox("RAGE", "Other", "Debug prediction")
local ui_min_samples = ui.new_slider("RAGE", "Other", "Min samples required", 8, 64, 16, true)
local ui_history_time = ui.new_slider("RAGE", "Other", "History time (s)", 1, 5, 2, true, "s")


local player_data = {}

local function get_eye_position(ent)
    local x, y, z = entity.get_prop(ent, "m_vecOrigin")
    local view_offset = entity.get_prop(ent, "m_vecViewOffset[2]")
    return vector(x, y, z + view_offset)
end

local function get_player_angles(player)
    local pitch, yaw = entity.get_prop(player, "m_angEyeAngles")
    return { pitch = pitch, yaw = yaw }
end

local function get_rotation_data(player)
    if player_data[player] == nil then
        player_data[player] = {
            angles_history = {},
            predicted_angle = nil,
            last_prediction_time = 0,
            pattern_detected = false,
            pattern = {},
            pattern_confidence = 0,
            update_tick = 0,
        }
    end
    
    return player_data[player]
end

local function normalize_angle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

local function calculate_delta(old_angle, new_angle)
    local delta = normalize_angle(new_angle - old_angle)
    return delta
end

local function detect_pattern(deltas)
    if #deltas < ui.get(ui_min_samples) then
        return nil, 0
    end
    
    local best_pattern = nil
    local best_confidence = 0
    

    for pattern_size = 2, math.min(PATTERN_SIZE, math.floor(#deltas / 2)) do

        for start = 1, pattern_size do
            local pattern = {}
            for i = start, start + pattern_size - 1 do
                table.insert(pattern, deltas[(i - 1) % #deltas + 1])
            end
            

            local matches = 0
            local total = 0
            
            for i = 1, #deltas - pattern_size do
                local match = true
                for j = 1, pattern_size do
                    if math.abs(deltas[i + j - 1] - pattern[j]) > 5 then
                        match = false
                        break
                    end
                end
                
                if match then
                    matches = matches + 1
                end
                total = total + 1
            end
            
            local confidence = matches / total
            if confidence > best_confidence then
                best_confidence = confidence
                best_pattern = pattern
            end
        end
    end
    

    if best_confidence < 0.4 then
        return nil, 0
    end
    
    return best_pattern, best_confidence
end

local function predict_next_angle(player)
    local data = get_rotation_data(player)
    local angles_history = data.angles_history
    
    if #angles_history < 2 then
        return nil
    end
    

    local deltas = {}
    for i = 2, #angles_history do
        local delta = calculate_delta(angles_history[i-1].yaw, angles_history[i].yaw)
        table.insert(deltas, delta)
    end
    
 
    local pattern, confidence = detect_pattern(deltas)
    
    data.pattern_detected = pattern ~= nil
    data.pattern = pattern
    data.pattern_confidence = confidence
    

    if pattern and confidence > 0.5 then

        local last_angle = angles_history[#angles_history].yaw
        

        local pattern_pos = #deltas % #pattern + 1
        local next_delta = pattern[pattern_pos]
        local predicted_yaw = normalize_angle(last_angle + next_delta)
        

        local prediction_strength = ui.get(ui_prediction_strength) / 100
        local mixed_yaw = last_angle * (1 - prediction_strength * confidence) + 
                          predicted_yaw * (prediction_strength * confidence)
        
        data.predicted_angle = normalize_angle(mixed_yaw)
        return data.predicted_angle
    end
    

    data.predicted_angle = angles_history[#angles_history].yaw
    return data.predicted_angle
end

local function draw_prediction_info(player, data)
    if not ui.get(ui_visualization) then
        return
    end
    

    local x, y, z = entity.get_origin(player)
    if x == nil then return end
    
    local wx, wy = renderer.world_to_screen(x, y, z + 75)
    if wx == nil then return end
    

    local last_angle = data.angles_history[#data.angles_history].yaw
    local text_color = {255, 255, 255, 255}
    
    if data.pattern_detected then
        text_color = {0, 255, 0, 255}
    end
    
    local r, g, b, a = unpack(text_color)
    
    renderer.text(wx, wy, r, g, b, a, "c", 0, string.format("Pred: %.1f°", data.predicted_angle or 0))
    
    if ui.get(ui_debug) then
        renderer.text(wx, wy + 12, r, g, b, a, "c", 0, 
            string.format("Current: %.1f° | Conf: %.0f%%", 
            last_angle or 0, 
            (data.pattern_confidence or 0) * 100))
        

        if data.pattern_detected and data.pattern then
            local pattern_str = "Pattern: "
            for i, delta in ipairs(data.pattern) do
                pattern_str = pattern_str .. string.format("%.1f ", delta)
            end
            renderer.text(wx, wy + 24, r, g, b, a, "c", 0, pattern_str)
        end
    end
end


local function on_ragebot_fire(e)
    if not ui.get(ui_enabled) then
        return
    end
    
    local target = e.target
    if not entity.is_enemy(target) then
        return
    end
    
    local data = get_rotation_data(target)
    if data.predicted_angle then
  
        e.target_yaw = data.predicted_angle
    end
end


local function on_net_update()
    if not ui.get(ui_enabled) then
        return
    end
    
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    
    local players = entity.get_players(true)
    local current_tick = globals.tickcount()
    

    for player_idx in pairs(player_data) do
        if not entity.is_alive(player_idx) then
            player_data[player_idx] = nil
        end
    end
    

    local max_history_size = math.ceil(ui.get(ui_history_time) * (1 / globals.tickinterval()))
    
    for _, player in ipairs(players) do
        if entity.is_alive(player) and entity.is_enemy(player) then
            local data = get_rotation_data(player)
            
            -- Only update on certain ticks for performance
            if current_tick % UPDATE_FREQUENCY == 0 then
                local angles = get_player_angles(player)
                

                table.insert(data.angles_history, angles)
                

                while #data.angles_history > max_history_size do
                    table.remove(data.angles_history, 1)
                end
                

                predict_next_angle(player)
                data.last_prediction_time = globals.realtime()
            end
        end
    end
end

local function on_paint()
    if not ui.get(ui_enabled) or not ui.get(ui_visualization) then
        return
    end
    
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then
        return
    end
    
    local players = entity.get_players(true)
    for _, player in ipairs(players) do
        if entity.is_alive(player) and entity.is_enemy(player) and player_data[player] then
            local data = player_data[player]
            if data.angles_history and #data.angles_history > 0 then
                draw_prediction_info(player, data)
            end
        end
    end
end

client.set_event_callback("paint", on_paint)
client.set_event_callback("net_update_end", on_net_update)
client.set_event_callback("aim_fire", on_ragebot_fire)

-- Print info on load
client.log("Jitter Prediction loaded successfully")
print("Jitter Prediction loaded successfully. Configure options in RAGE > Other.")