local killsay1		= gui.checkbox("misc.chunxi.killsay", "scripts.elements_b", "Killsay")
local phrases =  "我将以【AW】形态入侵HVH并出击你~!"
 
function on_game_event(event)
    if killsay1:get_value() then
    local lp = engine.get_local_player()
    local userid = engine.get_player_for_user_id(event:get_int("userid"))
    local attacker = engine.get_player_for_user_id(event:get_int("attacker"))
    if event:get_name() ~= "player_death" then return end
    if userid == attacker or attacker ~= lp then return end
    engine.exec('say "' .. phrases .. '"')
    end
end