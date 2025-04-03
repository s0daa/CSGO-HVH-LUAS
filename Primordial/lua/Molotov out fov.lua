local function rotate_angle(cx, cy, deg, distance, xmp, ymp)
    local viewAngles = engine.get_view_angles()

    deg = math.rad(deg - viewAngles.y)

    local x = math.sin(deg) * distance * xmp
    local y = math.cos(deg) * distance * ymp

    x = cx - x
    y = cy - y

    return { x, y }
end

local function normalize_yaw(angle)
    angle = (angle % 360 + 360) % 360
    return angle > 180 and angle - 360 or angle
end

local function calculate_yaw(src, to)
    local delta = { src.x - to.x, src.y - to.y }
    local yaw = math.atan(delta[2] / delta[1])
    yaw = normalize_yaw(yaw * 180 / math.pi)

    if delta[1] >= 0 then yaw = normalize_yaw(yaw + 180) end

    return yaw
end

local function world_point_visible(origin)
    local screen_size = render.get_screen_size()
    local w2s = render.world_to_screen(origin)

    if w2s == nil then return false end

    if w2s.x < 0 or w2s.x > screen_size.x or w2s.y < 0 or w2s.y > screen_size.y then
        return false
    else
        return true
    end
end

function math.lerp(name, value, speed)
    return name + (value - name) * globals.frame_time() * speed
end

local screen_size = render.get_screen_size()
local default_font = render.get_default_font()

local anim = {}

callbacks.add(e_callbacks.PAINT, function()
    local button, color, color2 = unpack(menu.find("visuals", "esp", "items", "danger warning"))
    
    if not engine.is_in_game() then return end

    local molotovs = entity_list.get_entities_by_classid(100)
    for i = 1, #molotovs do
        local entity = molotovs[i]

        local thrower = entity:get_prop("m_hOwnerEntity")
        local vec_origin = entity:get_prop("m_vecOrigin")

        local item = vec_origin.x + vec_origin.y + vec_origin.z
        if not anim[item] then anim[item] = 0 end

        if world_point_visible(vec_origin) then return end

        local molotov_tick = entity:get_prop("m_nFireEffectTickBegin")
        local molotov_time = 7.03125 - globals.interval_per_tick() * (globals.tick_count() - molotov_tick)
        
        if molotov_time < 0.3 then
            anim[item] = math.lerp(anim[item], 0, 10)
        end

        local local_player = entity_list.get_local_player()
        local origin = local_player:get_render_origin()

        local yaw = calculate_yaw(origin, vec_origin)
        local pointer = rotate_angle(screen_size.x / 2, screen_size.y / 2, yaw, 300, 1, 1.2)

        local w2s = vec2_t(pointer[1], pointer[2])
        if w2s == nil then return end

        local distance = math.floor(vec_origin:dist(origin) / 12)

        if distance > 40 then
            anim[item] = math.lerp(anim[item], 0, 10)
        else
            anim[item] = math.lerp(anim[item], 255, 10)
        end

        alpha = anim[item] / 255

        render.push_alpha_modifier(alpha)

        render.rect_filled(vec2_t(w2s.x - 30, w2s.y - 30), vec2_t(60, 60), color_t(0, 0, 0, 70), 10)

        render.push_clip(vec2_t(0, w2s.y - 30 + (60 * ((7.03125 - molotov_time) / 7.03125))), vec2_t(screen_size.x, screen_size.y))
        render.rect(vec2_t(w2s.x - 30, w2s.y - 30), vec2_t(60, 60), color:get(), 10)
        render.pop_clip()

        render.weapon_icon(e_items.WEAPON_MOLOTOV, vec2_t(w2s.x, w2s.y - 10), color:get(), true)
        render.text(default_font, distance .. "ft", vec2_t(w2s.x, w2s.y + 16), color_t(255, 255, 255), true)

        render.pop_alpha_modifier()
    end
end)