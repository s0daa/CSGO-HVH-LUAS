local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = {
	HELMET = bit.lshift(1, 0),
	KEVLAR = bit.lshift(1, 1),
	HELMET_KEVLAR = bit.lshift(1, 2),
	ZOOM = bit.lshift(1, 3),
	BLIND = bit.lshift(1, 4),
	RELOAD = bit.lshift(1, 5),
	BOMB = bit.lshift(1, 6),
	VIP = bit.lshift(1, 7),
	DEFUSE = bit.lshift(1, 8),
	FAKE_DUCK = bit.lshift(1, 9),
	PIN_PULLED = bit.lshift(1, 10),
	LOCAL_HITTABLE = bit.lshift(1, 11),
	LOCAL_OCCLUDED = bit.lshift(1, 12),
	EXPLOITER = bit.lshift(1, 13),
	BETA_1 = bit.lshift(1, 14),
	BETA_2 = bit.lshift(1, 15),
	BETA_3 = bit.lshift(1, 16),
	EXPLOITER_DEFENSIVE = bit.lshift(1, 17)
}

local function var_0_2(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = string.format("%02X", arg_1_0)
	local var_1_1 = string.format("%02X", arg_1_1)
	local var_1_2 = string.format("%02X", arg_1_2)

	return var_1_0 .. var_1_1 .. var_1_2 .. "FF"
end

local function var_0_3(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		if iter_2_1 == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_4(arg_3_0)
	local var_3_0, var_3_1, var_3_2 = entity.get_prop(arg_3_0, "m_vecVelocity")

	if var_3_0 == nil then
		return 0
	end

	return math.sqrt(var_3_0 * var_3_0 + var_3_1 * var_3_1 + var_3_2 * var_3_2)
end

local var_0_5 = var_0_2(ui.get(ui.reference("MISC", "Settings", "Menu color")))
local var_0_6 = "\a" .. var_0_5 .. " [Jumpstop] \aBDBDBDFF"
local var_0_7 = {
	enabled = ui.new_checkbox("RAGE", "Aimbot", var_0_6 .. "Enabled"),
	mode = ui.new_combobox("RAGE", "Aimbot", "\n", "On quick stop", "On hittable", "Both"),
	recovery = ui.new_checkbox("RAGE", "Aimbot", var_0_6 .. "Recovery speed \aFFA95FFF[alpha]"),
	recovery_speed = ui.new_slider("RAGE", "Aimbot", "\n", 0, 250, 230, true, "u"),
	disablers = ui.new_multiselect("RAGE", "Aimbot", var_0_6 .. "Disablers", "Unscoped", "Target above distance"),
	max_unscoped_distance = ui.new_slider("RAGE", "Aimbot", var_0_6 .. "Maximum target distance", 0, 100, 15, true, "ft"),
	max_scoped_distance = ui.new_slider("RAGE", "Aimbot", var_0_6 .. "Maximum target distance (scoped)", 0, 100, 35, true, "ft")
}
local var_0_8 = {
	weapon_type = ui.reference("RAGE", "Weapon type", "Weapon type")
}
local var_0_9 = {
	"G3SG1 / SCAR-20",
	"SSG 08",
	"AWP",
	"Rifle"
}

local function var_0_10()
	local var_4_0 = ui.get(var_0_8.weapon_type)
	local var_4_1 = ui.get(var_0_7.enabled)
	local var_4_2 = ui.get(var_0_7.disablers)

	for iter_4_0, iter_4_1 in pairs(var_0_7) do
		ui.set_visible(iter_4_1, var_4_1)
	end

	ui.set_visible(var_0_7.recovery_speed, var_4_1 and ui.get(var_0_7.recovery))
	ui.set_visible(var_0_7.max_unscoped_distance, var_4_1 and var_0_3(var_4_2, "Target above distance") and (not var_0_3(var_0_9, var_4_0) or not var_0_3(var_4_2, "Unscoped")))
	ui.set_visible(var_0_7.max_scoped_distance, var_4_1 and var_0_3(var_0_9, var_4_0) and var_0_3(var_4_2, "Target above distance"))
	ui.set_visible(var_0_7.enabled, true, true)
end

var_0_10()

for iter_0_0, iter_0_1 in pairs(var_0_7) do
	ui.set_callback(iter_0_1, var_0_10)
end

local function var_0_11(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	local var_5_0 = arg_5_3 - arg_5_0
	local var_5_1 = arg_5_4 - arg_5_1
	local var_5_2 = arg_5_5 - arg_5_2
	local var_5_3 = 1
	local var_5_4 = 100

	if arg_5_6 == "feet" then
		var_5_3, var_5_4 = 2, 30.48
	end

	return math.sqrt(var_5_0^2 + var_5_1^2 + var_5_2^2) * var_5_3 / var_5_4
end

local function var_0_12()
	for iter_6_0, iter_6_1 in ipairs(entity.get_players(true)) do
		local var_6_0 = entity.get_esp_data(iter_6_1)

		if bit.band(var_6_0.flags, var_0_1.LOCAL_HITTABLE) ~= 0 then
			return true
		end
	end

	return false
end

local function var_0_13()
	local var_7_0, var_7_1, var_7_2 = entity.get_origin(entity.get_local_player())
	local var_7_3
	local var_7_4 = math.huge

	for iter_7_0, iter_7_1 in ipairs(entity.get_players(true)) do
		local var_7_5, var_7_6, var_7_7 = entity.get_origin(iter_7_1)
		local var_7_8 = var_0_11(var_7_0, var_7_1, var_7_2, var_7_5, var_7_6, var_7_7, "feet")

		if var_7_8 <= var_7_4 then
			var_7_4 = var_7_8
		end
	end

	return var_7_3, var_7_4
end

local var_0_14 = false
local var_0_15 = false

client.set_event_callback("setup_command", function(arg_8_0)
	local var_8_0 = entity.get_local_player()

	if ui.get(var_0_7.recovery) and var_0_14 and var_0_4(var_8_0) <= ui.get(var_0_7.recovery_speed) then
		arg_8_0.in_jump = 0

		return
	end

	local var_8_1 = entity.get_player_weapon(var_8_0)

	if not var_8_1 then
		var_0_14 = false

		return
	end

	if not ui.get(var_0_7.enabled) then
		var_0_14 = false

		return
	end

	local var_8_2 = ui.get(var_0_7.mode)
	local var_8_3 = (var_8_2 == "On quick stop" or var_8_2 == "Both") and arg_8_0.quick_stop or (var_8_2 == "On hittable" or var_8_2 == "Both") and var_0_12()

	if not arg_8_0.in_jump or not var_8_3 then
		var_0_14 = false

		return
	end

	local var_8_4 = var_0_0[entity.get_prop(var_8_1, "m_iItemDefinitionIndex")]
	local var_8_5 = entity.get_prop(entity.get_local_player(), "m_flNextAttack")
	local var_8_6 = globals.curtime() >= (var_8_4.is_revolver and var_8_5 or math.max(entity.get_prop(var_8_1, "m_flNextPrimaryAttack"), var_8_5))

	if var_8_4.is_melee_weapon or not var_8_6 then
		var_0_14 = false

		return
	end

	local var_8_7 = ui.get(var_0_7.disablers)
	local var_8_8 = entity.get_prop(var_8_0, "m_bIsScoped")

	if var_8_4.zoom_levels > 0 and not var_8_8 and var_0_3(var_8_7, "Unscoped") then
		var_0_14 = false

		return
	end

	if var_0_3(var_8_7, "Target above distance") then
		local var_8_9 = ui.get(var_0_8.weapon_type)
		local var_8_10 = ui.get(var_0_3(var_0_9, var_8_9) and var_8_8 and var_0_7.max_scoped_distance or var_0_7.max_unscoped_distance)
		local var_8_11, var_8_12 = var_0_13()

		if var_8_10 < var_8_12 then
			var_0_14 = false

			return
		end
	end

	arg_8_0.in_jump = 0
	var_0_14 = true
end)
