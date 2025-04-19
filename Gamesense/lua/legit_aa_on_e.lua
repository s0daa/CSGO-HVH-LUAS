local legit_aa_on_key = ui.new_hotkey("AA", "Anti-aimbot angles", "Legit anti-aim (on key)")
local freestanding_body_yaw = ui.reference("AA", "Anti-aimbot angles", "Freestanding body yaw")
local body_yaw, body_yaw_slider = ui.reference ('aa', 'anti-aimbot angles', 'body yaw')
local fake_yaw_limit = ui.reference('aa', 'anti-aimbot angles', 'fake yaw limit')
local pitch = ui.reference ("AA", "Anti-aimbot angles", "yaw")


client.set_event_callback("setup_command",function(e)
    local weaponn = entity.get_player_weapon()
    if ui.get(legit_aa_on_key) then
        if weaponn ~= nil and entity.get_classname(weaponn) == "CC4" then return end

        if e.in_attack == 1 then 
            e.in_use = 0
        end

        if e.chokedcommands == 0 then
            e.in_use = 0
        end
        ui.set(pitch, "Off")
        ui.set(body_yaw, "opposite")
        ui.set(freestanding_body_yaw, true)
        ui.set(fake_yaw_limit, 60)
    elseif not ui.get(legit_aa_on_key) then
    	ui.set(pitch, "180")
        ui.set(body_yaw, "Jitter")
        ui.set(fake_yaw_limit, 45)
    end
end)