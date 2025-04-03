--conditional fakelag
--credits to hause/myzarfin for organizing my skitzo code

local ref = {
    fake_duck = menu.find("antiaim", "main", "general", "fake duck"),
    slow_motion = menu.find("misc", "main", "movement", "slow walk"),
    double_tap = menu.find("aimbot", "general", "exploits", "doubletap", "enable"),
    auto_peek = menu.find("aimbot", "general", "misc", "autopeek"),
    fakelag_amount = menu.find("antiaim", "main", "fakelag", "amount"),
    hide_shots = menu.find( "aimbot", "general", "exploits", "hideshots", "enable" )
}

local menu = {
    condition_list = menu.add_multi_selection("player states", "states picker", {"crouch", "slow walk", "in air", "on shot", "on peek"}),
    indicator = menu.add_checkbox("enable", "indicator"),
    font_select = menu.add_selection("enable", "fonts", {"Arial", "Verdana", "Impact", "Comic sans", "Pixel", "Tahoma"}),
    fakelag_state = {
        { menu.add_slider("fake lag control", "crouch", 0.0, 15.0, ""), menu.add_checkbox("fake lag control", "random", false) },
        { menu.add_slider("fake lag control", "slow walk", 0.0, 15.0, ""), menu.add_checkbox("fake lag control", "random", false) },
        { menu.add_slider("fake lag control", "in air", 0.0, 15.0, ""), menu.add_checkbox("fake lag control", "random", false) },
        { menu.add_slider("fake lag control", "on shot", 0.0, 15.0, ""), menu.add_checkbox("fake lag control", "random", false) },
        { menu.add_slider("fake lag control", "on peek", 0.0, 15.0, ""), menu.add_checkbox("fake lag control", "random", false) },
    }
}

local vars = {
    screen_size = render.get_screen_size(),
    player = entity_list.get_local_player(),
    duck_amount = 0,
    local_flags = 0,
    textFont = render.create_font("Arial", 30, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW),
    default_fakelag = ref.fakelag_amount:get(),
    prev_state = 'none',
    color = menu.indicator:add_color_picker("text color"),
    
    cur_time = -1,
    max_backtrack_time = 400,
    last_shot_time = -1,
    delta = -1,
    ms_since_last_shot = -1,

    fonts = {
        avaliable_fonts = {
            "Arial",
            "Verdana",
            "Impact",
            "Comic Sans",
            "Small Fonts",
            "Tahoma",
        },

        font_ptr = {},
    }
}

local function GetPlayerState(player)
    local v = vars.player:get_prop('m_vecVelocity')
    local is_fake_ducking = ref.fake_duck[2]:get()
    local is_slow_motion  = ref.slow_motion[1]:get() and ref.slow_motion[2]:get()
    local is_crouching    = vars.player:get_prop('m_flDuckAmount') > 0.5 and (not is_fake_ducking)
    local is_jumping      = bit.band(vars.player:get_prop('m_fFlags'), 1) == 0
    local is_standing     = math.sqrt(v.x ^ 2 + v.y ^ 2) < 2
    local is_ideal_ticking = ref.double_tap[2]:get() and ref.auto_peek[2]:get()

    vars.cur_time = global_vars.cur_time( )
    vars.delta = vars.cur_time - vars.last_shot_time
    vars.ms_since_last_shot = vars.delta * 1000 > vars.max_backtrack_time and vars.max_backtrack_time or vars.delta * 1000
    local is_on_shot = vars.ms_since_last_shot < vars.max_backtrack_time

    if is_on_shot then
        return 'on shot'
    elseif is_ideal_ticking or ref.auto_peek[2]:get() then
        return 'on peek'
    elseif is_slow_motion then
        return 'slow walk'
    elseif is_crouching then
        return 'crouch'
    elseif is_jumping then
        return 'in air'
    elseif is_standing then
        return 'standing'
    end
    return 'none'
end

local function SetVisibility(table, condition)
    for k, v in pairs(table) do
        if (type(v) == 'table') then
            for j, i in pairs(v) do
                i:set_visible(condition)
            end
        else 
            v:set_visible(condition)
        end
    end
end

callbacks.add(e_callbacks.EVENT, function(event)
    local player = entity_list.get_player_from_userid( event.userid )
    if not player or not vars.local_player or player ~= vars.local_player then
        return
    end

    if not ref.hide_shots[ 2 ]:get( ) then
        vars.last_shot_time = vars.cur_time
    end
end, 'weapon_fire')

callbacks.add(e_callbacks.PAINT, function()
    local state = GetPlayerState(vars.player)
    local chokedTicks = engine.get_choked_commands()
    local fps = tostring(client.get_fps())
    local velo = tostring(math.floor(vars.player:get_prop('m_vecVelocity'):length2d()))
    local ping = tostring(math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000))
    local x, y = (vars.screen_size.x / 2), (vars.screen_size.y / 2)
    
    if(menu.indicator:get()) then
        render.circle_filled(vec2_t.new(x-600, y+300), 30, color_t.new(25,25,25,155))
        if(chokedTicks > 3) then    
            render.progress_circle(vec2_t.new(x-600, y+300), 25, color_t.new(255,255,0), 8, chokedTicks/15)
        end
        render.text(vars.fonts.font_ptr[menu.font_select:get()], string.format("%i fps    %i m/s     %i ping", fps, velo, ping), vec2_t(x, y+470), vars.color:get(), true)
    end

    local active = false
    for k, v in pairs(menu.fakelag_state) do
        SetVisibility(v, menu.condition_list:get(k))
        if menu.condition_list:get(k) then
            if state == menu.condition_list:get_item_name(k) then
                ref.fakelag_amount:set(menu.fakelag_state[k][1]:get())
                active = true
            end

            if menu.fakelag_state[k][2]:get() then
                ref.fakelag_amount:set(math.random(0, menu.fakelag_state[k][1]:get()))
            end
        end
    end

    if not active then
        ref.fakelag_amount:set(vars.default_fakelag)
    end
end )

do
    SetVisibility(menu.fakelag_state, false)

    for k, v in pairs(vars.fonts.avaliable_fonts) do
        vars.fonts.font_ptr[k] = render.create_font(v, 30, 400, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
    end
end