local table = {}

function table.render_glow(x,y,w,h,round,r,g,b,a,glow_size)
    for radius = 4, math.floor(glow_size) do
        local radius_glow = radius / 2
        render.rect(vec2_t(x - radius_glow, y - radius_glow), vec2_t(w + radius_glow * 2, h + radius_glow * 2), color_t(r, g, b, math.floor(a / glow_size * (glow_size - radius))), round)
    end
end

return table