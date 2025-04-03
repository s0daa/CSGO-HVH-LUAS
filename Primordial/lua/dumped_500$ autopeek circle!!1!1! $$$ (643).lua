local elements = {
    enable = menu.add_checkbox("Sk33t peek!!!", "Enable", false),
    size = menu.add_slider("Sk33t peek!!!", "Size", 20, 50),
    segments = menu.add_slider("Sk33t peek!!!", "Segments", 10, 128),
    step = menu.add_slider("Sk33t peek!!!", "Step", 1, 20),
    multiplier = menu.add_slider("Sk33t peek!!!", "Alpha multiplier", 1, 10),
}

elements.size:set(25)
elements.segments:set(22)
elements.step:set(7)
elements.multiplier:set(5)

local color = elements.enable:add_color_picker("color")
callbacks.add(e_callbacks.PAINT, function()
    color_get = color:get()
    local r, g, b = color_get.r, color_get.g, color_get.b
    local position = ragebot.get_autopeek_pos()
    local local_player = entity_list.get_local_player()
    if position ~= nil and elements.enable:get() then   
        local circle_size = elements.size:get()
        local num_segments = elements.segments:get()
        local step = elements.step:get() / 10
        
        for i = 1, circle_size, step do
            local a = math.ceil(math.log(1/3 * 255) / math.log(i + elements.multiplier:get() * 10))
            if math.pow(a, 2) / 1.3 < i then
                a = math.ceil(a / 0.7)
            end
                if a > 100 then goto skip end

            local vertices = {}
            for j = 0, num_segments do
                local angle = (j / num_segments) * math.pi * 2
                local x = math.cos(angle) * (circle_size - i)
                local y = math.sin(angle) * (circle_size - i)
                local pos = render.world_to_screen(position + vec3_t(x, y, 0))
                table.insert(vertices, pos)
            end
            if local_player:is_alive() then
                render.polygon(vertices, color_t(r, g, b, a))
            end
            ::skip::
        end
    end
end)