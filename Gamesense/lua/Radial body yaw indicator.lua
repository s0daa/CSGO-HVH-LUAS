local var_0_0 = require("vector")
local var_0_1 = require("gamesense/antiaim_funcs")
local var_0_2 = {
	enabled = ui.new_checkbox("VISUALS", "Other ESP", "Radial anti-aim indicator"),
	selector = ui.new_combobox("VISUALS", "Other ESP", "Customize", "Hide", "Real", "Fake"),
	real = {
		mode = ui.new_combobox("VISUALS", "Other ESP", "Real mode", "Off", "Circle", "Lines"),
		color = ui.new_color_picker("VISUALS", "Other ESP", "Real color", 255, 255, 255, 255),
		offset = ui.new_slider("VISUALS", "Other ESP", "Real offset", 1, 100, 10),
		max = ui.new_slider("VISUALS", "Other ESP", "Real max", 1, 100, 10),
		add = ui.new_slider("VISUALS", "Other ESP", "Real add", -100, 100, 10, true, nil, 0.1),
		dec = ui.new_slider("VISUALS", "Other ESP", "Real decay factor", 1, 100, 80, true, nil, 0.01),
		lag = ui.new_slider("VISUALS", "Other ESP", "Real update", 1, 16, 1, true, "t"),
		divs = ui.new_slider("VISUALS", "Other ESP", "Real subdivisions", 2, 36, 8)
	},
	fake = {
		mode = ui.new_combobox("VISUALS", "Other ESP", "Fake mode", "Off", "Circle", "Lines"),
		color = ui.new_color_picker("VISUALS", "Other ESP", "Fake color", 255, 0, 0, 255),
		offset = ui.new_slider("VISUALS", "Other ESP", "Fake offset", 1, 100, 10),
		max = ui.new_slider("VISUALS", "Other ESP", "Fake max", 1, 100, 10),
		add = ui.new_slider("VISUALS", "Other ESP", "Fake add", -100, 100, 10, true, nil, 0.1),
		dec = ui.new_slider("VISUALS", "Other ESP", "Fake decay factor", 1, 100, 80, true, nil, 0.01),
		lag = ui.new_slider("VISUALS", "Other ESP", "Fake update", 1, 16, 1, true, "t"),
		divs = ui.new_slider("VISUALS", "Other ESP", "Fake subdivisons", 2, 36, 8)
	}
}

local function var_0_3(arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if iter_1_1 ~= arg_1_2 then
			ui.set_visible(iter_1_1, arg_1_1)
		end
	end
end

local var_0_4 = {
	lp = entity.get_local_player(),
	fake = {
		draw = function()
			return
		end,
		angles = {},
		color = {
			ui.get(var_0_2.fake.color)
		},
		offset = ui.get(var_0_2.fake.offset),
		max = ui.get(var_0_2.fake.max),
		add = ui.get(var_0_2.fake.add) * 0.1,
		dec = ui.get(var_0_2.fake.dec) * 0.01,
		lag = ui.get(var_0_2.fake.lag),
		divs = ui.get(var_0_2.fake.divs)
	},
	real = {
		draw = function()
			return
		end,
		angles = {},
		color = {
			ui.get(var_0_2.real.color)
		},
		offset = ui.get(var_0_2.real.offset),
		max = ui.get(var_0_2.real.max),
		add = ui.get(var_0_2.real.add) * 0.1,
		dec = ui.get(var_0_2.real.dec) * 0.01,
		lag = ui.get(var_0_2.real.lag),
		divs = ui.get(var_0_2.real.divs)
	}
}

for iter_0_0 = 1, 361 do
	var_0_4.fake.angles[iter_0_0] = 0
	var_0_4.real.angles[iter_0_0] = 0
end

ui.set_callback(var_0_2.fake.color, function()
	var_0_4.fake.color = {
		ui.get(var_0_2.fake.color)
	}
end)
ui.set_callback(var_0_2.fake.offset, function()
	var_0_4.fake.offset = ui.get(var_0_2.fake.offset)
end)
ui.set_callback(var_0_2.fake.max, function()
	var_0_4.fake.max = ui.get(var_0_2.fake.max)
end)
ui.set_callback(var_0_2.fake.add, function()
	var_0_4.fake.add = ui.get(var_0_2.fake.add) * 0.1
end)
ui.set_callback(var_0_2.fake.dec, function()
	var_0_4.fake.dec = ui.get(var_0_2.fake.dec) * 0.01
end)
ui.set_callback(var_0_2.fake.lag, function()
	var_0_4.fake.lag = ui.get(var_0_2.fake.lag)
end)
ui.set_callback(var_0_2.fake.divs, function()
	var_0_4.fake.divs = ui.get(var_0_2.fake.divs)
end)
ui.set_callback(var_0_2.real.color, function()
	var_0_4.real.color = {
		ui.get(var_0_2.real.color)
	}
end)
ui.set_callback(var_0_2.real.offset, function()
	var_0_4.real.offset = ui.get(var_0_2.real.offset)
end)
ui.set_callback(var_0_2.real.max, function()
	var_0_4.real.max = ui.get(var_0_2.real.max)
end)
ui.set_callback(var_0_2.real.add, function()
	var_0_4.real.add = ui.get(var_0_2.real.add) * 0.1
end)
ui.set_callback(var_0_2.real.dec, function()
	var_0_4.real.dec = ui.get(var_0_2.real.dec) * 0.01
end)
ui.set_callback(var_0_2.real.lag, function()
	var_0_4.real.lag = ui.get(var_0_2.real.lag)
end)
ui.set_callback(var_0_2.real.divs, function()
	var_0_4.real.divs = ui.get(var_0_2.real.divs)
end)

local var_0_5 = {
	Circle = function(arg_18_0)
		local var_18_0 = {}
		local var_18_1 = 0

		for iter_18_0, iter_18_1 in ipairs(arg_18_0.angles) do
			var_18_1 = math.min(var_18_1 + iter_18_1, arg_18_0.max)

			if iter_18_0 % arg_18_0.divs == 0 then
				table.insert(var_18_0, var_18_1)

				var_18_1 = 0
			end
		end

		local var_18_2 = var_0_0(entity.get_origin(var_0_4.lp))

		for iter_18_2 = 1, #var_18_0 - 1 do
			local var_18_3 = var_18_2 + var_0_0():init_from_angles(0, iter_18_2 * arg_18_0.divs - arg_18_0.divs / 2) * (arg_18_0.offset + var_18_0[iter_18_2])
			local var_18_4, var_18_5 = renderer.world_to_screen(var_18_3:unpack())
			local var_18_6 = var_18_2 + var_0_0():init_from_angles(0, (iter_18_2 + 1) * arg_18_0.divs - arg_18_0.divs / 2) * (arg_18_0.offset + var_18_0[iter_18_2 + 1])
			local var_18_7, var_18_8 = renderer.world_to_screen(var_18_6:unpack())

			renderer.line(var_18_4, var_18_5, var_18_7, var_18_8, unpack(arg_18_0.color))
		end

		local var_18_9 = var_18_2 + var_0_0():init_from_angles(0, arg_18_0.divs - arg_18_0.divs / 2) * (arg_18_0.offset + var_18_0[1])
		local var_18_10, var_18_11 = renderer.world_to_screen(var_18_9:unpack())
		local var_18_12 = var_18_2 + var_0_0():init_from_angles(0, #var_18_0 * arg_18_0.divs - arg_18_0.divs / 2) * (arg_18_0.offset + var_18_0[#var_18_0])
		local var_18_13, var_18_14 = renderer.world_to_screen(var_18_12:unpack())

		renderer.line(var_18_10, var_18_11, var_18_13, var_18_14, unpack(arg_18_0.color))
	end,
	Lines = function(arg_19_0)
		local var_19_0 = {}
		local var_19_1 = 0

		for iter_19_0, iter_19_1 in ipairs(arg_19_0.angles) do
			var_19_1 = math.min(var_19_1 + iter_19_1, arg_19_0.max)

			if (iter_19_0 - 1) % arg_19_0.divs == 0 then
				table.insert(var_19_0, var_19_1)

				var_19_1 = 0
			end
		end

		local var_19_2 = var_0_0(entity.get_origin(var_0_4.lp))

		for iter_19_2 = 1, #var_19_0 do
			local var_19_3 = var_19_2 + var_0_0():init_from_angles(0, iter_19_2 * arg_19_0.divs - arg_19_0.divs * 1.5) * (arg_19_0.offset - 2)
			local var_19_4, var_19_5 = renderer.world_to_screen(var_19_3:unpack())
			local var_19_6 = var_19_2 + var_0_0():init_from_angles(0, iter_19_2 * arg_19_0.divs - arg_19_0.divs * 1.5) * (arg_19_0.offset + var_19_0[iter_19_2])
			local var_19_7, var_19_8 = renderer.world_to_screen(var_19_6:unpack())

			renderer.line(var_19_4, var_19_5, var_19_7, var_19_8, unpack(arg_19_0.color))
		end
	end,
	Off = function(arg_20_0)
		return
	end
}

local function var_0_6(arg_21_0)
	var_0_4.lp = entity.get_local_player()

	local var_21_0, var_21_1 = var_0_1.get_body_yaw()
	local var_21_2 = math.max(math.min(math.floor(var_21_0) + 1, 361), 1)
	local var_21_3 = var_0_4.real.angles[var_21_2]

	if var_0_4.real.add < 0 then
		var_0_4.real.angles[var_21_2] = math.max(var_21_3 + var_0_4.real.add, -var_0_4.real.max)
	else
		var_0_4.real.angles[var_21_2] = math.min(var_21_3 + var_0_4.real.add, var_0_4.real.max)
	end

	local var_21_4 = math.max(math.min(math.floor(var_21_1) + 1, 361), 1)
	local var_21_5 = var_0_4.fake.angles[var_21_4]

	if var_0_4.fake.add < 0 then
		var_0_4.fake.angles[var_21_4] = math.max(var_21_5 + var_0_4.fake.add, -var_0_4.fake.max)
	else
		var_0_4.fake.angles[var_21_4] = math.min(var_21_5 + var_0_4.fake.add, var_0_4.fake.max)
	end

	if arg_21_0.command_number % var_0_4.real.lag == 0 then
		for iter_21_0, iter_21_1 in ipairs(var_0_4.real.angles) do
			if math.abs(iter_21_1) > 0 and iter_21_0 ~= var_21_2 then
				var_0_4.real.angles[iter_21_0] = iter_21_1 * var_0_4.real.dec
			end
		end
	end

	if arg_21_0.command_number % var_0_4.fake.lag == 0 then
		for iter_21_2, iter_21_3 in ipairs(var_0_4.fake.angles) do
			if iter_21_3 > 0 and iter_21_2 ~= var_21_4 then
				var_0_4.fake.angles[iter_21_2] = iter_21_3 * var_0_4.fake.dec

				if var_0_4.fake.angles[iter_21_2] < 0.5 then
					var_0_4.fake.angles[iter_21_2] = 0
				end
			end
		end
	end
end

local function var_0_7()
	if entity.is_alive(var_0_4.lp) then
		var_0_4.fake:draw()
		var_0_4.real:draw()
	end
end

local function var_0_8()
	local var_23_0 = ui.get(var_0_2.selector)

	if ui.get(var_0_2.enabled) then
		if var_23_0 == "Hide" then
			var_0_3(var_0_2.real, false)
			var_0_3(var_0_2.fake, false)
		elseif var_23_0 == "Real" then
			ui.set_visible(var_0_2.real.mode, true)
			var_0_3(var_0_2.real, ui.get(var_0_2.real.mode) ~= "Off", var_0_2.real.mode)
			var_0_3(var_0_2.fake, false)
		elseif var_23_0 == "Fake" then
			var_0_3(var_0_2.real, false)
			ui.set_visible(var_0_2.fake.mode, true)
			var_0_3(var_0_2.fake, ui.get(var_0_2.fake.mode) ~= "Off", var_0_2.fake.mode)
		end
	else
		var_0_3(var_0_2.real, false)
		var_0_3(var_0_2.fake, false)
	end
end

local function var_0_9()
	var_0_4.fake.draw = var_0_5[ui.get(var_0_2.fake.mode)]
	var_0_4.real.draw = var_0_5[ui.get(var_0_2.real.mode)]

	var_0_8()
end

local function var_0_10()
	local var_25_0 = ui.get(var_0_2.enabled)
	local var_25_1 = var_25_0 and client.set_event_callback or client.unset_event_callback

	var_25_1("setup_command", var_0_6)
	var_25_1("paint", var_0_7)
	ui.set_visible(var_0_2.selector, var_25_0)
	var_0_8()
end

ui.set_callback(var_0_2.real.mode, var_0_9)
ui.set_callback(var_0_2.fake.mode, var_0_9)
ui.set_callback(var_0_2.selector, var_0_8)
ui.set_callback(var_0_2.enabled, var_0_10)
var_0_10()
