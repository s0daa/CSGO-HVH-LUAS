slot0 = nil

if pcall(client.create_interface) then
	slot2 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
	slot3 = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
	slot4 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
	slot5 = require("ffi").typeof("char[?]")

	function slot0()
		if uv0() > 0 then
			slot1 = uv1(slot0)

			uv2(0, slot1, slot0)

			return uv3.string(slot1, slot0 - 1)
		end
	end
end

panorama.loadstring([[
	var panel_invite_all, panel_btn

	var players = []
	var refresh_handler
	var refresh_button
	var tooltip_visible = false

	var collecting_players = false
	var next_filter = {}

	var _BuildPlayers = function(){
		if(!refresh_button.visible)
			return

		var count = PartyBrowserAPI.GetResultsCount()
		for(i=0; i < count; i++){
			var xuid = PartyBrowserAPI.GetXuidByIndex(i)
			if(!players.includes(xuid)){
				players.push(xuid)
			}
		}
		if(tooltip_visible){
			_HideTooltip()
			_ShowTooltip()
		}
	}

	var _CollectPlayers = function(){
		collecting_players = !collecting_players

		if(collecting_players){
			panel_btn.style.backgroundColor = "gradient(linear, 100% 0%, 0% 0%, from( #00000000), color-stop( 0, #95b80666 ), to( #95b806FF ));"
			if(PartyBrowserAPI.GetProgress() == 100){
				PartyBrowserAPI.Refresh()
			}
		} else {
			panel_btn.style.backgroundColor = null
		}

		if(tooltip_visible){
			_HideTooltip()
			_ShowTooltip()
		}
	}

	var _PartyBrowserRefresh = function(){
		_BuildPlayers()
		if(collecting_players){
			if(tooltip_visible){
				_HideTooltip()
				_ShowTooltip()
			}
			if(PartyBrowserAPI.GetProgress() == 100){
				var cur_filter = GameInterfaceAPI.GetSettingString('ui_nearbylobbies_filter')
				var new_filter = next_filter[cur_filter]

				if(new_filter != null){
					GameInterfaceAPI.SetSettingString('ui_nearbylobbies_filter', new_filter)
					PartyBrowserAPI.SetSearchFilter(new_filter)
					PartyBrowserAPI.Refresh()
				}
			}
		}
	}

	var _InviteAll = function(){
		if(collecting_players){
			_CollectPlayers()
		}
		_BuildPlayers()
		players.forEach(function(player){
			FriendsListAPI.ActionInviteFriend(player, "")
		})
	}

	var _ShowTooltip = function(){
		_BuildPlayers()
		if(collecting_players){
			var game_mode_name = $.Localize(`#SFUI_GameMode_${GameInterfaceAPI.GetSettingString('ui_nearbylobbies_filter')}`)
			UiToolkitAPI.ShowTextTooltip('JsFriendsList-lobbies-toolbar-button-inviteall', `Left-click: Invite ${players.length} players\nRight-click: Stop collecting\n\nCollecting players... \n[${PartyBrowserAPI.GetProgress()}%] ${game_mode_name}`)
		} else {
			UiToolkitAPI.ShowTextTooltip('JsFriendsList-lobbies-toolbar-button-inviteall', `Left-click: Invite ${players.length} players\nRight-click: Collect players`)
		}
		tooltip_visible = true
	}

	var _HideTooltip = function(){
		UiToolkitAPI.HideTextTooltip()
		tooltip_visible = false
	}

	var _Create = function(layout){
		var panel_refresh = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies-toolbar-button-refresh")
		var panel_parent = panel_refresh.GetParent()

		panel_invite_all = $.CreatePanel('Button', panel_parent, 'InviteAllButton')
		if (panel_invite_all != null) {
			panel_invite_all.SetParent(panel_parent)
			panel_parent.MoveChildBefore(panel_invite_all, panel_refresh)

			if (panel_invite_all.BLoadLayoutFromString(layout, false, false)) {
				panel_invite_all.visible = true

				panel_btn = panel_invite_all.FindChildTraverse("JsFriendsList-lobbies-toolbar-button-inviteall")
				if(panel_btn != null){
					panel_btn.SetPanelEvent("onactivate", _InviteAll)
					panel_btn.SetPanelEvent("onmouseover", _ShowTooltip)
					panel_btn.SetPanelEvent("onmouseout", _HideTooltip)
					panel_btn.SetPanelEvent("oncontextmenu", _CollectPlayers)
				}

				next_filter = {}
				var re = /^JsFriendsList-lobbies-toolbar-button-(.*)$/
				var filters = []

				panel_parent.Children().forEach(function(el){
					if(el.paneltype == "RadioButton" && el.group == "JsFriendsList-lobbies-toolbar-button-modegroup"){
						var match = el.id.match(re)
						if(match){
							filters.push(match[1])
						}
					}
				})

				if(filters.length > 1){
					for(i=0; i<filters.length-1; i++){
						next_filter[ filters[i] ] = filters[i+1]
					}
					next_filter[ filters[filters.length-1] ] = filters[0]
				}
			}
		}
		if(refresh_handler == null){
			refresh_handler = $.RegisterForUnhandledEvent('PanoramaComponent_PartyBrowser_Refresh', _PartyBrowserRefresh)
		}
		if(refresh_button == null){
			refresh_button = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies-toolbar-button-refresh")
		}
	}

	var _Destroy = function(){
		if (panel_invite_all != null) {
			panel_invite_all.RemoveAndDeleteChildren()
			panel_invite_all.DeleteAsync(0.0)
			panel_invite_all = null
		}
		if(refresh_handler != null){
			$.UnregisterForUnhandledEvent('PanoramaComponent_PartyBrowser_Refresh', refresh_handler)
			refresh_handler = null
		}
	}

	return {
		create: _Create,
		destroy: _Destroy
	}
]], "CSGOMainMenu")().create([[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/friendslist.css" />
		<include src="file://{resources}/styles/playercard.css" />
		<include src="file://{resources}/styles/friendtile.css" />
	</styles>
	<Panel>
		<Button id="JsFriendsList-lobbies-toolbar-button-inviteall" class="IconButton">
			<Image src="file://{images}/icons/ui/invite.svg"/>
		</Button>
	</Panel>
</root>
]])
panorama.loadstring([[
	var panel_tabs, panel_steam_friends, panel_extended_friends, panel_extended_friends_separator, panel_list
	var custom_friends_xuids = []
	var custom_friends_enabled = false
	var custom_friends_status = {}

	// invite button
	var invite_btn_pressed = false
	var invite_btn_xuid, invite_btn_time, invite_btn_source

	// FriendsListAPI hook stuff
	var orig = {
		GetCount: FriendsListAPI.GetCount,
		GetXuidByIndex: FriendsListAPI.GetXuidByIndex,
		GetFriendStatus: FriendsListAPI.GetFriendStatus,
		GetFriendStatusBucket: FriendsListAPI.GetFriendStatusBucket,
		GetFriendRelationship: FriendsListAPI.GetFriendRelationship,
		IsFriendInvited: FriendsListAPI.IsFriendInvited
	}

	var hk_extra_xuids = []
	var hk_extra_xuids_count_prev
	var real_count

	FriendsListAPI.GetCount = function(){
		real_count = orig.GetCount.call(this)

		return real_count+hk_extra_xuids.length
	}

	FriendsListAPI.GetXuidByIndex = function(index){
		if(index >= real_count){
			return hk_extra_xuids[index-real_count]
		}

		return orig.GetXuidByIndex.call(this, index)
	}

	FriendsListAPI.GetFriendStatus = function(xuid){
		var result = orig.GetFriendStatus.call(this, xuid)
		if(result == "" && hk_extra_xuids.includes(xuid)){
			return "Custom Friend"
		}

		return result
	}

	FriendsListAPI.GetFriendStatusBucket = function(xuid){
		var result = orig.GetFriendStatusBucket.call(this, xuid)
		if(result == "Offline" && hk_extra_xuids.includes(xuid)){
			// return "Offline"
		}

		return result
	}

	FriendsListAPI.GetFriendRelationship = function(xuid){
		var result = orig.GetFriendRelationship.call(this, xuid)
		if(result == "none" && hk_extra_xuids.includes(xuid)){
			return "friend"
		}

		return result
	}

	var _Create = function(layout){
		var panel_friends = $.GetContextPanel().FindChildTraverse("JsFriendsList-friends")
		panel_list = panel_friends.FindChildTraverse("JsFriendsList-List")

		var panel_container = $.CreatePanel('Panel', panel_friends, 'FriendsListTabs')
		if (panel_container != null) {
			if (panel_container.BLoadLayoutFromString(layout, false, false)) {
				panel_container.visible = true

				panel_tabs = panel_container.GetChild(0)
				panel_tabs.SetParent(panel_friends)
				panel_friends.MoveChildBefore(panel_tabs, panel_friends.GetChild(0))

				panel_container.RemoveAndDeleteChildren()
				panel_container.DeleteAsync(0.0)

				panel_steam_friends = panel_tabs.FindChildTraverse("JsFriendsList-SteamFriends")
				panel_extended_friends = panel_tabs.FindChildTraverse("JsFriendsList-ExtendedFriends")
				panel_extended_friends_separator = panel_tabs.FindChildTraverse("JsFriendsList-ExtendedFriendsSeparator")

				if(panel_steam_friends != null){
					panel_steam_friends.SetPanelEvent("onactivate", function(){
						custom_friends_enabled = false
						_UpdateCustomFriends()
					})
				}

				if(panel_extended_friends != null){
					panel_extended_friends.SetPanelEvent("onactivate", function(){
						custom_friends_enabled = true
						_UpdateCustomFriends()
					})
				}

				var panel_invite_all = panel_tabs.FindChildTraverse("JsFriendsList-friends-toolbar-button-invite")
				if(panel_invite_all != null){
					panel_invite_all.SetPanelEvent("onactivate", function(){
						invite_btn_pressed = true
					})
					panel_invite_all.SetPanelEvent("oncontextmenu", function(){
						var count = FriendsListAPI.GetCount()

						for(i=0; i < count; i++){
							FriendsListAPI.ActionInviteFriend(FriendsListAPI.GetXuidByIndex(i), "")
						}
					})
				}
				var panel_copy_friend_code = panel_tabs.FindChildTraverse("JsFriendsList-friends-toolbar-button-copy-friend-code")
				if(panel_copy_friend_code != null){
					panel_copy_friend_code.SetPanelEvent("onactivate", function(){
						var yourCode = MyPersonaAPI.GetFriendCode()
						SteamOverlayAPI.CopyTextToClipboard(yourCode)
						UiToolkitAPI.ShowTextTooltip('JsFriendsList-friends-toolbar-button-copy-friend-code', 'Copied your code to clipboard')
					})
				}

				_UpdateCustomFriends()
			}
		}
	}

	var _Destroy = function(){
		if (panel_tabs != null){
			panel_tabs.RemoveAndDeleteChildren()
			panel_tabs.DeleteAsync(0.0)
			panel_tabs = null
		}

		// restore
		for(var key in orig){
			FriendsListAPI[key] = orig[key]
		}
	}

	var _UpdateCustomFriends = function(){
		var has_custom_friends = custom_friends_xuids.length > 0

		if(panel_steam_friends != null){
			panel_steam_friends.visible = has_custom_friends;
		}
		if(panel_extended_friends != null){
			panel_extended_friends.visible = has_custom_friends;
		}
		if(panel_extended_friends_separator != null){
			panel_extended_friends_separator.visible = has_custom_friends;
		}

		hk_extra_xuids = (has_custom_friends && custom_friends_enabled) ? custom_friends_xuids : []
		hk_extra_xuids = hk_extra_xuids.filter(function(xuid){
			return orig.GetFriendRelationship.call(FriendsListAPI, xuid) == "none"
		})

		if(hk_extra_xuids.length != hk_extra_xuids_count_prev){
			hk_extra_xuids.forEach(function(xuid){
				var panel = panel_list.FindChildTraverse(xuid)
				if(panel != null){
					panel.DeleteAsync(0.0)
				}
			})
			$.DispatchEvent("PanoramaComponent_FriendsList_RebuildFriendsList")

			hk_extra_xuids_count_prev = hk_extra_xuids.length
		}
	}

	var _SetCustomFriends = function(xuids){
		custom_friends_xuids = xuids || []

		_UpdateCustomFriends()
	}

	var _InviteBtnPressed = function(){
		if(invite_btn_pressed){
			invite_btn_pressed = false
			return true
		}
		return invite_btn_pressed
	}

	var _InviteBtnCallback = function(text){
		invite_btn_xuid = null
		text = text.replace(/[\n\s]/g, "")

		// friend code check
		if(text.match(/^[A-Z0-9]{5}\-[A-Z0-9]{4}$/)){
			invite_btn_source = "friend code"
			invite_btn_xuid = FriendsListAPI.GetXuidFromFriendCode(text)
		} else {
			var match = text.match(/^(?:https:\/\/steamcommunity.com\/profiles\/)?(765\d{14})\/?/)
			if(match){
				invite_btn_source = "steamid"
				invite_btn_xuid = match[1]
			}
		}

		if(invite_btn_xuid == MyPersonaAPI.GetXuid()){
			UiToolkitAPI.ShowTextTooltip("JsFriendsList-friends-toolbar-button-invite", "You can't invite yourself!")
			invite_btn_xuid = null
		} else if(invite_btn_xuid != null && LobbyAPI.IsPartyMember(invite_btn_xuid)) {
			UiToolkitAPI.ShowTextTooltip("JsFriendsList-friends-toolbar-button-invite", "Player already in lobby!")
			invite_btn_xuid = null
		} else if(invite_btn_xuid != null){
			UiToolkitAPI.ShowTextTooltip("JsFriendsList-friends-toolbar-button-invite", "Loading...")
			invite_btn_time = Date.now()
			_InviteBtnJob()
		} else {
			UiToolkitAPI.ShowTextTooltip("JsFriendsList-friends-toolbar-button-invite", "Invalid friendcode / steamid")
		}
	}

	var _InviteBtnJob = function(){
		if(invite_btn_xuid != null){
			var name = FriendsListAPI.GetFriendName(invite_btn_xuid)

			if(name == "" && Date.now()-invite_btn_time > 5*1000)
				name = "unknown"

			if(name != ""){
				FriendsListAPI.ActionInviteFriend(invite_btn_xuid, '')
				UiToolkitAPI.ShowTextTooltip('JsFriendsList-friends-toolbar-button-invite', `Invited ${name} by ${invite_btn_source}!`)
				invite_btn_xuid = null
				invite_btn_time = null
				invite_btn_source = null
			}

			return name == ""
		}
	}

	return {
		create: _Create,
		destroy: _Destroy,
		set_custom_friends: _SetCustomFriends,
		invite_btn_pressed: _InviteBtnPressed,
		invite_btn_callback: _InviteBtnCallback,
		invite_btn_job: _InviteBtnJob
	}
]], "CSGOMainMenu")().create([[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/friendslist.css" />
		<include src="file://{resources}/styles/playercard.css" />
		<include src="file://{resources}/styles/friendtile.css" />
	</styles>
	<Panel>
		<Panel class="friendslist-navbar friendslist-navbar--tab-settings expand">
			<Panel class= "horizontal-align-left vertical-center left-right-flow" >
				<RadioButton id="JsFriendsList-SteamFriends" class="IconButton friendslist-navbar-lobby-button" selected="true"
					group="JsFriendsList-friends-toolbar-button-modegroup"
					onmouseover="UiToolkitAPI.ShowTextTooltip('JsFriendsList-SteamFriends', 'Steam Friends');"
					onmouseout="UiToolkitAPI.HideTextTooltip();">
					<Image src="file://{images}/icons/ui/player.svg"/>
				</RadioButton>
				<RadioButton id="JsFriendsList-ExtendedFriends" class="IconButton friendslist-navbar-lobby-button"
					group="JsFriendsList-friends-toolbar-button-modegroup"
					onmouseover="UiToolkitAPI.ShowTextTooltip('JsFriendsList-ExtendedFriends', 'Extended Friends');"
					onmouseout="UiToolkitAPI.HideTextTooltip();">
					<Image src="file://{images}/icons/ui/lobby.svg"/>
				</RadioButton>
				<Panel id="JsFriendsList-ExtendedFriendsSeparator" class="friendslist-navbar-spacer-fit-width"/>
				<Button id="JsFriendsList-friends-toolbar-button-copy-friend-code" class="IconButton"
					onmouseover="UiToolkitAPI.ShowTextTooltip('JsFriendsList-friends-toolbar-button-copy-friend-code', 'Copy your friend code');"
					onmouseout="UiToolkitAPI.HideTextTooltip();">
					<Image src="file://{images}/icons/ui/link.svg"/>
				</Button>
				<Button id="JsFriendsList-friends-toolbar-button-invite" class="IconButton"
					onmouseover="UiToolkitAPI.ShowTextTooltip('JsFriendsList-friends-toolbar-button-invite', 'Left-click: Invite from clipboard\nRight-click: Invite all friends');"
					onmouseout="UiToolkitAPI.HideTextTooltip();">
					<Image src="file://{images}/icons/ui/invite.svg"/>
				</Button>
			</Panel>
		</Panel>
	</Panel>
</root>
]])
panorama.loadstring([[
	var debug = false

	var custom_panels = []
	var show_accept_popup_handler

	var _UpdateAcceptPopup = function(){
		$.GetContextPanel().FindChildrenWithClassTraverse("accept-match-container").forEach(function(panel){
			var panel_data_container = panel.FindChildTraverse("AcceptMatchDataContainer")
			var panel_parent = panel_data_container.GetParent()

			var panel_container = $.CreatePanel('Panel', panel_parent, 'ExtraOptions-Container')
			if (panel_container != null) {
				if (panel_container.BLoadLayoutFromString(layout, false, false)) {
					var panel_extra_options = panel_container.FindChild("ExtraOptions")

					panel_extra_options.visible = true

					// swap that mf parent and "extract" panel_extra_options from the container panel
					panel_extra_options.SetParent(panel_parent)

					// remove comtainer that we loaded the layout into
					panel_container.RemoveAndDeleteChildren()
					panel_container.DeleteAsync(0.0)

					// casual accept, for example
					var is_auto = panel_data_container.BHasClass("auto")

					// cancel is visible if we're leader and not auto accepting
					var button_cancel_search = panel_extra_options.FindChildTraverse("ExtraOptions-Cancel")
					if(button_cancel_search){
						button_cancel_search.visible = !is_auto || debug
						button_cancel_search.SetHasClass("hidden", !button_cancel_search.visible)
					}

					// leave is visible if we're in a public lobby and not auto accepting
					var button_leave_lobby = panel_extra_options.FindChildTraverse("ExtraOptions-Leave")
					if(button_leave_lobby){
						button_leave_lobby.visible = (!is_auto && PartyListAPI.GetPartySessionSetting("system/network") == "LIVE") || debug
						button_leave_lobby.SetHasClass("hidden", !button_leave_lobby.visible)
					}

					custom_panels.push(panel_extra_options)
				}
			}
		})
	}

	var _Create = function(_layout){
		layout = _layout

		if(show_accept_popup_handler == null){
			show_accept_popup_handler = $.RegisterForUnhandledEvent('ShowAcceptPopup', _UpdateAcceptPopup)
		}
		_UpdateAcceptPopup()
	}

	var _Destroy = function(){
		custom_panels.forEach(function(panel){
			try {
				panel.RemoveAndDeleteChildren()
				panel.DeleteAsync(0.0)
			} catch(e){}
		})

		if(show_accept_popup_handler){
			$.UnregisterForUnhandledEvent('ShowAcceptPopup', show_accept_popup_handler)
			show_accept_popup_handler = null
		}
	}

	return {
		create: _Create,
		destroy: _Destroy
	}
]], "CSGOPopups")().create([[
<root>
	<styles>
		<include src="file://{resources}/styles/gamestyles.css" />
		<include src="file://{resources}/styles/popups/popups_shared.css" />
	</styles>
	<Panel>
		<Panel id="ExtraOptions" class= "horizontal-align-right right-left-flow" style="margin: 4px;">
			<Button id="ExtraOptions-Cancel" class="IconButton" style="margin: 4px; tooltip-position: bottom; tooltip-body-position: 0% 0%;"
				onactivate="LobbyAPI.StopMatchmaking();"
				onmouseover="UiToolkitAPI.ShowTextTooltip('ExtraOptions-CancelTooltip', '#tooltip_canelsearch');"
				onmouseout="UiToolkitAPI.HideTextTooltip();">
				<Panel id="ExtraOptions-CancelTooltip" style="width: 80%; height: 80%; tooltip-position: bottom; tooltip-body-position: 0% 0%;" />
				<Image src="file://{images}/icons/ui/cancel.svg" style="margin: 4px; opacity: 0.55;" />
			</Button>
			<Button id="ExtraOptions-Leave" class="IconButton" style="margin: 4px; padding: 0px;"
				onactivate="LobbyAPI.CloseSession();"
				onmouseover="UiToolkitAPI.ShowTextTooltip('ExtraOptions-LeaveTooltip', '#tooltip_leave_lobby');"
				onmouseout="UiToolkitAPI.HideTextTooltip();">
				<Panel id="ExtraOptions-LeaveTooltip" style="width: 80%; height: 80%; tooltip-position: bottom; tooltip-body-position: 0% 0%;" />
				<Image src="file://{images}/icons/ui/leave.svg" style="margin: 4px; opacity: 0.55;" />
			</Button>
		</Panel>
	</Panel>
</root>
]])
panorama.loadstring([[
	var cancel_btn, session_update_handler

	var _IsSearching = function(){
		var searchingStatus = LobbyAPI.GetMatchmakingStatusString()
		return searchingStatus !== '' && searchingStatus !== undefined
	}

	var _SetCancelBtnVisible = function(visible){
		if(cancel_btn	!= null){
			cancel_btn.visible = visible
			cancel_btn.SetHasClass("hidden", !visible)
		}
	}

	var _UpdateVisibility = function(){
		_SetCancelBtnVisible(_IsSearching())
	}

	var _Create = function(){
		if(session_update_handler == null){
			session_update_handler = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _MatchmakingSessionsUpdate)
		}

		cancel_btn = $.GetContextPanel().FindChildTraverse("PartyListHeader").FindChildTraverse("PartyCancelBtn")

		_UpdateVisibility()
	}

	var _MatchmakingSessionsUpdate = function(){
		_UpdateVisibility()
		$.Schedule(0.0, _UpdateVisibility)
	}

	var _Destroy = function(){
		if(session_update_handler != null){
			$.UnregisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", session_update_handler)
			session_update_handler = null
		}

		_SetCancelBtnVisible(_IsSearching() && LobbyAPI.BIsHost())
	}

	return {
		create: _Create,
		destroy: _Destroy
	}
]], "CSGOMainMenu")().create()
client.set_event_callback("shutdown", function ()
	uv0.destroy()
	uv1.destroy()
	uv2.destroy()
	uv3.destroy()
end)

slot8 = "^765" .. string.rep("%d", 14) .. "$"
slot9 = 0
slot10 = false

client.set_event_callback("paint_ui", function ()
	if globals.realtime() > uv0 + 15 then
		slot0 = {}

		if readfile("friends.txt") ~= nil then
			for slot5 in slot1:gmatch("[^\r\n]+") do
				if slot5:gsub(" ", ""):match(uv1) then
					table.insert(slot0, slot5)
				end
			end
		end

		uv2.set_custom_friends(slot0)

		uv0 = globals.realtime()
	end

	if uv3 and not uv2.invite_btn_job() then
		uv3 = false
	end

	if uv4 ~= nil and uv2.invite_btn_pressed() and type(uv4()) == "string" then
		uv2.invite_btn_callback(slot0)

		uv3 = true
	end
end)
