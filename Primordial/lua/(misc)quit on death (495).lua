function on_paint()
    local lp = entity_list.get_local_player() 
    if lp == nil then return end
        local function on_event(event)
            if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end
            engine.execute_cmd("quit")
        end
        callbacks.add(e_callbacks.EVENT, on_event, "player_death")
end

callbacks.add(e_callbacks.PAINT, on_paint)