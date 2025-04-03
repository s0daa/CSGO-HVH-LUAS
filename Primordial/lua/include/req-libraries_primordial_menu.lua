--|
local service = {
    button_cache = {},
    open_animation = global_vars.real_time(),
    was_opened = false
}

--|
local scrollbar = { width = 0, position = 0 }
local scroll = {
    width = 0,
    position = 0,
    final_position = 0,
    animation = {
        start = 0,
        duration = 0.25
    },
    has_down = false,
    should_drag = false,
    drag_delta = vec2_t(0, 0)
}

--|
local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))

--|
function math.clamp(n, min, max)
    return math.max(math.min(n, max), min)
end
function math.round(n)
    return math.floor(n + 0.5)
end
function math.round_clamp(n, min, max)
    return math.round(math.clamp(n, min, max))
end

--|
function render.rect_filled_outline(position, size, color, round, outline)
    render.rect_filled(position, size, outline, round)
    render.rect_filled(position + vec2_t(1, 1), size - vec2_t(2, 2), color, round)
end

--|
local function handle_input()
    --
    local scroll_delta = input.get_scroll_delta()
    scroll.final_position = scroll.final_position + scroll_delta * 25
    scroll.final_position = math.clamp(scroll.final_position, 0, scroll.width - menu.get_size().x)

    --
    local menu_position = menu.get_pos()
    local menu_size = menu.get_size()
    local mouse_position = input.get_mouse_pos()

    --
    local is_mouse_in_bounds = input.is_mouse_in_bounds(menu.get_pos() + vec2_t(scrollbar.position, -10), vec2_t(scrollbar.width, 5))
    if input.is_key_held(e_keys.MOUSE_LEFT) then
        if is_mouse_in_bounds then
            if not scroll.should_drag then
                scroll.drag_delta = (mouse_position - menu_position - vec2_t(scrollbar.position, 0)).x
                scroll.drag_delta = math.round_clamp(scroll.drag_delta, 0, scrollbar.width)
            end
            scroll.should_drag = true
        end
    else
        scroll.should_drag = false
    end

    --
    if input.is_key_held(e_keys.MOUSE_LEFT) and scroll.should_drag then
        scroll.position = ((mouse_position - menu_position).x - scroll.drag_delta) * (scroll.width - menu_size.x) / (menu_size.x - scrollbar.width)
        scroll.final_position = scroll.position
    end

    --
    scroll.has_down = input.is_key_held(e_keys.MOUSE_LEFT)

    if scroll_delta ~= 0 then
        scroll.animation.start = global_vars.real_time()
    end

    --
    scroll.position = math.clamp(scroll.position, 0, scroll.width - menu_size.x)

    --
    local animation_elapsed = global_vars.real_time() - scroll.animation.start
    if animation_elapsed > scroll.animation.duration then
        return
    end

    --
    local animation_delta = math.min(1, animation_elapsed / scroll.animation.duration)
    scroll.position = math.floor(scroll.position + (scroll.final_position - scroll.position) * animation_delta + 0.5)
end

--|
local function on_paint()
    --
    local real_time = global_vars.real_time()
    local alpha_modifier = menu.get_alpha_modifier()
    local alpha_substraction = (real_time - service.open_animation) / 0.5 * 255
    alpha_substraction = math.round_clamp(alpha_substraction, 0, 255 + #service.button_cache * 15)
    
    --
    if service.was_opened ~= menu.is_open() and alpha_modifier == 0 then
        service.open_animation = real_time
    end
    service.was_opened = menu.is_open()

    --
    render.push_alpha_modifier(alpha_modifier)

    --
    handle_input()

    --
    local default_font = render.get_default_font()
    local base_position = menu.get_pos()
    local menu_size = menu.get_size()
    base_position = base_position - vec2_t(0, 40)

    --
    render.push_clip(base_position - vec2_t(1, 1), vec2_t(menu_size.x + 2, 57))

    --
    local content_size = vec2_t(0, 0)
    for index, button in next, service.button_cache do
        --
        local render_alpha = alpha_substraction - index * 15
        render_alpha = math.round_clamp(render_alpha, 0, 255)

        --
        local text_size = render.get_text_size(default_font, button.text)
        local text_color = color_t(255, 255, 255, math.round_clamp(render_alpha - button.current_alpha, 0, 255))

        --
        local button_position = base_position + vec2_t(content_size.x - scroll.position, 0)
        local button_size = vec2_t(text_size.x + 10, text_size.y + 10)

        --
        if input.is_mouse_in_bounds(button_position, button_size) then
            if button.end_alpha == 155 then
                button.animation_start = real_time
            end
            button.end_alpha = 0
            if input.is_key_pressed(e_keys.MOUSE_LEFT) then
                button.callback()
            end
        else
            if button.end_alpha == 0 then
                button.animation_start = real_time
            end
            button.end_alpha = 155
        end

        --
        render.rect_filled_outline(button_position, button_size, color_t(41, 41, 41, render_alpha), 10, color_t(0, 0, 0, render_alpha))
        render.text(default_font, button.text, button_position + vec2_t(5, 5), text_color)

        --
        content_size = content_size + vec2_t(button_size.x + 5, 0)
        if button.end_alpha ~= button.current_alpha then
            button.current_alpha = math.round(button.current_alpha + (button.end_alpha - button.current_alpha) * ((real_time - button.animation_start) / 0.5))
        end
    end

    --
    scroll.width = content_size.x
    scrollbar.width = menu_size.x / scroll.width * menu_size.x
    scrollbar.position = scroll.position / (scroll.width - menu_size.x)
    scrollbar.position = scrollbar.position * (menu_size.x - scrollbar.width)

    --
    if scroll.position > 0 then
        --
        local alpha_delta = math.clamp(scroll.position / 25, 0, 1)

        --
        render.rect_fade(base_position - vec2_t(5, 0), vec2_t(25, default_font.height + 10), color_t(41, 41, 41, math.round(255 * alpha_delta)), color_t(41, 41, 41, math.round(50 * alpha_delta)), true)
    end
    if scroll.width - menu_size.x - scroll.position > 0 then
        --
        local alpha_delta = math.clamp((scroll.width - menu_size.x - scroll.position) / 25, 0, 1)

        --
        render.rect_fade(base_position + vec2_t(menu_size.x - 25, 0), vec2_t(25, default_font.height + 10), color_t(41, 41, 41, math.round(50 * alpha_delta)), color_t(41, 41, 41, math.round(255 * alpha_delta)), true)
    end

    --
    render.rect_filled(base_position + vec2_t(0, 30), vec2_t(menu_size.x, 5), color_t(34, 34, 34), 2)
    render.rect_filled(base_position + vec2_t(scrollbar.position, 30), vec2_t(math.clamp(scrollbar.width, 0, menu_size.x), 5), accent_color:get(), 2)

    --
    render.pop_clip()
    render.pop_alpha_modifier()
end

--|
callbacks.add(e_callbacks.PAINT, on_paint)

--|
function service:add_button(text, callback)
    table.insert(self.button_cache, {
        text = text or "empty button",
        callback = callback or function() end,
        current_alpha = 100, end_alpha = 155, animation_start = global_vars.real_time()
    })
end

--|
return service