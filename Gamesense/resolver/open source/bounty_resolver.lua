-- Function to safely require libraries
local function require_lib(lib, error_msg)
    local success, result = pcall(require, lib)
    if success then
        return result
    else
        error(error_msg)
    end
end

-- UI Elements
local resolver_checkbox = ui.new_checkbox("RAGE", "Other", "Advanced Resolver")
local prediction_checkbox = ui.new_checkbox("RAGE", "Other", "Improved Prediction")

-- Helper functions
local function to_ticks(time) return math.floor(time / globals.tickinterval() + 0.5) end

-- Resolver Function
local function resolver()
    if not ui.get(resolver_checkbox) then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    client.update_player_list()
    for _, player in pairs(entity.get_players(true)) do
        local simtime, old_simtime = entity.get_prop(player, "m_flSimulationTime"), entity.get_prop(player, "m_flOldSimulationTime")
        if not simtime or not old_simtime then return end
        
        simtime, old_simtime = to_ticks(simtime), to_ticks(old_simtime)
        local records = {}
        records[player] = records[player] or {}
        records[player][simtime] = {
            eye = select(2, entity.get_prop(player, "m_angEyeAngles")),
            lby = entity.get_prop(player, "m_flLowerBodyYawTarget"),
            desync = antiaim_funcs.get_max_desync(antiaim_funcs.get_animstate(player))
        }
        
        if records[player][old_simtime] and records[player][simtime] then
            local anim_state = antiaim_funcs.get_animstate(player)
            local max_desync = records[player][simtime].desync
            local eye_yaw = records[player][simtime].eye

            -- Predict Fake Yaw Offset
            local fake_yaw = eye_yaw + max_desync
            -- local math.rando
            if math.abs(fake_yaw - records[player][old_simtime].eye) > max_desync then
                fake_yaw = eye_yaw - max_desync
            end
            
            plist.set(player, "Force body yaw", fake_yaw)
            plist.set(player, "Force body yaw value", fake_yaw)
            plist.set(player, "Correction active", true)
        end
    end
end

client.set_event_callback("net_update_end", function()
    if ui.get(resolver_checkbox) then
        resolver()
    end
end)

-- Velocity Calculation
local function get_velocity(player)
    local vx, vy = entity.get_prop(player, "m_vecVelocity")
    return math.sqrt(vx^2 + vy^2)
end

-- Advanced Prediction Fix
local function prediction_fix()
    if not ui.get(prediction_checkbox) then return end

    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return end

    local target = client.current_threat()
    if not target or not entity.is_alive(target) or entity.is_dormant(target) then return end

    local x, y, z = entity.get_prop(target, "m_vecOrigin")
    if not x or not y or not z then return end
    if get_velocity(target) < 20 then return end

    local new_x, new_y, new_z = x + globals.tickinterval() * entity.get_prop(target, "m_vecVelocity"), y, z
    local frame_count = globals.framecount()
    local smoothing = 1 / frame_count

    local smoothed_position = vector(x, y, z)
    smoothed_position.x = smoothed_position.x + (new_x - smoothed_position.x) * smoothing
    smoothed_position.y = smoothed_position.y + (new_y - smoothed_position.y) * smoothing
    smoothed_position.z = smoothed_position.z + (new_z - smoothed_position.z) * smoothing

    local r, g, b, a = 255, 0, 0, 200
    local screen_x, screen_y = renderer.world_to_screen(x, y, z)
    local target_x, target_y = renderer.world_to_screen(smoothed_position.x, smoothed_position.y, smoothed_position.z)

    if screen_x and screen_y and target_x and target_y then
        renderer.line(screen_x, screen_y, target_x, target_y, r, g, b, a)
    end
end

client.set_event_callback("paint", function()
    if ui.get(prediction_checkbox) then
        prediction_fix()
    end
end)
