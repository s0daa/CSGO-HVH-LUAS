--made by walleX

local text = menu.add_text("", "Made by walleX")
local toggle = menu.add_checkbox("", "Enable")
local size = menu.add_slider("", "Hitmarker size", 10, 16,2)
local fade_color_in = toggle:add_color_picker("Fade Color In")
local fade_color_out = toggle:add_color_picker("Fade Color Out")
local change_fade_side = menu.add_checkbox("", "Change Fade (Horizontal)")




local function on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
    fade_side = false
    if toggle:get() then
    if change_fade_side:get() then
    fade_side = true
    end
    render.push_alpha_modifier(alpha_factor)
    down = vec2_t(screen_pos.x, screen_pos.y - size:get()/5*2)
    side = vec2_t(screen_pos.x-size:get()/5*2, screen_pos.y)
    render.rect_fade(down, vec2_t(2,size:get()), fade_color_in:get(), fade_color_out:get(),fade_side)
    render.rect_fade(side, vec2_t(size:get(),2), fade_color_in:get(), fade_color_out:get(),fade_side)

    render.pop_alpha_modifier()

    return true
end
end

callbacks.add(e_callbacks.WORLD_HITMARKER, on_world_hitmarker)