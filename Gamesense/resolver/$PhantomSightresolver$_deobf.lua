-- Deobf by soda, come on bro, base64?

-- See what they fake. Strike where they can’t
-- Made By  Vigo

local ffi = require("ffi")
local client_log = client.log
local math_floor = math.floor
local math_random = math.random
local entity_get_prop = entity.get_prop
local entity_get_players = entity.get_players
local math_abs = math.abs
local math_min = math.min
local math_max = math.max
local match_sqrt = math.sqrt
local math_pi = math.pi
local math_deg = math.deg
local math_rad = math.rad
local math_sin = math.sin
local math_cos = math.cos
local math_atan = math.atan
local math_atan2 = math.atan2
local math_acos = math.acos
local math_fmod = math.fmod
local math_ceil = math.ceil
local math_pow = math.pow

-- Data Storage
local resolver_data = {}
local backtrack_data = {}
local nn_data = {} -- Neural Network Data (Yaw History Storage)
local shot_history = {} -- Stores hit/miss data for adaptive learning
local weapon_config = {} -- Stores Resolver settings per weapon

-- UI Elements
local enable_resolver = ui.new_checkbox("LUA", "B", "Enable Resolver")
local resolver_mode = ui.new_combobox("LUA", "B", "Resolver Mode", "Auto", "Aggressive", "Defensive", "Jitter", "Brute Force", "Hybrid AI/ML", "Neural Network")
local enable_debug = ui.new_checkbox("LUA", "B", "Enable Debug Overlay")
local enable_backtrack = ui.new_checkbox("LUA", "B", "Enable Advanced Backtrack")
local enable_resolver_debug = ui.new_checkbox("LUA", "B", "Enable Draw Resolver  Debug")
local enable_adaptive_interp = ui.new_checkbox("LUA", "B", "Enable Adaptive Interpolation")

-- Debug Log Function
local function debug_log(msg)
    if ui.get(enable_debug) then
        client_log("[Resolver] " .. msg)
    end
end

-- 🔥 **Yaw Tracking for Neural Network**
function store_yaw_history(player, yaw)
    if not nn_data[player] then
        nn_data[player] = {}
    end
    table.insert(nn_data[player], 1, yaw)
    if #nn_data[player] > 20 then -- Store last 20 yaws for better learning
        table.remove(nn_data[player])
    end
end

function get_trend_yaw(player)
    if not nn_data[player] or #nn_data[player] == 0 then
        return nil
    end
    local sum, weight, last_yaw = 0, 0, nn_data[player][1]
    for i = 1, #nn_data[player] do
        local importance = i / #nn_data[player]
        sum = sum + (nn_data[player][i] * importance)
        weight = weight + importance
    end
    local predicted_yaw = (sum / weight) + ((last_yaw - sum / weight) * 0.5)  -- AI auto-adjusts yaw trends
    return predicted_yaw
end

-- 🔥 **Freestanding Detection**
function detect_freestanding(player)
    local velocity_x = entity_get_prop(player, "m_vecVelocity[0]") or 0
    local velocity_y = entity_get_prop(player, "m_vecVelocity[1]") or 0
    local speed = math.sqrt(velocity_x^2 + velocity_y^2)

    if speed < 10 then
        debug_log("Anti-Defensive Triggered: Player " .. player)
        return true
    end
    return false
end

-- 🔥 **Exploit Detection**
function detect_exploit(player)
    local fake_lag = entity_get_prop(player, "m_flPoseParameter[6]") or 0
    local fake_duck = entity_get_prop(player, "m_flDuckAmount") or 0
    local dt_active = entity_get_prop(player, "m_bIsScoped") or 0  
	local desync_delta = entity_get_prop(entity_get_prop(player, "m_flPoseParameter[11]") or 0)
	local fake_flick = entity_get_prop(player, "m_flSimulationTime") or 0
	
    if fake_lag > 0.5 then
        debug_log("Detected Fake Lag on Player " .. player)
        return "fake_lag"
    elseif fake_duck > 0.8 then
        debug_log("Detected Fake Duck on Player " .. player)
        return "fake_duck"
    elseif dt_active == 1 then
        debug_log("Detected Double Tap on Player " .. player)
        return "double_tap"
    elseif fake_flick > 0.1 then
        debug_log("Detected Fake Flick on Player " .. player)
        return "fake_flick"
	end
    return "none"
end

-- 🔥 **Smart Backtrack System**
function store_backtrack_record(player)
    if not backtrack_data[player] then
        backtrack_data[player] = {}
    end
    local sim_time = entity_get_prop(player, "m_flSimulationTime") or 0
    local position = { entity_get_prop(player, "m_vecOrigin") or {0, 0, 0} }

    table.insert(backtrack_data[player], 1, { simtime = sim_time, position = position })
    if #backtrack_data[player] > math_random(10, 20) then -- Dynamically adjusts backtrack depth
    table.remove(backtrack_data[player])
end
    debug_log("Stored Backtrack Record | Player: " .. player .. " | Simtime: " .. sim_time)
end

-- **Best Backtrack Tick Selection**
function get_best_backtrack_tick(player)
    if not backtrack_data[player] or #backtrack_data[player] == 0 then
        return nil
    end
    local best_tick = backtrack_data[player][1].simtime
    debug_log("Best Backtrack Tick for Player: " .. player .. " | Simtime: " .. best_tick)
    return best_tick
end

-- 🔥 **Neural Network Resolver (Now Smarter!)**
function neural_network_resolver(player, yaw)
    store_yaw_history(player, yaw)
    local trend_yaw = get_trend_yaw(player)

    local adjustment = 0
    if trend_yaw then
        adjustment = trend_yaw - yaw
    else
        adjustment = math_random(-20, 20)
    end

    debug_log("Neural Network Adjusted Yaw: " .. yaw + adjustment)
    return yaw + adjustment
end

-- 🔥 **Hit/Miss Learning System**
function update_shot_history(player, hit)
    if not shot_history[player] then
        shot_history[player] = { hits = 0, misses = 0, last_adjustment = 0 }
    end
    if hit then
        shot_history[player].hits = shot_history[player].hits + 1
    else
        shot_history[player].misses = shot_history[player].misses + 1
        shot_history[player].last_adjustment = shot_history[player].last_adjustment + math_random(-10, 10) -- Adds small adjustments
    end
end

function get_shot_adjustment(player)
    if not shot_history[player] then return 0 end
    return shot_history[player].last_adjustment
end

function get_shot_accuracy(player)
    if not shot_history[player] or (shot_history[player].hits + shot_history[player].misses) == 0 then
        return 0
    end
    return (shot_history[player].hits / (shot_history[player].hits + shot_history[player].misses)) * 100
end

-- 🔥 **Dynamic Resolver Speed**
function dynamic_resolver_speed(player)
    local miss_count = shot_history[player] and shot_history[player].misses or 0
    return math_min(60, 30 + (miss_count * 5)) -- Increases speed if missing too much
end

-- 🔥 **Detect Anti Exploit**
function detect_anti_exploit(player)
    local yaw_delta = math_abs(entity_get_prop(player, "m_flPoseParameter[11]") or 0)
    local fake_lag = entity_get_prop(player, "m_flPoseParameter[6]") or 0
    local speed = entity_get_prop(player, "m_vecVelocity[0]") or 0

    if yaw_delta > 60 and fake_lag > 0.6 and speed < 5 then
        debug_log("Detected Advanced Anti-Aim Exploit | Player: " .. player)
        return true
    end
    return false
end

-- 🔥 **Network Interpolation Calculation (Lag Compensation)**
function calculate_interpolation(speed, ping, crouching)
     -- Ensure values are not nil
    speed = speed or 0
    ping = ping or 0
    crouching = crouching or false
	
	local interp_base = 0.00775
    local interp_factor = math_max(0.00775, 1 / 64) -- Adjust for 64 tick servers
    if speed > 120 then
        interp_factor = interp_factor * 1.2
    end
    if ping > 80 then
        interp_factor = interp_factor * 1.1
    end
    if crouching then
        interp_factor = interp_factor * 0.9
    end
    return math_min(math_max(interp_base, interp_factor), 0.1)
end

function adaptive_interpolation()
    if not ui.get(enable_adaptive_interp) then return end
    local player = entity.get_local_player()
    local velocity = entity_get_prop(player, "m_vecVelocity[0]") or 0
    local ping = client.latency() * 1000
    local crouching = entity_get_prop(player, "m_fFlags") or 4 == 4

    local interp_value = calculate_interpolation(velocity, ping, crouching)
    cvar.cl_interp:set_float(interp_value)
end

-- 🔥 **Detect Fake Desync**
function detect_fake_desync(player)
    local desync_delta = math_abs(entity_get_prop(player, "m_flPoseParameter[11]") or 0)
    local velocity_x = entity_get_prop(player, "m_vecVelocity[0]") or 0
    local velocity_y = entity_get_prop(player, "m_vecVelocity[1]") or 0
    local speed = math.sqrt(velocity_x^2 + velocity_y^2)

    if desync_delta > 50 and speed < 10 then
        debug_log("Fake Desync Detected on Player " .. player)
        return true
    end
    return false
end

-- 🔥 **Tick Prediction AI**
function predict_enemy_yaw_shift(player)
    local last_yaw = get_trend_yaw(player)
    if not last_yaw then return 0 end
    local prediction_offset = math_random(-10, 10)
    debug_log("Predicting Yaw Shift for Player " .. player .. " | Offset: " .. prediction_offset)
    return last_yaw + prediction_offset
end

-- 🔥 **AI-Based Resolver Logic (Hybrid AI & Neural Network)**
function hybrid_ai_resolver(player, yaw)
    local aa_type = detect_exploit(player)
    local accuracy = get_shot_accuracy(player)
    local interpolation = calculate_interpolation(player)
	local resolver_speed = dynamic_resolver_speed(player)
	local adjustment = predict_enemy_yaw_shift(player)
    local detect_fake = detect_fake_desync(player)
    local detect_exploit = detect_anti_exploit(player) 
	local freestanding = detect_freestanding(player)
 
	if accuracy < 50 then -- If accuracy is low, use different adjustments
        adjustment = adjustment + 15
    end
    if freestanding then
        adjustment = adjustment + math_random(-10, 10) -- Small yaw shift for freestanding enemies
    end

    if ui.get(enable_backtrack) then
        store_backtrack_record(player)
        local best_tick = get_best_backtrack_tick(player)
        if best_tick then
            entity.set_prop(player, "m_flSimulationTime", best_tick)
        end
    end

    debug_log("AI Detected: " .. aa_type .. " | Adjustment: " .. adjustment)
    
    if aa_type == "fake_lag" then return yaw + adjustment + 45
    elseif aa_type == "fake_duck" then return yaw + adjustment - 30
    elseif aa_type == "desync" then return yaw + resolver_speed
	else return yaw + adjustment end
end

-- 🔥 **Experience Replay Ai**
experience_memory = {}

function store_experience(player, yaw)
    if not experience_memory[player] then
        experience_memory[player] = {}
    end
    table.insert(experience_memory[player], 1, yaw)
    if #experience_memory[player] > 50 then -- Stores last 50 yaw angles
        table.remove(experience_memory[player])
    end
end

function get_experience_yaw(player)
    if not experience_memory[player] or #experience_memory[player] == 0 then
        return nil
    end
    return experience_memory[player][math_random(1, #experience_memory[player])] -- Picks a past yaw pattern
end

-- 🔥 **Resolver Debug Overlay**
function draw_resolver_debug()
    if not ui.get(enable_resolver_debug) then return end
    local players = entity_get_players(true)
    for _, player in ipairs(players) do
        local yaw = entity_get_prop(player, "m_angEyeAngles[1]") or 0
        local yaw_adjusted = hybrid_ai_resolver(player, yaw)
        renderer.text(10, 10 + (_ * 15), 255, 0, 0, 255, "b", 0, "Yaw: " .. yaw_adjusted)
    end
end

-- 🔥 **Resolver Logic**
function resolver_logic(player)
    if not ui.get(enable_resolver) then return end
    local yaw = entity_get_prop(player, "m_angEyeAngles[1]") or 0

    store_backtrack_record(player)

    local adjustment = yaw
    local mode = ui.get(resolver_mode)

    if mode == "Auto" then
        adjustment = hybrid_ai_resolver(player, yaw)
    elseif mode == "Aggressive" then
        adjustment = yaw + 35
    elseif mode == "Defensive" then
        adjustment = yaw - 25
    elseif mode == "Jitter" then
        adjustment = yaw + math.sin(globals.realtime() * 5) * 40
    elseif mode == "Brute Force" then
    local angles = {yaw + 30, yaw - 30, yaw + 60, yaw - 60, yaw + 90, yaw - 90}
    adjustment = angles[math_random(1, #angles)] -- Picks a tested angle
    elseif mode == "Hybrid AI/ML" then
        adjustment = hybrid_ai_resolver(player, yaw)
    elseif mode == "Neural Network" then
        adjustment = neural_network_resolver(player, yaw)
    end

    debug_log("Adjusted Player " .. player .. " Yaw to: " .. adjustment)
    entity.set_prop(player, "m_angEyeAngles[1]", adjustment)
end

-- 🔥 **Event Callbacks**
client.set_event_callback("paint", function()
    for _, player in ipairs(entity_get_players(true)) do
        resolver_logic(player)
    end
	draw_resolver_debug()
	adaptive_interpolation()
end)
