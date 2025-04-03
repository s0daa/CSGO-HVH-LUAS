local version = "debug"
local username = user.name

local aboutScript = menu.add_text("Thunderline [ " .. version .. " ]", "Welcome back, " .. username)

local enableTeleportInAir = menu.add_checkbox("Aimbot", "Teleport in air")

local enableDebugLogs = menu.add_checkbox("Visuals", "Debug ragebot logs")
local debugLogsStyle = menu.add_selection("Visuals", "Debug ragebot logs style", {"Standard arrangement", "At crosshair"})
local debugLogsColor = enableDebugLogs:add_color_picker("Debug ragebot logs color")

local enableCrosshairIndicators = menu.add_checkbox("Visuals", "Crosshair indicators")
local crosshairIndicatorsColor = enableCrosshairIndicators:add_color_picker("Crosshair indicators color")

local indicatorsArray = menu.add_multi_selection("Visuals", "Choose the necessary indicators", {"Keybinds", "Spectator list", "Watermark"})
local indicatorsFirstColor = indicatorsArray:add_color_picker("Indicators first color")
local indicatorsSecondColor = indicatorsArray:add_color_picker("Indicators second color")

local enableAA = menu.add_checkbox("Anti-aims", "Enable conditions Anti-aims")
local conditionsState = menu.add_selection("Anti-aims", "Condition", {
"Standing",
"Motion detected",
"Slow walk",
"Crouching",
"In air"
})

stateStand = true
stateMove = false
stateSlow = false
stateCrouching = false
stateAir = false

local desyncStand = menu.add_slider("Anti-aims", "[Standing] Desync value", 1, 60)
local jitter_offsetStand = menu.add_slider("Anti-aims", "[Standing] Jitter offset", 0, 90)
local l_yaw_addStand = menu.add_slider("Anti-aims", "[Standing] Left yaw add", -50, 50)
local r_yaw_addStand = menu.add_slider("Anti-aims", "[Standing] Right yaw add", -50, 50)

local desyncMove = menu.add_slider("Anti-aims", "[Motion detected] Desync value", 1, 60)
local jitter_offsetMove = menu.add_slider("Anti-aims", "[Motion detected] Jitter offset", 0, 90)
local l_yaw_addMove = menu.add_slider("Anti-aims", "[Motion detected] Left yaw add", -50, 50)
local r_yaw_addMove = menu.add_slider("Anti-aims", "[Motion detected] Right yaw add", -50, 50)

local desyncSlow = menu.add_slider("Anti-aims", "[Slow walk] Desync value", 1, 60)
local jitter_offsetSlow = menu.add_slider("Anti-aims", "[Slow walk] Jitter offset", 0, 90)
local l_yaw_addSlow = menu.add_slider("Anti-aims", "[Slow walk] Left yaw add", -50, 50)
local r_yaw_addSlow = menu.add_slider("Anti-aims", "[Slow walk] Right yaw add", -50, 50)

local desyncCrouching = menu.add_slider("Anti-aims", "[Crouching] Desync value", 1, 60)
local jitter_offsetCrouching = menu.add_slider("Anti-aims", "[Crouching] Jitter offset", 0, 90)
local l_yaw_addCrouching = menu.add_slider("Anti-aims", "[Crouching] Left yaw add", -50, 50)
local r_yaw_addCrouching = menu.add_slider("Anti-aims", "[Crouching] Right yaw add", -50, 50)

local desyncAir = menu.add_slider("Anti-aims", "[Air] Desync value", 1, 60)
local jitter_offsetAir = menu.add_slider("Anti-aims", "[Air] Jitter offset", 0, 90)
local l_yaw_addAir = menu.add_slider("Anti-aims", "[Air] Left yaw add", -50, 50)
local r_yaw_addAir = menu.add_slider("Anti-aims", "[Air] Right yaw add", -50, 50)

local yaw_base = menu.add_selection("Anti-aims", "Yaw base", {"Viewangle", "At target(crosshair)", "At target(distance)"})
local disabler = menu.add_multi_selection("Anti-aims","Disable in",{"On peek","On manual sideways","On manual backward","On hideshots"})

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

local bindsState = {
["DMG"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
["DMG"] = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
["DMG"] = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
["DMG"] = menu.find("aimbot", "revolver", "target overrides", "force min. damage"),
["DMG"] = menu.find("aimbot", "deagle", "target overrides", "force min. damage"),
["DMG"] = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
["ROLL"] = menu.find("aimbot","general","aimbot","body lean resolver"),
["DT"] = menu.find("aimbot","general","exploits","doubletap","enable"),
["HS"] = menu.find("aimbot","general","exploits","hideshots","enable"),
}

local allBindsState = {
    ["Force damage"] = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
    ["Force damage"] = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
    ["Force damage"] = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
    ["Force damage"] = menu.find("aimbot", "revolver", "target overrides", "force min. damage"),
    ["Force damage"] = menu.find("aimbot", "deagle", "target overrides", "force min. damage"),
    ["Force damage"] = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
    ["Slow walk"] = menu.find("misc", "main", "movement", "slow walk"),
    ["Roll resolver"] = menu.find("aimbot","general","aimbot","body lean resolver"),
    ["Double tap"] = menu.find("aimbot","general","exploits","doubletap","enable"),
    ["Hide shots"] = menu.find("aimbot","general","exploits","hideshots","enable"),
    ["Auto peek"] = menu.find("aimbot","general","misc","autopeek"),
    ["Fake duck"] = menu.find("antiaim","main","general","fake duck"),
    ["Inverter desync"] = menu.find("antiaim","main","manual","invert desync"),
    ["Auto direction"] = menu.find("antiaim","main","auto direction","enable"),
}

local positionState = 2

local positionState2String = {
    "standing",
    "motion detected",
    "slow walk",
    "crouching",
    "in air"
}

local visuals = {
    keybind = {
        x = 10,
        y = 610,
        offsetx = 0,
        offsety = 0,
        modes = {
            "toggled", "hold", "hold off", "always", "off"
        },
        alpha = 0,
        size = 190,
    },
}

local font = render.create_font("verdana", 12, 50, e_font_flags.DROPSHADOW)
local fontCrosshairIndic = render.create_font("smallest_pixel-7.ttf", 10, 500, e_font_flags.DROPSHADOW)

local logs = {}
local logsTime = {}
local logsAlpha = {}
local logsMove = {}

local hitboxList = {
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

function visible()

    desyncStand:set_visible(stateStand)
    jitter_offsetStand:set_visible(stateStand)
    l_yaw_addStand:set_visible(stateStand)
    r_yaw_addStand:set_visible(stateStand)

    desyncMove:set_visible(stateMove)
    jitter_offsetMove:set_visible(stateMove)
    l_yaw_addMove:set_visible(stateMove)
    r_yaw_addMove:set_visible(stateMove)

    desyncSlow:set_visible(stateSlow)
    jitter_offsetSlow:set_visible(stateSlow)
    l_yaw_addSlow:set_visible(stateSlow)
    r_yaw_addSlow:set_visible(stateSlow)

    desyncCrouching:set_visible(stateCrouching)
    jitter_offsetCrouching:set_visible(stateCrouching)
    l_yaw_addCrouching:set_visible(stateCrouching)
    r_yaw_addCrouching:set_visible(stateCrouching)

    desyncAir:set_visible(stateAir)
    jitter_offsetAir:set_visible(stateAir)
    l_yaw_addAir:set_visible(stateAir)
    r_yaw_addAir:set_visible(stateAir)

    if conditionsState:get() == 1 then
        stateStand = true
        stateMove = false
        stateSlow = false
        stateCrouching = false
        stateAir = false
    end

    if conditionsState:get() == 2 then
        stateStand = false
        stateMove = true
        stateSlow = false
        stateCrouching = false
        stateAir = false
    end

    if conditionsState:get() == 3 then
        stateStand = false
        stateMove = false
        stateSlow = true
        stateCrouching = false
        stateAir = false
    end

    if conditionsState:get() == 4 then
        stateStand = false
        stateMove = false
        stateSlow = false
        stateCrouching = true
        stateAir = false
    end

    if conditionsState:get() == 5 then
        stateStand = false
        stateMove = false
        stateSlow = false
        stateCrouching = false
        stateAir = true
    end
end

function positionInTheWorld()
    local localPlayer = entity_list:get_local_player()

    if localPlayer ~= nil and localPlayer:is_alive() then
        if localPlayer:get_prop("m_fFlags") == 256 or localPlayer:get_prop("m_fFlags") == 262 then
            positionState = 5
        else
            if localPlayer:get_prop("m_fFlags") == 263 then
                positionState = 4
            else
                if menu.find("misc", "main", "movement", "slow walk")[2]:get() then
                    positionState = 3
                else
                    if math.pow(localPlayer:get_prop("m_vecVelocity")[0], 2) + math.pow( localPlayer:get_prop("m_vecVelocity")[1], 2 ) > 15 then
                        positionState = 2
                    else
                        positionState = 1
                    end
                end
            end
        end
    end 
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

if enableAA:get() then
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
end

function on_antiaim(ctx)
if enableAA:get() then
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

    if positionState == 1 then

    vars._jitter = jitter_offsetStand:get()
    vars._limit = desyncStand:get()
    
    _l_yaw_add = l_yaw_addStand:get()
    _r_yaw_add = r_yaw_addStand:get()

    end

    if positionState == 2 then

        vars._jitter = jitter_offsetMove:get()
        vars._limit = desyncMove:get()
        
        _l_yaw_add = l_yaw_addMove:get()
        _r_yaw_add = r_yaw_addMove:get()
    
    end

    if positionState == 3 then

        vars._jitter = jitter_offsetSlow:get()
        vars._limit = desyncSlow:get()
        
        _l_yaw_add = l_yaw_addSlow:get()
        _r_yaw_add = r_yaw_addSlow:get()
    
    end

    if positionState == 4 then

        vars._jitter = jitter_offsetCrouching:get()
        vars._limit = desyncCrouching:get()
        
        _l_yaw_add = l_yaw_addCrouching:get()
        _r_yaw_add = r_yaw_addCrouching:get()
    
    end

    if positionState == 5 then

        vars._jitter = jitter_offsetAir:get()
        vars._limit = desyncAir:get()
        
        _l_yaw_add = l_yaw_addAir:get()
        _r_yaw_add = r_yaw_addAir:get()
    
        end

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
end

--logs

function renderLogs()
if enableDebugLogs:get() and engine.is_connected() then
    if debugLogsStyle:get() == 1 then
        if #logs > 12 then
            table.remove(logs)
            table.remove(logsTime)
            table.remove(logsMove)
        end
    else
        if #logs > 6 then
            table.remove(logs)
            table.remove(logsTime)
            table.remove(logsMove)
        end
    end

    for i = 1, #logs do
        if logsAlpha[1] ~= nil and logs[1] ~= nil and logsMove[1] ~= nil then
            if debugLogsStyle:get() == 1 then
                render.text(font, logs[i], vec2_t(logsMove[i] + 5, -10 + 15 * i), color_t(debugLogsColor:get()[0], debugLogsColor:get()[1], debugLogsColor:get()[2], math.floor( logsAlpha[i])))
            else
                render.text(font, logs[i], vec2_t(logsMove[i] + render.get_screen_size()[0] / 2, render.get_screen_size()[1] / 1.3 + 15 * i), color_t(debugLogsColor:get()[0], debugLogsColor:get()[1], debugLogsColor:get()[2], math.floor( logsAlpha[i])), true)
            end
        end

        if logsTime[1] ~= nil and logsTime[i] + 6 < global_vars.cur_time() then

            logsAlpha[i] = logsAlpha[i] - global_vars.frame_time() * 600
            logsMove[i] = logsMove[i] - global_vars.frame_time() * 120

            if logsAlpha[i] <= 0 then
                table.remove(logs, i)
                table.remove(logsTime, i)
                table.remove(logsMove, i)
            end
        end
    end
else
    for k in pairs (logs) do
        logs [k] = nil
    end
    for k in pairs (logsTime) do
        logsTime [k] = nil
    end
    for k in pairs (logsMove) do
        logsMove [k] = nil
    end
end
end

function getHitLogs(hit)
if enableDebugLogs:get() and engine.is_connected() then
    local remainingHealth = hit.player:get_prop("m_iHealth")
    table.insert(logs, 1, "Registered shot in the " .. hitboxList[hit.hitgroup] .. " of " .. hit.player:get_name() .. " with a " .. hit.damage .. " damage (" .. remainingHealth .. " remaining)")
    table.insert(logsTime, 1, global_vars.cur_time())
    table.insert(logsAlpha, 1, 255)
    table.insert(logsMove, 1, 5)
end
end

function getMissLogs(miss)
if enableDebugLogs:get() and engine.is_connected() then
    table.insert(logs, 1, "Missed shot due to " .. miss.reason_string)
    table.insert(logsTime, 1, global_vars.cur_time())
    table.insert(logsAlpha, 1, 255)
    table.insert(logsMove, 1, 5)
end
end

--crosshair indicators

function renderIndicators()
if enableCrosshairIndicators:get() and entity_list.get_local_player() ~= nil and entity_list.get_local_player():is_alive() then

    offset = 1

    render.text(fontCrosshairIndic, "THUNDERLINE", vec2_t(render.get_screen_size()[0] / 2, render.get_screen_size()[1] / 1.9), crosshairIndicatorsColor:get())

    for i, v in pairs(bindsState) do
        local active = v[2]

        local position = vec2_t(render.get_screen_size()[0] / 2, render.get_screen_size()[1] / 1.9 + 10 * offset)

        if active:get() then
            render.text(fontCrosshairIndic, i, position, crosshairIndicatorsColor:get())
            offset = offset + 1
        end
    end
end
end

--spectator list

function renderSpectatorList()
if indicatorsArray:get(2) and entity_list.get_local_player() ~= nil and entity_list.get_local_player():is_alive() and not menu.is_open() then
    offset = 1

    local localPlayer = entity_list.get_local_player_or_spectating()
    local players = entity_list.get_players()

    for i,v in pairs(players) do
        if not v then return end
        if v:is_alive() or v:is_dormant() then goto skip end
        local playername = v:get_name()
        if playername == "<blank>" then goto skip end
        local observing = entity_list.get_entity(v:get_prop("m_hObserverTarget"))
        if not observing then goto skip end
        if observing:get_index() == localPlayer:get_index() then
            render.text(font, playername, vec2_t(render.get_screen_size()[0] - render.get_text_size(font, playername)[0] - 5, 11 + 15 * offset), color_t(255,255,255,255))
            offset = offset + 1
        end
        ::skip::
    end
end
end

--key binds

function renderKeyBinds()
if indicatorsArray:get(1) then
    local mousepos = input.get_mouse_pos()

    if visuals.keybind.show or menu.is_open() then
        visuals.keybind.alpha = visuals.keybind.alpha > 254 and 255 or visuals.keybind.alpha + 51
    else
        visuals.keybind.alpha = visuals.keybind.alpha < 1 and 0 or visuals.keybind.alpha - 51
    end

    render.push_alpha_modifier(visuals.keybind.alpha/255)
    render.rect_fade(vec2_t(visuals.keybind.x, visuals.keybind.y+9), vec2_t(visuals.keybind.size, 1), indicatorsSecondColor:get(), indicatorsFirstColor:get(), true)
    render.push_clip(vec2_t(visuals.keybind.x+visuals.keybind.size-2, visuals.keybind.y+9), vec2_t(10, 7))
    render.progress_circle(vec2_t.new(visuals.keybind.x+visuals.keybind.size-3, visuals.keybind.y+14), 6, indicatorsFirstColor:get(), 1, 1)
    render.pop_clip()
    render.push_clip(vec2_t(visuals.keybind.x-10, visuals.keybind.y+9), vec2_t(12, 7))
    render.progress_circle(vec2_t.new(visuals.keybind.x+2, visuals.keybind.y+14), 6, indicatorsSecondColor:get(), 1, 1)
    render.pop_clip()
    render.text(font, "Keybinds", vec2_t(visuals.keybind.x+visuals.keybind.size/2, visuals.keybind.y+18), color_t(255,255,255,255), true)
    if input.is_key_held(e_keys.MOUSE_LEFT) and input.is_mouse_in_bounds(vec2_t(visuals.keybind.x-20,visuals.keybind.y-20),vec2_t(visuals.keybind.x+160,visuals.keybind.y+48)) and menu.is_open() then
        if not hasoffset then
            visuals.keybind.offsetx = visuals.keybind.x-mousepos.x
            visuals.keybind.offsety = visuals.keybind.y-mousepos.y
            hasoffset = true
        end
        visuals.keybind.x = mousepos.x + visuals.keybind.offsetx
        visuals.keybind.y = mousepos.y + visuals.keybind.offsety
    else
        hasoffset = false
    end
    
    offset = 1

    for i, v in pairs(allBindsState) do
        local dap = v[2]
        if dap:get() then
            render.text(font, i, vec2_t(visuals.keybind.x+2, visuals.keybind.y+18+(12*offset)), indicatorsSecondColor:get())
            local itssize = render.get_text_size(font, visuals.keybind.modes[dap:get_mode()+1])
            render.text(font, visuals.keybind.modes[dap:get_mode()+1], vec2_t(visuals.keybind.x+visuals.keybind.size - itssize.x, visuals.keybind.y+18+(12*offset)), indicatorsFirstColor:get())
            offset = offset + 1
        end
    end

    visuals.keybind.show = offset > 1
end
end

--watermark

function renderWatermark()
    if indicatorsArray:get(3) then
        local screen = render.get_screen_size()
        local h, m, s = client.get_local_time()

        local watermarkValue = string.format("Thunderline [ " .. version .. " ] | %s | %s ms | %02d:%02d:%02d", username, math.floor(engine.get_latency(e_latency_flows.INCOMING)), h, m, s)
        local watermarkValueSize = render.get_text_size(font, watermarkValue)
        render.rect_fade(vec2_t(screen.x - watermarkValueSize.x - 14, 3), vec2_t(watermarkValueSize.x + 8, 1), indicatorsSecondColor:get(), indicatorsFirstColor:get(), true)
        render.push_clip(vec2_t(screen.x - 9, 3), vec2_t(10, 7))
        render.progress_circle(vec2_t.new(screen.x - 9, 8), 6, indicatorsFirstColor:get(), 1, 1)
        render.pop_clip()
        render.push_clip(vec2_t(screen.x - watermarkValueSize.x - 22, 4), vec2_t(12, 7))
        render.progress_circle(vec2_t.new(screen.x - watermarkValueSize.x - 10, 8), 6, indicatorsSecondColor:get(), 1, 1)
        render.pop_clip()
        render.text(font, watermarkValue, vec2_t(screen.x - watermarkValueSize.x - 10, 6), color_t(255,255,255,255))
    end
end

--teleport in air

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

function teleport(cmd)
    local localPlayer = entity_list:get_local_player()
    if not enableTeleportInAir:get() then return end
    if ragebot.get_autopeek_pos() then return end
    local enemies = entity_list.get_players(true)
    for i,v in ipairs(enemies) do
        if are_them_visibles(v) and are_have_weapon(v) and positionState == 5 then
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end
    end
end

function renderList()
    on_paint()
    positionInTheWorld()
    renderLogs()
    renderIndicators()
    renderSpectatorList()
    renderWatermark()
    visible()
    renderKeyBinds()
end

callbacks.add(e_callbacks.PAINT, renderList)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
callbacks.add(e_callbacks.SETUP_COMMAND, teleport)
callbacks.add(e_callbacks.AIMBOT_HIT, getHitLogs)
callbacks.add(e_callbacks.AIMBOT_MISS, getMissLogs)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)