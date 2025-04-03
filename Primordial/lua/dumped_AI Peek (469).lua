---@diagnostic disable: undefined-global
local bit = require 'bit'
local callback = {}
function menu.add_callback(control, fn)
    for i = 1, #callback do
        if (callback[i].control == control) then
            callback[i].fn = fn
            return
        end
    end
    local value, type = 0, 0
    local status = pcall(function() value = control:get() end)
    if (not status) then 
        type = 1 status = pcall(function() value = control:get_items() end)
    end
    if (not status) then type = 2 end
    if (type == 1) then
        local val = { items = control:get_items(), table = {} }
        for i = 1, #val.items do
            table.insert(val.table, control:get(i))
        end
        value = val.table
    end
    table.insert(callback, { control = control, fn = fn, value = value, type = type })
end
callbacks.add(e_callbacks.PAINT, function()
    for i = 1, #callback do
        if (callback[i].type ~= 1 and callback[i].type ~= 2 and callback[i].control:get() ~= callback[i].value) then
            callback[i].value = callback[i].control:get()
            callback[i].fn()
        elseif (callback[i].type == 1) then
            local val = { items = callback[i].control:get_items(), table = {} }
            for f = 1, #val.items do
                table.insert(val.table, callback[i].control:get(f))
            end
            for f = 1, #val.table do
                if (val.table[f] ~= callback[i].value[f]) then
                    callback[i].value = val.table
                    callback[i].fn()
                end
            end
        end
    end
end)

local ui = {
    main_switch = menu.add_checkbox('B', 'Peek bot(beta)', false),
    mode = menu.add_selection('B', 'Detection mode', {'Risky', 'Safest'}),
    hitbox = menu.add_multi_selection('B', 'Detection hitbox', {'Head', 'Neck', 'Chest', 'Stomach', 'Arms', 'Legs', 'Feet'}),
    tick = menu.add_slider('B', 'Reserve extrapolate tick', 0, 5),
    unlock = menu.add_checkbox('B', 'Unlock camera'), false,
    segament = menu.add_slider('B', 'Segament', 2, 60),
    radius = menu.add_slider('B', 'Radius', 0, 250),
    depart = menu.add_slider('B', 'Department', 1, 12),
    middle = menu.add_checkbox('B', 'Middle point', false),
    limit = menu.add_checkbox('B', 'Max prediction point limit', false),
    limit_num = menu.add_slider('B', 'Limit num', 0, 20),
    debugger = menu.add_multi_selection('B', 'Debugger', {'Line player-predict', 'Line predict-target','Fraction detection', 'Base'})
}
if ui.radius:get() == 0 then ui.radius:set(50) end
if ui.depart:get() == 1 then ui.depart:set(2) end
if ui.limit_num:get() == 0 then ui.limit_num:set(5) end
ui.key = ui.main_switch:add_keybind("Peek bot key")
ui.color = ui.debugger:add_color_picker('Debugger color')
--[[
local function g_menu_handler()
	local main = menu.main_switch
	for i,o in pairs(ui) do
		o:set_visible(main:get())
	end
	menu.limit_num:set_visible(main:get() and menu.limit:get())
	main:set_visible(true)
end

g_menu_handler()
for i,o in pairs(ui) do
    menu.add_callback(o, g_menu_handler)
end]]

local includes = function (table,key)
    for i=1, #table do
        if table[i] == key then
            return true;
        end;
    end;
    
    return false;
end
local main_font = render.create_font("Verdana", 12, 350, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local function extrapolate( player , ticks , x, y, z )
    local xv, yv, zv =  player:get_prop("m_vecVelocity" ).x, player:get_prop("m_vecVelocity").y, player:get_prop("m_vecVelocity").z
    local new_x = x+global_vars.interval_per_tick( )*xv*ticks
    local new_y = y+global_vars.interval_per_tick( )*yv*ticks
    local new_z = z+global_vars.interval_per_tick( )*zv*ticks
    return new_x, new_y, new_z
end 

local is_in_air = function(player)
    return bit.band( player:get_prop( "m_fFlags" ), 1 ) == 0
end


local r, g, b, a = 255, 255, 255, 255
local my_old_view = vec3_t(0, 0, 0)
local my_old_vec = vec3_t(0, 0, 0)
local quick_peek_assist = menu.find('aimbot', 'general', 'misc', 'autopeek')
local minimum_damage_auto = menu.find('aimbot', 'auto', 'target overrides', 'force min. damage')
local minimum_damage_scout = menu.find('aimbot', 'scout', 'target overrides', 'force min. damage')
local minimum_damage_awp = menu.find('aimbot', 'awp', 'target overrides', 'force min. damage')
local minimum_damage_deagle = menu.find('aimbot', 'deagle', 'target overrides', 'force min. damage')
local minimum_damage_revolver = menu.find('aimbot', 'revolver', 'target overrides', 'force min. damage')
local minimum_damage_pistols = menu.find('aimbot', 'pistols', 'target overrides', 'force min. damage')
local minimum_damage_other = menu.find('aimbot', 'other', 'target overrides', 'force min. damage')

local function init_old()
    local me = entity_list.get_local_player()
    if me == nil then
        return 
    end
    local pitch, yaw = me:get_render_angles().x, me:get_render_angles().y
    my_old_view = vec3_t(pitch, yaw, 0)
    local x, y, z = me:get_hitbox_pos(e_hitboxes.PELVIS).x, me:get_hitbox_pos(e_hitboxes.PELVIS).y, me:get_hitbox_pos(e_hitboxes.PELVIS).z
    my_old_vec = vec3_t(x, y, z)
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
	local eye_pos = vec
	local viewangle = my_old_view
    
    local sin_pitch = math.sin(math.rad(0))
    local cos_pitch = math.cos(math.rad(0))
    local sin_yaw = math.sin(math.rad((90 + viewangle.y + radius)))
    local cos_yaw = math.cos(math.rad((90 + viewangle.y + radius)))

    local a_vec1 = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }

    local a_vec = vec3_t(eye_pos.x + a_vec1[1] * v, eye_pos.y + a_vec1[2] * v, eye_pos.z + a_vec1[3] * v)
	return a_vec
end

local function get_predict_point(radius, segament, vec)
    local points = {}
    local me = entity_list.get_local_player()
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
    local limit_vec_cal = #vec3_t(limit_vec.x - my_vec.x, limit_vec.y - my_vec.y, 0)

    local points = {}

    for i = 1, department do
        local add_vec = vec3_t(vec.x - my_vec.x / department * i, vec.y - my_vec.y / department * i, 0 / department * i)
        if #add_vec < limit_vec_cal then
            table.insert(points, my_vec + add_vec)
        end
    end

    return points
end

local function endpos(origin, dest)
    local local_player = entity_list.get_local_player()
    local tr = trace.line(origin, dest, local_player)
    local endpos = dest
    return endpos, tr.fraction
end

local function draw_circle_3d(x, y, z, radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage, fill_r, fill_g, fill_b, fill_a)
    local accuracy = accuracy ~= nil and accuracy or 3
    local width = width ~= nil and width or 1
    local outline = outline ~= nil and outline or false
    local start_degrees = start_degrees ~= nil and start_degrees or 0
    local percentage = percentage ~= nil and percentage or 1

    local center_x, center_y
    if fill_a then
        center_x, center_y = render.world_to_screen(vec3_t(x, y, z)).x, render.world_to_screen(vec3_t(x, y, z)).y
    end

    local screen_x_line_old, screen_y_line_old
    for rot=start_degrees, percentage*360, accuracy do
        local rot_temp = math.rad(rot)
        local lineX, lineY, lineZ = radius * math.cos(rot_temp) + x, radius * math.sin(rot_temp) + y, z
        if lineX ~= nil and lineY ~= nil and lineZ ~= nil then
            local screen_x_line = render.world_to_screen(vec3_t(lineX, lineY, lineZ))
            if screen_x_line ~= nil and screen_x_line_old ~= nil then
                --if fill_a and center_x ~= nil then
                --    renderer.triangle(screen_x_line, screen_y_line, screen_x_line_old, screen_y_line_old, center_x, center_y, fill_r, fill_g, fill_b, fill_a)
                --    render.triangle_filled(vec2_t.new(100, 500), 50, color_t.new(255,0,0), 90)
                --end
                for i=1, width do
                    local i=i-1
                    render.line(vec2_t(screen_x_line.x, screen_x_line.y-i), vec2_t(screen_x_line_old.x, screen_x_line_old.y-i), color_t(r, g, b, a))
                    render.line(vec2_t(screen_x_line.x-1, screen_x_line.y), vec2_t(screen_x_line_old.x-i, screen_x_line_old.y), color_t(r, g, b, a))
                end
                if outline then
                    local outline_a = a/255*160
                    render.line(vec2_t(screen_x_line.x, screen_x_line.y-width), vec2_t(screen_x_line_old.x, screen_x_line_old.y-width), color_t(16, 16, 16, outline_a))
                    render.line(vec2_t(screen_x_line.x, screen_x_line.y+1), vec2_t(screen_x_line_old.x, screen_x_line_old.y+1), color_t(16, 16, 16, outline_a))
                end
            end
            screen_x_line_old = screen_x_line
        end
    end
end

local function calculate_end_pos(draw_line, draw_circle, debug_fraction, vec, my_vec)
    local me = entity_list.get_local_player()
    local dx, dy, dz = me:get_render_origin().x, me:get_render_origin().y, me:get_render_origin().z
    local debug_vec = vec3_t(my_vec.x, my_vec.y, dz + 5)
    local debug_vec_2 = vec3_t(vec.x, vec.y, dz + 5)
    local pos_1, fraction_1 = endpos(my_vec, vec)
    local pos_2, fraction_2 = endpos(debug_vec, debug_vec_2)

    local end_Pos = vec3_t(pos_2.x, pos_2.y, vec.z)

    if draw_line and pos_2.x ~= nil then
        local x1 = render.world_to_screen(pos_2)
        local x2 = render.world_to_screen(debug_vec)
        if x1 ~= nil and x2 ~= nil then
            render.line(vec2_t(x1.x, x1.y), vec2_t(x2.x, x2.y) , color_t(r, g, b, a))
        end
    end

    if debug_fraction then
        local debug_text = tostring(math.floor(fraction_1) * 100)
        local x3 = render.world_to_screen(debug_vec_2)
        if x3 ~= nil then
            render.text(main_font, debug_text, vec2_t(x3.x, x3.y), color_t(r, g, b, a))
        end
    end

    return end_Pos
end

local function calculate_real_point(draw_line, draw_circle, debug_fraction, vec)
    local points_list = {}
    local me = entity_list.get_local_player()
    local my_vec = vec
    local points = get_predict_point(ui.radius:get(), ui.segament:get(), my_vec)

    for i, o in pairs(points) do
        if ui.middle:get() then
            local halfone = points[i+1]
            halfone = halfone == nil and points[1] or halfone
            local halfpoint = vec3_t((halfone.x + o.x)/2 ,(halfone.y + o.y)/2, o.z)
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
    local me = entity_list.get_local_player()
    local m_points = calculate_real_point(debug_line ,debug_cir ,debug_fraction, vec)
    local dx, dy, dz = me:get_render_origin().x, me:get_render_origin().y, me:get_render_origin().z
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
                    draw_circle_3d(depart_vec.x, depart_vec.y, dz + 5, 5, r, g, b, a)
                end
            end
        end
    end

    return points
end

local function get_peek_hitbox(content)
    local hitbox = {}
    if content:get(1) then
        table.insert(hitbox, e_hitboxes.HEAD)
    end

    if content:get(2) then
        table.insert(hitbox, e_hitboxes.NECK)
    end

    if content:get(3) then
        table.insert(hitbox, e_hitboxes.THORAX)
        table.insert(hitbox, e_hitboxes.CHEST)
        table.insert(hitbox, e_hitboxes.UPPER_CHEST)
    end

    if content:get(4) then
        table.insert(hitbox, e_hitboxes.PELVIS)
        table.insert(hitbox, e_hitboxes.BODY)
    end

    if content:get(5) then
        table.insert(hitbox, e_hitboxes.RIGHT_HAND)
        table.insert(hitbox, e_hitboxes.LEFT_HAND)
        table.insert(hitbox, e_hitboxes.RIGHT_UPPER_ARM)
        table.insert(hitbox, e_hitboxes.RIGHT_FOREARM)
        table.insert(hitbox, e_hitboxes.LEFT_UPPER_ARM)
        table.insert(hitbox, e_hitboxes.LEFT_FOREARM)
    end

    if content:get(6) then
        table.insert(hitbox, e_hitboxes.RIGHT_THIGH)
        table.insert(hitbox, e_hitboxes.LEFT_THIGH)
        table.insert(hitbox, e_hitboxes.RIGHT_CALF)
        table.insert(hitbox, e_hitboxes.LEFT_CALF)
    end

    if content:get(7) then
        table.insert(hitbox, e_hitboxes.RIGHT_FOOT)
        table.insert(hitbox, e_hitboxes.LEFT_FOOT)
    end

    return hitbox
end

local current_threat = nil
local function get_current_threat(ctx, cmd, unpredicted_data)
    current_threat = ctx.player
end

local function aiPeekrunner()
    local predict_tick = ui.tick:get()
    local me = entity_list.get_local_player()
    if me == nil then return end

    if me:is_alive() == false then
        return
    end

    if ui.key:get() == false then
        return
    end

    local m_x, m_y, m_z = me:get_hitbox_pos(e_hitboxes.PELVIS).x, me:get_hitbox_pos(e_hitboxes.PELVIS).y, me:get_hitbox_pos(e_hitboxes.PELVIS).z
    local my_vec = vec3_t(m_x, m_y, m_z)

    local mpitch, myaw = me:get_render_angles().x, me:get_render_angles().y

    if ui.main_switch:get() == false then
        return
    end

    local cur_weap = me:get_active_weapon()
    if cur_weap == nil then
        return
    end

    local weapon_data_type = cur_weap:get_weapon_data().type
    local cur_weap_name = cur_weap:get_name()
    local minimum_damage = minimum_damage_other[1]:get()

    if weapon_data_type == e_weapon_types.PISTOL then
        minimum_damage = minimum_damage_pistols[1]:get()
    elseif cur_weap_name == "ssg08" then
        minimum_damage = minimum_damage_scout[1]:get()
    elseif cur_weap_name == "deagle" then
        minimum_damage = minimum_damage_deagle[1]:get()
    elseif cur_weap_name == "revolver" then
        minimum_damage = minimum_damage_revolver[1]:get()
    elseif cur_weap_name == "awp" then
        minimum_damage = minimum_damage_awp[1]:get()
    elseif cur_weap_name == "scar20" or cur_weap_name == "g3sg1" then
        minimum_damage = minimum_damage_auto[1]:get()
    end

    local m_points = run_all_Point(
        ui.debugger:get(1),
        ui.debugger:get(4),
        ui.debugger:get(3),
        ui.depart:get(),
        my_old_vec
    )
    local sort_type = ui.mode:get()
    local p_Hitbox = get_peek_hitbox(ui.hitbox)
    local p_List = {}

    local players = entity_list.get_players(true)
    if #players == 0 then
        WORKING_VEC = nil
        IS_WORKING = false
        return
    end
    for i,o in pairs(m_points) do
        for _,player in pairs(players) do
            local best_target = player
            for _,v in pairs(p_Hitbox) do
                if best_target:is_alive() and not best_target:is_dormant() then
                    local ex, ey, ez = best_target:get_hitbox_pos(v).x, best_target:get_hitbox_pos(v).y, best_target:get_hitbox_pos(v).z
                    local new_x, new_y, new_z = extrapolate(best_target, predict_tick, ex, ey, ez)
                    local e_vec = vec3_t(new_x, new_y, new_z)
                    local dmg = trace.bullet(o, e_vec, me)
                    if dmg.valid and dmg.damage >= math.min(minimum_damage, best_target:get_prop('m_iHealth')) then
                        table.insert(p_List, {
                            TARGET = best_target,
                            damage = dmg.damage,
                            vec = o,
                            enemy_vec = e_vec
                        })
                    end
                end
            end
        end
        if ui.limit:get() and #p_List >= ui.limit_num:get() then
            break
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
        if o.TARGET:is_alive() == false then
            table.remove(p_List, i)
        end
    end

    local _, _, debug_point = me:get_render_origin().x, me:get_render_origin().y, me:get_render_origin().z
    if #p_List >= 1 then
        local lib = p_List[1]
        local vec = lib.vec
        local damage = lib.damage
        local e_vec = lib.enemy_vec
        local new_debug = vec3_t(vec.x, vec.y, debug_point + 5)
        local x1 = render.world_to_screen(new_debug)
        if x1 ~= nil then
            if ui.debugger:get(2) then
                if e_vec.x == nil or e_vec.y == nil or (e_vec.x == 0 and e_vec.y == 0) then return end
                local x2 = render.world_to_screen(e_vec)
                if x2 == nil then return end
                render.line(vec2_t(x1.x, x1.y), vec2_t(x2.x, x2.y), color_t(r, g, b, a))
            end

            if x1.y ~= nil then
                x1.y = x1.y - 12
            end

            local render_text = tostring(math.floor(damage))
            render.text(main_font, render_text, vec2_t(x1.x, x1.y), color_t(r, g, b, a))
        end
        IS_WORKING = true
        WORKING_VEC = vec
    else
        WORKING_VEC = nil
        IS_WORKING = false
    end
end

local RUN_MOVEMENT = false
local function aiPeekragebot()
    if ui.main_switch:get() == false then
        return
    end

    RUN_MOVEMENT = false
end

local function deg_to_rad(val) 
	return val * (math.pi / 180.0) 
end

local function angle_to_vector(Angle)
	local cp, sp = math.cos(deg_to_rad(Angle.x)), math.sin(deg_to_rad(Angle.x))
	local cy, sy = math.cos(deg_to_rad(Angle.y)), math.sin(deg_to_rad(Angle.y))
	local cr, sr = math.cos(deg_to_rad(Angle.z)), math.sin(deg_to_rad(Angle.z))

	local forward = vec3_t(0, 0, 0)

	forward.x = cp * cy
	forward.y = cp * sy
	forward.z = -sp

	return forward
end
local function set_movement(cmd, desired_pos, whyyy)
    local local_player = entity_list.get_local_player()
    if whyyy then
		local current_pos = local_player:get_render_origin()
		local yaw = engine.get_view_angles().y
	
		local vector_forward = {
			x = current_pos.x - desired_pos.x,
			y = current_pos.y - desired_pos.y,
		}
	  
		local velocity = {
			x = -(vector_forward.x * math_cos(yaw / 180 * math.pi) + vector_forward.y * math_sin(yaw / 180 * math.pi)),
			y = vector_forward.y * math_cos(yaw / 180 * math.pi) - vector_forward.x * math_sin(yaw / 180 * math.pi),
		}
	
		cmd.forwardmove = velocity.x * 15
		cmd.sidemove = velocity.y * 15
	else
		local x, y, z = local_player:get_render_origin().x, local_player:get_render_origin().y, local_player:get_render_origin().z
		local pitch, yaw = vector_angles(x, y, z, desired_pos.x, desired_pos.y, desired_pos.z)

    	local movedirection = yaw

    	local move1 = angle_to_vector(angle_t(0, engine.get_view_angles().y - movedirection, 0))
    	cmd.move.x = move1.x * 450
    	cmd.move.y = move1.y * 450
	end
end

local indr, indg, indb, inda = 255, 255, 255, 255

local function aiPeekretreat(cmd)
    local me = entity_list.get_local_player()
    if me == nil then
        return
    end

    if ui.main_switch:get() == false then
        return
    end

    if me:is_alive() == false then
        return
    end

    local is_forward = cmd.in_forward == 1
    local is_backward = cmd.in_back == 1
    local is_left = cmd.in_moveleft == 1
    local is_right = cmd.in_moveright == 1

    if ui.key:get() then

        local my_weapon = me:get_active_weapon()
        if my_weapon == nil then
            return
        end

        local in_air = is_in_air(me)
        local timer = global_vars.cur_time()
        local can_Fire = (me:get_prop("m_flNextAttack") <= timer and my_weapon:get_prop("m_flNextPrimaryAttack") <= timer)
        local x, y, z = me:get_render_origin().x, me:get_render_origin().y, me:get_render_origin().z

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

--client.set_event_callback("paint", function()
--    if ui.get(ui.main_switch) == false then
--        return
--    end
--
--    renderer.indicator(indr, indg, indb, inda, 'AI PEEK')
--end)

callbacks.add(e_callbacks.PAINT, aiPeekrunner)
callbacks.add(e_callbacks.SETUP_COMMAND, aiPeekretreat)
callbacks.add(e_callbacks.HITSCAN, get_current_threat)

callbacks.add(e_callbacks.RUN_COMMAND, function()
    local me = entity_list.get_local_player()
    if me == nil then return end

    if me:is_alive() == false then
        return
    end

    local m_x, m_y, m_z = me:get_hitbox_pos(e_hitboxes.PELVIS).x, me:get_hitbox_pos(e_hitboxes.PELVIS).y, me:get_hitbox_pos(e_hitboxes.PELVIS).z
    local my_vec = vec3_t(m_x, m_y, m_z)
    local mpitch, myaw = me:get_render_angles().x, me:get_render_angles().y

    if ui.key:get() == false or ui.unlock:get() then
        my_old_view = vec3_t(mpitch, myaw, 0)
    end

    if ui.key:get() == false then
        my_old_vec = my_vec
    end
end)
callbacks.add(e_callbacks.AIMBOT_SHOOT, aiPeekragebot)