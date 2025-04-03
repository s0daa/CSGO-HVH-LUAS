local var_0_0 = require("gamesense/panorama_events")
local var_0_1 = panorama.open()
local var_0_2 = var_0_1.OverwatchAPI
local var_0_3 = var_0_1.GameStateAPI

;(function()
	local var_1_0 = {}
	local var_1_1 = database.read("csmit195_OWBot") or {}

	var_1_1.TotalOverwatches = var_1_1.TotalOverwatches or 0
	var_1_0.Enable = ui.new_checkbox("MISC", "Miscellaneous", "Overwatch Bot")
	var_1_0.ForceConvictOptions = ui.new_multiselect("MISC", "Miscellaneous", "Verdict", {
		"Aimbot",
		"Wallhacks",
		"Other",
		"Griefing"
	})
	var_1_0.DownloadDelay = ui.new_slider("MISC", "Miscellaneous", "Download delay", 5, 300, 5, true, "m")
	var_1_0.VerdictDelay = ui.new_slider("MISC", "Miscellaneous", "Verdict delay", 5, 300, 35, true, "m")
	var_1_0.OnlyProcess = ui.new_combobox("MISC", "Miscellaneous", "Only process", {
		"Main-menu",
		"In-game",
		"Both"
	})
	var_1_0.DownloadRules = ui.new_combobox("MISC", "Miscellaneous", "Only download", {
		"Always",
		"Round End",
		"Self Death",
		"Both"
	})
	var_1_0.Stats = {}
	var_1_0.Stats.Header = ui.new_label("MISC", "Miscellaneous", "Statistics:")
	var_1_0.Stats.CasesCompleted = ui.new_label("MISC", "Miscellaneous", "Cases Completed: " .. var_1_1.TotalOverwatches)
	var_1_0.Stats.CasesAccurate = ui.new_label("MISC", "Miscellaneous", "Cases Accurate: IN_DEV")
	var_1_0.Stats.TotalXP = ui.new_label("MISC", "Miscellaneous", "Total XP Earned: IN_DEV")

	ui.set(var_1_0.ForceConvictOptions, {
		"Aimbot",
		"Wallhacks",
		"Other"
	})

	local var_1_2
	local var_1_3
	local var_1_4 = 0

	local function var_1_5()
		if var_1_3 then
			return
		end

		if not ui.get(var_1_0.Enable) then
			return
		end

		if var_1_2 then
			return
		end

		local var_2_0 = ui.get(var_1_0.OnlyProcess)
		local var_2_1 = var_0_3.IsConnectedOrConnectingToServer()

		if var_2_0 ~= "Both" and (var_2_0 == "Main-menu" and var_2_1 or var_2_0 == "In-game" and not var_2_1) then
			var_1_3 = true

			return client.delay_call(1, var_1_5)
		end

		var_1_3 = false

		local var_2_2 = var_0_2.GetAssignedCaseDescription()
		local var_2_3 = var_0_2.GetEvidencePreparationPercentage()

		if globals.realtime() - var_1_4 > ui.get(var_1_0.DownloadDelay) * 60 and (var_2_2:sub(1, 4) == "OWC#" or tonumber(var_2_2) ~= nil) and var_2_3 == 0 then
			var_0_2.StartDownloadingCaseEvidence()

			var_1_4 = globals.realtime()

			print("[OVERWATCH BOT] ", "Starting Case Download")
		end

		if tonumber(var_2_2) ~= nil then
			-- block empty
		end

		if tonumber(var_2_2) ~= nil and var_2_3 == 100 then
			print("[OVERWATCH BOT] ", "Case: ", var_2_2, ", Finished Download, Waiting: ", ui.get(var_1_0.VerdictDelay))

			var_1_2 = true

			local function var_2_4()
				local var_3_0 = ui.get(var_1_0.OnlyProcess)
				local var_3_1 = var_0_3.IsConnectedOrConnectingToServer()

				if var_3_0 ~= "Both" and (var_3_0 == "Main-menu" and var_3_1 or var_3_0 == "In-game" and not var_3_1) then
					print("[OVERWATCH BOT] not allowed to process, waiting til conditions are sufficient")

					return client.delay_call(5, var_2_4)
				end

				local var_3_2 = {}

				for iter_3_0, iter_3_1 in ipairs(ui.get(var_1_0.ForceConvictOptions)) do
					var_3_2[iter_3_1] = "convict"
				end

				local var_3_3 = string.format("aimbot:%s;wallhack:%s;speedhack:%s;grief:%s;", var_3_2.Aimbot or "dismiss", var_3_2.Wallhacks or "dismiss", var_3_2.Other or "dismiss", var_3_2.Griefing or "dismiss")

				print("[OVERWATCH BOT] ", "Convicting player for: ", var_3_3)
				var_0_2.SubmitCaseVerdict(var_3_3)
				print("[OVERWATCH BOT] ", "Finished Convicting, waiting for next case")

				var_1_1.TotalOverwatches = var_1_1.TotalOverwatches + 1

				ui.set(var_1_0.Stats.CasesCompleted, "Cases Completed: " .. var_1_1.TotalOverwatches)

				var_1_2 = false
			end

			client.delay_call(ui.get(var_1_0.VerdictDelay) * 60, var_2_4)
		end

		if var_2_2 == "" and var_2_3 == 100 then
			-- block empty
		end
	end

	client.set_event_callback("round_end", function()
		local var_4_0 = ui.get(var_1_0.DownloadRules)

		if var_4_0 == "Round End" or var_4_0 == "Both" then
			var_1_5()
		end
	end)
	client.set_event_callback("player_death", function(arg_5_0)
		local var_5_0 = ui.get(var_1_0.DownloadRules)

		if var_5_0 == "Self Death" or var_5_0 == "Both" then
			local var_5_1 = entity.get_local_player()
			local var_5_2 = client.userid_to_entindex(arg_5_0.attacker)

			if var_5_1 == client.userid_to_entindex(arg_5_0.userid) then
				var_1_5()
			end
		end
	end)

	local var_1_6 = globals.realtime()

	client.set_event_callback("post_render", function()
		if (ui.get(var_1_0.DownloadRules) == "Always" or not var_0_3.IsConnectedOrConnectingToServer()) and globals.realtime() - var_1_6 > 1 then
			var_1_5()

			var_1_6 = globals.realtime()
		end
	end)
	var_0_0.register_event("PanoramaComponent_Overwatch_CaseUpdated", var_1_5)

	function var_1_0.Toggle(arg_7_0)
		local var_7_0 = type(arg_7_0) == "bool" and arg_7_0 or type(arg_7_0) == "number" and ui.get(arg_7_0) or arg_7_0 == nil and ui.get(var_1_0.Enable)

		ui.set_visible(var_1_0.VerdictDelay, var_7_0)
		ui.set_visible(var_1_0.DownloadDelay, var_7_0)
		ui.set_visible(var_1_0.ForceConvictOptions, var_7_0)
		ui.set_visible(var_1_0.OnlyProcess, var_7_0)
		ui.set_visible(var_1_0.DownloadRules, var_7_0)

		for iter_7_0, iter_7_1 in pairs(var_1_0.Stats) do
			ui.set_visible(iter_7_1, var_7_0)
		end

		var_1_1.Active = var_7_0

		if var_7_0 and var_1_5 then
			var_1_5()
		end
	end

	ui.set_callback(var_1_0.Enable, var_1_0.Toggle)
	client.delay_call(1, ui.set, var_1_0.Enable, var_1_1.Active)
	var_1_0.Toggle(var_1_1.Active)
	client.set_event_callback("shutdown", function()
		database.write("csmit195_OWBot", var_1_1)
	end)
end)()
