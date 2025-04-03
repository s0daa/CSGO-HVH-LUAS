-- menu get
get_menu = {
    menu.find('antiaim', 'main', 'fakelag', 'amount'),
    menu.find('aimbot', 'general', 'exploits', 'doubletap', 'enable')
}

ref_fl = get_menu[1]:get()

--ui
ui = {
    menu.add_checkbox("Ideal Tick", "Enabled IDEAL-Tick", false),
    menu.add_text("Ideal Tick", "IDEAL-Tick HotKey"),
    menu.add_checkbox("Ideal Tick", "IDEAL-Tick Indicator")
}

sw = ui[2]:add_keybind("ideal")

--vars
ideal_font  = render.create_font("Smallest Pixel", 14, 700, e_font_flags.OUTLINE)
screen_size = render.get_screen_size()
dh_fade     = 0
fade        = 0

--function
functions = {
    --hide
    [1] = function()
        for t1 = 1, #ui do
            if t1 == 1 then
                goto for_end
            else    
                ui[t1]:set_visible(ui[1]:get())
            end

            :: for_end ::
        end
    end,

    --IDEAL Indicator
    [2] = function()
        if not ui[1]:get() and not ui[3]:get() then return end

        if not get_menu[2][2]:get() then return end

        if not engine.is_connected() then return end
        if not engine.is_in_game() then return end
    
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
    
        if local_player:get_prop("m_iHealth") <= 0 then
            return 
        end
    
        if sw:get() then
            fade = 255
        else
            fade = 0
        end
        
        if fade ~= dh_fade then
            if dh_fade > fade then
                dh_fade = dh_fade - 15
            else
                dh_fade = dh_fade + 15
            end
        end
    
        size = render.get_text_size(ideal_font, "::  IDEAL - TICK  ::")
        render.text(ideal_font, "::  IDEAL - TICK  ::", vec2_t(screen_size.x/2 - size.x/2, screen_size.y/4), color_t(255, 255, 255, dh_fade))

    end,
    
    --IDEAL Set
    [3] = function()
        if not ui[1]:get() then return end
        if not get_menu[2][2]:get() then return end

        if not engine.is_connected() then return end
        if not engine.is_in_game() then return end
    
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
    
        if local_player:get_prop("m_iHealth") <= 0 then
            return 
        end

        if not sw:get() then
            get_menu[1]:set(ref_fl)
        else
            get_menu[1]:set(0)
        end

    end

}

--callbacks
callbacks.add(e_callbacks.PAINT, function()
    for t2 = 1, #functions do
        functions[t2]()
    end
end)