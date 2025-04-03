local font1 = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local font2 = render.create_font("Small Fonts", 8, 400, e_font_flags.DROPSHADOW)

local function on_player_esp(ctx)
    ctx:set_font(font1)
    ctx:set_small_font(font2)
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)