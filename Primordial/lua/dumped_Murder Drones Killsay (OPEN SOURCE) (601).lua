local killsays = {
    "Bite ME!",
    "Hi, I'm Serial Designation N! You must be new to our Squad.",
    "AHHH!!! MY MIND'S IN A WEIRD PLACE! DON'T READ INTO THIS!",
    "I love doing anything.",
    "Sweet uh, i'm open to new things I guess.",
    "Ah, biscuits! I'm sorry.",
    "I was given a job and I always want to try my best.",
    "Oh. Oh! You know I left an extremely dangerous weapon!",
    "I'm sorry. I really enjoyed our time together, but I can't have you shooting me with that thing!",
    "Have fun repressing this!",
    "Huh? Oh, uh. N, i'm an angsty rebellious Disassembly Drone now.",
    "Bite ME!!",
    "81t3 M3!!!",
    "WaNnA dO aN aUtOpSy To FiNd OuT??",
    "Hi, The name is N. Tragedy is my Friend!"
    -- add as many as you want
}

local old_rand = 0
local function on_event(event)
    local lp = entity_list.get_local_player()
    ::generate::
    local rand = killsays[math.random(#killsays)]
    if (rand == old_rand) then
        goto generate
    end
    local kill_cmd = 'say ' .. rand
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd)
    old_rand = rand
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")