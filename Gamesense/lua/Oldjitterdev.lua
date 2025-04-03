local pui = require("gamesense/pui")
local clipboard = require("gamesense/clipboard")
local ffi = require("ffi")
local base64 = require("gamesense/base64")

local assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs = assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs
local client_log, client_delay_call, ui_get, string_format = client.log, client.delay_call, ui.get, string.format
local typeof, sizeof, cast, cdef, ffi_string, ffi_gc = ffi.typeof, ffi.sizeof, ffi.cast, ffi.cdef, ffi.string, ffi.gc
local string_lower, string_len, string_find = string.lower, string.len, string.find
local base64_encode = base64.encode

local x_ind, y_ind = client.screen_size()

local lua_group = pui.group("aa","anti-aimbot angles")
pui.accent = "EE4444FF"

local aa_config = { '\vGlobal\r', '\vStand\r', '\vWalking\r', '\vRunning\r' , '\vAerobic\r', '\vAerobic+\r', '\vDuck\r', '\vDuck+Move\r' }
local aa_short = { '\vG\r', '\vS\r', '\vW\r', '\vR\r' , '\vA\r', '\vA+\r', '\vD\r', '\vD+M\r' }

local ref = {
    enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
    --[1] = combobox/checkbox | [2] = slider/hotkey
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') }
}

local menu = {
    enable_x = lua_group:checkbox("jitter"),
    enable = lua_group:checkbox("JITTER \v[DEV]"),
    tab = lua_group:combobox('Tab', {"Anti-Aim", "Addons"}),
    addons = lua_group:multiselect('Additions', {'Shit AA On Warmup', 'Anti Backstab'}),
    yaw_direction = lua_group:multiselect('Yaw Directions', {'Freestanding', 'Manual AA'}),
    key_freestand = lua_group:hotkey('Freestanding'),
    key_left = lua_group:hotkey('Manual Left'),
    key_right = lua_group:hotkey('Manual Right'),
    condition = lua_group:combobox('Condition', aa_config),
}

local aa_builder = {}

for i=1, #aa_config do
    aa_builder[i] = {
        enable = lua_group:checkbox('Override '..aa_config[i]),
        static = lua_group:slider(aa_short[i]..' · Yaw', -180, 180, 0, true, '°', 1),
        mod_type = lua_group:combobox(aa_short[i]..' · Modifier Type', {'Off','Offset','Center','Random', 'Skitter'}),
        default_type = lua_group:combobox(aa_short[i]..' · Default Type', {'Default', 'Alternative'}),
        mod_dm = lua_group:slider(aa_short[i]..' ~ Jitter Default Min', -180, 180, 0, true, '°', 1),
        mod_dx = lua_group:slider(aa_short[i]..' · Jitter Default Max', -180, 180, 0, true, '°', 1),
        active_type = lua_group:combobox(aa_short[i]..' · Active Type', {'Default', 'Alternative'}),
        mod_adm = lua_group:slider(aa_short[i]..' · Jitter Active Min', -180, 180, 0, true, '°', 1),
        mod_adx = lua_group:slider(aa_short[i]..' · Jitter Active Max', -180, 180, 0, true, '°', 1),
        body_slider = lua_group:slider(aa_short[i]..' · Body Yaw Amount', -180, 180, 0, true, '°', 1),
    }
end

access_check = {menu.enable_x, true}
enable_check = {menu.enable, true}
aa_tab = {menu.tab, "Anti-Aim"}
addons_tab = {menu.tab, "Addons"}
menu.enable_x:depend({menu.enable_x, function() return false end})
menu.enable:depend(access_check)
menu.tab:depend(access_check, enable_check)
menu.addons:depend(access_check, aa_tab, enable_check)
menu.condition:depend(access_check, aa_tab, enable_check)
menu.yaw_direction:depend(access_check, addons_tab, enable_check)
menu.key_freestand:depend(access_check, addons_tab, enable_check, {menu.yaw_direction, "Freestanding"})
menu.key_left:depend(access_check, addons_tab, enable_check, {menu.yaw_direction, "Manual AA"})
menu.key_right:depend(access_check, addons_tab, enable_check, {menu.yaw_direction, "Manual AA"})

for i=1, #aa_config do
    cond_check = {menu.condition, function() return (i ~= 1) end}
    tab_cond = {menu.condition, aa_config[i]}
    cnd_en = {aa_builder[i].enable, function() if (i == 1) then return true else return aa_builder[i].enable:get() end end}
    aa_tab = {menu.tab, "Anti-Aim"}
    jit_ch = {aa_builder[i].mod_type, function() return aa_builder[i].mod_type:get() ~= "Off" end}
    aa_builder[i].enable:depend(access_check, cond_check, tab_cond, aa_tab, enable_check)
    aa_builder[i].static:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check)
    aa_builder[i].mod_type:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check)
    aa_builder[i].default_type:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check)
    aa_builder[i].mod_dm:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check, jit_ch)
    aa_builder[i].mod_dx:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check, jit_ch)
    aa_builder[i].active_type:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check, jit_ch)
    aa_builder[i].mod_adm:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check, jit_ch)
    aa_builder[i].mod_adx:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check, jit_ch)
    aa_builder[i].body_slider:depend(access_check, cnd_en, tab_cond, aa_tab, enable_check)
end

local function hide_original_menu(state)
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.pitch[1], state)
    ui.set_visible(ref.pitch[2], state)
    ui.set_visible(ref.yawbase, state)
    ui.set_visible(ref.yaw[1], state)
    ui.set_visible(ref.yaw[2], state)
    ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.roll[1], state)
    ui.set_visible(ref.yawjitter[2], state)
    ui.set_visible(ref.bodyyaw[1], state)
    ui.set_visible(ref.bodyyaw[2], state)
    ui.set_visible(ref.fsbodyyaw, state)
    ui.set_visible(ref.edgeyaw, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
end


local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local tickcount = globals.tickcount()
    local sim_time = toticks(entity.get_prop(entity.get_local_player(), "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time
    if sim_diff < 0 then
        defensive_until = globals.tickcount() + math.abs(sim_diff) - toticks(client.latency())
    end
    last_sim_time = sim_time
    return defensive_until > tickcount
end


local id = 1   
local function player_state(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end

    vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    flags = entity.get_prop(lp, 'm_fFlags')
    velocity = math.sqrt(vecvelocity[1]^2+vecvelocity[2]^2)
    groundcheck = bit.band(flags, 1) == 1
    jumpcheck = bit.band(flags, 1) == 0 and cmd.in_jump
    ducked = entity.get_prop(lp, 'm_flDuckAmount') > 0.7
    duckcheck = ducked or ui.get(ref.fakeduck)
    slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if jumpcheck and duckcheck then return "Air+C"
    elseif jumpcheck then return "Air"
    elseif duckcheck and velocity > 10 then return "Duck-Moving"
    elseif duckcheck and velocity < 10 then return "Duck"
    elseif groundcheck and slowwalk_key and velocity > 10 then return "Walking"
    elseif groundcheck and velocity > 5 then return "Moving"
    elseif groundcheck and velocity < 5 then return "Stand"
    else return "Global" end
end

local yaw_direction = 0
local last_press_t_dir = 0

local run_direction = function()
    ui.set(ref.freestand[1], menu.yaw_direction:get("Freestanding"))
    ui.set(ref.freestand[2], menu.key_freestand:get() and 'Always on' or 'On hotkey')

    if yaw_direction ~= 0 then
        ui.set(ref.freestand[1], false)
    end

	if menu.yaw_direction:get("Manual AA") and menu.key_right:get() and last_press_t_dir + 0.2 < globals.curtime() then
		yaw_direction = yaw_direction == 90 and 0 or 90
		last_press_t_dir = globals.curtime()
	elseif menu.yaw_direction:get("Manual AA") and menu.key_left:get() and last_press_t_dir + 0.2 < globals.curtime() then
		yaw_direction = yaw_direction == -90 and 0 or -90
		last_press_t_dir = globals.curtime()
	elseif last_press_t_dir > globals.curtime() then
		last_press_t_dir = globals.curtime()
    end
end

local randomize = 0
local randomize2 = 0

anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function aa_setup(cmd)
    local lp = entity.get_local_player()
    if lp == nil then return end
    if player_state(cmd) == "Duck-Moving" and aa_builder[8].enable:get() then id = 8
    elseif player_state(cmd) == "Duck" and aa_builder[7].enable:get() then id = 7
    elseif player_state(cmd) == "Air+C" and aa_builder[6].enable:get() then id = 6
    elseif player_state(cmd) == "Air" and aa_builder[5].enable:get() then id = 5
    elseif player_state(cmd) == "Moving" and aa_builder[4].enable:get() then id = 4
    elseif player_state(cmd) == "Walking" and aa_builder[3].enable:get() then id = 3
    elseif player_state(cmd) == "Stand" and aa_builder[2].enable:get() then id = 2
    else id = 1 end

    run_direction()

    ui.set(ref.pitch[1], "Down")
    ui.set(ref.yawbase, "At targets")
    ui.set(ref.yaw[1], '180')
    ui.set(ref.bodyyaw[1], 'Jitter')
    ui.set(ref.roll[1], 0)
    ui.set(ref.yawjitter[1], aa_builder[id].mod_type:get())
    ui.set(ref.bodyyaw[2], aa_builder[id].body_slider:get())
    ui.set(ref.yaw[2], yaw_direction == 0 and aa_builder[id].static:get() or yaw_direction)

    cmd.force_defensive = true

    local active_jit = cmd.command_number % math.random(3, 6) > 1

    if is_defensive_active() and active_jit then
        if aa_builder[id].active_type:get() == "Default" then
            ui.set(ref.yawjitter[2], yaw_direction == 0 and randomize2 or 0)
        else
            ui.set(ref.yawjitter[2], yaw_direction == 0 and math.random(aa_builder[id].mod_adm:get(), aa_builder[id].mod_adx:get()) or 0)
        end
        randomize = math.random(aa_builder[id].mod_dm:get(), aa_builder[id].mod_dx:get())
    else
        if aa_builder[id].default_type:get() == "Default" then
            ui.set(ref.yawjitter[2], yaw_direction == 0 and randomize or 0)
        else
            ui.set(ref.yawjitter[2], yaw_direction == 0 and math.random(aa_builder[id].mod_dm:get(), aa_builder[id].mod_dx:get()) or 0)
        end
        randomize2 = math.random(aa_builder[id].mod_adm:get(), aa_builder[id].mod_adx:get())
    end

    local players = entity.get_players(true)
    if menu.addons:get("Shit AA On Warmup") then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[2], math.random(-180, 180))
            ui.set(ref.yawjitter[2], math.random(-180, 180))
            ui.set(ref.bodyyaw[2], math.random(-180, 180))
            ui.set(ref.pitch[1], "Custom")
            ui.set(ref.pitch[2], math.random(-89, 89)) 
        end
    end

    if menu.addons:get("Anti Backstab") then
        lp_orig_x, lp_orig_y, lp_orig_z = entity.get_prop(lp, "m_vecOrigin")
        for i=1, #players do
            if players == nil then return end
            enemy_orig_x, enemy_orig_y, enemy_orig_z = entity.get_prop(players[i], "m_vecOrigin")
            distance_to = anti_knife_dist(lp_orig_x, lp_orig_y, lp_orig_z, enemy_orig_x, enemy_orig_y, enemy_orig_z)
            weapon = entity.get_player_weapon(players[i])
            if weapon == nil then return end
            if entity.get_classname(weapon) == "CKnife" and distance_to <= 250 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end
end

local config_items = {menu, aa_builder}

local package, data, encrypted, decrypted = pui.setup(config_items), "", "", ""
config = {}

config.export = function()
    data = package:save()
    encrypted = base64.encode(json.stringify(data))
    clipboard.set(encrypted)
    print("Succesfully Exported")
end

config.import = function(input)
    decrypted = json.parse(base64.decode(input ~= nil and input or clipboard.get()))
    package:load(decrypted)
    print("Succesfully Imported!")
end

import = lua_group:button("Import Config", function() 
    config.import()
end):depend(access_check, aa_tab, enable_check)

export = lua_group:button("Export Config", function() 
    config.export()
end):depend(access_check, aa_tab, enable_check)

default = lua_group:button("Default Config", function() 
    config.import("W3siZW5hYmxlIjp0cnVlLCJ0YWIiOiJBbnRpLUFpbSIsImFkZG9ucyI6WyJBbnRpIEJhY2tzdGFiIiwifiJdLCJrZXlfbGVmdCI6WzEsOTAsIn4iXSwieWF3X2RpcmVjdGlvbiI6WyJGcmVlc3RhbmRpbmciLCJ+Il0sImVuYWJsZV94Ijp0cnVlLCJrZXlfZnJlZXN0YW5kIjpbMSw2LCJ+Il0sImtleV9yaWdodCI6WzEsNjcsIn4iXSwiY29uZGl0aW9uIjoiXHUwMDBiQWVyb2JpYytcciJ9LFt7ImVuYWJsZSI6ZmFsc2UsIm1vZF90eXBlIjoiQ2VudGVyIiwibW9kX2FkeCI6OTYsIm1vZF9hZG0iOjk2LCJzdGF0aWMiOjksImJvZHlfc2xpZGVyIjotMSwibW9kX2R4Ijo2NiwibW9kX2RtIjo2NiwiZGVmYXVsdF90eXBlIjoiRGVmYXVsdCIsImFjdGl2ZV90eXBlIjoiRGVmYXVsdCJ9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6IkNlbnRlciIsIm1vZF9hZHgiOjExMCwibW9kX2FkbSI6OTAsInN0YXRpYyI6MywiYm9keV9zbGlkZXIiOi0xLCJtb2RfZHgiOjc1LCJtb2RfZG0iOjYwLCJkZWZhdWx0X3R5cGUiOiJEZWZhdWx0IiwiYWN0aXZlX3R5cGUiOiJBbHRlcm5hdGl2ZSJ9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6IkNlbnRlciIsIm1vZF9hZHgiOjEzMCwibW9kX2FkbSI6MTEwLCJzdGF0aWMiOi0zLCJib2R5X3NsaWRlciI6LTEsIm1vZF9keCI6OTAsIm1vZF9kbSI6NzAsImRlZmF1bHRfdHlwZSI6IkRlZmF1bHQiLCJhY3RpdmVfdHlwZSI6IkFsdGVybmF0aXZlIn0seyJlbmFibGUiOnRydWUsIm1vZF90eXBlIjoiQ2VudGVyIiwibW9kX2FkeCI6MTMwLCJtb2RfYWRtIjoxMTAsInN0YXRpYyI6MCwiYm9keV9zbGlkZXIiOi0xLCJtb2RfZHgiOjgwLCJtb2RfZG0iOjcwLCJkZWZhdWx0X3R5cGUiOiJEZWZhdWx0IiwiYWN0aXZlX3R5cGUiOiJBbHRlcm5hdGl2ZSJ9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6IkNlbnRlciIsIm1vZF9hZHgiOjExMCwibW9kX2FkbSI6OTAsInN0YXRpYyI6MCwiYm9keV9zbGlkZXIiOi0xLCJtb2RfZHgiOjc1LCJtb2RfZG0iOjYwLCJkZWZhdWx0X3R5cGUiOiJEZWZhdWx0IiwiYWN0aXZlX3R5cGUiOiJBbHRlcm5hdGl2ZSJ9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6IkNlbnRlciIsIm1vZF9hZHgiOjExMCwibW9kX2FkbSI6OTAsInN0YXRpYyI6OSwiYm9keV9zbGlkZXIiOi0xLCJtb2RfZHgiOjc1LCJtb2RfZG0iOjYwLCJkZWZhdWx0X3R5cGUiOiJEZWZhdWx0IiwiYWN0aXZlX3R5cGUiOiJBbHRlcm5hdGl2ZSJ9LHsiZW5hYmxlIjp0cnVlLCJtb2RfdHlwZSI6IkNlbnRlciIsIm1vZF9hZHgiOjExMCwibW9kX2FkbSI6OTAsInN0YXRpYyI6MywiYm9keV9zbGlkZXIiOi0xLCJtb2RfZHgiOjkwLCJtb2RfZG0iOjcwLCJkZWZhdWx0X3R5cGUiOiJEZWZhdWx0IiwiYWN0aXZlX3R5cGUiOiJEZWZhdWx0In0seyJlbmFibGUiOnRydWUsIm1vZF90eXBlIjoiQ2VudGVyIiwibW9kX2FkeCI6MTEwLCJtb2RfYWRtIjo5MCwic3RhdGljIjozLCJib2R5X3NsaWRlciI6LTEsIm1vZF9keCI6NzUsIm1vZF9kbSI6NjAsImRlZmF1bHRfdHlwZSI6IkFsdGVybmF0aXZlIiwiYWN0aXZlX3R5cGUiOiJEZWZhdWx0In1dXQ==")
end):depend(access_check, aa_tab, enable_check)

client.set_event_callback("paint", function()
    if not entity.is_alive(entity.get_local_player()) then return end
    renderer.text(20, y_ind/2, 255, 255, 255, 255, "", 0, "\a7C7C7CFFJ I T T E R \aB74E4EFF[DEV]")
end)

client.set_event_callback("setup_command", function(cmd)
    if not menu.enable:get() then return end
    aa_setup(cmd)
end)

client.set_event_callback('paint_ui', function()
    hide_original_menu(not (menu.enable:get() and menu.enable_x:get()))
    menu.enable_x:set(true)
    if not menu.enable:get() then return end
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)