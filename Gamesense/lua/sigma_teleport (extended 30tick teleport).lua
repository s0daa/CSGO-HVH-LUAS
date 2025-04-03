local var_0_0 = bit.lshift(1, 11)
local var_0_1 = 0.3
local var_0_2 = require("gamesense/csgo_weapons")
local var_0_3 = client.screen_size
local var_0_4 = renderer.text
local var_0_5 = {
	client.screen_size()
}
local var_0_6 = {
	var_0_5[1] / 2,
	var_0_5[2] / 2
}
local var_0_7 = ui.new_hotkey("AA", "Other", "Far Teleport")
local var_0_8 = ui.new_hotkey("AA", "Other", "Far Teleport When Hittable")
local var_0_9, var_0_10, var_0_11 = ui.reference("RAGE", "Aimbot", "Double tap")
local var_0_12, var_0_13 = ui.reference("RAGE", "Other", "Quick peek assist")
local var_0_14
local var_0_15

local function var_0_16()
	var_0_14, var_0_15 = nil
end

var_0_16()

local var_0_17

client.set_event_callback("run_command", function(arg_2_0)
	var_0_17 = arg_2_0.command_number
end)
client.set_event_callback("predict_command", function(arg_3_0)
	if arg_3_0.command_number == var_0_17 then
		var_0_17 = nil

		local var_3_0 = entity.get_prop(entity.get_local_player(), "m_nTickBase")

		if var_0_14 ~= nil then
			var_0_15 = var_3_0 - var_0_14
		end

		var_0_14 = math.max(var_3_0, var_0_14 or 0)
	end
end)
client.set_event_callback("level_init", var_0_16)

local var_0_18 = false
local var_0_19

client.set_event_callback("setup_command", function(arg_4_0)
	if not ui.get(var_0_9) or not ui.get(var_0_10) or ui.get(var_0_11) ~= "Defensive" then
		var_0_18, var_0_19 = false, false

		return
	end

	if not var_0_18 and (arg_4_0.in_forward == 1 or arg_4_0.in_back == 1 or arg_4_0.in_moveleft == 1 or arg_4_0.in_moveright == 1 or arg_4_0.in_jump == 1) then
		var_0_18 = ui.get(var_0_7)

		if not var_0_18 and ui.get(var_0_8) then
			for iter_4_0, iter_4_1 in ipairs(entity.get_players(true)) do
				local var_4_0 = entity.get_esp_data(iter_4_1).flags or 0

				if bit.band(var_4_0, var_0_0) ~= 0 then
					var_0_18 = true

					break
				end
			end
		end
	end

	if var_0_18 then
		arg_4_0.force_defensive = true

		if var_0_15 >= 14 then
			var_0_19 = true
		end

		if var_0_19 and var_0_15 == 0 or var_0_2(entity.get_player_weapon(entity.get_local_player())).type == "grenade" then
			ui.set(var_0_9, false)
			client.delay_call(var_0_1, ui.set, var_0_9, true)

			var_0_19, var_0_18 = false, false
		end

		return
	end
end)
client.set_event_callback("paint", function()
	local var_5_0 = "+/- MAXIMIZING TELEPORT DISTANCE"

	if var_0_19 then
		renderer.indicator(143, 194, 21, 255, var_5_0)
		renderer.text(var_0_5[1] - 1206, 772, 143, 207, 219, 255, "-c", 0, "+/- MAXIMIZING TELEPORT DISTANCE")
	elseif ui.get(var_0_7) or ui.get(var_0_8) then
		if var_0_18 then
			renderer.indicator(255, 0, 50, 255, var_5_0)
		else
			renderer.indicator(255, 255, 255, 255, var_5_0)
		end
	end
end)
client.set_event_callback("setup_command", function(arg_6_0)
	if arg_6_0.weaponselect ~= 0 then
		arg_6_0.force_defensive = 1
	end
end)
