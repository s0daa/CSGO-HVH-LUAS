local ref_mindmg =  ui.reference( "rage" , "aimbot" , "Minimum damage" ) 
local ovr_checkbox , ovr_hotkey , ovr_value =  ui.reference( "rage" , "aimbot" , "Minimum damage override" ) 
local dmg_ind = ui.new_checkbox("Rage", "Other", "DMG IND")
local color = ui.new_color_picker("Rage", "Other", "Color picka", 255, 255, 255, 255)
local client_screen_size = client.screen_size
local renderer_text = renderer.text

client.set_event_callback('paint', function()
    if not ui.get(dmg_ind) then return end 
    local w, h = client_screen_size()
    local center_x, center_y = w / 2, h / 2
    local red, green, blue, alpha = ui.get(color)

    if ui.get(ovr_checkbox) and ui.get(ovr_hotkey)  then
        renderer_text(center_x + 12, center_y - 7, red, green, blue, alpha, "c", 0, ui.get(ovr_value))
    else
        renderer_text(center_x + 12, center_y - 7, red, green, blue, alpha, "c", 0, ui.get(ref_mindmg))
    end
end)
