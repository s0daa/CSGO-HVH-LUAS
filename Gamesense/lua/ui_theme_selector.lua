-- Localize often used API variables
local ui_reference, ui_set_visible, ui_new_button, color_log = ui.reference, ui.set_visible, ui.new_button, client.color_log

-- Localize a reference to the menu dropdown
local theme_ref = ui_reference("MISC", "Settings", "Menu theme")


local function ui_visibility_wrapped(visible)

    -- https://gamesense.vip/forums/lua.php#ui-set_visible

    if (visible) then
        ui_set_visible(theme_ref, true)
        color_log(238, 238, 238, "UI theme selector set to: Visible")
    else
        ui_set_visible(theme_ref, false)
        color_log(238, 238, 238, "UI theme selector set to: Hidden")
    end
    
end

ui_new_button("LUA", "A", "Enable UI theme selector", ui_visibility_wrapped(true))
ui_new_button("LUA", "A", "Disable UI theme selector", ui_visibility_wrapped(false))