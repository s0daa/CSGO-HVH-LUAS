local scope_master = menu.add_checkbox("custom scope", "[enable] custom scope", true)
local scope_color = scope_master:add_color_picker("[enable] custom scope color")
local scope_offset = menu.add_slider("custom scope", "[scope] offset", 0, 500, 1, 0)
local scope_padding = menu.add_slider("custom scope", "[scope] padding", -250, 250, 1, 0)

scope_offset:set(100)
scope_padding:set(-110)

local function scope_render()
    if not scope_master:get() then return end
    local screen_size = render.get_screen_size()
    local screen_center = vec2_t(screen_size.x / 2, screen_size.y / 2)
    local lp = entity_list.get_local_player()
    if lp == nil then return end
    local health = lp:get_prop("m_iHealth")
    if health == 0 then return end
    local weap = lp:get_active_weapon()
    if weap == nil then return end
    local is_scoped = weap:get_prop("m_zoomLevel")
    local scoped_prop = lp:get_prop("m_bIsScoped")
    local in_scope = scoped_prop == 1 and true or false

    if in_scope == nil or not in_scope then return end
    if is_scoped == 0 or is_scoped == nil then return end
    local offset = scope_offset:get()

    pos = vec2_t(screen_center.x, screen_center.y - offset)
    size = vec2_t(1, offset)
    pos.y = pos.y - (scope_padding:get() - 1)
    render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get())

    pos = vec2_t(screen_center.x, screen_center.y + (offset * 0 ))
    size = vec2_t(1, offset - ( offset * 0 ))
    pos.y = pos.y + scope_padding:get()
    render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0))

    pos = vec2_t(screen_center.x - offset, screen_center.y)
    size = vec2_t(offset, 1)
    pos.x = pos.x - (scope_padding:get() - 1)
    render.rect_fade(pos, size, color_t(0, 0, 0, 0), scope_color:get(), true)

    pos = vec2_t(screen_center.x + (offset * 0 ), screen_center.y)
    size = vec2_t(offset - ( offset * 0 ), 1)
    pos.x = pos.x + scope_padding:get()
    render.rect_fade(pos, size, scope_color:get(), color_t(0, 0, 0, 0), true)
end

callbacks.add(e_callbacks.PAINT, scope_render)