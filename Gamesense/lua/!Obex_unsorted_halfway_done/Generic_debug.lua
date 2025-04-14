-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local client_exec, client_set_event_callback, client_trace_line, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, ui_get, ui_new_checkbox, ui_new_multiselect, ipairs = client.exec, client.set_event_callback, client.trace_line, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, ui_get, ui.new_checkbox, ui.new_multiselect, ipairs

--[[
    generic.lua v3
    credits: Zack, Nulled, Ivan, Kez
]]

-- Imports
local images = require("gamesense/images")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local vector = require "vector"
local csgo_weapons = require "gamesense/csgo_weapons"

-- temp vars (remove when pushing)
--local username = "dev"
--local uid = "poontang slayer"

local obex_data = obex_fetch and obex_fetch() or {username = 'Zack', build = 'Beta', discord=''}


-- set last updated date.
local last_update = "November 24th, 2021"

local update_log = [[
    + Updated Shuffle Preset
    + Added Min Dmg indicator
    + Added Force "Defensive" (Allows you to always force defensive DT (wouldn't recommend))
    + Added LC (Lag Comp) indicator whenever exploit is active
    ~ Reworked Ideal Tick
    + Added "Simple Crosshair" indicators
    ~ Reworked AA activating whenever plays don't return nil
]]

-- are we on beta build?
--local beta = true
--local build = "developer"

local alpha = 0

local globals_realtime = globals.realtime
local ind_side = "none"
local manual_mode = "back"
local lp = entity.get_local_player()
local get = ui.get
local set = ui.set
local ui_reference = ui.reference
local entity_is_alive = entity.is_alive
local entity_get_origin = entity.get_origin
local math_min = math.min
local math_max = math.max
local entity_get_prop = entity.get_prop
local math_random = math.random
local globals_tickcount = globals.tickcount
local last_break_time = globals_realtime()
local curtime = globals.curtime()
local a = false

local function table_insert(table, val)
    table[#table + 1] = val
end

local table_remove = table.remove
local shift_ticks = 0
local ticks_while_shifting = 0
local hs_percent = 0
local hs_percent1 = 0
local ground_time = 0
local break_distance = 0
local last_shot_time = globals_tickcount()
local antibrute_shots = 0
local best_target = nil
local is_in_use = false
local is_antibrute = false
local jitter_side = false
local micromovemnt_switch = false
local shot_angle = false
local right_ready = true
local left_ready = true
local networked_side = false
local strafe_side = false
local dragging = false
local drag_xy = {0, 0}

local tags = {" ", "g", "ge", "gen", "gene", "gener", "generi", "generic", "generic.", "generic.l", "generic.lu", "generic.lua", "generic.lu", "generic.l", "generic.", "generic", "generi", "gener", "gene", "gen", "ge", "g", " "}
local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local last_origin = {0, 0, 0}
local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2}

local player_data = {}

local logs_data = {text = {}, cur_offset = {}, alpha = {}, time = {}}
local fire_logs = {id = {}, pred_hc = {}, pred_hb = {}, pred_dmg = {}}
local white = {255, 255, 255, 255}

for i = 1, 72 do
    table_insert(player_data, {
        index = i,
        side =  {yaw = 0, yaw_jitter = {"Off",  0}, body_yaw = {"Static", 0, nil}, fake_yaw = 58, },
        shot_at = nil,
        shots = 0,
        last_shot_time = 0,
        last_side = nil,
    })
end

--references
local ref = {
    thirdperson = {ui_reference("Visuals", "Effects", "Force third person (alive)")},
    aa_enable = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    pitch = ui_reference("AA", "Anti-aimbot angles", "Pitch"),
    yaw_base = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    yaw = {ui_reference("AA", "Anti-aimbot angles", "Yaw")},
    yaw_jitter = {ui_reference("AA", "Anti-aimbot angles", "Yaw jitter")},
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")},
    freestanding_body_yaw = ui_reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
    fake_yaw_limit = ui_reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
    edge_yaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    freestanding = {ui_reference("AA", "Anti-aimbot angles", "Freestanding")},
    doubletap = {ui_reference("RAGE", "Other", "Double tap")},
    onshot = {ui_reference("AA", "Other", "On shot anti-aim")},
    doubletap = {ui_reference("RAGE", "Other", "Double tap")},
    fakeduck = ui_reference("RAGE", "Other", "Duck peek assist"),
    quickpeek = {ui_reference("RAGE", "Other", "Quick peek assist")},
    fakelag_limit = ui_reference("AA", "Fake lag", "Limit"),
    reload_all = ui_reference("config", "Lua", "Reload active scripts"),
    leg_movement = ui_reference("AA", "Other", "Leg movement"),
    sv_maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    dt_fl = ui_reference("Rage", "Other", "Double tap fake lag limit"),
    min_dmg = ui_reference("RAGE", "Aimbot", "Minimum damage")
}

--elements
local generic_pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch\ngeneric", {"Off", "Default", "Up", "Down", "Minimal", "Random"})
local generic_yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw base\ngeneric", {"Local view", "At targets"})
local generic_yaw_mode = ui.new_combobox("AA", "Anti-aimbot angles", "Yaw\ngeneric", {"Off", "180", "Spin", "Static", "180 Z", "Crosshair"})
local generic_manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual left")
local generic_manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual right")
local generic_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "Presets", {"Defensive", "Shuffle", "ShigeYaw", "Gypsy Hata", "Towel Head", "Sply Tard"})
local generic_exploit_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Defensive Exploit")
local generic_exploit_settings = ui.new_multiselect("AA", "Anti-aimbot angles", "Lag Comp Settings", "In Air", "On Hotkey", "Moving", "Always On")
local generic_exploit_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Exploit hotkey")
local sep_1 = ui.new_label("AA", "Anti-aimbot angles", "=======================")

local generic_custom_byaw = ui.new_combobox("AA", "Anti-aimbot angles", "[Custom] Body Yaw\ngeneric", {"Opposite", "Static", "Jitter"})
local generic_custom_body = ui.new_slider("AA", "Anti-aimbot angles", "[Custom] Body Yaw Slider", -180, 180, 0, true, "°" )
local generic_custom_byaw_value = ui.new_slider("AA", "Anti-aimbot angles", "[Custom] Fake yaw", 1, 60, 30, true, "°", 1)
local generic_custom_match_body = ui.new_checkbox("AA", "Anti-aimbot angles", "[Custom] Fake Match Body")
local generic_custom_brute_match_body = ui.new_checkbox("AA", "Anti-aimbot angles", "[Custom] Anti-brute Match Body")
local generic_random_byaw = ui.new_checkbox("AA", "Anti-aimbot angles", "[Custom] Body Yaw randomization")
local generic_random_min = ui.new_slider("AA", "Anti-aimbot angles", "[Custom] Body Yaw Minimum", 1, 60, 30, true, "°", 1)
local generic_random_max = ui.new_slider("AA", "Anti-aimbot angles", "[Custom] Body Yaw Maximum", 1, 60, 30, true, "°", 1)
local generic_anti_brute_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "[Custom] Anti Brute Enabled")
local generic_antibrute_range = ui.new_slider("AA", "Anti-aimbot angles", "Anti-brute range", 10, 100, 50, true, "%", 1, {[10] = "Low N Slow", [50] = "Default"})
local generic_peek_real_fake_check = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable Peek Real and Fake")
local generic_peek_fake = ui.new_combobox("AA", "Anti-aimbot angles", "Peeking Types", {"Fake", "Real"})
local placbo_resolver = ui.new_checkbox("AA", "Anti-Aimbot angles", "Generic Solver!! SOLVE DEM ANGLES")


local sep_2 = ui.new_label("AA", "Anti-aimbot angles", "=======================")

local generic_legit_aa_enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Legit aa on E")
local generic_legit_aa = ui.new_combobox("AA", "Anti-aimbot angles", "Legit aa options", "Default", "Jitter", "Low Delta")
local generic_leg_breaker = ui.new_checkbox("AA", "Anti-aimbot angles", "Leg Breaker")
local generic_smart_peek = ui.new_hotkey("AA", "Anti-aimbot angles", "Generic Smart Peek \n generic")
local generic_freestanding_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Freestanding \n generic")
local generic_edge_yaw_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge yaw \n generic")
local generic_clantag = ui.new_checkbox("AA", "Other", "Clantag")
local generic_console_clear = ui.new_checkbox("AA", "Other", "Round-End Console Clear")
local generic_indicators = ui.new_checkbox("AA", "Other", "Generic Visuals")
local indicator_modes = ui.new_multiselect("AA", "Other", "Options", {"Spectators", "Watermark", "Crosshair", "Simple Crosshair", "State Panel", "Logs", "AA Lines", "Manual Arrows"})
local aa_line_modes = ui.new_multiselect("AA", "Other", "AA Line Options", {"REAL", "FAKE", "ABS"})
local real_color_label = ui.new_label("AA", "Other", "Real Color")
local real_color = ui.new_color_picker("AA", "Other", "Real color picker", 255, 0, 0, 255)
local fake_color_label = ui.new_label("AA", "Other", "Fake Color")
local fake_color = ui.new_color_picker("AA", "Other", "Fake color picker", 0, 255, 0, 255)
local abs_color_label = ui.new_label("AA", "Other", "Abs Color")
local abs_color = ui.new_color_picker("AA", "Other", "Abs color picker", 0, 0, 255, 255)
local indicators_label = ui.new_label("AA", "Other", "Theme Color")
local indicators_color = ui.new_color_picker("AA", "Other", "Theme color picker", 220, 220, 255, 255)
local indicators_rainbow = ui.new_checkbox("AA", "Other", "Rainbow")
local logs_bold = ui.new_checkbox("AA", "Other", "Bold Logs")

local spectators_x = ui.new_slider("AA", "Other", "spectator (x pos)", -100, 5000, 10)
local spectators_y = ui.new_slider("AA", "Other", "spectator (y pos)", -100, 5000, center[2])

local theme_color = {ui.get(indicators_color)}

local function includes(table, key)
    if table == nil then
        return false, i
    end

    for i = 1, #table do
        if table[i] == key then
            return true, i
        end
    end

    return false, nil
end

local function multicolor_console(...)
    local texts = {...}
    for i=1, #texts do
        local text = texts[i]
        client.color_log(text[1], text[2], text[3], i ~= #texts and (text[4] .. "\0") or text[4])
    end
end

client.exec("clear")
--[[]]
multicolor_console(
    {white[1], white[2], white[3], "[ "},
    {theme_color[1], theme_color[2], theme_color[3], "generic"},
    {white[1], white[2], white[3], " ] "},
    {theme_color[1], theme_color[2], theme_color[3], "Successfully"},
    {white[1], white[2], white[3], " Loaded: (user: "},
    {theme_color[1], theme_color[2], theme_color[3], obex_data.username},
    {white[1], white[2], white[3], ", uid: "},
    {theme_color[1], theme_color[2], theme_color[3], obex_data.build},
    {white[1], white[2], white[3], ", build: "},
    {theme_color[1], theme_color[2], theme_color[3], beta and "beta" or "live"},
    {white[1], white[2], white[3], ")"}
)

multicolor_console(
    {white[1], white[2], white[3], "[ "},
    {theme_color[1], theme_color[2], theme_color[3], "generic"},
    {white[1], white[2], white[3], " ] "},
    {theme_color[1], theme_color[2], theme_color[3], "Last"},
    {white[1], white[2], white[3], " Updated: "},
    {theme_color[1], theme_color[2], theme_color[3], last_update}
)

multicolor_console(
    {white[1], white[2], white[3], "[ "},
    {theme_color[1], theme_color[2], theme_color[3], "generic"},
    {white[1], white[2], white[3], " ] "},
    {theme_color[1], theme_color[2], theme_color[3], "Join"},
    {white[1], white[2], white[3], " the discord for "},
    {theme_color[1], theme_color[2], theme_color[3], "updates: "},
    {theme_color[1], theme_color[2], theme_color[3], "https://discord.gg/7X8D3zCq89"}
)

multicolor_console(
    {white[1], white[2], white[3], "[ "},
    {theme_color[1], theme_color[2], theme_color[3], "generic"},
    {white[1], white[2], white[3], " ] "},
    {theme_color[1], theme_color[2], theme_color[3], "Update"},
    {white[1], white[2], white[3], " Log: \n"},
    {theme_color[1], theme_color[2], theme_color[3], update_log}
)

local function create_log(time, ...) --Used for the logging system
    table_insert(logs_data.text, {...})
    table_insert(logs_data.cur_offset, 0)
    table_insert(logs_data.alpha, 0)
    table_insert(logs_data.time, globals.realtime() + time)
end

--Removes data 
local function remove_shot_data(id)
    for i=1, #fire_logs.id do 
        if fire_logs.id[i] == id then
            table_remove(fire_logs.pred_hc, i)
            table_remove(fire_logs.pred_hb, i)
            table_remove(fire_logs.pred_dmg, i)
            table_remove(fire_logs.id, i)
        end
    end
end

local function set_visible(state, ...)
    local objects = {...}

    for i = 1, #objects do
        ui.set_visible(objects[i], state)
    end
end

local function clamp(min, max, current)
    if min < max then
        return math_min(max, math_max(min, current))
    else
        return math_min(min, math_max(max, current))
    end
end

local function mouse_within(x, y, w, h)
    local mx, my = ui.mouse_position()
    if mx > x and mx < x + w and my > y and my < y + h then
        return client.key_state(0x01)
    end
    return false
end

local function get_velocity(index)
    local raw_speed = {entity_get_prop(index, "m_vecVelocity")}
    return math.floor(math.sqrt(raw_speed[1]^2 + raw_speed[2]^2) + 0.5)
end

local function lerp(one, two, percent) 
	local return_results = {}
	for i=1, #one do
		return_results[i] = one[i] + (two[i] - one[i]) * percent
	end
	return return_results
end

local function distance2d(from, to)
    local delta = {from[1] - to[1], from[2] - to[2], from[3] - to[3]}
    return math.sqrt(delta[1] * delta[1] + delta[2] * delta[2])
end

local function distance3d(from, to)
    local delta = {from[1] - to[1], from[2] - to[2], from[3] - to[3]}
    return math.sqrt(delta[1] * delta[1] + delta[2] * delta[2] + delta[3] * delta[3])
end

local function vec3_angles(source, destination)
    local vec3_delta = {
        source[1] - destination[1],
        source[2] - destination[2],
        source[3] - destination[3],
    }

    local distances = math.sqrt(vec3_delta[1] * vec3_delta[1] + vec3_delta[2] * vec3_delta[2])

    local angle_pitch = math.atan(vec3_delta[2]/distances) * (180/math.pi)
    local angle_yaw = math.atan(vec3_delta[2]/vec3_delta[1]) * (180/math.pi)

    if vec3_delta[1] > 0 then
        angle_yaw = angle_yaw + 180
    end

    return {angle_pitch, angle_yaw}
end

local function vec3_normalize(vec1)
	local len = math.sqrt(vec1[1] * vec1[1] + vec1[2] * vec1[2] + vec1[3] * vec1[3])
	if len == 0 then
		return 0, 0, 0
	end
	local r = 1 / len
	return {vec1[1]*r, vec1[2]*r, vec1[3]*r}
end

local function vec3_dot(vec1, vec2)
	return vec1[1]*vec2[1] + vec1[2]*vec2[2] + vec1[3]*vec2[3]
end

local function normalize_yaw(yaw) 
    yaw = (yaw % 360 + 360) % 360
    return yaw > 180 and yaw - 360 or yaw
end

local function angle_to_vec(angle)
	local p, y = math.rad(angle[1]), math.rad(angle[2])
	local sp, cp, sy, cy = math.sin(p), math.cos(p), math.sin(y), math.cos(y)
	return {cp*cy, cp*sy, -sp}
end

local function get_fov(start_origin, end_origin, angle)
    local origin = angle_to_vec(angle)
    local nomralize_origin = vec3_normalize({end_origin[1] - start_origin[1], end_origin[2] - start_origin[2], end_origin[3] - start_origin[3]})

    return math.deg(math.acos(vec3_dot(origin, nomralize_origin)))
end

local function hsv_to_rgb(h, s, v) 
    local r, g, b

    h = h/360
    s = s/100
    v = v/100
    
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end

    return r * 255, g * 255, b * 255
end

local function rainbow(speed, offset, s, v, a)
    --Default to if nothing was provided (retards)
    speed = speed or 10
    offset = offset or 0
    s = s or 100
    v = v or 100

    local h = ((globals_tickcount() * speed) % 360) + offset

    --Normalize
    while h > 360 do
        h = h - 360
    end

    while h < 0 do
        h = 360 - h
    end

    --Just incase...
    h = clamp(0, 360, h)

    local color = {hsv_to_rgb(h, s, v)}
    --Add alpha
    table_insert(color, a)

    return color
end

local utility = {
    string_to_grad = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
        local output = ''
        local len = #text-1
        local rinc = (r2 - r1) / len
        local ginc = (g2 - g1) / len
        local binc = (b2 - b1) / len
        local ainc = (a2 - a1) / len
        for i=1, len+1 do
            output = output .. ('\a%02x%02x%02x%02x%s'):format(r1, g1, b1, a1, text:sub(i, i))
            r1 = r1 + rinc
            g1 = g1 + ginc
            b1 = b1 + binc
            a1 = a1 + ainc
        end
    
        return output
    end,
    
    clamp = function(cur, min, max)
        if cur == nil or min == nil or max == nil then
            return nil
        end
        if min > max then
            return nil
        end
        if cur < min then
            return min
        end
        if cur > max then
            return max
        end
    
        return cur
    end,

    animation =function(check, name, value, speed) 
        if check then 
            return name + (value - name) * globals.frametime() * speed 
        else 
            return name - (value + name) * globals.frametime() * speed -- add / 2 if u want goig back effect
        end
    end,
}

local function closest_player_fov(enemies_only)
    if lp == nil or entity_is_alive(lp) == false then
        return nil 
    end

    local players = entity.get_players(enemies_only)
    
    --Get local eye position
    local local_camera = {client.camera_angles()}
    local local_origin = {entity_get_origin(lp)}

    if local_camera[1] == nil or local_origin[1] == nil then
        return nil
    end

    local_origin[3] = local_origin[3] + 64
    
    local data = {360, nil}

    for i = 1, #players do
        local player = players[i]
        local origin = {entity_get_origin(player)}

        if (origin[1] ~= nil) then
            local angle_to_player = vec3_angles(local_origin, origin)

            local fov = get_fov(local_origin, origin, local_camera)

            if (data[1] > fov) then
                data = {fov, player}
            end
        end
    end

    local shot_data = {(1/globals.tickinterval()) * 4, nil}

    for i = 1, #player_data do
        local data = player_data[i]

        local delta = math.abs(globals_tickcount() - data.last_shot_time)

        if delta < shot_data[1] then
            shot_data = {delta, data.index}
        end
    end

    if shot_data[2] then
        return shot_data[2]
    else
        return data[2]
    end
end


local function calculate_stage(len, speed)
    return math.floor((globals.curtime() * speed / 10) % len + 1)
end

local function angle_vector(angle_x, angle_y)
	local sp, sy, cp, cy = nil, nil, nil, nil
	sy = math.sin(math.rad(angle_y))
	cy = math.cos(math.rad(angle_y))
	sp = math.sin(math.rad(angle_x))
	cp = math.cos(math.rad(angle_x))
	return {cp * cy, cp * sy, -sp}
end

local function eye_position(player)
    if(player == nil) then
        return nil
    end

    local origin = {entity_get_origin(player)}

    return {origin[1], origin[2], origin[3] + 46 + (18 * (1 - entity_get_prop(player, "m_flDuckAmount")))}
end

local function calculate_origin(origin, angle, distance)
    local angle_vec = angle_vector(0, angle)

    local results = {
        origin[1] + angle_vec[1] * distance,
        origin[2] + angle_vec[2] * distance,
        origin[3] + angle_vec[3] * distance
    }
    return results
end


local function extrapolate_angle(index, origin, angles, limit)
    local forward = angle_to_vec(angles)
    local trace = {client.trace_line(index, origin[1], origin[2], origin[3], forward[1] * (8192), forward[2] * (8192), forward[3] * (8192))}
    return {
        origin[1] + (forward[1] * clamp(0, limit, (8192 * trace[1]))),
        origin[2] + (forward[2] * clamp(0, limit, (8192 * trace[1]))),
        origin[3] + (forward[3] * clamp(0, limit, (8192 * trace[1])))
    }, 8192 * trace[1]
end

local function dynamic_freestanding(player)
    if lp == nil or entity_is_alive(lp) == false then
        return nil
    end

    if player == nil or entity_is_alive(player) == false then
        return nil
    end

    local local_eye_position = eye_position(lp)
    local enemy_eye_position = eye_position(player)

    if local_eye_position == nil or enemy_eye_position == nil then
        return nil
    end

    if math.abs(local_eye_position[3] - enemy_eye_position[3]) > 45 then
        if local_eye_position[3] > enemy_eye_position[3] then
            enemy_eye_position[3] = local_eye_position[3]
        else
            local_eye_position[3] = enemy_eye_position[3]
        end
    end

    local angle = vec3_angles(local_eye_position, enemy_eye_position)

    local total_trace_90_to_90 = 0
    local total_trace_neg_90_neg_90 = 0

    --For a total of x * 8 traces
    for i = 1, 4 do 
        local max_distance = i * 10

        local local_90 = extrapolate_angle(lp, local_eye_position, {0, normalize_yaw(angle[2] + 90)}, max_distance)
        local local_neg_90 = extrapolate_angle(lp, local_eye_position, {0, normalize_yaw(angle[2] - 90)}, max_distance)

        local enemy_90 = extrapolate_angle(player, enemy_eye_position, {0, normalize_yaw(angle[2] - 90 + 180)}, max_distance)
        local enemy_neg_90 = extrapolate_angle(player, enemy_eye_position, {0, normalize_yaw(angle[2] + 90 + 180)}, max_distance)

        local _90_to_90 = {client.trace_line(lp, local_90[1], local_90[2], local_90[3], enemy_90[1], enemy_90[2], enemy_90[3])}
        local _neg_90_to_neg_90 = {client.trace_line(lp, local_neg_90[1], local_neg_90[2], local_neg_90[3], enemy_neg_90[1], enemy_neg_90[2], enemy_neg_90[3])}

        total_trace_90_to_90 = total_trace_90_to_90 + _90_to_90[1]
        total_trace_neg_90_neg_90 = total_trace_neg_90_neg_90 + _neg_90_to_neg_90[1]
    end

    local equals_zero = total_trace_90_to_90 == 0 and total_trace_neg_90_neg_90 == 0
    local equals = total_trace_90_to_90 == total_trace_neg_90_neg_90

    if not (equals_zero or equals) then
        return total_trace_90_to_90 > total_trace_neg_90_neg_90
    end

    return nil
end

local function can_shoot(player)
    if player == nil or entity_is_alive(player) == false or entity.get_player_weapon(player) == nil then
        return true
    end

    local m_flNextAttack = entity_get_prop(player, "m_flNextAttack")
    local m_flNextPrimaryAttack = entity_get_prop(entity.get_player_weapon(player), "m_flNextPrimaryAttack")
    local m_nTickBase = entity_get_prop(player, "m_nTickBase")

    if m_flNextAttack == nil or m_flNextPrimaryAttack == nil or m_nTickBase == nil then
        return true
    end

    local curtime = m_nTickBase * globals.tickinterval()

    if m_flNextAttack > curtime then
        return false
    elseif m_flNextPrimaryAttack > curtime then
        return false
    end

    return true
end


local function micromove(cmd)
    local air = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 0

    if cmd.forwardmove == 0 and cmd.sidemove == 0 and air == false then
        local duck_amount = entity_get_prop(lp, "m_flDuckAmount") or 0
        local amount = duck_amount > 0.1 and 3.10 or 1.10
        cmd.forwardmove = micromovemnt_switch and amount or -amount
        micromovemnt_switch = not micromovemnt_switch
    end
end

local function presets(player)
    if player == nil then
        return {yaw = 0, yaw_jitter = {"Off",  0}, body_yaw = {"Static", 0}, fake_yaw = 58}, false, 0
    end

    local speed = get_velocity(lp) --int, player speed
    local air = bit.band(entity_get_prop(lp, "m_fFlags") or 0, 1) == 0 --boolean, player in air or not 
    local duck = bit.band(entity_get_prop(lp, "m_fFlags") or 0, 2) == 2 --boolean, player in air or not 
    local team = entity_get_prop(lp, "m_iTeamNum") == 3 --true for Ct, false for t
    local raw_freestanding = dynamic_freestanding(player) --boolean, best head angle
    local freestanding = raw_freestanding


    if raw_freestanding == nil then
        if player_data[player].last_side ~= nil then
            freestanding = player_data[player].last_side 
        else
            freestanding = shot_angle
        end
    end

    local antibrute = player_data[player].shots ~= 0 --true/false if player is being antibruted, boolean
    local shot_at_angle = player_data[player].shot_at --If player is being antibruted returns angle they shot at, boolean
    local missed = player_data[player].shots --Total shots a player has missed on you, int

    local aa = {yaw = 0, yaw_jitter = {"Off",  0}, body_yaw = {"Opposite", 60, nil}, fake_yaw = 40}

    --[[
        for clair <3 :DD

        example of setting shit:
        aa.yaw = 0 
        aa.yaw_jitter = {"Offset", 180}
        aa.body_yaw = {"Opposite", 0}
        aa.fake_yaw = 60

        --ex. freestand body yaw
        aa.body_yaw = {"Static", freestanding and -60 or 60} 

        --ex. freestands first shot then anti brutes
        if antibrute == false then --first shot antiaim
            aa.body_yaw = {"Static", freestanding and -60 or 60}
        else
            aa.body_yaw = {"Static", shot_at_angle and -60 or 60}
        end

        you can do random values with math_random(MIN, MAX), for ex. 
        aa.body_yaw = {"Static", math_random(-90, 90)}

        Options freestanding strafe_side jitter_side 
        
        5/10/21:
        shot_angle (boolean, flips every shot)
        duck (boolean, player is ducking)
        team (boolean, true for Ct, false for t)

        5/11/21:
        raw_freestanding (boolean, Raw freestanding, returns nil if freestanding is indecisive)
        body_yaw = {"Opposite", 60, nil}
            -legit aa side: body_yaw[3] = nil (for default), true (left), false (right)
            -ex. aa.body_yaw = {"Static", 60, false}

        manual_mode (returns string of manual mode)
            -ex. 
                if manual_mode == "left" then
                    do that
                elseif manual_mode == "right" then
                    do this
                elseif manual_mode == "back" then
                    back lol
                end
    ]]

    local generic_body_yaw_g = get(generic_body_yaw)

    if generic_body_yaw_g == "Shuffle" then
        local num = {-43, 25}
        local num2 = num[math.random(1,2)]

        --if antibrute == false then -- daniel is gay!
        if air then
            aa.body_yaw = {"Jitter", 0}
            aa.fake_yaw = 60
            --aa.yaw = num2
            client.delay_call(1, ui.set, ref.yaw[2], 90)
            client.delay_call(2, ui.set, ref.yaw[2], 88)
            --print(ref.yaw[2])

            aa.yaw_jitter = {"Center", 0}
        else 
            if speed > 4 then
                aa.body_yaw = {"Jitter", 0}
                aa.fake_yaw = 60
                --print('pussy')
                --aa.yaw =  36
                client.delay_call(1, ui.set, ref.yaw[2], 90)
                client.delay_call(2, ui.set, ref.yaw[2], 88)
                aa.yaw_jitter = {"Center", 0}
            end       
        end   
    elseif generic_body_yaw_g == "Defensive" then --to add more modes
        if antibrute == false then --first shot antiaim
            if air then --In air antiaim
                aa.body_yaw = {"Jitter", 0}
                aa.fake_yaw = 60
                aa.yaw_jitter = {"Center", -90}
                aa.yaw = 0
                if speed > 4 then
                    aa.body_yaw = {"Jitter", 0}
                    aa.fake_yaw = 60
                    aa.yaw_jitter = {"Center", -90}
                    aa.yaw = 0
                end       
            end
        else 
            aa.body_yaw = {"Jitter", shot_at_angle and -90 or 90}
        end      
    elseif generic_body_yaw_g == "ShigeYaw" then 
        if antibrute == false then --first shot antiaim
            if air then --In air antiaim
                aa.body_yaw = {"Jitter", 0}
                aa.yaw_jitter = {"Center", 0}
                aa.fake_yaw = math.random(55, 59)
                client.delay_call(1, ui.set, ref.yaw[2], 9)
                client.delay_call(2, ui.set, ref.yaw[2], -5)
            else
                if speed > 4 then
                    aa.body_yaw = {"Jitter", 0}
                    aa.yaw_jitter = {"Center", 88}
                    --aa.yaw_jitter = {"Center", -5}
                    aa.fake_yaw = 58
                    client.delay_call(1, ui.set, ref.yaw[2], -5)
                    client.delay_call(2, ui.set, ref.yaw[2], -12)
                else
                    if speed == 1 then
                        aa.body_yaw = {"Jitter", 0}
                        aa.yaw_jitter = {"Center", 73}
                        aa.yaw = 7
                        aa.fake_yaw = 58
                        --client.delay_call(1, ui.set, ref.yaw[2], 7)
                    end
                end
            end   
        else
            aa.body_yaw = {"Jitter", 0}
        end
    elseif generic_body_yaw_g == "Gypsy Hata" then
        if antibrute == false then
            if air then
                aa.body_yaw = {"Jitter", 0}
                aa.fake_yaw = 54
                aa.yaw_jitter = {"Center", 20}
                aa.yaw = -3
            else
                if speed < 4 then
                    if team then
                        aa.body_yaw = {"Jitter", 0, shot_angle and 120 or -120}
                        aa.yaw_jitter = {"Center", 43}
                        aa.fake_yaw = 60
                    else
                        aa.body_yaw = {"Jitter", shot_angle and 120 or 120}
                        aa.yaw_jitter = {"Center", 43}
                    end
                end
            end
        else
            aa.body_yaw = {"Static", shot_at_angle and -120 or 120}
        end
    elseif generic_body_yaw_g == "Custom" then
        local rand_delta = math.random(get(generic_random_min), get(generic_random_max))

        local custom_body =  get(generic_custom_body) 

        local custom_delta = get(generic_random_byaw) and rand_delta or get(generic_custom_byaw_value)

        local brute_enabled = get(generic_anti_brute_enable)

        local fake_delta = get(generic_custom_match_body) and 48

        local brute_yaw = get(generic_custom_brute_match_body) and get(generic_custom_byaw) or "Static"

        if antibrute == false or not brute_enabled then
            if air then
                aa.body_yaw = {get(generic_custom_byaw), custom_body}
                aa.fake_yaw = {get(custom_delta)}
                aa.yaw_jitter = {"Center", -10}
            else
                if speed < 4 then
                    if team then
                        aa.body_yaw = {get(generic_custom_byaw), shot_angle and custom_body or -custom_body}
                        aa.yaw_jitter = {"Offset", math_random(custom_body / 3, custom_body / 2)}
                        aa.fake_yaw = fake_delta
                    else
                        aa.body_yaw = {get(generic_custom_byaw), shot_angle and custom_body or -custom_body}
                        aa.yaw_jitter = {"Random", math_random(-custom_body / 3, custom_body / 2.1)}
                        aa.fake_yaw = fake_delta
                    end
                end
            end
        else
            aa.body_yaw = {get(generic_custom_byaw), shot_at_angle and -custom_body or custom_body}
        end
    elseif generic_body_yaw_g == "Towel Head" then
        if antibrute == false then
            if air then
                aa.body_yaw = {"Jitter", 0}
                aa.fake_yaw = 54
                aa.yaw_jitter = {"Center", 20}
            else
                if speed < 4 then
                    if team then
                        aa.body_yaw = {"Static", 40, shot_angle and 33 or -33}
                        aa.yaw_jitter = {"Off", 0}
                        aa.fake_yaw = 39
                    else
                        aa.body_yaw = {"Static", shot_angle and -33 or 33}
                        aa.yaw_jitter = {"Off", 0}
                    end
                end
            end
        else
            aa.body_yaw = {"Static", shot_at_angle and -33 or 33}
        end

    elseif generic_body_yaw_g == "Sply Tard" then
        if antibrute == false then
            if air then
                aa.body_yaw = {"Jitter", 0}
                aa.fake_yaw = 54
                aa.yaw_jitter = {"Center", 20}
            else
                if speed < 4 then
                    if team then
                        aa.body_yaw = {"Opposite", 40, shot_angle and -90 or -90}
                        aa.yaw_jitter = {"Offset", 7}
                        aa.fake_yaw = 39
                    else
                        aa.body_yaw = {"Opposite", shot_angle and -90 or 90}
                        aa.yaw_jitter = {"Offset", 7}
                    end
                end
            end
        else
            aa.body_yaw = {"Static", shot_at_angle and -90 or 120}
        end
    end
    
    return aa, antibrute, missed
end

local function net_update_start()
    if globals.chokedcommands() == 0 then
        jitter_side = not jitter_side
    end

    best_target = closest_player_fov(true)

    local best_data, in_anti, shots = presets(best_target)

    is_antibrute = in_anti or false
    antibrute_shots = shots or 0

    for i = 1, #player_data do
        local data = player_data[i]

        if entity_is_alive(data.index) and entity.is_enemy(data.index) and lp ~= nil and entity_is_alive(lp) then
            player_data[i].side = best_data
        else
            player_data[i].shot_at = nil
            player_data[i].shots = 0
            player_data[i].last_shot_time = 0
        end
    end
end

--Callbacks
local function paint_ui()
    lp = entity.get_local_player()

    local indicator_g = get(generic_indicators)
    
    set_visible(get(generic_body_yaw), Prediction_Breaker, Prediction_Breaker_Inverter)
    set_visible(get(generic_legit_aa_enabled), generic_legit_aa)
    set_visible(get(generic_exploit_enable), generic_exploit_settings, generic_exploit_key)
    set_visible(indicator_g, indicator_modes)
    set_visible(indicator_g, aa_line_modes)
    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines"), aa_line_modes)
    set_visible(indicator_g and includes(get(indicator_modes), "Spectators"))
    set_visible(false, spectators_x, spectators_y)
    set_visible(true, fakelag_limit)
    set_visible(includes(get(indicator_modes), "Logs"), logs_bold)
    set_visible(get(generic_peek_real_fake_check), generic_peek_fake)

    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "REAL"), real_color_label)
    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "REAL"), real_color)

    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "FAKE"), fake_color_label)
    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "FAKE"), fake_color)

    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "ABS"), abs_color_label)
    set_visible(indicator_g and includes(get(indicator_modes), "AA Lines") and includes(get(aa_line_modes), "ABS"), abs_color)

    -- Custom AA Preset
    set_visible(get(generic_body_yaw) == "Custom", sep_1, sep_2, generic_custom_byaw, generic_random_byaw, generic_random_min, generic_random_max, generic_anti_brute_enable, generic_custom_byaw_value, generic_custom_match_body, generic_custom_brute_match_body)
    set_visible(get(generic_body_yaw) == "Custom" and not get(generic_random_byaw), generic_custom_byaw_value, generic_custom_body)
    set_visible(get(generic_random_byaw) and get(generic_body_yaw) == "Custom", generic_random_max, generic_random_min)
    set_visible(get(generic_anti_brute_enable) and get(generic_body_yaw) == "Custom", generic_custom_brute_match_body)

    --color states
    local state = false

    if #get(indicator_modes) == 1 then
        state = includes(get(indicator_modes), "AA Lines") == false
    else
        state = #get(indicator_modes) ~= 0
    end

    set_visible(indicator_g and state, indicators_rainbow)
    set_visible(indicator_g and not get(indicators_rainbow) and state, indicators_label, indicators_color)

    --Hide normal skeet
    set_visible(false, ref.pitch, ref.yaw_base, ref.yaw[1], ref.yaw[2], ref.yaw_jitter[1], ref.yaw_jitter[2], ref.body_yaw[1], ref.body_yaw[2], ref.freestanding_body_yaw, ref.fake_yaw_limit, ref.edge_yaw, ref.freestanding[1], ref.freestanding[2])
end

--not mine lol fuck making this code shit
local function renderer_triangle(v2_A, v2_B, v2_C, r, g, b, a)
    v2_A = {x = v2_A[1], y = v2_A[2]}
    v2_B = {x = v2_B[1], y = v2_B[2]}
    v2_C = {x = v2_C[1], y = v2_C[2]}    

    local function i(j,k,l)
        local m=(k.y-j.y)*(l.x-k.x)-(k.x-j.x)*(l.y-k.y)
        if m<0 then return true end
        return false
    end
    if i(v2_A,v2_B,v2_C) then renderer.triangle(v2_A.x,v2_A.y,v2_B.x,v2_B.y,v2_C.x,v2_C.y,r,g,b,a)
    elseif i(v2_A,v2_C,v2_B) then renderer.triangle(v2_A.x,v2_A.y,v2_C.x,v2_C.y,v2_B.x,v2_B.y,r,g,b,a)
    elseif i(v2_B,v2_C,v2_A) then renderer.triangle(v2_B.x,v2_B.y,v2_C.x,v2_C.y,v2_A.x,v2_A.y,r,g,b,a)
    elseif i(v2_B,v2_A,v2_C) then renderer.triangle(v2_B.x,v2_B.y,v2_A.x,v2_A.y,v2_C.x,v2_C.y,r,g,b,a)
    elseif i(v2_C,v2_A,v2_B) then renderer.triangle(v2_C.x,v2_C.y,v2_A.x,v2_A.y,v2_B.x,v2_B.y,r,g,b,a)
    else renderer.triangle(v2_C.x,v2_C.y,v2_B.x,v2_B.y,v2_A.x,v2_A.y,r,g,b,a)end
end

local function rotate_point(new_x, new_y, angle, distance)
    angle = normalize_yaw(angle)

    local cam = {center[1], center[2]}

    local x = math.sin(math.rad(angle - cam[2])) * distance
    local y = math.cos(math.rad(angle - cam[2])) * distance 
    
    return new_x - x, new_y - y
end

local function manual_arrrows()
    local draw_arrow = function(style, angle, dist, color, size)
        local x, y = rotate_point(center[1], center[2], angle, dist)

        y = y + 22

        local top_point = {rotate_point(x, y, normalize_yaw(angle), size)}
        local left_point = {rotate_point(x, y, normalize_yaw(angle + 180 - 90), size / 2)}
        local right_point = {rotate_point(x, y, normalize_yaw(angle + 180 + 90), size / 2)}
        local middle_point = {rotate_point(x, y, normalize_yaw(angle + 180), style and 0 or -2)}

        renderer_triangle(top_point, left_point, middle_point, color[1], color[2], color[3], color[4])
        renderer_triangle(top_point, right_point, middle_point, color[1], color[2], color[3], color[4])
    end

    if(manual_mode == "left") then
        draw_arrow(0, -90, 30, theme_color, 10)
    elseif(manual_mode == "right") then
        draw_arrow(0, 90, 30, theme_color, 10)
    end
end

local function crosshair_indicators()

    local speed = get_velocity(lp) --int, player speed

    local air = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 0

    local desync_amt = math.floor(math.min(58, math.abs(entity.get_prop(lp, "m_flPoseParameter", 11)*120-60)))

    renderer.text(center[1] + 20, center[2] + 20, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-c", nil, tostring(get(ref.min_dmg)))

    if get(generic_exploit_enable) then
        renderer.text(center[1] + -20, center[2] + 20, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-c", nil, "LC")
    else
        renderer.text(center[1] + -20, center[2] + 20, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-c", nil, "")
    end

    local active = {0, 255, 0, 255}
    local disabled = {255, 0, 0, 255}

    renderer.gradient(center[1] - desync_amt, center[2] + 38, desync_amt, 1, 52, 52, 52, 0, theme_color[1], theme_color[2], theme_color[3], 255, true)

    renderer.gradient(center[1], center[2] + 38, desync_amt, 1, theme_color[1], theme_color[2], theme_color[3], 255, 52, 52, 52, 0, true)

    local b_yaw_size = {renderer.measure_text("", string.format(" %s°", desync_amt))}

    renderer.text(center[1] - b_yaw_size[1] / 2, center[2] + 23, 255, 255, 255, 255, "", 0, string.format(" %s°", desync_amt))

    renderer.text(center[1] - b_yaw_size[1] / 2, center[2] + 23, 255, 255, 255, 255, "", 0, string.format(" %s°", desync_amt))

    local logo_size = {renderer.measure_text("b", "ERIC")}
    local logo_size_second = {renderer.measure_text("b", "GEN")}
    
    if ui.get(ref.body_yaw[2]) > 0 then
        ind_side = "left"
        renderer.text(center[1] + logo_size[1] / 2 - 1, center[2] + 48, 255, 255, 255, 255, "cb", 0, "ERIC")
        renderer.text(center[1] - logo_size_second[1] / 2 - 1, center[2] + 48, theme_color[1], theme_color[2], theme_color[3], 255, "cb", 0, "GEN")
    else
        ind_side = "right"
        renderer.text(center[1] + logo_size[1] / 2 - 1, center[2] + 48, theme_color[1], theme_color[2], theme_color[3], 255, "cb", 0, "ERIC")
        renderer.text(center[1] - logo_size_second[1] / 2 - 1, center[2] + 48, 255, 255, 255, 255, "cb", 0, "GEN")
    end

    local dt_percent = clamp(0, 1, (ticks_while_shifting - 10)/12)
    local dt_state = get(ref.doubletap[1]) and get(ref.doubletap[2]) and dt_percent == 1
    local dt_color = lerp(active, disabled, 1 - dt_percent)

    local inc_amount = (1 / 0.1) * globals.frametime()

    if can_shoot(lp) then
        hs_percent = hs_percent + inc_amount
    else
        hs_percent = 0
    end

    hs_percent = clamp(0, 1, hs_percent)

    local os_state = get(ref.onshot[1]) and get(ref.onshot[2]) and not dt_state and hs_percent == 1

    local indicators = {}
    local indicator_offset = 70

    local yaw_mode = ui.get(generic_body_yaw)

    if speed == 1 then
        renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 64, 255, 255, 255, 255, "-c", 0, "[STANDING]")
    else 
        if air then 
            renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 64, 255, 255, 255, 255, "-c", 0, "[AIR]")
        else
            renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 64, 255, 255, 255, 255, "-c", 0, "[MOVING]")
        end

    end


    if get(generic_smart_peek) then
        local shift_percentage = utility.clamp(antiaim_funcs.get_tickbase_shifting() * 10, 0, 100)

        renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 10, 255, 255, 255, 255, "-c", 0, '+/- SMART PEEK ACTIVE ' .. shift_percentage, "x")
    end



    if(manual_mode ~= "back") then
        yaw_mode = manual_mode == "left" and "MANUAL - L" or "MANUAL - R"
    end

    if(is_in_use and get(generic_legit_aa_enabled)) then
        local type = get(generic_legit_aa)

        if(type == "Default") then
            yaw_mode = "LEGIT"
        elseif(type == "Jitter") then
            yaw_mode = "LEGIT JITTER"
        else
            yaw_mode = "LEGIT LOW"
        end
    end

    if(get(generic_smart_peek)) then
        yaw_mode = "SMART PEEK"
    end
    
    table_insert(indicators, {
        text = "[ " .. yaw_mode:upper() .. " ]",
        active = false,
        active_color = white,
        disabled_color = white,
        circle_enabled = false,
        percent = 0
    })

    table_insert(indicators, {
        text = "[ " .. ind_side:upper() .. " ]",
        active = false,
        active_color = white,
        disabled_color = white,
        circle_enabled = false,
        percent = 0
    })

    if(dt_percent ~= 0) then
        table_insert(indicators, {
            text = "DT",
            active = dt_state,
            active_color = active,
            disabled_color = disabled,
            circle_enabled = true,
            percent = dt_percent
        })
    end

    if(ui.get(ref.onshot[1]) and ui.get(ref.onshot[2]) and hs_percent ~= 0 and dt_percent ~= 1 and not ui.get(ref.doubletap[2])) then
        table_insert(indicators, {
            text = "HS",
            active = os_state,
            active_color = active,
            disabled_color = disabled,
            circle_enabled = true,
            percent = hs_percent
        })
    end

    if(ui.get(ref.fakeduck)) then
        local duck_amount = entity_get_prop(lp, "m_flDuckAmount") or 0

        local fd_active = duck_amount > 0.54

        table_insert(indicators, {
            text = "FD",
            active = fd_active,
            active_color = active,
            disabled_color = disabled,
            circle_enabled = true,
            percent = duck_amount
        })
    end
    
    for i = 1, #indicators do
        local ind = indicators[i]

        if(ind ~= nil) then
            local txt_size = {renderer.measure_text("-", ind.text)}

            local actual_color = ind.active and ind.active_color or ind.disabled_color

            local padding = ind.padding or 0

            renderer.text(center[1] - (txt_size[1] / 2), center[2] + indicator_offset, actual_color[1], actual_color[2], actual_color[3], actual_color[4], "-", 0, ind.text)

            if(ind.circle_enabled and ind.percent ~= 1) then
                renderer.circle_outline(center[1] - (txt_size[1] / 2) + 16 + padding, center[2] + indicator_offset + txt_size[2] / 2, 15, 15, 15, 255, 2, 90, 1, 4)
                renderer.circle_outline(center[1] - (txt_size[1] / 2) + 16 + padding, center[2] + indicator_offset + txt_size[2] / 2, ind.active_color[1], ind.active_color[2], ind.active_color[3], ind.active_color[4], 3, 90, ind.percent, 2)
            end

            indicator_offset = indicator_offset + 11
        end
    end
end

local function crosshair_2()
    
    local speed = get_velocity(lp) --int, player speed

    local air = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 0

    local desync_amt = math.floor(math.min(58, math.abs(entity.get_prop(lp, "m_flPoseParameter", 11)*120-60)))

    local alpha = math.sin(math.abs((math.pi * -1) + (globals.curtime() * 1.5) % (math.pi * 2))) * 255

    --renderer.gradient(center[1] - desync_amt, center[2] + 38, desync_amt, 1, 52, 52, 52, 0, theme_color[1], theme_color[2], theme_color[3], 255, true)

    --renderer.rectangle(center[1] - desync_amt, center[2] + 38, 35, 5, theme_color[1], theme_color[2], theme_color[3], 255, true)

    --renderer.rectangle(center[1] , center[2] + 38, 35, 5, theme_color[1], theme_color[2], theme_color[3], 255, true)

    
    --renderer.gradient(center[1], center[2] + 38, desync_amt, 1, theme_color[1], theme_color[2], theme_color[3], 255, 52, 52, 52, 0, true)

    local b_yaw_size = {renderer.measure_text("", string.format(" %s°", desync_amt))}

    renderer.text(center[1] - b_yaw_size[1] /  55, center[2] + 15, 255, 255, 255, 255, "-", 0, string.format(" %s°", desync_amt))

    renderer.text(center[1] - b_yaw_size[1] /  55, center[2] + 15, 255, 255, 255, 255, "-", 0, string.format(" %s°", desync_amt))

    
    local logo_size = {renderer.measure_text("b", "ERIC")}
    local logo_size_second = {renderer.measure_text("b", "GEN")}
    
    if ui.get(ref.body_yaw[2]) > 0 then
        ind_side = "left"
        renderer.text(center[1] + logo_size[1] / 3 - - 7, center[2] + 23, 255, 255, 255, 255, "-", 0, "ERIC")
        renderer.text(center[1] - logo_size_second[1] / 3 - - 7, center[2] + 23, theme_color[1], theme_color[2], theme_color[3], 255, "-", 0, "GEN")
    else
        ind_side = "right"
        renderer.text(center[1] + logo_size[1] / 3 - - 7, center[2] + 23, theme_color[1], theme_color[2], theme_color[3], 255, "-", 0, "ERIC")
        renderer.text(center[1] - logo_size_second[1] / 3 - - 7, center[2] + 23, 255, 255, 255, 255, "-", 0, "GEN")
    end

    if get(generic_peek_fake) == "Real" then
        renderer.text(center[1] + logo_size[1] / 3 - 7, center[2] + 33, 255, 255, 255, 255, "-", 0, "REAL +/-")
    elseif get(generic_peek_fake) == "Fake" then
        renderer.text(center[1] + logo_size[1] / 3 -  7, center[2] + 33, 255, 255, 255, 255, "-", 0, "FAKE -/-")
    end

    if speed == 1 then
        renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 43, 255, 255, 255, 255, "-", 0, "[STAND]")
    else 
        if air then 
            renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 43, 255, 255, 255, 255, "-", 0, "[AIR]")
        else
            renderer.text(center[1] + logo_size[1] / 25 - 1, center[2] + 43, 255, 255, 255, 255, "-", 0, "[MOVE]")
        end

    end

    renderer.text(center[1] + 29, center[2] + 20, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-c", nil, tostring(get(ref.min_dmg)))


    if get(ref.doubletap[2]) or get(ref.onshot[2]) then
        cached_value = center[2] + 53
        cached_ab = center[2] + 53
    else
        cached_value = center[2] + 53
        cached_ab = center[2] + 53 
    end

    if get(ref.doubletap[2]) then
        renderer.text(center[1] - - 1, cached_value, 170, 235, 140, 255, "-", nil, "DT")
    else
        renderer.text(center[1] - - 1, cached_value, 255, 255, 255, 185, "-", nil, "DT")
    end

    if get(ref.onshot[2]) then
        renderer.text(center[1] + 12, cached_value, 170, 235, 140, 255, "-", nil, "OS")
    else
        renderer.text(center[1] + 12, cached_value, 255, 255, 255, 185, "-", nil, "OS")
    end


    --[[if get(ref.doubletap[2]) and get(ref.onshot[2]) then
        renderer.text(center[1] + 12, cached_value, 170, 235, 140, 255, "-", nil, "OS")
    end]]

    if get(ref.quickpeek[2]) then
        renderer.text(center[1] + 36, cached_value, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-", nil, "QP")
    else
        renderer.text(center[1] + 36, cached_value, 255, 255, 255, 185, "-", nil, "QP")
    end


    if get(ref.freestanding[2]) then
        renderer.text(center[1] + 25, cached_value, theme_color[1], theme_color[2], theme_color[3], theme_color[4], "-", nil, "FS")
    else
        renderer.text(center[1] + 25, cached_value, 255, 255, 255, 185, "-", nil, "FS")
    end





   
end

local function panel()
    if includes(get(indicator_modes), "State Panel") then

        local desync_amt2 = math.floor(math.min(58, math.abs(entity.get_prop(lp, "m_flPoseParameter", 11)*120-60)))

        local yaw_mode2 = ui.get(generic_body_yaw)

        local items = { }
        --username
        renderer.text(screen[1] / 20 - 90, center[2] + 64, 255, 255, 255, 255, 0, "b", "[generic.lua]")
        renderer.text(screen[1] / 20 - 90, center[2] + 80, 255, 255, 255, 255, 0, "b", "Welcome: " .. obex_data.username)
        renderer.text(screen[1] / 20 - 90, center[2] + 95, 255, 255, 255, 255, 0, "b", "version: " .. obex_data.build)
        renderer.text(screen[1] / 20 - 90, center[2] + 110, 255, 255, 255, 255, 0, "b", "Best Target: ", entity.get_player_name(best_target))
        renderer.text(screen[1] / 20 - 90, center[2] + 125, 255, 255, 255, 255, 0, "b", "Desync Amt: ", desync_amt2, "° ", "(" .. desync_amt2 .. "°", ")")
        renderer.text(screen[1] / 20 - 90, center[2] + 140, 255, 255, 255, 255, 0, "b", "Anti-aim Info: ", yaw_mode2)
        --renderer.text(screen[1] / 25 - 90, center[2] + 130, 255, 255, 255, 255, 0, "b", "Angle ", byaw_side)

    end


end

local function logs_indicators()
    local alpha_inc = (255/0.25) * globals.frametime()
    
    local offset = 0

    local flags = get(logs_bold) and "b" or ""

    for i=#logs_data.text, 1, -1 do
        if logs_data.text[i] ~= nil then
            local table_text = logs_data.text[i]

            local max_alpha = logs_data.alpha[i]
            
            logs_data.alpha[i] = clamp(0, 255, logs_data.time[i] < globals.realtime() and max_alpha - alpha_inc or max_alpha + alpha_inc)

            local old_offset = logs_data.cur_offset[i]
            
            if old_offset ~= offset then
                logs_data.cur_offset[i] = clamp(0, offset, old_offset < offset and old_offset + (120 * globals.frametime()) or offset)
            end

            local new_offset = logs_data.cur_offset[i]

            local raw_text = ""

            for i2=1, #table_text do
                raw_text = raw_text .. table_text[i2][5]
            end

            local total_size = {renderer.measure_text(flags, raw_text)}

            local percent = 1-(max_alpha/255)

            local x_offset = logs_data.time[i] > globals.realtime() and -percent*80 or percent*80

            local text_offset = 0
            for i2=1, #table_text do

                local cur_table_text = table_text[i2]

                local text_size = {renderer.measure_text(flags, cur_table_text[5])}

                renderer.text((center[1] - total_size[1]/2) + text_offset + x_offset, screen[2] - 300 + new_offset, cur_table_text[1], cur_table_text[2], cur_table_text[3], clamp(0, max_alpha, cur_table_text[4]), flags, 0, cur_table_text[5])
                
                text_offset = text_offset + text_size[1] 
            end

            offset = offset + 18
        end
    
    end

    --Remove oldest logs if they're more than 5 logs
    for i=1, #logs_data.text do
        local dif_from_newest = #logs_data.text - i 

        if dif_from_newest > 5 then
            logs_data.time[i] = 0
        end
    end

    --Remove old logs
    for i=1, #logs_data.text do
        if logs_data.alpha[i] == 0 and logs_data.time[i] < globals.realtime() then
            table_remove(logs_data.cur_offset, i)
            table_remove(logs_data.alpha, i)
            table_remove(logs_data.time, i)
            table_remove(logs_data.text, i)
        end
    end 
end

local function paint()
    if get(generic_indicators) then
        local rainbow_speed = 3

        if get(indicators_rainbow) then
            theme_color = rainbow(rainbow_speed, 0, 80, 100, 255)
        else
            theme_color = {get(indicators_color)}
        end

        if includes(get(indicator_modes), "Spectators") then
            if lp ~= nil then
                local position = {get(spectators_x), get(spectators_y)}

                local size = {180, 20}

                if ui.is_menu_open() then
                    local click = client.key_state(0x01)
                    local mouse = {ui.mouse_position()}

                    if dragging and not click then
                        dragging = false
                    end

                    if dragging and click then
                        position[1] = mouse[1] - drag_xy[1]
                        position[2] = mouse[2] - drag_xy[2]
                        set(spectators_x, clamp(0, 5000, position[1])) --Saves to a slider
                        set(spectators_y, clamp(0, 5000, position[2]))
                    end
                    if mouse_within(position[1], position[2], size[1], size[2]) then
                        dragging = true
                        drag_xy[1] = mouse[1] - position[1]
                        drag_xy[2] = mouse[2] - position[2]
                    end
                end

                --Clamp
                set(spectators_x, clamp(1, screen[1] - size[1] - 1, get(spectators_x)))
                set(spectators_y, clamp(1, screen[2] - size[2] - 1, get(spectators_y)))

                --Update
                position = {get(spectators_x), get(spectators_y)}

                local r, g, b, a = theme_color[1], theme_color[2], theme_color[3], theme_color[4]

                renderer.rectangle(position[1], position[2] + size[2], size[1], 2, r, g, b, a)

                renderer.gradient(position[1], position[2], size[1], 20, 10, 10, 10, 25, 10, 10, 10, 100, false)

                renderer.text(position[1] + size[1]/2, position[2] + 20/2, 255, 255, 255, 255, "rc", 0, "spectators")

                local y_offset = position[2] + size[2] + 10

                local get_spectators = function()
                    local me = entity.get_local_player()
        
                    local players, observing = { }, me
                
                    for i = 1, globals.maxplayers() do
                        if entity.get_classname(i) == "CCSPlayer" then
                            local spec_mode = entity.get_prop(i, "m_iObserverMode")
                            local spec_target = entity.get_prop(i, "m_hObserverTarget")
                
                            if spec_target ~= nil and spec_target <= 64 and not entity.is_alive(i) and (spec_mode == 4 or spec_mode == 5) then
                                if players[spec_target] == nil then
                                    players[spec_target] = { }
                                end
                
                                if i == me then
                                    observing = spec_target
                                end
                
                                table_insert(players[spec_target], i)
                            end
                        end
                    end
                
                    return players, observing
                end

                local spectators, player = get_spectators()

                if(spectators[player] ~= nil) then
                    for _, spectator in pairs(spectators[player]) do
                        if(spectator ~= lp) then
                            local player_name = entity.get_player_name(spectator)

                            local player_id = entity.get_steam64(spectator)

                            local avatar = images.get_steam_avatar(player_id)

                            if(avatar == nil) then
                                avatar = images.get_steam_avatar(entity.get_steam64(lp))
                            end
                            
                            local tex = renderer.load_rgba(avatar.contents, avatar.width, avatar.height) 

                            local txt_size = {renderer.measure_text("r", player_name)}

                            if(tex ~= nil) then
                                renderer.texture(tex, position[1], y_offset, txt_size[2], txt_size[2], 255, 255, 255, 255, "f")
                            end

                            renderer.text(position[1] + txt_size[1] + 20, y_offset, 255, 255, 255, 255, "r", 0, player_name)

                            y_offset = y_offset + txt_size[2] + 4
                        end
                    end
                end
            end
        end

        if(includes(get(indicator_modes), "AA Lines")) then
            if(lp ~= nil and entity.is_alive(lp) and get(ref.thirdperson[1]) and get(ref.thirdperson[2])) then
                local make_line = function(label, dist, loc_x, loc_y, loc_z, origin_x, origin_y, value, color)
                    local x_angle = loc_x + math.cos(math.rad(value)) * dist
                    local y_angle = loc_y + math.sin(math.rad(value)) * dist

                    local w2s = {renderer.world_to_screen(x_angle, y_angle, loc_z)}

                    if(w2s[1] ~= nil and w2s[2] ~= nil) then
                        renderer.line(origin_x, origin_y, w2s[1], w2s[2], color[1], color[2], color[3], color[4])

                        local txt_size = {renderer.measure_text("-", label)}

                        renderer.text(w2s[1] - txt_size[1] / 2, w2s[2] - 2, color[1], color[2], color[3], color[4], "-", 0, label)
                    end
                end

                local origin = {entity.get_origin(lp)}

                local origin_screen = {renderer.world_to_screen(origin[1], origin[2], origin[3])}

                if(origin_screen[1] ~= nil and origin_screen[2] ~= nil) then
                    local modes = get(aa_line_modes)

                    if(includes(modes, "REAL")) then
                        make_line("REAL", 20, origin[1], origin[2], origin[3], origin_screen[1], origin_screen[2], antiaim_funcs.get_body_yaw(1), {ui.get(real_color)})
                    end

                    if(includes(modes, "FAKE")) then
                        make_line("FAKE", 23, origin[1], origin[2], origin[3], origin_screen[1], origin_screen[2], antiaim_funcs.get_body_yaw(2), {ui.get(fake_color)})
                    end

                    if(includes(modes, "ABS")) then
                        make_line("ABS", 25, origin[1], origin[2], origin[3], origin_screen[1], origin_screen[2], antiaim_funcs.get_abs_yaw(), {ui.get(abs_color)})
                    end
                end
            end
        end

        --Watermark
        if includes(get(indicator_modes), "Watermark") then
            local x, y = screen[1], screen[2]

            local h, m, s = client.system_time()

            if(h > 12) then
                h = h - 12
            end

            m = m < 10 and "0" .. m or m
            s = s < 10 and "0" .. s or s

            local logo = beta and "generic.lua[beta]" or "generic.lua"

            local text = string.format(logo .. " | %stck | %s:%s:%s | %s [%s]", 1 / globals.tickinterval(), h, m, s, obex_data.username, obex_data.build)

            local w = renderer.measure_text("r", text)
            
            local r, g, b, a = theme_color[1], theme_color[2], theme_color[3], theme_color[4]

            renderer.rectangle(x - w - 15, 26, w + 10, 2, r, g, b, a)

            renderer.gradient(x - w - 15, 5, w + 10, 20, 10, 10, 10, 25, 10, 10, 10, 100, false)

            renderer.text(x - 10, 10, 255, 255, 255, 255, "r", 0, text)
        end

        if includes(get(indicator_modes), "Crosshair") and lp ~= nil and entity_is_alive(lp) then
            crosshair_indicators()
        end

        if includes(get(indicator_modes), "Simple Crosshair") and lp ~= nil and entity_is_alive(lp) then
            crosshair_2()
        end


        if includes(get(indicator_modes), "Logs") then
            logs_indicators()
        end

        if includes(get(indicator_modes), "Manual Arrows") then
            if(lp ~= nil and entity.is_alive(lp)) then
                manual_arrrows()
            end
        end
    end
end

local function clantag_changer()
    --Clantag changer
    if get(generic_clantag) then
        local tag = tags[calculate_stage(#tags, 20)]

        if clantag_old ~= tag then
            client.set_clan_tag(" ".. tag)
            clantag_old = tag
            clantag_override = true
        end
    else
        if clantag_override then
            client.delay_call(0.1, function() client.set_clan_tag("") end)
            clantag_override = false
        end
    end
end

local function smart_peek()

    local cached_quick = get(ref.quickpeek[1])

    if(get(generic_smart_peek)) then
        set(ref.freestanding[1], "Default")
        set(ref.freestanding[2], "Always on")
        set(ref.quickpeek[1], true)
        set(ref.quickpeek[2], "Always on")
        set(ref.doubletap[2], "Always on")
        set(ref.fakelag_limit, 1)
    else
        set(ref.freestanding[1], "Default")
        set(ref.quickpeek[2], "On hotkey")
        set(ref.doubletap[2], "Toggle")
        set(ref.fakelag_limit, 14)
    end
end

client.set_event_callback("setup_command", function(cmd)
    local air = bit.band(entity.get_prop(lp, "m_fFlags"), 1) == 0
    local speed = get_velocity(lp)
    local options = get(generic_exploit_settings)
    local option2 = get(generic_exploit_key)

    if get(generic_exploit_enable) then
        if includes(options, "In Air") then
            if air then
                cmd.force_defensive = true
                --print("air")
            end
        end
    end

    if includes(options, "Moving") then
        if speed > 4 then
            cmd.force_defensive = true
            --print("speed")
        end
    end


    if ui.get(generic_exploit_key) then
        cmd.force_defensive = true
        --print("hot key active")
    end


    if includes(options, "Always On") then
        cmd.force_defensive = true
        --print("Always on")
    end


end)

local function setup_command(cmd)
    is_in_use = cmd.in_use == 1
    ticks_while_shifting = shift_ticks < 0 and ticks_while_shifting + 1 or 0

    if(dragging) then
        cmd.in_attack = 0
    end

    local on_ground = bit.band(entity_get_prop(lp, "m_fFlags") or 0, 1) == 1

    ground_time = on_ground and ground_time + 1 or 0

    if math.abs(cmd.sidemove) > 5 then
        strafe_side = cmd.sidemove < 0 
    end

    if cmd.chokedcommands == 0 and lp ~= nil then
        local origin = {entity_get_origin(lp)}

        if origin[1] ~= nil then
            local delta = {origin[1] - last_origin[1], origin[2] - last_origin[2], origin[3] - last_origin[3]}
            break_distance = delta[1] * delta[1] + delta[2] * delta[2] + delta[3] * delta[3]
            last_origin = origin
        end

        networked_side = get(ref.body_yaw[2]) == 0 and nil or (get(ref.body_yaw[2]) < 0)
    end

    set(ref.pitch, get(generic_pitch))
    set(ref.yaw[1], get(generic_yaw_mode))
    set(ref.body_yaw[2], get(generic_custom_body))

    if best_target ~= nil then
        local data = player_data[best_target].side

        set(ref.yaw[2], data.yaw)
        set(ref.yaw_jitter[1], data.yaw_jitter[1])
        set(ref.yaw_jitter[2], data.yaw_jitter[2])
        set(ref.body_yaw[1], data.body_yaw[1])
        set(ref.body_yaw[2], data.body_yaw[2])
        set(ref.fake_yaw_limit, data.fake_yaw)
    else
        set(ref.yaw[2], 0)
        set(ref.yaw_jitter[1], "Off")
        set(ref.yaw_jitter[2], 0)
        set(ref.body_yaw[1], "Opposite")
        set(ref.body_yaw[2], 0)
        set(ref.fake_yaw_limit, 58)
    end

    --manual anti-aim
    if get(generic_manual_left) and left_ready then
        if manual_mode == "left" then
            manual_mode = "back"
        else
            manual_mode = "left"
        end
        left_ready = false
    elseif get(generic_manual_right) and right_ready then
        if manual_mode == "right" then
            manual_mode = "back"
        else
            manual_mode = "right"
        end
        right_ready = false
    end

    if get(generic_manual_left) == false then
        left_ready = true
    end

    if get(generic_manual_right) == false then
        right_ready = true
    end

    if manual_mode == "left" then
        set(ref.yaw[2], -90)
    elseif manual_mode == "right" then
        set(ref.yaw[2], 90)
    end
    set(ref.yaw_base, manual_mode ~= "back" and "Local view" or get(generic_yaw_base))

    if(lp ~= nil and entity.is_alive(lp)) then
        smart_peek()
    end
   
    if(not get(generic_smart_peek)) then
        set(ref.freestanding[1], (manual_mode ~= "back") and {} or {"Default"})
        set(ref.freestanding[2], (manual_mode ~= "back") and "On hotkey" or (get(generic_freestanding_key) and "Always on" or "On hotkey"))
    end

    if get(generic_freestanding_key) then
        set(ref.freestanding[1], "Default")
        set(ref.freestanding[2], "Always on")
    end

    set(ref.edge_yaw, (manual_mode ~= "back") and false or get(generic_edge_yaw_key))

    local game_rules = entity.get_game_rules()

    if(game_rules ~= nil and lp ~= nil) then
        local is_freeze = entity.get_prop(game_rules, "m_bFreezePeriod")
        
        if(is_freeze == 0) then
            if get(generic_legit_aa_enabled) and cmd.in_use == 1 then
                micromove(cmd)
        
                if (get(generic_legit_aa) == "Default") then
                    set(ref.yaw[1], "180")
                    set(ref.yaw[2], 180)
                    set(ref.yaw_base, "Local view")
                    set(ref.fake_yaw_limit, 60)
                    set(ref.freestanding[1], {})
                    set(ref.edge_yaw, false)
                elseif (get(generic_legit_aa) == "Jitter") then
                    set(ref.yaw[1], "180")
                    set(ref.yaw[2], 180)
                    set(ref.yaw_base, "Local view")
                    set(ref.fake_yaw_limit, 60)
                    --set(ref.freestanding[1], "Default")
                    --set(ref.freestanding[2], "Always on")
                    set(ref.edge_yaw, false)
                    set(ref.body_yaw[1], "Jitter")
                elseif (get(generic_legit_aa) == "Low Delta") then
                    set(ref.yaw[1], "180")
                    set(ref.yaw[2], 180)
                    set(ref.yaw_base, "Local view")
                    set(ref.fake_yaw_limit, 20)
                    set(ref.freestanding[1], {})
                    set(ref.edge_yaw, false)
                    set(ref.body_yaw[1], "Opposite")
                end        
        
                local c4 = false
        
                local weapon = entity.get_player_weapon(lp)
                if weapon ~= nil then
                    local classname = entity.get_classname(weapon)
                    if classname ~= nil then
                        c4 = classname == "CC4"
                    end 
                end
        
                if best_target ~= nil then
                    local data = player_data[best_target].side
        
                    if data.body_yaw[3] ~= nil then
                        set(ref.body_yaw[1], "Static")
                        set(ref.body_yaw[2], data.body_yaw[3] and 57 or -57)
                    end
                end
        
                if cmd.chokedcommands == 0 and not c4 then
                    cmd.in_use = 0
                end
            end
        end
    end    

    if get(generic_peek_fake) == "Real" then
        set(ref.freestanding_body_yaw, false)
    elseif get(generic_peek_fake) == "Fake" then
        set(ref.freestanding_body_yaw, true)
    end
    
end

local function leg_break()
    if(ground_time > 0) then
        if get(generic_leg_breaker) then
            if (last_break_time + 1 / 65 <= globals_realtime()) then
                if get(ref.leg_movement) == "Never slide" then
                    set(ref.leg_movement, "Always slide")
                else
                    set(ref.leg_movement, "Never slide")
                end
    
                last_break_time = globals_realtime()
            end
        end
    end
end

local function bullet_impact(e)
    local impact = {e.x, e.y, e.z}
    local index = client.userid_to_entindex(e.userid)

    if not (entity.is_enemy(index) and entity_is_alive(index) and entity.is_dormant(index) == false and index ~= lp and lp ~= nil and entity_is_alive(lp)) then
        return
    end

    local shoot_origin = eye_position(index)
    local eye_origin = eye_position(lp)
    local origin = {entity_get_origin(lp)}

    if shoot_origin[1] == nil or eye_origin[1] == nil or origin[1] == nil then
        return
    end

    if globals_tickcount() <= player_data[index].last_shot_time then
        return
    end

    local distance_to_impact = distance2d(shoot_origin, impact)
    local distance_to_player = distance2d(shoot_origin, eye_origin)
    local impact_point = lerp(shoot_origin, impact, distance_to_player/distance_to_impact)
    local start_trace_point = lerp(shoot_origin, impact, (distance_to_player - 4)/distance_to_impact)
    local end_trace_point = lerp(shoot_origin, impact, (distance_to_player + 4)/distance_to_impact)

    local distance_to_impact_3d = distance3d(shoot_origin, impact)
    local distance_to_player_3d = distance3d(shoot_origin, eye_origin)

    if distance_to_impact_3d < distance_to_player_3d - 256 then      
        return
    end

    local _, yaw = entity_get_prop(lp, "m_angRotation")
    local body_yaw = (entity_get_prop(lp, "m_flPoseParameter", 11) or 1) * 120 - 60
    local angle = normalize_yaw(yaw + body_yaw)
    
    local far_left_top_point = calculate_origin(eye_origin, normalize_yaw(angle + 60), 20)
    local left_top_point = calculate_origin(eye_origin, normalize_yaw(angle + 10), 20)
    local far_right_top_point = calculate_origin(eye_origin, normalize_yaw(angle - 60), 20)
    local right_top_point = calculate_origin(eye_origin, normalize_yaw(angle - 10), 20)

    local data = {999, nil}

    local origins = {far_left_top_point, left_top_point, far_right_top_point, right_top_point}
    for i = 1, #origins do
        local cur_origin = origins[i]

        local z_point = clamp(eye_origin[3], origin[3], impact_point[3])
        local distance_to_cur_point = distance3d(start_trace_point, {cur_origin[1], cur_origin[2], z_point})

        if distance_to_cur_point < data[1] then
            local side = 0

            if i == 1 or i == 2 then
                side = -1
            elseif i == 3 or i == 4 then
                side = 1
            end
            data = {distance_to_cur_point, side}
        end
    end

    if data[1] >= (get(generic_antibrute_range) / 2.66666666667) then --1.66666666667 magic number dw
        return
    end

    local pdata = player_data[index]
    
    player_data[index].shots = player_data[index].shots + 1

    if networked_side ~= nil then
        player_data[index].shot_at = not networked_side
    else
        player_data[index].shot_at = -data[2] == 1 and true or false
    end

    player_data[index].last_shot_time = globals_tickcount() + 1

    local byaw_side = "left"

    if(pdata.side.body_yaw[2] < 0) then
        byaw_side = "left"
    else
        byaw_side = "right"
    end

    local fake_real_delta = normalize_yaw(antiaim_funcs.get_abs_yaw() - antiaim_funcs.get_body_yaw(1))

    create_log(5,
        {white[1], white[2], white[3], white[4], "[ "},
        {theme_color[1], theme_color[2], theme_color[3], theme_color[4], "generic"},
        {white[1], white[2], white[3], white[4], " ] "},
        {theme_color[1], theme_color[2], theme_color[3], theme_color[4], entity.get_player_name(index)},
        {white[1], white[2], white[3], white[4], " shot towards you (side: "},
        {theme_color[1], theme_color[2], theme_color[3], theme_color[4], byaw_side},
        {white[1], white[2], white[3], white[4], ", shots: "},
        {theme_color[1], theme_color[2], theme_color[3], theme_color[4], player_data[index].shots},
        {white[1], white[2], white[3], white[4], ", dist: "},
        {theme_color[1], theme_color[2], theme_color[3], theme_color[4], math.floor(data[1] + 0.5) .. "u"},
        {white[1], white[2], white[3], white[4], ")"}
    )

    multicolor_console(
            {white[1], white[2], white[3], "[ "},
            {theme_color[1], theme_color[2], theme_color[3], "generic"},
            {white[1], white[2], white[3], " ] "},
            {theme_color[1], theme_color[2], theme_color[3], entity.get_player_name(index)},
            {white[1], white[2], white[3], " shot towards you (side: "},
            {theme_color[1], theme_color[2], theme_color[3], byaw_side},
            {white[1], white[2], white[3], ", shots: "},
            {theme_color[1], theme_color[2], theme_color[3], player_data[index].shots},
            {white[1], white[2], white[3], ", dist: "},
            {theme_color[1], theme_color[2], theme_color[3], math.floor(data[1] + 0.5) .. "u"},
            {white[1], white[2], white[3], ", ovrlap: "},
            {theme_color[1], theme_color[2], theme_color[3], math.floor(antiaim_funcs.get_overlap() * 100) .. "%"},
            {white[1], white[2], white[3], ")"}
        )
end

local function aim_fire(e) --Aimbot fire
    if includes(get(indicator_modes), "Logs") then
        local contains, i = includes(fire_logs.id, e.id) --Collect targeted hc, hb, and pred. dmg
        if contains == false then
            table_insert(fire_logs.id, e.id)
            table_insert(fire_logs.pred_hc, e.hit_chance)
            table_insert(fire_logs.pred_hb, e.hitgroup)
            table_insert(fire_logs.pred_dmg, e.damage)
        end
    end
end

local function aim_hit(e) --Aimbot hit
    local target = e.target
    if includes(get(indicator_modes), "Logs") then
        local contains, i = includes(fire_logs.id, e.id)
        if contains then --Add logs
            local pred_hc = fire_logs.pred_hc[i]
            local pred_hb = hitgroup_names[fire_logs.pred_hb[i] + 1]
            local pred_dmg = fire_logs.pred_dmg[i]

            local name = entity.get_player_name(target)
            local acc = e.hit_chance
            local hitbox = hitgroup_names[e.hitgroup + 1]
            local damage = e.damage
            local health = entity_get_prop(target, "m_iHealth") or 0
            
            --Log
            create_log(5,
                {white[1], white[2], white[3], white[4], "[ "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], "generic"},
                {white[1], white[2], white[3], white[4], " ] "},
                {white[1], white[2], white[3], white[4], "Hit "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], name},
                {white[1], white[2], white[3], white[4], " in the "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], hitbox},
                {white[1], white[2], white[3], white[4], " for "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], damage},
                {white[1], white[2], white[3], white[4], " damage ("},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], health},
                {white[1], white[2], white[3], white[4], " hp remaining)"}
            )

            --Console
            multicolor_console(
                {white[1], white[2], white[3], "[ "},
                {theme_color[1], theme_color[2], theme_color[3], "generic"},
                {white[1], white[2], white[3], " ] "},
                {white[1], white[2], white[3], "Hit "},
                {theme_color[1], theme_color[2], theme_color[3], name},
                {white[1], white[2], white[3], " in the "},
                {theme_color[1], theme_color[2], theme_color[3], hitbox},
                {white[1], white[2], white[3], " for "},
                {theme_color[1], theme_color[2], theme_color[3], damage},
                {white[1], white[2], white[3], " damage ("},
                {theme_color[1], theme_color[2], theme_color[3], health},
                {white[1], white[2], white[3], " hp remaining, hc: "},
                {theme_color[1], theme_color[2], theme_color[3], math.floor(acc)},
                {theme_color[1], theme_color[2], theme_color[3], "%"},
                {white[1], white[2], white[3], ")"}
            )

            --Remove old data that we aren't gonna use
            remove_shot_data(e.id)
        end
    end
end

local function aim_miss(e) --ehhh... nothing new 
    local target = e.target
    if includes(get(indicator_modes), "Logs") then
        local contains, i = includes(fire_logs.id, e.id)
        if contains then
            local name = entity.get_player_name(target)
            local acc = e.hit_chance
            local hitbox = hitgroup_names[e.hitgroup + 1]
            local reason = e.reason == "?" and "resolver" or e.reason
            local pred_hc = fire_logs.pred_hc[i]
            local pred_hb = hitgroup_names[fire_logs.pred_hb[i] + 1]
            local pred_dmg = fire_logs.pred_dmg[i]
            --Create log
            create_log(5,
                {white[1], white[2], white[3], white[4], "[ "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], "generic"},
                {white[1], white[2], white[3], white[4], " ] "}, 
                {255, 255, 255, 255, "Missed "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], name},
                {255, 255, 255, 255, "'s "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], hitbox},
                {255, 255, 255, 255, " due to "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], reason},
                {255, 255, 255, 255, " (hc: "},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], math.floor(acc)},
                {theme_color[1], theme_color[2], theme_color[3], theme_color[4], "%"},
                {255, 255, 255, 255, ")"}
            )

            --Send message log
            multicolor_console(
                {white[1], white[2], white[3], "[ "},
                {theme_color[1], theme_color[2], theme_color[3], "generic"},
                {white[1], white[2], white[3], " ] "},
                {255, 255, 255, "Missed "},
                {theme_color[1], theme_color[2], theme_color[3], name},
                {255, 255, 255, "'s "},
                {theme_color[1], theme_color[2], theme_color[3], hitbox},
                {255, 255, 255, " due to "},
                {theme_color[1], theme_color[2], theme_color[3], reason},
                {255, 255, 255, " (hc: "},
                {theme_color[1], theme_color[2], theme_color[3], math.floor(acc)},
                {theme_color[1], theme_color[2], theme_color[3], "%"},
                {255, 255, 255, ", hb: "},
                {theme_color[1], theme_color[2], theme_color[3], pred_hb},
                {255, 255, 255, ", dmg: "},
                {theme_color[1], theme_color[2], theme_color[3], pred_dmg},
                {255, 255, 255, ")"}
            )
            --Remove old data that we aren't gonna use
            remove_shot_data(e.id)
        end
    end
end

local function weapon_fire(e)
    local userid = client.userid_to_entindex(e.userid)

    if userid ~= lp then
        return
    end

    local tickdelta = last_shot_time - globals_tickcount()

    if tickdelta >= (1/globals.tickinterval()) then
        last_shot_time = globals_tickcount()
    end

    if last_shot_time < globals_tickcount() then --To avoid "double flipping" while double tapping
        shot_angle = not shot_angle
        last_shot_time = globals_tickcount() + 5
    end
end

local function shutdown()
    --Restore    
    set_visible(true, ref.pitch, ref.yaw_base, ref.yaw[1], ref.yaw[2], ref.yaw_jitter[1], ref.yaw_jitter[2], ref.body_yaw[1], ref.body_yaw[2], ref.freestanding_body_yaw, ref.fake_yaw_limit, ref.edge_yaw, ref.freestanding[1], ref.freestanding[2])
    
    if get(generic_clantag) then
        client.set_clan_tag("")
    end
end

local function net_update_end() --For getting shifted ticks
    if lp == nil or entity_is_alive(lp) == false then
        return
    end

    local sim_time = entity_get_prop(lp, "m_flSimulationTime")
    if sim_time ~= nil then
        if old_sim_time ~= sim_time then
            shift_ticks = (sim_time/globals.tickinterval()) - globals_tickcount()
            old_sim_time = sim_time
        end
    end
end

local function player_connect_full()
    clantag_update_time = globals_tickcount()
    last_shot_time = globals_tickcount()
end

local function set_event_callback(event, ...)
    local args = {...}

    for i = 1, #args do
        client.set_event_callback(event, args[i])
    end
end

set_event_callback("round_prestart", function()
    if(ui.get(generic_console_clear)) then
        client.exec("clear")
        multicolor_console(
            {white[1], white[2], white[3], "[ "},
            {theme_color[1], theme_color[2], theme_color[3], "generic"},
            {white[1], white[2], white[3], " ] "},
            {theme_color[1], theme_color[2], theme_color[3], " ========================= "},
            {white[1], white[2], white[3], "Round Begin"},
            {theme_color[1], theme_color[2], theme_color[3], " ========================= "}
        )
    end
end)

set_event_callback("paint_ui", paint_ui)
set_event_callback("paint", paint, clantag_changer)
set_event_callback("setup_command", setup_command)
set_event_callback("bullet_impact", bullet_impact)
set_event_callback("weapon_fire", weapon_fire)
set_event_callback("shutdown", shutdown)
set_event_callback("net_update_start", net_update_start)
set_event_callback("player_connect_full", player_connect_full)
set_event_callback("net_update_end", net_update_end)
set_event_callback("aim_hit", aim_hit)
set_event_callback("aim_fire", aim_fire)
set_event_callback("aim_miss", aim_miss)
set_event_callback("paint", leg_break)
set_event_callback("paint", panel)
set_event_callback("setup_command", tap)
