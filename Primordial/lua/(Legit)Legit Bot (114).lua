local set_view_angle = function(angle)
   
    return engine.set_view_angles( angle)
end
local legit_bot_enable = menu.add_checkbox("Legit bot", "Legit bot", false)
local legit_bot_fov = menu.add_slider("Legit bot", "FOV", 0, 180)
local legit_keybind = legit_bot_enable:add_keybind("Aim")
local smooth = menu.add_slider("Legit bot", "Leigt smooth", 1, 100)
local anti_recoil = menu.add_checkbox("Legit bot", "Anti recoil")
local anti_recoil_x = menu.add_slider("Legit bot", "Anti recoil pitch %", 1, 100)
local anti_recoil_y = menu.add_slider("Legit bot", "Anti recoil yaw %", 1, 100)
menu.add_button(
    "Legit bot",
    "More function will be add soon",
    function()
    end
)

local trigger_enable = menu.add_checkbox("Trigger bot", "Enable")
local trigger_fov = menu.add_slider("Trigger bot", "Fov", 0.1, 3, 0.1, 1)
local keybind = trigger_enable:add_keybind("Trigger")

local function normalize_angles(angle)
    if angle.y ~= angle.y or angle.y == INF then
        angle.y = 0
        angle.y = angle.y
    elseif not (angle.y > -180 and angle.y <= 180) then
        angle.y = math.fmod(math.fmod(angle.y + 360, 360), 360)
        angle.y = angle.y > 180 and angle.y - 360 or angle.y
    end

    return angle_t(math.max(-89, math.min(89, angle.x)), angle.y, 0)
end

local PI = math.pi
local DEG_TO_RAD = PI / 180.0
local RAD_TO_DEG = 180.0 / PI
local function vec3_dot(ax, ay, az, bx, by, bz)
    return ax * bx + ay * by + az * bz
end
local function Length(vec)
    return math.sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z)
end
local function rtd(radians)
    return radians * 180 / math.pi
end
local function pos2angle(vec1, vec2)
    local x = vec2.x - vec1.x
    local z = vec2.y - vec1.y
    local y = vec1.z - vec2.z

    return angle_t(-rtd(math.atan2(y, math.sqrt(x * x + z * z))), rtd(math.atan2(z, x)) + 180, 0)
end
local function vec3_normalize(x, y, z)
    local len = math.sqrt(x * x + y * y + z * z)
    if len == 0 then
        return 0, 0, 0
    end
    local r = 1 / len
    return x * r, y * r, z * r
end

local function angle_to_vec(pitch, yaw)
    local pitch_rad, yaw_rad = DEG_TO_RAD * pitch, DEG_TO_RAD * yaw
    local sp, cp, sy, cy = math.sin(pitch_rad), math.cos(pitch_rad), math.sin(yaw_rad), math.cos(yaw_rad)
    return cp * cy, cp * sy, -sp
end

local hitboxes = {
    "HEAD",
    "NECK",
    "PELVIS",
    "BODY",
    "THORAX",
    "CHEST"
}
local function is_player_vis(local_player, player)
    local vis_hitboxes = {}
    local is_visible = false
    for key, value in pairs(hitboxes) do
        if local_player:is_point_visible(player:get_hitbox_pos(e_hitboxes[value])) then
            if not is_visible then
                is_visible = true
            end
            table.insert(vis_hitboxes, value)
        end
    end

    return is_visible, vis_hitboxes
end
local function calculate_fov_to_player(ent, lx, ly, lz, fx, fy, fz)
    local px, py = ent:get_prop("m_vecOrigin").x, ent:get_prop("m_vecOrigin").y
    local dx, dy, dz = vec3_normalize(px - lx, py - ly, lz - lz)
    local dot_product = vec3_dot(dx, dy, dz, fx, fy, fz)
    local cos_inverse = math.acos(dot_product)
    return RAD_TO_DEG * cos_inverse
end
local function calculate_fov_to_point(px, py, pz, lx, ly, lz, fx, fy, fz)
    local dx, dy, dz = vec3_normalize(px - lx, py - ly, pz - lz)
    local dot_product = vec3_dot(dx, dy, dz, fx, fy, fz)
    local cos_inverse = math.acos(dot_product)
    return RAD_TO_DEG * cos_inverse
end

local function get_closest_player_to_crosshair(lx, ly, lz, pitch, yaw)
    local local_player = entity_list.get_local_player()
    local fx, fy, fz = angle_to_vec(pitch, yaw)
    local enemy_players = entity_list.get_players(true)

    local nearest_player = nil
    local nearest_player_fov = math.huge
    local nearest_player_hitbox = {}
    local nearest_hitbox_fov = math.huge
    local nearest_hitbox = nil
    for i = 1, #enemy_players do
        local enemy_ent = enemy_players[i]
        local is_vis, vis_hitbox = is_player_vis(local_player, enemy_ent)
        if is_vis then
            local fov_to_player = calculate_fov_to_player(enemy_ent, lx, ly, lz, fx, fy, fz)
            if fov_to_player <= nearest_player_fov then
                nearest_player = enemy_ent
                nearest_player_fov = fov_to_player
                nearest_player_hitbox = vis_hitbox
            end
            for key, value in pairs(vis_hitbox) do
                local cache_hitbox_pos = enemy_ent:get_hitbox_pos(e_hitboxes[value])
                local fov_to_hitbox =
                    calculate_fov_to_point(
                    cache_hitbox_pos.x,
                    cache_hitbox_pos.y,
                    cache_hitbox_pos.z,
                    lx,
                    ly,
                    lz,
                    fx,
                    fy,
                    fz
                )
                if fov_to_hitbox <= nearest_hitbox_fov then
                    nearest_hitbox_fov = fov_to_hitbox
                    nearest_hitbox = value
                end
            end
        end
    end
    return nearest_player, nearest_player_fov, nearest_hitbox_fov, nearest_hitbox, nearest_player_hitbox
end

local cache_angle = angle_t(0, 0, 0)
local puch_angle = angle_t(0, 0, 0)
local last_puch_angle = angle_t(0, 0, 0)
local final_puch_angle = angle_t(0, 0, 0)
local closest_player, closest_fov, closest_hitbox_fov, closest_hitbox = nil, nil, nil, nil
local function on_setup_cmd(cmd)
    local view_angles = engine.get_view_angles()
    local local_player = entity_list.get_local_player()
    local eye_pos = local_player:get_eye_position()

    closest_player, closest_fov, closest_hitbox_fov, closest_hitbox =
        get_closest_player_to_crosshair(
        eye_pos.x,
        eye_pos.y,
        eye_pos.z,
        view_angles.x + puch_angle.x,
        view_angles.y + puch_angle.y
    )
    
    if closest_player ~= nil and closest_player:is_alive() then
    local aim_angle = pos2angle(closest_player:get_hitbox_pos(e_hitboxes[closest_hitbox]), eye_pos)   
        if trigger_enable:get() and keybind:get() then
            if closest_hitbox_fov <= trigger_fov:get() then
                cmd.viewangles = aim_angle
                cmd:add_button(e_cmd_buttons.ATTACK)
            end
        elseif legit_bot_enable:get() then
       
            if legit_keybind:get() and closest_hitbox_fov<= legit_bot_fov:get()  then
                local puch_angle =
                angle_t(
                (local_player:get_prop("m_aimPunchAngle").x * (anti_recoil_x:get() / 100)) * 2,
                (local_player:get_prop("m_aimPunchAngle").y * (anti_recoil_y:get() / 100)) * 2,
                0
                )
                local relative_angle =
                    cmd:has_button(e_cmd_buttons.ATTACK) and view_angles - (normalize_angles(aim_angle-puch_angle )) or
                    view_angles - (normalize_angles(aim_angle))

                local unitAngle =
                    angle_t(relative_angle.x / Length(relative_angle), relative_angle.y / Length(relative_angle), 0)
                local smoothedAngle =
                    angle_t(
                    unitAngle.x / smooth:get() /
                        ((closest_hitbox_fov / legit_bot_fov:get()) * 100 < 2 and 2 / 100 or
                            closest_hitbox_fov / legit_bot_fov:get()),
                    unitAngle.y / smooth:get() /
                        ((closest_hitbox_fov / legit_bot_fov:get()) * 100 < 2 and 2 / 100 or
                            closest_hitbox_fov / legit_bot_fov:get()),
                    0
                )
                if (Length(smoothedAngle) > Length(relative_angle)) then
                    smoothedAngle = relative_angle
                end
                cache_angle = cache_angle+puch_angle   
                if not ((view_angles - smoothedAngle ).x ~=(view_angles - smoothedAngle ).x)  then
                set_view_angle(normalize_angles((view_angles - smoothedAngle )))
                end
            end
        end
    end
end
local function on_run_cmd(cmd)
    local local_player = entity_list.get_local_player()
    local view_angles = engine.get_view_angles()
    puch_angle =
    angle_t(
    (local_player:get_prop("m_aimPunchAngle").x * (anti_recoil_x:get() / 100)) * 2,
    (local_player:get_prop("m_aimPunchAngle").y * (anti_recoil_y:get() / 100)) * 2,
    0
    )
    if anti_recoil:get() then
        final_puch_angle = last_puch_angle - puch_angle
        last_puch_angle = puch_angle
    else
        final_puch_angle = angle_t(0, 0, 0)
    end
    if cmd:has_button(e_cmd_buttons.ATTACK) then
        set_view_angle(normalize_angles(view_angles + final_puch_angle))
    end
end
callbacks.add(e_callbacks.RUN_COMMAND, on_run_cmd)
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_cmd)