-- Import clipboard library from GameSense
local clipboard = require("gamesense/clipboard")
local ffi = require("ffi")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local vector = require("vector")

-- Basic vector library
local vector = {}
vector.__index = vector

function vector.new(x, y, z)
    return setmetatable({x = x or 0, y = y or 0, z = z or 0}, vector)
end

function vector.distance(x1, y1, z1, x2, y2, z2)
    if not x1 or not y1 or not z1 or not x2 or not y2 then
        return math.huge -- Return a large number if any coordinate is nil
    end
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

-- Logging levels 📊
local LOG_LEVELS = {INFO = 1, DEBUG = 2, ERROR = 3}
local current_log_level = LOG_LEVELS.INFO

local function log(level, message)
    if level >= current_log_level then
        client.color_log(0, 255, 0, message)
    end
end

-- Enhanced Data Structures 📊
local body_yaw_data = {}
local missed_shots_data = setmetatable({}, { __mode = 'k' })
local yaw_history = {}
local velocity_history = {}
local stance_history = {}
local weapon_history = {}
local shot_time_history = {}
local health_history = {}
local armor_history = {}
local distance_history = {}
local view_angle_history = {}
local shot_accuracy_history = {}
local engagement_distance_history = {}
local crouch_history = {}
local jump_history = {}
local scope_history = {}
local MAX_HISTORY_SIZE = 100 -- Increased history size for more data points

-- Pre-trained Neural Network Weights and Biases
local pre_trained_weights = {
    -- Add pre-trained weights here, e.g.:
    -- { {0.1, -0.2, 0.3}, {0.4, 0.5, -0.6}, ... },
}
local pre_trained_biases = {
    -- Add pre-trained biases here, e.g.:
    -- {0.1, -0.2, 0.3, ... },
}

-- Saves and Loads Neural Network
local function save_neural_network()
    database.write("nn_weights", weights)
    database.write("nn_biases", biases)
    log(LOG_LEVELS.INFO, "Neural network state saved.")
end

local function load_neural_network()
    weights = database.read("nn_weights") or weights
    biases = database.read("nn_biases") or biases
    log(LOG_LEVELS.INFO, "Neural network state loaded.")
end

local function load_pretrained_neural_network()
    weights = pre_trained_weights -- Replace with your pre-trained weights
    biases = pre_trained_biases -- Replace with your pre-trained biases
    log(LOG_LEVELS.INFO, "Pre-trained neural network state loaded.")
end

-- Serialize and Deserialize Utility Functions
local function table_to_string(tbl)
    return json.encode(tbl)
end

local function string_to_table(str)
    return json.decode(str)
end

-- Ensure all UI elements are correctly initialized
local enable_resolver = ui.new_checkbox("RAGE", "Other", "Enable Advanced Resolver")
log(LOG_LEVELS.INFO, "Initialized resolver settings")
local resolver_mode = ui.new_combobox("LUA", "B", "Resolver Mode", "Weighted Average", "Median", "Neural Network", "Jitter Resolver", "Defensive Resolver", "Aggressive", "Predictive", "Smart Hybrid")
local decay_factor_slider = ui.new_slider("LUA", "B", "Decay Factor", 0, 100, 70)
local hit_probability_factor_slider = ui.new_slider("LUA", "B", "Hit Probability Factor", 0, 100, 50)
local epochs_slider = ui.new_slider("LUA", "B", "Epochs", 1, 1000, 500)
local avoid_miss_adjustment_slider = ui.new_slider("LUA", "B", "Avoid Miss Adjustment", 0, 100, 15)
local default_yaw_adjustment_slider = ui.new_slider("LUA", "B", "Default Yaw Adjustment", -180, 180, 0)
local hitbox_selection = ui.new_combobox("LUA", "B", "Hitbox Selection", "Head", "Neck", "Chest", "Stomach")
local dropout_rate_slider = ui.new_slider("LUA", "B", "Dropout Rate", 0, 100, 50)

local function safe_get(ui_item, item_name)
    if ui_item == nil then
        log(LOG_LEVELS.ERROR, "Error: UI item is nil for: " .. tostring(item_name))
        return 0 -- Return a default value if the UI item is nil
    end

    local status, value = pcall(ui.get, ui_item)
    if not status then
        log(LOG_LEVELS.ERROR, "Error: Failed to get value for UI item: " .. tostring(item_name) .. ", error: " .. tostring(value))
        return 0 -- Return a default value if the value is nil or an error occurred
    end
    return value
end

-- Export and Import Configurations
local function export_config()
    local config = {
        decay_factor = safe_get(decay_factor_slider, "decay_factor_slider"),
        hit_probability_factor = safe_get(hit_probability_factor_slider, "hit_probability_factor_slider"),
        epochs = safe_get(epochs_slider, "epochs_slider"),
        avoid_miss_adjustment = safe_get(avoid_miss_adjustment_slider, "avoid_miss_adjustment_slider"),
        default_yaw_adjustment = safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider"),
        dropout_rate = safe_get(dropout_rate_slider, "dropout_rate_slider"),
        preset = safe_get(preset_dropdown, "preset_dropdown")
    }
    local config_string = table_to_string(config)
    clipboard.set(config_string)
    client.exec("echo Configuration exported to clipboard.")
    log(LOG_LEVELS.INFO, "Configuration exported to clipboard.")
end

local function import_config()
    local config_string = clipboard.get()
    local config = string_to_table(config_string)
    if config then
        ui.set(decay_factor_slider, config.decay_factor)
        ui.set(hit_probability_factor_slider, config.hit_probability_factor)
        ui.set(epochs_slider, config.epochs)
        ui.set(avoid_miss_adjustment_slider, config.avoid_miss_adjustment)
        ui.set(default_yaw_adjustment_slider, config.default_yaw_adjustment)
        ui.set(dropout_rate_slider, config.dropout_rate)
        ui.set(preset_dropdown, config.preset)
        log(LOG_LEVELS.INFO, "Configuration imported from clipboard.")
    else
        log(LOG_LEVELS.ERROR, "No valid configuration found to import.")
    end
end

local function export_nn_config()
    local nn_config = {
        weights = weights,
        biases = biases
    }
    local nn_config_string = table_to_string(nn_config)
    clipboard.set(nn_config_string)
    client.exec("echo Neural network configuration exported to clipboard.")
    log(LOG_LEVELS.INFO, "Neural network configuration exported to clipboard.")
end

local function import_nn_config()
    local nn_config_string = clipboard.get()
    local nn_config = string_to_table(nn_config_string)
    if nn_config then
        weights = nn_config.weights
        biases = nn_config.biases
        log(LOG_LEVELS.INFO, "Neural network configuration imported from clipboard.")
    else
        log(LOG_LEVELS.ERROR, "No valid neural network configuration found to import.")
    end
end

-- Buttons for saving and loading NN state
local save_nn_button = ui.new_button("LUA", "B", "Save NN", function()
    save_neural_network()
end)

local load_nn_button = ui.new_button("LUA", "B", "Load NN", function()
    load_neural_network()
end)

local pre_trained_nn_button = ui.new_button("LUA", "B", "Load Pre-trained NN", function()
    load_pretrained_neural_network()
end)

-- Buttons for exporting and importing configurations
local export_config_button = ui.new_button("LUA", "B", "Export Config", function()
    export_config()
end)

local import_config_button = ui.new_button("LUA", "B", "Import Config", function()
    import_config()
end)

local export_nn_config_button = ui.new_button("LUA", "B", "Export NN Config", function()
    export_nn_config()
end)

local import_nn_config_button = ui.new_button("LUA", "B", "Import NN Config", function()
    import_nn_config()
end)

-- Preset Dropdown
local preset_dropdown = ui.new_combobox("LUA", "B", "Preset Configuration", "General", "Aggressive", "Defensive", "Passive")

-- Preset Configurations
local preset_configurations = {
    General = {
        decay_factor = 70,
        hit_probability_factor = 50,
        epochs = 500,
        avoid_miss_adjustment = 15,
        default_yaw_adjustment = 0,
        dropout_rate = 50
    },
    Aggressive = {
        decay_factor = 90,
        hit_probability_factor = 70,
        epochs = 700,
        avoid_miss_adjustment = 10,
        default_yaw_adjustment = 0,
        dropout_rate = 60
    },
    Defensive = {
        decay_factor = 50,
        hit_probability_factor = 30,
        epochs = 300,
        avoid_miss_adjustment = 20,
        default_yaw_adjustment = 0,
        dropout_rate = 40
    },
    Passive = {
        decay_factor = 60,
        hit_probability_factor = 40,
        epochs = 400,
        avoid_miss_adjustment = 25,
        default_yaw_adjustment = 0,
        dropout_rate = 45
    }
}

-- Apply Preset Function
local function apply_preset(preset)
    local config = preset_configurations[preset]
    if config then
        ui.set(decay_factor_slider, config.decay_factor)
        ui.set(hit_probability_factor_slider, config.hit_probability_factor)
        ui.set(epochs_slider, config.epochs)
        ui.set(avoid_miss_adjustment_slider, config.avoid_miss_adjustment)
        ui.set(default_yaw_adjustment_slider, config.default_yaw_adjustment)
        ui.set(dropout_rate_slider, config.dropout_rate)
        log(LOG_LEVELS.INFO, "Applied " .. preset .. " preset configuration.")
    else
        log(LOG_LEVELS.ERROR, "Invalid preset: " .. tostring(preset))
    end
end

-- Callback to Apply Selected Preset
ui.set_callback(preset_dropdown, function()
    local selected_preset = ui.get(preset_dropdown)
    apply_preset(selected_preset)
end)

-- Adaptive Learning Rate for Neural Network
local function adaptive_learning_rate()
    local learning_rate = safe_get(decay_factor_slider, "decay_factor_slider") / 100
    return learning_rate
end

-- Neural Network Training Function
local function neural_network_train(player_index, epochs, batch_size, patience)
    local learning_rate = adaptive_learning_rate() -- Dynamic learning rate
    for epoch = 1, epochs do
        local batches = create_batches(yaw_history[player_index], batch_size)
        for _, batch in ipairs(batches) do
            local loss = train_on_batch(batch, learning_rate)
            if loss < best_loss then
                best_loss = loss
                patience_counter = 0
            else
                patience_counter = patience_counter + 1
                if patience_counter >= patience then
                    return
                end
            end
        end
    end
end

-- Neural Network Prediction Function
local function neural_network_prediction(player_index)
    local prediction, confidence = predict(player_index, weights, biases)
    return prediction, confidence
end

-- Enhanced Weighted Average Calculation
local function calculate_weighted_average_adjustment(player_index)
    local total_adjustment, total_weight, weight = 0, 0, 1
    local decay_factor = safe_get(decay_factor_slider, "decay_factor_slider") / 100
    local recent_hit_factor = 1.2

    if not yaw_history[player_index] then
        yaw_history[player_index] = {}
    end

    if #yaw_history[player_index] == 0 then
        return safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
    end

    for i = #yaw_history[player_index], 1, -1 do
        local adjustment = yaw_history[player_index][i]
        if hit_probability_history[player_index][i] > 0.7 then
            weight = weight * recent_hit_factor
        end
        total_adjustment = total_adjustment + adjustment * weight
        total_weight = total_weight + weight
        weight = weight * decay_factor
    end

    return total_weight > 0 and (total_adjustment / total_weight) or safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
end

-- Predict best yaw adjustment using median 🔍
local function predict_best_adjustment(player_index)
    local yaw_data = yaw_history[player_index]
    if not yaw_data or #yaw_data == 0 then
        return safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
    end

    table.sort(yaw_data)
    local median_index = math.floor(#yaw_data / 2)
    return yaw_data[median_index] or safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
end

-- Calculate hit probability 🎯
local function calculate_hit_probability(player_index)
    local hits, total = 0, #yaw_history[player_index] or 0
    for _, hist_yaw in ipairs(yaw_history[player_index] or {}) do
        if hist_yaw == body_yaw_data[player_index] then
            hits = hits + 1
        end
    end
    return total > 0 and (hits / total) or 0.5
end

-- Improved Avoid Previous Miss Adjustment
local function avoid_previous_miss(player_index, adjustment)
    local miss_data = missed_shots_data[player_index] or {}
    local avoid_miss_adjustment = safe_get(avoid_miss_adjustment_slider, "avoid_miss_adjustment_slider")
    local miss_threshold = 3

    for _, miss_yaw in ipairs(miss_data) do
        if math.abs(miss_yaw - adjustment) < miss_threshold then
            return adjustment + avoid_miss_adjustment
        end
    end
    return adjustment
end

-- Adaptive Adjustment Scaling 📏
local function adaptive_adjustment_scale(hit_probability)
    local hit_probability_factor = safe_get(hit_probability_factor_slider, "hit_probability_factor_slider")
    return 1 + (1 - hit_probability) * hit_probability_factor
end

-- Dynamic Adjustment Based on Player Behavior 🤖
local function dynamic_adjustment(player_index, adjustment)
    local recent_behavior = yaw_history[player_index]
    if not recent_behavior or #recent_behavior == 0 then
        return adjustment
    end

    local recent_movement = entity.get_prop(player_index, "m_vecVelocity[0]")
    if recent_movement and recent_movement > 100 then
        adjustment = adjustment * 1.1
    else
        adjustment = adjustment * 0.9
    end

    return adjustment
end

-- Enhanced Resolver Logic using GameSense Lua API 🚀
local function resolver_logic(player_index)
    if not entity.is_enemy(player_index) then
        return
    end

    local resolver_mode_value = ui.get(resolver_mode)
    local adjustment

    if resolver_mode_value == "Weighted Average" then
        local weighted_average_adjustment = calculate_weighted_average_adjustment(player_index)
        local hit_probability = calculate_hit_probability(player_index)
        local adjustment_scale = adaptive_adjustment_scale(hit_probability)
        adjustment = weighted_average_adjustment * adjustment_scale
    elseif resolver_mode_value == "Median" then
        adjustment = predict_best_adjustment(player_index)
    elseif resolver_mode_value == "Neural Network" then
        local epoch = safe_get(epochs_slider, "epochs_slider")
        local batch_size = 10
        local patience = 10
        neural_network_train(player_index, epoch, batch_size, patience) -- Train the neural network
        adjustment, confidence = neural_network_prediction(player_index) -- Predict using the neural network
        log(LOG_LEVELS.INFO, "NN Prediction Confidence: " .. tostring(confidence))
    elseif resolver_mode_value == "Jitter Resolver" then
        functions.resolve_jitter(player_index)
        log(LOG_LEVELS.INFO, "Jitter resolver used")
        return
    elseif resolver_mode_value == "Defensive Resolver" then
        adjustment = resolve_defensive_aa(player_index)
    elseif resolver_mode_value == "Aggressive" then
        adjustment = resolve_aggressive(player_index)
    elseif resolver_mode_value == "Predictive" then
        adjustment = resolve_predictive(player_index)
    elseif resolver_mode_value == "Smart Hybrid" then
        local hit_probability = calculate_hit_probability(player_index)
        local weighted_average_adjustment = calculate_weighted_average_adjustment(player_index)
        local adjustment_scale = adaptive_adjustment_scale(hit_probability)
        local nn_adjustment, confidence = neural_network_prediction(player_index)
        local jitter_adjustment = functions.resolve_jitter(player_index)
        local defensive_adjustment = resolve_defensive_aa(player_index)
        local aggressive_adjustment = resolve_aggressive(player_index)
        local predictive_adjustment = resolve_predictive(player_index)

        adjustment = (weighted_average_adjustment + nn_adjustment + (jitter_adjustment or 0) + defensive_adjustment + aggressive_adjustment + predictive_adjustment) / 6
        adjustment = adjustment * adjustment_scale
        log(LOG_LEVELS.INFO, "Smart Hybrid Resolver applied")
    end

    adjustment = avoid_previous_miss(player_index, adjustment)
    adjustment = dynamic_adjustment(player_index, adjustment)
    return adjustment
end

-- Enhanced Data Structures for Defensive Resolver
local enemy_defensive_data = {}

-- Function to collect enemy data
local function collect_enemy_data(player_index)
    local data = {
        yaw = entity.get_prop(player_index, "m_flPoseParameter[11]"),
        velocity = entity.get_prop(player_index, "m_vecVelocity[0]"),
        movement_type = entity.get_prop(player_index, "m_fFlags"),
        body_yaw = entity.get_prop(player_index, "m_flPoseParameter[11]"),
        timestamp = globals.curtime()
    }
    if not enemy_defensive_data[player_index] then
        enemy_defensive_data[player_index] = {}
    end
    table.insert(enemy_defensive_data[player_index], data)

    -- Maintain history size limit
    if #enemy_defensive_data[player_index] > MAX_HISTORY_SIZE then
        table.remove(enemy_defensive_data[player_index], 1)
    end
end

-- Predict enemy future anti-aim based on collected data
local function predict_future_aa(player_index)
    local data = enemy_defensive_data[player_index]
    if not data or #data == 0 then
        return safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
    end

    local total_weight = 0
    local future_yaw = 0
    local current_time = globals.curtime()

    for i = 1, #data do
        local entry = data[i]
        local time_diff = current_time - entry.timestamp

        -- Weight based on recency
        local weight = 1 / (1 + time_diff)
        total_weight = total_weight + weight

        -- Weighted sum of yaw values
        future_yaw = future_yaw + entry.yaw * weight
    end

    -- Calculate the weighted average
    future_yaw = future_yaw / total_weight

    -- Apply adjustments based on the recent movement
    local recent_movement = data[#data].velocity
    if recent_movement and recent_movement > 100 then
        future_yaw = future_yaw * 1.2
    else
        future_yaw = future_yaw * 0.8
    end

    -- Introduce slight randomness to counter enemy jitter
    future_yaw = future_yaw + math.random(-10, 10)

    return future_yaw
end

-- New Resolver Functions
local function resolve_aggressive(player_index)
    local recent_movement = entity.get_prop(player_index, "m_vecVelocity[0]")
    local body_yaw = entity.get_prop(player_index, "m_flPoseParameter[11]")
    local adjustment = body_yaw * 1.5

    if recent_movement and recent_movement > 100 then
        adjustment = adjustment * 1.2
    else
        adjustment = adjustment * 0.8
    end

    return adjustment
end

local function resolve_predictive(player_index)
    collect_enemy_data(player_index)
    local future_adjustment = predict_future_aa(player_index)

    local random_adjustment = yaw_history[player_index] and yaw_history[player_index][math.random(#yaw_history[player_index])] or future_adjustment
    local recent_movement = entity.get_prop(player_index, "m_vecVelocity[0]")
    local body_yaw = entity.get_prop(player_index, "m_flPoseParameter[11]")

    if recent_movement and recent_movement > 100 then
        random_adjustment = random_adjustment * 1.2
    else
        random_adjustment = random_adjustment * 0.8
    end

    if body_yaw then
        random_adjustment = random_adjustment + body_yaw * 0.5
    end

    return (random_adjustment + future_adjustment) / 2
end

-- New Resolver for Defensive Anti-Aim 🤺
local function resolve_defensive_aa(player_index)
    collect_enemy_data(player_index)

    local future_adjustment = predict_future_aa(player_index)

    -- Apply additional defensive resolver strategies
    local yaw_data = yaw_history[player_index]
    if not yaw_data or #yaw_data == 0 then
        return future_adjustment
    end

    local random_adjustment = yaw_data[math.random(#yaw_data)]
    local recent_movement = entity.get_prop(player_index, "m_vecVelocity[0]")
    local body_yaw = entity.get_prop(player_index, "m_flPoseParameter[11]") -- Body yaw parameter

    -- Adjust based on movement and body yaw
    if recent_movement and recent_movement > 100 then
        random_adjustment = random_adjustment * 1.2
    else
        random_adjustment = random_adjustment * 0.8
    end

    -- Handling jitter and unpredictable behavior
    if body_yaw then
        random_adjustment = random_adjustment + body_yaw * 0.5
    end

    if math.random() > 0.5 then
        random_adjustment = random_adjustment + math.random(-15, 15)
    end

    return (random_adjustment + future_adjustment) / 2
end

-- Select the best hitbox based on hit probability and player stance
local function select_best_hitbox(player_index)
    if not entity.is_enemy(player_index) then
        return
    end

    local hitbox = ui.get(hitbox_selection)
    local stance = entity.get_prop(player_index, "m_flPoseParameter[0]")
    local hit_probability = calculate_hit_probability(player_index)

    if stance and hit_probability then
        if stance < 0.5 then
            return 3
        else
            if (hit_probability > 0.7) then
                return 0
            elseif (hit_probability > 0.5) then
                return 2
            else
                return 3
            end
        end
    else
        if hitbox == "Head" then
            return 0
        elseif hitbox == "Neck" then
            return 1
        elseif hitbox == "Chest" then
            return 2
        elseif hitbox == "Stomach" then
            return 3
        end
    end
end

local function calculate_shot_accuracy(player_index)
    local shots_fired = entity.get_prop(player_index, "m_iShotsFired") or 0
    local hits = entity.get_prop(player_index, "m_iTotalHits") or 0
    if shots_fired == 0 then
        return 0
    end
    return (hits / shots_fired) * 100
end

local function calculate_engagement_distance(player_index, attacker_index)
    local player_origin = entity.get_origin(player_index)
    local attacker_origin = entity.get_origin(attacker_index)
    return vector.distance(player_origin[1], player_origin[2], player_origin[3], attacker_origin[1], attacker_origin[2], attacker_origin[3])
end

-- Save body yaw data and update UI 💾
local function save_and_update_body_yaw(player_index, yaw)
    local velocity = entity.get_prop(player_index, "m_vecVelocity[0]")
    local stance = entity.get_prop(player_index, "m_flPoseParameter[0]")
    local weapon = entity.get_player_weapon(player_index)
    local shot_time = globals.curtime()
    local health = entity.get_prop(player_index, "m_iHealth")
    local armor = entity.get_prop(player_index, "m_ArmorValue")
    local px, py, pz = entity.get_origin(player_index)
    local lx, ly, lz = entity.get_origin(entity.get_local_player())
    
    -- Check if any coordinate is nil
    if not px or not py or not pz or not lx or not ly or not lz then
        log(LOG_LEVELS.ERROR, "Failed to get player or local player origin.")
        return
    end
    
    local distance = vector.distance(px, py, pz, lx, ly, lz)
    local view_angle = entity.get_prop(player_index, "m_angEyeAngles[1]") -- Player's view angle
    local shot_accuracy = calculate_shot_accuracy(player_index) -- Calculate shot accuracy
    local engagement_distance = distance -- Calculate engagement distance
    local crouch = entity.get_prop(player_index, "m_flDuckAmount")
    local jump = entity.get_prop(player_index, "m_fFlags")
    local scope = entity.get_prop(player_index, "m_bIsScoped")

    body_yaw_data[player_index] = yaw
    add_to_history(player_index, yaw, velocity, stance, weapon, shot_time, health, armor, distance, view_angle, shot_accuracy, engagement_distance, crouch, jump, scope)
    
    if ui.get(enable_resolver) then
        plist.set(player_index, "body yaw", yaw)
        log(LOG_LEVELS.INFO, string.format("Updated body yaw for player %d to %.2f", player_index, yaw))
    else
        log(LOG_LEVELS.ERROR, "Resolver is disabled.")
    end
end

local function on_player_hit(event)
    local target_index = client.userid_to_entindex(event.userid)
    local attacker_index = client.userid_to_entindex(event.attacker)
    if not entity.is_enemy(target_index) then return end

    local hitbox = event.hitgroup
    local damage = event.dmg_health
    local health_left = entity.get_prop(target_index, "m_iHealth")
    local armor_left = entity.get_prop(target_index, "m_ArmorValue")
    local target_velocity = math.sqrt(entity.get_prop(target_index, "m_vecVelocity[0]")^2 + entity.get_prop(target_index, "m_vecVelocity[1]")^2)
    local distance = vector.distance(entity.get_origin(attacker_index), entity.get_origin(target_index))

    log(LOG_LEVELS.INFO, string.format("Player hit: Target %d by Attacker %d", target_index, attacker_index))
    log(LOG_LEVELS.INFO, string.format("Hitbox: %d, Damage: %d, Health Left: %d, Armor Left: %d, Target Velocity: %f, Distance: %f", hitbox, damage, health_left, armor_left, target_velocity, distance))
end

-- Improved on_shot_missed Function
local function on_shot_missed(event)
    local shooter_index = client.userid_to_entindex(event.userid)
    local target_index = client.userid_to_entindex(event.targetid)
    if not entity.is_enemy(target_index) then return end

    missed_shots_data[target_index] = missed_shots_data[target_index] or {}
    table.insert(missed_shots_data[target_index], event.shot_yaw)

    local reason = ""
    local target_velocity = math.sqrt(entity.get_prop(target_index, "m_vecVelocity[0]")^2 + entity.get_prop(target_index, "m_vecVelocity[1]")^2)
    local shot_accuracy = calculate_hit_probability(target_index)
    local hitbox = event.hitgroup
    local distance = vector.distance(entity.get_origin(shooter_index), entity.get_origin(target_index))

    if target_velocity > 100 then
        reason = "Player moved"
    elseif shot_accuracy < 0.5 then
        reason = "Low accuracy"
    elseif distance > 800 then
        reason = "Long distance"
    else
        reason = "Hitbox mismatch"
    end

    local shot_angle = event.shot_yaw
    local target_health = entity.get_prop(target_index, "m_iHealth")
    local target_armor = entity.get_prop(target_index, "m_ArmorValue")

    log(LOG_LEVELS.INFO, string.format("Shot missed: Shooter %d at Target %d", shooter_index, target_index))
    log(LOG_LEVELS.INFO, string.format("Miss Reason: %s, Shot Angle: %f, Target Health: %d, Target Armor: %d, Target Velocity: %f", reason, shot_angle, target_health, target_armor, target_velocity))
end

client.set_event_callback("shot_missed", on_shot_missed)

local round_counter = 0
local auto_save_counter = 0

local function on_round_end(event)
    round_counter = round_counter + 1
    auto_save_counter = auto_save_counter + 1

    if round_counter >= 4 then
        body_yaw_data = {}
        missed_shots_data = {}
        yaw_history = {}
        velocity_history = {}
        stance_history = {}
        weapon_history = {}
        shot_time_history = {}
        health_history = {}
        armor_history = {}
        distance_history = {}
        view_angle_history = {}
        shot_accuracy_history = {}
        engagement_distance_history = {}
        crouch_history = {}
        jump_history = {}
        scope_history = {}
        log(LOG_LEVELS.INFO, "Data reset after 4 rounds.")
        round_counter = 0
    end

    if auto_save_counter >= 6 then
        save_neural_network()
        log(LOG_LEVELS.INFO, "Auto-saved neural network state after 6 rounds.")
        auto_save_counter = 0
    end
end

-- Improved Animation Fix 🛠️
local function animation_fix()
    local players = entity.get_players(true)
    for i = 1, #players do
        local player = players[i]
        if entity.is_alive(player) then
            local anim_state = entity.get_prop(player, "m_flPoseParameter[0]")
            if anim_state then
                entity.set_prop(player, "m_flPoseParameter[0]", anim_state + 0.01)
                entity.set_prop(player, "m_flPoseParameter[0]", anim_state)
            end
        end
    end
end

client.set_event_callback("paint", animation_fix)

-- Register Event Callbacks 📞
client.set_event_callback("player_hurt", on_player_hit)
client.set_event_callback("shot_missed", on_shot_missed)
client.set_event_callback("round_end", on_round_end)

ui.set_callback(enable_resolver, function()
    local enabled = ui.get(enable_resolver)
    if enabled then
        client.set_event_callback("player_hurt", on_player_hit)
        client.set_event_callback("shot_missed", on_shot_missed)
        client.set_event_callback("round_end", on_round_end)
        log(LOG_LEVELS.INFO, "Advanced Resolver enabled.")
    else
        client.unset_event_callback("player_hurt", on_player_hit)
        client.unset_event_callback("shot_missed", on_shot_missed)
        client.unset_event_callback("round_end", on_round_end)
        log(LOG_LEVELS.ERROR, "Advanced Resolver disabled.")
    end
end)

log(LOG_LEVELS.INFO, "Ultimate resolver script with advanced machine learning and enhanced settings loaded.")
print("Ultimate resolver script with advanced machine learning and enhanced settings loaded.")

-- Security Enhancements 🛡️
local function validate_input(input)
    if type(input) ~= "number" or input < -180 or input > 180 then
        log(LOG_LEVELS.ERROR, "Invalid input detected.")
        return false
    end
    return true
end

-- Dynamic Parameter Tuning
local last_decay_factor = nil
local last_hit_probability_factor = nil

local function adjust_resolver_params()
    if not ui.get(enable_resolver) then return end
    local decay_factor = safe_get(decay_factor_slider, "decay_factor_slider")
    local hit_probability_factor = safe_get(hit_probability_factor_slider, "hit_probability_factor_slider")
    
    if last_decay_factor ~= decay_factor or last_hit_probability_factor ~= hit_probability_factor then
        log(LOG_LEVELS.DEBUG, string.format("Decay Factor: %d, Hit Probability Factor: %d", decay_factor, hit_probability_factor))
        last_decay_factor = decay_factor
        last_hit_probability_factor = hit_probability_factor
    end
end

client.set_event_callback("run_command", adjust_resolver_params)

-- Performance Optimization 🚀
local function optimize_performance()
    collectgarbage("collect")
    log(LOG_LEVELS.INFO, "Performance optimization executed.")
end

client.set_event_callback("round_start", optimize_performance)

-- Notification System 🔔
local function send_notification(message)
    client.exec("say", message)
end

-- AI Training Mode 🤖
local function training_mode(player_index)
    local epoch = safe_get(epochs_slider, "epochs_slider")
    local batch_size = 10
    local patience = 10
    while true do
        neural_network_train(player_index, epoch, batch_size, patience)
        log(LOG_LEVELS.INFO, "Training in progress...")
        client.delay_call(1, training_mode, player_index)
    end
end

if ui.get(enable_resolver) then
    for _, player_index in ipairs(entity.get_players(true)) do
        if entity.is_enemy(player_index) then
            training_mode(player_index)
        end
    end
end

-- Adaptive Adjustment Based on User Performance 📈
local function adaptive_adjustment(player_index)
    local recent_behavior = yaw_history[player_index]
    if not recent_behavior or #recent_behavior == 0 then
        return safe_get(default_yaw_adjustment_slider, "default_yaw_adjustment_slider")
    end

    local recent_movement = entity.get_prop(player_index, "m_vecVelocity[0]")
    local adjustment = dynamic_adjustment(player_index, calculate_weighted_average_adjustment(player_index))
    
    if recent_movement and recent_movement > 100 then
        adjustment = adjustment * 1.1
    else
        adjustment = adjustment * 0.9
    end
    
    log(LOG_LEVELS.INFO, "Adaptive adjustment applied based on user performance.")
    return adjustment
end

-- Define a function to detect the operating system.
local function get_os()
    local os_name

    if package.config:sub(1, 1) == '\\' then
        os_name = "windows"
    else
        local fh = io.popen("uname -s")
        local uname = fh:read("*l")
        fh:close()

        if uname == "Linux" then
            os_name = "linux"
        elseif uname == "Darwin" then
            os_name = "mac"
        else
            os_name = "unknown"
        end
    end

    return os_name
end

-- Cross-platform Support Function.
local function cross_platform_support()
    local platform_name = get_os()

    if platform_name == "windows" then
        log(LOG_LEVELS.INFO, "Running on Windows platform.")
    elseif platform_name == "linux" then
        log(LOG_LEVELS.INFO, "Running on Linux platform.")
    elseif platform_name == "mac" then
        log(LOG_LEVELS.INFO, "Running on macOS platform.")
    else
        log(LOG_LEVELS.ERROR, "Unknown platform: " .. tostring(platform_name))
    end
end

cross_platform_support()

-- Enhanced Visualization
local function visualize_prediction(player_index)
    local future_yaw = predict_future_aa(player_index)
    local x, y, z = entity.get_origin(player_index)
    local x2, y2 = renderer.world_to_screen(x, y, z)

    if x2 and y2 then
        renderer.text(x2, y2, 255, 255, 255, 255, "+", 0, "Predicted Yaw: " .. tostring(future_yaw))
    end
end

log(LOG_LEVELS.INFO, "Ultimate resolver script with advanced machine learning and enhanced settings loaded and running.")

-- @region: custom math
math.clamp = function(x, min, max)
    return math.max(min, math.min(x, max))
end

-- @region: utility
local utility = { }

utility.get_client_entity = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)")

utility.get_anim_layer = function(b, c)
    c = c or 1; b = libraries.ffi.cast(libraries.ffi.typeof('void***'), b)

    return libraries.ffi.cast('struct animation_layer_t**', libraries.ffi.cast('char*', b) + 0x2990)[0][c]
end

utility.contains = function(table, argument)
    for index, value in next, table do 
        if value == argument then 
            return true
        end
    end
    return false
end

-- @region: functions
local functions = { }

-- Define menu elements 🛠️
local menu = {
    elements = {
        body_aim_lethality = ui.new_slider("RAGE", "Other", "Body Aim Lethality", 0, 100, 50),
        selection = ui.new_multiselect("RAGE", "Other", "Selection", "Force body on lethal", "Prefer body on override", "Anti-aim correction")
    }
}

-- Functions to handle menu visibility and updates
functions.elements_visibility = function()
    ui.set_visible(menu.elements.body_aim_lethality, (utility.contains(ui.get(menu.elements.selection), "Force body on lethal")))
end

-- Initial function call to set visibility
functions.elements_visibility()

functions.jitter_records = { }

functions.resolve_jitter = function(player)
    if not utility.contains(ui.get(menu.elements.selection), "Anti-aim correction") then
        functions.jitter_records[player] = { side = 1, side_count = 0, desync = 0, temp_pitch = 0, parts = { }, layers = { } }

        plist.set(player, "Correction active", true)
        plist.set(player, "Force body yaw", false)
        plist.set(player, "Force pitch", false)
    else
        if not functions.jitter_records[player] then
            functions.jitter_records[player] = { side = 1, side_count = 0, desync = 0, temp_pitch = 0, parts = { }, layers = { } }
        else
            for u = 1, 13, 1 do
                functions.jitter_records[player].layers[u] = { }

                functions.jitter_records[player].layers[u]["Main"] = utility.get_anim_layer(utility.get_client_entity(player), 6)

                functions.jitter_records[player].layers[u]["m_flPrevCycle"] = functions.jitter_records[player].layers[u]["Main"].m_flPrevCycle

                functions.jitter_records[player].layers[u]["m_flWeight"] = functions.jitter_records[player].layers[u]["Main"].m_flWeight
                
                functions.jitter_records[player].layers[u]["m_flWeightDeltaRate"] = functions.jitter_records[player].layers[u]["Main"].m_flWeightDeltaRate

                functions.jitter_records[player].layers[u]["m_flPlaybackRate"] = functions.jitter_records[player].layers[u]["Main"].m_flPlaybackRate
                
                functions.jitter_records[player].layers[u]["m_flCycle"] = functions.jitter_records[player].layers[u]["Main"].m_flCycle

                functions.jitter_records[player].parts[u] = { }

                for y, val in pairs({"m_flPrevCycle", "m_flWeight", "m_flWeightDeltaRate", "m_flPlaybackRate", "m_flCycle"}) do
                    functions.jitter_records[player].parts[u][val] = { }

                    for i = 1, 13, 1 do
                        functions.jitter_records[player].parts[u][val][i] = math.floor(functions.jitter_records[player].layers[u][val] * (10 ^ i)) - (math.floor(functions.jitter_records[player].layers[u][val] * (10 ^ (i - 1))) * 10)
                    end
                end
            end

            local right_side = functions.jitter_records[player].parts[6]["m_flPlaybackRate"][4] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][5] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][6] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][7]
            
            local left_side = functions.jitter_records[player].parts[6]["m_flPlaybackRate"][6] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][7] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][8] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][9]

            local temp

            if functions.jitter_records[player].parts[6]["m_flPlaybackRate"][3] == 0 then
                temp = -3.4117 * left_side + 98.9393

                if temp < 64 then
                    functions.jitter_records[player].desync = temp
                end
            else
                temp = -3.4117 * right_side + 98.9393

                if temp < 64 then
                    functions.jitter_records[player].desync = temp
                end
            end

            local temp_weight = tonumber(functions.jitter_records[player].parts[6]["m_flWeight"][4] .. functions.jitter_records[player].parts[6]["m_flWeight"][5])

            if functions.jitter_records[player].parts[6]["m_flWeight"][2] == 0 then
                if (functions.jitter_records[player].layers[6]["m_flWeight"] * 10 ^ 5 > 300) then
                    functions.jitter_records[player].side_count = functions.jitter_records[player].side_count + 1
                else
                    functions.jitter_records[player].side_count = 0
                end
            elseif functions.jitter_records[player].parts[6]["m_flWeight"][1] == 9 then
                if temp_weight == 29 then
                    functions.jitter_records[player].side = "Left"
                elseif temp_weight == 30 then
                    functions.jitter_records[player].side = "Right"
                elseif functions.jitter_records[player].parts[6]["m_flWeight"][2] == 9 then
                    functions.jitter_records[player].side_count = functions.jitter_records[player].side_count + 2
                else
                    functions.jitter_records[player].side_count = 0
                end
            end

            if functions.jitter_records[player].side_count >= 4 then
                if functions.jitter_records[player].side == "Left" then
                    functions.jitter_records[player].side = "Right"
                else
                    functions.jitter_records[player].side = "Left"
                end

                functions.jitter_records[player].side_count = 0
            end

            functions.jitter_records[player].desync = math.clamp(math.abs(math.floor(functions.jitter_records[player].desync)), 0, 60)

            local pitch = ({entity.get_prop(player, "m_angEyeAngles")})[1]

            if pitch < 0 and functions.jitter_records[player].temp_pitch > 0 then
                plist.set(player, "Force pitch", true)
                plist.set(player, "Force pitch value", functions.jitter_records[player].temp_pitch)
            else
                plist.set(player, "Force pitch", false)
                functions.jitter_records[player].temp_pitch = pitch
            end

            if functions.jitter_records[player].side == "Right" then
                plist.set(player, "Force body yaw value", functions.jitter_records[player].desync)
            else
                plist.set(player, "Force body yaw value", -functions.jitter_records[player].desync)
            end

            plist.set(player, "Force body yaw", true)
            plist.set(player, "Correction active", true)
        end
    end
end

functions.body_aim = function(player)
    local minimum_damage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") }

    if not utility.contains(ui.get(menu.elements.selection), "Force body on lethal") and not (utility.contains(ui.get(menu.elements.selection), "Prefer body on override") and ui.get(minimum_damage_override[1]) and ui.get(minimum_damage_override[2])) then
        plist.set(player, "Override prefer body aim", "-")
    else
        if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponG3SG1" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSCAR20" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CDEagle" then
            plist.set(player, "Override prefer body aim", "-")
        else
            if entity.get_prop(player, "m_iHealth") <= ui.get(menu.elements.body_aim_lethality) and utility.contains(ui.get(menu.elements.selection), "Force body on lethal") then
                plist.set(player, "Override prefer body aim", "Force")
            else
                if (utility.contains(ui.get(menu.elements.selection), "Prefer body on override") and ui.get(minimum_damage_override[1]) and ui.get(minimum_damage_override[2])) then
                    plist.set(player, "Override prefer body aim", "On")
                else
                    plist.set(player, "Override prefer body aim", "-")
                end
            end
        end
    end
end

functions.update_players = function()
    client.update_player_list()

    local players = entity.get_players(true)

    for id, player in pairs(players) do
        functions.resolve_jitter(player)
        functions.body_aim(player)
    end
end

-- @region: lagcomp box
local g_esp_data = { }
local g_sim_ticks, g_net_data = { }, { }

local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local entity_get_bounding_box = entity.get_bounding_box
local entity_get_player_name = entity.get_player_name
local renderer_text = renderer.text
local w2s = renderer.world_to_screen
local line = renderer.line
local table_insert = table.insert
local client_trace_line = client.trace_line
local math_floor = math.floor
local globals_frametime = globals.frametime

local sv_gravity = cvar.sv_gravity
local sv_jump_impulse = cvar.sv_jump_impulse

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_subtract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_add = function(a, b) return { a[1] + b[1], a[2] + b[2], a[3] + b[3] } end
local vec_length = function(x, y) return (x * x + y * y) end

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}

    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
    end

    return result
end

local extrapolate = function(ent, origin, flags, ticks)
    local tickinterval = globals_tickinterval()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = origin, origin

    local velocity = { entity_get_prop(ent, 'm_vecVelocity') }
    local gravity = velocity[3] > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin = {
            p_origin[1] + (velocity[1] * tickinterval),
            p_origin[2] + (velocity[2] * tickinterval),
            p_origin[3] + (velocity[3]+gravity) * tickinterval,
        }

        local fraction = client_trace_line(-1, 
            prev_origin[1], prev_origin[2], prev_origin[3], 
            p_origin[1], p_origin[2], p_origin[3]
        )

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

local function g_net_update()
    local me = entity_get_local_player()
    local players = get_entities(true, true)

    for i=1, #players do
        local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
            g_esp_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_subtract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_length(diff_origin[1], diff_origin[2])

                    local extrapolated = extrapolate(idx, player_origin, m_fFlags, delta-1)
    
                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        predicted_origin = extrapolated,

                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end
    
            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
    end
end



-- @region: callbacks
local callbacks = { }

callbacks.paint_ui = client.set_event_callback("paint_ui", function()
    functions.elements_visibility()
end)

callbacks.net_update_end = client.set_event_callback("net_update_end", function()
    functions.update_players()
end)

-- Complete the initialization process
log(LOG_LEVELS.INFO, "Ultimate resolver with prediction and enhanced settings fully loaded.")
