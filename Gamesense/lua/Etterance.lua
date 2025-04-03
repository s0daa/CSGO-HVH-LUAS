local ffi = require('ffi')
local images = require("gamesense/images")
local vector = require('vector')
local http = require('gamesense/http')
local clipboard = require("gamesense/clipboard") or error("Install Clipboard library!")
local base64 = require("gamesense/base64") or error("Install Base64 library!")
local c_entity = require("gamesense/entity") or error("Install Entity library!")

local assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs = assert, pcall, xpcall, error, setmetatable, tostring, tonumber, type, pairs, ipairs
local client_log, client_delay_call, ui_get, string_format = client.log, client.delay_call, ui.get, string.format
local typeof, sizeof, cast, cdef, ffi_string, ffi_gc = ffi.typeof, ffi.sizeof, ffi.cast, ffi.cdef, ffi.string, ffi.gc
local string_lower, string_len, string_find = string.lower, string.len, string.find
local base64_encode = base64.encode

local euphemia = euphemia_data and euphemia_data() or {
    username = "lby__",
    build = "coder"
}

local x, o = '\x14\x14\x14\xFF', '\x0c\x0c\x0c\xFF'

local pattern = table.concat{
    x,x,o,x,
    o,x,o,x,
    o,x,x,x,
    o,x,o,x
}

local tex_id = renderer.load_rgba(pattern, 4, 4)

function render_ogskeet_border(x,y,w,h,a)
    renderer.rectangle(x - 10, y - 48 ,w + 20, h + 16,12,12,12,a)
    renderer.rectangle(x - 9, y - 47 ,w + 18, h + 14,60,60,60,a)
    renderer.rectangle(x - 8, y - 46 ,w + 16, h + 12,40,40,40,a)
    renderer.rectangle(x - 5, y - 43 ,w + 10, h + 6,60,60,60,a)
    renderer.rectangle(x - 4, y - 42 ,w + 8, h + 4,12,12,12,a)
    renderer.texture(tex_id, x - 4, y - 42, w + 8, h + 4, 255, 255, 255, a, "r")
    renderer.gradient(x - 4,y - 42, w /2, 1, 59, 175, 222, a, 202, 70, 205, a,true)               
    renderer.gradient(x - 4 + w / 2 ,y - 42, w /2 + 8.5, 1,202, 70, 205, a,204, 227, 53, a,true)
    --renderer.text(x, y - 40, 255,255,255,a, "", nil, text)
end

local lua = {}
lua.database = {configs = ":etterance::configs:"}

local aa_config = { 'Global', 'Stand', 'Slow Motion', 'Moving' , 'Air', 'Air Crouch', 'Duck', 'Duck Move' }
local aa_short = { 'G', 'S', 'SM', 'M' , 'A', 'A+C', 'D', 'D+M' }
local rage = {}

local state_to_num = { 
    ['Global'] = 1, 
    ['Stand'] = 2, 
    ['Slow Motion'] = 3, 
    ['Moving'] = 4,
    ['Air'] = 5,
    ['Air Crouch'] = 6,
    ['Duck'] = 7,
    ['Duck Moving'] = 8, 
}


local ref = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
	load_cfg = ui.reference('Config', 'Presets', 'Load'),
    dmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),
    --[1] = combobox/checkbox | [2] = slider/hotkey
    pitch = { ui.reference('AA', 'Anti-aimbot angles', 'pitch'), },
    rage = { ui.reference('RAGE', 'Aimbot', 'Enabled') },
    yaw = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	quickpeek = { ui.reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter = { ui.reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	roll = { ui.reference('AA', 'Anti-aimbot angles', 'Roll') },
	bodyyaw = { ui.reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui.reference('AA', 'Anti-aimbot angles', 'Freestanding') },
	os = { ui.reference('AA', 'Other', 'On shot anti-aim') },
	slow = { ui.reference('AA', 'Other', 'Slow motion') },
	dt = { ui.reference('RAGE', 'Aimbot', 'Double tap') }
}

---------------------------------------------

local colours = {
	lightblue = '\aFF5858FF',
	darkerblue = '\a5E587DFF',
	grey = '\aFFFFFFFF',
	red = '\aFFFFFFFF',
	default = '\aFFFFFFFF',
	green = '\aBCFFB9FF',

}
local etterance = {
	luaenable = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Etterance.Tech \aFF5858FF['..string.upper(euphemia.build)..']'),
	tabselect = ui.new_combobox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Tab', 'Main', 'Anti-Aim', 'Anti~Bruteforce', 'Other', 'Config'),

	main = {
		main_space = ui.new_label('AA', 'Anti-aimbot angles', '  '),
		main_label1 = ui.new_label('AA', 'Anti-aimbot angles', 'Welcome Back, '..colours.lightblue.. euphemia.username..' !'),
		main_label4 = ui.new_label('AA', 'Anti-aimbot angles', 'Etterance.Tech \aFF5858FF['..string.upper(euphemia.build)..']'),
        main_space3 = ui.new_label('AA', 'Anti-aimbot angles', 'Author ~ '..colours.lightblue..'lby__'),
		main_space1 = ui.new_label('AA', 'Anti-aimbot angles', 'Last update ~ '..colours.lightblue..'3/2/2024'),
        main_space4 = ui.new_label('AA', 'Anti-aimbot angles', '  '),
        aa_select = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. 'ET · \a9696FFFFAnti~Aim Tab', {'Main', 'Builder', 'Keybinds'}),
		main_settings = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Yaw Direction', {'Edge-yaw', 'Freestand', 'Manual AA'}),
        addons_aa = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Addons', {'Anti~Backstab', 'Shit AA On Warmup'}), 
        safehead = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'SafeHead In Air+C', {'Knife', 'Taser', 'Scout', 'Awp'}), 
	},

	antiaim = {
        c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        c_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Yaw Base', {'Local view','At targets'}),
        c_yaw = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
		aa_condition = ui.new_combobox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Condition', aa_config),
        ab_enable = ui.new_checkbox('AA','Anti-aimbot angles', 'Enable \aFF5858FFAnti~Bruteforce'),
        ab_phases = ui.new_slider('AA', 'Anti-aimbot angles', 'Phases', 1, 5, 1, true),
	},

	visual = {
		indicator_enable = ui.new_checkbox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Indicators'),
		indicator_select = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Select Indicators', 'Crosshair Indicators', 'Damage Indicator'),
        indicator_type = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Type', {'Default', 'Alternative'}),
		indicator_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator Color 1', 255, 164, 164, 255),
        indicator_col2 = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator Color 2', 255, 255, 255, 255),     
		window_enable = ui.new_checkbox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Windows'),
		window_select = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Windows', 'Defensive Manager', 'Slowed Down'),
        window_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Window Color 1', 255, 164, 164, 255),
        window_col2 = ui.new_color_picker('AA','Anti-aimbot angles', 'Window Color 2', 255, 164, 164, 255), 
        arrows_enable = ui.new_checkbox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Manual Arrows'),
        arrows_type = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Arrows Type', {'Default','Spread Based'}),
        arrows_slider = ui.new_slider('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Arrows Offset', 0, 50, 0, true, '', 1),
        arrows_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Arrows Color 1', 255, 255, 255, 255),
        rage_logs = ui.new_checkbox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'RageBot Logs'),
        logs_type = ui.new_multiselect('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Logs Output', {'Console','Screen'}),
        logs_vis = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Logs Type', {'Default','Alternative'}),
        log_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Log Color', 255, 255, 255, 255), 

        anims_enable = ui.new_checkbox('AA','Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Animation Breakers'),
        anims_ground = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Ground Breaker', {'Off','Follow Legs', 'Jitter Legs', 'MoonWalk'}),
        anims_air = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Air Breaker', {'Off','Static Legs', 'MoonWalk'}),
        anims_other = ui.new_multiselect('aa', 'anti-aimbot angles', colours.lightblue .. '   ET · '.. colours.default ..'Other Breakers', {'Move Lean', 'Pitch 0 On Land'}),
        watermark = ui.new_combobox("aa", "anti-aimbot angles", colours.lightblue .. 'ET · '.. colours.default .. "Watermarks", {"Default", "Branded"}),
        watermark_color = ui.new_color_picker('AA','Anti-aimbot angles', 'watermark_color', 255, 255, 255, 255),     
	},

	keybinds = {
		key_edge_yaw = ui.new_hotkey('AA', 'anti-aimbot angles', 'Edge-yaw'),
        static_yaw = ui.new_checkbox('aa', 'anti-aimbot angles', 'Static Freestanding'),
		key_freestand = ui.new_hotkey('AA', 'anti-aimbot angles', 'Freestanding'),
		key_forward = ui.new_hotkey('AA', 'anti-aimbot angles', 'Manual Forward'),
		key_back = ui.new_hotkey('AA', 'anti-aimbot angles', 'Manual Back'),
		key_left = ui.new_hotkey('AA', 'anti-aimbot angles', 'Manual Left'),
		key_right = ui.new_hotkey('AA', 'anti-aimbot angles', 'Manual Right'),
	},

    misc = {
        misc_other = ui.new_multiselect('aa', 'anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Useful Functions', {'Console Filter', 'Fast Ladder', 'TrashTalk'}),
        breaklc = ui.new_checkbox('AA', 'Anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Break LC Teleport'),
        lc_key = ui.new_hotkey('AA', 'anti-aimbot angles', colours.lightblue .. 'ET · '.. colours.default ..'Break LC Teleport', true),
	},

    config = {
        list = ui.new_listbox('aa', 'anti-aimbot angles', "Configs", ""),
        name = ui.new_textbox('aa', 'anti-aimbot angles', "Config name", ""),
        load = ui.new_button('aa', 'anti-aimbot angles', "Load", function() end),
        save = ui.new_button('aa', 'anti-aimbot angles', "Save", function() end),
        delete = ui.new_button('aa', 'anti-aimbot angles', "Delete", function() end),
        import = ui.new_button('aa', 'anti-aimbot angles', "Import", function() end),
        export = ui.new_button('aa', 'anti-aimbot angles', "Export", function() end)
    },
}

brute_table = {}
local max_phases = 5

for i=1, max_phases do
    brute_table[i] = {
        select = ui.new_multiselect('AA','Anti-aimbot angles', colours.lightblue .. '['..i..'] · '.. colours.default ..'Select', {'Jitter', 'Body Yaw'}),
        jitter = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. '['..i..'] · '.. colours.default ..'Jitter', -180, 180, 0, true),
        body = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. '['..i..'] · '.. colours.default ..'Body Yaw', -180, 180, 0, true),
    }
end

for i=1, #aa_config do
    rage[i] = {
        enable = ui.new_checkbox('aa', 'anti-aimbot angles', 'Override · '.. colours.lightblue .. aa_config[i]),
        yaw_type = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Yaw Type', {'Static', 'l&r','Delay', 'Delayed Yaw'}),
        delay_ticks = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default.. ' · Delay Ticks', 1, 10, 3, true),
        limit = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default.. ' · Static Yaw', -180, 180, 0, true, '°'),
		l_limit = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default.. ' · Yaw Left', -180, 180, 0, true, '°'),
        r_limit = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Yaw Right', -180, 180, 0, true, '°'),
        c_jitter = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Jitter Type', {'Off','Offset','Center','Random', 'Skitter'}),
        c_jitter_mode = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Jitter Mode', {'Default', 'Alternative'}),
        c_jitter_slider = ui.new_slider('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Jitter Amount', -180, 180, 0, true, '°', 1),
        c_body = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Body Yaw', {'Off','Opposite','Jitter','Static'}),
        body_slider = ui.new_slider('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Body Yaw Amount', -180, 180, 0, true, '°', 1),
		freestand_lby = ui.new_checkbox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Desync Freestanding'),
        c_pitch_exp = ui.new_checkbox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Defensive Exploit'),
        c_exp_type = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Defensive Type', {'On Peek', 'Always On'}),
        exp_yaw = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Defensive Yaw', {'Disabled', 'Sideways', 'Random', 'Spin', "3-Way", "5-Way"}),
        exp_pitch = ui.new_combobox('aa', 'anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Defensive Pitch', {'Disabled', 'Up', 'Zero', 'Random', 'Custom'}),
        pitch_amount = ui.new_slider('AA', 'Anti-aimbot angles', colours.lightblue .. aa_short[i].. colours.default..' · Pitch Amount', -89, 89, -49, true, '°'),
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

local function set_lua_menu()
    local lua_enabled = ui.get(etterance.luaenable)
    ui.set_visible(etterance.luaenable, true)
    ui.set_visible(etterance.tabselect, lua_enabled)

    local select_main = ui.get(etterance.tabselect) == 'Main' and lua_enabled
    local select_aa = ui.get(etterance.tabselect) == 'Anti-Aim' and lua_enabled
    local select_ab = ui.get(etterance.tabselect) == 'Anti~Bruteforce' and lua_enabled
    local select_ab2 = ui.get(etterance.tabselect) == 'Anti~Bruteforce' and lua_enabled and ui.get(etterance.antiaim.ab_enable)
    local select_visuals = ui.get(etterance.tabselect) == 'Other' and lua_enabled
    local select_misc = ui.get(etterance.tabselect) == 'Other' and lua_enabled
    local select_cfg = ui.get(etterance.tabselect) == 'Config' and lua_enabled

    ui.set_visible(etterance.config.list, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.name, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.load, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.save, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.delete, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.import, lua_enabled and select_cfg)
    ui.set_visible(etterance.config.export, lua_enabled and select_cfg)

    ui.set_visible(etterance.main.main_label1, select_main)
	ui.set_visible(etterance.main.main_label4, select_main)
	ui.set_visible(etterance.main.main_space, select_main)
	ui.set_visible(etterance.main.main_space1, select_main)
    ui.set_visible(etterance.main.main_space3, select_main)
    ui.set_visible(etterance.main.main_space4, select_main)
    ui.set_visible(etterance.keybinds.key_edge_yaw, contains(ui.get(etterance.main.main_settings), 'Edge-yaw') and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
    ui.set_visible(etterance.keybinds.key_freestand, contains(ui.get(etterance.main.main_settings), 'Freestand') and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
    ui.set_visible(etterance.keybinds.static_yaw, ui.get(etterance.main.aa_select) == "Keybinds" and select_aa and contains(ui.get(etterance.main.main_settings), 'Freestand'))
    local manual_aa = contains(ui.get(etterance.main.main_settings), 'Manual AA')
    ui.set_visible(etterance.keybinds.key_forward, manual_aa and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
	ui.set_visible(etterance.keybinds.key_back, manual_aa and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
    ui.set_visible(etterance.keybinds.key_left, manual_aa and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
    ui.set_visible(etterance.keybinds.key_right, manual_aa and ui.get(etterance.main.aa_select) == "Keybinds" and select_aa)
    
    ui.set_visible(etterance.antiaim.aa_condition, select_aa)
    ui.set_visible(etterance.main.main_settings, select_aa and ui.get(etterance.main.aa_select) == "Keybinds")
    ui.set_visible(etterance.main.aa_select, select_aa)
    ui.set_visible(etterance.main.addons_aa, select_aa and ui.get(etterance.main.aa_select) == "Main")
    ui.set_visible(etterance.main.safehead, select_aa and ui.get(etterance.main.aa_select) == "Main")
    ui.set_visible(etterance.antiaim.c_pitch, select_aa and ui.get(etterance.main.aa_select) == "Main")
    ui.set_visible(etterance.antiaim.c_yawbase, select_aa and ui.get(etterance.main.aa_select) == "Main")
    ui.set_visible(etterance.antiaim.c_yaw, select_aa and ui.get(etterance.main.aa_select) == "Main")
    ui.set_visible(etterance.antiaim.ab_enable, select_ab)
    ui.set_visible(etterance.antiaim.ab_phases, select_ab2)

	ui.set_visible(etterance.visual.indicator_enable, select_visuals)
    ui.set_visible(etterance.visual.indicator_select, select_visuals and ui.get(etterance.visual.indicator_enable))
    ui.set_visible(etterance.visual.indicator_type, select_visuals and ui.get(etterance.visual.indicator_enable) and contains(ui.get(etterance.visual.indicator_select), 'Crosshair Indicators'))
    ui.set_visible(etterance.visual.indicator_col, select_visuals and ui.get(etterance.visual.indicator_enable))
    ui.set_visible(etterance.visual.indicator_col2, select_visuals and ui.get(etterance.visual.indicator_enable))
    ui.set_visible(etterance.visual.window_enable, select_visuals)
    ui.set_visible(etterance.visual.window_select, select_visuals and ui.get(etterance.visual.window_enable))
    ui.set_visible(etterance.visual.watermark, select_visuals)
    ui.set_visible(etterance.visual.watermark_color, select_visuals)

    ui.set_visible(etterance.visual.window_col, select_visuals and ui.get(etterance.visual.window_enable) and contains(ui.get(etterance.visual.window_select), 'Defensive Manager'))
    ui.set_visible(etterance.visual.window_col2, select_visuals and ui.get(etterance.visual.window_enable) and contains(ui.get(etterance.visual.window_select), 'Slowed Down'))

    ui.set_visible(etterance.visual.rage_logs, select_visuals)
    ui.set_visible(etterance.visual.logs_type, select_visuals and ui.get(etterance.visual.rage_logs))
    ui.set_visible(etterance.visual.logs_vis, select_visuals and ui.get(etterance.visual.rage_logs) and contains(ui.get(etterance.visual.logs_type), 'Screen'))
    ui.set_visible(etterance.visual.log_col, select_visuals and ui.get(etterance.visual.rage_logs) and contains(ui.get(etterance.visual.logs_type), 'Screen') and ui.get(etterance.visual.logs_vis) == "Default")
    ui.set_visible(etterance.visual.arrows_enable, select_visuals)
    ui.set_visible(etterance.visual.arrows_type, select_visuals and ui.get(etterance.visual.arrows_enable))
    ui.set_visible(etterance.visual.arrows_slider, select_visuals and ui.get(etterance.visual.arrows_enable) and ui.get(etterance.visual.arrows_type) == "Default")
    ui.set_visible(etterance.visual.arrows_col, select_visuals and ui.get(etterance.visual.arrows_enable))

    ui.set_visible(etterance.visual.anims_enable, select_visuals)
    ui.set_visible(etterance.visual.anims_ground, select_visuals and ui.get(etterance.visual.anims_enable))
    ui.set_visible(etterance.visual.anims_air, select_visuals and ui.get(etterance.visual.anims_enable))
    ui.set_visible(etterance.visual.anims_other, select_visuals and ui.get(etterance.visual.anims_enable))
    ui.set_visible(etterance.misc.misc_other, select_misc)
    ui.set_visible(etterance.misc.breaklc, select_misc)
    ui.set_visible(etterance.misc.lc_key, select_misc and ui.get(etterance.misc.breaklc))
end

local ground_check = false

local xxx = 'Stand'
local function get_mode(e)
    local lp = entity.get_local_player()
    if lp == nil then return end
    local vecvelocity = { entity.get_prop(lp, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1 and e.in_jump == 0
    local not_moving = velocity < 10

    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])

    if not on_ground then
        xxx = ((entity.get_prop(lp, 'm_flDuckAmount') > 0.7) and ui.get(rage[state_to_num['Air Crouch']].enable)) and 'Air Crouch' or 'Air'
    else
        if not_moving then
            if ui.get(ref.fakeduck) or (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
                xxx = 'Duck'
            else
                xxx = 'Stand'
            end
        else
            if ui.get(ref.fakeduck) or (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then 
                xxx = 'Duck Moving'
            elseif slowwalk_key then
                xxx = 'Slow Motion'
            else
                xxx = 'Moving'
            end
        end
    end
    return xxx
end

local function handle_menu()
    local enabled = ui.get(etterance.luaenable) and ui.get(etterance.tabselect) == 'Anti-Aim' and ui.get(etterance.main.aa_select) == "Builder"
    ui.set_visible(etterance.antiaim.aa_condition, enabled)
    ui.set(rage[1].enable, true)
    for i=1, #aa_config do
        local show = ui.get(etterance.antiaim.aa_condition) == aa_config[i] and enabled
        local cond_tp = ui.get(rage[i].enable)
        ui.set_visible(rage[i].enable, show and i > 1)
        
        ui.set_visible(rage[i].yaw_type, show and cond_tp)
        ui.set_visible(rage[i].delay_ticks, show and cond_tp and ui.get(rage[i].yaw_type) ~= 'Static' and ui.get(rage[i].yaw_type) ~= 'l&r')
        ui.set_visible(rage[i].limit, show and cond_tp and ui.get(rage[i].yaw_type) == 'Static')

        ui.set_visible(rage[i].l_limit, show and cond_tp and ui.get(rage[i].yaw_type) ~= 'Static')
        ui.set_visible(rage[i].r_limit, show and cond_tp and ui.get(rage[i].yaw_type) ~= 'Static')

        ui.set_visible(rage[i].c_jitter, show and cond_tp)
        ui.set_visible(rage[i].c_jitter_mode, show and ui.get(rage[i].c_jitter) ~= 'Off' and cond_tp)
        ui.set_visible(rage[i].c_jitter_slider, show and ui.get(rage[i].c_jitter) ~= 'Off' and cond_tp)
        ui.set_visible(rage[i].c_body,show and cond_tp)
        ui.set_visible(rage[i].body_slider,show and (ui.get(rage[i].c_body) ~= 'Off' and ui.get(rage[i].c_body) ~= 'Opposite') and cond_tp)
        ui.set_visible(rage[i].freestand_lby, show and cond_tp)
        ui.set_visible(rage[i].c_pitch_exp, show and cond_tp)

        def_check = ui.get(rage[i].c_pitch_exp) and show and cond_tp
        ui.set_visible(rage[i].c_exp_type, def_check)
        ui.set_visible(rage[i].exp_yaw, def_check)
        ui.set_visible(rage[i].exp_pitch, def_check)
        ui.set_visible(rage[i].pitch_amount, def_check and ui.get(rage[i].exp_pitch) == "Custom")
    end
    ---for ab
    local ab_check = ui.get(etterance.luaenable) and ui.get(etterance.tabselect) == 'Anti~Bruteforce'
    for i=1, max_phases do
        ab_show = ui.get(etterance.antiaim.ab_enable) and ui.get(etterance.antiaim.ab_phases) > i - 1
        ui.set_visible(brute_table[i].select, ab_show and ab_check)
        ui.set_visible(brute_table[i].body, ab_show and ab_check and contains(ui.get(brute_table[i].select), "Body Yaw"))
        ui.set_visible(brute_table[i].jitter, ab_show and ab_check and contains(ui.get(brute_table[i].select), "Jitter"))
    end

end

local function handle_keybinds()
    local freestand = ui.get(etterance.keybinds.key_freestand)
    ui.set(ref.freestand[1], freestand)
    ui.set(ref.freestand[2], freestand and 0 or 2)
end
    
local last_press_t_dir = 0
local yaw_direction = 0

local run_direction = function()
	ui.set(etterance.keybinds.key_forward, 'On hotkey')
	ui.set(etterance.keybinds.key_left, 'On hotkey')
	ui.set(etterance.keybinds.key_back, 'On hotkey')
	ui.set(etterance.keybinds.key_right, 'On hotkey')
    ui.set(ref.edgeyaw, ui.get(etterance.keybinds.key_edge_yaw) and contains(ui.get(etterance.main.main_settings), 'Edge-yaw'))

    ui.set(ref.freestand[1], ui.get(etterance.keybinds.key_freestand))
    ui.set(ref.freestand[2], ui.get(etterance.keybinds.key_freestand) and 'Always on' or 'On hotkey')

	if (ui.get(etterance.keybinds.key_freestand) and contains(ui.get(etterance.main.main_settings), 'Freestand')) or not contains(ui.get(etterance.main.main_settings), 'Manual AA') then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if ui.get(etterance.keybinds.key_forward) and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
			last_press_t_dir = globals.curtime()
		elseif ui.get(etterance.keybinds.key_right) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals.curtime()
		elseif ui.get(etterance.keybinds.key_left) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals.curtime()
		elseif ui.get(etterance.keybinds.key_back) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 0 and 0 or 0
			last_press_t_dir = globals.curtime()
		elseif last_press_t_dir > globals.curtime() then
			last_press_t_dir = globals.curtime()
		end
	end
end


local function doubletap_charged()
    if not ui.get(ref.dt[1]) or not ui.get(ref.dt[2]) or ui.get(ref.fakeduck) then return false end
    if not entity.is_alive(entity.get_local_player()) or entity.get_local_player() == nil then return end
    local weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity.get_prop(entity.get_local_player(), "m_flNextAttack") + 0.01
	local checkcheck = entity.get_prop(weapon, "m_flNextPrimaryAttack")
	if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.01
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - globals.curtime() < 0 and next_primary_attack - globals.curtime() < 0
end



local function animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * globals.frametime() * speed 
    else 
        return name - (value + name) * globals.frametime() * speed   
    end
end

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2} 

local x_offset, y_offset = screen[1], screen[2]
local x, y =  x_offset/2,y_offset/2 

local rgba_to_hex = function(b, c, d, e)
    return string.format('%02x%02x%02x%02x', b, c, d, e)
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function clamp(x, minval, maxval)
    if x < minval then
        return minval
    elseif x > maxval then
        return maxval
    else
        return x
    end
end
local function text_fade_animation(x, y, speed, color1, color2, text, flag)
    local final_text = ''
    local curtime = globals.curtime()
    for i = 0, #text do
        local x = i * 10  
        local wave = math.cos(8 * speed * curtime + x / 30)
        local color = rgba_to_hex(
            lerp(color1.r, color2.r, clamp(wave, 0, 1)),
            lerp(color1.g, color2.g, clamp(wave, 0, 1)),
            lerp(color1.b, color2.b, clamp(wave, 0, 1)),
            color1.a
        ) 
        final_text = final_text .. '\a' .. color .. text:sub(i, i) 
    end
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, flag, nil, final_text)
end

local xpos = 0
local references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}


local spread_amount = 0

---
local last_sim_time = 0
local native_GetClientEntity = vtable_bind('client.dll', 'VClientEntityList003', 3, 'void*(__thiscall*)(void*, int)')
function is_defensive_active()
    local lp = entity.get_local_player()
    if lp == nil or not entity.is_alive(lp) then return end
    local m_flOldSimulationTime = ffi.cast("float*", ffi.cast("uintptr_t", native_GetClientEntity(lp)) + 0x26C)[0]
    local m_flSimulationTime = entity.get_prop(lp, "m_flSimulationTime")
    local delta = toticks(m_flOldSimulationTime - m_flSimulationTime)
    if delta > 0 then
        last_sim_time = globals.tickcount() + delta - toticks(client.real_latency())
    end
    return last_sim_time > globals.tickcount()
end
---

local def_ind_check = 0

math.lerp = function(name, value, speed)
    return name + (value - name) * globals.absoluteframetime() * speed
end

alpha_ind = 0
alpha_vel = 0
vel_amount = 0
def_amount = 0
def_cross = 0
spread_lerp = 0
RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

local logo
local function downloadFileLogo()
	http.get("https://cdn.discordapp.com/attachments/1062810573814910987/1216864522703474799/purple-saturn-planet-png.png?ex=6601f066&is=65ef7b66&hm=69edf57f1158627067dc9f3347e162d7c7fea2bf8b505702dc4066ed74abb66a&", function(success, response)
		if not success or response.status ~= 200 then
            return
		end

		logo = images.load(response.body)
	end)
end
downloadFileLogo()

local function onscreen_elements()  
	local spacing = 0 
    local indi_state = string.upper(xxx)
    local acti_indi_state = ui.get(rage[state_to_num[xxx]].enable) and indi_state or 'GLOBAL'
    local lp = entity.get_local_player()
    local r, g, b, a = ui.get(etterance.visual.indicator_col)
    local r1, g1, b1, a1 = ui.get(etterance.visual.indicator_col2)
	local indicatormaster = ui.get(etterance.luaenable)

    screen = {client.screen_size()}
    center = {screen[1]/2, screen[2]/2} 
    local accent = { ui.get(etterance.visual.watermark_color) }

	local scpd = entity.get_prop(lp, "m_bIsScoped")
    lsms = renderer.measure_text(nil, "E T T E ")
    lsms2 = renderer.measure_text(nil, "R A N C E")
    if ui.get(etterance.visual.watermark) == "Default" then
        renderer.text(20, center[2], 150, 150, 150, 255,  "", 0,  "E T T E ")
        text_fade_animation(20+lsms, center[2], -1, {r=200, g=200, b=200, a=255}, {r=accent[1], g=accent[2], b=accent[3], a=255}, "R A N C E", "")
        renderer.text(20+lsms+lsms2, center[2], 150, 150, 150, 255,  "", 0,  " \aFF5858FF[DEBUG V2]")
    else
        if logo ~= nil then
            logo:draw(0,center[2] - 7, 40, 40, 255,255,255,255)
        else
            downloadFileLogo()
        end

        local white = { 255, 255, 255, 255 }
        local design_accent_color = { accent[1], accent[2], accent[3], 255 }

        local text = { 
            [1] = string.format('ETTERANCE\a%s.TECH', RGBAtoHEX(design_accent_color[1], design_accent_color[2],design_accent_color[3],design_accent_color[4])),
            [2] = string.format('USER - %s [\a%s%s\a%s]', string.upper(euphemia.username), RGBAtoHEX(design_accent_color[1], design_accent_color[2],design_accent_color[3],design_accent_color[4]), string.upper(euphemia.build), RGBAtoHEX(white[1], white[2], white[3], white[4]))
        }
        local measure = { renderer.measure_text('-', text[2]) }
    
        renderer.text(40, center[2] + 5, 255, 255, 255, 255, '-', 0, text[1])
        renderer.text(40, center[2] + (measure[2] + 2), 255, 255, 255, 255, '-', 0, text[2])
    end
    xpos = animation(scpd == 1, xpos, 20, 20)

    if indicatormaster and ui.get(etterance.visual.arrows_enable) and entity.is_alive(lp) then
        vx, vy, vz = entity.get_prop(lp, "m_vecVelocity[0]"), entity.get_prop(lp, "m_vecVelocity[1]"), entity.get_prop(lp, "m_vecVelocity[2]")
        vel = math.sqrt(vx ^ 2 + vy ^ 2+ vz ^ 2)/10
        spread_lerp = math.lerp(spread_lerp, vel, 8)
        r2, g2, b2, a2 = ui.get(etterance.visual.arrows_col)
        spread_amount = ui.get(etterance.visual.arrows_type) == "Default" and ui.get(etterance.visual.arrows_slider) or spread_lerp

        if yaw_direction == -90 then
            renderer.text(center[1] - 60 - spread_amount, center[2]-xpos-35, r2, g2, b2, 200, "+b", 0, "<")
            renderer.text(center[1] + 50 + spread_amount, center[2]-xpos-35, 175, 175, 175, 255, "+b", 0, ">")
        elseif yaw_direction == 90 then
            renderer.text(center[1] - 60 - spread_amount, center[2]-xpos-35, 175, 175, 175, 255, "+b", 0, "<")
            renderer.text(center[1] + 50 + spread_amount, center[2]-xpos-35, r2, g2, b2, 200, "+b", 0, ">")            
        else
            renderer.text(center[1] - 60 - spread_amount, center[2]-xpos-35, 175, 175, 175, 255, "+b", 0, "<")
            renderer.text(center[1] + 50 + spread_amount, center[2]-xpos-35, 175, 175, 175, 255, "+b", 0, ">")  
        end
    end

	center[1] = center[1] + xpos
    if indicatormaster and entity.is_alive(lp) then   
        if contains(ui.get(etterance.visual.indicator_select), 'Crosshair Indicators') and ui.get(etterance.visual.indicator_enable) then
            if ui.get(etterance.visual.indicator_type) == "Default" then
                ind_size = renderer.measure_text("c-d", "ETTERANCE.TECH")
                text_fade_animation(center[1] + 19, center[2] + 21, 1, {r=r, g=g, b=b, a=255}, {r=r1, g=g1, b=b1, a=255}, "DEBUG", "c-d")
                text_fade_animation(center[1] + 19, center[2] + 29, 1, {r=r, g=g, b=b, a=255}, {r=r1, g=g1, b=b1, a=255}, "ETTERANCE.TECH", "c-d")



                def_cross = math.abs(entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60)/60

                renderer.rectangle(center[1]-10, center[2] + 34, ind_size+1, 5, 0, 0, 0, 255)
                renderer.gradient(center[1]-9, center[2] + 35, def_cross*ind_size, 3, r, g, b, 255, r, g, b, 0, true)

                renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), r, g, b, 255,  "c-d", 0,  '' .. acti_indi_state .. '')
                spacing = spacing + 1

                if ui.get(references.minimum_damage_override[2]) then
                    renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), r, g, b, 255, "c-d", 0, "DMG")
                    spacing = spacing + 1
                end

                if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                    if doubletap_charged() then
                        renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), r, g, b, a, "c-d", 0, "DT")
                    else
                        renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), 145, 145, 145, 255, "c-d", 0, "DT")
                    end
                    spacing = spacing + 1
                end

                if ui.get(ref.os[2]) then
                    renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), r, g, b, 255, "c-d", 0, "OSAA")
                    spacing = spacing + 1
                end

                if ui.get(etterance.keybinds.key_freestand) then
                    renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), r, g, b, 255, "c-d", 0, "FS")
                    spacing = spacing + 1
                end

                if ui.get(ref.forcebaim)then
                    renderer.text(center[1] + 19, center[2] + 43 + (spacing * 8), 255, 102, 117, 255, "c-d", 0, "BODY")
                    spacing = spacing + 1
                end
            else
                renderer.text(center[1] + 21, center[2] + 29 + (spacing * 11), r, g, b, 255,  "c-b", 0,  "etterance")
                renderer.text(center[1] + 21, center[2] + 39 + (spacing * 11), r1, g1, b1, 255,  "c", 0,  '' .. string.lower(acti_indi_state) .. '')

                if ui.get(references.minimum_damage_override[2]) then
                    renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 200, 200, 200, 255, "c", 0, "dmg")
                    spacing = spacing + 1
                end

                if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then
                    if doubletap_charged() then
                        renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 200, 200, 200, a, "c", 0, "dt")
                    else
                        renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 145, 145, 145, 255, "c", 0, "dt")
                    end
                    spacing = spacing + 1
                end

                if ui.get(ref.os[2]) then
                    renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 200, 200, 200, 255, "c", 0, "osaa")
                    spacing = spacing + 1
                end

                if ui.get(etterance.keybinds.key_freestand) then
                    renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 200, 200, 200, 255, "c", 0, "fs")
                    spacing = spacing + 1
                end

                if ui.get(ref.forcebaim)then
                    renderer.text(center[1] + 21, center[2] + 50 + (spacing * 11), 255, 102, 117, 255, "c", 0, "body")
                    spacing = spacing + 1
                end

            end
        end

        if contains(ui.get(etterance.visual.indicator_select), 'Damage Indicator') then
            if ui.get(references.minimum_damage_override[2]) then
                renderer.text(screen[1] / 2 + 5, screen[2] / 2 - 14, 255, 255, 255, 225, "d", 0, ui.get(references.minimum_damage_override[3]) .. "")
            else
                renderer.text(screen[1] / 2 + 5, screen[2] / 2 - 14, 255, 255, 255, 225, "d", 0, ui.get(references.minimum_damage) .. "")
            end
        end

        if ui.get(etterance.visual.window_enable) then
            if contains(ui.get(etterance.visual.window_select), 'Defensive Manager') then

                if not ui.is_menu_open() then
                    if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) and not ui.get(ref.fakeduck) then
                        alpha_ind = math.lerp(alpha_ind, 255, 10)
                    else
                        alpha_ind = math.lerp(alpha_ind, 0, 10)
                    end

                    if not doubletap_charged() then
                        def_ind_check = math.lerp(def_ind_check, 0.1, 10)
                    elseif doubletap_charged() and is_defensive_active() then
                        def_ind_check = math.lerp(def_ind_check, 1, 10)
                    else
                        def_ind_check = math.lerp(def_ind_check, 0.5, 10)
                    end
                else
                    alpha_ind = math.lerp(alpha_ind, 255, 10)
                    def_ind_check = globals.tickcount() % 50/100 * 2
                end

                if not doubletap_charged() then
                    renderer.text(screen[1]/2, screen[2] / 4-10, 255, 255, 255, alpha_ind, "c-d", 0, "DEFENSIVE:   \a"..RGBAtoHEX(255, 0, 0, alpha_ind).."CHARGE")
                elseif doubletap_charged() and not is_defensive_active() then
                    renderer.text(screen[1]/2, screen[2] / 4-10, 255, 255, 255, alpha_ind, "c-d", 0, "DEFENSIVE:   READY")
                else
                    renderer.text(screen[1]/2, screen[2] / 4-10, 255, 255, 255, alpha_ind, "c-d", 0, "DEFENSIVE: CHOCKED")
                end

                local r4, g4, b4, a4 = ui.get(etterance.visual.window_col)

                renderer.gradient(screen[1]/2 - (50 *def_ind_check), screen[2] / 4, 1 + 50*def_ind_check, 2, r4, g4, b4, alpha_ind/3, r4, g4, b4, alpha_ind, true)
                renderer.gradient(screen[1]/2, screen[2] / 4, 50*def_ind_check, 2, r4, g4, b4, alpha_ind, r4, g4, b4, alpha_ind/3, true)
            end
        end
        if contains(ui.get(etterance.visual.window_select), 'Slowed Down') then
            vel_mod = entity.get_prop(lp, 'm_flVelocityModifier')

            if not ui.is_menu_open() then
                if vel_mod < 1 then
                    alpha_vel = math.lerp(alpha_vel, 255, 10)
                else
                    alpha_vel = math.lerp(alpha_vel, 0, 10)
                end
                vel_amount = math.lerp(vel_amount, vel_mod, 10)
            else
                alpha_vel = math.lerp(alpha_vel, 255, 10)
                vel_amount = globals.tickcount() % 50/100 * 2
            end

            local r5, g5, b5, a5 = ui.get(etterance.visual.window_col2)

            renderer.text(screen[1]/2, screen[2] / 3 - 10, 255, 255, 255, alpha_vel, "c-d", 0, "VELOCITY:   "..math.floor(vel_mod*100).." %")
            renderer.gradient(screen[1]/2 - (50 *vel_amount), screen[2] / 3, 1 + 50*vel_amount, 2, r5, g5, b5, alpha_vel/3, r5, g5, b5, alpha_vel, true)
            renderer.gradient(screen[1]/2, screen[2] / 3, 50*vel_amount, 2, r5, g5, b5, alpha_vel, r5, g5, b5, alpha_vel/3, true)
        end
    end
end

local logs = {}
local function ragebot_logs()
    local offset, x, y = 0, screen[1] / 2, screen[2] / 1.4
    for idx, data in ipairs(logs) do
        if (((globals.curtime() /2) * 2.0) - data[3]) < 4.0 and not (#logs > 5 and idx < #logs - 5) then
            data[2] = math.lerp(data[2], 255, 10)
        else
            data[2] = math.lerp(data[2], 0, 10)
        end
        offset = offset - 35 * (data[2] / 255)

        text_size_x, text_sise_y = renderer.measure_text("", data[1])
        local r6, g6, b6, a6 = ui.get(etterance.visual.log_col)
        if ui.get(etterance.visual.logs_vis) == "Default" then
            renderer.rectangle(x - 6 - text_size_x / 2, y - offset-5, text_size_x + 11, 22, 15,15,15, data[2] / 1) -- обводка 2 пикселя
            -- слева
            renderer.gradient(x - 6 - text_size_x / 2, y - offset-5, 20, 1, r6, g6, b6, data[2], r6, g6, b6, data[2], true) -- Вверхня вправо
            renderer.gradient(x - 6 - text_size_x / 2, y - offset-5, 1, 6, r6, g6, b6, data[2], r6, g6, b6, data[2], false) -- Вверх - вниз
            renderer.gradient(x - 6 - text_size_x / 2, y - offset-6+22, 20, 1, r6, g6, b6, data[2], r6, g6, b6, data[2], true) --нижняя вправо
            renderer.gradient(x - 6 - text_size_x / 2, y - offset-5+22, 1, -6, r6, g6, b6, data[2], r6, g6, b6, data[2], false) -- нижняя вверх
            --справа
            renderer.gradient(x - 15 + text_size_x / 2, y - offset-5, 20, 1, r6, g6, b6, data[2], r6, g6, b6, data[2], true) -- сверху - налево
            renderer.gradient(x + 4 + text_size_x / 2, y - offset-5, 1, 6, r6, g6, b6, data[2], r6, g6, b6, data[2], true) -- сверху - вниз
            renderer.gradient(x + 4 + text_size_x / 2, y - offset-5+22, 1, -6, r6, g6, b6, data[2], r6, g6, b6, data[2], true)
            renderer.gradient(x - 15 + text_size_x / 2, y - offset-6+22, 20, 1, r6, g6, b6, data[2], r6, g6, b6, data[2], true) -- нижняя

        elseif ui.get(etterance.visual.logs_vis) == "Alternative" then
            render_ogskeet_border(x - text_size_x / 2 -1, y - offset+37, text_size_x, 17, data[2])
        end
        renderer.text(x - 1 - text_size_x / 2, y - offset - 1, 255, 255, 255, data[2], "", 0, data[1])

        if data[2] < 0.1 or not entity.get_local_player() then table.remove(logs, idx) end
    end
end

renderer.log = function(text, size)
    table.insert(logs, { text, 0, ((globals.curtime() / 2) * 2.0), size})
end

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local function aim_hit(e)
    if not ui.get(etterance.visual.rage_logs) then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    if contains(ui.get(etterance.visual.logs_type), 'Console') then
	    print(string.format('Hit %s in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
    end
    if contains(ui.get(etterance.visual.logs_type), 'Screen') then
        renderer.log(string.format('Hit %s in the %s for %d damage (%d health remaining)', entity.get_player_name(e.target), group, e.damage, entity.get_prop(e.target, 'm_iHealth')))
    end
end
client.set_event_callback('aim_hit', aim_hit)

local function aim_miss(e)
    if not ui.get(etterance.visual.rage_logs) then return end
	local group = hitgroup_names[e.hitgroup + 1] or '?'
    if contains(ui.get(etterance.visual.logs_type), 'Console') then
	    print(string.format('Missed %s in the %s due to %s. hs: %s', entity.get_player_name(e.target), group, e.reason, math.floor(e.hit_chance)))
    end
    if contains(ui.get(etterance.visual.logs_type), 'Screen') then
        renderer.log(string.format('Missed %s in the %s due to %s. hs: %s', entity.get_player_name(e.target), group, e.reason, math.floor(e.hit_chance)))
    end
end
client.set_event_callback('aim_miss', aim_miss)

distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

current_tickcount = 0
to_jitter = false
local desync_side = 1
local state = 1
client.set_event_callback('setup_command', function(e)
    local localplayer = entity.get_local_player()

    if localplayer == nil or not entity.is_alive(localplayer) or not ui.get(etterance.luaenable) then
        return
    end

    state = get_mode(e)

    ui.set(ref.enabled, true)
    state = ui.get(rage[state_to_num[state]].enable) and state_to_num[state] or state_to_num['Global']

    handle_keybinds()
    run_direction() 
    ui.set(ref.pitch[1], ui.get(etterance.antiaim.c_pitch))
    ui.set(ref.yawbase, ui.get(etterance.antiaim.c_yawbase))
    ui.set(ref.yaw[1], ui.get(etterance.antiaim.c_yaw))
    if ui.get(rage[state].c_jitter_mode) == "Default" then
        ui.set(ref.yawjitter[2], ui.get(rage[state].c_jitter_slider))
    else
        ui.set(ref.yawjitter[2], e.command_number % math.random(3,6) == 0 and ui.get(rage[state].c_jitter_slider) + 15 or ui.get(rage[state].c_jitter_slider))
    end
    ui.set(ref.yawjitter[1], ui.get(rage[state].c_jitter))
	ui.set(ref.roll[1], 0)
    if ui.get(rage[state].yaw_type) ~= "Delay" and ui.get(rage[state].yaw_type) ~= "Delayed Yaw" then
        ui.set(ref.bodyyaw[1], ui.get(rage[state].c_body))
        ui.set(ref.bodyyaw[2], ui.get(rage[state].body_slider))
    end
    ui.set(ref.fsbodyyaw, ui.get(rage[state].freestand_lby))

	local desync_type = entity.get_prop(localplayer, 'm_flPoseParameter', 11) * 120 - 60
	desync_side = desync_type > 0 and 1 or -1


    if globals.tickcount() > current_tickcount + ui.get(rage[state].delay_ticks) then
        if e.chokedcommands == 0 then
           to_jitter = not to_jitter
           current_tickcount = globals.tickcount()
        end
    elseif globals.tickcount() <  current_tickcount then
        current_tickcount = globals.tickcount()
    end

    if ui.get(rage[state].yaw_type) == "Static" then
        ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].limit)) or yaw_direction)
    elseif ui.get(rage[state].yaw_type) == "l&r" then
        if desync_side == 1 then
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].l_limit)) or yaw_direction)
        elseif desync_side == -1 then
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].r_limit)) or yaw_direction)
        end
    elseif ui.get(rage[state].yaw_type) == "Delay" then
        if to_jitter then
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].l_limit)) or yaw_direction)
            ui.set(ref.bodyyaw[2], -1)
        else
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].r_limit)) or yaw_direction)
            ui.set(ref.bodyyaw[2], 1)
        end
        ui.set(ref.bodyyaw[1], "Static")
    else
        if to_jitter then
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].l_limit)) or yaw_direction)
        else
            ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].r_limit)) or yaw_direction)
        end
        ui.set(ref.bodyyaw[1], "Static")
        ui.set(ref.bodyyaw[2], 1)
    end


    weapon_type = entity.get_player_weapon(localplayer)
    weapon_class = entity.get_classname(weapon_type)
    if state == 6 then
        if contains(ui.get(etterance.main.safehead), 'Knife') and weapon_class == "CKnife" then
            ui.set(ref.yaw[2], 6)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif contains(ui.get(etterance.main.safehead), 'Taser') and weapon_class == "CWeaponTaser" then
            ui.set(ref.yaw[2], 6)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif contains(ui.get(etterance.main.safehead), 'Scout') and weapon_class == "CWeaponSSG08" then
            ui.set(ref.yaw[2], 6)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        elseif contains(ui.get(etterance.main.safehead), 'Awp') and weapon_class == "CWeaponAWP" then
            ui.set(ref.yaw[2], 6)
            ui.set(ref.bodyyaw[2], 1)
            ui.set(ref.yawbase, "At targets")
            ui.set(ref.bodyyaw[1], "Static")
            ui.set(ref.yawjitter[2], 0)
            ui.set(ref.yawjitter[1], "Off")
        end
    end  
    
    if ui.get(etterance.keybinds.static_yaw) and ui.get(etterance.keybinds.key_freestand) then
        ui.set(ref.yaw[2], 6)
        ui.set(ref.bodyyaw[2], 1)
        ui.set(ref.yawbase, "At targets")
        ui.set(ref.bodyyaw[1], "Static")
        ui.set(ref.yawjitter[2], 0)
    end


    if contains(ui.get(etterance.main.addons_aa), 'Shit AA On Warmup') then
        if entity.get_prop(entity.get_game_rules(), "m_bWarmupPeriod") == 1 then
            ui.set(ref.yaw[2], math.random(-180, 180))
            ui.set(ref.yawjitter[2], math.random(-180, 180))
            ui.set(ref.bodyyaw[2], math.random(-180, 180))
        end
    end

    if contains(ui.get(etterance.main.addons_aa), 'Anti~Backstab') then
        players = entity.get_players(true)
        lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 250 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.yawbase, "At targets")
            end
        end
    end

end)

function normalize_yaw(yaw) yaw = (yaw % 360 + 360) % 360 return yaw > 180 and yaw - 360 or yaw end

client.set_event_callback("setup_command", function(e)
    local pitch_tbl = {
        ['Disabled'] = 89,
        ['Up'] = -89,
        ['Zero'] = 0,
        ['Random'] = math.random(-89, 89),
        ['Custom'] = ui.get(rage[state].pitch_amount)
    }
	
	local yaw_tbl = {
        ['Disabled'] = 0,
        ['Sideways'] = globals.tickcount() % 3 == 0 and client.random_int(-100, -90) or globals.tickcount() % 3 == 1 and 180 or globals.tickcount() % 3 == 2 and client.random_int(90, 100) or 0,
        ['Random'] = math.random(-180, 180),
        ['Spin'] = normalize_yaw(globals.curtime() * 1000),
        ['3-Way'] = globals.tickcount() % 3 == 0 and client.random_int(-110, -90) or globals.tickcount() % 3 == 1 and client.random_int(90, 120) or globals.tickcount() % 3 == 2 and client.random_int(-180, -150) or 0,
        ['5-Way'] = globals.tickcount() % 5 == 0 and client.random_int(-90, -75) or globals.tickcount() % 5 == 1 and client.random_int(-45, -30) or globals.tickcount() % 5 == 2 and client.random_int(-180, -160) or globals.tickcount() % 5 == 3 and client.random_int(45, 60) or globals.tickcount() % 5 == 3 and client.random_int(90, 110) or 0
	}

    if e.chokedcommands > 1 then return end
    if ui.get(rage[state].c_pitch_exp) then
        e.force_defensive = ui.get(rage[state].c_exp_type) == "Always On" and 1 or 0
        if is_defensive_active() then
        ---YAW
            ui.set(ref.yaw[1], "180")
            ui.set(ref.yaw[2], yaw_tbl[ui.get(rage[state].exp_yaw)])

            ui.set(ref.pitch[1], "Custom") 
            ui.set(ref.pitch[2], pitch_tbl[ui.get(rage[state].exp_pitch)])
        end
    end
end)

local lastmiss = 0
local function GetClosestPoint(A, B, P)
    a_to_p = { P[1] - A[1], P[2] - A[2] }
    a_to_b = { B[1] - A[1], B[2] - A[2] }

    atb2 = a_to_b[1]^2 + a_to_b[2]^2

    atp_dot_atb = a_to_p[1]*a_to_b[1] + a_to_p[2]*a_to_b[2]
    t = atp_dot_atb / atb2
    
    return { A[1] + a_to_b[1]*t, A[2] + a_to_b[2]*t }
end
local bruteforce_reset = true
local stage = 0
local shot_time = 0


client.set_event_callback("bullet_impact", function(e)
    if ui.get(etterance.antiaim.ab_enable) == false then return end
    
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
    if math.abs(delta_2d) <= 60 and globals.curtime() - lastmiss > 0.015 then
        lastmiss = globals.curtime()
        bruteforce = true
        shot_time = globals.realtime()
        stage = stage >= ui.get(etterance.antiaim.ab_phases) and 0 or stage + 1
        stage = stage == 0 and 1 or stage
        if contains(ui.get(etterance.visual.logs_type), 'Screen') then
            renderer.log("Anti~Bruteforce Angle Switched. Enemy: "..entity.get_player_name(ent)..". Stage: "..stage)
        end
    end
end)

local function Returner()
    brut3 = true
    return brut3
end

client.set_event_callback("setup_command", function(cmd)
    if bruteforce and ui.get(etterance.antiaim.ab_enable) then
        client.set_event_callback("paint_ui", Returner)
        bruteforce = false
        bruteforce_reset = false
        stage = stage == 0 and 1 or stage
        set_brute = true
    else
        if shot_time + 3 < globals.realtime() or not ui.get(etterance.antiaim.ab_enable) then
            client.unset_event_callback("paint_ui", Returner)
            set_brute = false
            brut3 = false
            stage = 0
            bruteforce_reset = true
            set_brute = false
        end
    end
    return shot_time
end)

client.set_event_callback("setup_command", function(cmd)
    ground_check = cmd.in_jump == 0
    if set_brute == false then return end
    if contains(ui.get(brute_table[stage].select), "Jitter") then
        ui.set(ref.yawjitter[2], ui.get(brute_table[stage].jitter))
    end
    if contains(ui.get(brute_table[stage].select), "Body Yaw") then
        ui.set(ref.bodyyaw[2], ui.get(brute_table[stage].body))
    end
end)

local function is_vulnerable()
    for _, v in ipairs(entity.get_players(true)) do
        local flags = (entity.get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            return true
        end
    end

    return false
end

client.set_event_callback("setup_command", function(cmd)
    if ui.get(etterance.misc.breaklc) and ui.get(etterance.misc.lc_key) then
        if is_vulnerable() and cmd.in_jump == 1 then
            cmd.force_defensive = true
            cmd.discharge_pending = true
        end
    end
end)

local slidewalk_directory = ui.reference("AA", "other", "leg movement")

client.set_event_callback("pre_render", function()
    if not ui.get(etterance.visual.anims_enable) then return end
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()
    if not self_anim_state then
        return
    end
    if ui.get(etterance.visual.anims_ground) == "Follow Legs" then
        ui.set(slidewalk_directory, "Always slide")
        entity.set_prop(self, "m_flPoseParameter", 1, 0)
    elseif ui.get(etterance.visual.anims_ground) == "Jitter Legs" then
        ui.set(slidewalk_directory, globals.tickcount() % 4 > 1 and "Always slide" or "Off")
        entity.set_prop(self, "m_flPoseParameter", 1, globals.tickcount() % 6 > 2 and 0 or 3)
    elseif ui.get(etterance.visual.anims_ground) == "MoonWalk" then
        ui.set(slidewalk_directory, "Never slide")
        entity.set_prop(self, "m_flPoseParameter", 0, 7)
    end

    if ui.get(etterance.visual.anims_air) == "Static Legs" then
        entity.set_prop(self, "m_flPoseParameter", 1, 6)
    elseif ui.get(etterance.visual.anims_air) == "MoonWalk" then
        local self_anim_overlay_air = self_index:get_anim_overlay(6)
        if not self_anim_overlay_air then
            return
        end
        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay_air.weight = 1
        end
    end

    if contains(ui.get(etterance.visual.anims_other), "Move Lean") then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end
        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = 1
        end
    end
    if contains(ui.get(etterance.visual.anims_other), "Pitch 0 On Land") then
        if not self_anim_state.hit_in_ground_animation or not ground_check then
            return
        end

        entity.set_prop(self, "m_flPoseParameter", 0.5, 12)
    end 
end)

client.set_event_callback("setup_command", function(e)
    if not contains(ui.get(etterance.misc.misc_other), "Fast Ladder") then return end
    local local_player = entity.get_local_player()
    local pitch, yaw = client.camera_angles()
    if entity.get_prop(local_player, "m_MoveType") == 9 then
        e.yaw = math.floor(e.yaw+0.5)
        e.roll = 0

            if e.forwardmove == 0 then
                e.pitch = 89
                e.yaw = e.yaw + 180
                if math.abs(180) > 0 and math.abs(180) < 180 and e.sidemove ~= 0 then
                    e.yaw = e.yaw - ui_get(180)
                end
                if math.abs(180) == 180 then
                    if e.sidemove < 0 then
                        e.in_moveleft = 0
                        e.in_moveright = 1
                    end
                    if e.sidemove > 0 then
                        e.in_moveleft = 1
                        e.in_moveright = 0
                    end
                end
            end

            if e.forwardmove > 0 then
                if pitch < 45 then
                    e.pitch = 89
                    e.in_moveright = 1
                    e.in_moveleft = 0
                    e.in_forward = 0
                    e.in_back = 1
                    if e.sidemove == 0 then
                        e.yaw = e.yaw + 90
                    end
                    if e.sidemove < 0 then
                        e.yaw = e.yaw + 150
                    end
                    if e.sidemove > 0 then
                        e.yaw = e.yaw + 30
                    end
                end 
            end


            if e.forwardmove < 0 then
                e.pitch = 89
                e.in_moveleft = 1
                e.in_moveright = 0
                e.in_forward = 1
                e.in_back = 0
                if e.sidemove == 0 then
                    e.yaw = e.yaw + 90
                end
                if e.sidemove > 0 then
                    e.yaw = e.yaw + 150
                end
                if e.sidemove < 0 then
                    e.yaw = e.yaw + 30
                end
            end
    end
end)


local phrases = {
    "гуд лак шалава",
    "бля извини пошёл нахуй",
    "русский чит всегда был хуевый",
    "ты че gamesense оплатил а играть не научился((",
    "by ETTERANCE хуесос",
    "пизда и хуй не совместимы",
    "изи пидорас",
    "опять в хуй деда",
    "1.",
    "уууу 1",
    "иди дальше пизду лежи",
    "ай шлюхаааа на хуй села",
    "by BLAMELESS HVH ETTERANCE TECH",
    "уебише санное",
    "найс luasense далбаеб",
    "хуя ты кляча",
    "че папке в мамке",
    "изи пиздачес",
    "изи пизи лемонсквизи",
    "Встань на колени, ты, собака",
    "Это xo-yaw или почему ты сразу умер?",
    "ешки матрешки вот это вантапчик",
    'каадык мне в зад вот это я тебе ебло снес красиво',
    'сейчас в попу, потом в ротик',
    'где мозги потерял шаболда',
    'бегите сука, папочка идет...',
    'братец тут уже нихуя не поможет',
    'передавило ослинской мочой',
    'залил очко спермой',
    'где мозги потерял шаболда',
    'анально наказан',
    'где носопырку потерял',
    'опять шляпа слетела, анти-попадайки не помогли',
    'ты че spacex - собака хохлятская или как ты умер?',
    'Ты че собака хохлятская spacex? Купила? Ну отлетаешь нахуй',
    'фанат ебаный в колени упал .!.',
    'Под шконку уебище',
    'Пошёл чефирить сучок'
}

local userid_to_entindex, get_local_player, is_enemy, console_cmd = client.userid_to_entindex, entity.get_local_player, entity.is_enemy, client.exec

local function on_player_death(e)
    if not contains(ui.get(etterance.misc.misc_other), "TrashTalk") then return end

	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)

	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
        client.delay_call(2, function() console_cmd("say ", phrases[math.random(1, #phrases)]) end)
	end
end
client.set_event_callback("player_death", on_player_death)


local function console_filter()
    checker_cons = contains(ui.get(etterance.misc.misc_other), "Console Filter")
    cvar.con_filter_enable:set_int(checker_cons and 1 or 0)  
    cvar.con_filter_text:set_int(checker_cons and 1 or 0)
    cvar.con_filter_text_out:set_int(checker_cons and 1 or 0)
end
console_filter()
ui.set_callback(etterance.misc.misc_other, console_filter)


client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback('paint_ui', function()
    ragebot_logs()
    if not ui.is_menu_open() then return end
    set_lua_menu()
    handle_menu()
    hide_original_menu(not (ui.get(etterance.luaenable)))
end)

client.set_event_callback('paint', function()
    onscreen_elements()
end)

--cfg system

local function getConfig(name)
    local database = database.read(lua.database.configs) or {}

    for i, v in pairs(database) do
        if v.name == name then
            return {
                config = v.config,
                index = i
            }
        end
    end

    return false
end
local function saveConfig(name)
    local db = database.read(lua.database.configs) or {}
    local config = {}

    if name:match("[^%w]") ~= nil then
        return
    end

    for key, value in pairs(aa_config) do
        config[value] = {}
        for k, v in pairs(rage[key]) do
            config[value][k] = ui.get(v)
        end
    end

    local cfg = getConfig(name)

    if not cfg then
        table.insert(db, { name = name, config = config })
    else
        db[cfg.index].config = config
    end

    database.write(lua.database.configs, db)
end
local function deleteConfig(name)
    local db = database.read(lua.database.configs) or {}

    for i, v in pairs(db) do
        if v.name == name then
            table.remove(db, i)
            break
        end
    end

    database.write(lua.database.configs, db)
end
local function getConfigList()
    local database = database.read(lua.database.configs) or {}
    local config = {}

    for i, v in pairs(database) do
        table.insert(config, v.name)
    end

    return config
end

local function loadSettings(config)
    for key, value in pairs(aa_config) do
        for k, v in pairs(rage[key]) do
            if (config[value][k] ~= nil) then
                print(config[value][k])
                ui.set(v, config[value][k])
            end
        end 
    end
end
local function importSettings()
    loadSettings(json.parse(base64.decode(clipboard.get())))
end
local function exportSettings(name)
    local config = {}
    for key, value in pairs(aa_config) do
        config[value] = {}
        for k, v in pairs(rage[key]) do
            config[value][k] = ui.get(v)
        end
    end
    
    clipboard.set(base64.encode(json.stringify(config)))
end

ui.update(etterance.config.list,getConfigList())
if database.read(lua.database.configs) == nil then
    database.write(lua.database.configs, {})
end
ui.set(etterance.config.name, #database.read(lua.database.configs) == 0 and "" or database.read(lua.database.configs)[ui.get(etterance.config.list)+1].name)
ui.set_callback(etterance.config.list, function(value)
    local protected = function()
        if value == nil then return end
        local name = ""
    
        local configs = getConfigList()
        if configs == nil then return end
    
        name = configs[ui.get(value)+1] or ""
    
        ui.set(etterance.config.name, name)
    end

    if pcall(protected) then

    end
end)

local function loadConfig(name)
    local config = getConfig(name)
    loadSettings(config.config)
end

ui.set_callback(etterance.config.load, function()
    local name = ui.get(etterance.config.name)
    if name == "" then return end
    local protected = function()
        loadConfig(name)
    end

    if pcall(protected) then
        name = name:gsub('*', '')
        renderer.log('Successfully Loaded')
        print('Successfully Loaded')
    else
        renderer.log('Failed To Load')
        print('Failed To Load')
    end
end)

ui.set_callback(etterance.config.save, function()
        local name = ui.get(etterance.config.name)
        if name == "" then return end
    
        if name:match("[^%w]") ~= nil then
            renderer.log('Failed To Save')
            print('Failed To Save')
            return
        end
    local protected = function()
        saveConfig(name)
        ui.update(etterance.config.list, getConfigList())
    end
    if pcall(protected) then
        renderer.log('Saved')
        print('Saved')
    end
end)

ui.set_callback(etterance.config.delete, function()
    local name = ui.get(etterance.config.name)
    if name == "" then return end
    if deleteConfig(name) == false then
        renderer.log('Failed To Delete')
        print('Failed To Delete')
        ui.update(etterance.config.list, getConfigList())
        return
    end
    local protected = function()
        deleteConfig(name)
    end

    if pcall(protected) then
        ui.update(etterance.config.list, getConfigList())
        ui.set(etterance.config.list, #database.read(lua.database.configs) - #database.read(lua.database.configs))
        ui.set(etterance.config.name, #database.read(lua.database.configs) == 0 and "" or getConfigList()[#database.read(lua.database.configs) - #database.read(lua.database.configs)+1])
        renderer.log('Deleted Config')
        print('Deleted Config')
    end
end)

ui.set_callback(etterance.config.import, function()
    local protected = function()
        importSettings()
    end

    if pcall(protected) then
        renderer.log('Successfully Import Config')
        print('Successfully Import Config')
    else
        renderer.log('Failed To Import Config')
        print('Failed To Import Config')
    end

end)

ui.set_callback(etterance.config.export, function()
    local name = ui.get(etterance.config.name)
    if name == "" then return end

    local protected = function()
        exportSettings(name)
    end

    if pcall(protected) then
        renderer.log('Successfully Exported Config: '..name)
        print('Successfully Exported Config: '..name)
    else
        renderer.log('Failed To Export Config: '..name)
        print('Failed To Export Config: '..name)
    end
end)