-- Adding color picker
local textWatermark = menu.add_text("Custom", "Watermark color")
local accentColor = textWatermark:add_color_picker("Watermark color")
accentColor:set(color_t(211,135,217))

-- Adding slider for rainbow mode
local rainbowMode = menu.add_checkbox("Custom", "Enable rainbow mode")
local rainbowSpeed = menu.add_slider("Custom", "Rainbow mode speed", 0, 100, 1, 0, "%")
    rainbowSpeed:set(30)

-- Defining fonts
local px15 = render.create_font("Segoe UI", 15, 100)
local px12 = render.create_font("Segoe UI", 12, 100)

-- Watermark draw function
function watermarkDraw()

    -- Getting size of username string
    local userSize = render.get_text_size(px15, string.format("primordial      "..user.name..""))

    -- Getting accent color
    local watermarkColor = accentColor:get()

    -- Rendering watermark
    render.rect_filled(vec2_t(6,8), vec2_t(70, 22), color_t(31,31,31,150))
    render.rect_filled(vec2_t(6,8), vec2_t(userSize.x+16, 22), color_t(31,31,31,100))
    render.text(px15, "primordial      "..user.name.."", vec2_t.new(12, 11), color_t.new(255, 255, 255, 255))


    -- Rendering frequency and FPS

    -- Defining FPS and tickrate locals
    local fps = client.get_fps()
    local tickrate = client.get_tickrate()

    if (tickrate==0) 
        then
            tickrate="-"
        else
            tickrate=""..client.get_tickrate().."   TICK"
    end
    
    -- Getting size of strings
    local fpsSize = render.get_text_size(px12, ""..fps.."   FPS")
    local tickSize = render.get_text_size(px12, ""..tickrate.."")
    
    render.rect_filled(vec2_t(6,40), vec2_t(fpsSize.x+16, 16), color_t(31,31,31,150))
    render.rect_filled(vec2_t(6,40), vec2_t(fpsSize.x+16+tickSize.x+16, 16), color_t(31,31,31,100))
    render.text(px12, ""..fps.."   FPS", vec2_t(14,42), color_t(255,255,255,255))
    render.text(px12, ""..tickrate.."", vec2_t(fpsSize.x+30,42), color_t(255,255,255,255))  
    
    
    -- Rendering colors and rainbow mode if enabled 
    if (rainbowMode:get()==true)
        then
            local rainbowCalc = (global_vars.real_time() * rainbowSpeed:get()) % 100
            accentColor:set(color_t.from_hsb(rainbowCalc / 100, 1, 1))
            render.rect_fade(vec2_t(6,38), vec2_t(fpsSize.x+16+tickSize.x+16, 2), color_t(31,31,31,50), accentColor:get(), true)
            render.rect_fade(vec2_t(6,6), vec2_t(userSize.x+16, 2), color_t(31,31,31,50), accentColor:get(), true)
        else
            render.rect_filled(vec2_t(6,38), vec2_t(fpsSize.x+16+tickSize.x+16, 2), watermarkColor)
            render.rect_filled(vec2_t(6,6), vec2_t(userSize.x+16, 2), watermarkColor)
    end

    -- Returning and empty string to remove the original watermark
    return ""
end

callbacks.add(e_callbacks.DRAW_WATERMARK, watermarkDraw)