local var_0_0 = require("vector")
local var_0_1 = require("gamesense/images")
local var_0_2 = panorama.open()
local var_0_3 = require("ffi")
local var_0_4 = {
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
		cast = var_0_3.cast
	}
}
local var_0_5 = var_0_2.MyPersonaAPI.GetXuid()
local var_0_6, var_0_7 = var_0_4.client.screen_size()
local var_0_8 = {}
local var_0_9 = {}
local var_0_10 = {}
local var_0_11 = 0
local var_0_12 = 0
local var_0_13 = 0
local var_0_14 = 0
local var_0_15 = 0
local var_0_16 = 0
local var_0_17 = 0
local var_0_18 = {
	missed = 0
}
local var_0_19 = globals.realtime() + 600
local var_0_20 = {}
local var_0_21 = var_0_4.data.read("rpg/kill_times") or {}
local var_0_22 = ""
local var_0_23 = {
	status = "",
	username = var_0_4.data.read("rpg/nickname_") or "unknown",
	avatar = var_0_4.data.read("rpg/avatar") or var_0_1.get_steam_avatar(var_0_5, 65) or nil,
	lvl = var_0_4.data.read("rpg/level_") or 1,
	xp = {
		var_0_4.data.read("rpg/xp/current_") or 0,
		var_0_4.data.read("rpg/xp/needed_") or 100,
		var_0_4.data.read("rpg/xp/reached_") or 0,
		var_0_4.data.read("rpg/xp/prev_reached_") or 0
	},
	balance = var_0_4.data.read("rpg/balance_") or 0,
	disable_original = var_0_4.data.read("rpg/hud/disable_orig") or 0,
	force_weapon = var_0_4.data.read("rpg/hud/force_weap") or 0
}
local var_0_24 = {
	{
		"Kill someone with a knife",
		"kill_knife",
		{
			300,
			400
		},
		"rpg/quests/3/kill_knife",
		var_0_4.data.read("rpg/quests/3/kill_knife") or 0
	},
	{
		"Kill someone without missing a single shot",
		"kill_miss",
		{
			400,
			1000
		},
		"rpg/quests/3/kill_miss",
		var_0_4.data.read("rpg/quests/3/kill_miss") or 0
	}
}
local var_0_25 = {
	helmet = var_0_1.get_weapon_icon("helmet"),
	armor = var_0_1.get_weapon_icon("kevlar")
}
local var_0_26 = {
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
local var_0_27 = {
	x = var_0_4.data.read("rpg/hud/pos.x") or 854,
	y = var_0_4.data.read("rpg/hud/pos.y") or 110
}

if var_0_23.username == "unknown" then
	var_0_4.client.color_log(255, 0, 0, "Please select your username. [.nick]")
end

local function var_0_28(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	var_0_4.table.insert(var_0_10, {
		1,
		var_0_4.globals.tickcount(),
		{
			arg_1_0,
			arg_1_1,
			arg_1_2,
			arg_1_3
		}
	})
	var_0_4.client.color_log(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
end

local function var_0_29(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0, var_2_1 = ui.mouse_position()

	return arg_2_0 <= var_2_0 and var_2_0 <= arg_2_0 + arg_2_2 and arg_2_1 <= var_2_1 and var_2_1 <= arg_2_1 + arg_2_3
end

local function var_0_30(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10, arg_3_11, arg_3_12, arg_3_13, arg_3_14)
	local var_3_0 = {
		arg_3_0,
		arg_3_1
	}
	local var_3_1 = {}

	var_3_1.x, var_3_1.y = var_0_4.render.world_to_screen(arg_3_0, arg_3_1, arg_3_2)

	for iter_3_0 = arg_3_5, arg_3_4 + arg_3_5, var_0_4.math.min(25, arg_3_3 / 5) do
		local var_3_2 = var_0_4.math.rad(iter_3_0)
		local var_3_3 = var_0_0(arg_3_3 * var_0_4.math.cos(var_3_2) + arg_3_0, arg_3_3 * var_0_4.math.sin(var_3_2) + arg_3_1, arg_3_2)
		local var_3_4 = {}

		var_3_4.x, var_3_4.y = var_0_4.render.world_to_screen(var_3_3.x, var_3_3.y, var_3_3.z)

		if var_3_4.x ~= nil and var_3_0.x ~= nil then
			if arg_3_10 then
				var_0_4.render.polygon(var_3_1.x, var_3_1.y, var_3_0.x, var_3_0.y, var_3_4.x, var_3_4.y, arg_3_11, arg_3_12, arg_3_13, arg_3_14)
			end

			var_0_4.render.line(var_3_4.x, var_3_4.y, var_3_0.x, var_3_0.y, arg_3_6, arg_3_7, arg_3_8, arg_3_9)
		end

		var_3_0.x, var_3_0.y = var_3_4.x, var_3_4.y
	end
end

local function var_0_31(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = var_0_4.math.sin(arg_4_0)
	local var_4_1 = var_0_4.math.cos(arg_4_0)

	arg_4_2.x = arg_4_2.x - arg_4_1.x
	arg_4_2.y = arg_4_2.y - arg_4_1.y
	arg_4_3.x = arg_4_3.x - arg_4_1.x
	arg_4_3.y = arg_4_3.y - arg_4_1.y

	local var_4_2 = arg_4_2.x * var_4_1 - arg_4_2.y * var_4_0
	local var_4_3 = arg_4_2.x * var_4_0 + arg_4_2.y * var_4_1
	local var_4_4 = arg_4_3.x * var_4_1 - arg_4_3.y * var_4_0
	local var_4_5 = arg_4_3.x * var_4_0 + arg_4_3.y * var_4_1

	return var_4_2 + arg_4_1.x, var_4_3 + arg_4_1.y, var_4_4 + arg_4_1.x, var_4_5 + arg_4_1.y
end

local function var_0_32(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0

	var_5_0 = var_5_0 < arg_5_1 and arg_5_1 or var_5_0
	var_5_0 = arg_5_2 < var_5_0 and arg_5_2 or var_5_0

	return var_5_0
end

local function var_0_33(arg_6_0)
	var_0_4.data.write("rpg/level_", var_0_23.lvl)
	var_0_4.data.write("rpg/xp/current_", var_0_23.xp[1])
	var_0_4.data.write("rpg/xp/needed_", var_0_23.xp[2])
	var_0_4.data.write("rpg/xp/reached_", var_0_23.xp[3])
	var_0_4.data.write("rpg/xp/prev_reached_", var_0_23.xp[4])
	var_0_4.data.write("rpg/balance_", var_0_23.balance)
	var_0_4.data.write("rpg/has_save_", true)
	var_0_28(220, 220, 220, arg_6_0 and "Automatically saved progress." or "Successfully saved progress.")
end

local function var_0_34()
	if var_0_4.data.read("rpg/has_save_") == nil or var_0_4.data.read("rpg/has_save_") == false or var_0_4.data.read("rpg/level_") == nil then
		var_0_4.client.color_log(255, 0, 0, "Couldn't find any save, sorry!")

		return
	end

	var_0_23.lvl = var_0_4.data.read("rpg/level_")
	var_0_23.xp[1] = var_0_4.data.read("rpg/xp/current_")
	var_0_23.xp[2] = var_0_4.data.read("rpg/xp/needed_")
	var_0_23.xp[3] = var_0_4.data.read("rpg/xp/reached_")
	var_0_23.xp[4] = var_0_4.data.read("rpg/xp/prev_reached_")
	var_0_23.balance = var_0_4.data.read("rpg/balance_")

	var_0_28(220, 220, 220, "Loaded latest save.")
end

local function var_0_35(arg_8_0)
	if arg_8_0 then
		if var_0_4.data.read("rpg/has_save_") then
			var_0_4.data.write("rpg/level_", nil)
			var_0_4.data.write("rpg/xp/current_", nil)
			var_0_4.data.write("rpg/xp/needed_", nil)
			var_0_4.data.write("rpg/xp/reached_", nil)
			var_0_4.data.write("rpg/xp/prev_reached_", nil)
			var_0_4.data.write("rpg/balance_", nil)
			var_0_4.data.write("rpg/has_save_", false)
			var_0_4.client.color_log(220, 220, 220, "Successfully reset your save")
		else
			var_0_4.client.color_log(255, 0, 0, "Couldn't find any save to reset.")
		end
	else
		var_0_4.client.color_log(220, 220, 220, "Successfully reset your progress.")
	end

	var_0_23.lvl = 1
	var_0_23.xp[1] = 0
	var_0_23.xp[2] = 100
	var_0_23.xp[3] = 0
	var_0_23.xp[4] = 0
	var_0_23.balance = 0
end

local function var_0_36(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_0 == "xp" then
		var_0_23.xp[1] = var_0_23.xp[1] + arg_9_1

		var_0_4.table.insert(var_0_8, {
			1,
			var_0_4.globals.tickcount(),
			arg_9_1
		})

		if arg_9_2 then
			var_0_33(true)
		end
	elseif arg_9_0 == "level" then
		var_0_23.lvl = var_0_23.lvl + arg_9_1

		if arg_9_1 > 0 then
			-- block empty
		end

		if arg_9_2 then
			var_0_33(true)
		end
	elseif arg_9_0 == "balance" then
		var_0_23.balance = var_0_23.balance + arg_9_1

		var_0_4.table.insert(var_0_9, {
			1,
			var_0_4.globals.tickcount(),
			arg_9_1
		})

		if arg_9_2 then
			var_0_33(true)
		end
	end
end

local function var_0_37(arg_10_0)
	if arg_10_0.reason ~= "spread" then
		var_0_18.missed = var_0_18.missed + 1
	end
end

local function var_0_38()
	local var_11_0 = var_0_4.ent.get_local()

	if var_11_0 == nil then
		return
	end

	if var_0_23.avatar == nil or var_0_5 == nil then
		var_0_5 = var_0_2.MyPersonaAPI.GetXuid()
		var_0_23.avatar = var_0_1.get_steam_avatar(var_0_5, 65)
	end

	if var_0_23.disable_original == 1 then
		if cvar.cl_drawhud:get_int() == 1 then
			cvar.cl_drawhud:set_int(0)
		end

		if cvar.cl_drawhud_force_radar:get_int() <= 0 then
			cvar.cl_drawhud_force_radar:set_int(1)
		end
	elseif var_0_23.disable_original == 2 then
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

	local var_11_1 = var_0_23.username:sub(0, 24) .. " • level " .. var_0_23.lvl .. " (+" .. var_0_23.xp[2] - var_0_23.xp[1] .. "xp)"
	local var_11_2 = {
		health = var_0_4.ent.get_prop(var_11_0, "m_iHealth"),
		armor = var_0_4.ent.get_prop(var_11_0, "m_ArmorValue"),
		has_helmet = var_0_4.ent.get_prop(var_11_0, "m_bHasHelmet"),
		text_size = {
			var_0_4.render.measure("", var_11_1)
		},
		status_size = {
			var_0_4.render.measure("", var_0_23.status)
		},
		balance_size = {
			var_0_4.render.measure("", "$" .. var_0_23.balance)
		},
		is_scoped = var_0_4.ent.get_prop(var_11_0, "m_bIsScoped")
	}
	local var_11_3 = {
		var_0_4.render.measure("", var_11_2.health .. "hp")
	}
	local var_11_4 = var_0_4.math.min(1, var_11_2.health / 100)
	local var_11_5 = var_0_4.math.min(1, var_0_23.xp[1] / var_0_23.xp[2])
	local var_11_6 = var_0_4.ent.get_weapon(var_11_0)
	local var_11_7 = var_0_1.get_weapon_icon("weapon_knife")
	local var_11_8 = var_0_4.globals.frametime() * 8
	local var_11_9 = var_0_23.disable_original > 0 or var_0_23.force_weapon > 0

	var_0_20.left = var_0_4.client.key_state(1)
	var_0_20.pos = {
		ui.mouse_position()
	}

	if var_0_4.ent.is_alive(var_11_0) then
		var_0_22 = var_0_4.ent.get_classname(var_0_4.ent.get_weapon(var_0_4.ent.get_local()))
	end

	if var_0_14 > 0 then
		if var_0_27.drag and not var_0_20.left then
			var_0_27.drag = false
		end

		if var_0_27.drag and var_0_20.left then
			var_0_27.x = var_0_20.pos[1] - var_0_27.drag_x
			var_0_27.y = var_0_20.pos[2] - var_0_27.drag_y

			var_0_4.data.write("rpg/hud/pos.x", var_0_27.x)
			var_0_4.data.write("rpg/hud/pos.y", var_0_27.y)
		end

		if var_0_29(var_0_27.x, var_0_27.y, 30, 17) and var_0_20.left then
			var_0_27.drag = true
			var_0_27.drag_x = var_0_20.pos[1] - var_0_27.x
			var_0_27.drag_y = var_0_20.pos[2] - var_0_27.y
		end

		var_0_4.render.rectangle(var_0_27.x, var_0_27.y, 30, 20, 30, 30, 30, 255 * var_0_14)
		var_0_4.render.text(var_0_27.x + 10, var_0_27.y, 180, 180, 180, 255 * var_0_14, "-", 0, "▼")
	end

	var_0_23.avatar:draw(var_0_27.x - 23, var_0_27.y + 32, 75, 75, 255, 255, 255, 255, true)
	var_0_4.render.circle(var_0_27.x + 15, var_0_27.y + 105, 0, 150, 255, 190, 13, 0, 1)
	var_0_4.render.text(var_0_27.x + 15, var_0_27.y + 100, 255, 255, 255, 255, "c", 0, var_0_23.lvl)
	var_0_4.render.circle_out(var_0_27.x + 15, var_0_27.y + 70, 30, 30, 30, 255, 55, 0, 1, 18)
	var_0_4.render.circle_out(var_0_27.x + 15, var_0_27.y + 70, 0, 150, 255, 255, 40, 90, var_11_5, 1)
	var_0_4.render.rectangle(var_0_27.x + 55, var_0_27.y + 70, var_11_2.status_size[1] + var_11_2.balance_size[1] + 40, 20, 30, 30, 30, 255)
	var_0_4.render.gradient(var_0_27.x + 55 + var_11_2.status_size[1] + var_11_2.balance_size[1] + 40, var_0_27.y + 70, 30, 20, 30, 30, 30, 255, 30, 30, 30, 0, true)
	var_0_4.render.text(var_0_27.x + 77, var_0_27.y + 73, 255, 190, 0, 255, "", 0, var_0_23.status)
	var_0_4.render.text(var_0_27.x + 77 + var_11_2.status_size[1], var_0_27.y + 73, 220, 220, 220, 255, "", 0, " • $" .. var_0_23.balance)
	var_0_4.render.rectangle(var_0_27.x - 25, var_0_27.y + 55, -var_11_3[1] - 30, 20, 30, 30, 30, 255)
	var_0_4.render.text(var_0_27.x - 45 - var_11_3[1], var_0_27.y + 58, 255 - 108 * var_11_4, 220 * var_11_4, 50 * var_11_4, 255, "", 0, var_11_2.health .. "hp")
	var_0_4.render.gradient(var_0_27.x - 25 - var_11_3[1] - 60, var_0_27.y + 55, 30, 20, 30, 30, 30, 0, 30, 30, 30, 255, true)
	var_0_4.render.circle_out(var_0_27.x + 15, var_0_27.y + 70, 255 - 108 * var_11_4, 220 * var_11_4, 50 * var_11_4, 255, 55, 355, var_11_4 * 0.92, 1)
	var_0_4.render.gradient(var_0_27.x + 55 + var_11_2.text_size[1] + 30, var_0_27.y + 40, 30, 25, 30, 30, 30, 255, 30, 30, 30, 0, true)
	var_0_4.render.rectangle(var_0_27.x + 55, var_0_27.y + 40, var_11_2.text_size[1] + 30, 25, 30, 30, 30, 255)
	var_0_4.render.text(var_0_27.x + 75, var_0_27.y + 45, 220, 220, 220, 255, "", 0, var_11_1)

	if var_0_12 > 0 then
		var_0_25.helmet:draw(var_0_27.x + 65, var_0_27.y + 15, 15, 25, 220, 220, 220, var_11_2.has_helmet == 1 and 255 * var_0_12 or 60 * var_0_12, true)
		var_0_25.armor:draw(var_0_27.x + 85, var_0_27.y + 20, 15, 15, 220, 220, 220, var_11_2.armor > 1 and 255 * var_0_12 or 60 * var_0_12, true)
	end

	if var_0_12 > 0 and var_0_4.ent.is_alive(var_11_0) then
		local var_11_10 = var_0_1.get_weapon_icon(var_0_4.ent.get_prop(var_11_6, "m_iItemDefinitionIndex"))

		var_0_13 = math.max(0, var_0_16 - var_0_4.globals.tickcount()) / 20
		var_0_15 = math.max(0, var_0_17 - var_0_4.globals.tickcount()) / 13

		local var_11_11 = {
			var_11_10:measure() + 10
		}
		local var_11_12 = {
			var_0_4.ent.get_prop(var_11_6, "m_iClip1"),
			var_0_4.ent.get_prop(var_11_6, "m_iPrimaryReserveAmmoCount")
		}

		var_11_10:draw(var_0_6 / 2 - var_11_11[1] / 2, var_0_7 - 180, var_11_11[1], var_11_11[2], 220, 220, 220, 120 * var_0_12 + 135 * var_0_13, true)

		if var_0_15 > 0 then
			var_11_10:draw(var_0_6 / 2 - var_11_11[1] / 2, var_0_7 - 180, var_11_11[1], var_11_11[2], 220, 0, 0, 120 * var_0_15, true)
		end

		if var_11_12 and var_11_12[1] > -1 then
			var_0_4.render.text(var_0_6 / 2, var_0_7 - 120, 220, 220, 220, 255 * var_0_12, "c+", 0, var_11_12[1] .. " / " .. var_11_12[2])
		end
	end

	var_0_12 = var_0_32(var_0_12 + (var_11_9 and var_11_8 / 2 or -var_11_8), 0, 1)
	var_0_14 = var_0_32(var_0_14 + (ui.is_menu_open() and var_11_8 / 2 or -var_11_8), 0, 1)
end

local function var_0_39()
	local var_12_0 = {}
	local var_12_1 = {}
	local var_12_2 = {}

	for iter_12_0 = 1, #var_0_8 do
		xp = var_0_8[iter_12_0]

		local var_12_3 = var_0_4.globals.frametime() * 8

		if xp[2] + 160 < var_0_4.globals.tickcount() or iter_12_0 > 5 then
			var_12_0[#var_12_0 + 1] = 1
		end

		if xp[3] > 0 then
			var_0_4.render.text(var_0_27.x + 15, var_0_27.y + 20 - 15 * iter_12_0 + 10 * xp[1], 0, 150, 255, 255 * (1 - xp[1]), "c", 0, "+" .. xp[3] .. "xp")
		else
			var_0_4.render.text(var_0_27.x + 15, var_0_27.y + 20 - 15 * iter_12_0 + 10 * xp[1], 255, 40, 0, 255 * (1 - xp[1]), "c", 0, xp[3] .. "xp")
		end

		xp[1] = var_0_32(xp[1] + (xp[2] + 150 < var_0_4.globals.tickcount() and var_12_3 / 2 or -var_12_3), 0, 1)
	end

	for iter_12_1 = 1, #var_0_9 do
		money = var_0_9[iter_12_1]

		local var_12_4 = var_0_4.globals.frametime() * 8

		if money[2] + 160 < var_0_4.globals.tickcount() or iter_12_1 > 5 then
			var_12_1[#var_12_1 + 1] = 1
		end

		if money[3] > 0 then
			var_0_4.render.text(var_0_27.x + 65 + var_0_4.render.measure("", var_0_23.status .. " • $" .. var_0_23.balance), var_0_27.y + 80 + 15 * iter_12_1 - 10 * money[1], 147, 220, 50, 255 * (1 - money[1]), "c", 0, "+$" .. money[3])
		else
			var_0_4.render.text(var_0_27.x + 65 + var_0_4.render.measure("", var_0_23.status .. " • $" .. var_0_23.balance), var_0_27.y + 80 + 15 * iter_12_1 - 10 * money[1], 255, 40, 0, 255 * (1 - money[1]), "c", 0, "-$" .. -money[3])
		end

		money[1] = var_0_32(money[1] + (money[2] + 150 < var_0_4.globals.tickcount() and var_12_4 / 2 or -var_12_4), 0, 1)
	end

	for iter_12_2 = 1, #var_0_10 do
		log = var_0_10[iter_12_2]

		local var_12_5 = var_0_4.globals.frametime() * 8
		local var_12_6 = {
			width = var_0_4.render.measure("", log[3][4])
		}
		local var_12_7 = log[2] + 300 > var_0_4.globals.tickcount() and 15 * log[1] or 0

		if log[2] + 310 < var_0_4.globals.tickcount() or iter_12_2 > 15 then
			var_12_2[#var_12_2 + 1] = 1
		end

		var_0_4.render.circle(var_0_27.x + 80, var_0_27.y + 88 + 20 * iter_12_2 - var_12_7, 30, 30, 30, 255 * (1 - log[1]), 7.8, 180, 0.5)
		var_0_4.render.rectangle(var_0_27.x + 80, var_0_27.y + 80 + 20 * iter_12_2 - var_12_7, var_12_6.width, 16, 30, 30, 30, 255 * (1 - log[1]))
		var_0_4.render.circle(var_0_27.x + 80 + var_12_6.width, var_0_27.y + 88 + 20 * iter_12_2 - var_12_7, 30, 30, 30, 255 * (1 - log[1]), 7.8, 0, 0.5)
		var_0_4.render.text(var_0_27.x + 80, var_0_27.y + 81 + 20 * iter_12_2 - var_12_7, log[3][1], log[3][2], log[3][3], 255 * (1 - log[1]), "", 0, log[3][4])

		log[1] = var_0_32(log[1] + (log[2] + 300 < var_0_4.globals.tickcount() and var_12_5 / 2 or -var_12_5), 0, 1)
	end

	for iter_12_3 = 1, #var_12_0 do
		var_0_4.table.remove(var_0_8, var_12_0[iter_12_3])
	end

	for iter_12_4 = 1, #var_12_1 do
		var_0_4.table.remove(var_0_9, var_12_1[iter_12_4])
	end

	for iter_12_5 = 1, #var_12_2 do
		var_0_4.table.remove(var_0_10, var_12_2[iter_12_5])
	end
end

local function var_0_40()
	var_0_38()

	if #var_0_8 > 0 or #var_0_9 > 0 or #var_0_10 > 0 then
		var_0_39()
	end

	if var_0_23.balance < 0 then
		var_0_23.balance = 0
	end

	if var_0_23.balance > 9999 then
		var_0_23.balance = 9999
	end

	if var_0_23.lvl == 1 and var_0_23.xp[1] < 0 then
		var_0_23.xp[1] = 0
	end
end

var_0_4.client.set_event_callback("paint", var_0_40)

local function var_0_41()
	if var_0_23.xp[1] >= var_0_23.xp[2] then
		var_0_23.xp[4] = var_0_23.xp[3]
		var_0_23.xp[3] = var_0_23.xp[2]

		var_0_36("level", 1, false)

		var_0_23.xp[2] = var_0_23.lvl <= 10 and var_0_23.xp[2] * 2 or var_0_23.xp[2] * 3
		var_0_23.xp[1] = 0

		var_0_28(220, 220, 220, "Reached a new level! Level " .. var_0_23.lvl .. ", required xp for next level: " .. var_0_23.xp[2])
		var_0_33(true)
	end

	if var_0_23.xp[3] + var_0_23.xp[1] < var_0_23.xp[3] then
		var_0_23.xp[1] = var_0_23.xp[3] + var_0_23.xp[1]
		var_0_23.xp[2] = var_0_23.xp[3]
		var_0_23.xp[3] = var_0_23.xp[4]

		var_0_36("level", -1, true)
	end

	if var_0_23.lvl <= 5 then
		var_0_23.status = "Beginner"
	elseif var_0_23.lvl > 5 and var_0_23.lvl <= 15 then
		var_0_23.status = "Adventurer"
	elseif var_0_23.lvl > 15 and var_0_23.lvl <= 30 then
		var_0_23.status = "Master"
	elseif var_0_23.lvl > 30 and var_0_23.lvl <= 50 then
		var_0_23.status = "Legendary"
	end

	if var_0_19 < var_0_4.globals.realtime() then
		var_0_33(true)

		var_0_19 = var_0_4.globals.realtime() + 600
	end

	for iter_14_0 in pairs(var_0_21) do
		if var_0_4.globals.realtime() >= var_0_21[iter_14_0] then
			var_0_21[iter_14_0] = nil
		end
	end
end

local function var_0_42()
	return
end

local function var_0_43()
	var_0_41()
	var_0_42()
end

var_0_4.client.set_event_callback("setup_command", var_0_43)

local function var_0_44(arg_17_0)
	local var_17_0 = arg_17_0

	if var_17_0:sub(0, 1) == "." then
		if var_17_0:sub(2, 5):lower() == "nick" then
			var_0_23.username = var_17_0:sub(7, 32)

			database.write("rpg/nickname_", var_0_23.username)

			return true
		elseif var_17_0:sub(2, 5):lower() == "help" then
			var_0_4.client.color_log(255, 255, 255, "Hey, \x00")
			var_0_4.client.color_log(255, 0, 0, var_0_23.username .. " \x00")
			var_0_4.client.color_log(255, 255, 255, "Here's a list of all the current commands.")
			var_0_4.client.color_log(255, 190, 0, ".nick [nickname] \x00")
			var_0_4.client.color_log(255, 255, 255, " - change your nickname.")
			var_0_4.client.color_log(255, 190, 0, ".stats \x00")
			var_0_4.client.color_log(255, 255, 255, " - display your current statistics.")
			var_0_4.client.color_log(255, 190, 0, ".save \x00")
			var_0_4.client.color_log(255, 255, 255, " - save your progress.")
			var_0_4.client.color_log(255, 190, 0, ".load \x00")
			var_0_4.client.color_log(255, 255, 255, " - load the latest save.")
			var_0_4.client.color_log(255, 190, 0, ".reset [1] \x00")
			var_0_4.client.color_log(255, 255, 255, " - reset your progress [save].")
			var_0_4.client.color_log(255, 190, 0, ".shop [buy/refund] [item:id] \x00")
			var_0_4.client.color_log(255, 255, 255, " - view the shop/buy or refund an item.")
			var_0_4.client.color_log(255, 190, 0, ".quest [list/take] [quest:id] \x00")
			var_0_4.client.color_log(255, 255, 255, " - view the quest list/take a quest.")
			var_0_4.client.color_log(255, 190, 0, ".disable_hud [int] \x00")
			var_0_4.client.color_log(255, 255, 255, " - disable the original csgo hud.")
			var_0_4.client.color_log(255, 190, 0, ".force_hud [int] \x00")
			var_0_4.client.color_log(255, 255, 255, " - force luas weapon hud.")

			return true
		elseif var_17_0:sub(2, 6):lower() == "stats" then
			var_0_4.client.color_log(255, 255, 255, var_0_23.username .. " • level \x00")
			var_0_4.client.color_log(255, 190, 0, var_0_23.lvl .. " \x00")
			var_0_4.client.color_log(255, 255, 255, "(\x00")
			var_0_4.client.color_log(0, 150, 255, var_0_23.xp[2] - var_0_23.xp[1] .. "xp\x00")
			var_0_4.client.color_log(255, 255, 255, ") • \x00")
			var_0_4.client.color_log(255, 190, 0, var_0_23.status .. " \x00")
			var_0_4.client.color_log(255, 255, 255, "• $" .. var_0_23.balance)

			return true
		elseif var_17_0:sub(2, 5):lower() == "save" then
			var_0_33(false)

			return true
		elseif var_17_0:sub(2, 5):lower() == "load" then
			var_0_34()

			return true
		elseif var_17_0:sub(2, 6):lower() == "reset" then
			var_0_35(var_17_0:sub(8, 8) == "1")

			return true
		elseif var_17_0:sub(2, 5):lower() == "shop" then
			if var_17_0:len() > 6 then
				for iter_17_0 = 1, #var_0_26 do
					item = var_0_26[iter_17_0]

					if var_17_0:sub(7, 9):lower() == "buy" then
						if item[2] == var_17_0:sub(11, -1):lower() then
							if item[8] then
								var_0_4.client.color_log(255, 0, 0, "This item has already been purchased.")
							elseif item[4] <= var_0_23.balance then
								var_0_36("balance", -item[4], true)

								item[8] = true

								database.write(item[7], true)
								var_0_4.client.color_log(255, 255, 255, "Item successfully purchased.")
							else
								var_0_4.client.color_log(255, 0, 0, "You don't have enough money.")
							end
						end

						return true
					elseif var_17_0:sub(7, 12):lower() == "refund" then
						if item[2] == "xp" then
							var_0_4.client.color_log(255, 0, 0, "This item can not refunded.")

							return
						end

						if item[8] then
							var_0_36("balance", item[4], true)

							item[8] = false

							database.write(item[7], false)
							var_0_4.client.color_log(255, 255, 255, "Item successfully refunded.")
						else
							var_0_4.client.color_log(255, 0, 0, "This item has not been purchased yet.")
						end

						return true
					end
				end
			else
				for iter_17_1 = 1, #var_0_26 do
					item = var_0_26[iter_17_1]

					local var_17_1 = 255
					local var_17_2 = 190
					local var_17_3 = 0

					if item[8] then
						var_17_1, var_17_2, var_17_3 = 0, 150, 255
					end

					var_0_4.client.color_log(var_17_1, var_17_2, var_17_3, item[1] .. " (" .. item[2] .. ") \x00")
					var_0_4.client.color_log(255, 255, 255, "- " .. item[3] .. " \x00")
					var_0_4.client.color_log(255, 190, 0, "$" .. item[4])
				end

				return true
			end
		elseif var_17_0:sub(2, 12):lower() == "disable_hud" then
			local var_17_4 = tonumber(var_17_0:sub(14, 14))

			if var_17_4 and var_17_4 <= 2 then
				var_0_23.disable_original = var_17_4

				database.write("rpg/hud/disable_orig", var_17_4)
			end

			return true
		elseif var_17_0:sub(2, 10):lower() == "force_hud" then
			local var_17_5 = tonumber(var_17_0:sub(12, 12))

			if var_17_5 and var_17_5 <= 1 then
				var_0_23.force_weapon = var_17_5

				database.write("rpg/hud/force_weap", var_17_5)
			end

			return true
		elseif var_17_0:sub(2, 6):lower() == "quest" then
			if var_17_0:len() > 7 then
				if var_17_0:sub(8, 11):lower() == "list" then
					for iter_17_2 = 1, #var_0_24 do
						quest = var_0_24[iter_17_2]

						local var_17_6 = 255
						local var_17_7 = 255
						local var_17_8 = 255

						if quest[5] < 0 then
							var_17_6, var_17_7, var_17_8 = 255, 0, 0
						elseif quest[5] == 1 then
							var_17_6, var_17_7, var_17_8 = 0, 150, 255
						elseif quest[5] == 2 then
							var_17_6, var_17_7, var_17_8 = 255, 180, 0
						end

						var_0_4.client.color_log(var_17_6, var_17_7, var_17_8, quest[1] .. " (" .. quest[2] .. ") - " .. quest[3][1] .. "xp, $" .. quest[3][2])
					end

					return true
				elseif var_17_0:sub(8, 11):lower() == "take" then
					local var_17_9 = var_17_0:sub(13, -1):lower()

					var_0_11 = var_17_9

					for iter_17_3 = 1, #var_0_24 do
						quest = var_0_24[iter_17_3]

						if var_17_9 == quest[2] and quest[5] == 0 then
							var_0_28(220, 220, 220, "Successfully have taken a quest - " .. quest[1])
						end

						if var_0_11 == quest[2] then
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
				var_0_4.client.color_log(180, 180, 180, "Usage: .quest [list/take]")

				return true
			end
		end
	end
end

var_0_4.client.set_event_callback("console_input", var_0_44)
var_0_4.client.set_event_callback("player_death", function(arg_18_0)
	local var_18_0 = var_0_4.client.userid_to_idx(arg_18_0.userid)
	local var_18_1 = var_0_4.client.userid_to_idx(arg_18_0.attacker)
	local var_18_2 = {
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
	}
	local var_18_3 = {
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
		}
	}
	local var_18_4 = {
		CKnife = {
			-20,
			-5
		},
		CWeaponAWP = {
			-50,
			-100
		}
	}

	if var_18_2[arg_18_0.weapon] == nil then
		var_18_2[arg_18_0.weapon] = {
			80,
			40
		}
		var_18_3[arg_18_0.weapon] = {
			40,
			20
		}
	end

	if var_18_1 == var_0_4.ent.get_local() and var_0_4.ent.is_enemy(var_18_0) then
		if not var_0_21[var_18_0] then
			if arg_18_0.headshot then
				var_0_36("xp", var_18_2[arg_18_0.weapon][1], false)
				var_0_36("balance", var_18_2[arg_18_0.weapon][2], false)
			else
				var_0_36("xp", var_18_3[arg_18_0.weapon][1], false)
				var_0_36("balance", var_18_3[arg_18_0.weapon][2], false)
			end

			var_0_21[var_18_0] = var_0_4.globals.realtime() + 20
		end

		if var_0_24[2][5] == 1 then
			var_0_24[2][5] = 2

			database.write(var_0_24[2][5], 2)
			var_0_36("xp", var_0_24[2][3][1], true)
			var_0_36("balance", var_0_24[2][3][2], true)
		elseif var_0_24[1][5] == 1 and arg_18_0.weapon == "knife" then
			var_0_24[1][5] = 2

			database.write(var_0_24[1][4], 2)
			var_0_36("xp", var_0_24[1][3][1], true)
			var_0_36("balance", var_0_24[1][3][2], true)
		end

		var_0_17 = var_0_4.globals.tickcount() + 25
	end

	if var_18_0 == var_0_4.ent.get_local() then
		if var_18_4[var_0_22] == nil then
			var_18_4[var_0_22] = {
				-30,
				-15
			}
		end

		var_0_36("xp", var_18_4[var_0_22][1], false)
		var_0_36("balance", var_18_4[var_0_22][2], false)
	end
end)
var_0_4.client.set_event_callback("player_hurt", function(arg_19_0)
	local var_19_0 = var_0_4.client.userid_to_idx(arg_19_0.userid)

	if var_0_4.client.userid_to_idx(arg_19_0.attacker) == var_0_4.ent.get_local() and var_0_4.ent.is_enemy(var_19_0) then
		var_0_17 = var_0_4.globals.tickcount() + 13
	end
end)
var_0_4.client.set_event_callback("weapon_fire", function(arg_20_0)
	if var_0_4.client.userid_to_idx(arg_20_0.userid) == var_0_4.ent.get_local() then
		var_0_16 = var_0_4.globals.tickcount() + 20
	end
end)
var_0_4.client.set_event_callback("aim_miss", function(arg_21_0)
	if var_0_24[2][5] == 1 then
		var_0_24[2][5] = -1

		database.write(var_0_24[2][5], -1)
		client.exec("play bot\\aw_hell")
		var_0_28(255, 0, 0, "Quest failed. Missed a shot.")
	end
end)
var_0_4.client.set_event_callback("player_connect_full", function(arg_22_0)
	if var_0_4.client.userid_to_idx(arg_22_0.userid) == var_0_4.ent.get_local() then
		var_0_21 = {}
		var_0_16 = globals.tickcount()
		var_0_17 = globals.tickcount()
	end
end)
var_0_4.client.set_event_callback("round_end", function(arg_23_0)
	if arg_23_0.winner == var_0_4.ent.get_prop(var_0_4.ent.get_local(), "m_iTeamNum") then
		var_0_36("xp", 50, false)
		var_0_36("balance", 50, false)
	end
end)
var_0_4.client.set_event_callback("shutdown", function()
	if cvar.cl_drawhud_force_radar:get_int() <= 0 then
		cvar.cl_drawhud_force_radar:set_int(1)
	end

	if cvar.cl_drawhud:get_int() <= 0 then
		cvar.cl_drawhud:set_int(1)
	end

	if #var_0_21 > 0 then
		database.write("rpg/kill_times", var_0_21)
	else
		database.write("rpg/kill_times", {})
	end
end)
