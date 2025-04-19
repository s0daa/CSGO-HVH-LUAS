
local queue = {}

local function aim_fire(c)
	queue[globals.tickcount()] = {c.x,c.y,c.z, globals.curtime() + 2}
end

local function paint(c)
	for tick, data in pairs(queue) do
        if globals.curtime() <= data[4] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
               --renderer.circle_outline(x1,y1,255,255,255,255,5,0,1.0,1)
			   renderer.line(x1 - 6,y1,x1 + 6,y1,0, 204, 153,255)
			   renderer.line(x1,y1 - 6,x1,y1 + 6 ,0, 204, 153,255)
            end
        end
    end
end

client.set_event_callback("aim_fire",aim_fire)
client.set_event_callback("paint",paint)

client.set_event_callback("round_prestart", function()
    queue = {}
end)


-- Hitmarker и Kill Effect by Gamesense
local hit_queue = {}
local kill_effects = {
    particles = {},
    last_kill = 0
}
local circles_queue = {} -- Таблица для хранения активных кругов
-- Настройки UI
local ui_elements = {
    kill_color = ui.new_color_picker('VISUALS', 'Effects', 'Kill effect', 0, 180, 255, 185),
    kill_effect = ui.new_checkbox('VISUALS', 'Effects', 'Kill effect')
}

local queue = {}

local function aim_fire(c)
    queue[globals.tickcount()] = {c.x,c.y,c.z, globals.curtime() + 2}
end

local circles_queue = {}

local function draw_circle_3d(x, y, z, radius, r, g, b, a)
    local segments = 60
    local prev_sx, prev_sy

    for i = 0, segments do
        local angle = math.rad((i / segments) * 360)
        local px = x + math.cos(angle) * radius
        local pz = z + math.sin(angle) * radius
        local sx, sy = renderer.world_to_screen(px, y, pz)
        
        if sx and sy then
            if prev_sx and prev_sy then
                renderer.line(prev_sx, prev_sy, sx, sy, r, g, b, a)
            end
            prev_sx, prev_sy = sx, sy
        else
            prev_sx, prev_sy = nil, nil
        end
    end
end
local function paint(c)
    for tick, data in pairs(queue) do
        if globals.curtime() <= data[4] then
            local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
            if x1 ~= nil and y1 ~= nil then
               renderer.line(x1 - 6,y1,x1 + 6,y1,0, 204, 153,255)
               renderer.line(x1,y1 - 6,x1,y1 + 6 ,0, 204, 153,255)
            end
        end
    end
end

client.set_event_callback("aim_fire", aim_fire)
client.set_event_callback("paint", paint)

client.set_event_callback("round_prestart", function()
    queue = {}
end)



-- Kill Effect
local function create_kill_effect(x, y, z)
    for i = 1, 24 do  -- Увеличено количество частиц
        local angle = math.rad(i * 15)  -- Уменьшен угол между частицами
        local speed = 1.5 + math.random() * 1.0  -- Замедлена начальная скорость
        local particle = {
            pos = {x = x, y = y, z = z},
            velocity = {
                x = math.cos(angle) * speed,
                y = math.sin(angle) * speed,
                z = math.random() * 1.5  -- Уменьшена вертикальная скорость
            },
            life = 0,
            size = 4 + math.random() * 3,  -- Увеличен начальный размер
            alpha = 255,
            color = {ui.get(ui_elements.kill_color)}
        }
        table.insert(kill_effects.particles, particle)
    end
end
local function draw_kill_effect()
    local r, g, b, a = ui.get(ui_elements.kill_color)
    
    for i = #kill_effects.particles, 1, -1 do
        local p = kill_effects.particles[i]
        p.life = p.life + globals.frametime()
        
        -- Обновление позиции
        p.pos.x = p.pos.x + p.velocity.x
        p.pos.y = p.pos.y + p.velocity.y
        p.pos.z = p.pos.z + p.velocity.z * 0.5
        
        -- Физика
        p.velocity.z = p.velocity.z - 0.08
        p.alpha = math.max(0, 255 - (p.life * 400))
        p.size = p.size * (1 - p.life * 0.5)
        
        -- Отрисовка (только основная частица)
        local x, y = renderer.world_to_screen(p.pos.x, p.pos.y, p.pos.z)
        if x and y then
            renderer.circle(x, y, r, g, b, p.alpha, p.size, 0, 1, 2)
            renderer.circle(x, y, 50, 50, 50, p.alpha * 0.3, p.size * 2, 0, 1, 1)
        end
        
        if p.life > 0.8 then
            table.remove(kill_effects.particles, i)
        end
    end
end











-- Конфигурация
local config = {
    color = ui.new_color_picker('LUA', 'A', 'Effect color', 20, 100, 120, 90)
}

-- Анимационная система
local animation = {
    progress = 0,
    active = false,
    start_time = 0
}

local function start_animation()
    animation.active = true
    animation.start_time = globals.realtime()
    animation.progress = 0
end

local function update_animation()
    if not animation.active then return end
    
    animation.progress = math.min((globals.realtime() - animation.start_time) / 0.7, 1)
    
    if animation.progress >= 1 then
        animation.active = false
    end
end

local function draw_edge_effect()
    if not animation.active then return end
    
    -- Инициализация размеров экрана внутри функции отрисовки
    local screen_w, screen_h = client.screen_size()
    local r, g, b, a = ui.get(config.color)
    local intensity = 1
    
    -- Плавное затухание
    local alpha = a * (1 - animation.progress^3) * intensity
    
    -- Боковые полосы
    renderer.gradient(
        0, 0,
        55, screen_h,
        r, g, b, alpha * 0.8,
        r, g, b, alpha * 0.2,
        true
    )
    
    renderer.gradient(
        screen_w - 55, 0,
        55, screen_h,
        r, g, b, alpha * 0.2,
        r, g, b, alpha * 0.8,
        true
    )
    
    -- Верхний/нижний градиенты
    local vertical_alpha = alpha * 0.4
    renderer.gradient(
        55, 0,
        screen_w - 55*2, 15,
        r, g, b, vertical_alpha,
        r, g, b, 0,
        false
    )
    
    renderer.gradient(
        55, screen_h - 15,
        screen_w - 55*2, 15,
        r, g, b, 0,
        r, g, b, vertical_alpha,
        false
    )
end

client.set_event_callback('player_death', function(e)
    if client.userid_to_entindex(e.attacker) ~= entity.get_local_player() then return end
    if not ui.get(ui_elements.kill_effect) then return end
    
    local victim = client.userid_to_entindex(e.userid)
    local head_pos = {entity.hitbox_position(victim, 0)}
    local feet_pos = {entity.get_origin(victim)}
    
    -- Добавляем анимированный круг
    table.insert(circles_queue, {
        start_pos = {x = feet_pos[1], y = feet_pos[2], z = feet_pos[3]},
        end_pos = {x = head_pos[1], y = head_pos[2], z = head_pos[3]},
        start_time = globals.curtime(),
        duration = 1.0, -- Длительность анимации в секундах
        radius = 25,
        color = {r = 0, g = 205, b = 255, a = 180}
    })
end)

client.set_event_callback('paint', function()
    for i = #circles_queue, 1, -1 do
        local circle = circles_queue[i]
        local progress = (globals.curtime() - circle.start_time) / circle.duration
        
        if progress >= 1 then
            table.remove(circles_queue, i)
        else
            -- Интерполяция позиции
            local current_x = circle.start_pos.x + (circle.end_pos.x - circle.start_pos.x) * progress
            local current_y = circle.start_pos.y + (circle.end_pos.y - circle.start_pos.y) * progress
            local current_z = circle.start_pos.z + (circle.end_pos.z - circle.start_pos.z) * progress
            
            -- Плавное затухание
            local alpha = circle.color.a * (1 - progress)
            
            -- Отрисовка
            draw_circle_3d(
                current_x,
                current_y,
                current_z,
                circle.radius,
                circle.color.r,
                circle.color.g,
                circle.color.b,
                alpha
            )
        end
    end
end)
client.set_event_callback('player_death', function(e)
    if client.userid_to_entindex(e.attacker) ~= entity.get_local_player() then return end
    start_animation()
end)

client.set_event_callback('paint', function()
    update_animation()
    draw_edge_effect()
end)


-- Обработчики событий
client.set_event_callback('aim_fire', function(e)
    if e.result == 'hit' then
        aim_fire(e)
    end
end)

client.set_event_callback('player_death', function(e)
    if client.userid_to_entindex(e.attacker) ~= entity.get_local_player() then return end
    if not ui.get(ui_elements.kill_effect) then return end
    
    local victim = client.userid_to_entindex(e.userid)
    local head_pos = {entity.hitbox_position(victim, 0)}
    create_kill_effect(head_pos[1], head_pos[2], head_pos[3])
    kill_effects.last_kill = globals.curtime()
end)

client.set_event_callback('paint', function()
    if ui.get(ui_elements.kill_effect) then
        draw_kill_effect()
    end
end)

client.set_event_callback('round_start', function()
    hit_queue = {}
    kill_effects.particles = {}
end)