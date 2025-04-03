local enabled = menu.add_checkbox("defuse bot", "enable")
local close_defuse = menu.add_checkbox("defuse bot", "close defuse")

local defusing = false

local TEAM_CT = 3

local function vector_distance(src, dst)
    return math.sqrt((dst.x - src.x) ^ 2 + (dst.y - src.y) ^ 2 + (dst.z - src.z) ^ 2)
end

local function time_to_ticks(time)
    return math.floor(0.5 + (time / global_vars.interval_per_tick()))
end

local function are_all_enemies_dead()
    for _, enemy in pairs(entity_list.get_players(true)) do
        if enemy:is_alive() then
            return false
        end
    end

    return true
end

local function get_remaining_ticks_to_defuse(player, bomb)
    local defuse_time = 10

    if player:get_prop("m_bHasDefuser") == 1 then
        defuse_time = 5
    end

    local blow_time = bomb:get_prop("m_flC4Blow")

    return time_to_ticks(math.abs(global_vars.cur_time() - blow_time) - defuse_time)
end

local function run_defuse_bot(cmd)
    local local_player = entity_list.get_local_player()

    if not local_player or not local_player:is_alive() then
        return false
    end

    if local_player:get_prop("m_iTeamNum") ~= TEAM_CT then
        return false
    end

    local bomb = entity_list.get_entities_by_name("CPlantedC4")[1]

    if not bomb or bomb:get_prop("m_bBombDefused") == 1 then
        return false
    end

    if not are_all_enemies_dead() then
        return false
    end

    local player_origin = local_player:get_render_origin()
    local bomb_origin = bomb:get_render_origin()

    if vector_distance(player_origin, bomb_origin) > 75 then
        return false
    end

    local ticks_to_defuse = get_remaining_ticks_to_defuse(local_player, bomb)

    -- i have no idea why it only works with 2 ticks to spare when it should work with 0 but i have tested it like 50 times and it only works this way.
    if (close_defuse:get() and ticks_to_defuse == 2) or (not close_defuse:get() and ticks_to_defuse > 2) or defusing then
        cmd:add_button(e_cmd_buttons.USE)
        cmd.viewangles = angle_t(89, 0, 0)
        return true
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    if enabled:get() then
        defusing = run_defuse_bot(cmd)
    else
        defusing = false
    end
end)