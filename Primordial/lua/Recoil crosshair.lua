local screen_size = render.get_screen_size()

-- made by amandaf - give credit if you use code

local crosshair = function(localplayer)

	local iFov = 90 + menu.find("visuals", "other", "general", "render fov add"):get() -- fov calc
	local iFovX = screen_size.x / iFov
	local iFovY = screen_size.y / iFov

    local fl_view_recoil_tracking = cvars.view_recoil_tracking
    local fl_weapon_recoil_scale = cvars.weapon_recoil_scale

    local vecAimPunchAngles = localplayer:get_prop("m_aimPunchAngle")
	
    local vecCrosshairPosition = vec2_t((screen_size.x/2) - (iFovX * ((vecAimPunchAngles.y * fl_weapon_recoil_scale:get_float()) * fl_view_recoil_tracking:get_float())),
    (screen_size.y/2) + (iFovY * ((vecAimPunchAngles.x * fl_weapon_recoil_scale:get_float()) * fl_view_recoil_tracking:get_float())))

    if vecCrosshairPosition ~= vec2_t(screen_size.x/2,screen_size.y/2) then  -- remove this if statement to always render the crosshair
        render.line(vecCrosshairPosition, vec2_t(vecCrosshairPosition.x, vecCrosshairPosition.y+4), color_t(255,255,255))
        render.line(vecCrosshairPosition, vec2_t(vecCrosshairPosition.x, vecCrosshairPosition.y-4), color_t(255,255,255))
        render.line(vecCrosshairPosition, vec2_t(vecCrosshairPosition.x+4, vecCrosshairPosition.y), color_t(255,255,255))
        render.line(vecCrosshairPosition, vec2_t(vecCrosshairPosition.x-4, vecCrosshairPosition.y), color_t(255,255,255))
    end
end

callbacks.add(e_callbacks.PAINT, function()

    local localplayer = entity_list.get_local_player()

    if engine.is_in_game() and localplayer:is_alive() then
        crosshair(localplayer)
    end
    
end)