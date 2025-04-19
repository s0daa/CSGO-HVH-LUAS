local globals_frametime = globals.frametime
local globals_tickinterval = globals.tickinterval
local entity_is_enemy = entity.is_enemy
local entity_get_prop = entity.get_prop
local entity_is_dormant = entity.is_dormant
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local entity_get_local_player = entity.get_local_player
local entity_get_player_resource = entity.get_player_resource
local table_insert = table.insert
local math_floor = math.floor

local master_switch = ui.new_checkbox('RAGE', 'Aimbot', 'Log aimbot shots')
local master_switch_hitboxes = ui.new_checkbox('RAGE', 'Aimbot', 'Aimbot shots hitboxes')
local hitboxes_color = ui.new_color_picker('RAGE', 'Aimbot', 'Shots hitboxes color', 255, 0, 0, 65)
local hitboxes_time = ui.new_slider('RAGE', 'Aimbot', '\n Shots hitboxes time', 5, 200, 20, true, 's', 0.1)
local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')

local time_to_ticks = function(t) return math_floor(0.5 + (t / globals_tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local g_aimbot_data = { }
local g_sim_ticks, g_net_data = { }, { }

local cl_data = {
    tick_shifted = false,
    tick_base = 0
}

local multicolor_console = function(...)
    local texts = {...}
    for i=1, #texts do
        local text = texts[i]
        client.color_log(text[1], text[2], text[3], i ~= #texts and (text[4] .. '\0') or text[4])
    end
end

function math.round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}
    local player_resource = entity_get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity_is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table_insert(result, player) end
        end
    end

    return result
end

local generate_flags = function(e, on_fire_data)
    return {
		e.refined and 'R' or '',
		e.expired and 'X' or '',
		e.noaccept and 'N' or '',
		cl_data.tick_shifted and 'S' or '',
		on_fire_data.teleported and 'T' or '',
		on_fire_data.interpolated and 'I' or '',
		on_fire_data.extrapolated and 'E' or '',
		on_fire_data.boosted and 'B' or '',
		on_fire_data.high_priority and 'H' or ''
    }
end

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

--region net_update
local function g_net_update()
	local me = entity_get_local_player()
    local players = get_entities(true, true)
	local m_tick_base = entity_get_prop(me, 'm_nTickBase')
	
    cl_data.tick_shifted = false
    
	if m_tick_base ~= nil then
		if cl_data.tick_base ~= 0 and m_tick_base < cl_data.tick_base then
			cl_data.tick_shifted = true
		end
	
		cl_data.tick_base = m_tick_base
    end

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity_is_dormant(idx) or not entity_is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
        else
            local player_origin = { entity_get_origin(idx) }
            local simulation_time = time_to_ticks(entity_get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity_get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
    end
end
--endregion

local function g_aim_fire(e)
    local data = e

    if ui.get(master_switch_hitboxes) then
        local r, g, b, a = ui.get(hitboxes_color)

        client.draw_hitboxes(e.target, ui.get(hitboxes_time)/10, 19, r, g, b, a, e.tick)
    end

    local plist_sp = plist.get(e.target, 'Override safe point')
    local checkbox = ui.get(force_safe_point)

    if g_net_data[e.target] == nil then
        g_net_data[e.target] = { }
    end

    data.teleported = g_net_data[e.target].lagcomp or false
    data.choke = g_net_data[e.target].tick or '?'
    data.self_choke = globals.chokedcommands()
    data.safe_point = ({
        ['Off'] = 'off',
        ['On'] = true,
        ['-'] = checkbox
    })[plist_sp]

    g_aimbot_data[e.id] = data
end

local function isNegative(math)
    if(math < 0) then
        return true
    else
        return false
    end
    return false
end

local function ismoving(e)
    if(e.sidemove == 0 and e.forwardmove == 0) then
        return "0"
    else
        return "1"
    end
    return "0"
end

local function g_aim_hit(e)
    if g_aimbot_data[e.id] == nil then
        return
    end

    local on_fire_data = g_aimbot_data[e.id]
	local name = string.lower(entity.get_player_name(e.target))
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local aimed_hgroup = hitgroup_names[on_fire_data.hitgroup + 1] or '?'
    
    local hitchance = math_floor(on_fire_data.hit_chance + 0.5)
    local health = entity_get_prop(e.target, 'm_iHealth')
    -- local min_dmg = ui.reference("RAGE", "Aimbot", "Minimum Damage")

    local flags = generate_flags(e, on_fire_data)
    local ideal_angle = math.max(-60, math.min(60, math.round((entity.get_prop(e.target, "m_flPoseParameter", 11) or 0)*120-60+0.5)))
    local gay = on_fire_data.damage - e.damage
    local first_num='2'
    local second_num='1'
    if ideal_angle<0 then
        first_num = '1'
    end
    if math.abs(ideal_angle)<30 then
        second_num = '2'
    end

    local random = math.random(0,1)
    local m_tick_base = entity_get_prop(entity.get_local_player(), 'm_nTickBase')
    local bt = (m_tick_base - on_fire_data.tick) - 4

    if(isNegative(gay)) then
        multicolor_console({200, 200, 200, "[+] Hit "}, {159, 202, 42, name}, {200, 200, 200, "'s "}, {159, 202, 42, hgroup}, {200, 200, 200, " for "}, {159, 202, 42, e.damage}, {200, 200, 200, " ("}, {159, 202, 42, gay}, {200, 200, 200, ") damage ("}, {159, 202, 42, hitchance}, {200, 200, 200, "%) bt="}, {159, 202, 42, bt}, {200, 200, 200, "ms ["}, {159, 202, 42, first_num}, {200, 200, 200, ":"}, {159, 202, 42, second_num}, {200, 200, 200, ":"}, {159, 202, 42, ideal_angle}, {200, 200, 200, "°] d="}, {159, 202, 42, string.format("%i %s ", random, table.concat(flags))}, {200, 200, 200, "move="}, {159, 202, 42, ismoving(e)})
    else
        multicolor_console({200, 200, 200, "[+] Hit "}, {159, 202, 42, name}, {200, 200, 200, "'s "}, {159, 202, 42, hgroup}, {200, 200, 200, " for "}, {159, 202, 42, e.damage}, {200, 200, 200, " ("}, {159, 202, 42, string.format("+%i",gay)}, {200, 200, 200, ") damage ("}, {159, 202, 42, hitchance}, {200, 200, 200, "%) bt="}, {159, 202, 42, bt}, {200, 200, 200, "ms ["}, {159, 202, 42, first_num}, {200, 200, 200, ":"}, {159, 202, 42, second_num}, {200, 200, 200, ":"}, {159, 202, 42, ideal_angle}, {200, 200, 200, "°] d="}, {159, 202, 42, string.format("%i %s ", random, table.concat(flags))}, {200, 200, 200, "move="}, {159, 202, 42, ismoving(e)})
    end
end

local function g_aim_miss(e)
    if g_aimbot_data[e.id] == nil then
        return
    end
    local on_fire_data = g_aimbot_data[e.id]
    local name = string.lower(entity.get_player_name(e.target))

	local aimed_hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local hitchance = math_floor(on_fire_data.hit_chance + 0.5)
    local ideal_angle = math.max(-60, math.min(60, math.round((entity.get_prop(e.target, "m_flPoseParameter", 11) or 0)*120-60+0.5)))

    local first_num='2'
    local second_num='1'
    if ideal_angle<0 then
        first_num = '1'
    end
    if math.abs(ideal_angle)<30 then
        second_num = '2'
    end

    local random = math.random(0,1)

    local flags = generate_flags(e, on_fire_data)
    local m_tick_base = entity.get_prop(entity.get_local_player(), 'm_nTickBase')
    local bt = (m_tick_base - on_fire_data.tick) - 4
    multicolor_console({200, 200, 200, "[-] Missed "}, {255, 115, 115, name}, {200, 200, 200, "'s "}, {255, 115, 115, aimed_hgroup}, {200, 200, 200, " for "}, {255, 115, 115,  on_fire_data.damage}, {200, 200, 200, " damage ("}, {255, 115, 115,  on_fire_data.damage}, {200, 200, 200, "%) due to "}, {255, 115, 115, e.reason}, {200, 200, 200, " bt="}, {255, 115, 115, bt}, {200, 200, 200, "ms ["}, {255, 115, 115, first_num}, {200, 200, 200, ":"}, {255, 115, 115, second_num}, {200, 200, 200, ":"}, {255, 115, 115, ideal_angle}, {200, 200, 200, "°] d="}, {255, 115, 115, string.format("%i %s ", random, table.concat(flags))}, {200, 200, 200, "move="}, {255, 115, 115, ismoving(e)})
end

local function g_player_hurt(e)
    local attacker_id = client.userid_to_entindex(e.attacker)
	
    if attacker_id == nil or attacker_id ~= entity.get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
    local ideal_angle = math.max(-60, math.min(60, math.round((entity.get_prop(e.target, "m_flPoseParameter", 11) or 0)*120-60+0.5)))

    local first_num='2'
    local second_num='1'
    if ideal_angle<0 then
        first_num = '1'
    end
    if math.abs(ideal_angle)<30 then
        second_num = '2'
    end

    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client.userid_to_entindex(e.userid)
		local target_name = entity.get_player_name(target_id)

		print(string.format("%s %s for %i damage (%i remaining) ", weapon_to_verb[e.weapon], string.lower(target_name), e.dmg_health, e.health))
	end
end

client.set_event_callback('aim_fire', g_aim_fire)
client.set_event_callback('aim_hit', g_aim_hit)
client.set_event_callback('aim_miss', g_aim_miss)
client.set_event_callback('net_update_end', g_net_update)

client.set_event_callback('player_hurt', g_player_hurt)