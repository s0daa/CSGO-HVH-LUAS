local side = false
local back = false


function draw_side_arrow(x, y, size, color, side)
    if(side) then
        for i = 0, (size - 1) do
            render.rect(vec2_t(x + i, y + (i / 2) + 1), vec2_t(1, size - i), color)
        end
        
    else
        for i = 0, (size - 1) do
            render.rect(vec2_t(x - i, y + (i / 2) + 1), vec2_t(1, size - i), color)
        end 
    end  
end

function draw_back_arrow(x, y, size, color, side)
    if(back) then
        for i = 0, (size - 1) do
            render.rect(vec2_t(x - 0.5 - (i / 2), y - i / 50 + 30), vec2_t(1, size - i), color)
        end
        for i = 0, (size - 1) do
            render.rect(vec2_t(x + (i / 2), y - i / 50 + 30), vec2_t(1, size - i), color)
        end
        
    else
        for i = 0, (size - 1) do
            render.rect(vec2_t(x - i, y + (i / 2) + 1), vec2_t(1, size - i), color)
        end 
    end  
end

local arrows = menu.add_checkbox("visual", "custom manual arrows")

local references = {
    left = menu.find("antiaim", "main", "manual", "left"),
    back = menu.find("antiaim", "main", "manual", "back"),
    right = menu.find("antiaim", "main", "manual", "right")

}

callbacks.add(e_callbacks.PAINT, function()

    local local_player = entity_list.get_local_player()

    if local_player == nil or local_player:is_alive() ~= true and engine.is_connected() ~= true and engine.is_in_game() ~= true then
        return
    end

    if arrows:get() ~= true then
        return
    end

    menu.find("antiaim", "main", "manual", "visualization", "manual")[1]:set(false)

    local custom_colour = menu.find("misc", "main", "config", "accent color")[2]:get()

    local screen_size = render.get_screen_size()

    if references.left[2]:get_key() ~= e_keys.KEY_NONE and references.back[2]:get_key() ~= e_keys.KEY_NONE and references.right[2]:get_key() ~= e_keys.KEY_NONE then
        render.rect(vec2_t(screen_size.x / 2 - 100, screen_size.y - 70), vec2_t(200, 60), color_t(100, 100, 100, 255))
        render.rect_filled(vec2_t(screen_size.x / 2 - 100, screen_size.y - 70), vec2_t(200, 60), color_t(0, 0, 0, 120))

        side = true;
        draw_side_arrow(screen_size.x / 2 + 10 + 30 + 1, screen_size.y - 50, 16, color_t(100, 100, 100, 100), side)

        side = false;
        draw_side_arrow(screen_size.x / 2 - 10 - 30 + 1, screen_size.y - 50, 16, color_t(100, 100, 100, 100), side)

        back = true;
        draw_back_arrow(screen_size.x / 2, screen_size.y - 77, 16, color_t(100, 100, 100, 100), back)

        if antiaim.get_manual_override() == 3 then
           side = true;
           draw_side_arrow(screen_size.x / 2 + 10 + 30 + 1, screen_size.y - 50, 16, custom_colour, side)

        elseif antiaim.get_manual_override() == 1 then
            side = false;
            draw_side_arrow(screen_size.x / 2 - 10 - 30 + 1, screen_size.y - 50, 16, custom_colour, side)

        elseif antiaim.get_manual_override() == 2 then
            back = true;
            draw_back_arrow(screen_size.x / 2, screen_size.y - 77, 16, custom_colour, back)
        end
    end
end)