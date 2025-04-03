-- SCREEN & FONT
local main_font = render.create_font("Verdana", 12, 200, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW) -- font
local screen_size = render.get_screen_size() -- screen
local ctx, cty = screen_size.x / 2, screen_size.y / 2 -- x and y

-- VARS
local dt_ref = menu.find("aimbot","general","exploits","doubletap","enable") -- get doubletap
local hs_ref = menu.find("aimbot","general","exploits","hideshots","enable") -- get hideshots
local damage_override = menu.find("aimbot", "auto", "target overrides", "force min. damage") -- get damage override
local force_baim = menu.find("aimbot","scout","target overrides","force hitbox") -- get froce baim
local aa = menu.find("antiaim","main","angles","yaw base") -- get yaw base

-- MENU
local checkbox = menu.add_checkbox("Indicator", "Turn On") -- checkbox ( turn on the indicator)

-- FUNCTION
function on_paint()

    if not engine.is_connected() then
        return
      end
      
    if not engine.is_in_game() then
        return
    end
      
    local local_player = entity_list.get_local_player()
      
    if not local_player:get_prop("m_iHealth") then
        return
    end

    local ind_dst = 0
    local ind_spr = 9

    if local_player:is_alive() then -- check if player is alive

        if checkbox:get() then

            -- render AAs
            if antiaim.is_inverting_desync() then
                render.text(main_font, "LEFT", vec2_t(ctx, cty + 20 + ind_dst), color_t(255, 255, 255, 255)) -- render text
                ind_dst = ind_dst + ind_spr -- next indicator go down when this one is active
            elseif not antiaim.is_inverting_desync() then
                render.text(main_font, "RIGHT", vec2_t(ctx, cty + 20 + ind_dst), color_t(255, 255, 255, 255))
                ind_dst = ind_dst + ind_spr 
            end
            
            -- render doubletap
            if dt_ref[2]:get() then

                if exploits.get_charge() >= 1 then
                    render.text(main_font, "DT", vec2_t(ctx, cty + 20 + ind_dst), color_t(127,255,0,255))
                    ind_dst = ind_dst + ind_spr
                end

                if exploits.get_charge() < 1 then
                    render.text(main_font, "DT", vec2_t(ctx, cty + 20 + ind_dst), color_t(255,0,0,255))
                    ind_dst = ind_dst + ind_spr
                end

            end

            -- render hideshots
            if hs_ref[2]:get() then
                render.text(main_font, "HIDE", vec2_t(ctx, cty + 20 + ind_dst), color_t(255,255,51,255))
                ind_dst = ind_dst + ind_spr
            end

            -- render fakeduck
            if antiaim.is_fakeducking() then 
                render.text(main_font, "DUCK", vec2_t(ctx, cty + 20 + ind_dst), color_t(255, 255, 255, 255))
                ind_dst = ind_dst + ind_spr
            end

            -- render damage override
            if damage_override[2]:get() then 
                render.text(main_font, "DMG", vec2_t(ctx, cty + 20 + ind_dst), color_t(255, 255, 255, 255))
                ind_dst = ind_dst + ind_spr
            end

            -- render force baim
            if force_baim[2]:get() then 
                render.text(main_font, "BAIM", vec2_t(ctx, cty + 20 + ind_dst), color_t(255, 255, 255, 255))
                ind_dst = ind_dst + ind_spr
            end
    
        end

    else
    end

end

-- CALLBACKS
callbacks.add(e_callbacks.PAINT, on_paint)