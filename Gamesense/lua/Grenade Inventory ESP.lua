local var_0_0 = client.set_event_callback
local var_0_1 = entity.get_bounding_box
local var_0_2 = entity.get_players
local var_0_3 = entity.get_prop
local var_0_4 = table.insert
local var_0_5 = ui.get
local var_0_6 = ui.new_checkbox
local var_0_7 = ui.new_color_picker
local var_0_8 = unpack
local var_0_9 = entity.get_origin
local var_0_10 = entity.get_local_player
local var_0_11 = ui.new_slider
local var_0_12 = math.floor
local var_0_13 = require("gamesense/images")
local var_0_14 = require("gamesense/csgo_weapons")
local var_0_15 = var_0_6("LUA", "A", "Grenade Inventory")
local var_0_16 = var_0_7("LUA", "A", "Grenade Inventory color", 255, 255, 255, 255)
local var_0_17 = var_0_11("LUA", "A", "Grenade Icon Scale", 6, 10, 8, true, "x", 0.1)

local function var_0_18(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 0, 64 do
		local var_1_1 = var_0_3(arg_1_0, "m_hMyWeapons", iter_1_0)

		if var_1_1 ~= nil then
			local var_1_2 = var_0_14(var_1_1)

			if var_1_2 ~= nil and var_1_2.type == "grenade" then
				var_0_4(var_1_0, var_1_2.idx)
			end
		end
	end

	return var_1_0
end

var_0_0("paint", function()
	if not var_0_5(var_0_15) then
		return
	end

	local var_2_0, var_2_1, var_2_2, var_2_3 = var_0_5(var_0_16)
	local var_2_4 = var_0_2(true)

	for iter_2_0, iter_2_1 in ipairs(var_2_4) do
		local var_2_5 = var_0_18(iter_2_1)

		if #var_2_5 > 0 then
			local var_2_6, var_2_7, var_2_8, var_2_9, var_2_10 = var_0_1(iter_2_1)

			if var_2_9 ~= nil and var_2_10 > 0 then
				local var_2_11 = 0

				for iter_2_2, iter_2_3 in ipairs(var_2_5) do
					local var_2_12 = var_0_13.get_weapon_icon(iter_2_3)
					local var_2_13, var_2_14 = var_2_12:measure()
					local var_2_15 = var_0_12(var_2_13 * var_0_5(var_0_17) / 10)
					local var_2_16 = var_0_12(var_2_14 * var_0_5(var_0_17) / 10)
					local var_2_17 = (24 - var_2_15) / 2

					var_2_12:draw(var_2_8 - 3 + var_2_11 + var_2_17, var_2_9 - var_2_16 - 3, var_2_15 + 5, var_2_16 + 5, 0, 0, 0, 225)
					var_2_12:draw(var_2_8 + var_2_11 + var_2_17, var_2_9 - var_2_16, var_2_15, var_2_16, var_2_0, var_2_1, var_2_2, var_2_3)

					var_2_11 = var_2_11 + 24
				end
			end
		end
	end
end)
