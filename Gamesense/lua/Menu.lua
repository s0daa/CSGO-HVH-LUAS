-- https://github.com/s0daa/CSGO-HVH-LUAS

local labelmenusafe = ui.new_label("MISC", "Settings", "\a3B3B3BFF~ for crack users ~")

local menucolorcheckbox = ui.new_checkbox("MISC", "Settings", "\aFFFFFF90☀ \a9FCA2BFFSave your menu color")
local menucolorpicker = ui.new_color_picker("MISC", "Settings", "\n Save your menu color", 159, 202, 43, 255)
local menu_color = ui.reference("MISC", "Settings", "Menu color")

local menu_lock_enabled = ui.new_checkbox("MISC", "Settings", "\aFFFFFF90◲ \a9FCA2BFFLock menu layout")
local lock_menu_layout = ui.reference("MISC", "Settings", "Lock menu layout")

local dpiscale = ui.new_combobox("MISC", "Settings", "\aFFFFFF90⊞ \a9FCA2BFFDPI scale", { "100%", "125%", "150%", "175%", "200%" })
local dpiscaleref = ui.reference("MISC", "Settings", "DPI scale", { "100%", "125%", "150%", "175%", "200%" })

local function menucolor_picker()
    if ui.get(menucolorcheckbox) then
        ui.set_visible(menucolorpicker, true)
    else
        ui.set_visible(menucolorpicker, false)
    end

    if ui.get(menucolorcheckbox) then
        local r, g, b, a = ui.get(menucolorpicker)  
        ui.set(menu_color, r, g, b, a)
    end
end

local function dpiscale_enabler()
    if ui.get(dpiscale) == "100%" then
        ui.set(dpiscaleref, "100%")
    end

    if ui.get(dpiscale) == "125%" then
        ui.set(dpiscaleref, "125%")
    end

    if ui.get(dpiscale) == "150%" then
        ui.set(dpiscaleref, "150%")
    end

    if ui.get(dpiscale) == "175%" then
        ui.set(dpiscaleref, "175%")
    end

    if ui.get(dpiscale) == "200%" then
        ui.set(dpiscaleref, "200%")
    end
end

local function menu_layout_enabler()
    if ui.get(menu_lock_enabled) then
        ui.set(lock_menu_layout, true)
    else
        ui.set(lock_menu_layout, false)
    end
end

client.set_event_callback("paint_ui", function()
    menucolor_picker()
    menu_layout_enabler()
    dpiscale_enabler()
end)
