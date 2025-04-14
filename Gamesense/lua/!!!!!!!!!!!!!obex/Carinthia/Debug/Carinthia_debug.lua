vector = require('vector')

local aa_funcs = require 'gamesense/antiaim_funcs' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=29665')
local images = require 'gamesense/images' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=22917')
local http = require 'gamesense/http'
local clipboard = require 'gamesense/clipboard'

local configs = '/mylua//configs/' -- the database name for the configs to be stored (can be named what ever you want)
local cloud_presets = {} -- a table to store cloud presets for the session

local elements = {} -- a table to store the elements ( NOT CONFIG ELEMENTS )
local config_elements = {} -- a table to store the config elements

-- a function to create a new config element with a visibility condition
local ui_new = function(element, condition, config, callback)
    condition = condition or true
    config = config or false
    callback = callback or function() end

    local update = function()
        for k, v in pairs(elements) do
            if type(v.condition) == 'function' then
                ui.set_visible(v.element, v.condition())
            else
                ui.set_visible(v.element, v.condition)
            end
        end
    end

    table.insert(elements, { element = element, condition = condition})

    if config then
        table.insert(config_elements, element)
    end

    ui.set_callback(element, function(value)
        update()
        callback(value)
    end)

    update()

    return element
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
local KINGPIN_ref = {
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
	maxusrcmdprocessticks = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),

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

local colours = {

	lightblue = '\a96cfffFF',
	darkerblue = '\aa1a9ffFF',
	lightgreen = '\ae0ff70FF',
	grey = '\a606060FF',
    lightgrey = '\ac9c9c9FF',
	red = '\aff441fFF',
	palepurple = '\aabc9ffFF',
	default = '\ac8c8c8FF',
}


local obex_data = obex_fetch and obex_fetch() or {username = 'Ryxnn', build = 'Source', discord=''}

client.exec('clear')

client.color_log(245, 130, 130, '██╗  ██╗██╗███╗   ██╗ ██████╗ ██████╗ ██╗███╗   ██╗')
client.color_log(199, 121, 121, '██║ ██╔╝██║████╗  ██║██╔════╝ ██╔══██╗██║████╗  ██║')
client.color_log(171, 128, 128, '█████╔╝ ██║██╔██╗ ██║██║  ███╗██████╔╝██║██╔██╗ ██║')
client.color_log(120, 120, 120, '██╔═██╗ ██║██║╚██╗██║██║   ██║██╔═══╝ ██║██║╚██╗██║')
client.color_log(87,  87,  87,  '██║  ██╗██║██║ ╚████║╚██████╔╝██║     ██║██║ ╚████║')


client.color_log(194, 194, 194,  'KINGPIN - Welcome ' .. obex_data.username .. ' - ' .. obex_data.build)

------------
--[LOCALS]
------------

local KINGPIN = {}
KINGPIN.antiaim = {}
KINGPIN.keybinds = {}
KINGPIN.visual = {}
KINGPIN.misc = {}
KINGPIN.configs = {}


KINGPIN.luaenable = ui_new(ui.new_checkbox('AA', 'Anti-aimbot angles', colours.palepurple .. 'K I N G P I N' .. colours.default .. ' Menu'))

KINGPIN.tabselect = ui_new(ui.new_combobox('AA','Anti-aimbot angles', 'Tab selector', 'Anti-Aim', 'Visuals', 'Misc', 'Config'), function() 
    return ui.get(KINGPIN.luaenable)
end)

--------------
--[ANTI-AIM]
--------------
KINGPIN.antiaim.aa_manual = ui_new(ui.new_checkbox('AA','Anti-aimbot angles', 'Enable' .. colours.palepurple .. ' Manual ' .. colours.default .. 'Anti-Aim'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim'
end, true)
KINGPIN.antiaim.fl_limitslider = ui_new(ui.new_slider('AA', 'Fake lag', 'Limit ', 1, 16, 14, true), function() 
    return ui.get(KINGPIN.luaenable)
end, true)

--------------
--[KEYBINDS]
--------------
KINGPIN.keybinds.key_forward = ui_new(ui.new_hotkey('AA', 'Anti-aimbot angles', colours.lightgreen .. ' > ' .. colours.default .. 'Manual Forward'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.antiaim.aa_manual)
end)
KINGPIN.keybinds.key_left = ui_new(ui.new_hotkey('AA', 'Anti-aimbot angles', colours.lightgreen .. ' > ' .. colours.default .. 'Manual Left'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.antiaim.aa_manual)
end)
KINGPIN.keybinds.key_right = ui_new(ui.new_hotkey('AA', 'Anti-aimbot angles', colours.lightgreen .. ' > ' .. colours.default .. 'Manual Right'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.antiaim.aa_manual)
end)
KINGPIN.keybinds.aa_other = ui_new(ui.new_checkbox('AA','Anti-aimbot angles', 'Enable' .. colours.palepurple .. ' Other'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim'
end)
KINGPIN.keybinds.key_legit = ui_new(ui.new_hotkey('AA', 'Anti-aimbot angles', colours.lightgreen .. ' > ' .. colours.default .. 'Legit AA'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.keybinds.aa_other)
end)
KINGPIN.keybinds.key_freestand = ui_new(ui.new_hotkey('AA', 'Anti-aimbot angles', colours.lightgreen .. ' > ' .. colours.default .. 'Freestanding'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.keybinds.aa_other)
end)
KINGPIN.keybinds.label_empty1 = ui_new(ui.new_label('AA', 'Anti-aimbot angles', '  '), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim'
end)
KINGPIN.keybinds.aa_builder = ui_new(ui.new_label('AA', 'Anti-aimbot angles', '-' .. colours.palepurple .. 'State Based Anti-Aim Builder' .. colours.default .. '-'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim'
end)
KINGPIN.keybinds.aa_condition = ui_new(ui.new_combobox('AA','Anti-aimbot angles', 'Anti-Aim Conditions', aa_config), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim'
end)

-----------
--[VISUALS]
-----------
KINGPIN.visual.indicator_select = ui_new(ui.new_multiselect('AA', 'Anti-aimbot angles', 'Indicator types', {'-', 'Crosshair'}), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals'
end)
KINGPIN.visual.crosshair_select = ui_new(ui.new_combobox('AA', 'Anti-aimbot angles','Crosshair indicators', {'-', 'Clean'}), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and contains(ui.get(KINGPIN.visual.indicator_select), 'Crosshair')
end)
KINGPIN.visual.label_col_1 = ui_new(ui.new_label('AA', 'Anti-aimbot angles','Colour 1'), function()
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and ui.get(KINGPIN.visual.crosshair_select) == 'Clean'
end)
KINGPIN.visual.col_1 = ui_new(ui.new_color_picker('AA', 'Anti-aimbot angles','Colour 1', 255, 255, 255, 255), function()
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and ui.get(KINGPIN.visual.crosshair_select) == 'Clean'
end)
KINGPIN.visual.label_col_2 = ui_new(ui.new_label('AA', 'Anti-aimbot angles','Colour 2'), function()
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and ui.get(KINGPIN.visual.crosshair_select) == 'Clean'
end)
KINGPIN.visual.col_2 = ui_new(ui.new_color_picker('AA', 'Anti-aimbot angles','Colour 2', 255, 255, 255, 255), function()
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and ui.get(KINGPIN.visual.crosshair_select) == 'Clean'
end)
KINGPIN.visual.logs_enable = ui_new(ui.new_checkbox('AA','Anti-aimbot angles', 'Enable' .. colours.palepurple .. ' Hit/Miss ' .. colours.default .. 'Logs' .. colours.red .. 'NOT FUNCTIONAL ATM'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals'
end, true)
KINGPIN.visual.logs_output = ui_new(ui.new_multiselect('AA', 'Anti-aimbot angles', 'Logs output', {'Crosshair', 'Top left', 'Console'}), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Visuals' and ui.get(KINGPIN.visual.logs_enable)
end, true)

-----------
--[MISC]
-----------
KINGPIN.misc.dtenable = ui_new(ui.new_checkbox('AA', 'Anti-aimbot angles', 'enable' .. colours.palepurple .. ' doubletap ' .. colours.default .. 'modifier'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Misc'
end, true)
KINGPIN.misc.dtspeed = ui_new(ui.new_combobox('AA', 'Anti-aimbot angles', 'Modify tickbase', {'Default', 'Fast', 'Fastest'}), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Misc' and ui.get(KINGPIN.misc.dtenable)
end, true)
KINGPIN.misc.enable_clan_tag = ui_new(ui.new_checkbox('AA', 'Anti-aimbot angles', 'enable' .. colours.palepurple .. ' KINGPIN ' .. colours.default .. 'clantag'), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Misc'
end, true)

--------------
--[CONFIGS]
--------------
KINGPIN.configs.config_list = ui_new(ui.new_listbox('AA', 'Anti-aimbot angles', 'Configs', ''), function()
     return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_name = ui_new(ui.new_textbox('AA', 'Anti-aimbot angles', 'Config name', ''), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_load = ui_new(ui.new_button('AA', 'Anti-aimbot angles', colours.lightgrey .. 'Load', function() end), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_save = ui_new(ui.new_button('AA', 'Anti-aimbot angles', colours.lightgrey .. 'Save', function() end), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_delete = ui_new(ui.new_button('AA', 'Anti-aimbot angles', colours.lightgrey .. 'Delete', function() end), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_import = ui_new(ui.new_button('AA', 'Anti-aimbot angles', colours.lightgrey .. 'Import settings', function() end), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)
KINGPIN.configs.config_export = ui_new(ui.new_button('AA', 'Anti-aimbot angles', colours.lightgrey .. 'Export settings', function() end), function() 
    return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Config'
end)

--------------
--[AA BUILDER]
--------------

for i=1, #aa_config do
    local show = function() return ui.get(KINGPIN.luaenable) and ui.get(KINGPIN.tabselect) == 'Anti-Aim' and ui.get(KINGPIN.keybinds.aa_condition) == aa_config[i] end
    local cond = colours.palepurple .. string.lower(aa_config[i]) .. colours.lightblue .. ' ' .. colours.default

    rage[i] = {
        KINGPIN_enabled = ui_new(ui.new_checkbox('aa', 'anti-aimbot angles', 'Enable ' .. aa_config[i] .. ' config'), function() return 
            show() and i > 1 

        end, true),
        KINGPIN_pitch = ui_new(ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}), function() return 
            show() 

        end, true),
        KINGPIN_yawbase = ui_new(ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw base', {'Local view','At targets'}), function() return 
            show() 

        end, true),
        KINGPIN_yaw = ui_new(ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}), function() return 
            show() 

        end, true),
		l_yaw_limit = ui_new(ui.new_slider('AA', 'Anti-aimbot angles', cond .. 'yaw limit -' .. colours.lightblue .. ' Left', -180, 180, 0, true, '°'), function() return 
            show() and ui.get(rage[i].KINGPIN_yaw) ~= 'Off' 

        end, true),
        r_yaw_limit = ui_new(ui.new_slider('AA', 'Anti-aimbot angles', cond .. 'yaw limit -' .. colours.lightblue .. ' Right', -180, 180, 0, true, '°'), function() return 
            show() and ui.get(rage[i].KINGPIN_yaw) ~= 'Off' 

        end, true),
        KINGPIN_jitter = ui_new(ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Yaw jitter', {'Off','Offset','Center','Random'}), function() return 
            show() 

        end, true),
        KINGPIN_l_jitter_sli = ui_new(ui.new_slider('aa', 'anti-aimbot angles', cond .. 'Yaw Jitter' .. colours.lightblue .. ' Left', -180, 180, 0, true, '°', 1), function() return 
            show()and ui.get(rage[i].KINGPIN_jitter) ~= 'Off' 

        end, true),
        KINGPIN_r_jitter_sli = ui_new(ui.new_slider('aa', 'anti-aimbot angles', cond .. 'Yaw Jitter' .. colours.lightblue .. ' Right', -180, 180, 0, true, '°', 1), function() return 
            show()and ui.get(rage[i].KINGPIN_jitter) ~= 'Off' 

        end, true),
        KINGPIN_body = ui_new(ui.new_combobox('aa', 'anti-aimbot angles', cond .. 'Body yaw', {'Off','Opposite','Jitter','Static'}), function() return 
            show() 

        end, true),
        KINGPIN_body_sli = ui_new(ui.new_slider('aa', 'anti-aimbot angles', '\n' .. cond .. 'body sli', -180, 180, 0, true, '°', 1), function() return 
            show() and (ui.get(rage[i].KINGPIN_body) ~= 'Off' and ui.get(rage[i].KINGPIN_body) ~= 'Opposite') 

        end, true),
        l_fake_limit = ui_new(ui.new_slider('aa', 'anti-aimbot angles', cond .. 'Fake yaw limit' .. colours.lightblue .. ' Left', 0, 60, 60, true, '°', 1), function() return 
            show() and ui.get(rage[i].KINGPIN_body) ~= 'Off' 

        end, true),
        r_fake_limit = ui_new(ui.new_slider('aa', 'anti-aimbot angles', cond .. 'Fake yaw limit' .. colours.lightblue .. ' Right', 0, 60, 60, true, '°', 1), function() return 
            show() and ui.get(rage[i].KINGPIN_body) ~= 'Off' 

        end, true),
        KINGPIN_free_b_yaw = ui_new(ui.new_checkbox('aa', 'anti-aimbot angles', cond .. 'Freestanding body yaw'), function() return 
            show() and ui.get(rage[i].KINGPIN_body) ~= 'Off' 

        end, true),       
        KINGPIN_roll = ui_new(ui.new_slider('AA', 'anti-aimbot angles', cond .. 'Roll AA', -50, 50, 0, true, '°', 1), function() return 
            show() and ui.get(rage[i].KINGPIN_body) ~= 'Off'

        end, true),
    }
end

------------------
--[AA BUILDER END]
------------------


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


local function hide_original_menu(state)
    --OG MENU
    ui.set_visible(KINGPIN_ref.enabled, state)
    ui.set_visible(KINGPIN_ref.pitch, state)
    ui.set_visible(KINGPIN_ref.yawbase, state)
    ui.set_visible(KINGPIN_ref.yaw[1], state)
    ui.set_visible(KINGPIN_ref.yaw[2], state)
    ui.set_visible(KINGPIN_ref.yawjitter[1], state)
    ui.set_visible(KINGPIN_ref.yawjitter[2], state)
    ui.set_visible(KINGPIN_ref.bodyyaw[1], state)
    ui.set_visible(KINGPIN_ref.bodyyaw[2], state)
    ui.set_visible(KINGPIN_ref.fakeyawlimit, state)
    ui.set_visible(KINGPIN_ref.fsbodyyaw, state)
    ui.set_visible(KINGPIN_ref.edgeyaw, state)
    ui.set_visible(KINGPIN_ref.roll, state)
    ui.set_visible(KINGPIN_ref.freestand[1], state)
    ui.set_visible(KINGPIN_ref.freestand[2], state)
	ui.set_visible(KINGPIN_ref.fl_limit, state)
end

---------------------------------------------
--[MENU ELEMENTS END]
---------------------------------------------
---------------------------------------------
--[ANTI_AIM CONDITIONS]
---------------------------------------------

local xxx = 'Stand'
local function get_mode(e)
    -- 'Stand', 'Duck CT', 'Duck T', 'Moving', 'Air', Slow motion'
    local lp = entity.get_local_player()
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1 and e.in_jump == 0
    local not_moving = velocity < 2

    local slowwalk_key = ui.get(KINGPIN_ref.slow[1]) and ui.get(KINGPIN_ref.slow[2])
    local teamnum = entity.get_prop(lp, 'm_iTeamNum')

    local ct      = teamnum == 3
    local t       = teamnum == 2

    if not ui.get(KINGPIN_ref.bhop) then
        on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1
    end
    
    if not on_ground then
        xxx = ((entity.get_prop(lp, 'm_flDuckAmount') > 0.7) and ui.get(rage[state_to_num['Air duck']].KINGPIN_enabled)) and 'Air duck' or 'Air'
    else
        if ui.get(KINGPIN_ref.fakeduck) or (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
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



local function handle_keybinds()
    local freestand = ui.get(KINGPIN.keybinds.key_freestand)
    ui.set(KINGPIN_ref.freestand[1], freestand and 'Default' or '')
    ui.set(KINGPIN_ref.freestand[2], freestand and 0 or 2)
end


---------------------------------------------
--[ANTI_AIM CONDITIONS END]
---------------------------------------------

---------------------------------------------
--[CONFIG SYSTEM]
---------------------------------------------

function get_config(name)
    local database = database.read(configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            config = v.config
            return {
                config = v.config,
                index = i
            }
        end
    end

    for i, v in pairs(cloud_presets) do
        if v.name == name then
            config = v.config
            return {
                config = v.config,
                index = i
            }
        end
    end

    return false
end

function save_config(name)
    local db = database.read(configs) or {}
    local config = {}

    if name:match('[^%w]') ~= nil then
        return
    end

    for _, v in pairs(config_elements) do
        local val = ui.get(v)

        if type(val) == 'table' then
            if #val > 0 then
                val = table.concat(val, '|')
            else
                val = nil
            end
        end

        table.insert(config, tostring(val))
    end

    local cfg = get_config(name)

    if not cfg then
        table.insert(db, { name = name, config = table.concat(config, ':') })
    else
        db[cfg.index].config = table.concat(config, ':')
    end

    database.write(configs, db)
end

function delete_config(name)
    local db = database.read(configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    database.write(configs, db)
end

function get_config_list()
    local database = database.read(configs) or {}
    local config = {}
    local presets = cloud_presets

    for i, v in pairs(presets) do
        table.insert(config, v.name)
    end

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

function config_tostring()
    local config = {}
    for _, v in pairs(config_elements) do
        local val = ui.get(v)
        if type(val) == 'table' then
            if #val > 0 then
                val = table.concat(val, '|')
            else
                val = nil
            end
        end
        table.insert(config, tostring(val))
    end

    return table.concat(config, ':')
end

function load_settings(config)
    local type_from_string = function(input)
        if type(input) ~= 'string' then return input end

        local value = input:lower()

        if value == 'true' then
            return true
        elseif value == 'false' then
            return false
        elseif tonumber(value) ~= nil then
            return tonumber(value)
        else
            return tostring(input)
        end
    end

    config = split(config, ':')

    for i, v in pairs(config_elements) do
        if string.find(config[i], '|') then
            local values = split(config[i], '|')
            ui.set(v, values)
        else
            ui.set(v, type_from_string(config[i]))
        end
    end
end

function export_settings()
    local config = config_tostring()
    clipboard.set(config)
end

function load_config(name)
    local database = database.read(configs) or {}
    local config = get_config(name)

    load_settings(config.config)
end

function init_database()
    if database.read(configs) == nil then
        database.write(configs, {})
    end

    local user, token = 'github username', 'auth token' -- get from github account settings (lmk if you need help, you probably wont need it unless your repo is private)

    http.get('https://raw.githubusercontent.com/ryanstayman1/DSQ2/main/Configs.json', function(success, response) -- {authorization = {user, token}} < ONLY USE IF YOUR REPO IS PRIVATE
        if not success then
            print('Failed to get presets')
            return
        end

        presets = json.parse(response.body)

        local db = database.read(configs)

        for i, preset in pairs(presets.presets) do
            table.insert(cloud_presets, { name = '\ae0ff70FF*'..preset.name, config = preset.config})
        end

        ui.update(KINGPIN.configs.config_list, get_config_list())
    end) 
end

init_database()

ui.update(KINGPIN.configs.config_list, get_config_list())
ui.set(KINGPIN.configs.config_name, #database.read(configs) == 0 and '' or database.read(configs)[ui.get(KINGPIN.configs.config_list)+1].name)
ui.set_callback(KINGPIN.configs.config_list, function(value)
    local name = ''

    local configs = get_config_list()

    name = configs[ui.get(value)+1] or ''

    ui.set(KINGPIN.configs.config_name, name)
end)

ui.set_callback(KINGPIN.configs.config_load, function()
    local name = ui.get(KINGPIN.configs.config_name)
    if name == '' then return end

    local protected = function()
        load_config(name)
    end

    if pcall(protected) then
        print('loaded config: '..name)
    else
        print('failed to load config: '..name)
    end
end)

ui.set_callback(KINGPIN.configs.config_save, function()
    local name = ui.get(KINGPIN.configs.config_name)
    if name == '' then return end

    if name:match('[^%w]') ~= nil then
        print('Failed to save config because it contains invalid characters')
        return
    end

    local protected = function()
        save_config(name)
    end

    if pcall(protected) then
        ui.update(KINGPIN.configs.config_list, get_config_list())
        print('saved config: '..name)
    else
        print('failed to save config: '..name)
    end
end)

ui.set_callback(KINGPIN.configs.config_delete, function()
    local name = ui.get(KINGPIN.configs.config_name)
    if name == '' then return end

    if not get_config(name) then
        print('failed to delete config: '..name)
        return
    end

    local protected = function()
        delete_config(name)
    end

    if pcall(protected) then
        ui.update(KINGPIN.configs.config_list, get_config_list())
        ui.set(KINGPIN.configs.config_list, 0)
        ui.set(KINGPIN.configs.config_name, #database.read(configs) == 0 and '' or database.read(configs)[#database.read(configs) - #database.read(configs)+1].name)
        print('deleted config: '..name)
    else
        print('failed to delete config: '..name)
    end
end)

ui.set_callback(KINGPIN.configs.config_import, function()
    local protected = function()
        load_settings(clipboard.get())
    end

    if pcall(protected) then
        print('imported settings')
    else
        print('failed to import settings')
    end
end)

ui.set_callback(KINGPIN.configs.config_export, function()
    local protected = function()
        export_settings()
    end

    if pcall(protected) then
        print('exported settings')
    else
        print('failed to export settings')
    end
end)
---------------------------------------------
--[CONFIG SYSTEM END]
---------------------------------------------

---------------------------------------------
--[VISUALS]
---------------------------------------------

gradient = function(r1, g1, b1, a1, r2, g2, b2, a2, text)
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
end

local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * globals.frametime() * speed 
    else 
        return name - (value + name) * globals.frametime() * speed -- add / 2 if u want goig back effect
        
    end
end

local xpos = 0
local xpos2 = 0
local xpos3 = 0
local xpos4 = 0
local xpos5 = 0
local indi_anim = 0

local function KINGPIN_VISUALS()
  

    screen = {client.screen_size()}
	center = {screen[1]/2, screen[2]/2} 



    local spacing = 0 
    local lp = entity.get_local_player()
    local indi_state = string.upper(xxx)
    local scpd = entity.get_prop(lp, "m_bIsScoped")
    local acti_indi_state = ui.get(rage[state_to_num[xxx]].KINGPIN_enabled) and indi_state or 'GLOBAL'
    local centerstate = renderer.measure_text('-', acti_indi_state)
	local centerpixel = centerstate / 2
    local scoped_pixel = ui.get(KINGPIN.visual.crosshair_select) == 'Clean' and scpd == 1
	local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 3) * 3) * 75 + 150), 255)


    xpos2 = animation(scoped_pixel, xpos2, 20, 15)
	xpos3 = animation(scoped_pixel, xpos3, 2, 15)
	xpos4 = animation(scoped_pixel, xpos4, 14, 15)
	xpos5 = animation(scoped_pixel, xpos5, 9, 15)

    local r, g, b, a = ui.get(KINGPIN.visual.col_1)
    local r2, g2, b2, a2 = ui.get(KINGPIN.visual.col_2)
    local text_to_render = gradient(r, g, b, a, r2, g2, b2, a2, "KINGPIN")


    if ui.get(KINGPIN.visual.crosshair_select) == 'Clean' then

        renderer.text(center[1] + 2 + xpos4, center[2] + 20, 255, 255, 255, 255,'c-', 0, text_to_render)
        renderer.text(center[1] + 32 + xpos4, center[2] + 20, r2, g2, b2, alpha_pulse,'c-', 0, 'DEBUG')

        if scpd == 1 then
            renderer.text(center[1] - 7 + xpos5, center[2] + 25, 210, 210, 210, 255,'-', 0, '~' .. acti_indi_state .. '~')
        else
            centerpixel = centerstate / 2 + 5
            renderer.text(center[1] - 7 - xpos5 - centerpixel, center[2] + 25, 210, 210, 210, 255,'-', 0, '~' .. acti_indi_state .. '~')
        end

        if ui.get(KINGPIN_ref.os[2]) then
            if scpd == 1 then
                renderer.text(center[1] + 5 + xpos3  , center[2] + 40, 210, 210, 210, 255,'c-', 0, 'OS')
            else
                renderer.text(center[1] + 2 + xpos3  , center[2] + 40, 210, 210, 210, 255,'c-', 0, 'OS')
            end
        end

    end

end




---------------------------------------------
--[VISUALS END]
---------------------------------------------
---------------------------------------------
--[CLANTAG CHANGER]
---------------------------------------------
    
local skeetclantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')
client.set_event_callback('net_update_end', function()
    if ui.get(skeetclantag) then 
        return 
    end

    if ui.get(KINGPIN.misc.enable_clan_tag) then
        client.set_clan_tag('KINGPIN')
    else
        client.set_clan_tag('\0')
    end
end)
ui.set_callback(KINGPIN.misc.enable_clan_tag, function()

end)
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
    if not ui.get(KINGPIN.keybinds.key_legit) or not ui.get(KINGPIN.keybinds.aa_other) then 
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
	ui.set(KINGPIN.keybinds.key_forward, 'On hotkey')
	ui.set(KINGPIN.keybinds.key_left, 'On hotkey')
	ui.set(KINGPIN.keybinds.key_right, 'On hotkey')

    ui.set(KINGPIN_ref.freestand[1], ui.get(KINGPIN.keybinds.key_freestand) and 'Default' or '-')
    ui.set(KINGPIN_ref.freestand[2], ui.get(KINGPIN.keybinds.key_freestand) and 'Always on' or 'On hotkey')

	if ui.get(KINGPIN.keybinds.key_freestand) and ui.get(KINGPIN.antiaim.aa_manual) or not ui.get(KINGPIN.antiaim.aa_manual) then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if ui.get(KINGPIN.keybinds.key_forward) and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
			last_press_t_dir = globals.curtime()
		elseif ui.get(KINGPIN.keybinds.key_right) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals.curtime()
		elseif ui.get(KINGPIN.keybinds.key_left) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
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
--[DOUBLE TAP]
---------------------------------------------
local function doubletap_enhance()

	local doubletapmaster = ui.get(KINGPIN.misc.dtenable)

	if doubletapmaster then
		if ui.get(KINGPIN.misc.dtspeed) == 'Default' then
			ui.set(KINGPIN_ref.maxusrcmdprocessticks, 16)
		elseif ui.get(KINGPIN.misc.dtspeed) == 'Fast' then
			ui.set(KINGPIN_ref.maxusrcmdprocessticks, 17)
		else 
			ui.set(KINGPIN_ref.maxusrcmdprocessticks, 18)
		end
	end

end

---------------------------------------------
--[DOUBLE TAP]
---------------------------------------------


---------------------------------------------
--[CALLBACKS]
---------------------------------------------

client.set_event_callback('paint_ui', function()
    hide_original_menu(not ui.get(KINGPIN.luaenable))
	doubletap_enhance()

end)


client.set_event_callback('setup_command', function(e)

    local localplayer = entity.get_local_player()

    if localplayer == nil or not entity.is_alive(localplayer) or not ui.get(KINGPIN.luaenable) then
        return
    end



    local state = get_mode(e)
    local legit_aa = ui.get(KINGPIN.keybinds.key_legit) and ui.get(KINGPIN.keybinds.aa_other)

    ui.set(KINGPIN_ref.enabled, true)
    state = ui.get(rage[state_to_num[state]].KINGPIN_enabled) and state_to_num[state] or state_to_num['Global']


    handle_keybinds()
    run_direction()

    local desync_type = entity.get_prop(localplayer, 'm_flPoseParameter', 11) * 120 - 60
	local desync_side = desync_type > 0 and 1 or -1
    if desync_side == 1 then
        --left
        ui.set(KINGPIN_ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].l_yaw_limit) or yaw_direction)
        ui.set(KINGPIN_ref.fakeyawlimit, legit_aa and 58 or ui.get(rage[state].l_fake_limit))
        ui.set(KINGPIN_ref.yawjitter[2], ui.get(rage[state].KINGPIN_l_jitter_sli))
    elseif desync_side == -1 then
        --right
        ui.set(KINGPIN_ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].r_yaw_limit) or yaw_direction)
        ui.set(KINGPIN_ref.fakeyawlimit, legit_aa and 58 or ui.get(rage[state].r_fake_limit))
        ui.set(KINGPIN_ref.yawjitter[2], ui.get(rage[state].KINGPIN_r_jitter_sli))
    end

    ui.set(KINGPIN_ref.pitch, legit_aa and 'Off' or ui.get(rage[state].KINGPIN_pitch))
    ui.set(KINGPIN_ref.yawbase, legit_aa and 'Local view' or ui.get(rage[state].KINGPIN_yawbase))
    ui.set(KINGPIN_ref.yaw[1], legit_aa and 'Off' or ui.get(rage[state].KINGPIN_yaw))
    --local force_roll = ui.get(KINGPIN.keybinds.key_roll) and contains(ui.get(KINGPIN.antiaim.aa_settings), 'Force Roll')
    ui.set(KINGPIN_ref.yawjitter[1], ui.get(rage[state].KINGPIN_jitter))
    ui.set(KINGPIN_ref.bodyyaw[1], legit_aa and 'Opposite' or ui.get(rage[state].KINGPIN_body))
    ui.set(KINGPIN_ref.bodyyaw[2], ui.get(rage[state].KINGPIN_body_sli))
    ui.set(KINGPIN_ref.fsbodyyaw, legit_aa and true or ui.get(rage[state].KINGPIN_free_b_yaw))
    ui.set(KINGPIN_ref.roll, force_roll and ui.get(rage[state].KINGPIN_roll) or 0)

    if force_roll then
        e.roll = ui.get(rage[state].KINGPIN_roll) 
    end

end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback('paint', function()
    KINGPIN_VISUALS()
end)
---------------------------------------------
--[CALLBACKS]
---------------------------------------------
