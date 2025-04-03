local var_0_0 = require("gamesense/chat")
local var_0_1 = require("gamesense/localize")
local var_0_2 = ui.new_checkbox("MISC", "Miscellaneous", "Reveal enemy teamchat")
local var_0_3 = panorama.open().GameStateAPI
local var_0_4 = {}

local function var_0_5(arg_1_0)
	local var_1_0 = client.userid_to_entindex(arg_1_0.userid)

	if not entity.is_enemy(var_1_0) then
		return
	end

	if var_0_3.IsSelectedPlayerMuted(var_0_3.GetPlayerXuidStringFromEntIndex(var_1_0)) then
		return
	end

	if cvar.cl_mute_enemy_team:get_int() == 1 then
		return
	end

	if cvar.cl_mute_all_but_friends_and_party:get_int() == 1 then
		return
	end

	client.delay_call(0.2, function()
		if var_0_4[var_1_0] ~= nil and math.abs(globals.realtime() - var_0_4[var_1_0]) < 0.4 then
			return
		end

		local var_2_0 = entity.get_prop(entity.get_player_resource(), "m_iTeam", var_1_0) == 2 and "T" or "CT"
		local var_2_1 = entity.get_prop(var_1_0, "m_szLastPlaceName")
		local var_2_2 = entity.get_player_name(var_1_0)
		local var_2_3 = ("Cstrike_Chat_%s_%s"):format(var_2_0, entity.is_alive(var_1_0) and "Loc" or "Dead")
		local var_2_4 = var_0_1(var_2_3, {
			s1 = var_2_2,
			s2 = arg_1_0.text,
			s3 = var_0_1(var_2_1 ~= "" and var_2_1 or "UI_Unknown")
		})

		var_0_0.print_player(var_1_0, var_2_4)
	end)
end

local function var_0_6(arg_3_0)
	if not entity.is_enemy(arg_3_0.entity) then
		return
	end

	var_0_4[arg_3_0.entity] = globals.realtime()
end

ui.set_callback(var_0_2, function()
	local var_4_0 = ui.get(var_0_2) and client.set_event_callback or client.unset_event_callback

	var_4_0("player_say", var_0_5)
	var_4_0("player_chat", var_0_6)
end)
