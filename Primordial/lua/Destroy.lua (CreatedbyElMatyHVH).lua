local build = "Beta 7.4"

local lua_menu = {
    --main
    user = menu.add_text("De$troy | Information", string.format("Creado Por: El Maty HVH")),
    buildstate = menu.add_text("De$troy | Information", string.format("Version: %s", build)),

}

local handle_yaw = 0
local fake_limit = menu.add_slider("De$troy AA", "fake limit", 1, 15)
local jitter_offset = menu.add_slider("De$troy AA", "jitter offset", -40, 0)
local l_yaw_add = menu.add_slider("De$troy AA", "left yaw add", -10, 10)
local r_yaw_add = menu.add_slider("De$troy AA", "right yaw add", -10, 10)
local yaw_base = menu.add_selection("De$troy AA", "yaw base", {"viewangle", "at target(crosshair)", "at target(distance)"})

local disabler = menu.add_multi_selection("Desactivar TKAA","Desactivar Tank AA",{"Con el Autopeek"})

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

client.log_screen('Lua created by elite.yb#4752')

-- set our colors here ig --
local colors = {
    white = color_t(255, 255, 255),
    red   = color_t(255, 0, 0),
    gray  = color_t(100, 100, 100)
}

-- references cuz i couldn't be fucked to type this everytime --
local ref = {
	aimbot = {
		dt_ref = menu.find("aimbot","general","exploits","doubletap","enable"),
		hs_ref = menu.find("aimbot","general","exploits","hideshots","enable"),
		hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox"),
        safepoint_ovride = menu.find("aimbot", "auto", "target overrides", "force safepoint")
	},
}

local globals = {
    crouching          = false,
    standing           = false,
    jumping            = false,
    running            = false,
    pressing_move_keys = false
}

local screen_size    = render.get_screen_size()


callbacks.add(e_callbacks.SETUP_COMMAND, function(cmd)
    local local_player = entity_list.get_local_player()
    globals.pressing_move_keys = (cmd:has_button(e_cmd_buttons.MOVELEFT) or cmd:has_button(e_cmd_buttons.MOVERIGHT) or cmd:has_button(e_cmd_buttons.FORWARD) or cmd:has_button(e_cmd_buttons.BACK))

    if (not local_player:has_player_flag(e_player_flags.ON_GROUND)) or (local_player:has_player_flag(e_player_flags.ON_GROUND) and cmd:has_button(e_cmd_buttons.JUMP)) then
        globals.jumping = true
    else
        globals.jumping = false
    end

    if globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.running = false
            else
                globals.running = true
                globals.crouching = false
            end
        elseif globals.jumping and not cmd:has_button(e_cmd_buttons.JUMP) then
            globals.running = false
            globals.crouching = false
        end

        globals.standing = false
    elseif not globals.pressing_move_keys then
        if not globals.jumping then
            if cmd:has_button(e_cmd_buttons.DUCK) then
                globals.crouching = true
                globals.standing = false
            else
                globals.standing = true
                globals.crouching = false
            end
        else
            globals.standing = false
            globals.crouching = false
        end
        
        globals.running = false
    end
end)








local rage_f = {
    customdt_check                = menu.add_checkbox("De$troy  <ragebot", "override doubletap", false),
    customdt_speed                = menu.add_slider("De$troy  /  ragebot  /  main", "speed", 10, 22),
    customdt_waning               = menu.add_text("De$troy  /  ragebot  /  main", "this dt speed may cause unregistered shots."),
    customdt_corrections          = menu.add_checkbox("De$troy  /  ragebot  /  main", "disable corrections", false),
    recharge_check                = menu.add_checkbox("De$troy  /  ragebot  /  main", "faster recharge", false),
    disableinterp_check           = menu.add_checkbox("De$troy  /  ragebot  /  main", "disable interpolation", false),
    prediction_check              = menu.add_checkbox("De$troy  /  ragebot  /  main", "better prediction", false),
    prediction_warning            = menu.add_text("De$troy  /  ragebot  /  main", "recommended to use this feature only with force prediction."),
    early_check                   = menu.add_checkbox("De$troy  /  ragebot  /  main", "early autostop on autopeek", false),
    early_weapons                 = menu.add_multi_selection("De$troy  /  ragebot  /  main", "weapons", {"scout", "awp"}),
}
rage_f.customdt_speed:set(15)


local function drawshit()
    -- maintab
    maintab.tabselection:set_visible(allowload == true)
    maintab.textaa:set_visible(allowload == true)
    maintab.cfg_import:set_visible(allowload == true)
    maintab.cfg_export:set_visible(allowload == true)
    maintab.cfg_default:set_visible(allowload == true)
    maintab.space123:set_visible(allowload == true)
    maintab.discordlink:set_visible(allowload == true)
    -- rage
    rage_f.customdt_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.customdt_speed:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and allowload == true)
    rage_f.customdt_corrections:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and allowload == true)
    rage_f.customdt_waning:set_visible(maintab.tabselection:get() == 1 and rage_f.customdt_check:get() and rage_f.customdt_speed:get() >16 and allowload == true)
    rage_f.recharge_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.disableinterp_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.prediction_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.prediction_warning:set_visible(maintab.tabselection:get() == 1 and rage_f.prediction_check:get() and not refs.prediction:get() and allowload == true)
    rage_f.early_check:set_visible(maintab.tabselection:get() == 1 and allowload == true)
    rage_f.early_weapons:set_visible(maintab.tabselection:get() == 1 and rage_f.early_check:get() and allowload == true)
    -- aa
    aa_f.aa_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_switchside:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_check:get() and allowload == true)
    aa_f.aa_animbreaker_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_animbreaker_main:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and allowload == true)
    aa_f.aa_animbreaker_legs:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and aa_f.aa_animbreaker_main:get(2) and allowload == true)
    aa_f.aa_animbreaker_other:set_visible(maintab.tabselection:get() == 2 and aa_f.aa_animbreaker_check:get() and allowload == true)
    aa_f.onshotfl_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.lc_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.lc_weapons:set_visible(maintab.tabselection:get() == 2 and aa_f.lc_check:get() and allowload == true)
    aa_f.lc_state_check:set_visible(maintab.tabselection:get() == 2 and aa_f.lc_check:get() and allowload == true)
    aa_f.anti_zeus_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    aa_f.anti_zeus_max_dist:set_visible(maintab.tabselection:get() == 2 and aa_f.anti_zeus_check:get() and allowload == true)
    aa_f.warmup_check:set_visible(maintab.tabselection:get() == 2 and allowload == true)
    -- visual
    visual_f.color_theme_text:set_visible(maintab.tabselection:get() == 3 and visual_f.color_theme_mode:get() == 1 and allowload == true)
    visual_f.color_theme_text_2:set_visible(maintab.tabselection:get() == 3 and visual_f.color_theme_mode:get() == 1 and allowload == true)
    visual_f.color_theme_alpha:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.fonttext:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.fontlink:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.lobby_waning:set_visible(maintab.tabselection:get() == 3 and not engine.is_connected() and allowload == true)
    visual_f.indicators_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.indicators_customisation:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and allowload == true)
    visual_f.indicators_customisation_bg:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(2) and allowload == true)
    visual_f.indicators_customisation_rect:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(2) and allowload == true)
    visual_f.indicators_state_color:set_visible(maintab.tabselection:get() == 3 and visual_f.indicators_check:get() and visual_f.indicators_customisation:get(3) and allowload == true)
    visual_f.watermark_custom_watername:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and allowload == true)
    visual_f.watermark_custom_custom:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and visual_f.watermark_custom_watername:get() == 4 and allowload == true)
    visual_f.watermark_custom_showuid:set_visible(maintab.tabselection:get() == 3 and visual_f.windows_combo:get(1) and allowload == true)
    visual_f.lethal_indicator_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.slowdownind_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.infobox_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.color_theme_mode:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.penisdot_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.floydmode_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.windows_combo:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.windows_mode:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.disable_primomark:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    visual_f.zeus_warning_check:set_visible(maintab.tabselection:get() == 3 and allowload == true)
    -- misc
    misc_f.trashtalk_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.trashtalk_mode:set_visible(maintab.tabselection:get() == 4 and misc_f.trashtalk_check:get() and allowload == true)
    misc_f.tt_hs_check:set_visible(maintab.tabselection:get() == 4 and misc_f.trashtalk_check:get() and misc_f.trashtalk_mode:get() == 2 and allowload == true)
    misc_f.clantag_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.clantag_mode:set_visible(maintab.tabselection:get() == 4 and misc_f.clantag_check:get() and allowload == true)
    misc_f.gh_fix_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.autobuy_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.localserver_check:set_visible(maintab.tabselection:get() == 4 and allowload == true)
    misc_f.localserver_configure:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_bottext:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get()and allowload == true)
    misc_f.localserver_botaddct:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_botaddt:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    misc_f.localserver_botkick:set_visible(maintab.tabselection:get() == 4 and misc_f.localserver_check:get() and allowload == true)
    -- info
    infotab.space132:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforlogo:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.space12:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforbild:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforver:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforuser:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforcord:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    infotab.neforlog:set_visible(maintab.tabselection:get() == 5 and allowload == true)
    ----- aa shit
    aa_f.conditionselection:set_visible(aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    -- override global
    aa_f.aa_overg_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_overg_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --jitter type
    aa_f.aa_jittertype_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jittertype_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)

    aa_f.aa_randomise_global_left_check:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_global_left1:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_left_check:get() and allowload == true)
    aa_f.aa_randomise_global_left2:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_left_check:get() and allowload == true)
    aa_f.aa_randomise_global_right_check:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_global_right1:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_right_check:get() and allowload == true)
    aa_f.aa_randomise_global_right2:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_global_right_check:get() and allowload == true)
    
    aa_f.aa_randomise_stand_left_check:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_stand_left1:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_left_check:get() and allowload == true)
    aa_f.aa_randomise_stand_left2:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_left_check:get() and allowload == true)
    aa_f.aa_randomise_stand_right_check:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_stand_right1:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_right_check:get() and allowload == true)
    aa_f.aa_randomise_stand_right2:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_stand_right_check:get() and allowload == true)

    aa_f.aa_randomise_move_left_check:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_move_left1:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_left_check:get() and allowload == true)
    aa_f.aa_randomise_move_left2:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_left_check:get() and allowload == true)
    aa_f.aa_randomise_move_right_check:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_move_right1:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_right_check:get() and allowload == true)
    aa_f.aa_randomise_move_right2:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_move_right_check:get() and allowload == true)

    aa_f.aa_randomise_air_left_check:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_air_left1:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_left_check:get() and allowload == true)
    aa_f.aa_randomise_air_left2:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_left_check:get() and allowload == true)
    aa_f.aa_randomise_air_right_check:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_air_right1:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_right_check:get() and allowload == true)
    aa_f.aa_randomise_air_right2:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_air_right_check:get() and allowload == true)

    aa_f.aa_randomise_airduck_left_check:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_airduck_left1:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_left_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_left2:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_left_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_right_check:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_airduck_right1:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_right_check:get() and allowload == true)
    aa_f.aa_randomise_airduck_right2:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_airduck_right_check:get() and allowload == true)

    aa_f.aa_randomise_crouch_left_check:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_crouch_left1:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_left_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_left2:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_left_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_right_check:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_crouch_right1:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_right_check:get() and allowload == true)
    aa_f.aa_randomise_crouch_right2:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_crouch_right_check:get() and allowload == true)

    aa_f.aa_randomise_slowwalk_left_check:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_slowwalk_left1:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_left_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_left2:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_left_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_right_check:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_randomise_slowwalk_right1:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_right_check:get() and allowload == true)
    aa_f.aa_randomise_slowwalk_right2:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_randomise_slowwalk_right_check:get() and allowload == true)
    --
    --yaw
    aa_f.aa_yawlimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_yawlimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_yawlimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --yaw jitter
    aa_f.aa_jitter_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_jitter_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --yaw offset
    aa_f.aa_offset_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_offset_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --fake
    aa_f.aa_fakelimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_fakelimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_fakelimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --lean
    aa_f.aa_leanlimleft_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    aa_f.aa_leanlimright_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    aa_f.aa_leanlimright_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    aa_f.aa_leanlimright_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    aa_f.aa_leanlimright_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    aa_f.aa_leanlimright_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    aa_f.aa_leanlimright_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    --
    aa_f.aa_leanlimleft_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)
    aa_f.aa_leanlimright_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)
    --
    aa_f.aa_lean_check_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    aa_f.aa_lean_check_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and allowload == true)
    --
    aa_f.aa_lean_mode_global:set_visible(aa_f.conditionselection:get() == 1 and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_global:get() and allowload == true)
    aa_f.aa_lean_mode_stand:set_visible(aa_f.conditionselection:get() == 2 and aa_f.aa_overg_stand:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_stand:get() and allowload == true)
    aa_f.aa_lean_mode_move:set_visible(aa_f.conditionselection:get() == 3 and aa_f.aa_overg_move:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_move:get() and allowload == true)
    aa_f.aa_lean_mode_air:set_visible(aa_f.conditionselection:get() == 4 and aa_f.aa_overg_air:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_air:get() and allowload == true)
    aa_f.aa_lean_mode_airduck:set_visible(aa_f.conditionselection:get() == 5 and aa_f.aa_overg_airduck:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_airduck:get() and allowload == true)
    aa_f.aa_lean_mode_crouch:set_visible(aa_f.conditionselection:get() == 6 and aa_f.aa_overg_crouch:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_crouch:get() and allowload == true)
    aa_f.aa_lean_mode_slowwalk:set_visible(aa_f.conditionselection:get() == 7 and aa_f.aa_overg_slowwalk:get() and aa_f.aa_check:get() and maintab.tabselection:get() == 2 and aa_f.aa_lean_check_slowwalk:get() and allowload == true)

    unregtab.text1:set_visible(allowload == false)
    unregtab.text2:set_visible(allowload == false)
    unregtab.text3:set_visible(allowload == false)
    unregtab.text4:set_visible(allowload == false)
    unregtab.contactscopy:set_visible(allowload == false)
end



local killsays = {
    '1',
    'Random',
    'Retard',
    
}
local function table_lengh(data) 
    if type(data) ~= 'table' then
        return 0													
    end
    local count = 0
    for _ in pairs(data) do
        count = count + 1
    end
    return count
end

local function on_event(event)
    local lp = entity_list.get_local_player() --grabbing out local player
    local kill_cmd = 'say ' .. killsays[math.random(table_lengh(killsays))] --randomly selecting a killsay
    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    engine.execute_cmd(kill_cmd) 
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death")