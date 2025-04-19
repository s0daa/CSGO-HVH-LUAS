slot0 = "A"
slot1, slot2 = client.screen_size()
slot6 = ui.new_color_picker("LUA", slot0, "Cinematic black bars color", 0, 0, 0, 255)
slot7 = ui.new_slider("LUA", slot0, "\n Cinematic black bars height", 1, slot2 / 2, math.floor(0.23809523809523808 * slot2 / 2 + 0.5), true, "px")

ui.set(ui.new_hotkey("LUA", slot0, "Cinematic black bars hotkey", true), "Always on")

slot8 = nil
slot9 = 0

function slot10()
	uv0 = tonumber(cvar.safezoney:get_string())

	cvar.safezoney:set_raw_float(uv0)
	ui.set_visible(uv1, ui.get(uv2))
	ui.set_visible(uv3, ui.get(uv2))
end

slot10()
ui.set_callback(ui.new_checkbox("LUA", slot0, "Cinematic black bars"), slot10)
client.set_event_callback("shutdown", slot10)
client.set_event_callback("paint_ui", function ()
	uv2 = math.max(0, math.min(1, uv2 + 0.02 * (ui.get(uv0) and ui.get(uv1) and 1 or -1)))
	slot1 = (math.sin(uv2 * math.pi - math.pi / 2) + 1) / 2
	slot2 = ui.get(uv3)
	slot3 = {
		ui.get(uv4)
	}

	renderer.rectangle(0, 0, uv5, slot2 * slot1, slot3[1], slot3[2], slot3[3], slot3[4])
	renderer.rectangle(0, uv6, uv5, slot2 * slot1 * -1, slot3[1], slot3[2], slot3[3], slot3[4])
	cvar.safezoney:set_raw_float((uv6 - slot2 * slot1 * 2) / uv6 * uv7)
end)
