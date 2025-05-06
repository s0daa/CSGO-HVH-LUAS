-- paid
local base64 = require 'gamesense/base64' -- https://gamesense.pub/forums/viewtopic.php?id=21619
local anti_aim = require 'gamesense/antiaim_funcs' -- https://gamesense.pub/forums/viewtopic.php?id=29665
local csgo_weapons = require 'gamesense/csgo_weapons' -- https://gamesense.pub/forums/viewtopic.php?id=18807
local entity = require 'gamesense/entity' -- https://gamesense.pub/forums/viewtopic.php?id=27529
local clipboard = require 'gamesense/clipboard' -- https://gamesense.pub/forums/viewtopic.php?id=28678
local vector = require 'vector'
local alphabet = 'base64'

--[[
    to do: 
        Fix fake yaw jitter state.
]]

local x, y = client.screen_size()
local tab, container, name = 'AA', 'Anti-aimbot angles', '[\a96C83CFFChernobyl\aFFFFFFC8]'
local vars = {
    player_states = {'Crouch', 'Standing', 'Moving', 'Slow motion', 'Jump'},
    player_states2 = {'Crouch', 'Standing', 'Moving', 'Moving fake lag', 'Slow motion', 'Jump', 'Jump fake lag'},
    state_to_idx = {['Crouch'] = 1, ['Standing'] = 2, ['Moving'] = 3, ['Slow motion'] = 4, ['Jump'] = 5},
    state_to_idx2 = {['Crouch'] = 1, ['Standing'] = 2, ['Moving'] = 3, ['Moving fake lag'] = 4, ['Slow motion'] = 5, ['Jump'] = 6, ['Jump fake lag'] = 7},
    active_i = 1,
    active_i2 = 1,
    p_state = 0
}

local ref = {
    aa = {
        enableaa = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
        pitch = ui.reference('AA', 'Anti-aimbot angles', 'Pitch'),
        yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
        yaw = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw')},
        yawjitter = {ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter')},
        bodyyaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
        freestandbodyyaw = ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
        edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        freestand = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
        roll = ui.reference('AA', 'Anti-aimbot angles', 'Roll')
    },
    fake_lag = {
        fakelagenable = ui.reference('AA', 'Fake lag', 'Enabled'),
        amount = ui.reference('AA', 'Fake lag', 'Amount'),
        variance = ui.reference('AA', 'Fake lag', 'Variance'),
        limit = ui.reference('AA', 'Fake lag', 'Limit')
    },
    other = {
        slowmotion = {ui.reference('AA', 'Other', 'Slow motion')},
        legmove = ui.reference('AA', 'Other', 'Leg movement'),
        quickpeek = {ui.reference('Rage', 'Other', 'Quick peek assist')},
        quickpeekmode = ui.reference('Rage', 'Other', 'Quick peek assist mode'),
        safe_point = ui.reference('Rage', 'Aimbot', 'Force safe point'),
        force_baim = ui.reference('Rage', 'Aimbot', 'Force body aim'),
        quickstop = ui.reference('Rage', 'Aimbot', 'Quick stop'),
        ct = ui.reference('Misc', 'Miscellaneous', 'Clan tag spammer')
    },
    exploits = {
        hideshots = {ui.reference('AA', 'Other', 'On shot anti-aim')},
        doubletap = {ui.reference('Rage', 'Aimbot', 'Double tap')},
        doubletaplag = ui.reference('Rage', 'Aimbot', 'Double tap fake lag limit'),
        fakeduck = ui.reference('Rage', 'Other', 'Duck peek assist'),
        ticks = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks2')
    },
    main = {
        enable = ui.new_checkbox(tab, container, name .. ' anti-aim'),
        options = ui.new_multiselect(tab, container, '\n', {'Anti-aim', 'Exploits', 'Indicators'}),
        aa_type = ui.new_combobox(tab, container, name .. ' anti-aim mode', {'Tank', 'Experimental', 'Builder'}),
        freestand = ui.new_hotkey(tab, container, 'Freestand')
    },
    indicators = {
        options = ui.new_multiselect(tab, container, name .. ' indicators', {'States', 'Hotkeys'}),
        state_label = ui.new_label(tab, container, 'States'),
        state_color = ui.new_color_picker(tab, container, 'color', 132, 161, 255, 255),
        keys_label = ui.new_label(tab, container, 'Hotkeys'),
        keys_color = ui.new_color_picker(tab, container, 'color', 255, 255, 255, 255)
    },
    roll = {},
    builder = {},
}

ref.builder[0] = {
    player_state = ui.new_combobox(tab, container, 'Anti-aim player state', vars.player_states2)
}

for i = 1, 7 do
    ref.builder[i] = {
        pitch = ui.new_combobox(tab, container, 'Pitch', {'Default', 'Down', 'Up', 'Minimal', 'Off'}),
        yawbase = ui.new_combobox(tab, container, 'Yaw base', {'Local view', 'At targets'}),
        yawtype = ui.new_combobox(tab, container, 'Yaw type', {'Default', 'Yaw add'}),
        yaw = ui.new_slider(tab, container, '\n', -180, 180, 0),
        yawjitter = ui.new_combobox(tab, container, 'Yaw jitter', {'Off', 'Center', 'Offset', 'Random'}),
        yawjitterslider = ui.new_slider(tab, container, '\n', -180, 180, 0),
        bodyyaw = ui.new_combobox(tab, container, 'Body yaw', {'Off', 'Static', 'Opposite', 'Jitter'}),
        bodyyawslider = ui.new_slider(tab, container, '\n', -180, 180, 0),
        fakeyaw = ui.new_combobox(tab, container, 'Fake yaw', {'Static'}),
        fakeyawslider = ui.new_slider(tab, container, '\n', 0, 60, 60)
    }
end

ref.roll[0] = {
	player_state = ui.new_combobox(tab, container, 'Roll player state', vars.player_states)
}

for i = 1, 5 do 
    ref.roll[i] = {
        roll = ui.new_slider('AA', 'Anti-aimbot angles', '\n' .. vars.player_states[i], -50, 50, 0, true)
	}
end

local function contains(table, key) 
    for index, value in pairs(table) do 
        if value == key then 
            return true 
        end 
    end 
    return false 
end

local function SetTableVisibility(table, condition)
    for k, v in pairs(table) do
        if (type(v) == 'table') then
            SetTableVisibility(v, condition)
        else 
            ui.set_visible(v, condition)
        end
    end
end

local function get_entity_dist() -- if needed will change later for calculating other entitys
    local local_player = entity.get_local_player()
    local enemies = entity.get_players(true)
    local local_pos = vector(local_player:get_prop('m_vecOrigin'))
    local enemy_pos = vector(enemies:get_prop('m_vecOrigin'))

    local distance = local_pos:dist(enemy_pos)

    return distance
end

local function entity_weapon_class() -- if needed will change later for calculating other entitys
    local local_player = entity.get_local_player()
    local enemies = entity.get_players(true)
    local weapon = entity.get_player_weapon(local_player)
    local weapon_cs = csgo_weapons(weapon)
    if weapon == nil then return end
	if weapon_cs == nil then return end

    local class_name = weapon_cs.type

    return class_name
end

local spamtime = 0
local z = false
local function switch_values(int1, int2)
    local tabletest = {
        [true] = int1,
        [false] = int2
    }
    if globals.realtime() >= spamtime then
        z = not z
        spamtime = globals.realtime() + 0.025
    end
    return tabletest[z]
end

local function str_to_sub(input, sep)
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string.gsub(str, "\n", "")
	end
	return t
end

local function set_aa(state, type0, pitch, yawbase, yaw, yawvalue, yawjitter, yawjittervalue, bodyyaw, bodyyawvalue, fake, yawaddbool, yawaddleft, yawaddright, freestand)
    local local_player = entity.get_local_player()
    local delta = (math.floor(((entity.get_prop(local_player, 'm_flPoseParameter', 11) or 0)*120-60+0.5) * (10^(1 or 0)) + 0.5) / (10^(1 or 0))) -- taken from my old lua

    if state and type0 then
        ui.set(ref.aa.pitch, pitch)
        ui.set(ref.aa.yawbase, yawbase)
        ui.set(ref.aa.yaw[1], yaw)
        ui.set(ref.aa.yawjitter[1], yawjitter)
        ui.set(ref.aa.yawjitter[2], yawjittervalue)
        ui.set(ref.aa.bodyyaw[1], bodyyaw)
        ui.set(ref.aa.bodyyaw[2], bodyyawvalue)

        if yawaddbool then
            if delta > 0 then
                ui.set(ref.aa.yaw[2], yawaddleft)
            else
                ui.set(ref.aa.yaw[2], yawaddright)
            end
        else
            ui.set(ref.aa.yaw[2], yawvalue)
        end

        
        if freestand then
            ui.set(ref.aa.freestand[2], 'Always on')
            ui.set(ref.aa.freestand[1], true)
        else
            ui.set(ref.aa.freestand[2], 'Always on')
            ui.set(ref.aa.freestand[1], false)

            if freestandingbodyyaw then
                ui.set(ref.aa.freestandbodyyaw, true)
            else
                ui.set(ref.aa.freestandbodyyaw, false)
            end
        end
    end
end

local function player_states(cmd)
    local local_player = entity.get_local_player()
    local enemies = entity.get_players(true)
    local x, y = entity.get_prop(local_player, 'm_vecVelocity')
    local speed = x ~= nil and math.floor(math.sqrt( x * x + y * y + 0.5 )) or 0
    local in_air = bit.band(entity.get_prop(entity.get_local_player(), 'm_fFlags'), 1) == 0
    local on_ground = entity.get_prop(local_player, 'm_fFlags') == 257
    local crouching_in_air = entity.get_prop(local_player, 'm_fFlags') == 262
    local crouching = entity.get_prop(local_player, 'm_flDuckAmount') > 0.5 and not fake_duck
    local slowwalk = ui.get(ref.other.slowmotion[2])
    local fakelag = not anti_aim.get_double_tap() and not ui.get(ref.exploits.doubletap[2])
    local fake_duck = ui.get(ref.exploits.fakeduck)
    local stand = speed < 2 and not in_air and not crouching
    local move = speed > 2 and not in_air and not slowwalk
    local state = ''

    if stand then
        state = 'STAND'
    elseif in_air and not fakelag then
        state = 'IN-AIR'
    elseif crouching_in_air and not fakelag then
        state = 'IN-AIR'
    elseif in_air or crouching_in_air and fakelag then
        state = 'IN-AIR [FL]'
    elseif move and not fakelag then
        state = 'MOVE'
    elseif move and fakelag then
        state = 'MOVE [FL]'
    elseif slowwalk then
        state = 'SLOW'
    elseif crouching then 
        state = 'CROUCH'
    end
    return state
end



local function main()
    if not ui.get(ref.main.enable) then return end
    local stand, air, airfl, move, movefl, slow, crouch = player_states() == 'STAND', player_states() == 'IN-AIR', player_states() == 'IN-AIR [FL]', player_states() == 'MOVE', player_states() == 'MOVE [FL]', player_states() == 'SLOW', player_states() == 'CROUCH'
    local tank, experimental, builder = ui.get(ref.main.aa_type) == 'Tank', ui.get(ref.main.aa_type) == 'Experimental', ui.get(ref.main.aa_type) == 'Builder'

    if contains(ui.get(ref.main.options), 'Anti-aim') then
        -- state, aa type, pitch, yawbase, yaw, yawvalue, yawjitter, yawjittervalue, bodyyaw, bodyyawvalue, fake, yawaddbool, yawaddleft, yawaddright, freestand(dont touch this)
        set_aa(stand, tank, 'Default', 'At targets', '180', 0, 'Off', 60, 'Static', -180, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(air, tank, 'Default', 'At targets', '180', 0, 'Center', client.random_int(60, 90), 'Jitter', 0, 60, true, 7, 14, ui.get(ref.main.freestand), false)
        set_aa(airfl, tank, 'Default', 'At targets', '180', 0, 'Center', client.random_int(60, 90), 'Jitter', 0, 60, true, 7, 14, ui.get(ref.main.freestand), false)
        set_aa(move, tank, 'Default', 'At targets', '180', 0, 'Center', 87, 'Jitter', 141, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(movefl, tank, 'Default', 'At targets', '180', 0, 'Center', 87, 'Jitter', 141, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(slow, tank, 'Default', 'At targets', '180', 0, 'Center', 60, 'Jitter', 0, 60, true, 18, -18, ui.get(ref.main.freestand), false)
        set_aa(crouch, tank, 'Default', 'At targets', '180', 0, 'Center', 14, 'Jitter', 0, 60, true, 0, 0, ui.get(ref.main.freestand), false)

        set_aa(stand, experimental, 'Default', 'At targets', '180', 0, 'Off', 60, 'Static', -180, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(air, experimental, 'Default', 'At targets', '180', 0, 'Center', 66, 'Jitter', -180, 60, true, 17, -8, ui.get(ref.main.freestand), false)
        set_aa(airfl, experimental, 'Default', 'At targets', '180', 0, 'Center', 53, 'Jitter', -180, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(move, experimental, 'Default', 'At targets', '180', 0, 'Center', 53, 'Jitter', 0, 60, true, -8, 17, ui.get(ref.main.freestand), false)
        set_aa(movefl, experimental, 'Default', 'At targets', '180', 0, 'Center', 73, 'Jitter', -180, 60, true, 0, 0, ui.get(ref.main.freestand), false)
        set_aa(slow, experimental, 'Default', 'At targets', '180', 0, 'Center', 60, 'Jitter', 0, 60, true, 18, -18, ui.get(ref.main.freestand), false)
        set_aa(crouch, experimental, 'Default', 'At targets', '180', 0, 'Center', 14, 'Jitter', 0, 60, true, 8, -5, ui.get(ref.main.freestand), false)

        -- [[ DO NOT TOUCH THE BUILDER ]]
        set_aa(stand, builder, ui.get(ref.builder[2].pitch), ui.get(ref.builder[2].yawbase), '180', ui.get(ref.builder[2].yaw), ui.get(ref.builder[2].yawjitter), ui.get(ref.builder[2].yawjitterslider), ui.get(ref.builder[2].bodyyaw), ui.get(ref.builder[2].bodyyawslider), ui.get(ref.builder[2].fakeyawslider), ui.get(ref.builder[2].yawtype) == 'Yaw add', ui.get(ref.builder[2].yaw), -ui.get(ref.builder[2].yaw), ui.get(ref.main.freestand))
        set_aa(air, builder, ui.get(ref.builder[6].pitch), ui.get(ref.builder[6].yawbase), '180', ui.get(ref.builder[6].yaw), ui.get(ref.builder[6].yawjitter), ui.get(ref.builder[6].yawjitterslider), ui.get(ref.builder[6].bodyyaw), ui.get(ref.builder[6].bodyyawslider), ui.get(ref.builder[6].fakeyawslider), ui.get(ref.builder[6].yawtype) == 'Yaw add', ui.get(ref.builder[6].yaw), -ui.get(ref.builder[6].yaw), ui.get(ref.main.freestand))
        set_aa(airfl, builder, ui.get(ref.builder[7].pitch), ui.get(ref.builder[7].yawbase), '180', ui.get(ref.builder[7].yaw), ui.get(ref.builder[7].yawjitter), ui.get(ref.builder[7].yawjitterslider), ui.get(ref.builder[7].bodyyaw), ui.get(ref.builder[7].bodyyawslider), ui.get(ref.builder[7].fakeyawslider), ui.get(ref.builder[7].yawtype) == 'Yaw add', ui.get(ref.builder[7].yaw), -ui.get(ref.builder[7].yaw), ui.get(ref.main.freestand))
        set_aa(move, builder, ui.get(ref.builder[3].pitch), ui.get(ref.builder[3].yawbase), '180', ui.get(ref.builder[3].yaw), ui.get(ref.builder[3].yawjitter), ui.get(ref.builder[3].yawjitterslider), ui.get(ref.builder[3].bodyyaw), ui.get(ref.builder[3].bodyyawslider), ui.get(ref.builder[3].fakeyawslider), ui.get(ref.builder[3].yawtype) == 'Yaw add', ui.get(ref.builder[3].yaw), -ui.get(ref.builder[3].yaw), ui.get(ref.main.freestand))
        set_aa(movefl, builder, ui.get(ref.builder[4].pitch), ui.get(ref.builder[4].yawbase), '180', ui.get(ref.builder[4].yaw), ui.get(ref.builder[4].yawjitter), ui.get(ref.builder[4].yawjitterslider), ui.get(ref.builder[4].bodyyaw), ui.get(ref.builder[4].bodyyawslider), ui.get(ref.builder[4].fakeyawslider), ui.get(ref.builder[4].yawtype) == 'Yaw add', ui.get(ref.builder[4].yaw), -ui.get(ref.builder[4].yaw), ui.get(ref.main.freestand))
        set_aa(slow, builder, ui.get(ref.builder[5].pitch), ui.get(ref.builder[5].yawbase), '180', ui.get(ref.builder[5].yaw), ui.get(ref.builder[5].yawjitter), ui.get(ref.builder[5].yawjitterslider), ui.get(ref.builder[5].bodyyaw), ui.get(ref.builder[5].bodyyawslider), ui.get(ref.builder[5].fakeyawslider), ui.get(ref.builder[5].yawtype) == 'Yaw add', ui.get(ref.builder[5].yaw), -ui.get(ref.builder[5].yaw), ui.get(ref.main.freestand))
        set_aa(crouch, builder, ui.get(ref.builder[1].pitch), ui.get(ref.builder[1].yawbase), '180', ui.get(ref.builder[1].yaw), ui.get(ref.builder[1].yawjitter), ui.get(ref.builder[1].yawjitterslider), ui.get(ref.builder[1].bodyyaw), ui.get(ref.builder[1].bodyyawslider), ui.get(ref.builder[1].fakeyawslider), ui.get(ref.builder[1].yawtype) == 'Yaw add', ui.get(ref.builder[1].yaw), -ui.get(ref.builder[1].yaw), ui.get(ref.main.freestand))
    end
end

local function export()
    local str = ''
    for i = 1, 7 do
        str = str .. tostring(ui.get(ref.builder[i].pitch)) .. '|'
        .. tostring(ui.get(ref.builder[i].yawbase)) .. '|'
        .. tostring(ui.get(ref.builder[i].yaw)) .. '|'
        .. tostring(ui.get(ref.builder[i].yawjitter)) .. '|'
        .. tostring(ui.get(ref.builder[i].yawjitterslider)) .. '|'
        .. tostring(ui.get(ref.builder[i].bodyyaw)) .. '|'
        .. tostring(ui.get(ref.builder[i].bodyyawslider)) .. '|'
        .. tostring(ui.get(ref.builder[i].fakeyawslider)) .. '|'
        .. tostring(ui.get(ref.builder[i].fakeyaw)) .. '|'
        .. tostring(ui.get(ref.builder[i].yawtype)) .. '|'
    end
    client.color_log(255, 151, 50, '[CHERNOBYL] Exported to clipboard!')
    local encoded = base64.encode(str, alphabet)
    clipboard.set(encoded)
end

local function import(input)
    local tbl = str_to_sub(input, '|')
    for i = 1, 7 do
        ui.set(ref.builder[i].pitch, tbl[1 + (10 * (i - 1))])
        ui.set(ref.builder[i].yawbase, tbl[2 + (10 * (i - 1))])
        ui.set(ref.builder[i].yaw, tbl[3 + (10 * (i - 1))])
        ui.set(ref.builder[i].yawjitter, tbl[4 + (10 * (i - 1))])
        ui.set(ref.builder[i].yawjitterslider, tbl[5 + (10 * (i - 1))])
        ui.set(ref.builder[i].bodyyaw, tbl[6 + (10 * (i - 1))])
        ui.set(ref.builder[i].bodyyawslider, tbl[7 + (10 * (i - 1))])
        ui.set(ref.builder[i].fakeyawslider, tbl[8 + (10 * (i - 1))])
        ui.set(ref.builder[i].fakeyaw, tbl[9 + (10 * (i - 1))])
        ui.set(ref.builder[i].yawtype, tbl[10 + (10 * (i - 1))])
    end
    client.color_log(255, 151, 50, '[CHERNOBYL] Imported from clipboard!')
end

local export_button = ui.new_button(tab, container, 'Export anti-aim', function()
    export()
end)

local import_button = ui.new_button(tab, container, 'Import anti-aim', function()
    import(base64.decode(clipboard.get()))
end)

local function render_text(x, y, r, g, b, a, type, text)
    if type then
        renderer.text(x, y, r, g, b, a, '-', nil, text)
    else
        renderer.text(x, y, 255, 255, 255, 255, '-', nil, text)
    end
end

local function indicators()
    if not ui.get(ref.main.enable) or not entity.is_alive(entity.get_local_player()) then return end
    local r, g, b, a = ui.get(ref.indicators.state_color)
    local r2, g2, b2, a2 = ui.get(ref.indicators.keys_color)
    if contains(ui.get(ref.main.options), 'Indicators') then
        renderer.text(x/2+10, y/2, 255, 255, 255, 255, '-', nil, 'CHERNOBYL')
    end
    if contains(ui.get(ref.main.options), 'Indicators') and contains(ui.get(ref.indicators.options), 'States') then
        renderer.text(x/2+10, y/2-10, r, g, b, a, '-', nil, player_states())
    end
    if contains(ui.get(ref.main.options), 'Indicators') and contains(ui.get(ref.indicators.options), 'Hotkeys') then
        render_text(x/2+10, y/2+10, r2, g2, b2, a2, ui.get(ref.exploits.doubletap[2]), 'DT')
        render_text(x/2+21, y/2+10, r2, g2, b2, a2, ui.get(ref.exploits.hideshots[2]), 'HS')
        render_text(x/2+33, y/2+10, r2, g2, b2, a2, ui.get(ref.other.force_baim), 'BAIM')
        render_text(x/2+53, y/2+10, r2, g2, b2, a2, ui.get(ref.other.safe_point), 'SP')
    end
end
    
local function handle_menu(hide_all)
    vars.active_i = vars.state_to_idx[ui.get(ref.roll[0].player_state)]
    vars.active_i2 = vars.state_to_idx2[ui.get(ref.builder[0].player_state)]

    local show_menu = tostring(hide_all) ~= 'hide'
    local aacorrect = contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable)
    local rollcorrect = contains(ui.get(ref.main.options), 'Exploits') and ui.get(ref.main.enable)
    
    for i = 1, 5 do
	    ui.set_visible(ref.roll[i].roll, vars.active_i == i and show_menu and rollcorrect)
    end
    for i = 1, 7 do
        ui.set_visible(ref.builder[i].pitch, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].yawbase, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].yaw, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].yawtype, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].yawjitter, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].yawjitterslider, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].bodyyaw, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].bodyyawslider, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].fakeyaw, vars.active_i2 == i and show_menu and aacorrect)
        ui.set_visible(ref.builder[i].fakeyawslider, vars.active_i2 == i and show_menu and aacorrect)
    end
end

local function handle_callbacks()
    ui.set_callback(ref.roll[0].player_state, handle_menu)
    ui.set_callback(ref.builder[0].player_state, handle_menu)
    for i = 1, 5 do
        if contains(ui.get(ref.main.options), 'Exploits') and ui.get(ref.main.enable) then
	    	ui.set_callback(ref.roll[i].roll, handle_menu)
        end
    end
    for i = 1, 7 do
        if contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable) then
            ui.set_visible(ref.builder[i].pitch, handle_menu)
            ui.set_visible(ref.builder[i].yawbase, handle_menu)
            ui.set_visible(ref.builder[i].yaw, handle_menu)
            ui.set_visible(ref.builder[i].yawtype, handle_menu)
            ui.set_visible(ref.builder[i].yawjitter, handle_menu)
            ui.set_visible(ref.builder[i].yawjitterslider, handle_menu)
            ui.set_visible(ref.builder[i].bodyyaw, handle_menu)
            ui.set_visible(ref.builder[i].bodyyawslider, handle_menu)
            ui.set_visible(ref.builder[i].fakeyaw, handle_menu)
            ui.set_visible(ref.builder[i].fakeyawslider, vhandle_menu)
        end
    end

    client.set_event_callback('paint_ui', function()
        if ui.get(ref.main.enable) then
            SetTableVisibility(ref.aa, not ui.get(ref.main.enable))
        end
        ui.set_callback(ref.main.enable, function()
            SetTableVisibility(ref.aa, not ui.get(ref.main.enable))
            SetTableVisibility({
                ref.main.options, 
                ref.roll[0].player_state, 
                ref.roll,
                ref.builder[0].player_state,
                ref.builder,
                ref.main.aa_type, 
                ref.indicators.options, 
                ref.indicators.state_label, 
                ref.indicators.state_color, 
                ref.indicators.keys_color, 
                ref.indicators.keys_label,
                import_button,
                export_button
        }, ui.get(ref.main.enable))
            SetTableVisibility(ref.roll, contains(ui.get(ref.main.options), 'Exploits') and ui.get(ref.main.enable))
            SetTableVisibility(ref.builder, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
            SetTableVisibility({ref.main.aa_type, ref.main.freestand}, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.enable))
            SetTableVisibility({ref.indicators.options}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable))
            SetTableVisibility(ref.builder, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
            SetTableVisibility({ref.indicators.state_label, ref.indicators.state_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'States'))
            SetTableVisibility({ref.indicators.keys_label, ref.indicators.keys_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'Hotkeys'))
            SetTableVisibility({import_button, export_button}, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
        end)
        
        ui.set_callback(ref.main.options, function()
            SetTableVisibility(ref.roll, contains(ui.get(ref.main.options), 'Exploits') and ui.get(ref.main.enable))
            SetTableVisibility(ref.builder, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
            SetTableVisibility({ref.main.aa_type, ref.main.freestand}, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.enable))
            SetTableVisibility({ref.indicators.options}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable))
            SetTableVisibility({ref.indicators.state_label, ref.indicators.state_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'States'))
            SetTableVisibility({ref.indicators.keys_label, ref.indicators.keys_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'Hotkeys'))
            SetTableVisibility({import_button, export_button}, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
        end)
    
        ui.set_callback(ref.main.aa_type, function()
            SetTableVisibility(ref.builder, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
            SetTableVisibility({import_button, export_button}, contains(ui.get(ref.main.options), 'Anti-aim') and ui.get(ref.main.aa_type) == 'Builder' and ui.get(ref.main.enable))
        end)
    
        ui.set_callback(ref.indicators.options, function()
            SetTableVisibility({ref.indicators.state_label, ref.indicators.state_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'States'))
            SetTableVisibility({ref.indicators.keys_label, ref.indicators.keys_color}, contains(ui.get(ref.main.options), 'Indicators') and ui.get(ref.main.enable) and contains(ui.get(ref.indicators.options), 'Hotkeys'))
        end)

        client.set_event_callback('setup_command', main)
        client.set_event_callback('paint', indicators)

        handle_menu(nil)
    end)
end
handle_callbacks()