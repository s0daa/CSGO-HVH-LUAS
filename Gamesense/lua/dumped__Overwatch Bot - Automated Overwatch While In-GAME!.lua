slot0 = require("gamesense/panorama_events")
slot1 = panorama.open()
slot2 = slot1.OverwatchAPI
slot3 = slot1.GameStateAPI

function ()
	slot0 = {
		Enable = ui.new_checkbox("MISC", "Miscellaneous", "Overwatch Bot"),
		ForceConvictOptions = ui.new_multiselect("MISC", "Miscellaneous", "Verdict", {
			"Aimbot",
			"Wallhacks",
			"Other",
			"Griefing"
		}),
		DownloadDelay = ui.new_slider("MISC", "Miscellaneous", "Download delay", 5, 300, 5, true, "m"),
		VerdictDelay = ui.new_slider("MISC", "Miscellaneous", "Verdict delay", 5, 300, 35, true, "m"),
		OnlyProcess = ui.new_combobox("MISC", "Miscellaneous", "Only process", {
			"Main-menu",
			"In-game",
			"Both"
		}),
		DownloadRules = ui.new_combobox("MISC", "Miscellaneous", "Only download", {
			"Always",
			"Round End",
			"Self Death",
			"Both"
		}),
		Stats = {}
	}
	slot1 = database.read("csmit195_OWBot") or {}
	slot1.TotalOverwatches = slot1.TotalOverwatches or 0
	slot0.Stats.Header = ui.new_label("MISC", "Miscellaneous", "Statistics:")
	slot0.Stats.CasesCompleted = ui.new_label("MISC", "Miscellaneous", "Cases Completed: " .. slot1.TotalOverwatches)
	slot0.Stats.CasesAccurate = ui.new_label("MISC", "Miscellaneous", "Cases Accurate: IN_DEV")
	slot0.Stats.TotalXP = ui.new_label("MISC", "Miscellaneous", "Total XP Earned: IN_DEV")

	ui.set(slot0.ForceConvictOptions, {
		"Aimbot",
		"Wallhacks",
		"Other"
	})

	slot2, slot3 = nil
	slot4 = 0

	client.set_event_callback("round_end", function ()
		if ui.get(uv0.DownloadRules) == "Round End" or slot0 == "Both" then
			uv1()
		end
	end)
	client.set_event_callback("player_death", function (slot0)
		if ui.get(uv0.DownloadRules) == "Self Death" or slot1 == "Both" then
			slot3 = client.userid_to_entindex(slot0.attacker)

			if entity.get_local_player() == client.userid_to_entindex(slot0.userid) then
				uv1()
			end
		end
	end)

	slot6 = globals.realtime()

	client.set_event_callback("post_render", function ()
		if (ui.get(uv0.DownloadRules) == "Always" or not uv1.IsConnectedOrConnectingToServer()) and globals.realtime() - uv2 > 1 then
			uv3()

			uv2 = globals.realtime()
		end
	end)
	uv2.register_event("PanoramaComponent_Overwatch_CaseUpdated", function ()
		if uv0 then
			return
		end

		if not ui.get(uv1.Enable) then
			return
		end

		if uv2 then
			return
		end

		slot1 = uv3.IsConnectedOrConnectingToServer()

		if ui.get(uv1.OnlyProcess) ~= "Both" and (slot0 == "Main-menu" and slot1 or slot0 == "In-game" and not slot1) then
			uv0 = true

			return client.delay_call(1, uv4)
		end

		uv0 = false
		slot2 = uv5.GetAssignedCaseDescription()

		if globals.realtime() - uv6 > ui.get(uv1.DownloadDelay) * 60 and (slot2:sub(1, 4) == "OWC#" or tonumber(slot2) ~= nil) and uv5.GetEvidencePreparationPercentage() == 0 then
			uv5.StartDownloadingCaseEvidence()

			uv6 = globals.realtime()

			print("[OVERWATCH BOT] ", "Starting Case Download")
		end

		if tonumber(slot2) ~= nil then
			-- Nothing
		end

		if tonumber(slot2) ~= nil and slot3 == 100 then
			print("[OVERWATCH BOT] ", "Case: ", slot2, ", Finished Download, Waiting: ", ui.get(uv1.VerdictDelay))

			uv2 = true

			client.delay_call(ui.get(uv1.VerdictDelay) * 60, function ()
				slot1 = uv1.IsConnectedOrConnectingToServer()

				if ui.get(uv0.OnlyProcess) ~= "Both" and (slot0 == "Main-menu" and slot1 or slot0 == "In-game" and not slot1) then
					print("[OVERWATCH BOT] not allowed to process, waiting til conditions are sufficient")

					return client.delay_call(5, uv2)
				end

				slot2 = {
					[slot7] = "convict"
				}

				for slot6, slot7 in ipairs(ui.get(uv0.ForceConvictOptions)) do
					-- Nothing
				end

				slot3 = string.format("aimbot:%s;wallhack:%s;speedhack:%s;grief:%s;", slot2.Aimbot or "dismiss", slot2.Wallhacks or "dismiss", slot2.Other or "dismiss", slot2.Griefing or "dismiss")

				print("[OVERWATCH BOT] ", "Convicting player for: ", slot3)
				uv3.SubmitCaseVerdict(slot3)
				print("[OVERWATCH BOT] ", "Finished Convicting, waiting for next case")

				uv4.TotalOverwatches = uv4.TotalOverwatches + 1

				ui.set(uv0.Stats.CasesCompleted, "Cases Completed: " .. uv4.TotalOverwatches)

				uv5 = false
			end)
		end

		if slot2 == "" and slot3 == 100 then
			-- Nothing
		end
	end)

	function slot0.Toggle(slot0)
		slot1 = type(slot0) == "bool" and slot0 or type(slot0) == "number" and ui.get(slot0) or slot0 == nil and ui.get(uv0.Enable)

		ui.set_visible(uv0.VerdictDelay, slot1)
		ui.set_visible(uv0.DownloadDelay, slot1)
		ui.set_visible(uv0.ForceConvictOptions, slot1)
		ui.set_visible(uv0.OnlyProcess, slot1)
		ui.set_visible(uv0.DownloadRules, slot1)

		for slot5, slot6 in pairs(uv0.Stats) do
			ui.set_visible(slot6, slot1)
		end

		uv1.Active = slot1

		if slot1 and uv2 then
			uv2()
		end
	end

	ui.set_callback(slot0.Enable, slot0.Toggle)
	client.delay_call(1, ui.set, slot0.Enable, slot1.Active)
	slot0.Toggle(slot1.Active)
	client.set_event_callback("shutdown", function ()
		database.write("csmit195_OWBot", uv0)
	end)
end()
