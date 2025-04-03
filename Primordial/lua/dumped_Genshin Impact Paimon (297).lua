local frames = 0
local animTime = global_vars.real_time()
local hitboxes = {
    [0] = "generic",
    [1] = "head",
    [2] = "chest",
    [3] = "stomach",
    [4] = "left arm",
    [5] = "right arm",
    [6] = "left leg",
    [7] = "right leg",
    [10] = "gear",
}

local reasons = {
    [0] = "Hit",
    [1] = "resolver",
    [2] = "spread",
    [3] = "occlusion",
    [4] = "prediction error",
}

local console = render.create_font("Trebuchet MS", 15, 600)
local message = nil
local show = false
local time = global_vars.real_time()


local paimon_enable = menu.add_checkbox("scripts", "enable", false)
local paimon_logs = menu.add_checkbox("scripts", "hit logs", false)
local paimon_logs_timer = menu.add_slider("scripts", "hit logs timer", 3.0, 12.0)



local p000 = render.load_image("./csgo/paimon/paimon_000.png")
local p001 = render.load_image("./csgo/paimon/paimon_001.png")
local p002 = render.load_image("./csgo/paimon/paimon_002.png")
local p003 = render.load_image("./csgo/paimon/paimon_003.png")
local p004 = render.load_image("./csgo/paimon/paimon_004.png")
local p005 = render.load_image("./csgo/paimon/paimon_005.png")
local p006 = render.load_image("./csgo/paimon/paimon_006.png")
local p007 = render.load_image("./csgo/paimon/paimon_007.png")
local p008 = render.load_image("./csgo/paimon/paimon_008.png")
local p009 = render.load_image("./csgo/paimon/paimon_009.png")
local p010 = render.load_image("./csgo/paimon/paimon_0010.png")
local p011 = render.load_image("./csgo/paimon/paimon_0011.png")
local p012 = render.load_image("./csgo/paimon/paimon_0012.png")
local p013 = render.load_image("./csgo/paimon/paimon_0013.png")
local p014 = render.load_image("./csgo/paimon/paimon_0014.png")
local p015 = render.load_image("./csgo/paimon/paimon_0015.png")
local p016 = render.load_image("./csgo/paimon/paimon_0016.png")
local p017 = render.load_image("./csgo/paimon/paimon_0017.png")
local p018 = render.load_image("./csgo/paimon/paimon_0018.png")
local p019 = render.load_image("./csgo/paimon/paimon_0019.png")
local p020 = render.load_image("./csgo/paimon/paimon_0020.png")
local p021 = render.load_image("./csgo/paimon/paimon_0021.png")
local p022 = render.load_image("./csgo/paimon/paimon_0022.png")
local p023 = render.load_image("./csgo/paimon/paimon_0023.png")
local p024 = render.load_image("./csgo/paimon/paimon_0024.png")
local p025 = render.load_image("./csgo/paimon/paimon_0025.png")
local p026 = render.load_image("./csgo/paimon/paimon_0026.png")
local p027 = render.load_image("./csgo/paimon/paimon_0027.png")
local p028 = render.load_image("./csgo/paimon/paimon_0028.png")
local p029 = render.load_image("./csgo/paimon/paimon_0029.png")
local p030 = render.load_image("./csgo/paimon/paimon_0030.png")
local p031 = render.load_image("./csgo/paimon/paimon_0031.png")
local p032 = render.load_image("./csgo/paimon/paimon_0032.png")
local p033 = render.load_image("./csgo/paimon/paimon_0033.png")
local p034 = render.load_image("./csgo/paimon/paimon_0034.png")
local p035 = render.load_image("./csgo/paimon/paimon_0035.png")
local p036 = render.load_image("./csgo/paimon/paimon_0036.png")
local p037 = render.load_image("./csgo/paimon/paimon_0037.png")
local p038 = render.load_image("./csgo/paimon/paimon_0038.png")
local p039 = render.load_image("./csgo/paimon/paimon_0039.png")
local p040 = render.load_image("./csgo/paimon/paimon_0040.png")
local p041 = render.load_image("./csgo/paimon/paimon_0041.png")
local p042 = render.load_image("./csgo/paimon/paimon_0042.png")
local p043 = render.load_image("./csgo/paimon/paimon_0043.png")
local p044 = render.load_image("./csgo/paimon/paimon_0044.png")
local p045 = render.load_image("./csgo/paimon/paimon_0045.png")
local p046 = render.load_image("./csgo/paimon/paimon_0046.png")
local p047 = render.load_image("./csgo/paimon/paimon_0047.png")
local p048 = render.load_image("./csgo/paimon/paimon_0048.png")
local p049 = render.load_image("./csgo/paimon/paimon_0049.png")
local p050 = render.load_image("./csgo/paimon/paimon_0050.png")
local p051 = render.load_image("./csgo/paimon/paimon_0051.png")
local p052 = render.load_image("./csgo/paimon/paimon_0052.png")

function renderPaimon(pos, size)
    if frames == 0 then
        render.texture(p000.id, pos, size)
        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 1
        end
    end

    if frames == 1 then
        render.texture(p001.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 2
        end
    end

    if frames == 2 then
        render.texture(p002.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 3
        end
    end

    if frames == 3 then
        render.texture(p003.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 4
        end
    end

    if frames == 4 then
        render.texture(p004.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 5
        end
    end

    if frames == 5 then
        render.texture(p005.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 6
        end
    end

    if frames == 6 then
        render.texture(p006.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 7
        end
    end

    if frames == 7 then
        render.texture(p007.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 8
        end
    end

    if frames == 8 then
        render.texture(p008.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 9
        end
    end

    if frames == 9 then
        render.texture(p009.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 10
        end
    end

    if frames == 10 then
        render.texture(p010.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 11
        end
    end

    if frames == 11 then
        render.texture(p011.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 12
        end
    end

    if frames == 12 then
        render.texture(p012.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 13
        end
    end

    if frames == 13 then
        render.texture(p013.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 14
        end
    end

    if frames == 14 then
        render.texture(p014.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 15
        end
    end

    if frames == 15 then
        render.texture(p015.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 16
        end
    end

    if frames == 16 then
        render.texture(p016.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 17
        end
    end

    if frames == 17 then
        render.texture(p017.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 18
        end
    end

    if frames == 18 then
        render.texture(p018.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 19
        end
    end

    if frames == 19 then
        render.texture(p019.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 20
        end
    end

    if frames == 20 then
        render.texture(p020.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 21
        end
    end

    if frames == 21 then
        render.texture(p021.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 22
        end
    end

    if frames == 22 then
        render.texture(p022.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 23
        end
    end

    if frames == 23 then
        render.texture(p023.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 24
        end
    end

    if frames == 24 then
        render.texture(p024.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 25
        end
    end

    if frames == 25 then
        render.texture(p025.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 26
        end
    end

    if frames == 26 then
        render.texture(p026.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 27
        end
    end

    if frames == 27 then
        render.texture(p027.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 28
        end
    end

    if frames == 28 then
        render.texture(p028.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 29
        end
    end

    if frames == 29 then
        render.texture(p029.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 30
        end
    end

    if frames == 30 then
        render.texture(p030.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 31
        end
    end

    if frames == 31 then
        render.texture(p031.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 32
        end
    end

    if frames == 32 then
        render.texture(p032.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 33
        end
    end

    if frames == 33 then
        render.texture(p033.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 34
        end
    end

    if frames == 34 then
        render.texture(p034.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 35
        end
    end

    if frames == 35 then
        render.texture(p035.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 36
        end
    end

    if frames == 36 then
        render.texture(p036.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 37
        end
    end

    if frames == 37 then
        render.texture(p037.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 38
        end
    end

    if frames == 38 then
        render.texture(p038.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 39
        end
    end

    if frames == 39 then
        render.texture(p039.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 40
        end
    end

    if frames == 40 then
        render.texture(p040.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 41
        end
    end

    if frames == 41 then
        render.texture(p041.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 42
        end
    end

    if frames == 42 then
        render.texture(p042.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 43
        end
    end

    if frames == 43 then
        render.texture(p043.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 44
        end
    end

    if frames == 44 then
        render.texture(p044.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 45
        end
    end

    if frames == 45 then
        render.texture(p045.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 46
        end
    end

    if frames == 46 then
        render.texture(p046.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 47
        end
    end

    if frames == 47 then
        render.texture(p047.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 48
        end
    end

    if frames == 48 then
        render.texture(p048.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 49
        end
    end

    if frames == 49 then
        render.texture(p049.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 50
        end
    end

    if frames == 50 then
        render.texture(p050.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 51
        end
    end

    if frames == 51 then
        render.texture(p051.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 52
        end
    end

    if frames == 52 then
        render.texture(p052.id, pos, size)

        if global_vars.real_time() > animTime + 0.030 then
            animTime = global_vars.real_time();

            frames = 0
        end
    end
end

function messageBox(pos)
    if show then
        if message == nil then
            return
        else
            local size = render.get_text_size(console, message)
            local tempTime = global_vars.real_time()

            render.circle_filled(pos, 9, color_t.new(255, 255, 255, 255))
            render.circle(vec2_t.new(pos.x - 1, pos.y), 9, color_t.new(0, 0, 0, 255))
            render.circle_filled(vec2_t.new(pos.x + size.x, pos.y), 9, color_t.new(255, 255, 255, 255))
            render.circle(vec2_t.new(pos.x + 1 + size.x, pos.y), 9, color_t.new(0, 0, 0, 255))


            render.rect(vec2_t.new(pos.x, pos.y - 9), vec2_t.new(size.x / 2 + 65, 9 + 10), color_t.new(0, 0, 0, 255))

            render.polyline({vec2_t.new(pos.x + size.x / 2 + 64, pos.y + 9), vec2_t.new(pos.x + size.x / 2 + 64, pos.y + 9 + 11), vec2_t.new(pos.x + size.x / 2 + 73, pos.y + 9)}, color_t.new(0, 0, 0, 255))
            render.polygon({vec2_t.new(pos.x + size.x / 2 + 65, pos.y + 8), vec2_t.new(pos.x + size.x / 2 + 65, pos.y + 9 + 10), vec2_t.new(pos.x + size.x / 2 + 73, pos.y + 8)}, color_t.new(255, 255, 255, 255))

            render.rect(vec2_t.new(pos.x + size.x / 2 + 73, pos.y - 9), vec2_t.new(size.x / 2 - 73, 9 + 10), color_t.new(0, 0, 0, 255))


            render.rect(vec2_t.new(pos.x + size.x / 2 + 65, pos.y - 9), vec2_t.new(size.x / 2 - 73, 1), color_t.new(0, 0, 0, 255))


            render.rect_filled(vec2_t.new(pos.x, pos.y - 8), vec2_t.new(size.x, 8 + 9), color_t.new(255, 255, 255, 255))


            render.text(console, message, vec2_t.new(pos.x, pos.y - 7), color_t.new(0, 0, 0, 255))

            if tempTime >= time + paimon_logs_timer:get() then
                    show = false
            end
        end
    else
        time = global_vars.real_time()
    end
end

callbacks.add(e_callbacks.PAINT, function()
    local screen = render.get_screen_size()
    local in_game = engine.is_in_game()

    if paimon_enable:get() == true then
        local w = nil
        local h = nil

        local tp = menu.find("visuals", "other", "thirdperson", "enable")[2]
        local tpDistance = menu.find("visuals", "other", "thirdperson", "distance")

        if w == nil then
            if tpDistance:get() >= 200 then
                if tp == false then
                    w = math.floor(397 / 3)
                else
                    w = math.floor(397 / 4)
                end
            else
                w = math.floor(397 / 3)
            end
        end

        if h == nil then
            if tpDistance:get() >= 200 then
                if tp == false then
                    h = math.floor(465 / 3)
                else
                    h = math.floor(465 / 4)
                end
            else
                h = math.floor(465 / 3)
            end
        end

        if not in_game then
            return
        end

        if tp:get() == true then
            renderPaimon(vec2_t.new(screen.x / 2 - w / 2 + 400 - tpDistance:get(), screen.y / 2 - h / 2), vec2_t.new(w, h))
        else
            renderPaimon(vec2_t.new(screen.x / 2 - w / 2, screen.y - h / 2 - 190), vec2_t.new(w, h))
        end

        if paimon_logs:get() == true then
            if tp:get() == true then
                messageBox(vec2_t.new(screen.x / 2 - w / 2 + 230 - tpDistance:get(), screen.y / 2 - h / 2 - 15))
            else
                messageBox(vec2_t.new(screen.x / 2 - w / 2 - 150, screen.y - h / 2 - 15 - 190))
            end
        end
    end
end)

callbacks.add(e_callbacks.AIMBOT_SHOOT, function(shot)
    local target = shot.player
    local damage = shot.damage
    local hitgroup = hitboxes[shot.hitgroup]
    local hitchance = shot.hitchance

    message = string.format("You shot at %s for %s damage! He has %s HP left! You shot his %s with a Hit Chance of %s!", target:get_name(), damage, target:get_prop("m_iHealth"), hitgroup, hitchance)
    show = true
end)

callbacks.add(e_callbacks.AIMBOT_MISS, function(miss)
    local target = miss.player
    local wanted_hitgroup = hitboxes[miss.aim_hitgroup]
    local hitchance = miss.aim_hitchance
    local reason = miss.reason_string

    message = string.format("You missed shot to %s due to %s! He has %s HP left! You tried hit his %s with a Hit Chance of %s!", target:get_name(), reason, target:get_prop("m_iHealth"), wanted_hitgroup, hitchance)
    show = true
end)