-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = {}

local function var_0_1()
	var_0_0 = {}
end

local var_0_2 = ui.new_checkbox("LUA", "a", "Enable Trails")
local var_0_3 = ui.new_slider("LUA", "a", "Trail Segment Expiration", 1, 100, 10, true, "s", 0.1)
local var_0_4 = ui.new_combobox("LUA", "a", "Trail Type", "Line", "Advanced Line", "Rect")
local var_0_5 = ui.new_combobox("LUA", "a", "Trail Color Type", "Static", "Chroma", "Gradient Chroma")
local var_0_6 = ui.new_color_picker("LUA", "a", "Trail Color", 246, 34, 34, 255)
local var_0_7 = ui.new_slider("LUA", "a", "Trail Chroma Speed Multiplier", 1, 100, 1, true, "%", 0.1)
local var_0_8 = ui.new_slider("LUA", "a", "Line Size", 1, 100, 1, true)
local var_0_9 = ui.new_slider("LUA", "a", "Rect Width", 1, 100, 1, true)
local var_0_10 = ui.new_slider("LUA", "a", "Rect Height", 1, 100, 1, true)
local var_0_11 = ui.new_slider("LUA", "a", "Trail X Width", 1, 100, 1, true)
local var_0_12 = ui.new_slider("LUA", "a", "Trail Y Width", 1, 100, 1, true)

ui.new_button("LUA", "a", "Clear Trail Data", var_0_1)

local var_0_13 = require("vector")

local function var_0_14(arg_2_0, arg_2_1)
	local var_2_0 = math.floor(math.sin((globals.realtime() + arg_2_0) * arg_2_1) * 127 + 128)
	local var_2_1 = math.floor(math.sin((globals.realtime() + arg_2_0) * arg_2_1 + 2) * 127 + 128)
	local var_2_2 = math.floor(math.sin((globals.realtime() + arg_2_0) * arg_2_1 + 4) * 127 + 128)

	return var_2_0, var_2_1, var_2_2
end

client.set_event_callback("paint", function()
	local var_3_0 = ui.get(var_0_5)
	local var_3_1 = ui.get(var_0_4)

	ui.set_visible(var_0_6, var_3_0 == "Static")
	ui.set_visible(var_0_7, var_3_0 ~= "Static")
	ui.set_visible(var_0_11, var_3_1 == "Advanced Line")
	ui.set_visible(var_0_12, var_3_1 == "Advanced Line")
	ui.set_visible(var_0_8, var_3_1 == "Line")
	ui.set_visible(var_0_9, var_3_1 == "Rect")
	ui.set_visible(var_0_10, var_3_1 == "Rect")

	local var_3_2 = entity.get_local_player()

	if entity.is_alive(var_3_2) and ui.get(var_0_2) then
		local var_3_3 = globals.curtime()
		local var_3_4 = var_0_13(entity.get_prop(var_3_2, "m_vecOrigin"))

		if var_0_0.lastOrigin == nil then
			var_0_0.lastOrigin = var_3_4
		end

		local var_3_5 = var_3_4:dist(var_0_0.lastOrigin)

		if var_0_0.trailSegments == nil then
			var_0_0.trailSegments = {}
		end

		if var_3_5 ~= 0 then
			local var_3_6, var_3_7, var_3_8 = entity.get_prop(var_3_2, "m_vecOrigin")
			local var_3_9 = {
				pos = var_3_4,
				exp = var_3_3 + ui.get(var_0_3) * 0.1,
				x = var_3_6,
				y = var_3_7,
				z = var_3_8
			}

			table.insert(var_0_0.trailSegments, var_3_9)
		end

		var_0_0.lastOrigin = var_3_4

		for iter_3_0 = #var_0_0.trailSegments, 1, -1 do
			if var_3_3 > var_0_0.trailSegments[iter_3_0].exp then
				table.remove(var_0_0.trailSegments, iter_3_0)
			end
		end

		for iter_3_1, iter_3_2 in ipairs(var_0_0.trailSegments) do
			local var_3_10, var_3_11 = renderer.world_to_screen(iter_3_2.x, iter_3_2.y, iter_3_2.z)
			local var_3_12 = 0

			if var_3_0 == "Gradient Chroma" then
				var_3_12 = iter_3_1
			end

			if var_3_10 ~= nil and var_3_11 ~= nil then
				local var_3_13, var_3_14, var_3_15 = var_0_14(var_3_12, ui.get(var_0_7) * 0.1)

				if var_3_0 == "Static" then
					var_3_13, var_3_14, var_3_15 = ui.get(var_0_6)
				end

				if var_3_1 == "Line" or var_3_1 == "Advanced Line" then
					if iter_3_1 < #var_0_0.trailSegments then
						local var_3_16 = var_0_0.trailSegments[iter_3_1 + 1]
						local var_3_17, var_3_18 = renderer.world_to_screen(var_3_16.x, var_3_16.y, var_3_16.z)

						if var_3_17 ~= nil and var_3_18 ~= nil then
							if var_3_1 == "Advanced Line" then
								for iter_3_3 = 1, ui.get(var_0_11) do
									renderer.line(var_3_10 + iter_3_3, var_3_11, var_3_17 + iter_3_3, var_3_18, var_3_13, var_3_14, var_3_15, 255)
								end

								for iter_3_4 = 1, ui.get(var_0_12) do
									renderer.line(var_3_10, var_3_11 + iter_3_4, var_3_17, var_3_18 + iter_3_4, var_3_13, var_3_14, var_3_15, 255)
								end
							else
								for iter_3_5 = 1, ui.get(var_0_8) do
									renderer.line(var_3_10 + iter_3_5, var_3_11 + iter_3_5, var_3_17 + iter_3_5, var_3_18 + iter_3_5, var_3_13, var_3_14, var_3_15, 255)
								end
							end
						end
					end
				else
					renderer.rectangle(var_3_10, var_3_11, ui.get(var_0_9), ui.get(var_0_10), var_3_13, var_3_14, var_3_15, 255)
				end
			end
		end
	end
end)
client.set_event_callback("round_start", var_0_1)
