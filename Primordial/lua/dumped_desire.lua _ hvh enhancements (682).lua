local lua_ver = "1.4"

local groups = {
    main = "Main",
    ragebot = "Rage",
    antiaim = "Anti-Aim",
    misc = "Misc",
    animations = "Animations",
    notifications = "Notifications",
    server_connect = "Servers",
}

menu.add_text(groups.main, "Desire.lua")
menu.add_text(groups.main, "Version " .. lua_ver)
menu.add_text(groups.main, "User: " .. user.name)
menu.add_text(groups.main, "UID: " .. user.uid)

menu.add_text(groups.server_connect, "Desires HvH Servers [EU]")

menu.add_button(groups.server_connect, "Desire's HvH Server (no awp or roll)", function()
    engine.execute_cmd("connect 94.156.128.92:27015")
end)

menu.add_button(groups.server_connect, "Desire's HvH Server (awp and roll)", function()
    engine.execute_cmd("connect 94.156.128.92:27018")
end)

local menu_vars = {
    rage_jump_scout_modifiers = menu.add_checkbox(groups.ragebot, "Jumpscout Modifiers"),
    rage_jump_scout_hitchance = menu.add_slider(groups.ragebot, "Jumpscout Hitchance", 0, 100),
    rage_jump_scout_mindmg = menu.add_slider(groups.ragebot, "Jumpscout Min Damage", 0, 100),
    rage_safe_ideal_tick = menu.add_checkbox(groups.ragebot, "Safe Ideal Tick"),

    rage_doubletap_enhancements = menu.add_checkbox(groups.ragebot, "Doubletap Enhancements", false),
    rage_doubletap_enhancements_main_ticks_mode = menu.add_selection(groups.ragebot, "Mode", {"dynamic", "custom"}),
    rage_doubletap_enhancements_speed_calculation_mode = menu.add_selection(groups.ragebot, "Speed Calculation", {"aggresive", "hold", "dynamic"}),
    rage_doubletap_enhancements_custom_speed = menu.add_slider(groups.ragebot, "Doubletap Speed", 5, 17),
    
    notification_animation = menu.add_selection(groups.notifications, "Notification Animation", {"Stack & Fly", "Come & Go"}),
    notification_animation_speed = menu.add_slider(groups.notifications, "Notification Animation Speed", 4, 10),

    aimbot_notifications = menu.add_checkbox(groups.notifications, "Aimbot Notifications"),
    aimbot_notifications_select = menu.add_multi_selection(groups.notifications, "Notifications", {"Hit", "Miss"}),

    custom_watermark = menu.add_checkbox(groups.misc, "Watermark", true),

    tick_walk = menu.add_checkbox(groups.misc, "Tick Walk"),
    tick_walk_mode = menu.add_selection(groups.misc, "Tick Walk Mode", {"Normal", "Break", "Custom"}),
    tick_walk_ticks_to_freeze = menu.add_slider(groups.misc, "Ticks To Freeze", 10, 80),
    tick_walk_ticks_to_move = menu.add_slider(groups.misc, "Ticks To Move", 5, 75),

    custom_autopeek = menu.add_checkbox(groups.misc, "Custom Autopeek Circle"),
    custom_autopeek_mode = menu.add_selection(groups.misc, "Custom Autopeek Render", {"Pentagram", "Ball"}),

    custom_world_hitmarker = menu.add_checkbox(groups.misc, "Custom World Hitmarker"),
    custom_world_hitmarker_mode = menu.add_selection(groups.misc, "Custom World Hitmarker Render", {"Circle", "Triangle"}),
    custom_world_damage_text = menu.add_selection(groups.misc, "Custom World Damage Font", {"Verdana", "Tahoma", "Courier New", "Segoe UI"}),

    custom_clantag = menu.add_checkbox(groups.misc, "Custom Clantag"),
    custom_clantag_mode = menu.add_selection(groups.misc, "Clantag Select", {"desire.lua (static)", "desire.lua", "gamesense", "primordial with uid", "primordial uid (static)", "aimware"}),

    indicators_select = menu.add_multi_selection(groups.misc, "Indicators", {"Slow Walk", "Fakeduck", "Autopeek", "Hitchance", "Min. Damage", "Doubletap", "Hideshots", "Real Yaw", "Fake Yaw", "Lean Yaw"}),

    animation_on_move = menu.add_multi_selection(groups.animations, "On Move", {"Moon Walk"}),
    animation_in_air = menu.add_multi_selection(groups.animations, "In Air", {"Static Legs", "Strafe Legs", "Lean With Strafe"}),
    animation_on_land = menu.add_multi_selection(groups.animations, "On Land", {"Zero Pitch", "Freeze Legs"}),

    enable_custom_antiaim = menu.add_checkbox(groups.antiaim, "Enable Custom Antiaim"),
    custom_antiaim_anti_prediction_pitch = menu.add_checkbox(groups.antiaim, "Anti Prediction"),
    custom_antiaim_anti_prediction_spin = menu.add_checkbox(groups.antiaim, "Anti Prediction Spin"),
    custom_antiaim_anti_prediction_pitch_triggers = menu.add_multi_selection(groups.antiaim, "Anti Prediction Trigger", {"While Jumping", "While Running"}),

    custom_antiaim_movement_type = menu.add_selection(groups.antiaim, "Stage", {"Stand", "Move", "Air", "Slow Walk", "Crouch", "Air Crouch"}),

    custom_antiaim_stand_pitch = menu.add_selection(groups.antiaim, "[Stand] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_stand_yaw_base = menu.add_selection(groups.antiaim, "[Stand] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_stand_yaw_add = menu.add_slider(groups.antiaim, "[Stand] Yaw Add", -180, 180),
    custom_antiaim_stand_rotate = menu.add_checkbox(groups.antiaim, "[Stand] Rotate"),
    custom_antiaim_stand_rotate_range = menu.add_slider(groups.antiaim, "[Stand] Rotate Range", 0, 360),
    custom_antiaim_stand_rotate_speed = menu.add_slider(groups.antiaim, "[Stand] Rotate Speed", 0, 100),
    custom_antiaim_stand_jitter_mode = menu.add_selection(groups.antiaim, "[Stand] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_stand_jitter_type = menu.add_selection(groups.antiaim, "[Stand] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_stand_skitter = menu.add_checkbox(groups.antiaim, "[Stand] Skitter"),
    custom_antiaim_stand_jitter_add = menu.add_slider(groups.antiaim, "[Stand] Jitter Add", -180, 180),

    custom_antiaim_stand_desync_side_stand = menu.add_selection(groups.antiaim, "[Stand] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_stand_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Stand] Desync Left Amount", 0, 100),
    custom_antiaim_stand_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Stand] Desync Right Amount", 0, 100),

    custom_antiaim_move_pitch = menu.add_selection(groups.antiaim, "[Move] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_move_yaw_base = menu.add_selection(groups.antiaim, "[Move] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_move_yaw_add = menu.add_slider(groups.antiaim, "[Move] Yaw Add", -180, 180),
    custom_antiaim_move_rotate = menu.add_checkbox(groups.antiaim, "[Move] Rotate"),
    custom_antiaim_move_rotate_range = menu.add_slider(groups.antiaim, "[Move] Rotate Range", 0, 360),
    custom_antiaim_move_rotate_speed = menu.add_slider(groups.antiaim, "[Move] Rotate Speed", 0, 100),
    custom_antiaim_move_jitter_mode = menu.add_selection(groups.antiaim, "[Move] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_move_jitter_type = menu.add_selection(groups.antiaim, "[Move] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_move_skitter = menu.add_checkbox(groups.antiaim, "[Move] Skitter"),
    custom_antiaim_move_jitter_add = menu.add_slider(groups.antiaim, "[Move] Jitter Add", -180, 180),

    custom_antiaim_move_desync_side_stand =menu.add_selection(groups.antiaim, "[Move] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_move_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Move] Desync Left Amount", 0, 100),
    custom_antiaim_move_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Move] Desync Right Amount", 0, 100),

    custom_antiaim_air_pitch = menu.add_selection(groups.antiaim, "[Air] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_air_yaw_base = menu.add_selection(groups.antiaim, "[Air] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_air_yaw_add = menu.add_slider(groups.antiaim, "[Air] Yaw Add", -180, 180),
    custom_antiaim_air_rotate = menu.add_checkbox(groups.antiaim, "[Air] Rotate"),
    custom_antiaim_air_rotate_range = menu.add_slider(groups.antiaim, "[Air] Rotate Range", 0, 360),
    custom_antiaim_air_rotate_speed = menu.add_slider(groups.antiaim, "[Air] Rotate Speed", 0, 100),
    custom_antiaim_air_jitter_mode = menu.add_selection(groups.antiaim, "[Air] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_air_jitter_type = menu.add_selection(groups.antiaim, "[Air] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_air_skitter = menu.add_checkbox(groups.antiaim, "[Air] Skitter"),
    custom_antiaim_air_jitter_add = menu.add_slider(groups.antiaim, "[Air] Jitter Add", -180, 180),

    custom_antiaim_air_desync_side_stand = menu.add_selection(groups.antiaim, "[Air] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_air_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Air] Desync Left Amount", 0, 100),
    custom_antiaim_air_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Air] Desync Right Amount", 0, 100),

    custom_antiaim_slowwalk_pitch = menu.add_selection(groups.antiaim, "[Slow Walk] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_slowwalk_yaw_base = menu.add_selection(groups.antiaim, "[Slow Walk] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_slowwalk_yaw_add = menu.add_slider(groups.antiaim, "[Slow Walk] Yaw Add", -180, 180),
    custom_antiaim_slowwalk_rotate = menu.add_checkbox(groups.antiaim, "[Slow Walk] Rotate"),
    custom_antiaim_slowwalk_rotate_range = menu.add_slider(groups.antiaim, "[Slow Walk] Rotate Range", 0, 360),
    custom_antiaim_slowwalk_rotate_speed = menu.add_slider(groups.antiaim, "[Slow Walk] Rotate Speed", 0, 100),
    custom_antiaim_slowwalk_jitter_mode = menu.add_selection(groups.antiaim, "[Slow Walk] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_slowwalk_jitter_type = menu.add_selection(groups.antiaim, "[Slow Walk] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_slowwalk_skitter = menu.add_checkbox(groups.antiaim, "[Slow Walk] Skitter"),
    custom_antiaim_slowwalk_jitter_add = menu.add_slider(groups.antiaim, "[Slow Walk] Jitter Add", -180, 180),

    custom_antiaim_slowwalk_desync_side_stand = menu.add_selection(groups.antiaim, "[Slow Walk] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_slowwalk_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Slow Walk] Desync Left Amount", 0, 100),
    custom_antiaim_slowwalk_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Slow Walk] Desync Right Amount", 0, 100),

    custom_antiaim_crouch_pitch = menu.add_selection(groups.antiaim, "[Crouch] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_crouch_yaw_base = menu.add_selection(groups.antiaim, "[Crouch] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_crouch_yaw_add = menu.add_slider(groups.antiaim, "[Crouch] Yaw Add", -180, 180),
    custom_antiaim_crouch_rotate = menu.add_checkbox(groups.antiaim, "[Crouch] Rotate"),
    custom_antiaim_crouch_rotate_range = menu.add_slider(groups.antiaim, "[Crouch] Rotate Range", 0, 360),
    custom_antiaim_crouch_rotate_speed = menu.add_slider(groups.antiaim, "[Crouch] Rotate Speed", 0, 100),
    custom_antiaim_crouch_jitter_mode = menu.add_selection(groups.antiaim, "[Crouch] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_crouch_jitter_type = menu.add_selection(groups.antiaim, "[Crouch] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_crouch_skitter = menu.add_checkbox(groups.antiaim, "[Crouch] Skitter"),
    custom_antiaim_crouch_jitter_add = menu.add_slider(groups.antiaim, "[Crouch] Jitter Add", -180, 180),

    custom_antiaim_crouch_desync_side_stand = menu.add_selection(groups.antiaim, "[Crouch] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_crouch_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Crouch] Desync Left Amount", 0, 100),
    custom_antiaim_crouch_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Crouch] Desync Right Amount", 0, 100),

    custom_antiaim_air_crouch_pitch = menu.add_selection(groups.antiaim, "[Air Crouch] Pitch", {"None", "Down", "Up", "Zero", "Jitter"}),
    custom_antiaim_air_crouch_yaw_base = menu.add_selection(groups.antiaim, "[Air Crouch] Yaw Base", {"None", "Viewangle", "At Target (Crosshair)", "At Target (Distance)", "Velocity"}),
    custom_antiaim_air_crouch_yaw_add = menu.add_slider(groups.antiaim, "[Air Crouch] Yaw Add", -180, 180),
    custom_antiaim_air_crouch_rotate = menu.add_checkbox(groups.antiaim, "[Air Crouch] Rotate"),
    custom_antiaim_air_crouch_rotate_range = menu.add_slider(groups.antiaim, "[Air Crouch] Rotate Range", 0, 360),
    custom_antiaim_air_crouch_rotate_speed = menu.add_slider(groups.antiaim, "[Air Crouch] Rotate Speed", 0, 100),
    custom_antiaim_air_crouch_jitter_mode = menu.add_selection(groups.antiaim, "[Air Crouch] Jitter Mode", {"None", "Static", "Random"}),
    custom_antiaim_air_crouch_jitter_type = menu.add_selection(groups.antiaim, "[Air Crouch] Jitter Type", {"Offset", "Center"}),
    custom_antiaim_air_crouch_skitter = menu.add_checkbox(groups.antiaim, "[Air Crouch] Skitter"),
    custom_antiaim_air_crouch_jitter_add = menu.add_slider(groups.antiaim, "[Air Crouch] Jitter Add", -180, 180),

    custom_antiaim_air_crouch_desync_side_stand = menu.add_selection(groups.antiaim, "[Air Crouch] Desync Side", {"None", "Left", "Right", "Jitter", "Peek Fake", "Peek Real"}),
    custom_antiaim_air_crouch_desync_left_amount_stand = menu.add_slider(groups.antiaim, "[Air Crouch] Desync Left Amount", 0, 100),
    custom_antiaim_air_crouch_desync_right_amount_stand = menu.add_slider(groups.antiaim, "[Air Crouch] Desync Right Amount", 0, 100),
}

local desire = {
    notification_array = {},
}

local font = render.create_font("micross", 14, 300)
local ind_font = render.create_font("verdana", 21, 800, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

callbacks.add(e_callbacks.PAINT, function()
    table.foreach(desire.notification_array, function(i, notification_array_pointer)        
        if i > 10 then return end

        local text = notification_array_pointer.text
        local screen_size = render.get_screen_size()
        local text_size = render.get_text_size(font, text)

        local centered = notification_array_pointer.start_animx + screen_size.x / 2 - text_size.x * 0.5 - 80

        if menu_vars.notification_animation:get() == 1 then         
            notification_array_pointer.start_animx = notification_array_pointer.start_animx + menu_vars.notification_animation_speed:get()

            if notification_array_pointer.start_animx > 80 then
                notification_array_pointer.start_animx = 80
            end

            notification_array_pointer.start_animy = notification_array_pointer.start_animy - menu_vars.notification_animation_speed:get()

            if notification_array_pointer.start_animy < -80 then
                notification_array_pointer.start_animy = -80
            end

            if notification_array_pointer.alpha < 150 then
                notification_array_pointer.animx = notification_array_pointer.animx + menu_vars.notification_animation_speed:get()
                notification_array_pointer.animy = notification_array_pointer.animy - menu_vars.notification_animation_speed:get()
            end
        end

        if menu_vars.notification_animation:get() == 2 then         
            notification_array_pointer.start_animx = notification_array_pointer.start_animx + menu_vars.notification_animation_speed:get()

            if notification_array_pointer.start_animx > 80 then
                notification_array_pointer.start_animx = 80
            end

            notification_array_pointer.start_animy = 0

            if notification_array_pointer.alpha < 150 then
                notification_array_pointer.animx = notification_array_pointer.animx + menu_vars.notification_animation_speed:get()
                notification_array_pointer.animy = 0
            end
        end

        notification_array_pointer.duration = notification_array_pointer.duration + notification_array_pointer.speed

        if notification_array_pointer.duration > text_size.x then 
            notification_array_pointer.duration = text_size.x + 1
            notification_array_pointer.alpha = notification_array_pointer.alpha - 3

            if notification_array_pointer.alpha == 0 then
                table.remove(desire.notification_array, i)
            end
        end

        local pos = vec2_t(0, 0)
        if menu_vars.notification_animation:get() == 1 then
            pos = vec2_t(centered + notification_array_pointer.animx, notification_array_pointer.start_animy + screen_size.y / 1.2 + 2 - (i * 25) + 80 + notification_array_pointer.animy)
        else
            pos = vec2_t(centered + notification_array_pointer.animx, notification_array_pointer.start_animy + screen_size.y / 1.2 + 2 - (i * 25) + notification_array_pointer.animy)
        end

        local size = vec2_t(text_size.x + 13, text_size.y + 5)

        render.rect_filled(pos, size, color_t(31, 31, 31, notification_array_pointer.alpha), 4)

        render.rect(pos, size, color_t(10, 10, 10, notification_array_pointer.alpha), 4)
        render.rect(vec2_t(pos.x - 1, pos.y - 1), vec2_t(size.x + 2, size.y + 2), color_t(notification_array_pointer.color[1], notification_array_pointer.color[2], notification_array_pointer.color[3], notification_array_pointer.alpha), 4)
        render.rect(vec2_t(pos.x - 2, pos.y - 2), vec2_t(size.x + 4, size.y + 4), color_t(10, 10, 10, notification_array_pointer.alpha), 4)

        if menu_vars.notification_animation:get() == 1 then
            render.text(font, text, vec2_t(centered + 7 + notification_array_pointer.animx, notification_array_pointer.start_animy + screen_size.y / 1.2 + 4 - (i * 25) + 80 + notification_array_pointer.animy), color_t(notification_array_pointer.color[1], notification_array_pointer.color[2], notification_array_pointer.color[3], notification_array_pointer.alpha))
        else
            render.text(font, text, vec2_t(centered + 7 + notification_array_pointer.animx, notification_array_pointer.start_animy + screen_size.y / 1.2 + 4 - (i * 25) + notification_array_pointer.animy), color_t(notification_array_pointer.color[1], notification_array_pointer.color[2], notification_array_pointer.color[3], notification_array_pointer.alpha))
        end
    end)
end)

function desire:add_notify(text, speed, color) 
    local duration = 0
    local alpha = 255
    local animy = 0
    local animx = 0
    local start_animy = 0
    local start_animx = 0

    table.insert(self.notification_array, {
        speed = speed,
        duration = duration,
        text = text,
        alpha = alpha,
        color = color,
        animy = animy,
        animx = animx,
        start_animy = start_animy,
        start_animx = start_animx
    })
end

local old_antiaim = {
    pitch = menu.find("Antiaim", "Main", "Angles", "Pitch"):get(),
    yaw_base = menu.find("Antiaim", "Main", "Angles", "Yaw Base"):get(),
    yaw_add = menu.find("Antiaim", "Main", "Angles", "Yaw Add"):get(),
    rotate = menu.find("Antiaim", "Main", "Angles", "Rotate"):get(),
    rotate_range = menu.find("Antiaim", "Main", "Angles", "Rotate Range"):get(),
    rotate_speed = menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):get(),
    jitter_mode = menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):get(),
    jitter_type = menu.find("Antiaim", "Main", "Angles", "Jitter Type"):get(),
    jitter_add = menu.find("Antiaim", "Main", "Angles", "Jitter Add"):get(),
    body_lean = menu.find("Antiaim", "Main", "Angles", "Body Lean"):get(),

    desync_side_stand = menu.find("Antiaim", "Main", "Desync", "Side#Stand"):get(),
    desync_left_amount_stand = menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):get(),
    desync_right_amount_stand = menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):get(),

    desync_side_move = menu.find("Antiaim", "Main", "Desync", "Side#Move"):get(),
    desync_left_amount_move = menu.find("Antiaim", "Main", "Desync", "Left Amount#Move"):get(),
    desync_right_amount_move = menu.find("Antiaim", "Main", "Desync", "Right Amount#Move"):get(),

    desync_side_slowwalk = menu.find("Antiaim", "Main", "Desync", "Side#Slow Walk"):get(),
    desync_left_amount_slowwalk = menu.find("Antiaim", "Main", "Desync", "Left Amount#Slow Walk"):get(),
    desync_right_amount_slowwalk = menu.find("Antiaim", "Main", "Desync", "Right Amount#Slow Walk"):get(),

    desync_anti_bruteforce = menu.find("Antiaim", "Main", "Desync", "Anti Bruteforce"):get(),
    desync_on_shot = menu.find("Antiaim", "Main", "Desync", "On Shot"):get(),
}

local function handle_menu_visibility()
    local visible = false
    if menu_vars.rage_doubletap_enhancements:get() then
        if visible then
            visible = false
        elseif not visible then
            visible = true
        end
    end

    menu_vars.rage_doubletap_enhancements_main_ticks_mode:set_visible(visible)

    if menu_vars.rage_doubletap_enhancements_main_ticks_mode:get() == 2 then
        menu_vars.rage_doubletap_enhancements_speed_calculation_mode:set_visible(false)
        menu_vars.rage_doubletap_enhancements_custom_speed:set_visible(visible)
    else
        menu_vars.rage_doubletap_enhancements_custom_speed:set_visible(false)
        menu_vars.rage_doubletap_enhancements_speed_calculation_mode:set_visible(visible)
    end

    if menu_vars.custom_world_hitmarker:get() then
        menu_vars.custom_world_hitmarker_mode:set_visible(true)
        menu_vars.custom_world_damage_text:set_visible(true)
    else
        menu_vars.custom_world_hitmarker_mode:set_visible(false)
        menu_vars.custom_world_damage_text:set_visible(false)
    end

    if menu_vars.custom_clantag:get() then
        menu_vars.custom_clantag_mode:set_visible(true)
    else
        menu_vars.custom_clantag_mode:set_visible(false)
    end

    if menu_vars.tick_walk:get() then
        menu_vars.tick_walk_mode:set_visible(true)
        if menu_vars.tick_walk_mode:get() == 3 then
            menu_vars.tick_walk_ticks_to_freeze:set_visible(true)
            menu_vars.tick_walk_ticks_to_move:set_visible(true)
        else
            menu_vars.tick_walk_ticks_to_freeze:set_visible(false)
            menu_vars.tick_walk_ticks_to_move:set_visible(false)
        end
    else
        menu_vars.tick_walk_mode:set_visible(false)
        menu_vars.tick_walk_ticks_to_freeze:set_visible(false)
        menu_vars.tick_walk_ticks_to_move:set_visible(false)
    end

    if menu_vars.rage_jump_scout_modifiers:get() then      
        menu_vars.rage_jump_scout_hitchance:set_visible(true)
        menu_vars.rage_jump_scout_mindmg:set_visible(true)
    else
        menu_vars.rage_jump_scout_hitchance:set_visible(false)
        menu_vars.rage_jump_scout_mindmg:set_visible(false)
    end

    
    if menu_vars.custom_antiaim_anti_prediction_pitch:get() then      
        menu_vars.custom_antiaim_anti_prediction_spin:set_visible(true)
        menu_vars.custom_antiaim_anti_prediction_pitch_triggers:set_visible(true)
    else
        menu_vars.custom_antiaim_anti_prediction_spin:set_visible(false)
        menu_vars.custom_antiaim_anti_prediction_pitch_triggers:set_visible(false)
    end


    if menu_vars.custom_antiaim_movement_type:get() == 1 then
        menu_vars.custom_antiaim_stand_pitch:set_visible(true)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(true)
        menu_vars.custom_antiaim_stand_rotate:set_visible(true)

        if menu_vars.custom_antiaim_stand_rotate:get() then
            menu_vars.custom_antiaim_stand_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_stand_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        end
        
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_stand_skitter:set_visible(true)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(true)

        menu_vars.custom_antiaim_move_pitch:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_move_rotate:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_move_skitter:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(false)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(false)
    else if menu_vars.custom_antiaim_movement_type:get() == 2 then

        menu_vars.custom_antiaim_stand_pitch:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_stand_skitter:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_move_pitch:set_visible(true)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(true)

        menu_vars.custom_antiaim_move_rotate:set_visible(true)
        if menu_vars.custom_antiaim_move_rotate:get() then
            menu_vars.custom_antiaim_move_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_move_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)
        end

        menu_vars.custom_antiaim_move_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_move_skitter:set_visible(true)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(true)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(false)
    else if menu_vars.custom_antiaim_movement_type:get() == 3 then
        menu_vars.custom_antiaim_stand_pitch:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_stand_skitter:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_move_pitch:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_move_rotate:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)

        menu_vars.custom_antiaim_move_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_move_skitter:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(false)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(true)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(true)

        menu_vars.custom_antiaim_air_rotate:set_visible(true)
        if menu_vars.custom_antiaim_air_rotate:get() then
            menu_vars.custom_antiaim_air_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_air_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        end

        menu_vars.custom_antiaim_air_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_air_skitter:set_visible(true)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(true)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(false)
    else if menu_vars.custom_antiaim_movement_type:get() == 4 then
        menu_vars.custom_antiaim_stand_pitch:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_stand_skitter:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_move_pitch:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_move_rotate:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)

        menu_vars.custom_antiaim_move_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_move_skitter:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(false)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(true)

        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(true)
        if menu_vars.custom_antiaim_slowwalk_rotate:get() then
            menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        end

        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(true)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(false)
    else if menu_vars.custom_antiaim_movement_type:get() == 5 then
        menu_vars.custom_antiaim_stand_pitch:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_stand_skitter:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_move_pitch:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_move_rotate:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)

        menu_vars.custom_antiaim_move_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_move_skitter:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(false)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(true)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(true)

        menu_vars.custom_antiaim_crouch_rotate:set_visible(true)
        if menu_vars.custom_antiaim_crouch_rotate:get() then
            menu_vars.custom_antiaim_crouch_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)
        end

        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(true)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(true)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(false)
    else if menu_vars.custom_antiaim_movement_type:get() == 6 then
        menu_vars.custom_antiaim_stand_pitch:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_stand_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_stand_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_stand_skitter:set_visible(false)
        menu_vars.custom_antiaim_stand_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_stand_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_stand_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_move_pitch:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_move_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_move_rotate:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_move_rotate_speed:set_visible(false)

        menu_vars.custom_antiaim_move_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_move_skitter:set_visible(false)
        menu_vars.custom_antiaim_move_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_move_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_move_desync_right_amount_stand:set_visible(false)
        
        menu_vars.custom_antiaim_air_pitch:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_air_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_air_rotate:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_air_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_air_skitter:set_visible(false)
        menu_vars.custom_antiaim_air_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_air_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_air_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_pitch:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_yaw_add:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_rotate_speed:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_skitter:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_slowwalk_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_crouch_pitch:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_base:set_visible(false)
        menu_vars.custom_antiaim_crouch_yaw_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_rotate:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_range:set_visible(false)
        menu_vars.custom_antiaim_crouch_rotate_speed:set_visible(false)

        menu_vars.custom_antiaim_crouch_jitter_mode:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_type:set_visible(false)
        menu_vars.custom_antiaim_crouch_skitter:set_visible(false)
        menu_vars.custom_antiaim_crouch_jitter_add:set_visible(false)

        menu_vars.custom_antiaim_crouch_desync_side_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_left_amount_stand:set_visible(false)
        menu_vars.custom_antiaim_crouch_desync_right_amount_stand:set_visible(false)

        menu_vars.custom_antiaim_air_crouch_pitch:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_yaw_base:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_yaw_add:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_rotate:set_visible(true)
        if menu_vars.custom_antiaim_air_crouch_rotate:get() then
            menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(true)
            menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(true)
        else
            menu_vars.custom_antiaim_air_crouch_rotate_range:set_visible(false)
            menu_vars.custom_antiaim_air_crouch_rotate_speed:set_visible(false)
        end
        menu_vars.custom_antiaim_air_crouch_jitter_mode:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_jitter_type:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_skitter:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_jitter_add:set_visible(true)

        menu_vars.custom_antiaim_air_crouch_desync_side_stand:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:set_visible(true)
        menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:set_visible(true)
    end
    end
    end
    end
    end
    end
end

local menu_colors = {
    custom_auto_peek_col = menu_vars.custom_autopeek:add_color_picker("Autopeek Color"),
    custom_world_hitmarker_col = menu_vars.custom_world_hitmarker:add_color_picker("World Hitmarker Color"),

    aimbot_notifications_col_miss = menu_vars.aimbot_notifications:add_color_picker("Miss Color"),
    aimbot_notifications_col_hit = menu_vars.aimbot_notifications:add_color_picker("Hit Color"),
}

local colors = {
    red = color_t(255, 0, 0, 255),
    light_red = color_t(232, 97, 97, 255),
}

local do_welcome_noti_once = false
local function welcome_notify()
    if not do_welcome_noti_once then
        desire:add_notify("welcome, " .. user.name .. "!", 0.4, menu.find("Misc", "Main", "Personalization", "Accent Color")[2]:get())
        desire:add_notify("desire.lua, currently on version " .. lua_ver, 0.6, menu.find("Misc", "Main", "Personalization", "Accent Color")[2]:get())  
        do_welcome_noti_once = true
    end
end

local function distance(point1, point2) 
    return math.sqrt((point2[1] - point1[1]) ^ 2 + (point2[2] - point1[2]) ^ 2) 
end

local hitgroups = {
    [0] = "generic", 
    [1] = "head", 
    [2] = "chest", 
    [3] = "stomach", 
    [4] = "left arm", 
    [5] = "right arm", 
    [6] = "left leg", 
    [7] = "right leg", 
    [8] = "neck", 
    [9] = "gear"
}

local killed_player = {}
local function on_aimbot_hit(hit)
    if not menu_vars.aimbot_notifications:get() then return end
    if menu_vars.aimbot_notifications_select:get(1) then
        if killed_player[hit.player:get_index()] == true then return end
        if not hit.player then return end
        desire:add_notify("hit [" .. hit.player:get_name() .. "] -> [" .. hitgroups[hit.hitgroup] .. " | " .. hit.damage .. " dmg]" .. " -> [" .. hit.backtrack_ticks .. " bt] -> [safe: " .. tostring(hit.safepoint) .. "]", 0.7, color_t(menu_colors.aimbot_notifications_col_hit:get()[1], menu_colors.aimbot_notifications_col_hit:get()[2], menu_colors.aimbot_notifications_col_hit:get()[3]))
    end
end

local function on_aimbot_miss(miss)
    if not menu_vars.aimbot_notifications:get() then return end
    if menu_vars.aimbot_notifications_select:get(2) then
        if not miss.player then return end
        desire:add_notify("missed [" .. miss.player:get_name() .. "] -> [" .. miss.reason_string .. "]", 0.7, color_t(menu_colors.aimbot_notifications_col_miss:get()[1], menu_colors.aimbot_notifications_col_miss:get()[2], menu_colors.aimbot_notifications_col_miss:get()[3]))
    end
end

local function on_event(event)
    if event.name == "player_death" then
        local attacker = entity_list.get_player_from_userid(event.attacker)
        local victim = entity_list.get_player_from_userid(event.userid)

        if not attacker then return end
        if not victim then return end

        if not menu_vars.aimbot_notifications:get() then return end
        if menu_vars.aimbot_notifications_select:get(1) then
            if attacker == entity_list.get_local_player() then
                killed_player[victim:get_index()] = true
                desire:add_notify("killed [" .. victim:get_name() .. "] -> [" .. event.weapon .. "]"  , 0.2, color_t(menu_colors.aimbot_notifications_col_hit:get()[1], menu_colors.aimbot_notifications_col_hit:get()[2], menu_colors.aimbot_notifications_col_hit:get()[3]))
            end
        end
    end
end

local function reset_kill_check()
    if not engine.is_in_game() then return end
    local enemies_only = entity_list.get_players(true) 
    for _, enemy in pairs(enemies_only) do 
        if not enemy:is_player() then return end
        if enemy:is_alive() then 
            killed_player[enemy:get_index()] = false
        end
    end
end

callbacks.add(e_callbacks.PAINT, reset_kill_check)

local global_ap_pos = vec3_t(0,0,0)

local function custom_autopeek_circle()
    if ragebot.get_autopeek_pos() == nil then return end
    global_ap_pos = ragebot.get_autopeek_pos()

    if not menu_vars.custom_autopeek:get() then return end

    local pos = ragebot.get_autopeek_pos()

    if menu_vars.custom_autopeek_mode:get() == 1 then
        debug_overlay.add_line(vec3_t(-10, -15, 0) + pos, pos + vec3_t(-10, 15, 0), color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), true, 0.1)

        debug_overlay.add_line(vec3_t(-10, -15, 0) + pos, pos + vec3_t(15, 10, 0), color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), true, 0.1)

        debug_overlay.add_line(vec3_t(-25, 0, 0) + pos, pos + vec3_t(15, 10, 0), color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), true, 0.1)

        debug_overlay.add_line(vec3_t(-25, 0, 0) + pos, pos + vec3_t(15, -10, 0), color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), true, 0.1)

        debug_overlay.add_line(vec3_t(-10, 15, 0) + pos, pos + vec3_t(15, -10, 0), color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), true, 0.1)
    end
    
    if menu_vars.custom_autopeek_mode:get() == 2 then
        debug_overlay.add_sphere(ragebot.get_autopeek_pos(), 10, 20, 20, color_t(menu_colors.custom_auto_peek_col:get()[1], menu_colors.custom_auto_peek_col:get()[2], menu_colors.custom_auto_peek_col:get()[3]), 0.06)
    end
end

local skitter = false
local skitter_ang = 0
local function antiaims()

    if not menu_vars.enable_custom_antiaim:get() then return end
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    local stage = ""

    -- slowwalk
    if menu.find("Misc", "Main", "Movement", "Slow Walk")[2]:get() and local_player:get_prop("m_vecVelocity"):length2d() > 4  then
        menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_slowwalk_pitch:get())
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_slowwalk_yaw_base:get())

        if menu_vars.custom_antiaim_slowwalk_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 3 then
                skitter_ang = menu_vars.custom_antiaim_slowwalk_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_slowwalk_jitter_add:get()
            end

            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_slowwalk_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_slowwalk_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_slowwalk_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_slowwalk_rotate_speed:get())

        if menu_vars.custom_antiaim_slowwalk_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_slowwalk_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_slowwalk_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_slowwalk_jitter_add:get())
    
        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_slowwalk_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_slowwalk_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_slowwalk_desync_right_amount_stand:get())
    -- air duck
    else if bit.band(local_player:get_prop("m_fFlags"), 1) == 0 and local_player:get_prop("m_flDuckAmount") > 0.5 then
        menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_air_crouch_pitch:get())
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_air_crouch_yaw_base:get())

        if menu_vars.custom_antiaim_air_crouch_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 3 then
                skitter_ang = menu_vars.custom_antiaim_air_crouch_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_air_crouch_jitter_add:get()
            end

            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_air_crouch_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_air_crouch_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_air_crouch_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_air_crouch_rotate_speed:get())

        if menu_vars.custom_antiaim_air_crouch_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_air_crouch_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_air_crouch_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_air_crouch_jitter_add:get())

        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_air_crouch_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_air_crouch_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_air_crouch_desync_right_amount_stand:get())
    -- duck
    else if local_player:get_prop("m_flDuckAmount") > 0.5 or menu.find("Antiaim", "Main", "General", "Fakeduck")[2]:get() then
        menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_crouch_pitch:get())
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_crouch_yaw_base:get())

        if menu_vars.custom_antiaim_crouch_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 3 then
                skitter_ang = menu_vars.custom_antiaim_crouch_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_crouch_jitter_add:get()
            end

            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_crouch_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_crouch_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_crouch_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_crouch_rotate_speed:get())

        if menu_vars.custom_antiaim_crouch_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_crouch_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_crouch_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_crouch_jitter_add:get())
    
        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_crouch_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_crouch_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_crouch_desync_right_amount_stand:get())
    -- in air
    else if bit.band(local_player:get_prop("m_fFlags"), 1) == 0 then
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_air_yaw_base:get())

        if menu_vars.custom_antiaim_air_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 3 then
                skitter_ang = menu_vars.custom_antiaim_air_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_air_jitter_add:get()
            end

            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_air_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_air_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_air_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_air_rotate_speed:get())

        if menu_vars.custom_antiaim_air_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_air_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_air_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_air_jitter_add:get())
    
        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_air_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_air_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_air_desync_right_amount_stand:get())

    -- move
    else if local_player:get_prop("m_vecVelocity"):length2d() > 4 then
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_move_yaw_base:get())

        if menu_vars.custom_antiaim_move_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 3 then
                skitter_ang = menu_vars.custom_antiaim_move_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_move_jitter_add:get()
            end

            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_move_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_move_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_move_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_move_rotate_speed:get())

        if menu_vars.custom_antiaim_move_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_move_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_move_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_move_jitter_add:get())
    
        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_move_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_move_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_move_desync_right_amount_stand:get())

    -- stand
    else
        menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_stand_pitch:get())
        menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(menu_vars.custom_antiaim_stand_yaw_base:get())

        if menu_vars.custom_antiaim_stand_skitter:get() then
            if globals.tick_count() % 5 == 1 then
                skitter_ang = 0
            end

            if globals.tick_count() % 5 > 2 then
                skitter_ang = menu_vars.custom_antiaim_stand_jitter_add:get()
            end

            if globals.tick_count() % 5 == 2 then
                skitter_ang = -menu_vars.custom_antiaim_stand_jitter_add:get()
            end
            
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(skitter_ang)
        else
            menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(menu_vars.custom_antiaim_stand_yaw_add:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Rotate"):set(menu_vars.custom_antiaim_stand_rotate:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(menu_vars.custom_antiaim_stand_rotate_range:get())
        menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(menu_vars.custom_antiaim_stand_rotate_speed:get())

        if menu_vars.custom_antiaim_stand_skitter:get() then
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(1)
        else
            menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(menu_vars.custom_antiaim_stand_jitter_mode:get())
        end

        menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(menu_vars.custom_antiaim_stand_jitter_type:get())
        menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(menu_vars.custom_antiaim_stand_jitter_add:get())
    
        menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(menu_vars.custom_antiaim_stand_desync_side_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(menu_vars.custom_antiaim_stand_desync_left_amount_stand:get())
        menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(menu_vars.custom_antiaim_stand_desync_right_amount_stand:get())
    end
    end
    end
    end
    end
end

local desirelua_ct = {
    [0] = "ire.lua          ",
    [1] = "re.lua           ",
    [2] = "e.lua            ",
    [3] = ".lua             ",
    [4] = "lua              ",
    [5] = "               ",
    [6] = "             de",
    [7] = "            des",
    [8] = "           desi",
    [9] = "          desir",
    [10] = "         desire",
    [11] = "        desire.",
    [12] = "       desire.l",
    [13] = "      desire.lu",
    [14] = "      desire.lua primordial ",
    [15] = "     esire.lua primordial ",
    [16] = "     sire.lua primordial ",
    [17] = "    ire.lua  primordial ",
    [18] = "    re.lua primordial ",
    [19] = "   e.lua primordial ",
    [20] = "   .lua primordial ",
    [21] = "  lua primordial ",
    [22] = "  ua primordial   ",
    [23] = " a primordial    ",
    [24] = " primordial    ",
    [25] = "  a     primordia",
    [26] = "  ua    primordi ",
    [27] = "  lua    primord ",
    [28] = "  .lua    primor ",
    [29] = "  e.lua   primo ",
    [30] = "  re.lua  prim ",
    [31] = "  ire.lua  pri ",
    [32] = "  sire.lua pr ",
    [33] = "  esire.lua p   ",
    [34] = "  desire.lua    ",
    [35] = "   ",
}

local gamesense_ct = {
    [0] = "sense          ",
    [1] = "ense           ",
    [2] = "nse            ",
    [3] = "se             ",
    [4] = "e              ",
    [5] = "               ",
    [6] = "             ga",
    [7] = "            gam",
    [8] = "           game",
    [9] = "          games",
    [10] = "         gamese",
    [11] = "        gamesen",
    [12] = "       gamesens",
    [13] = "      gamesense",
    [14] = "      gamesense",
    [15] = "     gamesense ",
    [16] = "     gamesense ",
    [17] = "    gamesense  ",
    [18] = "    gamesense  ",
    [19] = "   gamesense   ",
    [20] = "   gamesense   ",
    [21] = "  gamesense    ",
    [22] = "  gamesense    ",
    [23] = " gamesense     ",
    [24] = " gamesense     ",
    [25] = "gamesense      ",
    [26] = "gamesense      ",
    [27] = "amesense       ",
    [28] = "mesense        ",
    [29] = "esense         ",
}

local aimware_ct = {
    [0] = " AIMWARE.NET ",
    [1] = " IMWARE.NET A",
    [2] = " MWARE.NET AI",
    [3] = " WARE.NET AIM",
    [4] = " ARE.NET AIMW",
    [5] = " RE.NET AIMWA",
    [6] = " E.NET AIMWAR",
    [7] = " .NET AIMWARE",
    [8] = " NET AIMWARE.",
    [9] = " ET AIMWARE.N",
    [10] = " T AIMWARE.NE",
}

local primordial_with_uid_ct = {
    [0] = "⌛",
    [1] = "⌛ p",
    [2] = "⌛ pr",
    [3] = "⌛ pri",
    [4] = "⌛ prim",
    [5] = "⌛ primo",
    [6] = "⌛ primord",
    [7] = "⌛ primordi",
    [8] = "⌛ primordia",
    [9] = "⌛ primordial",
    [10] = "⌛ primordia <" .. user.uid .. ">",
    [11] = "⌛ primordi <" .. user.uid .. ">",
    [12] = "⌛ primord <" .. user.uid .. ">",
    [13] = "⌛ primor <" .. user.uid .. ">",
    [14] = "⌛ primo <" .. user.uid .. ">",
    [15] = "⌛ prim <" .. user.uid .. ">",
    [16] = "⌛ pri <" .. user.uid .. ">",
    [17] = "⌛ pr <" .. user.uid .. ">",
    [18] = "⌛ p <" .. user.uid .. ">",
    [19] = "⌛  <" .. user.uid .. ">",
    [20] = "⌛ <" .. user.uid .. ">",
    [21] = "⌛ p <" .. user.uid .. ">",
    [22] = "⌛ pr <" .. user.uid .. ">",
    [23] = "⌛ pri <" .. user.uid .. ">",
    [24] = "⌛ prim <" .. user.uid .. ">",
    [25] = "⌛ primo <" .. user.uid .. ">",
    [26] = "⌛ primord <" .. user.uid .. ">",
    [27] = "⌛ primordi <" .. user.uid .. ">",
    [28] = "⌛ primordia <" .. user.uid .. ">",
    [29] = "⌛ primordial <" .. user.uid .. ">",
    [30] = "⌛ primordia",
    [31] = "⌛ primordi",
    [32] = "⌛ primord",
    [33] = "⌛ primor",
    [34] = "⌛ primo",
    [35] = "⌛ prim",
    [36] = "⌛ pri",
    [37] = "⌛ pr",
    [38] = "⌛ p",
}

local last_tick = 0
local function do_clantag()
    if not menu_vars.custom_clantag:get() then 
        if globals.real_time() - last_tick >= 5 then
            client.set_clantag("")
            last_tick = globals.real_time()
        end
        return 
    end

    if menu_vars.custom_clantag_mode:get() == 1 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag("desire.lua")
            last_tick = globals.real_time()
        end
    end

    if menu_vars.custom_clantag_mode:get() == 2 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag(desirelua_ct[server_time % 36])
            last_tick = globals.real_time()
        end
    end

    if menu_vars.custom_clantag_mode:get() == 3 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag(gamesense_ct[server_time % 30])
            last_tick = globals.real_time()
        end
    end

    if menu_vars.custom_clantag_mode:get() == 4 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag(primordial_with_uid_ct[server_time % 39])
            last_tick = globals.real_time()
        end
    end

    if menu_vars.custom_clantag_mode:get() == 5 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag("⌛ prim <" .. user.uid .. ">")
            last_tick = globals.real_time()
        end
    end

    if menu_vars.custom_clantag_mode:get() == 6 then
        if globals.real_time() - last_tick >= 0.15 then
            local server_time = math.floor(globals.cur_time() / 0.296875 + 6.60925 - 0.07 - engine.get_latency(e_latency_flows.OUTGOING) - engine.get_latency(e_latency_flows.INCOMING))
            client.set_clantag(aimware_ct[server_time % 11])
            last_tick = globals.real_time()
        end
    end
end

local function watermark()
    if not menu_vars.custom_watermark:get() then return end
    local username = user.name
    local text = "desire.lua / " .. username .. " / " .. user.uid
    
    local screen_size = render.get_screen_size()
    local text_size = render.get_text_size(font, text)

    render.rect_filled(vec2_t(screen_size.x - 7 - text_size.x, 3), vec2_t(text_size.x + 4, text_size.y + 3), color_t(10, 10, 10, 255), 4)
    
    render.rect(vec2_t(screen_size.x - 7 - text_size.x, 3), vec2_t(text_size.x + 4, text_size.y + 3), color_t(46, 46, 46, 255), 4)

    render.text(font, text, vec2_t(screen_size.x - 5 - text_size.x, 4), color_t(140, 140, 140, 255))
   -- render.text(font, username, vec2_t(screen_size.x - 5 - text_size.x / 1.69, 4), menu.find("Misc", "Main", "Personalization", "Accent Color")[2]:get())
end

local function on_shutdown()
    menu.find("Antiaim", "Main", "Angles", "Pitch"):set(old_antiaim.pitch)
    menu.find("Antiaim", "Main", "Angles", "Yaw Base"):set(old_antiaim.yaw_base)
    menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(old_antiaim.yaw_add)
    menu.find("Antiaim", "Main", "Angles", "Rotate"):set(old_antiaim.rotate)
    menu.find("Antiaim", "Main", "Angles", "Rotate Range"):set(old_antiaim.rotate_range)
    menu.find("Antiaim", "Main", "Angles", "Rotate Speed"):set(old_antiaim.rotate_speed)
    menu.find("Antiaim", "Main", "Angles", "Jitter Mode"):set(old_antiaim.jitter_mode)
    menu.find("Antiaim", "Main", "Angles", "Jitter Type"):set(old_antiaim.jitter_type)
    menu.find("Antiaim", "Main", "Angles", "Jitter Add"):set(old_antiaim.jitter_add)
    menu.find("Antiaim", "Main", "Angles", "Body Lean"):set(old_antiaim.body_lean)

    menu.find("Antiaim", "Main", "Desync", "Side#Stand"):set(old_antiaim.desync_side_stand)
    menu.find("Antiaim", "Main", "Desync", "Left Amount#Stand"):set(old_antiaim.desync_left_amount_stand)
    menu.find("Antiaim", "Main", "Desync", "Right Amount#Stand"):set(old_antiaim.desync_right_amount_stand)

    menu.find("Antiaim", "Main", "Desync", "Side#Move"):set(old_antiaim.desync_side_move)
    menu.find("Antiaim", "Main", "Desync", "Left Amount#Move"):set(old_antiaim.desync_left_amount_move)
    menu.find("Antiaim", "Main", "Desync", "Right Amount#Move"):set(old_antiaim.desync_right_amount_move)

    menu.find("Antiaim", "Main", "Desync", "Side#Slow Walk"):set(old_antiaim.desync_side_move)
    menu.find("Antiaim", "Main", "Desync", "Left Amount#Slow Walk"):set(old_antiaim.desync_left_amount_move)
    menu.find("Antiaim", "Main", "Desync", "Right Amount#Slow Walk"):set(old_antiaim.desync_right_amount_move)

    menu.find("Antiaim", "Main", "Desync", "Anti Bruteforce"):set(old_antiaim.desync_anti_bruteforce)
    menu.find("Antiaim", "Main", "Desync", "On Shot"):set(old_antiaim.desync_on_shot)

    client.set_clantag("")
end

local old_ragebot = {
    scout_hitchance = menu.find("Aimbot", "Scout", "Targeting", "Hitchance"):get(),
    scout_mindmg = menu.find("Aimbot", "Scout", "Targeting", "Min. Damage"):get(),
}

local call_ragebot_once = false
local is_allowed_to_edit_vars = false
function handle_old_ragebot_values()
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    if not call_ragebot_once or is_allowed_to_edit_vars then
        old_ragebot.scout_hitchance = menu.find("Aimbot", "Scout", "Targeting", "Hitchance"):get()
        old_ragebot.scout_mindmg = menu.find("Aimbot", "Scout", "Targeting", "Min. Damage"):get()
        call_ragebot_once = true
    end
end

local force_js_vals = false
local function ragebot()
    handle_old_ragebot_values()

    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if not local_player:is_player() then return end
    if local_player:is_alive() then
        if menu_vars.rage_jump_scout_modifiers:get() then
            if bit.band(local_player:get_prop("m_fFlags"), 1) == 0 then
                is_allowed_to_edit_vars = false
                menu.find("Aimbot", "Scout", "Targeting", "Hitchance"):set(menu_vars.rage_jump_scout_hitchance:get())
                menu.find("Aimbot", "Scout", "Targeting", "Min. Damage"):set(menu_vars.rage_jump_scout_mindmg:get())
                force_js_vals = false
            else
                is_allowed_to_edit_vars = true
                if not force_js_vals then
                    menu.find("Aimbot", "Scout", "Targeting", "Hitchance"):set(old_ragebot.scout_hitchance)
                    menu.find("Aimbot", "Scout", "Targeting", "Min. Damage"):set(old_ragebot.scout_mindmg)
                end
            end
        end
    end
end

local function add_indicator(text, i, x, text_size, screen_size, col)
    text_size = render.get_text_size(ind_font, text)

    render.rect_filled(vec2_t(x - 10, screen_size.y / 1.4 - i - text_size.y - 5), vec2_t(text_size.x + 20, text_size.y + 10), color_t(31,31,31,255), 6)
    render.rect(vec2_t(x - 10, screen_size.y / 1.4 - i - text_size.y - 5), vec2_t(text_size.x + 20, text_size.y + 10), color_t(46, 46, 46,255), 6)

    render.rect_filled(vec2_t(x - 10, screen_size.y / 1.4 - i - text_size.y - 5), vec2_t(3, text_size.y + 10), col)

    render.text(ind_font, text, vec2_t(x, screen_size.y / 1.4 - i - text_size.y), color_t(255,255,255,255))
end

local safe_auto_peek = false
local current_dt_mode_to_string = ""

local function indicators()
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    if not local_player:is_player() then return end
    if not local_player:is_alive() then return end

    local text = ""
    local screen_size = render.get_screen_size()
    local text_size = render.get_text_size(ind_font, text)
    local x = 20
    local i = 0
    local h = 35
    local accent_col = menu.find("Misc", "Main", "Personalization", "Accent Color")[2]:get()

    if menu_vars.indicators_select:get("Fake Yaw") then
        i = i + h
        add_indicator("FAKE YAW: " .. tostring(math.floor(antiaim.get_fake_angle())), i, x, text_size, screen_size, accent_col)
    end

    if menu_vars.indicators_select:get("Real Yaw") then
        i = i + h
        add_indicator("REAL YAW: " .. tostring(math.floor(antiaim.get_real_angle())), i, x, text_size, screen_size, accent_col)
    end

    if menu_vars.indicators_select:get("Lean Yaw") then
        i = i + h
        add_indicator("LEAN YAW: " .. tostring(math.floor(antiaim.get_body_lean())), i, x, text_size, screen_size, accent_col)
    end

    if menu_vars.indicators_select:get("Slow Walk") then
        if menu.find("Misc", "Main", "Movement", "Slow Walk", "Enable")[2]:get() and local_player:get_prop("m_vecVelocity"):length2d() > 3 then
            i = i + h
            add_indicator("SLOWWALK: " .. tostring(math.floor(local_player:get_prop("m_vecVelocity"):length2d())) .. "u", i, x, text_size, screen_size, accent_col)
        end
    end

    if menu_vars.indicators_select:get("Autopeek") then
        if menu.find("Aimbot", "General", "Misc", "Autopeek", "Enable")[2]:get() then
            i = i + h
            
            if safe_auto_peek then
                add_indicator("AUTOPEEK (SAFE)", i, x, text_size, screen_size, color_t(0,255,0,255))
            else
                add_indicator("AUTOPEEK", i, x, text_size, screen_size, accent_col)
            end
        end
    end

    if not local_player:get_active_weapon() then return end

    if local_player:get_active_weapon():get_name() ~= "knife" and local_player:get_active_weapon():get_name() ~= "taser" then
        if local_player:get_active_weapon():get_name() == "g3sg1" or local_player:get_active_weapon():get_name() == "scar20" then

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Auto", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Auto", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Auto", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Auto", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Auto", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Auto", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

        else if local_player:get_active_weapon():get_name() == "ssg08" then

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Scout", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Scout", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Scout", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Scout", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Scout", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Scout", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

        else if local_player:get_active_weapon():get_name() == "awp" then

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Awp", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Awp", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Awp", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Awp", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Awp", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Awp", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

        else if local_player:get_active_weapon():get_name() == "deagle" then

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Deagle", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Deagle", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Deagle", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Deagle", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Deagle", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Deagle", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

        else if local_player:get_active_weapon():get_name() == "revolver" then

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Revolver", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Revolver", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Revolver", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Revolver", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Revolver", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Revolver", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

        else if local_player:get_active_weapon():get_name() == "glock" 
            or local_player:get_active_weapon():get_name() == "elite" 
            or local_player:get_active_weapon():get_name() == "p250" 
            or local_player:get_active_weapon():get_name() == "tec9"
            or local_player:get_active_weapon():get_name() == "usp-s"
            or local_player:get_active_weapon():get_name() == "p2000"
            or local_player:get_active_weapon():get_name() == "fiveseven" then
    
                if menu_vars.indicators_select:get("Min. Damage") then
                    i = i + h
    
                    if menu.find("Aimbot", "Pistols", "Target Overrides", "Min. Damage")[2]:get() then
                        add_indicator("MD: " .. menu.find("Aimbot", "Pistols", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                    else
                        add_indicator("MD: " .. menu.find("Aimbot", "Pistols", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                    end
                end

                if menu_vars.indicators_select:get("Hitchance") then
                    i = i + h
                    if menu.find("Aimbot", "Pistols", "Target Overrides", "Hitchance")[2]:get() then
                        add_indicator("HC: " .. menu.find("Aimbot", "Pistols", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                    else
                        add_indicator("HC: " .. menu.find("Aimbot", "Pistols", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                    end
                end
        else

            if menu_vars.indicators_select:get("Min. Damage") then
                i = i + h

                if menu.find("Aimbot", "Other", "Target Overrides", "Min. Damage")[2]:get() then
                    add_indicator("MD: " .. menu.find("Aimbot", "Other", "Target Overrides", "Min. Damage")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("MD: " .. menu.find("Aimbot", "Other", "Targeting", "Min. Damage"):get(), i, x, text_size, screen_size, accent_col)
                end
            end

            if menu_vars.indicators_select:get("Hitchance") then
                i = i + h
                if menu.find("Aimbot", "Other", "Target Overrides", "Hitchance")[2]:get() then
                    add_indicator("HC: " .. menu.find("Aimbot", "Other", "Target Overrides", "Hitchance")[1]:get(), i, x, text_size, screen_size, accent_col)
                else
                    add_indicator("HC: " .. menu.find("Aimbot", "Other", "Targeting", "Hitchance"):get(), i, x, text_size, screen_size, accent_col)
                end
            end
        end 
        end
        end
        end
        end
        end
    end
 
    if menu_vars.indicators_select:get("Hideshots") then
        if menu.find("Aimbot", "General", "Exploits", "Hideshots", "Enable")[2]:get() then
            i = i + h
            add_indicator("HS", i, x, text_size, screen_size, accent_col)
        end
    end

    if menu_vars.indicators_select:get("Doubletap") then
        if menu.find("Aimbot", "General", "Exploits", "Doubletap", "Enable")[2]:get() then
            i = i + h
            if menu_vars.rage_doubletap_enhancements:get() then 
                add_indicator("DT" .. current_dt_mode_to_string, i, x, text_size, screen_size, exploits.get_charge() < 10 and color_t(255, 0, 0, 255) or accent_col)
            else
                add_indicator("DT", i, x, text_size, screen_size, exploits.get_charge() < 14 and color_t(255, 0, 0, 255) or accent_col)
            end
        end
    end

    if menu_vars.indicators_select:get("Fakeduck") then
        if menu.find("Antiaim", "Main", "General", "Fakeduck", "Enable")[2]:get() then
            i = i + h
            add_indicator("FD", i, x, text_size, screen_size, accent_col)
        end
    end
end

local function safe_ideal_tick(cmd)
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    if menu_vars.rage_safe_ideal_tick:get()
    and menu.find("Aimbot", "General", "Misc", "Autopeek", "Enable")[2]:get() 
    and menu.find("Aimbot", "General", "Exploits", "Doubletap", "Enable")[2]:get() 
    and not client.can_fire()
    and distance(local_player:get_render_origin(), global_ap_pos) < 20 then
        cmd.move.x = 0
        cmd.move.y = 0

        safe_auto_peek = true
    else
        safe_auto_peek = false
    end
end

local vector = {}

function vector.to_angle(vec_1)
    local temp, pitch, yaw = 0, 0, 0

    if vec_1.y == 0 and vec_1.x == 0 then
        yaw = 0

        if vec_1.z > 0 then 
            pitch = 270
        else 
            pitch = 90
        end
    else 
        yaw = math.atan2(vec_1.y, vec_1.x) * 180 / math.pi

        if yaw < 0 then 
            yaw = yaw + 360
        end

        temp = math.sqrt(vec_1.x * vec_1.x + vec_1.y * vec_1.y)
        pitch = math.atan2(-vec_1.z, temp) * 180 / math.pi

        if pitch < 0 then 
            pitch = pitch + 360
        end
    end

    return vec3_t(pitch, yaw, 0)
end

local function at_targets_angle()
    local players = entity_list.get_players(true)
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    local target_origin = vec3_t(0, 0, 0)
    local best_dist = 10000
    
    local best_ang = 0

    for k, enemy in pairs(players) do
        if not enemy:is_alive() or enemy:is_dormant() then
			goto skip
		end

		local origin = enemy:get_render_origin()
		local local_origin = local_player:get_render_origin()

        local dist = distance(local_origin, origin)

        if dist < best_dist then
            local best_origin = enemy:get_render_origin()

            target_origin = best_origin
            best_dist = dist
        else
			goto skip
        end

        best_ang = vector.to_angle(local_origin - target_origin).y

        ::skip::
    end

    return best_ang
end

local on_land_timer = 0
local function animations(a)
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    local flags = local_player:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0

    if on_land then
        on_land_timer = on_land_timer + 1
    else
        on_land_timer = 0
    end

    if on_land_timer < 50 and on_land_timer > 1 then
        if menu_vars.animation_on_land:get("Zero Pitch") then
            a:set_render_pose(e_poses.BODY_PITCH, 0.5)
        end

        if menu_vars.animation_on_land:get("Freeze Legs") then
            a:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0, 0)
        end
    end

    -- in air
    if bit.band(local_player:get_prop("m_fFlags"), 1) == 0 then
        if menu_vars.animation_in_air:get("Static Legs") then
            a:set_render_pose(e_poses.JUMP_FALL, 1)
        end

        if menu_vars.animation_in_air:get("Strafe Legs") then
            a:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1, 0)
        end

        if menu_vars.animation_in_air:get("Lean With Strafe") then
            a:set_render_animlayer(e_animlayers.LEAN, 1, 0)
        end
    -- move
    else if local_player:get_prop("m_vecVelocity"):length2d() > 4 then
        if menu_vars.animation_on_move:get("Moon Walk") then
            a:set_render_pose(e_poses.MOVE_YAW, 1)
        end
    end
    end

end

local enum = {
    FASTEST = 17,
    ACCURATE = 14,
    SAFE = 12,
    SAFEST = 10
}

local doubletap = cvars.sv_maxusrcmdprocessticks

local font_hm_1 = render.create_font("verdana", 14, 200, e_font_flags.ANTIALIAS)
local font_hm_2 = render.create_font("tahoma", 14, 200, e_font_flags.ANTIALIAS)
local font_hm_3 = render.create_font("Cour", 14, 200, e_font_flags.ANTIALIAS)
local font_hm_4 = render.create_font("Segoeuib", 14, 300, e_font_flags.ANTIALIAS)

local function on_world_hitmarker(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
    render.push_alpha_modifier(alpha_factor)
    if menu_vars.custom_world_hitmarker:get() then
        if menu_vars.custom_world_hitmarker_mode:get() == 1 then
            render.circle_filled(screen_pos, 3, menu_colors.custom_world_hitmarker_col:get())
        end

        if menu_vars.custom_world_hitmarker_mode:get() == 2 then
            render.triangle_filled(screen_pos, 6, menu_colors.custom_world_hitmarker_col:get())
        end

        if menu_vars.custom_world_damage_text:get() == 1 then
            render.text(font_hm_1, tostring(damage), screen_pos, menu_colors.custom_world_hitmarker_col:get())
        end

        if menu_vars.custom_world_damage_text:get() == 2 then
            render.text(font_hm_2, tostring(damage), screen_pos, menu_colors.custom_world_hitmarker_col:get())
        end

        if menu_vars.custom_world_damage_text:get() == 3 then
            render.text(font_hm_3, tostring(damage), screen_pos, menu_colors.custom_world_hitmarker_col:get())
        end

        if menu_vars.custom_world_damage_text:get() == 4 then
            render.text(font_hm_4, tostring(damage), screen_pos, menu_colors.custom_world_hitmarker_col:get())
        end
    end

    render.pop_alpha_modifier()

    return menu_vars.custom_world_hitmarker:get()
end

local function tick_walk(cmd)
    if not menu_vars.tick_walk:get() then return end

    if menu_vars.tick_walk_ticks_to_move:get() > menu_vars.tick_walk_ticks_to_freeze:get() then
        menu_vars.tick_walk_ticks_to_move:set(menu_vars.tick_walk_ticks_to_freeze:get() - 5)
    end

    if not menu.find("Misc", "Main", "Movement", "Slow Walk", "Enable")[2]:get() then return end

    if menu_vars.tick_walk_mode:get() == 1 then
        if globals.tick_count() % 24 > 10
        or globals.tick_count() % 12 > 5 then
            cmd.move = vec3_t(0,0,0)
        end
    end

    if menu_vars.tick_walk_mode:get() == 2 then
        if globals.tick_count() % 30 > 24 
        or globals.tick_count() % 12 > 5
        then
            cmd.move = vec3_t(0,0,0)
        end
    end

    if menu_vars.tick_walk_mode:get() == 3 then
        if globals.tick_count() % menu_vars.tick_walk_ticks_to_freeze:get() > menu_vars.tick_walk_ticks_to_move:get() then
            cmd.move = vec3_t(0,0,0)
        end
    end
end

local anti_pred_yaw = 0
local function entity_loop(aa) 
    local players = entity_list.get_players(true)
    local local_player = entity_list.get_local_player()
    if not local_player then return end

    local target_origin = vec3_t(0, 0, 0)
    local best_dist = 10000

    for k, enemy in pairs(players) do
        if not enemy:is_alive() or enemy:is_dormant() then
			goto skip
		end

		local origin = enemy:get_render_origin()
		local local_origin = local_player:get_render_origin()

        local dist = distance(local_origin, origin)

        if dist < best_dist then
            local best_origin = enemy:get_render_origin()

            target_origin = best_origin
            best_dist = dist
        else
			goto skip
        end

        if target_origin == nil then goto skip end

        if anti_pred_yaw == 180 then
            anti_pred_yaw = -180
        end

        if menu_vars.custom_antiaim_anti_prediction_pitch:get() then
            if menu.find("Aimbot", "General", "Exploits", "Doubletap", "Enable")[2]:get() then
                if local_player:is_point_visible(target_origin) or distance(local_origin, target_origin) < 500 then        
                    if bit.band(local_player:get_prop("m_fFlags"), 1) == 0 then    
                        if menu_vars.custom_antiaim_anti_prediction_pitch_triggers:get(1) then
                            if menu_vars.custom_antiaim_anti_prediction_spin:get() then
                                anti_pred_yaw = anti_pred_yaw + 10
                                menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(anti_pred_yaw)
                            end

                            if globals.tick_count() % 25 < 2 then
                                menu.find("Antiaim", "Main", "Angles", "Pitch"):set(3)
                            else
                                menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_air_pitch:get())
                            end
                        end
                    else if local_player:get_prop("m_vecVelocity"):length2d() > 4 then
                        if menu_vars.custom_antiaim_anti_prediction_pitch_triggers:get(2) then
                            if menu_vars.custom_antiaim_anti_prediction_spin:get() then
                                anti_pred_yaw = anti_pred_yaw + 10
                                menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(anti_pred_yaw)
                            end

                            if globals.tick_count() % 25 < 2 then
                                menu.find("Antiaim", "Main", "Angles", "Pitch"):set(3)
                                menu.find("Antiaim", "Main", "Angles", "Yaw Add"):set(anti_pred_yaw)
                            else
                                menu.find("Antiaim", "Main", "Angles", "Pitch"):set(menu_vars.custom_antiaim_move_pitch:get())
                            end
                        end
                    end
                    end
                end
            end
        end

        if not menu_vars.rage_doubletap_enhancements:get() or not menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2]:get() then 
            doubletap:set_int(16)
            goto skip 
        end

        if menu_vars.rage_doubletap_enhancements_main_ticks_mode:get() == 1 then 
            if menu_vars.rage_doubletap_enhancements_speed_calculation_mode:get() == 1 then 
                doubletap:set_int(enum.FASTEST)
                current_dt_mode_to_string = ": FASTEST"
            else if menu_vars.rage_doubletap_enhancements_speed_calculation_mode:get() == 2 then 
                if distance(local_origin, target_origin) < 600 then
                    doubletap:set_int(enum.FASTEST)
                    current_dt_mode_to_string = ": FASTEST"
                else if distance(local_origin, target_origin) > 600 then
                    doubletap:set_int(enum.ACCURATE)
                    current_dt_mode_to_string = ": ACCURATE"
                end
                end
            else if menu_vars.rage_doubletap_enhancements_speed_calculation_mode:get() == 3 then 
                if distance(local_origin, target_origin) < 600 then
                    doubletap:set_int(enum.FASTEST)
                    current_dt_mode_to_string = ": FASTEST"
                else if distance(local_origin, target_origin) > 600 and distance(local_origin, target_origin) < 1000 then
                    doubletap:set_int(enum.ACCURATE)
                    current_dt_mode_to_string = ": ACCURATE"
                else if distance(local_origin, target_origin) > 1000 and distance(local_origin, target_origin) < 2300 then
                    doubletap:set_int(enum.SAFE)
                    current_dt_mode_to_string = ": SAFE"
                else if distance(local_origin, target_origin) > 2300 then
                    doubletap:set_int(enum.SAFEST)
                    current_dt_mode_to_string = ": SAFEST"
                end
                end
                end
                end
            end
            end
            end

        else
            doubletap:set_int(menu_vars.rage_doubletap_enhancements_custom_speed:get())
            current_dt_mode_to_string = ""
        end

        ::skip::
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, entity_loop)
callbacks.add(e_callbacks.WORLD_HITMARKER, on_world_hitmarker)
callbacks.add(e_callbacks.ANTIAIM, anti_prediction)
callbacks.add(e_callbacks.ANTIAIM, animations)
callbacks.add(e_callbacks.RUN_COMMAND, tick_walk)
callbacks.add(e_callbacks.RUN_COMMAND, safe_ideal_tick)
callbacks.add(e_callbacks.PAINT, welcome_notify)
callbacks.add(e_callbacks.PAINT, indicators)
callbacks.add(e_callbacks.PAINT, ragebot)
callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.PAINT, watermark)
callbacks.add(e_callbacks.PAINT, do_clantag)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.PAINT, handle_menu_visibility)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.PAINT, custom_autopeek_circle)
callbacks.add(e_callbacks.PAINT, swap_antiaim_settings)
callbacks.add(e_callbacks.PAINT, antiaims)