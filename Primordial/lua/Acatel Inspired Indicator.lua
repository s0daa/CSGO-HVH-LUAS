local font_inds = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.OUTLINE) -- font

local screen_size = render.get_screen_size() -- screen
local x, y = screen_size.x / 2, screen_size.y / 2 -- x and y

local checkbox = menu.add_checkbox("Indicator", "Turn On") -- checkbox ( turn on the indicator)

local text_inds = 10

local dt_ref = menu.find("aimbot","general","exploits","doubletap","enable") -- get doubletap
local hs_ref = menu.find("aimbot","general","exploits","hideshots","enable") -- get hideshots
local direction = menu.find("antiaim","main","auto direction","enable") -- get auto direction 
local damage_override = menu.find("aimbot", "auto", "target overrides", "force min. damage") -- get damage override

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

    local baim_color = color_t(255,255,255,255)
	local hs_color = color_t(255,255,255,255)
	local sp_color = color_t(255,255,255,255)
	local fakeduck_color = color_t(255,255,255,255)
    local damage_color = color_t(255,255,255,255)

    if local_player:is_alive() then
        if checkbox:get() then

            local ind_dst = 0
            local ind_spr = 8

            local text = "BASIC"
            local size = render.get_text_size(font_inds, text)

            if direction[2]:get() then
                acatel_style_2 = "FREESTAND"
            elseif antiaim.is_inverting_desync() then
                acatel_style_2 = "LEFT"
            else
                acatel_style_2 = "RIGHT"
            end

                render.text(font_inds, "SMART:  ", vec2_t(x, y + 28.5), color_t(220, 91, 97, 255)) -- render text
                render.text(font_inds, acatel_style_2, vec2_t(x + 29, y + 28), color_t(138, 137, 204, 255)) -- render text
                    
                local dt_color = color_t(1,1,1,255)
                    
                if dt_ref[2]:get() then
                    
                    if exploits.get_charge() < 1 then
                        dt_color = color_t(255,0,0,255)
                    else
                        dt_color = color_t(255,255,255,255)
                    end
                end
                    
                --DT
                if dt_ref[2]:get() then
                    render.text(font_inds, "DT", vec2_t(x, y + 36 + ind_dst), dt_color) -- render text
                else
                    render.text(font_inds, "DT", vec2_t(x, y + 36 + ind_dst), color_t(48,48,48,255)) -- render tex
                end

                -- hideshots
                if hs_ref[2]:get() then
                    render.text(font_inds, "HS", vec2_t(x + 13, y + 36 + ind_dst), hs_color) -- render text
                else
                    render.text(font_inds, "HS", vec2_t(x + 13, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- safepoint
                if antiaim.is_fakeducking() then
                    render.text(font_inds, "FD", vec2_t(x + 26, y + 36 + ind_dst), fakeduck_color) -- render text
                else
                    render.text(font_inds, "FD", vec2_t(x + 26, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end

                -- damage override
                if damage_override[2]:get() then
                    render.text(font_inds, "DMG", vec2_t(x + 39, y + 36 + ind_dst), damage_color) -- render text
                else
                    render.text(font_inds, "DMG", vec2_t(x + 39, y + 36 + ind_dst), color_t(48,48,48,255)) -- render text
                end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)