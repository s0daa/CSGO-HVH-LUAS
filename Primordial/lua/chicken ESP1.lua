local verdana = render.create_font("Verdana", 12, 100, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

callbacks.add(e_callbacks.PAINT, function()
    local chicken = entity_list.get_entities_by_name("CChicken")
    for i = 1, #chicken do
        local chicken_pos = chicken[i]:get_prop("m_vecOrigin")
        local chicken_screen = render.world_to_screen(chicken_pos)
        if chicken_screen == nil then return end
        render.progress_circle(chicken_screen, 0, color_t.new(255,0,0), 3, 1)
        render.text(verdana, "chicken", chicken_screen, color_t(255, 255, 255, 255))
    end
end)