local ref_enable = menu.add_checkbox("DVD Settings", "Enable")
local ref_color = ref_enable:add_color_picker("Color")

local dvd_font = render.create_font("TI logoso TFB", 100, 0, e_font_flags.ANTIALIAS)
local dvd_size = render.get_text_size(dvd_font, "J")

local screen_size = render.get_screen_size()

local position = vec2_t(math.random(0, screen_size.x), math.random(0, screen_size.y))
local speed = vec2_t(1, 1)

function on_paint()
    if ref_enable:get() and menu.is_open() then
        position.x = position.x + speed.x
        position.y = position.y + speed.y

        if position.x + dvd_size.x >= screen_size.x then
            speed.x = -speed.x
            position.x = screen_size.x - dvd_size.x
        elseif position.x <= 0 then
            speed.x = -speed.x
            position.x = 0
        end
        
        if position.y + dvd_size.y >= screen_size.y then
            speed.y = -speed.y
            position.y = screen_size.y - dvd_size.y
        elseif position.y <= 0 then
            speed.y = -speed.y
            position.y = 0
        end
        
        render.text(dvd_font, "J", position, ref_color:get())
    end
end

callbacks.add(e_callbacks.DRAW_WATERMARK, on_paint)