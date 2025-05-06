local ui_get, ui_set = ui.get, ui.set
local entity_get_local_player = entity.get_local_player
local entity_get_player_weapon = entity.get_player_weapon
local entity_get_prop = entity.get_prop
local entity_is_alive = entity.is_alive

local globals_frametime = globals.frametime
local client_screen_size = client.screen_size
local renderer_gradient = renderer.gradient

local global_alpha = 0
local clamp = function(v, min, max)
	local num = v

	num = num < min and min or num
	num = num > max and max or num

	return num
end

local scope_overlay = ui.reference('VISUALS', 'Effects', 'Remove scope overlay')
local master_switch = ui.new_checkbox('Visuals', 'Effects', 'Custom scope lines')
local color_picker = ui.new_color_picker('Visuals', 'Effects', '\n scope_lines_color_picker', 0, 0, 0, 255) --[[ 3D55D6FF / 9BABFDFF ]]

local overlay_position = ui.new_slider('Visuals', 'Effects', '\n scope_lines_initial_pos', 0, 500, 250)
local overlay_offset = ui.new_slider('Visuals', 'Effects', '\n scope_lines_offset', 0, 500, 15)

local fade_time = ui.new_slider('Visuals', 'Effects', 'Fade animation speed', 4, 20, 12, true, 'fr', 1, { [4] = 'Off' })

local g_paint_ui = function()
	ui_set(scope_overlay, true)
end

local g_paint = function()
	local offset, initial_position, fade_time, color =
		ui_get(overlay_offset), ui_get(overlay_position),
		ui_get(fade_time), { ui_get(color_picker) }

	local FT = fade_time > 4 and (globals_frametime()*fade_time) or 1
	local width, height = client_screen_size()

	-- DO STUFF
	local me = entity_get_local_player()
	local wpn = entity_get_player_weapon(me)

	local scope_level = entity_get_prop(wpn, 'm_zoomLevel')
	local scoped = entity_get_prop(me, 'm_bIsScoped') == 1
	local resume_zoom = entity_get_prop(me, 'm_bResumeZoom') == 1

	local is_valid = entity_is_alive(me) and wpn ~= nil and scope_level ~= nil

	if is_valid and scope_level > 0 and scoped and not resume_zoom then
		global_alpha = clamp(global_alpha+FT, 0, 1)
	else
		global_alpha = clamp(global_alpha-FT, 0, 1)
	end

	renderer_gradient(width/2 - initial_position, height / 2, initial_position - offset, 1, color[1], color[2], color[3], 0, color[1], color[2], color[3], global_alpha*color[4], true)
	renderer_gradient(width/2 + offset, height / 2, initial_position - offset, 1, color[1], color[2], color[3], global_alpha*color[4], color[1], color[2], color[3], 0, true)

	renderer_gradient(width / 2, height/2 - initial_position, 1, initial_position - offset, color[1], color[2], color[3], 0, color[1], color[2], color[3], global_alpha*color[4], false)
	renderer_gradient(width / 2, height/2 + offset, 1, initial_position - offset, color[1], color[2], color[3], global_alpha*color[4], color[1], color[2], color[3], 0, false)

	ui_set(scope_overlay, false)
end

local ui_callback = function(c)
	local master_switch = ui_get(c)
	
	if not master_switch then
		global_alpha = 0
	end

	client[(not master_switch and 'un' or '') .. 'set_event_callback']('paint_ui', g_paint_ui)
	client[(not master_switch and 'un' or '') .. 'set_event_callback']('paint', g_paint)
end

ui.set_callback(master_switch, ui_callback)
ui_callback(master_switch)