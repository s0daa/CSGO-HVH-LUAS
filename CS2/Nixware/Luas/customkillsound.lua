
local custom_sound_command = "play sounds/ambient/animal/cat_03"


register_callback("player_death", function(event)
    
    if event:get_pawn("attacker") == entitylist.get_local_player_pawn() then
        
        engine.execute_client_cmd(custom_sound_command)
    end
end)