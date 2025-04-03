local client_visible, entity_hitbox_position, math_abs, math_atan, table_remove = client.visible, entity.hitbox_position, math.abs, math.atan, table.remove
local ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_log, client_color_log, client_set_event_callback = client.log, client.color_log, client.set_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local bit_band, bit_bend = bit.band, validate
local client_screen_size, renderer_text = client.screen_size, renderer.text

local unsafe_key = ui_new_hotkey("RAGE", "Other", "sigma_\aff5252ffdangerous\ad9d9d9ff_key")
local ref_ps = ui_reference("RAGE", "Aimbot", "Prefer safe point")
local ref_ms = ui_reference("RAGE", "Aimbot", "Multi-point scale")
local ref_mp, ref_mpkey, ref_mp_mode = ui_reference("RAGE", "Aimbot", "Multi-point")
local ref_us = ui_reference("RAGE", "Aimbot", "Avoid unsafe hitboxes")
local ref_ds = ui_reference("RAGE", "Other", "Delay shot")
local us_md = ui.reference("RAGE", "Aimbot", "Minimum damage")
local us_pbaim = ui_reference("RAGE", "Other", "Prefer body aim")
local us_thbx = ui_reference("RAGE", "Aimbot", "Target hitbox")
local sx, sy = client_screen_size()
local cx, cy = sx / 2, sy / 2
local function runus()
	if ui_get(unsafe_key) then
        ui_set(ref_ps, false)
        ui_set(ref_ms, 100)
        ui_set(ref_mp, {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"})
		ui_set(ref_us, {})
		ui_set(ref_ds, false)
		--ui_set(us_md, 1)
		ui_set(us_pbaim, false)
		ui_set(us_thbx, {"Head", "Chest", "Stomach", "Arms", "Legs", "Feet"})
    end
	if ui_get(unsafe_key) then
        renderer_text(cx, cy+11, 255, 0, 0, 255, "c-", 0, "+°VERY UNSAFE/DANGEROUS°+")
    end
end
client_set_event_callback("paint", runus)