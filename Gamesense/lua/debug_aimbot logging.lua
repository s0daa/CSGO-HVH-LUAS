local printf = function(...)
	utils.print_console('[fatality] ', render.color(255, 35, 35))
	utils.print_console(string.format(...)..'\n', render.color(217, 217, 217))
	utils.print_dev_console(string.format(...)..'\n')
end

local data = {}

local db = database.load('aimbot_data') or {}

local shots = (db.shots or 0)

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }

local time_to_ticks = function(t) return math.floor(0.5 + (t / global_vars.interval_per_tick)) end

local function aim_hit(e)
	printf('[%s] Hit %s\'s %s for %s(%s) (%s remaining) aimed=%s(%s) sp=%s body_yaw=%s bt=%s lc=%s tc=%s', e.id, e.name, hitgroup_names[e.server_hitgroup+1], e.server_damage, e.client_damage, 
	e.health, hitgroup_names[e.client_hitgroup+1], e.hit_chance, e.safe_point, e.body_yaw, e.backtrack, e.local_choke, e.target_choke)
end

local function aim_miss(e)
	printf('[%s] Missed %s\'s %s(%s)(%s) due to %s, sp=%s body_yaw=%s bt=%s lc=%s tc=%s', e.id, e.name, hitgroup_names[e.client_hitgroup+1], e.client_damage, e.hit_chance, e.result, e.safe_point,
	e.body_yaw, e.backtrack, e.local_choke, e.target_choke)
end

local function save_data()
	local database_info = 
	{
		shots = shots
	}
	database.save('aimbot_data', database_info)
end

function on_shot_registered(e)
	if e.manual then 
		return 
	end

	shots = shots + 1

	local g = e

	g.id = shots
	g.name = engine.get_player_info(e.target).name
	g.hit_chance = math.floor(e.hitchance+0.5)..'%'
	e.health = entities.get_entity(e.target):get_prop('m_iHealth')
	e.body_yaw = math.floor(entities.get_entity(e.target):get_prop('m_flPoseParameter', 11)*120-60)
	e.safe_point = not e.very_secure and not e.secure and false or true
	e.local_choke = info.fatality.lag_ticks
	e.target_choke = time_to_ticks(entities.get_entity(e.target):get_prop('m_flSimulationTime'))-e.tick

	data[shots] = g

	if e.result == 'hit' then 
		aim_hit(g)
	else 
		aim_miss(g)
	end
end

function on_player_death(e)
	if engine.get_player_for_user_id(e:get_int('userid')) == engine.get_local_player() then
		save_data()
	end
end

function on_shutdown()
	save_data()
end