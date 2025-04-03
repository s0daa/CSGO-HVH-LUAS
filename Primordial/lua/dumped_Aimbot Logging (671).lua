-- // variables
local offset = 35 -- // notification offset
local screen_size = render.get_screen_size() -- // size of players screen
local notification_table = {} -- // {text: string, time: globals.real_time() + number, position: number, {hit:bool, miss:bool}}
local main_font = render.get_default_font() -- // default primordial font

--// ui elements
local enable_hit = menu.add_checkbox("hit / miss logs", "enable hit logs", false) -- // hit log toggle
local enable_miss = menu.add_checkbox("hit / miss logs", "enable miss logs", false) -- // miss log toggle
local display_time = menu.add_slider("hit / miss logs", "display time", 3, 10, nil, nil, "s") -- // display time slider
local notif_limit = menu.add_slider("hit / miss logs", "notification limit", 1, 10) -- // notification limit slider

-- // lerp function
function lerp(a, b, t)
    return a + (b - a) * t
end

-- // easing
function movement(offset, when, original, new_place, speed)
    if when == true then
        offset = lerp(offset, new_place, globals.frame_time() * speed)
    else
        offset = lerp(offset, original, globals.frame_time() * speed)
    end
    return offset
end

-- // notification function
function notifications()
    for k, v in pairs(notification_table) do
        if k > notif_limit:get() then return end
        if v.time < globals.real_time() then table.remove(notification_table, k) end
        
        local text = v.text
        local text_size = render.get_text_size(main_font, text)
        local side_padding = 20
        local stroke_padding = 22

        v.position = movement(v.position, v.time > globals.real_time(), screen_size.y*0.7 + k*offset, screen_size.y*0.7 + (k-1)*offset, 10)

        if v.hit == true then
            render.rect_filled(vec2_t(screen_size.x/2-text_size.x/2 - stroke_padding/2, v.position-1), vec2_t(text_size.x + stroke_padding, 27), color_t(0,255,0), 8)
        end

        if v.miss == true then
            render.rect_filled(vec2_t(screen_size.x/2-text_size.x/2 - stroke_padding/2, v.position-1), vec2_t(text_size.x + stroke_padding, 27), color_t(255,0,0), 8)
        end

        if v.universal == true then
            render.rect_filled(vec2_t(screen_size.x/2-text_size.x/2 - stroke_padding/2, v.position-1), vec2_t(text_size.x + stroke_padding, 27), color_t(255,105,180), 8)
        end

        render.rect_filled(vec2_t(screen_size.x/2-text_size.x/2 - side_padding/2, v.position), vec2_t(text_size.x + side_padding, 25), color_t(20,20,20), 6)
        render.text(main_font, text, vec2_t(screen_size.x/2 - text_size.x/2, v.position + text_size.y/2), color_t(255, 255, 255))

    end
end

-- // aimbot hit function
function on_aimbot_hit(hit)
    if enable_hit:get() then
        local text = string.format("hit %s for %s damage (predicted:%s hc:%s bt:%s)", string.lower(hit.player:get_name()), hit.damage, predicted, hitchance, bt)
        notification_table[#notification_table+1] = {text = text, time = globals.real_time() + display_time:get(), position = screen_size.y*0.7, alpha = 0, hit = true}
    end
end

-- // aimbot miss function
function on_aimbot_miss(miss)
    if enable_miss:get() then
        local text = string.format("missed %s due to %s (hc:%s bt:%s)", string.lower(miss.player:get_name()), miss.reason_string, hitchance, bt)
        notification_table[#notification_table+1] = {text = text, time = globals.real_time() + display_time:get(), position = screen_size.y*0.7, alpha = 0, miss = true}
    end
end

-- // aimbot shoot function
function on_aimbot_shoot(shot)
    hitchance = shot.hitchance
    predicted = shot.damage
    bt = shot.backtrack_ticks
end

-- // callbacks
callbacks.add(e_callbacks.PAINT,notifications)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)