--* Zeus warning, [Hit flag] (justin)
local icon_font = render.create_font("UnderStrukk Regular", 22, 100, e_font_flags.ANTIALIAS)
local ind = menu.add_checkbox("Zeus Warning", "Enable")
local text = menu.add_text("Zeus Warning", "Active Color")
local text2 = menu.add_text("Zeus Warning", "In Active Color")

local ind_col = text:add_color_picker("Color [Active]", color_t(255, 162, 0))
local ind_col2 = text2:add_color_picker("Color [In Active]", color_t(212, 106, 106))


local function on_player_esp(ctx)

local enemies = entity_list.get_players(true)
local lp = entity_list.get_local_player()
if lp == nil or enemies == nil then
return
end
if engine.is_connected() and engine.is_in_game() then
--Zeus Warning

local enemy = ctx.player --Zeus Warning
if ind:get() then
    if not enemy then
        return
    end
    if ctx.dormant then
        return
    end
    local enemy_pos = enemy:get_render_origin() + vec3_t(0, 0, 78)
    local enemy_screen_pos = render.world_to_screen(enemy_pos)
    if enemy_screen_pos == nil then
        return
    end
    local bbox = ctx.bbox_start
    local bboxsize = ctx.bbox_size

    local activeweapon = enemy:get_active_weapon()
    if activeweapon == nil then
        return
    end
    local weaponname = activeweapon:get_name()
    if weaponname == "taser" then
        render.text(icon_font, "S", vec2_t(bbox.x - 35, bbox.y + 0), ind_col()) --the bboxsize.x/5 makes no sense ik but idc will fix somewhen
    else
      render.text(icon_font, "Z", vec2_t(bbox.x - 35, bbox.y + 0), ind_col2())
    end
end
end
end
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)