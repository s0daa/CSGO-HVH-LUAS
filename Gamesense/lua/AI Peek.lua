

local ffi = require 'ffi'
local bit = require 'bit'
local vector = require 'vector'
local trace = require 'gamesense/trace'

local menu = {
	main_switch = 	ui.new_checkbox			('LUA', 'B', 'AIpeek by overvest'),
	key = 			ui.new_hotkey 			('LUA', 'B', 'Peek bot key', true, 0),
	mode = 			ui.new_combobox			('LUA', 'B', 'Detection mode', {'Risky', 'Safest'}),
	target = 		ui.new_combobox			('LUA', 'B', 'Detection target', {'Current', 'All target'}),
	hitbox = 		ui.new_multiselect		('LUA', 'B', 'Detection hitbox', {'Head', 'Neck', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet'}),
	tick = 			ui.new_slider 			('LUA', 'B', 'Reserve extrapolate tick', 0, 5, 0),
	unlock = 		ui.new_checkbox			('LUA', 'B', 'Unlock camera'),
	segament = 		ui.new_slider 			('LUA', 'B', 'Segament', 2, 60, 2),
	radius = 		ui.new_slider 			('LUA', 'B', 'Radius', 0, 250, 50),
	depart =		ui.new_slider 			('LUA', 'B', 'Department', 1, 12, 2),
	middle =  		ui.new_checkbox 		('LUA', 'B', 'Middle point'),
	limit = 		ui.new_checkbox			('LUA', 'B', 'Max prediction point limit'),
	limit_num =		ui.new_slider 			('LUA', 'B', 'Limit num', 0, 20, 5),
	debugger = 		ui.new_multiselect 		('LUA', 'B', 'Debugger', {'Line player-predict', 'Line predict-target','Fraction detection', 'Base'}),
	color =  		ui.new_color_picker 	('LUA', 'B', 'Debugger color', 255, 255, 255, 255)
}

local function g_menu_handler()
	local main = menu.main_switch
	for i,o in pairs(menu) do
		ui.set_visible(o, ui.get(main))
	end
	ui.set_visible(menu.limit_num, ui.get(main) and ui.get(menu.limit))
	ui.set_visible(main, true)
end

g_menu_handler()
for i,o in pairs(menu) do
	ui.set_callback(o, g_menu_handler)
end

local includes = function (table,key)
    for i=1, #table do
        if table[i] == key then
            return true;
        end;
    end;
    
    return false;
end

local function extrapolate( player , ticks , x, y, z )
    local xv, yv, zv =  entity.get_prop( player, "m_vecVelocity" )
    local new_x = x+globals.tickinterval( )*xv*ticks
    local new_y = y+globals.tickinterval( )*yv*ticks
    local new_z = z+globals.tickinterval( )*zv*ticks
    return new_x, new_y, new_z
end  

local is_in_air = function(player)
    return bit.band( entity.get_prop( player, "m_fFlags" ), 1 ) == 0
end


local r, g, b, a = 255, 255, 255, 255
local my_old_view = vector(0, 0, 0)
local my_old_vec = vector(0, 0, 0)
local minimum_damage = ui.reference('RAGE', 'Aimbot', 'Minimum damage')
local quick_peek_assist = { ui.reference("RAGE", "Other", "Quick peek assist") }
local quick_peek_assist_mode = { ui.reference("RAGE", "Other", "Quick peek assist mode") }

local function init_old()
	local me = entity.get_local_player()
	if me == nil then 
		return  
	end
	local pitch, yaw = client.camera_angles()
	my_old_view = vector(pitch, yaw, 0)
	local x, y, z = entity.hitbox_position(me, 3)
	my_old_vec = vector(x, y, z)
end

local IS_WORKING = false
local WORKING_VEC = my_old_vec


local function vector_angles(x1, y1, z1, x2, y2, z2)
	local origin_x, origin_y, origin_z
	local target_x, target_y, target_z
	if x2 == nil then
		target_x, target_y, target_z = x1, y1, z1
		origin_x, origin_y, origin_z = client.eye_position()
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
		local yaw = math.deg(math.atan2(delta_y, delta_x))
		local hyp = math.sqrt(delta_x*delta_x + delta_y*delta_y)
		local pitch = math.deg(math.atan2(-delta_z, hyp))
		return pitch, yaw
	end
end

local function get_view_point(radius, v, vec)
	local me = entity.get_local_player()
	local eye_pos = vec
	local viewangle = my_old_view
	local a_vec = eye_pos + vector(0,0,0):init_from_angles(0, (90 + viewangle.y + radius), 0) * v
	return a_vec
end

local function get_predict_point(radius, segament, vec)
	local points = {}
	local me = entity.get_local_player()
	local my_vec = vec
	segament = math.max(2, math.floor(segament))
	local angles_pre_point = 360 / segament
	for i = 0, 360, angles_pre_point do
		local m_p = get_view_point(i, radius, my_vec)
		table.insert(points, m_p)
	end
	return points
end

local function get_depart_point(vec, my_vec, department, limit_vec)
	local vec_1 = vector(vec.x, vec.y, 0)
	local vec_2 = vector(my_vec.x, my_vec.y, 0)
	local vec_3 = vector(limit_vec.x, limit_vec.y, 0)

	local each_plus = (vec_1 - vec_2) / department
	local limit_vec_cal = (vec_3 - vec_2):length()

	local points = {}

	for i = 1, department do
		local add_vec = each_plus * i
		if add_vec:length() < limit_vec_cal then
			table.insert(points, my_vec + add_vec)
		end
	end

	return points
end

local function endpos(origin, dest)
    local local_player = entity.get_local_player()
    local tr = trace.line(origin, dest, { skip = local_player })
    local endpos = tr.end_pos
    return endpos, tr.fraction
end

local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)
	local accuracy = accuracy ~= nil and accuracy or 2
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 4

	local center_x, center_y
	if fill_a then
		center_x, center_y = renderer.world_to_screen(x, y, z)
	end

	local screen_x_line_old, screen_y_line_old
	for rot=start_degrees, percentage*360, accuracy do
		local rot_temp = math.rad(rot)
		local lineX, lineY, lineZ = radius * math.cos(rot_temp) + x, radius * math.sin(rot_temp) + y, z
		local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~=nil and screen_x_line_old ~= nil then
			if fill_a and center_x ~= nil then
				renderer.triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
			end
			for i=1, width do
				local i=i-1
				renderer.line(screen_x_line, screen_y_line-i, screen_x_line_old, screen_y_line_old-i, r, g, b, a)
				renderer.line(screen_x_line-1, screen_y_line, screen_x_line_old-i, screen_y_line_old, r, g, b, a)
			end
			if outline then
				local outline_a = a/255*160
				renderer.line(screen_x_line, screen_y_line-width, screen_x_line_old, screen_y_line_old-width, 16, 16, 16, outline_a)
				renderer.line(screen_x_line, screen_y_line+1, screen_x_line_old, screen_y_line_old+1, 16, 16, 16, outline_a)
			end
		end
		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

local function calculate_end_pos(draw_line, draw_circle, debug_fraction, vec, my_vec)
	local me = entity.get_local_player()
	local dx, dy, dz = entity.get_origin(me)
	local debug_vec = vector(my_vec.x, my_vec.y, dz + 5)
	local debug_vec_2 = vector(vec.x, vec.y, dz + 5)
	local pos_1, fraction_1 = endpos(my_vec, vec)
	local pos_2, fraction_2 = endpos(debug_vec, debug_vec_2)

	local end_Pos = vector(pos_2.x, pos_2.y, vec.z)

	if draw_line then
		local x1, y1 = renderer.world_to_screen(pos_2.x, pos_2.y, pos_2.z)
		local x2, y2 = renderer.world_to_screen(debug_vec.x, debug_vec.y, debug_vec.z)
		renderer.line(x1, y1, x2, y2 , r, g, b, a)
	end

	if debug_fraction then
		local debug_text = tostring(math.floor(fraction_1) * 100)
		local x3, y3 = renderer.world_to_screen(debug_vec_2.x, debug_vec_2.y, debug_vec_2.z)
		renderer.text(x3, y3, r, g, b, a, 'c', 0, debug_text)
	end

	return end_Pos
end

local function calculate_real_point(draw_line, draw_circle, debug_fraction, vec)
	local points_list = {}
	local me = entity.get_local_player()
	local my_vec = vec
	local points = get_predict_point(ui.get(menu.radius), ui.get(menu.segament), my_vec)

	for i, o in pairs(points) do
		if ui.get(menu.middle) then
			local halfone = points[i+1]
			halfone = halfone == nil and points[1] or halfone
			local halfpoint = vector((halfone.x + o.x)/2 ,(halfone.y + o.y)/2, o.z)
			local end_pos = calculate_end_pos(draw_line,draw_circle ,debug_fraction, halfpoint, my_vec)
            table.insert(points_list, {
                endpos = end_pos,
                ideal = halfpoint
            })
		end
        local end_pos = calculate_end_pos(draw_line,draw_circle ,debug_fraction, o, my_vec)
        table.insert(points_list, {
            endpos = end_pos,
            ideal = o
        })
	end

	return points_list
end

local function run_all_Point(debug_line, debug_cir, debug_fraction, department, vec)
	local me = entity.get_local_player()
	local m_points = calculate_real_point(debug_line ,debug_cir ,debug_fraction, vec)
	local dx, dy, dz = entity.get_origin(me)
	local points = {}
	for i, o in pairs(m_points) do
		local calculate_vec = o.ideal
		local limit_vec = o.endpos
		table.insert(points, limit_vec)
		if debug_cir then
			draw_circle_3d(limit_vec.x, limit_vec.y, dz + 5, 5, r, g, b, a)
		end

		if department ~= 1 then
			for _, depart_vec in pairs(get_depart_point(calculate_vec, vec, department, limit_vec)) do
				table.insert(points, depart_vec)

				if debug_cir then
					draw_circle_3d(depart_vec.x, depart_vec.y,dz + 5, 5, r, g, b, a)
				end
			end
		end
	end

	return points
end

local function get_peek_hitbox(content)
	local hitbox = {}
	if includes(content, 'Head') then
		table.insert(hitbox, 0)
	end

	if includes(content, 'Neck') then
		table.insert(hitbox, 1)
	end

	if includes(content, 'Chest') then
		table.insert(hitbox, 4)
		table.insert(hitbox, 5)
		table.insert(hitbox, 6)
	end

	if includes(content, 'Stomach') then
		table.insert(hitbox, 2)
		table.insert(hitbox, 3)
	end

	if includes(content, 'Arms') then
		table.insert(hitbox, 13)
		table.insert(hitbox, 14)
		table.insert(hitbox, 15)
		table.insert(hitbox, 16)
		table.insert(hitbox, 17)
		table.insert(hitbox, 18)
	end

	if includes(content, 'Legs') then
		table.insert(hitbox, 7)
		table.insert(hitbox, 8)
		table.insert(hitbox, 9)
		table.insert(hitbox, 10)
	end

	if includes(content, 'Feet') then
		table.insert(hitbox, 11)
		table.insert(hitbox, 12)
	end

	return hitbox
end

local function using_auto_peek()
	return (ui.get(quick_peek_assist[1]) and ui.get(quick_peek_assist[2]))
end

local function aiPeekrunner()
	local predict_tick = ui.get(menu.tick)
	local me = entity.get_local_player()
	if me == nil then return end

	if entity.is_alive(me) == false then
		return 
	end

	if ui.get(menu.key) == false then
		return 
	end

	local m_x, m_y, m_z = entity.hitbox_position(me, 4)
	local my_vec = vector(m_x, m_y, m_z)

	local mpitch, myaw = client.camera_angles()

	if ui.get(menu.main_switch) == false then
		return 
	end

	local debugger = ui.get(menu.debugger)
	local m_points = run_all_Point(
		includes(debugger, 'Line player-predict'),
		includes(debugger, 'Base'),
		includes(debugger, 'Fraction detection'),
		ui.get(menu.depart),
		my_old_vec
	)
	local sort_type = ui.get(menu.mode)
	local p_Hitbox = get_peek_hitbox(ui.get(menu.hitbox))
	local p_List = {}
	if not (ui.get(menu.target) == 'Current') then
		local players = entity.get_players(true)
		if #players == 0 then
			WORKING_VEC = nil
			IS_WORKING = false
			return 
		end
		for i,o in pairs(m_points) do
			for _,player in pairs(players) do
				local best_target = player
				for _,v in pairs(p_Hitbox) do
					local ex, ey, ez = entity.hitbox_position(best_target, v)
					local new_x, new_y, new_z = extrapolate(best_target, predict_tick, ex, ey, ez)
					local e_vec = vector(new_x, new_y, new_z)
					local _, dmg = client.trace_bullet(me, o.x, o.y, o.z, e_vec.x, e_vec.y, e_vec.z)
					if dmg >= math.min(ui.get(minimum_damage), entity.get_prop(best_target, 'm_iHealth')) then
						table.insert(p_List, {
							TARGET = best_target,
							damage = dmg,
							vec = o,
							enemy_vec = e_vec
						})
					end
				end
			end

			if ui.get(menu.limit) and #p_List >= ui.get(menu.limit_num) then
				break
			end
		end
	else
		local best_target = client.current_threat()
		if best_target == nil then
			WORKING_VEC = nil
			IS_WORKING = false
			return 
		end
		for i,o in pairs(m_points) do
			for k,v in pairs(p_Hitbox) do
				local ex, ey, ez = entity.hitbox_position(best_target, v)
				local new_x, new_y, new_z = extrapolate(best_target, predict_tick, ex, ey, ez)
				local e_vec = vector(new_x, new_y, new_z)
				local _, dmg = client.trace_bullet(me, o.x, o.y, o.z, e_vec.x, e_vec.y, e_vec.z)
				if dmg > math.min(ui.get(minimum_damage), entity.get_prop(best_target, 'm_iHealth')) then
					table.insert(p_List, {
						TARGET = best_target,
						damage = dmg,
						vec = o,
						enemy_vec = e_vec
					})
				end
			end

			if ui.get(menu.limit) and #p_List >= ui.get(menu.limit_num) then
				break
			end
		end
	end

	table.sort(p_List, function(a, b)
		if sort_type == 'Risky' then
			return a.damage > b.damage
		else
			return a.damage < b.damage
		end
	end)

	for i,o in pairs(p_List) do
		if entity.is_alive(o.TARGET) == false then
			table.remove(p_List, i)
		end
	end

	local _, _, debug_point = entity.get_origin(me)
	if #p_List >= 1 then
		local lib = p_List[1]
		local vec = lib.vec
		local damage = lib.damage 
		local e_vec = lib.enemy_vec
		local new_debug = vector(vec.x, vec.y, debug_point + 5)
		local x1, y1 = renderer.world_to_screen(new_debug.x, new_debug.y, new_debug.z)
		if includes(debugger, 'Line predict-target')  then
			local x2, y2 = renderer.world_to_screen(e_vec.x, e_vec.y, e_vec.z)
			renderer.line(x1, y1, x2, y2, r, g, b, a)
		end

		if y1 ~= nil then
			y1 = y1 - 12
		end

		local render_text = tostring(math.floor(damage))
		renderer.text(x1, y1 , r, g, b, a, 0, render_text)
		IS_WORKING = true 
		WORKING_VEC = vec
	else
		WORKING_VEC = nil
		IS_WORKING = false
	end
end

local RUN_MOVEMENT = false
local function aiPeekragebot()
	if ui.get(menu.main_switch) == false then 
		return 
	end

	RUN_MOVEMENT = false
end

local function set_movement(cmd, desired_pos)
    local local_player = entity.get_local_player()
    local x, y, z = entity.get_prop(local_player, "m_vecAbsOrigin")
    local pitch, yaw = vector_angles(x, y, z, desired_pos.x, desired_pos.y, desired_pos.z)
    cmd.in_forward = 1
    cmd.in_back = 0
    cmd.in_moveleft = 0
    cmd.in_moveright = 0
    cmd.in_speed = 0

    cmd.forwardmove = 800
    cmd.sidemove = 0

    cmd.move_yaw = yaw
end

local indr, indg, indb, inda = 255, 255, 255, 255

local function aiPeekretreat(cmd)
	local me = entity.get_local_player()
	if me == nil then 
		return 
	end

	if ui.get(menu.main_switch) == false then 
		return 
	end

	if entity.is_alive(me) == false then
		return 
	end

	local is_forward = cmd.in_forward == 1
	local is_backward = cmd.in_back == 1
	local is_left = cmd.in_moveleft == 1
	local is_right = cmd.in_moveright == 1

	if ui.get(menu.key) then

		local my_weapon = entity.get_player_weapon(me)
		if my_weapon == nil then 
			return 
		end

		local in_air = is_in_air(me)
		local timer = globals.curtime()
		local can_Fire = (entity.get_prop(me, "m_flNextAttack") <= timer and entity.get_prop(my_weapon, "m_flNextPrimaryAttack") <= timer)
		local x, y, z = entity.get_origin(me)

		if math.abs(x - my_old_vec.x) <= 10 then
			RUN_MOVEMENT = true
		end

		if can_Fire == false then
			RUN_MOVEMENT = false 
		end
		indr, indg, indb, inda = 255, 255, 0, 255
		if IS_WORKING and RUN_MOVEMENT and in_air == false and WORKING_VEC ~= nil then
			set_movement(cmd, WORKING_VEC)
			indr, indg, indb, inda = 0, 255, 0, 255
		elseif RUN_MOVEMENT == false and in_air == false and is_forward == false and is_backward == false and is_left == false and is_right == false then
			set_movement(cmd, my_old_vec)
		end

	else
		indr, indg, indb, inda = 0, 255, 0, 255
	end
end

init_old()

client.set_event_callback("paint", function()
	if ui.get(menu.main_switch) == false then 
		return 
	end

	renderer.indicator(indr, indg, indb, inda, 'AI PEEK')
end)

client.set_event_callback("paint", aiPeekrunner)
client.set_event_callback("setup_command", aiPeekretreat)

client.set_event_callback("run_command", function()
	local me = entity.get_local_player()
	if me == nil then return end

	if entity.is_alive(me) == false then
		return 
	end

	local m_x, m_y, m_z = entity.hitbox_position(me, 3)
	local my_vec = vector(m_x, m_y, m_z)
	local mpitch, myaw = client.camera_angles()

	if ui.get(menu.key) == false or ui.get(menu.unlock) then
		my_old_view = vector(mpitch, myaw, 0)
	end

	if ui.get(menu.key) == false then
		my_old_vec = my_vec
	end
end)
client.set_event_callback("aim_fire", aiPeekragebot)