local font = render.create_font('DejaVu Sans Bold', 20, 200, e_font_flags.ANTIALIAS)
local data = { 
    pos = vec2_t(50, 500),
    diff = vec2_t(0, 0),
    hit = 0,
    shot = 0
}
local on_shot = function()
    data.shot = data.shot + 1
end

local on_hit = function ()
    data.hit = data.hit + 1
end

local on_paint = function()
    local text = string.format('%d / %d (%s)', data.hit, data.shot, math.floor(data.hit/data.shot * 100) )
    local textsize = render.get_text_size(font, text)

    if input.is_mouse_in_bounds(data.pos, textsize) and input.is_key_held(e_keys.MOUSE_LEFT) then
        data.pos = input.get_mouse_pos() + data.diff
    else
        data.diff = data.pos - input.get_mouse_pos()
    end

    render.text(font, text, data.pos, color_t(255, 255, 255, 255))
end

callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shot)
callbacks.add(e_callbacks.AIMBOT_HIT, on_hit)
callbacks.add(e_callbacks.PAINT, on_paint)