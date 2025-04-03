local var_0_0 = require("gamesense/steamworks")
local var_0_1 = require("ffi")
local var_0_2 = var_0_0.ISteamUserStats
local var_0_3 = var_0_0.EResult
local var_0_4 = panorama.loadstring("\treturn [(timestamp) => {\n\t\tvar date = new Date(timestamp * 1000);\n\t\treturn `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`\n\t}]\n")()[0]
local var_0_5 = {}
local var_0_6 = var_0_2.GetNumAchievements()

for iter_0_0 = 0, var_0_6 - 1 do
	local var_0_7 = var_0_2.GetAchievementName(iter_0_0)

	table.insert(var_0_5, {
		id = var_0_7,
		name = var_0_2.GetAchievementDisplayAttribute(var_0_7, "name"),
		desc = var_0_2.GetAchievementDisplayAttribute(var_0_7, "desc"),
		hidden = var_0_2.GetAchievementDisplayAttribute(var_0_7, "hidden")
	})
end

local var_0_8

local function var_0_9()
	for iter_1_0, iter_1_1 in ipairs(var_0_5) do
		local var_1_0, var_1_1, var_1_2 = var_0_2.GetAchievementAndUnlockTime(iter_1_1.id)

		if var_1_0 then
			iter_1_1.achieved = var_1_1
			iter_1_1.unlock_time = var_1_2
			iter_1_1.unlock_time_formatted = var_0_4(var_1_2)
		end
	end

	var_0_8()
end

var_0_0.set_callback("UserStatsReceived_t", var_0_9)
var_0_0.set_callback("UserStatsStored_t", var_0_9)

local var_0_10 = {}

for iter_0_1, iter_0_2 in ipairs(var_0_5) do
	var_0_10[iter_0_1] = iter_0_2.name
end

local var_0_11 = ui.new_checkbox("LUA", "B", "Steam Achievement Manager")
local var_0_12 = ui.new_listbox("LUA", "B", "Achievements", var_0_10)
local var_0_13 = ui.new_label("LUA", "B", "No description")
local var_0_14 = ui.new_label("LUA", "B", "No global unlock percentage")
local var_0_15 = ui.new_checkbox("LUA", "B", "Achievement unlocked")
local var_0_16 = ui.new_label("LUA", "B", "Unlocked at")

ui.set_callback(var_0_11, function()
	var_0_8()

	if ui.get(var_0_11) then
		var_0_9()
		var_0_2.RequestGlobalAchievementPercentages(function(arg_3_0)
			if arg_3_0.m_eResult == var_0_3.OK then
				local var_3_0 = {}
				local var_3_1 = 0

				for iter_3_0, iter_3_1 in ipairs(var_0_5) do
					var_3_0[iter_3_1.id] = iter_3_1
					var_3_1 = math.max(var_3_1, iter_3_1.id:len() + 1)
				end

				local var_3_2 = var_0_1.new("char[?]", var_3_1)
				local var_3_3, var_3_4, var_3_5 = var_0_2.GetMostAchievedAchievementInfo(var_3_2, var_3_1)

				while var_3_3 ~= -1 do
					local var_3_6 = var_0_1.string(var_3_2)

					if var_3_0[var_3_6] ~= nil then
						var_3_0[var_3_6].global_percent = var_3_4
					end

					var_0_1.fill(var_3_2, var_3_1)

					local var_3_7

					var_3_3, var_3_4, var_3_7 = var_0_2.GetNextMostAchievedAchievementInfo(var_3_3, var_3_2, var_3_1)
				end

				var_0_8()
			end
		end)
	end
end)

local var_0_17 = false

ui.set_callback(var_0_15, function()
	if var_0_17 or not ui.get(var_0_11) then
		return
	end

	local var_4_0 = (ui.get(var_0_12) or 0) + 1
	local var_4_1 = var_0_5[var_4_0]

	if var_4_1 ~= nil then
		local var_4_2 = ui.get(var_0_15)

		if var_4_2 then
			var_0_2.SetAchievement(var_4_1.id)
		else
			var_0_2.ClearAchievement(var_4_1.id)
		end

		var_0_2.StoreStats()

		var_0_17 = true

		ui.set(var_0_15, not var_4_2)

		var_0_17 = false
	end
end)

local var_0_18 = ui.new_button("LUA", "B", "Unlock all", function()
	for iter_5_0, iter_5_1 in ipairs(var_0_5) do
		if not iter_5_1.achieved then
			var_0_2.SetAchievement(iter_5_1.id)
		end
	end

	var_0_2.StoreStats()
end)
local var_0_19 = ui.new_button("LUA", "B", "Lock all", function()
	for iter_6_0, iter_6_1 in ipairs(var_0_5) do
		if iter_6_1.achieved then
			var_0_2.ClearAchievement(iter_6_1.id)
		end
	end

	var_0_2.StoreStats()
end)

function var_0_8()
	var_0_17 = true

	local var_7_0 = ui.get(var_0_11)

	if var_7_0 then
		ui.set_visible(var_0_12, true)
		ui.set_visible(var_0_13, true)
		ui.set_visible(var_0_15, true)
		ui.set_visible(var_0_18, true)
		ui.set_visible(var_0_19, true)

		local var_7_1 = (ui.get(var_0_12) or 0) + 1
		local var_7_2 = var_0_5[var_7_1]

		if var_7_2 ~= nil then
			ui.set(var_0_15, var_7_2.achieved == true)
			ui.set(var_0_13, var_7_2.desc)
			ui.set_visible(var_0_14, var_7_2.global_percent ~= nil)

			if var_7_2.global_percent ~= nil then
				ui.set(var_0_14, string.format("Unlocked by %.1f%% of players", var_7_2.global_percent))
			end

			ui.set_visible(var_0_16, var_7_2.achieved and var_7_2.unlock_time_formatted ~= nil)

			if var_7_2.achieved and var_7_2.unlock_time_formatted ~= nil then
				ui.set(var_0_16, "Unlocked at " .. var_7_2.unlock_time_formatted)
			end
		else
			ui.set_visible(var_0_14, false)
			ui.set_visible(var_0_16, false)
		end
	else
		ui.set_visible(var_0_12, var_7_0)
		ui.set_visible(var_0_13, var_7_0)
		ui.set_visible(var_0_14, var_7_0)
		ui.set_visible(var_0_15, var_7_0)
		ui.set_visible(var_0_16, var_7_0)
		ui.set_visible(var_0_18, var_7_0)
		ui.set_visible(var_0_19, var_7_0)
	end

	var_0_17 = false
end

ui.set_callback(var_0_12, var_0_8)
var_0_8()
