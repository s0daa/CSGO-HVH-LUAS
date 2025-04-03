--███╗   ███╗███████╗███╗   ██╗██╗   ██╗
--████╗ ████║██╔════╝████╗  ██║██║   ██║
--██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║
--██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║
--██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝
--╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝

local menu_main = {

    menu_master_tabs = menu.add_list("Everlasting.lua", "Tabs", {"Anti-Aim", "Visuals", "Animations"}, 3),

    menu_antiaim_tabs = menu.add_selection("Yaw Control", "Anti-Aim Mode", {"Unconditional", "Conditional"}),
    jitter_speed = menu.add_slider("Yaw Control", "Jitter Frequency", 0, 50, 1, 0, "Hz"),

    -- teleport
    menu_antiaim_misc_teleport = menu.add_checkbox("Misc Anti-Aim", "Teleport On Key"),
    -- aa fighing
    menu_antiaim_fishing = menu.add_checkbox("Misc Anti-Aim", "Pitch Fishing"),
    -- crouch fishing
    menu_antiaim_crouch_fishing = menu.add_checkbox("Misc Anti-Aim", "Crouch Fishing"),
    menu_antiaim_crouch_fishing_speed = menu.add_slider("Misc Anti-Aim", "Crouch Fishing", 2, 15, 1, 2, "°"),
    menu_antiaim_crouch_fishing_air = menu.add_checkbox("Misc Anti-Aim", "Disable Crouch Fish In Air"),
    -- fake desync
    menu_antiaim_fake_desync = menu.add_checkbox("Misc Anti-Aim", "Fake Desync"),
    menu_antiaim_fake_desync_speed = menu.add_slider("Misc Anti-Aim", "Fake Desync Frequency", 0, 50, 1, 0, "°"),
    -- extended roll
    menu_antiaim_extended_roll = menu.add_checkbox("Misc Anti-Aim", "Extended Roll"),
    menu_antiaim_extended_roll_amount = menu.add_slider("Misc Anti-Aim", "Extended Roll Amount",-80, 80, 0.01, 0, '°'),
}
local menu_elems = {
    -- Animations
    Leg_air_anim_select = menu.add_multi_selection("Air Animations", "Types", {"Leg Movement", "leg Stiffness","Fall movement","Toe point","Lean","Moonwalk"}),
    Leg_air_move = menu.add_slider('Air Animations', 'leg Movement amount', 0, 1.0, 0.01, 2, '°'),
    Leg_air_stiff = menu.add_slider('Air Animations', 'leg Stiffness amount', 0, 1.0, 0.01, 2, '°'),
    Leg_air_fall = menu.add_slider('Air Animations', 'Fall Movement amount', 0, 1.0, 0.01, 2, '°'),
    Leg_air_toe = menu.add_slider('Air Animations', 'Toe point amount', 0, 1.0, 0.01, 2, '°'),
    Leg_air_Lean = menu.add_slider('Air Animations', 'Lean amount', 0, 1.0, 0.01, 2, '°'),
    Leg_air_moonwalk = menu.add_slider('Air Animations', 'Moonwalk angle', 0, 1.0, 0.01, 2, '°'),

    Leg_moving_anim_select = menu.add_multi_selection("Moving Animations", "Types", {"Leg Movement","Lean", "Moonwalk"}),
    Leg_moving_move = menu.add_slider('Moving Animations', 'leg Movement amount', 0, 1.0, 0.01, 2, '°'),
    Leg_moving_Lean = menu.add_slider('Moving Animations', 'Lean amount', 0, 1.0, 0.01, 2, '°'),
    Leg_moving_moonwalk = menu.add_slider('Moving Animations', 'Moonwalk angle', 0, 1.0, 0.01, 2, '°'),

    Pitch_on_land_check = menu.add_checkbox("Pitch Animations", "Zero pitch on land"),
    Pitch_on_land_delay = menu.add_slider('Pitch Animations', 'Reset Pitch Delay', 0, 50, 1, 0, '°'),

    WatermarkCheckbox = menu.add_checkbox("Visuals", "Crosshair Watermark"),
    WatermarkStyleSelection = menu.add_selection("Visuals", "Crosshair Watermark Styles", {"Stairs", "Caterpillar", "Continuity", "Continuity Alpha"}),
    SlowedCheckbox = menu.add_checkbox("Indicators", "Slowed"),
    SlowedTextCheckbox = menu.add_checkbox("Indicators", "Show Text"),
    SlowedDesyncCheckbox = menu.add_checkbox("Indicators", "Show Desync while not slowed"),

    KeybindsCheckbox = menu.add_checkbox("Indicators", "keybinds"),

    BounceCheckbox = menu.add_checkbox("Misc Visuals", "Bounce on hit"),
    ScopedCheckbox = menu.add_checkbox("Misc Visuals", "Reposition while scoped"),
    VisualsOffsetSlider = menu.add_slider('Misc Visuals', 'Visuals (Y) Offset', -50, 50, 1, 0, '°'),
    
}

function is_slow_walk_active()
    local slow_enable = menu.find('misc', 'main', 'movement', 'Slow Walk', 'enabled')
    
    if slow_enable ~= nil then
        local slow_walk_bind = slow_enable[2]
        return slow_walk_bind:get()
    else
        return false
    end
end

--████████╗██╗███╗   ███╗███████╗    ██████╗  █████╗ ███████╗███████╗██████╗          ██╗██╗████████╗████████╗███████╗██████╗ 
--╚══██╔══╝██║████╗ ████║██╔════╝    ██╔══██╗██╔══██╗██╔════╝██╔════╝██╔══██╗         ██║██║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗
--   ██║   ██║██╔████╔██║█████╗      ██████╔╝███████║███████╗█████╗  ██║  ██║         ██║██║   ██║      ██║   █████╗  ██████╔╝
--   ██║   ██║██║╚██╔╝██║██╔══╝      ██╔══██╗██╔══██║╚════██║██╔══╝  ██║  ██║    ██   ██║██║   ██║      ██║   ██╔══╝  ██╔══██╗
--   ██║   ██║██║ ╚═╝ ██║███████╗    ██████╔╝██║  ██║███████║███████╗██████╔╝    ╚█████╔╝██║   ██║      ██║   ███████╗██║  ██║
--   ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚═════╝      ╚════╝ ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝

local angle_sliders = {}
local num_sliders = 0

function add_angle()
    if #angle_sliders < 50 then
    local angle_slider = menu.add_slider("Yaw Control", "Jitter Angle " .. #angle_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(angle_sliders, angle_slider)
    num_sliders = num_sliders + 1
    end
end

function remove_angle()
    if num_sliders > 0 then
        angle_sliders[num_sliders]:set_visible(false)
        table.remove(angle_sliders, num_sliders)
        num_sliders = num_sliders - 1
        generate_jitter()
    end
end

local add_yaw_button = menu.add_button("Yaw Control", "Add Angle", add_angle)
local remove_yaw_button = menu.add_button("Yaw Control", "Remove Angle", remove_angle)

function generate_jitter()
    local jitter_angle = 0
    for i = 1, #angle_sliders do
        jitter_angle = jitter_angle + angle_sliders[i]:get()
    end
    jitter_angle = jitter_angle / #angle_sliders
    return jitter_angle
end


local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_angle_index = 1
local last_jitter_time = 0

local jitter_yaw_global = function()
    if menu_main.menu_antiaim_tabs:get() == 1 then

    local current_time = globals.real_time()
    local base_speed = menu_main.jitter_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #angle_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_jitter_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_jitter_time = current_time

        if #angle_sliders > 0 and current_angle_index then
            local jitter_angle = angle_sliders[current_angle_index] and angle_sliders[current_angle_index]:get() or 0
            current_angle_index = current_angle_index % #angle_sliders + 1
            yaw_add:set(jitter_angle)
        else
           -- print("FAILED: current_angle_index is nil, please add a slider to make this stop")
            end
        end
    end
end

-- Add two initial angle sliders
--add_angle()
--add_angle()

-- standing/YAW2

local menu_standing = {
    menu_antiaim_conditions = menu.add_list("Yaw Control", "Conditions", {"Standing", "Moving", "Slow Walking", "Crouched", "In Air"}, 5),
    standing_speed = menu.add_slider("Yaw Control", "(S) Jitter Frequency", 0, 50, 1, 0, "Hz"),
}
local standing_sliders = {}
local num_standing_sliders = 0

function add_standing()
    if #standing_sliders < 50 then
    local standing_slider = menu.add_slider("Yaw Control", "(S) Jitter Angle " .. #standing_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(standing_sliders, standing_slider)
    num_standing_sliders = num_standing_sliders + 1
    end
end

function remove_standing()
    if num_standing_sliders > 0 then
        standing_sliders[num_standing_sliders]:set_visible(false)
        table.remove(standing_sliders, num_standing_sliders)
        num_standing_sliders = num_standing_sliders - 1
        generate_standing_jitter()
    end
end

local add_standing_button = menu.add_button("Yaw Control", "Add Angle", add_standing)
local remove_standing_button = menu.add_button("Yaw Control", "Remove Angle", remove_standing)

function generate_standing_jitter()
    local jitter_offset = 0
    for i = 1, #standing_sliders do
        jitter_offset = jitter_offset + standing_sliders[i]:get()
    end
    jitter_offset = jitter_offset / #standing_sliders
    return jitter_offset
end

local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_standing_index = 1
local last_standing_time = 0

local jitter_standing = function()
    if not engine.is_connected() or not engine.is_in_game() then return end
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled_crouch = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_tabs:get() == 2 and not in_air and not key_toggled_crouch and velocity < 10 then

    local current_time = globals.real_time()
    local base_speed = menu_standing.standing_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #standing_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_standing_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_standing_time = current_time

        if #standing_sliders > 0 and current_standing_index then
            local jitter_offset = standing_sliders[current_standing_index] and standing_sliders[current_standing_index]:get() or 0
            current_standing_index = current_standing_index % #standing_sliders + 1
            yaw_add:set(jitter_offset)
        else
           -- print("FAILED: current_standing_index is nil, please add an offset to make this stop")
            end
        end
    end
end

-- Add two initial standing sliders
--add_standing()
--add_standing()

-- moving/YAW2

local menu_moving = {
    moving_speed = menu.add_slider("Yaw Control", "(M) Jitter Frequency", 0, 50, 1, 0, "Hz"),
}
local moving_sliders = {}
local num_moving_sliders = 0

function add_moving()
    if #moving_sliders < 50 then
    local moving_slider = menu.add_slider("Yaw Control", "(M) Jitter Angle " .. #moving_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(moving_sliders, moving_slider)
    num_moving_sliders = num_moving_sliders + 1
    end
end

function remove_moving()
    if num_moving_sliders > 0 then
        moving_sliders[num_moving_sliders]:set_visible(false)
        table.remove(moving_sliders, num_moving_sliders)
        num_moving_sliders = num_moving_sliders - 1
        generate_moving_jitter()
    end
end

local add_moving_button = menu.add_button("Yaw Control", "Add Angle", add_moving)
local remove_moving_button = menu.add_button("Yaw Control", "Remove Angle", remove_moving)

function generate_moving_jitter()
    local jitter_offset = 0
    for i = 1, #moving_sliders do
        jitter_offset = jitter_offset + moving_sliders[i]:get()
    end
    jitter_offset = jitter_offset / #moving_sliders
    return jitter_offset
end

local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_moving_index = 1
local last_moving_time = 0

local jitter_moving = function()
    if not engine.is_connected() or not engine.is_in_game() then return end
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled_crouch = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_tabs:get() == 2 and not in_air and not key_toggled_crouch and velocity > 10 and not is_slow_walk_active()then

    local current_time = globals.real_time()
    local base_speed = menu_moving.moving_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #moving_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_moving_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_moving_time = current_time

        if #moving_sliders > 0 and current_moving_index then
            local jitter_offset = moving_sliders[current_moving_index] and moving_sliders[current_moving_index]:get() or 0
            current_moving_index = current_moving_index % #moving_sliders + 1
            yaw_add:set(jitter_offset)
        else
           -- print("FAILED: current_moving_index is nil, please add an offset to make this stop")
            end
        end
    end
end

-- Add two initial moving sliders
--add_moving()
--add_moving()

local menu_slowwalking = {
    slowwalking_speed = menu.add_slider("Yaw Control", "(SW) Jitter Frequency", 0, 50, 1, 0, "Hz"),
}
local slowwalking_sliders = {}
local num_slowwalking_sliders = 0

function add_slowwalking()
    if #slowwalking_sliders < 50 then
    local slowwalking_slider = menu.add_slider("Yaw Control", "(SW) Jitter Angle " .. #slowwalking_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(slowwalking_sliders, slowwalking_slider)
    num_slowwalking_sliders = num_slowwalking_sliders + 1
    end
end

function remove_slowwalking()
    if num_slowwalking_sliders > 0 then
        slowwalking_sliders[num_slowwalking_sliders]:set_visible(false)
        table.remove(slowwalking_sliders, num_slowwalking_sliders)
        num_slowwalking_sliders = num_slowwalking_sliders - 1
        generate_slowwalking_jitter()
    end
end

local add_slowwalking_button = menu.add_button("Yaw Control", "Add Angle", add_slowwalking)
local remove_slowwalking_button = menu.add_button("Yaw Control", "Remove Angle", remove_slowwalking)

function generate_slowwalking_jitter()
    local jitter_offset = 0
    for i = 1, #slowwalking_sliders do
        jitter_offset = jitter_offset + slowwalking_sliders[i]:get()
    end
    jitter_offset = jitter_offset / #slowwalking_sliders
    return jitter_offset
end

local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_slowwalking_index = 1
local last_slowwalking_time = 0

local jitter_slowwalking = function()
    if not engine.is_connected() or not engine.is_in_game() then return end
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled_crouch = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_tabs:get() == 2 and is_slow_walk_active() and not key_toggled_crouch then

    local current_time = globals.real_time()
    local base_speed = menu_slowwalking.slowwalking_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #slowwalking_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_slowwalking_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_slowwalking_time = current_time

        if #slowwalking_sliders > 0 and current_slowwalking_index then
            local jitter_offset = slowwalking_sliders[current_slowwalking_index] and slowwalking_sliders[current_slowwalking_index]:get() or 0
            current_slowwalking_index = current_slowwalking_index % #slowwalking_sliders + 1
            yaw_add:set(jitter_offset)
        else
           -- print("FAILED: current_slowwalking_index is nil, please add an offset to make this stop")
            end
        end
    end
end

-- Add two initial slowwalking sliders
--add_slowwalking()
--add_slowwalking()

local menu_crouched = {
    crouched_speed = menu.add_slider("Yaw Control", "(C) Jitter Frequency", 0, 50, 1, 0, "Hz"),
}
local crouched_sliders = {}
local num_crouched_sliders = 0

function add_crouched()
    if #crouched_sliders < 50 then
    local crouched_slider = menu.add_slider("Yaw Control", "(C) Jitter Angle " .. #crouched_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(crouched_sliders, crouched_slider)
    num_crouched_sliders = num_crouched_sliders + 1
    end
end

function remove_crouched()
    if num_crouched_sliders > 0 then
        crouched_sliders[num_crouched_sliders]:set_visible(false)
        table.remove(crouched_sliders, num_crouched_sliders)
        num_crouched_sliders = num_crouched_sliders - 1
        generate_crouched_jitter()
    end
end

local add_crouched_button = menu.add_button("Yaw Control", "Add Angle", add_crouched)
local remove_crouched_button = menu.add_button("Yaw Control", "Remove Angle", remove_crouched)

function generate_crouched_jitter()
    local jitter_offset = 0
    for i = 1, #crouched_sliders do
        jitter_offset = jitter_offset + crouched_sliders[i]:get()
    end
    jitter_offset = jitter_offset / #crouched_sliders
    return jitter_offset
end

local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_crouched_index = 1
local last_crouched_time = 0

local jitter_crouched = function()
    if not engine.is_connected() or not engine.is_in_game() then return end
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled_crouch = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_tabs:get() == 2 and key_toggled_crouch then

    local current_time = globals.real_time()
    local base_speed = menu_crouched.crouched_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #crouched_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_crouched_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_crouched_time = current_time

        if #crouched_sliders > 0 and current_crouched_index then
            local jitter_offset = crouched_sliders[current_crouched_index] and crouched_sliders[current_crouched_index]:get() or 0
            current_crouched_index = current_crouched_index % #crouched_sliders + 1
            yaw_add:set(jitter_offset)
        else
           -- print("FAILED: current_crouched_index is nil, please add an offset to make this stop")
            end
        end
    end
end

-- Add two initial crouched sliders
--add_crouched()
--add_crouched()

local menu_air = {
    air_speed = menu.add_slider("Yaw Control", "(A) Jitter Frequency", 0, 50, 1, 0, "Hz"),
}
local air_sliders = {}
local num_air_sliders = 0

function add_air()
    if #air_sliders < 50 then
    local air_slider = menu.add_slider("Yaw Control", "(A) Jitter Angle " .. #air_sliders + 1, -180, 180, 1, 0, "°")
    table.insert(air_sliders, air_slider)
    num_air_sliders = num_air_sliders + 1
    end
end

function remove_air()
    if num_air_sliders > 0 then
        air_sliders[num_air_sliders]:set_visible(false)
        table.remove(air_sliders, num_air_sliders)
        num_air_sliders = num_air_sliders - 1
        generate_air_jitter()
    end
end

local add_air_button = menu.add_button("Yaw Control", "Add Angle", add_air)
local remove_air_button = menu.add_button("Yaw Control", "Remove Angle", remove_air)

function generate_air_jitter()
    local jitter_offset = 0
    for i = 1, #air_sliders do
        jitter_offset = jitter_offset + air_sliders[i]:get()
    end
    jitter_offset = jitter_offset / #air_sliders
    return jitter_offset
end

local yaw_add = menu.find("antiaim", "main", "angles", "yaw add")
local current_air_index = 1
local last_air_time = 0

local jitter_air = function()
    if not engine.is_connected() or not engine.is_in_game() then return end
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled_crouch = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_tabs:get() == 2 and in_air then

    local current_time = globals.real_time()
    local base_speed = menu_air.air_speed:get()
    local speed_increase = 0.015 -- set your desired speed increase percentage here

    local jitter_speed = base_speed * math.pow(1 + speed_increase, #air_sliders)

    local time_since_last_jitter = 1

    if jitter_speed > 0 then
        time_since_last_jitter = current_time - last_air_time
    end

    if time_since_last_jitter >= (1 / jitter_speed) then
        last_air_time = current_time

        if #air_sliders > 0 and current_air_index then
            local jitter_offset = air_sliders[current_air_index] and air_sliders[current_air_index]:get() or 0
            current_air_index = current_air_index % #air_sliders + 1
            yaw_add:set(jitter_offset)
        else
            --print("FAILED: current_air_index is nil, please add an offset to make this stop")
            end
        end
    end
end

-- Add two initial air sliders
--add_air()
--add_air()

--███╗   ███╗███████╗███╗   ██╗██╗   ██╗    ██╗  ██╗ █████╗ ███╗   ██╗██████╗ ██╗     ███████╗██████╗ 
--████╗ ████║██╔════╝████╗  ██║██║   ██║    ██║  ██║██╔══██╗████╗  ██║██╔══██╗██║     ██╔════╝██╔══██╗
--██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║    ███████║███████║██╔██╗ ██║██║  ██║██║     █████╗  ██████╔╝
--██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║    ██╔══██║██╔══██║██║╚██╗██║██║  ██║██║     ██╔══╝  ██╔══██╗
--██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝    ██║  ██║██║  ██║██║ ╚████║██████╔╝███████╗███████╗██║  ██║
--╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝

local handle_menu = function()
    local master_enabled = menu_main.menu_antiaim_tabs:get() == 1 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #angle_sliders do
        angle_sliders[i]:set_visible(master_enabled)
    end
    local master_global_slider_1 = menu_main.menu_antiaim_tabs:get() == 1 and menu_main.menu_master_tabs:get() == 1 and #angle_sliders > 0 
    add_yaw_button:set_visible(master_enabled)
    remove_yaw_button:set_visible(master_global_slider_1)
    menu_main.jitter_speed:set_visible(master_enabled)

    local master_enabled_2 = menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    menu_standing.menu_antiaim_conditions:set_visible(master_enabled_2)

    local master_enabled_standing = menu_standing.menu_antiaim_conditions:get() == 1 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #standing_sliders do
        standing_sliders[i]:set_visible(master_enabled_standing)
    end
    local master_standing_slider_1 = menu_standing.menu_antiaim_conditions:get() == 1 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1 and #standing_sliders > 0 
    add_standing_button:set_visible(master_enabled_standing)
    remove_standing_button:set_visible(master_standing_slider_1)
    menu_standing.standing_speed:set_visible(master_enabled_standing)

    local master_enabled_moving = menu_standing.menu_antiaim_conditions:get() == 2 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #moving_sliders do
        moving_sliders[i]:set_visible(master_enabled_moving)
    end
    local master_moving_slider_1 = menu_standing.menu_antiaim_conditions:get() == 2 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1 and #moving_sliders > 0 
    add_moving_button:set_visible(master_enabled_moving)
    remove_moving_button:set_visible(master_moving_slider_1)
    menu_moving.moving_speed:set_visible(master_enabled_moving)

    local master_enabled_slowwalking = menu_standing.menu_antiaim_conditions:get() == 3 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #slowwalking_sliders do
        slowwalking_sliders[i]:set_visible(master_enabled_slowwalking)
    end
    local master_slowwalking_slider_1 = menu_standing.menu_antiaim_conditions:get() == 3 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1 and #slowwalking_sliders > 0 
    add_slowwalking_button:set_visible(master_enabled_slowwalking)
    remove_slowwalking_button:set_visible(master_slowwalking_slider_1)
    menu_slowwalking.slowwalking_speed:set_visible(master_enabled_slowwalking)

    local master_enabled_crouched = menu_standing.menu_antiaim_conditions:get() == 4 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #crouched_sliders do
        crouched_sliders[i]:set_visible(master_enabled_crouched)
    end
    local master_crouched_slider_1 = menu_standing.menu_antiaim_conditions:get() == 4 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1 and #crouched_sliders > 0 
    add_crouched_button:set_visible(master_enabled_crouched)
    remove_crouched_button:set_visible(master_crouched_slider_1)
    menu_crouched.crouched_speed:set_visible(master_enabled_crouched)

    local master_enabled_air = menu_standing.menu_antiaim_conditions:get() == 5 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1
    
    for i = 1, #air_sliders do
        air_sliders[i]:set_visible(master_enabled_air)
    end
    local master_air_slider_1 = menu_standing.menu_antiaim_conditions:get() == 5 and menu_main.menu_antiaim_tabs:get() == 2 and menu_main.menu_master_tabs:get() == 1 and #air_sliders > 0 
    add_air_button:set_visible(master_enabled_air)
    remove_air_button:set_visible(master_air_slider_1)
    menu_air.air_speed:set_visible(master_enabled_air)

    -- AA MISC
    local handle_menu_tab_1 = menu_main.menu_master_tabs:get() == 1
    menu_main.menu_antiaim_tabs:set_visible(handle_menu_tab_1)
    menu_main.menu_antiaim_fishing:set_visible(handle_menu_tab_1)
    menu_main.menu_antiaim_fake_desync:set_visible(handle_menu_tab_1)
    menu_main.menu_antiaim_extended_roll:set_visible(handle_menu_tab_1)
    menu_main.menu_antiaim_misc_teleport:set_visible(handle_menu_tab_1)
    menu_main.menu_antiaim_crouch_fishing:set_visible(handle_menu_tab_1)
    local handle_menu_antiaim_fake_desync = menu_main.menu_antiaim_fake_desync:get() and menu_main.menu_master_tabs:get() == 1
    menu_main.menu_antiaim_fake_desync_speed:set_visible(handle_menu_antiaim_fake_desync)
    local handle_menu_antiaim_extended_roll = menu_main.menu_antiaim_extended_roll:get() and menu_main.menu_master_tabs:get() == 1
    menu_main.menu_antiaim_extended_roll_amount:set_visible(handle_menu_antiaim_extended_roll)
    local handle_menu_antiaim_crouch_fishing = menu_main.menu_antiaim_crouch_fishing:get() and menu_main.menu_master_tabs:get() == 1
    menu_main.menu_antiaim_crouch_fishing_speed:set_visible(handle_menu_antiaim_crouch_fishing)
    menu_main.menu_antiaim_crouch_fishing_air:set_visible(handle_menu_antiaim_crouch_fishing)   

    --ANimations
    local animstabs_enabled = menu_main.menu_master_tabs:get() == 3
    local anim_tabs_1 = menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_anim_select:set_visible(anim_tabs_1)
    menu_elems.Leg_moving_anim_select:set_visible(anim_tabs_1)
    
    local anim_tabs_1_2 = menu_main.menu_master_tabs:get() == 3
    menu_elems.Pitch_on_land_check:set_visible(anim_tabs_1_2)
    local Pitch_on_land_check_enabled = menu_elems.Pitch_on_land_check:get() and menu_main.menu_master_tabs:get() == 3
    menu_elems.Pitch_on_land_delay:set_visible(Pitch_on_land_check_enabled)
    
    local anim_air_selection_1 = menu_elems.Leg_air_anim_select:get(1) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_move:set_visible(anim_air_selection_1)
    local anim_air_selection_2 = menu_elems.Leg_air_anim_select:get(2) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_stiff:set_visible(anim_air_selection_2)
    local anim_air_selection_3 = menu_elems.Leg_air_anim_select:get(3) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_fall:set_visible(anim_air_selection_3)
    local anim_air_selection_4 = menu_elems.Leg_air_anim_select:get(4) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_toe:set_visible(anim_air_selection_4)
    local anim_air_selection_5 = menu_elems.Leg_air_anim_select:get(5) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_Lean:set_visible(anim_air_selection_5)
    local anim_air_selection_6 = menu_elems.Leg_air_anim_select:get(6) and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_air_moonwalk:set_visible(anim_air_selection_6)
    
    local anim_moving_selection_1 = menu_elems.Leg_moving_anim_select:get(1)  and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_moving_move:set_visible(anim_moving_selection_1)
    local anim_moving_selection_2 = menu_elems.Leg_moving_anim_select:get(2)  and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_moving_Lean:set_visible(anim_moving_selection_2)
    local anim_moving_selection_3 = menu_elems.Leg_moving_anim_select:get(3)  and menu_main.menu_master_tabs:get() == 3
    menu_elems.Leg_moving_moonwalk:set_visible(anim_moving_selection_3)
    
    
    local mastervisuals_enabled = menu_main.menu_master_tabs:get() == 2
    menu_elems.WatermarkCheckbox:set_visible(mastervisuals_enabled)
    menu_elems.SlowedCheckbox:set_visible(mastervisuals_enabled)
    menu_elems.KeybindsCheckbox:set_visible(mastervisuals_enabled)
    menu_elems.BounceCheckbox:set_visible(mastervisuals_enabled)
    menu_elems.ScopedCheckbox:set_visible(mastervisuals_enabled)
    menu_elems.VisualsOffsetSlider:set_visible(mastervisuals_enabled)
    local masterwatermark_enabled = menu_main.menu_master_tabs:get() == 2 and menu_elems.WatermarkCheckbox:get()
    menu_elems.WatermarkStyleSelection:set_visible(masterwatermark_enabled)
    local slowed_enabled = menu_main.menu_master_tabs:get() == 2 and menu_elems.SlowedCheckbox:get()
    menu_elems.SlowedTextCheckbox:set_visible(slowed_enabled)
    menu_elems.SlowedDesyncCheckbox:set_visible(slowed_enabled)

end

-- anti-aim tab Positions
menu.set_group_column("Anti-aim Configs", 1)
menu.set_group_column("Misc Anti-Aim", 2)
menu.set_group_column("Yaw Control", 3)
-- Visuals tab Positions
menu.set_group_column("Visuals", 2)
menu.set_group_column("Indicators", 2)
menu.set_group_column("Misc Visuals", 3)
-- Animations tab Positions
menu.set_group_column("Pitch Animations", 3)
menu.set_group_column("Moving Animations", 3)
menu.set_group_column("Air Animations", 2)

--██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ███████╗
--██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██╔════╝
--██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗███████╗
--██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║╚════██║
--╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝███████║
-- ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝
                                                       
-- Helper function to serialize a table into a string
local function serialize_table(val, name)
    local tmp = ""
    if name then tmp = tmp .. name .. " = " end
    if type(val) == "table" then
        if next(val) == nil then
            tmp = tmp .. "{}"
        else
            tmp = tmp .. "{"
            for k, v in pairs(val) do
                if type(k) == "string" then
                    tmp = tmp .. k .. "=" .. serialize_table(v) .. ","
                else
                    tmp = tmp .. serialize_table(v, k) .. ","
                end
            end
            tmp = tmp .. "}"
        end
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializable datatype:".. type(val) .. "]\""
    end
    return tmp
end

-- Helper function to deserialize a string into a table
local function deserialize_table(str)
    local maxLength = 8096 -- maximum allowed length

    if #str > maxLength then
        print("(Input Error) Input string is too long")
        return nil
    end
    if not str or str == "" then
        print("(Input Error) Empty or nil input string")
        return nil
    end 
    local extra_chars = str:match("^.*}(.+)$")
    if extra_chars and extra_chars ~= "" then
        print("(Input Error) Invalid input string: contains extra characters after the closing brace '}'")
        return nil
    end

    local invalidStrings = {"_G", "os.getenv", "random", "math.randomseed", "math.random", "math.randomseed", "math", "table.save", "table.load", "table", "string.gsub", "string.dump", "string", "os.", "local", "function", "print", "loadstring", "debug", "loadfile", "os.execute", "io.", "require", "dofile", "load", "setfenv", "setmetatable", "getmetatable", "rawget", "rawset", "coroutine", "package", "get", "size", "pos.*", "find", "create", "int", "float", "string", "invoke", "callback", "save", "bool"}

    for _, invalidStr in ipairs(invalidStrings) do
        if str:find(invalidStr, 1, true) then
            print("(Crackpot Repellant) Invalid configuration string: contains the string '" .. invalidStr .. "'")
            engine.play_sound("error.wav", 0.1, 100)
            return nil
        end
    end

    str = str:gsub("//.-\n", "\n") -- remove single-line comments
    str = str:gsub("/%*.-%*/", "") -- remove multi-line comments
    str = str:gsub("[%z\1-\31\127-\255]", "") -- remove control characters
    str = str:gsub("%s+", "") -- remove whitespace
    str = str:gsub("^%s+", "") -- remove leading whitespace
    str = str:gsub("%s+$", "") -- remove trailing whitespace
    
    local f = load("return {" .. str .. "}")
    if not f then
        print("(Crash Prevention) Failed to conjure a configuration string: " .. str)
        engine.play_sound("training/puck_fail.wav", 0.1, 100)
        return nil
    end
    
    local success, result = pcall(f)
    if not success then
        print("(Crash Prevention) Failed to deconjure configuration string: " .. str)
        engine.play_sound("training/puck_fail.wav", 0.1, 100)
        return nil
    end
    
    return result
end

local vgui_sys = 'VGUI_System010'
local vgui2 = 'vgui2.dll'

local function VTableBind(mod, face, n, type)
    local iface = memory.create_interface(mod, face) or error(face .. ": invalid interface")
    local instance = memory.get_vfunc(iface, n) or error(index .. ": invalid index")
    local success, typeof = pcall(ffi.typeof, type)
    if not success then
        error(typeof, 2)
    end
    local fnptr = ffi.cast(typeof, instance) or error(type .. ": invalid typecast")
    return function(...)
        return fnptr(tonumber(ffi.cast("void***", iface)), ...)
    end
end

local native_GetClipboardTextCount = VTableBind(vgui2, vgui_sys, 7, "int(__thiscall*)(void*)")
local native_SetClipboardText = VTableBind(vgui2, vgui_sys, 9, "void(__thiscall*)(void*, const char*, int)")
local native_GetClipboardText = VTableBind(vgui2, vgui_sys, 11, "int(__thiscall*)(void*, int, const char*, int)")

-- Helper function to deserialize a string into a table
local function exportconfig_fn()
    local config = {}
    for name, element in pairs(menu_main) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end
    for name, element in pairs(menu_standing) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end

    for name, element in pairs(menu_moving) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end

    for name, element in pairs(menu_slowwalking) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end

    for name, element in pairs(menu_crouched) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end
    for name, element in pairs(menu_air) do
        if element.get ~= nil then -- check if the element has a get function
            config[name] = element:get()
        end
    end

    for i = 1, #angle_sliders do
        config["angle_slider_" .. i] = angle_sliders[i]:get()
    end

    for i = 1, #standing_sliders do
        config["standing_slider_" .. i] = standing_sliders[i]:get()
    end

    for i = 1, #moving_sliders do
        config["moving_slider_" .. i] = moving_sliders[i]:get()
    end

    for i = 1, #slowwalking_sliders do
        config["slowwalking_slider_" .. i] = slowwalking_sliders[i]:get()
    end

    for i = 1, #crouched_sliders do
        config["crouched_slider_" .. i] = crouched_sliders[i]:get()
    end

    for i = 1, #air_sliders do
        config["air_slider_" .. i] = air_sliders[i]:get()
    end

    local serialized_config = serialize_table(config)
    serialized_config = "{" .. serialized_config:sub(2, -2) .. "}"
    native_SetClipboardText(serialized_config, string.len(serialized_config))
    print("Config exported to clipboard:\n" .. serialized_config) 
    engine.play_sound("survival/bonus_award_01.wav", 0.3, 100)
end

function import_config()
    local buf_size = 8096
    local clipboard_text = ffi.new("char[?]", buf_size)
    local success = native_GetClipboardText(0, clipboard_text, buf_size)
    if not success or clipboard_text[0] == 0 then
      print("(Crash Prevention) Invalid or empty config in clipboard.")
      engine.play_sound("training/puck_fail.wav", 0.1, 100)
      return
    end
    clipboard_text = ffi.string(clipboard_text)
    if type(clipboard_text) ~= "string" then
      print("(Crash Prevention) Clipboard data is not a string.")
      engine.play_sound("training/puck_fail.wav", 0.1, 100)
      return
    end
    clipboard_text = clipboard_text:gsub("{", ""):gsub("}", "") -- remove curly braces
    if clipboard_text == "" then
      print("(Crash Prevention) Empty config in clipboard after removing curly braces.")
      engine.play_sound("training/puck_fail.wav", 0.1, 100)
      return
    end
    local config = deserialize_table(clipboard_text)
    if not config or type(config) ~= "table" then
      print("(Crash Prevention) Invalid config in clipboard, Failed to deconjure config.")
      engine.play_sound("training/puck_fail.wav", 0.1, 100)
      return
    end
    -- set the menu values based on the imported config
    local nil_config_values = {}
    for name, element in pairs(menu_main) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end
    for name, element in pairs(menu_standing) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end
    for name, element in pairs(menu_moving) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end
    for name, element in pairs(menu_slowwalking) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end
    for name, element in pairs(menu_crouched) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end
    for name, element in pairs(menu_air) do
        if element.set ~= nil and config[name] ~= nil then -- check if the element has a set function and the config has a value for this element
            element:set(config[name])
        elseif config[name] == nil then
            table.insert(nil_config_values, name)
        end
    end

-- continue with the rest of the code if there are no errors

    for i, slider in ipairs(angle_sliders) do
        local key = "angle_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    for i, slider in ipairs(standing_sliders) do
        local key = "standing_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    for i, slider in ipairs(moving_sliders) do
        local key = "moving_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    for i, slider in ipairs(slowwalking_sliders) do
        local key = "slowwalking_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    for i, slider in ipairs(crouched_sliders) do
        local key = "crouched_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    for i, slider in ipairs(air_sliders) do
        local key = "air_slider_" .. i
        if config[key] ~= nil then
            slider:set(config[key])
        else
            print("(Crash Prevention) Failed to deconjure configuration string, to many sliders present ")
        end
    end
    -- add new sliders if the imported config has more sliders than the current menu
    local i = #angle_sliders+1
    while config["angle_slider_" .. i] ~= nil do
        add_angle()
        angle_sliders[i]:set(config["angle_slider_" .. i])
        i = i + 1
    end
    local i = #standing_sliders+1
    while config["standing_slider_" .. i] ~= nil do
        add_standing()
        standing_sliders[i]:set(config["standing_slider_" .. i])
        i = i + 1
    end
    local i = #moving_sliders+1
    while config["moving_slider_" .. i] ~= nil do
        add_moving()
        moving_sliders[i]:set(config["moving_slider_" .. i])
        i = i + 1
    end
    local i = #slowwalking_sliders+1
    while config["slowwalking_slider_" .. i] ~= nil do
        add_slowwalking()
        slowwalking_sliders[i]:set(config["slowwalking_slider_" .. i])
        i = i + 1
    end
    local i = #crouched_sliders+1
    while config["crouched_slider_" .. i] ~= nil do
        add_crouched()
        crouched_sliders[i]:set(config["crouched_slider_" .. i])
        i = i + 1
    end
    local i = #air_sliders+1
    while config["air_slider_" .. i] ~= nil do
        add_air()
        air_sliders[i]:set(config["air_slider_" .. i])
        i = i + 1
    end
    if #nil_config_values > 0 then
        print("(Crash Prevention) Invalid or missing config context in clipboard, Attempted to apply all values but failed.")
        engine.play_sound("training/puck_fail.wav", 0.1, 100)
        return
    end
    print("Config imported from clipboard.")
    engine.play_sound("survival/buy_item_01.wav", 0.3, 100)
end

local importconfig = menu.add_button("Everlasting.lua", "Import Config", import_config)
local exportconfig = menu.add_button("Everlasting.lua", "Export Config", exportconfig_fn)

function configs_menu_handle()
    local configs_menu_antiaim_enabled = menu_main.menu_master_tabs:get() == 1
    exportconfig:set_visible(configs_menu_antiaim_enabled)
    importconfig:set_visible(configs_menu_antiaim_enabled)
end

--███╗   ███╗██╗███████╗ ██████╗     █████╗ ███╗   ██╗████████╗██╗       █████╗ ██╗███╗   ███╗
--████╗ ████║██║██╔════╝██╔════╝    ██╔══██╗████╗  ██║╚══██╔══╝██║      ██╔══██╗██║████╗ ████║
--██╔████╔██║██║███████╗██║         ███████║██╔██╗ ██║   ██║   ██║█████╗███████║██║██╔████╔██║
--██║╚██╔╝██║██║╚════██║██║         ██╔══██║██║╚██╗██║   ██║   ██║╚════╝██╔══██║██║██║╚██╔╝██║
--██║ ╚═╝ ██║██║███████║╚██████╗    ██║  ██║██║ ╚████║   ██║   ██║      ██║  ██║██║██║ ╚═╝ ██║
--╚═╝     ╚═╝╚═╝╚══════╝ ╚═════╝    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝      ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝


local last_jitter_time_desync = 0
local fake_value = 1

function do_fakedesync_time(ctx)
    if not engine.is_connected() or not engine.is_in_game() then 
        return 
    end
    
    if not menu_main.menu_antiaim_fake_desync:get() then 
        return 
    end
    
    local speed_scale = 1 / math.max(menu_main.menu_antiaim_fake_desync_speed:get(), 1)
    local jitter_tick_interval = 1 + math.floor(speed_scale * 50)
    local real_time = globals.real_time() or 0
    local ticks_elapsed = math.floor((real_time - (last_jitter_time_desync or 0)) / globals.interval_per_tick())

    if ticks_elapsed < jitter_tick_interval then 
        return 
    end

    last_jitter_time_desync = real_time
    fake_value = fake_value == 1 and 2 or 1
    
    ctx:set_fakelag(fake_value == 1)
    ctx:set_fakelag(fake_value == 2)
end


local prevSimulationTime = 0
local simulationTimeDiff = 0

local function getSimulationTimeDiff()
    if not engine.is_connected() or not engine.is_in_game() then return end

    local localPlayer = entity_list.get_local_player()
    if not localPlayer then
        return 0
    end

    local currentSimulationTime = localPlayer:get_prop("m_flSimulationTime")
    if not currentSimulationTime then
        return 0
    end

    local diff = currentSimulationTime - (prevSimulationTime + 0.75)
    prevSimulationTime = currentSimulationTime
    simulationTimeDiff = diff
    return simulationTimeDiff
end

local function defensive_pitch(ctx)
    if not engine.is_connected() or not engine.is_in_game() then return end

    local keyToggledA = input.is_key_held(e_keys.KEY_A)
    local keyToggledD = input.is_key_held(e_keys.KEY_D)

    if not menu_main.menu_antiaim_fishing:get() then
        return
    end

    if math.floor(globals.cur_time() * 26) % 16 ~= 0 or engine.get_choked_commands() >= 2 or getSimulationTimeDiff() == -0.75 then
        return
    end

    ctx:set_pitch(-89)

end

local keybindextenedroll = menu_main.menu_antiaim_extended_roll:add_keybind("Extended roll bind")

function roll_menu_handle()

    local masterppresetson = menu_main.menu_master_tabs:get() == 1 and menu_main.menu_antiaim_extended_roll:get()
    keybindextenedroll:set_visible(masterppresetson)

end

-- Find menu elements
local roll_drop = menu.find("antiaim", "main", "angles", "Body lean")
local roll_add = menu.find("antiaim", "main", "angles", "Body lean Value")

-- Variables
local last_duck_time = 0

-- Function to execute extended roll
function do_extended_roll(cmd)
    if not engine.is_connected() or not engine.is_in_game() then return end
    -- Check if extended roll is enabled
    if not keybindextenedroll:get() or not menu_main.menu_antiaim_extended_roll:get() then
        return
    end

    -- Set view angles and roll add value
    local side = menu_main.menu_antiaim_extended_roll_amount:get()
    cmd.viewangles.z = side
    roll_add:set(-side * 0.6)

    -- Set roll drop value
    roll_drop:set(2)
end

local last_ground_time = 0 -- add a new variable to store the last time the player was on the ground

function on_crouch_fishing(cmd)
    if not engine.is_connected() or not engine.is_in_game() then return end

    local current_time = globals.real_time()
    local interval = globals.interval_per_tick()
    local tick_count = global_vars.tick_count()
    local lp = entity_list.get_local_player()
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0
    local crouch_key = input.find_key_bound_to_binding("duck")
    local key_toggled = input.is_key_held(crouch_key)

    if menu_main.menu_antiaim_crouch_fishing:get() and not key_toggled then
        -- Check if air ducking is enabled and if the player is on the ground
        if menu_main.menu_antiaim_crouch_fishing_air:get() or not in_air then
            -- Check if the player has been on the ground for at least 1 second
            if in_air then
                last_ground_time = 0
            else
                if last_ground_time == 0 then
                    last_ground_time = current_time
                end
                if (current_time - last_ground_time) >= 1 then -- 1 second has passed since the player was last on the ground
                    if (current_time - last_duck_time) > (menu_main.menu_antiaim_crouch_fishing_speed:get() * interval) then
                        cmd:add_button(e_cmd_buttons.DUCK)
                        last_duck_time = current_time
                    else
                        cmd:remove_button(e_cmd_buttons.DUCK)
                    end
                else
                    cmd:remove_button(e_cmd_buttons.DUCK) -- the player hasn't been on the ground for 1 second yet, so don't crouch
                end
            end
        end
    end
end

local keybindteleport = menu_main.menu_antiaim_misc_teleport:add_keybind("Teleport Bind")

function teleport_menu_handle()

    local masterteleport = menu_main.menu_master_tabs:get() == 1
    keybindteleport:set_visible(masterteleport)

end
function do_teleport(ctx)
    if not engine.is_connected() or not engine.is_in_game() then return end

    if keybindteleport:get() and menu_main.menu_antiaim_misc_teleport:get() then
        exploits.force_uncharge()
        exploits.force_recharge()
        exploits.allow_recharge()
    end
end

 --█████╗ ███╗   ██╗██╗███╗   ███╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗███████╗
--██╔══██╗████╗  ██║██║████╗ ████║██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║██╔════╝
--███████║██╔██╗ ██║██║██╔████╔██║███████║   ██║   ██║██║   ██║██╔██╗ ██║███████╗
--██╔══██║██║╚██╗██║██║██║╚██╔╝██║██╔══██║   ██║   ██║██║   ██║██║╚██╗██║╚════██║
--██║  ██║██║ ╚████║██║██║ ╚═╝ ██║██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║███████║
--╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝

local onground = 1
local endoftime = 0

function do_animations(ctx)
    if not engine.is_connected() or not engine.is_in_game() then return end
    
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0
    local local_player = entity_list.get_local_player()
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local currtime = global_vars.real_time()

    if menu_elems.Pitch_on_land_check:get() then
        if on_land == true then
            onground = onground + 1
        else
            onground = 0
            endoftime = currtime + menu_elems.Pitch_on_land_delay:get() * 0.05
        end

        if onground > 1 and endoftime > currtime then
            ctx:set_render_pose(e_poses.BODY_PITCH, 0.48)
        end
    end

    -- air
        if in_air then
            if menu_elems.Leg_air_anim_select:get(1) then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, menu_elems.Leg_air_move:get())
                ctx:set_render_pose(e_poses.MOVE_BLEND_RUN, menu_elems.Leg_air_move:get())
            end

            if menu_elems.Leg_air_anim_select:get(2) then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_LAND_OR_CLIMB, menu_elems.Leg_air_stiff:get())
            end

            if menu_elems.Leg_air_anim_select:get(3) then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_JUMP_OR_FALL, menu_elems.Leg_air_fall:get())
            end

            if menu_elems.Leg_air_anim_select:get(4) then
                ctx:set_render_pose(e_poses.JUMP_FALL, menu_elems.Leg_air_toe:get())
            end

            if menu_elems.Leg_air_anim_select:get(5) then
                ctx:set_render_animlayer(e_animlayers.LEAN, menu_elems.Leg_air_Lean:get())
            end
            if menu_elems.Leg_air_anim_select:get(6) then
                ctx:set_render_pose(e_poses.MOVE_YAW, menu_elems.Leg_air_moonwalk:get())
            end
        end

        if not in_air and velocity > 70 then
            if menu_elems.Leg_moving_anim_select:get(1) then
                ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, menu_elems.Leg_moving_move:get())
                ctx:set_render_pose(e_poses.MOVE_BLEND_RUN, menu_elems.Leg_moving_move:get())
            end
            if menu_elems.Leg_moving_anim_select:get(2) then
                ctx:set_render_animlayer(e_animlayers.LEAN, menu_elems.Leg_moving_Lean:get())
            end
            if menu_elems.Leg_moving_anim_select:get(3) then
                ctx:set_render_pose(e_poses.MOVE_YAW, menu_elems.Leg_moving_moonwalk:get())
            end
        end
    end


--██╗   ██╗██╗███████╗██╗   ██╗ █████╗ ██╗     ███████╗
--██║   ██║██║██╔════╝██║   ██║██╔══██╗██║     ██╔════╝
--██║   ██║██║███████╗██║   ██║███████║██║     ███████╗
--╚██╗ ██╔╝██║╚════██║██║   ██║██╔══██║██║     ╚════██║
-- ╚████╔╝ ██║███████║╚██████╔╝██║  ██║███████╗███████║
--  ╚═══╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝

    local displacement_values = {
        {x = 2, y = 2},
        {x = -2, y = -2},
        {x = -2, y = 2},
        {x = 2, y = -2},
    }
    
    local displacement_interval = 0.01
    local displacement_duration = 0.15
    local max_displacement_count = 25
    local text_x, text_y, rect_x, rect_y, displacement_count, displacement_index = 0, 0, 0, 0, 0, 1
    local bounce_end_time, displacement_timer = 0, 0
    arial2 = render.create_font("Trebuchet MS", 15, 8000, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
    default_font = render.create_font("Trebuchet MS", 10, 8000, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

    
    local function on_aimbot_hit(hit)
        displacement_count = 0
        displacement_timer = globals.cur_time() + displacement_interval
        bounce_end_time = globals.cur_time() + displacement_duration
    end
    
    local function lerp(start_value, end_value, percent)
        return start_value * (1 - percent) + end_value * percent
    end

    local function lerp_color(c1, c2, t)
        -- Linearly interpolate each color component separately
        local r = math.floor(lerp(c1.r, c2.r, t))
        local g = math.floor(lerp(c1.g, c2.g, t))
        local b = math.floor(lerp(c1.b, c2.b, t))
        local a = math.floor(lerp(c1.a, c2.a, t))
        return color_t(r, g, b, a)
    end

    local target_y_values = {}
    local current_y_values = {}
    
    local function Lerp_binds(current, target, speed)
        return current + (target - current) * speed
    end

local indicators_list = {
    {name = "Extended", bind = menu.find("antiaim","main","extended angles","enable")[2]},
    {name = "Slow Walk", bind = menu.find("misc", "main", "movement", "Slow Walk", "enabled")[2]},
    {name = "Doubletap", bind = menu.find("aimbot","general","exploits","Doubletap","enable")[2]},
    {name = "Auto Peek", bind = menu.find("aimbot","general","misc","autopeek","enabled")[2]},
    {name = "Hide Shots", bind = menu.find("aimbot","general","exploits","hideshots","enable")[2]},
    {name = "Anti Exploit", bind = menu.find("aimbot","general","exploits","force prediction","enabled")[2]},
    {name = "Auto Direction", bind = menu.find("antiaim","main","auto direction","enable")[2]},
    {name = "Fake Ducking", bind = menu.find("antiaim","main","general","fakeduck")[2]},
    {name = "Lean Resolver", bind = menu.find("aimbot","general","aimbot","body lean resolver","enable")[2]}
}

    
    function is_bind_active(bind)
        if bind ~= nil then
            return bind:get()
        else
            return false
        end
    end
    
    -------out
    local initial_value = 0
    local value_we_want_to_lerp_to = 40
    --------in
    local value_we_want_to_lerp_to2 = 0

    -- watermark
    local watermarkcolor = menu_elems.WatermarkCheckbox:add_color_picker("watermark", color_t(243, 178, 255, 200))
    local watermarkcolortwo = menu_elems.WatermarkCheckbox:add_color_picker("watermark2",  color_t(255, 255, 255, 250))

    -- slow indicator
    local slow_desync_text = menu_elems.SlowedTextCheckbox:add_color_picker("textcolor", color_t(255, 255, 255, 200))
    local slowbaroutline = menu_elems.SlowedCheckbox:add_color_picker("inside",  color_t(243, 178, 255, 200))
    local slowbarbackground = menu_elems.SlowedCheckbox:add_color_picker("background",  color_t(80, 80, 80, 100))

    --keybinds
    local keybindcolor = menu_elems.KeybindsCheckbox:add_color_picker("keybindscolor",  color_t(255, 255, 255, 200))
   


    function visuals()
        if not engine.is_connected() or not engine.is_in_game() then return end
        local screen_size = render.get_screen_size()
        local text = "Everlasting"
        local text_size = render.get_text_size(arial2, text)
        local letter_spacing = text_size.x / #text
        local x = screen_size.x / 2 - text_size.x / 2 + text_x
        local y = screen_size.y / 2 - text_size.y / 2 + text_y  + 10 
        local colors = {
            watermarkcolor:get(), -- pink
            watermarkcolortwo:get(), -- white pink
        }
        local color_index = 1 
        local local_player = entity_list.get_local_player()
        local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
        if weapon == nil then return end
        local scoped = local_player:get_prop("m_bIsScoped")
        local weapon_name = weapon:get_name()
        local customheight = menu_elems.VisualsOffsetSlider:get()

        local target_value = scoped == 1 and value_we_want_to_lerp_to or weapon_name == "decoy" and value_we_want_to_lerp_to or weapon_name == "hegrenade" and value_we_want_to_lerp_to or weapon_name == "molotov" and value_we_want_to_lerp_to or weapon_name == "incgrenade" and value_we_want_to_lerp_to or weapon_name == "smokegrenade" and value_we_want_to_lerp_to or weapon_name == "flashbang" and value_we_want_to_lerp_to or value_we_want_to_lerp_to2
        local diff = math.abs(initial_value - target_value)
        local lerp_percent = diff < 1 and 1 or 0.05
        if menu_elems.ScopedCheckbox:get() then
        initial_value = lerp(initial_value, target_value, lerp_percent)
        else
        initial_value = 0
        end

        if menu_elems.WatermarkCheckbox:get() then
    
        if menu_elems.WatermarkStyleSelection:get() == 1 then
            for i = 1, #text do
                local letter_size = render.get_text_size(arial2, text:sub(i, i))
                local letter_x = x + (i - 1) * letter_spacing + letter_size.x / 2
                local time = globals.real_time()
                local color_percent = (math.sin(time * 4) + 1) / 2 -- wave between 0 and 1
                local color = lerp_color(colors[color_index], colors[color_index % #colors + 1], color_percent)
                render.text(arial2, text:sub(i, i), vec2_t(letter_x - letter_size.x / 2 + initial_value + 4, y + 15 + customheight), color, true)
                color_index = color_index % #colors + 1 -- cycle through colors
            end
        end

        if menu_elems.WatermarkStyleSelection:get() == 2 then
            for i = 1, #text do
                local letter_size = render.get_text_size(arial2, text:sub(i, i))
                local letter_x = x + (i - 1) * letter_spacing + letter_size.x / 2
                local color_index = math.floor((globals.cur_time() * 4 + i*0.5) % #colors) + 1
                local color = colors[color_index]
                render.text(arial2, text:sub(i, i), vec2_t(letter_x - letter_size.x / 2 + initial_value + 4 , y + 15 + customheight), color, true)
            end
        end

        if menu_elems.WatermarkStyleSelection:get() == 3 then
            local color_start = colors[1]
            local color_end = colors[2]
            
            for i = 1, #text do
                local letter_size = render.get_text_size(arial2, text:sub(i, i))
                local letter_x = x + (i - 1) * letter_spacing + letter_size.x / 2
                local progress = (math.sin(globals.cur_time() * 4 + i*0.5) + 1) / 2
                local color_value = lerp_color(colors[1], colors[2], progress)
                render.text(arial2, text:sub(i, i), vec2_t(letter_x - letter_size.x / 2 + initial_value + 4, y + 15 + customheight), color_value, true)
            end
        end

        if menu_elems.WatermarkStyleSelection:get() == 4 then
            for i = 1, #text do
                local letter_size = render.get_text_size(arial2, text:sub(i, i))
                local letter_x = x + (i - 1) * letter_spacing + letter_size.x / 2
                local alpha_value = math.floor(lerp(250, 100, (math.sin(globals.cur_time() * 4 + i*0.5) + 1) / 2))
                render.text(arial2, text:sub(i, i), vec2_t(letter_x - letter_size.x / 2 + initial_value + 4, y + 15 + customheight), color_t(watermarkcolor:get()[1], watermarkcolor:get()[2], watermarkcolor:get()[3], alpha_value), true)
            end
        end
        if menu_elems.BounceCheckbox:get() then
            if globals.cur_time() < bounce_end_time and displacement_count < max_displacement_count then
                if globals.cur_time() > displacement_timer then
                    displacement_index = displacement_index + 1
                    if displacement_index > #displacement_values then
                        displacement_index = 1
                    end
                    text_x, text_y = displacement_values[displacement_index].x, displacement_values[displacement_index].y
                    rect_x, rect_y = displacement_values[displacement_index].x, displacement_values[displacement_index].y
                    displacement_timer = globals.cur_time() + displacement_interval
                    displacement_count = displacement_count + 1
                end
            else
                text_x, text_y = 0, 0
                rect_x, rect_y = 0, 0
            end
        end
    else
        text_x, text_y = 0, 0
        rect_x, rect_y = 0, 0
    end
        local max_desync_range = antiaim.get_max_desync_range()
        local modifier = local_player:get_prop("m_flVelocityModifier")
        local text_offset = 0 -- initialize the text offset to 0

        if modifier ~= 1 and menu_elems.SlowedCheckbox:get() then
            local width_mod = 65 * (1 - modifier) -- calculate the width of the bar based on the player's speed
            local width = 65
            local height = 6

            local rect_x = screen_size.x / 2 - width / 2 -- calculate the x position of the rectangle based on the bar's width
            local rect_y = screen_size.y / 2 - height / 2 -- set the y position of the rectangle to the center of the screen
    
            render.rect_filled(vec2_t(rect_x + initial_value, rect_y + 26 + customheight), vec2_t(width, height), slowbarbackground:get(), 50) -- draw the rectangle filled static
            render.rect_filled(vec2_t(screen_size.x / 2 - width_mod / 2 + initial_value, rect_y + 26 + customheight), vec2_t(width_mod, height), slowbaroutline:get(), 50) -- draw the rectangle filled
            render.rect(vec2_t(rect_x + initial_value, rect_y + 26 + customheight), vec2_t(width, height), slowbaroutline:get(), 15) -- draw the rectangle
            text_offset = text_offset + 8
            if menu_elems.SlowedTextCheckbox:get() then
            render.text(default_font, "Slowed", vec2_t(x + 40 + initial_value, y + 33 + customheight), slow_desync_text:get(), true) -- draw the text with some padding below the bar
            text_offset = text_offset + 9 -- increase text offset by 15 if slowed text is displayed
            end
            rect_x = rect_x - modifier * 10 -- update the x position of the rectangle based on the player's speed
        
        else if menu_elems.SlowedDesyncCheckbox:get() and menu_elems.SlowedCheckbox:get() then
            local width_mod = 65 * max_desync_range*0.015 -- calculate the width of the bar based on the player's speed
            local width = 65
            local height = 6

            local rect_x = screen_size.x / 2 - width / 2 -- calculate the x position of the rectangle based on the bar's width
            local rect_y = screen_size.y / 2 - height / 2 -- set the y position of the rectangle to the center of the screen
    
            render.rect_filled(vec2_t(rect_x + initial_value, rect_y + 26 + customheight), vec2_t(width, height), slowbarbackground:get(), 50) -- draw the rectangle filled static
            render.rect_filled(vec2_t(screen_size.x / 2 - width_mod / 2 + initial_value, rect_y + 26 + customheight), vec2_t(width_mod, height), slowbaroutline:get(), 50) -- draw the rectangle filled
            render.rect(vec2_t(rect_x + initial_value, rect_y + 26 + customheight), vec2_t(width, height), slowbaroutline:get(), 15) -- draw the rectangle
            text_offset = text_offset + 8
            if menu_elems.SlowedTextCheckbox:get() then
            render.text(default_font, "Desync", vec2_t(x + 40 + initial_value, y + 33 + customheight), slow_desync_text:get(), true) -- draw the text with some padding below the bar
            text_offset = text_offset + 9 -- increase text offset by 15 if slowed text is displayed
            end
        end
    end

    local num_of_indicators = 0
    if menu_elems.KeybindsCheckbox:get() then
        for _, indicator in ipairs(indicators_list) do
            local target_y = y + 26 + num_of_indicators * 10 + text_offset + customheight
            if is_bind_active(indicator.bind) then
                if not target_y_values[indicator.name] then
                    target_y_values[indicator.name] = target_y
                    current_y_values[indicator.name] = target_y
                else
                    target_y_values[indicator.name] = target_y
                end
                num_of_indicators = num_of_indicators + 1
            else
                target_y_values[indicator.name] = nil
                current_y_values[indicator.name] = nil
            end
        end
        local lerp_speed = 0.25
        for indicator_name, target_y in pairs(target_y_values) do
            current_y_values[indicator_name] = Lerp_binds(current_y_values[indicator_name], target_y, lerp_speed)
            render.text(default_font, indicator_name, vec2_t(x + 40 + initial_value, current_y_values[indicator_name]), keybindcolor:get(), true)
        end
    end
end


callbacks.add(e_callbacks.PAINT, visuals)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.PAINT, handle_menu)
callbacks.add(e_callbacks.PAINT, configs_menu_handle)
callbacks.add(e_callbacks.ANTIAIM, jitter_yaw_global)
callbacks.add(e_callbacks.ANTIAIM, jitter_standing)
callbacks.add(e_callbacks.ANTIAIM, jitter_moving)
callbacks.add(e_callbacks.ANTIAIM, jitter_slowwalking)
callbacks.add(e_callbacks.ANTIAIM, jitter_crouched)
callbacks.add(e_callbacks.ANTIAIM, jitter_air)
callbacks.add(e_callbacks.SETUP_COMMAND, on_crouch_fishing)
callbacks.add(e_callbacks.SETUP_COMMAND, do_extended_roll)
callbacks.add(e_callbacks.ANTIAIM, do_fakedesync_time)
callbacks.add(e_callbacks.ANTIAIM, do_animations)
callbacks.add(e_callbacks.ANTIAIM, defensive_pitch)
callbacks.add(e_callbacks.ANTIAIM, do_jitter_tick)
callbacks.add(e_callbacks.ANTIAIM, do_jitter_time)
callbacks.add(e_callbacks.ANTIAIM, do_teleport)
callbacks.add(e_callbacks.PAINT, teleport_menu_handle)
callbacks.add(e_callbacks.PAINT, roll_menu_handle)