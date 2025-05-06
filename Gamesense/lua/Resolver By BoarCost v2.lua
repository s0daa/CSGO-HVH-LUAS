-- Ultimate AI Evolution Resolver (All-in-One Evolutionary AI)
-- Combines Yaw Correction, Movement Prediction, Desync Counter, Double-Tap Sync, Missed Shot Correction, and Adaptation

local skull = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣤⣤⣤⣤⣀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀
]]

client.log("\a4" .. skull)
client.log("\a2[LOADED] Ultimate AI Evolution Resolver Initialized!")

-- UI Elements for Resolver Control
local resolver_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable AI Evolution Resolver")
local resolver_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Resolver Mode", "AI Evolution")

-- Double-Tap Control UI
local dt_enabled = ui.new_checkbox("Rage", "Other", "Enable Double-Tap")
local dt_delay = ui.new_slider("Rage", "Other", "Double-Tap Delay", 0, 20, 5, true, "ms")
local dt_multiplier = ui.new_slider("Rage", "Other", "Double-Tap Multiplier", 1, 10, 1, true)

-- Global Variables
local player_data = {}
local yaw_history = {}
local missed_shots = {}
local dt_last_shot_time = 0
local dt_shooting = false

-- Function to Normalize Angles (-180 to 180 degrees)
local function NormalizeAngle(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end

-- Function to Store Yaw History for Predictive Adjustments
local function store_yaw(player, yaw)
    if not yaw_history[player] then
        yaw_history[player] = {}
    end
    table.insert(yaw_history[player], yaw)
    if #yaw_history[player] > 20 then
        table.remove(yaw_history[player], 1)
    end
end

-- AI-Driven Yaw Correction Based on Evolutionary Prediction
local function predict_yaw(player)
    local velocity = entity.get_prop(player, "m_vecVelocity")
    local speed = math.sqrt(velocity[1]^2 + velocity[2]^2)
    local lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local eye_angles = entity.get_prop(player, "m_angEyeAngles")
    local predicted_yaw = eye_angles.y

    -- Basic prediction based on speed and movement
    if speed < 20 then
        -- Walking / Standing
        predicted_yaw = lby + 0
    elseif speed > 100 then
        -- Running / High Speed
        predicted_yaw = lby + 180
    else
        -- Moderate speed / Mix of movement
        predicted_yaw = lby + (speed > 50 and 90 or 45)
    end

    -- Fine-tune based on missed shots
    if missed_shots[player] and missed_shots[player] > 2 then
        predicted_yaw = predicted_yaw + (missed_shots[player] % 2 == 0 and 180 or 90)
    end

    -- Correct yaw based on history of previous shots
    if yaw_history[player] then
        local avg_yaw = 0
        for _, yaw in ipairs(yaw_history[player]) do
            avg_yaw = avg_yaw + yaw
        end
        avg_yaw = avg_yaw / #yaw_history[player]
        predicted_yaw = predicted_yaw + (predicted_yaw - avg_yaw > 10 and 180 or 0)
    end

    -- Normalize and return the predicted yaw
    predicted_yaw = NormalizeAngle(predicted_yaw)
    store_yaw(player, predicted_yaw)
    return predicted_yaw
end

-- AI Evolution Resolver Logic (Integrated AI Evolutionary System)
local function resolve_enemy(cmd, player)
    local mode = ui.get(resolver_mode)
    local flags = entity.get_prop(player, "m_fFlags")
    local velocity = entity.get_prop(player, "m_vecVelocity")
    local lby = entity.get_prop(player, "m_flLowerBodyYawTarget")
    local eye_angles = entity.get_prop(player, "m_angEyeAngles")
    local predicted_yaw = predict_yaw(player)
    local speed = math.sqrt(velocity[1]^2 + velocity[2]^2)

    -- AI Evolution-based dynamic adjustments
    if mode == "AI Evolution" then
        -- Evolving adjustments based on player movement, missed shots, and AI predictions
        if speed > 100 then
            predicted_yaw = lby + (missed_shots[player] > 3 and 180 or 90)
        elseif speed < 20 then
            predicted_yaw = lby + (missed_shots[player] > 2 and 45 or 0)
        else
            predicted_yaw = lby + (missed_shots[player] > 1 and 90 or 0)
        end
    end

    -- Apply the final yaw to the command
    cmd.yaw = predicted_yaw
end

-- Double-Tap Handling
local function double_tap_shot(cmd)
    if not ui.get(dt_enabled) then return end

    local current_time = globals.curtime()
    local delay = ui.get(dt_delay) / 1000
    local multiplier = ui.get(dt_multiplier)

    if current_time - dt_last_shot_time >= delay / multiplier then
        dt_shooting = true
    else
        dt_shooting = false
    end

    if dt_shooting then
        -- Execute delayed shot
        client.delay_call(0.01, function()
            client.exec("attack")
        end)
        dt_last_shot_time = globals.curtime()
    end
end

-- Track Missed Shots
local function on_shot_missed(event)
    local player = event:get_int("user")
    missed_shots[player] = (missed_shots[player] or 0) + 1
end

client.set_event_callback("shot_missed", on_shot_missed)

-- Main Resolver Execution During Command Setup
client.set_event_callback("setup_command", function(cmd)
    if not ui.get(resolver_enabled) then return end
    for _, player in pairs(entity.get_players(true)) do
        -- Resolve the enemy based on AI Evolution resolver
        resolve_enemy(cmd, player)
        double_tap_shot(cmd)
    end
end)

client.log("\a2[AI EVOLUTION RESOLVER] Initialized Successfully!")
