local function warmup_config()
    engine.execute_cmd("sv_cheats 1;Impulse 101;sv_airaccelerate 9999;bot_stop all;mp_roundtime_defuse 60;sv_infinite_ammo 1;mp_limitteams 0;mp_autoteambalance 0;mp_buytime 100000;mp_freezetime 1;mp_ignore_round_win_conditions 1;mp_respawn_on_death_ct 1; mp_respawn_on_death_t 1")
end

local function restartGame()
    engine.execute_cmd("mp_restartgame 1")
end

local function giveMoney()
    engine.execute_cmd("impulse 101")
end

local function kickBots()
    engine.execute_cmd("bot_kick")
end

local function add_bot_t()
    engine.execute_cmd("bot_add_t")
end

local function add_bot_ct()
    engine.execute_cmd("bot_add_ct")
end

local function giveSnipers()
    engine.execute_cmd("give weapon_ssg08;give weapon_scar20;give weapon_awp;give weapon_deagle")
end

local function giveGrenades()
    engine.execute_cmd("give weapon_hegrenade;give weapon_incgrenade;give weapon_smokegrenade;give weapon_flashbang")
end

local function placeBots()
    engine.execute_cmd("bot_place")
end

menu.add_button("Warmup helper", "Load warm up config", warmup_config)
menu.add_button("Warmup helper", "restart game", restartGame)
menu.add_button("Warmup helper", "give money", giveMoney)
menu.add_button("Warmup helper", "add bot ct", add_bot_ct)
menu.add_button("Warmup helper", "add bot t", add_bot_t)
menu.add_button("Warmup helper", "kick bots", kickBots)
menu.add_button("Warmup helper", "give snipers", giveSnipers)
menu.add_button("Warmup helper", "give grenades", giveGrenades)
menu.add_button("Warmup helper", "place bots", placeBots)


callbacks.add(e_callbacks.PAINT, print)