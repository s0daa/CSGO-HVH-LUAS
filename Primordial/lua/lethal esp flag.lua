local text = menu.add_text("lethal esp flag", "color")
local lethal_color = text:add_color_picker("lethal flag color")
lethal_color:set(color_t(255, 0, 0, 255))

local lethal_players = {}
local function get_lethal_players()
    local enemies = entity_list.get_players(true)
    local lp = entity_list.get_local_player()
    if not enemies or not lp then return end
    for k, v in pairs(enemies) do 
        if v:is_alive() then
            local e_idx = v:get_index()
            local e_pelvis = v:get_hitbox_pos(e_hitboxes.PELVIS)
            local e_trace = trace.bullet(vec3_t(e_pelvis.x - 1, e_pelvis.y - 1, e_pelvis.z - 1), e_pelvis, lp, v)

            lethal_players[e_idx] = e_trace.damage >= v:get_prop("m_iHealth")
        end
    end
end

local function on_player_esp(ctx)
    local e_idx = ctx.player:get_index()

    if lethal_players[e_idx] ~= nil and lethal_players[e_idx] == true then
        ctx:add_flag("LETHAL", lethal_color:get())
    end
end

callbacks.add(e_callbacks.PAINT, get_lethal_players)
callbacks.add(e_callbacks.PLAYER_ESP, on_player_esp)