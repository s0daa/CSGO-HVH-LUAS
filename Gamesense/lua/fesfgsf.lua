local master_switch = ui.new_checkbox("VISUALS", "Other ESP", "Minimum Damage Override Indicator")

local references = {
    minimum_damage = ui.reference("RAGE", "Aimbot", "Minimum damage"),
    minimum_damage_override = { ui.reference("RAGE", "Aimbot", "Minimum damage override") }
}

local screen_size = { client.screen_size() }

local paint = function(ctx)
    local localplayer = entity.get_local_player()
    if localplayer == nil or not entity.is_alive(localplayer) then return end

    if ui.get(references.minimum_damage_override[2]) then
        renderer.text(screen_size[1] / 2 + 2, screen_size[2] / 2 - 25, 137, 161, 255, 225, "d", 0, ui.get(references.minimum_damage_override[3]) .. "")
    end
end

local ui_callback = function(self)
    local enabled = ui.get(self)
    local updatecallback = enabled and client.set_event_callback or client.unset_event_callback

    updatecallback("paint", paint)
end

ui.set_callback(master_switch, ui_callback)
ui_callback(master_switch)