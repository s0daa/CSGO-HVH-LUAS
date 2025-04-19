local mmdmg_ui = {
    enable = ui.new_checkbox("RAGE", "Aimbot", "Multi Minimum Damage"),
    count = ui.new_combobox("RAGE", "Aimbot", "Value Multi Minimum Damage", {"0", "1", "2", "3", "4", "5"}),
    checkbox = {},
    active = {},
    damage = {},
    orig_damage = ui.new_slider("RAGE", "Aimbot", "Original Minimum Damage", 1, 126, 1)
}

for i = 1, 5 do
    mmdmg_ui.checkbox[i] = ui.new_checkbox("RAGE", "Aimbot", "Enable Multi Minimum Damage " .. i)
    mmdmg_ui.active[i] = ui.new_hotkey("RAGE", "Aimbot", "Hotkey " .. i, true)
    mmdmg_ui.damage[i] = ui.new_slider("RAGE", "Aimbot", "Multi Minimum Damage " .. i, 1, 126, 1)
end

local orig_mindmg = ui.reference("RAGE", "Aimbot", "Minimum damage")

ui.set(mmdmg_ui.orig_damage, ui.get(orig_mindmg))

local function handle_damage_override()
    if not ui.get(mmdmg_ui.enable) then
        return
    end

    local count = tonumber(ui.get(mmdmg_ui.count))
    local found_active = false
    
    for i = 1, count do
        if ui.get(mmdmg_ui.checkbox[i]) then
            if ui.get(mmdmg_ui.active[i]) then
                ui.set(orig_mindmg, ui.get(mmdmg_ui.damage[i]))
                found_active = true
                break
            end
        end
    end

    if not found_active then
        ui.set(orig_mindmg, ui.get(mmdmg_ui.orig_damage))
    end
end

local function on_paint()
    local enabled = ui.get(mmdmg_ui.enable)
    local count = tonumber(ui.get(mmdmg_ui.count))

    if not ui.get(mmdmg_ui.enable) then
        ui.set(mmdmg_ui.orig_damage, ui.get(orig_mindmg))
    end
    
    ui.set_visible(mmdmg_ui.count, enabled)
    ui.set_visible(mmdmg_ui.orig_damage, enabled)
    
    for i = 1, 5 do
        local show_group = enabled and i <= count
        local show_sliders = show_group and ui.get(mmdmg_ui.checkbox[i])
        
        ui.set_visible(mmdmg_ui.checkbox[i], show_group)
        ui.set_visible(mmdmg_ui.active[i], show_group)
        ui.set_visible(mmdmg_ui.damage[i], show_sliders)
    end

    handle_damage_override()
end

client.set_event_callback("paint", on_paint)