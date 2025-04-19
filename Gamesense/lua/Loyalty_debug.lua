-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
--[[
    loyalty.lua

    author: invalidcode#1337

    TODO:
    - Finish menu elements handling DONE!!

    - Per state antiaim DONE!!
    - Anti bruteforce 
    - Disable jitter on lethal and low height
    - Disable jitter on freestand activation
    - Crosshair indicator

    - Break extrapolation
    - Anti overlap (maybe?)

    - Quickfall
    - Roll indicator
    - Body aim conditions
]]

--@region dependencies
local ent_found, ent = pcall(require, "gamesense/entity")
if not ent_found then
	error("gamesense/entity not found, please subscribe at https://gamesense.pub/forums/viewtopic.php?id=27529")
end

local ffi = require("ffi")
local ref = require("ref_lib")
local vector = require("vector")
--@endregion

local SCRIPT_BUILDS = {
	rage = "rage",
	semirage = "semirage",
	beta = "beta",
	debug = "debug",
}

local function get_build(build)
	build = string.lower(build)

	if build == "user" then
		return "rage"
	elseif build == "beta" then
		return "semirage"
	elseif build == "debug" then
		return "beta"
	else
		return "debug"
	end
end

--@region script info
local obex_data = obex_fetch and obex_fetch() or {
	build = "dev",
	username = "dev",
}

local script = {
	name = "loyalty",
	version = "3.0",
	build = get_build(obex_data.build),
	discord = "https://discord.gg/zQxAzgbbGX",
	username = obex_data.username,
}
print(script.build)
--@endregion

--@region enums
local PLAYER_STATES = {
	stand = "stand",
	move = "move",
	crouch = "crouch",
	slow = "slow",
	air = "air",
	airCrouch = "air crouch",
}

local AA_MODES = {
	main = "main",
	alternative = "alternative",
	semirage = "semirage",
	custom = "custom",
}

local BYAW_MODES = {
	normal = "normal",
	reversed = "reversed",
	none = "none",
}

local TABS = {
	general = "general",
	aa = "aa",
	misc = "misc",
	visuals = "visuals",
	semirage = "semirage",
}
--@endregion

--@region utils
local gamerules_ptr = client.find_signature("client.dll", "\x83\x3D\xCC\xCC\xCC\xCC\xCC\x74\x2A\xA1")
local gamerules = ffi.cast("intptr_t**", ffi.cast("intptr_t", gamerules_ptr) + 2)[0]

local function table_values(t, col)
	local values = {}
	for k, v in pairs(t) do
		if col == "k" then
			table.insert(values, k)
		elseif col == "v" then
			table.insert(values, v)
		else
			print("invalid col")
		end
	end

	return values
end

local function vectorize(table)
	return vector(table[1], table[2], table[3])
end

entity.get_velocity = function(ent)
	local vel = vectorize({ entity.get_prop(ent, "m_vecVelocity") })

	return math.sqrt(vel.x ^ 2 + vel.y ^ 2)
end

entity.is_crouching = function(ent)
	local flags = entity.get_prop(ent, "m_fFlags")

	return bit.band(flags, 4) == 4
end

entity.is_in_air = function(ent)
	local flags = entity.get_prop(ent, "m_fFlags")

	return bit.band(flags, 1) ~= 1
end

entity.sanitize = function(ent)
	return entity.is_alive(ent) and not entity.is_dormant(ent)
end

entity.get_height = function(ent)
	return ({ entity.get_prop(ent, "m_vecOrigin") })[3]
end

entity.get_distance = function(ent1, ent2)
	local ent1_pos = vector(entity.get_prop(ent1, "m_vecOrigin"))
	local ent2_pos = vector(entity.get_prop(ent2, "m_vecOrigin"))

	return ent1_pos:dist(ent2_pos)
end

entity.extrapolate_position = function(position, ticks, ent)
	local velocity = vectorize({ entity.get_prop(ent, "m_vecVelocity") })

	return position + velocity * ticks * globals.tickinterval()
end

math.calc_angle = function(local_x, local_y, enemy_x, enemy_y)
	local ydelta = local_y - enemy_y
	local xdelta = local_x - enemy_x
	local relativeyaw = math.atan(ydelta / xdelta)
	relativeyaw = math.normalize_angle(relativeyaw * 180 / math.pi)
	if xdelta >= 0 then
		relativeyaw = math.normalize_angle(relativeyaw + 180)
	end
	return relativeyaw
end

math.closest_vec_dist = function(A, B, C)
	local d = (A - B) / A:dist(B)
	local v = C - B
	local t = v:dot(d)
	local P = B + d:scaled(t)

	return P:dist(C)
end

math.angle_vector = function(angle_x, angle_y)
	local sy = math.sin(math.rad(angle_y))
	local cy = math.cos(math.rad(angle_y))
	local sp = math.sin(math.rad(angle_x))
	local cp = math.cos(math.rad(angle_x))
	return cp * cy, cp * sy, -sp
end

math.normalize_angle = function(angle)
	while angle > 180 do
		angle = angle - 360
	end
	while angle < -180 do
		angle = angle + 360
	end
	return angle
end

local function contains(menu, val)
	for k, v in pairs(ui.get(menu)) do
		if v == val then
			return true
		end
	end

	return false
end

local function get_damage(me, enemy, x, y, z)
	local ex = {}
	local ey = {}
	local ez = {}
	ex[0], ey[0], ez[0] = entity.hitbox_position(enemy, 1)
	ex[1], ey[1], ez[1] = ex[0] + 40, ey[0], ez[0]
	ex[2], ey[2], ez[2] = ex[0], ey[0] + 40, ez[0]
	ex[3], ey[3], ez[3] = ex[0] - 40, ey[0], ez[0]
	ex[4], ey[4], ez[4] = ex[0], ey[0] - 40, ez[0]
	ex[5], ey[5], ez[5] = ex[0], ey[0], ez[0] + 40
	ex[6], ey[6], ez[6] = ex[0], ey[0], ez[0] - 40
	local bestdamage = 0
	local bent
	for i = 0, 6 do
		local ent, damage = client.trace_bullet(enemy, ex[i], ey[i], ez[i], x, y, z)
		if damage > bestdamage then
			bent = ent
			bestdamage = damage
		end
	end

	return bent == nil and client.scale_damage(me, 1, bestdamage) or bestdamage
end

--@endregion

--@region shared
local shared = {
	state = PLAYER_STATES.stand,
	me = 0,
	target = -1,
	cur_tab = "",
}

function shared:update()
	local me = entity.get_local_player()
	local vel = entity.get_velocity(me)

	self.me = me
	self.target = client.current_threat()

	if entity.is_crouching(me) and entity.is_in_air(me) then
		self.state = PLAYER_STATES.airCrouch
	elseif entity.is_crouching(me) then
		self.state = PLAYER_STATES.crouch
	elseif entity.is_in_air(me) then
		self.state = PLAYER_STATES.air
	elseif ui.get(ref.antiaim_other.slow_motion[2]) then
		self.state = PLAYER_STATES.slow
	elseif vel > 3 then
		self.state = PLAYER_STATES.move
	else
		self.state = PLAYER_STATES.stand
	end
end
--@endregion

--@region menu
local TAB, CONTAINER = "AA", "Anti-aimbot angles"

local function generate_custom_menu()
	local aa = {}

	for _, state in pairs(PLAYER_STATES) do
		aa[state] = {}

		if script.build == SCRIPT_BUILDS.beta or script.build == SCRIPT_BUILDS.debug then
			aa[state].pitch = ui.new_combobox(
				TAB,
				CONTAINER,
				string.format("[%s] Pitch", state),
				{ "off", "default", "up", "down", "minimal" }
			)

			aa[state].yaw = ui.new_combobox(
				TAB,
				CONTAINER,
				string.format("[%s] Yaw", state),
				{ "off", "180", "spin", "static", "180 Z", "Crosshair" }
			)
		end

		aa[state].yaw_offset_r = ui.new_slider(
			TAB,
			CONTAINER,
			string.format("[%s] right->Yaw offset", state),
			-180,
			180,
			0,
			true,
			"°",
			1,
			{}
		)
		aa[state].yaw_offset_l = ui.new_slider(
			TAB,
			CONTAINER,
			string.format("[%s] left->Yaw offset", state),
			-180,
			180,
			0,
			true,
			"°",
			1,
			{}
		)

		aa[state].jitter_mode = ui.new_combobox(
			TAB,
			CONTAINER,
			string.format("[%s] Jitter mode", state),
			{ "off", "center", "offset", "random", "skitter" }
		)
		aa[state].jitter_offset =
			ui.new_slider(TAB, CONTAINER, string.format("[%s] Jitter offset", state), -180, 180, 0, true, "°", 1, {})

		aa[state].at_targets = ui.new_checkbox(TAB, CONTAINER, string.format("[%s] At targets", state))
		aa[state].byaw_mode = ui.new_combobox(
			TAB,
			CONTAINER,
			string.format("[%s] Body yaw controller", state),
			table_values(BYAW_MODES, "k")
		)
		aa[state].roll = ui.new_slider(
			TAB,
			CONTAINER,
			string.format("\aB6B665FF[%s] Force roll", state),
			0,
			45,
			0,
			true,
			"°",
			1,
			{}
		)

		-- ui.set_callback(aa[state].jitter_mode, function ()
		--     ui.set_visible(aa[state].jitter_offset, ui.get(aa[state].jitter_mode) ~= 'none')
		-- end)
	end

	return aa
end

local generate_semirage_menu = function()
	if script.build == SCRIPT_BUILDS.rage then
		return {
			disabled_label = ui.new_label(TAB, CONTAINER, "Semirage features are not"),
			disabled_label2 = ui.new_label(TAB, CONTAINER, "available in rage build"),
		}
	end

	return {
		override_switch = ui.new_checkbox(TAB, CONTAINER, "Enable semirage features"),
		mm_roll_switch = ui.new_checkbox(TAB, CONTAINER, "Enable roll in MM"),
		dynamic_fov = ui.new_checkbox(TAB, CONTAINER, "Dynamic FOV"),
		min_fov = ui.new_slider(TAB, CONTAINER, "Minimum FOV", 1, 30, 3, true, "°", 1),
		max_fov = ui.new_slider(TAB, CONTAINER, "Maximum FOV", 1, 30, 15, true, "°", 1),
		autowall_hk = ui.new_hotkey(TAB, CONTAINER, "Automatic penetration"),
		autofire_hk = ui.new_hotkey(TAB, CONTAINER, "Automatic fire"),
	}
end

local get_aa_modes = function()
	if script.build == SCRIPT_BUILDS.rage then
		return { "main", "alternative", "custom" }
	elseif script.build == SCRIPT_BUILDS.semirage then
		return { "semirage", "custom" }
	else
		return { "main", "alternative", "semirage", "custom" }
	end
end

local menu = { -- First-level tables are reserved for actual tabs only
	enable = ui.new_checkbox(TAB, CONTAINER, string.format("\a6580b6FF[%s] Enable", script.name)),
	tab = ui.new_combobox(TAB, CONTAINER, "Active tab", { "general", "aa", "semirage", "visuals", "misc" }),

	general = {
		_name = ui.new_label(TAB, CONTAINER, string.format("Welcome, %s", script.username)),
		_version = ui.new_label(TAB, CONTAINER, string.format("Version: %s | build: %s", script.version, script.build)),
		_discord = ui.new_label(TAB, CONTAINER, string.format("Discord: %s", script.discord)),
	},

	aa = {
		mode = ui.new_combobox(TAB, CONTAINER, "AA mode", get_aa_modes()),
		state = ui.new_combobox(
			TAB,
			CONTAINER,
			"Player state",
			{ "stand", "move", "crouch", "slow", "air", "air crouch" }
		),
		custom = generate_custom_menu(), -- ex: menu.aa.custom[PLAYER_STATES.stand].jitter_offset

		legit_hk = ui.new_hotkey(TAB, CONTAINER, "Legit AA"),
		edge_hk = ui.new_hotkey(TAB, CONTAINER, "Edge yaw"),
		roll_hk = ui.new_hotkey(TAB, CONTAINER, "\aB6B665FFForce roll"),

		manual_switch = ui.new_checkbox(TAB, CONTAINER, "Manual AA"),
		left_hk = ui.new_hotkey(TAB, CONTAINER, "Manual left"),
		right_hk = ui.new_hotkey(TAB, CONTAINER, "Manual right"),

		disable_jitter_cond = ui.new_multiselect(
			TAB,
			CONTAINER,
			"Disable jitter",
			{ "Lethal", "Freestand", "Legit AA", "Manual AA" }
		),
		pha_switch = ui.new_checkbox(TAB, CONTAINER, "Prevent height advantage"),
	},

	misc = {
		quick_fall = ui.new_hotkey(TAB, CONTAINER, "Quick fall", false),
		leg_anim = ui.new_combobox(TAB, CONTAINER, "Leg animation", { "Off", "Static legs", "Moving legs" }),
	},

	visuals = {
		indicator_switch = ui.new_checkbox(TAB, CONTAINER, "Crosshair indicator"),
		primary_label = ui.new_label(TAB, CONTAINER, "Primary color"),
		primary_picker = ui.new_color_picker(TAB, CONTAINER, "primary_clr", 255, 255, 255, 255),
		secondary_label = ui.new_label(TAB, CONTAINER, "Secondary color"),
		secondary_picker = ui.new_color_picker(TAB, CONTAINER, "secondary_clr", 255, 255, 255, 255),
	},

	semirage = generate_semirage_menu(),
}

shared.cur_tab = ui.get(menu.tab)

function menu:handle_visibility(table, show, tab_active)
	local enabled = ui.get(self.enable)
	local tab = ui.get(self.tab)

	for k, v in pairs(table and table or menu) do
		if type(v) == "table" then
			local show_tab = false

			if not table then -- If current table is a first-level tab
				show_tab = tab == k and enabled

				self:handle_visibility(v, show_tab, show_tab)
			else -- If current table is not a subsection of a tab
				self:handle_visibility(v, tab_active, tab_active)
			end
		elseif v ~= menu.enable and v ~= menu.tab then
			if type(v) ~= "function" then
				ui.set_visible(v, show and enabled)
			end
		end
	end

	local custom_visible = shared.cur_tab == TABS.aa and ui.get(self.aa.mode) == AA_MODES.custom
	ui.set_visible(self.aa.state, enabled and custom_visible)

	for k, v in pairs(self.aa.custom) do
		local visible = k == ui.get(self.aa.state) and enabled and custom_visible

		for k, element in pairs(v) do
			ui.set_visible(element, visible)
		end
	end

	ui.set_visible(self.aa.right_hk, shared.cur_tab == TABS.aa and ui.get(self.aa.manual_switch))
	ui.set_visible(self.aa.left_hk, shared.cur_tab == TABS.aa and ui.get(self.aa.manual_switch))

	if script.build ~= SCRIPT_BUILDS.rage then
		ui.set_visible(self.semirage.max_fov, shared.cur_tab == TABS.semirage and ui.get(self.semirage.dynamic_fov))
		ui.set_visible(self.semirage.min_fov, shared.cur_tab == TABS.semirage and ui.get(self.semirage.dynamic_fov))
	end
end
menu:handle_visibility()
--@endregion

--@region aa
local aa = {
	best_angle = -1,
	brute = {
		modifier = 1,
		last_time = 0,
	},
	last_manual_time = 0,
	is_manual_aa = false,
	is_valve_ds_spoofed = false,
	last_fl_val = nil,
}

aa.presets = {
	[AA_MODES.main] = {
		[PLAYER_STATES.stand] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = -16,
			yaw_offset_l = 18,

			jitter_mode = "skitter",
			jitter_offset = 35,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.move] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 0,
			yaw_offset_l = 0,

			jitter_mode = "center",
			jitter_offset = 45,

			at_targets = false,
			byaw_mode = BYAW_MODES.none,
			roll = 0,
		},
		[PLAYER_STATES.crouch] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 4,
			yaw_offset_l = 4,

			jitter_mode = "center",
			jitter_offset = 45,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.air] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 8,
			yaw_offset_l = 8,

			jitter_mode = "center",
			jitter_offset = 42,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.airCrouch] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 18,
			yaw_offset_l = 18,

			jitter_mode = "center",
			jitter_offset = 42,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.slow] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 0,
			yaw_offset_l = 0,

			jitter_mode = "center",
			jitter_offset = 40,

			at_targets = false,
			byaw_mode = BYAW_MODES.none,
			roll = 0,
		},
	},
	[AA_MODES.alternative] = {
		[PLAYER_STATES.stand] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = -12,
			yaw_offset_l = 17,

			jitter_mode = "off",
			jitter_offset = 36,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.move] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = 8,
			yaw_offset_l = 8,

			jitter_mode = "skitter",
			jitter_offset = 38,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.crouch] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = -10,
			yaw_offset_l = 15,

			jitter_mode = "off",
			jitter_offset = 48,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.air] = {
			pitch = "random",
			yaw = "180",
			yaw_offset_r = 5,
			yaw_offset_l = 12,

			jitter_mode = "skitter",
			jitter_offset = 37,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.airCrouch] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = -12,
			yaw_offset_l = 17,

			jitter_mode = "skitter",
			jitter_offset = 40,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.slow] = {
			pitch = "down",
			yaw = "180",
			yaw_offset_r = -13,
			yaw_offset_l = 9,

			jitter_mode = "off",
			jitter_offset = 50,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
	},
	[AA_MODES.semirage] = {
		[PLAYER_STATES.stand] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = -12,
			yaw_offset_l = 17,

			jitter_mode = "off",
			jitter_offset = 36,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.move] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = 8,
			yaw_offset_l = 8,

			jitter_mode = "skitter",
			jitter_offset = 38,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.crouch] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = -10,
			yaw_offset_l = 15,

			jitter_mode = "off",
			jitter_offset = 48,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.air] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = 5,
			yaw_offset_l = 12,

			jitter_mode = "skitter",
			jitter_offset = 37,

			at_targets = true,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.airCrouch] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = -12,
			yaw_offset_l = 17,

			jitter_mode = "skitter",
			jitter_offset = 40,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
		[PLAYER_STATES.slow] = {
			pitch = "off",
			yaw = "off",
			yaw_offset_r = -13,
			yaw_offset_l = 9,

			jitter_mode = "off",
			jitter_offset = 50,

			at_targets = false,
			byaw_mode = BYAW_MODES.normal,
			roll = 0,
		},
	},
}

function aa:init()
	local mode = ui.get(menu.aa.mode)

	if mode == AA_MODES.custom then
		self.preset = menu.aa.custom
	else
		self.preset = aa.presets[mode]
	end

	self.state = shared.state

	local function get_value(value)
		return mode == AA_MODES.custom and ui.get(value) or value
	end

	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60

	if script.build == SCRIPT_BUILDS.semirage then
		self.pitch = mode == AA_MODES.custom and "off" or self.preset[self.state].pitch
		self.yaw = mode == AA_MODES.custom and "off" or self.preset[self.state].yaw
	elseif script.build == SCRIPT_BUILDS.rage then
		self.pitch = mode == AA_MODES.custom and "down" or self.preset[self.state].pitch
		self.yaw = mode == AA_MODES.custom and "180" or self.preset[self.state].yaw
	else
		self.pitch = get_value(self.preset[self.state].pitch)
		self.yaw = get_value(self.preset[self.state].yaw)
	end

	if not self.is_manual_aa then
		self.yaw_offset =
			get_value(bodyyaw < 0 and self.preset[self.state].yaw_offset_l or self.preset[self.state].yaw_offset_r)
	end
	self.jitter_mode = get_value(self.preset[self.state].jitter_mode)
	self.jitter_offset = get_value(self.preset[self.state].jitter_offset)
	self.at_targets = get_value(self.preset[self.state].at_targets)
	self.byaw_mode = get_value(self.preset[self.state].byaw_mode)
	self.byaw = 0

	self.roll = get_value(self.preset[self.state].roll)
end

function aa:run_adjustments(cmd)
	function self:get_best_angle()
		local me = shared.me
		local best_enemy = shared.target

		if not entity.sanitize(best_enemy) or not entity.sanitize(me) then
			return { best_angle = -1, damage = 0 }
		end

		local lx, ly, lz = client.eye_position()

		local e_x, e_y = entity.hitbox_position(best_enemy, 0)

		local yaw = math.calc_angle(lx, ly, e_x, e_y)
		local rdir_x, rdir_y = math.angle_vector(0, (yaw + 90))
		local rend_x = lx + rdir_x * 10
		local rend_y = ly + rdir_y * 10

		local ldir_x, ldir_y = math.angle_vector(0, (yaw - 90))
		local lend_x = lx + ldir_x * 10
		local lend_y = ly + ldir_y * 10

		local r2dir_x, r2dir_y = math.angle_vector(0, (yaw + 90))
		local r2end_x = lx + r2dir_x * 50
		local r2end_y = ly + r2dir_y * 50

		local l2dir_x, l2dir_y = math.angle_vector(0, (yaw - 90))
		local l2end_x = lx + l2dir_x * 50
		local l2end_y = ly + l2dir_y * 50

		local ldamage = get_damage(me, best_enemy, rend_x, rend_y, lz)
		local rdamage = get_damage(me, best_enemy, lend_x, lend_y, lz)

		local l2damage = get_damage(me, best_enemy, r2end_x, r2end_y, lz)
		local r2damage = get_damage(me, best_enemy, l2end_x, l2end_y, lz)

		local max_ldamage = math.max(ldamage, l2damage)
		local max_rdamage = math.max(rdamage, r2damage)

		if math.abs(max_ldamage - max_rdamage) < 10 then
			return { best_angle = -1, damage = (max_ldamage > max_rdamage) and max_ldamage or max_rdamage }
		end

		if l2damage > r2damage or ldamage > rdamage then
			return { best_angle = 0, damage = max_ldamage }
		elseif r2damage > l2damage or rdamage > ldamage then
			return { best_angle = 1, damage = max_rdamage }
		else
			return { best_angle = -1, damage = 0 }
		end
	end

	function self:get_height_advantage(target)
		if not target or not entity.sanitize(target) then
			return 0
		end

		local me_height = entity.get_height(shared.me)
		local target_height = entity.get_height(target)

		local dist = entity.get_distance(shared.me, target)

		local height_diff = target_height - me_height
		local height_advantage = height_diff / dist

		return height_advantage
	end

	local fs = self:get_best_angle()

	-- Jitter disabler checks
	local disable_jitter = false

	self.fs_damage = fs.damage
	self.height_advantage = self:get_height_advantage(shared.target)
	local health = entity.get_prop(shared.me, "m_iHealth")

	local is_height_advantage = self.height_advantage > 0.2
	local is_lethal = health < 40 -- if we are not in height advantage and enemy can one-shot us
	local is_fs = (ui.get(ref.antiaim.freestanding[1]) and ui.get(ref.antiaim.freestanding[2]))

	if
		(is_lethal and contains(menu.aa.disable_jitter_cond, "Lethal"))
		or (is_fs and contains(menu.aa.disable_jitter_cond, "Freestand"))
		or (ui.get(menu.aa.legit_hk) and contains(menu.aa.disable_jitter_cond, "Legit AA")) and not is_height_advantage
		or (contains(menu.aa.disable_jitter_cond, "Manual AA") and self.is_manual_aa)
	then
		disable_jitter = true
	end

	if disable_jitter then
		self.jitter_mode = "Off"
		self.byaw_mode = BYAW_MODES.reversed
	end

	-- Prevent height advantage
	if ui.get(menu.aa.pha_switch) and is_height_advantage then
		self.pitch = "Down"
		self.yaw = "Off"
	end

	-- Body yaw freestanding
	if fs.best_angle ~= -1 then
		if self.byaw_mode == BYAW_MODES.normal then
			self.byaw = 180 * (fs.best_angle == 0 and -1 or 1)
		else
			self.byaw = 180 * (fs.best_angle == 0 and 1 or -1)
		end

		if self.pitch == "off" then
			self.byaw = self.byaw * -1
		end
	elseif self.byaw_mode ~= BYAW_MODES.none then
		self.byaw = 180
	end

	self.roll = self.roll * (self.byaw > 0 and -1 or 1)

	if self.state == PLAYER_STATES.air or self.state == PLAYER_STATES.airCrouch then
		cmd.force_defensive = true
	end
end

function aa:legit_on_key(cmd)
	if not ui.get(menu.aa.legit_hk) then
		return
	end

	local wpn_name = entity.get_classname(entity.get_player_weapon(shared.me))

	local should_legit_aa = true

	local m_iTeamNum = entity.get_prop(shared.me, "m_iTeamNum")
	if wpn_name == "CC4" then
		should_legit_aa = false
	elseif m_iTeamNum == 3 then
		local c4 = entity.get_all("CPlantedC4")

		for i = 1, #c4 do
			local dist = entity.get_distance(shared.me, c4[i])

			if dist <= 100 then
				should_legit_aa = false
				break
			end
		end

		local hostages = entity.get_all("CHostage")
		for i = 1, #hostages do
			local dist = entity.get_distance(shared.me, hostages[i])

			if dist <= 100 then
				should_legit_aa = false
				break
			end
		end
	end

	if should_legit_aa then
		-- self.byaw_mode = BYAW_MODES.normal
		self.at_targets = true
		self.pitch = "Off"
		self.yaw = "Off"

		cmd.in_use = 0
	end
end

function aa:mm_roll()
	if script.build == SCRIPT_BUILDS.rage or not ui.get(menu.semirage.override_switch) then
		return
	end

	local is_valve_ds = ffi.cast("bool*", gamerules[0] + 124)

	if is_valve_ds ~= nil then
		if self.roll ~= 0 and ui.get(menu.semirage.mm_roll_switch) then
			if is_valve_ds[0] == true then
				is_valve_ds[0] = 0
				self.is_valve_ds_spoofed = 1
			end
		else
			if is_valve_ds[0] == false and self.is_valve_ds_spoofed == 1 then
				self.roll = 0
			end
		end
	end

	if self.is_valve_ds_spoofed == 1 then
		if cvar.sv_maxusrcmdprocessticks:get_int() ~= 7 then
			if ui.get(ref.fakelag.limit) > 6 then
				self.last_fl_val = ui.get(ref.fakelag.limit)
				ui.set(ref.fakelag.limit, 6)
			end

			client.set_cvar("sv_maxusrcmdprocessticks", "7")
		end
	else
		if self.last_fl_val ~= nil then
			ui.set(ref.fakelag.limit, self.last_fl_val)
			self.last_fl_val = nil
		end

		if cvar.sv_maxusrcmdprocessticks:get_int() ~= 16 then
			client.set_cvar("sv_maxusrcmdprocessticks", "16")
		end
	end
end

function aa:handle_on_key()
	ui.set(ref.antiaim.edge_yaw, ui.get(menu.aa.edge_hk))

	if ui.get(menu.aa.manual_switch) then
		local yaw = self.roll > 0 and 65 or 90

		if ui.get(menu.aa.left_hk) and self.last_manual_time + 0.2 < globals.curtime() then
			self.yaw_offset = self.yaw_offset == -yaw and 0 or -yaw
			self.is_manual_aa = self.yaw_offset == -yaw
			self.last_manual_time = globals.curtime()
		elseif ui.get(menu.aa.right_hk) and self.last_manual_time + 0.2 < globals.curtime() then
			self.yaw_offset = self.yaw_offset == yaw and 0 or yaw
			self.is_manual_aa = self.yaw_offset == yaw
			self.last_manual_time = globals.curtime()
		elseif self.last_manual_time > globals.curtime() then
			self.last_manual_time = globals.curtime()
		end
	end

	local adjust_values_for_mm = script.build ~= SCRIPT_BUILDS.rage and ui.get(menu.semirage.mm_roll_switch)

	if ui.get(menu.aa.roll_hk) then
		self.roll = (50 - (adjust_values_for_mm and self.is_valve_ds_spoofed * 6 or 0)) * (self.byaw > 0 and -1 or 1)
		self.yaw_offset = self.roll > 0 and -10 or 10
		self.jitter_mode = "Off"
		self.byaw_mode = BYAW_MODES.normal
	end
end

function aa.brute:controller()
	if globals.curtime() > self.last_time + 2 then
		self.modifier = 1
	end

	aa.byaw = aa.byaw * self.modifier
end

function aa.brute:event(e)
	local shooter = client.userid_to_entindex(e.userid)

	if not entity.sanitize(shooter) or not entity.is_enemy(shooter) then
		return
	end

	local shooter_pos = vectorize({ entity.get_origin(shooter) })
	local eye_pos = vectorize({ client.eye_position(shared.me) })
	local shot_pos = vector(e.x, e.y, e.z)

	local dist = math.closest_vec_dist(shooter_pos, shot_pos, eye_pos)

	if dist < 45 and globals.curtime() - self.last_time > 0.2 then
		print(
			string.format(
				"[%s] 》Adjusted antiaim due to anti-bruteforce | dist: %s",
				script.name,
				tostring(math.ceil(dist * 10) / 10)
			)
		)
		self.modifier = self.modifier * -1
		self.last_time = globals.curtime()
	end
end

function aa:override(cmd)
	ui.set(ref.antiaim.yaw[1], self.yaw)
	ui.set(ref.antiaim.pitch, self.pitch)

	ui.set(ref.antiaim.yaw[2], self.yaw_offset)
	ui.set(ref.antiaim.yaw_jitter[1], self.jitter_mode)
	ui.set(ref.antiaim.yaw_jitter[2], self.jitter_offset)

	ui.set(ref.antiaim.body_yaw[1], self.byaw_mode == BYAW_MODES.none and "jitter" or "static")
	ui.set(ref.antiaim.body_yaw[2], self.byaw)

	ui.set(ref.antiaim.yaw_base, self.at_targets == true and "At targets" or "Local view")

	ui.set(ref.antiaim.roll, self.roll)
	cmd.roll = self.roll
end
--@endregion

--@region semirage
local semirage = {}

function semirage:dynamic_fov()
	if
		script.build == SCRIPT_BUILDS.rage
		or not ui.get(menu.semirage.dynamic_fov)
		or not ui.get(menu.semirage.override_switch)
	then
		return
	end

	local MIN_DIST = 1500
	local MAX_DIST = 100
	local DISTANCE_SCALE = 4000

	local fov = ui.get(menu.semirage.min_fov)

	local dist = entity.get_distance(shared.me, shared.target)

	local max_fov = ui.get(menu.semirage.max_fov)
	local min_fov = ui.get(menu.semirage.min_fov)

	if dist >= MIN_DIST then
		fov = min_fov
	elseif dist <= MAX_DIST then
		fov = max_fov
	else
		fov = math.min(max_fov, math.max(min_fov, DISTANCE_SCALE / dist))
	end

	ui.set(ref.ragebot.max_fov, fov)
end

function semirage:on_key()
	if script.build == SCRIPT_BUILDS.rage or not ui.get(menu.semirage.override_switch) then
		ui.set(ref.ragebot.automatic_penetration, true)
		ui.set(ref.ragebot.automatic_fire, true)
		return
	end
	ui.set(ref.ragebot.automatic_penetration, ui.get(menu.semirage.autowall_hk))
	ui.set(ref.ragebot.automatic_fire, ui.get(menu.semirage.autofire_hk))
end
--@endregion

--@region misc
local misc = {}

function misc:quick_fall()
	if not ui.get(menu.misc.quick_fall) then
		ui.set(ref.ragebot.double_tap[1], true)
		return
	end

	local me = entity.get_local_player()
	local velocity = vector(entity.get_prop(me, "m_vecVelocity"))

	if velocity.z < -190 then
		ui.set(ref.ragebot.double_tap[1], false)
	else
		ui.set(ref.ragebot.double_tap[1], true)
	end
end

-- function misc:auto_tp()
-- 	if not ui.get(menu.misc.tp_in_air) then
-- 		return
-- 	end

-- 	local me = entity.get_local_player()
-- 	local me_pos = vector(entity.hitbox_position(me, 3))
-- 	local target_eye = vector(entity.hitbox_position(shared.target, 0))

-- 	local _, damage =
-- 		client.trace_bullet(shared.target, target_eye.x, target_eye.y, target_eye.z, me_pos.x, me_pos.y, me_pos.z, true)

-- 	if damage > 10 then
-- 		client.delay_call(0.2, function()
-- 			ui.set(ref.ragebot.double_tap[1], false)
-- 			self.is_tp = true
-- 		end)
-- 	else
-- 		self.is_tp = false
-- 	end
-- end

-- function misc:tp_indicator()
-- 	if self.is_tp then
-- 		renderer.indicator(
-- 			132,
-- 			196,
-- 			20,
-- 			245,
-- 			("-/+ MODIFYING TELEPORT DISTANCE ON TICK (%i)"):format(client.random_int(0, 64))
-- 		)
-- 	end
-- end

function misc:leg_anim()
	if ui.get(menu.misc.leg_anim) == "Moving legs" then
		local me = ent.get_local_player()
		local m_fFlags = me:get_prop("m_fFlags")
		local is_onground = bit.band(m_fFlags, 1) ~= 0
		if not is_onground then
			local my_animlayer = me:get_anim_overlay(6) -- MOVEMENT_MOVE
			my_animlayer.weight = 1
		end
	end

	if ui.get(menu.misc.leg_anim) == "Static legs" then
		entity.set_prop(entity.get_local_player(), "m_flPoseParameter", 1, 6)
	end
end
--@endregion
local indicators = {
	colors = {
		primary = { 255, 255, 255, 255 },
		secondary = { 255, 255, 255, 255 },
	},
}

function indicators:update()
	self.colors.primary = { ui.get(menu.visuals.primary_picker) }
	self.colors.secondary = { ui.get(menu.visuals.secondary_picker) }
end

indicators:update()

ui.set_callback(menu.visuals.primary_picker, function()
	indicators:update()
end)

ui.set_callback(menu.visuals.secondary_picker, function()
	indicators:update()
end)

function indicators:crosshair_indicator()
	local screen_size = { client.screen_size() }

	local x, y = screen_size[1] / 2, screen_size[2] / 2 + 30
	local bodyyaw = entity.get_prop(entity.get_local_player(), "m_flPoseParameter", 11) * 120 - 60
	local double_tap = ui.get(ref.ragebot.double_tap[1]) and ui.get(ref.ragebot.double_tap[2])
	local baim = ui.get(ref.ragebot.force_body_aim)
	local safepoint = ui.get(ref.ragebot.force_safepoint)
	local freestanding = ui.get(ref.antiaim.freestanding[1]) and ui.get(ref.antiaim.freestanding[2])

	renderer.text(
		x,
		y,
		self.colors.primary[1],
		self.colors.primary[2],
		self.colors.primary[3],
		255,
		"c-",
		nil,
		string.upper(script.name)
	)

	y = y + 10

	renderer.text(x, y, 255, 255, 255, 255, "c-", nil, string.format("%s %%", math.floor(bodyyaw)))

	y = y + 10

	renderer.text(x, y, 255, 255, 255, double_tap and self.colors.primary[4] or 100, "c-", nil, "DT")

	y = y + 6

	renderer.text(
		x - 18,
		y,
		self.colors.secondary[1],
		self.colors.secondary[2],
		self.colors.secondary[3],
		safepoint and self.colors.primary[4] or 100,
		"-",
		nil,
		"SP"
	)

	renderer.text(
		x - 5,
		y,
		self.colors.secondary[1],
		self.colors.secondary[2],
		self.colors.secondary[3],
		baim and self.colors.primary[4] or 100,
		"-",
		nil,
		"BAIM"
	)

	renderer.text(
		x + 16,
		y,
		self.colors.secondary[1],
		self.colors.secondary[2],
		self.colors.secondary[3],
		freestanding and self.colors.primary[4] or 100,
		"-",
		nil,
		"FS"
	)
end

function indicators:keybinds()
	if ui.get(menu.misc.quick_fall) then
		renderer.indicator(132, 196, 20, 245, "QUICK FALL")
	end

	if ui.get(menu.aa.roll_hk) and self.roll > 0 then
		renderer.indicator(132, 196, 20, 245, "ROLL")
	end

	if script.build ~= SCRIPT_BUILDS.rage and ui.get(menu.semirage.override_switch) then
		if ui.get(menu.semirage.autofire_hk) then
			renderer.indicator(255, 255, 255, 245, "AUTO")
		end

		if ui.get(menu.semirage.autowall_hk) then
			renderer.indicator(255, 255, 255, 245, "AW")
		end

		if ui.get(menu.semirage.dynamic_fov) then
			renderer.indicator(132, 196, 20, 245, string.format("FOV: %s", ui.get(ref.ragebot.max_fov)))
		end
	end
end
--@endregion

--@region debug
local function debug_panel()
	if script.build ~= "debug" then
		return
	end

	local x, y = 200, 200
	local y_add = 0

	renderer.text(x, y, 255, 255, 255, 255, "", nil, "Debug panel")
	y_add = y_add + 20

	-- local to_debug = { shared.state, aa.brute.modifier, aa.byaw_mode, aa.yaw_offset, shared.target }
	local to_debug = {
		["state"] = shared.state,
		["target"] = string.format("[%s] %s", shared.target, entity.get_player_name(shared.target)),
		["height_advantage"] = string.format("%s: %s", aa.height_advantage or "", (aa.height_advantage or 0) > 0.15),
		["brute.modifier"] = aa.brute.modifier,
		["fs_damage"] = aa.fs_damage,
		["byaw_mode"] = aa.byaw_mode,
		["byaw_offset"] = aa.byaw,
		["is_manual_aa"] = aa.is_manual_aa,
	}

	for name, val in pairs(to_debug) do
		renderer.text(x, y + y_add, 255, 255, 255, 255, "", nil, string.format("%s: %s", name, tostring(val)))
		y_add = y_add + 13
	end
end
--@endregion

--@region Configs
-- local function export_config(config_item, t)
--     local config = config_item and config_item or ''

--     local has_child = false
--     for key, element in pairs(t and t or menu) do
--         if type(element) == 'table' then
--             export_config(config, element)
--             has_child = true
--         elseif type(element) ~= 'function' then
--             config = config .. key .. ':' .. tostring(ui.get(element)) .. '|'
--         end
--     end

--     if not has_child then
--         print(config)
--     end
-- end

-- local export_btn = ui.new_button(TAB, CONTAINER, 'Export config', export_config)
-- local import_btn = ui.new_button(TAB, CONTAINER, 'Import config')
--@endregion

--@region callbacks
local function setup_cmd(cmd)
	shared:update()
	aa:init()
	aa:handle_on_key()
	aa:legit_on_key(cmd)
	aa:run_adjustments(cmd)
	aa.brute:controller()
	aa:mm_roll()
	aa:override(cmd)

	semirage:dynamic_fov()
	semirage:on_key()

	misc:quick_fall()
	-- misc:auto_tp()
end

local function bullet_impact(e)
	aa.brute:event(e)
end

local function paint()
	debug_panel()
	indicators:crosshair_indicator()
	indicators:keybinds()
end

local function pre_render()
	misc:leg_anim()
end

local function paint_ui()
	if globals.mapname() == nil and entity.get_local_player() == nil then
		aa.is_valve_ds_spoofed = false
		if cvar.sv_maxusrcmdprocessticks:get_int() ~= 16 then
			client.set_cvar("sv_maxusrcmdprocessticks", 16)
		end

		if aa.last_fl_val ~= nil then
			if ui.get(ref.fakelag.limit) ~= aa.last_fl_val then
				ui.set(ref.fakelag.limit, aa.last_fl_val)
				aa.last_fl_val = nil
			end
		end
	end
end

local function pre_config_load()
	aa.last_fl_val = nil
end

local function pre_config_save()
	if aa.last_fl_val ~= nil then
		ui.set(ref.fakelag.limit, aa.last_fl_val)
	end
end

local function handle_callback(toggle)
	local handle = ui.get(toggle) == true and client.set_event_callback or client.unset_event_callback

	handle("setup_command", setup_cmd)
	handle("bullet_impact", bullet_impact)
	handle("paint", paint)
	handle("pre_render", pre_render)
	handle("paint_ui", paint_ui)
	handle("pre_config_load", pre_config_load)
	handle("pre_config_save", pre_config_save)
end

ui.set_callback(menu.enable, function()
	menu:handle_visibility()
	handle_callback(menu.enable)
end)

local visible_callbacks = { menu.tab, menu.aa.state, menu.aa.mode, menu.aa.manual_switch }
for element in ipairs(visible_callbacks) do
	ui.set_callback(visible_callbacks[element], function()
		menu:handle_visibility()
	end)
end

if script.build ~= SCRIPT_BUILDS.rage then
	ui.set_callback(menu.semirage.dynamic_fov, function()
		menu:handle_visibility()
	end)
end

ui.set_callback(menu.tab, function()
	shared.cur_tab = ui.get(menu.tab)

	menu:handle_visibility()
end)

-- ui.set_callback(menu.aa.state, function ()
--     menu:handle_visibility()
-- end)

-- ui.set_callback(menu.aa.mode, function ()
--     menu:handle_visibility()
-- end)

-- ui.set_callback(menu.aa.manual_switch, function ()
--     menu:handle_visibility()
-- end)
--@endregion

client.exec("clear")
client.color_log(136, 152, 252, string.format("%s loaded!", script.name))
client.color_log(136, 152, 252, string.format("Welcome back, %s", script.username))
