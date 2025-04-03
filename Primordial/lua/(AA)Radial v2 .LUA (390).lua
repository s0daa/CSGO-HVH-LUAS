local changelog = menu.add_text ("Radial V2 LUA", "-=Changelog=-              Thank you for using this lua")
local changelog = menu.add_text ("Radial V2 LUA", "-------------------                      Latest updates log")
local changelog = menu.add_text ("Radial V2 LUA", "LUA created by                       - 16.06-22")
local changelog = menu.add_text ("Radial V2 LUA", "FakeAngels AKA MR.Lee         - 14.05-22")
local view = menu.add_selection ("Radial V2 LUA", "", {"View changelog and updates", "- Menu layout", "- Cleaned up codes", "- Added pitch expoit","- Added auto direction", "- Feature marked with @ [not available]"})

---------------
--Auto direct-- {+antibrute (Extra tab)}
---------------

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

local state = 0

local mpitch          = menu.add_selection("Angles", "pitch", {"off", "down", "up", "zero", "jitter"})

local mOnshot         = menu.add_selection("Angles", "onshot", {"off", "opposite", "same side", "random"})

local mleg_slide      = menu.add_selection("Angles", "leg slide", {"off", "never", "always", "jitter"})

local do_auto_direct  = menu.add_selection("Angles", "auto direction mode", {"off", "viewangle", "at targets (crosshair)", "at targets (distance)", "velocity"})

local function main(cmd)

    cheat_jitter:set(1) 
    override_stand:set(false) 
    auto_direct:set(do_auto_direct() + 1)

    pitch:set(mpitch() + 1)
    onshot:set(mOnshot() + 1)
    leg_slide:set(mleg_slide() + 1)
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


    print("Initial settings before loading Lua restored :)")
    print("Thank you for using Radial V2 LUA")
end

menu.set_group_column("Angles", 1)

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)

------------
--Exploits--
------------

local class2 = menu.add_checkbox("Exploits", "pitch exploit") 

local function on_antiaim(ctx)
  if class2:get() then
      if anti_aim_jitter_switch then
      ctx:set_pitch(81)
      anti_aim_jitter_switch = false 
  else
      ctx:set_pitch(89)
      anti_aim_jitter_switch = true
  end
end
end

menu.set_group_column("Exploits", 1)

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)

local class3 = menu.add_checkbox("Exploits", "tall man exploit [@]") 

-------------------------------------------NO2



------------
--Anti aim--
------------

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






local state = 0

 
local presets = menu.add_selection("AntiAim", "AntiAim presets", {"custom builder", "Massive dynamic desync", "Normal dynamic desync", "Small dynamic desync", "Exploit aa", "-"})

local jitter_builder  = menu.add_checkbox("AntiAim", "Enable On/Off")
local rotate          = menu.add_checkbox("AntiAim", "rotate")


local jitter_angle_1  = menu.add_slider("AntiAim", "jitter angle 1", -180, 180)
local jitter_angle_2  = menu.add_slider("AntiAim", "jitter angle 2", -180, 180)
local mjitter_speed   = menu.add_slider("AntiAim", "jitter speed", 1, 3)

local desync_amount_1 = menu.add_slider("AntiAim", "desync amount 1", -100, 100)
local desync_amount_2 = menu.add_slider("AntiAim", "desync amount 2", -100, 100) 

local rotate_angle    = menu.add_slider("AntiAim", "rotate range", 0, 360)
local rotate_speed    = menu.add_slider("AntiAim", "rotate speed", 0, 100)

  
menu.set_group_column("Main", 2)
---------------------------------------------------------------------------

local function main(cmd)

    cheat_jitter:set(1) 
    override_stand:set(false) 

    local preset = presets:get()

    if preset == 2 then   
        jitter_angle_1:set(-31.3)
        jitter_angle_2:set(28.8)
        desync_amount_1:set(124)
        desync_amount_2:set(-98.3)
    end

    if preset == 3 then   
        jitter_angle_1:set(-11-5)
        jitter_angle_2:set(11.4)
        desync_amount_1:set(60)
        desync_amount_2:set(-88)
    end

    if preset == 4 then   
        jitter_angle_1:set(-4.5)
        jitter_angle_2:set(4.4)
        desync_amount_1:set(80)
        desync_amount_2:set(-93)

        rotate_enable:set(true)
        mrotate_range:set(3)
        mrotate_speed:set(3)
    end

    if preset == 5 then  
        jitter_angle_1:set(18)
        jitter_angle_2:set(6)
        desync_amount_1:set(81)
        desync_amount_2:set(100)

        rotate_enable:set(true)
        mrotate_range:set(31)
        mrotate_speed:set(10)
    end

    if preset == 6 then  
        jitter_angle_1:set(0)
        jitter_angle_2:set(0)
        desync_amount_1:set(0)
        desync_amount_2:set(-0)
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

    
    local vrotate_speed = rotate_speed:get()
    local vrotate_range = rotate_angle:get()

    if  rotate:get() then
        rotate_enable:set(true)
        mrotate_speed:set(vrotate_speed)
        mrotate_range:set(vrotate_range)
    else 
        rotate_enable:set(false)
    end

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
end

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)

-------------
--Extra--
-------------

local do_antibrute    = menu.add_checkbox("Extra", "anti bruteforce") 

local function extra(cmd)
    if  do_antibrute:get() then
        antibrute:set(true)
    else
        antibrute:set(false)
    end
end

menu.set_group_column("Extra", 2)

callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, extra)


-------------
--watermark--
-------------

local watermark_font = render.create_font( "Radial LUA", 17, 400, e_font_flags.ANTIALIAS )
local spectator_font = render.create_font( "Radial LUA", 12, 400, e_font_flags.DROPSHADOW )

local local_player = nil
local screen_size = render.get_screen_size( )

function get_table_length( table )
    length = 0

    for _ in pairs( table ) do
        length = length + 1
    end

    return length
end

local function watermark( )
    ping = math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 )
    tick_rate = math.floor( 1 / global_vars.interval_per_tick( ) )

    text = "Radial LUA | Ping: " .. ping .. "ms | Tick: " .. tick_rate .. " "

    text_size = render.get_text_size( watermark_font, text )

    render.rect_filled( vec2_t( screen_size.x - text_size.x - 23, 30 ), vec2_t( text_size.x + 10, text_size.y + -13 ), color_t( 0, 0, 0, 150 ) )

    render.text( watermark_font, text, vec2_t( screen_size.x - 15  - text_size.x, 10 ), color_t( 255, 255, 255 ) )
end

local function spectator_list( )
    

    spectators = { "spectators" }
    cur_spec_index = 2

    
    for _, player in pairs( entity_list.get_players( ) ) do
        if player:is_alive( ) or player:is_dormant( ) then
            goto continue
        end

        observer_target = entity_list.get_entity( player:get_prop( "m_hObserverTarget" ) )

        if observer_target ~= local_player then
            goto continue
        end

        spectators[ cur_spec_index ] = player:get_name( )

        
        cur_spec_index = cur_spec_index + 1

        ::continue::
    end
end

local function on_paint( )
    local_player = entity_list.get_local_player( )

    if not local_player then
        return
    end

    watermark( )
    spectator_list( )
end

local function on_watermark( )
    return
end

callbacks.add( e_callbacks.PAINT, on_paint )
callbacks.add( e_callbacks.DRAW_WATERMARK, on_watermark )

-------------
--callbacks--
-------------

local script_menu = {
    m_max_compensation_ticks = menu.add_slider( "Extra", "MaxComp Ticks", 0, 12 )
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





--callbacks.add(e_callbacks.SHUTDOWN, menu_add_checkbox)
--callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
--callbacks.add(e_callbacks.ANTIAIM, main)
--callbacks.add( e_callbacks.NET_UPDATE, on_net_update )
--callbacks.add( e_callbacks.SETUP_COMMAND, on_setup_command )