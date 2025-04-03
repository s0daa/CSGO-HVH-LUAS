local enabled = menu.add_checkbox("windows", "watermark enabled")
local font = render.create_font("Verdana", 13, 24, e_font_flags.ANTIALIAS)
local screen_size = render.get_screen_size()

callbacks.add(e_callbacks.DRAW_WATERMARK, function(ctx)
    if enabled:get() then
        local h, m, s = client.get_local_time()
        local text = string.format("primordial | %s | %s ms | %02d:%02d:%02d", user.name, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
        local text_size = render.get_text_size(font, text)

        render.rect_filled(vec2_t(screen_size.x - text_size.x - 23, 7), vec2_t(text_size.x + 11, text_size.y + 9), color_t(255, 255, 255), 3)
        render.rect_filled(vec2_t(screen_size.x - text_size.x - 22, 8), vec2_t(text_size.x + 9, text_size.y + 9), color_t(0, 0, 0), 3)
        
        render.text(font, text, vec2_t(screen_size.x - text_size.x - 17, 12), color_t(255, 255, 255, 255))
    end

    return ""
end)