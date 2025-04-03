local advancedHudMode = menu.add_selection("Advanced HUD", "Advanced HUD", {"OFF", "Health Based", "Looping", "Custom"})
local loopingDelay = menu.add_slider("Advanced HUD", "Looping Delay", 0, 3000, 1.0, 0, "ms")
local custom_hud = menu.add_slider("Advanced HUD", "Custom HUD", 0, 10, 1.0, 0, " style")
local currentHudColor = 0
local nextLoop = 0
loopingDelay:set(1000)

callbacks.add(e_callbacks.PAINT, function()
    loopingDelay:set_visible(advancedHudMode:get() == 3)
    custom_hud:set_visible(advancedHudMode:get() == 4)
    local local_player = entity_list.get_local_player()
    local health = local_player:get_prop("m_iHealth")
    if(advancedHudMode:get() == 2) then
        cvars.cl_hud_color:set_int(health > 95 and 8 or health > 70 and 7 or health > 40 and 6 or 5)
    elseif (advancedHudMode:get() == 3) then
        if(nextLoop < global_vars.real_time()) then
            currentHudColor = currentHudColor + 1
            cvars.cl_hud_color:set_int(currentHudColor)
            if(currentHudColor >= 10) then
                currentHudColor = 0
            end
            nextLoop = global_vars.real_time() + loopingDelay:get() / 1000
        end
    elseif (advancedHudMode:get() == 4) then
        cvars.cl_hud_color:set_int(custom_hud:get())
    else
        cvars.cl_hud_color:set_int(0)
    end
end)