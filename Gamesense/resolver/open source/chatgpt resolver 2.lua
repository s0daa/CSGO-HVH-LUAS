-- Smart Resolver ULTIMATE v2 - by ChatGPT
-- 🔥 Overhauled version without dynamic combobox (safe for Skeet)

local enable_resolver = ui.new_checkbox("RAGE", "Other", "Smart Resolver ULTIMATE")
local override_key = ui.new_hotkey("RAGE", "Other", "Manual Resolver Switch")

-- Settings for all enemies
local enable_per_enemy = ui.new_checkbox("MISC", "Settings", "Enable Smart Resolver for All Enemies")
local brute_style = ui.new_combobox("MISC", "Settings", "Brute Style", "Safe", "Balanced", "Aggressive")
local critical_threshold = ui.new_slider("MISC", "Settings", "Misses to Critical", 1, 6, 3)

local function normalize_yaw(yaw)
    yaw = yaw % 360
    if yaw > 180 then yaw = yaw - 360 end
    return yaw
end

local player_data, switch_side = {}, false

local function get_velocity(ent)
    local vx, vy = entity.get_prop(ent, "m_vecVelocity") or 0, 0
    return math.sqrt(vx * vx + vy * vy)
end

local function resolve_target(ent)
    if not entity.is_enemy(ent) or not entity.is_alive(ent) then return end
    if not ui.get(enable_resolver) or not ui.get(enable_per_enemy) then return end

    if not player_data[ent] then
        player_data[ent] = {
            missed = 0, brute_step = 1, last_lby = 0, lby_update = globals.curtime(),
            critical = false, state = "", last_resolved = 0
        }
    end

    local data = player_data[ent]
    local lby = entity.get_prop(ent, "m_flLowerBodyYawTarget") or 0
    local yaw = entity.get_prop(ent, "m_angEyeAngles[1]") or 0
    local flags = entity.get_prop(ent, "m_fFlags") or 0
    local vel = get_velocity(ent)
    local is_moving = vel > 20
    local is_air = bit.band(flags, 1) == 0
    local is_afk = vel < 2 and globals.curtime() - data.lby_update > 5

    local resolved_yaw = yaw
    local state = ""
    local threshold = ui.get(critical_threshold)
    local style = ui.get(brute_style)
    local brute_pool = {
        Safe = {15, -15, 25, -25},
        Balanced = {0, 30, -30, 60, -60},
        Aggressive = {0, 45, -45, 90, -90, 120, -120}
    }

    if lby ~= data.last_lby then
        data.last_lby = lby
        data.lby_update = globals.curtime()
    end

    if is_afk then
        resolved_yaw = lby
        state = "AFK"
    elseif data.critical or (data.missed >= threshold and not is_moving and not is_air) then
        local offset = brute_pool[style][(data.brute_step % #brute_pool[style]) + 1]
        resolved_yaw = lby + offset
        state = "CRITICAL+" .. offset
    elseif is_moving then
        resolved_yaw = lby
        state = "MOVING"
    elseif is_air then
        local offset = ({25, -25, 15})[(data.missed % 3) + 1]
        resolved_yaw = lby + offset
        state = "AIR+" .. offset
    else
        local offset = brute_pool[style][(data.brute_step % #brute_pool[style]) + 1]
        resolved_yaw = lby + offset
        state = "STAND+" .. offset
    end

    if not is_moving and (globals.curtime() - data.lby_update > 1.1) then
        resolved_yaw = lby
        state = state .. " | LBY-PRED"
    end

    if ui.get(override_key) or switch_side then
        resolved_yaw = resolved_yaw + 180
        state = state .. " | SWITCH"
    end

    resolved_yaw = normalize_yaw(resolved_yaw)
    data.last_resolved = resolved_yaw
    data.state = state

    entity.set_prop(ent, "m_angEyeAngles[1]", resolved_yaw)
end

client.set_event_callback("create_move", function()
    if not ui.get(enable_resolver) then return end
    for _, ent in ipairs(entity.get_players(true)) do
        resolve_target(ent)
    end
end)

client.set_event_callback("aim_miss", function(e)
    local target = e.target
    if target and entity.is_enemy(target) then
        local d = player_data[target]
        if d then
            d.missed = d.missed + 1
            d.brute_step = d.brute_step + 1
            if d.missed >= ui.get(critical_threshold) then
                d.critical = true
                client.color_log(255, 80, 80, string.format("[RESOLVER] %s entered CRITICAL MODE\n", entity.get_player_name(target)))
            end
        end
    end
end)

client.set_event_callback("player_hurt", function(e)
    local attacker = client.userid_to_entindex(e.attacker)
    local victim = client.userid_to_entindex(e.userid)
    if attacker == entity.get_local_player() and entity.is_enemy(victim) then
        local d = player_data[victim]
        if d then
            client.color_log(120, 255, 120, string.format("[RESOLVER] Hit %s, resetting state.\n", entity.get_player_name(victim)))
            d.missed = 0
            d.brute_step = 1
            d.critical = false
            switch_side = not switch_side
        end
    end
end)

client.set_event_callback("player_death", function(e)
    local victim = client.userid_to_entindex(e.userid)
    player_data[victim] = nil
end)

-- Safe ESP Resolver Flags
client.set_event_callback("paint", function()
    if not ui.get(enable_resolver) then return end
    for idx, data in pairs(player_data) do
        if entity.is_alive(idx) and entity.is_enemy(idx) then
            local pos = {entity.hitbox_position(idx, 0)}
            if pos[1] and pos[2] and pos[3] then
                local sx, sy = renderer.world_to_screen(pos[1], pos[2], pos[3] + 72)
                if sx and sy then
                    renderer.text(sx, sy - 10, 255, 255, 255, 255, "c", 0, "[" .. data.state .. "]")
                end
            end
        end
    end
end)

client.color_log(100, 200, 255, "✅ Smart Resolver ULTIMATE v2 Loaded — safe mode without dynamic combobox\n")
