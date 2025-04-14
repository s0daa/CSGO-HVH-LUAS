-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local ffi = require("ffi")
local vector = require("vector")
local antiaim_funcs = require("gamesense/antiaim_funcs")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")

local last_press_t_dir = 0
local yaw_direction = 0

local killsays = {
	"ur so bad lmao",
	"doing ur mom",
	"is it possible to be that bad as you lmao",
	"1, nice aa",
	"u pay for this? xd",
	"tell ur mom to stop, my cock is falling off from sucking",
	"two finger hvher? devyc is that you",
	"lose weight k1d",
}

local get_name = panorama.loadstring([[ return MyPersonaAPI.GetName() ]])

local obex_data = obex_fetch and obex_fetch() or {username = 'author213', build = 'NA'}

local build = "live"
local username = obex_data.username
local user = username:lower()

-- Locals
local p_states = { 
	'Default',
	'Standing', 
	'Slow motion', 
	'Moving', 
	'Jumping', 
	'Duck jumping',
	'Crouching'
}

local p_states_num = { 
	['Default'] = 1,
	['Standing'] = 2, 
	['Slow motion'] = 3, 
	['Moving'] = 4, 
	['Jumping'] = 5, 
	['Duck jumping'] = 6, 
	['Crouching'] = 7,
	
}

local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }

local player_state = "Standing"

local custom = {}
local logs_txt = {}
local configs = {}

-- Screen calcs
local screen_x, screen_y = client.screen_size()
local center_x, center_y = screen_x / 2, screen_y / 2

configs.code = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

configs.encode = function(data)
    return ((data:gsub('.', function(x) 
        local r, b='', x:byte()
        for i = 8, 1, -1 do r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r;
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0) end
        return configs.code:sub(c + 1, c + 1)
    end) .. ( { '', '==', '=' } )[ #data % 3 + 1 ])
end

configs.decode = function(data)
    data = string.gsub(data, '[^' .. configs.code .. '=]', '')
    return (data:gsub( '.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (configs.code:find(x) - 1)
        for i = 6, 1, -1 do r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0) end
        return string.char(c)
    end) )
end

-- Menu colours
local gradients = {
	default = "\ac8c8c8ff",
	purple_1 = "\ab8dbffff",
	purple_2 = "\ab8d7ffff",
	purple_3 = "\ab8d0ffff",
	purple_4 = "\ab8c7ffff",
	purple_5 = "\ab8bfffff",
	purple_6 = "\abab8ffff",
	purple_7 = "\ac0b8ffff", 
	purple_8 = "\ac6b8ffff",
	purple_9 = "\accb8ffff",
	light_purple = "\ad4d4ffff",
	gold = "\aa9a95eff",
}

-- Menu features listed here
local menu = {
	main = {
		main_spacer = ui.new_label("AA", "Anti-aimbot angles", " "),
        main_user = ui.new_label("AA", "Anti-aimbot angles", "~ Welcome " ..gradients.purple_1 .. user),
		main_build = ui.new_label("AA", "Anti-aimbot angles", "~ Build " ..gradients.purple_1 .. build),
		main_spacer2 = ui.new_label("AA", "Anti-aimbot angles", " "),
    },
    main_menu = {
        lua_tab = ui.new_combobox ("AA", "Anti-aimbot angles", "[ " ..gradients.purple_1.. "M" ..gradients.purple_2.. "e" ..gradients.purple_3.. "n" ..gradients.purple_4.. "u " ..gradients.default.. "]", "Antiaim", "Visuals", "Misc"),
    },
    anti_aim = {
		enabled = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " ..gradients.purple_1.. "p" ..gradients.purple_2.. "o" ..gradients.purple_3.. "i" ..gradients.purple_4.. "s" ..gradients.purple_5.. "o" ..gradients.purple_6.. "n" ..gradients.default.. ".tech"),
		aa_type = ui.new_combobox("AA", "Anti-aimbot angles", "Anti-aim " ..gradients.purple_1.. "m" ..gradients.purple_2.. "o" ..gradients.purple_3.. "d" ..gradients.purple_4.. "e", "Preset", "Builder"),
		anti_aim_extras = ui.new_multiselect("AA", "Anti-aimbot angles", "Anti-aim " ..gradients.purple_1.. "e" ..gradients.purple_2.. "x" ..gradients.purple_3.. "t" ..gradients.purple_4.. "r" ..gradients.purple_5.. "a" ..gradients.purple_6.. "s", "Freestand", "Manual AA"),
		freestand = ui.new_hotkey("AA", "Anti-aimbot angles", "	    ~ Free" ..gradients.purple_1.. "s" ..gradients.purple_2.. "t" ..gradients.purple_3.. "a" ..gradients.purple_4.. "n" ..gradients.purple_5.. "d"),

		disable_freestand = ui.new_multiselect("AA", "Anti-aimbot angles", "Freestand " ..gradients.purple_1.. "d" ..gradients.purple_2.. "i" ..gradients.purple_3.. "s" ..gradients.purple_4.. "a" ..gradients.purple_5.. "b" ..gradients.purple_6.. "l" ..gradients.purple_7.. "e" ..gradients.purple_8.. "r" ..gradients.purple_9.. "s", "Standing", "Moving", "Jumping", "Crouching", "Slow motion"),

		manual_back = ui.new_hotkey("AA", "Anti-aimbot angles", "	    ~ Manual " ..gradients.purple_1.. "b" ..gradients.purple_2.. "a" ..gradients.purple_3.. "c" ..gradients.purple_4.. "k"),
		manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "	    ~ Manual " ..gradients.purple_1.. "l" ..gradients.purple_2.. "e" ..gradients.purple_3.. "f" ..gradients.purple_4.. "t"),
		manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "	    ~ Manual " ..gradients.purple_1.. "r" ..gradients.purple_2.. "i" ..gradients.purple_3.. "g" ..gradients.purple_4.. "h" ..gradients.purple_4.. "t"),
		anti_aim_settings = ui.new_label("AA", "Anti-aimbot angles", "[ " ..gradients.purple_1.. "C" ..gradients.purple_2.. "o" ..gradients.purple_3.. "n" ..gradients.purple_4.. "f" ..gradients.purple_5.. "i" ..gradients.purple_6.. "g" ..gradients.default.. " ]"),
		yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", gradients.purple_1.. "Y" ..gradients.purple_2.. "a" ..gradients.purple_3.. "w" ..gradients.light_purple.. " base", "Local view", "At targets"),

		hide_builder = ui.new_checkbox("AA", "Anti-aimbot angles", "Hide "..gradients.purple_1.. "b" ..gradients.purple_2.. "u" ..gradients.purple_3.. "i" ..gradients.purple_4.. "l" ..gradients.purple_5.. "d" ..gradients.purple_6.. "e" ..gradients.purple_6.. "r"),
    },
	presets = {
		preset_type = ui.new_combobox("AA", "Anti-aimbot angles", gradients.purple_1.. "P" ..gradients.purple_2.. "r" ..gradients.purple_3.. "e" ..gradients.purple_4.. "s" ..gradients.purple_5.. "e" ..gradients.purple_6.. "t", "Off", "Smart", "Dynamic"),
	},
	custom = {
		custom_state = ui.new_combobox("AA", "Anti-aimbot angles", "Player state", p_states),
	},
    visuals = {
        vis_color = ui.new_label("AA", "Anti-aimbot angles", "Visual " ..gradients.purple_1.. "c" ..gradients.purple_2.. "o" ..gradients.purple_3.. "l" ..gradients.purple_4.. "o" ..gradients.purple_5.. "r" ..gradients.default.. " accent"),
        visuals_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Visual accent", 255, 255, 255, 255, true),
		poison_ui = ui.new_multiselect("AA", "Anti-aimbot angles", "Poison " ..gradients.purple_3.. "U" ..gradients.purple_4.. "I", "Indicators", "Watermark", "Hit / Miss Logs"),
		visual_indicator = ui.new_label("AA", "Anti-aimbot angles" ,gradients.purple_1.. "I" ..gradients.purple_2.. "n" ..gradients.purple_3.. "d" ..gradients.purple_4.. "i" ..gradients.purple_5.. "c" ..gradients.purple_6.. "a" ..gradients.purple_7.. "t" ..gradients.purple_8.. "o" ..gradients.purple_9.. "rs"),
		indicator_style = ui.new_combobox("AA", "Anti-aimbot angles", "Styles", "Style #1" , "Style #2" , "Style #3", "Style #4"),
		visual_watermark = ui.new_label("AA", "Anti-aimbot angles", gradients.purple_1.. "W" ..gradients.purple_2.. "a" ..gradients.purple_3.. "t" ..gradients.purple_4.. "e" ..gradients.purple_5.. "r"..gradients.purple_6.. "m" ..gradients.purple_7.. "a" ..gradients.purple_8.. "r" ..gradients.purple_9.. "k"),
		watermark_rounding = ui.new_slider("AA", "Anti-aimbot angles" , "Watermark " ..gradients.purple_1.. "r" ..gradients.purple_2.. "o" ..gradients.purple_3.. "u" ..gradients.purple_4.. "n" ..gradients.purple_5.. "d"..gradients.purple_6.."i" ..gradients.purple_7.. "n" ..gradients.purple_8.. "g", 0, 7, 4),
		visual_log = ui.new_label("AA", "Anti-aimbot angles", gradients.purple_1.. "H" ..gradients.purple_2.. "i" ..gradients.purple_3.. "t " ..gradients.purple_4.. "l" ..gradients.purple_5.. "o"..gradients.purple_6.. "g"),
		hit_color = ui.new_label("AA", "Anti-aimbot angles", ">> Hit " ..gradients.purple_1.. "c" ..gradients.purple_2.. "o" ..gradients.purple_3.. "l" ..gradients.purple_4.. "o" ..gradients.purple_5.. "r" ..gradients.default.. " accent"),
		hit_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Log hit accent", 138, 230, 133, 255, true),
		miss_color = ui.new_label("AA", "Anti-aimbot angles", ">> Miss " ..gradients.purple_1.. "c" ..gradients.purple_2.. "o" ..gradients.purple_3.. "l" ..gradients.purple_4.. "o" ..gradients.purple_5.. "r" ..gradients.default.. " accent"),
		miss_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "Log miss accent", 230, 133, 133, 255, true),
    },
	misc = {
		improved_os = ui.new_checkbox("AA", "Anti-aimbot angles", "Improved " ..gradients.purple_1.. "h" ..gradients.purple_2.. "i" ..gradients.purple_3.. "d" ..gradients.purple_4.. "e" ..gradients.purple_5.. "s"..gradients.purple_6.. "h" ..gradients.purple_7.. "o" ..gradients.purple_8.. "t" ..gradients.purple_9.. "s"), 
		leg_break = ui.new_checkbox("AA", "Anti-aimbot angles", "Leg " ..gradients.purple_1.. "b" ..gradients.purple_2.. "r" ..gradients.purple_3.. "e" ..gradients.purple_4.. "a" ..gradients.purple_5.. "k"..gradients.purple_6.. "e" ..gradients.purple_7.. "r"),
		killsay = ui.new_checkbox("AA", "Anti-aimbot angles", "Poison " ..gradients.purple_1.. "k" ..gradients.purple_2.. "i" ..gradients.purple_3.. "l" ..gradients.purple_4.. "l" ..gradients.purple_5.. "s"..gradients.purple_6.. "a" ..gradients.purple_7.. "y"),
		clantag = ui.new_checkbox("AA", "Anti-aimbot angles", "Poison " ..gradients.purple_1.. "c" ..gradients.purple_2.. "l" ..gradients.purple_3.. "a" ..gradients.purple_4.. "n" ..gradients.purple_5.. "t"..gradients.purple_6.. "a" ..gradients.purple_7.. "g"),
		improved_dt = ui.new_combobox("AA", "Anti-aimbot angles", "Adaptive " ..gradients.purple_1.. "d" ..gradients.purple_1.. "o" ..gradients.purple_2.. "u" ..gradients.purple_3.. "b" ..gradients.purple_4.. "l" ..gradients.purple_5.. "e" ..gradients.purple_6.. "t" ..gradients.purple_7.. "a" ..gradients.purple_9.. "p", "Default", "Fast", "" ..gradients.purple_5.. "M" ..gradients.purple_7.. "a" ..gradients.purple_9.. "x"),
	},
	fakelag = {
		fl_os = ui.new_slider("AA", "Fake lag", "Limit", 1, 15, 1),
	},
}


for i=1, #p_states do
	custom[i] = {
		b_enable = ui.new_checkbox("AA", "Anti-aimbot angles", "Enable " ..string.lower(p_states[i]).. " state"),
		b_pitch = ui.new_combobox("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " pitch", {"Off", "Up", "Down", "Random"}),
		b_yaw_base = ui.new_combobox("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " yaw base", {"Local view", "At targets"}),
		b_yaw = ui.new_combobox("AA", "Anti-aimbot angles", gradients.light_purple.. p_states[i] .. gradients.default.. "  yaw", "Off", "180"),
		b_yaw_amount_left = ui.new_slider("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " left side yaw amount", -180, 180, 0, true, "°"),
		b_yaw_amount_right = ui.new_slider("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " right side yaw amount", -180, 180, 0, true, "°"),
		b_jitter_type = ui.new_combobox("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " jitter mode", {"Off", "Center", "Offset", "Random"}),
		b_jitter_amount = ui.new_slider("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " jitter amount", 1, 120, 1, true, "°"),
		b_body_yaw = ui.new_combobox("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] ..gradients.default.. " body yaw", {"Off", "Static", "Jitter"}),
		b_fake_amount = ui.new_slider("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " fake yaw amount", 0, 60, 0, true, "°"),
		b_roll_amount = ui.new_slider("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " roll amount", -50, 50, 0, true, "°"),
		b_roll_key = ui.new_hotkey("AA", "Anti-aimbot angles", gradients.light_purple..  p_states[i] .. gradients.default.. " force roll key"),
	}
end

config_system = {
	export = ui.new_button("AA", "Anti-aimbot angles", "Export",function()
		local settings = {}
		for item, value in pairs(custom) do
			for k,v in pairs(value) do 
				settings[k..item] = {k,ui.get(custom[item][k]),item} 
				
			end
		end
		clipboard.set(configs.encode(json.stringify(settings)))
	end),
	import = ui.new_button("AA", "Anti-aimbot angles", "Import",function()
		local data = json.parse(configs.decode(clipboard.get()))
		for item, value in pairs(data) do
			if not string.find(item,"key") then
			ui.set(custom[value[3]][value[1]],value[2])	
			
			end
		end		
	end)
}

-- Add references here according to path
local references = {
    anti_aim = {
        enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
        pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
        yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
        fakeyawlimit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
        freestandingbodyyaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
        edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
        roll = ui.reference("AA", "Anti-aimbot angles", "Roll")
    },
    rage = {
        doubletap = {ui.reference("Rage", "Other", "Double tap")},
        dtmode = ui.reference("Rage", "Other", "Double tap mode"),
        prefer = ui.reference("Rage", "Aimbot", "Prefer safe point"),
        safepoint = ui.reference("Rage", "Aimbot", "Force safe point"),
        baim = ui.reference("Rage", "Other", "Force body aim"),
        dtlimit = ui.reference("Rage", "Other", "Double tap fake lag limit"),
        quickpeek = {ui.reference("Rage", "Other", "Quick peek assist")},
        fakeducking = ui.reference("Rage", "Other", "Duck peek assist"),
    },
	other = {
		leg_movement = ui.reference("AA", "Other", "Leg movement"),
		onshot = {ui.reference("AA", "Other", "On shot anti-aim")},
		slowwalk = {ui.reference("AA", "Other", "Slow motion")},
	},
    fake_lag = {
        enabled = ui.reference("AA", "Fake lag", "Enabled"),
        limit = ui.reference("AA", "Fake lag", "Limit")
    },
	misc = {
		maxusrcmdprocessticks = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	},
}

-- Weird visible loop fix thing (?)
references.anti_aim.yaw, references.anti_aim.yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
references.anti_aim.bodyyaw, references.anti_aim.bodyyaw_slider = ui.reference("AA", "Anti-aimbot angles", "Body yaw")
references.anti_aim.jitter, references.anti_aim.jitter_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")
references.anti_aim.freestand, references.anti_aim.freestand_key = ui.reference("AA", "Anti-aimbot angles", "Freestanding", "Default")

-- Window functions
local rounding = 2
local o = 10
local rad = rounding + 2
local gap = 1

local RoundedRect = function(x, y, w, h, radius, r, g, b, a)
	renderer.rectangle(x + radius, y, w - radius * 2, radius, r, g, b, a)
	renderer.rectangle(x, y + radius, radius, h - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius, y + h - radius, w - radius * 2, radius, r, g, b, a)
	renderer.rectangle(x + w - radius, y + radius, radius, h - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius, y + radius, w - radius * 2, h - radius * 2, r, g, b, a)
	renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
	renderer.circle(x + w - radius, y + radius, r, g, b, a, radius, 90, 0.25)
	renderer.circle(x + radius, y + h - radius, r, g, b, a, radius, 270, 0.25)
	renderer.circle(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25)
end
local OutlineGlow = function(x, y, w, h, radius, r, g, b, a)
	renderer.rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
	renderer.rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
	renderer.rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
	renderer.circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
	renderer.circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
	renderer.circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
	renderer.circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
end
local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
	renderer.rectangle(x + radius, y, w - radius * 2, 1, r, g, b, 255)
	renderer.circle_outline(x + radius, y + radius, r, g, b, 255, radius, 180, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + radius, r, g, b, 255, radius, 270, 0.25, 1)
	renderer.gradient(x, y + radius, 1, h - radius * 2, r, g, b, 255, r, g, b, 45, false)
	renderer.gradient(x + w - 1, y + radius, 1, h - radius * 2, r, g, b, 255, r, g, b, 45, false)
	renderer.circle_outline(x + radius, y + h - radius, r, g, b, 45, radius, 90, 0.25, 1)
	renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, 45, radius, 0, 0.25, 1)
	renderer.rectangle(x + radius, y + h - 1, w - radius * 2, 1, r, g, b, 45)
	for radius = 4, glow do
		local radius = radius / 2
		OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r1, g1, b1, glow - radius * 2)
	end
end
local FadedRoundedGlowEdge = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
	renderer.circle_outline(x + radius, y + radius +  r, g, b, 255, radius, 180, 0.25, 2)
	renderer.gradient(x + radius + y + 30, 2, r, g, b, 255, r, g, b, 0, true)
	renderer.gradient(x +  y + radius + 2, 15, r, g, b, 255, r, g, b, 0, false)

	renderer.circle_outline(x + w - radius - y + h - radius - r, g, b, 255, radius, 0, 0.25, 2)
	renderer.gradient(x + w - 2 - y + radius - gap + 8, 2, h - radius * 2 - 8, r, g, b, 45, r, g, b, 255, false)
	renderer.gradient(x + radius - y + h - gap - 2, w - radius * 2 , 2, r, g, b, 45, r, g, b, 255, true)
end

local tools = {
    animation = function(check, name, stop, speed)
        if check then
            return name + (stop - name) * globals.frametime() * speed
        else
            return name - (stop + name) * globals.frametime() * speed
        end
    end,
    lerp = function(check, stop, speed)
        return check + (stop - check) * globals.frametime() * speed
    end,
    rgb_to_hex = function(r, g, b)
        r = tostring(r);g = tostring(g);b = tostring(b)
        r = (r:len() == 1) and '0'..r or r;g = (g:len() == 1) and '0'..g or g;b = (b:len() == 1) and '0'..b or b
    
        local rgb = (r * 0x10000) + (g * 0x100) + b
        return (r == '00' and g == '00' and b == '00') and '000000' or string.format('%x', rgb)
    end,
    table_contains = function(tabel, value)
        for i=1, #tabel do
            if tabel[i] == value then
                return true
            end
        end
        return false
    end,
}

local last_press = 0
local yaw_slider = 0

local anti_aim = {
	run = function(cmd)
		local enabled = ui.get(menu.anti_aim.enabled)
		ui.set(references.anti_aim.enabled, enabled)

		local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1) == 1 and cmd.in_jump == 0
		local speed = vector(entity.get_prop(entity.get_local_player(), "m_vecVelocity")):length2d()
		local duck_amount = entity.get_prop(entity.get_local_player(), "m_flDuckAmount")

		local body_yaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
		local yaw_side = body_yaw > 0 and 1 or -1
		local choked = (cmd.chokedcommands == 0)
	
		local slow_walk = ui.get(references.other.slowwalk[1]) and ui.get(references.other.slowwalk[2])
		local doubletap = ui.get(references.rage.doubletap[1] and references.rage.doubletap[2])
		local onshot = ui.get(references.other.onshot[1] and references.other.onshot[2])
		local fakeduck = ui.get(references.rage.fakeducking)
		local freestand = ui.get(menu.anti_aim.freestand)
		local fakelag = ui.get(menu.fakelag.fl_os)

		if slow_walk then
			player_state = "Slow motion"
		elseif not on_ground and duck_amount > 0.6 then
			player_state = "Duck jumping"
		elseif not on_ground then
			player_state = "Jumping"
		elseif duck_amount > 0.6 then
			player_state = "Crouching"
		elseif speed > 2 then
			player_state = "Moving"
		elseif speed < 2 then
			player_state = "Standing"
		end

		ui.set(references.fake_lag.limit, fakelag)
	
		ui.set(references.anti_aim.freestand, freestand and "Default" or "-")
		ui.set(references.anti_aim.freestand_key, "Always on")
		
		if tools.table_contains(ui.get(menu.anti_aim.disable_freestand), "Standing") and player_state == "Standing" then
			ui.set(references.anti_aim.freestand, "-")
		elseif tools.table_contains(ui.get(menu.anti_aim.disable_freestand), "Moving") and player_state == "Moving" then
			ui.set(references.anti_aim.freestand, "-")
		elseif tools.table_contains(ui.get(menu.anti_aim.disable_freestand), "Jumping") and player_state == "Jumping" then
			ui.set(references.anti_aim.freestand, "-")
		elseif tools.table_contains(ui.get(menu.anti_aim.disable_freestand), "Crouching") and player_state == "Crouching" then
			ui.set(references.anti_aim.freestand, "-")
		elseif tools.table_contains(ui.get(menu.anti_aim.disable_freestand), "Slow motion") and player_state == "Slow motion" then
			ui.set(references.anti_aim.freestand, "-")
		end

		state_switch = p_states_num[player_state]
	
		if ui.get(menu.anti_aim.aa_type) == "Builder" then
			state_switch = p_states_num[player_state]
			if ui.get(custom[state_switch].b_enable) then
				ui.set(references.anti_aim.pitch, ui.get(custom[state_switch].b_pitch))
				ui.set(references.anti_aim.yawbase, ui.get(custom[state_switch].b_yaw_base))
				ui.set(references.anti_aim.yaw, ui.get(custom[state_switch].b_yaw))
				if cmd.chokedcommands ~= 0 then
				else
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and ui.get(custom[state_switch].b_yaw_amount_left) or ui.get(custom[state_switch].b_yaw_amount_right)))
				end
				ui.set(references.anti_aim.jitter, ui.get(custom[state_switch].b_jitter_type))
				ui.set(references.anti_aim.jitter_slider, ui.get(custom[state_switch].b_jitter_amount))
				ui.set(references.anti_aim.bodyyaw, ui.get(custom[state_switch].b_body_yaw))
				ui.set(references.anti_aim.fakeyawlimit, ui.get(custom[state_switch].b_fake_amount))
				ui.set(references.anti_aim.roll, ui.get(custom[state_switch].b_roll_amount))
			else
				ui.set(references.anti_aim.pitch, ui.get(custom[1].b_pitch))
				ui.set(references.anti_aim.yawbase, ui.get(custom[1].b_yaw_base))
				ui.set(references.anti_aim.yaw, ui.get(custom[1].b_yaw))
				if cmd.chokedcommands ~= 0 then
				else
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and ui.get(custom[1].b_yaw_amount_left) or ui.get(custom[1].b_yaw_amount_right)))
				end
				ui.set(references.anti_aim.jitter, ui.get(custom[1].b_jitter_type))
				ui.set(references.anti_aim.jitter_slider, ui.get(custom[1].b_jitter_amount))
				ui.set(references.anti_aim.bodyyaw, ui.get(custom[1].b_body_yaw))
				ui.set(references.anti_aim.fakeyawlimit, ui.get(custom[1].b_fake_amount))
				ui.set(references.anti_aim.roll, ui.get(custom[1].b_roll_amount))
			end
		end
	
		if ui.get(menu.anti_aim.aa_type) == "Preset" then

			if ui.get(menu.presets.preset_type) == "Off" then
				ui.set(references.anti_aim.pitch, "Off")
				ui.set(references.anti_aim.yaw, "Off")
				ui.set(references.anti_aim.yawbase, "Local view")
				ui.set(references.anti_aim.yaw_slider, 0)
				ui.set(references.anti_aim.jitter, "Off")
				ui.set(references.anti_aim.bodyyaw, "Off")
				ui.set(references.anti_aim.fakeyawlimit, 0)
				ui.set(references.anti_aim.roll, 0)
			end

			-- Presets
			if ui.get(menu.presets.preset_type) == "Smart" then
				ui.set(references.anti_aim.pitch, "Down")
				ui.set(references.anti_aim.yawbase, ui.get(menu.anti_aim.yaw_base))
				ui.set(references.anti_aim.yaw, "180")
				if player_state == "Standing" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -9 or 14))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 69)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Moving" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -3 or 8))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 57)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Jumping" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and 0 or 0))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 5)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Duck jumping" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and 0 or 0))
					ui.set(references.anti_aim.jitter, "Random")
					ui.set(references.anti_aim.jitter_slider, -21)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Slow motion" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and 1 or 0))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 82)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Crouching" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -7 or 11))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 50)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				end
			end

			if ui.get(menu.presets.preset_type) == "Dynamic" then
				ui.set(references.anti_aim.pitch, "Down")
				ui.set(references.anti_aim.yawbase, ui.get(menu.anti_aim.yaw_base))
				ui.set(references.anti_aim.yaw, "180")
				if player_state == "Standing" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -9 or 14))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 69)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 57)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Moving" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -25 or 23))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 31)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 48)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Jumping" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -11 or 14))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 44)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 59)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Duck jumping" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -14 or 17))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 35)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 59)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Slow motion" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -18 or 21))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 33)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 59)
					ui.set(references.anti_aim.roll, 0)
				elseif player_state == "Crouching" then
					ui.set(references.anti_aim.pitch, "Down")
					ui.set(references.anti_aim.yawbase, "At targets")
					ui.set(references.anti_aim.yaw_slider, 0)
					ui.set(references.anti_aim.yaw_slider, (yaw_side == 1 and -11 or 14))
					ui.set(references.anti_aim.jitter, "Center")
					ui.set(references.anti_aim.jitter_slider, 45)
					ui.set(references.anti_aim.bodyyaw, "Jitter")
					ui.set(references.anti_aim.fakeyawlimit, 59)
					ui.set(references.anti_aim.roll, 0)
				end
			end
		end
		
		if ui.get(menu.misc.improved_os) then
			if onshot and not doubletap and not fakeduck then
				ui.set(references.fake_lag.limit, 3)
			end
		end
	
		if ui.get(menu.misc.improved_dt) == "Default" then
			ui.set(references.misc.maxusrcmdprocessticks, 16)
		elseif ui.get(menu.misc.improved_dt) == "Fast" then
			ui.set(references.misc.maxusrcmdprocessticks, 18)
		elseif ui.get(menu.misc.improved_dt) == "Max" then
			ui.set(references.misc.maxusrcmdprocessticks, 19)
		end
	end,
	leg_break = function()
		if ui.get(menu.misc.leg_break) then
			local num = math.random(1, 3)
			if num > 1 then
				ui.set( references.other.leg_movement, "Always slide" )
			else
				ui.set( references.other.leg_movement, "Never slide" )
			end

			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 8, 0)
		end
	end,
	manual_aa = function(cmd)
		local freestand = ui.get(menu.anti_aim.freestand)

		ui.set(menu.anti_aim.manual_back, "On hotkey")
		ui.set(menu.anti_aim.manual_left, "On hotkey")
		ui.set(menu.anti_aim.manual_right, "On hotkey")


		if ui.get(menu.anti_aim.freestand) then
			return
		else
			if ui.get(menu.anti_aim.manual_back) and last_press + 0.2 < globals.curtime() then
				yaw_slider = 0
				last_press = globals.curtime()
			elseif ui.get(menu.anti_aim.manual_left) and last_press + 0.2 < globals.curtime() then
				yaw_slider = yaw_slider == -90 and 0 or -90
				last_press = globals.curtime()
			elseif ui.get(menu.anti_aim.manual_right) and last_press + 0.2 < globals.curtime() then
				yaw_slider = yaw_slider == 90 and 0 or 90
				last_press = globals.curtime()
			elseif last_press > globals.curtime() then
				last_press = globals.curtime()
			end
		end
		if yaw_slider ~= 0 then
			ui.set(references.anti_aim.yaw_slider, yaw_slider)
		end
	end
}

local visual_data = {
    cross_x = 0,
    anim_dt = 0,
	anim_os = 0,
	anim_fs = 0,
	anim_ba = 0,
    anim_menu = 0,
    anim_line = 0,
    alpha_dt = 0,
    alpha_os = 0,
    alpha_fs = 0,
    alpha_sp = 0,
    alpha_baim = 0,
    alpha_water = 0,
    spacer_dt = 0,
    smooth_bar = 0,
	arrows = {
		left = 0,
		right = 0
	}
}

local visuals = {
	indicators = function()
        local r, g, b, a = ui.get(menu.visuals.visuals_clr)
        local hexclr = "\a"..tools.rgb_to_hex(r, g, b).."FF"

		local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 3) * 4) * 125 + 200), 225)

        --local body_yaw_pose_param = math.floor(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120) - 60
        --local body_yaw_perc = body_yaw_pose_param / 60
        --local body_width = math.abs(50 * body_yaw_perc)

		local freestand = ui.get(menu.anti_aim.freestand)
		local doubletap = ui.get(references.rage.doubletap[1]) and ui.get(references.rage.doubletap[2])
		local onshot = ui.get(references.other.onshot[1]) and ui.get(references.other.onshot[2])
		local baim = ui.get(references.rage.baim)

        if (ui.get(menu.visuals.indicator_style) == "Style #1" and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators")) then
            visual_data.alpha_dt = doubletap and tools.lerp(visual_data.alpha_dt, 255, 22) or tools.lerp(visual_data.alpha_dt, 0, 30)
            visual_data.alpha_os = onshot and tools.lerp(visual_data.alpha_os, 255, 20) or tools.lerp(visual_data.alpha_os, 100, 15)
            visual_data.alpha_fs = freestand and tools.lerp(visual_data.alpha_fs, 255, 15) or tools.lerp(visual_data.alpha_fs, 100, 15)
            visual_data.alpha_sp = ui.get(references.rage.safepoint) and tools.lerp(visual_data.alpha_sp, 255, 20) or tools.lerp(visual_data.alpha_sp, 100, 15)
            visual_data.alpha_baim = baim and tools.lerp(visual_data.alpha_baim, 255, 20) or tools.lerp(visual_data.alpha_baim, 100, 15)

            visual_data.anim_dt = tools.animation(doubletap, visual_data.anim_dt, 4, 15)     

            if visual_data.anim_dt > 3.9 then
                visual_data.anim_dt = 4
            end

            if antiaim_funcs.get_double_tap() then
                charge_colour1, charge_colour2, charge_colour3 = 109, 156, 90
            else
                charge_colour1, charge_colour2, charge_colour3 = 186, 102, 102
            end

            renderer.text(center_x - 8, center_y + 41, r, g, b, 255, "c-", "nil", "POISON")
            renderer.text(center_x + 14, center_y + 41, 200, 200, 200, alpha_pulse, "c-", "nil", build:upper())
            renderer.text(center_x, center_y + 50, r, g, b, 255, "c-", "nil", string.upper(player_state))
            renderer.text(center_x, center_y + 55 + visual_data.anim_dt, charge_colour1, charge_colour2, charge_colour3, visual_data.alpha_dt, "c-", "nil", "DT")
            renderer.text(center_x - 17, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_baim, "c-", "nil", "BAIM")
            renderer.text(center_x - 1, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_os, "c-", "nil", "OS")
            renderer.text(center_x + 10, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_fs, "c-", "nil", "FS")
            renderer.text(center_x + 22, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_sp, "c-", "nil", "SP")
        end

		if (ui.get(menu.visuals.indicator_style) == "Style #2" and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators")) then
            visual_data.alpha_dt = doubletap and tools.lerp(visual_data.alpha_dt, 255, 20) or tools.lerp(visual_data.alpha_dt, 0, 30)
            visual_data.alpha_os = onshot and tools.lerp(visual_data.alpha_os, 255, 20) or tools.lerp(visual_data.alpha_os, 0, 30)
            visual_data.alpha_fs = freestand and tools.lerp(visual_data.alpha_fs, 255, 20) or tools.lerp(visual_data.alpha_fs, 0, 30)
            visual_data.alpha_baim = baim and tools.lerp(visual_data.alpha_baim, 255, 20) or tools.lerp(visual_data.alpha_baim, 0, 30)

            visual_data.anim_fs = tools.animation(freestand, visual_data.anim_fs, 4, 20)
            visual_data.anim_dt = tools.animation(doubletap, visual_data.anim_dt, 4, 20)
            visual_data.anim_os = tools.animation(onshot, visual_data.anim_os, 4, 20)
            visual_data.anim_ba = tools.animation(baim, visual_data.anim_ba, 4, 20)

			if visual_data.anim_fs > 3.9 then
                visual_data.anim_fs = 4
            end

            if visual_data.anim_dt > 3.9 then
                visual_data.anim_dt = 4
            end

            if visual_data.anim_os > 3.9 then
                visual_data.anim_os = 4
            end

            if visual_data.anim_ba > 3.9 then
                visual_data.anim_ba = 4
            end

            if antiaim_funcs.get_double_tap() then
                charge_colour1, charge_colour2, charge_colour3 = 109, 156, 90
            else
                charge_colour1, charge_colour2, charge_colour3 = 186, 102, 102
            end

            renderer.text(center_x + 2, center_y + 19, 255, 255, 255, 255, "-", "nil", "POISON")
            renderer.text(center_x + 30, center_y + 19, r, g, b, alpha_pulse, "-", "nil", build:upper())
			
			local main_width = renderer.measure_text("-", "POISON")
			local build_width = renderer.measure_text("-", build:upper())

			local body_yaw_pose_param = math.floor(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120) - 60
        	local body_yaw_perc = body_yaw_pose_param / 60

            renderer.rectangle(center_x + 3, center_y + 30, main_width + build_width +2, 5, 0, 0, 0, 255, true)
            renderer.gradient(center_x + 4, center_y + 31, math.abs((main_width + build_width +1) * body_yaw_perc), 3, r, g, b, 255, r, g, b, 40, true)

            renderer.text(center_x + 2, center_y + 31 + visual_data.anim_fs, 255, 255, 255, visual_data.alpha_fs, "-", "nil", "FREESTAND")
            renderer.text(center_x + 2, center_y + 35 + visual_data.anim_dt + visual_data.anim_fs, 255, 255, 255, visual_data.alpha_dt, "-", "nil", "DOUBLETAP")
            renderer.text(center_x + 2, center_y + 39 + visual_data.anim_os + visual_data.anim_dt + visual_data.anim_fs, 255, 255, 255, visual_data.alpha_os, "-", "nil", "ONSHOT")
            renderer.text(center_x + 2, center_y + 43 + visual_data.anim_ba + visual_data.anim_os + visual_data.anim_dt + visual_data.anim_fs, 255, 255, 255, visual_data.alpha_baim, "-", "nil", "BAIM")
        end

		if (ui.get(menu.visuals.indicator_style) == "Style #3" and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators")) then
			local exploit = doubletap or onshot
			visual_data.alpha_dt = exploit and tools.lerp(visual_data.alpha_dt, 255, 22) or tools.lerp(visual_data.alpha_dt, 0, 30)
            visual_data.anim_dt = tools.animation(doubletap or onshot, visual_data.anim_dt, 4, 15)     

            if visual_data.anim_dt > 3.9 then
                visual_data.anim_dt = 4
            end

			exploit = " "

			if doubletap then
				if antiaim_funcs.get_double_tap() then
					charge_colour1, charge_colour2, charge_colour3 = 109, 156, 90
					exploit = "DT"
				else
					charge_colour1, charge_colour2, charge_colour3 = 186, 102, 102
					exploit = "DT"
				end
			elseif onshot then
				exploit = "ONSHOT"
				charge_colour1, charge_colour2, charge_colour3 = 240, 139, 139
			end

            renderer.text(center_x - 8, center_y + 41, r, g, b, 255, "c-", "nil", "POISON")
            renderer.text(center_x + 14, center_y + 41, 200, 200, 200, alpha_pulse, "c-", "nil", build:upper())
            renderer.text(center_x, center_y + 51, 200, 200, 200, 255, "c-", "nil", string.upper(player_state))
            renderer.text(center_x, center_y + 57 + visual_data.anim_dt, charge_colour1, charge_colour2, charge_colour3, visual_data.alpha_dt, "c-", "nil", exploit)
		end

		if (ui.get(menu.visuals.indicator_style) == "Style #4" and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators")) then
			visual_data.alpha_dt = doubletap and tools.lerp(visual_data.alpha_dt, 255, 22) or tools.lerp(visual_data.alpha_dt, 0, 30)
            visual_data.alpha_os = onshot and tools.lerp(visual_data.alpha_os, 255, 20) or tools.lerp(visual_data.alpha_os, 100, 15)
            visual_data.alpha_fs = freestand and tools.lerp(visual_data.alpha_fs, 255, 15) or tools.lerp(visual_data.alpha_fs, 100, 15)
            visual_data.alpha_sp = ui.get(references.rage.safepoint) and tools.lerp(visual_data.alpha_sp, 255, 20) or tools.lerp(visual_data.alpha_sp, 100, 15)
            visual_data.alpha_baim = baim and tools.lerp(visual_data.alpha_baim, 255, 20) or tools.lerp(visual_data.alpha_baim, 100, 15)

            visual_data.anim_dt = tools.animation(doubletap, visual_data.anim_dt, 4, 15)     

            if visual_data.anim_dt > 3.9 then
                visual_data.anim_dt = 4
            end

            if antiaim_funcs.get_double_tap() then
                charge_colour1, charge_colour2, charge_colour3 = 109, 156, 90
            else
                charge_colour1, charge_colour2, charge_colour3 = 186, 102, 102
            end

            renderer.text(center_x + 15, center_y + 41, r, g, b, 255, "c-", "nil", "POISON")
            renderer.text(center_x + 37, center_y + 41, 200, 200, 200, alpha_pulse, "c-", "nil", build:upper())
			renderer.text(center_x + 2, center_y + 45, 255, 255, 255, 255, "-", "nil", string.upper(player_state))
            renderer.text(center_x + 6, center_y + 55 + visual_data.anim_dt, charge_colour1, charge_colour2, charge_colour3, visual_data.alpha_dt, "c-", "nil", "DT")
            renderer.text(center_x + 11, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_baim, "c-", "nil", "BAIM")
            renderer.text(center_x + 27, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_os, "c-", "nil", "OS")
            renderer.text(center_x + 38, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_fs, "c-", "nil", "FS")
            renderer.text(center_x + 50, center_y + visual_data.anim_dt + 63, 255, 255, 255, visual_data.alpha_sp, "c-", "nil", "SP")
		end
	end,
	watermark = function()

		local rounding = ui.get(menu.visuals.watermark_rounding)

		local window = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn)
			if alpha * 255 > 0 then
				renderer.blur(x, y, w, h)
			end
			RoundedRect(x, y, w, h, rounding, 17, 17, 17, 50)
			FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
			if not fn then
				return
			end
			fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
		end


		

		local r, g, b, a = ui.get(menu.visuals.visuals_clr)
        local hexclr = "\a"..tools.rgb_to_hex(r, g, b).."FF"

		local alpha_pulse = math.min(math.floor(math.sin((globals.realtime() % 3) * 4) * 125 + 200), 255)

		local hours, minutes, seconds = client.system_time()
        local day = client.system_time()
        local delay = math.floor(client.latency() * 1000)

        local water_text = string.format("poi" .. hexclr .."son  \aFFFFFFFF∙  "  ..user..  "  ∙   delay: %d ms  \aFFFFFFFF∙  %02d:%02d:%02d", delay, hours, minutes, seconds)

        local water_text_size = renderer.measure_text(nil, water_text)

        local menu_open = ui.is_menu_open()

        if tools.table_contains(ui.get(menu.visuals.poison_ui), "Watermark") then

			window(screen_x - water_text_size - 21, 10, water_text_size + 12, visual_data.anim_menu + 27, r, g, b, 25, ( alpha_pulse / 220 ) + 0.4, r, g, b)

            renderer.text(screen_x - water_text_size - 15, 12, 255, 255, 255, 255, "", "nil", water_text)

            visual_data.anim_menu = tools.animation(menu_open, visual_data.anim_menu, 8, 10)
            visual_data.alpha_water = menu_open and tools.lerp(visual_data.alpha_water, 255, 1.5) or tools.lerp(visual_data.alpha_water, 0, 35)
			
            renderer.text(screen_x - water_text_size - 15, 27, 255, 255, 255, visual_data.alpha_water, "", "nil", "build")
			renderer.text(screen_x - water_text_size + 12, 27, r, g, b, visual_data.alpha_water, "", "nil", build)
        end
	end,
	manual_arrows = function()
		local r, g, b, a = ui.get(menu.visuals.visuals_clr)
		local speed = 13
		local left_value = yaw_slider == -90 and 1 or 0
		local right_value = yaw_slider == 90 and 1 or 0
		visual_data.arrows.left = tools.lerp(visual_data.arrows.left, left_value, speed)
		visual_data.arrows.right = tools.lerp(visual_data.arrows.right, right_value, speed)
		renderer.text(center_x - 35, center_y - 2, r, g, b, 255 * visual_data.arrows.left, 'c', nil, '❰')
		renderer.text(center_x + 35, center_y - 2, r, g, b, 255 * visual_data.arrows.right, 'c', nil, '❱')

	end
}

-- Notifications
local get_hit_color = function()
	local r, g, b, a = ui.get(menu.visuals.hit_clr)
	return r, g, b, a
end

local get_miss_color = function()
	local r, g, b, a = ui.get(menu.visuals.miss_clr)
	return r, g, b, a
end

local r, g, b, a = get_hit_color()
local noticol = '\a'..tools.rgb_to_hex(r, g, b)..'ff'

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
	local noticol = '\a'..tools.rgb_to_hex(r, g, b)..'ff'
	local white = '\aFFFFFFFF'

	if tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs") then
		table.insert(logs_txt, {		
			text = string.format(white.. 'Hit '..noticol..'%s '..white..'in '..noticol..'%s '..white..'for '..noticol..'%i '..white..'damage ('..noticol..'%i '..white..'remaining)', name, hgroup, e.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke),
			text2 = string.format('Hit %s in %s for %i damage (%i remaining)', name, hgroup, e.damage, health, aimed_hgroup, hitchance, on_fire_data.safe_point, on_fire_data.self_choke, on_fire_data.choke),

			timer = globals.realtime(),
			smooth_y = screen[2] + 100,
			alpha = 0,
			alpha2 = 0,
		
			first_circle = 0,
			second_circle = 0,
		
			box_left = center_x,
			box_right = center_x,
		
			box_left_1 = center_x,
			box_right_1 = center_x
		})
	end
end


local function aim_miss(e)
    
    local on_fire_data = g_aimbot_data[e.id]
    local name = string.lower(entity.get_player_name(e.target))
	local hgroup = hitgroup_names[e.hitgroup + 1] or '?'
    local hitchance = math.floor(on_fire_data.hit_chance + 0.5) .. '%'
    local reason = e.reason == '?' and 'unknown' or e.reason
	
	local r, g, b, a = get_miss_color()
	local noticol = '\a'..tools.rgb_to_hex(r, g, b)..'ff'
	local white = '\aFFFFFFFF'

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

	if tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs") then
		table.insert(logs_txt, {
			
			text = string.format(white.. 'Missed ' ..noticol.. '%s ' ..white.. 'in '..noticol..'%s ' ..white.. 'due to '..noticol..'%s ' ..white.. '('..noticol..'%s '..white..'hitchance)', name, hgroup, e.reason, hitchance),
			text2 = string.format('Missed %s in %s due to %s (%s hitchance)', name, hgroup, e.reason, hitchance),
			timer = globals.realtime(),
			smooth_y = screen[2] + 100,
			alpha = 0,
			alpha2 = 0,
		
			first_circle = 0,
			second_circle = 0,
		
			box_left = center_x,
			box_right = center_x,
		
			box_left_1 = center_x,
			box_right_1 = center_x
		})
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
				table.remove(logs_txt, 1)
			end

			if info.text ~= nil and info.text ~= "" then
				local text_size_x, text_size_y = renderer.measure_text("", info.text)

				if info.timer + 4.8 < globals.realtime() then
					info.smooth_y = y


					info.alpha = easings.lerp(
						info.alpha,
						0,
						globals.frametime() * 10
					)

					info.alpha2 = easings.lerp(
						info.alpha2,
						0,
						globals.frametime() * 1
					)
				else
					info.smooth_y = easings.lerp(
						info.smooth_y,
						y,
						globals.frametime() * 7
					)

					info.alpha = easings.lerp(
						info.alpha,
						255,
						globals.frametime() * 1
					)

					info.alpha2 = easings.lerp(
						info.alpha2,
						125,
						globals.frametime() * 1
					)

				end

				local add_y = math.floor(info.smooth_y)
				local alpha = math.floor(info.alpha)
				local alpha2 = math.floor(info.alpha2)

				local r, g, b, a = ui.get(menu.visuals.visuals_clr)

				--(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)

				--(x, y, w, h, radius, r, g, b, a)
		
				renderer.text(center_x - text_size_x / 2, add_y - 21, 250, 250, 250, alpha, '', 0, info.text)
				time_plus = 4.8
				y = y - 16

				
				if info.timer + time_plus < globals.realtime() then table.remove(logs_txt, i) end
			end
		end
	end
end

local clantags = {
	"  ",
	" | ",
	" P ",
	" O0 ",
	" PO ",
	" PO\\ ",
	" PO\\/ ",
	" POI ",
	" POI5 ",
	" POIS ",
	" POIS| ",
	" POIS|0 ",
	" POISON| ",
	" POISON ",
	" P0I$ON ",
	" poison ",
	" P0I$ON ",
	" POISON ",
	" POISON| ",
	" POIS|0 ",
	" POIS| ",
	" POIS ",
	" POI5 ",
	" POI ",
	" PO\\/ ",
	" PO\\ ",
	" PO ",
	" O0 ",
	" P ",
	" | ",
	"  ",
}

local time = 50

client.set_event_callback("net_update_end", function()
	local cur = math.floor(globals.tickcount() / time) % #clantags
	local clantag = clantags[cur+1]

	if ui.get(menu.misc.clantag) then
		if clantag ~= previous_tag then
			previous_tag = clantag
			client.set_clan_tag(clantag)
		end
	end
end)

ui.set_callback(menu.misc.clantag, function()client.set_clan_tag("\0") end)

function visible(reference, state)
    if type(reference) == "table" then
        for index, value in pairs(reference) do
            if type(value) == "table" then
                for i = 1, #value do
                    ui.set_visible(value[i], state)
                end
            else
                ui.set_visible(value, state)
            end
        end
    else
        ui.set_visible(reference, state)
    end
end

-- Menu functions
local function menu_functions()
    -- Loop through the "references" and set all indexes to not visible (false)
	visible(references.anti_aim, false)

	ui.set_visible(references.fake_lag.limit, false)

	-- Antiaim local menu feature
    local tab_antiaim = ui.get(menu.main_menu.lua_tab) == "Antiaim"
	local preset_antiaim = ui.get(menu.anti_aim.aa_type) == "Preset"
	local custom_antiaim = ui.get(menu.anti_aim.aa_type) == "Builder"

	-- Visuals local menu feature
    local tab_visuals = ui.get(menu.main_menu.lua_tab) == "Visuals"

	-- Misc local menu feature
    local tab_misc = ui.get(menu.main_menu.lua_tab) == "Misc"
	
    -- Show visible on "Visuals" tab#
	visible(menu.visuals, tab_visuals)
	visible(menu.misc, tab_misc) 

    -- Show visibile on "Antiaim" tab
	visible(menu.anti_aim, tab_antiaim)


	ui.set_visible(menu.anti_aim.freestand, tab_antiaim and tools.table_contains(ui.get(menu.anti_aim.anti_aim_extras), "Freestand"))
	ui.set_visible(menu.anti_aim.manual_back, tab_antiaim and tools.table_contains(ui.get(menu.anti_aim.anti_aim_extras), "Manual AA"))
	ui.set_visible(menu.anti_aim.manual_left, tab_antiaim and tools.table_contains(ui.get(menu.anti_aim.anti_aim_extras), "Manual AA"))
	ui.set_visible(menu.anti_aim.manual_right, tab_antiaim and tools.table_contains(ui.get(menu.anti_aim.anti_aim_extras), "Manual AA"))

	ui.set_visible(menu.anti_aim.disable_freestand, tab_antiaim and tools.table_contains(ui.get(menu.anti_aim.anti_aim_extras), "Freestand"))

	-- Antiaim -> Custom
	ui.set_visible(menu.anti_aim.yaw_base, tab_antiaim and not custom_antiaim)
	ui.set_visible(menu.custom.custom_state, tab_antiaim and custom_antiaim and not ui.get(menu.anti_aim.hide_builder))
	ui.set_visible(menu.anti_aim.hide_builder, tab_antiaim and custom_antiaim)

	-- Antiaim -> Presets
	ui.set_visible(menu.presets.preset_type, preset_antiaim and tab_antiaim)

	-- Antiaim -> Custom -> Config
	ui.set_visible(config_system.import, tab_antiaim and custom_antiaim)
	ui.set_visible(config_system.export, tab_antiaim and custom_antiaim)

	-- Visual -> Watermark
	ui.set_visible(menu.visuals.visual_watermark, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Watermark"))
	ui.set_visible(menu.visuals.watermark_rounding, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Watermark"))

	-- Visual -> Indicators
	ui.set_visible(menu.visuals.visual_indicator, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators"))
	ui.set_visible(menu.visuals.indicator_style, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Indicators"))

	-- Visual -> Hit logs
	ui.set_visible(menu.visuals.visual_log, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs"))
	ui.set_visible(menu.visuals.hit_color, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs"))
	ui.set_visible(menu.visuals.miss_color, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs"))
	ui.set_visible(menu.visuals.hit_clr, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs"))
	ui.set_visible(menu.visuals.miss_clr, tab_visuals and tools.table_contains(ui.get(menu.visuals.poison_ui), "Hit / Miss Logs"))

	-- Custom antiaim visibility
	for i=1, #p_states do
		local vis = ui.get(menu.custom.custom_state) == p_states[i] and custom_antiaim and tab_antiaim and not ui.get(menu.anti_aim.hide_builder)
		for k, v in pairs(custom[i]) do
			ui.set_visible(v, vis)
		end

		if not ui.get(custom[i].b_enable) then
			for k, v in pairs(custom[i]) do
				ui.set_visible(v, false)
			end
		end

		ui.set_visible(custom[i].b_enable, vis)
		
		if ui.get(custom[i].b_jitter_type) == "Off" then
			ui.set_visible(custom[i].b_jitter_amount, false)
		end
	end
end



-- Unload functions 
local function unload()
-- Og menu visible on unload
	for k, v in pairs(references.anti_aim) do
		ui.set_visible(v, true)
	end

	ui.set_visible(references.fake_lag.limit, true)

	ui.set(references.misc.maxusrcmdprocessticks, 16)

	-- Reset our anti-aim
	ui.set(references.anti_aim.pitch, "Off")
	ui.set(references.anti_aim.yaw, "Off")
	ui.set(references.anti_aim.yawbase, "Local view")
	ui.set(references.anti_aim.yaw_slider, 0)
	ui.set(references.anti_aim.jitter, "Off")
	ui.set(references.anti_aim.bodyyaw, "Off")
	ui.set(references.anti_aim.fakeyawlimit, 0)
	ui.set(references.anti_aim.roll, 0)
end

local function on_setup_command(cmd)
	anti_aim.run(cmd)
	anti_aim.manual_aa(cmd)
end



local function render()
	anti_aim.leg_break()
end

local function on_paint()
	visuals.watermark()
	notifications()

	if not entity.is_alive(entity.get_local_player()) then
		return
	end
	
	visuals.indicators()
	visuals.manual_arrows()
end

local function onPlayerDeath(e)
	if ui.get(menu.misc.killsay) then
		local attacker_entindex = client.userid_to_entindex(e.attacker)
		local victim_entindex = client.userid_to_entindex(e.userid)
		local local_player = entity.get_local_player()

		if attacker_entindex ~= local_player or victim_entindex == local_player then
			return
		end
		
		client.exec("say "..killsays[client.random_int(1, #killsays)])
	end
end

client.set_event_callback("player_death", onPlayerDeath)

-- Callbacks
client.set_event_callback("pre_render", render)
client.set_event_callback("paint_ui", menu_functions)
client.set_event_callback("paint", on_paint)
client.set_event_callback("shutdown", unload)
client.set_event_callback("setup_command", on_setup_command)
client.set_event_callback("aim_hit", aim_hit)
client.set_event_callback("aim_miss", aim_miss)
client.set_event_callback("net_update_end", g_net_update)
client.set_event_callback("aim_fire", g_aim_fire)
client.set_event_callback("bullet_impact", g_bullet_impact)

-- Cool sound when loaded xD
client.exec('playvol "survival/buy_item_01.wav" 1') 