--[[ 
    ______              _______  _______ _________ _______ _________ _______                   
(  ___ \ |\     /|  (  ____ \(  ____ )\__   __/(  ____ \\__   __/(  ____ \|\     /||\     /|
| (   ) )( \   / )  | (    \/| (    )|   ) (   | (    \/   ) (   | (    \/| )   ( || )   ( |
| (__/ /  \ (_) /   | (__    | (____)|   | |   | (_____    | |   | |      | (___) || (___) |
|  __ (    \   /    |  __)   |     __)   | |   (_____  )   | |   | |      |  ___  ||  ___  |
| (  \ \    ) (     | (      | (\ (      | |         ) |   | |   | |      | (   ) || (   ) |
| )___) )   | |     | )      | ) \ \_____) (___/\____) |___) (___| (____/\| )   ( || )   ( |
|/ \___/    \_/_____|/       |/   \__/\_______/\_______)\_______/(_______/|/     \||/     \|
              (_____)                                                                       
]]

local ffi = require 'ffi'
local http = require 'gamesense/http'

-- Настройка файловой системы
local filesystem = {}
do
    local m, i = "filesystem_stdio.dll", "VFileSystem017"
    local add_search_path = vtable_bind(m, i, 11, "void (__thiscall*)(void*, const char*, const char*, int)")
    local remove_search_path = vtable_bind(m, i, 12, "bool (__thiscall*)(void*, const char*, const char*)")
    local get_game_directory = vtable_bind("engine.dll", "VEngineClient014", 36, "const char*(__thiscall*)(void*)")
    filesystem.game_directory = string.sub(ffi.string(get_game_directory()), 1, -5)
    add_search_path(filesystem.game_directory, "ROOT_PATH", 0)
    defer(function() remove_search_path(filesystem.game_directory, "ROOT_PATH") end)
    filesystem.create_directory = vtable_bind(m, i, 22, "void (__thiscall*)(void*, const char*, const char*)")
end

-- Создание папки Omicron
filesystem.create_directory("Macarone", "ROOT_PATH")

-- Переменные для анимации
local MacaroneImage
local is_displaying = true
local timer = globals.realtime()
local display_time = 2 -- Время отображения в секундах

-- Функция lerp для анимации
local function lerp(start, end_pos, speed)
    local frametime = globals.frametime() * speed
    local val = start + (end_pos - start) * frametime
    return math.abs(val - end_pos) < 0.01 and end_pos or val
end

-- Загрузка текстуры по URL
local load_textures = function(data)
    MacaroneImage = renderer.load_png(data, 1920, 1920) -- Загружаем ваше изображение в нужном размере
end

http.get("https://github.com/frisichh/macarone.lua/blob/main/1075cee6-8597-4520-91ab-16a570d26cec-removebg-preview(1).png?raw=true", function(success, raw)
    if success and string.sub(raw.body, 2, 4) == "PNG" then
        load_textures(raw.body)
    else
        -- Сообщение удалено
    end
end)

-- Анимация отображения
local motion = { base_speed = 6, _list = {} }
motion.new = function(name, new_value, speed, init)
    speed = speed or motion.base_speed
    motion._list[name] = motion._list[name] or (init or 0)
    motion._list[name] = lerp(motion._list[name], new_value, speed)
    return motion._list[name]
end

client.set_event_callback('paint', function()
    if not MacaroneImage then
        -- Сообщение удалено
        return
    end

    local width, height = client.screen_size()
    local alpha_value = motion.new("alpha_value", is_displaying and 145 or 0, 6)
    local texture_alpha = motion.new("texture_alpha", is_displaying and 255 or 0, 6)

    renderer.rectangle(0, 0, width, height, 0, 0, 0, alpha_value)
    local texture_w, texture_h = 500, 500
    renderer.texture(MacaroneImage, width / 2 - texture_w / 2, height / 2 - texture_h / 2, texture_w, texture_h, 255, 255, 255, texture_alpha, "f")

    -- Логика таймера
    if is_displaying and globals.realtime() - timer > display_time then
        is_displaying = false
    end
end)

-- Далее ваш существующий код...
local easing = require 'gamesense/easing'
-- ... (остальной код остаётся без изменений)

local function rgbtohex(r, g, b)
    r = tostring(r); g = tostring(g); b = tostring(b)
    r = (r:len() == 1) and '0'..r or r; g = (g:len() == 1) and '0'..g or g; b = (b:len() == 1) and '0'..b or b
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local function render_rectangle_rounded(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local datacircle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    }
    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    }
    for _, data in pairs(datacircle) do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end
    for _, data in pairs(data) do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

local function renderer_shit(x, y, w, r, g, b, a, edge_h)
    local opacity = 0
    opacity = easing.quad_in(0.5, opacity, (ui.is_menu_open() and 180 or 0) - opacity, 3)
    render_rectangle_rounded(x + 1, y+10, w - 3 , 48, 20, 20, 20, opacity, 10)
    render_rectangle_rounded(x+1, y-2, w-3, 19, 20, 20, 20, 255, 4)
    render_rectangle_rounded(x, y-3, w-1, 21, 15, 15, 15, 120, 4)
end


local ui_get = ui.get
local js = panorama.open() 
local steam_name = js.MyPersonaAPI.GetName() 
local nick_name = "" ..steam_name
local script_version = "1.6" 
local session_start = globals.realtime() 

-- UI Library Shortcuts 
local ui = { 
    get = ui.get, 
    set = ui.set, 
    new_checkbox = ui.new_checkbox, 
    new_combobox = ui.new_combobox, 
    new_slider = ui.new_slider, 
    new_color_picker = ui.new_color_picker, 
    new_hotkey = ui.new_hotkey, 
    new_label = ui.new_label, 
    new_button = ui.new_button, 
    reference = ui.reference, 
    set_visible = ui.set_visible, 
    set_callback = ui.set_callback,
	is_menu_open = ui.is_menu_open, -- добавленная строка
	mouse_position = ui.mouse_position
} 

local entity = {
    get_local_player = entity.get_local_player,
    get_prop = entity.get_prop,
    set_prop = entity.set_prop,
    is_enemy = entity.is_enemy,
    is_alive = entity.is_alive,
    get_players = entity.get_players,
    get_bounding_box = entity.get_bounding_box,
	get_player_name = entity.get_player_name,
    get_origin = entity.get_origin,
    get_player_weapon = entity.get_player_weapon,
    get_classname = entity.get_classname,
    get_entity = entity.get_entity,
    is_dormant = entity.is_dormant
}

local renderer = {
    text = renderer.text,
    gradient = renderer.gradient,
    rectangle = renderer.rectangle,
    line = renderer.line,
    world_to_screen = renderer.world_to_screen,
    indicator = renderer.indicator,
	measure_text = renderer.measure_text -- добавлена строка
}

local globals = {
    realtime = globals.realtime,
    tickinterval = globals.tickinterval,
    frametime = globals.frametime,
    tickcount = globals.tickcount
}

--[[=============== CORE VARIABLES ===============]]
local tabs = {"Home", "Information", "Rage", "Visual", "Misc"}
local selected_tab = ui.new_combobox("LUA", "B", "Tab Selection", tabs)

--[[=============== MAIN TAB ===============]]
main_content = {
    header = ui.new_label("LUA", "B", "Welcome \a9FCA2BFF " ..steam_name),
    version = ui.new_label("LUA", "B", "Version 1.6 | Private Build"),
    youtube_btn = ui.new_button("LUA", "B", "YouTube Channel ", function() 
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://www.youtube.com/@frisich") 
    end),
    discord_btn = ui.new_button("LUA", "B", "Discord Server ", function()
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/eWpwu6ewXV")
    end),
    config_btn = ui.new_button("LUA", "B", "My config ", function() -- переименовано
        panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://funpay.com/lots/offer?id=35077086")
    end),
    separator = ui.new_label("LUA", "B", "▰▰▰▰▰▰▰▰卍▰▰▰▰▰▰▰▰")
}

--[[=============== DRAW SCRIPT TITLE ===============]]
local function draw_script_title()
    local tick = globals.tickcount() * 0.03
    local r = math.sin(tick) * 127 + 128
    local g = math.sin(tick + 2) * 127 + 128
    local b = math.sin(tick + 4) * 127 + 128

    local text = "macarone.lua"
    local screen_w, screen_h = client.screen_size()
    local text_length = 11 * 7
    local x = (screen_w - text_length) / 2
    local y = 25

    renderer.text(x + 1, y + 1, 0, 0, 0, 255, nil, 0, text)
    renderer.text(x, y, r, g, b, 255, nil, 0, text)
    return x, y, text_length
end

--[[=============== INFORMATION TAB INTEGRATION ===============]]
local icons = {
    main = "",      -- Иконка главного меню
    info = "",      -- Иконка информации
    version = "",   -- Иконка версии
    time = "",      -- Иконка времени
    update = ""     -- Иконка обновления
}

-- Цветовая палитра
local colors = {
    mint = {160, 255, 160},       -- Мятный
    teal = {0, 200, 150},         -- Бирюзовый
    glow = {220, 255, 220},       -- Свечение
    accent = "FFA0FFA0"           -- Салатовый акцент
}

local function wave_gradient(text, time)
    local result = ""
    local length = #text
    
    for i = 1, length do
        local pos = i / length
        local wave = math.sin(time * 4 + pos * 6) * 0.4 + 0.6
        
        -- Интерполяция цветов
        local r = colors.mint[1] * wave + colors.teal[1] * (1 - wave)
        local g = colors.mint[2] * wave + colors.teal[2] * (1 - wave)
        local b = colors.mint[3] * wave + colors.teal[3] * (1 - wave)
        
        -- Эффект свечения
        local glow_intensity = math.abs(math.sin(time * 8 + i * 0.5)) * 50
        r = math.min(255, r + glow_intensity)
        g = math.min(255, g + glow_intensity)
        b = math.min(255, b + glow_intensity)

        result = result .. string.format("\a%02X%02X%02XFF%s", 
            math.floor(r),
            math.floor(g),
            math.floor(b),
            text:sub(i, i)
        )
    end
    return result
end

local info_content = {
    main_selector = ui.new_label("LUA", "B", " Information"),
    welcome_label = ui.new_label("LUA", "B", " "),
    version_label = ui.new_label("LUA", "B", " "),
    update_label = ui.new_label("LUA", "B", icons.update .. " Last update was \a" .. colors.accent .. "23.03.2025"),
    time_label = ui.new_label("LUA", "B", " ")
}

--[[=============== СЕССИЯ И АНИМАЦИИ ===============]]
local function update_labels()
    local current_time = globals.realtime()
    ui.set(info_content.welcome_label, icons.main .. " Welcome back " .. wave_gradient(nick_name, current_time))
    ui.set(info_content.version_label, icons.version .. " Version: " .. wave_gradient(script_version, current_time))
end

local function update_display()
    local session_time = globals.realtime() - session_start
    ui.set(info_content.time_label, string.format(
        "%s Session time: \a%s%02d:%02d:%02d",
        icons.time,
        colors.accent,
        math.floor(session_time/3600),
        math.floor(session_time/60%60),
        math.floor(session_time%60)
    ))
end
--[[=============== SESSION INFO ===============]]
session_info = {
    start_time = globals.realtime(),
    last_update = "23.03.2025",
    version = script_version, -- Используем переменную версии скрипта
    welcome = info_content.welcome_label -- Используем существующий элемент
}

local function update_session_time()
    if session_info and session_info.start_time then
        local elapsed_time = globals.realtime() - session_info.start_time
        local minutes = math.floor(elapsed_time / 60)
        local seconds = math.floor(elapsed_time % 60)
        ui.set(info_content.time_label, string.format("Session time: %02d:%02d", minutes, seconds))
    end
end

client.set_event_callback("paint", update_session_time) -- Обновляем каждую отрисовку

--[[=============== GRADIENT FUNCTION ===============]]

--[[=============== TEXT ANIMATION ===============]]
local function animate_text()
    local current_time = globals.realtime()
    local wave_text = wave_gradient(nick_name, current_time) -- Теперь функция определена
    ui.set(session_info.welcome, " Welcome back: \aFFA0FFA0" .. wave_text)
end
--[[=============== SESSION TIME UPDATE ===============]]
local function update_time()
    local session_time = globals.realtime() - session_start
    ui.set(info_content.time_label, string.format(
        " Session time: \aFFA0FFA0%02d:%02d:%02d",
        math.floor(session_time/3600),
        math.floor(session_time/60%60),
        math.floor(session_time%60)
    ))
end


client.set_event_callback("paint_ui", function()
    update_labels() -- Оставляем только актуальные обновления
    update_display()
end)

--[[=============== VISUAL TAB ===============]]
local visual_separator = ui.new_label("LUA", "B", "\aFFD700FF︻デ═一")

-- UI элементы для кейбиндов
local enable_keybinds_display = ui.new_checkbox("LUA", "B", "Enable Keybinds Display")
local rounding_ref = ui.new_slider("LUA", "B", "Keybind Rounding", 0, 10, 4, true, nil, 1)
local text_color_ref = ui.new_color_picker("LUA", "B", "Text Color", 255, 255, 255, 255)
local outline_color_ref = ui.new_color_picker("LUA", "B", "Outline Color", 170, 170, 170, 255)


-- Переменные для перетаскивания окна
local is_dragging = false
local drag_offset_x, drag_offset_y = 0, 0
local x_pos, y_pos = 100, 100

-- Сохранение и загрузка позиции окна
local function save_position()
    database.write("keybinds_window_pos", {x = x_pos, y = y_pos})
end

local function load_position()
    local saved_pos = database.read("keybinds_window_pos")
    if saved_pos then
        x_pos = saved_pos.x
        y_pos = saved_pos.y
    else
        x_pos = 10
        y_pos = 10
    end
end
load_position()

-- Ссылки на кейбинды из меню
local dt_ref, dt_key = ui.reference("RAGE", "Aimbot", "Double Tap")
local min_dmg_override_ref, min_dmg_override_key = ui.reference("RAGE", "Aimbot", "Minimum damage override")
local fd_ref = ui.reference("RAGE", "Other", "Duck peek assist")
local os_ref, os_key = ui.reference("AA", "Other", "On shot anti-aim")
local slow_walk_ref, slow_walk_key = ui.reference("AA", "Other", "Slow motion")

-- Список кейбиндов
local keybinds = {
    { name = "Double Tap", ref = dt_ref, key = dt_key, get_status = function() return ui.get(dt_ref) and ui.get(dt_key) end, get_text = function() return "Double tap [holding]" end, icon = "" },
    { name = "Fake Duck", ref = fd_ref, get_status = function() return ui.get(fd_ref) end, get_text = function() return "Fake duck [holding]" end, icon = "" },
    { name = "Hide Shots", ref = os_ref, key = os_key, get_status = function() return ui.get(os_ref) and ui.get(os_key) end, get_text = function() return "Hide shots [holding]" end, icon = "" },
    { name = "Min Damage Override", ref = min_dmg_override_ref, key = min_dmg_override_key, get_status = function() return ui.get(min_dmg_override_ref) and ui.get(min_dmg_override_key) end, get_text = function() return "Min. damage [holding]" end, icon = "" },
    { name = "Slow Walk", ref = slow_walk_ref, key = slow_walk_key, get_status = function() return ui.get(slow_walk_ref) and ui.get(slow_walk_key) end, get_text = function() return "Slow motion [holding]" end, icon = "" },
}

-- Функция отрисовки кейбиндов
local keybinds_alpha = 0
local function draw_keybinds()
    if not ui.get(enable_keybinds_display) then
        keybinds_alpha = 0
        return
    end

    local rounding = math.max(1, ui.get(rounding_ref))
    local text_r, text_g, text_b, text_a = ui.get(text_color_ref)
    local outline_r, outline_g, outline_b, outline_a = ui.get(outline_color_ref)

    local max_width = 0
    local active_count = 0

    for _, bind in ipairs(keybinds) do
        local is_active = bind.get_status()
        if is_active then
            local text_width = renderer.measure_text("o", bind.get_text()) + 8
            max_width = math.max(max_width, text_width)
            active_count = active_count + 1
        end
    end

    local header_text = "keybinds"
    local header_width = renderer.measure_text("o", header_text) + 10
    max_width = math.max(max_width, header_width)

    local frames = 8 * globals.frametime()
    if active_count > 0 or ui.is_menu_open() then
        keybinds_alpha = keybinds_alpha + frames; if keybinds_alpha > 1 then keybinds_alpha = 1 end
    else
        keybinds_alpha = keybinds_alpha - frames; if keybinds_alpha < 0 then keybinds_alpha = 0 end
    end

    if keybinds_alpha > 0 then
        local header_width_adjusted = header_width + 50
        local header_height = 18

        render_rectangle_rounded(x_pos, y_pos - 3, header_width_adjusted, header_height + 2, 20, 20, 20, 120 * keybinds_alpha, rounding)
        render_rectangle_rounded(x_pos + 1, y_pos - 2, header_width_adjusted - 2, header_height, outline_r, outline_g, outline_b, outline_a * keybinds_alpha, rounding)

        renderer.text(x_pos + (header_width_adjusted - header_width) / 2, y_pos + 1, text_r, text_g, text_b, text_a * keybinds_alpha, "o", 0, header_text)
    end

    if keybinds_alpha > 0 and active_count > 0 then
        local bind_y_offset = 22

        for _, bind in ipairs(keybinds) do
            local is_active = bind.get_status()
            if is_active then
                local text = bind.get_text()
                local bind_h = 14
                local bind_y_pos = y_pos + bind_y_offset
                local bind_width = renderer.measure_text("o", text) + 10

                render_rectangle_rounded(x_pos, bind_y_pos - 3, bind_width, bind_h + 2, 10, 10, 10, 30 * keybinds_alpha, rounding)
                render_rectangle_rounded(x_pos + 1, bind_y_pos - 2, bind_width - 2, bind_h, outline_r, outline_g, outline_b, 80 * keybinds_alpha, rounding)

                local text_x = x_pos + 5
                renderer.text(text_x, bind_y_pos + 1, text_r, text_g, text_b, text_a * keybinds_alpha, "o", 0, text)

                bind_y_offset = bind_y_offset + bind_h + 4
            end
        end
    end

    -- Добавьте этот блок для перетаскивания:
    if ui.is_menu_open() then
        local mouse_x, mouse_y = ui.mouse_position()
        local left_mouse = client.key_state(0x01)
        local header_w = header_width + 50

        if left_mouse and mouse_x >= x_pos and mouse_x <= x_pos + header_w and mouse_y >= y_pos and mouse_y <= y_pos + 15 and not is_dragging then
            is_dragging = true
            drag_offset_x = mouse_x - x_pos
            drag_offset_y = mouse_y - y_pos
        elseif is_dragging then
            x_pos = mouse_x - drag_offset_x
            y_pos = mouse_y - drag_offset_y
        end

        if not left_mouse then 
            is_dragging = false 
        end
    end
end


-- Watermark (вставьте в начало Lakaka.lua, после объявления переменных)
local ms_watermark = ui.new_checkbox("LUA", "B", "Watermark")
local ms_color = ui.new_color_picker("LUA", "B", "Watermark Color", 142, 165, 229, 85)

local obex_data = {username = entity.get_player_name(entity.get_local_player()) or 'unknown', build = 'boosters'}
local watermark_alpha = 0

local function watermark()
    local state = ui.get(ms_watermark)
    if not state then
        watermark_alpha = watermark_alpha - 8 * globals.frametime()
        if watermark_alpha < 0 then watermark_alpha = 0 end
        return
    end

    local screen = {client.screen_size()}
    local opacity = easing.quad_in(0.5, watermark_alpha, (ui.is_menu_open() and 255 or 0) - watermark_alpha, 3)

    local r, g, b, a = ui.get(ms_color)
    local wm_col = rgbtohex(r, g, b) .. 'FF'

    local data_suffix = 'macarone.lua'
    local nickname = obex_data.username
    local h, m, s = client.system_time()
    local actual_time = string.format('%2d:%02d', h, m)
    local latency = math.floor(client.latency() * 1000)
    local latency_text = string.format('  %d', latency)

    local text = string.format('\a%s%s \a737373FF/ %s /\a%s%s \a737373FFms\a%s %s\a737373FF pm', wm_col, data_suffix, nickname, wm_col, latency_text, wm_col, actual_time)
    local un, mb = 'Username - ', 'Build - '
    local un_width, mb_width = renderer.measure_text(nil, un), renderer.measure_text(nil, mb)

    local w = renderer.measure_text(nil, text) + 8
    local x, y = screen[1] - w - 10, 7

    renderer_shit(x, y, w, 65, 65, 65, 180, 2)
    renderer.text(x + 4, y + 1, 255, 255, 255, 255, '', 0, text)
    renderer.text(x + 5, y + 20, 170, 170, 170, opacity, '', 0, un)
    renderer.text(x + 5, y + 35, 170, 170, 170, opacity, '', 0, mb)
    renderer.text(x + 5 + un_width, y + 20, r, g, b, opacity, '', 0, nickname)
    renderer.text(x + 5 + mb_width, y + 35, r, g, b, opacity, '', 0, 'BOOSTERS')

    watermark_alpha = watermark_alpha + 8 * globals.frametime()
    if watermark_alpha > 1 then watermark_alpha = 1 end
end





-- Damage Indicator (обновленная версия)
local damage_indicator_enabled = ui.new_checkbox("LUA", "B", "Damage Indicator")
local damage_indicator_duration = ui.new_slider("LUA", "B", "Duration", 1, 10, 4)
local damage_indicator_speed = ui.new_slider("LUA", "B", "Speed", 1, 8, 2)
local damage_indicator_default_color = ui.new_color_picker("LUA", "B", "Default Color", 255, 255, 255, 255)
local damage_indicator_head_color = ui.new_color_picker("LUA", "B", "Head Color", 149, 184, 6, 255)
local damage_indicator_nade_color = ui.new_color_picker("LUA", "B", "Nade Color", 255, 179, 38, 255)
local damage_indicator_knife_color = ui.new_color_picker("LUA", "B", "Knife Color", 255, 255, 255, 255)
local damage_indicator_min_damage = ui.new_checkbox("LUA", "B", "Show Minimum Damage")


--[[=============== DAMAGE INDICATOR (ОРИГИНАЛЬНАЯ РЕАЛИЗАЦИЯ) ===============]]--
local damage_indicator_data = {}
local hitgroup_names = { "generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear" }

client.set_event_callback("player_hurt", function(e)
    if not ui.get(damage_indicator_enabled) then return end
    
    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)
    
    if attacker == entity.get_local_player() then
        local pos = { entity.get_prop(victim, "m_vecOrigin") }
        local view_offset = entity.get_prop(victim, "m_vecViewOffset[2]") or 0
        pos[3] = pos[3] + view_offset

        table.insert(damage_indicator_data, {
            damage = e.dmg_health,
            start_time = globals.realtime(),
            pos = pos,
            duration = ui.get(damage_indicator_duration),
            speed = ui.get(damage_indicator_speed) / 3,
            hitgroup = e.hitgroup,
            weapon = e.weapon
        })
    end
end)

client.set_event_callback("paint", function()
    local current_time = globals.realtime()
    for i = #damage_indicator_data, 1, -1 do
        local data = damage_indicator_data[i]
        local delta_time = current_time - data.start_time
        local progress = delta_time / data.duration

        if delta_time > data.duration then
            table.remove(damage_indicator_data, i)
        else
            -- Анимация подъема
            local offset_z = data.speed * delta_time * 15 -- Увеличиваем скорость
            local x, y = renderer.world_to_screen(data.pos[1], data.pos[2], data.pos[3] + offset_z)
            
            if x and y then
                local alpha = 255 - (progress * 255)
                local r, g, b = ui.get(damage_indicator_default_color)

                if data.hitgroup == 1 then
                    r, g, b = ui.get(damage_indicator_head_color)
                elseif data.weapon == "hegrenade" then
                    r, g, b = ui.get(damage_indicator_nade_color)
                elseif data.weapon == "knife" then
                    r, g, b = ui.get(damage_indicator_knife_color)
                end

                renderer.text(x, y, r, g, b, alpha, "c", 0, ui.get(damage_indicator_min_damage) and "-" .. data.damage or data.damage)
            end
        end
    end
end)



--[[=============== АНИМАЦИЯ КРЫЛЬЕВ ===============]]
local wing_animation = {
    active = false,
    start_tick = 0,
    duration_ticks = 64 -- ~0.64 секунды
}

client.set_event_callback("player_death", function(e)
    if client.userid_to_entindex(e.attacker) == entity.get_local_player() then
        wing_animation.active = true
        wing_animation.start_tick = globals.tickcount()
    end
end)

local function draw_wing_pattern(base_x, base_y, direction)
    local progress = (globals.tickcount() - wing_animation.start_tick) / wing_animation.duration_ticks
    if progress > 1 then return end
    
    local alpha = math.floor(255 * (1 - progress))
    local wing_color = {255, 223, 0, alpha} -- Золотой цвет
    
    -- Основные линии крыла
    local offsets = {
        {0, 0}, {0, 5}, {0, 10},  -- Вертикальные элементы
        {5, 2}, {10, 4},          -- Диагональные элементы
        {-5, 2}, {-10, 4}         -- Зеркальные диагонали
    }

    for _, offset in ipairs(offsets) do
        local start_x = base_x + offset[1] * direction
        local start_y = base_y + offset[2]
        local end_x = start_x + 25 * direction
        local end_y = start_y + math.sin(progress * math.pi) * 15
        
        renderer.line(
            start_x, start_y,
            end_x, end_y,
            wing_color[1], wing_color[2], wing_color[3], wing_color[4]
        )
    end
end

local function draw_wings()
    if not wing_animation.active then return end
    
    local text_x, text_y, text_width = draw_script_title()
    local wing_base_x = text_x + text_width / 2
    local wing_base_y = text_y + 15
    
    -- Левое крыло
    draw_wing_pattern(wing_base_x - 15, wing_base_y, -1)
    -- Правое крыло
    draw_wing_pattern(wing_base_x + 15, wing_base_y, 1)

    if (globals.tickcount() - wing_animation.start_tick) > wing_animation.duration_ticks then
        wing_animation.active = false
    end
end

client.set_event_callback("paint", function()
    draw_script_title()
    draw_wings()
	watermark()
end)


--[[=============== ANIMATION ZOOM ===============]] 
local animation_zoom_enabled = ui.new_checkbox("LUA", "B", "Enable Animation Zoom")
local animation_zoom_fov = ui.new_slider("LUA", "B", "Amount FOV", -40, 70, 0, true, "%", 1)
local animation_zoom_speed = ui.new_slider("LUA", "B", "Amount Speed", 0, 30, 0, true, "ms", 0.1)

local refs = {
    fov = ui.reference('MISC', 'Miscellaneous', 'Override FOV')
}

local zoom = 0

local function smooth(a, b, s)
    return a + (b - a) * s
end

client.set_event_callback("override_view", function(v)
    if not refs.fov then return end

    local d_fov = ui.get(refs.fov)
    if not d_fov then return end

    if not ui.get(animation_zoom_enabled) then
        zoom = smooth(zoom, d_fov, 0.05)
        v.fov = zoom
        return
    end

    local animation_speed = math.max(0.01, math.min(0.03, ui.get(animation_zoom_speed) / 1000))
    local me = entity.get_local_player()
    if not me or entity.get_prop(me, "m_iHealth") <= 0 then return end

    local w = entity.get_player_weapon(me)
    if not w then return end

    local scoped = entity.get_prop(me, "m_bIsScoped") == 1
    if not scoped then
        zoom = smooth(zoom, d_fov, animation_speed)
        v.fov = zoom
        return
    end

    local zoom_offset = ui.get(animation_zoom_fov)
    local zoom_level = entity.get_prop(w, "m_zoomLevel") or 0
    local target_fov = d_fov - zoom_offset - (zoom_level == 2 and 45 or 30)
    target_fov = math.max(30, math.min(200, target_fov))

    zoom = smooth(zoom, target_fov, animation_speed)
    v.fov = zoom
end)

-- Lag Compensation System
local lagcomp_enabled = ui.new_checkbox("LUA", "B", "⚡️Lag Compensation")
local lagcomp_color = ui.new_color_picker("LUA", "B", "LC Color", 47, 117, 221, 255)
local lagcomp_warning = ui.new_checkbox("LUA", "B", "Show Warnings")

local g_esp_data = {}
local g_sim_ticks, g_net_data = {}, {}

local function time_to_ticks(t)
    return math.floor(0.5 + (t / globals.tickinterval()))
end

local function vec_subtract(a, b)
    return {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
end

local function vec_add(a, b)
    return {a[1] + b[1], a[2] + b[2], a[3] + b[3]}
end

local function vec_length(x, y)
    return (x * x + y * y)
end

local function extrapolate(ent, origin, flags, ticks)
    local tickinterval = globals.tickinterval()
    local sv_gravity = 800 * tickinterval -- Используем фиксированное значение, так как sv_gravity не доступен напрямую
    local sv_jump_impulse = 301.993 * tickinterval -- Реальное значение из CS:GO

    local p_origin, prev_origin = origin, origin
    local velocity = {entity.get_prop(ent, 'm_vecVelocity')}
    local gravity = velocity[3] > 0 and -sv_gravity or sv_jump_impulse

    for i = 1, ticks do
        prev_origin = p_origin
        p_origin = {
            p_origin[1] + (velocity[1] * tickinterval),
            p_origin[2] + (velocity[2] * tickinterval),
            p_origin[3] + (velocity[3] + gravity) * tickinterval,
        }
        
        local fraction = client.trace_line(-1, 
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
    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end
    
    local players = entity.get_players(true) -- Получаем только врагов
    
    for i, idx in ipairs(players) do
        local prev_tick = g_sim_ticks[idx]
        
        if entity.is_dormant(idx) or not entity.is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
            g_esp_data[idx] = nil
        else
            local player_origin = {entity.get_origin(idx)}
            local simulation_time = time_to_ticks(entity.get_prop(idx, 'm_flSimulationTime'))
            
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick
                
                if delta < 0 or (delta > 0 and delta <= 64) then
                    local m_fFlags = entity.get_prop(idx, 'm_fFlags')
                    local diff_origin = vec_subtract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_length(diff_origin[1], diff_origin[2])
                    
                    local extrapolated = extrapolate(idx, player_origin, m_fFlags, delta - 1)
                    
                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end
                    
                    g_net_data[idx] = {
                        tick = delta - 1,
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

local function g_paint_handler()
    if not ui.get(lagcomp_enabled) then return end

    local me = entity.get_local_player()
    if not me or not entity.is_alive(me) then return end

    local r, g, b, a = ui.get(lagcomp_color)
    local warning_enabled = ui.get(lagcomp_warning)

    for idx, data in pairs(g_net_data) do
        if g_esp_data[idx] then
            local x, y = renderer.world_to_screen(data.origin[1], data.origin[2], data.origin[3])
            if x and y then
                -- Отрисовка индикатора лаг-компенсации
                renderer.text(x, y, r, g, b, a, "c", 0, "LC")
                if warning_enabled and data.lagcomp then
                    renderer.text(x, y + 15, 255, 0, 0, 255, "c", 0, "WARN")
                end
            end
        end
    end
end



client.set_event_callback('net_update_end', g_net_update)
client.set_event_callback('paint', g_paint_handler)

-- Healthbar System
local healthbar_enabled = ui.new_checkbox("LUA", "B", "❤️Healthbar")
local healthbar_gradient = ui.new_checkbox("LUA", "B", "Gradient Effect")
local healthbar_color_full = ui.new_color_picker("LUA", "B", "Full Health", 142, 214, 77, 255)
local healthbar_color_empty = ui.new_color_picker("LUA", "B", "Low Health", 244, 48, 87, 255)
local default_healthbar_ref = ui.reference("VISUALS", "Player ESP", "Health bar")




--[[=============== HEALTHBAR LOGIC ===============]]
local function draw_healthbar(e)
    local x1, y1, x2, y2 = entity.get_bounding_box(e)
    if not x1 or entity.is_dormant(e) then return end

    local hp = entity.get_prop(e, "m_iHealth") or 100
    local height = y2 - y1
    local left = x1 - 7
    local percentage = hp / 100

    -- Фон
    renderer.rectangle(left - 1, y1 - 1, 4, height + 2, 20, 20, 20, 150)

    -- Цвета
    local r1, g1, b1 = ui.get(healthbar_color_full)
    local r2, g2, b2 = ui.get(healthbar_color_empty)
    local nr = r1 + (r2 - r1) * (1 - percentage)
    local ng = g1 + (g2 - g1) * (1 - percentage)
    local nb = b1 + (b2 - b1) * (1 - percentage)

    -- Отрисовка
    if ui.get(healthbar_gradient) then
        renderer.gradient(left, y2 - height * percentage, 2, height * percentage, 
            nr, ng, nb, 255, r2, g2, b2, 255, false)
    else
        renderer.rectangle(left, y2 - height * percentage, 2, height * percentage, nr, ng, nb, 255)
    end
end


-- Viewmodel Changer
local viewmodel_changer     = ui.new_checkbox("LUA", "B", "⚙️Viewmodel changer")
local viewmodel_fov         = ui.new_slider("LUA", "B", "Offset fov", -1800, 1800, 680, true, nil, 0.1)
local viewmodel_offset_x    = ui.new_slider("LUA", "B", "Offset x", -1800, 1800, 25, true, nil, 0.1)
local viewmodel_offset_y    = ui.new_slider("LUA", "B", "Offset y", -1800, 1800, 0, true, nil, 0.1)
local viewmodel_offset_z    = ui.new_slider("LUA", "B", "Offset z", -1800, 1800, -15, true, nil, 0.1)

--[[=============== BULLET TRACER & HITMARKER ===============]]--
local bt_enabled = ui.new_checkbox("LUA", "B", "Bullet Tracer")
local bt_color = ui.new_color_picker("LUA", "B", "Tracer Color", 255, 255, 255, 220)
local bt_glow = ui.new_checkbox("LUA", "B", "Enable Glow")
local hm_enabled = ui.new_checkbox("LUA", "B", "Hit Marker")
local hm_color = ui.new_color_picker("LUA", "B", "Hit Color", 70, 200, 120, 255)

-- Инициализация переменных
local bt_tracers = {}
local hm_data = {}
local bullet_impacts = {} -- Таблица для сохранения позиций попаданий
local last_shot_time = 0

local GLOW_CONFIG = {
    fade_time = 2.5,
    core_width = 2,
    glow_layers = 8,
    base_radius = 1.0,
    glow_alpha = 150
}

-- Функция для получения времени
local function get_current_time()
    return globals.tickcount() * globals.tickinterval()
end

-- Bullet Tracer (остается без изменений)
client.set_event_callback("bullet_impact", function(e)
    local attacker = client.userid_to_entindex(e.userid)
    if attacker ~= entity.get_local_player() then return end

    local current_time = get_current_time()
    if current_time - last_shot_time < 0.1 then return end
    last_shot_time = current_time

    -- Сохраняем позицию попадания
    bullet_impacts[attacker] = {
        x = e.x,
        y = e.y,
        z = e.z,
        time = current_time
    }

    table.insert(bt_tracers, {
        start = {client.eye_position()},
        end_pos = {e.x, e.y, e.z},
        spawn_time = current_time,
        alpha = 255
    })
end)

-- Hitmarker: используем сохраненные позиции попадания
client.set_event_callback("player_hurt", function(e)
    if not ui.get(hm_enabled) then return end
    
    local attacker = client.userid_to_entindex(e.attacker)
    if attacker ~= entity.get_local_player() then return end

    -- Получаем последнюю сохраненную позицию попадания
    local impact = bullet_impacts[attacker]
    if not impact or (get_current_time() - impact.time) > 0.2 then return end

    

    table.insert(hm_data, {
        pos = {impact.x, impact.y, impact.z}, -- Используем реальные координаты попадания
        hitgroup = hitgroup_names[e.hitgroup] or "Тело",
        spawn_time = get_current_time(),
        expire_time = get_current_time() + 2.5
    })

    bullet_impacts[attacker] = nil -- Удаляем использованную позицию
end)

-- Отрисовка Hitmarker
client.set_event_callback("paint", function()
    local cur_time = get_current_time()

    -- Hitmarker
    if ui.get(hm_enabled) then
        local hm_clr = {ui.get(hm_color)}
        for i = #hm_data, 1, -1 do
            local data = hm_data[i]
            if cur_time > data.expire_time then
                table.remove(hm_data, i)
            else
                local x, y = renderer.world_to_screen(data.pos[1], data.pos[2], data.pos[3])
                if x and y then
                    -- Размер и анимация
                    local size = 6
                    local lifetime = cur_time - data.spawn_time
                    local progress = (lifetime / 2.5)^4
                    local alpha = 255 * (1 - progress)

                    -- Крестик
                    renderer.line(x - size, y, x + size, y, hm_clr[1], hm_clr[2], hm_clr[3], alpha, 2)
                    renderer.line(x, y - size, x, y + size, hm_clr[1], hm_clr[2], hm_clr[3], alpha, 2)

                    
                end
            end
        end
    end

    -- Трейсеры (без изменений)
    if ui.get(bt_enabled) then
        local clr = {ui.get(bt_color)}
        for i = #bt_tracers, 1, -1 do
            local tracer = bt_tracers[i]
            local delta = cur_time - tracer.spawn_time

            if delta > GLOW_CONFIG.fade_time then
                table.remove(bt_tracers, i)
            else
                local x1, y1 = renderer.world_to_screen(tracer.start[1], tracer.start[2], tracer.start[3])
                local x2, y2 = renderer.world_to_screen(tracer.end_pos[1], tracer.end_pos[2], tracer.end_pos[3])

                if x1 and x2 then
                    local alpha = 255
                    if delta > 2.0 then
                        alpha = 255 - (255 * ((delta - 2.0) / 0.5))
                    end

                    renderer.line(x1, y1, x2, y2, clr[1], clr[2], clr[3], alpha, GLOW_CONFIG.core_width)
                end
            end
        end
    end
end)




--[[=============== BETTER SCOPE OVERLAY ===============]]
local easing = require("gamesense/easing")
local m_alpha = 0
local function clamp(v, min_val, max_val)
    return math.max(min_val, math.min(v, max_val))
end

-- Отключаем стандартный прицел
local scope_overlay_ref = ui.reference("VISUALS", "Effects", "Remove scope overlay")
ui.set(scope_overlay_ref, true)

-- Добавляем label, чтобы гарантированно отобразить color_picker
local scope_color_label = ui.new_label("LUA", "B", "Scope Lines Color:")
local scope_master_switch = ui.new_checkbox("LUA", "B", "⚔️Custom Scope Lines")
local scope_color_picker = ui.new_color_picker("LUA", "B", "scope_lines_col", 255, 255, 255, 255)
local scope_overlay_position = ui.new_slider("LUA", "B", "Scope Lines Initial Position", 0, 500, 190)
local scope_overlay_offset = ui.new_slider("LUA", "B", "Scope Lines Offset", 0, 500, 15)
local scope_fade_time = ui.new_slider("LUA", "B", "Fade Animation Speed", 3, 20, 12, true, "fr", 1, { [3] = "Off" })

-- Функция для paint_ui: временно включает стандартный прицел
local function g_paint_ui()
    ui.set(scope_overlay_ref, true)
end

-- Основная функция отрисовки кастомного прицела
local function g_paint()
    ui.set(scope_overlay_ref, false)
    local width, height = client.screen_size()
    local offset = ui.get(scope_overlay_offset) * height / 1080
    local initial_position = ui.get(scope_overlay_position) * height / 1080
    local speed = ui.get(scope_fade_time)

    local r, g, b, a = ui.get(scope_color_picker)

    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)
    if not me or not wpn then return end

    local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
    local scoped = entity.get_prop(me, 'm_bIsScoped') == 1
    local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
    local is_valid = entity.is_alive(me) and wpn and scope_level
    local act = is_valid and scope_level > 0 and scoped and not resume_zoom

    local FT = speed > 3 and globals.frametime() * speed or 1
    local alpha = easing.linear(m_alpha, 0, 1, 1)

    renderer.gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1,
        r, g, b, 0, r, g, b, alpha * a, true)
    renderer.gradient(width/2 + offset, height / 2, initial_position - offset, 1,
        r, g, b, alpha * a, r, g, b, 0, true)

    renderer.gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset,
        r, g, b, 0, r, g, b, alpha * a, false)
    renderer.gradient(width / 2, height/2 + offset, 1, initial_position - offset,
        r, g, b, alpha * a, r, g, b, 0, false)

    m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

-- Колбэк для прицела
local function scope_ui_callback(c)
    local state = ui.get(c)
    if not state then m_alpha = 0 end

    ui.set_visible(scope_overlay_ref, not state)
    ui.set_visible(scope_color_label, state)
    ui.set_visible(scope_color_picker, state)
    ui.set_visible(scope_overlay_position, state)
    ui.set_visible(scope_overlay_offset, state)
    ui.set_visible(scope_fade_time, state)

    local addr = state and "" or "un"
    local func = client[addr .. "set_event_callback"]
    func("paint_ui", g_paint_ui)
    func("paint", g_paint)
end

ui.set_callback(scope_master_switch, scope_ui_callback)
scope_ui_callback(scope_master_switch)



--[[=============== RAGE TAB ===============]]
local rage_content = {
    coming_soon = ui.new_label("LUA", "B", "Comming soon...") -- Добавляем лейбл
}


--[[=============== MISC TAB ===============]] 
local animfix_checkbox = ui.new_checkbox("LUA", "B", "AnimFix") -- Добавить в секцию MISC


local obex_data = {username = entity.get_player_name(entity.get_local_player()) or 'unknown', build = 'boosters'}
local watermark_alpha = 0
local function watermark()
    local state = ui.get(ms_watermark)
    if not state then
        watermark_alpha = watermark_alpha - 8 * globals.frametime()
        if watermark_alpha < 0 then watermark_alpha = 0 end
        return
    end

    local screen_w, screen_h = client.screen_size()
    local screen = {screen_w, screen_h}
    local center = {screen[1]/2, screen[2]/2}

    local opacity = easing.quad_in(0.5, watermark_alpha, (ui.is_menu_open() and 255 or 0) - watermark_alpha, 3)

    local r, g, b, a = ui.get(ms_color)
    local wm_col = rgbtohex(r, g, b) .. 'FF'

    local data_suffix = 'macarone.lua'
    local nickname = obex_data.username
    local h, m, s = client.system_time()
    local actual_time = ('%2d:%02d'):format(h, m)

    local latency = client.latency() * 1000
    local latency_text = ('  %d'):format(latency) or ''

    local text = ('\a' .. wm_col .. '%s \a737373FF / %s /\a' .. wm_col .. '%s \a737373FFms\a' .. wm_col .. ' %s\a737373FF pm '):format(data_suffix, nickname, latency_text, actual_time)
    local un, mb = 'Username - ', 'Build - '

    local un_width, mb_width = renderer.measure_text(nil, un), renderer.measure_text(nil, mb)

    local h, w = 18, renderer.measure_text(nil, text) + 8
    local x, y = screen_w, 10 + (-3)

    x = x - w - 10

    renderer_shit(x, y, w, 65, 65, 65, 180, 2)
    renderer.text(x + 4, y + 1, 255, 255, 255, 255, '', 0, text)

    renderer.text(x + 5, y + 20, 170, 170, 170, opacity, '', 0, 'Username - ')
    renderer.text(x + 5, y + 35, 170, 170, 170, opacity, '', 0, 'Build - ')

    renderer.text(x + 5 + un_width, y + 20, r, g, b, opacity, '', 0, nickname)
    renderer.text(x + 5 + mb_width, y + 35, r, g, b, opacity, '', 0, 'BOOSTERS')

    watermark_alpha = watermark_alpha + 8 * globals.frametime()
    if watermark_alpha > 1 then watermark_alpha = 1 end
end

client.set_event_callback("paint", watermark)


--[[=============== REVEALER CHAT ===============]]
local revealer_chat = ui.new_checkbox("LUA", "B", "revealer chat")

local chat = require "gamesense/chat"
local localize = require "gamesense/localize"

local GameStateAPI = panorama.open().GameStateAPI
local lastChatMessage = {}

local function onPlaySay(e)
    local sender = client.userid_to_entindex(e.userid)
    if not entity.is_enemy(sender) then return end

    if GameStateAPI.IsSelectedPlayerMuted(GameStateAPI.GetPlayerXuidStringFromEntIndex(sender)) then return end

    client.delay_call(0.2, function()
        if lastChatMessage[sender] ~= nil and math.abs(globals.realtime() - lastChatMessage[sender]) < 0.4 then
            return
        end

        local enemyTeamName = entity.get_prop(entity.get_player_resource(), "m_iTeam", sender) == 2 and "T" or "CT"
        local placeName = entity.get_prop(sender, "m_szLastPlaceName")
        local enemyName = entity.get_player_name(sender)
        local localizeStr = ("Cstrike_Chat_%s_%s"):format(enemyTeamName, entity.is_alive(sender) and "Loc" or "Dead")
        local msg = localize(localizeStr, {
            s1 = enemyName,
            s2 = e.text,
            s3 = localize(placeName ~= "" and placeName or "UI_Unknown")
        })

        chat.print_player(sender, msg)
    end)
end

local function onPlayChat(e)
    if not entity.is_enemy(e.entity) then return end
    lastChatMessage[e.entity] = globals.realtime()
end

ui.set_callback(revealer_chat, function()
    local update_callback = ui.get(revealer_chat) and client.set_event_callback or client.unset_event_callback
    update_callback("player_say", onPlaySay)
    update_callback("player_chat", onPlayChat)
end)

--[[=============== ANIMFIX LOGIC ===============]] 
client.set_event_callback("pre_render", function()
    if ui.get(animfix_checkbox) then
        local local_player = entity.get_local_player()
        if local_player then
            entity.set_prop(local_player, "m_flPoseParameter", math.random(0, 10)/10, 3)
            entity.set_prop(local_player, "m_flPoseParameter", math.random(0, 10)/10, 7)
            entity.set_prop(local_player, "m_flPoseParameter", math.random(0, 10)/10, 6)
        end
    end
end)
--[[=============== FOG SYSTEM ===============]]--
local enable_fog = ui.new_checkbox("LUA", "B", "Enable Fog")
local fog_color = ui.new_color_picker("LUA", "B", "Fog Color", 255, 255, 255, 255)
local fog_start = ui.new_slider("LUA", "B", "Fog Start", 0, 16384, 0)
local fog_end = ui.new_slider("LUA", "B", "Fog End", 0, 16384, 0)
local fog_max_density = ui.new_slider("LUA", "B", "Fog Max Density", 0, 100, 0, true, "%")

client.set_event_callback("paint", function()
    if ui.get(enable_fog) then
        local r, g, b, a = ui.get(fog_color)
        client.set_cvar("fog_override", 1)
        client.set_cvar("fog_start", tostring(ui.get(fog_start)))
        client.set_cvar("fog_end", tostring(ui.get(fog_end)))
        client.set_cvar("fog_maxdensity", tostring(ui.get(fog_max_density)/100))
        client.set_cvar("fog_color", string.format("%d %d %d", r, g, b))
    else
        client.set_cvar("fog_override", 0)
    end
end)

-- Колбэки для обновления параметров
ui.set_callback(fog_color, function()
    local r, g, b = ui.get(fog_color)
    client.set_cvar("fog_color", string.format("%d %d %d", r, g, b))
end)

ui.set_callback(fog_start, function()
    client.set_cvar("fog_start", tostring(ui.get(fog_start)))
end)

ui.set_callback(fog_end, function()
    client.set_cvar("fog_end", tostring(ui.get(fog_end)))
end)

ui.set_callback(fog_max_density, function()
    client.set_cvar("fog_maxdensity", tostring(ui.get(fog_max_density)/100))
end)

-- Обновление видимости элементов (добавьте в функцию update_visibility)



--[[=============== HITSOUND SYSTEM ===============]]
local hitsound_enabled = ui.new_checkbox("LUA", "B", "Custom Hitsound")
local head_sound_ref = ui.new_combobox("LUA", "B", "Head shot sound", {"Wood stop", "Wood strain", "Wood plank impact", "Warning"})
local body_sound_ref = ui.new_combobox("LUA", "B", "Body shot sound", {"Wood stop", "Wood strain", "Wood plank impact", "Warning"})
local volume_ref = ui.new_slider("LUA", "B", "Sound volume", 1, 100, 1, true, "%")

local sound_name_to_file = {
    ["Wood stop"] = "doors/wood_stop1.wav",
    ["Wood strain"] = "physics/wood/wood_strain7.wav",
    ["Wood plank impact"] = "physics/wood/wood_plank_impact_hard4.wav",
    ["Warning"] = "resource/warning.wav"
}

local function on_player_hurt(e)
    if not ui.get(hitsound_enabled) then return end
    if client.userid_to_entindex(e.attacker) ~= entity.get_local_player() then return end
    
    local sound_file = sound_name_to_file[e.hitgroup == 1 and ui.get(head_sound_ref) or ui.get(body_sound_ref)]
    if sound_file then
        for i=1, ui.get(volume_ref) do
            client.exec("playvol " .. sound_file .. " 1")
        end
    end
end

local function update_hitsound_visibility()
    local state = ui.get(hitsound_enabled)
    ui.set_visible(head_sound_ref, state)
    ui.set_visible(body_sound_ref, state)
    ui.set_visible(volume_ref, state)
end

ui.set_callback(hitsound_enabled, update_hitsound_visibility)
client.set_event_callback("player_hurt", on_player_hurt)

--[[=============== TRASH TALK SYSTEM ===============]]
local trashtalk_enabled = ui.new_checkbox("LUA", "B", "Enable Trash Talk")
local kill_sequences = {
    {"Иногда молчание — это самая громкая вещь, которую можно сказать.", "Не будь бездарным, как твои 2 отца, заходи пидрил", "discord.gg/88hTYbbTaa" },
    {"когда волк молчит не перебивай", "Слабый должен молчать, а ты уже охрип", "discord.gg/88hTYbbTaa" },
    {"Человек меняется по двум причинам: или по первой, или по второй", "Твоя мать тоже изменилась, но не тебе", "discord.gg/88hTYbbTaa" },
    {"Тут — это вам не там", "А ты — это не человек, но ничего, привыкнешь", "discord.gg/88hTYbbTaa" },
    {"Запомни! Главное помнить, что ты запомнил", "Запомни, что ты сын ошибки", "discord.gg/88hTYbbTaa" },
    {"Если ты чего-то не понял, значит, понял не всё", "Но даже если поймешь, умнее не станешь", "discord.gg/88hTYbbTaa" },
    {"Не будь тем, кем не надо быть", "Будь лучше, хотя тебе это не светит", "discord.gg/88hTYbbTaa" },
    {"Работа не волк. Никто не волк. Только волк — волк", "А ты просто ошибка природы", "discord.gg/88hTYbbTaa" },
    {"Сила не в бабках. Ведь бабки уже старые и слабые", "Как и твой батя после водки", "discord.gg/88hTYbbTaa" },
    {"Позвоночник знаешь? Я позвонил", "Но не тебе, тебя даже мать блокнула", "discord.gg/88hTYbbTaa" },
    {"Я всегда говорю правду, даже когда вру", "А ты всегда врешь, даже когда молчишь", "discord.gg/88hTYbbTaa" },
    {"Слава богу я атеист", "А тебе бы пора начать молиться", "discord.gg/88hTYbbTaa" },
    {"Искал мед, насрал медведь", "discord.gg/88hTYbbTaa" }
}

local death_sequences = {
    {"Бляя, опять сдох... Ну ничего, главное, что не таким бездарем, как ты." },
    {"Пиздец, меня опять сложили... Но я хотя бы не бегаю с кфг юки и спуфера, и не считаю себя богом." },
    {"Смерть? Это временно, а твоя никчемная игра — это диагноз." },
    {"Я сдох, но хотя бы не от стыда за твою мать." },
    {"Опять в ящике... Как твой батя после запоя." }
}

local function send_sequence(sequence, delay)
    for i, message in ipairs(sequence) do
        client.delay_call(delay * i, function()
            client.exec("say " .. message)
        end)
    end
end

client.set_event_callback("player_death", function(e)
    if not ui.get(trashtalk_enabled) then return end
    
    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)
    local me = entity.get_local_player()

    if attacker == me then
        local seq = kill_sequences[math.random(#kill_sequences)]
        send_sequence(seq, 1.0)
    elseif victim == me then
        local seq = death_sequences[math.random(#death_sequences)]
        send_sequence(seq, 1.0)
    end
end)

--[[=============== VIEWMODEL CHANGER ===============]]
local cvar_fov      = cvar.viewmodel_fov
local cvar_offset_x = cvar.viewmodel_offset_x
local cvar_offset_y = cvar.viewmodel_offset_y     
local cvar_offset_z = cvar.viewmodel_offset_z

local function set_viewmodel(fov, x, y, z)
    cvar_fov:set_raw_float(fov * 0.1)
    cvar_offset_x:set_raw_float(x * 0.1)
    cvar_offset_y:set_raw_float(y * 0.1)
    cvar_offset_z:set_raw_float(z * 0.1)
end

local function handle_viewmodel()
    local offset_fov    = ui.get(viewmodel_fov)
    local offset_x      = ui.get(viewmodel_offset_x)
    local offset_y      = ui.get(viewmodel_offset_y)
    local offset_z      = ui.get(viewmodel_offset_z)
    set_viewmodel(offset_fov, offset_x, offset_y, offset_z)
end

local function handle_menu()
    local state = ui.get(viewmodel_changer)
    ui.set_visible(viewmodel_fov, state)
    ui.set_visible(viewmodel_offset_x, state)
    ui.set_visible(viewmodel_offset_y, state)
    ui.set_visible(viewmodel_offset_z, state)
    if not state then
        set_viewmodel(680, 25, 0, -15)
    else
        handle_viewmodel()
    end
end

ui.set_callback(viewmodel_changer, handle_menu)
ui.set_callback(viewmodel_fov, handle_viewmodel)
ui.set_callback(viewmodel_offset_x, handle_viewmodel)
ui.set_callback(viewmodel_offset_y, handle_viewmodel)
ui.set_callback(viewmodel_offset_z, handle_viewmodel)

--[[=============== VISIBILITY MANAGEMENT ===============]]
--[[=============== VISIBILITY MANAGEMENT ===============]]
client.set_event_callback("paint", draw_keybinds)
client.set_event_callback("shutdown", save_position) 
local function update_visibility()
    local tab = ui.get(selected_tab)
    local visual_tab = (tab == "Visual")
    local misc_tab = (tab == "Misc")
    local rage_tab = (tab == "Rage")
    local info_tab = (tab == "Information")
	ui.set_visible(main_content.discord_btn, tab == "Home")

    -- Home Tab
    for _, element in pairs(main_content) do
        ui.set_visible(element, tab == "Home")
    end

    -- Rage Tab
    ui.set_visible(rage_content.coming_soon, rage_tab)

    -- Visual Tab
    ui.set_visible(lagcomp_enabled, visual_tab)
    ui.set_visible(lagcomp_color, visual_tab and ui.get(lagcomp_enabled))
    ui.set_visible(lagcomp_warning, visual_tab and ui.get(lagcomp_enabled))
    ui.set_visible(healthbar_enabled, visual_tab)
    ui.set_visible(healthbar_gradient, visual_tab and ui.get(healthbar_enabled))
    ui.set_visible(healthbar_color_full, visual_tab and ui.get(healthbar_enabled))
    ui.set_visible(healthbar_color_empty, visual_tab and ui.get(healthbar_enabled))
    ui.set(default_healthbar_ref, not ui.get(healthbar_enabled))
    ui.set_visible(scope_master_switch, visual_tab)

    ui.set_visible(scope_color_label, visual_tab and ui.get(scope_master_switch))
    ui.set_visible(scope_color_picker, visual_tab and ui.get(scope_master_switch))
    ui.set_visible(scope_overlay_position, visual_tab and ui.get(scope_master_switch))
    ui.set_visible(scope_overlay_offset, visual_tab and ui.get(scope_master_switch))
    ui.set_visible(scope_fade_time, visual_tab and ui.get(scope_master_switch))
    ui.set_visible(viewmodel_changer, visual_tab)

    ui.set_visible(viewmodel_fov, visual_tab and ui.get(viewmodel_changer))
    ui.set_visible(viewmodel_offset_x, visual_tab and ui.get(viewmodel_changer))
    ui.set_visible(viewmodel_offset_y, visual_tab and ui.get(viewmodel_changer))
    ui.set_visible(viewmodel_offset_z, visual_tab and ui.get(viewmodel_changer))

    ui.set_visible(animation_zoom_enabled, visual_tab)
    ui.set_visible(animation_zoom_fov, visual_tab and ui.get(animation_zoom_enabled))
    ui.set_visible(animation_zoom_speed, visual_tab and ui.get(animation_zoom_enabled))
    
    -- Damage Indicator
    ui.set_visible(damage_indicator_enabled, visual_tab)
    ui.set_visible(damage_indicator_duration, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_speed, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_default_color, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_head_color, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_nade_color, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_knife_color, visual_tab and ui.get(damage_indicator_enabled))
    ui.set_visible(damage_indicator_min_damage, visual_tab and ui.get(damage_indicator_enabled))
	
	
	    -- Watermark
    ui.set_visible(ms_watermark, visual_tab)
    ui.set_visible(ms_color, visual_tab and ui.get(ms_watermark))
	


    ui.set_visible(enable_keybinds_display, visual_tab)
    ui.set_visible(rounding_ref, visual_tab and ui.get(enable_keybinds_display))
    ui.set_visible(text_color_ref, visual_tab and ui.get(enable_keybinds_display))
    ui.set_visible(outline_color_ref, visual_tab and ui.get(enable_keybinds_display))
    
    -- Information Tab
    ui.set_visible(info_content.main_selector, info_tab)
    ui.set_visible(info_content.welcome_label, info_tab)
    ui.set_visible(info_content.update_label, info_tab)
    ui.set_visible(info_content.version_label, info_tab)
    ui.set_visible(info_content.time_label, info_tab)
    
    -- Misc Tab
    ui.set_visible(trashtalk_enabled, misc_tab)
    ui.set_visible(hitsound_enabled, misc_tab)
    ui.set_visible(head_sound_ref, misc_tab and ui.get(hitsound_enabled))
    ui.set_visible(body_sound_ref, misc_tab and ui.get(hitsound_enabled))
    ui.set_visible(volume_ref, misc_tab and ui.get(hitsound_enabled))
    ui.set_visible(enable_fog, misc_tab)
    ui.set_visible(animfix_checkbox, misc_tab)
    ui.set_visible(fog_color, misc_tab and ui.get(enable_fog))
    ui.set_visible(fog_start, misc_tab and ui.get(enable_fog))
    ui.set_visible(fog_end, misc_tab and ui.get(enable_fog))
    ui.set_visible(fog_max_density, misc_tab and ui.get(enable_fog))
    
    -- Bullet Tracer & Hit Marker
    ui.set_visible(bt_enabled, visual_tab)
    ui.set_visible(bt_color, visual_tab and ui.get(bt_enabled))
    ui.set_visible(bt_glow, visual_tab and ui.get(bt_enabled))
    ui.set_visible(hm_enabled, visual_tab)
    ui.set_visible(hm_color, visual_tab and ui.get(hm_enabled))
    
    -- Revealer Chat
    ui.set_visible(revealer_chat, misc_tab)
	

end


--[[=============== EVENT HANDLERS ===============]]
client.set_event_callback("paint", function()
    if ui.get(healthbar_enabled) then
        for _, e in ipairs(entity.get_players(true)) do
            if entity.is_alive(e) then 
                draw_healthbar(e)
            end
        end
    end
end)

client.set_event_callback("shutdown", function()
    set_viewmodel(680, 25, 0, -15)
    client.exec("playvol physics/metal/metal_solid_impact_hard5 0")
    ui.set(default_healthbar_ref, true)
end)

ui.set_callback(selected_tab, update_visibility)
ui.set_callback(trashtalk_enabled, update_visibility)
ui.set_callback(healthbar_enabled, update_visibility)
ui.set_callback(enable_fog, update_visibility)
ui.set_callback(animation_zoom_enabled, update_visibility)
ui.set_callback(damage_indicator_enabled, update_visibility)
ui.set_callback(enable_keybinds_display, update_visibility)
ui.set_callback(ms_watermark, update_visibility)
update_visibility()
