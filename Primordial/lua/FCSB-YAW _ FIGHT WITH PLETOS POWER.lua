local pixel = render.create_font("Smallest Pixel-7", 10, 20, e_font_flags.OUTLINE)
local multi_selection = menu.add_multi_selection("antiaim", "leg animation fix", {"reverse", "static"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))
local fake_limit = menu.add_slider("antiaim", "fake limit(antidinamo antiaim)", 1, 60)
local jitter_offset = menu.add_slider("antiaim", "jitter offset(antidinamo antiaim)", 0, 90)
local l_yaw_add = menu.add_slider("antiaim", "left yaw add(antidinamo antiaim)", -50, 50)
local r_yaw_add = menu.add_slider("antiaim", "right yaw add(antidinamo antiaim)", -50, 50)
local yaw_base = menu.add_selection("antiaim", "yaw base(antidinamo antiaim)", {"viewangle", "at target(crosshair)", "at target(distance)"})

local disabler = menu.add_multi_selection("antiaim","tank disabler(antidinamo antiaim)",{"on peek","on manual sideways","on manual backward","on hideshots"})

local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))

local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))

local side_stand = menu.find("antiaim","main", "desync","side#stand")
local llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
local rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
local side_move = menu.find("antiaim","main", "desync","side#move")
local llimit_move = menu.find("antiaim","main", "desync","left amount#move")
local rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
local side_slowm = menu.find("antiaim","main", "desync","side#slow walk")
local llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk")
local rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk")



local get_screen = render.get_screen_size()
local dt_tog = menu.add_checkbox("visuals", "masterswitch", false)
local dt_speed = menu.add_slider("ragebot", "Double Tap Speed",14,18)
local dt_ind_tog = menu.add_checkbox("visuals", "Enable", true)
local dt_style = menu.add_selection("visuals", "Style", {"normal", "fcsb mode"})
local dt_CCol = dt_ind_tog:add_color_picker("visuals Charged Color")
local dt_UCol = dt_ind_tog:add_color_picker("visuals Uncharged Color")
local dt_FCol = dt_ind_tog:add_color_picker("visuals Fade Color")
local xslid = menu.add_slider("visuals", "Indicator x",0,get_screen.x)
local yslid = menu.add_slider("visuals", "Indicator y",0,get_screen.y)
local verdana = render.create_font("Verdana", 15, 16, e_font_flags.ANTIALIAS)
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")

local function dt_ind()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    local choice = dt_style:get()
    local dt_tick = exploits.get_charge()
    local posx = xslid:get()
    local posy = yslid:get()
    local cur_time = global_vars.cur_time()
    local pulse = math.sin(math.abs(-math.pi + (cur_time * 1) % (math.pi * 2))) * 1
	local text_size = 12,12
    local magic = 0.07142
    if dt_tick == 15 then
        magic = 0.06666
    else if dt_tick == 16 then
        magic = 0.06252
    else if dt_tick == 17 then
        magic = 0.05882
    else if dt_tick == 18 then
        magic = 0.05555
    end
  end 
 end
end
    --draw ind
    local col = dt_CCol:get()
    local fade = dt_FCol:get()
    if dt_tick < 14 then
    col = dt_UCol:get()
    end
    local isr = dt_tick < 14 and "X " or "✔ "
    local text = string.format(" fcsb-yaw DT | Ready: "..isr)
    if local_player:get_prop("m_iHealth") > 0 then
    if dt_ind_tog:get() and choice == 1 then
    local dtText = string.format(" fcsb-yaw DT | ticks："..dt_tick)
	local text_size = 12,12
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 2), color_t(255,255,255,150))
    render.rect_filled(vec2_t(posx, posy), vec2_t(180*dt_tick*magic, 2), col)
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 20), color_t(0,0,0,150))
    render.text(verdana, dtText, vec2_t(posx+10, posy+3), color_t(255,255,255))
    end  
    if dt_ind_tog:get() and choice == 2 then
    local dtText = string.format(" fcsb-yaw DT | ticks："..dt_tick)
    local text_size = 12,12
    render.text(verdana, text, vec2_t(posx+10, posy+3), color_t(255,255,255)) --text
    render.rect_filled(vec2_t(posx, posy), vec2_t(180, 20), color_t(0,0,0,120)) --shadow
    render.push_alpha_modifier(pulse)
    render.rect_fade(vec2_t(posx, posy-1), vec2_t(90, 1), fade, col, true) --top left
    render.rect_fade(vec2_t(posx+90, posy-1), vec2_t(90, 1), col, fade, true) --top right
    render.rect_fade(vec2_t(posx, posy+20), vec2_t(90, 1), fade, col, true) --down left
    render.rect_fade(vec2_t(posx+90, posy+20), vec2_t(90, 1), col, fade, true) --down right
    render.pop_alpha_modifier() 
    end
    --change dt speed
    if dt_tog:get() and dt_ref[2]:get() then
        cvars.sv_maxusrcmdprocessticks:set_int(dt_speed:get()+2)
        cvars.cl_clock_correction:set_int(0)
        cvars.cl_clock_correction_adjustment_max_amount:set_int(450)
    else
        cvars.sv_maxusrcmdprocessticks:set_int(16)
        cvars.cl_clock_correction:set_int(1)
    end
end
end

callbacks.add(e_callbacks.PAINT, dt_ind)

local backup_cache = {
    side_stand = side_stand:get(),
    side_move = side_move:get(),
    side_slowm = side_slowm:get(),

    llimit_stand = llimit_stand:get(),
    rlimit_stand = rlimit_stand:get(),

    llimit_move = llimit_move:get(),
    rlimit_move = rlimit_move:get(),

    llimit_slowm = llimit_slowm:get(),
    rlimit_slowm = rlimit_slowm:get()
}

local vars = {
    yaw_base = 0,
    _jitter = 0,
    _yaw_add = 0,
    _limit = 0,
    val_n = 0,
    desync_val = 0,
    yaw_offset = 0,
    temp_vars = 0,
    revs = 1,
    last_time = 0
}

local handle_yaw = 0

local function on_shutdown()
    side_stand:set(backup_cache.side_stand)
    side_move:set(backup_cache.side_move)
    side_slowm:set(backup_cache.side_slowm)

    llimit_stand:set(backup_cache.llimit_stand)
    rlimit_stand:set(backup_cache.rlimit_stand)

    llimit_move:set(backup_cache.llimit_move)
    rlimit_move:set(backup_cache.rlimit_move)

    llimit_slowm:set(backup_cache.llimit_slowm)
    rlimit_slowm:set(backup_cache.rlimit_slowm)
end

local normalize_yaw = function(yaw)
    while yaw > 180 do yaw = yaw - 360 end
    while yaw < -180 do yaw = yaw + 360 end

    return yaw
end

local function calc_shit(xdelta, ydelta)
    if xdelta == 0 and ydelta == 0 then
        return 0
    end
    
    return math.deg(math.atan2(ydelta, xdelta))
end

local function calc_angle(src, dst)
    local vecdelta = vec3_t(dst.x - src.x, dst.y - src.y, dst.z - src.z)
    local angles = angle_t(math.atan2(-vecdelta.z, math.sqrt(vecdelta.x^2 + vecdelta.y^2)) * 180.0 / math.pi, (math.atan2(vecdelta.y, vecdelta.x) * 180.0 / math.pi), 0.0)
    return angles
end

local function calc_distance(src, dst)
    return math.sqrt(math.pow(src.x - dst.x, 2) + math.pow(src.y - dst.y, 2) + math.pow(src.z - dst.z, 2) )
end

local function get_distance_closest_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_origin = local_player:get_render_origin()
    local bestenemy = nil
    local dis = 10000
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_distance = calc_distance(enemy_origin, local_origin)
        if cur_distance < dis then
            dis = cur_distance
            bestenemy = enemy
        end
    end
    return bestenemy
end

local function get_crosshair_closet_enemy()
    local enemies_only = entity_list.get_players(true) 
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_eyepos = local_player:get_eye_position()
    local local_angles = engine.get_view_angles()
    local bestenemy = nil
    local fov = 180
    for _, enemy in pairs(enemies_only) do 
        local enemy_origin = enemy:get_render_origin()
        local cur_fov = math.abs(normalize_yaw(calc_shit(local_eyepos.x - enemy_origin.x, local_eyepos.y - enemy_origin.y) - local_angles.y + 180))
        if cur_fov < fov then
            fov = cur_fov
            bestenemy = enemy
        end
    end

    return bestenemy
end

function on_paint()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local local_eyepos = local_player:get_eye_position()
    local view_angle = engine.get_view_angles()
    if yaw_base:get() == 1 then
        vars.yaw_base = view_angle.y
    elseif yaw_base:get() == 2 then
        vars.yaw_base = get_crosshair_closet_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_crosshair_closet_enemy():get_render_origin()).y
    elseif yaw_base:get() == 3 then  
        vars.yaw_base = get_distance_closest_enemy() == nil and view_angle.y or calc_angle(local_eyepos, get_distance_closest_enemy():get_render_origin()).y
    end
end

function on_antiaim(ctx)
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if disabler:get(1) then 
        if ref_peek_key:get() == true then 
            on_shutdown()
            return
        end
    end
    if disabler:get(2) then
        if antiaim.get_manual_override() == 1 or antiaim.get_manual_override() == 3 then 
            on_shutdown()
            return
        end
    end
    if disabler:get(3) then 
        if antiaim.get_manual_override() == 2 then 
            on_shutdown()
            return
        end
    end
    if disabler:get(4) then
        if ref_onshot_key:get() then 
            on_shutdown()
            return
        end
    end

    if math.abs(global_vars.tick_count() - vars.temp_vars) > 1 then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end

    local is_invert = vars.revs == 1 and key_bind:get() and false or true

    vars._jitter = jitter_offset:get()
    vars._limit = fake_limit:get()
    
    _l_yaw_add = l_yaw_add:get()
    _r_yaw_add = r_yaw_add:get()

    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars._limit/120) or vars._limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add

    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)

    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(4)
    side_move:set(4)
    side_slowm:set(4)

    llimit_stand:set(vars._limit/2 * 10/6)
    rlimit_stand:set(vars._limit * 10/6)

    llimit_move:set(vars._limit/2 * 10/6)
    rlimit_move:set(vars._limit * 10/6)

    llimit_slowm:set(vars._limit/2 * 10/6)
    rlimit_slowm:set(vars._limit * 10/6)
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	if multi_selection:get(1) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

	if find_slow_walk_key:get() and multi_selection:get(2) then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
	end
end)
--binds
local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable") -- get doubletap
local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable") -- get hideshots
local isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable") -- get autopeek
local isSW = menu.find("misc","main","movement","slow walk", "enable") -- get Slow Walk
local isMD = menu.find("aimbot", "scout", "target overrides", "force min. damage") -- get damage override
local isBA = menu.find("aimbot", "scout", "target overrides", "force hitbox") -- get froce baim
local isSP = menu.find("aimbot", "scout", "target overrides", "force safepoint") -- get safe point
local isAA = menu.find("antiaim", "main", "angles", "yaw base") -- get yaw base

--indicators
local fake = antiaim.get_fake_angle()
local currentTime = global_vars.cur_time
local function indicators()
    if not engine.is_connected() then
        return
    end

    if not engine.is_in_game() then
        return
    end

    local local_player = entity_list.get_local_player()

    if not local_player:get_prop("m_iHealth") then
        return
    end
    --screen size
    local x = render.get_screen_size().x
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="R"
    else
        invert ="L"
    end

    --screen size
    local ay = 40
    local alpha = math.min(math.floor(math.sin((global_vars.real_time()%3) * 4) * 175 + 50), 255)
    if local_player:is_alive() then -- check if player is alive
    --render
    local eternal_ts = render.get_text_size(pixel, "muie rapid ")
    render.text(pixel, "muie rapid", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    render.text(pixel, "stable", vec2_t(x/2+eternal_ts.x-2, y/2+ay), color_t(255, 130, 130, alpha), 10, true)
    ay = ay + 10.5
    
    local text_ =""
    local clr0 = color_t(0, 0, 0, 0)
    if isSW[2]:get() then
        text_ ="DANGEROUS+ "
        clr0 = color_t(255, 50, 50, 255)
    else
        text_ ="DYNAMIC- "
        clr0 = color_t(255, 117, 107, 255)
    end

    local d_ts = render.get_text_size(pixel, text_)
    render.text(pixel, text_, vec2_t(x/2, y/2+ay), clr0, 10, true)
    render.text(pixel, math.floor(fake).."", vec2_t(x/2+d_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5
    
    local fake_ts = render.get_text_size(pixel, "FAKE YAW: ")
    render.text(pixel, "FAKE YAW:", vec2_t(x/2, y/2+ay), color_t(130, 130, 255, 255), 10, true)
    render.text(pixel, invert, vec2_t(x/2+fake_ts.x, y/2+ay), color_t(255, 255, 255, 255), 10, true)
    ay = ay + 10.5

    local asadsa = math.min(math.floor(math.sin((exploits.get_charge()%2) * 1) * 122), 100)
    if isAP[2]:get() and isDT[2]:get() then 
        local ts_tick = render.get_text_size(pixel, "IDEALTICK ")
        render.text(pixel, "IDEALTICK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        render.text(pixel, "x"..asadsa, vec2_t(x/2+ts_tick.x, y/2+ay), exploits.get_charge() == 1 and color_t(0, 255, 0, 255) or color_t(255, 0, 0, 255), 10, true)
        ay = ay + 10.5
    else
        if isAP[2]:get() then
            render.text(pixel, "PEEK", vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
            ay = ay + 10.5
        end
        if isDT[2]:get() then
        if exploits.get_charge() >= 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(0, 255, 0, 255), 10, true)
            ay = ay + 10.5
        end
        if exploits.get_charge() < 1 then
            render.text(pixel, "DT", vec2_t(x/2, y/2+ay), color_t(255, 0, 0, 255), 10, true)
            ay = ay + 10.5
        end
    end
    end

    if isMD[2]:get() then
        render.text(pixel, "MD: "..tostring(isMD[2]:get()), vec2_t(x/2, y/2+ay), color_t(255, 255, 255, 255), 10, true)
        ay = ay + 10.5
    end

    local ax = 0
    if isHS[2]:get() then
        render.text(pixel, "ONSHOT", vec2_t(x/2, y/2+ay), color_t(250, 173, 181, 255), 10, true)
        ay = ay + 10.5
    end

    render.text(pixel, "BAIM", vec2_t(x/2, y/2+ay), isBA[2]:get() == 2 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
    ax = ax + render.get_text_size(pixel, "BAIM ").x

    render.text(pixel, "FS", vec2_t(x/2+ax, y/2+ay), isAA:get() == 5 and color_t(255, 255, 255, 255) or color_t(255, 255, 255, 128), 10, true)
end
end

--callback
callbacks.add(e_callbacks.PAINT,indicators)