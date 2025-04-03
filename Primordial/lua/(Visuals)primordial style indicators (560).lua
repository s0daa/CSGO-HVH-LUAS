local checkbox = menu.add_checkbox("Indicators", "Indicators", false)
local colorpicker = checkbox:add_color_picker("Indicators")

local font = render.create_font("Calibri", 16, 400, e_font_flags.DROPSHADOW)

function indicators()
    
    local isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable")[2]
    local isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2]
    local isFS = menu.find("antiaim", "main", "auto direction", "enable")[2]
    local AutoO = menu.find("aimbot", "auto", "target overrides", "force min. damage")[2] 
    local ScoutO = menu.find("aimbot", "scout", "target overrides", "force min. damage")[2] 
    local DeagleO = menu.find("aimbot", "deagle", "target overrides", "force min. damage")[2] 
    local RevolverO = menu.find("aimbot", "revolver", "target overrides", "force min. damage")[2] 
    local PistolO = menu.find("aimbot", "pistols", "target overrides", "force min. damage")[2] 
    local AwpO = menu.find("aimbot", "awp", "target overrides", "force min. damage")[2] 
    local PING = menu.find("aimbot", "general", "fake ping", "enable")[2]

    local ay = 0

    if isDT:get( ) then
        if isDT:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(20, 18), color_t(20,20,20,85)) end
        if isDT:get() then render.text(font, "dt", vec2_t(4, 501 + ay), color_t(221, 221, 221, 255)) end
        if isDT:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(1, 18), colorpicker:get()) end
        ay = ay + 20
    end
    if isHS:get( ) then
        if isHS:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(20, 18), color_t(20,20,20,85)) end
        if isHS:get() then render.text(font, "hs", vec2_t(4, 501 + ay), color_t(221, 221, 221, 255)) end
        if isHS:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(1, 18), colorpicker:get()) end
        ay = ay + 20
    end
    if PING:get( ) then
        if PING:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(33, 18), color_t(20,20,20,85)) end
        if PING:get() then render.text(font, "ping", vec2_t(4, 501 + ay), color_t(221, 221, 221, 255)) end
        if PING:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(1, 18), colorpicker:get()) end
        ay = ay + 20
    end
    if isFS:get( ) then
        if isFS:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(20, 18), color_t(20,20,20,85)) end
        if isFS:get() then render.text(font, "fs", vec2_t(5, 501 + ay), color_t(221, 221, 221, 255)) end
        if isFS:get() then render.rect_filled(vec2_t(0, 500 + ay), vec2_t(1, 18), colorpicker:get()) end
        ay = ay + 20
    end
    if AutoO:get() or ScoutO:get() or DeagleO:get() or RevolverO:get() or PistolO:get() or AwpO:get() then 
        render.rect_filled(vec2_t(0, 500 + ay), vec2_t(31, 18), color_t(20,20,20,85)) 
        render.text(font, "dmg", vec2_t(4, 501 + ay), color_t(221, 221, 221, 255)) 
        render.rect_filled(vec2_t(0, 500 + ay), vec2_t(1, 18), colorpicker:get())

    end
end
    callbacks.add(e_callbacks.PAINT, function()
        if checkbox:get() then
            indicators()
        end
    end)