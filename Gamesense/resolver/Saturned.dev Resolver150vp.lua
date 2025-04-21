local vector = require("vector")
local plist_get, plist_set = plist.get, plist.set
local get_players = entity.get_players
local is_enemy = entity.is_enemy
local ui_ref = ui.reference
local math_floor = math.floor
local math_abs = math.abs
local math_deg = math.deg
local math_rad = math.rad
local math_atan2 = math.atan2
local math_sqrt = math.sqrt

local config = {
    minSpeed = 10,
    moveAngleThreshold = 35,
    eyeYawDiffThreshold = 35,
    lbyDiffThreshold = 25,
    localToEnemyAngleThreshold = 35,
    poseParameterIndex = 11,
    leanAngleRange = 120,
    leanMinThreshold = 20,
    randomJitterRange = 5,
    baseStep = 30,
    minStep = 5,
    maxAngleAbs = 60,
    sideVoteWeights = {
        eyeToLocal = 1,
        eyeToLBY = 1,
        moveToEye = 1,
        moveToLBY = 1,
        localToLBY = 1,
        poseLean = 1
    }
}

local menu = {
    separator_top    = ui.new_label("Lua", "B", "\a373737FF__________________________"),
    enable           = ui.new_checkbox("Lua", "B", "\aFF4500FF[Enable Saturned.dev Resolver]"),
    channel          = ui.new_label("Lua", "B", "\tDeveloped by -> tg @SaturnedResolver"),
    separator_bottom = ui.new_label("Lua", "B", "\a373737FF‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾"),
    logs             = ui.new_checkbox("Lua", "B", "Logs"),
    debug            = ui.new_checkbox("Lua", "B", "Flag ESP"),
    bruteforce       = ui.new_checkbox("Lua", "B", "Adaptive Bruteforce"),
    debug_overlay    = ui.new_checkbox("Lua", "B", "Debug Overlay")
}

local successful_angles = {}
local enemy_data = {}

local function normalize_angle(angle)
    angle = angle % 360
    if angle > 180 then
        angle = angle - 360
    end
    return angle
end

local function angle_difference(a, b)
    return math_abs(normalize_angle(a - b))
end

local function distance2D(x1, y1, x2, y2)
    return math_sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

local function get_movement_angle(enemy)
    local vx, vy, vz = entity.get_prop(enemy, "m_vecVelocity")
    if vx == nil or vy == nil then 
        return nil 
    end
    local speed = math_sqrt(vx * vx + vy * vy)
    if speed > config.minSpeed then
        local move_angle = math_deg(math_atan2(vy, vx))
        return normalize_angle(move_angle)
    end
    return nil
end

local function detect_side(enemy)
    local local_player = entity.get_local_player()
    if not local_player or not enemy then 
        return 0 
    end
    local side_votes = 0
    local ex, ey, ez = entity.get_prop(enemy, "m_vecOrigin")
    local lx, ly, lz = entity.get_prop(local_player, "m_vecOrigin")
    local lby = entity.get_prop(enemy, "m_flLowerBodyYawTarget")
    local enemy_eye_x, enemy_eye_y, enemy_eye_z = entity.get_prop(enemy, "m_angEyeAngles")
    if ex == nil or ey == nil or lx == nil or ly == nil or lby == nil or enemy_eye_y == nil then
        return 0
    end
    local eye_yaw = enemy_eye_y
    local move_angle = get_movement_angle(enemy)
    do
        local dx = ex - lx
        local dy = ey - ly
        local angle_to_local = math_deg(math_atan2(dy, dx))
        local diff = normalize_angle(eye_yaw - angle_to_local)
        if math_abs(diff) > config.eyeYawDiffThreshold then
            side_votes = side_votes + (diff > 0 and config.sideVoteWeights.eyeToLocal or -config.sideVoteWeights.eyeToLocal)
        end
    end
    do
        local delta = normalize_angle(eye_yaw - lby)
        if math_abs(delta) > config.lbyDiffThreshold then
            side_votes = side_votes + (delta > 0 and config.sideVoteWeights.eyeToLBY or -config.sideVoteWeights.eyeToLBY)
        end
    end
    if move_angle then
        local diff = normalize_angle(move_angle - eye_yaw)
        if math_abs(diff) > config.moveAngleThreshold then
            side_votes = side_votes + (diff > 0 and config.sideVoteWeights.moveToEye or -config.sideVoteWeights.moveToEye)
        end
    end
    if move_angle then
        local diff = normalize_angle(move_angle - lby)
        if math_abs(diff) > config.lbyDiffThreshold then
            side_votes = side_votes + (diff > 0 and config.sideVoteWeights.moveToLBY or -config.sideVoteWeights.moveToLBY)
        end
    end
    do
        local dx = ex - lx
        local dy = ey - ly
        local angle_to_local = math_deg(math_atan2(dy, dx))
        local delta = normalize_angle(angle_to_local - lby)
        if math_abs(delta) > config.localToEnemyAngleThreshold then
            side_votes = side_votes + (delta > 0 and config.sideVoteWeights.localToLBY or -config.sideVoteWeights.localToLBY)
        end
    end
    local body_lean = entity.get_prop(enemy, "m_flPoseParameter", config.poseParameterIndex)
    if body_lean ~= nil then
        local lean_angle = body_lean * config.leanAngleRange - (config.leanAngleRange / 2)
        if math_abs(lean_angle) > config.leanMinThreshold then
            side_votes = side_votes + (lean_angle > 0 and config.sideVoteWeights.poseLean or -config.sideVoteWeights.poseLean)
        end
    end
    if side_votes > 0 then
        return 1
    elseif side_votes < 0 then
        return -1
    end
    return 0
end

local function improved_bruteforce(enemy)
    enemy_data[enemy] = enemy_data[enemy] or { angle = 0, step = config.baseStep, direction = 1, attempts = 0 }
    local data = enemy_data[enemy]
    data.attempts = data.attempts + 1
    if successful_angles[enemy] and #successful_angles[enemy] > 0 then
        local sum = 0
        for _, a in ipairs(successful_angles[enemy]) do
            sum = sum + a
        end
        local avg = sum / #successful_angles[enemy]
        local jitter = math.random(-config.randomJitterRange, config.randomJitterRange)
        data.angle = avg + jitter
        data.step = config.baseStep
        data.direction = (math.random() > 0.5) and 1 or -1
        return normalize_angle(data.angle)
    end
    local move_angle = get_movement_angle(enemy)
    if move_angle then
        data.angle = move_angle + math.random(-10, 10)
        return normalize_angle(data.angle)
    end
    if data.attempts == 1 then
        local _, enemy_yaw, _ = entity.get_prop(enemy, "m_angEyeAngles")
        if enemy_yaw then
            data.angle = enemy_yaw + math.random(-15, 15)
            return normalize_angle(data.angle)
        end
    end
    local random_adjustment = math.random(-2, 2)
    data.angle = data.angle + data.step * data.direction + random_adjustment
    if math_abs(data.angle) > config.maxAngleAbs then
        data.direction = -data.direction
        data.step = math.max(config.minStep, data.step - 5)
        data.angle = data.angle + data.step * data.direction
    end
    data.angle = normalize_angle(data.angle)
    return data.angle
end

local function log_message(prefix, message, color_table)
    if not ui.get(menu.logs) then return end
    client.color_log(200, 200, 200, "[\0")
    client.color_log(color_table.r, color_table.g, color_table.b, prefix .. "\0")
    client.color_log(200, 200, 200, "] " .. message .. "\n")
end

local hitgroup_names = { 
    "generic", "head", "chest", "stomach", 
    "left arm", "right arm", "left leg", "right leg", 
    "neck", "?", "gear" 
}

local function aim_miss(e)
    if ui.get(menu.enable) and ui.get(menu.logs) then
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local reason = e.reason == "?" and "resolver" or e.reason
        local target_name = entity.get_player_name(e.target) or "unknown"
        local message = string.format("Missed %s in the %s due to %s", target_name, group, reason)
        log_message("Saturned.dev", message, { r = 241, g = 64, b = 101 })
    end
end
client.set_event_callback("aim_miss", aim_miss)

local function aim_hit(e)
    if ui.get(menu.enable) and ui.get(menu.logs) then
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_name = entity.get_player_name(e.target) or "unknown"
        local angle = plist_get(e.target, "Force body yaw value") or 0
        local health_remaining = math.max(entity.get_prop(e.target, "m_iHealth") - e.damage, 0)
        local message = string.format("Registered damage to %s in the %s for %d damage (%d health remaining) using angle %s°", 
            target_name, group, e.damage, health_remaining, tostring(angle))
        log_message("Saturned.dev", message, { r = 102, g = 255, b = 0 })
        successful_angles[e.target] = successful_angles[e.target] or {}
        table.insert(successful_angles[e.target], angle)
        if #successful_angles[e.target] > 10 then
            table.remove(successful_angles[e.target], 1)
        end
    end
end
client.set_event_callback("aim_hit", aim_hit)

client.register_esp_flag("BRUTE", 255, 255, 255, function(ent)
    return ui.get(menu.debug) 
       and is_enemy(ent) 
       and plist_get(ent, "Force body yaw") 
       and ui.get(menu.bruteforce)
end)

local function draw_debug_overlay()
    if not ui.get(menu.debug_overlay) then return end
    local players = get_players(true)
    for _, player in ipairs(players) do
        if is_enemy(player) then
            local x, y, z = entity.get_prop(player, "m_vecOrigin")
            if x and y then
                local angle = plist_get(player, "Force body yaw value") or 0
                client.draw_text(x, y, 255, 255, 255, 255, 0, "small", string.format("%.1f°", angle))
            end
        end
    end
end
client.set_event_callback("paint", draw_debug_overlay)

local function update_menu()
    local enabled = ui.get(menu.enable)
    ui.set_visible(menu.channel, enabled)
    ui.set_visible(menu.logs, enabled)
    ui.set_visible(menu.debug, enabled)
    ui.set_visible(menu.bruteforce, enabled)
    ui.set_visible(menu.debug_overlay, enabled)
end
client.set_event_callback("paint", update_menu)

local function resolver()
    if not ui.get(menu.enable) then return end
    local players = get_players(true)
    for _, player in ipairs(players) do
        local side = detect_side(player)
        local angle = ui.get(menu.bruteforce) and improved_bruteforce(player) or 0
        if side ~= 0 then
            angle = angle + side * 5
        end
        plist_set(player, "Force body yaw", true)
        plist_set(player, "Force body yaw value", normalize_angle(angle))
    end
end
client.set_event_callback("run_command", resolver)

local function on_player_spawn(e)
    local player = e.userid
    enemy_data[player] = nil
    successful_angles[player] = nil
end
client.set_event_callback("player_spawn", on_player_spawn)

local sentences = {
    "сосать хуйло ебаное",
    "Saturned трахнул тебя ебаное чмо",
    "АХАХА ОТЪЕБАН САТУРНЕДОМ АХАХА",
    "что что ма бой? отъебал тебя сатурнедом",
    "на колени бичара перед сатурном"
}

local function on_player_death(event)
    local local_player = entity.get_local_player()
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)
    if local_player == nil or attacker == nil or victim == nil then
        return
    end
    if attacker == local_player and victim ~= local_player then
        local killsay = "say " .. sentences[math.random(#sentences)]
        killsay = string.gsub(killsay, "$name", entity.get_player_name(victim))
        client.log(killsay)
        client.exec(killsay)
    end
end

math.randomseed(133742069)
math.random(); math.random(); math.random()

client.set_event_callback("player_death", on_player_death)
