-- Создание UI элементов (Чекбоксы)
local enable_aimbot = ui.new_checkbox("MISC", "Miscellaneous", "Enable Aimbot")
local enable_hit_chance = ui.new_checkbox("MISC", "Miscellaneous", "Enable HitChance")
local enable_backtrack = ui.new_checkbox("MISC", "Miscellaneous", "Enable Backtrack")
local enable_safe = ui.new_checkbox("MISC", "Miscellaneous", "Enable Safe Mode")
local fix_prediction_error = ui.new_checkbox("MISC", "Miscellaneous", "Fix Prediction Error")

-- UI Elements для других функций
local aa_strength = ui.new_slider("RAGE", "Aimbot", "Destruction Power", 1, 180, 100, true, "%", 1)
local adaptive_mode = ui.new_combobox("RAGE", "Aimbot", "Adaptive Mode", {"Balanced", "Precision", "Aggressive"})
local anti_bruteforce = ui.new_checkbox("RAGE", "Aimbot", "Anti-Bruteforce")
local spread_compensation = ui.new_checkbox("RAGE", "Aimbot", "Enable Spread Compensation")
local fix_tick_miss = ui.new_checkbox("RAGE", "Aimbot", "Fix Δ: 9t Misses")

-- Core Resolver Data
local resolver = {
    base_angles = {58, -58, 29, -29, 45, -45},
    max_strength = 2.5,
    current_multiplier = 1.0,
    shot_history = {},
    brute_force_count = {},
    last_correction = {},
    miss_count = {}
}

-- Strength Scaling System
local function get_scaled_strength()
    local base = ui.get(aa_strength) / 100
    return math.min(resolver.max_strength, base * resolver.current_multiplier)
end

-- Adaptive Multiplier Control
local function update_multiplier()
    if #resolver.shot_history == 0 then return end

    local hit_rate = 0
    for _, shot in pairs(resolver.shot_history) do
        if shot.hit then hit_rate = hit_rate + 1 end
    end
    hit_rate = hit_rate / #resolver.shot_history

    -- плавное изменение множителя, избегаем резких скачков
    if hit_rate < 0.3 then  
        resolver.current_multiplier = math.max(resolver.current_multiplier * 0.95, 0.8)  -- Меньше резких изменений
    elseif hit_rate > 0.7 then  
        resolver.current_multiplier = math.min(resolver.current_multiplier * 1.05, resolver.max_strength)  -- Более плавный рост
    end
end

-- Anti-Bruteforce Detection
local function detect_bruteforce(ent)
    if not ui.get(anti_bruteforce) then return false end  -- Проверка состояния чекбокса anti_bruteforce
    
    local ent_index = ent
    resolver.brute_force_count[ent_index] = (resolver.brute_force_count[ent_index] or 0) + 1
    
    -- более гибкая логика для брутфорса
    if resolver.brute_force_count[ent_index] >= 5 then
        resolver.brute_force_count[ent_index] = 0
        return true
    end
    
    return false
end

-- Spread Compensation
local function compensate_spread(ent)
    if not ui.get(spread_compensation) then return 0 end  -- Проверка состояния чекбокса spread_compensation
    
    local spread = entity.get_prop(ent, "m_flWeaponSpread")
    if spread == nil then return 0 end  -- Если спред не найден, возвращаем 0

    local spread_angle = spread * 60  -- Преобразуем спред в угол (приближенная формула)

    -- Рассчитываем компенсацию для спреда
    local compensation = spread_angle * (math.random() * 2 - 1)  -- Случайная величина для компенсации ошибки

    return compensation
end

-- Neural Prediction (Δ: 9t Fix + Bruteforce)
local function neural_prediction(ent)
    local ent_index = ent
    local lby = entity.get_prop(ent, "m_flLowerBodyYawTarget") or 0
    local eye_angles = {entity.get_prop(ent, "m_angEyeAnglesY") or lby}
    
    local base_prediction = (lby + eye_angles[1]) * 0.5

    -- Tick compensation for Δ: 9t miss fix
    if ui.get(fix_tick_miss) then
        local tick_shift = math.max(0, globals.tickcount() - entity.get_prop(ent, "m_nTickBase"))
        local latency = client.latency()  -- Используем client.latency() вместо globals.lerptime()
        local desync_fix = tick_shift * (latency * 100)  -- Плавная коррекция на основе задержки
        base_prediction = base_prediction + desync_fix
    end

    -- Apply last correction if available
    local correction = resolver.last_correction[ent_index] or 0
    base_prediction = base_prediction + correction

    -- Adaptive mode influence
    local mode = ui.get(adaptive_mode) or "Balanced"
    local mode_multiplier = (mode == "Balanced" and 1.0) or (mode == "Precision" and 0.8) or (mode == "Aggressive" and 1.2)

    -- Apply anti-bruteforce correction
    if detect_bruteforce(ent) then
        base_prediction = base_prediction + math.random(-10, 10)
    end

    local strength = get_scaled_strength() * mode_multiplier
    local final_angle = (base_prediction + (58 * strength)) % 360

    resolver.last_correction[ent_index] = final_angle

    -- Добавляем компенсацию спреда
    local spread_correction = compensate_spread(ent)
    final_angle = final_angle + spread_correction

    return final_angle
end

-- Execution Core
client.set_event_callback("net_update_end", function()
    for _, ent in ipairs(entity.get_players(true)) do
        if entity.is_enemy(ent) then
            local correction = neural_prediction(ent)
            entity.set_prop(ent, "m_angEyeAnglesY", correction)
        end
    end
end)

-- Feedback System (Shot Analysis)
client.set_event_callback("aim_ack", function(e)
    if e.reason ~= "?" then return end

    local ent = e.target
    local ent_index = ent

    -- Запись в историю выстрела
    table.insert(resolver.shot_history, 1, {
        tick = globals.tickcount(),
        hit = e.hit
    })

    if not e.hit then
        resolver.miss_count[ent_index] = (resolver.miss_count[ent_index] or 0) + 1
        resolver.last_correction[ent_index] = (resolver.last_correction[ent_index] or 0) + math.random(-15, 15)
    else
        resolver.miss_count[ent_index] = 0
    end

    -- Ограничиваем размер истории
    if #resolver.shot_history > 20 then
        table.remove(resolver.shot_history)
    end

    update_multiplier()
end)

-- Enhanced Neural Prediction with Death Check
local function improved_neural_prediction(ent)
    local ent_index = ent
    local lby = entity.get_prop(ent, "m_flLowerBodyYawTarget") or 0
    local eye_angles = {entity.get_prop(ent, "m_angEyeAnglesY") or lby}

    -- Check if the target is dead
    local health = entity.get_prop(ent, "m_iHealth")
    if health <= 0 then
        return nil  -- Do not apply prediction if the target is dead
    end

    local base_prediction = (lby + eye_angles[1]) * 0.5

    -- Tick compensation for Δ: 9t miss fix
    if ui.get(fix_tick_miss) then
        local tick_shift = math.max(0, globals.tickcount() - entity.get_prop(ent, "m_nTickBase"))
        local latency = client.latency()
        local desync_fix = tick_shift * (latency * 100)
        base_prediction = base_prediction + desync_fix
    end

    -- Apply last correction if available
    local correction = resolver.last_correction[ent_index] or 0
    base_prediction = base_prediction + correction

    -- Adaptive mode influence
    local mode = ui.get(adaptive_mode) or "Balanced"
    local mode_multiplier = (mode == "Balanced" and 1.0) or (mode == "Precision" and 0.8) or (mode == "Aggressive" and 1.2)

    -- Apply anti-bruteforce correction
    if detect_bruteforce(ent) then
        base_prediction = base_prediction + math.random(-10, 10)
    end

    local strength = get_scaled_strength() * mode_multiplier
    local final_angle = (base_prediction + (58 * strength)) % 360

    resolver.last_correction[ent_index] = final_angle

    -- Spread compensation
    local spread_correction = compensate_spread(ent)
    final_angle = final_angle + spread_correction

    return final_angle
end

-- Execution Core (Update prediction only if target is alive)
client.set_event_callback("net_update_end", function()
    for _, ent in ipairs(entity.get_players(true)) do
        if entity.is_enemy(ent) then
            local corrected_angle = improved_neural_prediction(ent)
            if corrected_angle then
                entity.set_prop(ent, "m_angEyeAnglesY", corrected_angle)
            end
        end
    end
end)
