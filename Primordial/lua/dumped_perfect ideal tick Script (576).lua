local ui = {
    color = menu.add_text("SFAES -> IDEAL TICK", "color"):add_color_picker("color"),
}

local setup = {
    default_color = ui.color:set(color_t(188,238,252,200)),
}

local renderer = {
    font = render.create_font("Smallest Pixel-7", 11, 300, e_font_flags.DROPSHADOW, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE),
    screen_size = render.get_screen_size(),
}

local ref = {
    double_tap = menu.find("aimbot", "general", "exploits", "doubletap", "enable")[2],
    auto_peek = menu.find("aimbot", "general", "misc", "autopeek")[2]
}

callbacks.add(e_callbacks.PAINT, function()
    if not engine.is_connected() or not engine.is_in_game() then return end

    local localplayer = entity_list.get_local_player() 
    if not localplayer:is_alive() or not ref.double_tap:get() or not ref.auto_peek:get() then return end

    local idealtick_charge = math.floor(exploits.get_charge() / exploits.get_max_charge() * 100)

    local text = "+/- CHARGED IDEAL TICK {"..idealtick_charge.."%}"

    local text_size = render.get_text_size(renderer.font, text)
    render.text(renderer.font, text, vec2_t(renderer.screen_size.x/2-text_size.x*0.5, renderer.screen_size.y/2-text_size.y*3), ui.color:get()) 
end)

callbacks.add(e_callbacks.EVENT, function(event)
    if event.name == "weapon_fire" then 
        if engine.get_player_index_from_user_id(event.userid) == engine.get_local_player_index() and ref.double_tap:get() and ref.auto_peek:get() then 
            exploits.force_uncharge()
            exploits.force_recharge()

            client.log("ideal tick -> teleported successfully")
        end
    end
end)