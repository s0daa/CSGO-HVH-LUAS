local fake_limit = menu.add_slider("group", "fake limit", 1, 60)
local jitter_offset = menu.add_slider("group", "jitter offset", 0, 90)
local l_yaw_add = menu.add_slider("group", "left yaw add", -50, 50)
local r_yaw_add = menu.add_slider("group", "right yaw add", -50, 50)
local yaw_base = menu.add_selection("group", "yaw base", {"viewangle", "at target(crosshair)", "at target(distance)"})

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


client.log_screen('Lua created by Stitch13377.')

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

local indicator = menu.add_checkbox("Main", "Indicators")
local ind_col = indicator:add_color_picker("Indicators Color")

local function indicators()
    if not engine.is_in_game() then return end
    local local_player = entity_list.get_local_player()
    if not local_player:is_alive() then return end
    if not indicator:get() then return end

    local lethal         = local_player:get_prop("m_iHealth") <= 92
	local font_inds      = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font
	local x, y           = screen_size.x / 2, screen_size.y / 2
    local indi_color     = ind_col:get()
    local text_size      = render.get_text_size(font_inds, "Bismuth.yaw")
    local text_size2     = render.get_text_size(font_inds, "lethal")
    local cur_weap       = local_player:get_prop("m_hActiveWeapon")
    local current_state  = "Bismuth.yaw"
    local ind_offset     = 0

    if globals.jumping then
        current_state = "*jump"
    elseif globals.running then
        current_state = "*walk"
    elseif globals.standing then
        current_state = "*stand"
    elseif globals.crouching then
        current_state = "*duck"
    end
    
    -- LETHAL --
    if lethal then
        render.text(font_inds, "lethal", vec2_t(x + 2, y + 23), indi_color, true)
    end

    render.text(font_inds, current_state, vec2_t(x + 1, y + 33), indi_color, true)

    render.text(font_inds, "Bismuth.yaw", vec2_t(x + 2, y + 43), indi_color, true)

    -- DT --
    if ref.aimbot.dt_ref[2]:get() then
        if exploits.get_charge() < 1 then
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.red, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        else
            render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.white, true)
            ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
        end
    else
        render.text(font_inds, "DT", vec2_t(x - 20, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "DT")[0] + 5
    end

    -- HS --
    if ref.aimbot.hs_ref[2]:get() then
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    else
        render.text(font_inds, "HS", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "HS")[0] + 5
    end

    -- BA --
    if ref.aimbot.hitbox_override[2]:get() then
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    else
        render.text(font_inds, "BA", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "BA")[0] + 5
    end

    -- SP --
    if ref.aimbot.safepoint_ovride[2]:get() then
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.white, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    else
        render.text(font_inds, "SP", vec2_t(x - 20 + ind_offset, y + 53), colors.gray, true)
        ind_offset = ind_offset + render.get_text_size(font_inds, "SP")[0] + 5
    end
end

callbacks.add(e_callbacks.PAINT, function()
    ind_col:set_visible(indicator:get())

    indicators()
end)

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


--| Create the menu element(s)
local should_slide = menu.add_checkbox("los the lua guy", "slide on walk", true)
local should_jump = menu.add_checkbox("los the lua guy", "static legs in air", true)

--| The anti aim callback
local function on_anti_aim(antiaim_context)
    -- Return if the local player isn't alive
    local local_player = entity_list.get_local_player()
    if not local_player or not local_player:is_alive() then
        return
    end

    -- Set the MOVE_BLEND_WALK param if the checkbox is checked
    if should_slide:get() then
        antiaim_context:set_render_pose(e_poses.MOVE_BLEND_WALK, 0)
    end

    -- Set the JUMP_FALL param if the checkbox is checked
    if should_jump:get() then
        antiaim_context:set_render_pose(e_poses.JUMP_FALL, 1)
    end
end

--| Register the callback
callbacks.add(e_callbacks.ANTIAIM, on_anti_aim)   



--[[
   _____                         ____                                 _   _______ _____  
  / ____|                       |  _ \                               | | |__   __|  __ \ 
 | (___  _   _ ___  __ _ _ __   | |_) | __ _ _ __ _ __ _____      __ | |    | |  | |  | |
  \___ \| | | / __|/ _` | '_ \  |  _ < / _` | '__| '__/ _ \ \ /\ / / | |    | |  | |  | |
  ____) | |_| \__ \ (_| | | | | | |_) | (_| | |  | | | (_) \ V  V /  | |____| |  | |__| |
 |_____/ \__,_|___/\__,_|_| |_| |____/ \__,_|_|  |_|  \___/ \_/\_/   |______|_|  |_____/ 
                                                                                         
                                                                                         
    HIT AND MISS LOGGER VISUAL BY SLXYX SUSAN BARROW LTD
]]--

local enableSwag = menu.add_checkbox("susan barrow ltd | general", "enable logger", false)
local printtoConsole = menu.add_checkbox("susan barrow ltd | general", "print logs to console", false)

local amountonscreen = menu.add_slider("susan barrow ltd | modifiers", "amount of logs on screen at one time", 1, 10)
local timelogs = menu.add_slider("susan barrow ltd | modifiers", "time before logs fade", 0, 10)
local fontstyle = menu.add_selection("susan barrow ltd | modifiers", "font style", {"normal", "bold"})

local logs = {}
local logrender = {}
local logtime = {}
local boollog = {true,true,true,true,true}
local curTime = {}
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local fonts = {
    normal = render.create_font("Tahoma", 12, 100, e_font_flags.ANTIALIAS),
    bold = render.create_font("Tahoma Bold", 13, 500, e_font_flags.ANTIALIAS)
}

function drawLog()
    if not enableSwag:get() then return end
    local screen_size = render.get_screen_size()
    for i = 1, #logs do
        if logrender[i] then
            if not logtime[i] or not logs[i] then return end
            render.text(fontstyle:get() == 1 and fonts.normal or fonts.bold, logs[i], vec2_t(screen_size.x/2, screen_size.y/(1.25+i/45)), color_t(255, 255, 255, logtime[i]), true)
        end
    end
end

function onHit(e)
    local hitString = string.format("Hit %s in the %s [%s] for %s [%s] (hc: %s bt: %s)", e.player:get_name(), hitgroup_names[e.hitgroup + 1] or '?', hitgroup_names[e.aim_hitgroup + 1], e.damage, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, hitString); table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(hitString)
    end
    boollog[#logs] = true
end

function onMiss(e)
    local missString = string.format("Missed %s %s due to %s [%s] (hc: %s bt: %s)", e.player:get_name().."'s", hitgroup_names[e.aim_hitgroup + 1] or '?', e.reason_string, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, missString)
    table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(missString)
    end
    boollog[#logs] = true
end

function handleVisibility()
    for i = 1, #logs do
        if boollog[i] then
            curTime[i] = client.get_unix_time() + timelogs:get()
            boollog[i] = false
            logtime[i] = 255
        end
        if not curTime[i] then goto endrendering end
        if curTime[i] < client.get_unix_time() then
            logtime[i] = logtime[i] - 1
        end
        if logtime[i] == 10 then
            table.remove(logs, i);table.remove(logrender, i);table.remove(logtime, i);table.remove(boollog, i);table.remove(curTime, i)
        end
        ::endrendering::
    end 
end

callbacks.add(e_callbacks.AIMBOT_MISS, onMiss)
callbacks.add(e_callbacks.AIMBOT_HIT, onHit)

callbacks.add(e_callbacks.PAINT, function()
    drawLog(); handleVisibility()
end)


--| Create the remover checkbox
local sleeve_remover = menu.add_checkbox("Main", "Sleeve remover")

--| Store a cached value
local sleeve_cache = sleeve_remover:get()

--| Keep a material cache
local sleeve_material_cache = {}

--| The paint callback
local function on_paint()
    -- Cache the materials if checkbox changes
    if sleeve_cache ~= sleeve_remover:get() then
        materials.for_each(function(material)
            if material:get_name():find("sleeve") then
                table.insert(sleeve_material_cache, material)
            end
        end)
    end
    sleeve_cache = sleeve_remover:get()

    -- Update the NO_DRAW flag
    for k, v in next, sleeve_material_cache do
        v:set_flag(e_material_flags.NO_DRAW, sleeve_remover:get())
    end
end

--| Register the paint callback
callbacks.add(e_callbacks.PAINT, on_paint)        



--[[
       $$$$$\  $$$$$$\  $$$$$$$$\ $$\      $$\   $$\  $$$$$$\        $$\   $$\ $$$$$$\                 
       \__$$ |$$  __$$\ $$  _____|$$ |     $$ |  $$ |$$  __$$\       $$ |  $$ |\_$$  _|         $$\    
          $$ |$$ /  $$ |$$ |      $$ |     $$ |  $$ |$$ /  \__|      $$ |  $$ |  $$ |           $$ |   
          $$ |$$ |  $$ |$$$$$\    $$ |     $$ |  $$ |\$$$$$$\        $$ |  $$ |  $$ |        $$$$$$$$\ 
    $$\   $$ |$$ |  $$ |$$  __|   $$ |     $$ |  $$ | \____$$\       $$ |  $$ |  $$ |        \__$$  __|
    $$ |  $$ |$$ |  $$ |$$ |      $$ |     $$ |  $$ |$$\   $$ |      $$ |  $$ |  $$ |           $$ |   
    \$$$$$$  | $$$$$$  |$$$$$$$$\ $$$$$$$$\\$$$$$$  |\$$$$$$  |      \$$$$$$  |$$$$$$\          \__|   
     \______/  \______/ \________|\________|\______/  \______/        \______/ \______|                
                                                                                                   
     JOELUS UI CERTIFIED SCRIPT BY SLXYX MARY BARROW | UID 95 BIIIIIITCH (◣_◢)                                                                                            
                                                                                                   
]]--

local variables = {
    keybind = {
        x = menu.add_slider(" ui | hidden", "kb_x", 0, 3840),
        y = menu.add_slider(" ui | hidden", "kb_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        modes = {"[toggled]", "[held]", "[on]", "[on]","[off]"},
        alpha = 0,
        size = 140,
    },
    spectator = {
        x = menu.add_slider(" ui | hidden", "spec_x", 0, 3840),
        y = menu.add_slider(" ui | hidden", "spec_y", 0, 2160),
        offsetx = 0,
        offsety = 0,
        alpha = 0,
        list = {},
        size = 140,
    }
}

local keybindings = {
    ["double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["hide shots"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["auto peek"] = menu.find("aimbot","general","misc","autopeek"),
    ["fake duck"] = menu.find("antiaim","main","general","fake duck"),
    ["invert"] = menu.find("antiaim","main","manual","invert desync"),
    ["manual left"] = menu.find("antiaim","main","manual","left"),
    ["manual back"] = menu.find("antiaim","main","manual","back"),
    ["manual right"] = menu.find("antiaim","main","manual","right"),
    ["auto direction"] = menu.find("antiaim","main","auto direction","enable"),
    ["edge jump"] = menu.find("misc","main","movement","edge jump"),
    ["sneak"] = menu.find("misc","main","movement","sneak"),
    ["edge bug"] = menu.find("misc","main","movement","edge bug helper"),
    ["jump bug"] = menu.find("misc","main","movement","jump bug"),
    ["fire extinguisher"] = menu.find("misc","utility","general","fire extinguisher"),
    ["freecam"] = menu.find("misc","utility","general","freecam"),
}

local wtm_enable = menu.add_checkbox(" ui | watermark", "watermark")
local wtm_colour = wtm_enable:add_color_picker("watermark colour")

local keybind_enable = menu.add_checkbox(" ui | keybinds", "keybinds")
local keybind_colour = keybind_enable:add_color_picker("keybinds colour")

local spectator_enable = menu.add_checkbox(" ui | spectators", "spectators")
local spectator_colour = spectator_enable:add_color_picker("spectators colour")

local box_style = menu.add_selection(" ui | style", "box style", {"default solus", "rounded corners"})

menu.set_group_visibility(" ui | hidden", false)

local font = render.create_font("Verdana", 12, 24, e_font_flags.ANTIALIAS)

local function watermark()
    if not wtm_enable:get() then return end
    local screensize = render.get_screen_size()
    local h, m, s = client.get_local_time()
    local wtm_string = string.format("Bismuth.yaw | %s [%s] | %s ms | %s tick | %02d:%02d:%02d", user.name, user.uid, math.floor(engine.get_latency(e_latency_flows.INCOMING)), client.get_tickrate(), h, m, s)
    local wtm_size = render.get_text_size(font, wtm_string)
    render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 19), vec2_t(wtm_size.x+8, 1), wtm_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(screensize.x-wtm_size.x-14, 20), vec2_t(wtm_size.x+8, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(screensize.x-6, 19), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(screensize.x-11, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(screensize.x-wtm_size.x-22, 19), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(screensize.x-wtm_size.x-10, 23), 6, wtm_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, wtm_string, vec2_t(screensize.x-wtm_size.x-10, 21), color_t(255,255,255,255))
end

local function keybinds()
    if not keybind_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.keybind.show or menu.is_open() then
        variables.keybind.alpha = variables.keybind.alpha > 254 and 255 or variables.keybind.alpha + 10
    else
        variables.keybind.alpha = variables.keybind.alpha < 1 and 0 or variables.keybind.alpha - 10
    end
    render.push_alpha_modifier(variables.keybind.alpha/255)
    render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+9), vec2_t(variables.keybind.size, 1), keybind_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(variables.keybind.x:get(), variables.keybind.y:get()+10), vec2_t(variables.keybind.size, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(variables.keybind.x:get()+variables.keybind.size-2, variables.keybind.y:get()+9), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(variables.keybind.x:get()+variables.keybind.size-3, variables.keybind.y:get()+14), 6, keybind_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(variables.keybind.x:get()-10, variables.keybind.y:get()+9), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(variables.keybind.x:get()+2, variables.keybind.y:get()+14), 6, keybind_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, "keybinds", vec2_t(variables.keybind.x:get()+variables.keybind.size/2, variables.keybind.y:get()+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.keybind.x:get()-20,variables.keybind.y:get()-20),vec2_t(variables.keybind.x:get()+160,variables.keybind.y:get()+48)) then
        if not hasoffset then
            variables.keybind.offsetx = variables.keybind.x:get()-mousepos.x
            variables.keybind.offsety = variables.keybind.y:get()-mousepos.y
            hasoffset = true
        end
        variables.keybind.x:set(mousepos.x + variables.keybind.offsetx)
        variables.keybind.y:set(mousepos.y + variables.keybind.offsety)
    else
        hasoffset = false
    end
    
    offset = 1

    for i, v in pairs(keybindings) do
        local dap = v[2]
        if dap:get() then
            render.text(font, i, vec2_t(variables.keybind.x:get()+2, variables.keybind.y:get()+18+(12*offset)), color_t(255,255,255,255))
            local itssize = render.get_text_size(font, variables.keybind.modes[dap:get_mode()+1])
            render.text(font, variables.keybind.modes[dap:get_mode()+1], vec2_t(variables.keybind.x:get()+variables.keybind.size-2-itssize.x, variables.keybind.y:get()+18+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
    end

    variables.keybind.show = offset > 1
end

local function spectators()
    if not spectator_enable:get() or not entity_list.get_local_player() then return end
    local mousepos = input.get_mouse_pos()
    if variables.spectator.show or menu.is_open() then
        variables.spectator.alpha = variables.spectator.alpha > 254 and 255 or variables.spectator.alpha + 25
    else
        variables.spectator.alpha = variables.spectator.alpha < 1 and 0 or variables.spectator.alpha - 25
    end
    render.push_alpha_modifier(variables.spectator.alpha/255)
    render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+9), vec2_t(variables.spectator.size, 1), spectator_colour:get())
    if box_style:get() == 1 then
        render.rect_filled(vec2_t(variables.spectator.x:get(), variables.spectator.y:get()+10), vec2_t(variables.spectator.size, 16), color_t(13,13,13,110))
    else
        render.push_clip(vec2_t(variables.spectator.x:get()+variables.spectator.size-2, variables.spectator.y:get()+9), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x:get()+variables.spectator.size-3, variables.spectator.y:get()+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(variables.spectator.x:get()-10, variables.spectator.y:get()+9), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(variables.spectator.x:get()+2, variables.spectator.y:get()+14), 6, spectator_colour:get(), 1, 1)
        render.pop_clip()
    end
    render.text(font, "spectators", vec2_t(variables.spectator.x:get()+variables.spectator.size/2, variables.spectator.y:get()+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(variables.spectator.x:get()-20,variables.spectator.y:get()-20),vec2_t(variables.spectator.x:get()+160,variables.spectator.y:get()+48)) then
        if not hasoffsetspec then
            variables.spectator.offsetx = variables.spectator.x:get()-mousepos.x
            variables.spectator.offsety = variables.spectator.y:get()-mousepos.y
            hasoffsetspec = true
        end
        variables.spectator.x:set(mousepos.x + variables.spectator.offsetx)
        variables.spectator.y:set(mousepos.y + variables.spectator.offsety)
    else
        hasoffsetspec = false
    end
    offset = 1

    curspec = 1

    local local_player = entity_list.get_local_player_or_spectating()

    local players = entity_list.get_players()

    if not players then return end

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == local_player:get_index() then
            local size = render.get_text_size(font, playername)
            variables.spectator.size = size.x/2
            render.text(font, playername, vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+18+(12*offset)), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end

    if variables.spectator.size < 140 then variables.spectator.size = 140 end

    for i = 1, #variables.spectator.list do
        render.text(font, variables.spectator.list[i], vec2_t(variables.spectator.x:get()+2, variables.spectator.y:get()+18+(12*offset)), color_t(255,255,255,255))
        offset = offset + 1
    end

    variables.spectator.show = offset > 1
end

callbacks.add(e_callbacks.PAINT, function()
    watermark(); keybinds(); spectators()
end)

callbacks.add(e_callbacks.DRAW_WATERMARK, function() return"" end)