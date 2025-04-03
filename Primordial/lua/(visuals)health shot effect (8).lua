local effect_time = menu.add_slider("health shot effect", "[health shot] effect time", 0, 1, 0.1, 1) -- creating a slider for effect time

effect_time:set(1) --setting our slider to 1 by default

local function on_event(event) -- creating the event function 
    local curtime = global_vars.cur_time() -- grabbing current game time
    local lp = entity_list.get_local_player() -- grabbing our local player
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is you
    lp:set_prop("m_flHealthShotBoostExpirationTime", curtime + effect_time:get()) --triggering healhshot animation
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death") -- calling the function only when a player dies