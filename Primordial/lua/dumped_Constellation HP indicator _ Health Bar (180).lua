local ui = menu.add_checkbox("Constellation HP indicator / Health Bar", "Enable", false)
local color = ui:add_color_picker("bruh color")
local key2 = {menu.add_slider("Constellation HP indicator / Health Bar", "X", 1, 1920),menu.add_slider("Constellation HP indicator / Health Bar", "Y", 1, 1080)}
local y = 0;

local function draw_line(p1, p2, o1, o2)
    render.line(vec2_t(p1,p2),    vec2_t(o1, o2-y)    , color:get())
    render.line(vec2_t(p1,p2+1),  vec2_t(o1, o2+1-y)  , color:get())
    render.line(vec2_t(p1,p2+2),  vec2_t(o1, o2+2-y)  , color:get())
    render.line(vec2_t(p1,p2+2.4),vec2_t(o1, o2+2.4-y), color:get())
    render.line(vec2_t(p1,p2-y),  vec2_t(o1, o2+y)    , color:get())
end

local function CircleFilled(p3,p4, p5, p6, c1)
    render.circle_filled(vec2_t.new(p3, p4),3,color:get())
end

local texturez = render.load_image("primordial//scripts//gris.png")

function on_paint()
		local xx, yy = key2[1]:get(), key2[2]:get()

        if ui:get() then
            render.texture(texturez.id, vec2_t(xx, yy), vec2_t.new(722, 126))
			local lp_index = entity_list.get_local_player()
            if not lp_index then return end
            if engine.is_connected() then
            local hp = lp_index:get_prop("m_iHealth")
            local hp_true = lp_index:get_prop("m_iHealth")
            local frametime = 1

            
            local t = frametime * (10 + math.abs(lp_index:get_prop("m_iHealth") - hp) * 1.3);
    
            if hp > lp_index:get_prop("m_iHealth") then
                hp = math.max(hp - t, lp_index:get_prop("m_iHealth"))
            elseif hp < lp_index:get_prop("m_iHealth") then
                hp = math.min(hp + t, lp_index:get_prop("m_iHealth"))
            end
           
            if (hp > 0) then
                
            end
            if hp == 100 then
                CircleFilled(xx + 712, yy + 58, 5, 4, color:get())
            end
            if hp > 90 then
                local o_x = (712 - 666) * (1 - ((hp - 90) / 10))
                local o_y = (58 - 47) * (1 - ((hp - 90) / 10))
                CircleFilled(xx + 666, yy + 47-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 394, yy + 52-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 358, yy + 41-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 232, yy + 48-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 160, yy + 64-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 666, yy + 47, xx + 712 - o_x, yy + 58 - o_y)
                draw_line(xx + 394, yy + 52, xx + 666, yy + 47)
                draw_line(xx + 358, yy + 41, xx + 394, yy + 52)
                draw_line(xx + 232, yy + 48, xx + 358, yy + 41)
                draw_line(xx + 160, yy + 64, xx + 232, yy + 48)
                draw_line(xx + 131, yy + 51, xx + 160, yy + 64)
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            elseif (hp > 50) then
                local o_x = (666 - 394) * (1 - (hp - 50) / 40)
                local o_y = (47 - 52) * (1 - (hp - 50) / 40)
                CircleFilled(xx + 394, yy + 52-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 358, yy + 41-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 232, yy + 48-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 160, yy + 64-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx + 116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 394, yy + 52, xx + 666 - o_x, yy + 47 - o_y)
                draw_line(xx + 358, yy + 41, xx + 394, yy + 52)
                draw_line(xx + 232, yy + 48, xx + 358, yy + 41)
                draw_line(xx + 160, yy + 64, xx + 232, yy + 48)
                draw_line(xx + 131, yy + 51, xx + 160, yy + 64)
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            elseif (hp > 40) then
                local o_x = (394 - 358) * ((hp - 50) / -10)
                local o_y = (52 - 41) * ((hp - 50) / -10)
                CircleFilled(xx +358, yy + 41-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +232, yy + 48-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +160, yy + 64-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 358, yy + 41, xx + 394 - o_x, yy + 52 - o_y)
    
                draw_line(xx + 232, yy + 48, xx + 358, yy + 41)
                draw_line(xx + 160, yy + 64, xx + 232, yy + 48)
                draw_line(xx + 131, yy + 51, xx + 160, yy + 64)
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            elseif (hp > 20) then
                local o_x = (358 - 232) * ((hp - 40) / -20)
                local o_y = (41 - 48) * ((hp - 40) / -20)
                CircleFilled(xx +232, yy + 48-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +160, yy + 64-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 232, yy + 48, xx + 358 - o_x, yy + 41 - o_y)
    
                draw_line(xx + 160, yy + 64, xx + 232, yy + 48)
                draw_line(xx + 131, yy + 51, xx + 160, yy + 64)
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            elseif (hp > 10) then
                local o_x = (232 - 160) * ((hp - 20) / -10)
                local o_y = (48 - 64) * ((hp - 20) / -10)
                CircleFilled(xx +160, yy + 64-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 160, yy + 64, xx + 232 - o_x, yy + 48 - o_y)
    
                draw_line(xx + 131, yy + 51, xx + 160, yy + 64)
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            elseif (hp > 5) then
                local o_x = (160 - 131) * ((hp - 10) / -5)
                local o_y = (64 - 51) * ((hp - 10) / -5)
                CircleFilled(xx +131, yy + 51-y, 5, 4, color_t(180, 190, 200, 255))
                CircleFilled(xx +116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                draw_line(xx + 131, yy + 51, xx + 160 - o_x, yy + 64 - o_y)
    
                draw_line(xx + 116, yy + 65, xx + 131, yy + 51)
            else
                if (hp > 0) then
                    local o_x = (131 - 116) * ((hp - 5) / -5)
                    local o_y = (51 - 65) * ((hp - 5) / -5)
                    CircleFilled(xx +116, yy + 65-y, 5, 4, color_t(180, 190, 200, 255))
                
                    draw_line(xx + 116, yy + 65, xx + 131 - o_x, yy + 51 - o_y)
                end
            end
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)