slot0 = require("vector")
slot1 = require("gamesense/images")
slot4 = {
	ent = {
		get_local = entity.get_local_player,
		get_prop = entity.get_prop,
		get_weapon = entity.get_player_weapon,
		is_alive = entity.is_alive,
		is_enemy = entity.is_enemy,
		get_all = entity.get_all,
		get_classname = entity.get_classname
	},
	render = {
		polygon = renderer.triangle,
		line = renderer.line,
		circle = renderer.circle,
		circle_out = renderer.circle_outline,
		rectangle = renderer.rectangle,
		gradient = renderer.gradient,
		measure = renderer.measure_text,
		text = renderer.text,
		world_to_screen = renderer.world_to_screen
	},
	math = {
		rad = math.rad,
		pi = math.pi,
		cos = math.cos,
		sin = math.sin,
		min = math.min,
		max = math.max
	},
	data = {
		read = database.read,
		write = database.write
	},
	globals = {
		tickcount = globals.tickcount,
		frametime = globals.frametime,
		realtime = globals.realtime
	},
	client = {
		screen_size = client.screen_size,
		set_event_callback = client.set_event_callback,
		userid_to_idx = client.userid_to_entindex,
		color_log = client.color_log,
		find_sig = client.find_signature,
		key_state = client.key_state,
		exec = client.exec
	},
	table = {
		insert = table.insert,
		remove = table.remove
	},
	ffi = {
		cast = require("ffi").cast
	}
}
slot6, slot7 = slot4.client.screen_size()
slot8 = {}
slot9 = {}
slot10 = {}
slot11 = 0
slot12 = 0
slot13 = 0
slot14 = 0
slot15 = 0
slot16 = 0
slot17 = 0
slot18 = {
	missed = 0
}
slot19 = globals.realtime() + 600
slot20 = {}
slot21 = slot4.data.read("rpg/kill_times") or {}
slot22 = ""
slot24 = {
	{
		"Kill someone with a knife",
		"kill_knife",
		{
			300,
			400
		},
		"rpg/quests/3/kill_knife",
		slot4.data.read("rpg/quests/3/kill_knife") or 0
	},
	{
		"Kill someone without missing a single shot",
		"kill_miss",
		{
			400,
			1000
		},
		"rpg/quests/3/kill_miss",
		slot4.data.read("rpg/quests/3/kill_miss") or 0
	}
}
slot25 = {
	helmet = slot1.get_weapon_icon("helmet"),
	armor = slot1.get_weapon_icon("kevlar")
}
slot26 = {
	{
		"On-shot",
		"os",
		"Helps you to not get onshotted.",
		200,
		"cheat_feature",
		{
			"aa",
			"other",
			"on shot anti-aim"
		},
		"rpg/shop/os_",
		database.read("rpg/shop/os_")
	}
}
slot27 = {
	x = slot4.data.read("rpg/hud/pos.x") or 854,
	y = slot4.data.read("rpg/hud/pos.y") or 110
}

if ({
	status = "",
	username = slot4.data.read("rpg/nickname_") or "unknown",
	avatar = slot4.data.read("rpg/avatar") or slot1.get_steam_avatar(panorama.open().MyPersonaAPI.GetXuid(), 65) or nil,
	lvl = slot4.data.read("rpg/level_") or 1,
	xp = {
		slot4.data.read("rpg/xp/current_") or 0,
		slot4.data.read("rpg/xp/needed_") or 100,
		slot4.data.read("rpg/xp/reached_") or 0,
		slot4.data.read("rpg/xp/prev_reached_") or 0
	},
	balance = slot4.data.read("rpg/balance_") or 0,
	disable_original = slot4.data.read("rpg/hud/disable_orig") or 0,
	force_weapon = slot4.data.read("rpg/hud/force_weap") or 0
}).username == "unknown" then
	slot4.client.color_log(255, 0, 0, "Please select your username. [.nick]")
end

function slot28(slot0, slot1, slot2, slot3)
	uv0.table.insert(uv1, {
		1,
		uv0.globals.tickcount(),
		{
			slot0,
			slot1,
			slot2,
			slot3
		}
	})
	uv0.client.color_log(slot0, slot1, slot2, slot3)
end

function slot29(slot0, slot1, slot2, slot3)
	slot4, slot5 = ui.mouse_position()

	return slot0 <= slot4 and slot4 <= slot0 + slot2 and slot1 <= slot5 and slot5 <= slot1 + slot3
end

function slot30(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13, slot14)
	slot15 = {
		slot0,
		slot1
	}
	slot16 = {
		y = slot18,
		x = slot17
	}
	slot17, slot18 = uv0.render.world_to_screen(slot0, slot1, slot2)
	slot20 = 25

	for slot20 = slot5, slot4 + slot5, uv0.math.min(slot20, slot3 / 5) do
		slot21 = uv0.math.rad(slot20)
		slot22 = uv1(slot3 * uv0.math.cos(slot21) + slot0, slot3 * uv0.math.sin(slot21) + slot1, slot2)
		slot24, slot25 = uv0.render.world_to_screen(slot22.x, slot22.y, slot22.z)

		if ({
			y = slot25,
			x = slot24
		}).x ~= nil and slot15.x ~= nil then
			if slot10 then
				uv0.render.polygon(slot16.x, slot16.y, slot15.x, slot15.y, slot23.x, slot23.y, slot11, slot12, slot13, slot14)
			end

			uv0.render.line(slot23.x, slot23.y, slot15.x, slot15.y, slot6, slot7, slot8, slot9)
		end

		slot15.y = slot23.y
		slot15.x = slot23.x
	end
end

function slot31(slot0, slot1, slot2, slot3)
	slot4 = uv0.math.sin(slot0)
	slot5 = uv0.math.cos(slot0)
	slot2.x = slot2.x - slot1.x
	slot2.y = slot2.y - slot1.y
	slot3.x = slot3.x - slot1.x
	slot3.y = slot3.y - slot1.y

	return slot2.x * slot5 - slot2.y * slot4 + slot1.x, slot2.x * slot4 + slot2.y * slot5 + slot1.y, slot3.x * slot5 - slot3.y * slot4 + slot1.x, slot3.x * slot4 + slot3.y * slot5 + slot1.y
end

function slot32(slot0, slot1, slot2)
	if slot0 < slot1 then
		slot3 = slot1 or slot3
	end

	if slot2 < slot3 then
		slot3 = slot2 or slot3
	end

	return slot3
end

function slot33(slot0)
	uv0.data.write("rpg/level_", uv1.lvl)
	uv0.data.write("rpg/xp/current_", uv1.xp[1])
	uv0.data.write("rpg/xp/needed_", uv1.xp[2])
	uv0.data.write("rpg/xp/reached_", uv1.xp[3])
	uv0.data.write("rpg/xp/prev_reached_", uv1.xp[4])
	uv0.data.write("rpg/balance_", uv1.balance)
	uv0.data.write("rpg/has_save_", true)
	uv2(220, 220, 220, slot0 and "Automatically saved progress." or "Successfully saved progress.")
end

function slot34()
	if uv0.data.read("rpg/has_save_") == nil or uv0.data.read("rpg/has_save_") == false or uv0.data.read("rpg/level_") == nil then
		uv0.client.color_log(255, 0, 0, "Couldn't find any save, sorry!")

		return
	end

	uv1.lvl = uv0.data.read("rpg/level_")
	uv1.xp[1] = uv0.data.read("rpg/xp/current_")
	uv1.xp[2] = uv0.data.read("rpg/xp/needed_")
	uv1.xp[3] = uv0.data.read("rpg/xp/reached_")
	uv1.xp[4] = uv0.data.read("rpg/xp/prev_reached_")
	uv1.balance = uv0.data.read("rpg/balance_")

	uv2(220, 220, 220, "Loaded latest save.")
end

function slot35(slot0)
	if slot0 then
		if uv0.data.read("rpg/has_save_") then
			uv0.data.write("rpg/level_", nil)
			uv0.data.write("rpg/xp/current_", nil)
			uv0.data.write("rpg/xp/needed_", nil)
			uv0.data.write("rpg/xp/reached_", nil)
			uv0.data.write("rpg/xp/prev_reached_", nil)
			uv0.data.write("rpg/balance_", nil)
			uv0.data.write("rpg/has_save_", false)
			uv0.client.color_log(220, 220, 220, "Successfully reset your save")
		else
			uv0.client.color_log(255, 0, 0, "Couldn't find any save to reset.")
		end
	else
		uv0.client.color_log(220, 220, 220, "Successfully reset your progress.")
	end

	uv1.lvl = 1
	uv1.xp[1] = 0
	uv1.xp[2] = 100
	uv1.xp[3] = 0
	uv1.xp[4] = 0
	uv1.balance = 0
end

function slot36(slot0, slot1, slot2)
	if slot0 == "xp" then
		uv0.xp[1] = uv0.xp[1] + slot1

		uv1.table.insert(uv2, {
			1,
			uv1.globals.tickcount(),
			slot1
		})

		if slot2 then
			uv3(true)
		end
	elseif slot0 == "level" then
		uv0.lvl = uv0.lvl + slot1

		if slot1 > 0 then
			-- Nothing
		end

		if slot2 then
			uv3(true)
		end
	elseif slot0 == "balance" then
		uv0.balance = uv0.balance + slot1

		uv1.table.insert(uv4, {
			1,
			uv1.globals.tickcount(),
			slot1
		})

		if slot2 then
			uv3(true)
		end
	end
end

function slot37(slot0)
	if slot0.reason ~= "spread" then
		uv0.missed = uv0.missed + 1
	end
end

function slot38()
	if uv0.ent.get_local() == nil then
		return
	end

	if uv1.avatar == nil or uv2 == nil then
		uv2 = uv3.MyPersonaAPI.GetXuid()
		uv1.avatar = uv4.get_steam_avatar(uv2, 65)
	end

	if uv1.disable_original == 1 then
		if cvar.cl_drawhud:get_int() == 1 then
			cvar.cl_drawhud:set_int(0)
		end

		if cvar.cl_drawhud_force_radar:get_int() <= 0 then
			cvar.cl_drawhud_force_radar:set_int(1)
		end
	elseif uv1.disable_original == 2 then
		if cvar.cl_drawhud_force_radar:get_int() >= 0 then
			cvar.cl_drawhud_force_radar:set_int(-1)
		end

		if cvar.cl_drawhud:get_int() == 1 then
			cvar.cl_drawhud:set_int(0)
		end
	else
		if cvar.cl_drawhud_force_radar:get_int() <= 0 then
			cvar.cl_drawhud_force_radar:set_int(1)
		end

		if cvar.cl_drawhud:get_int() == 0 then
			cvar.cl_drawhud:set_int(1)
		end
	end

	slot2 = {
		health = uv0.ent.get_prop(slot0, "m_iHealth"),
		armor = uv0.ent.get_prop(slot0, "m_ArmorValue"),
		has_helmet = uv0.ent.get_prop(slot0, "m_bHasHelmet"),
		text_size = {
			uv0.render.measure("", uv1.username:sub(0, 24) .. " • level " .. uv1.lvl .. " (+" .. uv1.xp[2] - uv1.xp[1] .. "xp)")
		},
		status_size = {
			uv0.render.measure("", uv1.status)
		},
		balance_size = {
			uv0.render.measure("", "$" .. uv1.balance)
		},
		is_scoped = uv0.ent.get_prop(slot0, "m_bIsScoped")
	}
	slot3 = {
		uv0.render.measure("", slot2.health .. "hp")
	}
	slot4 = uv0.math.min(1, slot2.health / 100)
	slot5 = uv0.math.min(1, uv1.xp[1] / uv1.xp[2])
	slot6 = uv0.ent.get_weapon(slot0)
	slot7 = uv4.get_weapon_icon("weapon_knife")
	slot8 = uv0.globals.frametime() * 8
	slot9 = uv1.disable_original > 0 or uv1.force_weapon > 0
	uv5.left = uv0.client.key_state(1)
	uv5.pos = {
		ui.mouse_position()
	}

	if uv0.ent.is_alive(slot0) then
		uv6 = uv0.ent.get_classname(uv0.ent.get_weapon(uv0.ent.get_local()))
	end

	if uv7 > 0 then
		if uv8.drag and not uv5.left then
			uv8.drag = false
		end

		if uv8.drag and uv5.left then
			uv8.x = uv5.pos[1] - uv8.drag_x
			uv8.y = uv5.pos[2] - uv8.drag_y

			uv0.data.write("rpg/hud/pos.x", uv8.x)
			uv0.data.write("rpg/hud/pos.y", uv8.y)
		end

		if uv9(uv8.x, uv8.y, 30, 17) and uv5.left then
			uv8.drag = true
			uv8.drag_x = uv5.pos[1] - uv8.x
			uv8.drag_y = uv5.pos[2] - uv8.y
		end

		uv0.render.rectangle(uv8.x, uv8.y, 30, 20, 30, 30, 30, 255 * uv7)
		uv0.render.text(uv8.x + 10, uv8.y, 180, 180, 180, 255 * uv7, "-", 0, "▼")
	end

	uv1.avatar:draw(uv8.x - 23, uv8.y + 32, 75, 75, 255, 255, 255, 255, true)
	uv0.render.circle(uv8.x + 15, uv8.y + 105, 0, 150, 255, 190, 13, 0, 1)
	uv0.render.text(uv8.x + 15, uv8.y + 100, 255, 255, 255, 255, "c", 0, uv1.lvl)
	uv0.render.circle_out(uv8.x + 15, uv8.y + 70, 30, 30, 30, 255, 55, 0, 1, 18)
	uv0.render.circle_out(uv8.x + 15, uv8.y + 70, 0, 150, 255, 255, 40, 90, slot5, 1)
	uv0.render.rectangle(uv8.x + 55, uv8.y + 70, slot2.status_size[1] + slot2.balance_size[1] + 40, 20, 30, 30, 30, 255)
	uv0.render.gradient(uv8.x + 55 + slot2.status_size[1] + slot2.balance_size[1] + 40, uv8.y + 70, 30, 20, 30, 30, 30, 255, 30, 30, 30, 0, true)
	uv0.render.text(uv8.x + 77, uv8.y + 73, 255, 190, 0, 255, "", 0, uv1.status)
	uv0.render.text(uv8.x + 77 + slot2.status_size[1], uv8.y + 73, 220, 220, 220, 255, "", 0, " • $" .. uv1.balance)
	uv0.render.rectangle(uv8.x - 25, uv8.y + 55, -slot3[1] - 30, 20, 30, 30, 30, 255)
	uv0.render.text(uv8.x - 45 - slot3[1], uv8.y + 58, 255 - 108 * slot4, 220 * slot4, 50 * slot4, 255, "", 0, slot2.health .. "hp")
	uv0.render.gradient(uv8.x - 25 - slot3[1] - 60, uv8.y + 55, 30, 20, 30, 30, 30, 0, 30, 30, 30, 255, true)
	uv0.render.circle_out(uv8.x + 15, uv8.y + 70, 255 - 108 * slot4, 220 * slot4, 50 * slot4, 255, 55, 355, slot4 * 0.92, 1)
	uv0.render.gradient(uv8.x + 55 + slot2.text_size[1] + 30, uv8.y + 40, 30, 25, 30, 30, 30, 255, 30, 30, 30, 0, true)
	uv0.render.rectangle(uv8.x + 55, uv8.y + 40, slot2.text_size[1] + 30, 25, 30, 30, 30, 255)
	uv0.render.text(uv8.x + 75, uv8.y + 45, 220, 220, 220, 255, "", 0, slot1)

	if uv10 > 0 then
		uv11.helmet:draw(uv8.x + 65, uv8.y + 15, 15, 25, 220, 220, 220, slot2.has_helmet == 1 and 255 * uv10 or 60 * uv10, true)
		uv11.armor:draw(uv8.x + 85, uv8.y + 20, 15, 15, 220, 220, 220, slot2.armor > 1 and 255 * uv10 or 60 * uv10, true)
	end

	if uv10 > 0 and uv0.ent.is_alive(slot0) then
		slot7 = uv4.get_weapon_icon(uv0.ent.get_prop(slot6, "m_iItemDefinitionIndex"))
		uv12 = math.max(0, uv13 - uv0.globals.tickcount()) / 20
		uv14 = math.max(0, uv15 - uv0.globals.tickcount()) / 13
		slot10 = {
			slot7:measure() + 10
		}
		slot11 = {
			uv0.ent.get_prop(slot6, "m_iClip1"),
			uv0.ent.get_prop(slot6, "m_iPrimaryReserveAmmoCount")
		}

		slot7:draw(uv16 / 2 - slot10[1] / 2, uv17 - 180, slot10[1], slot10[2], 220, 220, 220, 120 * uv10 + 135 * uv12, true)

		if uv14 > 0 then
			slot7:draw(uv16 / 2 - slot10[1] / 2, uv17 - 180, slot10[1], slot10[2], 220, 0, 0, 120 * uv14, true)
		end

		if slot11 and slot11[1] > -1 then
			uv0.render.text(uv16 / 2, uv17 - 120, 220, 220, 220, 255 * uv10, "c+", 0, slot11[1] .. " / " .. slot11[2])
		end
	end

	uv10 = uv18(uv10 + (slot9 and slot8 / 2 or -slot8), 0, 1)
	uv7 = uv18(uv7 + (ui.is_menu_open() and slot8 / 2 or -slot8), 0, 1)
end

function slot39()
	slot0 = {}
	slot1 = {}
	slot2 = {}

	for slot6 = 1, #uv0 do
		xp = uv0[slot6]
		slot7 = uv1.globals.frametime() * 8

		if xp[2] + 160 < uv1.globals.tickcount() or slot6 > 5 then
			slot0[#slot0 + 1] = 1
		end

		if xp[3] > 0 then
			uv1.render.text(uv2.x + 15, uv2.y + 20 - 15 * slot6 + 10 * xp[1], 0, 150, 255, 255 * (1 - xp[1]), "c", 0, "+" .. xp[3] .. "xp")
		else
			uv1.render.text(uv2.x + 15, uv2.y + 20 - 15 * slot6 + 10 * xp[1], 255, 40, 0, 255 * (1 - xp[1]), "c", 0, xp[3] .. "xp")
		end

		xp[1] = uv3(xp[1] + (xp[2] + 150 < uv1.globals.tickcount() and slot7 / 2 or -slot7), 0, 1)
	end

	for slot6 = 1, #uv4 do
		money = uv4[slot6]
		slot7 = uv1.globals.frametime() * 8

		if money[2] + 160 < uv1.globals.tickcount() or slot6 > 5 then
			slot1[#slot1 + 1] = 1
		end

		if money[3] > 0 then
			uv1.render.text(uv2.x + 65 + uv1.render.measure("", uv5.status .. " • $" .. uv5.balance), uv2.y + 80 + 15 * slot6 - 10 * money[1], 147, 220, 50, 255 * (1 - money[1]), "c", 0, "+$" .. money[3])
		else
			uv1.render.text(uv2.x + 65 + uv1.render.measure("", uv5.status .. " • $" .. uv5.balance), uv2.y + 80 + 15 * slot6 - 10 * money[1], 255, 40, 0, 255 * (1 - money[1]), "c", 0, "-$" .. -money[3])
		end

		money[1] = uv3(money[1] + (money[2] + 150 < uv1.globals.tickcount() and slot7 / 2 or -slot7), 0, 1)
	end

	for slot6 = 1, #uv6 do
		log = uv6[slot6]
		slot7 = uv1.globals.frametime() * 8
		slot8 = {
			width = uv1.render.measure("", log[3][4])
		}
		slot9 = uv1.globals.tickcount() < log[2] + 300 and 15 * log[1] or 0

		if log[2] + 310 < uv1.globals.tickcount() or slot6 > 15 then
			slot2[#slot2 + 1] = 1
		end

		uv1.render.circle(uv2.x + 80, uv2.y + 88 + 20 * slot6 - slot9, 30, 30, 30, 255 * (1 - log[1]), 7.8, 180, 0.5)
		uv1.render.rectangle(uv2.x + 80, uv2.y + 80 + 20 * slot6 - slot9, slot8.width, 16, 30, 30, 30, 255 * (1 - log[1]))
		uv1.render.circle(uv2.x + 80 + slot8.width, uv2.y + 88 + 20 * slot6 - slot9, 30, 30, 30, 255 * (1 - log[1]), 7.8, 0, 0.5)
		uv1.render.text(uv2.x + 80, uv2.y + 81 + 20 * slot6 - slot9, log[3][1], log[3][2], log[3][3], 255 * (1 - log[1]), "", 0, log[3][4])

		log[1] = uv3(log[1] + (log[2] + 300 < uv1.globals.tickcount() and slot7 / 2 or -slot7), 0, 1)
	end

	for slot6 = 1, #slot0 do
		uv1.table.remove(uv0, slot0[slot6])
	end

	for slot6 = 1, #slot1 do
		uv1.table.remove(uv4, slot1[slot6])
	end

	for slot6 = 1, #slot2 do
		uv1.table.remove(uv6, slot2[slot6])
	end
end

slot4.client.set_event_callback("paint", function ()
	uv0()

	if #uv1 > 0 or #uv2 > 0 or #uv3 > 0 then
		uv4()
	end

	if uv5.balance < 0 then
		uv5.balance = 0
	end

	if uv5.balance > 9999 then
		uv5.balance = 9999
	end

	if uv5.lvl == 1 and uv5.xp[1] < 0 then
		uv5.xp[1] = 0
	end
end)

function slot41()
	if uv0.xp[2] <= uv0.xp[1] then
		uv0.xp[4] = uv0.xp[3]
		uv0.xp[3] = uv0.xp[2]

		uv1("level", 1, false)

		uv0.xp[2] = uv0.lvl <= 10 and uv0.xp[2] * 2 or uv0.xp[2] * 3
		uv0.xp[1] = 0

		uv2(220, 220, 220, "Reached a new level! Level " .. uv0.lvl .. ", required xp for next level: " .. uv0.xp[2])
		uv3(true)
	end

	if uv0.xp[3] + uv0.xp[1] < uv0.xp[3] then
		uv0.xp[1] = uv0.xp[3] + uv0.xp[1]
		uv0.xp[2] = uv0.xp[3]
		uv0.xp[3] = uv0.xp[4]

		uv1("level", -1, true)
	end

	if uv0.lvl <= 5 then
		uv0.status = "Beginner"
	elseif uv0.lvl > 5 and uv0.lvl <= 15 then
		uv0.status = "Adventurer"
	elseif uv0.lvl > 15 and uv0.lvl <= 30 then
		uv0.status = "Master"
	elseif uv0.lvl > 30 and uv0.lvl <= 50 then
		uv0.status = "Legendary"
	end

	if uv4 < uv5.globals.realtime() then
		uv3(true)

		uv4 = uv5.globals.realtime() + 600
	end

	for slot3 in pairs(uv6) do
		if uv6[slot3] <= uv5.globals.realtime() then
			uv6[slot3] = nil
		end
	end
end

function slot42()
end

slot4.client.set_event_callback("setup_command", function ()
	uv0()
	uv1()
end)
slot4.client.set_event_callback("console_input", function (slot0)
	if slot0:sub(0, 1) == "." then
		if slot1:sub(2, 5):lower() == "nick" then
			uv0.username = slot1:sub(7, 32)

			database.write("rpg/nickname_", uv0.username)

			return true
		elseif slot1:sub(2, 5):lower() == "help" then
			uv1.client.color_log(255, 255, 255, "Hey,  ")
			uv1.client.color_log(255, 0, 0, uv0.username .. "  ")
			uv1.client.color_log(255, 255, 255, "Here's a list of all the current commands.")
			uv1.client.color_log(255, 190, 0, ".nick [nickname]  ")
			uv1.client.color_log(255, 255, 255, " - change your nickname.")
			uv1.client.color_log(255, 190, 0, ".stats  ")
			uv1.client.color_log(255, 255, 255, " - display your current statistics.")
			uv1.client.color_log(255, 190, 0, ".save  ")
			uv1.client.color_log(255, 255, 255, " - save your progress.")
			uv1.client.color_log(255, 190, 0, ".load  ")
			uv1.client.color_log(255, 255, 255, " - load the latest save.")
			uv1.client.color_log(255, 190, 0, ".reset [1]  ")
			uv1.client.color_log(255, 255, 255, " - reset your progress [save].")
			uv1.client.color_log(255, 190, 0, ".shop [buy/refund] [item:id]  ")
			uv1.client.color_log(255, 255, 255, " - view the shop/buy or refund an item.")
			uv1.client.color_log(255, 190, 0, ".quest [list/take] [quest:id]  ")
			uv1.client.color_log(255, 255, 255, " - view the quest list/take a quest.")
			uv1.client.color_log(255, 190, 0, ".disable_hud [int]  ")
			uv1.client.color_log(255, 255, 255, " - disable the original csgo hud.")
			uv1.client.color_log(255, 190, 0, ".force_hud [int]  ")
			uv1.client.color_log(255, 255, 255, " - force luas weapon hud.")

			return true
		elseif slot1:sub(2, 6):lower() == "stats" then
			uv1.client.color_log(255, 255, 255, uv0.username .. " • level  ")
			uv1.client.color_log(255, 190, 0, uv0.lvl .. "  ")
			uv1.client.color_log(255, 255, 255, "( ")
			uv1.client.color_log(0, 150, 255, uv0.xp[2] - uv0.xp[1] .. "xp ")
			uv1.client.color_log(255, 255, 255, ") •  ")
			uv1.client.color_log(255, 190, 0, uv0.status .. "  ")
			uv1.client.color_log(255, 255, 255, "• $" .. uv0.balance)

			return true
		elseif slot1:sub(2, 5):lower() == "save" then
			uv2(false)

			return true
		elseif slot1:sub(2, 5):lower() == "load" then
			uv3()

			return true
		elseif slot1:sub(2, 6):lower() == "reset" then
			uv4(slot1:sub(8, 8) == "1")

			return true
		elseif slot1:sub(2, 5):lower() == "shop" then
			if slot1:len() > 6 then
				for slot5 = 1, #uv5 do
					item = uv5[slot5]

					if slot1:sub(7, 9):lower() == "buy" then
						if item[2] == slot1:sub(11, -1):lower() then
							if item[8] then
								uv1.client.color_log(255, 0, 0, "This item has already been purchased.")
							elseif item[4] <= uv0.balance then
								uv6("balance", -item[4], true)

								item[8] = true

								database.write(item[7], true)
								uv1.client.color_log(255, 255, 255, "Item successfully purchased.")
							else
								uv1.client.color_log(255, 0, 0, "You don't have enough money.")
							end
						end

						return true
					elseif slot1:sub(7, 12):lower() == "refund" then
						if item[2] == "xp" then
							uv1.client.color_log(255, 0, 0, "This item can not refunded.")

							return
						end

						if item[8] then
							uv6("balance", item[4], true)

							item[8] = false

							database.write(item[7], false)
							uv1.client.color_log(255, 255, 255, "Item successfully refunded.")
						else
							uv1.client.color_log(255, 0, 0, "This item has not been purchased yet.")
						end

						return true
					end
				end
			else
				for slot5 = 1, #uv5 do
					item = uv5[slot5]
					slot6 = 255
					slot7 = 190
					slot8 = 0

					if item[8] then
						slot8 = 255
						slot7 = 150
						slot6 = 0
					end

					uv1.client.color_log(slot6, slot7, slot8, item[1] .. " (" .. item[2] .. ")  ")
					uv1.client.color_log(255, 255, 255, "- " .. item[3] .. "  ")
					uv1.client.color_log(255, 190, 0, "$" .. item[4])
				end

				return true
			end
		elseif slot1:sub(2, 12):lower() == "disable_hud" then
			if tonumber(slot1:sub(14, 14)) and slot2 <= 2 then
				uv0.disable_original = slot2

				database.write("rpg/hud/disable_orig", slot2)
			end

			return true
		elseif slot1:sub(2, 10):lower() == "force_hud" then
			if tonumber(slot1:sub(12, 12)) and slot2 <= 1 then
				uv0.force_weapon = slot2

				database.write("rpg/hud/force_weap", slot2)
			end

			return true
		elseif slot1:sub(2, 6):lower() == "quest" then
			if slot1:len() > 7 then
				if slot1:sub(8, 11):lower() == "list" then
					for slot5 = 1, #uv7 do
						quest = uv7[slot5]
						slot6 = 255
						slot7 = 255
						slot8 = 255

						if quest[5] < 0 then
							slot8 = 0
							slot7 = 0
							slot6 = 255
						elseif quest[5] == 1 then
							slot8 = 255
							slot7 = 150
							slot6 = 0
						elseif quest[5] == 2 then
							slot8 = 0
							slot7 = 180
							slot6 = 255
						end

						uv1.client.color_log(slot6, slot7, slot8, quest[1] .. " (" .. quest[2] .. ") - " .. quest[3][1] .. "xp, $" .. quest[3][2])
					end

					return true
				elseif slot1:sub(8, 11):lower() == "take" then
					uv8 = slot1:sub(13, -1):lower()

					for slot6 = 1, #uv7 do
						quest = uv7[slot6]

						if slot2 == quest[2] and quest[5] == 0 then
							uv9(220, 220, 220, "Successfully have taken a quest - " .. quest[1])
						end

						if uv8 == quest[2] then
							if quest[5] == 0 then
								quest[5] = 1
							end
						elseif quest[5] == 1 then
							quest[5] = 0
						end
					end

					return true
				end
			else
				uv1.client.color_log(180, 180, 180, "Usage: .quest [list/take]")

				return true
			end
		end
	end
end)
slot4.client.set_event_callback("player_death", function (slot0)
	slot1 = uv0.client.userid_to_idx(slot0.userid)
	slot2 = uv0.client.userid_to_idx(slot0.attacker)
	slot4 = {
		knife = {
			150,
			50
		},
		awp = {
			15,
			5
		},
		taser = {
			100,
			50
		},
		ssg08 = {
			50,
			35
		},
		[slot0.weapon] = {
			40,
			20
		}
	}
	slot5 = {
		CKnife = {
			-20,
			-5
		},
		CWeaponAWP = {
			-50,
			-100
		}
	}

	if ({
		knife = {
			200,
			100
		},
		awp = {
			85,
			25
		},
		taser = {
			150,
			50
		},
		ssg08 = {
			100,
			50
		}
	})[slot0.weapon] == nil then
		slot3[slot0.weapon] = {
			80,
			40
		}
	end

	if slot2 == uv0.ent.get_local() and uv0.ent.is_enemy(slot1) then
		if not uv1[slot1] then
			if slot0.headshot then
				uv2("xp", slot3[slot0.weapon][1], false)
				uv2("balance", slot3[slot0.weapon][2], false)
			else
				uv2("xp", slot4[slot0.weapon][1], false)
				uv2("balance", slot4[slot0.weapon][2], false)
			end

			uv1[slot1] = uv0.globals.realtime() + 20
		end

		if uv3[2][5] == 1 then
			uv3[2][5] = 2

			database.write(uv3[2][5], 2)
			uv2("xp", uv3[2][3][1], true)
			uv2("balance", uv3[2][3][2], true)
		elseif uv3[1][5] == 1 and slot0.weapon == "knife" then
			uv3[1][5] = 2

			database.write(uv3[1][4], 2)
			uv2("xp", uv3[1][3][1], true)
			uv2("balance", uv3[1][3][2], true)
		end

		uv4 = uv0.globals.tickcount() + 25
	end

	if slot1 == uv0.ent.get_local() then
		if slot5[uv5] == nil then
			slot5[uv5] = {
				-30,
				-15
			}
		end

		uv2("xp", slot5[uv5][1], false)
		uv2("balance", slot5[uv5][2], false)
	end
end)
slot4.client.set_event_callback("player_hurt", function (slot0)
	if uv0.client.userid_to_idx(slot0.attacker) == uv0.ent.get_local() and uv0.ent.is_enemy(uv0.client.userid_to_idx(slot0.userid)) then
		uv1 = uv0.globals.tickcount() + 13
	end
end)
slot4.client.set_event_callback("weapon_fire", function (slot0)
	if uv0.client.userid_to_idx(slot0.userid) == uv0.ent.get_local() then
		uv1 = uv0.globals.tickcount() + 20
	end
end)
slot4.client.set_event_callback("aim_miss", function (slot0)
	if uv0[2][5] == 1 then
		uv0[2][5] = -1

		database.write(uv0[2][5], -1)
		client.exec("play bot\\aw_hell")
		uv1(255, 0, 0, "Quest failed. Missed a shot.")
	end
end)
slot4.client.set_event_callback("player_connect_full", function (slot0)
	if uv0.client.userid_to_idx(slot0.userid) == uv0.ent.get_local() then
		uv1 = {}
		uv2 = globals.tickcount()
		uv3 = globals.tickcount()
	end
end)
slot4.client.set_event_callback("round_end", function (slot0)
	if slot0.winner == uv0.ent.get_prop(uv0.ent.get_local(), "m_iTeamNum") then
		uv1("xp", 50, false)
		uv1("balance", 50, false)
	end
end)
slot4.client.set_event_callback("shutdown", function ()
	if cvar.cl_drawhud_force_radar:get_int() <= 0 then
		cvar.cl_drawhud_force_radar:set_int(1)
	end

	if cvar.cl_drawhud:get_int() <= 0 then
		cvar.cl_drawhud:set_int(1)
	end

	if #uv0 > 0 then
		database.write("rpg/kill_times", uv0)
	else
		database.write("rpg/kill_times", {})
	end
end)
