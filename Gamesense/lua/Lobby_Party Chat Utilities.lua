local var_0_0 = panorama.open()
local var_0_1 = var_0_0.MyPersonaAPI
local var_0_2 = var_0_0.LobbyAPI
local var_0_3 = var_0_0.PartyListAPI
local var_0_4 = var_0_0.FriendsListAPI
local var_0_5 = var_0_0.GameStateAPI
local var_0_6 = {
	Get = ui.get,
	Set = ui.set,
	Delay = client.delay_call,
	RandInt = client.random_int,
	RegisterEvent = client.set_event_callback,
	SetVisible = ui.set_visible,
	SetCallback = ui.set_callback,
	Button = ui.new_button,
	Slider = ui.new_slider,
	Combobox = ui.new_combobox,
	Textbox = ui.new_textbox,
	Checkbox = ui.new_checkbox,
	ListBox = ui.new_listbox,
	Label = ui.new_label
}

if not var_0_2.IsSessionActive() then
	var_0_2.CreateSession()
	var_0_3.SessionCommand("MakeOnline", "")
end

panorama.loadstring("\tvar waitForSearchingEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', function() {});\n")()

local var_0_7 = panorama.loadstring("\treturn {\n\t\tstart: function(callback) {\n\t\t\twaitForSearchingEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', callback);\n\t\t},\n\t\tstop: function() {\n\t\t\t$.UnregisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', waitForSearchingEventHandler);\n\t\t}\n\t}\n")()

var_0_7.start(panorama.loadstring("return function() {}")())
var_0_7.stop()

var_0_6.Config = {
	Side = "B",
	Panel = "LUA"
}
var_0_6.Chat = {
	ErrorPrefix = "#SFUI_QMM_ERROR_",
	DefaultChatMsg = "i'm jackin off",
	Errors = {
		"1_FailPingServer",
		"1_FailReadyUp",
		"1_FailReadyUp_Title",
		"1_FailVerifyClan",
		"1_FailVerifyClan_Title",
		"1_InsufficientLevel",
		"1_InsufficientLevel02",
		"1_InsufficientLevel03",
		"1_InsufficientLevel04",
		"1_InsufficientLevel05",
		"1_NotLoggedIn",
		"1_NotVacVerified",
		"1_OngoingMatch",
		"1_PenaltySeconds",
		"1_PenaltySecondsGreen",
		"1_VacBanned",
		"1_VacBanned_Title",
		"ClientBetaVersionMismatch",
		"ClientUpdateRequired",
		"FailedToPingServers",
		"FailedToReadyUp",
		"FailedToSetupSearchData",
		"FailedToVerifyClan",
		"InvalidGameMode",
		"NoOngoingMatch",
		"NotLoggedIn",
		"NotVacVerified",
		"OperationPassInvalid",
		"OperationQuestIdInactive",
		"PartyRequired1",
		"PartyRequired2",
		"PartyRequired3",
		"PartyRequired4",
		"PartyRequired5",
		"PartyTooLarge",
		"SkillGroupLargeDelta",
		"SkillGroupMissing",
		"TournamentMatchInvalidEvent",
		"TournamentMatchNoEvent",
		"TournamentMatchRequired",
		"TournamentMatchSetupNoTeam",
		"TournamentMatchSetupSameTeam",
		"TournamentMatchSetupYourTeam",
		"TournamentTeamAccounts",
		"TournamentTeamSize",
		"UnavailMapSelect",
		"VacBanned",
		"X_AccountWarningNonPrime",
		"X_AccountWarningTrustMajor",
		"X_AccountWarningTrustMajor_Summary",
		"X_AccountWarningTrustMinor",
		"X_FailPingServer",
		"X_FailReadyUp",
		"X_FailVerifyClan",
		"X_InsecureBlocked",
		"X_InsufficientLevel",
		"X_InsufficientLevel02",
		"X_InsufficientLevel03",
		"X_InsufficientLevel04",
		"X_InsufficientLevel05",
		"X_NotLoggedIn",
		"X_NotVacVerified",
		"X_OngoingMatch",
		"X_PenaltySeconds",
		"X_PenaltySecondsGreen",
		"X_PerfectWorldDenied",
		"X_PerfectWorldRequired",
		"X_VacBanned"
	},
	QueueErrors = {
		"X_VacBanned",
		"X_PenaltySeconds",
		"X_InsecureBlocked",
		"SkillGroupLargeDelta"
	},
	MessageTypes = {
		"Invite",
		"Error",
		"Chat",
		"Start/Stop Queue",
		"Popup Window",
		"Ear Rape [1]",
		"Ear Rape [2]",
		"Mass Popup"
	},
	Colours = {
		"Red",
		"Green",
		"Yellow"
	}
}
var_0_6.Data = {
	Targets = {
		[0] = "-",
		"-",
		"-",
		"-",
		"-",
		"-"
	},
	BadMessages = {
		"Ear Rape [1]",
		"Ear Rape [2]",
		"Mass Popup"
	}
}
var_0_6.Funcs = {
	["table.HasValue"] = function(arg_1_0, arg_1_1)
		for iter_1_0, iter_1_1 in ipairs(var_0_6.Data.BadMessages) do
			if iter_1_1 == arg_1_1 then
				return true
			end
		end

		return false
	end,
	arrToStr = function()
		local var_2_0 = "["

		for iter_2_0, iter_2_1 in pairs(var_0_6.Data.Targets) do
			var_2_0 = string.format("%s'%s',", var_2_0, iter_2_1)
		end

		return string.format("%s];", var_2_0)
	end,
	GetRandomErrorMessage = function()
		return var_0_6.Chat.Errors[var_0_6.RandInt(1, #var_0_6.Chat.Errors)]
	end,
	BuildFuncs = function()
		local var_4_0 = var_0_6.Get(var_0_6.UI.TrustMsgOnSearch.Element)
		local var_4_1 = var_0_6.Chat.ErrorPrefix
		local var_4_2 = var_0_6.Funcs.arrToStr()
		local var_4_3 = var_0_6.Get(var_0_6.UI.StopQueue.Element)
		local var_4_4 = var_0_6.Get(var_0_6.UI.StopQueue.Hidden.Error.Element)
		local var_4_5 = var_0_6.Get(var_0_6.UI.StopQueue.Hidden.Silent.Element)
		local var_4_6 = var_0_6.Get(var_0_6.UI.Target.Element)

		var_0_7.stop()
		var_0_7.start(panorama.loadstring(string.format("\t\t\treturn function() {\n\t\t\t\tif (LobbyAPI.GetMatchmakingStatusString() == '#SFUI_QMM_State_find_searching') {\n\t\t\t\t\tif (%s) {\n\t\t\t\t\t\tlet trustFactorData = %s\n\t\t\t\t\t\tlet sendTrustMsg = false;\n\n\t\t\t\t\t\tfor (let i = 0; i < trustFactorData.length; i++) {\n\t\t\t\t\t\t\tlet trustOption = trustFactorData[i];\n\t\t\t\n\t\t\t\t\t\t\tif (trustOption != '-') {\n\t\t\t\t\t\t\t\tlet userXUID = PartyListAPI.GetXuidByIndex(i);\n\n\t\t\t\t\t\t\t\tif (trustOption === 'Red' || trustOption === 'Yellow') {sendTrustMsg = true;}\n\t\t\t\t\n\t\t\t\t\t\t\t\tlet msgType = (trustOption === 'Red') ? 'ChatReportError' : 'ChatReportYellow';\n\t\t\t\t\t\t\t\tlet msgCol = (trustOption === 'Red') ? \"error\" : \"yellow\";\n\t\t\t\t\t\t\t\tlet trustMessage = (trustOption === 'Red') ? 'X_AccountWarningTrustMajor' : 'X_AccountWarningTrustMinor';\n\t\t\t\t\n\t\t\t\t\t\t\t\tPartyListAPI.SessionCommand(`Game::${msgType}`, `run all xuid ${userXUID} ${msgCol} %s${trustMessage}`);\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t}\n\t\t\t\t\n\t\t\t\t\t\tif (sendTrustMsg) {\n\t\t\t\t\t\t\tPartyListAPI.SessionCommand('Game::ChatReportError', `run all xuid ${MyPersonaAPI.GetXuid()} error %sX_AccountWarningTrustMajor_Summary `);\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\n\t\t\t\t\tif (%s) {\n\t\t\t\t\t\tlet target = (LobbyAPI.BIsHost()) ? PartyListAPI.GetXuidByIndex(%s) : MyPersonaAPI.GetXuid();\n\t\n\t\t\t\t\t\tif (!%s) {\n\t\t\t\t\t\t\tPartyListAPI.SessionCommand('Game::ChatReportError', `run all xuid ${target} error %s%s`);\n\t\t\t\t\t\t}\n\t\n\t\t\t\t\t\tLobbyAPI.StopMatchmaking();\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t", tostring(var_4_0), var_4_2, var_4_1, var_4_1, tostring(var_4_3), var_4_6 - 1, tostring(var_4_5), var_4_1, var_4_4))())
	end,
	ClearPopups = function()
		local var_5_0 = "CSGOMainMenu"

		if var_0_5.IsLocalPlayerPlayingMatch() then
			var_5_0 = "ContextMenuManager"
		end

		panorama.loadstring("UiToolkitAPI.CloseAllVisiblePopups()", var_5_0)()
	end,
	ExecuteMessage = function()
		local var_6_0 = var_0_6.UI.MessageType
		local var_6_1 = var_0_6.Get(var_6_0.Element)
		local var_6_2 = "Game::"
		local var_6_3 = ""
		local var_6_4 = ""
		local var_6_5 = var_0_2.BIsHost() and var_0_3.GetXuidByIndex(var_0_6.Get(var_0_6.UI.Target.Element) - 1) or var_0_1.GetXuid()

		if var_6_1 == "Chat" then
			var_6_2 = string.format("%sChat", var_6_2)
			var_6_3 = "chat"
			var_6_4 = var_0_6.Get(var_6_0.Hidden.Text):gsub(" ", " ")
		elseif var_6_1 == "Error" then
			var_6_3 = var_0_6.Get(var_6_0.Hidden.Colour)

			if var_6_3 == "Red" then
				var_6_2 = string.format("%sChatReportError", var_6_2)
				var_6_3 = "error"
			else
				var_6_2 = string.format("%sChatReport%s", var_6_2, var_6_3)
				var_6_3 = var_6_3:lower()
			end

			var_6_4 = string.format("%s%s", var_6_4, var_0_6.Chat.ErrorPrefix)

			if var_0_6.Get(var_6_0.Hidden.RandErr.Element) then
				var_6_4 = string.format("%s%s", var_6_4, var_0_6.Funcs.GetRandomErrorMessage())
			else
				var_6_4 = string.format("%s%s", var_6_4, var_0_6.Chat.Errors[var_0_6.Get(var_6_0.Hidden.ErrorList) + 1])
			end
		elseif var_6_1 == "Invite" then
			var_6_2 = string.format("%sChatInviteMessage", var_6_2)
			var_6_5 = var_0_1.GetXuid()
			var_6_3 = "friend"
			var_6_4 = var_0_4.GetXuidByIndex(var_0_6.RandInt(1, var_0_4.GetCount() - 1))
		elseif var_6_1 == "Start/Stop Queue" then
			var_0_2.StartMatchmaking("", "", "", "")
			var_0_2.StopMatchmaking()

			return
		elseif var_6_1 == "Popup Window" then
			var_6_2 = string.format("%sHostEndGamePlayAgain", var_6_2)

			var_0_6.Delay(0.5, function()
				var_0_6.Funcs.ClearPopups()
			end)
		elseif var_6_1 == "Ear Rape [1]" then
			for iter_6_0 = 1, var_0_6.Get(var_0_6.UI.LoopMessages.Hidden.Amt) do
				var_0_2.StartMatchmaking("", "", "", "")
				var_0_2.StopMatchmaking()
			end

			return
		elseif var_6_1 == "Ear Rape [2]" then
			for iter_6_1 = 1, var_0_6.Get(var_0_6.UI.LoopMessages.Hidden.Amt) do
				var_0_3.SessionCommand("Game::Chat", string.format("run all xuid %s name %s chat ", var_0_1.GetXuid(), var_0_1.GetName()))
			end

			return
		else
			for iter_6_2 = 1, var_0_6.Get(var_0_6.UI.LoopMessages.Hidden.Amt) do
				var_0_3.SessionCommand("Game::HostEndGamePlayAgain", string.format("run all xuid %s", var_0_1.GetXuid()))
			end

			var_0_6.Delay(0.5, function()
				var_0_6.Funcs.ClearPopups()
			end)

			return
		end

		var_0_3.SessionCommand(var_6_2, string.format("run all xuid %s %s %s", var_6_5, #var_6_3 > 1 and " " .. var_6_3 or "", #var_6_4 > 1 and " " .. var_6_4 or ""))
	end,
	HandleMessage = function()
		local var_9_0 = var_0_6.UI.LoopMessages.Hidden
		local var_9_1 = var_0_6.Get(var_0_6.UI.MessageType.Element)

		if var_0_6.Get(var_0_6.UI.LoopMessages.Element) and not var_0_6.Funcs["table.HasValue"](var_0_6.Data.BadMessages, var_9_1) then
			for iter_9_0 = 1, var_0_6.Get(var_9_0.Amt) do
				if not var_0_6.Get(var_0_6.UI.LoopMessages.Element) then
					break
				end

				var_0_6.Funcs.ExecuteMessage()
			end

			var_0_6.Delay(var_0_6.Get(var_9_0.Delay) / 1000, var_0_6.Funcs.HandleMessage)
		else
			var_0_6.Funcs.ExecuteMessage()
		end
	end
}
var_0_6.UI = {
	lblStart = {
		Element = var_0_6.Label(var_0_6.Config.Panel, var_0_6.Config.Side, "---------------[Start Lobby Utils]--------------"),
		Callback = function(arg_10_0)
			return
		end
	},
	Target = {
		Element = var_0_6.Slider(var_0_6.Config.Panel, var_0_6.Config.Side, "Target Player", 1, 5, 0),
		Callback = function(arg_11_0)
			var_0_6.Set(var_0_6.UI.TrustMsgOnSearch.Hidden.Message.Element, var_0_6.Data.Targets[var_0_6.Get(arg_11_0) - 1])
			var_0_6.Funcs.BuildFuncs()
		end
	},
	TrustMsgOnSearch = {
		Element = var_0_6.Checkbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Trust Message on Search"),
		Hidden = {
			Message = {
				Element = var_0_6.Combobox(var_0_6.Config.Panel, var_0_6.Config.Side, "Trust Message", {
					"-",
					"Yellow",
					"Red"
				}),
				Callback = function(arg_12_0)
					local var_12_0 = var_0_6.Get(var_0_6.UI.Target.Element)

					if var_0_6.Data.Targets[var_12_0 - 1] ~= var_0_6.Get(arg_12_0) then
						var_0_6.Data.Targets[var_12_0 - 1] = var_0_6.Get(arg_12_0)
					end

					var_0_6.Funcs.BuildFuncs()
				end
			}
		},
		Callback = function(arg_13_0)
			var_0_6.SetVisible(var_0_6.UI.TrustMsgOnSearch.Hidden.Message.Element, var_0_6.Get(arg_13_0))
			var_0_6.Funcs.BuildFuncs()
		end
	},
	StopQueue = {
		Element = var_0_6.Checkbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Auto Stop Queue"),
		Hidden = {
			Silent = {
				Element = var_0_6.Checkbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Silent"),
				Callback = function(arg_14_0)
					var_0_6.SetVisible(var_0_6.UI.StopQueue.Hidden.Error.Element, not var_0_6.Get(arg_14_0))
					var_0_6.Funcs.BuildFuncs()
				end
			},
			Error = {
				Element = var_0_6.Combobox(var_0_6.Config.Panel, var_0_6.Config.Side, "Queue Error", var_0_6.Chat.QueueErrors),
				Callback = function(arg_15_0)
					var_0_6.Funcs.BuildFuncs()
				end
			}
		},
		Callback = function(arg_16_0)
			local var_16_0 = var_0_6.Get(arg_16_0)
			local var_16_1 = var_0_6.UI.StopQueue.Hidden

			var_0_6.SetVisible(var_16_1.Silent.Element, var_16_0)
			var_0_6.SetVisible(var_16_1.Error.Element, var_16_0)
			var_0_6.Funcs.BuildFuncs()
		end
	},
	LoopMessages = {
		Element = var_0_6.Checkbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Loop Messages"),
		Hidden = {
			Delay = var_0_6.Slider(var_0_6.Config.Panel, var_0_6.Config.Side, "Spam Delay", 1, 1000, 250, true, "ms"),
			Amt = var_0_6.Slider(var_0_6.Config.Panel, var_0_6.Config.Side, "Spam Per Loop", 1, 200, 1, true)
		},
		Callback = function(arg_17_0)
			local var_17_0 = var_0_6.Get(arg_17_0)
			local var_17_1 = var_0_6.UI.LoopMessages.Hidden

			var_0_6.SetVisible(var_17_1.Delay, var_17_0)
			var_0_6.SetVisible(var_17_1.Amt, var_17_0)
		end
	},
	MessageType = {
		Element = var_0_6.Combobox(var_0_6.Config.Panel, var_0_6.Config.Side, "Message Type", var_0_6.Chat.MessageTypes),
		Hidden = {
			Text = var_0_6.Textbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Message Text"),
			Colour = var_0_6.Combobox(var_0_6.Config.Panel, var_0_6.Config.Side, "Message Colour", var_0_6.Chat.Colours),
			RandErr = {
				Element = var_0_6.Checkbox(var_0_6.Config.Panel, var_0_6.Config.Side, "Random Error"),
				Callback = function(arg_18_0)
					var_0_6.SetVisible(var_0_6.UI.MessageType.Hidden.ErrorList, not var_0_6.Get(arg_18_0))
					var_0_6.Funcs.BuildFuncs()
				end
			},
			ErrorList = var_0_6.ListBox(var_0_6.Config.Panel, var_0_6.Config.Side, "Error List", var_0_6.Chat.Errors)
		},
		Callback = function(arg_19_0)
			local var_19_0 = var_0_6.Get(arg_19_0) == "Error"
			local var_19_1 = var_0_6.UI.MessageType.Hidden

			var_0_6.SetVisible(var_19_1.Text, var_0_6.Get(arg_19_0) == "Chat")
			var_0_6.SetVisible(var_19_1.Colour, var_19_0)
			var_0_6.SetVisible(var_19_1.RandErr.Element, var_19_0)

			if var_0_6.Get(var_19_1.RandErr.Element) then
				var_0_6.SetVisible(var_19_1.ErrorList, not var_0_6.Get(var_19_1.RandErr.Element))
			else
				var_0_6.SetVisible(var_19_1.ErrorList, var_19_0)
			end

			var_0_6.Funcs.BuildFuncs()
		end
	},
	["Close Windows"] = {
		Element = var_0_6.Button(var_0_6.Config.Panel, var_0_6.Config.Side, "Force Close Windows", function(arg_20_0)
			return
		end),
		Callback = var_0_6.Funcs.ClearPopups
	},
	["Execute Message"] = {
		Element = var_0_6.Button(var_0_6.Config.Panel, var_0_6.Config.Side, "Execute Message", function(arg_21_0)
			return
		end),
		Callback = var_0_6.Funcs.HandleMessage
	},
	lblEnd = {
		Element = var_0_6.Label(var_0_6.Config.Panel, var_0_6.Config.Side, "---------------[End Lobby Utils]----------------"),
		Callback = function(arg_22_0)
			return
		end
	}
}

var_0_6.RegisterEvent("shutdown", function()
	var_0_7.stop()
end)
var_0_6.Funcs.BuildFuncs()

for iter_0_0, iter_0_1 in pairs(var_0_6.UI) do
	if iter_0_1.Hidden then
		for iter_0_2, iter_0_3 in pairs(iter_0_1.Hidden) do
			if type(iter_0_3) == "table" then
				var_0_6.SetCallback(iter_0_3.Element, iter_0_3.Callback)
				var_0_6.SetVisible(iter_0_3.Element, false)
			else
				var_0_6.SetVisible(iter_0_3, false)
			end
		end
	else
		var_0_6.SetVisible(iter_0_1.Element, true)
	end

	var_0_6.SetCallback(iter_0_1.Element, iter_0_1.Callback)
end
