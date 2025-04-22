-- Bluhgang Resolver (Ultimate v2.2)
local ffi = require("ffi")


-- FFI Definitions
ffi.cdef[[
    struct AnimationLayer {
        char pad_0[20];
        int activity;
        int flags;
        float cycle;
        float playbackrate;
        float weight;
        float weightdelta;
        float unk0;
        float unk1;
        int order;
    };
]]

-- Game Interfaces
local ientitylist = ffi.cast("void***", client.create_interface("client_panorama.dll", "VClientEntityList003"))
local get_client_entity = ffi.cast("void*(__thiscall*)(void*, int)", ientitylist[0][3])

-- Configuration
local RESOLVER_VERSION = "2.2.0"
local MAX_PLAYERS = 64
local LAYER_ADJUST = 6
local DEBUG_PREFIX = "[Resolver] "
local VALID_PATTERNS = {
    ["UDUD"] = { weight = 1.3, threshold = 2 },
    ["DUDU"] = { weight = 1.2, threshold = 2 },
    ["UUUU"] = { weight = 1.6, threshold = 2 },
    ["DDDD"] = { weight = 1.6, threshold = 2 },
    ["UUDD"] = { weight = 1.1, threshold = 3 },
    ["UDU"]  = { weight = 1.0, threshold = 4 }
}

-- UI Elements
local menu = {
    resolver_enable = ui.new_checkbox("RAGE", "Other", "Advanced Resolver"),
    resolver_debug = ui.new_checkbox("RAGE", "Other", "Resolver Debug"),
    resolver_flags = ui.new_checkbox("RAGE", "Other", "Show Resolver Flags"),
    resolver_aggression = ui.new_slider("RAGE", "Other", "Resolver Aggression", 1, 3, 2),
    resolver_style = ui.new_combobox("RAGE", "Other", "Resolver Style", {"Balanced", "Aggressive", "Defensive", "Experimental"}),
    
    override_body_checkbox, override_body_combobox,
    override_safe_checkbox, override_safe_combobox,
    force_body
}

-- Initialize UI references
menu.override_body_checkbox, menu.override_body_combobox = ui.reference("Players", "Adjustments", "Override Prefer body aim")
menu.override_safe_checkbox, menu.override_safe_combobox = ui.reference("Players", "Adjustments", "Override Safe point")
menu.force_body = ui.reference("Players", "Adjustments", "Force body yaw")

-- Resolver State
local resolver_data = {
    players = {},
    layer_cache = {},
    last_processed = 0,
    aggression_levels = { [1] = 0.6, [2] = 1.0, [3] = 1.4 },
    brute_counter = {},
    shot_history = {}
}

-- Initialize player data
for i = 1, MAX_PLAYERS do
    resolver_data.players[i] = {
        side = "none",
        desync = 58,
        confidence = 0,
        hit_count = 0,
        miss_count = 0,
        patterns = {},
        context = {
            moving = false,
            ducking = false,
            airborne = false,
            velocity = 0,
            eye_yaw = 0,
            lby = 0,
            weapon_type = 0
        },
        last_updated = 0,
        brute_stage = 0,
        last_shot_time = 0
    }
end

-- Helper Functions
local function clamp(value, min, max)
    return math.min(math.max(value, min), max)
end

local function normalize_yaw(yaw)
    yaw = yaw % 360
    return yaw > 180 and yaw - 360 or yaw
end

local function get_anim_layers(player)
    local ent = get_client_entity(ientitylist, player)
    return ent and ffi.cast("struct AnimationLayer**", ffi.cast("char*", ent) + 0x2990)[0]
end

local function is_valid_player(player)
    return type(player) == "number" and player >= 1 and player <= MAX_PLAYERS
end

-- Advanced Context Analysis
local function update_player_context(player)
    local state = resolver_data.players[player]
    if not state then return end

    local velocity = {entity.get_prop(player, "m_vecVelocity")}
    local weapon = entity.get_player_weapon(player)
    
    state.context.velocity = math.sqrt(velocity[1]^2 + velocity[2]^2)
    state.context.ducking = entity.get_prop(player, "m_flDuckAmount") or 0
    state.context.airborne = bit.band(entity.get_prop(player, "m_fFlags"), 1) ~= 1
    state.context.moving = state.context.velocity > 10
    state.context.eye_yaw = entity.get_prop(player, "m_angEyeAngles[1]") or 0
    state.context.lby = entity.get_prop(player, "m_flLowerBodyYawTarget") or 0
    state.context.weapon_type = weapon and entity.get_prop(weapon, "m_iItemDefinitionIndex") or 0
    
    -- Initialize brute counter with timestamp
    resolver_data.brute_counter[player] = resolver_data.brute_counter[player] or {
        stages = {"left", "right", "center"},
        current_stage = 1,
        last_reset = globals.realtime()
    }
end

-- Intelligent Pattern Recognition
local function analyze_patterns(state, player)
    local pattern_str = table.concat(state.patterns)
    local confidence_boost = 0
    local aggression = resolver_data.aggression_levels[ui.get(menu.resolver_aggression)] or 1.0
    local resolver_style = ui.get(menu.resolver_style)

    -- Initialize brute_data with timestamp tracking
    local brute_data = resolver_data.brute_counter[player] or {
        stages = {"left", "right", "center"},
        current_stage = 1,
        last_reset = globals.realtime()
    }
    resolver_data.brute_counter[player] = brute_data

    -- Style-based multipliers
    local style_mod = 1.0
    if resolver_style == "Aggressive" then
        style_mod = 1.4
    elseif resolver_style == "Defensive" then
        style_mod = 0.6
    elseif resolver_style == "Experimental" then
        style_mod = 1.8
    end

    -- Enhanced pattern recognition with weapon-based adjustments
    for pattern, data in pairs(VALID_PATTERNS) do
        local count = select(2, pattern_str:gsub(pattern, ""))
        if count >= data.threshold then
            local weapon_mod = state.context.weapon_type == 64 and 0.9 or 1.1 -- SSG modifier
            confidence_boost = confidence_boost + (count * data.weight * 18 * style_mod * weapon_mod)
        end
    end

    -- LBY-based adjustments
    local lby_delta = math.abs(normalize_yaw(state.context.lby - state.context.eye_yaw))
    local lby_mod = lby_delta > 35 and 1.25 or 1.0
    confidence_boost = confidence_boost * lby_mod

    -- Time-based confidence system
    local time_since_update = globals.realtime() - state.last_updated
    local time_decay = time_since_update * (state.context.moving and 6 or 4)
    state.confidence = clamp(state.confidence + confidence_boost - time_decay, 0, 100)

    -- Adaptive prediction logic
    local new_side = state.side
    if state.miss_count >= 3 and (globals.realtime() - brute_data.last_reset) > 2 then
        brute_data.current_stage = (brute_data.current_stage % 3) + 1
        new_side = brute_data.stages[brute_data.current_stage]
        brute_data.last_reset = globals.realtime()
        state.confidence = 85
        state.desync = 58
    else
        -- Advanced pattern matching
        if pattern_str:match("UUUU$") then
            new_side = "right"
        elseif pattern_str:match("DDDD$") then
            new_side = "left"
        elseif pattern_str:match("UDUD$") then
            new_side = state.side == "left" and "right" or "left"
        end
        
        -- Velocity-based override
        if state.context.moving and state.confidence > 45 then
            local move_yaw = math.deg(math.atan2(velocity[2], velocity[1]))
            local yaw_delta = math.abs(normalize_yaw(move_yaw - state.context.eye_yaw))
            new_side = yaw_delta > 90 and "left" or "right"
        end
    end

    -- Confidence-based application
    if state.confidence > 35 then
        state.side = new_side
        state.brute_stage = brute_data.current_stage
    end
end

-- Enhanced Animation Analysis
local function analyze_layers(player)
    if not is_valid_player(player) then return end
    
    local state = resolver_data.players[player]
    if not state then return end

    local layers = get_anim_layers(player)
    if not layers then return end

    update_player_context(player)
    
    resolver_data.layer_cache[player] = resolver_data.layer_cache[player] or {}
    local cache = resolver_data.layer_cache[player]

    -- Store layer data with velocity context
    table.insert(cache, 1, {
        cycle = layers[LAYER_ADJUST].cycle,
        weight = layers[LAYER_ADJUST].weight,
        rate = layers[LAYER_ADJUST].playbackrate,
        time = globals.realtime(),
        velocity = state.context.velocity
    })

    -- Maintain 20-frame history
    if #cache > 20 then table.remove(cache, 21) end

    -- Build delta patterns with velocity filtering
    if #cache >= 2 then
        local delta = cache[1].weight - cache[2].weight
        if math.abs(delta) > 0.05 then -- Noise filter
            table.insert(state.patterns, 1, delta > 0 and "U" or "D")
            if #state.patterns > 40 then table.remove(state.patterns, 41) end
        end
    end

    -- Full analysis cycle
    if globals.realtime() - state.last_updated > 0.25 then
        analyze_patterns(state, player)
        state.last_updated = globals.realtime()
        
        -- Dynamic desync calculation with velocity scaling
        local base_cycle = cache[1].cycle
        local raw_desync = math.abs(base_cycle * 1000 * cache[1].rate)
        local velocity_mod = clamp(state.context.velocity / 250, 0.5, 1.2)
        
        -- Context-based adjustments
        local final_desync = raw_desync
        if state.context.airborne then
            final_desync = final_desync * 0.7
        elseif state.context.ducking > 0.5 then
            final_desync = final_desync * 0.85
        end
        
        state.desync = clamp(final_desync * velocity_mod, 10, 60)
    end
end

-- Resolver Core with Adaptive Processing
local function update_resolver()
    if not ui.get(menu.resolver_enable) then return end

    local players = entity.get_players(true)
    local local_player = entity.get_local_player()
    local current_time = globals.realtime()

    -- Adaptive processing throttling
    local processing_interval = #players > 3 and 0.08 or 0.05
    if current_time - resolver_data.last_processed < processing_interval then return end
    resolver_data.last_processed = current_time

    for _, player in ipairs(players) do
        if not is_valid_player(player) or player == local_player then goto continue end

        local state = resolver_data.players[player]
        if not entity.is_alive(player) then goto continue end

        analyze_layers(player)

        -- Apply resolver logic with confidence threshold
        if state.confidence > 35 then
            plist.set(player, "Force body yaw", true)
            plist.set(player, "Force body yaw value", state.side == "left" and -state.desync or state.desync)
            
            -- Update overrides with safety checks
            if menu.override_body_combobox then
                ui.set(menu.override_body_combobox, state.confidence > 70 and 2 or 1)
            end
            plist.set(player, "Prefer body aim", state.confidence > 70 and 2 or 1)
            plist.set(player, "Safe point", state.confidence > 85 and 1 or 0)
        end

        ::continue::
    end
end

-- Event Handlers with Brute Protection
client.set_event_callback("net_update_end", update_resolver)

client.set_event_callback("aim_miss", function(e)
    if not ui.get(menu.resolver_enable) then return end
    
    local player = e.target
    if not is_valid_player(player) then return end

    local state = resolver_data.players[player]
    state.miss_count = state.miss_count + 1
    state.hit_count = math.max(state.hit_count - 1, 0)
    state.confidence = clamp(state.confidence - 30, 0, 100)

    -- Adaptive correction with brute reset
    if state.miss_count >= 2 then
        state.side = state.side == "left" and "right" or "left"
        state.desync = clamp(state.desync * 0.8, 25, 60)
        state.miss_count = 0
        
        -- Reset brute counter after 4 misses
        if state.miss_count >= 4 then
            resolver_data.brute_counter[player] = nil
        end
        
        if ui.get(menu.resolver_debug) then
            client.log(DEBUG_PREFIX .. ("Adaptive correction for %s (New side: %s)"):format(
                entity.get_player_name(player),
                state.side
            ))
        end
    end
end)

client.set_event_callback("aim_hit", function(e)
    local player = e.target
    if not is_valid_player(player) then return end

    local state = resolver_data.players[player]
    state.hit_count = state.hit_count + 1
    state.miss_count = math.max(state.miss_count - 2, 0)
    state.confidence = clamp(state.confidence + 25, 0, 100)
    state.last_shot_time = globals.realtime()

    -- Successful hit adjustments
    if state.hit_count > 2 then
        state.desync = clamp(state.desync * 1.1, 25, 60)
    end
    
    -- Reset brute counter on hit
    resolver_data.brute_counter[player] = nil
end)

-- Enhanced Visual Feedback
client.register_esp_flag("RS", 0, 255, 0, function(player)
    return ui.get(menu.resolver_flags) and resolver_data.players[player].side == "right"
end)

client.register_esp_flag("LS", 255, 0, 0, function(player)
    return ui.get(menu.resolver_flags) and resolver_data.players[player].side == "left"
end)

-- Cleanup and Safety
client.set_event_callback("shutdown", function()
    for i = 1, MAX_PLAYERS do
        if is_valid_player(i) then
            plist.set(i, "Force body yaw", false)
            plist.set(i, "Prefer body aim", 0)
            plist.set(i, "Safe point", 0)
        end
    end
    resolver_data.brute_counter = {}
end)

-- UI Management
local function update_ui()
    local state = ui.get(menu.resolver_enable)
    ui.set_visible(menu.resolver_debug, state)
    ui.set_visible(menu.resolver_flags, state)
    ui.set_visible(menu.resolver_aggression, state)
    ui.set_visible(menu.resolver_style, state)
    ui.set(menu.force_body, not state)
end

ui.set_callback(menu.resolver_enable, update_ui)
update_ui()

client.log(DEBUG_PREFIX .. "Resolver initialized (" .. RESOLVER_VERSION .. ")")