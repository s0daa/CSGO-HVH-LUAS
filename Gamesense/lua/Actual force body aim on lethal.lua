local var_0_0 = ui.new_checkbox("RAGE", "Other", "Force body aim if lethal")
local var_0_1 = ui.new_multiselect("RAGE", "Other", "Enabled weapons", {
	"Scout",
	"Awp",
	"Auto",
	"R8 revolver",
	"Deagle",
	"Other"
})
local var_0_2 = require("gamesense/csgo_weapons")
local var_0_3 = require("vector")

local function var_0_4(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in ipairs(ui.get(arg_1_0)) do
		if iter_1_1 == arg_1_1 then
			return true
		end
	end

	return false
end

local function var_0_5(arg_2_0)
	if (arg_2_0 == 38 or arg_2_0 == 11) and var_0_4(var_0_1, "Auto") then
		return true
	elseif arg_2_0 == 40 and var_0_4(var_0_1, "Scout") then
		return true
	elseif arg_2_0 == 9 and var_0_4(var_0_1, "Awp") then
		return true
	elseif arg_2_0 == 64 and var_0_4(var_0_1, "R8 revolver") then
		return true
	elseif arg_2_0 == 1 and var_0_4(var_0_1, "Deagle") then
		return true
	elseif var_0_4(var_0_1, "Other") then
		return true
	end

	return false
end

local function var_0_6(arg_3_0)
	local var_3_0 = entity.get_local_player()

	if var_3_0 == nil or not entity.is_alive(var_3_0) then
		return
	end

	local var_3_1 = var_0_3(entity.get_prop(var_3_0, "m_vecAbsOrigin")):dist(var_0_3(entity.get_prop(arg_3_0, "m_vecOrigin")))
	local var_3_2 = entity.get_prop(arg_3_0, "m_iHealth")
	local var_3_3 = entity.get_player_weapon(entity.get_local_player())

	if var_3_3 == nil then
		return
	end

	local var_3_4 = entity.get_prop(var_3_3, "m_iItemDefinitionIndex")

	if var_3_4 == nil then
		return
	end

	local var_3_5 = var_0_2[var_3_4]

	if var_3_5 == nil then
		return
	end

	if not var_0_5(var_3_4) or not ui.get(var_0_0) then
		return
	end

	local var_3_6 = var_3_5.damage * math.pow(var_3_5.range_modifier, var_3_1 * 0.002) * 1.25
	local var_3_7 = entity.get_prop(arg_3_0, "m_ArmorValue")
	local var_3_8 = var_3_6 * (var_3_5.armor_ratio * 0.5)

	if var_3_7 < var_3_6 - var_3_6 * (var_3_5.armor_ratio * 0.5) * 0.5 then
		var_3_8 = var_3_6 - var_3_7 / 0.5
	end

	return var_3_2 <= var_3_8
end

local function var_0_7()
	local var_4_0 = entity.get_players(true)

	for iter_4_0 = 1, #var_4_0 do
		if var_4_0[iter_4_0] == nil then
			return
		end

		local var_4_1 = var_0_6(var_4_0[iter_4_0]) and "Force" or "-"

		plist.set(var_4_0[iter_4_0], "Override prefer body aim", var_4_1)
	end
end

client.set_event_callback("run_command", var_0_7)
client.set_event_callback("paint_ui", function()
	ui.set_visible(var_0_1, ui.get(var_0_0))
end)
client.register_esp_flag("BAIM", 255, 20, 20, function(arg_6_0)
	return var_0_6(arg_6_0)
end)
