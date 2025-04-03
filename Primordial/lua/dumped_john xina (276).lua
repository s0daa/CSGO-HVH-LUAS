local jx = render.load_image("primordial\\scripts\\john_xina\\johnxina.jpg")
local shotted = false
local function on_paint()
    if engine.is_in_game() then
        if shotted == true then
            render.texture(jx.id, vec2_t(600, 180), jx.size)
            engine.play_sound("bing-chilling.wav", 100, 100)
            local function shotfalseagain()
                shotted = false
            end
            client.delay_call(shotfalseagain, 0.5)
        end
    end
end
local function on_shot(shot)
    shotted = true

end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shot)