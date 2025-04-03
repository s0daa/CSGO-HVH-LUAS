local vars = {
    enable_all = menu.add_checkbox("doubletap enhancements", "enable", false),
    main_ticks_mode = menu.add_selection("doubletap enhancements", "mode", {"dynamic", "custom"}),
    speed_calculation_mode = menu.add_selection("doubletap enhancements", "speed calculation", {"aggresive", "hold", "dynamic"}),
    custom_speed = menu.add_slider("doubletap enhancements", "doubletap speed", 5, 17),
    tick_notice = menu.add_text("doubletap enhancements", "the info box will display 2 less ticks due to them"),
    tick_notice_2 = menu.add_text("doubletap enhancements", "being reserved."),
}

menu.add_button("servers", "Desire's HvH Server (No AWP / No Roll)", function()
    engine.execute_cmd("connect 94.156.128.92:27015")
end)

menu.add_button("servers", "Desire's HvH Server (Yes AWP / Yes Roll)", function()
    engine.execute_cmd("connect 94.156.128.92:27018")
end)

local function handle_widget_visibility()
    local visible = false
    if vars.enable_all:get() then
        if visible then
            visible = false
        elseif not visible then
            visible = true
        end
    end

    vars.main_ticks_mode:set_visible(visible)

    if vars.main_ticks_mode:get() == 2 then
        vars.speed_calculation_mode:set_visible(false)
        vars.custom_speed:set_visible(true)
        vars.tick_notice:set_visible(true)
        vars.tick_notice_2:set_visible(true)
    else
        vars.custom_speed:set_visible(false)
        vars.speed_calculation_mode:set_visible(visible)
        vars.tick_notice:set_visible(false)
        vars.tick_notice_2:set_visible(false)
    end
end

local doubletap = cvars.sv_maxusrcmdprocessticks

local function distance(point1, point2) 
    return math.sqrt((point2[1] - point1[1]) ^ 2 + (point2[2] - point1[2]) ^ 2) 
end

local function distancefov(point1, point2) 
    return math.sqrt((point2[1] - 0) ^ 2 + (point2[2] - point1) ^ 2) 
end

local enum = {
    FASTEST = 17,
    ACCURATE = 14,
    SAFE = 12,
}

local font = render.create_font("tahoma", 15, 600, e_font_flags.ANTIALIAS)

local function alter_doubletap_speed()
    -- if the master switch is off, fuck off
    if not vars.enable_all:get() then 
        doubletap:set_int(16) -- smack this shit back to default
        return 
    end

    -- if doubletap is disabled, don't run anything below
    if not menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2]:get() then return end

    local plocal = entity_list.get_local_player()

    if not engine.is_in_game() then return end

    if not plocal:is_alive() then return end

    local players = entity_list.get_players(true) 

    local best_target_origin = vec3_t(0.0, 0.0, 0.0)

    local player_name = ""

    if vars.main_ticks_mode:get() == 1 then
        for _, player in pairs(players) do 

            if not player:is_alive() then break end

            player_name = player:get_name()

            if vars.speed_calculation_mode:get() == 1 then 
                doubletap:set_int(enum.FASTEST)
            else if vars.speed_calculation_mode:get() == 2 then 
                if distance(plocal:get_render_origin(), best_target_origin) < 600 then
                    doubletap:set_int(enum.FASTEST)
                else if distance(plocal:get_render_origin(), best_target_origin) > 600 then
                    doubletap:set_int(enum.ACCURATE)
                end
                end
            else if vars.speed_calculation_mode:get() == 3 then 
                if distance(plocal:get_render_origin(), best_target_origin) < 600 then
                    doubletap:set_int(enum.FASTEST)
                else if distance(plocal:get_render_origin(), best_target_origin) > 600 and distance(plocal:get_render_origin(), best_target_origin) < 1000 then
                    doubletap:set_int(enum.ACCURATE)
                else if distance(plocal:get_render_origin(), best_target_origin) > 1000 then
                    doubletap:set_int(enum.SAFE)
                end
                end
                end
            end
            end
            end
        end   
    else
        doubletap:set_int(vars.custom_speed:get())
    end

    render.text(font, "target: " .. tostring(player_name), vec2_t(50, 50), color_t(255, 255, 255, 255))

    local current_dt_mode_to_string = ""

    if exploits.get_charge() == 15 then
        current_dt_mode_to_string = "FASTEST"
    else if exploits.get_charge() == 12 then
        current_dt_mode_to_string = "ACCURATE"
    else if exploits.get_charge() == 10 then
        current_dt_mode_to_string = "SAFE"
    else if exploits.get_charge() < 10 then
        current_dt_mode_to_string = "RECHARGING..."
    end
    end
    end
    end

    local text_mode = "current mode: " .. current_dt_mode_to_string
    local text_ticks = "current ticks: " .. tostring(exploits.get_charge())
    
    local text_size_mode = render.get_text_size(font, text_mode)
    local text_size_ticks = render.get_text_size(font, text_ticks)

    local infobox_size = vec2_t(5 + text_size_mode[1] + 5, 5 + text_size_mode[2] + 5)

    if vars.main_ticks_mode:get() == 1 then
        infobox_size = vec2_t(5 + text_size_mode[1] + 5, 5 + text_size_mode[2] + 5)
    else
        infobox_size = vec2_t(5 + text_size_ticks[1] + 5, 5 + text_size_ticks[2] + 5)
    end

    render.rect_filled(vec2_t(5, render.get_screen_size()[2] / 2 - text_size_mode[2]), infobox_size, color_t(30,30,30))

    render.rect(vec2_t(5, render.get_screen_size()[2] / 2 - text_size_mode[2]), infobox_size, color_t(42,42,42))

    if vars.main_ticks_mode:get() == 1 then
        render.text(font, text_mode, vec2_t(10, 5 + render.get_screen_size()[2] / 2 - text_size_mode[2]), color_t(255, 255, 255, 255))
    else
        render.text(font, text_ticks, vec2_t(10, 5 + render.get_screen_size()[2] / 2 - text_size_ticks[2]), color_t(255, 255, 255, 255))
    end
end

callbacks.add(e_callbacks.PAINT, handle_widget_visibility)
callbacks.add(e_callbacks.PAINT, alter_doubletap_speed)