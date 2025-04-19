-- local variables for API functions. any changes to the line below will be lost on re-generation
local assert, bit_band, globals_curtime, globals_tickcount, globals_tickinterval, math_abs, math_floor, math_fmod, math_max, math_min, math_pow, table_remove, unpack, setmetatable = assert, bit.band, globals.curtime, globals.tickcount, globals.tickinterval, math.abs, math.floor, math.fmod, math.max, math.min, math.pow, table.remove, unpack, setmetatable

local type = type

local ffi = require 'ffi'
local vector = require 'vector'
local entity = require 'gamesense/entity'

local jmp_edx = client.find_signature('engine.dll', '\xFF\xE2')

local function vmt_thunk(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return ffi.cast(t, jmp_edx)(instance, ffi.cast('void***', instance)[0][index], ...)
		end
	end
end

local function clamp(val, min_val, max_val)
	return math_max(min_val, math_min(max_val, val))
end

local function anglemod(a)
	return (360 / 65536) * bit_band(math_floor(a * (65536 / 360)), 65535)
end

local function approach_angle(target, value, speed)
	target = anglemod(target)
	value = anglemod(value)

	local delta = target - value

	if speed < 0 then
		speed = -speed
	end

	if delta < -180 then
		delta = delta + 360
	elseif delta > 180 then
		delta = delta - 360
	end

	if delta > speed then
		value = value + speed
	elseif delta < -speed then
		value = value - speed
	else
		value = target
	end

	return value
end

local function normalize_angle(angle)
	while angle > 180 do angle = angle - 360 end
	while angle < -180 do angle = angle + 360 end
	return angle
end

local function angle_diff(dest_angle, src_angle)
	local delta = math_fmod(dest_angle - src_angle, 360)
	if dest_angle > src_angle then
		if delta >= 180 then
			delta = delta - 360
		end
	else
		if delta <= -180 then
			delta = delta + 360
		end
	end
	return delta
end

local function get_smoothed_velocity(min_delta, a, b)
	local delta = a - b
	local delta_length = delta:length()

	if delta_length <= min_delta then
		if -min_delta <= delta_length then
			return a
		else
			local radius = 1 / (delta_length + 1.19209290E-07)
			return b - ((delta * radius) * min_delta)
		end
	else
		local radius = 1 / (delta_length + 1.19209290E-07)
		return b + ((delta * radius) * min_delta)
	end
end

local estimate_abs_velocity = vmt_thunk(144, 'void(__fastcall*)(void*, void*, float*)')

local data = {
	abs_yaw = 0,
	feet_yaw = 0,
	server_feet_yaw = 0,
	desync_exact = 0,
	desync = 0,

	tickbase = { 
		shifting = 0,
		list = (function()
			-- dont mind me, i was having a stroke
			local index, max = { }, 16
			for i=1, max do
				index[#index+1] = 0
				if i == max then
					return index
				end
			end
		end)()
	},

	balance_adjust = {
		updating = false,
		next_update = 0
	}
}

local abs_vel, original_data = ffi.new('float[3]'), data
local stop_to_full_running_fraction, duck_amount, speed = 0, 0, 0
local eye_angles_y, srv_goal_feet_yaw

local function setup_velocity(c)
	local curtime = globals_curtime()
	local tickinterval = globals_tickinterval()

	local local_player = entity.get_local_player()
	local anim_state = local_player:get_anim_state()

	if anim_state.anim_update_timer <= 0.0 then
		stop_to_full_running_fraction, duck_amount, speed = 0, 0, 0
		eye_angles_y, srv_goal_feet_yaw = nil, nil
		data = original_data
		return
	end

	if eye_angles_y == nil or srv_goal_feet_yaw == nil then
		eye_angles_y = anim_state.eye_angles_y
		srv_goal_feet_yaw = anim_state.goal_feet_yaw
	end

	if c.chokedcommands == 0 then
		stop_to_full_running_fraction = anim_state.stop_to_full_running_fraction
		duck_amount = anim_state.duck_amount
		eye_angles_y = anim_state.eye_angles_y

		estimate_abs_velocity(local_player:get_client_entity(), abs_vel)

		local velocity_a = vector(abs_vel[0], abs_vel[1], abs_vel[2])
		local velocity_b = vector(local_player:get_prop('m_vecVelocity'))

		local spd = velocity_a:lengthsqr()

		if spd > math_pow(1.2 * 260, 2) then
			local velocity_normalized = velocity_a:normalized()
			velocity_a = velocity_normalized * (1.2 * 260)
		end

		velocity_a.z = 0
		velocity_b = get_smoothed_velocity(tickinterval * 2000, velocity_a, velocity_b)

		speed = math_min(velocity_b:length(), 260)
	end

	local lower_body = local_player:get_anim_overlay(3)

	local weapon = local_player:get_player_weapon():get_weapon_info()
	local max_movement_speed = weapon and math_max(weapon.flMaxSpeed, 0.001) or 260

	local running_speed = clamp(speed / (max_movement_speed * 0.520), 0, 1)
	local yaw_modifier = (((stop_to_full_running_fraction * -0.3) - 0.2) * running_speed) + 1

	if duck_amount > 0 then
		local ducking_speed = clamp(speed / (max_movement_speed * 0.340), 0, 1)
		yaw_modifier = yaw_modifier + ((duck_amount * ducking_speed) * (0.5 - yaw_modifier))
	end

	srv_goal_feet_yaw = clamp(srv_goal_feet_yaw, -360, 360)

	local eye_feet_delta = angle_diff(eye_angles_y, srv_goal_feet_yaw)
	local max_yaw_modifier, min_yaw_modifier = 
		yaw_modifier * 58,
		yaw_modifier * -58

	if eye_feet_delta <= max_yaw_modifier then
		if min_yaw_modifier > eye_feet_delta then
			srv_goal_feet_yaw = math_abs(min_yaw_modifier) + eye_angles_y
		end
	else
		srv_goal_feet_yaw = eye_angles_y - math_abs(max_yaw_modifier)
	end

	if speed > 0.1 then
		srv_goal_feet_yaw = approach_angle(
			eye_angles_y,
			normalize_angle(srv_goal_feet_yaw),
			((stop_to_full_running_fraction * 20) + 30) * tickinterval
		)
	else
		srv_goal_feet_yaw = approach_angle(
			local_player:get_prop('m_flLowerBodyYawTarget'),
			normalize_angle(srv_goal_feet_yaw), 
			tickinterval * 100
		)
	end

	if not data.balance_adjust.updating then
		data.balance_adjust.next_update = curtime + 0.22
	elseif local_player:get_sequence_activity(lower_body.sequence) == 979 then
		if data.balance_adjust.next_update < curtime and lower_body.weight > 0.000 then
			data.balance_adjust.next_update = curtime + 1.1
		end
	end

	if c.chokedcommands == 0 then
		local body_lean = math_abs(angle_diff(anim_state.eye_angles_y, anim_state.goal_feet_yaw))

		data.balance_adjust.updating = 
			anim_state.on_ground and anim_state.m_velocity < 0.1 and
			anim_state.anim_update_timer > 0.0

		data.abs_yaw = anim_state.eye_angles_y
		data.feet_yaw = anim_state.goal_feet_yaw
		data.server_feet_yaw = srv_goal_feet_yaw

		data.desync_exact = angle_diff(srv_goal_feet_yaw, anim_state.goal_feet_yaw)
		data.desync = clamp(data.desync_exact, -body_lean, body_lean)
	end
end

local function net_update()
	local local_player = entity.get_local_player()
	local sim_time = local_player:get_prop('m_flSimulationTime')

	if local_player == nil or sim_time == nil then
		return
	end

	local tick_count = globals_tickcount()
	local shifted = math_max(unpack(data.tickbase.list))

	data.tickbase.shifting = shifted < 0 and math_abs(shifted) or 0
	data.tickbase.list[#data.tickbase.list+1] = sim_time/globals_tickinterval() - tick_count

	table_remove(data.tickbase.list, 1)
end

client.set_event_callback('setup_command', setup_velocity)
client.set_event_callback('net_update_start', net_update)

local this = { }

local ret_thing = function(n, ...)
	local type = { }
	local _arr = { ... }

	for i=1, #_arr do
		type[#type+1] = _arr[i]
	end

	if type[n] == nil then
		return unpack(_arr)
	end

	return type[n]
end

local get_curtime = function(nOffset)
	return globals_curtime() - (nOffset * globals_tickinterval())
end

local weapon_ready = function()
	local target = entity.get_local_player()
	local weapon = target:get_player_weapon()

	if target == nil or weapon == nil then
		return false
	end

	if get_curtime(16) < target:get_prop('m_flNextAttack') then 
		return false
	end

	if get_curtime(0) < weapon:get_prop('m_flNextPrimaryAttack') then
		return false
	end

	return true
end

return {
	approach_angle = function(target, value, speed) return approach_angle(target, value, speed) end,
	angle_diff = function(dest_angle, src_angle) return angle_diff(dest_angle, src_angle) end,
	normalize_angle = function(angle) return normalize_angle(angle) end,

	get_abs_yaw = function() return data.abs_yaw end,
	get_balance_adjust = function() return data.balance_adjust end,
	get_body_yaw = function(n) return ret_thing(n, data.feet_yaw, data.server_feet_yaw) end,
	get_desync = function(n) return ret_thing(n, data.desync, data.desync_exact) end,
	get_tickbase_shifting = function() return data.tickbase.shifting end,
	get_double_tap = function() return weapon_ready() and data.tickbase.shifting > 0 end,

	get_overlap = function(rotation)
		local client, server, lean =
			data.feet_yaw,
			data.server_feet_yaw,
			angle_diff(data.abs_yaw, data.feet_yaw)
	
		if type(rotation) == 'number' then
			local cLean = math_abs(lean)
	
			client = clamp(
				rotation, 
				data.abs_yaw-cLean, data.abs_yaw+cLean
			)
		end
	
		if rotation == true then
			client = data.abs_yaw + lean
		end
	
		local adiff = math_abs(angle_diff(client, server))
	
		return 1 - (adiff / 120 * 1), client
	end
}