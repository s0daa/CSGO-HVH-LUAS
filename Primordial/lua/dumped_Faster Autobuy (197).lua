--[[
    icedancer for the primordial.dev community
    thanks to @jake
    17th april 2022

    to do list :
    - optimize (not sure if it's possible anymore)

    update log 17th april 2022 :
    - thanks @onion for suggesting I change the callback
]]

-- selection variable
local primary = menu.add_selection("Made by icedancer", "primary", {"AWP", "Scout"})

-- check if we exist
local function localPlayerCheck()
    local local_player = entity_list.get_local_player()
    return local_player
end

function on_event()
    if not localPlayerCheck then return end

    -- check if primary is set on the Scout
    if primary:get() == 2 then
        engine.execute_cmd("buy ssg08")

    -- check if primary is set on the awp
    else
        engine.execute_cmd("buy awp")
    end
end

-- enter buyzone event callback

callbacks.add(e_callbacks.EVENT, on_event, "round_start")