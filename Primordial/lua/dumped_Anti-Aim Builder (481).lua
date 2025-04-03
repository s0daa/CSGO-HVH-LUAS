local aa_conds = {
    "Shared",
    "Standing",
    "Walking",
    "Slow walk",
    "Ducking",
    "Air",
    "Crouching air",
}
local short_conds = {
    "",
    "[S] ",
    "[W] ",
    "[SW] ",
    "[C] ",
    "[A] ",
    "[C-A] ",
}
local entity = {}
local antiaims = {}

---@param group string
---@param name string
---@param def_key number|nil
menu.add_keybind = function(group, name, def_key)
    local text = menu.add_text(group, name)
    local def_key = def_key or 0

    return {text, text:add_keybind(name, def_key)}
end

local conditions = menu.add_selection("Anti-aim", "Conditions", aa_conds)
local inverter = menu.add_keybind("Anti-aim", "Invert desync")

for i = 1, #aa_conds do
    antiaims[i] = {
        enable_condition = menu.add_checkbox("Settings", "Enable " .. aa_conds[i] .. " condition", false),
        pitch_mode = menu.add_selection("Settings", short_conds[i].."Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
        yaw_base = menu.add_selection("Settings", short_conds[i].."Yaw base", {"None", "Viewangle", "At targets (crosshair)", "At targets (distance)"}),
        yaw_add_left = menu.add_slider("Settings", short_conds[i].."Yaw add left", -180, 180),
        yaw_add_right = menu.add_slider("Settings", short_conds[i].."Yaw add right", -180, 180),
        yaw_modifier = menu.add_selection("Settings", short_conds[i].."Yaw modifier", {"Disable", "Center", "Offset"}),
        mod_degree = menu.add_slider("Settings", short_conds[i].."Modifier degree", -180, 180),
        fake_limit_left = menu.add_slider("Settings", short_conds[i].."Fake limit left", 0, 60),
        fake_limit_right = menu.add_slider("Settings", short_conds[i].."Fake limit right", 0, 60),
        fake_options = menu.add_multi_selection("Settings", short_conds[i].."Fake options", {"Jitter"}),
        on_shot_aa = menu.add_selection("Settings", short_conds[i].."On-shot type", {"None", "Opposite", "Same side", "Random"}),
    }
end

callbacks.add(e_callbacks.PAINT, function ()
    for i = 1, #aa_conds do
        local cond = conditions:get() == i
        local enabled = antiaims[i].enable_condition:get()
        local yaw_modifier = antiaims[i].yaw_modifier:get()

        antiaims[i].pitch_mode:set_visible(cond and enabled)
        antiaims[i].yaw_base:set_visible(cond and enabled)
        antiaims[i].yaw_add_left:set_visible(cond and enabled)
        antiaims[i].yaw_add_right:set_visible(cond and enabled)
        antiaims[i].yaw_modifier:set_visible(cond and enabled)
        antiaims[i].mod_degree:set_visible(cond and enabled and yaw_modifier ~= 1)
        antiaims[i].fake_limit_left:set_visible(cond and enabled)
        antiaims[i].fake_limit_right:set_visible(cond and enabled)
        antiaims[i].fake_options:set_visible(cond and enabled)
        antiaims[i].on_shot_aa:set_visible(cond and enabled)
    end

    for i = 2, #aa_conds do
        antiaims[1].enable_condition:set(true)
        antiaims[1].enable_condition:set_visible(false)
        antiaims[i].enable_condition:set_visible(conditions:get() == i)
    end
end)

local ui_reference = {
    yaw_add = menu.find("antiaim", "main", "angles", "yaw add"),
    sides = menu.find("antiaim", "main", "desync", "side#stand"),
    move_override_stand = menu.find("antiaim", "main", "desync", "override stand#move"),
    slowwalk_override_stand = menu.find("antiaim", "main", "desync", "override stand#slow walk"),
    left_amount = menu.find("antiaim", "main", "desync", "left amount#stand"),
    right_amount = menu.find("antiaim", "main", "desync", "right amount#stand"),
    anti_bruteforce = menu.find("antiaim", "main", "desync", "anti bruteforce"),
    on_shot = menu.find("antiaim", "main", "desync", "on shot"),
    auto_direction = menu.find("antiaim", "main", "auto direction", "enable"),
    slowwalk = menu.find("misc", "main", "movement", "slow walk"),
}

local var = {invert = false, jitter = 1, state = 1}

entity.get_velocity = function(entity)
    local vel = {x = entity:get_prop("m_vecVelocity[0]"), y = entity:get_prop("m_vecVelocity[1]"), z = entity:get_prop("m_vecVelocity[2]")}
    local speed = math.floor(math.min(10000, math.sqrt(vel.x ^ 2 + vel.y ^ 2 + vel.z ^ 2) + 0.5))

    return speed == 0 and speed + 1 or speed
end

entity.get_localplayer_state = function()
    local localplayer = entity_list.get_local_player()

    if localplayer ~= nil then
        local flags = localplayer:get_prop("m_fFlags")

        if localplayer:has_player_flag(e_player_flags.ON_GROUND) and entity.get_velocity(localplayer) < 2 and flags ~= 256 and flags ~= 263 then -- standing
            var.state = antiaims[2].enable_condition:get() and 2 or 1
        end
        if localplayer:has_player_flag(e_player_flags.ON_GROUND) and entity.get_velocity(localplayer) > 2 and flags ~= 256 and flags ~= 263 then -- moving
            var.state = antiaims[3].enable_condition:get() and 3 or 1
        end
        if ui_reference.slowwalk[2]:get() and entity.get_velocity(localplayer) > 2 then -- slow walk
            var.state = antiaims[4].enable_condition:get() and 4 or 1
        end
        if localplayer:has_player_flag(e_player_flags.DUCKING) and localplayer:has_player_flag(e_player_flags.ON_GROUND) then -- crouch
            var.state = antiaims[5].enable_condition:get() and 5 or 1
        end
        if antiaim.is_fakeducking() and localplayer:has_player_flag(e_player_flags.ON_GROUND) then
            var.state = antiaims[5].enable_condition:get() and 5 or 1
        end
        if not localplayer:has_player_flag(e_player_flags.ON_GROUND) then -- air
            var.state = antiaims[6].enable_condition:get() and 6 or 1
        end
        if not localplayer:has_player_flag(e_player_flags.ON_GROUND) and localplayer:has_player_flag(e_player_flags.DUCKING) then -- air
            var.state = antiaims[7].enable_condition:get() and 7 or 1
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
    local local_eyepos = local_player:get_eye_position()
    local local_origin = local_player:get_render_origin()
    local bestenemy = nil
    local dis = math.huge
    for _, enemy in pairs(enemies_only) do
        if enemy:is_alive() and enemy ~= nil and not enemy:is_dormant() then
            local enemy_origin = enemy:get_render_origin()
            local cur_distance = calc_distance(enemy_origin, local_origin)
            if cur_distance < dis then
                dis = cur_distance
                bestenemy = enemy
            end
        end
    end

    if bestenemy == nil then
        return engine.get_view_angles()
    end

    return calc_angle(local_eyepos, bestenemy:get_render_origin())
end

local function get_crosshair_closet_enemy()
    local enemies_only = entity_list.get_players(true)
    if enemies_only == nil then return end
    local local_player = entity_list.get_local_player()
    local local_eyepos = local_player:get_eye_position()
    local local_angles = engine.get_view_angles()
    local bestenemy = nil
    local fov = math.huge
    for _, enemy in pairs(enemies_only) do
        if enemy:is_alive() and enemy ~= nil and not enemy:is_dormant() then
            local enemy_origin = enemy:get_render_origin()
            local cur_fov = math.abs(normalize_yaw(calc_shit(local_eyepos.x - enemy_origin.x, local_eyepos.y - enemy_origin.y) - local_angles.y + 180))
            if cur_fov < fov then
                fov = cur_fov
                bestenemy = enemy
            end
        end
    end

    if bestenemy == nil then
        return engine.get_view_angles()
    end

    return calc_angle(local_eyepos, bestenemy:get_render_origin())
end

callbacks.add(e_callbacks.ANTIAIM, function (ctx, cmd)
    entity.get_localplayer_state()
    local i = var.state

    -- @ note - anti-aim reference

    local aa_reference = {
        pitch = antiaims[i].pitch_mode,
        yaw_base = antiaims[i].yaw_base,
        left_yaw_add = antiaims[i].yaw_add_left,
        right_yaw_add = antiaims[i].yaw_add_right,
        yaw_modifier = antiaims[i].yaw_modifier,
        modifier_degree = antiaims[i].mod_degree,
        fake_limit_left = antiaims[i].fake_limit_left,
        fake_limit_right = antiaims[i].fake_limit_left,
        fake_options = antiaims[i].fake_options,
        on_shot = antiaims[i].on_shot_aa
    }

    local manual_override = antiaim.get_manual_override()
    local manual_add = (manual_override == 0 and 180 or manual_override == 1 and -90 or manual_override == 3 and 90 or 180)
    local pitch = aa_reference.pitch:get() == 2 and 89 or aa_reference.pitch:get() == 3 and -89 or aa_reference.pitch:get() == 4 and 0 or aa_reference.pitch:get() == 5 and (var.jitter == -1 and 89 or -89) or cmd.viewangles.x

    local yaw_base = aa_reference.yaw_base:get() == 2 and cmd.viewangles.y or aa_reference.yaw_base:get() == 3 and get_crosshair_closet_enemy().y or aa_reference.yaw_base:get() == 4 and get_distance_closest_enemy().y or cmd.viewangles.y
    local yaw = aa_reference.yaw_base:get() ~= 1 and (manual_override == 0 and yaw_base or cmd.viewangles.y) - manual_add or cmd.viewangles.y

    -- @ note - Jitter system
    if aa_reference.yaw_modifier:get() == 2 then
        yaw = yaw + (aa_reference.modifier_degree:get() / 2) * var.jitter
    elseif aa_reference.yaw_modifier:get() == 3 then
        yaw = yaw + (var.jitter == -1 and 0 or aa_reference.modifier_degree:get())
    end

    -- @ note - left / right yaw add
    yaw = yaw + (var.invert and aa_reference.right_yaw_add:get() or aa_reference.left_yaw_add:get())

    -- @ note - Set antiaim settings

    ctx:set_pitch(pitch)
    if not ui_reference.auto_direction[2]:get() then
        ctx:set_yaw(yaw)
    end
    ctx:set_body_lean(0)

    ui_reference.sides:set(2)
    ui_reference.left_amount:set(100 * (aa_reference.fake_limit_left:get() / 60))
    ui_reference.right_amount:set(100 * (aa_reference.fake_limit_right:get() / 60))
    ui_reference.anti_bruteforce:set(false)
    ui_reference.move_override_stand:set(false)
    ui_reference.slowwalk_override_stand:set(false)
    ui_reference.on_shot:set(aa_reference.on_shot:get())

    if aa_reference.fake_options:get(1) then
        ctx:set_invert_desync(var.jitter == 1)
        var.invert = var.jitter == 1
    else
        var.invert = inverter[2]:get()
        ctx:set_invert_desync(inverter[2]:get())
    end
end)

callbacks.add(e_callbacks.SETUP_COMMAND, function (cmd)
    if engine.get_choked_commands() == 0 then
        var.jitter = var.jitter * -1
    end
end)