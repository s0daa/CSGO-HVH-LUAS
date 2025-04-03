local enabled_ref = menu.add_checkbox("Predict Hitbox", "Enable", true)
local color_ref = enabled_ref:add_color_picker("Color")
local size_ref = menu.add_slider("Visual Hitbox Size", "Size", 500, 4000)
local peek_text_ref = menu.add_text("Visualize hitscan", "Auto peek assistant")
local peek_ref = peek_text_ref:add_keybind("automatic peek key")

local reduce_fov_ref = menu.find("visuals", "other", "general", "zoom fov")
local stupid2_ref, auto_peek_ref = unpack(menu.find("aimbot", "general", "misc", "autopeek"))

local function __thiscall(func, this)
    -- bind wrapper for __thiscall functions
    return function(...)
        return func(this, ...)
    end
end

local function vtable_bind(module, interface, index, type)
    local addr = ffi.cast("void***", memory.create_interface(module, interface)) or error(interface .. " is nil.")
    return __thiscall(ffi.cast(ffi.typeof(type), addr[0][index]), addr)
end

local nativeDrawSetColor = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 15, "void(__thiscall*)(void*, int, int, int, int)")
local nativeDrawOutlinedCircle = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 103, "void(__thiscall*)(void*, int, int, int, int)")

local surface = {}

function surface.draw_outlined_circle(x, y, r, g, b, a, radius, segments)
    nativeDrawSetColor(r, g, b, a)
    return nativeDrawOutlinedCircle(x, y, radius, segments)
end

local function degree_to_radian(degree)
    return (math.pi / 180) * degree
end

local function angle_to_vector (angle)
    local pitch = degree_to_radian(angle.x)
    local yaw = degree_to_radian(angle.y)
    return vec3_t(math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch))
end

local function better_angle_to_vector (x, y)
    local pitch = degree_to_radian(x)
    local yaw = degree_to_radian(y)
    return math.cos(pitch) * math.cos(yaw), math.cos(pitch) * math.sin(yaw), -math.sin(pitch)
end

local function dist_to (vec1, vec2)
    return math.sqrt(math.pow(vec1.x - vec2.x, 2) + math.pow(vec1.y - vec2.y, 2) + math.pow(vec1.z - vec2.z, 2))
end

local function dist_to_2d (vec1, vec2)
    return math.sqrt(math.pow(vec1.x - vec2.x, 2) + math.pow(vec1.y - vec2.y, 2))
end

local function getCameraPositionInaccurate()
    local local_player = entity_list.get_local_player()
    local eye_pos = local_player:get_eye_position()
    if not client.is_in_thirdperson() then
        return eye_pos
    end
    local local_angle = angle_to_vector(engine.get_view_angles())
    local camera_pos = vec3_t(local_angle.x * -130 + eye_pos.x, local_angle.y * -130 + eye_pos.y, local_angle.z * -130 + eye_pos.z)
    local trace_result = trace.line(eye_pos, camera_pos, local_player)
    local camera_pos = vec3_t(local_angle.x * -128 * trace_result.fraction + eye_pos.x, local_angle.y * -128 * trace_result.fraction + eye_pos.y, local_angle.z * -128 * trace_result.fraction + eye_pos.z)
    return camera_pos
end

local function adjustAngle(angle)
    if angle < 0 then
        angle = (90 + angle * (-1))
    elseif angle > 0 then
        angle = (90 - angle)
    end

    return angle
end

local function get_velocity(player)
    local velocity = player:get_prop("m_vecVelocity")
    return math.sqrt(velocity.x * velocity.x, velocity.y * velocity.y)
end

local render_factor = 1

local function update_scale()
    local local_player = entity_list.get_local_player()
    if local_player == nil or not local_player:is_alive() then
        return
    end
    local weapon = local_player:get_active_weapon()
    if weapon == nil then
        return
    end
    local zoom = weapon:get_prop("m_zoomLevel")
    render_factor = 1
    if zoom ~= nil and zoom > 0 then
        local fov = local_player:get_prop("m_iFOV")
        if fov < 90 then
            render_factor = 2.6 * (reduce_fov_ref:get() + 100) / 100
        end
        if fov < 40 then
            render_factor = 6 * (reduce_fov_ref:get() + 100) / 100
        end
    end
end

local hit_pos = {}
local hit_size = {}

local mapping = {
    weapon_ssg08 = 'scout',
    weapon_awp = 'awp',
    weapon_scar20 = 'auto',
    weapon_g3sg1 = 'auto',
    weapon_deagle = 'deagle',
    weapon_revolver = 'revolver'
}

local color = color_ref:get()
local color_border = color_ref:get()
color_border = color_t(color_border.r * 1.8 > 255 and 255 or math.floor(color_border.r * 1.8), color_border.g * 1.8 > 255 and 255 or math.floor(color_border.g * 1.8), color_border.b * 1.8 > 255 and 255 or math.floor(color_border.b * 1.8, 200))
color.a = 150
local size = size_ref:get()

local dmg1 = 0
local dmg2 = 0

local hitscan = { 4, 2, 0, 6 }

local eye_pos = vec3_t(0, 0, 0)
local auto_side = 0

local last_auto_peek = false

local function handle_auto_peek(cmd, origin, pos, speed)
    if pos == nil or origin == nil then
        return
    end
    local vec2pos_x, vec2pos_y = pos.x - origin.x, pos.y - origin.y
    local angle2pos = math.atan2(vec2pos_y, vec2pos_x) * (180 / math.pi)
    local view = engine.get_view_angles()
    local viewyaw = view.y - 180
    local moveangle = (adjustAngle(angle2pos - viewyaw) + 90) * (math.pi / 180)
    cmd.move.x = math.cos(moveangle) * speed
    cmd.move.y = math.sin(moveangle) * speed
end

local function on_setup_command(cmd)
    if not enabled_ref:get() then
        hit_pos = {}
        hit_size = {}
        last_auto_peek = false
        return
    end
    local local_player = entity_list.get_local_player()
    local enemies_1 = entity_list.get_players(true)
    local enemies = {}
    for _, v in pairs(enemies_1) do
        if not v:is_dormant() and v:is_alive() then
            table.insert(enemies, v)
        else
            hit_pos[v:get_index()] = nil
        end
    end
    if #enemies == 0 then
        hit_pos = {}
        hit_size = {}
        last_auto_peek = false
        return
    end

    local enemy = enemies[1 + global_vars.tick_count() % #enemies]
    if global_vars.tick_count() % 32 == 0 then
        update_scale()
    end
    local cameraPos = getCameraPositionInaccurate()
    if cameraPos == nil then
        return
    end
    if peek_ref:get() and not last_auto_peek then
        eye_pos = local_player:get_eye_position()
        auto_side = 0
    elseif not peek_ref:get() then
        eye_pos = local_player:get_eye_position()
    end
    last_auto_peek = peek_ref:get()

    local enemy_pos = enemy:get_render_origin()
    local vec2enemy_x, vec2enemy_y = eye_pos.x - enemy_pos.x, eye_pos.y - enemy_pos.y
    local ang2enemy = math.atan2(vec2enemy_y, vec2enemy_x) * (180 / math.pi)

    local extrapolate_distance = 30 + get_velocity(local_player) / 15

    local left_x, left_y, left_z = better_angle_to_vector(0, ang2enemy + 90)
    local right_x, right_y, right_z = better_angle_to_vector(0, ang2enemy - 90)
    local eye_left = vec3_t(left_x * extrapolate_distance + eye_pos.x, left_y * extrapolate_distance + eye_pos.y, eye_pos.z)
    local eye_right = vec3_t(right_x * extrapolate_distance + eye_pos.x, right_y * extrapolate_distance + eye_pos.y, eye_pos.z)
    local trace_result_left = trace.line(eye_pos, eye_left, local_player).fraction * 0.99
    local trace_result_right = trace.line(eye_pos, eye_right, local_player).fraction * 0.99
    eye_left = vec3_t(left_x * extrapolate_distance * trace_result_left + eye_pos.x, left_y * extrapolate_distance * trace_result_left + eye_pos.y, eye_pos.z)
    eye_right = vec3_t(right_x * extrapolate_distance * trace_result_right + eye_pos.x, right_y * extrapolate_distance * trace_result_right + eye_pos.y, eye_pos.z)

    local dmg_vis = dmg1 == 100 and enemy:get_prop("m_iHealth") or dmg1
    local dmg_hid = dmg2 == 100 and enemy:get_prop("m_iHealth") or dmg2

    for _, i in ipairs(hitscan) do
        local hitpos = enemy:get_hitbox_pos(i)
        local trace_result_left = trace.bullet(eye_left, hitpos, local_player, enemy)
        if (trace_result_left.valid and trace_result_left.damage > (trace_result_left.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            if auto_side == 0 then
                auto_side = eye_left
            end
            goto
            auto
        end
        local trace_result_right = trace.bullet(eye_right, hitpos, local_player, enemy)
        if (trace_result_right.valid and trace_result_right.damage > (trace_result_right.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            if auto_side == 0 then
                auto_side = eye_right
            end
            goto
            auto
        end
        local trace_result_mid = trace.bullet(eye_pos, hitpos, local_player, enemy)
        if (trace_result_mid.valid and trace_result_mid.damage > (trace_result_mid.pen_count > 0 and dmg_hid or dmg_vis)) then
            hit_pos[enemy:get_index()] = hitpos
            hit_size[enemy:get_index()] = math.atan(10 / (2 * dist_to(cameraPos, hitpos))) * size
            return
        end

    end
    hit_pos[enemy:get_index()] = nil
    :: auto ::
    local dopeek = false
    for i, v in pairs(hit_pos) do
        if v ~= nil then
            dopeek = true
            break
        end
    end
    if last_auto_peek then
        if not dopeek or not client.can_fire() then
            auto_side = 0
            local distance = dist_to_2d(eye_pos, local_player:get_render_origin())
            if distance > 1 then
                handle_auto_peek(cmd, local_player:get_render_origin(), eye_pos, math.max(10, math.min(450, math.pow(distance, 2.5))))
            end
        else
            if auto_side ~= 0 then
                handle_auto_peek(cmd, local_player:get_render_origin(), auto_side, 450)
            end
        end
    end
end

callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)

local function on_item_equip(event)
    if not enabled_ref:get() then
        return
    end
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        color = color_ref:get()
        color_border = color_ref:get()
        color_border = color_t(color_border.r * 1.8 > 255 and 255 or math.floor(color_border.r * 1.8), color_border.g * 1.8 > 255 and 255 or math.floor(color_border.g * 1.8), color_border.b * 1.8 > 255 and 255 or math.floor(color_border.b * 1.8, 200))
        size = size_ref:get()
        color.a = 150
        client.delay_call(function()
            local local_player = entity_list.get_local_player()
            if local_player == nil then
                return
            end
            local weapon = local_player:get_active_weapon()
            if weapon == nil then
                return
            end
            local weapon_data = weapon:get_weapon_data()
            local weapon_group = "other"
            if mapping[weapon_data.console_name] ~= nil then
                weapon_group = mapping[weapon_data.console_name]
            elseif
            weapon_data.type == 2 then
                weapon_group = "pistols"
            elseif
            weapon_data.type == 3 or weapon_data.type == 4 then
                weapon_group = "other"
            end
            local mindmg, mindmg_enabled = unpack(menu.find("aimbot", weapon_group, "target overrides", "force min. damage"))
            if mindmg_enabled:get() then
                dmg1 = mindmg:get()
                dmg2 = dmg1
            else
                dmg1 = menu.find("aimbot", weapon_group, "targeting", "min. damage"):get()
                dmg2 = menu.find("aimbot", weapon_group, "targeting", "override autowall damage"):get() and menu.find("aimbot", weapon_group, "targeting", "autowall"):get() or dmg1
            end
        end, 0.1)
        update_scale()
    end
end

callbacks.add(e_callbacks.EVENT, on_item_equip, "item_equip")

local function on_weapon_zoom(event)
    if not enabled_ref:get() then
        return
    end
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        update_scale()
    end
end

callbacks.add(e_callbacks.EVENT, on_weapon_zoom, "weapon_zoom")
callbacks.add(e_callbacks.EVENT, on_weapon_zoom, "weapon_fire")

local function on_player_death(event)
    if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() then
        update_scale()
        hit_pos = {}
        hit_size = {}
    end
end

callbacks.add(e_callbacks.EVENT, on_player_death, "player_death")













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













local function on_paint()
    if not enabled_ref:get() then
        return
    end

    if last_auto_peek then
        local screen_pos = render.world_to_screen(vec3_t(eye_pos.x, eye_pos.y, eye_pos.z - 16))
        if screen_pos ~= nil then
            render.circle_filled(screen_pos, 25, color)
        end
    end

    local cbr, cbg, cbb = color_border.r, color_border.g, color_border.b

    for i, v in pairs(hit_pos) do
        local screen_pos = render.world_to_screen(v)
        if screen_pos ~= nil then
            local circle_size = math.ceil(hit_size[i] * render_factor)
            render.circle_filled(screen_pos, circle_size, color)
            local outline = math.ceil(hit_size[i] * render_factor / 3)
            for x = 0, outline do
                nativeDrawSetColor(cbr, cbg, cbb, 255 - (250 / outline) * x)
                nativeDrawOutlinedCircle(screen_pos.x, screen_pos.y, circle_size + x, 10 + circle_size / 2)
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)