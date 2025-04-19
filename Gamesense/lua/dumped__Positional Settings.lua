slot1, slot2, slot3, slot4 = nil

if entity.get_local_player() ~= nil then
	slot1, slot2, slot3 = entity.get_origin(slot0)
	slot4 = slot3 + 100000 * client.trace_line(slot0, slot1, slot2, slot3, slot1, slot2, slot3 + 100000)
end

slot5, slot6 = renderer.world_to_screen(slot1, slot2, slot3)
slot7 = 250
slot8 = {
	false,
	0,
	0,
	0
}
slot9 = {}
slot10 = {}
slot11 = nil

if slot0 ~= nil then
	slot11 = entity.get_classname(entity.get_player_weapon(slot0))
end

slot12 = nil
slot13 = false
slot14 = {}
slot15 = ""
slot10.dt = ui.reference("RAGE", "Other", "Double Tap")
slot10.hitchance = ui.reference("RAGE", "Aimbot", "Minimum Hit Chance")
slot10.mindamage = ui.reference("RAGE", "Aimbot", "Minimum Damage")
slot10.limbsafe = ui.reference("RAGE", "Aimbot", "Force Safe Point on Limbs")
slot10.prefersafe = ui.reference("RAGE", "Aimbot", "Prefer Safe Point")
slot16 = {
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
slot17 = {}

ui.new_label("LUA", "B", "-+-+-+-+ [ Onion's Position LUA ] +-+-+-+-")

slot18 = false
slot19 = {}

if ui.get(slot10.dt) then
	slot18 = true
end

slot20 = false
slot21 = ui.new_checkbox("LUA", "B", "Enabled")
slot22 = ui.new_checkbox("LUA", "B", "Disable Recharge in Region")
slot23 = ui.new_checkbox("LUA", "B", "Debug Lines")
slot24 = ui.new_slider("LUA", "B", "Draw Distance", 5, 5000, 250)
slot25 = ui.new_checkbox("LUA", "B", "Custom Colors")
slot26 = {
	ui.new_checkbox("LUA", "B", "Draw Color"),
	ui.new_color_picker("LUA", "B", "Draw Color", 3, 136, 252, 100),
	ui.new_checkbox("LUA", "B", "Hover Color"),
	ui.new_color_picker("LUA", "B", "Hover Color", 252, 198, 3, 100)
}
slot27 = ui.new_textbox("LUA", "B", "Position Name")

function slot28(slot0, slot1, slot2, slot3, slot4, slot5)
	for slot10 = 1, #{
		tonumber(slot0),
		tonumber(slot1),
		tonumber(slot4),
		tonumber(slot2),
		tonumber(slot3),
		tonumber(slot5)
	} do
		if slot6[slot10] > 0 then
			slot6[slot10] = slot6[slot10] + 100000
		end

		slot6[slot10] = math.abs(slot6[slot10])
	end

	if slot6[2] < slot6[1] then
		if slot6[1] < slot6[3] or slot6[3] < slot6[2] then
			return false
		end
	elseif slot6[3] < slot6[1] or slot6[2] < slot6[3] then
		return false
	end

	if slot6[5] < slot6[4] then
		if slot6[4] < slot6[6] or slot6[6] < slot6[5] then
			return false
		end
	elseif slot6[6] < slot6[4] or slot6[5] < slot6[6] then
		return false
	end

	return true
end

slot30 = function (slot0, slot1)
	if slot1 == nil then
		slot1 = "%s"
	end

	slot2 = {}

	if slot0 ~= nil then
		slot6 = slot1

		for slot6 in string.gmatch(slot0, "([^" .. slot6 .. "]+)") do
			table.insert(slot2, slot6)
		end
	end

	return slot2
end(globals.mapname(), "/")
slot31 = slot30[#slot30]

function slot32(slot0)
	if uv0 ~= nil and slot0 ~= nil then
		for slot5 = 1, #uv1(slot0, "\n") do
			if uv0[slot5] ~= nil and uv0[slot5][1] ~= nil then
				slot6, slot7, slot8, slot9 = nil

				ui.set(uv0[slot5][1], string.find(uv1(slot1[slot5], "|")[1], "true") and true or false)
				ui.set(uv0[slot5][2], tonumber(slot10[2]))
				ui.set(uv0[slot5][3], tonumber(slot10[3]))
				ui.set(uv0[slot5][4], string.find(slot10[4], "true") and true or false)
				ui.set(uv0[slot5][5], string.find(slot10[5], "true") and true or false)
				ui.set(uv0[slot5][6], string.find(slot10[6], "true") and true or false)
			end
		end
	end
end

function slot34()
	name = ui.get(uv0)
	slot1 = nil

	if readfile("onionPositions_" .. uv1 .. ".db") ~= nil and slot0 ~= "" then
		for slot6 = 1, #uv2(slot0, "\n") do
			if not string.find(slot2[slot6], name) then
				slot1 = slot1 ~= nil and slot1 + "\n" + slot2[slot6] or slot2[slot6]
			end
		end

		writefile("onionPositions_" .. uv1 .. ".db", slot1)
	end
end

function slot35()
	if ui.get(uv0) and uv1 ~= nil then
		if uv2[1] then
			uv2[1] = false
			slot0 = "Name"

			if ui.get(uv3) ~= nil and ui.get(uv3) ~= "" then
				slot0 = ui.get(uv3)
			end

			if readfile("onionPositions_" .. uv4 .. ".db") ~= "" and slot1 ~= nil then
				writefile("onionPositions_" .. uv4 .. ".db", slot1 .. "\n" .. slot0 .. "|" .. uv2[4] .. "|" .. uv2[2] .. "|" .. uv2[3] .. "|" .. uv5 .. "|" .. uv6)
			else
				writefile("onionPositions_" .. uv4 .. ".db", slot0 .. "|" .. uv2[4] .. "|" .. uv2[2] .. "|" .. uv2[3] .. "|" .. uv5 .. "|" .. uv6)
			end

			uv7()

			uv2[4] = 0
			uv2[3] = 0
			uv2[2] = 0
		else
			uv2[1] = true
			uv2[4] = uv8
			uv2[3] = uv6
			uv2[2] = uv5
		end
	end
end

function slot36()
	if ui.get(uv0) and uv1 ~= nil then
		slot3 = 245

		client.color_log(66, 164, slot3, "playerX: " .. uv2 .. " playerY: " .. uv3 .. " playerZ: " .. uv4 .. " Player Ceiling: " .. uv5 .. "\n")

		for slot3 = 0, 1 do
			slot4 = client.trace_line(uv1, uv2, uv3, uv4, uv2, uv3 - 100 + 200 * slot3, uv4)
			slot6, slot7 = renderer.world_to_screen(uv2 + (-100 + 200 * slot3) * client.trace_line(uv1, uv2, uv3, uv4, uv2 - 100 + 200 * slot3, uv3, uv4), uv3, uv4)
			slot8, slot9 = renderer.world_to_screen(uv2, uv3 + (-100 + 200 * slot3) * slot4, uv4)

			if slot4 ~= 1 then
				client.color_log(0, 255, 0, "Hit on the Y Axis, yAxis: " .. slot4 .. ", Original playerY: " .. uv3 - 100 + 200 * slot3 .. ", playerY Hit: " .. uv3 + (-100 + 200 * slot3) * slot4 .. ", i: " .. slot3 .. "\n")
			else
				client.color_log(255, 0, 0, "No hit on the Y Axis, i: " .. slot3 .. "\n")
			end

			if slot5 ~= 1 then
				client.color_log(0, 255, 0, "Hit on the X Axis, xAxis: " .. slot5 .. ", Original playerX: " .. uv2 - 100 + 200 * slot3 .. ", playerX Hit: " .. uv2 + (-100 + 200 * slot3) * slot5 .. ", i: " .. slot3 .. "\n")
			else
				client.color_log(255, 0, 0, "No hit on the X Axis, i: " .. slot3 .. "\n")
			end
		end
	end
end

function slot37()
	if ui.get(uv0) and uv1 then
		for slot4 = 1, #uv2 do
			slot5, slot6, slot7, slot8 = nil
			slot5 = ui.get(uv3[slot4][1]) and "true" or "false"
			slot6 = ui.get(uv3[slot4][4]) and "true" or "false"
			slot7 = ui.get(uv3[slot4][5]) and "true" or "false"
			slot8 = ui.get(uv3[slot4][6]) and "true" or "false"
			slot0 = nil == nil and slot5 .. "|" .. ui.get(uv3[slot4][2]) .. "|" .. ui.get(uv3[slot4][3]) .. "|" .. slot6 .. "|" .. slot7 .. "|" .. slot8 or slot5 .. "|" .. ui.get(uv3[slot4][2]) .. "|" .. ui.get(uv3[slot4][3]) .. "|" .. slot6 .. "|" .. slot7 .. "|" .. slot8 .. "\n" .. slot5 .. "|" .. ui.get(uv3[slot4][2]) .. "|" .. ui.get(uv3[slot4][3]) .. "|" .. slot6 .. "|" .. slot7 .. "|" .. slot8
		end

		slot3 = nil
		slot4 = false
		slot5 = 0

		for slot9 = 1, #uv4(readfile("onionSettings.db"), "\n") do
			if string.find(slot2[slot9], uv5) then
				slot4 = true
				slot5 = slot9
			end
		end

		if slot4 then
			for slot9 = 1, 6 do
				table.remove(slot2, slot5)
			end
		end

		for slot9 = 1, #slot2 do
			slot3 = (slot3 ~= nil and slot3 ~= "" or slot2[slot9]) and slot2[slot9] .. "\n" .. slot2[slot9]
		end

		client.color_log(255, 255, 255, uv5)

		if slot3 ~= nil then
			writefile("onionSettings.db", slot3)
		end

		client.color_log(255, 255, 255, "Mainframe 1/2")

		if readfile("onionSettings.db") ~= nil and slot6 ~= "" then
			client.color_log(255, 255, 255, "Mainframe 1")
			writefile("onionSettings.db", slot6 .. "\nmap: " .. uv5 .. "\n" .. slot0)
		else
			client.color_log(255, 255, 255, "Mainframe 2")
			writefile("onionSettings.db", "map: " .. uv5 .. "\n" .. slot0)
		end
	else
		client.color_log(255, 255, 255, "Please step inside a location to save settings.")
	end
end

function ()
	if uv0 ~= nil then
		uv1 = {}
		uv2 = {}
		slot0 = readfile("onionPositions_" .. uv3 .. ".db")
		uv4 = {}

		for slot6 = 1, #uv5(readfile("onionSettings.db"), "\n") do
			if string.find(slot2[slot6], "map: ") then
				table.insert(uv4, {
					slot2[slot6 + 1] .. "\n" .. slot2[slot6 + 2] .. "\n" .. slot2[slot6 + 3] .. "\n" .. slot2[slot6 + 4] .. "\n" .. slot2[slot6 + 5],
					string.gsub(slot2[slot6], "map: ", "")
				})
			end
		end

		if #uv4 ~= 0 then
			for slot6 = 1, #uv4 do
				if string.find(uv4[slot6][2], uv6) then
					uv7(uv4[slot6][1])
				end
			end
		end

		if slot0 ~= nil and slot0 ~= "" then
			for slot7 = 1, #uv5(slot0, "\n") do
				if #uv5(slot3[slot7], "|") == 6 then
					table.insert(uv1, {
						slot8[1],
						slot8[2],
						{
							slot8[3],
							slot8[4]
						},
						{
							slot8[5],
							slot8[6]
						}
					})
					table.insert(uv2, slot8[1])
				else
					table.insert(uv1, {
						"Name",
						slot8[1],
						{
							slot8[2],
							slot8[3]
						},
						{
							slot8[4],
							slot8[5]
						}
					})
					table.insert(uv2, "Name")
				end
			end
		end
	end
end()

if slot19 ~= nil and #slot19 ~= 0 then
	slot12 = ui.new_combobox("LUA", "B", "Location", slot19)
end

slot38 = ui.new_button("LUA", "B", "Log Location", slot36)
slot39 = ui.new_button("LUA", "B", "Create Position", slot35)

if slot19 ~= nil and #slot19 ~= 0 then
	slot40 = ui.new_button("LUA", "B", "Delete Position", slot34)
end

slot40 = ui.new_button("LUA", "B", "Update Settings", slot33)

if slot11 ~= nil then
	ui.set(ui.new_label("LUA", "B", "-+-+-+-+ [ Aim -  ] +-+-+-+-"), "LUA", "B", "-+-+-+-+ [ Aim - " .. slot11 .. " ] +-+-+-+-")
end

slot46 = slot37
slot42 = ui.new_button("LUA", "B", "Save Settings", slot46)

for slot46 = 1, #slot16 do
	table.insert(slot17, {
		ui.new_checkbox("LUA", "B", "Double Tap"),
		ui.new_slider("LUA", "B", "Minimum hit chance", 0, 100, 10),
		ui.new_slider("LUA", "B", "Minimum Damage", 0, 126, 10),
		ui.new_checkbox("LUA", "B", "Force Safe-Point on Limbs"),
		ui.new_checkbox("LUA", "B", "Prefer Safe-Point"),
		ui.new_checkbox("LUA", "B", "Override Aimbot")
	})
end

ui.new_label("LUA", "B", "-+-+-+-+ [ Onion's Position LUA ] +-+-+-+-")

slot43 = false
slot44 = nil

client.set_event_callback("paint", function ()
	uv0 = entity.get_local_player()
	slot0 = uv1(globals.mapname(), "/")
	uv2 = slot0[#slot0]

	for slot4 = 1, #uv3 do
		ui.set_visible(uv3[slot4], ui.get(uv4))
	end

	if ui.get(uv5) and uv0 ~= nil and entity.is_alive(uv0) then
		uv6 = entity.get_classname(entity.get_player_weapon(uv0))
		uv7, uv8, uv9 = entity.get_origin(uv0)
		uv10, uv11 = renderer.world_to_screen(uv7, uv8, uv9)
		uv12 = uv9 + 100000 * client.trace_line(uv0, uv7, uv8, uv9, uv7, uv8, uv9 + 100000)
		slot4 = uv6

		ui.set(uv13, "-+-+-+-+ [ Aim - " .. slot4 .. " ] +-+-+-+-")

		for slot4 = 1, #uv14 do
			if uv6 ~= uv14[slot4][1] then
				for slot8 = 1, #uv15[slot4] do
					ui.set_visible(uv15[slot4][slot8], false)
				end
			else
				for slot8 = 1, #uv15[slot4] do
					ui.set_visible(uv15[slot4][slot8], true)
				end
			end
		end

		if uv16[1] then
			p, pp = renderer.world_to_screen(uv16[2], uv16[3], uv16[4])
			c, cc = renderer.world_to_screen(uv7, uv16[3], uv16[4])
			d, dd = renderer.world_to_screen(uv16[2], uv8, uv16[4])
			k, kk = renderer.world_to_screen(uv7, uv8, uv16[4])

			renderer.line(p, pp, c, cc, 255, 255, 255, 255)
			renderer.line(p, pp, d, dd, 255, 255, 255, 255)
			renderer.line(k, kk, c, cc, 255, 255, 255, 255)
			renderer.line(k, kk, d, dd, 255, 255, 255, 255)
		end

		if ui.get(uv17) then
			for slot4 = 0, 1 do
				slot7, slot8 = renderer.world_to_screen(uv7 + (-100 + 200 * slot4) * client.trace_line(uv0, uv7, uv8, uv9, uv7 - 100 + 200 * slot4, uv8, uv9), uv8, uv9)
				slot9, slot10 = renderer.world_to_screen(uv7, uv8 + (-100 + 200 * slot4) * client.trace_line(uv0, uv7, uv8, uv9, uv7, uv8 - 100 + 200 * slot4, uv9), uv9)

				renderer.line(uv10, uv11, slot9, slot10, 255, 255, 255, 255)
				renderer.line(uv10, uv11, slot7, slot8, 255, 255, 255, 255)
			end

			slot1, slot2 = renderer.world_to_screen(uv7, uv8, uv12)

			renderer.line(uv10, uv11, slot1, slot2, 255, 255, 255, 255)
		end

		uv18 = false

		for slot4 = 1, #uv19 do
			if uv20(uv19[slot4][3][1], uv19[slot4][4][1], uv19[slot4][3][2], uv19[slot4][4][2], uv7, uv8) then
				uv18 = true

				if uv21 ~= uv19[slot4][1] then
					uv21 = uv19[slot4][1]

					uv22()
				end

				for slot8 = 1, #uv14 do
					if uv6 == uv14[slot8][1] and ui.get(uv15[slot8][6]) then
						if not ui.get(uv23) then
							ui.set(uv24.dt, ui.get(uv15[slot8][1]))
						end

						ui.set(uv24.hitchance, ui.get(uv15[slot8][2]))
						ui.set(uv24.mindamage, ui.get(uv15[slot8][3]))
						ui.set(uv24.limbsafe, ui.get(uv15[slot8][4]))
						ui.set(uv24.prefersafe, ui.get(uv15[slot8][5]))
					end
				end

				if not uv25 then
					uv25 = true
					uv26 = slot4
				end

				if uv27 and uv6 ~= "CWeaponAWP" and uv6 ~= "CWeaponSSG08" and ui.get(uv23) then
					if uv28 then
						ui.set(uv24.dt, false)
					else
						ui.set(uv24.dt, true)
					end
				end

				trX, trY = renderer.world_to_screen(uv19[slot4][3][1], uv19[slot4][3][2], uv19[slot4][2])
				tlX, tlY = renderer.world_to_screen(uv19[slot4][3][1], uv19[slot4][4][2], uv19[slot4][2])
				blX, blY = renderer.world_to_screen(uv19[slot4][4][1], uv19[slot4][3][2], uv19[slot4][2])
				brX, brY = renderer.world_to_screen(uv19[slot4][4][1], uv19[slot4][4][2], uv19[slot4][2])

				if ui.get(uv3[3]) and ui.get(uv4) then
					renderer.triangle(tlX, tlY, brX, brY, blX, blY, ui.get(uv3[4]))
					renderer.triangle(tlX, tlY, trX, trY, blX, blY, ui.get(uv3[4]))
				else
					renderer.triangle(tlX, tlY, brX, brY, blX, blY, 255, 255, 255, 150)
					renderer.triangle(tlX, tlY, trX, trY, blX, blY, 255, 255, 255, 150)
				end
			else
				if (not uv25 or slot4 == uv26) and uv27 and uv6 ~= "CWeaponAWP" and uv6 ~= "CWeaponSSG08" and ui.get(uv23) then
					ui.set(uv24.dt, true)

					uv28 = false
					uv25 = false
					uv26 = nil
				end

				if math.sqrt((uv7 - uv19[slot4][4][1])^2 + (uv8 - uv19[slot4][4][2])^2) <= ui.get(uv29) or math.sqrt((uv7 - uv19[slot4][3][1])^2 + (uv8 - uv19[slot4][3][2])^2) <= ui.get(uv29) then
					trX, trY = renderer.world_to_screen(uv19[slot4][3][1], uv19[slot4][3][2], uv19[slot4][2])
					tlX, tlY = renderer.world_to_screen(uv19[slot4][3][1], uv19[slot4][4][2], uv19[slot4][2])
					blX, blY = renderer.world_to_screen(uv19[slot4][4][1], uv19[slot4][3][2], uv19[slot4][2])
					brX, brY = renderer.world_to_screen(uv19[slot4][4][1], uv19[slot4][4][2], uv19[slot4][2])

					if ui.get(uv3[1]) and ui.get(uv4) then
						renderer.triangle(tlX, tlY, brX, brY, blX, blY, ui.get(uv3[2]))
						renderer.triangle(tlX, tlY, trX, trY, blX, blY, ui.get(uv3[2]))
					else
						renderer.triangle(tlX, tlY, brX, brY, blX, blY, 255, 255, 255, 150)
						renderer.triangle(tlX, tlY, trX, trY, blX, blY, 255, 255, 255, 150)
					end
				end
			end
		end
	else
		for slot4 = 1, #uv15 do
			for slot8 = 1, #uv15[slot4] do
				ui.set_visible(uv15[slot4][slot8], false)
			end
		end
	end
end)
client.set_event_callback("weapon_fire", function (slot0)
	if client.userid_to_entindex(slot0.userid) == uv0 then
		uv1 = true
	end
end)
