local bit_band, client_camera_angles, client_color_log, client_create_interface, client_delay_call, client_exec, client_eye_position, client_key_state, client_log, client_random_int, client_scale_damage, client_screen_size, client_set_event_callback, client_trace_bullet, client_userid_to_entindex, database_read, database_write, entity_get_local_player, entity_get_player_weapon, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, entity_is_enemy, math_abs, math_atan2, require, error, globals_absoluteframetime, globals_curtime, globals_realtime, math_atan, math_cos, math_deg, math_floor, math_max, math_min, math_rad, math_sin, math_sqrt, print, renderer_circle_outline, renderer_gradient, renderer_measure_text, renderer_rectangle, renderer_text, renderer_triangle, string_find, string_gmatch, string_gsub, string_lower, table_insert, table_remove, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_reference, tostring, ui_is_menu_open, ui_mouse_position, ui_new_combobox, ui_new_slider, ui_set, ui_set_callback, ui_set_visible, tonumber, pcall = bit.band, client.camera_angles, client.color_log, client.create_interface, client.delay_call, client.exec, client.eye_position, client.key_state, client.log, client.random_int, client.scale_damage, client.screen_size, client.set_event_callback, client.trace_bullet, client.userid_to_entindex, database.read, database.write, entity.get_local_player, entity.get_player_weapon, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, entity.is_enemy, math.abs, math.atan2, require, error, globals.absoluteframetime, globals.curtime, globals.realtime, math.atan, math.cos, math.deg, math.floor, math.max, math.min, math.rad, math.sin, math.sqrt, print, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.rectangle, renderer.text, renderer.triangle, string.find, string.gmatch, string.gsub, string.lower, table.insert, table.remove, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.reference, tostring, ui.is_menu_open, ui.mouse_position, ui.new_combobox, ui.new_slider, ui.set, ui.set_callback, ui.set_visible, tonumber, pcall
local ui_menu_position, ui_menu_size, math_pi, renderer_indicator, entity_is_dormant, client_set_clan_tag, client_trace_line, entity_get_all, entity_get_classname = ui.menu_position, ui.menu_size, math.pi, renderer.indicator, entity.is_dormant, client.set_clan_tag, client.trace_line, entity.get_all, entity.get_classname

--> How to utilize obex macros
local obex_data = obex_fetch and obex_fetch() or {username = 'Kenny', build = 'Source'}

--> Colorful text function
local colorful_text = {
    lerp = function(self, from, to, duration)
        if type(from) == 'table' and type(to) == 'table' then
            return { 
                self:lerp(from[1], to[1], duration), 
                self:lerp(from[2], to[2], duration), 
                self:lerp(from[3], to[3], duration) 
            };
        end

        return from + (to - from) * duration;
    end,

    console = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                for k = 1, #v[3] do
                    local l = self:lerp(v[1], v[2], k / #v[3]);
                    client.color_log(l[1], l[2], l[3], v[3]:sub(k, k) .. '\0');
                end
            elseif type(v[1]) == 'table' and type(v[2]) == 'string' then
                client.color_log(v[1][1], v[1][2], v[1][3], v[2] .. '\0');
            end
        end
    end,

    text = function(self, ...)
        local menu = false;
        local alpha = 255
        local f = '';
        
        for i, v in ipairs({ ... }) do
            if type(v) == 'boolean' then
                menu = v;
            elseif type(v) == 'number' then
                alpha = v;
            elseif type(v) == 'string' then
                f = f .. v;
            elseif type(v) == 'table' then
                if type(v[1]) == 'table' and type(v[2]) == 'string' then
                    f = f .. ('\a%02x%02x%02x%02x'):format(v[1][1], v[1][2], v[1][3], alpha) .. v[2];
                elseif type(v[1]) == 'table' and type(v[2]) == 'table' and type(v[3]) == 'string' then
                    for k = 1, #v[3] do
                        local g = self:lerp(v[1], v[2], k / #v[3])
                        f = f .. ('\a%02x%02x%02x%02x'):format(g[1], g[2], g[3], alpha) .. v[3]:sub(k, k)
                    end
                end
            end
        end

        return ('%s\a%s%02x'):format(f, (menu) and 'cdcdcd' or 'ffffff', alpha);
    end,

    log = function(self, ...)
        for i, v in ipairs({ ... }) do
            if type(v) == 'table' then
                if type(v[1]) == 'table' then
                    if type(v[2]) == 'string' then
                        self:console({ v[1], v[1], v[2] })
                        if (v[3]) then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    elseif type(v[2]) == 'table' then
                        self:console({ v[1], v[2], v[3] })
                        if v[4] then
                            self:console({ { 255, 255, 255 }, '\n' })
                        end
                    end
                elseif type(v[1]) == 'string' then
                    self:console({ { 205, 205, 205 }, v[1] });
                    if v[2] then
                        self:console({ { 255, 255, 255 }, '\n' })
                    end
                end
            end
        end
    end
}

local aa = {
	enable = ui.reference("AA", "Anti-aimbot angles", "Enabled"),
	pitch = ui.reference("AA", "Anti-aimbot angles", "pitch"),
	leg = ui.reference("AA", "Other", "Leg Movement"),
	yawbase = ui.reference("AA", "Anti-aimbot angles", "Yaw base"),
	yaw = { ui.reference("AA", "Anti-aimbot angles", "Yaw") },
    fakeyawlimit = ui.reference("AA", "anti-aimbot angles", "Fake yaw limit"),
    fsbodyyaw = ui.reference("AA", "anti-aimbot angles", "Freestanding body yaw"),
    edgeyaw = ui.reference("AA", "Anti-aimbot angles", "Edge yaw"),
    fakeduck = ui.reference("RAGE", "Other", "Duck peek assist"),
	dmg = ui.reference("RAGE", "Aimbot", "Minimum damage"),
	roll = ui.reference("AA", "anti-aimbot angles", "Roll"),
	hc = ui.reference("RAGE", "Aimbot", "Minimum hit chance"),
	baim = ui.reference("RAGE", "Other", "Force body aim"),
	preferbaim = ui.reference("RAGE", "Other", "Prefer body aim"),
	prefersp = ui.reference("RAGE", "Aimbot", "Prefer safe point"),
	sp = { ui.reference("RAGE", "Aimbot", "Force safe point") },
	smtype = { ui.reference("AA", "Other", "Slow motion type") },
	yawjitter = { ui.reference("AA", "Anti-aimbot angles", "Yaw jitter") },
	bodyyaw = { ui.reference("AA", "Anti-aimbot angles", "Body yaw") },
	fs = { ui.reference("AA", "Anti-aimbot angles", "Freestanding") },
	os = { ui.reference("AA", "Other", "On shot anti-aim") },
	sw = { ui.reference("AA", "Other", "Slow motion") },
	dt = { ui.reference("RAGE", "Other", "Double tap") },
	ps = { ui.reference("MISC", "Miscellaneous", "Ping spike") },
	fllimit = ui.reference("AA", "Fake lag", "Limit"),
	flvar = ui.reference("AA", "Fake lag", "Variance"),
	flmode = ui.reference("AA", "Fake lag", "Amount"),
}

local anti_aim = require 'gamesense/antiaim_funcs'

local slidewalk = ui.reference("AA", "other", "leg movement")
local header = ui.new_label("AA", "Anti-aimbot angles", colorful_text:text({{135, 206, 235}, '------------------ [ALIVE] ------------------'}))
local legenable = ui.new_checkbox("AA", "Anti-aimbot angles", "Leg Movement Breaker")
local manual_left_dir = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Left")
local manual_right_dir = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Right")
local manual_backward_dir = ui.new_hotkey("AA", "Anti-aimbot angles", "Manual Back")
local ind_header = ui.new_label("AA", "Anti-aimbot angles", "Indicator Color")
local ind_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\n", 135, 206, 235, 255)
local notify_header = ui.new_label("AA", "Anti-aimbot angles", "NOTIFICATION COLOR")
local notify_color = ui.new_color_picker("AA", "Anti-aimbot angles", "\n", 255,255,255, 255)
local manual_state = ui.new_slider("AA", "Anti-aimbot angles", "\n Manual Direction Number", 0, 3, 0)

local reversed = false
local last_abftick = 0

local pct = 0
local start = 0

local abftimer = globals.tickcount()
local timer = globals.tickcount()
local vector = require "vector"
local paint_funcs = {}
paint_funcs.notifications = {}
paint_funcs.notifications.table_text = {}


-- References
local ref = {
    fakeyawlimit = ui.reference('AA', 'anti-aimbot angles', 'Fake yaw limit'),
    fsbodyyaw = ui.reference('AA', 'anti-aimbot angles', 'Freestanding body yaw'),
	bodyyaw = {ui.reference('AA', 'Anti-aimbot angles', 'Body yaw')},
	fs = {ui.reference('AA', 'Anti-aimbot angles', 'Freestanding')},
	os = {ui.reference('AA', 'Other', 'On shot anti-aim')},
	dt = {ui.reference('RAGE', 'Other', 'Double tap')}
}



-- Screen res
local sc 			= {client.screen_size()}
local cw 			= sc[1]/2
local ch 			= sc[2]/2

-- Menu Items




-- Variables	


-- Gui Creation
local iu = {
	x = database.read("ui_x") or 250,
	y = database.read("ui_y") or 250,
	w = 140,
	h = 1,
	dragging = false
}



local function intersect(x, y, w, h, debug) 
	local cx, cy = ui.mouse_position()
	return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function clamp(x, min, max)
	return x < min and min or x > max and max or x
end

local function contains(table, key)
    for index, value in pairs(table) do
        if value == key then return true end -- , index
    end
    return false -- , nil
end

local function KaysFunction(A,B,C)
    local d = (A-B) / A:dist(B)
    local v = C - B
    local t = v:dot(d) 
    local P = B + d:scaled(t)
    
    return P:dist(C)
end

local should_reset = true

local function reset_brute()
	if should_reset then
		pct = 1
		start = 720
		table.insert(paint_funcs.notifications.table_text, {
		text = "[Alive.Tech] "..colorful_text:text({{255, 255, 255}, 'Anti-Bruteforce reset'}),
		timer = globals.realtime(),

		smooth_y = paint_funcs.notifications.vars.screen[2] + 100,
		alpha = 0,

		first_circle = 0,
		sencond_circle = 0,

		box_left = paint_funcs.notifications.vars.screen[1] / 2,
		box_right = paint_funcs.notifications.vars.screen[1] / 2,

		box_left_1 = paint_funcs.notifications.vars.screen[1] / 2,
		box_right_1 = paint_funcs.notifications.vars.screen[1] / 2
		})

		reversed = false
		should_reset = false
	end
end

local function on_bullet_impact(e)
	local local_player = entity.get_local_player()
	local shooter = client.userid_to_entindex(e.userid)

	if not true then return end

	if not entity.is_enemy(shooter) or not entity.is_alive(local_player) then
		return
	end

	local shot_start_pos 	= vector(entity.get_prop(shooter, "m_vecOrigin"))
	shot_start_pos.z 		= shot_start_pos.z + entity.get_prop(shooter, "m_vecViewOffset[2]")
	local eye_pos			= vector(client.eye_position())
	local shot_end_pos 		= vector(e.x, e.y, e.z)
	local closest			= KaysFunction(shot_start_pos, shot_end_pos, eye_pos)

	if globals.tickcount() - abftimer < 0 then
		abftimer = globals.tickcount()
	end

	if globals.tickcount() - abftimer > 3 and closest < 70 then
		pct = 1
		start = 720
		abftimer = globals.tickcount()
		reversed = not reversed
		last_abftick = globals.tickcount()
		client.delay_call(7, reset_brute);should_reset = true
		table.insert(paint_funcs.notifications.table_text, {
		text = "[Alive.Tech] "..colorful_text:text({{255, 255, 255}, 'Anti-Bruteforce Reversed!'}),
		timer = globals.realtime(),
		
		smooth_y = paint_funcs.notifications.vars.screen[2] + 100,
		alpha = 0,

		first_circle = 0,
		sencond_circle = 0,

		box_left = paint_funcs.notifications.vars.screen[1] / 2,
		box_right = paint_funcs.notifications.vars.screen[1] / 2,

		box_left_1 = paint_funcs.notifications.vars.screen[1] / 2,
		box_right_1 = paint_funcs.notifications.vars.screen[1] / 2
		})
	end
end




--

-- Handles all callbacks
local function handle_callbacks()
	local call_back = client.set_event_callback

	-- Handles Bruteforce
	call_back('bullet_impact', on_bullet_impact)



	-- Resets Bruteforce
	call_back('shutdown', function()
		reset_brute()
	end)

	call_back('round_end', reset_brute)
	call_back('round_start', reset_brute)
	call_back('client_disconnect', reset_brute)
	call_back('level_init', reset_brute)
	call_back('player_connect_full', function(e) if client.userid_to_entindex(e.userid) == entity.get_local_player() then reset_brute() end end)
end


handle_callbacks()



local images = require "gamesense/images"
local csgo_weapons = require "gamesense/csgo_weapons"
local vector = require "vector"








paint_funcs.notifications.vars = {
    screen = {client.screen_size()}
}


local main = {}


local funcs = {}
funcs.math = {}

function funcs.math:lerp(start, vend, time)
    return start + (vend - start) * time
end


table.insert(paint_funcs.notifications.table_text, {
    text = "[Alive.Tech] "..colorful_text:text({{255, 255, 255}, 'Lua Successfully Loaded!'}),
    timer = globals.realtime(),

    smooth_y = paint_funcs.notifications.vars.screen[2] + 100,
    alpha = 0,

    first_circle = 0,
    sencond_circle = 0,

    box_left = paint_funcs.notifications.vars.screen[1] / 2,
    box_right = paint_funcs.notifications.vars.screen[1] / 2,

    box_left_1 = paint_funcs.notifications.vars.screen[1] / 2,
    box_right_1 = paint_funcs.notifications.vars.screen[1] / 2
})   
function paint_funcs.notifications:on_paint()
    if entity.get_local_player() == nil then
        return
    end

    local y = self.vars.screen[2] - 100

    
    for i, info in ipairs(self.table_text) do
        if i > 5 then
            table.remove(self.table_text,i)
        end
        if info.text ~= nil and info ~= "" then
            local text_size = {renderer.measure_text(nil,info.text)}
            if info.timer + 3.8 < globals.realtime() then
                info.first_circle = funcs.math:lerp(info.first_circle,0,globals.frametime() * 1)
                info.sencond_circle = funcs.math:lerp(info.sencond_circle,0,globals.frametime() * 1)
                info.box_left = funcs.math:lerp(info.box_left,self.vars.screen[1]/2,globals.frametime() * 1)
                info.box_right = funcs.math:lerp(info.box_right,self.vars.screen[1]/2,globals.frametime() * 1)
                info.box_left_1 = funcs.math:lerp(info.box_left_1,self.vars.screen[1]/2,globals.frametime() * 1)
                info.box_right_1 = funcs.math:lerp(info.box_right_1,self.vars.screen[1]/2,globals.frametime() * 1)
                info.smooth_y = funcs.math:lerp(info.smooth_y,self.vars.screen[2] + 100,globals.frametime() * 2)
                info.alpha = funcs.math:lerp(info.alpha,0,globals.frametime() * 4)

            else
                info.alpha = funcs.math:lerp(info.alpha,255,globals.frametime() * 4)
                info.smooth_y = funcs.math:lerp(info.smooth_y,y,globals.frametime() * 2)
                info.first_circle = funcs.math:lerp(info.first_circle,275,globals.frametime() * 1)
                info.sencond_circle = funcs.math:lerp(info.sencond_circle,-95,globals.frametime() * 1)
                info.box_left = funcs.math:lerp(info.box_left,self.vars.screen[1]/2 - text_size[1] /2 -2,globals.frametime() * 1)
                info.box_right = funcs.math:lerp(info.box_right,self.vars.screen[1]/2  - text_size[1] /2 +4,globals.frametime() * 1)
                info.box_left_1 = funcs.math:lerp(info.box_left_1,self.vars.screen[1]/2- text_size[1] /2 -2,globals.frametime() * 1)
                info.box_right_1 = funcs.math:lerp(info.box_right_1,self.vars.screen[1]/2 - text_size[1] /2 +4,globals.frametime() * 1)
            end
            local add_y = math.floor(info.smooth_y)
            local alpha = math.floor(info.alpha)
            local first_circle = math.floor(info.first_circle)
            local second_circle = math.floor(info.sencond_circle)
            local left_box = math.floor(info.box_left)
            local right_box = math.floor(info.box_right)
            local left_box_1 = math.floor(info.box_left_1)
            local right_box_1 = math.floor(info.box_right_1)

            local r,g,b,unnnnnnnnnnnnnnnnnn = ui.get(notify_color)



            renderer.rectangle(self.vars.screen[1] / 2 - text_size[1] / 2 - 4 ,add_y - 21,text_size[1] + 8,text_size[2] + 7,0,0,0,100)
            renderer.gradient(self.vars.screen[1] / 2 - text_size[1] / 2 - 4 ,add_y - text_size[2] / 2 + 2, text_size[1] + text_size[2] / 2 + 4,2,r,g,b,alpha,r,g,b,alpha,true)
            renderer.gradient(self.vars.screen[1] / 2 - text_size[1] / 2 - 4 ,add_y - text_size[2] * 2 + 2, text_size[1] + text_size[2] / 2 + 4,2,r,g,b,alpha,r,g,b,alpha,true)
            renderer.circle(self.vars.screen[1] / 2 - text_size[1] / 2 - 4 ,add_y - text_size[2], 0,0,0,100, text_size[2] / 2 + 4, 180, 0.5)
            renderer.circle(self.vars.screen[1] / 2 + text_size[1] / 2 + 4 ,add_y - text_size[2], 0,0,0,100, text_size[2] / 2 + 4, 0, 0.5)
            renderer.circle_outline(self.vars.screen[1] / 2 - text_size[1] / 2 - 4 ,add_y - text_size[2], r,g,b,alpha, text_size[2] / 2 + 4, 90, 0.5,2)
            renderer.circle_outline(self.vars.screen[1] / 2 + text_size[1] / 2 + 4 ,add_y - text_size[2], r,g,b,alpha, text_size[2] / 2 + 4, 270, 0.5,2)

           
            renderer.text(
                self.vars.screen[1] / 2 - text_size[1] / 2 ,add_y - 18,
                r,g,b,alpha,nil,0,info.text
            )
    
            y = y - 30
            if info.timer + 4 < globals.realtime() then
                table.remove(self.table_text,i)
            end
        end
    end

end

function main:paint_ui()
    paint_funcs.notifications:on_paint()
end


client.set_event_callback("paint_ui",main.paint_ui)












client.set_event_callback("net_update_end", function()
	if ui.get(legenable) then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 0)
	end
end)

client.set_event_callback("run_command", function(ctx)
    if ui.get(legenable) then
	p = client.random_int(1, 3)
	if p == 1 then
		ui.set(slidewalk, "Off")
	elseif p == 2 then
       ui.set(slidewalk, "Always slide")
    elseif p == 3 then
		ui.set(slidewalk, "Off")
    end
    ui.set_visible(slidewalk, false)
else
    ui.set_visible(slidewalk, true)
end
end)

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

local ui_get = ui.get
local ffi = require('ffi')
local ffi_cast = ffi.cast
ffi.cdef [[
	typedef int(__thiscall* get_clipboard_text_count)(void*);
	typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
	typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]
local VGUI_System010 =  client_create_interface("vgui2.dll", "VGUI_System010") or print( "Error finding VGUI_System010")
local VGUI_System = ffi_cast(ffi.typeof('void***'), VGUI_System010 )
local get_clipboard_text_count = ffi_cast( "get_clipboard_text_count", VGUI_System[ 0 ][ 7 ] ) or print( "get_clipboard_text_count Invalid")
local set_clipboard_text = ffi_cast( "set_clipboard_text", VGUI_System[ 0 ][ 9 ] ) or print( "set_clipboard_text Invalid")
local get_clipboard_text = ffi_cast( "get_clipboard_text", VGUI_System[ 0 ][ 11 ] ) or print( "get_clipboard_text Invalid")

local function clipboard_import( )
  	local clipboard_text_length = get_clipboard_text_count( VGUI_System )
	local clipboard_data = ""

	if clipboard_text_length > 0 then
		buffer = ffi.new("char[?]", clipboard_text_length)
		size = clipboard_text_length * ffi.sizeof("char[?]", clipboard_text_length)

		get_clipboard_text( VGUI_System, 0, buffer, size )

		clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
	end
	return clipboard_data
end

local function clipboard_export(string)
	if string then
		set_clipboard_text(VGUI_System, string, string:len())
	end
end

local mmenu = gradient_text(155,15,155,255,80,200,200,255,"[ALIVE]")


local var = {
	player_states = {"Standing", "Running", "Slowmotion", "Crouch", "Air Crouch", "Air"},
	state_to_idx = {["Standing"] = 1, ["Running"] = 2, ["Slowmotion"] = 3, ["Crouch"] = 4, ["Air Crouch"] = 5, ["Air"] = 6,},
}

local anti_aims = { }

anti_aims[0] = {
	player_state = ui.new_combobox("AA", "Anti-aimbot angles", mmenu..colorful_text:text({{1, 255, 143}, ' Player states'}), var.player_states),
}
for i=1,6 do
	anti_aims[i] = {
		pitch = ui.new_combobox("AA", "Anti-aimbot angles", "Pitch - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), { "Off", "Default", "Up", "Down", "Minimal", "Random" }),
		yawl = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Left - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), -180, 180, 0),
		yawr = ui.new_slider("AA", "Anti-aimbot angles", "Yaw Right - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), -180, 180, 0),
		yawjitter = ui.new_combobox("AA", "Anti-aimbot angles", "Jitter Mode - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), { "Off", "Offset", "Center", "Random" }),
		jitterslider = ui.new_slider("AA", "Anti-aimbot angles", "Jitter Offset - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), -180, 180, 0),
		cbyawmode = ui.new_combobox("AA", "Anti-aimbot angles", "Body Yaw Mode - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), { "Off", "Opposite", "Jitter", "Static" }),
		byawslider = ui.new_slider("AA", "Anti-aimbot angles", "Body yaw - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), -180, 180, 0),
		fakeyawlimit = ui.new_slider("AA", "Anti-aimbot angles", "Fake yaw limit - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), 0, 60, 60),
		roll = ui.new_slider("AA", "Anti-aimbot angles", "Roll - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}), -50, 50, 0),
		fsbyaw = ui.new_checkbox("AA", "Anti-aimbot angles", "Freestanding Body-yaw - "..colorful_text:text({{106, 183, 243}, var.player_states[i]})),
		abf = ui.new_checkbox("AA", "Anti-aimbot angles", "Anti-Bruteforce - "..colorful_text:text({{106, 183, 243}, var.player_states[i]}))
	}
end

local function buildermenu()
	var.active_i = var.state_to_idx[ui.get(anti_aims[0].player_state)]
	
	for i=1,6 do
		ui.set_visible(anti_aims[i].pitch,var.active_i == i)
		ui.set_visible(anti_aims[i].yawl,var.active_i == i)
		ui.set_visible(anti_aims[i].yawr,var.active_i == i)
		ui.set_visible(anti_aims[i].yawjitter,var.active_i == i)
		ui.set_visible(anti_aims[i].jitterslider,var.active_i == i)
		ui.set_visible(anti_aims[i].cbyawmode,var.active_i == i)
		ui.set_visible(anti_aims[i].byawslider,var.active_i == i)
		ui.set_visible(anti_aims[i].fakeyawlimit,var.active_i == i)
		ui.set_visible(anti_aims[i].roll, var.active_i == i)
		ui.set_visible(anti_aims[i].fsbyaw,var.active_i == i)
		ui.set_visible(anti_aims[i].abf,var.active_i == i)
	end
end

ui.set_callback(anti_aims[0].player_state, buildermenu)

buildermenu()

--manual bind system

local bind_system = {left = false, right = false, back = false,}
function bind_system:update()
	ui.set(manual_left_dir, "On hotkey")
	ui.set(manual_right_dir, "On hotkey")
	ui.set(manual_backward_dir, "On hotkey")
	local m_state = ui.get(manual_state)
	local left_state, right_state, backward_state = 
		ui.get(manual_left_dir), 
		ui.get(manual_right_dir),
		ui.get(manual_backward_dir)

	if left_state == self.left and 
		right_state == self.right and
		backward_state == self.back then
		return
	end

	self.left, self.right, self.back = 
		left_state, 
		right_state, 
		backward_state

	if (left_state and m_state == 1) or (right_state and m_state == 2) or (backward_state and m_state == 3) then
		ui.set(manual_state, 0)
		return
	end

	if left_state and m_state ~= 1 then
		ui.set(manual_state, 1)
	end

	if right_state and m_state ~= 2 then
		ui.set(manual_state, 2)
	end

	if backward_state and m_state ~= 3 then
		ui.set(manual_state, 3)	
	end
end

local menu_visibility = function(bool)
    ui.set_visible(manual_state, bool)
	ui.set_visible(aa.pitch, bool)
	ui.set_visible(aa.yawbase, bool)
	ui.set_visible(aa.yaw[1], bool)
	ui.set_visible(aa.yaw[2], bool)
	ui.set_visible(aa.fakeyawlimit, bool)
	ui.set_visible(aa.fsbodyyaw, bool)
	ui.set_visible(aa.edgeyaw, bool)
	ui.set_visible(aa.yawjitter[1], bool)
	ui.set_visible(aa.yawjitter[2], bool)
	ui.set_visible(aa.bodyyaw[1], bool)
	ui.set_visible(aa.bodyyaw[2], bool)
	ui.set_visible(aa.roll, bool)
end

client.set_event_callback("paint_ui", function(e)
	menu_visibility(false)
end)

client.set_event_callback('shutdown', function()
	menu_visibility(true)
end)

--epeek
client.set_event_callback("setup_command",function(e)
    local weaponn = entity.get_player_weapon()
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then
            if e.in_attack == 1 then
                e.in_attack = 0 
                e.in_use = 1
            end
        else
            if e.chokedcommands == 0 then
                e.in_use = 0
            end
        end
end)

local tankreversed = false
local tick_var = 0

local round = function(num, dec)
    local mult = 10^(dec or 0)
    return math.floor(num * mult + 0.5) / mult
end

local desync_side = 'None'
local desync = 0
local desync_amount = 0

client.set_event_callback("setup_command", function(e)
	local local_player = entity.get_local_player()
	if not entity.is_alive(local_player) then
		return
	end

	local vx, vy = entity.get_prop(local_player, "m_vecVelocity")
	local speed = math.floor(math.min(10000, math.sqrt(vx*vx + vy*vy) + 0.5))
	local onground = (bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1)
	local infiniteduck = (bit.band(entity.get_prop(local_player, "m_fFlags"), 2) == 2)
	local epeek = client.key_state(0x45)

    bind_system:update()

	if globals.tickcount() - tick_var > 0 and globals.chokedcommands() == 1 then
		tankreversed = not tankreversed
		tick_var = globals.tickcount()
	elseif globals.tickcount() - tick_var < -1 then
		tick_var = globals.tickcount()
	end

    local snum = 1
	--state_to_idx = {["STANDING"] = 1, ["RUNNING"] = 2, ["SLOWMOTION"] = 3, ["CROUCH"] = 4, ["AIR CROUCH"] = 5, ["AIR"] = 6,},

    if speed > 10 then
        snum = 2
    end
    if ui.get(aa.sw[1]) and ui.get(aa.sw[2]) then
        snum = 3
    end
    if onground and infiniteduck or onground and ui.get(aa.fakeduck) then
        snum = 4
    end
    if not onground or client.key_state(0x20) then
        snum = client.key_state(0x11) and 5 or 6
    end

	if e.chokedcommands == 0 then
        desync_side = (desync * (ui.get(aa.yaw[1]) == '180' and -1 or 1)) < 0 and 'Left' or 'Right'
        desync = entity.get_prop(local_player, 'm_flPoseParameter', 11) * 120 - 60
        desync_amount = clamp(math.abs(desync), 0, 57)
    end

	local yawref = desync_side == 'Right' and ui.get(anti_aims[snum].yawr) or ui.get(anti_aims[snum].yawl)
	local byawref = ui.get(anti_aims[snum].byawslider)

	-- Switch body yaw
	byawref = reversed and byawref * -1 or byawref
	byawref = ui.get(aa.yaw[1]) == 'Off' and byawref * -1 or byawref

    local byawmode = ui.get(anti_aims[snum].cbyawmode)
    local jittermode = ui.get(anti_aims[snum].yawjitter)
    local jitterref = ui.get(anti_aims[snum].jitterslider)
    local fyawref = ui.get(anti_aims[snum].fakeyawlimit)

	local msyaw = 0
	local mwork = ui.get(manual_state) ~= 0
	if mwork then
		msyaw = ui.get(manual_state) == 1 and -85 or ui.get(manual_state) == 2 and 87 or yawref
	end
    ui.set(aa.pitch,epeek and "Off" or ui.get(anti_aims[snum].pitch))
	ui.set(aa.yawbase,ui.get(manual_state) == 0 and "At targets" or "Local view")
	ui.set(aa.yaw[1],epeek and "Off" or "180")
	ui.set(aa.yaw[2],mwork and msyaw or yawref)
	ui.set(aa.yawjitter[1],jittermode)
	ui.set(aa.yawjitter[2],jitterref)
	ui.set(aa.bodyyaw[1],byawmode)
	ui.set(aa.bodyyaw[2],byawref)
	ui.set(aa.fakeyawlimit,fyawref)
	ui.set(aa.roll, ui.get(anti_aims[snum].roll))
	ui.set(aa.fsbodyyaw,ui.get(anti_aims[snum].fsbyaw))
end)

client.set_event_callback("paint", function()
	local local_player = entity.get_local_player()

	if not entity.is_alive(local_player) then
		return
	end
	
    local screen_x, screen_y = client.screen_size()
    local real_x, real_y = screen_x / 2, screen_y / 2

	local ir,ig,ib,ia = ui.get(ind_color)
    renderer.text(real_x, real_y + 30, ir,ig,ib,ia, 'c-', 0, "A L I V E")
    renderer.text(real_x, real_y + 40, 255, 255, 255, 255, 'c-', 0, (clamp(round(desync_amount/57*100), 0, 100)).."%")

    local formatted_text = colorful_text:text({{106, 183, 243}, '%s'}) .. colorful_text:text({{255, 255, 255}, '   -   '}) .. colorful_text:text({{106, 183, 243}, '%s'})
    renderer.text(real_x, screen_y - 10, ir,ig,ib,ia, 'c-', 0, (formatted_text:format(obex_data.username, obex_data.build)):upper())
end)

local function str_to_sub(input, sep)
	local t = {}
	for str in string_gmatch(input, "([^"..sep.."]+)") do
		t[#t + 1] = string_gsub(str, "\n", "")
	end
	return t
end
local function to_boolean(str)
	if str == "true" or str == "false" then
		return (str == "true")
	else
		return str
	end
end

local function export_cfg()
	local str = ""

	for i=1, 6 do
		str = str
		.. tostring(ui_get(anti_aims[i].pitch)) .. "|"
		.. tostring(ui_get(anti_aims[i].yawl)) .. "|"
		.. tostring(ui_get(anti_aims[i].yawr)) .. "|"
		.. tostring(ui_get(anti_aims[i].yawjitter)) .. "|"
		.. tostring(ui_get(anti_aims[i].jitterslider)) .. "|"
		.. tostring(ui_get(anti_aims[i].cbyawmode)) .. "|"
		.. tostring(ui_get(anti_aims[i].byawslider)) .. "|"
		.. tostring(ui_get(anti_aims[i].fakeyawlimit)) .. "|"
		.. tostring(ui_get(anti_aims[i].roll)) .. "|"
		.. tostring(ui_get(anti_aims[i].fsbyaw)) .. "|"
		.. tostring(ui_get(anti_aims[i].abf)) .. "|"
	end
	clipboard_export(str)
end

local function load_cfg(input)
	local tbl = str_to_sub(input, "|")
	for i=1, 6 do
		ui_set(anti_aims[i].pitch, tbl[1 + (11 * (i - 1))])
		ui_set(anti_aims[i].yawl, tonumber(tbl[2 + (11 * (i - 1))]))
		ui_set(anti_aims[i].yawr, tonumber(tbl[3 + (11 * (i - 1))]))
		ui_set(anti_aims[i].yawjitter, tbl[4 + (11 * (i - 1))])
		ui_set(anti_aims[i].jitterslider, tonumber(tbl[5 + (11 * (i - 1))]))
		ui_set(anti_aims[i].cbyawmode, tbl[6 + (11 * (i - 1))])
		ui_set(anti_aims[i].byawslider, tonumber(tbl[7 + (11 * (i - 1))]))
		ui_set(anti_aims[i].fakeyawlimit, tonumber(tbl[8 + (11 * (i - 1))]))
		ui_set(anti_aims[i].roll, to_boolean(tbl[9 + (11 * (i - 1))]))
		ui_set(anti_aims[i].fsbyaw, to_boolean(tbl[10 + (11 * (i - 1))]))
		ui_set(anti_aims[i].abf, to_boolean(tbl[11 + (11 * (i - 1))]))		
	end
end

local function import_cfg()
	local cfgtext = clipboard_import()
	load_cfg(cfgtext)
end

local exp = ui.new_button("AA", "Anti-aimbot angles", colorful_text:text({{106, 183, 243}, 'Export Config'}), export_cfg)
local imp = ui.new_button("AA", "Anti-aimbot angles", colorful_text:text({{106, 183, 243}, 'Import Config'}), import_cfg)