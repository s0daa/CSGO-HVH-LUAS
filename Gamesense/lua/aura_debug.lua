local ffi = require('ffi')
local vector = require('vector')
local http = require("gamesense/http") 

local shl, shr, band = bit.lshift, bit.rshift, bit.band
local char, byte, gsub, sub, format, concat, tostring, error, pairs = string.char, string.byte, string.gsub, string.sub, string.format, table.concat, tostring, error, pairs

local extract = function(v, from, width)
	return band(shr(v, from), shl(1, width) - 1)
end

local function makeencoder(alphabet)
	local encoder, decoder = {}, {}
	for i=1, 65 do
		local chr = byte(sub(alphabet, i, i)) or 32 -- or ' '
		if decoder[chr] ~= nil then
			error('invalid alphabet: duplicate character ' .. tostring(chr), 3)
		end
		encoder[i-1] = chr
		decoder[chr] = i-1
	end
	return encoder, decoder
end

local encoders, decoders = {}, {}

encoders['base64'], decoders['base64'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
encoders['base64url'], decoders['base64url'] = makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_')

local alphabet_mt = {
	__index = function(tbl, key)
		if type(key) == 'string' and key:len() == 64 or key:len() == 65 then
			-- if key is a valid looking base64 alphabet, try to make an encoder/decoder pair from it
			encoders[key], decoders[key] = makeencoder(key)
			return tbl[key]
		end
	end
}

setmetatable(encoders, alphabet_mt)
setmetatable(decoders, alphabet_mt)

local function encode(str, encoder)
	encoder = encoders[encoder or 'base64'] or error('invalid alphabet specified', 2)

	str = tostring(str)

	local t, k, n = {}, 1, #str
	local lastn = n % 3
	local cache = {}

	for i = 1, n-lastn, 3 do
		local a, b, c = byte(str, i, i+2)
		local v = a*0x10000 + b*0x100 + c
		local s = cache[v]

		if not s then
			s = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
			cache[v] = s
		end

		t[k] = s
		k = k + 1
	end

	if lastn == 2 then
		local a, b = byte(str, n-1, n)
		local v = a*0x10000 + b*0x100
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
	elseif lastn == 1 then
		local v = byte(str, n)*0x10000
		t[k] = char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
	end

	return concat(t)
end

local function decode(b64, decoder)
	decoder = decoders[decoder or 'base64'] or error('invalid alphabet specified', 2)

	local pattern = '[^%w%+%/%=]'
	if decoder then
		local s62, s63
		for charcode, b64code in pairs(decoder) do
			if b64code == 62 then s62 = charcode
			elseif b64code == 63 then s63 = charcode
			end
		end
		pattern = format('[^%%w%%%s%%%s%%=]', char(s62), char(s63))
	end

	b64 = gsub(tostring(b64), pattern, '')

	local cache = {}
	local t, k = {}, 1
	local n = #b64
	local padding = sub(b64, -2) == '==' and 2 or sub(b64, -1) == '=' and 1 or 0

	for i = 1, padding > 0 and n-4 or n, 4 do
		local a, b, c, d = byte(b64, i, i+3)

		local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
		local s = cache[v0]
		if not s then
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
			s = char(extract(v,16,8), extract(v,8,8), extract(v,0,8))
			cache[v0] = s
		end

		t[k] = s
		k = k + 1
	end

	if padding == 1 then
		local a, b, c = byte(b64, n-3, n-1)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
		t[k] = char(extract(v,16,8), extract(v,8,8))
	elseif padding == 2 then
		local a, b = byte(b64, n-3, n-2)
		local v = decoder[a]*0x40000 + decoder[b]*0x1000
		t[k] = char(extract(v,16,8))
	end
	return concat(t)
end

    http.get("https://google.com", function(success, response)
    if not success or response.status ~= 200 then
      return
    end
    if response.body then


--[LOCALS]



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



--[REFERENCES]

local ref = {
	enabled = ui.reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = ui.reference('AA', 'Anti-aimbot angles', 'pitch'),
	yawbase = ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw = ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    fakeduck = ui.reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint = ui.reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui.reference('RAGE', 'Aimbot', 'Force body aim'),
	load_cfg = ui.reference('Config', 'Presets', 'Load'),
    dmg = ui.reference('RAGE', 'Aimbot', 'Minimum damage'),

    --[1] = combobox/checkbox | [2] = slider/hotkey
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


--[REFERENCES]




local function rgbToHex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local colours = {

	lightblue = '\a'..rgbToHex(255, 255, 255)..'ff',
	darkerblue = '\aFFFFFFFF',
	grey = '\aFFFFFFFF',
	red = '\aFFFFFFFF',
	default = '\aFFFFFFFF',
	green = '\aFFFFFFFF',

}
local build = "source"

local aura = {
	luaenable = ui.new_checkbox('AA', 'Anti-aimbot angles', colours.default .. '\a6B5F6CE6A'),
	tabselect = ui.new_combobox('AA','Anti-aimbot angles', 'Â» Tabs', '-', 'Anti-Aim', 'Anti-Bruteforce', 'Other'),
    
	main = {
		main_space = ui.new_label('AA', 'Anti-aimbot angles', '        '),
		main_label1 = ui.new_label('AA', 'Anti-aimbot angles', colours.lightblue .. 'Welcome back,'),
		main_label4 = ui.new_label('AA', 'Anti-aimbot angles', colours.default .. 'Last update 15/10/2023'),

		main_space1 = ui.new_label('AA', 'Anti-aimbot angles', 'Build ~ Nightly'),
        main_space4 = ui.new_label('AA', 'Anti-aimbot angles', '        '),
		main_settings = ui.new_multiselect('AA','Anti-aimbot angles', 'Anti-Aim Addons', 'Force Defensive', 'Anti~Backstab', 'Edge-yaw', 'Freestand', 'Manual AA'),
	},

	antiaim = {
        c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', 'Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        c_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', 'Yaw Base', {'Local view','At targets'}),
		aa_condition = ui.new_combobox('AA','Anti-aimbot angles', 'Current Condition', aa_config),
        ab_enable = ui.new_checkbox('AA','Anti-aimbot angles', 'Enable Anti-Bruteforce'),
        stg1_label = ui.new_label('AA', 'Anti-aimbot angles', 'Stage 1'),
        stg1_body = ui.new_slider('AA', 'Anti-aimbot angles', 'Body Yaw', -180, 180, 0, true),
        stg1_jit = ui.new_slider('AA', 'Anti-aimbot angles', 'Jitter', -180, 180, 0, true),
        stg2_label = ui.new_label('AA', 'Anti-aimbot angles', 'Stage 2'),
        stg2_body = ui.new_slider('AA', 'Anti-aimbot angles', 'Body Yaw', -180, 180, 0, true),
        stg2_jit = ui.new_slider('AA', 'Anti-aimbot angles', 'Jitter', -180, 180, 0, true),
        stg3_label = ui.new_label('AA', 'Anti-aimbot angles', 'Stage 3'),
        stg3_body = ui.new_slider('AA', 'Anti-aimbot angles', 'Body Yaw', -180, 180, 0, true),
        stg3_jit = ui.new_slider('AA', 'Anti-aimbot angles', 'Jitter', -180, 180, 0, true),
	},

	visual = {


		indicator_enable = ui.new_checkbox('AA','Anti-aimbot angles', 'Crosshair Indicator'),
		indicator_select = ui.new_multiselect('AA','Anti-aimbot angles', 'Display', 'Crosshair Indicators', 'Kibit DMG'),
		indicator_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator colours', 181, 209, 255, 255),
        indicator_col2 = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator colours', 255, 255, 255, 255),

		enablenotifications = ui.new_checkbox('AA','Anti-aimbot angles', 'Logs'),
		notification_system = ui.new_multiselect('AA','Anti-aimbot angles', 'Display', 'Under crosshair', 'Console Logs'),
		notification_style =  ui.new_combobox('AA', 'Anti-aimbot angles', 'Notification Style', {'Dark mode'}),
		notification_col = ui.new_color_picker('AA','Anti-aimbot angles', 'Indicator colours', 181, 209, 255, 255),
		hitcol_label = ui.new_label('AA', 'Anti-aimbot angles', 'Hit colour'),
		hitcol = ui.new_color_picker('AA','Anti-aimbot angles', 'Hit colour', 154, 176, 255, 255),
		misscol_label = ui.new_label('AA', 'Anti-aimbot angles', 'Miss colour'),
		misscol = ui.new_color_picker('AA','Anti-aimbot angles', 'Miss colour', 251, 101, 128, 255),
	},

	keybinds = {
		key_defensive = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Force Defensive'),
		key_edge_yaw = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Edge-yaw'),
		key_freestand = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Freestanding'),
		key_forward = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Forward'),
		key_back = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Back'),
		key_left = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Left'),
		key_right = ui.new_hotkey('AA', 'Anti-aimbot angles', 'Manual Right'),
	},

    misc = {
		enable_clan_tag = ui.new_checkbox('AA', 'Anti-aimbot angles', 'Clantag'),
	},
}

local m_elements = ui.new_multiselect("AA", "Anti-aimbot angles", "Animation Breaker", {"Body Lean", "Slide Walking", "Pitch 0 On Land", "Static Legs In Air", "Jitter Legs On Ground"})
local slide_elements = ui.new_multiselect("AA", "Anti-aimbot angles", "Slide While", {"While walking", "While running", "While crouching"})
local body_lean_value = ui.new_slider("AA", "Anti-aimbot angles", "Body Lean Amount", 0, 100, 0, true, "%", 0.01)
local break_air_value = ui.new_slider("AA", "Anti-aimbot angles", "Static Legs In Air Amount", 0, 10, 5, true, "%", 0.1)
local break_land_value = ui.new_slider("AA", "Anti-aimbot angles", "Jitter Legs Amount", 0, 10, 5, true, "%", 0.1)


--[ANTI-AIM]


local function set_menu_color()
    local r, g, b = ui.get(aura.colorpicker)
    colours.lightblue = '\a'..rgbToHex(r, g, b)..'ff'
end

for i=1, #aa_config do
    
    local cond = colours.lightblue .. 'Condition ' .. colours.darkerblue .. string.lower(aa_config[i]) .. colours.lightblue .. ' ' .. colours.default

    rage[i] = {
        c_enabled = ui.new_checkbox('aa', 'anti-aimbot angles', 'Enable ' .. aa_config[i] .. ' config'),
        c_yaw = ui.new_combobox('aa', 'anti-aimbot angles', 'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),

		l_limit = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw Add Left', -180, 180, 0, true, 'Â°'),
        r_limit = ui.new_slider('AA', 'Anti-aimbot angles', 'Yaw Add Right', -180, 180, 0, true, 'Â°'),

        c_jitter = ui.new_combobox('aa', 'anti-aimbot angles', 'Jitter Type', {'Off','Offset','Center','Random'}),
        c_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', 'Jitter Amount', -180, 180, 0, true, 'Â°', 1),
        c_body = ui.new_combobox('aa', 'anti-aimbot angles', 'Body Yaw', {'Off','Opposite','Jitter','Static'}),
        c_body_sli = ui.new_slider('aa', 'anti-aimbot angles', 'Body Yaw Amount', -180, 180, 0, true, 'Â°', 1),

		c_free_b_yaw = ui.new_checkbox('aa', 'anti-aimbot angles', 'FS Body Yaw'),
        c_pitch_exp = ui.new_checkbox('aa', 'anti-aimbot angles', 'Pitch Exploit'),
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



--[MENU ELEMENTS]


local function hide_original_menu(state)
    --OG MENU
    ui.set_visible(ref.enabled, state)
    ui.set_visible(ref.pitch, state)
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
    local lua_enabled = ui.get(aura.luaenable)

    ui.set_visible(aura.tabselect, lua_enabled)

    --returns true or false
    local select_main = ui.get(aura.tabselect) == '-' and lua_enabled
    local select_aa = ui.get(aura.tabselect) == 'Anti-Aim' and lua_enabled
    local select_ab = ui.get(aura.tabselect) == 'Anti-Bruteforce' and lua_enabled
    local select_ab2 = ui.get(aura.tabselect) == 'Anti-Bruteforce' and lua_enabled and ui.get(aura.antiaim.ab_enable)
    local select_visuals = ui.get(aura.tabselect) == 'Other' and lua_enabled
    local select_misc = ui.get(aura.tabselect) == 'Other' and lua_enabled

	--------------
	-- MAIN
	--------------
    ui.set_visible(aura.main.main_label1, select_main)
	ui.set_visible(aura.main.main_label4, select_main)
	ui.set_visible(aura.main.main_space, select_main)
	ui.set_visible(aura.main.main_space1, select_main)

    ui.set_visible(aura.main.main_settings, select_main)
	ui.set_visible(aura.keybinds.key_defensive, contains(ui.get(aura.main.main_settings), 'Force Defensive') and select_main)
    ui.set_visible(aura.keybinds.key_edge_yaw, contains(ui.get(aura.main.main_settings), 'Edge-yaw') and select_main)
    ui.set_visible(aura.keybinds.key_freestand, contains(ui.get(aura.main.main_settings), 'Freestand') and select_main)
    local manual_aa = contains(ui.get(aura.main.main_settings), 'Manual AA')
    ui.set_visible(aura.keybinds.key_forward, manual_aa and select_main)
	ui.set_visible(aura.keybinds.key_back, manual_aa and select_main)
    ui.set_visible(aura.keybinds.key_left, manual_aa and select_main)
    ui.set_visible(aura.keybinds.key_right, manual_aa and select_main)
    
	--------------
	-- ANTI-AIM
	--------------
    ui.set_visible(aura.antiaim.aa_condition, select_aa)
    ui.set_visible(aura.antiaim.c_pitch, select_aa)
    ui.set_visible(aura.antiaim.c_yawbase, select_aa)

    ui.set_visible(aura.antiaim.ab_enable, select_ab)
    ui.set_visible(aura.antiaim.stg1_label, select_ab2)
    ui.set_visible(aura.antiaim.stg1_body, select_ab2)
    ui.set_visible(aura.antiaim.stg1_jit, select_ab2)

    ui.set_visible(aura.antiaim.stg2_label, select_ab2)
    ui.set_visible(aura.antiaim.stg2_body, select_ab2)
    ui.set_visible(aura.antiaim.stg2_jit, select_ab2)

    ui.set_visible(aura.antiaim.stg3_label, select_ab2)
    ui.set_visible(aura.antiaim.stg3_body, select_ab2)
    ui.set_visible(aura.antiaim.stg3_jit, select_ab2)

	--------------
	-- VISUAL
	--------------


	ui.set_visible(aura.visual.indicator_enable, select_visuals)
    ui.set_visible(aura.visual.indicator_select, select_visuals and ui.get(aura.visual.indicator_enable))
    ui.set_visible(aura.visual.indicator_col, select_visuals and ui.get(aura.visual.indicator_enable) and contains(ui.get(aura.visual.indicator_select), 'Crosshair Indicators'))
    ui.set_visible(aura.visual.indicator_col2, select_visuals and ui.get(aura.visual.indicator_enable) and contains(ui.get(aura.visual.indicator_select), 'Crosshair Indicators'))

	ui.set_visible(aura.visual.enablenotifications, select_visuals)
	ui.set_visible(aura.visual.notification_system, select_visuals and ui.get(aura.visual.enablenotifications))
	ui.set_visible(aura.visual.notification_col, select_visuals and ui.get(aura.visual.enablenotifications))
	ui.set_visible(aura.visual.notification_style, select_visuals and ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), 'Under crosshair'))
	ui.set_visible(aura.visual.hitcol_label, select_visuals and ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), 'Under crosshair') and ui.get(aura.visual.notification_style) == 'Dark mode')
	ui.set_visible(aura.visual.misscol_label, select_visuals and ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), 'Under crosshair') and ui.get(aura.visual.notification_style) == 'Dark mode')
	ui.set_visible(aura.visual.hitcol, select_visuals and ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), 'Under crosshair') and ui.get(aura.visual.notification_style) == 'Dark mode')
	ui.set_visible(aura.visual.misscol, select_visuals and ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), 'Under crosshair') and ui.get(aura.visual.notification_style) == 'Dark mode')

	ui.set_visible(aura.visual.notification_style, false)
	ui.set_visible(aura.visual.misscol, false)
	ui.set_visible(aura.visual.misscol_label, false)
	ui.set_visible(aura.visual.hitcol_label, false)

    ui.set_visible(aura.misc.enable_clan_tag, select_misc)
    ui.set_visible(m_elements, select_misc)
    ui.set_visible(body_lean_value, table.contains(m_elements, "Body Lean") and select_misc)
    ui.set_visible(slide_elements, table.contains(m_elements, "Slide Walking") and select_misc)
    ui.set_visible(break_air_value, table.contains(m_elements, "Static Legs In Air") and select_misc)
    ui.set_visible(break_land_value, table.contains(m_elements, "Jitter Legs On Ground") and select_misc)
end

--[MENU ELEMENTS]


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

    
    on_ground = bit.band(entity.get_prop(lp, 'm_fFlags'), 1) == 1
    
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
    local enabled = ui.get(aura.luaenable) and ui.get(aura.tabselect) == 'Anti-Aim'
    ui.set_visible(aura.antiaim.aa_condition, enabled)
    ui.set(rage[1].c_enabled, true)
    for i=1, #aa_config do
        local show = ui.get(aura.antiaim.aa_condition) == aa_config[i] and enabled
        local cond_tp = ui.get(rage[i].c_enabled)
        ui.set_visible(rage[i].c_enabled, show and i > 1)
        ui.set_visible(rage[i].c_yaw,show and cond_tp)
        
        ui.set_visible(rage[i].c_jitter, show and cond_tp)
        ui.set_visible(rage[i].c_jitter_sli, show and ui.get(rage[i].c_jitter) ~= 'Off' and cond_tp)
        ui.set_visible(rage[i].c_body,show and cond_tp)
        ui.set_visible(rage[i].c_body_sli,show and (ui.get(rage[i].c_body) ~= 'Off' and ui.get(rage[i].c_body) ~= 'Opposite') and cond_tp)
        ui.set_visible(rage[i].c_free_b_yaw, show and cond_tp)
        ui.set_visible(rage[i].c_pitch_exp, show and cond_tp)

        ui.set_visible(rage[i].l_limit, show and cond_tp)
        ui.set_visible(rage[i].r_limit, show and cond_tp)
    end
end
handle_menu()

local function handle_keybinds()
    local freestand = ui.get(aura.keybinds.key_freestand)
    ui.set(ref.freestand[1], freestand)
    ui.set(ref.freestand[2], freestand and 0 or 2)
end



--[ANTI-AIM]



--[MISC]




--[MISC]



--[CLANTAG CHANGER]

    
local skeetclantag = ui.reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')

local duration = 15
local clantags = {

' ',
's',
'st',
'sta',
'star',
'stars',
'starse',
'starsen',
'aura ',
'',
}

local empty = {''}
local clantag_prev
client.set_event_callback('net_update_end', function()
    if ui.get(skeetclantag) then 
        return 
    end

    local cur = math.floor(globals.tickcount() / duration) % #clantags
    local clantag = clantags[cur+1]

	if not ui.get(aura.misc.enable_clan_tag) then
		client.set_clan_tag("")
	end

    if ui.get(aura.misc.enable_clan_tag) then
        if clantag ~= clantag_prev then
            clantag_prev = clantag
            client.set_clan_tag(clantag)
        end
    end
end)
ui.set_callback(aura.misc.enable_clan_tag, function() client.set_clan_tag('\0') end)

--[CLANTAG CHANGER]



--[MANUAL AA]

local last_press_t_dir = 0
local yaw_direction = 0

local run_direction = function()
	ui.set(aura.keybinds.key_forward, 'On hotkey')
	ui.set(aura.keybinds.key_left, 'On hotkey')
	ui.set(aura.keybinds.key_back, 'On hotkey')
	ui.set(aura.keybinds.key_right, 'On hotkey')
    ui.set(ref.edgeyaw, ui.get(aura.keybinds.key_edge_yaw) and contains(ui.get(aura.main.main_settings), 'Edge-yaw'))

    ui.set(ref.freestand[1], ui.get(aura.keybinds.key_freestand))
    ui.set(ref.freestand[2], ui.get(aura.keybinds.key_freestand) and 'Always on' or 'On hotkey')

	if (ui.get(aura.keybinds.key_freestand) and contains(ui.get(aura.main.main_settings), 'Freestand')) or not contains(ui.get(aura.main.main_settings), 'Manual AA') then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if ui.get(aura.keybinds.key_forward) and last_press_t_dir + 0.2 < globals.curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
			last_press_t_dir = globals.curtime()
		elseif ui.get(aura.keybinds.key_right) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals.curtime()
		elseif ui.get(aura.keybinds.key_left) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals.curtime()
		elseif ui.get(aura.keybinds.key_back) and last_press_t_dir + 0.2 < globals.curtime() then
			yaw_direction = yaw_direction == 0 and 0 or 0
			last_press_t_dir = globals.curtime()
		elseif last_press_t_dir > globals.curtime() then
			last_press_t_dir = globals.curtime()
		end
	end
end

--[MANUAL AA]



-- indicators
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

local screen = {client.screen_size()}
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
local function text_fade_animation(x, y, speed, color1, color2, text)
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
    
    renderer.text(x, y, color1.r, color1.g, color1.b, color1.a, "c-d", nil, final_text)
end
  

--[Indicators]

local xpos = 0
local references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}
local function onscreen_elements()

    screen = {client.screen_size()}
	center = {screen[1]/2, screen[2]/2} 


    if contains(ui.get(aura.visual.indicator_select), 'Kibit DMG') then
        local localplayer = entity.get_local_player()
        if localplayer == nil or not entity.is_alive(localplayer) then return end

        if ui.get(references.minimum_damage_override[2]) then
            renderer.text(screen[1] / 2 + 2, screen[2] / 2 - 14, 255, 255, 255, 225, "d", 0, ui.get(references.minimum_damage_override[3]) .. "")
        end
    end

	
	--DEFAULT LOCALS
	
	local spacing = 0 
    local indi_state = string.upper(xxx)
    local acti_indi_state = ui.get(rage[state_to_num[xxx]].c_enabled) and indi_state or ''
    local lp = entity.get_local_player()
    local r, g, b, a = ui.get(aura.visual.indicator_col)
    local r1, g1, b1, a1 = ui.get(aura.visual.indicator_col2)
	local indicatormaster = ui.get(aura.luaenable) and ui.get(aura.visual.indicator_enable)

	local scpd = entity.get_prop(lp, "m_bIsScoped")
    text_fade_animation(x + 2, y * 2 - 12, 1, {r=r, g=g, b=b, a=255}, {r=r1, g=g1, b=b1, a=255}, "A U R A ")


    xpos = animation(scpd == 1, xpos, 20, 10)
	center[1] = center[1] + xpos

	local isFreestanding = ui.get(ref.freestand[2])
	local local_player = entity.get_local_player()
	local active_weapon = entity.get_prop(local_player, "m_hActiveWeapon")	
	if active_weapon == nil then
		return
	end

	local centerfunc1 = renderer.measure_text('-', "mobil")
	local centerpixel1 = centerfunc1 / 2


	
    if indicatormaster and entity.is_alive(lp) then   
        if contains(ui.get(aura.visual.indicator_select), 'Crosshair Indicators') then
               text_fade_animation(center[1] + 21, center[2] + 25, 0.5, {r=r, g=g, b=b, a=255}, {r=r1, g=g1, b=b1, a=255}, "AURA")
				--renderer.text(center[1] + 21, center[2] + 25, r, g, b, a,  'cb-', 0, 'aura')
				renderer.text(center[1] + 21, center[2] + 37 + (spacing * 8), 150, 150, 150, 255,  "c-d", 0,  '' .. acti_indi_state .. '')
				spacing = spacing + 1

				if ui.get(ref.dt[1]) and ui.get(ref.dt[2]) then

					if doubletap_charged() then
						renderer.text(center[1] + 20, center[2] + 25 + (spacing * 8), r, g, b, a, "c-d", 0, "DT")

					else
						renderer.text(center[1] + 20, center[2] + 25 + (spacing * 8), 145, 145, 145, 255, "c-d", 0, "DT")

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

				

					spacing = spacing + 1
				end

				if ui.get(ref.os[2]) then
					renderer.text(center[1] + 20, center[2] + 25 + (spacing * 8), r, g, b, 255, "c-d", 0, "HS")
					spacing = spacing + 1

				end

				if ui.get(ref.forcebaim)then
					renderer.text(center[1] + 22, center[2] + 25 + (spacing * 8), 255, 102, 117, 255, "c-d", 0, "BAIM")
					spacing = spacing + 1

				end
        end
    end
end

local screen = {client.screen_size()}
local center = {screen[1]/2, screen[2]/2} 


--[NOTIFICATIONS]


local get_hit_color = function()
	local r, g, b, a = ui.get(aura.visual.hitcol)
	return r, g, b, a
end

local get_miss_color = function()
	local r, g, b, a = ui.get(aura.visual.misscol)
	return r, g, b, a
end

local r, g, b, a = get_hit_color()
local noticol = '\a'..rgbToHex(r, g, b)..'ff'

table.insert(logs_txt, {

	text = 'Welcome back, hencio',
	textdark = colours.grey ..'Welcome back, hencio',

	timer = globals.realtime(),
	smooth_y = screen[2] + 155,
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

	if ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), "Under crosshair") then
		table.insert(logs_txt, {		
			text = string.format(colours.grey .. 'Hit ' .. colours.grey .. '%s\'s' .. noticol .. ' %s' .. colours.grey .. ' for ' .. noticol .. '%i' , name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke),
			textdark = string.format(colours.grey .. 'Hit ' .. colours.grey .. '%s\'s' .. noticol .. ' %s' .. colours.grey .. ' for ' .. noticol .. '%i' , name, hgroup, e.damage, on_fire_data.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke),
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

	if ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), "Console Logs") then
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


	if ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), "Under crosshair") then
		table.insert(logs_txt, {

			textdark = string.format(colours.grey .. ' Missed' .. colours.grey .. ' %s\'s' .. noticol .. ' %s'.. colours.grey .. colours.grey .. ')(' .. noticol .. '%s' .. colours.grey .. ') due to' .. noticol .. ' %s', name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy),
        	textdark = string.format(colours.grey .. ' Missed' .. colours.grey .. ' %s\'s' .. noticol .. ' %s'.. colours.grey .. colours.grey .. ')(' .. noticol .. '%s' .. colours.grey .. ') due to' .. noticol .. ' %s', name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy),

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

	if ui.get(aura.visual.enablenotifications) and contains(ui.get(aura.visual.notification_system), "Console Logs") then
		print(string.format('[%d] Missed %s\'s %s(%i)(%s) due to %s:%.2fÂ°', e.id, name, hgroup, on_fire_data.damage, hitchance, e.reason, inaccuracy))

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
				local r, g, b, a = ui.get(aura.visual.notification_col)

				if ui.get(aura.visual.notification_style) == 'Top bar' then
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

			

				elseif ui.get(aura.visual.notification_style) == 'Dark mode' then

					-- backround
					renderer.rectangle(
						center[1] - text_size_x / 2 - 13, 
						add_y - 26, 
						text_size_x + 26, 
						20, 
						25, 25, 25, 100
					)


							--center outline
					renderer.rectangle(						
						center[1] - text_size_x / 2 - 16, 
						add_y - 29, 
						text_size_x + 32, 
						26, 
						25, 25, 25, 50
					)

					renderer.gradient(
						center[1] - text_size_x / 2 - 13, 
						add_y - 25.5, 
						2, 
						22, 
						r, g, b, a,
						r, g, b, 0, 
						false
					)

					renderer.gradient(
						center[1] + text_size_x / 2 + 11 ,
						add_y - 26, 
						2, 
						23, 
						r, g, b, a, 
						r, g, b, 0,  
						false
					)

					renderer.text(center[1] - text_size_x / 2, add_y - 23, 250, 250, 250, alpha, '', 0, info.textdark)

				end

				y = y - 45
				if info.timer + 4 < globals.realtime() then table.remove(logs_txt, i) end
			end
		end
	end
end


--[NOTIFICATIONS]




--[CALLBACKS]

client.set_event_callback('aim_hit', aim_hit)

client.set_event_callback('aim_miss', aim_miss)

client.set_event_callback('net_update_end', g_net_update)

client.set_event_callback('aim_fire', g_aim_fire)

client.set_event_callback('bullet_impact', g_bullet_impact)




client.set_event_callback('paint_ui', function()
    --set_menu_color()
    set_lua_menu()
    hide_original_menu(not ui.get(aura.luaenable))
	notifications()

end)

distance_knife = {}
distance_knife.anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

client.set_event_callback('pre_config_save', function()
----database.write('aura_color', colours.lightblue)
end)
curtime = 0
client.set_event_callback('setup_command', function(e)

    local localplayer = entity.get_local_player()

    if localplayer == nil or not entity.is_alive(localplayer) or not ui.get(aura.luaenable) then
        return
    end





    local state = get_mode(e)

    ui.set(ref.enabled, true)
    state = ui.get(rage[state_to_num[state]].c_enabled) and state_to_num[state] or state_to_num['Global']


    handle_keybinds()
    run_direction()

    if ui.get(rage[state].c_pitch_exp) then
        if ui.get(ref.os[2]) then return end
        if globals.curtime () > curtime + 0.07 then
            ui.set(ref.pitch,"Up")
            ui.set(ref.yaw[2],120)
            curtime = globals.curtime()
        else
            ui.set(ref.pitch,"Down")
        end
    else
        ui.set(ref.pitch, ui.get(aura.antiaim.c_pitch))
    end
    ui.set(ref.yawbase, ui.get(aura.antiaim.c_yawbase))
    ui.set(ref.yaw[1], ui.get(rage[state].c_yaw))
    
    ui.set(ref.yawjitter[1], ui.get(rage[state].c_jitter))
	ui.set(ref.roll[1], 0)
    ui.set(ref.bodyyaw[1], ui.get(rage[state].c_body))
    ui.set(ref.bodyyaw[2], ui.get(rage[state].c_body_sli))
    ui.set(ref.fsbodyyaw, ui.get(rage[state].c_free_b_yaw))



	local force_def = ui.get(aura.keybinds.key_defensive) and contains(ui.get(aura.main.main_settings), 'Force Defensive')
	
	if force_def then
		force_defensive = 1;
		no_choke = 1;
		quick_stop = 1;
	else
		force_defensive = 0;
		no_choke = 0;
		quick_stop = 0;
	end

	local desync_type = entity.get_prop(localplayer, 'm_flPoseParameter', 11) * 120 - 60
	local desync_side = desync_type > 0 and 1 or -1

    if desync_side == 1 then
            --left
        ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].l_limit)) or yaw_direction)
    elseif desync_side == -1 then
            --right
        ui.set(ref.yaw[2], yaw_direction == 0 and (ui.get(rage[state].r_limit)) or yaw_direction)
    end
	ui.set(ref.yawjitter[2], ui.get(rage[state].c_jitter_sli))

    if contains(ui.get(aura.main.main_settings), 'Anti~Backstab') then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        if players == nil then return end
        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = distance_knife.anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 300 then
                ui.set(ref.yaw[2], 180)
                ui.set(ref.pitch, "Off")
                ui.set(ref.yawbase, "At targets")
            end
        end
    end
end)

-- [[ Anti brute force ]] --
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
    if ui.get(aura.antiaim.ab_enable) == false then return end
    
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
        stage = stage >= 3 and 0 or stage + 1
        stage = stage == 0 and 1 or stage
        table.insert(logs_txt, {
            text = noticol ..'S'.. colours.grey ..' Changed jitter due to [jitter] bullet '..tostring(stage),
            textdark = noticol ..'S'.. colours.grey ..' Changed jitter due to [jitter] bullet '..tostring(stage),
        
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
end)

local function Returner()
    brut3 = true

    return brut3
end

client.set_event_callback("setup_command", function(cmd)
    if bruteforce and ui.get(aura.antiaim.ab_enable) then
        client.set_event_callback("paint_ui", Returner)
        bruteforce = false
        bruteforce_reset = false
        stage = stage == 0 and 1 or stage
        set_brute = true
    else
        if shot_time + 3 < globals.realtime() or not ui.get(aura.antiaim.ab_enable) then
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
    if set_brute == false then return end
    if stage == 1 then
        ui.set(ref.yawjitter[2], ui.get(aura.antiaim.stg1_jit))
        ui.set(ref.bodyyaw[2], ui.get(aura.antiaim.stg1_body))
    elseif stage == 2 then
        ui.set(ref.yawjitter[2], ui.get(aura.antiaim.stg2_jit))
        ui.set(ref.bodyyaw[2], ui.get(aura.antiaim.stg2_body))
    elseif stage == 3 then
        ui.set(ref.yawjitter[2], ui.get(aura.antiaim.stg3_jit))
        ui.set(ref.bodyyaw[2], ui.get(aura.antiaim.stg3_body))
    end
end)

client.set_event_callback('shutdown', function()
    hide_original_menu(true)
end)

client.set_event_callback('paint', function()
    onscreen_elements()
end)

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
        table.insert(logs_txt, {

            text = colours.grey ..'Config Succesfully Imported',
            textdark = colours.grey ..'Config Succesfully Imported',
        
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
        table.insert(logs_txt, {
            text = colours.grey ..'Config Succesfully Exported',
            textdark = colours.grey ..'Config Succesfully Exported',
        
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
    end)
end


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

local export = ui.new_button("AA","Other",'\aFFFFFFC8Export Config', export_cfg)
local load = ui.new_button("AA","Other",'\aFFFFFFC8Import Config', import_cfg)

local function init_callbacks()
    ui.set_callback(aura.luaenable, handle_menu)
    ui.set_callback(aura.antiaim.aa_condition, handle_menu)
    ui.set_callback(aura.tabselect, handle_menu)
    ui.set_callback(ref.load_cfg, handle_menu)

    for i=1, #aa_config do
        ui.set_callback(rage[i].c_yaw, handle_menu)
        ui.set_callback(rage[i].c_jitter, handle_menu)
        ui.set_callback(rage[i].c_body, handle_menu)
        ui.set_callback(rage[i].c_enabled, handle_menu)
    end
end
init_callbacks()

table.contains = function(source, target)
    local source_element = ui.get(source)
    for id, name in pairs(source_element) do
        if name == target then
            return true
        end
    end

    return false
end

local c_entity = require("gamesense/entity")
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

local is_on_ground = false
local slidewalk_directory = ui.reference("AA", "other", "leg movement")



client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0

    if table.contains(m_elements, "Jitter Legs On Ground") then
        ui.set(slidewalk_directory, cmd.command_number % 3 == 0 and "Off" or "Always slide")
    end
end)

client.set_event_callback("pre_render", function()
	if not ui.get(aura.luaenable) then return end
    local self = entity.get_local_player()
    if not self or not entity.is_alive(self) then
        return
    end

    local self_index = c_entity.new(self)
    local self_anim_state = self_index:get_anim_state()

    if not self_anim_state then
        return
    end

    if table.contains(m_elements, "Slide Walking") then
        if table.contains(slide_elements, "While walking") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_WALK)
        end

        if table.contains(slide_elements, "While running") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_RUN)
        end

        if table.contains(slide_elements, "While crouching") then
            entity.set_prop(self, "m_flPoseParameter", 0, E_POSE_PARAMETERS.MOVE_BLEND_CROUCH)
        end
    end

    if table.contains(m_elements, "Static Legs In Air") then
        entity.set_prop(self, "m_flPoseParameter", ui.get(break_air_value) / 10, E_POSE_PARAMETERS.JUMP_FALL)
    end

    if table.contains(m_elements, "Jitter Legs On Ground") then
        entity.set_prop(self, "m_flPoseParameter", E_POSE_PARAMETERS.STAND, globals.tickcount() % 4 > 1 and ui.get(break_land_value) / 10 or 1)
    end
    
    if table.contains(m_elements, "Body Lean") then
        local self_anim_overlay = self_index:get_anim_overlay(12)
        if not self_anim_overlay then
            return
        end

        local x_velocity = entity.get_prop(self, "m_vecVelocity[0]")
        if math.abs(x_velocity) >= 3 then
            self_anim_overlay.weight = ui.get(body_lean_value) / 100
        end
    end

    if table.contains(m_elements, "Pitch 0 On Land") then
        if not self_anim_state.hit_in_ground_animation or not is_on_ground then
            return
        end

        entity.set_prop(self, "m_flPoseParameter", 0.5, E_POSE_PARAMETERS.BODY_PITCH)
    end 
end)

else
    print("yo")
end

end)