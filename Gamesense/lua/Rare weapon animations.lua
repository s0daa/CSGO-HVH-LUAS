local var_0_0 = bit.band
local var_0_1 = entity.get_local_player
local var_0_2 = entity.get_prop
local var_0_3 = entity.is_alive
local var_0_4 = entity.set_prop
local var_0_5 = pairs
local var_0_6 = ui.get
local var_0_7 = ui.new_checkbox
local var_0_8 = ui.new_multiselect
local var_0_9 = ui.set_visible
local var_0_10 = require("gamesense/csgo_weapons")
local var_0_11 = require("table.clear")

local function var_0_12(arg_1_0, arg_1_1)
	local var_1_0 = {}

	for iter_1_0, iter_1_1 in var_0_5(arg_1_0) do
		var_1_0[iter_1_0] = arg_1_1(iter_1_1)
	end

	return var_1_0
end

local function var_0_13(arg_2_0)
	local var_2_0 = {}

	for iter_2_0 = 1, #arg_2_0 do
		var_2_0[arg_2_0[iter_2_0]] = iter_2_0
	end

	return var_2_0
end

local var_0_14 = {
	{
		weapon = var_0_10.weapon_knife_butterfly,
		overrides = {
			0,
			[13] = 15,
			[14] = 15
		}
	},
	{
		weapon = var_0_10.weapon_knife_falchion,
		overrides = {
			[12] = 13
		}
	},
	{
		weapon = var_0_10.weapon_knife_ursus,
		overrides = {
			[0] = 1,
			[14] = 13
		}
	},
	{
		weapon = var_0_10.weapon_knife_stiletto,
		overrides = {
			[13] = 12
		}
	},
	{
		weapon = var_0_10.weapon_knife_widowmaker,
		overrides = {
			[14] = 15
		}
	},
	{
		weapon = var_0_10.weapon_knife_skeleton,
		overrides = {
			[0] = 1,
			[13] = 14
		}
	},
	{
		weapon = var_0_10.weapon_knife_canis,
		overrides = {
			[0] = 1,
			[14] = 13
		}
	},
	{
		weapon = var_0_10.weapon_knife_cord,
		overrides = {
			[0] = 1,
			[14] = 13
		}
	},
	{
		weapon = var_0_10.weapon_knife_outdoor,
		overrides = {
			[14] = 13
		},
		overrides_durations = {
			[1] = 4
		}
	},
	{
		weapon = var_0_10.weapon_deagle,
		overrides = {
			[7] = 8
		}
	},
	{
		weapon = var_0_10.weapon_revolver,
		overrides = {
			[3] = 4
		}
	}
}
local var_0_15 = {}
local var_0_16 = var_0_7("SKINS", "Model options", "Rare weapon animations")
local var_0_17 = var_0_8("SKINS", "Model options", "\nActive rare animations", var_0_12(var_0_14, function(arg_3_0)
	return arg_3_0.name or arg_3_0.weapon.name
end))

var_0_9(var_0_17, false)
ui.set_callback(var_0_16, function()
	var_0_9(var_0_17, var_0_6(var_0_16))
end)
ui.set_callback(var_0_17, function()
	var_0_11(var_0_15)

	local var_5_0 = var_0_13(var_0_6(var_0_17))

	for iter_5_0 = 1, #var_0_14 do
		local var_5_1 = var_0_14[iter_5_0]

		if var_5_0[var_5_1.name or var_5_1.weapon.name] ~= nil then
			local var_5_2 = var_5_1.weapon.idx

			var_0_15[var_5_2] = var_0_15[var_5_2] or {}

			for iter_5_1, iter_5_2 in var_0_5(var_5_1.overrides) do
				var_0_15[var_5_2][iter_5_1] = iter_5_2
			end
		end
	end
end)
client.set_event_callback("net_update_start", function()
	if not var_0_6(var_0_16) then
		return
	end

	local var_6_0 = var_0_1()

	if var_6_0 == nil or not var_0_3(var_6_0) then
		return
	end

	local var_6_1 = var_0_2(var_6_0, "m_hViewModel[0]")

	if var_6_1 == nil then
		return
	end

	local var_6_2 = var_0_2(var_6_1, "m_hWeapon")

	if var_6_2 == nil then
		return
	end

	local var_6_3 = var_0_0(var_0_2(var_6_2, "m_iItemDefinitionIndex") or 0, 65535)
	local var_6_4 = var_0_15[var_6_3]

	if var_6_4 ~= nil then
		local var_6_5 = var_0_2(var_6_1, "m_nSequence")

		if var_6_4[var_6_5] ~= nil then
			var_0_4(var_6_1, "m_nSequence", var_6_4[var_6_5])
		end
	end
end)
