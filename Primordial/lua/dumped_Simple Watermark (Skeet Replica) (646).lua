local font=render.create_font("Verdana.ttf", 14,400,e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)



local function on_paint()
    if engine.is_in_game()==false then return end
    local h, m, s = client.get_local_time()
    local timeW = string.format("%02d:%02d:%02d", h, m, s)
    local screen_size = render.get_screen_size( )
    local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color")) -- accent_color_color()
    local cheatN1 = "Prim"
    local cheatN2 = "ordial.dev"
    local fps = math.floor(1 / globals.frame_time()).."fps"
    local ping = math.floor((engine.get_latency(e_latency_flows.INCOMING) or 0) * 1000) 
    local spacer = " | "
    local primsize = render.get_text_size(font, cheatN1)
    local mordialsize = render.get_text_size(font, cheatN2)
    local text= cheatN1..cheatN2..spacer..fps..spacer..ping.."ms".."00:00:00"

    local player=entity_list.get_local_player
    if player==nil and engine.is_in_game()==false then return end
    local text_size=render.get_text_size(font, text)
    --outer blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 47, 11 ), vec2_t( text_size.x + 38, text_size.y + 24 ), color_t(18, 18, 18))
    --outer outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 46, 12 ), vec2_t( text_size.x + 36, text_size.y + 22 ), color_t(66, 64, 62))
    --outerbox 
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 43, 14 ), vec2_t( text_size.x + 30, text_size.y + 17 ), color_t(44, 44, 44))
    --inner outline
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 39, 18 ), vec2_t( text_size.x + 22, text_size.y + 9 ), color_t(66, 64, 62))
    --blackbox
    render.rect_filled(vec2_t( screen_size.x - text_size.x - 37, 20 ), vec2_t( text_size.x + 18, text_size.y + 5 ), color_t(18, 18, 18))
    --rgb line
    --render.line_multicolor(x-112,14, x-textx-25, 15, render.color("#9329cc"), render.color("#2986cc"))
    --render.line_multicolor(x-15,14, x-textx-1 * -85, 15, render.color("#aacc29"), render.color("#9329cc"))

    render.text(font, cheatN1, vec2_t( screen_size.x - 31  - text_size.x, 23 ), color_t(255,255, 255, 255))
    render.text(font, cheatN2, vec2_t( screen_size.x - 31  - text_size.x + primsize.x , 23 ), accent_color_color())
    render.text(font, spacer..fps..spacer..ping.."ms"..spacer..timeW, vec2_t( screen_size.x - 31  - text_size.x + primsize.x + mordialsize.x, 23 ), color_t(255,255, 255, 255))

end

callbacks.add(e_callbacks.PAINT, on_paint)