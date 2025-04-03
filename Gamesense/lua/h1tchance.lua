local bit = require'bit'

local feature = {
	def_hc = ui.new_slider('rage', 'aimbot', 'Default hit chance', 0, 100, 50, true, '%'),
	hc_in_air = ui.new_checkbox('rage', 'aimbot', 'Hit chance in air'),
	hit_chance_in_air = ui.new_slider('rage', 'aimbot', '\ninairhc', 0, 100, 50, true, '%'),
	hit_chance_ovr = ui.new_slider('rage', 'aimbot', 'Hit chance override', 0, 100, 50, true, '%'),
	hc_ovr_key = ui.new_hotkey('rage', 'other', 'Hit chance override', false)
}

local hc_ref = ui.reference('rage', 'aimbot', 'minimum hit chance')
ui.set_visible(hc_ref, false)

local w, h = client.screen_size()

client.set_event_callback('setup_command', function()
	local lp = entity.get_local_player(); if lp == nil or (not entity.is_alive(lp)) then return end
	local flags = entity.get_prop(lp, 'm_fFlags')
	local in_air = bit.band(flags, 1) ~= 1

	
	ui.set(hc_ref, ui.get(feature.def_hc))
	if in_air and ui.get(feature.hc_in_air) then
		ui.set(hc_ref, ui.get(feature.hit_chance_in_air))
	end
if ui.get(feature.hc_ovr_key) then
		ui.set(hc_ref, ui.get(feature.hit_chance_ovr))
	end

	
end)

client.set_event_callback('paint', function()
	if ui.get(feature.hc_ovr_key) then
		renderer.indicator(255, 255, 255, 255, "HITCHANCE OVR")
	end
end)

client.set_event_callback('shutdown', function()
	ui.set_visible(hc_ref, true)
end)

local ui_vis = function(self)
	ui.set_visible(feature.hit_chance_in_air, ui.get(self))
end
ui.set_callback(feature.hc_in_air, ui_vis); ui_vis(feature.hc_in_air)