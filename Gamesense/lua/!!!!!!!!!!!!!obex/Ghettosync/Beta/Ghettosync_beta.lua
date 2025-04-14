-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_create_interface, client_delay_call, client_exec, client_eye_position, client_scale_damage, client_screen_size, client_set_clan_tag, client_set_event_callback, client_trace_bullet, client_trace_line, client_userid_to_entindex, database_read, database_write, entity_get_all, entity_get_classname, entity_get_local_player, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_dormant, entity_is_enemy, entity_set_prop, globals_tickcount, math_floor, require, error, globals_curtime, globals_frametime, globals_tickinterval, json_parse, json_stringify, math_abs, math_atan, math_atan2, math_cos, math_deg, math_rad, math_random, math_sin, math_sqrt, renderer_circle, renderer_circle_outline, renderer_line, renderer_measure_text, renderer_rectangle, renderer_text, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_new_slider, ui_reference, tostring, ui_set, pairs, type, pcall, renderer_triangle, tonumber, ui_new_button, ui_set_callback, ui_set_visible = bit.band, client.camera_angles, client.create_interface, client.delay_call, client.exec, client.eye_position, client.scale_damage, client.screen_size, client.set_clan_tag, client.set_event_callback, client.trace_bullet, client.trace_line, client.userid_to_entindex, database.read, database.write, entity.get_all, entity.get_classname, entity.get_local_player, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_dormant, entity.is_enemy, entity.set_prop, globals.tickcount, math.floor, require, error, globals.curtime, globals.frametime, globals.tickinterval, json.parse, json.stringify, math.abs, math.atan, math.atan2, math.cos, math.deg, math.rad, math.random, math.sin, math.sqrt, renderer.circle, renderer.circle_outline, renderer.line, renderer.measure_text, renderer.rectangle, renderer.text, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.new_slider, ui.reference, tostring, ui.set, pairs, type, pcall, renderer.triangle, tonumber, ui.new_button, ui.set_callback, ui.set_visible

local obex_data = obex_fetch and obex_fetch() or {username = 'Yas', build = 'USER'}

build_get = obex_data.build
build = build_get:upper()

local watermarkbuild = " "

if obex_data.username == "Yas" or obex_data.username == "Xyno" or obex_data.username == "Cubs"  then
	watermarkbuild = "DEV"
else

	if build == "USER" or build == "user" then
		watermarkbuild = "LIVE"
	elseif build == "beta" or build == "BETA" then
		watermarkbuild = "BETA"
	elseif build == "debug" or build == "DEBUG" then
		watermarkbuild = "DEBUG"
	else
		watermarkbuild = "error"
	end
end

local ffi = require('ffi')
local vector = require('vector')

local aa_funcs = require 'gamesense/antiaim_funcs' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=29665')
local images = require 'gamesense/images' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=22917')
local http = require 'gamesense/http' or error('Missing https://gamesense.pub/forums/viewtopic.php?id=19253')

---------------------------------------------
--[LOCALS]
---------------------------------------------


local aa_config = { 'Global', 'Standing', 'Slow motion', 'Moving' , 'Air', 'Air duck', 'Duck', 'Legit aa'}
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local rage = {}
local logs_txt = {}
local active_idx = 1
local last_anti = 0
local function air(x) return bit_band(entity_get_prop(x, "m_fFlags"), 1) == 0
end

local state_to_num = {
	['Global'] = 1,
	['Stand'] = 2,
	['Slow motion'] = 3,
	['Moving'] = 4,
	['Air'] = 5,
	['Air duck'] = 6,
	['Duck'] = 7,
	['Legit aa'] = 8,
}


---------------------------------------------
--[REFERENCES]
---------------------------------------------
local ref = {
	enabled = ui_reference('AA', 'Anti-aimbot angles', 'Enabled'),
	pitch = ui_reference('AA', 'Anti-aimbot angles', 'pitch'),
	yawbase = ui_reference('AA', 'Anti-aimbot angles', 'Yaw base'),
	fakeyawlimit = ui_reference('AA', 'anti-aimbot angles', 'Fake yaw limit'),
	fsbodyyaw = ui_reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	edgeyaw = ui_reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
	maxprocticks = ui_reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
	fakeduck = ui_reference('RAGE', 'Other', 'Duck peek assist'),
	safepoint = ui_reference('RAGE', 'Aimbot', 'Force safe point'),
	forcebaim = ui_reference('RAGE', 'Other', 'Force body aim'),
	player_list = ui_reference('PLAYERS', 'Players', 'Player list'),
	reset_all = ui_reference('PLAYERS', 'Players', 'Reset all'),
	apply_all = ui_reference('PLAYERS', 'Adjustments', 'Apply to all'),
	load_cfg = ui_reference('Config', 'Presets', 'Load'),
	fl_limit = ui_reference('AA', 'Fake lag', 'Limit'),
	dt_limit = ui_reference('RAGE', 'Other', 'Double tap fake lag limit'),
	dmg = ui_reference('RAGE', 'Aimbot', 'Minimum damage'),
	bhop = ui_reference('MISC', 'Movement', 'Bunny hop'),
	maxusrcmdprocessticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks"),
	roll = ui_reference('aa', 'Anti-aimbot angles', 'Roll'),
	leg_movement = ui_reference("AA", "Other", "Leg movement"),

	--[1] = combobox/checkbox | [2] = slider/hotkey
	rage = { ui_reference('RAGE', 'Aimbot', 'Enabled') },
	yaw = { ui_reference('AA', 'Anti-aimbot angles', 'Yaw') },
	quickpeek = { ui_reference('RAGE', 'Other', 'Quick peek assist') },
	yawjitter = { ui_reference('AA', 'Anti-aimbot angles', 'Yaw jitter') },
	bodyyaw = { ui_reference('AA', 'Anti-aimbot angles', 'Body yaw') },
	freestand = { ui_reference('AA', 'Anti-aimbot angles', 'Freestanding', 'Default') },
	os = { ui_reference('AA', 'Other', 'On shot anti-aim') },
	slow = { ui_reference('AA', 'Other', 'Slow motion') },
	dt = { ui_reference('RAGE', 'Other', 'Double tap') },
	fakelag = { ui_reference('AA', 'Fake lag', 'Enabled') }
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

--local colours.lightblue = '\a'..rgbToHex(181, 209, 255)..'ff' --database_read('ghettosync_color') ~= nil and database_read('ghettosync_color') or rgbToHex(196, 217, 255)

local colours = {

	lightblue = '\a'..rgbToHex(181, 209, 255)..'ff',
	darkerblue = '\a9AC9FFFF',
	grey = '\a898989FF',
	red = '\aff441fFF',
	default = '\ac8c8c8FF',
	violet = '\a'..rgbToHex(189, 183, 255)..'ff',
	violet2 = '\aC5C9FFFF'
}


-- build_get = "debug"
-- build_get = "beta"
-- build_get = "live"



client_exec('clear')

-- client.color_log(189, 183, 255, "|-----------------------[ghettosync]-------------------------|")
client.color_log(189, 183, 255, "              Welcome ".. obex_data.username .." to ghettosync " .. watermarkbuild .. "")
client.color_log(189, 183, 255, "        o                                                     ")
client.color_log(189, 183, 255, "        O                                                      ")
client.color_log(189, 183, 255, "        o             O     O                                  ")
client.color_log(189, 183, 255, "        O            oOo   oOo                                 ")
client.color_log(189, 183, 255, "  .oOoO OoOo. .oOo.   o     o   .oOo. .oOo  O   o  OoOo. .oOo  ")
client.color_log(189, 183, 255, "  o   O o   o OooO'   O     O   O   o `Ooo. o   O  o   O O     ")
client.color_log(189, 183, 255, "  O   o o   O O       o     o   o   O     O O   o  O   o o     ")
client.color_log(189, 183, 255, "   OoOo O   o `OoO'   `oO   `oO `OoO' `OoO' `OoOO  o   O `OoO' ")
client.color_log(189, 183, 255, "      O                                         o                ")
client.color_log(189, 183, 255, "   OoO'                                      OoO'              ")
client.color_log(189, 183, 255, "                 discord.gg/JerGahXbut")
--   client.color_log(189, 183, 255, "|-----------------------[ghettosync]-------------------------|")
--client.color_log(0, 255, 0, "                       Success!")
-- client.color_log(0, 255, 0, "                  last update 27/09")
-- client.color_log(189, 183, 255, "|------------------------[changelogs]------------------------|")
-- client.color_log(189, 183, 255, "[...]")
--  client.color_log(255, 255, 0, "[~] Reworked legit aa:")
--client.color_log(255, 255, 0, "                       - Added legit aa into builder")
--client.color_log(255, 255, 0, "                       - Fixed taking hostages")
--client.color_log(255, 255, 0, "                       - Now correctly saves as a preset and exports")
--  client.color_log(0, 255, 0, "[+] Added left/right fake yaw limit")
--  client.color_log(0, 255, 0, "[+] Added Exclusive arrows")
--  client.color_log(255, 255, 0, "[~] Changes in builder")
--	client.color_log(255, 255, 0, "[~] Changes in presets")

--client.color_log(0, 255, 0, "[+] overhauled offsets")
--client.color_log(255, 180, 40, "[~] changed 'smart freestanding' to only enable on awp once again")
--client.color_log(200, 0, 0, "[-] removed placeholder textbox")
--client.color_log(200, 200, 200, "please give feedback on update in the discord!")
animdur = 14

local animacja = {}

if obex_data.username == "Yas" or obex_data.username == "Xyno" or obex_data.username == "Cubs"  then
	animacja = {

		' ',
		'G',
		'gH',
		'ghE',
		'gheT',
		'ghetT',
		'ghettO',
		'ghettoS',
		'ghettosY',
		'ghettosyN',
		'ghettosynC',
		'ghettosync -',
		'ghettosync - D',
		'ghettosync - dE',
		'ghettosync - deV',
		'ghettosync - dev B',
		'ghettosync - dev bU',
		'ghettosync - dev buI',
		'ghettosync - dev buiL',
		'ghettosync - dev builD',
		'ghettosync - DEV build',
		'ghettosync - dev build',
		'ghettosync - DEV build',
		'ghettosync - dev build',
		'ghettosync - dev buiL',
		'ghettosync - dev buI',
		'ghettosync - dev bU',
		'ghettosync - dev B',
		'ghettosync - deV',
		'ghettosync - dE',
		'ghettosync - D',
		'ghettosync - ',
		'ghettosynC',
		'ghettosyN',
		'ghettosY',
		'ghettoS',
		'ghettO',
		'ghetT',
		'gheT',
		'ghE',
		'gH',
		'G',
		'',
	}
else
	if build == "user" or build =="USER" then
		animacja = {

			' ',
			'G',
			'gH',
			'ghE',
			'gheT',
			'ghetT',
			'ghettO',
			'ghettoS',
			'ghettosY',
			'ghettosyN',
			'ghettosynC',
			'ghettosync -',
			'ghettosync - L',
			'ghettosync - lI',
			'ghettosync - liV',
			'ghettosync - livE',
			'ghettosync - live B',
			'ghettosync - live bU',
			'ghettosync - live buI',
			'ghettosync - live buiL',
			'ghettosync - live builD',
			'ghettosync - LIVE build',
			'ghettosync - live build',
			'ghettosync - LIVE build',
			'ghettosync - live build',
			'ghettosync - live buiL',
			'ghettosync - live buI',
			'ghettosync - live B',
			'ghettosync - livE',
			'ghettosync - liV',
			'ghettosync - lI',
			'ghettosync - L',
			'ghettosync - ',
			'ghettosynC',
			'ghettosyN',
			'ghettosY',
			'ghettoS',
			'ghettO',
			'ghetT',
			'gheT',
			'ghE',
			'gH',
			'G',
			'',
		}
	elseif build == "beta" or build =="BETA" then
		animacja = {

			' ',
			'G',
			'gH',
			'ghE',
			'gheT',
			'ghetT',
			'ghettO',
			'ghettoS',
			'ghettosY',
			'ghettosyN',
			'ghettosynC',
			'ghettosync -',
			'ghettosync - B',
			'ghettosync - bE',
			'ghettosync - beT',
			'ghettosync - betA',
			'ghettosync - beta B',
			'ghettosync - beta bU',
			'ghettosync - beta buI',
			'ghettosync - beta buiL',
			'ghettosync - beta builD',
			'ghettosync - BETA build',
			'ghettosync - beta build',
			'ghettosync - BETA build',
			'ghettosync - beta build',
			'ghettosync - beta buiL',
			'ghettosync - beta buI',
			'ghettosync - beta B',
			'ghettosync - betA',
			'ghettosync - beT',
			'ghettosync - bE',
			'ghettosync - B',
			'ghettosync - ',
			'ghettosynC',
			'ghettosyN',
			'ghettosY',
			'ghettoS',
			'ghettO',
			'ghetT',
			'gheT',
			'ghE',
			'gH',
			'G',
			'',
		}
	elseif build == "debug" or build =="DEBUG" then
		animacja = {

			' ',
			'G',
			'gH',
			'ghE',
			'gheT',
			'ghetT',
			'ghettO',
			'ghettoS',
			'ghettosY',
			'ghettosyN',
			'ghettosynC',
			'ghettosync -',
			'ghettosync - D',
			'ghettosync - dE',
			'ghettosync - deB',
			'ghettosync - debU',
			'ghettosync - debuG',
			'ghettosync - debug B',
			'ghettosync - debug bU',
			'ghettosync - debug buI',
			'ghettosync - debug buiL',
			'ghettosync - debug builD',
			'ghettosync - debug build',
			'ghettosync - DEBUG build',
			'ghettosync - debug build',
			'ghettosync - DEBUG build',
			'ghettosync - debug builD',
			'ghettosync - debug buiL',
			'ghettosync - debug buI',
			'ghettosync - debug bU',
			'ghettosync - debug B',
			'ghettosync - debuG',
			'ghettosync - debU',
			'ghettosync - deB',
			'ghettosync - dE',
			'ghettosync - D',
			'ghettosync - ',
			'ghettosynC',
			'ghettosyN',
			'ghettosY',
			'ghettoS',
			'ghettO',
			'ghetT',
			'gheT',
			'ghE',
			'gH',
			'G',
			'',
		}

	else
		animacja = {
			'error',
			'ERROR',
		}
	end
end


local empty = {''}

local ghettosync = {
	luaenable = ui_new_checkbox('AA', 'Anti-aimbot angles', 'Enable'),
	animacjalabel = ui_new_label('AA', 'Anti-aimbot angles', "animacja"),
	tabselect = ui_new_combobox('AA','Anti-aimbot angles', colours.grey ..'Current tab', 'Anti-Aim', 'Hotkeys', 'Visuals', 'Misc', 'Config'),
	Hotkeys = {

	},

	antiaim = {
		aa_presets = ui_new_combobox('AA','Anti-aimbot angles', colours.grey ..'Anti-aim type', 'Bossmode', 'Alternative', 'Builder'),
		aa_condition = ui_new_combobox('AA','Anti-aimbot angles', colours.grey ..'Player State', aa_config),
		fl_limitslider = ui_new_slider("AA", "Fake lag", "Limit ", 1, 15, 15, true),
	},

	visual = {
		indicator_enable = ui_new_checkbox('AA','Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' crosshair indicators'),
		indicatorsselect = ui_new_combobox('AA','Anti-aimbot angles', colours.violet2 ..  ' › ' .. colours.grey .. 'indicator type', 'Classic', 'Modern'),
		indicator_col = ui_new_color_picker('AA','Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' indicator colours', 189, 183, 255, 255),
		dynamicindicator = ui_new_checkbox("AA", "Anti-aimbot angles", colours.violet2 .. " ›" .. colours.grey .. " dynamic indicators"),
		keybindsselect = ui_new_multiselect('AA','Anti-aimbot angles', colours.violet2 .. ' ›'.. colours.grey ..' toggle Indicators', 'Keybinds', 'States'),
		manual_indicators = ui_new_checkbox("AA","Anti-aimbot angles",colours.violet2 .. '≫ ' .. colours.grey .. " manual arrows"),
		arrow_col = ui_new_color_picker('AA','Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' arrow colours', 189, 183, 255, 255),
		arrowselect = ui_new_combobox('AA','Anti-aimbot angles', colours.violet2 ..  ' › ' .. colours.grey .. 'toggle arrows', 'Classic', 'Modern', 'Exclusive'),
		toggle_notificiations = ui_new_checkbox("AA", "Anti-aimbot angles", colours.violet2 .. "≫ " .. colours.grey .. " notify"),
		notif_col = ui_new_color_picker('AA','Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' arrow colours', 189, 183, 255, 255),
	},

	keybinds = {
		key_legit = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' legit aa'),
		key_defensive = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' force defensive'),
		key_left = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' manual left'),
		key_right = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' manual right'),
		key_back = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' reset key'),
		key_freestand = ui_new_hotkey('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' freestanding'),
	},

	misc = {
		enable_clan_tag = ui_new_checkbox('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. ' clantag'),
		animator = ui_new_checkbox('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. " old animations"),
		leg_break = ui_new_checkbox('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.grey .. " leg breaker"),
		--debug = ui_new_checkbox('AA', 'Anti-aimbot angles', colours.violet2 .. '≫ ' .. colours.red  .. " debug")
	},
}
ui_set(ghettosync.luaenable, true)

local animacja_prev
function animacjaplay()
	local teraz = math_floor(globals_tickcount() / animdur) % #animacja
	local animacja = animacja[teraz+1]
	if animacja ~= animacja_prev then
		animacja_prev = animacja
		ui_set(ghettosync.animacjalabel, colours.violet2 .. animacja)
	end
end

---------------------------------------------
--[ANTI-AIM]
---------------------------------------------
local function set_menu_color()
	local r, g, b = ui_get(ghettosync.colorpicker)
	colours.violet = '\a'..rgbToHex(r, g, b)..'ff'
end

for i=1, #aa_config do
	rage[i] = {
		c_enabled = ui_new_checkbox('aa', 'anti-aimbot angles', colours.grey .. 'Enable ' .. aa_config[i] .. ' config'),
		c_pitch = ui_new_combobox('aa', 'anti-aimbot angles',colours.grey .. 'Pitch',  {  'Off', 'Down',  'Default',  'Minimal'}),
		c_yawbase = ui_new_combobox('aa', 'anti-aimbot angles', colours.grey ..'Yaw base', {'Local view','At targets'}),
		c_yaw = ui_new_combobox('aa', 'anti-aimbot angles',  colours.grey ..'Yaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
		c_yaw_sli = ui_new_slider('aa', 'anti-aimbot angles',colours.grey .. ' Yaw value', -180, 180, 0, true, '°', 1),
		lr_limit = ui_new_checkbox('aa', 'anti-aimbot angles', colours.grey ..'Left/Right yaw limit' ),
		l_limit = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'L' .. colours.violet2 .. ']' ..colours.grey.. ' Yaw limit', -180, 180, 0, true, '°', 1),
		r_limit = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'R' .. colours.violet2 .. ']' ..colours.grey.. ' Yaw limit', -180, 180, 0, true, '°', 1),

		c_jitter = ui_new_combobox('aa', 'anti-aimbot angles',  colours.grey ..'Yaw jitter', {'Off','Offset',"Left & Right Offset",'Center',"Left & Right Center",'Random'}),
		c_jitter_sli = ui_new_slider('aa', 'anti-aimbot angles', colours.grey .. 'Jitter value', -180, 180, 0, true, '°', 1),
		l_jitter = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'L' .. colours.violet2 .. ']' ..colours.grey.. ' Value', -180, 180, 0, true, '°', 1),
		r_jitter = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'R' .. colours.violet2 .. ']' ..colours.grey.. ' Value', -180, 180, 0, true, '°', 1),
		c_body = ui_new_combobox('aa', 'anti-aimbot angles', colours.grey .. 'Body yaw', {'Off','Opposite','Jitter','Static'}),
		c_body_sli = ui_new_slider('aa', 'anti-aimbot angles', colours.grey ..'Body value', -180, 180, 0, true, '°', 1),

		c_free_b_yaw = ui_new_checkbox('aa', 'anti-aimbot angles',  'Freestanding body yaw'),
		c_lby_limit = ui_new_slider('aa', 'anti-aimbot angles',  'Fake yaw limit', 0, 60, 60, true, '°', 1),
		l_desync_limit = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'L' .. colours.violet2 .. ']' ..colours.grey.. ' Fake yaw limit', 0, 60, 60, true, '°', 1),
		r_desync_limit = ui_new_slider('aa', 'anti-aimbot angles',  colours.violet2 .. '[' .. colours.grey .. 'R' .. colours.violet2 .. ']' ..colours.grey.. ' Fake yaw limit', 0, 60, 60, true, '°', 1),
		hybrid_fs =  ui_new_checkbox("AA", "Anti-aimbot angles", colours.grey .."Anti bruteforce"),
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

----
--- database
----
local dbcfg = database_read("config") or {}


function loaddatabase()
	if dbcfg.preset == "Builder" then
		reseted = 1
	end

	if dbcfg.clantag ~= nil then
		ui_set(ghettosync.misc.enable_clan_tag, dbcfg.clantag)
	end
	if dbcfg.animator ~= nil then
		ui_set(ghettosync.misc.animator, dbcfg.animator )
	end
	if dbcfg.leg_break ~= nil then
		ui_set(ghettosync.misc.leg_break, dbcfg.leg_break)
	end

	if dbcfg.dbr ~= nil then
		ui_set(ghettosync.visual.indicator_col, dbcfg.dbr, dbcfg.dbg, dbcfg.dbb, dbcfg.dba)
	end
	if dbcfg.toggle_notificiations ~= nil then
		ui_set(ghettosync.visual.toggle_notificiations, dbcfg.toggle_notificiations)
	end
	if dbcfg.manual_indicators ~= nil then
		ui_set(ghettosync.visual.manual_indicators, dbcfg.manual_indicators )
	end
	if dbcfg.dbarrowselect ~= nil then
		ui_set(ghettosync.visual.arrowselect, dbcfg.dbarrowselect )
	end
	if dbcfg.indicator_enable ~= nil then
		ui_set(ghettosync.visual.indicator_enable, dbcfg.indicator_enable)
	end
	if dbcfg.keybindsselect ~= nil then
		ui_set(ghettosync.visual.keybindsselect, dbcfg.keybindsselect)
	end
	if dbcfg.dbarrow_colr ~= nil then
		ui_set(ghettosync.visual.arrow_col, dbcfg.dbarrow_colr, dbcfg.dbarrow_colg, dbcfg.dbarrow_colb, dbcfg.dbarrow_cola)
	end
	if dbcfg.notif_col ~= nil then
		ui_set(ghettosync.visual.notif_col, dbcfg.notif_colr, dbcfg.notif_colg, dbcfg.notif_colb, dbcfg.notif_cola)
	end

	if dbpreset ~= nil then
		ui_set(ghettosync.antiaim.aa_presets, dbpreset)
	end
	if dbcfg.preset == "Builder" then
		ui_set(ghettosync.antiaim.aa_presets, "Builder")

		pcall(function()
		local num_tbl = {}
		local settings = dbcfg.config

		for key, value in pairs(settings) do
			if type(value) == 'table' then
				for k, v in pairs(value) do
					if type(k) == 'number' then
						table_insert(num_tbl, v)
						ui_set(rage[key], num_tbl)
					else
						ui_set(rage[key][k], v)
					end
				end
			else
				ui_set(rage[key], value)
			end
		end
		end)
	end
end

reseted=1

loaddatabase()

client_set_event_callback("pre_config_load", function(e)
dbcfg.dbr, dbcfg.dbg, dbcfg.dbb, dbcfg.dba = ui_get(ghettosync.visual.indicator_col)
dbcfg.clantag = ui_get(ghettosync.misc.enable_clan_tag)
dbcfg.animator = ui_get(ghettosync.misc.animator)
dbcfg.leg_break = ui_get(ghettosync.misc.leg_break)
dbcfg.toggle_notificiations = ui_get(ghettosync.visual.toggle_notificiations)
dbcfg.manual_indicators = ui_get(ghettosync.visual.manual_indicators)
dbcfg.dbarrowselect = ui_get(ghettosync.visual.arrowselect)
dbcfg.indicator_enable = ui_get(ghettosync.visual.indicator_enable)
dbcfg.keybindsselect = ui_get(ghettosync.visual.keybindsselect)
dbcfg.dbarrow_colr, dbcfg.dbarrow_colg, dbcfg.dbarrow_colb, dbcfg.dbarrow_cola = ui_get(ghettosync.visual.arrow_col)
dbcfg.notif_colr, dbcfg.notif_colg, dbcfg.notif_colb, dbcfg.notif_cola = ui_get(ghettosync.visual.notif_col)

dbpreset = ui_get(ghettosync.antiaim.aa_presets)
dbcfg.preset = dbpreset
if dbpreset == "Builder" then
	local settings = {}
	pcall(function()
	for key, value in pairs(rage) do
		if value then
			settings[key] = {}

			if type(value) == 'table' then
				for k, v in pairs(value) do
					settings[key][k] = ui_get(v)
				end
			else
				settings[key] = ui_get(value)
			end
		end
	end
	dbcfg.config = settings
	end)
end
end)

client_set_event_callback("post_config_load", function(e)
if dbcfg.preset == "Builder" then
	reseted = 1
end

if dbcfg.clantag ~= nil then
	ui_set(ghettosync.misc.enable_clan_tag, dbcfg.clantag)
end
if dbcfg.animator ~= nil then
	ui_set(ghettosync.misc.animator, dbcfg.animator )
end
if dbcfg.leg_break ~= nil then
	ui_set(ghettosync.misc.leg_break, dbcfg.leg_break)
end
if dbcfg.dbr ~= nil then
	ui_set(ghettosync.visual.indicator_col, dbcfg.dbr, dbcfg.dbg, dbcfg.dbb, dbcfg.dba)
end
if dbcfg.toggle_notificiations ~= nil then
	ui_set(ghettosync.visual.toggle_notificiations, dbcfg.toggle_notificiations)
end
if dbcfg.manual_indicators ~= nil then
	ui_set(ghettosync.visual.manual_indicators, dbcfg.manual_indicators )
end
if dbcfg.dbarrowselect ~= nil then
	ui_set(ghettosync.visual.arrowselect, dbcfg.dbarrowselect )
end
if dbcfg.indicator_enable ~= nil then
	ui_set(ghettosync.visual.indicator_enable, dbcfg.indicator_enable)
end
if dbcfg.keybindsselect ~= nil then
	ui_set(ghettosync.visual.keybindsselect, dbcfg.keybindsselect)
end
if dbcfg.dbarrow_col ~= nil then
	ui_set(ghettosync.visual.arrow_col, dbcfg.dbarrow_colr, dbcfg.dbarrow_colg, dbcfg.dbarrow_colb, dbcfg.dbarrow_cola)
end

if dbcfg.notif_col ~= nil then
	ui_set(ghettosync.visual.notif_col, dbcfg.notif_colr, dbcfg.notif_colg, dbcfg.notif_colb, dbcfg.notif_cola)
end

if dbpreset ~= nil then
	reseted=1
	ui_set(ghettosync.antiaim.aa_presets, dbpreset)

	pcall(function()
	local num_tbl = {}
	local settings = dbcfg.config

	for key, value in pairs(settings) do
		if type(value) == 'table' then
			for k, v in pairs(value) do
				if type(k) == 'number' then
					table_insert(num_tbl, v)
					ui_set(rage[key], num_tbl)
				else
					ui_set(rage[key][k], v)
				end
			end
		else
			ui_set(rage[key], value)
		end
	end
	end)
end
end)

client_set_event_callback("shutdown", function()
dbcfg.dbr, dbcfg.dbg, dbcfg.dbb, dbcfg.dba = ui_get(ghettosync.visual.indicator_col)
dbcfg.clantag = ui_get(ghettosync.misc.enable_clan_tag)
dbcfg.animator = ui_get(ghettosync.misc.animator)
dbcfg.leg_break = ui_get(ghettosync.misc.leg_break)
dbcfg.toggle_notificiations = ui_get(ghettosync.visual.toggle_notificiations)
dbcfg.manual_indicators = ui_get(ghettosync.visual.manual_indicators)
dbcfg.dbarrowselect = ui_get(ghettosync.visual.arrowselect)
dbcfg.indicator_enable = ui_get(ghettosync.visual.indicator_enable)
dbcfg.keybindsselect = ui_get(ghettosync.visual.keybindsselect)
dbcfg.dbarrow_colr, dbcfg.dbarrow_colg, dbcfg.dbarrow_colb, dbcfg.dbarrow_cola = ui_get(ghettosync.visual.arrow_col)
dbcfg.notif_colr, dbcfg.notif_colg, dbcfg.notif_colb, dbcfg.notif_cola = ui_get(ghettosync.visual.notif_col)

dbpreset = ui_get(ghettosync.antiaim.aa_presets)
dbcfg.preset = dbpreset
if dbpreset == "Builder" then
	local settings = {}
	pcall(function()
	for key, value in pairs(rage) do
		if value then
			settings[key] = {}

			if type(value) == 'table' then
				for k, v in pairs(value) do
					settings[key][k] = ui_get(v)
				end
			else
				settings[key] = ui_get(value)
			end
		end
	end
	dbcfg.config = settings
	end)
end

database_write("config", dbcfg)
end)


---------------------------------------------
--[Preset]
---------------------------------------------
brutereset = 0

local function bossmodeimport()
	pcall(function()
	local num_tbl = {}
	local settings = json_parse('[{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","l_jitter":0,"c_yawbase":"Local view","c_body_sli":0,"c_enabled":false,"r_jitter":0,"c_jitter":"Off","c_free_b_yaw":false,"c_jitter_sli":0,"l_desync_limit":0,"r_desync_limit":0,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-46,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":-23,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":27,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0},{"r_limit":8,"c_lby_limit":58,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":6},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":3,"c_pitch":"Default","c_body":"Jitter","l_jitter":12,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":14,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":18,"c_pitch":"Down","c_body":"Jitter","l_jitter":36,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":36,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":37,"l_desync_limit":59,"r_desync_limit":59,"l_limit":0},{"r_limit":12,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":16,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-35,"c_yawbase":"At targets","c_body_sli":20,"c_enabled":true,"r_jitter":33,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":55,"l_desync_limit":60,"r_desync_limit":60,"l_limit":-8},{"r_limit":8,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Down","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":57,"l_desync_limit":60,"r_desync_limit":60,"l_limit":7},{"r_limit":0,"c_lby_limit":60,"lr_limit":false,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":178,"c_pitch":"Off","c_body":"Static","l_jitter":0,"c_yawbase":"Local view","c_body_sli":180,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":7,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0}]')
	for key, value in pairs(settings) do
		if type(value) == 'table' then
			for k, v in pairs(value) do
				if type(k) == 'number' then
					table_insert(num_tbl, v)
					ui_set(rage[key], num_tbl)
				else
					ui_set(rage[key][k], v)
				end
			end
		else
			ui_set(rage[key], value)
		end
	end
	end)
end

local bossmode_builder = ui_new_button("AA", "anti-aimbot angles", colours.grey .. "Import into builder", function(to_import)
ui_set(ghettosync.antiaim.aa_presets, "Builder")
pcall(function()
local num_tbl = {}
	local settings = json_parse('[{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","l_jitter":0,"c_yawbase":"Local view","c_body_sli":0,"c_enabled":false,"r_jitter":0,"c_jitter":"Off","c_free_b_yaw":false,"c_jitter_sli":0,"l_desync_limit":0,"r_desync_limit":0,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-46,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":-23,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":27,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0},{"r_limit":8,"c_lby_limit":58,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":6},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":3,"c_pitch":"Default","c_body":"Jitter","l_jitter":12,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":14,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":18,"c_pitch":"Down","c_body":"Jitter","l_jitter":36,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":36,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":37,"l_desync_limit":59,"r_desync_limit":59,"l_limit":0},{"r_limit":12,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":16,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-35,"c_yawbase":"At targets","c_body_sli":20,"c_enabled":true,"r_jitter":33,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":55,"l_desync_limit":60,"r_desync_limit":60,"l_limit":-8},{"r_limit":8,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Down","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":57,"l_desync_limit":60,"r_desync_limit":60,"l_limit":7},{"r_limit":0,"c_lby_limit":60,"lr_limit":false,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":178,"c_pitch":"Off","c_body":"Static","l_jitter":0,"c_yawbase":"Local view","c_body_sli":180,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":7,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0}]')

for key, value in pairs(settings) do
	if type(value) == 'table' then
		for k, v in pairs(value) do
			if type(k) == 'number' then
				table_insert(num_tbl, v)
				ui_set(rage[key], num_tbl)
			else
				ui_set(rage[key][k], v)
			end
		end
	else
		ui_set(rage[key], value)
	end
end
end)
end)

local function alternativeimport()
	pcall(function()
	local num_tbl = {}
	local settings = json_parse('[{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","l_jitter":0,"c_yawbase":"Local view","c_body_sli":0,"c_enabled":false,"r_jitter":0,"c_jitter":"Off","c_free_b_yaw":false,"c_jitter_sli":0,"l_desync_limit":0,"r_desync_limit":0,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-46,"c_yawbase":"At targets","c_body_sli":10,"c_enabled":true,"r_jitter":-23,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":41,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0},{"r_limit":8,"c_lby_limit":58,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":6},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":3,"c_pitch":"Default","c_body":"Jitter","l_jitter":12,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":14,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":18,"c_pitch":"Down","c_body":"Jitter","l_jitter":36,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":36,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":37,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":12,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":16,"c_pitch":"Down","c_body":"Jitter","l_jitter":73,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":-2,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":54,"l_desync_limit":58,"r_desync_limit":59,"l_limit":-4},{"r_limit":8,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Down","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":57,"l_desync_limit":60,"r_desync_limit":60,"l_limit":7},{"r_limit":0,"c_lby_limit":60,"lr_limit":false,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":178,"c_pitch":"Off","c_body":"Static","l_jitter":0,"c_yawbase":"Local view","c_body_sli":180,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":7,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0}]')

	for key, value in pairs(settings) do
		if type(value) == 'table' then
			for k, v in pairs(value) do
				if type(k) == 'number' then
					table_insert(num_tbl, v)
					ui_set(rage[key], num_tbl)
				else
					ui_set(rage[key][k], v)
				end
			end
		else
			ui_set(rage[key], value)
		end
	end
	end)
end

local alternative_builder = ui_new_button("AA", "anti-aimbot angles", colours.grey .."Import into builder", function(to_import)
ui_set(ghettosync.antiaim.aa_presets, "Builder")
pcall(function()
local num_tbl = {}
local settings = json_parse('[{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","l_jitter":0,"c_yawbase":"Local view","c_body_sli":0,"c_enabled":false,"r_jitter":0,"c_jitter":"Off","c_free_b_yaw":false,"c_jitter_sli":0,"l_desync_limit":0,"r_desync_limit":0,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":0,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":-46,"c_yawbase":"At targets","c_body_sli":10,"c_enabled":true,"r_jitter":-23,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":41,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0},{"r_limit":8,"c_lby_limit":58,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Minimal","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":6},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":3,"c_pitch":"Default","c_body":"Jitter","l_jitter":12,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":14,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":58,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":0,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":18,"c_pitch":"Down","c_body":"Jitter","l_jitter":36,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":36,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":37,"l_desync_limit":58,"r_desync_limit":59,"l_limit":0},{"r_limit":12,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":16,"c_pitch":"Down","c_body":"Jitter","l_jitter":73,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":-2,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":54,"l_desync_limit":58,"r_desync_limit":59,"l_limit":-4},{"r_limit":8,"c_lby_limit":60,"lr_limit":true,"hybrid_fs":true,"c_yaw":"180","c_yaw_sli":7,"c_pitch":"Down","c_body":"Jitter","l_jitter":0,"c_yawbase":"At targets","c_body_sli":0,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":false,"c_jitter_sli":57,"l_desync_limit":60,"r_desync_limit":60,"l_limit":7},{"r_limit":0,"c_lby_limit":60,"lr_limit":false,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":178,"c_pitch":"Off","c_body":"Static","l_jitter":0,"c_yawbase":"Local view","c_body_sli":180,"c_enabled":true,"r_jitter":0,"c_jitter":"Center","c_free_b_yaw":true,"c_jitter_sli":7,"l_desync_limit":60,"r_desync_limit":60,"l_limit":0}]')

for key, value in pairs(settings) do
	if type(value) == 'table' then
		for k, v in pairs(value) do
			if type(k) == 'number' then
				table_insert(num_tbl, v)
				ui_set(rage[key], num_tbl)
			else
				ui_set(rage[key][k], v)
			end
		end
	else
		ui_set(rage[key], value)
	end
end
end)
end)


local function reset()
	pcall(function()
	local num_tbl = {}
	local settings = json_parse('[{"r_limit":0,"c_body_sli":10,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":true,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":58},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"Off","c_yaw_sli":0,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":0,"c_jitter_sli":0,"lr_limit":true,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":0,"c_lby_limit":60},{"r_limit":0,"c_body_sli":0,"c_enabled":false,"hybrid_fs":false,"c_yaw":"180","c_yaw_sli":180,"c_pitch":"Off","c_body":"Off","c_free_b_yaw":false,"l_desync_limit":60,"c_jitter_sli":0,"lr_limit":false,"c_yawbase":"Local view","l_limit":0,"c_jitter":"Off","r_desync_limit":60,"c_lby_limit":60}]')

	for key, value in pairs(settings) do
		if type(value) == 'table' then
			for k, v in pairs(value) do
				if type(k) == 'number' then
					table_insert(num_tbl, v)
					ui_set(rage[key], num_tbl)
				else
					ui_set(rage[key][k], v)
				end
			end
		else
			ui_set(rage[key], value)
		end
	end
	end)
end
---
-- notifications
---



--[[local bgpng = nil
http.get("https://i.imgur.com/DLcibGv.png", function(s, r)
	if s and r.status == 200 then
	bgpng = images.load(r.body)
end
end)]]--


_G.ghettosync_push=(function()
_G.ghettosync_notify_cache={}
local a={callback_registered=false,maximum_count=4}
local b=ui_reference("Misc","Settings","Menu color")
function a:register_callback()
	if self.callback_registered then return end;
	client_set_event_callback("paint_ui",function()
	local c={client_screen_size()}
	local d={0,0,0}
	local e=1;

	local animload, circleload = 0;

	local f=_G.ghettosync_notify_cache;
	for g=#f,1,-1 do
		_G.ghettosync_notify_cache[g].time=_G.ghettosync_notify_cache[g].time-globals_frametime()
		local c1,c2,c3,c4 = ui_get(ghettosync.visual.notif_col)
		local h,i=255,0;
		local i2 = 0;
		local lerpy = 0;
		local cp = 40;
		local cp_circ = 0.2;
		local lerp_circ = 0.2;
		local lh = c4;
		local j=f[g]
		if j.time<0 then
			table_remove(_G.ghettosync_notify_cache,g)
		else
			local k=j.def_time-j.time;
			local k=k>1 and 1 or k;
			if j.time<1 or k<1 then
				i=(k<1 and k or j.time)/1;
				i2=(k<1 and k or j.time)/1;
				h=i*255;
				lh = i*c4;
				cp_circ = i*0.2
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
				end;
				local l={ui_get(b)}
				local m={math_floor(renderer_measure_text(nil,"[GHETTOSYNC]  "..j.draw)*1.03)}
				local n={renderer_measure_text(nil,"[GHETTOSYNC]  ")}
				local o={renderer_measure_text(nil,j.draw)}
				local p={c[1]/2-m[1]/2+3,c[2]-c[2]/100*13.4+e}

				local x, y = client_screen_size()

				lerpy = ((22*j.time))
				color = 25
				renderer_rectangle(p[1]-1,p[2]-20,m[1]+2,24,color, color, color,lh>255 and 255 or lh)
				--renderer.texture(17, p[1]-1,p[2]-20,m[1]+2,24,15, 15, 15,h>255 and 255 or h, f)
				--renderer.texture(bgtexture, p[1]-1, p[2]-20, 700, 100, 15, 15, 15, h>255 and 255 or h)
				
				--bgpng:draw(p[1]- 1, p[2]-20, m[1]+2, 24, 255, 255, 255, 255)
				renderer_circle(p[1]-1,p[2]-2, color, color, color,lh>255 and c4 or lh, 6, 270, 0.25)
				renderer_circle(p[1]-1,p[2]-14, color, color, color,lh>255 and c4 or lh, 6, 180, 0.25)
				renderer_rectangle(p[1]-7,p[2]-14,6,12,color, color, color,lh>255 and c4 or lh)

				renderer_circle(p[1]+m[1]+1,p[2]-14, color, color, color,lh>255 and c4 or lh, 6, 90, 0.25)
				renderer_circle(p[1]+m[1]+1,p[2]-2, color, color, color,lh>255 and c4 or lh, 6, 0, 0.25)
				renderer_rectangle(p[1]+m[1] +1,p[2]-14,6,12, color, color, color,lh>255 and c4 or lh)

				renderer_circle_outline(p[1]-1,p[2]-8, c1,c2,c3,lh>255 and c4 or lh, 12, 85, 0.10, 2)

				--renderer_circle_outline(p[1]+m[1]+1,p[2]-9, c1,c2,c3,h>200 and 200 or h, 13, 35, 0.3 - lerp_circ, 2)
				--renderer_line(p[1]+m[1]+1,p[2]+3,p[1]+149-lerpy,p[2]+3,c1,c2,c3,h>255 and 255 or h)
				--renderer_rectangle(p[1],p[2]+2,m[1]-140+lerpy,2,c1,c2,c3,lh>255 and 255 or lh)
				renderer_rectangle(p[1],p[2]+2,m[1]+4,2,c1,c2,c3,lh>255 and c4 or lh)
				renderer_circle_outline(p[1]+m[1],p[2]-7.25, c1,c2,c3,lh>255 and c4 or lh, 12, 50, 0.05, 2)

				--renderer_line(p[1]-109+lerpy+m[1]+1,p[2]+3,p[1]-cp+169-lerpy,p[2]+3,c1,c2,c3,lh>255 and 255 or lh)
				--renderer_line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,255,c2,255,h>255 and 255 or h)
				--renderer_line(p[1]-1,p[2]-21,p[1]-149+m[1]+lerpy,p[2]-21,0,c2,0,h>255 and 255 or h)
				renderer_text(p[1]+m[1]/2-o[1]/2,p[2] - 9,c1,c2,c3,lh>255 and c4 or lh,"c",nil,"GHETTOSYNC  ")
				renderer_text(p[1]+m[1]/2+n[1]/2,p[2] - 9,255,255,255,lh>255 and c4 or lh,"c",nil,j.draw)e=e-33
			end
			end;
			self.callback_registered=true end)
			end;

			function a:paint(q,r)
				local s=tonumber(q)+1;
				for g=self.maximum_count,2,-1 do
					_G.ghettosync_notify_cache[g]=_G.ghettosync_notify_cache[g-1]
					end;
					_G.ghettosync_notify_cache[1]={time=s,def_time=s,draw=r}
					self:register_callback()end;return a end)()

					-- ghettosync_push:paint( time ,"    ")
					----
					--antibrute
					----


					local best_enemy = nil

					local brute = {
						yaw_status = "default",
						fs_side = 0,
						last_miss = 0,
						best_angle = 0,
						misses = { },
						hp = 0,
						misses_ind = { },
						can_hit_head = 0,
						can_hit = 0,
						hit_reverse = { }
					}

					local ingore = false
					local laa = 0
					local raa = 0
					local mantimer = 0
					local function normalize_yaw(yaw)
						while yaw > 180 do yaw = yaw - 360 end
							while yaw < -180 do yaw = yaw + 360 end
								return yaw
							end

							local function calc_angle(local_x, local_y, enemy_x, enemy_y)
								local ydelta = local_y - enemy_y
								local xdelta = local_x - enemy_x
								local relativeyaw = math_atan( ydelta / xdelta )
								relativeyaw = normalize_yaw( relativeyaw * 180 / math.pi )
								if xdelta >= 0 then
									relativeyaw = normalize_yaw(relativeyaw + 180)
								end
								return relativeyaw
							end

							local function ang_on_screen(x, y)
								if x == 0 and y == 0 then return 0 end

								return math_deg(math_atan2(y, x))
							end

							local function angle_vector(angle_x, angle_y)
								local sy = math_sin(math_rad(angle_y))
								local cy = math_cos(math_rad(angle_y))
								local sp = math_sin(math_rad(angle_x))
								local cp = math_cos(math_rad(angle_x))
								return cp * cy, cp * sy, -sp
							end

							local function get_damage(me, enemy, x, y,z)
								local ex = { }
								local ey = { }
								local ez = { }
								ex[0], ey[0], ez[0] = entity_hitbox_position(enemy, 1)
								ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
								ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
								ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
								ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
								ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
								ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
								local bestdamage = 0
								local bent = nil
								for i=0, 6 do
									local ent, damage = client_trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
									if damage > bestdamage then
										bent = ent
										bestdamage = damage
									end
								end
								return bent == nil and client_scale_damage(me, 1, bestdamage) or bestdamage
							end

							local function get_best_enemy()
								best_enemy = nil

								local enemies = entity_get_players(true)
								local best_fov = 180

								local lx, ly, lz = client_eye_position()
								local view_x, view_y, roll = client_camera_angles()

								for i=1, #enemies do
									local cur_x, cur_y, cur_z = entity_get_prop(enemies[i], "m_vecOrigin")
									local cur_fov = math_abs(normalize_yaw(ang_on_screen(lx - cur_x, ly - cur_y) - view_y + 180))
									if cur_fov < best_fov then
										best_fov = cur_fov
										best_enemy = enemies[i]
									end
								end
							end

							local function extrapolate_position(xpos,ypos,zpos,ticks,player)
								local x,y,z = entity_get_prop(player, "m_vecVelocity")
								for i=0, ticks do
									xpos =  xpos + (x*globals_tickinterval())
									ypos =  ypos + (y*globals_tickinterval())
									zpos =  zpos + (z*globals_tickinterval())
								end
								return xpos,ypos,zpos
							end

							local function get_velocity(player)
								local x,y,z = entity_get_prop(player, "m_vecVelocity")
								if x == nil then return end
								return math_sqrt(x*x + y*y + z*z)
							end

							local function get_body_yaw(player)
								local _, model_yaw = entity_get_prop(player, "m_angAbsRotation")
								local _, eye_yaw = entity_get_prop(player, "m_angEyeAngles")
								if model_yaw == nil or eye_yaw ==nil then return 0 end
								return normalize_yaw(model_yaw - eye_yaw)
							end


							local function get_best_angle()
								local me = entity_get_local_player()

								if best_enemy == nil then return end

								local origin_x, origin_y, origin_z = entity_get_prop(best_enemy, "m_vecOrigin")
								if origin_z == nil then return end
								origin_z = origin_z + 64

								local extrapolated_x, extrapolated_y, extrapolated_z = extrapolate_position(origin_x, origin_y, origin_z, 20, best_enemy)

								local lx,ly,lz = client_eye_position()
								local hx,hy,hz = entity_hitbox_position(entity_get_local_player(), 0)
								local _, head_dmg = client_trace_bullet(best_enemy, origin_x, origin_y, origin_z, hx, hy, hz, true)

								if head_dmg ~= nil and head_dmg > 1 then
									brute.can_hit_head = 1
								else
									brute.can_hit_head = 0
								end

								local view_x, view_y, roll = client_camera_angles()

								local e_x, e_y, e_z = entity_hitbox_position(best_enemy, 0)

								local yaw = calc_angle(lx, ly, e_x, e_y)
								local rdir_x, rdir_y, rdir_z = angle_vector(0, (yaw + 90))
								local rend_x = lx + rdir_x * 10
								local rend_y = ly + rdir_y * 10

								local ldir_x, ldir_y, ldir_z = angle_vector(0, (yaw - 90))
								local lend_x = lx + ldir_x * 10
								local lend_y = ly + ldir_y * 10

								local r2dir_x, r2dir_y, r2dir_z = angle_vector(0, (yaw + 90))
								local r2end_x = lx + r2dir_x * 100
								local r2end_y = ly + r2dir_y * 100

								local l2dir_x, l2dir_y, l2dir_z = angle_vector(0, (yaw - 90))
								local l2end_x = lx + l2dir_x * 100
								local l2end_y = ly + l2dir_y * 100

								local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
								local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

								local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
								local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

								if l2damage > r2damage or ldamage > rdamage or l2damage > ldamage then
									for i=1, #aa_config do
										if ui_get(rage[i].hybrid_fs) then
											brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 1 or 2)
										else
											brute.best_angle = 1
										end
									end
								elseif r2damage > l2damage or rdamage > ldamage or r2damage > rdamage then
									for i=1, #aa_config do
										if ui_get(rage[i].hybrid_fs) then
											brute.best_angle = (brute.hit_reverse[best_enemy] == nil and 2 or 1)
										else
											brute.best_angle = 2
										end
									end
								end
							end

							local notif = true


							local function delayednotif()
								if entity_is_alive(me) then
								ghettosync_push:paint(5,"Anti-Bruteforce reset")
								notif = true
								end
							end

							local desync_side = -1
							local function delayed()
								if entity_is_alive(me) then
								local me = entity_get_local_player()
								client_delay_call(0.1 , delayednotif)
								desync_side = desync_side + 1
								end
							end




							local function brute_impact(e)

								local me = entity_get_local_player()

								if not entity_is_alive(me) then return end

								local shooter_id = e.userid
								local shooter = client_userid_to_entindex(shooter_id)

								if not entity_is_enemy(shooter) or entity_is_dormant(shooter) then return end

								local lx, ly, lz = entity_hitbox_position(me, "head_0")

								local ox, oy, oz = entity_get_prop(me, "m_vecOrigin")
								local ex, ey, ez = entity_get_prop(shooter, "m_vecOrigin")

								local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math_sqrt((e.y-ey)^2 + (e.x - ex)^2)

								if math_abs(dist) <= 35 and globals_curtime() - brute.last_miss > 0.015 then
									for i=1, #aa_config do
										if ui_get(rage[i].hybrid_fs) then
											if ui_get(ghettosync.visual.toggle_notificiations) and notif then
												if entity_is_alive(me) then delayed() end
												notif=false
											end
										else
										end
										brute.last_miss = globals_curtime()
										if brute.misses[shooter] == nil then
											brute.misses[shooter] = 1
											brute.misses_ind[shooter] = 1
										elseif brute.misses[shooter] >= 2 then
											brute.misses[shooter] = nil
										else
											brute.misses_ind[shooter] = brute.misses_ind[shooter] + 1
											brute.misses[shooter] = brute.misses[shooter] + 1
										end
									end
								end
							end

							brute.reset = function()
							brute.fs_side = 0
							brute.last_miss = 0
							brute.best_angle = 0
							brute.misses_ind = { }
							brute.misses = { }
						end

						local function brute_death(e)

							local victim_id = e.userid
							local victim = client_userid_to_entindex(victim_id)

							if victim ~= entity_get_local_player() then return end

							local attacker_id = e.attacker
							local attacker = client_userid_to_entindex(attacker_id)

							if not entity_is_enemy(attacker) then return end

							if not e.headshot then return end

							if brute.misses[attacker] == nil or (globals_curtime() - brute.last_miss < 0.06 and brute.misses[attacker] == 1) then
								if brute.hit_reverse[attacker] == nil then
									brute.hit_reverse[attacker] = true
								else
									brute.hit_reverse[attacker] = nil
								end
							end
						end

						local value = 0
						local once1 = false
						local once2 = false
						local dt_a = 0
						local dt_y = 45
						local dt_x = 0
						local dt_w = 0
						local os_a = 0
						local os_y = 45
						local os_x = 0
						local os_w = 0
						local fs_a = 0
						local fs_y = 45
						local fs_x = 0
						local fs_w = 0
						local n_x = 0
						local n2_x = 0
						local n3_x = 0
						local n4_x = 0

						local round = function(value, multiplier) local multiplier = 10 ^ (multiplier or 0); return math_floor(value * multiplier + 0.5) / multiplier end

						local was_on_ground = false


						---------------------------------------------
						--[MENU ELEMENTS]
						---------------------------------------------

						local function hide_original_menu(state)
							--OG MENU
							ui_set_visible(ref.enabled, state)
							ui_set_visible(ref.pitch, state)
							ui_set_visible(ref.yawbase, state)
							ui_set_visible(ref.yaw[1], state)
							ui_set_visible(ref.yaw[2], state)
							ui_set_visible(ref.yawjitter[1], state)
							ui_set_visible(ref.yawjitter[2], state)
							ui_set_visible(ref.bodyyaw[1], state)
							ui_set_visible(ref.bodyyaw[2], state)
							ui_set_visible(ref.fakeyawlimit, state)
							ui_set_visible(ref.fsbodyyaw, state)
							ui_set_visible(ref.edgeyaw, state)
							ui_set_visible(ref.freestand[1], state)
							ui_set_visible(ref.freestand[2], state)
							ui_set_visible(ref.fl_limit, state)
							ui_set_visible(ref.roll, state)
						end

						---------------------------------------------
						--[MENU ELEMENTS]
						---------------------------------------------

						local xxx = 'Stand'
						local function get_mode(e)
							-- 'Stand', 'Duck CT', 'Duck T', 'Moving', 'Air', Slow motion'
							local lp = entity_get_local_player()
							local vecvelocity = { entity_get_prop(lp, 'm_vecVelocity') }
							local velocity = math_sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
							local on_ground = bit_band(entity_get_prop(lp, 'm_fFlags'), 1) == 1 and e.in_jump == 0
							local not_moving = velocity < 2
							local slowwalk_key = ui_get(ref.slow[1]) and ui_get(ref.slow[2])
							local teamnum = entity_get_prop(lp, 'm_iTeamNum')

							local ct      = teamnum == 3
							local t       = teamnum == 2

							if not ui_get(ref.bhop) then
								on_ground = bit_band(entity_get_prop(lp, 'm_fFlags'), 1) == 1
							end
							if ui_get(ghettosync.keybinds.key_legit) then
								xxx = "Legit aa"
							elseif not on_ground then
								xxx = ((entity_get_prop(lp, 'm_flDuckAmount') > 0.7) and ui_get(rage[state_to_num['Air duck']].c_enabled)) and 'Air duck' or 'Air'
							else
								if ui_get(ref.fakeduck) or (entity_get_prop(lp, 'm_flDuckAmount') > 0.7) then
									xxx = 'Duck'
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
							local enabled = ui_get(ghettosync.luaenable) and ui_get(ghettosync.tabselect) == 'Anti-Aim' and ui_get(ghettosync.antiaim.aa_presets) == 'Builder'
							ui_set_visible(ghettosync.antiaim.aa_condition, enabled)

							if ui_get(ghettosync.antiaim.aa_presets) == "Bossmode" then
								brute.reset()
								bossmodeimport()
								reseted = 0
							end
							if ui_get(ghettosync.antiaim.aa_presets) == "Alternative" then
								brute.reset()
								alternativeimport()
								reseted = 0
							end
							if ui_get(ghettosync.antiaim.aa_presets) == "Builder" and reseted == 0 then
								reset()
								reseted = 1
							end
							for i=1, #aa_config do
								local show = ui_get(ghettosync.antiaim.aa_condition) == aa_config[i] and enabled
								ui_set_visible(rage[i].c_enabled, show and i > 1)
								ui_set_visible(rage[i].c_pitch,show and i ~= 8)
								ui_set_visible(rage[i].c_yawbase,show)
								ui_set_visible(rage[i].c_yaw, false)
								ui_set_visible(rage[i].c_yaw_sli, false)

								ui_set_visible(rage[i].c_jitter, show)
								ui_set_visible(rage[i].c_jitter_sli, show and ui_get(rage[i].c_jitter) ~= 'Off' and ui_get(rage[i].c_jitter) ~= 'Left & Right Center' and ui_get(rage[i].c_jitter) ~= 'Left & Right Offset' )
								ui_set_visible(rage[i].l_jitter, show and ui_get(rage[i].c_jitter) == 'Left & Right Center' or show and ui_get(rage[i].c_jitter) == 'Left & Right Offset' )
								ui_set_visible(rage[i].r_jitter, show and ui_get(rage[i].c_jitter) == 'Left & Right Center' or show and ui_get(rage[i].c_jitter) == 'Left & Right Offset')
								ui_set_visible(rage[i].c_body,show)
								ui_set_visible(rage[i].c_body_sli,show and (ui_get(rage[i].c_body) ~= 'Off' and ui_get(rage[i].c_body) ~= 'Opposite'))
								ui_set_visible(rage[i].l_desync_limit, show)
								ui_set_visible(rage[i].r_desync_limit, show)

								ui_set_visible(rage[i].c_free_b_yaw, false)
								ui_set_visible(rage[i].c_lby_limit, false)


								ui_set_visible(rage[i].lr_limit, false)
								ui_set_visible(rage[i].l_limit, show and ui_get(rage[i].lr_limit) and i ~= 8)
								ui_set_visible(rage[i].r_limit, show and ui_get(rage[i].lr_limit) and i ~= 8)
								ui_set_visible(rage[i].hybrid_fs, show and i ~= 8)

								ui_set(rage[i].lr_limit, true)
								ui_set(rage[i].c_yaw, "180")
							end

							ui.set(rage[8].c_yaw_sli, 178)
							ui.set(rage[8].c_pitch, "off")
							ui_set(rage[8].lr_limit, false)

						end
						handle_menu()

						local function handle_keybinds()
							local freestand = ui_get(ghettosync.keybinds.key_freestand)
							ui_set(ref.freestand[1], freestand and 'Default' or '')
							ui_set(ref.freestand[2], freestand and 0 or 2)
						end
						---------------------------------------------
						--[ANTI-AIM]
						---------------------------------------------

						---------------------------------------------
						--[MISC]
						---------------------------------------------


						local VGUI_System010 =  client_create_interface('vgui2.dll', 'VGUI_System010')
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

				local import_cfg = ui_new_button("AA", "anti-aimbot angles", colours.grey .."Import", function(to_import)
				ui_set(ghettosync.antiaim.aa_presets, "Builder")
				pcall(function()
				local num_tbl = {}
				local settings = json_parse(clipboard_import())

				for key, value in pairs(settings) do
					if type(value) == 'table' then
						for k, v in pairs(value) do
							if type(k) == 'number' then
								table_insert(num_tbl, v)
								ui_set(rage[key], num_tbl)
							else
								ui_set(rage[key][k], v)
							end
						end
					else
						ui_set(rage[key], value)
					end
				end
				--ghettosync_push:paint(5, "Reset data due to importing anti-aim settings.")
				brute.reset()
				ghettosync_push:paint(5, "Imported anti-aim settings.")
				end)
				end)

				local export_cfg = ui_new_button("AA", "anti-aimbot angles", colours.grey .."Export", function()
				local settings = {}

				pcall(function()
				for key, value in pairs(rage) do
					if value then
						settings[key] = {}

						if type(value) == 'table' then
							for k, v in pairs(value) do
								settings[key][k] = ui_get(v)
							end
						else
							settings[key] = ui_get(value)
						end
					end
				end

				clipboard_export(json_stringify(settings))

				ghettosync_push:paint(5, 'Exported settings to clipboard.')
				end)
				end)

				local function leg_breaker()
					if ui_get(ghettosync.misc.leg_break) and ui_get(ghettosync.luaenable) then
						if ui_get(ref.leg_movement) == "Always slide" or ui_get(ref.leg_movement) == "Never slide" or ui_get(ref.leg_movement) == "Off" then
							if math_random(1, 2) == 1 then
								ui_set(ref.leg_movement, "Never slide")
							else
								ui_set(ref.leg_movement, "Always slide")
							end
						end
					end
				end

				---------------------------------------------
				--[MISC]
				---------------------------------------------
				---------------------------------------------
				--[CLANTAG CHANGER]
				---------------------------------------------

				local skeetclantag = ui_reference('MISC', 'MISCELLANEOUS', 'Clan tag spammer')

				local duration = 25
				local clantags = {
					'',
					'',
					'g',
					'g\a>',
					'gh\a>',
					'ghe\a>',
					'ghet\a>',
					'ghett\a>',
					'ghetto\a>',
					'ghettos\a>',
					'ghettosy\a>',
					'ghettosyn\a>',
					'ghettosync\a',
					'ghettosync\a',
					'ghettosync\a',
					'ghettosync\a',
					'ghettosync\a',
					'ghettosyn\a>',
					'ghettosy\a>',
					'ghettos\a>',
					'ghetto\a>',
					'ghett\a>',
					'ghet\a>',
					'ghe\a>',
					'gh\a>',
					'g\a>',
					'',
					'',
				}

				local empty = {''}
				local clantag_prev
				client_set_event_callback('net_update_end', function()
				if ui_get(skeetclantag) then
					return
				end

				local cur = math_floor(globals_tickcount() / duration) % #clantags
				local clantag = clantags[cur+1]

				if ui_get(ghettosync.misc.enable_clan_tag) then
					if clantag ~= clantag_prev then
						clantag_prev = clantag
						client_set_clan_tag(clantag)
					end
				end
				end)
				ui_set_callback(ghettosync.misc.enable_clan_tag, function() client_set_clan_tag('\0') end)
				---------------------------------------------
				--[CLANTAG CHANGER]
				---------------------------------------------

				---------------------------------------------
				--[LEGIT AA]
				---------------------------------------------

				local entity_has_c4 = function(ent)
				local bomb = entity_get_all('CC4')[1]
				return bomb ~= nil and entity_get_prop(bomb, 'm_hOwnerEntity') == ent
			end

			local distance_3d = function(x1, y1, z1, x2, y2, z2)
			return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
		end

		local classnames = {
			'CWorld',
			'CCSPlayer',
			'CFuncBrush'
		}

		local aa_on_use = function(e)

		local local_player = entity_get_local_player()

		local distance = 100
		local bomb = entity_get_all('CPlantedC4')[1]
		local bomb_x, bomb_y, bomb_z = entity_get_prop(bomb, 'm_vecOrigin')

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(local_player, 'm_vecOrigin')
			distance = distance_3d(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end

		local distance_h = 100
		local hostage = entity_get_all('CHostage')[1]
		local hostage_x, hostage_y, hostage_z = entity_get_prop(hostage, 'm_vecOrigin')

		if hostage_x ~= nil then
			local player_x, player_y, player_z = entity_get_prop(local_player, 'm_vecOrigin')
			distance_h = distance_3d(hostage_x, hostage_y, hostage_z, player_x, player_y, player_z)
		end

		local team_num = entity_get_prop(local_player, 'm_iTeamNum')
		local defusing_bomb = team_num == 3 and distance < 62
		local getting_hostage = team_num == 3 and distance_h < 62

		local on_bombsite = entity_get_prop(local_player, 'm_bInBombZone')

		local has_bomb = entity_has_c4(local_player)
		local planting_bomb = on_bombsite ~= 0 and team_num == 2 and has_bomb

		local eyepos = vector(client_eye_position())
		local pitch, yaw = client_camera_angles()

		local sin_pitch = math_sin(math_rad(pitch))
		local cos_pitch = math_cos(math_rad(pitch))
		local sin_yaw = math_sin(math_rad(yaw))
		local cos_yaw = math_cos(math_rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
		local fraction, entindex = client_trace_line(local_player, eyepos.x, eyepos.y, eyepos.z, eyepos.x + (dir_vec[1] * 8192), eyepos.y + (dir_vec[2] * 8192), eyepos.z + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #classnames do
				if entity_get_classname(entindex) == classnames[i] then
					using = false
				end
			end
		end

		if not using and not planting_bomb and not defusing_bomb and not getting_hostage and ui_get(ghettosync.keybinds.key_legit) then
			e.in_use = 0
		end
	end
	function onstart(e)
		aa_on_use(e)
	end

	client_set_event_callback("setup_command", onstart)
	---------------------------------------------
	--[LEGIT AA]
	---------------------------------------------

	---------------------------------------------
	--[MANUAL AA]
	---------------------------------------------
	local last_press_t_dir = 0
	local yaw_direction = 0

	local run_direction = function()
	ui_set(ghettosync.keybinds.key_left, 'On hotkey')
	ui_set(ghettosync.keybinds.key_back, 'On hotkey')
	ui_set(ghettosync.keybinds.key_right, 'On hotkey')

	ui_set(ref.freestand[1], ui_get(ghettosync.keybinds.key_freestand) and 'Default' or '-')
	ui_set(ref.freestand[2], ui_get(ghettosync.keybinds.key_freestand) and 'Always on' or 'On hotkey')

	if (ui_get(ghettosync.keybinds.key_freestand)) then
		yaw_direction = 0
		last_press_t_dir = globals_curtime()
	else
		if ui_get(ghettosync.keybinds.key_right) and last_press_t_dir + 0.2 < globals_curtime() then
			yaw_direction = yaw_direction == 90 and 0 or 90
			last_press_t_dir = globals_curtime()
		elseif ui_get(ghettosync.keybinds.key_left) and last_press_t_dir + 0.2 < globals_curtime() then
			yaw_direction = yaw_direction == -90 and 0 or -90
			last_press_t_dir = globals_curtime()
		elseif ui_get(ghettosync.keybinds.key_back) and last_press_t_dir + 0.2 < globals_curtime() then
			yaw_direction = yaw_direction == 0 and 0 or 0
			last_press_t_dir = globals_curtime()
		elseif last_press_t_dir > globals_curtime() then
			last_press_t_dir = globals_curtime()
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
	if not ui_get(ref.dt[1]) or not ui_get(ref.dt[2]) or ui_get(ref.fakeduck) then return false end
	if not entity_is_alive(entity_get_local_player()) or entity_get_local_player() == nil then return end
	local weapon = entity_get_prop(entity_get_local_player(), "m_hActiveWeapon")
	if weapon == nil then return false end
	local next_attack = entity_get_prop(entity_get_local_player(), "m_flNextAttack") + 0.25
	local checkcheck = entity_get_prop(weapon, "m_flNextPrimaryAttack")
	if checkcheck == nil then return end
	local next_primary_attack = checkcheck + 0.5
	if next_attack == nil or next_primary_attack == nil then return false end
	return next_attack - globals_curtime() < 0 and next_primary_attack - globals_curtime() < 0
end



local function animation(check, name, value, speed)
	if check then
		return name + (value - name) * globals_frametime() * speed
	else
		return name - (value + name) * globals_frametime() * speed -- add / 2 if u want goig back effect

	end
end


---------------------------------------------
--[INDICATOR FUNCTIONS]
---------------------------------------------

---------------------------------------------
--[Indicators]
---------------------------------------------

xpos = 0
xpos1 = 0
xpos2 = 0
xpos3 = 0
xpos4 = 0
ypos1 = 0
ypos2 = 0 
ypos3 = 0
ypos4 = 0
dtalpha = 0
osalpha = 0
baimalpha = 0
fsalpha = 0
offset = 0
offset2 = 0
offset3 = 0
offset4 = 0
local function onscreen_elements()

	screen = {client_screen_size()}
	center = {screen[1]/2, screen[2]/2}

	-------------------
	--DEFAULT LOCALS
	-------------------

	local spacing = 0
	local indi_state = string.upper(xxx)
	local indi_desync = aa_funcs.get_desync(2)
	local acti_indi_state = ui_get(rage[state_to_num[xxx]].c_enabled) and indi_state or 'GLOBAL'
	local lp = entity_get_local_player()
	local r, g, b, a = ui_get(ghettosync.visual.indicator_col)
	local indicatormaster = ui_get(ghettosync.luaenable) and ui_get(ghettosync.visual.indicator_enable)

	local scpd = entity_get_prop(lp, "m_bIsScoped")

	xpos = animation(scoped_default, xpos, 20, 15)
	center[1] = center[1] + xpos

	-------------------
	--DEFAULT LOCALS
	-------------------

	-------------------
	--IDEALYAW LOCALS
	-------------------

	local isFreestanding = ui_get(ref.freestand[2])
	local local_player = entity_get_local_player()
	local active_weapon = entity_get_prop(local_player, "m_hActiveWeapon")
	if active_weapon == nil then
		return
	end
	local nextAttack = entity_get_prop(local_player,"m_flNextAttack")
	local nextShot = entity_get_prop(active_weapon,"m_flNextPrimaryAttack")
	local nextShotSecondary = entity_get_prop(active_weapon,"m_flNextSecondaryAttack")
	if nextAttack == nil or nextShot == nil or nextShotSecondary == nil then
		return
	end
	nextAttack = nextAttack + 0.5
	nextShot = nextShot + 0.5
	nextShotSecondary = nextShotSecondary + 0.5


	-------------------w
	--PIXEL LOCALS
	-------------------
    function lerp(start, vend, time)
	return start + (vend - start) * time 
	end

	local scpd = entity.get_prop(lp, "m_bIsScoped")
	local scoped_pixel = scpd == 1 and ui_get(ghettosync.visual.dynamicindicator) and ui_get(ghettosync.visual.indicatorsselect) == "Classic"

	xpos1 = animation(scoped_pixel, xpos1, 8, 15)
	xpos2 = animation(scoped_pixel, xpos2, 13, 15)
	xpos3 = animation(scoped_pixel, xpos3, 16, 15)
	xpos4 = animation(scoped_pixel, xpos4, 6, 15)
	if scoped_pixel then
		offset = 5
		offset2 = 2
		offset3 = 3
	else 
		offset = 0
		offset2 = 0
		offset3 = 0
	end
	local offsetind = 0
	local offsetbaim = 0
	local offsetfreestand = 0

	-------------------
	--PIXEL LOCALS
	-------------------
	local realtime = globals.realtime() % 3

	local syncalpha = math.min(math.floor(math.sin((globals.realtime() % 3) * 3) * 75 + 150), 255)



	if indicatormaster and entity_is_alive(lp) then
		if ui_get(ghettosync.visual.indicator_enable)then
			if ui.get(ref.dt[2]) and not ui_get(ref.os[2]) then
				--ypos1 = lerp(ypos1,-8,globals.frametime() * 6) 
				dtalpha = lerp(dtalpha,255,globals.frametime() * 6) 
				offsetind = 8
			else
				--ypos1 = lerp(ypos1,8,globals.frametime() * 6) 
				dtalpha = lerp(dtalpha,0,globals.frametime() * 6)
				offsetind = 0
			end
			if dtalpha >= 21 then
				offsetind = 8
			elseif dtalpha <= 20 then
				offsetind = 0
			end
			if ui_get(ref.os[2]) then

				--ypos2 = lerp(ypos2,-8,globals.frametime() * 6) 
				osalpha = lerp(osalpha,255,globals.frametime() * 6) 
				if dtalpha <= 21 then
				offsetbaim = 8
				end
			else
				--ypos2 = lerp(ypos2,8,globals.frametime() * 6) 
				osalpha = lerp(osalpha,0,globals.frametime() * 6)
				offsetbaim = 0
			end
			if ui_get(ref.forcebaim) then
				--ypos3 = lerp(ypos3,-8,globals.frametime() * 6) 
				baimalpha = lerp(baimalpha,255,globals.frametime() * 6) 
				offsetfreestand = 8
			else
				--ypos3 = lerp(ypos3,8,globals.frametime() * 6) 
				baimalpha = lerp(baimalpha,0,globals.frametime() * 6)
				offsetfreestand = 0
			end
			if ui_get(ghettosync.keybinds.key_freestand) then
			--	ypos4 = lerp(ypos4,-8,globals.frametime() * 6) 
				fsalpha = lerp(fsalpha,255,globals.frametime() * 6) 
			else
			--	ypos4 = lerp(ypos4,8,globals.frametime() * 6) 
				fsalpha = lerp(fsalpha,0,globals.frametime() * 6)
			end

			if ui_get(ghettosync.visual.indicatorsselect) == "Classic" then
				local text = renderer_text(center[1] + 24 + xpos2  , center[2] + 14 , r, g, b, 255, "c-", 0, "GHETTO")
				local text2 = renderer_text(center[1] + 47 + xpos2, center[2] + 14 ,230,230, 230, syncalpha, "c-", 0, "SYNC")
				if doubletap_charged() then
					renderer_text(center[1] + 27 + xpos1, center[2] + 22 + ypos1, r, g, b, dtalpha,'c-', 0, 'READY')
					else 
					renderer_text(center[1] + 27 + xpos1, center[2] + 22 + ypos1, 255, 0, 0, dtalpha,'c-', 0, 'READY')
					end
				renderer_text(center[1] + 27 - offset3+ xpos1, center[2] + 22 + ypos2 , r, g, b, osalpha,'c-', 0, 'HIDE')
				renderer_text(center[1] + 27 - offset2 + xpos1, center[2] + 22 + ypos3 + offsetind + offsetbaim, r, g, b, baimalpha,'c-', 0, 'BAIM')
				renderer_text(center[1] + 26 - offset2+ xpos1, center[2] + 22 + ypos4 + offsetind + offsetbaim + offsetfreestand, r, g, b, fsalpha,'c-', 0, 'FREE')
			elseif ui_get(ghettosync.visual.indicatorsselect) == "Modern" then
				-- local text = renderer_text(modernindicatorshow) -- renderer_text(center[1] + 7 , center[2] + 14 , r, g, b, 255, "cb", 0, modernindicatorshow)
				

				local text = renderer_text(center[1] + 9  , center[2] + 14 , r, g, b, 255, "cb", 0, "ghetto")

				local text2 = renderer_text(center[1] + 36  , center[2] + 14 ,230,230, 230, 255, "cb", 0, "sync")
				if ui_get(ghettosync.visual.indicator_enable) and contains(ui_get(ghettosync.visual.keybindsselect), "Keybinds") and not contains(ui_get(ghettosync.visual.keybindsselect), "States") then
					if doubletap_charged() then
					renderer_text(center[1] + 19 , center[2] + 24 + ypos1, r, g, b, dtalpha,'c-', 0, 'DT')
					else 
					renderer_text(center[1] + 19 , center[2] + 24 + ypos1, 255, 0, 0, dtalpha,'c-', 0, 'DT')
					end
					renderer_text(center[1] + 19 , center[2] + 24 + ypos2 , r, g, b, osalpha,'c-', 0, 'OS')
					renderer_text(center[1] + 20, center[2] + 24 + ypos3 + offsetind + offsetbaim, r, g, b, baimalpha,'c-', 0, 'BAIM')
					renderer_text(center[1] + 19 , center[2] + 24 + ypos4 + offsetind + offsetbaim + offsetfreestand, r, g, b, fsalpha,'c-', 0, 'FS')
				elseif ui_get(ghettosync.visual.indicator_enable) and contains(ui_get(ghettosync.visual.keybindsselect), "States") and not contains(ui_get(ghettosync.visual.keybindsselect), "Keybinds") then

					local textstate = renderer_text(center[1]+ 28 + offset3+xpos1, center[2] + 24 ,r, g, b, 255, "c-", 0, acti_indi_state)
				elseif ui_get(ghettosync.visual.indicator_enable) and contains(ui_get(ghettosync.visual.keybindsselect), "States") and contains(ui_get(ghettosync.visual.keybindsselect), "Keybinds") then
					local textstate = renderer_text(center[1]+ 28 + offset3 + xpos1, center[2] + 24  ,r, g, b, 255, "c-", 0, acti_indi_state)
					if doubletap_charged() then
					renderer_text(center[1] + 19 , center[2] + 32 + ypos1, r, g, b, dtalpha,'c-', 0, 'DT')
					else 
					renderer_text(center[1] + 19 , center[2] + 32 + ypos1, 255, 0, 0, dtalpha,'c-', 0, 'DT')
					end
					renderer_text(center[1] + 19 , center[2] + 32 + ypos2 , r, g, b, osalpha,'c-', 0, 'OS')
					renderer_text(center[1] + 20 , center[2] + 32 + ypos3 + offsetind + offsetbaim, r, g, b, baimalpha,'c-', 0, 'BAIM')
					renderer_text(center[1] + 19 , center[2] + 32 + ypos4 + offsetind + offsetbaim + offsetfreestand, r, g, b, fsalpha,'c-', 0, 'FS')
				end

			end
		end
	end
end

---------------------------------------------
--[Manual aa indicator]
---------------------------------------------

local function get_eye_pos(ent)
	local x, y, z = entity_get_prop(ent, "m_vecOrigin")
	local hx, hy, hz = entity_hitbox_position(ent, 0)
	return x, y, hz
end

local function rotate_point(x, y, rot, size)
	return math_cos(math_rad(rot)) * size + x, math_sin(math_rad(rot)) * size + y
end

local function renderer_arrow(x, y, r, g, b, a, rotation, size)
	local x0, y0 = rotate_point(x, y, rotation, 45)
	local x1, y1 = rotate_point(x, y, rotation + (size / 3.5), 45 - (size / 4))
	local x2, y2 = rotate_point(x, y, rotation - (size / 3.5), 45 - (size / 4))
	renderer_triangle(x0, y0, x1, y1, x2, y2, r, g, b, a)
end

mr,mg,mb,ma = 100,100,100,255
mar,mag,mab,maa = 100,100,100,255

xa = 0
rosnie = true

local function manual_aa_arrows()

	if entity_is_alive(entity_get_local_player()) then
		loaded = 1
	end
	if ui_get(ghettosync.luaenable) and loaded == 1 then
		renderer_text(screen[1]/2, screen[2] - 12, 100,100,100, 255, "c", 0, 'GHETTOSYNC | '.. watermarkbuild)
	end


	if ui_get(ghettosync.visual.manual_indicators) and ui_get(ghettosync.luaenable) and entity_is_alive(entity_get_local_player()) then

		local nr,ng,nb,na = ui_get(ghettosync.visual.arrow_col)

		if yaw_direction == 90 then
			mar,mag,mab,maa = nr,ng,nb,na
			mbr,mbg,mbb,ma = 50,50,50,255
			mr,mg,mb,ma = 50,50,50,255
		elseif yaw_direction == -90 then
			mar,mag,mab,maa = 50,50,50,255
			mr,mg,mb,ma = 50,50,50,255
			mbr,mbg,mbb,ma = nr,ng,nb,na
		elseif yaw_direction == 0 then
			mr,mg,mb,ma = nr,ng,nb,na
			mar,mag,mab,maa = 50,50,50,255
			mbr,mbg,mbb,ma = 50,50,50,255
		elseif yaw_direction ~= 90 and yaw_direction ~= 90 then
			mbr,mbg,mbb,ma = 50,50,50,255
			mar,mag,mab,maa = 50,50,50,255

		end
		if ui_get(ghettosync.visual.arrowselect) == "Classic" then
			if yaw_direction ~= 0 then
				renderer_text(screen[1]/2 + 55, screen[2]/2 - 2.5, mar,mag,mab, 255, "c+", 0, '⯈')
				renderer_text(screen[1]/2 - 55, screen[2]/2 - 2.5, mbr,mbg,mbb, 255, "c+", 0, '⯇')
			end
		end
		-- just for ambani :)
		local xr,xg,xb,a = ui_get(ghettosync.visual.arrow_col)
		if ui_get(ghettosync.visual.arrowselect) == "Exclusive" then
			if maleje then
				if xa <=1 then
					rosnie = true
					maleje = false
				end
				xa = xa - 0.75
			elseif rosnie then
				xa = xa + 0.75
				if xa >= 255 then
					rosnie = false
					maleje = true
				end
			end

			if yaw_direction == 90 then
				renderer_text(screen[1]/2 + 55, screen[2]/2 - 1, xr,xg,xb, xa, "c", 0, '⮞')
			elseif yaw_direction == -90 then
				renderer_text(screen[1]/2 - 55, screen[2]/2 - 1, xr,xg,xb, xa, "c", 0, '⮜')
			else
				return
			end
		end


		local cam = vector(client_camera_angles())
		local plocal = entity_get_local_player()
		local h = vector(entity_hitbox_position(plocal, "head_0"))
		local p = vector(entity_hitbox_position(plocal, "pelvis"))

		local yaw = normalize_yaw(calc_angle(p.x, p.y, h.x, h.y) - cam.y + 120)
		local bodyyaw = entity_get_prop(plocal, "m_flPoseParameter", 11) * 120 - 60

		local fakeangle = normalize_yaw(yaw + bodyyaw)
		local r,g,b,a = ui_get(ghettosync.visual.arrow_col)

		if ui_get(ghettosync.visual.arrowselect) == "Modern" then
			renderer_triangle(screen[1]/2 + 55, screen[2]/2 , screen[1]/2 + 42, screen[2]/2 - 6, screen[1]/2 + 42, screen[2]/2 + 8,
			yaw_direction == 90 and r or 35,
			yaw_direction == 90 and g or 35,
			yaw_direction == 90 and b or 35,
			yaw_direction == 90 and a or 150)

			renderer_triangle(screen[1]/2 - 55, screen[2]/2, screen[1]/2 - 42, screen[2]/2 - 6, screen[1]/2 - 42, screen[2]/2 + 8,
			yaw_direction == -90 and r or 35,
			yaw_direction == -90 and g or 35,
			yaw_direction == -90 and b or 35,
			yaw_direction == -90 and a or 150)

			renderer_rectangle(screen[1]/2 + 38, screen[2]/2 - 6, 2, 14,
			bodyyaw < 0 and r or 35,
			bodyyaw < 0 and g or 35,
			bodyyaw < 0 and b or 35,
			bodyyaw < 0 and a or 150)
			renderer_rectangle(screen[1]/2 - 40, screen[2]/2 - 6, 2, 14,
			bodyyaw > 0 and r or 35,
			bodyyaw > 0 and g or 35,
			bodyyaw > 0 and b or 35,
			bodyyaw > 0 and a or 150)
		end
	end
end

---------------------------------------------
--[INDICATORS]
---------------------------------------------



local function set_lua_menu()
	local lua_enabled = ui_get(ghettosync.luaenable)

	ui_set_visible(ghettosync.tabselect, lua_enabled)
	ui_set_visible(ghettosync.animacjalabel, lua_enabled)
	--returns true or false
	local builder = ui_get(ghettosync.antiaim.aa_presets) == 'Builder' and lua_enabled
	local bossmode = ui_get(ghettosync.antiaim.aa_presets) == "Bossmode" and lua_enabled
	local alternative = ui_get(ghettosync.antiaim.aa_presets) == "Alternative" and lua_enabled
	local select_Hotkeys = ui_get(ghettosync.tabselect) == 'Hotkeys' and lua_enabled
	local select_aa = ui_get(ghettosync.tabselect) == 'Anti-Aim' and lua_enabled
	local select_visuals = ui_get(ghettosync.tabselect) == 'Visuals' and lua_enabled
	local select_misc = ui_get(ghettosync.tabselect) == 'Misc' and lua_enabled
	local select_config = ui_get(ghettosync.tabselect) == 'Config' and lua_enabled
	local exportvis = ui_get(ghettosync.tabselect) == 'Config' and ui_get(ghettosync.antiaim.aa_presets) == "Builder" and lua_enabled

	--------------
	-- Hotkeys
	--------------
	ui_set_visible(ghettosync.keybinds.key_defensive, select_Hotkeys)
	ui_set_visible(ghettosync.keybinds.key_legit, select_Hotkeys)
	ui_set_visible(ghettosync.keybinds.key_freestand, select_Hotkeys)
	ui_set_visible(ghettosync.keybinds.key_back, select_Hotkeys)
	ui_set_visible(ghettosync.keybinds.key_left, select_Hotkeys)
	ui_set_visible(ghettosync.keybinds.key_right, select_Hotkeys)

	--------------
	-- ANTI-AIM
	--------------
	ui_set_visible(ghettosync.antiaim.aa_condition, builder and select_aa)
	ui_set_visible(ghettosync.antiaim.aa_presets, select_aa)
	ui_set_visible(ghettosync.antiaim.fl_limitslider, ui_get(ghettosync.luaenable))
	ui_set_visible(bossmode_builder, bossmode and select_aa)
	ui_set_visible(alternative_builder, alternative and select_aa)
	--------------
	-- VISUAL
	--------------
	ui_set_visible(ghettosync.visual.indicator_enable, select_visuals)
	ui_set_visible(ghettosync.visual.indicator_col, select_visuals and ui_get(ghettosync.visual.indicator_enable))
	ui_set_visible(ghettosync.visual.manual_indicators, select_visuals)
	ui_set_visible(ghettosync.visual.toggle_notificiations, select_visuals)
	ui_set_visible(ghettosync.visual.keybindsselect, select_visuals and ui_get(ghettosync.visual.indicator_enable) and ui_get(ghettosync.visual.indicatorsselect) ~= "Classic")
	ui_set_visible(ghettosync.visual.dynamicindicator, select_visuals and ui_get(ghettosync.visual.indicator_enable) and ui_get(ghettosync.visual.indicatorsselect) == "Classic")
	ui_set_visible(ghettosync.visual.arrowselect, select_visuals and ui_get(ghettosync.visual.manual_indicators))
	ui_set_visible(ghettosync.visual.arrow_col, select_visuals and ui_get(ghettosync.visual.manual_indicators))
	ui_set_visible(ghettosync.visual.notif_col, select_visuals and ui_get(ghettosync.visual.toggle_notificiations))
	ui_set_visible(ghettosync.visual.indicatorsselect, select_visuals and ui_get(ghettosync.visual.indicator_enable))

	--------------
	-- MISC
	--------------
	ui_set_visible(ghettosync.misc.animator, select_misc)
	ui_set_visible(ghettosync.misc.enable_clan_tag, select_misc)
	ui_set_visible(ghettosync.misc.leg_break, select_misc)
	--ui_set_visible(ghettosync.misc.debug, select_misc)
	--------------
	-- CONFIG
	--------------
	ui_set_visible(import_cfg, select_config)
	ui_set_visible(export_cfg, exportvis)
end


---------------------------------------------
--[CALLBACKS]
---------------------------------------------
local last = 0
local l_jitteradd = 0
local r_jitteradd = 0
local yaw_dir_rem1, yaw_dir_rem2




client_set_event_callback('paint_ui', function()
--set_menu_color()
set_lua_menu()
hide_original_menu(not ui_get(ghettosync.luaenable))

end)

client_set_event_callback('pre_config_save', function()
--database_write('ghettosync_color', colours.lightblue)
end)



client_set_event_callback('setup_command', function(e)
local state = get_mode(e)
local localplayer = entity_get_local_player()

if localplayer == nil or not entity_is_alive(localplayer) or not ui_get(ghettosync.luaenable) then
	return
end

ui_set(ref.enabled, true)
state = ui_get(rage[state_to_num[state]].c_enabled) and state_to_num[state] or state_to_num['Global']


local current = globals_curtime()


if ui.get(rage[state].c_jitter) == "Left & Right Center" then
	if ui.get(rage[state].l_jitter) == 0 then
		l_jitteradd = -1
	elseif ui.get(rage[state].l_jitter) >= 0 then
		l_jitteradd = -1*(math.abs(ui.get(rage[state].l_jitter)))
	elseif ui.get(rage[state].l_jitter) <= 0 then
		l_jitteradd = ui.get(rage[state].l_jitter)
	end

elseif ui.get(rage[state].c_jitter) ~= "Left & Right Center" and ui.get(rage[state].c_jitter) ~= "Left & Right Offset" then
	r_jitteradd = math.abs(ui.get(rage[state].l_limit))
end

if ui.get(rage[state].c_jitter) == "Left & Right Offset" then
	if ui.get(rage[state].l_jitter) == 0 then
		l_jitteradd = -1
	elseif ui.get(rage[state].l_jitter) >= 0 then
		l_jitteradd = -1*(math.abs(ui.get(rage[state].l_jitter)))
	elseif ui.get(rage[state].l_jitter) <= 0 then
		l_jitteradd = ui.get(rage[state].l_jitter)
	end

elseif ui.get(rage[state].c_jitter) ~= "Left & Right Offset" and ui.get(rage[state].c_jitter) ~= "Left & Right Center"then
	r_jitteradd = math.abs(ui.get(rage[state].l_limit))
end


if ui.get(rage[state].c_jitter) == "Left & Right Center" then
	r_jitteradd = math.abs(ui.get(rage[state].r_jitter))

elseif ui.get(rage[state].c_jitter) ~= "Left & Right Center" and ui.get(rage[state].c_jitter) ~= "Left & Right Offset"  then
	r_jitteradd = math.abs(ui.get(rage[state].r_limit))
end

if ui.get(rage[state].c_jitter) == "Left & Right Offset" then
	r_jitteradd = math.abs(ui.get(rage[state].r_jitter))

elseif ui.get(rage[state].c_jitter) ~= "Left & Right Center" and ui.get(rage[state].c_jitter) ~= "Left & Right Offset" then
	r_jitteradd = math.abs(ui.get(rage[state].r_limit))
end




if not ui.get(rage[state].lr_limit) then
	if state ~=8 then
		ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].c_yaw_sli) or yaw_direction)
	else
		ui.set(ref.yaw[2], ui.get(rage[state].c_yaw_sli))
	end
end
if ui.get(rage[state].c_jitter) == "Left & Right Center" then

	ui_set(ref.yawjitter[1], "center")
	if ui_get(ref.yawjitter[2]) >= 0 then
		ui_set(ref.yawjitter[2], l_jitteradd)
	elseif ui_get(ref.yawjitter[2]) <= 0 then
		ui_set(ref.yawjitter[2], r_jitteradd)
	end
elseif  ui.get(rage[state].c_jitter) == "Left & Right Offset" then
	ui_set(ref.yawjitter[1], "offset")
	if ui_get(ref.yawjitter[2]) >= 0 then
		ui_set(ref.yawjitter[2], l_jitteradd)
	elseif ui_get(ref.yawjitter[2]) <= 0 then
		ui_set(ref.yawjitter[2], r_jitteradd)
	end
else
	ui_set(ref.yawjitter[1], ui_get(rage[state].c_jitter))
	ui_set(ref.yawjitter[2], ui_get(rage[state].c_jitter_sli))
end




local force_def = ui_get(ghettosync.keybinds.key_defensive)

if force_def then
	force_defensive = 1;
	no_choke = 1;
	quick_stop = 1;
else
	force_defensive = 0;
	no_choke = 0;
	quick_stop = 0;
end

if ui_get(rage[state].lr_limit) then
	if not ui_get(rage[state].hybrid_fs) then
		ui.set(rage[state].c_free_b_yaw, true)
	else
		ui.set(rage[state].c_free_b_yaw, false)
	end
end

if desync_side == 1 or brute.best_angle == 1 then
	--left
	if ui_get(rage[state].l_desync_limit) ~= 60 then
	ui_set(ref.fakeyawlimit, ui_get(rage[state].l_desync_limit))
	else
		ui_set(ref.fakeyawlimit, 59)
	end
elseif desync_side == -1 or brute.best_angle == 2 then
	--right
	if ui_get(rage[state].r_desync_limit) ~= 60 then
		ui_set(ref.fakeyawlimit, ui_get(rage[state].r_desync_limit))
		else
			ui_set(ref.fakeyawlimit, 59)
		end
end
if desync_side == 2 then
	desync_side = -1
end

if ui_get(rage[state].lr_limit) and e.chokedcommands == 0 then

	if desync_side == 1 or brute.best_angle == 1 then
		--left
		if state ~=8 then
			ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].l_limit) or yaw_direction)
		else
			ui.set(ref.yaw[2], ui.get(rage[state].l_limit))
		end
	elseif desync_side == -1 or brute.best_angle == 2 then
		--right
		if state ~=8 then
			ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].r_limit) or yaw_direction)
		else
			ui.set(ref.yaw[2], ui.get(rage[state].r_limit))
		end
	end
	if desync_side == 2 then
		desync_side = -1
	end
end

ui_set(ref.pitch, ui_get(rage[state].c_pitch))
ui_set(ref.yawbase, ui_get(rage[state].c_yawbase))
ui_set(ref.yaw[1], ui_get(rage[state].c_yaw))
ui_set(ref.bodyyaw[1], ui_get(rage[state].c_body))
ui_set(ref.bodyyaw[2], ui_get(rage[state].c_body_sli))
ui_set(ref.fsbodyyaw, ui_get(rage[state].c_free_b_yaw))

handle_keybinds()
run_direction()

end)

client_set_event_callback('paint', function()
onscreen_elements()
end)

client_set_event_callback("bullet_impact", function(e)
brute_impact(e)
end)

local function init_callbacks()
	ui_set_callback(ghettosync.luaenable, handle_menu)
	ui_set_callback(ghettosync.antiaim.aa_condition, handle_menu)
	ui_set_callback(ghettosync.visual.manual_indicators, manual_aa_arrows)
	ui_set_callback(ghettosync.visual.indicatorsselect, handle_menu)
	ui_set_callback(ghettosync.antiaim.aa_presets, handle_menu)
	ui_set_callback(ghettosync.tabselect, handle_menu)
	ui_set_callback(ref.load_cfg, handle_menu)

	for i=1, #aa_config do
		ui_set_callback(rage[i].c_yaw, handle_menu)
		ui_set_callback(rage[i].c_jitter, handle_menu)
		ui_set_callback(rage[i].c_body, handle_menu)
		ui_set_callback(rage[i].c_enabled, handle_menu)
		ui_set_callback(rage[i].lr_limit, handle_menu)
	end
end
client_set_event_callback("setup_command", leg_breaker)
client_set_event_callback('paint', manual_aa_arrows)
client_set_event_callback('post_render', animacjaplay)
init_callbacks()

client_set_event_callback('pre_render', function()
if entity_get_local_player() ~= nil and ui_get(ghettosync.misc.animator) then
	if air(entity_get_local_player()) then
		entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 6)
	else
		entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1, 0)
	end
end
end)


local function main()
	client_set_event_callback("run_command", function()
	get_best_enemy()
	get_best_angle()
	end)

	client_set_event_callback("bullet_impact", function(e)
	brute_impact(e)
	end)

	client_set_event_callback("shutdown", function()
	hide_original_menu(true)
	end)

	client_set_event_callback("player_death", function(e)
	brute_death(e)
	if client_userid_to_entindex(e.userid) == entity_get_local_player() then
		if ui_get(ghettosync.visual.toggle_notificiations) then
			ghettosync_push:paint(5, "Reset data due to death")
		end
		brute.reset()
	end
	end)

	client_set_event_callback("round_start", function()
	local me = entity_get_local_player()
	if not entity_is_alive(me) then return end
	lastlocal = 0
	lastdt = 0
	brute.reset()
	end)

	client_set_event_callback("client_disconnect", function()
	brute.reset()
	end)

	client_set_event_callback("game_newmap", function()
	if ui_get(ghettosync.visual.toggle_notificiations) then
		ghettosync_push:paint(5, "Reset data due to new map")
	end
	brute.reset()
	end)


	client_set_event_callback("cs_game_disconnected", function()
	brute.reset()
	end)
end

if obex_data.username == "Yas" then
	local test = ui_new_button("LUA", "B", "test notif", function()
	--ghettosync_push:paint(5, "Reset data due to death")
	--ghettosync_push:paint(5,"Switched due to Anti-Bruteforce")
	--ghettosync_push:paint(5, "Reset data due to importing anti-aim settings.")
	delayednotif()
	end)

end
--[[client.set_event_callback('paint', function()
	local ref = {
	--	pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
		yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
		yaw_slider = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw")),
		--yaw_jitter = select(1, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
		--yaw_jitter_add = select(2, ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")),
		--body_yaw = select(1, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
		--body_yaw_slider = select(2, ui.reference("AA", "Anti-aimbot angles", "Body yaw")),
	--	Freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw"),
	--	fakelimit = ui.reference("AA", "Anti-aimbot angles", "Fake yaw limit"),
		}
	
		local final_text = ''
	
		for key, val in pairs(ref) do
			final_text = string.format('%s\n[%s] - %s', final_text, key, ui.get(val))
		end
		if entity_is_alive(entity_get_local_player()) then
		
		if ui_get(ghettosync.misc.debug) then
		--renderer.text(1400, 610, 255, 255, 255, 255, 'cb', 0, "[desync side]: " .. desync_side)
		--renderer.text(1400, 620, 255, 255, 255, 255, 'cb', 0, "[bruteforce]: " .. brute.best_angle)
		--renderer.text(1400, 630, 255, 255, 255, 255, 'cb', 0, "[l jtiter]: " .. l_jitteradd)
		--renderer.text(1400, 640, 255, 255, 255, 255, 'cb', 0, "[r jitter]: " .. r_jitteradd)
		renderer.text(1400, 640, 255, 255, 255, 255, 'cb', 0, "[yaw]: " .. aa_funcs.get_abs_yaw())
		
		renderer.text(1400, 650, 255, 255, 255, 255, 'cb', 0, "[desync]: " .. aa_funcs.get_desync(1))
		renderer.text(1400, 660, 255, 255, 255, 255, 'cb', 0, "[Client body yaw]: " .. 	aa_funcs.get_body_yaw(1))
		renderer.text(1400, 670, 255, 255, 255, 255, 'cb', 0, "[Server body yaw]: " .. 	aa_funcs.get_body_yaw(2))
		renderer.text(1400, 680, 255, 255, 255, 255, 'cb', 0, "[Overlap]: " .. aa_funcs.get_overlap(float))
		renderer.text(1400, 690, 255, 255, 255, 255, 'cb', 0, final_text)
		end
	end
	 
	end)]]--
	
main()