local screen_size = render.get_screen_size()

local x = menu.add_slider("dt indicator", "x", 0, screen_size.x)   
local y = menu.add_slider("dt indicator", "y", 0, screen_size.y)   
x:set(screen_size.x/2)
y:set(screen_size.y/2 + 40)
local font = render.create_font("smallest pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)

local function on_paint()
    local vec = vec2_t.new(x:get(), y:get())
    local progress = exploits.get_charge()/exploits.get_max_charge()
    local color = color_t.new(math.floor(255 - 131 * progress), math.floor(195 * progress), math.floor(13 * progress), 255)
    render.progress_circle( vec - vec2_t(6, 0), 2, color_t.new(0,0,0, 250), 3, progress)
    render.progress_circle( vec - vec2_t(6, 0), 3, color, 1, progress)
    render.text(font,"DT",vec2_t(vec.x + 2,vec.y - 5), color)
end

callbacks.add(e_callbacks.PAINT, on_paint)