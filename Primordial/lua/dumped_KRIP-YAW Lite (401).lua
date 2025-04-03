local text = menu.add_text("welcome!", "Coded by PyZik and KRIPSI    \n"                    )
local text = menu.add_text("welcome!", "KRIP-YAW Lite thx for using    \n"                    )
local text = menu.add_text("welcome!", "Pro version - 10$ or 500 rub in our discord    \n"                    )
local text = menu.add_text("welcome!", "Mr."..user.name.."["..user.uid.."]   \n"                    )

menu.add_button("welcome!", "print Discord", function()
    print("discord.gg/HgMhPbtq9n")
end)




menu.add_button("RAGE", "RQ", function()
    while true do end
end)


------------------------------------- AI BOT 


-------------------------------------

local yaw_base        = menu.find("antiaim", "main", "angles", "yaw add"        )
local rotate_enable   = menu.find("antiaim", "main", "angles", "rotate"         )
local mrotate_range   = menu.find("antiaim", "main", "angles", "rotate range"   )
local mrotate_speed   = menu.find("antiaim", "main", "angles", "rotate speed"   )
local desync_side     = menu.find("antiaim", "main", "desync", "side"           ) 
local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount"    )
local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount"   ) 
local antibrute       = menu.find("antiaim", "main", "desync", "anti bruteforce")
local cheat_jitter    = menu.find("antiaim", "main", "angles", "jitter mode"    )
local auto_direct     = menu.find("antiaim", "main", "angles", "yaw base"       )
local pitch           = menu.find("antiaim", "main", "angles", "pitch"          )
local onshot          = menu.find("antiaim", "main", "desync", "on shot"        )
local override_stand  = menu.find("antiaim", "main", "desync", "override stand" )
local leg_slide       = menu.find("antiaim", "main", "general", "leg slide"     )
local jitterADD       = menu.find("antiaim", "main", "angles", "jitter add"     )
local jittertype      = menu.find("antiaim", "main", "angles", "jitter type"     )
local jittermade      = menu.find("antiaim", "main", "angles", "jitter mode"     )

local jitter_builder  = menu.add_checkbox("anti aim", "Enable")

 ---------------------------------------------------------------------------
--] Save Initial Settings [--
local sYaw_base        = yaw_base:get()
local sRotate_enable   = rotate_enable:get()
local sMrotate_range   = mrotate_range:get()
local sMrotate_speed   = mrotate_speed:get()
local sDesync_side     = desync_side:get()
local sDesync_amount_l = desync_amount_l:get()
local sDesync_amount_r = desync_amount_r:get()
local sAntibrute       = antibrute:get()
local sCheat_jitter    = cheat_jitter:get()
local sAuto_direct     = auto_direct:get()
local sPitch           = pitch:get()
local sOnshot          = onshot:get()
local sOverride_stand  = override_stand:get()
local sLeg_slide       = leg_slide:get()
-- uses these to revert settings on shutdown

 ---------------------------------------------------------------------------
 --] MENU ELEMENTS [--
 
 --] Welcom message :3 [--





-- global variables
local state    = 0
local side     = 0
local uid      = user.uid
local name     = user.name

 --] Anti-Aim [--

 -- presets
local presets = menu.add_selection("anti aim", "KRIP SETS", {"none", "KRIP MODE"})


-- jitter builder 


local jitter_angle_1  = menu.add_slider("anti aim", "jitter angle 1", -180, 180)
local jitter_angle_2  = menu.add_slider("anti aim", "jitter angle 2", -180, 180)

local desync_amount_1 = menu.add_slider("anti aim", "desync amount 1", -100, 100)
local desync_amount_2 = menu.add_slider("anti aim", "desync amount 2", -100, 100) 

local mjitter_speed   = menu.add_slider("anti aim", "jitter speed", 1, 3)


menu.set_group_column("anti aim", 2)

local function main(cmd)



 
    cheat_jitter:set(1) 
    override_stand:set(false)



    local preset = presets:get()


    

    if preset == 2 then
	    desync_amount_1:set(85)
        desync_amount_2:set(45)
		jitter_angle_1:set(-34)
        jitter_angle_2:set(22)
		onshot:set(2)
		jitterADD:set(88)
		jittertype:set(1)
		jittermade:set(1)
        
	end

   

    

   
	     

    local vjitter_angle_1 = jitter_angle_1:get()
    local vjitter_angle_2 = jitter_angle_2:get()
    local vdesync_amount_1 = desync_amount_1:get()
    local vdesync_amount_2 = desync_amount_2:get()

   

 
    local tick_count = global_vars.tick_count()

    if jitter_builder:get() then
        local jitter_speed = mjitter_speed:get() + 1

        if state > 0 then 
            yaw_base:set(vjitter_angle_1)

            if vjitter_angle_1 > 0 then
                side = 1
            else
                side = 0
            end

            if vdesync_amount_1 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_1 * -1)
                desync_amount_r:set(vdesync_amount_1 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_1)
                desync_amount_r:set(vdesync_amount_1)
            end

        else
            yaw_base:set(vjitter_angle_2)

            if vjitter_angle_2 > 0 then
                side = 1
            else
                side = 0
            end

            if vdesync_amount_2 < 0 then 
                desync_side:set(2)
                desync_amount_l:set(vdesync_amount_2 * -1)
                desync_amount_r:set(vdesync_amount_2 * -1)
            else
                desync_side:set(3)
                desync_amount_l:set(vdesync_amount_2)
                desync_amount_r:set(vdesync_amount_2)
            end
        end
        state = state + 1
        if state > jitter_speed then state = jitter_speed * -1 
        end
    end

    auto_direct:set(auto_direct() + 1)

    if  antibrute:get() then
        antibrute:set(true)
    else
        antibrute:set(false)
    end


    pitch:set(pitch() + 1)

    onshot:set(onshot() + 1)

    leg_slide:set(leg_slide() + 1)

    ---------------------------------------------------------------------------

end

local function on_shutdown()
    yaw_base:set(sYaw_base)       
    rotate_enable:set(sRotate_enable) 
    mrotate_range:set(sMrotate_range)  
    mrotate_speed:set(sMrotate_speed)  
    desync_side:set(sDesync_side)    
    desync_amount_l:set(sDesync_amount_l)                                
    desync_amount_r:set(sDesync_amount_r)
    antibrute:set(sAntibrute)     
    cheat_jitter:set(sCheat_jitter)   
    auto_direct:set(sAuto_direct)    
    pitch:set(sPitch)                                                        
    onshot:set(sOnshot)                
    override_stand:set(sOverride_stand)        
    leg_slide:set(sLeg_slide)                 

    print("1")
    print("Bye!")
end

local ref_quickpeek = menu.find("aimbot","general","misc","autopeek")
local ref_safe_charge = menu.add_checkbox("RAGE","enable krip (safe) peek",false)

local function on_setup_command(cmd)
	if not cmd or not ref_safe_charge:get() then
		return
	end

	if ref_quickpeek[2]:get() and not client.can_fire() and not (exploits.get_charge() >= 14) then
		cmd.move = vec3_t()
	end 

end

-----------------------------

local script_menu = {
  m_max_compensation_ticks = menu.add_slider( "RAGE", "krip ticks", 0, 12 )
}

local math_const = {
  m_pi_radians = 57.295779513082
}

local player_records = { }



local function push_player_record( player )
  local index = player:get_index( )
  local record = { }

  record.m_eye_position = player:get_eye_position( )
  record.m_simulation_time = player:get_prop( "m_flSimulationTime" )

  if( player_records[ index ] == nil ) then
    player_records[ index ] = { }
  end

  for i = 11, 0, -1 do
    if( player_records[ index ][ i ] ~= nil ) then
      player_records[ index ][ i + 1 ] = player_records[index ][ i ]
    end
  end

  player_records[ index ][ 0 ] = record
end


local function clamp(num, min, max)
	if num < min then
		num = min
	elseif num > max then
		num = max
	end

	return num
end



local function ticks_to_time( ticks )
  return global_vars.interval_per_tick( ) * ticks
end


local function time_to_ticks( time )
  return math.floor( 0.5 + time / global_vars.interval_per_tick( ) )
end


local function calc_lerp( )
  local update_rate = clamp( cvars.cl_updaterate:get_float( ), cvars.sv_minupdaterate:get_float( ), cvars.sv_maxupdaterate:get_float( ) )
  local lerp_ratio = clamp( cvars.cl_interp_ratio:get_float( ), cvars.sv_client_min_interp_ratio:get_float( ), cvars.sv_client_max_interp_ratio:get_float( ) )

  return clamp( lerp_ratio / update_rate, cvars.cl_interp:get_float( ), 1 )
end

local function is_record_valid( record, tick_base )
  local max_unlag = cvars.sv_maxunlag:get_float( )
  local current_time = ticks_to_time( tick_base )

  local correct = engine.get_latency( e_latency_flows.INCOMING ) + engine.get_latency( e_latency_flows.OUTGOING )
  local correct = clamp( correct, 0, max_unlag )

  return math.abs( correct - ( current_time - record.m_simulation_time ) ) <= 0.2
end


local function calc_angle( from, to )
  local result = angle_t( 0.0, 0.0, 0.0 )
  local delta = from - to
  local hyp = math.sqrt( delta.x * delta.x + delta.y * delta.y )

  result.x = math.atan( delta.z / hyp ) * math_const.m_pi_radians
  result.y = math.atan( delta.y / delta.x ) * math_const.m_pi_radians

  if( delta.x >= 0 ) then
    result.y = result.y + 180
  end

  return result
end

local function normalize_angle( angle )
  local result = angle

  while result.x < -180 do
    result.x = result.x + 360
  end

  while result.x > 180 do
    result.x = result.x - 360
  end

  while result.y < -180 do
    result.y = result.y + 360
  end

  while result.y > 180 do
    result.y = result.y - 360
  end

  result.x = clamp( result.x, -89, 89 )

  return result
end


local function calc_fov( view_angle, target_angle )
  local delta = target_angle - view_angle
  local delta_normalized = normalize_angle( delta )

  return math.min( math.sqrt( math.pow( delta_normalized.x, 2 ) + math.pow( delta_normalized.y, 2 ) ), 180 )
end


local function on_net_update( )
  local enemies_only = entity_list.get_players(true)
  if( enemies_only == nil ) then
    return
  end

  for _, enemy in pairs(enemies_only) do
    if enemy:is_alive() then
      push_player_record( enemy )
    end
  end
end

local function on_setup_command( cmd )
  local enemies_only = entity_list.get_players(true)

  local closest_enemy = nil
  local closest_fov = 180

  local local_player = entity_list.get_local_player( )
  if( local_player == nil or local_player:is_alive( ) ~= true or cmd:has_button( e_cmd_buttons.ATTACK ) ~= true ) then
    return
  end

  local view_angle = engine.get_view_angles( )
  local eye_position = local_player:get_eye_position( )


  for _, enemy in pairs(enemies_only) do
    if enemy:is_alive() then
      local fov = calc_fov( view_angle, calc_angle( eye_position, enemy:get_eye_position( ) ) )

      if( fov < closest_fov ) then
        closest_enemy = enemy
        closest_fov = fov
      end
    end
  end

  if( closest_enemy ~= nil ) then
    closest_fov = 180

    local best_record = nil
    if( player_records[ closest_enemy:get_index( ) ] == nil ) then
      return
    end

    for i = 0, 12 do
      if( player_records[ closest_enemy:get_index( ) ][ i ] ~= nil ) then
        local record = player_records[ closest_enemy:get_index( ) ][ i ]
        local compensation_ticks = time_to_ticks( closest_enemy:get_prop( "m_flSimulationTime" ) - record.m_simulation_time )

        if( is_record_valid( record, local_player:get_prop( "m_nTickBase" ) ) and compensation_ticks <= script_menu.m_max_compensation_ticks:get( ) ) then
            local fov = calc_fov( view_angle, calc_angle( eye_position, record.m_eye_position ) )

            if( fov < closest_fov ) then
              closest_fov = fov
              best_record = record
            end
        end
      end
    end

    if( best_record ~= nil ) then
      local tick_count = cmd.tick_count

      cmd.tick_count = time_to_ticks( best_record.m_simulation_time + calc_lerp( ) )
    end
  end
end




callbacks.add( e_callbacks.NET_UPDATE, on_net_update )
callbacks.add( e_callbacks.SETUP_COMMAND, on_setup_command )

local indicators = menu.add_multi_selection("Visual", "Skeet style indicators", {"DoubleTap", "Safe Point", "Baim", "Lethal","Min DMG", "Hide Shots", "FakeDuck", "Fake-Lag", "Fake",})

local screen_size = render.get_screen_size()
local font = render.create_font("Calibri Bold", 27, 670, e_font_flags.ANTIALIAS)
local color2 = color_t(255, 255, 255, 255)
local color3 = color_t(255, 0, 0, 255)
local col_1 = color_t(0, 0, 0, 150)
local col_2 = color_t(0, 0, 0, 0)
local fontsigma = render.create_font("Verdana", 12, 400, e_font_flags.ANTIALIAS)


local function on_draw_watermark()
    local fps = client.get_fps()
    local tickrate = client.get_tickrate()
    return "KRIP-YAW | {Lite} | "..user.name.." | "..fps.." fps | "..tickrate.." tick"
end





local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
	deagle = {3},
    revolver = {4},
    pistols = {5},
    other = {6}
}

local math_funcs = { 
    get_min_dmg = function(wpn_type) 
        local menu_ref = menu.find("aimbot", wpn_type, "target overrides", "force min. damage")
        local force_lethal = menu.find("aimbot", wpn_type, "target overrides", "force lethal shot")
        local hitbox_ovr = menu.find("aimbot", wpn_type, "target overrides", "force hitbox")
        local force_sp = menu.find("aimbot", wpn_type, "target overrides", "force safepoint")
        local force_hc = menu.find("aimbot", wpn_type, "target overrides", "force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(),
                force_hc[2]:get()}
    end,
    vars = {
        angle = 0
    }
}

local function calcs()
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        math_funcs.vars.angle = 0

    else
        math_funcs.vars.angle = antiaim.get_max_desync_range()
    end
end

callbacks.add(e_callbacks.ANTIAIM, calcs)

local groups = {
    auto = {0},
    scout = {1},
    awp = {2},
	deagle = {3},
    revolver = {4},
    pistols = {5},
    other = {6}
}
local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil

local function get_weapon_group() -- // Classy also did a func like this, might be better not sure.
    for key, value in pairs(groups) do
        if value == ragebot.get_active_cfg() then
            current_min = math_funcs.get_min_dmg(key)[1];
            key_active = math_funcs.get_min_dmg(key)[2];
            force_lethal = math_funcs.get_min_dmg(key)[3];
            hitbox_ovr = math_funcs.get_min_dmg(key)[4];
            force_sp = math_funcs.get_min_dmg(key)[5];
            force_hc = math_funcs.get_min_dmg(key)[6];
        end
    end

    return {tostring(current_min), key_active, force_lethal, hitbox_ovr, force_sp, force_hc};
end
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hideshots = menu.find("aimbot", "general", "exploits", "hideshots", "enable")
local pitch = menu.find("antiaim", "main", "extended angles", "enable")

local function gradient(x, y, w, h, col1, col2)
    render.rect_fade(vec2_t(x, y - 4), vec2_t(w / 4, h), col2, col1, true)
    render.rect_fade(vec2_t(x + (w / 4), y - 4), vec2_t(w / 4, h), col1, col2, true)
end

local function dnn()
    local maxdes = math_funcs.vars.angle
    local local_player = entity_list.get_local_player()
    if local_player == nil then
        return
    end
    if not local_player:is_alive() then
        return
    end
    
    local pos = vec2_t(0, 0)
    local addpos = vec2_t(0, 32)
    local startpos = vec2_t(screen_size.x * 0.00741666666, screen_size.y * 0.67777777777)
    local function default(str, color)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        pos = pos - addpos
    end

    local function circle(str, color, percent)
        local text_size = render.get_text_size(font, str)
        gradient(9, pos.y + 4, 70, 28, col_1, col_2)
        render.text(font, str, pos, color)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color_t(0, 0, 0, 155), 3, 1)
        render.progress_circle(pos + vec2_t(text_size.x * 1.3, text_size.y / 1.9), 5, color, 3, percent)
        pos = pos - addpos

    end

    pos = startpos
    if indicators:get('Fake') then
        circle("FAKE", color_t(math.floor(255 - maxdes * 1.6), math.floor(maxdes * 4), 50, 255), maxdes / 58)
    end
    if indicators:get('Fake-Lag') then
        circle("FL ", color_t(math.floor(255 - engine.get_choked_commands() * 360 / 14 * 0.25), math.floor(engine.get_choked_commands() * 360 / 14 * 0.5), 50, 255), engine.get_choked_commands() / 14)
    end

    if indicators:get('Min DMG') and get_weapon_group()[2] then
        default("DMG: " .. get_weapon_group()[1], color2)
    end

    if indicators:get("Lethal") and get_weapon_group()[3] then
        default("LETHAL", color2)
    end

    if indicators:get('Baim') and get_weapon_group()[4] then
        default("BAIM", color2)
    end

    if indicators:get('Safe Point') and get_weapon_group()[5] then
        default("SAFE", color2)
    end

    if indicators:get('FakeDuck') and antiaim.is_fakeducking() then
        default("DUCK", color2)
    end

     if hideshots[2]:get() and indicators:get('Hide Shots') then
        default("ONSHOT", color_t(150, 200, 60, 255))
    end
	
	if pitch[2]:get() then
        default("pitch", color2)
    end

    if dt_ref[2]:get() then
        if exploits.get_charge() == 14 and indicators:get('DoubleTap') then
            default("DT", color2)
        elseif exploits.get_charge() ~= 14 and indicators:get('DoubleTap') then
            default("DT", color3)
        end
    end

end





------------------


------------------


function world_circle(origin, radius, color)
	local previous_screen_pos, screen

    for i = 0, radius*2 do
		local pos = vec3_t(radius * math.cos(i/3) + origin.x, radius * math.sin(i/3) + origin.y, origin.z);

        local screen = render.world_to_screen(pos)
        if not screen then return end
		if screen.x ~= nil and previous_screen_pos then
            render.line(previous_screen_pos, screen, color)
			previous_screen_pos = screen
        elseif screen.x ~= nil then
            previous_screen_pos = screen
		end
	end
end

-------------------------



local logs = {}
local fonts = nil
local wantTimer = menu.add_checkbox("Visual", "Hit Logs Fonts", false)
local fontSelection = menu.add_selection("Visual", "Logs Font Selection", {"Regular", "Bold"})
local function paint12()
    if wantTimer:get() then
        fontSelection:set_visible(true)
    else
        fontSelection:set_visible(false)
    end
end
callbacks.add(e_callbacks.PAINT,paint12)


local function onPaint()
    if(fonts == nil) then
        fonts =
        {
            regular = render.create_font("Verdana", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
            bold = render.create_font("Verdana Bold", 12, 1, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW);
        }
    end

    if (engine.is_connected() ~= true) then
        return
    end

    local time = global_vars.frame_time()

    local screenSize = render.get_screen_size()
    local screenWidth = screenSize.x
    local screenHeight = screenSize.y

    for i = 1, #logs do
        local log = logs[i]
        if log == nil then goto continue
        end
        local x = screenWidth / 2
        local y = screenHeight / 1.25 + (i * 15)
        local alpha = 0

        if (log.state == 'appearing') then
            -- Fade in.
            local progress = log.currentTime / log.lifeTime.fadeIn
            x = x - Lerp(log.offset, 0, Ease(progress))
            alpha = Lerp(0, 255, Ease(progress))

            log.currentTime = log.currentTime + time
            if (log.currentTime >= log.lifeTime.fadeIn) then
                log.state = 'visible'

                -- Reset time.
                log.currentTime = 0
            end


        elseif(log.state == 'visible') then
        -- Fully opaque.
        alpha = 255

        log.currentTime = log.currentTime + time
        if (log.currentTime >= log.lifeTime.visible) then
            log.state = 'disappearing'

            -- Reset Time.
            log.currentTime = 0
        end

        elseif(log.state == 'disappearing') then
            -- Fade out.
            local progress = log.currentTime / log.lifeTime.fadeOut
            x = x + Lerp(0, log.offset, Ease(progress))
            alpha = Lerp(255, 0, Ease(progress))

            log.currentTime = log.currentTime + time
            if(log.currentTime >= log.lifeTime.fadeOut) then
                table.remove(logs, i)
                goto continue
            end
        end

        -- Increase the total time.
        log.totalTime = log.totalTime + time

        alpha = math.floor(alpha)
        local white = color_t(236, 236, 236, alpha)
        local accent_color_text, accent_color_color = unpack(menu.find("misc", "main", "config", "accent color"))
        local detail = accent_color_color:get()
        detail.a = alpha

        local message = {}

        -- Add header and body to message
        local combined = {}

        for a = 1, #log.header do
            local t = log.header[a]
            table.insert(combined, t)
        end

        for a = 1, #log.body do
            local t = log.body[a]
            table.insert(combined, t)
        end

        for j = 1, #combined do
            local data = combined[j]

            local text = tostring(data[1])
            local color = data[2]

            -- Push the data to the message.
            table.insert(message,{text, color and detail or white})
        end

        -- Add the total lifetime to the message.
        if wantTimer:get() then
            table.insert(message,{' - ', white})
            local temp = (log.lifeTime.fadeIn + log.lifeTime.visible + log.lifeTime.fadeOut) - log.totalTime
            table.insert(message, {string.format("%.1fs", temp), detail})
        elseif not wantTimer:get() then
            
        end
        -- Draw log.
        local render_font = nil
        if render_font == nil then
        local stringFont = fontSelection:get()
        if stringFont == 1 then render_font = fonts.regular
            else render_font = fonts.bold
            end
        end

        render.string(x, y, message, 'c', render_font)
        ::continue::
    end
end

local hitgroupMap = {
    [0] = 'generic',
    [1] = 'head',
    [2] = 'chest',
    [3] = 'stomach',
    [4] = 'left arm',
    [5] = 'right arm',
    [6] = 'left leg',
    [7] = 'right leg',
    [8] = 'neck',
    [9] = 'gear'
  }

function on_aimbot_hit(hit)
    local name = hit.player:get_name()
    local hitbox = hitgroupMap[hit.hitgroup]
    local damage = hit.damage
    local health = hit.player:get_prop('m_iHealth')

    AddLog('PlayerHitEvent', {
        {'Hit ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'for ', false};
        {damage .. ' ', true};
        {'damage (remaining: ', false};
        {health, true};
        {')', false};
    })
end

function on_aimbot_miss(miss)
    local name = miss.player:get_name()
    local hitbox = hitgroupMap[miss.aim_hitgroup]
    local damage = miss.aim_damage
    local health = miss.player:get_prop('m_iHealth')
    local reason = miss.reason_string

    AddLog('PlayerHitEvent', {
        {'Missed ', false};
        {name .. ' ', true};
        {'in the ', false};
        {hitbox .. ' ', true};
        {'due to ', false};
        {reason .. ' ', true};
    })
end

function AddLog(type, body)
    local log = {
        type = type,
        state = 'appearing',
        offset = 250,
        currentTime = 0,
        totalTime = 0,
        lifeTime = {
            fadeIn = 0.75,
            visible = 3,
            fadeOut = 0.75
        },
        header = {
            {'[', false},
            {'KRIP-YAW', true},
            {'] ', false},
        },
        body = body
    }
    table.insert(logs, log)
end

function Lerp(from, to, progress) 
    return from + (to - from) * progress
end

function Ease(progress)
    return progress < 0.5 and 15 * progress * progress * progress * progress * progress or 1 - math.pow(-2 * progress + 2, 5) / 2
end

render.string = function(x, y, data, alignment, font)
    -- Get total length for all the data.
    local length = 0
    for i = 1, #data do
        local text = data[i][1]
        
        local size = render.get_text_size(font, text)
        length = length + size.x
    end

    local offset = x
    for i = 1, #data do
        local text = data[i][1]
        local color = data[i][2]

        local sX = offset
        local sY = y

        -- Adjust position based on alignment
        if(alignment) == 'l' then
            sX = offset - length
        elseif(alignment) == 'c' then
            sX = offset - (length / 2)
        elseif(alignment) == 'r' then
            sX = offset
        end



        -- Draw the text.

        render.text(font, text, vec2_t(sX + 1, sY + 1), color_t(16, 16, 16, color.a))
        render.text(font, text, vec2_t(sX, sY), color)

        -- Add the length of the text to the offset.
        local size = render.get_text_size(font, text)
        offset = offset + size.x
    end
end


callbacks.add(e_callbacks.PAINT,onPaint)
callbacks.add(e_callbacks.AIMBOT_MISS,on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT,on_aimbot_hit)

-----------------------------



-----------------------------



---krip talk

local Visual = {}
local ui = {}
Visual.phrases = {}

local function paint1()
    if ui.is_enabled:get() then
        ui.current_list:set_visible(true)
    else
        ui.current_list:set_visible(false)
    end
end
callbacks.add(e_callbacks.PAINT,paint1)

table.insert(Visual.phrases, {
    name = "KRIP TALK (Ru)",
    phrases = {
        "1 2 3..... ВСЕ РАВНО КРИП ЯВ ИМБА",
        "КРИП ЯВ ОТЕЦ ЭТОГО МИРА",
        "Я ЛЮБЛЮ КРИП ЯВ И КРИПСИ",
        "ПУЗИК ГЕЙ А КРИП ЯВ ИМБА КСТА",
        "КРИП ЯВ НА АВЕ ЗДОРОВЬЕ МАМЕ",
        "ТЫ ЧЕ КРИП ЯВА МАЛО ЕЛ?",
        "Я КРИП ЯВ КРИД",
        "КРИП ЯВ КРИП ЯВОВИЧ, ДА МЕНЯ ТАК ЗОВУТ!!!!!",
        "Я КРИП А ТЫ ЯВ ПОЛУЧАЕТСЯ КРИП ЯВ",
        "КРИПСИ ЯВ ИМБА!!!! ОЙ ТОЕСТЬ КРИП ЯВ",
        "ЕСЛИ НИК ПУЗИК ТО ЕСТЬ ПУЗО? ОЙ КАКАЯ РАЗНИЦА ЕСЛИ ТЕБЯ ВЫЕБАЛ КРИП ЯВ",
        "КРИП ИЛИ НЕ КРИП А ВСЕ РАВНО ЯВ",
        "ЧЕ ОТЛЕТЕЛ ЕДИНИЦОЙ ОТ ЛУЧШЕГО ЯВА КРИПА МИРА ЭТОГО?",
        "КРИП И ЯВ КАК ЧИП И ДЕЙЛ КСТА",
        "КУПИ КРИП ЯВ И НЕ БУДЬ ННОМ С 22",
        "ЮИД 500 В ПРИМОРДИАЛЕ ПМАЙ ДУРА НИК КРИПСИ",
        "ПОСОСИ СЛАБОЧЕК КРИП ЯВ ИМБА НАХУЙ ЕПТА АХХАХАХА ЕБАТЬ Я ХОРОШ",

    }
})



ui.group_name = "Visual"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Krip Say", false)

ui.current_list = menu.add_selection(ui.group_name, "Krip List", (function()
    local tbl = {}
    for k, v in pairs(Visual.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

Visual.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = Visual.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, Visual.player_death, "player_death")
--------------------------------------------------- Custom Fake Lag

---------------------------------------------------


---------------------------------------------------

--callback

-----------------------------

callbacks.add(e_callbacks.PAINT, dnn)
callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)


callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)