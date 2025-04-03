callbacks.add(e_callbacks.PAINT, function() end)

local stats = {
    "Follow Players Movement", 
    "All Freeze",
    "All Crouching", 
    "Not firing", 
    "Ignore Players"
}

local function practice()
    engine.execute_cmd("sv_cheats 1; mp_limitteams 0; mp_autoteambalance 0; mp_roundtime 60; mp_roundtime_defuse 60; mp_maxmoney 60000; mp_startmoney 60000; mp_freezetime 0; mp_buytime 9999; mp_buy_anywhere 1; sv_infinite_ammo 1; ammo_grenade_limit_total 5; bot_kick; bot_stop 1; mp_warmup_end; mp_restartgame 1; mp_respawn_on_death_ct 1; mp_respawn_on_death_t 1; sv_airaccelerate 500;")
end

local function setup()
    engine.execute_cmd("sv_cheats 1;Impulse 101;sv_airaccelerate 9999;bot_stop all;mp_roundtime_defuse 60;sv_infinite_ammo 1;mp_limitteams 0;mp_autoteambalance 0;mp_buytime 100000;mp_freezetime 1;mp_ignore_round_win_conditions 1;")
end

local function setup2()
    engine.execute_cmd("mp_restartgame 1")
end

local function setup3()
    engine.execute_cmd("impulse 101")
end
local function setup4()
    engine.execute_cmd("bot_add;bot_add;bot_add;bot_add;bot_add;bot_add;bot_add;bot_add;bot_add;")
end
local function setup8()
    engine.execute_cmd("bot_kick")
end
local function setup7()
    engine.execute_cmd("give weapon_ssg08;give weapon_scar20;give weapon_awp;give weapon_deagle")
end

local function setup9()
    engine.execute_cmd("give weapon_hegrenade;give weapon_incgrenade;give weapon_smokegrenade;give weapon_flashbang")
end

local function re_active()
    engine.execute_cmd("mp_respawn_on_death_ct 0;mp_respawn_on_death_t 0")
end

local function setup10()
    engine.execute_cmd("mp_respawn_on_death_ct 1;mp_respawn_on_death_t 1")
    client.delay_call(re_active, 5.0)
end


local function setup11()
    engine.execute_cmd("bot_place")
end

local function setup14()
    engine.execute_cmd("bot_add_t")
end

local function setup15()
    engine.execute_cmd("bot_add_ct")
end

local prac = menu.add_button("A", "Exec Practice CFG", practice)
local warmup = menu.add_button("A", "Load Warmup Config", setup)
local warmup2 = menu.add_button("A", "Restart Game", setup2)
local warmup3 = menu.add_button("A", "Gain Money", setup3)
local warmup6 = menu.add_button("A", "Kick All bots", setup8)
local warmup4 = menu.add_button("A", "Fill Server with bots", setup4)
local warmup8 = menu.add_button("A", "Give All Sniper Rifles", setup7)
local warmup9 = menu.add_button("A", "Give All nades", setup9)
local warmup10 = menu.add_button("A", "Respawn All bots", setup10)
local warmup11 = menu.add_button("A", "Place a bot", setup11)
local bot_holding = menu.add_multi_selection("A", "Bot Status", stats)
local function setup13()
    if bot_holding:get(1) then
        engine.execute_cmd("bot_stop 1;")
    else
        engine.execute_cmd("bot_stop 0;")
    end

    if bot_holding:get(2) then
        engine.execute_cmd("bot_crouch 1;")
    else
        engine.execute_cmd("bot_crouch 0;")
    end

    if bot_holding:get(3) then
        engine.execute_cmd("bot_mimic 1;")
    else
        engine.execute_cmd("bot_mimic 0;")
    end

    if bot_holding:get(4) then
        engine.execute_cmd("bot_dont_shoot 1;")
    else
        engine.execute_cmd("bot_dont_shoot 0;")
    end

    if bot_holding:get(4) then
        engine.execute_cmd("bot_ignore_players 1 1;")
    else
        engine.execute_cmd("bot_ignore_players 0 0;")
    end
end
local warmup12 = menu.add_button("A", "Update Bot Status", setup13)

local add_t = menu.add_button("B", "Add bot to T", setup14)
local add_ct = menu.add_button("B", "Add bot to CT", setup15)