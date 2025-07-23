-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

﻿local var_0_0 = require("gamesense/pui")
local var_0_1 = require("gamesense/icons")
local var_0_2 = {}
local var_0_3 = ui.reference("MISC", "Settings", "Menu color")
local var_0_4 = cvar.cl_drawhud_force_deathnotices

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = string.format("%02X", arg_1_0)
	local var_1_1 = string.format("%02X", arg_1_1)
	local var_1_2 = string.format("%02X", arg_1_2)

	return var_1_0 .. var_1_1 .. var_1_2 .. "FF"
end

local var_0_6 = {
	cog = {
		"settings",
		"misc"
	},
	eye = {
		"visual"
	},
	["x-circle"] = {
		"danger",
		"error",
		"x"
	},
	["exclamation-triangle"] = {
		"warn",
		"warning"
	},
	["check-circle"] = {
		"success"
	},
	envelope = {
		"message"
	},
	fire = {
		"hot",
		"flame"
	},
	home = {
		"house"
	}
}
local var_0_7 = {}

for iter_0_0, iter_0_1 in pairs(var_0_6) do
	var_0_1.hero.get_texture(iter_0_0, "solid", {
		255,
		255,
		255,
		255
	}, 20, function(arg_2_0)
		if not arg_2_0 then
			return print("couldn't load icon '" .. iter_0_0 .. "'")
		end

		var_0_6[iter_0_0] = arg_2_0
		var_0_7[iter_0_0] = iter_0_0

		for iter_2_0, iter_2_1 in ipairs(iter_0_1) do
			var_0_7[iter_2_1] = iter_0_0
		end
	end)
end

local function var_0_8(arg_3_0)
	return 1 - math.sqrt(1 - arg_3_0 * arg_3_0)
end

local function var_0_9(arg_4_0)
	arg_4_0 = arg_4_0 - 1

	return math.sqrt(1 - arg_4_0 * arg_4_0)
end

local var_0_10 = 0

function AddNotification(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = false

	if arg_5_3 and (not arg_5_4 or _G.type(arg_5_4) ~= "number") then
		arg_5_4 = var_0_6[var_0_7[arg_5_3] or ""] or nil
		var_5_0 = not not arg_5_4
	end

	var_0_10 = var_0_10 + 1
	var_0_2[#var_0_2 + 1] = {
		id = var_0_10,
		title = arg_5_0,
		description = arg_5_1,
		duration = arg_5_2,
		type = arg_5_3,
		type_icon = var_5_0,
		icon = arg_5_4,
		color = arg_5_5,
		time = globals.realtime() * 1000
	}

	return var_0_10
end

local function var_0_11(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(var_0_2) do
		if iter_6_1.id == arg_6_0 then
			table.remove(var_0_2, iter_6_0)

			return true
		end
	end

	return false
end

local function var_0_12(arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(var_0_2) do
		if iter_7_1.id == arg_7_0 then
			for iter_7_2, iter_7_3 in pairs(arg_7_1) do
				if iter_7_2 ~= "id" then
					var_0_2[iter_7_0][iter_7_2] = iter_7_3
				end
			end

			return true
		end
	end

	return false
end

local var_0_13 = {}
local var_0_14 = {
	ui.get(ui.reference("MISC", "Settings", "Menu color"))
}
local var_0_15 = var_0_5(table.unpack(var_0_14))
local var_0_16 = "\a" .. var_0_15 .. " [Notifications] \aBDBDBDFF"
local var_0_17 = var_0_0.group("CONFIG", "Lua")
local var_0_18 = var_0_17:combobox(var_0_16 .. "Navigation", {
	"-",
	"Appearance",
	"Position & Size",
	"Debug"
})

var_0_13.Debug = {
	send_notification = var_0_17:button("Send test notification", function()
		AddNotification("Test Notification", "Just a simple test notification with some regular text, some \a69FF69FFcolored{default} and {menu}menu-colored {default}text", 300000, "flame")
	end),
	clear_notifications = var_0_17:button("Clear all notifications", function()
		var_0_2 = {}
	end)
}
var_0_13.Appearance = {
	enable_killfeed = var_0_17:checkbox(var_0_16 .. "Show kill feed while drawing"),
	disable_glow = var_0_17:checkbox(var_0_16 .. "Disable glow effect"),
	disable_blur = var_0_17:checkbox(var_0_16 .. "Disable blur effect"),
	roundness = var_0_17:slider(var_0_16 .. "Background roundness", 0, 20, 5)
}
var_0_13["Position & Size"] = {
	pos_x = var_0_17:slider(var_0_16 .. "Position (X)", 0, 100, 91, 1, "%"),
	pos_y = var_0_17:slider(var_0_16 .. "Position (Y)", 0, 100, 1, 1, "%"),
	width = var_0_17:slider(var_0_16 .. "Max width", 200, 500, 430, 1, "px")
}

var_0_0.traverse(var_0_13, function(arg_10_0, arg_10_1)
	arg_10_0:depend({
		var_0_18,
		arg_10_1[1]
	})
end)
var_0_0.setup(var_0_13)

function renderer.rounded_rectangle(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9)
	arg_11_1 = arg_11_1 + arg_11_8

	local var_11_0 = {
		{
			arg_11_0 + arg_11_8,
			arg_11_1,
			180
		},
		{
			arg_11_0 + arg_11_2 - arg_11_8,
			arg_11_1,
			90
		},
		{
			arg_11_0 + arg_11_8,
			arg_11_1 + arg_11_3 - arg_11_8 * 2,
			270
		},
		{
			arg_11_0 + arg_11_2 - arg_11_8,
			arg_11_1 + arg_11_3 - arg_11_8 * 2,
			0
		}
	}
	local var_11_1 = {
		{
			arg_11_0 + arg_11_8,
			arg_11_1,
			arg_11_2 - arg_11_8 * 2,
			arg_11_3 - arg_11_8 * 2
		},
		{
			arg_11_0 + arg_11_8,
			arg_11_1 - arg_11_8,
			arg_11_2 - arg_11_8 * 2,
			arg_11_8
		},
		{
			arg_11_0 + arg_11_8,
			arg_11_1 + arg_11_3 - arg_11_8 * 2,
			arg_11_2 - arg_11_8 * 2,
			arg_11_8
		},
		{
			arg_11_0,
			arg_11_1,
			arg_11_8,
			arg_11_3 - arg_11_8 * 2
		},
		{
			arg_11_0 + arg_11_2 - arg_11_8,
			arg_11_1,
			arg_11_8,
			arg_11_3 - arg_11_8 * 2
		}
	}

	if arg_11_9 then
		renderer.gradient(arg_11_0, arg_11_1 - arg_11_3 - arg_11_9 * 2, arg_11_2 + 2 * arg_11_9 - arg_11_9 * 2, arg_11_3 + 2 * arg_11_9, 0, 0, 0, 0, arg_11_4, arg_11_5, arg_11_6, arg_11_7 / 2, false)
		renderer.gradient(arg_11_0 + arg_11_2 - 1, arg_11_1 - 1, arg_11_9 * 2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7 / 2, 0, 0, 0, 0, true)
	end

	for iter_11_0, iter_11_1 in next, var_11_0 do
		renderer.circle(iter_11_1[1], iter_11_1[2], arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, iter_11_1[3], 0.25)
	end

	for iter_11_2, iter_11_3 in next, var_11_1 do
		renderer.rectangle(iter_11_3[1], iter_11_3[2], iter_11_3[3], iter_11_3[4], arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	end
end

local function var_0_19(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, ...)
	local var_12_0 = table.concat({
		...
	}, " ")
	local var_12_1 = {}

	for iter_12_0 in var_12_0:gmatch("%S+") do
		table.insert(var_12_1, iter_12_0)
	end

	local var_12_2 = {}
	local var_12_3 = ""

	for iter_12_1, iter_12_2 in ipairs(var_12_1) do
		local var_12_4 = var_12_3 .. iter_12_2

		if arg_12_7 < renderer.measure_text(arg_12_6, var_12_4) then
			table.insert(var_12_2, var_12_3)

			var_12_3 = iter_12_2 .. " "
		else
			var_12_3 = var_12_4 .. " "
		end

		if iter_12_1 == #var_12_1 then
			table.insert(var_12_2, var_12_3)
		end
	end

	for iter_12_3, iter_12_4 in ipairs(var_12_2) do
		local var_12_5 = {}

		for iter_12_5 in iter_12_4:gmatch("%S+") do
			table.insert(var_12_5, iter_12_5)
		end

		local var_12_6, var_12_7 = renderer.measure_text(arg_12_6, "A")

		renderer.text(arg_12_0, arg_12_1 + (iter_12_3 - 1) * var_12_7, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7, table.concat(var_12_5, " "))
	end
end

local function var_0_20(arg_13_0, arg_13_1, ...)
	local var_13_0 = table.concat({
		...
	}, " ")
	local var_13_1 = {}

	for iter_13_0 in var_13_0:gmatch("%S+") do
		table.insert(var_13_1, iter_13_0)
	end

	local var_13_2 = {}
	local var_13_3 = ""

	for iter_13_1, iter_13_2 in ipairs(var_13_1) do
		local var_13_4 = var_13_3 .. iter_13_2

		if arg_13_1 < renderer.measure_text(arg_13_0, var_13_4) then
			table.insert(var_13_2, var_13_3)

			var_13_3 = iter_13_2 .. " "
		else
			var_13_3 = var_13_4 .. " "
		end

		if iter_13_1 == #var_13_1 then
			table.insert(var_13_2, var_13_3)
		end
	end

	local var_13_5, var_13_6 = renderer.measure_text(arg_13_0, "A")
	local var_13_7 = var_13_6 * #var_13_2
	local var_13_8 = 0

	for iter_13_3, iter_13_4 in ipairs(var_13_2) do
		local var_13_9 = renderer.measure_text(arg_13_0, iter_13_4)

		var_13_8 = math.max(var_13_8, var_13_9)
	end

	return var_13_8, var_13_7
end

local var_0_21 = "+"
local var_0_22 = "d"
local var_0_23 = 10
local var_0_24 = 250

local function var_0_25(arg_14_0)
	local var_14_0 = {}
	local var_14_1 = #arg_14_0

	for iter_14_0 = 1, var_14_1 do
		var_14_0[iter_14_0] = arg_14_0[var_14_1 - iter_14_0 + 1]
	end

	return var_14_0
end

local function var_0_26()
	local var_15_0, var_15_1, var_15_2 = ui.get(var_0_3)
	local var_15_3 = var_0_5(var_15_0, var_15_1, var_15_2)
	local var_15_4 = globals.realtime() * 1000
	local var_15_5, var_15_6 = client.screen_size()
	local var_15_7 = 0
	local var_15_8 = var_0_13["Position & Size"].width.value
	local var_15_9 = var_0_13["Position & Size"].pos_x.value
	local var_15_10 = var_0_13["Position & Size"].pos_y.value
	local var_15_11 = var_15_10 >= 50 and var_0_25(var_0_2) or var_0_2

	for iter_15_0, iter_15_1 in pairs(var_15_11) do
		local var_15_12, var_15_13, var_15_14 = table.unpack(iter_15_1.color and iter_15_1.color or {
			var_15_0,
			var_15_1,
			var_15_2
		})
		local var_15_15 = var_15_4 - iter_15_1.time
		local var_15_16 = math.max(0, math.min(1, var_15_15 / var_0_24))
		local var_15_17 = 255

		if var_15_16 < 1 then
			var_15_17 = math.floor(var_0_8(var_15_16) * 255)
		end

		local var_15_18 = 0
		local var_15_19 = 0
		local var_15_20 = 0
		local var_15_21 = 0

		if var_15_15 > iter_15_1.duration then
			var_15_18 = math.max(0, math.min(1, (var_15_4 - (iter_15_1.time + iter_15_1.duration)) / var_0_24))

			local var_15_22 = math.max(0, math.min(1, (var_15_4 - (iter_15_1.time + iter_15_1.duration)) / (var_0_24 / 2)))

			var_15_17 = math.floor(var_0_9(1 - var_15_22) * 255)
		end

		local var_15_23 = iter_15_1.description:gsub("{menu}", "\a" .. var_15_3):gsub("{default}", "\a" .. var_0_5(220, 220, 220)):gsub("(\a......)(..)", function(arg_16_0, arg_16_1)
			return arg_16_0 .. string.format("%02X", math.min(tonumber(arg_16_1, 16), var_15_17))
		end)
		local var_15_24 = var_15_8 - var_0_23 * 2
		local var_15_25 = 0
		local var_15_26 = 60
		local var_15_27, var_15_28 = var_0_20(var_0_22, var_15_24, var_15_23)
		local var_15_29 = var_15_26 + var_0_23 + (var_15_28 + var_0_23) - 30

		if var_15_15 > iter_15_1.duration then
			var_15_19 = 1 - var_0_9(1 - var_15_18)

			local var_15_30 = 0
			local var_15_31 = 0

			if var_15_9 > 65 then
				var_15_30 = var_15_5 * 1.2 + var_15_8 * 2
			elseif var_15_9 < 45 then
				var_15_30 = 0 - var_15_8 * 2
			elseif var_15_10 >= 50 then
				var_15_31 = var_15_6 * 1.2 + var_15_8 * 2
			else
				var_15_31 = 0 - var_15_29 * 2
			end

			var_15_20 = var_15_30 * var_15_19
			var_15_21 = var_15_31 * var_15_19
		end

		local var_15_32 = var_15_5 * (var_15_9 / 100) + var_15_24 / 2 + var_15_20
		local var_15_33 = var_15_6 * (var_15_10 / 100) + var_15_7 + var_15_21
		local var_15_34 = 1 - var_15_15 / iter_15_1.duration

		if iter_15_1.duration ~= 0 and var_15_15 >= iter_15_1.duration and var_15_15 > iter_15_1.duration + var_0_24 then
			var_0_11(iter_15_1.id)
		else
			if not var_0_13.Appearance.disable_blur.value and entity.get_local_player() then
				renderer.blur(var_15_32 - var_15_8, var_15_33, var_15_8 + var_0_23, var_15_29 + var_0_23, 50, 1)
				renderer.rounded_rectangle(var_15_32 - var_15_8, var_15_33, var_15_8 + var_0_23, var_15_29 + var_0_23, 0, 0, 0, math.min(200, var_15_17), var_0_13.Appearance.roundness.value)
			else
				renderer.rounded_rectangle(var_15_32 - var_15_8, var_15_33, var_15_8 + var_0_23, var_15_29 + var_0_23, 0, 0, 0, math.min(220, var_15_17), var_0_13.Appearance.roundness.value)
			end

			local var_15_35 = 0

			if iter_15_1.icon then
				if type(iter_15_1.icon) == "number" then
					if iter_15_1.type_icon and not var_0_13.Appearance.disable_glow.value then
						renderer.texture(iter_15_1.icon, var_15_32 - var_15_8 + var_0_23 - 2, var_15_33 + var_0_23 - 2, 24, 24, var_15_12, var_15_13, var_15_14, var_15_17, "f")
					end

					renderer.texture(iter_15_1.icon, var_15_32 - var_15_8 + var_0_23, var_15_33 + var_0_23, 20, 20, 255, 255, 255, var_15_17, "f")
				else
					iter_15_1.icon:draw(var_15_4 / 1000 - iter_15_1.time / 1000, var_15_32 - var_15_8 + var_0_23, var_15_33 + var_0_23, 20, 20, 255, 255, 255, 255)
				end

				var_15_35 = 20 + var_0_23
			end

			renderer.text(var_15_32 - var_15_8 + var_0_23 + var_15_35, var_15_33 + var_0_23 / 2, 255, 255, 255, var_15_17, var_0_21, var_15_8 - var_0_23 * 2 - var_15_35, iter_15_1.title)
			var_0_19(var_15_32 - var_15_8 + var_0_23, var_15_33 + var_0_23 / 2 + var_15_26 + var_0_23 / 2 - 30, 220, 220, 220, var_15_17, var_0_22, var_15_8 - var_0_23 * 2, var_15_23)

			if var_15_15 < iter_15_1.duration and iter_15_1.duration ~= math.huge then
				renderer.rounded_rectangle(var_15_32 - var_15_8 + math.max(0, var_0_13.Appearance.roundness.value / 2), var_15_33 + var_15_29 + var_0_23 - 5, math.floor(math.max(0, (var_15_8 + var_0_23) * var_15_34 - var_0_13.Appearance.roundness.value) + 0.5), 5, var_15_12, var_15_13, var_15_14, var_15_17, 1, not var_0_13.Appearance.disable_glow.value and 5 or 0)
			end

			var_15_7 = var_15_7 + var_15_29 + var_0_23 * 2

			if var_15_15 > iter_15_1.duration then
				var_15_7 = var_15_7 - (var_15_29 + var_0_23 * 2) * var_15_19
			end
		end
	end

	local var_15_36 = var_0_4:get_int()

	if not var_0_13.Appearance.enable_killfeed.value and var_15_7 > 0 and var_15_36 ~= -1 then
		var_0_4:set_int(-1)
	elseif (var_0_13.Appearance.enable_killfeed.value or var_15_7 == 0) and var_15_36 ~= 0 then
		var_0_4:set_int(0)
	end
end

client.set_event_callback("paint_ui", function()
	var_0_26()
end)
client.set_event_callback("gs:notification", function(arg_18_0)
	AddNotification(table.unpack(arg_18_0))
end)

return {
	add = AddNotification,
	remove = var_0_11,
	edit = var_0_12
}
