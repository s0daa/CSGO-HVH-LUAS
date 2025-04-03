local var_0_0 = entity.get_local_player()
local var_0_1
local var_0_2
local var_0_3
local var_0_4

if var_0_0 ~= nil then
	var_0_1, var_0_2, var_0_3 = entity.get_origin(var_0_0)
	var_0_4 = var_0_3 + 100000 * client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1, var_0_2, var_0_3 + 100000)
end

local var_0_5, var_0_6 = renderer.world_to_screen(var_0_1, var_0_2, var_0_3)
local var_0_7 = 250
local var_0_8 = {
	false,
	0,
	0,
	0
}
local var_0_9 = {}
local var_0_10 = {}
local var_0_11

if var_0_0 ~= nil then
	var_0_11 = entity.get_classname(entity.get_player_weapon(var_0_0))
end

local var_0_12
local var_0_13 = false
local var_0_14 = {}
local var_0_15 = ""

var_0_10.dt = ui.reference("RAGE", "Other", "Double Tap")
var_0_10.hitchance = ui.reference("RAGE", "Aimbot", "Minimum Hit Chance")
var_0_10.mindamage = ui.reference("RAGE", "Aimbot", "Minimum Damage")
var_0_10.limbsafe = ui.reference("RAGE", "Aimbot", "Force Safe Point on Limbs")
var_0_10.prefersafe = ui.reference("RAGE", "Aimbot", "Prefer Safe Point")

local var_0_16 = {
	{
		"CDEagle",
		"R8 or Deagle"
	},
	{
		"CWeaponSSG08",
		"SSG 08"
	},
	{
		"CWeaponAWP",
		"AWP"
	},
	{
		"CWeaponG3SG1",
		"G3SG1"
	},
	{
		"CWeaponSCAR20",
		"SCAR-20"
	}
}
local var_0_17 = {}

ui.new_label("LUA", "B", "-+-+-+-+ [ Onion's Position LUA ] +-+-+-+-")

local var_0_18 = false
local var_0_19 = {}

if ui.get(var_0_10.dt) then
	var_0_18 = true
end

local var_0_20 = false
local var_0_21 = ui.new_checkbox("LUA", "B", "Enabled")
local var_0_22 = ui.new_checkbox("LUA", "B", "Disable Recharge in Region")
local var_0_23 = ui.new_checkbox("LUA", "B", "Debug Lines")
local var_0_24 = ui.new_slider("LUA", "B", "Draw Distance", 5, 5000, 250)
local var_0_25 = ui.new_checkbox("LUA", "B", "Custom Colors")
local var_0_26 = {
	ui.new_checkbox("LUA", "B", "Draw Color"),
	ui.new_color_picker("LUA", "B", "Draw Color", 3, 136, 252, 100),
	ui.new_checkbox("LUA", "B", "Hover Color"),
	ui.new_color_picker("LUA", "B", "Hover Color", 252, 198, 3, 100)
}
local var_0_27 = ui.new_textbox("LUA", "B", "Position Name")

local function var_0_28(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = {
		tonumber(arg_1_0),
		tonumber(arg_1_1),
		tonumber(arg_1_4),
		tonumber(arg_1_2),
		tonumber(arg_1_3),
		tonumber(arg_1_5)
	}

	for iter_1_0 = 1, #var_1_0 do
		if var_1_0[iter_1_0] > 0 then
			var_1_0[iter_1_0] = var_1_0[iter_1_0] + 100000
		end

		var_1_0[iter_1_0] = math.abs(var_1_0[iter_1_0])
	end

	if var_1_0[1] > var_1_0[2] then
		if var_1_0[3] > var_1_0[1] or var_1_0[3] < var_1_0[2] then
			return false
		end
	elseif var_1_0[3] < var_1_0[1] or var_1_0[3] > var_1_0[2] then
		return false
	end

	if var_1_0[4] > var_1_0[5] then
		if var_1_0[6] > var_1_0[4] or var_1_0[6] < var_1_0[5] then
			return false
		end
	elseif var_1_0[6] < var_1_0[4] or var_1_0[6] > var_1_0[5] then
		return false
	end

	return true
end

local function var_0_29(arg_2_0, arg_2_1)
	if arg_2_1 == nil then
		arg_2_1 = "%s"
	end

	local var_2_0 = {}

	if arg_2_0 ~= nil then
		for iter_2_0 in string.gmatch(arg_2_0, "([^" .. arg_2_1 .. "]+)") do
			table.insert(var_2_0, iter_2_0)
		end
	end

	return var_2_0
end

local var_0_30 = var_0_29(globals.mapname(), "/")
local var_0_31 = var_0_30[#var_0_30]

local function var_0_32(arg_3_0)
	if var_0_17 ~= nil and arg_3_0 ~= nil then
		local var_3_0 = var_0_29(arg_3_0, "\n")

		for iter_3_0 = 1, #var_3_0 do
			if var_0_17[iter_3_0] ~= nil and var_0_17[iter_3_0][1] ~= nil then
				local var_3_1
				local var_3_2
				local var_3_3
				local var_3_4
				local var_3_5 = var_0_29(var_3_0[iter_3_0], "|")
				local var_3_6 = string.find(var_3_5[1], "true") and true or false
				local var_3_7 = string.find(var_3_5[4], "true") and true or false
				local var_3_8 = string.find(var_3_5[5], "true") and true or false
				local var_3_9 = string.find(var_3_5[6], "true") and true or false

				ui.set(var_0_17[iter_3_0][1], var_3_6)
				ui.set(var_0_17[iter_3_0][2], tonumber(var_3_5[2]))
				ui.set(var_0_17[iter_3_0][3], tonumber(var_3_5[3]))
				ui.set(var_0_17[iter_3_0][4], var_3_7)
				ui.set(var_0_17[iter_3_0][5], var_3_8)
				ui.set(var_0_17[iter_3_0][6], var_3_9)
			end
		end
	end
end

local function var_0_33()
	if var_0_0 ~= nil then
		var_0_9 = {}
		var_0_19 = {}

		local var_4_0 = readfile("onionPositions_" .. var_0_31 .. ".db")

		var_0_14 = {}

		local var_4_1 = readfile("onionSettings.db")
		local var_4_2 = var_0_29(var_4_1, "\n")

		for iter_4_0 = 1, #var_4_2 do
			if string.find(var_4_2[iter_4_0], "map: ") then
				table.insert(var_0_14, {
					var_4_2[iter_4_0 + 1] .. "\n" .. var_4_2[iter_4_0 + 2] .. "\n" .. var_4_2[iter_4_0 + 3] .. "\n" .. var_4_2[iter_4_0 + 4] .. "\n" .. var_4_2[iter_4_0 + 5],
					string.gsub(var_4_2[iter_4_0], "map: ", "")
				})
			end
		end

		if #var_0_14 ~= 0 then
			for iter_4_1 = 1, #var_0_14 do
				if string.find(var_0_14[iter_4_1][2], var_0_15) then
					var_0_32(var_0_14[iter_4_1][1])
				end
			end
		end

		if var_4_0 ~= nil and var_4_0 ~= "" then
			local var_4_3 = var_0_29(var_4_0, "\n")

			for iter_4_2 = 1, #var_4_3 do
				local var_4_4 = var_0_29(var_4_3[iter_4_2], "|")

				if #var_4_4 == 6 then
					table.insert(var_0_9, {
						var_4_4[1],
						var_4_4[2],
						{
							var_4_4[3],
							var_4_4[4]
						},
						{
							var_4_4[5],
							var_4_4[6]
						}
					})
					table.insert(var_0_19, var_4_4[1])
				else
					table.insert(var_0_9, {
						"Name",
						var_4_4[1],
						{
							var_4_4[2],
							var_4_4[3]
						},
						{
							var_4_4[4],
							var_4_4[5]
						}
					})
					table.insert(var_0_19, "Name")
				end
			end
		end
	end
end

local function var_0_34()
	name = ui.get(var_0_12)

	local var_5_0 = readfile("onionPositions_" .. var_0_31 .. ".db")
	local var_5_1

	if var_5_0 ~= nil and var_5_0 ~= "" then
		local var_5_2 = var_0_29(var_5_0, "\n")

		for iter_5_0 = 1, #var_5_2 do
			if not string.find(var_5_2[iter_5_0], name) then
				if var_5_1 ~= nil then
					var_5_1 = var_5_1 + "\n" + var_5_2[iter_5_0]
				else
					var_5_1 = var_5_2[iter_5_0]
				end
			end
		end

		writefile("onionPositions_" .. var_0_31 .. ".db", var_5_1)
	end
end

local function var_0_35()
	if ui.get(var_0_21) and var_0_0 ~= nil then
		if var_0_8[1] then
			var_0_8[1] = false

			local var_6_0 = "Name"

			if ui.get(var_0_27) ~= nil and ui.get(var_0_27) ~= "" then
				var_6_0 = ui.get(var_0_27)
			end

			local var_6_1 = readfile("onionPositions_" .. var_0_31 .. ".db")

			if var_6_1 ~= "" and var_6_1 ~= nil then
				writefile("onionPositions_" .. var_0_31 .. ".db", var_6_1 .. "\n" .. var_6_0 .. "|" .. var_0_8[4] .. "|" .. var_0_8[2] .. "|" .. var_0_8[3] .. "|" .. var_0_1 .. "|" .. var_0_2)
			else
				writefile("onionPositions_" .. var_0_31 .. ".db", var_6_0 .. "|" .. var_0_8[4] .. "|" .. var_0_8[2] .. "|" .. var_0_8[3] .. "|" .. var_0_1 .. "|" .. var_0_2)
			end

			var_0_33()

			var_0_8[2], var_0_8[3], var_0_8[4] = 0, 0, 0
		else
			var_0_8[1] = true
			var_0_8[2], var_0_8[3], var_0_8[4] = var_0_1, var_0_2, var_0_3
		end
	end
end

local function var_0_36()
	if ui.get(var_0_21) and var_0_0 ~= nil then
		client.color_log(66, 164, 245, "playerX: " .. var_0_1 .. " playerY: " .. var_0_2 .. " playerZ: " .. var_0_3 .. " Player Ceiling: " .. var_0_4 .. "\n")

		for iter_7_0 = 0, 1 do
			local var_7_0 = client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1, var_0_2 - 100 + 200 * iter_7_0, var_0_3)
			local var_7_1 = client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1 - 100 + 200 * iter_7_0, var_0_2, var_0_3)
			local var_7_2, var_7_3 = renderer.world_to_screen(var_0_1 + (-100 + 200 * iter_7_0) * var_7_1, var_0_2, var_0_3)
			local var_7_4, var_7_5 = renderer.world_to_screen(var_0_1, var_0_2 + (-100 + 200 * iter_7_0) * var_7_0, var_0_3)

			if var_7_0 ~= 1 then
				client.color_log(0, 255, 0, "Hit on the Y Axis, yAxis: " .. var_7_0 .. ", Original playerY: " .. var_0_2 - 100 + 200 * iter_7_0 .. ", playerY Hit: " .. var_0_2 + (-100 + 200 * iter_7_0) * var_7_0 .. ", i: " .. iter_7_0 .. "\n")
			else
				client.color_log(255, 0, 0, "No hit on the Y Axis, i: " .. iter_7_0 .. "\n")
			end

			if var_7_1 ~= 1 then
				client.color_log(0, 255, 0, "Hit on the X Axis, xAxis: " .. var_7_1 .. ", Original playerX: " .. var_0_1 - 100 + 200 * iter_7_0 .. ", playerX Hit: " .. var_0_1 + (-100 + 200 * iter_7_0) * var_7_1 .. ", i: " .. iter_7_0 .. "\n")
			else
				client.color_log(255, 0, 0, "No hit on the X Axis, i: " .. iter_7_0 .. "\n")
			end
		end
	end
end

local function var_0_37()
	if ui.get(var_0_21) and var_0_13 then
		local var_8_0

		for iter_8_0 = 1, #var_0_16 do
			local var_8_1
			local var_8_2
			local var_8_3
			local var_8_4
			local var_8_5 = ui.get(var_0_17[iter_8_0][1]) and "true" or "false"
			local var_8_6 = ui.get(var_0_17[iter_8_0][4]) and "true" or "false"
			local var_8_7 = ui.get(var_0_17[iter_8_0][5]) and "true" or "false"
			local var_8_8 = ui.get(var_0_17[iter_8_0][6]) and "true" or "false"

			if var_8_0 == nil then
				var_8_0 = var_8_5 .. "|" .. ui.get(var_0_17[iter_8_0][2]) .. "|" .. ui.get(var_0_17[iter_8_0][3]) .. "|" .. var_8_6 .. "|" .. var_8_7 .. "|" .. var_8_8
			else
				var_8_0 = var_8_0 .. "\n" .. var_8_5 .. "|" .. ui.get(var_0_17[iter_8_0][2]) .. "|" .. ui.get(var_0_17[iter_8_0][3]) .. "|" .. var_8_6 .. "|" .. var_8_7 .. "|" .. var_8_8
			end
		end

		local var_8_9 = readfile("onionSettings.db")
		local var_8_10 = var_0_29(var_8_9, "\n")
		local var_8_11
		local var_8_12 = false
		local var_8_13 = 0

		for iter_8_1 = 1, #var_8_10 do
			if string.find(var_8_10[iter_8_1], var_0_15) then
				var_8_12 = true
				var_8_13 = iter_8_1
			end
		end

		if var_8_12 then
			for iter_8_2 = 1, 6 do
				table.remove(var_8_10, var_8_13)
			end
		end

		for iter_8_3 = 1, #var_8_10 do
			if var_8_11 == nil or var_8_11 == "" then
				var_8_11 = var_8_10[iter_8_3]
			else
				var_8_11 = var_8_11 .. "\n" .. var_8_10[iter_8_3]
			end
		end

		client.color_log(255, 255, 255, var_0_15)

		if var_8_11 ~= nil then
			writefile("onionSettings.db", var_8_11)
		end

		client.color_log(255, 255, 255, "Mainframe 1/2")

		local var_8_14 = readfile("onionSettings.db")

		if var_8_14 ~= nil and var_8_14 ~= "" then
			client.color_log(255, 255, 255, "Mainframe 1")
			writefile("onionSettings.db", var_8_14 .. "\nmap: " .. var_0_15 .. "\n" .. var_8_0)
		else
			client.color_log(255, 255, 255, "Mainframe 2")
			writefile("onionSettings.db", "map: " .. var_0_15 .. "\n" .. var_8_0)
		end
	else
		client.color_log(255, 255, 255, "Please step inside a location to save settings.")
	end
end

var_0_33()

if var_0_19 ~= nil and #var_0_19 ~= 0 then
	var_0_12 = ui.new_combobox("LUA", "B", "Location", var_0_19)
end

local var_0_38 = ui.new_button("LUA", "B", "Log Location", var_0_36)
local var_0_39 = ui.new_button("LUA", "B", "Create Position", var_0_35)

if var_0_19 ~= nil and #var_0_19 ~= 0 then
	local var_0_40 = ui.new_button("LUA", "B", "Delete Position", var_0_34)
end

local var_0_41 = ui.new_button("LUA", "B", "Update Settings", var_0_33)
local var_0_42 = ui.new_label("LUA", "B", "-+-+-+-+ [ Aim -  ] +-+-+-+-")

if var_0_11 ~= nil then
	ui.set(var_0_42, "LUA", "B", "-+-+-+-+ [ Aim - " .. var_0_11 .. " ] +-+-+-+-")
end

local var_0_43 = ui.new_button("LUA", "B", "Save Settings", var_0_37)

for iter_0_0 = 1, #var_0_16 do
	table.insert(var_0_17, {
		ui.new_checkbox("LUA", "B", "Double Tap"),
		ui.new_slider("LUA", "B", "Minimum hit chance", 0, 100, 10),
		ui.new_slider("LUA", "B", "Minimum Damage", 0, 126, 10),
		ui.new_checkbox("LUA", "B", "Force Safe-Point on Limbs"),
		ui.new_checkbox("LUA", "B", "Prefer Safe-Point"),
		ui.new_checkbox("LUA", "B", "Override Aimbot")
	})
end

ui.new_label("LUA", "B", "-+-+-+-+ [ Onion's Position LUA ] +-+-+-+-")

local var_0_44 = false
local var_0_45

client.set_event_callback("paint", function()
	var_0_0 = entity.get_local_player()

	local var_9_0 = var_0_29(globals.mapname(), "/")

	var_0_31 = var_9_0[#var_9_0]

	for iter_9_0 = 1, #var_0_26 do
		ui.set_visible(var_0_26[iter_9_0], ui.get(var_0_25))
	end

	if ui.get(var_0_21) and var_0_0 ~= nil and entity.is_alive(var_0_0) then
		var_0_11 = entity.get_classname(entity.get_player_weapon(var_0_0))
		var_0_1, var_0_2, var_0_3 = entity.get_origin(var_0_0)
		var_0_5, var_0_6 = renderer.world_to_screen(var_0_1, var_0_2, var_0_3)
		var_0_4 = var_0_3 + 100000 * client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1, var_0_2, var_0_3 + 100000)

		ui.set(var_0_42, "-+-+-+-+ [ Aim - " .. var_0_11 .. " ] +-+-+-+-")

		for iter_9_1 = 1, #var_0_16 do
			if var_0_11 ~= var_0_16[iter_9_1][1] then
				for iter_9_2 = 1, #var_0_17[iter_9_1] do
					ui.set_visible(var_0_17[iter_9_1][iter_9_2], false)
				end
			else
				for iter_9_3 = 1, #var_0_17[iter_9_1] do
					ui.set_visible(var_0_17[iter_9_1][iter_9_3], true)
				end
			end
		end

		if var_0_8[1] then
			p, pp = renderer.world_to_screen(var_0_8[2], var_0_8[3], var_0_8[4])
			c, cc = renderer.world_to_screen(var_0_1, var_0_8[3], var_0_8[4])
			d, dd = renderer.world_to_screen(var_0_8[2], var_0_2, var_0_8[4])
			k, kk = renderer.world_to_screen(var_0_1, var_0_2, var_0_8[4])

			renderer.line(p, pp, c, cc, 255, 255, 255, 255)
			renderer.line(p, pp, d, dd, 255, 255, 255, 255)
			renderer.line(k, kk, c, cc, 255, 255, 255, 255)
			renderer.line(k, kk, d, dd, 255, 255, 255, 255)
		end

		if ui.get(var_0_23) then
			for iter_9_4 = 0, 1 do
				local var_9_1 = client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1, var_0_2 - 100 + 200 * iter_9_4, var_0_3)
				local var_9_2 = client.trace_line(var_0_0, var_0_1, var_0_2, var_0_3, var_0_1 - 100 + 200 * iter_9_4, var_0_2, var_0_3)
				local var_9_3, var_9_4 = renderer.world_to_screen(var_0_1 + (-100 + 200 * iter_9_4) * var_9_2, var_0_2, var_0_3)
				local var_9_5, var_9_6 = renderer.world_to_screen(var_0_1, var_0_2 + (-100 + 200 * iter_9_4) * var_9_1, var_0_3)

				renderer.line(var_0_5, var_0_6, var_9_5, var_9_6, 255, 255, 255, 255)
				renderer.line(var_0_5, var_0_6, var_9_3, var_9_4, 255, 255, 255, 255)
			end

			local var_9_7, var_9_8 = renderer.world_to_screen(var_0_1, var_0_2, var_0_4)

			renderer.line(var_0_5, var_0_6, var_9_7, var_9_8, 255, 255, 255, 255)
		end

		var_0_13 = false

		for iter_9_5 = 1, #var_0_9 do
			if var_0_28(var_0_9[iter_9_5][3][1], var_0_9[iter_9_5][4][1], var_0_9[iter_9_5][3][2], var_0_9[iter_9_5][4][2], var_0_1, var_0_2) then
				var_0_13 = true

				if var_0_15 ~= var_0_9[iter_9_5][1] then
					var_0_15 = var_0_9[iter_9_5][1]

					var_0_33()
				end

				for iter_9_6 = 1, #var_0_16 do
					if var_0_11 == var_0_16[iter_9_6][1] and ui.get(var_0_17[iter_9_6][6]) then
						if not ui.get(var_0_22) then
							ui.set(var_0_10.dt, ui.get(var_0_17[iter_9_6][1]))
						end

						ui.set(var_0_10.hitchance, ui.get(var_0_17[iter_9_6][2]))
						ui.set(var_0_10.mindamage, ui.get(var_0_17[iter_9_6][3]))
						ui.set(var_0_10.limbsafe, ui.get(var_0_17[iter_9_6][4]))
						ui.set(var_0_10.prefersafe, ui.get(var_0_17[iter_9_6][5]))
					end
				end

				if not var_0_44 then
					var_0_44 = true
					var_0_45 = iter_9_5
				end

				if var_0_18 and var_0_11 ~= "CWeaponAWP" and var_0_11 ~= "CWeaponSSG08" and ui.get(var_0_22) then
					if var_0_20 then
						ui.set(var_0_10.dt, false)
					else
						ui.set(var_0_10.dt, true)
					end
				end

				trX, trY = renderer.world_to_screen(var_0_9[iter_9_5][3][1], var_0_9[iter_9_5][3][2], var_0_9[iter_9_5][2])
				tlX, tlY = renderer.world_to_screen(var_0_9[iter_9_5][3][1], var_0_9[iter_9_5][4][2], var_0_9[iter_9_5][2])
				blX, blY = renderer.world_to_screen(var_0_9[iter_9_5][4][1], var_0_9[iter_9_5][3][2], var_0_9[iter_9_5][2])
				brX, brY = renderer.world_to_screen(var_0_9[iter_9_5][4][1], var_0_9[iter_9_5][4][2], var_0_9[iter_9_5][2])

				if ui.get(var_0_26[3]) and ui.get(var_0_25) then
					renderer.triangle(tlX, tlY, brX, brY, blX, blY, ui.get(var_0_26[4]))
					renderer.triangle(tlX, tlY, trX, trY, blX, blY, ui.get(var_0_26[4]))
				else
					renderer.triangle(tlX, tlY, brX, brY, blX, blY, 255, 255, 255, 150)
					renderer.triangle(tlX, tlY, trX, trY, blX, blY, 255, 255, 255, 150)
				end
			else
				if (not var_0_44 or iter_9_5 == var_0_45) and var_0_18 and var_0_11 ~= "CWeaponAWP" and var_0_11 ~= "CWeaponSSG08" and ui.get(var_0_22) then
					ui.set(var_0_10.dt, true)

					var_0_20 = false
					var_0_44 = false
					var_0_45 = nil
				end

				if math.sqrt((var_0_1 - var_0_9[iter_9_5][4][1])^2 + (var_0_2 - var_0_9[iter_9_5][4][2])^2) <= ui.get(var_0_24) or math.sqrt((var_0_1 - var_0_9[iter_9_5][3][1])^2 + (var_0_2 - var_0_9[iter_9_5][3][2])^2) <= ui.get(var_0_24) then
					trX, trY = renderer.world_to_screen(var_0_9[iter_9_5][3][1], var_0_9[iter_9_5][3][2], var_0_9[iter_9_5][2])
					tlX, tlY = renderer.world_to_screen(var_0_9[iter_9_5][3][1], var_0_9[iter_9_5][4][2], var_0_9[iter_9_5][2])
					blX, blY = renderer.world_to_screen(var_0_9[iter_9_5][4][1], var_0_9[iter_9_5][3][2], var_0_9[iter_9_5][2])
					brX, brY = renderer.world_to_screen(var_0_9[iter_9_5][4][1], var_0_9[iter_9_5][4][2], var_0_9[iter_9_5][2])

					if ui.get(var_0_26[1]) and ui.get(var_0_25) then
						renderer.triangle(tlX, tlY, brX, brY, blX, blY, ui.get(var_0_26[2]))
						renderer.triangle(tlX, tlY, trX, trY, blX, blY, ui.get(var_0_26[2]))
					else
						renderer.triangle(tlX, tlY, brX, brY, blX, blY, 255, 255, 255, 150)
						renderer.triangle(tlX, tlY, trX, trY, blX, blY, 255, 255, 255, 150)
					end
				end
			end
		end
	else
		for iter_9_7 = 1, #var_0_17 do
			for iter_9_8 = 1, #var_0_17[iter_9_7] do
				ui.set_visible(var_0_17[iter_9_7][iter_9_8], false)
			end
		end
	end
end)
client.set_event_callback("weapon_fire", function(arg_10_0)
	if client.userid_to_entindex(arg_10_0.userid) == var_0_0 then
		var_0_20 = true
	end
end)
