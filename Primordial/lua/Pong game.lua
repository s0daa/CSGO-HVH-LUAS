--* pong game by khey
--* enjo

local data = {
    player_paddle = {
        pos = vec2_t(render.get_screen_size().x*0.05, render.get_screen_size().y*0.5),
        size = vec2_t(render.get_screen_size().x*0.01, render.get_screen_size().y*0.1),
        speed = 12
    },

    --* 'ai'
    ai_paddle = {
        pos = vec2_t(render.get_screen_size().x - (render.get_screen_size().x*0.05 + render.get_screen_size().x*0.01), render.get_screen_size().y*0.5),
        size = vec2_t(render.get_screen_size().x*0.01, render.get_screen_size().y*0.1),
        speed = 15 --* ai paddle speed is a bit faster because
    },

    ball = {
        pos = vec2_t(render.get_screen_size().x*0.5, render.get_screen_size().y*0.5),
        size = vec2_t(render.get_screen_size().x*0.005, render.get_screen_size().x*0.005),
        speed = vec2_t(render.get_screen_size().x*0.005, render.get_screen_size().x*0.005)
    },

    last_frame = 0,
    is_paused = true,
    round_over = false,
    last_round_start = 0, --* store this to not pause game on round start
    winner = nil,

    fonts = {
        score = render.create_font('Arial', 24, 400, e_font_flags.ANTIALIAS),
        round_over = render.create_font('Arial', 26, 600, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
        winner = render.create_font('Arial', 24, 400, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
    },

    scores = {
        ai = 0,
        player = 0
    }
}

local handle_player_moving = function()
    if input.is_key_held(e_keys.KEY_UP) and data.player_paddle.pos.y > 0 then
        data.player_paddle.pos.y = data.player_paddle.pos.y - data.player_paddle.speed
    elseif input.is_key_held(e_keys.KEY_DOWN) and data.player_paddle.pos.y + data.player_paddle.size.y < render.get_screen_size().y then
        data.player_paddle.pos.y = data.player_paddle.pos.y + data.player_paddle.speed
    end
end

local handle_ball = function()
    data.ball.pos = data.ball.pos + data.ball.speed

    if data.ball.pos.y + data.ball.size.y > render.get_screen_size().y or data.ball.pos.y < 0 then
        data.ball.speed.y = -data.ball.speed.y
    end

    if (data.ball.speed.x > 0 and data.ball.pos.x > data.ai_paddle.pos.x and data.ball.pos.x < data.ai_paddle.pos.x + data.ai_paddle.size.x and data.ball.pos.y > data.ai_paddle.pos.y and data.ball.pos.y < data.ai_paddle.pos.y + data.ai_paddle.size.y) or (data.ball.speed.x < 0 and data.ball.pos.x < data.player_paddle.pos.x + data.player_paddle.size.x and data.ball.pos.x > data.player_paddle.pos.x and data.ball.pos.y > data.player_paddle.pos.y and data.ball.pos.y < data.player_paddle.pos.y + data.player_paddle.size.y) then
        data.ball.speed.x = -data.ball.speed.x
    end

    if data.ball.pos.x < 0 then
        data.round_over = true
        data.winner = 'AI'
        data.scores.ai = data.scores.ai + 1
    elseif data.ball.pos.x > render.get_screen_size().x then
        data.round_over = true
        data.winner = user.name
        data.scores.player = data.scores.player + 1
    end
end

local handle_ai_moving = function()
    if data.ball.speed.x > 0 then
        if data.ball.pos.y > data.ai_paddle.pos.y  then
            data.ai_paddle.pos.y = data.ai_paddle.pos.y + data.ai_paddle.speed
        elseif data.ball.pos.y < data.ai_paddle.pos.y + data.ai_paddle.size.y then
            data.ai_paddle.pos.y = data.ai_paddle.pos.y - data.ai_paddle.speed
        end

        if data.ai_paddle.pos.y + data.ai_paddle.size.y > render.get_screen_size().y then
            data.ai_paddle.pos.y = render.get_screen_size().y - data.ai_paddle.size.y
        end

        if data.ai_paddle.pos.y < 0 then
            data.ai_paddle.pos.y = 0
        end
    end
end

local handle_pause = function()
    if input.is_key_pressed(e_keys.KEY_SPACE) and not data.round_over then
        data.is_paused = not data.is_paused
    end
end

local render_scores = function()
    render.text(data.fonts.score, tostring(data.scores.player), vec2_t(render.get_screen_size().x * 0.01, render.get_screen_size().x * 0.01), color_t(255, 255, 255, 255))
    render.text(data.fonts.score, tostring(data.scores.ai), vec2_t(render.get_screen_size().x - render.get_screen_size().x * 0.01 - render.get_text_size(data.fonts.score, tostring(data.scores.ai)).x, render.get_screen_size().x * 0.01), color_t(255, 255, 255, 255))
end

local on_paint = function()
    --* every 16ms handle moving the player paddle
    if data.last_frame + 0.08 < global_vars.cur_time() and not data.round_over and not data.is_paused then
        handle_player_moving()
        handle_ai_moving()
        handle_ball()

    end

    handle_pause()
    render_scores()

    --* render player paddle
    render.rect_filled(data.player_paddle.pos, data.player_paddle.size, color_t(255, 255, 255, 255), 0)

    --* render 'ai' paddle
    render.rect_filled(data.ai_paddle.pos, data.ai_paddle.size, color_t(255, 255, 255, 255), 0)

    --* render our ball
    render.rect_filled(data.ball.pos, data.ball.size, color_t(255, 255, 255, 255), 5)

    --* render 'round over' or 'paused' text messages
    if data.is_paused and not data.game_over and data.last_round_start + 0.5 < global_vars.cur_time() then
        render.text(data.fonts.round_over, 'Paused', vec2_t(render.get_screen_size().x/2, render.get_screen_size().y/2), color_t(230, 230, 230, 255), true)
        render.text(data.fonts.winner, 'Press space to continue', vec2_t(render.get_screen_size().x/2, render.get_screen_size().y/2 + render.get_text_size(data.fonts.round_over, 'Paused').y), color_t(230, 230, 230, 255), true)
    end

    if data.round_over then
        render.text(data.fonts.round_over, 'Round over.', vec2_t(render.get_screen_size().x/2, render.get_screen_size().y/2), color_t(230, 230, 230, 255), true)
        render.text(data.fonts.winner, data.winner .. ' won. Press space to continue', vec2_t(render.get_screen_size().x/2, render.get_screen_size().y/2 + render.get_text_size(data.fonts.round_over, 'Game over.').y), color_t(230, 230, 230, 255), true)
    
        if input.is_key_pressed(e_keys.KEY_SPACE) then
            data.round_over = false
            data.ball.pos = vec2_t(render.get_screen_size().x*0.5, render.get_screen_size().y*0.5)
            data.last_round_start = global_vars.cur_time()
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)