local function setbotsnguns()
    engine.execute_cmd("god; bot_kick; mp_respawn_on_death_t 1; mp_respawn_on_death_ct 1; bot_add_ct; bot_add_ct; bot_add_ct; bot_stop 1; give weapon_molotov; give weapon_smokegrenade; give weapon_hegrenade") --edit this to add items after delayed execution
end

local function no_warmup()
    engine.execute_cmd("sv_cheats 1; mp_warmup_end; mp_roundtime_defuse 60; mp_restartgame 1; sv_infinite_ammo 1; mp_limitteams 16; mp_autoteambalance 0") -- edit this to add or remove something that instatly sets up
    client.delay_call(setbotsnguns, 2.0)
end

local function yes_warmup()
    engine.execute_cmd("sv_cheats 1; mp_do_warmup_offine 1; mp_warmup_pausetimer 1; mp_warmup_start; sv_infinite_ammo 1; mp_limitteams 16; mp_autoteambalance 0") -- edit this to add or remove something that instatly sets up
    client.delay_call(setbotsnguns, 2.0)
end

local warmup = menu.add_button('Setup', 'Warmup ( add enemy ct )', yes_warmup)
local nowarmup = menu.add_button('Setup', 'NO-Warmup (add enemy ct)', no_warmup)

local function on_paint()

end
callbacks.add(e_callbacks.PAINT, on_paint)