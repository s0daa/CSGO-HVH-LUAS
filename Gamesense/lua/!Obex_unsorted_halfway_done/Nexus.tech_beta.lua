-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local inspect = require 'gamesense/inspect'
local c_entity = require("gamesense/entity")
local http = require "gamesense/http"
local base64 = require("gamesense/base64")
local surface = require("gamesense/surface")
local images = require ("gamesense/images")
local csgo_weapons = require "gamesense/csgo_weapons"
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local function contains_selected(b,c)for d,e in pairs(b)do if e==c then return true end end;return false end 

local client_camera_angles, client_create_interface, client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_player_name, entity_get_prop, entity_is_alive, globals_chokedcommands, globals_realtime, globals_tickcount, globals_tickinterval, math_abs, math_ceil, math_floor, string_format, string_lower, table_concat, table_insert, ui_new_checkbox, ui_reference, error, pairs, plist_get, ui_get, print, ui_set_callback = client.camera_angles, client.create_interface, client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_player_name, entity.get_prop, entity.is_alive, globals.chokedcommands, globals.realtime, globals.tickcount, globals.tickinterval, math.abs, math.ceil, math.floor, string.format, string.lower, table.concat, table.insert, ui.new_checkbox, ui.reference, error, pairs, plist.get, ui.get, print, ui.set_callback

local obex_data = obex_fetch and obex_fetch() or {username = 'admin', build = 'debug', discord=''}

client.set_event_callback('paint', function()

    local screen_size = vector(client.screen_size())
    local username = (('%s  -  %s'):format(obex_data.username, obex_data.build)):upper()
end)

if obex_data.build == "Debug" then
    obex_data.build = "alpha"
end

if obex_data.build == "Live" or obex_data.build == "Beta" then
	tabs = {"Anti-aim", "Visuals"}
else
	tabs = {"Anti-aim", "Visuals", "Misc & features"}	
end

RGBAtoHEX = function(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end	
local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
	local output = ''
	
	local len = #text - 1
	
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


local ctx = (function()
	local ctx = {}


	ctx.helpers = {
	
		clamp = function(self, val, lower, upper)
			assert(val and lower and upper, "not very useful error message here")
			if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
			return math.max(lower, math.min(upper, val))
		end,
		
		rgba_to_hex = function(self, r, g, b, a)
		  return bit.tohex(
		    (math.floor(r + 0.5) * 16777216) + 
		    (math.floor(g + 0.5) * 65536) + 
		    (math.floor(b + 0.5) * 256) + 
		    (math.floor(a + 0.5))
		  )
		end,

		hex_to_rgba = function(self, hex)
    	local color = tonumber(hex, 16)

    	return 
        math.floor(color / 16777216) % 256, 
        math.floor(color / 65536) % 256, 
        math.floor(color / 256) % 256, 
        color % 256
		end,

		color_text = function(self, string, r, g, b, a)
			local accent = "\a" .. self:rgba_to_hex(r, g, b, a)
			local white = "\a" .. self:rgba_to_hex(255, 255, 255, a)

			local str = ""
			for i, s in ipairs(self:split(string, "$")) do
				str = str .. (i % 2 ==( string:sub(1, 1) == "$" and 0 or 1) and white or accent) .. s
			end

			return str
		end,

		animate_text = function(self, time, string, r, g, b, a)
			local t_out, t_out_iter = { }, 1

			local l = string:len( ) - 1
	
			local r_add = (255 - r)
			local g_add = (255 - g)
			local b_add = (255 - b)
			local a_add = (0 - a)
	
			for i = 1, #string do
				local iter = (i - 1)/(#string - 1) + time
				t_out[t_out_iter] = "\a" .. ctx.helpers:rgba_to_hex( r + r_add * math.abs(math.cos( iter )), g + g_add * math.abs(math.cos( iter )), b + b_add * math.abs(math.cos( iter )), a + a_add * math.abs(math.cos( iter )) )
	
				t_out[t_out_iter + 1] = string:sub( i, i )
	
				t_out_iter = t_out_iter + 2
			end
	
			return t_out
		end,
	}
	
	ctx.m_render = {
		rec = function(self, x, y, w, h, radius, color)
			radius = math.min(x/2, y/2, radius)
			local r, g, b, a = unpack(color)
			renderer.rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
			renderer.rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
			renderer.rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
			renderer.circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
			renderer.circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
			renderer.circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
			renderer.circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
		end,

		rec_outline = function(self, x, y, w, h, radius, thickness, color)
			radius = math.min(w/2, h/2, radius)
			local r, g, b, a = unpack(color)
			if radius == 1 then
				renderer.rectangle(x, y, w, thickness, r, g, b, a)
				renderer.rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
			else
				renderer.rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
				renderer.rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
				renderer.circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
				renderer.circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
				renderer.circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
			end
		end,

		glow_module = function(self, x, y, w, h, width, rounding, accent, accent_inner)
			local thickness = 1
			local offset = 1
			local r, g, b, a = unpack(accent)
			if accent_inner then
				self:rec(x , y, w, h + 1, rounding, accent_inner)
				--renderer.blur(x , y, w, h)
				--m_render.rec_outline(x + width*thickness - width*thickness, y + width*thickness - width*thickness, w - width*thickness*2 + width*thickness*2, h - width*thickness*2 + width*thickness*2, color(r, g, b, 255), rounding, thickness)
			end
			for k = 0, width do
				if a * (k/width)^(1) > 5 then
					local accent = {r, g, b, a * (k/width)^(2)}
					self:rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
				end
			end
		end
	}
	
	return ctx
end)()




-- color inicial: #8fbeff  -  143, 190, 255, 255
-- color final: #1b1d21  -  41, 43, 48, 255

local SM4 = gradient_text(143, 190, 255, 255, 143, 190, 255, 255, "Nexus" )

local btn = {}

btn.lb1 = ui.new_label("AA", "Anti-aimbot angles", " ")

local lua_enable = ui.new_checkbox("AA", "Anti-aimbot angles", " \ad7acddFF| "..SM4.." \ad7acddFF| - \ad7acddFF" ..obex_data.username)

ui.set(lua_enable, true)
ui.set_visible(lua_enable, false)

local ref = {
	enabled = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch"),
	roll = ui.reference("AA", "Anti-aimbot angles", "Roll"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = {ui.reference("AA", "Anti-aimbot angles", "Yaw")},
 	fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
	edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
	fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	safepoint = ui.reference("RAGE", "Aimbot", "Force safe point"),
	forcebaim = ui.reference("RAGE", "Aimbot", "Force body aim"),
	player_list = ui.reference("PLAYERS", "Players", "Player list"),
	reset_all = ui.reference("PLAYERS", "Players", "Reset all"),
	bhop = ui.reference('MISC', 'Movement', 'Bunny hop'),
	apply_all = ui.reference("PLAYERS", "Adjustments", "Apply to all"),
	load_cfg = ui.reference("Config", "Presets", "Load"),
	fl_limit = ui.reference("AA", "Fake lag", "Limit"),
	dt_limit = ui.reference("RAGE", "Aimbot", "Double tap fake lag limit"),
	leg_movement = ui.reference("AA", "Other", "Leg movement"),
	quickpeek = {ui.reference("RAGE", "Other", "Quick peek assist")},
	yawjitter = {ui.reference("AA", "Anti-aimbot angles", "Yaw jitter")},
	bodyyaw = {ui.reference("AA", "Anti-aimbot angles", "Body yaw")},
	freestand = {ui.reference("AA", "Anti-aimbot angles", "Freestanding")},
	os = {ui.reference("AA", "Other", "On shot anti-aim")},
	slow = {ui.reference("AA", "Other", "Slow motion")},
	dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
	ps = {ui.reference("RAGE", "Aimbot", "Double tap")},
	body_yaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	Fakelag = {ui.reference("AA", "Fake lag", "Limit")},
	fakelag_legs = ui.reference("AA", "Fake lag", "Limit"),
	
	min_dmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
	hitchance = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),	
}
local aa_init = {}
local aa_config = {'Shared', 'Standing', 'Slow motion', 'Running' , 'Air', 'Air crouch', 'Crouching' }
local bruteforce_phases = {"Phase 1", "Phase 2", "Phase 3", "Phase 4", "Phase 5"}
local rage = {}
local bf = {}

local bf_state_to_num = {
	['Phase 1'] = 1,
    ['Phase 2'] = 2,
    ['Phase 3'] = 3,
    ['Phase 4'] = 4,
    ['Phase 5'] = 5,
}

local state_to_num = { 
    ['Shared'] = 1,
    ['Standing'] = 2,
    ['Slow motion'] = 3,
    ['Running'] = 4,
    ['Air'] = 5,
    ['Air crouch'] = 6,
    ['Crouching'] = 7,
}

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

local function table_contains(tbl, val)
    for i=1,#tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

btn.lb6 = ui.new_label("AA", "Anti-aimbot angles", "\a42454fFFWelcome back to \a8FBEFFFFNexus\a42454fFF, "..obex_data.username.."")
btn.lb2 = ui.new_label("AA", "Anti-aimbot angles", "\a42454fFF\a42454fFFCurrent build: \a8FBEFFFF"..obex_data.build.."" )
btn.lb3 = ui.new_label("AA", "Anti-aimbot angles", "\a42454fFFLast update: \a8FBEFFFF2023-02-17")
btn.lb5 = ui.new_label("AA", "Anti-aimbot angles", " ")

aa_vis = false
visuals_vis = false
misc_vis = false
back_vis = false
config_vis = false

btn.back_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFBack", function()

	aa_vis = false
	visuals_vis = false
	misc_vis = false
	config_vis = false
	ui.set_visible(btn.aa_btn, true)
	ui.set_visible(btn.visuals_btn, true)
	ui.set_visible(btn.config_btn, true)
	ui.set_visible(btn.misc_btn, true)
	ui.set_visible(btn.back_btn, false)
end)
ui.set_visible(btn.back_btn, false)

btn.aa_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFAnti-aim", function() 
	aa_vis = true
	back_vis = true
	ui.set_visible(btn.aa_btn, false)
	ui.set_visible(btn.visuals_btn, false)
	ui.set_visible(btn.misc_btn, false)
	ui.set_visible(btn.config_btn, false)
	ui.set_visible(btn.back_btn, true)
end)
btn.visuals_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFVisuals", function()
	visuals_vis = true
	back_vis = true
	ui.set_visible(btn.aa_btn, false)
	ui.set_visible(btn.visuals_btn, false)
	ui.set_visible(btn.misc_btn, false)
	ui.set_visible(btn.config_btn, false)
	ui.set_visible(btn.back_btn, true)
end)
btn.misc_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFMisc", function()
	back_vis = true
	misc_vis = true
	ui.set_visible(btn.aa_btn, false)
	ui.set_visible(btn.visuals_btn, false)
	ui.set_visible(btn.misc_btn, false)
	ui.set_visible(btn.config_btn, false)
	ui.set_visible(btn.back_btn, true)
end)

btn.config_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFConfigs", function()
	back_vis = true
	config_vis = true
	ui.set_visible(btn.aa_btn, false)
	ui.set_visible(btn.visuals_btn, false)
	ui.set_visible(btn.config_btn, false)
	ui.set_visible(btn.misc_btn, false)
	ui.set_visible(btn.back_btn, true)
end)

btn.lb8 = ui.new_label("AA", "Anti-aimbot angles", " ")
local aacat = ui.new_combobox("AA", "Anti-aimbot angles", "\a4F4F4FFF ~   \a8FBEFFFFAnti-aim categories", "Builder", "Anti-bruteforce", "Extras", "Exploits")
local anim = ui.new_combobox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFLegs breaker", "Off", "Moonwalk", "Follow direction", "Ice")
local anim_old = ui.new_multiselect("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFOld animations", {"Static legs in-air", "Pitch 0 on-land", "Fakeduck breaker on shot"})

local ui_stuff = {
	watermark_enable = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFWatermark"),
	wtr_clr_1 = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFWatermark color"),
	wtr_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFWatermark text color", 255, 255, 255, 255),
	wtr_clr_bg1 = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFWatermark background color"),
	wtr_clr_bg = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFWatermark background color", 8, 8, 7, 140),
	crosshair_inds = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFIndicators"),
	inds_selct = ui.new_combobox("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators", { "Off", "Stylish", "Bloom", "Modern", "Old", "Alternative"}),
	main_clr_l = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators color"),
	main_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators color", 255, 255, 255, 255),
	main_clr_2 = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators secondary color"),
	main_clr2 = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators secondary color", 255, 255, 255, 255),
	dsy_clr_lbl = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFDesync bar color"),
	dsy_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFDesync bar color", 255, 255, 255, 255),
	glow_clr_l = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators glow color"),
	glow_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFIndicators glow color", 255, 255, 255, 255),
	arrw_selct = ui.new_combobox("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFArrow style", { "Off", "Small", "Classic", "Modern", "Triangle", "Teamskeet" }),
	draw_arrows = ui.new_checkbox("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFAlways draw arrows"),
	arrows_clr_lbl = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFArrows color"),
	arrows_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFArrows color", 120, 200, 255, 255),
	ts_arrows_clr_lbl = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFDesync line color"),
	ts_arrows_clr = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFDesync line color", 255, 255, 255, 255),	
	moonwalk_air = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFMoonwalk in air"),
	trashtalk = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFTrashtalk"),
	tele = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFExtended teleport"),
	tele_key = ui.new_hotkey("AA", "Anti-aimbot angles","\a4F4F4FFF ~  \a42454fFFExtended teleport hotkey"),
	anti_knife = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFAvoid backstab"),
	debug_panel = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFDebug panel"),
	exploit_select = ui.new_combobox('AA','Anti-aimbot angles', SM4.." \a4F4F4FFF ~  \a42454fFFExploit selector", {"Defensive anti-aim", "Pitch exploit"}),
	defensive_aa_key = ui.new_hotkey("AA", "Anti-aimbot angles","\a4F4F4FFF ~  \a42454fFFDefensive AA hotkey"),
	defensive_lbl = ui.new_label("AA", "Anti-aimbot angles", " "),
	defensive_yaw = ui.new_combobox('aa', 'anti-aimbot angles', '\a8FBEFFFF Defensive anti-aim  \a4F4F4FFF ~  \a42454fFFYaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
	defensive_pitch = ui.new_combobox('aa', 'anti-aimbot angles', '\a8FBEFFFF Defensive anti-aim  \a4F4F4FFF ~  \a42454fFFPitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
	esploit2 = ui.new_hotkey("AA", "Anti-aimbot angles","\a4F4F4FFF ~  \a42454fFFPitch exploit hotkey"),
	panel_font = ui.new_combobox("AA", "Anti-aimbot angles", "Debug panel font", { "regular", "bold" }),
	loger = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFAimbot logs"),
	loger2 = ui.new_multiselect("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFLogger", "Console", "Pop Up"),
	popaps = ui.new_combobox("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFPop Ups", { "Centered", "Left screen" }),
	glow_enabled = ui_new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFEnable glow"),

	glow_text = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFGlow color"),
	glow_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFGlow color", 135, 175, 255, 255),
	
	hit_text = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFPop Ups hit color"),
	hit_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFPop Ups hit color", 95, 255, 160, 255),
	
	miss_text = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFPop Ups miss color"),
	miss_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFPop Ups miss color", 255, 95, 155, 255),

	background_text = ui.new_label("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFBackground color"),
	background_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\a4F4F4FFF ~  \a42454fFFBackground color", 8, 8, 7, 140),
}


aa_init[0] = {
	aa_dir   = 0,
	last_press_t = 0,
	manuals = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFHotkeys"),
	manual_left = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8FBEFFFFLeft \a42454fFFhotkey"),
	manual_right = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8FBEFFFFRight \a42454fFFhotkey"),
	manual_re = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8FBEFFFFReset \a42454fFFhotkey"),
	manual_forward = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8FBEFFFFForward \a42454fFFhotkey"),
	fs = ui.new_hotkey("AA", "Anti-aimbot angles", "\a8FBEFFFFFreestand \a42454fFFhotkey"),
	fs_disablers = ui.new_multiselect("AA", "Anti-aimbot angles", "\a8FBEFFFFFreestanding \a42454fFFdisablers", "Standing", "Slowwalk", "In air", "Crouching"),
	fast_weapon_switch = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFFast weapon swap"),
	invalid_bt_ticks = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFInvalidate ticks in air"),
	defensive_inair = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFForce defensive in air"),
	fix_hs = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFBetter on-shot"),
	legit_aa = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFLegit AA on use"),
	aa_builder = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFConditional anti-aim"),
	brute_enable = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFAnti-bruteforce"),
	hide_builder = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFHide anti-aim builder"),
	team = ui.new_combobox('AA','Anti-aimbot angles', '\a8FBEFFFFTeam', {"CT","T"}),
	aa_condition = ui.new_combobox('AA','Anti-aimbot angles', '\a8FBEFFFFAnti-aim condition', aa_config),
	brute_phases = ui.new_combobox('AA','Anti-aimbot angles', '\a8FBEFFFFAnti-bruteforce phase', bruteforce_phases),
	aas = ui.new_checkbox("AA", "Anti-aimbot angles", SM4.." \a4F4F4FFF ~  \a42454fFFSpaghetti mode"),
}

client.set_event_callback('grenade_thrown', function(e)
	if ui.get(aa_init[0].fast_weapon_switch) then
		local lp = entity.get_local_player();
		local userid = client.userid_to_entindex(e.userid);
		
		if userid ~= lp then
			return
		end
		client.exec('slot3; slot2; slot1');
	end
end);

client.set_event_callback('weapon_fire', function(e)
	if ui.get(aa_init[0].fast_weapon_switch) then
		if e.weapon ~= 'weapon_taser' then
			return
		end
		
		local lp = entity.get_local_player();
		local userid = client.userid_to_entindex(e.userid);
		
		if userid ~= lp then
			return
		end
		client.exec('slot3; slot2; slot1');
	end
end);

for v=1, #bruteforce_phases do
    
    local cond_bf = "\a8FBEFFFF"..bruteforce_phases[v]..""
	
    bf[v] = {

		bf_enable_aa = ui.new_checkbox('aa', 'anti-aimbot angles', 'Enable ' .. bruteforce_phases[v] .. ' \aFFFFFFFFcondition'),
        bf_c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFPitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        bf_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw base', {'Local view','At targets'}),
        bf_yaw = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        bf_yaw_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw type', {'Left & Right', '3-Way','5-Way'}),
        bf_left_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFLeft yaw', -180, 180, 0, true, '°'),
        bf_right_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFRight yaw', -180, 180, 0, true, '°'),
		bf_yaw_3way_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw 1', -180, 180, 0, true, '°', 1),
		bf_yaw_3way_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw 2', -180, 180, 0, true, '°', 1),
		bf_yaw_3way_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw 3', -180, 180, 0, true, '°', 1),
		bf_yaw_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw offset 1', -180, 180, 0, true, '°', 1),
        bf_yaw_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw offset 2', -180, 180, 0, true, '°', 1),
        bf_yaw_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw offset 3', -180, 180, 0, true, '°', 1),
        bf_yaw_4 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw offset 4', -180, 180, 0, true, '°', 1),
        bf_yaw_5 = ui.new_slider('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw offset 5', -180, 180, 0, true, '°', 1),
        
		bf_jitter = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw jitter', {'Off','Offset','Center','Random'}),
        bf_jitter_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFYaw jitter type', {'Static', 'Left & Right'}),
		bf_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_bf .. '\a4F4F4FFF ~  \a42454FFFYaw jitter slider', -180, 180, 0, true, '°', 1),
        
        bf_left_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_bf .. '\a4F4F4FFF ~  \a42454FFFLeft jitter slider', -180, 180, 0, true, '°', 1),
		bf_right_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_bf .. '\a4F4F4FFF ~  \a42454FFFRight jitter slider', -180, 180, 0, true, '°', 1),
		
        bf_body = ui.new_combobox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~ \a42454FFFBody yaw', {'Off','Opposite','Jitter','Static'}),
        bf_freestand_byaw = ui.new_checkbox('aa', 'anti-aimbot angles', cond_bf..'\a4F4F4FFF ~  \a42454FFFFreestanding body yaw'),
       
	}	
end
local function handle_menu_bf()
    local bf_enabled = aa_vis and ui.get(aa_init[0].brute_enable)
    ui.set_visible(aa_init[0].brute_phases, bf_enabled and ui.get(aacat) == "Anti-bruteforce")
	
    for v=1, #bruteforce_phases do
		local bf_condition_enable = ui.get(bf[v].bf_enable_aa)
        local bf_show_enb = bf_enabled and ui.get(aacat) == "Anti-bruteforce" and ui.get(aa_init[0].brute_phases) == bruteforce_phases[v]
        local bf_show = bf_enabled and ui.get(aacat) == "Anti-bruteforce" and ui.get(aa_init[0].brute_phases) == bruteforce_phases[v]
		
		if ui.get(aa_init[0].brute_phases) == "Phase 1" then
			setvis_bf = bf_show
		else
			setvis_bf = bf_show and bf_condition_enable
		end
		
		ui.set_visible(bf[v].bf_enable_aa, bf_show_enb and v > 1)
		ui.set_visible(bf[v].bf_c_pitch, setvis_bf)
		ui.set_visible(bf[v].bf_yawbase, setvis_bf)
		ui.set_visible(bf[v].bf_yaw, setvis_bf)
		
		ui.set_visible(bf[v].bf_jitter, setvis_bf)
		ui.set_visible(bf[v].bf_jitter_type, setvis_bf and ui.get(bf[v].bf_jitter) ~= 'Off')
		ui.set_visible(bf[v].bf_jitter_sli, setvis_bf and ui.get(bf[v].bf_jitter_type) == "Static" and ui.get(bf[v].bf_jitter) ~= 'Off')
		
		ui.set_visible(bf[v].bf_right_jitter_sli, setvis_bf and ui.get(bf[v].bf_jitter_type) == "Left & Right" and ui.get(bf[v].bf_jitter) ~= 'Off')
		ui.set_visible(bf[v].bf_left_jitter_sli, setvis_bf and ui.get(bf[v].bf_jitter_type) == "Left & Right" and ui.get(bf[v].bf_jitter) ~= 'Off')
		
		ui.set_visible(bf[v].bf_body, setvis_bf)
		ui.set_visible(bf[v].bf_freestand_byaw, setvis_bf)
		ui.set_visible(bf[v].bf_yaw_type, setvis_bf)
		ui.set_visible(bf[v].bf_left_limit, setvis_bf and ui.get(bf[v].bf_yaw_type) == "Left & Right")
		ui.set_visible(bf[v].bf_right_limit, setvis_bf and ui.get(bf[v].bf_yaw_type) == "Left & Right")
		
		ui.set_visible(bf[v].bf_yaw_3way_1, setvis_bf and ui.get(bf[v].bf_yaw_type) == "3-Way")
		ui.set_visible(bf[v].bf_yaw_3way_2, setvis_bf and ui.get(bf[v].bf_yaw_type) == "3-Way")
		ui.set_visible(bf[v].bf_yaw_3way_3, setvis_bf and ui.get(bf[v].bf_yaw_type) == "3-Way")
		
		ui.set_visible(bf[v].bf_yaw_1, setvis_bf and ui.get(bf[v].bf_yaw_type) == "5-Way")
		ui.set_visible(bf[v].bf_yaw_2, setvis_bf and ui.get(bf[v].bf_yaw_type) == "5-Way")
		ui.set_visible(bf[v].bf_yaw_3, setvis_bf and ui.get(bf[v].bf_yaw_type) == "5-Way")
		ui.set_visible(bf[v].bf_yaw_4, setvis_bf and ui.get(bf[v].bf_yaw_type) == "5-Way")
		ui.set_visible(bf[v].bf_yaw_5, setvis_bf and ui.get(bf[v].bf_yaw_type) == "5-Way")
		
	
    end
end
client.set_event_callback("paint_ui", handle_menu_bf)

for i=1, #aa_config do
    
    local cond_t = "\a8FBEFFFF [T] "..aa_config[i]..""
    local cond_ct = "\a8FBEFFFF [CT] "..aa_config[i]..""
	
    rage[i] = {
		-- T
        t_enable_aa = ui.new_checkbox('aa', 'anti-aimbot angles', '\a8FBEFFFF[T] \a42454FFFEnable \a8FBEFFFF' .. aa_config[i] .. ' \a42454FFFcondition'),
		t_c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFPitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        t_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw base', {'Local view','At targets'}),
        t_yaw = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        t_yaw_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw type', {'Left & Right', '3-Way','5-Way'}),
        t_left_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFLeft yaw', -180, 180, 0, true, '°'),
        t_right_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFRight yaw', -180, 180, 0, true, '°'),
		t_yaw_3way_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw 1', -180, 180, 0, true, '°', 1),
		t_yaw_3way_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw 2', -180, 180, 0, true, '°', 1),
		t_yaw_3way_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw 3', -180, 180, 0, true, '°', 1),
		t_yaw_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw offset 1', -180, 180, 0, true, '°', 1),
        t_yaw_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw offset 2', -180, 180, 0, true, '°', 1),
        t_yaw_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw offset 3', -180, 180, 0, true, '°', 1),
        t_yaw_4 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw offset 4', -180, 180, 0, true, '°', 1),
        t_yaw_5 = ui.new_slider('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw offset 5', -180, 180, 0, true, '°', 1),
        
		t_jitter = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw jitter', {'Off','Offset','Center','Random'}),
        t_jitter_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFYaw jitter type', {'Static', 'Left & Right'}),
        t_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_t .. '\a4F4F4FFF ~  \a42454FFFYaw jitter slider', -180, 180, 0, true, '°', 1),
        
        t_left_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_t .. '\a4F4F4FFF ~  \a42454FFFLeft jitter slider', -180, 180, 0, true, '°', 1),
		t_right_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_t .. '\a4F4F4FFF ~  \a42454FFFRight jitter slider', -180, 180, 0, true, '°', 1),
		
        t_body = ui.new_combobox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~ \a42454FFFBody yaw', {'Off','Opposite','Jitter','Static'}),
        t_freestand_byaw = ui.new_checkbox('aa', 'anti-aimbot angles', cond_t..'\a4F4F4FFF ~  \a42454FFFFreestanding body yaw'),
		
		-- CT
		ct_enable_aa = ui.new_checkbox('aa', 'anti-aimbot angles', '\a8FBEFFFF[CT] \a42454FFFEnable \a8FBEFFFF' .. aa_config[i] .. ' \a42454FFFcondition'),
		ct_c_pitch = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFPitch', {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
        ct_yawbase = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw base', {'Local view','At targets'}),
        ct_yaw = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw', {'Off', '180', 'Spin', 'Static', '180 Z', 'Crosshair'}),
        ct_yaw_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw type', {'Left & Right', '3-Way','5-Way'}),
        ct_left_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFLeft yaw', -180, 180, 0, true, '°'),
        ct_right_limit = ui.new_slider('AA', 'Anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFRight yaw', -180, 180, 0, true, '°'),
		ct_yaw_3way_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw 1', -180, 180, 0, true, '°', 1),
		ct_yaw_3way_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw 2', -180, 180, 0, true, '°', 1),
		ct_yaw_3way_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw 3', -180, 180, 0, true, '°', 1),
		ct_yaw_1 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw offset 1', -180, 180, 0, true, '°', 1),
        ct_yaw_2 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw offset 2', -180, 180, 0, true, '°', 1),
        ct_yaw_3 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw offset 3', -180, 180, 0, true, '°', 1),
        ct_yaw_4 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw offset 4', -180, 180, 0, true, '°', 1),
        ct_yaw_5 = ui.new_slider('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw offset 5', -180, 180, 0, true, '°', 1),
        
		ct_jitter = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw jitter', {'Off','Offset','Center','Random'}),
        ct_jitter_type = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFYaw jitter type', {'Static', 'Left & Right'}),
        ct_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_ct .. '\a4F4F4FFF ~  \a42454FFFYaw jitter slider', -180, 180, 0, true, '°', 1),
        
		ct_left_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_ct .. '\a4F4F4FFF ~  \a42454FFFLeft jitter slider', -180, 180, 0, true, '°', 1),
		ct_right_jitter_sli = ui.new_slider('aa', 'anti-aimbot angles', cond_ct .. '\a4F4F4FFF ~  \a42454FFFRight jitter slider', -180, 180, 0, true, '°', 1),
		
        ct_body = ui.new_combobox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~ \a42454FFFBody yaw', {'Off','Opposite','Jitter','Static'}),
        ct_freestand_byaw = ui.new_checkbox('aa', 'anti-aimbot angles', cond_ct..'\a4F4F4FFF ~  \a42454FFFFreestanding body yaw'),
       
	}	
end
local function handle_menu()
	local enabled = aa_vis and ui.get(aa_init[0].aa_builder) and not ui.get(aa_init[0].hide_builder)
	ui.set_visible(aa_init[0].aa_condition, enabled and ui.get(aacat) == "Builder")
	local hide_b = false
	
	if ui.get(aa_init[0].hide_builder) then
		hide_b = false
	end
	
	for i=1, #aa_config do
		local condition_enable_t = ui.get(rage[i].t_enable_aa)
		local condition_enable_ct = ui.get(rage[i].ct_enable_aa)
		local show_enb_t = enabled and ui.get(aacat) == "Builder" and ui.get(aa_init[0].team) == "T" and ui.get(aa_init[0].aa_condition) == aa_config[i]
		local show_enb_ct = enabled and ui.get(aacat) == "Builder" and ui.get(aa_init[0].team) == "CT" and ui.get(aa_init[0].aa_condition) == aa_config[i]
		local show_t = enabled and ui.get(aacat) == "Builder" and ui.get(aa_init[0].team) == "T" and ui.get(aa_init[0].aa_condition) == aa_config[i]
		local show_ct = enabled and ui.get(aacat) == "Builder" and ui.get(aa_init[0].team) == "CT" and ui.get(aa_init[0].aa_condition) == aa_config[i]
		
		local setvis_t = show_t and condition_enable_t
		local setvis_t_ct = show_ct and condition_enable_ct
		
		if ui.get(aa_init[0].aa_condition) == "Shared" then
			setvis_t = show_t
		else
			setvis_t = show_t and condition_enable_t
		end
		
		if ui.get(aa_init[0].aa_condition) == "Shared" then
			setvis_ct = show_ct
		else
			setvis_ct = show_ct and condition_enable_ct
		end
		
		-- T OWO UWU AWA EWE IWI
		ui.set_visible(rage[i].t_enable_aa, show_enb_t and i > 1 or hide_b)
		ui.set_visible(rage[i].t_c_pitch, setvis_t or hide_b)
		ui.set_visible(rage[i].t_yawbase, setvis_t or hide_b)
		ui.set_visible(rage[i].t_yaw, setvis_t or hide_b)
		
		ui.set_visible(rage[i].t_jitter, setvis_t or hide_b)
		ui.set_visible(rage[i].t_jitter_type, setvis_t and ui.get(rage[i].t_jitter) ~= 'Off' or hide_b)
		ui.set_visible(rage[i].t_jitter_sli, setvis_t and ui.get(rage[i].t_jitter_type) == "Static" and ui.get(rage[i].t_jitter) ~= 'Off' or hide_b)
		
		ui.set_visible(rage[i].t_right_jitter_sli, setvis_t and ui.get(rage[i].t_jitter_type) == "Left & Right" and ui.get(rage[i].t_jitter) ~= 'Off' or hide_b)
		ui.set_visible(rage[i].t_left_jitter_sli, setvis_t and ui.get(rage[i].t_jitter_type) == "Left & Right" and ui.get(rage[i].t_jitter) ~= 'Off' or hide_b)
		
		ui.set_visible(rage[i].t_body, setvis_t or hide_b)
		ui.set_visible(rage[i].t_freestand_byaw, setvis_t or hide_b)
		ui.set_visible(rage[i].t_yaw_type, setvis_t or hide_b)
		ui.set_visible(rage[i].t_left_limit, setvis_t and ui.get(rage[i].t_yaw_type) == "Left & Right" or hide_b)
		ui.set_visible(rage[i].t_right_limit, setvis_t and ui.get(rage[i].t_yaw_type) == "Left & Right" or hide_b)
		
		ui.set_visible(rage[i].t_yaw_3way_1, setvis_t and ui.get(rage[i].t_yaw_type) == "3-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_3way_2, setvis_t and ui.get(rage[i].t_yaw_type) == "3-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_3way_3, setvis_t and ui.get(rage[i].t_yaw_type) == "3-Way" or hide_b)
		
		ui.set_visible(rage[i].t_yaw_1, setvis_t and ui.get(rage[i].t_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_2, setvis_t and ui.get(rage[i].t_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_3, setvis_t and ui.get(rage[i].t_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_4, setvis_t and ui.get(rage[i].t_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].t_yaw_5, setvis_t and ui.get(rage[i].t_yaw_type) == "5-Way" or hide_b)
	 
		-- CT JEJEJEJEJE
		ui.set_visible(rage[i].ct_enable_aa, show_enb_ct and i > 1 or hide_b)
		ui.set_visible(rage[i].ct_c_pitch, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_yawbase, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_yaw, setvis_ct or hide_b)
		
		ui.set_visible(rage[i].ct_jitter, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_jitter_type, setvis_ct and ui.get(rage[i].ct_jitter) ~= 'Off' or hide_b)
		ui.set_visible(rage[i].ct_jitter_sli, setvis_ct and ui.get(rage[i].ct_jitter_type) == "Static" and ui.get(rage[i].ct_jitter) ~= 'Off' or hide_b)
		
		ui.set_visible(rage[i].ct_right_jitter_sli, setvis_ct and ui.get(rage[i].ct_jitter_type) == "Left & Right" and ui.get(rage[i].ct_jitter) ~= 'Off' or hide_b)
		ui.set_visible(rage[i].ct_left_jitter_sli, setvis_ct and ui.get(rage[i].ct_jitter_type) == "Left & Right" and ui.get(rage[i].ct_jitter) ~= 'Off' or hide_b)
		
		ui.set_visible(rage[i].ct_body, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_freestand_byaw, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_yaw_type, setvis_ct or hide_b)
		ui.set_visible(rage[i].ct_left_limit, setvis_ct and ui.get(rage[i].ct_yaw_type) == "Left & Right" or hide_b)
		ui.set_visible(rage[i].ct_right_limit, setvis_ct and ui.get(rage[i].ct_yaw_type) == "Left & Right" or hide_b)
		
		ui.set_visible(rage[i].ct_yaw_3way_1, setvis_ct and ui.get(rage[i].ct_yaw_type) == "3-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_3way_2, setvis_ct and ui.get(rage[i].ct_yaw_type) == "3-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_3way_3, setvis_ct and ui.get(rage[i].ct_yaw_type) == "3-Way" or hide_b)
		
		ui.set_visible(rage[i].ct_yaw_1, setvis_ct and ui.get(rage[i].ct_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_2, setvis_ct and ui.get(rage[i].ct_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_3, setvis_ct and ui.get(rage[i].ct_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_4, setvis_ct and ui.get(rage[i].ct_yaw_type) == "5-Way" or hide_b)
		ui.set_visible(rage[i].ct_yaw_5, setvis_ct and ui.get(rage[i].ct_yaw_type) == "5-Way" or hide_b)
		
	
	end
end
client.set_event_callback("paint_ui", handle_menu)

local legit_setts = {
	legit_yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a8FBEFFFFLegit AA \a4F4F4FFF  ~  \a42454fFFYaw \n" , { "Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	legit_yaw_add = ui.new_slider("AA", "Anti-aimbot angles", "\a8FBEFFFFLegit AA \a4F4F4FFF  ~  \a42454fFFYaw add\n", -180, 180, 0),
	legit_body = ui.new_combobox('aa', 'anti-aimbot angles', "\a8FBEFFFFLegit AA \a4F4F4FFF  ~  \a42454fFFBody yaw", {'Opposite', 'Jitter'}),
}

local pitchxp = {
	pitchxp_lbl = ui.new_label("AA", "Anti-aimbot angles", " "),
	yaw = ui.new_combobox("AA", "Anti-aimbot angles", "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Yaw base \n" , { "Off", "180", "Spin", "Static", "180 Z", "Crosshair"}),
	pitch = ui.new_combobox('aa', 'anti-aimbot angles', "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Pitch", {'Off','Default','Up', 'Down', 'Minimal', 'Random'}),
	ticks = ui.new_slider("AA", "Anti-aimbot angles", '\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Ticks amount \n', 4, 30, 7),
	yawleft = ui.new_slider("AA", "Anti-aimbot angles", "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Yaw left\n", -180, 180, 0),
	yawright = ui.new_slider("AA", "Anti-aimbot angles", "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Yaw right\n", -180, 180, 0),
	yawjitter = ui.new_combobox("AA", "Anti-aimbot angles", "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Yaw jitter\n" , { "Off", "Offset", "Center", "Random" }),
	yawjitteradd = ui.new_slider("AA", "Anti-aimbot angles", "\a8FBEFFFFPitch exploit\a4F4F4FFF  ~  Yaw jitter add\n" , -180, 180, 0),
}

local function set_og_menu(state)
	ui.set_visible(ref.pitch, state)
	ui.set_visible(ref.roll, state)
	ui.set_visible(ref.yawbase, state)
	ui.set_visible(ref.yaw[1], state)
	ui.set_visible(ref.yaw[2], state)
	ui.set_visible(ref.yawjitter[1], state)
	ui.set_visible(ref.yawjitter[2], state)
	ui.set_visible(ref.bodyyaw[1], state)
	ui.set_visible(ref.bodyyaw[2], state)
	ui.set_visible(ref.freestand[1], state)
	ui.set_visible(ref.freestand[2], state)
 	ui.set_visible(ref.fsbodyyaw, state)
	ui.set_visible(ref.edgeyaw, state)
	ui.set_visible(ref.enabled, state)
end

local renderer_rectangle_rounded = function(x, y, w, h, r, g, b, a, radius)
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

local solus_render = (function() local solus_m = {}; local RoundedRect = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+radius,y,w-radius*2,radius,r,g,b,a)renderer.rectangle(x,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+h-radius,w-radius*2,radius,r,g,b,a)renderer.rectangle(x+w-radius,y+radius,radius,h-radius*2,r,g,b,a)renderer.rectangle(x+radius,y+radius,w-radius*2,h-radius*2,r,g,b,a)renderer.circle(x+radius,y+radius,r,g,b,a,radius,180,0.25)renderer.circle(x+w-radius,y+radius,r,g,b,a,radius,90,0.25)renderer.circle(x+radius,y+h-radius,r,g,b,a,radius,270,0.25)renderer.circle(x+w-radius,y+h-radius,r,g,b,a,radius,0,0.25) end; local rounding = 4; local rad = rounding + 2; local n = 45; local o = 20; local OutlineGlow = function(x, y, w, h, radius, r, g, b, a) renderer.rectangle(x+2,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+w-3,y+radius+rad,1,h-rad*2-radius*2,r,g,b,a)renderer.rectangle(x+radius+rad,y+2,w-rad*2-radius*2,1,r,g,b,a)renderer.rectangle(x+radius+rad,y+h-3,w-rad*2-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius+rad,y+radius+rad,r,g,b,a,radius+rounding,180,0.25,1)renderer.circle_outline(x+w-radius-rad,y+radius+rad,r,g,b,a,radius+rounding,270,0.25,1)renderer.circle_outline(x+radius+rad,y+h-radius-rad,r,g,b,a,radius+rounding,90,0.25,1)renderer.circle_outline(x+w-radius-rad,y+h-radius-rad,r,g,b,a,radius+rounding,0,0.25,1) end; local FadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,a)renderer.circle_outline(x+radius,y+radius,r,g,b,a,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,a,radius,270,0.25,1)renderer.gradient(x,y+radius,1,h-radius*2,r,g,b,a,r,g,b,n,false)renderer.gradient(x+w-1,y+radius,1,h-radius*2,r,g,b,a,r,g,b,n,false)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n)if ui_get(ui_stuff.glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r,g,b,glow-radius*2)end end end; local HorizontalFadedRoundedRect = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,a)renderer.circle_outline(x+radius,y+radius,r,g,b,a,radius,180,0.25,1)renderer.circle_outline(x+radius,y+h-radius,r,g,b,a,radius,90,0.25,1)renderer.gradient(x+radius,y,w/3.5-radius*2,1,r,g,b,a,0,0,0,n/0,true)renderer.gradient(x+radius,y+h-1,w/3.5-radius*2,1,r,g,b,a,0,0,0,n/0,true)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r1,g1,b1,n)renderer.rectangle(x+radius,y,w-radius*2,1,r1,g1,b1,n)renderer.circle_outline(x+w-radius,y+radius,r1,g1,b1,n,radius,-90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r1,g1,b1,n,radius,0,0.25,1)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r1,g1,b1,n)if ui_get(ui_stuff.glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end end; local FadedRoundedGlow = function(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1) local n=a/255*n;renderer.rectangle(x+radius,y,w-radius*2,1,r,g,b,n)renderer.circle_outline(x+radius,y+radius,r,g,b,n,radius,180,0.25,1)renderer.circle_outline(x+w-radius,y+radius,r,g,b,n,radius,270,0.25,1)renderer.rectangle(x,y+radius,1,h-radius*2,r,g,b,n)renderer.rectangle(x+w-1,y+radius,1,h-radius*2,r,g,b,n)renderer.circle_outline(x+radius,y+h-radius,r,g,b,n,radius,90,0.25,1)renderer.circle_outline(x+w-radius,y+h-radius,r,g,b,n,radius,0,0.25,1)renderer.rectangle(x+radius,y+h-1,w-radius*2,1,r,g,b,n)if ui_get(ui_stuff.glow_enabled)then for radius=4,glow do local radius=radius/2;OutlineGlow(x-radius,y-radius,w+radius*2,h+radius*2,radius,r1,g1,b1,glow-radius*2)end end end; solus_m.linear_interpolation = function(start, _end, time) return (_end - start) * time + start end solus_m.clamp = function(value, minimum, maximum) if minimum>maximum then return math.min(math.max(value,maximum),minimum)else return math.min(math.max(value,minimum),maximum)end end solus_m.lerp = function(start, _end, time) time=time or 0.005;time=solus_m.clamp(globals.frametime()*time*175.0,0.01,1.0)local a=solus_m.linear_interpolation(start,_end,time)if _end==0.0 and a<0.01 and a>-0.01 then a=0.0 elseif _end==1.0 and a<1.01 and a>0.99 then a=1.0 end;return a end solus_m.container = function(x, y, w, h, r, g, b, a, alpha, fn) if alpha*255>0 then end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedRect(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.horizontal_container = function(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn) if alpha*255>0 then end;RoundedRect(x,y,w,h,rounding,17,17,17,a)HorizontalFadedRoundedRect(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.container_glow = function(x, y, w, h, r, g, b, a, alpha,r1, g1, b1, fn) if alpha*255>0 then end;RoundedRect(x,y,w,h,rounding,17,17,17,a)FadedRoundedGlow(x,y,w,h,rounding,r,g,b,alpha*255,alpha*o,r1,g1,b1)if not fn then return end;fn(x+rounding,y+rounding,w-rounding*2,h-rounding*2.0) end; solus_m.measure_multitext = function(flags, _table) local a=0;for b,c in pairs(_table)do c.flags=c.flags or''a=a+renderer.measure_text(c.flags,c.text)end;return a end solus_m.multitext = function(x, y, _table) for a,b in pairs(_table)do b.flags=b.flags or''b.limit=b.limit or 0;b.color=b.color or{255,255,255,255}b.color[4]=b.color[4]or 255;renderer.text(x,y,b.color[1],b.color[2],b.color[3],b.color[4],b.flags,b.limit,b.text)x=x+renderer.measure_text(b.flags,b.text) end end return solus_m end)()

local svg_main = [[<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg" version="1.1" width="400" height="397.5728155339806" viewBox="0, 0, 400,397.5728155339806"><g id="svgg"><path id="path0" d="M193.042 4.992 C 191.511 5.267,187.843 5.694,184.891 5.942 C 179.938 6.358,174.521 6.982,166.998 8.003 C 165.358 8.226,162.674 8.732,161.034 9.129 C 159.394 9.525,156.710 10.077,155.070 10.356 C 153.429 10.635,151.640 11.078,151.093 11.341 C 150.547 11.603,149.311 11.939,148.346 12.087 C 147.382 12.235,146.130 12.607,145.563 12.915 C 144.663 13.404,141.477 14.328,138.370 15.001 C 137.823 15.119,137.197 15.353,136.978 15.521 C 136.759 15.689,135.828 16.028,134.909 16.274 C 133.989 16.520,133.005 16.941,132.722 17.211 C 132.438 17.481,131.312 17.934,130.219 18.218 C 127.906 18.820,121.930 21.434,121.736 21.929 C 121.663 22.114,121.331 22.266,120.997 22.266 C 120.274 22.266,112.781 25.890,112.591 26.332 C 112.518 26.502,112.215 26.640,111.918 26.640 C 111.409 26.640,108.584 28.126,108.151 28.621 C 108.042 28.747,107.192 29.184,106.262 29.594 C 105.333 30.004,104.573 30.491,104.573 30.677 C 104.573 30.862,104.349 31.014,104.076 31.015 C 103.543 31.016,99.429 33.630,97.850 34.972 C 97.323 35.419,96.721 35.785,96.511 35.785 C 96.076 35.785,92.197 38.531,91.756 39.152 C 91.595 39.378,91.461 39.442,91.457 39.295 C 91.452 39.038,90.239 39.962,88.626 41.451 C 88.212 41.834,87.739 42.147,87.575 42.147 C 87.411 42.148,86.615 42.729,85.807 43.440 C 84.999 44.150,83.670 45.268,82.854 45.924 C 80.673 47.678,79.403 48.802,76.227 51.789 C 74.657 53.265,73.236 54.473,73.068 54.473 C 72.900 54.473,72.763 54.742,72.763 55.070 C 72.763 55.398,72.525 55.666,72.234 55.666 C 71.943 55.666,71.466 56.113,71.173 56.660 C 70.880 57.207,70.413 57.654,70.134 57.654 C 69.856 57.654,69.310 58.191,68.923 58.847 C 68.535 59.504,67.898 60.142,67.508 60.266 C 67.118 60.390,66.799 60.630,66.799 60.800 C 66.799 60.970,65.860 62.099,64.712 63.308 C 61.353 66.847,60.040 68.390,60.040 68.801 C 60.040 69.012,59.771 69.185,59.443 69.185 C 59.115 69.185,58.847 69.333,58.847 69.513 C 58.847 69.934,55.586 74.245,54.279 75.551 C 53.730 76.100,53.280 76.771,53.280 77.042 C 53.280 77.313,53.097 77.535,52.873 77.535 C 52.649 77.535,52.288 77.937,52.070 78.429 C 51.853 78.921,50.971 80.212,50.109 81.296 C 49.248 82.381,48.624 83.349,48.722 83.447 C 48.821 83.546,48.545 83.876,48.109 84.182 C 47.673 84.487,47.316 84.969,47.316 85.253 C 47.316 85.536,46.877 86.242,46.341 86.821 C 45.805 87.399,45.475 87.873,45.607 87.873 C 45.740 87.873,45.587 88.186,45.268 88.569 C 44.948 88.951,44.475 89.712,44.216 90.258 C 43.958 90.805,43.035 92.416,42.165 93.837 C 41.296 95.258,40.158 97.227,39.637 98.211 C 39.115 99.195,38.018 101.163,37.197 102.584 C 36.377 104.006,34.069 108.483,32.068 112.534 C 23.498 129.882,19.232 142.326,15.508 160.835 C 9.953 188.444,12.809 222.124,23.246 252.087 C 24.046 254.384,25.056 257.336,25.491 258.648 C 25.925 259.960,26.719 261.962,27.256 263.097 C 27.792 264.231,28.231 265.278,28.231 265.424 C 28.231 265.784,32.011 274.301,33.695 277.734 C 34.446 279.264,35.536 281.501,36.118 282.704 C 36.701 283.907,37.221 284.964,37.274 285.054 C 37.327 285.143,38.008 284.561,38.787 283.759 C 39.565 282.957,40.093 282.123,39.959 281.906 C 39.824 281.689,39.860 281.511,40.039 281.511 C 40.217 281.511,40.616 280.929,40.925 280.219 C 41.234 279.508,41.668 278.807,41.888 278.660 C 42.109 278.513,42.327 278.142,42.372 277.835 C 42.573 276.469,44.323 271.571,44.611 271.571 C 44.787 271.571,44.930 271.201,44.930 270.749 C 44.930 268.694,51.374 256.894,57.182 248.313 C 63.355 239.193,73.587 226.391,75.401 225.517 C 76.349 225.061,79.434 221.197,80.489 219.146 C 81.526 217.131,80.578 207.930,79.155 206.194 C 77.442 204.103,78.735 197.721,81.683 193.717 C 87.209 186.211,94.893 184.593,105.742 188.652 C 107.782 189.415,108.768 189.250,111.066 187.761 C 112.993 186.513,120.396 180.682,121.272 179.723 C 123.081 177.744,141.925 163.089,148.450 158.587 C 149.512 157.855,150.870 156.899,151.468 156.461 C 153.005 155.338,160.553 150.180,161.358 149.702 C 161.726 149.483,163.381 148.410,165.035 147.316 C 168.732 144.871,168.265 145.163,174.934 141.140 C 175.922 140.544,178.378 139.046,179.936 138.089 C 180.365 137.826,184.026 135.802,188.072 133.591 C 192.117 131.381,195.696 129.410,196.024 129.212 C 196.352 129.014,199.394 127.492,202.783 125.830 C 206.173 124.167,209.394 122.571,209.940 122.281 C 211.744 121.327,222.445 116.588,223.459 116.294 C 224.006 116.136,224.632 115.867,224.851 115.697 C 225.218 115.412,230.525 113.289,237.773 110.526 C 242.330 108.790,249.603 106.251,252.485 105.391 C 253.907 104.967,256.859 104.064,259.046 103.386 C 272.760 99.129,288.298 95.693,304.374 93.362 C 310.113 92.530,331.857 92.655,337.315 93.552 C 345.379 94.877,353.259 97.072,357.383 99.141 C 358.977 99.942,360.615 100.596,361.023 100.596 C 361.430 100.596,361.822 100.739,361.895 100.913 C 362.038 101.254,367.737 102.982,368.720 102.982 C 369.049 102.982,369.377 103.133,369.450 103.317 C 369.523 103.501,370.164 103.765,370.875 103.903 C 372.287 104.178,372.714 103.211,371.663 102.116 C 371.386 101.827,370.815 100.785,370.395 99.801 C 369.976 98.817,369.440 97.744,369.206 97.416 C 368.972 97.087,368.425 96.103,367.990 95.229 C 367.555 94.354,366.975 93.402,366.701 93.113 C 366.427 92.824,366.203 92.365,366.203 92.094 C 366.203 91.823,365.889 91.254,365.506 90.830 C 365.123 90.407,364.380 89.210,363.853 88.171 C 363.327 87.132,362.748 86.282,362.567 86.282 C 362.386 86.282,361.983 85.701,361.672 84.990 C 361.361 84.279,360.643 83.178,360.076 82.543 C 359.509 81.907,359.046 81.156,359.046 80.872 C 359.046 80.589,358.813 80.215,358.529 80.040 C 358.244 79.865,357.580 79.095,357.052 78.330 C 356.224 77.130,352.775 72.885,349.491 69.025 C 348.951 68.391,347.570 66.891,346.421 65.693 C 345.273 64.494,344.334 63.389,344.334 63.236 C 344.334 63.083,343.887 62.718,343.340 62.425 C 342.793 62.133,342.346 61.665,342.346 61.387 C 342.346 61.108,341.809 60.563,341.153 60.175 C 340.497 59.788,339.960 59.340,339.960 59.181 C 339.960 59.022,339.227 58.211,338.331 57.378 C 337.435 56.546,335.673 54.836,334.416 53.579 C 333.158 52.321,331.923 51.292,331.671 51.292 C 331.419 51.292,331.213 51.135,331.213 50.943 C 331.213 50.480,323.879 44.533,323.308 44.533 C 323.063 44.533,322.863 44.285,322.863 43.982 C 322.863 43.679,322.237 43.133,321.471 42.770 C 320.706 42.407,320.080 41.972,320.080 41.804 C 320.080 41.636,319.364 41.096,318.489 40.604 C 317.614 40.113,316.899 39.585,316.899 39.433 C 316.899 39.151,315.682 38.422,314.414 37.943 C 314.031 37.799,313.718 37.526,313.718 37.337 C 313.718 37.149,313.002 36.629,312.127 36.183 C 311.252 35.737,310.537 35.214,310.537 35.021 C 310.537 34.829,309.732 34.340,308.749 33.936 C 307.766 33.532,306.961 33.084,306.960 32.942 C 306.958 32.561,304.225 31.014,303.556 31.014 C 303.240 31.014,302.982 30.842,302.982 30.632 C 302.982 30.422,302.132 29.823,301.093 29.302 C 295.693 26.593,291.606 24.399,291.131 23.956 C 290.839 23.683,290.410 23.459,290.180 23.459 C 289.949 23.459,288.396 22.817,286.729 22.032 C 281.229 19.444,279.739 18.795,278.131 18.289 C 277.256 18.014,276.362 17.663,276.143 17.508 C 275.924 17.354,274.672 16.906,273.360 16.512 C 272.048 16.118,270.756 15.623,270.488 15.413 C 270.018 15.042,268.952 14.725,265.209 13.841 C 264.225 13.609,263.330 13.304,263.221 13.164 C 262.976 12.850,259.510 11.876,257.753 11.627 C 257.043 11.526,256.461 11.300,256.461 11.125 C 256.461 10.949,255.701 10.685,254.771 10.538 C 253.842 10.391,252.199 10.018,251.121 9.708 C 250.042 9.398,248.602 9.145,247.920 9.145 C 247.238 9.145,246.501 8.966,246.283 8.748 C 245.811 8.276,240.884 7.555,230.219 6.395 C 228.141 6.169,225.010 5.801,223.260 5.577 C 215.445 4.577,197.320 4.226,193.042 4.992 M235.520 135.390 C 233.296 135.659,230.344 136.155,228.959 136.493 C 225.817 137.259,221.885 137.972,220.797 137.972 C 220.343 137.972,219.459 138.239,218.833 138.566 C 218.206 138.893,217.373 139.161,216.980 139.163 C 216.047 139.166,211.106 140.324,210.338 140.719 C 210.010 140.888,208.400 141.337,206.759 141.716 C 205.119 142.096,203.419 142.566,202.982 142.760 C 201.542 143.400,197.254 144.732,196.633 144.732 C 196.298 144.732,196.024 144.896,196.024 145.098 C 196.024 145.299,195.442 145.579,194.732 145.719 C 193.126 146.036,191.360 146.634,190.060 147.299 C 189.513 147.579,188.082 148.124,186.879 148.510 C 185.676 148.895,184.509 149.354,184.284 149.530 C 184.060 149.705,182.987 150.150,181.899 150.518 C 180.811 150.886,179.831 151.311,179.722 151.464 C 179.612 151.616,178.360 152.165,176.938 152.684 C 175.517 153.203,174.264 153.748,174.155 153.895 C 174.046 154.042,173.263 154.411,172.415 154.714 C 171.568 155.017,170.788 155.490,170.683 155.764 C 170.578 156.038,170.180 156.262,169.799 156.262 C 169.095 156.262,162.210 159.656,161.835 160.188 C 161.722 160.348,160.777 160.798,159.734 161.189 C 158.692 161.580,157.592 162.147,157.291 162.448 C 156.990 162.748,156.009 163.289,155.112 163.648 C 154.214 164.007,153.479 164.420,153.479 164.565 C 153.479 164.710,152.808 165.181,151.988 165.612 C 151.168 166.042,150.408 166.505,150.298 166.641 C 150.189 166.776,149.549 167.169,148.876 167.514 C 144.604 169.701,126.408 182.491,116.694 190.134 C 111.154 194.492,110.753 195.372,112.922 198.410 C 116.663 203.647,111.195 218.688,105.550 218.688 C 105.079 218.688,104.316 219.016,103.854 219.416 C 102.758 220.367,98.033 221.245,95.573 220.956 C 91.609 220.489,88.600 219.922,88.144 219.555 C 87.183 218.782,85.213 218.621,84.571 219.264 C 84.231 219.603,83.758 219.881,83.519 219.881 C 82.777 219.881,79.523 223.123,79.523 223.862 C 79.523 224.246,79.076 224.854,78.529 225.212 C 77.982 225.570,77.535 226.133,77.535 226.463 C 77.535 226.793,77.266 227.166,76.938 227.292 C 76.610 227.417,76.342 227.751,76.342 228.032 C 76.342 228.523,71.174 236.447,69.431 238.629 C 67.410 241.158,66.566 242.353,66.056 243.402 C 65.757 244.018,65.355 244.424,65.162 244.305 C 64.969 244.186,64.811 244.332,64.811 244.631 C 64.811 244.929,63.961 246.514,62.922 248.153 C 61.884 249.792,60.820 251.482,60.559 251.908 C 52.845 264.513,47.239 283.921,48.920 292.201 C 49.125 293.210,49.574 295.537,49.918 297.371 C 52.793 312.706,65.938 321.617,90.516 324.892 C 96.263 325.658,116.322 323.289,126.640 320.625 C 132.138 319.206,134.735 318.485,137.177 317.702 C 145.419 315.057,155.564 311.651,157.455 310.895 C 158.658 310.413,160.984 309.486,162.624 308.835 C 166.607 307.252,170.732 305.494,173.161 304.344 C 178.005 302.051,190.075 296.004,192.247 294.783 C 193.559 294.045,195.258 293.131,196.024 292.753 C 196.789 292.375,197.921 291.659,198.539 291.162 C 199.158 290.665,199.859 290.258,200.099 290.258 C 200.338 290.258,200.816 290.010,201.162 289.705 C 201.507 289.401,202.416 288.812,203.181 288.396 C 205.067 287.371,211.797 283.000,216.844 279.523 C 224.445 274.286,235.902 265.141,242.739 258.851 C 258.392 244.452,274.351 226.182,282.511 213.320 C 283.343 212.008,284.264 210.791,284.557 210.616 C 284.850 210.442,285.089 210.097,285.089 209.850 C 285.089 209.604,285.873 208.226,286.830 206.789 C 287.788 205.351,288.886 203.325,289.270 202.286 C 289.654 201.248,290.103 200.398,290.267 200.398 C 290.601 200.398,291.849 196.811,291.849 195.850 C 291.849 195.508,292.011 195.229,292.209 195.229 C 292.604 195.229,294.235 190.371,294.235 189.197 C 294.235 188.797,294.388 188.469,294.576 188.469 C 295.435 188.469,297.813 175.525,297.814 170.846 C 297.814 167.984,297.097 161.987,296.615 160.835 C 296.433 160.398,295.977 159.011,295.602 157.753 C 295.228 156.496,294.781 155.467,294.609 155.467 C 294.438 155.467,294.178 154.924,294.032 154.259 C 293.886 153.594,293.157 152.251,292.410 151.273 C 291.664 150.296,291.054 149.392,291.054 149.265 C 291.054 148.927,287.155 145.225,285.508 143.999 C 284.731 143.420,284.006 142.844,283.897 142.719 C 283.381 142.127,278.751 139.576,277.336 139.104 C 276.461 138.812,275.656 138.475,275.547 138.355 C 275.208 137.985,269.392 136.433,267.197 136.128 C 266.650 136.051,264.861 135.729,263.221 135.411 C 259.480 134.686,241.472 134.673,235.520 135.390 M391.153 163.451 C 390.770 163.674,390.457 164.206,390.457 164.632 C 390.457 165.059,390.282 165.408,390.067 165.408 C 389.853 165.408,389.568 165.842,389.435 166.373 C 389.302 166.904,388.958 167.428,388.672 167.538 C 388.386 167.648,387.930 168.421,387.659 169.256 C 387.388 170.092,386.839 171.242,386.440 171.811 C 386.040 172.381,385.591 173.633,385.441 174.595 C 385.174 176.302,378.668 189.972,373.728 199.205 C 369.419 207.257,363.749 216.275,359.353 222.068 C 357.762 224.164,356.188 226.168,355.684 226.740 C 355.346 227.122,355.070 227.581,355.070 227.760 C 355.070 227.938,354.488 228.641,353.777 229.322 C 353.067 230.002,352.038 231.114,351.491 231.792 C 350.944 232.470,350.184 233.378,349.801 233.809 C 349.418 234.240,349.105 234.756,349.105 234.957 C 349.105 235.157,348.968 235.381,348.800 235.454 C 348.633 235.527,347.783 236.469,346.912 237.548 C 346.041 238.627,344.970 239.916,344.533 240.413 C 337.123 248.828,329.862 256.461,329.267 256.461 C 329.025 256.461,328.827 256.641,328.827 256.861 C 328.827 257.081,327.947 258.109,326.872 259.147 C 322.361 263.499,317.498 267.995,312.782 272.174 C 312.531 272.396,310.403 274.166,308.052 276.107 C 305.701 278.048,303.777 279.789,303.777 279.977 C 303.777 280.165,303.518 280.318,303.201 280.318 C 302.884 280.318,302.481 280.542,302.306 280.816 C 302.131 281.090,300.939 282.111,299.658 283.085 C 298.376 284.060,297.239 285.088,297.130 285.371 C 297.022 285.653,296.740 285.885,296.504 285.885 C 296.268 285.885,295.226 286.600,294.189 287.475 C 293.151 288.350,292.120 289.066,291.897 289.066 C 291.673 289.066,291.348 289.294,291.173 289.572 C 290.998 289.851,289.270 291.238,287.332 292.654 C 285.395 294.070,283.266 295.721,282.602 296.322 C 281.937 296.923,281.241 297.416,281.054 297.416 C 280.868 297.416,280.397 297.729,280.008 298.111 C 279.619 298.494,277.964 299.693,276.330 300.776 C 274.697 301.859,273.296 302.899,273.219 303.088 C 273.141 303.277,272.694 303.598,272.225 303.803 C 271.387 304.167,267.960 306.478,266.812 307.451 C 266.491 307.724,265.613 308.276,264.861 308.680 C 264.108 309.083,263.240 309.666,262.931 309.975 C 262.622 310.284,262.216 310.537,262.030 310.537 C 261.844 310.537,261.185 310.954,260.567 311.464 C 259.949 311.974,258.822 312.735,258.064 313.154 C 257.305 313.573,256.500 314.051,256.274 314.214 C 254.692 315.365,251.562 317.283,250.947 317.478 C 250.538 317.608,249.885 318.067,249.494 318.499 C 249.103 318.931,248.587 319.292,248.348 319.301 C 248.108 319.310,246.660 320.114,245.129 321.087 C 243.598 322.061,241.451 323.329,240.358 323.906 C 239.264 324.483,238.280 325.066,238.171 325.201 C 238.062 325.337,237.256 325.803,236.382 326.239 C 235.507 326.674,234.702 327.121,234.592 327.233 C 234.398 327.431,231.582 328.932,228.429 330.518 C 227.555 330.958,226.750 331.445,226.640 331.600 C 226.531 331.755,225.585 332.205,224.539 332.601 C 223.493 332.996,222.509 333.524,222.352 333.774 C 222.196 334.024,221.298 334.477,220.358 334.779 C 219.418 335.082,218.524 335.529,218.370 335.773 C 218.217 336.017,217.288 336.476,216.307 336.792 C 215.325 337.108,214.235 337.654,213.884 338.005 C 213.533 338.356,212.390 338.895,211.344 339.202 C 210.299 339.510,209.357 339.985,209.251 340.258 C 209.146 340.532,208.859 340.755,208.613 340.755 C 208.058 340.755,203.850 342.448,203.579 342.781 C 203.469 342.914,202.440 343.333,201.292 343.711 C 200.144 344.089,199.205 344.548,199.205 344.730 C 199.205 344.913,197.952 345.451,196.421 345.924 C 194.891 346.398,193.637 346.905,193.635 347.051 C 193.633 347.197,192.515 347.663,191.150 348.088 C 189.785 348.512,188.432 349.094,188.143 349.380 C 187.854 349.666,187.317 349.903,186.950 349.906 C 186.167 349.913,182.890 351.016,182.309 351.468 C 182.089 351.639,180.835 352.106,179.523 352.505 C 178.211 352.904,177.038 353.374,176.917 353.550 C 176.796 353.726,175.285 354.230,173.559 354.672 C 171.832 355.113,170.321 355.629,170.200 355.819 C 170.001 356.130,167.783 356.764,164.923 357.329 C 164.329 357.446,163.636 357.791,163.384 358.095 C 163.131 358.399,162.482 358.648,161.941 358.648 C 160.727 358.648,156.743 359.715,155.666 360.329 C 155.229 360.578,154.155 360.908,153.280 361.063 C 149.807 361.677,147.513 362.218,146.835 362.582 C 146.157 362.947,142.837 363.695,140.060 364.109 C 139.349 364.215,138.767 364.448,138.767 364.627 C 138.767 364.806,137.783 365.076,136.581 365.226 C 134.584 365.475,133.282 366.600,134.990 366.600 C 135.318 366.600,135.586 366.751,135.586 366.934 C 135.586 367.118,136.347 367.504,137.276 367.792 C 138.206 368.081,139.324 368.524,139.761 368.778 C 140.842 369.406,147.372 371.105,161.431 374.417 C 188.177 380.718,220.026 380.903,246.918 374.914 C 252.109 373.758,261.135 371.395,262.823 370.751 C 263.588 370.459,265.020 370.014,266.004 369.763 C 274.396 367.621,296.179 357.645,305.826 351.525 C 307.062 350.741,309.120 349.445,310.399 348.646 C 315.444 345.493,324.253 339.099,328.069 335.820 C 328.855 335.145,329.839 334.319,330.256 333.984 C 338.419 327.431,349.272 316.086,356.874 306.161 C 360.575 301.328,360.121 301.971,365.050 294.586 C 368.944 288.752,369.254 288.260,372.242 283.156 C 373.185 281.545,374.353 279.577,374.838 278.782 C 376.111 276.696,377.734 273.228,377.734 272.596 C 377.734 272.297,378.002 271.950,378.330 271.824 C 378.658 271.699,378.926 271.349,378.926 271.048 C 378.926 270.746,379.183 269.980,379.496 269.345 C 379.809 268.710,380.122 267.927,380.192 267.604 C 380.261 267.281,380.542 266.776,380.815 266.482 C 381.088 266.188,381.312 265.613,381.312 265.204 C 381.312 264.795,381.491 264.350,381.710 264.215 C 381.928 264.080,382.107 263.622,382.107 263.197 C 382.107 262.773,382.272 262.425,382.473 262.425 C 382.675 262.425,382.964 261.844,383.115 261.133 C 383.267 260.422,383.843 258.767,384.396 257.455 C 384.949 256.143,385.561 254.375,385.756 253.527 C 385.951 252.678,386.467 251.202,386.903 250.245 C 387.339 249.289,387.863 247.619,388.069 246.535 C 388.274 245.452,388.608 244.244,388.810 243.853 C 389.278 242.948,390.299 239.248,390.654 237.177 C 390.804 236.302,391.065 235.408,391.234 235.189 C 391.404 234.970,391.645 234.076,391.769 233.201 C 392.190 230.251,392.929 226.844,393.308 226.112 C 393.668 225.415,393.939 223.581,394.843 215.706 C 395.069 213.738,395.471 211.698,395.738 211.173 C 396.395 209.879,396.440 175.460,395.785 175.035 C 395.545 174.879,395.231 173.767,395.088 172.565 C 394.176 164.915,393.063 162.339,391.153 163.451 " stroke="none" fill="#fcfcfc" fill-rule="evenodd"/><path id="path1" d="M42.889 91.361 C 36.473 100.000,29.229 112.013,23.653 123.260 C 18.655 133.343,18.111 134.529,16.273 139.364 C 15.359 141.769,14.484 144.006,14.329 144.334 C 14.174 144.662,13.382 147.078,12.569 149.702 C 11.756 152.326,10.752 155.547,10.338 156.859 C 9.924 158.171,9.379 160.318,9.128 161.630 C 8.876 162.942,8.340 165.268,7.937 166.799 C 7.533 168.330,7.004 171.014,6.759 172.763 C 6.515 174.513,6.073 177.197,5.778 178.728 C 2.367 196.423,3.918 223.581,9.740 248.111 C 11.393 255.079,17.515 273.820,19.056 276.631 C 19.269 277.019,20.187 279.125,21.097 281.312 C 23.573 287.266,28.714 297.431,29.543 298.011 C 31.265 299.217,32.308 298.106,35.887 291.252 C 36.948 289.220,39.373 283.376,39.219 283.222 C 39.139 283.142,38.849 283.618,38.574 284.281 C 37.995 285.678,37.148 285.854,36.768 284.655 C 36.558 283.996,31.175 272.570,29.854 269.980 C 29.502 269.290,26.375 261.448,24.939 257.654 C 22.546 251.330,18.267 237.377,17.684 233.996 C 17.533 233.121,16.977 230.575,16.449 228.338 C 15.922 226.100,15.230 222.432,14.912 220.186 C 14.594 217.941,14.160 215.119,13.949 213.917 C 12.759 207.158,12.199 193.500,12.719 183.897 C 13.276 173.614,14.722 162.593,16.476 155.268 C 17.000 153.082,17.551 150.666,17.700 149.901 C 18.085 147.933,21.700 136.131,22.869 133.025 C 26.016 124.664,27.809 120.558,32.508 110.961 C 34.703 106.477,40.756 95.519,41.521 94.645 C 41.814 94.310,42.176 93.632,42.326 93.139 C 42.477 92.646,43.057 91.699,43.616 91.035 C 44.175 90.371,44.554 89.749,44.458 89.654 C 44.363 89.559,43.657 90.327,42.889 91.361 M310.338 93.065 C 303.983 93.676,296.359 94.683,293.638 95.270 C 292.107 95.601,289.404 96.116,287.630 96.416 C 275.153 98.526,251.238 105.531,234.592 111.951 C 229.002 114.107,227.578 114.684,223.857 116.302 C 221.998 117.110,219.672 118.084,218.688 118.465 C 217.704 118.847,216.186 119.545,215.314 120.017 C 214.443 120.489,213.575 120.875,213.386 120.875 C 213.011 120.875,194.127 130.258,193.456 130.778 C 193.228 130.955,191.521 131.906,189.662 132.893 C 183.438 136.195,175.656 140.743,169.781 144.513 C 169.016 145.004,167.316 146.087,166.004 146.920 C 152.060 155.769,133.986 169.125,121.147 180.069 C 109.770 189.766,109.038 190.090,103.145 188.020 C 91.449 183.913,79.467 190.581,78.795 201.571 L 78.636 204.175 79.576 203.345 C 83.951 199.483,88.583 198.869,95.557 201.226 C 101.684 203.296,103.429 202.898,109.442 198.061 C 111.374 196.507,111.727 196.024,111.728 194.934 C 111.729 193.878,112.041 193.413,113.462 192.350 C 114.415 191.637,116.675 189.891,118.483 188.469 C 122.391 185.399,126.401 182.430,130.219 179.781 C 131.750 178.719,133.807 177.281,134.791 176.585 C 136.670 175.256,138.091 174.312,142.346 171.568 C 143.767 170.651,146.487 168.890,148.389 167.654 C 150.291 166.419,151.935 165.408,152.042 165.408 C 152.150 165.408,153.636 164.402,155.344 163.174 C 157.052 161.946,158.718 160.842,159.046 160.721 C 159.374 160.600,160.716 159.754,162.028 158.842 C 163.340 157.929,165.454 156.573,166.727 155.828 C 174.710 151.152,178.318 149.016,179.324 148.372 C 179.871 148.022,181.123 147.324,182.107 146.821 C 183.091 146.318,185.865 144.840,188.270 143.537 C 190.676 142.233,193.091 140.984,193.638 140.762 C 194.185 140.539,195.080 140.079,195.626 139.739 C 196.173 139.399,197.247 138.858,198.012 138.537 C 198.777 138.215,199.717 137.778,200.099 137.565 C 201.331 136.879,202.132 136.490,204.970 135.203 C 206.501 134.509,208.827 133.433,210.139 132.813 C 211.451 132.192,214.314 130.927,216.501 130.001 C 218.688 129.075,221.014 128.090,221.670 127.812 C 222.963 127.264,224.988 126.488,229.026 124.994 C 230.447 124.468,231.968 123.869,232.406 123.662 C 235.436 122.233,258.191 114.992,262.425 114.109 C 263.191 113.949,265.249 113.425,266.998 112.944 C 268.748 112.463,271.074 111.906,272.167 111.707 C 273.260 111.507,275.497 110.994,277.137 110.567 C 278.777 110.140,281.909 109.497,284.095 109.137 C 286.282 108.778,288.608 108.325,289.264 108.131 C 297.292 105.759,329.847 105.773,335.984 108.152 C 336.531 108.363,338.478 108.890,340.311 109.321 C 343.534 110.080,346.052 110.848,351.491 112.736 C 365.476 117.588,367.788 117.416,364.995 111.730 C 361.224 104.051,358.708 99.924,357.375 99.234 C 352.458 96.686,342.364 94.365,330.417 93.035 C 326.513 92.600,314.989 92.617,310.338 93.065 M382.704 175.692 C 381.940 176.756,379.697 180.916,377.719 184.936 C 367.460 205.795,362.822 214.795,361.374 216.654 C 360.968 217.176,360.636 217.761,360.636 217.954 C 360.636 218.148,360.158 219.063,359.574 219.988 C 355.844 225.892,355.691 226.651,359.193 221.869 C 366.890 211.361,371.002 204.386,379.000 188.270 C 381.171 183.897,383.366 179.513,383.878 178.529 C 386.310 173.860,385.473 171.838,382.704 175.692 M109.926 199.372 C 102.303 205.098,102.659 204.347,104.601 210.587 C 105.500 213.475,105.781 215.054,105.665 216.561 C 105.491 218.830,105.690 218.903,107.897 217.372 C 112.872 213.921,115.651 204.103,113.071 199.094 L 112.297 197.591 109.926 199.372 M284.264 211.140 C 283.297 212.672,281.879 214.783,281.113 215.833 C 280.348 216.883,278.917 218.870,277.932 220.250 C 270.757 230.312,256.575 246.284,246.918 255.178 C 244.185 257.695,241.143 260.500,240.159 261.411 C 237.729 263.660,233.361 267.298,229.633 270.179 C 227.934 271.491,225.985 273.024,225.300 273.586 C 224.187 274.499,216.320 280.129,213.365 282.127 C 210.108 284.329,206.324 286.784,204.384 287.953 C 203.186 288.674,201.486 289.699,200.606 290.230 C 173.029 306.863,136.513 320.483,110.934 323.677 C 98.505 325.229,97.201 325.331,92.445 325.122 C 57.373 323.582,41.280 301.724,51.941 270.105 C 54.129 263.616,59.283 252.770,61.203 250.613 C 61.438 250.349,61.630 250.017,61.630 249.876 C 61.630 249.734,62.130 248.877,62.740 247.970 C 64.624 245.173,64.682 245.047,63.794 245.678 C 63.369 245.980,63.588 245.683,64.281 245.018 C 64.973 244.353,66.457 242.495,67.577 240.890 C 68.698 239.285,70.203 237.167,70.922 236.183 C 75.655 229.702,76.933 226.900,75.547 226.044 C 74.960 225.681,70.375 230.643,67.103 235.181 C 66.943 235.404,66.389 236.123,65.874 236.779 C 60.983 243.004,54.665 252.174,51.629 257.455 C 50.874 258.767,49.946 260.378,49.565 261.034 C 49.185 261.690,48.585 262.853,48.233 263.618 C 47.881 264.384,47.083 266.019,46.460 267.252 C 45.837 268.486,45.328 269.712,45.328 269.978 C 45.328 270.244,44.881 271.352,44.334 272.440 C 42.721 275.652,43.209 275.205,45.437 271.430 C 49.546 264.469,50.998 262.221,54.076 258.054 C 55.497 256.129,56.928 254.151,57.256 253.658 C 58.281 252.117,62.458 246.945,62.896 246.674 C 63.377 246.377,57.520 255.053,56.406 256.288 C 55.999 256.740,55.666 257.307,55.666 257.550 C 55.666 257.792,55.076 258.765,54.355 259.711 C 46.599 269.891,40.611 286.407,40.254 298.608 C 39.209 334.289,76.229 347.670,130.616 331.269 C 136.222 329.579,147.196 325.925,150.497 324.651 C 152.028 324.060,153.918 323.338,154.698 323.048 C 161.254 320.605,180.498 311.513,187.325 307.632 C 188.555 306.934,190.791 305.661,192.295 304.805 C 193.799 303.948,195.922 302.651,197.013 301.922 C 198.103 301.193,199.131 300.596,199.297 300.596 C 199.464 300.596,200.853 299.702,202.386 298.608 C 203.918 297.515,205.266 296.620,205.382 296.620 C 205.498 296.620,207.031 295.591,208.791 294.334 C 210.550 293.077,212.297 291.869,212.673 291.650 C 214.292 290.709,222.303 284.597,226.383 281.189 C 228.821 279.154,232.068 276.490,233.598 275.270 C 236.993 272.565,257.300 252.291,258.359 250.549 C 258.777 249.862,259.818 248.540,260.673 247.612 C 261.528 246.684,263.717 244.135,265.537 241.948 C 269.844 236.776,269.980 236.605,269.980 236.382 C 269.980 236.277,270.830 235.099,271.869 233.763 C 272.908 232.427,274.007 230.949,274.311 230.478 C 274.616 230.007,275.629 228.459,276.562 227.038 C 278.939 223.418,280.371 220.834,283.172 215.109 C 284.510 212.376,285.769 209.809,285.971 209.405 C 286.884 207.575,285.858 208.618,284.264 211.140 M372.808 282.565 C 372.256 283.625,370.906 285.924,369.808 287.674 C 368.710 289.423,367.319 291.660,366.717 292.644 C 365.497 294.639,360.546 301.775,359.118 303.596 C 358.611 304.242,357.448 305.762,356.534 306.972 C 338.506 330.831,307.137 354.431,279.125 365.210 C 277.048 366.009,274.274 367.077,272.962 367.583 C 235.903 381.864,192.099 383.394,150.497 371.859 C 147.425 371.007,148.482 370.881,139.563 373.164 C 138.141 373.528,135.099 374.274,132.803 374.821 C 130.507 375.369,128.334 375.896,127.975 375.993 C 126.750 376.324,126.816 379.722,128.047 379.722 C 128.285 379.722,129.408 380.146,130.542 380.664 C 132.950 381.765,136.708 383.064,140.365 384.059 C 141.790 384.447,143.311 384.950,143.745 385.177 C 144.178 385.405,145.815 385.879,147.382 386.232 C 148.949 386.585,150.739 387.067,151.358 387.304 C 153.044 387.948,162.894 389.795,173.360 391.430 C 182.734 392.894,211.091 393.287,218.489 392.055 C 219.801 391.837,223.577 391.307,226.880 390.879 C 230.183 390.450,234.477 389.746,236.423 389.313 C 238.368 388.881,241.213 388.254,242.744 387.921 C 247.602 386.862,258.280 383.972,259.841 383.293 C 260.278 383.103,262.157 382.418,264.016 381.771 C 265.875 381.124,268.648 380.113,270.179 379.523 C 271.710 378.934,273.782 378.149,274.784 377.779 C 276.410 377.178,278.951 376.006,282.505 374.218 C 283.864 373.533,283.856 373.538,287.873 371.576 C 293.018 369.065,299.664 365.228,305.169 361.593 C 311.905 357.146,315.119 354.875,318.224 352.370 C 319.791 351.106,321.521 349.788,322.068 349.443 C 326.121 346.879,349.105 323.814,349.105 322.310 C 349.105 322.172,350.626 320.169,352.485 317.858 C 354.344 315.548,355.865 313.500,355.865 313.308 C 355.865 313.116,356.779 311.743,357.896 310.257 C 359.012 308.771,360.021 307.286,360.137 306.958 C 360.252 306.630,360.920 305.467,361.621 304.374 C 363.829 300.928,365.503 298.091,366.782 295.626 C 367.463 294.314,368.208 292.883,368.436 292.445 C 368.665 292.008,369.150 291.069,369.515 290.358 C 369.880 289.647,370.440 288.574,370.760 287.972 C 372.277 285.114,374.145 280.971,373.987 280.813 C 373.890 280.716,373.359 281.504,372.808 282.565 " stroke="none" fill="#cdcdcd" fill-rule="evenodd"/><path id="path2" d="M12.473 192.048 C 12.473 194.344,12.539 195.283,12.619 194.135 C 12.700 192.987,12.700 191.108,12.619 189.960 C 12.539 188.812,12.473 189.751,12.473 192.048 " stroke="none" fill="#dcdcdc" fill-rule="evenodd"/><path id="path3" d="M198.907 379.598 C 199.289 379.698,199.916 379.698,200.298 379.598 C 200.681 379.498,200.368 379.416,199.602 379.416 C 198.837 379.416,198.524 379.498,198.907 379.598 " stroke="none" fill="#e4e4e4" fill-rule="evenodd"/><path id="path4" d="M193.543 379.208 C 194.038 379.303,194.754 379.299,195.134 379.200 C 195.514 379.100,195.109 379.022,194.235 379.027 C 193.360 379.031,193.049 379.113,193.543 379.208 M215.015 379.208 C 215.509 379.303,216.225 379.299,216.605 379.200 C 216.985 379.100,216.581 379.022,215.706 379.027 C 214.831 379.031,214.520 379.113,215.015 379.208 M202.883 379.618 C 204.140 379.697,206.198 379.697,207.455 379.618 C 208.713 379.539,207.684 379.474,205.169 379.474 C 202.654 379.474,201.625 379.539,202.883 379.618 " stroke="none" fill="#ececec" fill-rule="evenodd"/></g></svg>]]

local logo_push_left = renderer.load_svg(svg_main, 25, 25)
local logo_main = renderer.load_svg(svg_main, 13, 13)

_G.nexus_push=(function()
	_G.nexus_notify_cache={}
	local a={callback_registered=false,maximum_count=4}
	local b=ui.reference("Misc","Settings","Menu color")
	function a:register_callback()
		if self.callback_registered then return end;
		client.set_event_callback("paint_ui",function()
			local c={client.screen_size()}
			local d={0,0,0}
			local e=1;
			local f=_G.nexus_notify_cache;
			for g=#f,1,-1 do
				_G.nexus_notify_cache[g].time=_G.nexus_notify_cache[g].time-globals.frametime()
				local h,i=255,0;
				local i2 = 0;
				local lerpy = 150;
				local lerp_circ = 0.5;
				local j=f[g]
				if j.time<0 then
					table.remove(_G.nexus_notify_cache,g)
				else
					local k=j.def_time-j.time;
					local k=k>1 and 1 or k;
				if j.time<1 or k<1 then
					i=(k<1 and k or j.time)/1;
					i2=(k<1 and k or j.time)/1;
					h=i*255;
					lerpy=i*150;
					lerp_circ=i*0.5
				if i<0.2 then
					e=e+8*(1.0-i/0.2)
				end
			end;

			local l={ui.get(b)}
			local m={math.floor(renderer.measure_text(nil,"[Nexus]  "..j.draw)*1.03)}
			local n={renderer.measure_text(nil,"[Nexus]  ")}
			local o={renderer.measure_text(nil,j.draw)}
			local p={c[1]/2-m[1]/2+3,c[2]-c[2]/140*13.4+e - 35}
			local g_r, g_g, g_b = ui.get(ui_stuff.glow_color)
			local r_bg, g_bg, b_bg, a_bg = ui.get(ui_stuff.background_color)
			local x, y = client.screen_size()

			if ui.get(ui_stuff.popaps) == "Centered" then
				if ui.get(ui_stuff.glow_enabled) then
					solus_render.container_glow(p[1] + 4, p[2], m[1], 19, g_r, g_g, g_b, 0, 1, g_r, g_g, g_b);
				end
				renderer_rectangle_rounded(p[1] + 4, p[2] , m[1], 19, r_bg, g_bg, b_bg, a_bg, 4)
	            
				renderer.text(p[1]-8+m[1]/2+n[1]/2,p[2] + 9,255,255,255, 255,"c",nil,j.draw)e=e-33
				
				---------
				renderer.circle_outline(p[1] + 7, p[2] + 3, g_r, g_g, g_b, 255, 3, 132, 0.4, 1.5) -- LEFT TOP
				---------
				renderer.circle_outline(p[1] + 7, p[2] + 16, g_r, g_g, g_b, 255, 3, 75, 0.4, 1.5) -- LEFT BOTTOM
				
				--------
				renderer.circle_outline(p[1]+m[1] + 1, p[2] + 3, g_r, g_g, g_b, 255, 3, 260, 0.4, 1.5) -- RIGHT UP
				--------
				renderer.circle_outline(p[1]+m[1] + 1, p[2] + 16, g_r, g_g, g_b, 255, 3, 312, 0.4, 1.5) -- RIGHT BOTTOM
				
				
				renderer.gradient(p[1] + 4, p[2] + 2, 2, 15, g_r, g_g, g_b, 255, g_r, g_g, g_b, 255, true) -- LEFT LINE
				renderer.gradient(p[1]+m[1] + 2, p[2] + 2, 2, 15, g_r, g_g, g_b, 255, g_r, g_g, g_b, 255, true) -- RIGHT LINE
				
				renderer.texture(logo_main, p[1] + 17, p[2] + 3, 13, 13, g_r, g_g, g_b, 255)

			end
			
			if ui.get(ui_stuff.popaps) == "Left screen" then
				renderer_rectangle_rounded(10, p[2] - 540 , m[1] + 25, 34, r_bg, g_bg, b_bg, a_bg, 5)
				renderer.text(45, p[2] -538,255,255,255,h,"-",nil,string.upper(j.draw))e=e+38
				renderer.texture(logo_push_left, 15, p[2] - 535, 25, 25, g_r, g_g, g_b, 255)
			end
			
		end
	end;
	self.callback_registered=true end)
end;
function a:paint(q,r)
	local s=tonumber(q)+1;
	for g=self.maximum_count,2,-1 do
		_G.nexus_notify_cache[g]=_G.nexus_notify_cache[g-1]
	end;
	_G.nexus_notify_cache[1]={time=s,def_time=s,draw=r}
self:register_callback()end;return a end)()

if ui.get(ui_stuff.popaps) == "Centered" then
	nexus_push:paint(5, "Welcome to nexus, "..obex_data.username)
end


function RGBtoHEX(redArg, greenArg, blueArg)
	return string.format('%.2x%.2x%.2xFF', redArg, greenArg, blueArg)
end

local function set_lua_menu()
	local is_aa = aa_vis
	local is_aa3 = ui.get(aacat) == "Builder"
	local is_aa2 = ui.get(aacat) == "Extras"
	local is_aa_exploits = ui.get(aacat) == "Exploits"
	local is_vis = visuals_vis
	local is_misc = misc_vis
	local is_debug = misc_vis
	local is_esploit = is_aa and ui.get(aacat) == "Exploits" and ui.get(ui_stuff.exploit_select) == "Pitch exploit"
	local is_knife = ui.get(ui_stuff.anti_knife)
	local is_enabled = ui.get(lua_enable)

	ui.set_visible(aa_init[0].defensive_inair, is_aa and is_aa2)
	ui.set_visible(aa_init[0].fix_hs, is_aa and is_aa2)
	
	ui.set_visible(ui_stuff.exploit_select, is_aa and is_aa_exploits)
	ui.set_visible(ui_stuff.defensive_lbl, ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" and is_aa and is_aa_exploits and is_enabled)
	ui.set_visible(ui_stuff.defensive_aa_key, ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" and is_aa and is_aa_exploits and is_enabled)
	ui.set_visible(ui_stuff.defensive_pitch, ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" and is_aa and is_aa_exploits and is_enabled)
	ui.set_visible(ui_stuff.defensive_yaw, ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" and is_aa and is_aa_exploits and is_enabled)
	
	ui.set_visible(ui_stuff.exploit_select, is_aa and is_aa_exploits)
	ui.set_visible(ui_stuff.esploit2, ui.get(ui_stuff.exploit_select) == "Pitch exploit" and is_aa and is_aa_exploits and is_enabled)
	
	local popups_show = is_vis and is_enabled and ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up")
	
	ui.set_visible(ui_stuff.popaps, popups_show)
	ui.set_visible(ui_stuff.background_text, popups_show)
	ui.set_visible(ui_stuff.background_color, popups_show)
	
	local show_glow = is_vis and is_enabled and ui.get(ui_stuff.watermark_enable) or is_vis and is_enabled and ui.get(ui_stuff.popaps) == "Centered"
	local show_aa = is_aa and is_enabled
	local glow_vis = show_glow and ui.get(ui_stuff.glow_enabled)
	
	ui.set_visible(ui_stuff.miss_text, popups_show and ui.get(ui_stuff.popaps) == "Centered")
	ui.set_visible(ui_stuff.miss_color, popups_show and ui.get(ui_stuff.popaps) == "Centered")
	ui.set_visible(ui_stuff.hit_text, popups_show and ui.get(ui_stuff.popaps) == "Centered")
	ui.set_visible(ui_stuff.hit_color, popups_show and ui.get(ui_stuff.popaps) == "Centered")
	
	ui.set_visible(ui_stuff.glow_enabled, show_glow and ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") or show_glow and ui.get(ui_stuff.watermark_enable))
	ui.set_visible(ui_stuff.glow_text, show_glow and glow_vis and ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") or show_glow and glow_vis and ui.get(ui_stuff.watermark_enable))
	ui.set_visible(ui_stuff.glow_color, show_glow and glow_vis and ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") or show_glow and glow_vis and ui.get(ui_stuff.watermark_enable))
	
	ui.set_visible(pitchxp.pitchxp_lbl, is_esploit)
	ui.set_visible(pitchxp.ticks, is_esploit)
	ui.set_visible(pitchxp.pitch, is_esploit)
	ui.set_visible(pitchxp.yaw, is_esploit)
	ui.set_visible(pitchxp.yawleft, is_esploit)
	ui.set_visible(pitchxp.yawright, is_esploit) 
	ui.set_visible(pitchxp.yawjitter , is_esploit)
	ui.set_visible(pitchxp.yawjitteradd , is_esploit and ui.get(pitchxp.yawjitter) ~= "Off" )
	
	
	ui.set_visible(legit_setts.legit_yaw, is_aa and is_aa2 and ui.get(aa_init[0].legit_aa))
	ui.set_visible(legit_setts.legit_yaw_add, is_aa and is_aa2 and ui.get(aa_init[0].legit_aa) and ui.get(legit_setts.legit_yaw) ~= "Off")
	ui.set_visible(legit_setts.legit_body, is_aa and is_aa2 and ui.get(aa_init[0].legit_aa))

	if is_enabled then
		set_og_menu(false)
		ui.set(ref.enabled, true)
	else
		set_og_menu(true)
		ui.set(ref.enabled, false)
	end

	ui.set_visible(aa_init[0].fast_weapon_switch, is_misc)
	ui.set_visible(ui_stuff.moonwalk_air, is_misc and ui.get(anim) == "Moonwalk")
	
	if is_debug and is_enabled then
		ui.set_visible(ui_stuff.trashtalk, true)
		ui.set_visible(ui_stuff.anti_knife, true)
		ui.set_visible(ui_stuff.tele, true)
		ui.set_visible(anim, true)
		ui.set_visible(anim_old, true)
		ui.set_visible(aa_init[0].aas, true)
	else
		ui.set_visible(ui_stuff.trashtalk, false)
		ui.set_visible(anim, false)
		ui.set_visible(anim_old, false)
		ui.set_visible(ui_stuff.anti_knife, false)
		ui.set_visible(ui_stuff.tele, false)
		ui.set_visible(aa_init[0].aas, false)
	end

	ui.set_visible(ui_stuff.tele_key, ui.get(ui_stuff.tele) and is_debug and is_enabled)

    if is_aa or is_vis or is_debug or config_vis and is_enabled then

		ui.set_visible(btn.lb2, false)
		ui.set_visible(btn.lb3, false)
		ui.set_visible(btn.lb6, false)
		ui.set_visible(btn.lb1, false)
		ui.set_visible(btn.lb5, false)
		ui.set_visible(btn.lb8, true)

	else
		ui.set_visible(btn.lb2, true)
		ui.set_visible(btn.lb5, true)
		ui.set_visible(btn.lb3, true)
		ui.set_visible(btn.lb1, true)
		ui.set_visible(btn.lb6, true)
	end

	if is_debug and is_enabled and ui.get(ui_stuff.debug_panel) then
		ui.set_visible(ui_stuff.panel_font, false)
	else
		ui.set_visible(ui_stuff.panel_font, false)
	end


	ui.set_visible(aa_init[0].brute_enable, is_aa and ui.get(aacat) == "Anti-bruteforce" and is_enabled)

	if is_aa and is_aa2 and is_enabled then

		ui.set_visible(aa_init[0].manuals, true)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].fs, true)
		ui.set_visible(aa_init[0].invalid_bt_ticks, true)
		ui.set_visible(aa_init[0].legit_aa, true)
		ui.set_visible(aa_init[0].manual_re,false)
		ui.set_visible(aa_init[0].fs_disablers, true)
	else

		ui.set_visible(aa_init[0].manuals, false)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].invalid_bt_ticks, false)
		ui.set_visible(aa_init[0].legit_aa, false)
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].manual_re,false)
		ui.set_visible(aa_init[0].fs, false)
		ui.set_visible(aa_init[0].fs_disablers, false)
	end
	
	if ui.get(aa_init[0].manuals) and is_aa2 and is_aa and is_enabled then

		ui.set_visible(aa_init[0].manual_left, true)
		ui.set_visible(aa_init[0].manual_right, true)
		ui.set_visible(aa_init[0].manual_forward, true)
		ui.set_visible(aa_init[0].manual_re,true)
		ui.set_visible(aa_init[0].fs, true)
		ui.set_visible(aa_init[0].fs_disablers, true)
		
	else
		ui.set_visible(aa_init[0].manual_forward, false)
		ui.set_visible(aa_init[0].manual_re,false)
		ui.set_visible(aa_init[0].manual_left, false)
		ui.set_visible(aa_init[0].manual_right, false)
		ui.set_visible(aa_init[0].fs, false)
		ui.set_visible(aa_init[0].fs_disablers, false)
	end


	ui.set_visible(ui_stuff.arrows_clr_lbl, is_vis and is_enabled and ui.get(ui_stuff.crosshair_inds) and ui.get(ui_stuff.arrw_selct) ~= "Off")
	ui.set_visible(ui_stuff.arrows_clr, is_vis and is_enabled and ui.get(ui_stuff.crosshair_inds) and ui.get(ui_stuff.arrw_selct) ~= "Off")
	
	ui.set_visible(ui_stuff.ts_arrows_clr_lbl, is_vis and is_enabled and ui.get(ui_stuff.crosshair_inds) and ui.get(ui_stuff.arrw_selct) == "Teamskeet")
	ui.set_visible(ui_stuff.ts_arrows_clr, is_vis and is_enabled and ui.get(ui_stuff.crosshair_inds) and ui.get(ui_stuff.arrw_selct) == "Teamskeet")

	local is_inds = is_vis and is_enabled and ui.get(ui_stuff.crosshair_inds) and ui.get(ui_stuff.inds_selct) ~= "Off"
	
	ui.set_visible(ui_stuff.main_clr_l, is_inds)
	ui.set_visible(ui_stuff.main_clr, is_inds)
	
	ui.set_visible(ui_stuff.dsy_clr_lbl, is_inds and ui.get(ui_stuff.inds_selct) == "Stylish")
	ui.set_visible(ui_stuff.dsy_clr, is_inds and ui.get(ui_stuff.inds_selct) == "Stylish")
	
	ui.set_visible(ui_stuff.glow_clr_l, is_inds and ui.get(ui_stuff.inds_selct) == "Alternative" or is_inds and ui.get(ui_stuff.inds_selct) == "Stylish")
	ui.set_visible(ui_stuff.glow_clr, is_inds and ui.get(ui_stuff.inds_selct) == "Alternative" or is_inds and ui.get(ui_stuff.inds_selct) == "Stylish")

	ui.set_visible(ui_stuff.main_clr2, is_inds)
	ui.set_visible(ui_stuff.main_clr_2, is_inds)
	
	if is_vis and is_enabled then
		ui.set_visible(ui_stuff.debug_panel, true)
		ui.set_visible(ui_stuff.crosshair_inds, true)
		ui.set_visible(ui_stuff.loger,true)
		ui.set_visible(ui_stuff.loger2,true)
		ui.set_visible(ui_stuff.watermark_enable, true) 
	else 
		ui.set_visible(ui_stuff.debug_panel, false)
		ui.set_visible(ui_stuff.crosshair_inds, false)
		ui.set_visible(ui_stuff.loger,false)
		ui.set_visible(ui_stuff.loger2, false)
		ui.set_visible(ui_stuff.watermark_enable, false)
	end
	
	if ui.get(ui_stuff.loger) and is_vis and is_enabled then 
		ui.set_visible(ui_stuff.loger2, true)
	else
		ui.set_visible(ui_stuff.loger2, false)
	end

	if ui.get(ui_stuff.crosshair_inds) and is_vis and is_enabled then
		ui.set_visible(ui_stuff.inds_selct, true)
		ui.set_visible(ui_stuff.arrw_selct, true)
	
	else
		ui.set_visible(ui_stuff.inds_selct, false)
		ui.set_visible(ui_stuff.arrw_selct, false)
	end

	ui.set_visible(ui_stuff.wtr_clr_1, is_vis and is_enabled and ui.get(ui_stuff.watermark_enable))
	ui.set_visible(ui_stuff.wtr_clr, is_vis and is_enabled and ui.get(ui_stuff.watermark_enable))
	ui.set_visible(ui_stuff.wtr_clr_bg1, is_vis and is_enabled and ui.get(ui_stuff.watermark_enable))
	ui.set_visible(ui_stuff.wtr_clr_bg, is_vis and is_enabled and ui.get(ui_stuff.watermark_enable))

	ui.set_visible(ui_stuff.draw_arrows, ui.get(ui_stuff.crosshair_inds) and is_vis and is_enabled and ui.get(ui_stuff.arrw_selct) ~= "Off")
	
	
	if  is_aa and is_aa3 and is_enabled and ui.get(aa_init[0].aa_builder) and not ui.get(aa_init[0].hide_builder) then
		ui.set_visible(aa_init[0].team, true)
	else
		ui.set_visible(aa_init[0].team, false)
	end
	
	ui.set_visible(aa_init[0].hide_builder, is_aa and is_aa3 and is_enabled and ui.get(aa_init[0].aa_builder))
	if is_aa then
		ui.set_visible(aacat, true)
	else
		ui.set_visible(aacat, false)
	end

	if is_aa and is_aa3 and is_enabled then

		ui.set_visible(aa_init[0].aa_builder, true)
	else
		ui.set_visible(aa_init[0].aa_builder, false)
	end
end

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

local function normalize_yaw(yaw)
	while yaw > 180 do yaw = yaw - 360 end
	while yaw < -180 do yaw = yaw + 360 end
	return yaw
end



local aa = {
	ignore = false,
	manaa = 0,
	input = 0,
}

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	local in_air = bit.band(flags, 1) == 0
	
	return in_air
end

local xxx = 'Standing'
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
		--xxx = ((entity.get_prop(lp, 'm_flDuckAmount') > 0.7) and ui.get(rage[state_to_num['Air crouch']].enable_aa)) and 'Air crouch' or 'Air'
		if not (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
			xxx = "Air"
		elseif (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
			xxx = 'Air crouch'
		end
	else
		if ui.get(ref.fakeduck) or (entity.get_prop(lp, 'm_flDuckAmount') > 0.7) then
			xxx = 'Crouching'
		elseif not_moving then
			xxx = 'Standing'
		elseif not not_moving then
			if slowwalk_key then
	
				xxx = 'Slow motion'
			else
	
				xxx = 'Running'
			end
		end
	end

    return xxx

end

local function invalid_ticks(cmd)

	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	
	if ui.get(aa_init[0].fix_hs) then
		if is_os and not ui.get(ref.fakeduck) then
			ui.set(ref.fakelag_legs, 1)
		else
			ui.set(ref.fakelag_legs	, 15)
		end
	end
	
end
client.set_event_callback("setup_command", invalid_ticks)

-- anti brute
local lastmiss = 0
local bruteforce_reset = true
local stage = 0
local shot_time = 0

client.set_event_callback("bullet_impact", function(e)
    if not ui.get(aa_init[0].brute_enable) then return end
    
	local me = entity.get_local_player()
	if not me then return end
	if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then return end
	
	local shooter_id = e.userid
	local shooter = client.userid_to_entindex(shooter_id)
	local shooter_name = entity.get_player_name(shooter)
	
	local lx, ly, lz = entity.hitbox_position(me, "head_0")
	local ox, oy, oz = entity.get_prop(me, "m_vecOrigin")
	local ex, ey, ez = entity.get_prop(shooter, "m_vecOrigin")
	

	local dist = ((e.y - ey)*lx - (e.x - ex)*ly + e.x*ey - e.y*ex) / math.sqrt((e.y-ey)^2 + (e.x - ex)^2)

	if not entity.is_enemy(shooter) or entity.is_dormant(shooter) then return end

    if bruteforce then return end
    if math.abs(dist) <= 35 and globals.curtime() - lastmiss > 0.015 then
        lastmiss = globals.curtime()
        bruteforce = true
        shot_time = globals.realtime()
        stage = stage >= 5 and 0 or stage + 1
        stage = stage == 0 and 1 or stage
        nexus_push:paint(5, "Player "..string.lower(shooter_name).." triggered anti-bruteforce - ["..stage.. "]")
	end
end)



client.set_event_callback("setup_command", function(cmd)
	if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then return end
    if bruteforce and ui.get(aa_init[0].brute_enable) then
        --client.set_event_callback("paint_ui", Returner)
        bruteforce = false
        bruteforce_reset = false
        stage = stage == 0 and 1 or stage
		brut3 = true
        set_brute = true
    else
        if shot_time + 3 < globals.realtime() or not ui.get(aa_init[0].brute_enable) then
            --client.unset_event_callback("paint_ui", Returner)
            set_brute = false
            brut3 = false
            stage = 0
            bruteforce_reset = true
            cmd.roll = 0
            set_brute = false

        end
    end
    return shot_time
end)


client.set_event_callback("setup_command", function(cmd)
    
    if set_brute == false then return end
	if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then return end

	
	local bf_state = "Phase 1"
	
	if stage == 1 then
		bf_state = "Phase 1"
	elseif stage == 2 then
		bf_state = "Phase 2"
	elseif stage == 3 then
		bf_state = "Phase 3"
	elseif stage == 4 then
		bf_state = "Phase 4"
	elseif stage == 5 then
		bf_state = "Phase 5"
	elseif stage <= 0 or stage > 5 then 
		return
	end
		ui.set(ref.bodyyaw[2], 0)
		if ui.get(aa_init[0].brute_enable) then
			if ui.get(aa_init[0].fs) then -- elpepe fs
				if xxx == "Standing" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Standing") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end

				elseif xxx == "Running" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Running") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Slow motion" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Slowwalk") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Air" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "In air") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Crouch T" or xxx == "Crouch CT" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Crouching") then 
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						ui.set(ref.freestand[2], "Always on")
					end
				end
			else
				ui.set(ref.freestand[1], true)
				ui.set(ref.freestand[2], "On hotkey")
			end
		
			
			bf_state = ui.get(bf[bf_state_to_num[bf_state]].bf_enable_aa) and bf_state_to_num[bf_state] or bf_state_to_num['Phase 1']
			
			ui.set(ref.pitch, ui.get(bf[bf_state].bf_c_pitch))
			ui.set(ref.yawbase, ui.get(bf[bf_state].bf_yawbase))
			
			ui.set(ref.yaw[1], ui.get(bf[bf_state].bf_yaw))
			
			if ui.get(bf[bf_state].bf_jitter_type) == "Static" then
				ui.set(ref.yawjitter[1], ui.get(bf[bf_state].bf_jitter))
				ui.set(ref.yawjitter[2], ui.get(bf[bf_state].bf_jitter_sli))
			elseif ui.get(bf[bf_state].bf_jitter_type) == "Left & Right" then
				if desync_side == 1 then
					ui.set(ref.yawjitter[1], ui.get(bf[bf_state].bf_jitter))
					ui.set(ref.yawjitter[2], ui.get(bf[bf_state].bf_right_jitter_sli))
				elseif desync_side == -1 then
					ui.set(ref.yawjitter[1], ui.get(bf[bf_state].bf_jitter))
					ui.set(ref.yawjitter[2], ui.get(bf[bf_state].bf_left_jitter_sli))
				end
			end

			ui.set(ref.bodyyaw[1], ui.get(bf[bf_state].bf_body))
			ui.set(ref.fsbodyyaw, ui.get(bf[bf_state].bf_freestand_byaw))
			
			
			
			local bf_yaw_angles = { ui.get(bf[bf_state].bf_yaw_1), ui.get(bf[bf_state].bf_yaw_2), ui.get(bf[bf_state].bf_yaw_3), ui.get(bf[bf_state].bf_yaw_4), ui.get(bf[bf_state].bf_yaw_5)}
			local bf_ways = (globals.tickcount() % #bf_yaw_angles) + 1
			
			local bf_yaw_angles_3way = { ui.get(bf[bf_state].bf_yaw_3way_1), ui.get(bf[bf_state].bf_yaw_3way_2), ui.get(bf[bf_state].bf_yaw_3way_3)}
			local bf_ways_3way = (globals.tickcount() % #bf_yaw_angles_3way) + 1
				
			if ui.get(bf[bf_state].bf_yaw_type) == "Left & Right" then
				if desync_side == 1 then
					--left
					ui.set(ref.yaw[2], ui.get(bf[bf_state].bf_left_limit))
				elseif desync_side == -1 then
					--right
					ui.set(ref.yaw[2], ui.get(bf[bf_state].bf_right_limit))
				end
			end
			if ui.get(bf[bf_state].bf_yaw_type) == "5-Way" then
				ui.set(ref.yaw[2], bf_yaw_angles[bf_ways])
			end
			if ui.get(bf[bf_state].bf_yaw_type) == "3-Way" then
				ui.set(ref.yaw[2], bf_yaw_angles_3way[bf_ways_3way])
			end
		end
end)

local g_antiaim = {}
g_antiaim.legit = {}
g_antiaim.legit.classnames = {"CWorld","CCSPlayer","CFuncBrush"}

function g_antiaim.legit:get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function g_antiaim.legit:entity_has_c4(ent)
	local bomb = entity.get_all("CC4")[1]
	return bomb ~= nil and entity.get_prop(bomb, "m_hOwnerEntity") == ent
end


local disable_use = false
function g_antiaim.legit:run_legit(cmd)

    if ui.get(aa_init[0].legit_aa) then
        local plocal = entity_get_local_player()
		
		local distance = 100
		local bomb = entity.get_all("CPlantedC4")[1]
		local bomb_x, bomb_y, bomb_z = entity.get_prop(bomb, "m_vecOrigin")

		if bomb_x ~= nil then
			local player_x, player_y, player_z = entity.get_prop(plocal, "m_vecOrigin")
			distance = self:get_distance(bomb_x, bomb_y, bomb_z, player_x, player_y, player_z)
		end
		
		local team_num = entity.get_prop(plocal, "m_iTeamNum")
		local defusing = team_num == 3 and distance < 62

		local on_bombsite = entity.get_prop(plocal, "m_bInBombZone")
   
		local has_bomb = self:entity_has_c4(plocal)
		local trynna_plant = on_bombsite ~= 0 and team_num == 2 and has_bomb and disable_use
		
		local px, py, pz = client_eye_position()
		local pitch, yaw = client_camera_angles()
	
		local sin_pitch = math.sin(math.rad(pitch))
		local cos_pitch = math.cos(math.rad(pitch))
		local sin_yaw = math.sin(math.rad(yaw))
		local cos_yaw = math.cos(math.rad(yaw))

		local dir_vec = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

		local fraction, entindex = client.trace_line(plocal, px, py, pz, px + (dir_vec[1] * 8192), py + (dir_vec[2] * 8192), pz + (dir_vec[3] * 8192))

		local using = true

		if entindex ~= nil then
			for i=0, #self.classnames do
				if entity.get_classname(entindex) == self.classnames[i] then
					using = false
				end
			end
		end

		if not using and not trynna_plant and not defusing then
			cmd.in_use = 0
		end
    end
end


function g_antiaim:run_main(cmd)
    self.legit:run_legit(cmd)
end

local setup_command = function(cmd)
    self = main or self
    g_antiaim:run_main(cmd)
end
client.set_event_callback("setup_command", setup_command)


-- manual aa stuff
local last_press_t_dir = 0
local yaw_direction = 0
local run_direction = function()
	ui.set(aa_init[0].manual_forward, 'On hotkey')
	ui.set(aa_init[0].manual_left, 'On hotkey')
	ui.set(aa_init[0].manual_right, 'On hotkey')
	ui.set(aa_init[0].manual_re, 'On hotkey')

	if ui.get(aa_init[0].manual_forward) and last_press_t_dir + 0.21 < globals.curtime() then
		yaw_direction = yaw_direction == 180 and 0 or 180
		last_press_t_dir = globals.curtime()
	elseif ui.get(aa_init[0].manual_right) and last_press_t_dir + 0.21 < globals.curtime() then
		yaw_direction = yaw_direction == 90 and 0 or 90
		last_press_t_dir = globals.curtime()
	elseif ui.get(aa_init[0].manual_left) and last_press_t_dir + 0.21 < globals.curtime() then
		yaw_direction = yaw_direction == -90 and 0 or -90
		last_press_t_dir = globals.curtime()
	elseif ui.get(aa_init[0].manual_re) and last_press_t_dir + 0.21 < globals.curtime() then
		yaw_direction = yaw_direction == 0 and 0 or 0
		last_press_t_dir = globals.curtime()
	elseif last_press_t_dir > globals.curtime() then
		last_press_t_dir = globals.curtime()
	end
end
client.set_event_callback('setup_command', run_direction)

local do_jitter = true
client.set_event_callback("setup_command", function(e)
	
	local lp = entity.get_local_player()
	if lp == nil or not entity.is_alive(lp) then
		return
	end
	
	local desync_type = entity.get_prop(lp, 'm_flPoseParameter', 11) * 120 - 60
	local desync_side = desync_type > 0 and 1 or -1
	
	local teamnum = entity.get_prop(lp, 'm_iTeamNum')

    local is_ct = teamnum == 3
    local is_t = teamnum == 2

	local l = 1
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fd = ui.get(ref.fakeduck)
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	
	ui.set(aa_init[0].manual_forward, "On hotkey")
	ui.set(aa_init[0].manual_left, "On hotkey")
	ui.set(aa_init[0].manual_right, "On hotkey")
	ui.set(aa_init[0].manual_re, "On hotkey")

	if ui.get(aa_init[0].defensive_inair) or ui.get(aa_init[0].invalid_bt_ticks) then
		if e.in_jump == 1 and is_dt then
			e.force_defensive = true
		else
			e.force_defensive = false
		end
	end
	
	local state = get_mode(e)
	
	if stage == 0 then
		if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then
		
			ui.set(ref.freestand[1], false)
			ui.set(ref.freestand[2], "On hotkey")
			ui.set(ref.pitch, "Off")
			
			ui.set(ref.yawbase, "Local view")
 			ui.set(ref.fsbodyyaw, true)
			ui.set(ref.bodyyaw[1], ui.get(legit_setts.legit_body))
			ui.set(ref.yaw[1], ui.get(legit_setts.legit_yaw))
			ui.set(ref.yaw[2], ui.get(legit_setts.legit_yaw_add))
			
		else
			if not ui.get(aa_init[0].aa_builder) then return end
			ui.set(ref.pitch, "Down")
			ui.set(ref.bodyyaw[2], 0)
			
			if ui.get(aa_init[0].fs) then -- elpepe fs
				if xxx == "Standing" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Standing") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end

				elseif xxx == "Running" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Running") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Slow motion" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Slowwalk") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Air" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "In air") then
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						
						ui.set(ref.freestand[2], "Always on")
					end
				elseif xxx == "Crouch T" or xxx == "Crouch CT" then
					if contains_selected(ui.get(aa_init[0].fs_disablers), "Crouching") then 
						ui.set(ref.freestand[1], false)
						ui.set(ref.freestand[2], "On hotkey")
					else
						ui.set(ref.freestand[2], "Always on")
					end
				end
			else
				ui.set(ref.freestand[1], true)
				ui.set(ref.freestand[2], "On hotkey")
			end
			
			if ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" and ui.get(ui_stuff.defensive_aa_key) and is_dt and not client.key_state(0x45) then
				e.force_defensive = true
				ui.set(ref.yaw[1], ui.get(ui_stuff.defensive_yaw))
				if desync_side == 1 then
					--left
					ui.set(ref.yaw[2], 90)
				elseif desync_side == -1 then
					--right
					ui.set(ref.yaw[2], 90)
				end
				ui.set(ref.yawjitter[1], "Center")
				ui.set(ref.yawjitter[2], 180)
 				ui.set(ref.pitch, ui.get(ui_stuff.defensive_pitch))
				ui.set(ref.bodyyaw[1], "jitter")
				
			elseif not ui.get(ui_stuff.exploit_select) == "Defensive anti-aim" or not ui.get(ui_stuff.defensive_aa_key) and not client.key_state(0x45)then
				
				local ticks_amount = ui.get(pitchxp.ticks) * 1.5
					
				if ui.get(ui_stuff.exploit_select) == "Pitch exploit" and ui.get(ui_stuff.esploit2) and globals.tickcount() % ticks_amount < 7 and is_dt and not client.key_state(0x45) then
					e.force_defensive = true
					if desync_side == 1 then
						--left
						ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(pitchxp.yawleft) or yaw_direction)
					elseif desync_side == -1 then
						--right
						ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(pitchxp.yawright) or yaw_direction)
					end
					ui.set(ref.yawjitter[1], ui.get(pitchxp.yawjitter))
					ui.set(ref.yawjitter[2], ui.get(pitchxp.yawjitteradd))
					ui.set(ref.pitch, ui.get(pitchxp.pitch))
 				else
					if not ui.get(ui_stuff.defensive_aa_key) and not ui.get(ui_stuff.esploit2) and not ui.get(aa_init[0].defensive_inair) and not ui.get(aa_init[0].invalid_bt_ticks) then
						e.force_defensive = false
					end
					ui.set(ref.enabled, true)
					
					-- TEAM T
					if is_t then
						state = ui.get(rage[state_to_num[state]].t_enable_aa) and state_to_num[state] or state_to_num['Shared']
						ui.set(ref.pitch, ui.get(rage[state].t_c_pitch))
						if yaw_direction ~= 0 then
							ui.set(ref.yawbase, "Local view")
						else
							ui.set(ref.yawbase, ui.get(rage[state].t_yawbase))
						end
						
						ui.set(ref.yaw[1], ui.get(rage[state].t_yaw))
						
						if ui.get(rage[state].t_jitter_type) == "Static" then
							ui.set(ref.yawjitter[1], ui.get(rage[state].t_jitter))
							ui.set(ref.yawjitter[2], ui.get(rage[state].t_jitter_sli))
						elseif ui.get(rage[state].t_jitter_type) == "Left & Right" then
							if desync_side == 1 then
								ui.set(ref.yawjitter[1], ui.get(rage[state].t_jitter))
								ui.set(ref.yawjitter[2], ui.get(rage[state].t_right_jitter_sli))
							elseif desync_side == -1 then
								ui.set(ref.yawjitter[1], ui.get(rage[state].t_jitter))
								ui.set(ref.yawjitter[2], ui.get(rage[state].t_left_jitter_sli))
							end
						end
						
						ui.set(ref.bodyyaw[1], ui.get(rage[state].t_body))
						ui.set(ref.fsbodyyaw, ui.get(rage[state].t_freestand_byaw))
						
				
						local t_yaw_angles = { ui.get(rage[state].t_yaw_1), ui.get(rage[state].t_yaw_2), ui.get(rage[state].t_yaw_3), ui.get(rage[state].t_yaw_4), ui.get(rage[state].t_yaw_5)}
						local t_ways = (globals.tickcount() % #t_yaw_angles) + 1
						
						local t_yaw_angles_3way = { ui.get(rage[state].t_yaw_3way_1), ui.get(rage[state].t_yaw_3way_2), ui.get(rage[state].t_yaw_3way_3)}
						local t_ways_3way = (globals.tickcount() % #t_yaw_angles_3way) + 1
					
						if ui.get(rage[state].t_yaw_type) == "Left & Right" then
							if desync_side == 1 then
								--left
								ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].t_left_limit) or yaw_direction)
							elseif desync_side == -1 then
								--right
								ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].t_right_limit) or yaw_direction)
							end
						end
						if ui.get(rage[state].t_yaw_type) == "5-Way" then
							ui.set(ref.yaw[2], yaw_direction == 0 and t_yaw_angles[t_ways] or yaw_direction)
						end
						if ui.get(rage[state].t_yaw_type) == "3-Way" then
							ui.set(ref.yaw[2], yaw_direction == 0 and t_yaw_angles_3way[t_ways_3way] or yaw_direction)
						end
					else
						-- CT TEAM
						state = ui.get(rage[state_to_num[state]].ct_enable_aa) and state_to_num[state] or state_to_num['Shared']
						ui.set(ref.pitch, ui.get(rage[state].ct_c_pitch))
						if yaw_direction ~= 0 then
							ui.set(ref.yawbase, "Local view")
						else
							ui.set(ref.yawbase, ui.get(rage[state].ct_yawbase))
						end
						
						ui.set(ref.yaw[1], ui.get(rage[state].ct_yaw))
						
						if ui.get(rage[state].ct_jitter_type) == "Static" then
							ui.set(ref.yawjitter[1], ui.get(rage[state].ct_jitter))
							ui.set(ref.yawjitter[2], ui.get(rage[state].ct_jitter_sli))
						elseif ui.get(rage[state].ct_jitter_type) == "Left & Right" then
							if desync_side == 1 then
								ui.set(ref.yawjitter[1], ui.get(rage[state].ct_jitter))
								ui.set(ref.yawjitter[2], ui.get(rage[state].ct_right_jitter_sli))
							elseif desync_side == -1 then
								ui.set(ref.yawjitter[1], ui.get(rage[state].ct_jitter))
								ui.set(ref.yawjitter[2], ui.get(rage[state].ct_left_jitter_sli))
							end
						end
						
						ui.set(ref.bodyyaw[1], ui.get(rage[state].ct_body))
						ui.set(ref.fsbodyyaw, ui.get(rage[state].ct_freestand_byaw))
						
						
					
						local ct_yaw_angles = { ui.get(rage[state].ct_yaw_1), ui.get(rage[state].ct_yaw_2), ui.get(rage[state].ct_yaw_3), ui.get(rage[state].ct_yaw_4), ui.get(rage[state].ct_yaw_5)}
						local ct_ways = (globals.tickcount() % #ct_yaw_angles) + 1
						
						local ct_yaw_angles_3way = { ui.get(rage[state].ct_yaw_3way_1), ui.get(rage[state].ct_yaw_3way_2), ui.get(rage[state].ct_yaw_3way_3)}
						local ct_ways_3way = (globals.tickcount() % #ct_yaw_angles_3way) + 1
					
						if ui.get(rage[state].ct_yaw_type) == "Left & Right" then
							if desync_side == 1 then
								--left
								ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].ct_left_limit) or yaw_direction)
							elseif desync_side == -1 then
								--right
								ui.set(ref.yaw[2], yaw_direction == 0 and ui.get(rage[state].ct_right_limit) or yaw_direction)
							end
						end
						if ui.get(rage[state].ct_yaw_type) == "5-Way" then
							ui.set(ref.yaw[2], yaw_direction == 0 and ct_yaw_angles[ct_ways] or yaw_direction)
						end
						if ui.get(rage[state].ct_yaw_type) == "3-Way" then
							ui.set(ref.yaw[2], yaw_direction == 0 and ct_yaw_angles_3way[ct_ways_3way] or yaw_direction)
						end
					end
				end
			end
		end
	end
end)

anti_knife_dist = function (x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local function anti_knife()
    if ui.get(ui_stuff.anti_knife) then
        local players = entity.get_players(true)
        local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
        local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
        local pitch = ui.reference("AA", "Anti-aimbot angles", "Pitch")

        for i=1, #players do
            local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
            local distance = anti_knife_dist(lx, ly, lz, x, y, z)
            local weapon = entity.get_player_weapon(players[i])
            if entity.get_classname(weapon) == "CKnife" and distance <= 200 then
                ui.set(yaw_slider,180)
                ui.set(pitch,"Off")
            end
        end
    end
end

client.set_event_callback("setup_command", anti_knife)

brute.reset = function()
	stage = 0
	brute.fs_side = 0
	brute.last_miss = 0
	brute.best_angle = 0
	brute.misses_ind = { }
	brute.misses = { }
end


local killsays = {
	"𝕤𝕜𝕖𝕖𝕥 𝕕𝕠𝕟𝕥 𝕟𝕖𝕖𝕕 𝕦𝕡𝕕 𝕓𝕦𝕥 𝕚𝕥 𝕦𝕡𝕕 (◣_◢)",
	"𝙉𝙀𝙓𝙐𝙎 1 - 𝙮𝙤𝙪 0",
	"1 ",
	"why are u dead?",
	"𝐔 𝐂𝐀𝐍𝐓 𝐇𝐈𝐓 𝐌𝐘 𝐇𝐄𝐀𝐃 (◣_◢)",
	"иди купи нексус нуб",
	"hs",
	'˜" ° • .˜ "° • 1 • °" ˜. • ° "˜',
	"★ EZ U SHOOT MY DESYNC ★ ",
	"одним ботом меньше",
	"𝗡𝗘𝗫𝗨𝗦.𝗧𝗘𝗖𝗛 𝗕𝗘𝗦𝗧 𝗔𝗔 𝗧𝗘𝗖𝗛𝗡𝗢𝗟𝗢𝗚𝗬",
	"╚═★ 𝑔𝑜𝑑 𝑏𝑙𝑒𝑠𝑠 𝑔𝑎𝑚𝑒𝑠𝑒𝑛𝑠𝑒 ★═╝",
	"ты не можешь ударить меня по голове",
	"𝐃𝐄𝐏𝐎𝐑𝐓𝐄𝐃 𝐓𝐎 𝐌𝐀𝐃𝐀𝐆𝐀𝐒𝐂𝐀𝐑",
	"𝔹𝔸𝕀𝕋𝔼𝔻 𝕃𝕀𝕂𝔼 𝔸 𝔽𝕀𝕊ℍ (◣_◢)",
	"ｓｈｏｐｐｙ．ｇｇ／＠ｎｅｘｕｓ．ｔｅｃｈ",
	"⤹★ NEXUS ★⤸",
	"▞▞▞ ▞▞▞1▞▞▞ ▞▞▞",
	"WHY SO BAD? LMAO",
	"𝔾𝕖𝕥 𝕠𝕨𝕟𝕖𝕕 𝕓𝕠𝕥 ℍ𝔸ℍ𝔸ℍ𝔸 (◣_◢)",
	"you try to kill god(me) now you are burning in hell",
	"outplayed by the blessed legend",
}

local function onPlayerDeath(e)

	if not ui.get(ui_stuff.trashtalk) then return end
	local attacker_entindex = client.userid_to_entindex(e.attacker)
	local victim_entindex = client.userid_to_entindex(e.userid)
	local local_player = entity.get_local_player()

	if attacker_entindex ~= local_player or victim_entindex == local_player then
		return
	end
	
	client.exec("say "..killsays[client.random_int(1, #killsays)])
end

client.set_event_callback("player_death", onPlayerDeath)

local function watermark()
	
	local data_suffix = 'nexus'

	local h, m, s, mst = client.system_time()

	local actual_time = ('%2d:%02d'):format(h, m)

	local nickname = obex_data.username
	local g_r, g_g, g_b = ui.get(ui_stuff.glow_color)
	local rr, gg, gb = ui.get(ui_stuff.wtr_clr)
	local r_bg, g_bg, b_bg, a_bg = ui.get(ui_stuff.wtr_clr_bg)
	local realtime = globals.realtime() % 3
	
	local colorxd = RGBtoHEX(rr, gg, gb)
	
	text = (" %s [ \a"..colorxd..""..obex_data.build.. "\aFFFFFFFF ]   /   \aFFFFFFFF%s    \aFFFFFFFF/   \a"..colorxd.."%s   "):format(data_suffix, nickname, actual_time)
		
	local h, w = 18, renderer.measure_text(nil, text) + 8
	local x, y = client.screen_size(), 10 + (-3)
		
	x = x - w - 10


	if ui.get(ui_stuff.watermark_enable) then

		solus_render.container_glow(x - 19, y, w + 18, 21, g_r, g_g, g_b, a_bg, 1, g_r, g_g, g_b);
		renderer_rectangle_rounded(x - 19, y, w + 18, 21,  r_bg, g_bg, b_bg, a_bg, 4)
		renderer.texture(logo_main, x - 12, y + 4, 13, 13, g_r, g_g, g_b, 255)
		renderer.text(x+7, y + 4, 255, 255, 255, 255, '', 0, text)
	end
end
client.set_event_callback("paint", watermark)

local function animation(check, start_val, end_val, speed)

    if check then
        return math.max(start_val + (end_val - start_val) * speed/300, 0)
    else
		return math.max(start_val - (end_val + start_val) * speed/4/300, 0)
    end
end

local wiwi = {
	dt_a = 0,
	dt_y = 45,
	dt_x = 0,
	dt_w = 0,
	
	os_a = 0,
	os_y = 45,
	os_x = 0,
	os_w = 0,
	
	fs_a = 0,
	fs_y = 45,
	fs_x = 0,
	fs_w = 0,
	
	lele = 0,
	
	xpos_idk = 0,
	xpos = 0,
	xpos_dt = 0,
	xpos_dsy = 0,
	xpos_binds = 0,
	xpos_os = 0,
	xpos_idealtick = 0,
	xpos_gradient = 0,
	xpos_state = 0,
	
	y_add = 0,
}

local xs = {
	active_fraction = 0,
	inactive_fraction = 0,
	hide_fraction = 0,
	scoped_fraction = 0,
	fraction = 0,
}

local function draw()
	local bodyyaw = math.min(57, math.abs(entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11)*120-60))
	local bodyyaw_arrows = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local side = bodyyaw > 0 and 1 or -1

	local mr,mg,mb,ma = ui.get(ui_stuff.arrows_clr)
	local ts_r, ts_g, ts_b, ts_a = ui.get(ui_stuff.ts_arrows_clr)
	local x, y = client.screen_size()
	
	local me = entity.get_local_player()

	if not entity.is_alive(me) then return end
	
	local wpn = entity.get_player_weapon(me)
	local weapon_id = entity.get_prop(wpn, "m_iItemDefinitionIndex")

	local is_charged = antiaim_funcs.get_double_tap()
	local is_dt = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
	local is_os = ui.get(ref.os[1]) and ui.get(ref.os[2])
	local is_fs = ui.get(aa_init[0].fs)
	local is_ba = ui.get(ref.forcebaim)
	local is_sp = ui.get(ref.safepoint)
	local is_qp = ui.get(ref.quickpeek[2])

	if is_charged then dr,dg,db,da=0, 255, 0,255 elseif is_os then dr,dg,db,da=255,255,255,255 else dr,dg,db,da=255,0,0,255 end;if is_qp then qr,qg,qb,qa=255,255,255,255 else qr,qg,qb,qa=255,255,255,150 end;if is_ba then br,bg,bb,ba=255,255,255,255 else br,bg,bb,ba=255,255,255,150 end;if is_fs then fr,fg,fb,fa=255,255,255,255 else fr,fg,fb,fa=255,255,255,150 end;if is_sp then sr,sg,sb,sa=255,255,255,255 else sr,sg,sb,sa=255,255,255,150 end


	--states [for searching] 
	local add_y = 0
	local realtime = globals.realtime() % 3
	local scpd = entity.get_prop(me, "m_bIsScoped")
	local scope_level = entity.get_prop(wpn, 'm_zoomLevel')
	local resume_zoom = entity.get_prop(me, 'm_bResumeZoom') == 1
	local scoped_default = scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48

	
	local p_state = "STANDING"
	local anti_aim_invert = bodyyaw_arrows > 0 and 1 or -1
    local vecvelocity = { entity.get_prop(me, 'm_vecVelocity') }
    local velocity = math.sqrt(vecvelocity[1] ^ 2 + vecvelocity[2] ^ 2)
    local on_ground = bit.band(entity.get_prop(me, 'm_fFlags'), 1) == 1
    local not_moving = velocity < 2

    local slowwalk_key = ui.get(ref.slow[1]) and ui.get(ref.slow[2])
    local teamnum = entity.get_prop(me, 'm_iTeamNum')

    local ct  = teamnum == 3
    local t   = teamnum == 2

    if not ui.get(ref.bhop) then
        on_ground = bit.band(entity.get_prop(me, 'm_fFlags'), 1) == 1
    end
    
    if not on_ground then
		if not (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
			p_state = "AIR"
		elseif (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
			p_state = "AIR CROUCH"
		end
    else
        if ui.get(ref.fakeduck) or (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
			p_state = 'Crouching'
        elseif not_moving then
			p_state = 'Standing'
        elseif not not_moving then
			if slowwalk_key then
				p_state = 'Slow motion'
            else
                p_state = 'Running'
            end
        end
	end
	
	if is_dt then if wiwi.dt_a<255 then wiwi.dt_a=wiwi.dt_a+5 end;if wiwi.dt_w<10 then wiwi.dt_w=wiwi.dt_w+0.28 end;if wiwi.dt_y<36 then wiwi.dt_y=wiwi.dt_y+1 end;if wiwi.fs_x<11 then wiwi.fs_x=wiwi.fs_x+0.25 end elseif not is_dt then if wiwi.dt_a>0 then wiwi.dt_a=wiwi.dt_a-5 end;if wiwi.dt_w>0 then wiwi.dt_w=wiwi.dt_w-0.2 end;if wiwi.dt_y>25 then wiwi.dt_y=wiwi.dt_y-1 end;if wiwi.fs_x>0 then wiwi.fs_x=wiwi.fs_x-0.25 end end;if is_os and not is_dt then if wiwi.os_a<255 then wiwi.os_a=wiwi.os_a+5 end;if wiwi.os_w<12 then wiwi.os_w=wiwi.os_w+0.28 end;if wiwi.os_y<36 then wiwi.os_y=wiwi.os_y+1 end;if wiwi.fs_x<12 then wiwi.fs_x=wiwi.fs_x+0.5 end elseif not is_os and not is_dt then if wiwi.os_a>0 then wiwi.os_a=wiwi.os_a-5 end;if wiwi.os_w>0 then wiwi.os_w=wiwi.os_w-0.2 end;if wiwi.os_y>25 then wiwi.os_y=wiwi.os_y-1 end;if wiwi.fs_x>0 then wiwi.fs_x=wiwi.fs_x-0.5 end end;if is_fs then if wiwi.fs_w<10 then wiwi.fs_w=wiwi.fs_w+0.35 end;if wiwi.fs_a<255 then wiwi.fs_a=wiwi.fs_a+5 end;if wiwi.dt_x>-7 then wiwi.dt_x=wiwi.dt_x-0.5 end;if wiwi.os_x>-7 then wiwi.os_x=wiwi.os_x-0.5 end;if wiwi.fs_y<36 then wiwi.fs_y=wiwi.fs_y+1 end elseif not is_fs then if wiwi.fs_a>0 then wiwi.fs_a=wiwi.fs_a-5 end;if wiwi.fs_w>0 then wiwi.fs_w=wiwi.fs_w-0.2 end;if wiwi.dt_x<0 then wiwi.dt_x=wiwi.dt_x+0.5 end;if wiwi.os_x<0 then wiwi.os_x=wiwi.os_x+0.5 end;if wiwi.fs_y>25 then wiwi.fs_y=wiwi.fs_y-1 end end
	
	if ui.get(ui_stuff.inds_selct) == "Stylish" and ui.get(ui_stuff.crosshair_inds) then
		
		wiwi.xpos = animation(scoped_default, wiwi.xpos, 37, 20) or 0
		wiwi.xpos_dt = animation(scoped_default, wiwi.xpos_dt, 19, 20) or 0
		wiwi.xpos_dsy = animation(scoped_default, wiwi.xpos_dsy, 37, 20) or 0
		wiwi.xpos_binds = animation(scoped_default, wiwi.xpos_binds, 32, 20) or 0
		wiwi.xpos_os = animation(scoped_default, wiwi.xpos_os, 15, 17) or 0
		wiwi.xpos_idealtick = animation(scoped_default, wiwi.xpos_idealtick, 28, 20) or 0
		wiwi.xpos_state = animation(scoped_default, wiwi.xpos_state, 10, 20) or 0
		wiwi.xpos_gradient = animation(scoped_default, wiwi.xpos_gradient, 35, 20) or 0
		
		wiwi.xpos_idk = animation(scoped_default, wiwi.xpos_idk, 19, 20) or 0
		
		wiwi.y_add = animation(is_dt or is_os, wiwi.y_add, 10, 20) or 0
		

		local charge = antiaim_funcs.get_tickbase_shifting() * 0.1
		local r, g, b = ui.get(ui_stuff.main_clr)
		local r2, g2, b2 = ui.get(ui_stuff.main_clr2)
		local rg, gg, bg = ui.get(ui_stuff.glow_clr)
		local dsy_r, dsy_g, dsy_b = ui.get(ui_stuff.dsy_clr)

		if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then
			p_state = "LEGIT"
		else
			if not on_ground then
				if not (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR"
				elseif (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR+DUCK"
				end
			else
				if ui.get(ref.fakeduck) or (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = 'CROUCH'
				elseif not_moving then
					p_state = 'STAND'
				elseif not not_moving then
					if slowwalk_key then
						p_state = 'SLOWMOTION'
					else
						p_state = 'MOVING'
					end
				end
			end
		end
		
		if scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48 then 
			alpha_scope = 60
			alpha = math.floor(math.sin(realtime * 4) * (22 / 2 - 1) + 22 / 2) or 22
		else
			alpha_scope = 255
			alpha = math.floor(math.sin(realtime * 4) * (100 / 2 - 1) + 100 / 2) or 100
		end
		
		local ret = ctx.helpers:animate_text(globals.curtime() * 1.4, "nexus.tech", r2, g2, b2, alpha_scope)

		ctx.m_render:glow_module(x/2 - 25 + wiwi.xpos_gradient, y/2 + 34, 50, -0.2, 9, 0, {rg, gg, bg, alpha}, {rg, gg, bg, alpha})
		ctx.m_render:glow_module(x/2 - 25 + wiwi.xpos_gradient, y/2 + 41, 50, -0.2, 9, 0, {rg, gg, bg, alpha}, {rg, gg, bg, alpha})

		renderer.text(x / 2 - 1 + wiwi.xpos_idk, y / 2 + 27 , 110, 110, 110, alpha_scope, "c-", 0, "BETA")
		
		renderer.text(x / 2 - 1 + wiwi.xpos, y / 2 + 34, r, g, b, alpha_scope, "cb", 0, "nexus.tech")
		renderer.text(x / 2 - 1 + wiwi.xpos, y / 2 + 34, r2, g2, b2, alpha_scope, "cb", 0, "",unpack(ret))
		
		renderer_rectangle_rounded(x / 2 - 27 + wiwi.xpos_dsy, y / 2 + 40, 53, 4, 0, 0, 0, alpha_scope, 1)
		renderer_rectangle_rounded(x / 2 - 27 + wiwi.xpos_dsy, y / 2 + 41, 0+(math.abs(bodyyaw*58/62)), 2, dsy_r, dsy_g, dsy_b, alpha_scope, 1)

		if scoped_default then
			renderer.text(x / 2 - 1 + wiwi.xpos_state , y / 2 + 43, 150, 150, 150, alpha_scope, "-", 0, string.upper(p_state)) -- + n2_x - testting
		else
			renderer.text(x / 2 - 1 + wiwi.xpos_state, y / 2 + 49, 150, 150, 150, alpha_scope, "c-", 0, string.upper(p_state)) -- + n2_x - testting
		end

		if is_dt then
			if charge <= 0 then
				renderer.text(x / 2 - 6 + wiwi.xpos_dt, y / 2 + 59 , 110, 110, 110, alpha_scope, "c-", 0, "DT")
			else
				renderer.text(x / 2 - 6 + wiwi.xpos_dt, y / 2 + 59 , 255, 255, 255, alpha_scope, "c-", 0, "DT")
			end
			renderer.circle_outline(x / 2 + 5 + wiwi.xpos_dt, y / 2 + 60, 50, 50, 50, alpha_scope, 3, 1, 1, 1)
			renderer.circle_outline(x / 2 + 5 + wiwi.xpos_dt, y / 2 + 60, 200, 200, 200, alpha_scope, 3, 1, charge, 1)
		else
			if is_os then
				renderer.text(x / 2 + wiwi.xpos_os - 1, y / 2 + 59, 255, 255, 255, alpha_scope, "c-", 0, "OS")
			end
		end
		
		if is_sp then
			renderer.text(x / 2 -18 + wiwi.xpos_binds , y / 2  + 59 + wiwi.y_add, 255, 255, 255, alpha_scope, "c-", 0, "SP")
		else 
			renderer.text(x / 2 -18 + wiwi.xpos_binds , y / 2  + 59 + wiwi.y_add, 110, 110, 110, alpha_scope, "c-", 0, "SP")
		end
		
		if is_ba then 
		
			renderer.text(x / 2 + wiwi.xpos_binds - 1, y / 2  + 59 + wiwi.y_add, 255, 255, 255, alpha_scope, "c-", 0, "BAIM")
		else
			renderer.text(x / 2 + wiwi.xpos_binds - 1, y / 2  + 59 + wiwi.y_add, 110, 110, 110, alpha_scope, "c-", 0, "BAIM")
		end

		if is_fs then 
			renderer.text(x / 2+ 15 + wiwi.xpos_binds, y / 2  + 59 + wiwi.y_add, 255, 255, 255, alpha_scope, "c-", 0, "FS")
		else
			renderer.text(x / 2+ 15 + wiwi.xpos_binds, y / 2  + 59 + wiwi.y_add, 110, 110, 110, alpha_scope, "c-", 0, "FS")
		end 

	end

	local threat = client.current_threat()
	local cur_threat = threat == nil and "nil" or entity.get_player_name(threat)
	
	if string.len(cur_threat) > 15 then 
		cur_threat = "long name retard"
	end

	if ui.get(ui_stuff.panel_font) == "regular" then
		font_size = "r"
		text_separation = "0"
	else
		font_size = "+r"
		text_separation = 10	
	end
	
	if ui.get(ui_stuff.debug_panel) then
	
		--local alpha_panel = math.floor(math.sin(realtime * 4) * (180 / 2 - 1) + 180 / 2) or 180
		local alpha_panel = math.sin(math.abs(-math.pi + (globals.curtime() * (1 / 0.7)) % (math.pi * 2))) * 255

	
        if is_dt or is_os then
            renderer.text(x-5, y/2 - 28 + text_separation * 2, 255, 255, 255, 255, "r", 0, "true") 
        else
            renderer.text(x-5, y/2 - 28 + text_separation * 2, 255, 255, 255, 255, "r", 0, "false") 
        end
		renderer.text(x-5, y/2 - 50 + text_separation, 255, 255, 255, 255, "r", 0, "nexus.tech - "..obex_data.username) 
		renderer.text(x-37, y/2 - 40 + text_separation, 255, 255, 255, 255,  "r", 0, "version: ") 
		renderer.text(x-5, y/2 - 40 + text_separation, 255, 255, 255, alpha_panel,  "r", 0, obex_data.build) 
		renderer.text(x-28, y/2 - 28 + text_separation * 2, 255, 255, 255, 255, "r", 0, "exploit charge: ") --ticks shifteados
		renderer.text(x-42, y/2 - 16 + text_separation * 3, 255, 255, 255, 255, "r", 0, "desync amount: ")
		renderer.text(x-5, y/2 - 16 + text_separation * 3, 255, 255, 255, 255, "r", 0, "" ..math.floor(bodyyaw).."(" ..math.floor(bodyyaw) .."°)" )
		renderer.text(x-5, y/2 - 5 + text_separation * 4, 255, 255, 255, 255, "r", 0, "target: " ..cur_threat)
	
		if entity.get_local_player() == nil or not entity.is_alive(entity.get_local_player()) then return end
		local weapon_idx = entity.get_player_weapon(entity.get_local_player())
		local local_player = entity.get_local_player()
		local active_weapon = entity.get_player_weapon(local_player) == nil and 1 or entity.get_player_weapon(local_player)
		local weapon = csgo_weapons[entity.get_prop(active_weapon, "m_iItemDefinitionIndex")]
		if weapon == nil then return end
		local weapon_name = entity.get_classname(weapon_idx)
		local weapon_icon = images.get_weapon_icon(weapon) == nil and images.get_weapon_icon("weapon_ak47") or images.get_weapon_icon(weapon)
		local bullet_icon = images.get_panorama_image("icons/ui/bullet_burst.svg")
		local bullet_icon2 = images.get_panorama_image("icons/ui/bullet_burst_outline.svg")
		local bullet_icon3 = images.get_panorama_image("icons/ui/bullet.svg")
		local weapon_w, weapon_h = weapon_icon:measure()
		local timeToShoot = 0
		local local_player_weapon = entity.get_player_weapon(local_player)
		local cur = globals.curtime()
		if cur < entity.get_prop(local_player_weapon, "m_flNextPrimaryAttack") then
			timeToShoot = entity.get_prop(local_player_weapon, "m_flNextPrimaryAttack") - cur
		elseif cur < entity.get_prop(local_player, "m_flNextAttack") then
			timeToShoot = entity.get_prop(local_player, "m_flNextAttack") - cur
		end
		if math_floor((timeToShoot * 1000) + 0.5) <= 10 then
			timeToShoot = 0
		end
		if timeToShoot > 1.9 then
			timeToShoot = 0
		end
		local w =  renderer.measure_text(nil, " ") + math.max(weapon_w / 2, timeToShoot * 70), 50
	
		renderer.text(x - 5 + 4 / 2, y/2 + 6, 255, 255, 255, 255, "r", 0, "hitchance: " ..ui.get(ref.hitchance))
		renderer.text(x - 5, y/2 + 17, 255, 255, 255, 255, "r", 0, "damage: "..ui.get(ref.min_dmg))
		weapon_icon:draw(x - w - 2, y/2 + 30, weapon_w / 2 + 1, weapon_h / 2, 255, 255, 255, 255)
	end
	
	
	if ui.get(ui_stuff.inds_selct) == "Modern" and ui.get(ui_stuff.crosshair_inds) then
		
		local alpha = math.floor(math.sin(realtime * 4) * (215 / 2 - 1) + 255 / 2) or alpha_scope
		if scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48 then 
			alpha_scope = 90
			alpha = math.floor(math.sin(realtime * 4) * (90 / 2 - 1) + 120 / 2) or 255
		else
			alpha_scope = 255
			alpha = math.floor(math.sin(realtime * 4) * (215 / 2 - 1) + 255 / 2) or 255
		end
		
		local charge = antiaim_funcs.get_tickbase_shifting() * 0.1
		local r, g, b, a = ui.get(ui_stuff.main_clr)
		
		if ui.get(aa_init[0].legit_aa) and client.key_state(0x45) then
			p_state = "LEGIT"
		else
			if not on_ground then
				if not (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR"
				elseif (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR+C"
				end
			else
				if ui.get(ref.fakeduck) or (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = 'CROUCH'
				elseif not_moving then
					p_state = 'STAND'
				elseif not not_moving then
					if slowwalk_key then
						p_state = 'DANGEROUS'
					else
						p_state = 'RUN'
					end
				end
			end
		end
		

		
		renderer.text(x/2 + 2, y/2 + 34, 255, 255, 255, alpha_scope, "-", 0, "NEXUS")
		renderer.text(x/2 + 27, y/2 + 34, r, g, b, alpha, "-", 0, string.upper(obex_data.build))
		
		if is_dt then
			if charge <= 0 then
				renderer.text(x/2 + 2, y/2 + 44, 255, 70, 70, alpha_scope, "-", 0, "DT")
			else
				renderer.text(x/2 + 2, y/2 + 44, 70, 255, 70, alpha_scope, "-", 0, "DT")
			end
		else--  + wiwi.os_x
			renderer.text(x/2 + 2, y/2 + 44, 70, 70, 70, alpha_scope, "-", 0, "DT") --  + wiwi.os_x
		end
		
		if is_os then
			renderer.text(x/2 + 14, y/2 + 44, 255, 255, 255, alpha_scope, "-", 0, "HS")
		else
			renderer.text(x/2 + 14, y/2 + 44, 70, 70, 70, alpha_scope, "-", 0, "HS")
		end
		
		if is_fs then
			renderer.text(x/2 + 27, y/2 + 44, 255, 255, 255, alpha_scope, "-", 0, "FS")
		else
			renderer.text(x/2 + 27, y/2 + 44, 70, 70, 70, alpha_scope, "-", 0, "FS")
		end
		
		local mierdon = renderer.measure_text(nil,"STATE  |")
		renderer.text(x / 2 + 2 , y / 2 + 55, 180, 180, 180, alpha, "-", 0, "STATE  |")
		renderer.text(x / 2 + mierdon - 10 , y / 2 + 55, 180, 180, 180, alpha_scope, "-", 0, string.upper(p_state))
		
	end

	if ui.get(ui_stuff.inds_selct) == "Bloom" and ui.get(ui_stuff.crosshair_inds) then
		
		local r, g, b = ui.get(ui_stuff.main_clr)
		local r2, g2, b2 = ui.get(ui_stuff.main_clr2)
		local po,pu,ph = ui.get(ui_stuff.glow_clr)
		local charge = antiaim_funcs.get_tickbase_shifting() * 0.1
		
		if scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48 then 
			alpha_scope = 90
			alpha = math.floor(math.sin(realtime * 4) * (90 / 2 - 1) + 120 / 2) or 255
		else
			alpha_scope = 255
			alpha = math.floor(math.sin(realtime * 4) * (215 / 2 - 1) + 255 / 2) or 255
		end
	
		local rr, gg, bbb = ui.get(ui_stuff.glow_color)
	
		wiwi.xpos_dt = animation(is_dt, wiwi.xpos_dt, 10, 15) or 0 -- dt
		wiwi.xpos_os = animation(is_dt or is_os, wiwi.xpos_os, 10, 15) or 0 -- onshot
		wiwi.xpos_dsy = animation(is_dt or is_os or is_fs, wiwi.xpos_dsy, 10, 15) or 0  -- freestand
	
		local txth = renderer.measure_text("-", "NEXUS")
		local ret = ctx.helpers:animate_text(globals.curtime() * 1.8, "NEXUS", r, g, b, alpha_scope)

		--ctx.m_render:glow_module(x/2, y/2 + 34, txth + 15, -0.2, 10, 0, {po, pu, ph, alpha_scope * math.abs(math.sin(globals.curtime()*1))}, {25, 25, 25, alpha_scope})
		--renderer.text(x / 2 + 1, y / 2 + 30, 255, 255, 255, alpha_scope, "-", 0, "", unpack(ret))

		renderer.text(x / 2, y / 2 + 30, r, g, b, alpha_scope, "-", 0, "NEXUS")
		renderer.text(x / 2 + 25, y / 2 + 30, r2, g2, b2, alpha, "-", 0, "BETA")
		
		renderer.gradient(x/ 2 + 1, y/2 + 42, 45 , 5, 0, 0, 0, alpha_scope, 0, 0, 0, alpha_scope, true) -- bg
		renderer.gradient(x/ 2 + 2, y/2 + 43, 0 +(math.abs(bodyyaw*58/72)) , 3, r, g, b, alpha_scope, r, g, b, alpha_scope/255, true) -- dsy bar
		
		if is_dt then
			if charge <= 0 then
				renderer.text(x / 2, y / 2 + wiwi.xpos_dt + 37, 255, 70, 70, alpha_scope, "-", 0, "DOUBLETAP")
			else
				renderer.text(x / 2, y / 2 + wiwi.xpos_dt + 37, 255, 255, 255, alpha_scope, "-", 0, "DOUBLETAP")
			end
			add_y=add_y+10
		end
		
		if is_os then
			renderer.text(x / 2, y / 2 + wiwi.xpos_os + 37 + add_y, 137, 179, 255, alpha_scope, "-", 0, "ONSHOT")
			add_y=add_y+10
		end
		
		if is_fs then
			renderer.text(x / 2, y / 2 + wiwi.xpos_dsy + 37 + add_y, 159, 202, 43, alpha_scope, "-", 0, "FREESTAND")
			add_y=add_y+10
		end
	end
	if ui.get(ui_stuff.inds_selct) == "Old" and ui.get(ui_stuff.crosshair_inds) then
		
		local r, g, b, a = ui.get(ui_stuff.main_clr)
		local r2, g2, b2 = ui.get(ui_stuff.main_clr2)
		local charge = antiaim_funcs.get_tickbase_shifting() * 0.1

		
		if scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48 then 
			alpha_scope = 90
		else
			alpha_scope = 255
		end
		
		if is_dt == false and is_os == false then
			p_state = "FAKELAG"
		else
			if not on_ground then
				if not (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR"
				elseif (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = "AIR+DUCK"
				end
			else
				if ui.get(ref.fakeduck) or (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
					p_state = 'DUCK'
				elseif not_moving then
					p_state = 'STAND'
				elseif not not_moving then
					if slowwalk_key then
						p_state = 'WALK'
					else
						p_state = 'MOVE'
					end
				end
			end
		end
		
		wiwi.xpos = animation(scoped_default, wiwi.xpos, 32, 20) or 0
		wiwi.xpos_dt = animation(scoped_default, wiwi.xpos_dt, 17, 20) or 0
		wiwi.xpos_os = animation(scoped_default, wiwi.xpos_os, 13, 20) or 0
		wiwi.xpos_idk = animation(is_dt or is_os, wiwi.xpos_idk, 12, 20) or 0
		wiwi.xpos_state = animation(scoped_default, wiwi.xpos_state, 16, 20) or 0
		wiwi.xpos_gradient = animation(scoped_default, wiwi.xpos_gradient, 37, 20) or 0
		
		local ret = ctx.helpers:animate_text(globals.curtime() * 1.7, "NEXUS DEBUG", r, g, b, alpha_scope)

		renderer.text(x / 2 - 1 + wiwi.xpos, y / 2 + 40, r2, g2, b2, alpha_scope, "c-", 0, "NEXUS DEBUG")
		renderer.text(x / 2 - 1 + wiwi.xpos, y / 2 + 40, 255, 255, 255, alpha_scope, "c-", 0, unpack(ret))
	  
		if scoped_default then
			renderer.text(x / 2 + wiwi.xpos_state - 10 , y / 2 + 45, 100, 100, 100, alpha_scope, "-", 0, "<"..string.upper(p_state)..">") -- + n2_x - testting
		else
			renderer.text(x / 2 - 1 + wiwi.xpos_state, y / 2 + 50, 100, 100, 100, alpha_scope, "c-", 0, "<"..string.upper(p_state)..">") -- + n2_x - testting
		end
		if is_dt then
			renderer.text(x / 2 - 6 + wiwi.xpos_dt, y / 2 + 48 + wiwi.xpos_idk , 200, 200, 200, alpha_scope, "c-", 0, "DT")
			--x, y , r, g, b, a, radius, start_degrees, percentage, thickness
			renderer.circle_outline(x / 2 + 5 + wiwi.xpos_dt, y / 2 + 49 + wiwi.xpos_idk, 50, 50, 50, alpha_scope, 3, 1, 1, 1)
			renderer.circle_outline(x / 2 + 5 + wiwi.xpos_dt, y / 2 + 49 + wiwi.xpos_idk, 200, 200, 200, alpha_scope, 3, 1, charge, 1)
			add_y = add_y + 10
		end
		
		if is_os and not is_dt then
			renderer.text(x / 2 - 1 + wiwi.xpos_os, y / 2 + 48 + wiwi.xpos_idk + add_y , 200, 200, 200, alpha_scope, "c-", 0, "HS")
		end
	end
	
	if ui.get(ui_stuff.inds_selct) == "Alternative" and ui.get(ui_stuff.crosshair_inds) then
	
		if not on_ground then
			if not (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
				p_state = "AIR"
			elseif (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
				p_state = "AIR+C"
			end
		else
			if ui.get(ref.fakeduck) or (entity.get_prop(me, 'm_flDuckAmount') > 0.7) then
				p_state = 'CROUCH'
			elseif not_moving then
				p_state = 'STANDING'
			elseif not not_moving then
				if slowwalk_key then
					p_state = 'SLOWMOTION'
				else
					p_state = 'MOVING'
				end
			end
		end
		
		local alpha = math.floor(math.sin(realtime * 4) * (215 / 2 - 1) + 255 / 2) or alpha_scope
		if scpd == 1 or weapon_id == 43 or  weapon_id == 44 or weapon_id == 45 or weapon_id == 46 or weapon_id == 47 or weapon_id == 48 then 
			alpha_scope = 60
			alpha = math.floor(math.sin(realtime * 4) * (90 / 2 - 1) + 120 / 2) or 255
		else
			alpha_scope = 255
			alpha = math.floor(math.sin(realtime * 4) * (215 / 2 - 1) + 255 / 2) or 255
		end
		
		
		local r, g, b, a = ui.get(ui_stuff.main_clr)
		local r2, g2, b2 = ui.get(ui_stuff.glow_clr)
		local m_text = renderer.measure_text("-", "NEXUS  TECH")

		ctx.m_render:glow_module(x/2 + ((m_text + 2)/2) * xs.scoped_fraction - m_text/2 + 4, y/2 + 30, m_text - 4, 0, 6, 0, {r2, g2, b2, alpha}, {r2, g2, b2, alpha})
		renderer.text(x/2 + ((m_text + 2)/2) * xs.scoped_fraction, y/2 + 30, 255, 255, 255, alpha_scope, "-c", 0, "NEXUS  ", "\a" .. ctx.helpers:rgba_to_hex( r, g, b, alpha) .. "TECH")

		local next_attack = entity.get_prop(me, "m_flNextAttack")
		local next_primary_attack = entity.get_prop(entity.get_player_weapon(me), "m_flNextPrimaryAttack")

		local dt_toggled = ui.get(ref.dt[1]) and ui.get(ref.dt[2])
		local dt_active = not (math.max(next_primary_attack, next_attack) > globals.curtime()) --or (ctx.helpers.defensive and ctx.helpers.defensive > ui.get(ctx.ref.dt_fl))

		if dt_toggled and dt_active then
			xs.active_fraction = ctx.helpers:clamp(xs.active_fraction + globals.frametime()/0.15, 0, 1)
		else
			xs.active_fraction = ctx.helpers:clamp(xs.active_fraction - globals.frametime()/0.15, 0, 1)
		end

		if dt_toggled and not dt_active then
			xs.inactive_fraction = ctx.helpers:clamp(xs.inactive_fraction + globals.frametime()/0.15, 0, 1)
		else
			xs.inactive_fraction = ctx.helpers:clamp(xs.inactive_fraction - globals.frametime()/0.15, 0, 1)
		end

		if ui.get(ref.os[1]) and ui.get(ref.os[2]) and not dt_toggled then
			xs.hide_fraction = ctx.helpers:clamp(xs.hide_fraction + globals.frametime()/0.15, 0, 1)
		else
			xs.hide_fraction = ctx.helpers:clamp(xs.hide_fraction - globals.frametime()/0.15, 0, 1)
		end

		if math.max(xs.hide_fraction, xs.inactive_fraction, xs.active_fraction) > 0 then
			xs.fraction = ctx.helpers:clamp(xs.fraction + globals.frametime()/0.1, 0, 1)
		else
			xs.fraction = ctx.helpers:clamp(xs.fraction - globals.frametime()/0.1, 0, 1)
		end

			local dt_size = renderer.measure_text("-", "DT ")
			local ready_size = renderer.measure_text("-", "READY")
			renderer.text(x/2 + ((dt_size + ready_size + 2)/2) * xs.scoped_fraction, y/2 + 40, 255, 255, 255, xs.active_fraction * alpha_scope, "-c", dt_size + xs.active_fraction * ready_size + 1, "DT ", "\a" .. ctx.helpers:rgba_to_hex(155, 255, 155, alpha_scope * xs.active_fraction) .. "READY")

			local charging_size = renderer.measure_text("-", "CHARGING")
			renderer.text(x/2 + ((dt_size + charging_size + 2)/2) * xs.scoped_fraction, y/2 + 40, 255, 255, 255, xs.inactive_fraction * alpha_scope, "-c", dt_size + xs.inactive_fraction * charging_size + 1, "DT ", "\a" .. ctx.helpers:rgba_to_hex(255, 120, 120, alpha_scope * xs.inactive_fraction) .. "CHARGING")

			local hide_size = renderer.measure_text("-", "HIDE ")
			local active_size = renderer.measure_text("-", "ACTIVE")
			renderer.text(x/2 + ((hide_size + active_size + 2)/2) * xs.scoped_fraction, y/2 + 40, 255, 255, 255, xs.hide_fraction * alpha_scope, "-c", hide_size + xs.hide_fraction * active_size + 1, "HIDE ", "\a" .. ctx.helpers:rgba_to_hex(155, 155, 200, alpha_scope * xs.hide_fraction) .. "ACTIVE")
			
			local state_size = renderer.measure_text("-", '- ' .. string.upper(p_state) .. ' -')
			renderer.text(x/2 + ((state_size + 2)/2) * xs.scoped_fraction, y/2 + 40 + 10 * xs.fraction, 255, 255, 255, alpha_scope, "-c", 0, '- ' .. string.upper(p_state) .. ' -')
		end

	if ui.get(ui_stuff.arrw_selct) == "off" then
		ui.set_visible(ui_stuff.draw_arrows, false)
	end

	if ui.get(ui_stuff.arrw_selct) == "Teamskeet" and ui.get(ui_stuff.crosshair_inds) then
		ui.set_visible(ui_stuff.draw_arrows, false)
		
		if yaw_direction == -90 then --manual left
			renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 25, 25, 25, 160)
			renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, mr, mg, mb, 160)
		elseif yaw_direction == 90 then -- manual right
			renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, mr, mg, mb, 160)
			renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 25, 25, 25, 160)
		else
			renderer.triangle(x / 2 + 55, y / 2 + 2, x / 2 + 42, y / 2 - 7, x / 2 + 42, y / 2 + 11, 25, 25, 25, 160)
			renderer.triangle(x / 2 - 55, y / 2 + 2, x / 2 - 42, y / 2 - 7, x / 2 - 42, y / 2 + 11, 25, 25, 25, 160)
		end
	
		if anti_aim_invert == 1 then
			renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, ts_r, ts_g, ts_b, ts_a)
			renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18, 25, 25, 25, 160)
		else
			renderer.rectangle(x / 2 + 38, y / 2 - 7, 2, 18, 25, 25, 25, 160)
			renderer.rectangle(x / 2 - 40, y / 2 - 7, 2, 18, ts_r, ts_g, ts_b, ts_a)
		end
	end
	-- ⯇ ⯈ ⯅ ⯆
		if ui.get(ui_stuff.arrw_selct) == "Modern" and ui.get(ui_stuff.crosshair_inds) then
			ui.set_visible(ui_stuff.draw_arrows, true)
			if ui.get(ui_stuff.draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⮜')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⮞')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, 255, "c", 0, '⮞')
				if ui.get(ui_stuff.draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⮜')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, 255, "c", 0, '⮜')
				if ui.get(ui_stuff.draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⮞')
				end
			end
		end

		if ui.get(ui_stuff.arrw_selct) == "Small" and ui.get(ui_stuff.crosshair_inds) then
			ui.set_visible(ui_stuff.draw_arrows, true)
			if ui.get(ui_stuff.draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '‹')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '›')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, 255, "c+", 0, '›')
				if ui.get(ui_stuff.draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '‹')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, 255, "c+", 0, '‹')
				if ui.get(ui_stuff.draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c+", 0, '›')
				end
			end
		end
		 
		if ui.get(ui_stuff.arrw_selct) == "Triangle" and ui.get(ui_stuff.crosshair_inds) then
			ui.set_visible(ui_stuff.draw_arrows, true)
			if ui.get(ui_stuff.draw_arrows) then
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⯇')
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⯈')
			end
	
			if ui.get(ref.yaw[2]) == 90 then
				
				renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, 255, "c", 0, '⯈')
				if ui.get(ui_stuff.draw_arrows) then
				else
				renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⯇')
				end
			end
			if ui.get(ref.yaw[2]) == -90 then
				
				renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, 255, "c", 0, '⯇')
				if ui.get(ui_stuff.draw_arrows) then
				else
					renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "c", 0, '⯈')
				end
			end
		end

	if ui.get(ui_stuff.arrw_selct) == "Classic" and ui.get(ui_stuff.crosshair_inds) then
		ui.set_visible(ui_stuff.draw_arrows, true)
		if ui.get(ui_stuff.draw_arrows) then
			renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "cb", 0, '<')
			renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "cb	", 0, '>')
		end

		if ui.get(ref.yaw[2]) == 90 then
			
			renderer.text(x / 2 + 45, y / 2 - 2.5, mr,mg,mb, 255, "cb", 0, '>')
			if ui.get(ui_stuff.draw_arrows) then
			else
			renderer.text(x / 2 - 45, y / 2 - 2.5, 255,255,255, 100, "cb", 0, '<')
			end
		end
		if ui.get(ref.yaw[2]) == -90 then
			
			renderer.text(x / 2 - 45, y / 2 - 2.5, mr,mg,mb, 255, "cb", 0, '<')
			if ui.get(ui_stuff.draw_arrows) then
			else
				renderer.text(x / 2 + 45, y / 2 - 2.5, 255,255,255, 100, "cb", 0, '>')
			end
		end
	end
end

local cfg_stuff = {}
local encode_and_decode = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

cfg_stuff.encode = function(data)
    return ((data:gsub(".", function(x)
        local r,encode_and_decode= '', x:byte()
        for i=8,1,-1 do r=r..(encode_and_decode%2^i-encode_and_decode%2^(i-1)>0 and "1" or "0") end
        return r;
    end).."0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=="1" and 2^(6-i) or 0) end
        return encode_and_decode:sub(c+1,c+1)
    end)..({ "", "==", "=" })[#data%3+1])
end

cfg_stuff.decode = function(data)
    data = string.gsub(data, "[^"..encode_and_decode.."=]", "")
    return (data:gsub(".", function(x)
        if (x == "=") then return "" end
        local r,f="",(encode_and_decode:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and "1" or "0") end
        return r;
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
        if (#x ~= 8) then return "" end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=="1" and 2^(8-i) or 0) end
            return string.char(c)
    end))
end


local cfg_data = {

	data = {
	
		-- checkbox
		ui_stuff.watermark_enable,
		ui_stuff.crosshair_inds,
		ui_stuff.inds_selct,
		ui_stuff.arrw_selct,
		ui_stuff.draw_arrows,
		ui_stuff.moonwalk_air,
		ui_stuff.tele,
		ui_stuff.anti_knife,
		ui_stuff.debug_panel,
		aa_init[0].defensive_inair,
		ui_stuff.exploit_select,
		ui_stuff.defensive_yaw,
		ui_stuff.defensive_pitch,
		ui_stuff.loger,
		ui_stuff.loger2,
		ui_stuff.popaps,
		
		ui_stuff.glow_enabled,
		
		aa_init[0].fs_disablers,
		aa_init[0].fast_weapon_switch,
		aa_init[0].aa_condition,
		aa_init[0].brute_phases,
		aa_init[0].aas,
		
		
		aa_init[0].invalid_bt_ticks,
		aa_init[0].fix_hs,
		aa_init[0].legit_aa,
		aa_init[0].aa_builder,
		aa_init[0].brute_enable,
		aa_init[0].hide_builder,
	
	
		-- builder data
		
		-- TT
		rage[1].t_enable_aa, rage[2].t_enable_aa, rage[3].t_enable_aa, rage[4].t_enable_aa, rage[5].t_enable_aa, rage[6].t_enable_aa, rage[7].t_enable_aa,
        rage[1].t_c_pitch, rage[2].t_c_pitch, rage[3].t_c_pitch, rage[4].t_c_pitch, rage[5].t_c_pitch, rage[6].t_c_pitch, rage[7].t_c_pitch,
        rage[1].t_yawbase, rage[2].t_yawbase, rage[3].t_yawbase, rage[4].t_yawbase, rage[5].t_yawbase, rage[6].t_yawbase, rage[7].t_yawbase,
        rage[1].t_yaw, rage[2].t_yaw, rage[3].t_yaw, rage[4].t_yaw, rage[5].t_yaw, rage[6].t_yaw, rage[7].t_yaw,
        rage[1].t_yaw_type, rage[2].t_yaw_type, rage[3].t_yaw_type, rage[4].t_yaw_type, rage[5].t_yaw_type, rage[6].t_yaw_type, rage[7].t_yaw_type,
        rage[1].t_left_limit, rage[2].t_left_limit, rage[3].t_left_limit, rage[4].t_left_limit, rage[5].t_left_limit, rage[6].t_left_limit, rage[7].t_left_limit,
        rage[1].t_right_limit, rage[2].t_right_limit, rage[3].t_right_limit, rage[4].t_right_limit, rage[5].t_right_limit, rage[6].t_right_limit, rage[7].t_right_limit,
		rage[1].t_yaw_3way_1, rage[2].t_yaw_3way_1, rage[3].t_yaw_3way_1, rage[4].t_yaw_3way_1, rage[5].t_yaw_3way_1, rage[6].t_yaw_3way_1, rage[7].t_yaw_3way_1,
		rage[1].t_yaw_3way_2, rage[2].t_yaw_3way_2, rage[3].t_yaw_3way_2, rage[4].t_yaw_3way_2, rage[5].t_yaw_3way_2, rage[6].t_yaw_3way_2, rage[7].t_yaw_3way_2,
		rage[1].t_yaw_3way_3, rage[2].t_yaw_3way_3, rage[3].t_yaw_3way_3, rage[4].t_yaw_3way_3, rage[5].t_yaw_3way_3, rage[6].t_yaw_3way_3, rage[7].t_yaw_3way_3,
		rage[1].t_yaw_1, rage[2].t_yaw_1, rage[3].t_yaw_1, rage[4].t_yaw_1, rage[5].t_yaw_1, rage[6].t_yaw_1, rage[7].t_yaw_1,
        rage[1].t_yaw_2, rage[2].t_yaw_2, rage[3].t_yaw_2, rage[4].t_yaw_2, rage[5].t_yaw_2, rage[6].t_yaw_2, rage[7].t_yaw_2,
        rage[1].t_yaw_3, rage[2].t_yaw_3, rage[3].t_yaw_3, rage[4].t_yaw_3, rage[5].t_yaw_3, rage[6].t_yaw_3, rage[7].t_yaw_3,
        rage[1].t_yaw_4, rage[2].t_yaw_4, rage[3].t_yaw_4, rage[4].t_yaw_4, rage[5].t_yaw_4, rage[6].t_yaw_4, rage[7].t_yaw_4,
        rage[1].t_yaw_5, rage[2].t_yaw_5, rage[3].t_yaw_5, rage[4].t_yaw_5, rage[5].t_yaw_5, rage[6].t_yaw_5, rage[7].t_yaw_5,
        
		rage[1].t_jitter, rage[2].t_jitter, rage[3].t_jitter, rage[4].t_jitter, rage[5].t_jitter, rage[6].t_jitter, rage[7].t_jitter,
        rage[1].t_jitter_type, rage[2].t_jitter_type, rage[3].t_jitter_type, rage[4].t_jitter_type, rage[5].t_jitter_type, rage[6].t_jitter_type, rage[7].t_jitter_type,
        rage[1].t_jitter_sli, rage[2].t_jitter_sli, rage[3].t_jitter_sli, rage[4].t_jitter_sli, rage[5].t_jitter_sli, rage[6].t_jitter_sli, rage[7].t_jitter_sli,
        
        rage[1].t_left_jitter_sli, rage[2].t_left_jitter_sli, rage[3].t_left_jitter_sli, rage[4].t_left_jitter_sli, rage[5].t_left_jitter_sli, rage[6].t_left_jitter_sli, rage[7].t_left_jitter_sli,
		rage[1].t_right_jitter_sli, rage[2].t_right_jitter_sli, rage[3].t_right_jitter_sli, rage[4].t_right_jitter_sli, rage[5].t_right_jitter_sli, rage[6].t_right_jitter_sli, rage[7].t_right_jitter_sli,
		
        rage[1].t_body, rage[2].t_body, rage[3].t_body, rage[4].t_body, rage[5].t_body, rage[6].t_body, rage[7].t_body,
        rage[1].t_freestand_byaw, rage[2].t_freestand_byaw, rage[3].t_freestand_byaw, rage[4].t_freestand_byaw, rage[5].t_freestand_byaw, rage[6].t_freestand_byaw, rage[7].t_freestand_byaw,
		
		-- CT XD
		rage[1].ct_enable_aa, rage[2].ct_enable_aa, rage[3].ct_enable_aa, rage[4].ct_enable_aa, rage[5].ct_enable_aa, rage[6].ct_enable_aa, rage[7].ct_enable_aa,
        rage[1].ct_c_pitch, rage[2].ct_c_pitch, rage[3].ct_c_pitch, rage[4].ct_c_pitch, rage[5].ct_c_pitch, rage[6].ct_c_pitch, rage[7].ct_c_pitch, 
        rage[1].ct_yawbase, rage[2].ct_yawbase, rage[3].ct_yawbase, rage[4].ct_yawbase, rage[5].ct_yawbase, rage[6].ct_yawbase, rage[7].ct_yawbase,
        rage[1].ct_yaw, rage[2].ct_yaw, rage[3].ct_yaw, rage[4].ct_yaw, rage[5].ct_yaw, rage[6].ct_yaw, rage[7].ct_yaw,
        rage[1].ct_yaw_type, rage[2].ct_yaw_type, rage[3].ct_yaw_type, rage[4].ct_yaw_type, rage[5].ct_yaw_type, rage[6].ct_yaw_type, rage[7].ct_yaw_type,
        rage[1].ct_left_limit, rage[2].ct_left_limit, rage[3].ct_left_limit, rage[4].ct_left_limit, rage[5].ct_left_limit, rage[6].ct_left_limit, rage[7].ct_left_limit,
        rage[1].ct_right_limit, rage[2].ct_right_limit, rage[3].ct_right_limit, rage[4].ct_right_limit, rage[5].ct_right_limit, rage[6].ct_right_limit, rage[7].ct_right_limit,
		rage[1].ct_yaw_3way_1, rage[2].ct_yaw_3way_1, rage[3].ct_yaw_3way_1, rage[4].ct_yaw_3way_1, rage[5].ct_yaw_3way_1, rage[6].ct_yaw_3way_1, rage[7].ct_yaw_3way_1,
		rage[1].ct_yaw_3way_2, rage[2].ct_yaw_3way_2, rage[3].ct_yaw_3way_2, rage[4].ct_yaw_3way_2, rage[5].ct_yaw_3way_2, rage[6].ct_yaw_3way_2, rage[7].ct_yaw_3way_2,
		rage[1].ct_yaw_3way_3, rage[2].ct_yaw_3way_3, rage[3].ct_yaw_3way_3, rage[4].ct_yaw_3way_3, rage[5].ct_yaw_3way_3, rage[6].ct_yaw_3way_3, rage[7].ct_yaw_3way_3,
		rage[1].ct_yaw_1, rage[2].ct_yaw_1, rage[3].ct_yaw_1, rage[4].ct_yaw_1, rage[5].ct_yaw_1, rage[6].ct_yaw_1, rage[7].ct_yaw_1,
        rage[1].ct_yaw_2, rage[2].ct_yaw_2, rage[3].ct_yaw_2, rage[4].ct_yaw_2, rage[5].ct_yaw_2, rage[6].ct_yaw_2, rage[7].ct_yaw_2,
        rage[1].ct_yaw_3, rage[2].ct_yaw_3, rage[3].ct_yaw_3, rage[4].ct_yaw_3, rage[5].ct_yaw_3, rage[6].ct_yaw_3, rage[7].ct_yaw_3,
        rage[1].ct_yaw_4, rage[2].ct_yaw_4, rage[3].ct_yaw_4, rage[4].ct_yaw_4, rage[5].ct_yaw_4, rage[6].ct_yaw_4, rage[7].ct_yaw_4,
        rage[1].ct_yaw_5, rage[2].ct_yaw_5, rage[3].ct_yaw_5, rage[4].ct_yaw_5, rage[5].ct_yaw_5, rage[6].ct_yaw_5, rage[7].ct_yaw_5, 
        
		rage[1].ct_jitter, rage[2].ct_jitter, rage[3].ct_jitter, rage[4].ct_jitter, rage[5].ct_jitter, rage[6].ct_jitter, rage[7].ct_jitter,
        rage[1].ct_jitter_type, rage[2].ct_jitter_type, rage[3].ct_jitter_type, rage[4].ct_jitter_type, rage[5].ct_jitter_type, rage[6].ct_jitter_type, rage[7].ct_jitter_type,
        rage[1].ct_jitter_sli, rage[2].ct_jitter_sli, rage[3].ct_jitter_sli, rage[4].ct_jitter_sli, rage[5].ct_jitter_sli, rage[6].ct_jitter_sli, rage[7].ct_jitter_sli,
        
        rage[1].ct_left_jitter_sli, rage[2].ct_left_jitter_sli, rage[3].ct_left_jitter_sli, rage[4].ct_left_jitter_sli, rage[5].ct_left_jitter_sli, rage[6].ct_left_jitter_sli, rage[7].ct_left_jitter_sli,
		rage[1].ct_right_jitter_sli, rage[2].ct_right_jitter_sli, rage[3].ct_right_jitter_sli, rage[4].ct_right_jitter_sli, rage[5].ct_right_jitter_sli, rage[6].ct_right_jitter_sli, rage[7].ct_right_jitter_sli,
		
        rage[1].ct_body, rage[2].ct_body, rage[3].ct_body, rage[4].ct_body, rage[5].ct_body, rage[6].ct_body, rage[7].ct_body,
        rage[1].ct_freestand_byaw, rage[2].ct_freestand_byaw, rage[3].ct_freestand_byaw, rage[4].ct_freestand_byaw, rage[5].ct_freestand_byaw, rage[6].ct_freestand_byaw, rage[7].ct_freestand_byaw,
		
		
		-- anti-bruteforce data
		bf[1].bf_enable_aa, bf[2].bf_enable_aa, bf[3].bf_enable_aa, bf[4].bf_enable_aa, bf[5].bf_enable_aa,
        bf[1].bf_c_pitch, bf[2].bf_c_pitch, bf[3].bf_c_pitch, bf[4].bf_c_pitch, bf[5].bf_c_pitch,
        bf[1].bf_yawbase, bf[2].bf_yawbase, bf[3].bf_yawbase, bf[4].bf_yawbase, bf[5].bf_yawbase,
        bf[1].bf_yaw, bf[2].bf_yaw, bf[3].bf_yaw, bf[4].bf_yaw, bf[5].bf_yaw,
        bf[1].bf_yaw_type, bf[2].bf_yaw_type, bf[3].bf_yaw_type, bf[4].bf_yaw_type, bf[5].bf_yaw_type, 
        bf[1].bf_left_limit, bf[2].bf_left_limit, bf[3].bf_left_limit, bf[4].bf_left_limit, bf[5].bf_left_limit,
        bf[1].bf_right_limit, bf[2].bf_right_limit, bf[3].bf_right_limit, bf[4].bf_right_limit, bf[5].bf_right_limit,
		bf[1].bf_yaw_3way_1, bf[2].bf_yaw_3way_1, bf[3].bf_yaw_3way_1, bf[4].bf_yaw_3way_1, bf[5].bf_yaw_3way_1,
		bf[1].bf_yaw_3way_2, bf[2].bf_yaw_3way_2, bf[3].bf_yaw_3way_2, bf[4].bf_yaw_3way_2, bf[5].bf_yaw_3way_2, 
		bf[1].bf_yaw_3way_3, bf[2].bf_yaw_3way_3, bf[3].bf_yaw_3way_3, bf[4].bf_yaw_3way_3, bf[5].bf_yaw_3way_3,
		bf[1].bf_yaw_1, bf[2].bf_yaw_1, bf[3].bf_yaw_1, bf[4].bf_yaw_1, bf[5].bf_yaw_1,
        bf[1].bf_yaw_2, bf[2].bf_yaw_2, bf[3].bf_yaw_2, bf[4].bf_yaw_2, bf[5].bf_yaw_2,
        bf[1].bf_yaw_3, bf[2].bf_yaw_3, bf[3].bf_yaw_3, bf[4].bf_yaw_3, bf[5].bf_yaw_3,
        bf[1].bf_yaw_4, bf[2].bf_yaw_4, bf[3].bf_yaw_4, bf[4].bf_yaw_4, bf[5].bf_yaw_4,
        bf[1].bf_yaw_5, bf[2].bf_yaw_5, bf[3].bf_yaw_5, bf[4].bf_yaw_5, bf[5].bf_yaw_5,
        
		bf[1].bf_jitter, bf[2].bf_jitter, bf[3].bf_jitter, bf[4].bf_jitter, bf[5].bf_jitter,
        bf[1].bf_jitter_type, bf[2].bf_jitter_type, bf[3].bf_jitter_type, bf[4].bf_jitter_type, bf[5].bf_jitter_type,
        bf[1].bf_jitter_sli, bf[2].bf_jitter_sli, bf[3].bf_jitter_sli, bf[4].bf_jitter_sli, bf[5].bf_jitter_sli,
        
        bf[1].bf_left_jitter_sli, bf[2].bf_left_jitter_sli, bf[3].bf_left_jitter_sli, bf[4].bf_left_jitter_sli, bf[5].bf_left_jitter_sli,
		bf[1].bf_right_jitter_sli, bf[2].bf_right_jitter_sli, bf[3].bf_right_jitter_sli, bf[4].bf_right_jitter_sli, bf[5].bf_right_jitter_sli,
		
        bf[1].bf_body, bf[2].bf_body, bf[3].bf_body, bf[4].bf_body, bf[5].bf_body,
        bf[1].bf_freestand_byaw, bf[2].bf_freestand_byaw, bf[3].bf_freestand_byaw, bf[4].bf_freestand_byaw, bf[5].bf_freestand_byaw,
 		
		pitchxp.yaw,
		pitchxp.pitch,
		pitchxp.ticks,
		pitchxp.yawleft,
		pitchxp.yawright,
		pitchxp.yawjitter,
		pitchxp.yawjitteradd,
		
		legit_setts.legit_yaw,
		legit_setts.legit_yaw_add,
		legit_setts.legit_body,
		
	}
}

local cond_state = 1 
if ui.get(aa_init[0].aa_condition) == "Shared" then
	cond_state = 1
elseif ui.get(aa_init[0].aa_condition) == "Standing" then
	cond_state = 2
elseif ui.get(aa_init[0].aa_condition) == "Slow motion" then
	cond_state = 3
elseif ui.get(aa_init[0].aa_condition) == "Running" then
	cond_state = 4
elseif ui.get(aa_init[0].aa_condition) == "Air" then
	cond_state = 5
elseif ui.get(aa_init[0].aa_condition) == "Air crouch" then
	cond_state = 6
elseif ui.get(aa_init[0].aa_condition) == "Crouching" then
	cond_state = 7
end

local t_cond_data = {
	t_data_cond = {
		-- TT
		rage[cond_state].t_enable_aa,
        rage[cond_state].t_c_pitch,
        rage[cond_state].t_yawbase,
        rage[cond_state].t_yaw,
        rage[cond_state].t_yaw_type,
        rage[cond_state].t_left_limit,
        rage[cond_state].t_right_limit,
		rage[cond_state].t_yaw_3way_1,
		rage[cond_state].t_yaw_3way_2,
		rage[cond_state].t_yaw_3way_3,
		rage[cond_state].t_yaw_1,
        rage[cond_state].t_yaw_2,
        rage[cond_state].t_yaw_3,
        rage[cond_state].t_yaw_4,
        rage[cond_state].t_yaw_5,
        
		rage[cond_state].t_jitter,
        rage[cond_state].t_jitter_type,
        rage[cond_state].t_jitter_sli,
        
        rage[cond_state].t_left_jitter_sli,
		rage[cond_state].t_right_jitter_sli,
		
        rage[cond_state].t_body,
        rage[cond_state].t_freestand_byaw,
 
		
	}
}

local ct_cond_data = {
	ct_data_cond = {
		-- CT
		rage[cond_state].ct_enable_aa,
        rage[cond_state].ct_c_pitch,
        rage[cond_state].ct_yawbase,
        rage[cond_state].ct_yaw,
        rage[cond_state].ct_yaw_type,
        rage[cond_state].ct_left_limit,
        rage[cond_state].ct_right_limit,
		rage[cond_state].ct_yaw_3way_1,
		rage[cond_state].ct_yaw_3way_2,
		rage[cond_state].ct_yaw_3way_3,
		rage[cond_state].ct_yaw_1,
        rage[cond_state].ct_yaw_2,
        rage[cond_state].ct_yaw_3,
        rage[cond_state].ct_yaw_4,
        rage[cond_state].ct_yaw_5,
        
		rage[cond_state].ct_jitter,
        rage[cond_state].ct_jitter_type,
        rage[cond_state].ct_jitter_sli,
        
        rage[cond_state].ct_left_jitter_sli,
		rage[cond_state].ct_right_jitter_sli,
		
        rage[cond_state].ct_body,
        rage[cond_state].ct_freestand_byaw,
 		
		
	}
}

local import_cfg = function(text)
	local status, message = pcall(function()
		local decode_cfg = json.parse(cfg_stuff.decode(clipboard.get()))
		
		for k, v in pairs(decode_cfg) do
		k = ({[1] = "data"})[k]

			for k2, v2 in pairs(v) do
				if (k == "data") then
					ui.set(cfg_data[k][k2],(v2))
				end
			end
		end
		print('Succesfully imported anti-aim settings.')
		nexus_push:paint(5, "Succesfully imported anti-aim settings.")
    end)
	if (not status) then
		print('Failed to import anti-aim settings.')
		nexus_push:paint(5, "Failed to import anti-aim settings.")
		return
	end
end

local export_cfg = function()

    local Code = { {} }

	local status, message = pcall(function()

		for _, setts in pairs(cfg_data.data) do
			table.insert(Code[1], ui.get(setts))
		end
		
        clipboard.set(cfg_stuff.encode(json.stringify(Code)))
        print('Succesfully exported anti-aim settings.')
		nexus_push:paint(5, "Succesfully exported anti-aim settings.")
		
    end)
	if (not status) then
		print('Failed to export anti-aim settings.')
		nexus_push:paint(5, "Failed to export anti-aim settings.")
		return
	end
end

local mierdaaaa = ui.new_label("AA", "Anti-aimbot angles", " ")
local causita = ui.new_label("AA", "Anti-aimbot angles", " ")
local export_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFExport config", export_cfg)
local import_btn = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFImport config", import_cfg)


local btn_to_tt = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFSend to T", function()

	local state = 1 
	if ui.get(aa_init[0].aa_condition) == "Shared" then
		state = 1
	elseif ui.get(aa_init[0].aa_condition) == "Standing" then
		state = 2
	elseif ui.get(aa_init[0].aa_condition) == "Slow motion" then
		state = 3
	elseif ui.get(aa_init[0].aa_condition) == "Running" then
		state = 4
	elseif ui.get(aa_init[0].aa_condition) == "Air" then
		state = 5
	elseif ui.get(aa_init[0].aa_condition) == "Air crouch" then
		state = 6
	elseif ui.get(aa_init[0].aa_condition) == "Crouching" then
		state = 7
	end
	
	ui.set(rage[state].t_enable_aa, ui.get(rage[state].ct_enable_aa))
	ui.set(rage[state].t_c_pitch, ui.get(rage[state].ct_c_pitch))
	ui.set(rage[state].t_yawbase, ui.get(rage[state].ct_yawbase))
	ui.set(rage[state].t_yaw, ui.get(rage[state].ct_yaw))
	
	ui.set(rage[state].t_jitter, ui.get(rage[state].ct_jitter))
	ui.set(rage[state].t_jitter_type, ui.get(rage[state].ct_jitter_type))
	ui.set(rage[state].t_jitter_sli, ui.get(rage[state].ct_jitter_sli))
	ui.set(rage[state].t_right_jitter_sli, ui.get(rage[state].ct_right_jitter_sli))
	
	ui.set(rage[state].t_left_jitter_sli, ui.get(rage[state].ct_left_jitter_sli))
	ui.set(rage[state].t_body, ui.get(rage[state].ct_body))
	ui.set(rage[state].t_freestand_byaw, ui.get(rage[state].ct_freestand_byaw))
	
	ui.set(rage[state].t_yaw_type, ui.get(rage[state].ct_yaw_type))
	
	ui.set(rage[state].t_left_limit, ui.get(rage[state].ct_left_limit))
	ui.set(rage[state].t_right_limit, ui.get(rage[state].ct_right_limit))
	
	ui.set(rage[state].t_yaw_1, ui.get(rage[state].ct_yaw_1))
	ui.set(rage[state].t_yaw_2, ui.get(rage[state].ct_yaw_2))
	ui.set(rage[state].t_yaw_3, ui.get(rage[state].ct_yaw_3))
	ui.set(rage[state].t_yaw_4, ui.get(rage[state].ct_yaw_4))
	ui.set(rage[state].t_yaw_5, ui.get(rage[state].ct_yaw_5))
	
	ui.set(rage[state].t_yaw_3way_1, ui.get(rage[state].ct_yaw_3way_1))
	ui.set(rage[state].t_yaw_3way_2, ui.get(rage[state].ct_yaw_3way_2))
	ui.set(rage[state].t_yaw_3way_3, ui.get(rage[state].ct_yaw_3way_3))	

end)

local btn_to_ct = ui.new_button("AA", "Anti-aimbot angles", "\a8FBEFFFFSend to CT", function()

	local state = 1 
	if ui.get(aa_init[0].aa_condition) == "Shared" then
		state = 1
	elseif ui.get(aa_init[0].aa_condition) == "Standing" then
		state = 2
	elseif ui.get(aa_init[0].aa_condition) == "Slow motion" then
		state = 3
	elseif ui.get(aa_init[0].aa_condition) == "Running" then
		state = 4
	elseif ui.get(aa_init[0].aa_condition) == "Air" then
		state = 5
	elseif ui.get(aa_init[0].aa_condition) == "Air crouch" then
		state = 6
	elseif ui.get(aa_init[0].aa_condition) == "Crouching" then
		state = 7
	end
	
	ui.set(rage[state].ct_enable_aa, ui.get(rage[state].t_enable_aa))
	ui.set(rage[state].ct_c_pitch, ui.get(rage[state].t_c_pitch))
	ui.set(rage[state].ct_yawbase, ui.get(rage[state].t_yawbase))
	ui.set(rage[state].ct_yaw, ui.get(rage[state].t_yaw))
	
	ui.set(rage[state].ct_jitter, ui.get(rage[state].t_jitter))
	ui.set(rage[state].ct_jitter_type, ui.get(rage[state].t_jitter_type))
	ui.set(rage[state].ct_jitter_sli, ui.get(rage[state].t_jitter_sli))
	
	ui.set(rage[state].ct_right_jitter_sli, ui.get(rage[state].t_right_jitter_sli))
	
	ui.set(rage[state].ct_left_jitter_sli, ui.get(rage[state].t_left_jitter_sli))
	ui.set(rage[state].ct_body, ui.get(rage[state].t_body))
	ui.set(rage[state].ct_freestand_byaw, ui.get(rage[state].t_freestand_byaw))
	
	ui.set(rage[state].ct_yaw_type, ui.get(rage[state].t_yaw_type))
	
	ui.set(rage[state].ct_yaw_1, ui.get(rage[state].t_yaw_1))
	ui.set(rage[state].ct_yaw_2, ui.get(rage[state].t_yaw_2))
	ui.set(rage[state].ct_yaw_3, ui.get(rage[state].t_yaw_3))
	ui.set(rage[state].ct_yaw_4, ui.get(rage[state].t_yaw_4))
	ui.set(rage[state].ct_yaw_5, ui.get(rage[state].t_yaw_5))
	
	ui.set(rage[state].ct_yaw_3way_1, ui.get(rage[state].t_yaw_3way_1))
	ui.set(rage[state].ct_yaw_3way_2, ui.get(rage[state].t_yaw_3way_2))
	ui.set(rage[state].ct_yaw_3way_3, ui.get(rage[state].t_yaw_3way_3))
	
	ui.set(rage[state].ct_left_limit, ui.get(rage[state].t_left_limit))
	ui.set(rage[state].ct_right_limit, ui.get(rage[state].t_right_limit))

end)

local function config_menu()
	local is_enabled = ui.get(lua_enable)
	
	ui.set_visible(causita, aa_vis)
	ui.set_visible(btn_to_ct, aa_vis and ui.get(aa_init[0].team) == "T" and ui.get(aa_init[0].aa_builder) and ui.get(aacat) == "Builder")
	ui.set_visible(btn_to_tt, aa_vis and ui.get(aa_init[0].team) == "CT" and ui.get(aa_init[0].aa_builder) and ui.get(aacat) == "Builder")
	
	if is_enabled and config_vis then
		ui.set_visible(export_btn, true)
		ui.set_visible(import_btn, true)
		ui.set_visible(mierdaaaa, true)
	else
		ui.set_visible(export_btn, false)
		ui.set_visible(import_btn, false)
		ui.set_visible(mierdaaaa, false)
	end
end

client.set_event_callback("paint", draw)
client.set_event_callback("paint_ui", set_lua_menu)
client.set_event_callback("paint_ui", set_og_menu)
client.set_event_callback("paint_ui", config_menu)

local function main()
	client.set_event_callback("shutdown", function()
		set_og_menu(true)
	end)

	client.set_event_callback("player_death", function(e)
		if client.userid_to_entindex(e.userid) == entity.get_local_player() then
			if ui.get(aa_init[0].brute_enable) then
				if ui.get(ui_stuff.popaps) == "Centered" then
					nexus_push:paint(5, "Anti-bruteforce data reset due to death")
				elseif ui.get(ui_stuff.popaps) == "Left screen" then
					nexus_push:paint(5, "Cleared\nanti-bruteforce\ndata")
				end
				brute.reset()
			end
		end
	end)

	client.set_event_callback("round_start", function()
		aa.input = 0
		aa.ignore = false
		lastlocal = 0
		brute.reset()
		local me = entity.get_local_player()
		if not entity.is_alive(me) then return end
		if ui.get(aa_init[0].brute_enable) then
			if ui.get(ui_stuff.popaps) == "Centered" then
				nexus_push:paint(5, "Anti-bruteforce data reset due to new round")
			elseif ui.get(ui_stuff.popaps) == "Left screen" then
				nexus_push:paint(5, "Cleared\nanti-bruteforce\ndata")
			end
			brute.reset()
		end
	end)

	client.set_event_callback("client_disconnect", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)

	client.set_event_callback("cs_game_disconnected", function()
		aa.input = 0
		aa.ignore = false
		brute.reset()
	end)
end
main()

local ground_ticks, end_time = 1, 0

client.set_event_callback("setup_command", function(cmd)
    is_on_ground = cmd.in_jump == 0

	if ui.get(anim) == "Follow direction" then
		ui.set(ref.leg_movement, cmd.command_number % 3 == 0 and "Off" or "Always slide")
	end
end)

client.set_event_callback("pre_render", function()

	local self = entity.get_local_player()
	local self_index = c_entity.new(self)
	if not self_index then return end
	local self_anim_state = self_index:get_anim_state()
	
	if not self_anim_state then
		return	
	end
	
	if entity.is_alive(entity.get_local_player()) then
		
		if contains_selected(ui.get(anim_old), "Static legs in-air") then
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6) 
		end
	
		if contains_selected(ui.get(anim_old), "Pitch 0 on-land") then
			local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

			if on_ground == 1 then
				ground_ticks = ground_ticks + 1
			else
				ground_ticks = 0
				end_time = globals.curtime() + 1
			end 
		
			if ground_ticks > ui.get(ref.fakelag_legs)+1 and end_time > globals.curtime() then
				entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0.5, 12)
			end
		end
		
		if contains_selected(ui.get(anim_old), "Fakeduck breaker on shot") then
			if ui.get(ref.fakeduck) then
				entity.set_prop(self, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 5 / 10 or 1)
			end
		end
	
		if ui.get(anim) == "Moonwalk" then
			
			ui.set(ref.leg_movement, "Never slide")
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 7) 
			local self_anim_overlay = self_index:get_anim_overlay(6)
			if not self_anim_overlay then
				return
			end
			
			if ui.get(ui_stuff.moonwalk_air) then
				if in_air(self) then
					self_anim_overlay.weight = 100
				end
			end
		end
		
		if ui.get(anim) == "Follow direction" and not client.key_state(0x45) then
			ui.set(ref.leg_movement, "Always slide")
			entity.set_prop(self, "m_flPoseParameter", 1, globals.tickcount() % 4 > 1 and 3 / 10 or 1)
		end
			
		if ui.get(anim) == "Ice" then
			entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 0, 10) 
		end
	end
end)

--LOGS

local ffi_typeof, ffi_cast = ffi.typeof, ffi.cast

local prefer_safe_point = ui_reference('RAGE', 'Aimbot', 'Prefer safe point')
local force_safe_point = ui_reference('RAGE', 'Aimbot', 'Force safe point')

local num_format = function(b) local c=b%10;if c==1 and b~=11 then return b..'st'elseif c==2 and b~=12 then return b..'nd'elseif c==3 and b~=13 then return b..'rd'else return b..'th'end end
local hitgroup_names = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' }
local weapon_to_verb = { knife = 'Knifed', hegrenade = 'Naded', inferno = 'Burned' }

local classes = {
    net_channel = function()
        local this = { }

        local class_ptr = ffi_typeof('void***')
        local engine_client = ffi_cast(class_ptr, client_create_interface("engine.dll", "VEngineClient014"))
        local get_channel = ffi_cast("void*(__thiscall*)(void*)", engine_client[0][78])

        local netc_bool = ffi_typeof("bool(__thiscall*)(void*)")
        local netc_bool2 = ffi_typeof("bool(__thiscall*)(void*, int, int)")
        local netc_float = ffi_typeof("float(__thiscall*)(void*, int)")
        local netc_int = ffi_typeof("int(__thiscall*)(void*, int)")
        local net_fr_to = ffi_typeof("void(__thiscall*)(void*, float*, float*, float*)")

        client_set_event_callback('net_update_start', function()
            local ncu_info = ffi_cast(class_ptr, get_channel(engine_client)) or error("net_channel:update:info is nil")
            local seqNr_out = ffi_cast(netc_int, ncu_info[0][17])(ncu_info, 1)
        
            for name, value in pairs({
                seqNr_out = seqNr_out,
        
                is_loopback = ffi_cast(netc_bool, ncu_info[0][6])(ncu_info),
                is_timing_out = ffi_cast(netc_bool, ncu_info[0][7])(ncu_info),
        
                latency = {
                    crn = function(flow) return ffi_cast(netc_float, ncu_info[0][9])(ncu_info, flow) end,
                    average = function(flow) return ffi_cast(netc_float, ncu_info[0][10])(ncu_info, flow) end,
                },
        
                loss = ffi_cast(netc_float, ncu_info[0][11])(ncu_info, 1),
                choke = ffi_cast(netc_float, ncu_info[0][12])(ncu_info, 1),
                got_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 1),
                sent_bytes = ffi_cast(netc_float, ncu_info[0][13])(ncu_info, 0),
        
                is_valid_packet = ffi_cast(netc_bool2, ncu_info[0][18])(ncu_info, 1, seqNr_out-1),
            }) do
                this[name] = value
            end
        end)

        function this:get()
            return (this.seqNr_out ~= nil and this or nil)
        end

        return this
    end,

    aimbot = function(net_channel)
        local this = { }
        local aim_data = { }
        local bullet_impacts = { }

        local generate_flags = function(pre_data)
            return {
                pre_data.self_choke > 1 and 1 or 0,
                pre_data.velocity_modifier < 1.00 and 1 or 0,
                pre_data.flags.boosted and 1 or 0
            }
        end

        local get_safety = function(aim_data, target)
            local has_been_boosted = aim_data.boosted
            local plist_safety = plist_get(target, 'Override safe point')
            local ui_safety = { ui_get(prefer_safe_point), ui_get(force_safe_point) or plist_safety == 'On' }
    
            if not has_been_boosted then
                return -1
            end
    
            if plist_safety == 'Off' or not (ui_safety[1] or ui_safety[2]) then
                return 0
            end
    
            return ui_safety[2] and 2 or (ui_safety[1] and 1 or 0)
        end

        local get_inaccuracy_tick = function(pre_data, tick)
            local spread_angle = -1
            for k, impact in pairs(bullet_impacts) do
                if impact.tick == tick then
                    local aim, shot = 
                        (pre_data.eye-pre_data.shot_pos):angles(),
                        (pre_data.eye-impact.shot):angles()
        
                        spread_angle = vector(aim-shot):length2d()
                    break
                end
            end

            return spread_angle
        end

        this.fired = function(e)
            local this = { }
            local p_ent = e.target
            local me = entity_get_local_player()
        
            aim_data[e.id] = {
                original = e,
                dropped_packets = { },
        
                handle_time = globals_realtime(),
                self_choke = globals_chokedcommands(),
        
                flags = {
                    boosted = e.boosted
                },

                safety = get_safety(e, p_ent),
                correction = plist_get(p_ent, 'Correction active'),
        
                shot_pos = vector(e.x, e.y, e.z),
                eye = vector(client_eye_position()),
                view = vector(client_camera_angles()),
        
                velocity_modifier = entity_get_prop(me, 'm_flVelocityModifier'),
                total_hits = entity_get_prop(me, 'm_totalHitsOnServer'),

                history = globals.tickcount() - e.tick
            }
        end
        
        this.missed = function(e)
			
			local m_r, m_g, m_b = ui.get(ui_stuff.miss_color)
			local hex_miss = RGBtoHEX(m_r, m_g, m_b)
			
            if aim_data[e.id] == nil then
                return
            end
        
            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)
            
            local net_data = net_channel:get()
        
            local ping, avg_ping = 
                net_data.latency.crn(0)*1000, 
                net_data.latency.average(0)*1000
        
            local net_state = string_format(
                'delay: %d:%.2f | dropped: %d', 
                avg_ping, math_abs(avg_ping-ping), #pre_data.dropped_packets
            )
        
            local uflags = {
                math_abs(avg_ping-ping) < 1 and 0 or 1,
                cvar.cl_clock_correction:get_int() == 1 and 0 or 1,
                cvar.cl_clock_correction_force_server_tick:get_int() == 999 and 0 or 1
            }
        
            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            
            local me = entity_get_local_player()
            local hgroup = (hitgroup_names[e.hitgroup + 1] or '?')
            local target_name = (entity_get_player_name(e.target))
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)
			
			if string.len(target_name) > 15 then
				target_name = "long name retard"
			end
        
            local reasons = {
                ['event_timeout'] = function()
                    print(string_format(
                        'Missed %s shot due to event timeout [%s] [%s]', 
                        shot_id, target_name, net_state
                    ))
                end,

                ['death'] = function()
					 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to death [dropped: %d ]', 
                        shot_id, target_name, hgroup, hit_chance, #pre_data.dropped_packets
                    ))
					end
					 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") then
					 
						
					 
						if ui.get(ui_stuff.popaps) == "Left screen" then
					  nexus_push:paint(3,string_format(
                        'TARGET:    \aff878bFF%s\n \affffffffHITBOX:    \aff878bFF%s\n \affffffffREASON:     \aff878bFFDEATH', 
                     target_name, hgroup
					))
					end
						if ui.get(ui_stuff.popaps) == "Centered" then
							nexus_push:paint(3,string_format(
							  '\a'..hex_miss.."Missed \aFFFFFFFFshot at %s's ".."\a"..hex_miss.."%s \aFFFFFFFFdue to \a"..hex_miss.."death", 
								 target_name, hgroup
							))
						end
					end
                end,
        
                ['prediction_error'] = function(type)

                    local type = type == 'unregistered shot' and (' [' .. type .. ']') or ''
					 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to prediction error%s [%s] [bt: %d ]', 
                        shot_id, target_name, hgroup, hit_chance, type, net_state, pre_data.history
                    ))
					end
					 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") then
						if ui.get(ui_stuff.popaps) == "Left screen" then
							nexus_push:paint(3,string_format(
							  'TARGET: \aff878bFF%s\n \affffffffHITBOX: \aff878bFF%s\n \affffffffREASON:  \aff878bFFPREDICTION ERROR', 
						   target_name, hgroup
						  ))
						  end
							  if ui.get(ui_stuff.popaps) == "Centered" then
								nexus_push:paint(3,string_format(
									'\a'..hex_miss.."Missed \aFFFFFFFFshot at %s's ".."\a"..hex_miss.."%s \aFFFFFFFFdue to \a"..hex_miss.."prediction error", 
									target_name, hgroup
								))
							  end
					end
                end,
        
                ['spread'] = function()
				 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to spread ( damage: %d | bt: %d )',
                        shot_id, target_name, hgroup, hit_chance, spread_angle, 
                        pre_data.original.damage, pre_data.history
                    ))
					end
					 if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") then
						if ui.get(ui_stuff.popaps) == "Left screen" then
							nexus_push:paint(3,string_format(
							  'TARGET: \aff878bFF%s\n \affffffffHITBOX: \aff878bFF%s\n \affffffffREASON:  \aff878bFFSPREAD', 
						   target_name, hgroup
						  ))
						  end
							  if ui.get(ui_stuff.popaps) == "Centered" then
								  nexus_push:paint(3,string_format(
							  '\a'..hex_miss.."Missed \aFFFFFFFFshot at %s's ".."\a"..hex_miss.."%s \aFFFFFFFFdue to \a"..hex_miss.."spread", 
								 target_name, hgroup
								))
							  end
							end
                end,
        
                ['unknown'] = function(type)
                    local _type = {
                        ['damage_rejected'] = 'damage rejection',
                        ['unknown'] = string_format('UNKNOWN')
                    }
					if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Console") then
                    print(string_format(
                        'Missed %s shot at %s\'s %s(%s%%) due to %s ( dmg: %d | bt: %d  )',
                        shot_id, target_name, hgroup, hit_chance, _type[type or 'unknown'],
                        pre_data.original.damage, pre_data.safety, pre_data.history
                    ))
					end
					if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") then
						if ui.get(ui_stuff.popaps) == "Left screen" then
							nexus_push:paint(3,string_format(
							  'TARGET: \aff878bFF%s\n \affffffffHITBOX: \aff878bFF%s\n \affffffffREASON:  \aff878bFFUNKNOWN', 
						   target_name, hgroup
						  ))
						  end
							  if ui.get(ui_stuff.popaps) == "Centered" then
								  nexus_push:paint(3,string_format(
								  '\a'..hex_miss.."Missed \aFFFFFFFFshot at %s's ".."\a"..hex_miss.."%s \aFFFFFFFFdue to \a"..hex_miss.."unknown", 
									 target_name, hgroup
								))
							  end
							end
                end
				
            }
        
            local post_data = {
                event_timeout = (globals_realtime() - pre_data.handle_time) >= 0.5,
                damage_rejected = e.reason == '?' and pre_data.total_hits ~= entity_get_prop(me, 'm_totalHitsOnServer'),
                prediction_error = e.reason == 'prediction error' or e.reason == 'unregistered shot'
            }
        
            if post_data.event_timeout then 
                reasons.event_timeout()
            elseif post_data.prediction_error then 
                reasons.prediction_error(e.reason)
            elseif e.reason == 'spread' then
                reasons.spread()
            elseif e.reason == '?' then
                reasons.unknown(post_data.damage_rejected and 'damage_rejected' or 'unknown')
            elseif e.reason == 'death' then
                reasons.death()
            end
            aim_data[e.id] = nil
        end
        
        this.hit = function(e)
			
			local h_r, h_g, h_b = ui.get(ui_stuff.hit_color)
			local hex_hit = RGBtoHEX(h_r, h_g, h_b)
			
            if aim_data[e.id] == nil then
                return
            end
        
            local p_ent = e.target


            local pre_data = aim_data[e.id]
            local shot_id = num_format((e.id % 15) + 1)

            local me = entity_get_local_player()
            local hgroup = (hitgroup_names[e.hitgroup + 1] or '?')
            local aimed_hgroup = hitgroup_names[pre_data.original.hitgroup + 1] or '?'

            local target_name = (entity_get_player_name(e.target))
			local rmn_health = entity.get_prop(p_ent, "m_iHealth")
            local hit_chance = math_floor(pre_data.original.hit_chance + 0.5)
            local pflags = generate_flags(pre_data)

			if string.len(target_name) > 15 then
				target_name = "long name retard"
			end
	
            local spread_angle = get_inaccuracy_tick( pre_data, globals_tickcount() )
            
            local _verification = function()
                local text = ''

                local hg_diff = hgroup ~= aimed_hgroup
                local dmg_diff = e.damage ~= pre_data.original.damage
        
                if hg_diff or dmg_diff then
                    text = string_format(
                        ' | mismatch: [ %s ]', (function()
                            local addr = ''

                            if dmg_diff then addr = 'dmg: ' .. pre_data.original.damage .. (hg_diff and ' | ' or '') end
                            if hg_diff then addr = addr .. (hg_diff and 'hitgroup: ' .. aimed_hgroup or '') end

                            return addr
                        end)()
                    )
                end

                return text
            end
            if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Console") then
				print(string_format(
					'Fired %s shot in %s %s for %d damage ( hc: %d%% | bt: %d )',
					shot_id, target_name, hgroup, e.damage,
					hit_chance, pre_data.history, _verification()
				))
            end

            if ui.get(ui_stuff.loger) and contains(ui_stuff.loger2, "Pop Up") then

				if ui.get(ui_stuff.popaps) == "Centered" then
					nexus_push:paint(3,string_format(
					  '\a'..hex_hit..'Hit \aFFFFFFFF%s in \a'..hex_hit..'%s \aFFFFFFFFfor \a'..hex_hit..'%d \aFFFFFFFFdamage (\a'..hex_hit..'%i \aFFFFFFFFhp remaining)', 
					  target_name, hgroup, e.damage, rmn_health
					))
				end  
				if ui.get(ui_stuff.popaps) == "Left screen" then
					nexus_push:paint(3, string_format(
						'\affffffffHITTED:  \aaff7a3FF%s\n\affffffffHITBOX:  \aaff7a3FF%s\n\affffffffDAMAGE:  \aaff7a3FF%d  ',
						target_name, hgroup, e.damage
					))
				end
			end
        end
        
        this.bullet_impact = function(e)
            local tick = globals_tickcount()
            local me = entity_get_local_player()
            local user = client_userid_to_entindex(e.userid)
            
            if user ~= me then
                return
            end
        
            if #bullet_impacts > 150 then
                bullet_impacts = { }
            end
        
            bullet_impacts[#bullet_impacts+1] = {
                tick = tick,
                eye = vector(client_eye_position()),
                shot = vector(e.x, e.y, e.z)
            }
        end
        
        this.net_listener = function()
            local net_data = net_channel:get()
        
            if net_data == nil then
                return
            end

            if not net_channel.is_valid_packet then
                for id in pairs(aim_data) do
                    table_insert(aim_data[id].dropped_packets, net_channel.seqNr_out)
                end
            end
        end

        return this
    end
}

local net_channel = classes.net_channel()
local aimbot = classes.aimbot(net_channel)

local g_player_hurt = function(e)
    local attacker_id = client_userid_to_entindex(e.attacker)
	
    if attacker_id == nil or attacker_id ~= entity_get_local_player() then
        return
    end

    local group = hitgroup_names[e.hitgroup + 1] or "?"
	
    if group == "generic" and weapon_to_verb[e.weapon] ~= nil then
        local target_id = client_userid_to_entindex(e.userid)
		local target_name = entity_get_player_name(target_id)

		print(string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
		
		if ui.get(ui_stuff.popaps) == "Centered" then
			nexus_push:paint(3, string_format("%s %s for %i damage (%i remaining)", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
		elseif ui.get(ui_stuff.popaps) == "Left screen" then
			nexus_push:paint(3, string_format("\aFFFFFFFF%s %s\ndamage:   %i\n%i remaining", weapon_to_verb[e.weapon], string_lower(target_name), e.dmg_health, e.health))
		end
	end
end

local interface_callback = function(c)
    local addr = not ui_get(c) and 'un' or ''
    local _func = client[addr .. 'set_event_callback']

    _func('aim_fire', aimbot.fired)
    _func('aim_miss', aimbot.missed)
    _func('aim_hit', aimbot.hit)
    _func('bullet_impact', aimbot.bullet_impact)
    _func('net_update_start', aimbot.net_listener)
    _func('player_hurt', g_player_hurt)
end

ui_set_callback(ui_stuff.loger, interface_callback)
interface_callback(ui_stuff.loger)

client.set_event_callback( "net_update_end", function ( )
    
    local peru = entity.get_local_player( )
    if ui.get(aa_init[0].aas) then
        if entity.is_alive(peru) then
            entity.set_prop(peru,"m_flModelScale", 0.6, 12 )
        end
    else
        entity.set_prop(peru,"m_flModelScale", 1, 12)           
    end
end)

local alpha0 = 0
 function ui.multiReference(tab, groupbox, name)
    local ref1, ref2, ref3 = ui.reference(tab, groupbox, name)
    return { ref1, ref2, ref3 }
end

dt = ui.multiReference("RAGE", "Aimbot", "Double tap")


local function ext_tp(cmd)
	
	if not ui.get(ui_stuff.tele) then return end

	local local_player = entity.get_local_player()
	local weapon_ent = entity.get_player_weapon(local_player)
	if weapon_ent == nil then return end
	local weapon = csgo_weapons(weapon_ent)
	if weapon == nil then return end
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	local weapon = csgo_weapons[weapon_idx]
	if weapon_ent == nil then return end

	if ui.get(ui_stuff.tele_key) then
		renderer.indicator(159, 202, 43, 255, "Ϟ     ")
		if ui.get(dt[1]) and ui.get(dt[2]) then
			ui.set(sv_maxusrcmdprocessticks, 18)
			if antiaim_funcs:get_tickbase_shifting() > 12 then
				cmd.force_defensive = math.random(1,2);
			end
		end
	else
		cmd.force_defensive = false
	end
end

function lerp(a, b, t)
if not b  or not a or not t then return end
    return a + (b - a) * t
end
local function on_paint()

	if not ui.get(ui_stuff.tele) then return end
	
	if ui.get(ui_stuff.tele_key) then
		if alpha0 ~= 0 then
			renderer.indicator(159, 202, 43, alpha0, "Ϟ     ")
		end
	end
	
	local local_player = entity.get_local_player()
	local weapon_ent = entity.get_player_weapon(local_player)
	if weapon_ent == nil then return end
	local weapon = csgo_weapons(weapon_ent)
	if weapon == nil then return end
	local weapon_idx = entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")
	local weapon = csgo_weapons[weapon_idx]
	if weapon_ent == nil then return end
	
	if ui.get(ui_stuff.tele_key) then
		if ui.get(dt[1]) and ui.get(dt[2]) then
			alpha0 = 255
		else
			alpha0 = 0
		end
	end
end
client.set_event_callback("paint", on_paint)
client.set_event_callback('setup_command', ext_tp, cmd)