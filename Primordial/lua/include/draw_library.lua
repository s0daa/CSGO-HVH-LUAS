function render.rect_fade_round_box(start_pos, end_pos, start_color, end_color, width, round)
    -- up
    render.rect_fade(vec2_t.new(start_pos.x + round, start_pos.y), vec2_t.new(end_pos.x - round * 2, end_pos.y - end_pos.y + width), start_color, end_color, true)
    -- left
    render.rect_fade(vec2_t.new(start_pos.x, start_pos.y + round), vec2_t.new(start_pos.x - start_pos.x + width, end_pos.y - round * 2), color_t.new(start_color.r, start_color.g, start_color.b, start_color.a), color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 5)), false)
    -- right
    render.rect_fade(vec2_t.new(start_pos.x + end_pos.x - width, start_pos.y + round), vec2_t.new(end_pos.x - end_pos.x + width, end_pos.y - round * 2), color_t.new(end_color.r, end_color.g, end_color.b, end_color.a), color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 5)), false)
    -- down
    render.rect_fade(vec2_t.new(start_pos.x + round, start_pos.y + end_pos.y - width), vec2_t.new(end_pos.x - round * 2, start_pos.y - start_pos.y + width), color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 5)), color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 5)), true)
    if round ~= 0 and width ~= 0 then
        -- right down
        render.push_clip(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + end_pos.y - round), round - width, color_t.new(start_color.r, start_color.g, start_color.b, math.floor(start_color.a / 50)), width, 1)
        render.pop_clip()
        -- right up
        render.push_clip(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + end_pos.x - round, start_pos.y + round - 1), round - width, color_t.new(end_color.r, end_color.g, end_color.b, end_color.a), width, 1)
        render.pop_clip()
        -- left down
        render.push_clip(vec2_t.new(start_pos.x + round - round, start_pos.y + end_pos.y - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + round - 1, start_pos.y + end_pos.y - round), round - width, color_t.new(end_color.r, end_color.g, end_color.b, math.floor(end_color.a / 50)), width, 1)
        render.pop_clip()
        -- left up
        render.push_clip(vec2_t.new(start_pos.x + round - round, start_pos.y + round - round), vec2_t.new(round, round))
        render.progress_circle(vec2_t.new(start_pos.x + round - 1, start_pos.y + round - 1), round - width, color_t.new(start_color.r, start_color.g, start_color.b, start_color.a), width, 1)
        render.pop_clip()
    end
end