local Water_tog = menu.add_checkbox("Watermark", "Enable")
local Water_Col = Water_tog:add_color_picker("Watermark Color")
local verdana = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)
local get_screen = render.get_screen_size()

local function Watermark()
    if Water_tog:get() then
        local x = (get_screen.x);
		local tick = client.get_tickrate()
        local fps = client.get_fps()
		local WatermarkText = string.format(" Primordial.dev | %s | fps: %i | tick: %s", user.name, fps, tick)
		local text_size = 12,12
        render.rect_filled(vec2_t(1680, 17), vec2_t(230, 3), Water_Col:get())
        render.rect_filled(vec2_t(1680, 18), vec2_t(230, 17), color_t(0,0,0,150))
        render.text(verdana, WatermarkText, vec2_t(1680, 19), color_t(255,255,255,255))
    end  
end

callbacks.add(e_callbacks.PAINT, Watermark)