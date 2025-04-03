local function is_enemy(player)
    return entity.is_enemy(player)
end

local function valid_player(player)
    return not entity.is_dormant(player) and entity.get_prop(player, "m_iHealth") > 0 and is_enemy(player)
end

local function lerp(fraction, start, end_value)
    return start + fraction * (end_value - start)
end

local records = {}

local function on_create_move(cmd)
    local local_player = entity.get_local_player()
    if not local_player or entity.is_dormant(local_player) then
        return
    end

    for _, player in ipairs(entity.get_players(true)) do
        if valid_player(player) then
            local sim_time = entity.get_prop(player, "m_flSimulationTime")
            if records[player] == nil or sim_time > records[player].sim_time then
                records[player] = {
                    sim_time = sim_time,
                    origin = vector(entity.get_prop(player, "m_vecOrigin"))
                }
            end
        end
    end

    if bit.band(cmd.buttons, bit.lshift(1, 0)) ~= 0 then -- IN_ATTACK
        local best_target = nil
        local best_distance = math.huge

        for player, record in pairs(records) do
            if valid_player(player) then
                local time_delta = globals.curtime() - record.sim_time
                local latency = client.latency() * 2

                if time_delta <= latency then
                    local local_origin = vector(entity.get_prop(local_player, "m_vecOrigin"))
                    local delta_distance = (local_origin - record.origin):length()

                    if delta_distance < best_distance then
                        best_distance = delta_distance
                        best_target = player
                    end
                end
            end
        end

        if best_target then
            cmd.tick_count = math.floor(lerp((globals.curtime() - records[best_target].sim_time) / (client.latency() * 2), globals.tickcount() - client.latency(), globals.tickcount()))
        end
    end
end

client.set_event_callback("create_move", on_create_move)