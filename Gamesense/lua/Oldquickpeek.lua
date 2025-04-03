-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_eye_position, client_set_event_callback, client_userid_to_entindex, entity_get_classname, entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_is_alive, math_atan2, math_cos, math_deg, math_rad, math_sin, math_sqrt, renderer_line, renderer_triangle, renderer_world_to_screen, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_reference, ui_set, ui_set_callback, ui_set_visible = client.eye_position, client.set_event_callback, client.userid_to_entindex, entity.get_classname, entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.is_alive, math.atan2, math.cos, math.deg, math.rad, math.sin, math.sqrt, renderer.line, renderer.triangle, renderer.world_to_screen, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.reference, ui.set, ui.set_callback, ui.set_visible

local quickstop_reference = ui_reference("RAGE", "Aimbot", "Quick stop")
local enabled_reference, hotkey_reference = ui_reference("RAGE", "Other", "Quick peek assist")

local draw_reference = ui_new_checkbox("VISUALS", "Other ESP", "Draw quick peek")
local color_reference = ui_new_color_picker("VISUALS", "Other ESP", "Quick peek color", 255, 255, 255, 255)

local single_fire_weapons = {
	"CDeagle",
	"CWeaponSSG08",
	"CWeaponAWP"
}

local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local center_x, center_y
	if fill_a then
		center_x, center_y = renderer_world_to_screen(x, y, z)
	end

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math_rad(rot)
		local lineX, lineY, lineZ = radius * math_cos(rot_temp) + x, radius * math_sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer_world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			if fill_a and center_x ~= nil then
				renderer_triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
			end
			for i=1, width do
				local i=i-1
				renderer_line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
				renderer_line(screen_x_line-1, screen_y_line, screen_x_line_old-i, screen_y_line_old, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer_line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer_line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function distance3d(x1, y1, z1, x2, y2, z2)
	return math_sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

local function table_contains(tbl, val)
	for i = 1, #tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function vector_angles(x1, y1, z1, x2, y2, z2)
	local origin_x, origin_y, origin_z
	local target_x, target_y, target_z
	if x2 == nil then
		target_x, target_y, target_z = x1, y1, z1
		origin_x, origin_y, origin_z = client_eye_position()
		if origin_x == nil then
			return
		end
	else
		origin_x, origin_y, origin_z = x1, y1, z1
		target_x, target_y, target_z = x2, y2, z2
	end

	local delta_x, delta_y, delta_z = target_x-origin_x, target_y-origin_y, target_z-origin_z

	if delta_x == 0 and delta_y == 0 then
		return (delta_z > 0 and 270 or 90), 0
	else
		local yaw = math_deg(math_atan2(delta_y, delta_x))
		local hyp = math_sqrt(delta_x*delta_x + delta_y*delta_y)
		local pitch = math_deg(math_atan2(-delta_z, hyp))

		return pitch, yaw
	end
end

local hotkey_prev, shots, pos_x, pos_y, pos_z = false, 0
local quickstop_prev, quickstop_allowed, standing

local function update_visiblity()
	local enabled = ui_get(enabled_reference)

	if not enabled then
		hotkey_prev = false
		pos_x = nil
	end
end
ui_set_callback(enabled_reference, update_visiblity)
update_visiblity()

local function on_paint()
	local player = entity.get_local_player();

    if (not player or entity.get_prop(player, "m_lifeState") ~= 0) then
        return;
    end

    local entity_weapon = entity.get_player_weapon(player);

    -- If our weapon entity doesn't exist
    if (not entity_weapon) then
        return;
    end

    local weapon_index = bit.band(entity.get_prop(entity_weapon, "m_iItemDefinitionIndex"), 0xFFFF);
	if weapon_index == 42 then
		return
	end
	
	local is_enabled = ui_get(enabled_reference) and ui_get(hotkey_reference) and pos_x ~= nil and entity_is_alive(entity_get_local_player())

	if not is_enabled or not ui_get(draw_reference) then
		return
	end

	local wx, wy = renderer_world_to_screen(pos_x, pos_y, pos_z)

	if wx ~= nil then
        local r, g, b, a = ui_get(color_reference)
        
		draw_circle_3d(pos_x, pos_y, pos_z, 14, r, g, b, a, 3, 2, false, 0, 1, r, g, b, a*0.6)
	end
end
client_set_event_callback("paint", on_paint)


local function on_setup_command(cmd)
	if not ui_get(enabled_reference) then
		return
	end

	local hotkey = ui_get(hotkey_reference)

	local player = entity.get_local_player();

    if (not player or entity.get_prop(player, "m_lifeState") ~= 0) then
        return;
    end

    local entity_weapon = entity.get_player_weapon(player);

    if (not entity_weapon) then
        return;
    end

    local weapon_index = bit.band(entity.get_prop(entity_weapon, "m_iItemDefinitionIndex"), 0xFFFF);
	if weapon_index == 42 then
		return
	end

    local on_ground = bit.band(entity.get_prop(entity.get_local_player(), "m_fFlags"), 1)

	if hotkey then
        local local_player = entity_get_local_player()

		if not hotkey_prev and on_ground == 1 then
			pos_x, pos_y, pos_z = entity_get_prop(local_player, "m_vecAbsOrigin")
		end
	else
		pos_x = nil
	end

    if on_ground == 1 then

    hotkey_prev = hotkey
    end
end

client_set_event_callback("setup_command", on_setup_command)