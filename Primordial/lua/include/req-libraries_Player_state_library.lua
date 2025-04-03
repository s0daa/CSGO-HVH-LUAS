local table = {}

local primordial = {
    slowwalk = menu.find("misc","main","movement","slow walk")
}

function table.get_state()
    local local_player = entity_list.get_local_player()
    if not local_player then return end 
    local on_ground = local_player:has_player_flag(e_player_flags.ON_GROUND)
    local crouch = local_player:has_player_flag(e_player_flags.DUCKING)
    local jump = not local_player:has_player_flag(e_player_flags.ON_GROUND)
    local velocity = math.sqrt(math.pow(local_player:get_prop("m_vecVelocity[0]"), 2) + math.pow(local_player:get_prop("m_vecVelocity[1]"), 2))

    if jump and crouch then return 6 end
    if jump then return 5 end
    if crouch then return 4 end
    if velocity > 5 then
        if primordial.slowwalk[2]:get() then
            return 3
        end

        return 2
    end
    if on_ground and not move then return 1 end
end

return table