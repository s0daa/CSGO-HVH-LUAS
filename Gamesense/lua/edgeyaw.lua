local check = ui.new_checkbox("AA", "Anti-aimbot angles", "Edge yaw on hotkey")
local hotkey = ui.new_hotkey("AA", "Anti-aimbot angles", "Edge yaw on hotkey", true)
local edge = ui.reference("AA", "Anti-aimbot angles", "Edge yaw")

local state = false
local function on_paint()
	state = ui.get(hotkey)
	if state then
		renderer.indicator(207, 206, 204, 255, "EDGE")
	end
end

local last_state = false
local function on_setup_command(c)
	if state ~= last_state then
		ui.set(edge, state)
		last_state = state
	end
end

ui.set_callback(check, function(c)
	if ui.get(c) then
		client.set_event_callback("paint", on_paint)
		client.set_event_callback("setup_command", on_setup_command)
	else
		client.unset_event_callback("paint", on_paint)
		client.unset_event_callback("setup_command", on_setup_command)
	end
end)