local fake_checkbox = menu.add_checkbox("general", "fake arrow")
local fake_color = fake_checkbox:add_color_picker("fake arrow color", color_t(240, 85, 85))
local fake_arrow_length = menu.add_slider("general", "fake arrow lenght", 10, 150)
fake_arrow_length:set(30)

local real_checkbox = menu.add_checkbox("general", "real arrow")
local real_color = real_checkbox:add_color_picker("real arrow color")
local real_arrow_length = menu.add_slider("general", "real arrow lenght", 10, 150)
real_arrow_length:set(30)

local function draw_arrow(world_pos, angle, length, color)
    local forward, right, up = angle_t(0, angle, 0):to_vector()

    local p1 = world_pos
    local p2 = world_pos + forward:scaled(length)
    
    local p1_screen = render.world_to_screen(p1)
    local p2_screen = render.world_to_screen(p2)

    if p1_screen == nil or p2_screen == nil then
        return
    end

    render.line(p1_screen, p2_screen, color)

    -- now render the tippy top
    local triangle_p1 = render.world_to_screen(p2 + right:scaled(4))
    local triangle_p2 = render.world_to_screen(p2 - right:scaled(4))
    local triangle_p3 = render.world_to_screen(p2 + forward:scaled(8))

    if triangle_p1 == nil or triangle_p2 == nil or triangle_p3 == nil then
        return
    end

    render.polygon({ triangle_p1, triangle_p2, triangle_p3 }, color)
end

local function on_paint()
    local local_player = entity_list.get_local_player()
    if local_player == nil or not local_player:is_alive() then 
        return
    end

    local local_origin = local_player:get_render_origin()

    if fake_checkbox:get() then
        draw_arrow(local_origin, antiaim.get_fake_angle(), fake_arrow_length:get(), fake_color:get())
    end

    if real_checkbox:get() then
        draw_arrow(local_origin, antiaim.get_real_angle(), real_arrow_length:get(), real_color:get())
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)