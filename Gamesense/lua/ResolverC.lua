local ffi = require("ffi")
local bit = require("bit")
local vector = require("vector")

local MAX_COMPENSATION = 58.0
local PING_FACTOR = 0.38
local BASE_HISTORY = 14
local VELOCITY_THRESHOLD = 110.0
local EDGE_TOLERANCE = 14.0
local ROUND_HISTORY_CAP = 3
local LEARNING_RATE = 0.1

local resolver_toggle = ui.new_checkbox("RAGE", "Other", "Resolver that CAN hit vs Resolver that CANT hit")
local ping_indicator = ui.new_label("RAGE", "Other", "Latency: 0ms")
local status_label = ui.new_label("RAGE", "Other", "Status: Inactive")

local function clamp(val, min_val, max_val)
    return math.min(math.max(val, min_val), max_val)
end

local function NormalizeAngle(angle)
    if not angle then return 0 end
    angle = angle % 360
    if angle > 180 then
        return angle - 360
    elseif angle < -180 then
        return angle + 360
    end
    return angle
end

local function weightedAverage(buffer, current_time, key)
    if not buffer or #buffer == 0 then return 0 end
    local sum, total = 0, 0
    for i = 1, #buffer do
        if buffer[i].timestamp then
            local dt = current_time - buffer[i].timestamp
            local weight = math.exp(-dt * 2)
            sum = sum + (buffer[i][key] or 0) * weight
            total = total + weight
        end
    end
    return total == 0 and (buffer[1][key] or 0) or (sum / total)
end

local function stdDev(samples)
    if not samples or #samples == 0 then return 0 end
    local s = 0
    for i = 1, #samples do s = s + samples[i] end
    local mean = s / #samples
    local var = 0
    for i = 1, #samples do var = var + (samples[i] - mean)^2 end
    return math.sqrt(var / #samples)
end

local function kalmanFilter(current_angle, previous_angle, process_noise, measurement_noise)
    local estimated_angle = current_angle
    local error_estimate = process_noise

    local kalman_gain = error_estimate / (error_estimate + measurement_noise)
    estimated_angle = estimated_angle + kalman_gain * (previous_angle - estimated_angle)
    error_estimate = (1 - kalman_gain) * error_estimate

    return estimated_angle
end

local function multiResolutionAnalysis(buffer)
    local shortTerm = {}
    local longTerm = {}

    for i = 1, math.min(#buffer, 5) do
        table.insert(shortTerm, buffer[i].eye)
    end

    for i = 1, #buffer do
        table.insert(longTerm, buffer[i].eye)
    end

    local shortTermStdDev = stdDev(shortTerm)
    local longTermStdDev = stdDev(longTerm)

    if shortTermStdDev < 15 then
        return "jitter"
    elseif longTermStdDev < 15 then
        return "defensive"
    else
        return "random"
    end
end

local function predictFutureAngle(buffer)
    if not buffer or #buffer < 2 then return buffer[1] and buffer[1].eye or 0 end
    local diff = NormalizeAngle(buffer[1].eye - buffer[2].eye)
    local predicted = NormalizeAngle(buffer[1].eye + diff)
    return kalmanFilter(predicted, buffer[1].eye, 0.1, 0.5) -- Adjust noise parameters as needed
end

local function predictDesync(profile)
    if not profile.buffer or #profile.buffer == 0 then return 0 end
    local latest = profile.buffer[1]
    return NormalizeAngle((latest.eye or 0) - (latest.body or 0))
end

local function predictBacktrack(profile)
    local n = #profile.buffer
    if not profile.buffer or n < 5 then return profile.buffer[n] and profile.buffer[n].eye or 0 end
    local sum, cnt = 0, 0
    for i = 5, n do
        sum = sum + (profile.buffer[i].eye or 0)
        cnt = cnt + 1
    end
    return cnt > 0 and (sum / cnt) or (profile.buffer[n] and profile.buffer[n].eye or 0)
end

local function afkCheck(profile)
    if not profile.buffer or #profile.buffer == 0 then return false end
    local total = 0
    for i = 1, #profile.buffer do
        total = total + (profile.buffer[i].velocity or 0)
    end
    return (total / #profile.buffer) < 0.5
end

local function dynamicLearningRate(profile)
    return LEARNING_RATE * (1 - profile.hit_confidence)
end

local function adjustWeights(profile)
    local jitterCount, defensiveCount = 0, 0
    for _, sample in ipairs(profile.buffer or {}) do
        if sample.aa_type == "jitter" then
            jitterCount = jitterCount + 1
        elseif sample.aa_type == "defensive" then
            defensiveCount = defensiveCount + 1
        end
    end
    if jitterCount > defensiveCount then
        return {future = 0.6, desync = 0.2, backtrack = 0.2}
    else
        return {future = 0.2, desync = 0.4, backtrack = 0.4}
    end
end

local Resolver = {}
Resolver.profiles = {}

Resolver.CreateProfile = function()
    return {
        buffer = {},
        latency_scale = 1.0,
        aa_type = "defensive",
        hit_confidence = 0.5,
        adaptive_offset = 0,
        round_history = {},
        round_count = 0
    }
end

Resolver.UpdateProfile = function(self, ent)
    if not entity.is_alive(ent) then return end
    self.profiles[ent] = self.profiles[ent] or Resolver.CreateProfile()
    local profile = self.profiles[ent]
    local latency = client.latency() * 1000 or 0
    profile.latency_scale = clamp((latency / 90) * PING_FACTOR, 0.8, 1.2)
    local history_limit = math.floor(BASE_HISTORY * profile.latency_scale)
    local eye = {entity.get_prop(ent, "m_angEyeAngles")} or {0, 0, 0}
    local eye_yaw = NormalizeAngle(eye[2])
    local lby = entity.get_prop(ent, "m_flLowerBodyYawTarget") or (((entity.get_prop(ent, "m_flPoseParameter", 11) or 0.5) * 120) - 60)
    local vel = vector(entity.get_prop(ent, "m_vecVelocity") or 0)
    local body_yaw = lby
    local t = globals.curtime() or 0
    table.insert(profile.buffer, 1, {eye = eye_yaw, body = body_yaw, velocity = vel:length2d(), timestamp = t})
    while #profile.buffer > history_limit do table.remove(profile.buffer) end

    profile.aa_type = multiResolutionAnalysis(profile.buffer)

    if profile.hit_confidence > 0.5 then profile.hit_confidence = profile.hit_confidence - 0.01 end
end

Resolver.CalculateCompensation = function(self, ent)
    local profile = self.profiles[ent]
    if not profile or #profile.buffer < 3 then return 0 end

    local weights = adjustWeights(profile)
    local future = predictFutureAngle(profile.buffer)
    local desync = predictDesync(profile)
    local backtrack = predictBacktrack(profile)
    local base = (future * weights.future + desync * weights.desync + backtrack * weights.backtrack) * profile.latency_scale
    local comp = NormalizeAngle(base + profile.adaptive_offset)

    return clamp(comp, -MAX_COMPENSATION, MAX_COMPENSATION)
end

local function getEnemies()
    local enms = {}
    local players = entity.get_players(true)
    if players then
        for _, ent in ipairs(players) do
            if entity.is_enemy(ent) then
                table.insert(enms, ent)
            end
        end
    end
    return enms
end

local shotRecords = {}
local errorLog = {}

client.set_event_callback("weapon_fire", function(e)
    local shooter = e.userid and client.userid_to_entindex(e.userid) or nil
    if shooter ~= entity.get_local_player() then return end
    local target = client.get_crosshair_target and client.get_crosshair_target() or nil
    if target and entity.is_enemy(target) and entity.is_alive(target) then
        shotRecords[target] = {time = globals.curtime() or 0, resolved = false}
    end
end)

client.set_event_callback("player_hurt", function(e)
    if e.hitgroup ~= 1 then return end
    if e.attacker ~= entity.get_local_player() then return end
    local ent = client.userid_to_entindex(e.userid)
    if not ent then return end
    local profile = Resolver.profiles[ent]
    if profile then
        profile.hit_confidence = math.min(profile.hit_confidence + 0.15, 1.0)
        profile.adaptive_offset = 0
    end
    if shotRecords[ent] then
        shotRecords[ent].resolved = true
    end
end)

client.set_event_callback("net_update_end", function()
    ui.set(ping_indicator, "Latency: " .. math.floor(client.latency() * 1000 or 0) .. "ms")

    for k, record in pairs(shotRecords or {}) do
        if (globals.curtime() or 0) - record.time > 0.5 and not record.resolved then
            local profile = Resolver.profiles[k]
            if profile and #profile.buffer >= 3 then
                local predicted = predictFutureAngle(profile.buffer)
                local desync = predictDesync(profile)
                local backtrack = predictBacktrack(profile)
                local base = (predicted * 0.4 + desync * 0.3 + backtrack * 0.3) * profile.latency_scale
                local current_comp = NormalizeAngle(base + profile.adaptive_offset)
                local error = current_comp - predicted

                table.insert(errorLog, {
                    entindex = k,
                    predicted = predicted,
                    actual = current_comp,
                    error = error,
                    aa_type = profile.aa_type,
                    timestamp = globals.curtime()
                })

                profile.adaptive_offset = profile.adaptive_offset - dynamicLearningRate(profile) * error
            end
            client.log("Missed shot due to bad resolver (gradient update)")
            shotRecords[k] = nil
        elseif (globals.curtime() or 0) - record.time > 0.5 then
            shotRecords[k] = nil
        end
    end

    if not ui.get(resolver_toggle) then
        ui.set(status_label, "Status: Disabled")
        for _, ent in ipairs(getEnemies()) do
            plist.set(ent, "Force body yaw", false)
        end
        return
    end

    local enemies = getEnemies()
    ui.set(status_label, "Status: Active | Targets: " .. #enemies)
    for _, ent in ipairs(enemies) do
        if entity.is_alive(ent) then
            Resolver:UpdateProfile(ent)
            local profile = Resolver.profiles[ent]
            if profile and (profile.aa_type == "jitter" or profile.aa_type == "defensive") then
                local comp = Resolver:CalculateCompensation(ent)
                plist.set(ent, "Force body yaw value", comp)
                plist.set(ent, "Force body yaw", true)
            else
                plist.set(ent, "Force body yaw", false)
            end
        end
    end
end)

client.set_event_callback("round_end", function()
    if #errorLog > 0 then
        local totalError = 0
        local jitterCount, defensiveCount = 0, 0
        for _, log in ipairs(errorLog) do
            totalError = totalError + math.abs(log.error)
            if log.aa_type == "jitter" then
                jitterCount = jitterCount + 1
            elseif log.aa_type == "defensive" then
                defensiveCount = defensiveCount + 1
            end
        end
        local avgError = totalError / #errorLog
        client.log("Average resolver error: " .. avgError)
        client.log("Jitter AA encounters: " .. jitterCount)
        client.log("Defensive AA encounters: " .. defensiveCount)

        if jitterCount > defensiveCount then
            client.log("Adjusting weights: Increasing future angle weight")
        else
            client.log("Adjusting weights: Increasing desync/backtrack weight")
        end

        errorLog = {}
    end

    for ent, profile in pairs(Resolver.profiles or {}) do
        profile.round_history = profile.round_history or {}
        table.insert(profile.round_history, profile.adaptive_offset)
        profile.round_count = (profile.round_count or 0) + 1
        if profile.round_count > ROUND_HISTORY_CAP then
            table.remove(profile.round_history, 1)
        end
        local sum = 0
        for i = 1, #profile.round_history do
            sum = sum + profile.round_history[i]
        end
        profile.adaptive_offset = sum / math.max(#profile.round_history, 1)
        profile.buffer = {}
    end

    shotRecords = {}
end)

client.set_event_callback("paint", function()
    for k, record in pairs(shotRecords or {}) do
        if (globals.curtime() or 0) - record.time > 0.5 and not record.resolved then
            local ent = k
            local origin = entity.get_origin(ent)
            if origin then
                local x, y = renderer.world_to_screen(origin.x, origin.y, origin.z)
                if x and y then
                    renderer.text(x, y, 255, 0, 0, 255, "-", 0, "Missed Shot")
                    renderer.text(x, y + 15, 255, 0, 0, 255, "-", 0, "AA Type: " .. Resolver.profiles[ent].aa_type)
                    renderer.text(x, y + 30, 255, 0, 0, 255, "-", 0, "Error: " .. string.format("%.2f", record.error))
                end
            end
        end
    end
end)