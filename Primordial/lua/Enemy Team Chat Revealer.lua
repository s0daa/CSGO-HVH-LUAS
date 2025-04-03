local function on_event(event)
    if event.name ~= "player_say" then return end

    local entity = entity_list.get_player_from_userid(event.userid)

    if not entity:is_enemy() then return end

    local text = event.text
    local team = entity:get_prop("m_iTeamNum")
    local col = entity:get_prop("DT_CSPlayerResource", "m_iCompTeammateColor")
    local name = entity:get_name()
    
    local state = entity:is_alive() and "Live" or "Death"

    client.log(string.format("(%s) [%s] %s : %s", team, state, name, text))
end
callbacks.add(e_callbacks.EVENT, on_event)