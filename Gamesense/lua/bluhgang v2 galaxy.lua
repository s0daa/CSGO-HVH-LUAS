local ffi = require('ffi')
local vector = require('vector')

local aa_funcs = require 'gamesense/antiaim_funcs' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=29665')
local images = require 'gamesense/images' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=22917')

---------------------------------------------
--[LOCALS]
---------------------------------------------

local aa_config = { 'Global', 'Stand', 'Slow motion', 'Moving' , 'Air', 'Air duck', 'Duck T', 'Duck CT' }
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local rage = {}
local logs_txt = {}
local active_idx = 1
local last_anti = 0

local state_to_num = { 
    ['Global'] = 1, 
    ['Stand'] = 2, 
    ['Slow motion'] = 3, 
    ['Moving'] = 4,
    ['Air'] = 5,
    ['Air duck'] = 6,
    ['Duck T'] = 7,
    ['Duck CT'] = 8, 
}


---------------------------------------------
--[REFERENCES]
---------------------------------------------
local ref = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = ui.reference('AA', 'Anti-aimbot angles', 'pitch'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fakeyawlimit = ui.reference('AA', 'anti-aimbot angles', 'Fake yaw limit'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    maxprocticks = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui.reference('RAGE', 'Other', 'Force body aim'),
	roll = ui.reference('aa', 'Anti-aimbot angles', 'Roll'),
	player_list = ui.reference('PLAYERS', 'Players', 'Player list'),
	reset_all = ui.reference('PLAYERS', 'Players', 'Reset all'),
	apply_all = ui.reference('PLAYERS', 'Adjustments', 'Apply to all'),
	load_cfg = ui.reference('Config', 'Presets', 'Load'),
	fl_limit = ui.reference('AA', 'Fake lag', 'Limit'),
    dt_limit = ui.reference('RAGE', 'Other', 'Double tap fake lag limit'),
    dmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
    bhop = ui.reference('MISC', 'Movement', 'Bunny hop'),
	maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),

    --[1] = combobox/checkbox | [2] = slider/hotkey
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	quickpeek = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding', 'Default') },
	os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') },
	dt = { ui.reference('RAGE', 'Other', 'Double tap') },
	fakelag = { ui.reference('AA', 'Fake lag', 'Enabled') }
}

---------------------------------------------
--[REFERENCES]
---------------------------------------------

---------------------------------------------
--[MENU ELEMENTS]
---------------------------------------------

--[GLOBAL] color
local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

--local colours.lightblue = '\a'..rgbToHex(181, 209, 255)..'ff' --database.read('enterprise_color') ~= nil and database.read('enterprise_color') or rgbToHex(196, 217, 255)

local colours = {

	lightblue = '\a'..rgbToHex(181, 209, 255)..'ff',
	darkerblue = '\a9AC9FFFF',
	grey = '\a898989FF',
	red = '\aff441fFF',
	default = '\ac8c8c8FF',
}

local username = _G.obex_name == nil and 'Admin' or _G.obex_name
local build_get = _G.obex_build == nil and 'STABLE' or _G.obex_build
local build = build_get:lower()

local enterprise = {
	luaenable = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Enable ' .. colours.red .. '1Mafia.lua' .. colours.default .. ' [' .. colours.red .. build .. colours.default .. ']'),
	tabselect = ui.new_combobox('AA','Anti-aimbot angles', 'lua menu', 'Anti-Aim', 'Visuals', 'Misc'),

	main = {
		main_space = ui.new_label('AA', 'Anti-aimbot angles', '  '),
		main_label1 = ui.new_label('AA', 'Anti-aimbot angles', colours.lightblue .. '               1Maf' .. colours.default .. 'ia.lua'),
		main_label2 = ui.new_label('AA', 'Anti-aimbot angles', colours.default .. '                     --[' .. colours.lightblue .. build .. colours.default .. ']--'),
		main_label3 = ui.new_label('AA', 'Anti-aimbot angles', colours.default .. '                    user~ ' .. colours.lightblue .. username),
		main_label4 = ui.new_label('AA', 'Anti-aimbot angles', colours.default .. '            Last update 15/07/2022'),
		main_space1 = ui.new_label('AA', 'Anti-aimbot angles', '  '),
		main_settings = ui.new_multiselect('AA','Anti-aimbot angles', 'Anti-Aim Enhancements', 'Force Defensive', 'Force Roll', 'Legit AA', 'Edge-yaw', 'Freestand', 'Manual AA'),
	},

	antiaim = {
		aa_presets = ui.new_combobox('AA','Anti-aimbot angles', 'AA Preset', 'Aggressive', 'Defensive', 'Experemental'),
		aa_condition = ui.new_combobox('AA','Anti-aimbot angles', 'Anti-Aim Conditions', aa_config),
		fl_limitslider = ui.new_slider("AA", "Fake lag", "Limit ", 1, 15, 15, true),
		
	},

	visual = {

		indicator_enable = ui.new_checkbox('AA','Anti-aimbot angles', '» enable ' .. colours.red ..'indicators' .. colours.red .. ''),
		indicator_select = ui.new_multiselect('AA','Anti-aimbot angles', 'Indicators', 'Crosshair indicators'),
		indicator_style = ui.new_combobox('AA', 'Anti-aimbot angles', 'Crosshair indicator style', {'Pixel', 'Ideal yaw', 'Old'}),
		indicator_opt_deafult = ui.new_multiselect('AA','Anti-aimbot angles', 'Display keybinds', 'Dynamic Indicators', 'AA States', 'Double tap', 'Hide shots', 'Force body aim'),
		indicator_opt_pixel = ui.new_multiselect('AA','Anti-aimbot angles', 'Display keybinds', 'Dynamic Indicators', 'Keybinds'),
		indicator_check = ui.new_label('AA', 'Anti-aimbot angles', 'Indicator colours'),
		indicator_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator colours', 255, 79, 66),

		enablenotifications = ui.new_checkbox('AA','Anti-aimbot angles', '» enable ' .. colours.red ..'notifications'),
		notification_system = ui.new_multiselect('AA','Anti-aimbot angles', 'Notification system', 'Hit/Miss Notifications', 'Console logs'),
		notification_style =  ui.new_combobox('AA', 'Anti-aimbot angles', 'Notification Style', {'Top bar', 'Dark mode'}),
		hitcol_labe1l = ui.new_label('AA', 'Anti-aimbot angles', 'Hitlog colour'),
		notification_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator colours', 255, 79, 66),
		hitcol_label = ui.new_label('AA', 'Anti-aimbot angles', 'Hit colour'),
		hitcol = ui.new_color_picker('AA','Anti-aimbot angles', 'Hit colour', 181, 209, 255, 255),
		misscol_label = ui.new_label('AA', 'Anti-aimbot angles', 'Miss colour'),
		misscol = ui.new_color_picker('AA','Anti-aimbot angles', 'Miss colour', 255, 101, 128, 255),

		solus_enable = ui.new_checkbox('AA','Anti-aimbot angles', '» enable ' .. colours.red ..'keybinds'),
		watermark = ui.new_checkbox('AA', 'Anti-aimbot angles', colours.grey .. ' ~' .. colours.default .. ' watermark'),
		keybind = ui.new_checkbox('AA', 'Anti-aimbot angles',colours.grey .. ' ~' .. colours.default .. ' keybinds'),
		spectator = ui.new_checkbox('AA', 'Anti-aimbot angles',colours.grey .. ' ~' .. colours.default .. ' spectators'),
		onscreen_design = ui.new_combobox('AA', 'Anti-aimbot angles', 'Solus Style', {'Top bar', 'Dark mode'}),
		solus_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Solus colours', 255, 79, 66),
	},

	keybinds = {
		key_defensive = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Force Defensive'),
		key_roll = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Force Roll'),
		key_legit = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Legit AA'),
		key_edge_yaw = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Edge-yaw'),
		key_freestand = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Freestanding'),
		key_forward = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Forward'),
		key_back = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Back'),
		key_left = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Left'),
		key_right = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Right'),
	},

    misc = {
		dtenable = ui.new_checkbox('AA', 'Anti-aimbot angles', '» enable ' .. colours.red ..'doubletap enhancements' .. colours.red .. ''),
		dtspeed = ui.new_combobox('AA', 'Anti-aimbot angles', 'enhance dt speed', {'Default', 'Fast', 'Fastest'}),
		osfix = ui.new_checkbox('AA', 'Anti-aimbot angles', '» enable ' .. colours.red ..'hideshots fix' .. colours.red ..''),
	},
}

---------------------------------------------
--[ANTI-AIM]
---------------------------------------------

local function set_menu_color()
    local r, g, b = ui.get(enterprise.colorpicker)
    colours.lightblue = '\a'..rgbToHex(r, g, b)..'ff'
end

for i=1, #aa_config do
    
    local cond = colours.red .. 'state~' .. colours.red .. string.lower(aa_config[i]) .. colours.lightblue .. ' ' .. colours.default

    rage[i] = {
        c_enabled = ui.new_checkbox('aa', 'anti-aimbot angles', 'Enable ' .. aa_config[i] .. ' config'),
        c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        c_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw base', {'Local view','At targets'}),
        c_yaw = ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        c_yaw_sli = ui.new_slider('aa', 'anti-aimbot angles', '\n' .. cond .. ' yaw sli', -180, 180, 0, true, '°', 1),

        c_jitter = ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw jitter', {'Off','Offset','Center','Random'}),
        c_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', '\n' .. cond .. 'jitter sli', -180, 180, 0, true, '°', 1),
        c_body = ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Body yaw', {'Off','Opposite','Jitter','Static'}),
        c_body_sli = ui.new_slider('aa', 'anti-aimbot angles', '\n' .. cond .. 'body sli', -180, 180, 0, true, '°', 1),
        c_free_b_yaw = ui.new_checkbox('aa', 'anti-aimbot angles', cond .. 'Freestanding body yaw'),
        c_lby_limit = ui.new_slider('aa', 'anti-aimbot angles', cond .. 'Fake yaw limit', 0, 60, 60, true, '°', 1),
        c_roll = ui.new_slider('AA', 'anti-aimbot angles', cond .. 'Roll AA', -50, 50, 0, true, '°', 1),

        adv_combo = ui.new_multiselect('AA', 'Anti-aimbot angles', cond .. 'Advanced Settings', {'Fluctuate Fake yaw limit', 'L/R YAW'}),
        min_mfy = ui.new_slider('AA', 'Anti-aimbot angles', cond ..  '[MIN] Fake yaw limit', 0, 60, 0, true, '°'),
        max_mfy = ui.new_slider('AA', 'Anti-aimbot angles', cond .. '[MAX] Fake yaw limit', 0, 60, 0, true, '°'),
        l_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond .. 'Left yaw', -180, 180, 0, true, '°'),
        r_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond .. 'Right yaw', -180, 180, 0, true, '°')
    }


end

local function contains(table, val)
    if #table > 0 then 
        for i=1, #table do
            if table[i] == val then
                return true
            end
        end
    end
    return false
end


---------------------------------------------
--[MENU ELEMENTS]
---------------------------------------------

local function hide_original_menu(state)
    --OG MENU
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
    ui.set_visible(ref.roll, state)
    ui.set_visible(ref.freestand[1], state)
    ui.set_visible(ref.freestand[2], state)
	ui.set_visible(ref.fl_limit, state)
end

local function set_lua_menu()
    local lua_enabled = ui.get(enterprise.luaenable)

    ui.set_visible(enterprise.tabselect, lua_enabled)

    --returns true or false
    local select_main = ui.get(enterprise.tabselect) == 'Main' and lua_enabled
    local select_aa = ui.get(enterprise.tabselect) == 'Anti-Aim' and lua_enabled
    local select_visuals = ui.get(enterprise.tabselect) == 'Visuals' and lua_enabled
    local select_misc = ui.get(enterprise.tabselect) == 'Misc' and lua_enabled

	--------------
	-- MAIN
	--------------
    ui.set_visible(enterprise.main.main_label1, select_main)
	ui.set_visible(enterprise.main.main_label2, select_main)
	ui.set_visible(enterprise.main.main_label3, select_main)
	ui.set_visible(enterprise.main.main_label4, select_main)
	ui.set_visible(enterprise.main.main_space, select_main)
	ui.set_visible(enterprise.main.main_space1, select_main)
    ui.set_visible(enterprise.main.main_settings, select_main)
	ui.set_visible(enterprise.keybinds.key_defensive, select_main and contains(ui.get(enterprise.main.main_settings), 'Force Defensive'))
    ui.set_visible(enterprise.keybinds.key_roll, select_main and contains(ui.get(enterprise.main.main_settings), 'Force Roll'))
    ui.set_visible(enterprise.keybinds.key_edge_yaw, select_main and contains(ui.get(enterprise.main.main_settings), 'Edge-yaw'))
    ui.set_visible(enterprise.keybinds.key_legit, select_main and contains(ui.get(enterprise.main.main_settings), 'Legit AA'))
    ui.set_visible(enterprise.keybinds.key_freestand, select_main and contains(ui.get(enterprise.main.main_settings), 'Freestand'))
    local manual_aa = contains(ui.get(enterprise.main.main_settings), 'Manual AA')
    ui.set_visible(enterprise.keybinds.key_forward, select_main and manual_aa)
	ui.set_visible(enterprise.keybinds.key_back, select_main and manual_aa)
    ui.set_visible(enterprise.keybinds.key_left, select_main and manual_aa)
    ui.set_visible(enterprise.keybinds.key_right, select_main and manual_aa)
    
	--------------
	-- ANTI-AIM
	--------------
    ui.set_visible(enterprise.antiaim.aa_condition, select_aa)
	ui.set_visible(enterprise.antiaim.fl_limitslider, ui.get(enterprise.luaenable))

	--------------
	-- VISUAL
	--------------

	ui.set_visible(enterprise.visual.indicator_enable, select_visuals)
    ui.set_visible(enterprise.visual.indicator_select, select_visuals and ui.get(enterprise.visual.indicator_enable))
	ui.set_visible(enterprise.visual.indicator_style, select_visuals and ui.get(enterprise.visual.indicator_enable) and contains(ui.get(enterprise.visual.indicator_select), 'Crosshair indicators'))
    ui.set_visible(enterprise.visual.indicator_opt_deafult, select_visuals and ui.get(enterprise.visual.indicator_enable) and contains(ui.get(enterprise.visual.indicator_select), 'Crosshair indicators') and ui.get(enterprise.visual.indicator_style) == 'Old')
	ui.set_visible(enterprise.visual.indicator_opt_pixel, select_visuals and ui.get(enterprise.visual.indicator_enable) and contains(ui.get(enterprise.visual.indicator_select), 'Crosshair indicators') and ui.get(enterprise.visual.indicator_style) == 'Pixel')
    ui.set_visible(enterprise.visual.indicator_col, select_visuals and ui.get(enterprise.visual.indicator_enable) and contains(ui.get(enterprise.visual.indicator_select), 'Crosshair indicators') and ui.get(enterprise.visual.indicator_style) == 'Old' or ui.get(enterprise.visual.indicator_style) == 'Pixel')

	ui.set_visible(enterprise.visual.indicator_check, select_visuals and ui.get(enterprise.visual.indicator_select) and ui.get(enterprise.visual.indicator_enable))
	ui.set_visible(enterprise.visual.indicator_col, select_visuals and ui.get(enterprise.visual.indicator_select) and ui.get(enterprise.visual.indicator_enable))
	ui.set_visible(enterprise.visual.enablenotifications, select_visuals)
	ui.set_visible(enterprise.visual.notification_system, select_visuals and ui.get(enterprise.visual.enablenotifications))
	ui.set_visible(enterprise.visual.hitcol_labe1l, select_visuals and ui.get(enterprise.visual.enablenotifications) and ui.get(enterprise.visual.notification_style) == 'Top bar')
	ui.set_visible(enterprise.visual.notification_col, select_visuals and ui.get(enterprise.visual.enablenotifications) and ui.get(enterprise.visual.notification_style) == 'Top bar')
	ui.set_visible(enterprise.visual.notification_style, select_visuals and ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), 'Hit/Miss Notifications'))
	ui.set_visible(enterprise.visual.hitcol_label, select_visuals and ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), 'Hit/Miss Notifications') and ui.get(enterprise.visual.notification_style) == 'Dark mode')
	ui.set_visible(enterprise.visual.misscol_label, select_visuals and ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), 'Hit/Miss Notifications') and ui.get(enterprise.visual.notification_style) == 'Dark mode')
	ui.set_visible(enterprise.visual.hitcol, select_visuals and ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), 'Hit/Miss Notifications') and ui.get(enterprise.visual.notification_style) == 'Dark mode')
	ui.set_visible(enterprise.visual.misscol, select_visuals and ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), 'Hit/Miss Notifications') and ui.get(enterprise.visual.notification_style) == 'Dark mode')

	ui.set_visible(enterprise.visual.solus_enable, select_visuals)
    ui.set_visible(enterprise.visual.watermark, select_visuals and ui.get(enterprise.visual.solus_enable))
    ui.set_visible(enterprise.visual.spectator, select_visuals and ui.get(enterprise.visual.solus_enable))
    ui.set_visible(enterprise.visual.keybind, select_visuals and ui.get(enterprise.visual.solus_enable))
	ui.set_visible(enterprise.visual.onscreen_design, (ui.get(enterprise.visual.watermark) and ui.get(enterprise.visual.solus_enable) and select_visuals) or (ui.get(enterprise.visual.spectator) and ui.get(enterprise.visual.solus_enable) and select_visuals) or (ui.get(enterprise.visual.keybind) and ui.get(enterprise.visual.solus_enable) and select_visuals))
	ui.set_visible(enterprise.visual.solus_col, select_visuals and ui.get(enterprise.visual.solus_enable))


	ui.set_visible(enterprise.misc.dtenable, select_misc)
	ui.set_visible(enterprise.misc.dtspeed, select_misc and ui.get(enterprise.misc.dtenable))
	ui.set_visible(enterprise.misc.osfix, select_misc)
end
---------------------------------------------
--[MENU ELEMENTS]
---------------------------------------------

local xxx = 'Stand'
local function get_mode(e)
    -- 'Stand', 'Duck CT', 'Duck T', 'Moving', 'Air', Slow motion'
    local lp = entity.get_local_player()
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1 and e.in_jump == 0
    local not_moving = velocity < 2

    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')

    local ct      = teamnum == 3
    local t       = teamnum == 2

    if not ui.get(ref.bhop) then
        on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1
    end
    
    if not on_ground then
        xxx = ((entity.get_prop(lp, 'm_flDuckAmount') > 0.7) and ui.get(rage[state_to_num['Air duck']].c_enabled)) and 'Air duck' or 'Air'
    else
        if ui.get(ref.fakeduck) or (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
            if ct then 
                xxx = 'Duck CT'
            elseif t then
                xxx = 'Duck T'
            end
        elseif not_moving then
            
            xxx = 'Stand'
        elseif not not_moving then
            if slowwalk_key then
    
                xxx = 'Slow motion'
            else
    
                xxx = 'Moving'
            end
        end
    end

    return xxx

end


local function handle_menu()
    local enabled = ui.get(enterprise.luaenable) and ui.get(enterprise.tabselect) == 'Anti-Aim'
    ui.set_visible(enterprise.antiaim.aa_condition, enabled)

    for i=1, #aa_config do
        local show = ui.get(enterprise.antiaim.aa_condition) == aa_config[i] and enabled 
		ui.set_visible(enterprise.antiaim.aa_presets,show)
        ui.set_visible(rage[i].c_enabled, show and i > 1)
        ui.set_visible(rage[i].c_pitch,show)
        ui.set_visible(rage[i].c_yawbase,show)
        ui.set_visible(rage[i].c_yaw,show)
        ui.set_visible(rage[i].c_yaw_sli, show and ui.get(rage[i].c_yaw) ~= 'Off' and not contains(ui.get(rage[i].adv_combo), 'L/R YAW'))
        
        ui.set_visible(rage[i].c_jitter, show)
        ui.set_visible(rage[i].c_jitter_sli, show and ui.get(rage[i].c_jitter) ~= 'Off')
        ui.set_visible(rage[i].c_body,show)
        ui.set_visible(rage[i].c_body_sli,show and (ui.get(rage[i].c_body) ~= 'Off' and ui.get(rage[i].c_body) ~= 'Opposite'))
        ui.set_visible(rage[i].c_free_b_yaw, show)

        ui.set_visible(rage[i].c_lby_limit, show and not contains(ui.get(rage[i].adv_combo), 'Fluctuate Fake yaw limit'))
        ui.set_visible(rage[i].c_roll, show)
        ui.set_visible(rage[i].adv_combo, show )
        ui.set_visible(rage[i].min_mfy, show and contains(ui.get(rage[i].adv_combo), 'Fluctuate Fake yaw limit'))
        ui.set_visible(rage[i].max_mfy, show and contains(ui.get(rage[i].adv_combo), 'Fluctuate Fake yaw limit'))
        ui.set_visible(rage[i].l_limit, show and contains(ui.get(rage[i].adv_combo), 'L/R YAW'))
        ui.set_visible(rage[i].r_limit, show and contains(ui.get(rage[i].adv_combo), 'L/R YAW'))
    end
end
handle_menu()

local function handle_keybinds()
    local freestand = ui.get(enterprise.keybinds.key_freestand)
    ui.set(ref.freestand[1], freestand and 'Default' or '')
    ui.set(ref.freestand[2], freestand and 0 or 2)
end


---------------------------------------------
--[ANTI-AIM]
---------------------------------------------

---------------------------------------------
--[MISC]
---------------------------------------------
local base64 = function(string, type)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local string = tostring(string)

    if type == 1 then
        return ((string:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b:sub(c+1,c+1)
        end)..({ '', '==', '=' })[#string%3+1])
    elseif type == 0 then
        string = string.gsub(string, '[^'..b..'=]', '')
        return (string:gsub('.', function(x)
            if (x == '=') then return '' end
            local r,f='',(b:find(x)-1)
            for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
            return r;
        end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
            if (#x ~= 8) then return '' end
            local c=0
            for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
                return string.char(c)
        end))
    end
end

local VGUI_System010 =  client.create_interface('vgui2.dll', 'VGUI_System010')
local VGUI_System = ffi.cast(ffi.typeof('void***'), VGUI_System010)

ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local get_clipboard_text_count = ffi.cast('get_clipboard_text_count', VGUI_System[0][7])
local set_clipboard_text = ffi.cast('set_clipboard_text', VGUI_System[0][9])
local get_clipboard_text = ffi.cast('get_clipboard_text', VGUI_System[0][11])

local clipboard_import = function()
  	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	local clipboard_data = ''

	if clipboard_text_length > 0 then
		buffer = ffi.new('char[?]', clipboard_text_length)
		size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)

		get_clipboard_text( VGUI_System, 0, buffer, size )
		clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	end

	return clipboard_data
end

local clipboard_export = function(string)
	if string then
		set_clipboard_text(VGUI_System, string, #string)
	end
end

local import_cfg = function(to_import)
    pcall(function()
        local num_tbl = {}
        local settings = json.parse(clipboard_import())

        for key, value in pairs(settings) do
            if type(value) == 'table' then
                for k, v in pairs(value) do
                    if type(k) == 'number' then
                        table.insert(num_tbl, v)
                        ui.set(rage[key], num_tbl)
                    else
                        ui.set(rage[key][k], v)
                    end
                end
            else
                ui.set(rage[key], value)
            end
        end

        print('Imported anti-aim settings.')
    end)
end

local export_cfg = function()
    local settings = {}

    pcall(function()
        for key, value in pairs(rage) do
            if value then
                settings[key] = {}

                if type(value) == 'table' then
                    for k, v in pairs(value) do
                        settings[key][k] = ui.get(v)
                    end
                else
                    settings[key] = ui.get(value)
                end
            end
        end

        clipboard_export(json.stringify(settings))
        print('Exported anti-aim settings to clipboard.')
    end)
end
---------------------------------------------
--[MISC]
---------------------------------------------

---------------------------------------------
--[CLANTAG CHANGER]
---------------------------------------------

---------------------------------------------
--[LEGIT AA]
---------------------------------------------

local entity_has_c4 = function(ent)
	local bomb = entity.get_all('CC4')[1]
	return bomb ~= nil and entity.get_prop(bomb, 'm_hOwnerEntity') == ent
end

local distance_3d = function(x1, y1, z1, x2, y2, z2)
	return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local classnames = { 
    'CWorld', 
    'CCSPlayer', 
    'CFuncBrush' 
}

local aa_on_use = function(e)
    if not ui.get(enterprise.keybinds.key_legit) or not contains(ui.get(enterprise.main.main_settings), 'Legit AA') then 
        return 
    end

    local local_player = entity.get_local_player()
    
    local distance = 100
    local bomb = entity.get_all('CPlantedC4')[1]
    local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, 'm_vecOrigin')

    if bomb_x ~= nil then
        local player_x, player_y, player_z = entity.get_prop(local_player, 'm_vecOrigin')
        distance = distance_3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
    end
    
    local distance_h = 100
    local hostage = entity.get_all('CHostage')[1]
    local hostage_x, hostage_y, hostage_z = entity.get_prop(hostage, 'm_vecOrigin')
    
    if hostage_x ~= nil then
        local player_x, player_y, player_z = entity.get_prop(local_player, 'm_vecOrigin')
        distance_h = distance_3d(hostage_x, hostage_y, hostage_z, player_x, player_y, player_z)
    end
    
    local team_num = entity.get_prop(local_player, 'm_iTeamNum')
    local defusing_bomb = team_num == 3 and distance < 62
    local getting_hostage = team_num == 3 and distance_h < 62

    local on_bombsite = entity.get_prop(local_player, 'm_bInBombZone')
    
    local has_bomb = entity_has_c4(local_player)
    local planting_bomb = on_bombsite ~= 0 and team_num == 2 and has_bomb
	
    local eyepos = vector(client.eye_position())
    local pitch, yaw = client.camera_angles()

    local sin_pitch = math.sin(math.rad(pitch))
    local cos_pitch = math.cos(math.rad(pitch))
    local sin_yaw = math.sin(math.rad(yaw))
    local cos_yaw = math.cos(math.rad(yaw))

    local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
    local fraction, entindex = client.trace_line(local_player, eyepos.x, eyepos.y, eyepos.z, eyepos.x + (dir_vec[1] * 8192), eyepos.y + (dir_vec[2] * 8192), eyepos.z + (dir_vec[3] * 8192))

    local using = true

    if entindex ~= nil then
        for i=0, #classnames do
            if entity.get_classname(entindex) == classnames[i] then
                using = false
            end
        end
    end

    if not using and not planting_bomb and not defusing_bomb and not getting_hostage then
        e.in_use = 0
    end
end

---------------------------------------------
--[LEGIT AA]
---------------------------------------------

---------------------------------------------
--[MANUAL AA]
---------------------------------------------
local last_press_t_dir = 0
local yaw_direction = 0

local run_direction = function()
	ui.set(enterprise.keybinds.key_forward, 'On hotkey')
	ui.set(enterprise.keybinds.key_left, 'On hotkey')
	ui.set(enterprise.keybinds.key_back, 'On hotkey')
	ui.set(enterprise.keybinds.key_right, 'On hotkey')
    ui.set(ref.edgeyaw, ui.get(enterprise.keybinds.key_edge_yaw) and contains(ui.get(enterprise.main.main_settings), 'Edge-yaw'))

    ui.set(ref.freestand[1], ui.get(enterprise.keybinds.key_freestand) and 'Default' or '-')
    ui.set(ref.freestand[2], ui.get(enterprise.keybinds.key_freestand) and 'Always on' or 'On hotkey')

	if (ui.get(enterprise.keybinds.key_freestand) and contains(ui.get(enterprise.main.main_settings), 'Freestand')) or not contains(ui.get(enterprise.main.main_settings), 'Manual AA') then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if ui.get(enterprise.keybinds.key_forward) and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
			last_press_t_dir = globals.curtime()
		elseif ui.get(enterprise.keybinds.key_right) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals.curtime()
		elseif ui.get(enterprise.keybinds.key_left) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals.curtime()
		elseif ui.get(enterprise.keybinds.key_back) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 0 and 0 or 0
			last_press_t_dir = globals.curtime()
		elseif last_press_t_dir > globals.curtime() then
			last_press_t_dir = globals.curtime()
		end
	end
end
---------------------------------------------
--[MANUAL AA]
---------------------------------------------

---------------------------------------------
--[INDICATOR FUNCTIONS]
---------------------------------------------

local function doubletap_charged()
    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
	local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.5
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end



local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * globals.frametime() * speed 
    else 
        return name - (value + name) * globals.frametime() * speed -- add / 2 if u want goig back effect
        
    end
end


---------------------------------------------
--[INDICATOR FUNCTIONS]
---------------------------------------------

---------------------------------------------
--[Indicators]
---------------------------------------------
local xpos = 0
local xpos2 = 0
local xpos3 = 0
local xpos4 = 0
local xpos5 = 0
local indi_anim = 0

local function onscreen_elements()

    screen = {client.screen_size()}
	center = {screen[1]/2, screen[2]/2} 

	-------------------
	--DEFAULT LOCALS
	-------------------

	local spacing = 0 
    local indi_state = string.upper(xxx)
    local indi_desync = aa_funcs.get_desync(2)
    local acti_indi_state = ui.get(rage[state_to_num[xxx]].c_enabled) and indi_state or 'GLOBAL'
    local lp = entity.get_local_player()
    local r, g, b, a = ui.get(enterprise.visual.indicator_col)
	local indicatormaster = ui.get(enterprise.luaenable) and ui.get(enterprise.visual.indicator_enable)

	local scpd = entity.get_prop(lp, "m_bIsScoped")
    local scoped_default = ui.get(enterprise.visual.indicator_style) == 'Old' and contains(ui.get(enterprise.visual.indicator_opt_deafult), 'Dynamic Indicators') and scpd == 1

    xpos = animation(scoped_default, xpos, 20, 15)
	center[1] = center[1] + xpos

	-------------------
	--DEFAULT LOCALS
	-------------------

	-------------------
	--IDEALYAW LOCALS
	-------------------

	local isFreestanding = ui.get(ref.freestand[2])
	local local_player = entity.get_local_player()
	local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")	
	if active_weapon == nil then
		return
	end	
	local nextAttack = entity.get_prop(local_player,"m_flNextAttack") 
	local nextShot = entity.get_prop(active_weapon,"m_flNextPrimaryAttack")
	local nextShotSecondary = entity.get_prop(active_weapon,"m_flNextSecondaryAttack")
	if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
		return
	end
	nextAttack = nextAttack + 0.5
	nextShot = nextShot + 0.5
	nextShotSecondary = nextShotSecondary + 0.5

	-------------------
	--IDEALYAW LOCALS
	-------------------

	-------------------
	--PIXEL LOCALS
	-------------------

	local scoped_pixel = ui.get(enterprise.visual.indicator_style) == 'Pixel' and contains(ui.get(enterprise.visual.indicator_opt_pixel), 'Dynamic Indicators') and scpd == 1
	local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 3) * 3) * 75 + 150), 255)
	local body_yaw_pose_param = math.floor(entity.get_prop(lp, "m_flPoseParameter", 11) * 120) - 60
	local body_yaw = math.abs(body_yaw_pose_param)
	local body_yaw_percentage = body_yaw / 60
	local bar_width = (1 * body_yaw)

	local centerfunc = renderer.measure_text('-', acti_indi_state)
	local centerpixel = centerfunc / 2

	xpos2 = animation(scoped_pixel, xpos2, 20, 15)
	xpos3 = animation(scoped_pixel, xpos3, 17, 15)
	xpos4 = animation(scoped_pixel, xpos4, 16, 15)
	xpos5 = animation(scoped_pixel, xpos5, 13, 15)


	-------------------
	--PIXEL LOCALS
	-------------------
	
    if indicatormaster and entity.is_alive(lp) then   
        if contains(ui.get(enterprise.visual.indicator_select), 'Crosshair indicators') then
			if ui.get(enterprise.visual.indicator_style) == 'Old' then
				renderer.text(center[1] + 20, center[2] + 25, r, g, b, a,  'cb-', 0, '1MAFIA')

				if indi_desync > 0 then -- left

					renderer.rectangle(center[1] + 40 + xpos2, center[2] + 31, 32, 1, r, g, b, a)
					renderer.rectangle(center[1] + 8 + xpos2, center[2] + 31, 32, 1, 150, 150, 150, 255)
					renderer.gradient(center[1] + 72 + xpos2, center[2] + 31, 1, 6, r, g, b, a, r, g, b, 0, false)
					renderer.gradient(center[1] + 8 + xpos2, center[2] + 31, 1, 6, 150, 150, 150, 255, 255, 255, 255, 0, false)
					

				elseif indi_desync < 0 then -- right

					renderer.rectangle(center[1] + 40 + xpos2, center[2] + 31, 32, 1, 150, 150, 150, 255)
					renderer.rectangle(center[1] + 8 + xpos2, center[2] + 31, 32, 1, r, g, b, a)
					renderer.gradient(center[1] + 72 + xpos2, center[2] + 31, 1, 6, 150, 150, 150, 255, 150, 150, 150, 0, false)
					renderer.gradient(center[1] + 8 + xpos2, center[2] + 31, 1, 6,  r, g, b, a, r, g, b, 0, false)
				
				else
					renderer.rectangle(center[1] + 40 + xpos2, center[2] + 31, 32, 1, 150, 150, 150, 255)
					renderer.rectangle(center[1] + 8 + xpos2, center[2] + 31, 32, 1, 150, 150, 150, 255)
					renderer.gradient(center[1] + 72 + xpos2, center[2] + 31, 1, 6, 150, 150, 150, 255, 150, 150, 150, 0, false)
					renderer.gradient(center[1] + 8 + xpos2, center[2] + 31, 1, 6, 150, 150, 150, 255, 150, 150, 150, 0, false)
				end


				if contains(ui.get(enterprise.visual.indicator_opt_deafult), 'AA States') then
					renderer.text(center[1] + 38 + xpos2, center[2] + 37 + (spacing * 8), 150, 150, 150, 255,  "c-d", 0,  '[' .. acti_indi_state .. ']')
					spacing = spacing + 1

				end

				if contains(ui.get(enterprise.visual.indicator_opt_deafult), 'Double tap') and ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then

					if doubletap_charged() then
						renderer.text(center[1] + 33 + xpos2, center[2] + 37 + (spacing * 8), r, g, b, a, "c-d", 0, "DT")

					else
						renderer.text(center[1] + 33 + xpos2, center[2] + 37 + (spacing * 8), 145, 145, 145, 255, "c-d", 0, "DT")

					end

					local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
					local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.25
					local CHECK = entity.get_prop(weapon, "m_flNextPrimaryAttack")
					
					if CHECK == nil then return end
					
					local next_primary_attack = CHECK + 0.5
					
					if next_primary_attack - globals.curtime() < 0 and next_attack - globals.curtime() < 0 then
						lima = 1.4
					else
						lima = next_primary_attack - globals.curtime()
					end
					
					local CHECKCHECK = math.abs((lima * 10/6) - 1)

					renderer.circle_outline(center[1] + 45 + xpos2, center[2] + 37 + (spacing * 8), 150, 150, 150, CHECKCHECK == 1 and 1 or 255, 2.9, 270, 5, 1)
					renderer.circle_outline(center[1] + 45 + xpos2, center[2] + 37 + (spacing * 8), r, g, b, CHECKCHECK == 1 and 1 or 255, 2.9, 270, CHECKCHECK, 1)

					spacing = spacing + 1
				end

				if contains(ui.get(enterprise.visual.indicator_opt_deafult), 'Hide shots') and ui.get(ref.os[2]) then
					renderer.text(center[1] + 38 + xpos2, center[2] + 37 + (spacing * 8), r, g, b, 255, "c-d", 0, "HS")
					spacing = spacing + 1

				end

				if contains(ui.get(enterprise.visual.indicator_opt_deafult), 'Force body aim') and ui.get(ref.forcebaim)then
					renderer.text(center[1] + 38 + xpos2, center[2] + 37 + (spacing * 8), 255, 102, 117, 255, "c-d", 0, "BAIM")
					spacing = spacing + 1

				end

			elseif ui.get(enterprise.visual.indicator_style) == 'Ideal yaw' then
				center = {screen[1]/2, screen[2]/2} 

				renderer.text(center[1], center[2] + 35, 218, 118, 0, 255,'', 0, '1MAFIA YAW')

				if isFreestanding then
					renderer.text(center[1], center[2] + 35, 218, 118, 0, 255,'', 0, '1MAFIA YAW+')
				end

				if ui.get(ref.yawbase) == 'At targets' then
					renderer.text(center[1], center[2] + 45, 209, 139, 230, 255,'', 0, 'DYNAMIC')
				else
					renderer.text(center[1], center[2] + 45, 255, 0, 0, 255,'', 0, 'DEFAULT')
				end
				

				if ui.get(ref.dt[2]) then
					had_dt = true
					if math.max(nextShot,nextShotSecondary) < nextAttack then -- swapping
						if nextAttack - globals.curtime() > 0.00 then
							renderer.text(center[1], center[2] + 55 + (spacing * 8), 255, 0, 0, 255, '', 0, 'DT')
						else
							renderer.text(center[1], center[2] + 55 + (spacing * 8), 0, 255, 0, 255, '', 0, 'DT')

						end
						spacing = spacing + 1
					else -- shooting or just shot	
						if math.max(nextShot,nextShotSecondary) - globals.curtime() > 0.00  then
							renderer.text(center[1], center[2] + 55 + (spacing * 8), 255, 0, 0, 255, '', 0, 'DT')

						else
							if math.max(nextShot,nextShotSecondary) - globals.curtime() < 0.00  then
								renderer.text(center[1], center[2] + 55 + (spacing * 8), 0, 255, 0, 255, '', 0, 'DT')
							else
								renderer.text(center[1], center[2] + 55 + (spacing * 8), 0, 255, 0, 255, '', 0, 'DT')
							end
						end
						spacing = spacing + 1
					end
				end

				if ui.get(ref.os[2]) then
					renderer.text(center[1], center[2] + 55 + (spacing * 9), 209, 139, 230, 255, '', 0, 'AA')
				else
				
				end

				if ui.get(ref.os[2]) then
					renderer.text(center[1], center[2] + 55 + (spacing * 9), 209, 139, 230, 255, '', 0, 'AA')
				else
				
				end
				--	name allignment
				-- Debug + 60
				-- Beta + 57
				-- live + 55
			elseif ui.get(enterprise.visual.indicator_style) == 'Pixel' then
				renderer.text(center[1] + 23 + xpos2, center[2] + 20, 255, 255, 255, 255,'c-', 0, '1MAFIA')
				renderer.text(center[1] + 52 + xpos2, center[2] + 20, r, g, b, alpha_pulse,'c-', 0, 'STABLE')
				renderer.rectangle(center[1] + 17 + xpos3, center[2] + 25, bar_width, 2, r, g, b, 255)

				if contains(ui.get(enterprise.visual.indicator_opt_pixel), 'Dynamic Indicators') and scpd == 1 then
					renderer.text(center[1] + 26 - centerpixel + xpos5, center[2] + 27, r, g, b, 255,'-', 0, acti_indi_state)
					renderer.text(center[1] + 16 + xpos2, center[2] + 20, 255, 255, 255, 255,'c-', 0, '1MAFIA')
					renderer.rectangle(center[1] + 10 + xpos3, center[2] + 25, bar_width, 2, r, g, b, 255)
				else
					renderer.text(center[1] + 32 - centerpixel + xpos5, center[2] + 27, r, g, b, 255,'-', 0, acti_indi_state)
				end

				if contains(ui.get(enterprise.visual.indicator_opt_pixel), 'Keybinds') then

					if doubletap_charged() then
						renderer.text(center[1] + 13 + xpos4, center[2] + 40, r, g, b, 255,'c-', 0, 'DT')
					else
						renderer.text(center[1] + 13 + xpos4, center[2] + 40, 156, 156, 156, 255,'c-', 0, 'DT')
					end

					if ui.get(ref.os[2]) then
						renderer.text(center[1] + 24 + xpos4, center[2] + 40, r, g, b, 255,'c-', 0, 'OS')
					else
						renderer.text(center[1] + 24 + xpos4, center[2] + 40, 156, 156, 156, 255,'c-', 0, 'OS')
					end

					if ui.get(ref.safepoint) then 
						renderer.text(center[1] + 36 + xpos4, center[2] + 40, r, g, b, 255,'c-', 0, 'FS')
					else
						renderer.text(center[1] + 36 + xpos4, center[2] + 40, 156, 156, 156, 255,'c-', 0, 'FS')
					end

					if ui.get(ref.forcebaim) then
						renderer.text(center[1] + 52 + xpos4, center[2] + 40, r, g, b, 255,'c-', 0, 'BAIM')
					else
						renderer.text(center[1] + 52 + xpos4, center[2] + 40, 156, 156, 156, 255,'c-', 0, 'BAIM')
					end
				end
			end
        end
    end

    if ui.get(enterprise.keybinds.key_roll) and contains(ui.get(enterprise.main.main_settings), 'Force Roll') and contains(ui.get(enterprise.visual.indicator_select), 'ROLL') then
		if ui.get(ref.roll) > 0 or ui.get(ref.roll) < 0 then
       		renderer.indicator(162, 0, 20, 255, 'ROLL')
		end
    end
end



---------------------------------------------
--[INDICATORS]
---------------------------------------------

---------------------------------------------
--[DOUBLE TAP]
---------------------------------------------
local function doubletap_enhance()

	local doubletapmaster = ui.get(enterprise.misc.dtenable)

	if doubletapmaster then
		if ui.get(enterprise.misc.dtspeed) == 'Default' then
			ui.set(ref.maxusrcmdprocessticks, 16)
		elseif ui.get(enterprise.misc.dtspeed) == 'Fast' then
			ui.set(ref.maxusrcmdprocessticks, 17)
		else 
			ui.set(ref.maxusrcmdprocessticks, 18)
		end
	end

end

---------------------------------------------
--[DOUBLE TAP]
---------------------------------------------

---------------------------------------------
--[SOLUS]
---------------------------------------------

local function renderer_shit(x, y, w, r, g, b, a, edge_h, watermark)
    if edge_h == nil then 
		edge_h = 0 
	end

	if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then
		if watermark then
			-- backround
			renderer.rectangle(x+1, y+2, w-2, 2, 0, 0, 0, 35)
			renderer.rectangle(x, y+4, w, 15, 0, 0, 0, 35)
		end

		--topleft "rounding"
		renderer.circle_outline(x+5, y+4, r, g, b, a, 4, 180, 0.25, 2)
	
		--topright "rounding"
		renderer.circle_outline(x+w-5, y+4, r, g, b, a, 4, 270, 0.25, 2)

		--top line
		renderer.rectangle(x+5, y, w-10, 2, r, g, b, a)

		--left line that goes down after "rounding"
		renderer.gradient(x, y+4, 2, 9+edge_h, r, g, b, a, r, g, b, 0, false)

		--right line that goes down after "rounding"
		renderer.gradient(x+w-2, y+4, 2, 9+edge_h, r, g, b, a, r, g, b, 0, false)
	elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
		--center outline
		renderer.rectangle(x - 3, y , w + 6, 22, 25, 25, 25, easings.clamp(a - 160, 0, 255))

		--Center backround
		renderer.rectangle(x, y+3, w, 16, 25, 25, 25, a)
	end

end

local m_hotkeys, m_hotkeys_update = { }, true

local script_name = 'enterprise'
local database_name = 'enterprise'
local dragging_fn = function(name, base_x, base_y) return (function()local a={}local b,c,d,e,f,g,h,i,j,k,l,m,n,o;local p={__index={drag=function(self,...)local q,r=self:get()local s,t=a.drag(q,r,...)if q~=s or r~=t then self:set(s,t)end;return s,t end,set=function(self,q,r)local j,k=client.screen_size()ui.set(self.x_reference,q/j*self.res)ui.set(self.y_reference,r/k*self.res)end,get=function(self)local j,k=client.screen_size()return ui.get(self.x_reference)/self.res*j,ui.get(self.y_reference)/self.res*k end}}function a.new(u,v,w,x)x=x or 10000;local j,k=client.screen_size()local y=ui.new_slider('LUA','A',u..' window position',0,x,v/j*x)local z=ui.new_slider('LUA','A','\n'..u..' window position y',0,x,w/k*x)ui.set_visible(y,false)ui.set_visible(z,false)return setmetatable({name=u,x_reference=y,y_reference=z,res=x},p)end;function a.drag(q,r,A,B,C,D,E)if globals.framecount()~=b then c=ui.is_menu_open()f,g=d,e;d,e=ui.mouse_position()i=h;h=client.key_state(0x01)==true;m=l;l={}o=n;n=false;j,k=client.screen_size()end;if c and i~=nil then if(not i or o)and h and f>q and g>r and f<q+A and g<r+B then n=true;q,r=q+d-f,r+e-g;if not D then q=math.max(0,math.min(j-A,q))r=math.max(0,math.min(k-B,r))end end end;table.insert(l,{q,r,A,B})return q,r,A,B end;return a end)().new(name, base_x, base_y) end
local create_integer = function(b,c,d,e)return{min=b,max=c,init_val=d,scale=e,value=d}end
local item_count = function(b)if b==nil then return 0 end;if#b==0 then local c=0;for d in pairs(b)do c=c+1 end;return c end;return#b end
local notes = function(b)local c=function(d,e)local f={}for g in pairs(d)do table.insert(f,g)end;table.sort(f,e)local h=0;local i=function()h=h+1;if f[h]==nil then return nil else return f[h],d[f[h]]end end;return i end;local j={get=function(k)local l,m=0,{}for n,o in c(package.solus_notes)do if o==true then l=l+1;m[#m+1]={n,l}end end;for p=1,#m do if m[p][1]==b then return k(m[p][2]-1)end end end,set_state=function(q)package.solus_notes[b]=q;table.sort(package.solus_notes)end,unset=function()client_unset_event_callback('shutdown',callback)end}client.set_event_callback('shutdown',function()if package.solus_notes[b]~=nil then package.solus_notes[b]=nil end end)if package.solus_notes==nil then package.solus_notes={}end;return j end

local script_db = {
	watermark = {
		nickname = '',		
		beta_status = false,
		gc_state = true,
		style = create_integer(1, 4, 1, 1),
		suffix = nil,
	},

	spectators = {
        avatars = true,
		auto_position = true
	},

	keybinds = {
		{
			require = '',
			reference = { 'legit', 'aimbot', 'Enabled' },
			custom_name = 'Legit aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'legit', 'triggerbot', 'Enabled' },
			custom_name = 'Legit triggerbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Enabled' },
			custom_name = 'Rage aimbot',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'aimbot', 'Force safe point' },
			custom_name = 'Safe point',
			ui_offset = 1
		},


		{
			require = '',
			reference = { 'rage', 'other', 'Quick stop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Quick peek assist' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Force body aim' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Duck peek assist' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'rage', 'other', 'Double tap' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'rage', 'other', 'Anti-aim correction override' },
			custom_name = 'Resolver override',
			ui_offset = 1
		},


		{
			require = '',
			reference = { 'aa', 'anti-aimbot angles', 'Freestanding' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Slow motion' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'On shot anti-aim' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'aa', 'other', 'Fake peek' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'movement', 'Z-Hop' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Pre-speed' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Blockbot' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'movement', 'Jump at edge' },
			custom_name = '',
			ui_offset = 2
		},


		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Last second defuse' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Free look' },
			custom_name = '',
			ui_offset = 1
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Ping spike' },
			custom_name = '',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'misc', 'miscellaneous', 'Automatic grenade release' },
			custom_name = 'Grenade release',
			ui_offset = 2
		},

		{
			require = '',
			reference = { 'visuals', 'player esp', 'Activation type' },
			custom_name = 'Visuals',
			ui_offset = 1
		},
	},
}

local get_bar_color = function()
	local r, g, b, a = ui.get(enterprise.visual.solus_col)
	return r, g, b, a
end


local ms_classes = {
	watermark = function()
		local note = notes 'a_visual.watermark'
		local cstyle = { [1] = 'gamesense', [2] = 'enterprise' }

		local has_beta = pcall(ui.reference, 'misc', 'Settings', 'Hide from OBS')
		local get_name = _G.obex_name == nil and 'Admin' or _G.obex_name
		local get_gc_state = panorama.loadstring([[ return MyPersonaAPI.IsConnectedToGC() ]])

		local classptr = ffi.typeof('void***')
		local latency_ptr = ffi.typeof('float(__thiscall*)(void*, int)')

		local rawivengineclient = client.create_interface('engine.dll', 'VEngineClient014') or error('VEngineClient014 wasnt found', 2)
		local ivengineclient = ffi.cast(classptr, rawivengineclient) or error('rawivengineclient is nil', 2)
		local is_in_game = ffi.cast('bool(__thiscall*)(void*)', ivengineclient[0][26]) or error('is_in_game is nil')

		local g_paint_handler = function()
			local solusmaster = ui.get(enterprise.visual.solus_enable)
			local state = ui.get(enterprise.visual.watermark)
			local r, g, b, a = get_bar_color()
			local msping_col = '\a'..rgbToHex(r, g, b)..'ff'
			local watermark_grey = '\a'..rgbToHex(150, 150, 150)..'ff'

			note.set_state(state)

			note.get(function(id)
				local data_wm = script_db.watermark or { }
				local data_nickname = data_wm.nickname and tostring(data_wm.nickname) or ''
				local data_suffix = (data_wm.suffix and tostring(data_wm.suffix) or ''):gsub('', '')

				if data_wm.beta_status and has_beta and (not data_suffix or #data_suffix < 1) then
					data_suffix = ''
				end

				local sys_time = { client.system_time() }
				local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])

				local is_connected_to_gc = not data_wm.gc_state or get_gc_state()
				local gc_state = not is_connected_to_gc and '\x20\x20\x20\x20\x20' or ''

				local nickname = #data_nickname > 0 and data_nickname or get_name
				local suffix = ('%s%s'):format(
					cstyle[data_wm.style and data_wm.style.value or 1] or cstyle[1], 
					#data_suffix > 0 and (' [%s]'):format(data_suffix) or ''
				)
		
				local text = ('%s  %s  %s'):format(gc_state, nickname, actual_time)

                local watermarkk_t = '1Maf'
                local watermarkk_t2 = 'ia.lua'
				local watermarkk_t3 = '1Mafia.lua'
                local watermarkk_t4 = ' ['..build..']'


				if is_in_game(is_in_game) == true and solusmaster then
					local latency = client.latency()*1000

					local latency_text = latency > 5 and ('  delay: %dms'):format(latency) or 'Localhost'

					if ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
						latency_text = latency > 5 and (msping_col .. ' %d'.. watermark_grey .. 'ms'):format(latency) or msping_col ..'Localhost' .. watermark_grey
					end

					text = ('%s | %s | %s | %s'):format(gc_state, nickname, latency_text, actual_time)

                    local tc_x, tc_h = renderer.measure_text('', watermarkk_t)
                    local tc2_x, tc2_h = renderer.measure_text('', watermarkk_t2) 
					local tc3_x, tc3_h = renderer.measure_text('', watermarkk_t3)
					local tc4_x, tc4_h = renderer.measure_text('', watermarkk_t4) 

					local h, w = 18, renderer.measure_text(nil, tc_x .. " " .. text) + 8
					local x, y = client.screen_size(), 10 + (25*id)
		
					x = x - w - 10

					local move_x = 0
					if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then
						move_x = 75
					elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
						move_x = 90
					end


					renderer_shit(x - move_x - 4, y, w + move_x, r, g, b, 255, 2, true)
					local r, g, b, a = ui.get(enterprise.visual.solus_col)
					
					if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then

						renderer.text(x - move_x, y + 4, r, g, b, 255, '', 0, watermarkk_t)

						--prise
						renderer.text(x - move_x + tc_x, y + 4, 255, 255, 255, 255, '', 0, watermarkk_t2)

						--build
						renderer.text(x - move_x + tc_x + tc2_x, y + 4, r, g, b, 255, '', 0, watermarkk_t4)

						--render everything else
						renderer.text(x - move_x + tc_x + tc2_x + tc4_x, y + 4, 255, 255, 255, 255, '', 0, text)
					elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then

						renderer.text(x - move_x, y + 4, r, g, b, 255, '', 0, watermarkk_t3)

						--build
						renderer.text(x - move_x + tc3_x, y + 4, 150, 150, 150, 255, '', 0, watermarkk_t4)

						--render everything else
						renderer.text(x -move_x + tc3_x + tc4_x, y + 4, 150, 150, 150, 255, '', 0, text)
					end
					
					

					if not is_connected_to_gc then
						local realtime = globals.realtime()*1.5
					
						if realtime%2 <= 1 then
							renderer.circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, 0, realtime%1, 2)
						else
							renderer.circle_outline(x+10, y + 11, 89, 119, 239, 255, 5, realtime%1*370, 1-realtime%1, 2)
						end
					end
				end
			end)
		end

		client.set_event_callback('paint_ui', g_paint_handler)
	end,

    spectators = function()
		local screen_size = { client.screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Spectators', screen_size[1] / 1.385, screen_size[2] / 2)
		local m_alpha, m_active, m_contents, unsorted = 0, {}, {}, {}

		local get_spectating_players = function()
			local me = entity.get_local_player()

			local players, observing = { }, me
		
			for i = 1, globals.maxplayers() do
				if entity.get_classname(i) == 'CCSPlayer' then
					local m_iObserverMode = entity.get_prop(i, 'm_iObserverMode')
					local m_hObserverTarget = entity.get_prop(i, 'm_hObserverTarget')

                    if m_hObserverTarget ~= nil and m_hObserverTarget <= 64 and not entity.is_alive(i) and (m_iObserverMode == 4 or m_iObserverMode == 5) then
						if players[m_hObserverTarget] == nil then
							players[m_hObserverTarget] = { }
						end

						if i == me then
							observing = m_hObserverTarget
						end

                        table.insert(players[m_hObserverTarget], i)
					end
				end
			end

            return players, observing
		end

		local g_paint_handler = function()
			local data_sp = script_db.spectators or { }

			local master_switch = ui.get(enterprise.visual.spectator)
			local solusmaster = ui.get(enterprise.visual.solus_enable)
			local is_menu_open = ui.is_menu_open()
			local frames = 8 * globals.frametime()
		
			local latest_item = false
			local maximum_offset = 85
		
			local me = entity.get_local_player()
			local spectators, player = get_spectating_players()
		
			for i=1, 64 do 
				unsorted[i] = {
					idx = i,
					active = false
				}
			end

			if spectators[player] ~= nil then
				for _, spectator in pairs(spectators[player]) do
					unsorted[spectator] = { 
						idx = spectator,
						
						active = (function()
							if spectator == me then
								return false
							end

							return true
						end)(),

						avatar = (function()
							if not data_sp.avatars then
								return nil
							end
							local steam_id = entity.get_steam64(spectator)
							local avatar = images.get_steam_avatar(steam_id)
		
							if steam_id == nil or avatar == nil then
								return nil
							end

							if m_contents[spectator] == nil or m_contents[spectator].conts ~= avatar.contents then
								m_contents[spectator] = {
									conts = avatar.contents,
									texture = renderer.load_rgba(avatar.contents, avatar.width, avatar.height)
								}
							end
		
							return m_contents[spectator].texture
						end)()

					}
				end
			end
		
			for _, c_ref in pairs(unsorted) do
				local c_id = c_ref.idx
				local c_nickname = entity.get_player_name(c_ref.idx)
		
				if c_ref.active then
					latest_item = true
		
					if m_active[c_id] == nil then
						m_active[c_id] = {
							alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer.measure_text(nil, c_nickname)
					m_active[c_id].active = true
					m_active[c_id].offset = text_width
					m_active[c_id].alpha = m_active[c_id].alpha + frames
                    m_active[c_id].avatar = c_ref.avatar
					m_active[c_id].name = c_nickname
		
					if m_active[c_id].alpha > 1 then
						m_active[c_id].alpha = 1
					end
				elseif m_active[c_id] ~= nil then
					m_active[c_id].active = false
					m_active[c_id].alpha = m_active[c_id].alpha - frames
		
					if m_active[c_id].alpha <= 0 then
						m_active[c_id] = nil
					end
				end
		
				if m_active[c_id] ~= nil and m_active[c_id].offset > maximum_offset then
					maximum_offset = m_active[c_id].offset
				end
			end
		
			if is_menu_open and not latest_item then
				local case_name = ' '
				local text_width = renderer.measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					name = '',
					active = true,
					offset = text_width,
					alpha = 0
				}
			end
			local r, g, b, a = get_bar_color()
			local msping_col = item_count(m_active) > 0 and '\a'..rgbToHex(r, g, b)..'ff' or '\a'..rgbToHex(r, g, b)..'00'
			local text = 'Spectators'
			local textdark = msping_col .. 'Spectators'
			
			local x, y = dragging:get()
			local height_offset = 23
			local w, h = 55 + maximum_offset, 50
			local avatars = true
			
			w = w - (avatars and 0 or 17) 
			local right_offset = avatars and (x+w/2) > (({ client.screen_size() })[1] / 2)
			
			if solusmaster and master_switch then
				renderer_shit(x, y, w, r, g, b, m_alpha*255, 2)
				
				if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then
					renderer.text(x - renderer.measure_text(nil, text) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, text)
				elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
					renderer.text(x - renderer.measure_text(nil, textdark) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, textdark)
				end

				for c_name, c_ref in pairs(m_active) do
					local _, text_h = renderer.measure_text(nil, c_ref.name)

					if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then
						renderer.text(x + ((c_ref.avatar and not right_offset) and text_h or -5) + 10, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_ref.name)
					elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
						renderer.text(x + ((c_ref.avatar and not right_offset) and text_h or -5) + 10, y + height_offset, 150, 150, 150, m_alpha*c_ref.alpha*255, '', 0, c_ref.name)
					end

					renderer.texture(c_ref.avatar, x + (right_offset and w - 15 or 5), y + height_offset, text_h, text_h, 255, 255, 255, m_alpha*c_ref.alpha*255, 'f')
			
					height_offset = height_offset + 15
				end
			end

			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames; if m_alpha > 1 then m_alpha = 1 end
			else
				m_alpha = m_alpha - frames; if m_alpha < 0 then m_alpha = 0 end 
			end
		
			if is_menu_open then
				m_active[' '] = nil
			end
		end

		client.set_event_callback('paint', g_paint_handler)
	end,

	keybinds = function()
		local screen_size = { client.screen_size() }
		local screen_size = {
			screen_size[1] - screen_size[1] * cvar.safezonex:get_float(),
			screen_size[2] * cvar.safezoney:get_float()
		}

		local dragging = dragging_fn('Keybinds', screen_size[1] / 1.385, screen_size[2] / 2.5)

		local m_alpha, m_active = 0, { }
		local hotkey_modes = { 'holding', 'toggled', 'disabled' }

        local elements = {
			rage = { 'aimbot', 'other' },
			aa = { 'anti-aimbot angles', 'fake lag', 'other' },
			legit = { 'weapon type', 'aimbot', 'triggerbot', 'other' },
			visuals = { 'player esp', 'cololightblue models', 'other esp', 'effects' },
			misc = { 'miscellaneous', 'movement', 'settings' },
			skins = { 'knife options', 'glove options', 'weapon skin' },
			players = { 'players', 'adjustments' },
			config = { 'presets', 'lua' },
			lua = { 'a', 'b' }
		}

        local reference_if_exists = function(...)
			if pcall(ui.reference, ...) then
				 return true
			end
		end

		local create_item = function(data)
			local collected = { }

			local cname = data.custom_name
			local reference = { ui.reference(unpack(data.reference)) }
		
			for i=1, #reference do
				if i <= data.ui_offset then
					collected[i] = reference[i]
				end
			end
		
			cname = (cname and #tostring(cname) > 0) and cname or nil

			data.reference[3] = data.ui_offset == 2 and ui.name(collected[1]) or data.reference[3]

			m_hotkeys[cname or (data.reference[3] or '?')] = {
				reference = data.reference,

				ui_offset = data.ui_offset,
				custom_name = cname,
				custom_file = data.require,
				collected = collected
			}

			return true
		end

        local create_custom_item = function(pdata)
			local reference = pdata.reference

			if  reference == nil or elements[reference[1]:lower()] == nil or 
				not contains(elements[reference[1]:lower()], reference[2]:lower()) then
				return false
			end

			if reference_if_exists(unpack(reference)) then
				return create_item(pdata)
			else
				if pcall(require, pdata.require) and reference_if_exists(unpack(reference)) then
					return create_item(pdata)
				else
					local name = (pdata.require and #pdata.require > 0) and (pdata.require .. '.lua') or '-'

					client.color_log(216, 181, 121, ('[%s] \1\0'):format(script_name))
					client.color_log(155, 220, 220, ('Unable to reference hotkey: %s [ %s ]'):format(reference[3], name))
				end
			end

			return false
		end

		local g_paint_handler = function()
			local master_switch = ui.get(enterprise.visual.keybind)
			local solusmaster = ui.get(enterprise.visual.solus_enable)

			local is_menu_open = ui.is_menu_open()
			local frames = 8 * globals.frametime()
		
			local latest_item = false
			local maximum_offset = 66

            if m_hotkeys_update == true then
				m_hotkeys = { }
				m_active = { }

                for _, item in pairs((script_db.keybinds or { })) do
					create_custom_item({
						reference = item.reference,
						ui_offset = item.ui_offset or 1,
						require = item.require
					})
				end

				m_hotkeys_update = false
			end
		
			for c_name, c_data in pairs(m_hotkeys) do
				local item_active = true
				local c_ref = c_data.collected

				local items = item_count(c_ref)
				local state = { ui.get(c_ref[items]) }
		
				if items > 1 then
					item_active = ui.get(c_ref[1])
				end
		
				if item_active and state[2] ~= 0 and (state[2] == 3 and not state[1] or state[2] ~= 3 and state[1]) then
					latest_item = true
		
					if m_active[c_name] == nil then
						m_active[c_name] = {
							mode = '', alpha = 0, offset = 0, active = true
						}
					end
		
					local text_width = renderer.measure_text(nil, c_name)
		
					m_active[c_name].active = true
					m_active[c_name].offset = text_width
					m_active[c_name].mode = hotkey_modes[state[2]]
					m_active[c_name].alpha = m_active[c_name].alpha + frames
		
					if m_active[c_name].alpha > 1 then
						m_active[c_name].alpha = 1
					end
				elseif m_active[c_name] ~= nil then
					m_active[c_name].active = false
					m_active[c_name].alpha = m_active[c_name].alpha - frames
		
					if m_active[c_name].alpha <= 0 then
						m_active[c_name] = nil
					end
				end
		
				if m_active[c_name] ~= nil and m_active[c_name].offset > maximum_offset then
					maximum_offset = m_active[c_name].offset
				end
			end
		
			if is_menu_open and not latest_item then
				local case_name = 'Menu toggled'
				local text_width = renderer.measure_text(nil, case_name)
		
				latest_item = true
				maximum_offset = maximum_offset < text_width and text_width or maximum_offset
		
				m_active[case_name] = {
					active = true,
					offset = text_width,
					mode = '~',
					alpha = 0,
				}
			end
			local r, g, b, a = get_bar_color()
			local msping_col = item_count(m_active) > 0 and '\a'..rgbToHex(r, g, b)..'ff' or '\a'..rgbToHex(r, g, b)..'00'

			
			local text = 'Keybinds'
			local textdark = msping_col .. 'Keybinds'

			local x, y = dragging:get()
		
			local height_offset = 23
			local w, h = 75 + maximum_offset, 50

			if solusmaster and master_switch then
				renderer_shit(x, y, w, r, g, b, m_alpha*255, 2)
			
				for c_name, c_ref in pairs(m_active) do
					local key_type = '[' .. (c_ref.mode or '?') .. ']'
					
					if ui.get(enterprise.visual.onscreen_design) == 'Top bar' then
						renderer.text(x + 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, c_name)
						renderer.text(x + w - renderer.measure_text(nil, key_type) - 5, y + height_offset, 255, 255, 255, m_alpha*c_ref.alpha*255, '', 0, key_type)
						renderer.text(x - renderer.measure_text(nil, text) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, text)
					elseif ui.get(enterprise.visual.onscreen_design) == 'Dark mode' then
						renderer.text(x + 5, y + height_offset, 150, 150, 150, m_alpha*c_ref.alpha*255, '', 0, c_name)
						renderer.text(x + w - renderer.measure_text(nil, key_type) - 5, y + height_offset, 150, 150, 150, m_alpha*c_ref.alpha*255, '', 0, key_type)
						renderer.text(x - renderer.measure_text(nil, textdark) / 2 + w/2, y + 4, 255, 255, 255, m_alpha*255, '', 0, textdark)
					end
			
					height_offset = height_offset + 15
				end
			end
		
			dragging:drag(w, (3 + (15 * item_count(m_active))) * 2)

			if master_switch and item_count(m_active) > 0 and latest_item then
				m_alpha = m_alpha + frames

				if m_alpha > 1 then 
					m_alpha = 1
				end
			else
				m_alpha = m_alpha - frames

				if m_alpha < 0 then
					m_alpha = 0
				end 
			end
		
			if is_menu_open then

				m_active['Menu toggled'] = nil
			end
		end
		

		client.set_event_callback('paint', g_paint_handler)
	end,
}

ms_classes.watermark()
ms_classes.spectators()
ms_classes.keybinds()

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2} 

---------------------------------------------
--[SOLUS]
---------------------------------------------

---------------------------------------------
--[NOTIFICATIONS]
---------------------------------------------

local get_hit_color = function()
	local r, g, b, a = ui.get(enterprise.visual.hitcol)
	return r, g, b, a
end

local get_miss_color = function()
	local r, g, b, a = ui.get(enterprise.visual.misscol)
	return r, g, b, a
end

local r, g, b, a = get_hit_color()
local noticol = '\a'..rgbToHex(r, g, b)..'ff'

table.insert(logs_txt, {

	text = 'Welcome ' .. username .. ' to 1Mafia.lua [' .. build .. '] build loaded.',
	textdark = colours.grey ..'Welcome ' .. noticol .. username .. colours.grey .. ' to ' .. noticol .. '1Mafia' .. colours.grey .. '.lua' .. colours.grey .. ' [' .. noticol .. build .. colours.grey .. '] build loaded.',

	timer = globals.realtime(),
	smooth_y = screen[2] + 100,
	alpha = 0,

	first_circle = 0,
	second_circle = 0,

	box_left = center[1],
	box_right = center[1],

	box_left_1 = center[1],
	box_right_1 = center[1]
})


local force_safe_point = ui.reference('RAGE', 'Aimbot', 'Force safe point')
local time_to_ticks = function(t) return math.floor(0.5 + (t / globals.tickinterval())) end
local vec_substract = function(a, b) return { a[1] - b[1], a[2] - b[2], a[3] - b[3] } end
local vec_lenght = function(x, y) return (x * x + y * y) end

local g_impact = { }
local g_aimbot_data = { }
local g_sim_ticks, g_net_data = { }, { }

local cl_data = {
    tick_shifted = false,
    tick_base = 0
}

local float_to_int = function(n) 
	return n >= 0 and math.floor(n+.5) or math.ceil(n-.5)
end

local get_entities = function(enemy_only, alive_only)
    local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}
    local player_resource = entity.get_player_resource()
    
    for player = 1, globals.maxplayers() do
        local is_enemy, is_alive = true, true
        
        if enemy_only and not entity.is_enemy(player) then is_enemy = false end
        if is_enemy then
            if alive_only and entity.get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
            if is_alive then table.insert(result, player) end
        end
    end

    return result
end


local function g_net_update()
	local me = entity.get_local_player()
    local players = get_entities(true, true)
	local m_tick_base = entity.get_prop(me, 'm_nTickBase')
	
    cl_data.tick_shifted = false
    
	if m_tick_base ~= nil then
		if cl_data.tick_base ~= 0 and m_tick_base < cl_data.tick_base then
			cl_data.tick_shifted = true
		end
	
		cl_data.tick_base = m_tick_base
    end

	for i=1, #players do
		local idx = players[i]
        local prev_tick = g_sim_ticks[idx]
        
        if entity.is_dormant(idx) or not entity.is_alive(idx) then
            g_sim_ticks[idx] = nil
            g_net_data[idx] = nil
        else
            local player_origin = { entity.get_origin(idx) }
            local simulation_time = time_to_ticks(entity.get_prop(idx, 'm_flSimulationTime'))
    
            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local m_fFlags = entity.get_prop(idx, 'm_fFlags')

                    local diff_origin = vec_substract(player_origin, prev_tick.origin)
                    local teleport_distance = vec_lenght(diff_origin[1], diff_origin[2])

                    g_net_data[idx] = {
                        tick = delta-1,

                        origin = player_origin,
                        tickbase = delta < 0,
                        lagcomp = teleport_distance > 4096,
                    }
                end
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = player_origin,
            }
        end
    end
end

local function g_aim_fire(e)
    local data = e

    local plist_sp = plist.get(e.target, 'Override safe point')
    local plist_fa = plist.get(e.target, 'Correction active')
    local checkbox = ui.get(force_safe_point)

    if g_net_data[e.target] == nil then
        g_net_data[e.target] = { }
    end

    data.tick = e.tick

    data.eye = vector(client.eye_position)
    data.shot = vector(e.x, e.y, e.z)

    data.teleported = g_net_data[e.target].lagcomp or false
    data.choke = g_net_data[e.target].tick or '?'
    data.self_choke = globals.chokedcommands()
    data.correction = plist_fa and 1 or 0
    data.safe_point = ({
        ['Off'] = 'off',
        ['On'] = true,
        ['-'] = checkbox
    })[plist_sp]

    g_aimbot_data[e.id] = data
end

local function aim_hit(e)

    local on_fire_data = g_aimbot_data[e.id]
	local name = string.lower(entity.get_player_name(e.target))
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local aimed_hgroup = hitgroup_names[on_fire_data.hitgroup + 1] or '?'
    local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
    local health = entity.get_prop(e.target, 'm_iHealth')

	local r, g, b, a = get_hit_color()
	local noticol = '\a'..rgbToHex(r, g, b)..'ff'

	if ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), "Hit/Miss Notifications") then
		table.insert(logs_txt, {		
			text = string.format('[%d] Hit %s\'s %s for %i(%d) (%i remaining) aimed=%s(%s) sp=%s LC=%s TC=%s', e.id, name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke),
			textdark = string.format(colours.grey .. '[' .. noticol .. '%d' .. colours.grey .. ']' .. noticol .. ' Hit ' .. colours.grey .. '%s\'s' .. noticol .. ' %s' .. colours.grey .. ' for ' .. noticol .. '%i' .. colours.grey .. '(%d) (' .. noticol .. '%i' .. colours.grey .. ' remaining) aimed=' .. noticol .. '%s' .. colours.grey .. '(' .. noticol .. '%s' .. colours.grey .. ') sp=' .. noticol .. '%s' .. colours.grey .. ' LC=' .. noticol .. '%s' .. colours.grey .. ' TC=' .. noticol .. '%s', e.id, name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke),

			timer = globals.realtime(),
			smooth_y = screen[2] + 100,
			alpha = 0,
		
			first_circle = 0,
			second_circle = 0,
		
			box_left = center[1],
			box_right = center[1],
		
			box_left_1 = center[1],
			box_right_1 = center[1]
		})
	end

	if ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), "Console logs") then
		print(string.format('[%d] Hit %s\'s %s for %i(%d) (%i remaining) aimed=%s(%s) sp=%s LC=%s TC=%s', e.id, name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke))


	end

end


local function aim_miss(e)
    
    local on_fire_data = g_aimbot_data[e.id]
    local name = string.lower(entity.get_player_name(e.target))
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
    local reason = e.reason == '?' and 'unknown' or e.reason
	
	local r, g, b, a = get_miss_color()
	local noticol = '\a'..rgbToHex(r, g, b)..'ff'

	local inaccuracy = 0
    for i=#g_impact, 1, -1 do
        local impact = g_impact[i]

        if impact and impact.tick == globals.tickcount() then
            local aim, shot = 
                (impact.origin-on_fire_data.shot):angles(),
                (impact.origin-impact.shot):angles()

            inaccuracy = vector(aim-shot):length2d()
            break
        end
    end


	if ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), "Hit/Miss Notifications") then
		table.insert(logs_txt, {

			text = string.format('[%d] Missed %s\'s %s(%i)(%s) due to %s:%.2f°', e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy),
			textdark = string.format(colours.grey .. '[%d]' .. noticol .. ' Missed' .. colours.grey .. ' %s\'s' .. noticol .. ' %s'.. colours.grey ..'(' .. noticol .. '%i' .. colours.grey .. ')(' .. noticol .. '%s' .. colours.grey .. ') due to' .. noticol .. ' %s' .. colours.grey .. ':%.2f' .. noticol .. '°', e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy),

			timer = globals.realtime(),
			smooth_y = screen[2] + 100,
			alpha = 0,
		
			first_circle = 0,
			second_circle = 0,
		
			box_left = center[1],
			box_right = center[1],
		
			box_left_1 = center[1],
			box_right_1 = center[1]
		})
	end

	if ui.get(enterprise.visual.enablenotifications) and contains(ui.get(enterprise.visual.notification_system), "Console logs") then
		print(string.format('[%d] Missed %s\'s %s(%i)(%s) due to %s:%.2f°', e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy))

	end
end

local function g_bullet_impact(e)
    local tick = globals.tickcount()
    local me = entity.get_local_player()
    local user = client.userid_to_entindex(e.userid)
    
    if user ~= me then
        return
    end

    if #g_impact > 150 and g_impact[#g_impact].tick ~= tick then
        g_impact = { }
    end

    g_impact[#g_impact+1] = 
    {
        tick = tick,
        origin = vector(client.eye_position()), 
        shot = vector(e.x, e.y, e.z)
    }
end

easings = {
	lerp = function(start, vend, time)
		return start + (vend - start) * time
	end,

	clamp = function(val, min, max)
		if val > max then return max end
		if min > val then return min end
		return val
	end
}

notifications = function()
    local localplayer = entity.get_local_player()
	if not localplayer then return end

	if entity.is_alive(localplayer) then
		screen = {client.screen_size()}
		center = {screen[1]/2, screen[2]/2} 

		local y = screen[2] - 100
		for i, info in ipairs(logs_txt) do
			if i > 5 then
				table.remove(logs_txt, i)
			end

			if info.text ~= nil and info.text ~= "" then
				local text_size_x, text_size_y = renderer.measure_text("", info.text)

				if info.timer + 3.8 < globals.realtime() then
					info.first_circle = easings.lerp(
						info.first_circle, 0, globals.frametime() * 1
					)
	
					info.second_circle = easings.lerp(
						info.second_circle, 0, globals.frametime() * 1
					)
	
					info.box_left = easings.lerp(
						info.box_left, center[1], globals.frametime() * 1
					)
	
					info.box_right = easings.lerp(
						info.box_right, center[1], globals.frametime() * 1
					)
	
					info.box_left_1 = easings.lerp(
						info.box_left_1, center[1], globals.frametime() * 1
					)
	
					info.box_right_1 = easings.lerp(
						info.box_right_1, center[1], globals.frametime() * 1
					)

					info.smooth_y = easings.lerp(
						info.smooth_y,
						screen[2] + 100,
						globals.frametime() * 2
					)

					info.alpha = easings.lerp(
						info.alpha,
						0,
						globals.frametime() * 15
					)
				else
					info.alpha = easings.lerp(
						info.alpha,
						255,
						globals.frametime() * 4
					)
					
					info.smooth_y = easings.lerp(
						info.smooth_y,
						y,
						globals.frametime() * 4
					)

					info.first_circle = easings.lerp(
						info.first_circle, 275, globals.frametime() * 5
					)

					info.second_circle = easings.lerp(
						info.second_circle, -95, globals.frametime() * 3
					)

					info.box_left = easings.lerp(
						info.box_left, center[1] - text_size_x / 2 - 2, globals.frametime() * 6
					)

					info.box_right = easings.lerp(
						info.box_right, center[1] + text_size_x / 2 + 4, globals.frametime() * 6
					)

					info.box_left_1 = easings.lerp(
						info.box_left_1, center[1] - text_size_x / 2 - 2, globals.frametime() * 6
					)

					info.box_right_1 = easings.lerp(
						info.box_right_1, center[1] + text_size_x / 2 + 4, globals.frametime() * 6
					)
				end

				local add_y = math.floor(info.smooth_y)
				local alpha = math.floor(info.alpha)

				local first_circle = math.floor(info.first_circle)
				local second_circle = math.floor(info.second_circle)

				local left_box = math.floor(info.box_left)
				local right_box = math.floor(info.box_right)

				local left_box_1 = math.floor(info.box_left_1)
				local right_box_1 = math.floor(info.box_right_1)
				local r, g, b, a = ui.get(enterprise.visual.notification_col)

				if ui.get(enterprise.visual.notification_style) == 'Top bar' then
					renderer.rectangle(
						center[1] - text_size_x / 2 - 13, 
						add_y - 26,
						text_size_x + 26,
						2,
						r, g, b, a
					)						

					-- backround
					renderer.rectangle(
						center[1] - text_size_x / 2 - 13, 
						add_y - 26, 
						text_size_x + 26, 
						20, 
						0, 0, 0, 35
					)


					--left line that goes down after "rounding"
					renderer.gradient(
						center[1] - text_size_x / 2 - 13, 
						add_y - 26, 
						2, 
						9, 
						r, g, b, a,
						r, g, b, 0, 
						false
					)

					--right line that goes down after "rounding"
					renderer.gradient(
						center[1] + text_size_x / 2 + 13 ,
						add_y - 26, 
						2, 
						9, 
						r, g, b, a, 
						r, g, b, 0,  
						false
					)

					--renderer.text(center[1] - 50 , add_y - 40, r, g, b, alpha, "", 0, "1Mafia.lua")
					renderer.text(center[1] - text_size_x / 2, add_y - 21, 250, 250, 250, alpha, '', 0, info.text)

				elseif ui.get(enterprise.visual.notification_style) == 'Dark mode' then

					-- backround
					renderer.rectangle(
						center[1] - text_size_x / 2 - 13, 
						add_y - 26, 
						text_size_x + 26, 
						20, 
						25, 25, 25, 255
					)

							--center outline
					renderer.rectangle(						
						center[1] - text_size_x / 2 - 16, 
						add_y - 29, 
						text_size_x + 32, 
						26, 
						25, 25, 25, 100
					)

					renderer.text(center[1] - text_size_x / 2, add_y - 23, 250, 250, 250, alpha, '', 0, info.textdark)

				end

				y = y - 45
				if info.timer + 4 < globals.realtime() then table.remove(logs_txt, i) end
			end
		end
	end
end

---------------------------------------------
--[NOTIFICATIONS]
---------------------------------------------


---------------------------------------------
--[CALLBACKS]
---------------------------------------------
client.set_event_callback('aim_hit', aim_hit)

client.set_event_callback('aim_miss', aim_miss)

client.set_event_callback('net_update_end', g_net_update)

client.set_event_callback('aim_fire', g_aim_fire)

client.set_event_callback('bullet_impact', g_bullet_impact)




client.set_event_callback('paint_ui', function()
    --set_menu_color()
    set_lua_menu()
    hide_original_menu(not ui.get(enterprise.luaenable))
	notifications()
	doubletap_enhance()

end)

client.set_event_callback('pre_config_save', function()
    --database.write('enterprise_color', colours.lightblue)
end)

client.set_event_callback('setup_command', function(e)

    local localplayer = entity.get_local_player()

    if localplayer == nil or not entity.is_alive(localplayer) or not ui.get(enterprise.luaenable) then
        return
    end


	if ui.get(enterprise.misc.osfix) and not ui.get(ref.fakeduck) then
		if ui.get(ref.os[2]) then
			ui.set(ref.fl_limit, 3)
		else
			ui.set(ref.fl_limit, ui.get(enterprise.antiaim.fl_limitslider))
		end
	end




    local state = get_mode(e)
    local legit_aa = ui.get(enterprise.keybinds.key_legit) and contains(ui.get(enterprise.main.main_settings), 'Legit AA')

    ui.set(ref.enabled, true)
    state = ui.get(rage[state_to_num[state]].c_enabled) and state_to_num[state] or state_to_num['Global']


    handle_keybinds()
    run_direction()

    ui.set(ref.pitch, legit_aa and 'Off' or ui.get(rage[state].c_pitch))
    ui.set(ref.yawbase, legit_aa and 'Local view' or ui.get(rage[state].c_yawbase))
    ui.set(ref.yaw[1], legit_aa and 'Off' or ui.get(rage[state].c_yaw))

    if not contains(ui.get(rage[state].adv_combo), 'L/R YAW') then 
        ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].c_yaw_sli) or yaw_direction) 
    end
    
    local force_roll = ui.get(enterprise.keybinds.key_roll) and contains(ui.get(enterprise.main.main_settings), 'Force Roll')

    ui.set(ref.yawjitter[1], ui.get(rage[state].c_jitter))
    ui.set(ref.yawjitter[2], ui.get(rage[state].c_jitter_sli))
    ui.set(ref.bodyyaw[1], legit_aa and 'Opposite' or ui.get(rage[state].c_body))
    ui.set(ref.bodyyaw[2], ui.get(rage[state].c_body_sli))
    ui.set(ref.fsbodyyaw, legit_aa and true or ui.get(rage[state].c_free_b_yaw))
    ui.set(ref.fakeyawlimit, legit_aa and 58 or ui.get(rage[state].c_lby_limit))
    ui.set(ref.roll, force_roll and ui.get(rage[state].c_roll) or 0)


	local force_def = ui.get(enterprise.keybinds.key_defensive) and contains(ui.get(enterprise.main.main_settings), 'Force Defensive')
	
	if force_def then
		force_defensive = 1;
		no_choke = 1;
		quick_stop = 1;
	else
		force_defensive = 0;
		no_choke = 0;
		quick_stop = 0;
	end

    if force_roll then
        e.roll = ui.get(rage[state].c_roll) 
    end

    if contains(ui.get(rage[state].adv_combo), 'Fluctuate Fake yaw limit') then
        ui.set(ref.fakeyawlimit, math.random(ui.get(rage[state].min_mfy), ui.get(rage[state].max_mfy)))
    end

    if contains(ui.get(rage[state].adv_combo), 'L/R YAW') and e.chokedcommands == 0 then
		local desync_type = entity.get_prop(localplayer, 'm_flPoseParameter', 11) * 120 - 60
		local desync_side = desync_type > 0 and 1 or -1

        if desync_side == 1 then
            --left
            ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].l_limit) or yaw_direction)
        elseif desync_side == -1 then
            --right
            ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].r_limit) or yaw_direction)
        end
    end
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback('paint', function()
    onscreen_elements()
end)


client.set_event_callback('console_input', function(input)
    if string.find(input, 'export') then
        export_cfg()
        return true
    end

    if string.find(input, 'import') then
        import_cfg()
        return true
    end
end)


local function init_callbacks()
    ui.set_callback(enterprise.luaenable, handle_menu)
    ui.set_callback(enterprise.antiaim.aa_condition, handle_menu)
    ui.set_callback(enterprise.tabselect, handle_menu)
    ui.set_callback(ref.load_cfg, handle_menu)

    for i=1, #aa_config do
        ui.set_callback(rage[i].c_yaw, handle_menu)
        ui.set_callback(rage[i].c_jitter, handle_menu)
        ui.set_callback(rage[i].c_body, handle_menu)
        ui.set_callback(rage[i].adv_combo, handle_menu)
        ui.set_callback(rage[i].c_enabled, handle_menu)
    end
end
init_callbacks()
---------------------------------------------
--[CALLBACKS]
---------------------------------------------



