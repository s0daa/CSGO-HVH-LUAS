--| Create the menu element(s)
local rainbow_checkbox = menu.add_checkbox("los the lua man", "china hat rainbow", true)

--| The paint callback
local function on_paint()
    -- Return if not in thirdperson
    if not client.is_in_thirdperson() then
        return
    end

    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Get the head origin
    local origin = local_player:get_hitbox_pos(e_hitboxes.HEAD) + vec3_t(0, 0, 10)

    -- Get the screen position of the head origin
    local screen_pos = render.world_to_screen(origin)
    if screen_pos == nil then
        return
    end

    -- Calculate the color
    local color = color_t(255, 255, 255, 55)
    if rainbow_checkbox:get() then
        color = color_t.from_hsb(global_vars.tick_count() % 360 / 360, 1, 1)
    end

    -- Calculate the hat edges
    local last_edge
    local view_yaw = engine.get_view_angles().y
    for angle_deg = 0, 3600 do
        -- Get the offset vector and set the Z to -5
        local offset_vector = angle_t(0, angle_deg/10 + view_yaw, 0):to_vector():scaled(10)
        offset_vector.z = -5

        -- Get the screen position of the offset vector
        local screen_pos_edge = render.world_to_screen(origin + offset_vector)

        -- Draw the line
        if screen_pos_edge ~= nil then
            render.line(screen_pos, screen_pos_edge, color)
            if last_edge then
                render.line(last_edge, screen_pos_edge, color)
            end
            last_edge = screen_pos_edge
        end
    end
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)