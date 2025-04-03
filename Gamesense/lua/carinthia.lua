---------------------------------------------
--[CACHED FUNCTIONS]
---------------------------------------------
local menu_get, menu_set, menu_checkbox, menu_slider, menu_combobox, menu_multiselect, menu_hotkey, menu_button, menu_colorpicker, menu_textbox, menu_listbox, menu_string, menu_label, menu_reference, menu_set_callback, menu_setvisible, client_set_event_callback, render_measure_text, client_trace_line, client_eye_position, client_trace_bullet = ui.get, ui.set, ui.new_checkbox, ui.new_slider, ui.new_combobox, ui.new_multiselect, ui.new_hotkey, ui.new_button, ui.new_color_picker, ui.new_textbox, ui.new_listbox, ui.new_string, ui.new_label, ui.reference, ui.set_callback, ui.set_visible, client.set_event_callback, renderer.measure_text, client.trace_line, client.eye_position, client.trace_bullet
local entity_get_prop, entity_get_local_player, entity_is_alive, entity_get_player_weapon, entity_get_classname, entity_get_origin, globals_frametime, client_screen_size, globals_framecount, is_menu_open, menu_mouse_position, client_key_state, table_insert, entity_get_steam64, render_circle_outline, entity_get_all, globals_tickinterval, client_set_clantag = entity.get_prop, entity.get_local_player, entity.is_alive, entity.get_player_weapon, entity.get_classname, entity.get_origin, globals.frametime, client.screen_size, globals.framecount, ui.is_menu_open, ui.mouse_position, client.key_state, table.insert, entity.get_steam64, renderer.circle_outline, entity.get_all, globals.tickinterval, client.set_clan_tag
local math_sqrt, bit_band, globals_curtime, math_floor, bit_lshift, globals_tickcount, entity_get_players, entity_get_player_name, entity_get_steam64, client_userid_to_entindex, entity_is_enemy, entity_is_dormant, entity_hitbox_position, math_max, math_abs, render_text, render_world_to_screen, client_exec, entity_get_bounding_box, client_create_interface, render_box, render_circle, render_gradient, globals_realtime = math.sqrt, bit.band, globals.curtime, math.floor, bit.lshift, globals.tickcount, entity.get_players, entity.get_player_name, entity.get_steam64, client.userid_to_entindex, entity.is_enemy, entity.is_dormant, entity.hitbox_position, math.max, math.abs, renderer.text, renderer.world_to_screen, client.exec, entity.get_bounding_box, client.create_interface, renderer.rectangle, renderer.circle, renderer.gradient, globals.realtime

local ease   = require 'gamesense/easing'
local http   = require 'gamesense/http'

---------------------------------------------
--[FFI & MISC STUFF]
---------------------------------------------
local ffi = require('ffi')
local vector = require('vector')

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

---------------------------------------------
--[LOCALS AND FUNCTIONS]
---------------------------------------------
---------------
local aa_config = { 'Global', 'Stand', 'Slow', 'Moving' , 'Air', 'Air duck', 'Duck T', 'Duck CT' }
local rage = {}
---------------
local obex_data = {username = 'scriptleaks', build = 'boosters'}

local state_to_num = { 
    ['Global'] = 1, 
    ['Stand'] = 2, 
    ['Slow'] = 3, 
    ['Moving'] = 4,
    ['Air'] = 5,
    ['Air duck'] = 6,
    ['Duck T'] = 7,
    ['Duck CT'] = 8, 
}

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


local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function animation(check, name, value, speed) 
	if check then 
		return round(name + (value - name) * globals.frametime() * speed, 2)
	else 
		return name > 0.9 and round(name - (value + name) * globals.frametime() * speed / 2, 2) or 0
	end
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

local function rgbtohex(r, g, b)
    r = tostring(r);g = tostring(g);b = tostring(b)
    r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b

    local rgb = (r * 0x10000) + (g * 0x100) + b
    return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
end

local function render_rectangle_rounded(x, y, w, h, r, g, b, a, radius)
    y = y + radius
    local datacircle = {
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

    for _, data in pairs(datacircle) do
        renderer.circle(data[1], data[2], r, g, b, a, radius, data[3], 0.25)
    end

    for _, data in pairs(data) do
       renderer.rectangle(data[1], data[2], data[3], data[4], r, g, b, a)
    end
end

---------------------------------------------
--[REFERENCES]
---------------------------------------------
local reference = {
	enabled      = menu_reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch        = menu_reference('AA', 'Anti-aimbot angles', 'pitch'),
	yawbase      = menu_reference('AA', 'Anti-aimbot angles', 'Yaw base'),
    fsbodyyaw    = menu_reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
    edgeyaw      = menu_reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    maxprocticks = menu_reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks2'),
    fakeduck     = menu_reference('RAGE', 'Other', 'Duck peek assist'),
    safepoint    = menu_reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim    = menu_reference('RAGE', 'Aimbot', 'Force body aim'),
	roll         = menu_reference('aa', 'Anti-aimbot angles', 'Roll'),
	player_list  = menu_reference('PLAYERS', 'Players', 'Player list'),
	reset_all    = menu_reference('PLAYERS', 'Players', 'Reset all'),
	apply_all    = menu_reference('PLAYERS', 'Adjustments', 'Apply to all'),
	load_cfg     = menu_reference('Config', 'Presets', 'Load'),
	fl_limit     = menu_reference('AA', 'Fake lag', 'Limit'),
    dt_limit     = menu_reference('RAGE', 'Aimbot', 'Double tap fake lag limit'),
    dmg          = menu_reference('RAGE', 'Aimbot', 'Minimum damage'),
    bhop         = menu_reference('MISC', 'Movement', 'Bunny hop'),
	processticks = menu_reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks2'),  

    --[1] = combobox/checkbox | [2] = slider/hotkey
    rage         = { menu_reference('RAGE', 'Aimbot', 'Enabled') },
    yaw          = { menu_reference('AA', 'Anti-aimbot angles', 'Yaw') }, 
	quickpeek    = { menu_reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter    = { menu_reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw      = { menu_reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand    = { menu_reference('AA', 'Anti-aimbot angles', 'Freestanding', 'Default') },
	os           = { menu_reference('AA', 'Other', 'On shot anti-aim') },
	slow         = { menu_reference('AA', 'Other', 'Slow motion') },
	dt           = { menu_reference('RAGE', 'Aimbot', 'Double tap') },
	fakelag      = { menu_reference('AA', 'Fake lag', 'Enabled') },
    pingspike    = { menu_reference('MISC', 'Miscellaneous', 'Ping spike') }
}

local colours = {

	menutheme   = '\a91a6ebFF',
    white       = '\affffffFF',
    special     = '\aa6e8a0FF',
	lightblue   = '\a96cfffFF',
    babyblue    = '\a91afffFF',
	grey        = '\aabababFF',
	default     = '\ac8c8c8FF',

    theme = {

        c  = '\a6E91FFFF',
        a  = '\a7188d1FF',
        r  = '\a7286c2FF',
        i  = '\a6a7badFF',
        n  = '\a6a7594FF',
        t  = '\a747b8cFF',
        h  = '\a797c85FF',
        i2 = '\a878787FF',
        a2 = '\a878787FF',
    },
}

---------------------------------------------
--[CREATE MENU ELEMENTS]
---------------------------------------------
local x = {
    tab = 'AA',
    section = 'Anti-aimbot angles'
}

colours.element = colours.grey .. '[' .. colours.babyblue .. '+' .. colours.grey .. '] ' 
lua_title       = '@carinthia - 2v2/5v5 Tournament'


local carinthia = {
	luaenable            = menu_checkbox(x.tab, x.section, colours.theme.c .. 'C '.. colours.theme.a ..'A '.. colours.theme.r ..'R '.. colours.theme.i ..'I '.. colours.theme.n ..'N '.. colours.theme.t ..'T '.. colours.theme.h ..'H '.. colours.theme.i2 ..'I '.. colours.theme.a2 ..'A '),
	tabselect            = menu_combobox(x.tab, x.section, 'Tab selector', 'Anti-Aim', 'Visuals', 'Misc', 'Config'),

	antiaim = {
        fl_slider        = menu_slider  ('AA', 'Fake Lag', 'Limit ', 1, 15, 14, true),
        builder_header   = menu_label   (x.tab, x.section, lua_title),
        builder_sub      = menu_label   (x.tab, x.section, '                 [' .. colours.menutheme .. 'antiaims' .. colours.default.. ']'),
        header_spacer    = menu_label   (x.tab, x.section, ' '),
        page_select      = menu_combobox(x.tab, x.section, 'Options', 'Dynamic', 'Custom Builder', 'Keybinds'),
        manual_master    = menu_checkbox(x.tab, x.section, 'Enable' .. colours.menutheme .. ' Manual ' .. colours.default .. 'Anti-Aim'),
        key_forward      = menu_hotkey  (x.tab, x.section, colours.element .. 'Manual Forward'),
        key_left         = menu_hotkey  (x.tab, x.section, colours.element .. 'Manual Left'),
        key_right        = menu_hotkey  (x.tab, x.section, colours.element .. 'Manual Right'), 
        other_master     = menu_checkbox(x.tab,x.section, 'Enable' .. colours.menutheme .. ' Other'),  
        key_legit        = menu_hotkey  (x.tab, x.section, colours.element .. 'Legit AA'),  
        key_freestand    = menu_hotkey  (x.tab, x.section, colours.element .. 'Freestanding'), 
        static_fs        = menu_checkbox(x.tab,x.section, colours.element .. 'Enable static freestand'),  
        aa_cond          = menu_combobox(x.tab, x.section, 'State Select', aa_config),
	},

    builder = {},

	visual = {
        indi_header      = menu_label      (x.tab, x.section, lua_title),
        indi_sub         = menu_label      (x.tab, x.section, '                  [' .. colours.menutheme .. 'visuals' .. colours.default.. ']'),
        indih_spacer     = menu_label      (x.tab, x.section, ' '),
        indicator_select = menu_multiselect(x.tab, x.section, 'Visual Select', {'Crosshair', 'Lua watermark', 'Animations'}),
        crosshair_select = menu_combobox   (x.tab, x.section, 'Crosshair indicators', {'-', 'Carinthia', 'Simple', 'Kydex'}),
        clr_col1_label   = menu_label      (x.tab, x.section, colours.element .. 'Colour 1'),
        clr_col1         = menu_colorpicker(x.tab, x.section, 'Colour 1', 255, 255, 255, 255), 
        clr_col2_label   = menu_label      (x.tab, x.section, colours.element .. 'Colour 2'), 
        clr_col2         = menu_colorpicker(x.tab, x.section, 'Colour 2', 255, 255, 255, 255),
        indi_opt         = menu_combobox   (x.tab, x.section, 'Options', {'Build', 'Anti-aim state'}),
        watermark_master = menu_checkbox   (x.tab, x.section, 'Lua watermark'),
        clr_wm_label     = menu_label      (x.tab, x.section, colours.element .. 'Watermark Theme'), 
        clr_wm           = menu_colorpicker(x.tab, x.section, 'Colour 2', 255, 255, 255, 255), 
        extra            = menu_multiselect(x.tab, x.section, 'Extra indicators', {'Force baim', 'Ping spike'}),
        animbreaker      = menu_multiselect(x.tab, x.section, colours.special .. 'Animation breakers', {'Moonwalk'}),
	},

    misc = {
        misc_header      = menu_label   (x.tab, x.section, lua_title),
        misc_sub         = menu_label   (x.tab, x.section, '                    [' .. colours.menutheme .. 'misc' .. colours.default.. ']'),
        misch_spacer     = menu_label   (x.tab, x.section, ' '),
        dtenable         = menu_checkbox(x.tab, x.section, 'enable' .. colours.menutheme .. ' doubletap ' .. colours.default .. 'modifier'),   
        dtspeed          = menu_combobox(x.tab, x.section, colours.element .. 'Modify tickbase', {'Default', 'Fast', 'Fastest'}), 
        fastswap         = menu_checkbox(x.tab, x.section, colours.element .. colours.special .. 'Fast weapon switch'), 
        defensive_air    = menu_checkbox(x.tab, x.section, colours.element .. colours.special .. 'Force defensive in air'),
	},

    config = {
        config_header    = menu_label(x.tab, x.section, lua_title),
        config_sub       = menu_label(x.tab, x.section, '                    [' .. colours.menutheme .. 'configs' .. colours.default.. ']'),
        config_space     = menu_label(x.tab, x.section, ' '),
    
    }
}
---------------------------------------------
--[CREATING BUILDER MENU ELEMENTS]
---------------------------------------------

for i=1, #aa_config do
    
    local cond = colours.menutheme .. string.lower(aa_config[i]) .. colours.lightblue .. ' ' .. colours.default

    carinthia.builder[i] = {
        build_enabled       = menu_checkbox(x.tab, x.section, 'Enable ' .. colours.babyblue .. aa_config[i] .. colours.default .. ' config'),   
        build_pitch         = menu_combobox(x.tab, x.section, colours.element .. 'Pitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),   
        build_yawbase       = menu_combobox(x.tab, x.section, colours.element .. 'Yaw base', {'Local view','At targets'}),   
        build_yaw           = menu_combobox(x.tab, x.section, colours.element .. 'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),   
		l_yaw_limit         = menu_slider(x.tab, x.section, colours.element .. 'yaw limit -' .. colours.menutheme .. ' L', -180, 180, 0, true, '°'),   
        r_yaw_limit         = menu_slider(x.tab, x.section, colours.element .. 'yaw limit -' .. colours.menutheme .. ' R', -180, 180, 0, true, '°'),   
        build_jitter        = menu_combobox(x.tab, x.section, colours.element .. 'Yaw jitter', {'Off','Offset','Center','Random'}),   
        build_l_jitter_sli  = menu_slider(x.tab, x.section, colours.element .. 'Yaw Jitter -' .. colours.menutheme .. ' L', -180, 180, 0, true, '°', 1),   
        build_r_jitter_sli  = menu_slider(x.tab, x.section, colours.element .. 'Yaw Jitter -' .. colours.menutheme .. ' R', -180, 180, 0, true, '°', 1),   
        build_body          = menu_combobox(x.tab, x.section, colours.element .. 'Body yaw', {'Off','Opposite','Jitter','Static'}),   
        build_body_sli      = menu_slider(x.tab, x.section, '\n' .. colours.element .. 'body sli', -180, 180, 0, true, '°', 1),   
        l_fake_limit        = menu_slider(x.tab, x.section, colours.element .. 'Fake yaw limit -' .. colours.menutheme .. ' L', 0, 60, 60, true, '°', 1),   
        r_fake_limit        = menu_slider(x.tab, x.section, colours.element .. 'Fake yaw limit -' .. colours.menutheme .. ' R', 0, 60, 60, true, '°', 1),
        build_free_b_yaw    = menu_checkbox(x.tab, x.section, colours.element .. 'Freestanding body yaw'),
        build_roll          = menu_slider(x.tab, x.section, colours.element .. 'Roll AA', -50, 50, 0, true, '°', 1),

    }
end

---------------------------------------------
--[CONFIGURATION SYSTEM]
---------------------------------------------
local base64 = {}
extract = function(v, from, width)
    return bit.band(bit.rshift(v, from), bit.lshift(1, width) - 1)
end
function base64.makeencoder(alphabet)
    local encoder = {}
    local t_alphabet = {}
    for i = 1, #alphabet do
        t_alphabet[i - 1] = alphabet:sub(i, i)
    end
    for b64code, char in pairs(t_alphabet) do
        encoder[b64code] = char:byte()
    end
    return encoder
end
function base64.makedecoder(alphabet)
    local decoder = {}
    for b64code, charcode in pairs(base64.makeencoder(alphabet)) do
        decoder[charcode] = b64code
    end
    return decoder
end
DEFAULT_ENCODER = base64.makeencoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')
DEFAULT_DECODER = base64.makedecoder('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=')

CUSTOM_ENCODER = base64.makeencoder('KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')
CUSTOM_DECODER = base64.makedecoder('KmAWpuFBOhdbI1orP2UN5vnSJcxVRgazk97ZfQqL0yHCl84wTj3eYXiD6stEGM+/=')

function base64.encode(str, encoder, usecaching)
    str = tostring(str)

    encoder = encoder or DEFAULT_ENCODER
    local t, k, n = {}, 1, #str
    local lastn = n % 3
    local cache = {}
    for i = 1, n - lastn, 3 do
        local a, b, c = str:byte(i, i + 2)
        local v = a * 0x10000 + b * 0x100 + c
        local s
        if usecaching then
            s = cache[v]
            if not s then
                s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                        encoder[extract(v, 0, 6)])
                cache[v] = s
            end
        else
            s = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                    encoder[extract(v, 0, 6)])
        end
        t[k] = s
        k = k + 1
    end
    if lastn == 2 then
        local a, b = str:byte(n - 1, n)
        local v = a * 0x10000 + b * 0x100
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[extract(v, 6, 6)],
                   encoder[64])
    elseif lastn == 1 then
        local v = str:byte(n) * 0x10000
        t[k] = string.char(encoder[extract(v, 18, 6)], encoder[extract(v, 12, 6)], encoder[64], encoder[64])
    end
    return table.concat(t)
end
function base64.decode(b64, decoder, usecaching)
    decoder = decoder or DEFAULT_DECODER
    local pattern = '[^%w%+%/%=]'
    if decoder then
        local s62, s63
        for charcode, b64code in pairs(decoder) do
            if b64code == 62 then
                s62 = charcode
            elseif b64code == 63 then
                s63 = charcode
            end
        end
        pattern = ('[^%%w%%%s%%%s%%=]'):format(string.char(s62), string.char(s63))
    end
    b64 = b64:gsub(pattern, '')
    local cache = usecaching and {}
    local t, k = {}, 1
    local n = #b64
    local padding = b64:sub(-2) == '==' and 2 or b64:sub(-1) == '=' and 1 or 0
    for i = 1, padding > 0 and n - 4 or n, 4 do
        local a, b, c, d = b64:byte(i, i + 3)
        local s
        if usecaching then
            local v0 = a * 0x1000000 + b * 0x10000 + c * 0x100 + d
            s = cache[v0]
            if not s then
                local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
                s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
                cache[v0] = s
            end
        else
            local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40 + decoder[d]
            s = string.char(extract(v, 16, 8), extract(v, 8, 8), extract(v, 0, 8))
        end
        t[k] = s
        k = k + 1
    end
    if padding == 1 then
        local a, b, c = b64:byte(n - 3, n - 1)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000 + decoder[c] * 0x40
        t[k] = string.char(extract(v, 16, 8), extract(v, 8, 8))
    elseif padding == 2 then
        local a, b = b64:byte(n - 3, n - 2)
        local v = decoder[a] * 0x40000 + decoder[b] * 0x1000
        t[k] = string.char(extract(v, 16, 8))
    end
    return table.concat(t)
end

local configs = {}
configs.validation_key = 'b5fa5c5cf5b401b00e06fd202a902d1f'

-- color: userdata holding 'r, g, b, a' as floats (0.0 - 1.0)
configs.convertColorToString = function(color)
	r = math_round(color.r * 255)
	g = math_round(color.g * 255)
	b = math_round(color.b * 255)
	a = math_round(color.a * 255)

    return string.format('%i, %i, %i, %i', r, g, b, a)
end

-- split 'str' at 'sep' and return a table of the resulting substrings
configs.splitString = function(str, sep)
    local sep, fields = sep or ':', {}
    local pattern = string.format('([^%s]+)', sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

-- loop through 'tbl' and save content into 'saveTbl'
configs.saveTable = function(tbl, saveTbl)
    -- table loop
    for k, v in pairs(tbl) do 
        -- if 'v' is a table, call the function again with adjusted arguments, basic recursion
        if type(v) == 'table' then
            -- since our value is a table we need to create an empty table
            -- in our 'saveTbl' with our key as the name of the table
            saveTbl[k] = {}
            -- call this function again with adjusted arguments
            -- 'v' is the table thats being looped over and our newly created table
            -- is the table that the values of 'v' get saved in
            configs.saveTable(v, saveTbl[k])
        else
            -- since 'v' isnt a table, we can safely assume its a menu element
            -- so get its value and save it in our 'saveTbl'
            if string.find(k, 'clr') ~= nil then
                if string.find(k, 'clr') > 0 and string.find(k, '_1') then
                    v = {
                    	type = 'color',
                    	v = {ui.get(v)},
                    }
                else
                    v = ui.get(v)
                end
            else
				v = ui.get(v)
				if type(v) == 'table' then
					v = {
						type = 'multi',
						v = v
					}
				end
            end
            --print(k .. ' ' .. json.stringify(v) .. ' t: ' .. json.stringify(type(v)))
            --v = ui.get
            -- if 'v' is of type 'userdata', it means that the menu element is a color picker
            -- so get the color and save that to 'saveTbl'
            saveTbl[k] = v
        end
    end    
end

-- tbl: values to load, menuElementsTable: table to save values into, should be the table that holds the menu elements, tblName: ignore, just for debugging
configs.loadTable = function(tbl, menuElementsTable, tblName)
    -- set 'tblName' to 'tblName' if it isnt set
    tblName = tblName or ''
    -- loop through 'tbl'
    for k, v in pairs(tbl) do 
        -- same thing as in 'saveTable'
        -- if 'v' is a table, call the function again with adjusted arguments
		if menuElementsTable[k] == nil then 
			if tonumber(k) then
				if menuElementsTable[tonumber(k)] ~= nil then
					configs.loadTable(v, menuElementsTable[tonumber(k)], tblName .. tonumber(k) .. '.')
				end

				--local newK = conditions_fix[k]
				--configs.loadTable(v, menuElementsTable[tostring(k)], tblName .. tostring(k) .. '.')
				--print(json.stringify(menuElementsTable))
				goto skip

			else
				goto skip 
			end
		end
        if type(v) == 'table' then
            if v.type ~= nil then 
                --print(k .. ' ' .. v.type .. ' v: ' .. json.stringify(v.v))
        		-- custom table, not a sub menu
        		-- meaning its either a color picker or a multiselect
        		if v.type == 'color' then
        			-- yep, color picker
        			local r, g, b, a = unpack(v.v)
                    ui.set(menuElementsTable[k], r, g, b, a)
        		elseif v.type == 'multi' then 
        			-- yep, multi select
        			ui.set(menuElementsTable[k], v.v)
        		end
        	else
	            -- our table to loop through becomes 'v'
            	-- and the table to save values in becomes the table that has the same name as 'km'
            	configs.loadTable(v, menuElementsTable[k], tblName .. k .. '.')
        	end
        else
        -- if the value contains spacebar it should be a color
		if menuElementsTable == nil then goto skip end
		if menuElementsTable[k] == nil then goto skip end

        if string.find(k, 'key') ~= nil or string.find(k, 'label') ~= nil then
            goto skip
        else
			local test = ui.get(menuElementsTable[k], v)
			if test == nil then goto skip end

			local success, err = pcall(function () ui.set(menuElementsTable[k], v) end)
            --ui.set(menuElementsTable[k], v)
        end
        --print(type(v))
        --if v.type ~= nil then 
        --    print('true')
        --end
		--print('Setting ' .. tblName .. k .. ' to ' .. tostring(v) .. ' (prev ' .. tostring(menuElementsTable[k]) .. ')')

			::skip::
            
        end      
		::skip::  
    end   
end

configs.clipboard_import = function(self)
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

configs.clipboard_export = function(self, string)
	if string then
		set_clipboard_text(VGUI_System, string, #string)
	end
end

--add to list
local db_configs = database.read('carinthia_configs') or {
    ['Ryan'] = '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'
}

local cloud_presets = {}

--array for storing
configs.getConfigNames = function()
	local values = {}

    for cconfig_name, __ in pairs(cloud_presets) do
		table.insert(values, cconfig_name)
	end	
	
	for config_name, _ in pairs(db_configs) do
		table.insert(values, config_name)
	end
	return values
end

configs.getConfigNameForID = function(id)
	return configs.getConfigNames()[id]
end

configs.list = menu_listbox('aa', 'anti-aimbot angles', 'configs list', function(self)
	--ui.set(configs.config_name, 'asd')
end)

menu_set_callback(configs.list, function()
	local configID = menu_get(configs.list)
	if configID == nil then return end
	local name = configs.getConfigNameForID(configID + 1)

	menu_set(configs.config_name, name)
end)

--load from web
function init_database()
    if database.read(db_configs) == nil then
        database.write(db_configs, {})
    end

    local user, token = 'github username', 'auth token' -- get from github account settings (lmk if you need help, you probably wont need it unless your repo is private)

    http.get('https://starlua.net/cloud_cfgs/topg.json', function(success, response) -- {authorization = {user, token}} < ONLY USE IF YOUR REPO IS PRIVATE
        if not success then
            print('Failed to get presets')
            return
        end

		presets = json.parse(response.body)

        --local db = database.read(db_configs)

        for i, preset in pairs(presets.presets) do
			local name = '*'.. preset.name .. " (" .. preset.update .. ")"
			local config = preset.config
			cloud_presets[name] = config
            --table.insert(cloud_presets, { name = '*'..preset.name .. " (" .. preset.update .. ")", config = preset.config})
        end

        ui.update(configs.list, configs.getConfigNames())
    end) 
end

init_database()

configs.config_name = menu_textbox('aa', 'anti-aimbot angles', 'Config')

local valueTable = {}

configs.save = menu_button('aa', 'anti-aimbot angles', 'Save', function(self)
	local txtbox = menu_get(configs.config_name)

    local configID = menu_get(configs.list)
	local name = ''

	if configID ~= nil then 
		name = configs.getConfigNameForID(configID + 1)
		if name == '' then 
            print('Configuration has to have a name!')
			return 
		end
	end
	
	if txtbox == '' then
		return
	end

	if name == txtbox then
		-- get stuff
		configs.saveTable(carinthia, valueTable)
		valueTable[configs.validation_key] = true

		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)

		db_configs[name] = json_config
        print('Configuration ' .. name .. ' succesfully saved!')
	else
		configs.saveTable(carinthia, valueTable)
		valueTable[configs.validation_key] = true

		local json_config = json.stringify(valueTable)
		
		json_config = base64.encode(json_config, CUSTOM_ENCODER)
	
		db_configs[txtbox] = json_config
        print('Configuration ' .. txtbox .. ' succesfully created!')
	end

	database.write('carinthia_configs', db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
end)


configs.load = ui.new_button('aa', 'anti-aimbot angles', 'Load', function()
    local configID = menu_get(configs.list)
	if configID == nil then return end

    local name = configs.getConfigNameForID(configID + 1)

    local protected = function()
		local cfg = db_configs[name]

		if cfg == nil then
			cfg = cloud_presets[name]
		end

        local json_config = base64.decode(cfg, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
            error('cannot_find_validation_key')
            print('cannot_find_validation_key')
            return
        end

        json_config = json.parse(json_config)

        if json_config == nil then
            error('wrong_json')
            print('wrong_json')
            return
        end

        configs.loadTable(json_config, carinthia)
    end

    local status, message = pcall(protected)

    if not status then
        print('Failed to load config:', message)
        return
    end

    print("Loaded configuration " .. name)
end)

configs.delete = ui.new_button('aa', 'anti-aimbot angles', 'Delete', function()
    local configID = menu_get(configs.list)
	if configID == nil then return end
	local txtbox = menu_get(configs.config_name)
	local name = configs.getConfigNameForID(configID + 1)

	if name == '' or txtbox == '' or name == nil then
		return
	end

    if cloud_presets[name] then
		print("You can't delete cloud configurations!")
		return
	end
	
	db_configs[name] = nil
	database.write('carinthia_configs', db_configs)

	--update listbox
	ui.update(configs.list, configs.getConfigNames())
    print('Succesfully deleted ' .. name .. '!')

end)

--update listbox on load
ui.update(configs.list, configs.getConfigNames())

configs.import = menu_button('aa', 'anti-aimbot angles', 'Import from clipboard', function(self)
    local protected = function()
        local clipboard = text == nil and configs:clipboard_import() or text

        local json_config = base64.decode(clipboard, CUSTOM_DECODER)

        if json_config:match(configs.validation_key) == nil then
            error('cannot_find_validation_key')
            return
        end

        json_config = json.parse(json_config)

        if json_config == nil then
            error('wrong_json')
            print('wrong_json')
            return
        end

		print('Succesfully imported from clipboard')
        configs.loadTable(json_config, carinthia)

    end

    local status, message = pcall(protected)

    if not status then
        print('Failed to load config:', message)
        return
    end
end)

configs.export = menu_button('aa', 'anti-aimbot angles', 'Export to clipboard', function()
    local configID = menu_get(configs.list)
	
	configs.saveTable(carinthia, valueTable)
	valueTable[configs.validation_key] = true

	local json_config = json.stringify(valueTable)
	
	json_config = base64.encode(json_config, CUSTOM_ENCODER)

	configs:clipboard_export(json_config)	

    print('Succesfully exported to clipboard')
end)



---------------------------------------------
--[ANTI_AIM CONDITION CHECK]
---------------------------------------------

local xxx = 'Stand'
local function get_mode(e)
    -- 'Stand', 'Duck CT', 'Duck T', 'Moving', 'Air', Slow motion'
    local localplayer = entity_get_local_player()
    local vecvelocity = { entity_get_prop(localplayer, 'm_vecVelocity') }
    local velocity = math_sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity_get_prop(localplayer, 'm_fFlags'), 1) == 1 and e.in_jump == 0
    local not_moving = velocity < 2

    local slowwalk_key = menu_get(reference.slow[1]) and menu_get(reference.slow[2])
    local teamnum = entity_get_prop(localplayer, 'm_iTeamNum')

    local ct      = teamnum == 3
    local t       = teamnum == 2

    if not menu_get(reference.bhop) then
        on_ground = bit.band(entity.get_prop(localplayer, 'm_fFlags'), 1) == 1
    end
    
    if not on_ground then
        xxx = ((entity_get_prop(localplayer, 'm_flDuckAmount') > 0.7) and menu_get(carinthia.builder[state_to_num['Air duck']].build_enabled)) and 'Air duck' or 'Air'
    else
        if menu_get(reference.fakeduck) or (entity_get_prop(localplayer, 'm_flDuckAmount') > 0.7) then
            if ct then 
                xxx = 'Duck CT'
            elseif t then
                xxx = 'Duck T'
            end
        elseif not_moving then
            
            xxx = 'Stand'
        elseif not not_moving then
            if slowwalk_key then
    
                xxx = 'Slow'
            else
    
                xxx = 'Moving'
            end
        end
    end

    return xxx

end


---------------------------------------------
--[VISUAL LOCALS/FUNCS]
---------------------------------------------

local gradientanim = function(text_to_draw, speed)
    local base_r, base_g, base_b,base_a = menu_get(carinthia.visual.clr_col1)
    local r2, g2, b2, a2 = menu_get(carinthia.visual.clr_col2)
    local highlight_fraction =  (globals_realtime() / 2 % 1.2 * speed) - 1.2
    local output = ''
    for idx = 1, #text_to_draw do
        local character = text_to_draw:sub(idx, idx)
        local character_fraction = idx / #text_to_draw

        local r, g, b, a = base_r, base_g, base_b, base_a
        local highlight_delta = (character_fraction - highlight_fraction)
        if highlight_delta >= 0 and highlight_delta <= 1.4 then
            if highlight_delta > 0.7 then
                highlight_delta = 1.4 - highlight_delta
            end
            local r_fraction, g_fraction, b_fraction, a_fraction = r2 - r, g2 - g, b2 - b
            r = r + r_fraction * highlight_delta / 0.8
            g = g + g_fraction * highlight_delta / 0.8
            b = b + b_fraction * highlight_delta / 0.8
        end
        output = output .. ('\a%02x%02x%02x%02x%s'):format(r, g, b, 255, text_to_draw:sub(idx, idx))
    end
    return output
end

--Disabling indicators animation vars
local xposdt    = 0
local xposos    = 0
local alphadt   = 0
local alphaos   = 0

--Scoped animation carinthia
local c_top     = 0
local c_indi    = 0
local c_hide    = 0

--Scoped animation Simple
local s_top     = 0
local s_build   = 0
local s_state   = 0
local s_dt      = 0
local s_hide    = 0

--Scoped animation Kydex
local k_kydex   = 0
local k_main    = 0
local k_state   = 0

local opacity = 0

local function renderer_shit(x, y, w, r, g, b, a, edge_h)

    opacity = ease.quad_in(0.5, opacity, (is_menu_open() and 180 or 0) - opacity, 3)
    render_rectangle_rounded(x + 1, y+10, w - 3 , 48, 20, 20, 20, opacity, 10)


    --MAIN BODY
	render_rectangle_rounded(x+1, y-2, w-3, 19, 20, 20, 20, 255, 4)
    --OUTER TRANSPARENT
    render_rectangle_rounded(x, y-3, w-1, 21, 15, 15, 15, 120, 4)

end

---------------------------------------------
--[MENU HANDLING]
---------------------------------------------

local menu = {

    carinthia_vis = function(self)
        --Menu checks
        local luaenabled   = menu_get(carinthia.luaenable)
        ---------------------------
        local menu_antiaim = menu_get(carinthia.tabselect) == 'Anti-Aim' and luaenabled
        local menu_visual  = menu_get(carinthia.tabselect) == 'Visuals' and luaenabled
        local menu_config  = menu_get(carinthia.tabselect) == 'Config' and luaenabled
        local menu_misc    = menu_get(carinthia.tabselect) == 'Misc' and luaenabled
        ---------------------------
        local keybinds_m   = menu_get(carinthia.antiaim.page_select) == 'Keybinds' and menu_get(carinthia.antiaim.manual_master)
        local keybinds_o   = menu_get(carinthia.antiaim.page_select) == 'Keybinds' and menu_get(carinthia.antiaim.other_master)
        local builder      = menu_get(carinthia.antiaim.page_select) == 'Custom Builder'
        ---------------------------
        local select_cross = contains(ui.get(carinthia.visual.indicator_select), 'Crosshair')
        local enable_1     = menu_get(carinthia.visual.crosshair_select) ~= '-'
        local water_master = contains(ui.get(carinthia.visual.indicator_select), 'Lua watermark')
        local anim_master  = contains(ui.get(carinthia.visual.indicator_select), 'Animations')

        menu_setvisible(carinthia.tabselect, luaenabled)

        --Anti-aim
        menu_setvisible(carinthia.antiaim.page_select, menu_antiaim)
        menu_setvisible(carinthia.antiaim.manual_master, menu_antiaim and menu_get(carinthia.antiaim.page_select) == 'Keybinds')
        menu_setvisible(carinthia.antiaim.key_forward, menu_antiaim and keybinds_m)
        menu_setvisible(carinthia.antiaim.key_left, menu_antiaim and keybinds_m)
        menu_setvisible(carinthia.antiaim.key_right, menu_antiaim and keybinds_m)
        menu_setvisible(carinthia.antiaim.other_master, menu_antiaim and menu_get(carinthia.antiaim.page_select) == 'Keybinds')
        menu_setvisible(carinthia.antiaim.key_legit, menu_antiaim and keybinds_o)
        menu_setvisible(carinthia.antiaim.key_freestand, menu_antiaim and keybinds_o)
        menu_setvisible(carinthia.antiaim.static_fs, menu_antiaim and keybinds_o)
        menu_setvisible(carinthia.antiaim.header_spacer, menu_antiaim)
        menu_setvisible(carinthia.antiaim.builder_header, menu_antiaim)
        menu_setvisible(carinthia.antiaim.builder_sub, menu_antiaim)
        menu_setvisible(carinthia.antiaim.aa_cond, menu_antiaim)

        --Visual
        menu_setvisible(carinthia.visual.indi_header,menu_visual)
        menu_setvisible(carinthia.visual.indi_sub,menu_visual)
        menu_setvisible(carinthia.visual.indih_spacer,menu_visual)
        menu_setvisible(carinthia.visual.indicator_select, menu_visual)
        menu_setvisible(carinthia.visual.crosshair_select, menu_visual and select_cross)
        menu_setvisible(carinthia.visual.clr_col1_label, menu_visual and select_cross and enable_1)
        menu_setvisible(carinthia.visual.clr_col1, menu_visual and select_cross and enable_1)
        menu_setvisible(carinthia.visual.clr_col2_label, menu_visual and select_cross and enable_1)
        menu_setvisible(carinthia.visual.clr_col2, menu_visual and select_cross and enable_1)
        menu_setvisible(carinthia.visual.indi_opt, menu_visual and select_cross and menu_get(carinthia.visual.crosshair_select) == 'Simple')
        menu_setvisible(carinthia.visual.watermark_master, menu_visual and water_master)
        menu_setvisible(carinthia.visual.clr_wm_label, menu_visual and water_master)
        menu_setvisible(carinthia.visual.clr_wm, menu_visual and water_master)
        menu_setvisible(carinthia.visual.extra, menu_visual)
        menu_setvisible(carinthia.visual.animbreaker, menu_visual and anim_master)

        --Misc
        menu_setvisible(carinthia.misc.misc_header, menu_misc)
        menu_setvisible(carinthia.misc.misc_sub, menu_misc)
        menu_setvisible(carinthia.misc.misch_spacer, menu_misc)
        menu_setvisible(carinthia.misc.dtenable, menu_misc)
        menu_setvisible(carinthia.misc.dtspeed, menu_misc and menu_get(carinthia.misc.dtenable))
        menu_setvisible(carinthia.misc.fastswap, menu_misc)
        menu_setvisible(carinthia.misc.defensive_air, menu_misc)

        --Config
        menu_setvisible(carinthia.config.config_header, menu_config)
        menu_setvisible(carinthia.config.config_sub, menu_config)  
        menu_setvisible(carinthia.config.config_space, menu_config) 
        menu_setvisible(configs.list, menu_config)
        menu_setvisible(configs.config_name, menu_config)
        menu_setvisible(configs.save, menu_config)
        menu_setvisible(configs.load, menu_config)
        menu_setvisible(configs.delete, menu_config)
        menu_setvisible(configs.import, menu_config)
        menu_setvisible(configs.export, menu_config)

    end,

    hide_original_menu = function(self, state)
        --OG MENU
        menu_setvisible(reference.enabled, state)
        menu_setvisible(reference.pitch, state)
        menu_setvisible(reference.yawbase, state)
        menu_setvisible(reference.yaw[1], state)
        menu_setvisible(reference.yaw[2], state)
        menu_setvisible(reference.yawjitter[1], state)
        menu_setvisible(reference.yawjitter[2], state)
        menu_setvisible(reference.bodyyaw[1], state)
        menu_setvisible(reference.bodyyaw[2], state)
        menu_setvisible(reference.fsbodyyaw, state)
        menu_setvisible(reference.edgeyaw, state)
        menu_setvisible(reference.roll, state)
        menu_setvisible(reference.freestand[1], state)
        menu_setvisible(reference.freestand[2], state)
        menu_setvisible(reference.fl_limit, state)
    end,

    handle_menu = function(self)
        local enabled = menu_get(carinthia.luaenable) and menu_get(carinthia.tabselect) == 'Anti-Aim' and menu_get(carinthia.antiaim.page_select) == 'Custom Builder'
        menu_setvisible(carinthia.antiaim.aa_cond, enabled)
    
        for i=1, #aa_config do
            local show = menu_get(carinthia.antiaim.aa_cond) == aa_config[i] and enabled 
            menu_setvisible(carinthia.builder[i].build_enabled, show and i > 1)

            if i > 1 then
                show = show and menu_get(carinthia.builder[i].build_enabled)
            end

            local lryaw_show    = menu_get(carinthia.builder[i].build_yaw) ~= 'Off'
            local lrjitter_show = menu_get(carinthia.builder[i].build_jitter) ~= 'Off' 
            local lrfake_show   = menu_get(carinthia.builder[i].build_body) ~= 'Off' 

            menu_setvisible(carinthia.builder[i].build_pitch, show)
            menu_setvisible(carinthia.builder[i].build_yawbase, show)
            menu_setvisible(carinthia.builder[i].build_yaw, show)
            menu_setvisible(carinthia.builder[i].l_yaw_limit, show and lryaw_show)
            menu_setvisible(carinthia.builder[i].r_yaw_limit, show and lryaw_show)
            menu_setvisible(carinthia.builder[i].build_jitter, show)
            menu_setvisible(carinthia.builder[i].build_l_jitter_sli, show and lrjitter_show)
            menu_setvisible(carinthia.builder[i].build_r_jitter_sli, show and lrjitter_show)
            menu_setvisible(carinthia.builder[i].build_body, show)
            menu_setvisible(carinthia.builder[i].build_body_sli, show and lrfake_show and menu_get(carinthia.builder[i].build_body) ~= 'Opposite')
            menu_setvisible(carinthia.builder[i].l_fake_limit, show and lrfake_show)
            menu_setvisible(carinthia.builder[i].r_fake_limit, show and lrfake_show)
            menu_setvisible(carinthia.builder[i].build_free_b_yaw, show and lrfake_show)
            menu_setvisible(carinthia.builder[i].build_roll, show and lrfake_show)

        end
    end,

    onscreen_visuals = function(self)
        --Checks
        local enabled     = menu_get(carinthia.luaenable)
        local localplayer = entity_get_local_player()
        if enabled == false or localplayer == nil or entity_is_alive(localplayer) == false then return end

        --Centering pos
        screen = {client_screen_size()}
        center = {screen[1]/2, screen[2]/2} 

        --Spacing var
        local spacing = 0 

        --locals to make things cleaner
        local xsimple       = menu_get(carinthia.visual.crosshair_select) == 'Simple'
        local xcarinthia    = menu_get(carinthia.visual.crosshair_select) == 'Carinthia'
        local xkydex        = menu_get(carinthia.visual.crosshair_select) == 'Kydex'
        local alpha_pulse   = math.min(math.floor(math.sin((globals_realtime() % 3) * 3) * 75 + 150), 255)

        --Lua watermark locals
        local lua_watermark = menu_get(carinthia.visual.watermark_master) and contains(ui.get(carinthia.visual.indicator_select), 'Lua watermark')
        local obex_data     = {username = 'scriptleaks', build = 'boosters'}
        local build_size    = render_measure_text('', obex_data.build)

        --Grabbing Current aa state
        local indi_state    = 0
        if xcarinthia or xkydex then 
            indi_state      = string.upper(xxx)
        else
            indi_state      = string.lower(xxx)
        end
        local acti_indi_state = menu_get(carinthia.builder[state_to_num[xxx]].build_enabled) and indi_state or 'GLOBAL'

        --Center of active state text
        local centerstate   = 0
        if xcarinthia or xkydex then
            centerstate     = render_measure_text('-', acti_indi_state)
        elseif xsimple then
            centerstate     = render_measure_text('', acti_indi_state)
        end
        local centerpixel   = centerstate / 2

        --Scoped checks
        local scpd             = entity.get_prop(localplayer, 'm_bIsScoped') == 1
        local scoped_carinthia = xcarinthia and scpd
        local scoped_simple    = xsimple and scpd
        local scoped_kydex     = xkydex and scpd

        --Random info storing
        local dtz    = menu_get(reference.dt[1]) and menu_get(reference.dt[2])
        local osz    = menu_get(reference.os[2])
        local buildz = menu_get(carinthia.visual.indi_opt) == 'Build'
        local statez = menu_get(carinthia.visual.indi_opt) == 'Anti-aim state'

        --Disabling indicators animation
        xposdt  = animation(dtz, xposdt, 10, 15)
        xposos  = animation(osz, xposos, 10, 15)
        alphadt = animation(dtz, alphadt, 255, 15)
        alphaos = animation(osz, alphaos, 255, 15)

        --Scoped animation carinthia
        c_top  =  animation(scoped_carinthia, c_top, 32, 15)
        c_indi =  animation(scoped_carinthia, c_indi, 16, 15)
        c_hide =  animation(scoped_carinthia, c_hide, 8, 15)

        --Scoped animation Simple 
        s_top   = animation(scoped_simple, s_top, 24, 15)
        s_build = animation(scoped_simple, s_build, 14, 15)
        s_state = animation(scoped_simple, s_state, 13, 15)
        s_dt    = animation(scoped_simple, s_dt, 8, 15)
        s_hide  = animation(scoped_simple, s_hide, 13, 15)

        --Scoped animation Kydex
        k_kydex = animation(scoped_kydex, k_kydex, 12, 15)
        k_main  = animation(scoped_kydex, k_main, 31, 15)
        k_state = animation(scoped_kydex, k_state, 11, 15)

        if scpd then
            centerpixel = 10
        end

        if contains(menu_get(carinthia.visual.indicator_select), 'Crosshair') then 
            if xcarinthia then
            
                local r, g, b, a = menu_get(carinthia.visual.clr_col1)
                local r2, g2, b2, a2 = menu_get(carinthia.visual.clr_col2)
                local text_to_render = gradient(r, g, b, a, r2, g2, b2, a2, 'CARINTHIA')
            
                local nameX = render_measure_text('-', 'CARINTHIA')
                local fullName = render_measure_text('-', 'CARINTHIA BOOSTERS')
                local nameX_center = nameX / 2
                local fullname_x = fullName / 2
            
                --Carinthia
                render_text(center[1] - 2, center[2] + 20, 255, 255, 255, 255,'c-', 0, text_to_render)
                --State
                render_text(center[1] - centerpixel + c_indi - 4, center[2] + 25, 185, 185, 185, 255,'-', 0, '*' .. acti_indi_state .. '*')
            
                if menu_get(reference.os[2]) then
                    render_text(center[1] + c_hide - 1, center[2] + 40, 185, 185, 185, 255,'c-', 0, 'OS')
                end
            
            elseif xsimple then
            
                render_text(center[1] + s_top, center[2] + 20, 255, 255, 255, 255,'c', 0, gradientanim('carinthia', 3))
            
                if buildz then 
                    render_text(center[1] + s_build, center[2] + 30, 185, 185, 185, alpha_pulse,'c', 0, 'BOOSTERS')
                
                elseif statez then
                    render_text(center[1] - centerpixel + s_state, center[2] + 23, 185, 185, 185, 255,'', 0, acti_indi_state)
                end
            
                render_text(center[1] + s_dt, center[2] + xposdt + 31 + (spacing * 10), 185, 185, 185, alphadt,'c', 0, 'dt')
            
                if dtz then spacing = spacing + 1 end
            
                render_text(center[1] + s_hide, center[2] + xposos + 31 + (spacing * 10), 185, 185, 185, alphaos,'c', 0, 'hide')
            
                if osz then spacing = spacing + 1 end
            
            elseif xkydex then
                
                render_text(center[1] + k_kydex, center[2] + 21, 255, 255, 255, 255,'c-', 0, 'KYDEX')
                render_text(center[1] + k_main, center[2] + 30, 255, 255, 255, 255,'cb', 0, gradientanim('carinthialua', 3))
                render_text(center[1] - centerpixel + k_state, center[2] + 35, 255, 255, 255, 255,'-', 0, gradientanim(acti_indi_state, 3))

            
            
            end

            if lua_watermark then

                screen = {client_screen_size()}
                center = {screen[1]/2, screen[2]/2} 

                opacity = ease.quad_in(0.5, opacity, (is_menu_open() and 255 or 0) - opacity, 3)

                local r, g, b, a   = menu_get(carinthia.visual.clr_wm)
                local wm_col       = rgbtohex(r, g, b) .. 'FF'

                local data_suffix  = 'carinthia.lua'
                local nickname     = obex_data.username
                local h, m, s, mst = client.system_time()
                local actual_time  = ('%2d:%02d'):format(h, m)
                    
                local latency      = client.latency()*1000
                local latency_text = ('  %d'):format(latency) or ''
            
                text    = ('\a' .. wm_col .. '%s \a737373FF / %s /\a' .. wm_col .. '%s \a737373FFms\a' .. wm_col .. ' %s\a737373FF pm '):format(data_suffix, nickname, latency_text, actual_time)
                un, mb  = ('Username - '), ('Build - ')

                local un, mb = renderer.measure_text(nil, un), renderer.measure_text(nil, mb)

                local h, w = 18, renderer.measure_text(nil, text) + 8
                local x, y = client.screen_size(), 10 + (-3)
                    
                x = x - w - 10
            
                if lua_watermark then

                    renderer_shit(x, y, w, 65, 65, 65, 180, 2)
                    renderer.text(x+4, y + 1, 255, 255, 255, 255, '', 0, text)

                    renderer.text(x + 5, y + 20, 170, 170, 170, opacity, '', 0, 'Username - ' )
                    renderer.text(x + 5, y + 35, 170, 170, 170, opacity, '', 0, 'Build - ')

                    renderer.text(x + 5 + un, y + 20, r, g, b, opacity, '', 0, nickname)
                    renderer.text(x + 5 + mb, y + 35, r, g, b, opacity, '', 0, 'BOOSTERS')
                
                end
            end
        
            if contains(menu_get(carinthia.visual.extra), 'Force baim') then
                if menu_get(reference.forcebaim) then
                    renderer.indicator(162, 0, 20, 255, 'FORCE BAIM')
                end
            end
            if contains(menu_get(carinthia.visual.extra), 'Ping spike') then
                if menu_get(reference.pingspike[2]) then
                    renderer.indicator(162, 196, 81, 255, 'PING')
                end
            end

            if contains(menu_get(carinthia.visual.animbreaker), 'Moonwalk') then
                entity.set_prop(localplayer, "m_flPoseParameter", 0, 7)
            else
                entity.set_prop(localplayer, "m_flPoseParameter", 0, 5)
            end

        end
    end,
}

---------------------------------------------
--[LEGIT AA]
---------------------------------------------
local legit = {
    entity_has_c4 = function(self, ent)
        local bomb = entity.get_all('CC4')[1]
        return bomb ~= nil and entity_get_prop(bomb, 'm_hOwnerEntity') == ent
    end,

    distance_3d = function(self, x1, y1, z1, x2, y2, z2)
        return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
    end,

    classnames = { 
        'CWorld', 
        'CCSPlayer', 
        'CFuncBrush' 
    },

    aa_on_use = function(self, e)
        if not menu_get(carinthia.antiaim.key_legit) or not menu_get(carinthia.antiaim.other_master) then 
            return 
        end
    
        local local_player = entity_get_local_player()
        
        local distance = 100
        local bomb = entity_get_all('CPlantedC4')[1]
        local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, 'm_vecOrigin')
    
        if bomb_x ~= nil then
            local player_x, player_y, player_z = entity_get_prop(local_player, 'm_vecOrigin')
            distance = self:distance_3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
        end
        
        local distance_h = 100
        local hostage = entity_get_all('CHostage')[1]
        local hostage_x, hostage_y, hostage_z = entity_get_prop(hostage, 'm_vecOrigin')
        
        if hostage_x ~= nil then
            local player_x, player_y, player_z = entity_get_prop(local_player, 'm_vecOrigin')
            distance_h = self:distance_3d(hostage_x, hostage_y, hostage_z, player_x, player_y, player_z)
        end
        
        local team_num = entity_get_prop(local_player, 'm_iTeamNum')
        local defusing_bomb = team_num == 3 and distance < 62
        local getting_hostage = team_num == 3 and distance_h < 62
    
        local on_bombsite = entity_get_prop(local_player, 'm_bInBombZone')
        
        local has_bomb = self:entity_has_c4(local_player)
        local planting_bomb = on_bombsite ~= 0 and team_num == 2 and has_bomb
        
        local eyepos = vector(client.eye_position())
        local pitch, yaw = client.camera_angles()
    
        local sin_pitch = math.sin(math.rad(pitch))
        local cos_pitch = math.cos(math.rad(pitch))
        local sin_yaw = math.sin(math.rad(yaw))
        local cos_yaw = math.cos(math.rad(yaw))
    
        local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
        local fraction, entindex = client_trace_line(local_player, eyepos.x, eyepos.y, eyepos.z, eyepos.x + (dir_vec[1] * 8192), eyepos.y + (dir_vec[2] * 8192), eyepos.z + (dir_vec[3] * 8192))
    
        local using = true
    
        if entindex ~= nil then
            for i=0, #self.classnames do
                if entity_get_classname(entindex) == self.classnames[i] then
                    using = false
                end
            end
        end
    
        if not using and not planting_bomb and not defusing_bomb and not getting_hostage then
            e.in_use = 0
        end
    end,
}
---------------------------------------------
--[LEGIT AA]
---------------------------------------------

---------------------------------------------
--[MANUAL AA]
---------------------------------------------
local last_press_t_dir = 0
local yaw_direction = 0

local run_direction = function()
	menu_set(carinthia.antiaim.key_forward, 'On hotkey')
	menu_set(carinthia.antiaim.key_left, 'On hotkey')
	menu_set(carinthia.antiaim.key_right, 'On hotkey')

    local static_fs       = menu_get(carinthia.antiaim.static_fs)
    local master_o_enable = menu_get(carinthia.antiaim.other_master)

    if static_fs and master_o_enable and menu_get(carinthia.antiaim.key_freestand) then
        menu_set(reference.yawjitter[2], 0)
    end

    menu_set(reference.freestand[1], menu_get(carinthia.antiaim.key_freestand) and true or false)
    menu_set(reference.freestand[2], menu_get(carinthia.antiaim.key_freestand) and 'Always on' or 'On hotkey')

	if menu_get(carinthia.antiaim.key_freestand) and menu_get(carinthia.antiaim.manual_master) or not menu_get(carinthia.antiaim.manual_master) then
		yaw_direction = 0
		last_press_t_dir = globals.curtime()
	else
		if menu_get(carinthia.antiaim.key_forward) and last_press_t_dir + 0.2 < globals_curtime() then
            yaw_direction = yaw_direction == 180 and 0 or 180
			last_press_t_dir = globals_curtime()
		elseif menu_get(carinthia.antiaim.key_right) and last_press_t_dir + 0.2 < globals_curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals_curtime()
		elseif menu_get(carinthia.antiaim.key_left) and last_press_t_dir + 0.2 < globals_curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals_curtime()
		elseif last_press_t_dir > globals.curtime() then
			last_press_t_dir = globals_curtime()
		end
	end
end

local handle_keybinds = function()
    local freestand = menu_get(carinthia.antiaim.key_freestand)
    menu_set(reference.freestand[1], freestand and true or false)
    menu_set(reference.freestand[2], freestand and 0 or 2)
end
---------------------------------------------
--[MANUAL AA]
---------------------------------------------

client_set_event_callback('shutdown', function()

    menu:hide_original_menu(true)

end)

client_set_event_callback('paint_ui', function()
    menu:onscreen_visuals()

    if is_menu_open() then
        menu:carinthia_vis()
        menu:hide_original_menu(false)
        menu:handle_menu()
    end
end)

client_set_event_callback('setup_command', function(e)

    local localplayer = entity_get_local_player()
    menu_set(reference.enabled, menu_get(carinthia.luaenable))
    if localplayer == nil or not entity_is_alive(localplayer) or not menu_get(carinthia.luaenable) then
        return
    end


    --HIDESHOTS FIX
    local hide_check     = menu_get(reference.os[2])
    local fakeduck_check = menu_get(reference.fakeduck)

    if hide_check and not fakeduck_check then
	    menu_set(reference.fl_limit, 1)
    else
	    menu_set(reference.fl_limit, menu_get(carinthia.antiaim.fl_slider))
    end

    --HIDESHOTS FIX


    local state = get_mode(e)
    local legit_aa = menu_get(carinthia.antiaim.key_legit) and menu_get(carinthia.antiaim.other_master)

    state = menu_get(carinthia.builder[state_to_num[state]].build_enabled) and state_to_num[state] or state_to_num['Global']
    
    local defensive_air = menu_get(carinthia.misc.defensive_air)

    if defensive_air then
        if xxx == 'Air' or xxx == 'Air duck' then
            e.force_defensive = true
        end
    end

    local desync_type = entity_get_prop(localplayer, 'm_flPoseParameter', 11) * 120 - 60
	local desync_side = desync_type > 0 and 1 or -1
    if desync_side == 1 then
        --left
        menu_set(reference.yaw[2], yaw_direction == 0 and menu_get(carinthia.builder[state].l_yaw_limit) or yaw_direction)
    --    menu_set(reference.fakeyawlimit, legit_aa and 58 or menu_get(carinthia.builder[state].l_fake_limit))
        menu_set(reference.yawjitter[2], menu_get(carinthia.builder[state].build_l_jitter_sli))
    elseif desync_side == -1 then
        --right
        menu_set(reference.yaw[2], yaw_direction == 0 and menu_get(carinthia.builder[state].r_yaw_limit) or yaw_direction)
     --   menu_set(reference.fakeyawlimit, legit_aa and 58 or menu_get(carinthia.builder[state].r_fake_limit))
        menu_set(reference.yawjitter[2], menu_get(carinthia.builder[state].build_r_jitter_sli))
    end

    menu_set(reference.pitch, legit_aa and 'Off' or menu_get(carinthia.builder[state].build_pitch))
    menu_set(reference.yawbase, legit_aa and 'Local view' or menu_get(carinthia.builder[state].build_yawbase))
    menu_set(reference.yaw[1], legit_aa and 'Off' or menu_get(carinthia.builder[state].build_yaw))
    --local force_roll = menu_get(build.keybinds.key_roll) and contains(menu_get(build.antiaim.aa_settings), 'Force Roll')
    menu_set(reference.yawjitter[1], menu_get(carinthia.builder[state].build_jitter))
    menu_set(reference.bodyyaw[1], legit_aa and 'Opposite' or menu_get(carinthia.builder[state].build_body))
    menu_set(reference.bodyyaw[2], menu_get(carinthia.builder[state].build_body_sli))
    menu_set(reference.fsbodyyaw, legit_aa and true or menu_get(carinthia.builder[state].build_free_b_yaw))
    menu_set(reference.roll, force_roll and menu_get(carinthia.builder[state].build_roll) or 0)

    if force_roll then
        e.roll = menu_get(carinthia.builder[state].build_roll) 
    end

    handle_keybinds()
    run_direction()

    legit:aa_on_use(e)
end)

---------------------------------------------
--[FAST SWITCH]
---------------------------------------------
client_set_event_callback('grenade_thrown', function(e)
    if menu_get(carinthia.misc.fastswap) then
      local lp = entity_get_local_player();
      local userid = client_userid_to_entindex(e.userid);
    
      if userid ~= lp then
        return
      end
    
      client.exec('slot3; slot2; slot1');
    end
  end);
  
  client_set_event_callback('weapon_fire', function(e)
    if menu_get(carinthia.misc.fastswap) then
      if e.weapon ~= 'weapon_taser' then
        return
      end
  
      local lp = entity_get_local_player();
      local userid = client_userid_to_entindex(e.userid);
  
      if userid ~= lp then
        return
      end
    
      client.exec('slot3; slot2; slot1');
    end
  end);


