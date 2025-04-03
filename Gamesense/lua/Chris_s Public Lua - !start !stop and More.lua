local var_0_0 = require("ffi")
local var_0_1 = require("gamesense/csgo_weapons")
local var_0_2 = require("gamesense/http")
local var_0_3 = require("gamesense/steamworks")
local var_0_4 = require("gamesense/panorama_events")
local var_0_5 = require("gamesense/clipboard")
local var_0_6 = panorama.open()
local var_0_7 = var_0_6["$"]
local var_0_8 = var_0_6.CompetitiveMatchAPI
local var_0_9 = var_0_6.GameStateAPI
local var_0_10 = var_0_6.FriendsListAPI
local var_0_11 = var_0_6.GameTypesAPI
local var_0_12 = var_0_6.PartyListAPI
local var_0_13 = var_0_6.MyPersonaAPI
local var_0_14 = var_0_6.LobbyAPI
local var_0_15 = var_0_6.SteamOverlayAPI
local var_0_16 = var_0_6.TeammatesAPI
local var_0_17 = var_0_3.ISteamFriends
local var_0_18 = {
	items = {}
}
local var_0_19 = database.read("cplua_overrides") or {}

function var_0_18.new(arg_1_0, arg_1_1)
	local var_1_0 = {
		name = arg_1_0,
		state = arg_1_1
	}

	if var_0_19[arg_1_0] then
		var_1_0.state = false
	end

	var_0_18.items[arg_1_0] = var_1_0

	return var_1_0
end

function var_0_18.get(arg_2_0)
	return var_0_18.items[arg_2_0].state
end

var_0_18.new("Panorama Libraries", true)
var_0_18.new("LiveCheck Library", true)
var_0_18.new("Delayed Auto Accept", true)
var_0_18.new("Delayed Connect", true)
var_0_18.new("Auto Accept Detection", true)
var_0_18.new("Auto Derank Score", true)
var_0_18.new("Auto Open CsgoStats.gg", false)
var_0_18.new("Auto Invite Recents", true)
var_0_18.new("Match Start Beep", true)
var_0_18.new("Custom Clantag Builder", true)
var_0_18.new("Custom Killsay Builder", true)
var_0_18.new("Report Enemy Tool", true)
var_0_18.new("Account Checkers", true)
var_0_18.new("Crack Checker", false)
var_0_18.new("Faceit Checker", true)
var_0_18.new("Game Value", true)
var_0_18.new("Inventory Value", true)
var_0_18.new("Banned Friends", true)
var_0_18.new("Name History", true)
var_0_18.new("CSGOStats.gg", true)
var_0_18.new("Whitelist Friends on Key", true)
var_0_18.new("Playerlist Additions", true)
var_0_18.new("Highlight Targets", true)
var_0_18.new("Dev Report Bot", true)
var_0_18.new("Party Chat Utils", true)
var_0_18.new("Chat Commands", true)
var_0_18.new("Raw Chat Print", true)
var_0_18.new("User Data Saving", true)

local var_0_20
local var_0_21 = {}
local var_0_22 = {
	debugMode = false
}

if var_0_18.get("Panorama Libraries") then
	CPPanoramaMainMenu = panorama.loadstring("\t\t$.Schedule(5, $.Msg, 'test')\n\n\t\t// Lobby Chat Utils\n\t\tlet Prefix = '!';\n\t\tlet MsgSteamID = false;\n\t\tlet MySteamID = MyPersonaAPI.GetXuid();\n\t\tlet UserData = {};\n\t\tlet MuteUsers = [];\n\n\t\tconst Utilities = {};\n\n\t\tUtilities.IsBlacklisted = (SteamXUID) => {\n\t\t\tUserData.blacklist = UserData.blacklist || [0];\n\t\t\treturn UserData.blacklist.includes(SteamXUID)\n\t\t}\n\n\t\tUtilities.SayParty = (Message) => {\n\t\t\tlet FilteredMessage = Message.split(' ').join('\\u{00A0}');\n\t\t\tPartyListAPI.SessionCommand('Game::Chat', `run all xuid ${MySteamID} chat ${FilteredMessage}`);\n\t\t}\n\n\t\tlet Keys = [\n\t\t\t'5DA40A4A4699DEE30C1C9A7BCE84C914',\n\t\t\t'5970533AA2A0651E9105E706D0F8EDDC',\n\t\t\t'2B3382EBA9E8C1B58054BD5C5EE1C36A'\n\t\t];\n\t\tlet KeyIndex = 0\n\t\tUtilities.RandomWebKey = () => {\n\t\t\tif ( KeyIndex >= Keys.length ) KeyIndex = 0;\n\t\t\treturn Keys[KeyIndex++]\n\t\t}\n\n\t\t/*\n\t\tfunction resolveVanityURL(vanityurl, callback)\n\t\t\thttp.get('https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1?key=' .. Utilities.RandomWebKeyhttp .. '&vanityurl=' .. vanityurl, function(success, response)\n\t\t\t\tif not success or response.status ~= 200 then return callback(false) end\n\t\t\n\t\t\t\tlocal data = json.parse(response.body)\n\t\t\t\tif data then\n\t\t\t\t\tif not data.response.success == 1 or not data.response.steamid then return callback(false) end\n\t\t\t\t\treturn callback(data.response.steamid)\n\t\t\t\tend\n\t\t\t\treturn callback(false)\n\t\t\tend)\n\t\tend\n\t\t*/\n\n\t\tUtilities.resolveVanityURL = (vanityurl, callback) => {\n\t\t\t$.AsyncWebRequest('https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1?key=' + Utilities.RandomWebKey() + '&vanityurl=' + vanityurl, {\n\t\t\t\ttype:\"GET\",\n\t\t\t\tcomplete:function(e){\n\t\t\t\t\tif ( e.status != 200 ) return;\n\t\t\t\t\tlet Response = e.responseText.substring(0, e.responseText.length-1);\n                    let Data = JSON.parse(Response);\n\t\t\t\t\tif ( Data.response.success ) {\n\t\t\t\t\t\tcallback(Data.response.steamid)\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t});\n\t\t}\n\n\t\tUtilities.FindPlayer = (str, NoOutput, callback) => {\n\t\t\tlet FoundXUID = false;\n\n\t\t\t// Type Checks\n\t\t\tlet regex_steamid64 = /(765\\d{14})/i;\n\t\t\tlet regex_steamid3 = / /i; // idk yet bud, maths is dumb\n\t\t\tlet regex_friendcode = /(\\w{5}-\\w{4})/i;\n\t\t\tlet regex_lobbyindex = /\\d{1}$/i\n\t\t\tlet regex_url = /steamcommunity.com\\/id\\/(.+)$/i;\n\n\t\t\tif ( regex_steamid64.test(str) ) {\n\t\t\t\tFoundXUID = str.match(regex_steamid64)[0];\n\t\t\t} else if ( regex_steamid3.test(str) ) {\n\n\t\t\t} else if ( regex_friendcode.test(str) ) {\n\t\t\t\tFoundXUID = FriendsListAPI.GetXuidFromFriendCode(str.match(regex_friendcode)[0]);\n\t\t\t} else if ( regex_lobbyindex.test(str) ) {\n\t\t\t\tlet LobbyIndex = str.match(regex_lobbyindex)[0]\n\t\t\t\tFoundXUID = PartyListAPI.GetXuidByIndex(LobbyIndex - 1);\n\t\t\t} else if ( regex_url.test(str) && callback ) {\n\t\t\t\tlet vanityURL = str.match(regex_url)[1].replace(/\\/$/, \"\")\n\t\t\t\tUtilities.resolveVanityURL(vanityURL, (steamid)=>{\n\t\t\t\t\tcallback(steamid)\n\t\t\t\t});\n\t\t\t} else if ( typeof str == 'string' ) {\n\t\t\t\tlet TempID;\n\t\t\t\tlet TempCount = 0;\n\t\t\t\tfor ( i=0; i<PartyListAPI.GetCount(); i++ ) {\n\t\t\t\t\tlet MemberSteamID = PartyListAPI.GetXuidByIndex(i);\n\t\t\t\t\tlet MemberName = PartyListAPI.GetFriendName(MemberSteamID);\n\t\t\t\t\tif ( MemberName.toLowerCase().indexOf(str.toLowerCase()) == 0 ) {\n\t\t\t\t\t\tTempID = MemberSteamID;\n\t\t\t\t\t\tTempCount++;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t\tif ( TempCount == 1 ) {\n\t\t\t\t\tFoundXUID = TempID;\n\t\t\t\t} else if ( !NoOutput ) {\n\t\t\t\t\tUtilities.SayParty(`Found ${TempCount} matches for \"${str}\", try being more specific!`)\n\t\t\t\t}\n\t\t\t}\n\t\t\tif ( FoundXUID ) {\n\t\t\t\tif ( callback ) callback(FoundXUID);\n\t\t\t\treturn FoundXUID\n\t\t\t}\n\t\t}\n\n\t\tUtilities.MessageHistory = [];\n\n\t\tfunction AttachHistory() {\n\t\t\tlet elInput = $.GetContextPanel().FindChildTraverse('ChatInput');\n\n\t\t\tlet ChatPanelContainer = $.GetContextPanel().FindChildTraverse('ChatPanelContainer');\n\t\t\t\n\t\t\tif ( ChatPanelContainer && elInput ) {\n\t\t\t\tlet Root = ChatPanelContainer.GetParent();\n\n\t\t\t\telInput.ClearPanelEvent('oninputsubmit');\n\n\t\t\t\telInput.SetPanelEvent( 'onfocus', ()=>{\n\t\t\t\t});\n\n\t\t\t\tUtilities.ClearMessageIndex = ()=>{\n\t\t\t\t\tUtilities.MessageIndex = Utilities.MessageHistory.length;\n\t\t\t\t}\n\n\t\t\t\telInput.SetPanelEvent( 'oninputsubmit', ()=>{\n\t\t\t\t\tlet Msg = elInput.text;\n\t\t\t\t\tif ( Msg != '' ) {\n\t\t\t\t\t\tUtilities.MessageHistory.push(Msg);\n\t\t\t\t\t\tUtilities.ClearMessageIndex();\n\t\t\t\t\t}\n\t\t\t\t\telInput.text = Msg.replace(/@[0-9\\w-]+/ig, (match, capture)=>{\n\t\t\t\t\t\tlet FoundXUID = Utilities.FindPlayer(match.substring(1), true)\n\t\t\t\t\t\tif ( FoundXUID ) {\n\t\t\t\t\t\t\treturn PartyListAPI.GetFriendName(FoundXUID)\n\t\t\t\t\t\t}\n\t\t\t\t\t\treturn match\n\t\t\t\t\t});\n\t\t\t\t\tRoot.SubmitChatText()\n\t\t\t\t\telInput.text = \"\";\n\t\t\t\t});\n\t\t\t}\n\t\t}\n\n\t\tAttachHistory()\n\n\t\t$.RegisterForUnhandledEvent(\"PanoramaComponent_Lobby_MatchmakingSessionUpdate\", function(state){\n\t\t\tif(state == 'updated' && PartyListAPI.IsPartySessionActive()){\n\t\t\t\tAttachHistory();\n\t\t\t}\n\t\t});\n\n\t\tlet PartyChatCommands = [];\n\t\t\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Help (!\\u{200B}help)',\n\t\t\tcmds: ['help', 'h'],\n\t\t\ttimeout: 2500,\n\t\t\texec: (cmd, args, sender, steamid) => {\n \t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( args.length == 0 ) {\n\t\t\t\t\tfor ( i=1; i<PartyChatCommands.length; i++ ) {\n\t\t\t\t\t\tlet ChatCommand = PartyChatCommands[i];\n\t\t\t\t\t\tif (ChatCommand.cmds[0] == 'sus')\n\t\t\t\t\t\t\tcontinue;\n\t\t\t\t\t\tconst Title = `» ${ChatCommand.title}`;\n\t\t\t\t\t\tconst Alias = ChatCommand.cmds;\n\t\t\t\t\t\tUtilities.SayParty(Title);\n\t\t\t\t\t}\n\t\t\t\t} else {\n\t\t\t\t\tfor ( i=1; i<PartyChatCommands.length; i++ ) {\n\t\t\t\t\t\tlet ChatCommand = PartyChatCommands[i];\n\t\t\t\t\t\tif (ChatCommand.cmds[0] == 'sus')\n\t\t\t\t\t\t\tcontinue;\n\n\t\t\t\t\t\tconst Alias = ChatCommand.cmds;\n\t\t\t\t\t\tconst FoundAlias = Alias.find(item => item == args[0]);\n\t\t\t\t\t\tif ( FoundAlias ) {\n\t\t\t\t\t\t\tconst AliasString = Alias.join(', ');\n\t\t\t\t\t\t\tconst Title = `» List of Alias's: ${AliasString}`;\n\t\t\t\t\t\t\tUtilities.SayParty(Title);\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Test (!\\u{200B}test)',\n\t\t\tcmds: ['test'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tUtilities.SayParty(`Test successful, sender info: ${sender} | ${steamid}`)\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Sus (!\\u{200B}Displays a sus Lua Coder)',\n\t\t\tcmds: ['sus'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\t// todo: sus stuff below\n\t\t\t\tUtilities.SayParty(`${sender} did you know csmit is a sussy baka? >w<`)\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Start Queue (!\\u{200B}startq)',\n\t\t\tcmds: ['start', 'startq', 'startqueue', 'queue', 'q'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( !LobbyAPI.BIsHost() ) return;\n\t\t\t\t\n\t\t\t\tLobbyAPI.StartMatchmaking(\tMyPersonaAPI.GetMyOfficialTournamentName(),\n\t\t\t\t\tMyPersonaAPI.GetMyOfficialTeamName(),\n\t\t\t\t\t'',\n\t\t\t\t\t''\n\t\t\t\t);\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Stop Queue (!\\u{200B}stopq)',\n\t\t\tcmds: ['stop', 'stopq', 'stopqueue', 'sq', 's'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tLobbyAPI.StopMatchmaking()\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Restart Queue (!\\u{200B}restartq)',\n\t\t\tcmds: ['restart', 'restartq', 'restartqueue', 'rs'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( !LobbyAPI.BIsHost() ) return;\n\t\t\t\tLobbyAPI.StopMatchmaking()\n\t\t\t\t$.Schedule(1, ()=>{\n\t\t\t\t\t/*let settings = LobbyAPI.IsSessionActive() ? LobbyAPI.GetSessionSettings() : null;\n\t\t\t\t\tlet stage = '';\n\t\t\t\t\tif ( settings && settings.game && settings.options\n\t\t\t\t\t\t&& settings.options.server !== 'listen'\n\t\t\t\t\t\t&& settings.game.mode === 'competitive'\n\t\t\t\t\t\t&& settings.game.mapgroupname.includes( 'mg_lobby_mapveto' ) ) {\n\t\t\t\t\t\tstage = '';\n\t\t\t\t\t}*/\n\n\t\t\t\t\tLobbyAPI.StartMatchmaking(\tMyPersonaAPI.GetMyOfficialTournamentName(),\n\t\t\t\t\t\tMyPersonaAPI.GetMyOfficialTeamName(),\n\t\t\t\t\t\t'',\n\t\t\t\t\t\t''\n\t\t\t\t\t);\n\t\t\t\t});\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Posts a random chuck norris fact (!\\u{200B}chucknorris)',\n\t\t\tcmds: ['cfact', 'fact', 'chucknorris'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\t$.AsyncWebRequest('https://api.chucknorris.io/jokes/random', {\n\t\t\t\t\ttype:\"GET\",\n\t\t\t\t\tcomplete:function(e){\n\t\t\t\t\t\tif ( e.status != 200 ) return;\n\t\t\t\t\t\tlet Response = e.responseText.substring(0, e.responseText.length-1);\n\t\t\t\t\t\tlet Data = JSON.parse(Response);\n\t\t\t\t\t\tif ( Data ) {\n\t\t\t\t\t\t\tUtilities.SayParty(Data.value)\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\t\t\t});\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Reset Lobby (!\\u{200B}resetlobby)',\n\t\t\tcmds: ['resetlobby', 'relobby', 'rl'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\tlet Settings = LobbyAPI.GetSessionSettings();\n\t\t\t\tlet GameMode = Settings.game.mode;\n\t\t\t\tlet GameType = Settings.game.type;\n\t\t\t\tlet MapGroupName = Settings.game.mapgroupname;\n\t\t\t\tlet MySteamID = MyPersonaAPI.GetXuid();\n\n\t\t\t\tif ( steamid != MySteamID ) return;\n\n\t\t\t\t// Get Lobby Players\n\t\t\t\tlet SteamIDs = [];\n\t\t\t\tfor ( i=0; i<Settings.members.numMachines; i++ ) {\n\t\t\t\t\tlet Player = Settings.members[`machine${i}`];\n\t\t\t\t\tlet PlayerSteamID = Player.id;\n\n\t\t\t\t\tif ( MySteamID != PlayerSteamID ) {\n\t\t\t\t\t\tSteamIDs.push(PlayerSteamID)\n\t\t\t\t\t}\n\t\t\t\t}\n\n\t\t\t\tLobbyAPI.CloseSession();\n\n\t\t\t\tfor ( i=0; i<SteamIDs.length; i++ ) {\n\t\t\t\t\tFriendsListAPI.ActionInviteFriend(SteamIDs[i], '');\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Maps (!\\u{200B}maps dust2, safehouse)',\n\t\t\tcmds: ['maps', 'map', 'setmaps', 'changemap', 'changemaps'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( !UserData.mods.indexOf(steamid) ) return;\n\t\t\t\tif ( !LobbyAPI.BIsHost() ) return;\n\t\t\t\t\n\t\t\t\tlet Config = GameTypesAPI.GetConfig();\n\t\t\t\tlet SessionSettings = LobbyAPI.GetSessionSettings();\n\t\t\t\tlet GameMode = SessionSettings.game.mode;\n\t\t\t\tlet GameType = SessionSettings.game.type;\n\n\t\t\t\tlet MapsInGroup = Config.gameTypes[GameType].gameModes[GameMode].mapgroupsMP;\n\t\t\t\tlet MapList = [];\n\n\t\t\t\tif ( args[0] == 'all' ) {\n\t\t\t\t\tdelete MapsInGroup['mg_lobby_mapveto'];\n\t\t\t\t\tMapList = Object.keys(MapsInGroup)\n\t\t\t\t} else {\n\t\t\t\t\tlet Maps = args.join(',').split(',');\n\t\t\t\t\tlet FilteredMaps = [];\n\t\t\t\t\tMaps.forEach((map, index)=>{\n\t\t\t\t\t\tif ( map.trim() != '' ) {\n\t\t\t\t\t\t\tFilteredMaps.push(map)\n\t\t\t\t\t\t}\n\t\t\t\t\t});\n\n\t\t\t\t\tlet FoundMaps = {};\n\t\t\t\t\tFilteredMaps.forEach((SearchMap, key)=>{\n\t\t\t\t\t\tfor (Map in MapsInGroup) {\n\t\t\t\t\t\t\tlet MapName = GameTypesAPI.GetFriendlyMapName(Map.substr(3));\n\t\t\t\t\t\t\tif ( Map.indexOf('scrimmage') == -1 && ( MapName.toLowerCase().indexOf(SearchMap.trim().toLowerCase()) != -1 || Map.toLowerCase().search(SearchMap.toLowerCase()) != -1 ) ) {\n\t\t\t\t\t\t\t\tFoundMaps[Map] = true;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t} \n\t\t\t\t\t});\n\t\t\t\t\t\n\t\t\t\t\tfor ( Map in FoundMaps ) {\n\t\t\t\t\t\tMapList.push(Map);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t\t\n\t\t\t\tif ( MapList.length > 0 ) {\n\t\t\t\t\tPartyListAPI.UpdateSessionSettings(`Update/Game/mapgroupname ${MapList}`);\n\t\t\t\t} \n\t\t\t}\n\t\t});\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Gamemode (!\\u{200B}mode wm)',\n\t\t\tcmds: ['mode', 'gm', 'gamemode', 'mm', 'wm'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( !LobbyAPI.BIsHost() ) return;\n\n\t\t\t\tlet SessionSettings = LobbyAPI.GetSessionSettings();\n\t\t\t\tlet GameMode = SessionSettings.game.mode;\n\t\t\t\tlet GameType = SessionSettings.game.type;\n\n\t\t\t\tlet settings = { update : { Game: { } } }\n\n\t\t\t\t// I would use a switch case, but I want to do regex\n\t\t\t\tif ( cmd == 'mm' || ( args.length > 0 && /(comp.*|5(x|v)5|mm)/i.test(args[0]) ) ) {\n\t\t\t\t\tsettings.update.Game.mode = 'competitive'\n\t\t\t\t\tsettings.update.Game.type = 'classic'\n\t\t\t\t} else if ( cmd == 'wm' || ( args.length > 0 && /(wing.*|2(x|v)2|wm)/i.test(args[0]) ) ) {\n\t\t\t\t\tsettings.update.Game.mode = 'scrimcomp2v2'\n\t\t\t\t\tsettings.update.Game.type = 'classic'\n\t\t\t\t}\n\n\t\t\t\tLobbyAPI.UpdateSessionSettings( settings );\n\t\t\t}\n\t\t});\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'clearchat (!\\u{200B}clearchat)',\n\t\t\tcmds: ['clearchat', 'clear', 'cc', 'cl', 'deletechat', 'delchat', 'deletechat'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( steamid != MyPersonaAPI.GetXuid() ) return;\n\n\t\t\t\tlet party_chat = $.GetContextPanel().FindChildTraverse(\"PartyChat\")\n\t\t\t\tif(party_chat) {\n\t\t\t\t\tlet chat_lines = party_chat.FindChildTraverse(\"ChatLinesContainer\")\n\t\t\t\t\tif(chat_lines) {\n\t\t\t\t\t\t//chat_lines.RemoveAndDeleteChildren();\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Kick (!\\u{200B}kick <partial:name>|<steamid>|<friendcode>)',\n\t\t\tcmds: ['kick'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tif ( !LobbyAPI.BIsHost() ) return;\n\t\t\t\tif ( steamid != LobbyAPI.GetHostSteamID() && !UserData.mods.indexOf(steamid) ) return;\n\n\t\t\t\tUserData.mods = UserData.mods || [0];\n\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tlet KickXUID = Utilities.FindPlayer(args[0]);\n\t\t\t\t\tif ( KickXUID && LobbyAPI.GetHostSteamID() != KickXUID && LobbyAPI.IsPartyMember(KickXUID) ) {\n\t\t\t\t\t\tLobbyAPI.KickPlayer(KickXUID);\n\t\t\t\t\t\tlet Name = FriendsListAPI.GetFriendName(KickXUID);\n\t\t\t\t\t\tUtilities.SayParty(`Kicked ${Name} (${KickXUID}) from the lobby!`);\n\t\t\t\t\t} else if ( LobbyAPI.GetHostSteamID() == KickXUID ) {\n\t\t\t\t\t\tUtilities.SayParty(`You are unable to kick the host!`);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\t\n\t\tRandNumber = 3\n\t\tPartyChatCommands.push({\n            title: 'Roll a number between 1 and 6 (!\\u{200B}roll)',\n            cmds: ['roll'],\n            exec: (cmd, args, sender, steamid) => {\n                if ( Utilities.IsBlacklisted(steamid) ) return;\n                let currentNumber = Math.floor(Math.random() * (6-1)) + 1;\n                if (currentNumber == 1 && currentNumber == RandNumber) {\n                    Utilities.SayParty(`${sender} rolled a ${currentNumber} ... snake eyes!`)\n                } else {\n                    Utilities.SayParty(`${sender} rolled a ${currentNumber}`)\n\t\t\t\t}\n                RandNumber = currentNumber;\n            }\n        });\n\n\t\tPartyChatCommands.push({\n            title: 'Am i gay?! (!\\u{200B}gay)',\n            cmds: ['gay'],\n            exec: (cmd, args, sender, steamid) => {\n                if ( Utilities.IsBlacklisted(steamid) ) return;\n                let currentNumber = Math.floor(Math.random() * (2-0)) + 1;\n\t\t\t\tif (currentNumber == 2) {\n                    Utilities.SayParty(`${sender} is gay`)\n\t\t\t\t} else {\n                    Utilities.SayParty(`${sender} is not gay`)\n\t\t\t\t}\n                RandNumber = currentNumber;\n            }\n        });\n\n\t\tPartyChatCommands.push({\n            title: 'Invades Issue??',\n            cmds: ['invades'],\n            exec: (cmd, args, sender, steamid) => {\n                if ( Utilities.IsBlacklisted(steamid) ) return;\n                Utilities.SayParty(`issue`)\n            }\n        });\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'check how much the person loves you! (!\\u{200B}lovecalc <partial:name>|<steamid>|<friendcode>)',\n\t\t\tcmds: ['lovecalc', 'lc', 'love'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tUserData.mods = UserData.mods || [0];\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tlet LoveXUID = Utilities.FindPlayer(args[0]);\n\t\t\t\t\tif ( LoveXUID && LobbyAPI.GetHostSteamID() ) {\n\t\t\t\t\t\tlet Name = FriendsListAPI.GetFriendName(LoveXUID);\n\t\t\t\t\t\tlet currentNumber = ((Number(LoveXUID.substr(3)) + Number(steamid.substr(3)) + 8) % 100) + 1;\n\t\t\t\t\t\tif (currentNumber == 69 && RandNumber)\n\t\t\t\t\t\tUtilities.SayParty(`${Name} loves ${sender} to ${currentNumber}% Nice, haha funny number!`);\n\t\t\t\t\telse\n\t\t\t\t\t\tUtilities.SayParty(`${Name} loves ${sender} to ${currentNumber}%`);\n\t\t\t\t\t\tRandNumber = currentNumber;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'check your pp size or someone elses! (!\\u{200B}ppsize <partial:name>|<steamid>|<friendcode>)',\n\t\t\tcmds: ['ppsize', 'pp'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tUserData.mods = UserData.mods || [0];\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tlet funnypp = Utilities.FindPlayer(args[0]);\n\t\t\t\t\tif ( funnypp && LobbyAPI.GetHostSteamID() ) {\n\t\t\t\t\t\tlet Name = FriendsListAPI.GetFriendName(funnypp);\n\t\t\t\t\t\tlet currentNumber = Math.floor(Math.random() * (30-1)) +1;\n\t\t\t\t\t\tif (currentNumber == 1 && RandNumber)\n\t\t\t\t\t\tUtilities.SayParty(`${Name}'s pp is ${currentNumber}cm >w< so cute`);\n\t\t\t\t\telse\n\t\t\t\t\t\tUtilities.SayParty(`${Name}'s pp is ${currentNumber}cm long`);\n\t\t\t\t\t\tRandNumber = currentNumber;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Check (!\\u{200B}Check <steamid>|<friendcode>)',\n\t\t\tcmds: ['check'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tUtilities.FindPlayer(args[0], false, (steamid)=>{\n\t\t\t\t\t\tlet Name = FriendsListAPI.GetFriendName(steamid);\n\t\t\t\t\t\tUtilities.SayParty('[LiveCheck] Please wait 5 seconds. Checking...');\n\t\t\t\t\t\tLiveCheck.start(steamid, (data)=>{\n\t\t\t\t\t\t\tlet msg = '[LiveCheck] ';\n\t\t\t\t\t\t\tif ( data ) { \n\t\t\t\t\t\t\t\tmsg += `${Name} is in-${data.state} `\n\t\t\t\t\t\t\t\tif ( data.state == 'lobby' ) {\n\t\t\t\t\t\t\t\t\tmsg += 'queuing '\n\t\t\t\t\t\t\t\t\tlet Maps = data.mapgroupname.split(',');\n\t\t\t\t\t\t\t\t\tlet CleanMaps = [];\n\t\t\t\t\t\t\t\t\tfor ( i=0; i<Maps.length; i++ ) {\n\t\t\t\t\t\t\t\t\t\tlet TextClean = Maps[i].substr(3, Maps[i].length);\n\t\t\t\t\t\t\t\t\t\tCleanMaps[i] = GameTypesAPI.GetFriendlyMapName(TextClean);\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\tmsg += CleanMaps.join(', ');\n\t\t\t\t\t\t\t\t} else if ( data.state == 'game' ) {\n\t\t\t\t\t\t\t\t\tmsg += `playing ${data.map} - ${data.status}`\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\tmsg += ` Found no rich presence for ${steamid}`;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tUtilities.SayParty(msg);\n\t\t\t\t\t\t})\n\t\t\t\t\t});\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\n\t\t// CountryNames thanks to sapphryus\n\t\tlet CountryNames = {KW:\"Kuwait\",MA:\"Morocco \",AF:\"Afghanistan\",AL:\"Albania\",DZ:\"Algeria\",AS:\"American Samoa\",AD:\"Andorra\",AO:\"Angola\",AI:\"Anguilla\",AQ:\"Antarctica\",AG:\"Antigua and Barbuda\",AR:\"Argentina\",AM:\"Armenia\",AW:\"Aruba\",AU:\"Australia\",AT:\"Austria\",AZ:\"Azerbaijan\",BS:\"Bahamas\",BH:\"Bahrain\",BD:\"Bangladesh\",BB:\"Barbados\",BY:\"Belarus\",BE:\"Belgium\",BZ:\"Belize\",BJ:\"Benin\",BM:\"Bermuda\",BT:\"Bhutan\",BO:\"Bolivia\",BA:\"Bosnia and Herzegovina\",BW:\"Botswana\",BV:\"Bouvet Island\",BR:\"Brazil\",IO:\"British Indian Ocean Territory\",BN:\"Brunei Darussalam\",BG:\"Bulgaria\",BF:\"Burkina Faso\",BI:\"Burundi\",KH:\"Cambodia\",CM:\"Cameroon\",CA:\"Canada\",CV:\"Cape Verde\",KY:\"Cayman Islands\",CF:\"Central African Republic\",TD:\"Chad\",CL:\"Chile\",CN:\"China\",CX:\"Christmas Island\",CC:\"Cocos (Keeling) Islands\",CO:\"Colombia\",KM:\"Comoros\",CG:\"Congo\",CD:\"Congo, the Democratic Republic of the\",CK:\"Cook Islands\",CR:\"Costa Rica\",CI:\"Cote D'Ivoire\",HR:\"Croatia\",CU:\"Cuba\",CY:\"Cyprus\",CZ:\"Czech Republic\",DK:\"Denmark\",DJ:\"Djibouti\",DM:\"Dominica\",DO:\"Dominican Republic\",EC:\"Ecuador\",EG:\"Egypt\",SV:\"El Salvador\",GQ:\"Equatorial Guinea\",ER:\"Eritrea\",EE:\"Estonia\",ET:\"Ethiopia\",FK:\"Falkland Islands (Malvinas)\",FO:\"Faroe Islands\",FJ:\"Fiji\",FI:\"Finland\",FR:\"France\",GF:\"French Guiana\",PF:\"French Polynesia\",TF:\"French Southern Territories\",GA:\"Gabon\",GM:\"Gambia\",GE:\"Georgia\",DE:\"Germany\",GH:\"Ghana\",GI:\"Gibraltar\",GR:\"Greece\",GL:\"Greenland\",GD:\"Grenada\",GP:\"Guadeloupe\",GU:\"Guam\",GT:\"Guatemala\",GN:\"Guinea\",GW:\"Guinea-Bissau\",GY:\"Guyana\",HT:\"Haiti\",HM:\"Heard Island and Mcdonald Islands\",VA:\"Holy See (Vatican City State)\",HN:\"Honduras\",HK:\"Hong Kong\",HU:\"Hungary\",IS:\"Iceland\",IN:\"India\",ID:\"Indonesia\",IR:\"Iran, Islamic Republic of\",IQ:\"Iraq\",IE:\"Ireland\",IL:\"Israel\",IT:\"Italy\",JM:\"Jamaica\",JP:\"Japan\",JO:\"Jordan\",KZ:\"Kazakhstan\",KE:\"Kenya\",KI:\"Kiribati\",KP:\"North Korea\",KR:\"South Korea\",KW:\"Kuwait\",KG:\"Kyrgyzstan\",LA:\"Lao People's Democratic Republic\",LV:\"Latvia\",LB:\"Lebanon\",LS:\"Lesotho\",LR:\"Liberia\",LY:\"Libya\",LI:\"Liechtenstein\",LT:\"Lithuania\",LU:\"Luxembourg\",MO:\"Macao\",MG:\"Madagascar\",MW:\"Malawi\",MY:\"Malaysia\",MV:\"Maldives\",ML:\"Mali\",MT:\"Malta\",MH:\"Marshall Islands\",MQ:\"Martinique\",MR:\"Mauritania\",MU:\"Mauritius\",YT:\"Mayotte\",MX:\"Mexico\",FM:\"Micronesia, Federated States of\",MD:\"Moldova, Republic of\",MC:\"Monaco\",MN:\"Mongolia\",MS:\"Montserrat\",MA:\"Morocco\",MZ:\"Mozambique\",MM:\"Myanmar\",NA:\"Namibia\",NR:\"Nauru\",NP:\"Nepal\",NL:\"Netherlands\",NC:\"New Caledonia\",NZ:\"New Zealand\",NI:\"Nicaragua\",NE:\"Niger\",NG:\"Nigeria\",NU:\"Niue\",NF:\"Norfolk Island\",MK:\"North Macedonia, Republic of\",MP:\"Northern Mariana Islands\",NO:\"Norway\",OM:\"Oman\",PK:\"Pakistan\",PW:\"Palau\",PS:\"Palestinian Territory, Occupied\",PA:\"Panama\",PG:\"Papua New Guinea\",PY:\"Paraguay\",PE:\"Peru\",PH:\"Philippines\",PN:\"Pitcairn\",PL:\"Poland\",PT:\"Portugal\",PR:\"Puerto Rico\",QA:\"Qatar\",RE:\"Reunion\",RO:\"Romania\",RU:\"Russia\",RW:\"Rwanda\",SH:\"Saint Helena\",KN:\"Saint Kitts and Nevis\",LC:\"Saint Lucia\",PM:\"Saint Pierre and Miquelon\",VC:\"Saint Vincent and the Grenadines\",WS:\"Samoa\",SM:\"San Marino\",ST:\"Sao Tome and Principe\",SA:\"Saudi Arabia\",SN:\"Senegal\",SC:\"Seychelles\",SL:\"Sierra Leone\",SG:\"Singapore\",SK:\"Slovakia\",SI:\"Slovenia\",SB:\"Solomon Islands\",SO:\"Somalia\",ZA:\"South Africa\",GS:\"South Georgia and the South Sandwich Islands\",ES:\"Spain\",LK:\"Sri Lanka\",SD:\"Sudan\",SR:\"Suriname\",SJ:\"Svalbard and Jan Mayen\",SZ:\"Eswatini\",SE:\"Sweden\",CH:\"Switzerland\",SY:\"Syrian Arab Republic\",TW:\"Taiwan\",TJ:\"Tajikistan\",TZ:\"Tanzania, United Republic of\",TH:\"Thailand\",TL:\"Timor-Leste\",TG:\"Togo\",TK:\"Tokelau\",TO:\"Tonga\",TT:\"Trinidad and Tobago\",TN:\"Tunisia\",TR:\"Turkey\",TM:\"Turkmenistan\",TC:\"Turks and Caicos Islands\",TV:\"Tuvalu\",UG:\"Uganda\",UA:\"Ukraine\",AE:\"United Arab Emirates\",GB:\"United Kingdom\",US:\"USA\",UM:\"United States Minor Outlying Islands\",UY:\"Uruguay\",UZ:\"Uzbekistan\",VU:\"Vanuatu\",VE:\"Venezuela\",VN:\"Vietnam\",VG:\"Virgin Islands, British\",VI:\"Virgin Islands, U.S.\",WF:\"Wallis and Futuna\",EH:\"Western Sahara\",YE:\"Yemen\",ZM:\"Zambia\",ZW:\"Zimbabwe\",AX:\"Åland Islands\",BQ:\"Bonaire, Sint Eustatius and Saba\",CW:\"Curaçao\",GG:\"Guernsey\",IM:\"Isle of Man\",JE:\"Jersey\",ME:\"Montenegro\",BL:\"Saint Barthélemy\",MF:\"Saint Martin (French part)\",RS:\"Serbia\",SX:\"Sint Maarten (Dutch part)\",SS:\"South Sudan\",XK:\"Kosovo\"}\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Locate (!\\u{200B}locate <partial:name>|<steamid>|<friendcode>)',\n\t\t\tcmds: ['locate', 'locs', 'loc', 'locations', 'location'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tlet XUID = 0;\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tXUID = Utilities.FindPlayer(args[0])\n\t\t\t\t}\n\t\t\t\t\n\n\t\t\t\tlet Settings = LobbyAPI.GetSessionSettings();\n\t\t\t\tfor ( i=0; i<Settings.members.numMachines; i++ ) {\n\t\t\t\t\tlet Player = Settings.members[`machine${i}`];\n\t\t\t\t\tlet PlayerSteamID = Player.id;\n\t\t\t\t\tlet PlayerName = Player.player0.name;\n\t\t\t\t\tlet Location = Player.player0.game.loc;\n\t\t\t\t\tlet LocationFull = CountryNames[Location];\n\n\t\t\t\t\tif ( typeof args[0] == 'undefined' || PlayerSteamID == XUID ) {\n\t\t\t\t\t\tUtilities.SayParty(`[LOCATION] ${PlayerName} is from ${LocationFull}!`);\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Mods (!\\u{200B}mod add <partial:name>|<steamid>|<friendcode>|<lobbyindex>)',\n\t\t\thelpTitle: 'Type \"!mod add <PartialName>\", \"!mod add <SteamID64>\", \"!mod add <FriendCode>\", \"!mod add <LobbyIndex>\"',\n\t\t\thelpExamples: 'Typing \"!mod add 2\" will mod the second person in the lobby, others are pretty easy like \"!mod add csmit\"!',\n\t\t\tcmds: ['mod'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( steamid == MyPersonaAPI.GetXuid() ) {\n\t\t\t\t\tUserData.mods = UserData.mods || [0];\n\t\t\t\t\tswitch(args[0]) {\n\t\t\t\t\t\tcase 'add':\n\t\t\t\t\t\t\tif ( typeof args[1] != 'undefined' ) {\n\t\t\t\t\t\t\t\tlet ModXUID = Utilities.FindPlayer(args[1]);\n\t\t\t\t\t\t\t\tif ( ModXUID ) {\n\t\t\t\t\t\t\t\t\tif ( UserData.mods.indexOf(ModXUID) == -1 ) {\n\t\t\t\t\t\t\t\t\t\tUserData.mods.push(ModXUID);\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(ModXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Added ${FriendName}(${ModXUID}) as a moderator!`);\n\t\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(ModXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Cannot add ${FriendName}(${ModXUID}) as they are already a moderator!`)\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'list':\n\t\t\t\t\t\t\tUserData.mods.forEach((steamid, index)=>{\n\t\t\t\t\t\t\t\tif ( steamid ) {\n\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(steamid);\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`[${index}] ${FriendName} - ${steamid}`);\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t})\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'remove':\n\t\t\t\t\t\t\tif ( typeof args[1] != 'undefined' ) {\n\t\t\t\t\t\t\t\tif ( typeof UserData.mods[ parseInt(args[1]) ] == 'undefined' ) {\n\t\t\t\t\t\t\t\t\tlet ModXUID = Utilities.FindPlayer(args[1]);\n\t\t\t\t\t\t\t\t\tlet FoundIndex = UserData.mods.indexOf(ModXUID);\n\t\t\t\t\t\t\t\t\tif ( ModXUID && FoundIndex != -1 ) {\n\t\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.mods[FoundIndex];\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);\n\t\t\t\t\t\t\t\t\t\tdelete UserData.mods[ FoundIndex ];\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.mods[ parseInt(args[1]) ];\n\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);\n\t\t\t\t\t\t\t\t\tdelete UserData.mods[ parseInt(args[1]) ];\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'clear':\n\t\t\t\t\t\t\tlet TotalMods = UserData.mods.length || 0\n\t\t\t\t\t\t\tUtilities.SayParty(`Cleared ${TotalMods} records (incl removed and existing mods)!`);\n\t\t\t\t\t\t\tUserData.mods = [null];\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tdefault:\n\t\t\t\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\t\t\t\tlet ModXUID = Utilities.FindPlayer(args[0]);\n\t\t\t\t\t\t\t\tif ( ModXUID && ModXUID != MySteamID ) {\n\t\t\t\t\t\t\t\t\tif ( UserData.mods.indexOf(ModXUID) == -1 ) {\n\t\t\t\t\t\t\t\t\t\tUserData.mods.push(ModXUID);\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(ModXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Added ${FriendName} (${ModXUID}) as a moderator!`);\n\t\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\t\tlet FoundIndex = UserData.mods.indexOf(ModXUID);\n\t\t\t\t\t\t\t\t\t\tif ( FoundIndex != -1 ) {\n\t\t\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.mods[FoundIndex];\n\t\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);\n\t\t\t\t\t\t\t\t\t\t\tdelete UserData.mods[ FoundIndex ];\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else if ( ModXUID == MySteamID ) {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Nope! You cannot add yourself to the moderator!`)\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Sorry! I don't know how to decipher: ${args[0]}`)\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t}                \n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Blacklist (!\\u{200B}blacklist <partial:name>|<steamid>|<friendcode>|<lobbyindex>)',\n\t\t\thelpTitle: 'Type \"!blacklist add <PartialName>\", \"!blacklist add <SteamID64>\", \"!blacklist add <FriendCode>\", \"!blacklist add <LobbyIndex>\"',\n\t\t\thelpExamples: 'Typing \"!blacklist add 2\" will blacklist the second person in the lobby, others are pretty easy like \"!blacklist add csmit\"!',\n\t\t\tcmds: ['blacklist', 'bl'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( steamid == MyPersonaAPI.GetXuid() ) {\n\t\t\t\t\tUserData.blacklist = UserData.blacklist || [0];\n\t\t\t\t\tswitch(args[0]) {\n\t\t\t\t\t\tcase 'add':\n\t\t\t\t\t\t\tif ( typeof args[1] != 'undefined' ) {\n\t\t\t\t\t\t\t\tlet BlacklistXUID = Utilities.FindPlayer(args[1]);\n\t\t\t\t\t\t\t\tif ( BlacklistXUID && BlacklistXUID != MySteamID ) {\n\t\t\t\t\t\t\t\t\tif ( UserData.blacklist.indexOf(BlacklistXUID) == -1 ) {\n\t\t\t\t\t\t\t\t\t\tUserData.blacklist.push(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Added ${FriendName} (${BlacklistXUID}) to blacklist!`);\n\t\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Cannot add ${FriendName}(${BlacklistXUID}) to blacklist!`)\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else if ( BlacklistXUID == MySteamID ) {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Nope! You cannot add yourself to the blacklist!`)\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'list':\n\t\t\t\t\t\t\tUserData.blacklist.forEach((steamid, index)=>{\n\t\t\t\t\t\t\t\tif ( steamid ) {\n\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(steamid);\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`[${index}] ${FriendName} - ${steamid}`);\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t})\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'remove':\n\t\t\t\t\t\t\tif ( typeof args[1] != 'undefined' ) {\n\t\t\t\t\t\t\t\tif ( typeof UserData.blacklist[ parseInt(args[1]) ] == 'undefined' ) {\n\t\t\t\t\t\t\t\t\tlet BlacklistXUID = Utilities.FindPlayer(args[1]);\n\t\t\t\t\t\t\t\t\tlet FoundIndex = UserData.blacklist.indexOf(BlacklistXUID);\n\t\t\t\t\t\t\t\t\tif ( BlacklistXUID && FoundIndex != -1 ) {\n\t\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.blacklist[FoundIndex];\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);\n\t\t\t\t\t\t\t\t\t\tdelete UserData.blacklist[ FoundIndex ];\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.blacklist[ parseInt(args[1]) ];\n\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);\n\t\t\t\t\t\t\t\t\tdelete UserData.blacklist[ parseInt(args[1]) ];\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tcase 'clear':\n\t\t\t\t\t\t\tlet TotalBlacklist = UserData.blacklist.length || 0\n\t\t\t\t\t\t\tUtilities.SayParty(`Cleared ${TotalBlacklist} records (incl removed and existing blacklists)!`);\n\t\t\t\t\t\t\tUserData.blacklist = [0];\n\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\tdefault:\n\t\t\t\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\t\t\t\tlet BlacklistXUID = Utilities.FindPlayer(args[0]);\n\t\t\t\t\t\t\t\tif ( BlacklistXUID && BlacklistXUID != MySteamID ) {\n\t\t\t\t\t\t\t\t\tif ( UserData.blacklist.indexOf(BlacklistXUID) == -1 ) {\n\t\t\t\t\t\t\t\t\t\tUserData.blacklist.push(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Added ${FriendName} (${BlacklistXUID}) to blacklist!`);\n\t\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\t\tlet FoundIndex = UserData.blacklist.indexOf(BlacklistXUID);\n\t\t\t\t\t\t\t\t\t\tif ( FoundIndex != -1 ) {\n\t\t\t\t\t\t\t\t\t\t\tlet FriendSteam = UserData.blacklist[FoundIndex];\n\t\t\t\t\t\t\t\t\t\t\tlet FriendName = FriendsListAPI.GetFriendName(FriendSteam);\n\t\t\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);\n\t\t\t\t\t\t\t\t\t\t\tdelete UserData.blacklist[ FoundIndex ];\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t} else if ( BlacklistXUID == MySteamID ) {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Nope! You cannot add yourself to the blacklist!`)\n\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\tUtilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t}\n\t\t\t\t\t}                \n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Invite (!\\u{200B}invite <steamid>|<friendcode>)',\n\t\t\tcmds: ['inv', 'invite', 'add'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\tUtilities.FindPlayer(args[0], false, (steamid)=>{\n\t\t\t\t\tFriendsListAPI.ActionInviteFriend(steamid, '')\n\t\t\t\t})\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'WhoInvited (!\\u{200B}who <steamid>|<friendcode>)',\n\t\t\tcmds: ['who', 'whoinv', 'whoinvite', 'whoinvited'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\tlet XUID = 0;\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tXUID = Utilities.FindPlayer(args[0])\n\t\t\t\t}\n\n\t\t\t\tif ( XUID != 0 ) {\n\t\t\t\t\tlet LobbyData = LobbyAPI.GetSessionSettings()\n\t\t\t\t\tfor ( i=0; i<LobbyData.members.numMachines; i++ ) {\n\t\t\t\t\t\tlet Machine = LobbyData.members[`machine${i}`]\n\t\t\t\t\t\tif ( Machine && XUID == Machine.id ) {\n\t\t\t\t\t\t\tlet jfriend = Machine['player0'].game.jfriend\n\t\t\t\t\t\t\tlet jfriendName = FriendsListAPI.GetFriendName(jfriend);\n\t\t\t\t\t\t\tlet friendName = FriendsListAPI.GetFriendName(XUID);\n\t\t\t\t\t\t\tif ( jfriend ) {\t\t\n\t\t\t\t\t\t\t\tUtilities.SayParty(`${friendName} was invited by ${jfriendName} (${jfriend})!`);\n\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\tUtilities.SayParty(`Couldn't find who invited ${friendName}!`);\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Mute (!\\u{200B}mute <steamid>|<friendcode>)',\n\t\t\tcmds: ['mute', 'm', 'quiet', 'silence', 'ignore', 'block'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\n\t\t\t\tlet XUID = 0;\n\t\t\t\tif ( typeof args[0] != 'undefined' ) {\n\t\t\t\t\tXUID = Utilities.FindPlayer(args[0])\n\t\t\t\t}\n\n\t\t\t\tif ( XUID != 0 ) {\n\t\t\t\t\tlet friendName = FriendsListAPI.GetFriendName(XUID);\n\t\t\t\t\tMuteUsers.push(XUID);\n\t\t\t\t\tUtilities.SayParty(`${friendName} is now muted!`);\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\t\tPartyChatCommands.push({\n\t\t\ttitle: 'Ping (!\\u{200B}ping <ping> [ <target> ] or !ping)',\n\t\t\tcmds: ['ping', 'maxping', 'p'],\n\t\t\texec: (cmd, args, sender, steamid) => {\n\t\t\t\tif ( Utilities.IsBlacklisted(steamid) ) return;\n\t\t\t\tlet BaseCMD = 'mm_dedicated_search_maxping'\n\t\t\t\tlet MyPing = GameInterfaceAPI.GetSettingString(BaseCMD);\n\n\t\t\t\tif ( /((?:\\d\\s){3}\\d)/.test(MyPing) ) {\n\t\t\t\t\tMyPing = '> 1000'\n\t\t\t\t} else {\n\t\t\t\t\tMyPing = '< ' + Math.trunc(MyPing)\n\t\t\t\t}\n\n\t\t\t\tswitch (args.length) {\n\t\t\t\t\tcase 0:\n\t\t\t\t\t\t// Print current ping\n\t\t\t\t\t\tUtilities.SayParty(`[PING] My ping is: ${MyPing}`);\n\t\t\t\t\t\tbreak;\n\t\t\t\t\tcase 1:\n\t\t\t\t\t\t// Set Ping to Arg0\n\t\t\t\t\t\tlet RequestedPing = Math.trunc(args[0]);\n\t\t\t\t\t\tif ( RequestedPing == '0' ) {\n\t\t\t\t\t\t\tRequestedPing = '0 0 0 4'\n\t\t\t\t\t\t}\n\t\t\t\t\t\tGameInterfaceAPI.ConsoleCommand(`${BaseCMD} ${RequestedPing}`)\n\t\t\t\t\t\tUtilities.SayParty(`[PING] I set ping to: ${RequestedPing}`);\n\t\t\t\t\t\tbreak;\n\t\t\t\t\tcase 2:\n\t\t\t\t\t\t// If Arg1 == Me, set Ping to Arg0\n\t\t\t\t\t\tlet XUID = Utilities.FindPlayer(args[1]);\n\t\t\t\t\t\tif ( XUID != 0 && XUID == MySteamID ) {\n\t\t\t\t\t\t\tlet RequestedPing = Math.trunc(args[0]);\n\t\t\t\t\t\t\tif ( RequestedPing == '0' ) {\n\t\t\t\t\t\t\t\tRequestedPing = '0 0 0 4'\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tGameInterfaceAPI.ConsoleCommand(`${BaseCMD} ${RequestedPing}`)\n\t\t\t\t\t\t\tUtilities.SayParty(`[PING] I set ping to: ${RequestedPing}`);\n\t\t\t\t\t\t}\n\t\t\t\t\t\tbreak;\n\t\t\t\t}\n\t\t\t}\n\t\t});\n\n\t\t// Ignore Initial Chat\n\t\tlet PreprocessChat = () => {\n\t\t\tlet party_chat = $.GetContextPanel().FindChildTraverse(\"PartyChat\")\n\t\t\tif(party_chat) {\n\t\t\t\tlet chat_lines = party_chat.FindChildTraverse(\"ChatLinesContainer\")\n\t\t\t\tif(chat_lines) {\n\t\t\t\t\tchat_lines.Children().reverse().forEach(el => {\n\t\t\t\t\t\tlet child = el.GetChild(0)\n\t\t\t\t\t\tif ( child && child.BHasClass('left-right-flow') && child.BHasClass('horizontal-align-left') ) {\n\t\t\t\t\t\t\tif ( child.GetChildCount() == 2 ) {\n\t\t\t\t\t\t\t\tMsgSteamID = child.Children()[0].steamid;\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tif ( !child.BHasClass('cp_processed') ) {\n\t\t\t\t\t\t\t\tchild.AddClass('cp_processed');\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t}\n\t\t\t\t\t})\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\tPreprocessChat();\n\n\t\tlet ProcessChat = false;\n\t\tlet Shutdown = false;\n\t\tlet Timeouts = [];\n\t\tlet PartyChatLoop = ()=>{\n\t\t\tlet party_chat = $.GetContextPanel().FindChildTraverse(\"PartyChat\")\n\t\t\tif(party_chat) {\n\t\t\t\tlet chat_lines = party_chat.FindChildTraverse(\"ChatLinesContainer\")\n\t\t\t\tif(chat_lines) {\n\t\t\t\t\tchat_lines.Children().forEach(el => {\n\t\t\t\t\t\tlet child = el.GetChild(0)\n\t\t\t\t\t\tif ( child && child.BHasClass('left-right-flow') && child.BHasClass('horizontal-align-left') ) {\n\t\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\t\tif ( child.BHasClass('cp_processed') ) return false;\n\t\t\t\t\t\t\n\t\t\t\t\t\t\t\tlet InnerChild = child.GetChild(child.GetChildCount()-1);\n\t\t\t\t\t\t\t\tif ( InnerChild && InnerChild.text ) {\n\t\t\t\t\t\t\t\t\tlet Sender = $.Localize('{s:player_name}', InnerChild);\n\t\t\t\t\t\t\t\t\tlet Message = $.Localize('{s:msg}', InnerChild);\n\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\t//var Message = InnerChild.text.toLowerCase()\n\t\t\t\t\t\t\t\t\t\n\t\t\t\t\t\t\t\t\tif (!Message.startsWith(Prefix)) return;\n\n\t\t\t\t\t\t\t\t\tif ( child.GetChildCount() == 2 ) {\n\t\t\t\t\t\t\t\t\t\tMsgSteamID = child.Children()[0].steamid;\n\t\t\t\t\t\t\t\t\t}\n\n\n\n\t\t\t\t\t\t\t\t\tif ( MuteUsers.includes(MsgSteamID) ) {\n\t\t\t\t\t\t\t\t\t\t//return el.RemoveAndDeleteChildren();\n\t\t\t\t\t\t\t\t\t}\n\n\t\t\t\t\t\t\t\t\tconst args = Message.slice(Prefix.length).trim().split(' ');\n\t\t\t\t\t\t\t\t\tconst command = args.shift().toLowerCase();\n\n\t\t\t\t\t\t\t\t\tfor ( index=0; index < PartyChatCommands.length; index++ ) {\n\t\t\t\t\t\t\t\t\t\tconst ChatCommand = PartyChatCommands[index];\n\t\t\t\t\t\t\t\t\t\tfor ( i=0; i<ChatCommand.cmds.length; i++ ) {\n\t\t\t\t\t\t\t\t\t\t\tconst Alias = ChatCommand.cmds[i]; \n\t\t\t\t\t\t\t\t\t\t\tif ( Alias == command ) {\n\t\t\t\t\t\t\t\t\t\t\t\tif ( ChatCommand.timeout ) {\n\t\t\t\t\t\t\t\t\t\t\t\t\tif ( Timeouts[ChatCommand] && Date.now() <= Timeouts[ChatCommand] ) {\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\t\t\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\t\t\t\t\t\t\t\tTimeouts[ChatCommand] = Date.now() + ChatCommand.timeout\n\t\t\t\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t\t\t\tChatCommand.exec(command, args, Sender, MsgSteamID)\n\t\t\t\t\t\t\t\t\t\t\t\tbreak;\n\t\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\t} catch(err) {\n\t\t\t\t\t\t\t\t$.Msg('CSLua: Error (probably irrelevent) ', err);\n\t\t\t\t\t\t\t}\n\t\t\t\t\t\t\tif ( child ) child.AddClass('cp_processed');\n\t\t\t\t\t\t}\n\t\t\t\t\t})\n\t\t\t\t}\n\t\t\t}\t\n\t\t}\n\n\t\treturn {\n\t\t\tPartyChatLoop: ()=>{\n\t\t\t\tPartyChatLoop();\n\t\t\t},\n\t\t\tGetUserData: ()=>{\n\t\t\t\treturn JSON.stringify(UserData);\n\t\t\t},\n\t\t\tSetUserData: (data)=>{\n\t\t\t\tUserData = JSON.parse(data);\n\t\t\t\tUserData.mods = typeof UserData.mods == 'undefined' ? [] : Object.values(UserData.mods);\n\t\t\t\tUserData.blacklist = typeof UserData.blacklist == 'undefined' ? [] : Object.values(UserData.blacklist);\n\t\t\t},\n\t\t\tPreviousMessage: ()=>{\n\t\t\t\tlet elInput = $.GetContextPanel().FindChildTraverse('ChatInput');\n\t\t\t\tif ( elInput && Utilities.MessageHistory.length > 0 && Utilities.MessageIndex > 0 ) {\n\t\t\t\t\tif ( elInput.BHasKeyFocus() ) {\n\t\t\t\t\t\telInput.text = Utilities.MessageHistory[Utilities.MessageIndex-- - 1];\n\t\t\t\t\t} else {\n\t\t\t\t\t\tUtilities.MessageIndex = Utilities.MessageHistory.length;\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t},\n\t\t\tNextMessage: ()=>{\n\t\t\t\tlet elInput = $.GetContextPanel().FindChildTraverse('ChatInput');\n\t\t\t\tif ( elInput && Utilities.MessageHistory.length > 0 && Utilities.MessageIndex < Utilities.MessageHistory.length - 1 ) {\n\t\t\t\t\tif ( elInput.BHasKeyFocus() ) {\n\t\t\t\t\t\telInput.text = Utilities.MessageHistory[Utilities.MessageIndex++ + 1];\n\t\t\t\t\t} else {\n\t\t\t\t\t\tUtilities.ClearMessageIndex();\n\t\t\t\t\t}\n\t\t\t\t}\n\t\t\t},\n\t\t\tClearMessageIndex: Utilities.ClearMessageIndex\n\t\t}\n\t", "CSGOMainMenu")()

	if var_0_18.get("Crack Checker") then
		LolzPanorama = panorama.loadstring("\t\t\tvar html\n\t\t\tvar finish_handler\n\t\t\tvar alert_handler\n\t\t\tvar data\n\n\t\t\tvar page_script = `\n\t\t\t\tfunction setCookie(name,value,days) {\n\t\t\t\t\tvar expires = \"\";\n\t\t\t\t\tif (days) {\n\t\t\t\t\t\tvar date = new Date();\n\t\t\t\t\t\tdate.setTime(date.getTime() + (days*24*60*60*1000));\n\t\t\t\t\t\texpires = \"; expires=\" + date.toUTCString();\n\t\t\t\t\t}\n\t\t\t\t\tdocument.cookie = name + \"=\" + (value || \"\")  + expires + \"; path=/\";\n\t\t\t\t}\n\t\t\t\t\n\t\t\t\tsetCookie('xf_market_currency','usd',7);\n\t\t\t\t\n\t\t\t\tvar data = {\n\t\t\t\t\tcookie: document.cookie,\n\t\t\t\t\tuser_agent: navigator.userAgent\n\t\t\t\t}\n\t\t\t\talert(JSON.stringify(data));\n\t\t\t`\n\n\t\t\tvar _Create = function() {\n\t\t\t\tif(html != null) {\n\t\t\t\t\treturn\n\t\t\t\t}\n\n\t\t\t\thtml = $.CreatePanel(\"HTML\", $.GetContextPanel(), \"\", {\n\t\t\t\t\turl: \"https://lolz.guru/\",\n\t\t\t\t\tacceptsinput: \"false\",\n\t\t\t\t\tacceptsfocus: \"false\",\n\t\t\t\t\tmousetracking: \"false\",\n\t\t\t\t\tfocusonhover: \"false\",\n\t\t\t\t\twidth: \"100px\",\n\t\t\t\t\theight: \"100px\",\n\t\t\t\t})\n\t\t\t\thtml.visible = false\n\n\t\t\t\tfinish_handler = $.RegisterEventHandler(\"HTMLFinishRequest\", html, function(a, url, title){\n\t\t\t\t\tif(url == \"https://lolz.guru/\"){\n\t\t\t\t\t\thtml.RunJavascript(page_script)\n\t\t\t\t\t}\n\t\t\t\t});\n\n\t\t\t\talert_handler = $.RegisterEventHandler(\"HTMLJSAlert\", html, function(id, alert_text){\n\t\t\t\t\tif(html != null && id == html.id) {\n\t\t\t\t\t\ttry {\n\t\t\t\t\t\t\tdata = JSON.parse(alert_text)\n\n\t\t\t\t\t\t\thtml.RunJavascript('document.cookie = `df_id=; domain=lolz.guru; path=/; max-age=0; xf_market_currency=usd;`;')\n\n\t\t\t\t\t\t\t// we got cookies, clean up everything\n\t\t\t\t\t\t\t_Destroy()\n\t\t\t\t\t\t} catch(err) {\n\t\t\t\t\t\t\t// silently ignore\n\t\t\t\t\t\t}\n\t\t\t\t\t}\n\t\t\t\t});\n\n\t\t\t}\n\n\t\t\tvar _Destroy = function() {\n\t\t\t\tif(finish_handler != null) {\n\t\t\t\t\t$.UnregisterEventHandler(\"HTMLFinishRequest\", html, finish_handler)\n\t\t\t\t\tfinish_handler = null\n\t\t\t\t}\n\n\t\t\t\tif(alert_handler != null) {\n\t\t\t\t\t$.UnregisterEventHandler(\"HTMLJSAlert\", html, alert_handler)\n\t\t\t\t\talert_handler = null\n\t\t\t\t}\n\n\t\t\t\tif(html != null) {\n\t\t\t\t\thtml.DeleteAsync(0.0)\n\t\t\t\t\thtml = null\n\t\t\t\t}\n\t\t\t}\n\n\t\t\t// just to return the data back to lua\n\t\t\tvar _GetData = function() {\n\t\t\t\treturn data\n\t\t\t}\n\n\t\t\treturn {\n\t\t\t\tcreate: _Create,\n\t\t\t\tdestroy: _Destroy,\n\t\t\t\tget_data: _GetData\n\t\t\t}\n\t\t", "CSGOMainMenu")()
	end

	ReconnectBtn = panorama.loadstring("\t\tvar btnReconnect = $.GetContextPanel().FindChildTraverse( 'MatchmakingReconnect' );\n\n\t\treturn {\n\t\t\tset:(text)=>{btnReconnect.text = text},\n\t\t\treset:()=>{btnReconnect.text = 'RECONNECT'},\n\t\t\tget:()=>btnReconnect.text\n\t\t}\n\t", "CSGOMainMenu")()

	if var_0_18.get("LiveCheck Library") then
		client.delay_call(0, function()
			LiveCheck = {
				datawaiting = {},
				agecheck = {},
				dataready = {}
			}

			function LiveCheck.buildRichPresence(arg_4_0)
				return {
					version = var_0_17.GetFriendRichPresence(arg_4_0, "version"),
					status = var_0_17.GetFriendRichPresence(arg_4_0, "status"),
					state = var_0_17.GetFriendRichPresence(arg_4_0, "game:state"),
					gamemode = var_0_17.GetFriendRichPresence(arg_4_0, "game:mode"),
					mapgroupname = var_0_17.GetFriendRichPresence(arg_4_0, "game:mapgroupname"),
					map = var_0_17.GetFriendRichPresence(arg_4_0, "game:map")
				}
			end

			function LiveCheck.start(arg_5_0, arg_5_1, arg_5_2)
				if not arg_5_1 then
					return
				end

				local var_5_0 = tostring(arg_5_1)
				local var_5_1 = var_0_17.GetFriendRichPresenceKeyCount(var_5_0) > 0 and LiveCheck.buildRichPresence(var_5_0) or false

				LiveCheck.datawaiting[var_5_0] = true

				var_0_17.RequestFriendRichPresence(var_5_0)
				client.delay_call(5, function()
					arg_5_2(var_5_0, LiveCheck.dataready[var_5_0] or var_5_1)
				end)
			end

			var_0_3.set_callback("FriendRichPresenceUpdate_t", function(arg_7_0)
				local var_7_0 = arg_7_0.m_steamIDFriend:render_steam64()

				if LiveCheck.datawaiting[var_7_0] then
					LiveCheck.dataready[var_7_0] = LiveCheck.buildRichPresence(var_7_0)
					LiveCheck.datawaiting[var_7_0] = false
				end
			end)

			LiveCheck.panorama = panorama.loadstring("\t\t\t\tLiveCheck = {queue:[], waiting:{}}\n\t\t\t\tLiveCheck.start = (steamid, callback) => {\n\t\t\t\t\tLiveCheck.waiting[steamid] = callback\n\t\t\t\t\tLiveCheck.queue[LiveCheck.queue.length + 1] = steamid\n\t\t\t\t}\n\n\t\t\t\tfunction _getQueue(){\n\t\t\t\t\tlet Queue = LiveCheck.queue;\n\t\t\t\t\tLiveCheck.queue = [];\n\t\t\t\t\treturn Queue;\n\t\t\t\t}\n\n\t\t\t\tfunction _finished(steamid, data){\n\t\t\t\t\tif ( typeof LiveCheck.waiting[steamid] != 'undefined' ) {\n\t\t\t\t\t\tLiveCheck.waiting[steamid](data);\n\t\t\t\t\t\tdelete LiveCheck.waiting[steamid];\n\t\t\t\t\t}\n\t\t\t\t}\n\n\t\t\t\treturn  {\n\t\t\t\t\tgetQueue: _getQueue,\n\t\t\t\t\tfinished: _finished\n\t\t\t\t}\n\t\t\t", "CSGOMainMenu")()

			function LiveCheck.loop()
				if not LiveCheck.panorama.getQueue then
					return
				end

				local var_8_0 = LiveCheck.panorama.getQueue()

				if var_8_0.length > 0 then
					for iter_8_0 = 0, var_8_0.length - 1 do
						local var_8_1 = var_8_0[iter_8_0]

						if var_8_1 then
							LiveCheck:start(var_8_1, function(arg_9_0, arg_9_1)
								LiveCheck.panorama.finished(arg_9_0, arg_9_1)
							end)
						end
					end
				end

				client.delay_call(0.5, LiveCheck.loop)
			end

			LiveCheck.loop()
		end)
	end

	Date = panorama.loadstring("return [ts => new Date(ts * 1000)]")()[0]
end

function Initiate()
	local var_10_0 = {
		loops = {},
		ChatMethods = {
			["Local Chat"] = function(arg_11_0)
				cp_SendChat(arg_11_0)
			end,
			["Party Chat"] = function(arg_12_0)
				var_0_12.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", var_0_13.GetXuid(), arg_12_0:gsub(" ", " ")))
			end,
			["Game Chat"] = function(arg_13_0)
				MessageQueue:Say(arg_13_0)
			end,
			["Team Chat"] = function(arg_14_0)
				MessageQueue:SayTeam(arg_14_0)
			end,
			Console = function(...)
				print(...)
			end
		},
		Header = ui.new_label("Lua", "B", "=========  [   $CP Start   ]  =========")
	}

	if var_0_18.get("Delayed Auto Accept") then
		var_10_0.AutoAccept = {}
		var_10_0.AutoAccept.originalAutoAccept = ui.reference("MISC", "Miscellaneous", "Auto-accept matchmaking")
		var_10_0.AutoAccept.enable = ui.new_checkbox("Lua", "B", "Delayed Auto Accept")
		var_10_0.AutoAccept.delay = ui.new_slider("Lua", "B", "\nAuto Accept Delay", 1, 21, 3, true, "s")

		ui.set_visible(var_10_0.AutoAccept.delay, false)
		ui.set_callback(var_10_0.AutoAccept.enable, function(arg_16_0)
			local var_16_0 = ui.get(arg_16_0)

			ui.set_visible(var_10_0.AutoAccept.delay, var_16_0)

			if var_16_0 then
				ui.set(var_10_0.AutoAccept.originalAutoAccept, not var_16_0)
			end
		end)
		ui.set_callback(var_10_0.AutoAccept.originalAutoAccept, function(arg_17_0)
			if ui.get(arg_17_0) then
				ui.set(var_10_0.AutoAccept.enable, false)
			end
		end)

		local var_10_1 = false

		var_0_4.register_event("ShowAcceptPopup", function(arg_18_0)
			if not ui.get(var_10_0.AutoAccept.enable) then
				return
			end

			if var_10_1 and var_10_1.active then
				var_10_1:delete()
			end

			var_10_1 = Timer.set(ui.get(var_10_0.AutoAccept.delay), function()
				print("ACCEPT")
				var_0_14.SetLocalPlayerReady("accept")
			end)
		end)
	end

	if var_0_18.get("Delayed Connect") then
		var_10_0.DelayedConnect = {}
		var_10_0.DelayedConnect.enable = ui.new_checkbox("Lua", "B", "Delayed Connect")
		var_10_0.DelayedConnect.delay = ui.new_slider("Lua", "B", "\nDelayed Connect Delay", 30, 415, 120, true, "s")

		ui.set_visible(var_10_0.DelayedConnect.delay, false)
		ui.set_callback(var_10_0.DelayedConnect.enable, function(arg_20_0)
			local var_20_0 = ui.get(arg_20_0)

			ui.set_visible(var_10_0.DelayedConnect.delay, var_20_0)
		end)

		local var_10_2 = false
		local var_10_3 = false
		local var_10_4 = false

		var_0_4.register_event("ShowAcceptPopup", function(arg_21_0)
			if not ui.get(var_10_0.DelayedConnect.enable) then
				return
			end

			var_10_2 = 0

			print("Count = ", var_10_2)

			if var_10_4 and var_10_4.active then
				var_10_4:delete()
			end
		end)
		client.set_event_callback("player_connect_full", function(arg_22_0)
			if not var_10_2 then
				return
			end

			if not var_0_8.HasOngoingMatch() then
				return
			end

			local var_22_0 = ui.get(var_10_0.DelayedConnect.delay)

			var_10_2 = var_10_2 + 1

			print("Count = ", var_10_2)

			if var_10_2 == 1 then
				client.exec("disconnect")
				print("disconnecting, starting timer")

				var_10_4 = Timer.set(var_22_0, function()
					ReconnectBtn.set("RECONNECT")
					var_10_0.DerankScore.Reconnect()
					print("Timer Done!")
				end)

				local function var_22_1()
					if var_10_4.active then
						ReconnectBtn.set("RECONNECT (" .. math.floor(var_10_4:remaining()) .. ")")
						client.delay_call(1, var_22_1)
					end
				end

				var_22_1()
				var_0_14.CloseSession()
			elseif var_10_2 == 2 then
				var_10_4:delete()
				ReconnectBtn.set("RECONNECT")

				var_10_2 = false
			end
		end)
	end

	if var_0_18.get("Auto Accept Detection") then
		var_10_0.AutoAcceptDetection = {}
		var_10_0.AutoAcceptDetection.enable = ui.new_checkbox("Lua", "B", "Auto Accept Detection")
		var_10_0.AutoAcceptDetection.output = ui.new_multiselect("Lua", "B", "Output", {
			"Party Chat",
			"On-screen",
			"Console"
		})

		ui.set_visible(var_10_0.AutoAcceptDetection.output, false)
		ui.set(var_10_0.AutoAcceptDetection.output, {
			"Party Chat",
			"Console"
		})
		ui.set_callback(var_10_0.AutoAcceptDetection.enable, function(arg_25_0)
			local var_25_0 = ui.get(arg_25_0)

			ui.set_visible(var_10_0.AutoAcceptDetection.output, var_25_0)
		end)

		local var_10_5 = 1

		local function var_10_6()
			var_10_5 = 1
		end

		var_0_4.register_event("ShowAcceptPopup", var_10_6)
		var_0_4.register_event("CloseAcceptPopup", var_10_6)
		var_0_4.register_event("QueueConnectToServer", var_10_6)

		local var_10_7 = false
		local var_10_8 = 0
		local var_10_9 = false

		var_0_4.register_event("PanoramaComponent_Lobby_ReadyUpForMatch", function(arg_27_0, arg_27_1, arg_27_2)
			if arg_27_0 and arg_27_1 == 0 then
				if ui.get(var_10_0.AutoAcceptDetection.enable) then
					print("Attempt accept")

					var_10_9 = true

					var_0_14.SetLocalPlayerReady("accept")
				end
			elseif var_10_9 and arg_27_1 > 1 then
				for iter_27_0, iter_27_1 in ipairs(ui.get(var_10_0.AutoAcceptDetection.output)) do
					if iter_27_1 == "Party Chat" then
						var_10_0.ChatMethods["Party Chat"]("[AUTOACCEPT] Detected " .. arg_27_1 .. " possible auto accepts!")
					end

					if iter_27_1 == "On-screen" then
						var_10_7 = true
						var_10_8 = arg_27_1

						client.delay_call(15, function()
							var_10_7 = false
							var_10_8 = 0
						end)
					end

					var_10_9 = false

					if iter_27_1 == "Console" then
						print("[AUTOACCEPT] Detected " .. arg_27_1 .. " possible auto accepts!")
					end
				end
			end

			var_10_5 = var_10_5 + 1

			if not arg_27_0 then
				var_10_6()
			end
		end)
		client.set_event_callback("paint_ui", function()
			if var_10_7 and var_10_8 > 0 then
				local var_29_0, var_29_1 = client.screen_size()

				renderer.text(var_29_0 / 2, var_29_1 / 2, 255, 0, 0, 255, "+c", 0, "Total auto accepts: " .. var_10_8)
			end
		end)
	end

	if var_0_18.get("Auto Derank Score") then
		var_10_0.DerankScore = {}
		var_10_0.DerankScore.enable = ui.new_checkbox("Lua", "B", "Auto Derank Score")
		var_10_0.DerankScore.delay = ui.new_slider("Lua", "B", "\nAuto Derank Delay", 0, 15, 0, true, "s")
		var_10_0.DerankScore.method = ui.new_multiselect("Lua", "B", "Method", {
			"On Connect (beta)",
			"Round Prestart",
			"Round Start",
			"During Timeout",
			"Round End"
		})

		ui.set_visible(var_10_0.DerankScore.method, false)
		ui.set_visible(var_10_0.DerankScore.delay, false)
		ui.set_callback(var_10_0.DerankScore.enable, function(arg_30_0)
			local var_30_0 = ui.get(arg_30_0)

			ui.set_visible(var_10_0.DerankScore.method, var_30_0)
			ui.set_visible(var_10_0.DerankScore.delay, var_30_0)
		end)

		function var_10_0.DerankScore.MethodState(arg_31_0)
			for iter_31_0, iter_31_1 in ipairs(ui.get(var_10_0.DerankScore.method)) do
				if iter_31_1 == arg_31_0 then
					return true
				end
			end

			return Found
		end

		function var_10_0.DerankScore.Reconnect()
			if var_0_8.HasOngoingMatch() then
				client.delay_call(ui.get(var_10_0.DerankScore.delay), function()
					client.exec("disconnect")
					var_0_8.ActionReconnectToOngoingMatch()
				end)
			end
		end

		client.set_event_callback("player_connect_full", function()
			if ui.get(var_10_0.DerankScore.enable) and var_10_0.DerankScore.MethodState("On Connect (beta)") and not var_0_10.IsGameInWarmup() then
				var_10_0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_start", function()
			if ui.get(var_10_0.DerankScore.enable) and var_10_0.DerankScore.MethodState("Round Prestart") then
				var_10_0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_end", function()
			if entity.is_alive(entity.get_local_player()) and ui.get(var_10_0.DerankScore.enable) and var_10_0.DerankScore.MethodState("Round End") then
				var_10_0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_freeze_end", function()
			if entity.is_alive(entity.get_local_player()) and ui.get(var_10_0.DerankScore.enable) and var_10_0.DerankScore.MethodState("Round Start") then
				var_10_0.DerankScore.Reconnect()
			end
		end)

		var_10_0.DerankScore.Deranking = false
		var_10_0.loops[#var_10_0.loops + 1] = function()
			if not var_10_0.DerankScore.Deranking and ui.get(var_10_0.DerankScore.enable) and var_10_0.DerankScore.MethodState("During Timeout") and var_0_10.IsGamePaused() and entity.is_alive(entity.get_local_player()) then
				local var_38_0 = entity.get_prop(entity.get_game_rules(), "m_bCTTimeOutActive") == 1 and "CT" or entity.get_prop(entity.get_game_rules(), "m_bTerroristTimeOutActive") == 1 and "T" or false
				local var_38_1 = 0

				if var_38_0 == "CT" then
					var_38_1 = entity.get_prop(entity.get_game_rules(), "m_flCTTimeOutRemaining")
				elseif var_38_0 == "T" then
					var_38_1 = entity.get_prop(entity.get_game_rules(), "m_flTerroristTimeOutRemaining")
				end

				if var_38_1 > 0 then
					var_10_0.DerankScore.Deranking = true

					var_10_0.DerankScore.Reconnect()
				end
			end
		end

		client.set_event_callback("player_connect_full", function(arg_39_0)
			if entity.get_local_player() == client.userid_to_entindex(arg_39_0.userid) then
				var_10_0.DerankScore.Deranking = false
			end
		end)
	end

	if var_0_18.get("Auto Open CsgoStats.gg") then
		var_10_0.AutoCSGOStats = {}
		var_10_0.AutoCSGOStats.enable = ui.new_checkbox("Lua", "B", "Auto CSGOStats.gg")

		var_0_4.register_event("ShowAcceptPopup", function(arg_40_0)
			var_10_0.AutoCSGOStats.FirstJoin = true

			printDebug("==> I am watching now")
		end)
		var_0_4.register_event("QueueConnectToServer", function()
			printDebug("==> Queue Connect To Server", ui.get(var_10_0.AutoCSGOStats.enable), var_0_8.HasOngoingMatch())

			if var_10_0.AutoCSGOStats.FirstJoin and ui.get(var_10_0.AutoCSGOStats.enable) and var_0_8.HasOngoingMatch() then
				var_10_0.AutoCSGOStats.FirstJoin = false

				var_0_15.OpenExternalBrowserURL("https://csgostats.gg/player/" .. var_0_13.GetXuid() .. "#/live")
			end
		end)
	end

	if var_0_18.get("Auto Invite Recents") then
		var_10_0.InviteRecents = {}
		var_10_0.InviteRecents.enable = ui.new_checkbox("Lua", "B", "Auto Invite Recents")
		var_10_0.InviteRecents.autostart = ui.new_checkbox("Lua", "B", "Start Queue On Join")

		ui.set_visible(var_10_0.InviteRecents.autostart, false)
		ui.set_callback(var_10_0.InviteRecents.enable, function(arg_42_0)
			printDebug(arg_42_0)
			ui.set_visible(var_10_0.InviteRecents.autostart, ui.get(var_10_0.InviteRecents.enable))
		end)

		local var_10_10 = ""
		local var_10_11 = false

		var_0_4.register_event("EndOfMatch_Shutdown", function(arg_43_0)
			var_10_10 = var_0_9.GetGameModeName(false)

			if var_10_10 and var_0_8.HasOngoingMatch() then
				var_10_0.InviteRecents.Reinvite = true
				var_10_0.InviteRecents.SessionReady = false

				if not var_0_14.IsSessionActive() and ui.get(var_10_0.InviteRecents.enable) then
					var_0_14.CreateSession()
					var_0_12.SessionCommand("MakeOnline", "")

					var_10_11 = true
				end
			end
		end)
		var_0_4.register_event("PanoramaComponent_Lobby_MatchmakingSessionUpdate", function(arg_44_0)
			if arg_44_0 == "ready" and var_10_11 then
				local var_44_0 = {
					update = {
						Game = {}
					}
				}
				local var_44_1 = var_0_11.GetConfig()

				if var_10_10 == "Competitive" then
					var_44_0.update.Game.mode = "competitive"
					var_44_0.update.Game.type = "classic"
				elseif var_10_10 == "Wingman" then
					var_44_0.update.Game.mode = "scrimcomp2v2"
					var_44_0.update.Game.type = "classic"
				end

				var_44_0.update.Game.mapgroupname = var_44_1.gameTypes[var_44_0.update.Game.type].gameModes[var_44_0.update.Game.mode].mapgroupsMP

				var_0_14.UpdateSessionSettings(var_44_0)

				var_10_11 = false

				var_0_16.Refresh()

				var_10_0.InviteRecents.SessionReady = true
			end
		end)
		var_0_4.register_event("PanoramaComponent_Teammates_Refresh", function()
			if not var_0_14.BIsHost() then
				return
			end

			panorama.loadstring("\t\t\t\tlet Recents = $.GetContextPanel().FindChildTraverse('JsFriendsList-recents').FindChild('JsFriendsList-List' );\n\t\t\t\tRecents.ScrollToBottom() \n\t\t\t\tRecents.ScrollToTop()\n\t\t\t", "CSGOMainMenu")()

			var_10_0.InviteRecents.InviteCount = var_10_10 == "Competitive" and 3 or 0

			if var_10_0.InviteRecents.Reinvite and var_10_0.InviteRecents.SessionReady then
				if ui.get(var_10_0.InviteRecents.enable) then
					for iter_45_0 = 0, var_10_0.InviteRecents.InviteCount do
						local var_45_0 = var_0_16.GetXuidByIndex(iter_45_0)

						var_0_10.ActionInviteFriend(var_45_0, "")
					end
				end

				var_10_0.InviteRecents.Reinvite = false
			end
		end)
		var_0_4.register_event("PanoramaComponent_Lobby_PlayerJoined", function(arg_46_0)
			if not var_0_14.BIsHost() then
				return
			end

			local var_46_0 = var_0_14.GetSessionSettings().members.numSlots
			local var_46_1 = var_10_10 == "Wingman" and 2 or 5

			if ui.get(var_10_0.InviteRecents.enable) and ui.get(var_10_0.InviteRecents.autostart) and var_0_12.GetCount() == var_46_1 then
				var_0_14.StartMatchmaking("", "", "", "")
			end
		end)
	end

	if var_0_18.get("Match Start Beep") then
		var_10_0.MatchStartBeep = {}
		var_10_0.MatchStartBeep.enable = ui.new_checkbox("Lua", "B", "Match Start Beep")
		var_10_0.MatchStartBeep.repeatTimes = ui.new_slider("Lua", "B", "Times (x)", 1, 30, 1)
		var_10_0.MatchStartBeep.repeatInterval = ui.new_slider("Lua", "B", "Interval (ms)", 0, 1000, 250, true, "ms")
		var_10_0.MatchStartBeep.delay = ui.new_slider("Lua", "B", "% of Match Freezetime", 0, 100, 75, true, "%")
		var_10_0.MatchStartBeep.sounds = {
			{
				"popup_accept_match_beep",
				"* Default (Beep)"
			},
			{
				"PanoramaUI.Lobby.Joined",
				"* Lobby Joined"
			},
			{
				"PanoramaUI.Lobby.Left",
				"* Lobby Left"
			},
			{
				"popup_accept_match_waitquiet",
				"* Match Accept Tick"
			},
			{
				"popup_accept_match_person",
				"* Match Accept Person"
			},
			{
				"popup_accept_match_confirmed",
				"* Match Confirmed"
			},
			{
				"UIPanorama.generic_button_press",
				"Generic Button"
			},
			{
				"mainmenu_press_home",
				"Home Button"
			},
			{
				"tab_mainmenu_inventory",
				"Inventory Tab"
			},
			{
				"tab_settings_settings",
				"Settings Tab"
			},
			{
				"UIPanorama.mainmenu_press_quit",
				"Quit Button"
			},
			{
				"sticker_applySticker",
				"Sticker Apply"
			},
			{
				"sticker_nextPosition",
				"Sticker Next Position"
			},
			{
				"container_sticker_ticker",
				"Container Sticker Ticker"
			},
			{
				"container_weapon_ticker",
				"Container Weapon Ticker"
			},
			{
				"container_countdown",
				"Container Countdown"
			},
			{
				"inventory_inspect_sellOnMarket",
				"Sell on Market"
			},
			{
				"UIPanorama.sidemenu_select",
				"Sidemenu Select"
			},
			{
				"inventory_item_popupSelect",
				"Item Popup"
			},
			{
				"UIPanorama.stats_reveal",
				"Stats Reveal"
			},
			{
				"ItemRevealSingleLocalPlayer",
				"Reveal Singleplayer"
			},
			{
				"ItemDropCommon",
				"Item Drop (Common)"
			},
			{
				"ItemDropUncommon",
				"Item Drop (Uncommon)"
			},
			{
				"ItemDropMythical",
				"Item Drop (Mythical)"
			},
			{
				"ItemDropLegendary",
				"Item Drop (Legendary)"
			},
			{
				"ItemDropAncient",
				"Item Drop (Ancient)"
			},
			{
				"UIPanorama.XP.Ticker",
				"XP Ticker"
			},
			{
				"UIPanorama.XP.BarFull",
				"XP Bar Full"
			},
			{
				"UIPanorama.XP.NewRank",
				"XP New Rank"
			},
			{
				"UIPanorama.XP.NewSkillGroup",
				"New Skill Group"
			},
			{
				"UIPanorama.submenu_leveloptions_slidein",
				"Map Vote SlideIn"
			},
			{
				"UIPanorama.submenu_leveloptions_select",
				"Map Vote Select"
			},
			{
				"mainmenu_press_GO",
				"Matchmaking Search"
			},
			{
				"buymenu_select",
				"Buy Select"
			},
			{
				"UIPanorama.gameover_show",
				"Gameover"
			},
			{
				"inventory_item_select",
				"Inventory Select"
			},
			{
				"UIPanorama.inventory_new_item_accept",
				"Inventory New Item"
			},
			{
				"sidemenu_slidein",
				"Sidemenu Slidein"
			},
			{
				"sidemenu_slideout",
				"Sidemenu Slideout"
			},
			{
				"UIPanorama.inventory_new_item",
				"Inventory New Item"
			},
			{
				"inventory_inspect_weapon",
				"Inventory Inspect Weapon"
			},
			{
				"inventory_inspect_knife",
				"Inventory Inspect Knife"
			},
			{
				"inventory_inspect_sticker",
				"Inventory Inspect Sticker"
			},
			{
				"inventory_inspect_graffiti",
				"Inventory Inspect Graffiti"
			},
			{
				"inventory_inspect_musicKit",
				"Inventory Inspect Music Kit"
			},
			{
				"inventory_inspect_coin",
				"Inventory Inspect Coin"
			},
			{
				"inventory_inspect_gloves",
				"Inventory Inspect Gloves"
			},
			{
				"inventory_inspect_close",
				"Inventory Inspect Close"
			},
			{
				"XrayStart",
				"XRay Start"
			},
			{
				"rename_purchaseSuccess",
				"Nametag Success"
			},
			{
				"rename_select",
				"Nametag Select"
			},
			{
				"rename_teletype",
				"Nametag Teletype"
			},
			{
				"weapon_selectReplace",
				"Weapon Select Replace"
			},
			{
				"UIPanorama.popup_newweapon",
				"New Weapon Popup"
			}
		}

		local var_10_12 = {}
		local var_10_13 = {}

		for iter_10_0, iter_10_1 in pairs(var_10_0.MatchStartBeep.sounds) do
			var_10_12[#var_10_12 + 1] = iter_10_1[2]
			var_10_13[iter_10_1[2]] = iter_10_1[1]
		end

		var_10_0.MatchStartBeep.sounds = ui.new_listbox("Lua", "B", "Sounds", var_10_12)
		var_10_0.MatchStartBeep.testsound = ui.new_button("Lua", "B", "Test Sound", function()
			local var_47_0 = var_10_12[ui.get(var_10_0.MatchStartBeep.sounds) + 1]

			printDebug(var_47_0, ">", var_10_13[var_47_0])

			if var_47_0 and var_47_0 ~= "" and var_10_13[var_47_0] then
				var_10_0.MatchStartBeep.PlaySound()
			end
		end)

		ui.set_visible(var_10_0.MatchStartBeep.delay, false)
		ui.set_visible(var_10_0.MatchStartBeep.sounds, false)
		ui.set_visible(var_10_0.MatchStartBeep.testsound, false)
		ui.set_visible(var_10_0.MatchStartBeep.repeatTimes, false)
		ui.set_visible(var_10_0.MatchStartBeep.repeatInterval, false)
		ui.set_callback(var_10_0.MatchStartBeep.enable, function(arg_48_0)
			local var_48_0 = ui.get(arg_48_0)

			ui.set_visible(var_10_0.MatchStartBeep.delay, var_48_0)
			ui.set_visible(var_10_0.MatchStartBeep.sounds, var_48_0)
			ui.set_visible(var_10_0.MatchStartBeep.testsound, var_48_0)
			ui.set_visible(var_10_0.MatchStartBeep.repeatTimes, var_48_0)
			ui.set_visible(var_10_0.MatchStartBeep.repeatInterval, ui.get(var_10_0.MatchStartBeep.repeatTimes) ~= 1 and var_48_0)
		end)

		function var_10_0.MatchStartBeep.PlaySound()
			local var_49_0 = var_10_12[ui.get(var_10_0.MatchStartBeep.sounds) + 1] or "Default (Beep)"

			if var_49_0 and var_49_0 ~= "" and var_10_13[var_49_0] then
				local var_49_1 = ui.get(var_10_0.MatchStartBeep.repeatTimes)
				local var_49_2 = ui.get(var_10_0.MatchStartBeep.repeatInterval)

				if var_49_1 == 1 then
					var_0_7.DispatchEvent("PlaySoundEffect", var_10_13[var_49_0], "MOUSE")
				else
					for iter_49_0 = 1, var_49_1 do
						client.delay_call(var_49_1 == 1 and 0 or (iter_49_0 - 1) * var_49_2 / 1000, function()
							printDebug("done")
							var_0_7.DispatchEvent("PlaySoundEffect", var_10_13[var_49_0], "MOUSE")
						end)
					end
				end
			end
		end

		ui.set_callback(var_10_0.MatchStartBeep.repeatTimes, function(arg_51_0)
			local var_51_0 = ui.get(arg_51_0)

			ui.set_visible(var_10_0.MatchStartBeep.repeatInterval, var_51_0 ~= 1 and ui.get(var_10_0.MatchStartBeep.enable))
		end)
		client.set_event_callback("round_start", function()
			if ui.get(var_10_0.MatchStartBeep.enable) then
				local var_52_0 = cvar.mp_freezetime:get_int()
				local var_52_1 = ui.get(var_10_0.MatchStartBeep.delay) / 100

				client.delay_call(var_52_0 * var_52_1, function()
					var_10_0.MatchStartBeep.PlaySound()
				end)
			end
		end)
	end

	if var_0_18.get("Custom Clantag Builder") then
		var_10_0.Clantag = {}
		var_10_0.Clantag.last = ""
		var_10_0.Clantag.enable = ui.new_checkbox("Lua", "B", "Clantag Builder [BETA]")
		var_10_0.Clantag.template = ui.new_textbox("Lua", "B", "\nClantag Template")
		var_10_0.Clantag.helper1 = ui.new_label("Lua", "B", "Helper: Type { or anything")
		var_10_0.Clantag.helper2 = ui.new_label("Lua", "B", "\n")
		var_10_0.Clantag.helper3 = ui.new_label("Lua", "B", "\n")
		var_10_0.Clantag.helper4 = ui.new_label("Lua", "B", "\n")
		var_10_0.Clantag.helper5 = ui.new_label("Lua", "B", "\n")
		var_10_0.Clantag.processedData = {}
		var_10_0.Clantag.data = {
			{
				"rank",
				"competitive ranking",
				300,
				function()
					local var_54_0 = entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", entity.get_local_player())

					if var_54_0 == 0 then
						return "N/A"
					end

					if var_54_0 then
						local var_54_1 = var_0_9.GetGameModeInternalName(true)
						local var_54_2 = var_0_7.Localize(var_54_1 == "survival" and "#skillgroup_" .. var_54_0 .. "dangerzone" or "RankName_" .. var_54_0)

						return (getRankShortName(var_54_2))
					end
				end,
				0
			},
			{
				"wins",
				"competitive wins",
				300,
				function()
					return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", entity.get_local_player()) or ""
				end,
				0
			},
			{
				"hp",
				"current health",
				0.5,
				function()
					return entity.get_prop(entity.get_local_player(), "m_iHealth") or 0
				end,
				0
			},
			{
				"amr",
				"current armor",
				0.5,
				function()
					return entity.get_prop(entity.get_local_player(), "m_ArmorValue") or 0
				end,
				0
			},
			{
				"loc",
				"current location",
				0.5,
				function()
					return var_0_7.Localize(entity.get_prop(entity.get_local_player(), "m_szLastPlaceName")) or ""
				end,
				0
			},
			{
				"kills",
				"current kills",
				1,
				function()
					return entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0
				end,
				0
			},
			{
				"deaths",
				"current deaths",
				1,
				function()
					return entity.get_prop(entity.get_player_resource(), "m_iDeaths", entity.get_local_player()) or 0
				end,
				0
			},
			{
				"assists",
				"current assists",
				1,
				function()
					return entity.get_prop(entity.get_player_resource(), "m_iAssists", entity.get_local_player()) or 0
				end,
				0
			},
			{
				"hschance",
				"current headshot chance",
				1,
				function()
					local var_62_0 = entity.get_local_player()
					local var_62_1 = var_10_0.Clantag.processedData.kills
					local var_62_2 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", entity.get_local_player())

					if var_62_1 and var_62_2 then
						return math.ceil(var_62_2 / var_62_1 * 100)
					end
				end,
				0
			},
			{
				"c4",
				"displays BOMB if carrying bomb",
				1,
				function()
					var_10_0.Clantag.last = ""
				end,
				0
			},
			{
				"wep",
				"current weapon name",
				0.25,
				function()
					local var_64_0 = entity.get_local_player()
					local var_64_1 = entity.get_player_weapon(var_64_0)

					if var_64_1 == nil then
						return
					end

					local var_64_2 = entity.get_prop(var_64_1, "m_iItemDefinitionIndex")

					if var_64_2 == nil then
						return
					end

					local var_64_3 = var_0_1[var_64_2]

					if var_64_3 == nil then
						return
					end

					return var_64_3.name
				end,
				0
			},
			{
				"ammo",
				"current weapon ammo",
				0.25,
				function()
					local var_65_0 = entity.get_local_player()
					local var_65_1 = entity.get_player_weapon(var_65_0)

					if var_65_1 == nil then
						return
					end

					local var_65_2 = entity.get_prop(var_65_1, "m_iClip1")

					if var_65_2 == nil then
						return
					end

					return var_65_2
				end,
				0
			},
			{
				"id",
				"current steam id",
				9999,
				function()
					return var_0_13.GetXuid()
				end,
				0
			},
			{
				"bomb",
				"bomb timer countdown",
				1,
				function()
					local var_67_0 = entity.get_all("CPlantedC4")[1]

					if var_67_0 == nil or entity.get_prop(var_67_0, "m_bBombDefused") == 1 or entity.get_local_player() == nil then
						return ""
					end

					local var_67_1 = entity.get_prop(var_67_0, "m_flC4Blow") - globals.curtime()

					return var_67_1 ~= nil and var_67_1 > 0 and math.floor(var_67_1) or ""
				end,
				0
			},
			{
				"doa",
				"displays DEAD or ALIVE",
				0.5,
				function()
					return entity.is_alive(entity.get_local_player()) and "ALIVE" or "DEAD"
				end,
				0
			},
			{
				"fps",
				"current FPS",
				0.05,
				function()
					return AccumulateFps()
				end,
				0
			},
			{
				"ping",
				"current ping",
				0.5,
				function()
					return math.floor(client.latency() * 1000)
				end,
				0
			},
			{
				"date",
				"current date (DD/MM/YY)",
				300,
				function()
					local var_71_0 = Date(client.unix_time())
					local var_71_1 = string.format("%02d", var_71_0.getDate())
					local var_71_2 = string.format("%02d", var_71_0.getMonth() + 1)

					return string.format("%s/%s/%s", var_71_1, var_71_2, tostring(var_71_0.getFullYear()):sub(3, 4))
				end,
				0
			},
			{
				"shortday",
				"current name of the day (Mon, Wed, Tue)",
				300,
				function()
					return ({
						"Sun",
						"Mon",
						"Tue",
						"Wed",
						"Thu",
						"Fri",
						"Sat"
					})[Date(client.unix_time()).getDay() + 1]
				end,
				0
			},
			{
				"longday",
				"current name of the day (Monday, Wednesday, Tuesday)",
				300,
				function()
					return ({
						"Sunday",
						"Monday",
						"Tuesday",
						"Wednesday",
						"Thursday",
						"Friday",
						"Saturday"
					})[Date(client.unix_time()).getDay() + 1]
				end,
				0
			},
			{
				"day",
				"current day of the month",
				300,
				function()
					local var_74_0 = Date(client.unix_time())

					return string.format("%02d", var_74_0.getDate())
				end,
				0
			},
			{
				"month",
				"current month number",
				300,
				function()
					local var_75_0 = Date(client.unix_time())

					return string.format("%02d", var_75_0.getMonth() + 1)
				end,
				0
			},
			{
				"year",
				"current year number",
				300,
				function()
					local var_76_0 = Date(client.unix_time())

					return tostring(var_76_0.getFullYear()):sub(3, 4)
				end,
				0
			},
			{
				"time12",
				"current time in 12 hour time",
				1,
				function()
					local var_77_0 = Date(client.unix_time())
					local var_77_1 = var_77_0.getHours()
					local var_77_2 = var_77_1 > 12 and "PM" or "AM"
					local var_77_3 = string.format("%02d", var_77_1 > 12 and var_77_1 - 12 or var_77_1)
					local var_77_4 = string.format("%02d", var_77_0.getMinutes())
					local var_77_5 = string.format("%02d", var_77_0.getSeconds())

					return string.format("%s:%s:%s %s", var_77_3, var_77_4, var_77_5, var_77_2)
				end,
				0
			},
			{
				"time24",
				"current time in 24 hour time",
				1,
				function()
					local var_78_0 = Date(client.unix_time())
					local var_78_1 = string.format("%02d", var_78_0.getHours())
					local var_78_2 = string.format("%02d", var_78_0.getMinutes())
					local var_78_3 = string.format("%02d", var_78_0.getSeconds())

					return string.format("%s:%s:%s", var_78_1, var_78_2, var_78_3)
				end,
				0
			},
			{
				"hour12",
				"hour in 12 hour time",
				1,
				function()
					local var_79_0 = Date(client.unix_time()).getHours()

					return string.format("%02d", var_79_0 > 12 and var_79_0 - 12 or var_79_0)
				end,
				0
			},
			{
				"hour24",
				"hour in 24 hour time",
				1,
				function()
					return Date(client.unix_time()).getHours()
				end,
				0
			},
			{
				"mins",
				"current minutes in system time",
				1,
				function()
					local var_81_0 = Date(client.unix_time())

					return string.format("%02d", var_81_0.getMinutes())
				end,
				0
			},
			{
				"secs",
				"current seconds in system time",
				1,
				function()
					local var_82_0 = Date(client.unix_time())

					return string.format("%02d", var_82_0.getSeconds())
				end,
				0
			},
			{
				"timesuffix",
				"12 hour time suffix",
				1,
				function()
					return Date(client.unix_time()).getHours() > 12 and "PM" or "AM"
				end,
				0
			}
		}

		ui.set_visible(var_10_0.Clantag.template, false)
		ui.set_visible(var_10_0.Clantag.helper1, false)
		ui.set_visible(var_10_0.Clantag.helper2, false)
		ui.set_visible(var_10_0.Clantag.helper3, false)
		ui.set_visible(var_10_0.Clantag.helper4, false)
		ui.set_visible(var_10_0.Clantag.helper5, false)

		local var_10_14 = false

		client.set_event_callback("pre_config_load", function()
			var_10_14 = true
		end)
		client.set_event_callback("post_config_load", function()
			var_10_14 = false
		end)
		ui.set_callback(var_10_0.Clantag.enable, function(arg_86_0)
			local var_86_0 = ui.get(arg_86_0)

			if not var_86_0 and not var_10_14 then
				client.set_clan_tag("\x00")
			end

			var_10_0.Clantag.last = ""

			ui.set_visible(var_10_0.Clantag.template, var_86_0)
			ui.set(var_10_0.Clantag.helper1, "Helper: type { to get suggestions")
			ui.set_visible(var_10_0.Clantag.helper1, var_86_0)
			ui.set_visible(var_10_0.Clantag.helper2, false)
			ui.set_visible(var_10_0.Clantag.helper3, false)
			ui.set_visible(var_10_0.Clantag.helper4, false)
			ui.set_visible(var_10_0.Clantag.helper5, false)
		end)

		local var_10_15 = ui.get(var_10_0.Clantag.template)

		client.set_event_callback("post_render", function()
			local var_87_0 = ui.get(var_10_0.Clantag.template)

			if var_87_0 ~= var_10_15 then
				var_10_15 = var_87_0

				local var_87_1 = var_87_0:match("{(%a*%d*)$")

				if var_87_1 then
					local var_87_2 = false

					if var_87_1:len() > 0 then
						for iter_87_0, iter_87_1 in ipairs(var_10_0.Clantag.data) do
							if iter_87_1[1]:sub(1, var_87_1:len()) == var_87_1:lower() then
								var_87_2 = iter_87_1

								break
							end
						end

						if var_87_2 then
							ui.set(var_10_0.Clantag.helper1, "{" .. var_87_2[1] .. "} - " .. var_87_2[2])
						else
							ui.set(var_10_0.Clantag.helper1, "no matches found for {" .. var_87_1 .. "}")
						end

						ui.set_visible(var_10_0.Clantag.helper2, false)
						ui.set_visible(var_10_0.Clantag.helper3, false)
						ui.set_visible(var_10_0.Clantag.helper4, false)
						ui.set_visible(var_10_0.Clantag.helper5, false)
					else
						local var_87_3 = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {}
						}
						local var_87_4 = {}

						for iter_87_2, iter_87_3 in ipairs(var_10_0.Clantag.data) do
							var_87_4[#var_87_4 + 1] = iter_87_3[1]
						end

						for iter_87_4 = 1, 7 do
							local var_87_5 = var_87_4[iter_87_4]

							if var_87_5 then
								var_87_3.helper1[#var_87_3.helper1 + 1] = var_87_5
							end
						end

						for iter_87_5 = 8, 14 do
							local var_87_6 = var_87_4[iter_87_5]

							if var_87_6 then
								var_87_3.helper2[#var_87_3.helper2 + 1] = var_87_6
							end
						end

						for iter_87_6 = 15, 21 do
							local var_87_7 = var_87_4[iter_87_6]

							if var_87_7 then
								var_87_3.helper3[#var_87_3.helper3 + 1] = var_87_7
							end
						end

						for iter_87_7 = 22, 28 do
							local var_87_8 = var_87_4[iter_87_7]

							if var_87_8 then
								var_87_3.helper4[#var_87_3.helper4 + 1] = var_87_8
							end
						end

						for iter_87_8 = 29, 35 do
							local var_87_9 = var_87_4[iter_87_8]

							if var_87_9 then
								var_87_3.helper5[#var_87_3.helper5 + 1] = var_87_9
							end
						end

						ui.set(var_10_0.Clantag.helper1, table.concat(var_87_3.helper1, ", "))
						ui.set(var_10_0.Clantag.helper2, table.concat(var_87_3.helper2, ", "))
						ui.set(var_10_0.Clantag.helper3, table.concat(var_87_3.helper3, ", "))
						ui.set(var_10_0.Clantag.helper4, table.concat(var_87_3.helper4, ", "))
						ui.set(var_10_0.Clantag.helper5, table.concat(var_87_3.helper5, ", "))
						ui.set_visible(var_10_0.Clantag.helper1, #var_87_3.helper1 > 0)
						ui.set_visible(var_10_0.Clantag.helper2, #var_87_3.helper2 > 0)
						ui.set_visible(var_10_0.Clantag.helper3, #var_87_3.helper3 > 0)
						ui.set_visible(var_10_0.Clantag.helper4, #var_87_3.helper4 > 0)
						ui.set_visible(var_10_0.Clantag.helper5, #var_87_3.helper5 > 0)
					end
				else
					ui.set(var_10_0.Clantag.helper1, "Helper: " .. var_87_0 .. "_")
					ui.set_visible(var_10_0.Clantag.helper2, false)
					ui.set_visible(var_10_0.Clantag.helper3, false)
					ui.set_visible(var_10_0.Clantag.helper4, false)
					ui.set_visible(var_10_0.Clantag.helper5, false)
				end
			end
		end)

		var_10_0.loops[#var_10_0.loops + 1] = function()
			if not ui.get(var_10_0.Clantag.enable) then
				return
			end

			if not entity.get_local_player() then
				return
			end

			for iter_88_0, iter_88_1 in ipairs(var_10_0.Clantag.data) do
				local var_88_0 = iter_88_1[1]
				local var_88_1 = iter_88_1[2]
				local var_88_2 = iter_88_1[3]
				local var_88_3 = iter_88_1[4]

				if globals.curtime() > iter_88_1[5] then
					local var_88_4 = var_88_3()

					if var_88_4 == nil then
						var_10_0.Clantag.processedData[var_88_0] = ""
					elseif var_88_4 then
						var_10_0.Clantag.processedData[var_88_0] = var_88_4
					end

					iter_88_1[5] = globals.curtime() + var_88_2
				end
			end

			local var_88_5 = processTags(ui.get(var_10_0.Clantag.template), var_10_0.Clantag.processedData)

			if var_10_0.Clantag.last ~= var_88_5 and var_88_5 ~= "" then
				client.set_clan_tag(var_88_5)

				var_10_0.Clantag.last = var_88_5
			end
		end

		client.set_event_callback("player_connect_full", function()
			var_10_0.Clantag.last = ""

			for iter_89_0, iter_89_1 in ipairs(var_10_0.Clantag.data) do
				iter_89_1[5] = 0
			end
		end)
		client.set_event_callback("round_start", function()
			var_10_0.Clantag.last = ""
		end)
	end

	if var_0_18.get("Custom Killsay Builder") then
		var_10_0.CustomKillSay = {}
		var_10_0.CustomKillSay.enable = ui.new_checkbox("Lua", "B", "Killsay Builder [BETA]")
		var_10_0.CustomKillSay.template = ui.new_textbox("Lua", "B", "\nKillsay Template")
		var_10_0.CustomKillSay.helper1 = ui.new_label("Lua", "B", "Helper: type { to get suggestions")
		var_10_0.CustomKillSay.helper2 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.helper3 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.helper4 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.helper5 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.helper6 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.helper7 = ui.new_label("Lua", "B", "\n")
		var_10_0.CustomKillSay.processedData = {}

		ui.set_visible(var_10_0.CustomKillSay.template, false)
		ui.set_visible(var_10_0.CustomKillSay.helper1, false)
		ui.set_visible(var_10_0.CustomKillSay.helper2, false)
		ui.set_visible(var_10_0.CustomKillSay.helper3, false)
		ui.set_visible(var_10_0.CustomKillSay.helper4, false)
		ui.set_visible(var_10_0.CustomKillSay.helper5, false)
		ui.set_visible(var_10_0.CustomKillSay.helper6, false)
		ui.set_visible(var_10_0.CustomKillSay.helper7, false)
		ui.set_callback(var_10_0.CustomKillSay.enable, function(arg_91_0)
			local var_91_0 = ui.get(arg_91_0)

			ui.set_visible(var_10_0.CustomKillSay.template, var_91_0)
			ui.set(var_10_0.CustomKillSay.helper1, "Helper: type { to get suggestions")
			ui.set_visible(var_10_0.CustomKillSay.helper1, var_91_0)
			ui.set_visible(var_10_0.CustomKillSay.helper2, false)
			ui.set_visible(var_10_0.CustomKillSay.helper3, false)
			ui.set_visible(var_10_0.CustomKillSay.helper4, false)
			ui.set_visible(var_10_0.CustomKillSay.helper5, false)
			ui.set_visible(var_10_0.CustomKillSay.helper6, false)
			ui.set_visible(var_10_0.CustomKillSay.helper7, false)
		end)

		local var_10_16 = {
			{
				"vname",
				"victims kills",
				function(arg_92_0, arg_92_1)
					return entity.get_player_name(arg_92_0)
				end
			},
			{
				"myname",
				"victims kills",
				function(arg_93_0, arg_93_1)
					return entity.get_player_name(arg_93_1)
				end
			},
			{
				"vuserid",
				"victims userid",
				function(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
					return arg_94_2
				end
			},
			{
				"myuserid",
				"my userid",
				function(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
					return arg_95_3
				end
			},
			{
				"ventid",
				"victims entity id",
				function(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
					return arg_96_0
				end
			},
			{
				"myentid",
				"victims entity id",
				function(arg_97_0, arg_97_1, arg_97_2, arg_97_3)
					return arg_97_1
				end
			},
			{
				"myname",
				"victims kills",
				function(arg_98_0, arg_98_1)
					return entity.get_player_name(arg_98_1)
				end
			},
			{
				"vdeaths",
				"victims deaths",
				function(arg_99_0, arg_99_1)
					return entity.get_prop(entity.get_player_resource(), "m_iDeaths", arg_99_0) + 1 or 0
				end
			},
			{
				"vkills",
				"victims kills",
				function(arg_100_0, arg_100_1)
					return entity.get_prop(entity.get_player_resource(), "m_iKills", arg_100_0) or 0
				end
			},
			{
				"vassists",
				"victims assists",
				function(arg_101_0, arg_101_1)
					return entity.get_prop(entity.get_player_resource(), "m_iAssists", arg_101_0) or 0
				end
			},
			{
				"mykills",
				"my kills",
				function(arg_102_0, arg_102_1)
					return entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0
				end
			},
			{
				"mydeaths",
				"my kills",
				function(arg_103_0, arg_103_1)
					return entity.get_prop(entity.get_player_resource(), "m_iDeaths", entity.get_local_player()) or 0
				end
			},
			{
				"myassists",
				"my kills",
				function(arg_104_0, arg_104_1)
					return entity.get_prop(entity.get_player_resource(), "m_iAssists", entity.get_local_player()) or 0
				end
			},
			{
				"vrank",
				"victims competitive ranking",
				function(arg_105_0, arg_105_1)
					local var_105_0 = entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", arg_105_0)

					if var_105_0 == 0 then
						return "N/A"
					end

					if var_105_0 then
						local var_105_1 = var_0_9.GetGameModeInternalName(true)
						local var_105_2 = var_0_7.Localize(var_105_1 == "survival" and "#skillgroup_" .. var_105_0 .. "dangerzone" or "RankName_" .. var_105_0)

						return (getRankShortName(var_105_2))
					end
				end
			},
			{
				"myrank",
				"my competitive ranking",
				function(arg_106_0, arg_106_1)
					local var_106_0 = entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", entity.get_local_player())

					if var_106_0 == 0 then
						return "N/A"
					end

					if var_106_0 then
						local var_106_1 = var_0_9.GetGameModeInternalName(true)
						local var_106_2 = var_0_7.Localize(var_106_1 == "survival" and "#skillgroup_" .. var_106_0 .. "dangerzone" or "RankName_" .. var_106_0)

						return (getRankShortName(var_106_2))
					end
				end
			},
			{
				"vwins",
				"victims competitive wins",
				function(arg_107_0, arg_107_1)
					return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", arg_107_0) or ""
				end
			},
			{
				"mywins",
				"my competitive wins",
				function(arg_108_0, arg_108_1)
					return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", entity.get_local_player()) or ""
				end
			},
			{
				"vhp",
				"my current health",
				function(arg_109_0, arg_109_1)
					return entity.get_prop(arg_109_0, "m_iHealth") or 0
				end
			},
			{
				"myhp",
				"my current health",
				function(arg_110_0, arg_110_1)
					return entity.get_prop(entity.get_local_player(), "m_iHealth") or 0
				end
			},
			{
				"vamr",
				"victim current armor",
				function(arg_111_0, arg_111_1)
					return entity.get_prop(arg_111_0, "m_ArmorValue") or 0
				end
			},
			{
				"myamr",
				"current armor",
				function(arg_112_0, arg_112_1)
					return entity.get_prop(entity.get_local_player(), "m_ArmorValue") or 0
				end
			},
			{
				"vloc",
				"victim current location",
				function(arg_113_0, arg_113_1)
					return var_0_7.Localize(entity.get_prop(arg_113_0, "m_szLastPlaceName")) or ""
				end
			},
			{
				"myloc",
				"current location",
				function(arg_114_0, arg_114_1)
					return var_0_7.Localize(entity.get_prop(entity.get_local_player(), "m_szLastPlaceName")) or ""
				end
			},
			{
				"vheadchance",
				"victim current headshot chance",
				function(arg_115_0, arg_115_1)
					local var_115_0 = entity.get_prop(entity.get_player_resource(), "m_iKills", arg_115_0) or 0
					local var_115_1 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", arg_115_0) or 0

					if var_115_0 and var_115_1 then
						return math.ceil(var_115_1 / var_115_0 * 100)
					end
				end
			},
			{
				"myheadchance",
				"current headshot chance",
				function(arg_116_0, arg_116_1)
					local var_116_0 = entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0
					local var_116_1 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", entity.get_local_player())

					if var_116_0 and var_116_1 then
						return math.ceil(var_116_1 / var_116_0 * 100)
					end
				end
			},
			{
				"mywep",
				"current weapon name",
				function(arg_117_0, arg_117_1)
					local var_117_0 = entity.get_local_player()
					local var_117_1 = entity.get_player_weapon(var_117_0)

					if var_117_1 == nil then
						return
					end

					local var_117_2 = entity.get_prop(var_117_1, "m_iItemDefinitionIndex")

					if var_117_2 == nil then
						return
					end

					local var_117_3 = var_0_1[var_117_2]

					if var_117_3 == nil then
						return
					end

					return var_117_3.name
				end
			},
			{
				"vwep",
				"current weapon name",
				function(arg_118_0, arg_118_1)
					local var_118_0 = var_10_0.CustomKillSay.vwep[arg_118_0]
					local var_118_1 = entity.get_prop(var_118_0, "m_iItemDefinitionIndex")

					if var_118_1 == nil then
						return
					end

					local var_118_2 = var_0_1[var_118_1]

					if var_118_2 == nil then
						return
					end

					return var_118_2.name
				end
			},
			{
				"ammo",
				"current weapon ammo",
				function(arg_119_0, arg_119_1)
					local var_119_0 = entity.get_local_player()
					local var_119_1 = entity.get_player_weapon(var_119_0)

					if var_119_1 == nil then
						return
					end

					local var_119_2 = entity.get_prop(var_119_1, "m_iClip1")

					if var_119_2 == nil then
						return
					end

					return var_119_2
				end
			},
			{
				"vsteam64",
				"victim steam id",
				function(arg_120_0, arg_120_1)
					return var_0_9.GetPlayerXuidStringFromEntIndex(arg_120_0)
				end
			},
			{
				"mysteam64",
				"my steam id",
				function(arg_121_0, arg_121_1)
					return var_0_13.GetXuid()
				end
			},
			{
				"bomb",
				"bomb timer countdown",
				function(arg_122_0, arg_122_1)
					local var_122_0 = entity.get_all("CPlantedC4")[1]

					if var_122_0 == nil or entity.get_prop(var_122_0, "m_bBombDefused") == 1 or entity.get_local_player() == nil then
						return ""
					end

					local var_122_1 = entity.get_prop(var_122_0, "m_flC4Blow") - globals.curtime()

					return var_122_1 ~= nil and var_122_1 > 0 and math.floor(var_122_1) or ""
				end
			},
			{
				"doa",
				"displays DEAD or ALIVE",
				function(arg_123_0, arg_123_1)
					return entity.is_alive(entity.get_local_player()) and "ALIVE" or "DEAD"
				end
			},
			{
				"ping",
				"current ping",
				function(arg_124_0, arg_124_1)
					return math.floor(client.latency() * 1000)
				end
			},
			{
				"date",
				"current date (DD/MM/YY)",
				function(arg_125_0, arg_125_1)
					local var_125_0 = Date(client.unix_time())
					local var_125_1 = string.format("%02d", var_125_0.getDate())
					local var_125_2 = string.format("%02d", var_125_0.getMonth() + 1)

					return string.format("%s/%s/%s", var_125_1, var_125_2, tostring(var_125_0.getFullYear()):sub(3, 4))
				end
			},
			{
				"shortday",
				"current name of the day (Mon, Wed, Tue)",
				function(arg_126_0, arg_126_1)
					return ({
						"Sun",
						"Mon",
						"Tue",
						"Wed",
						"Thu",
						"Fri",
						"Sat"
					})[Date(client.unix_time()).getDay() + 1]
				end
			},
			{
				"longday",
				"current name of the day (Monday, Wednesday, Tuesday)",
				function(arg_127_0, arg_127_1)
					return ({
						"Sunday",
						"Monday",
						"Tuesday",
						"Wednesday",
						"Thursday",
						"Friday",
						"Saturday"
					})[Date(client.unix_time()).getDay() + 1]
				end
			},
			{
				"day",
				"current day of the month",
				function(arg_128_0, arg_128_1)
					local var_128_0 = Date(client.unix_time())

					return string.format("%02d", var_128_0.getDate())
				end
			},
			{
				"month",
				"current month number",
				function(arg_129_0, arg_129_1)
					local var_129_0 = Date(client.unix_time())

					return string.format("%02d", var_129_0.getMonth() + 1)
				end
			},
			{
				"year",
				"current year number",
				function(arg_130_0, arg_130_1)
					local var_130_0 = Date(client.unix_time())

					return tostring(var_130_0.getFullYear()):sub(3, 4)
				end
			},
			{
				"time12",
				"current time in 12 hour time",
				function(arg_131_0, arg_131_1)
					local var_131_0 = Date(client.unix_time())
					local var_131_1 = var_131_0.getHours()
					local var_131_2 = var_131_1 > 12 and "PM" or "AM"
					local var_131_3 = string.format("%02d", var_131_1 > 12 and var_131_1 - 12 or var_131_1)
					local var_131_4 = string.format("%02d", var_131_0.getMinutes())
					local var_131_5 = string.format("%02d", var_131_0.getSeconds())

					return string.format("%s:%s:%s %s", var_131_3, var_131_4, var_131_5, var_131_2)
				end
			},
			{
				"time24",
				"current time in 24 hour time",
				function(arg_132_0, arg_132_1)
					local var_132_0 = Date(client.unix_time())
					local var_132_1 = string.format("%02d", var_132_0.getHours())
					local var_132_2 = string.format("%02d", var_132_0.getMinutes())
					local var_132_3 = string.format("%02d", var_132_0.getSeconds())

					return string.format("%s:%s:%s", var_132_1, var_132_2, var_132_3)
				end
			},
			{
				"hour12",
				"hour in 12 hour time",
				function(arg_133_0, arg_133_1)
					local var_133_0 = Date(client.unix_time()).getHours()

					return string.format("%02d", var_133_0 > 12 and var_133_0 - 12 or var_133_0)
				end
			},
			{
				"hour24",
				"hour in 24 hour time",
				function(arg_134_0, arg_134_1)
					return Date(client.unix_time()).getHours()
				end
			},
			{
				"mins",
				"current minutes in system time",
				function(arg_135_0, arg_135_1)
					local var_135_0 = Date(client.unix_time())

					return string.format("%02d", var_135_0.getMinutes())
				end
			},
			{
				"secs",
				"current seconds in system time",
				function(arg_136_0, arg_136_1)
					local var_136_0 = Date(client.unix_time())

					return string.format("%02d", var_136_0.getSeconds())
				end
			},
			{
				"timesuffix",
				"12 hour time suffix",
				function(arg_137_0, arg_137_1)
					return Date(client.unix_time()).getHours() > 12 and "PM" or "AM"
				end
			}
		}

		var_10_0.CustomKillSay.vwep = {}

		client.set_event_callback("run_command", function()
			for iter_138_0 = 1, globals.maxplayers() do
				local var_138_0 = entity.get_prop(iter_138_0, "m_hActiveWeapon")

				if var_138_0 then
					var_10_0.CustomKillSay.vwep[iter_138_0] = var_138_0
				end
			end
		end)

		local var_10_17 = ui.get(var_10_0.CustomKillSay.template)

		client.set_event_callback("post_render", function()
			local var_139_0 = ui.get(var_10_0.CustomKillSay.template)

			if var_139_0 ~= var_10_17 then
				var_10_17 = var_139_0

				local var_139_1 = var_139_0:match("{(%a*%d*)$")

				if var_139_1 then
					local var_139_2 = false

					if var_139_1:len() > 0 then
						for iter_139_0, iter_139_1 in ipairs(var_10_16) do
							if iter_139_1[1]:sub(1, var_139_1:len()) == var_139_1:lower() then
								var_139_2 = iter_139_1

								break
							end
						end

						if var_139_2 then
							ui.set(var_10_0.CustomKillSay.helper1, "{" .. var_139_2[1] .. "} - " .. var_139_2[2])
						else
							ui.set(var_10_0.CustomKillSay.helper1, "no matches found for {" .. var_139_1 .. "}")
						end

						ui.set_visible(var_10_0.CustomKillSay.helper2, false)
						ui.set_visible(var_10_0.CustomKillSay.helper3, false)
						ui.set_visible(var_10_0.CustomKillSay.helper4, false)
						ui.set_visible(var_10_0.CustomKillSay.helper5, false)
						ui.set_visible(var_10_0.CustomKillSay.helper6, false)
						ui.set_visible(var_10_0.CustomKillSay.helper7, false)
					else
						local var_139_3 = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {},
							helper6 = {},
							helper7 = {}
						}
						local var_139_4 = {}

						for iter_139_2, iter_139_3 in ipairs(var_10_16) do
							var_139_4[#var_139_4 + 1] = iter_139_3[1]
						end

						for iter_139_4 = 1, 7 do
							local var_139_5 = var_139_4[iter_139_4]

							if var_139_5 then
								var_139_3.helper1[#var_139_3.helper1 + 1] = var_139_5
							end
						end

						for iter_139_5 = 8, 14 do
							local var_139_6 = var_139_4[iter_139_5]

							if var_139_6 then
								var_139_3.helper2[#var_139_3.helper2 + 1] = var_139_6
							end
						end

						for iter_139_6 = 15, 21 do
							local var_139_7 = var_139_4[iter_139_6]

							if var_139_7 then
								var_139_3.helper3[#var_139_3.helper3 + 1] = var_139_7
							end
						end

						for iter_139_7 = 22, 28 do
							local var_139_8 = var_139_4[iter_139_7]

							if var_139_8 then
								var_139_3.helper4[#var_139_3.helper4 + 1] = var_139_8
							end
						end

						for iter_139_8 = 29, 35 do
							local var_139_9 = var_139_4[iter_139_8]

							if var_139_9 then
								var_139_3.helper5[#var_139_3.helper5 + 1] = var_139_9
							end
						end

						for iter_139_9 = 36, 42 do
							local var_139_10 = var_139_4[iter_139_9]

							if var_139_10 then
								var_139_3.helper6[#var_139_3.helper6 + 1] = var_139_10
							end
						end

						for iter_139_10 = 43, 49 do
							local var_139_11 = var_139_4[iter_139_10]

							if var_139_11 then
								var_139_3.helper7[#var_139_3.helper7 + 1] = var_139_11
							end
						end

						ui.set(var_10_0.CustomKillSay.helper1, table.concat(var_139_3.helper1, ", "))
						ui.set(var_10_0.CustomKillSay.helper2, table.concat(var_139_3.helper2, ", "))
						ui.set(var_10_0.CustomKillSay.helper3, table.concat(var_139_3.helper3, ", "))
						ui.set(var_10_0.CustomKillSay.helper4, table.concat(var_139_3.helper4, ", "))
						ui.set(var_10_0.CustomKillSay.helper5, table.concat(var_139_3.helper5, ", "))
						ui.set(var_10_0.CustomKillSay.helper6, table.concat(var_139_3.helper6, ", "))
						ui.set(var_10_0.CustomKillSay.helper7, table.concat(var_139_3.helper7, ", "))
						ui.set_visible(var_10_0.CustomKillSay.helper1, #var_139_3.helper1 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper2, #var_139_3.helper2 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper3, #var_139_3.helper3 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper4, #var_139_3.helper4 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper5, #var_139_3.helper5 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper6, #var_139_3.helper6 > 0)
						ui.set_visible(var_10_0.CustomKillSay.helper7, #var_139_3.helper7 > 0)
					end
				else
					ui.set(var_10_0.CustomKillSay.helper1, "Helper: " .. var_139_0 .. "_")
					ui.set_visible(var_10_0.CustomKillSay.helper2, false)
					ui.set_visible(var_10_0.CustomKillSay.helper3, false)
					ui.set_visible(var_10_0.CustomKillSay.helper4, false)
					ui.set_visible(var_10_0.CustomKillSay.helper5, false)
					ui.set_visible(var_10_0.CustomKillSay.helper6, false)
					ui.set_visible(var_10_0.CustomKillSay.helper7, false)
				end
			end
		end)
		client.set_event_callback("player_death", function(arg_140_0)
			if not ui.get(var_10_0.CustomKillSay.enable) then
				return
			end

			local var_140_0 = entity.get_local_player()
			local var_140_1 = client.userid_to_entindex(arg_140_0.attacker)
			local var_140_2 = client.userid_to_entindex(arg_140_0.userid)

			if var_140_1 == var_140_0 and var_140_1 ~= var_140_2 then
				local var_140_3 = {}

				for iter_140_0, iter_140_1 in ipairs(var_10_16) do
					local var_140_4 = iter_140_1[1]
					local var_140_5 = iter_140_1[2]

					var_140_3[var_140_4] = iter_140_1[3](var_140_2, var_140_1, arg_140_0.userid, arg_140_0.attacker)
				end

				local var_140_6 = processTags(ui.get(var_10_0.CustomKillSay.template), var_140_3)

				MessageQueue:Say(var_140_6)
			end
		end)
	end

	if var_0_18.get("Report Enemy Tool") then
		var_10_0.ReportTool = {}
		var_10_0.ReportTool.enable = ui.new_checkbox("Lua", "B", "Report Tool")
		var_10_0.ReportTool.hotkey = ui.new_hotkey("Lua", "B", "Report Tool", true)

		local var_10_18 = {
			{
				"textabuse",
				"Comms Abuse"
			},
			{
				"voiceabuse",
				"Voice Abuse"
			},
			{
				"grief",
				"Griefing"
			},
			{
				"aimbot",
				"Aim Hacking"
			},
			{
				"wallhack",
				"Wall Hacking"
			},
			{
				"speedhack",
				"Other Hacking"
			}
		}
		local var_10_19 = {}
		local var_10_20 = {}

		for iter_10_2, iter_10_3 in ipairs(var_10_18) do
			var_10_19[#var_10_19 + 1] = iter_10_3[2]
			var_10_20[iter_10_3[2]] = iter_10_3[1]
		end

		var_10_0.ReportTool.types = ui.new_multiselect("Lua", "B", "Types", var_10_19)

		ui.set(var_10_0.ReportTool.types, {
			"Aim Hacking",
			"Wall Hacking",
			"Other Hacking"
		})

		local var_10_21

		local function var_10_22()
			if var_10_21 or not ui.get(var_10_0.ReportTool.enable) then
				return
			end

			local var_141_0 = ui.get(var_10_0.ReportTool.types)
			local var_141_1 = ""

			for iter_141_0, iter_141_1 in pairs(var_141_0) do
				var_141_1 = iter_141_0 == 1 and var_10_20[iter_141_1] or var_141_1 .. "," .. var_10_20[iter_141_1]
			end

			local var_141_2 = {}

			for iter_141_2 = 1, globals.maxplayers() do
				local var_141_3 = var_0_9.GetPlayerXuidStringFromEntIndex(iter_141_2)

				if var_141_3:len() > 5 and entity.is_enemy(iter_141_2) then
					var_141_2[#var_141_2 + 1] = var_141_3
				end
			end

			for iter_141_3, iter_141_4 in ipairs(var_141_2) do
				var_10_21 = true

				client.delay_call((iter_141_3 - 1) * 1, function()
					var_0_9.SubmitPlayerReport(iter_141_4, var_141_1)

					if iter_141_3 == #var_141_2 then
						client.delay_call(1, function()
							var_10_21 = false
						end)
					end
				end)
			end
		end

		client.set_event_callback("net_update_end", function()
			local var_144_0, var_144_1 = ui.get(var_10_0.ReportTool.hotkey)

			if var_144_0 and not ui.is_menu_open() then
				var_10_22()
			end
		end)

		var_10_0.ReportTool.submit = ui.new_button("Lua", "B", "Report!", var_10_22)

		ui.set_callback(var_10_0.ReportTool.enable, function(arg_145_0)
			local var_145_0 = ui.get(arg_145_0)

			ui.set_visible(var_10_0.ReportTool.types, var_145_0)
			ui.set_visible(var_10_0.ReportTool.submit, var_145_0)
		end)
		ui.set_visible(var_10_0.ReportTool.types, false)
		ui.set_visible(var_10_0.ReportTool.submit, false)
	end

	if var_0_18.get("Account Checkers") then
		local var_10_23 = {
			registered = {}
		}

		function var_10_23.new(arg_146_0, arg_146_1, arg_146_2)
			local var_146_0 = {
				name = arg_146_0,
				desc = arg_146_1,
				callback = arg_146_2,
				cache = {},
				start = function(arg_147_0)
					return
				end,
				stop = function(arg_148_0)
					return
				end,
				isRunning = function(arg_149_0)
					return
				end
			}

			var_10_23.registered[#var_10_23.registered + 1] = var_146_0

			return var_146_0
		end

		local var_10_24 = false

		function var_10_23._StartBTN()
			if var_10_24 then
				return
			end

			var_10_24 = true

			local var_150_0 = ui.get(var_10_23.type)
			local var_150_1
			local var_150_2

			for iter_150_0, iter_150_1 in ipairs(var_10_23.registered) do
				if iter_150_1.name == var_150_0 then
					var_150_1 = iter_150_1
				end
			end

			if var_150_1 then
				local var_150_3 = ui.get(var_10_23.target)
				local var_150_4 = {}

				if var_0_9.IsConnectedOrConnectingToServer() then
					for iter_150_2 = 1, globals.maxplayers() do
						local var_150_5 = var_0_9.GetLocalPlayerXuid()
						local var_150_6 = var_0_9.GetPlayerXuidStringFromEntIndex(iter_150_2)
						local var_150_7 = var_0_9.ArePlayersEnemies(var_150_5, var_150_6)

						if var_150_6 and var_150_6:len() == 17 and (var_150_3 == "Everyone" or var_150_3 == "Teammates" and not var_150_7 or var_150_3 == "Enemies" and var_150_7) then
							var_150_4[#var_150_4 + 1] = {
								var_150_6,
								entity.get_player_name(iter_150_2)
							}
						end
					end
				elseif var_0_14.IsSessionActive() then
					IsLobby = true

					for iter_150_3 = 0, var_0_12.GetCount() - 1 do
						local var_150_8 = var_0_12.GetXuidByIndex(iter_150_3)

						var_150_4[#var_150_4 + 1] = {
							var_150_8,
							var_0_12.GetFriendName(var_150_8)
						}
					end
				end

				if #var_150_4 > 0 then
					ui.set(var_10_23.status, "Status: Checking 0/" .. #var_150_4 .. "!")

					local var_150_9 = 1

					function DispatchMessageOut(arg_151_0, arg_151_1, arg_151_2)
						ui.set(var_10_23.status, "Status: Checking " .. arg_151_1 .. "/" .. #arg_151_2 .. "!")

						local var_151_0 = var_150_1.cache[arg_151_0]

						if var_151_0 then
							if var_0_9.IsConnectedOrConnectingToServer() then
								local var_151_1 = ui.get(var_10_23.output)
								local var_151_2 = var_151_0.server

								if var_151_0.localchat and not var_151_0.server then
									var_151_2 = var_151_0.localchat
									var_151_1 = "Local Chat"
								end

								var_10_0.ChatMethods[var_151_1](var_151_2)
							elseif var_151_0.lobby and var_0_14.IsSessionActive() then
								local var_151_3 = ui.get(var_10_23.output)

								if var_151_3 ~= "Console" then
									var_151_3 = "Party Chat"
								end

								var_10_0.ChatMethods[var_151_3](var_150_1.cache[arg_151_0].lobby)
							end
						end

						if var_150_9 == #arg_151_2 then
							var_10_24 = false

							ui.set(var_10_23.status, "Status: Finished " .. arg_151_1 .. "/" .. #arg_151_2 .. "!")
						end
					end

					function CheckTarget(arg_152_0)
						if var_150_4[arg_152_0] then
							local var_152_0 = var_150_4[arg_152_0][1]
							local var_152_1 = var_150_4[arg_152_0][2]

							if var_150_1.cache[var_152_0] then
								DispatchMessageOut(var_152_0, arg_152_0, var_150_4)

								var_150_9 = var_150_9 + 1

								CheckTarget(var_150_9)
							else
								var_150_1.callback(var_152_0, var_152_1, function(arg_153_0)
									if arg_153_0 then
										var_150_1.cache[var_152_0] = var_150_1.cache[var_152_0] or {}
										var_150_1.cache[var_152_0].server = arg_153_0.server and "[" .. var_150_1.name .. "] " .. arg_153_0.server
										var_150_1.cache[var_152_0].localchat = arg_153_0.localchat and " \a[" .. var_150_1.name .. "] \n" .. arg_153_0.localchat
										var_150_1.cache[var_152_0].lobby = arg_153_0.lobby and "[" .. var_150_1.desc .. "] " .. arg_153_0.lobby
									end

									DispatchMessageOut(var_152_0, arg_152_0, var_150_4)

									var_150_9 = var_150_9 + 1

									CheckTarget(var_150_9)
								end, function(arg_154_0)
									if arg_154_0 then
										if var_0_9.IsConnectedOrConnectingToServer() then
											local var_154_0 = ui.get(var_10_23.output)

											var_10_0.ChatMethods[var_154_0](arg_154_0)
										elseif var_0_14.IsSessionActive() then
											var_10_0.ChatMethods["Party Chat"](arg_154_0)
										end
									end

									CheckTarget(var_150_9)
								end, function()
									var_10_24 = false

									ui.set(var_10_23.status, "Status: Finished " .. #var_150_4 .. "/" .. #var_150_4 .. "!")
								end, var_150_1)
							end
						end
					end

					CheckTarget(var_150_9)
				end
			end
		end

		if var_0_18.get("Crack Checker") then
			local function var_10_25(arg_156_0, arg_156_1)
				if var_0_20 == nil then
					var_0_20 = LolzPanorama.get_data()

					if var_0_20 ~= nil then
						var_0_20 = json.parse(tostring(var_0_20))
					else
						client.delay_call(0.1, var_10_25, arg_156_0, arg_156_1)

						return
					end
				end

				if var_0_20 ~= nil then
					local var_156_0 = {
						user_id = "",
						new = true,
						_xfResponseType = "json",
						_xfNoRedirect = "1",
						_xfRequestUri = "/market/steam/",
						order_by = "pdate_to_down",
						_formSubmitted = "true",
						_itemCount = "1",
						category_id = "1",
						title = arg_156_0
					}
					local var_156_1 = {
						Cookie = var_0_20.cookie
					}

					var_0_2.get("https://lolz.guru/market", {
						params = var_156_0,
						headers = var_156_1
					}, function(arg_157_0, arg_157_1)
						if arg_157_1.status == 200 then
							local var_157_0 = json.parse(arg_157_1.body)

							arg_156_1(arg_157_0, arg_157_1, var_157_0)
						else
							arg_156_1(arg_157_0, arg_157_1)
						end
					end)
				end
			end

			local function var_10_26(...)
				if var_0_20 == nil then
					LolzPanorama.create()
					client.delay_call(0.1, var_10_25, ...)
				else
					var_10_25(...)
				end
			end

			var_10_23.new("Crack Checker", "CrackCheck", function(arg_159_0, arg_159_1, arg_159_2, arg_159_3, arg_159_4, arg_159_5)
				var_10_26(arg_159_0, function(arg_160_0, arg_160_1, arg_160_2)
					if arg_160_1.status == 200 then
						local var_160_0 = arg_160_2.templateHtml
						local var_160_1 = {}
						local var_160_2 = "(<div id=\"marketItem%-%-.+\">.+class=\"marketIndexItem%-%-topContainer\")"

						for iter_160_0 in var_160_0:gmatch(var_160_2) do
							local var_160_3 = iter_160_0:match("<div id=\"marketItem%-%-(%d+)\"")
							local var_160_4 = iter_160_0:match("<span class=\"Value\">(%d+,?.?%d+)</span>"):gsub(",", ".")

							var_160_1[#var_160_1 + 1] = {
								var_160_3,
								math.floor(var_160_4 * 100) / 100
							}
						end

						if #var_160_1 > 0 then
							local var_160_5 = {
								name = arg_159_1,
								id = arg_159_0,
								times = #var_160_1,
								price = string.format("%.2f", var_160_1[1][2]),
								marketid = var_160_1[1][1]
							}

							var_160_5.link = "https://lolz.guru/market/" .. var_160_5.marketid

							local var_160_6 = {}
							local var_160_7 = {}

							for iter_160_1, iter_160_2 in ipairs(var_160_1) do
								var_160_6[#var_160_6 + 1] = iter_160_2[2]
								var_160_7[#var_160_7 + 1] = iter_160_2[1]
							end

							var_160_5.min = math.min(unpack(var_160_6))
							var_160_5.max = math.max(unpack(var_160_6))
							var_160_5.links = table.concat(var_160_7, ", ")

							local var_160_8 = {
								server = processTags("Acc {name} sold {times} times for {price}usd on LolzTeam, market ID: {marketID}", var_160_5),
								lobby = processTags("Acc {name} - {price}USD - ID: {marketID}", var_160_5)
							}

							arg_159_2(var_160_8)
						else
							local var_160_9 = {
								localchat = arg_159_1 .. "'s account was not sold on Lolz.Team."
							}

							arg_159_2(var_160_9)
						end
					else
						local var_160_10 = {
							localchat = arg_159_1 .. "'s failed to check with Lolz.guru, is Lolz offline?"
						}

						arg_159_2(var_160_10)
					end
				end)
			end)
		end

		if var_0_18.get("Faceit Checker") then
			local var_10_27

			var_10_23.new("Faceit Checker", "FACEIT", function(arg_161_0, arg_161_1, arg_161_2, arg_161_3, arg_161_4, arg_161_5)
				if not var_10_27 then
					var_0_2.get("https://api.faceit.com/stats/v1/stats/configuration/csgo", function(arg_162_0, arg_162_1)
						var_10_27 = json.parse(arg_162_1.body)

						arg_161_3()
					end)

					return
				end

				var_0_2.get("https://api.faceit.com/search/v1/?limit=3&query=" .. arg_161_0, function(arg_163_0, arg_163_1)
					if arg_163_0 then
						local var_163_0 = json.parse(arg_163_1.body)
						local var_163_1 = {}

						if var_163_0 and var_163_0.payload.players.total_count > 0 then
							local var_163_2 = var_163_0.payload.players.results[#var_163_0.payload.players.results]

							var_163_1.id = var_163_2.id
							var_163_1.nickname = var_163_2.nickname
							var_163_1.country = var_163_2.country

							var_0_2.get("https://api.faceit.com/stats/v1/stats/users/" .. var_163_1.id .. "/games/csgo", function(arg_164_0, arg_164_1)
								if not arg_164_0 then
									return arg_161_3()
								end

								local var_164_0 = json.parse(arg_164_1.body)

								if var_164_0 then
									local var_164_1 = var_10_27.grouping.main_stats[5]
									local var_164_2 = var_10_27.grouping.user_win_rate
									local var_164_3 = var_10_27.grouping.main_stats[6]
									local var_164_4 = var_10_27.grouping.main_stats[1]
									local var_164_5 = {
										name = arg_161_1,
										steamid = arg_161_0,
										id = var_163_1.id,
										user = var_163_1.nickname,
										country = var_163_1.country
									}

									if var_164_0.lifetime then
										var_163_1.kdratio = var_164_0.lifetime[var_164_1]
										var_163_1.winratio = var_164_0.lifetime[var_164_2]
										var_163_1.hschance = var_164_0.lifetime[var_164_3]
										var_163_1.matches = var_164_0.lifetime[var_164_4]
										var_164_5.kdratio = var_163_1.kdratio
										var_164_5.win = var_163_1.winratio .. "%"
										var_164_5.hschance = var_163_1.hschance
										var_164_5.matches = var_163_1.matches
									end

									var_0_2.get("https://api.faceit.com/users/v1/nicknames/" .. var_163_1.nickname, function(arg_165_0, arg_165_1)
										if not arg_165_0 then
											return arg_161_3()
										end

										local var_165_0 = json.parse(arg_165_1.body)

										if var_165_0 and var_165_0.result == "OK" then
											if var_165_0.payload.games and var_165_0.payload.games.csgo then
												var_164_5.level = var_165_0.payload.games.csgo.skill_level or 0
												var_164_5.elo = var_165_0.payload.games.csgo.faceit_elo
											end

											local var_165_1 = {
												server = processTags("{name} has a level {level} FaceIt Account ({user})!", var_164_5),
												lobby = processTags("{name} - Level: {level} - User: {user}!", var_164_5)
											}

											arg_161_2(var_165_1)
										end
									end)
								end
							end)
						else
							var_10_0.ChatMethods["Local Chat"](" \a[" .. arg_161_5.name .. "] \n" .. arg_161_1 .. "'s account was not found on FaceIT!")
							arg_161_2()
						end
					else
						arg_161_3("No Fucking Clue, dm csmit195#4729 if error persists")
					end
				end)
			end)
		end

		if var_0_18.get("Inventory Value") then
			local var_10_28
			local var_10_29 = {
				"",
				"https://api.codetabs.com/v1/proxy/?quest=",
				"https://thingproxy.freeboard.io/fetch/"
			}
			local var_10_30 = 1

			local function var_10_31()
				var_10_30 = var_10_30 + 1

				if var_10_30 > #var_10_29 then
					var_10_30 = 1
				end

				print("new proxy: ", var_10_30, " : ", var_10_29[var_10_30])
			end

			var_10_23.new("Inventory Value", "Inventory", function(arg_167_0, arg_167_1, arg_167_2, arg_167_3, arg_167_4, arg_167_5)
				if not var_10_28 then
					var_0_2.get("http://csgobackpack.net/api/GetItemsList/v2/?no_details=1&details=0", {
						absolute_timeout = 300,
						network_timeout = 300
					}, function(arg_168_0, arg_168_1)
						if not arg_168_0 then
							return
						end

						client.delay_call(1, function()
							var_10_28 = json.parse(arg_168_1.body)

							client.delay_call(1, arg_167_3)
						end)
					end)

					return
				end

				var_0_2.get("https://steamcommunity.com/profiles/" .. arg_167_0 .. "/inventory/", function(arg_170_0, arg_170_1)
					if not arg_170_0 or not arg_170_1.body then
						return arg_167_3()
					end

					local var_170_0 = arg_170_1.body:match("<div class=\"profile_private_info\">") ~= nil
					local var_170_1 = arg_170_1.body:match("'s inventory is currently private.") ~= nil

					if var_170_0 or var_170_1 then
						local var_170_2 = {
							localchat = arg_167_1 .. "'s " .. (var_170_0 and "profile" or "inventory") .. " is private"
						}

						var_170_2.lobby = var_170_2.localchat

						return arg_167_2(var_170_2)
					end

					print("requesting: ", var_10_29[var_10_30] .. "https://steamcommunity.com/profiles/" .. arg_167_0 .. "/inventory/json/730/2")
					var_0_2.get(var_10_29[var_10_30] .. "https://steamcommunity.com/profiles/" .. arg_167_0 .. "/inventory/json/730/2", function(arg_171_0, arg_171_1)
						if not arg_171_0 or not arg_171_1.body then
							var_10_31()

							return arg_167_3()
						end

						local var_171_0 = json.parse(arg_171_1.body)

						if var_171_0 and type(var_171_0) ~= "userdata" and arg_171_1.body then
							if not var_171_0.success then
								var_10_31()

								return client.delay_call(5, arg_167_3)
							end

							local var_171_1 = {}
							local var_171_2 = 0

							for iter_171_0, iter_171_1 in pairs(var_171_0.rgDescriptions) do
								if iter_171_1.marketable == 1 then
									local var_171_3 = var_10_28.items_list[iter_171_1.market_hash_name]
									local var_171_4 = var_171_3 and var_171_3.price and (var_171_3.price["30_days"] or var_171_3.price.all_time)

									if var_171_4 then
										var_171_2 = var_171_2 + var_171_4.median
									end
								end
							end

							local var_171_5 = {
								server = arg_167_1 .. "'s inventory value is worth $" .. string.format("%.2f", var_171_2) .. "USD",
								lobby = arg_167_1 .. " - Value: $" .. string.format("%.2f", var_171_2) .. "USD"
							}

							arg_167_2(var_171_5)
						else
							var_10_31()
							arg_167_3()
						end
					end)
				end)
			end)
		end

		if var_0_18.get("Game Value") then
			var_10_23.new("Game Value", "Games", function(arg_172_0, arg_172_1, arg_172_2, arg_172_3, arg_172_4, arg_172_5)
				var_0_2.get("https://steamid.pro/lookup/" .. arg_172_0, function(arg_173_0, arg_173_1)
					if not arg_173_0 or arg_173_1.status ~= 200 then
						return arg_172_3("error checking " .. arg_172_0)
					end

					local var_173_0 = arg_173_1.body:match("<span class=\"number%-price\">$(%d+)</span>")

					if var_173_0 then
						local var_173_1 = {
							server = arg_172_1 .. "'s account is worth $" .. var_173_0 .. "!"
						}

						arg_172_2(var_173_1)
					else
						arg_172_3("no price found, wtf? dm csmit195#4729 if the error persists.")
					end
				end)
			end)
		end

		var_10_23.new("Live Checker", "Games", function(arg_174_0, arg_174_1, arg_174_2, arg_174_3, arg_174_4, arg_174_5)
			LiveCheck:start(arg_174_0, function(arg_175_0, arg_175_1)
				local var_175_0 = {}

				if var_175_0 then
					var_175_0.server = "[LiveCheck] " .. arg_174_0 .. " == " .. arg_175_1.state
				else
					var_175_0.server = "[LiveCheck] " .. arg_174_0 .. " == No response"
				end

				arg_174_2(var_175_0)
			end)
		end)

		if var_0_18.get("Banned Friends") then
			var_10_23.new("Banned Friends", "Banned", function(arg_176_0, arg_176_1, arg_176_2, arg_176_3, arg_176_4, arg_176_5)
				var_0_2.get("https://steamcommunity.com/profiles/" .. arg_176_0 .. "/friends/", function(arg_177_0, arg_177_1)
					if not arg_177_0 or arg_177_1.status ~= 200 then
						return arg_176_3("failed to check " .. arg_176_0 .. "'s friends, dm csmit195#4729 if error persists")
					end

					local var_177_0 = {}

					for iter_177_0 in arg_177_1.body:gmatch("data%-steamid=\"(%d+)\"") do
						var_177_0[#var_177_0 + 1] = iter_177_0
					end

					local var_177_1 = {}

					for iter_177_1, iter_177_2 in ipairs(var_177_0) do
						local var_177_2 = math.floor(iter_177_1 / 100) + 1

						var_177_1[var_177_2] = var_177_1[var_177_2] or {}
						var_177_1[var_177_2][#var_177_1[var_177_2] + 1] = iter_177_2
					end

					if #var_177_1 == 0 then
						return arg_176_2()
					end

					local var_177_3 = 0
					local var_177_4 = 0
					local var_177_5 = false

					for iter_177_3, iter_177_4 in ipairs(var_177_1) do
						local var_177_6 = table.concat(iter_177_4, ",")

						var_0_2.get("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=" .. RandomWebKey() .. "&steamids=" .. var_177_6, function(arg_178_0, arg_178_1)
							if not arg_178_0 or arg_178_1.status ~= 200 or var_177_5 then
								var_177_5 = true

								return arg_176_3("unknown error, retrying")
							end

							local var_178_0 = json.parse(arg_178_1.body)

							if var_178_0 and var_178_0.players then
								for iter_178_0, iter_178_1 in ipairs(var_178_0.players) do
									var_177_3 = var_177_3 + 1

									if iter_178_1.NumberOfVACBans > 0 or iter_178_1.NumberOfGameBans > 0 then
										var_177_4 = var_177_4 + 1
									end

									if var_177_3 == #var_177_0 then
										local var_178_1 = {
											server = arg_176_1 .. " has " .. var_177_4 .. "/" .. #var_177_0 .. " banned friends!",
											lobbychat = arg_176_1 .. " - " .. var_177_4 .. "/" .. #var_177_0 .. " banned friends!"
										}

										arg_176_2(var_178_1)
									end
								end
							end
						end)
					end
				end)
			end)
		end

		local function var_10_32(arg_179_0)
			local var_179_0 = {}
			local var_179_1 = 0
			local var_179_2 = var_0_17.GetFriendPersonaNameHistory(arg_179_0, var_179_1)

			if var_179_2 ~= "" then
				repeat
					var_179_0[#var_179_0 + 1] = var_179_2
					var_179_1 = var_179_1 + 1
					var_179_2 = var_0_17.GetFriendPersonaNameHistory(arg_179_0, var_179_1)
				until var_179_2 == ""
			end

			return var_179_0
		end

		if var_0_18.get("Name History") then
			var_10_23.new("Name History", "Names", function(arg_180_0, arg_180_1, arg_180_2, arg_180_3, arg_180_4, arg_180_5)
				local var_180_0 = var_10_32(arg_180_0)

				if #var_180_0 > 0 then
					local var_180_1 = {
						server = table.concat(var_180_0, ", ")
					}

					var_180_1.lobby = var_180_1.server

					arg_180_2(var_180_1)
				else
					arg_180_2()
				end
			end)
		end

		var_10_23.enable = ui.new_checkbox("Lua", "B", "Account Checkers")

		local var_10_33 = {}

		for iter_10_4, iter_10_5 in ipairs(var_10_23.registered) do
			var_10_33[#var_10_33 + 1] = iter_10_5.name
		end

		if #var_10_33 == 0 then
			var_10_33 = {
				"Empty..."
			}
		end

		var_10_23.type = ui.new_combobox("Lua", "B", "Type", var_10_33)
		var_10_23.target = ui.new_combobox("Lua", "B", "Target", {
			"Everyone",
			"Teammates",
			"Enemies"
		})
		var_10_23.output = ui.new_combobox("Lua", "B", "Output", {
			"Local Chat",
			"Party Chat",
			"Game Chat",
			"Team Chat",
			"Console"
		})

		ui.set(var_10_23.output, "Local Chat")

		var_10_23.status = ui.new_label("Lua", "B", "Status: Idle...")
		var_10_23.check = ui.new_button("Lua", "B", "Check", var_10_23._StartBTN)

		ui.set_visible(var_10_23.type, false)
		ui.set_visible(var_10_23.target, false)
		ui.set_visible(var_10_23.output, false)
		ui.set_visible(var_10_23.status, false)
		ui.set_visible(var_10_23.check, false)
		ui.set_callback(var_10_23.enable, function(arg_181_0)
			local var_181_0 = ui.get(arg_181_0)

			ui.set_visible(var_10_23.type, var_181_0)
			ui.set_visible(var_10_23.target, var_181_0)
			ui.set_visible(var_10_23.output, var_181_0)
			ui.set_visible(var_10_23.status, var_181_0)
			ui.set_visible(var_10_23.check, var_181_0)
		end)
	end

	if var_0_18.get("Whitelist Friends on Key") then
		var_10_0.WhitelistLegitsOnKey = {}
		var_10_0.WhitelistLegitsOnKey.enable = ui.new_checkbox("Lua", "B", "Whitelist Legits on key")
		var_10_0.WhitelistLegitsOnKey.hotkey = ui.new_hotkey("Lua", "B", "Whitelist Legits on key", true)

		client.set_event_callback("run_command", function()
			local var_182_0, var_182_1 = ui.get(var_10_0.WhitelistLegitsOnKey.hotkey)

			for iter_182_0, iter_182_1 in ipairs(entity.get_players(true)) do
				if var_0_21 and var_0_21.cache and var_0_21.cache[iter_182_1] and var_0_21.cache[iter_182_1][var_0_21.MarkAsLegit] then
					plist.set(iter_182_1, "Add to whitelist", ui.get(var_10_0.WhitelistLegitsOnKey.enable) and var_182_0 and var_0_21.cache[iter_182_1][var_0_21.MarkAsLegit])
				end
			end
		end)
		client.register_esp_flag("WHITELISTED", 255, 255, 255, function(arg_183_0)
			local var_183_0, var_183_1 = ui.get(var_10_0.WhitelistLegitsOnKey.hotkey)

			if var_0_21 and var_0_21.cache and var_0_21.cache[arg_183_0] and var_0_21.cache[arg_183_0][var_0_21.MarkAsLegit] then
				return ui.get(var_10_0.WhitelistLegitsOnKey.enable) and var_183_0 and var_0_21.cache[arg_183_0][var_0_21.MarkAsLegit]
			end

			return false
		end)
	end

	if var_0_18.get("Chat Commands") then
		var_10_0.ChatCommands = {}
		var_10_0.ChatCommands.enable = ui.new_checkbox("Lua", "B", "In-game Chat Commands")

		ui.set_callback(var_10_0.ChatCommands.enable, function(arg_184_0)
			local var_184_0 = ui.get(arg_184_0)

			ui.set_visible(var_10_0.ChatCommands.commands, var_184_0)
		end)

		local var_10_34 = {}

		function var_10_34.register(arg_185_0, arg_185_1, arg_185_2, arg_185_3)
			local var_185_0 = {
				name = arg_185_0,
				desc = arg_185_1,
				alias = arg_185_2,
				exec = arg_185_3
			}

			var_10_34.commands = var_10_34.commands or {}
			var_10_34.commands[#var_10_34.commands + 1] = var_185_0

			return var_185_0
		end

		local var_10_35 = {}

		function var_10_35.register(arg_186_0, arg_186_1)
			local var_186_0 = {
				name = arg_186_0,
				hex = arg_186_1
			}

			var_10_35.colors = var_10_35.colors or {}
			var_10_35.colors[#var_10_35.colors + 1] = var_186_0

			return var_186_0
		end

		function var_10_35.fromHex(arg_187_0, arg_187_1)
			local var_187_0 = arg_187_1:gsub("#", "")

			for iter_187_0, iter_187_1 in ipairs(var_10_35.colors) do
				local var_187_1 = iter_187_1.hex:gsub("#", "")

				if var_187_0:lower() == var_187_0:lower() then
					return iter_187_1
				end
			end
		end

		function var_10_35.fromName(arg_188_0, arg_188_1)
			for iter_188_0, iter_188_1 in ipairs(var_10_35.colors) do
				if iter_188_1.name:lower() == arg_188_1:lower() then
					return iter_188_1
				end
			end
		end

		var_10_35.register("yellow", "#F8F62D")
		var_10_35.register("purple", "#A119F0")
		var_10_35.register("green", "#00B562")
		var_10_35.register("blue", "#5CA8FF")
		var_10_35.register("orange", "#FF9B25")

		local function var_10_36(arg_189_0)
			if not arg_189_0 or type(arg_189_0) ~= "string" or type(arg_189_0) ~= "number" then
				return
			end

			local var_189_0

			if tonumber(arg_189_0) then
				local var_189_1 = client.userid_to_entindex(arg_189_0)

				if var_189_1 then
					var_189_0 = var_189_1
				end
			end

			local var_189_2 = var_10_35:fromName(arg_189_0)

			for iter_189_0 = 1, globals.maxplayers() do
				local var_189_3 = var_0_9.GetPlayerXuidStringFromEntIndex(iter_189_0)
				local var_189_4 = var_0_9.GetPlayerColor(var_189_3)

				if var_189_2 and var_10_35:fromHex(var_189_4) == var_189_2 then
					var_189_0 = iter_189_0

					break
				end

				if entity.get_player_name(iter_189_0):lower():find(arg_189_0:lower()) then
					var_189_0 = iter_189_0

					break
				end
			end

			if var_189_0 then
				local var_189_5 = var_0_9.GetLocalPlayerXuid()
				local var_189_6 = {
					xuid = var_0_9.GetPlayerXuidStringFromEntIndex(var_189_0),
					entid = var_189_0,
					name = entity.get_player_name(var_189_0),
					enemy = var_0_9.ArePlayersEnemies(var_189_5, SteamXUID)
				}

				var_189_6.color = var_0_9.GetPlayerColor(var_189_6.xuid)

				return var_189_6
			end
		end

		var_10_34.register("kick", "call vote kick", {
			"kick",
			"k",
			"votekick",
			"vk"
		}, function(arg_190_0, arg_190_1, arg_190_2)
			local var_190_0 = var_10_36(arg_190_2[1])

			print("test", var_190_0)

			if var_190_0 then
				local var_190_1 = getPlayerInfo(var_190_0.entid)

				print("hello...")
				client.exec("callvote ", "kick ", var_190_1.userid)
			end
		end)
		var_10_34.register("mute", "mutes the player", {
			"mute",
			"m",
			"silence",
			"ignore",
			"i",
			"block"
		}, function(arg_191_0, arg_191_1, arg_191_2)
			local var_191_0 = var_10_36(arg_191_2[1])

			if var_191_0 then
				var_0_9.ToggleMute(var_191_0.xuid)
			end
		end)
		var_10_34.register("map", "calls map vote", {
			"map",
			"m",
			"votemap",
			"vm"
		}, function(arg_192_0, arg_192_1, arg_192_2)
			print("test", arg_192_2[1])

			if arg_192_2[1] then
				client.exec("callvote ", "ChangeLevel ", arg_192_2[1])
			end
		end)
		var_10_34.register("timeout", "calls timeout", {
			"timeout",
			"pause",
			"t",
			"p",
			"calltimeout"
		}, function(arg_193_0, arg_193_1, arg_193_2)
			client.exec("callvote ", "StartTimeOut")
		end)
		var_10_34.register("surrender", "calls surrender", {
			"forfeit",
			"ff",
			"surrender",
			"surr",
			"giveup",
			"kms",
			"kys"
		}, function(arg_194_0, arg_194_1, arg_194_2)
			client.exec("callvote ", "Surrender")
		end)
		var_10_34.register("gay", "checks gay status", {
			"gay"
		}, function(arg_195_0, arg_195_1, arg_195_2)
			return arg_195_1 .. " is " .. (math.random(1, 2) == 1 and "gay" or "not gay") .. "!"
		end)
		var_10_34.register("techtimeout", "leaves for 1 min 45s", {
			"techtimeout",
			"tt"
		}, function(arg_196_0, arg_196_1, arg_196_2)
			if var_0_8.HasOngoingMatch() then
				client.exec("disconnect")
				client.delay_call(105, function()
					var_0_8.ActionReconnectToOngoingMatch()
				end)
			end
		end)

		local var_10_37 = {}
		local var_10_38 = {}
		local var_10_39 = {}

		for iter_10_6, iter_10_7 in ipairs(var_10_34.commands) do
			local var_10_40 = "!" .. iter_10_7.name .. " - " .. iter_10_7.desc

			var_10_37[#var_10_37 + 1] = var_10_40
			var_10_38[iter_10_7.name] = var_10_40
			var_10_39[var_10_40] = iter_10_7.name
		end

		var_10_0.ChatCommands.commands = ui.new_multiselect("Lua", "B", "\n", var_10_37)

		ui.set(var_10_0.ChatCommands.commands, {
			var_10_38.timeout,
			var_10_38.gay
		})
		ui.set_visible(var_10_0.ChatCommands.commands, false)
		client.set_event_callback("player_chat", function(arg_198_0)
			if not ui.get(var_10_0.ChatCommands.enable) then
				return
			end

			local var_198_0 = arg_198_0.entity
			local var_198_1 = arg_198_0.name
			local var_198_2 = arg_198_0.text
			local var_198_3 = entity.get_local_player()
			local var_198_4, var_198_5 = string.match(var_198_2, "^!(%w+)[%s]?(.*)$")

			if var_198_4 ~= nil then
				local var_198_6 = {}

				for iter_198_0 in var_198_5:gmatch("%S+") do
					table.insert(var_198_6, iter_198_0)
				end

				local var_198_7 = {}

				for iter_198_1, iter_198_2 in ipairs(ui.get(var_10_0.ChatCommands.commands)) do
					var_198_7[var_10_39[iter_198_2]] = true
				end

				for iter_198_3, iter_198_4 in ipairs(var_10_34.commands) do
					if var_198_7[iter_198_4.name] then
						for iter_198_5, iter_198_6 in ipairs(iter_198_4.alias) do
							if iter_198_6 == var_198_4:lower() then
								local var_198_8 = iter_198_4.exec(var_198_0, var_198_1, var_198_6)
								local var_198_9 = 0

								if var_198_3 == var_198_0 then
									var_198_9 = 0.75
								end

								client.delay_call(var_198_9, function()
									MessageQueue:Say(var_198_8)
								end)

								break
							end
						end
					end
				end
			end
		end)
	end

	if var_0_18.get("Party Chat Utils") then
		var_10_0.PartyChatUtils = {}
		var_10_0.PartyChatUtils.enable = ui.new_checkbox("Lua", "B", "In-lobby Chat Commands")

		ui.set(var_10_0.PartyChatUtils.enable, true)

		local function var_10_41()
			if ui.get(var_10_0.PartyChatUtils.enable) then
				CPPanoramaMainMenu.PartyChatLoop()
			end

			client.delay_call(0.25, var_10_41)
		end

		var_10_41()
	end

	var_10_0.DebugOptions = {}
	var_10_0.DebugOptions.enable = ui.new_checkbox("Lua", "B", "Debug Mode (console)")

	ui.set_callback(var_10_0.DebugOptions.enable, function(arg_201_0)
		local var_201_0 = ui.get(arg_201_0)

		var_0_22.debugMode = var_201_0
	end)

	var_10_0.Footer = ui.new_label("Lua", "B", "=========  [   $CP Finish   ]  =========")

	client.set_event_callback("paint", function()
		for iter_202_0, iter_202_1 in ipairs(var_10_0.loops) do
			iter_202_1()
		end
	end)

	local var_10_42 = {
		letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' ",
		trans = {
			bold = {
				"𝗮",
				"𝗯",
				"𝗰",
				"𝗱",
				"𝗲",
				"𝗳",
				"𝗴",
				"𝗵",
				"𝗶",
				"𝗷",
				"𝗸",
				"𝗹",
				"𝗺",
				"𝗻",
				"𝗼",
				"𝗽",
				"𝗾",
				"𝗿",
				"𝘀",
				"𝘁",
				"𝘂",
				"𝘃",
				"𝘄",
				"𝘅",
				"𝘆",
				"𝘇",
				"𝗔",
				"𝗕",
				"𝗖",
				"𝗗",
				"𝗘",
				"𝗙",
				"𝗚",
				"𝗛",
				"𝗜",
				"𝗝",
				"𝗞",
				"𝗟",
				"𝗠",
				"𝗡",
				"𝗢",
				"𝗣",
				"𝗤",
				"𝗥",
				"𝗦",
				"𝗧",
				"𝗨",
				"𝗩",
				"𝗪",
				"𝗫",
				"𝗬",
				"𝗭",
				"𝟬",
				"𝟭",
				"𝟮",
				"𝟯",
				"𝟰",
				"𝟱",
				"𝟲",
				"𝟳",
				"𝟴",
				"𝟵",
				"'",
				" "
			},
			bolditalic = {
				"𝙖",
				"𝙗",
				"𝙘",
				"𝙙",
				"𝙚",
				"𝙛",
				"𝙜",
				"𝙝",
				"𝙞",
				"𝙟",
				"𝙠",
				"𝙡",
				"𝙢",
				"𝙣",
				"𝙤",
				"𝙥",
				"𝙦",
				"𝙧",
				"𝙨",
				"𝙩",
				"𝙪",
				"𝙫",
				"𝙬",
				"𝙭",
				"𝙮",
				"𝙯",
				"𝘼",
				"𝘽",
				"𝘾",
				"𝘿",
				"𝙀",
				"𝙁",
				"𝙂",
				"𝙃",
				"𝙄",
				"𝙅",
				"𝙆",
				"𝙇",
				"𝙈",
				"𝙉",
				"𝙊",
				"𝙋",
				"𝙌",
				"𝙍",
				"𝙎",
				"𝙏",
				"𝙐",
				"𝙑",
				"𝙒",
				"𝙓",
				"𝙔",
				"𝙕",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			italic = {
				"𝘢",
				"𝘣",
				"𝘤",
				"𝘥",
				"𝘦",
				"𝘧",
				"𝘨",
				"𝘩",
				"𝘪",
				"𝘫",
				"𝘬",
				"𝘭",
				"𝘮",
				"𝘯",
				"𝘰",
				"𝘱",
				"𝘲",
				"𝘳",
				"𝘴",
				"𝘵",
				"𝘶",
				"𝘷",
				"𝘸",
				"𝘹",
				"𝘺",
				"𝘻",
				"𝘈",
				"𝘉",
				"𝘊",
				"𝘋",
				"𝘌",
				"𝘍",
				"𝘎",
				"𝘏",
				"𝘐",
				"𝘑",
				"𝘒",
				"𝘓",
				"𝘔",
				"𝘕",
				"𝘖",
				"𝘗",
				"𝘘",
				"𝘙",
				"𝘚",
				"𝘛",
				"𝘜",
				"𝘝",
				"𝘞",
				"𝘟",
				"𝘠",
				"𝘡",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			circled = {
				"ⓐ",
				"ⓑ",
				"ⓒ",
				"ⓓ",
				"ⓔ",
				"ⓕ",
				"ⓖ",
				"ⓗ",
				"ⓘ",
				"ⓙ",
				"ⓚ",
				"ⓛ",
				"ⓜ",
				"ⓝ",
				"ⓞ",
				"ⓟ",
				"ⓠ",
				"ⓡ",
				"ⓢ",
				"ⓣ",
				"ⓤ",
				"ⓥ",
				"ⓦ",
				"ⓧ",
				"ⓨ",
				"ⓩ",
				"Ⓐ",
				"Ⓑ",
				"Ⓒ",
				"Ⓓ",
				"Ⓔ",
				"Ⓕ",
				"Ⓖ",
				"Ⓗ",
				"Ⓘ",
				"Ⓙ",
				"Ⓚ",
				"Ⓛ",
				"Ⓜ",
				"Ⓝ",
				"Ⓞ",
				"Ⓟ",
				"Ⓠ",
				"Ⓡ",
				"Ⓢ",
				"Ⓣ",
				"Ⓤ",
				"Ⓥ",
				"Ⓦ",
				"Ⓧ",
				"Ⓨ",
				"Ⓩ",
				"0",
				"①",
				"②",
				"③",
				"④",
				"⑤",
				"⑥",
				"⑦",
				"⑧",
				"⑨",
				"'",
				" "
			},
			circledNeg = {
				"🅐",
				"🅑",
				"🅒",
				"🅓",
				"🅔",
				"🅕",
				"🅖",
				"🅗",
				"🅘",
				"🅙",
				"🅚",
				"🅛",
				"🅜",
				"🅝",
				"🅞",
				"🅟",
				"🅠",
				"🅡",
				"🅢",
				"🅣",
				"🅤",
				"🅥",
				"🅦",
				"🅧",
				"🅨",
				"🅩",
				"🅐",
				"🅑",
				"🅒",
				"🅓",
				"🅔",
				"🅕",
				"🅖",
				"🅗",
				"🅘",
				"🅙",
				"🅚",
				"🅛",
				"🅜",
				"🅝",
				"🅞",
				"🅟",
				"🅠",
				"🅡",
				"🅢",
				"🅣",
				"🅤",
				"🅥",
				"🅦",
				"🅧",
				"🅨",
				"🅩",
				"⓿",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			fullwidth = {
				"ａ",
				"ｂ",
				"ｃ",
				"ｄ",
				"ｅ",
				"ｆ",
				"ｇ",
				"ｈ",
				"ｉ",
				"ｊ",
				"ｋ",
				"ｌ",
				"ｍ",
				"ｎ",
				"ｏ",
				"ｐ",
				"ｑ",
				"ｒ",
				"ｓ",
				"ｔ",
				"ｕ",
				"ｖ",
				"ｗ",
				"ｘ",
				"ｙ",
				"ｚ",
				"Ａ",
				"Ｂ",
				"Ｃ",
				"Ｄ",
				"Ｅ",
				"Ｆ",
				"Ｇ",
				"Ｈ",
				"Ｉ",
				"Ｊ",
				"Ｋ",
				"Ｌ",
				"Ｍ",
				"Ｎ",
				"Ｏ",
				"Ｐ",
				"Ｑ",
				"Ｒ",
				"Ｓ",
				"Ｔ",
				"Ｕ",
				"Ｖ",
				"Ｗ",
				"Ｘ",
				"Ｙ",
				"Ｚ",
				"０",
				"１",
				"２",
				"３",
				"４",
				"５",
				"６",
				"７",
				"８",
				"９",
				"＇",
				"　"
			},
			fraktur = {
				"𝔞",
				"𝔟",
				"𝔠",
				"𝔡",
				"𝔢",
				"𝔣",
				"𝔤",
				"𝔥",
				"𝔦",
				"𝔧",
				"𝔨",
				"𝔩",
				"𝔪",
				"𝔫",
				"𝔬",
				"𝔭",
				"𝔮",
				"𝔯",
				"𝔰",
				"𝔱",
				"𝔲",
				"𝔳",
				"𝔴",
				"𝔵",
				"𝔶",
				"𝔷",
				"𝔄",
				"𝔅",
				"ℭ",
				"𝔇",
				"𝔈",
				"𝔉",
				"𝔊",
				"ℌ",
				"ℑ",
				"𝔍",
				"𝔎",
				"𝔏",
				"𝔐",
				"𝔑",
				"𝔒",
				"𝔓",
				"𝔔",
				"ℜ",
				"𝔖",
				"𝔗",
				"𝔘",
				"𝔙",
				"𝔚",
				"𝔛",
				"𝔜",
				"ℨ",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			frakturbold = {
				"𝖆",
				"𝖇",
				"𝖈",
				"𝖉",
				"𝖊",
				"𝖋",
				"𝖌",
				"𝖍",
				"𝖎",
				"𝖏",
				"𝖐",
				"𝖑",
				"𝖒",
				"𝖓",
				"𝖔",
				"𝖕",
				"𝖖",
				"𝖗",
				"𝖘",
				"𝖙",
				"𝖚",
				"𝖛",
				"𝖜",
				"𝖝",
				"𝖞",
				"𝖟",
				"𝕬",
				"𝕭",
				"𝕮",
				"𝕯",
				"𝕰",
				"𝕱",
				"𝕲",
				"𝕳",
				"𝕴",
				"𝕵",
				"𝕶",
				"𝕷",
				"𝕸",
				"𝕹",
				"𝕺",
				"𝕻",
				"𝕼",
				"𝕽",
				"𝕾",
				"𝕿",
				"𝖀",
				"𝖁",
				"𝖂",
				"𝖃",
				"𝖄",
				"𝖅",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			script = {
				"𝓪",
				"𝓫",
				"𝓬",
				"𝓭",
				"𝓮",
				"𝓯",
				"𝓰",
				"𝓱",
				"𝓲",
				"𝓳",
				"𝓴",
				"𝓵",
				"𝓶",
				"𝓷",
				"𝓸",
				"𝓹",
				"𝓺",
				"𝓻",
				"𝓼",
				"𝓽",
				"𝓾",
				"𝓿",
				"𝔀",
				"𝔁",
				"𝔂",
				"𝔃",
				"𝓐",
				"𝓑",
				"𝓒",
				"𝓓",
				"𝓔",
				"𝓕",
				"𝓖",
				"𝓗",
				"𝓘",
				"𝓙",
				"𝓚",
				"𝓛",
				"𝓜",
				"𝓝",
				"𝓞",
				"𝓟",
				"𝓠",
				"𝓡",
				"𝓢",
				"𝓣",
				"𝓤",
				"𝓥",
				"𝓦",
				"𝓧",
				"𝓨",
				"𝓩",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			doublestruck = {
				"𝕒",
				"𝕓",
				"𝕔",
				"𝕕",
				"𝕖",
				"𝕗",
				"𝕘",
				"𝕙",
				"𝕚",
				"𝕛",
				"𝕜",
				"𝕝",
				"𝕞",
				"𝕟",
				"𝕠",
				"𝕡",
				"𝕢",
				"𝕣",
				"𝕤",
				"𝕥",
				"𝕦",
				"𝕧",
				"𝕨",
				"𝕩",
				"𝕪",
				"𝕫",
				"𝔸",
				"𝔹",
				"ℂ",
				"𝔻",
				"𝔼",
				"𝔽",
				"𝔾",
				"ℍ",
				"𝕀",
				"𝕁",
				"𝕂",
				"𝕃",
				"𝕄",
				"ℕ",
				"𝕆",
				"ℙ",
				"ℚ",
				"ℝ",
				"𝕊",
				"𝕋",
				"𝕌",
				"𝕍",
				"𝕎",
				"𝕏",
				"𝕐",
				"ℤ",
				"𝟘",
				"𝟙",
				"𝟚",
				"𝟛",
				"𝟜",
				"𝟝",
				"𝟞",
				"𝟟",
				"𝟠",
				"𝟡",
				"'",
				" "
			},
			monospace = {
				"𝚊",
				"𝚋",
				"𝚌",
				"𝚍",
				"𝚎",
				"𝚏",
				"𝚐",
				"𝚑",
				"𝚒",
				"𝚓",
				"𝚔",
				"𝚕",
				"𝚖",
				"𝚗",
				"𝚘",
				"𝚙",
				"𝚚",
				"𝚛",
				"𝚜",
				"𝚝",
				"𝚞",
				"𝚟",
				"𝚠",
				"𝚡",
				"𝚢",
				"𝚣",
				"𝙰",
				"𝙱",
				"𝙲",
				"𝙳",
				"𝙴",
				"𝙵",
				"𝙶",
				"𝙷",
				"𝙸",
				"𝙹",
				"𝙺",
				"𝙻",
				"𝙼",
				"𝙽",
				"𝙾",
				"𝙿",
				"𝚀",
				"𝚁",
				"𝚂",
				"𝚃",
				"𝚄",
				"𝚅",
				"𝚆",
				"𝚇",
				"𝚈",
				"𝚉",
				"𝟶",
				"𝟷",
				"𝟸",
				"𝟹",
				"𝟺",
				"𝟻",
				"𝟼",
				"𝟽",
				"𝟾",
				"𝟿",
				"'",
				" "
			},
			parenthesized = {
				"⒜",
				"⒝",
				"⒞",
				"⒟",
				"⒠",
				"⒡",
				"⒢",
				"⒣",
				"⒤",
				"⒥",
				"⒦",
				"⒧",
				"⒨",
				"⒩",
				"⒪",
				"⒫",
				"⒬",
				"⒭",
				"⒮",
				"⒯",
				"⒰",
				"⒱",
				"⒲",
				"⒳",
				"⒴",
				"⒵",
				"⒜",
				"⒝",
				"⒞",
				"⒟",
				"⒠",
				"⒡",
				"⒢",
				"⒣",
				"⒤",
				"⒥",
				"⒦",
				"⒧",
				"⒨",
				"⒩",
				"⒪",
				"⒫",
				"⒬",
				"⒭",
				"⒮",
				"⒯",
				"⒰",
				"⒱",
				"⒲",
				"⒳",
				"⒴",
				"⒵",
				"0",
				"⑴",
				"⑵",
				"⑶",
				"⑷",
				"⑸",
				"⑹",
				"⑺",
				"⑻",
				"⑼",
				"'",
				" "
			},
			regional = {
				"🇦",
				"🇧",
				"🇨",
				"🇩",
				"🇪",
				"🇫",
				"🇬",
				"🇭",
				"🇮",
				"🇯",
				"🇰",
				"🇱",
				"🇲",
				"🇳",
				"🇴",
				"🇵",
				"🇶",
				"🇷",
				"🇸",
				"🇹",
				"🇺",
				"🇻",
				"🇼",
				"🇽",
				"🇾",
				"🇿",
				"🇦",
				"🇧",
				"🇨",
				"🇩",
				"🇪",
				"🇫",
				"🇬",
				"🇭",
				"🇮",
				"🇯",
				"🇰",
				"🇱",
				"🇲",
				"🇳",
				"🇴",
				"🇵",
				"🇶",
				"🇷",
				"🇸",
				"🇹",
				"🇺",
				"🇻",
				"🇼",
				"🇽",
				"🇾",
				"🇿",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			squared = {
				"🄰",
				"🄱",
				"🄲",
				"🄳",
				"🄴",
				"🄵",
				"🄶",
				"🄷",
				"🄸",
				"🄹",
				"🄺",
				"🄻",
				"🄼",
				"🄽",
				"🄾",
				"🄿",
				"🅀",
				"🅁",
				"🅂",
				"🅃",
				"🅄",
				"🅅",
				"🅆",
				"🅇",
				"🅈",
				"🅉",
				"🄰",
				"🄱",
				"🄲",
				"🄳",
				"🄴",
				"🄵",
				"🄶",
				"🄷",
				"🄸",
				"🄹",
				"🄺",
				"🄻",
				"🄼",
				"🄽",
				"🄾",
				"🄿",
				"🅀",
				"🅁",
				"🅂",
				"🅃",
				"🅄",
				"🅅",
				"🅆",
				"🅇",
				"🅈",
				"🅉",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			squaredNeg = {
				"🅰",
				"🅱",
				"🅲",
				"🅳",
				"🅴",
				"🅵",
				"🅶",
				"🅷",
				"🅸",
				"🅹",
				"🅺",
				"🅻",
				"🅼",
				"🅽",
				"🅾",
				"🅿",
				"🆀",
				"🆁",
				"🆂",
				"🆃",
				"🆄",
				"🆅",
				"🆆",
				"🆇",
				"🆈",
				"🆉",
				"🅰",
				"🅱",
				"🅲",
				"🅳",
				"🅴",
				"🅵",
				"🅶",
				"🅷",
				"🅸",
				"🅹",
				"🅺",
				"🅻",
				"🅼",
				"🅽",
				"🅾",
				"🅿",
				"🆀",
				"🆁",
				"🆂",
				"🆃",
				"🆄",
				"🆅",
				"🆆",
				"🆇",
				"🆈",
				"🆉",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			acute = {
				"á",
				"b",
				"ć",
				"d",
				"é",
				"f",
				"ǵ",
				"h",
				"í",
				"j",
				"ḱ",
				"ĺ",
				"ḿ",
				"ń",
				"ő",
				"ṕ",
				"q",
				"ŕ",
				"ś",
				"t",
				"ú",
				"v",
				"ẃ",
				"x",
				"ӳ",
				"ź",
				"Á",
				"B",
				"Ć",
				"D",
				"É",
				"F",
				"Ǵ",
				"H",
				"í",
				"J",
				"Ḱ",
				"Ĺ",
				"Ḿ",
				"Ń",
				"Ő",
				"Ṕ",
				"Q",
				"Ŕ",
				"ś",
				"T",
				"Ű",
				"V",
				"Ẃ",
				"X",
				"Ӳ",
				"Ź",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			thai = {
				"ﾑ",
				"乃",
				"c",
				"d",
				"乇",
				"ｷ",
				"g",
				"ん",
				"ﾉ",
				"ﾌ",
				"ズ",
				"ﾚ",
				"ﾶ",
				"刀",
				"o",
				"ｱ",
				"q",
				"尺",
				"丂",
				"ｲ",
				"u",
				"√",
				"w",
				"ﾒ",
				"ﾘ",
				"乙",
				"ﾑ",
				"乃",
				"c",
				"d",
				"乇",
				"ｷ",
				"g",
				"ん",
				"ﾉ",
				"ﾌ",
				"ズ",
				"ﾚ",
				"ﾶ",
				"刀",
				"o",
				"ｱ",
				"q",
				"尺",
				"丂",
				"ｲ",
				"u",
				"√",
				"w",
				"ﾒ",
				"ﾘ",
				"乙",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			curvy1 = {
				"ค",
				"๒",
				"ƈ",
				"ɗ",
				"ﻉ",
				"ि",
				"ﻭ",
				"ɦ",
				"ٱ",
				"ﻝ",
				"ᛕ",
				"ɭ",
				"๓",
				"ก",
				"ѻ",
				"ρ",
				"۹",
				"ɼ",
				"ร",
				"Շ",
				"પ",
				"۷",
				"ฝ",
				"ซ",
				"ץ",
				"չ",
				"ค",
				"๒",
				"ƈ",
				"ɗ",
				"ﻉ",
				"ि",
				"ﻭ",
				"ɦ",
				"ٱ",
				"ﻝ",
				"ᛕ",
				"ɭ",
				"๓",
				"ก",
				"ѻ",
				"ρ",
				"۹",
				"ɼ",
				"ร",
				"Շ",
				"પ",
				"۷",
				"ฝ",
				"ซ",
				"ץ",
				"չ",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			curvy2 = {
				"α",
				"в",
				"¢",
				"∂",
				"є",
				"ƒ",
				"ﻭ",
				"н",
				"ι",
				"נ",
				"к",
				"ℓ",
				"м",
				"η",
				"σ",
				"ρ",
				"۹",
				"я",
				"ѕ",
				"т",
				"υ",
				"ν",
				"ω",
				"χ",
				"у",
				"չ",
				"α",
				"в",
				"¢",
				"∂",
				"є",
				"ƒ",
				"ﻭ",
				"н",
				"ι",
				"נ",
				"к",
				"ℓ",
				"м",
				"η",
				"σ",
				"ρ",
				"۹",
				"я",
				"ѕ",
				"т",
				"υ",
				"ν",
				"ω",
				"χ",
				"у",
				"չ",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			curvy3 = {
				"ค",
				"๒",
				"ς",
				"๔",
				"є",
				"Ŧ",
				"ﻮ",
				"ђ",
				"เ",
				"ן",
				"к",
				"ɭ",
				"๓",
				"ภ",
				"๏",
				"ק",
				"ợ",
				"г",
				"ร",
				"Շ",
				"ย",
				"ש",
				"ฬ",
				"א",
				"ץ",
				"չ",
				"ค",
				"๒",
				"ς",
				"๔",
				"є",
				"Ŧ",
				"ﻮ",
				"ђ",
				"เ",
				"ן",
				"к",
				"ɭ",
				"๓",
				"ภ",
				"๏",
				"ק",
				"ợ",
				"г",
				"ร",
				"Շ",
				"ย",
				"ש",
				"ฬ",
				"א",
				"ץ",
				"չ",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			fauxcryllic = {
				"а",
				"ъ",
				"с",
				"ↁ",
				"э",
				"f",
				"Б",
				"Ђ",
				"і",
				"ј",
				"к",
				"l",
				"м",
				"и",
				"о",
				"р",
				"q",
				"ѓ",
				"ѕ",
				"т",
				"ц",
				"v",
				"ш",
				"х",
				"Ў",
				"z",
				"Д",
				"Б",
				"Ҁ",
				"ↁ",
				"Є",
				"F",
				"Б",
				"Н",
				"І",
				"Ј",
				"Ќ",
				"L",
				"М",
				"И",
				"Ф",
				"Р",
				"Q",
				"Я",
				"Ѕ",
				"Г",
				"Ц",
				"V",
				"Щ",
				"Ж",
				"Ч",
				"Z",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			rockdots = {
				"ä",
				"ḅ",
				"ċ",
				"ḋ",
				"ë",
				"ḟ",
				"ġ",
				"ḧ",
				"ï",
				"j",
				"ḳ",
				"ḷ",
				"ṁ",
				"ṅ",
				"ö",
				"ṗ",
				"q",
				"ṛ",
				"ṡ",
				"ẗ",
				"ü",
				"ṿ",
				"ẅ",
				"ẍ",
				"ÿ",
				"ż",
				"Ä",
				"Ḅ",
				"Ċ",
				"Ḋ",
				"Ё",
				"Ḟ",
				"Ġ",
				"Ḧ",
				"Ї",
				"J",
				"Ḳ",
				"Ḷ",
				"Ṁ",
				"Ṅ",
				"Ö",
				"Ṗ",
				"Q",
				"Ṛ",
				"Ṡ",
				"Ṫ",
				"Ü",
				"Ṿ",
				"Ẅ",
				"Ẍ",
				"Ÿ",
				"Ż",
				"0",
				"1",
				"2",
				"ӟ",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			smallcaps = {
				"ᴀ",
				"ʙ",
				"ᴄ",
				"ᴅ",
				"ᴇ",
				"ꜰ",
				"ɢ",
				"ʜ",
				"ɪ",
				"ᴊ",
				"ᴋ",
				"ʟ",
				"ᴍ",
				"ɴ",
				"ᴏ",
				"ᴩ",
				"q",
				"ʀ",
				"ꜱ",
				"ᴛ",
				"ᴜ",
				"ᴠ",
				"ᴡ",
				"x",
				"y",
				"ᴢ",
				"ᴀ",
				"ʙ",
				"ᴄ",
				"ᴅ",
				"ᴇ",
				"ꜰ",
				"ɢ",
				"ʜ",
				"ɪ",
				"ᴊ",
				"ᴋ",
				"ʟ",
				"ᴍ",
				"ɴ",
				"ᴏ",
				"ᴩ",
				"Q",
				"ʀ",
				"ꜱ",
				"ᴛ",
				"ᴜ",
				"ᴠ",
				"ᴡ",
				"x",
				"Y",
				"ᴢ",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			stroked = {
				"Ⱥ",
				"ƀ",
				"ȼ",
				"đ",
				"ɇ",
				"f",
				"ǥ",
				"ħ",
				"ɨ",
				"ɉ",
				"ꝁ",
				"ł",
				"m",
				"n",
				"ø",
				"ᵽ",
				"ꝗ",
				"ɍ",
				"s",
				"ŧ",
				"ᵾ",
				"v",
				"w",
				"x",
				"ɏ",
				"ƶ",
				"Ⱥ",
				"Ƀ",
				"Ȼ",
				"Đ",
				"Ɇ",
				"F",
				"Ǥ",
				"Ħ",
				"Ɨ",
				"Ɉ",
				"Ꝁ",
				"Ł",
				"M",
				"N",
				"Ø",
				"Ᵽ",
				"Ꝗ",
				"Ɍ",
				"S",
				"Ŧ",
				"ᵾ",
				"V",
				"W",
				"X",
				"Ɏ",
				"Ƶ",
				"0",
				"1",
				"ƻ",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				"'",
				" "
			},
			subscript = {
				"ₐ",
				"b",
				"c",
				"d",
				"ₑ",
				"f",
				"g",
				"ₕ",
				"ᵢ",
				"ⱼ",
				"ₖ",
				"ₗ",
				"ₘ",
				"ₙ",
				"ₒ",
				"ₚ",
				"q",
				"ᵣ",
				"ₛ",
				"ₜ",
				"ᵤ",
				"ᵥ",
				"w",
				"ₓ",
				"y",
				"z",
				"ₐ",
				"B",
				"C",
				"D",
				"ₑ",
				"F",
				"G",
				"ₕ",
				"ᵢ",
				"ⱼ",
				"ₖ",
				"ₗ",
				"ₘ",
				"ₙ",
				"ₒ",
				"ₚ",
				"Q",
				"ᵣ",
				"ₛ",
				"ₜ",
				"ᵤ",
				"ᵥ",
				"W",
				"ₓ",
				"Y",
				"Z",
				"₀",
				"₁",
				"₂",
				"₃",
				"₄",
				"₅",
				"₆",
				"₇",
				"₈",
				"₉",
				"'",
				" "
			},
			superscript = {
				"ᵃ",
				"ᵇ",
				"ᶜ",
				"ᵈ",
				"ᵉ",
				"ᶠ",
				"ᵍ",
				"ʰ",
				"ⁱ",
				"ʲ",
				"ᵏ",
				"ˡ",
				"ᵐ",
				"ⁿ",
				"ᵒ",
				"ᵖ",
				"q",
				"ʳ",
				"ˢ",
				"ᵗ",
				"ᵘ",
				"ᵛ",
				"ʷ",
				"ˣ",
				"ʸ",
				"ᶻ",
				"ᴬ",
				"ᴮ",
				"ᶜ",
				"ᴰ",
				"ᴱ",
				"ᶠ",
				"ᴳ",
				"ᴴ",
				"ᴵ",
				"ᴶ",
				"ᴷ",
				"ᴸ",
				"ᴹ",
				"ᴺ",
				"ᴼ",
				"ᴾ",
				"Q",
				"ᴿ",
				"ˢ",
				"ᵀ",
				"ᵁ",
				"ⱽ",
				"ᵂ",
				"ˣ",
				"ʸ",
				"ᶻ",
				"⁰",
				"¹",
				"²",
				"³",
				"⁴",
				"⁵",
				"⁶",
				"⁷",
				"⁸",
				"⁹",
				"'",
				" "
			},
			inverted = {
				"ɐ",
				"q",
				"ɔ",
				"p",
				"ǝ",
				"ɟ",
				"ƃ",
				"ɥ",
				"ı",
				"ɾ",
				"ʞ",
				"ן",
				"ɯ",
				"u",
				"o",
				"d",
				"b",
				"ɹ",
				"s",
				"ʇ",
				"n",
				"ʌ",
				"ʍ",
				"x",
				"ʎ",
				"z",
				"ɐ",
				"q",
				"ɔ",
				"p",
				"ǝ",
				"ɟ",
				"ƃ",
				"ɥ",
				"ı",
				"ɾ",
				"ʞ",
				"ן",
				"ɯ",
				"u",
				"o",
				"d",
				"b",
				"ɹ",
				"s",
				"ʇ",
				"n",
				"𐌡",
				"ʍ",
				"x",
				"ʎ",
				"z",
				"0",
				"1",
				"2",
				"3",
				"4",
				"5",
				"6",
				"7",
				"8",
				"9",
				",",
				" "
			}
		}
	}

	function transText(arg_203_0, arg_203_1)
		if not var_10_42.trans[arg_203_0] then
			return arg_203_1
		end

		local var_203_0 = ""

		for iter_203_0 = 1, #arg_203_1 do
			local var_203_1 = arg_203_1:sub(iter_203_0, iter_203_0)

			var_203_0 = var_203_0 .. (var_10_42.trans[arg_203_0][var_10_42.letters:find(var_203_1)] or var_203_1)
		end

		return var_203_0
	end

	function changeCaseWord(arg_204_0)
		local var_204_0 = ""

		for iter_204_0 = 1, #arg_204_0 do
			if iter_204_0 % 2 == 1 then
				var_204_0 = var_204_0 .. string.upper(arg_204_0:sub(iter_204_0, iter_204_0))
			else
				var_204_0 = var_204_0 .. string.lower(arg_204_0:sub(iter_204_0, iter_204_0))
			end
		end

		return var_204_0
	end

	function changeCase(arg_205_0)
		local var_205_0 = {}

		for iter_205_0 in arg_205_0:gmatch(".+") do
			var_205_0[#var_205_0 + 1] = iter_205_0
		end

		for iter_205_1, iter_205_2 in ipairs(var_205_0) do
			var_205_0[iter_205_1] = changeCaseWord(iter_205_2)
		end

		return table.concat(var_205_0, " ")
	end

	if var_0_18.get("Playerlist Additions") then
		local var_10_43 = ui.reference("Players", "Players", "Player list")
		local var_10_44 = ui.reference("Players", "Players", "Reset all")
		local var_10_45 = ui.reference("Players", "Adjustments", "Apply to all")

		var_0_21.binds = {}
		var_0_21.defaultValues = {}
		var_0_21.cache = {}

		function var_0_21.getPlayer()
			return ui.get(var_10_43)
		end

		function var_0_21.bind(arg_207_0, arg_207_1)
			var_0_21.binds[#var_0_21.binds + 1] = arg_207_0
			var_0_21.defaultValues[arg_207_0] = ui.get(arg_207_0)

			ui.set_callback(arg_207_0, function(arg_208_0)
				if arg_207_1 then
					arg_207_1(arg_208_0)
				end

				local var_208_0 = var_0_21.getPlayer()

				printDebug("callbacks, ", var_208_0)

				if var_208_0 then
					var_0_21.cache[var_208_0] = var_0_21.cache[var_208_0] or {}
					var_0_21.cache[var_208_0][arg_208_0] = ui.get(arg_208_0)

					printDebug(var_208_0, " = ", arg_208_0, ", ", ui.get(arg_208_0))
				end
			end)
		end

		ui.set_callback(var_10_43, function(arg_209_0)
			local var_209_0 = ui.get(arg_209_0)

			if var_209_0 then
				var_0_21.cache[var_209_0] = var_0_21.cache[var_209_0] or {}

				for iter_209_0, iter_209_1 in ipairs(var_0_21.binds) do
					local var_209_1 = var_0_21.cache[var_209_0][iter_209_1]

					printDebug(iter_209_1, var_209_1)

					if var_209_1 == nil then
						var_209_1 = var_0_21.defaultValues[iter_209_1]
					end

					if var_209_1 ~= nil then
						ui.set(iter_209_1, var_209_1)
					end
				end
			end
		end)
		ui.set_callback(var_10_44, function(arg_210_0)
			for iter_210_0, iter_210_1 in pairs(var_0_21.cache) do
				for iter_210_2, iter_210_3 in pairs(iter_210_1) do
					ui.set(iter_210_2, var_0_21.defaultValues[iter_210_2])
				end
			end

			var_0_21.cache = {}
		end)
		ui.set_callback(var_10_45, function(arg_211_0)
			local var_211_0 = var_0_21.getPlayer()

			if var_211_0 then
				var_0_21.cache[var_211_0] = var_0_21.cache[var_211_0] or {}

				for iter_211_0 = 1, globals.maxplayers() do
					if entity.is_enemy(iter_211_0) then
						for iter_211_1, iter_211_2 in ipairs(var_0_21.binds) do
							var_0_21.cache[iter_211_0] = var_0_21.cache[iter_211_0] or {}
							var_0_21.cache[iter_211_0][iter_211_2] = ui.get(iter_211_2)
						end
					end
				end
			end
		end)
		ui.new_label("Players", "Adjustments", "=---------  [ START $CP Additions  ]  ---------=")

		local var_10_46 = {
			repeatMessages = ui.new_checkbox("Players", "Adjustments", "Repeat Messages")
		}

		var_0_21.bind(var_10_46.repeatMessages, function(arg_212_0)
			local var_212_0 = ui.get(arg_212_0)
			local var_212_1 = var_0_21.getPlayer()

			ui.set_visible(var_10_46.repeatMethod, ui.get(arg_212_0))
			ui.set_visible(var_10_46.testOutput, ui.get(arg_212_0))
		end)

		local var_10_47 = {
			"Shift Case"
		}

		for iter_10_8, iter_10_9 in pairs(var_10_42.trans) do
			var_10_47[#var_10_47 + 1] = iter_10_8
		end

		var_10_46.repeatMethod = ui.new_combobox("Players", "Adjustments", "Repeat Method", var_10_47)
		var_10_46.testOutput = ui.new_button("Players", "Adjustments", "Print Example", function()
			local var_213_0 = ui.get(var_10_46.repeatMethod)
			local var_213_1 = "She Sells Seashells on the Seashore"

			if var_213_0 == "Shift Case" then
				var_213_1 = changeCase(var_213_1)
			else
				var_213_1 = transText(var_213_0, var_213_1)
			end

			var_10_0.ChatMethods["Local Chat"](" \a[Message Repeater] \n" .. var_213_1)
		end)

		ui.set_visible(var_10_46.repeatMethod, false)
		ui.set_visible(var_10_46.testOutput, false)
		var_0_21.bind(var_10_46.repeatMethod)
		client.set_event_callback("player_chat", function(arg_214_0)
			if not arg_214_0.teamonly then
				local var_214_0 = arg_214_0.entity
				local var_214_1 = arg_214_0.name
				local var_214_2 = arg_214_0.text

				var_0_21.cache[var_214_0] = var_0_21.cache[var_214_0] or {}

				if entity.is_enemy(var_214_0) and var_0_21.cache[var_214_0] ~= nil and var_0_21.cache[var_214_0][var_10_46.repeatMessages] and var_0_21.cache[var_214_0][var_10_46.repeatMethod] then
					local var_214_3 = var_0_21.cache[var_214_0][var_10_46.repeatMethod]
					local var_214_4 = var_214_2

					if var_214_3 == "Shift Case" then
						var_214_4 = changeCase(var_214_2)
					else
						var_214_4 = transText(var_214_3, var_214_2)
					end

					MessageQueue:Say(var_214_4, true)
				end
			end
		end)

		if var_0_18.get("Highlight Targets") then
			local var_10_48 = ui.new_checkbox("Players", "Adjustments", "Hightlight Player")

			var_0_21.bind(var_10_48)

			local var_10_49 = {}

			client.set_event_callback("run_command", function(arg_215_0)
				var_10_49 = {}

				for iter_215_0, iter_215_1 in ipairs(entity.get_players(true)) do
					var_0_21.cache[iter_215_1] = var_0_21.cache[iter_215_1] or {}

					if var_0_21.cache[iter_215_1][var_10_48] then
						table.insert(var_10_49, iter_215_1)
						entity.set_prop(iter_215_1, "m_flDetectedByEnemySensorTime", 1000000)
					else
						entity.set_prop(iter_215_1, "m_flDetectedByEnemySensorTime", 0)
					end
				end
			end)
			client.set_event_callback("paint", function()
				for iter_216_0, iter_216_1 in pairs(var_10_49) do
					local var_216_0 = {
						entity.get_bounding_box(iter_216_1)
					}

					if #var_216_0 == 5 and var_216_0[5] ~= 0 then
						local var_216_1 = var_216_0[1] + (var_216_0[3] - var_216_0[1]) / 2

						renderer.text(var_216_1, var_216_0[2] - 18, 255, 255, 0, 255 * var_216_0[5], "c", 0, "WARNING!")
					end
				end
			end)
		end

		if var_0_18.get("Whitelist Friends on Key") then
			var_0_21.MarkAsLegit = ui.new_checkbox("Players", "Adjustments", "Mark as Legit")

			var_0_21.bind(var_0_21.MarkAsLegit)
			client.set_event_callback("paint", function()
				local var_217_0, var_217_1 = ui.get(var_10_0.WhitelistLegitsOnKey.hotkey)

				if ui.get(var_10_0.WhitelistLegitsOnKey.enable) and var_217_0 then
					renderer.indicator(255, 255, 255, 255, "WHITELISTED LEGITS")
				end
			end)
		end

		ui.new_label("Players", "Adjustments", "=---------  [  END $CP Additions  ]  ---------=")
		client.set_event_callback("cs_win_panel_match", function(arg_218_0)
			var_0_21.cache = {}
		end)
		var_0_4.register_event("ShowAcceptPopup", function(arg_219_0)
			var_0_21.cache = {}
		end)
	end
end

Timer = {
	q = {}
}

function Timer.set(arg_220_0, arg_220_1)
	local var_220_0 = #Timer.q + 1
	local var_220_1 = {
		expiry = globals.realtime() + arg_220_0,
		callback = arg_220_1,
		duration = arg_220_0
	}

	var_220_1.active = true

	function var_220_1.update(arg_221_0, arg_221_1)
		arg_221_0.expiry = globals.realtime() + arg_221_1
	end

	function var_220_1.increase(arg_222_0, arg_222_1)
		arg_222_0.expiry = arg_222_0.expiry + arg_222_1
	end

	function var_220_1.decrease(arg_223_0, arg_223_1)
		arg_223_0.expiry = arg_223_0.expiry - arg_223_1
	end

	function var_220_1.reset(arg_224_0)
		arg_224_0.expiry = globals.realtime() + arg_224_0.duration
	end

	function var_220_1.delete(arg_225_0)
		if not arg_225_0.active then
			return
		end

		arg_225_0.active = false

		table.remove(Timer.q, var_220_0)
	end

	function var_220_1.remaining(arg_226_0)
		return arg_226_0.active and arg_226_0.expiry - globals.realtime() or 0
	end

	Timer.q[var_220_0] = var_220_1

	return var_220_1
end

client.set_event_callback("post_render", function()
	for iter_227_0 = 1, #Timer.q do
		local var_227_0 = Timer.q[iter_227_0]

		if globals.realtime() >= var_227_0.expiry then
			var_227_0.active = false

			var_227_0.callback()
			table.remove(Timer.q, iter_227_0)

			break
		end
	end
end)

MessageQueue = {}
MessageQueue.pending = {}

function MessageQueue.Say(arg_228_0, arg_228_1, arg_228_2)
	if arg_228_1 then
		local var_228_0 = arg_228_1:gsub("\"", ""):gsub(";", "")
		local var_228_1 = {
			"say \"",
			var_228_0,
			"\";"
		}

		table.insert(arg_228_0.pending, Priority and 1 or var_228_1)
	end
end

function MessageQueue.SayTeam(arg_229_0, arg_229_1, arg_229_2)
	if arg_229_1 then
		local var_229_0 = arg_229_1:gsub("\"", ""):gsub(";", "")
		local var_229_1 = {
			"say_team \"",
			var_229_0,
			"\";"
		}

		table.insert(arg_229_0.pending, Priority and 1 or var_229_1)
	end
end

local var_0_23 = globals.realtime()

client.set_event_callback("post_render", function()
	if globals.realtime() - var_0_23 > 0.725 + client.latency() then
		local var_230_0 = MessageQueue.pending[1]

		if var_230_0 then
			client.exec(unpack(var_230_0))
			table.remove(MessageQueue.pending, 1)

			var_0_23 = globals.realtime()
		end
	end
end)

local var_0_24 = {
	"5DA40A4A4699DEE30C1C9A7BCE84C914",
	"5970533AA2A0651E9105E706D0F8EDDC",
	"2B3382EBA9E8C1B58054BD5C5EE1C36A"
}
local var_0_25 = 0

function RandomWebKey()
	var_0_25 = var_0_25 < #var_0_24 and var_0_25 + 1 or 1

	return var_0_24[var_0_25]
end

function processTags(arg_232_0, arg_232_1)
	if not arg_232_1 then
		arg_232_1 = arg_232_0
		arg_232_0 = arg_232_1[1]
	end

	local var_232_0 = arg_232_0
	local var_232_1 = string.gsub(var_232_0, "({([^}]+)})", function(arg_233_0, arg_233_1, arg_233_2, arg_233_3)
		return arg_232_1[arg_233_1:lower()] or arg_233_0
	end)

	return (string.gsub(var_232_1, "({([^}]+):(%w*)})", function(arg_234_0, arg_234_1, arg_234_2, arg_234_3)
		local var_234_0 = arg_232_1[arg_234_1:lower()]

		if var_234_0 and type(arg_234_2) == "string" and arg_234_2:len() > 0 then
			local var_234_1 = arg_234_2:lower()

			if var_234_1:find("i") then
				var_234_0 = var_234_0:lower()
			end

			if var_234_1:find("u") then
				var_234_0 = var_234_0:upper()
			end

			if var_234_1:find("s") then
				var_234_0 = var_234_0:gsub("%s+", "")
			end

			if var_234_1:find("h") then
				var_234_0 = var_234_0:gsub("[-]+", "")
			end

			if var_234_1:find("n") then
				var_234_0 = var_234_0:gsub("%d+", "")
			end

			if var_234_1:find("%d") then
				local var_234_2 = tonumber(string.match(var_234_1, "%d"))
				local var_234_3 = {}

				for iter_234_0 in var_234_0:gmatch("%w+") do
					table.insert(var_234_3, iter_234_0)
				end

				if var_234_2 <= #var_234_3 then
					var_234_0 = var_234_3[var_234_2]
				end
			end
		end

		return var_234_0 or arg_234_0
	end))
end

function printDebug(...)
	if not var_0_22.debugMode then
		return
	end
end

function esc(arg_236_0)
	return (arg_236_0:gsub("%%", "%%%%"):gsub("^%^", "%%^"):gsub("%$$", "%%$"):gsub("%(", "%%("):gsub("%)", "%%)"):gsub("%.", "%%."):gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%*", "%%*"):gsub("%+", "%%+"):gsub("%-", "%%-"):gsub("%?", "%%?"))
end

function getRankShortName(arg_237_0)
	if not arg_237_0 then
		return false
	end

	local var_237_0 = {
		"III",
		"II",
		"I"
	}
	local var_237_1 = arg_237_0:gsub("The ", " "):gsub("%l", "")

	for iter_237_0 = 1, #var_237_0 do
		if var_237_1:find(var_237_0[iter_237_0]) then
			var_237_1 = var_237_1:gsub(var_237_0[iter_237_0], #var_237_0 + 1 - iter_237_0)
		end

		var_237_1 = var_237_1:gsub(" ", "")
	end

	return var_237_1
end

local function var_0_26(arg_238_0)
	return string.format("%%%02X", string.byte(arg_238_0))
end

function urlencode(arg_239_0)
	if arg_239_0 == nil then
		return
	end

	arg_239_0 = arg_239_0:gsub("\n", "\r\n")
	arg_239_0 = arg_239_0:gsub("([^%w ])", var_0_26)
	arg_239_0 = arg_239_0:gsub(" ", "+")

	return arg_239_0
end

local function var_0_27(arg_240_0)
	return string.char(tonumber(arg_240_0, 16))
end

function urldecode(arg_241_0)
	if arg_241_0 == nil then
		return
	end

	arg_241_0 = arg_241_0:gsub("+", " ")
	arg_241_0 = arg_241_0:gsub("%%(%x%x)", var_0_27)

	return arg_241_0
end

var_0_0.cdef("  typedef struct\n  {\n    int64_t pad_0;\n    union {\n      int xuid;\n      struct {\n        int xuidlow;\n        int xuidhigh;\n      };\n    };\n    char name[128];\n    int userid;\n    char guid[33];\n    unsigned int friendsid;\n    char friendsname[128];\n    bool fakeplayer;\n    bool ishltv;\n    unsigned int customfiles[4];\n    unsigned char filesdownloaded;\n  } S_playerInfo_t;\n\n  typedef bool(__thiscall* fnGetPlayerInfo)(void*, int, S_playerInfo_t*);\n")

local var_0_28 = var_0_0.cast(var_0_0.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))
local var_0_29 = var_0_0.cast("fnGetPlayerInfo", var_0_28[0][8])

function getPlayerInfo(arg_242_0)
	local var_242_0 = var_0_0.new("S_playerInfo_t[1]")

	var_0_29(var_0_28, arg_242_0, var_242_0)

	return var_242_0[0]
end

if var_0_18.get("Raw Chat Print") then
	var_0_0.cdef("\t\ttypedef void***(__thiscall* FindHudElement_t)(void*, const char*);\n\t\ttypedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);\n\t")

	local var_0_30 = "\xB9\xCC\xCC\xCC̈F\t"
	local var_0_31 = "U\x8B\xECS\x8B]\bVW\x8B\xF93\xF69w("
	local var_0_32 = client.find_signature("client_panorama.dll", var_0_30) or error("sig1 not found")
	local var_0_33 = var_0_0.cast("char*", var_0_32) + 1
	local var_0_34 = var_0_0.cast("void**", var_0_33)[0] or error("hud is nil")
	local var_0_35 = client.find_signature("client_panorama.dll", var_0_31) or error("FindHudElement not found")
	local var_0_36 = var_0_0.cast("FindHudElement_t", var_0_35)(var_0_34, "CHudChat") or error("CHudChat not found")
	local var_0_37 = (var_0_36[0] or error("CHudChat instance vtable is nil"))[27]
	local var_0_38 = var_0_0.cast("ChatPrintf_t", var_0_37)

	function cp_SendChat(arg_243_0)
		var_0_38(var_0_36, 0, 0, arg_243_0)
	end

	local var_0_39 = {}
	local var_0_40 = 0
	local var_0_41 = 0

	function AccumulateFps()
		local var_244_0 = globals.absoluteframetime()

		if var_244_0 > 0 then
			table.insert(var_0_39, 1, var_244_0)
		end

		local var_244_1 = #var_0_39

		if var_244_1 == 0 then
			return 0
		end

		local var_244_2 = 0
		local var_244_3 = 0

		while var_244_3 < 0.5 do
			var_244_2 = var_244_2 + 1
			var_244_3 = var_244_3 + var_0_39[var_244_2]

			if var_244_1 <= var_244_2 then
				break
			end
		end

		local var_244_4 = var_244_3 / var_244_2

		while var_244_2 < var_244_1 do
			var_244_2 = var_244_2 + 1

			table.remove(var_0_39)
		end

		local var_244_5 = 1 / var_244_4
		local var_244_6 = globals.realtime()

		if math.abs(var_244_5 - var_0_40) > 4 or var_244_6 - var_0_41 > 2 then
			var_0_40 = var_244_5
			var_0_41 = var_244_6
		else
			var_244_5 = var_0_40
		end

		return math.ceil(var_244_5 + 0.5)
	end
end

if var_0_18.get("User Data Saving") then
	local var_0_42 = database.read("cplua_userdata") or {}
	local var_0_43, var_0_44 = pcall(json.stringify, var_0_42)

	CPPanoramaMainMenu.SetUserData(var_0_43 and var_0_44 or {})
	client.set_event_callback("shutdown", function()
		local var_245_0, var_245_1 = pcall(json.parse, CPPanoramaMainMenu.GetUserData())

		database.write("cplua_userdata", parseSuccess_ and var_245_1 or {})
	end)
end

Initiate()
