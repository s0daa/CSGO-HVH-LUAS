-------------------------------------
--                                 --
--                                 --
--      rs on death lels           --
--        by tiramisu              --
--                                 --
--                                 --
-------------------------------------

-- REQUIRES/LOCALS --
local butts = require("primordial/menu buttons.122")
local noti = require("primordial/notification pop-up library.58")
---------------------

-- Buttons/Notifs --
butts:add_button("SILENT RS", function()
    engine.execute_cmd("say /rs")
end)
butts:add_button("LOUD RS", function()
    engine.execute_cmd("say !rs")
end)
butts:add_button("get level name", function()
    print("level name short", engine.get_level_name_short())
end)
butts:add_button("servers silent", function()
    engine.execute_cmd("say /servers")
end)
noti:add_notification("tiramisu", "loaded, have fun rsing", 10)
-------------------- 
local maincheck = menu.add_checkbox("multira.lua", "off/on")

function resetScore(event) --pass in the event data paremeters
    -- event wiki: https://wiki.alliedmods.net/Counter-Strike:_Global_Offensive_Events
    -- entity_list: https://docs.primordial.dev/api_functions/entity_list/?h=entity
    if maincheck:get() == true then
        local me = entity_list.get_local_player()
        local dead = entity_list.get_player_from_userid(event.userid) -- the event has a structure named userid, this is the user id of who died
        if me == dead then -- if you are the user who died
            engine.execute_cmd("say ".."!rs") --this types text into chat
        end -- end if me statement
    end -- end if switch = true

end -- end function

callbacks.add(e_callbacks.EVENT, resetScore, "player_death")