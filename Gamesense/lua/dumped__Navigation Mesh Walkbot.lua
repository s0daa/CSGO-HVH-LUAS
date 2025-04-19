slot0 = client.get_cvar
slot1 = client.camera_position
slot2 = client.create_interface
slot3 = client.random_int
slot4 = client.latency
slot5 = client.set_clan_tag
slot6 = client.find_signature
slot7 = client.log
slot8 = client.timestamp
slot9 = client.delay_call
slot10 = client.draw_indicator
slot11 = client.trace_line
slot12 = client.draw_circle
slot13 = client.draw_line
slot14 = client.draw_text
slot15 = client.register_esp_flag
slot16 = client.get_model_name
slot17 = client.system_time
slot18 = client.visible
slot19 = client.exec
slot20 = client.key_state
slot21 = client.set_cvar
slot22 = client.unix_time
slot23 = client.error_log
slot24 = client.draw_debug_text
slot25 = client.update_player_list
slot26 = client.camera_angles
slot27 = client.eye_position
slot28 = client.draw_hitboxes
slot29 = client.random_float
slot30 = entity.get_local_player
slot31 = entity.is_enemy
slot32 = entity.get_bounding_box
slot33 = entity.get_all
slot34 = entity.set_prop
slot35 = entity.is_alive
slot36 = entity.get_steam64
slot37 = entity.get_classname
slot38 = entity.get_player_resource
slot39 = entity.get_esp_data
slot40 = entity.is_dormant
slot41 = entity.get_player_name
slot42 = entity.get_game_rules
slot43 = entity.get_origin
slot44 = entity.hitbox_position
slot45 = entity.get_player_weapon
slot46 = entity.get_players
slot47 = entity.get_prop
slot48 = globals.realtime
slot49 = globals.absoluteframetime
slot50 = globals.chokedcommands
slot51 = globals.oldcommandack
slot52 = globals.tickcount
slot53 = globals.commandack
slot54 = globals.lastoutgoingcommand
slot55 = globals.curtime
slot57 = globals.tickinterval
slot58 = globals.framecount
slot59 = globals.frametime
slot60 = globals.maxplayers
slot62 = ui.new_combobox
slot63 = ui.reference
slot64 = ui.set_visible
slot65 = ui.new_textbox
slot68 = ui.mouse_position
slot70 = ui.new_multiselect
slot71 = ui.is_menu_open
slot72 = ui.new_hotkey
slot73 = ui.set
slot74 = ui.update
slot75 = ui.menu_size
slot76 = ui.name
slot77 = ui.menu_position
slot78 = ui.set_callback
slot79 = ui.new_button
slot81 = ui.new_string
slot82 = ui.get
slot83 = client.world_to_screen
slot84 = client.draw_rectangle
slot85 = client.draw_circle_outline
slot86 = client.userid_to_entindex
slot87 = client.draw_gradient
slot88 = client.set_event_callback
slot89 = client.screen_size
slot90 = client.trace_bullet
slot91 = client.unset_event_callback
slot92 = client.color_log
slot93 = client.reload_active_scripts
slot94 = client.scale_damage
slot95 = {
	debug_stance = "",
	sourcenav = require("gamesense/sourcenav"),
	graph = {},
	ignoreConnection = {},
	forbiddenWaypoint = {},
	path = {},
	waypoint = {},
	previousWaypoint = {}
}
slot96 = {
	lastStuckHandleTick = 999999999999.0,
	stuckAttempts = 0
}
slot101 = {
	[0] = "Misc",
	"Movement"
}
slot102 = {
	enable = ui.new_checkbox(slot101[0], slot101[1], "Enable walkbot"),
	target_type = slot62(slot101[0], slot101[1], "Walkbot target", "Waypoint", "Closest enemy", "Teammate"),
	option_type = slot70(slot101[0], slot101[1], "Walkbot options", {
		"Lock view angle",
		"Rand waypt if no enemy",
		"Rand waypt if no mate",
		"Show Path",
		"Debug Panel"
	}),
	option_automation = slot70(slot101[0], slot101[1], "Walkbot automation", {
		"Auto plant",
		"Auto defuse",
		"Auto team join",
		"Follow bomb_begindefuse",
		"Follow bomb_beginplant",
		"Follow bomb_dropped",
		"Stand still after plant"
	}),
	plant_slider = ui.new_slider(slot101[0], slot101[1], "A to B percentage", 0, 3, 2, true, "%", 1, function ()
		return {
			[0] = "Closest",
			"Random",
			"Only go A",
			"Only go B"
		}
	end()),
	pathlabel = ui.new_label(slot101[0], slot101[1], "Path Color"),
	pathcolor = ui.new_color_picker(slot101[0], slot101[1], "Path Color", 72, 133, 237, 255),
	end_waypoint = slot72(slot101[0], slot101[1], "Set waypoint"),
	calculate_path = slot72(slot101[0], slot101[1], "Calculate path"),
	remove_point = slot72(slot101[0], slot101[1], "Remove waypoint"),
	team_target = ui.new_listbox(slot101[0], slot101[1], "Target", "-", ({
		unscope = false,
		carrier = false,
		goingC4 = false,
		stand = false,
		planted = false,
		aa = false,
		previousPitch = "",
		debug = false,
		target_bombsite = "",
		target_name = "",
		currMap = globals.mapname(),
		teammates = {},
		previousC4 = {}
	}).teammates),
	auto_team = slot62(slot101[0], slot101[1], "Automatically choose team", "Spectator", "Terrorist", "Counter-Terrorist")
}
slot103 = {
	enable_aa = slot63("AA", "Anti-aimbot angles", "Enabled"),
	aa_pitch = slot63("AA", "Anti-aimbot angles", "Pitch"),
	easy_strafe = slot63("Misc", "Movement", "Easy strafe"),
	saveconfig = slot63("Config", "Presets", "Save"),
	loadconfig = slot63("Config", "Presets", "Load")
}
slot104 = {
	AVOID = 128,
	WALK = 64,
	RUN = 32,
	STOP = 16,
	NO_JUMP = 8,
	PRECISE = 4,
	JUMP = 2,
	CROUCH = 1,
	NAV_BLOCKER = 2147483648.0,
	HAS_ELEVATOR = 1073741824,
	FUNC_COST = 536870912,
	LAST_CUSTOM = 67108864,
	FIRST_CUSTOM = 65536,
	CLIFF = 32768,
	OBSTACLE_TOP = 16384,
	NO_MERGE = 8192,
	STAIRS = 4096,
	NO_HOSTAGES = 2048,
	STAND = 1024,
	DONT_HIDE = 512,
	TRANSIENT = 256
}
slot105 = {
	IN_SCORE = 65536,
	IN_ALT2 = 32768,
	IN_ALT1 = 16384,
	IN_RELOAD = 8192,
	IN_RUN = 4096,
	IN_ATTACK2 = 2048,
	IN_MOVERIGHT = 1024,
	IN_MOVELEFT = 512,
	IN_RIGHT = 256,
	IN_LEFT = 128,
	IN_CANCEL = 64,
	IN_USE = 32,
	IN_BACK = 16,
	IN_FORWARD = 8,
	IN_DUCK = 4,
	IN_JUMP = 2,
	IN_ATTACK = 1,
	IDLE = 0,
	IN_WALK = 131072
}
slot106 = inf
slot107 = nil

function slot108(slot0, slot1)
	return math.sqrt(math.pow(slot1.x - slot0.x, 2) + math.pow(slot1.y - slot0.y, 2) + math.pow(slot1.z - slot0.z, 2))
end

function slot109(slot0, slot1)
	if uv0(slot0, slot1) - 5 * slot0.encounter_paths_count < 0 then
		slot2 = 0
	end

	return slot2
end

function slot110(slot0, slot1)
	return true
end

function slot111(slot0, slot1)
	slot3 = nil

	for slot7, slot8 in ipairs(slot0) do
		if slot1[slot8] < uv0 then
			slot3 = slot8
			slot2 = slot9
		end
	end

	return slot3
end

function slot112(slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot1) do
		if slot0 ~= slot7 and uv0(slot0, slot7) then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

function slot113(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

function slot114(slot0)
	for slot5, slot6 in pairs(slot0) do
		if type(slot5) == "string" then
			slot1 = "\n{" .. "[\"" .. slot5 .. "\"]" .. "="
		end

		slot1 = (type(slot6) == "table" and slot1 .. uv0(slot6) or type(slot6) == "boolean" and slot1 .. tostring(slot6) or slot1 .. "\"" .. slot6 .. "\"") .. ",\n"
	end

	if slot1 ~= "" then
		slot1 = slot1:sub(1, slot1:len() - 1)
	end

	return slot1 .. "}\n"
end

function slot115(slot0, slot1)
	for slot5, slot6 in ipairs(slot0) do
		if slot6 == slot1 then
			return false
		end
	end

	return true
end

function slot116(slot0, slot1)
	for slot5, slot6 in ipairs(slot0) do
		if slot6 == slot1 then
			slot0[slot5] = slot0[#slot0]
			slot0[#slot0] = nil

			break
		end
	end
end

function slot117(slot0, slot1, slot2)
	if slot1[slot2] then
		table.insert(slot0, 1, slot1[slot2])

		return uv0(slot0, slot1, slot1[slot2])
	else
		return slot0
	end
end

function slot118(slot0, slot1, slot2, slot3)
	slot4 = {}
	slot5 = {
		slot0
	}
	slot6 = {}

	if slot3 then
		uv0 = slot3
	end

	slot8 = {
		[slot0] = ({
			[slot0] = 0
		})[slot0] + uv1(slot0, slot1)
	}

	while #slot5 > 0 do
		if uv2(slot5, slot8) == slot1 then
			slot10 = uv3({}, slot6, slot1)

			table.insert(slot10, slot1)

			return slot10
		end

		uv4(slot5, slot9)
		table.insert(slot4, slot9)

		for slot14, slot15 in ipairs(uv5(slot9, slot2)) do
			if uv6(slot4, slot15) then
				slot16 = slot7[slot9] + uv7(slot9, slot15)

				if uv6(slot5, slot15) or slot16 < slot7[slot15] then
					slot6[slot15] = slot9
					slot7[slot15] = slot16
					slot8[slot15] = slot7[slot15] + uv1(slot15, slot1)

					if uv6(slot5, slot15) then
						table.insert(slot5, slot15)
					end
				end
			end
		end
	end

	return nil
end

function slot119()
	uv0 = nil
end

function slot120(slot0, slot1, slot2, slot3, slot4)
	if not uv0 then
		uv0 = {}
	end

	if not uv0[slot0] then
		uv0[slot0] = {}
	elseif uv0[slot0][slot1] and not slot3 then
		return uv0[slot0][slot1]
	end

	slot5 = uv1(slot0, slot1, slot2, slot4)

	if not uv0[slot0][slot1] and not slot3 then
		uv0[slot0][slot1] = slot5
	end

	return slot5
end

function slot121(slot0, slot1)
	return (slot0 + slot1) / 2
end

function slot122(slot0, slot1)
	return math.sqrt(math.pow(slot1 - slot0, 2))
end

function slot123(slot0, slot1, slot2, slot3)
	return math.sqrt(math.pow(slot2 - slot0, 2) + math.pow(slot3 - slot1, 2))
end

function slot124(slot0, slot1, slot2, slot3, slot4, slot5)
	return math.sqrt(math.pow(slot3 - slot0, 2) + math.pow(slot4 - slot1, 2) + math.pow(slot5 - slot2, 2))
end

function slot125(slot0)
	return math.floor(slot0 / uv0() + 0.5)
end

function slot126(slot0, slot1, slot2, slot3, slot4)
	return slot0[1] <= slot3 and slot1 <= slot0[1] and slot0[2] <= slot4 and slot2 <= slot0[2]
end

function slot127(slot0, slot1, slot2, slot3)
	return slot1 + math.cos(math.rad(slot3)) * slot0, slot2 + math.sin(math.rad(slot3)) * slot0
end

function slot128(slot0)
	while slot0 < 0 do
		slot0 = slot0 + 360
	end

	while slot0 > 360 or slot0 == 360 do
		slot0 = slot0 - 360
	end

	return slot0
end

function slot129()
	uv0.graph = {}
	uv0.path = nil
	uv0.waypoint = {}
	uv0.ignoreConnection = {}
	uv0.forbiddenWaypoint = {}
end

function slot130()
	uv0.planted = false
	uv0.stand = false
	uv0.goingC4 = false
	uv0.carrier = false
	uv0.unscope = false
	uv0.previousC4 = {}
end

function slot131(slot0, slot1, slot2, slot3, slot4, slot5)
	slot6, slot7, slot8, slot9, slot10, slot11 = nil

	if slot3 == nil then
		slot11 = slot2
		slot10 = slot1
		slot9 = slot0
		slot12, slot7, slot8 = uv0()

		if slot12 == nil then
			return
		end
	else
		slot8 = slot2
		slot7 = slot1
		slot6 = slot0
		slot11 = slot5
		slot10 = slot4
		slot9 = slot3
	end

	if slot9 - slot6 == 0 and slot10 - slot7 == 0 then
		return slot11 - slot8 > 0 and 270 or 90, 0
	else
		return math.deg(math.atan2(-slot14, math.sqrt(math.pow(slot12, 2) + math.pow(slot13, 2)))), math.deg(math.atan2(slot13, slot12))
	end
end

function slot132(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
	uv0(slot0, slot1, slot2, 0, 0, 0, 150, slot7 + 1, 0, 1)
	uv0(slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, 0, 1)
end

function slot133()
	if uv0() == nil then
		return nil
	end

	slot1, slot2, slot3 = uv1(slot0)

	if slot1 == nil then
		return nil
	end

	return slot1, slot2, slot3
end

function slot134()
	if uv0.navmesh_raw ~= nil then
		for slot3, slot4 in ipairs(uv0.navmesh.areas) do
			uv0.graph[slot3] = slot4
			uv0.graph[slot3].x = uv1(slot4.north_west.x, slot4.south_east.x)
			uv0.graph[slot3].y = uv1(slot4.north_west.y, slot4.south_east.y)
			uv0.graph[slot3].z = uv1(slot4.north_east_z, slot4.south_west_z)
		end
	end
end

function slot136(slot0)
	slot1, slot2 = uv0(c, slot0.x, slot0.y, slot0.z)

	if slot1 ~= nil then
		if bit.band(slot0.flags, uv1.JUMP) == uv1.JUMP then
			slot3 = "" .. "JUMP:"
		end

		if bit.band(slot0.flags, uv1.WALK) == uv1.WALK then
			slot3 = slot3 .. "WALK:"
		end

		if bit.band(slot0.flags, uv1.CROUCH) == uv1.CROUCH then
			slot3 = slot3 .. "CROUCH:"
		end

		if bit.band(slot0.flags, uv1.PRECISE) == uv1.PRECISE then
			slot3 = slot3 .. "PRECISE:"
		end

		if bit.band(slot0.flags, uv1.NO_JUMP) == uv1.NO_JUMP then
			slot3 = slot3 .. "NO_JUMP:"
		end

		if bit.band(slot0.flags, uv1.AVOID) == uv1.AVOID then
			slot3 = slot3 .. "AVOID:"
		end

		if bit.band(slot0.flags, uv1.TRANSIENT) == uv1.TRANSIENT then
			slot3 = slot3 .. "TRANSIENT:"
		end

		if bit.band(slot0.flags, uv1.OBSTACLE_TOP) == uv1.OBSTACLE_TOP then
			slot3 = slot3 .. "OBSTACLE_TOP:"
		end

		if bit.band(slot0.flags, uv1.CLIFF) == uv1.CLIFF then
			slot3 = slot3 .. "CLIFF:"
		end

		if bit.band(slot0.flags, uv1.STAIRS) == uv1.STAIRS then
			slot3 = slot3 .. "STAIRS:"
		end

		if bit.band(slot0.flags, uv1.NO_MERGE) == uv1.NO_MERGE then
			slot3 = slot3 .. "NO_MERGE:"
		end

		if bit.band(slot0.flags, uv1.FIRST_CUSTOM) == uv1.FIRST_CUSTOM then
			slot3 = slot3 .. "FIRST_CUSTOM:"
		end

		if bit.band(slot0.flags, uv1.LAST_CUSTOM) == uv1.LAST_CUSTOM then
			slot3 = slot3 .. "LAST_CUSTOM:"
		end

		if bit.band(slot0.flags, uv1.FUNC_COST) == uv1.FUNC_COST then
			slot3 = slot3 .. "FUNC_COST:"
		end

		if bit.band(slot0.flags, uv1.HAS_ELEVATOR) == uv1.HAS_ELEVATOR then
			slot3 = slot3 .. "HAS_ELEVATOR:"
		end

		if bit.band(slot0.flags, uv1.NAV_BLOCKER) == uv1.NAV_BLOCKER then
			slot3 = slot3 .. "NAV_BLOCKER:"
		end

		uv2(c, slot1, slot2, 255, 255, 255, 255, "c", 0, slot3)
	end
end

function slot137(slot0, slot1)
	for slot5, slot6 in ipairs(uv0.ignoreConnection) do
		if slot6.id == slot1.id then
			return false
		end
	end

	if bit.band(slot1.flags, uv1.OBSTACLE_TOP) == uv1.OBSTACLE_TOP then
		return false
	end

	for slot5, slot6 in ipairs(slot0.connections) do
		for slot10, slot11 in ipairs(slot6.connections) do
			if slot11 == slot1.id then
				return true
			end
		end
	end

	return false
end

function slot138(slot0)
	for slot4, slot5 in ipairs(uv0.graph) do
		if slot5.id == slot0 then
			return slot4
		end
	end

	return 1
end

function slot139(slot0)
	slot1, slot2, slot3 = uv0()

	if slot1 == nil then
		return
	end

	if uv1(slot0.x, slot0.y, slot0.z, slot1, slot2, slot3) > 500 then
		return
	end

	slot4, slot5 = uv2(c, slot0.x, slot0.y, slot0.z)

	uv3(slot0)

	slot6, slot7 = uv2(c, slot0.north_west.x, slot0.north_west.y, slot0.north_west.z)
	slot8, slot9 = uv2(c, slot0.south_east.x, slot0.south_east.y, slot0.south_east.z)
	slot10, slot11 = uv2(c, slot0.south_east.x, slot0.north_west.y, slot0.north_east_z)
	slot12, slot13 = uv2(c, slot0.north_west.x, slot0.south_east.y, slot0.south_west_z)

	uv4(c, slot6, slot7, slot10, slot11, 0, 0, 0, 255)
	uv4(c, slot12, slot13, slot8, slot9, 0, 0, 0, 255)
	uv4(c, slot6, slot7, slot12, slot13, 0, 0, 0, 255)
	uv4(c, slot10, slot11, slot8, slot9, 0, 0, 0, 255)
end

function slot140(slot0, slot1, slot2)
	slot3 = uv0.graph[1]

	for slot7, slot8 in ipairs(uv0.graph) do
		if uv1(slot8.x, slot8.y, slot8.z, slot0, slot1, slot2) < uv1(slot3.x, slot3.y, slot3.z, slot0, slot1, slot2) then
			slot3 = slot8
		end
	end

	return slot3
end

function slot141()
	if uv0.path ~= nil then
		slot0 = nil

		for slot4, slot5 in ipairs(uv0.path) do
			slot6, slot7 = uv1(c, slot5.x, slot5.y, slot5.z)
			slot8, slot9 = nil

			if slot0 ~= nil then
				slot8, slot9 = uv1(c, slot0.x, slot0.y, slot0.z)
			end

			if slot6 ~= nil and uv2(uv3(uv4.option_type), "Show Path") then
				slot10, slot11, slot12, slot13 = uv3(uv4.pathcolor)

				uv5(c, slot6, slot7, slot10, slot11, slot12, slot13, 2)

				if slot8 ~= nil then
					uv6(c, slot6, slot7, slot8, slot9, slot10, slot11, slot12, slot13)
				end
			end

			slot0 = slot5
		end
	end

	if uv0.waypoint[1] ~= nil then
		slot0 = uv7(uv0.waypoint[1], uv0.waypoint[2], uv0.waypoint[3])
		slot1 = 15
		slot2 = 5
		slot3, slot4 = uv1(c, slot0.x, slot0.y, slot0.z)

		if slot3 ~= nil then
			slot5 = 1

			renderer.triangle(slot3 - slot2 - slot5, slot4 - slot1 - slot5, slot3 + slot2 + slot5, slot4 - slot1 - slot5, slot3, slot4 + slot5, 0, 0, 0, 250)
			renderer.triangle(slot3 - slot2, slot4 - slot1, slot3 + slot2, slot4 - slot1, slot3, slot4, 219, 50, 54, 255)
			uv5(c, slot3, slot4 - slot1, 219, 50, 54, 255, slot2)
			uv5(c, slot3, slot4 - slot1, 100, 50, 54, 255, 1)
		end
	end
end

function slot142()
	if not uv0(uv1(uv2.option_type), "Debug Panel") then
		return
	end

	slot0, slot1 = uv3()
	p_1_size_w, p_1_size_h = renderer.measure_text("", "walkbot debug")

	renderer.text(10, slot1 / 2.15, 255, 255, 255, 230, "", 0, "walkbot debug")

	slot2 = p_1_size_h

	if uv4.target_name:len() > 10 then
		slot3 = string.sub(slot3, 0, 10)
	end

	slot4, slot5, slot6 = unpack(uv5.waypoint)
	slot7, slot8, slot9 = uv6()

	if uv4.goingC4 then
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target: bomb_dropped")

		slot2 = slot2 + p_1_size_h
	elseif uv4.planted then
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target: bomb_planted")

		slot2 = slot2 + p_1_size_h
	elseif uv4.carrier then
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target: going to bombsite")

		slot2 = slot2 + p_1_size_h

		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target_bombsite: ", uv4.target_bombsite)

		slot2 = slot2 + p_1_size_h
	elseif uv4.target_name == "unknown" or uv4.target_name == "" or uv4.target_name == nil then
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target: random place in the map")

		slot2 = slot2 + p_1_size_h
	else
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target: ", uv4.target_name)

		slot2 = slot2 + p_1_size_h
	end

	if not uv4.carrier then
		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "target_origin: ", slot4, " ", slot5, " ", slot6)

		slot2 = slot2 + p_1_size_h

		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "current_origin: ", slot7, " ", slot8, " ", slot9)

		slot2 = slot2 + p_1_size_h
		p_2_size_w, p_2_size_h = renderer.measure_text("", "current stance: ")

		renderer.text(10, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, "current stance: ")
		renderer.text(10 + p_2_size_w, slot1 / 2.15 + slot2, 255, 255, 255, 230, "", 0, uv5.debug_stance)

		slot2 = slot2 + p_1_size_h
	end
end

function slot143(slot0, slot1, slot2, slot3, slot4, slot5)
	if slot0 == nil or slot3 == nil then
		uv0.path = nil
	else
		slot8 = uv2(uv1(slot0, slot1, slot2).id)
		slot9 = uv2(uv1(slot3, slot4, slot5).id)

		for slot13, slot14 in ipairs(uv0.forbiddenWaypoint) do
			if slot14.id == slot7.id then
				uv0.path = nil

				return
			end
		end

		if slot8 ~= -1 and slot9 ~= -1 then
			uv0.path = uv3(uv0.graph[slot8], uv0.graph[slot9], uv0.graph, false, uv4)

			if uv0.path == nil then
				table.insert(uv0.forbiddenWaypoint, slot7)
			end
		end
	end

	if uv5(uv6(uv7.option_type), "Debug Panel") then
		uv0.debug_stance = "calculate_path"
	end

	if uv8.debug then
		print("calculate_path")
	end
end

function slot144()
	uv0.lastPointRemoved = uv1.path[1]

	table.remove(uv1.path, 1)

	uv0.lastStuckHandleTick = uv2()

	if #uv1.path <= 0 then
		uv1.waypoint = {}
	end
end

function slot145(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	return (slot3 - slot0) * slot6 + slot0, (slot4 - slot1) * slot6 + slot1, (slot5 - slot2) * slot6 + slot2
end

function slot146(slot0)
	slot1, slot2, slot3 = uv0(uv1(), "m_bombsiteCenterA")
	slot4, slot5, slot6 = uv0(uv1(), "m_bombsiteCenterB")
	slot7, slot8, slot9 = uv0(slot0, "m_vecMins")
	slot10, slot11, slot12 = uv0(slot0, "m_vecMaxs")
	slot13, slot14, slot15 = uv2(slot7, slot8, slot9, slot10, slot11, slot12, 0.5)

	return uv3(slot13, slot14, slot15, slot1, slot2, slot3) < uv3(slot13, slot14, slot15, slot4, slot5, slot6) and "A" or "B"
end

function slot147()
	slot0, slot1, slot2 = uv0()

	if slot0 == nil then
		return
	end

	for slot7 = 1, uv1() do
		if uv2(slot7) == "CCSPlayer" and uv3(slot7) and uv4(slot7) and uv5(slot7) ~= nil then
			if nil == nil then
				slot3 = slot7
			else
				slot8, slot9, slot10 = uv5(slot7)
				slot11, slot12, slot13 = uv5(slot3)

				if uv6(slot0, slot1, slot2, slot11, slot12, slot13) <= 100 or uv6(slot0, slot1, slot2, slot8, slot9, slot10) <= 100 then
					return
				elseif uv6(slot0, slot1, slot2, slot8, slot9, slot10) < uv6(slot0, slot1, slot2, slot11, slot12, slot13) then
					slot3 = slot7
				end
			end
		end
	end

	uv7.target_name = uv8(slot3)

	return slot3
end

function slot148(slot0)
	slot1, slot2, slot3 = uv0()

	if slot1 == nil then
		return
	end

	slot7 = slot2
	slot8 = slot0
	slot1, slot2 = uv1(20, slot1, slot7, slot8)

	for slot7, slot8 in ipairs(uv2.graph) do
		if uv3({
			slot1,
			slot2
		}, slot8.north_west.x, slot8.north_west.y, slot8.south_east.x, slot8.south_east.y) then
			return slot8
		end
	end
end

function slot149(slot0)
	slot1, slot2, slot3 = uv0()

	if slot1 == nil then
		return
	end

	if uv1.path ~= nil and #uv1.path > 0 then
		if uv2(uv3.easy_strafe) == false then
			uv4(uv3.easy_strafe, true)
		end

		slot10 = uv1.path[1].z
		slot4, slot5 = uv5(slot1, slot2, slot3, uv1.path[1].x, uv1.path[1].y, slot10)
		slot0.move_yaw = uv6(slot5)

		for slot10 = 1, #uv2(uv7.option_type) do
			if slot6[slot10] == "Lock view angle" then
				slot0.yaw = slot5

				uv4(uv3.enable_aa, true)
			end
		end

		slot0.buttons = bit.bor(slot0.buttons, uv8.IN_FORWARD)
		slot0.forwardmove = 450

		if uv9(slot1, slot2, slot3, uv1.path[1].x, uv1.path[1].y, uv1.path[1].z) < 50 then
			if bit.band(uv1.graph[uv10(uv1.path[1].id)].flags, uv11.JUMP) == uv11.JUMP then
				slot0.buttons = bit.bor(slot0.buttons, uv8.IN_JUMP, uv8.IN_DUCK)
			elseif bit.band(uv1.graph[uv10(uv1.path[1].id)].flags, uv11.CROUCH) == uv11.CROUCH then
				slot0.buttons = bit.bor(slot0.buttons, uv8.IN_DUCK)
			end
		end

		if uv12(slot5) ~= nil and bit.band(uv1.graph[uv10(slot7.id)].flags, uv11.CROUCH) == uv11.CROUCH then
			slot0.buttons = bit.bor(slot0.buttons, uv8.IN_DUCK)
		end

		for slot12, slot13 in ipairs(uv13("CDynamicProp")) do
			slot14, slot15, slot16 = uv14(slot13)

			if uv9(slot14, slot15, slot16, slot1, slot2, slot3) < 50 then
				slot0.yaw = slot5
				slot0.buttons = bit.bor(slot0.buttons, uv8.IN_ATTACK)
			end
		end

		for slot13, slot14 in ipairs(uv13("CPropDoorRotating")) do
			slot15 = {
				uv14(slot14)
			}
			slot15[3] = slot15[3] + 50

			if uv9(slot1, slot2, slot3 + 50, slot15[1], slot15[2], slot15[3]) < 50 then
				slot16, slot17, slot18 = uv15(50, slot1, slot2, slot5)

				if uv16(uv17(), slot1, slot2, slot3 + 50, slot16, slot17, slot3 + 50) < 0.9 then
					slot0.buttons = bit.bor(slot0.buttons, uv8.IN_USE)
				end
			end
		end
	end
end

function slot150()
	slot0, slot1, slot2 = uv0()

	if slot0 == nil then
		return
	end

	uv1.waypoint = {
		slot0,
		slot1,
		slot2
	}
end

function slot151()
	slot2 = {}

	for slot6 = 1, uv2() do
		if uv1(uv3(), "m_bConnected", slot6) == 1 and uv1(slot6, "m_iTeamNum") == uv1(uv0(), "m_iTeamNum") and slot6 ~= slot0 then
			table.insert(slot2, uv4(slot6))
		end
	end

	uv5.teammates = slot2
end

function slot152()
	if uv0.stand or uv0.planted or uv0.goingC4 or uv0.carrier then
		return
	end

	if uv1.follow_target ~= nil and uv2(uv1.follow_target) then
		slot0, slot1, slot2 = uv3(uv1.follow_target)
		uv1.waypoint = {
			slot0,
			slot1,
			slot2
		}

		if uv4(uv5(uv6.option_type), "Debug Panel") then
			uv1.debug_stance = "set_waypoint_teammate"
		end

		if uv0.debug then
			print("set_waypoint_teammate")
		end
	end
end

function slot153()
	slot0, slot1, slot2 = uv0()

	if slot0 == nil then
		return
	end

	if uv1() ~= nil then
		slot4, slot5, slot6 = uv2(slot3)
		uv3.waypoint = {
			slot4,
			slot5,
			slot6
		}
	end

	return slot3
end

function slot154()
	slot0, slot1, slot2 = uv0()

	if slot0 == nil then
		return
	end

	if uv1.graph ~= nil and #uv1.graph > 0 then
		slot3 = uv1.graph[uv2(1, #uv1.graph)]
		uv1.waypoint = {
			slot3.x,
			slot3.y,
			slot3.z
		}
	end

	if uv3(uv4(uv5.option_type), "Debug Panel") then
		uv1.debug_stance = "set_waypoint_rand"
	end

	if uv6.debug then
		print("set_waypoint_rand")
	end
end

function slot155()
	if uv0(uv1.team_target) == nil then
		return
	end

	for slot3 = 1, uv2() do
		if uv3(slot3) ~= nil and slot4 == uv4.teammates[uv0(uv1.team_target) + 1] then
			uv5.follow_target = slot3
		end
	end
end

function slot156()
	slot0, slot1, slot2 = uv0()

	if slot0 == nil then
		return
	end

	uv1(slot0, slot1, slot2, uv2.waypoint[1], uv2.waypoint[2], uv2.waypoint[3])
end

function slot157()
	uv0.ignoreConnection = {}

	if uv1.stand or uv1.planted or uv1.goingC4 or uv1.carrier then
		return
	end

	if uv2() == nil and uv3(uv4(uv5.option_type), "Rand waypt if no enemy") then
		uv6()

		if uv3(uv4(uv5.option_type), "Debug Panel") then
			uv0.debug_stance = "handle_closest_enemy rand_way_no_enemy"
		end

		if uv1.debug then
			print("handle_closest_enemy rand_way_no_enemy")
		end
	end

	if uv3(uv4(uv5.option_type), "Debug Panel") then
		uv0.debug_stance = "handle_closest_enemy set_pathway"
	end

	if uv1.debug then
		print("handle_closest_enemy set_pathway")
	end

	uv7()
end

function ()
	if uv0() == nil then
		return
	end

	uv1()

	if uv2.sourcenav == nil then
		uv3("please subscribe to https://gamesense.pub/forums/viewtopic.php?id=18492")

		return
	end

	uv4.currMap = uv5()
	uv2.navmesh_raw = nil
	uv2.navmesh_raw = readfile("csgo/maps/" .. uv4.currMap .. ".nav")

	if uv2.navmesh_raw ~= nil then
		uv2.navmesh = uv2.sourcenav.parse(uv2.navmesh_raw)

		uv6()
	else
		uv3("navigation mesh not found, please run 'nav_generate' in console")
	end
end()

function slot159(slot0)
	if uv0(uv1(), "m_bFreezePeriod") == 1 then
		return
	end

	if uv2.stuckAttempts == 0 then
		slot0.buttons = bit.bor(slot0.buttons, uv3.IN_JUMP)
		uv2.stuckAttempts = uv2.stuckAttempts + 1

		if uv4(uv5(uv6.option_type), "Debug Panel") then
			uv7.debug_stance = "handle_stuck IN_JUMP"
		end

		if uv8.debug then
			print("handle_stuck IN_JUMP")
		end
	elseif uv2.stuckAttempts == 1 then
		table.insert(uv7.ignoreConnection, uv7.path[1])
		uv9(0.1, uv10)

		uv2.stuckAttempts = uv2.stuckAttempts + 1

		if uv4(uv5(uv6.option_type), "Debug Panel") then
			uv7.debug_stance = "handle_stuck set_pathway"
		end

		if uv8.debug then
			print("handle_stuck set_pathway")
		end
	else
		if uv5(uv6.target_type) == "Closest enemy" then
			uv11()

			if uv4(uv5(uv6.option_type), "Debug Panel") then
				uv7.debug_stance = "handle_stuck handle_closest_enemy"
			end

			if uv8.debug then
				print("handle_stuck handle_closest_enemy")
			end
		elseif uv5(uv6.target_type) == "Teammate" then
			uv12()

			if uv4(uv5(uv6.option_type), "Debug Panel") then
				uv7.debug_stance = "handle_stuck handle_teammate"
			end

			if uv8.debug then
				print("handle_stuck handle_teammate")
			end
		elseif uv5(uv6.target_type) == "Waypoint" then
			if database.read("walkbot_db")[uv13()] ~= nil then
				uv7.waypoint = slot1

				uv9(0.1, uv10)
			else
				print("No waypoint detected for this map")

				if uv4(uv5(uv6.option_type), "Debug Panel") then
					uv7.debug_stance = "no waypoint detected for this map"
				end
			end

			if uv4(uv5(uv6.option_type), "Debug Panel") then
				uv7.debug_stance = "handle_stuck handle_waypoint"
			end

			if uv8.debug then
				print("handle_stuck handle_waypoint")
			end
		end

		uv9(0.1, uv10)

		uv2.stuckAttempts = 0
	end

	uv2.lastStuckHandleTick = uv14()
end

function slot160()
	slot0, slot1, slot2 = nil

	if uv0("CPlantedC4")[1] == nil then
		if uv3(uv2(uv1(), "m_iPlayerC4")) == "CCSPlayer" and not uv4(slot5) then
			slot3 = slot5
		end

		if slot3 == nil and planting_site ~= nil then
			slot0, slot1, slot2 = uv2(slot4, "m_bombsiteCenter" .. planting_site)
		end
	end

	if slot3 ~= nil then
		slot0, slot1, slot2 = uv2(slot3, "m_vecOrigin")
	end

	return slot0, slot1, slot2
end

function slot161()
	if uv1(uv0("CPlantedC4")[1], "m_flC4Blow") == nil then
		return
	end

	slot1 = uv1(slot0, "m_flC4Blow") - uv2()

	if slot0 == nil or slot1 == nil then
		return 0
	end

	if slot1 > 0 then
		return slot1
	end
end

function slot162(slot0)
	if slot0 == 64 then
		if uv0(uv1(), "m_bHasDefuser") == 0 then
			return 10.03125
		end

		return 5.03125
	elseif slot0 == 128 then
		if uv0(uv1(), "m_bHasDefuser") == 0 then
			return 10.0234375
		end

		return 5.0234375
	end
end

function slot171(slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv3()) == false then
		return
	end

	if uv4(uv0(uv1.option_automation), "Follow bomb_begindefuse") then
		slot1 = uv0(uv1.target_type)

		if uv5(slot0.userid) ~= uv3() then
			if slot1 == "Closest enemy" or slot1 == "Teammate" then
				slot2, slot3, slot4 = nil
				slot5, slot6, slot7 = uv6(uv5(slot0.userid))
				uv7.waypoint = {
					slot5,
					slot6,
					slot7
				}

				uv8(0.1, uv9)

				if uv4(uv0(uv1.option_type), "Debug Panel") then
					uv7.debug_stance = "on_bomb_begindefuse set_pathway"
				end

				if uv10.debug then
					print("on_bomb_begindefuse set_pathway | ", slot2, " ", slot3, " ", slot4)
				end
			end
		else
			return
		end
	end
end

function slot174()
	uv0.carrier = false

	if not uv1(uv2.enable) then
		return
	end

	if uv3(uv4()) == false then
		return
	end

	if uv5(uv1(uv2.option_automation), "Follow bomb_dropped") then
		slot1, slot2, slot3 = nil

		for slot7, slot8 in ipairs(uv6("CC4")) do
			slot9, slot2, slot3 = uv7(slot8, "m_vecOrigin")

			if slot9 ~= nil and slot2 ~= nil and slot3 ~= nil then
				if slot1 and slot2 and slot3 == 0 then
					uv0.goingC4 = false

					return
				end

				uv8.previousWaypoint = uv8.waypoint
				uv8.waypoint = {
					slot1,
					slot2,
					slot3
				}

				uv9(0.1, uv10)

				uv0.goingC4 = true

				if uv5(uv1(uv2.option_type), "Debug Panel") then
					uv8.debug_stance = "on_bomb_dropped going_c4"
				end

				if uv0.debug then
					print("on_bomb_dropped going_c4 | ", slot1, " ", slot2, " ", slot3)
				end
			else
				uv9(0.5, uv11)

				if uv5(uv1(uv2.option_type), "Debug Panel") then
					uv8.debug_stance = "c4 nil, looping again"
				end

				if uv0.debug then
					print("c4 nil, looping again")
				end
			end
		end
	end
end

function slot176(slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv0(uv1.option_type), "Debug Panel") then
		uv3.debug_stance = "on_teamchange generate_teammates"
	end

	if uv4.debug then
		print("on_teamchange generate_teammates")
	end

	uv5()
	uv6(uv1.team_target, uv4.teammates)
end

function slot177(slot0)
	uv0(uv1.calculate_path, slot0)
	uv0(uv1.remove_point, slot0)
	uv0(uv1.end_waypoint, slot0)
end

function slot178()
	if uv0(uv1.enable) then
		uv2(uv1.target_type, true)
		uv2(uv1.option_type, true)

		if uv0(uv1.target_type) == "Waypoint" then
			uv3(true)
			uv2(uv1.team_target, false)
			uv2(uv1.option_automation, false)
			uv2(uv1.plant_slider, false)
			uv2(uv1.pathlabel, false)
			uv2(uv1.pathcolor, false)
			uv2(uv1.auto_team, false)
		elseif slot0 == "Closest enemy" then
			uv2(uv1.team_target, false)
		elseif slot0 == "Teammate" then
			uv3(false)
			uv4()
			uv5(uv1.team_target, uv6.teammates)
			uv2(uv1.team_target, true)

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv8.debug_stance = "handle_menu generate_teammates"
			end

			if uv6.debug then
				print("handle_menu generate_teammates")
			end
		end

		if slot0 == "Teammate" or slot0 == "Closest enemy" then
			uv3(false)
			uv2(uv1.calculate_path, true)
			uv2(uv1.option_automation, true)

			if uv7(uv0(uv1.option_type), "Show Path") then
				uv2(uv1.pathlabel, true)
				uv2(uv1.pathcolor, true)
			else
				uv2(uv1.pathlabel, false)
				uv2(uv1.pathcolor, false)
			end

			if uv7(uv0(uv1.option_automation), "Auto plant") then
				uv2(uv1.plant_slider, true)
			else
				uv2(uv1.plant_slider, false)
			end

			if uv7(uv0(uv1.option_automation), "Auto team join") then
				uv2(uv1.auto_team, true)
			else
				uv2(uv1.auto_team, false)
			end
		end
	else
		for slot3, slot4 in pairs(uv1) do
			uv2(slot4, false)
		end

		uv2(uv1.enable, true)
	end
end

slot78(slot102.enable, slot178)
slot78(slot102.target_type, slot178)
slot78(slot102.option_type, slot178)
slot78(slot102.option_automation, slot178)
slot178()
slot88("paint", function (slot0)
	if not uv0(uv1.enable) or uv2.navmesh_raw == nil then
		return
	end

	uv3()
	uv4()
end)
slot88("setup_command", function (slot0)
	if not uv0(uv1.enable) or uv2.navmesh_raw == nil then
		return
	end

	if uv3(uv4()) == false then
		return
	end

	if not uv5.currMap == uv6() then
		uv7()

		return
	end

	slot1 = uv4()
	slot3 = uv8(slot1, "m_bIsScoped")

	if not uv8(uv9(slot1), "m_zoomLevel") then
		uv5.unscope = false
	elseif slot2 > 0 and uv5.unscope then
		if slot3 > 0 then
			slot0.in_attack2 = 1

			if uv10(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "un_scope"
			end

			if uv5.debug then
				print("un_scope")
			end
		else
			client.exec("slot5;slot4;slot3;slot2")
			client.delay_call(9e-12, client.exec, "slot1")

			if uv10(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "quick_swap"
			end

			if uv5.debug then
				print("quick_swap")
			end
		end
	else
		uv5.unscope = false
	end

	if uv0(uv1.target_type) == "Waypoint" then
		if uv0(uv1.end_waypoint) then
			uv11()

			slot5 = database.read("walkbot_db") or {}
			slot5[uv6()] = uv2.waypoint

			database.write("walkbot_db", slot5)
		end

		if uv0(uv1.calculate_path) then
			uv12()
		end
	elseif slot4 == "Closest enemy" then
		if uv2.path == nil or #uv2.path <= 0 then
			if uv5.previousC4 == nil then
				on_bomb_planted()

				return
			end

			if uv5.planted == false and uv10(uv0(uv1.option_automation), "Auto plant") and uv8(70, "m_iPlayerC4") == 1 and bit.band(uv8(slot1, "m_fFlags"), 1) == 1 and uv8(slot1, "m_bInBombZone") == 1 then
				slot0.in_use = 1

				if uv10(uv0(uv1.option_type), "Debug Panel") then
					uv2.debug_stance = "c4_planting auto_plant"
				end

				if uv5.debug then
					print("c4_planting auto_plant")
				end

				return
			elseif uv5.planted == true and uv10(uv0(uv1.option_automation), "Auto defuse") and uv13() ~= nil and uv13() > 0 and uv8(slot1, "m_iTeamNum") == 3 and bit.band(uv8(slot1, "m_fFlags"), 1) == 1 then
				slot5 = 1 / uv14()
				slot6, slot7, slot8 = uv15()
				slot9, slot10, slot11 = uv8(slot1, "m_vecOrigin")

				if uv13() >= uv17(slot5) - uv18() / slot5 and uv16(slot6, slot7, slot8, slot9, slot10, slot11) < 61.88 then
					if uv5.aa == false then
						uv5.previousAA = uv0(uv19.enable_aa)
						uv5.previousPitch = uv0(uv19.aa_pitch)
						uv5.aa = true
					end

					uv20(uv19.enable_aa, true)
					uv20(uv19.aa_pitch, "Down")

					slot0.in_use = 1

					if uv10(uv0(uv1.option_type), "Debug Panel") then
						uv2.debug_stance = "defusing_c4 auto_defuse"
					end

					if uv5.debug then
						print("defusing_c4 auto_defuse")
					end
				end

				return
			end

			if uv10(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "handle_closest_enemy on_setup_command"
			end

			if uv5.debug then
				print("handle_closest_enemy on_setup_command")
			end

			uv21()
			uv22(0.1, uv12)

			slot0.in_use = 0
		end

		if uv0(uv1.calculate_path) then
			if uv10(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "handle_closest_enemy calculate_path set_pathway on_setup_command"
			end

			if uv5.debug then
				print("handle_closest_enemy calculate_path set_pathway on_setup_command")
			end

			uv21()
			uv12()
		end
	elseif slot4 == "Teammate" then
		if uv2.path == nil or #uv2.path <= 0 then
			if uv23() then
				if uv10(uv0(uv1.option_type), "Debug Panel") then
					uv2.debug_stance = "update_follow_target"
				end

				if uv5.debug then
					print("update_follow_target")
				end

				uv24()
			end

			if uv5.planted == false and uv10(uv0(uv1.option_automation), "Auto plant") and uv8(70, "m_iPlayerC4") == 1 and bit.band(uv8(slot1, "m_fFlags"), 1) == 1 and uv8(slot1, "m_bInBombZone") == 1 then
				slot0.in_use = 1

				if uv10(uv0(uv1.option_type), "Debug Panel") then
					uv2.debug_stance = "set_waypoint_teammate auto_plant"
				end

				if uv5.debug then
					print("set_waypoint_teammate auto_plant")
				end
			elseif uv5.planted == true and uv10(uv0(uv1.option_automation), "Auto defuse") and uv13() ~= nil and uv13() > 0 and uv8(slot1, "m_iTeamNum") == 3 and bit.band(uv8(slot1, "m_fFlags"), 1) == 1 then
				slot5 = 1 / uv14()
				slot6, slot7, slot8 = uv15()
				slot9, slot10, slot11 = uv8(slot1, "m_vecOrigin")

				if uv13() >= uv17(slot5) - uv18() / slot5 and uv16(slot6, slot7, slot8, slot9, slot10, slot11) < 61.88 then
					if uv5.aa == false then
						uv5.previousAA = uv0(uv19.enable_aa)
						uv5.previousPitch = uv0(uv19.aa_pitch)
						uv5.aa = true
					end

					uv20(uv19.enable_aa, true)
					uv20(uv19.aa_pitch, "Down")

					slot0.in_use = 1

					if uv10(uv0(uv1.option_type), "Debug Panel") then
						uv2.debug_stance = "set_waypoint_teammate auto_defuse"
					end

					if uv5.debug then
						print("set_waypoint_teammate auto_defuse")
					end
				end
			end

			if uv5.defused then
				slot0.in_use = 0
			end

			if uv0(uv1.team_target) == nil and uv10(uv0(uv1.option_type), "Rand waypt if no mate") then
				uv25()
				uv22(0.1, uv12)

				if uv10(uv0(uv1.option_type), "Debug Panel") then
					uv2.debug_stance = "rand_way_mate no_mate_selected"
				end

				if uv5.debug then
					print("rand_way_mate no_mate_selected")
				end
			else
				uv26()
				uv22(0.1, uv12)

				if uv10(uv0(uv1.option_type), "Debug Panel") then
					uv2.debug_stance = "set_waypoint_teammate set_pathway"
				end

				if uv5.debug then
					print("set_waypoint_teammate set_pathway")
				end
			end
		end

		if uv0(uv1.calculate_path) then
			uv26()
			uv22(0.1, uv12)

			if uv10(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "set_waypoint_teammate calculate_path set_pathway"
			end

			if uv5.debug then
				print("set_waypoint_teammate calculate_path set_pathway")
			end
		end
	end

	uv27(slot0)

	if uv2.path ~= nil and #uv2.path > 0 then
		slot5, slot6, slot7 = uv28()

		if slot5 == nil then
			return
		end

		if uv16(slot5, slot6, slot7, uv2.path[1].x, uv2.path[1].y, uv2.path[1].z) < 50 or uv0(uv1.remove_point) then
			uv29()
		end

		if uv30.lastStuckHandleTick + uv31(4) < uv32() then
			uv33(slot0)
		end
	end
end)
slot88("round_prestart", function (slot0)
	if not uv0(uv1.enable) or uv2.navmesh_raw == nil then
		return
	end

	uv3()

	if uv4.aa then
		uv5(uv6.enable_aa, uv4.previousAA)
		uv5(uv6.aa_pitch, uv4.previousPitch)

		uv4.aa = false
	end

	if uv7(uv0(uv1.option_type), "Debug Panel") then
		uv2.debug_stance = "on_round_prestart generate_teammates"
	end

	if uv4.debug then
		print("on_round_prestart generate_teammates")
	end

	uv8()
	uv9(uv1.team_target, uv4.teammates)

	if uv0(uv1.target_type) == "Closest enemy" then
		uv10()
	elseif slot1 == "Teammate" then
		uv11()
	end

	uv12(0.1, uv13)

	if uv7(uv0(uv1.option_type), "Debug Panel") then
		uv2.debug_stance = "on_round_prestart set_pathway"
	end

	if uv4.debug then
		print("on_round_prestart set_pathway")
	end
end)
slot88("round_freeze_end", function ()
	uv0(0.1, uv1)
end)
slot88("player_spawn", function (slot0)
	if not uv0(uv1.enable) or uv2.navmesh_raw == nil then
		return
	end

	uv3()

	if uv4(slot0.userid) == uv5() then
		if uv0(uv1.target_type) == "Closest enemy" then
			uv6()

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "on_player_spawn handle_closest_enemy"
			end

			if uv8.debug then
				print("on_player_spawn handle_closest_enemy")
			end
		elseif uv0(uv1.target_type) == "Teammate" then
			uv9()

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "on_player_spawn handle_teammate"
			end

			if uv8.debug then
				print("on_player_spawn handle_teammate")
			end
		elseif uv0(uv1.target_type) == "Waypoint" then
			if database.read("walkbot_db")[uv10()] ~= nil then
				uv2.waypoint = slot1

				uv11(0.1, uv12)
			else
				print("No waypoint detected for this map")
			end

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv2.debug_stance = "on_player_spawn handle_waypoint"
			end

			if uv8.debug then
				print("on_player_spawn handle_waypoint")
			end
		end
	end
end)
slot88("player_connect_full", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(slot0.userid) == uv3() then
		uv4()
		uv5()

		if uv6(uv0(uv1.option_automation), "Auto team join") and uv0(uv1.target_type) ~= "Waypoint" then
			slot2 = nil

			if uv0(uv1.auto_team) == "Spectator" then
				slot2 = 1
			elseif slot1 == "Terrorist" then
				slot2 = 2
			elseif slot1 == "Counter-Terrorist" then
				slot2 = 3
			end

			uv7(0.5, client.exec, "jointeam " .. slot2 .. " 1")

			if uv6(uv0(uv1.option_type), "Debug Panel") then
				uv8.debug_stance = "on_player_connect_full joining " .. slot1
			end

			if uv9.debug then
				print("on_player_connect_full joining ", slot1)
			end
		end

		uv7(1, uv10)
	end
end)
slot88("player_death", function (slot0)
	if not uv0(uv1.enable) or uv2.navmesh_raw == nil then
		return
	end

	if uv4(slot0.userid) == uv3() then
		uv5()
	end

	if uv4(slot0.attacker) == slot1 or uv4(slot0.assister) == slot1 then
		uv6.unscope = true
	end

	if uv6.planted == false and uv0(uv1.target_type) == "Closest enemy" and uv4(slot0.attacker) == slot1 or uv4(slot0.assister) == slot1 then
		uv7()

		if uv8(uv0(uv1.option_type), "Debug Panel") then
			uv2.debug_stance = "on_player_death rand_way_clos_dead"
		end

		if uv6.debug then
			print("on_player_death rand_way_clos_dead")
		end
	elseif uv6.planted == false and uv0(uv1.target_type) == "Teammate" and uv4(slot0.userid) == uv2.follow_target and uv8(uv0(uv1.option_type), "Rand waypt if no mate") then
		uv9()

		if uv8(uv0(uv1.option_type), "Debug Panel") then
			uv2.debug_stance = "on_player_death rand_way_mate_dead"
		end

		if uv6.debug then
			print(uv4(slot0.userid), "|", uv2.follow_target)
		end

		if uv6.debug then
			print("on_player_death rand_way_mate_dead")
		end
	end

	uv10(0.1, uv11)
end)
slot88("player_team", slot176)
slot88("player_disconnect", slot176)
slot88("bomb_planted", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv3()) == false then
		return
	end

	slot1 = uv0(uv1.target_type)
	slot3 = uv4(uv3(), "m_iTeamNum")

	if uv5.carrier then
		uv5.carrier = false

		return
	end

	if uv6(slot0.userid) ~= uv3() then
		uv5.planted = true

		if uv7(uv0(uv1.option_automation), "Auto defuse") and slot3 == 3 then
			slot4, slot5, slot6 = nil
			slot7, slot8, slot9 = uv8()
			uv9.waypoint = {
				slot7,
				slot8,
				slot9
			}

			if uv5.debug then
				print("on_bomb_plant bomb_coords | x:", slot4, " y:", slot5, " z:", slot6)
			end

			if slot4 == nil or slot5 == nil or slot6 == nil then
				if uv5.previousC4 == nil then
					if uv10(slot0.site) == "A" then
						slot7, slot8, slot9 = uv4(uv11(), "m_bombsiteCenterA")
					else
						slot7, slot8, slot9 = uv4(uv11(), "m_bombsiteCenterB")
					end

					uv9.waypoint = {
						siteX,
						siteY,
						siteZ
					}

					if uv7(uv0(uv1.option_type), "Debug Panel") then
						uv10(slot0.site)

						uv9.debug_stance = "on_bomb_plant bomb_coords = nil, going bombsite "
					end

					if uv5.debug then
						print("on_bomb_plant bomb_coords = nil, going bombsite ", uv10(slot0.site))
					end
				else
					uv9.waypoint = uv5.previousC4

					if uv7(uv0(uv1.option_type), "Debug Panel") then
						uv9.debug_stance = "on_bomb_plant bomb_coords = nil, going begin_plantC4_coords"
					end

					if uv5.debug then
						print("on_bomb_plant bomb_coords = nil, going begin_plantC4_coords | ", unpack(uv9.waypoint))
					end
				end
			end

			uv12(0.1, uv13)

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				if uv5.debug then
					uv9.debug_stance = "auto_defuse set_pathway"
				end

				print("auto_defuse set_pathway | ", unpack(uv9.waypoint))
			end
		end
	else
		uv5.goingC4 = false

		if uv7(uv0(uv1.option_automation), "Stand still after plant") and slot3 == 2 then
			uv5.stand = true

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv9.debug_stance = "on_bomb_planted stand_still"
			end

			if uv5.debug then
				print("on_bomb_planted stand_still")
			end
		else
			if slot1 == "Closest enemy" and uv5.defused == true then
				uv14()
			elseif slot1 == "Teammate" and uv5.defused == true then
				uv15()
			end

			uv12(0.1, uv13)

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv9.debug_stance = "on_bomb_planted_going_selection set_pathway"
			end

			if uv5.debug then
				print("on_bomb_planted_going_selection set_pathway")
			end
		end
	end
end)
slot88("bomb_begindefuse", slot171)
slot88("bomb_beginplant", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv3()) == false then
		return
	end

	if uv4(uv0(uv1.option_automation), "Follow bomb_beginplant") then
		slot1 = uv0(uv1.target_type)

		if uv5(slot0.userid) ~= uv3() then
			if slot1 == "Closest enemy" or slot1 == "Teammate" then
				slot2, slot3, slot4 = nil
				slot5, slot3, slot4 = uv6(uv5(slot0.userid))

				if slot5 == nil or slot3 == nil or slot4 == nil and uv7.debug then
					if uv7.debug then
						print("planter origin unknown")
					end
				else
					uv7.previousC4 = {
						slot2,
						slot3,
						slot4
					}
					uv8.waypoint = {
						slot2,
						slot3,
						slot4
					}

					if uv7.debug then
						if uv7.debug then
							print("on_bomb_beginplant bomb_coords | x:", slot2, " y:", slot3, " z:", slot4)
						end

						uv9(0.1, uv10)
					end

					if uv4(uv0(uv1.option_type), "Debug Panel") then
						uv8.debug_stance = "on_bomb_beginplant set_pathway"
					end

					if uv7.debug then
						print("on_bomb_beginplant set_pathway | ", unpack(uv8.waypoint))
					end
				end
			end
		else
			return
		end
	end
end)
slot88("bomb_exploded", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	uv2.planted = false
	uv2.defused = true
end)
slot88("bomb_pickup", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv3()) == false then
		return
	end

	if uv4(slot0.userid) ~= uv3() then
		uv5.goingc4 = false
		uv6.waypoint = uv6.previousWaypoint

		if uv7(uv0(uv1.option_type), "Debug Panel") then
			uv6.debug_stance = "on_bomb_pickup going_previous_waypoint"
		end

		if uv5.debug then
			print("on_bomb_pickup going_previous_waypoint")
		end

		uv8(0.1, uv9)

		return
	end

	if uv7(uv0(uv1.option_automation), "Auto plant") then
		slot1 = uv0(uv1.plant_slider)

		if (uv0(uv1.target_type) == "Closest enemy" or slot2 == "Teammate") and uv4(slot0.userid) == uv3() then
			uv5.carrier = true

			if uv5.goingc4 == true then
				uv5.goingc4 = false
			end

			slot3, slot4, slot5 = uv10(uv11(), "m_bombsiteCenterA")
			slot6, slot7, slot8 = uv10(uv11(), "m_bombsiteCenterB")

			if slot1 == 0 then
				if uv7(uv0(uv1.option_type), "Debug Panel") then
					uv5.target_bombsite = "closest"
				end

				if uv5.debug then
					print("Going to Closest")
				end

				slot9, slot10, slot11 = uv12(uv3())

				if uv13(slot9, slot10, slot11, slot3, slot4, slot5) < uv13(slot9, slot10, slot11, slot6, slot7, slot8) then
					uv6.waypoint = {
						slot3,
						slot4,
						slot5
					}
				else
					uv6.waypoint = {
						slot6,
						slot7,
						slot8
					}
				end
			elseif slot1 == 2 then
				if uv7(uv0(uv1.option_type), "Debug Panel") then
					uv5.target_bombsite = "a site"
				end

				if uv5.debug then
					print("Going to A")
				end

				uv6.waypoint = {
					slot3,
					slot4,
					slot5
				}
			elseif slot1 == 3 then
				if uv7(uv0(uv1.option_type), "Debug Panel") then
					uv5.target_bombsite = "b site"
				end

				if uv5.debug then
					print("Going to B")
				end

				uv6.waypoint = {
					slot6,
					slot7,
					slot8
				}
			elseif slot1 == 1 then
				slot9 = uv14(1, 2)

				if uv7(uv0(uv1.option_type), "Debug Panel") then
					uv5.target_bombsite = "random"
				end

				if uv5.debug then
					uv5.target_bombsite = "random"

					print("Going to Random " .. slot9)
				end

				if slot9 == 1 then
					uv6.waypoint = {
						slot3,
						slot4,
						slot5
					}
				elseif slot9 == 2 then
					uv6.waypoint = {
						slot6,
						slot7,
						slot8
					}
				end
			end

			if uv7(uv0(uv1.option_type), "Debug Panel") then
				uv6.debug_stance = "on_bomb_pickup set_pathway"
			end

			if uv5.debug then
				print("on_bomb_pickup set_pathway | ", unpack(uv6.waypoint))
			end

			uv5.goingC4 = false

			uv8(0.1, uv9)
		end
	end
end)
slot88("bomb_defused", function (slot0)
	if not uv0(uv1.enable) then
		return
	end

	if uv2(uv3()) == false then
		return
	end

	uv4.planted = false
	uv4.defused = true

	if uv5(slot0.userid) == uv3() then
		if uv0(uv1.target_type) == "Closest enemy" then
			uv6()
		elseif slot1 == "Teammate" then
			uv7()
		end

		uv8(0.1, uv9)

		if uv10(uv0(uv1.option_type), "Debug Panel") then
			uv11.debug_stance = "on_bomb_defused set_pathway"
		end

		if uv4.debug then
			print("on_bomb_defused set_pathway")
		end
	end

	if uv4.aa then
		uv12(uv13.enable_aa, uv4.previousAA)
		uv12(uv13.aa_pitch, uv4.previousPitch)

		uv4.aa = false
	end
end)
slot88("bomb_abortdefuse", slot171)
slot88("bomb_dropped", function (slot0)
	if uv0(slot0.userid) == uv1() then
		uv2(3, uv3)
	end
end)
