slot0 = panorama.open()
slot1 = slot0.MyPersonaAPI
slot4 = slot0.FriendsListAPI
slot5 = slot0.GameStateAPI
slot6 = {
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

if not slot0.LobbyAPI.IsSessionActive() then
	slot2.CreateSession()
	slot0.PartyListAPI.SessionCommand("MakeOnline", "")
end

panorama.loadstring("\tvar waitForSearchingEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', function() {});\n")()

slot7 = panorama.loadstring([[
	return {
		start: function(callback) {
			waitForSearchingEventHandler = $.RegisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', callback);
		},
		stop: function() {
			$.UnregisterForUnhandledEvent('PanoramaComponent_Lobby_MatchmakingSessionUpdate', waitForSearchingEventHandler);
		}
	}
]])()

slot7.start(panorama.loadstring("return function() {}")())
slot7.stop()

slot6.Config = {
	Side = "B",
	Panel = "LUA"
}
slot6.Chat = {
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
slot6.Data = {
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
slot6.Funcs = {
	["table.HasValue"] = function (slot0, slot1)
		for slot5, slot6 in ipairs(uv0.Data.BadMessages) do
			if slot6 == slot1 then
				return true
			end
		end

		return false
	end,
	arrToStr = function ()
		for slot4, slot5 in pairs(uv0.Data.Targets) do
			slot0 = string.format("%s'%s',", "[", slot5)
		end

		return string.format("%s];", slot0)
	end,
	GetRandomErrorMessage = function ()
		return uv0.Chat.Errors[uv0.RandInt(1, #uv0.Chat.Errors)]
	end,
	BuildFuncs = function ()
		slot1 = uv0.Chat.ErrorPrefix

		uv1.stop()
		uv1.start(panorama.loadstring(string.format([[
			return function() {
				if (LobbyAPI.GetMatchmakingStatusString() == '#SFUI_QMM_State_find_searching') {
					if (%s) {
						let trustFactorData = %s
						let sendTrustMsg = false;

						for (let i = 0; i < trustFactorData.length; i++) {
							let trustOption = trustFactorData[i];
			
							if (trustOption != '-') {
								let userXUID = PartyListAPI.GetXuidByIndex(i);

								if (trustOption === 'Red' || trustOption === 'Yellow') {sendTrustMsg = true;}
				
								let msgType = (trustOption === 'Red') ? 'ChatReportError' : 'ChatReportYellow';
								let msgCol = (trustOption === 'Red') ? "error" : "yellow";
								let trustMessage = (trustOption === 'Red') ? 'X_AccountWarningTrustMajor' : 'X_AccountWarningTrustMinor';
				
								PartyListAPI.SessionCommand(`Game::${msgType}`, `run all xuid ${userXUID} ${msgCol} %s${trustMessage}`);
							}
						}
				
						if (sendTrustMsg) {
							PartyListAPI.SessionCommand('Game::ChatReportError', `run all xuid ${MyPersonaAPI.GetXuid()} error %sX_AccountWarningTrustMajor_Summary `);
						}
					}
	
					if (%s) {
						let target = (LobbyAPI.BIsHost()) ? PartyListAPI.GetXuidByIndex(%s) : MyPersonaAPI.GetXuid();
	
						if (!%s) {
							PartyListAPI.SessionCommand('Game::ChatReportError', `run all xuid ${target} error %s%s`);
						}
	
						LobbyAPI.StopMatchmaking();
					}
				}
			}
		]], tostring(uv0.Get(uv0.UI.TrustMsgOnSearch.Element)), uv0.Funcs.arrToStr(), slot1, slot1, tostring(uv0.Get(uv0.UI.StopQueue.Element)), uv0.Get(uv0.UI.Target.Element) - 1, tostring(uv0.Get(uv0.UI.StopQueue.Hidden.Silent.Element)), slot1, uv0.Get(uv0.UI.StopQueue.Hidden.Error.Element)))())
	end,
	ClearPopups = function ()
		slot0 = "CSGOMainMenu"

		if uv0.IsLocalPlayerPlayingMatch() then
			slot0 = "ContextMenuManager"
		end

		panorama.loadstring("UiToolkitAPI.CloseAllVisiblePopups()", slot0)()
	end,
	ExecuteMessage = function ()
		slot3 = ""
		slot4 = ""
		slot5 = uv1.BIsHost() and uv2.GetXuidByIndex(uv0.Get(uv0.UI.Target.Element) - 1) or uv3.GetXuid()

		if uv0.Get(uv0.UI.MessageType.Element) == "Chat" then
			slot2 = string.format("%sChat", "Game::")
			slot3 = "chat"
			slot4 = uv0.Get(slot0.Hidden.Text):gsub(" ", " ")
		elseif slot1 == "Error" then
			if uv0.Get(slot0.Hidden.Colour) == "Red" then
				slot2 = string.format("%sChatReportError", slot2)
				slot3 = "error"
			else
				slot2 = string.format("%sChatReport%s", slot2, slot3)
				slot3 = slot3:lower()
			end

			if uv0.Get(slot0.Hidden.RandErr.Element) then
				slot4 = string.format("%s%s", string.format("%s%s", slot4, uv0.Chat.ErrorPrefix), uv0.Funcs.GetRandomErrorMessage())
			else
				slot4 = string.format("%s%s", slot4, uv0.Chat.Errors[uv0.Get(slot0.Hidden.ErrorList) + 1])
			end
		elseif slot1 == "Invite" then
			slot2 = string.format("%sChatInviteMessage", slot2)
			slot5 = uv3.GetXuid()
			slot3 = "friend"
			slot4 = uv4.GetXuidByIndex(uv0.RandInt(1, uv4.GetCount() - 1))
		elseif slot1 == "Start/Stop Queue" then
			uv1.StartMatchmaking("", "", "", "")
			uv1.StopMatchmaking()

			return
		elseif slot1 == "Popup Window" then
			slot2 = string.format("%sHostEndGamePlayAgain", slot2)

			uv0.Delay(0.5, function ()
				uv0.Funcs.ClearPopups()
			end)
		elseif slot1 == "Ear Rape [1]" then
			for slot9 = 1, uv0.Get(uv0.UI.LoopMessages.Hidden.Amt) do
				uv1.StartMatchmaking("", "", "", "")
				uv1.StopMatchmaking()
			end

			return
		elseif slot1 == "Ear Rape [2]" then
			for slot9 = 1, uv0.Get(uv0.UI.LoopMessages.Hidden.Amt) do
				uv2.SessionCommand("Game::Chat", string.format("run all xuid %s name %s chat ", uv3.GetXuid(), uv3.GetName()))
			end

			return
		else
			for slot9 = 1, uv0.Get(uv0.UI.LoopMessages.Hidden.Amt) do
				uv2.SessionCommand("Game::HostEndGamePlayAgain", string.format("run all xuid %s", uv3.GetXuid()))
			end

			uv0.Delay(0.5, function ()
				uv0.Funcs.ClearPopups()
			end)

			return
		end

		uv2.SessionCommand(slot2, string.format("run all xuid %s %s %s", slot5, #slot3 > 1 and " " .. slot3 or "", #slot4 > 1 and " " .. slot4 or ""))
	end,
	HandleMessage = function ()
		slot0 = uv0.UI.LoopMessages.Hidden

		if uv0.Get(uv0.UI.LoopMessages.Element) and not uv0.Funcs["table.HasValue"](uv0.Data.BadMessages, uv0.Get(uv0.UI.MessageType.Element)) then
			for slot5 = 1, uv0.Get(slot0.Amt) do
				if not uv0.Get(uv0.UI.LoopMessages.Element) then
					break
				end

				uv0.Funcs.ExecuteMessage()
			end

			uv0.Delay(uv0.Get(slot0.Delay) / 1000, uv0.Funcs.HandleMessage)
		else
			uv0.Funcs.ExecuteMessage()
		end
	end
}
slot11 = slot6.Config.Panel
slot12 = slot6.Config.Side
slot6.UI = {
	lblStart = {
		Element = slot6.Label(slot6.Config.Panel, slot6.Config.Side, "---------------[Start Lobby Utils]--------------"),
		Callback = function (slot0)
		end
	},
	Target = {
		Element = slot6.Slider(slot6.Config.Panel, slot6.Config.Side, "Target Player", 1, 5, 0),
		Callback = function (slot0)
			uv0.Set(uv0.UI.TrustMsgOnSearch.Hidden.Message.Element, uv0.Data.Targets[uv0.Get(slot0) - 1])
			uv0.Funcs.BuildFuncs()
		end
	},
	TrustMsgOnSearch = {
		Element = slot6.Checkbox(slot6.Config.Panel, slot6.Config.Side, "Trust Message on Search"),
		Hidden = {
			Message = {
				Element = slot6.Combobox(slot6.Config.Panel, slot6.Config.Side, "Trust Message", {
					"-",
					"Yellow",
					"Red"
				}),
				Callback = function (slot0)
					if uv0.Data.Targets[uv0.Get(uv0.UI.Target.Element) - 1] ~= uv0.Get(slot0) then
						uv0.Data.Targets[slot1 - 1] = uv0.Get(slot0)
					end

					uv0.Funcs.BuildFuncs()
				end
			}
		},
		Callback = function (slot0)
			uv0.SetVisible(uv0.UI.TrustMsgOnSearch.Hidden.Message.Element, uv0.Get(slot0))
			uv0.Funcs.BuildFuncs()
		end
	},
	StopQueue = {
		Element = slot6.Checkbox(slot6.Config.Panel, slot6.Config.Side, "Auto Stop Queue"),
		Hidden = {
			Silent = {
				Element = slot6.Checkbox(slot6.Config.Panel, slot6.Config.Side, "Silent"),
				Callback = function (slot0)
					uv0.SetVisible(uv0.UI.StopQueue.Hidden.Error.Element, not uv0.Get(slot0))
					uv0.Funcs.BuildFuncs()
				end
			},
			Error = {
				Element = slot6.Combobox(slot6.Config.Panel, slot6.Config.Side, "Queue Error", slot6.Chat.QueueErrors),
				Callback = function (slot0)
					uv0.Funcs.BuildFuncs()
				end
			}
		},
		Callback = function (slot0)
			slot1 = uv0.Get(slot0)
			slot2 = uv0.UI.StopQueue.Hidden

			uv0.SetVisible(slot2.Silent.Element, slot1)
			uv0.SetVisible(slot2.Error.Element, slot1)
			uv0.Funcs.BuildFuncs()
		end
	},
	LoopMessages = {
		Element = slot6.Checkbox(slot6.Config.Panel, slot6.Config.Side, "Loop Messages"),
		Hidden = {
			Delay = slot6.Slider(slot6.Config.Panel, slot6.Config.Side, "Spam Delay", 1, 1000, 250, true, "ms"),
			Amt = slot6.Slider(slot6.Config.Panel, slot6.Config.Side, "Spam Per Loop", 1, 200, 1, true)
		},
		Callback = function (slot0)
			slot1 = uv0.Get(slot0)
			slot2 = uv0.UI.LoopMessages.Hidden

			uv0.SetVisible(slot2.Delay, slot1)
			uv0.SetVisible(slot2.Amt, slot1)
		end
	},
	MessageType = {
		Element = slot6.Combobox(slot6.Config.Panel, slot6.Config.Side, "Message Type", slot6.Chat.MessageTypes),
		Hidden = {
			Text = slot6.Textbox(slot6.Config.Panel, slot6.Config.Side, "Message Text"),
			Colour = slot6.Combobox(slot6.Config.Panel, slot6.Config.Side, "Message Colour", slot6.Chat.Colours),
			RandErr = {
				Element = slot6.Checkbox(slot6.Config.Panel, slot6.Config.Side, "Random Error"),
				Callback = function (slot0)
					uv0.SetVisible(uv0.UI.MessageType.Hidden.ErrorList, not uv0.Get(slot0))
					uv0.Funcs.BuildFuncs()
				end
			},
			ErrorList = slot6.ListBox(slot6.Config.Panel, slot6.Config.Side, "Error List", slot6.Chat.Errors)
		},
		Callback = function (slot0)
			slot1 = uv0.Get(slot0) == "Error"

			uv0.SetVisible(uv0.UI.MessageType.Hidden.Text, uv0.Get(slot0) == "Chat")
			uv0.SetVisible(slot2.Colour, slot1)
			uv0.SetVisible(slot2.RandErr.Element, slot1)

			if uv0.Get(slot2.RandErr.Element) then
				uv0.SetVisible(slot2.ErrorList, not uv0.Get(slot2.RandErr.Element))
			else
				uv0.SetVisible(slot2.ErrorList, slot1)
			end

			uv0.Funcs.BuildFuncs()
		end
	},
	["Close Windows"] = {
		Element = slot6.Button(slot6.Config.Panel, slot6.Config.Side, "Force Close Windows", function (slot0)
		end),
		Callback = slot6.Funcs.ClearPopups
	},
	["Execute Message"] = {
		Element = slot6.Button(slot6.Config.Panel, slot6.Config.Side, "Execute Message", function (slot0)
		end),
		Callback = slot6.Funcs.HandleMessage
	},
	lblEnd = {
		Element = slot6.Label(slot11, slot12, "---------------[End Lobby Utils]----------------"),
		Callback = function (slot0)
		end
	}
}

slot6.RegisterEvent("shutdown", function ()
	uv0.stop()
end)
slot6.Funcs.BuildFuncs()

for slot11, slot12 in pairs(slot6.UI) do
	if slot12.Hidden then
		for slot16, slot17 in pairs(slot12.Hidden) do
			if type(slot17) == "table" then
				slot6.SetCallback(slot17.Element, slot17.Callback)
				slot6.SetVisible(slot17.Element, false)
			else
				slot6.SetVisible(slot17, false)
			end
		end
	else
		slot6.SetVisible(slot12.Element, true)
	end

	slot6.SetCallback(slot12.Element, slot12.Callback)
end
