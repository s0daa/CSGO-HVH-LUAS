--menu
select1 = menu.add_selection("Font","Style", {"Off", "Arial", "Impact", "Calibri", "Smallest Pixel", "Verdana"})
size1 = menu.add_slider("Font", "Size", 10, 50)
check1 = menu.add_multi_selection("Font", "extra", {"outline", "shadow"})


--no outline
local function on_player_esp(ctx)
    size2 = size1:get() --slider value
    
    --render fonts
    local font1 = render.create_font("Arial", size2, 20)
    local font2 = render.create_font("Impact", size2, 20)
    local font3 = render.create_font("Calibri", size2, 20)
    local font4 = render.create_font("Smallest Pixel-7", size2, 20)
    local font5 = render.create_font("Verdana", size2, 20)
    if (select1:get() == 2) and not check1:get(1) and not check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font1)
    end
    if (select1:get() == 3) and not check1:get(1) and not check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font2)
    end
    if (select1:get() == 4) and not check1:get(1) and not check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font3)
    end
    if (select1:get() == 5) and not check1:get(1) and not check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font4)
    end
    if (select1:get() == 6) and not check1:get(1) and not check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font5)
    end
    end
    callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)


--outline
local function on_player_esp(ctx)
size2 = size1:get() --slider value

--render fonts
local font1 = render.create_font("Arial", size2, 20, e_font_flags.OUTLINE)
local font2 = render.create_font("Impact", size2, 20, e_font_flags.OUTLINE)
local font3 = render.create_font("Calibri", size2, 20, e_font_flags.OUTLINE)
local font4 = render.create_font("Smallest Pixel-7", size2, 20, e_font_flags.OUTLINE)
local font5 = render.create_font("Verdana", size2, 20, e_font_flags.OUTLINE)
if (select1:get() == 2) and check1:get(1) and not check1:get(2) then
    if ctx.dormant then
        return
    end
    ctx:set_font(font1)
end
if (select1:get() == 3) and check1:get(1) and not check1:get(2) then
    if ctx.dormant then
        return
    end
    ctx:set_font(font2)
end
if (select1:get() == 4) and check1:get(1) and not check1:get(2) then
    if ctx.dormant then
        return
    end
    ctx:set_font(font3)
end
if (select1:get() == 5) and check1:get(1) and not check1:get(2) then
    if ctx.dormant then
        return
    end
    ctx:set_font(font4)
end
if (select1:get() == 6) and check1:get(1) and not check1:get(2) then
    if ctx.dormant then
        return
    end
    ctx:set_font(font5)
end
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)


--shadow
local function on_player_esp(ctx)
    size2 = size1:get() --slider value
    
    --render fonts
    local font1 = render.create_font("Arial", size2, 20, e_font_flags.DROPSHADOW)
    local font2 = render.create_font("Impact", size2, 20, e_font_flags.DROPSHADOW)
    local font3 = render.create_font("Calibri", size2, 20, e_font_flags.DROPSHADOW)
    local font4 = render.create_font("Smallest Pixel-7", size2, 20, e_font_flags.DROPSHADOW)
    local font5 = render.create_font("Verdana", size2, 20, e_font_flags.DROPSHADOW)
    if (select1:get() == 2) and not check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font1)
    end
    if (select1:get() == 3) and not check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font2)
    end
    if (select1:get() == 4) and not check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font3)
    end
    if (select1:get() == 5) and not check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font4)
    end
    if (select1:get() == 6) and not check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font5)
    end
    end
    callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)


--shadow + outline
local function on_player_esp(ctx)
    size2 = size1:get() --slider value
    
    --render fonts
    local font1 = render.create_font("Arial", size2, 20, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    local font2 = render.create_font("Impact", size2, 20, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    local font3 = render.create_font("Calibri", size2, 20, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    local font4 = render.create_font("Smallest Pixel-7", size2, 20, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    local font5 = render.create_font("Verdana", size2, 20, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE)
    if (select1:get() == 2) and check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font1)
    end
    if (select1:get() == 3) and check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font2)
    end
    if (select1:get() == 4) and check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font3)
    end
    if (select1:get() == 5) and check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font4)
    end
    if (select1:get() == 6) and check1:get(1) and check1:get(2) then
        if ctx.dormant then
            return
        end
        ctx:set_font(font5)
    end
    end
    callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)