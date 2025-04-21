-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_screen_size, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, globals_frametime, renderer_gradient, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.screen_size, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, globals.frametime, renderer.gradient, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible
local clamp = function(v, min, max) local num = v; num = num < min and min or num; num = num > max and max or num; return num end

local easing = require "gamesense/easing"
local m_alpha = 0

local scope_overlay = ui_reference('VISUALS', 'Effects', 'Remove scope overlay')
local master_switch = ui_new_checkbox('Visuals', 'Effects', 'Custom scope lines')
local color_picker = ui_new_color_picker('Visuals', 'Effects', '\n scope_lines_color_picker', 0, 0, 0, 255)
local overlay_position = ui_new_slider('Visuals', 'Effects', '\n scope_lines_initial_pos', 0, 500, 190)
local overlay_offset = ui_new_slider('Visuals', 'Effects', '\n scope_lines_offset', 0, 500, 15)
local fade_time = ui_new_slider('Visuals', 'Effects', 'Fade animation speed', 3, 20, 12, true, 'fr', 1, { [3] = 'Off' })

local g_paint_ui = function()
	ui_set(scope_overlay, true)
end

local g_paint = function()
	ui_set(scope_overlay, false)

	local width, height = client_screen_size()
	local offset, initial_position, speed, color =
		ui_get(overlay_offset) * height / 1080, 
		ui_get(overlay_position) * height / 1080, 
		ui_get(fade_time), { ui_get(color_picker) }

	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil
	local act = is_valid and scope_level > 0 and scoped and not resume_zoom

	local FT = speed > 3 and globals_frametime() * speed or 1
	local alpha = easing.linear(m_alpha, 0, 1, 1)

	renderer_gradient(width/2 - initial_position + 2, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], true)
	renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer_gradient(width / 2, height/2 - initial_position + 2, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], alpha*color[4], false)
	renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], alpha*color[4], color[1], color[2], color[3], 0, false)
	
	m_alpha = clamp(m_alpha + (act and FT or -FT), 0, 1)
end

local ui_callback = function(c)
	local master_switch, addr = ui_get(c), ''

	if not master_switch then
		m_alpha, addr = 0, 'un'
	end
	
	local _func = client[addr .. 'set_event_callback']

	ui_set_visible(scope_overlay, not master_switch)
	ui_set_visible(overlay_position, master_switch)
	ui_set_visible(overlay_offset, master_switch)
	ui_set_visible(fade_time, master_switch)

	_func('paint_ui', g_paint_ui)
	_func('paint', g_paint)
end

ui_set_callback(master_switch, ui_callback)
ui_callback(master_switch)