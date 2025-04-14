-- Настройки резолвера
local settings = {
    enabled = true,           -- Включить резольвер (true/false)
    desync_sensitivity = 35,  -- Чувствительность десинка (10–60 градусов)
    brute_speed = 5,          -- Скорость брутфорса (1–10, больше = быстрее меняет углы)
    visualize = true          -- Показывать визуализацию (true/false)
}
local enable_logs = true      -- Включить логи (true/false)

-- Таблица для хранения данных резолвера
local resolver_data = {}
local last_shot = {}

-- Список углов для брутфорса
local brute_angles = { 0, 58, -58, 90, -90, 180, -180, 45, -45, 135, -135, 30, -30, 60, -60, 120, -120 }

-- Функция для логирования
local function log_message(...)
    if enable_logs then
        client.log(...)
    end
end

-- Функция для получения текущего времени
local function get_time()
    return globals.curtime()
end

-- Нормализация угла
local function normalize_angle(angle)
    while angle > 180 do angle = angle - 360 end
    while angle < -180 do angle = angle + 360 end
    return angle
end

-- Инициализация данных для игрока
local function init_player(entindex)
    if not resolver_data[entindex] then
        resolver_data[entindex] = {
            last_yaw = 0,
            brute_index = 1,
            last_update = 0,
            hits = 0,
            misses = 0,
            resolved_yaw = 0,
            last_lby = 0,
            last_velocity = 0,
            desync_side = 0,
            last_anim_time = 0,
            miss_streak = 0
        }
    end
end

-- Получение десинк направления через анимации
local function get_desync_side(entindex)
    local anim_time = entity.get_prop(entindex, "m_flSimulationTime")
    if not anim_time then return 0 end

    local layer = entity.get_prop(entindex, "m_AnimOverlay", 3)
    if layer then
        local cycle = entity.get_prop(entindex, "m_AnimOverlay", 3, "m_flCycle")
        local weight = entity.get_prop(entindex, "m_AnimOverlay", 3, "m_flWeight")
        if cycle and weight and weight > 0 then
            local data = resolver_data[entindex]
            if data.last_anim_time ~= anim_time then
                local yaw = get_anim_yaw(entindex)
                local delta = normalize_angle(yaw - data.last_yaw)
                if math.abs(delta) > settings.desync_sensitivity then
                    return delta > 0 and 1 or -1
                end
            end
        end
    end
    return 0
end

-- Получение yaw из анимаций или LBY
local function get_anim_yaw(entindex)
    local yaw = entity.get_prop(entindex, "m_flPoseParameter", 11)
    if yaw then
        yaw = yaw * 360 - 180
        if math.abs(yaw) > 1 then
            return yaw
        end
    end

    local lby = entity.get_prop(entindex, "m_flLowerBodyYawTarget")
    if lby and math.abs(lby) > 1 then
        return lby
    end

    return 0
end

-- Функция для резолвинга угла
local function resolve_yaw(entindex)
    if not settings.enabled then return 0 end
    init_player(entindex)
    local data = resolver_data[entindex]
    local now = get_time()
    if now - data.last_update < 0.05 then
        return data.resolved_yaw
    end
    data.last_update = now

    local anim_yaw = get_anim_yaw(entindex)
    local lby = entity.get_prop(entindex, "m_flLowerBodyYawTarget") or 0
    local velocity = math.sqrt((entity.get_prop(entindex, "m_vecVelocity[0]") or 0)^2 + (entity.get_prop(entindex, "m_vecVelocity[1]") or 0)^2)

    local desync_side = get_desync_side(entindex)
    if desync_side ~= 0 then
        data.desync_side = desync_side
    end

    if data.miss_streak >= 2 then
        local speed = math.floor(settings.brute_speed)
        data.brute_index = (data.brute_index + speed) % #brute_angles + 1
        data.resolved_yaw = brute_angles[data.brute_index]
        if data.miss_streak >= 3 then
            data.resolved_yaw = normalize_angle(data.resolved_yaw + (math.random(0, 1) == 0 and 180 or -180))
        end
        log_message(string.format("Resolving %s: Aggressive brute yaw %.0f (streak: %d)", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw, data.miss_streak))
        return data.resolved_yaw
    end

    if velocity > 5 and data.last_velocity < 5 then
        data.resolved_yaw = lby
        data.miss_streak = 0
        log_message(string.format("Resolving %s: LBY yaw %.0f (moving)", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw))
    elseif math.abs(normalize_angle(lby - data.last_lby)) > settings.desync_sensitivity then
        data.resolved_yaw = lby
        data.miss_streak = 0
        log_message(string.format("Resolving %s: LBY yaw %.0f (LBY update)", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw))
    elseif math.abs(normalize_angle(anim_yaw - data.last_yaw)) > settings.desync_sensitivity then
        data.brute_index = (data.brute_index % #brute_angles) + 1
        data.resolved_yaw = brute_angles[data.brute_index]
        log_message(string.format("Resolving %s: Brute yaw %.0f (anim delta)", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw))
    else
        if data.desync_side ~= 0 then
            data.resolved_yaw = normalize_angle(anim_yaw + data.desync_side * 58)
            log_message(string.format("Resolving %s: Desync yaw %.0f (side: %d)", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw, data.desync_side))
        else
            data.resolved_yaw = anim_yaw
            log_message(string.format("Resolving %s: Anim yaw %.0f", entity.get_player_name(entindex) or "Unknown", data.resolved_yaw))
        end
    end

    data.last_yaw = anim_yaw
    data.last_lby = lby
    data.last_velocity = velocity
    return data.resolved_yaw
end

-- Обработка выстрелов
local function on_weapon_fire(event)
    if not settings.enabled then return end
    local userid = event.userid
    local local_player = entity.get_local_player()
    if client.userid_to_entindex(userid) == local_player then
        local target = client.current_threat()
        if target and entity.is_enemy(target) then
            last_shot[target] = { time = get_time(), hit = false }
            log_message(string.format("Shot at %s", entity.get_player_name(target) or "Unknown"))
        end
    end
end

-- Обработка попаданий
local function on_player_hurt(event)
    if not settings.enabled then return end
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)
    local local_player = entity.get_local_player()
    if attacker == local_player and entity.is_enemy(victim) then
        init_player(victim)
        resolver_data[victim].hits = resolver_data[victim].hits + 1
        resolver_data[victim].miss_streak = 0
        if last_shot[victim] and get_time() - last_shot[victim].time < 0.1 then
            last_shot[victim].hit = true
        end
        log_message(string.format("Hit %s, hits: %d, yaw: %.0f", entity.get_player_name(victim) or "Unknown", resolver_data[victim].hits, resolver_data[victim].resolved_yaw))
    end
end

-- Проверка промахов
local function check_misses()
    if not settings.enabled then return end
    for entindex, shot in pairs(last_shot) do
        if get_time() - shot.time > 0.1 and not shot.hit and entity.is_enemy(entindex) then
            init_player(entindex)
            resolver_data[entindex].misses = resolver_data[entindex].misses + 1
            resolver_data[entindex].miss_streak = resolver_data[entindex].miss_streak + 1
            local speed = math.floor(settings.brute_speed)
            resolver_data[entindex].brute_index = (resolver_data[entindex].brute_index + speed) % #brute_angles + 1
            resolver_data[entindex].resolved_yaw = brute_angles[resolver_data[entindex].brute_index]
            log_message(string.format("Missed %s, misses: %d, streak: %d, switching to yaw %.0f", entity.get_player_name(entindex) or "Unknown", resolver_data[entindex].misses, resolver_data[entindex].miss_streak, resolver_data[entindex].resolved_yaw))
            last_shot[entindex] = nil
        end
    end
end

-- Применение резолвера
local function on_run_command()
    if not settings.enabled then return end
    local enemies = entity.get_players(true)
    for _, entindex in ipairs(enemies) do
        if entity.is_alive(entindex) then
            resolve_yaw(entindex)
        end
    end
end

-- Визуализация
local function on_paint()
    if not settings.enabled or not settings.visualize then return end
    check_misses()
    local enemies = entity.get_players(true)
    for _, entindex in ipairs(enemies) do
        if entity.is_alive(entindex) and resolver_data[entindex] then
            local data = resolver_data[entindex]
            local x, y, z = entity.get_origin(entindex)
            local screen_x, screen_y = renderer.world_to_screen(x, y, z + 70)

            if screen_x and screen_y then
                local color_r, color_g, color_b = 255, 165, 0
                if data.hits > data.misses + 2 then
                    color_r, color_g, color_b = 0, 255, 0
                elseif data.misses > data.hits + 2 then
                    color_r, color_g, color_b = 255, 0, 0
                end
                if data.miss_streak >= 3 and math.floor(get_time() * 4) % 2 == 0 then
                    color_r, color_g, color_b = 255, 255, 255
                end

                local text = string.format("Yaw: %.0f (H:%d M:%d)", data.resolved_yaw, data.hits, data.misses)
                renderer.text(screen_x, screen_y, color_r, color_g, color_b, 255, "c", 0, text)

                local angle_rad = math.rad(data.resolved_yaw)
                local length = 40
                local end_x = x + math.cos(angle_rad) * length
                local end_y = y + math.sin(angle_rad) * length
                local end_screen_x, end_screen_y = renderer.world_to_screen(end_x, end_y, z + 70)
                if end_screen_x and end_screen_y then
                    renderer.line(screen_x, screen_y, end_screen_x, end_screen_y, color_r, color_g, color_b, 255)
                end
            end
        end
    end
end

-- Регистрация событий
client.set_event_callback("weapon_fire", on_weapon_fire)
client.set_event_callback("player_hurt", on_player_hurt)
client.set_event_callback("run_command", on_run_command)
client.set_event_callback("paint", on_paint)
client.set_event_callback("game_newmap", function()
    resolver_data = {}
    last_shot = {}
end)
client.set_event_callback("shutdown", function()
    resolver_data = {}
    last_shot = {}
end)