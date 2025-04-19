local old_doubletap_reference = {ui.reference("RAGE", "Aimbot", "Double tap")}

ui.set_visible(old_doubletap_reference[1], false)
ui.set_visible(old_doubletap_reference[2], false)

local binds = {
    first = ui.new_hotkey("RAGE", "Other", "Double tap", false),
    second = ui.new_hotkey("RAGE", "Other", "DDoS", false)
}

local update_doubletap_state = function()
    if ui.get(binds.first) or ui.get(binds.second) then
        ui.set(old_doubletap_reference[1], true)
        ui.set(old_doubletap_reference[2], "Always on")
    else
        ui.set(old_doubletap_reference[1], false)
        ui.set(old_doubletap_reference[2], "Off hotkey")
    end
end

client.set_event_callback("run_command", update_doubletap_state)