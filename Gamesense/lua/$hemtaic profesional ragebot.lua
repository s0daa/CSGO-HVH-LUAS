-- 📌 Core Information
local RESOLVER_VERSION = "3.0.0-2025"
local LAST_UPDATE = "2025-02-26 15:42:34"
local AUTHOR = "Wikingss"

-- 📌 Menu Groups
local menu = {
    -- Main
    label_main_start = ui.new_label("RAGE", "Other", "═══════ Master Resolver ═══════"),
    enabled = ui.new_checkbox("RAGE", "Other", "Enable Master Resolver"),
    mode = ui.new_combobox("RAGE", "Other", "Mode", {
        "Hybrid AI/ML",
        "Pattern Recognition",
        "Network Analysis",
        "Exploit Detection",
        "Dynamic Adaptation"
    }),
    confidence = ui.new_slider("RAGE", "Other", "Base Confidence", 1, 100, 75, true, "%"),
    presets = ui.new_combobox("RAGE", "Other", "Presets", {
        "Maximum Accuracy",
        "Performance",
        "Anti-Exploit",
        "Custom"
    }),
    label_main_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Prediction
    label_pred_start = ui.new_label("RAGE", "Other", "═══════ Prediction ═══════"),
    pred_enabled = ui.new_checkbox("RAGE", "Other", "Enable Prediction"),
    pred_features = ui.new_multiselect("RAGE", "Other", "ML Features", {
        "Movement Analysis",
        "Pattern Recognition",
        "Historical Data",
        "Real-time Adaptation"
    }),
    pred_layers = ui.new_slider("RAGE", "Other", "GRU Layers", 1, 8, 4),
    pred_units = ui.new_slider("RAGE", "Other", "Units per Layer", 16, 256, 128),
    pred_depth = ui.new_slider("RAGE", "Other", "Prediction Depth", 1, 64, 32),
    label_pred_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Animation
    label_anim_start = ui.new_label("RAGE", "Other", "═══════ Animation ═══════"),
    anim_enabled = ui.new_checkbox("RAGE", "Other", "Enable Animation"),
    anim_tracking = ui.new_checkbox("RAGE", "Other", "Sequence Tracking"),
    anim_detection = ui.new_multiselect("RAGE", "Other", "Desync Detection", {
        "Layer Weight Analysis",
        "Delta Comparison",
        "Pattern Matching",
        "Real-time Validation"
    }),
    anim_visual = ui.new_checkbox("RAGE", "Other", "3D Visualization"),
    label_anim_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Network
    label_net_start = ui.new_label("RAGE", "Other", "═══════ Network ═══════"),
    net_enabled = ui.new_checkbox("RAGE", "Other", "Enable Network"),
    net_backtrack = ui.new_multiselect("RAGE", "Other", "Backtrack Options", {
        "Smart Selection",
        "Priority Targets",
        "Optimization"
    }),
    net_conditions = ui.new_slider("RAGE", "Other", "Network Conditions", 1, 100, 50),
    net_optimization = ui.new_checkbox("RAGE", "Other", "Tick Optimization"),
    label_net_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Exploits
    label_exploit_start = ui.new_label("RAGE", "Other", "═══════ Exploits ═══════"),
    exploit_enabled = ui.new_checkbox("RAGE", "Other", "Enable Exploits"),
    exploit_detection = ui.new_multiselect("RAGE", "Other", "Detect Exploits", {
        "Double Tap",
        "Hide Shots",
        "Fake Lag",
        "Extended Desync"
    }),
    exploit_counter = ui.new_multiselect("RAGE", "Other", "Countermeasures", {
        "Auto Adapt",
        "Force Backtrack",
        "Safe Point",
        "Damage Override"
    }),
    label_exploit_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Optimization
    label_opt_start = ui.new_label("RAGE", "Other", "═══════ Optimization ═══════"),
    opt_enabled = ui.new_checkbox("RAGE", "Other", "Enable Optimization"),
    opt_hitbox = ui.new_combobox("RAGE", "Other", "Hitbox Priority", {
        "Smart Selection",
        "Head Priority",
        "Body Priority",
        "Dynamic"
    }),
    opt_boost = ui.new_slider("RAGE", "Other", "Accuracy Boost", 0, 100, 50),
    label_opt_end = ui.new_label("RAGE", "Other", "════════════════════════"),

    -- Debug
    label_debug_start = ui.new_label("RAGE", "Other", "═══════ Debug ═══════"),
    debug_enabled = ui.new_checkbox("RAGE", "Other", "Enable Debug"),
    debug_visual = ui.new_multiselect("RAGE", "Other", "Visualize", {
        "Prediction Lines",
        "Hitboxes",
        "Network Data",
        "ML Confidence"
    }),
    debug_logging = ui.new_checkbox("RAGE", "Other", "Extended Logging"),
    label_debug_end = ui.new_label("RAGE", "Other", "════════════════════════")
}

-- 📌 Helper Functions
local function create_colored_text(text, r, g, b)
    local color_prefix = string.char(r, g, b)
    return color_prefix .. text .. string.char(255, 255, 255)
end

local function format_time(seconds)
    return string.format("%.2f", seconds)
end

local function get_preset_config(preset_name)
    local presets = {
        ["Maximum Accuracy"] = {
            pred_layers = 8,
            pred_units = 256,
            confidence = 95,
        },
        ["Performance"] = {
            pred_layers = 4,
            pred_units = 128,
            confidence = 75,
        },
        ["Anti-Exploit"] = {
            pred_layers = 6,
            pred_units = 192,
            confidence = 85,
        },
        ["Custom"] = {}
    }
    return presets[preset_name] or presets["Custom"]
end

local function apply_preset(preset_name)
    local config = get_preset_config(preset_name)
    for setting, value in pairs(config) do
        if menu[setting] then
            ui.set(menu[setting], value)
        end
    end
end

local function set_default_values()
    ui.set(menu.enabled, true)
    ui.set(menu.mode, "Hybrid AI/ML")
    ui.set(menu.confidence, 85)
    ui.set(menu.presets, "Maximum Accuracy")
    ui.set(menu.pred_enabled, true)
    ui.set(menu.pred_features, {
        "Movement Analysis",
        "Pattern Recognition",
        "Historical Data"
    })
    ui.set(menu.anim_enabled, true)
    ui.set(menu.net_enabled, true)
    ui.set(menu.exploit_enabled, true)
    ui.set(menu.opt_enabled, true)
    ui.set(menu.debug_enabled, false)
end

local function handle_visibility()
    local master_enabled = ui.get(menu.enabled)
    
    -- Główne elementy
    ui.set_visible(menu.mode, master_enabled)
    ui.set_visible(menu.confidence, master_enabled)
    ui.set_visible(menu.presets, master_enabled)

    -- Labels
    ui.set_visible(menu.label_main_start, master_enabled)
    ui.set_visible(menu.label_main_end, master_enabled)
    ui.set_visible(menu.label_pred_start, master_enabled)
    ui.set_visible(menu.label_pred_end, master_enabled)
    ui.set_visible(menu.label_anim_start, master_enabled)
    ui.set_visible(menu.label_anim_end, master_enabled)
    ui.set_visible(menu.label_net_start, master_enabled)
    ui.set_visible(menu.label_net_end, master_enabled)
    ui.set_visible(menu.label_exploit_start, master_enabled)
    ui.set_visible(menu.label_exploit_end, master_enabled)
    ui.set_visible(menu.label_opt_start, master_enabled)
    ui.set_visible(menu.label_opt_end, master_enabled)
    ui.set_visible(menu.label_debug_start, master_enabled)
    ui.set_visible(menu.label_debug_end, master_enabled)

    -- Prediction
    local pred_visible = master_enabled and ui.get(menu.pred_enabled)
    ui.set_visible(menu.pred_enabled, master_enabled)
    ui.set_visible(menu.pred_features, pred_visible)
    ui.set_visible(menu.pred_layers, pred_visible)
    ui.set_visible(menu.pred_units, pred_visible)
    ui.set_visible(menu.pred_depth, pred_visible)

    -- Animation
    local anim_visible = master_enabled and ui.get(menu.anim_enabled)
    ui.set_visible(menu.anim_enabled, master_enabled)
    ui.set_visible(menu.anim_tracking, anim_visible)
    ui.set_visible(menu.anim_detection, anim_visible)
    ui.set_visible(menu.anim_visual, anim_visible)

    -- Network
    local net_visible = master_enabled and ui.get(menu.net_enabled)
    ui.set_visible(menu.net_enabled, master_enabled)
    ui.set_visible(menu.net_backtrack, net_visible)
    ui.set_visible(menu.net_conditions, net_visible)
    ui.set_visible(menu.net_optimization, net_visible)

    -- Exploits
    local exploit_visible = master_enabled and ui.get(menu.exploit_enabled)
    ui.set_visible(menu.exploit_enabled, master_enabled)
    ui.set_visible(menu.exploit_detection, exploit_visible)
    ui.set_visible(menu.exploit_counter, exploit_visible)

    -- Optimization
    local opt_visible = master_enabled and ui.get(menu.opt_enabled)
    ui.set_visible(menu.opt_enabled, master_enabled)
    ui.set_visible(menu.opt_hitbox, opt_visible)
    ui.set_visible(menu.opt_boost, opt_visible)

    -- Debug
    local debug_visible = master_enabled and ui.get(menu.debug_enabled)
    ui.set_visible(menu.debug_enabled, master_enabled)
    ui.set_visible(menu.debug_visual, debug_visible)
    ui.set_visible(menu.debug_logging, debug_visible)
end -- TUTAJ DODANO BRAKUJĄCY end dla funkcji handle_visibility

-- Callbacks dla menu
ui.set_callback(menu.enabled, handle_visibility)
ui.set_callback(menu.pred_enabled, handle_visibility)
ui.set_callback(menu.anim_enabled, handle_visibility)
ui.set_callback(menu.net_enabled, handle_visibility)
ui.set_callback(menu.exploit_enabled, handle_visibility)
ui.set_callback(menu.opt_enabled, handle_visibility)
ui.set_callback(menu.debug_enabled, handle_visibility)

-- Callback dla presetu
ui.set_callback(menu.presets, function()
    local selected_preset = ui.get(menu.presets)
    apply_preset(selected_preset)
end)

-- Inicjalizacja
set_default_values()
handle_visibility()

-- Event callback
client.set_event_callback("paint", function()
    if ui.get(menu.enabled) then
        local screen_w, screen_h = client.screen_size()
        renderer.text(10, screen_h - 25, 130, 180, 255, 255, "", 0, 
            string.format("Master Resolver | v%s | by %s", RESOLVER_VERSION, AUTHOR))
    end
end)

-- Konfiguracja systemu
local CONFIG = {
    ML = {
        LEARNING_RATE = 0.001,
        UPDATE_INTERVAL = 0.1,
        BATCH_SIZE = 16,
        DEFAULT_LAYERS = 4,
        DEFAULT_UNITS = 128
    },
    ANIMATION = {
        UPDATE_RATE = 0.05,
        MAX_HISTORY = 32,
        DEFAULT_PRIORITY = 3
    },
    NETWORK = {
        MAX_RECORDS = 64,
        BACKTRACK_LIMIT = 1.0,
        LERP_TIME = 0.2
    },
    EXPLOITS = {
        DT_THRESHOLD = 0.8,
        HS_THRESHOLD = 0.7,
        FL_THRESHOLD = 14,
        DETECT_INTERVAL = 0.5
    }
}

-- System uczenia maszynowego (ML)
local MLSystem = {
    layers = {},
    weights = {},
    cache = {},
    last_update = 0,
    
    init = function(self, num_layers, num_units)
        self.layers = {}
        self.cache = {}
        self.last_update = globals.realtime()
        
        num_layers = num_layers or CONFIG.ML.DEFAULT_LAYERS
        num_units = num_units or CONFIG.ML.DEFAULT_UNITS
        
        for i = 1, num_layers do
            self.layers[i] = {
                units = num_units,
                weights = {},
                bias = {},
                last_output = {},
                gradient = {}
            }
            
            for j = 1, num_units do
                self.layers[i].weights[j] = math.random() * 2 - 1
                self.layers[i].bias[j] = math.random() * 2 - 1
                self.layers[i].gradient[j] = 0
            end
        end
    end,

    update_weights = function(self, error)
        local learning_rate = CONFIG.ML.LEARNING_RATE
        
        for i = 1, #self.layers do
            local layer = self.layers[i]
            for j = 1, layer.units do
                layer.weights[j] = layer.weights[j] - learning_rate * layer.gradient[j] * error
                layer.bias[j] = layer.bias[j] - learning_rate * error
            end
        end
    end,

    predict = function(self, input)
        -- Sprawdzenie cache
        local cache_key = table.concat(input, ",")
        if self.cache[cache_key] then
            return self.cache[cache_key]
        end
        
        local output = input
        for i = 1, #self.layers do
            local layer = self.layers[i]
            local new_output = {}
            
            for j = 1, layer.units do
                new_output[j] = layer.bias[j]
                for k = 1, #output do
                    new_output[j] = new_output[j] + output[k] * layer.weights[j]
                end
                new_output[j] = math.tanh(new_output[j])
                layer.last_output[j] = new_output[j]
            end
            output = new_output
        end
        
        -- Zapisz wynik do cache
        self.cache[cache_key] = output[1]
        return output[1]
    end,

    train = function(self, inputs, targets, epochs)
        epochs = epochs or 10
        local batch_size = CONFIG.ML.BATCH_SIZE
        local learning_rate = CONFIG.ML.LEARNING_RATE
        
        for epoch = 1, epochs do
            local total_error = 0
            
            for i = 1, #inputs, batch_size do
                local batch_end = math.min(i + batch_size - 1, #inputs)
                local batch_inputs = {}
                local batch_targets = {}
                
                for j = i, batch_end do
                    table.insert(batch_inputs, inputs[j])
                    table.insert(batch_targets, targets[j])
                end
                
                for j, input in ipairs(batch_inputs) do
                    local prediction = self:predict(input)
                    local error = batch_targets[j] - prediction
                    self:update_weights(error)
                    total_error = total_error + math.abs(error)
                end
            end
        end
        
        -- Wyczyść cache po treningu
        self.cache = {}
    end,
    
    analyze_player = function(self, ent)
        if not entity.is_alive(ent) then return 0 end
        
        local player_x, player_y, player_z = entity.get_prop(ent, "m_vecOrigin")
        local vel_x, vel_y, vel_z = entity.get_prop(ent, "m_vecVelocity")
        local eye_angles_y = entity.get_prop(ent, "m_angEyeAngles[1]")
        local lower_body_yaw = entity.get_prop(ent, "m_flLowerBodyYawTarget")
        
        if not player_x or not vel_x or not eye_angles_y or not lower_body_yaw then
            return 0
        end
        
        local speed = math.sqrt(vel_x^2 + vel_y^2)
        local moving = speed > 5
        local delta_yaw = math.abs((eye_angles_y - lower_body_yaw) % 360)
        if delta_yaw > 180 then delta_yaw = 360 - delta_yaw end
        
        local input = {
            moving and 1 or 0,
            speed / 250,
            delta_yaw / 180
        }
        
        return self:predict(input)
    end
}

-- System analizy animacji
local AnimationSystem = {
    sequences = {},
    patterns = {},
    last_update = 0,
    
    init = function(self)
        self.sequences = {}
        self.patterns = {}
        self.last_update = globals.realtime()
    end,
    
    get_animlayer = function(self, ent)
        if not entity.is_alive(ent) then return nil end
        
        -- Pobieranie warstw animacji
        local layers = {}
        
        for i = 0, 13 do  -- CS:GO używa 13 warstw animacji
            local weight = entity.get_prop(ent, string.format("m_flWeight[%d]", i)) or 0
            local cycle = entity.get_prop(ent, string.format("m_flCycle[%d]", i)) or 0
            local sequence = entity.get_prop(ent, string.format("m_nSequence[%d]", i)) or 0
            
            layers[i] = {
                weight = weight,
                cycle = cycle,
                sequence = sequence
            }
        end
        
        return layers
    end,

    update_patterns = function(self, ent)
        local current_time = globals.realtime()
        if current_time - self.last_update < CONFIG.ANIMATION.UPDATE_RATE then
            return
        end
        
        local layers = self:get_animlayer(ent)
        if not layers then return end
        
        local pattern = {
            time = current_time,
            layers = layers
        }
        
        if not self.patterns[ent] then
            self.patterns[ent] = {}
        end
        
        table.insert(self.patterns[ent], pattern)
        if #self.patterns[ent] > CONFIG.ANIMATION.MAX_HISTORY then
            table.remove(self.patterns[ent], 1)
        end
        
        self.last_update = current_time
    end,

    get_desync_amount = function(self, ent)
        if not self.patterns[ent] or #self.patterns[ent] < 2 then return 0 end
        
        local eye_angles_y = entity.get_prop(ent, "m_angEyeAngles[1]")
        local lower_body_yaw = entity.get_prop(ent, "m_flLowerBodyYawTarget")
        
        if not eye_angles_y or not lower_body_yaw then return 0 end
        
        local delta_yaw = math.abs((eye_angles_y - lower_body_yaw) % 360)
        if delta_yaw > 180 then delta_yaw = 360 - delta_yaw end
        
        -- Analiza wzorców animacji
        local patterns = self.patterns[ent]
        local latest = patterns[#patterns]
        local previous = patterns[#patterns - 1]
        
        local weight_delta = 0
        local cycle_delta = 0
        local sequence_changed = false
        local count = 0
        
        for i = 0, 13 do
            if latest.layers[i] and previous.layers[i] then
                weight_delta = weight_delta + math.abs(latest.layers[i].weight - previous.layers[i].weight)
                cycle_delta = cycle_delta + math.abs(latest.layers[i].cycle - previous.layers[i].cycle)
                if latest.layers[i].sequence ~= previous.layers[i].sequence then
                    sequence_changed = true
                end
                count = count + 1
            end
        end
        
        if count > 0 then
            weight_delta = weight_delta / count
            cycle_delta = cycle_delta / count
        end
        
        -- Im większe delta, tym większy potencjalny desync
        local desync_estimate = delta_yaw * (1 + weight_delta * 10 + cycle_delta * 5)
        if sequence_changed then desync_estimate = desync_estimate * 1.25 end
        
        return math.min(desync_estimate, 180)
    end,
    
    analyze_animation_behavior = function(self, ent)
        if not self.patterns[ent] then return {} end
        
        local patterns = self.patterns[ent]
        if #patterns < 10 then return {} end
        
        local analysis = {
            is_static = true,
            is_jittering = false,
            is_switching = false,
            cycle_time = 0,
            dominant_pattern = nil
        }
        
        -- Analiza zmian w czasie
        local deltas = {}
        local jitter_count = 0
        local sequence_changes = 0
        
        for i = 2, #patterns do
            local curr = patterns[i]
            local prev = patterns[i-1]
            local delta = 0
            local seq_changed = false
            local count = 0
            
            for layer_idx = 0, 13 do
                if curr.layers[layer_idx] and prev.layers[layer_idx] then
                    delta = delta + math.abs(curr.layers[layer_idx].weight - prev.layers[layer_idx].weight)
                    if curr.layers[layer_idx].sequence ~= prev.layers[layer_idx].sequence then
                        seq_changed = true
                    end
                    count = count + 1
                end
            end
            
            if count > 0 then
                delta = delta / count
                table.insert(deltas, delta)
                
                if delta > 0.2 then  -- Wartość progowa dla jittera
                    jitter_count = jitter_count + 1
                end
                
                if seq_changed then
                    sequence_changes = sequence_changes + 1
                end
            end
        end
        
        -- Określ zachowanie
        if #deltas > 0 then
            local avg_delta = 0
            for _, d in ipairs(deltas) do
                avg_delta = avg_delta + d
            end
            avg_delta = avg_delta / #deltas
            
            analysis.is_static = avg_delta < 0.05 and sequence_changes < 3
            analysis.is_jittering = jitter_count > #deltas * 0.3 or sequence_changes > #deltas * 0.2
            
            -- Szukaj cyklów
            if not analysis.is_static and not analysis.is_jittering then
                -- Prosta analiza cykli
                local max_correlation = 0
                local cycle_length = 0
                
                for test_cycle = 2, math.min(#deltas/2, 16) do
                    local correlation = 0
                    local samples = 0
                    
                    for i = 1, #deltas - test_cycle do
                        correlation = correlation + (1 - math.abs(deltas[i] - deltas[i + test_cycle]))
                        samples = samples + 1
                    end
                    
                    if samples > 0 then
                        correlation = correlation / samples
                        if correlation > max_correlation then
                            max_correlation = correlation
                            cycle_length = test_cycle
                        end
                    end
                end
                
                if max_correlation > 0.7 then
                    analysis.is_switching = true
                    analysis.cycle_time = cycle_length * CONFIG.ANIMATION.UPDATE_RATE
                end
            end
            
            -- Znajdź dominującą sekwencję
            local sequences = {}
            for i = 1, #patterns do
                for layer_idx = 0, 13 do
                    if patterns[i].layers[layer_idx] then
                        local seq = patterns[i].layers[layer_idx].sequence
                        if seq > 0 then
                            sequences[seq] = (sequences[seq] or 0) + 1
                        end
                    end
                end
            end
            
            local max_seq = 0
            local max_count = 0
            for seq, count in pairs(sequences) do
                if count > max_count then
                    max_count = count
                    max_seq = seq
                end
            end
            
            analysis.dominant_pattern = max_seq
        end
        
        return analysis
    end
}

-- System analizy sieci
local NetworkSystem = {
    records = {},
    stats = {},
    last_update = 0,
    
    init = function(self)
        self.records = {}
        self.stats = {}
        self.last_update = globals.realtime()
    end,

    record = function(self, ent)
        local current_time = globals.curtime()
        
        if not self.records[ent] then
            self.records[ent] = {}
            self.stats[ent] = {
                avg_ping = 0,
                choke = 0,
                loss = 0,
                last_update = current_time
            }
        end
        
        -- Pobierz informacje o graczu
        local player_info = entity.get_player_info(ent)
        if not player_info then return nil end
        
        local record = {
            time = current_time,
            ping = player_info.ping or 0,
            choke = player_info.choke or 0,
            loss = player_info.loss or 0,
            position = {entity.get_prop(ent, "m_vecOrigin")},
            angles = {entity.get_prop(ent, "m_angEyeAngles")},
            velocity = {entity.get_prop(ent, "m_vecVelocity")}
        }
        
        -- Aktualizuj statystyki
        self.stats[ent].avg_ping = self.stats[ent].avg_ping * 0.9 + record.ping * 0.1
        self.stats[ent].choke = self.stats[ent].choke * 0.9 + record.choke * 0.1
        self.stats[ent].loss = self.stats[ent].loss * 0.9 + record.loss * 0.1
        self.stats[ent].last_update = current_time
        
        -- Dodaj rekord
        table.insert(self.records[ent], record)
        
        -- Ograniczenie historii
        if #self.records[ent] > CONFIG.NETWORK.MAX_RECORDS then
            table.remove(self.records[ent], 1)
        end
        
        return record
    end,

    get_best_record = function(self, ent)
        if not self.records[ent] or #self.records[ent] == 0 then
            return nil
        end
        
        local current_time = globals.curtime()
        local best_record = nil
        local best_score = -1
        
        for _, record in ipairs(self.records[ent]) do
            -- Nie bierz pod uwagę rekordów starszych niż limit backtrack
            if current_time - record.time <= CONFIG.NETWORK.BACKTRACK_LIMIT then
                local time_factor = 1 - (current_time - record.time) / CONFIG.NETWORK.BACKTRACK_LIMIT
                local network_factor = 1 / (1 + record.choke + record.loss * 2)
                local score = time_factor * network_factor
                
                if score > best_score then
                    best_score = score
                    best_record = record
                end
            end
        end
        
        return best_record
    end,
    
    analyze_network_behavior = function(self, ent)
        if not self.records[ent] then return {} end
        
        local records = self.records[ent]
        if #records < 5 then return {} end
        
        local analysis = {
            ping_stability = 0,
            choke_frequency = 0,
            loss_frequency = 0,
            is_fakelagging = false,
            exploit_level = 0,
            update_rate = 0
        }
        
        -- Analiza zmian w czasie
        local ping_diffs = {}
        local choke_counts = 0
        local loss_counts = 0
        local time_diffs = {}
        local high_choke_count = 0
        
        for i = 2, #records do
            local curr = records[i]
            local prev = records[i-1]
            
            table.insert(ping_diffs, math.abs(curr.ping - prev.ping))
            if curr.choke > 0.1 then choke_counts = choke_counts + 1 end
            if curr.choke > 0.5 then high_choke_count = high_choke_count + 1 end
            if curr.loss > 0.1 then loss_counts = loss_counts + 1 end
            table.insert(time_diffs, curr.time - prev.time)
        end
        
        -- Oblicz statystyki
        if #ping_diffs > 0 then
            local sum_ping_diffs = 0
            for _, diff in ipairs(ping_diffs) do
                sum_ping_diffs = sum_ping_diffs + diff
            end
            analysis.ping_stability = 1 - math.min(1, sum_ping_diffs / (#ping_diffs * 30))
        end
        
        analysis.choke_frequency = choke_counts / #records
        analysis.loss_frequency = loss_counts / #records
        analysis.is_fakelagging = high_choke_count > #records * 0.3
        
        -- Oszacuj poziom exploitów
        local exploit_indicators = 0
        
        -- Nieregularny czas aktualizacji
        if #time_diffs > 0 then
            local sum_time = 0
            local sum_squared_diff = 0
            
            for _, diff in ipairs(time_diffs) do
                sum_time = sum_time + diff
            end
            
            local avg_time = sum_time / #time_diffs
            analysis.update_rate = 1 / avg_time
            
            for _, diff in ipairs(time_diffs) do
                sum_squared_diff = sum_squared_diff + (diff - avg_time)^2
            end
            
            local std_dev = math.sqrt(sum_squared_diff / #time_diffs)
            local coefficient_variation = std_dev / avg_time
            
            if coefficient_variation > 0.5 then
                exploit_indicators = exploit_indicators + coefficient_variation
            end
        end
        
        -- Nagłe zmiany kąta
        local angle_changes = 0
        for i = 2, #records do
            local curr_angles = records[i].angles
            local prev_angles = records[i-1].angles
            
            if curr_angles and prev_angles and curr_angles[2] and prev_angles[2] then
                local yaw_diff = math.abs((curr_angles[2] - prev_angles[2]) % 360)
                if yaw_diff > 180 then yaw_diff = 360 - yaw_diff end
                
                if yaw_diff > 45 then
                    angle_changes = angle_changes + 1
                end
            end
        end
        
        if angle_changes > #records * 0.2 then
            exploit_indicators = exploit_indicators + (angle_changes / #records) * 2
        end
        
        -- Wysoki choke i duże zmiany pozycji
        local teleport_count = 0
        for i = 2, #records do
            local curr = records[i]
            local prev = records[i-1]
            
            if curr.choke > 0.4 and curr.position and prev.position then
                local dx = curr.position[1] - prev.position[1]
                local dy = curr.position[2] - prev.position[2]
                local dist = math.sqrt(dx*dx + dy*dy)
                
                if dist > 32 then  -- Znacząca zmiana pozycji
                    teleport_count = teleport_count + 1
                end
            end
        end
        
        if teleport_count > 0 then
            exploit_indicators = exploit_indicators + teleport_count / #records * 3
        end
        
        analysis.exploit_level = math.min(1, exploit_indicators / 5)
        
        return analysis
    end
}

-- System wykrywania exploitów
local ExploitSystem = {
    records = {},
    last_check = {},
    
    init = function(self)
        self.records = {}
        self.last_check = {}
    end,
    
    detect_exploits = function(self, ent)
        local current_time = globals.realtime()
        
        -- Ograniczenie częstotliwości sprawdzania
        if self.last_check[ent] and current_time - self.last_check[ent] < CONFIG.EXPLOITS.DETECT_INTERVAL then
            return self.records[ent] or {}
        end
        
        self.last_check[ent] = current_time
        
        local exploits = {}
        
        -- Informacje o graczu
        local player_info = entity.get_player_info(ent)
        if not player_info then return exploits end
        
        -- Pozycja i prędkość
        local pos_x, pos_y, pos_z = entity.get_prop(ent, "m_vecOrigin")
        local vel_x, vel_y, vel_z = entity.get_prop(ent, "m_vecVelocity")
        local simtime = entity.get_prop(ent, "m_flSimulationTime")
        
        if not pos_x or not vel_x or not simtime then return exploits end
        
        -- Zapisz aktualny rekord
        if not self.records[ent] then
            self.records[ent] = {}
        end
        
        local current_record = {
            time = current_time,
            game_time = globals.curtime(),
            simtime = simtime,
            ping = player_info.ping or 0,
            choke = player_info.choke or 0,
            position = {pos_x, pos_y, pos_z},
            velocity = {vel_x, vel_y, vel_z},
            flags = entity.get_prop(ent, "m_fFlags") or 0
        }
        
        -- Przechowuj maksymalnie 10 ostatnich rekordów
        table.insert(self.records[ent], 1, current_record)
        if #self.records[ent] > 10 then
            table.remove(self.records[ent])
        end
        
        -- Potrzebujemy przynajmniej 2 rekordy do analizy
        if #self.records[ent] < 2 then return exploits end
        
        -- Wykrywanie Double Tap
        if #self.records[ent] >= 3 then
            local r1 = self.records[ent][1]
            local r2 = self.records[ent][2]
            local r3 = self.records[ent][3]
            
            local dt1 = r1.simtime - r2.simtime
            local dt2 = r2.simtime - r3.simtime
            local norm_dt = 1 / entity.get_prop(ent, "m_nTickBase") or 0.015
            
            if dt1 > norm_dt * 1.5 and dt2 < norm_dt * 0.7 then
                exploits.double_tap = {
                    confidence = math.min(1.0, dt1 / (norm_dt * 2)),
                    last_time = current_time
                }
            end
        end
        
        -- Wykrywanie Hide Shots (symulacja opóźnienia strzału)
        local r1 = self.records[ent][1]
        local r2 = self.records[ent][2]
        
        if r1.choke > CONFIG.EXPLOITS.HS_THRESHOLD and r1.simtime - r2.simtime > 0.03 then
            exploits.hide_shots = {
                confidence = math.min(1.0, r1.choke),
                last_time = current_time
            }
        end
        
        -- Wykrywanie Fake Lag
        if r1.choke > CONFIG.EXPLOITS.FL_THRESHOLD then
            exploits.fake_lag = {
                confidence = math.min(1.0, r1.choke / 20),
                value = r1.choke,
                last_time = current_time
            }
        end
        
        -- Wykrywanie Extended Desync
        local eye_angles_y = entity.get_prop(ent, "m_angEyeAngles[1]")
        local lower_body_yaw = entity.get_prop(ent, "m_flLowerBodyYawTarget")
        
        if eye_angles_y and lower_body_yaw then
            local delta_yaw = math.abs((eye_angles_y - lower_body_yaw) % 360)
            if delta_yaw > 180 then delta_yaw = 360 - delta_yaw end
            
            if delta_yaw > 58 then  -- Typowy maksymalny desync to około 58 stopni
                exploits.extended_desync = {
                    confidence = math.min(1.0, (delta_yaw - 58) / 30),
                    value = delta_yaw,
                    last_time = current_time
                }
            end
        end
        
        return exploits
    end,
    
    get_exploit_level = function(self, ent)
        local exploits = self:detect_exploits(ent)
        local current_time = globals.realtime()
        local total_level = 0
        local count = 0
        
        for exploit_type, info in pairs(exploits) do
            -- Uwzględnij tylko świeże dane (do 1 sekundy)
            if current_time - info.last_time < 1.0 then
                local weight = 1.0
                if exploit_type == "double_tap" then weight = 1.5
                elseif exploit_type == "hide_shots" then weight = 1.2
                elseif exploit_type == "fake_lag" then weight = 0.8
                elseif exploit_type == "extended_desync" then weight = 1.0
                end
                
                total_level = total_level + info.confidence * weight
                count = count + weight
            end
        end
        
        return count > 0 and (total_level / count) or 0
    end
}

-- Główny system resolvera
local Resolver = {
    version = RESOLVER_VERSION,
    last_update = LAST_UPDATE,
    author = AUTHOR,
    statistics = {
        total_resolves = 0,
        successful_resolves = 0,
        failed_resolves = 0,
        average_confidence = 0,
        resolve_time = 0
    },
    
    systems = {
        ml = MLSystem,
        animation = AnimationSystem,
        network = NetworkSystem,
        exploits = ExploitSystem
    },

    init = function(self, config)
        self.statistics = {
            total_resolves = 0,
            successful_resolves = 0,
            failed_resolves = 0,
            average_confidence = 0,
            resolve_time = 0
        }
        
        config = config or {}
        
        -- Inicjalizacja podsystemów
        self.systems.ml:init(config.pred_layers, config.pred_units)
        self.systems.animation:init()
        self.systems.network:init()
        self.systems.exploits:init()
        
        print(string.format("\n[Resolver] Version %s initialized by %s", self.version, self.author))
        return self
    end,
    
    resolve = function(self, ent, options)
        if not ent or not entity.is_alive(ent) then return nil end
        
        options = options or {}
        local confidence_base = options.confidence or 0.75
        local use_prediction = options.prediction ~= false
        local use_animation = options.animation ~= false
        local use_network = options.network ~= false
        local use_exploits = options.exploits ~= false
        
        -- Tutaj dodaj kod obsługi resolvera
    end,
    
    update_statistics = function(self, success, confidence, time)
        self.statistics.total_resolves = self.statistics.total_resolves + 1
        if success then
            self.statistics.successful_resolves = self.statistics.successful_resolves + 1
        else
            self.statistics.failed_resolves = self.statistics.failed_resolves + 1
        end
        
        self.statistics.average_confidence = 
            (self.statistics.average_confidence * (self.statistics.total_resolves - 1) + confidence) 
            / self.statistics.total_resolves
            
        self.statistics.resolve_time = 
            (self.statistics.resolve_time * (self.statistics.total_resolves - 1) + time) 
            / self.statistics.total_resolves
    end
}