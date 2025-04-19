client_draw_text, client_draw_indicator, client_set_event_callback, client_screen_size, ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_is_menu_open, ui_new_color_picker, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = client.draw_text, client.draw_indicator, client.set_event_callback, client.screen_size, ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.is_menu_open, ui.new_color_picker, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get

--menu shit
override = ui.new_checkbox("RAGE", "Other", "Resolver override")
override_color = ui.new_color_picker("RAGE", "Other", "\n flag")
override_key = ui.new_hotkey("RAGE", "Other", "Override key")
override_indicator = ui.new_combobox("RAGE", "Other", "Indicator type", "-", "Default", "Crosshair")

local function update_menu(visible)
	if ui.get(override, true) then
		ui.set_visible(override_color, true)
		ui.set_visible(override_key, true)
		ui.set_visible(override_indicator, true)
	else
		ui.set_visible(override_color, false)
		ui.set_visible(override_key, false)
		ui.set_visible(override_indicator, false)
	end
end
client.set_event_callback("paint", update_menu)

--references men
selectedplayer = ui.reference("PLAYERS", "Players", "Player list")
forcebody = ui.reference("PLAYERS", "Adjustments", "Force body yaw")
resetlist = ui.reference("PLAYERS", "Players", "Reset all")
correction_active = ui.reference("PLAYERS", "Adjustments", "Correction active")
applyall = ui.reference("players", "adjustments", "Apply to all")
body_slider = ui.reference("PLAYERS", "Adjustments", "Force body yaw value")

--override key

function setbodyyaw()
	if ui.get(override, true) then
	else
		return
	end
	if ui.get(body_slider) == 0 and canManual == true then
		ui.set(forcebody, true)
		ui.set(body_slider, 17)
		ui.set(applyall, true)
		canManual = false
	end
    if ui.get(body_slider) == 17 and canManual == true then
		ui.set(forcebody, false)
		ui.set(body_slider, 0)
		ui.set(applyall, true)
		canManual = false
    end
end

function on_paint()
	if ui.get(override, true) then
	else
		return
	end
	if ui.get(override_key) then
		if canManual == true then
			setbodyyaw()
			canManual = false
		end
	else
		canManual = true
	end
end
client.set_event_callback("paint", on_paint)

--overide flag

local r, g, b = ui.get(override_color) --this doesn't work cus flags are really weird so I'm just setting a static color instead, if anyone knows how to make this work then please let me know

client.register_esp_flag("low delta", 0, 255, 0, function(c)
	if ui.get(body_slider) == 17 then return true end
end)

--override indicators

client.set_event_callback("paint", function()

	local r, g, b, a = ui.get(override_color)
	local w, h = client_screen_size()
	local center = { w/2, h/2 }
	local y = (center[2])
	
	if ui.get(override, true) and ui.get(override_indicator) == "Default" then
		if ui.get(body_slider) == 17 then
			renderer.indicator(r, g, b, a, " (Δ)correction ")
		elseif ui.get(forcebody) == false then
			renderer.indicator(r, g, b, a, "def skeet")
		end
	end
	if ui.get(override, true) and ui.get(override_indicator) == "Crosshair" then
		if ui.get(body_slider) == 17 then
			renderer.text(center[1] + 7, y + 25, r, g, b, a, "c", 0, " correction(17Δ) ")
		elseif ui.get(forcebody) == false then
			renderer.text(center[1], y + 25, 255, 255, 255, a, "c", 0, "default(skeet)")
		end
	end
end)

--reset override on round start
client.set_event_callback("round_start", function()
	ui.set(body_slider, 0)
	ui.set(forcebody, false)
	ui.set(applyall, true)
end)