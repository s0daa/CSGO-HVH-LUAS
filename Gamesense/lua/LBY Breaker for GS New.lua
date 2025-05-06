--Discord: Mixologist#6105
local ffi, csgo_weapons = require("ffi"), require("gamesense/csgo_weapons")
local 
entity_get_local_player, entity_get_prop, entity_get_classname, entity_get_player_weapon, entity_hitbox_position, entity_get_players, entity_is_alive, entity_is_dormant, entity_is_enemy, entity_get_origin, entity_set_prop, ui_menu_position, ui_menu_size, ui_reference, ui_new_checkbox, ui_new_slider, ui_new_hotkey, ui_new_combobox, ui_new_color_picker, ui_set_visible, ui_get, ui_set, ui_is_menu_open, ui_new_label, ui_set_callback, ui_new_multiselect, client_screen_size, client_current_threat, client_find_signature, client_create_interface, client_set_event_callback, client_unset_event_callback, client_trace_line, client_random_int, client_userid_to_entindex, client_trace_bullet, client_scale_damage, client_eye_position, client_camera_angles, client_delay_call, client_key_state, client_latency, client_system_time, client_exec, globals_realtime, globals_curtime, globals_absoluteframetime, globals_frametime, globals_chokedcommands, globals_tickcount, renderer_rectangle, renderer_text, renderer_blur, renderer_indicator, renderer_circle_outline, renderer_fadebar , renderer_measure_text, renderer_line, renderer_world_to_screen, renderer_circle, math_floor, math_sqrt, math_abs, math_atan, math_atan2, math_max, math_deg, math_sin, math_cos, math_rad, math_pi, math_min, math_pow, math_random, ffi_cdef, ffi_cast, ffi_typeof = 
entity.get_local_player, entity.get_prop, entity.get_classname, entity.get_player_weapon, entity.hitbox_position, entity.get_players, entity.is_alive, entity.is_dormant, entity.is_enemy, entity.get_origin, entity.set_prop, ui.menu_position, ui.menu_size, ui.reference, ui.new_checkbox, ui.new_slider, ui.new_hotkey, ui.new_combobox, ui.new_color_picker, ui.set_visible, ui.get, ui.set, ui.is_menu_open, ui.new_label, ui.set_callback, ui.new_multiselect, client.screen_size, client.current_threat, client.find_signature, client.create_interface, client.set_event_callback, client.unset_event_callback, client.trace_line, client.random_int, client.userid_to_entindex, client.trace_bullet, client.scale_damage, client.eye_position, client.camera_angles, client.delay_call, client.key_state, client.latency, client.system_time, client.exec, globals.realtime, globals.curtime, globals.absoluteframetime, globals.frametime, globals.chokedcommands, globals.tickcount, renderer.rectangle, renderer.text, renderer.blur, renderer.indicator, renderer.circle_outline, renderer.gradient, renderer.measure_text, renderer.line, renderer.world_to_screen, renderer.circle, math.floor, math.sqrt, math.abs, math.atan, math.atan2, math.max, math.deg, math.sin, math.cos, math.rad, math.pi, math.min, math.pow, math.random, ffi.cdef, ffi.cast, ffi.typeof

local ref = {
    antiaim = ui_reference("AA", "Anti-aimbot angles", "Enabled"),
    roll = ui_reference("AA", "Anti-aimbot angles", "Roll"),
    is_qp = {ui_reference("RAGE", "Other", "Quick peek assist")},
    body_yaw = {ui_reference("AA", "Anti-aimbot angles", "Body yaw")}
}

local ent_state = {
    speed = function(ent) local speed = math_sqrt(math_pow(entity_get_prop(ent, "m_vecVelocity[0]"), 2) + math_pow(entity_get_prop(ent, "m_vecVelocity[1]"), 2)) return speed end,
    is_peeking = function() return (ui_get(ref.is_qp[1]) and ui_get(ref.is_qp[2])) end,
    is_ladder = function(ent) return (entity_get_prop(ent, "m_MoveType") or 0) == 9 end
}

--Roll in MM From pilot
local is_mm_state = 0
local game_rule = ffi_cast("intptr_t**", ffi_cast("intptr_t", client_find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")) + 2)[0]

--Menu Build
local lby_breaker = ui_new_checkbox("AA", "Anti-aimbot angles", "\aD6BE73FFLBY breaker", true)
local lby = {
    key = ui_new_hotkey("AA", "Anti-aimbot angles", "LBY break", true),
    body_inverter = ui_new_hotkey("AA", "Anti-aimbot angles", "- Desync Inverter"),
    desync = ui_new_slider("aa", "anti-aimbot angles", "Desync", 0, 65, 63),
    roll_enabled = ui_new_hotkey("AA", "Anti-aimbot angles", "\aD6BE73FFEnabled Roll"),
    roll_inverter = ui_new_hotkey("AA", "Anti-aimbot angles", "- Roll inverter"),
    roll = ui_new_slider("aa", "anti-aimbot angles", "Roll", -50, 50, 0)
}

local micro_move = function(cmd)
    local local_player = entity_get_local_player()
    if cmd.chokedcommands == 0 or ent_state.speed(local_player) > 2 or ent_state.is_peeking() or cmd.in_attack == 1 then return end

    cmd.forwardmove = 0.1
    cmd.in_forward = 1
end

local desync_func = function(cmd)
    if not ui_get(ref.antiaim) then return end
    if not (ui_get(lby_breaker) and ui_get(lby.key)) then return end

    local local_player = entity_get_local_player()
    local weapon = csgo_weapons[entity_get_prop(entity_get_player_weapon(local_player), "m_iItemDefinitionIndex")]

    if ent_state.is_ladder(local_player) then return end
    if weapon == nil or weapon.type == "grenade" then return end

    micro_move(cmd)
    --inverter
    local body_side = ui_get(lby.body_inverter) and ui_get(lby.desync) or -ui_get(lby.desync)

    if cmd.chokedcommands == 0 and cmd.in_attack ~= 1 then
        cmd.yaw = cmd.yaw - body_side
        cmd.allow_send_packet = false
    end

    --Spoofs Client to use Roll in MM
    local is_mm_value = ffi_cast("bool*", game_rule[0] + 124)
    if is_mm_value ~= nil then
        if ui_get(lby.roll_enabled) then
            ui_set(ref.roll, 0)
            cmd.roll = ui_get(lby.roll_inverter) and ui_get(lby.roll) or -ui_get(lby.roll)
            if is_mm_value[0] == true then
                is_mm_value[0] = 0
                is_mm_state = 1
            end
        else
            if is_mm_value[0] == false and is_mm_state == 1 then
                cmd.roll = 0
            end
        end
    end
end

local indicator_func = function()
    --inverter indicator
    if ui_get(lby.body_inverter) then
        renderer_indicator(214, 190, 115, 255, "Inverter")
    end
end

local menu_visible = function()
    for i, v in pairs(lby) do 
        ui_set_visible(v, ui_get(lby_breaker))
    end
end

menu_visible()

ui_set_callback(lby_breaker, function(e)
    menu_visible()
    local set_callback = ui_get(e) and client_set_event_callback or client_unset_event_callback

    set_callback("setup_command", desync_func)
    set_callback("paint", indicator_func)
end)

client_set_event_callback("shutdown", function()
    if globals.mapname() == nil then is_mm_state = 0 return end
    local is_mm_value = ffi_cast("bool*", game_rule[0] + 124)
    if is_mm_value ~= nil then
        if is_mm_value[0] == false and is_mm_state == 1 then
            is_mm_value[0] = 1
            is_mm_state = 0
        end
    end
end)
