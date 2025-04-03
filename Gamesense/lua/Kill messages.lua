local var_0_0 = require("gamesense/uix")
local var_0_1 = client.exec
local var_0_2 = client.system_time
local var_0_3 = client.userid_to_entindex
local var_0_4 = entity.get_local_player
local var_0_5 = entity.get_player_name
local var_0_6 = entity.get_prop
local var_0_7 = string.format
local var_0_8 = ui.get
local var_0_9 = ui.new_checkbox
local var_0_10 = ui.new_textbox
local var_0_11 = ui.set_callback
local var_0_12 = ui.set_visible
local var_0_13
local var_0_14
local var_0_15 = {}

local function var_0_16(arg_1_0)
	if var_0_3(arg_1_0.attacker) == var_0_4() then
		local var_1_0 = var_0_8(var_0_14)

		for iter_1_0, iter_1_1 in pairs(var_0_15) do
			if var_1_0:find(iter_1_0) then
				var_1_0 = var_1_0:gsub(iter_1_0, iter_1_1(arg_1_0))
			end
		end

		var_0_1("say ", var_1_0)
	end
end

local function var_0_17(arg_2_0)
	local var_2_0 = var_0_8(arg_2_0)

	var_0_12(var_0_14, var_2_0)
end

local function var_0_18(arg_3_0, arg_3_1)
	var_0_15[arg_3_0] = arg_3_1
end

;(function()
	var_0_18("$victim", function(arg_5_0)
		return var_0_5(var_0_3(arg_5_0.userid))
	end)
	var_0_18("$attacker", function(arg_6_0)
		return var_0_5(var_0_3(arg_6_0.attacker))
	end)
	var_0_18("$weapon", function(arg_7_0)
		return arg_7_0.weapon
	end)
	var_0_18("$location", function(arg_8_0)
		return var_0_6(var_0_3(arg_8_0.userid), "m_szLastPlaceName")
	end)
	var_0_18("$time", function()
		return var_0_7("%d:%02d:%02d", var_0_2())
	end)

	var_0_13 = var_0_0.new_checkbox("LUA", "B", "Kill message")
	var_0_14 = var_0_10("LUA", "B", "Message text")

	var_0_13:on("change", var_0_17)
	var_0_13:on("player_death", var_0_16)
end)()
