local var_0_0 = require("ffi")
local var_0_1 = panorama.open()
local var_0_2 = {
	data = {
		write = database.write,
		read = database.read
	},
	render = {
		rectangle = renderer.rectangle,
		gradient = renderer.gradient,
		text = renderer.text,
		measure = renderer.measure_text,
		load_rgba = renderer.load_rgba,
		texture = renderer.texture
	}
}
local var_0_3 = "\x14\x14\x14\xFF"
local var_0_4 = "\x00\x00\x00\x00"
local var_0_5 = table.concat({
	var_0_3,
	var_0_3,
	var_0_4,
	var_0_3,
	var_0_4,
	var_0_3,
	var_0_4,
	var_0_3,
	var_0_4,
	var_0_3,
	var_0_3,
	var_0_3,
	var_0_4,
	var_0_3,
	var_0_4,
	var_0_3
})
local var_0_6 = var_0_2.render.load_rgba(var_0_5, 4, 4)
local var_0_7 = var_0_0.typeof("int[1]")
local var_0_8 = vtable_bind("vguimatsurface.dll", "VGUI_Surface031", 100, "unsigned int(__thiscall*)(void*, int*, int*)")
local var_0_9 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
local var_0_10 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "void(__thiscall*)(void*, int, const char*, int)")
local var_0_11 = var_0_1.SteamOverlayAPI
local var_0_12, var_0_13 = client.screen_size()
local var_0_14 = {
	color = ui.reference("misc", "settings", "menu color"),
	layout = ui.reference("misc", "settings", "lock menu layout"),
	dpi = ui.reference("misc", "settings", "dpi scale")
}
local var_0_15 = {
	logs = var_0_2.data.read("custom_console/logs") or {},
	param = var_0_2.data.read("custom_console/parameters") or {
		h = 100,
		w = 250,
		x = var_0_12 / 2 - 125,
		y = var_0_13 / 2 - 50
	}
}
local var_0_16 = {
	fade = 1,
	open_send = false,
	dpi = 1,
	open = true,
	gs_color = {
		g = 220,
		r = 187,
		a = 255,
		b = 13
	},
	mouse = {
		y = 0,
		x = 0,
		x_ = 0,
		y_ = 0
	},
	drag = {},
	scroll = {
		drag_y = 0,
		drag = false,
		y_ = 0,
		x = var_0_15.param.x + var_0_15.param.w,
		y = var_0_15.param.y,
		h = var_0_15.param.h
	},
	clr = {
		g = 0,
		r = 0,
		a = 255,
		b = 0
	},
	pre = {
		"game",
		"sense"
	},
	hovered = {
		scroll = false,
		corner = false,
		send = false,
		message = -1,
		window = false
	}
}

var_0_16.gs_color.r, var_0_16.gs_color.g, var_0_16.gs_color.b, var_0_16.gs_color.a = ui.get(var_0_14.color)
var_0_16.clr = var_0_16.gs_color

local var_0_17 = {
	show = ui.new_checkbox("lua", "b", "• Custom console settings"),
	hotkey = ui.new_hotkey("lua", "b", "console_hotkey", true, 45),
	style = ui.new_combobox("lua", "b", "\n", "Gamesense", "Pasted"),
	open_menu = ui.new_checkbox("lua", "b", "• Open with ui"),
	render_line = ui.new_checkbox("lua", "b", "• Render line"),
	clr_override = ui.new_checkbox("lua", "b", "• Override color"),
	clr = ui.new_color_picker("lua", "b", "clr_ovr", var_0_16.gs_color.r, var_0_16.gs_color.g, var_0_16.gs_color.b, var_0_16.gs_color.a),
	dont_copy = ui.new_checkbox("lua", "b", "• Ignore prefix"),
	render_rounds = ui.new_multiselect("lua", "b", "• Indicate rounds", "Render", "Print on round start"),
	clear_logs = ui.new_checkbox("lua", "b", "• Clear logs on shutdown"),
	_ = ui.new_label("lua", "b", "• Prefix"),
	prefix = ui.new_textbox("lua", "b", "cnsl_prefix"),
	__ = ui.new_label("lua", "b", "• Prefix (color)"),
	prefix_clr = ui.new_textbox("lua", "b", "cnsl_clr_prefix")
}

if var_0_2.data.read("custom_console/clear") then
	ui.set(var_0_17.clear_logs, var_0_2.data.read("custom_console/clear"))
end

if var_0_2.data.read("console/save/enabled") or var_0_2.data.read("console/pos/x") then
	var_0_2.data.write("console/save/enabled", nil)
	var_0_2.data.write("console/save/always", nil)
	var_0_2.data.write("console/save/prefix", nil)
	var_0_2.data.write("console/prefix_c", nil)
	var_0_2.data.write("console/save/dont_copy", nil)
	var_0_2.data.write("console/save/clr_c", nil)
	var_0_2.data.write("console/save/print_rounds", nil)
	var_0_2.data.write("console/save/clr_r", nil)
	var_0_2.data.write("console/save/clr_g", nil)
	var_0_2.data.write("console/save/clr_b", nil)
	var_0_2.data.write("console/save/clr_a", nil)
	var_0_2.data.write("console/width", nil)
	var_0_2.data.write("console/height", nil)
	var_0_2.data.write("console/prev_logs__", logs)
	var_0_2.data.write("console/pos/x", nil)
	var_0_2.data.write("console/pos/y", nil)
	print("Cleared old data and applied some to the new database [console]")
end

if var_0_2.data.read("custom_console/") then
	var_0_2.data.write("custom_console/pos", nil)
	var_0_2.data.read("custom_console/size", nil)
	var_0_2.data.read("custom_console/", nil)
	var_0_2.data.read("custom_console/data", nil)
end

local var_0_18 = {}
local var_0_19 = {}

function var_0_18.draw_ui(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = {
		10,
		60,
		40,
		40,
		40,
		60,
		10
	}

	for iter_1_0 = 0, 6 do
		var_0_2.render.rectangle(arg_1_0 + iter_1_0, arg_1_1 + iter_1_0, arg_1_2 - iter_1_0 * 2, arg_1_3 - iter_1_0 * 2, var_1_0[iter_1_0 + 1], var_1_0[iter_1_0 + 1], var_1_0[iter_1_0 + 1], 255 * arg_1_4)
	end

	var_0_2.render.texture(var_0_6, arg_1_0 + 6, arg_1_1 + 6, arg_1_2 - 12, arg_1_3 - 12, 255, 255, 255, 255 * arg_1_4, "r")

	if ui.get(var_0_17.render_line) then
		var_0_2.render.gradient(arg_1_0 + 7, arg_1_1 + 7, arg_1_2 / 2, 2, 5, 221, 255, 255 * arg_1_4, 186, 12, 230, 255 * arg_1_4, true)
		var_0_2.render.gradient(arg_1_0 + 7 + arg_1_2 / 2, arg_1_1 + 7, arg_1_2 / 2 - 14, 2, 186, 12, 230, 255 * arg_1_4, 219, 226, 60, 255 * arg_1_4, true)
		var_0_2.render.rectangle(arg_1_0 + 7, arg_1_1 + 8, arg_1_2 - 14, 1, 0, 0, 0, 190 * arg_1_4)
	end
end

function var_0_18.draw_container(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = {
		10,
		45,
		25
	}
	local var_2_1 = var_0_2.render.measure("db", arg_2_5)

	if arg_2_6 then
		var_2_1 = var_0_2.render.measure("db", arg_2_5 .. arg_2_6)
	end

	for iter_2_0 = 1, 3 do
		var_0_2.render.rectangle(arg_2_0 + iter_2_0, arg_2_1 + iter_2_0, arg_2_2 - iter_2_0 * 2, arg_2_3 - iter_2_0 * 2, var_2_0[iter_2_0], var_2_0[iter_2_0], var_2_0[iter_2_0], 255 * arg_2_4)
	end

	var_0_2.render.rectangle(arg_2_0 + 14, arg_2_1 + 1, var_2_1 + 4, 2, 30, 30, 30, 255 * arg_2_4)
end

function var_0_18.get_clipboard()
	local var_3_0 = var_0_9()

	if var_3_0 > 0 then
		local var_3_1 = var_0_0.new("char[?]", var_3_0)
		local var_3_2 = var_3_0 * var_0_0.sizeof("char[?]", var_3_0)

		var_0_10(0, var_3_1, var_3_2)

		return (var_0_0.string(var_3_1, var_3_0 - 1))
	end

	return nil
end

function var_0_18.get_mouse_positon()
	local var_4_0 = var_0_7()
	local var_4_1 = var_0_7()

	var_0_8(var_4_0, var_4_1)

	local var_4_2 = tonumber(var_4_0[0])
	local var_4_3 = tonumber(var_4_1[0])

	return var_4_2, var_4_3
end

function var_0_18.intersect(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return arg_5_1 <= arg_5_0[1] and arg_5_0[1] <= arg_5_1 + arg_5_3 and arg_5_2 <= arg_5_0[2] and arg_5_0[2] <= arg_5_2 + arg_5_4
end

function var_0_18.clamp(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0

	var_6_0 = var_6_0 < arg_6_1 and arg_6_1 or var_6_0
	var_6_0 = arg_6_2 < var_6_0 and arg_6_2 or var_6_0

	return var_6_0
end

function var_0_18.contains(arg_7_0, arg_7_1)
	for iter_7_0 = 1, #arg_7_0 do
		if arg_7_0[iter_7_0] == arg_7_1 then
			return true
		end
	end

	return false
end

function var_0_19.print(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, ...)
	local var_8_0 = arg_8_0 or "log"

	if type(var_8_0) ~= "string" or var_8_0 ~= "log" and var_8_0 ~= "message" and var_8_0 ~= "player" then
		client.error_log("Invalid argument[1] in api.print()")

		return
	end

	if type(arg_8_1) ~= "number" then
		client.error_log("Invalid argument[2] in api.print()")

		return
	end

	if type(arg_8_2) ~= "number" then
		client.error_log("Invalid argument[3] in api.print()")

		return
	end

	if type(arg_8_3) ~= "number" then
		client.error_log("Invalid argument[4] in api.print()")

		return
	end

	if type(arg_8_4) ~= "boolean" then
		client.error_log("Invalid argument[5] in api.print()")

		return
	end

	local var_8_1 = {
		...
	}
	local var_8_2 = entity.get_game_rules()
	local var_8_3

	if var_8_2 ~= nil then
		var_8_3 = entity.get_prop(var_8_2, "m_totalRoundsPlayed") + 1
	end

	if (entity.get_prop(var_8_2, "m_bWarmupPeriod") or 0) == 1 then
		var_8_3 = "W"
	end

	var_0_15.logs[#var_0_15.logs + 1] = {
		type = var_8_0,
		r = arg_8_1,
		g = arg_8_2,
		b = arg_8_3,
		round = var_8_3 or "nil",
		can_copy = arg_8_4,
		text = unpack(var_8_1)
	}

	var_0_2.data.write("custom_console/logs", var_0_15.logs)

	return #var_0_15.logs
end

function var_0_19.clear(arg_9_0)
	if type(arg_9_0) ~= "string" and type(arg_9_0) ~= "number" then
		client.error_log("Invalid argument in api.clear()")

		return
	end

	if type(arg_9_0) == "number" then
		if var_0_15.logs[arg_9_0] then
			var_0_15.logs[arg_9_0] = nil

			return
		end
	elseif type(arg_9_0) == "string" then
		for iter_9_0, iter_9_1 in pairs(var_0_15.logs) do
			if ({
				iter_9_1.text:find(arg_9_0)
			})[1] then
				var_0_15.logs[iter_9_0] = nil

				return
			end
		end
	end

	client.error_log("Couldn't find specified index (api.clear)")
end

function var_0_19.edit(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, ...)
	local var_10_0 = arg_10_1

	if type(arg_10_0) ~= "number" then
		client.error_log("Invalid argument[1] in api.edit()")

		return
	end

	if type(var_10_0) ~= "string" or var_10_0 ~= "log" and var_10_0 ~= "message" and var_10_0 ~= "player" then
		client.error_log("Invalid argument[2] in api.edit()")

		return
	end

	local var_10_1
	local var_10_2
	local var_10_3
	local var_10_4
	local var_10_5
	local var_10_6
	local var_10_7 = {
		...
	}

	for iter_10_0, iter_10_1 in pairs(var_0_15.logs) do
		if arg_10_0 == iter_10_0 then
			var_10_4 = var_10_0 or iter_10_1.type
			var_10_1, var_10_2, var_10_3 = arg_10_2 or iter_10_1.r, arg_10_3 or iter_10_1.g, arg_10_4 or iter_10_1.b
			var_10_5 = var_10_5 or iter_10_1.can_copy
			var_10_6 = unpack(var_10_7) or iter_10_1.text
		end
	end

	if var_0_15.logs[arg_10_0] then
		local var_10_8 = var_0_15.logs[arg_10_0]

		var_10_8.type, var_10_8.r, var_10_8.g, var_10_8.b, var_10_8.can_copy, var_10_8.text = var_10_4, var_10_1, var_10_2, var_10_3, var_10_5, var_10_6

		return
	end

	client.error_log("Couldn't find specified index (api.edit)")
end

function var_0_19.return_logs()
	local var_11_0 = {}

	for iter_11_0, iter_11_1 in pairs(var_0_15.logs) do
		var_11_0[#var_11_0] = iter_11_1
	end

	return var_11_0
end

function var_0_19.get_parameters()
	return var_0_15.param.x, var_0_15.param.y, var_0_15.param.w, var_0_15.param.h
end

function var_0_19.is_open()
	return var_0_16.open, var_0_16.fade
end

local var_0_20 = {
	{
		globals.realtime(),
		false,
		false,
		false
	},
	{
		globals.realtime(),
		false,
		false,
		false
	}
}

local function var_0_21()
	for iter_14_0, iter_14_1 in pairs(var_0_20) do
		iter_14_1[3] = client.key_state(iter_14_0)

		if iter_14_1[3] then
			if globals.realtime() > iter_14_1[1] then
				iter_14_1[2] = true
			else
				iter_14_1[2] = false
			end

			iter_14_1[1] = globals.realtime() + 0.05
		elseif globals.realtime() < iter_14_1[1] then
			iter_14_1[4] = true
		else
			iter_14_1[4] = false
		end
	end
end

client.set_event_callback("paint_ui", var_0_21)

local var_0_22 = {
	handle = function(arg_15_0)
		local var_15_0 = var_0_16
		local var_15_1 = var_15_0.gs_color
		local var_15_2 = var_15_0.mouse
		local var_15_3 = var_15_0.dpi
		local var_15_4 = var_15_0.drag
		local var_15_5 = var_15_0.scroll
		local var_15_6 = var_15_0.hovered
		local var_15_7 = ui.get(var_0_14.dpi):gsub("%%", "%")
		local var_15_8 = var_0_20[1][3]

		var_15_1.r, var_15_1.g, var_15_1.b, var_15_1.a = ui.get(var_0_14.color)
		var_15_0.clr = var_15_1

		if ui.get(var_0_17.clr_override) then
			var_15_0.clr.r, var_15_0.clr.g, var_15_0.clr.b, var_15_0.clr.a = ui.get(var_0_17.clr)
		end

		var_15_0.dpi = tonumber(var_15_7) / 100

		local var_15_9 = var_0_15.param.x
		local var_15_10 = var_0_15.param.y
		local var_15_11 = var_0_15.param.w * var_15_3
		local var_15_12 = var_0_15.param.h * var_15_3

		var_15_2.x, var_15_2.y = var_0_18.get_mouse_positon()
		var_15_6.window, var_15_6.corner, var_15_6.scroll = var_0_18.intersect({
			var_15_2.x,
			var_15_2.y
		}, var_15_9, var_15_10, var_15_11, var_15_12), var_0_18.intersect({
			var_15_2.x,
			var_15_2.y
		}, var_15_9 + var_15_11 - 10, var_15_10 + var_15_12 - 10, 10, 10), var_0_18.intersect({
			var_15_2.x,
			var_15_2.y
		}, var_15_5.x, var_15_5.y, 6, var_15_5.h)
		var_15_0.open = ui.get(var_0_17.hotkey) or ui.get(var_0_17.open_menu) and ui.is_menu_open()
		var_15_0.pre[1] = ui.get(var_0_17.prefix) == "" and "game" or ui.get(var_0_17.prefix)
		var_15_0.pre[2] = ui.get(var_0_17.prefix_clr) == "" and "sense" or ui.get(var_0_17.prefix_clr)

		if not var_15_8 then
			var_15_2.x_, var_15_2.y_ = var_15_2.x, var_15_2.y
		end

		if var_15_0.open then
			if ui.is_menu_open() then
				if var_15_4.bool and not var_15_8 then
					var_15_4.bool = false
				end

				if var_15_4.bool and var_15_8 then
					var_0_15.param.x, var_0_15.param.y = var_15_2.x - var_15_4.x, var_15_2.y - var_15_4.y

					var_0_2.data.write("custom_console/parameters", var_0_15.param)
				end

				if var_15_6.window and var_15_6.message == -1 and var_15_8 then
					var_15_4.bool = true
					var_15_4.x, var_15_4.y = var_15_2.x - var_0_15.param.x, var_15_2.y - var_0_15.param.y
				end

				if var_15_8 then
					if var_15_4.rbool then
						var_0_15.param.w, var_0_15.param.h = math.max(350, var_15_2.x - var_15_4.rx), math.max(120, var_15_2.y - var_15_4.ry)
						var_15_4.bool = false

						var_0_2.data.write("custom_console/parameters", var_0_15.param)
					end

					if var_15_6.corner then
						var_15_4.rbool = true
						var_15_4.rx, var_15_4.ry = var_15_2.x - var_0_15.param.w, var_15_2.y - var_0_15.param.h
					end
				else
					var_15_4.rbool = false
				end
			end

			if var_15_5.drag and not var_0_20[1][3] then
				var_15_5.drag = false
			end

			if var_15_5.drag and var_0_20[1][3] then
				var_15_5.y_ = math.min(0, math.max(-var_0_2.render.measure("d", "A") * #var_0_15.logs, var_15_2.y - var_15_5.drag_y))
				var_15_4.bool = false
				var_15_4.rbool = false
			end

			if var_15_6.scroll then
				var_15_5.drag_y = var_15_2.y - var_15_5.y_
				var_15_5.drag = true
			end
		end
	end,
	text = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		local var_16_0 = var_0_16
		local var_16_1 = 0
		local var_16_2 = "[" .. table.concat(var_16_0.pre) .. "] "
		local var_16_3 = ""

		if var_0_18.contains(ui.get(var_0_17.render_rounds), "Render") and arg_16_3.round ~= "nil" then
			var_16_2 = string.format("[%s] [%s] ", arg_16_3.round, table.concat(var_16_0.pre))
		end

		arg_16_3.text = tostring(arg_16_3.text)

		;({
			log = function()
				local var_17_0 = var_0_2.render.measure("d", var_16_2)
				local var_17_1 = var_0_2.render.measure("d", arg_16_3.text)
				local var_17_2 = arg_16_3.alpha or 1

				var_16_1 = (var_17_1 + var_17_0 + 32 - var_0_15.param.w) / 4
				var_16_1 = math.max(0, arg_16_3.text:len() - var_16_1)

				var_0_2.render.text(arg_16_1, arg_16_2, var_16_0.clr.r, var_16_0.clr.g, var_16_0.clr.b, 255 * arg_16_4 * var_17_2, "d", 0, var_16_2)
				var_0_2.render.text(arg_16_1 + var_17_0, arg_16_2, arg_16_3.r, arg_16_3.g, arg_16_3.b, 255 * arg_16_4 * var_17_2, "d", 0, arg_16_3.text:sub(1, var_16_1))

				if ui.get(var_0_17.dont_copy) then
					var_16_3 = arg_16_3.text
				else
					var_16_3 = "[" .. table.concat(var_16_0.pre) .. "] " .. arg_16_3.text
				end
			end,
			message = function()
				local var_18_0 = var_0_2.render.measure("d", arg_16_3.text)
				local var_18_1 = arg_16_3.alpha or 1

				var_16_1 = (var_18_0 + 32 - var_0_15.param.w) / 4
				var_16_1 = math.max(0, arg_16_3.text:len() - var_16_1)

				var_0_2.render.text(arg_16_1, arg_16_2, arg_16_3.r, arg_16_3.g, arg_16_3.b, 255 * arg_16_4 * var_18_1, "d", 0, arg_16_3.text:sub(1, var_16_1))

				if ui.get(var_0_17.dont_copy) then
					var_16_3 = arg_16_3.text
				else
					var_16_3 = "[" .. table.concat(var_16_0.pre) .. "] " .. arg_16_3.text
				end
			end,
			player = function()
				local var_19_0 = {
					arg_16_3.text:find("{")
				}
				local var_19_1 = {
					arg_16_3.text:find("}")
				}

				if var_19_0 and var_19_1 then
					var_16_2 = arg_16_3.text:sub(var_19_0[1] + 1, var_19_1[1] - 1) .. "» "
				else
					var_19_1[1] = -1
					var_16_2 = "unknown » "
				end

				local var_19_2 = var_0_2.render.measure("d", var_16_2)
				local var_19_3 = var_0_2.render.measure("d", arg_16_3.text)
				local var_19_4 = arg_16_3.alpha or 1

				var_16_1 = (var_19_3 + var_19_2 + 32 - var_0_15.param.w) / 4
				var_16_1 = math.max(0, arg_16_3.text:len() - var_16_1)

				var_0_2.render.text(arg_16_1, arg_16_2, var_16_0.clr.r, var_16_0.clr.g, var_16_0.clr.b, 255 * arg_16_4 * var_19_4, "d", 0, var_16_2)
				var_0_2.render.text(arg_16_1 + var_19_2, arg_16_2, arg_16_3.r, arg_16_3.g, arg_16_3.b, 255 * arg_16_4 * var_19_4, "d", 0, arg_16_3.text:sub(var_19_1[1] + 2, var_16_1))

				if ui.get(var_0_17.dont_copy) then
					var_16_3 = arg_16_3.text
				else
					var_16_3 = var_16_2 .. ": " .. arg_16_3.text
				end
			end
		})[arg_16_3.type]()

		return var_16_3
	end
}

function var_0_22.window()
	var_0_22:handle()

	local var_20_0 = var_0_16
	local var_20_1 = var_20_0.clr
	local var_20_2 = var_20_0.mouse
	local var_20_3 = var_20_0.dpi
	local var_20_4 = var_20_0.drag
	local var_20_5 = var_20_0.scroll
	local var_20_6 = var_20_0.hovered
	local var_20_7 = var_20_0.fade
	local var_20_8 = var_0_15.param.x
	local var_20_9 = var_0_15.param.y
	local var_20_10 = var_0_15.param.w * var_20_3
	local var_20_11 = var_0_15.param.h * var_20_3
	local var_20_12 = {
		var_0_2.render.measure("d", "A")
	}
	local var_20_13 = {
		x = var_20_8 + 24,
		y = var_20_9 + 10,
		w = var_20_10 - 43,
		h = var_20_11 - 30
	}
	local var_20_14 = ui.get(var_0_17.render_line) and 4 or 0
	local var_20_15 = var_20_13.y + var_20_13.h - var_20_5.y_ - 15 + var_20_14
	local var_20_16 = globals.frametime() * 10

	if not var_20_0.open_send then
		var_20_6.message = -1
	end

	local var_20_17 = {
		style = ui.get(var_0_17.style)
	}

	var_20_0.scroll.x = var_20_13.x + var_20_13.w - 5

	if #var_0_15.logs > 150 then
		table.remove(var_0_15.logs, 1)
	end

	if var_20_7 > 0 then
		if var_20_17.style == "Gamesense" then
			var_0_18.draw_ui(var_20_8, var_20_9, var_20_10, var_20_11 + var_20_14, var_20_7)
			var_0_18.draw_container(var_20_8 + 16, var_20_9 + 16 + var_20_14, var_20_10 - 32, var_20_11 - 32, var_20_7, var_20_0.pre[1], var_20_0.pre[2])

			for iter_20_0, iter_20_1 in pairs(var_0_15.logs) do
				local var_20_18 = (var_20_12[2] + 2) * (#var_0_15.logs - iter_20_0)
				local var_20_19 = false

				if var_20_15 - var_20_18 >= var_20_13.y + var_20_14 + 10 and var_20_15 - var_20_18 <= var_20_13.y + var_20_14 + var_20_13.h - 12 then
					if iter_20_1.can_copy then
						var_20_19 = var_0_18.intersect({
							var_20_2.x,
							var_20_2.y
						}, var_20_13.x, var_20_15 - var_20_18, var_20_13.w - 8, 12)
					end

					local var_20_20 = var_20_7

					if var_20_19 then
						var_20_20 = (var_0_20[1][3] or var_0_20[2][3]) and 0.5 or 0.65

						if not var_20_0.open_send then
							var_20_6.message = iter_20_0
						end
					elseif var_20_6.message == iter_20_0 then
						var_20_20 = 0.5
					end

					local var_20_21 = var_0_22:text(var_20_13.x, var_20_15 - var_20_18, iter_20_1, var_20_20)

					if var_20_19 then
						if var_0_20[1][4] then
							var_0_11.CopyTextToClipboard(var_20_21)
						end

						if var_0_20[2][2] then
							var_20_0.open_send = not var_20_0.open_send
						end
					end

					var_0_15.logs[iter_20_0].to_copy = var_20_21
				end
			end

			if var_20_0.open_send then
				local var_20_22 = {
					x = var_20_13.x - 110,
					y = var_20_15 - (var_20_12[2] + 2) * (#var_0_15.logs - var_20_6.message)
				}

				var_20_6.send = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_22.x, var_20_22.y, 80, 40)

				local var_20_23 = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_22.x, var_20_22.y, 80, 18)
				local var_20_24 = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_22.x, var_20_22.y + 20, 80, 18)

				if not var_20_6.send and var_0_20[1][2] then
					var_20_0.open_send = false
				end

				var_0_2.render.rectangle(var_20_22.x - 1, var_20_22.y - 1, 82, 42, 0, 0, 0, 255 * var_20_7)
				var_0_2.render.rectangle(var_20_22.x, var_20_22.y, 80, 40, 25, 25, 25, 255 * var_20_7)

				if var_20_23 then
					var_0_2.render.rectangle(var_20_22.x, var_20_22.y, 80, 20, 15, 15, 15, 255 * var_20_7)

					if var_0_20[1][4] then
						client.exec("say ", var_0_15.logs[var_20_6.message].to_copy or var_0_15.logs[var_20_6.message].text)

						var_20_0.open_send = false
					end
				end

				var_0_2.render.text(var_20_22.x + 8, var_20_22.y + 4, 220, 220, 220, 255 * var_20_7, "", 0, "Global chat")

				if var_20_24 then
					var_0_2.render.rectangle(var_20_22.x, var_20_22.y + 20, 80, 20, 15, 15, 15, 255 * var_20_7)

					if var_0_20[1][4] then
						client.exec("say_team ", var_0_15.logs[var_20_6.message].to_copy or var_0_15.logs[var_20_6.message].text)

						var_20_0.open_send = false
					end
				end

				var_0_2.render.text(var_20_22.x + 8, var_20_22.y + 24, 220, 220, 220, 255 * var_20_7, "", 0, "Team chat")
			end

			var_0_2.render.rectangle(var_20_8 + 20, var_20_9 + 18 + var_20_14, var_20_10 - 40, 1, 45, 45, 45, 255 * var_20_7)
			var_0_2.render.rectangle(var_20_8 + 20, var_20_9 + 19 + var_20_14, var_20_10 - 40, 7, 25, 25, 25, 255 * var_20_7)
			var_0_2.render.gradient(var_20_8 + 20, var_20_9 + 25 + var_20_14, var_20_10 - 40, 15, 25, 25, 25, 255 * var_20_7, 25, 25, 25, 20 * var_20_7, false)
			var_0_2.render.gradient(var_20_8 + 20, var_20_9 + var_20_11 - 34 + var_20_14, var_20_10 - 40, 15, 25, 25, 25, 20 * var_20_7, 25, 25, 25, 255 * var_20_7, false)
			var_0_2.render.text(var_20_8 + 32, var_20_9 + 10 + var_20_14, 220, 220, 220, 255 * var_20_7, "db", 0, var_20_0.pre[1])
			var_0_2.render.text(var_20_8 + 32 + var_0_2.render.measure("db", var_20_0.pre[1]), var_20_9 + 10 + var_20_14, var_0_16.clr.r, var_0_16.clr.g, var_0_16.clr.b, 255 * var_20_7, "db", 0, var_20_0.pre[2])

			var_20_0.scroll.y = math.max(var_20_13.y + 12, math.min(var_20_13.y + var_20_13.h - var_20_5.h, var_20_13.y + var_20_5.y_ + 1 + 2 * #var_0_15.logs))
			var_20_0.scroll.h = math.max(12, var_20_13.h - 2 - 2 * #var_0_15.logs)

			if var_20_5.h < var_20_13.h - 15 then
				var_0_2.render.rectangle(var_20_13.x + var_20_13.w - 6, var_20_13.y + 8 + var_20_14, 6, var_20_13.h - 6, 45, 45, 45, 255 * var_20_7)
				var_0_2.render.rectangle(var_20_5.x, var_20_5.y + var_20_14, 4 * var_20_3, var_20_5.h, 60, 60, 60, 255 * var_20_7)
			end
		elseif var_20_17.style == "Pasted" then
			var_0_2.render.rectangle(var_20_8, var_20_9, var_20_10, var_20_11, 25, 25, 25, 255 * var_20_7)
			var_0_2.render.rectangle(var_20_8 + 12, var_20_9 + 20 + var_20_14, var_20_10 - 26, var_20_11 - 32, 15, 15, 15, 255 * var_20_7)

			var_20_13.x = var_20_13.x - 4

			if ui.get(var_0_17.render_line) then
				var_0_2.render.rectangle(var_20_8 + 1, var_20_9 + 1, var_20_10 - 2, 2, var_20_0.clr.r, var_20_0.clr.g, var_20_0.clr.b, 255 * var_20_7)
				var_0_2.render.rectangle(var_20_8 + 1, var_20_9 + 2, var_20_10 - 2, 1, 0, 0, 0, 190 * var_20_7)
			end

			for iter_20_2, iter_20_3 in pairs(var_0_15.logs) do
				local var_20_25 = (var_20_12[2] + 2) * (#var_0_15.logs - iter_20_2) - 8
				local var_20_26 = false

				if var_20_15 - var_20_25 >= var_20_13.y + var_20_14 + 10 and var_20_15 - var_20_25 <= var_20_13.y + var_20_14 + var_20_13.h - 6 then
					if iter_20_3.can_copy then
						var_20_26 = var_0_18.intersect({
							var_20_2.x,
							var_20_2.y
						}, var_20_13.x, var_20_15 - var_20_25, var_20_13.w - 8, 12)
					end

					local var_20_27 = var_20_7

					if var_20_26 then
						var_20_27 = (var_0_20[1][3] or var_0_20[2][3]) and 0.5 or 0.65

						if not var_20_0.open_send then
							var_20_6.message = iter_20_2
						end
					elseif var_20_6.message == iter_20_2 then
						var_20_27 = 0.5
					end

					local var_20_28 = var_0_22:text(var_20_13.x, var_20_15 - var_20_25, iter_20_3, var_20_27)

					if var_20_26 then
						if var_0_20[1][4] then
							var_0_11.CopyTextToClipboard(var_20_28)
						end

						if var_0_20[2][2] then
							var_20_0.open_send = not var_20_0.open_send
						end
					end
				end
			end

			if var_20_0.open_send then
				local var_20_29 = {
					x = var_20_13.x - 110,
					y = var_20_15 - (var_20_12[2] + 2) * (#var_0_15.logs - var_20_6.message)
				}

				var_20_6.send = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_29.x, var_20_29.y, 80, 40)

				local var_20_30 = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_29.x, var_20_29.y, 80, 18)
				local var_20_31 = var_0_18.intersect({
					var_20_2.x,
					var_20_2.y
				}, var_20_29.x, var_20_29.y + 20, 80, 18)

				if not var_20_6.send and var_0_20[1][2] then
					var_20_0.open_send = false
				end

				var_0_2.render.rectangle(var_20_29.x - 1, var_20_29.y - 1, 82, 42, 0, 0, 0, 255 * var_20_7)
				var_0_2.render.rectangle(var_20_29.x, var_20_29.y, 80, 40, 25, 25, 25, 255 * var_20_7)

				if var_20_30 then
					var_0_2.render.rectangle(var_20_29.x, var_20_29.y, 80, 20, 15, 15, 15, 255 * var_20_7)

					if var_0_20[1][4] then
						client.exec("say ", var_0_15.logs[var_20_6.message].text)

						var_20_0.open_send = false
					end
				end

				var_0_2.render.text(var_20_29.x + 8, var_20_29.y + 4, 220, 220, 220, 255 * var_20_7, "", 0, "Global chat")

				if var_20_31 then
					var_0_2.render.rectangle(var_20_29.x, var_20_29.y + 20, 80, 20, 15, 15, 15, 255 * var_20_7)

					if var_0_20[1][4] then
						client.exec("say_team ", var_0_15.logs[var_20_6.message].text)

						var_20_0.open_send = false
					end
				end

				var_0_2.render.text(var_20_29.x + 8, var_20_29.y + 24, 220, 220, 220, 255 * var_20_7, "", 0, "Team chat")
			end

			var_0_2.render.rectangle(var_20_8 + 14, var_20_9 + 20 + var_20_14, var_20_10 - 40, 7, 15, 15, 15, 255 * var_20_7)
			var_0_2.render.gradient(var_20_8 + 14, var_20_9 + 25 + var_20_14, var_20_10 - 40, 15, 15, 15, 15, 255 * var_20_7, 15, 15, 15, 20 * var_20_7, false)
			var_0_2.render.gradient(var_20_8 + 14, var_20_9 + var_20_11 - 30 + var_20_14, var_20_10 - 40, 15, 15, 15, 15, 20 * var_20_7, 15, 15, 15, 255 * var_20_7, false)
			var_0_2.render.text(var_20_8 + 12, var_20_9 + 2 + var_20_14, 220, 220, 220, 255 * var_20_7, "db", 0, var_20_0.pre[1])
			var_0_2.render.text(var_20_8 + 12 + var_0_2.render.measure("db", var_20_0.pre[1]), var_20_9 + 2 + var_20_14, var_0_16.clr.r, var_0_16.clr.g, var_0_16.clr.b, 255 * var_20_7, "db", 0, var_20_0.pre[2])

			var_20_0.scroll.x = var_20_13.x + var_20_13.w + 4
			var_20_0.scroll.y = math.max(var_20_13.y + 12, math.min(var_20_13.y + var_20_13.h - var_20_5.h, var_20_13.y + var_20_5.y_ + 2 * #var_0_15.logs))
			var_20_0.scroll.h = math.max(12, var_20_13.h - 2 * #var_0_15.logs)

			var_0_2.render.rectangle(var_20_13.x + var_20_13.w + 3, var_20_13.y + 10 + var_20_14, 6, var_20_13.h - 2, 45, 45, 45, 255 * var_20_7)

			if var_20_5.h < var_20_13.h - 5 then
				var_0_2.render.rectangle(var_20_5.x, var_20_5.y + var_20_14, 4 * var_20_3, var_20_5.h, 60, 60, 60, 255 * var_20_7)
			end
		end
	else
		var_20_0.open_send = false
	end

	var_20_0.fade = var_0_18.clamp(var_20_0.fade + (var_20_0.open and var_20_16 / 2 or -var_20_16), 0, 1)
end

client.set_event_callback("paint_ui", var_0_22.window)
client.set_event_callback("output", function(arg_21_0)
	var_0_19.print("log", arg_21_0.r, arg_21_0.g, arg_21_0.b, true, arg_21_0.text)
end)
client.set_event_callback("console_input", function(arg_22_0)
	if arg_22_0:sub(1, 9):lower() == "clear_lua" then
		print("Cleared custom console")

		var_0_15.logs = {}

		var_0_2.data.write("custom_console/logs", nil)

		return true
	end
end)
client.set_event_callback("round_start", function()
	if var_0_18.contains(ui.get(var_0_17.render_rounds), "Print on round start") then
		var_0_19.print("message", var_0_16.clr.r, var_0_16.clr.g, var_0_16.clr.b, false, "» Round started!")
	end
end)

local function var_0_23(arg_24_0)
	local var_24_0 = ui.get(arg_24_0)

	for iter_24_0, iter_24_1 in pairs(var_0_17) do
		if iter_24_0 ~= "show" and iter_24_0 ~= "hotkey" then
			ui.set_visible(var_0_17[iter_24_0], var_24_0)
		end
	end
end

local function var_0_24()
	if ui.get(var_0_17.clear_logs) then
		var_0_2.data.write("custom_console/logs", nil)
	end

	var_0_2.data.write("custom_console/clear", ui.get(var_0_17.clear_logs))
end

ui.set_callback(var_0_17.show, var_0_23)
var_0_23(var_0_17.show)
client.set_event_callback("shutdown", var_0_24)

package.preload["gamesense/custom_console"] = function()
	return var_0_19
end
