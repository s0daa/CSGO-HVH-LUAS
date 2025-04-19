slot0 = require("gamesense/steamworks")
slot1 = require("ffi")
slot3 = slot0.EResult
slot4 = panorama.loadstring([[
	return [(timestamp) => {
		var date = new Date(timestamp * 1000);
		return `${date.getFullYear()}/${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes()}:${date.getSeconds()}`
	}]
]])()[0]
slot5 = {}

for slot10 = 0, slot0.ISteamUserStats.GetNumAchievements() - 1 do
	slot11 = slot2.GetAchievementName(slot10)

	table.insert(slot5, {
		id = slot11,
		name = slot2.GetAchievementDisplayAttribute(slot11, "name"),
		desc = slot2.GetAchievementDisplayAttribute(slot11, "desc"),
		hidden = slot2.GetAchievementDisplayAttribute(slot11, "hidden")
	})
end

slot7 = nil

function slot8()
	for slot3, slot4 in ipairs(uv0) do
		slot5, slot4.achieved, slot4.unlock_time = uv1.GetAchievementAndUnlockTime(slot4.id)

		if slot5 then
			slot4.unlock_time_formatted = uv2(slot7)
		end
	end

	uv3()
end

slot0.set_callback("UserStatsReceived_t", slot8)
slot0.set_callback("UserStatsStored_t", slot8)

for slot13, slot14 in ipairs(slot5) do
	-- Nothing
end

slot12 = ui.new_label("LUA", "B", "No description")
slot13 = ui.new_label("LUA", "B", "No global unlock percentage")
slot15 = ui.new_label("LUA", "B", "Unlocked at")

ui.set_callback(ui.new_checkbox("LUA", "B", "Steam Achievement Manager"), function ()
	uv0()

	if ui.get(uv1) then
		uv2()
		uv3.RequestGlobalAchievementPercentages(function (slot0)
			if slot0.m_eResult == uv0.OK then
				slot1 = {
					[slot7.id] = slot7
				}

				for slot6, slot7 in ipairs(uv1) do
					slot2 = math.max(0, slot7.id:len() + 1)
				end

				slot4, slot5, slot6 = uv3.GetMostAchievedAchievementInfo(uv2.new("char[?]", slot2), slot2)

				while slot4 ~= -1 do
					if slot1[uv2.string(slot3)] ~= nil then
						slot1[slot7].global_percent = slot5
					end

					uv2.fill(slot3, slot2)

					slot4, slot5, slot6 = uv3.GetNextMostAchievedAchievementInfo(slot4, slot3, slot2)
				end

				uv4()
			end
		end)
	end
end)

slot16 = false

ui.set_callback(ui.new_checkbox("LUA", "B", "Achievement unlocked"), function ()
	if uv0 or not ui.get(uv1) then
		return
	end

	if uv3[(ui.get(uv2) or 0) + 1] ~= nil then
		if ui.get(uv4) then
			uv5.SetAchievement(slot1.id)
		else
			uv5.ClearAchievement(slot1.id)
		end

		uv5.StoreStats()

		uv0 = true

		ui.set(uv4, not slot2)

		uv0 = false
	end
end)

slot17 = ui.new_button("LUA", "B", "Unlock all", function ()
	for slot3, slot4 in ipairs(uv0) do
		if not slot4.achieved then
			uv1.SetAchievement(slot4.id)
		end
	end

	uv1.StoreStats()
end)
slot18 = ui.new_button("LUA", "B", "Lock all", function ()
	for slot3, slot4 in ipairs(uv0) do
		if slot4.achieved then
			uv1.ClearAchievement(slot4.id)
		end
	end

	uv1.StoreStats()
end)

function slot7()
	uv0 = true

	if ui.get(uv1) then
		ui.set_visible(uv2, true)
		ui.set_visible(uv3, true)
		ui.set_visible(uv4, true)
		ui.set_visible(uv5, true)
		ui.set_visible(uv6, true)

		if uv7[(ui.get(uv2) or 0) + 1] ~= nil then
			ui.set(uv4, slot2.achieved == true)
			ui.set(uv3, slot2.desc)
			ui.set_visible(uv8, slot2.global_percent ~= nil)

			if slot2.global_percent ~= nil then
				ui.set(uv8, string.format("Unlocked by %.1f%% of players", slot2.global_percent))
			end

			ui.set_visible(uv9, slot2.achieved and slot2.unlock_time_formatted ~= nil)

			if slot2.achieved and slot2.unlock_time_formatted ~= nil then
				ui.set(uv9, "Unlocked at " .. slot2.unlock_time_formatted)
			end
		else
			ui.set_visible(uv8, false)
			ui.set_visible(uv9, false)
		end
	else
		ui.set_visible(uv2, slot0)
		ui.set_visible(uv3, slot0)
		ui.set_visible(uv8, slot0)
		ui.set_visible(uv4, slot0)
		ui.set_visible(uv9, slot0)
		ui.set_visible(uv5, slot0)
		ui.set_visible(uv6, slot0)
	end

	uv0 = false
end

ui.set_callback(ui.new_listbox("LUA", "B", "Achievements", {
	[slot13] = slot14.name
}), slot7)
slot7()
