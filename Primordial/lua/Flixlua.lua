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

local antiaim_resolver = {}

-- Zmienne przechowujące poprzednie pozycje gracza i aktualne celownika
local last_origin = {0, 0, 0}
local last_angles = {0, 0, 0}
local target_origin = {0, 0, 0}

-- Funkcja pomocnicza do obliczania dystansu między dwoma pozycjami
local function distance(a, b)
local x, y, z = a[1] - b[1], a[2] - b[2], a[3] - b[3]
return math.sqrt(x * x + y * y + z * z)
end

-- Funkcja zwracająca cel, do którego ma być skierowane anty aimowanie
function antiaim_resolver.get_target()
local me = entity.get_local_player() -- pobranie lokalnego gracza
if not me then
return nil
end

local origin = entity.get_prop(me, "m_vecOrigin") -- pobranie pozycji gracza
local angles = {entity.get_prop(me, "m_angEyeAngles[1]"), entity.get_prop(me, "m_angEyeAngles[2]"), 0} -- pobranie kątów patrzenia gracza

-- Aktualizacja zmiennych przechowujących pozycje gracza i celownika
if distance(origin, last_origin) > 1 or distance(angles, last_angles) > 1 then
    last_origin = origin
    last_angles = angles
    target_origin = {0, 0, 0} -- resetowanie celu, jeśli gracz zmienił pozycję lub kąty patrzenia
end

-- Sprawdzenie, czy cel został już wyznaczony
if target_origin[1] ~= 0 or target_origin[2] ~= 0 or target_origin[3] ~= 0 then
    return target_origin
end

-- Pobranie listy przeciwników
local enemies = entity.get_players(true)

-- Wyszukanie przeciwnika znajdującego się najbliżej gracza
local min_distance = math.huge
local closest_enemy = nil
for i=1, #enemies do
    local enemy = enemies[i]
    local enemy_origin = entity.get_prop(enemy, "m_vecOrigin")
    local d = distance(origin, enemy_origin)
    if d < min_distance then
        min_distance = d
        closest_enemy = enemy
    end
end

-- Ustawienie celu na przeciwnika znajdującego się najbliżej gracza
if closest_enemy then
    target_origin = entity.get_prop(closest_enemy, "m_vecOrigin")
end

return target_origin

end

local enabled_checkbox = menu.add_checkbox("Ragebot", "Enable Resolver")

-- Funkcja uruchamiana przy kliknięciu przycisku Enable
local function on_resolver_enable()
if enabled_checkbox:get() then
client.set_event_callback("aimbot_fire", on_aimbot_fire)
else
client.unset_event_callback("aimbot_fire", on_aimbot_fire)
end
end

-- Funkcja uruchamiana przy strzale
local function on_aimbot_fire(shot)
local target = antiaim_resolver.get_target
end

local resolver = {}

-- Zmienne przechowujące informacje o ostatnich pozycjach celu
local last_shot_time = 0
local last_hit_pos = nil
local last_hit_time = 0
local is_resolver_enabled = false

-- Funkcja zwracająca pozycję, w którą należy strzelać
function resolver.get_target(entity_index)
  if not is_resolver_enabled then
    return nil
  end

  local current_time = globals.realtime()
  local hit_pos = nil

  -- Sprawdzenie, czy cel został trafiony
  if last_hit_pos ~= nil and current_time - last_hit_time < 0.5 then
    hit_pos = last_hit_pos
  else
    -- Pobranie pozycji celu
    local entity = entity.get_entity_from_index(entity_index)
    if entity == nil then
      return nil
    end
    local origin = entity.get_prop(entity_index, "m_vecOrigin")

    -- Obliczenie kątów do celu
    local local_player = entity.get_local_player()
    local local_eye_pos = entity.get_eye_position(local_player)
    local aim_angles = engine.world_to_screen_angles(local_eye_pos, origin)

    -- Obliczenie pozycji, w którą należy strzelać
    hit_pos = engine.screen_angles_to_world(aim_angles)
  end

  -- Aktualizacja zmiennych przechowujących informacje o ostatnich pozycjach celu
  if hit_pos ~= nil then
    if current_time - last_shot_time > 1.5 then
      last_shot_time = current_time
      last_hit_pos = hit_pos
    end
    last_hit_time = current_time
  end

  return hit_pos
end

local function on_resolver_checkbox_changed()
  is_resolver_enabled = menu.get_bool("Ragebot", "Enable Resolver 2")
end

-- Dodanie checkboxa do menu Ragebot
menu.add_checkbox("Ragebot", "Enable Resolver 2", on_resolver_checkbox_changed)

return resolver