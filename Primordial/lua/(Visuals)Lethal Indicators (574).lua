--lethal indicators--
local screen_size = render.get_screen_size()
local style = menu.add_selection("Lethal Indicators", "style", {"none","HL2-ish", "circle", "screen border", "traffic lights", "text", "healthshot"})
local offset = menu.add_slider("Lethal Indicators", "offset", -200, 200)
local saturation = menu.add_slider("Lethal Indicators", "saturation", 1, 255)
local position_x = menu.add_slider("Lethal Indicators", "Position X", -1500, 1500)
local position_y = menu.add_slider("Lethal Indicators", "Position Y", -1500, 1500)
local separator = menu.add_text("Lethal Indicators", "-----------------------------------------------------------------------------------------------")
local hud = menu.add_checkbox("Lethal Indicators", "blink hud when lethal")
local sp7 = render.create_font("Smallest Pixel-7", 11, 20, e_font_flags.OUTLINE)
--
local hud_cvar = cvars.cl_hud_color
local original_hud_color = hud_cvar:get_int()
if original_hud_color == 5 then -- just in case if someone has red hud already
    original_hud_color = 0
end
--
local w1 = 0
local w2 = 0
local w3 = 0
--
    
local function paint_callback()
        --menu shit
        if style:get()==1 then
            offset:set_visible(false)
            saturation:set_visible(false)
            position_x:set_visible(false)
            position_y:set_visible(false)
        end
        if style:get()==2 then
            offset:set_visible(true)
            saturation:set_visible(true)
            position_x:set_visible(false)
            position_y:set_visible(false)
        end
        if style:get()==3 then
            offset:set_visible(true)
            saturation:set_visible(true)
            position_x:set_visible(false)
            position_y:set_visible(false)
        end
        if style:get()==6 then
            offset:set_visible(false)
            saturation:set_visible(false)
            position_x:set_visible(true)
            position_y:set_visible(true)
        end
        if style:get()==5 then
            offset:set_visible(false)
            saturation:set_visible(false)
            position_x:set_visible(true)
            position_y:set_visible(true)
        end
        if style:get()==7 then
            offset:set_visible(false)
            saturation:set_visible(false)
            position_x:set_visible(false)
            position_y:set_visible(false)
        end
    local local_player = entity_list.get_local_player()
    if not local_player then return end
    local health = local_player:get_prop("m_iHealth")
   if health < 93 and health > 0 then
        if w2 == 0 and w1 < 60 then
            w1 = w1 + 1
            if w1 >= 60 then
                w2 = 1
            end
        elseif w2 == 1 then
            w1 = w1 - 1
            if w1 <= 0 then
                w2 = 0
            end
        end

        if hud:get()==true then
            if w1 == 50 then
                w3 = w3 +1
            end
            if w3 == 6 then
                w3 = 0
            end
            if w3 >= 3 then
            hud_cvar:set_int(5)
            else
            hud_cvar:set_int(original_hud_color)
            end
        else
            hud_cvar:set_int(original_hud_color)
        end

        if style:get()==2 then --half life'ish
            if health < 1 then return end
            --left
        render.polygon({
            vec2_t(screen_size.x/2-70-offset:get(),screen_size.y/2+50),
            vec2_t(screen_size.x/2-5-offset:get(),screen_size.y/2+80),
            vec2_t(screen_size.x/2-10-offset:get(),screen_size.y/2+50),
            vec2_t(screen_size.x/2-10-offset:get(),screen_size.y/2-50),
            vec2_t(screen_size.x/2-5-offset:get(),screen_size.y/2-80),
            vec2_t(screen_size.x/2-70-offset:get(),screen_size.y/2-50)},
            color_t(saturation:get(),0,0,w1))
            --right
        render.polygon({
            vec2_t(screen_size.x/2+70+offset:get(),screen_size.y/2-50),
            vec2_t(screen_size.x/2+5+offset:get(),screen_size.y/2-80),
            vec2_t(screen_size.x/2+10+offset:get(),screen_size.y/2-50),
            vec2_t(screen_size.x/2+10+offset:get(),screen_size.y/2+50),
            vec2_t(screen_size.x/2+5+offset:get(),screen_size.y/2+80),
            vec2_t(screen_size.x/2+70+offset:get(),screen_size.y/2+50)},
            color_t(saturation:get(),0,0,w1))

        elseif style:get()==3 then --circle
            if health < 1 then return end
            render.circle_filled(vec2_t.new(screen_size.x/2, screen_size.y/2), 25+offset:get()+w1+10, color_t.new(saturation:get(),0,0,70-w1))
            render.circle_filled(vec2_t.new(screen_size.x/2, screen_size.y/2), 15+offset:get()+w1, color_t.new(saturation:get(),0,0,65-w1+5))
            render.circle_filled(vec2_t.new(screen_size.x/2, screen_size.y/2), 15+offset:get()+w1-10, color_t.new(saturation:get(),0,0,30-w1+30))

        elseif style:get()==4 then --screen border
            if health < 1 then return end
                offset:set_visible(false)
                saturation:set_visible(false)
                position_x:set_visible(false)
                position_y:set_visible(false)
            render.rect(vec2_t(2, 2), vec2_t(screen_size.x-2, screen_size.y-2), color_t(255, 0, 0, (100 - health)))
            render.rect(vec2_t(1, 1), vec2_t(screen_size.x-1, screen_size.y-1), color_t(255, 0, 0, (100 - health)))
            render.rect(vec2_t(0, 0), vec2_t(screen_size.x, screen_size.y), color_t(255, 0, 0, (100 - health)))

        elseif style:get()==6 then --text
            if health < 1 then return end
            render.text(sp7, "LETHAL", vec2_t(screen_size.x/2+position_x:get()-(render.get_text_size(sp7, "LETHAL").x)/2+2, screen_size.y/2-15+position_y:get()), color_t(255,255,255,255))
    end

     end

    if style:get()==5 then --twaffic lighg 
        if health < 1 then return end
    --background
        render.rect_filled(vec2_t(screen_size.x/2-40+position_x:get(), screen_size.y/2-400+position_y:get()), vec2_t(80,200), color_t(0,0,0,255), 5)
        render.rect(vec2_t(screen_size.x/2-40+position_x:get(), screen_size.y/2-400+position_y:get()), vec2_t(80,200), color_t(100,100,100,255), 5)
    --red not active
        render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-360+position_y:get()), 20, color_t(60,0,0,255))
        render.circle(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-360+position_y:get()), 20, color_t(255,0,0,255))
    --yellow not active
        render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-300+position_y:get()), 20, color_t(60,60,0,255))
        render.circle(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-300+position_y:get()), 20, color_t(255,255,0,255))
    --green not active
        render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-240+position_y:get()), 20, color_t(0,60,0,255))
        render.circle(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-240+position_y:get()), 20, color_t(0,255,0,255))

    --active
    if health <= 10 then
    --red
    render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-360+position_y:get()), 20, color_t(255-w1-w1,0,0,255))
    end

    if health < 50 and health > 10 then
    --red
    render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-360+position_y:get()), 20, color_t(255,0,0,255))
    end

    if health < 93 and health >= 50 then
    --yellow
    render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-300+position_y:get()), 20, color_t(255,255,0,255))
    end

    if health > 93 then
    --green
    render.circle_filled(vec2_t.new(screen_size.x/2+position_x:get(), screen_size.y/2-240+position_y:get()), 20, color_t(0,255,0,255))
    end
    end

    if style:get()==7 then --healthshot effect
        if health < 1 then return end
        local curtime = global_vars.cur_time()
            if health <= 50 then
                local_player:set_prop("m_flHealthShotBoostExpirationTime", curtime + (100 - 2 * health) / 100)
            end
    end
end
--hello nezu--
callbacks.add(e_callbacks.PAINT,paint_callback)