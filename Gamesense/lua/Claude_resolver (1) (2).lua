--version 1.0.2
local ffi = require("ffi")
local bit = require("bit")
local vector = require("vector")

-- Расширенные функции анимации
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function smooth_step(x)
    return x * x * (3 - 2 * x)
end

local function smoother_step(x)
    return x * x * x * (x * (x * 6 - 15) + 10) -- Улучшенная функция сглаживания
end

local function ease_out_elastic(x)
    local c4 = (2 * math.pi) / 3
    if x == 0 then return 0 end
    if x == 1 then return 1 end
    return math.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1
end

local function ease_out_back(x)
    local c1 = 1.70158
    local c3 = c1 + 1
    return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2)
end

local function ease_in_out_cubic(x)
    return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2
end

local function ease_out_bounce(x)
    local n1 = 7.5625
    local d1 = 2.75
    
    if (x < 1 / d1) then
        return n1 * x * x
    elseif (x < 2 / d1) then
        x = x - 1.5 / d1
        return n1 * x * x + 0.75
    elseif (x < 2.5 / d1) then
        x = x - 2.25 / d1
        return n1 * x * x + 0.9375
    else
        x = x - 2.625 / d1
        return n1 * x * x + 0.984375
    end
end

-- Анимационные переменные состояния
local start_time = globals.realtime()
local alpha = 0
local animation_phase = 0 -- 0: появление, 1: прогресс, 2: завершение, 3: затухание
local progress_value = 0
local text_alpha = 0
local particles = {} -- Для эффекта частиц
local loading_text = "Loading..."
local loading_messages = {
    "Initializing systems...",
    "Preparing resources...",
    "Loading modules...",
    "Configuring settings...",
    "Almost there..."
}
local current_message_index = 1
local message_change_time = 0

-- Конфигурация времени анимации
local fade_in_duration = 0.8
local progress_duration = 3.5
local completion_duration = 1.0
local display_duration = 1.5
local fade_out_duration = 1.0
local message_change_interval = 0.8

-- Функция создания частиц
local function create_particles(x, y, count, color_r, color_g, color_b)
    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local speed = math.random() * 2 + 1
        local size = math.random() * 3 + 1
        local life = math.random() * 1.5 + 0.5
        
        table.insert(particles, {
            x = x,
            y = y,
            vx = math.cos(angle) * speed,
            vy = math.sin(angle) * speed,
            size = size,
            max_size = size,
            life = life,
            max_life = life,
            r = color_r + math.random(-20, 20),
            g = color_g + math.random(-20, 20),
            b = color_b + math.random(-20, 20)
        })
    end
end

-- Функция обновления и отрисовки частиц
local function update_and_draw_particles(dt, alpha_mult)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.x = p.x + p.vx * dt
        p.y = p.y + p.vy * dt
        p.life = p.life - dt
        
        -- Уменьшение скорости со временем для более естественного движения
        p.vx = p.vx * 0.95
        p.vy = p.vy * 0.95
        
        -- Уменьшение размера со временем
        p.size = p.max_size * (p.life / p.max_life)
        
        if p.life <= 0 then
            table.remove(particles, i)
        else
            local particle_alpha = (p.life / p.max_life) * 255 * alpha_mult
            renderer.circle(p.x, p.y, p.r, p.g, p.b, particle_alpha, p.size)
        end
    end
end

-- Функция отрисовки прогресс-бара с эффектами
local function draw_progress_bar(x, y, width, height, progress, r, g, b, a)
    local bar_radius = height / 2
    local inner_width = width - height -- Учитываем закругления на концах
    local progress_width = inner_width * progress
    
    -- Рисуем фон прогресс-бара (закругленный прямоугольник)
    -- Левый круг
    renderer.circle_outline(x + bar_radius, y + bar_radius, 40, 40, 40, a * 0.3, bar_radius, 0, 1, 2)
    -- Правый круг
    renderer.circle_outline(x + width - bar_radius, y + bar_radius, 40, 40, 40, a * 0.3, bar_radius, 0, 1, 2)
    -- Центральная часть
    renderer.rectangle(x + bar_radius, y, inner_width, height, 40, 40, 40, a * 0.3)
    
    -- Рисуем внутреннюю тень для эффекта глубины
    renderer.rectangle(x + bar_radius, y + height - 2, inner_width, 1, 0, 0, 0, a * 0.1)
    
    -- Рисуем заполненную часть прогресс-бара
    if progress > 0 then
        -- Левый круг (всегда виден, если прогресс > 0)
        renderer.circle(x + bar_radius, y + bar_radius, r, g, b, a, bar_radius)
        
        -- Центральная часть
        if progress_width > 0 then
            renderer.rectangle(x + bar_radius, y, progress_width, height, r, g, b, a)
        end
        
        -- Правый круг (виден только если прогресс достиг правого края)
        if progress >= 1 then
            renderer.circle(x + width - bar_radius, y + bar_radius, r, g, b, a, bar_radius)
        else if progress_width > 0 then
            -- Рисуем частичный круг на конце прогресса
            local end_x = x + bar_radius + progress_width
            renderer.circle(end_x, y + bar_radius, r, g, b, a, bar_radius)
            
            -- Добавляем свечение на конце прогресса
            renderer.circle(end_x, y + bar_radius, r, g, b, a * 0.3, bar_radius * 1.5)
        end
        end
    end
    
    -- Добавляем эффект блика на прогресс-баре
    if progress > 0.05 then
        local highlight_width = width * 0.1
        local highlight_x = x + bar_radius + (progress_width - highlight_width) * (0.6 + 0.4 * math.sin(globals.realtime() * 1.5))
        
        -- Ограничиваем позицию блика внутри видимой части прогресса
        highlight_x = math.max(x + bar_radius, math.min(highlight_x, x + bar_radius + progress_width - highlight_width))
        
        -- Рисуем блик с градиентом
        for i = 0, highlight_width, 1 do
            local highlight_alpha = a * 0.2 * math.sin((i / highlight_width) * math.pi)
            renderer.rectangle(highlight_x + i, y + 2, 1, height - 4, 255, 255, 255, highlight_alpha)
        end
    end
    
    -- Добавляем пульсирующее свечение вокруг прогресс-бара
    local pulse = (math.sin(globals.realtime() * 2) * 0.5 + 0.5) * 0.3
    renderer.rectangle(x + bar_radius, y - 2, inner_width, 1, r, g, b, a * pulse)
    renderer.rectangle(x + bar_radius, y + height + 1, inner_width, 1, r, g, b, a * pulse)
    
    -- Создаем частицы на конце прогресс-бара
    if globals.realtime() - start_time > fade_in_duration and progress < 1 and math.random() < 0.1 then
        local particle_x = x + bar_radius + progress_width
        local particle_y = y + math.random() * height
        create_particles(particle_x, particle_y, math.random(1, 2), r, g, b)
    end
    
    -- Создаем эффект завершения при достижении 100%
    if progress >= 1 and animation_phase == 1 then
        create_particles(x + width - bar_radius, y + bar_radius, 20, r, g, b)
        animation_phase = 2 -- Переходим к фазе завершения
    end
end

-- Функция отрисовки текста с эффектами
local function draw_loading_text(x, y, text, r, g, b, a, progress)
    local font = 0 -- Используем стандартный шрифт
    local text_width = renderer.measure_text(font, text)
    
    -- Рисуем тень для текста
    renderer.text(x, y + 1, 0, 0, 0, a * 0.6, "c", font, text)
    
    -- Рисуем основной текст
    renderer.text(x, y, r, g, b, a, "c", font, text)
    
    -- Добавляем анимированную точку в конце текста "Loading..."
    if text == "Loading..." then
        local dots = math.floor((globals.realtime() * 3) % 4)
        local dot_text = string.rep(".", dots)
        
        -- Измеряем ширину текста "Loading"
        local loading_width = renderer.measure_text(font, "Loading")
        
        -- Рисуем анимированные точки
        renderer.text(x + loading_width/2, y, r, g, b, a, "l", font, dot_text)
    end
    
    -- Добавляем процент загрузки
    if progress < 1 then
        local percent_text = math.floor(progress * 100) .. "%"
        renderer.text(x, y + 20, r, g, b, a, "c", font, percent_text)
    else
        local complete_text = ""
        renderer.text(x, y + 20, r, g, b, a, "c", font, complete_text)
    end
end

-- Основной callback отрисовки
client.set_event_callback('paint_ui', function()
    local screen = vector(client.screen_size())
    local size = vector(screen.x, screen.y)
    local center_x, center_y = screen.x/2, screen.y/2
    
    local current_time = globals.realtime()
    local elapsed = current_time - start_time
    local dt = globals.frametime() -- Для анимации частиц
    
    -- Определяем цвета - Небесно-голубые оттенки
    local r1 = 65  -- Светло-голубой
    local g1 = 170
    local b1 = 235
    local r2 = 30  -- Более насыщенный голубой
    local g2 = 144
    local b2 = 255
    
    -- Добавляем небольшую пульсацию цветов для более живого эффекта
    local pulse = math.sin(current_time * 0.5) * 0.1 + 0.9
    r1 = r1 * pulse
    g1 = g1 * pulse
    b1 = b1 * pulse
    
    local r = (r1 + r2) / 2
    local g = (g1 + g2) / 2
    local b = (b1 + b2) / 2
    
    -- Определяем фазу анимации и прогресс
    local total_duration = fade_in_duration + progress_duration + completion_duration + display_duration + fade_out_duration
    
    if elapsed < fade_in_duration then
        -- Фаза появления
        animation_phase = 0
        local progress = elapsed / fade_in_duration
        alpha = lerp(0, 255, smoother_step(progress))
        progress_value = 0
    elseif elapsed < fade_in_duration + progress_duration then
        -- Фаза прогресса
        animation_phase = 1
        local progress = (elapsed - fade_in_duration) / progress_duration
        progress_value = smoother_step(progress)
        alpha = 255
        
        -- Обновляем текст сообщения
        if current_time - message_change_time > message_change_interval then
            message_change_time = current_time
            current_message_index = (current_message_index % #loading_messages) + 1
        end
    elseif elapsed < fade_in_duration + progress_duration + completion_duration then
        -- Фаза завершения
        animation_phase = 2
        local progress = (elapsed - fade_in_duration - progress_duration) / completion_duration
        progress_value = 1
        alpha = 255
    elseif elapsed < fade_in_duration + progress_duration + completion_duration + display_duration then
        -- Фаза отображения завершенного состояния
        animation_phase = 2
        progress_value = 1
        alpha = 255
    elseif elapsed < total_duration then
        -- Фаза затухания
        animation_phase = 3
        local progress = (elapsed - fade_in_duration - progress_duration - completion_duration - display_duration) / fade_out_duration
        alpha = lerp(255, 0, smoother_step(progress))
    else
        -- Анимация завершена
        return
    end
    
    -- Рисуем фон с градиентом и виньеткой
    local bg_alpha = math.floor(alpha * 0.8)
    
    -- Создаем эффект виньетки (затемнение по краям)
    for i = 0, 10 do
        local radius = math.max(size.x, size.y) * (1.2 - i * 0.05)
        local vignette_alpha = bg_alpha * (i / 10) * 0.15
        renderer.circle(center_x, center_y, 0, 0, 0, vignette_alpha, radius)
    end
    
    -- Основной фон
    renderer.rectangle(0, 0, size.x, size.y, 0, 0, 0, bg_alpha * 0.7)
    
    -- Добавляем легкий градиентный эффект на фоне
    local gradient_height = size.y / 2
    for i = 0, gradient_height, 2 do
        local gradient_alpha = bg_alpha * 0.05 * (1 - i / gradient_height)
        renderer.rectangle(0, center_y - i, size.x, 2, r, g, b, gradient_alpha)
        renderer.rectangle(0, center_y + i, size.x, 2, r, g, b, gradient_alpha)
    end
    
    -- Размеры и позиция прогресс-бара
    local bar_width = 300
    local bar_height = 12
    local bar_x = center_x - bar_width / 2
    local bar_y = center_y
    
    -- Рисуем прогресс-бар
    draw_progress_bar(bar_x, bar_y, bar_width, bar_height, progress_value, r, g, b, alpha)
    
    -- Обновляем и рисуем частицы
    update_and_draw_particles(dt, alpha / 255)
    
    -- Рисуем текст загрузки
    if animation_phase < 2 then
        -- Во время загрузки показываем сообщения о процессе
        draw_loading_text(center_x, center_y - 30, loading_messages[current_message_index], r, g, b, alpha, progress_value)
    else
        -- После завершения показываем сообщение об успешной загрузке
        draw_loading_text(center_x, center_y - 30, "Loaded Successfully", r, g, b, alpha, progress_value)
    end
    
    -- Добавляем декоративные элементы
    if animation_phase >= 2 then
        -- Рисуем круги успеха при завершении
        local completion_progress = math.min(1, (elapsed - fade_in_duration - progress_duration) / (completion_duration * 0.5))
        if completion_progress < 1 then
            local circle_alpha = alpha * 0.2 * completion_progress
            local circle_size = 50 * ease_out_bounce(completion_progress)
            
            -- Рисуем несколько кругов для более премиального эффекта
            renderer.circle_outline(center_x, center_y, r, g, b, circle_alpha, circle_size, 0, 1, 2)
            renderer.circle_outline(center_x, center_y, r, g, b, circle_alpha * 0.7, circle_size * 1.1, 0, 1, 1.5)
            renderer.circle_outline(center_x, center_y, r, g, b, circle_alpha * 0.4, circle_size * 1.2, 0, 1, 1)
        end
    end
    
    -- Добавляем линию под текстом при завершении
    if animation_phase >= 2 then
        local text = "Loaded Successfully"
        local font = 0
        local text_width = renderer.measure_text(font, text)
        local line_y = center_y - 10
        
        -- Анимация появления линии
        local line_progress = math.min(1, (elapsed - fade_in_duration - progress_duration) / completion_duration)
        local line_width = text_width * ease_out_elastic(line_progress)
        
        renderer.rectangle(center_x - line_width/2, line_y, line_width, 2, r, g, b, alpha * 0.7)
    end
end)

local adaptive_resolver = {
    players = {},
    angle_sets = {
        standard = {0, 58, -58, 29, -29, 15, -15, 45, -45},
        extended = {0, 58, -58, 29, -29, 15, -15, 45, -45, 35, -35, 19, -19, 60, -60}
    },
    miss_memory = {},
    hit_memory = {},
    current_mode = "standard",
    last_update = 0,
    update_interval = 0.1,
    learning_rate = 0.2,
    confidence_threshold = 0.6,
    auto_switch_threshold = 3,
    debug_mode = false
}


function has_value(tab, val)
    if type(tab) ~= "table" then
        return false
    end
    
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end


local merged_enable = ui.new_checkbox("LUA", "A", "Enable Claude")
local merged_mode = ui.new_combobox("LUA", "A", "Mode", {"Aggressive", "Balanced", "Conservative", "Auto", "None"})
local merged_performance = ui.new_checkbox("LUA", "A", "Performance Mode")

local adaptive_resolver_checkbox = ui.new_checkbox("LUA", "A", "Adaptive Resolver")
local miss_analysis = ui.new_checkbox("LUA", "A", "Miss Analysis")
local miss_threshold = ui.new_slider("LUA", "A", "Analysis Threshold", 1, 10, 3, true, "x")
local prediction_enabled = ui.new_checkbox("LUA", "A", "Enable Prediction")

local bruteforce_angles = ui.new_multiselect("LUA", "A", "Bruteforce Angles", {"0°", "58°", "-58°", "29°", "-29°", "15°", "-15°", "45°", "-45°"})

local console_filter = ui.new_checkbox("LUA", "A", "Console Filter")
local player_list_enabled = ui.new_checkbox("LUA", "B", "Player List")
local player_list = ui.new_listbox("LUA", "B", "Target Players", {})
local player_list_data = {}
local auto_target_enabled = ui.new_checkbox("LUA", "B", "Auto Target")
local adaptive_mode_enabled = ui.new_checkbox("LUA", "A", "Adaptive Angle Mode")
local adaptive_mode_options = ui.new_multiselect("LUA", "A", "Adaptive Options", {
    "Auto-learn angles", 
    "Per-player adaptation",
    "Aggressive learning",
    "Extended angle set",
    "Debug output"
})
local adaptive_reset_button = ui.new_button("LUA", "A", "Reset Adaptive Data", function()
    adaptive_resolver:reset_data()
    client.log("[Claude] Adaptive angle data has been reset")
end)
function update_ui_visibility()
    local main_enabled = ui.get(merged_enable)
    
    -- Основные элементы UI
    ui.set_visible(merged_mode, main_enabled)
    ui.set_visible(merged_performance, main_enabled)
    ui.set_visible(adaptive_resolver_checkbox, main_enabled)
    ui.set_visible(miss_analysis, main_enabled)
    ui.set_visible(prediction_enabled, main_enabled)
    ui.set_visible(bruteforce_angles, main_enabled)
    ui.set_visible(console_filter, main_enabled)
    ui.set_visible(player_list_enabled, main_enabled)
    ui.set_visible(auto_target_enabled, main_enabled)
    
    -- Adaptive mode элементы
    ui.set_visible(adaptive_mode_enabled, main_enabled)
    ui.set_visible(adaptive_mode_options, main_enabled and ui.get(adaptive_mode_enabled))
    ui.set_visible(adaptive_reset_button, main_enabled and ui.get(adaptive_mode_enabled))
    
    -- Miss analysis элементы
    local miss_analysis_enabled = main_enabled and ui.get(miss_analysis)
    ui.set_visible(miss_threshold, miss_analysis_enabled)
    
    -- Player list элементы
    local player_list_visible = main_enabled and ui.get(player_list_enabled) and not ui.get(auto_target_enabled)
    ui.set_visible(player_list, player_list_visible)
    
    -- Исправление: Принудительно показываем все основные элементы UI, если включен основной чекбокс
    if main_enabled then
        -- Показываем все режимы резольвера
        ui.set_visible(merged_mode, true)
        ui.set_visible(adaptive_resolver_checkbox, true)
        ui.set_visible(miss_analysis, true)
        ui.set_visible(prediction_enabled, true)
        
        -- Показываем все опции брутфорса
        ui.set_visible(bruteforce_angles, true)
        
        -- Показываем все опции адаптивного режима
        ui.set_visible(adaptive_mode_enabled, true)
        if ui.get(adaptive_mode_enabled) then
            ui.set_visible(adaptive_mode_options, true)
            ui.set_visible(adaptive_reset_button, true)
        end
    end
end

-- Register callbacks for UI changes
ui.set_callback(merged_enable, update_ui_visibility)
ui.set_callback(miss_analysis, update_ui_visibility)
ui.set_callback(player_list_enabled, update_ui_visibility)
ui.set_callback(auto_target_enabled, update_ui_visibility)
update_ui_visibility()



local screen_w, screen_h = client.screen_size()
local function safe_get(obj, key, default)
    if obj == nil then return default end
    return obj[key] or default
end
local roll_resolver = {
    players = {},
    last_update = 0,
    update_rate = 0.05,
    miss_history = {},
    mode_effectiveness = {
        A = { hits = 0, misses = 0 },
        B = { hits = 0, misses = 0 },
        C = { hits = 0, misses = 0 }
    },
    console_filter = { enabled = true, filter_text = "Claude" }
}
local function trace_line(x1, y1, z1, x2, y2, z2)
    local fraction, entindex = client.trace_line(entity.get_local_player(), x1, y1, z1, x2, y2, z2)
    return fraction
end

local selected_player_idx = nil

ui.set_callback(player_list, function()
    local index = ui.get(player_list)
    selected_player_idx = player_list_data[index + 1] 
    
    if selected_player_idx then
        local name = entity.get_player_name(selected_player_idx)
        client.log("[Claude] Выбран игрок: " .. name)
        
        if not roll_resolver.players[selected_player_idx] then
            roll_resolver:init_player(selected_player_idx)
        end
    end
end)

client.set_event_callback("post_config_load", function()
    update_ui_visibility()
    update_adaptive_ui_visibility()
end)


local function clamp(v, min_val, max_val)
    if min_val > max_val then
        min_val, max_val = max_val, min_val
    end
    if v > max_val then return max_val end
    if v < min_val then return min_val end
    return v
end

function angle_diff(a, b)
    local diff = normalize_angle(a - b)
    return diff
end

function normalize_angle(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end
function roll_resolver:safe_init()
    self.players = self.players or {}
    self.last_update = self.last_update or 0
    self.update_rate = self.update_rate or 0.05
    self.miss_history = self.miss_history or {}
    self.position_history = self.position_history or {}
    
    -- Ensure mode_effectiveness is properly initialized
    self.mode_effectiveness = self.mode_effectiveness or {
        ["Aggressive"] = { hits = 0, misses = 0 },
        ["Balanced"] = { hits = 0, misses = 0 },
        ["Conservative"] = { hits = 0, misses = 0 }
    }
    
    self.console_filter = self.console_filter or { 
        enabled = true, 
        filter_text = "Claude" 
    }
    
    -- Initialize players
    local players = entity.get_players(true)
    for i = 1, #players do
        local idx = players[i]
        if not self.players[idx] then
            self:init_player(idx)
            if not adaptive_resolver then
                adaptive_resolver = adaptive_resolver or {}
                adaptive_resolver.players = adaptive_resolver.players or {}
        end
    end
  end
end


local function angle_diff(dest, src)
    local delta = (dest - src) % 360
    if delta > 180 then 
        delta = delta - 360
    elseif delta < -180 then 
        delta = delta + 360 
    end
    return delta
end

local function angle_lerp(a, b, t)
    local delta = angle_diff(b, a)
    return a + delta * t
end

local function angle_normalize(angle)
    angle = angle % 360
    if angle < 0 then angle = angle + 360 end
    return angle
end

local function update_player_list()
    local players = entity.get_players(true)
    local player_names = {}
    player_list_data = {}
    
    for i = 1, #players do
        local idx = players[i]
        local name = entity.get_player_name(idx)
        if name then
            table.insert(player_names, name)
            player_list_data[#player_names] = idx
        end
    end
    
    ui.update(player_list, player_names)
end
ui.set_callback(player_list, function()
    local index = ui.get(player_list)
    selected_player_idx = player_list_data[index + 1] 
    
    if selected_player_idx then
        local name = entity.get_player_name(selected_player_idx)
        client.log("[Claude] Выбран игрок: " .. name)
        
        if not roll_resolver.players[selected_player_idx] then
            roll_resolver:init_player(selected_player_idx)
        end
    end
end)

function get_current_target()
    -- Если auto-targeting включен, находим лучшую цель автоматически
    if ui.get(auto_target_enabled) then
        local local_player = entity.get_local_player()
        if not local_player or not entity.is_alive(local_player) then return nil end
        
        local players = entity.get_players(true)
        if #players == 0 then return nil end
        
        local closest_fov = 180
        local closest_player = nil
        local x, y = client.screen_size()
        local view_x, view_y = x/2, y/2
        
        for i=1, #players do
            local idx = players[i]
            if entity.is_alive(idx) then
                local wx, wy, wz = entity.get_prop(idx, "m_vecOrigin")
                if wx then
                    local sx, sy = renderer.world_to_screen(wx, wy, wz)
                    if sx and sy then
                        local fov = math.sqrt((sx - view_x)^2 + (sy - view_y)^2)
                        if fov < closest_fov then
                            closest_fov = fov
                            closest_player = idx
                        end
                    end
                end
            end
        end
        
        return closest_player
    else
        -- Используем выбор из player_list, если auto-targeting отключен
        if ui.get(player_list_enabled) and selected_player_idx and entity.is_alive(selected_player_idx) then
            return selected_player_idx
        end
    end
    
    return nil
end

local function normalize_angle(ang)
    while ang <= -180 do ang = ang + 360 end
    while ang > 180 do ang = ang - 360 end
    return ang
end

function log_debug(message)
    client.log("[Resolver Debug] " .. tostring(message))
end

local function vector_length_2d(x, y)
    return math.sqrt(x * x + y * y)
end

local function debug_log(msg)
    local rt = globals.realtime() or 0
    local seconds = math.floor(rt % 60)
    local minutes = math.floor((rt / 60) % 60)
    local hours   = math.floor(rt / 3600)
    local timestamp = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    client.log(string.format("[%s] %s", timestamp, msg))
end


ffi.cdef[[
    typedef struct {
        float x, y, z;
    } Vector3;

    typedef struct {
        float fraction;
        float fractionLeftSolid;
        bool  allSolid;
        bool  startSolid;
        float startpos[3];
        float endpos[3];
        struct {
            float x, y, z;
        } normal;
        float dist;
        unsigned char type;
        unsigned char signbits;
        unsigned char pad[2];
        float surface;
        int   hitgroup;
        short physicsbone;
        unsigned short worldSurfaceIndex;
        void* m_pEnt;
        int   hitbox;
    } trace_t;

    typedef struct {
        float matrix[3][4];
    } matrix3x4_t;

    typedef struct {
        char pad1[0x88];
        Vector3 velocity;
        float simulation_time;
        float old_simulation_time;
        char pad2[0x60];
        Vector3 origin;
        Vector3 view_angles;
        char pad3[0x4];
        float duck_amount;
        Vector3 eye_position;
        bool dormant;
        char pad4[0x8];
        float last_shot_time;
        int tick_base;
        int flags;
        float pose_params[24];
        float anim_layers[13][4];
        matrix3x4_t bone_matrix[128];
    } player_t;

    typedef void* (__thiscall* GetClientEntity_t)(void*, int);
]]

local interface_ptr = ffi.typeof("void***")
local raw_entity_list = client.create_interface("client.dll", "VClientEntityList003")
local entity_list = ffi.cast(interface_ptr, raw_entity_list)
local get_client_entity = ffi.cast("GetClientEntity_t", entity_list[0][3])


local function get_player_data(idx)
    local ptr = get_client_entity(entity_list, idx)
    if not ptr then return nil end
    local ent = ffi.cast("player_t*", ptr)
    if ent.dormant then return nil end
    return ent
end

local function safe_read_vector3(vec)
    if vec == nil then
        return {x = 0, y = 0, z = 0}, false
    end
    
    local ok_x, xval = pcall(function() return vec.x end)
    local ok_y, yval = pcall(function() return vec.y end)
    local ok_z, zval = pcall(function() return vec.z end)
    
    if not (ok_x and ok_y and ok_z) or (xval == nil) or (yval == nil) or (zval == nil) then
        return {x = 0, y = 0, z = 0}, false
    end
    
    return {x = xval, y = yval, z = zval}, true
end

local function predict_enemy_movement(idx, dt)
    if not idx or not entity.is_alive(idx) then return nil end
    
    local ent = get_player_data(idx)
    if not ent then 
        -- Return current position if we can't get player data
        local origin = {
            x = entity.get_prop(idx, "m_vecOrigin[0]") or 0,
            y = entity.get_prop(idx, "m_vecOrigin[1]") or 0,
            z = entity.get_prop(idx, "m_vecOrigin[2]") or 0,
        }
        return origin
    end
    
    local origin = {
        x = entity.get_prop(idx, "m_vecOrigin[0]") or 0,
        y = entity.get_prop(idx, "m_vecOrigin[1]") or 0,
        z = entity.get_prop(idx, "m_vecOrigin[2]") or 0,
    }
    
    local velocity, ok = safe_read_vector3(ent.velocity)
    if not ok then velocity = { x = 0, y = 0, z = 0 } end
    
    -- Initialize position_history if it doesn't exist
    if not roll_resolver.position_history then
        roll_resolver.position_history = {}
    end
    
    if not roll_resolver.position_history[idx] then
        roll_resolver.position_history[idx] = {}
    end
    
    -- Get previous position
    local prev_origin = {
        x = origin.x,
        y = origin.y,
        z = origin.z
    }
    
    if #roll_resolver.position_history[idx] > 0 then
        local last_pos = roll_resolver.position_history[idx][#roll_resolver.position_history[idx]]
        prev_origin.x = last_pos.x
        prev_origin.y = last_pos.y
        prev_origin.z = last_pos.z
    end
    
    -- Calculate acceleration (with safety checks)
    local accel = {
        x = 0, y = 0, z = 0
    }
    
    if dt > 0 then
        accel.x = (velocity.x - (prev_origin.x - origin.x) / dt) * 0.85
        accel.y = (velocity.y - (prev_origin.y - origin.y) / dt) * 0.85
        accel.z = (velocity.z - (prev_origin.z - origin.z) / dt) * 0.85
    end
    
    -- Get movement pattern multiplier
    local movement_pattern = 1.0 
    
    if roll_resolver.players and roll_resolver.players[idx] and 
       roll_resolver.players[idx].movement_patterns then
        movement_pattern = roll_resolver.players[idx].movement_patterns.multiplier or 1.0
    end
    
    -- Store current position in history
    table.insert(roll_resolver.position_history[idx], {
        x = origin.x,
        y = origin.y,
        z = origin.z,
        time = globals.realtime()
    })
    
    -- Limit history size
    if #roll_resolver.position_history[idx] > 5 then
        table.remove(roll_resolver.position_history[idx], 1)
    end
    
    -- Analyze movement pattern
    local pattern_modifier = 1.0
    if #roll_resolver.position_history[idx] >= 3 then
        local positions = roll_resolver.position_history[idx]
        local last_pos = positions[#positions]
        local prev_pos = positions[#positions-1]
        local prev_prev_pos = positions[#positions-2]
        
        -- Calculate movement vectors
        local v1x = prev_pos.x - prev_prev_pos.x
        local v1y = prev_pos.y - prev_prev_pos.y
        local v2x = last_pos.x - prev_pos.x
        local v2y = last_pos.y - prev_pos.y
        
        -- Calculate angle between vectors
        local dot_product = v1x * v2x + v1y * v2y
        local mag1 = math.sqrt(v1x * v1x + v1y * v1y)
        local mag2 = math.sqrt(v2x * v2x + v2y * v2y)
        
        if mag1 > 0 and mag2 > 0 then
            local angle_cos = dot_product / (mag1 * mag2)
            -- Clamp to avoid acos domain errors
            angle_cos = clamp(angle_cos, -1, 1)
            local angle = math.acos(angle_cos)
            
            -- Adjust pattern modifier based on angle
            if angle > math.rad(30) then
                pattern_modifier = 0.7 -- Sharp turn
            elseif angle > math.rad(10) then
                pattern_modifier = 0.85 -- Moderate turn
            end
        end
    end
    
    -- Apply pattern modifier
    movement_pattern = movement_pattern * pattern_modifier
    
    -- Calculate predicted position
    local predicted = {
        x = origin.x + (velocity.x * dt * movement_pattern) + (accel.x * dt * dt * 0.5),
        y = origin.y + (velocity.y * dt * movement_pattern) + (accel.y * dt * dt * 0.5),
        z = origin.z + (velocity.z * dt * movement_pattern) + (accel.z * dt * dt * 0.5)
    }
    
    -- Check if player is on ground
    local flags = entity.get_prop(idx, "m_fFlags")
    local on_ground = bit.band(flags or 0, 1) ~= 0
    
    -- Adjust Z position if on ground
    if on_ground then
        predicted.z = origin.z 
    end
    
    -- Check for collisions
    local fraction = trace_line(
        origin.x, origin.y, origin.z + 64, 
        predicted.x, predicted.y, predicted.z + 64 
    )
    
    -- Adjust prediction if collision detected
    if fraction < 1.0 then
        predicted.x = origin.x + (predicted.x - origin.x) * fraction * 0.9
        predicted.y = origin.y + (predicted.y - origin.y) * fraction * 0.9
    end
    
    return predicted
end

local function enable_force_yaw(yaw) 
    local local_player = entity.get_local_player()
    if local_player then
        entity.set_prop(local_player, "m_angEyeAngles[1]", yaw)
        debug_log("Force yaw set to: " .. yaw)
    end
end

function roll_resolver:on_aim_hit(e)
    if not ui.get(merged_enable) then return end
    local idx = e.target
    
    if not self.players[idx] then
        self:init_player(idx)
    end
    
    local data = self.players[idx]
    data.hits = (data.hits or 0) + 1
    data.hit_registered = true
    data.confidence = math.min(1.0, data.confidence + 0.2)
    
    if data.resolved_angles then
        self:add_angle_to_history(idx, "yaw", data.resolved_angles.yaw, 2.0)
        self:add_angle_to_history(idx, "pitch", data.resolved_angles.pitch, 2.0)
        self:add_angle_to_history(idx, "roll", data.resolved_angles.roll, 2.0)
    end
    
    if data.state == "SCAN" and data.confidence > 0.6 then
        data.state = "LOCKED"
    end
    
    local total_shots = (data.hits or 0) + (data.misses or 0)
    local accuracy = math.floor((data.hits or 0) / math.max(1, total_shots) * 100)
    local name = entity.get_player_name(idx) or "Unknown"
    debug_log(string.format("Hit %s: accuracy=%d%%", name, accuracy))
end

local nade_resolver = {
    layers      = {},
    safepoints  = {},
    cache       = {},
    shots_fired = {},
    history     = {}
}

ffi.cdef[[
    typedef struct {
        float m_flFeetYaw;
        float m_flFeetSpeedForwardsOrSideWays;
        float m_flFeetSpeedUnknownForwardOrSideways;
        float m_flFeetCycle;
        float m_flMoveWeight;
        float pad[64];
    } CCSGOPlayerAnimState;
]]

local function get_animstate(e_index)
    local base_ptr = entity.get_prop(e_index, "m_hAnimationState")
    if not base_ptr then return nil end
    local animstate = ffi.cast("CCSGOPlayerAnimState*", base_ptr)
    return animstate
end

local function is_lby_flexing(e_index)
    local vx = entity.get_prop(e_index, "m_vecVelocity[0]") or 0
    local vy = entity.get_prop(e_index, "m_vecVelocity[1]") or 0
    local speed_2d = vector_length_2d(vx, vy)
    return speed_2d < 1.0
end        
function nade_resolver:getMaxDesyncDelta(idx)
        local animstate = get_animstate(idx)
        if animstate then
            local vx = entity.get_prop(idx, "m_vecVelocity[0]") or 0
            local vy = entity.get_prop(idx, "m_vecVelocity[1]") or 0
            local speed = vector_length_2d(vx, vy)
            
            local duck_amount = entity.get_prop(idx, "m_flDuckAmount") or 0
            
            local speed_factor = clamp(animstate.m_flFeetSpeedForwardsOrSideWays, 0, 1)
            local run_factor = clamp(1.0 - (0.3 * speed_factor), 0, 1)
            local duck_factor = animstate.m_flMoveWeight * 0.3 + duck_amount * 0.15
            
            local weapon = entity.get_player_weapon(idx)
            local weapon_type = weapon and entity.get_prop(weapon, "m_iItemDefinitionIndex") or 0
            
            local weapon_modifier = 1.0
            if weapon_type == 9 or weapon_type == 40 or weapon_type == 38 then  
                weapon_modifier = 0.85
            elseif weapon_type == 14 or weapon_type == 28 then  
                weapon_modifier = 0.9
            end
            
            local flags = entity.get_prop(idx, "m_fFlags")
            local on_ground = bit.band(flags or 0, 1) ~= 0
            local air_modifier = on_ground and 1.0 or 0.85
            
            return 58.0 * (run_factor + duck_factor) * weapon_modifier * air_modifier
        end
        return 58.0 
    end
function nade_resolver:updateLayers(idx)
    local animstate = get_animstate(idx)
    if animstate then
        self.layers[idx] = {
            feet_speed = animstate.m_flFeetSpeedForwardsOrSideWays,
            feet_cycle = animstate.m_flFeetCycle,
            move_weight = animstate.m_flMoveWeight 
        }
    else
        self.layers[idx] = {
            feet_speed = 0,
            feet_cycle = 0,
            move_weight = 0
        }
    end
end

function nade_resolver:updateSafety(idx, side, desync)  
    if not idx or not side or not desync then return end
    self.safepoints[idx] = self.safepoints[idx] or {}
    for i = 1, 5 do
        self.safepoints[idx][i] = self.safepoints[idx][i] or { m_flDesync = 0, m_playback_rate = nil }
    end
    
  
    local function update_point(point, desync_value)
        local current = self.safepoints[idx][point]
        current.m_flDesync = desync_value
        current.m_playback_rate = 1.0
    end
    

    if side < 0 then
        update_point(3, -math.abs(desync))
        update_point(5, -math.abs(desync) * 0.5)
    elseif side > 0 then
        update_point(2, math.abs(desync))
        update_point(4, math.abs(desync) * 0.5)
    else
        update_point(1, 0)
    end
    

    self.history[idx] = self.history[idx] or {}
    table.insert(self.history[idx], {
        time = globals.realtime(),
        desync = desync,
        side = side
    })
    
    if #self.history[idx] > 10 then
        table.remove(self.history[idx], 1)
    end
end

function nade_resolver:predictedFootYaw(old_feet_yaw, eye_yaw, lby, duck_amount, vx, vy, min_yaw, max_yaw)
    if not old_feet_yaw or not eye_yaw or not lby then
        return 0 
    end
    
    local foot_yaw = clamp(old_feet_yaw or 0, -180, 180)
    local delta = angle_diff(eye_yaw or 0, foot_yaw)
    
    local vx_safe = vx or 0
    local vy_safe = vy or 0
    local speed = vector_length_2d(vx_safe, vy_safe)
    local speed_factor = clamp(speed / 250, 0, 1)
    
    local duck_factor = (duck_amount or 0) * 0.5
    
    local dynamic_min = (min_yaw or -57) * (1 - speed_factor) * (1 - duck_factor)
    local dynamic_max = (max_yaw or 57) * (1 - speed_factor) * (1 - duck_factor)
    
    if delta > dynamic_max then foot_yaw = eye_yaw - dynamic_max end
    if delta < dynamic_min then foot_yaw = eye_yaw + dynamic_min end
    
    if speed < 1.0 and math.abs(angle_diff(foot_yaw, lby)) > 35 then
        foot_yaw = angle_lerp(foot_yaw, lby, 0.3)
    end
    
    return angle_normalize(foot_yaw)
end



-- Initialize player data
function adaptive_resolver:init_player(idx)
    if not idx or not entity.is_alive(idx) then return end
    
    local name = entity.get_player_name(idx) or "Unknown"
    
    self.players[idx] = {
        name = name,
        angle_weights = {},
        miss_count = 0,
        hit_count = 0,
        last_angles = {},
        best_angle = 0,
        confidence = 0,
        state = "LEARNING",
        last_update = globals.realtime(),
        consecutive_misses = 0,
        consecutive_hits = 0,
        angle_history = {},
        miss_reasons = {}
    }
    
    -- Initialize weights for all angles
    local angle_set = self:get_angle_set()
    for _, angle in ipairs(angle_set) do
        self.players[idx].angle_weights[angle] = 1.0 / #angle_set
    end
    
    client.log(string.format("[Claude] Initialized adaptive resolver for %s", name))
end

function adaptive_resolver:get_angle_set()
    local options = ui.get(adaptive_mode_options)
    local use_extended = false
    
    if type(options) == "table" then
        for i=1, #options do
            if options[i] == "Extended angle set" then
                use_extended = true
                break
            end
        end
    elseif options == "Extended angle set" then
        use_extended = true
    end
    
    return use_extended and self.angle_sets.extended or self.angle_sets.standard
end

local advanced_resolver = {
    players = {},
    patterns = {},
    last_update = 0
}

function advanced_resolver:init_player(idx)
    self.players[idx] = {
        angles = {},
        patterns = {},
        last_hit_angle = 0,
        hit_count = 0,
        miss_count = 0,
        state = "INIT"
    }
end

function advanced_resolver:analyze_patterns(idx)
end

function advanced_resolver:resolve(idx)
end

client.set_event_callback("setup_command", function(cmd)
    if not ui.get(merged_enable) then return end
    
    if ui.get(merged_mode) == "C" then
        local enemies = entity.get_players(true)
        for i = 1, #enemies do
            advanced_resolver:resolve(enemies[i])
        end
    elseif ui.get(merged_mode) == "A" then
    end
end)

-- Record a miss and update angle weights
function adaptive_resolver:record_miss(idx, angle, reason)
    log_debug("Запись промаха для игрока " .. tostring(idx) .. " с углом " .. tostring(angle) .. " (причина: " .. tostring(reason) .. ")")
    
    if not idx or not angle then 
        log_debug("Недопустимые параметры idx или angle")
        return 
    end
    
    if not self.players[idx] then
        log_debug("Инициализация игрока " .. tostring(idx))
        self:init_player(idx)
    end
    
    local player = self.players[idx]
    player.miss_count = player.miss_count + 1
    player.consecutive_misses = player.consecutive_misses + 1
    player.consecutive_hits = 0
    
    -- Сохраняем причину промаха
    player.miss_reasons[reason] = (player.miss_reasons[reason] or 0) + 1
    log_debug("Обновлена статистика причин промахов: " .. reason .. " = " .. tostring(player.miss_reasons[reason]))
    
    -- Добавляем в память промахов
    table.insert(player.angle_history, {
        angle = angle,
        result = "miss",
        time = globals.realtime(),
        reason = reason
    })
    log_debug("Добавлена запись в историю углов, новый размер: " .. tostring(#player.angle_history))
    
    -- Ограничиваем размер истории
    if #player.angle_history > 20 then
        table.remove(player.angle_history, 1)
        log_debug("Удалена старая запись из истории углов")
    end
    
    -- Обновляем веса - уменьшаем вес для угла промаха
    local options = ui.get(adaptive_mode_options)
    local aggressive = has_value(options, "Aggressive learning")
    local learning_rate = aggressive and self.learning_rate * 2 or self.learning_rate
    
    if player.angle_weights[angle] then
        local old_weight = player.angle_weights[angle]
        player.angle_weights[angle] = math.max(0.05, player.angle_weights[angle] - learning_rate)
        log_debug("Обновлен вес угла " .. tostring(angle) .. ": " .. tostring(old_weight) .. " -> " .. tostring(player.angle_weights[angle]))
        
        -- Нормализуем веса
        self:normalize_weights(idx)
    end
    
    -- Обновляем состояние на основе последовательных промахов
    if player.consecutive_misses >= self.auto_switch_threshold then
        local old_state = player.state
        player.state = "ADAPTING"
        player.confidence = math.max(0, player.confidence - 0.2)
        log_debug("Обновлено состояние: " .. tostring(old_state) .. " -> " .. player.state .. " (уверенность: " .. tostring(player.confidence) .. ")")
    end
    
    -- Находим лучший угол
    self:find_best_angle(idx)
end


-- Record a hit and update angle weights
function adaptive_resolver:record_hit(idx, angle)
    log_debug("Запись попадания для игрока " .. tostring(idx) .. " с углом " .. tostring(angle))
    
    if not idx or not angle then 
        log_debug("Недопустимые параметры idx или angle")
        return 
    end
    
    if not self.players[idx] then
        log_debug("Инициализация игрока " .. tostring(idx))
        self:init_player(idx)
    end
    
    local player = self.players[idx]
    player.hit_count = player.hit_count + 1
    player.consecutive_hits = player.consecutive_hits + 1
    player.consecutive_misses = 0
    
    -- Добавляем в память попаданий
    table.insert(player.angle_history, {
        angle = angle,
        result = "hit",
        time = globals.realtime()
    })
    log_debug("Добавлена запись в историю углов, новый размер: " .. tostring(#player.angle_history))
    
    -- Ограничиваем размер истории
    if #player.angle_history > 20 then
        table.remove(player.angle_history, 1)
        log_debug("Удалена старая запись из истории углов")
    end
    
    -- Обновляем веса - увеличиваем вес для успешного угла
    local options = ui.get(adaptive_mode_options)
    local aggressive = has_value(options, "Aggressive learning")
    local learning_rate = aggressive and self.learning_rate * 2 or self.learning_rate
    
    if player.angle_weights[angle] then
        local old_weight = player.angle_weights[angle]
        player.angle_weights[angle] = math.min(0.95, player.angle_weights[angle] + learning_rate)
        log_debug("Обновлен вес угла " .. tostring(angle) .. ": " .. tostring(old_weight) .. " -> " .. tostring(player.angle_weights[angle]))
        
        -- Нормализуем веса
        self:normalize_weights(idx)
    end
    
    -- Обновляем состояние на основе последовательных попаданий
    if player.consecutive_hits >= 2 then
        local old_state = player.state
        player.state = "RESOLVED"
        player.confidence = math.min(1.0, player.confidence + 0.2)
        player.best_angle = angle
        log_debug("Обновлено состояние: " .. tostring(old_state) .. " -> " .. player.state .. " (уверенность: " .. tostring(player.confidence) .. ")")
    end
    
    -- Находим лучший угол
    self:find_best_angle(idx)
end

-- Normalize weights to ensure they sum to 1
function adaptive_resolver:normalize_weights(idx)
    local player = self.players[idx]
    local total = 0
    
    for _, weight in pairs(player.angle_weights) do
        total = total + weight
    end
    
    if total > 0 then
        for angle, weight in pairs(player.angle_weights) do
            player.angle_weights[angle] = weight / total
        end
    else
        -- Reset weights if something went wrong
        local angle_set = self:get_angle_set()
        for _, angle in ipairs(angle_set) do
            player.angle_weights[angle] = 1.0 / #angle_set
        end
    end
end

-- Find the best angle based on current weights
function adaptive_resolver:find_best_angle(idx)
    log_debug("Начало find_best_angle для игрока " .. tostring(idx))
    
    if not self.players[idx] then
        log_debug("Игрок " .. tostring(idx) .. " не найден")
        return 0
    end
    
    local player = self.players[idx]
    log_debug("Получен игрок: " .. tostring(player.name or "неизвестно"))
    local best_angle = 0
    local best_weight = 0
    
    for angle, weight in pairs(player.angle_weights) do
        log_debug("Проверка угла " .. tostring(angle) .. " с весом " .. tostring(weight))
        if angle ~= nil and weight ~= nil and weight > best_weight then
            best_weight = weight
            best_angle = angle
            log_debug("Новый лучший угол: " .. tostring(best_angle) .. " с весом " .. tostring(best_weight))
        end
    end
    
    -- Если у нас низкая уверенность во всех углах, пробуем что-то новое
    if best_weight < 0.2 then
        log_debug("Низкая уверенность во всех углах, пробуем новый подход")
        
        local angle_set = self:get_angle_set()
        log_debug("Получен набор углов, размер: " .. tostring(#angle_set))
        local unused_angles = {}
        
        for _, angle in ipairs(angle_set) do
            local used = false
            for _, entry in ipairs(player.angle_history) do
                if entry and entry.angle and entry.angle == angle and entry.time and globals.realtime() - entry.time < 5 then
                    used = true
                    break
                end
            end
            
            if not used then
                table.insert(unused_angles, angle)
                log_debug("Добавлен неиспользованный угол: " .. tostring(angle))
            end
        end
        
        if #unused_angles > 0 then
            -- Выбираем случайный неиспользованный угол
            local random_index = math.random(#unused_angles)
            best_angle = unused_angles[random_index]
            log_debug("Выбран случайный неиспользованный угол: " .. tostring(best_angle))
        else
            log_debug("Все углы уже использовались, выбираем наименее недавно использованный")
            -- Если все углы уже использовались, выбираем наименее недавно использованный
            local least_recent_angle = nil
            local least_recent_time = globals.realtime()
            
            for _, angle in ipairs(angle_set) do
                local last_used_time = 0
                for _, entry in ipairs(player.angle_history) do
                    if entry and entry.angle and entry.angle == angle and entry.time and entry.time > last_used_time then
                        last_used_time = entry.time
                    end
                end
                
                if last_used_time < least_recent_time then
                    least_recent_time = last_used_time
                    least_recent_angle = angle
                    log_debug("Новый наименее недавно использованный угол: " .. tostring(least_recent_angle) .. " время: " .. tostring(least_recent_time))
                end
            end
            
            if least_recent_angle then
                best_angle = least_recent_angle
                log_debug("Выбран наименее недавно использованный угол: " .. tostring(best_angle))
            end
        end
    end
    
    player.best_angle = best_angle
    log_debug("Итоговый выбранный угол: " .. tostring(best_angle))
    return best_angle
end


-- Get the best angle for a player
function adaptive_resolver:get_angle(idx)
    if not self.players[idx] then
        self:init_player(idx)
        return 0
    end
    
    local player = self.players[idx]
    
    -- Если у нас высокая уверенность в игроке, используем оптимальный угол
    if player.confidence > 0.5 then
        return self:get_optimal_angle(idx)
    end
    
    -- Если у нас низкая уверенность, используем стандартный подход
    if globals.realtime() - player.last_update > 1.0 then
        self:find_best_angle(idx)
        player.last_update = globals.realtime()
    end
    
    return player.best_angle
end

function adaptive_resolver:process_player_list()
    if not ui.get(merged_enable) or not ui.get(adaptive_mode_enabled) then return end
    
    local players = entity.get_players(true)
    if not players then return end
    
    for i = 1, #players do
        local idx = players[i]
        if entity.is_alive(idx) then
            if not self.players[idx] then
                self:init_player(idx)
            end
            
            -- Используем оптимальный угол для игроков с высокой уверенностью
            local angle = 0
            if self.players[idx].confidence > 0.5 then
                angle = self:get_optimal_angle(idx)
            else
                angle = self:get_angle(idx)
            end
            
            if roll_resolver.players[idx] then
                roll_resolver.players[idx].resolved_angles = roll_resolver.players[idx].resolved_angles or {}
                roll_resolver.players[idx].resolved_angles.yaw = angle
            end
        end
    end
end

-- Reset all adaptive data
function adaptive_resolver:reset_data()
    self.players = {}
    self.miss_memory = {}
    self.hit_memory = {}
    client.log("[Claude] Adaptive angle resolver data has been reset")
end

local function apply_adaptive_resolver(idx)
    if not ui.get(adaptive_resolver_checkbox) then return end  
    
    if not roll_resolver.players[idx] then
        roll_resolver:init_player(idx)
    end
    
    local hit_ratio = 0
    if roll_resolver.players[idx] then
        local total = (roll_resolver.players[idx].hits or 0) + (roll_resolver.players[idx].misses or 0)
        hit_ratio = total > 0 and roll_resolver.players[idx].hits / total or 0
    end
    
    if hit_ratio < 0.3 then
        local current_mode = ui.get(merged_mode)
        if current_mode == "Aggressive" then
            ui.set(merged_mode, "Balanced")
        elseif current_mode == "Balanced" then
            ui.set(merged_mode, "Conservative")
        else
            ui.set(merged_mode, "Aggressive")
        end
    end
end


client.set_event_callback("aim_miss", function(e)
    if ui.get(adaptive_resolver_checkbox) then
        apply_adaptive_resolver(e.target)
    end
end)

function adaptive_resolver:analyze_patterns(idx)
    log_debug("Начало analyze_patterns для игрока " .. tostring(idx))
    if not self.players[idx] then 
        log_debug("Игрок " .. tostring(idx) .. " не найден в self.players")
        return {static = 0, jitter = 0, spin = 0, random = 0, switch = 0, desync = 0} 
    end
    
    local player = self.players[idx]
    log_debug("Получен игрок: " .. tostring(player.name or "неизвестно"))
    local history = player.angle_history
    
    if not history then
        log_debug("История углов отсутствует")
        return {static = 0, jitter = 0, spin = 0, random = 0, switch = 0, desync = 0}
    end
    
    log_debug("История углов: " .. tostring(#history) .. " записей")
    
    if #history < 5 then 
        log_debug("Недостаточно истории для анализа")
        return {static = 0, jitter = 0, spin = 0, random = 0, switch = 0, desync = 0} 
    end
    
    local patterns = {
        static = 0,
        jitter = 0,
        spin = 0,
        random = 0,
        switch = 0,
        desync = 0
    }
    
    -- Проверка для static anti-aim
    log_debug("Проверка static anti-aim")
    local is_static = true
    local static_angle = nil
    
    for i = #history, math.max(1, #history - 4), -1 do
        if history[i] and history[i].result == "miss" and history[i].angle ~= nil then
            log_debug("Проверка записи " .. tostring(i) .. ": результат=miss, угол=" .. tostring(history[i].angle))
            if static_angle == nil then
                static_angle = history[i].angle
                log_debug("Установлен static_angle: " .. tostring(static_angle))
            elseif static_angle ~= nil then
                local diff = math.abs(normalize_angle(history[i].angle - static_angle))
                log_debug("Разница углов: " .. tostring(diff))
                if diff > 10 then
                    is_static = false
                    log_debug("Обнаружено отклонение > 10, не static")
                    break
                end
            end
        end
    end
    
    if is_static and static_angle ~= nil then
        patterns.static = 0.8
        log_debug("Определен static паттерн с вероятностью 0.8")
        
        -- Сохраняем оптимальный угол для static anti-aim
        player.optimal_angles = player.optimal_angles or {}
        player.optimal_angles.static = normalize_angle(static_angle + 180)
        log_debug("Установлен оптимальный угол для static: " .. tostring(player.optimal_angles.static))
        
        return patterns
    end
    
    -- Проверка для jitter anti-aim
    log_debug("Проверка jitter anti-aim")
    local angles = {}
    for i = #history, math.max(1, #history - 8), -1 do
        if history[i] and history[i].result == "miss" and history[i].angle ~= nil then
            local found = false
            for j, angle in ipairs(angles) do
                if angle ~= nil and history[i].angle ~= nil then
                    local diff = math.abs(normalize_angle(history[i].angle - angle))
                    if diff < 10 then
                        found = true
                        break
                    end
                end
            end
            
            if not found then
                table.insert(angles, history[i].angle)
                log_debug("Добавлен новый угол: " .. tostring(history[i].angle))
            end
        end
    end
    
    log_debug("Найдено уникальных углов: " .. tostring(#angles))
    if #angles == 2 then
        patterns.jitter = 0.7
        log_debug("Определен jitter паттерн с вероятностью 0.7")
        
        -- Сохраняем оптимальные углы для jitter anti-aim
        player.optimal_angles = player.optimal_angles or {}
        player.optimal_angles.jitter = {
            normalize_angle(angles[1] + 180),
            normalize_angle(angles[2] + 180)
        }
        log_debug("Установлены оптимальные углы для jitter: " .. 
                 tostring(player.optimal_angles.jitter[1]) .. ", " .. 
                 tostring(player.optimal_angles.jitter[2]))
        
        return patterns
    end
    
    -- Проверка для switch anti-aim (переключение между несколькими углами)
    if #angles >= 3 and #angles <= 5 then
        patterns.switch = 0.65
        log_debug("Определен switch паттерн с вероятностью 0.65")
        
        -- Сохраняем оптимальные углы для switch anti-aim
        player.optimal_angles = player.optimal_angles or {}
        player.optimal_angles.switch = {}
        
        for _, angle in ipairs(angles) do
            table.insert(player.optimal_angles.switch, normalize_angle(angle + 180))
        end
        
        local angles_str = ""
        for i, angle in ipairs(player.optimal_angles.switch) do
            angles_str = angles_str .. tostring(angle)
            if i < #player.optimal_angles.switch then
                angles_str = angles_str .. ", "
            end
        end
        log_debug("Установлены оптимальные углы для switch: " .. angles_str)
        
        return patterns
    end
    
    -- Проверка для spin anti-aim
    log_debug("Проверка spin anti-aim")
    local is_spin = true
    local last_angle = nil
    local direction = nil
    local spin_speed = 0
    local angle_diffs = {}
    
    for i = #history, math.max(1, #history - 6), -1 do
        if history[i] and history[i].result == "miss" and history[i].angle ~= nil then
            if last_angle == nil then
                last_angle = history[i].angle
                log_debug("Установлен last_angle: " .. tostring(last_angle))
            else
                local diff = normalize_angle(history[i].angle - last_angle)
                log_debug("Разница углов: " .. tostring(diff))
                table.insert(angle_diffs, diff)
                
                if direction == nil then
                    direction = diff > 0 and 1 or -1
                    log_debug("Установлено направление: " .. tostring(direction))
                elseif (diff > 0 and direction < 0) or (diff < 0 and direction > 0) then
                    is_spin = false
                    log_debug("Обнаружено изменение направления, не spin")
                    break
                end
                
                last_angle = history[i].angle
            end
        end
    end
    
    if is_spin and #angle_diffs > 0 then
        -- Вычисляем среднюю скорость вращения
        local total_diff = 0
        for _, diff in ipairs(angle_diffs) do
            total_diff = total_diff + math.abs(diff)
        end
        spin_speed = total_diff / #angle_diffs
        
        patterns.spin = 0.6
        log_debug("Определен spin паттерн с вероятностью 0.6, скорость: " .. tostring(spin_speed))
        
        -- Сохраняем оптимальные параметры для spin anti-aim
        player.optimal_angles = player.optimal_angles or {}
        player.optimal_angles.spin = {
            direction = direction,
            speed = spin_speed,
            offset = 90 * direction -- Смещение на 90 градусов в направлении вращения
        }
        log_debug("Установлены оптимальные параметры для spin: направление=" .. 
                 tostring(direction) .. ", скорость=" .. tostring(spin_speed) .. 
                 ", смещение=" .. tostring(player.optimal_angles.spin.offset))
        
        return patterns
    end
    
    -- Проверка для desync anti-aim (резкие изменения между двумя сторонами)
    local desync_detected = false
    local left_side = {}
    local right_side = {}
    
    for i = 1, #history do
        if history[i] and history[i].angle ~= nil then
            local angle = history[i].angle
            if angle > 0 then
                table.insert(right_side, angle)
            else
                table.insert(left_side, angle)
            end
        end
    end
    
    if #left_side > 2 and #right_side > 2 then
        local left_avg = 0
        local right_avg = 0
        
        for _, angle in ipairs(left_side) do
            left_avg = left_avg + angle
        end
        left_avg = left_avg / #left_side
        
        for _, angle in ipairs(right_side) do
            right_avg = right_avg + angle
        end
        right_avg = right_avg / #right_side
        
        local side_diff = math.abs(left_avg - right_avg)
        if side_diff > 30 then
            desync_detected = true
            patterns.desync = 0.55
            log_debug("Определен desync паттерн с вероятностью 0.55, разница сторон: " .. tostring(side_diff))
            
            -- Сохраняем оптимальные углы для desync anti-aim
            player.optimal_angles = player.optimal_angles or {}
            player.optimal_angles.desync = {
                left = normalize_angle(left_avg + 180),
                right = normalize_angle(right_avg + 180),
                center = normalize_angle((left_avg + right_avg) / 2 + 180)
            }
            log_debug("Установлены оптимальные углы для desync: левый=" .. 
                     tostring(player.optimal_angles.desync.left) .. ", правый=" .. 
                     tostring(player.optimal_angles.desync.right) .. ", центр=" ..
                     tostring(player.optimal_angles.desync.center))
            
            return patterns
        end
    end
    
    -- Если не определили конкретный паттерн, считаем random
    patterns.random = 0.5
    log_debug("Определен random паттерн с вероятностью 0.5")
    
    -- Для random anti-aim используем набор предопределенных углов
    player.optimal_angles = player.optimal_angles or {}
    player.optimal_angles.random = {0, 35, -35, 58, -58, 29, -29}
    log_debug("Установлены стандартные углы для random")
    
    return patterns
end


-- Update UI visibility
function update_adaptive_ui_visibility()
    local main_enabled = ui.get(merged_enable)
    local adaptive_enabled = main_enabled and ui.get(adaptive_mode_enabled)
    
    ui.set_visible(adaptive_mode_enabled, main_enabled)
    ui.set_visible(adaptive_mode_options, adaptive_enabled)
    ui.set_visible(adaptive_reset_button, adaptive_enabled)
end

-- Register callbacks for UI changes
ui.set_callback(merged_enable, update_adaptive_ui_visibility)
ui.set_callback(adaptive_mode_enabled, update_adaptive_ui_visibility)

-- Initialize UI visibility
update_adaptive_ui_visibility()


local original_nade_resolver_main = nade_resolver.main
function nade_resolver:main(idx)
    local target_idx = get_current_target() or idx
    
    if not target_idx then return end  -- Добавляем проверку на nil
    
    self:updateLayers(target_idx)
    if not self.cache[target_idx] then
        self.cache[target_idx] = {}
    end
    
    -- Остальная часть оригинальной функции
    local vx = entity.get_prop(target_idx, "m_vecVelocity[0]") or 0
    local vy = entity.get_prop(target_idx, "m_vecVelocity[1]") or 0
    local velocity_length = vector_length_2d(vx, vy)

    local max_desync_delta = self:getMaxDesyncDelta(target_idx)
    local desync = max_desync_delta * 58

    local eye_yaw       = entity.get_prop(target_idx, "m_angEyeAngles[1]") or 0
    local goal_feet_yaw = self.cache[target_idx].m_flGoalFeetYaw or 0
    local lby_target    = entity.get_prop(target_idx, "m_flLowerBodyYawTarget") or eye_yaw

    local angle_difference = angle_diff(eye_yaw, goal_feet_yaw)
    local side = 0
    if angle_difference < 0 then side = 1
    elseif angle_difference > 0 then side = -1 end

    local abs_angle_diff = math.abs(angle_difference)
    local old_abs = math.abs(self.cache[target_idx].m_flAbsAngleDiff or abs_angle_diff)
    local should_resolve = false

    if is_lby_flexing(target_idx) then
        should_resolve = true
    end

    local flCurrentAngle = math.max(abs_angle_diff, old_abs)
    if should_resolve then
        if abs_angle_diff <= 10.0 and old_abs <= 10.0 then
            desync = flCurrentAngle
        elseif abs_angle_diff <= 35.0 and old_abs <= 35.0 then
            desync = math.max(29.0, flCurrentAngle)
        else
            desync = clamp(flCurrentAngle, 29.0, 57)
        end
    else
        desync = self.cache[target_idx].m_flDesync or desync
    end

    desync = clamp(desync, 0, max_desync_delta * 58)
    self:updateSafety(target_idx, side, desync)
    
    self.cache[target_idx].m_flGoalFeetYaw = goal_feet_yaw
    self.cache[target_idx].m_flAbsAngleDiff = abs_angle_diff
    self.cache[target_idx].m_flDesync = desync
    self.cache[target_idx].m_flAbsAngleDiff      = abs_angle_diff
    self.cache[target_idx].m_flVelocityLengthXY  = velocity_length
    self.cache[target_idx].m_flDesync            = desync * side
    self.cache[target_idx].m_flGoalFeetYaw       = goal_feet_yaw
    self.cache[target_idx].m_flPredictedFootYaw  = self:predictedFootYaw(
        goal_feet_yaw,
        eye_yaw + self.cache[target_idx].m_flDesync,
        lby_target,
        0,
        vx,
        vy,
        -57,
        57
    )
end
local bruteforce_state = {}

local function apply_bruteforce(idx)
    if not ui.get(merged_enable) then return end
    
    local target_idx = get_current_target() or idx
    if not target_idx then return end  -- Добавляем проверку на nil
    
    local options = ui.get(bruteforce_angles)
    if #options == 0 then return end
    
    bruteforce_state[target_idx] = bruteforce_state[target_idx] or {
        current_angle = 1,
        last_change = globals.realtime(),
        tried_angles = {},
        best_angle = nil,
        best_angle_hits = 0
    }
    
    local state = bruteforce_state[target_idx] 
    local angles = {0, 58, -58, 29, -29, 15, -15, 45, -45}
    
    if state.best_angle and state.best_angle_hits > 2 then
        if math.random() < 0.7 then  
            local resolved_angle = state.best_angle
            
            if roll_resolver.players[target_idx] then
                roll_resolver.players[target_idx].resolved_angles.yaw = resolved_angle
            end
            return
        end
    end
    
    if globals.realtime() - state.last_change > 1.5 then
        local next_angle_index = state.current_angle
        local tries = 0
        
        while state.tried_angles[angles[next_angle_index]] and tries < #angles do
            next_angle_index = next_angle_index % #angles + 1
            tries = tries + 1
        end
        
        if tries >= #angles then
            state.tried_angles = {}
        end
        
        state.current_angle = next_angle_index
        state.last_change = globals.realtime()
        state.tried_angles[angles[next_angle_index]] = true
    end
    
    local resolved_angle = angles[state.current_angle]
    
    if roll_resolver.players[target_idx] then
        roll_resolver.players[target_idx].resolved_angles.yaw = resolved_angle
    end
end

client.set_event_callback("net_update_end", function()
    if not ui.get(merged_enable) then return end
    
    if ui.get(adaptive_mode_enabled) then
        local current_time = globals.realtime()
        if current_time - adaptive_resolver.last_update < adaptive_resolver.update_interval then
            return
        end
        
        adaptive_resolver.last_update = current_time
        adaptive_resolver:process_player_list()
    end
    
    roll_resolver:update()
end)

client.register_esp_flag("ADAPTIVE", 0, 255, 255, function(idx)
    if not ui.get(merged_enable) or not ui.get(adaptive_mode_enabled) then return false end
    
    local player = adaptive_resolver.players[idx]
    if not player then return false end
    
    return player.state == "ADAPTING" or player.state == "RESOLVED"
end)



client.set_event_callback("aim_miss", function(e)
    apply_bruteforce(e.target)
    roll_resolver:analyze_misses(e.target)
    roll_resolver:on_aim_miss(e)
    if ui.get(adaptive_mode_enabled) then
        adaptive_resolver:record_miss(e.target, roll_resolver.players[e.target].resolved_angles.yaw, e.reason)
    end

    if roll_resolver.players[e.target] then
        roll_resolver.players[e.target].misses = (roll_resolver.players[e.target].misses or 0) + 1
    end
end)

local last_print_time = 0 -- Store the last time we printed info

client.set_event_callback("paint_ui", function()
        if ui.get(merged_enable) then
        -- Принудительно показываем все элементы UI
        ui.set_visible(merged_mode, true)
        ui.set_visible(merged_performance, true)
        ui.set_visible(adaptive_resolver_checkbox, true)
        ui.set_visible(miss_analysis, true)
        ui.set_visible(miss_threshold, true)
        ui.set_visible(prediction_enabled, true)
        ui.set_visible(bruteforce_angles, true)
        ui.set_visible(console_filter, true)
        ui.set_visible(player_list_enabled, true)
        ui.set_visible(auto_target_enabled, true)
        ui.set_visible(adaptive_mode_enabled, true)
        ui.set_visible(adaptive_mode_options, true)
        ui.set_visible(adaptive_reset_button, true)
        ui.set_visible(player_list, true)
    end
    if not ui.get(merged_enable) then return end
    
    local target_idx = get_current_target()
    if not target_idx then return end
    
    local data = roll_resolver.players[target_idx]
    if not data then return end
    
    local name = entity.get_player_name(target_idx) or "Unknown"
    local hits = data.hits or 0
    local misses = data.misses or 0
    local total = hits + misses
    local accuracy = total > 0 and math.floor((hits / total) * 100) or 0
    local state = data.state or "UNKNOWN"
    local resolved_yaw = data.resolved_angles and data.resolved_angles.yaw or 0
    
    local info = string.format(
        "Player: %s State: %s Accuracy: %d%% (%d/%d) Angle: %.1f°",
        name, state, accuracy, hits, total, resolved_yaw
    )
    
    local current_time = globals.realtime()
    -- Print only if at least 5 seconds have passed
    if current_time - last_print_time >= 5 then
        client.log(info)
        last_print_time = current_time
    end
end)

function nade_resolver:checkResolvingStage(idx)
    local animstate = get_animstate(idx)
    local has_animstate = (animstate ~= nil)
    local cache_ok      = (self.cache[idx] ~= nil)
    local layers_ok     = (self.layers[idx] ~= nil)
    local safepoints_ok = (self.safepoints[idx] ~= nil)

    if not has_animstate then
        return "Resolving: 1/4"
    elseif not cache_ok then
        return "Resolving: 2/4"
    elseif not layers_ok then
        return "Resolving: 3/4"
    elseif not safepoints_ok then
        return "Resolving: 4/4"
    else
        return "Resolved"
    end
end

function roll_resolver:reset_all()
    for idx, data in pairs(self.players) do
        data.hits            = 0
        data.misses          = 0
        data.last_yaw        = 0
        data.resolved_angles = { yaw = 0 }
        data.memory_angles   = {}
        data.state           = "SCAN"
        data.hit_registered  = false
    end
    
    self.mode_effectiveness = {
        A = { hits = 0, misses = 0 },
        B = { hits = 0, misses = 0 },
        C = { hits = 0, misses = 0 }
    }
end

-- Fix for the error at line 1192
function roll_resolver:init_player(idx)
    if not idx then return end
    self.players[idx] = {
        memory_angles = {
            yaw = {},
            pitch = {},
            roll = {}
        },
        angle_history = {
            yaw = {},
            pitch = {},
            roll = {}
        },  -- Initialize angle_history properly
        resolved_angles = { 
            yaw = 0,
            pitch = 0,
            roll = 0
        },
        state = "SCAN",
        hits = 0,
        misses = 0,
        consecutive_hits = 0,
        consecutive_misses = 0,
        last_yaw = 0,
        hit_registered = false,
        last_miss_reason = nil,
        confidence = 0, 
        last_update_time = globals.realtime(),
        movement_patterns = {
            multiplier = 1.0,
            last_positions = {},
            last_velocities = {}
        },
        angle_weights = {} 
    }
    client.log("Found player " .. entity.get_player_name(idx))
end
function roll_resolver:add_angle_to_history(idx, angle_type, angle_value, weight)
    if not self.players[idx] then
        self:init_player(idx)
    end
    
    local data = self.players[idx]
    
    data.angle_history[angle_type] = data.angle_history[angle_type] or {}
    

    table.insert(data.angle_history[angle_type], {
        value = angle_value,
        time = globals.realtime(),
        weight = weight or 1.0
    })
    
    if #data.angle_history[angle_type] > 20 then
        table.remove(data.angle_history[angle_type], 1)
    end
    

    self:update_angle_weights(idx, angle_type)
end
function roll_resolver:update_angle_weights(idx, angle_type)
    if not self.players[idx] then return end
    
    local data = self.players[idx]
    local history = data.angle_history[angle_type]
    
    if not history or #history == 0 then return end
        data.angle_weights[angle_type] = {}
    
    for i = 1, #history do
        local angle = math.floor(history[i].value / 5) * 5
        data.angle_weights[angle_type][angle] = (data.angle_weights[angle_type][angle] or 0) + history[i].weight
    end
        local total_weight = 0
    for angle, weight in pairs(data.angle_weights[angle_type]) do
        total_weight = total_weight + weight
    end
    
    if total_weight > 0 then
        for angle, weight in pairs(data.angle_weights[angle_type]) do
            data.angle_weights[angle_type][angle] = weight / total_weight
        end
    end
end
function roll_resolver:get_most_probable_angle(idx, angle_type)
    if not self.players[idx] or not self.players[idx].angle_weights[angle_type] then
        return 0
    end
    
    local data = self.players[idx]
    local weights = data.angle_weights[angle_type]
    
    local max_weight = 0
    local best_angle = 0
    
    for angle, weight in pairs(weights) do
        if weight > max_weight then
            max_weight = weight
            best_angle = angle
        end
    end
    
    return best_angle, max_weight
end
function roll_resolver:analyze_angle_patterns(idx)
    if not self.players[idx] then return end
    
    local data = self.players[idx]
    local yaw_history = data.angle_history.yaw
    
    if not yaw_history or #yaw_history < 5 then return end
    
    local patterns = {
        jitter = 0,
        static = 0,
        spin = 0,
        random = 0
    }
    
    local last_angles = {}
    for i = math.max(1, #yaw_history - 4), #yaw_history do
        table.insert(last_angles, yaw_history[i].value)
    end
    
    local is_static = true
    local base_angle = last_angles[1]
    for i = 2, #last_angles do
        if math.abs(angle_diff(last_angles[i], base_angle)) > 5 then
            is_static = false
            break
        end
    end
    
    if is_static then
        patterns.static = 1.0
        return patterns
    end

    local is_jitter = true
    local angle1 = last_angles[1]
    local angle2 = nil
    
    for i = 2, #last_angles do
        if math.abs(angle_diff(last_angles[i], angle1)) < 5 then
         
        elseif angle2 == nil then
            angle2 = last_angles[i]
        elseif math.abs(angle_diff(last_angles[i], angle2)) > 5 then
            is_jitter = false
            break
        end
    end
    
    if is_jitter and angle2 ~= nil then
        patterns.jitter = 1.0
        return patterns
    end
    
    local is_spin = true
    local spin_direction = angle_diff(last_angles[2], last_angles[1]) > 0 and 1 or -1
    
    for i = 2, #last_angles - 1 do
        local curr_direction = angle_diff(last_angles[i+1], last_angles[i]) > 0 and 1 or -1
        if curr_direction ~= spin_direction then
            is_spin = false
            break
        end
    end
    
    if is_spin then
        patterns.spin = 1.0
        return patterns
    end
    
    patterns.random = 1.0
    return patterns
end

local function advanced_angle_solver(ent, dt, old_yaw)
    dt = dt or 0
    if not ent or not ent.velocity or type(ent.velocity) ~= "table" then
        return old_yaw
    end
    local vx = ent.velocity.x or 0
    local vy = ent.velocity.y or 0
    local spd2d = math.sqrt(vx^2 + vy^2)
    local velocity_angle = (spd2d >= 1) and math.deg(math.atan2(vy, vx)) or old_yaw
    local alpha = 0.65
    local new_yaw = angle_lerp(old_yaw, velocity_angle, alpha)
    return normalize_angle(new_yaw)
end
function roll_resolver:analyze_misses(idx)
    if not ui.get(miss_analysis) then return end
    
    local data = self.players[idx]
    if not data then 
        self:init_player(idx)
        data = self.players[idx]
    end
    
    -- Initialize miss_history if it doesn't exist
    self.miss_history[idx] = self.miss_history[idx] or {
        consecutive_misses = 0,
        last_miss_time = 0,
        miss_patterns = {},
        current_mode = ui.get(merged_mode)
    }
    
    local history = self.miss_history[idx]
    local current_time = globals.realtime()
    
    -- Update consecutive misses
    if current_time - history.last_miss_time > 5 then
        history.consecutive_misses = 1
    else
        history.consecutive_misses = history.consecutive_misses + 1
    end
    
    history.last_miss_time = current_time
    
    -- Initialize mode_effectiveness if it doesn't exist
    if not self.mode_effectiveness then
        self.mode_effectiveness = {
            ["Aggressive"] = { hits = 0, misses = 0 },
            ["Balanced"] = { hits = 0, misses = 0 },
            ["Conservative"] = { hits = 0, misses = 0 }
        }
    end
    
    -- Update mode effectiveness
    local current_mode = ui.get(merged_mode)
    if current_mode ~= "Auto" then
        -- Ensure the current mode exists in mode_effectiveness
        if not self.mode_effectiveness[current_mode] then
            self.mode_effectiveness[current_mode] = { hits = 0, misses = 0 }
        end
        self.mode_effectiveness[current_mode].misses = (self.mode_effectiveness[current_mode].misses or 0) + 1
    end
    
    -- Check if we need to switch modes
    if history.consecutive_misses >= ui.get(miss_threshold) then
        local next_mode = self:get_best_mode()
        
        -- Validate that next_mode is a valid option
        local valid_modes = {"Aggressive", "Balanced", "Conservative", "Auto"}
        local is_valid = false
        for _, mode in ipairs(valid_modes) do
            if next_mode == mode then
                is_valid = true
                break
            end
        end
        
        if is_valid and next_mode ~= current_mode then
            ui.set(merged_mode, next_mode)
            client.log(string.format("Switching mode to %s after %d consecutive misses", 
                                   next_mode, history.consecutive_misses))
            history.consecutive_misses = 0
        end
    end
end

function roll_resolver:predict_next_angle(idx)
    if not self.players[idx] then return 0 end
    
    local data = self.players[idx]
    local yaw_history = data.angle_history.yaw
    
    if not yaw_history or #yaw_history < 3 then
        return data.resolved_angles.yaw
    end
    
    local patterns = self:analyze_angle_patterns(idx)
    
    if patterns.static > 0.5 then
        return yaw_history[#yaw_history].value
    elseif patterns.static > 0.5 then
        return yaw_history[#yaw_history].value
    elseif patterns.jitter > 0.5 then
        local last_angle = yaw_history[#yaw_history].value
        local prev_angle = yaw_history[#yaw_history-1].value
        return prev_angle 
    elseif patterns.spin > 0.5 then
        local last_angle = yaw_history[#yaw_history].value
        local prev_angle = yaw_history[#yaw_history-1].value
        local delta = angle_diff(last_angle, prev_angle)
        return normalize_angle(last_angle + delta)
    else
        local best_angle, confidence = self:get_most_probable_angle(idx, "yaw")
        return best_angle
    end
end

function roll_resolver:get_best_mode()
    -- Initialize mode_effectiveness if it doesn't exist
    if not self.mode_effectiveness then
        self.mode_effectiveness = {
            ["Aggressive"] = { hits = 0, misses = 0 },
            ["Balanced"] = { hits = 0, misses = 0 },
            ["Conservative"] = { hits = 0, misses = 0 }
        }
    end
    
    local best_mode = "Balanced"  -- Default mode
    local best_ratio = 0
    
    -- Safely iterate through mode_effectiveness with nil checks
    for mode, stats in pairs(self.mode_effectiveness) do
        -- Ensure hits and misses are initialized
        if stats then
            stats.hits = stats.hits or 0
            stats.misses = stats.misses or 0
            
            local total = stats.hits + stats.misses
            if total > 0 then
                local ratio = stats.hits / total
                if ratio > best_ratio then
                    best_ratio = ratio
                    best_mode = mode
                end
            end
        end
    end
    
    -- Fallback logic if no good mode is found
    if best_ratio < 0.2 then
        local current = ui.get(merged_mode)
        if current == "Aggressive" then
            return "Balanced"
        elseif current == "Balanced" then
            return "Conservative"
        else
            return "Aggressive"  
        end
    end
    
    return best_mode
end
local function choose_anti_aim_fix(ent, base_angle)
    local vel, ok_vel = safe_read_vector3(ent.velocity)
    if ok_vel then
        local speed = math.sqrt(vel.x^2 + vel.y^2)
        if speed < 50 then
            return normalize_angle(base_angle + 25)
        elseif speed < 100 then
            return normalize_angle(base_angle + 35)
        end
    end
    return base_angle
end
function roll_resolver:update_confidence(idx, hit)
    if not self.players[idx] then 
        self:init_player(idx)
        return
    end
    
    local data = self.players[idx]
    
    if not data.confidence then
        data.confidence = 0
    end
    
    if hit then
        data.confidence = math.min(1.0, data.confidence + 0.2)
        data.hits = (data.hits or 0) + 1
        client.log("High chance to hit " .. entity.get_player_name(idx) .. ": " .. string.format("%.2f", data.confidence))
    else
        data.confidence = math.max(0.0, data.confidence - 0.1)
        data.misses = (data.misses or 0) + 1
        client.log("Doubtful... " .. entity.get_player_name(idx) .. ": " .. string.format("%.2f", data.confidence))
    end
    
    if data.confidence < 0.2 and data.state ~= "SCAN" then
        data.state = "SCAN"
        data.last_miss_reason = "low_confidence"
        client.log("[Claude] Player " .. entity.get_player_name(idx) .. " returned to SCAN state due to low confidence")
    end
end
local function round_angle(a)
    return math.floor(a + 0.5)
end

local function add_weight(memory, pitch, yaw, roll)
    memory[pitch] = memory[pitch] or {}
    memory[pitch][yaw] = memory[pitch][yaw] or {}
    memory[pitch][yaw][roll] = (memory[pitch][yaw][roll] or 0) + 1
    return memory[pitch][yaw][roll]
end

function roll_resolver:resolve_player(idx)
    if not ui.get(merged_enable) then
        self:reset_all()
        return
    end
    local data = self.players[idx]
    if not data then
        self:init_player(idx)
        data = self.players[idx]
    end

    local ent = get_player_data(idx)
    if not ent then return end

    local sim_time = ent.simulation_time or 0
    local old_sim_time = ent.old_simulation_time or sim_time
    local dt = sim_time - old_sim_time

    local view, ok_view = safe_read_vector3(ent.view_angles)
    local current_yaw = ok_view and view.y or 0

    local vel, ok_vel = safe_read_vector3(ent.velocity)
    local movement_factor = 0
    if ok_vel then
        movement_factor = math.min(1, math.sqrt(vel.x^2 + vel.y^2) / 250)
    end

    local p_old = data.last_yaw or current_yaw
    local y_adv = advanced_angle_solver(ent, dt, p_old)
    local new_yaw = choose_anti_aim_fix(ent, y_adv)

    local total_shots = (data.hits or 0) + (data.misses or 0)
    local hit_ratio = (data.hits or 0) / math.max(1, total_shots)
    local blend_ratio = math.min(1.0, (hit_ratio * 0.1) + (movement_factor * 0.3))
    local computed_yaw = normalize_angle(blend_ratio * data.last_yaw + (1 - blend_ratio) * new_yaw)
    data.last_yaw = computed_yaw
    data.resolved_angles.yaw = computed_yaw

    if hit_ratio > 0.6 and movement_factor < 0.3 then
        data.state = "RESOLVED"
    else
        data.state = "SCAN"
    end
end
function roll_resolver:track_movement(idx, player)
    if not idx or not entity.is_alive(idx) then return end
    if not self.players[idx] then self:init_player(idx) end
    
    local data = self.players[idx]
    if not data.movement_patterns then
        data.movement_patterns = {
            multiplier = 1.0,
            last_positions = {},
            last_velocities = {}
        }
    end
    
    local pos_x = entity.get_prop(idx, "m_vecOrigin[0]") or 0
    local pos_y = entity.get_prop(idx, "m_vecOrigin[1]") or 0
    local pos_z = entity.get_prop(idx, "m_vecOrigin[2]") or 0
    
    local vel_x = entity.get_prop(idx, "m_vecVelocity[0]") or 0
    local vel_y = entity.get_prop(idx, "m_vecVelocity[1]") or 0
    local vel_z = entity.get_prop(idx, "m_vecVelocity[2]") or 0
    
    local pos = {pos_x, pos_y, pos_z}
    local vel = {vel_x, vel_y, vel_z}
    
    table.insert(data.movement_patterns.last_positions, pos)
    table.insert(data.movement_patterns.last_velocities, vel)
    
    if #data.movement_patterns.last_positions > 10 then
        table.remove(data.movement_patterns.last_positions, 1)
        table.remove(data.movement_patterns.last_velocities, 1)
    end
    
    local speed = math.sqrt(vel[1]^2 + vel[2]^2)
    if speed > 200 then
        data.movement_patterns.multiplier = 1.2
    elseif speed < 50 then
        data.movement_patterns.multiplier = 0.8
    else
        data.movement_patterns.multiplier = 1.0
    end
end
function roll_resolver:update()
    if not ui.get(merged_enable) then
        return
    end
    
    local enemies = entity.get_players(true)
    if enemies then
        for i = 1, #enemies do
            local idx = enemies[i]
            if entity.is_alive(idx) then
                self:resolve_player(idx)
            end
        end
    end
end
local function enable_force_yaw_wrapper(yaw)
    enable_force_yaw(yaw)
end

function roll_resolver:update(idx, player, hit_info)
    if not idx or not player then return end
    
    if not self.players[idx] then
        self:init_player(idx)
    end
    
    local data = self.players[idx]
    local current_time = globals.realtime()
    
    if current_time - data.last_update_time < 0.05 then
        return
    end
    
    data.last_update_time = current_time
    
    local pitch = entity.get_prop(idx, "m_angEyeAngles[0]") or 0
    local yaw = entity.get_prop(idx, "m_angEyeAngles[1]") or 0
    local roll = entity.get_prop(idx, "m_angEyeAngles[2]") or 0
    
    local current_yaw = yaw
    local current_pitch = pitch
    local current_roll = roll
    
    self:add_angle_to_history(idx, "yaw", current_yaw, 1.0)
    self:add_angle_to_history(idx, "pitch", current_pitch, 1.0)
    self:add_angle_to_history(idx, "roll", current_roll, 1.0)
    
    self:track_movement(idx, player)
    
    if hit_info then
        if hit_info.hit then
            self:add_angle_to_history(idx, "yaw", data.resolved_angles.yaw, 2.0)
            self:add_angle_to_history(idx, "pitch", data.resolved_angles.pitch, 2.0)
            self:add_angle_to_history(idx, "roll", data.resolved_angles.roll, 2.0)
            data.hit_registered = true
        else
            data.hit_registered = false
            data.last_miss_reason = hit_info.reason or "unknown"
        end
        
        self:update_confidence(idx, hit_info.hit)
    end
    
    self:update_state(idx)
    
    self:resolve_angles(idx)
    
    data.last_yaw = current_yaw
end
function roll_resolver:update_state(idx)
    if not self.players[idx] then 
        self:init_player(idx)
        return
    end
    
    local data = self.players[idx]
    
    if not data.confidence then
        data.confidence = 0
    end
    
    if data.state == "SCAN" then
        if data.confidence > 0.6 then
            data.state = "LOCKED"
            client.log("Player " .. entity.get_player_name(idx) .. " moved to LOCKED state") 
        end
    elseif data.state == "LOCKED" then
        if data.confidence < 0.3 then
            data.state = "ADAPTIVE"
            client.log("Player " .. entity.get_player_name(idx) .. " moved to ADAPTIVE state")
        end
    elseif data.state == "ADAPTIVE" then
        if data.confidence > 0.7 then
            data.state = "LOCKED"
            client.log("Player " .. entity.get_player_name(idx) .. " moved to LOCKED state")
        elseif data.confidence < 0.2 then
            data.state = "SCAN"
            client.log("Player " .. entity.get_player_name(idx) .. " moved to SCAN state")
        end
    end
end
function roll_resolver:on_aim_miss(e)
    if not ui.get(merged_enable) then return end
    local idx = e.target
    local data = self.players[idx]
    if not data then return end

    if e.miss_reason and e.miss_reason == "spread" then
        return
    end

    data.last_miss_reason = e.miss_reason
    data.misses = (data.misses or 0) + 1
    data.hit_registered = false
    data.state = "SCAN"

    local total_shots = (data.hits or 0) + (data.misses or 0)
    local accuracy = math.floor((data.hits or 0) / math.max(1, total_shots) * 100)
    local name = entity.get_player_name(idx) or "Unknown"
    debug_log(string.format("Miss %s: accuracy=%d%%", name, accuracy))

    enable_force_yaw_wrapper(data.resolved_angles.yaw)
end

function roll_resolver:update_console_filter(force_disable)
    local should_filter = not force_disable and ui.get(console_filter)
    
    -- Check if cvar objects exist before using them
    if cvar and cvar.con_filter_enable and cvar.con_filter_text then
        cvar.con_filter_enable:set_int(should_filter and 1 or 0)
        cvar.con_filter_text:set_string(should_filter and self.console_filter.filter_text or "")
        if should_filter then 
            client.exec("clear") 
        end
    else
        -- If cvar objects don't exist, initialize them
        cvar = cvar or {}
        cvar.con_filter_enable = cvar.con_filter_enable or client.get_cvar("con_filter_enable")
        cvar.con_filter_text = cvar.con_filter_text or client.get_cvar("con_filter_text")
        
        -- Try again if we were able to initialize them
        if cvar.con_filter_enable and cvar.con_filter_text then
            cvar.con_filter_enable:set_int(should_filter and 1 or 0)
            cvar.con_filter_text:set_string(should_filter and self.console_filter.filter_text or "")
            if should_filter then 
                client.exec("clear") 
            end
        end
    end
end

function roll_resolver:cleanup()
    self.players = {}
    self:update_console_filter(true)
    debug_log("Claude: done cleanup.")
end
function save_presets()
    local presets = {}
    
    presets.merged_enable = ui.get(merged_enable)
    presets.merged_mode = ui.get(merged_mode)
    presets.merged_performance = ui.get(merged_performance)
    
    presets.adaptive_mode_enabled = ui.get(adaptive_mode_enabled)
    presets.adaptive_mode_options = ui.get(adaptive_mode_options)
    
    presets.adaptive_resolver_enabled = ui.get(adaptive_resolver_checkbox)  
    presets.miss_analysis = ui.get(miss_analysis)
    presets.miss_threshold = ui.get(miss_threshold)
    presets.prediction_enabled = ui.get(prediction_enabled)
    presets.bruteforce_angles = ui.get(bruteforce_angles)
    presets.console_filter = ui.get(console_filter)
    presets.player_list_enabled = ui.get(player_list_enabled)
    presets.auto_target_enabled = ui.get(auto_target_enabled)
    
    database.write("claude_presets", presets)
end

-- Исправление ошибки #1: bad argument #1 to 'get' (number expected, got table)
-- Проблема в строке 2430, где ui.get() получает таблицу вместо числа

-- Найдите эту строку (примерно 2430) и замените её:
function adaptive_resolver:get_angle_set()
    local options = ui.get(adaptive_mode_options)
    local use_extended = false
    
    -- Проверяем каждый элемент в options
    if type(options) == "table" then
        for i=1, #options do
            if options[i] == "Extended angle set" then
                use_extended = true
                break
            end
        end
    elseif options == "Extended angle set" then
        use_extended = true
    end
    
    return use_extended and self.angle_sets.extended or self.angle_sets.standard
end
function adaptive_resolver:get_optimal_angle(idx)
    if not self.players[idx] then
        self:init_player(idx)
        return 0
    end
    
    local player = self.players[idx]
    local patterns = self:analyze_patterns(idx)
    
    -- Находим наиболее вероятный паттерн
    local best_pattern = "random"
    local best_probability = 0
    
    for pattern, probability in pairs(patterns) do
        if probability > best_probability then
            best_probability = probability
            best_pattern = pattern
        end
    end
    
    log_debug("Наиболее вероятный паттерн: " .. best_pattern .. " с вероятностью " .. tostring(best_probability))
    
    -- Если у нас нет оптимальных углов для этого паттерна, анализируем заново
    if not player.optimal_angles or not player.optimal_angles[best_pattern] then
        self:analyze_patterns(idx)
    end
    
    -- Если все еще нет оптимальных углов, используем стандартный набор
    if not player.optimal_angles or not player.optimal_angles[best_pattern] then
        log_debug("Нет оптимальных углов для паттерна " .. best_pattern .. ", используем стандартный набор")
        return self:get_angle(idx)
    end
    
    -- Выбираем оптимальный угол в зависимости от паттерна
    local optimal_angle = 0
    
    if best_pattern == "static" then
        optimal_angle = player.optimal_angles.static
    elseif best_pattern == "jitter" then
        -- Для jitter выбираем угол, который не использовался в последнее время
        local last_angle = player.last_used_angle or 0
        if math.abs(normalize_angle(last_angle - player.optimal_angles.jitter[1])) < 10 then
            optimal_angle = player.optimal_angles.jitter[2]
        else
            optimal_angle = player.optimal_angles.jitter[1]
        end
    elseif best_pattern == "switch" then
        -- Для switch выбираем следующий угол в последовательности
        local last_index = player.last_switch_index or 0
        last_index = (last_index % #player.optimal_angles.switch) + 1
        optimal_angle = player.optimal_angles.switch[last_index]
        player.last_switch_index = last_index
    elseif best_pattern == "spin" then
        -- Для spin предсказываем следующий угол на основе скорости и направления
        local base_angle = entity.get_prop(idx, "m_angEyeAngles[1]") or 0
        local time_offset = 0.1 -- Предсказываем на 100 мс вперед
        optimal_angle = normalize_angle(base_angle + player.optimal_angles.spin.offset + 
                                       player.optimal_angles.spin.speed * player.optimal_angles.spin.direction * time_offset)
    elseif best_pattern == "desync" then
        -- Для desync чередуем между левой и правой стороной
        if not player.last_desync_side or player.last_desync_side == "left" then
            optimal_angle = player.optimal_angles.desync.right
            player.last_desync_side = "right"
        else
            optimal_angle = player.optimal_angles.desync.left
            player.last_desync_side = "left"
        end
    else -- random или другие неопределенные паттерны
        -- Выбираем случайный угол из предопределенного набора
        local random_index = math.random(#player.optimal_angles.random)
        optimal_angle = player.optimal_angles.random[random_index]
    end
    
    player.last_used_angle = optimal_angle
    log_debug("Выбран оптимальный угол " .. tostring(optimal_angle) .. " для паттерна " .. best_pattern)
    
    return optimal_angle
end

local function apply_adaptive_resolver(idx)
    if not ui.get(adaptive_resolver_checkbox) then return end  
    
    if not roll_resolver.players[idx] then
        roll_resolver:init_player(idx)
    end
    
    local hit_ratio = 0
    if roll_resolver.players[idx] then
        local total = (roll_resolver.players[idx].hits or 0) + (roll_resolver.players[idx].misses or 0)
        hit_ratio = total > 0 and roll_resolver.players[idx].hits / total or 0
    end
    
    if hit_ratio < 0.3 then
        local current_mode = ui.get(merged_mode)
        if current_mode == "Aggressive" then
            ui.set(merged_mode, "Balanced")
        elseif current_mode == "Balanced" then
            ui.set(merged_mode, "Conservative")
        else
            ui.set(merged_mode, "Aggressive")
        end
    end
end

-- И в обработчике события aim_miss (примерно строка 2520):
client.set_event_callback("aim_miss", function(e)
    if ui.get(adaptive_resolver_checkbox) then  -- Изменено здесь
        apply_adaptive_resolver(e.target)
    end
end)

-- Также в функции save_presets (примерно строка 2800):
function save_presets()
    local presets = {}
    
    -- Сохраняем настройки merged_enable
    presets.merged_enable = ui.get(merged_enable)
    presets.merged_mode = ui.get(merged_mode)
    presets.merged_performance = ui.get(merged_performance)
    
    -- Сохраняем настройки adaptive_resolver
    presets.adaptive_mode_enabled = ui.get(adaptive_mode_enabled)
    presets.adaptive_mode_options = ui.get(adaptive_mode_options)
    
    -- Сохраняем другие настройки
    presets.adaptive_resolver_enabled = ui.get(adaptive_resolver_checkbox)  -- Изменено здесь
    presets.miss_analysis = ui.get(miss_analysis)
    presets.miss_threshold = ui.get(miss_threshold)
    presets.prediction_enabled = ui.get(prediction_enabled)
    presets.bruteforce_angles = ui.get(bruteforce_angles)
    presets.console_filter = ui.get(console_filter)
    presets.player_list_enabled = ui.get(player_list_enabled)
    presets.auto_target_enabled = ui.get(auto_target_enabled)
    
    -- Сохраняем в базу данных
    database.write("claude_presets", presets)
end

function load_presets()
    local presets = database.read("claude_presets")
    if not presets then return end
    
    if presets.merged_enable ~= nil then ui.set(merged_enable, presets.merged_enable) end
    if presets.merged_mode ~= nil then ui.set(merged_mode, presets.merged_mode) end
    if presets.merged_performance ~= nil then ui.set(merged_performance, presets.merged_performance) end
    
    if presets.adaptive_mode_enabled ~= nil then ui.set(adaptive_mode_enabled, presets.adaptive_mode_enabled) end
    if presets.adaptive_mode_options ~= nil then ui.set(adaptive_mode_options, presets.adaptive_mode_options) end
    
    if presets.adaptive_resolver_enabled ~= nil then ui.set(adaptive_resolver_checkbox, presets.adaptive_resolver_enabled) end  
    if presets.miss_analysis ~= nil then ui.set(miss_analysis, presets.miss_analysis) end
    if presets.miss_threshold ~= nil then ui.set(miss_threshold, presets.miss_threshold) end
    if presets.prediction_enabled ~= nil then ui.set(prediction_enabled, presets.prediction_enabled) end
    if presets.bruteforce_angles ~= nil then ui.set(bruteforce_angles, presets.bruteforce_angles) end
    if presets.console_filter ~= nil then ui.set(console_filter, presets.console_filter) end
    if presets.player_list_enabled ~= nil then ui.set(player_list_enabled, presets.player_list_enabled) end
    if presets.auto_target_enabled ~= nil then ui.set(auto_target_enabled, presets.auto_target_enabled) end
    
    update_ui_visibility()
    update_adaptive_ui_visibility()
end

function roll_resolver:resolve_angles(idx)
    if not self.players[idx] then return end
    
    local data = self.players[idx]
    
    if data.state == "SCAN" then
        local scan_options = {0, 60, -60, 30, -30, 90, -90}
        local scan_index = math.floor(globals.realtime() * 0.5) % #scan_options + 1
        data.resolved_angles.yaw = scan_options[scan_index]
        data.resolved_angles.pitch = 89 
        data.resolved_angles.roll = 0
    elseif data.state == "LOCKED" then
        local best_yaw, yaw_confidence = self:get_most_probable_angle(idx, "yaw")
        local best_pitch, pitch_confidence = self:get_most_probable_angle(idx, "pitch")
        local best_roll, roll_confidence = self:get_most_probable_angle(idx, "roll")
        
        data.resolved_angles.yaw = best_yaw
        data.resolved_angles.pitch = best_pitch
        data.resolved_angles.roll = best_roll
    elseif data.state == "ADAPTIVE" then
        data.resolved_angles.yaw = self:predict_next_angle(idx)
        data.resolved_angles.pitch = 89
        
        data.resolved_angles.yaw = normalize_angle(data.resolved_angles.yaw * data.movement_patterns.multiplier)
    end
end




client.set_event_callback("ragebot_miss", function(e)
    if not ui.get(merged_enable) then return end
    if ui.get(merged_mode) ~= "A" then return end
    local target_index = e.target_index
    if target_index == nil then return end
    local enemy_name = entity.get_player_name(target_index)
    if enemy_name then
        nade_resolver.shots_fired[enemy_name] = (nade_resolver.shots_fired[enemy_name] or 0) + 1
    end
end)

client.set_event_callback("setup_command", function(cmd)
    apply_enhanced_autostop(cmd)
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end
    
    local tickbase = entity.get_prop(local_player, "m_nTickBase") - globals.tickcount()
    
    -- Create references safely
    local refs = {
        rage_cb = { ui.reference("RAGE", "Aimbot", "Enabled") },
        dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
        fake_duck = ui.reference("RAGE", "Other", "Duck peek assist"),
    }
    
    -- Check if references were created successfully
    if not refs.rage_cb[1] or not refs.rage_cb[2] or not refs.dt[1] or not refs.dt[2] or not refs.fake_duck then
        return
    end
    
    local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2]) and not ui.get(refs.fake_duck)
    local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")
    if active_weapon == nil then return end
    
    local weapon_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
    if weapon_idx == nil or weapon_idx == 64 then return end
    
    local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")
    if LastShot == nil then return end
    
    local single_fire_weapon = weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or weapon_idx == 35
    local value = single_fire_weapon and 1.50 or 0.50
    local in_attack = globals.curtime() - LastShot <= value

    if tickbase > 0 and doubletap_ref then
        if in_attack then
            ui.set(refs.rage_cb[2], "Always on")
        else
            ui.set(refs.rage_cb[2], "On hotkey")
        end
    else
        ui.set(refs.rage_cb[2], "Always on")
    end
end)

client.set_event_callback("player_flags", function(ctx)
    if not ui.get(merged_enable) then return end
    if ui.get(merged_mode) ~= "A" then return end
    local e_idx = ctx.entity
    if not e_idx or not entity.is_enemy(e_idx) or not entity.is_alive(e_idx) then
        return
    end
    local stage = nade_resolver:checkResolvingStage(e_idx)
    if stage then
        ctx:add_flag(stage, 255, 255, 255, 255)
    end
end)

client.set_event_callback("net_update_start", function()
    roll_resolver:safe_init()
    roll_resolver:update()
end)
client.set_event_callback("aim_hit", function(e)
    roll_resolver:safe_init()
    roll_resolver:on_aim_hit(e)
end)
client.set_event_callback("aim_miss", function(e)
    if not ui.get(merged_enable) or not ui.get(adaptive_mode_enabled) then return end
    
    local idx = e.target
    if not idx or not entity.is_alive(idx) then return end
    
    if e.reason == "spread" then return end
    
    local angle = 0
    if roll_resolver.players[idx] and roll_resolver.players[idx].resolved_angles then
        angle = roll_resolver.players[idx].resolved_angles.yaw or 0
    end
    
    adaptive_resolver:record_miss(idx, angle, e.reason)
end)

client.register_esp_flag("SCAN", 150, 150, 255, function(idx)
    if not ui.get(merged_enable) then return false end
    local data = roll_resolver.players[idx]
    if not data then return false end
    
    -- Track consecutive hits and misses
    data.consecutive_hits = data.consecutive_hits or 0
    data.consecutive_misses = data.consecutive_misses or 0
    
    -- Show SCAN if we're in SCAN state or have missed twice after being RESOLVED
    if data.state == "SCAN" or data.consecutive_misses >= 2 then
        return true
    end
    return false
end)

client.register_esp_flag("RESOLVED", 0, 255, 0, function(idx)
    if not ui.get(merged_enable) then return false end
    local data = roll_resolver.players[idx]
    if not data then return false end
    
    -- Show RESOLVED if we've hit the player at least twice and haven't missed twice since
    if data.consecutive_hits >= 2 and data.consecutive_misses < 2 then
        return true
    end
    return false
end)

client.set_event_callback("aim_hit", function(e)
    if not ui.get(merged_enable) then return end
    local idx = e.target
    
    if not roll_resolver.players[idx] then
        roll_resolver:init_player(idx)
    end
    
    local data = roll_resolver.players[idx]
    data.hits = (data.hits or 0) + 1
    data.consecutive_hits = (data.consecutive_hits or 0) + 1
    data.consecutive_misses = 0  
    
    if data.consecutive_hits >= 2 then
        data.state = "RESOLVED"
    end
    
    if ui.get(adaptive_mode_enabled) then
        if roll_resolver.players[idx] and roll_resolver.players[idx].resolved_angles then
            adaptive_resolver:record_hit(idx, roll_resolver.players[idx].resolved_angles.yaw)
        end
    end
    
    if bruteforce_state[idx] then
        local current_angle = roll_resolver.players[idx] and 
                             roll_resolver.players[idx].resolved_angles.yaw or 0
        
        bruteforce_state[idx].best_angle = current_angle
        bruteforce_state[idx].best_angle_hits = (bruteforce_state[idx].best_angle_hits or 0) + 1
        bruteforce_state[idx].last_change = globals.realtime() + 1.0 
    end
    
    if not roll_resolver.mode_effectiveness then
        roll_resolver.mode_effectiveness = {
            ["Aggressive"] = { hits = 0, misses = 0 },
            ["Balanced"] = { hits = 0, misses = 0 },
            ["Conservative"] = { hits = 0, misses = 0 }
        }
    end
    
    local current_mode = ui.get(merged_mode)
    if current_mode ~= "Auto" then
        if not roll_resolver.mode_effectiveness[current_mode] then
            roll_resolver.mode_effectiveness[current_mode] = { hits = 0, misses = 0 }
        end
        roll_resolver.mode_effectiveness[current_mode].hits = 
            (roll_resolver.mode_effectiveness[current_mode].hits or 0) + 1
    end
    
    roll_resolver:on_aim_hit(e)
end)

client.set_event_callback("player_connect_full", function(e)
    if not ui.get(merged_enable) then return end
    update_player_list()
    
    local players = entity.get_players(true)
    if players then
        for i = 1, #players do
            local idx = players[i]
            if not roll_resolver.players[idx] then
                roll_resolver:init_player(idx)
            end
            
            if ui.get(adaptive_mode_enabled) and not adaptive_resolver.players[idx] then
                adaptive_resolver:init_player(idx)
            end
        end
    end
    
    update_ui_visibility()
end)


-- Update the aim_miss event handler to track consecutive misses
client.set_event_callback("aim_miss", function(e)
    if not ui.get(merged_enable) then return end
    local idx = e.target
    
    if not roll_resolver.players[idx] then
        roll_resolver:init_player(idx)
    end
    
    local data = roll_resolver.players[idx]
    data.misses = (data.misses or 0) + 1
    data.consecutive_misses = (data.consecutive_misses or 0) + 1
    data.consecutive_hits = 0  -- Reset consecutive hits when we miss
    
    if data.consecutive_misses >= 2 and data.state == "RESOLVED" then
        data.state = "SCAN"
    end
    
    roll_resolver:on_aim_miss(e)
end)

client.register_esp_flag("prediction", 0, 255, 0, function(idx)
    if not ui.get(prediction_enabled) then 
        return false 
    end
    
    if not entity.is_enemy(idx) or not entity.is_alive(idx) then 
        return false 
    end
    
    local predicted = predict_enemy_movement(idx, 0.5)
    if not predicted then
        return false
    end
    
    local origin = {
        x = entity.get_prop(idx, "m_vecOrigin[0]") or 0,
        y = entity.get_prop(idx, "m_vecOrigin[1]") or 0,
        z = entity.get_prop(idx, "m_vecOrigin[2]") or 0,
    }
    
    local dx = predicted.x - origin.x
    local dy = predicted.y - origin.y
    local dist = math.sqrt(dx * dx + dy * dy)
    local threshold = 0.1 
    
    return dist > threshold
end)

client.register_esp_flag("prediction", 75, 0, 130, function(idx)
    if not ui.get(prediction_enabled) then 
        return false 
    end
    
    if not entity.is_enemy(idx) or not entity.is_alive(idx) then 
        return false 
    end
    
    local predicted = predict_enemy_movement(idx, 0.5)
    if not predicted then
        return false
    end
    
    local origin = {
        x = entity.get_prop(idx, "m_vecOrigin[0]") or 0,
        y = entity.get_prop(idx, "m_vecOrigin[1]") or 0,
        z = entity.get_prop(idx, "m_vecOrigin[2]") or 0,
    }
    
    local dx = predicted.x - origin.x
    local dy = predicted.y - origin.y
    local dist = math.sqrt(dx * dx + dy * dy)
    local threshold = 0.1
    
    return dist <= threshold
end)

local autostop = {
    enabled = false,
    ground_speed_threshold = 5.0,
    air_speed_multiplier   = 0.65,
    min_speed              = 1.0,
    slowdown_factor        = 0.5 
}

local autostop_enabled = ui.new_checkbox("RAGE", "Other", "Enable Autostop")
local autostop_options = ui.new_multiselect("RAGE", "Other", "Autostop options", {
    "Stop on ground",
    "Early prediction"
})

local function is_on_ground(flags)
    return bit.band(flags or 0, bit.lshift(1, 0)) ~= 0
end

local function get_velocity(player)
    local vx = entity.get_prop(player, "m_vecVelocity[0]") or 0
    local vy = entity.get_prop(player, "m_vecVelocity[1]") or 0
    return vx, vy, math.sqrt(vx * vx + vy * vy)
end

local function calculate_movement(cmd, velocity_x, velocity_y, multiplier)
    multiplier = multiplier or 1.0
    local yaw = math.deg(math.atan2(velocity_y, velocity_x))
    local move_angle = normalize_angle(cmd.yaw - yaw)
    local sin_rot = math.sin(math.rad(move_angle))
    local cos_rot = math.cos(math.rad(move_angle))
    local forward_move = cos_rot * velocity_x + sin_rot * velocity_y
    local side_move    = sin_rot * velocity_x - cos_rot * velocity_y
    return -forward_move * multiplier, -side_move * multiplier
end


-- Define the apply_enhanced_autostop function before it's used
function apply_enhanced_autostop(cmd)
    if not ui.get(autostop_enabled) then return end
    local options = ui.get(autostop_options)
    if #options == 0 then return end

    local player = entity.get_local_player()
    if not player or not entity.is_alive(player) then return end

    local weapon = entity.get_player_weapon(player)
    if not weapon then return end

    local next_attack = entity.get_prop(weapon, "m_flNextPrimaryAttack") or 0
    local server_time = globals.curtime()
    local can_shoot   = (next_attack <= server_time)

    local in_attack = bit.band(cmd.buttons, bit.lshift(1, 0)) ~= 0
    local should_slow = false

    if in_attack and can_shoot then
        should_slow = true
    end

    if not should_slow and has_value(options, "Early prediction") then
        local time_to_shot = next_attack - server_time
        if time_to_shot > 0 and time_to_shot < 0.15 then
            should_slow = true
        end
    end

    if not should_slow then
        return
    end

    local vx, vy, speed = get_velocity(player)
    if speed < autostop.min_speed then return end

    local flags = entity.get_prop(player, "m_fFlags") or 0
    local on_ground = is_on_ground(flags)

    if on_ground and has_value(options, "Stop on ground") then
        local forward_move, side_move = calculate_movement(cmd, vx, vy)
        cmd.forwardmove = forward_move * autostop.slowdown_factor
        cmd.sidemove    = side_move * autostop.slowdown_factor
    end
end

client.set_event_callback("setup_command", function(cmd)
    apply_enhanced_autostop(cmd)
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase") - globals.tickcount()
    local refs = {
        rage_cb = { ui.reference("RAGE", "Aimbot", "Enabled") },
        dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
        fake_duck = ui.reference("RAGE","Other","Duck peek assist"),
    }
    if not refs then return end
    local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2]) and not ui.get(refs.fake_duck)
    local active_weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if active_weapon == nil then return end
    local weapon_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
    if weapon_idx == nil or weapon_idx == 64 then return end
    local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")
    if LastShot == nil then return end
    local single_fire_weapon = weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or weapon_idx == 35
    local value = single_fire_weapon and 1.50 or 0.50
    local in_attack = globals.curtime() - LastShot <= value

    if tickbase > 0 and doubletap_ref then
        if in_attack then
            ui.set(refs.rage_cb[2], "Always on")
        else
            ui.set(refs.rage_cb[2], "On hotkey")
        end
    else
        ui.set(refs.rage_cb[2], "Always on")
    end
end)


local watermark = {
    text_parts = {
        {text = "game",   color = {255,255,255}},
        {text = "sense",  color = {0,255,127}},
        {text = " | ",    color = {255,255,255}},
        {text = "Claude", color = {130,207,255}}
    },
    background  = {0,0,0,200},
    background2 = {0,0,0,100},
    background3 = {45,45,45,255},
    glow_color  = {255,255,255,55},
    animation   = { opacity = 255, glow_intensity = 0 }
}

local function get_animated_color(base_color, time_offset)
    local intensity = math.sin(globals.realtime() * 2 + time_offset) * 0.15 + 0.85
    return {
        math.min(255, base_color[1] * intensity),
        math.min(255, base_color[2] * intensity),
        math.min(255, base_color[3] * intensity)
    }
end

local function render_watermark()
    if not ui.get(merged_enable) then return end
    local realtime = globals.tickcount()
    watermark.animation.glow_intensity = math.sin(realtime * 2) * 0.5 + 0.5
    local total_width = 0
    for _, part in ipairs(watermark.text_parts) do
        local w, _ = renderer.measure_text(nil, part.text)
        total_width = total_width + w
    end

    local x = screen_w - total_width - 20
    local y = 15
    local h = select(2, renderer.measure_text(nil, "H"))

    renderer.gradient(
        x - 7, y - 4, total_width + 14, h + 10,
        watermark.background3[1], watermark.background3[2], watermark.background3[3], watermark.background3[4],
        watermark.background3[1], watermark.background3[2], watermark.background3[3], watermark.background3[4],
        false
    )

    for i = 0, 3 do
        renderer.gradient(
            x - 5 - i, y - 2 - i, total_width + 10 + i*2, h + 6 + i*2,
            watermark.background[1],  watermark.background[2],  watermark.background[3],  watermark.background[4]  * (1 - i/4),
            watermark.background2[1], watermark.background2[2], watermark.background2[3], watermark.background2[4] * (1 - i/4),
            false
        )
    end

    for i = 1, 8 do
        renderer.blur(x - 5, y - 5, total_width + 10, h + 6)
    end

    local current_x = x
    for part_idx, part in ipairs(watermark.text_parts) do
        local color = get_animated_color(part.color, part_idx * 0.5)
        renderer.text(current_x, y, color[1], color[2], color[3], watermark.animation.opacity, nil, 0, part.text)
        current_x = current_x + renderer.measure_text(nil, part.text)
    end
end

client.set_event_callback("paint", render_watermark)


client.set_event_callback("shutdown", function()
    save_presets()
    roll_resolver:cleanup()
end)