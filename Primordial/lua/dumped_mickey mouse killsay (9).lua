local function death_event(event_info)
    local attacker = entity_list.get_player_from_userid(event_info.attacker)
    local victim = entity_list.get_player_from_userid(event_info.userid)
    if attacker == nil then return end
    if(attacker:get_name() ~= entity_list.get_local_player():get_name()) then
        return
    end
    local rdm = client.random_int(1, 7)
    engine.play_sound("mickey"..rdm..".wav", 10, 100) -- change the 100 to up/lower the pitch of classys voice :)
end

callbacks.add(e_callbacks.EVENT,death_event,"player_death")