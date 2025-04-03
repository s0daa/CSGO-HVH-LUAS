local var_0_0 = require("gamesense/panorama_events")
local var_0_1 = require("gamesense/steamworks")
local var_0_2 = require("ffi")
local var_0_3 = "serverbrowser_config"
local var_0_4 = 730
local var_0_5 = {
	AddToFavorites = "ServerBrowser_AddToFavorites",
	StopRefresh = "ServerBrowser_StopRefresh",
	RemoveFromFavorites = "ServerBrowser_RemoveFromFavorites",
	Refresh = "ServerBrowser_Refresh",
	AddToHistory = "ServerBrowser_AddToHistory",
	UpdateTagFilter = "ServerBrowser_UpdateTagFilter",
	RemoveFromHistory = "ServerBrowser_RemoveFromHistory",
	SaveFilters = "ServerBrowser_SaveFilters",
	RequestPlayerList = "ServerBrowser_RequestPlayerList",
	RequestFilters = "ServerBrowser_RequestFilters",
	ConnectWithPassword = "ServerBrowser_ConnectWithPassword",
	Connect = "ServerBrowser_Connect",
	QuickRefresh = "ServerBrowser_QuickRefresh"
}
local var_0_6 = 0
local var_0_7 = 1
local var_0_8 = 2
local var_0_9 = var_0_1.ISteamMatchmakingServers
local var_0_10 = var_0_1.ISteamMatchmaking
local var_0_11 = cvar.connect
local var_0_12 = cvar.password
local var_0_13 = {
	filters = {
		{},
		{},
		{},
		{},
		{},
		{}
	}
}

local function var_0_14()
	database.write(var_0_3, var_0_13)
end

;(function()
	local var_2_0 = database.read(var_0_3)

	if var_2_0 == nil then
		var_0_14()
	else
		var_0_13 = var_2_0
	end
end)()

local var_0_15 = panorama.loadstring("const IMG_BASE = 'https://relative.im/img'\n\nconst SIDE_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu_play.css\" />\n\t</styles>\n\t<Panel class=\"top-bottom-flow map-selection-list__quick-selection-sets\">\n\t\t<Label text=\"Community Servers\" class=\"map-selection__quick-selection-set-title\" />\n\t\t<Panel id=\"serverbrowser-tabs\" class=\"map-selection-list__quick-selection-sets__btns\">\n\t\t\t<Button id=\"internet\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"Internet (0)\" />\n\t\t\t</Button>\n\t\t\t<Button id=\"favorites\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"Favorites (0)\" />\n\t\t\t</Button>\n\t\t\t<Button id=\"history\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"History (0)\" />\n\t\t\t</Button>\n\t\t\t<Button id=\"spectate\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"Spectate (0)\" />\n\t\t\t</Button>\n\t\t\t<Button id=\"lan\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"LAN (0)\" />\n\t\t\t</Button>\n\t\t\t<Button id=\"friends\" class=\"map-selection__quick-selection-set horizontal-align-left preset-button\">\n\t\t\t\t<Label text=\"Friends (0)\" />\n\t\t\t</Button>\n\t\t</Panel>\n\t\t<Label text=\"Actions\" class=\"map-selection__quick-selection-set-title\" />\n\t\t<Panel id=\"serverbrowser-actions\" class=\"map-selection-list__quick-selection-sets__btns\">\n\t\t\t<Button id=\"EditFilters\" class=\"map-selection__quick-selection-set-icon save preset-button\">\n\t\t\t\t<Image texturewidth=\"24\" textureheight=\"24\" src=\"file://{images}/icons/ui/edit.svg\"/>\n\t\t\t\t<Label text=\"Edit Filters\"/>\n\t\t\t</Button>\n\n\t\t\t<Button id=\"OpenOldBrowser\" class=\"map-selection__quick-selection-set-icon save preset-button\">\n\t\t\t\t<Image texturewidth=\"24\" textureheight=\"24\" src=\"file://{images}/icons/ui/link.svg\"/>\n\t\t\t\t<Label text=\"Open Old Browser\"/>\n\t\t\t</Button>\n\t\t</Panel>\n\t</Panel>\n</root>`\n\nconst MAIN_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu_play.css\" />\n\t\t<include src=\"file://{resources}/styles/matchinfo.css\" />\n\t\t<include src=\"file://{resources}/styles/matchinfo_scoreboard.css\" />\n\t\t<include src=\"file://{resources}/styles/context_menus/context_menu_base.css\" />\n\t</styles>\n\t<snippets>\n\t\t<snippet name=\"serverbrowser_server\">\n\t\t\t<Panel class=\"left-right-flow full-width sb-row evenrow\" style=\"margin: 0 0 3px;padding: 4px 0;\">\n\t\t\t\t<Panel style=\"width:25px;margin-left: 6px;\">\n\t\t\t\t\t<Image id=\"password\" src=\"file://{images}/icons/ui/locked.svg\" texturewidth=\"20px\" scaling=\"none\" />\n\t\t\t\t</Panel>\n\t\t\t\t<Panel style=\"width:25px;margin-left: 4px;\">\n\t\t\t\t\t<Image id=\"vac\" src=\"${IMG_BASE}/vac.svg\" texturewidth=\"20px\" scaling=\"none\" />\n\t\t\t\t</Panel>\n\t\t\t\t<Label id=\"name\" style=\"width: 1100px;margin-left: 4px;text-overflow:ellipsis;white-space:nowrap;\" />\n\t\t\t\t<Label id=\"players\" style=\"width:100px;\" />\n\t\t\t\t<Label id=\"map\" style=\"width:150px;text-overflow:ellipsis;white-space:nowrap;\"/>\n\t\t\t\t<Label id=\"ping\" style=\"width:100px;\"/>\n\t\t\t</Panel>\n\t\t</snippet>\n\t</snippets>\n\t<Panel class=\"top-bottom-flow full-width full-height\" style=\"margin:0px;padding:0px;margin-top:0px;\">\n\t\t<Panel class=\"left-right-flow full-width sb-row no-hover oddrow\" style=\"padding-top:5px;padding-bottom:5px;margin-right:2px;\">\n\t\t\t<TooltipPanel id=\"password\" style=\"width:25px;margin-left: 6px;\" tooltip=\"Server requires password\">\n\t\t\t\t<Image src=\"file://{images}/icons/ui/locked.svg\" texturewidth=\"20px\" scaling=\"none\" />\n\t\t\t</TooltipPanel>\n\t\t\t<TooltipPanel id=\"vac\" style=\"width:25px;margin-left: 4px;\" tooltip=\"Server has Valve Anti-Cheat (VAC) enabled\">\n\t\t\t\t<Image src=\"${IMG_BASE}/vac.svg\" texturewidth=\"20px\" scaling=\"none\"/>\n\t\t\t</TooltipPanel>\n\t\t\t<Panel class=\"left-right-flow round-selection-button\" style=\"width:1100px;margin-left: 4px;\">\n\t\t\t\t<Label id=\"head-name\" class=\"fontWeight-Bold\" text=\"Name\"/>\n\t\t\t\t<Image id=\"sort-name\" src=\"file://{images}/icons/ui/expand.svg\" texturewidth=\"16px\" scaling=\"none\" style=\"margin-left:4px;\"/>\n\t\t\t</Panel>\n\t\t\t<Panel class=\"left-right-flow round-selection-button\" style=\"width:100px;\">\n\t\t\t\t<Label id=\"head-players\" class=\"fontWeight-Bold\" text=\"Players\"/>\n\t\t\t\t<Image id=\"sort-players\" src=\"file://{images}/icons/ui/expand.svg\" texturewidth=\"16px\" scaling=\"none\" style=\"margin-left:4px;\" />\n\t\t\t</Panel>\n\t\t\t<Panel class=\"left-right-flow round-selection-button\" style=\"width:150px;\">\n\t\t\t\t<Label id=\"head-map\" class=\"fontWeight-Bold\" text=\"Map\"/>\n\t\t\t\t<Image id=\"sort-map\" src=\"file://{images}/icons/ui/expand.svg\" texturewidth=\"16px\" scaling=\"none\" style=\"margin-left:4px;\" />\n\t\t\t</Panel>\n\t\t\t<Panel class=\"left-right-flow round-selection-button\" style=\"width:100px;\">\n\t\t\t\t<Label id=\"head-ping\" class=\"fontWeight-Bold\" text=\"Ping\"/>\n\t\t\t\t<Image id=\"sort-ping\" src=\"file://{images}/icons/ui/expand.svg\" texturewidth=\"16px\" scaling=\"none\" style=\"margin-left:4px;\" />\n\t\t\t</Panel>\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-internet\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-favorites\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-history\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-spectate\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-lan\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t\t<Panel id=\"serverbrowser-servers-friends\" class=\"top-bottom-flow full-width vscroll\">\n\t\t</Panel>\n\t</Panel>\n</root>`\n\nconst BTNS_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu_play.css\" />\n\t\t<include src=\"file://{resources}/styles/stats/playerstats.css\" />\n\t</styles>\n\t<Panel class=\"left-right-flow\">\n\t\t<Button id=\"QuickRefresh\" class=\"content-navbar__manage-btn\" style=\"height:46px;margin-right:12px;\">\n\t\t\t<Label id=\"QuickRefreshText\" text=\"QUICK REFRESH\"/>\n\t\t</Button>\n\t\t<Button id=\"Refresh\" class=\"content-navbar__manage-btn\" style=\"height:46px;margin-right:12px;\">\n\t\t\t<Panel id=\"RefreshSpinner\" style=\"margin-right: 14px;\" class=\"Spinner\"/>\n\t\t\t<Label id=\"RefreshText\" text=\"STOP REFRESH\"/>\n\t\t</Button>\n\t\t<Button id=\"Connect\" class=\"content-navbar__manage-btn\" style=\"height:46px;\">\n\t\t\t<Label id=\"ConnectText\" text=\"CONNECT\"/>\n\t\t</Button>\n\t</Panel>\n</root>`\n\nconst TAGS_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu_play.css\" />\n\t</styles>\n\t<Panel class=\"left-right-flow content-navbar__tabs\" style=\"width: 100%;\">\n\t\t<TextEntry id=\"TagFilter\" class=\"workshop-search-textentry\" placeholder=\"Search for tags\" />\n\t\t<Panel id=\"FocusStealer\" acceptsfocus=\"true\"/>\n\t</Panel>\n</root>`\n\nconst FWFH_LAYOUT = `<root>\n\t<styles>\n\t</styles>\n\t<Panel style=\"position: 0px 0px 0px;width:100%;height:100%;\">\n\t\t<Button id=\"FWFHButton\" style=\"width:100%;height:100%;\"/>\n\t</Panel>\n</root>`\n\nconst POPUP_FILTERS_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/gamestyles.css\" />\n\t\t<include src=\"file://{resources}/styles/popups/popups_shared.css\" />\n\t\t<include src=\"file://{resources}/styles/popups/popup_play_gamemodeflags.css\" />\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/settings/settings.css\" />\n\t\t<include src=\"file://{resources}/styles/settings/settings_slider.css\" />\n\t</styles>\n\n\t<script>\n\t\tconst filterSchema = {\n\t\t\tnotFull: ['ServerNotFull', 'check'],\n\t\t\tnotEmpty: ['ServerNotEmpty', 'check'],\n\t\t\tnotPasswordProtected: ['NotPasswordProtected', 'check'],\n\t\t\tlatency: ['Latency', 'drop'],\n\t\t\tlocation: ['Location', 'drop'],\n\t\t\tanticheat: ['AntiCheat', 'drop'],\n\t\t\tmap: ['Map', 'text']\n\t\t}\n\n\t\tfunction _Return(bProceed) {\n\t\t\tconst cpnl = $.GetContextPanel()\n\t\t\tlet callbackHandle = cpnl.GetAttributeInt('callback', -1);\n\t\t\tlet cancelCallbackHandle = cpnl.GetAttributeInt('cancelcallback', -1);\n\t\t\tlet callback = bProceed ? callbackHandle : cancelCallbackHandle;\n\t\t\tif (callbackHandle !== -1) {\n\t\t\t\tlet options = {}\n\t\t\t\tfor (let k in filterSchema) {\n\t\t\t\t\tconst [id, type] = filterSchema[k]\n\t\t\t\t\tconst el = cpnl.FindChildTraverse(id)\n\t\t\t\t\tlet v\n\t\t\t\t\tswitch (type) {\n\t\t\t\t\t\tcase 'check':\n\t\t\t\t\t\t\tv = el.IsSelected()\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'drop':\n\t\t\t\t\t\t\tv = el.GetSelected().id\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'text':\n\t\t\t\t\t\t\tv = el.text\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t}\n\t\t\t\t\toptions[k] = v\n\t\t\t\t}\n\t\t\t\tUiToolkitAPI.InvokeJSCallback(callback, options);\n\t\t\t}\n\n\t\t\tif ( callbackHandle !== -1 )\n\t\t\t\tUiToolkitAPI.UnregisterJSCallback(callbackHandle);\n\t\t\tif ( cancelCallbackHandle !== -1 )\n\t\t\t\tUiToolkitAPI.UnregisterJSCallback(cancelCallbackHandle);\n\n\t\t\t$.DispatchEvent('UIPopupButtonClicked', '');\n\t\t}\n\t\tfunction SetupPopup() {\n\t\t\tconst cpnl = $.GetContextPanel()\n\t\t\tfor (let k in filterSchema) {\n\t\t\t\tconst [id, type] = filterSchema[k]\n\t\t\t\tconst el = cpnl.FindChildTraverse(id)\n\t\t\t\tconst attrStr = cpnl.GetAttributeString(k, '')\n\t\t\t\tif (attrStr !== '') {\n\t\t\t\t\tswitch (type) {\n\t\t\t\t\t\tcase 'check':\n\t\t\t\t\t\t\tel.SetSelected(attrStr[0] === 't')\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'drop':\n\t\t\t\t\t\t\tel.SetSelected(attrStr)\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'text':\n\t\t\t\t\t\t\tel.text = attrStr\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t\t\n\t\t}\n\t\tfunction CancelPopup() {\n\t\t\t_Return(false);\n\t\t}\n\t\tfunction OnOKPressed() {\n\t\t\t_Return(true);\n\t\t}\n\t</script>\n\n\t<PopupCustomLayout class=\"PopupPanel\" popupbackground=\"dim\" onload=\"SetupPopup()\" oncancel=\"CancelPopup()\">\n\t\t<Label class=\"PopupTitle\" text=\"Edit Filters\" />\n\n\t\t<Panel class=\"radio-options-container\">\n\t\t\t<Panel style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<ToggleButton id=\"ServerNotFull\" class=\"PopupButton Row\" >\n\t\t\t\t\t<Label id=\"\" text=\"Server not full\" />\n\t\t\t\t</ToggleButton>\n\t\t\t</Panel>\n\t\t\t<Panel style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<ToggleButton id=\"ServerNotEmpty\" class=\"PopupButton Row\" >\n\t\t\t\t\t<Label id=\"\" text=\"Has users playing\" />\n\t\t\t\t</ToggleButton>\n\t\t\t</Panel>\n\t\t\t<Panel style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<ToggleButton id=\"NotPasswordProtected\" class=\"PopupButton Row\" >\n\t\t\t\t\t<Label text=\"Is not password protected\" />\n\t\t\t\t</ToggleButton>\n\t\t\t</Panel>\n\t\t\t<Panel class=\"PopupButton Row\" style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<Label text=\"Latency\"/>\n\t\t\t\t<DropDown class=\"PopupButton\" id=\"Latency\" menuclass=\"DropDownMenu Width-300\">\n\t\t\t\t\t<Label text=\"&lt; All &gt;\" id=\"LatencyAll\" value=\"0\"/>\n\t\t\t\t\t<Label text=\"&lt; 50\" id=\"Latency50\" value=\"50\"/>\n\t\t\t\t\t<Label text=\"&lt; 100\" id=\"Latency100\" value=\"100\"/>\n\t\t\t\t\t<Label text=\"&lt; 150\" id=\"Latency150\" value=\"150\"/>\n\t\t\t\t\t<Label text=\"&lt; 250\" id=\"Latency250\" value=\"250\"/>\n\t\t\t\t\t<Label text=\"&lt; 350\" id=\"Latency350\" value=\"350\"/>\n\t\t\t\t\t<Label text=\"&lt; 600\" id=\"Latency600\" value=\"600\"/>\n\t\t\t\t</DropDown>\n\t\t\t</Panel>\n\t\t\t<Panel class=\"PopupButton Row\" style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<Label text=\"Location\"/>\n\t\t\t\t<DropDown class=\"PopupButton\" id=\"Location\" menuclass=\"DropDownMenu Width-300\">\n\t\t\t\t\t<Label text=\"&lt; All &gt;\" id=\"LocationAll\" value=\"0\"/>\n\t\t\t\t\t<Label text=\"US - East\" id=\"LocationUSE\" value=\"1\"/>\n\t\t\t\t\t<Label text=\"US - West\" id=\"LocationUSW\" value=\"2\"/>\n\t\t\t\t\t<Label text=\"South America\" id=\"LocationSA\" value=\"3\"/>\n\t\t\t\t\t<Label text=\"Europe\" id=\"LocationEU\" value=\"4\"/>\n\t\t\t\t\t<Label text=\"Asia\" id=\"LocationAS\" value=\"5\"/>\n\t\t\t\t\t<Label text=\"Australia\" id=\"LocationAU\" value=\"6\"/>\n\t\t\t\t\t<Label text=\"Middle East\" id=\"LocationME\" value=\"7\"/>\n\t\t\t\t\t<Label text=\"Africa\" id=\"LocationAF\" value=\"8\"/>\n\t\t\t\t</DropDown>\n\t\t\t</Panel>\n\t\t\t<Panel class=\"PopupButton Row\" style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<Label text=\"Anti cheat\"/>\n\t\t\t\t<DropDown class=\"PopupButton\" id=\"AntiCheat\" menuclass=\"DropDownMenu Width-300\">\n\t\t\t\t\t<Label text=\"&lt; All &gt;\" id=\"AntiCheatAll\" value=\"0\"/>\n\t\t\t\t\t<Label text=\"Secure\" id=\"AntiCheatSecure\" value=\"1\"/>\n\t\t\t\t\t<Label text=\"Not secure\" id=\"AntiCheatInsecure\" value=\"2\"/>\n\t\t\t\t</DropDown>\n\t\t\t</Panel>\n\t\t\t<Panel class=\"PopupButton Row\" style=\"horizontal-align: left; margin-bottom: 10px;\">\n\t\t\t\t<Label text=\"Map\"/>\n\t\t\t\t<TextEntry class=\"PopupButton\" maxchars=\"32\" id=\"Map\" style=\"width: 300px;\" />\n\t\t\t</Panel>\n\t\t</Panel>\n\n\t\t<Panel class=\"PopupButtonRow\">\n\t\t\t<TextButton class=\"PopupButton\" text=\"#OK\" onactivate=\"OnOKPressed()\" />\n\t\t\t<TextButton class=\"PopupButton\" text=\"#Cancel_Button\" onactivate=\"CancelPopup()\" />\n\t\t</Panel>\n\t</PopupCustomLayout>\n</root>`\n\nconst POPUP_SERVER_LAYOUT = `<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/gamestyles.css\" />\n\t\t<include src=\"file://{resources}/styles/popups/popups_shared.css\" />\n\t\t<include src=\"file://{resources}/styles/popups/popup_play_gamemodeflags.css\" />\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/settings/settings.css\" />\n\t\t<include src=\"file://{resources}/styles/settings/settings_slider.css\" />\n\t</styles>\n\t<scripts>\n\t\t<include src=\"file://{resources}/scripts/common/formattext.js\" />\n\t</scripts>\n\n\t<script>\n\t\tlet server = {}\n\t\tlet dataCallback = -1\n\t\tfunction InvokeCallback(...args) {\n\t\t\tlet callback = $.GetContextPanel().GetAttributeInt('callback', -1)\n\t\t\tif (callback !== -1) {\n\t\t\t\tUiToolkitAPI.InvokeJSCallback(callback, ...args);\n\t\t\t}\n\t\t\treturn callback;\n\t\t}\n\t\tfunction _Return(szType) {\n\t\t\tlet callback = InvokeCallback(szType);\n\t\t\tif (callback !== -1) {\n\t\t\t\tUiToolkitAPI.UnregisterJSCallback(callback);\n\t\t\t}\n\t\t\tUiToolkitAPI.UnregisterJSCallback(dataCallback);\n\n\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\t$.DispatchEvent('UIPopupButtonClicked', '');\n\t\t}\n\n\t\tfunction _ClearPlayerList() {\n\t\t\t$.GetContextPanel().FindChildTraverse('PlayerList').Children().forEach(ch => {\n\t\t\t\tch.DeleteAsync(0.0);\n\t\t\t})\n\t\t}\n\t\tfunction _PlayerAdded(ply) {\n\t\t\tlet el = $.CreatePanel(\n\t\t\t\t'Panel',\n\t\t\t\t$.GetContextPanel().FindChildTraverse('PlayerList'),\n\t\t\t\t''\n\t\t\t);\n\t\t\tel.BLoadLayoutSnippet('serverbrowser_player')\n\t\t\tel.FindChildTraverse('Name').text = ply.name\n\t\t\tel.FindChildTraverse('Score').text = ply.score\n\t\t\tel.FindChildTraverse('Time').text = FormatText.SecondsToSignificantTimeString(ply.timePlayed)\n\t\t}\n\n\t\tfunction _UpdateData(type, data) {\n\t\t\tswitch (type) {\n\t\t\t\tcase 'clearPlayerList':\n\t\t\t\t\t_ClearPlayerList();\n\t\t\t\t\tbreak\n\t\t\t\tcase 'playerAdded':\n\t\t\t\t\t_PlayerAdded(data);\n\t\t\t\t\tbreak;\n\t\t\t\tcase 'playerRefreshStatus':\n\t\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t\tfunction SetupPopup() {\n\t\t\tlet parameters = [\n\t\t\t\t'appId',\n\t\t\t\t'botPlayers',\n\t\t\t\t'doNotRefresh',\n\t\t\t\t'gameDesc',\n\t\t\t\t'gameDir',\n\t\t\t\t'gameTags',\n\t\t\t\t'i',\n\t\t\t\t'ip',\n\t\t\t\t'ipPort',\n\t\t\t\t'map',\n\t\t\t\t'maxPlayers',\n\t\t\t\t'password',\n\t\t\t\t'ping',\n\t\t\t\t'players',\n\t\t\t\t'port',\n\t\t\t\t'queryPort',\n\t\t\t\t'secure',\n\t\t\t\t'serverName',\n\t\t\t\t'serverVersion',\n\t\t\t\t'successful',\n\t\t\t\t'timeLastPlayed',\n\t\t\t\t'type',\n\t\t\t];\n\t\t\tfor (let p of parameters) {\n\t\t\t\tserver[p] = $.GetContextPanel().GetAttributeString(p, '?')\n\t\t\t}\n\t\t\tdataCallback = UiToolkitAPI.RegisterJSCallback(_UpdateData);\n\t\t\t_UpdateWithServer(server)\n\t\t\tInvokeCallback('players', dataCallback)\n\t\t}\n\t\tfunction _UpdateWithServer(server) {\n\t\t\t$.GetContextPanel().SetDialogVariable('name', server.serverName)\n\t\t\t$.GetContextPanel().SetDialogVariable('game', server.gameDesc)\n\t\t\t$.GetContextPanel().SetDialogVariable('map', server.map)\n\t\t\t$.GetContextPanel().SetDialogVariable('players', server.players + ' / ' + server.maxPlayers)\n\t\t\t$.GetContextPanel().SetDialogVariable('vac', server.secure === 'true' ? 'Secure' : 'Not secure')\n\t\t\t$.GetContextPanel().SetDialogVariable('ping', server.ping)\n\t\t}\n\t\tfunction CancelPopup() {\n\t\t\t_Return(false);\n\t\t}\n\t\tfunction OnCopyPressed() {\n\t\t\tSteamOverlayAPI.CopyTextToClipboard(server.ipPort)\n\t\t\tUiToolkitAPI.HideTextTooltip();\n\t\t\tUiToolkitAPI.ShowTextTooltipOnPanel($.GetContextPanel().FindChildTraverse('CopyButton'), 'Copied to clipboard');\n\t\t}\n\t\tfunction OnConnectPressed() {\n\t\t\t_Return('connect')\n\t\t}\n\t</script>\n\t\n\t<snippets>\n\t\t<snippet name=\"serverbrowser_player\">\n\t\t\t<Panel class=\"left-right-flow full-width\">\n\t\t\t\t<Label id=\"Name\" text=\"?\" style=\"width:235px;\"/>\n\t\t\t\t<Label id=\"Score\" text=\"?\" style=\"width:70px;\"/>\n\t\t\t\t<Label id=\"Time\" text=\"?\" style=\"width:200px;\"/>\n\t\t\t</Panel>\n\t\t</snippet>\n\t</snippets>\n\n\t<PopupCustomLayout class=\"PopupPanel\" popupbackground=\"dim\" onload=\"SetupPopup()\" oncancel=\"CancelPopup()\">\n\t\t<Label class=\"PopupTitle\" text=\"{s:name}\" />\n\n\t\t<Panel class=\"left-right-flow\" style=\"margin: 16px;width: 100%;\">\n\t\t\t<Panel class=\"top-bottom-flow\" style=\"width:35%;\">\n\t\t\t\t<Label class=\"fontWeight-Bold text-align-right\" text=\"Game\" />\n\t\t\t\t<Label class=\"fontWeight-Bold text-align-right\" text=\"Map\" />\n\t\t\t\t<Label class=\"fontWeight-Bold text-align-right\" text=\"Players\" />\n\t\t\t\t<Label class=\"fontWeight-Bold text-align-right\" text=\"Valve Anti-Cheat\" />\n\t\t\t\t<Label class=\"fontWeight-Bold text-align-right\" text=\"Latency\" />\n\t\t\t</Panel>\n\t\t\t<Panel class=\"top-bottom-flow\" style=\"horizontal-align: left;width:65%;\">\n\t\t\t\t<Label text=\"{s:game}\" />\n\t\t\t\t<Label text=\"{s:map}\" />\n\t\t\t\t<Label text=\"{s:players}\" />\n\t\t\t\t<Label text=\"{s:vac}\" />\n\t\t\t\t<Label text=\"{s:ping}\" />\n\t\t\t</Panel>\n\t\t</Panel>\n\t\t\n\t\t<Panel class=\"radio-options-container\" style=\"margin-right: 16px;\">\n\t\t\t<Panel class=\"left-right-flow full-width\">\n\t\t\t\t<Label id=\"head-name\" class=\"fontWeight-Bold\" text=\"Player name\" style=\"width:235px;\"/>\n\t\t\t\t<Label id=\"head-score\" class=\"fontWeight-Bold\" text=\"Score\" style=\"width:70px;\"/>\n\t\t\t\t<Label id=\"head-time\" class=\"fontWeight-Bold\" text=\"Time\" style=\"width:200px;\"/>\n\t\t\t</Panel>\n\t\t\t<Panel id=\"PlayerList\" class=\"top-bottom-flow full-width vscroll\" style=\"max-height: 400px;\">\n\n\t\t\t</Panel>\n\t\t\t\n\t\t</Panel>\n\n\t\t<Panel class=\"PopupButtonRow\">\n\t\t\t<TextButton class=\"PopupButton\" text=\"#GameUI_Close\" onactivate=\"CancelPopup()\" />\n\t\t\t<TextButton id=\"CopyButton\" class=\"PopupButton\" text=\"Copy IP\" onactivate=\"OnCopyPressed()\" onmouseout=\"UiToolkitAPI.HideTextTooltip()\" />\n\t\t\t<TextButton class=\"PopupButton positiveColor\" text=\"Connect\" onactivate=\"OnConnectPressed()\" style=\"border: 1px solid rgba(191, 191, 191, 0.3);\" />\n\t\t</Panel>\n\t</PopupCustomLayout>\n</root>`\n\nconst destroyAllPanels = (ch) => ch.DeleteAsync(0)\nconst hideAllPanels = (ch) => (ch.visible = false)\nconst hidePanels =\n\t(others = false) =>\n\t(ch) => {\n\t\tlet ourPanel = (ch.id || '').startsWith('serverbrowser-')\n\t\tch.visible = others ? ourPanel : !ourPanel\n\t}\n\nconst latencyIdToThreshold = (lat) => {\n\tlet num = parseInt(lat.substring(7)) // 7 = 'Latency'.length\n\tif (!isNaN(num)) {\n\t\treturn num\n\t}\n\treturn 999999999999\n}\n\nconst Types = {\n\t0: 'Internet',\n\t1: 'Favorites',\n\t2: 'History',\n\t3: 'Spectate',\n\t4: 'Lan',\n\t5: 'Friends',\n\tinternet: 0,\n\tfavorites: 1,\n\thistory: 2,\n\tspectate: 3,\n\tlan: 4,\n\tfriends: 5,\n}\n\nconst hooks = []\n\nhooks.new = (obj, name, callback) => {\n\tlet hook = {\n\t\tdestroyed: false,\n\t\tobj,\n\t\tname,\n\t\toriginal: obj[name],\n\t\tdestroy() {\n\t\t\tif (this.destroyed) return true\n\t\t\tobj[name] = this.original\n\t\t\tthis.destroyed = true\n\t\t\treturn this.destroyed\n\t\t},\n\t}\n\thook.original = obj[name]\n\n\tobj[name] = function () {\n\t\t// just in case theres a reference stored somewhere to this function\n\t\tif (hook.destroyed) return hook.original.apply(this, arguments)\n\t\tlet thiz = this\n\t\treturn callback.apply(\n\t\t\t{ hook, this: thiz, orig: hook.original.bind(thiz) },\n\t\t\targuments\n\t\t)\n\t}\n\n\thooks.push(hook)\n\treturn hook\n}\n\nhooks.destroy = () => {\n\thooks.forEach((hook) => !hook.destroyed && hook.destroy())\n\treturn true\n}\n\nconst ipToString = (num) =>\n\t[\n\t\t(num >> (8 * 3)) & 0xff,\n\t\t(num >> (8 * 2)) & 0xff,\n\t\t(num >> (8 * 1)) & 0xff,\n\t\t(num >> (8 * 0)) & 0xff,\n\t].join('.')\n\nconst Lua = {\n\tEvents: {\n\t\tRefresh: 'ServerBrowser_Refresh',\n\t\tStopRefresh: 'ServerBrowser_StopRefresh',\n\t\tQuickRefresh: 'ServerBrowser_QuickRefresh',\n\t\tConnect: 'ServerBrowser_Connect',\n\t\tConnectWithPassword: 'ServerBrowser_ConnectWithPassword',\n\t\tRequestFilters: 'ServerBrowser_RequestFilters',\n\t\tSaveFilters: 'ServerBrowser_SaveFilters',\n\t\tUpdateTagFilter: 'ServerBrowser_UpdateTagFilter',\n\t\tAddToFavorites: 'ServerBrowser_AddToFavorites',\n\t\tRemoveFromFavorites: 'ServerBrowser_RemoveFromFavorites',\n\t\tAddToHistory: 'ServerBrowser_AddToHistory',\n\t\tRemoveFromHistory: 'ServerBrowser_RemoveFromHistory',\n\t\tRequestPlayerList: 'ServerBrowser_RequestPlayerList',\n\t},\n\tinit() {\n\t\t$.DefineEvent(Lua.Events.Refresh, 1, '', '')\n\t\t$.DefineEvent(Lua.Events.StopRefresh, 1, '', '')\n\t\t$.DefineEvent(Lua.Events.QuickRefresh, 2, '', '')\n\t\t$.DefineEvent(Lua.Events.Connect, 2, '', '')\n\t\t$.DefineEvent(Lua.Events.ConnectWithPassword, 3, '', '')\n\t\t$.DefineEvent(Lua.Events.RequestFilters, 1, '', '')\n\t\t$.DefineEvent(Lua.Events.SaveFilters, 2, '', '')\n\t\t$.DefineEvent(Lua.Events.UpdateTagFilter, 2, '', '')\n\t\t$.DefineEvent(Lua.Events.AddToFavorites, 4, '', '')\n\t\t$.DefineEvent(Lua.Events.RemoveFromFavorites, 4, '', '')\n\t\t$.DefineEvent(Lua.Events.AddToHistory, 4, '', '')\n\t\t$.DefineEvent(Lua.Events.RemoveFromHistory, 4, '', '')\n\t\t$.DefineEvent(Lua.Events.RequestPlayerList, 3, '', '')\n\t},\n\trefresh(type) {\n\t\t$.DispatchEvent(Lua.Events.Refresh, type)\n\t},\n\tstopRefresh(type) {\n\t\t$.DispatchEvent(Lua.Events.StopRefresh, type)\n\t},\n\tquickRefresh(type, server) {\n\t\t$.DispatchEvent(Lua.Events.QuickRefresh, type, server)\n\t},\n\tconnect(ip, port) {\n\t\t$.DispatchEvent(Lua.Events.Connect, ip, port)\n\t},\n\tconnectWithPassword(ip, port, password) {\n\t\t$.DispatchEvent(Lua.Events.ConnectWithPassword, ip, port, password)\n\t},\n\trequestFilters(type) {\n\t\t$.DispatchEvent(Lua.Events.RequestFilters, type)\n\t},\n\tsaveFilters(type, filters) {\n\t\t$.DispatchEvent(Lua.Events.SaveFilters, type, JSON.stringify(filters))\n\t},\n\tupdateTagFilter(type, tags) {\n\t\t$.DispatchEvent(Lua.Events.UpdateTagFilter, type, tags)\n\t},\n\taddToFavorites(appId, ip, port, queryPort) {\n\t\t$.DispatchEvent(Lua.Events.AddToFavorites, appId, ip, port, queryPort)\n\t},\n\tremoveFromFavorites(appId, ip, port, queryPort) {\n\t\t$.DispatchEvent(Lua.Events.RemoveFromFavorites, appId, ip, port, queryPort)\n\t},\n\taddToHistory(appId, ip, port, queryPort) {\n\t\t$.DispatchEvent(Lua.Events.AddToHistory, appId, ip, port, queryPort)\n\t},\n\tremoveFromHistory(appId, ip, port, queryPort) {\n\t\t$.DispatchEvent(Lua.Events.RemoveFromHistory, appId, ip, port, queryPort)\n\t},\n\trequestPlayerList(uid, ip, port) {\n\t\t$.DispatchEvent(Lua.Events.RequestPlayerList, uid, ip, port)\n\t},\n}\n\nconst browser = {\n\tinitialized: false,\n\tisOpen: false,\n\n\ttabs: ['internet', 'favorites', 'history', 'spectate', 'lan', 'friends'],\n\tselectedTab: 'internet',\n\tselectedType: 0,\n\n\tpanelMain: null,\n\tpanelSide: null,\n\tpanelBtns: null,\n\tpanelTags: null,\n\tpanelFWFH: null,\n\tpanelMainId: 'serverbrowser-main',\n\tpanelSideId: 'serverbrowser-side',\n\tpanelBtnsId: 'serverbrowser-btns',\n\tpanelTagsId: 'serverbrowser-tags',\n\tpanelFWFHId: 'serverbrowser-fwfh',\n\tpanelIds: [\n\t\t'serverbrowser-main',\n\t\t'serverbrowser-side',\n\t\t'serverbrowser-btns',\n\t\t'serverbrowser-tags',\n\t\t'serverbrowser-fwfh',\n\t],\n\tplayTopNavDropdown: null,\n\tdoneWithFrame: true,\n\n\tpanelServerLists: [],\n\trefreshing: [false, false, false, false, false, false],\n\t// prettier-ignore\n\tserverLists: [ [], [], [], [], [], [] ],\n\tfilters: [{}, {}, {}, {}, {}, {}],\n\tselectedServer: ['', '', '', '', '', ''],\n\n\tplayerCallbacks: {},\n\n\tlastSelectedItem: '',\n\n\turlEncode(obj) {\n\t\treturn Object.entries(obj)\n\t\t\t.map((i) => i.map(encodeURIComponent).join('='))\n\t\t\t.join('&')\n\t},\n\n\t// init/destroy\n\tfetchDependencyPanels() {\n\t\tlet contextPanel = $.GetContextPanel()\n\t\tthis.panelIds.forEach((panelId) => {\n\t\t\tlet panel = contextPanel.FindChildTraverse(panelId)\n\t\t\tif (panel) panel.DeleteAsync(0)\n\t\t})\n\n\t\tthis.JsQuickSelectParent = contextPanel.FindChildTraverse(\n\t\t\t'JsQuickSelectParent'\n\t\t)\n\t\tthis.MapSelectionList = contextPanel.FindChildTraverse('MapSelectionList')\n\t\tif (!this.JsQuickSelectParent || !this.MapSelectionList) return false\n\n\t\tthis.playTopNavDropdown =\n\t\t\tcontextPanel.FindChildTraverse('PlayTopNavDropdown')\n\t\tif (!this.playTopNavDropdown) return false\n\n\t\t// settings-container content-navbar__tabs--small\n\t\tthis.settingsContainer = contextPanel\n\t\t\t.FindChildTraverse('JsDirectChallengeBtn')\n\t\t\t.GetParent()\n\t\t\t.GetParent()\n\t\tif (!this.settingsContainer) return false\n\n\t\tthis.workshopSearchBar = contextPanel.FindChildTraverse('WorkshopSearchBar')\n\t\tif (!this.workshopSearchBar) return false\n\n\t\t// apparently there are 3 different elements with id \"GameModeSelectionRadios\"\n\t\tthis.gameModeSelectionRadios = this.workshopSearchBar\n\t\t\t.GetParent()\n\t\t\t.FindChild('GameModeSelectionRadios')\n\t\tif (!this.gameModeSelectionRadios) return false\n\n\t\tthis.btnContainer = $.GetContextPanel()\n\t\t\t.FindChildTraverse('StartMatchBtn')\n\t\t\t.GetParent()\n\t\tif (!this.btnContainer) return false\n\n\t\tthis.tagsContainer = this.workshopSearchBar.GetParent()\n\t\tif (!this.tagsContainer) return false\n\n\t\treturn true\n\t},\n\tcreatePanelMain() {\n\t\tlet parent = this.MapSelectionList.GetParent()\n\t\tthis.panelMain = $.CreatePanel('Panel', parent, this.panelMainId)\n\t\tthis.panelMain.BLoadLayoutFromString(MAIN_LAYOUT, false, false)\n\t\tthis.panelMain.enabled = true\n\t\tthis.panelMain.visible = false\n\n\t\tparent.MoveChildBefore(\n\t\t\tthis.panelMain,\n\t\t\tparent.GetChild(0) /* MapSelectionList */\n\t\t)\n\n\t\tthis.panelMain\n\t\t\t.FindChildTraverse('head-name')\n\t\t\t.SetPanelEvent('onactivate', () => this.nameHeaderPressed())\n\t\tthis.panelMain\n\t\t\t.FindChildTraverse('head-players')\n\t\t\t.SetPanelEvent('onactivate', () => this.playersHeaderPressed())\n\t\tthis.panelMain\n\t\t\t.FindChildTraverse('head-map')\n\t\t\t.SetPanelEvent('onactivate', () => this.mapHeaderPressed())\n\t\tthis.panelMain\n\t\t\t.FindChildTraverse('head-ping')\n\t\t\t.SetPanelEvent('onactivate', () => this.pingHeaderPressed())\n\n\t\tthis.panelServerLists.push(\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-internet'),\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-favorites'),\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-history'),\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-spectate'),\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-lan'),\n\t\t\tthis.panelMain.FindChildTraverse('serverbrowser-servers-friends')\n\t\t)\n\t\tthis.panelServerLists.forEach(hideAllPanels)\n\t},\n\tcreatePanelSide() {\n\t\tlet parent = this.JsQuickSelectParent.GetParent()\n\t\tthis.panelSide = $.CreatePanel('Panel', parent, this.panelSideId)\n\t\tthis.panelSide.BLoadLayoutFromString(SIDE_LAYOUT, false, false)\n\t\tthis.panelSide.enabled = true\n\t\tthis.panelSide.visible = false\n\n\t\tparent.MoveChildBefore(\n\t\t\tthis.panelSide,\n\t\t\tparent.GetChild(0) /* JsQuickSelectParent */\n\t\t)\n\n\t\tthis.panelSide\n\t\t\t.FindChildTraverse('serverbrowser-tabs')\n\t\t\t.Children()\n\t\t\t.forEach((ch) => {\n\t\t\t\tch.SetPanelEvent('onactivate', () => this.selectTab(ch.id))\n\t\t\t})\n\n\t\tthis.btnEditFilters = this.panelSide.FindChildTraverse('EditFilters')\n\t\tthis.btnEditFilters.SetPanelEvent('onactivate', () =>\n\t\t\tthis.editFiltersPressed()\n\t\t)\n\t\tthis.btnOpenOldBrowser = this.panelSide.FindChildTraverse('OpenOldBrowser')\n\t\tthis.btnOpenOldBrowser.SetPanelEvent('onactivate', () =>\n\t\t\tthis.openOldBrowserPressed()\n\t\t)\n\t},\n\tcreatePanelBtns() {\n\t\tthis.panelBtns = $.CreatePanel('Panel', this.btnContainer, this.panelBtnsId)\n\t\tthis.panelBtns.BLoadLayoutFromString(BTNS_LAYOUT, false, false)\n\t\tthis.panelBtns.enabled = true\n\t\tthis.panelBtns.visible = false\n\t\tthis.btnQuickRefresh = this.panelBtns.FindChild('QuickRefresh')\n\t\tthis.btnRefresh = this.panelBtns.FindChild('Refresh')\n\t\tthis.btnConnect = this.panelBtns.FindChild('Connect')\n\n\t\tthis.btnQuickRefresh.SetPanelEvent('onactivate', () =>\n\t\t\tthis.quickRefreshPressed()\n\t\t)\n\t\tthis.btnRefresh.SetPanelEvent('onactivate', () => this.refreshPressed())\n\t\tthis.btnConnect.SetPanelEvent('onactivate', () => this.connectPressed())\n\t},\n\tcreatePanelTags() {\n\t\tlet parent = this.tagsContainer\n\t\tthis.panelTags = $.CreatePanel('Panel', parent, this.panelTagsId)\n\t\tthis.panelTags.BLoadLayoutFromString(TAGS_LAYOUT, false, false)\n\t\tthis.panelTags.enabled = true\n\t\tthis.panelTags.visible = false\n\n\t\tparent.MoveChildBefore(this.panelTags, parent.GetChild(0) /* front of el */)\n\n\t\tthis.txtTags = this.panelTags.FindChildTraverse('TagFilter')\n\t\tthis.txtTags.SetPanelEvent('ontextentrychange', () =>\n\t\t\tthis.tagsFilterUpdated()\n\t\t)\n\t\tthis.txtTags.SetPanelEvent('onfocus', () => this.tagsFilterFocus())\n\n\t\t// Fuck Valve\n\t\tthis.tagsFocusStealer = this.panelTags.FindChildTraverse('FocusStealer')\n\t},\n\tcreatePanelFWFH() {\n\t\tthis.panelFWFH = $.CreatePanel(\n\t\t\t'Panel',\n\t\t\t$.GetContextPanel(),\n\t\t\tthis.panelFWFHId\n\t\t)\n\t\tthis.panelFWFH.BLoadLayoutFromString(FWFH_LAYOUT, false, false)\n\t\tthis.panelFWFH.enabled = true\n\t\tthis.panelFWFH.visible = false\n\n\t\tthis.btnFWFH = this.panelFWFH.FindChildTraverse('FWFHButton')\n\t\tthis.btnFWFH.SetPanelEvent('onactivate', () => this.clickOutTriggered())\n\t},\n\n\tinit() {\n\t\tif (this.initialized) return true\n\n\t\tif (!this.fetchDependencyPanels()) return false\n\n\t\tthis.createPanelMain()\n\t\tthis.createPanelSide()\n\t\tthis.createPanelBtns()\n\t\tthis.createPanelTags()\n\t\tthis.createPanelFWFH()\n\n\t\t// calling SetSelected will trigger oninputsubmit\n\t\t// since you cant hook event listeners in panorama js, the only way to change the dropdown is using SetSelected(Index)\n\t\t// every time the item is community in oninputsubmit handler in mainmenu_play it will call the openserverbrowser concmd\n\t\t// opening our panel, and settingg PlayCommunity to the item and our game will crash\n\n\t\thooks.new(\n\t\t\tthis.playTopNavDropdown,\n\t\t\t'GetSelected',\n\t\t\tfunction (bypass = false) {\n\t\t\t\tlet selected = this.orig()\n\t\t\t\tif (!bypass) {\n\t\t\t\t\tbrowser.lastSelectedItem = selected.id\n\t\t\t\t\tif (selected.id === 'PlayCommunity') {\n\t\t\t\t\t\tbrowser.doneWithFrame = false\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t\treturn selected\n\t\t\t}\n\t\t)\n\t\thooks.new(this.playTopNavDropdown, 'SetSelected', function (item) {\n\t\t\tif (!browser.doneWithFrame) {\n\t\t\t\titem = 'PlayCommunity'\n\t\t\t}\n\t\t\treturn this.orig(item)\n\t\t})\n\n\t\t// \"on**user**inputsubmit\" my ass\n\t\tthis.playTopNavDropdown.SetPanelEvent('onuserinputsubmit', () => {\n\t\t\tlet selectedId = this.playTopNavDropdown.GetSelected(true).id\n\t\t\tthis.lastSelectedItem = selectedId\n\t\t\tthis.doneWithFrame = true\n\t\t\tif (selectedId === 'PlayCommunity') {\n\t\t\t\tthis.open()\n\t\t\t} else {\n\t\t\t\tthis.close()\n\t\t\t}\n\t\t})\n\n\t\tthis.updateHeaders()\n\t\tthis.initialized = true\n\t\treturn true\n\t},\n\tdestroy() {\n\t\tthis.close()\n\t\tthis.initialized = false\n\t\tif (this.playTopNavDropdown) {\n\t\t\tthis.playTopNavDropdown.ClearPanelEvent('onuserinputsubmit')\n\t\t\tthis.playTopNavDropdown.SetSelected('Play-official')\n\t\t}\n\t\tif (this.panelMain) this.panelMain.DeleteAsync(0)\n\t\tif (this.panelSide) this.panelSide.DeleteAsync(0)\n\t\tif (this.panelBtns) this.panelBtns.DeleteAsync(0)\n\t\tif (this.panelTags) this.panelTags.DeleteAsync(0)\n\t\tif (this.panelFWFH) this.panelFWFH.DeleteAsync(0)\n\t\tif (this.hkSetSelected) this.hkSetSelected.destroy()\n\t},\n\n\t// fwfh focus mgr\n\tclickOutCallback: [],\n\tclickOutTriggered() {\n\t\tlet cb\n\t\twhile ((cb = this.clickOutCallback.shift())) {\n\t\t\tif (typeof cb === 'function') cb()\n\t\t}\n\n\t\tthis.hideClickOut()\n\t},\n\tshowClickOut(callback) {\n\t\tthis.clickOutCallback.push(callback)\n\t\tthis.panelFWFH.enabled = this.panelFWFH.visible = true\n\t},\n\thideClickOut() {\n\t\tif (this.clickOutCallback.length > 0) this.clickOutCallback = []\n\t\tthis.panelFWFH.enabled = this.panelFWFH.visible = false\n\t},\n\n\t// utility functions\n\tselectTab(tab) {\n\t\tthis.selectedTab = tab\n\t\tthis.selectedType = Types[tab]\n\n\t\tthis.panelSide\n\t\t\t.FindChildTraverse('serverbrowser-tabs')\n\t\t\t.Children()\n\t\t\t.forEach((ch) => ch.SetHasClass('match', ch.id == tab))\n\n\t\tthis.panelServerLists.forEach((ch, idx) => {\n\t\t\tch.visible = idx === this.selectedType\n\t\t})\n\n\t\tlet filter = this.filters[this.selectedType]\n\t\tthis.txtTags.text = filter && filter.tags ? filter.tags : ''\n\n\t\tthis.updateButtonState()\n\t},\n\tisRefreshing(type = this.selectedType) {\n\t\treturn this.refreshing[type]\n\t},\n\tgetSelectedServer(type = this.selectedType) {\n\t\treturn this.selectedServer[type]\n\t},\n\tgetSelectedServerObj(type = this.selectedType) {\n\t\tlet uid = this.getSelectedServer(type)\n\t\treturn this.serverLists[type].find((i) => i.uid === uid)\n\t},\n\tgetSelectedServerEl(type = this.selectedType) {\n\t\tlet uid = this.getSelectedServer(type)\n\t\treturn this.panelServerLists[type].FindChildTraverse(`server-${uid}`)\n\t},\n\tselectServer(type, uid, el) {\n\t\tlet oldEl = this.getSelectedServerEl(type)\n\t\tif (oldEl) {\n\t\t\toldEl.RemoveClass('CartTournamentPasses')\n\t\t\toldEl.AddClass('evenrow')\n\t\t}\n\n\t\tel.AddClass('CartTournamentPasses')\n\t\tel.RemoveClass('evenrow')\n\t\tthis.selectedServer[type] = uid\n\t},\n\tupdateButtonState() {\n\t\t// refresh btn\n\t\tlet refreshing = this.isRefreshing()\n\t\tif (refreshing) {\n\t\t\tthis.btnRefresh.FindChild('RefreshSpinner').visible = true\n\t\t\tthis.btnRefresh.FindChild('RefreshText').text = 'STOP REFRESH'\n\t\t} else {\n\t\t\tthis.btnRefresh.FindChild('RefreshSpinner').visible = false\n\t\t\tthis.btnRefresh.FindChild('RefreshText').text = 'REFRESH ALL'\n\t\t}\n\t},\n\tgetPlayersForServer(server, cb) {\n\t\tthis.playerCallbacks[server.uid] = {\n\t\t\tcallback: cb,\n\t\t\tplayers: [],\n\t\t}\n\t\tLua.requestPlayerList(server.uid, server.ip, server.port)\n\t},\n\tviewServerInfo(server) {\n\t\tlet callback = UiToolkitAPI.RegisterJSCallback((t, dcb) => {\n\t\t\tswitch (t) {\n\t\t\t\tcase 'connect':\n\t\t\t\t\tthis.connectToServer(server)\n\t\t\t\t\tbreak\n\t\t\t\tcase 'players':\n\t\t\t\t\tthis.getPlayersForServer(server, dcb)\n\t\t\t\t\tbreak\n\t\t\t}\n\t\t})\n\n\t\tlet parameters = Object.assign({}, { callback }, server)\n\n\t\tlet panelPopup = UiToolkitAPI.ShowCustomLayoutPopupParameters(\n\t\t\t'',\n\t\t\t'',\n\t\t\tthis.urlEncode(parameters)\n\t\t)\n\t\tpanelPopup.BLoadLayoutFromString(POPUP_SERVER_LAYOUT, false, false)\n\t},\n\tconnectToServer(server) {\n\t\tLua.connect(server.ip, server.port)\n\t},\n\taddServer(type, server, forceCreate = false) {\n\t\tlet panelServers = this.panelServerLists[type]\n\t\tlet srv = panelServers.FindChild(`server-${server.uid}`)\n\t\tif (!srv || forceCreate) {\n\t\t\tsrv = $.CreatePanel('Panel', panelServers, `server-${server.uid}`)\n\n\t\t\tsrv.BLoadLayoutSnippet('serverbrowser_server')\n\n\t\t\tif (!forceCreate) {\n\t\t\t\t/*let svs = this.serverLists[type].slice()\n\t\t\t\tif (svs.length >= 3) {\n\t\t\t\t\tsvs.sort(sortFn)\n\t\t\t\t\tlet ourServer = svs.findIndex((s) => s.i === server.i)\n\t\t\t\t\tif (ourServer + 1 !== svs.length) {\n\t\t\t\t\t\tpanelServers.MoveChildBefore(\n\t\t\t\t\t\t\tsrv,\n\t\t\t\t\t\t\tpanelServers.FindChild(`server-${svs[ourServer + 1].uid}`)\n\t\t\t\t\t\t)\n\t\t\t\t\t}\n\t\t\t\t}*/\n\t\t\t\tthis.resort(type, false)\n\n\t\t\t\tthis.panelSide\n\t\t\t\t\t.FindChildTraverse(Types[type].toLowerCase())\n\t\t\t\t\t.Children()[0].text = `${Types[type]} (${this.serverLists[type].length})`\n\t\t\t}\n\t\t}\n\t\tlet isWorkshopMap = server.map.startsWith('workshop/')\n\t\tlet mapFixed = server.map\n\t\tif (isWorkshopMap) {\n\t\t\tmapFixed = server.map.split('/')\n\t\t\tmapFixed = mapFixed[mapFixed.length - 1]\n\t\t}\n\t\tsrv.FindChildTraverse('password').visible = server.password\n\t\tsrv.FindChildTraverse('vac').visible = server.secure\n\t\tsrv.FindChildTraverse('name').text = server.serverName\n\t\tsrv.FindChildTraverse(\n\t\t\t'players'\n\t\t).text = `${server.players} / ${server.maxPlayers}`\n\t\tsrv.FindChildTraverse('map').text = mapFixed\n\t\tsrv.FindChildTraverse('ping').text = server.ping.toString()\n\t\tsrv.enabled = true\n\n\t\tlet listText = 'Add server to favorites'\n\t\tif (type === Types.favorites) {\n\t\t\tlistText = 'Remove server from favorites'\n\t\t} else if (type === Types.history) {\n\t\t\tlistText = 'Remove server from history'\n\t\t}\n\n\t\tlet filter = this.filters[type]\n\n\t\tlet contextMenu = [\n\t\t\t{\n\t\t\t\tlabel: 'Connect to server',\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tthis.connectToServer(server)\n\t\t\t\t},\n\t\t\t},\n\t\t\t{\n\t\t\t\tlabel: 'View server info',\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tthis.viewServerInfo(server)\n\t\t\t\t},\n\t\t\t},\n\t\t\t{\n\t\t\t\tlabel: 'Refresh server',\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tLua.quickRefresh(type, server.i)\n\t\t\t\t},\n\t\t\t},\n\t\t\t{\n\t\t\t\tlabel: 'Copy IP to clipboard',\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tSteamOverlayAPI.CopyTextToClipboard(server.ipPort)\n\t\t\t\t\tUiToolkitAPI.HideTextTooltip()\n\t\t\t\t\tUiToolkitAPI.ShowTextTooltipOnPanel(\n\t\t\t\t\t\tsrv.FindChildTraverse('name'),\n\t\t\t\t\t\t'Copied to clipboard'\n\t\t\t\t\t)\n\t\t\t\t\t$.Schedule(1, () => UiToolkitAPI.HideTextTooltip())\n\t\t\t\t},\n\t\t\t},\n\t\t\t{\n\t\t\t\tlabel: listText,\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tlet fn = Lua.addToFavorites\n\t\t\t\t\tif (type === Types.favorites) {\n\t\t\t\t\t\tfn = Lua.removeFromFavorites\n\t\t\t\t\t} else if (type === Types.history) {\n\t\t\t\t\t\tfn = Lua.removeFromHistory\n\t\t\t\t\t}\n\t\t\t\t\tfn(server.appId, server.ip, server.port, server.queryPort)\n\t\t\t\t},\n\t\t\t},\n\t\t\t{\n\t\t\t\tlabel:\n\t\t\t\t\tfilter.map === server.map\n\t\t\t\t\t\t? 'Remove map filter'\n\t\t\t\t\t\t: `Only show servers on ${\n\t\t\t\t\t\t\t\tserver.map.length < 12 ? server.map : 'this map'\n\t\t\t\t\t\t\t}`,\n\t\t\t\tjsCallback: () => {\n\t\t\t\t\tlet origFilter = this.filters[type]\n\t\t\t\t\tlet alreadyFiltered = origFilter.map === server.map\n\t\t\t\t\tlet filter = Object.assign({}, origFilter, {\n\t\t\t\t\t\tmap: alreadyFiltered ? '' : server.map,\n\t\t\t\t\t})\n\n\t\t\t\t\tLua.saveFilters(type, filter)\n\t\t\t\t\t$.Schedule(0.1, () => Lua.refresh(type))\n\t\t\t\t},\n\t\t\t},\n\t\t]\n\t\tsrv.SetPanelEvent('onactivate', () => {\n\t\t\tthis.selectServer(type, server.uid, srv)\n\t\t})\n\t\tsrv.SetPanelEvent('ondblclick', () => {\n\t\t\tthis.connectToServer(server)\n\t\t})\n\t\tsrv.SetPanelEvent('oncontextmenu', () => {\n\t\t\tthis.selectServer(type, server.uid, srv)\n\t\t\tUiToolkitAPI.ShowSimpleContextMenu('', `ServerContextMenu`, contextMenu)\n\t\t})\n\t},\n\n\t// sort lol\n\tsortColumn: '',\n\tsortDirection: 'asc',\n\tupdateHeaders() {\n\t\tlet sortName = this.panelMain.FindChildTraverse('sort-name')\n\t\tlet sortPlayers = this.panelMain.FindChildTraverse('sort-players')\n\t\tlet sortMap = this.panelMain.FindChildTraverse('sort-map')\n\t\tlet sortPing = this.panelMain.FindChildTraverse('sort-ping')\n\t\tsortName.visible = false\n\t\tsortPlayers.visible = false\n\t\tsortMap.visible = false\n\t\tsortPing.visible = false\n\n\t\tlet sortEl\n\n\t\tswitch (this.sortColumn) {\n\t\t\tcase 'serverName':\n\t\t\t\tsortEl = sortName\n\t\t\t\tbreak\n\t\t\tcase 'players':\n\t\t\t\tsortEl = sortPlayers\n\t\t\t\tbreak\n\t\t\tcase 'map':\n\t\t\t\tsortEl = sortMap\n\t\t\t\tbreak\n\t\t\tcase 'ping':\n\t\t\t\tsortEl = sortPing\n\t\t\t\tbreak\n\t\t\tdefault:\n\t\t\t\tsortEl = null\n\t\t\t\tbreak\n\t\t}\n\t\tif (!sortEl) return\n\t\tsortEl.visible = true\n\n\t\tsortEl.style.paddingTop = this.sortDirection === 'asc' ? '4px' : '5px'\n\t\tsortEl.style.transform =\n\t\t\tthis.sortDirection === 'asc' ? 'rotateZ(0deg)' : 'rotateZ(180deg)'\n\t},\n\tgetSortFunction() {\n\t\tif (this.sortColumn === '')\n\t\t\treturn () => {\n\t\t\t\treturn 0\n\t\t\t}\n\n\t\tconst numericSort = (a, b) => {\n\t\t\tif (this.sortDirection === 'asc') [a, b] = [b, a]\n\t\t\treturn a[this.sortColumn] - b[this.sortColumn]\n\t\t}\n\t\tconst stringSort = (a, b) => {\n\t\t\tif (this.sortDirection === 'asc') [a, b] = [b, a]\n\t\t\tlet av = a[this.sortColumn],\n\t\t\t\tbv = b[this.sortColumn]\n\t\t\tif (av < bv) return -1\n\t\t\tif (av > bv) return 1\n\t\t\treturn 0\n\t\t}\n\n\t\tif (this.sortColumn === 'serverName' || this.sortColumn === 'map')\n\t\t\treturn stringSort\n\n\t\treturn numericSort\n\t},\n\tresort(type = this.selectedType, rerender = true) {\n\t\tconst sortFn = this.getSortFunction()\n\t\tlet panelServers = this.panelServerLists[type]\n\t\tthis.serverLists[type].sort((a, b) => {\n\t\t\tlet retval = sortFn(a, b)\n\n\t\t\tif (!rerender) {\n\t\t\t\tlet elA = panelServers.FindChild(`server-${a.uid}`)\n\t\t\t\tlet elB = panelServers.FindChild(`server-${b.uid}`)\n\t\t\t\tif (elA && elB && retval !== 0) {\n\t\t\t\t\tif (retval < 0) {\n\t\t\t\t\t\tpanelServers.MoveChildBefore(elA, elB)\n\t\t\t\t\t} else {\n\t\t\t\t\t\tpanelServers.MoveChildAfter(elA, elB)\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t\treturn retval\n\t\t})\n\t\tthis.updateHeaders()\n\t\tif (rerender) this.rerender(type)\n\t},\n\trerender(type = this.selectedType) {\n\t\tthis.panelServerLists[type].Children().forEach(destroyAllPanels)\n\t\tfor (let server of this.serverLists[type]) {\n\t\t\tthis.addServer(type, server, true)\n\t\t}\n\t},\n\n\t// popup\n\teditFilters(type = this.selectedType) {\n\t\tlet callback = UiToolkitAPI.RegisterJSCallback((filters) => {\n\t\t\tLua.saveFilters(type, filters)\n\t\t})\n\n\t\tlet parameters = Object.assign({}, { callback }, this.filters[type])\n\n\t\tlet panelPopup = UiToolkitAPI.ShowGlobalCustomLayoutPopupParameters(\n\t\t\t'',\n\t\t\t'',\n\t\t\tthis.urlEncode(parameters)\n\t\t)\n\t\tpanelPopup.BLoadLayoutFromString(POPUP_FILTERS_LAYOUT, false, false)\n\t},\n\n\t// events\n\tplayCommunityPressed() {\n\t\t//this.playTopNavDropdown.SetSelected('PlayCommunity')\n\t\tthis.open()\n\t},\n\tquickRefreshPressed() {\n\t\tlet srv = this.getSelectedServerObj()\n\t\tif (!srv) return\n\t\tLua.quickRefresh(this.selectedType, srv.i)\n\t\tthis.updateButtonState()\n\t},\n\trefreshPressed() {\n\t\tlet refreshing = this.isRefreshing()\n\t\tif (refreshing) {\n\t\t\tLua.stopRefresh(this.selectedType)\n\t\t} else {\n\t\t\tLua.refresh(this.selectedType)\n\t\t}\n\t\tthis.updateButtonState()\n\t},\n\tconnectPressed() {\n\t\tlet srv = this.getSelectedServerObj()\n\t\tif (!srv) return\n\t\tthis.connectToServer(srv)\n\t\tthis.updateButtonState()\n\t},\n\teditFiltersPressed() {\n\t\tthis.editFilters()\n\t},\n\topenOldBrowserPressed() {\n\t\tGameInterfaceAPI.ConsoleCommand('gamemenucommand openserverbrowser ')\n\t},\n\ttagsFilterUpdated(type = this.selectedType) {\n\t\tlet tags = $.HTMLEscape(this.txtTags.text, true).toLowerCase()\n\t\tLua.updateTagFilter(type, tags)\n\t},\n\ttagsFilterFocus() {\n\t\tthis.showClickOut(() => {\n\t\t\tthis.tagsFocusStealer.SetFocus()\n\t\t})\n\t},\n\n\tnameHeaderPressed() {\n\t\tthis.sortColumn = 'serverName'\n\t\tthis.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'\n\t\tthis.resort()\n\t},\n\tplayersHeaderPressed() {\n\t\tthis.sortColumn = 'players'\n\t\tthis.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'\n\t\tthis.resort()\n\t},\n\tmapHeaderPressed() {\n\t\tthis.sortColumn = 'map'\n\t\tthis.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'\n\t\tthis.resort()\n\t},\n\tpingHeaderPressed() {\n\t\tthis.sortColumn = 'ping'\n\t\tthis.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc'\n\t\tthis.resort()\n\t},\n\n\t// visibility\n\topen() {\n\t\tif (!this.initialized) return\n\t\tthis.MapSelectionList.visible = false\n\t\tthis.JsQuickSelectParent.visible = false\n\t\tthis.JsQuickSelectParent.GetParent().AddClass('competitive')\n\t\tthis.JsQuickSelectParent.GetParent().AddClass('official')\n\n\t\tthis.settingsContainer.visible = false\n\t\tthis.gameModeSelectionRadios.AddClass('hidden')\n\t\tthis.workshopSearchBar.AddClass('hidden')\n\n\t\tthis.panelMain.visible = true\n\t\tthis.panelSide.visible = true\n\t\tthis.panelTags.visible = true\n\t\tthis.btnContainer.Children().forEach(hidePanels(true))\n\n\t\tthis.selectTab(this.selectedTab)\n\n\t\tthis.isOpen = true\n\t},\n\tclose() {\n\t\tif (!this.initialized) return\n\t\tthis.MapSelectionList.visible = true\n\t\tthis.JsQuickSelectParent.visible = true\n\t\tthis.JsQuickSelectParent.GetParent().RemoveClass('competitive')\n\t\tthis.JsQuickSelectParent.GetParent().RemoveClass('official')\n\n\t\tthis.settingsContainer.visible = true\n\t\tthis.gameModeSelectionRadios.RemoveClass('hidden')\n\t\tthis.workshopSearchBar.RemoveClass('hidden')\n\n\t\tthis.panelMain.visible = this.panelSide.visible = false\n\t\tthis.panelTags.visible = this.panelBtns.visible = false\n\t\tthis.btnContainer.Children().forEach(hidePanels(false))\n\n\t\tthis.isOpen = false\n\t},\n\n\t// Lua -> JS bridge funcs\n\t_clearServerList(type) {\n\t\tthis.panelSide\n\t\t\t.FindChildTraverse(Types[type].toLowerCase())\n\t\t\t.Children()[0].text = `${Types[type]} (0)`\n\t\tthis.selectedServer[type] = ''\n\t\tthis.serverLists[type] = []\n\t\tthis.panelServerLists[type].Children().forEach(destroyAllPanels)\n\t},\n\t_setRefreshing(type, refreshing) {\n\t\tthis.refreshing[type] = refreshing\n\t\tif (!refreshing) {\n\t\t\tthis.resort(type)\n\t\t}\n\t\tthis.updateButtonState()\n\t},\n\t_addServer(type, server) {\n\t\tif (this.filters[type]) {\n\t\t\tlet flt = this.filters[type]\n\t\t\tif (flt.anticheat === 'AntiCheatInsecure' && server.secure) return\n\t\t\tif (flt.latency) {\n\t\t\t\tlet lat = latencyIdToThreshold(flt.latency)\n\t\t\t\tif (server.ping > lat) return\n\t\t\t}\n\t\t}\n\t\tserver.uid = `${type}-${server.i}`\n\t\tserver.ipPort = ipToString(server.ip)\n\t\tif (server.port !== 27015) {\n\t\t\tserver.ipPort += ':'\n\t\t\tserver.ipPort += server.port\n\t\t}\n\t\tif (!this.serverLists[type].find((i) => i.i == server.i))\n\t\t\tthis.serverLists[type].push(server)\n\t\tthis.addServer(type, server)\n\t},\n\t_setFilters(type, filters) {\n\t\tthis.filters[type] = filters\n\t\tif (type === this.selectedType) {\n\t\t\tif (this.txtTags && !this.txtTags.BHasKeyFocus()) {\n\t\t\t\tthis.txtTags.text = filters.tags || ''\n\t\t\t}\n\t\t}\n\t},\n\n\t_clearPlayerList(uid) {\n\t\ttry {\n\t\t\tlet obj = this.playerCallbacks[uid]\n\t\t\tif (!obj) return\n\t\t\tUiToolkitAPI.InvokeJSCallback(obj.callback, 'clearPlayerList', {})\n\t\t} catch (err) {}\n\t},\n\t_playerRefreshStatus(uid, success) {\n\t\ttry {\n\t\t\tlet obj = this.playerCallbacks[uid]\n\t\t\tif (!obj) return\n\t\t\tUiToolkitAPI.InvokeJSCallback(obj.callback, 'playerRefreshStatus', {\n\t\t\t\tsuccess,\n\t\t\t})\n\t\t} catch (err) {}\n\t},\n\t_playerAdded(uid, name, score, timePlayed) {\n\t\ttry {\n\t\t\tlet obj = this.playerCallbacks[uid]\n\t\t\tif (!obj) return\n\t\t\tUiToolkitAPI.InvokeJSCallback(obj.callback, 'playerAdded', {\n\t\t\t\tname,\n\t\t\t\tscore,\n\t\t\t\ttimePlayed,\n\t\t\t})\n\t\t} catch (err) {}\n\t},\n}\n\nLua.init()\nbrowser.init()\n\nhooks.new(GameInterfaceAPI, 'ConsoleCommand', function (cmd) {\n\tif (\n\t\tcmd === 'gamemenucommand openserverbrowser' &&\n\t\t!MatchStatsAPI.IsConnectedToCommunityServer()\n\t) {\n\t\tif (!browser.initialized) {\n\t\t\tbrowser.init()\n\t\t\tbrowser.open()\n\t\t}\n\t\treturn\n\t}\n\treturn this.orig(cmd)\n})\n\nreturn {\n\tshutdown: () => {\n\t\ttry {\n\t\t\thooks.destroy()\n\t\t} catch (err) {\n\t\t\t$.Msg('Error while destroying hooks: ' + err.toString())\n\t\t}\n\t\ttry {\n\t\t\tbrowser.destroy()\n\t\t} catch (err) {\n\t\t\t$.Msg('Error while destroying browser: ' + err.toString())\n\t\t}\n\t\tUiToolkitAPI.CloseAllVisiblePopups()\n\t},\n\tClearServerList: (type) => browser._clearServerList(type),\n\tRefreshStatus: (type, refreshing) => browser._setRefreshing(type, refreshing),\n\tServerAdded: (type, server) => browser._addServer(type, server),\n\tGetFilters: (type, filters) => browser._setFilters(type, filters),\n\tClearPlayerList: (uid) => browser._clearPlayerList(uid),\n\tPlayerRefreshStatus: (uid, success) =>\n\t\tbrowser._playerRefreshStatus(uid, success),\n\tPlayerAdded: (uid, name, score, timePlayed) =>\n\t\tbrowser._playerAdded(uid, name, score, timePlayed),\n}\n", "CSGOMainMenu")()

local function var_0_16(arg_3_0)
	return tonumber(var_0_2.cast("uintptr_t", arg_3_0))
end

local function var_0_17(arg_4_0, arg_4_1, arg_4_2)
	return {
		type = arg_4_0,
		i = arg_4_1,
		ip = tonumber(arg_4_2.m_NetAdr.m_unIP),
		port = tonumber(arg_4_2.m_NetAdr.m_usConnectionPort),
		queryPort = tonumber(arg_4_2.m_NetAdr.m_usQueryPort),
		ping = tonumber(arg_4_2.m_nPing),
		successful = arg_4_2.m_bHadSuccessfulResponse == true,
		doNotRefresh = arg_4_2.m_bDoNotRefresh == true,
		gameDir = var_0_2.string(arg_4_2.m_szGameDir),
		map = var_0_2.string(arg_4_2.m_szMap),
		gameDesc = var_0_2.string(arg_4_2.m_szGameDescription),
		appId = arg_4_2.m_nAppID,
		players = tonumber(arg_4_2.m_nPlayers),
		maxPlayers = tonumber(arg_4_2.m_nMaxPlayers),
		botPlayers = tonumber(arg_4_2.m_nBotPlayers),
		password = arg_4_2.m_bPassword == true,
		secure = arg_4_2.m_bSecure == true,
		timeLastPlayed = tonumber(arg_4_2.m_ulTimeLastPlayed),
		serverVersion = tonumber(arg_4_2.m_nServerVersion),
		serverName = var_0_2.string(arg_4_2.m_szServerName),
		gameTags = var_0_2.string(arg_4_2.m_szGameTags)
	}
end

local var_0_18 = {}

local function var_0_19(arg_5_0)
	for iter_5_0, iter_5_1 in pairs(var_0_18) do
		if iter_5_1.type == arg_5_0 and not iter_5_1.released then
			return iter_5_1
		end
	end

	return nil
end

local var_0_20 = var_0_1.ISteamMatchmakingServerListResponse.new({
	ServerResponded = function(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = var_0_18[var_0_16(arg_6_1)]
		local var_6_1 = var_0_9.GetServerDetails(arg_6_1, arg_6_2)
		local var_6_2 = var_0_17(var_6_0.type, arg_6_2, var_6_1)

		var_0_15.ServerAdded(var_6_0.type, var_6_2)
	end,
	ServerFailedToRespond = function(arg_7_0, arg_7_1, arg_7_2)
		return
	end,
	RefreshComplete = function(arg_8_0, arg_8_1, arg_8_2)
		local var_8_0 = var_0_18[var_0_16(arg_8_1)]

		var_0_15.RefreshStatus(var_8_0.type, false)

		var_8_0.refreshing = false
	end
})

local function var_0_21(arg_9_0)
	if arg_9_0 == "LocationUSE" then
		return "0"
	elseif arg_9_0 == "LocationUSW" then
		return "1"
	elseif arg_9_0 == "LocationSA" then
		return "2"
	elseif arg_9_0 == "LocationEU" then
		return "3"
	elseif arg_9_0 == "LocationAS" then
		return "4"
	elseif arg_9_0 == "LocationAU" then
		return "5"
	elseif arg_9_0 == "LocationME" then
		return "6"
	elseif arg_9_0 == "LocationAF" then
		return "7"
	else
		return "255"
	end
end

local function var_0_22(arg_10_0)
	local var_10_0 = var_0_13.filters[arg_10_0 + 1]
	local var_10_1 = {}
	local var_10_2 = {}
	local var_10_3 = {}
	local var_10_4 = {}
	local var_10_5 = {}
	local var_10_6 = {}
	local var_10_7 = {
		"valve_ds"
	}

	if var_10_0.map then
		table.insert(var_10_1, {
			"map",
			var_10_0.map
		})
	end

	if var_10_0.notEmpty then
		table.insert(var_10_1, {
			"empty",
			"1"
		})
	end

	if var_10_0.notFull then
		table.insert(var_10_1, {
			"full",
			"1"
		})
	end

	if var_10_0.anticheat then
		if var_10_0.anticheat == "AntiCheatSecure" then
			table.insert(var_10_1, {
				"secure",
				"1"
			})
		elseif var_10_0.anticheat == "AntiCheatInsecure" then
			table.insert(var_10_7, "secure")
		end
	end

	if var_10_0.location then
		local var_10_8 = var_0_21(var_10_0.location)

		if var_10_8 ~= "255" then
			table.insert(var_10_1, {
				"region",
				var_10_8
			})
		end
	end

	if var_10_0.tags then
		table.insert(var_10_6, var_10_0.tags)
	end

	if #var_10_2 > 0 then
		table.insert(var_10_1, {
			"and",
			#var_10_2
		})

		for iter_10_0 = 1, #var_10_2 do
			table.insert(var_10_1, var_10_2[iter_10_0])
		end
	end

	if #var_10_3 > 0 then
		table.insert(var_10_1, {
			"or",
			#var_10_3
		})

		for iter_10_1 = 1, #var_10_3 do
			table.insert(var_10_1, var_10_3[iter_10_1])
		end
	end

	if #var_10_4 > 0 then
		table.insert(var_10_1, {
			"nand",
			#var_10_4
		})

		for iter_10_2 = 1, #var_10_4 do
			table.insert(var_10_1, var_10_4[iter_10_2])
		end
	end

	if #var_10_5 > 0 then
		table.insert(var_10_1, {
			"nor",
			#var_10_5
		})

		for iter_10_3 = 1, #var_10_5 do
			table.insert(var_10_1, var_10_5[iter_10_3])
		end
	end

	if #var_10_6 > 0 then
		table.insert(var_10_1, {
			"gametagsand",
			table.concat(var_10_6, ",")
		})
	end

	if #var_10_7 > 0 then
		table.insert(var_10_1, {
			"gametagsnor",
			table.concat(var_10_7, ",")
		})
	end

	return #var_10_1, var_10_1
end

local function var_0_23(arg_11_0)
	local var_11_0, var_11_1 = var_0_22(arg_11_0)
	local var_11_2

	var_11_2[0], var_11_2 = var_0_1.MatchMakingKeyValuePair_t_arr(var_11_0, var_11_1), var_0_2.new("MatchMakingKeyValuePair_t*[1]")

	local var_11_3 = -1

	if arg_11_0 == 0 then
		var_11_3 = var_0_9.RequestInternetServerList(var_0_4, var_11_2, var_11_0, var_0_20)
	elseif arg_11_0 == 1 then
		var_11_3 = var_0_9.RequestFavoritesServerList(var_0_4, var_11_2, var_11_0, var_0_20)
	elseif arg_11_0 == 2 then
		var_11_3 = var_0_9.RequestHistoryServerList(var_0_4, var_11_2, var_11_0, var_0_20)
	elseif arg_11_0 == 3 then
		var_11_3 = var_0_9.RequestSpectatorServerList(var_0_4, var_11_2, var_11_0, var_0_20)
	elseif arg_11_0 == 4 then
		var_11_3 = var_0_9.RequestLANServerList(var_0_4, var_0_20)
	elseif arg_11_0 == 5 then
		var_11_3 = var_0_9.RequestFriendsServerList(var_0_4, var_11_2, var_11_0, var_0_20)
	else
		return -1
	end

	var_0_18[var_0_16(var_11_3)] = {
		refreshing = true,
		released = false,
		handle = var_11_3,
		type = arg_11_0
	}

	return var_0_16(var_11_3)
end

local function var_0_24(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = -1
	local var_12_1 = var_0_1.ISteamMatchmakingPlayersResponse.new({
		AddPlayerToList = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			var_0_15.PlayerAdded(arg_12_0, var_0_2.string(arg_13_1), tonumber(arg_13_2), tonumber(arg_13_3))
		end,
		PlayersFailedToRespond = function(arg_14_0)
			var_0_15.PlayerRefreshStatus(arg_12_0, false)
		end,
		PlayersRefreshComplete = function(arg_15_0)
			var_0_15.PlayerRefreshStatus(arg_12_0, true)

			var_0_18[var_0_16(var_12_0)].refreshing = false
		end
	})

	var_0_15.ClearPlayerList(arg_12_0)

	var_12_0 = var_0_9.PlayerDetails(arg_12_1, arg_12_2, var_12_1)
	var_0_18[var_0_16(var_12_0)] = {
		type = -1,
		refreshing = true,
		handle = var_12_0
	}
end

local function var_0_25(arg_16_0, arg_16_1)
	var_0_9.RefreshQuery(arg_16_1)

	return arg_16_1
end

local function var_0_26(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	var_0_10.AddFavoriteGame(arg_17_0, arg_17_1, arg_17_2, arg_17_3, var_0_7, 0)
end

local function var_0_27(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	var_0_10.RemoveFavoriteGame(arg_18_0, arg_18_1, arg_18_2, arg_18_3, var_0_7)
end

local function var_0_28(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	var_0_10.AddFavoriteGame(0, arg_19_1, arg_19_2, arg_19_3, var_0_8, 0)
end

local function var_0_29(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	var_0_10.RemoveFavoriteGame(0, arg_20_1, arg_20_2, arg_20_3, var_0_8)
end

local function var_0_30(arg_21_0)
	var_0_15.ClearServerList(arg_21_0)
	var_0_15.RefreshStatus(arg_21_0, true)
	var_0_23(arg_21_0)
end

local function var_0_31(arg_22_0)
	for iter_22_0, iter_22_1 in pairs(var_0_18) do
		if iter_22_1.type == arg_22_0 and iter_22_1.refreshing then
			return true, iter_22_0
		end
	end

	return false, 0
end

local function var_0_32(arg_23_0)
	for iter_23_0, iter_23_1 in pairs(var_0_18) do
		if iter_23_1.type == arg_23_0 and iter_23_1.refreshing then
			var_0_9.CancelQuery(iter_23_1.handle)

			iter_23_1.refreshing = false

			var_0_15.RefreshStatus(iter_23_1.type, false)

			return true, iter_23_0
		end
	end

	return false, 0
end

local function var_0_33()
	for iter_24_0, iter_24_1 in pairs(var_0_18) do
		if iter_24_1.refreshing then
			if iter_24_1.type == -1 then
				var_0_9.CancelServerQuery(iter_24_1.handle)
			else
				var_0_9.CancelQuery(iter_24_1.handle)
			end

			iter_24_1.refreshing = false

			var_0_15.RefreshStatus(iter_24_1.type, false)
		end

		if not iter_24_1.released and iter_24_1.type ~= -1 then
			var_0_9.ReleaseRequest(iter_24_1.handle)

			iter_24_1.released = true
		end
	end
end

local function var_0_34(arg_25_0)
	var_0_15.GetFilters(arg_25_0, var_0_13.filters[arg_25_0 + 1])
end

local function var_0_35(arg_26_0)
	local var_26_0 = {
		bit.band(bit.rshift(arg_26_0, 24), 255),
		bit.band(bit.rshift(arg_26_0, 16), 255),
		bit.band(bit.rshift(arg_26_0, 8), 255),
		bit.band(bit.rshift(arg_26_0, 0), 255)
	}

	return table.concat(var_26_0, ".")
end

local function var_0_36(arg_27_0, arg_27_1)
	var_0_11:invoke_callback(arg_27_0 .. ":" .. arg_27_1)
end

local var_0_37 = {
	refresh = function(arg_28_0)
		if var_0_31(arg_28_0) then
			client.error_log("^^ Already refreshing!! ^^")
		else
			local var_28_0 = var_0_19(arg_28_0)

			if var_28_0 then
				if var_28_0.refreshing then
					var_0_9.CancelQuery(var_28_0.handle)

					var_28_0.refreshing = false
				end

				var_0_9.ReleaseRequest(var_28_0.handle)

				var_28_0.released = true
			end

			var_0_30(arg_28_0)
		end
	end,
	stopRefresh = function(arg_29_0)
		var_0_32(arg_29_0)
	end,
	quickRefresh = function(arg_30_0, arg_30_1)
		local var_30_0 = var_0_19(arg_30_0)

		if var_30_0 then
			var_0_9.RefreshServer(var_30_0.handle, arg_30_1)
		end
	end,
	connect = function(arg_31_0, arg_31_1)
		local var_31_0 = var_0_35(arg_31_0)
		local var_31_1 = "27015"

		if type(arg_31_1) == "number" then
			var_31_1 = tostring(arg_31_1)
		end

		var_0_12:set_string("")
		var_0_36(var_31_0, var_31_1)
	end,
	connectWithPassword = function(arg_32_0, arg_32_1, arg_32_2)
		local var_32_0 = var_0_35(arg_32_0)
		local var_32_1 = "27015"

		if type(arg_32_1) == "number" then
			var_32_1 = tostring(arg_32_1)
		end

		if type(arg_32_2) == "string" then
			var_0_12:set_string(arg_32_2)
		end

		var_0_36(var_32_0, var_32_1)
	end,
	requestFilters = function(arg_33_0)
		var_0_34(arg_33_0)
	end,
	saveFilters = function(arg_34_0, arg_34_1)
		arg_34_1 = json.parse(arg_34_1)

		if arg_34_1 == nil then
			return
		end

		local var_34_0 = ""

		if var_0_13.filters[arg_34_0 + 1] then
			var_34_0 = var_0_13.filters[arg_34_0 + 1].tags
		end

		var_0_13.filters[arg_34_0 + 1] = arg_34_1
		var_0_13.filters[arg_34_0 + 1].tags = var_34_0

		var_0_34(arg_34_0)
	end,
	updateTagFilter = function(arg_35_0, arg_35_1)
		var_0_13.filters[arg_35_0 + 1] = var_0_13.filters[arg_35_0 + 1] or {}
		var_0_13.filters[arg_35_0 + 1].tags = arg_35_1

		var_0_34(arg_35_0)
	end,
	addToFavorites = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
		var_0_26(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	end,
	removeFromFavorites = function(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
		var_0_27(arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	end,
	addToHistory = function(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
		var_0_28(arg_38_0, arg_38_1, arg_38_2, arg_38_3)
	end,
	removeFromHistory = function(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
		var_0_29(arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	end,
	requestPlayerList = function(arg_40_0, arg_40_1, arg_40_2)
		var_0_24(arg_40_0, arg_40_1, arg_40_2)
	end
}

for iter_0_0 = 0, 5 do
	var_0_34(iter_0_0)
end

var_0_0.register_event(var_0_5.Refresh, var_0_37.refresh)
var_0_0.register_event(var_0_5.StopRefresh, var_0_37.stopRefresh)
var_0_0.register_event(var_0_5.QuickRefresh, var_0_37.quickRefresh)
var_0_0.register_event(var_0_5.Connect, var_0_37.connect)
var_0_0.register_event(var_0_5.ConnectWithPassword, var_0_37.connectWithPassword)
var_0_0.register_event(var_0_5.RequestFilters, var_0_37.requestFilters)
var_0_0.register_event(var_0_5.SaveFilters, var_0_37.saveFilters)
var_0_0.register_event(var_0_5.UpdateTagFilter, var_0_37.updateTagFilter)
var_0_0.register_event(var_0_5.AddToFavorites, var_0_37.addToFavorites)
var_0_0.register_event(var_0_5.RemoveFromFavorites, var_0_37.removeFromFavorites)
var_0_0.register_event(var_0_5.AddToHistory, var_0_37.addToHistory)
var_0_0.register_event(var_0_5.RemoveFromHistory, var_0_37.removeFromHistory)
var_0_0.register_event(var_0_5.RequestPlayerList, var_0_37.requestPlayerList)
client.set_event_callback("shutdown", function()
	var_0_33()
	var_0_15.shutdown()
	var_0_14()
end)
