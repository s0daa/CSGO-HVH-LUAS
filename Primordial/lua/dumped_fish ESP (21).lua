local font = render.create_font("Verdana", 12, 100, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

callbacks.add(e_callbacks.PAINT, function()
    local fish = entity_list.get_entities_by_name("CFish")  -- much fish
    if fish == nil then return end -- no fish :(
        
    for i = 1, #fish do
        local pos = fish[i]:get_prop("m_vecOrigin")
        local screen = render.world_to_screen(pos)
        if screen == nil then return end

        render.text(font, "fish", screen, color_t(255, 255, 255, 255))
    end
end)