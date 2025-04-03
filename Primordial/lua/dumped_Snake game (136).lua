--* Woo snek game by khey
--* enjoy
local move_type = menu.add_selection('snek game', 'control type', {'arrows', 'wasd'})


local data = {
    keys = {
        font = render.create_font('Arial', 14, 400, e_font_flags.ANTIALIAS),

        last_up = 0,
        last_right = 0,
        last_down = 0,
        last_left = 0,

    },

    window = {
        pos = vec2_t(200, 200), --* initialize menu position
        size = vec2_t(200, 220), --* top 20 on y axis is for dragging

        mouse_difference = vec2_t(0, 0) --* simple dragging
    },

    game_data = {
        is_paused = false, --* so we can pause the game when moving menu around
        game_over = false,
        head_direction = vec2_t(1, 0), --* simple direction vector, -1 0 goes left, 0 1 goes down etc
        head_size = vec2_t(10, 10), --* each part size
        body_pcs = {vec2_t(40, 50), vec2_t(30, 50)}, --* this will contain our body pieces' coordinates
        last_move = 0, --* last move timer
        game_delay = 0.3, --* game speed, the lower it is, the faster our snakey boy will move
        food_pos = nil,
        score = 0,
        stored_velocity = vec2_t(1, 0),

        font_big = render.create_font('Arial', 20, 400, e_font_flags.ANTIALIAS)
    }
}

local render_keys = function ()
    local disabled_c = color_t(200, 200, 200, 200)
    local enabled_c = color_t(255, 255, 255, 255)

    -- ← ↑ → ↓ Arrow and direction symbols
    local up_text = ' ↑ '
    local right_text = '→'
    local down_text = ' ↓ '
    local left_text = '←'

    render.text(data.keys.font, up_text .. right_text .. down_text .. left_text, data.window.pos + vec2_t(2, 0), disabled_c)

    if data.keys.last_up > global_vars.cur_time() then
        render.text(data.keys.font, up_text, data.window.pos + vec2_t(2, 0), enabled_c)
    end

    if data.keys.last_right > global_vars.cur_time() then
        render.text(data.keys.font, right_text, data.window.pos + vec2_t(2, 0) + vec2_t(render.get_text_size(data.keys.font, up_text).x, 0), enabled_c)
    end

    if data.keys.last_down > global_vars.cur_time() then
        render.text(data.keys.font, down_text, data.window.pos + vec2_t(2, 0) + vec2_t(render.get_text_size(data.keys.font, up_text .. right_text).x, 0), enabled_c)
    end

    if data.keys.last_left > global_vars.cur_time() then
        render.text(data.keys.font, left_text, data.window.pos + vec2_t(2, 0) + vec2_t(render.get_text_size(data.keys.font, up_text .. right_text .. down_text).x, 0), enabled_c)
    end

    if (move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_UP)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_W)) then
        data.keys.last_up = global_vars.cur_time() + 0.2
    end

    if (move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_RIGHT)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_D)) then
        data.keys.last_right = global_vars.cur_time() + 0.2
    end

    if (move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_DOWN)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_S)) then
        data.keys.last_down = global_vars.cur_time() + 0.2
    end

    if (move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_LEFT)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_A)) then
        data.keys.last_left = global_vars.cur_time() + 0.2
    end
end

local spawn_new_food = function ()
    if not data.game_data.food_pos then
        local x = client.random_int(0, data.window.size.x - data.game_data.head_size.x)
        local y = client.random_int(0, data.window.size.y - 20 - data.game_data.head_size.y)

        local x = x - x%10
        local y = y - y%10

        data.game_data.food_pos = vec2_t(x, y)
        
        for i = 1, #data.game_data.body_pcs do
            if vec2_t(x, y) == data.game_data.body_pcs[i] then
                data.game_data.food_pos = nil
                break
            end
        end
    end
end

local handle_velocity = function ()
    if ((move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_UP)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_W))) and data.game_data.stored_velocity ~= vec2_t(0, 1) then
        data.game_data.head_direction = vec2_t(0, -1)
    elseif ((move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_RIGHT)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_D))) and data.game_data.stored_velocity ~= vec2_t(-1, 0) then
        data.game_data.head_direction = vec2_t(1, 0)
    elseif ((move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_DOWN)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_S))) and data.game_data.stored_velocity ~= vec2_t(0, -1) then
        data.game_data.head_direction = vec2_t(0, 1)
    elseif ((move_type:get() == 1 and input.is_key_pressed(e_keys.KEY_LEFT)) or (move_type:get() == 2 and input.is_key_pressed(e_keys.KEY_A))) and data.game_data.stored_velocity ~= vec2_t(1, 0) then
        data.game_data.head_direction = vec2_t(-1, 0)
    end
end

local render_window = function ()
    local mousepos = input.get_mouse_pos()
    --* Handle window dragging
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(data.window.pos, vec2_t(data.window.size.x, 20)) then
        data.window.pos = mousepos + data.window.mouse_difference
        data.game_data.is_paused = true
    else
        data.window.mouse_difference = data.window.pos - mousepos
    end

    render.rect_filled(data.window.pos, data.window.size, color_t(21, 21, 21, 255), 0)
    render.rect_filled(data.window.pos, vec2_t(data.window.size.x, 20), color_t(51, 51, 51, 255), 0)
end

local handle_collision = function()
    if not data.game_data.game_over then
        for i = 2, #data.game_data.body_pcs, 1 do
            if data.game_data.body_pcs[1] == data.game_data.body_pcs[i] then
                data.game_data.game_over = true
            end
        end
    end
end

local on_paint = function ()
    local game_field_start = data.window.pos + vec2_t(0, 20)

    render_window()
    handle_velocity()
    spawn_new_food()

    if global_vars.cur_time() > data.game_data.last_move and not data.game_data.is_paused and not data.game_data.game_over then
        local len = #data.game_data.body_pcs
        for i = 0, #data.game_data.body_pcs, 1 do
            if not data.game_data.body_pcs[len - i] or i + 1 == len then break end
            if data.game_data.body_pcs[len - i] ~= data.game_data.body_pcs[len - i - 1] then
                data.game_data.body_pcs[len - i] = data.game_data.body_pcs[len - i - 1]
            end
        end

        --* set the first block position to head position

        --* move head position according to velocity
        data.game_data.body_pcs[1] = data.game_data.body_pcs[1] + vec2_t(10 * data.game_data.head_direction.x, 10 * data.game_data.head_direction.y)

        --* update stored_velocity
        data.game_data.stored_velocity = data.game_data.head_direction
        --* update last_move
        data.game_data.last_move = global_vars.cur_time() + data.game_data.game_delay
        
    end

    --* if our player goes out of play area, put him to the other side (like in snake owo)
    if data.game_data.body_pcs[1].x > data.window.size.x - data.game_data.head_size.x then
        data.game_data.body_pcs[1].x = 0
    elseif data.game_data.body_pcs[1].x < 0 then
        data.game_data.body_pcs[1].x = data.window.size.x - data.game_data.head_size.x
    elseif data.game_data.body_pcs[1].y > data.window.size.y - data.game_data.head_size.y - 20 then
        data.game_data.body_pcs[1].y = 0
    elseif data.game_data.body_pcs[1].y < 0 then
        data.game_data.body_pcs[1].y = data.window.size.y - data.game_data.head_size.y - 20
    end

    --* if we are covering the food
    if data.game_data.body_pcs[1] == data.game_data.food_pos then
        data.game_data.food_pos = nil

        --* add a new value to our table to the last position with the coordinates of last_pos-1
        table.insert(data.game_data.body_pcs, #data.game_data.body_pcs, data.game_data.body_pcs[#data.game_data.body_pcs])

        --* update score
        data.game_data.score = data.game_data.score + 1

        --* make game faster
        if data.game_data.score % 5 == 0 then
            data.game_data.game_delay = data.game_data.game_delay - 0.025
        end
    end

    --* render body pieces
    for i = 2, #data.game_data.body_pcs, 1 do
        if not data.game_data.body_pcs[i] then break end
        render.rect_filled(game_field_start + data.game_data.body_pcs[i], data.game_data.head_size, color_t(210, 210, 210, 255), 0)
    end

    --* render food and head
    if data.game_data.food_pos then
        render.rect_filled(game_field_start + data.game_data.food_pos, data.game_data.head_size, color_t(0, 255, 0, 255), 5)
    end
    render.rect_filled(game_field_start + data.game_data.body_pcs[1], data.game_data.head_size, color_t(255, 255, 255, 255), 1)

    --* render score
    render.text(data.keys.font, 'Score: ' .. tostring(data.game_data.score), data.window.pos + vec2_t(data.window.size.x - render.get_text_size(data.keys.font, 'Score: ' .. tostring(data.game_data.score)).x, 0), color_t(255, 255, 255, 255))

    if data.game_data.game_over then
        render.text(data.game_data.font_big, 'Game over.', data.window.pos + vec2_t(data.window.size.x / 2, data.window.size.y/2), color_t(255, 10, 10, 230), true)
        render.text(data.keys.font, 'Score: '..tostring(data.game_data.score), data.window.pos + vec2_t(data.window.size.x / 2, data.window.size.y/2 + render.get_text_size(data.game_data.font_big, 'Game over.').y), color_t(255, 10, 10, 230), true)
        
        if (input.is_key_pressed(e_keys.KEY_UP) or input.is_key_pressed(e_keys.KEY_RIGHT) or input.is_key_pressed(e_keys.KEY_DOWN) or input.is_key_pressed(e_keys.KEY_LEFT)) then
            data.game_data.game_over = false

            -- reset values
            data.game_data.is_paused = false 
            data.game_data.head_direction = vec2_t(1, 0) 
            data.game_data.body_pcs = {vec2_t(40, 50), vec2_t(30, 50)} 
            data.game_data.last_move = 0 
            data.game_data.game_delay = 0.4 
            data.game_data.food_pos = nil
            data.game_data.score = 0
            data.game_data.stored_velocity = vec2_t(1, 0)
        end
    end

    if input.is_key_pressed(e_keys.KEY_SPACE) then
        data.game_data.is_paused = not data.game_data.is_paused
    end

    render_keys()
    handle_collision()
end

callbacks.add(e_callbacks.PAINT, on_paint)