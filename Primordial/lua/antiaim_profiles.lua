local slowwalk_key = menu.find("misc", "main", "movement", "slow walk")[2]
local onkey = menu.add_text("Enable / Disable angles", "Move Anti Aim angles"):add_keybind("onkey")
local onkey_pitch_Set = menu.add_checkbox("Enable / Disable angles", "Set pitch")
local onkey_pitch_mode = menu.add_selection("Enable / Disable angles", "pitch", {"none", "down", "up", "zero", "jitter"})
local air_pitch_Set = menu.add_checkbox("Air Anti Aim angles", "Set pitch")
local air_pitch_mode = menu.add_selection("Air Anti Aim angles", "pitch", {"none", "down", "up", "zero", "jitter"})
local slow_pitch_Set = menu.add_checkbox("Slowwalk Anti Aim angles", "Set pitch")
local slow_pitch_mode = menu.add_selection("Slowwalk Anti Aim angles", "pitch", {"none", "down", "up", "zero", "jitter"})
local standing_pitch_Set = menu.add_checkbox("Standing Anti Aim angles", "Set pitch")
local standing_pitch_mode = menu.add_selection("Standing Anti Aim angles", "pitch", {"none", "down", "up", "zero", "jitter"})
local config_pitch_mode = menu.find("antiaim", "main", "angles", "pitch")

local onkey_yaw_Set = menu.add_checkbox("Enable / Disable angles", "Set yaw")
local onkey_yaw_base = menu.add_selection("Enable / Disable angles", "yaw base", {"none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity"})
local onkey_yaw_add = menu.add_slider("Enable / Disable angles", "yaw add", -180, 180, 1, 0.1, "°")
local air_yaw_Set = menu.add_checkbox("Air Anti Aim angles", "Set yaw")
local air_yaw_base = menu.add_selection("Air Anti Aim angles", "yaw base", {"none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity"})
local air_yaw_add = menu.add_slider("Air Anti Aim angles", "yaw add", -180, 180, 1, 0.1, "°")
local slow_yaw_Set = menu.add_checkbox("Slowwalk Anti Aim angles", "Set yaw")
local slow_yaw_base = menu.add_selection("Slowwalk Anti Aim angles", "yaw base", {"none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity"})
local slow_yaw_add = menu.add_slider("Slowwalk Anti Aim angles", "yaw add", -180, 180, 1, 0.1, "°")
local standing_yaw_Set = menu.add_checkbox("Standing Anti Aim angles", "Set yaw")
local standing_yaw_base = menu.add_selection("Standing Anti Aim angles", "yaw base", {"none", "viewangle", "at target (crosshair)", "at target (distance)", "velocity"})
local standing_yaw_add = menu.add_slider("Standing Anti Aim angles", "yaw add", -180, 180, 1, 0.1, "°")
local config_yaw_base = menu.find("antiaim", "main", "angles", "yaw base")
local config_yaw_add = menu.find("antiaim", "main", "angles", "yaw add")

local onkey_rotate_Set = menu.add_checkbox("Enable / Disable angles", "Set rotate", false)
local onkey_rotate_range = menu.add_slider("Enable / Disable angles", "air rotate range", 0, 180, 1, 0.1)
local onkey_rotate_speed = menu.add_slider("Enable / Disable angles", "air rotate speed", 0, 100, 1, 0.1, "%")
local air_rotate_Set = menu.add_checkbox("Air Anti Aim angles", "Set rotate", false)
local air_rotate_range = menu.add_slider("Air Anti Aim angles", "air rotate range", 0, 180, 1, 0.1)
local air_rotate_speed = menu.add_slider("Air Anti Aim angles", "air rotate speed", 0, 100, 1, 0.1, "%")
local slow_rotate_Set = menu.add_checkbox("Slowwalk Anti Aim angles", "Set rotate", false)
local slow_rotate_range = menu.add_slider("Slowwalk Anti Aim angles", "rotate range", 0, 180, 1, 0.1)
local slow_rotate_speed = menu.add_slider("Slowwalk Anti Aim angles", "rotate speed", 0, 100, 1, 0.1, "%")
local standing_rotate_Set = menu.add_checkbox("Standing Anti Aim angles", "Set rotate", false)
local standing_rotate_range = menu.add_slider("Standing Anti Aim angles", "rotate range", 0, 180, 1, 0.1)
local standing_rotate_speed = menu.add_slider("Standing Anti Aim angles", "rotate speed", 0, 100, 1, 0.1, "%")
local config_rotate_enabled = menu.find("antiaim", "main", "angles", "rotate")
local config_rotate_range = menu.find("antiaim", "main", "angles", "rotate range")
local config_rotate_speed = menu.find("antiaim", "main", "angles", "rotate speed")

local onkey_jitter_Set = menu.add_checkbox("Enable / Disable angles", "Set jitter", false)
local onkey_jitter_mode = menu.add_selection("Enable / Disable angles", "jitter mode", {"none", "static", "random"})
local onkey_jitter_add = menu.add_slider("Enable / Disable angles", "jitter add", -180, 180, 1, 0.1)
local air_jitter_Set = menu.add_checkbox("Air Anti Aim angles", "Set jitter", false)
local air_jitter_mode = menu.add_selection("Air Anti Aim angles", "jitter mode", {"none", "static", "random"})
local air_jitter_add = menu.add_slider("Air Anti Aim angles", "jitter add", -180, 180, 1, 0.1)
local slow_jitter_Set = menu.add_checkbox("Slowwalk Anti Aim angles", "Set jitter", false)
local slow_jitter_mode = menu.add_selection("Slowwalk Anti Aim angles", "jitter mode", {"none", "static", "random"})
local slow_jitter_add = menu.add_slider("Slowwalk Anti Aim angles", "jitter add", -180, 180, 1, 0.1)
local standing_jitter_Set = menu.add_checkbox("Standing Anti Aim angles", "Set jitter", false)
local standing_jitter_mode = menu.add_selection("Standing Anti Aim angles", "jitter mode", {"none", "static", "random"})
local standing_jitter_add = menu.add_slider("Standing Anti Aim angles", "jitter add", -180, 180, 1, 0.1)
local config_jitter_mode = menu.find("antiaim", "main", "angles", "jitter mode")
local config_jitter_add = menu.find("antiaim", "main", "angles", "jitter add")

local onkey_fakelag_Set = menu.add_checkbox("Enable / Disable angles", "Set fakelag")
local onkey_fakelag_amount = menu.add_slider("Enable / Disable angles", "fakelag", 0, 15, 1, 0.1, " ticks")
local air_fakelag_Set = menu.add_checkbox("Air Anti Aim angles", "Set fakelag")
local air_fakelag_amount = menu.add_slider("Air Anti Aim angles", "fakelag", 0, 15, 1, 0.1, " ticks")
local slow_fakelag_Set = menu.add_checkbox("Slowwalk Anti Aim angles", "Set fakelag")
local slow_fakelag_amount = menu.add_slider("Slowwalk Anti Aim angles", "fakelag", 0, 15, 1, 0.1, " ticks")
local standing_fakelag_Set = menu.add_checkbox("Standing Anti Aim angles", "Set fakelag")
local standing_fakelag_amount = menu.add_slider("Standing Anti Aim angles", "fakelag", 0, 15, 1, 0.1, " ticks")
local config_fakelag_amount = menu.find("antiaim", "main", "fakelag", "amount")

local originals = {
    pitch_mode = config_pitch_mode:get(),
    yaw_base = config_yaw_base:get(),
    yaw_add = config_yaw_add:get(),
    jitter_mode = config_jitter_mode:get(),
    jitter_add = config_jitter_add:get(),
    rotate_enabled = config_rotate_enabled:get(),
    rotate_speed = config_rotate_speed:get(),
    rotate_range = config_rotate_range:get(),
    fakelag = config_fakelag_amount:get()
}

local values_reset = true

local function get_state()
    if onkey:get() then 
        return 0
    elseif not entity_list.get_local_player():has_player_flag(e_player_flags.ON_GROUND) and not slowwalk_key:get() and (entity_list.get_local_player():get_prop("m_vecVelocity").x ~= 0 and entity_list.get_local_player():get_prop("m_vecVelocity").y ~= 0) then
        return 1
    elseif entity_list.get_local_player():get_prop("m_vecVelocity").x == 0 and entity_list.get_local_player():get_prop("m_vecVelocity").y == 0 then
        return 2
    elseif slowwalk_key:get() then
        return 3
    end
end

local function apply_onkey()
    if onkey_fakelag_Set:get() then
        config_fakelag_amount:set(onkey_fakelag_amount:get())
    end

    if onkey_pitch_Set:get() then
        config_pitch_mode:set(onkey_pitch_mode:get())
    end

    if onkey_yaw_Set:get() then
        config_yaw_base:set(onkey_yaw_base:get())
        config_yaw_add:set(onkey_yaw_add:get())
    end

    if onkey_jitter_Set:get() then 
        config_jitter_mode:set(onkey_jitter_mode:get())
        config_jitter_add:set(onkey_jitter_add:get())
    end

    if onkey_rotate_Set:get() then
        config_rotate_enabled:set(true)
        config_rotate_range:set(onkey_rotate_range:get())
        config_rotate_speed:set(onkey_rotate_speed:get()) 
    end
end

local function apply_air()
    if air_fakelag_Set:get() then
        config_fakelag_amount:set(air_fakelag_amount:get())
    end

    if air_pitch_Set:get() then
        config_pitch_mode:set(air_pitch_mode:get())
    end

    if air_yaw_Set:get() then
        config_yaw_base:set(air_yaw_base:get())
        config_yaw_add:set(air_yaw_add:get())
    end

    if air_jitter_Set:get() then 
        config_jitter_mode:set(air_jitter_mode:get())
        config_jitter_add:set(air_jitter_add:get())
    end

    if air_rotate_Set:get() then
        config_rotate_enabled:set(true)
        config_rotate_range:set(air_rotate_range:get())
        config_rotate_speed:set(air_rotate_speed:get()) 
    end
end

local function apply_standing()
    if standing_fakelag_Set:get() then
        config_fakelag_amount:set(standing_fakelag_amount:get())
    end

    if standing_pitch_Set:get() then
        config_pitch_mode:set(standing_pitch_mode:get())
    end

    if standing_yaw_Set:get() then
        config_yaw_base:set(standing_yaw_base:get())
        config_yaw_add:set(standing_yaw_add:get())
    end

    if standing_jitter_Set:get() then 
        config_jitter_mode:set(standing_jitter_mode:get())
        config_jitter_add:set(standing_jitter_add:get())
    end

    if standing_rotate_Set:get() then
        config_rotate_enabled:set(true)
        config_rotate_range:set(standing_rotate_range:get())
        config_rotate_speed:set(standing_rotate_speed:get()) 
    end
end

local function apply_slowwalk()
    if slow_fakelag_Set:get() then
        config_fakelag_amount:set(slow_fakelag_amount:get())
    end

    if slow_pitch_Set:get() then
        config_pitch_mode:set(slow_pitch_mode:get())
    end

    if slow_yaw_Set:get() then
        config_yaw_base:set(slow_yaw_base:get())
        config_yaw_add:set(slow_yaw_add:get())
    end

    if slow_jitter_Set:get() then 
        config_jitter_mode:set(slow_jitter_mode:get())
        config_jitter_add:set(slow_jitter_add:get())
    end

    if slow_rotate_Set:get() then
        config_rotate_enabled:set(true)
        config_rotate_range:set(slow_rotate_range:get())
        config_rotate_speed:set(slow_rotate_speed:get()) 
    end
end

local function on_aintiaim()
    if menu.is_open() then return end
    local player_state = get_state()

    if player_state == 0 then 
        values_reset = false
        apply_onkey()
    elseif player_state == 1 then
        values_reset = false
        apply_air()
    elseif player_state == 2 then
        values_reset = false
        apply_standing()
    elseif player_state == 3 then
        values_reset = false
        apply_slowwalk()
    elseif not values_reset then
        config_pitch_mode:set(originals.pitch_mode)
        config_yaw_base:set(originals.yaw_base)
        config_yaw_add:set(originals.yaw_add)
        config_jitter_mode:set(originals.jitter_mode)
        config_jitter_add:set(originals.jitter_add)
        config_rotate_enabled:set(originals.rotate_enabled)
        config_rotate_range:set(originals.rotate_range)
        config_rotate_speed:set(originals.rotate_speed)
        config_fakelag_amount:set(originals.fakelag)
        values_reset = true
    end
end

local function onkey_visibility()
    onkey_pitch_mode:set_visible(onkey_pitch_Set:get())
    onkey_yaw_add:set_visible(onkey_yaw_Set:get())
    onkey_yaw_base:set_visible(onkey_yaw_Set:get())
    onkey_jitter_add:set_visible(onkey_jitter_Set:get())
    onkey_jitter_mode:set_visible(onkey_jitter_Set:get())
    onkey_rotate_range:set_visible(onkey_rotate_Set:get())
    onkey_rotate_speed:set_visible(onkey_rotate_Set:get())
    onkey_fakelag_amount:set_visible(onkey_fakelag_Set:get())
end

local function air_visibility()
    air_pitch_mode:set_visible(air_pitch_Set:get())
    air_yaw_add:set_visible(air_yaw_Set:get())
    air_yaw_base:set_visible(air_yaw_Set:get())
    air_jitter_add:set_visible(air_jitter_Set:get())
    air_jitter_mode:set_visible(air_jitter_Set:get())
    air_rotate_range:set_visible(air_rotate_Set:get())
    air_rotate_speed:set_visible(air_rotate_Set:get())
    air_fakelag_amount:set_visible(air_fakelag_Set:get())
end

local function slow_visibility()
    slow_pitch_mode:set_visible(slow_pitch_Set:get())
    slow_yaw_add:set_visible(slow_yaw_Set:get())
    slow_yaw_base:set_visible(slow_yaw_Set:get())
    slow_jitter_add:set_visible(slow_jitter_Set:get())
    slow_jitter_mode:set_visible(slow_jitter_Set:get())
    slow_rotate_range:set_visible(slow_rotate_Set:get())
    slow_rotate_speed:set_visible(slow_rotate_Set:get())
    slow_fakelag_amount:set_visible(slow_fakelag_Set:get())
end

local function standing_visibility()
    standing_pitch_mode:set_visible(standing_pitch_Set:get())
    standing_yaw_add:set_visible(standing_yaw_Set:get())
    standing_yaw_base:set_visible(standing_yaw_Set:get())
    standing_jitter_add:set_visible(standing_jitter_Set:get())
    standing_jitter_mode:set_visible(standing_jitter_Set:get())
    standing_rotate_range:set_visible(standing_rotate_Set:get())
    standing_rotate_speed:set_visible(standing_rotate_Set:get())
    standing_fakelag_amount:set_visible(standing_fakelag_Set:get())
end

local function on_paint()
    if menu.is_open() then
        originals = {
            pitch_mode = config_pitch_mode:get(),
            yaw_base = config_yaw_base:get(),
            yaw_add = config_yaw_add:get(),
            jitter_mode = config_jitter_mode:get(),
            jitter_add = config_jitter_add:get(),
            rotate_enabled = config_rotate_enabled:get(),
            rotate_speed = config_rotate_speed:get(),
            rotate_range = config_rotate_range:get(),
            fakelag = config_fakelag_amount:get()
        }
    end
    onkey_visibility()
    air_visibility()
    slow_visibility()
    standing_visibility()
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.ANTIAIM, on_aintiaim)