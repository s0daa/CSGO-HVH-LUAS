local jitter_offset = menu.add_slider("group", "jitter offset", -180, 180)
local jitter_speed = menu.add_slider("group", "jitter speed", 1, 4)
local lfake_limit = menu.add_slider("group", "left limit", 1, 60)
local rfake_limit = menu.add_slider("group", "right limit", 1, 60)
local l_yaw_add = menu.add_slider("group", "left yaw add", -50, 50)
local r_yaw_add = menu.add_slider("group", "right yaw add", -50, 50)
local yaw_base = menu.add_selection("group", "yaw base", {"viewangle", "at target(crosshair)", "at target(distance)"})

local disabler = menu.add_multi_selection("on disable","tank disabler",{"on peek","on manual sideways","on manual backward","on hideshots", "on Freestanding"})

local key_name, key_bind = unpack(menu.find("antiaim","main","manual","invert desync"))
local ref_hide_shot, ref_onshot_key = unpack(menu.find("aimbot", "general", "exploits", "hideshots", "enable"))

local ref_auto_peek, ref_peek_key = unpack(menu.find("aimbot","general","misc","autopeek"))

local ref_freestand, ref_frees_key = unpack(menu.find("antiaim","main","auto direction","enable"))


local side_stand = menu.find("antiaim","main", "desync","side#stand")
local llimit_stand = menu.find("antiaim","main", "desync","left amount#stand")
local rlimit_stand = menu.find("antiaim","main", "desync","right amount#stand")
local side_move = menu.find("antiaim","main", "desync","side#move")
local llimit_move = menu.find("antiaim","main", "desync","left amount#move")
local rlimit_move = menu.find("antiaim","main", "desync","right amount#move")
local side_slowm = menu.find("antiaim","main", "desync","side#slow walk")
local llimit_slowm = menu.find("antiaim","main", "desync","left amount#slow walk")
local rlimit_slowm = menu.find("antiaim","main", "desync","right amount#slow walk")

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
    l_limit = 0,
    r_limit = 0,
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
    if disabler:get(5) then
        if ref_frees_key:get() then
            on_shutdown()
            return
        end
    end

    local speed = 5 - jitter_speed:get()

    if math.abs(global_vars.tick_count() - vars.temp_vars) > speed then
       vars.revs = vars.revs == 1 and 0 or 1
       vars.temp_vars = global_vars.tick_count()
    end

    local is_invert = vars.revs == 1 and key_bind:get() and false or true

    vars._jitter = jitter_offset:get()
    vars.l_limit = lfake_limit:get()
    vars.r_limit = rfake_limit:get()
    
    _l_yaw_add = l_yaw_add:get()
    _r_yaw_add = r_yaw_add:get()

    vars.val_n = vars.revs == 1 and vars._jitter or -(vars._jitter)
    vars.desync_val = vars.val_n > 0 and -(vars.l_limit/60) or vars.r_limit/60
    vars._yaw_add = vars.val_n > 0 and _l_yaw_add or _r_yaw_add

    handle_yaw = normalize_yaw(vars.val_n + vars._yaw_add + vars.yaw_base + 180)

    ctx:set_invert_desync(is_invert)
    ctx:set_desync(vars.desync_val)
    ctx:set_yaw(handle_yaw)
    
    side_stand:set(vars.val_n > 0 and 1 or 2)
    side_move:set(vars.val_n > 0 and 1 or 2)
    side_slowm:set(vars.val_n > 0 and 1 or 2)

    llimit_stand:set(vars.l_limit * 10/6)
    rlimit_stand:set(vars.r_limit * 10/6)

    llimit_move:set(vars.l_limit * 10/6)
    rlimit_move:set(vars.r_limit * 10/6)

    llimit_slowm:set(vars.l_limit * 10/6)
    rlimit_slowm:set(vars.r_limit * 10/6)
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)