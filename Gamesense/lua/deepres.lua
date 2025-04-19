-- Anti-Aim Resolver for GameSense
-- With the help of AI
-- Author: [BreakClover]
-- Version: 1.0

-- Global Variables
local resolver_enabled = false
local resolver_patterns = {}
local resolver_database = {}

-- Console Commands
client.set_event_callback("console_input", function(input)
    if input == "RESOLVER LOADED" then
        resolver_enabled = true
        print("RESOLVER LOADED")
    elseif input == "RESOLVER UNLOADED" then
        resolver_enabled = false
        print("RESOLVER UNLOADED")
    end
end)

-- Helper Functions
local function get_player_data(player)
    local origin = player:get_origin()
    local velocity = player:get_prop("m_vecVelocity")
    local eye_angles = player:get_eye_angles()
    local lby = player:get_prop("m_flLowerBodyYawTarget")
    return {
        origin = origin,
        velocity = velocity,
        eye_angles = eye_angles,
        lby = lby
    }
end

local function analyze_anti_aim(player)
    local data = get_player_data(player)
    local player_index = player:get_index()

    -- Check for height difference
    local local_player = entity_list.get_local_player()
    local local_origin = local_player:get_origin()
    local height_diff = data.origin.z - local_origin.z

    -- Adjust for height difference
    if height_diff > 50 then
        data.eye_angles.y = data.eye_angles.y + 15
    elseif height_diff < -50 then
        data.eye_angles.y = data.eye_angles.y - 15
    end

    -- Analyze anti-aim patterns
    if resolver_patterns[player_index] == nil then
        resolver_patterns[player_index] = {}
    end

    local pattern = resolver_patterns[player_index]
    pattern.last_eye_angles = data.eye_angles
    pattern.last_lby = data.lby

    -- Detect jitter anti-aim
    if pattern.last_eye_angles and math.abs(pattern.last_eye_angles.y - data.eye_angles.y) > 20 then
        pattern.jitter = true
    else
        pattern.jitter = false
    end

    -- Detect static anti-aim
    if pattern.last_eye_angles and math.abs(pattern.last_eye_angles.y - data.eye_angles.y) < 5 then
        pattern.static = true
    else
        pattern.static = false
    end

    -- Detect defensive anti-aim
    if pattern.last_lby and math.abs(pattern.last_lby - data.lby) > 30 then
        pattern.defensive = true
    else
        pattern.defensive = false
    end

    -- Detect desync
    if pattern.last_eye_angles and math.abs(pattern.last_eye_angles.y - data.eye_angles.y) > 50 then
        pattern.desync = true
    else
        pattern.desync = false
    end

    -- Save patterns to database
    resolver_database[player_index] = pattern
end

-- Main Resolver Function
local function resolve_anti_aim(cmd)
    if not resolver_enabled then return end

    local local_player = entity_list.get_local_player()
    local players = entity_list.get_players(true)

    for _, player in ipairs(players) do
        analyze_anti_aim(player)

        local pattern = resolver_database[player:get_index()]
        if pattern then
            if pattern.jitter then
                cmd.viewangles.y = pattern.last_eye_angles.y + 180
            elseif pattern.static then
                cmd.viewangles.y = pattern.last_eye_angles.y
            elseif pattern.defensive then
                cmd.viewangles.y = pattern.last_lby
            elseif pattern.desync then
                cmd.viewangles.y = pattern.last_eye_angles.y + 110
            end
        end
    end
end

-- Hook into the cheat's event system
client.set_event_callback("createmove", function(cmd)
    resolve_anti_aim(cmd)
end)

-- Initialize Resolver
print("Anti-Aim Resolver Initialized. Use 'RESOLVER LOADED' or 'RESOLVER UNLOADED' in console to toggle.")