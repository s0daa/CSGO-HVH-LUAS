local var_0_0 = client.get_cvar
local var_0_1 = client.camera_position
local var_0_2 = client.create_interface
local var_0_3 = client.random_int
local var_0_4 = client.latency
local var_0_5 = client.set_clan_tag
local var_0_6 = client.find_signature
local var_0_7 = client.log
local var_0_8 = client.timestamp
local var_0_9 = client.delay_call
local var_0_10 = client.draw_indicator
local var_0_11 = client.trace_line
local var_0_12 = client.draw_circle
local var_0_13 = client.draw_line
local var_0_14 = client.draw_text
local var_0_15 = client.register_esp_flag
local var_0_16 = client.get_model_name
local var_0_17 = client.system_time
local var_0_18 = client.visible
local var_0_19 = client.exec
local var_0_20 = client.key_state
local var_0_21 = client.set_cvar
local var_0_22 = client.unix_time
local var_0_23 = client.error_log
local var_0_24 = client.draw_debug_text
local var_0_25 = client.update_player_list
local var_0_26 = client.camera_angles
local var_0_27 = client.eye_position
local var_0_28 = client.draw_hitboxes
local var_0_29 = client.random_float
local var_0_30 = entity.get_local_player
local var_0_31 = entity.is_enemy
local var_0_32 = entity.get_bounding_box
local var_0_33 = entity.get_all
local var_0_34 = entity.set_prop
local var_0_35 = entity.is_alive
local var_0_36 = entity.get_steam64
local var_0_37 = entity.get_classname
local var_0_38 = entity.get_player_resource
local var_0_39 = entity.get_esp_data
local var_0_40 = entity.is_dormant
local var_0_41 = entity.get_player_name
local var_0_42 = entity.get_game_rules
local var_0_43 = entity.get_origin
local var_0_44 = entity.hitbox_position
local var_0_45 = entity.get_player_weapon
local var_0_46 = entity.get_players
local var_0_47 = entity.get_prop
local var_0_48 = globals.realtime
local var_0_49 = globals.absoluteframetime
local var_0_50 = globals.chokedcommands
local var_0_51 = globals.oldcommandack
local var_0_52 = globals.tickcount
local var_0_53 = globals.commandack
local var_0_54 = globals.lastoutgoingcommand
local var_0_55 = globals.curtime
local var_0_56 = globals.mapname
local var_0_57 = globals.tickinterval
local var_0_58 = globals.framecount
local var_0_59 = globals.frametime
local var_0_60 = globals.maxplayers
local var_0_61 = ui.new_slider
local var_0_62 = ui.new_combobox
local var_0_63 = ui.reference
local var_0_64 = ui.set_visible
local var_0_65 = ui.new_textbox
local var_0_66 = ui.new_color_picker
local var_0_67 = ui.new_checkbox
local var_0_68 = ui.mouse_position
local var_0_69 = ui.new_listbox
local var_0_70 = ui.new_multiselect
local var_0_71 = ui.is_menu_open
local var_0_72 = ui.new_hotkey
local var_0_73 = ui.set
local var_0_74 = ui.update
local var_0_75 = ui.menu_size
local var_0_76 = ui.name
local var_0_77 = ui.menu_position
local var_0_78 = ui.set_callback
local var_0_79 = ui.new_button
local var_0_80 = ui.new_label
local var_0_81 = ui.new_string
local var_0_82 = ui.get
local var_0_83 = client.world_to_screen
local var_0_84 = client.draw_rectangle
local var_0_85 = client.draw_circle_outline
local var_0_86 = client.userid_to_entindex
local var_0_87 = client.draw_gradient
local var_0_88 = client.set_event_callback
local var_0_89 = client.screen_size
local var_0_90 = client.trace_bullet
local var_0_91 = client.unset_event_callback
local var_0_92 = client.color_log
local var_0_93 = client.reload_active_scripts
local var_0_94 = client.scale_damage
local var_0_95 = {
	debug_stance = "",
	sourcenav = require("gamesense/sourcenav"),
	graph = {},
	ignoreConnection = {},
	forbiddenWaypoint = {},
	path = {},
	waypoint = {},
	previousWaypoint = {}
}
local var_0_96 = {
	lastStuckHandleTick = 999999999999,
	stuckAttempts = 0
}
local var_0_97 = {
	aa = false,
	previousPitch = "",
	target_bombsite = "",
	target_name = "",
	unscope = false,
	debug = false,
	carrier = false,
	goingC4 = false,
	stand = false,
	planted = false,
	currMap = var_0_56(),
	teammates = {},
	previousC4 = {}
}
local var_0_98 = {
	"Lock view angle",
	"Rand waypt if no enemy",
	"Rand waypt if no mate",
	"Show Path",
	"Debug Panel"
}
local var_0_99 = {
	"Auto plant",
	"Auto defuse",
	"Auto team join",
	"Follow bomb_begindefuse",
	"Follow bomb_beginplant",
	"Follow bomb_dropped",
	"Stand still after plant"
}

local function var_0_100()
	local var_1_0 = {}

	var_1_0[0] = "Closest"
	var_1_0[1] = "Random"
	var_1_0[2] = "Only go A"
	var_1_0[3] = "Only go B"

	return var_1_0
end

local var_0_101 = {
	[0] = "Misc",
	"Movement"
}
local var_0_102 = {
	enable = var_0_67(var_0_101[0], var_0_101[1], "Enable walkbot"),
	target_type = var_0_62(var_0_101[0], var_0_101[1], "Walkbot target", "Waypoint", "Closest enemy", "Teammate"),
	option_type = var_0_70(var_0_101[0], var_0_101[1], "Walkbot options", var_0_98),
	option_automation = var_0_70(var_0_101[0], var_0_101[1], "Walkbot automation", var_0_99),
	plant_slider = var_0_61(var_0_101[0], var_0_101[1], "A to B percentage", 0, 3, 2, true, "%", 1, var_0_100()),
	pathlabel = var_0_80(var_0_101[0], var_0_101[1], "Path Color"),
	pathcolor = var_0_66(var_0_101[0], var_0_101[1], "Path Color", 72, 133, 237, 255),
	end_waypoint = var_0_72(var_0_101[0], var_0_101[1], "Set waypoint"),
	calculate_path = var_0_72(var_0_101[0], var_0_101[1], "Calculate path"),
	remove_point = var_0_72(var_0_101[0], var_0_101[1], "Remove waypoint"),
	team_target = var_0_69(var_0_101[0], var_0_101[1], "Target", "-", var_0_97.teammates),
	auto_team = var_0_62(var_0_101[0], var_0_101[1], "Automatically choose team", "Spectator", "Terrorist", "Counter-Terrorist")
}
local var_0_103 = {
	enable_aa = var_0_63("AA", "Anti-aimbot angles", "Enabled"),
	aa_pitch = var_0_63("AA", "Anti-aimbot angles", "Pitch"),
	easy_strafe = var_0_63("Misc", "Movement", "Easy strafe"),
	saveconfig = var_0_63("Config", "Presets", "Save"),
	loadconfig = var_0_63("Config", "Presets", "Load")
}
local var_0_104 = {
	LAST_CUSTOM = 67108864,
	FIRST_CUSTOM = 65536,
	CLIFF = 32768,
	OBSTACLE_TOP = 16384,
	NO_MERGE = 8192,
	STAIRS = 4096,
	NO_HOSTAGES = 2048,
	STAND = 1024,
	DONT_HIDE = 512,
	TRANSIENT = 256,
	AVOID = 128,
	WALK = 64,
	RUN = 32,
	STOP = 16,
	NO_JUMP = 8,
	PRECISE = 4,
	JUMP = 2,
	CROUCH = 1,
	NAV_BLOCKER = 2147483648,
	HAS_ELEVATOR = 1073741824,
	FUNC_COST = 536870912
}
local var_0_105 = {
	IN_WALK = 131072,
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
	IDLE = 0
}
local var_0_106 = 1 / 0
local var_0_107

local function var_0_108(arg_2_0, arg_2_1)
	return math.sqrt(math.pow(arg_2_1.x - arg_2_0.x, 2) + math.pow(arg_2_1.y - arg_2_0.y, 2) + math.pow(arg_2_1.z - arg_2_0.z, 2))
end

local function var_0_109(arg_3_0, arg_3_1)
	local var_3_0 = var_0_108(arg_3_0, arg_3_1) - 5 * arg_3_0.encounter_paths_count

	if var_3_0 < 0 then
		var_3_0 = 0
	end

	return var_3_0
end

local function var_0_110(arg_4_0, arg_4_1)
	return true
end

local function var_0_111(arg_5_0, arg_5_1)
	local var_5_0 = var_0_106
	local var_5_1

	for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
		local var_5_2 = arg_5_1[iter_5_1]

		if var_5_2 < var_5_0 then
			var_5_0, var_5_1 = var_5_2, iter_5_1
		end
	end

	return var_5_1
end

local function var_0_112(arg_6_0, arg_6_1)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_1) do
		if arg_6_0 ~= iter_6_1 and var_0_110(arg_6_0, iter_6_1) then
			table.insert(var_6_0, iter_6_1)
		end
	end

	return var_6_0
end

local function var_0_113(arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(arg_7_0) do
		if iter_7_1 == arg_7_1 then
			return true
		end
	end

	return false
end

local function var_0_114(arg_8_0)
	local var_8_0 = "\n{"

	for iter_8_0, iter_8_1 in pairs(arg_8_0) do
		if type(iter_8_0) == "string" then
			var_8_0 = var_8_0 .. "[\"" .. iter_8_0 .. "\"]" .. "="
		end

		if type(iter_8_1) == "table" then
			var_8_0 = var_8_0 .. var_0_114(iter_8_1)
		elseif type(iter_8_1) == "boolean" then
			var_8_0 = var_8_0 .. tostring(iter_8_1)
		else
			var_8_0 = var_8_0 .. "\"" .. iter_8_1 .. "\""
		end

		var_8_0 = var_8_0 .. ",\n"
	end

	if var_8_0 ~= "" then
		var_8_0 = var_8_0:sub(1, var_8_0:len() - 1)
	end

	return var_8_0 .. "}\n"
end

local function var_0_115(arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in ipairs(arg_9_0) do
		if iter_9_1 == arg_9_1 then
			return false
		end
	end

	return true
end

local function var_0_116(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in ipairs(arg_10_0) do
		if iter_10_1 == arg_10_1 then
			arg_10_0[iter_10_0] = arg_10_0[#arg_10_0]
			arg_10_0[#arg_10_0] = nil

			break
		end
	end
end

local function var_0_117(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_1[arg_11_2] then
		table.insert(arg_11_0, 1, arg_11_1[arg_11_2])

		return var_0_117(arg_11_0, arg_11_1, arg_11_1[arg_11_2])
	else
		return arg_11_0
	end
end

local function var_0_118(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = {}
	local var_12_1 = {
		arg_12_0
	}
	local var_12_2 = {}

	if arg_12_3 then
		var_0_110 = arg_12_3
	end

	local var_12_3 = {}
	local var_12_4 = {}

	var_12_3[arg_12_0] = 0
	var_12_4[arg_12_0] = var_12_3[arg_12_0] + var_0_109(arg_12_0, arg_12_1)

	while #var_12_1 > 0 do
		local var_12_5 = var_0_111(var_12_1, var_12_4)

		if var_12_5 == arg_12_1 then
			local var_12_6 = var_0_117({}, var_12_2, arg_12_1)

			table.insert(var_12_6, arg_12_1)

			return var_12_6
		end

		var_0_116(var_12_1, var_12_5)
		table.insert(var_12_0, var_12_5)

		local var_12_7 = var_0_112(var_12_5, arg_12_2)

		for iter_12_0, iter_12_1 in ipairs(var_12_7) do
			if var_0_115(var_12_0, iter_12_1) then
				local var_12_8 = var_12_3[var_12_5] + var_0_108(var_12_5, iter_12_1)

				if var_0_115(var_12_1, iter_12_1) or var_12_8 < var_12_3[iter_12_1] then
					var_12_2[iter_12_1] = var_12_5
					var_12_3[iter_12_1] = var_12_8
					var_12_4[iter_12_1] = var_12_3[iter_12_1] + var_0_109(iter_12_1, arg_12_1)

					if var_0_115(var_12_1, iter_12_1) then
						table.insert(var_12_1, iter_12_1)
					end
				end
			end
		end
	end

	return nil
end

local function var_0_119()
	var_0_107 = nil
end

local function var_0_120(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
	if not var_0_107 then
		var_0_107 = {}
	end

	if not var_0_107[arg_14_0] then
		var_0_107[arg_14_0] = {}
	elseif var_0_107[arg_14_0][arg_14_1] and not arg_14_3 then
		return var_0_107[arg_14_0][arg_14_1]
	end

	local var_14_0 = var_0_118(arg_14_0, arg_14_1, arg_14_2, arg_14_4)

	if not var_0_107[arg_14_0][arg_14_1] and not arg_14_3 then
		var_0_107[arg_14_0][arg_14_1] = var_14_0
	end

	return var_14_0
end

local function var_0_121(arg_15_0, arg_15_1)
	return (arg_15_0 + arg_15_1) / 2
end

local function var_0_122(arg_16_0, arg_16_1)
	return math.sqrt(math.pow(arg_16_1 - arg_16_0, 2))
end

local function var_0_123(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	return math.sqrt(math.pow(arg_17_2 - arg_17_0, 2) + math.pow(arg_17_3 - arg_17_1, 2))
end

local function var_0_124(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	return math.sqrt(math.pow(arg_18_3 - arg_18_0, 2) + math.pow(arg_18_4 - arg_18_1, 2) + math.pow(arg_18_5 - arg_18_2, 2))
end

local function var_0_125(arg_19_0)
	return math.floor(arg_19_0 / var_0_57() + 0.5)
end

local function var_0_126(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	return arg_20_3 >= arg_20_0[1] and arg_20_1 <= arg_20_0[1] and arg_20_4 >= arg_20_0[2] and arg_20_2 <= arg_20_0[2]
end

local function var_0_127(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_1 + math.cos(math.rad(arg_21_3)) * arg_21_0
	local var_21_1 = arg_21_2 + math.sin(math.rad(arg_21_3)) * arg_21_0

	return var_21_0, var_21_1
end

local function var_0_128(arg_22_0)
	while arg_22_0 < 0 do
		arg_22_0 = arg_22_0 + 360
	end

	while arg_22_0 > 360 or arg_22_0 == 360 do
		arg_22_0 = arg_22_0 - 360
	end

	return arg_22_0
end

local function var_0_129()
	var_0_95.graph = {}
	var_0_95.path = nil
	var_0_95.waypoint = {}
	var_0_95.ignoreConnection = {}
	var_0_95.forbiddenWaypoint = {}
end

local function var_0_130()
	var_0_97.planted = false
	var_0_97.stand = false
	var_0_97.goingC4 = false
	var_0_97.carrier = false
	var_0_97.unscope = false
	var_0_97.previousC4 = {}
end

local function var_0_131(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5)
	local var_25_0
	local var_25_1
	local var_25_2
	local var_25_3
	local var_25_4
	local var_25_5

	if arg_25_3 == nil then
		var_25_3, var_25_4, var_25_5 = arg_25_0, arg_25_1, arg_25_2
		var_25_0, var_25_1, var_25_2 = var_0_27()

		if var_25_0 == nil then
			return
		end
	else
		var_25_0, var_25_1, var_25_2 = arg_25_0, arg_25_1, arg_25_2
		var_25_3, var_25_4, var_25_5 = arg_25_3, arg_25_4, arg_25_5
	end

	local var_25_6 = var_25_3 - var_25_0
	local var_25_7 = var_25_4 - var_25_1
	local var_25_8 = var_25_5 - var_25_2

	if var_25_6 == 0 and var_25_7 == 0 then
		return var_25_8 > 0 and 270 or 90, 0
	else
		local var_25_9 = math.deg(math.atan2(var_25_7, var_25_6))
		local var_25_10 = math.sqrt(math.pow(var_25_6, 2) + math.pow(var_25_7, 2))

		return math.deg(math.atan2(-var_25_8, var_25_10)), var_25_9
	end
end

local function var_0_132(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7)
	var_0_12(arg_26_0, arg_26_1, arg_26_2, 0, 0, 0, 150, arg_26_7 + 1, 0, 1)
	var_0_12(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, 0, 1)
end

local function var_0_133()
	local var_27_0 = var_0_30()

	if var_27_0 == nil then
		return nil
	end

	local var_27_1, var_27_2, var_27_3 = var_0_43(var_27_0)

	if var_27_1 == nil then
		return nil
	end

	return var_27_1, var_27_2, var_27_3
end

local function var_0_134()
	if var_0_95.navmesh_raw ~= nil then
		for iter_28_0, iter_28_1 in ipairs(var_0_95.navmesh.areas) do
			local var_28_0 = var_0_121(iter_28_1.north_west.x, iter_28_1.south_east.x)
			local var_28_1 = var_0_121(iter_28_1.north_west.y, iter_28_1.south_east.y)
			local var_28_2 = var_0_121(iter_28_1.north_east_z, iter_28_1.south_west_z)

			var_0_95.graph[iter_28_0] = iter_28_1
			var_0_95.graph[iter_28_0].x = var_28_0
			var_0_95.graph[iter_28_0].y = var_28_1
			var_0_95.graph[iter_28_0].z = var_28_2
		end
	end
end

local function var_0_135()
	if var_0_30() == nil then
		return
	end

	var_0_129()

	if var_0_95.sourcenav == nil then
		var_0_23("please subscribe to https://gamesense.pub/forums/viewtopic.php?id=18492")

		return
	end

	var_0_97.currMap = var_0_56()
	var_0_95.navmesh_raw = nil
	var_0_95.navmesh_raw = readfile("csgo/maps/" .. var_0_97.currMap .. ".nav")

	if var_0_95.navmesh_raw ~= nil then
		var_0_95.navmesh = var_0_95.sourcenav.parse(var_0_95.navmesh_raw)

		var_0_134()
	else
		var_0_23("navigation mesh not found, please run 'nav_generate' in console")
	end
end

local function var_0_136(arg_30_0)
	local var_30_0, var_30_1 = var_0_83(c, arg_30_0.x, arg_30_0.y, arg_30_0.z)

	if var_30_0 ~= nil then
		local var_30_2 = ""

		if bit.band(arg_30_0.flags, var_0_104.JUMP) == var_0_104.JUMP then
			var_30_2 = var_30_2 .. "JUMP:"
		end

		if bit.band(arg_30_0.flags, var_0_104.WALK) == var_0_104.WALK then
			var_30_2 = var_30_2 .. "WALK:"
		end

		if bit.band(arg_30_0.flags, var_0_104.CROUCH) == var_0_104.CROUCH then
			var_30_2 = var_30_2 .. "CROUCH:"
		end

		if bit.band(arg_30_0.flags, var_0_104.PRECISE) == var_0_104.PRECISE then
			var_30_2 = var_30_2 .. "PRECISE:"
		end

		if bit.band(arg_30_0.flags, var_0_104.NO_JUMP) == var_0_104.NO_JUMP then
			var_30_2 = var_30_2 .. "NO_JUMP:"
		end

		if bit.band(arg_30_0.flags, var_0_104.AVOID) == var_0_104.AVOID then
			var_30_2 = var_30_2 .. "AVOID:"
		end

		if bit.band(arg_30_0.flags, var_0_104.TRANSIENT) == var_0_104.TRANSIENT then
			var_30_2 = var_30_2 .. "TRANSIENT:"
		end

		if bit.band(arg_30_0.flags, var_0_104.OBSTACLE_TOP) == var_0_104.OBSTACLE_TOP then
			var_30_2 = var_30_2 .. "OBSTACLE_TOP:"
		end

		if bit.band(arg_30_0.flags, var_0_104.CLIFF) == var_0_104.CLIFF then
			var_30_2 = var_30_2 .. "CLIFF:"
		end

		if bit.band(arg_30_0.flags, var_0_104.STAIRS) == var_0_104.STAIRS then
			var_30_2 = var_30_2 .. "STAIRS:"
		end

		if bit.band(arg_30_0.flags, var_0_104.NO_MERGE) == var_0_104.NO_MERGE then
			var_30_2 = var_30_2 .. "NO_MERGE:"
		end

		if bit.band(arg_30_0.flags, var_0_104.FIRST_CUSTOM) == var_0_104.FIRST_CUSTOM then
			var_30_2 = var_30_2 .. "FIRST_CUSTOM:"
		end

		if bit.band(arg_30_0.flags, var_0_104.LAST_CUSTOM) == var_0_104.LAST_CUSTOM then
			var_30_2 = var_30_2 .. "LAST_CUSTOM:"
		end

		if bit.band(arg_30_0.flags, var_0_104.FUNC_COST) == var_0_104.FUNC_COST then
			var_30_2 = var_30_2 .. "FUNC_COST:"
		end

		if bit.band(arg_30_0.flags, var_0_104.HAS_ELEVATOR) == var_0_104.HAS_ELEVATOR then
			var_30_2 = var_30_2 .. "HAS_ELEVATOR:"
		end

		if bit.band(arg_30_0.flags, var_0_104.NAV_BLOCKER) == var_0_104.NAV_BLOCKER then
			var_30_2 = var_30_2 .. "NAV_BLOCKER:"
		end

		var_0_14(c, var_30_0, var_30_1, 255, 255, 255, 255, "c", 0, var_30_2)
	end
end

local function var_0_137(arg_31_0, arg_31_1)
	for iter_31_0, iter_31_1 in ipairs(var_0_95.ignoreConnection) do
		if iter_31_1.id == arg_31_1.id then
			return false
		end
	end

	if bit.band(arg_31_1.flags, var_0_104.OBSTACLE_TOP) == var_0_104.OBSTACLE_TOP then
		return false
	end

	for iter_31_2, iter_31_3 in ipairs(arg_31_0.connections) do
		for iter_31_4, iter_31_5 in ipairs(iter_31_3.connections) do
			if iter_31_5 == arg_31_1.id then
				return true
			end
		end
	end

	return false
end

local function var_0_138(arg_32_0)
	for iter_32_0, iter_32_1 in ipairs(var_0_95.graph) do
		if iter_32_1.id == arg_32_0 then
			return iter_32_0
		end
	end

	return 1
end

local function var_0_139(arg_33_0)
	local var_33_0, var_33_1, var_33_2 = var_0_133()

	if var_33_0 == nil then
		return
	end

	if var_0_124(arg_33_0.x, arg_33_0.y, arg_33_0.z, var_33_0, var_33_1, var_33_2) > 500 then
		return
	end

	local var_33_3, var_33_4 = var_0_83(c, arg_33_0.x, arg_33_0.y, arg_33_0.z)

	var_0_136(arg_33_0)

	local var_33_5, var_33_6 = var_0_83(c, arg_33_0.north_west.x, arg_33_0.north_west.y, arg_33_0.north_west.z)
	local var_33_7, var_33_8 = var_0_83(c, arg_33_0.south_east.x, arg_33_0.south_east.y, arg_33_0.south_east.z)
	local var_33_9, var_33_10 = var_0_83(c, arg_33_0.south_east.x, arg_33_0.north_west.y, arg_33_0.north_east_z)
	local var_33_11, var_33_12 = var_0_83(c, arg_33_0.north_west.x, arg_33_0.south_east.y, arg_33_0.south_west_z)

	var_0_13(c, var_33_5, var_33_6, var_33_9, var_33_10, 0, 0, 0, 255)
	var_0_13(c, var_33_11, var_33_12, var_33_7, var_33_8, 0, 0, 0, 255)
	var_0_13(c, var_33_5, var_33_6, var_33_11, var_33_12, 0, 0, 0, 255)
	var_0_13(c, var_33_9, var_33_10, var_33_7, var_33_8, 0, 0, 0, 255)
end

local function var_0_140(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = var_0_95.graph[1]

	for iter_34_0, iter_34_1 in ipairs(var_0_95.graph) do
		if var_0_124(var_34_0.x, var_34_0.y, var_34_0.z, arg_34_0, arg_34_1, arg_34_2) > var_0_124(iter_34_1.x, iter_34_1.y, iter_34_1.z, arg_34_0, arg_34_1, arg_34_2) then
			var_34_0 = iter_34_1
		end
	end

	return var_34_0
end

local function var_0_141()
	if var_0_95.path ~= nil then
		local var_35_0

		for iter_35_0, iter_35_1 in ipairs(var_0_95.path) do
			local var_35_1, var_35_2 = var_0_83(c, iter_35_1.x, iter_35_1.y, iter_35_1.z)
			local var_35_3
			local var_35_4

			if var_35_0 ~= nil then
				var_35_3, var_35_4 = var_0_83(c, var_35_0.x, var_35_0.y, var_35_0.z)
			end

			if var_35_1 ~= nil and var_0_113(var_0_82(var_0_102.option_type), "Show Path") then
				local var_35_5, var_35_6, var_35_7, var_35_8 = var_0_82(var_0_102.pathcolor)

				var_0_132(c, var_35_1, var_35_2, var_35_5, var_35_6, var_35_7, var_35_8, 2)

				if var_35_3 ~= nil then
					var_0_13(c, var_35_1, var_35_2, var_35_3, var_35_4, var_35_5, var_35_6, var_35_7, var_35_8)
				end
			end

			var_35_0 = iter_35_1
		end
	end

	if var_0_95.waypoint[1] ~= nil then
		local var_35_9 = var_0_140(var_0_95.waypoint[1], var_0_95.waypoint[2], var_0_95.waypoint[3])
		local var_35_10 = 15
		local var_35_11 = 5
		local var_35_12, var_35_13 = var_0_83(c, var_35_9.x, var_35_9.y, var_35_9.z)

		if var_35_12 ~= nil then
			local var_35_14 = 1

			renderer.triangle(var_35_12 - var_35_11 - var_35_14, var_35_13 - var_35_10 - var_35_14, var_35_12 + var_35_11 + var_35_14, var_35_13 - var_35_10 - var_35_14, var_35_12, var_35_13 + var_35_14, 0, 0, 0, 250)
			renderer.triangle(var_35_12 - var_35_11, var_35_13 - var_35_10, var_35_12 + var_35_11, var_35_13 - var_35_10, var_35_12, var_35_13, 219, 50, 54, 255)
			var_0_132(c, var_35_12, var_35_13 - var_35_10, 219, 50, 54, 255, var_35_11)
			var_0_132(c, var_35_12, var_35_13 - var_35_10, 100, 50, 54, 255, 1)
		end
	end
end

local function var_0_142()
	if not var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		return
	end

	local var_36_0, var_36_1 = var_0_89()

	p_1_size_w, p_1_size_h = renderer.measure_text("", "walkbot debug")

	renderer.text(10, var_36_1 / 2.15, 255, 255, 255, 230, "", 0, "walkbot debug")

	local var_36_2 = p_1_size_h
	local var_36_3 = var_0_97.target_name

	if var_36_3:len() > 10 then
		local var_36_4 = string.sub(var_36_3, 0, 10)
	end

	local var_36_5, var_36_6, var_36_7 = unpack(var_0_95.waypoint)
	local var_36_8, var_36_9, var_36_10 = var_0_133()

	if var_0_97.goingC4 then
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target: bomb_dropped")

		var_36_2 = var_36_2 + p_1_size_h
	elseif var_0_97.planted then
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target: bomb_planted")

		var_36_2 = var_36_2 + p_1_size_h
	elseif var_0_97.carrier then
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target: going to bombsite")

		var_36_2 = var_36_2 + p_1_size_h

		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target_bombsite: ", var_0_97.target_bombsite)

		var_36_2 = var_36_2 + p_1_size_h
	elseif var_0_97.target_name == "unknown" or var_0_97.target_name == "" or var_0_97.target_name == nil then
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target: random place in the map")

		var_36_2 = var_36_2 + p_1_size_h
	else
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target: ", var_0_97.target_name)

		var_36_2 = var_36_2 + p_1_size_h
	end

	if not var_0_97.carrier then
		renderer.text(10, var_36_1 / 2.15 + var_36_2, 255, 255, 255, 230, "", 0, "target_origin: ", var_36_5, " ", var_36_6, " ", var_36_7)

		local var_36_11 = var_36_2 + p_1_size_h

		renderer.text(10, var_36_1 / 2.15 + var_36_11, 255, 255, 255, 230, "", 0, "current_origin: ", var_36_8, " ", var_36_9, " ", var_36_10)

		local var_36_12 = var_36_11 + p_1_size_h

		p_2_size_w, p_2_size_h = renderer.measure_text("", "current stance: ")

		renderer.text(10, var_36_1 / 2.15 + var_36_12, 255, 255, 255, 230, "", 0, "current stance: ")
		renderer.text(10 + p_2_size_w, var_36_1 / 2.15 + var_36_12, 255, 255, 255, 230, "", 0, var_0_95.debug_stance)

		local var_36_13 = var_36_12 + p_1_size_h
	end
end

local function var_0_143(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4, arg_37_5)
	if arg_37_0 == nil or arg_37_3 == nil then
		var_0_95.path = nil
	else
		local var_37_0 = var_0_140(arg_37_0, arg_37_1, arg_37_2)
		local var_37_1 = var_0_140(arg_37_3, arg_37_4, arg_37_5)
		local var_37_2 = var_0_138(var_37_0.id)
		local var_37_3 = var_0_138(var_37_1.id)

		for iter_37_0, iter_37_1 in ipairs(var_0_95.forbiddenWaypoint) do
			if iter_37_1.id == var_37_1.id then
				var_0_95.path = nil

				return
			end
		end

		if var_37_2 ~= -1 and var_37_3 ~= -1 then
			var_0_95.path = var_0_120(var_0_95.graph[var_37_2], var_0_95.graph[var_37_3], var_0_95.graph, false, var_0_137)

			if var_0_95.path == nil then
				table.insert(var_0_95.forbiddenWaypoint, var_37_1)
			end
		end
	end

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "calculate_path"
	end

	if var_0_97.debug then
		print("calculate_path")
	end
end

local function var_0_144()
	var_0_96.lastPointRemoved = var_0_95.path[1]

	table.remove(var_0_95.path, 1)

	var_0_96.lastStuckHandleTick = var_0_52()

	if #var_0_95.path <= 0 then
		var_0_95.waypoint = {}
	end
end

local function var_0_145(arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	local var_39_0 = (arg_39_3 - arg_39_0) * arg_39_6 + arg_39_0
	local var_39_1 = (arg_39_4 - arg_39_1) * arg_39_6 + arg_39_1
	local var_39_2 = (arg_39_5 - arg_39_2) * arg_39_6 + arg_39_2

	return var_39_0, var_39_1, var_39_2
end

local function var_0_146(arg_40_0)
	local var_40_0, var_40_1, var_40_2 = var_0_47(var_0_38(), "m_bombsiteCenterA")
	local var_40_3, var_40_4, var_40_5 = var_0_47(var_0_38(), "m_bombsiteCenterB")
	local var_40_6, var_40_7, var_40_8 = var_0_47(arg_40_0, "m_vecMins")
	local var_40_9, var_40_10, var_40_11 = var_0_47(arg_40_0, "m_vecMaxs")
	local var_40_12, var_40_13, var_40_14 = var_0_145(var_40_6, var_40_7, var_40_8, var_40_9, var_40_10, var_40_11, 0.5)

	return var_0_124(var_40_12, var_40_13, var_40_14, var_40_0, var_40_1, var_40_2) < var_0_124(var_40_12, var_40_13, var_40_14, var_40_3, var_40_4, var_40_5) and "A" or "B"
end

local function var_0_147()
	local var_41_0, var_41_1, var_41_2 = var_0_133()

	if var_41_0 == nil then
		return
	end

	local var_41_3

	for iter_41_0 = 1, var_0_60() do
		if var_0_37(iter_41_0) == "CCSPlayer" and var_0_31(iter_41_0) and var_0_35(iter_41_0) and var_0_43(iter_41_0) ~= nil then
			if var_41_3 == nil then
				var_41_3 = iter_41_0
			else
				local var_41_4, var_41_5, var_41_6 = var_0_43(iter_41_0)
				local var_41_7, var_41_8, var_41_9 = var_0_43(var_41_3)

				if var_0_124(var_41_0, var_41_1, var_41_2, var_41_7, var_41_8, var_41_9) <= 100 or var_0_124(var_41_0, var_41_1, var_41_2, var_41_4, var_41_5, var_41_6) <= 100 then
					return
				elseif var_0_124(var_41_0, var_41_1, var_41_2, var_41_7, var_41_8, var_41_9) > var_0_124(var_41_0, var_41_1, var_41_2, var_41_4, var_41_5, var_41_6) then
					var_41_3 = iter_41_0
				end
			end
		end
	end

	var_0_97.target_name = var_0_41(var_41_3)

	return var_41_3
end

local function var_0_148(arg_42_0)
	local var_42_0, var_42_1, var_42_2 = var_0_133()

	if var_42_0 == nil then
		return
	end

	local var_42_3, var_42_4 = var_0_127(20, var_42_0, var_42_1, arg_42_0)

	for iter_42_0, iter_42_1 in ipairs(var_0_95.graph) do
		if var_0_126({
			var_42_3,
			var_42_4
		}, iter_42_1.north_west.x, iter_42_1.north_west.y, iter_42_1.south_east.x, iter_42_1.south_east.y) then
			return iter_42_1
		end
	end
end

local function var_0_149(arg_43_0)
	local var_43_0, var_43_1, var_43_2 = var_0_133()

	if var_43_0 == nil then
		return
	end

	if var_0_95.path ~= nil and #var_0_95.path > 0 then
		if var_0_82(var_0_103.easy_strafe) == false then
			var_0_73(var_0_103.easy_strafe, true)
		end

		local var_43_3, var_43_4 = var_0_131(var_43_0, var_43_1, var_43_2, var_0_95.path[1].x, var_0_95.path[1].y, var_0_95.path[1].z)
		local var_43_5 = var_0_128(var_43_4)

		arg_43_0.move_yaw = var_43_5

		local var_43_6 = var_0_82(var_0_102.option_type)

		for iter_43_0 = 1, #var_43_6 do
			if var_43_6[iter_43_0] == "Lock view angle" then
				arg_43_0.yaw = var_43_5

				var_0_73(var_0_103.enable_aa, true)
			end
		end

		arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_FORWARD)
		arg_43_0.forwardmove = 450

		if var_0_124(var_43_0, var_43_1, var_43_2, var_0_95.path[1].x, var_0_95.path[1].y, var_0_95.path[1].z) < 50 then
			if bit.band(var_0_95.graph[var_0_138(var_0_95.path[1].id)].flags, var_0_104.JUMP) == var_0_104.JUMP then
				arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_JUMP, var_0_105.IN_DUCK)
			elseif bit.band(var_0_95.graph[var_0_138(var_0_95.path[1].id)].flags, var_0_104.CROUCH) == var_0_104.CROUCH then
				arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_DUCK)
			end
		end

		local var_43_7 = var_0_148(var_43_5)

		if var_43_7 ~= nil and bit.band(var_0_95.graph[var_0_138(var_43_7.id)].flags, var_0_104.CROUCH) == var_0_104.CROUCH then
			arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_DUCK)
		end

		local var_43_8 = var_0_33("CDynamicProp")

		for iter_43_1, iter_43_2 in ipairs(var_43_8) do
			local var_43_9, var_43_10, var_43_11 = var_0_43(iter_43_2)

			if var_0_124(var_43_9, var_43_10, var_43_11, var_43_0, var_43_1, var_43_2) < 50 then
				arg_43_0.yaw = var_43_5
				arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_ATTACK)
			end
		end

		local var_43_12 = var_0_33("CPropDoorRotating")

		for iter_43_3, iter_43_4 in ipairs(var_43_12) do
			local var_43_13 = {
				var_0_43(iter_43_4)
			}

			var_43_13[3] = var_43_13[3] + 50

			if var_0_124(var_43_0, var_43_1, var_43_2 + 50, var_43_13[1], var_43_13[2], var_43_13[3]) < 50 then
				local var_43_14, var_43_15, var_43_16 = var_0_127(50, var_43_0, var_43_1, var_43_5)

				if var_0_11(var_0_30(), var_43_0, var_43_1, var_43_2 + 50, var_43_14, var_43_15, var_43_2 + 50) < 0.9 then
					arg_43_0.buttons = bit.bor(arg_43_0.buttons, var_0_105.IN_USE)
				end
			end
		end
	end
end

local function var_0_150()
	local var_44_0, var_44_1, var_44_2 = var_0_133()

	if var_44_0 == nil then
		return
	end

	var_0_95.waypoint = {
		var_44_0,
		var_44_1,
		var_44_2
	}
end

local function var_0_151()
	local var_45_0 = var_0_30()
	local var_45_1 = var_0_47(var_45_0, "m_iTeamNum")
	local var_45_2 = {}

	for iter_45_0 = 1, var_0_60() do
		if var_0_47(var_0_38(), "m_bConnected", iter_45_0) == 1 and var_0_47(iter_45_0, "m_iTeamNum") == var_45_1 and iter_45_0 ~= var_45_0 then
			table.insert(var_45_2, var_0_41(iter_45_0))
		end
	end

	var_0_97.teammates = var_45_2
end

local function var_0_152()
	if var_0_97.stand or var_0_97.planted or var_0_97.goingC4 or var_0_97.carrier then
		return
	end

	if var_0_95.follow_target ~= nil and var_0_35(var_0_95.follow_target) then
		local var_46_0, var_46_1, var_46_2 = var_0_43(var_0_95.follow_target)

		var_0_95.waypoint = {
			var_46_0,
			var_46_1,
			var_46_2
		}

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "set_waypoint_teammate"
		end

		if var_0_97.debug then
			print("set_waypoint_teammate")
		end
	end
end

local function var_0_153()
	local var_47_0, var_47_1, var_47_2 = var_0_133()

	if var_47_0 == nil then
		return
	end

	local var_47_3 = var_0_147()

	if var_47_3 ~= nil then
		local var_47_4, var_47_5, var_47_6 = var_0_43(var_47_3)

		var_0_95.waypoint = {
			var_47_4,
			var_47_5,
			var_47_6
		}
	end

	return var_47_3
end

local function var_0_154()
	local var_48_0, var_48_1, var_48_2 = var_0_133()

	if var_48_0 == nil then
		return
	end

	if var_0_95.graph ~= nil and #var_0_95.graph > 0 then
		local var_48_3 = var_0_95.graph[var_0_3(1, #var_0_95.graph)]

		var_0_95.waypoint = {
			var_48_3.x,
			var_48_3.y,
			var_48_3.z
		}
	end

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "set_waypoint_rand"
	end

	if var_0_97.debug then
		print("set_waypoint_rand")
	end
end

local function var_0_155()
	if var_0_82(var_0_102.team_target) == nil then
		return
	end

	for iter_49_0 = 1, var_0_60() do
		local var_49_0 = var_0_41(iter_49_0)

		if var_49_0 ~= nil and var_49_0 == var_0_97.teammates[var_0_82(var_0_102.team_target) + 1] then
			var_0_95.follow_target = iter_49_0
		end
	end
end

local function var_0_156()
	local var_50_0, var_50_1, var_50_2 = var_0_133()

	if var_50_0 == nil then
		return
	end

	var_0_143(var_50_0, var_50_1, var_50_2, var_0_95.waypoint[1], var_0_95.waypoint[2], var_0_95.waypoint[3])
end

local function var_0_157()
	var_0_95.ignoreConnection = {}

	if var_0_97.stand or var_0_97.planted or var_0_97.goingC4 or var_0_97.carrier then
		return
	end

	if var_0_153() == nil and var_0_113(var_0_82(var_0_102.option_type), "Rand waypt if no enemy") then
		var_0_154()

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "handle_closest_enemy rand_way_no_enemy"
		end

		if var_0_97.debug then
			print("handle_closest_enemy rand_way_no_enemy")
		end
	end

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "handle_closest_enemy set_pathway"
	end

	if var_0_97.debug then
		print("handle_closest_enemy set_pathway")
	end

	var_0_156()
end

var_0_135()

local function var_0_158(arg_52_0)
	if not var_0_82(var_0_102.enable) or var_0_95.navmesh_raw == nil then
		return
	end

	var_0_141()
	var_0_142()
end

local function var_0_159(arg_53_0)
	if var_0_47(var_0_42(), "m_bFreezePeriod") == 1 then
		return
	end

	if var_0_96.stuckAttempts == 0 then
		arg_53_0.buttons = bit.bor(arg_53_0.buttons, var_0_105.IN_JUMP)
		var_0_96.stuckAttempts = var_0_96.stuckAttempts + 1

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "handle_stuck IN_JUMP"
		end

		if var_0_97.debug then
			print("handle_stuck IN_JUMP")
		end
	elseif var_0_96.stuckAttempts == 1 then
		table.insert(var_0_95.ignoreConnection, var_0_95.path[1])
		var_0_9(0.1, var_0_156)

		var_0_96.stuckAttempts = var_0_96.stuckAttempts + 1

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "handle_stuck set_pathway"
		end

		if var_0_97.debug then
			print("handle_stuck set_pathway")
		end
	else
		if var_0_82(var_0_102.target_type) == "Closest enemy" then
			var_0_157()

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_stuck handle_closest_enemy"
			end

			if var_0_97.debug then
				print("handle_stuck handle_closest_enemy")
			end
		elseif var_0_82(var_0_102.target_type) == "Teammate" then
			var_0_152()

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_stuck handle_teammate"
			end

			if var_0_97.debug then
				print("handle_stuck handle_teammate")
			end
		elseif var_0_82(var_0_102.target_type) == "Waypoint" then
			local var_53_0 = database.read("walkbot_db")[var_0_56()]

			if var_53_0 ~= nil then
				var_0_95.waypoint = var_53_0

				var_0_9(0.1, var_0_156)
			else
				print("No waypoint detected for this map")

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "no waypoint detected for this map"
				end
			end

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_stuck handle_waypoint"
			end

			if var_0_97.debug then
				print("handle_stuck handle_waypoint")
			end
		end

		var_0_9(0.1, var_0_156)

		var_0_96.stuckAttempts = 0
	end

	var_0_96.lastStuckHandleTick = var_0_52()
end

local function var_0_160()
	local var_54_0
	local var_54_1
	local var_54_2
	local var_54_3 = var_0_33("CPlantedC4")[1]

	if var_54_3 == nil then
		local var_54_4 = var_0_38()
		local var_54_5 = var_0_47(var_54_4, "m_iPlayerC4")

		if var_0_37(var_54_5) == "CCSPlayer" and not var_0_40(var_54_5) then
			var_54_3 = var_54_5
		end

		if var_54_3 == nil and planting_site ~= nil then
			var_54_0, var_54_1, var_54_2 = var_0_47(var_54_4, "m_bombsiteCenter" .. planting_site)
		end
	end

	if var_54_3 ~= nil then
		var_54_0, var_54_1, var_54_2 = var_0_47(var_54_3, "m_vecOrigin")
	end

	return var_54_0, var_54_1, var_54_2
end

local function var_0_161()
	local var_55_0 = var_0_33("CPlantedC4")[1]

	if var_0_47(var_55_0, "m_flC4Blow") == nil then
		return
	end

	local var_55_1 = var_0_47(var_55_0, "m_flC4Blow") - var_0_55()

	if var_55_0 == nil or var_55_1 == nil then
		return 0
	end

	if var_55_1 > 0 then
		return var_55_1
	end
end

local function var_0_162(arg_56_0)
	if arg_56_0 == 64 then
		if var_0_47(var_0_30(), "m_bHasDefuser") == 0 then
			return 10.03125
		end

		return 5.03125
	elseif arg_56_0 == 128 then
		if var_0_47(var_0_30(), "m_bHasDefuser") == 0 then
			return 10.0234375
		end

		return 5.0234375
	end
end

local function var_0_163(arg_57_0)
	if not var_0_82(var_0_102.enable) or var_0_95.navmesh_raw == nil then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	if not var_0_97.currMap == var_0_56() then
		var_0_135()

		return
	end

	local var_57_0 = var_0_30()
	local var_57_1 = var_0_47(var_0_45(var_57_0), "m_zoomLevel")
	local var_57_2 = var_0_47(var_57_0, "m_bIsScoped")

	if not var_57_1 then
		var_0_97.unscope = false
	elseif var_57_1 > 0 and var_0_97.unscope then
		if var_57_2 > 0 then
			arg_57_0.in_attack2 = 1

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "un_scope"
			end

			if var_0_97.debug then
				print("un_scope")
			end
		else
			client.exec("slot5;slot4;slot3;slot2")
			client.delay_call(9e-12, client.exec, "slot1")

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "quick_swap"
			end

			if var_0_97.debug then
				print("quick_swap")
			end
		end
	else
		var_0_97.unscope = false
	end

	local var_57_3 = var_0_82(var_0_102.target_type)

	if var_57_3 == "Waypoint" then
		if var_0_82(var_0_102.end_waypoint) then
			var_0_150()

			local var_57_4 = database.read("walkbot_db") or {}

			var_57_4[var_0_56()] = var_0_95.waypoint

			database.write("walkbot_db", var_57_4)
		end

		if var_0_82(var_0_102.calculate_path) then
			var_0_156()
		end
	elseif var_57_3 == "Closest enemy" then
		if var_0_95.path == nil or #var_0_95.path <= 0 then
			if var_0_97.previousC4 == nil then
				on_bomb_planted()

				return
			end

			if var_0_97.planted == false and var_0_113(var_0_82(var_0_102.option_automation), "Auto plant") and var_0_47(70, "m_iPlayerC4") == 1 and bit.band(var_0_47(var_57_0, "m_fFlags"), 1) == 1 and var_0_47(var_57_0, "m_bInBombZone") == 1 then
				arg_57_0.in_use = 1

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "c4_planting auto_plant"
				end

				if var_0_97.debug then
					print("c4_planting auto_plant")
				end

				return
			elseif var_0_97.planted == true and var_0_113(var_0_82(var_0_102.option_automation), "Auto defuse") and var_0_161() ~= nil and var_0_161() > 0 and var_0_47(var_57_0, "m_iTeamNum") == 3 and bit.band(var_0_47(var_57_0, "m_fFlags"), 1) == 1 then
				local var_57_5 = 1 / var_0_57()
				local var_57_6, var_57_7, var_57_8 = var_0_160()
				local var_57_9, var_57_10, var_57_11 = var_0_47(var_57_0, "m_vecOrigin")
				local var_57_12 = var_0_124(var_57_6, var_57_7, var_57_8, var_57_9, var_57_10, var_57_11)

				if var_0_161() >= var_0_162(var_57_5) - var_0_4() / var_57_5 and var_57_12 < 61.88 then
					if var_0_97.aa == false then
						var_0_97.previousAA = var_0_82(var_0_103.enable_aa)
						var_0_97.previousPitch = var_0_82(var_0_103.aa_pitch)
						var_0_97.aa = true
					end

					var_0_73(var_0_103.enable_aa, true)
					var_0_73(var_0_103.aa_pitch, "Down")

					arg_57_0.in_use = 1

					if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
						var_0_95.debug_stance = "defusing_c4 auto_defuse"
					end

					if var_0_97.debug then
						print("defusing_c4 auto_defuse")
					end
				end

				return
			end

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_closest_enemy on_setup_command"
			end

			if var_0_97.debug then
				print("handle_closest_enemy on_setup_command")
			end

			var_0_157()
			var_0_9(0.1, var_0_156)

			arg_57_0.in_use = 0
		end

		if var_0_82(var_0_102.calculate_path) then
			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_closest_enemy calculate_path set_pathway on_setup_command"
			end

			if var_0_97.debug then
				print("handle_closest_enemy calculate_path set_pathway on_setup_command")
			end

			var_0_157()
			var_0_156()
		end
	elseif var_57_3 == "Teammate" then
		if var_0_95.path == nil or #var_0_95.path <= 0 then
			if var_0_71() then
				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "update_follow_target"
				end

				if var_0_97.debug then
					print("update_follow_target")
				end

				var_0_155()
			end

			if var_0_97.planted == false and var_0_113(var_0_82(var_0_102.option_automation), "Auto plant") and var_0_47(70, "m_iPlayerC4") == 1 and bit.band(var_0_47(var_57_0, "m_fFlags"), 1) == 1 and var_0_47(var_57_0, "m_bInBombZone") == 1 then
				arg_57_0.in_use = 1

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "set_waypoint_teammate auto_plant"
				end

				if var_0_97.debug then
					print("set_waypoint_teammate auto_plant")
				end
			elseif var_0_97.planted == true and var_0_113(var_0_82(var_0_102.option_automation), "Auto defuse") and var_0_161() ~= nil and var_0_161() > 0 and var_0_47(var_57_0, "m_iTeamNum") == 3 and bit.band(var_0_47(var_57_0, "m_fFlags"), 1) == 1 then
				local var_57_13 = 1 / var_0_57()
				local var_57_14, var_57_15, var_57_16 = var_0_160()
				local var_57_17, var_57_18, var_57_19 = var_0_47(var_57_0, "m_vecOrigin")
				local var_57_20 = var_0_124(var_57_14, var_57_15, var_57_16, var_57_17, var_57_18, var_57_19)

				if var_0_161() >= var_0_162(var_57_13) - var_0_4() / var_57_13 and var_57_20 < 61.88 then
					if var_0_97.aa == false then
						var_0_97.previousAA = var_0_82(var_0_103.enable_aa)
						var_0_97.previousPitch = var_0_82(var_0_103.aa_pitch)
						var_0_97.aa = true
					end

					var_0_73(var_0_103.enable_aa, true)
					var_0_73(var_0_103.aa_pitch, "Down")

					arg_57_0.in_use = 1

					if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
						var_0_95.debug_stance = "set_waypoint_teammate auto_defuse"
					end

					if var_0_97.debug then
						print("set_waypoint_teammate auto_defuse")
					end
				end
			end

			if var_0_97.defused then
				arg_57_0.in_use = 0
			end

			if var_0_82(var_0_102.team_target) == nil and var_0_113(var_0_82(var_0_102.option_type), "Rand waypt if no mate") then
				var_0_154()
				var_0_9(0.1, var_0_156)

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "rand_way_mate no_mate_selected"
				end

				if var_0_97.debug then
					print("rand_way_mate no_mate_selected")
				end
			else
				var_0_152()
				var_0_9(0.1, var_0_156)

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "set_waypoint_teammate set_pathway"
				end

				if var_0_97.debug then
					print("set_waypoint_teammate set_pathway")
				end
			end
		end

		if var_0_82(var_0_102.calculate_path) then
			var_0_152()
			var_0_9(0.1, var_0_156)

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "set_waypoint_teammate calculate_path set_pathway"
			end

			if var_0_97.debug then
				print("set_waypoint_teammate calculate_path set_pathway")
			end
		end
	end

	var_0_149(arg_57_0)

	if var_0_95.path ~= nil and #var_0_95.path > 0 then
		local var_57_21, var_57_22, var_57_23 = var_0_133()

		if var_57_21 == nil then
			return
		end

		if var_0_124(var_57_21, var_57_22, var_57_23, var_0_95.path[1].x, var_0_95.path[1].y, var_0_95.path[1].z) < 50 or var_0_82(var_0_102.remove_point) then
			var_0_144()
		end

		if var_0_96.lastStuckHandleTick + var_0_125(4) < var_0_52() then
			var_0_159(arg_57_0)
		end
	end
end

local function var_0_164(arg_58_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_86(arg_58_0.userid) == var_0_30() then
		var_0_119()
		var_0_135()

		if var_0_113(var_0_82(var_0_102.option_automation), "Auto team join") and var_0_82(var_0_102.target_type) ~= "Waypoint" then
			local var_58_0 = var_0_82(var_0_102.auto_team)
			local var_58_1

			if var_58_0 == "Spectator" then
				var_58_1 = 1
			elseif var_58_0 == "Terrorist" then
				var_58_1 = 2
			elseif var_58_0 == "Counter-Terrorist" then
				var_58_1 = 3
			end

			var_0_9(0.5, client.exec, "jointeam " .. var_58_1 .. " 1")

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_player_connect_full joining " .. var_58_0
			end

			if var_0_97.debug then
				print("on_player_connect_full joining ", var_58_0)
			end
		end

		var_0_9(1, var_0_93)
	end
end

local function var_0_165(arg_59_0)
	if not var_0_82(var_0_102.enable) or var_0_95.navmesh_raw == nil then
		return
	end

	var_0_130()

	if var_0_86(arg_59_0.userid) == var_0_30() then
		if var_0_82(var_0_102.target_type) == "Closest enemy" then
			var_0_157()

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_player_spawn handle_closest_enemy"
			end

			if var_0_97.debug then
				print("on_player_spawn handle_closest_enemy")
			end
		elseif var_0_82(var_0_102.target_type) == "Teammate" then
			var_0_152()

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_player_spawn handle_teammate"
			end

			if var_0_97.debug then
				print("on_player_spawn handle_teammate")
			end
		elseif var_0_82(var_0_102.target_type) == "Waypoint" then
			local var_59_0 = database.read("walkbot_db")[var_0_56()]

			if var_59_0 ~= nil then
				var_0_95.waypoint = var_59_0

				var_0_9(0.1, var_0_156)
			else
				print("No waypoint detected for this map")
			end

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_player_spawn handle_waypoint"
			end

			if var_0_97.debug then
				print("on_player_spawn handle_waypoint")
			end
		end
	end
end

local function var_0_166(arg_60_0)
	if not var_0_82(var_0_102.enable) or var_0_95.navmesh_raw == nil then
		return
	end

	var_0_130()

	if var_0_97.aa then
		var_0_73(var_0_103.enable_aa, var_0_97.previousAA)
		var_0_73(var_0_103.aa_pitch, var_0_97.previousPitch)

		var_0_97.aa = false
	end

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "on_round_prestart generate_teammates"
	end

	if var_0_97.debug then
		print("on_round_prestart generate_teammates")
	end

	var_0_151()
	var_0_74(var_0_102.team_target, var_0_97.teammates)

	local var_60_0 = var_0_82(var_0_102.target_type)

	if var_60_0 == "Closest enemy" then
		var_0_153()
	elseif var_60_0 == "Teammate" then
		var_0_152()
	end

	var_0_9(0.1, var_0_156)

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "on_round_prestart set_pathway"
	end

	if var_0_97.debug then
		print("on_round_prestart set_pathway")
	end
end

local function var_0_167()
	var_0_9(0.1, var_0_156)
end

local function var_0_168(arg_62_0)
	if not var_0_82(var_0_102.enable) or var_0_95.navmesh_raw == nil then
		return
	end

	local var_62_0 = var_0_30()

	if var_0_86(arg_62_0.userid) == var_62_0 then
		var_0_130()
	end

	if var_0_86(arg_62_0.attacker) == var_62_0 or var_0_86(arg_62_0.assister) == var_62_0 then
		var_0_97.unscope = true
	end

	if var_0_97.planted == false and var_0_82(var_0_102.target_type) == "Closest enemy" and var_0_86(arg_62_0.attacker) == var_62_0 or var_0_86(arg_62_0.assister) == var_62_0 then
		var_0_157()

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "on_player_death rand_way_clos_dead"
		end

		if var_0_97.debug then
			print("on_player_death rand_way_clos_dead")
		end
	elseif var_0_97.planted == false and var_0_82(var_0_102.target_type) == "Teammate" and var_0_86(arg_62_0.userid) == var_0_95.follow_target and var_0_113(var_0_82(var_0_102.option_type), "Rand waypt if no mate") then
		var_0_154()

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "on_player_death rand_way_mate_dead"
		end

		if var_0_97.debug then
			print(var_0_86(arg_62_0.userid), "|", var_0_95.follow_target)
		end

		if var_0_97.debug then
			print("on_player_death rand_way_mate_dead")
		end
	end

	var_0_9(0.1, var_0_156)
end

local function var_0_169(arg_63_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	if var_0_113(var_0_82(var_0_102.option_automation), "Follow bomb_beginplant") then
		local var_63_0 = var_0_82(var_0_102.target_type)

		if var_0_86(arg_63_0.userid) ~= var_0_30() then
			if var_63_0 == "Closest enemy" or var_63_0 == "Teammate" then
				local var_63_1
				local var_63_2
				local var_63_3
				local var_63_4, var_63_5, var_63_6 = var_0_43(var_0_86(arg_63_0.userid))

				if var_63_4 == nil or var_63_5 == nil or var_63_6 == nil and var_0_97.debug then
					if var_0_97.debug then
						print("planter origin unknown")
					end
				else
					var_0_97.previousC4 = {
						var_63_4,
						var_63_5,
						var_63_6
					}
					var_0_95.waypoint = {
						var_63_4,
						var_63_5,
						var_63_6
					}

					if var_0_97.debug then
						if var_0_97.debug then
							print("on_bomb_beginplant bomb_coords | x:", var_63_4, " y:", var_63_5, " z:", var_63_6)
						end

						var_0_9(0.1, var_0_156)
					end

					if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
						var_0_95.debug_stance = "on_bomb_beginplant set_pathway"
					end

					if var_0_97.debug then
						print("on_bomb_beginplant set_pathway | ", unpack(var_0_95.waypoint))
					end
				end
			end
		else
			return
		end
	end
end

local function var_0_170(arg_64_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	local var_64_0 = var_0_82(var_0_102.target_type)
	local var_64_1 = var_0_30()
	local var_64_2 = var_0_47(var_64_1, "m_iTeamNum")

	if var_0_97.carrier then
		var_0_97.carrier = false

		return
	end

	if var_0_86(arg_64_0.userid) ~= var_0_30() then
		var_0_97.planted = true

		if var_0_113(var_0_82(var_0_102.option_automation), "Auto defuse") and var_64_2 == 3 then
			local var_64_3
			local var_64_4
			local var_64_5
			local var_64_6, var_64_7, var_64_8 = var_0_160()

			var_0_95.waypoint = {
				var_64_6,
				var_64_7,
				var_64_8
			}

			if var_0_97.debug then
				print("on_bomb_plant bomb_coords | x:", var_64_6, " y:", var_64_7, " z:", var_64_8)
			end

			if var_64_6 == nil or var_64_7 == nil or var_64_8 == nil then
				if var_0_97.previousC4 == nil then
					if var_0_146(arg_64_0.site) == "A" then
						local var_64_9, var_64_10, var_64_11 = var_0_47(var_0_38(), "m_bombsiteCenterA")
					else
						local var_64_12, var_64_13, var_64_14 = var_0_47(var_0_38(), "m_bombsiteCenterB")
					end

					var_0_95.waypoint = {
						siteX,
						siteY,
						siteZ
					}

					if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
						var_0_95.debug_stance = "on_bomb_plant bomb_coords = nil, going bombsite ", var_0_146(arg_64_0.site)
					end

					if var_0_97.debug then
						print("on_bomb_plant bomb_coords = nil, going bombsite ", var_0_146(arg_64_0.site))
					end
				else
					var_0_95.waypoint = var_0_97.previousC4

					if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
						var_0_95.debug_stance = "on_bomb_plant bomb_coords = nil, going begin_plantC4_coords"
					end

					if var_0_97.debug then
						print("on_bomb_plant bomb_coords = nil, going begin_plantC4_coords | ", unpack(var_0_95.waypoint))
					end
				end
			end

			var_0_9(0.1, var_0_156)

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				if var_0_97.debug then
					var_0_95.debug_stance = "auto_defuse set_pathway"
				end

				print("auto_defuse set_pathway | ", unpack(var_0_95.waypoint))
			end
		end
	else
		var_0_97.goingC4 = false

		if var_0_113(var_0_82(var_0_102.option_automation), "Stand still after plant") and var_64_2 == 2 then
			var_0_97.stand = true

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_bomb_planted stand_still"
			end

			if var_0_97.debug then
				print("on_bomb_planted stand_still")
			end
		else
			if var_64_0 == "Closest enemy" and var_0_97.defused == true then
				var_0_157()
			elseif var_64_0 == "Teammate" and var_0_97.defused == true then
				var_0_152()
			end

			var_0_9(0.1, var_0_156)

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_bomb_planted_going_selection set_pathway"
			end

			if var_0_97.debug then
				print("on_bomb_planted_going_selection set_pathway")
			end
		end
	end
end

local function var_0_171(arg_65_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	if var_0_113(var_0_82(var_0_102.option_automation), "Follow bomb_begindefuse") then
		local var_65_0 = var_0_82(var_0_102.target_type)

		if var_0_86(arg_65_0.userid) ~= var_0_30() then
			if var_65_0 == "Closest enemy" or var_65_0 == "Teammate" then
				local var_65_1
				local var_65_2
				local var_65_3
				local var_65_4, var_65_5, var_65_6 = var_0_43(var_0_86(arg_65_0.userid))

				var_0_95.waypoint = {
					var_65_4,
					var_65_5,
					var_65_6
				}

				var_0_9(0.1, var_0_156)

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "on_bomb_begindefuse set_pathway"
				end

				if var_0_97.debug then
					print("on_bomb_begindefuse set_pathway | ", var_65_4, " ", var_65_5, " ", var_65_6)
				end
			end
		else
			return
		end
	end
end

local function var_0_172(arg_66_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	var_0_97.planted = false
	var_0_97.defused = true

	local var_66_0 = var_0_82(var_0_102.target_type)

	if var_0_86(arg_66_0.userid) == var_0_30() then
		if var_66_0 == "Closest enemy" then
			var_0_157()
		elseif var_66_0 == "Teammate" then
			var_0_152()
		end

		var_0_9(0.1, var_0_156)

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "on_bomb_defused set_pathway"
		end

		if var_0_97.debug then
			print("on_bomb_defused set_pathway")
		end
	end

	if var_0_97.aa then
		var_0_73(var_0_103.enable_aa, var_0_97.previousAA)
		var_0_73(var_0_103.aa_pitch, var_0_97.previousPitch)

		var_0_97.aa = false
	end
end

local function var_0_173(arg_67_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	var_0_97.planted = false
	var_0_97.defused = true
end

local function var_0_174()
	var_0_97.carrier = false

	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	if var_0_113(var_0_82(var_0_102.option_automation), "Follow bomb_dropped") then
		local var_68_0 = var_0_33("CC4")
		local var_68_1
		local var_68_2
		local var_68_3

		for iter_68_0, iter_68_1 in ipairs(var_68_0) do
			local var_68_4, var_68_5, var_68_6 = var_0_47(iter_68_1, "m_vecOrigin")

			if var_68_4 ~= nil and var_68_5 ~= nil and var_68_6 ~= nil then
				if var_68_4 and var_68_5 and var_68_6 == 0 then
					var_0_97.goingC4 = false

					return
				end

				var_0_95.previousWaypoint = var_0_95.waypoint
				var_0_95.waypoint = {
					var_68_4,
					var_68_5,
					var_68_6
				}

				var_0_9(0.1, var_0_156)

				var_0_97.goingC4 = true

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "on_bomb_dropped going_c4"
				end

				if var_0_97.debug then
					print("on_bomb_dropped going_c4 | ", var_68_4, " ", var_68_5, " ", var_68_6)
				end
			else
				var_0_9(0.5, var_0_174)

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_95.debug_stance = "c4 nil, looping again"
				end

				if var_0_97.debug then
					print("c4 nil, looping again")
				end
			end
		end
	end
end

local function var_0_175(arg_69_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_35(var_0_30()) == false then
		return
	end

	if var_0_86(arg_69_0.userid) ~= var_0_30() then
		var_0_97.goingc4 = false
		var_0_95.waypoint = var_0_95.previousWaypoint

		if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
			var_0_95.debug_stance = "on_bomb_pickup going_previous_waypoint"
		end

		if var_0_97.debug then
			print("on_bomb_pickup going_previous_waypoint")
		end

		var_0_9(0.1, var_0_156)

		return
	end

	if var_0_113(var_0_82(var_0_102.option_automation), "Auto plant") then
		local var_69_0 = var_0_82(var_0_102.plant_slider)
		local var_69_1 = var_0_82(var_0_102.target_type)

		if (var_69_1 == "Closest enemy" or var_69_1 == "Teammate") and var_0_86(arg_69_0.userid) == var_0_30() then
			var_0_97.carrier = true

			if var_0_97.goingc4 == true then
				var_0_97.goingc4 = false
			end

			local var_69_2, var_69_3, var_69_4 = var_0_47(var_0_38(), "m_bombsiteCenterA")
			local var_69_5, var_69_6, var_69_7 = var_0_47(var_0_38(), "m_bombsiteCenterB")

			if var_69_0 == 0 then
				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_97.target_bombsite = "closest"
				end

				if var_0_97.debug then
					print("Going to Closest")
				end

				local var_69_8, var_69_9, var_69_10 = var_0_133(var_0_30())

				if var_0_124(var_69_8, var_69_9, var_69_10, var_69_2, var_69_3, var_69_4) < var_0_124(var_69_8, var_69_9, var_69_10, var_69_5, var_69_6, var_69_7) then
					var_0_95.waypoint = {
						var_69_2,
						var_69_3,
						var_69_4
					}
				else
					var_0_95.waypoint = {
						var_69_5,
						var_69_6,
						var_69_7
					}
				end
			elseif var_69_0 == 2 then
				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_97.target_bombsite = "a site"
				end

				if var_0_97.debug then
					print("Going to A")
				end

				var_0_95.waypoint = {
					var_69_2,
					var_69_3,
					var_69_4
				}
			elseif var_69_0 == 3 then
				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_97.target_bombsite = "b site"
				end

				if var_0_97.debug then
					print("Going to B")
				end

				var_0_95.waypoint = {
					var_69_5,
					var_69_6,
					var_69_7
				}
			elseif var_69_0 == 1 then
				local var_69_11 = var_0_3(1, 2)

				if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
					var_0_97.target_bombsite = "random"
				end

				if var_0_97.debug then
					var_0_97.target_bombsite = "random"

					print("Going to Random " .. var_69_11)
				end

				if var_69_11 == 1 then
					var_0_95.waypoint = {
						var_69_2,
						var_69_3,
						var_69_4
					}
				elseif var_69_11 == 2 then
					var_0_95.waypoint = {
						var_69_5,
						var_69_6,
						var_69_7
					}
				end
			end

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "on_bomb_pickup set_pathway"
			end

			if var_0_97.debug then
				print("on_bomb_pickup set_pathway | ", unpack(var_0_95.waypoint))
			end

			var_0_97.goingC4 = false

			var_0_9(0.1, var_0_156)
		end
	end
end

local function var_0_176(arg_70_0)
	if not var_0_82(var_0_102.enable) then
		return
	end

	if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
		var_0_95.debug_stance = "on_teamchange generate_teammates"
	end

	if var_0_97.debug then
		print("on_teamchange generate_teammates")
	end

	var_0_151()
	var_0_74(var_0_102.team_target, var_0_97.teammates)
end

local function var_0_177(arg_71_0)
	var_0_64(var_0_102.calculate_path, arg_71_0)
	var_0_64(var_0_102.remove_point, arg_71_0)
	var_0_64(var_0_102.end_waypoint, arg_71_0)
end

local function var_0_178()
	if var_0_82(var_0_102.enable) then
		local var_72_0 = var_0_82(var_0_102.target_type)

		var_0_64(var_0_102.target_type, true)
		var_0_64(var_0_102.option_type, true)

		if var_72_0 == "Waypoint" then
			var_0_177(true)
			var_0_64(var_0_102.team_target, false)
			var_0_64(var_0_102.option_automation, false)
			var_0_64(var_0_102.plant_slider, false)
			var_0_64(var_0_102.pathlabel, false)
			var_0_64(var_0_102.pathcolor, false)
			var_0_64(var_0_102.auto_team, false)
		elseif var_72_0 == "Closest enemy" then
			var_0_64(var_0_102.team_target, false)
		elseif var_72_0 == "Teammate" then
			var_0_177(false)
			var_0_151()
			var_0_74(var_0_102.team_target, var_0_97.teammates)
			var_0_64(var_0_102.team_target, true)

			if var_0_113(var_0_82(var_0_102.option_type), "Debug Panel") then
				var_0_95.debug_stance = "handle_menu generate_teammates"
			end

			if var_0_97.debug then
				print("handle_menu generate_teammates")
			end
		end

		if var_72_0 == "Teammate" or var_72_0 == "Closest enemy" then
			var_0_177(false)
			var_0_64(var_0_102.calculate_path, true)
			var_0_64(var_0_102.option_automation, true)

			if var_0_113(var_0_82(var_0_102.option_type), "Show Path") then
				var_0_64(var_0_102.pathlabel, true)
				var_0_64(var_0_102.pathcolor, true)
			else
				var_0_64(var_0_102.pathlabel, false)
				var_0_64(var_0_102.pathcolor, false)
			end

			if var_0_113(var_0_82(var_0_102.option_automation), "Auto plant") then
				var_0_64(var_0_102.plant_slider, true)
			else
				var_0_64(var_0_102.plant_slider, false)
			end

			if var_0_113(var_0_82(var_0_102.option_automation), "Auto team join") then
				var_0_64(var_0_102.auto_team, true)
			else
				var_0_64(var_0_102.auto_team, false)
			end
		end
	else
		for iter_72_0, iter_72_1 in pairs(var_0_102) do
			var_0_64(iter_72_1, false)
		end

		var_0_64(var_0_102.enable, true)
	end
end

var_0_78(var_0_102.enable, var_0_178)
var_0_78(var_0_102.target_type, var_0_178)
var_0_78(var_0_102.option_type, var_0_178)
var_0_78(var_0_102.option_automation, var_0_178)
var_0_178()
var_0_88("paint", var_0_158)
var_0_88("setup_command", var_0_163)
var_0_88("round_prestart", var_0_166)
var_0_88("round_freeze_end", var_0_167)
var_0_88("player_spawn", var_0_165)
var_0_88("player_connect_full", var_0_164)
var_0_88("player_death", var_0_168)
var_0_88("player_team", var_0_176)
var_0_88("player_disconnect", var_0_176)
var_0_88("bomb_planted", var_0_170)
var_0_88("bomb_begindefuse", var_0_171)
var_0_88("bomb_beginplant", var_0_169)
var_0_88("bomb_exploded", var_0_173)
var_0_88("bomb_pickup", var_0_175)
var_0_88("bomb_defused", var_0_172)
var_0_88("bomb_abortdefuse", var_0_171)
var_0_88("bomb_dropped", function(arg_73_0)
	if var_0_86(arg_73_0.userid) == var_0_30() then
		var_0_9(3, var_0_174)
	end
end)
