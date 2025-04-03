local flixwatermark_checkbox = menu.add_checkbox("Watermark", "Flixlua");
local function on_draw_watermark(watermark_text)
if flixwatermark_checkbox:get() then
    -- watermark
    return "Flixlua |  " .. user.name
	end
end

local dt_tog,dt_ref = menu.add_checkbox("Ragebot", "Best Double Tap")
local dt_speed = menu.add_slider("Ragebot", "Double Tap Speed",1,20)
    --change dt speed
	local function dt_tog() 
	if dt_tog:get() and dt_ref:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(dt_speed:get()+2)
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(20)
        cvars.cl_clock_correction:set_int(1)
	end
	end
	
local dt_rech_checkbox = menu.add_checkbox("Ragebot", "Faster Recharge")
	local function on_aimbot_shoot(shot)
	if dt_rech_checkbox:get() then
    exploits.force_recharge()
end
end

callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)

enabled = menu.add_checkbox("Exploit", "Auto teleport in air")
key     = enabled:add_keybind("Teleport keybind")
callbacks.add(e_callbacks.SETUP_COMMAND, strangerdranger)

function ent_speed_2d(entity)
    local velocity_x = entity:get_prop("m_vecVelocity[0]")
    local velocity_y = entity:get_prop("m_vecVelocity[1]")
    return math.sqrt((velocity_x * velocity_x) + (velocity_y * velocity_y))
end
local function Local_GetProp(prop_name, ...)
    local player = entity_list.get_local_player()
    return player:get_prop(prop_name, ...)
end

local ref_quickpeek = menu.find("aimbot","general","misc","autopeek")
local ref_safe_charge = menu.add_checkbox("Others","Safe Pick",false)

local function on_setup_command(cmd)
	if not cmd or not ref_safe_charge:get() then
		return
	end

	if ref_quickpeek[2]:get() and not client.can_fire() and not (exploits.get_charge() >= 14) then
		cmd.move = vec3_t()
	end 

end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)

callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
local fakeflick = menu.add_checkbox("FakeFlick", "Fake Flick");
local flickbind = fakeflick:add_keybind("fake flick");
local Inverter = menu.add_checkbox("FakeFlick", "Inverter");
local Inverterbind = Inverter:add_keybind("Inverter bind");
local yaw = menu.find("antiaim", "main", "angles", "yaw add")

local function on_antiaim(ctx)	

local TickcountModulo = global_vars.tick_count() % 17

if fakeflick:get() then
	Inverter:set_visible(true)
	local Flick = TickcountModulo == 10
	if (flickbind:get()) then
		if Flick then
			if Inverterbind:get() then
				yaw:set(-90)
			else
				
				yaw:set(90)
			end
		else
			yaw:set(0)
		end
	end
else
	Inverter:set_visible(false)
end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
--| Create the menu element(s)
local chinahat_checkbox = menu.add_checkbox("Visuals", "Enable China hat")
local rainbow_checkbox = menu.add_checkbox("Visuals", "Rainbow China hat")


--| The paint callback
local function on_paint()
if chinahat_checkbox:get() then
    -- Return if not in thirdperson
    if not client.is_in_thirdperson() then
        return
    end

    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Get the head origin
    local origin = local_player:get_hitbox_pos(e_hitboxes.HEAD) + vec3_t(0, 0, 10)
    
    -- Get the screen position of the head origin
    local screen_pos = render.world_to_screen(origin)
    if screen_pos == nil then
        return
    end

    -- Calculate the color
    local color = color_t(255, 255, 255, 55)
    if rainbow_checkbox:get() then
        color = color_t.from_hsb(global_vars.tick_count() % 360 / 360, 1, 1)
    end

    -- Calculate the hat edges
    local last_edge
    local view_yaw = engine.get_view_angles().y
    for angle_deg = 0, 360, 15 do
        -- Get the offset vector and set the Z to -5
        local offset_vector = angle_t(0, angle_deg + view_yaw, 0):to_vector():scaled(10)
        offset_vector.z = -5

        -- Get the screen position of the offset vector
        local screen_pos_edge = render.world_to_screen(origin + offset_vector)

        -- Draw the line
        if screen_pos_edge ~= nil then
            render.line(screen_pos, screen_pos_edge, color)
            if last_edge then
                render.line(last_edge, screen_pos_edge, color)
            end
            last_edge = screen_pos_edge
        end
    end
	end
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)


--local watermarkrm_checkbox = menu.add_checkbox("Watermark", "Remove Watermark");

--local function on_draw_watermark(watermark_text)
--if watermarkrm_checkbox():get() then
 --   return ""
	--end
--end
local ground_tick = 1
local end_time = 0
local on_land_checkbox = menu.add_checkbox("Others", "Pitch 0 on land");
local in_air_checkbox = menu.add_checkbox("Others", "Static legs in air");
callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	local lp = entity_list.get_local_player()
	local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
	local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
	local curtime = global_vars.cur_time() 
if on_land_checkbox:get() then
	if on_land == true then
		ground_tick = ground_tick + 1
	else
		ground_tick = 0
		end_time = curtime + 1
	end
	if ground_tick > 1 and end_time > curtime then
		ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
	end
	end
	if in_air_checkbox:get() then
	if in_air then
		ctx:set_render_pose(e_poses.JUMP_FALL, 1)
	end
	end
end)

local rawetrip_clantag = menu.add_checkbox("Clantag","Rawetrip")
local _set_clantag = ffi.cast('int(__fastcall*)(const char*, const char*)', memory.find_pattern('engine.dll', '53 56 57 8B DA 8B F9 FF 15'))
local _last_clantag = nil

local set_clantag = function(v)
  if v == _last_clantag then return end
  _set_clantag(v, v)
  _last_clantag = v
end

local tag = {
    '〄',
    '〄',
    'R >|〄',
    'RA >|〄',
    'R4W >|〄',
    'RAWЭ >|〄',
    'R4W3T >|〄',
    'RAWΣTR >|〄',
    'Я4WETRI >|〄',
    'RAWETRIP <|〄',
    'Я4WETRI <|〄',
    'RAWΣTR <|〄',
    'R4W3T <|〄',
    'RAWЭ <|〄',
    'R4W <|〄',
    'RA <|〄',
    'R <|〄',
    '〄',
    '〄',
} 

local engine_client_interface = memory.create_interface("engine.dll", "VEngineClient014")
local get_net_channel_info = ffi.cast("void*(__thiscall*)(void*)",memory.get_vfunc(engine_client_interface,78))
local net_channel_info = get_net_channel_info(ffi.cast("void***",engine_client_interface))
local get_latency = ffi.cast("float(__thiscall*)(void*,int)",memory.get_vfunc(tonumber(ffi.cast("unsigned long",net_channel_info)),9))

local function clantag_animation()
    if not engine.is_connected() then return end

    local latency = get_latency(ffi.cast("void***",net_channel_info),1) / global_vars.interval_per_tick()
    local tickcount_pred = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount_pred / 64, #tag) + 1)
    if rawetrip_clantag:get() then
        set_clantag(tag[iter])
    else
        set_clantag("")
    end 
end

local function clantag_destroy()
    set_clantag("")
end

callbacks.add(e_callbacks.PAINT, function()
    clantag_animation()
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
    clantag_destroy()
end)

local customfakeping = menu.add_checkbox("Others","Ping spike boost")
local customfakeping = menu.find("aimbot","general","fake ping","type",{"custom"},"ping amount", 0, 400)
if customfakeping:get() then
    cvars.sv_maxunlag:set_float(0.4)
else
    cvars.sv_maxunlag:set_float(0.2)
end
local function are_have_weapon(ent)
    if not ent:is_alive() or not ent:get_active_weapon() then return end
    local t_cur_wep = ent:get_active_weapon():get_class_name()
    return t_cur_wep ~= "CKnife" and t_cur_wep ~= "CC4" and t_cur_wep ~= "CMolotovGrenade" and t_cur_wep ~= "CSmokeGrenade" and t_cur_wep ~= "CHEGrenade" and t_cur_wep ~= "CWeaponTaser"
end
local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end
local function strangerdranger(cmd)
    if not enabled:get() then return end
    if not key:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end

local autostrafe = menu.add_checkbox("Others","Jump Scout")
autostrafe = menu.find("misc","main","movement","autostrafer")
local function on_paint()
    if ent_speed_2d(entity_list.get_local_player()) > 10 and (Local_GetProp("m_fFlags") == 256 or Local_GetProp("m_fFlags") == 262) then
        autostrafe:set(0,true)
        autostrafe:set(1,true)
    else
        autostrafe:set(0,false)
        autostrafe:set(1,false)
    end
end

local function on_aimbot_fire(shot)
    local target = get_best_target(shot)
    if target then
        local backtrack_target = backtrack.get(target, shot.tick)
        if backtrack_target then
            shot.target = backtrack_target
        end
    end
end

local function get_best_target(shot)
    local best_target = nil
    local best_fov = math.huge
    
    for i=1, globals.maxplayers() do
        local player = entity.get_player(i)
        if player and entity.is_alive(player) and entity.is_enemy(player) then
            local head_pos = entity.hitbox_position(player, 0)
            local fov = calculate_fov(shot.angle, shot.origin, head_pos)
            if fov < best_fov then
                best_fov = fov
                best_target = player
            end
        end
    end
    
    return best_target
end

local function calculate_fov(from, to, position)
    local angle = vector.sub(to, from)
    local dir = vector.normalize(angle)
    local aim_pos = vector.add(from, vector.mul(dir, 1000))
    local aim_angle = engine.trace_line(from[1], from[2], from[3], aim_pos[1], aim_pos[2], aim_pos[3], 0x1)
    local aim_dir = vector.normalize({ aim_angle.x, aim_angle.y, aim_angle.z })
    local angle_to_target = math.deg(math.acos(vector.dot(dir, aim_dir)))
    local distance_to_target = vector.distance(from, position)
    local fov = math.atan((0.15 * distance_to_target) / distance_to_target) * (180 / math.pi)
    return fov * angle_to_target
end

local function on_checkbox_callback()
    if menu.get_bool("Ragebot", "Force Backtrack") then
        aimbot.set_callback("on_fire", on_aimbot_fire)
    else
        aimbot.set_callback("on_fire", nil)
    end
end

menu.add_checkbox("Ragebot", "Force Backtrack", false, on_checkbox_callback)

local function get_best_target(shot)
    local best_target = nil
    local best_fov = math.huge
    local use_backtrack = menu.get_bool("Ragebot", "Best Target") -- sprawdź, czy przycisk Best Target jest włączony
    
    for i=1, globals.maxplayers() do
        local player = entity.get_player(i)
        if player and entity.is_alive(player) and entity.is_enemy(player) then
            local head_pos = entity.hitbox_position(player, 0)
            local fov = calculate_fov(shot.angle, shot.origin, head_pos)
            if fov < best_fov then
                if use_backtrack then -- jeśli Best Target jest włączony, użyj historii położenia do celu
                    local backtrack_data = backtrack.get_data(player)
                    if backtrack_data and #backtrack_data > 0 then
                        best_fov = fov
                        best_target = player
                    end
                else -- w przeciwnym razie użyj obecnego położenia celu
                    best_fov = fov
                    best_target = player
                end
            end
        end
    end
    
    return best_target
end

menu.add_checkbox("Ragebot", "Best Target", false) -- dodaj przycisk Best Target do menu

local function on_aimbot_fire(shot)
    local target = get_best_target(shot)
    if target then
        local backtrack_target = backtrack.get(target, shot.tick)
        if backtrack_target then
            shot.target = backtrack_target
        end
    end
end

local resolver_helper_enabled = false

local function detect_side(player)
    if not resolver_helper_enabled then
        return 0
    end

    -- angle vectors
    local forward = player:get_eye_vector()
    local right = player:get_eye_vector():cross(Vector3(0, 0, 1)):get_normalized()
    local up = right:cross(forward):get_normalized()

    -- filtering
    local filter = CS.CTraceFilter()
    filter:set_ignore_class(player:get_classname())
    local src = player:get_eye_pos()
    local dst = src + (forward * 384)

    -- back engine tracers
    local back_ray = CS.Ray(src, dst)
    local back_trace = engine_trace:trace_ray(back_ray, CS.MASK_SHOT_HULL, filter)
    local back_two = (back_trace.endpos - back_trace.startpos):length()

    -- right engine tracers
    local right_ray = CS.Ray(src + right * 35, dst + right * 35)
    local right_trace = engine_trace:trace_ray(right_ray, CS.MASK_SHOT_HULL, filter)
    local right_two = (right_trace.endpos - right_trace.startpos):length()

    -- left engine tracers
    local left_ray = CS.Ray(src - right * 35, dst - right * 35)
    local left_trace = engine_trace:trace_ray(left_ray, CS.MASK_SHOT_HULL, filter)
    local left_two = (left_trace.endpos - left_trace.startpos):length()

    -- resolve antiaim
    local angles = player:get_eye_angles()

    -- in air
    if player:is_in_air() then
        angles.pitch = -89
        player.resolver_flags.is_in_air = true
    end

    -- crouch
    if player:is_ducked() then
        angles.pitch = 75
        player.resolver_flags.is_crouching = true
    end

    -- slowwalk
    if player:is_slow_walking() then
        angles.pitch = -89
        angles.yaw = angles.yaw + 90
        player.resolver_flags.is_slow_walking = true
    end

    if side ~= 0 then
        angles.yaw = angles.yaw + (45 * side)
        player.resolver_flags.is_sideways = true
    end

    local velocity = player:get_prop_vector("localdata", "m_vecVelocity")
    if velocity:length() > 5 then
        if side == 0 then
            angles.pitch = math.atan2(-velocity.z, velocity:length2D()) * 180 / math.pi
        else
            angles.pitch = angles.pitch + 45
        end
        player.resolver_flags.is_in_air = true
    end

    -- apply resolved angles
    player:set_eye_angles(angles)

    -- fix side
    if left_two > right_two then
        return -1
    elseif right_two > left_two then
        return 1
    else
        return 0
    end
end


local function on_resolver_helper_checkbox_click()
    resolver_helper_enabled = menu.get_bool("Ragebot", "Enable Resolver")
end

menu.add_checkbox("Ragebot", "Enable Resolver", on_resolver_helper_checkbox_click)

local function on_paint()
    if not resolver_helper_enabled then
        return
    end

    local players = entitylist.get_players()
    for _, player in ipairs(players) do
        if player:is_enemy() and player:is_alive() then
            local antiaim_yaw = player:get_antiaim_yaw()

            -- resolvowanie antyaima
            local side = detect_side(player)
            if side == 1 then
                antiaim_yaw = -58
            elseif side == -1 then
                antiaim_yaw = 58
            else
                antiaim_yaw = 0
            end

            player:set_antiaim_yaw(antiaim_yaw)
        end
    end
end