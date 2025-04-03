require("gamesense/panorama_valve_utils")

local var_0_0 = panorama.open()
local var_0_1 = var_0_0.GameTypesAPI.GetActiveSeasionIndexValue()

if var_0_1 ~= nil and var_0_1 > 0 then
	local function var_0_2(arg_1_0, arg_1_1, arg_1_2, ...)
		local var_1_0 = table.concat({
			...
		})

		client.color_log(arg_1_0, arg_1_1, arg_1_2, var_1_0:match("^[^\a]*"), "\x00")

		for iter_1_0 in var_1_0:gmatch("\a[^\a]*") do
			local var_1_1 = tonumber("0x" .. iter_1_0:sub(2, 3))
			local var_1_2 = tonumber("0x" .. iter_1_0:sub(4, 5))
			local var_1_3 = tonumber("0x" .. iter_1_0:sub(6, 7))

			client.color_log(var_1_1, var_1_2, var_1_3, iter_1_0:sub(8, -1), "\x00")
		end

		client.color_log(arg_1_0, arg_1_1, arg_1_2, "\n\x00")
	end

	local var_0_3 = var_0_0.OperationUtil
	local var_0_4 = var_0_0.MissionsAPI
	local var_0_5 = var_0_0.InventoryAPI
	local var_0_6 = var_0_0["$"].Localize
	local var_0_7 = panorama.loadstring("\t\treturn [(text, missionid) => {\n\t\t\tlet panel = $.CreatePanel(\"Panel\", $.GetContextPanel(), \"\")\n\t\t\tMissionsAPI.ApplyQuestDialogVarsToPanelJS(missionid, panel)\n\n\t\t\tlet str = $.Localize(text, panel)\n\t\t\tpanel.DeleteAsync(0.0)\n\n\t\t\treturn str\n\t\t}]\n\t", "CSGOMainMenu")()[0]

	ui.new_button("MISC", "Miscellaneous", "Dump Operation Missions", function()
		var_0_3.ValidateOperationInfo(var_0_1)
		client.log("Operation ", var_0_6("op" .. var_0_1 + 1 .. "_name"), " Missions:")

		local var_2_0 = var_0_4.GetSeasonalOperationMissionCardsCount(var_0_1)

		for iter_2_0 = 1, var_2_0 do
			local var_2_1 = json.parse(tostring(var_0_4.GetSeasonalOperationMissionCardDetails(var_0_1, iter_2_0 - 1)))
			local var_2_2 = iter_2_0 - 1 < var_0_5.GetMissionBacklog()

			var_0_2(230, 230, 230, "\aB6E717Week ", iter_2_0, ": ", var_0_6(var_2_1.name), " \aB6B6B6(", var_2_1.operational_points, " points possible)")

			if #var_2_1.quests == 0 then
				client.color_log(201, 201, 201, "  Missions not known yet")
			else
				for iter_2_1 = 1, #var_2_1.quests do
					local var_2_3 = var_2_1.quests[iter_2_1]
					local var_2_4 = var_0_5.GetQuestItemIDFromQuestID(var_2_3)
					local var_2_5 = var_0_7(var_0_4.GetQuestDefinitionField(var_2_3, "loc_description"), var_2_3):gsub("<b>", ""):gsub("</b>", ""):gsub("%.$", "")
					local var_2_6 = var_0_4.GetQuestPoints(var_2_3, "count")
					local var_2_7 = var_0_4.GetQuestPoints(var_2_3, "goal")
					local var_2_8 = var_0_4.GetQuestPoints(var_2_3, "remaining")
					local var_2_9 = var_0_4.GetQuestDefinitionField(var_2_3, "operational_points")
					local var_2_10 = var_2_7 > 1 and "required: " .. var_2_7 .. ", " or ""

					if var_2_7 > 1 and var_2_8 > 0 and var_2_8 ~= var_2_7 then
						var_2_10 = var_2_10 .. "progress: " .. var_2_7 - var_2_8 .. ", "
					end

					var_0_2(160, 160, 160, "  \aDEDEDE", var_0_5.GetItemName(var_2_4), "\aC8C8C8: ", var_2_5, " \aADADAD(", var_2_10, "awards ", var_2_9 * var_2_6, " points) ", var_2_2 and (var_2_8 == 0 and "\a9BC20C√" or "\aFF2929X") or "")
				end
			end
		end

		client.color_log(210, 210, 210, " ")
	end)
end
