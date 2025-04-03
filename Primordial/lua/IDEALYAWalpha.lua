---- lol deobfuscated by stylez#0798 (i know that this is paste lua)

local fake_limit = menu.add_slider("Tank preset", "fake limit", 1, 60)
local jitter_offset = menu.add_slider("Tank preset", "jitter offset", 0, 90)
local l_yaw_add = menu.add_slider("Tank preset", "left yaw add", -50, 50)
local r_yaw_add = menu.add_slider("Tank preset", "right yaw add", -50, 50)
local yaw_base = menu.add_selection("Tank preset", "yaw base", {"viewangle", "at target(crosshair)", "at target(distance)"})

local disabler = menu.add_multi_selection("on disable","tank disabler",{"on peek","on manual sideways","on manual backward","on hideshots"})

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


local variables = {
    main_font = render.create_font("Segoe Ui", 13, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
}

local math_funcs = { --// Dk who this func is from was given it by a homie B), I store it like this bc it doesn't need to take up space in my editor.
    fadeInOut = function ()
        return math.floor(math.sin(math.abs((math.pi * -1) + (global_vars.cur_time() * 1.5) % (math.pi * 2))) * 255);
    end,
    get_min_dmg = function (wpn_type) --// thnx classy.
        local menu_ref = menu.find("aimbot",wpn_type,"target overrides","force min. damage")
        local force_lethal = menu.find("aimbot",wpn_type,"target overrides","force lethal shot")
        local hitbox_ovr = menu.find("aimbot",wpn_type,"target overrides","force hitbox")
        local force_sp = menu.find("aimbot",wpn_type,"target overrides","force safepoint")
        local force_hc = menu.find("aimbot",wpn_type,"target overrides","force hitchance")
        return {menu_ref[1]:get(), menu_ref[2]:get(), force_lethal[2]:get(), hitbox_ovr[2]:get(), force_sp[2]:get(), force_hc[2]:get()}
    end,
    get_screen_center = function ()
        local x,y = render.get_screen_size().x / 2, render.get_screen_size().y / 2
        return {x,y}
    end
}

local references = {
    aimbot = {
        double_tap = menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable'),
        hideshots = menu.find('aimbot', 'general', 'exploits', 'hideshots', 'enable'),
    },
    antiaim = {
        pitch = menu.find('antiaim', 'main', 'angles', 'pitch'),
        yaw_base = menu.find('antiaim', 'main', 'angles', 'yaw base'),
        yaw_add = menu.find('antiaim', 'main', 'angles', 'yaw add'),
        rotate = menu.find('antiaim', 'main', 'angles', 'rotate'),
        jitter_mode = menu.find('antiaim', 'main', 'angles', 'jitter mode'),
        jitter_add = menu.find('antiaim', 'main', 'angles', 'jitter add'),
        body_lean = menu.find('antiaim', 'main', 'angles', 'body lean'),
    }

}

local groups = {
    ['auto'] = 0,
    ['scout'] = 1,
    ['awp'] = 2,
    ['heavy pistols'] = 3,
    ['pistols'] = 4,
    ['other'] = 5,
}

local current_min = nil
local key_active = nil
local force_lethal = nil
local hitbox_ovr = nil
local force_sp = nil
local force_hc = nil
local indicators = menu.add_checkbox('Indicators', 'Enable', true)
local indicator_selection = menu.add_multi_selection('Indicators', 'Indicator selection', {'Desync bar', 'Double tap', 'FL', 'Min damage ovr.', 'Hide shots', 'Logo', 'Auto Peek', 'Force Lethal', 'Hitbox ovr.', 'Force Safepoint', 'Hitchance ovr.'})
local height_slider = menu.add_slider('Indicators', 'Height',0, 100)
local colorpicker = indicators:add_color_picker('Indicator Color Picker', color_t(110, 181, 255, 255))
local autopeek = menu.find('aimbot', 'general', 'misc', 'autopeek')

local function get_weapon_group() --// Classy also did a func like this, might be better not sure.
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

local function draw_indicators() --// Code very bad, don't look here unless you wanna go blind B).
    if (not entity_list.get_local_player() or not entity_list.get_local_player():is_alive() or not indicators:get()) then
        return;
    end

    local l = 0
    local bar_color = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b)
    local bar_color_alpha = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b, colorpicker:get().a)
    local fadeinout = color_t(colorpicker:get().r, colorpicker:get().g, colorpicker:get().b, math_funcs.fadeInOut())
    local get_choked_cmds = engine.get_choked_commands()

    if (indicator_selection:get('Logo')) then
        render.text(variables.main_font, 'IDEAL-YAW', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), fadeinout, true)
        l = l + 1
    end

    if (indicator_selection:get('Desync bar')) then
        render.rect_fade(vec2_t(math_funcs.get_screen_center()[1] - antiaim.get_max_desync_range(), math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), vec2_t(antiaim.get_max_desync_range(), 3), bar_color_alpha, bar_color, true)
        render.rect_fade(vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), vec2_t(antiaim.get_max_desync_range(), 3), bar_color, bar_color_alpha, true)
        l = l + 1
    end

    if (indicator_selection:get('Min damage ovr.') and get_weapon_group()[2]) then
        render.text(variables.main_font, get_weapon_group()[1], vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('FL') and get_choked_cmds >= 4 and not references.aimbot.double_tap[2]:get() and not references.aimbot.hideshots[2]:get()) then
        render.text(variables.main_font, 'FL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    elseif (indicator_selection:get('FL') and get_choked_cmds <= 4 and not references.aimbot.double_tap[2]:get() and not references.aimbot.hideshots[2]:get()) then --// Really bad way of checking if "breaking" LC, would be done better if I had the knowledge on how to do it B)
        render.text(variables.main_font, 'FL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), color_t(255, 0, 0), true)
        l = l + 1
    end

    if (indicator_selection:get('Hide shots') and references.aimbot.hideshots[2]:get() and not references.aimbot.double_tap[2]:get()) then
        render.text(variables.main_font, 'HS', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Double tap') and exploits.get_charge() >= 14 and references.aimbot.double_tap[2]:get()) then
        render.text(variables.main_font, 'DT', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Auto Peek') and autopeek[2]:get()) then
        render.text(variables.main_font, 'AP', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Force Lethal') and get_weapon_group()[3]) then
        render.text(variables.main_font, 'LETHAL', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Hitbox ovr.') and get_weapon_group()[4]) then
        render.text(variables.main_font, 'HB', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Force Safepoint') and get_weapon_group()[5]) then
        render.text(variables.main_font, 'SP', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end

    if (indicator_selection:get('Hitchance ovr.') and get_weapon_group()[6]) then
        render.text(variables.main_font, 'HC', vec2_t(math_funcs.get_screen_center()[1], math_funcs.get_screen_center()[2] + height_slider:get() + (l*13)), bar_color, true)
        l = l + 1
    end
end

local function on_paint()
    if (indicators:get()) then
        draw_indicators()
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)


local multi_selection = menu.add_multi_selection("Leg Anim", "selection", {"Jitter", "Static aslow walk"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	if multi_selection:get(1) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

	if find_slow_walk_key:get() and multi_selection:get(2) then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
	end
end)
