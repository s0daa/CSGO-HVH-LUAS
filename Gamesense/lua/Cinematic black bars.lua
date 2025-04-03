local var_0_0 = "A"
local var_0_1, var_0_2 = client.screen_size()
local var_0_3 = math.floor(0.23809523809523808 * var_0_2 / 2 + 0.5)
local var_0_4 = ui.new_checkbox("LUA", var_0_0, "Cinematic black bars")
local var_0_5 = ui.new_hotkey("LUA", var_0_0, "Cinematic black bars hotkey", true)
local var_0_6 = ui.new_color_picker("LUA", var_0_0, "Cinematic black bars color", 0, 0, 0, 255)
local var_0_7 = ui.new_slider("LUA", var_0_0, "\n Cinematic black bars height", 1, var_0_2 / 2, var_0_3, true, "px")

ui.set(var_0_5, "Always on")

local var_0_8
local var_0_9 = 0

local function var_0_10()
	var_0_8 = tonumber(cvar.safezoney:get_string())

	cvar.safezoney:set_raw_float(var_0_8)
	ui.set_visible(var_0_6, ui.get(var_0_4))
	ui.set_visible(var_0_7, ui.get(var_0_4))
end

var_0_10()
ui.set_callback(var_0_4, var_0_10)
client.set_event_callback("shutdown", var_0_10)
client.set_event_callback("paint_ui", function()
	local var_2_0 = ui.get(var_0_4) and ui.get(var_0_5)

	var_0_9 = math.max(0, math.min(1, var_0_9 + 0.02 * (var_2_0 and 1 or -1)))

	local var_2_1 = (math.sin(var_0_9 * math.pi - math.pi / 2) + 1) / 2
	local var_2_2 = ui.get(var_0_7)
	local var_2_3 = {
		ui.get(var_0_6)
	}

	renderer.rectangle(0, 0, var_0_1, var_2_2 * var_2_1, var_2_3[1], var_2_3[2], var_2_3[3], var_2_3[4])
	renderer.rectangle(0, var_0_2, var_0_1, var_2_2 * var_2_1 * -1, var_2_3[1], var_2_3[2], var_2_3[3], var_2_3[4])

	local var_2_4 = (var_0_2 - var_2_2 * var_2_1 * 2) / var_0_2 * var_0_8

	cvar.safezoney:set_raw_float(var_2_4)
end)
