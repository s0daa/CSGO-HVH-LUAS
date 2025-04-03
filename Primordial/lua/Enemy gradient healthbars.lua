local menu_elems = {}

menu_elems.master = menu.add_checkbox('Gradient healthbars', 'Enable gradient healthbars')
menu_elems.outline = menu.add_checkbox('Gradient healthbars', 'Outline')
menu_elems.outline_color = menu_elems.outline:add_color_picker('bg color', color_t(0, 0, 0, 150), true)
menu_elems.color_top = menu.add_checkbox('Gradient healthbars', 'Top color')
menu_elems.color_bot = menu.add_checkbox('Gradient healthbars', 'Bottom color')
menu_elems.color_t_top = menu_elems.color_top:add_color_picker('top color', color_t(255, 255, 255, 255), true)
menu_elems.color_t_bot = menu_elems.color_bot:add_color_picker('bottom color', color_t(255, 255, 255, 255), true)
menu_elems.better_color = menu.add_checkbox('Gradient healthbars', 'Better coloring')

callbacks.add(e_callbacks.PLAYER_ESP, function(ctx)
    if not menu_elems.master:get() then return end

    local ent = ctx.player
    local alpha = ctx.alpha_modifier
    local box_start = ctx.bbox_start
    local box_size = ctx.bbox_size
    local enemy = ctx.mode

    if enemy and ent:is_alive() then
        if menu_elems.outline:get() then
            render.rect_filled(box_start - vec2_t(-1, 0), vec2_t(4, box_size.y), menu_elems.outline_color:get(), 0)
        end
        
        local ent_health = math.max(0, math.min(ent:get_prop("m_iHealth"), 100))
        local perc_health = ent_health / 100

        local c = {
            top = menu_elems.color_t_top:get(),
            bot = menu_elems.color_t_bot:get()
        }

        if menu_elems.better_color:get() then
            local diff = {
                r = c.bot.r - c.top.r,
                g = c.bot.g - c.top.g,
                b = c.bot.b - c.top.b,
            }

            c.top = color_t(math.floor(c.top.r - diff.r*perc_health), math.floor(c.top.g - diff.g*perc_health), math.floor(c.top.b - diff.b*perc_health), c.top.a)
        end

        render.rect_fade(box_start - vec2_t(-2, -1) + vec2_t(0, (box_size.y - 2) * (1-perc_health)), vec2_t(2, (box_size.y - 2) - (box_size.y - 2) * (1-perc_health - 0.001)), c.top, c.bot, false)
    end
end)

callbacks.add(e_callbacks.PAINT, function()
    menu_elems.outline:set_visible(menu_elems.master:get())
    menu_elems.outline_color:set_visible(menu_elems.master:get() and menu_elems.outline:get())
    menu_elems.color_top:set_visible(menu_elems.master:get())
    menu_elems.color_bot:set_visible(menu_elems.master:get())
    menu_elems.color_t_top:set_visible(menu_elems.master:get())
    menu_elems.color_t_bot:set_visible(menu_elems.master:get())
    menu_elems.better_color:set_visible(menu_elems.master:get())
end)