-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local switch = false

local _switch = ui.find("Aimbot", "Anti\x20Aim", "Angles"):switch(string.format("\a%s%s", "B6B666FF", "Straight\x20Throw"))

_switch:set_callback(function (ref)
    switch = ref:get()
end, true)

local st = {}

st.active = false
st.check_active = function()
    st.active = false
    if switch ~=true then
        return
    end
    local local_player = entity.get_local_player()
    if local_player == nil then
        return
    end
    if local_player:is_alive() == false then
        return
    end
    if local_player.m_MoveType == 8 then
        return
    end
    local weapon = local_player:get_player_weapon()
    if weapon == nil then
        return
    end
    local weapon_info = weapon:get_weapon_info()
    if weapon_info == nil then
        return
    end
    if weapon_info.weapon_type ~= 9 then
        return
    end
    st.active = true
end

ffi.cdef([[
    typedef struct {
        float x;
        float y;
        float z;
    } vector_t;
]])

st.ang_vec = function(ang) 
    return vector(math.cos(ang.x * math.pi / 180) * math.cos(ang.y * math.pi / 180), math.cos(ang.x * math.pi / 180) * math.sin(ang.y * math.pi / 180), -math.sin(ang.x * math.pi / 180))
end

st.last_angles = vector(0, 0, 0)
st.target_angles = vector(0, 0, 0)

st.on_pre_render = function()
    st.check_active()
    st.last_angles = render.camera_angles()
    if st.active == true and common.is_in_thirdperson() == false then
        render.camera_angles(st.target_angles)
    end
end
st.on_override_view = function(zv)
    if st.active == true then
        zv.view = st.last_angles
        render.camera_angles(st.last_angles)
    end
end
st.on_createmove = function(cmd)
    if st.active ~= true then
        return
    end
    local local_player = entity.get_local_player()
    if local_player == nil then
        return
    end
    if local_player:is_alive() == false then
        return
    end
    local weapon = local_player:get_player_weapon()
    if weapon == nil then
        return
    end
    local weapon_info = weapon:get_weapon_info()
    if weapon_info == nil then
        return
    end

    local lp_addr = ffi.cast("uintptr_t", local_player[0])

    local ang_throw = vector(cmd.view_angles.x, cmd.view_angles.y, 0)
    ang_throw.x = ang_throw.x - (90 - math.abs(ang_throw.x)) * 10 / 90
    ang_throw = st.ang_vec(ang_throw)

    local throw_strength = math.clamp(weapon.m_flThrowStrength, 0, 1)
    local fl_velocity = math.clamp(weapon_info.throw_velocity * 0.9, 15, 750)
    fl_velocity = fl_velocity * (throw_strength * 0.7 + 0.3)

    local localplayer_velocity = ffi.cast("vector_t*", lp_addr + 0x94)[0]
    localplayer_velocity = vector(localplayer_velocity.x, localplayer_velocity.y, localplayer_velocity.z)
    local vec_throw = (ang_throw * fl_velocity + localplayer_velocity * 1.45)
    vec_throw = vec_throw:angles()
    local yaw_difference = cmd.view_angles.y - vec_throw.y
    while yaw_difference > 180 do
        yaw_difference = yaw_difference - 360
    end
    while yaw_difference < -180 do
        yaw_difference = yaw_difference + 360
    end
    local pitch_difference = cmd.view_angles.x - vec_throw.x - 10
    while pitch_difference > 90 do
        pitch_difference = pitch_difference - 45
    end
    while pitch_difference < -90 do
        pitch_difference = pitch_difference + 45
    end
    st.target_angles.y = cmd.view_angles.y + yaw_difference
    cmd.view_angles.y = cmd.view_angles.y + yaw_difference
    st.target_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
    cmd.view_angles.x = math.clamp(cmd.view_angles.x + pitch_difference, -89, 89)
end

events.pre_render:set(st.on_pre_render)
events.override_view:set(st.on_override_view)
events.createmove:set(st.on_createmove)