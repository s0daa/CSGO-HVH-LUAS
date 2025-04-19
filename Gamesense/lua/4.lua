local client_latency, client_set_clan_tag, client_log, client_timestamp, client_userid_to_entindex, client_trace_line, client_set_event_callback, client_screen_size, client_trace_bullet, client_color_log, client_system_time, client_delay_call, client_visible, client_exec, client_eye_position, client_set_cvar, client_scale_damage, client_draw_hitboxes, client_get_cvar, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.latency, client.set_clan_tag, client.log, client.timestamp, client.userid_to_entindex, client.trace_line, client.set_event_callback, client.screen_size, client.trace_bullet, client.color_log, client.system_time, client.delay_call, client.visible, client.exec, client.eye_position, client.set_cvar, client.scale_damage, client.draw_hitboxes, client.get_cvar, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float
local entity_get_player_resource, entity_get_local_player, entity_is_enemy, entity_get_bounding_box, entity_is_dormant, entity_get_steam64, entity_get_player_name, entity_hitbox_position, entity_get_game_rules, entity_get_all, entity_set_prop, entity_is_alive, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_get_classname = entity.get_player_resource, entity.get_local_player, entity.is_enemy, entity.get_bounding_box, entity.is_dormant, entity.get_steam64, entity.get_player_name, entity.hitbox_position, entity.get_game_rules, entity.get_all, entity.set_prop, entity.is_alive, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.get_classname
local globals_realtime, globals_absoluteframetime, globals_tickcount, globals_lastoutgoingcommand, globals_curtime, globals_mapname, globals_tickinterval, globals_framecount, globals_frametime, globals_maxplayers = globals.realtime, globals.absoluteframetime, globals.tickcount, globals.lastoutgoingcommand, globals.curtime, globals.mapname, globals.tickinterval, globals.framecount, globals.frametime, globals.maxplayers
local ui_new_slider, ui_new_combobox, ui_reference, ui_is_menu_open, ui_set_visible, ui_new_textbox, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.is_menu_open, ui.set_visible, ui.new_textbox, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get
local renderer_circle_outline, renderer_rectangle, renderer_gradient, renderer_circle, renderer_text, renderer_line, renderer_measure_text, renderer_indicator, renderer_world_to_screen = renderer.circle_outline, renderer.rectangle, renderer.gradient, renderer.circle, renderer.text, renderer.line, renderer.measure_text, renderer.indicator, renderer.world_to_screen
local math_ceil, math_tan, math_cos, math_sinh, math_pi, math_max, math_atan2, math_floor, math_sqrt, math_deg, math_atan, math_fmod, math_acos, math_pow, math_abs, math_min, math_sin, math_log, math_exp, math_cosh, math_asin, math_rad = math.ceil, math.tan, math.cos, math.sinh, math.pi, math.max, math.atan2, math.floor, math.sqrt, math.deg, math.atan, math.fmod, math.acos, math.pow, math.abs, math.min, math.sin, math.log, math.exp, math.cosh, math.asin, math.rad
local table_sort, table_remove, table_concat, table_insert = table.sort, table.remove, table.concat, table.insert
local find_material = materialsystem.find_material
local string_find, string_format, string_gsub, string_len, string_gmatch, string_match, string_reverse, string_upper, string_lower, string_sub = string.find, string.format, string.gsub, string.len, string.gmatch, string.match, string.reverse, string.upper, string.lower, string.sub
local ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error = ipairs, assert, pairs, next, tostring, tonumber, setmetatable, unpack, type, getmetatable, pcall, error

--[[
⣿⡇⣿⣿⣿⠛⠁⣴⣿⡿⠿⠧⠹⠿⠘⣿⣿⣿⡇⢸⡻⣿⣿⣿⣿⣿⣿⣿
⢹⡇⣿⣿⣿⠄⣞⣯⣷⣾⣿⣿⣧⡹⡆⡀⠉⢹⡌⠐⢿⣿⣿⣿⡞⣿⣿⣿
⣾⡇⣿⣿⡇⣾⣿⣿⣿⣿⣿⣿⣿⣿⣄⢻⣦⡀⠁⢸⡌⠻⣿⣿⣿⡽⣿⣿
⡇⣿⠹⣿⡇⡟⠛⣉⠁⠉⠉⠻⡿⣿⣿⣿⣿⣿⣦⣄⡉⠂⠈⠙⢿⣿⣝⣿
⠤⢿⡄⠹⣧⣷⣸⡇⠄⠄⠲⢰⣌⣾⣿⣿⣿⣿⣿⣿⣶⣤⣤⡀⠄⠈⠻⢮
⠄⢸⣧⠄⢘⢻⣿⡇⢀⣀⠄⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠄⢀
⠄⠈⣿⡆⢸⣿⣿⣿⣬⣭⣴⣿⣿⣿⣿⣿⣿⣿⣯⠝⠛⠛⠙⢿⡿⠃⠄⢸
⠄⠄⢿⣿⡀⣿⣿⣿⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⡾⠁⢠⡇⢀
⠄⠄⢸⣿⡇⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣏⣫⣻⡟⢀⠄⣿⣷⣾
⠄⠄⢸⣿⡇⠄⠈⠙⠿⣿⣿⣿⣮⣿⣿⣿⣿⣿⣿⣿⣿⡿⢠⠊⢀⡇⣿⣿
⠒⠤⠄⣿⡇⢀⡲⠄⠄⠈⠙⠻⢿⣿⣿⠿⠿⠟⠛⠋⠁⣰⠇⠄⢸⣿⣿⣿

    -- do not make shit
    -- Unfailer1337 2022/3/2 - 5.24
--]]


local lib = {
    ['gamesense/antiaim_funcs'] = 'https://gamesense.pub/forums/viewtopic.php?id=29665',
    ['gamesense/base64'] = 'https://gamesense.pub/forums/viewtopic.php?id=21619',
    ['gamesense/clipboard'] = 'https://gamesense.pub/forums/viewtopic.php?id=28678',
    ['gamesense/http'] = 'https://gamesense.pub/forums/viewtopic.php?id=19253',
    ['gamesense/surface'] = 'https://gamesense.pub/forums/viewtopic.php?id=18793',
    ['gamesense/easing'] = 'https://gamesense.pub/forums/viewtopic.php?id=22920'

}


local lib_notsub = { }

for i, v in pairs(lib) do
    if not pcall(require, i) then
        lib_notsub[#lib_notsub + 1] = lib[i]
    end
end

for i=1, #lib_notsub do
    error("pls sub the API \n" .. table.concat(lib_notsub, ", \n"))
end

local antiaim_funcs = require('gamesense/antiaim_funcs')
local base64 = require('gamesense/base64')
local clipboard = require('gamesense/clipboard')
local http = require('gamesense/http')
local easing = require "gamesense/easing"
local surface = require('gamesense/surface')
local ffi = require 'ffi'

local main = {}
local ui_main = {}
local visuals_main = {}

function main:callback(event_name,function_name,state)
    if state then
        client_set_event_callback(event_name,function_name)
    else
        client.unset_event_callback(event_name,function_name)
    end
    
end

main.vars = {
    screen = {client_screen_size()},
}

visuals_main.aspect_ratio = {}
visuals_main.aspect_ratio.vars = {
    multiplier = 0.01,
    steps = 200,

}


function visuals_main.aspect_ratio:set_aspect_ratio(aspect_ratio_multiplier)
    local screen_width, screen_height = client_screen_size()
	local aspectratio_value = (screen_width*aspect_ratio_multiplier)/screen_height

	if aspect_ratio_multiplier == 1 then
		aspectratio_value = 0
	end
	client_set_cvar("r_aspectratio", tonumber(aspectratio_value))
end

function visuals_main.aspect_ratio:gcd(m,n)
    while m ~= 0 do
		m, n = math_fmod(n, m), m
	end

	return n
end

local screen_width, screen_height, aspect_ratio_reference

function visuals_main.aspect_ratio:on_aspect_ratio_changed()
    local aspect_ratio = ui_get(ui_main.main_menu.aspect_ratio.aspect_ratio_reference)*0.01
	aspect_ratio = 2 - aspect_ratio
	visuals_main.aspect_ratio:set_aspect_ratio(aspect_ratio)
end
visuals_main.aspect_ratio.aspect_ratio_table = {}

function visuals_main.aspect_ratio:setup(screen_width_temp, screen_height_temp)
    screen_width, screen_height = screen_width_temp, screen_height_temp

	for i=1,  visuals_main.aspect_ratio.vars.steps do
		local i2=( visuals_main.aspect_ratio.vars.steps-i)* visuals_main.aspect_ratio.vars.multiplier
		local divisor =  visuals_main.aspect_ratio:gcd(screen_width*i2, screen_height)
		if screen_width*i2/divisor < 100 or i2 == 1 then
			visuals_main.aspect_ratio.aspect_ratio_table[i] = screen_width*i2/divisor .. ":" .. screen_height/divisor
		end
	end
end
visuals_main.aspect_ratio:setup(client_screen_size())

function visuals_main.aspect_ratio:on_paint()
    local screen_width_temp, screen_height_temp = client_screen_size()
	if screen_width_temp ~= screen_width or screen_height_temp ~= screen_height then
        
		visuals_main.aspect_ratio:setup(screen_width_temp, screen_height_temp)
	end
end

visuals_main.aimlog = {}
visuals_main.cl_color = {}
visuals_main.cl_color.vars = {}
visuals_main.cl_color.vars.materials = { 'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4' }
visuals_main.cl_color.vars.engine_client = ffi.cast(ffi.typeof('void***'), client.create_interface('engine.dll', 'VEngineClient014'))
visuals_main.cl_color.vars.console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), visuals_main.cl_color.vars.engine_client[0][11])
function visuals_main.cl_color:paint_ui()
    local r, g, b, a = ui.get(ui_main.main_menu.cl_color.recolor_console)

    if not self.vars.console_is_visible(self.vars.engine_client) then
        r, g, b, a = 255, 255, 255, 255
    end

    for _, mat in pairs(self.vars.materials) do
        find_material(mat):alpha_modulate(a)
        find_material(mat):color_modulate(r, g, b)
    end
end

visuals_main.scope_adjusments = {}

visuals_main.scope_adjusments.vars = {}
visuals_main.scope_adjusments.vars.m_alpha = 0
visuals_main.scope_adjusments.vars.scope_overlay = ui_reference('VISUALS', 'Effects', 'Remove scope overlay')
visuals_main.scope_adjusments.vars.clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

function visuals_main.scope_adjusments:ui()
    ui_set(self.vars.scope_overlay, true)

end
function visuals_main.scope_adjusments:on_paint()
    ui_set(self.vars.scope_overlay, false)

	local width, height = client_screen_size()
	local offset, initial_position, speed, color =
		ui_get(ui_main.main_menu.scope_adjusments.overlay_offset) * height / 1080, 
		ui_get(ui_main.main_menu.scope_adjusments.overlay_position) * height / 1080, 
		ui_get(ui_main.main_menu.scope_adjusments.fade_time), { ui_get(ui_main.main_menu.scope_adjusments.color_picker) }

	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals_frametime() * speed or 1
	local alpha = easing.linear(self.vars.m_alpha, 0, 1, 1)

	renderer_gradient(width/2 - initial_position, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer_gradient(width / 2, height/2 - initial_position, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	self.vars.m_alpha = self.vars.clamp(self.vars.m_alpha + (act and FT or -FT), 0, 1)
end

visuals_main.scope_zoom_overrde = {}
visuals_main.scope_zoom_overrde.vars = {}
visuals_main.scope_zoom_overrde.vars.override_zoom_fov = ui.reference('MISC', 'Miscellaneous', 'Override zoom FOV')
function visuals_main.scope_zoom_overrde:on_paint()
    local ent = entity.get_local_player()
    local weapon = entity.get_player_weapon(ent)
    local prop = entity.get_prop(weapon, 'm_zoomLevel')

    if prop == nil or prop == 0 then
        ui.set(self.vars.override_zoom_fov, 0)
        return
    end

    if prop == 1 then
        ui.set(self.vars.override_zoom_fov, 0)
    elseif prop == 2 then
        ui.set(self.vars.override_zoom_fov, ui.get(ui_main.main_menu.scope_zoom_override.override_zoom_fov_slider))
    end
end
visuals_main.damage_indicator = {}
visuals_main.damage_indicator.vars = {}
visuals_main.damage_indicator.vars.flag = {
    normal = "c"
}

visuals_main.damage_indicator.vars.display_duration = 2
visuals_main.damage_indicator.vars.speed = 1

visuals_main.damage_indicator.vars.damage_indicator_displays = {}
visuals_main.damage_indicator.vars.minimum_damage_reference = ui.reference("RAGE", "Aimbot", "Minimum damage")
visuals_main.damage_indicator.vars.aimbot_enabled_reference = ui.reference("RAGE", "Aimbot", "Enabled")
 
function visuals_main.damage_indicator:on_paint()
    if not ui_get(ui_main.main_menu.damage_indicator.enabled_reference) then
		return
	end
 
	local damage_indicator_displays_new = {}
	local max_time_delta = ui_get(ui_main.main_menu.damage_indicator.duration_reference) / 2
	local speed = ui_get(ui_main.main_menu.damage_indicator.speed_reference) / 3
	local realtime = globals_realtime()
	local max_time = realtime - max_time_delta / 2
	local aimbot_enabled = ui_get(self.vars.aimbot_enabled_reference)
	local minimum_damage = 0
	if aimbot_enabled then
		minimum_damage = ui_get(self.vars.minimum_damage_reference)
	end
 
	for i=1, #self.vars.damage_indicator_displays do
		local damage_indicator_display = self.vars.damage_indicator_displays[i]
		local damage, time, x, y, z, e = damage_indicator_display[1], damage_indicator_display[2], damage_indicator_display[3], damage_indicator_display[4], damage_indicator_display[5], damage_indicator_display[6]
		local r, g, b, a = 0, 255, 150, 255
		if time > max_time then
			local sx, sy = renderer_world_to_screen( x, y, z)
 
			if e.hitgroup == 1 then
				r, g, b = 255, 0, 0
			end
			if damage < minimum_damage and e.health ~= 0 then
				r, g, b = 255, 0, 0
			end
 
			if (time - max_time) < 0.7 then
				a = (time - max_time) / 0.7 * 255
			end
 
			if not (sx == nil or sy == nil) then
                if ui_get(ui_main.main_menu.damage_indicator.flag_reference) == "bold" then
                    if e.hitgroup == 1 then
                        renderer_text( sx, sy, r, g, b, a, "cb", 0, "HEAD SHOT")
                    else
                        renderer_text( sx, sy, r, g, b, a, "cb", 0, damage)
                    end



                elseif ui_get(ui_main.main_menu.damage_indicator.flag_reference) == "big" then
                    if e.hitgroup == 1 then
                        renderer_text( sx, sy, r, g, b, a, "c+", 0, "HEAD SHOT")
                    else
                        renderer_text( sx, sy, r, g, b, a, "c+", 0, damage)
                    end
                elseif ui_get(ui_main.main_menu.damage_indicator.flag_reference) == "normal" then
                    if e.hitgroup == 1 then
                        renderer_text( sx, sy, r, g, b, a, "c", 0, "HEAD SHOT")
                    else
                        renderer_text( sx, sy, r, g, b, a, "c", 0, damage)
                    end               
                 end
                

			end
			table_insert(damage_indicator_displays_new, {damage, time, x, y, z+0.4*speed, e})
		end
	end
 
	self.vars.damage_indicator_displays = damage_indicator_displays_new
end

visuals_main.bullet_tracers = {}
visuals_main.bullet_tracers.vars = {}
visuals_main.bullet_tracers.vars.queue = {}

function visuals_main.bullet_tracers:on_paint()
    if not ui.get(ui_main.main_menu.bullet_tracers.tracer) then
        return
    end
    local r, g, b = ui.get(ui_main.main_menu.bullet_tracers.color)

    for tick, data in pairs(self.vars.queue) do
        -- Screen positions
        local sx1, sy1  = renderer_world_to_screen(data.x, data.y, data.z)
        if not sx1 then
            sx1 = data.last_impact_x
            sy2 = data.last_impact_y
        end
        local sx2, sy2  = renderer_world_to_screen(data.lx, data.ly, data.lz)
        if not sx2 then
            sx2 = data.last_origin_x
            sy2 = data.last_origin_y
        end
        -- Visibility check
        local visible   = sx1 ~= nil and sx2 ~= nil
        -- Save shot locations
        data.last_impact_x = sx1
        data.last_impact_y = sy1
        data.last_origin_x = sx2
        data.last_origin_y = sy2
        -- Drawing
        if data.draw and visible then
            if globals_curtime() >= data.duration then
                data.alpha = data.alpha - 1
            end
            if data.alpha <= 0 then
                data.draw = false
            end
            renderer_line(sx1, sy1, sx2, sy2, r, g, b, data.alpha)
        end
    end
    -- for tick, data in pairs(self.vars.queue) do
    --     if globals.curtime() <= data[7] then
    --         local x1, y1 = renderer.world_to_screen(data[1], data[2], data[3])
    --         local x2, y2 = renderer.world_to_screen(data[4], data[5], data[6])
    --         if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
    --             renderer.line(x1, y1, x2, y2, ui.get(ui_main.main_menu.bullet_tracers.color))
    --         end
    --     end
    -- end
end

visuals_main._hitmarker = {}
visuals_main._hitmarker.vars = {}
visuals_main._hitmarker.vars.dt = {}
visuals_main._hitmarker.vars.list = { "Default", "Ratio", "Circle", "Circle Outline", "Cross", }
visuals_main._hitmarker.vars.listvars = {
    hitmarkenable, hitmarkcombo, r, g, b, a, hitmarktime, hitmarksize, hitmarkthicc
}

function visuals_main._hitmarker:on_paint()
    if self.vars.listvars.hitmarkenable then	
		if self.vars.listvars.hitmarkcombo == "Circle" or self.vars.listvars.hitmarkcombo == "Default" then
			ui_set_visible(ui_main.main_menu._hitmarker.hitmark_thicc, false)
		else
			ui_set_visible(ui_main.main_menu._hitmarker.hitmark_thicc, self.vars.listvars.hitmarkenable)
		end
		if #self.vars.dt ~= 0 then
			for i = 1, #self.vars.dt do
				if self.vars.dt[i] ~= nil then
					if client_timestamp() - self.vars.dt[i][4] > ui_get( ui_main.main_menu._hitmarker.hitmark_time) then
						table_remove(self.vars.dt, i)
						i = i - 1
					end
				end
			end
			for i = 1, #self.vars.dt do
				local x, y, z, time = self.vars.dt[i][1], self.vars.dt[i][2], self.vars.dt[i][3], self.vars.dt[i][4]
				local sx, sy = renderer_world_to_screen(x, y, z)
				if sx ~= nil and sy ~= nil then
					if  self.vars.listvars.hitmarkcombo == "Default" then
						local f1, f2 = 2, self.vars.listvars.hitmarksize
						renderer.line(sx+f1, sy-f1, sx+f2, sy-f2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--1
						renderer.line(sx-f1, sy-f1, sx-f2, sy-f2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--2
						renderer.line(sx-f1, sy+f1, sx-f2, sy+f2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--3
						renderer.line(sx+f1, sy+f1, sx+f2, sy+f2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--4
					end
					if  self.vars.listvars.hitmarkcombo == "Ratio" then
						for j=1, 4 do
							renderer_circle(sx, sy,  self.vars.listvars.self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a, self.vars.listvars.hitmarksize, (j*90)+43, self.vars.listvars.hitmarkthicc / 100)
						end
					end
					if  self.vars.listvars.hitmarkcombo == "Circle" then
						renderer_circle(sx, sy, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a, self.vars.listvars.hitmarksize, 0, 1)
					end
					if  self.vars.listvars.hitmarkcombo == "Circle Outline" then
						renderer_circle_outline(sx, sy, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a, self.vars.listvars.hitmarksize, 0, 1, self.vars.listvars.hitmarkthicc)
					end
					if  self.vars.listvars.hitmarkcombo == "Cross" then
						renderer_rectangle(sx-self.vars.listvars.hitmarkthicc, sy-self.vars.listvars.hitmarksize, self.vars.listvars.hitmarkthicc*2, self.vars.listvars.hitmarksize*2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--  |
						renderer_rectangle(sx-self.vars.listvars.hitmarksize, sy-self.vars.listvars.hitmarkthicc, self.vars.listvars.hitmarksize*2, self.vars.listvars.hitmarkthicc*2, self.vars.listvars.r, self.vars.listvars.g, self.vars.listvars.b, self.vars.listvars.a)--  -
					end
				end
			end
		end
	end
end

visuals_main.antiknife = {}
function visuals_main.antiknife:get_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)

end

function visuals_main.antiknife:on_run_command()
    local players = entity.get_players(true)
    local lx, ly, lz = entity.get_prop(entity.get_local_player(), "m_vecOrigin")
	local yaw, yaw_slider = ui.reference("AA", "Anti-aimbot angles", "Yaw")
    for i=1, #players do
        local x, y, z = entity.get_prop(players[i], "m_vecOrigin")
        local distance = self:get_distance(lx, ly, lz, x, y, z)
        local weapon = entity.get_player_weapon(players[i])
        if entity.get_classname(weapon) == "CKnife" and distance <= 280 then
            ui.set(yaw_slider,180)
        end
    end
end


ui_main.menu_tab = {
    "Aspect ratio","Aim log","Console color","Scope adjusments","Scope zoom override","Damage indicator","Bullet tracer","Hit marker","Anti knife"
}
ui_main.main_menu = {}

ui_main.main_menu.main_tab = {
    master_switch = ui_new_checkbox("LUA","B","Enable Unfailer adaptive visuals"),
    _label = ui.new_label("LUA","B","----------------------------------------------"),
    master_select = ui_new_combobox("LUA","B","Select settings",ui_main.menu_tab)
}
ui_main.main_menu.aspect_ratio = {
    aspect_ratio_reference = ui_new_slider("LUA","B","Aspect ratio",0, visuals_main.aspect_ratio.vars.steps-1, visuals_main.aspect_ratio.vars.steps/2, true, "%", 1, visuals_main.aspect_ratio.aspect_ratio_table)
}

ui_main.main_menu.aimlog = {
    aimlog_enable = ui_new_checkbox("LUA","B","Aim log"),
    on_fire_enable = ui_new_checkbox("LUA","B", "Fire log color"),
    on_fire_colour = ui_new_color_picker("LUA","B", "Fire color", 147, 112, 219, 255),
    on_miss_enable = ui_new_checkbox("LUA","B", "Miss color"),
    on_miss_colour = ui_new_color_picker("LUA","B", "Miss color", 255, 253, 166, 255),
    on_damage_enable = ui_new_checkbox("LUA","B", "Damage color"),
    on_damage_colour = ui_new_color_picker("LUA","B", "Damage color", 100, 149, 237, 255),
}

ui_main.main_menu.cl_color = {
    vgui_label = ui.new_label("LUA","B",'VGUI Color'),
    recolor_console = ui.new_color_picker("LUA","B", 'VGUI Color picker', 81, 81, 81, 210)

}

ui_main.main_menu.scope_adjusments = {
     master_switch = ui_new_checkbox("LUA","B", 'Custom scope lines'),
     color_picker = ui_new_color_picker("LUA","B", '\n scope_lines_color_picker', 0, 0, 0, 255),
     overlay_position = ui_new_slider("LUA","B", '\n scope_lines_initial_pos', 0, 500, 190),
     overlay_offset = ui_new_slider("LUA","B", '\n scope_lines_offset', 0, 500, 15),
     fade_time = ui_new_slider("LUA","B", 'Fade animation speed', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' }),
}

ui_main.main_menu.scope_zoom_override = {
    override_zoom_fov_slider = ui_new_slider("LUA","B", 'Override zoom FOV on second scope', 0, 100, 0, true, '%', 1)

}

ui_main.main_menu.damage_indicator = {
    enabled_reference = ui.new_checkbox("LUA","B",  "Damage Indicator"),
    flag_reference = ui_new_combobox("LUA","B","Display flag","bold","big","normal"),
    duration_reference = ui.new_slider("LUA","B",  "Display Duration", 1, 10, 4),
    speed_reference = ui.new_slider("LUA","B",  "Speed", 1, 8, 2),
}

ui_main.main_menu.bullet_tracers = {
    tracer = ui.new_checkbox("LUA","B",   "Bullet tracers redux"),
    color = ui.new_color_picker("LUA","B",   "Color", 255, 255, 255, 255),
}

ui_main.main_menu._hitmarker = {
    hitmark_enable = ui_new_checkbox("LUA","B", "World Hitmarker"),
    hitmark_combo = ui_new_combobox("LUA","B", "World Hitmarker Style",visuals_main._hitmarker.vars.list),
    hitmark_color = ui_new_color_picker("LUA","B", "World Hitmarker Color", 0, 25, 255, 255),
    hitmark_time = ui_new_slider("LUA","B", "World Hitmarker Time", 0, 5000, 850, true, "ms"),
    hitmark_legnth = ui_new_slider("LUA","B", "Hitmarker Size", 0, 15, 9, true, ""),
    hitmark_thicc = ui_new_slider("LUA","B", "Hitmarker Thiccness", 0, 10, 2, true, "")
}

ui_main.main_menu.antiknife = {
    anti_media = ui_new_checkbox("LUA","B", "Anti-knife"),

}
local label_2 = ui.new_label("LUA","B","----------------------------------------------")

local function on_aim_fire(e)
    self = main or self
    if ui_get(ui_main.main_menu.aimlog.aimlog_enable) and ui_get(ui_main.main_menu.aimlog.on_fire_enable) and e ~= nil then
    	local r, g, b = ui_get(ui_main.main_menu.aimlog.on_fire_colour)
        local hitgroup_names = { "身体", "头", "胸", "胃", "左胳膊", "右胳膊", "左腿", "右腿", "脖子", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local tickrate = client.get_cvar("cl_cmdrate") or 64
        local target_name = entity_get_player_name(e.target)
        local ticks = math.floor((e.backtrack * tickrate) + 0.5)

        client_color_log(r, g, b,
        "[Kayo] 击中了 ", string.lower(target_name),
        ", 击中部位: ", group,
        "  伤害: ", e.damage,
        "  命中率: ", string.format("%d", e.hit_chance),
        "  回溯: ", e.backtrack, " (", ticks, " tks)",
        "  伤害: ", e.high_priority)
    end
end

local function on_player_hurt(e)
    self = main or self
    if ui_get(ui_main.main_menu.aimlog.aimlog_enable) and ui_get(ui_main.main_menu.aimlog.on_damage_enable) then
        local attacker_id = client_userid_to_entindex(e.attacker)
        if attacker_id == nil then
            return
        end
    
        if attacker_id ~= entity_get_local_player() then
            return
        end
    
        local hitgroup_names = { "身体", "头部", "胸部", "胃部", "左臂", "右肩", "左腿", "右腿", "脖子", "?"}
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_id = client_userid_to_entindex(e.userid)
        local target_name = entity_get_player_name(target_id)
        local enemy_health = entity_get_prop(target_id, "m_iHealth")
        local rem_health = enemy_health - e.dmg_health
        if rem_health <= 0 then
            rem_health = 0
        end
    
        local message = "[Afeera] 击中 " .. string.lower(target_name) .. ", 命中部位: " .. group .. "  伤害: " .. e.dmg_health .. "  剩余血量: " .. rem_health
        if rem_health <= 0 then
            message = message .. " (死)"
        end
    
        
        local r, g, b = ui_get(ui_main.main_menu.aimlog.on_damage_colour)
        client_color_log(r, g, b, message) 
    end
    if not ui_get(ui_main.main_menu.damage_indicator.enabled_reference) then
		return
	end
	--local userid, attacker, health, armor, weapon, damage, dmg_armor, hitgroup = e.userid, e.attacker, e.health, e.armor, e.weapon, e.dmg_damage, e.dmg_armor, e.hitgroup
	local userid, attacker, damage, health = e.userid, e.attacker, e.dmg_health, e.health
	if userid == nil or attacker == nil or damage == nil then
		return
	end
 
	local player = client.userid_to_entindex(userid)
	local x, y, z = entity_get_prop(player, "m_vecOrigin")
	if x == nil or y == nil or z == nil then
		return
	end
	local voZ = entity_get_prop(player, "m_vecViewOffset[2]")
 
	table_insert(visuals_main.damage_indicator.vars.damage_indicator_displays, {damage, globals_realtime(), x, y, z + voZ, e})
end

local function on_aim_miss(e)
    self = main or self
    if ui_get(ui_main.main_menu.aimlog.aimlog_enable) and ui_get(ui_main.main_menu.aimlog.on_miss_enable) and e ~= nil then
        local r, g, b = ui_get(ui_main.main_menu.aimlog.on_miss_colour)
        local hitgroup_names = { "身体", "头部", "胸部", "胃部", "左臂", "右肩", "左腿", "右腿", "脖子", "?" }
        local group = hitgroup_names[e.hitgroup + 1] or "?"
        local target_name = entity_get_player_name(e.target)
        local reason
        if e.reason == "?" then
            reason = "resolver"
        else
            reason = e.reason
        end
    
            client_color_log(r, g, b,
            "[Afeera] 空了 ", string.lower(target_name),
            ", 击中部位: ", group,
            "  操作原因: ", reason)
        end
end

local function bullet_impact(e)
    self = main or self
    if ui_get(ui_main.main_menu._hitmarker.hitmark_enable) then
		if client_userid_to_entindex(e.userid) == entity_get_local_player() then
			table_insert(visuals_main._hitmarker.vars.dt, {e.x, e.y, e.z, client_timestamp()})
		end
	end
    if not ui.get(ui_main.main_menu.bullet_tracers.tracer) then
        return
    end
    if client.userid_to_entindex(e.userid) ~= entity.get_local_player() then
        return
    end
    local lx, ly, lz = client_eye_position()
    visuals_main.bullet_tracers.vars.queue[globals_tickcount()] = {
        x           = e.x,
        y           = e.y,
        z           = e.z,
        lx          = lx,
        ly          = ly,
        lz          = lz,
        draw        = true,
        alpha       = 255,
        duration    = globals_curtime() + 1.5
    }


end

function main:paint_ui()
    visuals_main.scope_adjusments:ui()

end

function main:round_prestart()
    if not ui.get(ui_main.main_menu.bullet_tracers.tracer) then
        return
    end
    visuals_main.bullet_tracers.vars.queue = {}
end

function main:runcommand()
    visuals_main.antiknife:on_run_command()
end

function main:paint()
    visuals_main.aspect_ratio:on_paint()
    visuals_main.cl_color:paint_ui()
    visuals_main.scope_adjusments:on_paint()
    visuals_main.scope_zoom_overrde:on_paint()
    visuals_main.damage_indicator:on_paint()
    visuals_main.bullet_tracers:on_paint()
    visuals_main._hitmarker:on_paint()

end


function main:init_menu()
    local enable = ui_get(ui_main.main_menu.main_tab.master_switch)
    ui_set_visible(ui_main.main_menu.main_tab.master_select,enable)
    ui_set_visible(ui_main.main_menu.main_tab._label,  enable)
    ui_set_visible(label_2, enable)

    for k, v in pairs(ui_main.main_menu.aspect_ratio) do
        ui_set_visible(v,enable)
    end

    local select = ui_get(ui_main.main_menu.main_tab.master_select)
  
    ui_set_visible(ui_main.main_menu.aspect_ratio.aspect_ratio_reference,select == "Aspect ratio" and enable)
    ui_set_visible(ui_main.main_menu.aimlog.aimlog_enable,select == "Aim log" and enable)

    ui_set_visible(ui_main.main_menu.aimlog.on_fire_enable,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)
    ui_set_visible(ui_main.main_menu.aimlog.on_fire_colour,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)
    ui_set_visible(ui_main.main_menu.aimlog.on_miss_enable,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)
    ui_set_visible(ui_main.main_menu.aimlog.on_miss_colour,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)
    ui_set_visible(ui_main.main_menu.aimlog.on_damage_enable,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)
    ui_set_visible(ui_main.main_menu.aimlog.on_damage_colour,select == "Aim log" and ui_get(ui_main.main_menu.aimlog.aimlog_enable) and enable)

    ui_set_visible(ui_main.main_menu.cl_color.recolor_console,select == "Console color" and enable)
    ui_set_visible(ui_main.main_menu.cl_color.vgui_label,select == "Console color" and enable)

    ui_set_visible(ui_main.main_menu.scope_adjusments.master_switch,select == "Scope adjusments" and enable)
    ui_set_visible(ui_main.main_menu.scope_adjusments.color_picker,select == "Scope adjusments" and ui_get(ui_main.main_menu.scope_adjusments.master_switch) and enable)
    ui_set_visible(ui_main.main_menu.scope_adjusments.overlay_position,select == "Scope adjusments" and ui_get(ui_main.main_menu.scope_adjusments.master_switch) and enable)
    ui_set_visible(ui_main.main_menu.scope_adjusments.overlay_offset,select == "Scope adjusments" and ui_get(ui_main.main_menu.scope_adjusments.master_switch) and enable)
    ui_set_visible(ui_main.main_menu.scope_adjusments.fade_time,select == "Scope adjusments" and ui_get(ui_main.main_menu.scope_adjusments.master_switch) and enable)

    ui_set_visible(ui_main.main_menu.scope_zoom_override.override_zoom_fov_slider,select == "Scope zoom override"  and enable)

    ui_set_visible(ui_main.main_menu.damage_indicator.enabled_reference,select == "Damage indicator"  and enable)
    ui_set_visible(ui_main.main_menu.damage_indicator.flag_reference,select == "Damage indicator" and ui_get(ui_main.main_menu.damage_indicator.enabled_reference) and enable)

    ui_set_visible(ui_main.main_menu.damage_indicator.duration_reference,select == "Damage indicator" and ui_get(ui_main.main_menu.damage_indicator.enabled_reference) and enable)
    ui_set_visible(ui_main.main_menu.damage_indicator.speed_reference,select == "Damage indicator"  and ui_get(ui_main.main_menu.damage_indicator.enabled_reference) and enable)

    ui_set_visible(ui_main.main_menu.bullet_tracers.tracer,select == "Bullet tracer"  and enable)
    ui_set_visible(ui_main.main_menu.bullet_tracers.color,select == "Bullet tracer"  and enable)

    visuals_main._hitmarker.vars.listvars.hitmarkenable = ui_get(ui_main.main_menu._hitmarker.hitmark_enable)
	visuals_main._hitmarker.vars.listvars.hitmarkcombo = ui_get(ui_main.main_menu._hitmarker.hitmark_combo)
	visuals_main._hitmarker.vars.listvars.r, visuals_main._hitmarker.vars.listvars.g, visuals_main._hitmarker.vars.listvars.b, visuals_main._hitmarker.vars.listvars.a = ui_get(ui_main.main_menu._hitmarker.hitmark_color)
	visuals_main._hitmarker.vars.listvars.hitmarktime = ui_get(ui_main.main_menu._hitmarker.hitmark_time)
	visuals_main._hitmarker.vars.listvars.hitmarksize = ui_get(ui_main.main_menu._hitmarker.hitmark_legnth)
	visuals_main._hitmarker.vars.listvars.hitmarkthicc = ui_get(ui_main.main_menu._hitmarker.hitmark_thicc)
    ui_set_visible(ui_main.main_menu._hitmarker.hitmark_enable, select == "Hit marker" and enable)

	ui_set_visible(ui_main.main_menu._hitmarker.hitmark_color,  select == "Hit marker" and  visuals_main._hitmarker.vars.listvars.hitmarkenable and enable)
	ui_set_visible(ui_main.main_menu._hitmarker.hitmark_time,select == "Hit marker" and  visuals_main._hitmarker.vars.listvars.hitmarkenable and enable)
	ui_set_visible(ui_main.main_menu._hitmarker.hitmark_legnth,select == "Hit marker" and  visuals_main._hitmarker.vars.listvars.hitmarkenable and enable)
	ui_set_visible(ui_main.main_menu._hitmarker.hitmark_thicc, select == "Hit marker" and  visuals_main._hitmarker.vars.listvars.hitmarkenable and enable)
	ui_set_visible(ui_main.main_menu._hitmarker.hitmark_combo, select == "Hit marker" and  visuals_main._hitmarker.vars.listvars.hitmarkenable and enable)

    ui_set_visible(ui_main.main_menu.antiknife.anti_media, select == "Anti knife" and enable)

    main:callback('run_command',main.runcommand,enable)
    main:callback("round_start", main.round_prestart,enable)
    main:callback('bullet_impact',bullet_impact,enable)
    main:callback('paint',main.paint,enable)
    main:callback("paint_ui",main.paint_ui,enable)
    main:callback("aim_fire",on_aim_fire,enable)
    main:callback("player_hurt",on_player_hurt,enable)
    main:callback("aim_miss",on_aim_miss,enable)

end

main:init_menu()

function main:handle_all_callbacks()

    for k, v in pairs(ui_main.main_menu.main_tab) do
        ui_set_callback(v,self.init_menu)
    end
    ui_set_callback(label_2,self.init_menu)
    
    for k, v in pairs(ui_main.main_menu.aspect_ratio) do
        ui_set_callback(v,self.init_menu)
    end
    ui_set_callback(ui_main.main_menu.aspect_ratio.aspect_ratio_reference, visuals_main.aspect_ratio.on_aspect_ratio_changed)

    for k, v in pairs(ui_main.main_menu.aimlog) do
        ui_set_callback(v,self.init_menu)
    end

    for k, v in pairs(ui_main.main_menu.cl_color) do
        ui_set_callback(v,self.init_menu)
    end

    for k, v in pairs(ui_main.main_menu.scope_adjusments) do
        ui_set_callback(v,self.init_menu)
    end

    for k, v in pairs(ui_main.main_menu.damage_indicator) do
        ui_set_callback(v,self.init_menu)
    end

    for k, v in pairs(ui_main.main_menu.bullet_tracers) do
        ui_set_callback(v,self.init_menu)
    end

    for k, v in pairs(ui_main.main_menu._hitmarker) do
        ui_set_callback(v,self.init_menu)
    end
end

main:handle_all_callbacks()