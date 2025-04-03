-- 


local vector = require("vector")
local pui = require("gamesense/pui")
local http = require("gamesense/http")
local base64 = require("gamesense/base64")
local images = require("gamesense/images")
local c_entity = require("gamesense/entity")
local clipboard = require("gamesense/clipboard")

local user = "OG"
local version = "Debug"
local update = "01.01.01"

local icon = nil
http.get("https://media.discordapp.net/attachments/1154576381578072065/1158238870735954021/image.png", function(success, response)
    if not success or response.status ~= 200 then
        print("There was an error fetching the icon.")
        return
    end
    local data = response.body
    icon = images.load(data)
end)

-- [References]
local refs = {
    aa = {
        aa_enable = pui.reference("AA","Anti-aimbot angles","Enabled"),
        pitch = pui.reference("AA","Anti-aimbot angles","Pitch"),
        pitch_value = select(2, pui.reference("AA","Anti-aimbot angles","Pitch")),
        yaw_base = pui.reference("AA","Anti-aimbot angles","Yaw base"),
        yaw = pui.reference("AA","Anti-aimbot angles","Yaw"),
        yaw_value = select(2, pui.reference("AA","Anti-aimbot angles","Yaw")),
        yaw_jitter = pui.reference("AA","Anti-aimbot angles","Yaw jitter"),
        yaw_jitter_value = select(2, pui.reference("AA","Anti-aimbot angles","Yaw jitter")),
        body_yaw = pui.reference("AA","Anti-aimbot angles","Body yaw"),
        body_yaw_value = select(2, pui.reference("AA","Anti-aimbot angles","Body yaw")),
        freestand_body_yaw = pui.reference("AA","Anti-aimbot angles","Freestanding body yaw"),
        edgeyaw = pui.reference("AA","Anti-aimbot angles","Edge yaw"),
        freestand = pui.reference("AA","Anti-aimbot angles","Freestanding"),
        roll = pui.reference("AA","Anti-aimbot angles","Roll"),
    },
    rage = {
        fakeduck = pui.reference("Rage","other","duck peek assist"),
        quick_peek = pui.reference("Rage", "other", "quick peek assist"),
        doubletap = pui.reference("Rage", "aimbot", "double tap"),
        force_safe = pui.reference("Rage", "aimbot", "force safe point"),
        force_baim = pui.reference("Rage", "aimbot", "force body aim"),
        hideshots = pui.reference("AA", "other", "on shot anti-aim"),
        md = pui.reference("Rage", "aimbot", "minimum damage"),
        md_override = pui.reference("Rage", "aimbot", "minimum damage override"),
        orig_md_override = {ui.reference("Rage", "aimbot", "minimum damage override")},
        slow_walk = pui.reference("AA","Other","slow motion"),
        slide = pui.reference("AA", "Other", "leg movement")
    },
    misc = {
        clan_tag = pui.reference("Misc", "Miscellaneous", "Clan tag spammer")
    }
}

local aa_state = {[1] = "G", [2] = "STAND", [3] = "MOVE", [4] = "AIR", [5] = "AIR-C", [6] = "CROUCH", [7] = "SLOW", [8] = "DEFENSIVE"}
local aa_state_full = {[1] = "Global", [2] = "Stand", [3] = "Move", [4] = "Air", [5] = "Air + Crouch", [6] = "Crouch", [7] = "Slowwalk", [8] = "Defensive"}

local clan_tag_value = ""
-- [References]

-- [Utility]
local function gradient(r1, g1, b1, a1, r2, g2, b2, a2, text)
    local output = ""
    local len = #text-1
    local rinc = (r2 - r1) / len
    local ginc = (g2 - g1) / len
    local binc = (b2 - b1) / len
    local ainc = (a2 - a1) / len
    for i=1, len+1 do
        output = output .. ("\a%02x%02x%02x%02x%s"):format(r1, g1, b1, a1, text:sub(i, i))
        r1 = r1 + rinc
        g1 = g1 + ginc
        b1 = b1 + binc
        a1 = a1 + ainc
    end
    return output
end

local gradient_anim = function(r1, g1, b1, r2, g2, b2, text)
    local highlight_fraction = (globals.realtime() / 2 % 1.2 * 2) - 1.2
    local output = ""
    for idx = 1, #text do
        local character = text:sub(idx, idx)
        local character_fraction = idx / #text
        local r, g, b = r1, g1, b1
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction = r2 - r, g2 - g, b2 - b
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text:sub(idx, idx))
    end
    return output
end

renderer.rounded_rectangle = function(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local data_circle = {
        {x + radius, y, 180},
        {x + w - radius, y, 90},
        {x + radius, y + h - radius * 2, 270},
        {x + w - radius, y + h - radius * 2, 0},
    }

    local data = {
        {x + radius, y, w - radius * 2, h - radius * 2},
        {x + radius, y - radius, w - radius * 2, radius},
        {x + radius, y + h - radius * 2, w - radius * 2, radius},
        {x, y, radius, h - radius * 2},
        {x + w - radius, y, radius, h - radius * 2},
    }

    for _, data in next, data_circle do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in next, data do
        renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

local function contains(table, element)
    for _, value in pairs(table) do
        if value == element then return true end
    end
    return false
end
-- [Utility]

-- [UI Setup]
local menu = pui.group("AA", "Anti-aimbot angles")
local gui = {
    lua = {
        enabled = menu:checkbox(gradient(185, 125, 210, 255, 195, 160, 210, 255, "Gravity")),
        tab = menu:combobox("Tab selection", "Home", "Anti-aim", "Miscellaneous", "Visuals", "Config"),
        line = menu:label("\n"),
        welcome = menu:label("gravity.lua"),
        version = menu:label("Version: Debug"),
        updated = menu:label("Updated: 01.01.01"),
    },

    antiaim = {
        tab = menu:combobox("Anti-aim tab selection", "Builder", "Additional", "Animations"),

        builder = {
            condition = menu:combobox("Conditions", aa_state_full)
        },

        additional = {
            safe_head = menu:checkbox("Safe head"),
            anti_backstab = menu:checkbox("Anti backstab"),
            leg_breaker = menu:checkbox("Leg breaker"),
            freestanding = menu:hotkey("Freestanding"),
            edge_yaw = menu:hotkey("Edge yaw"),
            manual_left = menu:hotkey("Manual left"),
            manual_right = menu:hotkey("Manual right"),
            manual_reset = menu:hotkey("Manual reset")
        },

        animations = {
            parkinson = menu:checkbox("Parkinson walk"),
            static_legs_in_air = menu:checkbox("Static legs in air"),
            pitch_zero_on_land = menu:checkbox("Pitch zero on land"),
        }
    },

    misc = {
        force_break_lc = menu:checkbox("Lag switch in air"),
        force_break_lc_value = menu:slider("Lag switch ticks", 2, 18, 14),
        clantag = menu:checkbox("Custom clan tag spammer")
    },

    visuals = {
        indicators = menu:checkbox("Crosshair indicators", {185, 125, 210}),
        md_indicator = menu:checkbox("Minimum damage indicator", {255, 255, 255}),
        hit_logs = menu:checkbox("Console hit logs"),
        screen_hit_logs = menu:checkbox("Screen hit logs", {185, 125, 210}),
        screen_hit_logs_y = menu:slider("Vertical offset", 0, 600, 300)
    },

    config = {
        save = menu:button("Save settings", function() config.save() end),
        load = menu:button("Load settings", function() config.load() end),
        import = menu:button("Import settings", function() config.import() end),
        export = menu:button("Export settings", function() config.export() end)
    }
}
-- [UI Setup]

-- [UI Visibility]
gui.lua.tab:depend({gui.lua.enabled, true})
gui.lua.line:depend({gui.lua.enabled, true}, {gui.lua.tab, "Home"})
gui.lua.welcome:depend({gui.lua.enabled, true}, {gui.lua.tab, "Home"})
gui.lua.version:depend({gui.lua.enabled, true}, {gui.lua.tab, "Home"})
gui.lua.updated:depend({gui.lua.enabled, true}, {gui.lua.tab, "Home"})
-- [UI Visibility]

-- [AntiAim Setup]
gui.antiaim.tab:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"})
for _,v in pairs(gui.antiaim.builder) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"})
end
for _,v in pairs(gui.antiaim.additional) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Additional"})
end
for _,v in pairs(gui.antiaim.animations) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Animations"})
end

local aa_builder = {}
for i = 1, 8 do
    local prefix = string.format("\aB97DD2FF[%s]", aa_state_full[i])
    aa_builder[i] = {}

    aa_builder[i].override = menu:checkbox(prefix.."\r Override builder")
    aa_builder[i].override:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"}, {gui.antiaim.builder.condition, aa_state_full[i]})

    aa_builder[i].pitch = menu:combobox(prefix.."\r Pitch", "Off", "Up", "Down", "Random", "Custom")
    aa_builder[i].pitch:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].pitch_value = menu:slider(prefix.."\r Pitch value", -89, 89, 0)
    aa_builder[i].pitch_value:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].pitch, "Custom"})

    aa_builder[i].yaw_base = menu:combobox(prefix.."\r Yaw base", "Local view", "At targets")
    aa_builder[i].yaw_base:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].yaw = menu:combobox(prefix.."\r Yaw", "Off", "180", "Spin", "Negative spin", "Random")
    aa_builder[i].yaw:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].yaw_value = menu:slider(prefix.."\r Yaw offset", -180, 180, 0)
    aa_builder[i].yaw_value:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw, "180"})

    aa_builder[i].yaw_jitter = menu:combobox(prefix.."\r Yaw jitter", "Off", "Offset", "Random", "Center", "Delayed", "3-way")
    aa_builder[i].yaw_jitter:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].yaw_jitter_value = menu:slider(prefix.."\r Yaw jitter", -180, 180, 0)
    aa_builder[i].yaw_jitter_value:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].yaw_jitter_delay = menu:slider(prefix.."\r Yaw jitter delay", 3, 16, 6)
    aa_builder[i].yaw_jitter_delay:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true}, {aa_builder[i].yaw_jitter, "Delayed"})

    aa_builder[i].body_yaw = menu:combobox(prefix.."\r Body yaw", "Off", "Opposite", "Jitter", "Static")
    aa_builder[i].body_yaw:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].body_yaw_value = menu:slider(prefix.."\r Body yaw value", -180, 180, 0)
    aa_builder[i].body_yaw_value:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    aa_builder[i].freestand_body_yaw = menu:checkbox(prefix.."\r Freestanding body yaw")
    aa_builder[i].freestand_body_yaw:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
    {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

    if i ~= 1 and i ~= 8 then
        aa_builder[i].defensive = menu:checkbox(prefix.."\r Use defensive")
        aa_builder[i].defensive:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
        {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})

        aa_builder[i].force_defensive = menu:checkbox(prefix.."\r Force defensive")
        aa_builder[i].force_defensive:depend({gui.lua.enabled, true}, {gui.lua.tab, "Anti-aim"}, {gui.antiaim.tab, "Builder"},
        {gui.antiaim.builder.condition, aa_state_full[i]}, {aa_builder[i].override, true})
    end
end

local function update_defaults(value)
    for _,v in pairs(refs.aa) do
        v:set_visible(value)
    end
end

local function reset_antiaim()
    refs.aa.aa_enable:override(true)
    refs.aa.pitch:override("Off")
    refs.aa.pitch_value:override(0)
    refs.aa.yaw_base:override("Local view")
    refs.aa.yaw:override("Off")
    refs.aa.yaw_value:override(0)
    refs.aa.yaw_jitter:override("Off")
    refs.aa.yaw_jitter_value:override(0)
    refs.aa.body_yaw:override("Off")
    refs.aa.body_yaw_value:override(0)
    refs.aa.freestand_body_yaw:override(false)
    refs.aa.edgeyaw:override(false)
    refs.aa.freestand:override(false)
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Roll"), 0)
end

local function enable()
    update_defaults(false)
    reset_antiaim()
end

local function disable()
    clan_tag_value = ""
    update_defaults(true)
    for k, v in pairs(refs.aa) do
        v:reset()
    end
end

gui.lua.enabled:set_callback(function (self)
    if self then enable()
    else disable() end
end)

local last_sim_time = 0
local defensive_until = 0
local function is_defensive_triggered()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math.abs(sim_diff) - toticks(client.latency())
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end

local function is_defensive_active(state)
    return aa_builder[state].defensive:get() and aa_builder[8].override:get() and is_defensive_triggered()
end

local function choking(cmd)
    local choke = false

    if cmd.allow_send_packet == false or cmd.chokedcommands > 1 then
        choke = true
    else
        choke = false
    end

    return choke
end

local function get_velocity()
    if not entity.get_local_player() then return end
    local first_velocity, second_velocity = entity.get_prop(entity.get_local_player(), "m_vecVelocity")
    local speed = math.floor(math.sqrt(first_velocity*first_velocity+second_velocity*second_velocity))
    
    return speed
end

local ground_tick = 1
local function get_state(speed)
    if not entity.is_alive(entity.get_local_player()) then return end
    local flags = entity.get_prop(entity.get_local_player(), "m_fFlags")
    local land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    if land == true then ground_tick = ground_tick + 1 else ground_tick = 0 end

    if bit.band(flags, 1) == 1 then
        if ground_tick < 10 then if bit.band(flags, 4) == 4 then return 5 else return 4 end end
        if bit.band(flags, 4) == 4 or refs.rage.fakeduck:get() then
            return 6 -- crouching
        else
            if speed <= 3 then
                return 2 -- standing
            else
                if refs.rage.slow_walk:get_hotkey() then
                    return 7 -- slowwalk
                else
                    return 3 -- moving
                end
            end
        end
    elseif bit.band(flags, 1) == 0 then
        if bit.band(flags, 4) == 4 then
            return 5 -- air-c
        else
            return 4 -- air
        end
    end
end

local function is_exposed()
    for _,v in pairs(entity.get_players(true)) do
        if not entity.is_dormant(v) then
            local local_player = entity.get_local_player()
            local entity_x, entity_y, entity_z = entity.get_origin(v)
            local local_x, local_y, local_z = entity.get_origin(local_player)
            local_z = local_z + 40
            local ent,_ = client.trace_bullet(v, entity_x, entity_y, entity_z, local_x, local_y, local_z, false)
            if ent == local_player then return true end
        end
    end
    return false
end

local current_state_ind = ""
local manual_value = ""
local holding_left = false
local holding_right = false
local holding_reset = false
local is_on_ground = false

local function update_antiaim(cmd)
    is_on_ground = cmd.in_jump == 0
    if not gui.lua.enabled:get() or not entity.get_local_player() then
        update_defaults(not gui.lua.enabled:get())
    return end

    local state = get_state(get_velocity())
    local builder = aa_builder[state]

    builder = not builder.override:get() and aa_builder[1] or builder
    if not builder.override:get() then
        reset_antiaim()
        return
    end

    current_state_ind = aa_state[state]
    if aa_builder[state].override:get() and is_defensive_active(state) and not choking(cmd) then
        builder = aa_builder[8]
        current_state_ind = "DEFENSIVE"
    end

    -- [Builder]

    builder.body_yaw:set_enabled(true)
    refs.aa.pitch:override(builder.pitch:get())
    if builder.pitch:get() == "Custom" then ui.set(refs.aa.pitch_value.ref, builder.pitch_value:get()) end
    refs.aa.yaw_base:override(builder.yaw_base:get())
    refs.aa.body_yaw:override(builder.body_yaw:get())
    refs.aa.body_yaw_value:override(builder.body_yaw_value:get())

    if builder.yaw_jitter:get() == "Delayed" then
        builder.body_yaw:set_enabled(false)
        builder.body_yaw:override("Static")
        refs.aa.body_yaw:override("Static")
        refs.aa.yaw:override(builder.yaw:get())
        refs.aa.yaw_jitter:override("Off")

        local yaw_value = builder.yaw_value:get()
        local jitter_value = builder.yaw_jitter_value:get()
        local speed = builder.yaw_jitter_delay:get()

        if cmd.command_number % speed > speed / 2 then
            yaw_value = (jitter_value / 2) + yaw_value
            if yaw_value > 180 then yaw_value = -180 + yaw_value - 180 end
            if yaw_value < -180 then yaw_value = 180 + yaw_value + 180 end
        else
            yaw_value = ((jitter_value * -1) / 2) + yaw_value
            if yaw_value > 180 then yaw_value = -180 + yaw_value - 180 end
            if yaw_value < -180 then yaw_value = 180 + yaw_value + 180 end
        end

        refs.aa.yaw_value:override(yaw_value)
    else
        if builder.yaw:get() == "Spin" then
            refs.aa.yaw:override("Spin")
            refs.aa.yaw_value:override(75)
        elseif builder.yaw:get() == "Negative spin" then
            refs.aa.yaw:override("Spin")
            refs.aa.yaw_value:override(-75)
        elseif builder.yaw:get() == "Random" then
            refs.aa.yaw:override("180")
            refs.aa.yaw_value:override(math.random(-180, 180))
        else
            refs.aa.yaw:override(builder.yaw:get())
            refs.aa.yaw_value:override(builder.yaw_value:get())
        end
        refs.aa.yaw_jitter:override(builder.yaw_jitter:get() == "3-way" and "Skitter" or builder.yaw_jitter:get())
        refs.aa.yaw_jitter_value:override(builder.yaw_jitter_value:get())
    end

    refs.aa.freestand_body_yaw:override(builder.freestand_body_yaw:get())
    
    local players = entity.get_players(true)

    if gui.antiaim.additional.safe_head:get() then
        local highest_difference
        for _,v in pairs(players) do
            local local_player_origin = vector(entity.get_origin(entity.get_local_player()))
            local player_origin = vector(entity.get_origin(v))
            local difference = (local_player_origin.z - player_origin.z)
            if not highest_difference or difference < highest_difference then highest_difference = difference end
        end

        local local_player_weapon = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

        if highest_difference and (((local_player_weapon == "CKnife" and state == 5 and highest_difference > -70)
        or (state == 5 and highest_difference > 120)
        or (state == 2 and highest_difference > 20))) then
            current_state_ind = "SAFE"
            ui.set(refs.aa.pitch.ref, "Down")
            ui.set(refs.aa.yaw.ref, "180")
            ui.set(refs.aa.yaw_value.ref, -1)
            ui.set(refs.aa.yaw_base.ref, "At targets")
            ui.set(refs.aa.yaw_jitter.ref, "Off")
            ui.set(refs.aa.body_yaw.ref, "Static")
            ui.set(refs.aa.body_yaw_value.ref, 0)
            ui.set(refs.aa.freestand_body_yaw.ref, false)
        end
    end

    if gui.antiaim.additional.anti_backstab:get() then
        for i, v in pairs(players) do
            local player_weapon = entity.get_classname(entity.get_player_weapon(v))
            local player_distance = math.floor(vector(entity.get_origin(v)):dist(vector(entity.get_origin(entity.get_local_player()))) / 7)

            if player_weapon == "CKnife" then
                if player_distance < 75 then
                    current_state_ind = "ANTI-KNIFE"
                    ui.set(refs.aa.yaw.ref, "180")
                    ui.set(refs.aa.yaw_value.ref, -180)
                    ui.set(refs.aa.yaw_base.ref, "At targets")
                    ui.set(refs.aa.yaw_jitter.ref, "Off")
                    ui.set(refs.aa.body_yaw.ref, "Off")
                end
            end
        end
    end

    if cmd.in_use == 1 then current_state_ind = "LEGIT" end

    refs.aa.freestand:set_hotkey("Always on")
    local fsactive,_ = gui.antiaim.additional.freestanding:get()
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Freestanding"), fsactive)
    if fsactive then
        refs.aa.yaw_jitter:set("Off")
        refs.aa.body_yaw:set("Static")
    end

    local eyactive,_ = gui.antiaim.additional.edge_yaw:get()
    ui.set(ui.reference("AA", "Anti-aimbot angles", "Edge yaw"), eyactive)

    gui.antiaim.additional.manual_left:set_hotkey("On hotkey")
    gui.antiaim.additional.manual_right:set_hotkey("On hotkey")
    gui.antiaim.additional.manual_reset:set_hotkey("On hotkey")
    local manual_left_active,_ = gui.antiaim.additional.manual_left:get()
    local manual_right_active,_ = gui.antiaim.additional.manual_right:get()
    local manual_reset_active,_ = gui.antiaim.additional.manual_reset:get()

    if manual_left_active then
        if not holding_left then
            manual_value = manual_value == "Left" and "" or "Left"
            holding_left = true
        end
    else
        holding_left = false
    end

    if manual_right_active then
        if not holding_right then
            manual_value = manual_value == "Right" and "" or "Right"
            holding_right = true
        end
    else
        holding_right = false
    end

    if manual_reset_active then
        if not holding_reset then
            manual_value = ""
            holding_reset = true
        end
    else
        holding_reset = false
    end

    if manual_value ~= "" then
        refs.aa.yaw:override("180")
        refs.aa.yaw_base:override("Local view")
        refs.aa.yaw_value:override(manual_value == "Left" and -90 or 90)
        refs.aa.yaw_jitter:override("Off")
        refs.aa.body_yaw:override("Static")
    end

    -- [Leg Breaker]
    if gui.antiaim.additional.leg_breaker:get() then
        if cmd.command_number % 5 > 2 then
            refs.rage.slide:override("Always slide")
        else
            refs.rage.slide:override("Never slide")
        end
    end
    -- [Leg Breaker]

    -- [Break LC]
    if gui.misc.force_break_lc:get() and (state == 4 or state == 5)  then
        if cmd.command_number % gui.misc.force_break_lc_value:get() == 0 and is_exposed() then
            refs.rage.doubletap:override(false)
        else
            refs.rage.doubletap:override(true)
        end
    else
        refs.rage.doubletap:reset()
    end
    -- [Break LC]

    cmd.force_defensive = aa_builder[state].force_defensive:get()
    update_defaults(not gui.lua.enabled:get())
end

local E_POSE_PARAMETERS = {
    STRAFE_YAW = 0,
    STAND = 1,
    LEAN_YAW = 2,
    SPEED = 3,
    LADDER_YAW = 4,
    LADDER_SPEED = 5,
    JUMP_FALL = 6,
    MOVE_YAW = 7,
    MOVE_BLEND_CROUCH = 8,
    MOVE_BLEND_WALK = 9,
    MOVE_BLEND_RUN = 10,
    BODY_YAW = 11,
    BODY_PITCH = 12,
    AIM_BLEND_STAND_IDLE = 13,
    AIM_BLEND_STAND_WALK = 14,
    AIM_BLEND_STAND_RUN = 14,
    AIM_BLEND_CROUCH_IDLE = 16,
    AIM_BLEND_CROUCH_WALK = 17,
    DEATH_YAW = 18
}

client.set_event_callback("pre_render", function()
    if ui.is_menu_open() then
        gui.lua.welcome:set("Welcome back "..gradient_anim(185, 125, 210, 0, 0, 0, user))
        gui.lua.version:set("Version: "..gradient_anim(185, 125, 210, 0, 0, 0, version))
        gui.lua.updated:set("Updated: "..gradient_anim(185, 125, 210, 0, 0, 0, update))
    end
    
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if gui.antiaim.animations.parkinson:get() then
        entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and 0.5 or 1)
    end

    if gui.antiaim.animations.static_legs_in_air:get() then
        entity.set_prop(self, "m_flPoseParameter", 1, E_POSE_PARAMETERS.JUMP_FALL)
    end

    if gui.antiaim.animations.pitch_zero_on_land:get() then
        if not self_anim_state.hit_in_ground_animation or not is_on_ground then
            return
        end

        entity.set_prop(self, "m_flPoseParameter", 0.5, E_POSE_PARAMETERS.BODY_PITCH)
    end
end)

client.set_event_callback("setup_command", update_antiaim)
-- [AntiAim Setup]

-- [Miscellaneous]
for _,v in pairs(gui.misc) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Miscellaneous"})
end

gui.misc.force_break_lc_value:depend({gui.misc.force_break_lc, true})

local clan_tag = {
    "                  ",
    "                  ",
    "                  ",
    "                 g",
    "                gr",
    "               gra",
    "              grav",
    "             gravi",
    "            gravit",
    "           gravity",
    "          gravity ",
    "         gravity  ",
    "        gravity   ",
    "       gravity    ",
    "      gravity     ",
    "     gravity      ",
    "    gravity       ",
    "   gravity        ",
    "  gravity         ",
    " gravity          ",
    "gravity           ",
    "ravity            ",
    "avity             ",
    "vity              ",
    "ity               ",
    "ty                ",
    "y                 ",
}

client.set_event_callback("net_update_end", function()
    if gui.misc.clantag:get() then
        local cur = math.floor(globals.curtime() * 2.4) % #clan_tag
        clan_tag_value = clan_tag[cur + 1]
        refs.misc.clan_tag:override(false)
        refs.misc.clan_tag:set_enabled(false)
        client.set_clan_tag(clan_tag_value)
    else
        if clan_tag_value ~= "" then
            clan_tag_value = ""
            client.set_clan_tag(clan_tag_value)
            refs.misc.clan_tag:reset()
            refs.misc.clan_tag:set_enabled(true)
        end
    end
end)
-- [Miscellaneous]

-- [Visuals]
local screen_x, screen_y = client.screen_size()
local screen_center_x, screen_center_y = screen_x / 2, screen_y / 2
for k, v in pairs(gui.visuals) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Visuals"})
end
gui.visuals.screen_hit_logs_y:depend({gui.lua.enabled, true}, {gui.lua.tab, "Visuals"}, {gui.visuals.screen_hit_logs, true})

local add_x_to_center = function(value)
    return screen_center_x + (screen_x * (value / 1920))
end

local add_y_to_center = function(value)
    return screen_center_y + (screen_y * (value / 1080))
end

local get_ordinal = function(value)
    local lastDigit = value % 10
    local secondLastDigit = math.floor(value / 10) % 10
    
    if secondLastDigit == 1 then
        return "th"
    elseif lastDigit == 1 then
        return "st"
    elseif lastDigit == 2 then
        return "nd"
    elseif lastDigit == 3 then
        return "rd"
    else
        return "th"
    end
end

local hitgroup_names = {"generic", "head", "chest", "stomach", "left arm", "right arm", "left leg", "right leg", "neck", "?", "gear"}
local shot_buffer = {}

local notifications = {}

client.set_event_callback("aim_hit", function(event)
    if not gui.visuals.hit_logs:get() then return end
    local fire_event = shot_buffer[event.id]
    local hitbox = event.hitgroup ~= fire_event.hitgroup and string.format("%s(%s)", hitgroup_names[event.hitgroup + 1], hitgroup_names[fire_event.hitgroup + 1]) or hitgroup_names[event.hitgroup + 1]
    local damage = event.damage ~= fire_event.damage and string.format("%s(%s)", event.damage, fire_event.damage) or event.damage
    local data = string.format("( hc = %s | history(Δ) = %s | safe = %s )", math.floor(event.hit_chance + 0.5), fire_event.backtrack, "?")
    print(string.format("Registered %s%s shot at %s\'s %s for %s damage %s", event.id, get_ordinal(event.id), entity.get_player_name(event.target), hitbox, damage, data))
    if not gui.visuals.screen_hit_logs then return end
    data = string.format("HC: %s, BT = %s", math.floor(event.hit_chance + 0.5), fire_event.backtrack)
    local notification = {
        text = string.format("HIT %s IN THE %s FOR %s %s", entity.get_player_name(event.target), string.upper(hitbox), damage, data),
        time = 10
    }
    if #notifications == 5 then table.remove(notifications, 1) end
    table.insert(notifications, notification)
    table.sort(notifications, function(a, b)
        return a.time > b.time
    end)
end)

client.set_event_callback("aim_miss", function(event)
    if not gui.visuals.hit_logs:get() then return end
    local fire_event = shot_buffer[event.id]
    local data = string.format("( dmg: %s | hc = %s | history(Δ) = %s | safe = %s )", fire_event.damage, math.floor(event.hit_chance + 0.5), fire_event.backtrack, "?")
    print(string.format("Missed %s%s shot at %s\'s %s due to %s %s", event.id, get_ordinal(event.id), entity.get_player_name(event.target), hitgroup_names[event.hitgroup + 1], event.reason, data))
    if not gui.visuals.screen_hit_logs then return end
    data = string.format("HC: %s, BT = %s", math.floor(event.hit_chance + 0.5), fire_event.backtrack)
    local notification = {
        text = string.format("MISSED %s IN THE %s FOR %s %s", entity.get_player_name(event.target), string.upper(hitgroup_names[fire_event.hitgroup + 1]), fire_event.damage, data),
        time = 10
    }
    if #notifications == 5 then table.remove(notifications, 1) end
    table.insert(notifications, notification)
    table.sort(notifications, function(a, b)
        return a.time > b.time
    end)
end)

client.set_event_callback("aim_fire", function(event)
    if not gui.visuals.hit_logs:get() then return end
    shot_buffer[event.id] = event
    shot_buffer[event.id].backtrack = globals.tickcount() - event.tick
end)

local x_to_add = 1 - 1
local min_dmg = 1 - 1
local indicators = {
    double_tap = {
        priority = 1,
        text = "DOUBLE TAP",
        hotkey = true,
        ref = refs.rage.doubletap,
        alpha = 0
    },

    hide_shots = {
        priority = 2,
        text = "HIDE SHOTS",
        hotkey = true,
        ref = refs.rage.hideshots,
        alpha = 0
    },

    fake_duck = {
        priority = 3,
        text = "FAKE DUCK",
        hotkey = false,
        ref = refs.rage.fakeduck,
        alpha = 0
    },

    force_safepoint = {
        priority = 4,
        text = "SAFE",
        hotkey = false,
        ref = refs.rage.force_safe,
        alpha = 0
    },

    force_baim = {
        priority = 5,
        text = "BAIM",
        hotkey = false,
        ref = refs.rage.force_baim,
        alpha = 0
    }
}

local sortedIndicators = {}
for key,_ in pairs(indicators) do
    table.insert(sortedIndicators, key)
end

table.sort(sortedIndicators, function(a, b)
    return indicators[a].priority < indicators[b].priority
end)

function paint()
    if not gui.lua.enabled:get() then return end

    local localplayer = entity.get_local_player()
    if not localplayer then return end
    if not entity.is_alive(localplayer) then return end

    local r, g, b = gui.visuals.indicators:get_color()
    renderer.text(screen_x * (10 / 1920), screen_center_y, 255, 255, 255, 255, "", 0, gradient_anim(r, g, b, 0, 0, 0, "~ G R A V I T Y ~"))

    if gui.visuals.indicators:get() then
        local scoped = entity.get_prop(localplayer, "m_bIsScoped") == 1
        if scoped then
            if x_to_add < 40 then x_to_add = x_to_add + 3 end
        else
            if x_to_add > 0 then x_to_add = x_to_add - 3 end
        end

        renderer.text(add_x_to_center (-2 + x_to_add), add_y_to_center(21), 255, 255, 255, 255, "-c", 0, "GRAVITY  "..gradient_anim(r, g, b, 0, 0, 0, string.upper(version)))

        for size = 1, 6 do
            renderer.rounded_rectangle(add_x_to_center(-29 - size + x_to_add), add_y_to_center(28 - size),
            screen_x * (59 / 1920) + (size * 2), screen_y * (3 / 1080) + (size * 2), r, g, b, 20 / size, 3)
        end

        renderer.rectangle(add_x_to_center(-30 + x_to_add), add_y_to_center(27), 61, 5, 0, 0, 0, 200)

        local desync = refs.aa.body_yaw_value:get()
        local negative = desync < 0
        if negative then desync = desync * -1 end

        renderer.gradient(add_x_to_center(-29 + (negative and 59 or 1 - 1) + x_to_add), add_y_to_center(28),
        screen_x * (((59 * (desync / 180)) * (negative and -1 or 1)) / 1920), screen_y * (3 / 1080),
        r, g, b, 255, 0, 0, 0, 255, true)

        renderer.text(add_x_to_center(-1 + x_to_add), add_y_to_center(38), r, g, b, 255, "-c", 0, current_state_ind)

        local index = 1
        for _, key in ipairs(sortedIndicators) do
            local indicator = indicators[key]

            local active = false
            if indicator.hotkey then
                active = indicator.ref:get_hotkey()
            else
                active = indicator.ref:get()
            end

            if active then
                if indicator.alpha < 255 then indicator.alpha = math.min(indicator.alpha + 10, 255) end
            else
                if indicator.alpha > 0 then indicator.alpha = math.max(indicator.alpha - 10, 0) end
            end

            if indicator.alpha > 0 then
                renderer.text(add_x_to_center(-1 + x_to_add), add_y_to_center(38) + (index * (screen_y * (10 / 1080))), 255, 255, 255, indicator.alpha, "-c", 0, indicator.text)
                index = index + 1
            end
        end
    end

    if gui.visuals.md_indicator:get() then
        local minimum_damage = refs.rage.md_override:get_hotkey() and ui.get(refs.rage.orig_md_override[3]) or refs.rage.md:get()
        local r, g, b = gui.visuals.md_indicator:get_color()
        if minimum_damage > min_dmg then
            min_dmg = min_dmg + 1
        elseif minimum_damage < min_dmg then
            min_dmg = min_dmg - 1
        end
        renderer.text(add_x_to_center(13), add_y_to_center(-22), r, g, b, 255, "-", 0, min_dmg)
    end

    for index, value in ipairs(notifications) do
        local add_y = 0

        value.time = value.time + 1
        if value.time > 420 then
            add_y = (value.time - 420) * 5
        end

        if add_y > screen_y * (100 / 1080) then
            table.remove(notifications, index)
            return
        end

        local text_size = renderer.measure_text("", value.text)
        local r, g, b = gui.visuals.screen_hit_logs:get_color()
        local y = add_y_to_center(100 + gui.visuals.screen_hit_logs_y:get() - (index * (screen_y * (32 / 1080)))) + add_y

        renderer.rounded_rectangle(add_x_to_center(-30) - (text_size / 2), y - 10, text_size + 35, 26, r, g, b, 200, 4)
        renderer.rounded_rectangle(add_x_to_center(-29) - (text_size / 2), y - 11, text_size + 35, 25, 10, 10, 10, 255, 4)

        local anim_size = (text_size * (math.min(1, (value.time / 420)))) + 8

        renderer.rounded_rectangle(add_x_to_center(-4) - math.floor((text_size / 2) + 0.5), y - 8, anim_size, 19, r, g, b, 200, 4)

        icon:draw(add_x_to_center(-28) - (text_size / 2), y - 10, 22, 22, r, g, b, 255, false)
        renderer.text(screen_center_x, y, 255, 255, 255, 255, "c", 0, value.text)
    end
end
-- [Visuals]

-- [Config]
for k, v in pairs(gui.config) do
    v:depend({gui.lua.enabled, true}, {gui.lua.tab, "Config"})
end

local config_items = {
    gui.antiaim,
    aa_builder
}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

local function clipboard_import()
    return clipboard.get()
end

local function clipboard_export(string)
	if string then
        clipboard.set(string)
	end
end

config.save = function()
    local new_data = pui.setup({gui, aa_builder}):save()
    local new_encrypted = base64.encode(json.stringify(new_data))
    database.write("gravity", new_encrypted)
    print("Saved settings to database")
end

config.load = function()
    local preset = database.read("gravity")
    if not preset then
        print("The database is empty")
    end
    local new_decrypted = json.parse(base64.decode(preset))
    local new_package = pui.setup({gui, aa_builder})
    new_package:load(new_decrypted)
    print("Loaded settings from the database")
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard_import()))
    package:load(decrypted)
    print("Imported settings from clipboard")
end

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard_export(encrypted)
    print("Exported settings to clipboard")
end
-- [Config]

if gui.lua.enabled:get() then config.load() end

client.set_event_callback("paint", paint)
client.set_event_callback("shutdown", disable)