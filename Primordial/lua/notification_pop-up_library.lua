--| Service object
local service = {
    notifications = {},
    text_font = render.create_font("Tahoma", 13, 400, e_font_flags.DROPSHADOW),
    direction = 1
}

--| Variables
local accent_color = select(2, unpack(menu.find("misc", "main", "config", "accent color")))
local background_color_fade = color_t(41, 41, 41, 50)
local background_color = color_t(41, 41, 41, 255)
local title_color = color_t(255, 255, 255, 255)
local text_color = color_t(155, 155, 155, 255)
local idle_color = color_t(35, 35, 35, 255)

--| Easing
local function easeInQuad(x)
    return x * x
end

--| Create a method which draws the notifications
local function on_paint()
    -- Grab the current screen size and calculate the base position at 95% X and Y
    local screen_size = render.get_screen_size()
    local base_position = vec2_t(screen_size.x * 0.95, screen_size.y * 0.95)

    -- Make sure none of the notifications have expired
    table.foreach(service.notifications, function(index, notification)
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())
        if time_delta >= notification.duration then
            return table.remove(service.notifications, index)
        end
    end)

    -- Loop through all notifications and keep a height offset
    local height_offset = 0
    table.foreach(service.notifications, function(index, notification)
        -- Calculate the time delta (elapsed time)
        local time_delta = notification.duration - (notification.expires_at - global_vars.real_time())

        -- Measure the text size of the title and text, then get the highest number
        local title_size = render.get_text_size(service.text_font, notification.title)
        local text_size = render.get_text_size(service.text_font, notification.text)
        local max_size = math.max(title_size.x, text_size.x)
        max_size = vec2_t(max_size + 20, title_size.y + text_size.y + 30)

        -- Calculate the animation delta
        local animation_delta = 1
        if time_delta < 0.25 then
            animation_delta = easeInQuad(time_delta * 4)
        elseif time_delta > notification.duration - 0.25 then
            animation_delta = easeInQuad((notification.duration - time_delta) * 4)
        end

        --
        max_size.x = max_size.x > 270 and 270 or max_size.x

        -- Text scrolling animation
        local size_delta = (text_size.x - max_size.x + 20)
        local text_animation = ((time_delta - 0.5) / (notification.duration - 1))
        if text_size.x < max_size.x or time_delta < 0.5 then
            text_animation = 0
        elseif time_delta > (notification.duration - 0.5) then
            text_animation = 1
        end

        -- Create the colors we'll be using and push the alpha modifier
        local color_alpha = math.floor(255 * animation_delta)
        local time_color = accent_color:get()
        render.push_alpha_modifier(color_alpha / 255)

        -- Calculate the position of the notification
        local clip_position = vec2_t(base_position.x - max_size.x, base_position.y - max_size.y - height_offset)
        local position = vec2_t(base_position.x - max_size.x * animation_delta, base_position.y - max_size.y - height_offset)
        local bar_width = max_size.x * time_delta / (notification.duration - 0.25)
        local text_clip = position + vec2_t(10, 15 + title_size.y)

        --
        if service.direction == 1 then
            bar_width = max_size.x - bar_width
        end

        -- Start clipping drawings to the original position
        render.push_clip(clip_position - vec2_t(0, 10), max_size + vec2_t(0, 10))

        --
        if input.is_mouse_in_bounds(position, max_size) and input.is_key_pressed(e_keys.MOUSE_LEFT) then
            if time_delta < notification.duration - 0.25 then
                notification.expires_at = global_vars.real_time() + 0.25
            end
        end

        -- Draw the background of the notification
        render.rect_filled(position, max_size, background_color, 10)

        -- Draw the time bar
        render.rect_filled(position + vec2_t(0, 10), vec2_t(max_size.x, 1), idle_color)
        render.rect_filled(position + vec2_t(0, 10), vec2_t(bar_width, 1), time_color)

        -- Draw the text of the notification
        render.text(service.text_font, notification.title, position + vec2_t(10, 15), title_color)

        -- Start clipping the text
        render.push_clip(text_clip, vec2_t(250, text_size.y))

        --
        render.text(service.text_font, notification.text, position + vec2_t(10 - size_delta * text_animation, 15 + title_size.y), text_color)

        --
        if max_size.x == 270 then
            if text_animation > 0 then
                render.rect_fade(text_clip, vec2_t(10, text_size.y), background_color, background_color_fade, true)
            end
            if text_animation < 1 then
                render.rect_fade(text_clip + vec2_t(240, 0), vec2_t(10, text_size.y), background_color_fade, background_color, true)
            end
        end

        -- Pop the clip and alpha modifier
        render.pop_clip()
        render.pop_clip()
        render.pop_alpha_modifier()

        -- Increase the height offset
        height_offset = height_offset + max_size.y * animation_delta + 5
    end)
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)

--| Create a message to append to the notification list
function service:add_notification(title, text, duration)
    -- Compensate for the animation
    duration = duration + 0.25

    --
    table.insert(self.notifications, { 
        title = title, text = text, 
        expires_at = global_vars.real_time() + duration, 
        duration = duration
    })
end

--| Return the service
return service