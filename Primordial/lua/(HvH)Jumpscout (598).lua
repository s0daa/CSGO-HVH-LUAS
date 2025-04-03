local luamenu = {}
luamenu.toggle = menu.add_checkbox("override hitchance in air (scout)", "toggle")
luamenu.hitchanceslider = menu.add_slider("override hitchance in air (scout)","hitchance value in air",0, 100 )

local primordial = {}
primordial.scouthitchance= menu.find("aimbot", "scout", "targeting", "hitchance")

local hitchance_saved = primordial.scouthitchance:get()



local function handle_visibility()

    luamenu.hitchanceslider:set_visible(luamenu.toggle:get() == true)

end

local function handle_hitchance_air()

    if not engine.is_connected() or not engine.is_in_game() then
        return
    else

    local localplayer   = entity_list.get_local_player()
    local isAir = localplayer:get_prop("m_vecVelocity[2]") ~= 0

        if isAir == false then
            primordial.scouthitchance:set(hitchance_saved)

        else
            primordial.scouthitchance:set(luamenu.hitchanceslider:get())
        end

    end
end


local function on_paint()

    handle_visibility()

    if luamenu.toggle:get() == true then
        handle_hitchance_air()
    end

end

local function on_shutdown()
    primordial.scouthitchance:set(hitchance_saved)
end

callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)