local resolver_enabled = ui.new_checkbox("Rage", "Other", "Enable AI Resolver")
local disable_aa_correction = ui.new_checkbox("Rage", "Other", "Disable Anti-Aim Correction")
local force_bodyaim_below_health = ui.new_slider("Rage", "Other", "Force Body-Aim Below Health", 0, 100, 88)

local player_data = {}

local function log_message(message)
    if ui.get(resolver_enabled) then
        client.log("[AI Resolver]: " .. message)
    end
end

local function calculate_yaw_delta(yaw1, yaw2)
    local delta = yaw1 - yaw2
    while delta > 180 do
        delta = delta - 360
    end
    while delta < -180 do
        delta = delta + 360
    end
    return delta
end

local function calculate_distance(vec1, vec2)
    return (vec1 - vec2):length()
end

local function get_resolver_adjustment(player_index)
    local results = player_data[player_index].shot_results
    if not results then
        return 0
    end

    local total_shots = results.hits + results.misses
    if total_shots == 0 then
        return 0
    end

    local hit_ratio = results.hits / total_shots
    if hit_ratio > 0.5 then
        return 20 -- Positive adjustment for higher hit ratio
    else
        return -20 -- Negative adjustment for lower hit ratio
    end
end

local function calculate_resolver_adjustment(player)
    local air_adj = 30
    local ground_adj = 10

    local adjustment = 0

    local player_velocity = entity.get_prop(player, "m_vecVelocity")
    if not player_velocity then
        log_message("Error: Unable to get player velocity.")
        return 0
    end
    player_velocity = vector(player_velocity)

    -- Resolver adjustment based on player movement
    if player_velocity:length2d() > 100 then
        adjustment = air_adj
    else
        adjustment = ground_adj
    end

    local local_player = entity.get_local_player()
    local local_position = entity.get_prop(local_player, "m_vecOrigin")
    if not local_position then
        log_message("Error: Unable to get local player position.")
        return 0
    end
    local_position = vector(local_position)

    local player_position = entity.get_prop(player, "m_vecOrigin")
    if not player_position then
        log_message("Error: Unable to get player position.")
        return 0
    end
    player_position = vector(player_position)

    local player_distance = calculate_distance(local_position, player_position)
    local is_visible = client.visible(player)

    -- Additional adjustments based on player position and visibility
    if player_distance < 500 and is_visible then
        adjustment = adjustment - 10
    elseif player_distance > 1000 and not is_visible then
        adjustment = adjustment + 20
    end

    -- Additional adjustments based on player state
    local duck_amount = entity.get_prop(player, "m_flDuckAmount")
    if duck_amount and duck_amount > 0.5 then
        adjustment = adjustment + 10
    end

    local flags = entity.get_prop(player, "m_fFlags")
    if flags and bit.band(flags, 1) == 0 then
        adjustment = adjustment + 15
    end

    -- Adjust based on health for body-aim forcing
    local health = entity.get_prop(player, "m_iHealth")
    local force_health = ui.get(force_bodyaim_below_health)
    if health and health < force_health then
        adjustment = adjustment - 15
    end

    return adjustment
end

local function predict_future_position(player, ticks)
    local simulation_time = entity.get_prop(player, "m_flSimulationTime")
    if not simulation_time then
        log_message("Error: Unable to get simulation time.")
        return vector(0, 0, 0)
    end

    local server_time = globals.curtime()
    local tick_interval = globals.tickinterval()

    local delta_time = server_time - simulation_time
    local tick_prediction = math.floor(delta_time / tick_interval) + ticks

    local current_position = entity.get_prop(player, "m_vecOrigin")
    if not current_position then
        log_message("Error: Unable to get player position.")
        return vector(0, 0, 0)
    end
    current_position = vector(current_position)

    local velocity = entity.get_prop(player, "m_vecVelocity")
    if not velocity then
        log_message("Error: Unable to get player velocity.")
        return current_position
    end
    velocity = vector(velocity)

    local prediction = current_position + (velocity * tick_prediction * tick_interval)

    return prediction
end

local function adjust_resolver(player)
    if not ui.get(resolver_enabled) then
        return
    end

    local player_index = client.userid_to_entindex(player)
    local eye_angles = entity.get_prop(player, "m_angEyeAngles")
    if not eye_angles then
        log_message("Error: Unable to get eye angles.")
        return
    end
    eye_angles = vector(eye_angles)

    local learning_adjustment = 0
    local ai_adjustment = 0

    if ui.get(disable_aa_correction) then
        learning_adjustment = get_resolver_adjustment(player_index)
        ai_adjustment = calculate_resolver_adjustment(player)
    end

    -- Prefer headshots
    local head_angle = entity.get_prop(player, "m_angEyeAngles")
    local body_angle = head_angle

    body_angle.x = head_angle.x + 25
    entity.set_prop(player, "m_angEyeAngles", body_angle)

    eye_angles.y = eye_angles.y + ai_adjustment
    entity.set_prop(player, "m_angEyeAngles", eye_angles)
end

local function track_player_desync(player)
    local player_index = client.userid_to_entindex(player)
    if not player_data[player_index] then
        player_data[player_index] = { 
            desync_type = "", 
            yaw = 0, 
            jitter_mode = "", 
            jitter_scale = 0,
            shot_results = {hits = 0, misses = 0}
        }
    end

    local eye_angles = entity.get_prop(player, "m_angEyeAngles")
    if not eye_angles then
        return
    end

    player_data[player_index].yaw = eye_angles.y
    -- Detect and store Desync type, Jitter Mode, and Jitter Scale based on observed patterns
    -- Replace the following lines with actual detection logic for Desync type, Jitter Mode, and Jitter Scale
    player_data[player_index].desync_type = "Fake"
    player_data[player_index].jitter_mode = "Dynamic"
    player_data[player_index].jitter_scale = 2.5
end

local function update_shot_results(event)
    local player = client.userid_to_entindex(event.userid)
    if not player then
        return
    end

    local player_index = client.userid_to_entindex(player)
    if not player_data[player_index] then
        player_data[player_index] = { 
            desync_type = "", 
            yaw = 0, 
            jitter_mode = "", 
            jitter_scale = 0,
            shot_results = {hits = 0, misses = 0}
        }
    end

    if event.hit then
        player_data[player_index].shot_results.hits = player_data[player_index].shot_results.hits + 1
    else
        player_data[player_index].shot_results.misses = player_data[player_index].shot_results.misses + 1
    end
end

local function prioritize_headshot(player)
    -- Example: Prefer aiming at the head hitbox
    local head_position = entity.hitbox_position(player, 0) -- 0 is the head hitbox index
    if head_position then
        local local_eye_position = entity.get_eye_position(entity.get_local_player())
        local head_angle_to_target = (head_position - local_eye_position):get_angles()
        head_angle_to_target.x = head_angle_to_target.x + 25 -- Adjust for more aggressive aiming
        entity.set_prop(player, "m_angEyeAngles", head_angle_to_target)
    end
end

local function target_body_if_head_not_visible(player)
    local head_visible = client.visible(player, {0}) -- 0 is the head hitbox index
    if not head_visible then
        local body_hitbox_indices = {3, 4, 5, 6} -- Indices for body hitboxes (pelvis, stomach, lower chest, chest)
        for _, hitbox_index in ipairs(body_hitbox_indices) do
            if client.visible(player, {hitbox_index}) then
                local body_position = entity.hitbox_position(player, hitbox_index)
                if body_position then
                    local local_eye_position = entity.get_eye_position(entity.get_local_player())
                    local body_angle_to_target = (body_position - local_eye_position):get_angles()
                    entity.set_prop(player, "m_angEyeAngles", body_angle_to_target)
                    return
                end
            end
        end
    end
end

-- Reduce misses due to spread by timing shots better and aiming at larger hitboxes
local function reduce_miss_due_to_spread(player)
    local local_player = entity.get_local_player()
    local local_velocity = entity.get_prop(local_player, "m_vecVelocity")
    if not local_velocity then
        return
    end
    local_velocity = vector(local_velocity)

    if local_velocity:length2d() > 10 then
        -- The local player is moving, aim at larger hitboxes to compensate for spread
        target_body_if_head_not_visible(player)
    else
        -- The local player is relatively still, prefer headshots
        prioritize_headshot(player)
    end
end

-- Triggerbot: Automatically shoot when the resolver determines a good shot
local function triggerbot_shoot(player)
    if not ui.get(resolver_enabled) then
        return
    end

    local is_in_shot_window = true -- Define your conditions for a good shot window

    if is_in_shot_window then
        client.delay_call(0.1, function() -- Adjust delay as necessary
            client.exec("attack")
        end)
    end
end

client.set_event_callback("aimbot_target", function(event)
    if not ui.get(resolver_enabled) then
        return
    end

    local player = client.userid_to_entindex(event.userid)
    if player then
        track_player_desync(player)
        prioritize_headshot(player)
        target_body_if_head_not_visible(player)
        reduce_miss_due_to_spread(player)
        triggerbot_shoot(player)
    end
end)

client.set_event_callback("aim_fire", update_shot_results)
client.set_event_callback("aim_miss", update_shot_results)

client.set_event_callback("paint", function()
    ui.set_visible(disable_aa_correction, ui.get(resolver_enabled))
    ui.set_visible(force_bodyaim_below_health, ui.get(resolver_enabled))
end)

client.set_event_callback("shutdown", function()
    ui.set_visible(resolver_enabled, false)
    ui.set_visible(disable_aa_correction, false)
    ui.set_visible(force_bodyaim_below_health, false)
end)
