local p_render = require('nix/libs/p_render')

local verdana = p_render.setup_font("C:/Windows/Fonts/verdana.ttf", 12, 0)

--customize watermark
local style = 3 -- 1 => solus ver 1.0; 2 => solus ver 1.5; 3 => ver 2.0; 4 => onetap style

local cheat_name = "gamesense" 
local custom_username = false
local custom_username_text = "Nixer1337"

local colors = {
    accent = color_t(0.5, 0.5, 1, 1),
    bg = color_t(0.06, 0.06, 0.06, 0.4)
}

local frame_count_for_fps, current_fps = 0, 0
local last_time_for_fps = os.clock()

local anim = {
    x = 0,
    w = 0
}

create_window = function(x, y, w, h, bg_clr, accent_clr, style)
    if style == 1 then
        p_render.rect_filled(x, y, w, h, bg_clr, 0)
        p_render.rect_filled(x, y, w, 2, accent_clr, 0)

    elseif style == 2 then
        p_render.rect_filled(x, y, w, h, bg_clr, 5)
        p_render.rect_filled(x, y + 7, 2, h - 14, accent_clr, 0)
        p_render.rect_filled(x + w - 2, y + 7, 2, h - 14, accent_clr, 0)
        p_render.glow(x, y + 7, 2, h - 14, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 3, 30)
        p_render.glow(x + w - 2, y + 7, 2, h - 14, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 3, 30)
    
    elseif style == 3 then
        p_render.glow(x, y, w, h, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 5, 30)
        p_render.rect_filled(x, y, w, h, bg_clr, 6)
        p_render.rect(x, y, w, h, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.35), 5)
        p_render.arc(x + 5, y + 5, 4, 3, 5, 10, accent_clr, 1)
        p_render.rect_filled(x + 4, y, w - 8, 1, accent_clr, 0)
        p_render.arc(x + w - 5, y + 5, 4, 6, 5, 10, accent_clr, 1)
        p_render.rect_filled_fade(x, y + 4, 1, h - 6, accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0), accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0))
        p_render.rect_filled_fade(x + w - 1, y + 4, 1, h - 6, accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0), accent_clr, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0))
    
    elseif style == 4 then
        p_render.glow(x - 4, y, w + 8, h, color_t(accent_clr.r, accent_clr.g, accent_clr.b, 0.25), 0, 30)
        p_render.rect_filled(x - 4, y, w + 8, h, color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.5), 0)
        p_render.rect_filled(x, y + 5, w, h - 8, color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.5), 0)
        p_render.rect(x - 4, y, w + 8, h,  color_t(bg_clr.r, bg_clr.g, bg_clr.b, 0.25), 0)
        p_render.rect_filled(x, y + 4, w, 1, accent_clr, 0)
    end
end

draw_watermark = function()
    -- setup fps
    local current_time = os.clock()
    frame_count_for_fps = frame_count_for_fps + 1

    if current_time - last_time_for_fps >= 1 then
        current_fps = frame_count_for_fps
        frame_count_for_fps = 0
        last_time_for_fps = current_time
    end

    -- get controller for get ping
    local controller = entitylist.get_local_player_controller()
    if controller == nil then return end

    local screen_size = render.screen_size()
    local username = custom_username and custom_username_text or get_user_name()

    local text = string.format("%s | %s | delay: %sms | fps: %s | %s", cheat_name, username, controller.m_iPing, current_fps, os.date("%H:%M:%S"))
    local text_size = render.calc_text_size(text, verdana, 12)
    
    -- setup animation
    anim.x = p_render.lerp(anim.x, screen_size.x - text_size.x - 20, 0.1)
    anim.w = p_render.lerp(anim.w, text_size.x, 0.25)
    
    local y = 10
    local h = 23

    -- render watermark
    create_window(anim.x - 6, y, anim.w + 12, h, colors.bg, colors.accent, style)
    p_render.text(verdana, 12, anim.x, y + h/2 - 6, color_t(1, 1, 1, 1), text, 0, 2)
end

register_callback("paint", draw_watermark) 