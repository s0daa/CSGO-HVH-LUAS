local indicfont = render.create_font("Tahoma", 12, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
local screen_size = render.get_screen_size()
local x, y = screen_size.x / 2, screen_size.y / 2
local checkbox = menu.add_checkbox("Ideal Yaw Indicator", "Turn On")
local dtenabled = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local hsenabled = menu.find("aimbot", "general", "exploits", "hideshots", "enable")




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

    if local_player:is_alive() and checkbox:get() then
        local ind_dst = 0
        local ind_spr = 8
        local text = "BASIC"
        local size = render.get_text_size(indicfont, text)

        render.text(indicfont, "IDEAL YAW", vec2_t(x, y + 40), color_t(218, 118, 0))
        render.text(indicfont, "DYNAMIC", vec2_t(x, y + 50), color_t(234, 115, 255))

        local dt_color = color_t(0, 0, 0, 0)
        local hs_color = color_t(234, 115, 255)

        if dtenabled[2]:get() then
            if exploits.get_charge() < 1 then
                dt_color = color_t(255, 0, 0)
            else
                dt_color = color_t(0, 255, 0)
            end
        end

        --DT
        if dtenabled[2]:get() then
            render.text(indicfont, "DT", vec2_t(x, y + 60 + ind_dst), dt_color)
        else
            render.text(indicfont, "DT", vec2_t(x, y + 60 + ind_dst), color_t(0, 0, 0, 0))
        end
        if hsenabled[2]:get() and not dtenabled[2]:get() then
            render.text(indicfont, "AA", vec2_t(x, y + 60 + ind_dst), hs_color)
        else
            render.text(indicfont, "AA", vec2_t(x, y + 60 + ind_dst), color_t(0, 0, 0, 0))
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)