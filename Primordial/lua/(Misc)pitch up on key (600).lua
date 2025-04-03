-- pitch reference
local pitch = menu.find("antiaim", "main", "angles", "pitch")

-- lua menu
local menu_toggle   = menu.add_checkbox("pitch toggle", "pitch toggle")
local menu_keybind  = menu_toggle:add_keybind("keybind")



local function on_paint()
    if menu_keybind:get() and menu_toggle:get() == true then
        pitch:set(4)
    else
        pitch:set(2)
    end
end

-- paint callback
callbacks.add(e_callbacks.PAINT, on_paint)