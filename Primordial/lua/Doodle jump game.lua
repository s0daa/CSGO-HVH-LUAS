local game = {}
game.size = vec2_t(200, 400)
game.pos = vec2_t(render.get_screen_size().x/2 - game.size.x/2, render.get_screen_size().y/2 - game.size.y/2)
game.state = 'paused'
game.color = color_t(150, 150, 255, 255)
game.moving = {}
game.moving.difference = vec2_t(0, 0)
game.paddles = {}
game.paddles.count = 6
game.paddles.gap = game.size.y / game.paddles.count
game.paddles.size = vec2_t(20, 6)
game.paddles.table = {}
game.font = render.create_font('Arial', 16, 400, e_font_flags.DROPSHADOW)
game.title_font = render.create_font('Comic Sans MS', 40, 400, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS)
game.title_prim_font = render.create_font('Comic Sans MS', 15, 400, e_font_flags.DROPSHADOW)
game.score = 0

local lil_jumper = {}
lil_jumper.size = vec2_t(30, 40)
lil_jumper.velocity = 0
lil_jumper.gravity = 0.1
lil_jumper.jump_power = 9
lil_jumper.image_right = render.load_image('primordial\\scripts\\doodler\\right.png')
lil_jumper.image_left = render.load_image('primordial\\scripts\\doodler\\left.png')
lil_jumper.last_side = 0

local accent_color = menu.find('misc', 'main', 'config', 'accent color')[2]

game.reset = function()
    game.paddles.table = {}
    for i = 1, 5 do
        table.insert(game.paddles.table, 1, {
            pos = vec2_t(client.random_int(0, game.size.x), game.size.y - i*game.paddles.gap), 
            size = game.paddles.size
        })
    end
    lil_jumper.pos = vec2_t(game.paddles.table[#game.paddles.table].pos.x, game.size.y -  game.size.y/3)
    lil_jumper.velocity = 0
    game.score = 0
end

lil_jumper.draw = function()
    if lil_jumper.last_side == 0 then
        render.texture(lil_jumper.image_left.id, game.pos + lil_jumper.pos, lil_jumper.size)
    else
        render.texture(lil_jumper.image_right.id, game.pos + lil_jumper.pos, lil_jumper.size)
    end
    --render.rect_filled(game.pos + lil_jumper.pos, lil_jumper.size, color_t(255, 255, 255, 255), 0)
end

for i = 1, 5 do
    table.insert(game.paddles.table, 1, {
        pos = vec2_t(client.random_int(0, game.size.x), game.size.y - i*game.paddles.gap), 
        size = game.paddles.size
    })
end

lil_jumper.pos = vec2_t(game.paddles.table[#game.paddles.table].pos.x, game.size.y -  game.size.y/3)


game.handle_paddle_drawing = function()
    for i = 1, #game.paddles.table do
        local paddle = game.paddles.table[i]
        -- render background
        render.rect_filled(game.pos + paddle.pos, paddle.size - vec2_t(0, 4), color_t(0, 0, 0, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(2, 2), paddle.size - vec2_t(2, 5), color_t(0, 0, 0, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(3, 3), paddle.size - vec2_t(4, 5), color_t(0, 0, 0, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(4, 4), paddle.size - vec2_t(6, 5), color_t(0, 0, 0, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(6, 5), paddle.size - vec2_t(10, 5), color_t(0, 0, 0, 255), 0)

        -- render foreground
        render.rect_filled(game.pos + paddle.pos, paddle.size - vec2_t(0, 4), color_t(150, 255, 150, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(1, 1), paddle.size - vec2_t(2, 5), color_t(150, 255, 150, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(2, 2), paddle.size - vec2_t(4, 5), color_t(150, 255, 150, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(3, 3), paddle.size - vec2_t(6, 5), color_t(150, 255, 150, 255), 0)
        render.rect_filled(game.pos + paddle.pos + vec2_t(5, 4), paddle.size - vec2_t(10, 5), color_t(150, 255, 150, 255), 0)
    end
end

game.handle_paddle_moving = function()
    for i = 1, #game.paddles.table do
        local paddle = game.paddles.table[i]
        paddle.pos.y = paddle.pos.y - lil_jumper.velocity
    end
end

game.remove_unwanted_paddles = function()
    for i = 1, #game.paddles.table do
        local paddle = game.paddles.table[i]
        if paddle.pos.y > game.pos.y + game.size.y + 200 then
            table.remove(game.paddles.table, i)
        end
    end
end

game.handle_game_state = function()
    if input.is_key_pressed(e_keys.KEY_P) and game.state ~= 'game_over' then
        game.state = game.state == 'paused' and 'playing' or 'paused'
    end

    if lil_jumper.pos.y > game.paddles.table[#game.paddles.table].pos.y + 100 then
        game.state = 'game_over'
    end

    if game.state == 'paused' then
        render.rect_filled(game.pos, game.size, color_t(60, 60, 60, 200))

        render.text(game.title_font, 'Doodbl Jump', game.pos + vec2_t(game.size.x/2, game.size.y/4), accent_color:get(), true)
        render.text(game.title_prim_font, 'for primordial', game.pos + vec2_t(game.size.x/2, game.size.y/4 + render.get_text_size(game.title_prim_font, 'Doobl Jump').y + 10), accent_color:get(), true)

        render.text(game.font, 'Game is paused.', game.pos + vec2_t(game.size.x/2, game.size.y/2), color_t(255, 255, 255, 255), true)
        render.text(game.font, '(Press P to resume)', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y), color_t(255, 255, 255, 255), true)
    
        render.text(game.font, 'Help:', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y*3), color_t(255, 255, 255, 255), true)
        render.text(game.font, 'Move jumper with arrows buttons.', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y*4), color_t(255, 255, 255, 255), true)
        render.text(game.font, 'Jumper jumps automatically.', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y*5), color_t(255, 255, 255, 255), true)
        render.text(game.font, 'idk thats it game\'s pretty', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y*7), color_t(255, 255, 255, 255), true)
        render.text(game.font, 'simple and straightforward.', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game is paused.').y*8), color_t(255, 255, 255, 255), true)

    elseif game.state == 'game_over' then
        render.text(game.font, string.format('Game over. Score: %i', game.score), game.pos + vec2_t(game.size.x/2, game.size.y/2), color_t(255, 255, 255, 255), true)
        render.text(game.font, '(Press Space to start again)', game.pos + vec2_t(game.size.x/2, game.size.y/2 + render.get_text_size(game.font, 'Game over. Score: %i').y), color_t(255, 255, 255, 255), true)
    end

    if game.state == 'game_over' and input.is_key_pressed(e_keys.KEY_SPACE) then
        game.reset()
        game.state = 'paused'
    end
end

lil_jumper.jump = function()
    lil_jumper.velocity = lil_jumper.velocity - lil_jumper.jump_power
    game.score = game.score + 1
    engine.play_sound('doodle_jump.wav', 1, 100)
end


lil_jumper.handle_moving = function()
    -- jumping
    lil_jumper.velocity = lil_jumper.velocity + lil_jumper.gravity
    --lil_jumper.pos.y = lil_jumper.pos.y + lil_jumper.velocity

    if lil_jumper.velocity < -9 then lil_jumper.velocity = -9 end

    -- left and right
    if input.is_key_held(e_keys.KEY_LEFT) then
        lil_jumper.pos.x = lil_jumper.pos.x - 2
        lil_jumper.last_side = 0
    end

    if input.is_key_held(e_keys.KEY_RIGHT) then
        lil_jumper.pos.x = lil_jumper.pos.x + 2
        lil_jumper.last_side = 1
    end

    if lil_jumper.pos.x > game.size.x then lil_jumper.pos.x = -lil_jumper.size.x
    elseif lil_jumper.pos.x + lil_jumper.size.x < 0 then lil_jumper.pos.x = game.size.x end

    for i = 1, #game.paddles.table do
        local paddle = game.paddles.table[i]

        if lil_jumper.velocity > 0 and lil_jumper.pos.x + lil_jumper.size.x > paddle.pos.x and lil_jumper.pos.x < paddle.pos.x + paddle.size.x and lil_jumper.pos.y  + lil_jumper.size.y > paddle.pos.y - 5 and lil_jumper.pos.y + lil_jumper.size.y < paddle.pos.y + paddle.size.y then
            lil_jumper.velocity = lil_jumper.velocity/2
            lil_jumper.jump()
        end
    end
end


local function handle_game_drawing()
    if input.is_mouse_in_bounds(game.pos, game.size) and input.is_key_held(e_keys.MOUSE_LEFT) then
        game.pos = game.moving.difference + input.get_mouse_pos()
    else
        game.moving.difference = game.pos - input.get_mouse_pos()
    end
    render.rect_filled(game.pos - vec2_t(1, 1), game.size + vec2_t(2, 2), color_t(0, 0, 0, 255), 0)
    render.rect_filled(game.pos, game.size, game.color, 0)

    render.text(game.font, string.format('Score: %s', game.score), game.pos + vec2_t(4, 4), color_t(255, 255, 255, 255))
end

local function on_paint()
    handle_game_drawing()

    render.push_clip(game.pos, game.size)
    game.handle_paddle_drawing()
    lil_jumper.draw()

    game.handle_game_state()
    if game.state == 'paused' or game.state == 'game_over' then return end

    lil_jumper.handle_moving()
    game.handle_paddle_moving()
    game.remove_unwanted_paddles()
    render.pop_clip()

    if lil_jumper.pos.y < game.paddles.table[1].pos.y + game.size.y + 200 then
        table.insert(game.paddles.table, 1, {
            pos = vec2_t(client.random_int(0, game.size.x), game.paddles.table[1].pos.y - game.paddles.gap),
            size = game.paddles.size
        })
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)