local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))

local rainbow_speed = menu.add_slider("general", "rainbow speed", 0, 100, 1, 0, "%")
rainbow_speed:set(50)

function on_paint()
    local current_rainbow = (global_vars.real_time() * rainbow_speed:get()) % 100

    accent_color_color:set(color_t.from_hsb(current_rainbow / 100, 1, 1))
end

callbacks.add(e_callbacks.PAINT, on_paint)