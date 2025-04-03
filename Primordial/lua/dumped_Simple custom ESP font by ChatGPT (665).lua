local fonts = {
    "Arial",
    "Impact",
    "Calibri",
    "Smallest Pixel-7",
    "Verdana"
}

local function on_player_esp(ctx)
    local select1_val = select1:get()
    local check1_val1, check1_val2 = check1:get(1), check1:get(2)
    local font_flags = 0

    if check1_val1 then
        font_flags = e_font_flags.OUTLINE
    elseif check1_val2 then
        font_flags = e_font_flags.DROPSHADOW
    end

    if select1_val > 1 and select1_val <= #fonts then
        local font = render.create_font(fonts[select1_val], size1:get(), 20, font_flags)

        if not ctx.dormant then
            ctx:set_font(font)
        end
    end
end

select1 = menu.add_selection("Font", "Style", {"Off", unpack(fonts)})
size1 = menu.add_slider("Font", "Size", 10, 50)
check1 = menu.add_multi_selection("Font", "Extra", {"Outline", "Shadow"})

callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)