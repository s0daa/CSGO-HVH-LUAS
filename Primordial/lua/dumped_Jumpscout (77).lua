function ent_speed_2d(entity)
    local velocity_x = entity:get_prop("m_vecVelocity[0]")
    local velocity_y = entity:get_prop("m_vecVelocity[1]")
    return math.sqrt((velocity_x * velocity_x) + (velocity_y * velocity_y))
end
local function Local_GetProp(prop_name, ...)
    local player = entity_list.get_local_player()
    return player:get_prop(prop_name, ...)
end
autostrafe = menu.find("misc","main","movement","autostrafer")
local function on_paint()
    if ent_speed_2d(entity_list.get_local_player()) > 10 and (Local_GetProp("m_fFlags") == 256 or Local_GetProp("m_fFlags") == 262) then
        autostrafe:set(0,true)
        autostrafe:set(1,true)
    else
        autostrafe:set(0,false)
        autostrafe:set(1,false)
    end
end
callbacks.add(e_callbacks.PAINT, on_paint)