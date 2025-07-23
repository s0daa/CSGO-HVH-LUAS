-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

-- Dodanie do istniejącej zakładki "LUA"
local enable_resolver = ui.new_checkbox("LUA", "B", "Enable Resolver")
local enable_jitter = ui.new_checkbox("LUA", "B", "Enable Jitter Resolver")
local enable_defensive = ui.new_checkbox("LUA", "B", "Enable Defensive AA")
local enable_safe_head = ui.new_checkbox("LUA", "B", "Enable Safe Head Resolver")
local enable_crouch_resolver = ui.new_checkbox("LUA", "B", "Enable Crouch Resolver")
local enable_force_body_aim = ui.new_checkbox("LUA", "B", "Enable Force Body Aim")

-- Slider do regulacji kąta bruteforce
local brute_force_angle = ui.new_slider("LUA", "B", "Brute Force Angle", 30, 60, 58)

local last_shot_time = {}
local player_yaw = {}
local jitter_detected = {}

-- Funkcja do wykrywania jittera
local function detect_jitter(player)
    if not ui.get(enable_jitter) then return end

    local current_yaw = entity.get_prop(player, "m_angEyeAngles[1]")
    local last_yaw = player_yaw[player] or 0
    local delta = math.abs(current_yaw - last_yaw)

    -- Jeśli zmiana kąta > 35 stopni, wykrywamy jitter
    if delta > 35 then
        jitter_detected[player] = true
    else
        jitter_detected[player] = false
    end

    player_yaw[player] = current_yaw
end

-- Funkcja do pobierania pozycji głowy (hitbox 0 = head)
local function get_head_position(player)
    local head_position = { entity.hitbox_position(player, 0) }
    return head_position[1], head_position[2], head_position[3]
end

-- Event do przechwytywania strzałów
client.set_event_callback("aim_fire", function(event)
    if not ui.get(enable_resolver) then return end

    local target = event.target
    if not target then return end

    last_shot_time[target] = globals.curtime()
end)

-- Event do przechwytywania obrażeń
client.set_event_callback("player_hurt", function(event)
    if not ui.get(enable_resolver) then return end

    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)

    if attacker ~= entity.get_local_player() then return end

    -- Aktualizacja yaw po trafieniu
    player_yaw[victim] = entity.get_prop(victim, "m_angEyeAngles[1]")
end)

-- Resolver
client.set_event_callback("paint", function()
    if not ui.get(enable_resolver) then return end

    local enemies = entity.get_players(true)

    for i = 1, #enemies do
        local player = enemies[i]
        if not entity.is_alive(player) then goto continue end

        local current_time = globals.curtime()
        local health = entity.get_prop(player, "m_iHealth")
        local vx = entity.get_prop(player, "m_vecVelocity[0]")
        local vy = entity.get_prop(player, "m_vecVelocity[1]")
        local velocity = math.sqrt(vx * vx + vy * vy)

        -- Wykrywanie jittera
        detect_jitter(player)

        -- Ustalanie kąta
        local yaw = player_yaw[player] or 0

        if last_shot_time[player] and current_time - last_shot_time[player] < 1 then
            if jitter_detected[player] and ui.get(enable_jitter) then
                yaw = yaw + (math.random(10, 15) * (math.random(0, 1) == 1 and 1 or -1))
            else
                yaw = yaw + ui.get(brute_force_angle)
            end
        else
            if ui.get(enable_defensive) and velocity > 5 then
                yaw = yaw + (velocity > 100 and 35 or 20)
            else
                yaw = yaw + (math.random(45, 58) * (math.random(0, 1) == 1 and 1 or -1))
            end
        end

        -- 🔥 Crouch Resolver 🔥
        if ui.get(enable_crouch_resolver) then
            local flags = entity.get_prop(player, "m_fFlags")
            if flags and bit.band(flags, 4) ~= 0 then
                -- Gracz kuca -> dostosuj yaw do crouch exploit
                yaw = yaw + (math.random(5, 15) * (math.random(0, 1) == 1 and 1 or -1))
            end
        end

        -- 🔥 Safe Head Resolver 🔥
        if ui.get(enable_safe_head) then
            local head_x, head_y, head_z = get_head_position(player)
            if head_x and head_y and head_z then
                local eye_yaw = entity.get_prop(player, "m_angEyeAngles[1]")

                if math.abs(eye_yaw - head_y) > 15 then
                    yaw = head_y + (math.random(10, 15) * (math.random(0, 1) == 1 and 1 or -1))
                end
            end
        end

        -- 🔥 Force Body Aim 🔥
        if ui.get(enable_force_body_aim) and health < 90 then
            -- Zmusza do celowania w ciało zamiast w głowę, korzystając z wbudowanego force body aim w cheacie
            local force_bodyaim = entity.get_prop(player, "m_flForceBodyAim")
            if force_bodyaim ~= nil then
                entity.set_prop(player, "m_flForceBodyAim", 1) -- Włączamy celowanie w ciało
            end
        else
            local force_bodyaim = entity.get_prop(player, "m_flForceBodyAim")
            if force_bodyaim ~= nil then
                entity.set_prop(player, "m_flForceBodyAim", 0) -- Wyłączamy celowanie w ciało
            end
        end

        -- Ustawianie kąta
        entity.set_prop(player, "m_angEyeAngles[1]", yaw)

        -- Debug info (opcjonalne)
        renderer.text(10, 10 + i * 15, 255, 255, 255, 255, "-", 0,
            "Player: " .. entity.get_player_name(player) ..
            " | Jitter: " .. tostring(jitter_detected[player]) ..
            " | Yaw: " .. tostring(yaw) ..
            " | Crouch: " .. tostring(bit.band(entity.get_prop(player, "m_fFlags") or 0, 4) ~= 0) ..
            " | Health: " .. tostring(health))

        ::continue::
    end
end)
