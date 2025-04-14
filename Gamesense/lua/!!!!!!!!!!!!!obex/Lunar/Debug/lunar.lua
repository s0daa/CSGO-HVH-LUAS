-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local vector = require("vector")
local bit = require("bit")
local ffi = require("ffi")
local antiaim_funcs = require "gamesense/antiaim_funcs" or error ("Missing gamesense/antiaim_funcs https://gamesense.pub/forums/viewtopic.php?id=29665")
local csgo_weapons = require "gamesense/csgo_weapons" or error("Missing gamesense/csgo_weapons https://gamesense.pub/forums/viewtopic.php?id=18807")
local clipboard = require "gamesense/clipboard" or error("Missing gamesense/clipboard https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require "gamesense/base64" or error("Missing gamesense/base64 https://gamesense.pub/forums/viewtopic.php?id=21619")

local data = database.read("lunar") or {}
local prefix = "\aEAD7FFFF -\aCDCDCDFF "
local current_player_state = "standing"
local build_version = "DEBUG"
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
local standing_settings = {}
local moving_settings = {}
local air_settings = {}
local air_crouching_settings = {}
local crouching_settings = {}
local slow_motion_settings = {}
local reload_settings = false
local bruteforce = false
local brutetick = 0

local function export()
    local config_data = {
        standing_settings = standing_settings,
        moving_settings = moving_settings,
        air_settings = air_settings,
        air_crouching_settings = air_crouching_settings,
        crouching_settings = crouching_settings,
        slow_motion_settings = slow_motion_settings
    }
    clipboard.set(base64.encode(json.stringify(config_data)))
    print("lunar.lua: settings exported to clipboard")
end

local function import()
    local config_data = json.parse(base64.decode(clipboard.get()))

    for k, v in pairs(config_data.standing_settings) do
        standing_settings[k] = v
    end

    for k, v in pairs(config_data.moving_settings) do
        moving_settings[k] = v
    end

    for k, v in pairs(config_data.air_settings) do
        air_settings[k] = v
    end

    for k, v in pairs(config_data.air_crouching_settings) do
        air_crouching_settings[k] = v
    end


    for k, v in pairs(config_data.crouching_settings) do
        crouching_settings[k] = v
    end

    for k, v in pairs(config_data.slow_motion_settings) do
        slow_motion_settings[k] = v
    end

    reload_settings = true
    print("lunar.lua: settings imported from clipboard")
end

-- ref from teamskeet
local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	roll = ui.reference("AA", "Anti-aimbot angles", "Roll") ,
    maxprocticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
    safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Other", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	dt_limit = ui.reference("RAGE", "Other", "Double tap fake lag limit"),

	quickpeek = { ui.reference("RAGE", "Other", "Quick peek assist") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	freestand = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	slow = { ui.reference("AA", "Other", "Slow motion") },
	dt = { ui.reference("RAGE", "Other", "Double tap") },
	ps = { ui.reference("RAGE", "Other", "Double tap") },
	fakelag = { ui.reference("AA", "Fake lag", "Enabled") }
}

local tab_selector = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "tab selector", {"Rage", "Exploits", "Anti-aimbot angles", "Visuals", "Misc", "Config"})

local rage = {
    force_defensive = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "force defensive"),
    doubletap = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "override doubletap"),
    doubletap_mode = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "doubletap mode", {"Default", "Fast", "Fastest"}),
    avoid_backstab = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "avoid backstab"),
    avoid_backstab_range = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "avoid backstab range", 50, 200, 180, true, "°"),
    high_priority_conditions = ui.new_multiselect("AA", "Anti-aimbot angles", prefix .. "high priority conditions", {"Bombcarrier"}),
    resolver = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "resolver"),
    resolver_mode = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "resolver mode", {"Default", "Bodyyaw"}),
}

local state_selector = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "state", {"standing", "moving", "air", "air crouching", "crouching", "slow motion"})

local exploits ={
    prediction_breaker = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "prediction breaker", {"Off", "Spin", "Reverse Spin", "Crazy", "Smart"}),
    pitch_breaker = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "pitch flicker"),
}

local antiaim = {
	yaw = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "yaw base", {"Local view", "At targets"}),
    pitch = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "pitch", {"Off", "Default", "Up", "Down", "Minimal", "Random"}),
    left_yaw = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "yaw offset \aEAD7FFFFleft", -180, 180, 0),
    right_yaw = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "yaw offset \aEAD7FFFFright", -180, 180, 0),
    body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "body yaw", { "Off", "Static", "Opposite", "Jitter"}),
	left_body_yaw = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "body yaw \aEAD7FFFFleft", -180, 180, 0),
    right_body_yaw = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "body yaw \aEAD7FFFFright", -180, 180, 0),
    jitter = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "jitter type", {"Off", "Offset", "Center", "Random"}),
    left_jitter = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "jitter offset \aEAD7FFFFleft", -180, 180, 0),
    right_jitter = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "jitter offset \aEAD7FFFFright", -180, 180, 0),     
    fakeyaw_left_limit = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "fake yaw limit \aEAD7FFFFleft", 0, 60, 60, true, "°"),
    fakeyaw_right_limit = ui.new_slider("AA", "Anti-aimbot angles", prefix .. "fake yaw limit \aEAD7FFFFright", 0, 60, 60, true, "°"),
    ui.new_label("AA", "Anti-aimbot angles", " "),
    antibrute = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "Anti Bruteforce"),
    antibrute_factor = ui.new_slider("AA", "Anti-aimbot angles", "Factor", 1, 3, 1),
}

local function save_state()
    local state = ui.get(state_selector)

    for k, v in pairs(antiaim) do
        if state == "standing" then
            standing_settings[k] = ui.get(v)
        elseif state == "moving" then
            moving_settings[k] = ui.get(v)
        elseif state == "air" then
            air_settings[k] = ui.get(v)
        elseif state == "air crouching" then
            air_crouching_settings[k] = ui.get(v)
        elseif state == "crouching" then
            crouching_settings[k] = ui.get(v)
        elseif state == "slow motion" then
            slow_motion_settings[k] = ui.get(v)
        end
    end
end

local visuals = {
	indicator = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "indicator"),
    debug_panel = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "debug panel")
}

local misc = {
    logging = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "logging"),
    logging_types = ui.new_multiselect("AA", "Anti-aimbot angles", prefix .. "types", {"misses", "hits"}),
    auto_buy = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "auto buy"),
    auto_buy_primary = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "primary", {"Off", "ssg08", "awp", "auto"}),
    auto_buy_secondary = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "secondary", {"Off", "dual berettas", "tec9 / fiveseven", "deagle / revolver"}),
    auto_buy_always_buy_secondary = ui.new_checkbox("AA", "Anti-aimbot angles", prefix .. "always buy pistol"),
    auto_buy_equipment = ui.new_multiselect("AA", "Anti-aimbot angles", prefix .. "equipment", {"vesthelm", "taser", "molotov", "smokegrenade", "hegrenade"}),
}

local config = {
    freestand_key = ui.new_hotkey("AA", "Anti-aimbot angles", prefix .. "freestand key"),
    freestand_mode = ui.new_combobox("AA", "Anti-aimbot angles", prefix .. "freestand mode", {"Default", "Static"}),
    import_config = ui.new_button("AA", "Anti-aimbot angles", "import", import),
	export_config = ui.new_button("AA", "Anti-aimbot angles", "export", export)
}

ui.set(ref.enabled, true)

for k, v in pairs(antiaim) do
    standing_settings[k] = ui.get(v)
    moving_settings[k] = ui.get(v)
    air_settings[k] = ui.get(v)
    air_crouching_settings[k] = ui.get(v)
    crouching_settings[k] = ui.get(v)
    slow_motion_settings[k] = ui.get(v)
end

local function remove_original_features(state)
	ui.set_visible(ref.enabled, state)
	ui.set_visible(ref.pitch, state)
	ui.set_visible(ref.yawbase, state)
	ui.set_visible(ref.yaw[1], state)
	ui.set_visible(ref.yaw[2], state)
	ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.yawjitter[2], state)
	ui.set_visible(ref.bodyyaw[1], state)
	ui.set_visible(ref.bodyyaw[2], state)
	ui.set_visible(ref.fakeyawlimit, state)
	ui.set_visible(ref.fsbodyyaw, state)
	ui.set_visible(ref.edgeyaw, state)
	ui.set_visible(ref.freestand[1], state)
	ui.set_visible(ref.freestand[2], state)
    ui.set_visible(ref.roll, state)
end

local function hide_menu() 
    ui.set_visible(state_selector, false)
	for k,v in pairs(rage) do
		ui.set_visible(v, false)
	end
    for k,v in pairs(exploits) do
        ui.set_visible(v, false)
    end
	for k,v in pairs(antiaim) do
		ui.set_visible(v, false)
	end
	for k,v in pairs(visuals) do
		ui.set_visible(v, false)
	end
	for k,v in pairs(config) do
		ui.set_visible(v, false)
	end
	for k,v in pairs(misc) do
		ui.set_visible(v, false)
	end

	local tab = ui.get(tab_selector)
	if tab == "Rage" then
		for k,v in pairs(rage) do
			ui.set_visible(v, true)
            ui.set_visible(rage.doubletap_mode, ui.get(rage.doubletap))
            ui.set_visible(rage.avoid_backstab_range, ui.get(rage.avoid_backstab))
		end
    elseif tab == "Exploits" then
        for k,v in pairs(exploits) do
            ui.set_visible(v, true)
        end
	elseif tab == "Anti-aimbot angles" then
		for k,v in pairs(antiaim) do
			ui.set_visible(v, true)
		end
        ui.set_visible(state_selector, true)
	elseif tab == "Visuals" then
		for k,v in pairs(visuals) do
			ui.set_visible(v, true)
		end
	elseif tab == "Config" then
		for k,v in pairs(config) do
			ui.set_visible(v, true)
		end
	elseif tab == "Misc" then
		for k,v in pairs(misc) do
			ui.set_visible(v, true)
            ui.set_visible(misc.logging_types, ui.get(misc.logging)) 
            ui.set_visible(misc.auto_buy_primary, ui.get(misc.auto_buy))
            ui.set_visible(misc.auto_buy_secondary, ui.get(misc.auto_buy))
            ui.set_visible(misc.auto_buy_always_buy_secondary, ui.get(misc.auto_buy))
            ui.set_visible(misc.auto_buy_equipment, ui.get(misc.auto_buy))
		end
	end
end

hide_menu()

local function on_state_change()
    local state = ui.get(state_selector)

    for k, v in pairs(antiaim) do
        if state == "standing" then
            ui.set(v, standing_settings[k])
        elseif state == "moving" then
            ui.set(v, moving_settings[k])
        elseif state == "air" then
            ui.set(v, air_settings[k])
        elseif state == "air crouching" then
            ui.set(v, air_crouching_settings[k])
        elseif state == "crouching" then
            ui.set(v, crouching_settings[k])
        elseif state == "slow motion" then
            ui.set(v, slow_motion_settings[k])
        end
    end
end


remove_original_features(false)
ui.set_callback(tab_selector, hide_menu)
ui.set_callback(state_selector, on_state_change)
ui.set_callback(misc.logging, function()
    ui.set_visible(misc.logging_types, ui.get(misc.logging)) 
end)
ui.set_callback(rage.doubletap, function()
    ui.set_visible(rage.doubletap_mode, ui.get(rage.doubletap))
    client.set_cvar("cl_clock_correction", "0")
end)
ui.set_callback(rage.doubletap_mode, function()
    if ui.get(rage.doubletap_mode) == "Default" then
        client.set_cvar("cl_clock_correction", "1")
        ui.set(ref.maxprocticks, 16)
    else
        client.set_cvar("cl_clock_correction", "0")
    end

    if ui.get(rage.doubletap_mode) == "Fast" then
        ui.set(ref.maxprocticks, 18)
    elseif ui.get(rage.doubletap_mode) == "Fastest" then
        ui.set(ref.maxprocticks, 21)
    end
end)
ui.set_callback(rage.avoid_backstab, function()
    ui.set_visible(rage.avoid_backstab_range, ui.get(rage.avoid_backstab))
end)


local function get_antiaim_side(i)
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    return side
end

local function player_state()
    local plr = entity.get_local_player()

    local velocity_array = { entity.get_prop(plr, "m_vecVelocity") }
    local duck_amount = entity.get_prop(plr, "m_flDuckAmount")
    local speed = math.sqrt(velocity_array[1] * velocity_array[1] + velocity_array[2] * velocity_array[2])

    current_player_state = "standing"

    if speed > 2 then
        current_player_state = "moving"
    end

    if duck_amount > 0.5 then
        current_player_state = "crouching"
    end

    if velocity_array[3] < -1 or velocity_array[3] > 1 then
        current_player_state = "air"
        if duck_amount > 0.5 then
            current_player_state = "air crouching"
        end
    end

    if ui.get(ref.slow[1]) and ui.get(ref.slow[2]) then
        current_player_state = "slow motion"
    end
end

local function render_indicator()
    if not ui.get(visuals.indicator) then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    local x, y = client.screen_size()
    local x = x / 2
    local y = y / 2 + 20

    local side_color_left = 255
    local side_color_right = 255
    angle = antiaim_funcs.get_desync(2)

    if (angle * 2) > 0 then
        side_color_left = 50
    elseif (angle * 2) < 0 then
        side_color_right = 50
    end

    local scope_state = entity.get_prop(entity.get_local_player(), "m_bIsScoped")

    if scope_state == 1 then
        x = x + 30
        local fulltext_offset = renderer.measure_text("-", "U N A")
        renderer.text(x + 5, y, 234, 215, 255, 255, "-", nil, "\aEAD7FFFFU N A")
        renderer.text(x, y, 234, 215, 255, side_color_left, "-", nil, "\aL")
        renderer.text(x + fulltext_offset + 5, y, 234, 215, 255, side_color_right, "-", nil, "\aR")
        renderer.text(x, y + 10, 234, 215, 255, 255, "-", nil, "\aEAD7FFFF" .. string.upper(current_player_state))
    else
        local fulltext_offset = renderer.measure_text("c-", "U N A")
        renderer.text(x, y, 234, 215, 255, 255, "c-", nil, "\aEAD7FFFFU N A")
        renderer.text(x - fulltext_offset + 6, y, 234, 215, 255, side_color_left, "c-", nil, "\aL")
        renderer.text(x + fulltext_offset - 5, y, 234, 215, 255, side_color_right, "c-", nil, "\aR")
        renderer.text(x, y + 10, 234, 215, 255, 255, "c-", nil, "\aEAD7FFFF" .. string.upper(current_player_state))
    end
end

local function render_debug_panel()
    if not ui.get(visuals.debug_panel) then return end
    if not entity.is_alive(entity.get_local_player()) then return end

    local x, y = client.screen_size()
    local x = x / 2
    local y = y / 2 + 20

    local plr = entity.get_local_player()
    local debug_items = {}
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    local offset = 0
    local velocity_array = { entity.get_prop(plr, "m_vecVelocity") }
    local speed = math.sqrt(velocity_array[1] * velocity_array[1] + velocity_array[2] * velocity_array[2])
    table.insert(debug_items, "lunar debug panel")
    table.insert(debug_items, ">> desync delta: " .. math.floor(bodyyaw))
    table.insert(debug_items, ">> desync angle: " .. math.floor(antiaim_funcs.get_desync(2)))
    table.insert(debug_items, "")

    local threat = client.current_threat()
    local threat_name = entity.get_player_name(threat)

    if threat == nil then
        table.insert(debug_items, ">> current threat: none")
    else
        local threat_health = math.floor(entity.get_prop(threat, "m_iHealth"))
        local threat_armor = math.floor(entity.get_prop(threat, "m_ArmorValue"))
        local threat_velocity = { entity.get_prop(threat, "m_vecVelocity") }
        local threat_speed = math.floor(math.sqrt(threat_velocity[1] * threat_velocity[1] + threat_velocity[2] * threat_velocity[2]))

        table.insert(debug_items, ">> current threat: " .. tostring(threat_name))
        if not entity.is_dormant(threat) then
            local side = 0
            if get_antiaim_side(client.current_threat()) then
                side = "left"
            else
                side = "right"
            end

            table.insert(debug_items, ">> threat health: " .. tostring(threat_health))
            table.insert(debug_items, ">> threat armor: " .. tostring(threat_armor))
            table.insert(debug_items, ">> threat velocity: " .. tostring(threat_speed))
            table.insert(debug_items, ">> anti aim side: " .. tostring(side))
        end
    end

    for i in pairs(debug_items) do
        renderer.text(40, y + offset, 234, 215, 255, 255, "d-", nil, "\aEAD7FFFF " .. debug_items[i])
        offset = offset + 10
    end
end

local function antiaim_handle()
    if not entity.is_alive(entity.get_local_player()) then return end
    local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
    if current_player_state == "standing" then
        ui.set(ref.pitch, standing_settings.pitch)
        ui.set(ref.yawbase, standing_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], standing_settings.body_yaw)
        ui.set(ref.yawjitter[1], standing_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], standing_settings.left_yaw)
            ui.set(ref.bodyyaw[2], standing_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], standing_settings.left_jitter)
            ui.set(ref.fakeyawlimit, standing_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], standing_settings.right_yaw)
            ui.set(ref.bodyyaw[2], standing_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], standing_settings.right_jitter)
            ui.set(ref.fakeyawlimit, standing_settings.fakeyaw_right_limit)
        end

    elseif current_player_state == "moving" then
        ui.set(ref.pitch, moving_settings.pitch)
        ui.set(ref.yawbase, moving_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], moving_settings.body_yaw)
        ui.set(ref.yawjitter[1], moving_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], moving_settings.left_yaw)
            ui.set(ref.bodyyaw[2], moving_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], moving_settings.left_jitter)
            ui.set(ref.fakeyawlimit, moving_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], moving_settings.right_yaw)
            ui.set(ref.bodyyaw[2], moving_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], moving_settings.right_jitter)
            ui.set(ref.fakeyawlimit, moving_settings.fakeyaw_right_limit)
        end

    elseif current_player_state == "air" then
        ui.set(ref.pitch, air_settings.pitch)
        ui.set(ref.yawbase, air_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], air_settings.body_yaw)
        ui.set(ref.yawjitter[1], air_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], air_settings.left_yaw)
            ui.set(ref.bodyyaw[2], air_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], air_settings.left_jitter)
            ui.set(ref.fakeyawlimit, air_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], air_settings.right_yaw)
            ui.set(ref.bodyyaw[2], air_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], air_settings.right_jitter)
            ui.set(ref.fakeyawlimit, air_settings.fakeyaw_right_limit)
        end

    elseif current_player_state == "crouching" then
        ui.set(ref.pitch, crouching_settings.pitch)
        ui.set(ref.yawbase, crouching_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], crouching_settings.body_yaw)
        ui.set(ref.yawjitter[1], crouching_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], crouching_settings.left_yaw)
            ui.set(ref.bodyyaw[2], crouching_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], crouching_settings.left_jitter)
            ui.set(ref.fakeyawlimit, crouching_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], crouching_settings.right_yaw)
            ui.set(ref.bodyyaw[2], crouching_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], crouching_settings.right_jitter)
            ui.set(ref.fakeyawlimit, crouching_settings.fakeyaw_right_limit)
        end

    elseif current_player_state == "air crouching" then
        ui.set(ref.pitch, air_crouching_settings.pitch)
        ui.set(ref.yawbase, air_crouching_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], air_crouching_settings.body_yaw)
        ui.set(ref.yawjitter[1], air_crouching_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], air_crouching_settings.left_yaw)
            ui.set(ref.bodyyaw[2], air_crouching_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], air_crouching_settings.left_jitter)
            ui.set(ref.fakeyawlimit, air_crouching_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], air_crouching_settings.right_yaw)
            ui.set(ref.bodyyaw[2], air_crouching_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], air_crouching_settings.right_jitter)
            ui.set(ref.fakeyawlimit, air_crouching_settings.fakeyaw_right_limit)
        end

    elseif current_player_state == "slow motion" then
        ui.set(ref.pitch, slow_motion_settings.pitch)
        ui.set(ref.yawbase, slow_motion_settings.yaw)
        ui.set(ref.yaw[1], "180")
        ui.set(ref.bodyyaw[1], slow_motion_settings.body_yaw)
        ui.set(ref.yawjitter[1], slow_motion_settings.jitter)
        if bodyyaw > 0 then
            ui.set(ref.yaw[2], slow_motion_settings.left_yaw)
            ui.set(ref.bodyyaw[2], slow_motion_settings.left_body_yaw)
            ui.set(ref.yawjitter[2], slow_motion_settings.left_jitter)
            ui.set(ref.fakeyawlimit, slow_motion_settings.fakeyaw_left_limit)
        elseif bodyyaw < 0 then
            ui.set(ref.yaw[2], slow_motion_settings.right_yaw)
            ui.set(ref.bodyyaw[2], slow_motion_settings.right_body_yaw)
            ui.set(ref.yawjitter[2], slow_motion_settings.right_jitter)
            ui.set(ref.fakeyawlimit, slow_motion_settings.fakeyaw_right_limit)
        end

    end
end

local function contains(table, value)

	if table == nil then
		return false
	end
	
    table = ui.get(table)
    for i=0, #table do
        if table[i] == value then
            return true
        end
    end
    return false
end

local function antibrute_handle()
    local factor = ui.get(antiaim.antibrute_factor)
    
    if factor == 1 then
        ui.set(ref.yawjitter[1], "Center")
        ui.set(ref.yawjitter[2], 28)
        ui.set(ref.bodyyaw[1], "Jitter")
    elseif factor == 2 then
        ui.set(ref.yawjitter[1], "Center")
        ui.set(ref.yawjitter[2], 36)
        ui.set(ref.bodyyaw[1], "Jitter")
    elseif factor == 3 then
        ui.set(ref.yawjitter[1], "Center")
        ui.set(ref.yawjitter[2], 53)
        ui.set(ref.bodyyaw[1], "Jitter")
    end

    if globals.tickcount() - brutetick > 10 then
        bruteforce = false
    end
end

local function calc_distance (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function avoid_backstab_handle()
    if ui.get(rage.avoid_backstab) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = calc_distance(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= ui.get(rage.avoid_backstab_range) then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.pitch, "Off")
                ui.set(ref.yawbase, "At targets")
            end
        end
    end
end

local function high_priority_conditions_handle()
    local players = entity.get_players(true)
    for i = 1, #players do
        local player = players[i]
        local player_name = entity.get_player_name(player)
        local player_weapon = entity.get_player_weapon(player)

        plist.set(i, "High priority", false)

        if contains(rage.high_priority_conditions, "Bombcarrier") then
            if entity.get_classname(player_weapon) == "CC4" then
                plist.set(i, "High priority", true)
            end
        end


    end
end

local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end

local can_fire = function(local_player)
    local local_weapon = entity.get_player_weapon(local_player)
    if local_weapon == nil then return  end
    local local_weapon_id = entity.get_prop(local_weapon, 'm_iItemDefinitionIndex')
    local shootable = entity.get_prop(local_player, "m_flNextAttack") <= globals.curtime() and entity.get_prop(local_weapon, "m_flNextPrimaryAttack") <= globals.curtime()
    return (local_weapon_id == 40 and shootable) and true or false
end  

local function hittable(local_player)
    if not client.current_threat() then return false end
    local target_origin = vector(entity.get_origin(client.current_threat()))
    if not target_origin then return false end
    if can_fire(local_player) == false then return false end
    local local_origin = vector(client.eye_position())
    local _, dmg = client.trace_bullet(local_player, local_origin.x, local_origin.y, local_origin.z, target_origin.x, target_origin.y, target_origin.z)
    return dmg >= 2
end

client.set_event_callback("net_update_start", function()
	local local_player = entity.get_local_player()

	if not entity.is_alive(local_player) then return end

	player_state()
end)

client.set_event_callback("paint", function()
    render_indicator()
    render_debug_panel()
    if not entity.is_alive(entity.get_local_player()) then return end
    local velocity_array = { entity.get_prop(entity.get_local_player(), "m_vecVelocity") }
    local speed = math.sqrt(velocity_array[1] * velocity_array[1] + velocity_array[2] * velocity_array[2])
    if ui.get(config.freestand_key) then    
            if ui.get(config.freestand_mode) == "Static" then
                ui.set(ref.freestand[2], "Always on")
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], 0)
                ui.set(ref.yawjitter[1], "Center")
                ui.set(ref.yawjitter[2], 0)
            elseif ui.get(config.freestand_mode) == "Default" then
                ui.set(ref.freestand[2], "Always on")
                ui.set(ref.freestand[1], "Default")
            end
    elseif bruteforce and ui.get(antiaim.antibrute) then
        antibrute_handle()
        ui.set(ref.freestand[1], "-")
    else
        antiaim_handle()
        ui.set(ref.freestand[1], "-")
    end
    avoid_backstab_handle()
    high_priority_conditions_handle()
end)


client.set_event_callback("paint", function()
    if ui.is_menu_open() then
        remove_original_features(false)
        hide_menu()
        if reload_settings then
            reload_settings = false
            on_state_change()
        else
            save_state()
        end
    end 
end)

client.set_event_callback("bullet_impact", function(e)
    if not ui.get(antiaim.antibrute) then return end
    if not entity.is_alive(entity.get_local_player()) then return end
    local ent = client.userid_to_entindex(e.userid)
    if ent ~= client.current_threat() then return end
    if entity.is_dormant(ent) or not entity.is_enemy(ent) then return end

    local ent_origin = { entity.get_prop(ent, "m_vecOrigin") }
    ent_origin[3] = ent_origin[3] + entity.get_prop(ent, "m_vecViewOffset[2]")
    local local_head = { entity.hitbox_position(entity.get_local_player(), 0) }
    local closest = GetClosestPoint(ent_origin, { e.x, e.y, e.z }, local_head)
    local delta = { local_head[1]-closest[1], local_head[2]-closest[2] }
    local delta_2d = math.sqrt(delta[1]^2+delta[2]^2)
    
    if bruteforce then return end
    if math.abs(delta_2d) <= 35 then
        bruteforce = true
        brutetick = globals.tickcount()
    end
end)

client.set_event_callback("net_update_end", function()
    if not entity.is_alive(entity.get_local_player()) then return end
    if ui.get(rage.resolver) then 
        local players = entity.get_all("CCSPlayer")
        for i=1, #players do
            if entity.is_alive(i) then
                if not entity.is_dormant(i) then
                    if entity.is_enemy(i) == true then
                        local bodyyaw = entity.get_prop(i, "m_flPoseParameter", 11) * 120 - 60
                        local pitch = entity.get_prop(i, "m_angEyeAngles", 1)
                        local velocity_array = { entity.get_prop(i, "m_vecVelocity") }
                        local speed = math.sqrt(velocity_array[1] * velocity_array[1] + velocity_array[2] * velocity_array[2])
                        side = (bodyyaw > 0) -- Left is above 0
                
                        if entity.is_alive(i) then
                            if ui.get(rage.resolver_mode) == "Default" then
                                if get_antiaim_side(i) then
                                    entity.set_prop(i, "m_angEyeAngles", 90, 0, -50)
                                else
                                    entity.set_prop(i, "m_angEyeAngles", 90, 0, 50)
                                end
                            end
                            if ui.get(rage.resolver_mode) == "Bodyyaw" then
                                if get_antiaim_side(i) then
                                    entity.set_prop(i, "m_angEyeAngles", 90, 0, 50)
                                else
                                    entity.set_prop(i, "m_angEyeAngles", 90, 0, -50)
                                end

                                plist.set(i, "Force body yaw", true)

                                if speed > 5 then
                                    plist.set(i, "Force body yaw value", bodyyaw)

                                    plist.set(i, "Override prefer bodyaim", "Off")
                                else
                                    plist.set(i, "Force body yaw", false)

                                    plist.set(i, "Override prefer bodyaim", "On")
                                end
                            else
                                plist.set(i, "Force body yaw", false)
                            end
                        end
                    end
                end
            end
        end
    end
end)

client.set_event_callback("shutdown", function()
    remove_original_features(true)
end)

client.set_event_callback('aim_fire', function(e)
    if not ui.get(misc.logging) then return end
    if not contains(misc.logging_types, "hits") then return end

    local flags = {
        e.teleported and 'T' or '',
        e.interpolated and 'I' or '',
        e.extrapolated and 'E' or '',
        e.boosted and 'B' or '',
        e.high_priority and 'H' or ''
    }
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    client.color_log(255, 255, 255,string.format('[LUNAR] Fired at %s\'s %s for %d dmg [ hit chance=%d%% ] [ bt=%2d ]', entity.get_player_name(e.target), group, e.damage, math.floor(e.hit_chance + 0.5), globals.tickcount() - e.tick, table.concat(flags)))
end)

client.set_event_callback("aim_miss", function(e)
    if not ui.get(misc.logging) then return end
    if not contains(misc.logging_types, "misses") then return end

    local enemies = entity.get_players(true)
    local name = string.lower(entity.get_player_name(e.target))
    local health = entity.get_prop(e.target, 'm_iHealth')
    local angle = math.floor(entity.get_prop(e.target, "m_flPoseParameter", 11) * 120 - 60 )
    local group = hitgroup_names[e.hitgroup + 1] or '?'
    local side = 0
    if get_antiaim_side(e.target) then
        side = "left"
    else
        side = "right"
    end
    client.color_log(255, 255, 255, string.format('[LUNAR] Missed shot at '..name.."'s "..group..' due to '..e.reason..' remaining ('..health..'hp) at angle: ['..angle..']  [' .. side .. ' side]'), "")
end)

local tick = 1

client.set_event_callback("setup_command", function(cmd)
    if not entity.is_alive(entity.get_local_player()) then return end
    if ui.get(rage.force_defensive) then
        cmd.force_defensive = true
    end

    local velocity_array = { entity.get_prop(entity.get_local_player(), "m_vecVelocity") }
    local speed = math.sqrt(velocity_array[1] * velocity_array[1] + velocity_array[2] * velocity_array[2])
    
    if ui.get(config.freestand_key) then    
        return
    elseif not hittable(entity.get_local_player()) then
        if ui.get(exploits.prediction_breaker) == "Spin" then
            ui.set(ref.yaw[1], "Spin")
            ui.set(ref.yaw[2], -50)
        elseif ui.get(exploits.prediction_breaker) == "Reverse Spin" then
            ui.set(ref.yaw[1], "Spin")
            ui.set(ref.yaw[2], 50)
        elseif ui.get(exploits.prediction_breaker) == "Crazy" then
            if globals.tickcount() % 2 >= 1 then
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], math.random(-10,20))
                ui.set(ref.yawjitter[1], "Center")
                ui.set(ref.yawjitter[2], math.random(40, 70))
            else
                ui.set(ref.yaw[1], "180")
                ui.set(ref.yaw[2], math.random(-10,20))
                ui.set(ref.yawjitter[1], "Offset")
                ui.set(ref.yawjitter[2], 18)
            end
        elseif ui.get(exploits.prediction_breaker) == "Smart" then
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], math.random(-20,30))
            ui.set(ref.yawjitter[1], "Center")
            ui.set(ref.yawjitter[2], (math.random(18, 90) * (speed / 220)))
            ui.set(ref.fakeyawlimit, math.random(45,58))
        end
    end

    if ui.get(exploits.pitch_breaker) and antiaim_funcs.get_double_tap() then
        cmd.force_defensive = true
        ui.set(ref.pitch, "Up")
    end
end)

client.set_event_callback("post_config_load", function()
    hide_menu()
    local config_string = database.read("lunar")
    if config_string == nil then return end
    local config_data = json.parse(base64.decode(config_string))

    for k, v in pairs(config_data.standing_settings) do
        standing_settings[k] = v
    end

    for k, v in pairs(config_data.moving_settings) do
        moving_settings[k] = v
    end

    for k, v in pairs(config_data.air_settings) do
        air_settings[k] = v
    end

    for k, v in pairs(config_data.air_crouching_settings) do
        air_crouching_settings[k] = v
    end

    for k, v in pairs(config_data.crouching_settings) do
        crouching_settings[k] = v
    end

    for k, v in pairs(config_data.slow_motion_settings) do
        slow_motion_settings[k] = v
    end

    reload_settings = true
end)

local function buy_primary(primary) 
    if primary == "Off" then return
    elseif primary == "auto" then
        client.exec("buy g3sg1")
        client.exec("buy scar20")
    else
        client.exec("buy " .. primary)
    end
end

local function buy_secondary(secondary)
    if secondary == "Off" then return
    elseif secondary == "deagle / revolver" then
        client.exec("buy deagle")
        client.exec("buy buy revolver")
    elseif "tec9 / fiveseven" then
        client.exec("buy tec9")
        client.exec("buy fiveseven")
    else
        client.exec("buy " .. secondary)
    end
end
local function buy_equipment(equipment)
    for k, v in pairs(equipment) do
        if v then
            client.exec("buy " .. v)
        end
    end
end

local bought_this_round = false

client.set_event_callback("player_spawn", function()
    if not bought_this_round then
        if ui.get(misc.auto_buy) then
            local primary = ui.get(misc.auto_buy_primary)
            local secondary = ui.get(misc.auto_buy_secondary)
            local equipment = ui.get(misc.auto_buy_equipment)
            local player_money = entity.get_prop(entity.get_local_player(), "m_iAccount")

            if player_money <= 1500 then
                if ui.get(misc.auto_buy_always_buy_secondary) then
                    buy_secondary(secondary)
                end
            else
                buy_primary(primary)
                buy_secondary(secondary)
                buy_equipment(equipment)
            end

            bought_this_round = true
        end
    end
end)

client.set_event_callback("player_death", function()
    remove_original_features(false)
    hide_menu()
    if reload_settings then
        reload_settings = false
        on_state_change()
    else
        save_state()
    end
end)

client.set_event_callback("cs_game_disconnected" , function()
    bought_this_round = false
    remove_original_features(false)
    hide_menu()
    if reload_settings then
        reload_settings = false
        on_state_change()
    else
        save_state()
    end
end)

client.set_event_callback("post_config_load", function()
    remove_original_features(false)
    hide_menu()
    if reload_settings then
        reload_settings = false
        on_state_change()
    else
        save_state()
    end
end)

client.set_event_callback("round_prestart", function()
    bought_this_round = false
end)

client.set_event_callback("post_config_save", function()
    local config_data = {
        standing_settings = standing_settings,
        moving_settings = moving_settings,
        air_settings = air_settings,
        air_crouching_settings = air_crouching_settings,
        crouching_settings = crouching_settings,
        slow_motion_settings = slow_motion_settings
    }
    local config_string = base64.encode(json.stringify(config_data))
    database.write("lunar", config_string)
end)