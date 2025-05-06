-- Advanced AI Peek for GameSense (HvH Optimized)
local ffi = require 'ffi'
local vector = require 'vector'
local trace = require 'gamesense/trace'

-- GUI Configuration
local menu = {
    enabled = ui.new_checkbox('LUA', 'B', 'AI Peek Enhanced'),
    key = ui.new_hotkey('LUA', 'B', 'Peek Key', true, 4), -- mouse4
    mode = ui.new_combobox('LUA', 'B', 'Target Selection', {'Closest', 'Highest Damage', 'Most Vulnerable'}),
    hitbox = ui.new_multiselect('LUA', 'B', 'Hitbox Priority', {'Head', 'Neck', 'Chest', 'Pelvis', 'Limbs'}),
    fov = ui.new_slider('LUA', 'B', 'Max FOV', 1, 180, 60),
    smooth = ui.new_slider('LUA', 'B', 'Smoothing', 1, 30, 12),
    extrapolate = ui.new_slider('LUA', 'B', 'Extrapolation', 0, 5, 1),
    hvh = {
        antiaim = ui.new_checkbox('LUA', 'B', 'HvH Anti-Aim'),
        fakelag = ui.new_checkbox('LUA', 'B', 'Adaptive Fakelag'),
        autoduck = ui.new_checkbox('LUA', 'B', 'Auto Duck')
    },
    visuals = {
        indicator = ui.new_checkbox('LUA', 'B', 'Visual Indicator'),
        debug = ui.new_multiselect('LUA', 'B', 'Debug', {'Target', 'FOV', 'Hitbox'})
    }
}

-- Core Variables
local enemies_cache = {}
local last_update = globals.curtime()
local best_target = nil
local best_position = nil
local is_peeking = false

-- Math Functions
local function normalize_angle(angle)
    angle = angle % 360
    return angle > 180 and angle - 360 or angle
end

local function get_fov(from, to)
    local delta = normalize_angle(to - from)
    return math.abs(delta)
end

-- Player Processing
local function update_enemies()
    if globals.curtime() - last_update < 0.1 then return end
    last_update = globals.curtime()
    
    enemies_cache = {}
    local players = entity.get_players(true) -- Only enemies
    local local_player = entity.get_local_player()
    
    for _, enemy in ipairs(players) do
        if entity.is_alive(enemy) then
            table.insert(enemies_cache, enemy)
        end
    end
end

-- Hitbox Processing
local function get_hitbox_priority()
    local hitboxes = {}
    local selected = ui.get(menu.hitbox)
    
    if selected == nil then return {0, 4, 3} end -- Default: Head, Chest, Pelvis
    
    if table.contains(selected, 'Head') then table.insert(hitboxes, 0) end
    if table.contains(selected, 'Neck') then table.insert(hitboxes, 1) end
    if table.contains(selected, 'Chest') then table.insert(hitboxes, 4) end
    if table.contains(selected, 'Pelvis') then table.insert(hitboxes, 3) end
    if table.contains(selected, 'Limbs') then
        table.insert(hitboxes, 13) -- Left arm
        table.insert(hitboxes, 14) -- Right arm
        table.insert(hitboxes, 7)  -- Left leg
        table.insert(hitboxes, 8)  -- Right leg
    end
    
    return #hitboxes > 0 and hitboxes or {0, 4, 3}
end

-- Target Selection
local function select_target()
    update_enemies()
    local local_player = entity.get_local_player()
    if not entity.is_alive(local_player) then return nil, nil end
    
    local view_angles = {client.camera_angles()}
    local hitboxes = get_hitbox_priority()
    local best_data = {target = nil, position = nil, damage = 0, fov = 180}
    
    for _, enemy in ipairs(enemies_cache) do
        for _, hitbox in ipairs(hitboxes) do
            local pos = {entity.hitbox_position(enemy, hitbox)}
            if pos[1] then
                -- Extrapolate position
                local vel = {entity.get_prop(enemy, "m_vecVelocity")}
                local ticks = ui.get(menu.extrapolate)
                pos[1] = pos[1] + vel[1] * globals.tickinterval() * ticks
                pos[2] = pos[2] + vel[2] * globals.tickinterval() * ticks
                pos[3] = pos[3] + vel[3] * globals.tickinterval() * ticks
                
                -- Calculate angles to target
                local angles = {vector_angles(local_player, pos)}
                local fov = get_fov(view_angles[2], angles[2])
                
                if fov <= ui.get(menu.fov) then
                    -- Trace visibility
                    local visible = trace.line(local_player, pos, {skip = local_player}).fraction > 0.97
                    
                    if visible then
                        -- Calculate damage
                        local damage = 100 -- Placeholder for actual damage calculation
                        
                        -- Select based on mode
                        local mode = ui.get(menu.mode)
                        if mode == 'Closest' or (best_data.target == nil) then
                            if fov < best_data.fov then
                                best_data = {target = enemy, position = pos, damage = damage, fov = fov}
                            end
                        elseif mode == 'Highest Damage' then
                            if damage > best_data.damage then
                                best_data = {target = enemy, position = pos, damage = damage, fov = fov}
                            end
                        elseif mode == 'Most Vulnerable' then
                            -- Add vulnerability calculation here
                            if damage > best_data.damage then
                                best_data = {target = enemy, position = pos, damage = damage, fov = fov}
                            end
                        end
                    end
                end
            end
        end
    end
    
    return best_data.target, best_data.position
end

-- HvH Features
local function handle_hvh()
    if not is_peeking then return end
    
    -- Anti-Aim Override
    if ui.get(menu.hvh.antiaim) then
        ui.set(menu.hvh.antiaim, true)
        -- Custom anti-aim logic here
    end
    
    -- Adaptive Fakelag
    if ui.get(menu.hvh.fakelag) then
        ui.set(menu.hvh.fakelag, true)
        -- Custom fakelag logic here
    end
    
    -- Auto Duck
    if ui.get(menu.hvh.autoduck) then
        client.set_cvar("+duck", 1)
    end
end

-- Main Logic
local function on_createmove(cmd)
    is_peeking = ui.get(menu.key)
    if not ui.get(menu.enabled) or not is_peeking then return end
    
    best_target, best_position = select_target()
    if not best_target or not best_position then return end
    
    -- Smooth Aiming
    local local_eyes = {entity.get_eye_position(entity.get_local_player())}
    local target_angles = {vector_angles(local_eyes, best_position)}
    local current_angles = {client.camera_angles()}
    
    local smooth_factor = ui.get(menu.smooth)
    target_angles[1] = current_angles[1] + (target_angles[1] - current_angles[1]) / smooth_factor
    target_angles[2] = current_angles[2] + (target_angles[2] - current_angles[2]) / smooth_factor
    
    cmd.viewangles = target_angles
    
    -- HvH Features
    handle_hvh()
end

-- Visuals
local function on_paint()
    if not ui.get(menu.enabled) then return end
    
    -- Visual Indicator
    if ui.get(menu.visuals.indicator) then
        local text = is_peeking and "AI PEEK [ACTIVE]" or "AI PEEK [READY]"
        local color = is_peeking and {0, 255, 0, 255} or {255, 255, 255, 255}
        renderer.text(50, 50, color[1], color[2], color[3], color[4], "cb", 0, text)
    end
    
    -- Debug Visuals
    if best_target and best_position then
        if table.contains(ui.get(menu.visuals.debug), 'Target') then
            local x, y = renderer.world_to_screen(best_position[1], best_position[2], best_position[3])
            if x then
                renderer.text(x, y, 255, 0, 0, 255, "c", 0, "TARGET")
            end
        end
    end
end

-- Event Handlers
client.set_event_callback("paint", on_paint)
client.set_event_callback("createmove", on_createmove)

print("✅ Advanced AI Peek loaded successfully!")