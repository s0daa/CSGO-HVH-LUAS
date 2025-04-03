local var_0_0 = require("gamesense/csgo_weapons")
local var_0_1 = require("gamesense/images")
local var_0_2 = ui.new_checkbox("VISUALS", "Player ESP", "Show nades")
local var_0_3 = ui.new_color_picker("VISUALS", "Player ESP", "Show nades", 255, 255, 255, 200)
local var_0_4 = ui.new_slider("VISUALS", "Player ESP", "\nNade offset", 0, 20, 0, true, "px", 1, {
	[0] = "Off"
})
local var_0_5 = ui.reference("misc", "Settings", "DPI scale")
local var_0_6 = {
	["175%"] = 1.75,
	["150%"] = 1.5,
	["125%"] = 1.25,
	["100%"] = 1,
	["200%"] = 2
}

local function var_0_7(arg_1_0, arg_1_1)
	local var_1_0 = 10^(arg_1_1 or 0)

	return math.floor(arg_1_0 * var_1_0 + 0.5) / var_1_0
end

local function var_0_8(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if iter_2_1 == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_9(arg_3_0)
	local var_3_0 = 0

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		var_3_0 = var_3_0 + iter_3_1
	end

	return var_3_0 / #arg_3_0
end

local var_0_10 = {}

client.set_event_callback("level_init", function()
	var_0_10 = {}
end)
client.set_event_callback("player_death", function(arg_5_0)
	var_0_10[client.userid_to_entindex(arg_5_0.userid)] = {}
end)
client.set_event_callback("player_spawn", function(arg_6_0)
	var_0_10[client.userid_to_entindex(arg_6_0.userid)] = {}
end)

local var_0_11 = {
	"weapon_molotov",
	"weapon_smokegrenade",
	"weapon_hegrenade",
	"weapon_incgrenade"
}
local var_0_12 = {
	weapon_molotov = "moly",
	weapon_incgrenade = "incin",
	weapon_hegrenade = "nade",
	weapon_smokegrenade = "smoke"
}
local var_0_13 = {
	moly = var_0_1.get_weapon_icon(var_0_11[1]),
	smoke = var_0_1.get_weapon_icon(var_0_11[2]),
	nade = var_0_1.get_weapon_icon(var_0_11[3]),
	incin = var_0_1.get_weapon_icon(var_0_11[4])
}
local var_0_14 = {
	weapon_molotov = 2,
	weapon_incgrenade = 2,
	weapon_hegrenade = 1,
	weapon_smokegrenade = 3
}
local var_0_15 = {
	nade = {
		var_0_13.nade:measure(nil, 12)
	},
	smoke = {
		var_0_13.smoke:measure(nil, 12)
	},
	moly = {
		var_0_13.moly:measure(nil, 12)
	},
	incin = {
		var_0_13.incin:measure(nil, 12)
	}
}

client.set_event_callback("item_remove", function(arg_7_0)
	local var_7_0 = client.userid_to_entindex(arg_7_0.userid)
	local var_7_1 = entity.get_player_name(var_7_0)

	if entity.is_enemy(var_7_0) then
		if var_0_10[var_7_0] ~= nil then
			local var_7_2 = "weapon_" .. arg_7_0.item
			local var_7_3 = {}

			for iter_7_0, iter_7_1 in ipairs(var_0_10[var_7_0]) do
				if iter_7_1 == var_7_2 then
					var_7_2 = "nothin"
				else
					table.insert(var_7_3, iter_7_1)
				end
			end

			var_0_10[var_7_0] = var_7_3
		else
			var_0_10[var_7_0] = {}
		end
	end
end)
client.set_event_callback("item_pickup", function(arg_8_0)
	local var_8_0 = client.userid_to_entindex(arg_8_0.userid)
	local var_8_1 = entity.get_player_name(var_8_0)

	if entity.is_enemy(var_8_0) then
		if var_0_10[var_8_0] == nil then
			var_0_10[var_8_0] = {}
		end

		local var_8_2 = "weapon_" .. arg_8_0.item

		if var_0_8(var_0_11, var_8_2) then
			table.insert(var_0_10[var_8_0], var_8_2)
		end
	end
end)
client.set_event_callback("paint", function()
	local var_9_0 = var_0_6[ui.get(var_0_5)]
	local var_9_1 = false
	local var_9_2 = entity.get_local_player()
	local var_9_3 = entity.get_prop(var_9_2, "m_iObserverMode")

	if not entity.is_alive(var_9_2) and (var_9_3 == 4 or var_9_3 == 5) and entity.is_enemy(entity.get_prop(var_9_2, "m_hObserverTarget")) then
		var_9_1 = true
	end

	local var_9_4 = entity.get_player_resource()

	for iter_9_0 = 1, globals.maxplayers() do
		if entity.get_prop(var_9_4, "m_bConnected", iter_9_0) == 1 and (entity.is_enemy(iter_9_0) and not var_9_1 or not entity.is_enemy(iter_9_0) and var_9_1) then
			if var_0_10[iter_9_0] == nil then
				var_0_10[iter_9_0] = {}
			end

			if entity.is_alive(iter_9_0) then
				if not entity.is_dormant(iter_9_0) then
					local var_9_5 = {}

					for iter_9_1 = 0, 64 do
						local var_9_6 = entity.get_prop(iter_9_0, "m_hMyWeapons", iter_9_1)

						if var_9_6 ~= nil then
							local var_9_7 = var_0_0(var_9_6)

							if var_9_7 ~= nil and var_9_7.type == "grenade" and var_9_7.console_name ~= "weapon_flashbang" and var_9_7.console_name ~= "weapon_decoy" then
								table.insert(var_9_5, var_9_7.console_name)
							end
						end
					end

					var_0_10[iter_9_0] = var_9_5
				end

				if #var_0_10[iter_9_0] > 0 and ui.get(var_0_2) then
					local var_9_8, var_9_9, var_9_10, var_9_11, var_9_12 = entity.get_bounding_box(iter_9_0)

					if var_9_12 == nil then
						var_9_12 = 1
					end

					if var_9_8 ~= nil and var_9_12 ~= 0 then
						local var_9_13 = var_0_10[iter_9_0]

						if #var_9_13 > 1 then
							table.sort(var_9_13, function(arg_10_0, arg_10_1)
								return (var_0_14[arg_10_0] ~= nil and var_0_14[arg_10_0] or 0) < (var_0_14[arg_10_1] ~= nil and var_0_14[arg_10_1] or 0)
							end)
						end

						local var_9_14 = var_9_8 + math.floor((var_9_10 - var_9_8) / 2)
						local var_9_15, var_9_16 = renderer.measure_text("d", "qgftTyiOOPp")
						local var_9_17, var_9_18, var_9_19, var_9_20 = ui.get(var_0_3)

						if entity.is_dormant(iter_9_0) then
							local var_9_21 = var_0_7(var_0_9({
								var_9_17,
								var_9_18,
								var_9_19
							})) * 0.75

							var_9_17 = var_9_21
							var_9_19 = var_9_21
							var_9_18 = var_9_21
						end

						local var_9_22 = var_9_20 * var_9_12
						local var_9_23 = 0

						for iter_9_2, iter_9_3 in pairs(var_9_13) do
							local var_9_24 = var_0_12[iter_9_3]

							var_9_23 = var_9_23 + var_0_15[var_9_24][1] * var_9_0

							if iter_9_2 ~= #var_9_13 then
								var_9_23 = var_9_23 + 4 * var_9_0
							end
						end

						local var_9_25 = var_9_14 - math.floor(var_9_23 / 2)
						local var_9_26 = 0

						for iter_9_4, iter_9_5 in pairs(var_9_13) do
							local var_9_27 = var_0_12[iter_9_5]

							var_0_13[var_9_27]:draw(var_0_7(var_9_25 + var_9_26), var_9_9 - var_9_16 - ui.get(var_0_4) - var_0_15[var_9_27][2] * var_9_0, var_0_15[var_9_27][1] * var_9_0, var_0_15[var_9_27][2] * var_9_0, var_9_17, var_9_18, var_9_19, var_9_22)

							var_9_26 = var_9_26 + var_0_15[var_9_27][1] * var_9_0

							if iter_9_4 ~= #var_9_13 then
								var_9_26 = var_9_26 + 4 * var_9_0
							end
						end
					end
				end
			end
		end
	end
end)
