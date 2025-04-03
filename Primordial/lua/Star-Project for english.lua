local script = {}
script.m_current_data = {
	m_key_modes = {},
	desync_flip = false,
	switcher_delay = 0,
	cache_rotation = {},
	motion_flip = false,
	m_shooting_ticks = 0,
	switcher_amount = 0,
	should_motion_flip = 0,
	m_custom_element = {},
	m_should_shooting = false,
	script_name = "Star-project",
	side_directory = {"Left prosthesis", "Right prosthesis"},
	player_state = {"Global", "stand", "walk", "slow Walk", "jump", "Crouch [T Camp]", "Crouch [CT Camp]", "Peek time [Forecast]", "Peek time [already]", "Visual time", "When firing", "on the left", "on the right", "back", "forward"},
	m_shot_data = {
		CurrentIndex = 0,
		LastShotTime = 0,
		RegisterAddState = false
	},

	bind_system = {
		left = false,
		right = false,
		back = false,
		forward = false
	},

	antiaim_funcs = {
		speed = 0,
		eye_angles_y = nil,
		tickbase_shifting = {},
		srv_goal_feet_yaw = nil,
		tickbase_shifting_list = {},
		get_desync_inverter = false,
		stop_to_full_running_fraction = 0,
		desync_data = {
			abs_yaw = 0,
			feet_yaw = 0,
			stand_height = 60,
			server_feet_yaw = 0,
			desync_body_lean = 0,
			desync_delta_angle = 0,
			desync_delta_angle_exact = 0
		}
	}
}

ffi.cdef[[
	typedef void*(__thiscall* get_client_entity_t)(void*, int);
	typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
]]

local animation_layer_t = ffi.typeof([[
	struct {
		char pad_0x0000[0x18];
		uint32_t sequence;
		float prev_cycle;
		float weight;
		float weight_delta_rate;
		float playback_rate;
		float cycle;
		void *entity; char pad_0x0038[0x4];
	} **
]])

local animation_state_t = ffi.typeof([[
	struct {
		char pad_0x0000[0x18];
		float anim_update_timer; char pad_0x001C[0xC];
		float started_moving_time;
		float last_move_time; char pad_0x0030[0x10];
		float last_lby_time; char pad_0x0044[0x8];
		float run_amount; char pad_0x0050[0x10];
		void *entity;
		__int32 active_weapon;
		__int32 last_active_weapon;
		float last_client_side_animation_update_time;
		__int32 last_client_side_animation_update_framecount;
		float eye_timer;
		float eye_angles_y;
		float eye_angles_x;
		float goal_feet_yaw;
		float current_feet_yaw;
		float torso_yaw;
		float last_move_yaw;
		float lean_amount; char pad_0x0094[0x4];
		float feet_cycle;
		float feet_yaw_rate; char pad_0x00A0[0x4];
		float duck_amount;
		float landing_duck_amount; char pad_0x00AC[0x4];
		float current_origin[3];
		float last_origin[3];
		float velocity_x;
		float velocity_y; char pad_0x00D0[0x10];
		float move_direction_1;
		float move_direction_2; char pad_0x00E8[0x4];
		float m_velocity;
		float jump_fall_velocity;
		float clamped_velocity;
		float feet_speed_forwards_or_sideways;
		float feet_speed_unknown_forwards_or_sideways;
		float last_time_started_moving;
		float last_time_stopped_moving;
		bool on_ground;
		bool hit_in_ground_animation; char pad_0x0110[0x8];
		float last_origin_z;
		float head_from_ground_distance_standing;
		float stop_to_full_running_fraction; char pad_0x0120[0x14];
		__int32 is_not_moving; char pad_0x0138[0x20];
		float last_anim_update_time;
		float moving_direction_x;
		float moving_direction_y;
		float moving_direction_z; char pad_0x0168[0x44];
		__int32 started_moving; char pad_0x01B0[0x8];
		float lean_yaw; char pad_0x01BC[0x8];
		float poses_speed; char pad_0x01C8[0x8];
		float ladder_speed; char pad_0x01D4[0x8];
		float ladder_yaw; char pad_0x01E0[0x8];
		float some_pose; char pad_0x01EC[0x14];
		float body_yaw; char pad_0x0204[0x8];
		float body_pitch; char pad_0x0210[0x8];
		float death_yaw; char pad_0x021C[0x8];
		float stand; char pad_0x0228[0x8];
		float jump_fall; char pad_0x0234[0x8];
		float aim_blend_stand_idle; char pad_0x0240[0x8];
		float aim_blend_crouch_idle; char pad_0x024C[0x8];
		float strafe_yaw; char pad_0x0258[0x8];
		float aim_blend_stand_walk; char pad_0x0264[0x8];
		float aim_blend_stand_run; char pad_0x0270[0x8];
		float aim_blend_crouch_walk; char pad_0x027C[0x8];
		float move_blend_walk; char pad_0x0288[0x8];
		float move_blend_run; char pad_0x0294[0x8];
		float move_blend_crouch; char pad_0x02A0[0x4];
		float speed;
		__int32 moving_in_any_direction;
		float acceleration; char pad_0x02B0[0x74];
		float crouch_height;
		__int32 is_full_crouched; char pad_0x032C[0x4];
		float velocity_subtract_x;
		float velocity_subtract_y;
		float velocity_subtract_z;
		float standing_head_height; char pad_0x0340[0x4];
	} **
]])

local enabled_antiaim = menu.add_checkbox(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "Enable anti-self-aiming [Master Switch]", false)
local switcher_desync_side = menu.add_text(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "[->]Switch to the right prosthesis")
local manual_left = menu.add_text(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "[->]Left hidden head")
local manual_right = menu.add_text(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "[->]Right hidden head")
local manual_backward = menu.add_text(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "[->]Manual back")
local manual_forward = menu.add_text(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "[->]Manually forward")
local manual_state_slider = menu.add_slider(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "Manual AA status", 0, 4)
local anti_backstab = menu.add_checkbox(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "Enable anti-knife", false)
local switcher_desync_key = switcher_desync_side:add_keybind("Switcher desync")
local left_side_key = manual_left:add_keybind("Manual left")
local right_side_key = manual_right:add_keybind("Manual right")
local back_side_key = manual_backward:add_keybind("Manual back")
local forward_side_key = manual_forward:add_keybind("Manual forward")

------------------------------------------------------- 自定义aa 菜单区域 -------------------------------------------------------
local antiaim_desync_side = menu.add_selection(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "Customize the anti-self-aiming direction", script.m_current_data.side_directory)
local antiaim_player_state = menu.add_selection(("Star-Project %s Area: Anti-self-aim [Total]"):format(script.m_current_data.script_name), "CustomizeArea: Anti-self-aim [sub]", script.m_current_data.player_state)
for i, side in pairs(script.m_current_data.side_directory) do
	if script.m_current_data.m_custom_element[i] == nil then
		script.m_current_data.m_custom_element[i] = {}
	end

	for idx, data in pairs(script.m_current_data.player_state) do
		script.m_current_data.m_custom_element[i][idx] = {
			enabled = menu.add_checkbox(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Initiates the anti-self-aiming state: %s[%s]"):format(data, side), idx == 1),
			pitch = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Pitch[%s]"):format(data, side), {"Shut down", "down"," up","Slightly up", "Up and down"}),
			yaw_base = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Yaw angle[%s]"):format(data, side), {"Shut down", "back", "According to the quasi-core enemy[At target]", "According to the nearest enemy[At target]", "According to the speed"}),
			yaw_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Yaw[%s]"):format(data, side), - 180, 180),
			yaw_jitter = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Yaw jittermode[%s]"):format(data, side), {"Shut down", "静态[Offset]", "区间[Center]", "随机[Random]"}),
			yaw_jitter_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Yaw jitterangle[%s]"):format(data, side), - 180, 180),
			body_yaw = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Body yawmode[%s]"):format(data, side), {"Shut down", "静态[Static]", "切换[Jitter]", "慢切换[Default jitter]", "随机[Ranodm]"}),
			body_yaw_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Body yawangle[%s]"):format(data, side), - 60, 60),
			freestanding_body_stypes = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Freestanding body yawmode[%s]"):format(data, side), {"Shut down", "fake Peek", "realy Peek"}),
			fake_yaw_stypes = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Fake yawmode[%s]"):format(data, side), {"静态[Static]", "切换[Jitter]", "随机[Random]", "延迟随机[Delay random]", "单向循环[Single rotation]", "来回循环[Rotation]"}),
			fake_yaw_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Fake yawangle[%s]"):format(data, side), 0, 60),
			fake_yaw_offset_extended = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s The Fake yaw pattern expands the angle[%s]"):format(data, side), 0, 60),
			fake_yaw_offset_delay = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Fake yaw delays random time x seconds[%s]"):format(data, side), 0.5, 10),
			extended_modes = menu.add_multi_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Extra expanded features[%s]"):format(data, side), {"反重合[Anti-overlap]", "切换[Jitter]", "随机切换[Randomize jitter]", "反暴力[Anti-brute force]"}),
			anti_brute_force_mode = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Anti-violencemode[%s]"):format(data, side), {"Shut down", "反向[Opposite]", "不切换[Same side]", "[随机切换]Random"}),
			desync_on_shot = menu.add_checkbox(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Shooting anti-self-aim: %s[%s]"):format(data, side), false),
			desync_on_shot_stypes = menu.add_selection(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Shoot counter-self-aimingmode[%s]"):format(data, side), {"Dynamic outward separation", "Dynamic inward separation", "Static outward separation", "Static inward separation"}),
			onshot_yaw_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Shoot Yawangle[%s]"):format(data, side), - 180, 180),
			onshot_yaw_jitter_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Shoot Yaw jitterangle[%s]"):format(data, side), - 180, 180),
			onshot_body_yaw_offset = menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Shoot Body yawangle[%s]"):format(data, side), - 60, 60),
			onshot_fake_yaw_offset= menu.add_slider(("Star-Project %s Area: Anti-self-aim [sub]"):format(script.m_current_data.script_name), ("Area: Anti-self-aim [sub]: %s Shoot Fake yawangle[%s]"):format(data, side), 0, 60)
		}
	end
end


--local enabled_fakelag = menu.add_checkbox(("Star-Project %s 区域: 假卡[总]"):format(script.m_current_data.script_name), "启用假卡拓展[总开关]", false)




script.class_ptr = ffi.typeof("void***")
script.ientitylist = ffi.cast(script.class_ptr, memory.create_interface("client.dll", "VClientEntityList003")) or error(("%s FFI ientitylist has error"):format(script.script_name))
script.entity_list_pointer = ffi.cast("void***", memory.create_interface("client.dll", "VClientEntityList003")) or error(("%s FFI entity list pointer has error"):format(script.script_name))
script.get_client_entity_uintptr_address = ffi.cast("GetClientEntity_4242425_t", script.entity_list_pointer[0][3]) or error(("%s FFI get client entity unitptr has error"):format(script.script_name))
script.get_client_entity = ffi.cast("get_client_entity_t", ffi.cast(script.class_ptr, memory.create_interface("client.dll", "VClientEntityList003"))[0][3]) or error(("%s FFI get client entity has error"):format(script.script_name))
script.is_alive = function(ptr)
	return ptr ~= nil and ptr:is_alive() and ptr:get_prop("m_iHealth") > 0
end

script.is_jumping = function(entity)
	if not script.is_alive(entity) then
		return false
	end

	local flags = entity:get_prop("m_fFlags")
	return bit.band(flags, 1) == 0
end

script.is_ducking = function(entity)
	if not script.is_alive(entity) then
		return false
	end

	local flags = entity:get_prop("m_fFlags")
	return bit.band(flags, 2) == 2
end

script.get_velocity = function(entity)
	if not script.is_alive(entity) then
		return 0
	end

	local velocity_y = entity:get_prop("m_vecVelocity[1]")
	local velocity_x = entity:get_prop("m_vecVelocity[0]")
	return math.sqrt((velocity_x * velocity_x) + (velocity_y * velocity_y))
end

script.vmt_entry = function(instance, index, type)
	return ffi.cast(type, (ffi.cast("void***", instance)[0])[index])
end

script.vmt_thunk = function(index, typestring)
	local t = ffi.typeof(typestring)
	return function(instance, ...)
		assert(instance ~= nil)
		if instance then
			return script.vmt_entry(instance, index, t)(instance, ...)
		end
	end
end

script.vmt_bind = function(module, interface, index, typestring)
	local success, typeof = pcall(ffi.typeof, typestring)
	local instance = memory.create_interface(module, interface) or error(("[%s]Invalid interface"):format(script.script_name))
	if not success then
		error(("[%s]vmt error: %s"):format(script.script_name, typeof), 2)
	end

	local fnptr = script.vmt_entry(instance, index, typeof) or error(("[%s]invalid vtable"):format(script.script_name))
	return function(...)
		return fnptr(instance, ...)
	end
end

script.get_client_handle = function(entity)
	if (type(entity) == "number" and entity == - 1) or (type(entity) ~= "number" and not script.is_alive(entity)) then
		return false
	end

	if type(entity) == "number" then
		local address = script.get_client_entity_uintptr_address(script.entity_list_pointer, entity)
		if address then
			return address
		end

		return false
	end

	local address = script.get_client_entity(script.ientitylist, entity:get_index())
	if address then
		return address
	end

	return false
end

script.get_anim_overlay = function(layer_index)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	local ent_ptr = ffi.cast("void***", script.get_client_handle(local_player:get_index()))
	return ffi.cast(animation_layer_t, ffi.cast("char*", ent_ptr) + 0x2990)[0][layer_index] 
end

script.get_model_lib = script.vmt_thunk(8, "const void*(__thiscall*)(void*)")
script.get_client_unknown_lib = script.vmt_thunk(0, "void*(__thiscall*)(void*)")
script.get_client_renderable_lib = script.vmt_thunk(5, "void*(__thiscall*)(void*)")
script.get_sequence_activity_match = memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 8B F1 83")
script.get_sequence_activity_lib = ffi.cast("int(__fastcall*)(void*, void*, int)", script.get_sequence_activity_match)
script.get_studio_model_lib = script.vmt_bind("engine.dll", "VModelInfoClient004", 32, "void*(__thiscall*)(void*, const void*)")
script.get_sequence_activity = function(ent, sequence)
	local get_client_networkable = function(ent)
		return script.get_client_networkable_lib(ent:get_index())
	end

	local get_model = function(ent)
		local client_ptr = ffi.cast("void***", get_client_networkable(ent))
		local unknown_ptr = ffi.cast("void***", script.get_client_unknown_lib(client_ptr))
		local renderable_ptr = ffi.cast("void***", script.get_client_renderable_lib(unknown_ptr))
		return script.get_model_lib(renderable_ptr)
	end

	local hdr = script.get_studio_model_lib(get_model(ent))
	if not hdr then
		return - 1
	end

	return script.get_sequence_activity_lib(script.get_client_handle(ent), hdr, sequence)
end

script.get_anim_state = function()
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	local ptr_address = script.get_client_handle(local_player:get_index())
	if not ptr_address then
		return false
	end

	local ent_ptr = ffi.cast("void***", ptr_address)
	return ffi.cast(animation_state_t, ffi.cast("char*", ent_ptr) + 0x9960)[0]
end

script.get_lowerbody_update = function()
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return {false, 0}
	end

	local anim_state = script.get_anim_state()
	local lower_body = script.get_anim_overlay(3)
	if not script.lowerbody_update.updating then
		script.lowerbody_update.next_update = global_vars.cur_time() + 0.22
	elseif script.get_sequence_activity(local_player, lower_body.sequence) == 979 then
		if script.lowerbody_update.next_update < global_vars.cur_time() and lower_body.weight > 0.000 then
			script.lowerbody_update.next_update = global_vars.cur_time() + 1.1
		end
	end

	script.lowerbody_update.updating = anim_state.on_ground and anim_state.m_velocity < 0.1 and anim_state.anim_update_timer > 0.0
	return {
		script.lowerbody_update.updating,
		(script.lowerbody_update.next_update - global_vars.cur_time()) / 1.1 * 1
	}
end

script.create_animation_update = function()
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return false
	end

	local anim_state = script.get_anim_state()
	local active_weapon = local_player:get_active_weapon()
	if not active_weapon or active_weapon == nil then
		return false
	end

	local function clamp(val, min_val, max_val)
		return math.max(min_val, math.min(max_val, val))
	end

	local function anglemod(a)
		return (360 / 65536) * bit.band(math.floor(a * (65536 / 360)), 65535)
	end

	local function normalize_angle(angle)
		while angle > 180 do
			angle = angle - 360
		end

		while angle < - 180 do
			angle = angle + 360
		end

		return angle
	end

	local ret_thing = function(n, ...)
		local type = {}
		local _arr = { ... }
		for i = 1, #_arr do
			type[#type + 1] = _arr[i]
		end

		if type[n] == nil then
			return unpack(_arr)
		end

		return type[n]
	end

	local function angle_diff(dest_angle, src_angle)
		local delta = math.fmod(dest_angle - src_angle, 360)
		if dest_angle > src_angle then
			if delta >= 180 then
				delta = delta - 360
			end
		else
			if delta <= - 180 then
				delta = delta + 360
			end
		end

		return delta
	end

	local function approach_angle(target, value, speed)
		target = anglemod(target)
		value = anglemod(value)
		local delta = target - value
		if speed < 0 then
			speed = - speed
		end

		if delta < - 180 then
			delta = delta + 360
		elseif delta > 180 then
			delta = delta - 360
		end

		if delta > speed then
			value = value + speed
		elseif delta < - speed then
			value = value - speed
		else
			value = target
		end

		return value
	end

	if anim_state.anim_update_timer <= 0.0 then
		script.m_current_data.antiaim_funcs.eye_angles_y, script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = nil, nil
		script.m_current_data.antiaim_funcs.stop_to_full_running_fraction, script.m_current_data.antiaim_funcs.speed = 0, 0
		return 0
	end

	if script.m_current_data.antiaim_funcs.eye_angles_y == nil or script.m_current_data.antiaim_funcs.srv_goal_feet_yaw == nil then
		script.m_current_data.antiaim_funcs.eye_angles_y = anim_state.eye_angles_y
		script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = anim_state.goal_feet_yaw
	end

	local tickinterval = global_vars.interval_per_tick()
	local max_movement_speed = active_weapon and active_weapon:get_weapon_data().max_speed or 260
	local running_speed = clamp(script.m_current_data.antiaim_funcs.speed / (max_movement_speed * 0.520), 0, 1)
	local eye_feet_delta = angle_diff(script.m_current_data.antiaim_funcs.eye_angles_y, script.m_current_data.antiaim_funcs.srv_goal_feet_yaw)
	local yaw_modifier = (((script.m_current_data.antiaim_funcs.stop_to_full_running_fraction * - 0.3) - 0.2) * running_speed) + 1
	local max_yaw_modifier, min_yaw_modifier = yaw_modifier * 58, yaw_modifier * - 58
	script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = clamp(script.m_current_data.antiaim_funcs.srv_goal_feet_yaw, - 360, 360)
	if eye_feet_delta <= max_yaw_modifier then
		if min_yaw_modifier > eye_feet_delta then
			script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = math.abs(min_yaw_modifier) + script.m_current_data.antiaim_funcs.eye_angles_y
		end
	else
		script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = script.m_current_data.antiaim_funcs.eye_angles_y - math.abs(max_yaw_modifier)
	end

	if script.m_current_data.antiaim_funcs.speed > 0.1 then
		script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = approach_angle(
			script.m_current_data.antiaim_funcs.eye_angles_y,
			normalize_angle(script.m_current_data.antiaim_funcs.srv_goal_feet_yaw),
			((script.m_current_data.antiaim_funcs.stop_to_full_running_fraction * 20) + 30) * tickinterval
		)
	else
		script.m_current_data.antiaim_funcs.srv_goal_feet_yaw = approach_angle(
			local_player:get_prop("m_flLowerBodyYawTarget"),
			normalize_angle(script.m_current_data.antiaim_funcs.srv_goal_feet_yaw), 
			tickinterval * 100
		)
	end

	if engine.get_choked_commands() == 0 then
		script.m_current_data.antiaim_funcs.feet_yaw = anim_state.goal_feet_yaw
		script.m_current_data.antiaim_funcs.eye_angles_y = anim_state.eye_angles_y
		script.m_current_data.antiaim_funcs.desync_data.abs_yaw = anim_state.eye_angles_y
		script.m_current_data.antiaim_funcs.desync_data.feet_yaw = anim_state.goal_feet_yaw
		script.m_current_data.antiaim_funcs.get_desync_inverter = antiaim.get_desync_side() == 2
		script.m_current_data.antiaim_funcs.speed = math.min(script.get_velocity(local_player), 260)
		script.m_current_data.antiaim_funcs.desync_data.stand_height = anim_state.standing_head_height
		script.m_current_data.antiaim_funcs.desync_data.server_feet_yaw = script.m_current_data.antiaim_funcs.srv_goal_feet_yaw
		script.m_current_data.antiaim_funcs.stop_to_full_running_fraction = anim_state.stop_to_full_running_fraction
		script.m_current_data.antiaim_funcs.desync_data.desync_body_lean = math.abs(angle_diff(script.m_current_data.antiaim_funcs.eye_angles_y, script.m_current_data.antiaim_funcs.desync_data.feet_yaw))
		script.m_current_data.antiaim_funcs.desync_data.desync_delta_angle_exact = angle_diff(script.m_current_data.antiaim_funcs.desync_data.server_feet_yaw, script.m_current_data.antiaim_funcs.desync_data.feet_yaw)
		script.m_current_data.antiaim_funcs.desync_data.desync_delta_angle = clamp(script.m_current_data.antiaim_funcs.desync_data.desync_delta_angle_exact, - script.m_current_data.antiaim_funcs.desync_data.desync_body_lean, script.m_current_data.antiaim_funcs.desync_data.desync_body_lean)
	end

	return ret_thing(n, script.m_current_data.antiaim_funcs.desync_data.feet_yaw, script.m_current_data.antiaim_funcs.desync_data.server_feet_yaw)
end

script.get_antiaim_data = function()
	local function anglemod(a)
		return (360 / 65536) * bit.band(math.floor(a * (65536 / 360)), 65535)
	end

	local function normalize_angle(angle)
		while angle > 180 do
			angle = angle - 360
		end

		while angle < - 180 do
			angle = angle + 360
		end

		return angle
	end

	local ret_thing = function(n, ...)
		local type = {}
		local _arr = { ... }
		for i = 1, #_arr do
			type[#type + 1] = _arr[i]
		end

		if type[n] == nil then
			return unpack(_arr)
		end

		return type[n]
	end

	local function angle_diff(dest_angle, src_angle)
		local delta = math.fmod(dest_angle - src_angle, 360)
		if dest_angle > src_angle then
			if delta >= 180 then
				delta = delta - 360
			end
		else
			if delta <= - 180 then
				delta = delta + 360
			end
		end

		return delta
	end

	local function approach_angle(target, value, speed)
		value = anglemod(value)
		target = anglemod(target)
		local delta = target - value
		if speed < 0 then
			speed = - speed
		end

		if delta < - 180 then
			delta = delta + 360
		elseif delta > 180 then
			delta = delta - 360
		end

		if delta > speed then
			value = value + speed
		elseif delta < - speed then
			value = value - speed
		else
			value = target
		end

		return value
	end

	local weapon_ready = function()
		local local_player = entity_list.get_local_player()
		if not script.is_alive(local_player) then
			return false
		end

		local weapon = local_player:get_active_weapon()
		if weapon == nil then
			return false
		end

		local get_curtime = function(nOffset)
			return global_vars.cur_time() - (nOffset * global_vars.interval_per_tick())
		end

		if get_curtime(16) < local_player:get_prop("m_flNextAttack") then 
			return false
		end

		if get_curtime(0) < weapon:get_prop("m_flNextPrimaryAttack") then
			return false
		end

		return true
	end

	return {
		approach_angle = function(target, value, speed)
			return approach_angle(target, value, speed)
		end,

		angle_diff = function(dest_angle, src_angle) return
			angle_diff(dest_angle, src_angle)
		end,

		normalize_angle = function(angle)
			return normalize_angle(angle)
		end,

		get_abs_yaw = function()
			return script.m_current_data.antiaim_funcs.desync_data.abs_yaw
		end,

		get_balance_adjust = function()
			return script.ffi_handler.get_lowerbody_update()
		end,

		get_body_yaw = function(n)
			return ret_thing(n, script.m_current_data.antiaim_funcs.desync_data.feet_yaw, script.m_current_data.antiaim_funcs.desync_data.server_feet_yaw)
		end,

		get_desync = function(n)
			return ret_thing(n, script.m_current_data.antiaim_funcs.desync_data.desync_delta_angle, script.m_current_data.antiaim_funcs.desync_data.desync_delta_angle_exact)
		end,

		get_overlap = function(rotation)
			local client, server, lean = script.m_current_data.antiaim_funcs.desync_data.feet_yaw, script.m_current_data.antiaim_funcs.desync_data.server_feet_yaw, angle_diff(script.m_current_data.antiaim_funcs.desync_data.abs_yaw, script.m_current_data.antiaim_funcs.desync_data.feet_yaw)
			if type(rotation) == "number" then
				local client_bodylean = math.abs(lean)
				client = clamp(
					rotation, 
					script.m_current_data.antiaim_funcs.desync_data.abs_yaw - client_bodylean, script.m_current_data.antiaim_funcs.desync_data.abs_yaw + client_bodylean
				)

			elseif type(rotation) == "boolean" and rotation then
				client = script.m_current_data.antiaim_funcs.desync_data.abs_yaw + lean
			end
	
			local adiff = math.abs(angle_diff(client, server))
			return 1 - (adiff / 120 * 1), client
		end
	}
end

script.key_modifier = function(key, mode)
	local m_key = type(key) == "number" and key or key:get_key()
	local m_mode = type(mode) == "number" and mode or mode:get_mode()
	local cache_key = ("%s %s"):format(type(key) == "number" and key or key:get_name(), m_mode)
	if script.m_current_data.m_key_modes[cache_key] == nil then
		script.m_current_data.m_key_modes[cache_key] = {
			state = false,
			holding = false,
			switcher = false
		}
	end

	if m_mode == 0 then
		if input.is_key_held(m_key) and not script.m_current_data.m_key_modes[cache_key].holding then
			script.m_current_data.m_key_modes[cache_key].holding = true
			script.m_current_data.m_key_modes[cache_key].switcher = input.is_key_held(m_key)
			script.m_current_data.m_key_modes[cache_key].state = not script.m_current_data.m_key_modes[cache_key].state
		elseif not input.is_key_held(m_key) then
			script.m_current_data.m_key_modes[cache_key].holding = false
		end

	elseif m_mode == 1 then
		script.m_current_data.m_key_modes[cache_key].state = input.is_key_held(m_key)
	elseif m_mode == 2 then
		script.m_current_data.m_key_modes[cache_key].state = not input.is_key_held(m_key)
	elseif m_mode == 3 then
		script.m_current_data.m_key_modes[cache_key].state = true
	elseif m_mode == 4 then
		script.m_current_data.m_key_modes[cache_key].state = false
	end

	return script.m_current_data.m_key_modes[cache_key].state
end

script.manual_modifier_keys = function()
	local m_state = manual_state_slider:get()
	local left_state, right_state, backward_state, forward_state = input.is_key_held(left_side_key:get_key()), input.is_key_held(right_side_key:get_key()), input.is_key_held(back_side_key:get_key()), input.is_key_held(forward_side_key:get_key())
	if left_state == script.m_current_data.bind_system.left and right_state == script.m_current_data.bind_system.right and backward_state == script.m_current_data.bind_system.back and forward_state == script.m_current_data.bind_system.forward then
		return
	end

	script.m_current_data.bind_system.left, script.m_current_data.bind_system.right, script.m_current_data.bind_system.back, script.m_current_data.bind_system.forward = left_state, right_state, backward_state, forward_state
	if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) or (forward_state and m_state == 4) then
		manual_state_slider:set(0)
		return
	end

	if left_state and m_state ~= 1 then
		manual_state_slider:set(1)
	end

	if right_state and m_state ~= 2 then
		manual_state_slider:set(2)
	end

	if backward_state and m_state ~= 3 then
		manual_state_slider:set(3)
	end

	if forward_state and m_state ~= 4 then
		manual_state_slider:set(4)
	end
end

script.m_handle_menu = function()
	if not menu.is_open() then
		return
	end

	manual_state_slider:set_visible(false)
	manual_left:set_visible(enabled_antiaim:get())
	manual_right:set_visible(enabled_antiaim:get())
	anti_backstab:set_visible(enabled_antiaim:get())
	manual_forward:set_visible(enabled_antiaim:get())
	manual_backward:set_visible(enabled_antiaim:get())
	antiaim_desync_side:set_visible(enabled_antiaim:get())
	antiaim_player_state:set_visible(enabled_antiaim:get())
	switcher_desync_side:set_visible(enabled_antiaim:get())
	for i, side_element in pairs(script.m_current_data.m_custom_element) do
		for idx, data in pairs(side_element) do
			data.enabled:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and idx ~= 1)
			data.pitch:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.yaw_base:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.yaw_jitter:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.body_yaw:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.desync_on_shot:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get())
			data.yaw_jitter_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.yaw_jitter:get() ~= 1)
			data.fake_yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1)
			data.fake_yaw_stypes:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1)
			data.body_yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1)
			data.extended_modes:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1)
			data.onshot_yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.desync_on_shot:get())
			data.desync_on_shot_stypes:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.desync_on_shot:get())
			data.onshot_fake_yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.desync_on_shot:get())
			data.onshot_yaw_jitter_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.desync_on_shot:get())
			data.onshot_body_yaw_offset:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.desync_on_shot:get())
			data.freestanding_body_stypes:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1)
			data.fake_yaw_offset_delay:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1 and data.fake_yaw_stypes:get() == 4)
			data.fake_yaw_offset_extended:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1 and data.fake_yaw_stypes:get() ~= 1)
			data.anti_brute_force_mode:set_visible(enabled_antiaim:get() and antiaim_desync_side:get() == i and antiaim_player_state:get() == idx and data.enabled:get() and data.body_yaw:get() ~= 1 and data.extended_modes:get("反暴力[Anti-brute force]"))
		end
	end
end

script.run_rotation = function(min, max, single, key)
	local m_min = math.min(min, max)
	local m_max = math.max(min, max)
	local m_key = key and key or ("%s %s %s"):format(min, max, single)
	if script.m_current_data.cache_rotation[m_key] == nil then
		script.m_current_data.cache_rotation[m_key] = {
			var = m_min,
			switcher = false
		}
	end

	if engine.get_choked_commands() == 0 then
		if single then
			script.m_current_data.cache_rotation[m_key].var = script.m_current_data.cache_rotation[m_key].var + 1
			if script.m_current_data.cache_rotation[m_key].var > m_max then
				script.m_current_data.cache_rotation[m_key].var = m_min
			end

		elseif not single then
			if not script.m_current_data.cache_rotation[m_key].switcher then
				script.m_current_data.cache_rotation[m_key].var = script.m_current_data.cache_rotation[m_key].var + 1
				if script.m_current_data.cache_rotation[m_key].var > m_max then
					script.m_current_data.cache_rotation[m_key].var = m_max
					script.m_current_data.cache_rotation[m_key].switcher = true
				end

			elseif script.m_current_data.cache_rotation[m_key].switcher then
				script.m_current_data.cache_rotation[m_key].var = script.m_current_data.cache_rotation[m_key].var - 1
				if script.m_current_data.cache_rotation[m_key].var < m_min then
					script.m_current_data.cache_rotation[m_key].var = m_min
					script.m_current_data.cache_rotation[m_key].switcher = false
				end
			end
		end
	end

	return script.m_current_data.cache_rotation[m_key].var
end

script.register_fast_shot = function(entity)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return false
	end

	local active_weapon = local_player:get_active_weapon()
	local last_shot_time = active_weapon:get_prop("m_fLastShotTime")
	local item_index = active_weapon:get_prop("m_iItemDefinitionIndex")
	if script.m_current_data.m_shot_data.CurrentIndex ~= item_index then
		script.m_current_data.m_shot_data.CurrentIndex = item_index
		script.m_current_data.m_shot_data.LastShotTime = last_shot_time
	end

	if script.m_current_data.m_shot_data.LastShotTime ~= last_shot_time then
		script.m_current_data.m_shot_data.RegisterAddState = true
		script.m_current_data.m_shot_data.LastShotTime = last_shot_time
		return true
	end

	if script.m_current_data.m_shot_data.RegisterAddState then
		script.m_current_data.m_shot_data.RegisterAddState = false
		return true
	end

	return false
end

script.player_visible = function()
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return false
	end

	for idx, ptr in pairs(entity_list.get_players(true)) do
		if script.is_alive(ptr) and local_player:is_point_visible(ptr:get_hitbox_pos(e_hitboxes.HEAD)) then
			return true
		end
	end

	return false
end

script.player_peeking = function(predict)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return false
	end

	local velocity = local_player:get_prop("m_vecVelocity")
	local head_pos = local_player:get_hitbox_pos(e_hitboxes.HEAD)
	local predicted_vector = predict and vec3_t(
		head_pos.x + (velocity.x / 220) * 128,
		head_pos.y + (velocity.y / 220) * 128,
		head_pos.z + (velocity.z / 220) * 128
	) or head_pos

	for idx, ptr in pairs(entity_list.get_players(true)) do
		local trace_data = trace.bullet(predicted_vector, ptr:get_hitbox_pos(e_hitboxes.HEAD), local_player, ptr)
		if script.is_alive(ptr) and trace_data.damage > 0 then
			return true
		end
	end

	return false
end

script.g_CanAttack = function(tickbase_buffer, bool_1, bool_2)
	if bool_1 == nil then
		bool_1 = true
	end

	if bool_2 == nil then
		bool_2 = true
	end

	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return false
	end

	local active_weapon = local_player:get_active_weapon()
	if not active_weapon then
		return false
	end

	local local_tickbase = local_player:get_prop("m_nTickBase")
	local interval = global_vars.interval_per_tick() * (local_tickbase - tickbase_buffer)
	if active_weapon == nil then
		return false
	end

	if interval < local_player:get_prop("m_flNextAttack") and bool_1 then
		return false
	end

	if interval < active_weapon:get_prop("m_flNextPrimaryAttack") and bool_2 then
		return false
	end

	return true
end

script.calculate_player_state = function(switcher)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	local player_state = 1
	local velocity = script.get_velocity(local_player)
	local m_element = function(idx)
		return script.m_current_data.m_custom_element[switcher and 2 or 1][idx].enabled:get()
	end

	if m_element(2) and velocity < 5 then
		player_state = 2
	end

	if m_element(3) and velocity > 5 then
		player_state = 3
	end

	if m_element(4) and script.m_reference.slow_walk[2]:get() then
		player_state = 4
	end

	if m_element(5) and script.is_jumping(local_player) then
		player_state = 5
	end

	if m_element(6) and script.is_ducking(local_player) and local_player:get_prop("m_iTeamNum") == 2 then
		player_state = 6
	end

	if m_element(7) and script.is_ducking(local_player) and local_player:get_prop("m_iTeamNum") ~= 2 then
		player_state = 7
	end

	if m_element(8) and script.player_peeking(true) then
		player_state = 8
	end

	if m_element(9) and script.player_peeking(false) then
		player_state = 9
	end

	if m_element(10) and script.player_visible() then
		player_state = 10
	end

	if m_element(11) and not script.g_CanAttack(13) then
		player_state = 11
	end

	if m_element(12) and manual_state_slider:get() == 1 then
		player_state = 12
	end

	if m_element(13) and manual_state_slider:get() == 2 then
		player_state = 13
	end

	if m_element(14) and manual_state_slider:get() == 3 then
		player_state = 14
	end

	if m_element(15) and manual_state_slider:get() == 4 then
		player_state = 15
	end

	return player_state
end

script.NormalizeYaw = function(flYaw)
	while flYaw > 180 do
		flYaw = flYaw - 360
	end

	while flYaw < - 180 do
		flYaw = flYaw + 360
	end

	return flYaw
end

script.m_reference = {
	pitch = menu.find("antiaim", "main", "angles", "pitch"),
	desync_side = menu.find("antiaim", "main", "desync", "side"),
	yaw_base = menu.find("antiaim", "main", "angles", "yaw base"),
	yaw_offset = menu.find("antiaim", "main", "angles", "yaw add"),
	slow_walk = menu.find("misc", "main", "movement", "slow walk"),
	fakelag_amount = menu.find("antiaim", "main", "fakelag", "amount"),
	override_stand = menu.find("antiaim", "main", "desync", "override stand"),
	move_antibrute_mode = menu.find("antiaim", "main", "desync", "move", "on shot"),
	stand_antibrute_mode = menu.find("antiaim", "main", "desync", "stand", "on shot"),
	move_left_amount = menu.find("antiaim", "main", "desync", "move", "left amount"),
	stand_left_amount = menu.find("antiaim", "main", "desync", "stand", "left amount"),
	move_antibrute = menu.find("antiaim", "main", "desync", "move", "anti bruteforce"),
	stand_antibrute = menu.find("antiaim", "main", "desync", "stand", "anti bruteforce"),
	slow_antibrute_mode = menu.find("antiaim", "main", "desync", "slow walk", "on shot"),
	stand_right_amount = menu.find("antiaim", "main", "desync", "stand", "right amount"),
	move_right_amount = menu.find("antiaim", "main", "desync", "move", "right amount"),
	slow_antibrute = menu.find("antiaim", "main", "desync", "slow walk", "anti bruteforce"),
	slow_left_amount = menu.find("antiaim", "main", "desync", "slow walk", "right amount"),
	slow_right_amount = menu.find("antiaim", "main", "desync", "slow walk", "right amount"),
}

script.m_anti_backstab = function()
	local local_player = entity_list.get_local_player()
	if not anti_backstab:get() or not script.is_alive(local_player) then
		return false
	end

	local g_FeetDistance = function(local_entity, target_entity)
		local function GetDistanceInMeter(a_x, a_y, a_z, b_x, b_y, b_z)
			return math.ceil(math.sqrt(math.pow(a_x - b_x, 2) + math.pow(a_y - b_y, 2) + math.pow(a_z - b_z, 2)) * 0.0254)
		end

		return GetDistanceInMeter(local_entity.x, local_entity.y, local_entity.z, target_entity.x, target_entity.y, target_entity.z)
	end

	for idx, ptr in pairs(entity_list.get_players(true)) do
		local should_weapon = ptr:get_active_weapon()
		if should_weapon then
			local is_knife = should_weapon:get_weapon_data().type == e_weapon_types.KNIFE
			if script.is_alive(ptr) and is_knife and g_FeetDistance(local_player:get_render_origin(), ptr:get_render_origin()) < 7 and local_player:is_point_visible(ptr:get_hitbox_pos(e_hitboxes.HEAD)) then
				return true
			end
		end
	end

	return false
end

script.m_event_handle = function(event)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	if event.name == "weapon_fire" and entity_list.get_player_from_userid(event.userid) == local_player then
		script.m_current_data.m_should_shooting = true
		script.m_current_data.m_shooting_ticks = global_vars.real_time()
	end
end

script.desync_extended = function(e)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	script.manual_modifier_keys()
	local switcher = script.key_modifier(switcher_desync_key, switcher_desync_key)
	local m_calculate_desync_cur_player_state = script.calculate_player_state(switcher)
	local m_current_element = script.m_current_data.m_custom_element[switcher and 2 or 1][m_calculate_desync_cur_player_state]
	if engine.get_choked_commands() == 0 then
		script.m_current_data.desync_flip = not script.m_current_data.desync_flip
	end

	if engine.get_choked_commands() == 0 then
		script.m_current_data.should_motion_flip = script.m_current_data.should_motion_flip + 1
		if script.m_current_data.should_motion_flip >= 2 then
			script.m_current_data.motion_flip = not script.m_current_data.motion_flip
			script.m_current_data.should_motion_flip = 0
		end
	end

	local is_visible = script.player_visible()
	local yaw_jitter = m_current_element.yaw_jitter:get()
	local body_yaw = m_current_element.body_yaw:get()
	local yaw_offset = m_current_element.yaw_offset:get()
	local fake_yaw = m_current_element.fake_yaw_stypes:get()
	local fake_yaw_offset = m_current_element.fake_yaw_offset:get()
	local yaw_jitter_offset = m_current_element.yaw_jitter_offset:get()
	local body_yaw_offset = m_current_element.body_yaw_offset:get()
	local fake_yaw_delay = m_current_element.fake_yaw_offset_delay:get()
	local jitter_desync = m_current_element.extended_modes:get("切换[Jitter]")
	local anti_bruteforce_mode = m_current_element.anti_brute_force_mode:get()
	local anti_overlap = m_current_element.extended_modes:get("反重合[Anti-overlap]")
	local freestanding_body_stypes = m_current_element.freestanding_body_stypes:get()
	local fake_yaw_offset_extended = m_current_element.fake_yaw_offset_extended:get()
	local anti_bruteforce = m_current_element.extended_modes:get("反暴力[Anti-brute force]")
	local randomized_jitter_desync = m_current_element.extended_modes:get("随机切换[Randomize jitter]")
	if yaw_jitter == 2 then
		yaw_offset = script.NormalizeYaw(yaw_offset + (script.m_current_data.desync_flip and yaw_jitter_offset or 0))
	elseif yaw_jitter == 3 then
		local yaw_jitter_center = math.floor((math.abs(yaw_jitter_offset) / 2) + 0.5)
		yaw_offset = script.NormalizeYaw(yaw_offset + (script.m_current_data.desync_flip and yaw_jitter_center or - yaw_jitter_center))
	elseif yaw_jitter == 4 then
		yaw_offset = script.NormalizeYaw(yaw_offset + math.random(0, yaw_jitter_offset))
	end

	if body_yaw == 2 then
		body_yaw_offset = body_yaw_offset
	elseif body_yaw == 3 then
		body_yaw_offset = script.m_current_data.desync_flip and body_yaw_offset or - body_yaw_offset
	elseif body_yaw == 4 then
		body_yaw_offset = script.m_current_data.motion_flip and body_yaw_offset or - body_yaw_offset
	elseif body_yaw == 5 then
		body_yaw_offset = math.random(- body_yaw_offset, body_yaw_offset)
	end

	if jitter_desync then
		body_yaw_offset = script.m_current_data.desync_flip and body_yaw_offset or - body_yaw_offset
		if randomized_jitter_desync then
			body_yaw_offset = math.random(0, 1) == 1 and body_yaw_offset or - body_yaw_offset
		end
	end

	if body_yaw == 1 then
		fake_yaw_offset = 0
		body_yaw_offset = 0
	else
		if fake_yaw == 2 then
			fake_yaw_offset = script.m_current_data.desync_flip and fake_yaw_offset or fake_yaw_offset_extended
		elseif fake_yaw == 3 then
			fake_yaw_offset = math.random(fake_yaw_offset, fake_yaw_offset_extended)
		elseif fake_yaw == 4 then
			if script.m_current_data.switcher_delay < global_vars.real_time() then
				script.m_current_data.switcher_amount = math.random(fake_yaw_offset, fake_yaw_offset_extended)
				script.m_current_data.switcher_delay = global_vars.real_time() + fake_yaw_delay
			end

			fake_yaw_offset = script.m_current_data.switcher_amount
		elseif fake_yaw == 5 then
			fake_yaw_offset = script.run_rotation(fake_yaw_offset, fake_yaw_offset_extended, true, "Single Fake Yaw")
		elseif fake_yaw == 6 then
			fake_yaw_offset = script.run_rotation(fake_yaw_offset, fake_yaw_offset_extended, false, "Rotation Fake Yaw")
		end
	end

	local desync_on_shot = m_current_element.desync_on_shot:get()
	local desync_on_shot_stypes = m_current_element.desync_on_shot_stypes:get()
	local desync_on_shot_yaw_offset = m_current_element.onshot_yaw_offset:get()
	local desync_on_shot_fake_yaw_offset = m_current_element.onshot_fake_yaw_offset:get()
	local desync_on_shot_yaw_jitter_offset = m_current_element.onshot_yaw_jitter_offset:get()
	local desync_on_shot_body_yaw_offset = m_current_element.onshot_body_yaw_offset:get()
	if desync_on_shot and script.m_current_data.m_should_shooting then
		local max_time = math.min(global_vars.real_time() - script.m_current_data.m_shooting_ticks, 1)
		if script.m_current_data.m_shooting_ticks > 0 then
			if desync_on_shot_stypes == 1 then
				local prev_yaw_offset = math.abs(desync_on_shot_yaw_offset) * (max_time)
				local prev_jitter_offset = math.abs(desync_on_shot_yaw_jitter_offset) * (max_time)
				local prev_fake_yaw_offset = math.abs(desync_on_shot_fake_yaw_offset) * (max_time)
				local prev_body_yaw_offset = math.abs(desync_on_shot_body_yaw_offset) * (max_time)
				local current_yaw_offset = desync_on_shot_yaw_offset > 0 and prev_yaw_offset or - prev_yaw_offset
				local current_jitter_offset = desync_on_shot_yaw_jitter_offset > 0 and prev_jitter_offset or - prev_jitter_offset
				fake_yaw_offset = desync_on_shot_fake_yaw_offset > 0 and prev_fake_yaw_offset or - prev_fake_yaw_offset
				body_yaw_offset = desync_on_shot_body_yaw_offset > 0 and prev_body_yaw_offset or - prev_body_yaw_offset
				yaw_offset = script.NormalizeYaw(current_yaw_offset + (script.m_current_data.desync_flip and current_jitter_offset or 0))
			elseif desync_on_shot_stypes == 2 then
				local prev_yaw_offset = math.abs(desync_on_shot_yaw_offset) * (1 - max_time)
				local prev_jitter_offset = math.abs(desync_on_shot_yaw_jitter_offset) * (1 - max_time)
				local prev_fake_yaw_offset = math.abs(desync_on_shot_fake_yaw_offset) * (1 - max_time)
				local prev_body_yaw_offset = math.abs(desync_on_shot_body_yaw_offset) * (1 - max_time)
				local current_yaw_offset = desync_on_shot_yaw_offset > 0 and prev_yaw_offset or - prev_yaw_offset
				local current_jitter_offset = desync_on_shot_yaw_jitter_offset > 0 and prev_jitter_offset or - prev_jitter_offset
				fake_yaw_offset = desync_on_shot_fake_yaw_offset > 0 and prev_fake_yaw_offset or - prev_fake_yaw_offset
				body_yaw_offset = desync_on_shot_body_yaw_offset > 0 and prev_body_yaw_offset or - prev_body_yaw_offset
				yaw_offset = script.NormalizeYaw(current_yaw_offset + (script.m_current_data.desync_flip and current_jitter_offset or 0))
			elseif desync_on_shot_stypes == 3 then
				local prev_yaw_offset = math.abs(desync_on_shot_yaw_offset)
				local prev_jitter_offset = math.abs(desync_on_shot_yaw_jitter_offset)
				local prev_fake_yaw_offset = math.abs(desync_on_shot_fake_yaw_offset)
				local prev_body_yaw_offset = math.abs(desync_on_shot_body_yaw_offset)
				local current_yaw_offset = desync_on_shot_yaw_offset > 0 and prev_yaw_offset or - prev_yaw_offset
				local current_jitter_offset = desync_on_shot_yaw_jitter_offset > 0 and prev_jitter_offset or - prev_jitter_offset
				fake_yaw_offset = desync_on_shot_fake_yaw_offset > 0 and prev_fake_yaw_offset or - prev_fake_yaw_offset
				body_yaw_offset = desync_on_shot_body_yaw_offset > 0 and prev_body_yaw_offset or - prev_body_yaw_offset
				yaw_offset = script.NormalizeYaw(current_yaw_offset + (script.m_current_data.desync_flip and current_jitter_offset or 0))
			elseif desync_on_shot_stypes == 4 then
				local prev_yaw_offset = - math.abs(desync_on_shot_yaw_offset)
				local prev_jitter_offset = - math.abs(desync_on_shot_yaw_jitter_offset)
				local prev_fake_yaw_offset = - math.abs(desync_on_shot_fake_yaw_offset)
				local prev_body_yaw_offset = - math.abs(desync_on_shot_body_yaw_offset)
				local current_yaw_offset = desync_on_shot_yaw_offset > 0 and prev_yaw_offset or - prev_yaw_offset
				local current_jitter_offset = desync_on_shot_yaw_jitter_offset > 0 and prev_jitter_offset or - prev_jitter_offset
				fake_yaw_offset = desync_on_shot_fake_yaw_offset > 0 and prev_fake_yaw_offset or - prev_fake_yaw_offset
				body_yaw_offset = desync_on_shot_body_yaw_offset > 0 and prev_body_yaw_offset or - prev_body_yaw_offset
				yaw_offset = script.NormalizeYaw(current_yaw_offset + (script.m_current_data.desync_flip and current_jitter_offset or 0))
			end
		end

		if max_time == 1 then
			script.m_current_data.m_shooting_ticks = 0
			script.m_current_data.m_should_shooting = false
		end
	end

	script.m_reference.desync_side:set(3)
	e:set_invert_desync(body_yaw_offset < 0)
	if freestanding_body_stypes == 2 and not is_visible then
		script.m_reference.desync_side:set(5)
	elseif freestanding_body_stypes == 3 and not is_visible then
		script.m_reference.desync_side:set(6)
	end

	local make_fake_amount = (((math.abs(body_yaw_offset) + fake_yaw_offset) / 2) / 60) * 100
	if anti_overlap then
		local antiaim_funcs = script.get_antiaim_data()
		local desync_amount = antiaim_funcs.get_desync(1)
		local server, client = antiaim_funcs.get_overlap(true)
		if server > 0.6 then
			make_fake_amount = 100
			e:set_invert_desync(desync_amount > 0)
			script.m_reference.desync_side:set(desync_amount > 0 and 2 or 3)
		end
	end

	script.m_reference.override_stand:set(false)
	script.m_reference.yaw_offset:set(yaw_offset)
	script.m_reference.slow_antibrute:set(anti_bruteforce)
	script.m_reference.move_antibrute:set(anti_bruteforce)
	script.m_reference.stand_antibrute:set(anti_bruteforce)
	script.m_reference.pitch:set(m_current_element.pitch:get())
	script.m_reference.slow_left_amount:set(make_fake_amount)
	script.m_reference.move_left_amount:set(make_fake_amount)
	script.m_reference.stand_left_amount:set(make_fake_amount)
	script.m_reference.slow_right_amount:set(make_fake_amount)
	script.m_reference.move_right_amount:set(make_fake_amount)
	script.m_reference.stand_right_amount:set(make_fake_amount)
	script.m_reference.slow_antibrute_mode:set(anti_bruteforce_mode)
	script.m_reference.yaw_base:set(m_current_element.yaw_base:get())
	script.m_reference.stand_antibrute_mode:set(anti_bruteforce_mode)
	script.m_reference.move_antibrute_mode:set(anti_bruteforce_mode)
	if script.m_anti_backstab() then
		script.m_reference.yaw_base:set(4)
		script.m_reference.yaw_offset:set(180)
	end
end

--[[script.fakelag_extended = function(e)
	local local_player = entity_list.get_local_player()
	if not script.is_alive(local_player) then
		return
	end

	local m_shot = script.register_fast_shot()
	script.m_reference.fakelag_amount:set(m_shot and 1 or 15)
	if engine.get_choked_commands() < script.m_reference.fakelag_amount:get() then
		e:set_fakelag(true)
	end
end]]

callbacks.add(e_callbacks.PAINT, function()
	script.m_handle_menu()
end)

callbacks.add(e_callbacks.EVENT, function(e)
	script.m_event_handle(e)
end)

callbacks.add(e_callbacks.ANTIAIM, function(e)
	script.desync_extended(e)
	--script.fakelag_extended(e)
	script.create_animation_update(e)
end)