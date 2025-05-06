local ffi = require("ffi")
local vector = require("vector")
local bit = require("bit")
local c_entity = require("gamesense/entity")

local enable_resolver = ui.new_checkbox("RAGE", "Other", "Enable Resolver")
local flags = ui.new_multiselect("RAGE", "Other", "Flags", "RESOLVING STATUS", "STORED FS SIDE", "ANTI-AIM DATA", "RESOLVING TYPE", "ANGLE DATA")

local player_pose_data = { }
local player_memory = { }
local player_animation_data = { }
local last_shot_data = { 
    damage = nil,
    hgroup = nil,
}

local js = panorama.open()
local GameStateAPI = js.GameStateAPI
local MyPersonaAPI = js.MyPersonaAPI

local function contains(table, value)

	if table == nil then
		return false
	end
	
    table = ui.get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function get_entities(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true

    local result = {}

    local me = entity.get_local_player()
    local player_resource = entity.get_player_resource()

    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true

        if enemy_only and not entity.is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table.insert(result, player) end
        end
    end

    return result
end

local function CalcAngle(x_src, y_src, z_src, x_dst, y_dst, z_dst)
    local x_delta = x_src - x_dst
    local y_delta = y_src - y_dst
    local z_delta = z_src - z_dst
    local hyp = math.sqrt(x_delta^2 + y_delta^2)
    local x = math.atan2(z_delta, hyp) * 57.295779513082
    local y = math.atan2(y_delta , x_delta) * 180 / 3.14159265358979323846
 
    if y > 180 then
        y = y - 180
    end
    if y < -180 then
        y = y + 180
    end
    return y
end

local function TIME_TO_TICKS( time )
    local t_Return = time / globals.tickinterval()
    return math.floor(t_Return)
end

local function TICKS_TO_TIME ( ticks )
    local t_Return = globals.tickinterval() * ticks
    return math.floor(t_Return)
end

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end

local function get_velocity(player)
	local x,y,z = entity.get_prop(player, "m_vecVelocity")
	if x == nil then return end
	return math.sqrt(x*x + y*y + z*z)
end

local function is_crouching(player)
    if player == nil then return end
    local flags = entity.get_prop(player, "m_fFlags")
    if flags == nil then return end

    if bit.band(flags, 4) == 4 then
        return true
    end
    
    return false
end

local function in_air(player)
    if player == nil then return end
    local flags = entity.get_prop(player, "m_fFlags")
    if flags == nil then return end
    
    if bit.band(flags, 1) == 0 then
        return true
    end
    
    return false
end

local function wall_freestand()

    local data = {
        side = 1,
        last_side = 0,
    
        last_hit = 0,
        hit_side = 0
    }

    local me = entity.get_local_player()

    if (not me or entity.get_prop(me, "m_lifeState") ~= 0) then
        return
    end
    

    local now = globals.curtime()

    if data.hit_side ~= 0 and now - data.last_hit > 5 then

        data.last_side = 0

        data.last_hit = 0
        data.hit_side = 0
    end

    local x, y, z = client.eye_position()
    local _, yaw = client.camera_angles()

    local trace_data = {left = 0, right = 0}

    for i = yaw - 120, yaw + 120, 30 do

        if i ~= yaw then

            local rad = math.rad(i)

            local px, py, pz = x + 256 * math.cos(rad), y + 256 * math.sin(rad), z

            local fraction = client.trace_line(me, x, y, z, px, py, pz)
            local side = i < yaw and "left" or "right"

            trace_data[side] = trace_data[side] + fraction
        end
    end

    data.side = trace_data.left < trace_data.right and 1 or -1

    if data.side == data.last_side then
        return
    end

    data.last_side = data.side

    if data.hit_side ~= 0 then
        data.side = data.hit_side == 1 and 1 or -1
    end

    local result = data.side == 1 and 1 or -1

    return result
end

local function max_angle(player)
    local player_index = c_entity.new(player)
    local player_animstate = player_index:get_anim_state()

    local max_yaw = player_animstate.max_yaw
    local min_yaw = player_animstate.min_yaw
    local duck_amount = player_animstate.duck_amount
    local feet_speed_forwards_or_sideways = math.max(0, math.min(1, player_animstate.feet_speed_forwards_or_sideways))
    local feet_speed_unknown_forwards_or_sideways = math.max(1, player_animstate.feet_speed_unknown_forwards_or_sideways)
    local value = ((player_animstate.stop_to_full_running_fraction * -0.30000001 - 0.19999999) * feet_speed_forwards_or_sideways + 1)
    if duck_amount > 0 then
        value = value + duck_amount * feet_speed_unknown_forwards_or_sideways * (0.5 - value)
    end
    local delta_yaw = math.abs(player_animstate.max_yaw) * value
    return math.min(math.abs(max_yaw), delta_yaw)
end

local function animation_data(player, max_yaw, state)
    local player_index = c_entity.new(player)

    if player_animation_data[player] == nil then
        player_animation_data[player] = {
            on_change_cycle_ticks = globals.tickcount(),
            pervious_feet_cycle = 0,
        }
    end

    local animstate = player_index:get_anim_state()
    local layer_1 = player_index:get_anim_overlay(1)
    local layer_3 = player_index:get_anim_overlay(3)
    local layer_6 = player_index:get_anim_overlay(6)

    local lby_data = { [47012329101563] = { 58, 1 }, [25012207031250] = { 35, 1 }, [59011840820313] = { 20, 1 }, [43014526367188] = { 58, -1 }, [59014892578125] = { 30, -1 } }

    local feet_cycle = (animstate.feet_cycle*100000000000000)

    local playbackrate_1 = layer_1.playback_rate
    local playbackrate_3 = layer_3.playback_rate
    local playbackrate_6 = layer_6.playback_rate

    local is_fake = ((playbackrate_3 == 0.96774184703827) or (playbackrate_6 == 0)) and false or true
    local side = (playbackrate_1 ~= 1) and 1 or -1
    
    if feet_cycle ~= player_animation_data[player].pervious_feet_cycle then
        player_animation_data[player].on_change_cycle_ticks = globals.tickcount()
        player_animation_data[player].pervious_feet_cycle = feet_cycle
    end

    local static_cycle = ((globals.tickcount() - player_animation_data[player].on_change_cycle_ticks) > 5)

    local opposite_desync = static_cycle and ((lby_data[feet_cycle] ~= nil) and lby_data[feet_cycle][1] or nil) or nil
    local opposite_side = static_cycle and ((lby_data[feet_cycle] ~= nil) and lby_data[feet_cycle][2] or nil) or nil

    local default_desync = is_fake and max_yaw or 0
    local default_side = is_fake and side or 1

    local angle_amount = (opposite_desync ~= nil) and opposite_desync or default_desync
    local side_amount = (opposite_side ~= nil) and opposite_side or (player_memory[player].is_jitter and default_side*player_memory[player].jitter_side*player_memory[player].stored_mode[state] or default_side)

    player_memory[player].opposite = static_cycle and (lby_data[feet_cycle] ~= nil)
    player_memory[player].opposite_angle = opposite_desync
    player_memory[player].anim_side = default_side

    local got_new_data = (player_memory[player].opposite and (player_memory[player].pervious_opposite_angle ~= opposite_desync)) or (side_amount ~= player_memory[player].pervious_anim_side)
    local got_new_data2 = (player_memory[player].old_weapon_side ~= default_side)

    if player_memory[player].anim_down and got_new_data then
        player_memory[player].anim_down = false
    end

    if got_new_data2 then
        if player_memory[player].is_jitter and not player_memory[player].opposite then
            if ((player_memory[player].jitter_side == 1) and (default_side == 1)) or ((player_memory[player].jitter_side == -1) and (default_side == -1)) then
                player_memory[player].stored_mode[state] = 1
            else
                player_memory[player].stored_mode[state] = -1
            end
        end
        player_memory[player].old_weapon_side = default_side
    end

    return angle_amount, side_amount
end

local function optimize_angle_to_yaw(angle, yaw)
    local abs_yaw = math.abs(yaw)
    local abs_angle = math.abs(angle)
    local max_yaw_90 = abs_yaw > 90 and math.abs(180 - abs_yaw) or abs_yaw
    local yaw_proccent = (max_yaw_90/10)/3.5
    local angle_proccent = math.floor(abs_angle/math.max(1, yaw_proccent))

    return math.max(0, angle_proccent)
end

local function create_angle(angle, adaptive, yaw)
    local angle_s = math.max(0, (angle - adaptive))

    return optimize_angle_to_yaw(angle_s, yaw)
end

local function state(velocity)
    if velocity < 5 and not in_air(entity.get_local_player()) and not is_crouching(entity.get_local_player()) then
        cnds = 1
    elseif in_air(entity.get_local_player()) and not is_crouching(entity.get_local_player()) then
        cnds = 4
    elseif in_air(entity.get_local_player()) and is_crouching(entity.get_local_player()) then
        cnds = 5
    elseif is_crouching(entity.get_local_player()) and not in_air(entity.get_local_player()) then
        cnds = 6
    else
        if velocity <= 78 then
            cnds = 3
        else
            cnds = 2 
        end
    end

    return cnds
end

client.set_event_callback("aim_fire", function(e)
    last_shot_data.damage = e.damage
    last_shot_data.hgroup = e.hitgroup
end)

client.set_event_callback("aim_miss", function(e)
    if e.reason ~= "?" then return end
    
    local player = e.target

    player_memory[player].resolved = false
    
    if player_memory[player] == nil then return end

    if not player_memory[player].anim_down then
        if player_memory[player].opposite then
            player_memory[player].pervious_opposite_angle = player_memory[player].opposite_angle
        end
        player_memory[player].pervious_anim_side = player_memory[player].anim_side
        player_memory[player].anim_down = true
    else
        player_memory[player].misses = ((player_memory[player].misses + 1) > 2) and 0 or (player_memory[player].misses + 1)
    end
end)

client.set_event_callback("aim_hit", function(e)
    local wanted_damage = last_shot_data.damage
    local wanted_hgroup = last_shot_data.hgroup
    local player = e.target

    if player_memory[player] == nil then return end

    if (wanted_damage == e.hitgroup) and (wanted_damage == e.damage) then player_memory[player].resolved = true end
    if (wanted_damage == e.damage) then return end

    local velocity = get_velocity(player)
    local state = state(player)

    local missmatch_amount = math.abs(wanted_damage - e.damage)
    local step = 4.45

    player_memory[player].adaptive_angle[state] = (missmatch_amount/step)

    local go_store = { [0] = false, [1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = false, [10] = false }

    if go_store[e.hitgroup] and (player_memory[player].misses ~= 0) then
        if (player_memory[player].stored_mode[state] == 1) then
            player_memory[player].misses = 0
            player_memory[player].stored_mode[state] = -1
        else
            player_memory[player].misses = 0
            player_memory[player].stored_mode[state] = 1
        end
    end
end)

local function JitterData(player, yaw, world_yaw, pitch)
    local velocity = get_velocity(player)
    local state = state(velocity)

    if (globals.tickcount() - player_memory[player].on_yaw_change_ticks) < 0 then 
        player_memory[player].on_yaw_change_ticks = 0
    end

    if yaw ~= player_memory[player].pervious_yaw then
        if (yaw > 0) and (player_memory[player].pervious_yaw < 0) then
            player_memory[player].yaw = player_memory[player].pervious_world_yaw
            player_memory[player].jitter_side = -1
            player_memory[player].on_yaw_change_ticks = globals.tickcount()
            player_memory[player].pervious_world_yaw = world_yaw
            player_memory[player].pervious_yaw = yaw
        elseif (yaw < 0) and (player_memory[player].pervious_yaw > 0) then
            player_memory[player].yaw = player_memory[player].pervious_world_yaw
            player_memory[player].jitter_side = 1
            player_memory[player].on_yaw_change_ticks = globals.tickcount()
            player_memory[player].pervious_world_yaw = world_yaw
            player_memory[player].pervious_yaw = yaw
        elseif (yaw > 0) and (player_memory[player].pervious_yaw > 0) then
            if yaw > player_memory[player].pervious_yaw then
                player_memory[player].yaw = player_memory[player].pervious_world_yaw
                player_memory[player].jitter_side = -1
                player_memory[player].on_yaw_change_ticks = globals.tickcount()
                player_memory[player].pervious_world_yaw = world_yaw
                player_memory[player].pervious_yaw = yaw
            elseif yaw < player_memory[player].pervious_yaw then
                player_memory[player].yaw = player_memory[player].pervious_world_yaw
                player_memory[player].jitter_side = 1
                player_memory[player].on_yaw_change_ticks = globals.tickcount()
                player_memory[player].pervious_world_yaw = world_yaw
                player_memory[player].pervious_yaw = yaw
            end
        elseif (yaw < 0) and (player_memory[player].pervious_yaw < 0) then
            if yaw > player_memory[player].pervious_yaw then
                player_memory[player].yaw = player_memory[player].pervious_world_yaw
                player_memory[player].jitter_side = -1
                player_memory[player].on_yaw_change_ticks = globals.tickcount()
                player_memory[player].pervious_world_yaw = world_yaw
                player_memory[player].pervious_yaw = yaw
            elseif yaw < player_memory[player].pervious_yaw then
                player_memory[player].yaw = player_memory[player].pervious_world_yaw
                player_memory[player].jitter_side = 1
                player_memory[player].on_yaw_change_ticks = globals.tickcount()
                player_memory[player].pervious_world_yaw = world_yaw
                player_memory[player].pervious_yaw = yaw
            end
        end
    end

    if (pitch > (player_memory[player].pervious_pitch + 37)) or (pitch < (player_memory[player].pervious_pitch - 37)) then
        player_memory[player].pitch = math.max(player_memory[player].pervious_pitch, pitch)
        player_memory[player].on_pitch_change_ticks = globals.tickcount()
        player_memory[player].pervious_pitch = pitch
    end

    player_memory[player].is_jitter = ((globals.tickcount() - player_memory[player].on_yaw_change_ticks) <= 1)
    player_memory[player].is_breaker = ((globals.tickcount() - player_memory[player].on_pitch_change_ticks) <= 1)
end

local function AngleData(player, yaw)
    local resolver_freestand = wall_freestand()

    local velocity = get_velocity(player)
    local state = state(velocity)

    local side_freestand = player_memory[player].is_jitter and player_memory[player].jitter_side or resolver_freestand
    local stored_side_mode = side_freestand*player_memory[player].stored_mode[state]
    local brute_side = (player_memory[player].misses == 0) and stored_side_mode or -stored_side_mode
    local brute_side_anim = (player_memory[player].misses == 0) and 1 or -1

    local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(player)
    local is_bot = GameStateAPI.IsFakePlayer(xuid)

    local max_yaw = max_angle(player)

    local anim_angle, anim_side = animation_data(player, max_yaw, state)
    local adaptive_angle = player_memory[player].adaptive_angle[state]

    if is_bot then
        player_memory[player].angle = 0
    else
        player_memory[player].angle = create_angle(anim_angle, adaptive_angle, yaw)*brute_side
    end
end

client.set_event_callback("pre_render", function()
    if not ui.get(enable_resolver) then return end

    local players = get_entities(true, true)
    for k, player in pairs(players) do
        if (player == nil) then goto skip end

        local yaw = entity.get_prop(player, "m_angEyeAngles[1]")
        local pitch = entity.get_prop(player, "m_angEyeAngles[0]")

        if player_pose_data[player] == nil then
            player_pose_data[player] = { 
                pitch = pitch,
                yaw = yaw,
            }
        end

        player_pose_data[player].pitch = pitch
        player_pose_data[player].yaw = yaw

        ::skip::
    end
end)

client.set_event_callback("setup_command", function()
    if not ui.get(enable_resolver) then return end
    local players = get_entities(true, true)
    for k, player in pairs(players) do
        if (player == nil) then goto skip end

        if (player_pose_data[player] == nil) then goto skip end

        local world_yaw = player_pose_data[player].yaw
        local world_pitch = player_pose_data[player].pitch

        local hitbox_pos_x, hitbox_pos_y, hitbox_pos_z = entity.hitbox_position(player, 0)
        local local_x, local_y, local_z = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local dynamic = CalcAngle(local_x, local_y, local_z, hitbox_pos_x, hitbox_pos_y, hitbox_pos_z)
        local fake_yaw = math.floor(normalize_yaw(world_yaw))

        local yaw = ((math.floor(normalize_yaw(dynamic)) - fake_yaw) > 0 and (math.floor(normalize_yaw(dynamic)) - fake_yaw) - 180 or (math.floor(normalize_yaw(dynamic)) - fake_yaw) + 180)*-1

        local velocity = get_velocity(player)
        local state = state(velocity)

        if (player_memory[player] == nil) then
            player_memory[player] = {
                misses = 0,
                angle = 0, 
                yaw = 0,
                pitch = 0,
                opposite = false,
                opposite_angle = 0,
                old_weapon_side = 0,
                anim_side = 0,
                pervious_opposite_angle = 0,
                pervious_anim_side = 0,
                anim_down = false,
                on_yaw_change_ticks = 0,
                on_pitch_change_ticks = 0,
                pervious_world_yaw = world_yaw,
                pervious_yaw = yaw,
                pervious_pitch = world_pitch,
                is_jitter = false,
                is_breaker = false,
                stored_mode = {
                    1,
                    1,
                    1,
                    1,
                    1,
                    1,
                },
                adaptive_angle = {
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                },
                resolved = false,
            }
        end

        JitterData(player, yaw, world_yaw, world_pitch)
        AngleData(player, yaw)

        ::skip::
    end
end)

client.set_event_callback("paint", function()
    local player = client.current_threat()

    if player == nil then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    if not ui.get(enable_resolver) then
        plist.set(player, "Force body yaw", false)
        plist.set(player, "Force pitch", false)
        return
    end

    if (player_memory[player] == nil) then return end

    local player_index = c_entity.new(player)

    plist.set(player, "Correction active", true)
    plist.set(player, "Force body yaw", true)
    plist.set(player, "Force pitch", player_memory[player].is_breaker)
    plist.set(player, "Force body yaw value", player_memory[player].angle)
    plist.set(player, "Force pitch value", player_memory[player].pitch)
    plist.set(player, "Override safe point", (player_memory[player].is_breaker or player_memory[player].is_jitter) and "On" or "Off")
    if player_memory[player].is_jitter then player_index:set_prop("m_angEyeAngles[1]", player_memory[player].yaw) end
    player_index:set_prop("m_angEyeAngles[2]", 0)
end)

client.set_event_callback("player_death", function(e)
    local player = client.userid_to_entindex(e.userid)
    local killer = client.userid_to_entindex(e.attacker)

    if killer == entity.get_local_player() then
        if player_memory[player] == nil then return end
        player_memory[player].misses = 0
        player_memory[player].anim_down = false
    end
end)

client.set_event_callback("round_start", function()
    local players = get_entities(true, false)
    for k, player in pairs(players) do
        if player_memory[player] == nil then return end
        player_memory[player].misses = 0
        player_memory[player].anim_down = false
    end
end)

client.register_esp_flag("RESOLVING", 255, 150, 150, function(entity_index)
    if not contains(flags, "RESOLVING STATUS") then return end

    if player_memory[entity_index] == nil then return false end

    return not player_memory[entity_index].resolved
end)

client.register_esp_flag("RESOLVED", 200, 255, 175, function(entity_index)
    if not contains(flags, "RESOLVING STATUS") then return end

    if player_memory[entity_index] == nil then return false end
    
    return player_memory[entity_index].resolved
end)

client.register_esp_flag("STORED FS SIDE", 255, 190, 135, function(entity_index)
    if not contains(flags, "STORED FS SIDE") then return end

    if player_memory[entity_index] == nil then return false end

    if entity.is_dormant(entity_index) then return false end

    local velocity = get_velocity(entity_index)
    local state = state(entity_index)

    local mode = (player_memory[entity_index].stored_mode[state] == 1) and "+" or "-"
    
    return true, "STORE [ "..mode.." ]"
end)

client.register_esp_flag("ANTI-AIM DATA", 255, 255, 255, function(entity_index)
    if not contains(flags, "ANTI-AIM DATA") then return end
    
    if player_memory[entity_index] == nil then return false end

    if entity.is_dormant(entity_index) then return false end

    local mode = player_memory[entity_index].is_breaker and "BREAK" or (player_memory[entity_index].is_jitter and "JITTER" or "STATIC")
    
    return true, mode
end)

client.register_esp_flag("RESOLVING TYPE", 210, 255, 160, function(entity_index)
    if not contains(flags, "RESOLVING TYPE") then return end
    
    local player = client.current_threat()

    if player ~= entity_index then return false end

    if entity.is_dormant(entity_index) then return end

    if player_memory[entity_index] == nil then return false end

    local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(player)
    local is_bot = GameStateAPI.IsFakePlayer(xuid)

    local mode = is_bot and "GAME" or (player_memory[entity_index].anim_down and "BRUTE" or "ANIM")
    
    return true, mode
end)

client.register_esp_flag("ANGLE DATA", 255, 255, 255, function(entity_index)
    if not contains(flags, "ANGLE DATA") then return end

    if player_memory[entity_index] == nil then return false end

    if entity.is_dormant(entity_index) then return false end

    local current_angle = math.floor(entity.get_prop(entity_index, "m_flPoseParameter", 11) * 120 - 60)
    local max_yaw = math.floor(max_angle(entity_index))
    
    return true, current_angle.." [ "..max_yaw.." ]"
end)