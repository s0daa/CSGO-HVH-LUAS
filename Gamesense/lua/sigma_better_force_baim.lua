
-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_visible, entity_hitbox_position, math_ceil, math_pow, math_sqrt, renderer_indicator, unpack, tostring, pairs = client.visible, entity.hitbox_position, math.ceil, math.pow, math.sqrt, renderer.indicator, unpack, tostring, pairs
local ui_new_label, ui_reference, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_set, ui_get, ui_set_callback, ui_set_visible = ui.new_label, ui.reference, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.set, ui.get, ui.set_callback, ui.set_visible
local client_log, client_color_log, client_set_event_callback, client_unset_event_callback = client.log, client.color_log, client.set_event_callback, client.unset_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop, entity_get_players, entity_is_alive = entity.get_local_player, entity.get_player_weapon, entity.get_prop, entity.get_players, entity.is_alive
local bit_band = bit.band
local client_screen_size, renderer_text = client.screen_size, renderer.text

local hitbox = ui.reference("RAGE", "Aimbot", "Target hitbox")
local mp, mpkey, mpmode = ui_reference("RAGE", "Aimbot", "Multi-point")
local sigma_modified_force_bodyaim = ui.new_hotkey("RAGE", "Other", "sigma_modified_force_bodyaim")
local forcebodyaim = ui.reference("RAGE", "Other", "Force body aim")
local function runbetterbaim()
	if ui.get(sigma_modified_force_bodyaim) then
		ui.set(mpkey, "On hotkey")
		ui.set(forcebodyaim, "Always on")
	else
		ui.set(mpkey, "Always on")
		ui.set(forcebodyaim, "On hotkey")
	end
end
client.set_event_callback("setup_command", runbetterbaim)
