-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_camera_angles, client_color_log, client_draw_text, client_exec, client_eye_position, client_key_state, client_latency, client_screen_size, client_set_cvar, client_set_event_callback, client_system_time, client_userid_to_entindex, client_userid_to_index, entity_get_classname, entity_get_esp_data, entity_get_local_player, entity_get_player_name, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_is_alive, entity_is_enemy, entity_set_prop, globals_chokedcommands, globals_curtime, globals_realtime, globals_tickcount, math_abs, math_cos, math_floor, math_max, math_pow, math_sqrt, renderer_blur, renderer_circle, renderer_circle_outline, renderer_gradient, renderer_rectangle, require, error, math_min, math_sin, table_insert, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_combobox, ui_new_hotkey, ui_new_label, ui_new_multiselect, ui_new_slider, ui_reference, unpack, fn, globals_frametime, ipairs, json_parse, json_stringify, math_random, panorama_loadstring, renderer_load_svg, renderer_text, renderer_texture, setmetatable, table_remove, toticks, ui_set, pairs, renderer_measure_text, tostring, ui_new_button, tonumber, ui_is_menu_open, ui_set_visible, entity_get_all, renderer_triangle, client_current_threat = client.camera_angles, client.color_log, client.draw_text, client.exec, client.eye_position, client.key_state, client.latency, client.screen_size, client.set_cvar, client.set_event_callback, client.system_time, client.userid_to_entindex, client.userid_to_index, entity.get_classname, entity.get_esp_data, entity.get_local_player, entity.get_player_name, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.is_alive, entity.is_enemy, entity.set_prop, globals.chokedcommands, globals.curtime, globals.realtime, globals.tickcount, math.abs, math.cos, math.floor, math.max, math.pow, math.sqrt, renderer.blur, renderer.circle, renderer.circle_outline, renderer.gradient, renderer.rectangle, require, error, math.min, math.sin, table.insert, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_combobox, ui.new_hotkey, ui.new_label, ui.new_multiselect, ui.new_slider, ui.reference, unpack, fn, globals.frametime, ipairs, json.parse, json.stringify, math.random, panorama.loadstring, renderer.load_svg, renderer.text, renderer.texture, setmetatable, table.remove, toticks, ui.set, pairs, renderer.measure_text, tostring, ui.new_button, tonumber, ui.is_menu_open, ui.set_visible,entity.get_all, renderer.triangle, client.current_threat
local bit_band, bit_rshift = bit.band, bit.rshift
local entity_get_game_rules = entity.get_game_rules
local globals_maxplayers = globals.maxplayers
local entity_get_player_resource = entity.get_player_resource
local mouse_position = ui.mouse_position
local obex_data = obex_fetch and obex_fetch() or {username = 'Admin', build = 'Debug', discord=''}
LPH_JIT = function(...) return ... end
LPH_ENCSTR = function(...) return ... end
LPH_ENCNUM = function(...) return ... end
LPH_CRASH = function(...) return ... end
--# MAIN
local _debug = false
local ffi = require "ffi"
local bit = require 'bit'
local lua_version = "2.0.6"
local updater = true
--local engineclient = require ("gamesense/engineclient") or error("Missing Engineclient Lib go sub, https://gamesense.pub/forums/viewtopic.php?id=42362")
local anti_aim = require ("gamesense/antiaim_funcs") or error("Missing Anti-Aim Functions Lib go sub, https://gamesense.pub/forums/viewtopic.php?id=29665")
local clipboard = require("gamesense/clipboard") or error("Missing Clipboard Lib go sub, https://gamesense.pub/forums/viewtopic.php?id=28678")
local base64 = require("gamesense/base64") or error("Missing base64 Lib go sub, https://gamesense.pub/forums/viewtopic.php?id=21619")
local ent = require("gamesense/entity") or error("Missing entity library, go sub in the forums")
local http = require("gamesense/http") or error("Missing http library, go sub in the forums")
local vector = require "vector" or error("Missing vector library, go sub in the forums")
local color = require("gamesense/color") or error("Missing Color library, https://gamesense.pub/forums/viewtopic.php?id=41959")
local csgo_weapons = require("gamesense/csgo_weapons") or error("Missing Csgo Weapon library, go sub in the forums")
local random = client.random_int
local scrsize_x, scrsize_y = client_screen_size()
local center_x, center_y = scrsize_x / 2, scrsize_y / 2
local find_material = materialsystem.find_material
local ui_set_callback = ui.set_callback
local client_get_cvar = client.get_cvar
local engine_client = ffi.cast(ffi.typeof('void***'), client.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])
local materials = { 'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4' }
local zeus_svg = renderer_load_svg("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#fff200\" fill-rule=\"evenodd\"></path></g></svg>", 25, 25)
bestcfg = 'VT_eyJBaXIrZHVjayI6eyJmX3dheTQiOjAsImZfd2F5MSI6MCwiZnNib2R5IjpmYWxzZSwidGlja19hYSI6MTUsIkN1c3RvbV9waXRjaCI6MCwiZl93YXk1IjowLCJZYXdMZWZ0IjoxNCwiQm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZSI6dHJ1ZSwiZGVmX21vZGUiOiJTcGluIiwiWWF3QmFzZSI6IkF0IHRhcmdldHMiLCJZYXciOiIxODAiLCJKaXR0ZXIiOiJDZW50ZXIiLCJkZWZfeWF3Ijo1NywiZl93YXkzIjowLCJkZWZfcGl0Y2giOiJVcCIsIlBpdGNoIjoiRG93biIsImZfd2F5MiI6MCwiSml0dGVyT2Zmc2V0Ijo1MywiWWF3QW1vdW50Ijo1MCwiWWF3UmlnaHQiOjIyfSwiU2xvd3dhbGsiOnsiZl93YXk0IjowLCJmX3dheTEiOjAsImZzYm9keSI6dHJ1ZSwidGlja19hYSI6MTUsIkN1c3RvbV9waXRjaCI6MCwiZl93YXk1IjowLCJZYXdMZWZ0IjotMTQsIkJvZHlZYXciOiJKaXR0ZXIiLCJkZWZlbnNpdmUiOnRydWUsImRlZl9tb2RlIjoiU3BpbiIsIllhd0Jhc2UiOiJBdCB0YXJnZXRzIiwiWWF3IjoiMTgwIiwiSml0dGVyIjoiQ2VudGVyIiwiZGVmX3lhdyI6LTEyMiwiZl93YXkzIjowLCJkZWZfcGl0Y2giOiJJZGVhbCIsIlBpdGNoIjoiRG93biIsImZfd2F5MiI6MCwiSml0dGVyT2Zmc2V0Ijo2NiwiWWF3QW1vdW50IjotMTIyLCJZYXdSaWdodCI6MTZ9LCJTdGFuZCI6eyJmX3dheTQiOjAsImZfd2F5MSI6MCwiZnNib2R5IjpmYWxzZSwidGlja19hYSI6MTUsIkN1c3RvbV9waXRjaCI6MCwiZl93YXk1IjowLCJZYXdMZWZ0IjotNCwiQm9keVlhdyI6IkppdHRlciIsImRlZmVuc2l2ZSI6ZmFsc2UsImRlZl9tb2RlIjoiU3BpbiIsIllhd0Jhc2UiOiJBdCB0YXJnZXRzIiwiWWF3IjoiMTgwIiwiSml0dGVyIjoiQ2VudGVyIiwiZGVmX3lhdyI6LTY2LCJmX3dheTMiOjAsImRlZl9waXRjaCI6IlJhbmRvbSIsIlBpdGNoIjoiRG93biIsImZfd2F5MiI6MCwiSml0dGVyT2Zmc2V0IjozNSwiWWF3QW1vdW50IjotNjYsIllhd1JpZ2h0IjoxOH0sIkR1Y2siOnsiZl93YXk0IjowLCJmX3dheTEiOjAsImZzYm9keSI6ZmFsc2UsInRpY2tfYWEiOjE1LCJDdXN0b21fcGl0Y2giOjAsImZfd2F5NSI6MCwiWWF3TGVmdCI6LTEwLCJCb2R5WWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlIjp0cnVlLCJkZWZfbW9kZSI6IlNwaW4iLCJZYXdCYXNlIjoiQXQgdGFyZ2V0cyIsIllhdyI6IjE4MCIsIkppdHRlciI6IkNlbnRlciIsImRlZl95YXciOjczLCJmX3dheTMiOjAsImRlZl9waXRjaCI6IlVwIiwiUGl0Y2giOiJEb3duIiwiZl93YXkyIjowLCJKaXR0ZXJPZmZzZXQiOjMwLCJZYXdBbW91bnQiOjczLCJZYXdSaWdodCI6MjB9LCJSdW5uaW5nIjp7ImZfd2F5NCI6MCwiZl93YXkxIjowLCJmc2JvZHkiOmZhbHNlLCJ0aWNrX2FhIjo1LCJDdXN0b21fcGl0Y2giOjAsImZfd2F5NSI6MCwiWWF3TGVmdCI6LTI5LCJCb2R5WWF3IjoiRmFrZSBKaXR0ZXIiLCJkZWZlbnNpdmUiOmZhbHNlLCJkZWZfbW9kZSI6IlNwaW4iLCJZYXdCYXNlIjoiQXQgdGFyZ2V0cyIsIllhdyI6IlNsb3cgSml0dGVyIiwiSml0dGVyIjoiQ2VudGVyIiwiZGVmX3lhdyI6MjgsImZfd2F5MyI6MCwiZGVmX3BpdGNoIjoiSWRlYWwiLCJQaXRjaCI6IkRvd24iLCJmX3dheTIiOjAsIkppdHRlck9mZnNldCI6MywiWWF3QW1vdW50Ijo1LCJZYXdSaWdodCI6Mzd9LCJBaXIiOnsiZl93YXk0IjowLCJmX3dheTEiOjAsImZzYm9keSI6ZmFsc2UsInRpY2tfYWEiOjE1LCJDdXN0b21fcGl0Y2giOjAsImZfd2F5NSI6MCwiWWF3TGVmdCI6LTEwLCJCb2R5WWF3IjoiSml0dGVyIiwiZGVmZW5zaXZlIjp0cnVlLCJkZWZfbW9kZSI6IlNwaW4iLCJZYXdCYXNlIjoiQXQgdGFyZ2V0cyIsIllhdyI6IjE4MCIsIkppdHRlciI6IkNlbnRlciIsImRlZl95YXciOjQzLCJmX3dheTMiOjAsImRlZl9waXRjaCI6IlJhbmRvbSIsIlBpdGNoIjoiRG93biIsImZfd2F5MiI6MCwiSml0dGVyT2Zmc2V0Ijo1OSwiWWF3QW1vdW50IjotMTAwLCJZYXdSaWdodCI6Mn19'


function get_file_path()
    local _, err = pcall(function() _G() end)
    return _ or err:match('\\(.*):[0-9]'):gsub("\\", "/")
end

local real_shit = false
local function load_shit()
    local bruh = LPH_ENCSTR("http://temp.virtualtech.cc/he/vloader/life/001.php")
    http.get(bruh, function(success2, response2)
    if not success2 or response2.status ~= 200 then
        real_shit = false
    else
        real_shit = true
    end
    end)
end
load_shit()


function lerp(a, b, t)
    return a + (b - a) * t
end


function clamp(x, min, max)
    return x < min and min or x > max and max or x
end

function map(n, start, stop, new_start, new_stop)
    local value = (n - start) / (stop - start) * (new_stop - new_start) + new_start
    return new_start < new_stop and math_max(math_min(value, new_stop), new_start) or math_max(math_min(value, new_start), new_stop)
end

function RGBAtoHEX(redArg, greenArg, blueArg, alphaArg)
    return string.format('%.2x%.2x%.2x%.2x', redArg, greenArg, blueArg, alphaArg)
end

function text_fade_animation(speed, r, g, b, a, text, totalWidth)
    local final_text = ''
    local curtime = globals_curtime()
    local spacesToAdd = math.max(0, totalWidth - #text)

    for i = 1, spacesToAdd do
        final_text = final_text .. ' '
    end

    for i = 1, #text do
        local char = text:sub(i, i)
        local color = RGBAtoHEX(r, g, b, a * math.abs(1 * math.cos(2 * speed * curtime / 4 + i * 5 / 30)))
        final_text = final_text .. '\a' .. color .. char
    end

    return final_text
end



function int32_to_rgb(int32)
    if not int32 then return end
    local limit = 0xff;
    local r = bit_band(bit_rshift(int32, 16), limit);
    local g = bit_band(bit_rshift(int32, 8), limit);
    local b = bit_band(int32, limit);
    return r, g, b
end

function rgb_to_int32(r, g, b)
    return r * (256 * 256) + g * 256 + b;
end

function int(x)
    return math_floor(x + 0.5)
end


function render_hex(r, g, b, a)
    return bit.tohex(
      (math_floor(r + 0.5) * 16777216) +
      (math_floor(g + 0.5) * 65536) +
      (math_floor(b + 0.5) * 256) +
      (math_floor(a + 0.5))
    )
end

function animate_text(time, string, r, g, b, a)
    local t_out, t_out_iter = { }, 1
    local l = string:len( ) - 1
    local r_add = (255 - r)
    local g_add = (255 - g)
    local b_add = (255 - b)
    local a_add = (155 - a)
    for i = 1, #string do
      local iter = (i - 1)/(#string - 1) + time
      t_out[t_out_iter] = "\a" .. render_hex( r + r_add * math_abs(math_cos( iter )), g + g_add * math_abs(math_cos( iter )), b + b_add * math_abs(math_cos( iter )), a + a_add * math_abs(math_cos( iter )) )
      t_out[t_out_iter + 1] = string:sub( i, i )
      t_out_iter = t_out_iter + 2
    end
    return t_out
end


function animate_alpha(initial)
    return math_sin(math_abs(math.pi+(globals_realtime())%(-math.pi*2)))*initial
end

function rec(x, y, w, h, radius, color)
    radius = math_min(x/2, y/2, radius)
    local r, g, b, a = unpack(color)
    renderer_rectangle(x, y + radius, w, h - radius*2, r, g, b, a)
    renderer_rectangle(x + radius, y, w - radius*2, radius, r, g, b, a)
    renderer_rectangle(x + radius, y + h - radius, w - radius*2, radius, r, g, b, a)
    renderer_circle(x + radius, y + radius, r, g, b, a, radius, 180, 0.25)
    renderer_circle(x - radius + w, y + radius, r, g, b, a, radius, 90, 0.25)
    renderer_circle(x - radius + w, y - radius + h, r, g, b, a, radius, 0, 0.25)
    renderer_circle(x + radius, y - radius + h, r, g, b, a, radius, -90, 0.25)
end

function renderer_outline_rectangle(x, y, w, h, r, g, b, a)
    renderer_rectangle(x, y, w, 1, r, g, b, a)
    renderer_rectangle(x + w - 1, y, 1, h, r ,g, b, a)
    renderer_rectangle(x, y + h - 1, w, 1, r, g, b, a)
    renderer_rectangle(x, y, 1, h, r, g, b, a)
end

function rec_outline(x, y, w, h, radius, thickness, color)
    radius = math_min(w/2, h/2, radius)
    local r, g, b, a = unpack(color)
    if radius == 1 then
      renderer_rectangle(x, y, w, thickness, r, g, b, a)
      renderer_rectangle(x, y + h - thickness, w , thickness, r, g, b, a)
    else
      renderer_rectangle(x + radius, y, w - radius*2, thickness, r, g, b, a)
      renderer_rectangle(x + radius, y + h - thickness, w - radius*2, thickness, r, g, b, a)
      renderer_rectangle(x, y + radius, thickness, h - radius*2, r, g, b, a)
      renderer_rectangle(x + w - thickness, y + radius, thickness, h - radius*2, r, g, b, a)
      renderer_circle_outline(x + radius, y + radius, r, g, b, a, radius, 180, 0.25, thickness)
      renderer_circle_outline(x + radius, y + h - radius, r, g, b, a, radius, 90, 0.25, thickness)
      renderer_circle_outline(x + w - radius, y + radius, r, g, b, a, radius, -90, 0.25, thickness)
      renderer_circle_outline(x + w - radius, y + h - radius, r, g, b, a, radius, 0, 0.25, thickness)
    end
end


function txt_glow(x, y, w, h, width, rounding, accent, accent_inner)
    local thickness = 1
    local offset = 1
    local r, g, b, a = unpack(accent)
    if accent_inner then
      rec(x , y, w, h + 1, rounding, accent_inner)
    end
    for k = 0, width do
      if a * (k/width)^(1) > 5 then
        local accent = {r, g, b, a * (k/width)^(2)}
        rec_outline(x + (k - width - offset)*thickness, y + (k - width - offset) * thickness, w - (k - width - offset)*thickness*2, h + 1 - (k - width - offset)*thickness*2, rounding + thickness * (width - k + offset), thickness, accent)
      end
    end
end

local function contains(tbl, val)
    for i=1, #tbl do
        if tbl[i] == val then return true end
    end
    return false
end

local function distance_ft(x2, y2, z2, x1, y1, z1)
	return math_sqrt(
		math_pow(x2 - x1, 2) +
		math_pow(y2 - y1, 2) +
		math_pow(z2 - z1, 2)
	) * 0.0254 / 0.3048
end

local function speed(x, y, z)
	return math_sqrt(
		math_pow(x, 2) +
		math_pow(y, 2) +
		math_pow(z, 2)
	)
end

local function gradient_text(r1, g1, b1, a1, r2, g2, b2, a2, text)
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


local refs = {
	enable = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = {ui_reference("AA", "Anti-aimbot angles", "pitch") },
    yawjitter = { ui_reference("AA", "Anti-aimbot angles", "yaw jitter") },
	yawbase = ui_reference("AA", "Anti-aimbot angles", "Yaw base"),
    bodyyaw = { ui_reference("AA", "Anti-aimbot angles", "Body yaw") },
	yaw = { ui_reference("AA", "Anti-aimbot angles", "Yaw") },
    freestand = { ui_reference("AA", "anti-aimbot angles", "freestanding") },
    fsbodyyaw = ui_reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui_reference("AA", "Anti-aimbot angles", "Edge yaw"),
    roll = ui_reference("AA", "Anti-aimbot angles", "roll"),
    slow = { ui_reference("AA", "Other", "Slow motion") },
    mini_dmg = { ui_reference("RAGE", "Aimbot", "Minimum damage Override")},
    dt = {ui_reference("RAGE", "Aimbot", "Double tap")},
    dt_lag = ui_reference("RAGE", "Aimbot", "Double tap fake lag limit"),
    baim = ui_reference("RAGE", "Aimbot", "Force body aim"),
    safepint = ui_reference("RAGE", "Aimbot", "Force safe point"),
    fd = ui_reference("RAGE", "Other", "Duck peek assist"),
    qp = {ui_reference("RAGE", "Other", "Quick peek assist")},
    os = {ui_reference("AA", "Other", "On shot anti-aim")},
    legmovement = ui_reference("AA", "other", "leg movement"),
    minimum_damage = ui_reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui_reference("RAGE", "Aimbot", "Minimum damage override") },
    on_shot_model = {ui_reference("visuals", "colored models", "On shot")},
    shadow = {ui_reference("visuals", "colored models", "Shadow")},
}

local fl_var = ui_reference("AA", "Fake lag", "Variance")
local fl_mode = ui_reference("AA", "Fake lag", "Amount")
local fakelag = ui_reference("AA", "Fake lag", "Limit")
local max_pticks = ui_reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")
local boost = ui_reference("RAGE", "Other", "Accuracy boost")
local delay_shot = ui_reference("RAGE", "Other", "Delay shot")
local hand_swap = false
--# Menu

local menu = {
    plabel = ui_new_label("AA", "Anti-aimbot angles", "Virutal Anit-Aim Technology"),
    label_color = ui_new_color_picker( "AA", "Anti-aimbot angles", " ", 190, 204, 231, 255),
    tab = ui_new_combobox("AA", "Anti-aimbot angles", " ", "Info & Config", "Anti-Aim", "Ragebot", "Visuals", "Miscellaneous"),
    ept_label = ui_new_label("AA", "Anti-aimbot angles", " "),
    label2 = ui_new_label("AA", "Anti-aimbot angles", "       Welcome to Use Virtualtech"),
    label4 = ui_new_label("AA", "Anti-aimbot angles", "                   user: "..obex_data.username),
    label3 = ui_new_label("AA", "Anti-aimbot angles", "                   build: "..obex_data.build),
    --dt = ui_new_checkbox("AA", "Anti-aimbot angles", "->Optimize DoubleTap"),
    --baimer = ui_new_checkbox("AA", "Anti-aimbot angles", "->Enhanced SafePoint"),
    baimer1 = ui_new_checkbox("AA", "Anti-aimbot angles", "->Enhanced Lethel Body Shot"),
    baimer2 = ui_new_checkbox("AA", "Anti-aimbot angles", "->Improved Accury On Landing"),
    baimer3 = ui_new_checkbox("AA", "Anti-aimbot angles", "->Ignore Limbs On Move/Duck"),
    baimer4 = ui_new_checkbox("AA", "Anti-aimbot angles", "->Force Teleport On Ideal Tick"),
    resolver = ui_new_combobox("AA", "Anti-aimbot angles", "->Resolver for Debug User", "Off", "Normal", "Low Performance"),
    animfix_land = ui_new_combobox("AA", "Anti-aimbot angles", "Animation On Ground", "Off", "Jitter Leg", "Reverse Leg", "Moon Walk"),
    animfix_air = ui_new_combobox("AA", "Anti-aimbot angles", "Animation In Air", "Off", "Legacy Fall", "Moon Walk"),
    animfix_other = ui_new_multiselect("AA", "Anti-aimbot angles", "Animation Other", "Zero Pitch On Landing", "Static Body Lean", "Cringe Crouch"),
    visual = ui_new_multiselect("AA", "Anti-aimbot angles", "Tab", "WaterMaker", "Crosshair", "Manual arrow", "RGB Models", "Defensive", "Slow Down","Min. dmg override", "Aimbot Log", "Debug panel", "Recolor console"),
    manual_ind = ui_new_multiselect("AA", "Anti-aimbot angles", "Manual Arrows", "Manual Direction", "Body Yaw Side"),
    aim_log = ui_new_multiselect("AA", "Anti-aimbot angles", "Aimbot Log", "Screen", "Console"),
    rgb = ui_new_multiselect("AA", "Anti-aimbot angles", "RGB Models", "Backtrack", "On shot"),
    rgb_saturation = ui_new_slider("AA", "Anti-aimbot angles", "RGB Models Saturation", 0, 100, 40),
    rgb_alpha = ui_new_slider("AA", "Anti-aimbot angles", "RGB Models Alpha", 0, 100, 40),
    rgb_speed = ui_new_slider("AA", "Anti-aimbot angles", "RGB Models Speed", 0, 10, 4),
    crs_dist = ui_new_slider("AA", "Anti-aimbot angles", "Crosshair Distance", 0, 100, 20),
    crs_color_label = ui_new_label( "AA", "Anti-aimbot angles", 'Crosshair color' ),
    crs_color = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Crosshair clr', 255, 255, 255, 255 ),
    crs_color1_label = ui_new_label( "AA", "Anti-aimbot angles", 'Desync color' ),
    crs_color1 = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Desync clr', 255, 255, 255, 255 ),
    crs_color2_label = ui_new_label( "AA", "Anti-aimbot angles", 'Body Yaw color' ),
    crs_color2 = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Body Yaw clr', 65, 126, 79, 255 ),
    water_color_label = ui_new_label( "AA", "Anti-aimbot angles", 'Watermark color' ),
    water_color = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Watermark clr', 55, 255, 155, 255 ),
    log_color_label1 = ui_new_label( "AA", "Anti-aimbot angles", 'Aimbot Hit color' ),
    log_hit_color = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Aimbot Hit clr', 204, 175, 243, 255 ),
    log_color_label2 = ui_new_label( "AA", "Anti-aimbot angles", 'Aimbot Miss color' ),
    log_miss_color = ui_new_color_picker( "AA", "Anti-aimbot angles", 'Aimbot Miss clr', 254, 75, 23, 255 ),
    ragdoll = ui_new_combobox("AA", "Anti-aimbot angles", "Ragdoll Control", "Off", "Astronaut", "AirBalloon", "Ghost", "SuperGravity"),
    save_fps = ui_new_multiselect("AA", "Anti-aimbot angles", "FPS Booster", "Optimize Game", "Use Less Glow"),
    cam = ui_new_checkbox("AA", "Anti-aimbot angles", "Disable Camera Collision"),
    fast_ladder = ui_new_checkbox("AA", "Anti-aimbot angles", "Faster Ladder"),
    nochat = ui_new_checkbox("AA", "Anti-aimbot angles", "Hidden Server Chat"),
    knife_lefthand = ui_new_checkbox("AA", "Anti-aimbot angles", "Switch Knife Side"),

}


aa_option = ui_new_multiselect("AA", "Anti-aimbot angles", "anti-aim additions", "show keybinds", "anti backstab", "safe head", "break air lc","jitter movement")
legithotkey = ui_new_hotkey("AA", "Anti-aimbot angles", "->legit antiaim")
freestandinghotkey = ui_new_hotkey("AA", "Anti-aimbot angles", "->freestanding")
Manualaaleft = ui_new_hotkey("AA", "Anti-aimbot angles", "->manual left")
Manualaaright = ui_new_hotkey("AA", "Anti-aimbot angles", "->manual right")
Manualaaforward = ui_new_hotkey("AA", "Anti-aimbot angles", "->manual forward")

--# Anti-aim
local Antiaim = {}

local var = {
    player_states = {"Stand", "Running", "Air", "Air+duck", "Duck", "Slowwalk"},
	player_states_idx = {["Stand"] = 1, ["Running"] = 2, ["Air"] = 3, ["Air+duck"] = 4, ["Duck"] = 5, ["Slowwalk"] = 6},
    p_state = 0
}

Antiaim[0] = {
    Condition = ui_new_combobox("AA", "Anti-aimbot angles", "anti-aim states", var.player_states),
}

for i = 1,6 do
	Antiaim[i] ={
        Pitch = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Pitch\n" ..var.player_states[i], "Off", "Down", "Up", "Minimal", "Random","Custom"),
        Custom_pitch = ui_new_slider("AA", "Anti-aimbot angles", "\n" ..var.player_states[i], -89, 89, 0),
        YawBase = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Yaw Base\n" ..var.player_states[i] , "At targets", "Local view"),
        Yaw = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Yaw\n" ..var.player_states[i] , "180", "Static", "5-Way" ,"Spin", "180 Z", "Slow Jitter","Random"),
        YawLeft = ui_new_slider("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Left Yaw\n" ..var.player_states[i] , -180, 180, 0),
        YawRight = ui_new_slider("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Right Yaw\n" ..var.player_states[i] , -180, 180, 0),
        tick_aa = ui_new_slider("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Switch Tick\n" ..var.player_states[i] , 0, 32, 12),
        f_way1 = ui_new_slider("AA", "Anti-aimbot angles", "[1] 5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way2 = ui_new_slider("AA", "Anti-aimbot angles", "[2] 5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way3 = ui_new_slider("AA", "Anti-aimbot angles", "[3] 5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way4 = ui_new_slider("AA", "Anti-aimbot angles", "[4] 5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        f_way5 = ui_new_slider("AA", "Anti-aimbot angles", "[5] 5-Way Yaw\n" ..var.player_states[i] , -180, 180, 0),
        Jitter = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Jitter Mode\n" ..var.player_states[i] , "Off", "Center", "Offset", "Skitter", "Random"),
        JitterOffset = ui_new_slider("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Jitter Amount\n" ..var.player_states[i] , -180, 180, 0),
        BodyYaw = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Body Yaw\n" ..var.player_states[i] , "Off", "Jitter", "Static", "Opposite", "Fake Jitter", "LBY Break"),
        YawAmount = ui_new_slider("AA", "Anti-aimbot angles", " " ..var.player_states[i] , -180, 180, 0),
        fsbody = ui_new_checkbox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Peek Fake Yaw\n" ..var.player_states[i]),
        defensive = ui_new_checkbox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Enable Defensive\n" ..var.player_states[i]),
        def_pitch = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Defensive Pitch\n" ..var.player_states[i] , "Off", "Down", "Up", "Ideal", "Random"),
        def_mode = ui_new_combobox("AA", "Anti-aimbot angles", "["..string.sub(var.player_states[i],1,1).."] Defensive Yaw\n" ..var.player_states[i] , "180", "Static" ,"Spin", "180 Z"),
        def_yaw = ui_new_slider("AA", "Anti-aimbot angles", " " ..var.player_states[i] , -180, 180, 0),
	}
end


console_lable = ui_new_label("AA", "Anti-aimbot angles", 'Recolor console')
console_color = ui_new_color_picker("AA", "Anti-aimbot angles", 'Cls color', 81, 81, 81, 210)



function choking(cmd)
    local Choke = false
    if cmd.allow_send_packet == false or globals_chokedcommands() > 1 then Choke = true else Choke = false end
    return Choke
end

function is_ex()
    if ui_get(refs.dt[2]) then return true end
    if ui_get(refs.os[2]) then return true end
    return false
end

function is_ideal()
    if not ui_get(refs.dt[2]) then return false end
    if not ui_get(refs.qp[2]) then return false end
    return true
end

function is_scoped()
    local lp = entity_get_local_player()
    if not entity_is_alive(lp) or not lp then return end
    local scoped = entity_get_prop(lp, "m_bIsScoped") == 1
    return scoped
end

function is_dormant(index)
    local dormanted = entity.is_dormant(index)
    return dormanted
end


function is_dt()
    local lp = entity_get_local_player()
    if not ui_get(refs.dt[1]) or not ui_get(refs.dt[2]) or ui_get(refs.fd) then return false end
    if not entity_is_alive(lp) or not lp then return end
    local frametime = globals_frametime()
    local curtime = globals_curtime()
    local weapon = entity_get_prop(lp, "m_hActiveWeapon")
    if weapon == nil then return false end
    local next_attack = entity_get_prop(lp, "m_flNextAttack") + 0.25
	local checkcheck = entity_get_prop(weapon, "m_flNextPrimaryAttack")
	if checkcheck == nil then return end
    local next_primary_attack = checkcheck + 0.15
    if next_attack == nil or next_primary_attack == nil then return false end
    return next_attack - curtime < 0 and next_primary_attack - curtime < 0
end


local body_yaw = 0
local function get_body_yaw()
    local lp = entity_get_local_player()
    if not entity_is_alive(lp) then return end
    local new_body_yaw = entity_get_prop(lp, 'm_flPoseParameter', 11)
    if new_body_yaw then
        new_body_yaw = math_abs(map(new_body_yaw, 0, 1, -60, 60))
        new_body_yaw = math_max(0, math_min(58, new_body_yaw))
        body_yaw = new_body_yaw / 57
    end
    return string.format("%.2f", body_yaw)
end

local function setSpeed(newSpeed)
	if client_get_cvar("cl_sidespeed") == 450 and newSpeed == 450 then return end
    client_set_cvar("cl_sidespeed", newSpeed)
    client_set_cvar("cl_forwardspeed", newSpeed)
    client_set_cvar("cl_backspeed", newSpeed)
end

local Render_engine = (function()
    local self = {}
    local b = function(c, d, e, f, g, h, i)
        local j = 0
        if g == 0 then return end
        renderer_rectangle(c + h + j, d + h + j, e - h * 2 - j * 2, f - h * 2 - j * 2, 17, 17, 17, g)
        renderer_circle(c + e - h - j, d + h + j, 17, 17, 17, g, h, 90, 0.25)
        renderer_circle(c + e - h - j, d + f - h - j, 17, 17, 17, g, h, 360, 0.25)
        renderer_circle(c + h + j, d + f - h - j, 17, 17, 17, g, h, 270, 0.25)
        renderer_circle(c + h + j, d + h + j, 17, 17, 17, g, h, 180, 0.25)
        renderer_rectangle(c + h + j, d + j, e - h * 2 - j * 2, h, 17, 17, 17, g)
        renderer_rectangle(c + e - h - j, d + h + j, h, f - h * 2 - j * 2, 17, 17, 17, g)
        renderer_rectangle(c + h + j, d + f - h - j, e - h * 2 - j * 2, h, 17, 17, 17, g)
        renderer_rectangle(c + j, d + h + j, h, f - h * 2 - j * 2, 17, 17, 17, g)
end
    local k = function(c, d, e, f, l, m, n, o, p, h, i)
        local j = h == 0 and i or 0
        renderer_rectangle(c + h, d, e - h * 2, i, l, m, n, o)
        renderer_circle_outline(c + e - h, d + h, l, m, n, o, h, 270, 0.25, i)
        renderer_gradient(c + e - i, d + h + j, i, f - h * 2 - j * 2, l, m, n, o, l, m, n, p, false)
        renderer_circle_outline(c + e - h, d + f - h, l, m, n, p, h, 360, 0.25, i)
        renderer_rectangle(c + h, d + f - i, e - h * 2, i, l, m, n, p)
        renderer_circle_outline(c + h, d + f - h, l, m, n, p, h, 90, 0.25, i)
        renderer_gradient(c, d + h + j, i, f - h * 2 - j * 2, l, m, n, o, l, m, n, p, false)
        renderer_circle_outline(c + h, d + h, l, m, n, o, h, 180, 0.25, i)
    end
    self.render_container = function(c, d, e, f, l, m, n, o, p, g, h, i, q)
        local r = o ~= 0 and g or o
        local s = o ~= 0 and p or o
        b(c, d, e, f, r, h, i)
        k(c, d, e, f, l, m, n, o, s, h, i)
        if q and g ~= 255 and o ~= 0 then
        end
    end
    return self
end)()

local rounding = 4
local rad = rounding + 2
local n = 45
local o = 16
local function OutlineGlow(x, y, w, h, radius, r, g, b, a)
        renderer_rectangle(x + 2, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
        renderer_rectangle(x + w - 3, y + radius + rad, 1, h - rad * 2 - radius * 2, r, g, b, a)
        renderer_rectangle(x + radius + rad, y + 2, w - rad * 2 - radius * 2, 1, r, g, b, a)
        renderer_rectangle(x + radius + rad, y + h - 3, w - rad * 2 - radius * 2, 1, r, g, b, a)
        renderer_circle_outline(x + radius + rad, y + radius + rad, r, g, b, a, radius + rounding, 180, 0.25, 1)
        renderer_circle_outline(x + w - radius - rad, y + radius + rad, r, g, b, a, radius + rounding, 270, 0.25, 1)
        renderer_circle_outline(x + radius + rad, y + h - radius - rad, r, g, b, a, radius + rounding, 90, 0.25, 1)
        renderer_circle_outline(x + w - radius - rad, y + h - radius - rad, r, g, b, a, radius + rounding, 0, 0.25, 1)
end

local function FadedRoundedGlow(x, y, w, h, radius, r, g, b, a, glow, r1, g1, b1)
    local n = a / 255 * n
    for radius = 4, glow do
        local radius = radius / 2
        OutlineGlow(x - radius, y - radius, w + radius * 2, h + radius * 2, radius, r1, g1, b1, glow - radius * 2)
    end
end

local function container_glow(x, y, w, h, r, g, b, a, alpha, r1, g1, b1, fn)
    if alpha * 255 > 0 then renderer_blur(x, y, w, h) end
    FadedRoundedGlow(x, y, w, h, rounding, r, g, b, alpha * 255, alpha * o, r1, g1, b1)
    if not fn then return end
    fn(x + rounding, y + rounding, w - rounding * 2, h - rounding * 2.0)
end


local dynamic = {}
dynamic.__index = dynamic
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}
    local logs = {}

    function dynamic.new(f, z, r, xi)
       f = math_max(f, 0.001)
       z = math_max(z, 0)

       local pif = math.pi * f
       local twopif = 2 * pif

       local a = z / pif
       local b = 1 / ( twopif * twopif )
       local c = r * z / twopif

       return setmetatable({
          a = a,
          b = b,
          c = c,

          px = xi,
          y = xi,
          dy = 0
       }, dynamic)
    end

    function dynamic:update(dt, x, dx)
       if dx == nil then
          dx = ( x - self.px ) / dt
          self.px = x
       end

       self.y  = self.y + dt * self.dy
       self.dy = self.dy + dt * ( x + self.c * dx - self.y - self.a * self.dy ) / self.b
       return self
    end

    function dynamic:get()
       return self.y
    end

    function fired(e)
        stored_shot = {
            damage = e.damage,
            hitbox = hitgroup_names[e.hitgroup + 1],
            lagcomp = e.teleported,
            backtrack = globals_tickcount() - e.tick
        }
        ideal_shot = true

    end

    function hit(e) --  [hitscan: %s, bt: %s, lagcomp: %s]
        local r, g, b, a = ui_get(menu.log_hit_color)
        local hex = RGBAtoHEX(r, g, b, a)
        local r_string = "hit " .. '\a' .. hex .. string.lower(entity_get_player_name(e.target)) .. " \aFFFFFFBBin " .. hitgroup_names[e.hitgroup + 1] .. " for " .. '\a' .. hex .. e.damage .. " \aFFFFFFBBhp"
        local string = string.format("hit %s in %s for %s hp", string.lower(entity_get_player_name(e.target)), hitgroup_names[e.hitgroup + 1] or '?', e.damage,  math_floor(e.hit_chance).."%", stored_shot.backtrack, stored_shot.lagcomp)
        table_insert(logs, {
            text = r_string,
            color = true,
            timestamp = globals_tickcount()
        })
        
            r,g,b = 0,255,120
            if contains(ui_get(menu.aim_log), "Console") then
            client_color_log(r, g, b, "[Virtual] \0")
            client_color_log(255, 255, 255, string)
        end
    end


    local miss_sp = {}

    function missed(e) --  [dmg: %s, bt: %s, lagcomp: %s]
        local r, g, b, a = ui_get(menu.log_miss_color)
        local hex = RGBAtoHEX(r, g, b, a)
        local miss = e.reason == "?" and "correction" or e.reason
        local r_string = "missed " .. '\a' .. hex .. string.lower(entity_get_player_name(e.target)) .. " \aFFFFFFBBdue to " .. '\a' .. hex .. miss
        local string = string.format("missed %s's %s due to %s", string.lower(entity_get_player_name(e.target)), stored_shot.hitbox, e.reason == "?" and "correction" or e.reason, stored_shot.damage, stored_shot.lagcomp, stored_shot.backtrack)
        table_insert(logs, {
            text = r_string,
            color = false,
            timestamp = globals_tickcount()
        })
            r,g,b = 255,50,50
            if contains(ui_get(menu.aim_log), "Console") then
            client_color_log(r, g, b, "[Virtual] \0")
            client_color_log(255, 255, 255, string)
        end
        local hp_left = entity_get_prop(ent.target, "m_iHealth")
    
        miss_sp[#miss_sp + 1] =
        {
            nigga = ent.target,
            hp = entity_get_prop(ent.target, "m_iHealth"),
        }
    end

    function menu_open()
        local menu_string = "Hit / Miss Someone for DMG / Reason"
        return menu_string
    end


    local last_abftick = 0
    local reversed = false
    local function KaysFunction(A,B,C)
        local d = (A-B) / A:dist(B)
        local v = C - B
        local t = v:dot(d)
        local P = B + d:scaled(t)

        return P:dist(C)
    end



local function round_restart()
    local lp = entity_get_local_player()
    we_danger = false
end

local function player_dead(e)
    if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then return end
    we_danger = false
end
local function anti_knife_dist(x1, y1, z1, x2, y2, z2)
    return math_sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

local we_danger = false
local function anti_knife()
        local lp = entity_get_local_player()
        local players = entity_get_players(true)
        local lx, ly, lz = entity_get_prop(lp, "m_vecOrigin")
        for i=1, #players do
            local x, y, z = entity_get_prop(players[i], "m_vecOrigin")
            local distance = anti_knife_dist(lx, ly, lz, x, y, z)
            local enemy_visible = client.visible(x, y, z)
            local weapon = entity_get_player_weapon(players[i])
            if entity_get_classname(weapon) == "CKnife" and distance <= 260 then
                we_danger = true
            else
                we_danger = false
        end
    end
end


local vulnerable_ticks = 0
local function is_enemy_peek()
    for _, v in ipairs(entity_get_players(true)) do
        local flags = (entity_get_esp_data(v)).flags

        if bit.band(flags, bit.lshift(1, 11)) ~= 0 then
            vulnerable_ticks = vulnerable_ticks + 1
            return true
        end
    end
    vulnerable_ticks = 0
    return false
end


--- @return number count The number of alive enemies
local function get_total_enemies()
    local count = 0

    for e = 1, globals_maxplayers() do
        if entity_get_prop(entity_get_player_resource(), "m_bConnected", e) and entity_is_enemy(e) and entity_is_alive(e) then
            count = count + 1
        end
    end

    return count
end


local last_sim_time = 0
local defensive_until = 0
local function is_defensive_active()
    local lp = entity_get_local_player()
    if not entity_is_alive(lp) or not lp then return end
    if not is_dt() then return end
    if not ui_get(refs.dt[1]) and ui_get(refs.dt[2]) then return end
    local tickcount = globals_tickcount()
    local sim_time = toticks(entity_get_prop(lp, "m_flSimulationTime"))
    local sim_diff = sim_time - last_sim_time

    if sim_diff < 0 then
        defensive_until = tickcount + math_abs(sim_diff) - math_floor(toticks(client_latency()))
    end

    last_sim_time = sim_time

    return defensive_until > tickcount
end



local function get_fake_yaw(index)
	if not entity_is_alive(index) then return end
    local actual_angle = math.deg(math.atan2(entity_get_prop(index, "m_angEyeAngles[1]") - entity_get_prop(index, "m_flLowerBodyYawTarget"),entity_get_prop(index, "m_angEyeAngles[0]")))
    local yesyaw = math.min(60, math.max(-60, (actual_angle * 10000)))
    local body_yaw = yesyaw
	return body_yaw
end


local function legit_aa_onkey(cmd)
    if not ui_get(legithotkey) then return end
    local weaponn = entity_get_player_weapon()
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if cmd.in_attack == 1 then
                cmd.in_attack = 0
                cmd.in_use = 1
            end
        else
            if cmd.chokedcommands == 0 then
                cmd.in_use = 0
            end
        end
    end

last_press = 0
aa_dir = "reset"
local function manual_aa()
    if ui_get(Manualaaright) and last_press + 0.2 < globals_curtime() then
        aa_dir = aa_dir == "right" and "reset" or "right"
        last_press = globals_curtime()
    elseif ui_get(Manualaaleft) and last_press + 0.2 < globals_curtime() then
        aa_dir = aa_dir == "left" and "reset" or "left"
        last_press = globals_curtime()
    elseif ui_get(Manualaaforward) and last_press + 0.2 < globals_curtime() then
        aa_dir = aa_dir == "front" and "reset" or "front"
        last_press = globals_curtime()
    elseif last_press > globals_curtime() then
        last_press = globals_curtime()
    end
end


local current_stage = 1
local state = "None"
local should_defen = false
local dec_pitch = -89
local function antiaim_enable(cmd)
    local lp = entity_get_local_player()

    if not entity_is_alive(lp) or not lp then return end
    manual_aa()
    inverted = entity_get_prop(lp, "m_flPoseParameter", 11) * 120 - 60 <= 0 and true or false
	local vx, vy, vz = entity_get_prop(lp, "m_vecVelocity")
	local p_still = math_sqrt(vx ^ 2 + vy ^ 2) < 2
    local high_speed = math_sqrt(vx ^ 2 + vy ^ 2) > 100
	local on_ground = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 1
    local crouching = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 1 and bit.band(entity_get_prop(lp, "m_fFlags"), 4) == 4
    local air_crouch = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 0 and bit.band(entity_get_prop(lp, "m_fFlags"), 4) == 4
	local p_slow = ui_get(refs.slow[1]) and ui_get(refs.slow[2])
    local tickcount = globals_tickcount()
    local game_rules = entity_get_game_rules()
    local meme_spin = get_total_enemies() == 0 and entity_get_prop(game_rules, "m_iRoundWinStatus") ~= 0
    space_down = client_key_state(0x20)
    on_legit = aa_dir == "left" or aa_dir == "right" or aa_dir == "front"
    if p_still == true and on_ground == true and not crouching == true and not space_down and not on_legit then
	    var.p_state = 1
        state = "STAND"
    end
    if p_still == false and on_ground == true and not crouching == true and not space_down and not on_legit then
	    var.p_state = 2
        state = "MOVE"
    end
    if on_ground == false and not on_legit then
	    var.p_state = 3
        state = "AIR"
    end
    if air_crouch == true and not on_legit then
	    var.p_state = 4
        state = "AIRCROUCH"
    end
    if crouching == true and not space_down and not on_legit then
	    var.p_state = 5
        state = "CROUCH"
    end
    if p_slow == true and on_ground == true and not p_still == true and not on_legit then
	    var.p_state = 6
        state = "SLOW"
    end
    if on_legit then
        state = "MANUAL"
    end

    if ui_get(refs.fd) then
        state = "FAKEDUCK"
    end

    if ui_get(freestandinghotkey) then
        ui_set(refs.freestand[1] , true)
        ui_set(refs.freestand[2] , "Always On")
    else
        ui_set(refs.freestand[1] , false)
        ui_set(refs.freestand[2] , "On Hotkey")
    end

    if contains(ui_get(aa_option), "break air lc") then
        if globals_tickcount() % 2 > 1 then
            cmd.allow_send_packet = on_ground 
        end
    end

    should_defen = is_defensive_active(local_player) and ui_get(refs.dt[1]) and ui_get(refs.dt[2]) and is_dt()
    run_defen = is_defensive_active(local_player)  and is_dt() and ui_get(refs.dt[1]) and ui_get(refs.dt[2])
    if state == "MOVE" and is_enemy_peek() and vulnerable_ticks <= 16 then
        should_defen = run_defen
    end

    if aa_dir == "left" then
        ui_set(refs.pitch[1], "Down")
        ui_set(refs.yawbase, "Local view")
        ui_set(refs.yaw[1], "180")
        ui_set(refs.yaw[2], -90)
        ui_set(refs.bodyyaw[1], "Static")
        ui_set(refs.yawjitter[2], 0)
        elseif aa_dir == "right" then
        ui_set(refs.pitch[1], "Down")
        ui_set(refs.yawbase, "Local view")
        ui_set(refs.yaw[1], "180")
        ui_set(refs.yaw[2], 90)
        ui_set(refs.yawjitter[2], 0)
        ui_set(refs.bodyyaw[1], "Static")
        elseif aa_dir == "front" then
        ui_set(refs.pitch[1], "Down")
        ui_set(refs.yawbase, "Local view")
        ui_set(refs.yaw[1], "180")
        ui_set(refs.yaw[2], 180)
        ui_set(refs.yawjitter[2], 0)
        ui_set(refs.bodyyaw[1], "Static")
        elseif aa_dir == "reset" then
    end
    if aa_dir == "reset" then
        local lp_weapon = entity_get_player_weapon(lp)
        local hold_knife = entity_get_classname(lp_weapon) == "CKnife" and contains(ui_get(aa_option), "safe head")
        local hold_zeus = entity_get_classname(lp_weapon) == "CWeaponTaser" and contains(ui_get(aa_option), "safe head")
        if we_danger and contains(ui_get(aa_option), "anti backstab")  then
            ui_set(refs.pitch[1], "Minimal")
            ui_set(refs.yawbase, "At targets")
            ui_set(refs.yaw[1], "180")
            ui_set(refs.yawjitter[1], "Center")
            ui_set(refs.yaw[2], 180)
            ui_set(refs.yawjitter[2], 50)
            ui_set(refs.bodyyaw[1], "Opposite")
            ui_set(refs.fsbodyyaw, false)
        return
    end
    if not meme_spin then
        if on_ground == false and hold_knife or hold_zeus  then
                ui_set(refs.pitch[1], should_defen and "Up" or "Minimal")
                ui_set(refs.yawbase, "At targets")
                ui_set(refs.yaw[1], should_defen and "Spin" or "180")
                ui_set(refs.yawjitter[1], "Off")
                ui_set(refs.yaw[2], should_defen and 64 or math_random(5,7))
                ui_set(refs.yawjitter[2], 0)
                ui_set(refs.bodyyaw[1], "Opposite")
                ui_set(refs.fsbodyyaw, false)

            return
        end
    end

        if meme_spin then
            ui_set(refs.pitch[1], "Off")
            ui_set(refs.yawbase, "Local view")
            ui_set(refs.yaw[1], "Spin")
            ui_set(refs.yawjitter[1], "Off")
            ui_set(refs.yaw[2], 56)
            ui_set(refs.yawjitter[2], 0)
            ui_set(refs.bodyyaw[1], "Off")
            ui_set(refs.fsbodyyaw, false)
            return
        end

        if ui_get(Antiaim[var.p_state].defensive) and ui_get(refs.dt[1]) and ui_get(refs.dt[2]) then
            if is_dt() then
            cmd.force_defensive = 1
            --cmd.no_choke = 1
            --cmd.quick_stop = 1
            end
        end
        local ideal_shot = false 
        if ui_get(menu.baimer4) and is_ideal() then
            cmd.discharge_pending = ideal_shot
            ideal_shot = false 
        end
        --if not ui_get(Manualaaleft) and not ui_get(Manualaaright) and not ui_get(Manualaaforward)  then
        local tick_base_sw = ui_get(Antiaim[var.p_state].tick_aa)
        local avoid_up = is_ex() and not ui_get(refs.fd)
        if ui_get(Antiaim[var.p_state].Yaw) == "Slow Jitter" then
            if globals_tickcount() % tick_base_sw > tick_base_sw / 2 then
                ui_set(refs.yaw[2], ui_get(Antiaim[var.p_state].YawRight))
            else
                ui_set(refs.yaw[2], ui_get(Antiaim[var.p_state].YawLeft))
            end
        end
        if ui_get(Antiaim[var.p_state].fsbody) then
            ui_set(refs.fsbodyyaw, true)
        else
            ui_set(refs.fsbodyyaw, false)
        end
        if ui_get(Antiaim[var.p_state].Yaw) == "5-Way" then
            ui_set(refs.yaw[1], "180")
            local five_ways = {ui_get(Antiaim[var.p_state].f_way1), ui_get(Antiaim[var.p_state].f_way2), ui_get(Antiaim[var.p_state].f_way3), ui_get(Antiaim[var.p_state].f_way4), ui_get(Antiaim[var.p_state].f_way5)}
            if cmd.command_number % 5 > 1 and choking(cmd) == false then
                current_stage = current_stage + 1
            end
            if current_stage == 6 then
                current_stage = 1
            end
            ui_set(refs.yaw[2], five_ways[current_stage])
        end

        ui_set(refs.enable, true)

        if ui_get(Antiaim[var.p_state].defensive) and should_defen and not ui_get(Antiaim[var.p_state].def_pitch) == "Ideal" then
            ui_set(refs.pitch[1], ui_get(Antiaim[var.p_state].def_pitch))
        else
            ui_set(refs.pitch[1], ui_get(Antiaim[var.p_state].Pitch))
        end

        if ui_get(Antiaim[var.p_state].defensive) and should_defen and ui_get(Antiaim[var.p_state].def_pitch) == "Off" then
            ui_set(refs.pitch[1], "Custom")
            ui_set(refs.pitch[2], 0)
        else
            ui_set(refs.pitch[1], ui_get(Antiaim[var.p_state].Pitch))
        end

        if ui_get(Antiaim[var.p_state].defensive) and should_defen and ui_get(Antiaim[var.p_state].def_pitch) == "Up" then
            ui_set(refs.pitch[1], "Up")
        end

        if ui_get(Antiaim[var.p_state].Pitch) == "Custom" and not should_defen then
            ui_set(refs.pitch[2], ui_get(Antiaim[var.p_state].Custom_pitch))
        end



        if ui_get(Antiaim[var.p_state].defensive) and ui_get(Antiaim[var.p_state].def_pitch) == "Ideal" and should_defen then
            dec_pitch = dec_pitch >= 89 and -89 or dec_pitch + 11
            ui_set(refs.pitch[1], "Custom")
            ui_set(refs.pitch[2], dec_pitch > 89 and -89 or dec_pitch)
        end

        if ui_get(Antiaim[var.p_state].defensive) and ui_get(Antiaim[var.p_state].def_pitch) == "Random" and should_defen then
            ui_set(refs.pitch[1], "Custom")
            ui_set(refs.pitch[2], random(-89, 89))
        end

        if ui_get(Antiaim[var.p_state].Pitch) == "Random" then
            ui_set(refs.pitch[2], random(-89, 89))
        end


        ui_set(refs.yawbase, ui_get(Antiaim[var.p_state].YawBase))

        if ui_get(Antiaim[var.p_state].Yaw) ~= "5-Way" and ui_get(Antiaim[var.p_state].Yaw) ~= "Slow Jitter" and ui_get(Antiaim[var.p_state].Yaw) ~= "Random" and not should_defen then
            ui_set(refs.yaw[1], ui_get(Antiaim[var.p_state].Yaw))
        end



        if ui_get(Antiaim[var.p_state].Yaw) == "Random" then
            ui_set(refs.yaw[1], "180")
            ui_set(refs.yaw[2], random(ui_get(Antiaim[var.p_state].YawLeft), ui_get(Antiaim[var.p_state].YawRight)))
        end

        if ui_get(Antiaim[var.p_state].Yaw) == "Slow Jitter" and ui_get(Antiaim[var.p_state].defensive) and should_defen then
            ui_set(refs.yaw[1], ui_get(Antiaim[var.p_state].def_mode))
        else
            ui_set(refs.yaw[1], "180")
        end


        if ui_get(Antiaim[var.p_state].defensive) and should_defen then
            ui_set(refs.yaw[1], ui_get(Antiaim[var.p_state].def_mode))
        end

        if ui_get(Antiaim[var.p_state].defensive) and should_defen then
        ui_set(refs.yawjitter[1], "Off")
        else
        ui_set(refs.yawjitter[1], ui_get(Antiaim[var.p_state].Jitter))
        end


        ui_set(refs.yawjitter[2], ui_get(Antiaim[var.p_state].JitterOffset))
        ui_set(refs.bodyyaw[2], ui_get(Antiaim[var.p_state].YawAmount))
        if ui_get(Antiaim[var.p_state].BodyYaw) == "Jitter" then
            ui_set(refs.bodyyaw[1], "Jitter")
        elseif ui_get(Antiaim[var.p_state].BodyYaw) == "Static" then
            ui_set(refs.bodyyaw[1], "Static")
        elseif ui_get(Antiaim[var.p_state].BodyYaw) == "Opposite" then
            ui_set(refs.bodyyaw[1], "Opposite")
        elseif ui_get(Antiaim[var.p_state].BodyYaw) == "Off" then
            ui_set(refs.bodyyaw[1], "Off")
        elseif ui_get(Antiaim[var.p_state].BodyYaw) == "Fake Jitter" then
            ui_set(refs.bodyyaw[1], cmd.chokedcommands < 1 and "Off" or "Jitter")
        elseif ui_get(Antiaim[var.p_state].BodyYaw) == "LBY Break" then
            ui_set(refs.bodyyaw[1], cmd.chokedcommands < 1 and "Off" or "Static")
        end
        if  ui_get(Antiaim[var.p_state].defensive) and should_defen then
            if ui_get(Antiaim[var.p_state].Yaw) ~= "5-Way" and ui_get(Antiaim[var.p_state].Yaw) ~= "Slow Jitter" then
                ui_set(refs.yaw[2], ui_get(Antiaim[var.p_state].def_yaw))
            end
        else
            if ui_get(Antiaim[var.p_state].Yaw) ~= "5-Way" and ui_get(Antiaim[var.p_state].Yaw) ~= "Slow Jitter"then
                ui_set(refs.yaw[2], inverted and ui_get(Antiaim[var.p_state].YawRight) or ui_get(Antiaim[var.p_state].YawLeft))
        end
    end
    end
end



local function get_speed(index)
    local vx, vy, vz = entity_get_prop(index, "m_vecVelocity")
    local speed = math_sqrt(vx ^ 2 + vy ^ 2)
    local int = math_floor(speed + 0.5)
    return int
end


local function get_pitch(index)
    local pitch = entity_get_prop(index, "m_flPoseParameter", 12 )
    return pitch
end


local all_players = {}
local function safe_point()
        for i,n in ipairs(all_players) do
            local amount_of_shots = 0
            local hp_shot = 0

           if not entity_is_alive(n.index) then table.remove(all_players,i) break end

                for k,v in ipairs(miss_sp) do
                    if v.nigga == n.index then
                        amount_of_shots = amount_of_shots + 1
                    end
                end


            local eyes = vector(entity_get_prop(n.index,"m_angEyeAngles"))

            local mathed = math.floor(eyes.y) - math.floor(n.old_pos)

            if mathed > 180 or mathed < -180 then

                local true_math = 0

                if mathed > 0 then
                    true_math = 199 - mathed
                else
                    true_math = -199 - mathed
                end

                if true_math > 80 or true_math < -80 then
                    n.wjitter = false
                elseif (true_math <= 80 or true_math >= -80 and true_math <= -1) and mathed ~= 0 then
                    n.wjitter = true
                end
            elseif mathed < 180 or mathed > -180 then
                if mathed > 80 or mathed < -80 then
                    n.wjitter = true
                elseif (mathed < 80 or mathed > -80 and mathed <= -1) and mathed ~= 0 then
                    n.wjitter = false
                end

            elseif mathed == 0 and n.wjitter == true then
                n.wjitter = true
            end

            local is_wide_jitter_maybe = false
            local velocity = vector(entity.get_prop(n.index,"m_vecVelocity"))
            local on_ground = bit.band(entity.get_prop(n.index, "m_fFlags"), 1) == 1
                is_wide_jitter_maybe = n.wjitter and velocity:length2d() > 0 and on_ground
        end
    missed_ = amount_of_shots
end
local plist_set = plist.set
local function resolver()
    if ui_get(menu.resolver) == "Off" then return end
    if not obex_data.build == "Debug" then return end
	local enemies =  client_current_threat()
    local tickcount = globals_tickcount()
    if not enemies then return end
    if not entity_is_alive(enemies) then return end
    safe_point()
	local desync = get_fake_yaw(enemies)
    local crouching = bit.band(entity_get_prop(enemies, "m_fFlags"), 1) == 1 and bit.band(entity_get_prop(enemies, "m_fFlags"), 4) == 4
    local hp = entity_get_prop(enemies, "m_iHealth") <= 92
    local high_speed = get_speed(enemies) >= 149
    local p_stand = get_speed(enemies) <= 40
    local jitter_wide = not crouching and is_wide_jitter_maybe
    local resolver_angle =  jitter_wide and desync * 0.75 or desync
    local high_pitch = math_floor(89 - 179 * get_pitch(enemies) + 0.6) > -44
    do_shit = not is_dormant(enemies)
    safe = jitter_wide or hp
	plist_set(enemies, "Force body yaw value", resolver_angle)
	plist_set(enemies, "Force body yaw", do_shit)
    plist_set(enemies, "Override safe point", safe and "On" or "-")
    plist_set(enemies, "Override prefer body aim", hp and "On" or "-")
end

--# Other
local ground_ticks, end_time = 1, 0
local just_land = false
local function animfix(cmd)
    local lp = entity_get_local_player()

    if not entity_is_alive(lp) then return end
    local me = ent.get_local_player()
    local m_fFlags = me:get_prop("m_fFlags");
    local is_onground = bit.band(entity_get_prop(lp, "m_fFlags"), 1) == 1
    local curtime = globals_curtime()
    local self_index = ent.new(lp)
    local self_anim_state = self_index:get_anim_state()
    local randome = random(1,10)

    local hold_aim = cvar["sv_maxusrcmdprocessticks_holdaim"]
    hold_aim:set_raw_int(1)

    if ui_get(menu.animfix_land) == "Jitter Leg" then
        ui_set(refs.legmovement, random(1, 2) == 1 and "Off" or "Always slide")
        entity_set_prop(entity_get_local_player(), "m_flPoseParameter", 1 - client.random_float(0.5, 1), 0)
    end
    if ui_get(menu.animfix_land) == "Moon Walk" then
        ui_set(refs.legmovement, "Never slide")
        entity_set_prop(lp, "m_flPoseParameter", 1, 7)
    end
    if ui_get(menu.animfix_air) == "Moon Walk" and not is_onground then
        local animlayer_6 = me:get_anim_overlay(6);
        animlayer_6.weight = 1;
        entity_set_prop(me, "m_flPoseParameter", 1, 6)
        ui_set(refs.legmovement, "Never slide")
        entity_set_prop(lp, "m_flPoseParameter", 1, 7)
    end
    if ui_get(menu.animfix_land) == "Reverse Leg" and is_onground  then
        ui_set(refs.legmovement, "Always slide")
        entity_set_prop(lp, "m_flPoseParameter", 1, 0)
        entity_set_prop(lp, "m_flPoseParameter", 1, 6)
    end

    if ui_get(menu.animfix_air) == "Legacy Fall" and not is_onground  then
        --ui_set(refs.legmovement, "Always slide")
        entity_set_prop(lp, "m_flPoseParameter", 1, 0)
        entity_set_prop(lp, "m_flPoseParameter", 1, 6)
    end

    if contains(ui_get(menu.animfix_other), "Zero Pitch On Landing") then
        if is_onground  then
            ground_ticks = ground_ticks + 1
        else
            ground_ticks = 0
            end_time = curtime + 1
        end
        just_land = ground_ticks > 17 and end_time > curtime
        if just_land then
            entity_set_prop(lp, "m_flPoseParameter", 0.5 , 12)
        end
    end
    if contains(ui_get(menu.animfix_other), "Static Body Lean") then
        local animlayer_12 = me:get_anim_overlay(12)
        animlayer_12.weight = 0
    end
    if contains(ui_get(menu.animfix_other), "Cringe Crouch") and not ui_get(refs.fd) then
        entity_set_prop(lp, "m_flPoseParameter", -1 , 16)
    end
end
--[[
local function dt_handle(cmd)
    local lp = entity_get_local_player()

    if ui_get(refs.fd) then cvar.sv_maxusrcmdprocessticks:set_int(16); ui_set(max_pticks, 16) return end
    if ui_get(refs.dt[2]) and ui_get(menu.dt) then
        ui_set(max_pticks, 17)
        cvar.sv_maxusrcmdprocessticks:set_int(17)
        cvar.cl_clock_correction:set_int(0)
    else
        ui_set(max_pticks, 16)
        cvar.sv_maxusrcmdprocessticks:set_int(16)
        cvar.cl_clock_correction:set_int(1)
    end
end
--]]
local function accuracy_boost()
    if not ui_get(menu.baimer2) then return end
    local lp = entity_get_local_player()
    if not lp then return end
    local weapon_ent = entity_get_player_weapon(lp)
	if weapon_ent == nil then return end
	local weapon = csgo_weapons(weapon_ent)
	if weapon == nil then return end
    local letsgo = weapon.name == "SSG 08" or weapon.name == "AWP"
    if just_land then
        ui_set(boost, letsgo and "High" or "Medium")
        ui_set(delay_shot, letsgo)
    else
        ui_set(boost, is_ideal() and "Maximum" or "High")
        ui_set(delay_shot, is_ideal() and false or true)
    end
end





local current_hue = 0 -- 初始色相
local function rgb_hit()
    local lp = entity_get_local_player()
    if not lp then return end
    if not contains(ui_get(menu.visual), "RGB Models") then return end
    -- 计算当前色相值，使颜色在彩色范围内循环
    local saturation = ui_get(menu.rgb_saturation)/100 -- 饱和度
    local lightness = 1 -- 亮度
    local hue_speed = ui_get(menu.rgb_speed) * 0.1 -- 控制色相变化的速度
    local alpha = 255 * ui_get(menu.rgb_alpha) * 0.01-- 透明度
    current_hue = (current_hue + hue_speed * globals_frametime()) % 360
    -- 创建 HSL 颜色
    local hsl_color = color.hsv(current_hue, saturation, lightness, alpha)
    -- 获取 RGB 颜色值
    local r, g, b, a = hsl_color:unpack()

    -- 应用颜色值到 UI 控件
    if contains(ui_get(menu.rgb), "Backtrack") then
        ui_set(refs.shadow[2], r, g, b, a)
    end
    if contains(ui_get(menu.rgb), "On shot") then
        ui_set(refs.on_shot_model[2], r, g, b, a)
    end

end



local function disable_cam()

    local collision = cvar["cam_collision"]
    collision:set_raw_int(ui_get(menu.cam) and 0 or 1)
end

local function disable_chat()

    if ui_get(menu.nochat) then
        cvar.cl_chatfilters:set_int(0)
    else
        cvar.cl_chatfilters:set_int(63)
    end
end

local function fast_climb(cmd)
    local lp = entity_get_local_player()

    local pitch, yaw = client_camera_angles()
    if entity_get_prop(lp, "m_MoveType") == 9 then
        cmd.roll = 0
        if ui_get(menu.fast_ladder) then
            if not client_key_state(0x57) and not client_key_state(0x53) then
                if client_key_state(0x41) or client_key_state(0x44) then
                    cmd.pitch = 89
                    cmd.yaw = cmd.yaw + 180
                    if client_key_state(0x41) and not client_key_state(0x44) then
                        cmd.in_moveleft = 0
                        cmd.in_moveright = 1
                    end
                    if client_key_state(0x44) and not client_key_state(0x41) then
                        cmd.in_moveleft = 1
                        cmd.in_moveright = 0
                    end
                end
            end
        end
        if pitch < 45 then
                if client_key_state(0x57) and not client_key_state(0x53) then
                    cmd.pitch = 89
                    cmd.in_moveright = 1
                    cmd.in_moveleft = 0
                    cmd.in_forward = 0
                    cmd.in_back = 1
                    if not client_key_state(0x41) and not client_key_state(0x44) then
                        cmd.yaw = cmd.yaw + 90
                    end
                    if client_key_state(0x41) and not client_key_state(0x44) then
                        cmd.yaw = cmd.yaw + 150
                    end
                    if not client_key_state(0x41) and client_key_state(0x44) then
                        cmd.yaw = cmd.yaw + 30
                    end
                end
            end
            if client_key_state(0x53) and not client_key_state(0x57) then
                cmd.pitch = 89
                cmd.in_moveleft = 1
                cmd.in_moveright = 0
                cmd.in_forward = 1
                cmd.in_back = 0
            if not client_key_state(0x41) and not client_key_state(0x44) then
                cmd.yaw = cmd.yaw + 90
            end
            if not client_key_state(0x41) and client_key_state(0x44) then
                cmd.yaw = cmd.yaw + 150
            end
            if client_key_state(0x41) and not client_key_state(0x44) then
                cmd.yaw = cmd.yaw + 30
            end
        end
    end
end

function errorcheck()
    ui_reference("Visuals", "Other ESP", "Helper")
    return ui_reference("Visuals", "Other ESP", "Helper")
end

function movementjitter(e)

    if not contains(ui_get(aa_option), "jitter movement") then return end
    local lp = entity_get_local_player()
    local weapon_ent = entity_get_player_weapon(lp)
    if not weapon_ent then return end
    local weapon = csgo_weapons(weapon_ent)
    if not weapon then return end
    local x, y, z = entity_get_prop(lp, "m_vecVelocity")
    local velocity = math_sqrt(x*x + y*y + z*z)
    local max_player_speed = (entity_get_prop(lp, "m_bIsScoped") == 1) and weapon.max_player_speed_alt or weapon.max_player_speed
    local max_achieved = false
    local speed = max_achieved and max_player_speed or max_player_speed * 0.95
    if max_achieved then
        if velocity >= max_player_speed * 0.99 then
            max_achieved = false
        end
    elseif velocity <= max_player_speed * 0.95 then
        max_achieved = true
    end
    local helper = ({errorcheck()})[2]
    if tostring(ui_get(helper)) ~= "false" then return end
    cvar.cl_sidespeed:set_int(speed)
    cvar.cl_forwardspeed:set_int(speed)
    cvar.cl_backspeed:set_int(speed)
end


function switch_knife()
    if not ui_get(menu.knife_lefthand) then return end
    local lp = entity_get_local_player()
    if not lp then return end
    local weapon = entity_get_player_weapon(lp)
    if entity_get_classname(weapon) == "CKnife" then
        cvar.cl_righthand:set_raw_int(cvar.cl_righthand:get_string() == "0" and 1 or 0)
        hand_swap = true
    elseif hand_swap then
        cvar.cl_righthand:set_raw_int(tonumber(cvar.cl_righthand:get_string()))
        hand_swap = false
    end
end


function get_state()
    local lp = entity_get_local_player()
    if not lp then return end

    if not state then return end
    local old_state = string.lower(state)
    return old_state
end

active_fraction = 0
inactive_fraction = 0
hide_fraction = 0
fraction = 0
local scope_anim = 0
local desync = 0
local function cross_ind()
    local lp = entity_get_local_player()

    if not entity_is_alive(lp) or not lp then return end
    local r, g, b, a = ui_get(menu.crs_color)
    local rr, gg, bb, aa = ui_get(menu.crs_color2)
    local rrr, ggg, bbb, aaa = ui_get(menu.crs_color1)
    local distance = ui_get(menu.crs_dist)
    local interval = 11
    local frametime = globals_frametime()
    local curtime = globals_curtime()
    local target_yaw = get_body_yaw()
    scope_anim = is_scoped() and lerp(scope_anim, 15, frametime * 5) or lerp(scope_anim, -15, frametime * 5)
    desync = lerp(desync, target_yaw, frametime * 3)
    local vts_w , vts_h = renderer_measure_text("c", "virtual")

    if contains(ui_get(menu.visual), "Crosshair") then
    ---logo render
    if not contains(ui_get(menu.save_fps), "Use Less Glow") then
        txt_glow(center_x + vts_w/2 + scope_anim - vts_w/2 + 3, center_y + distance + 3, vts_w - 3, -1, 10, 5, {r, g, b, 100}, {255, 255, 255, 0})
    end
    renderer_text(center_x + vts_w/2 + scope_anim + 1, center_y + distance + 2, 255, 255, 255, 255, "cd", 0, "vir","\a" .. render_hex(r, g, b, 225) .. "tual")
    ---dsy render
    renderer_outline_rectangle(center_x + vts_w/2 + scope_anim - vts_w/2 + 1, center_y + distance - 1 + interval, vts_w + 1, 4, 0, 0, 0, 255)
    renderer_rectangle(center_x + vts_w/2 + scope_anim - vts_w/2 + 2, center_y + distance + interval, vts_w - 1, 2.5, 25, 25, 25, 255)
    renderer_rectangle(center_x + vts_w/2 + scope_anim - vts_w/2 + 2 , center_y + distance + interval, (vts_w - 1) * desync , 2.5, rrr, ggg, bbb, 255)
    ---state render
    local state_size_x, state_size_y = renderer.measure_text("", get_state())
    renderer_text(center_x + vts_w/2 + scope_anim + 1, center_y + distance + interval * 2 - 2, 255, 255, 255, 255, "c", 0, get_state())
    ---exploit render
    if ui_get(refs.dt[2]) then
    if is_dt() then active_fraction = clamp(active_fraction + frametime/0.15, 0, 1) else active_fraction = clamp(active_fraction - frametime/0.15, 0, 1) end
    if not is_dt() then inactive_fraction = clamp(inactive_fraction + frametime/0.15, 0, 1) else inactive_fraction = clamp(inactive_fraction - frametime/0.15, 0, 1) end
    if math.max(inactive_fraction, active_fraction) > 0 then fraction = clamp(fraction + frametime/0.2, 0, 1) else fraction = clamp(fraction - frametime/0.2, 0, 1) end
    local active_size = renderer.measure_text("c", is_ideal() and "idealtick" or "doubletap")
    local inactive_size = renderer.measure_text("c", "doubletap")
    local rec = animate_text(curtime * 4, is_ideal() and "idealtick" or "doubletap", 75, 255, 75, 255)
    local ret = animate_text(curtime * 4, "doubletap", 255, 75, 75, 255)

    renderer_text(center_x + vts_w/2  + scope_anim + 2 , center_y + distance + interval * 3 - 2, 255, 255, 255, active_fraction * 255, "c", active_fraction * active_size + 1, "", unpack(rec) )
    renderer_text(center_x + vts_w/2  + scope_anim + 2 , center_y + distance + interval * 3 - 2, 255, 255, 255, inactive_fraction * 255, "c", inactive_fraction * inactive_size + 1, "", unpack(ret) )
    end
    if is_ex() and not ui_get(refs.dt[2]) then
    local os_size = renderer.measure_text("c", "on-shot")
    renderer_text(center_x + vts_w/2  + scope_anim + 1 , center_y + distance + interval * 3 - 2, 25, 255, 55, 255, "c", 0, "on-shot")
    renderer_text(center_x + vts_w/2  + scope_anim + 1 , center_y + distance + interval * 3 - 2, 25, 255, 55, 255, "c", 0, "on-shot")
    end
    end

    --dmg override
    if contains(ui_get(menu.visual), "Min. dmg override")  then
        if ui_get(refs.minimum_damage_override[2]) and not ui_is_menu_open() then
        renderer_text(center_x + 5, center_y - 15, 255, 255, 255, 255, "d", 0, ui_get(refs.minimum_damage_override[3]) .. "")
        end
        if ui_is_menu_open() then
        renderer_text(center_x + 5, center_y - 15, 255, 255, 255, 255, "d", 0, "dmg")
        end
    end

    --Manual arrow
    if contains(ui_get(menu.visual), "Manual arrow") and not is_scoped() then
    if contains(ui_get(menu.manual_ind), "Body Yaw Side") and contains(ui_get(menu.manual_ind), "Manual Direction") and not is_scoped() then
        renderer.line(center_x + 40, center_y - 7 , center_x + 40, center_y + 11 , inverted and rr or 35, inverted and gg or 35, inverted and bb or 35, inverted and aa or 150)
        renderer.line(center_x - 40, center_y - 7 , center_x - 40, center_y + 11 , inverted and 35 or rr, inverted and 35 or gg, inverted and 35 or bb, inverted and 150 or aa)
    end
    if not contains(ui_get(menu.manual_ind), "Manual Direction") and contains(ui_get(menu.manual_ind), "Body Yaw Side") then
        renderer_text(center_x + 40, center_y  , inverted and rr or 35, inverted and gg or 35, inverted and bb or 35, 255, "cdb+", 0, ">")
        renderer_text(center_x - 40, center_y  , inverted and 35 or rr, inverted and 35 or gg, inverted and 35 or bb, 255, "cdb+", 0, "<")
    end
        if contains(ui_get(menu.manual_ind), "Manual Direction") then
        renderer_triangle(center_x + 55, center_y + 2 , center_x + 42, center_y - 7 , center_x + 42, center_y + 11 ,
        aa_dir == "right" and r or 35,
        aa_dir == "right" and g or 35,
        aa_dir == "right" and b or 35,
        aa_dir == "right" and a or 150)

        renderer_triangle(center_x - 55, center_y + 2 , center_x - 42, center_y - 7 , center_x - 42, center_y + 11 ,
        aa_dir == "left" and r or 35,
        aa_dir == "left" and g or 35,
        aa_dir == "left" and b or 35,
        aa_dir == "left" and a or 150)

    end
end
end

local function p_log()
    local lp = entity_get_local_player()

    if not lp then return end
    if not contains(ui_get(menu.visual), "Aimbot Log") then return end
    if not contains(ui_get(menu.aim_log), "Screen") then return end

    local frametime = globals_frametime()

    -- 删除最旧的日志
    if #logs > 7 then
        local oldest_index = 1
        local oldest_time = logs[1].timestamp
        for i = 2, #logs do
            if logs[i].timestamp < oldest_time then
                oldest_time = logs[i].timestamp
                oldest_index = i
            end
        end
        table_remove(logs, oldest_index)
    end

    local time_factor = 200 - (#logs * 3)  -- 这里是一个简单的例子，你可以根据需要调整

    -- 从后往前遍历数组
    for i = #logs, 1, -1 do
        local log = logs[i]
        if not log then return end

        if not log.init then
            log.y = dynamic.new(2, 1, 1, -30)
            log.time = globals_tickcount() + time_factor  -- 使用 time_factor 调整时间
            log.init = true
        end

        local r, g, b, a = ui_get(menu.log_miss_color)
        if log.color == true then r, g, b, a = ui_get(menu.log_hit_color) end

        local string_size = renderer_measure_text("c", log.text)
        local ts_w , ts_h = renderer_measure_text("c", logs[i].text)
        if not contains(ui_get(menu.save_fps), "Use Less Glow")  then
            txt_glow(center_x-string_size/2 , scrsize_y-logs[i].y:get() - 140 , ts_w + 1, -1, 10, 5, {r, g, b, 60}, {255, 255, 255, 0})
        end
        renderer_text(center_x , scrsize_y-logs[i].y:get()-140 , 255,255,255,255,"c",0,logs[i].text)

        if tonumber(log.time) < globals_tickcount() then
            if log.y:get() < -10 then
                table_remove(logs, i)
            else
                log.y:update(frametime, -50, nil)
            end
        else
            log.y:update(frametime, 20 + (i * 28), nil)
        end
    end
end

local function water_marker()
    local lp = entity_get_local_player()
    local r, g, b, a = ui_get(menu.water_color)

    if not contains(ui_get(menu.visual), "WaterMaker") then return end
    local frametime = globals_frametime()
    local curtime = globals_curtime()
    local realping = "delay: "..math_floor(client_latency()*1000).."ms"
    local user_id = panorama_loadstring([[ return MyPersonaAPI.GetName() ]])
    local sys_time = {client_system_time()}
    local actual_time = ('%02d:%02d:%02d'):format(sys_time[1], sys_time[2], sys_time[3])
    local full_txt = 'virtualtech'.." · "..user_id().." · "..realping.." · "..actual_time
    local water_txt = " · "..user_id().." · "..realping.." · "..actual_time
    local vt_txt = "virtualtech"
    local vt_size = renderer_measure_text("cd", vt_txt)
    local txt_size = renderer_measure_text("cd", full_txt)
    local name_size = renderer_measure_text("cd", water_txt)
    local res = animate_text(curtime * 2, "virtualtech", r, g, b, a)
    if not contains(ui_get(menu.save_fps), "Use Less Glow") then
    container_glow(center_x - txt_size/2-15, center_y*2 - 32 , txt_size + 30, 25, r, g, b, 1,1,r, g, b)
    end
    Render_engine.render_container(center_x - txt_size/2-15, center_y*2 - 32  , txt_size + 30, 25, r, g, b, 255, 55, a, 6, 1, true)
    renderer_text(center_x + vt_size/2, center_y*2 - 20 , 255, 255, 255, 255, 'cd', 0, water_txt)
    renderer_text(center_x - name_size/2, center_y*2 - 20 , 0, 0, 0, 95, 'cd', 0, vt_txt)
    renderer_text(center_x - name_size/2, center_y*2 - 20  , 255, 255, 255, 255, "cd", nil, unpack(res))

end

local prev_simulation_time = 0
function sim_diff()
    local current_simulation_time = math_floor(0.5 + (entity_get_prop(entity_get_local_player(), "m_flSimulationTime") / globals.tickinterval()))
    local diff = current_simulation_time - prev_simulation_time
    prev_simulation_time = current_simulation_time
    return diff
end

local tick = 0
local ticker = 0
local lerp_alpha = 0
local function defensive_indicator()
    local lp = entity_get_local_player()

    if (entity_is_alive(lp) == false) or not lp then return end
    ticks = sim_diff()
    if contains(ui_get(menu.visual), "Defensive") then


        if ticks < 0 and ui_get(refs.dt[1]) and ui_get(refs.dt[2]) and not ui_get(refs.fd) then
            tick = globals_tickcount()
            defensive_ready = true
            ticker = 0
            lerp_alpha = 255
        end

        if defensive_ready == true then

            local expand = is_defensive and 100 or ticker * 100 / 175
            renderer_texture(defen_svg, center_x, center_y  * 0.5 - 10, 24, 24, 255, 255, 255, lerp_alpha)
            renderer_text(center_x , is_defensive and center_y  * 0.5 - 20 or center_y  * 0.5 - 10 ,255,255,255,lerp_alpha,"c",0,is_defensive and "DEFENSIVE" or "|- Simulated Choke -|")
            if not contains(ui_get(menu.save_fps), "Use Less Glow") then
                txt_glow(center_x - 50, center_y  * 0.5 , 100, 4, 6, 1, {255, 255, 255, 55 * lerp_alpha/255}, {255, 255, 255, 0})
            end
            renderer_rectangle(center_x - 50, center_y  * 0.5, 100, 4, 12, 12, 12, lerp_alpha <= 175 and lerp_alpha or 175)
            renderer_rectangle(center_x - 49, center_y  * 0.5 + 1 , expand, 2 , 255 , 255 , 255 , lerp_alpha)



            if ticker > 155 then
                lerp_alpha = lerp(lerp_alpha, 0, globals_frametime() * 30)
                if lerp_alpha < 20 then
                    defensive_ready = false
                end
            end
            ticker = ticker + 1
        end
    end
end

local function speed_warning()
    local lp = entity_get_local_player()
    if (entity_is_alive(lp) == false) or not lp then return end
    if not contains(ui_get(menu.visual), "Slow Down") then return end

    local modifier = entity_get_prop(lp, "m_flVelocityModifier")
    if  modifier ~= 1  then
        if not contains(ui_get(menu.save_fps), "Use Less Glow") then
            txt_glow(center_x - 50 , center_y  * 0.5 - 41, 101, 4, 6, 1, {255, 255, 255, 50}, {255, 255, 255, 0})
        end
        renderer_text(center_x , center_y  * 0.5 - 65 , 255 , 255 , 255 , 255 , "c" , 0 , "! Speed Warning !")
        renderer_text(center_x , center_y  * 0.5 - 52 , 255 , 255 , 255 , 255 , "c" , 0 , math_floor(modifier/0.01) .. "%")
        renderer_rectangle(center_x - 50, center_y  * 0.5 - 41, 100, 4, 12, 12, 12, 150)
        renderer_rectangle(center_x - 49, center_y  * 0.5 - 40, 100 * modifier ,2, 255 , 255 , 255 , 255)
    end
end

local function sc_ind()
    local lp = entity_get_local_player()
    local tickcount = globals_tickcount()

    if not contains(ui_get(menu.visual), "Misc.") then return end
    if not entity_is_alive(lp) or not lp then return end
    if is_ideal() or ui_is_menu_open()then
        if not contains(ui_get(menu.save_fps), "Use Less Glow") then
        container_glow(center_x-100, center_y-162, 200, 25, is_dt() and 140 or 255, is_dt() and 255 or 0, 0, 1,1,is_dt() and 140 or 255, is_dt() and 255 or 0, 0)
        end
        Render_engine.render_container(center_x-100, center_y-162, 200, 25, is_dt() and 140 or 255, is_dt() and 255 or 0, 0, 65, 50, 255, 6 , 1, true)
        client_draw_text(ctx, center_x, center_y-150, is_dt() and 140 or 255, is_dt() and 244 or 0, is_dt() and 140 or 0, animate_alpha(255), "c", 0, "+/- CHARGED IDEALTICK -/+")
    end
end


local function zeus_warning()
    local lp = entity_get_local_player()

    if not contains(ui_get(menu.visual), "Misc.") then return end
    enemy_player_threat_user_distance = false
	enemy_player_threat_fatal_distance = false
	if (entity_is_alive(lp) == false) or not lp then return end
	local lp_x, lp_y, lp_z = entity_get_prop(lp, "m_vecOrigin")
	local active_players = entity_get_players(true)
	for i = 1, #active_players do
		local enemy_player_is_threat = true
		local enemy_player = active_players[i]
		local ep_x, ep_y, ep_z = entity_get_prop(enemy_player, "m_vecOrigin")
		local eps_x, eps_y, eps_z = entity_get_prop(enemy_player, "m_vecVelocity")
		local distance_to_enemy = distance_ft(ep_x, ep_y, ep_z, lp_x, lp_y, lp_z)
		local warning_distance
		local enemy_speed = speed(eps_x, eps_y, eps_z)
		local weapon = entity_get_classname(entity_get_player_weapon(enemy_player))

		if (weapon ~= "CWeaponTaser") then
			enemy_player_is_threat = false
		end
		if (enemy_speed > 250) then
			warning_distance = 50
		else
			warning_distance = 30
		end
		local is_individual_in_fatal_distance = false
		if (distance_to_enemy < 14 and enemy_player_is_threat == true) then
			enemy_player_threat_fatal_distance = true
			is_individual_in_fatal_distance = true
		elseif (distance_to_enemy > 14 and distance_to_enemy <= warning_distance and enemy_player_is_threat == true) then
			enemy_player_threat_user_distance = true
		else
			enemy_player_is_threat = false
		end
        if (enemy_player_is_threat == true) or ui_is_menu_open() then
            if not contains(ui_get(menu.save_fps), "Use Less Glow") then
            container_glow(center_x-100, center_y-333, 200, 25, 255, 0, 0, 1, 1, 55, 0, 0)
            end
            Render_engine.render_container(center_x-100, center_y-333, 200, 25, 255, 0, 0, 255, 0, 255, 6, 1, true)
            client_draw_text(ctx, center_x, center_y-320, 255, 0, 0, animate_alpha(255), "cdb", 0, "ZUES WARNING")
            renderer_texture(zeus_svg, center_x - 60, center_y-327, 25, 25, 255, 0, 0, animate_alpha(255))
            renderer_texture(zeus_svg, center_x + 44, center_y-327, 25, 25, 255, 0, 0, animate_alpha(255))
        end
    end

end

local last_time = 0
local defensive_untild = 0

local function debug_panel()
local lp = entity_get_local_player()
local tickcount = globals_tickcount()
local r, g, b, a = ui_get(menu.label_color)
if not lp or not entity_is_alive(lp) then return end
if not contains(ui_get(menu.visual), "Debug panel") then return end
local target = client_current_threat()
if not target then return end
local curtime = globals_curtime()
local target_name = entity_get_player_name(target)
local target_yaw = string.format("%.0f", entity_get_prop(lp, "m_flPoseParameter", 11) * 120 - 60)
local sim_time = toticks(entity_get_prop(target, "m_flSimulationTime"))
local sim_diff = sim_time - last_time
local user_id = panorama_loadstring([[ return MyPersonaAPI.GetName() ]])
if sim_diff < 0 then defensive_untild = tickcount + math_abs(sim_diff) - toticks(client_latency()) end
last_time = sim_time
defen_state = is_defensive_active(lp) and "true" or "false"
local vx, vy, vz = entity_get_prop(target, "m_vecVelocity")
local debug_lol = text_fade_animation(1, r, g, b, a ,"Virtualtech Anti-Aim ["..obex_data.build.."]", 0)
enemy_velo = string.format("%.0f", math_sqrt(vx ^ 2 + vy ^ 2))
client_draw_text(ctx, 10 , center_y + 30 , 255, 255, 255, 255, "d", 0, debug_lol)
client_draw_text(ctx, 10 , center_y + 45 , 255, 255, 255, 255, "d", 0, "User: "..obex_data.username)
client_draw_text(ctx, 10 , center_y + 60 , 255, 255, 255, 255, "d", 0, "Target: "..target_name)
client_draw_text(ctx, 10 , center_y + 75 , 255, 255, 255, 255, "d", 0, "Desync: "..target_yaw)
client_draw_text(ctx, 10 , center_y + 90 , 255, 255, 255, 255, "d", 0, "State: "..get_state())
client_draw_text(ctx, 10 , center_y + 105 , 255, 255, 255, 255, "d", 0, "Defensive: "..defen_state)

end

enable_debug = ui.new_checkbox("lua", "b", "DEV Debugger")

function debugger()
    local lp = entity_get_local_player()
    if not lp or not entity_is_alive(lp) then return end
    local tickcount = globals_tickcount()

    if not ui_get(enable_debug) then return end
    local txt = is_defensive_active() and "true" or "false"
    renderer.indicator(200, 0, 0, 255, "State: "..get_state())
    renderer.indicator(200, 0, 0, 255, "YAW: "..get_body_yaw())
    renderer.indicator(200, 0, 0, 255, "DF: "..txt)
    renderer.indicator(200, 0, 0, 255, is_peeking and "PEEK" or "NOT PEEP")
    renderer.indicator(200, 0, 0, 255, should_defen and "DFS" or "NOT DFS")
    renderer.indicator(200, 0, 0, 255, reversed and "Brute force" or "NOT BF")

end

local gravity = 600
function ragdoll_shit()
    if ui_get(menu.ragdoll) == "Off" then
        gravity = 600
    end
    if ui_get(menu.ragdoll) == "Astronaut" then
        gravity = -10000
    end
    if ui_get(menu.ragdoll) == "AirBalloon" then
        gravity = -1000
    end
    if ui_get(menu.ragdoll) == "Ghost" then
        gravity = 0
    end
    if ui_get(menu.ragdoll) == "SuperGravity" then
        gravity = 10000
    end
    client_exec("cl_ragdoll_gravity " .. gravity)
    client_set_cvar("cl_ragdoll_gravity", gravity)
end

client_set_event_callback("player_death", ragdoll_shit)


function recolor_console()
    local r, g, b, a = ui_get(console_color)
    if not contains(ui_get(menu.visual), "Recolor console") then return end
    if not console_is_visible(engine_client) then
        r, g, b, a = 255, 255, 255, 255
    end
    for _, mat in pairs(materials) do
        find_material(mat):alpha_modulate(a)
        find_material(mat):color_modulate(r, g, b)
    end
end

--# Callbacks

function fps_boost()
    client_set_cvar("cl_showerror", 0)
    client_set_cvar("r_shadows", 0)
    client_set_cvar("cl_csm_static_prop_shadows", 0)
    client_set_cvar("r_3dsky", 0)
    client_set_cvar("cl_csm_shadows", 0)
    client_set_cvar("cl_csm_world_shadows", 0)
    client_set_cvar("cl_foot_contact_shadows", 0)
    client_set_cvar("cl_csm_viewmodel_shadows", 0)
    client_set_cvar("cl_csm_rope_shadows", 0)
    client_set_cvar("cl_csm_sprite_shadows", 0)
    client_set_cvar("r_drawrain", 0)
    client_set_cvar("r_drawropes", 0)
    client_set_cvar("r_drawsprites", 0)
    client_set_cvar("fog_enable_water_fog", 0)
    client_set_cvar("func_break_max_pieces", 0)
    client_set_cvar("r_dynamic", 0)
    client_set_cvar("r_dynamiclighting", 0)
    client_set_cvar("dsp_slow_cpu",1)
    client_set_cvar("r_eyegloss", 0)
    client_set_cvar("r_eyemove", 0)
    client_exec("con_filter_text_out Achievements disabled: cheats turned on in this app session.")
end


function fps_reset()
    client_set_cvar("cl_showerror", 0)
    client_set_cvar("r_shadows", 1)
    client_set_cvar("cl_csm_static_prop_shadows", 1)
    client_set_cvar("r_3dsky", 1)
    client_set_cvar("cl_csm_shadows", 1)
    client_set_cvar("cl_csm_world_shadows", 1)
    client_set_cvar("cl_foot_contact_shadows", 1)
    client_set_cvar("cl_csm_viewmodel_shadows", 1)
    client_set_cvar("cl_csm_rope_shadows", 1)
    client_set_cvar("cl_csm_sprite_shadows", 1)
    client_set_cvar("r_drawrain", 1)
    client_set_cvar("r_drawropes", 1)
    client_set_cvar("r_drawsprites", 1)
    client_set_cvar("fog_enable_water_fog", 1)
    client_set_cvar("func_break_max_pieces",1)
    client_set_cvar("r_dynamic", 1)
    client_set_cvar("r_dynamiclighting", 1)
    client_set_cvar("dsp_slow_cpu",1)
    client_set_cvar("r_eyegloss", 1)
    client_set_cvar("r_eyemove", 1)
end

boost_btn = ui_new_button("AA", "Anti-aimbot angles", "I need More FPS", fps_boost)
reset_btn = ui_new_button("AA", "Anti-aimbot angles", "I need More Effects", fps_reset)


function on_player_connect_full(e)
    local local_player = entity_get_local_player()
    if client_userid_to_entindex(e.userid) == local_player then
        defensive_until = 0
        we_danger = false
    end
end

local function on_load()
    --# Other
    ui_set_visible(menu.animfix_land, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.animfix_air, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.animfix_other, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(aa_option, ui_get(menu.tab) == "Anti-Aim")
    ui_set_visible(menu.label2, ui_get(menu.tab) == "Info & Config")
    ui_set_visible(menu.label3, ui_get(menu.tab) == "Info & Config")
    ui_set_visible(menu.label4, ui_get(menu.tab) == "Info & Config")
    --ui_set_visible(menu.baimer, ui_get(menu.tab) == "Ragebot")
    --ui_set_visible(menu.dt, ui_get(menu.tab) == "Ragebot")
    ui_set_visible(menu.baimer1, ui_get(menu.tab) == "Ragebot")
    ui_set_visible(menu.baimer2, ui_get(menu.tab) == "Ragebot")
    ui_set_visible(menu.baimer3, ui_get(menu.tab) == "Ragebot")
    ui_set_visible(menu.baimer4, ui_get(menu.tab) == "Ragebot")
    ui_set_visible(menu.resolver, ui_get(menu.tab) == "Ragebot" and obex_data.build == "Debug")
    ui_set_visible(menu.manual_ind, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Manual arrow"))
    ui_set_visible(menu.aim_log, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Aimbot Log"))
    ui_set_visible(menu.rgb , ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "RGB Models"))
    ui_set_visible(menu.rgb_saturation, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "RGB Models"))
    ui_set_visible(menu.rgb_alpha, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "RGB Models"))
    ui_set_visible(menu.rgb_speed, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "RGB Models"))
    ui_set_visible(menu.ragdoll, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.save_fps, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.knife_lefthand, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.cam, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.nochat, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.fast_ladder, ui_get(menu.tab) == "Miscellaneous")
    ui_set_visible(menu.visual, ui_get(menu.tab) == "Visuals")
    ui_set_visible(menu.crs_color_label, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Crosshair"))
    ui_set_visible(menu.crs_color, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Crosshair"))
    ui_set_visible(menu.crs_color1_label, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Crosshair"))
    ui_set_visible(menu.crs_color1, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Crosshair"))
    ui_set_visible(menu.crs_color2_label, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Manual arrow") and contains(ui_get(menu.manual_ind), "Body Yaw Side"))
    ui_set_visible(menu.crs_color2, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Manual arrow") and contains(ui_get(menu.manual_ind), "Body Yaw Side"))
    ui_set_visible(menu.crs_dist, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Crosshair"))
    ui_set_visible(menu.water_color, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "WaterMaker"))
    ui_set_visible(menu.water_color_label, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "WaterMaker"))
    ui_set_visible(menu.log_hit_color, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.aim_log), "Screen") and contains(ui_get(menu.visual), "Aimbot Log"))
    ui_set_visible(menu.log_miss_color, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.aim_log), "Screen")and contains(ui_get(menu.visual), "Aimbot Log"))
    ui_set_visible(menu.log_color_label1, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.aim_log), "Screen")and contains(ui_get(menu.visual), "Aimbot Log"))
    ui_set_visible(menu.log_color_label2, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.aim_log), "Screen")and contains(ui_get(menu.visual), "Aimbot Log"))
    ui_set_visible(console_lable, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Recolor console"))
    ui_set_visible(console_color, ui_get(menu.tab) == "Visuals" and contains(ui_get(menu.visual), "Recolor console"))
    ui_set_visible(export_btn, ui_get(menu.tab) == "Info & Config")
    ui_set_visible(import_btn, ui_get(menu.tab) == "Info & Config")
    ui_set_visible(default_btn, ui_get(menu.tab) == "Info & Config")
    ui_set_visible(reset_btn, ui_get(menu.tab) == "Miscellaneous" and contains(ui_get(menu.save_fps), "Optimize Game"))
    ui_set_visible(boost_btn, ui_get(menu.tab) == "Miscellaneous" and contains(ui_get(menu.save_fps), "Optimize Game"))
    -----debug
    active_i = var.player_states_idx[ui_get(Antiaim[0].Condition)]
    for i = 1,6 do
        ui_set_visible(Antiaim[i].Pitch, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].Custom_pitch, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[i].Pitch) == "Custom")
        ui_set_visible(Antiaim[i].YawBase, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].Yaw, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].YawLeft, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) ~= "5-Way")
        ui_set_visible(Antiaim[i].YawRight, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) ~= "5-Way")
        ui_set_visible(Antiaim[i].tick_aa, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) ~= "5-Way" and ui_get(Antiaim[active_i].Yaw) == "Slow Jitter")
        ui_set_visible(Antiaim[i].f_way1, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) == "5-Way")
        ui_set_visible(Antiaim[i].f_way2, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) == "5-Way")
        ui_set_visible(Antiaim[i].f_way3, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) == "5-Way")
        ui_set_visible(Antiaim[i].f_way4, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) == "5-Way")
        ui_set_visible(Antiaim[i].f_way5, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Yaw) == "5-Way")
        ui_set_visible(Antiaim[i].Jitter, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].JitterOffset, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].Jitter) ~= "Off")
        ui_set_visible(Antiaim[i].BodyYaw, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].YawAmount, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].BodyYaw) ~= "Off")
        ui_set_visible(Antiaim[i].fsbody, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].defensive, active_i == i and ui_get(menu.tab) == "Anti-Aim")
        ui_set_visible(Antiaim[i].def_mode, active_i == i and ui_get(menu.tab) == "Anti-Aim" and ui_get(Antiaim[active_i].defensive))
        ui_set_visible(Antiaim[i].def_pitch, active_i == i and ui_get(menu.tab) == "Anti-Aim"and ui_get(Antiaim[active_i].defensive))
        ui_set_visible(Antiaim[i].def_yaw, active_i == i and ui_get(menu.tab) == "Anti-Aim"and ui_get(Antiaim[active_i].defensive))
    end
    ui_set_visible(Antiaim[0].Condition, ui_get(menu.tab) == "Anti-Aim")
    ui_set_visible(Manualaaright, ui_get(menu.tab) == "Anti-Aim" and contains(ui_get(aa_option), "show keybinds"))
    ui_set_visible(Manualaaleft, ui_get(menu.tab) == "Anti-Aim" and contains(ui_get(aa_option), "show keybinds"))
    ui_set_visible(Manualaaforward, ui_get(menu.tab) == "Anti-Aim" and contains(ui_get(aa_option), "show keybinds"))
    ui_set_visible(freestandinghotkey, ui_get(menu.tab) == "Anti-Aim"and contains(ui_get(aa_option), "show keybinds"))
    ui_set_visible(legithotkey, ui_get(menu.tab) == "Anti-Aim" and contains(ui_get(aa_option), "show keybinds"))
    --# Skeet antiaim

        ui_set_visible(enable_debug, obex_data.username == "Admin")

    ui_set_visible(refs.enable, ui_get(enable_debug))
    ui_set_visible(refs.yaw[1], ui_get(enable_debug))
    ui_set_visible(refs.yaw[2], ui_get(enable_debug))
    ui_set_visible(refs.bodyyaw[1], ui_get(enable_debug))
    ui_set_visible(refs.bodyyaw[2], ui_get(enable_debug))
    ui_set_visible(refs.roll, ui_get(enable_debug))
    ui_set_visible(refs.freestand[1], ui_get(enable_debug))
    ui_set_visible(refs.freestand[2], ui_get(enable_debug))
    ui_set_visible(refs.yawjitter[1], ui_get(enable_debug))
    ui_set_visible(refs.yawjitter[2], ui_get(enable_debug))
    ui_set_visible(refs.pitch[1], ui_get(enable_debug))
    ui_set_visible(refs.pitch[2], ui_get(enable_debug))
    ui_set_visible(refs.yawbase, ui_get(enable_debug))
    ui_set_visible(refs.fsbodyyaw, ui_get(enable_debug))
    ui_set_visible(refs.edgeyaw, ui_get(enable_debug))
end

--client_set_event_callback("net_update_end", resolver)
client_set_event_callback("player_death", function(e)
    player_dead(e)
end)
client_set_event_callback("round_start", round_restart)

client_set_event_callback('aim_fire',fired)
client_set_event_callback("aim_hit", hit)
client_set_event_callback("aim_miss", missed)


client_set_event_callback("paint_ui", function()
    on_load()
    local r,g,b = ui_get(menu.label_color)
    if ui_is_menu_open() then
        ui_set(menu.plabel, text_fade_animation(2, r, g, b, 255, "Virtualtech Anti-Aim",0))
        ui_set(menu.label4, text_fade_animation(2, 255, 255, 255, 255, "user: "..obex_data.username, 31))
        ui_set(menu.label3, text_fade_animation(2, 255, 255, 255, 255, "build: "..obex_data.build, 32))
    end
end)
client_set_event_callback("paint", function()
    if real_shit then
    water_marker()
    cross_ind()
    p_log()
    sc_ind()
    speed_warning()
    rgb_hit()
    defensive_indicator()
    zeus_warning()
    switch_knife()
    recolor_console()
    debug_panel()
    debugger()
    end
end)

client_set_event_callback("net_update_start", function()
    resolver()
    anti_knife()
end)

client_set_event_callback("setup_command", function(cmd)
    if real_shit then
    antiaim_enable(cmd)
    legit_aa_onkey(cmd)
    fast_climb(cmd)
    --dt_handle(cmd)
    accuracy_boost()
    disable_cam()
    disable_chat()
    end
end)
client_set_event_callback("player_connect_full", on_player_connect_full)

client_set_event_callback("setup_command", movementjitter)

client_set_event_callback("shutdown", function()
    ui_set_visible(refs.enable, true)
    ui_set_visible(refs.yaw[1], true)
    ui_set_visible(refs.yaw[2], true)
    ui_set_visible(refs.bodyyaw[1], true)
    ui_set_visible(refs.bodyyaw[2], true)
    ui_set_visible(refs.roll, true)
    ui_set_visible(refs.freestand[1], true)
    ui_set_visible(refs.freestand[2], true)
    ui_set_visible(refs.yawjitter[1], true)
    ui_set_visible(refs.yawjitter[2], true)
    ui_set_visible(refs.pitch[1], true)
    ui_set_visible(refs.pitch[2], true)
    ui_set_visible(refs.yawbase, true)
    ui_set_visible(refs.fsbodyyaw, true)
    ui_set_visible(refs.edgeyaw, true)
    ui_set_visible(fl_var, true)
    ui_set_visible(fl_mode, true)
    ui_set_visible(fakelag, true)
    if hand_swap then
        cvar.cl_righthand:set_raw_int(tonumber(cvar.cl_righthand:get_string()))
    end
end)


ui_set_callback(menu.knife_lefthand, function()
    if hand_swap then
        cvar.cl_righthand:set_raw_int(tonumber(cvar.cl_righthand:get_string()))
    end
end)

client_set_event_callback("pre_render", function()
    animfix(cmd)
end)



-- Configs

function export_config()
	local settings = {}
	for key, value in pairs(var.player_states) do
		settings[tostring(value)] = {}
		for k, v in pairs(Antiaim[key]) do
			settings[value][k] = ui_get(v)
		end
	end
	client_exec("play buttons/button3;")
    clipboard.set("VT_"..base64.encode(json_stringify(settings), 'base64'))
end
export_btn = ui_new_button("AA", "Anti-aimbot angles", "Export Config", export_config)
function import_config()

	local settings = json_parse(base64.decode(string.sub(clipboard.get(),3,-1), 'base64'))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(Antiaim[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui_set(v, current)
                client_exec("play buttons/button3;")
			end
		end
	end
end
import_btn = ui_new_button("AA", "Anti-aimbot angles", "Import Config", import_config)

function default_config()

	local settings = json_parse(base64.decode(string.sub(bestcfg,3, -1), 'base64'))

	for key, value in pairs(var.player_states) do
		for k, v in pairs(Antiaim[key]) do
			local current = settings[value][k]
			if (current ~= nil) then
				ui_set(v, current)

			end
		end
	end
    client_exec("play buttons/bell1.wav;")
end
default_btn = ui_new_button("AA", "Anti-aimbot angles", "Remine Config", default_config)
