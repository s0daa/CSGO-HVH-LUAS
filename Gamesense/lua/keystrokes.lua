local kw, ka, ks, kd, space, crouch, m1, m2 = 0x57, 0x41, 0x53, 0x44, 0x20, 0x11, 0x01, 0x02
local w, h = client.screen_size()
local visible = ui.set_visible
local gui = {
    enable = ui.new_checkbox("lua", "a", "Keystrokes"),
    accent = ui.new_color_picker("lua", "a", "ksaccent", 56, 124, 198, 125),
    opt = ui.new_multiselect("lua", "a", "\n", "Boxes", "Mouse buttons", "Space", "Crouch"),
    accent2 = ui.new_color_picker("lua", "a", "ksaccent2", 20, 20, 20, 125),
    size = ui.new_slider("lua", "a", "\n\n", -10, 5, 0, true, "px"),
    text = ui.new_color_picker("lua", "a", "ksaccent2", 255, 255, 255, 255),
    gap = ui.new_slider("lua", "a", "\n\n\n", 0, 10, 5, true, "px"),
    text2 = ui.new_color_picker("lua", "a", "ksaccent2", 255, 255, 255, 255)
}
local wnd = {
    x = database.read("ks_x") or 300,
    y = database.read("ks_y") or h/2,
    dragging = false
}

local function intersect(x, y, w, h, debug) 
    local cx, cy = ui.mouse_position()
    debug = debug or false
    if debug then 
        renderer.rectangle(x, y, w, h, 255, 0, 0, 50)
    end
    return cx >= x and cx <= x + w and cy >= y and cy <= y + h
end

local function Contains(table, val) --thanks sapphyrus
    for i = 1, #table do
        if table[i] == val then
            return true
        end
    end
    return false
end

client.set_event_callback("paint", function()
    if ui.get(gui.enable) then
        visible(gui.opt, true)
        visible(gui.accent, true)
        visible(gui.accent2, true)
        visible(gui.text, true)
        visible(gui.text2, true)
        visible(gui.size, true)
        visible(gui.gap, true)
    else
        visible(gui.opt, false)
        visible(gui.accent, false)
        visible(gui.accent2, false)
        visible(gui.text, false)
        visible(gui.text2, false)
        visible(gui.size, false)
        visible(gui.gap, false)
    end
end)

client.set_event_callback("paint", function()
    local cx, cy = ui.mouse_position()
    local r, g, b, a = ui.get(gui.accent)
    local br, bg, bb, ba = ui.get(gui.accent2)
    local tr, tg, tb, ta = ui.get(gui.text)
    local btr, btg, btb, bta = ui.get(gui.text2)
    local size = ui.get(gui.size)
    local gap = ui.get(gui.gap) + size

    if ui.is_menu_open() then 
        
        if wnd.dragging and not client.key_state(m1) then
            wnd.dragging = false
        end
    
        if wnd.dragging and client.key_state(m1) then
            wnd.x = cx - wnd.drag_x
            wnd.y = cy - wnd.drag_y
        end
    
        if intersect(wnd.x, wnd.y - 10, 50, 5) and client.key_state(m1) then 
            wnd.dragging = true
            wnd.drag_x = cx - wnd.x
            wnd.drag_y = cy - wnd.y
        end

    end

    if client.key_state(m1) then
        if ui.is_menu_open() then
            if (wnd.x - 115 - gap) < 0 then wnd.x = 115 + gap end
            if (wnd.x + 100 + gap) > (w-50) then wnd.x = (w-100) - 50 - gap end
            if (wnd.y - 10) < 0 then wnd.y = 10 end
            if (wnd.y + 150) > h then wnd.y = (h-150) - gap end
        end
    end

    if ui.get(gui.enable) then
        if ui.is_menu_open() then
            renderer.rectangle(wnd.x - 1, wnd.y - 10, 50 + size + 2, 5, r, g, b, 255)
        end

        if client.key_state(kw) then
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x, wnd.y, 50 + size, 50 + size, r, g, b, a)
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 25 + (size/2), tr, tg, tb, ta, "c+", 0, "W")
            else
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 25 + (size/2), r, g, b, a, "c+", 0, "W")
            end
        else
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x, wnd.y, 50 + size, 50 + size, br, bg, bb, ba)
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 25 + (size/2), btr, btg, btb, bta, "c+", 0, "W")
            else
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 25 + (size/2), 255, 255, 255, bta, "c+", 0, "W")
            end
        end

        if client.key_state(ka) then
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x - 50 - gap, wnd.y + 50 + gap, 50 + size, 50 + size, r, g, b, a)
                renderer.text(wnd.x - 25 - gap + (size/2), wnd.y + 75 + gap + (size/2), tr, tg, tb, ta, "c+", 0, "A")
            else
                renderer.text(wnd.x - 25 - gap + (size/2), wnd.y + 75 + gap + (size/2), r, g, b, a, "c+", 0, "A")
            end
        else
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x - 50 - gap, wnd.y + 50 + gap, 50 + size, 50 + size, br, bg, bb, ba)
                renderer.text(wnd.x - 25 - gap + (size/2), wnd.y + 75 + gap + (size/2), btr, btg, btb, bta, "c+", 0, "A")
            else
                renderer.text(wnd.x - 25 - gap + (size/2), wnd.y + 75 + gap + (size/2), 255, 255, 255, bta, "c+", 0, "A")
            end
        end

        if client.key_state(ks) then
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x, wnd.y + 50 + gap, 50 + size, 50 + size, r, g, b, a)
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 75 + gap + (size/2), tr, tg, tb, ta, "c+", 0, "S")
            else
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 75 + gap + (size/2), r, g, b, a, "c+", 0, "S")
            end
        else
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x, wnd.y + 50 + gap, 50 + size, 50 + size, br, bg, bb, ba)
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 75 + gap + (size/2), btr, btg, btb, bta, "c+", 0, "S")
            else
                renderer.text(wnd.x + 25 + (size/2), wnd.y + 75 + gap + (size/2), 255, 255, 255, bta, "c+", 0, "S")
            end
        end

        if client.key_state(kd) then
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x + 50 + gap, wnd.y + 50 + gap, 50 + size, 50 + size, r, g, b, a)
                renderer.text(wnd.x + 75 + gap + (size/2), wnd.y + 75 + gap + (size/2), tr, tg, tb, ta, "c+", 0, "D")
            else
                renderer.text(wnd.x + 75 + gap + (size/2), wnd.y + 75 + gap + (size/2), r, g, b, a, "c+", 0, "D")
            end
        else
            if Contains(ui.get(gui.opt), "Boxes") then
                renderer.rectangle(wnd.x + 50 + gap, wnd.y + 50 + gap, 50 + size, 50 + size, br, bg, bb, ba)
                renderer.text(wnd.x + 75 + gap + (size/2), wnd.y + 75 + gap + (size/2), btr, btg, btb, bta, "c+", 0, "D")
            else
                renderer.text(wnd.x + 75 + gap + (size/2), wnd.y + 75 + gap + (size/2), 255, 255, 255, bta, "c+", 0, "D")
            end
        end

        if Contains(ui.get(gui.opt), "Space") then
            if client.key_state(space) then
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x - 50 - gap, wnd.y + 100 + gap*2, 150 + (gap*2) + size, 50 + size, r, g, b, a)
                    renderer.text(wnd.x + 25 + (size/2), wnd.y + 125 + gap*2 + (size/2), tr, tg, tb, ta, "c+", 0, "SPACE")
                else
                    renderer.text(wnd.x + 25 + (size/2), wnd.y + 125 + gap*2 + (size/2), r, g, b, a, "c+", 0, "SPACE")
                end
            else
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x - 50 - gap, wnd.y + 100 + gap*2, 150 + (gap*2) + size, 50 + size, br, bg, bb, ba)
                    renderer.text(wnd.x + 25 + (size/2), wnd.y + 125 + gap*2 + (size/2), btr, btg, btb, bta, "c+", 0, "SPACE")
                else
                    renderer.text(wnd.x + 25 + (size/2), wnd.y + 125 + gap*2 + (size/2), 255, 255, 255, bta, "c+", 0, "SPACE")
                end
            end
        end

        if Contains(ui.get(gui.opt), "Crouch") then
            if Contains(ui.get(gui.opt), "Space") then
                if client.key_state(crouch) then
                    if Contains(ui.get(gui.opt), "Boxes") then
                        renderer.rectangle(wnd.x - 100 - gap*2, wnd.y + 100 + gap*2, 50 + size, 50 + size, r, g, b, a)
                        renderer.text(wnd.x - 77 - gap*2 + (size/2), wnd.y + 122 + gap*2 + (size/2), tr, tg, tb, ta, "c+", 0, "⮟")
                    else
                        renderer.text(wnd.x - 77 - gap*2 + (size/2), wnd.y + 122 + gap*2 + (size/2), r, g, b, a, "c+", 0, "⮟")
                    end
                else
                    if Contains(ui.get(gui.opt), "Boxes") then
                        renderer.rectangle(wnd.x - 100 - gap*2, wnd.y + 100 + gap*2, 50 + size, 50 + size, br, bg, bb, ba)
                        renderer.text(wnd.x - 77 - gap*2 + (size/2), wnd.y + 122 + gap*2 + (size/2), btr, btg, btb, bta, "c+", 0, "⮟")
                    else
                        renderer.text(wnd.x - 77 - gap*2 + (size/2), wnd.y + 122 + gap*2 + (size/2), 255, 255, 255, bta, "c+", 0, "⮟")
                    end
                end
            else
                if client.key_state(crouch) then
                    if Contains(ui.get(gui.opt), "Boxes") then
                        renderer.rectangle(wnd.x - 50 - gap, wnd.y + 100 + gap*2, 150 + (gap*2) + size, 50 + size, r, g, b, a)
                        renderer.text(wnd.x + 25 + (size/2), wnd.y + 122 + gap*2 + (size/2), tr, tg, tb, ta, "c+", 0, "⮟")
                    else
                        renderer.text(wnd.x + 25 + (size/2), wnd.y + 122 + gap*2 + (size/2), r, g, b, a, "c+", 0, "⮟")
                    end
                else
                    if Contains(ui.get(gui.opt), "Boxes") then
                        renderer.rectangle(wnd.x - 50 - gap, wnd.y + 100 + gap*2, 150 + (gap*2) + size, 50 + size, br, bg, bb, ba)
                        renderer.text(wnd.x + 25 + (size/2), wnd.y + 122 + gap*2 + (size/2), btr, btg, btb, bta, "c+", 0, "⮟")
                    else
                        renderer.text(wnd.x + 25 + (size/2), wnd.y + 122 + gap*2 + (size/2), 255, 255, 255, bta, "c+", 0, "⮟")
                    end
                end
            end
        end

        if Contains(ui.get(gui.opt), "Mouse buttons") then
            if client.key_state(m1) then
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x + 100 + gap*2, wnd.y + 50 + gap, 50 + size, 50 + size, r, g, b, a)
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 75 + gap + (size/2), tr, tg, tb, ta, "c+", 0, "M1")
                else
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 75 + gap + (size/2), r, g, b, a, "c+", 0, "M1")
                end
            else
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x + 100 + gap*2, wnd.y + 50 + gap, 50 + size, 50 + size, br, bg, bb, ba)
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 75 + gap + (size/2), btr, btg, btb, bta, "c+", 0, "M1")
                else
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 75 + gap + (size/2), 255, 255, 255, bta, "c+", 0, "M1")
                end
            end

            if client.key_state(m2) then
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x + 100 + gap*2, wnd.y + 100 + gap*2, 50 + size, 50 + size, r, g, b, a)
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 125 + gap*2 + (size/2), tr, tg, tb, ta, "c+", 0, "M2")
                else
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 125 + gap*2 + (size/2), r, g, b, a, "c+", 0, "M2")
                end
            else
                if Contains(ui.get(gui.opt), "Boxes") then
                    renderer.rectangle(wnd.x + 100 + gap*2, wnd.y + 100 + gap*2, 50 + size, 50 + size, br, bg, bb, ba)
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 125 + gap*2 + (size/2), btr, btg, btb, bta, "c+", 0, "M2")
                else
                    renderer.text(wnd.x + 125 + gap*2 + (size/2), wnd.y + 125 + gap*2 + (size/2), 255, 255, 255, bta, "c+", 0, "M2")
                end
            end
        end

    end
end)

client.set_event_callback("shutdown", function()
    database.write("ks_x", wnd.x)
    database.write("ks_y", wnd.y)
end)
