local var_0_0 = client.key_state
local var_0_1 = client.userid_to_entindex
local var_0_2 = database.read
local var_0_3 = database.write
local var_0_4 = entity.get_local_player
local var_0_5 = entity.get_player_name
local var_0_6 = entity.get_prop
local var_0_7 = entity.get_steam64
local var_0_8 = renderer.rectangle
local var_0_9 = renderer.text
local var_0_10 = ui.get
local var_0_11 = ui.is_menu_open
local var_0_12 = ui.mouse_position
local var_0_13 = ui.new_hotkey
local var_0_14 = ui.new_checkbox
local var_0_15 = ui.new_combobox
local var_0_16 = pairs
local var_0_17 = ui.set_callback
local var_0_18 = cvar.mp_td_dmgtokick
local var_0_19 = entity.get_player_resource
local var_0_20 = client.set_event_callback
local var_0_21 = client.unset_event_callback
local var_0_22 = math.min
local var_0_23 = table.remove

local function var_0_24(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	return arg_1_2 <= arg_1_0 and arg_1_0 <= arg_1_4 and arg_1_3 <= arg_1_1 and arg_1_1 <= arg_1_5
end

local function var_0_25(arg_2_0)
	local var_2_0 = 0

	for iter_2_0 in var_0_16(arg_2_0) do
		var_2_0 = var_2_0 + 1
	end

	return var_2_0
end

local var_0_26 = var_0_2("teamdmg_pos") or {
	300,
	30
}
local var_0_27 = var_0_26[1]
local var_0_28 = var_0_26[2]
local var_0_29
local var_0_30
local var_0_31

local function var_0_32(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not var_0_11() then
		return var_0_27, var_0_28
	end

	if var_0_0(1) then
		local var_3_0, var_3_1 = var_0_12()

		if not var_0_31 then
			local var_3_2 = arg_3_0 + arg_3_2
			local var_3_3 = arg_3_1 + arg_3_3

			if var_0_24(var_3_0, var_3_1, arg_3_0, arg_3_1, var_3_2, var_3_3) then
				var_0_29, var_0_30, var_0_31 = var_3_0 - arg_3_0, var_3_1 - arg_3_1, true
			end
		else
			var_0_27, var_0_28 = var_3_0 - var_0_29, var_3_1 - var_0_30
		end
	else
		var_0_31 = false
	end

	return var_0_27, var_0_28
end

local var_0_33 = var_0_15("lua", "a", "Show Teammates Damage/Kills", "Off", "Without Colors", "Matchmaking Colors", "Matchmaking Color Names")
local var_0_34 = var_0_13("lua", "a", "hotkey", true)
local var_0_35 = var_0_14("lua", "a", "Remove from list when over amount")
local var_0_36 = var_0_2("teamdmg_pos_last") or {}
local var_0_37, var_0_38, var_0_39 = client.system_time()
local var_0_40 = var_0_36[var_0_37 .. var_0_38] or {}
local var_0_41 = var_0_25(var_0_40)
local var_0_42 = {
	255,
	255,
	255,
	255
}
local var_0_43
local var_0_44 = {
	{
		200,
		200,
		200,
		255,
		"BOT"
	},
	{
		200,
		200,
		200,
		255,
		"Gray"
	},
	{
		255,
		255,
		0,
		255,
		"Yellow"
	},
	{
		110,
		0,
		255,
		255,
		"Purple"
	},
	{
		0,
		200,
		0,
		255,
		"Green"
	},
	{
		0,
		75,
		255,
		255,
		"Blue"
	},
	{
		255,
		145,
		0,
		255,
		"Orange"
	}
}

local function var_0_45(arg_4_0)
	local var_4_0 = var_0_1(arg_4_0.attacker)
	local var_4_1 = var_0_1(arg_4_0.userid)
	local var_4_2 = var_0_4()

	if var_4_0 == var_4_1 then
		return
	end

	local var_4_3 = var_0_19()
	local var_4_4 = var_0_6(var_4_3, "m_iTeam", var_4_2)
	local var_4_5 = var_0_6(var_4_3, "m_iTeam", var_4_0)
	local var_4_6 = var_0_6(var_4_3, "m_iTeam", var_4_1)

	if var_4_5 ~= var_4_4 or var_4_6 ~= var_4_4 then
		return
	end

	local var_4_7 = var_0_7(var_4_0)

	if var_4_7 == 0 then
		return
	end

	if not var_0_40[var_4_7] then
		var_0_40[var_4_7] = {
			0,
			0,
			var_0_5(var_4_0),
			var_0_42,
			var_0_44[var_0_6(var_4_3, "m_iCompTeammateColor", var_4_0) + 3],
			var_4_0
		}
		var_0_41 = var_0_41 + 1
	end

	if not arg_4_0.health then
		var_0_40[var_4_7][1] = var_0_40[var_4_7][1] + 1
	else
		var_0_40[var_4_7][2] = var_0_40[var_4_7][2] + arg_4_0.dmg_health
	end

	var_0_40[var_4_7][4] = var_0_43 == "Without Colors" and var_0_42 or var_0_40[var_4_7][5]
	var_0_40[var_4_7][3] = var_0_43 == "Matchmaking Color Names" and var_0_40[var_4_7][5][5] or var_0_5(var_4_0)
end

local function var_0_46()
	if not var_0_10(var_0_34) then
		return
	end

	local var_5_0, var_5_1 = var_0_32(var_0_27, var_0_28, 200, 20)

	var_0_8(var_5_0, var_5_1, 200, 20, 37, 37, 37, 250)
	var_0_9(var_5_0 + 100, var_5_1 + 10, 255, 255, 255, 255, "cd", 0, "Player List")
	var_0_8(var_5_0, var_5_1 + 20, 200, var_0_41 * 10 + 10, 33, 33, 33, 180)

	local var_5_2 = var_5_1 + 25
	local var_5_3 = var_0_18:get_int()
	local var_5_4 = var_0_10(var_0_35)
	local var_5_5 = 0
	local var_5_6 = var_0_19()
	local var_5_7 = var_0_6(var_5_6, "m_iTeam", var_0_4())

	for iter_5_0, iter_5_1 in var_0_16(var_0_40) do
		local var_5_8 = var_0_22(iter_5_1[2] / var_5_3, 1)
		local var_5_9 = iter_5_1[4]

		var_0_9(var_5_0 + 5, var_5_2 + var_5_5, var_5_9[1], var_5_9[2], var_5_9[3], var_5_9[4], "ld", 42, iter_5_1[3])
		var_0_8(var_5_0 + 50, var_5_2 + var_5_5 - 3 + 7, 100, 6, 13, 13, 13, 230)
		var_0_8(var_5_0 + 51, var_5_2 + var_5_5 - 2 + 7, 98 * var_5_8, 4, 49, 233, 93, 255)
		var_0_9(var_5_0 + 100, var_5_2 + var_5_5 + 7, 255, 255, 255, 255, "c-d", 0, iter_5_1[2] .. "/" .. var_5_3)
		var_0_9(var_5_0 + 195, var_5_2 + var_5_5, 255, 255, 255, 255, "rd", 0, iter_5_1[1] .. " Kills")

		var_5_5 = var_5_5 + 11

		if var_5_4 and (iter_5_1[1] >= 3 or var_5_3 <= iter_5_1[2]) then
			var_0_23(var_0_40, iter_5_0)
		end

		if var_0_6(var_5_6, "m_iTeam", iter_5_1[6]) ~= var_5_7 then
			var_0_23(var_0_40, iter_5_0)
		end
	end
end

local function var_0_47(arg_6_0)
	var_0_40, var_0_41 = {}, 0
end

local function var_0_48()
	var_0_3("teamdmg_pos", {
		var_0_27,
		var_0_28
	})

	local var_7_0, var_7_1 = client.system_time()

	var_0_3("teamdmg_pos_last", {
		[var_7_0 .. var_7_1] = var_0_40
	})
end

local function var_0_49(arg_8_0)
	local var_8_0 = var_0_10(arg_8_0)
	local var_8_1 = var_8_0 ~= "Off" and var_0_20 or var_0_21

	var_0_43 = var_8_0

	var_8_1("player_hurt", var_0_45)
	var_8_1("player_death", var_0_45)
	var_8_1("paint", var_0_46)
	var_8_1("cs_win_panel_match", var_0_47)
	var_8_1("shutdown", var_0_48)
end

var_0_49(var_0_33)
var_0_17(var_0_33, var_0_49)
ui.new_button("lua", "a", "Reset List", var_0_47)
