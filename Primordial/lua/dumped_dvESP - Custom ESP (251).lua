--- Custom ESP by dve
---@diagnostic disable: redundant-parameter
local ui = {
    enabled             = menu.add_checkbox('ESP', 'Enable ESP', true),
    teammates           = menu.add_checkbox('ESP', 'Teammates'),
    box                 = menu.add_checkbox('ESP', 'Box'),
    health_bar          = menu.add_checkbox('ESP', 'Health Bar'),
    health_bar_bg       = menu.add_checkbox('ESP', 'Outline/Background'),
    health_bar_style    = menu.add_list('ESP', 'Style', { 'Health Based', 'Solid Color', 'Gradient', 'Gradient 2' }, 4),
    name                = menu.add_checkbox('ESP', 'Name'),
    weapon              = menu.add_checkbox('ESP', 'Weapon'),
    ammo_bar            = menu.add_checkbox('ESP', 'Ammo'),
    flags               = menu.add_multi_selection('ESP', 'Flags', { 'Money', 'Armor', 'Defuser', 'Bomb', 'Scoped', 'Fake Duck' }, 6),
    font                = menu.add_list('ESP', 'Name/Weapon', { 'Pixel', 'Verdana', 'Verdana Bold' }, 3)
}
local color = {
    box                 = ui.box:add_color_picker('Color', color_t(255, 255, 255, 255)),
    health_bar          = ui.health_bar:add_color_picker('Color', color_t(0, 255, 0, 255)),
    name                = ui.name:add_color_picker('Color', color_t(255, 255, 255, 255)),
    weapon              = ui.weapon:add_color_picker('Color', color_t(255, 255, 255, 255)),
    ammo_bar            = ui.ammo_bar:add_color_picker('Color', color_t(255, 255, 255, 255)),
    flags               = ui.flags:add_color_picker('Color', color_t(255, 255, 255, 255)),
}     
local fonts = {
    verdana     = render.create_font('Verdana', 12, 0),
    verdana_b   = render.create_font('Verdana', 12, 700, e_font_flags.DROPSHADOW),
    pixel       = render.create_font('Smallest Pixel-7', 10, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE),
}
local truncate = function(name) if #name > 10 then return name:sub(1, 10) .. '...' else return name end end
render.bounding_box = function(loc, size, color)
    render.rect(vec2_t(loc.x + 1, loc.y),               vec2_t(size.x - 1, 1), color)
    render.rect(vec2_t(loc.x + size.x - 1, loc.y + 1),  vec2_t(1, size.y - 1), color)
    render.rect(vec2_t(loc.x, loc.y + size.y - 1),      vec2_t(size.x - 1, 1), color)
    render.rect(vec2_t(loc.x, loc.y),                   vec2_t(1, size.y - 1), color)
end
local health_to_color = function(health)
    if health == 50 then return color_t(255, 255, 0, 255) end
    if health == 100 then return color_t(0, 255, 0, 255) end
    local new_clr = color_t(0, 0, 0, 255)
    if health < 50 then
        new_clr.r = 255
        new_clr.g = math.floor(255 + (health * 2 / 100) * 255)
    else
        new_clr.r = math.floor(math.abs(0 + (math.fmod(health, 50) * 2) / 100))
        new_clr.g = 255
    end
    return color_t(new_clr.r, new_clr.g, 0, 255)
end

local on_player_esp = function(ctx)
    if not ui.enabled:get() then return end

    local teammates             = ui.teammates:get()
    local box                   = ui.box:get()
    local box_color             = color.box:get()
    local health_bar            = ui.health_bar:get()
    local health_bar_bg         = ui.health_bar_bg:get()
    local health_bar_col        = color.health_bar:get()
    local health_bar_style      = ui.health_bar_style:get()
    local name                  = ui.name:get()
    local name_col              = color.name:get()
    local weapon                = ui.weapon:get()
    local weapon_col            = color.weapon:get()
    local ammo_bar              = ui.ammo_bar:get()
    local ammo_bar_col          = color.ammo_bar:get()
    local flags                 = ui.flags
    local flags_col             = color.flags:get()
    local font                  = fonts.pixel
    local _font
    if ui.font:get() == 1 then _font = fonts.pixel
    elseif ui.font:get() == 2 then _font = fonts.verdana
    elseif ui.font:get() == 3 then _font =  fonts.verdana_b end

    local player_name           = ctx.player:get_name()
    local player_money          = ctx.player:get_prop('m_iAccount')
    local player_weapon         = ctx.player:get_active_weapon()
    local player_weapon_name    = player_weapon and player_weapon:get_name() or nil
    local player_ammo           = player_weapon and player_weapon:get_prop('m_iClip1') or 0
    local player_ammo_max       = player_weapon and player_weapon:get_weapon_data().max_clip or 0

    local player_health         = ctx.player:get_prop('m_iHealth')
    local player_helmet         = ctx.player:get_prop('m_bHasHelmet') == 1
    local player_kevlar         = ctx.player:get_prop('m_ArmorValue') ~= 0

    local player_defuser        = ctx.player:get_prop('m_bHasDefuser')
    local player_carrier        = ctx.player:get_prop('m_iPlayerC4')
    local player_scoped         = ctx.player:get_prop('m_bIsScoped') == 1
    local player_height         = ctx.player:get_prop('m_flDuckAmount')
    local player_chest_pos      = render.world_to_screen(ctx.player:get_hitbox_pos(e_hitboxes.CHEST))

    local flags_index           = 0
    local bottom_index          = 7

    if not teammates then if not ctx.player:is_enemy() then return end end
    if player_chest_pos ~= nil then
        if not (ctx.bbox_start.x + ctx.bbox_size.x / 2 > player_chest_pos.x - 75) then return end
        if not (ctx.bbox_start.x + ctx.bbox_size.x / 2 < player_chest_pos.x + 75) then return end
    else
        return
    end

    local x1, y1, x2, y2, a     = ctx.bbox_start.x, ctx.bbox_start.y, ctx.bbox_size.x, ctx.bbox_size.y, ctx.alpha_modifier
    if x1 ~= nil and y1 ~= nil and x2 ~= nil and y2 ~= nil and a > 0 then
        if box then
            render.bounding_box(vec2_t(x1 + 1, y1 + 1),   vec2_t(x2 - 2, y2 - 2),   color_t(0, 0, 0, 155))
            render.bounding_box(vec2_t(x1, y1),           vec2_t(x2, y2),           box_color)
            render.bounding_box(vec2_t(x1 - 1, y1 - 1),   vec2_t(x2 + 2, y2 + 2),   color_t(0, 0, 0, 155))
        end

        if health_bar and player_health ~= 0 then
            local percent = math.abs((player_health - 100) / 100)
            if health_bar_bg then render.rect_filled(vec2_t(x1 - 5, y1 - 1), vec2_t(3, y2 + 2), color_t(0, 0, 0, 155)) end
            if health_bar_style == 1 then
                if health_bar_bg then render.rect(vec2_t(x1 - 4, y1), vec2_t(1, y2), color_t(0, 0, 0, 255)) end
                render.rect(vec2_t(x1 - 4, y1 + y2 * percent), vec2_t(1, (y2 - y2 * percent) + 1), health_to_color(player_health))
            elseif health_bar_style == 2 then
                if health_bar_bg then render.rect(vec2_t(x1 - 4, y1), vec2_t(1, y2), color_t(0, 0, 0, 255)) end
                render.rect(vec2_t(x1 - 4, y1 + y2 * percent), vec2_t(1, (y2 - y2 * percent) + 1), health_bar_col)
            elseif health_bar_style == 3 then
                render.rect_fade(vec2_t(x1 - 4, y1 + y2 * percent), vec2_t(1, (y2 - y2 * percent) + 1), health_bar_col, color_t(0, 0, 0, 155), false)
            elseif health_bar_style == 4 then
                render.rect_fade(vec2_t(x1 - 4, y1), vec2_t(1, y2), health_bar_col, color_t(255, 0, 0, 255), false)
                render.rect(vec2_t(x1 - 4, y1), vec2_t(1, y2 - y2 * (1 - percent)), color_t(0, 0, 0, 255))
            end
            if player_health < 100  and (health_bar_style ~= 1 and health_bar_style ~= 4)  then
                render.text(font, tostring(player_health), vec2_t(x1 - 7, y1 + y2 * percent - 2), health_bar_col, true)
            elseif player_health < 100  and (health_bar_style == 1 or health_bar_style == 4) then
                render.text(font, tostring(player_health), vec2_t(x1 - 7, y1 + y2 * percent - 2), health_to_color(player_health), true)
            end
        end

        if name then
            render.text(_font, truncate(player_name), vec2_t(x1 + x2/2, y1 - 5), name_col, true)
        end

        if ammo_bar and player_ammo ~= 0 and player_ammo_max ~= 0 then
            local percent = 1 - math.abs((player_ammo - player_ammo_max) / player_ammo_max)
            render.rect_filled(vec2_t(x1 - 1, y1 + y2 + 2), vec2_t(x2 + 2, 3), color_t(0, 0, 0, 155))                   -- outline
            render.rect(vec2_t(x1 + 1, y1 + y2 + 3), vec2_t(x2 - 1, 1), color_t(0, 0, 0, 255))                          -- background
            render.rect(vec2_t(x1 + 1, y1 + y2 + 3), vec2_t(x2 * percent, 1), ammo_bar_col)                             -- ammo bar
            bottom_index = bottom_index + 4
        end
        if weapon and player_weapon_name ~= nil then
            render.text(_font, string.upper(player_weapon_name), vec2_t(x1 + x2/2, y1 + y2 + bottom_index), weapon_col, true)
            bottom_index = bottom_index + 5
        end
        if flags:get(1) then                                                                                            -- Money
            render.text(font, '$' .. player_money, vec2_t(x1 + x2 + 3, y1 + flags_index), color_t(0, 255, 0, flags_col.a))
            flags_index = flags_index + 8
        end
        if flags:get(2) then                                                                                            -- Armor
            if player_helmet and player_kevlar then
                render.text(font, 'HK', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
                flags_index = flags_index + 8
            elseif player_helmet then
                render.text(font, 'H', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
                flags_index = flags_index + 8
            elseif player_kevlar then
                render.text(font, 'K', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
                flags_index = flags_index + 8
            end
        end
        if flags:get(3) then                                                                                            -- Defuser
            if player_defuser then
                render.text(font, 'KIT', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
                flags_index = flags_index + 8
            end
        end
        if flags:get(4) then                                                                                            -- C4
            if player_carrier then
                render.text(font, 'C4', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
                flags_index = flags_index + 8
            end
        end
        if flags:get(5) and player_scoped then
            render.text(font, 'ZOOM', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
            flags_index = flags_index + 8
        end
        if flags:get(6) and player_height > 0 and player_height < 1 then                                                -- Fake Duck
            render.text(font, 'FD', vec2_t(x1 + x2 + 3, y1 + flags_index), flags_col)
            flags_index = flags_index + 8
        end
    end
end

callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)