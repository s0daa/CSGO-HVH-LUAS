slot0 = require("gamesense/panorama_events")
slot1 = require("gamesense/steamworks")
slot2 = require("ffi")
slot3 = "serverbrowser_config"
slot4 = 730
slot5 = {
	AddToFavorites = "ServerBrowser_AddToFavorites",
	SaveFilters = "ServerBrowser_SaveFilters",
	RemoveFromFavorites = "ServerBrowser_RemoveFromFavorites",
	RequestFilters = "ServerBrowser_RequestFilters",
	AddToHistory = "ServerBrowser_AddToHistory",
	ConnectWithPassword = "ServerBrowser_ConnectWithPassword",
	RemoveFromHistory = "ServerBrowser_RemoveFromHistory",
	Connect = "ServerBrowser_Connect",
	RequestPlayerList = "ServerBrowser_RequestPlayerList",
	QuickRefresh = "ServerBrowser_QuickRefresh",
	StopRefresh = "ServerBrowser_StopRefresh",
	Refresh = "ServerBrowser_Refresh",
	UpdateTagFilter = "ServerBrowser_UpdateTagFilter"
}
slot6 = 0
slot7 = 1
slot8 = 2
slot9 = slot1.ISteamMatchmakingServers
slot10 = slot1.ISteamMatchmaking
slot11 = cvar.connect
slot12 = cvar.password
slot13 = {
	filters = {
		{},
		{},
		{},
		{},
		{},
		{}
	}
}

function slot14()
	database.write(uv0, uv1)
end

function ()
	if database.read(uv0) == nil then
		uv1()
	else
		uv2 = slot0
	end
end()

slot16 = panorama.loadstring([[
const IMG_BASE = 'https://relative.im/img'

const SIDE_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/mainmenu.css" />
		<include src="file://{resources}/styles/mainmenu_play.css" />
	</styles>
	<Panel class="top-bottom-flow map-selection-list__quick-selection-sets">
		<Label text="Community Servers" class="map-selection__quick-selection-set-title" />
		<Panel id="serverbrowser-tabs" class="map-selection-list__quick-selection-sets__btns">
			<Button id="internet" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="Internet (0)" />
			</Button>
			<Button id="favorites" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="Favorites (0)" />
			</Button>
			<Button id="history" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="History (0)" />
			</Button>
			<Button id="spectate" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="Spectate (0)" />
			</Button>
			<Button id="lan" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="LAN (0)" />
			</Button>
			<Button id="friends" class="map-selection__quick-selection-set horizontal-align-left preset-button">
				<Label text="Friends (0)" />
			</Button>
		</Panel>
		<Label text="Actions" class="map-selection__quick-selection-set-title" />
		<Panel id="serverbrowser-actions" class="map-selection-list__quick-selection-sets__btns">
			<Button id="EditFilters" class="map-selection__quick-selection-set-icon save preset-button">
				<Image texturewidth="24" textureheight="24" src="file://{images}/icons/ui/edit.svg"/>
				<Label text="Edit Filters"/>
			</Button>

			<Button id="OpenOldBrowser" class="map-selection__quick-selection-set-icon save preset-button">
				<Image texturewidth="24" textureheight="24" src="file://{images}/icons/ui/link.svg"/>
				<Label text="Open Old Browser"/>
			</Button>
		</Panel>
	</Panel>
</root>`

const MAIN_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/mainmenu.css" />
		<include src="file://{resources}/styles/mainmenu_play.css" />
		<include src="file://{resources}/styles/matchinfo.css" />
		<include src="file://{resources}/styles/matchinfo_scoreboard.css" />
		<include src="file://{resources}/styles/context_menus/context_menu_base.css" />
	</styles>
	<snippets>
		<snippet name="serverbrowser_server">
			<Panel class="left-right-flow full-width sb-row evenrow" style="margin: 0 0 3px;padding: 4px 0;">
				<Panel style="width:25px;margin-left: 6px;">
					<Image id="password" src="file://{images}/icons/ui/locked.svg" texturewidth="20px" scaling="none" />
				</Panel>
				<Panel style="width:25px;margin-left: 4px;">
					<Image id="vac" src="${IMG_BASE}/vac.svg" texturewidth="20px" scaling="none" />
				</Panel>
				<Label id="name" style="width: 1100px;margin-left: 4px;text-overflow:ellipsis;white-space:nowrap;" />
				<Label id="players" style="width:100px;" />
				<Label id="map" style="width:150px;text-overflow:ellipsis;white-space:nowrap;"/>
				<Label id="ping" style="width:100px;"/>
			</Panel>
		</snippet>
	</snippets>
	<Panel class="top-bottom-flow full-width full-height" style="margin:0px;padding:0px;margin-top:0px;">
		<Panel class="left-right-flow full-width sb-row no-hover oddrow" style="padding-top:5px;padding-bottom:5px;margin-right:2px;">
			<TooltipPanel id="password" style="width:25px;margin-left: 6px;" tooltip="Server requires password">
				<Image src="file://{images}/icons/ui/locked.svg" texturewidth="20px" scaling="none" />
			</TooltipPanel>
			<TooltipPanel id="vac" style="width:25px;margin-left: 4px;" tooltip="Server has Valve Anti-Cheat (VAC) enabled">
				<Image src="${IMG_BASE}/vac.svg" texturewidth="20px" scaling="none"/>
			</TooltipPanel>
			<Panel class="left-right-flow round-selection-button" style="width:1100px;margin-left: 4px;">
				<Label id="head-name" class="fontWeight-Bold" text="Name"/>
				<Image id="sort-name" src="file://{images}/icons/ui/expand.svg" texturewidth="16px" scaling="none" style="margin-left:4px;"/>
			</Panel>
			<Panel class="left-right-flow round-selection-button" style="width:100px;">
				<Label id="head-players" class="fontWeight-Bold" text="Players"/>
				<Image id="sort-players" src="file://{images}/icons/ui/expand.svg" texturewidth="16px" scaling="none" style="margin-left:4px;" />
			</Panel>
			<Panel class="left-right-flow round-selection-button" style="width:150px;">
				<Label id="head-map" class="fontWeight-Bold" text="Map"/>
				<Image id="sort-map" src="file://{images}/icons/ui/expand.svg" texturewidth="16px" scaling="none" style="margin-left:4px;" />
			</Panel>
			<Panel class="left-right-flow round-selection-button" style="width:100px;">
				<Label id="head-ping" class="fontWeight-Bold" text="Ping"/>
				<Image id="sort-ping" src="file://{images}/icons/ui/expand.svg" texturewidth="16px" scaling="none" style="margin-left:4px;" />
			</Panel>
		</Panel>
		<Panel id="serverbrowser-servers-internet" class="top-bottom-flow full-width vscroll">
		</Panel>
		<Panel id="serverbrowser-servers-favorites" class="top-bottom-flow full-width vscroll">
		</Panel>
		<Panel id="serverbrowser-servers-history" class="top-bottom-flow full-width vscroll">
		</Panel>
		<Panel id="serverbrowser-servers-spectate" class="top-bottom-flow full-width vscroll">
		</Panel>
		<Panel id="serverbrowser-servers-lan" class="top-bottom-flow full-width vscroll">
		</Panel>
		<Panel id="serverbrowser-servers-friends" class="top-bottom-flow full-width vscroll">
		</Panel>
	</Panel>
</root>`

const BTNS_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/mainmenu.css" />
		<include src="file://{resources}/styles/mainmenu_play.css" />
		<include src="file://{resources}/styles/stats/playerstats.css" />
	</styles>
	<Panel class="left-right-flow">
		<Button id="QuickRefresh" class="content-navbar__manage-btn" style="height:46px;margin-right:12px;">
			<Label id="QuickRefreshText" text="QUICK REFRESH"/>
		</Button>
		<Button id="Refresh" class="content-navbar__manage-btn" style="height:46px;margin-right:12px;">
			<Panel id="RefreshSpinner" style="margin-right: 14px;" class="Spinner"/>
			<Label id="RefreshText" text="STOP REFRESH"/>
		</Button>
		<Button id="Connect" class="content-navbar__manage-btn" style="height:46px;">
			<Label id="ConnectText" text="CONNECT"/>
		</Button>
	</Panel>
</root>`

const TAGS_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/mainmenu.css" />
		<include src="file://{resources}/styles/mainmenu_play.css" />
	</styles>
	<Panel class="left-right-flow content-navbar__tabs" style="width: 100%;">
		<TextEntry id="TagFilter" class="workshop-search-textentry" placeholder="Search for tags" />
		<Panel id="FocusStealer" acceptsfocus="true"/>
	</Panel>
</root>`

const FWFH_LAYOUT = `<root>
	<styles>
	</styles>
	<Panel style="position: 0px 0px 0px;width:100%;height:100%;">
		<Button id="FWFHButton" style="width:100%;height:100%;"/>
	</Panel>
</root>`

const POPUP_FILTERS_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/gamestyles.css" />
		<include src="file://{resources}/styles/popups/popups_shared.css" />
		<include src="file://{resources}/styles/popups/popup_play_gamemodeflags.css" />
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/settings/settings.css" />
		<include src="file://{resources}/styles/settings/settings_slider.css" />
	</styles>

	<script>
		const filterSchema = {
			notFull: ['ServerNotFull', 'check'],
			notEmpty: ['ServerNotEmpty', 'check'],
			notPasswordProtected: ['NotPasswordProtected', 'check'],
			latency: ['Latency', 'drop'],
			location: ['Location', 'drop'],
			anticheat: ['AntiCheat', 'drop'],
			map: ['Map', 'text']
		}

		function _Return(bProceed) {
			const cpnl = $.GetContextPanel()
			let callbackHandle = cpnl.GetAttributeInt('callback', -1);
			let cancelCallbackHandle = cpnl.GetAttributeInt('cancelcallback', -1);
			let callback = bProceed ? callbackHandle : cancelCallbackHandle;
			if (callbackHandle !== -1) {
				let options = {}
				for (let k in filterSchema) {
					const [id, type] = filterSchema[k]
					const el = cpnl.FindChildTraverse(id)
					let v
					switch (type) {
						case 'check':
							v = el.IsSelected()
							break;
						case 'drop':
							v = el.GetSelected().id
							break;
						case 'text':
							v = el.text
							break;
					}
					options[k] = v
				}
				UiToolkitAPI.InvokeJSCallback(callback, options);
			}

			if ( callbackHandle !== -1 )
				UiToolkitAPI.UnregisterJSCallback(callbackHandle);
			if ( cancelCallbackHandle !== -1 )
				UiToolkitAPI.UnregisterJSCallback(cancelCallbackHandle);

			$.DispatchEvent('UIPopupButtonClicked', '');
		}
		function SetupPopup() {
			const cpnl = $.GetContextPanel()
			for (let k in filterSchema) {
				const [id, type] = filterSchema[k]
				const el = cpnl.FindChildTraverse(id)
				const attrStr = cpnl.GetAttributeString(k, '')
				if (attrStr !== '') {
					switch (type) {
						case 'check':
							el.SetSelected(attrStr[0] === 't')
							break;
						case 'drop':
							el.SetSelected(attrStr)
							break;
						case 'text':
							el.text = attrStr
							break;
					}
				}
			}
			
		}
		function CancelPopup() {
			_Return(false);
		}
		function OnOKPressed() {
			_Return(true);
		}
	</script>

	<PopupCustomLayout class="PopupPanel" popupbackground="dim" onload="SetupPopup()" oncancel="CancelPopup()">
		<Label class="PopupTitle" text="Edit Filters" />

		<Panel class="radio-options-container">
			<Panel style="horizontal-align: left; margin-bottom: 10px;">
				<ToggleButton id="ServerNotFull" class="PopupButton Row" >
					<Label id="" text="Server not full" />
				</ToggleButton>
			</Panel>
			<Panel style="horizontal-align: left; margin-bottom: 10px;">
				<ToggleButton id="ServerNotEmpty" class="PopupButton Row" >
					<Label id="" text="Has users playing" />
				</ToggleButton>
			</Panel>
			<Panel style="horizontal-align: left; margin-bottom: 10px;">
				<ToggleButton id="NotPasswordProtected" class="PopupButton Row" >
					<Label text="Is not password protected" />
				</ToggleButton>
			</Panel>
			<Panel class="PopupButton Row" style="horizontal-align: left; margin-bottom: 10px;">
				<Label text="Latency"/>
				<DropDown class="PopupButton" id="Latency" menuclass="DropDownMenu Width-300">
					<Label text="&lt; All &gt;" id="LatencyAll" value="0"/>
					<Label text="&lt; 50" id="Latency50" value="50"/>
					<Label text="&lt; 100" id="Latency100" value="100"/>
					<Label text="&lt; 150" id="Latency150" value="150"/>
					<Label text="&lt; 250" id="Latency250" value="250"/>
					<Label text="&lt; 350" id="Latency350" value="350"/>
					<Label text="&lt; 600" id="Latency600" value="600"/>
				</DropDown>
			</Panel>
			<Panel class="PopupButton Row" style="horizontal-align: left; margin-bottom: 10px;">
				<Label text="Location"/>
				<DropDown class="PopupButton" id="Location" menuclass="DropDownMenu Width-300">
					<Label text="&lt; All &gt;" id="LocationAll" value="0"/>
					<Label text="US - East" id="LocationUSE" value="1"/>
					<Label text="US - West" id="LocationUSW" value="2"/>
					<Label text="South America" id="LocationSA" value="3"/>
					<Label text="Europe" id="LocationEU" value="4"/>
					<Label text="Asia" id="LocationAS" value="5"/>
					<Label text="Australia" id="LocationAU" value="6"/>
					<Label text="Middle East" id="LocationME" value="7"/>
					<Label text="Africa" id="LocationAF" value="8"/>
				</DropDown>
			</Panel>
			<Panel class="PopupButton Row" style="horizontal-align: left; margin-bottom: 10px;">
				<Label text="Anti cheat"/>
				<DropDown class="PopupButton" id="AntiCheat" menuclass="DropDownMenu Width-300">
					<Label text="&lt; All &gt;" id="AntiCheatAll" value="0"/>
					<Label text="Secure" id="AntiCheatSecure" value="1"/>
					<Label text="Not secure" id="AntiCheatInsecure" value="2"/>
				</DropDown>
			</Panel>
			<Panel class="PopupButton Row" style="horizontal-align: left; margin-bottom: 10px;">
				<Label text="Map"/>
				<TextEntry class="PopupButton" maxchars="32" id="Map" style="width: 300px;" />
			</Panel>
		</Panel>

		<Panel class="PopupButtonRow">
			<TextButton class="PopupButton" text="#OK" onactivate="OnOKPressed()" />
			<TextButton class="PopupButton" text="#Cancel_Button" onactivate="CancelPopup()" />
		</Panel>
	</PopupCustomLayout>
</root>`

const POPUP_SERVER_LAYOUT = `<root>
	<styles>
		<include src="file://{resources}/styles/gamestyles.css" />
		<include src="file://{resources}/styles/popups/popups_shared.css" />
		<include src="file://{resources}/styles/popups/popup_play_gamemodeflags.css" />
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/settings/settings.css" />
		<include src="file://{resources}/styles/settings/settings_slider.css" />
	</styles>
	<scripts>
		<include src="file://{resources}/scripts/common/formattext.js" />
	</scripts>

	<script>
		let server = {}
		let dataCallback = -1
		function InvokeCallback(...args) {
			let callback = $.GetContextPanel().GetAttributeInt('callback', -1)
			if (callback !== -1) {
				UiToolkitAPI.InvokeJSCallback(callback, ...args);
			}
			return callback;
		}
		function _Return(szType) {
			let callback = InvokeCallback(szType);
			if (callback !== -1) {
				UiToolkitAPI.UnregisterJSCallback(callback);
			}
			UiToolkitAPI.UnregisterJSCallback(dataCallback);

			UiToolkitAPI.HideTextTooltip();
			$.DispatchEvent('UIPopupButtonClicked', '');
		}

		function _ClearPlayerList() {
			$.GetContextPanel().FindChildTraverse('PlayerList').Children().forEach(ch => {
				ch.DeleteAsync(0.0);
			})
		}
		function _PlayerAdded(ply) {
			let el = $.CreatePanel(
				'Panel',
				$.GetContextPanel().FindChildTraverse('PlayerList'),
				''
			);
			el.BLoadLayoutSnippet('serverbrowser_player')
			el.FindChildTraverse('Name').text = ply.name
			el.FindChildTraverse('Score').text = ply.score
			el.FindChildTraverse('Time').text = FormatText.SecondsToSignificantTimeString(ply.timePlayed)
		}

		function _UpdateData(type, data) {
			switch (type) {
				case 'clearPlayerList':
					_ClearPlayerList();
					break
				case 'playerAdded':
					_PlayerAdded(data);
					break;
				case 'playerRefreshStatus':
					break;
			}
		}
		function SetupPopup() {
			let parameters = [
				'appId',
				'botPlayers',
				'doNotRefresh',
				'gameDesc',
				'gameDir',
				'gameTags',
				'i',
				'ip',
				'ipPort',
				'map',
				'maxPlayers',
				'password',
				'ping',
				'players',
				'port',
				'queryPort',
				'secure',
				'serverName',
				'serverVersion',
				'successful',
				'timeLastPlayed',
				'type',
			];
			for (let p of parameters) {
				server[p] = $.GetContextPanel().GetAttributeString(p, '?')
			}
			dataCallback = UiToolkitAPI.RegisterJSCallback(_UpdateData);
			_UpdateWithServer(server)
			InvokeCallback('players', dataCallback)
		}
		function _UpdateWithServer(server) {
			$.GetContextPanel().SetDialogVariable('name', server.serverName)
			$.GetContextPanel().SetDialogVariable('game', server.gameDesc)
			$.GetContextPanel().SetDialogVariable('map', server.map)
			$.GetContextPanel().SetDialogVariable('players', server.players + ' / ' + server.maxPlayers)
			$.GetContextPanel().SetDialogVariable('vac', server.secure === 'true' ? 'Secure' : 'Not secure')
			$.GetContextPanel().SetDialogVariable('ping', server.ping)
		}
		function CancelPopup() {
			_Return(false);
		}
		function OnCopyPressed() {
			SteamOverlayAPI.CopyTextToClipboard(server.ipPort)
			UiToolkitAPI.HideTextTooltip();
			UiToolkitAPI.ShowTextTooltipOnPanel($.GetContextPanel().FindChildTraverse('CopyButton'), 'Copied to clipboard');
		}
		function OnConnectPressed() {
			_Return('connect')
		}
	</script>
	
	<snippets>
		<snippet name="serverbrowser_player">
			<Panel class="left-right-flow full-width">
				<Label id="Name" text="?" style="width:235px;"/>
				<Label id="Score" text="?" style="width:70px;"/>
				<Label id="Time" text="?" style="width:200px;"/>
			</Panel>
		</snippet>
	</snippets>

	<PopupCustomLayout class="PopupPanel" popupbackground="dim" onload="SetupPopup()" oncancel="CancelPopup()">
		<Label class="PopupTitle" text="{s:name}" />

		<Panel class="left-right-flow" style="margin: 16px;width: 100%;">
			<Panel class="top-bottom-flow" style="width:35%;">
				<Label class="fontWeight-Bold text-align-right" text="Game" />
				<Label class="fontWeight-Bold text-align-right" text="Map" />
				<Label class="fontWeight-Bold text-align-right" text="Players" />
				<Label class="fontWeight-Bold text-align-right" text="Valve Anti-Cheat" />
				<Label class="fontWeight-Bold text-align-right" text="Latency" />
			</Panel>
			<Panel class="top-bottom-flow" style="horizontal-align: left;width:65%;">
				<Label text="{s:game}" />
				<Label text="{s:map}" />
				<Label text="{s:players}" />
				<Label text="{s:vac}" />
				<Label text="{s:ping}" />
			</Panel>
		</Panel>
		
		<Panel class="radio-options-container" style="margin-right: 16px;">
			<Panel class="left-right-flow full-width">
				<Label id="head-name" class="fontWeight-Bold" text="Player name" style="width:235px;"/>
				<Label id="head-score" class="fontWeight-Bold" text="Score" style="width:70px;"/>
				<Label id="head-time" class="fontWeight-Bold" text="Time" style="width:200px;"/>
			</Panel>
			<Panel id="PlayerList" class="top-bottom-flow full-width vscroll" style="max-height: 400px;">

			</Panel>
			
		</Panel>

		<Panel class="PopupButtonRow">
			<TextButton class="PopupButton" text="#GameUI_Close" onactivate="CancelPopup()" />
			<TextButton id="CopyButton" class="PopupButton" text="Copy IP" onactivate="OnCopyPressed()" onmouseout="UiToolkitAPI.HideTextTooltip()" />
			<TextButton class="PopupButton positiveColor" text="Connect" onactivate="OnConnectPressed()" style="border: 1px solid rgba(191, 191, 191, 0.3);" />
		</Panel>
	</PopupCustomLayout>
</root>`

const destroyAllPanels = (ch) => ch.DeleteAsync(0)
const hideAllPanels = (ch) => (ch.visible = false)
const hidePanels =
	(others = false) =>
	(ch) => {
		let ourPanel = (ch.id || '').startsWith('serverbrowser-')
		ch.visible = others ? ourPanel : !ourPanel
	}

const latencyIdToThreshold = (lat) => {
	let num = parseInt(lat.substring(7)) // 7 = 'Latency'.length
	if (!isNaN(num)) {
		return num
	}
	return 999999999999
}

const Types = {
	0: 'Internet',
	1: 'Favorites',
	2: 'History',
	3: 'Spectate',
	4: 'Lan',
	5: 'Friends',
	internet: 0,
	favorites: 1,
	history: 2,
	spectate: 3,
	lan: 4,
	friends: 5,
}

const hooks = []

hooks.new = (obj, name, callback) => {
	let hook = {
		destroyed: false,
		obj,
		name,
		original: obj[name],
		destroy() {
			if (this.destroyed) return true
			obj[name] = this.original
			this.destroyed = true
			return this.destroyed
		},
	}
	hook.original = obj[name]

	obj[name] = function () {
		// just in case theres a reference stored somewhere to this function
		if (hook.destroyed) return hook.original.apply(this, arguments)
		let thiz = this
		return callback.apply(
			{ hook, this: thiz, orig: hook.original.bind(thiz) },
			arguments
		)
	}

	hooks.push(hook)
	return hook
}

hooks.destroy = () => {
	hooks.forEach((hook) => !hook.destroyed && hook.destroy())
	return true
}

const ipToString = (num) =>
	[
		(num >> (8 * 3)) & 0xff,
		(num >> (8 * 2)) & 0xff,
		(num >> (8 * 1)) & 0xff,
		(num >> (8 * 0)) & 0xff,
	].join('.')

const Lua = {
	Events: {
		Refresh: 'ServerBrowser_Refresh',
		StopRefresh: 'ServerBrowser_StopRefresh',
		QuickRefresh: 'ServerBrowser_QuickRefresh',
		Connect: 'ServerBrowser_Connect',
		ConnectWithPassword: 'ServerBrowser_ConnectWithPassword',
		RequestFilters: 'ServerBrowser_RequestFilters',
		SaveFilters: 'ServerBrowser_SaveFilters',
		UpdateTagFilter: 'ServerBrowser_UpdateTagFilter',
		AddToFavorites: 'ServerBrowser_AddToFavorites',
		RemoveFromFavorites: 'ServerBrowser_RemoveFromFavorites',
		AddToHistory: 'ServerBrowser_AddToHistory',
		RemoveFromHistory: 'ServerBrowser_RemoveFromHistory',
		RequestPlayerList: 'ServerBrowser_RequestPlayerList',
	},
	init() {
		$.DefineEvent(Lua.Events.Refresh, 1, '', '')
		$.DefineEvent(Lua.Events.StopRefresh, 1, '', '')
		$.DefineEvent(Lua.Events.QuickRefresh, 2, '', '')
		$.DefineEvent(Lua.Events.Connect, 2, '', '')
		$.DefineEvent(Lua.Events.ConnectWithPassword, 3, '', '')
		$.DefineEvent(Lua.Events.RequestFilters, 1, '', '')
		$.DefineEvent(Lua.Events.SaveFilters, 2, '', '')
		$.DefineEvent(Lua.Events.UpdateTagFilter, 2, '', '')
		$.DefineEvent(Lua.Events.AddToFavorites, 4, '', '')
		$.DefineEvent(Lua.Events.RemoveFromFavorites, 4, '', '')
		$.DefineEvent(Lua.Events.AddToHistory, 4, '', '')
		$.DefineEvent(Lua.Events.RemoveFromHistory, 4, '', '')
		$.DefineEvent(Lua.Events.RequestPlayerList, 3, '', '')
	},
	refresh(type) {
		$.DispatchEvent(Lua.Events.Refresh, type)
	},
	stopRefresh(type) {
		$.DispatchEvent(Lua.Events.StopRefresh, type)
	},
	quickRefresh(type, server) {
		$.DispatchEvent(Lua.Events.QuickRefresh, type, server)
	},
	connect(ip, port) {
		$.DispatchEvent(Lua.Events.Connect, ip, port)
	},
	connectWithPassword(ip, port, password) {
		$.DispatchEvent(Lua.Events.ConnectWithPassword, ip, port, password)
	},
	requestFilters(type) {
		$.DispatchEvent(Lua.Events.RequestFilters, type)
	},
	saveFilters(type, filters) {
		$.DispatchEvent(Lua.Events.SaveFilters, type, JSON.stringify(filters))
	},
	updateTagFilter(type, tags) {
		$.DispatchEvent(Lua.Events.UpdateTagFilter, type, tags)
	},
	addToFavorites(appId, ip, port, queryPort) {
		$.DispatchEvent(Lua.Events.AddToFavorites, appId, ip, port, queryPort)
	},
	removeFromFavorites(appId, ip, port, queryPort) {
		$.DispatchEvent(Lua.Events.RemoveFromFavorites, appId, ip, port, queryPort)
	},
	addToHistory(appId, ip, port, queryPort) {
		$.DispatchEvent(Lua.Events.AddToHistory, appId, ip, port, queryPort)
	},
	removeFromHistory(appId, ip, port, queryPort) {
		$.DispatchEvent(Lua.Events.RemoveFromHistory, appId, ip, port, queryPort)
	},
	requestPlayerList(uid, ip, port) {
		$.DispatchEvent(Lua.Events.RequestPlayerList, uid, ip, port)
	},
}

const browser = {
	initialized: false,
	isOpen: false,

	tabs: ['internet', 'favorites', 'history', 'spectate', 'lan', 'friends'],
	selectedTab: 'internet',
	selectedType: 0,

	panelMain: null,
	panelSide: null,
	panelBtns: null,
	panelTags: null,
	panelFWFH: null,
	panelMainId: 'serverbrowser-main',
	panelSideId: 'serverbrowser-side',
	panelBtnsId: 'serverbrowser-btns',
	panelTagsId: 'serverbrowser-tags',
	panelFWFHId: 'serverbrowser-fwfh',
	panelIds: [
		'serverbrowser-main',
		'serverbrowser-side',
		'serverbrowser-btns',
		'serverbrowser-tags',
		'serverbrowser-fwfh',
	],
	playTopNavDropdown: null,
	doneWithFrame: true,

	panelServerLists: [],
	refreshing: [false, false, false, false, false, false],
	// prettier-ignore
	serverLists: [ [], [], [], [], [], [] ],
	filters: [{}, {}, {}, {}, {}, {}],
	selectedServer: ['', '', '', '', '', ''],

	playerCallbacks: {},

	lastSelectedItem: '',

	urlEncode(obj) {
		return Object.entries(obj)
			.map((i) => i.map(encodeURIComponent).join('='))
			.join('&')
	},

	// init/destroy
	fetchDependencyPanels() {
		let contextPanel = $.GetContextPanel()
		this.panelIds.forEach((panelId) => {
			let panel = contextPanel.FindChildTraverse(panelId)
			if (panel) panel.DeleteAsync(0)
		})

		this.JsQuickSelectParent = contextPanel.FindChildTraverse(
			'JsQuickSelectParent'
		)
		this.MapSelectionList = contextPanel.FindChildTraverse('MapSelectionList')
		if (!this.JsQuickSelectParent || !this.MapSelectionList) return false

		this.playTopNavDropdown =
			contextPanel.FindChildTraverse('PlayTopNavDropdown')
		if (!this.playTopNavDropdown) return false

		// settings-container content-navbar__tabs--small
		this.settingsContainer = contextPanel
			.FindChildTraverse('JsDirectChallengeBtn')
			.GetParent()
			.GetParent()
		if (!this.settingsContainer) return false

		this.workshopSearchBar = contextPanel.FindChildTraverse('WorkshopSearchBar')
		if (!this.workshopSearchBar) return false

		// apparently there are 3 different elements with id "GameModeSelectionRadios"
		this.gameModeSelectionRadios = this.workshopSearchBar
			.GetParent()
			.FindChild('GameModeSelectionRadios')
		if (!this.gameModeSelectionRadios) return false

		this.btnContainer = $.GetContextPanel()
			.FindChildTraverse('StartMatchBtn')
			.GetParent()
		if (!this.btnContainer) return false

		this.tagsContainer = this.workshopSearchBar.GetParent()
		if (!this.tagsContainer) return false

		return true
	},
	createPanelMain() {
		let parent = this.MapSelectionList.GetParent()
		this.panelMain = $.CreatePanel('Panel', parent, this.panelMainId)
		this.panelMain.BLoadLayoutFromString(MAIN_LAYOUT, false, false)
		this.panelMain.enabled = true
		this.panelMain.visible = false

		parent.MoveChildBefore(
			this.panelMain,
			parent.GetChild(0) /* MapSelectionList */
		)

		this.panelMain
			.FindChildTraverse('head-name')
			.SetPanelEvent('onactivate', () => this.nameHeaderPressed())
		this.panelMain
			.FindChildTraverse('head-players')
			.SetPanelEvent('onactivate', () => this.playersHeaderPressed())
		this.panelMain
			.FindChildTraverse('head-map')
			.SetPanelEvent('onactivate', () => this.mapHeaderPressed())
		this.panelMain
			.FindChildTraverse('head-ping')
			.SetPanelEvent('onactivate', () => this.pingHeaderPressed())

		this.panelServerLists.push(
			this.panelMain.FindChildTraverse('serverbrowser-servers-internet'),
			this.panelMain.FindChildTraverse('serverbrowser-servers-favorites'),
			this.panelMain.FindChildTraverse('serverbrowser-servers-history'),
			this.panelMain.FindChildTraverse('serverbrowser-servers-spectate'),
			this.panelMain.FindChildTraverse('serverbrowser-servers-lan'),
			this.panelMain.FindChildTraverse('serverbrowser-servers-friends')
		)
		this.panelServerLists.forEach(hideAllPanels)
	},
	createPanelSide() {
		let parent = this.JsQuickSelectParent.GetParent()
		this.panelSide = $.CreatePanel('Panel', parent, this.panelSideId)
		this.panelSide.BLoadLayoutFromString(SIDE_LAYOUT, false, false)
		this.panelSide.enabled = true
		this.panelSide.visible = false

		parent.MoveChildBefore(
			this.panelSide,
			parent.GetChild(0) /* JsQuickSelectParent */
		)

		this.panelSide
			.FindChildTraverse('serverbrowser-tabs')
			.Children()
			.forEach((ch) => {
				ch.SetPanelEvent('onactivate', () => this.selectTab(ch.id))
			})

		this.btnEditFilters = this.panelSide.FindChildTraverse('EditFilters')
		this.btnEditFilters.SetPanelEvent('onactivate', () =>
			this.editFiltersPressed()
		)
		this.btnOpenOldBrowser = this.panelSide.FindChildTraverse('OpenOldBrowser')
		this.btnOpenOldBrowser.SetPanelEvent('onactivate', () =>
			this.openOldBrowserPressed()
		)
	},
	createPanelBtns() {
		this.panelBtns = $.CreatePanel('Panel', this.btnContainer, this.panelBtnsId)
		this.panelBtns.BLoadLayoutFromString(BTNS_LAYOUT, false, false)
		this.panelBtns.enabled = true
		this.panelBtns.visible = false
		this.btnQuickRefresh = this.panelBtns.FindChild('QuickRefresh')
		this.btnRefresh = this.panelBtns.FindChild('Refresh')
		this.btnConnect = this.panelBtns.FindChild('Connect')

		this.btnQuickRefresh.SetPanelEvent('onactivate', () =>
			this.quickRefreshPressed()
		)
		this.btnRefresh.SetPanelEvent('onactivate', () => this.refreshPressed())
		this.btnConnect.SetPanelEvent('onactivate', () => this.connectPressed())
	},
	createPanelTags() {
		let parent = this.tagsContainer
		this.panelTags = $.CreatePanel('Panel', parent, this.panelTagsId)
		this.panelTags.BLoadLayoutFromString(TAGS_LAYOUT, false, false)
		this.panelTags.enabled = true
		this.panelTags.visible = false

		parent.MoveChildBefore(this.panelTags, parent.GetChild(0) /* front of el */)

		this.txtTags = this.panelTags.FindChildTraverse('TagFilter')
		this.txtTags.SetPanelEvent('ontextentrychange', () =>
			this.tagsFilterUpdated()
		)
		this.txtTags.SetPanelEvent('onfocus', () => this.tagsFilterFocus())

		// Fuck Valve
		this.tagsFocusStealer = this.panelTags.FindChildTraverse('FocusStealer')
	},
	createPanelFWFH() {
		this.panelFWFH = $.CreatePanel(
			'Panel',
			$.GetContextPanel(),
			this.panelFWFHId
		)
		this.panelFWFH.BLoadLayoutFromString(FWFH_LAYOUT, false, false)
		this.panelFWFH.enabled = true
		this.panelFWFH.visible = false

		this.btnFWFH = this.panelFWFH.FindChildTraverse('FWFHButton')
		this.btnFWFH.SetPanelEvent('onactivate', () => this.clickOutTriggered())
	},

	init() {
		if (this.initialized) return true

		if (!this.fetchDependencyPanels()) return false

		this.createPanelMain()
		this.createPanelSide()
		this.createPanelBtns()
		this.createPanelTags()
		this.createPanelFWFH()

		// calling SetSelected will trigger oninputsubmit
		// since you cant hook event listeners in panorama js, the only way to change the dropdown is using SetSelected(Index)
		// every time the item is community in oninputsubmit handler in mainmenu_play it will call the openserverbrowser concmd
		// opening our panel, and settingg PlayCommunity to the item and our game will crash

		hooks.new(
			this.playTopNavDropdown,
			'GetSelected',
			function (bypass = false) {
				let selected = this.orig()
				if (!bypass) {
					browser.lastSelectedItem = selected.id
					if (selected.id === 'PlayCommunity') {
						browser.doneWithFrame = false
					}
				}
				return selected
			}
		)
		hooks.new(this.playTopNavDropdown, 'SetSelected', function (item) {
			if (!browser.doneWithFrame) {
				item = 'PlayCommunity'
			}
			return this.orig(item)
		})

		// "on**user**inputsubmit" my ass
		this.playTopNavDropdown.SetPanelEvent('onuserinputsubmit', () => {
			let selectedId = this.playTopNavDropdown.GetSelected(true).id
			this.lastSelectedItem = selectedId
			this.doneWithFrame = true
			if (selectedId === 'PlayCommunity') {
				this.open()
			} else {
				this.close()
			}
		})

		this.updateHeaders()
		this.initialized = true
		return true
	},
	destroy() {
		this.close()
		this.initialized = false
		if (this.playTopNavDropdown) {
			this.playTopNavDropdown.ClearPanelEvent('onuserinputsubmit')
			this.playTopNavDropdown.SetSelected('Play-official')
		}
		if (this.panelMain) this.panelMain.DeleteAsync(0)
		if (this.panelSide) this.panelSide.DeleteAsync(0)
		if (this.panelBtns) this.panelBtns.DeleteAsync(0)
		if (this.panelTags) this.panelTags.DeleteAsync(0)
		if (this.panelFWFH) this.panelFWFH.DeleteAsync(0)
		if (this.hkSetSelected) this.hkSetSelected.destroy()
	},

	// fwfh focus mgr
	clickOutCallback: [],
	clickOutTriggered() {
		let cb
		while ((cb = this.clickOutCallback.shift())) {
			if (typeof cb === 'function') cb()
		}

		this.hideClickOut()
	},
	showClickOut(callback) {
		this.clickOutCallback.push(callback)
		this.panelFWFH.enabled = this.panelFWFH.visible = true
	},
	hideClickOut() {
		if (this.clickOutCallback.length > 0) this.clickOutCallback = []
		this.panelFWFH.enabled = this.panelFWFH.visible = false
	},

	// utility functions
	selectTab(tab) {
		this.selectedTab = tab
		this.selectedType = Types[tab]

		this.panelSide
			.FindChildTraverse('serverbrowser-tabs')
			.Children()
			.forEach((ch) => ch.SetHasClass('match', ch.id == tab))

		this.panelServerLists.forEach((ch, idx) => {
			ch.visible = idx === this.selectedType
		})

		let filter = this.filters[this.selectedType]
		this.txtTags.text = filter && filter.tags ? filter.tags : ''

		this.updateButtonState()
	},
	isRefreshing(type = this.selectedType) {
		return this.refreshing[type]
	},
	getSelectedServer(type = this.selectedType) {
		return this.selectedServer[type]
	},
	getSelectedServerObj(type = this.selectedType) {
		let uid = this.getSelectedServer(type)
		return this.serverLists[type].find((i) => i.uid === uid)
	},
	getSelectedServerEl(type = this.selectedType) {
		let uid = this.getSelectedServer(type)
		return this.panelServerLists[type].FindChildTraverse(`server-${uid}`)
	},
	selectServer(type, uid, el) {
		let oldEl = this.getSelectedServerEl(type)
		if (oldEl) {
			oldEl.RemoveClass('CartTournamentPasses')
			oldEl.AddClass('evenrow')
		}

		el.AddClass('CartTournamentPasses')
		el.RemoveClass('evenrow')
		this.selectedServer[type] = uid
	},
	updateButtonState() {
		// refresh btn
		let refreshing = this.isRefreshing()
		if (refreshing) {
			this.btnRefresh.FindChild('RefreshSpinner').visible = true
			this.btnRefresh.FindChild('RefreshText').text = 'STOP REFRESH'
		} else {
			this.btnRefresh.FindChild('RefreshSpinner').visible = false
			this.btnRefresh.FindChild('RefreshText').text = 'REFRESH ALL'
		}
	},
	getPlayersForServer(server, cb) {
		this.playerCallbacks[server.uid] = {
			callback: cb,
			players: [],
		}
		Lua.requestPlayerList(server.uid, server.ip, server.port)
	},
	viewServerInfo(server) {
		let callback = UiToolkitAPI.RegisterJSCallback((t, dcb) => {
			switch (t) {
				case 'connect':
					this.connectToServer(server)
					break
				case 'players':
					this.getPlayersForServer(server, dcb)
					break
			}
		})

		let parameters = Object.assign({}, { callback }, server)

		let panelPopup = UiToolkitAPI.ShowCustomLayoutPopupParameters(
			'',
			'',
			this.urlEncode(parameters)
		)
		panelPopup.BLoadLayoutFromString(POPUP_SERVER_LAYOUT, false, false)
	},
	connectToServer(server) {
		Lua.connect(server.ip, server.port)
	},
	addServer(type, server, forceCreate = false) {
		let panelServers = this.panelServerLists[type]
		let srv = panelServers.FindChild(`server-${server.uid}`)
		if (!srv || forceCreate) {
			srv = $.CreatePanel('Panel', panelServers, `server-${server.uid}`)

			srv.BLoadLayoutSnippet('serverbrowser_server')

			if (!forceCreate) {
				/*let svs = this.serverLists[type].slice()
				if (svs.length >= 3) {
					svs.sort(sortFn)
					let ourServer = svs.findIndex((s) => s.i === server.i)
					if (ourServer + 1 !== svs.length) {
						panelServers.MoveChildBefore(
							srv,
							panelServers.FindChild(`server-${svs[ourServer + 1].uid}`)
						)
					}
				}*/
				this.resort(type, false)

				this.panelSide
					.FindChildTraverse(Types[type].toLowerCase())
					.Children()[0].text = `${Types[type]} (${this.serverLists[type].length})`
			}
		}
		let isWorkshopMap = server.map.startsWith('workshop/')
		let mapFixed = server.map
		if (isWorkshopMap) {
			mapFixed = server.map.split('/')
			mapFixed = mapFixed[mapFixed.length - 1]
		}
		srv.FindChildTraverse('password').visible = server.password
		srv.FindChildTraverse('vac').visible = server.secure
		srv.FindChildTraverse('name').text = server.serverName
		srv.FindChildTraverse(
			'players'
		).text = `${server.players} / ${server.maxPlayers}`
		srv.FindChildTraverse('map').text = mapFixed
		srv.FindChildTraverse('ping').text = server.ping.toString()
		srv.enabled = true

		let listText = 'Add server to favorites'
		if (type === Types.favorites) {
			listText = 'Remove server from favorites'
		} else if (type === Types.history) {
			listText = 'Remove server from history'
		}

		let filter = this.filters[type]

		let contextMenu = [
			{
				label: 'Connect to server',
				jsCallback: () => {
					this.connectToServer(server)
				},
			},
			{
				label: 'View server info',
				jsCallback: () => {
					this.viewServerInfo(server)
				},
			},
			{
				label: 'Refresh server',
				jsCallback: () => {
					Lua.quickRefresh(type, server.i)
				},
			},
			{
				label: 'Copy IP to clipboard',
				jsCallback: () => {
					SteamOverlayAPI.CopyTextToClipboard(server.ipPort)
					UiToolkitAPI.HideTextTooltip()
					UiToolkitAPI.ShowTextTooltipOnPanel(
						srv.FindChildTraverse('name'),
						'Copied to clipboard'
					)
					$.Schedule(1, () => UiToolkitAPI.HideTextTooltip())
				},
			},
			{
				label: listText,
				jsCallback: () => {
					let fn = Lua.addToFavorites
					if (type === Types.favorites) {
						fn = Lua.removeFromFavorites
					} else if (type === Types.history) {
						fn = Lua.removeFromHistory
					}
					fn(server.appId, server.ip, server.port, server.queryPort)
				},
			},
			{
				label:
					filter.map === server.map
						? 'Remove map filter'
						: `Only show servers on ${
								server.map.length < 12 ? server.map : 'this map'
							}`,
				jsCallback: () => {
					let origFilter = this.filters[type]
					let alreadyFiltered = origFilter.map === server.map
					let filter = Object.assign({}, origFilter, {
						map: alreadyFiltered ? '' : server.map,
					})

					Lua.saveFilters(type, filter)
					$.Schedule(0.1, () => Lua.refresh(type))
				},
			},
		]
		srv.SetPanelEvent('onactivate', () => {
			this.selectServer(type, server.uid, srv)
		})
		srv.SetPanelEvent('ondblclick', () => {
			this.connectToServer(server)
		})
		srv.SetPanelEvent('oncontextmenu', () => {
			this.selectServer(type, server.uid, srv)
			UiToolkitAPI.ShowSimpleContextMenu('', `ServerContextMenu`, contextMenu)
		})
	},

	// sort lol
	sortColumn: '',
	sortDirection: 'asc',
	updateHeaders() {
		let sortName = this.panelMain.FindChildTraverse('sort-name')
		let sortPlayers = this.panelMain.FindChildTraverse('sort-players')
		let sortMap = this.panelMain.FindChildTraverse('sort-map')
		let sortPing = this.panelMain.FindChildTraverse('sort-ping')
		sortName.visible = false
		sortPlayers.visible = false
		sortMap.visible = false
		sortPing.visible = false

		let sortEl

		switch (this.sortColumn) {
			case 'serverName':
				sortEl = sortName
				break
			case 'players':
				sortEl = sortPlayers
				break
			case 'map':
				sortEl = sortMap
				break
			case 'ping':
				sortEl = sortPing
				break
			default:
				sortEl = null
				break
		}
		if (!sortEl) return
		sortEl.visible = true

		sortEl.style.paddingTop = this.sortDirection === 'asc' ? '4px' : '5px'
		sortEl.style.transform =
			this.sortDirection === 'asc' ? 'rotateZ(0deg)' : 'rotateZ(180deg)'
	},
	getSortFunction() {
		if (this.sortColumn === '')
			return () => {
				return 0
			}

		const numericSort = (a, b) => {
			if (this.sortDirection === 'asc') [a, b] = [b, a]
			return a[this.sortColumn] - b[this.sortColumn]
		}
		const stringSort = (a, b) => {
			if (this.sortDirection === 'asc') [a, b] = [b, a]
			let av = a[this.sortColumn],
				bv = b[this.sortColumn]
			if (av < bv) return -1
			if (av > bv) return 1
			return 0
		}

		if (this.sortColumn === 'serverName' || this.sortColumn === 'map')
			return stringSort

		return numericSort
	},
	resort(type = this.selectedType, rerender = true) {
		const sortFn = this.getSortFunction()
		let panelServers = this.panelServerLists[type]
		this.serverLists[type].sort((a, b) => {
			let retval = sortFn(a, b)

			if (!rerender) {
				let elA = panelServers.FindChild(`server-${a.uid}`)
				let elB = panelServers.FindChild(`server-${b.uid}`)
				if (elA && elB && retval !== 0) {
					if (retval < 0) {
						panelServers.MoveChildBefore(elA, elB)
					} else {
						panelServers.MoveChildAfter(elA, elB)
					}
				}
			}
			return retval
		})
		this.updateHeaders()
		if (rerender) this.rerender(type)
	},
	rerender(type = this.selectedType) {
		this.panelServerLists[type].Children().forEach(destroyAllPanels)
		for (let server of this.serverLists[type]) {
			this.addServer(type, server, true)
		}
	},

	// popup
	editFilters(type = this.selectedType) {
		let callback = UiToolkitAPI.RegisterJSCallback((filters) => {
			Lua.saveFilters(type, filters)
		})

		let parameters = Object.assign({}, { callback }, this.filters[type])

		let panelPopup = UiToolkitAPI.ShowGlobalCustomLayoutPopupParameters(
			'',
			'',
			this.urlEncode(parameters)
		)
		panelPopup.BLoadLayoutFromString(POPUP_FILTERS_LAYOUT, false, false)
	},

	// events
	playCommunityPressed() {
		//this.playTopNavDropdown.SetSelected('PlayCommunity')
		this.open()
	},
	quickRefreshPressed() {
		let srv = this.getSelectedServerObj()
		if (!srv) return
		Lua.quickRefresh(this.selectedType, srv.i)
		this.updateButtonState()
	},
	refreshPressed() {
		let refreshing = this.isRefreshing()
		if (refreshing) {
			Lua.stopRefresh(this.selectedType)
		} else {
			Lua.refresh(this.selectedType)
		}
		this.updateButtonState()
	},
	connectPressed() {
		let srv = this.getSelectedServerObj()
		if (!srv) return
		this.connectToServer(srv)
		this.updateButtonState()
	},
	editFiltersPressed() {
		this.editFilters()
	},
	openOldBrowserPressed() {
		GameInterfaceAPI.ConsoleCommand('gamemenucommand openserverbrowser ')
	},
	tagsFilterUpdated(type = this.selectedType) {
		let tags = $.HTMLEscape(this.txtTags.text, true).toLowerCase()
		Lua.updateTagFilter(type, tags)
	},
	tagsFilterFocus() {
		this.showClickOut(() => {
			this.tagsFocusStealer.SetFocus()
		})
	},

	nameHeaderPressed() {
		this.sortColumn = 'serverName'
		this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'
		this.resort()
	},
	playersHeaderPressed() {
		this.sortColumn = 'players'
		this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'
		this.resort()
	},
	mapHeaderPressed() {
		this.sortColumn = 'map'
		this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'
		this.resort()
	},
	pingHeaderPressed() {
		this.sortColumn = 'ping'
		this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'
		this.resort()
	},

	// visibility
	open() {
		if (!this.initialized) return
		this.MapSelectionList.visible = false
		this.JsQuickSelectParent.visible = false
		this.JsQuickSelectParent.GetParent().AddClass('competitive')
		this.JsQuickSelectParent.GetParent().AddClass('official')

		this.settingsContainer.visible = false
		this.gameModeSelectionRadios.AddClass('hidden')
		this.workshopSearchBar.AddClass('hidden')

		this.panelMain.visible = true
		this.panelSide.visible = true
		this.panelTags.visible = true
		this.btnContainer.Children().forEach(hidePanels(true))

		this.selectTab(this.selectedTab)

		this.isOpen = true
	},
	close() {
		if (!this.initialized) return
		this.MapSelectionList.visible = true
		this.JsQuickSelectParent.visible = true
		this.JsQuickSelectParent.GetParent().RemoveClass('competitive')
		this.JsQuickSelectParent.GetParent().RemoveClass('official')

		this.settingsContainer.visible = true
		this.gameModeSelectionRadios.RemoveClass('hidden')
		this.workshopSearchBar.RemoveClass('hidden')

		this.panelMain.visible = this.panelSide.visible = false
		this.panelTags.visible = this.panelBtns.visible = false
		this.btnContainer.Children().forEach(hidePanels(false))

		this.isOpen = false
	},

	// Lua -> JS bridge funcs
	_clearServerList(type) {
		this.panelSide
			.FindChildTraverse(Types[type].toLowerCase())
			.Children()[0].text = `${Types[type]} (0)`
		this.selectedServer[type] = ''
		this.serverLists[type] = []
		this.panelServerLists[type].Children().forEach(destroyAllPanels)
	},
	_setRefreshing(type, refreshing) {
		this.refreshing[type] = refreshing
		if (!refreshing) {
			this.resort(type)
		}
		this.updateButtonState()
	},
	_addServer(type, server) {
		if (this.filters[type]) {
			let flt = this.filters[type]
			if (flt.anticheat === 'AntiCheatInsecure' && server.secure) return
			if (flt.latency) {
				let lat = latencyIdToThreshold(flt.latency)
				if (server.ping > lat) return
			}
		}
		server.uid = `${type}-${server.i}`
		server.ipPort = ipToString(server.ip)
		if (server.port !== 27015) {
			server.ipPort += ':'
			server.ipPort += server.port
		}
		if (!this.serverLists[type].find((i) => i.i == server.i))
			this.serverLists[type].push(server)
		this.addServer(type, server)
	},
	_setFilters(type, filters) {
		this.filters[type] = filters
		if (type === this.selectedType) {
			if (this.txtTags && !this.txtTags.BHasKeyFocus()) {
				this.txtTags.text = filters.tags || ''
			}
		}
	},

	_clearPlayerList(uid) {
		try {
			let obj = this.playerCallbacks[uid]
			if (!obj) return
			UiToolkitAPI.InvokeJSCallback(obj.callback, 'clearPlayerList', {})
		} catch (err) {}
	},
	_playerRefreshStatus(uid, success) {
		try {
			let obj = this.playerCallbacks[uid]
			if (!obj) return
			UiToolkitAPI.InvokeJSCallback(obj.callback, 'playerRefreshStatus', {
				success,
			})
		} catch (err) {}
	},
	_playerAdded(uid, name, score, timePlayed) {
		try {
			let obj = this.playerCallbacks[uid]
			if (!obj) return
			UiToolkitAPI.InvokeJSCallback(obj.callback, 'playerAdded', {
				name,
				score,
				timePlayed,
			})
		} catch (err) {}
	},
}

Lua.init()
browser.init()

hooks.new(GameInterfaceAPI, 'ConsoleCommand', function (cmd) {
	if (
		cmd === 'gamemenucommand openserverbrowser' &&
		!MatchStatsAPI.IsConnectedToCommunityServer()
	) {
		if (!browser.initialized) {
			browser.init()
			browser.open()
		}
		return
	}
	return this.orig(cmd)
})

return {
	shutdown: () => {
		try {
			hooks.destroy()
		} catch (err) {
			$.Msg('Error while destroying hooks: ' + err.toString())
		}
		try {
			browser.destroy()
		} catch (err) {
			$.Msg('Error while destroying browser: ' + err.toString())
		}
		UiToolkitAPI.CloseAllVisiblePopups()
	},
	ClearServerList: (type) => browser._clearServerList(type),
	RefreshStatus: (type, refreshing) => browser._setRefreshing(type, refreshing),
	ServerAdded: (type, server) => browser._addServer(type, server),
	GetFilters: (type, filters) => browser._setFilters(type, filters),
	ClearPlayerList: (uid) => browser._clearPlayerList(uid),
	PlayerRefreshStatus: (uid, success) =>
		browser._playerRefreshStatus(uid, success),
	PlayerAdded: (uid, name, score, timePlayed) =>
		browser._playerAdded(uid, name, score, timePlayed),
}
]], "CSGOMainMenu")()

function slot17(slot0)
	return tonumber(uv0.cast("uintptr_t", slot0))
end

function slot18(slot0, slot1, slot2)
	return {
		type = slot0,
		i = slot1,
		ip = tonumber(slot2.m_NetAdr.m_unIP),
		port = tonumber(slot2.m_NetAdr.m_usConnectionPort),
		queryPort = tonumber(slot2.m_NetAdr.m_usQueryPort),
		ping = tonumber(slot2.m_nPing),
		successful = slot2.m_bHadSuccessfulResponse == true,
		doNotRefresh = slot2.m_bDoNotRefresh == true,
		gameDir = uv0.string(slot2.m_szGameDir),
		map = uv0.string(slot2.m_szMap),
		gameDesc = uv0.string(slot2.m_szGameDescription),
		appId = slot2.m_nAppID,
		players = tonumber(slot2.m_nPlayers),
		maxPlayers = tonumber(slot2.m_nMaxPlayers),
		botPlayers = tonumber(slot2.m_nBotPlayers),
		password = slot2.m_bPassword == true,
		secure = slot2.m_bSecure == true,
		timeLastPlayed = tonumber(slot2.m_ulTimeLastPlayed),
		serverVersion = tonumber(slot2.m_nServerVersion),
		serverName = uv0.string(slot2.m_szServerName),
		gameTags = uv0.string(slot2.m_szGameTags)
	}
end

slot19 = {}

function slot20(slot0)
	for slot4, slot5 in pairs(uv0) do
		if slot5.type == slot0 and not slot5.released then
			return slot5
		end
	end

	return nil
end

slot21 = slot1.ISteamMatchmakingServerListResponse.new({
	ServerResponded = function (slot0, slot1, slot2)
		slot3 = uv0[uv1(slot1)]

		uv4.ServerAdded(slot3.type, uv3(slot3.type, slot2, uv2.GetServerDetails(slot1, slot2)))
	end,
	ServerFailedToRespond = function (slot0, slot1, slot2)
	end,
	RefreshComplete = function (slot0, slot1, slot2)
		slot3 = uv0[uv1(slot1)]

		uv2.RefreshStatus(slot3.type, false)

		slot3.refreshing = false
	end
})

function slot22(slot0)
	if slot0 == "LocationUSE" then
		return "0"
	elseif slot0 == "LocationUSW" then
		return "1"
	elseif slot0 == "LocationSA" then
		return "2"
	elseif slot0 == "LocationEU" then
		return "3"
	elseif slot0 == "LocationAS" then
		return "4"
	elseif slot0 == "LocationAU" then
		return "5"
	elseif slot0 == "LocationME" then
		return "6"
	elseif slot0 == "LocationAF" then
		return "7"
	else
		return "255"
	end
end

function slot23(slot0)
	slot3 = {}
	slot4 = {}
	slot5 = {}
	slot6 = {}
	slot7 = {}
	slot8 = {
		"valve_ds"
	}

	if uv0.filters[slot0 + 1].map then
		table.insert({}, {
			"map",
			slot1.map
		})
	end

	if slot1.notEmpty then
		table.insert(slot2, {
			"empty",
			"1"
		})
	end

	if slot1.notFull then
		table.insert(slot2, {
			"full",
			"1"
		})
	end

	if slot1.anticheat then
		if slot1.anticheat == "AntiCheatSecure" then
			table.insert(slot2, {
				"secure",
				"1"
			})
		elseif slot1.anticheat == "AntiCheatInsecure" then
			table.insert(slot8, "secure")
		end
	end

	if slot1.location and uv1(slot1.location) ~= "255" then
		table.insert(slot2, {
			"region",
			slot9
		})
	end

	if slot1.tags then
		table.insert(slot7, slot1.tags)
	end

	if #slot3 > 0 then
		slot12 = #slot3

		table.insert(slot2, {
			"and",
			slot12
		})

		for slot12 = 1, #slot3 do
			table.insert(slot2, slot3[slot12])
		end
	end

	if #slot4 > 0 then
		slot12 = #slot4

		table.insert(slot2, {
			"or",
			slot12
		})

		for slot12 = 1, #slot4 do
			table.insert(slot2, slot4[slot12])
		end
	end

	if #slot5 > 0 then
		slot12 = #slot5

		table.insert(slot2, {
			"nand",
			slot12
		})

		for slot12 = 1, #slot5 do
			table.insert(slot2, slot5[slot12])
		end
	end

	if #slot6 > 0 then
		slot12 = #slot6

		table.insert(slot2, {
			"nor",
			slot12
		})

		for slot12 = 1, #slot6 do
			table.insert(slot2, slot6[slot12])
		end
	end

	if #slot7 > 0 then
		table.insert(slot2, {
			"gametagsand",
			table.concat(slot7, ",")
		})
	end

	if #slot8 > 0 then
		table.insert(slot2, {
			"gametagsnor",
			table.concat(slot8, ",")
		})
	end

	return #slot2, slot2
end

function slot24(slot0)
	slot1, slot2 = uv0(slot0)
	uv2.new("MatchMakingKeyValuePair_t*[1]")[0] = uv1.MatchMakingKeyValuePair_t_arr(slot1, slot2)
	slot5 = -1

	if slot0 == 0 then
		slot5 = uv3.RequestInternetServerList(uv4, slot4, slot1, uv5)
	elseif slot0 == 1 then
		slot5 = uv3.RequestFavoritesServerList(uv4, slot4, slot1, uv5)
	elseif slot0 == 2 then
		slot5 = uv3.RequestHistoryServerList(uv4, slot4, slot1, uv5)
	elseif slot0 == 3 then
		slot5 = uv3.RequestSpectatorServerList(uv4, slot4, slot1, uv5)
	elseif slot0 == 4 then
		slot5 = uv3.RequestLANServerList(uv4, uv5)
	elseif slot0 == 5 then
		slot5 = uv3.RequestFriendsServerList(uv4, slot4, slot1, uv5)
	else
		return -1
	end

	uv6[uv7(slot5)] = {
		refreshing = true,
		released = false,
		handle = slot5,
		type = slot0
	}

	return uv7(slot5)
end

function slot25(slot0, slot1, slot2)
	slot3 = -1

	uv1.ClearPlayerList(slot0)

	slot3 = uv5.PlayerDetails(slot1, slot2, uv0.ISteamMatchmakingPlayersResponse.new({
		AddPlayerToList = function (slot0, slot1, slot2, slot3)
			uv0.PlayerAdded(uv1, uv2.string(slot1), tonumber(slot2), tonumber(slot3))
		end,
		PlayersFailedToRespond = function (slot0)
			uv0.PlayerRefreshStatus(uv1, false)
		end,
		PlayersRefreshComplete = function (slot0)
			uv0.PlayerRefreshStatus(uv1, true)

			uv2[uv3(uv4)].refreshing = false
		end
	}))
	uv3[uv4(slot3)] = {
		refreshing = true,
		type = -1,
		handle = slot3
	}
end

function slot26(slot0, slot1)
	uv0.RefreshQuery(slot1)

	return slot1
end

function slot27(slot0, slot1, slot2, slot3)
	uv0.AddFavoriteGame(slot0, slot1, slot2, slot3, uv1, 0)
end

function slot28(slot0, slot1, slot2, slot3)
	uv0.RemoveFavoriteGame(slot0, slot1, slot2, slot3, uv1)
end

function slot29(slot0, slot1, slot2, slot3)
	uv0.AddFavoriteGame(0, slot1, slot2, slot3, uv1, 0)
end

function slot30(slot0, slot1, slot2, slot3)
	uv0.RemoveFavoriteGame(0, slot1, slot2, slot3, uv1)
end

function slot31(slot0)
	uv0.ClearServerList(slot0)
	uv0.RefreshStatus(slot0, true)
	uv1(slot0)
end

function slot32(slot0)
	for slot4, slot5 in pairs(uv0) do
		if slot5.type == slot0 and slot5.refreshing then
			return true, slot4
		end
	end

	return false, 0
end

function slot33(slot0)
	for slot4, slot5 in pairs(uv0) do
		if slot5.type == slot0 and slot5.refreshing then
			uv1.CancelQuery(slot5.handle)

			slot5.refreshing = false

			uv2.RefreshStatus(slot5.type, false)

			return true, slot4
		end
	end

	return false, 0
end

function slot34()
	for slot3, slot4 in pairs(uv0) do
		if slot4.refreshing then
			if slot4.type == -1 then
				uv1.CancelServerQuery(slot4.handle)
			else
				uv1.CancelQuery(slot4.handle)
			end

			slot4.refreshing = false

			uv2.RefreshStatus(slot4.type, false)
		end

		if not slot4.released and slot4.type ~= -1 then
			uv1.ReleaseRequest(slot4.handle)

			slot4.released = true
		end
	end
end

function slot36(slot0)
	return table.concat({
		bit.band(bit.rshift(slot0, 24), 255),
		bit.band(bit.rshift(slot0, 16), 255),
		bit.band(bit.rshift(slot0, 8), 255),
		bit.band(bit.rshift(slot0, 0), 255)
	}, ".")
end

function slot37(slot0, slot1)
	uv0:invoke_callback(slot0 .. ":" .. slot1)
end

slot38 = {
	refresh = function (slot0)
		if uv0(slot0) then
			client.error_log("^^ Already refreshing!! ^^")
		else
			if uv1(slot0) then
				if slot2.refreshing then
					uv2.CancelQuery(slot2.handle)

					slot2.refreshing = false
				end

				uv2.ReleaseRequest(slot2.handle)

				slot2.released = true
			end

			uv3(slot0)
		end
	end,
	stopRefresh = function (slot0)
		uv0(slot0)
	end,
	quickRefresh = function (slot0, slot1)
		if uv0(slot0) then
			uv1.RefreshServer(slot2.handle, slot1)
		end
	end,
	connect = function (slot0, slot1)
		slot2 = uv0(slot0)
		slot3 = "27015"

		if type(slot1) == "number" then
			slot3 = tostring(slot1)
		end

		uv1:set_string("")
		uv2(slot2, slot3)
	end,
	connectWithPassword = function (slot0, slot1, slot2)
		slot3 = uv0(slot0)
		slot4 = "27015"

		if type(slot1) == "number" then
			slot4 = tostring(slot1)
		end

		if type(slot2) == "string" then
			uv1:set_string(slot2)
		end

		uv2(slot3, slot4)
	end,
	requestFilters = function (slot0)
		uv0(slot0)
	end,
	saveFilters = function (slot0, slot1)
		if json.parse(slot1) == nil then
			return
		end

		slot2 = ""

		if uv0.filters[slot0 + 1] then
			slot2 = uv0.filters[slot0 + 1].tags
		end

		uv0.filters[slot0 + 1] = slot1
		uv0.filters[slot0 + 1].tags = slot2

		uv1(slot0)
	end,
	updateTagFilter = function (slot0, slot1)
		uv0.filters[slot0 + 1] = uv0.filters[slot0 + 1] or {}
		uv0.filters[slot0 + 1].tags = slot1

		uv1(slot0)
	end,
	addToFavorites = function (slot0, slot1, slot2, slot3)
		uv0(slot0, slot1, slot2, slot3)
	end,
	removeFromFavorites = function (slot0, slot1, slot2, slot3)
		uv0(slot0, slot1, slot2, slot3)
	end,
	addToHistory = function (slot0, slot1, slot2, slot3)
		uv0(slot0, slot1, slot2, slot3)
	end,
	removeFromHistory = function (slot0, slot1, slot2, slot3)
		uv0(slot0, slot1, slot2, slot3)
	end,
	requestPlayerList = function (slot0, slot1, slot2)
		uv0(slot0, slot1, slot2)
	end
}

for slot42 = 0, 5 do
	function (slot0)
		uv0.GetFilters(slot0, uv1.filters[slot0 + 1])
	end(slot42)
end

slot0.register_event(slot5.Refresh, slot38.refresh)
slot0.register_event(slot5.StopRefresh, slot38.stopRefresh)
slot0.register_event(slot5.QuickRefresh, slot38.quickRefresh)
slot0.register_event(slot5.Connect, slot38.connect)
slot0.register_event(slot5.ConnectWithPassword, slot38.connectWithPassword)
slot0.register_event(slot5.RequestFilters, slot38.requestFilters)
slot0.register_event(slot5.SaveFilters, slot38.saveFilters)
slot0.register_event(slot5.UpdateTagFilter, slot38.updateTagFilter)
slot0.register_event(slot5.AddToFavorites, slot38.addToFavorites)
slot0.register_event(slot5.RemoveFromFavorites, slot38.removeFromFavorites)
slot0.register_event(slot5.AddToHistory, slot38.addToHistory)
slot0.register_event(slot5.RemoveFromHistory, slot38.removeFromHistory)
slot0.register_event(slot5.RequestPlayerList, slot38.requestPlayerList)
client.set_event_callback("shutdown", function ()
	uv0()
	uv1.shutdown()
	uv2()
end)
