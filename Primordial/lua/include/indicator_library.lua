local M = {
    indicators = {},
    font = render.create_font( "Verdana", 26, 700, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW )
}

function M:add_indicator(text, colors, func)
    table.insert(self.indicators, {
        title = ("%i"):format(#self.indicators + 1),
        text = text,
        colors = colors,
        func = func
    })
end

function M:on_paint()
    screen_size = render.get_screen_size()
    base_position = vec2_t(20, screen_size.y * 0.92)

    height_offset = 0
    table.foreach(self.indicators, function(idx, indicator)
        text_size = render.get_text_size(self.font, indicator.text)
        base_position.y = base_position.y - ( height_offset * (text_size.y - 3) )

        size = (indicator.func() or 0) * text_size.x

        render.text( self.font, indicator.text, base_position, indicator.colors[1] )
        render.push_clip( base_position, vec2_t( size, text_size.y ) )
        render.text( self.font, indicator.text, base_position, indicator.colors[2] )
        render.pop_clip( )
        
        height_offset = height_offset + 1
    end)
end

return M