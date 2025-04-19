--[[
                           _   _     __    ___    _____                             __  
                          (_) | |   /_ |  / _ \  | ____|                           / /
   ___   ___   _ __ ___    _  | |_   | | | (_) | | |__         _ __ ___   ___     / / 
  / __| / __| | '_ ` _ \  | | | __|  | |  \__, | |___ \       | '_ ` _ \ / _ \   / /  
 | (__  \__ \ | | | | | | | | | |_   | |    / /   ___) |  _   | | | | | |  __/  / /   
  \___| |___/ |_| |_| |_| |_|  \__|  |_|   /_/   |____/  (_)  |_| |_| |_|\___| /_/    
   
   
    Script Name: Chris's Public Script (CP)
    Script Author: csmit195
    Script Version: 1.0
    Script Description: A soon to be public lua for all of man kind.
]]

local ffi = require 'ffi'
local csgo_weapons = require 'gamesense/csgo_weapons'
local http = require 'gamesense/http'
local steamworks = require 'gamesense/steamworks'
local panorama_events = require 'gamesense/panorama_events'

local js = panorama.open()
local _ = js['$']
local CompetitiveMatchAPI = js.CompetitiveMatchAPI
local GameStateAPI = js.GameStateAPI
local FriendsListAPI = js.FriendsListAPI
local GameTypesAPI = js.GameTypesAPI
local PartyListAPI = js.PartyListAPI
local MyPersonaAPI = js.MyPersonaAPI
local LobbyAPI = js.LobbyAPI
local SteamOverlayAPI = js.SteamOverlayAPI
local TeammatesAPI = js.TeammatesAPI

local ISteamFriends = steamworks.ISteamFriends

--#region Feature Overrides
local Feature = {items = {}}
local DisableOverride = database.read('cplua_overrides') or {}
function Feature.new(FeatureName, State)
	local object = {}
	object.name = FeatureName
	
	object.state = State
	if ( DisableOverride[FeatureName] ) then
		object.state = false
	end

	Feature.items[FeatureName] = object
	return object
end

function Feature.get(FeatureName)
	return Feature.items[FeatureName].state
end

Feature.new('Panorama Libraries', true) -- Very broad, will break a lot to disable
Feature.new('LiveCheck Library', true)

Feature.new('Delayed Auto Accept', true)
Feature.new('Delayed Connect', true)
Feature.new('Auto Accept Detection', true)
Feature.new('Auto Derank Score', true)
Feature.new('Auto Open CsgoStats.gg', false)
Feature.new('Auto Invite Recents', true)
Feature.new('Match Start Beep', true)
Feature.new('Custom Clantag Builder', true)
Feature.new('Custom Killsay Builder', true)
Feature.new('Report Enemy Tool', true)

Feature.new('Account Checkers', true)
Feature.new('Crack Checker', false)
Feature.new('Faceit Checker', true)
Feature.new('Game Value', true)
Feature.new('Inventory Value', true)
Feature.new('Banned Friends', true)
Feature.new('Name History', true)

Feature.new('Whitelist Friends on Key', true)
Feature.new('Playerlist Additions', true)
Feature.new('Highlight Targets', true)
Feature.new('Party Chat Utils', true)

Feature.new('Raw Chat Print', true)
Feature.new('User Data Saving', true)
--#endregion Feature Overrides

local lolz_data
local PListAdditions = {}

-- Options
local Options = {
	debugMode = false
}

--#region Panorama and Libraries
if ( Feature.get('Panorama Libraries') ) then
	--#region PartyChatCmd Library
	CPPanoramaMainMenu = panorama.loadstring([[
		// Lobby Chat Utils
		let Prefix = '!';
		let MsgSteamID = false;
		let MySteamID = MyPersonaAPI.GetXuid();
		let UserData = {};
		let MuteUsers = [];

		const Utilities = {};

		Utilities.IsBlacklisted = (SteamXUID) => {
			UserData.blacklist = UserData.blacklist || [0];
			return UserData.blacklist.includes(SteamXUID)
		}

		Utilities.SayParty = (Message) => {
			let FilteredMessage = Message.split(' ').join('\u{00A0}');
			PartyListAPI.SessionCommand('Game::Chat', `run all xuid ${MySteamID} chat ${FilteredMessage}`);
		}

		let Keys = [
			'5DA40A4A4699DEE30C1C9A7BCE84C914',
			'5970533AA2A0651E9105E706D0F8EDDC',
			'2B3382EBA9E8C1B58054BD5C5EE1C36A'
		];
		let KeyIndex = 0
		Utilities.RandomWebKey = () => {
			if ( KeyIndex >= Keys.length ) KeyIndex = 0;
			return Keys[KeyIndex++]
		}

		/*
		function resolveVanityURL(vanityurl, callback)
			http.get('https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1?key=' .. Utilities.RandomWebKeyhttp .. '&vanityurl=' .. vanityurl, function(success, response)
				if not success or response.status ~= 200 then return callback(false) end
		
				local data = json.parse(response.body)
				if data then
					if not data.response.success == 1 or not data.response.steamid then return callback(false) end
					return callback(data.response.steamid)
				end
				return callback(false)
			end)
		end
		*/

		Utilities.resolveVanityURL = (vanityurl, callback) => {
			$.AsyncWebRequest('https://api.steampowered.com/ISteamUser/ResolveVanityURL/v1?key=' + Utilities.RandomWebKey() + '&vanityurl=' + vanityurl, {
				type:"GET",
				complete:function(e){
					if ( e.status != 200 ) return;
					let Response = e.responseText.substring(0, e.responseText.length-1);
                    let Data = JSON.parse(Response);
					if ( Data.response.success ) {
						callback(Data.response.steamid)
					}
				}
			});
		}

		Utilities.FindPlayer = (str, NoOutput, callback) => {
			let FoundXUID = false;

			// Type Checks
			let regex_steamid64 = /(765\d{14})/i;
			let regex_steamid3 = / /i; // idk yet bud, maths is dumb
			let regex_friendcode = /(\w{5}-\w{4})/i;
			let regex_lobbyindex = /\d{1}$/i
			let regex_url = /steamcommunity.com\/id\/(.+)$/i;

			if ( regex_steamid64.test(str) ) {
				FoundXUID = str.match(regex_steamid64)[0];
			} else if ( regex_steamid3.test(str) ) {

			} else if ( regex_friendcode.test(str) ) {
				FoundXUID = FriendsListAPI.GetXuidFromFriendCode(str.match(regex_friendcode)[0]);
			} else if ( regex_lobbyindex.test(str) ) {
				let LobbyIndex = str.match(regex_lobbyindex)[0]
				FoundXUID = PartyListAPI.GetXuidByIndex(LobbyIndex - 1);
			} else if ( regex_url.test(str) && callback ) {
				let vanityURL = str.match(regex_url)[1].replace(/\/$/, "")
				Utilities.resolveVanityURL(vanityURL, (steamid)=>{
					callback(steamid)
				});
			} else if ( typeof str == 'string' ) {
				let TempID;
				let TempCount = 0;
				for ( i=0; i<PartyListAPI.GetCount(); i++ ) {
					let MemberSteamID = PartyListAPI.GetXuidByIndex(i);
					let MemberName = PartyListAPI.GetFriendName(MemberSteamID);
					if ( MemberName.toLowerCase().indexOf(str.toLowerCase()) == 0 ) {
						TempID = MemberSteamID;
						TempCount++;
					}
				}
				if ( TempCount == 1 ) {
					FoundXUID = TempID;
				} else if ( !NoOutput ) {
					Utilities.SayParty(`Found ${TempCount} matches for "${str}", try being more specific!`)
				}
			}
			if ( FoundXUID ) {
				if ( callback ) callback(FoundXUID);
				return FoundXUID
			}
		}

		Utilities.MessageHistory = [];

		function AttachHistory() {
			let elInput = $.GetContextPanel().FindChildTraverse('ChatInput');

			let ChatPanelContainer = $.GetContextPanel().FindChildTraverse('ChatPanelContainer');
			
			if ( ChatPanelContainer && elInput ) {
				let Root = ChatPanelContainer.GetParent();

				elInput.ClearPanelEvent('oninputsubmit');

				elInput.SetPanelEvent( 'onfocus', ()=>{
				});

				Utilities.ClearMessageIndex = ()=>{
					Utilities.MessageIndex = Utilities.MessageHistory.length;
				}

				elInput.SetPanelEvent( 'oninputsubmit', ()=>{
					let Msg = elInput.text;
					if ( Msg != '' ) {
						Utilities.MessageHistory.push(Msg);
						Utilities.ClearMessageIndex();
					}
					elInput.text = Msg.replace(/@[0-9\w-]+/ig, (match, capture)=>{
						let FoundXUID = Utilities.FindPlayer(match.substring(1), true)
						if ( FoundXUID ) {
							return PartyListAPI.GetFriendName(FoundXUID)
						}
						return match
					});
					Root.SubmitChatText()
					elInput.text = "";
				});
			}
		}

		AttachHistory()

		$.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", function(state){
			if(state == 'updated' && PartyListAPI.IsPartySessionActive()){
				AttachHistory();
			}
		});

		let PartyChatCommands = [];
		
		PartyChatCommands.push({
			title: 'Help (!\u{200B}help)',
			cmds: ['help', 'h'],
			timeout: 2500,
			exec: (cmd, args, sender, steamid) => {
 				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( args.length == 0 ) {
					for ( i=1; i<PartyChatCommands.length; i++ ) {
						let ChatCommand = PartyChatCommands[i];
						const Title = `» ${ChatCommand.title}`;
						const Alias = ChatCommand.cmds;
						Utilities.SayParty(Title);
					}
				} else {
					for ( i=1; i<PartyChatCommands.length; i++ ) {
						let ChatCommand = PartyChatCommands[i];
						const Alias = ChatCommand.cmds;
						const FoundAlias = Alias.find(item => item == args[0]);
						if ( FoundAlias ) {
							const AliasString = Alias.join(', ');
							const Title = `» List of Alias's: ${AliasString}`;
							Utilities.SayParty(Title);
							break;
						}
					}
				}
			}
		});
		PartyChatCommands.push({
			title: 'Test (!\u{200B}test)',
			cmds: ['test'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				Utilities.SayParty(`Test successful, sender info: ${sender} | ${steamid}`)
			}
		});
		PartyChatCommands.push({
			title: 'Start Queue (!\u{200B}startq)',
			cmds: ['start', 'startq', 'startqueue', 'queue', 'q'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;
				
				let settings = LobbyAPI.IsSessionActive() ? LobbyAPI.GetSessionSettings() : null;
				let stage = '';
				if ( settings && settings.game && settings.options
					&& settings.options.server !== 'listen'
					&& settings.game.mode === 'competitive'
					&& settings.game.mapgroupname.includes( 'mg_lobby_mapveto' ) ) {
					stage = '1';
				}

				LobbyAPI.StartMatchmaking(	MyPersonaAPI.GetMyOfficialTournamentName(),
					MyPersonaAPI.GetMyOfficialTeamName(),
					'',
					stage
				);
			}
		});
		PartyChatCommands.push({
			title: 'Stop Queue (!\u{200B}stopq)',
			cmds: ['stop', 'stopq', 'stopqueue', 'sq', 's'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				LobbyAPI.StopMatchmaking()
			}
		});
		PartyChatCommands.push({
			title: 'Restart Queue (!\u{200B}restartq)',
			cmds: ['restart', 'restartq', 'restartqueue', 'rs'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;
				LobbyAPI.StopMatchmaking()
				$.Schedule(1, ()=>{
					let settings = LobbyAPI.IsSessionActive() ? LobbyAPI.GetSessionSettings() : null;
					let stage = '';
					if ( settings && settings.game && settings.options
						&& settings.options.server !== 'listen'
						&& settings.game.mode === 'competitive'
						&& settings.game.mapgroupname.includes( 'mg_lobby_mapveto' ) ) {
						stage = '1';
					}

					LobbyAPI.StartMatchmaking(	MyPersonaAPI.GetMyOfficialTournamentName(),
						MyPersonaAPI.GetMyOfficialTeamName(),
						'',
						stage
					);
				});
			}
		});
		PartyChatCommands.push({
			title: 'Reset Lobby (!\u{200B}resetlobby)',
			cmds: ['resetlobby', 'relobby', 'rl'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				let Settings = LobbyAPI.GetSessionSettings();
				let GameMode = Settings.game.mode;
				let GameType = Settings.game.type;
				let MapGroupName = Settings.game.mapgroupname;
				let MySteamID = MyPersonaAPI.GetXuid();

				if ( steamid != MySteamID ) return;

				// Get Lobby Players
				let SteamIDs = [];
				for ( i=0; i<Settings.members.numMachines; i++ ) {
					let Player = Settings.members[`machine${i}`];
					let PlayerSteamID = Player.id;

					if ( MySteamID != PlayerSteamID ) {
						SteamIDs.push(PlayerSteamID)
					}
				}

				LobbyAPI.CloseSession();

				for ( i=0; i<SteamIDs.length; i++ ) {
					FriendsListAPI.ActionInviteFriend(SteamIDs[i], '');
				}
			}
		});
		PartyChatCommands.push({
			title: 'Maps (!\u{200B}maps dust2, safehouse)',
			cmds: ['maps', 'map', 'setmaps', 'changemap', 'changemaps'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !UserData.mods.indexOf(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;
				
				let Config = GameTypesAPI.GetConfig();
				let SessionSettings = LobbyAPI.GetSessionSettings();
				let GameMode = SessionSettings.game.mode;
				let GameType = SessionSettings.game.type;

				let MapsInGroup = Config.gameTypes[GameType].gameModes[GameMode].mapgroupsMP;
				let MapList = [];

				if ( args[0] == 'all' ) {
					delete MapsInGroup['mg_lobby_mapveto'];
					MapList = Object.keys(MapsInGroup)
				} else {
					let Maps = args.join(',').split(',');
					let FilteredMaps = [];
					Maps.forEach((map, index)=>{
						if ( map.trim() != '' ) {
							FilteredMaps.push(map)
						}
					});

					let FoundMaps = {};
					FilteredMaps.forEach((SearchMap, key)=>{
						for (Map in MapsInGroup) {
							let MapName = GameTypesAPI.GetFriendlyMapName(Map.substr(3));
							if ( Map.indexOf('scrimmage') == -1 && ( MapName.toLowerCase().indexOf(SearchMap.trim().toLowerCase()) != -1 || Map.toLowerCase().search(SearchMap.toLowerCase()) != -1 ) ) {
								FoundMaps[Map] = true;
							}
						} 
					});
					
					for ( Map in FoundMaps ) {
						MapList.push(Map);
					}
				}
				
				if ( MapList.length > 0 ) {
					PartyListAPI.UpdateSessionSettings(`Update/Game/mapgroupname ${MapList}`);
				} 
			}
		});

		PartyChatCommands.push({
			title: 'Gamemode (!\u{200B}mode wm)',
			cmds: ['mode', 'gm', 'gamemode', 'mm', 'wm'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;

				let SessionSettings = LobbyAPI.GetSessionSettings();
				let GameMode = SessionSettings.game.mode;
				let GameType = SessionSettings.game.type;

				let settings = { update : { Game: { } } }

				// I would use a switch case, but I want to do regex
				if ( cmd == 'mm' || ( args.length > 0 && /(comp.*|5(x|v)5|mm)/i.test(args[0]) ) ) {
					settings.update.Game.mode = 'competitive'
					settings.update.Game.type = 'classic'
				} else if ( cmd == 'wm' || ( args.length > 0 && /(wing.*|2(x|v)2|wm)/i.test(args[0]) ) ) {
					settings.update.Game.mode = 'scrimcomp2v2'
					settings.update.Game.type = 'classic'
				}

				LobbyAPI.UpdateSessionSettings( settings );
			}
		});

		PartyChatCommands.push({
			title: 'clearchat (!\u{200B}clearchat)',
			cmds: ['clearchat', 'clear', 'cc', 'cl', 'deletechat', 'delchat', 'deletechat'],
			exec: (cmd, args, sender, steamid) => {
				if ( steamid != MyPersonaAPI.GetXuid() ) return;

				let party_chat = $.GetContextPanel().FindChildTraverse("PartyChat")
				if(party_chat) {
					let chat_lines = party_chat.FindChildTraverse("ChatLinesContainer")
					if(chat_lines) {
						chat_lines.RemoveAndDeleteChildren();
					}
				}
			}
		});

		PartyChatCommands.push({
			title: 'Kick (!\u{200B}kick <partial:name>|<steamid>|<friendcode>)',
			cmds: ['kick'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;
				if ( steamid != LobbyAPI.GetHostSteamID() && !UserData.mods.indexOf(steamid) ) return;

				UserData.mods = UserData.mods || [0];

				if ( typeof args[0] != 'undefined' ) {
					let KickXUID = Utilities.FindPlayer(args[0]);
					if ( KickXUID && LobbyAPI.GetHostSteamID() != KickXUID && LobbyAPI.IsPartyMember(KickXUID) ) {
						LobbyAPI.KickPlayer(KickXUID);
						let Name = FriendsListAPI.GetFriendName(KickXUID);
						Utilities.SayParty(`Kicked ${Name} (${KickXUID}) from the lobby!`);
					} else if ( LobbyAPI.GetHostSteamID() == KickXUID ) {
						Utilities.SayParty(`You cant kick the host nigger!`);
					}
				}
			}
		});

		PartyChatCommands.push({
			title: 'Check (!\u{200B}Check <steamid>|<friendcode>)',
			cmds: ['check'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				if ( typeof args[0] != 'undefined' ) {
					Utilities.FindPlayer(args[0], false, (steamid)=>{
						let Name = FriendsListAPI.GetFriendName(steamid);
						Utilities.SayParty('[LiveCheck] Please wait 5 seconds. Checking...');
						LiveCheck.start(steamid, (data)=>{
							let msg = '[LiveCheck] ';
							if ( data ) { 
								msg += `${Name} is in-${data.state} `
								if ( data.state == 'lobby' ) {
									msg += 'queuing '
									let Maps = data.mapgroupname.split(',');
									let CleanMaps = [];
									for ( i=0; i<Maps.length; i++ ) {
										let TextClean = Maps[i].substr(3, Maps[i].length);
										CleanMaps[i] = GameTypesAPI.GetFriendlyMapName(TextClean);
									}
									msg += CleanMaps.join(', ');
								} else if ( data.state == 'game' ) {
									msg += `playing ${data.map} - ${data.status}`
								}
							} else {
								msg += ` Found no rich presence for ${steamid}`;
							}
							Utilities.SayParty(msg);
						})
					});
				}
			}
		});

		// CountryNames thanks to sapphryus
		let CountryNames = {KW:"Kuwait",MA:"Morocco ",AF:"Afghanistan",AL:"Albania",DZ:"Algeria",AS:"American Samoa",AD:"Andorra",AO:"Angola",AI:"Anguilla",AQ:"Antarctica",AG:"Antigua and Barbuda",AR:"Argentina",AM:"Armenia",AW:"Aruba",AU:"Australia",AT:"Austria",AZ:"Azerbaijan",BS:"Bahamas",BH:"Bahrain",BD:"Bangladesh",BB:"Barbados",BY:"Belarus",BE:"Belgium",BZ:"Belize",BJ:"Benin",BM:"Bermuda",BT:"Bhutan",BO:"Bolivia",BA:"Bosnia and Herzegovina",BW:"Botswana",BV:"Bouvet Island",BR:"Brazil",IO:"British Indian Ocean Territory",BN:"Brunei Darussalam",BG:"Bulgaria",BF:"Burkina Faso",BI:"Burundi",KH:"Cambodia",CM:"Cameroon",CA:"Canada",CV:"Cape Verde",KY:"Cayman Islands",CF:"Central African Republic",TD:"Chad",CL:"Chile",CN:"China",CX:"Christmas Island",CC:"Cocos (Keeling) Islands",CO:"Colombia",KM:"Comoros",CG:"Congo",CD:"Congo, the Democratic Republic of the",CK:"Cook Islands",CR:"Costa Rica",CI:"Cote D'Ivoire",HR:"Croatia",CU:"Cuba",CY:"Cyprus",CZ:"Czech Republic",DK:"Denmark",DJ:"Djibouti",DM:"Dominica",DO:"Dominican Republic",EC:"Ecuador",EG:"Egypt",SV:"El Salvador",GQ:"Equatorial Guinea",ER:"Eritrea",EE:"Estonia",ET:"Ethiopia",FK:"Falkland Islands (Malvinas)",FO:"Faroe Islands",FJ:"Fiji",FI:"Finland",FR:"France",GF:"French Guiana",PF:"French Polynesia",TF:"French Southern Territories",GA:"Gabon",GM:"Gambia",GE:"Georgia",DE:"Germany",GH:"Ghana",GI:"Gibraltar",GR:"Greece",GL:"Greenland",GD:"Grenada",GP:"Guadeloupe",GU:"Guam",GT:"Guatemala",GN:"Guinea",GW:"Guinea-Bissau",GY:"Guyana",HT:"Haiti",HM:"Heard Island and Mcdonald Islands",VA:"Holy See (Vatican City State)",HN:"Honduras",HK:"Hong Kong",HU:"Hungary",IS:"Iceland",IN:"India",ID:"Indonesia",IR:"Iran, Islamic Republic of",IQ:"Iraq",IE:"Ireland",IL:"Israel",IT:"Italy",JM:"Jamaica",JP:"Japan",JO:"Jordan",KZ:"Kazakhstan",KE:"Kenya",KI:"Kiribati",KP:"North Korea",KR:"South Korea",KW:"Kuwait",KG:"Kyrgyzstan",LA:"Lao People's Democratic Republic",LV:"Latvia",LB:"Lebanon",LS:"Lesotho",LR:"Liberia",LY:"Libya",LI:"Liechtenstein",LT:"Lithuania",LU:"Luxembourg",MO:"Macao",MG:"Madagascar",MW:"Malawi",MY:"Malaysia",MV:"Maldives",ML:"Mali",MT:"Malta",MH:"Marshall Islands",MQ:"Martinique",MR:"Mauritania",MU:"Mauritius",YT:"Mayotte",MX:"Mexico",FM:"Micronesia, Federated States of",MD:"Moldova, Republic of",MC:"Monaco",MN:"Mongolia",MS:"Montserrat",MA:"Morocco",MZ:"Mozambique",MM:"Myanmar",NA:"Namibia",NR:"Nauru",NP:"Nepal",NL:"Netherlands",NC:"New Caledonia",NZ:"New Zealand",NI:"Nicaragua",NE:"Niger",NG:"Nigeria",NU:"Niue",NF:"Norfolk Island",MK:"North Macedonia, Republic of",MP:"Northern Mariana Islands",NO:"Norway",OM:"Oman",PK:"Pakistan",PW:"Palau",PS:"Palestinian Territory, Occupied",PA:"Panama",PG:"Papua New Guinea",PY:"Paraguay",PE:"Peru",PH:"Philippines",PN:"Pitcairn",PL:"Poland",PT:"Portugal",PR:"Puerto Rico",QA:"Qatar",RE:"Reunion",RO:"Romania",RU:"Russia",RW:"Rwanda",SH:"Saint Helena",KN:"Saint Kitts and Nevis",LC:"Saint Lucia",PM:"Saint Pierre and Miquelon",VC:"Saint Vincent and the Grenadines",WS:"Samoa",SM:"San Marino",ST:"Sao Tome and Principe",SA:"Saudi Arabia",SN:"Senegal",SC:"Seychelles",SL:"Sierra Leone",SG:"Singapore",SK:"Slovakia",SI:"Slovenia",SB:"Solomon Islands",SO:"Somalia",ZA:"South Africa",GS:"South Georgia and the South Sandwich Islands",ES:"Spain",LK:"Sri Lanka",SD:"Sudan",SR:"Suriname",SJ:"Svalbard and Jan Mayen",SZ:"Eswatini",SE:"Sweden",CH:"Switzerland",SY:"Syrian Arab Republic",TW:"Taiwan",TJ:"Tajikistan",TZ:"Tanzania, United Republic of",TH:"Thailand",TL:"Timor-Leste",TG:"Togo",TK:"Tokelau",TO:"Tonga",TT:"Trinidad and Tobago",TN:"Tunisia",TR:"Turkey",TM:"Turkmenistan",TC:"Turks and Caicos Islands",TV:"Tuvalu",UG:"Uganda",UA:"Ukraine",AE:"United Arab Emirates",GB:"United Kingdom",US:"USA",UM:"United States Minor Outlying Islands",UY:"Uruguay",UZ:"Uzbekistan",VU:"Vanuatu",VE:"Venezuela",VN:"Vietnam",VG:"Virgin Islands, British",VI:"Virgin Islands, U.S.",WF:"Wallis and Futuna",EH:"Western Sahara",YE:"Yemen",ZM:"Zambia",ZW:"Zimbabwe",AX:"Åland Islands",BQ:"Bonaire, Sint Eustatius and Saba",CW:"Curaçao",GG:"Guernsey",IM:"Isle of Man",JE:"Jersey",ME:"Montenegro",BL:"Saint Barthélemy",MF:"Saint Martin (French part)",RS:"Serbia",SX:"Sint Maarten (Dutch part)",SS:"South Sudan",XK:"Kosovo"}
		PartyChatCommands.push({
			title: 'Locate (!\u{200B}locate <partial:name>|<steamid>|<friendcode>)',
			cmds: ['locate', 'locs', 'loc', 'locations', 'location'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				let XUID = 0;
				if ( typeof args[0] != 'undefined' ) {
					XUID = Utilities.FindPlayer(args[0])
				}
				

				let Settings = LobbyAPI.GetSessionSettings();
				for ( i=0; i<Settings.members.numMachines; i++ ) {
					let Player = Settings.members[`machine${i}`];
					let PlayerSteamID = Player.id;
					let PlayerName = Player.player0.name;
					let Location = Player.player0.game.loc;
					let LocationFull = CountryNames[Location];

					if ( typeof args[0] == 'undefined' || PlayerSteamID == XUID ) {
						Utilities.SayParty(`[LOCATION] ${PlayerName} is from ${LocationFull}!`);
					}
				}
			}
		});
		PartyChatCommands.push({
			title: 'Mods (!\u{200B}mod add <partial:name>|<steamid>|<friendcode>|<lobbyindex>)',
			helpTitle: 'Type "!mod add <PartialName>", "!mod add <SteamID64>", "!mod add <FriendCode>", "!mod add <LobbyIndex>"',
			helpExamples: 'Typing "!mod add 2" will mod the second person in the lobby, others are pretty easy like "!mod add csmit"!',
			cmds: ['mod'],
			exec: (cmd, args, sender, steamid) => {
				if ( steamid == MyPersonaAPI.GetXuid() ) {
					UserData.mods = UserData.mods || [0];
					switch(args[0]) {
						case 'add':
							if ( typeof args[1] != 'undefined' ) {
								let ModXUID = Utilities.FindPlayer(args[1]);
								if ( ModXUID ) {
									if ( UserData.mods.indexOf(ModXUID) == -1 ) {
										UserData.mods.push(ModXUID);
										let FriendName = FriendsListAPI.GetFriendName(ModXUID);
										Utilities.SayParty(`Added ${FriendName}(${ModXUID}) as a moderator!`);
									} else {
										let FriendName = FriendsListAPI.GetFriendName(ModXUID);
										Utilities.SayParty(`Cannot add ${FriendName}(${ModXUID}) as they are already a moderator!`)
									}
								} else {
									Utilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)
								}
							}
							break;
						case 'list':
							UserData.mods.forEach((steamid, index)=>{
								if ( steamid ) {
									let FriendName = FriendsListAPI.GetFriendName(steamid);
									Utilities.SayParty(`[${index}] ${FriendName} - ${steamid}`);
								}
							})
							break;
						case 'remove':
							if ( typeof args[1] != 'undefined' ) {
								if ( typeof UserData.mods[ parseInt(args[1]) ] == 'undefined' ) {
									let ModXUID = Utilities.FindPlayer(args[1]);
									let FoundIndex = UserData.mods.indexOf(ModXUID);
									if ( ModXUID && FoundIndex != -1 ) {
										let FriendSteam = UserData.mods[FoundIndex];
										let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
										Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);
										delete UserData.mods[ FoundIndex ];
									}
								} else {
									let FriendSteam = UserData.mods[ parseInt(args[1]) ];
									let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
									Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);
									delete UserData.mods[ parseInt(args[1]) ];
								}
							}
							break;
						case 'clear':
							let TotalMods = UserData.mods.length || 0
							Utilities.SayParty(`Cleared ${TotalMods} records (incl removed and existing mods)!`);
							UserData.mods = [null];
							break;
						default:
							if ( typeof args[0] != 'undefined' ) {
								let ModXUID = Utilities.FindPlayer(args[0]);
								if ( ModXUID && ModXUID != MySteamID ) {
									if ( UserData.mods.indexOf(ModXUID) == -1 ) {
										UserData.mods.push(ModXUID);
										let FriendName = FriendsListAPI.GetFriendName(ModXUID);
										Utilities.SayParty(`Added ${FriendName} (${ModXUID}) as a moderator!`);
									} else {
										let FoundIndex = UserData.mods.indexOf(ModXUID);
										if ( FoundIndex != -1 ) {
											let FriendSteam = UserData.mods[FoundIndex];
											let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
											Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) as a moderator!`);
											delete UserData.mods[ FoundIndex ];
										}
									}
								} else if ( ModXUID == MySteamID ) {
									Utilities.SayParty(`Nope! You cannot add yourself to the moderator!`)
								} else {
									Utilities.SayParty(`Sorry! I don't know how to decipher: ${args[0]}`)
								}
							}
					}                
				}
			}
		});
		PartyChatCommands.push({
			title: 'Blacklist (!\u{200B}blacklist <partial:name>|<steamid>|<friendcode>|<lobbyindex>)',
			helpTitle: 'Type "!blacklist add <PartialName>", "!blacklist add <SteamID64>", "!blacklist add <FriendCode>", "!blacklist add <LobbyIndex>"',
			helpExamples: 'Typing "!blacklist add 2" will blacklist the second person in the lobby, others are pretty easy like "!blacklist add csmit"!',
			cmds: ['blacklist', 'bl'],
			exec: (cmd, args, sender, steamid) => {
				if ( steamid == MyPersonaAPI.GetXuid() ) {
					UserData.blacklist = UserData.blacklist || [0];
					switch(args[0]) {
						case 'add':
							if ( typeof args[1] != 'undefined' ) {
								let BlacklistXUID = Utilities.FindPlayer(args[1]);
								if ( BlacklistXUID && BlacklistXUID != MySteamID ) {
									if ( UserData.blacklist.indexOf(BlacklistXUID) == -1 ) {
										UserData.blacklist.push(BlacklistXUID);
										let FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);
										Utilities.SayParty(`Added ${FriendName} (${BlacklistXUID}) to blacklist!`);
									} else {
										let FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);
										Utilities.SayParty(`Cannot add ${FriendName}(${BlacklistXUID}) to blacklist!`)
									}
								} else if ( BlacklistXUID == MySteamID ) {
									Utilities.SayParty(`Nope! You cannot add yourself to the blacklist!`)
								} else {
									Utilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)
								}
							}
							break;
						case 'list':
							UserData.blacklist.forEach((steamid, index)=>{
								if ( steamid ) {
									let FriendName = FriendsListAPI.GetFriendName(steamid);
									Utilities.SayParty(`[${index}] ${FriendName} - ${steamid}`);
								}
							})
							break;
						case 'remove':
							if ( typeof args[1] != 'undefined' ) {
								if ( typeof UserData.blacklist[ parseInt(args[1]) ] == 'undefined' ) {
									let BlacklistXUID = Utilities.FindPlayer(args[1]);
									let FoundIndex = UserData.blacklist.indexOf(BlacklistXUID);
									if ( BlacklistXUID && FoundIndex != -1 ) {
										let FriendSteam = UserData.blacklist[FoundIndex];
										let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
										Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);
										delete UserData.blacklist[ FoundIndex ];
									}
								} else {
									let FriendSteam = UserData.blacklist[ parseInt(args[1]) ];
									let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
									Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);
									delete UserData.blacklist[ parseInt(args[1]) ];
								}
							}
							break;
						case 'clear':
							let TotalBlacklist = UserData.blacklist.length || 0
							Utilities.SayParty(`Cleared ${TotalBlacklist} records (incl removed and existing blacklists)!`);
							UserData.blacklist = [0];
							break;
						default:
							if ( typeof args[0] != 'undefined' ) {
								let BlacklistXUID = Utilities.FindPlayer(args[0]);
								if ( BlacklistXUID && BlacklistXUID != MySteamID ) {
									if ( UserData.blacklist.indexOf(BlacklistXUID) == -1 ) {
										UserData.blacklist.push(BlacklistXUID);
										let FriendName = FriendsListAPI.GetFriendName(BlacklistXUID);
										Utilities.SayParty(`Added ${FriendName} (${BlacklistXUID}) to blacklist!`);
									} else {
										let FoundIndex = UserData.blacklist.indexOf(BlacklistXUID);
										if ( FoundIndex != -1 ) {
											let FriendSteam = UserData.blacklist[FoundIndex];
											let FriendName = FriendsListAPI.GetFriendName(FriendSteam);
											Utilities.SayParty(`Removed ${FriendName} (${FriendSteam}) from blacklist!`);
											delete UserData.blacklist[ FoundIndex ];
										}
									}
								} else if ( BlacklistXUID == MySteamID ) {
									Utilities.SayParty(`Nope! You cannot add yourself to the blacklist!`)
								} else {
									Utilities.SayParty(`Sorry! I don't know how to decipher: ${args[1]}`)
								}
							}
					}                
				}
			}
		});
		PartyChatCommands.push({
			title: 'Invite (!\u{200B}invite <steamid>|<friendcode>)',
			cmds: ['inv', 'invite', 'add'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				Utilities.FindPlayer(args[0], false, (steamid)=>{
					FriendsListAPI.ActionInviteFriend(steamid, '')
				})
			}
		});
		PartyChatCommands.push({
			title: 'WhoInvited (!\u{200B}who <steamid>|<friendcode>)',
			cmds: ['who', 'whoinv', 'whoinvite', 'whoinvited'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				let XUID = 0;
				if ( typeof args[0] != 'undefined' ) {
					XUID = Utilities.FindPlayer(args[0])
				}

				if ( XUID != 0 ) {
					let LobbyData = LobbyAPI.GetSessionSettings()
					for ( i=0; i<LobbyData.members.numMachines; i++ ) {
						let Machine = LobbyData.members[`machine${i}`]
						if ( Machine && XUID == Machine.id ) {
							let jfriend = Machine['player0'].game.jfriend
							let jfriendName = FriendsListAPI.GetFriendName(jfriend);
							let friendName = FriendsListAPI.GetFriendName(XUID);
							if ( jfriend ) {		
								Utilities.SayParty(`${friendName} was invited by ${jfriendName} (${jfriend})!`);
							} else {
								Utilities.SayParty(`Couldn't find who invited ${friendName}!`);
							}
						}
					}
				}
			}
		});
		PartyChatCommands.push({
			title: 'Mute (!\u{200B}mute <steamid>|<friendcode>)',
			cmds: ['mute', 'm', 'quiet', 'silence', 'ignore', 'block'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				let XUID = 0;
				if ( typeof args[0] != 'undefined' ) {
					XUID = Utilities.FindPlayer(args[0])
				}

				if ( XUID != 0 ) {
					let friendName = FriendsListAPI.GetFriendName(XUID);
					MuteUsers.push(XUID);
					Utilities.SayParty(`${friendName} is now muted!`);
				}
			}
		});
		PartyChatCommands.push({
			title: 'Ping (!\u{200B}ping <ping> [ <target> ] or !ping)',
			cmds: ['ping', 'maxping', 'p'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				let BaseCMD = 'mm_dedicated_search_maxping'
				let MyPing = GameInterfaceAPI.GetSettingString(BaseCMD);

				if ( /((?:\d\s){3}\d)/.test(MyPing) ) {
					MyPing = '> 1000'
				} else {
					MyPing = '< ' + Math.trunc(MyPing)
				}

				switch (args.length) {
					case 0:
						// Print current ping
						Utilities.SayParty(`[PING] My ping is: ${MyPing}`);
						break;
					case 1:
						// Set Ping to Arg0
						let RequestedPing = Math.trunc(args[0]);
						if ( RequestedPing == '0' ) {
							RequestedPing = '0 0 0 4'
						}
						GameInterfaceAPI.ConsoleCommand(`${BaseCMD} ${RequestedPing}`)
						Utilities.SayParty(`[PING] I set ping to: ${RequestedPing}`);
						break;
					case 2:
						// If Arg1 == Me, set Ping to Arg0
						let XUID = Utilities.FindPlayer(args[1]);
						if ( XUID != 0 && XUID == MySteamID ) {
							let RequestedPing = Math.trunc(args[0]);
							if ( RequestedPing == '0' ) {
								RequestedPing = '0 0 0 4'
							}
							GameInterfaceAPI.ConsoleCommand(`${BaseCMD} ${RequestedPing}`)
							Utilities.SayParty(`[PING] I set ping to: ${RequestedPing}`);
						}
						break;
				}
			}
		});

		// Ignore Initial Chat
		let PreprocessChat = () => {
			let party_chat = $.GetContextPanel().FindChildTraverse("PartyChat")
			if(party_chat) {
				let chat_lines = party_chat.FindChildTraverse("ChatLinesContainer")
				if(chat_lines) {
					chat_lines.Children().reverse().forEach(el => {
						let child = el.GetChild(0)
						if ( child && child.BHasClass('left-right-flow') && child.BHasClass('horizontal-align-left') ) {
							if ( child.GetChildCount() == 2 ) {
								MsgSteamID = child.Children()[0].steamid;
							}
							if ( !child.BHasClass('cp_processed') ) {
								child.AddClass('cp_processed');
							}
						}
					})
				}
			}
		}
		PreprocessChat();

		let ProcessChat = false;
		let Shutdown = false;
		let Timeouts = [];
		let PartyChatLoop = ()=>{
			let party_chat = $.GetContextPanel().FindChildTraverse("PartyChat")
			if(party_chat) {
				let chat_lines = party_chat.FindChildTraverse("ChatLinesContainer")
				if(chat_lines) {
					chat_lines.Children().forEach(el => {
						let child = el.GetChild(0)
						if ( child && child.BHasClass('left-right-flow') && child.BHasClass('horizontal-align-left') ) {
							try {
								if ( child.BHasClass('cp_processed') ) return false;
						
								let InnerChild = child.GetChild(child.GetChildCount()-1);
								if ( InnerChild && InnerChild.text ) {
									let Sender = $.Localize('{s:player_name}', InnerChild);
									let Message = $.Localize('{s:msg}', InnerChild);
								
									//var Message = InnerChild.text.toLowerCase()
									
									if (!Message.startsWith(Prefix)) return;

									if ( child.GetChildCount() == 2 ) {
										MsgSteamID = child.Children()[0].steamid;
									}

									if ( MuteUsers.includes(MsgSteamID) ) {
										return el.RemoveAndDeleteChildren();
									}

									const args = Message.slice(Prefix.length).trim().split(' ');
									const command = args.shift().toLowerCase();

									for ( index=0; index < PartyChatCommands.length; index++ ) {
										const ChatCommand = PartyChatCommands[index];
										for ( i=0; i<ChatCommand.cmds.length; i++ ) {
											const Alias = ChatCommand.cmds[i]; 
											if ( Alias == command ) {
												if ( ChatCommand.timeout ) {
													if ( Timeouts[ChatCommand] && Date.now() <= Timeouts[ChatCommand] ) {
														break;
													} else {
														Timeouts[ChatCommand] = Date.now() + ChatCommand.timeout
													}
												}
												ChatCommand.exec(command, args, Sender, MsgSteamID)
												break;
											}
										}
									}
								}
							} catch(err) {
								$.Msg('CSLua: Error (probably irrelevent) ', err);
							}
							if ( child ) child.AddClass('cp_processed');
						}
					})
				}
			}	
		}

		return {
			PartyChatLoop: ()=>{
				PartyChatLoop();
			},
			GetUserData: ()=>{
				return JSON.stringify(UserData);
			},
			SetUserData: (data)=>{
				UserData = JSON.parse(data);
				UserData.mods = typeof UserData.mods == 'undefined' ? [] : Object.values(UserData.mods);
				UserData.blacklist = typeof UserData.blacklist == 'undefined' ? [] : Object.values(UserData.blacklist);
			},
			PreviousMessage: ()=>{
				let elInput = $.GetContextPanel().FindChildTraverse('ChatInput');
				if ( elInput && Utilities.MessageHistory.length > 0 && Utilities.MessageIndex > 0 ) {
					if ( elInput.BHasKeyFocus() ) {
						elInput.text = Utilities.MessageHistory[Utilities.MessageIndex-- - 1];
					} else {
						Utilities.MessageIndex = Utilities.MessageHistory.length;
					}
				}
			},
			NextMessage: ()=>{
				let elInput = $.GetContextPanel().FindChildTraverse('ChatInput');
				if ( elInput && Utilities.MessageHistory.length > 0 && Utilities.MessageIndex < Utilities.MessageHistory.length - 1 ) {
					if ( elInput.BHasKeyFocus() ) {
						elInput.text = Utilities.MessageHistory[Utilities.MessageIndex++ + 1];
					} else {
						Utilities.ClearMessageIndex();
					}
				}
			},
			ClearMessageIndex: Utilities.ClearMessageIndex
		}
	]], 'CSGOMainMenu')();
	--#endregion

	--#region Lolz Checker Library
	if ( Feature.get('Crack Checker') ) then
		LolzPanorama = panorama.loadstring([[
			var html
			var finish_handler
			var alert_handler
			var data

			var page_script = `
				function setCookie(name,value,days) {
					var expires = "";
					if (days) {
						var date = new Date();
						date.setTime(date.getTime() + (days*24*60*60*1000));
						expires = "; expires=" + date.toUTCString();
					}
					document.cookie = name + "=" + (value || "")  + expires + "; path=/";
				}
				
				setCookie('xf_market_currency','usd',7);
				
				var data = {
					cookie: document.cookie,
					user_agent: navigator.userAgent
				}
				alert(JSON.stringify(data));
			`

			var _Create = function() {
				if(html != null) {
					return
				}

				html = $.CreatePanel("HTML", $.GetContextPanel(), "", {
					url: "https://lolz.guru/",
					acceptsinput: "false",
					acceptsfocus: "false",
					mousetracking: "false",
					focusonhover: "false",
					width: "100px",
					height: "100px",
				})
				html.visible = false

				finish_handler = $.RegisterEventHandler("HTMLFinishRequest", html, function(a, url, title){
					if(url == "https://lolz.guru/"){
						html.RunJavascript(page_script)
					}
				});

				alert_handler = $.RegisterEventHandler("HTMLJSAlert", html, function(id, alert_text){
					if(html != null && id == html.id) {
						try {
							data = JSON.parse(alert_text)

							html.RunJavascript('document.cookie = `df_id=; domain=lolz.guru; path=/; max-age=0; xf_market_currency=usd;`;')

							// we got cookies, clean up everything
							_Destroy()
						} catch(err) {
							// silently ignore
						}
					}
				});

			}

			var _Destroy = function() {
				if(finish_handler != null) {
					$.UnregisterEventHandler("HTMLFinishRequest", html, finish_handler)
					finish_handler = null
				}

				if(alert_handler != null) {
					$.UnregisterEventHandler("HTMLJSAlert", html, alert_handler)
					alert_handler = null
				}

				if(html != null) {
					html.DeleteAsync(0.0)
					html = null
				}
			}

			// just to return the data back to lua
			var _GetData = function() {
				return data
			}

			return {
				create: _Create,
				destroy: _Destroy,
				get_data: _GetData
			}
		]], "CSGOMainMenu")()
	end
	--#endregion

	--#region ReconnectBtn Library
	ReconnectBtn = panorama.loadstring([[
		var btnReconnect = $.GetContextPanel().FindChildTraverse( 'MatchmakingReconnect' );

		return {
			set:(text)=>{btnReconnect.text = text},
			reset:()=>{btnReconnect.text = 'RECONNECT'},
			get:()=>btnReconnect.text
		}
	]], 'CSGOMainMenu')()

	--#endregion

	--#region LiveCheck Library
	if ( Feature.get('LiveCheck Library') ) then
		client.delay_call(0, function()
			-- LOL SAPH DONT BULLY ME, I know you see what code was here. Fuck me.
			LiveCheck = { datawaiting = {}, agecheck = {}, dataready = {} }

			function LiveCheck.buildRichPresence(steamid)
				local RichPresence = {}
				RichPresence.version = ISteamFriends.GetFriendRichPresence(steamid, 'version')
				RichPresence.status = ISteamFriends.GetFriendRichPresence(steamid, 'status')
				RichPresence.state = ISteamFriends.GetFriendRichPresence(steamid, 'game:state')
				RichPresence.gamemode = ISteamFriends.GetFriendRichPresence(steamid, 'game:mode')
				RichPresence.mapgroupname = ISteamFriends.GetFriendRichPresence(steamid, 'game:mapgroupname')
				RichPresence.map = ISteamFriends.GetFriendRichPresence(steamid, 'game:map')
				return RichPresence
			end

			function LiveCheck:start(_steamid, callback)
				if not _steamid then return end

				local steamid = tostring(_steamid)
				local PresenceCount = ISteamFriends.GetFriendRichPresenceKeyCount(steamid)
				local RichPresence = PresenceCount > 0 and LiveCheck.buildRichPresence(steamid) or false

				LiveCheck.datawaiting[steamid] = true

				ISteamFriends.RequestFriendRichPresence(steamid)

				client.delay_call(5, function()
					callback(steamid, LiveCheck.dataready[steamid] or RichPresence)
				end)
			end

			-- Register Callbacks
			steamworks.set_callback('FriendRichPresenceUpdate_t', function(e)
				local steamid = e.m_steamIDFriend:render_steam64()
				if ( LiveCheck.datawaiting[steamid] ) then
					LiveCheck.dataready[steamid] = LiveCheck.buildRichPresence(steamid)
					LiveCheck.datawaiting[steamid] = false
				end
			end)

			-- Panorama Access
			LiveCheck.panorama = panorama.loadstring([[
				LiveCheck = {queue:[], waiting:{}}
				LiveCheck.start = (steamid, callback) => {
					LiveCheck.waiting[steamid] = callback
					LiveCheck.queue[LiveCheck.queue.length + 1] = steamid
				}

				function _getQueue(){
					let Queue = LiveCheck.queue;
					LiveCheck.queue = [];
					return Queue;
				}

				function _finished(steamid, data){
					if ( typeof LiveCheck.waiting[steamid] != 'undefined' ) {
						LiveCheck.waiting[steamid](data);
						delete LiveCheck.waiting[steamid];
					}
				}

				return  {
					getQueue: _getQueue,
					finished: _finished
				}
			]], 'CSGOMainMenu')()

			function LiveCheck.loop()
				local Queue = LiveCheck.panorama.getQueue()
				if ( Queue.length > 0 ) then
					for i=0, Queue.length-1 do
						local SteamID = Queue[i]
						if ( SteamID ) then
							LiveCheck:start(SteamID, function(steamid, data)
								LiveCheck.panorama.finished(steamid, data)
							end)
						end
					end
				end
				client.delay_call(0.5, LiveCheck.loop)
			end
			LiveCheck.loop()
		end)
	end
	--#endregion

	-- Too clean to put in one of the above panoramas, looks sexy AF
	Date = panorama.loadstring('return [ts => new Date(ts * 1000)]')()[0]
end
--#endregion

function Initiate()
	local CPLua = {loops = {}}

	CPLua.ChatMethods = {
		['Local Chat'] = function(msg)
			cp_SendChat(msg)
		end,
		['Party Chat'] = function(msg)
			PartyListAPI.SessionCommand('Game::Chat', string.format('run all xuid %s chat %s', MyPersonaAPI.GetXuid(), msg:gsub(' ', ' ')))
		end,
		['Game Chat'] = function(msg)
			local Sanitized = msg
			MessageQueue:Say(msg)
		end,
		['Team Chat'] = function(msg)
			MessageQueue:SayTeam(msg)
		end,
		['Console'] = function(...)
			print(...)
		end
	}

	CPLua.Header = ui.new_label('Lua', 'B', '=========  [   $CP Start   ]  =========')
	
	--#region Delayed Auto Accept
	if ( Feature.get('Delayed Auto Accept') ) then
		CPLua.AutoAccept = {}
		CPLua.AutoAccept.originalAutoAccept = ui.reference('MISC', 'Miscellaneous', 'Auto-accept matchmaking')
		CPLua.AutoAccept.enable = ui.new_checkbox('Lua', 'B', 'Delayed Auto Accept')
		CPLua.AutoAccept.delay = ui.new_slider('Lua', 'B', '\nAuto Accept Delay', 1, 21, 3, true, 's')

		ui.set_visible(CPLua.AutoAccept.delay, false)

		ui.set_callback(CPLua.AutoAccept.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.AutoAccept.delay, Status)
			
			if ( Status ) then
				ui.set(CPLua.AutoAccept.originalAutoAccept, not Status)
			end
		end)
		ui.set_callback(CPLua.AutoAccept.originalAutoAccept, function(self)
			if ( ui.get(self) ) then
				ui.set(CPLua.AutoAccept.enable, false)
			end
		end)

		local AutoAcceptReady
		panorama_events.register_event('ShowAcceptPopup', function(data)
			AutoAcceptReady = true
			-- print('ShowAcceptPopup')
		end)

		panorama_events.register_event('CloseAcceptPopup', function(data)
			AutoAcceptReady = false
			-- print('CloseAcceptPopup')
		end)

		panorama_events.register_event('PanoramaComponent_Lobby_ReadyUpForMatch', function(data)
			if ( ui.get(CPLua.AutoAccept.enable) ) then
				client.delay_call(ui.get(CPLua.AutoAccept.delay), function()
					LobbyAPI.SetLocalPlayerReady('accept')
				end)
			end
		end)
	end
	--#endregion

	--#region Delayed Connect
	if ( Feature.get('Delayed Connect') ) then
		CPLua.DelayedConnect = {}
		CPLua.DelayedConnect.enable = ui.new_checkbox('Lua', 'B', 'Delayed Connect')
		CPLua.DelayedConnect.delay = ui.new_slider('Lua', 'B', '\nDelayed Connect Delay', 30, 415, 120, true, 's')

		ui.set_visible(CPLua.DelayedConnect.delay, false)

		ui.set_callback(CPLua.DelayedConnect.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.DelayedConnect.delay, Status)
		end)

		client.set_event_callback('player_connect_full', function(e)
			if ( CPLua.DelayedConnect.once and client.userid_to_entindex(e.userid) == entity.get_local_player() and ui.get(CPLua.DelayedConnect.enable) and CompetitiveMatchAPI.HasOngoingMatch() ) then
				client.exec('disconnect')
				CPLua.DelayedConnect.once = false
				LobbyAPI.CloseSession()
			end

			if ( not CPLua.DelayedConnect.once ) then
				ReconnectBtn.reset()
			end
		end)

		panorama_events.register_event('ShowAcceptPopup', function(data)
			CPLua.DelayedConnect.FirstJoin = true
			CPLua.DelayedConnect.SecondJoin = false
			CPLua.DelayedConnect.once = true
		end)

		panorama_events.register_event('QueueConnectToServer', function(data)
			if ( not CPLua.DelayedConnect.FirstJoin and not CPLua.DelayedConnect.SecondJoin ) then
				CPLua.DelayedConnect.SecondJoin = true
			end

			if ( CPLua.DelayedConnect.FirstJoin and ui.get(CPLua.DelayedConnect.enable) and CompetitiveMatchAPI.HasOngoingMatch() ) then
				CPLua.DelayedConnect.FirstJoin = false
				CPLua.DelayedConnect.SecondJoin = false

				local Delay = ui.get(CPLua.DelayedConnect.delay)
				local index = 1

				function UpdateLoop()
					ReconnectBtn.set('RECONNECT (' .. Delay - index .. ')')
					index = index + 1

					if Delay - index == 0 and ui.get(CPLua.DelayedConnect.enable) and not GameStateAPI.IsConnectedOrConnectingToServer() then
						CPLua.DerankScore.Reconnect()
					end

					if ui.get(CPLua.DelayedConnect.enable) and Delay - index > 0 and not CPLua.DelayedConnect.SecondJoin then
						client.delay_call(1, UpdateLoop)
					else
						ReconnectBtn.set('RECONNECT')
					end
				end
				client.delay_call(1, UpdateLoop)	
			elseif ( not CPLua.DelayedConnect.FirstJoin ) then
				ReconnectBtn.set('RECONNECT')
			end
		end)
	end
	--#endregion

	--#region Auto Accept Detection
	if ( Feature.get('Auto Accept Detection') ) then
		CPLua.AutoAcceptDetection = {}
		CPLua.AutoAcceptDetection.enable = ui.new_checkbox('Lua', 'B', 'Auto Accept Detection')
		CPLua.AutoAcceptDetection.output = ui.new_multiselect('Lua', 'B', 'Output', {'Party Chat', 'On-screen', 'Console'})
		
		ui.set_visible(CPLua.AutoAcceptDetection.output, false)
		ui.set(CPLua.AutoAcceptDetection.output, {'Party Chat', 'Console'})

		ui.set_callback(CPLua.AutoAcceptDetection.enable, function(item)
			local Status = ui.get(item)
			ui.set_visible(CPLua.AutoAcceptDetection.output, Status)
		end)

		local Count = 1

		local function ResetCount()
			Count = 1
			-- print('reset count to 1')
		end

		panorama_events.register_event('ShowAcceptPopup', ResetCount)
		panorama_events.register_event('CloseAcceptPopup', ResetCount)
		panorama_events.register_event('QueueConnectToServer', ResetCount)

		local DrawPaintUI = false
		local PaintUI_Accepts = 0
		panorama_events.register_event('PanoramaComponent_Lobby_ReadyUpForMatch', function(shouldShow, playersReadyCount, numTotalClientsInReservation)
			-- print('[AUTODETECTION] shouldShow:', shouldShow, ' playersReadyCount:', playersReadyCount, ' numTotalClientsInReservation:', numTotalClientsInReservation)
			-- print('========================')
			-- print('count=', count)

			--CPLua.ChatMethods['Party Chat']('[CSMITDEBUG] shouldShow:' .. tostring(shouldShow) .. ' playersReadyCount:' .. playersReadyCount .. ' numTotalClientsInReservation:' .. numTotalClientsInReservation)
			if Count == 2 then
				if ui.get(CPLua.AutoAcceptDetection.enable) then
					-- print('Attempt accept')
					LobbyAPI.SetLocalPlayerReady('accept')
					for index, method in ipairs(ui.get(CPLua.AutoAcceptDetection.output)) do
						if method == 'Party Chat' then
							CPLua.ChatMethods['Party Chat']('[AUTOACCEPT] Detected ' .. playersReadyCount + 1 .. ' possible auto accepts!')
						end

						if method == 'On-screen' then
							DrawPaintUI = true
							PaintUI_Accepts = playersReadyCount + 1

							client.delay_call(15, function()
								DrawPaintUI = false
								PaintUI_Accepts = 0
							end)
						end

						if method == 'Console' then
							print('[AUTOACCEPT] Detected ' .. playersReadyCount + 1 .. ' possible auto accepts!')
						end
					end
				end
			end
			
			Count = Count + 1
			if not shouldShow then
				ResetCount()
			end
		end)

		client.set_event_callback('paint_ui', function()
			if DrawPaintUI and PaintUI_Accepts > 0 then
				local ScreenW, ScreenH = client.screen_size()
				renderer.text(ScreenW/2, ScreenH/2, 255, 0, 0, 255, '+c', 0, 'Total auto accepts: ' .. PaintUI_Accepts)
			end
		end)
	end
	--#endregion

	--#region Auto Derank Score
	if ( Feature.get('Auto Derank Score') ) then
		CPLua.DerankScore = {}
		CPLua.DerankScore.enable = ui.new_checkbox('Lua', 'B', 'Auto Derank Score')
		CPLua.DerankScore.delay = ui.new_slider('Lua', 'B', '\nAuto Derank Delay', 0, 15, 0, true, 's')
		CPLua.DerankScore.method = ui.new_multiselect('Lua', 'B', 'Method', {'Round Prestart', 'Round Start', 'During Timeout', 'Round End'})

		ui.set_visible(CPLua.DerankScore.method, false)
		ui.set_visible(CPLua.DerankScore.delay, false)

		ui.set_callback(CPLua.DerankScore.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.DerankScore.method, Status)
			ui.set_visible(CPLua.DerankScore.delay, Status)
		end)

		function CPLua.DerankScore.MethodState(Method)
			for index, value in ipairs(ui.get(CPLua.DerankScore.method)) do
				if ( value == Method ) then
					return true
				end
			end
			return Found
		end

		function CPLua.DerankScore.Reconnect()
			if CompetitiveMatchAPI.HasOngoingMatch() then
				client.delay_call(ui.get(CPLua.DerankScore.delay), function()
					client.exec('disconnect')
					CompetitiveMatchAPI.ActionReconnectToOngoingMatch()
				end)
			end
		end

		client.set_event_callback("round_start", function()
			if ui.get(CPLua.DerankScore.enable) and CPLua.DerankScore.MethodState('Round Prestart') then
				CPLua.DerankScore.Reconnect()
			end
		end)

		client.set_event_callback("round_end", function()
			if entity.is_alive(entity.get_local_player()) and ui.get(CPLua.DerankScore.enable) and CPLua.DerankScore.MethodState('Round End') then
				CPLua.DerankScore.Reconnect()
			end
		end)
	
		client.set_event_callback("round_freeze_end", function()
			if entity.is_alive(entity.get_local_player()) and ui.get(CPLua.DerankScore.enable) and CPLua.DerankScore.MethodState('Round Start') then
				CPLua.DerankScore.Reconnect()
			end
		end)

		CPLua.DerankScore.Deranking = false
		CPLua.loops[#CPLua.loops + 1] = function()
			if not CPLua.DerankScore.Deranking and ui.get(CPLua.DerankScore.enable) and CPLua.DerankScore.MethodState('During Timeout') and FriendsListAPI.IsGamePaused() and entity.is_alive(entity.get_local_player()) then
				local Team = (entity.get_prop(entity.get_game_rules(), "m_bCTTimeOutActive") == 1 and 'CT' or false) or (entity.get_prop(entity.get_game_rules(), "m_bTerroristTimeOutActive") == 1 and 'T' or false)
				local TimeoutRemaining = 0
				if ( Team == 'CT' ) then
					TimeoutRemaining = entity.get_prop(entity.get_game_rules(), "m_flCTTimeOutRemaining")
				elseif ( Team == 'T' ) then
					TimeoutRemaining = entity.get_prop(entity.get_game_rules(), "m_flTerroristTimeOutRemaining")
				end

				if ( TimeoutRemaining > 0) then
					CPLua.DerankScore.Deranking = true
					CPLua.DerankScore.Reconnect()
				end
			end
		end
		client.set_event_callback('player_connect_full', function(e)
			if ( entity.get_local_player() == client.userid_to_entindex(e.userid) ) then
				CPLua.DerankScore.Deranking = false
			end
		end)
	end
	--#endregion

	--#region Auto Open CsgoStats.gg
	if ( Feature.get('Auto Open CsgoStats.gg') ) then
		CPLua.AutoCSGOStats = {}
		CPLua.AutoCSGOStats.enable = ui.new_checkbox('Lua', 'B', 'Auto CSGOStats.gg')

		panorama_events.register_event('ShowAcceptPopup', function(data)
			CPLua.AutoCSGOStats.FirstJoin = true
			printDebug('==> I am watching now')
		end)
		panorama_events.register_event('QueueConnectToServer', function()
			printDebug('==> Queue Connect To Server', ui.get(CPLua.AutoCSGOStats.enable), CompetitiveMatchAPI.HasOngoingMatch() )
			if ( CPLua.AutoCSGOStats.FirstJoin and ui.get(CPLua.AutoCSGOStats.enable) and CompetitiveMatchAPI.HasOngoingMatch() ) then
				CPLua.AutoCSGOStats.FirstJoin = false
				SteamOverlayAPI.OpenExternalBrowserURL('https://csgostats.gg/player/' .. MyPersonaAPI.GetXuid() .. '#/live');
			end
		end)
	end
	--#endregion

	--#region Auto Invite Recents
	if ( Feature.get('Auto Invite Recents') ) then
		CPLua.InviteRecents = {}
		CPLua.InviteRecents.enable = ui.new_checkbox('Lua', 'B', 'Auto Invite Recents')
		CPLua.InviteRecents.autostart = ui.new_checkbox('Lua', 'B', 'Start Queue On Join')

		ui.set_visible(CPLua.InviteRecents.autostart, false)

		ui.set_callback(CPLua.InviteRecents.enable, function(status)
			printDebug(status)
			ui.set_visible(CPLua.InviteRecents.autostart, ui.get(CPLua.InviteRecents.enable))
		end)

		local GameMode = ''
		local refresh = false
		panorama_events.register_event('EndOfMatch_Shutdown', function(data)	
			GameMode = GameStateAPI.GetGameModeName(false)
			if ( GameMode and CompetitiveMatchAPI.HasOngoingMatch() ) then
				CPLua.InviteRecents.Reinvite = true
				CPLua.InviteRecents.SessionReady = false

				if ( not LobbyAPI.IsSessionActive() and ui.get(CPLua.InviteRecents.enable) ) then
					LobbyAPI.CreateSession()
					PartyListAPI.SessionCommand('MakeOnline', '')
					refresh = true
				end
			end
		end)

		panorama_events.register_event('PanoramaComponent_Lobby_MatchmakingSessionUpdate', function(state)
			if ( state == 'ready' and refresh ) then
				local settings = { update = { Game = { } } }
				local Config = GameTypesAPI.GetConfig()

				-- print(GameMode .. '<<<<' )
				if ( GameMode == 'Competitive' ) then
					settings.update.Game.mode = 'competitive'
					settings.update.Game.type = 'classic'
				elseif ( GameMode == 'Wingman' ) then
					settings.update.Game.mode = 'scrimcomp2v2'
					settings.update.Game.type = 'classic'
				end
				settings.update.Game.mapgroupname = Config.gameTypes[settings.update.Game.type].gameModes[settings.update.Game.mode].mapgroupsMP
				
				LobbyAPI.UpdateSessionSettings(settings)
				refresh = false

				TeammatesAPI.Refresh()
				CPLua.InviteRecents.SessionReady = true
			end
		end)

		panorama_events.register_event('PanoramaComponent_Teammates_Refresh', function()
			if ( not LobbyAPI.BIsHost() ) then return end

			panorama.loadstring([[
				let Recents = $.GetContextPanel().FindChildTraverse('JsFriendsList-recents').FindChild('JsFriendsList-List' );
				Recents.ScrollToBottom() 
				Recents.ScrollToTop()
			]], 'CSGOMainMenu')()

			CPLua.InviteRecents.InviteCount = GameMode == 'Competitive' and 3 or 0

			if ( CPLua.InviteRecents.Reinvite and CPLua.InviteRecents.SessionReady ) then
				if ( ui.get(CPLua.InviteRecents.enable) ) then
					for Index=0, CPLua.InviteRecents.InviteCount do
						local Teammate = TeammatesAPI.GetXuidByIndex(Index)
						FriendsListAPI.ActionInviteFriend(Teammate, '')
					end
				end
				CPLua.InviteRecents.Reinvite = false
			end
		end)

		panorama_events.register_event('PanoramaComponent_Lobby_PlayerJoined', function(steamid)
			if ( not LobbyAPI.BIsHost() ) then return end

			local numSlots = LobbyAPI.GetSessionSettings().members.numSlots
			local maxSlots = GameMode == 'Wingman' and 2 or 5

			if ( ui.get(CPLua.InviteRecents.enable) and ui.get(CPLua.InviteRecents.autostart) and PartyListAPI.GetCount() == maxSlots ) then				
				LobbyAPI.StartMatchmaking('', 'ct', 't', '')
			end
		end)
	end
	--#endregion

	--#region Match Start Beep
	if ( Feature.get('Match Start Beep') ) then
		CPLua.MatchStartBeep = {}
		CPLua.MatchStartBeep.enable = ui.new_checkbox('Lua', 'B', 'Match Start Beep')
		CPLua.MatchStartBeep.repeatTimes = ui.new_slider('Lua', 'B', 'Times (x)', 1, 30, 1)
		CPLua.MatchStartBeep.repeatInterval = ui.new_slider('Lua', 'B', 'Interval (ms)', 0, 1000, 250, true, 'ms')
		CPLua.MatchStartBeep.delay = ui.new_slider('Lua', 'B', '% of Match Freezetime', 0, 100, 75, true, '%')

		CPLua.MatchStartBeep.sounds = {
			{'popup_accept_match_beep', '* Default (Beep)'},
			{'PanoramaUI.Lobby.Joined', '* Lobby Joined'},
			{'PanoramaUI.Lobby.Left', '* Lobby Left'},
			{'popup_accept_match_waitquiet', '* Match Accept Tick'},
			{'popup_accept_match_person', '* Match Accept Person'},
			{'popup_accept_match_confirmed', '* Match Confirmed'},
			{'UIPanorama.generic_button_press', 'Generic Button'},
			{'mainmenu_press_home', 'Home Button'},
			{'tab_mainmenu_inventory', 'Inventory Tab'},
			{'tab_settings_settings', 'Settings Tab'},
			{'UIPanorama.mainmenu_press_quit', 'Quit Button'},
			{'sticker_applySticker', 'Sticker Apply'},
			{'sticker_nextPosition', 'Sticker Next Position'},
			{'container_sticker_ticker', 'Container Sticker Ticker'},
			{'container_weapon_ticker', 'Container Weapon Ticker'},
			{'container_countdown', 'Container Countdown'},
			{'inventory_inspect_sellOnMarket', 'Sell on Market'},
			{'UIPanorama.sidemenu_select', 'Sidemenu Select'},
			{'inventory_item_popupSelect', 'Item Popup'},
			{'UIPanorama.stats_reveal', 'Stats Reveal'},
			{'ItemRevealSingleLocalPlayer', 'Reveal Singleplayer'},
			{'ItemDropCommon', 'Item Drop (Common)'},
			{'ItemDropUncommon', 'Item Drop (Uncommon)'},
			{'ItemDropMythical', 'Item Drop (Mythical)'},
			{'ItemDropLegendary', 'Item Drop (Legendary)'},
			{'ItemDropAncient', 'Item Drop (Ancient)'},
			{'UIPanorama.XP.Ticker', 'XP Ticker'},
			{'UIPanorama.XP.BarFull', 'XP Bar Full'},
			{'UIPanorama.XP.NewRank', 'XP New Rank'},
			{'UIPanorama.XP.NewSkillGroup', 'New Skill Group'},
			{'UIPanorama.submenu_leveloptions_slidein', 'Map Vote SlideIn'},
			{'UIPanorama.submenu_leveloptions_select', 'Map Vote Select'},
			{'mainmenu_press_GO', 'Matchmaking Search'},
			{'buymenu_select', 'Buy Select'},
			{'UIPanorama.gameover_show', 'Gameover'},
			{'inventory_item_select', 'Inventory Select'},
			{'UIPanorama.inventory_new_item_accept', 'Inventory New Item'},
			{'sidemenu_slidein', 'Sidemenu Slidein'},
			{'sidemenu_slideout', 'Sidemenu Slideout'},
			{'UIPanorama.inventory_new_item', 'Inventory New Item'},
			{'inventory_inspect_weapon', 'Inventory Inspect Weapon'},
			{'inventory_inspect_knife', 'Inventory Inspect Knife'},
			{'inventory_inspect_sticker', 'Inventory Inspect Sticker'},
			{'inventory_inspect_graffiti', 'Inventory Inspect Graffiti'},
			{'inventory_inspect_musicKit', 'Inventory Inspect Music Kit'},
			{'inventory_inspect_coin', 'Inventory Inspect Coin'},
			{'inventory_inspect_gloves', 'Inventory Inspect Gloves'},
			{'inventory_inspect_close', 'Inventory Inspect Close'},
			{'XrayStart', 'XRay Start'},
			{'rename_purchaseSuccess', 'Nametag Success'},
			{'rename_select', 'Nametag Select'},
			{'rename_teletype', 'Nametag Teletype'},
			{'weapon_selectReplace', 'Weapon Select Replace'},
			{'UIPanorama.popup_newweapon', 'New Weapon Popup'}
		}
		local ProcessedSounds = {}
		local ReferenceSounds = {}
		for index, Sound in pairs(CPLua.MatchStartBeep.sounds) do
			ProcessedSounds[#ProcessedSounds + 1] = Sound[2]
			ReferenceSounds[Sound[2]] = Sound[1]
		end	
		CPLua.MatchStartBeep.sounds = ui.new_listbox('Lua', 'B', 'Sounds', ProcessedSounds)
		CPLua.MatchStartBeep.testsound = ui.new_button('Lua', 'B', 'Test Sound', function()
			local SelectedSound = ProcessedSounds[ui.get(CPLua.MatchStartBeep.sounds)+1]
			printDebug(SelectedSound, '>', ReferenceSounds[SelectedSound])
			if ( SelectedSound and SelectedSound ~= '' and ReferenceSounds[SelectedSound] ) then
				CPLua.MatchStartBeep.PlaySound()
			end
		end)

		ui.set_visible(CPLua.MatchStartBeep.delay, false)
		ui.set_visible(CPLua.MatchStartBeep.sounds, false)
		ui.set_visible(CPLua.MatchStartBeep.testsound, false)

		ui.set_visible(CPLua.MatchStartBeep.repeatTimes, false)
		ui.set_visible(CPLua.MatchStartBeep.repeatInterval, false)

		ui.set_callback(CPLua.MatchStartBeep.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.MatchStartBeep.delay, Status)
			ui.set_visible(CPLua.MatchStartBeep.sounds, Status)
			ui.set_visible(CPLua.MatchStartBeep.testsound, Status)

			ui.set_visible(CPLua.MatchStartBeep.repeatTimes, Status)
			ui.set_visible(CPLua.MatchStartBeep.repeatInterval, ui.get(CPLua.MatchStartBeep.repeatTimes) ~= 1 and Status)
		end)

		CPLua.MatchStartBeep.PlaySound = function()
			local SelectedSound = ProcessedSounds[ui.get(CPLua.MatchStartBeep.sounds)+1] or 'Default (Beep)'
			if ( SelectedSound and SelectedSound ~= '' and ReferenceSounds[SelectedSound] ) then
				local Times = ui.get(CPLua.MatchStartBeep.repeatTimes)
				local Interval = ui.get(CPLua.MatchStartBeep.repeatInterval)
				if ( Times == 1 ) then
					_.DispatchEvent( 'PlaySoundEffect', ReferenceSounds[SelectedSound], 'MOUSE');
				else
					for i=1, Times do
						client.delay_call(Times == 1 and 0 or ( ( i - 1 ) * Interval ) / 1000, function()
							printDebug('done')
							_.DispatchEvent( 'PlaySoundEffect', ReferenceSounds[SelectedSound], 'MOUSE')
						end)
					end
				end
			end
		end

		ui.set_callback(CPLua.MatchStartBeep.repeatTimes, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.MatchStartBeep.repeatInterval, Status ~= 1 and ui.get(CPLua.MatchStartBeep.enable))
		end)
		

		client.set_event_callback('round_start', function()
			if ( ui.get(CPLua.MatchStartBeep.enable) ) then
				local mp_freezetime = cvar.mp_freezetime:get_int()
				local percent = ui.get(CPLua.MatchStartBeep.delay) / 100
				client.delay_call(mp_freezetime * percent, function()
					CPLua.MatchStartBeep.PlaySound()
				end)
			end
		end)
	end
	--#endregion

	--#region Custom Clantag Builder
	if ( Feature.get('Custom Clantag Builder') ) then
		CPLua.Clantag = {}
		CPLua.Clantag.last = ''
		CPLua.Clantag.enable = ui.new_checkbox('Lua', 'B', 'Clantag Builder [BETA]')
		CPLua.Clantag.template = ui.new_textbox('Lua', 'B', '\nClantag Template')
		CPLua.Clantag.helper1 = ui.new_label('Lua', 'B', 'Helper: Type { or anything')
		CPLua.Clantag.helper2 = ui.new_label('Lua', 'B', '\n')
		CPLua.Clantag.helper3 = ui.new_label('Lua', 'B', '\n')
		CPLua.Clantag.helper4 = ui.new_label('Lua', 'B', '\n')
		CPLua.Clantag.helper5 = ui.new_label('Lua', 'B', '\n')

		CPLua.Clantag.processedData = {}

		CPLua.Clantag.data = {
			{'rank', 'competitive ranking', 300, function()
				local currentRank = entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveRanking', entity.get_local_player())
				if ( currentRank == 0 ) then return 'N/A' end

				if ( currentRank ) then
					local CurrentMode = GameStateAPI.GetGameModeInternalName(true)
					local RankLong = _.Localize(CurrentMode == 'survival' and '#skillgroup_'..currentRank..'dangerzone' or 'RankName_' .. currentRank)
					local RankName = getRankShortName(RankLong)

					return RankName
				end
			end, 0},
			{'wins', 'competitive wins', 300, function()
				return entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveWins', entity.get_local_player()) or ''
			end, 0},
			{'hp', 'current health', 0.5, function()
				return entity.get_prop(entity.get_local_player(), 'm_iHealth') or 0
			end, 0},
			{'amr', 'current armor', 0.5, function()
				return entity.get_prop(entity.get_local_player(), 'm_ArmorValue') or 0
			end, 0},
			{'loc', 'current location', 0.5, function()
				return _.Localize(entity.get_prop(entity.get_local_player(), 'm_szLastPlaceName')) or ''
			end, 0},
			{'kills', 'current kills', 1, function()
				return entity.get_prop(entity.get_player_resource(), 'm_iKills', entity.get_local_player()) or 0
			end, 0},
			{'deaths', 'current deaths', 1, function()
				return entity.get_prop(entity.get_player_resource(), 'm_iDeaths', entity.get_local_player()) or 0
			end, 0},
			{'assists', 'current assists', 1, function()
				return entity.get_prop(entity.get_player_resource(), 'm_iAssists', entity.get_local_player()) or 0
			end, 0},
			{'hschance', 'current headshot chance',  1, function()
				local LocalPlayer = entity.get_local_player()
				local TotalKills = CPLua.Clantag.processedData.kills
				local HeadshotKills = entity.get_prop(entity.get_player_resource(), 'm_iMatchStats_HeadShotKills_Total', entity.get_local_player())
				if ( TotalKills and HeadshotKills ) then				
					return math.ceil( (HeadshotKills / TotalKills) * 100 )
				end
			end, 0},
			{'c4', 'displays BOMB if carrying bomb', 1, function()
				CPLua.Clantag.last = '' -- TEMP
				
			end, 0},
			{'wep', 'current weapon name', 0.25, function()
				local LocalPlayer = entity.get_local_player()

				local WeaponENT = entity.get_player_weapon(LocalPlayer)
				if WeaponENT == nil then return end

				local WeaponIDX = entity.get_prop(WeaponENT, "m_iItemDefinitionIndex")
				if WeaponIDX == nil then return end

				local weapon = csgo_weapons[WeaponIDX]
				if weapon == nil then return end
				
				return weapon.name
			end, 0},
			{'ammo', 'current weapon ammo', 0.25, function()
				local LocalPlayer = entity.get_local_player()

				local WeaponENT = entity.get_player_weapon(LocalPlayer)
				if WeaponENT == nil then return end
				
				local Ammo = entity.get_prop(WeaponENT, "m_iClip1")
				if Ammo == nil then return end
				
				return Ammo
			end, 0},
			{'id', 'current steam id', 9999, function()
				return MyPersonaAPI.GetXuid()
			end, 0},
			{'bomb', 'bomb timer countdown', 1, function()
				local c4 = entity.get_all("CPlantedC4")[1]
				if c4 == nil or entity.get_prop(c4, "m_bBombDefused") == 1 or entity.get_local_player() == nil then return '' end
				local c4_time = entity.get_prop(c4, "m_flC4Blow") - globals.curtime()
				return c4_time ~= nil and c4_time > 0 and math.floor(c4_time) or ''
			end, 0},
			{'doa', 'displays DEAD or ALIVE', 0.5, function()
				return entity.is_alive(entity.get_local_player()) and 'ALIVE' or 'DEAD'
			end, 0},
			{'fps', 'current FPS', 0.05, function()
				return AccumulateFps()
			end, 0},
			{'ping', 'current ping', 0.5, function()
				return math.floor(client.latency()*1000)
			end, 0},
			{'date', 'current date (DD/MM/YY)', 300, function()
				local Data = Date(client.unix_time())
				local Day = string.format("%02d", Data.getDate())
				local Month = string.format("%02d", Data.getMonth()+1)
				return string.format('%s/%s/%s', Day, Month, tostring(Data.getFullYear()):sub(3,4))
			end, 0},
			{'shortday', 'current name of the day (Mon, Wed, Tue)', 300, function()
				local DaysOfWeek = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'}
				local Data = Date(client.unix_time())
				return DaysOfWeek[Data.getDay()+1]
			end, 0},
			{'longday', 'current name of the day (Monday, Wednesday, Tuesday)', 300, function()
				local DaysOfWeek = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'}
				local Data = Date(client.unix_time())
				return DaysOfWeek[Data.getDay()+1]
			end, 0},
			{'day', 'current day of the month', 300, function()
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getDate())
			end, 0},
			{'month', 'current month number', 300, function()
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getMonth()+1)
			end, 0},
			{'year', 'current year number', 300, function()
				local Data = Date(client.unix_time())
				return tostring(Data.getFullYear()):sub(3,4)
			end, 0},
			{'time12', 'current time in 12 hour time', 1, function()
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				local Suffix = Hours > 12 and 'PM' or 'AM'
				Hours = string.format("%02d", Hours > 12 and Hours - 12 or Hours)
				local Minutes = string.format("%02d", Data.getMinutes())
				local Seconds = string.format("%02d", Data.getSeconds())
				return string.format('%s:%s:%s %s', Hours, Minutes, Seconds, Suffix)
			end, 0},
			{'time24', 'current time in 24 hour time', 1, function()
				local Data = Date(client.unix_time())
				local Hours = string.format("%02d", Data.getHours())
				local Minutes = string.format("%02d", Data.getMinutes())
				local Seconds = string.format("%02d", Data.getSeconds())
				return string.format('%s:%s:%s', Hours, Minutes, Seconds)
			end, 0},
			{'hour12', 'hour in 12 hour time', 1, function()
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				return string.format("%02d", Hours > 12 and Hours - 12 or Hours)
			end, 0},
			{'hour24', 'hour in 24 hour time', 1, function()	
				local Data = Date(client.unix_time())
				return Data.getHours()
			end, 0},
			{'mins', 'current minutes in system time', 1, function()
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getMinutes())
			end, 0},
			{'secs', 'current seconds in system time', 1, function()
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getSeconds())
			end, 0},
			{'timesuffix', '12 hour time suffix', 1, function()
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				return Hours > 12 and 'PM' or 'AM'
			end, 0}
		}
		
		ui.set_visible(CPLua.Clantag.template, false)
		ui.set_visible(CPLua.Clantag.helper1, false)
		ui.set_visible(CPLua.Clantag.helper2, false)
		ui.set_visible(CPLua.Clantag.helper3, false)
		ui.set_visible(CPLua.Clantag.helper4, false)
		ui.set_visible(CPLua.Clantag.helper5, false)

		local configLoading = false
		client.set_event_callback('pre_config_load', function()
			configLoading = true
		end)
		
		client.set_event_callback('post_config_load', function()
			configLoading = false
		end)
		

		ui.set_callback(CPLua.Clantag.enable, function(self)
			local Status = ui.get(self)
			if ( not Status and not configLoading ) then
				client.set_clan_tag('\0')
				-- print('fuck')
			end

			CPLua.Clantag.last = ''
			ui.set_visible(CPLua.Clantag.template, Status)
			ui.set(CPLua.Clantag.helper1, 'Helper: type { to get suggestions')
			ui.set_visible(CPLua.Clantag.helper1, Status)
			ui.set_visible(CPLua.Clantag.helper2, false)
			ui.set_visible(CPLua.Clantag.helper3, false)
			ui.set_visible(CPLua.Clantag.helper4, false)
			ui.set_visible(CPLua.Clantag.helper5, false)
		end)

		-- Helper Code
		local LastTemplateText = ui.get(CPLua.Clantag.template)
		client.set_event_callback('post_render', function()
			local TemplateText = ui.get(CPLua.Clantag.template)
			if ( TemplateText ~= LastTemplateText ) then
				LastTemplateText = TemplateText
				local Match = TemplateText:match('{(%a*%d*)$')
				if ( Match ) then
					local FoundMatch = false
					if ( Match:len() > 0 ) then
						for i, v in ipairs(CPLua.Clantag.data) do
							if ( v[1]:sub(1, Match:len()) == Match:lower() ) then
								FoundMatch = v
								break;
							end
						end
						if ( FoundMatch ) then
							ui.set(CPLua.Clantag.helper1, '{' .. FoundMatch[1] .. '} - ' .. FoundMatch[2])
						else
							ui.set(CPLua.Clantag.helper1, 'no matches found for {' .. Match .. '}' )
						end		
						ui.set_visible(CPLua.Clantag.helper2, false)
						ui.set_visible(CPLua.Clantag.helper3, false)
						ui.set_visible(CPLua.Clantag.helper4, false)
						ui.set_visible(CPLua.Clantag.helper5, false)
					else
						local HelperCMDS = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {},
						}
						local cmds = {}
						for i, v in ipairs(CPLua.Clantag.data) do
							cmds[#cmds + 1] = v[1]
						end						
						-- I'm going to do some proper maths for this at a later date.
						for i=1, 7 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper1[#HelperCMDS.helper1 + 1] = cmd
							end
						end
						for i=8, 14 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper2[#HelperCMDS.helper2 + 1] = cmd
							end
						end
						for i=15, 21 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper3[#HelperCMDS.helper3 + 1] = cmd
							end
						end
						for i=22, 28 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper4[#HelperCMDS.helper4 + 1] = cmd
							end
						end
						for i=29, 35 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper5[#HelperCMDS.helper5 + 1] = cmd
							end
						end
						
						ui.set(CPLua.Clantag.helper1, table.concat(HelperCMDS.helper1, ', ') )
						ui.set(CPLua.Clantag.helper2, table.concat(HelperCMDS.helper2, ', ') )
						ui.set(CPLua.Clantag.helper3, table.concat(HelperCMDS.helper3, ', ') )
						ui.set(CPLua.Clantag.helper4, table.concat(HelperCMDS.helper4, ', ') )
						ui.set(CPLua.Clantag.helper5, table.concat(HelperCMDS.helper5, ', ') )

						ui.set_visible(CPLua.Clantag.helper1, #HelperCMDS.helper1 > 0)
						ui.set_visible(CPLua.Clantag.helper2, #HelperCMDS.helper2 > 0)
						ui.set_visible(CPLua.Clantag.helper3, #HelperCMDS.helper3 > 0)
						ui.set_visible(CPLua.Clantag.helper4, #HelperCMDS.helper4 > 0)
						ui.set_visible(CPLua.Clantag.helper5, #HelperCMDS.helper5 > 0)
					end
				else
					ui.set(CPLua.Clantag.helper1, 'Helper: ' .. TemplateText .. '_')
					ui.set_visible(CPLua.Clantag.helper2, false)
					ui.set_visible(CPLua.Clantag.helper3, false)
					ui.set_visible(CPLua.Clantag.helper4, false)
					ui.set_visible(CPLua.Clantag.helper5, false)
				end
			end
		end)

		CPLua.loops[#CPLua.loops + 1] = function()
			if ( not ui.get(CPLua.Clantag.enable) ) then return end
			if ( not entity.get_local_player() ) then return end

			-- DATA CALCULATIONS
			for index, value in ipairs(CPLua.Clantag.data) do
				local tag = value[1]
				local desc = value[2]
				local delay = value[3]
				local callfunc = value[4]
				
				if ( globals.curtime() > value[5] ) then
					local Output = callfunc()
					if ( Output == nil ) then
						CPLua.Clantag.processedData[tag] = ''
					elseif ( Output ) then
						CPLua.Clantag.processedData[tag] = Output
					end
					value[5] = globals.curtime() + delay
				end
			end
			
			local newClantag = processTags(ui.get(CPLua.Clantag.template), CPLua.Clantag.processedData)
			if ( CPLua.Clantag.last ~= newClantag and newClantag ~= '' ) then
				client.set_clan_tag(newClantag)
				CPLua.Clantag.last = newClantag
			end
		end

		client.set_event_callback('player_connect_full', function()
			CPLua.Clantag.last = ''
			for index, value in ipairs(CPLua.Clantag.data) do
				value[5] = 0
			end
		end)
		client.set_event_callback('round_start', function()
			CPLua.Clantag.last = ''
		end)
	end
	--#endregion

	--#region Custom Killsay Builder
	if ( Feature.get('Custom Killsay Builder') ) then
		CPLua.CustomKillSay = {}
		CPLua.CustomKillSay.enable = ui.new_checkbox('Lua', 'B', 'Killsay Builder [BETA]')
		CPLua.CustomKillSay.template = ui.new_textbox('Lua', 'B', '\nKillsay Template')
		CPLua.CustomKillSay.helper1 = ui.new_label('Lua', 'B', 'Helper: type { to get suggestions')
		CPLua.CustomKillSay.helper2 = ui.new_label('Lua', 'B', '\n')
		CPLua.CustomKillSay.helper3 = ui.new_label('Lua', 'B', '\n')
		CPLua.CustomKillSay.helper4 = ui.new_label('Lua', 'B', '\n')
		CPLua.CustomKillSay.helper5 = ui.new_label('Lua', 'B', '\n')
		CPLua.CustomKillSay.helper6 = ui.new_label('Lua', 'B', '\n')
		CPLua.CustomKillSay.helper7 = ui.new_label('Lua', 'B', '\n')

		CPLua.CustomKillSay.processedData = {}

		ui.set_visible(CPLua.CustomKillSay.template, false)
		ui.set_visible(CPLua.CustomKillSay.helper1, false)
		ui.set_visible(CPLua.CustomKillSay.helper2, false)
		ui.set_visible(CPLua.CustomKillSay.helper3, false)
		ui.set_visible(CPLua.CustomKillSay.helper4, false)
		ui.set_visible(CPLua.CustomKillSay.helper5, false)
		ui.set_visible(CPLua.CustomKillSay.helper6, false)
		ui.set_visible(CPLua.CustomKillSay.helper7, false)

		ui.set_callback(CPLua.CustomKillSay.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.CustomKillSay.template, Status)
			ui.set(CPLua.CustomKillSay.helper1, 'Helper: type { to get suggestions')
			ui.set_visible(CPLua.CustomKillSay.helper1, Status)
			ui.set_visible(CPLua.CustomKillSay.helper2, false)
			ui.set_visible(CPLua.CustomKillSay.helper3, false)
			ui.set_visible(CPLua.CustomKillSay.helper4, false)
			ui.set_visible(CPLua.CustomKillSay.helper5, false)
			ui.set_visible(CPLua.CustomKillSay.helper6, false)
			ui.set_visible(CPLua.CustomKillSay.helper7, false)
		end)

		-- Helper Code
		local helperData = {
			{'vname', 'victims kills', function(victim, attacker)
				return entity.get_player_name(victim)
			end},
			{'myname', 'victims kills', function(victim, attacker)
				return entity.get_player_name(attacker)
			end},
			{'vuserid', 'victims userid', function(victim, attacker, victimuserid, attackeruserid)
				return victimuserid
			end},
			{'myuserid', 'my userid', function(victim, attacker, victimuserid, attackeruserid)
				return attackeruserid
			end},
			{'ventid', 'victims entity id', function(victim, attacker, victimuserid, attackeruserid)
				return victim
			end},
			{'myentid', 'victims entity id', function(victim, attacker, victimuserid, attackeruserid)
				return attacker
			end},
			{'myname', 'victims kills', function(victim, attacker)
				return entity.get_player_name(attacker)
			end},
			{'vdeaths', 'victims deaths', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iDeaths', victim) + 1 or 0
			end},
			{'vkills', 'victims kills', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iKills', victim) or 0
			end},
			{'vassists', 'victims assists', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iAssists', victim) or 0
			end},
			{'mykills', 'my kills', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iKills', entity.get_local_player()) or 0
			end},
			{'mydeaths', 'my kills', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iDeaths', entity.get_local_player()) or 0
			end},
			{'myassists', 'my kills', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iAssists', entity.get_local_player()) or 0
			end},
			{'vrank', 'victims competitive ranking', function(victim, attacker)
				local currentRank = entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveRanking', victim)
				if ( currentRank == 0 ) then return 'N/A' end

				if ( currentRank ) then
					local CurrentMode = GameStateAPI.GetGameModeInternalName(true)
					local RankLong = _.Localize(CurrentMode == 'survival' and '#skillgroup_'..currentRank..'dangerzone' or 'RankName_' .. currentRank)
					local RankName = getRankShortName(RankLong)

					return RankName
				end
			end},
			{'myrank', 'my competitive ranking', function(victim, attacker)
				local currentRank = entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveRanking', entity.get_local_player())
				if ( currentRank == 0 ) then return 'N/A' end

				if ( currentRank ) then
					local CurrentMode = GameStateAPI.GetGameModeInternalName(true)
					local RankLong = _.Localize(CurrentMode == 'survival' and '#skillgroup_'..currentRank..'dangerzone' or 'RankName_' .. currentRank)
					local RankName = getRankShortName(RankLong)

					return RankName
				end
			end},
			{'vwins', 'victims competitive wins', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveWins', victim) or ''
			end},
			{'mywins', 'my competitive wins', function(victim, attacker)
				return entity.get_prop(entity.get_player_resource(), 'm_iCompetitiveWins', entity.get_local_player()) or ''
			end},
			{'vhp', 'my current health', function(victim, attacker)
				return entity.get_prop(victim, 'm_iHealth') or 0
			end},
			{'myhp', 'my current health', function(victim, attacker)
				return entity.get_prop(entity.get_local_player(), 'm_iHealth') or 0
			end},
			{'vamr', 'victim current armor', function(victim, attacker)
				return entity.get_prop(victim, 'm_ArmorValue') or 0
			end},
			{'myamr', 'current armor', function(victim, attacker)
				return entity.get_prop(entity.get_local_player(), 'm_ArmorValue') or 0
			end},
			{'vloc', 'victim current location', function(victim, attacker)
				return _.Localize(entity.get_prop(victim, 'm_szLastPlaceName')) or ''
			end},
			{'myloc', 'current location', function(victim, attacker)
				return _.Localize(entity.get_prop(entity.get_local_player(), 'm_szLastPlaceName')) or ''
			end},
			{'vheadchance', 'victim current headshot chance', function(victim, attacker)
				local TotalKills = entity.get_prop(entity.get_player_resource(), 'm_iKills', victim) or 0
				local HeadshotKills = entity.get_prop(entity.get_player_resource(), 'm_iMatchStats_HeadShotKills_Total', victim) or 0
				if ( TotalKills and HeadshotKills ) then				
					return math.ceil( (HeadshotKills / TotalKills) * 100 )
				end
			end},
			{'myheadchance', 'current headshot chance', function(victim, attacker)
				local TotalKills = entity.get_prop(entity.get_player_resource(), 'm_iKills', entity.get_local_player()) or 0
				local HeadshotKills = entity.get_prop(entity.get_player_resource(), 'm_iMatchStats_HeadShotKills_Total', entity.get_local_player())
				if ( TotalKills and HeadshotKills ) then				
					return math.ceil( (HeadshotKills / TotalKills) * 100 )
				end
			end},
			{'mywep', 'current weapon name', function(victim, attacker)
				local LocalPlayer = entity.get_local_player()

				local WeaponENT = entity.get_player_weapon(LocalPlayer)
				if WeaponENT == nil then return end

				local WeaponIDX = entity.get_prop(WeaponENT, "m_iItemDefinitionIndex")
				if WeaponIDX == nil then return end

				local weapon = csgo_weapons[WeaponIDX]
				if weapon == nil then return end
				
				return weapon.name
			end},
			{'vwep', 'current weapon name', function(victim, attacker)
				local Weapon = CPLua.CustomKillSay.vwep[victim]

				-- print(2, Weapon)

				local WeaponIDX = entity.get_prop(Weapon, "m_iItemDefinitionIndex")
				if WeaponIDX == nil then return end

				local weapon = csgo_weapons[WeaponIDX]
				if weapon == nil then return end
				
				return weapon.name
			end},
			{'ammo', 'current weapon ammo', function(victim, attacker)
				local LocalPlayer = entity.get_local_player()

				local WeaponENT = entity.get_player_weapon(LocalPlayer)
				if WeaponENT == nil then return end
				
				local Ammo = entity.get_prop(WeaponENT, "m_iClip1")
				if Ammo == nil then return end
				
				return Ammo
			end},
			{'vsteam64', 'victim steam id', function(victim, attacker)
				return GameStateAPI.GetPlayerXuidStringFromEntIndex(victim)
			end},
			{'mysteam64', 'my steam id', function(victim, attacker)
				return MyPersonaAPI.GetXuid()
			end},
			{'bomb', 'bomb timer countdown', function(victim, attacker)
				local c4 = entity.get_all("CPlantedC4")[1]
				if c4 == nil or entity.get_prop(c4, "m_bBombDefused") == 1 or entity.get_local_player() == nil then return '' end
				local c4_time = entity.get_prop(c4, "m_flC4Blow") - globals.curtime()
				return c4_time ~= nil and c4_time > 0 and math.floor(c4_time) or ''
			end},
			{'doa', 'displays DEAD or ALIVE', function(victim, attacker)
				return entity.is_alive(entity.get_local_player()) and 'ALIVE' or 'DEAD'
			end},
			{'ping', 'current ping', function(victim, attacker)
				return math.floor(client.latency()*1000)
			end},
			{'date', 'current date (DD/MM/YY)', function(victim, attacker)
				local Data = Date(client.unix_time())
				local Day = string.format("%02d", Data.getDate())
				local Month = string.format("%02d", Data.getMonth()+1)
				return string.format('%s/%s/%s', Day, Month, tostring(Data.getFullYear()):sub(3,4))
			end},
			{'shortday', 'current name of the day (Mon, Wed, Tue)', function(victim, attacker)
				local DaysOfWeek = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'}
				local Data = Date(client.unix_time())
				return DaysOfWeek[Data.getDay()+1]
			end},
			{'longday', 'current name of the day (Monday, Wednesday, Tuesday)', function(victim, attacker)
				local DaysOfWeek = {'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'}
				local Data = Date(client.unix_time())
				return DaysOfWeek[Data.getDay()+1]
			end},
			{'day', 'current day of the month', function(victim, attacker)
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getDate())
			end},
			{'month', 'current month number', function(victim, attacker)
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getMonth()+1)
			end},
			{'year', 'current year number', function(victim, attacker)
				local Data = Date(client.unix_time())
				return tostring(Data.getFullYear()):sub(3,4)
			end},
			{'time12', 'current time in 12 hour time', function(victim, attacker)
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				local Suffix = Hours > 12 and 'PM' or 'AM'
				Hours = string.format("%02d", Hours > 12 and Hours - 12 or Hours)
				local Minutes = string.format("%02d", Data.getMinutes())
				local Seconds = string.format("%02d", Data.getSeconds())
				return string.format('%s:%s:%s %s', Hours, Minutes, Seconds, Suffix)
			end},
			{'time24', 'current time in 24 hour time', function(victim, attacker)
				local Data = Date(client.unix_time())
				local Hours = string.format("%02d", Data.getHours())
				local Minutes = string.format("%02d", Data.getMinutes())
				local Seconds = string.format("%02d", Data.getSeconds())
				return string.format('%s:%s:%s', Hours, Minutes, Seconds)
			end},
			{'hour12', 'hour in 12 hour time', function(victim, attacker)
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				return string.format("%02d", Hours > 12 and Hours - 12 or Hours)
			end},
			{'hour24', 'hour in 24 hour time', function(victim, attacker)	
				local Data = Date(client.unix_time())
				return Data.getHours()
			end},
			{'mins', 'current minutes in system time', function(victim, attacker)
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getMinutes())
			end},
			{'secs', 'current seconds in system time', function(victim, attacker)
				local Data = Date(client.unix_time())
				return string.format("%02d", Data.getSeconds())
			end},
			{'timesuffix', '12 hour time suffix', function(victim, attacker)
				local Data = Date(client.unix_time())
				local Hours = Data.getHours()
				return Hours > 12 and 'PM' or 'AM'
			end}
		}

		-- vwep calculation
		CPLua.CustomKillSay.vwep = {}
		client.set_event_callback('run_command', function()
			for Player=1, globals.maxplayers() do
				local m_hActiveWeapon = entity.get_prop(Player, 'm_hActiveWeapon')
				if ( m_hActiveWeapon ) then
					CPLua.CustomKillSay.vwep[Player] = m_hActiveWeapon
				end
			end
		end)

		local LastKillsayText = ui.get(CPLua.CustomKillSay.template)
		client.set_event_callback('post_render', function()
			local TemplateText = ui.get(CPLua.CustomKillSay.template)
			if ( TemplateText ~= LastKillsayText ) then
				LastKillsayText = TemplateText
				local Match = TemplateText:match('{(%a*%d*)$')
				if ( Match ) then
					local FoundMatch = false
					if ( Match:len() > 0 ) then
						for i, v in ipairs(helperData) do
							if ( v[1]:sub(1, Match:len()) == Match:lower() ) then
								FoundMatch = v
								break;
							end
						end
						if ( FoundMatch ) then
							ui.set(CPLua.CustomKillSay.helper1, '{' .. FoundMatch[1] .. '} - ' .. FoundMatch[2])
						else
							ui.set(CPLua.CustomKillSay.helper1, 'no matches found for {' .. Match .. '}' )
						end
						ui.set_visible(CPLua.CustomKillSay.helper2, false)
						ui.set_visible(CPLua.CustomKillSay.helper3, false)
						ui.set_visible(CPLua.CustomKillSay.helper4, false)
						ui.set_visible(CPLua.CustomKillSay.helper5, false)
						ui.set_visible(CPLua.CustomKillSay.helper6, false)
						ui.set_visible(CPLua.CustomKillSay.helper7, false)
					else
						local HelperCMDS = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {},
							helper6 = {},
							helper7 = {},
						}
						local cmds = {}
						for i, v in ipairs(helperData) do
							cmds[#cmds + 1] = v[1]
						end
					
						-- I'm going to do some proper maths for this at a later date.
						for i=1, 7 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper1[#HelperCMDS.helper1 + 1] = cmd
							end
						end
						for i=8, 14 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper2[#HelperCMDS.helper2 + 1] = cmd
							end
						end
						for i=15, 21 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper3[#HelperCMDS.helper3 + 1] = cmd
							end
						end
						for i=22, 28 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper4[#HelperCMDS.helper4 + 1] = cmd
							end
						end
						for i=29, 35 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper5[#HelperCMDS.helper5 + 1] = cmd
							end
						end
						for i=36, 42 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper6[#HelperCMDS.helper6 + 1] = cmd
							end
						end
						for i=43, 49 do
							local cmd = cmds[i]
							if cmd then
								HelperCMDS.helper7[#HelperCMDS.helper7 + 1] = cmd
							end
						end
						
						ui.set(CPLua.CustomKillSay.helper1, table.concat(HelperCMDS.helper1, ', ') )
						ui.set(CPLua.CustomKillSay.helper2, table.concat(HelperCMDS.helper2, ', ') )
						ui.set(CPLua.CustomKillSay.helper3, table.concat(HelperCMDS.helper3, ', ') )
						ui.set(CPLua.CustomKillSay.helper4, table.concat(HelperCMDS.helper4, ', ') )
						ui.set(CPLua.CustomKillSay.helper5, table.concat(HelperCMDS.helper5, ', ') )
						ui.set(CPLua.CustomKillSay.helper6, table.concat(HelperCMDS.helper6, ', ') )
						ui.set(CPLua.CustomKillSay.helper7, table.concat(HelperCMDS.helper7, ', ') )

						ui.set_visible(CPLua.CustomKillSay.helper1, #HelperCMDS.helper1 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper2, #HelperCMDS.helper2 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper3, #HelperCMDS.helper3 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper4, #HelperCMDS.helper4 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper5, #HelperCMDS.helper5 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper6, #HelperCMDS.helper6 > 0)
						ui.set_visible(CPLua.CustomKillSay.helper7, #HelperCMDS.helper7 > 0)
					end
				else
					ui.set(CPLua.CustomKillSay.helper1, 'Helper: ' .. TemplateText)
					ui.set_visible(CPLua.CustomKillSay.helper2, false)
					ui.set_visible(CPLua.CustomKillSay.helper3, false)
					ui.set_visible(CPLua.CustomKillSay.helper4, false)
					ui.set_visible(CPLua.CustomKillSay.helper5, false)
					ui.set_visible(CPLua.CustomKillSay.helper6, false)
					ui.set_visible(CPLua.CustomKillSay.helper7, false)
				end
			end
		end)

		client.set_event_callback('player_death', function(e)
			if not ui.get(CPLua.CustomKillSay.enable) then return end

			local LocalPlayer = entity.get_local_player()
			local Attacker = client.userid_to_entindex(e.attacker)
			local Victim = client.userid_to_entindex(e.userid)
			if ( Attacker == LocalPlayer and Attacker ~= Victim ) then
				local ProcessedData = {}
				for i, v in ipairs(helperData) do
					local key = v[1]
					local title = v[2]
					local func = v[3]

					ProcessedData[key] = func(Victim, Attacker, e.userid, e.attacker)
				end
				local Processed = processTags(ui.get(CPLua.CustomKillSay.template), ProcessedData)
				--CPLua.ChatMethods['Game Chat'](Processed)
				MessageQueue:Say(Processed)
			end
		end)
	end
	--#endregion

	--#region Report Enemy Tool
	if ( Feature.get('Report Enemy Tool') ) then
		CPLua.ReportTool = {}
		CPLua.ReportTool.enable = ui.new_checkbox('Lua', 'B', 'Report Tool')
		CPLua.ReportTool.hotkey = ui.new_hotkey('Lua', 'B', 'Report Tool', true)
		
		local ReportTypes = {
			{'textabuse', 'Comms Abuse'},
			{'voiceabuse', 'Voice Abuse'},
			{'grief', 'Griefing'},
			{'aimbot', 'Aim Hacking'},
			{'wallhack', 'Wall Hacking'},
			{'speedhack', 'Other Hacking'}
		}
		local ReportTypeNames = {}
		local ReportTypeRef = {}
		for index, ReportType in ipairs(ReportTypes) do
			ReportTypeNames[#ReportTypeNames + 1] = ReportType[2]
			ReportTypeRef[ReportType[2]] = ReportType[1]
		end
		CPLua.ReportTool.types = ui.new_multiselect('Lua', 'B', 'Types', ReportTypeNames)
		ui.set(CPLua.ReportTool.types, {'Aim Hacking', 'Wall Hacking', 'Other Hacking'})

		local ReportingActive
		local function ReportNoobs()
			if ( ReportingActive or not ui.get(CPLua.ReportTool.enable) ) then return end
			local Types = ui.get(CPLua.ReportTool.types)
			local ReportTypes = ''
			for i, v in pairs(Types) do
				ReportTypes = ( i == 1 and ReportTypeRef[v] or ReportTypes..','..ReportTypeRef[v] )
			end

			local ReportQueue = {}
			for Player=1, globals.maxplayers() do
				local SteamXUID = GameStateAPI.GetPlayerXuidStringFromEntIndex(Player)
				if ( SteamXUID:len() > 5 and entity.is_enemy(Player) ) then
					ReportQueue[#ReportQueue + 1] = SteamXUID
				end
			end

			-- Actual Reporting
			for index, Reportee in ipairs(ReportQueue) do
				ReportingActive = true
				client.delay_call((index - 1) * 1, function()
					GameStateAPI.SubmitPlayerReport(Reportee, ReportTypes)
					if ( index == #ReportQueue ) then
						client.delay_call(1, function()
							ReportingActive = false
						end)
					end
				end)
			end
		end
		
		client.set_event_callback('net_update_end', function()
			local KeyState, Key = ui.get(CPLua.ReportTool.hotkey)
			if ( KeyState and not ui.is_menu_open() ) then
				ReportNoobs()
			end
		end)


		CPLua.ReportTool.submit = ui.new_button('Lua', 'B', 'Report!', ReportNoobs)

		ui.set_callback(CPLua.ReportTool.enable, function(self)
			local Status = ui.get(self)
			ui.set_visible(CPLua.ReportTool.types, Status)
			ui.set_visible(CPLua.ReportTool.submit, Status)
		end)
		ui.set_visible(CPLua.ReportTool.types, false)
		ui.set_visible(CPLua.ReportTool.submit, false)
	end
	--#endregion

	--#region Checkers
	if ( Feature.get('Account Checkers') ) then

		--#region Main Checker Code
		local Checkers = { registered = {} }

		function Checkers.new(checkerName, checkerDescription, checkerCallback)
			local mt = {}
			mt.name = checkerName
			mt.desc = checkerDescription
			mt.callback = checkerCallback
			mt.cache = {}

			function mt:start()

			end

			function mt:stop()

			end

			function mt:isRunning()

			end

			Checkers.registered[#Checkers.registered + 1] = mt

			return mt
		end

		local CheckStatus = false

		function Checkers._StartBTN()
			if ( CheckStatus ) then return end
			CheckStatus = true

			local Type = ui.get(Checkers.type)
			local TypeMT, InLobby

			for i, RegisteredItem in ipairs(Checkers.registered) do
				if ( RegisteredItem.name == Type ) then
					TypeMT = RegisteredItem
				end
			end

			if ( TypeMT ) then
				-- Target Acquisition
				local Target = ui.get(Checkers.target)
				local Targets = {}
				if ( GameStateAPI.IsConnectedOrConnectingToServer() ) then
					for Player=1, globals.maxplayers() do
						local LocalXUID = GameStateAPI.GetLocalPlayerXuid()
						local SteamXUID = GameStateAPI.GetPlayerXuidStringFromEntIndex(Player)
						local IsEnemy = GameStateAPI.ArePlayersEnemies(LocalXUID, SteamXUID)
						if ( SteamXUID and SteamXUID:len() == 17 ) then
							if ( ( Target == 'Everyone' ) or (Target == 'Teammates' and not IsEnemy) or (Target == 'Enemies' and IsEnemy) ) then
								Targets[#Targets + 1] = {SteamXUID, entity.get_player_name(Player)}
							end
						end
					end
				elseif ( LobbyAPI.IsSessionActive() ) then
					IsLobby = true
					for index=0, PartyListAPI.GetCount()-1 do
						local SteamXUID = PartyListAPI.GetXuidByIndex(index)
						Targets[#Targets + 1] = {SteamXUID, PartyListAPI.GetFriendName(SteamXUID)}
					end
				end

				if #Targets > 0 then
					ui.set(Checkers.status, 'Status: Checking 0/' .. #Targets .. '!')

					local CurrentTarget = 1

					function DispatchMessageOut(TargetSteamID, Target, Targets)
						ui.set(Checkers.status, 'Status: Checking ' .. Target .. '/' .. #Targets .. '!')

						local data = TypeMT.cache[TargetSteamID]
						if ( data ) then
							if ( GameStateAPI.IsConnectedOrConnectingToServer() ) then
								local Output = ui.get(Checkers.output)
								local Msg = data.server
								
								if ( data.localchat and not data.server ) then
									Msg = data.localchat
									Output = 'Local Chat'
								end

								CPLua.ChatMethods[Output](Msg)
							elseif ( data.lobby and LobbyAPI.IsSessionActive() ) then
								local Output = ui.get(Checkers.output)
								if ( Output ~= 'Console' ) then
									Output = 'Party Chat'
								end
								CPLua.ChatMethods[Output](TypeMT.cache[TargetSteamID].lobby)
							end
						end

						if ( Target == #Targets ) then
							-- Finished
							CheckStatus = false
							ui.set(Checkers.status, 'Status: Finished ' .. Target .. '/' .. #Targets .. '!')
						end
					end

					function CheckTarget(Target)
						if ( Targets[Target] ) then
							local TargetSteamID = Targets[Target][1]
							local TargetName = Targets[Target][2]
							if ( TypeMT.cache[TargetSteamID] ) then
								DispatchMessageOut(TargetSteamID, Target, Targets)
								CurrentTarget = CurrentTarget + 1
								CheckTarget(CurrentTarget)
							else
								TypeMT.callback(TargetSteamID, TargetName, function(data)							

									if ( data ) then
										TypeMT.cache[TargetSteamID] = TypeMT.cache[TargetSteamID] or {}

										TypeMT.cache[TargetSteamID].server = data.server and '[' .. TypeMT.name .. '] ' .. data.server
										TypeMT.cache[TargetSteamID].localchat = data.localchat and ' \x07[' .. TypeMT.name .. '] \x0A' .. data.localchat
										TypeMT.cache[TargetSteamID].lobby = data.lobby and '[' .. TypeMT.desc .. '] ' .. data.lobby
									end
									
									DispatchMessageOut(TargetSteamID, Target, Targets)

									CurrentTarget = CurrentTarget + 1
									CheckTarget(CurrentTarget)
								end, function(msg)
									if ( msg ) then
										if ( GameStateAPI.IsConnectedOrConnectingToServer() ) then
											local Output = ui.get(Checkers.output)
											CPLua.ChatMethods[Output](msg)
										elseif ( LobbyAPI.IsSessionActive() ) then
											CPLua.ChatMethods['Party Chat'](msg)
										end
									end
									CheckTarget(CurrentTarget)
								end, TypeMT)
							end
						end
					end
				
					CheckTarget(CurrentTarget)
				end
			end
		end
		--#endregion
		
		--#region Checker Definitions

		--#region Lolz.Guru Checker
		if ( Feature.get('Crack Checker') ) then
			local function check_lolzteam_impl(steamid, callback)
				if lolz_data == nil then
					lolz_data = LolzPanorama.get_data()

					if lolz_data ~= nil then
						lolz_data = json.parse(tostring(lolz_data))
					else
						client.delay_call(0.1, check_lolzteam_impl, steamid, callback)
						return
					end
				end

				if lolz_data ~= nil then
					local params = {
						user_id = "",
						category_id = "1",
						title = steamid,
						_itemCount = "1",
						_formSubmitted = "true",
						order_by = "pdate_to_down",
						_xfRequestUri = "/market/steam/",
						_xfNoRedirect = "1",
						_xfResponseType = "json",
						new = true
					}
					local headers = {
						Cookie = lolz_data.cookie
					}

					http.get("https://lolz.guru/market", {params=params, headers=headers}, function(success, response)
						if response.status == 200 then
							local result = json.parse(response.body)

							callback(success, response, result)
						else
							callback(success, response)
						end
					end)

				end
			end

			local function check_lolzteam(...)
				if lolz_data == nil then
					LolzPanorama.create()
					client.delay_call(0.1, check_lolzteam_impl, ...)
				else
					check_lolzteam_impl(...)
				end
			end

			Checkers.new('Crack Checker', 'CrackCheck', function(steamid, name, next, retry, TypeMT)
				check_lolzteam(steamid, function(success, response, result)
					if ( response.status == 200 ) then
						local HTML = result.templateHtml
						local Matches = {}
						local Pattern = '(<div id="marketItem%-%-.+">.+class="marketIndexItem%-%-topContainer")'
						for Found in HTML:gmatch(Pattern) do
							local MarketID = Found:match('<div id="marketItem%-%-(%d+)"')
							local Price = Found:match('<span class="Value">(%d+,?.?%d+)</span>'):gsub(',','.')
							Matches[#Matches + 1] = { MarketID, math.floor(Price * 100)/100 }
						end
						if ( #Matches > 0 ) then
							local ReplaceData = {}
							ReplaceData.name = name
							ReplaceData.id = steamid
							ReplaceData.times = #Matches
							ReplaceData.price = string.format('%.2f', Matches[1][2])
							ReplaceData.marketid = Matches[1][1]
							ReplaceData.link =  'https://lolz.guru/market/'..ReplaceData.marketid

							local Prices = {}
							local Links = {}
							for index, value in ipairs(Matches) do
								Prices[#Prices + 1] = value[2]
								Links[#Links + 1] = value[1]
							end
							ReplaceData.min = math.min(unpack(Prices))
							ReplaceData.max = math.max(unpack(Prices))
							
							ReplaceData.links = table.concat(Links, ', ')

							local data = {}
							data.server = processTags('Acc {name} sold {times} times for {price}usd on LolzTeam, market ID: {marketID}', ReplaceData)
							data.lobby = processTags('Acc {name} - {price}USD - ID: {marketID}', ReplaceData)
							next(data)
						else
							local data = {}
							data.localchat = name .. '\'s account was not sold on Lolz.Team.'
							next(data)
						end
					else
						local data = {}
						data.localchat = name .. '\'s failed to check with Lolz.guru, is Lolz offline?'
						next(data)
					end
				end)
			end)
		end
		--#endregion

		--#region Face.it Checker
		if ( Feature.get('Faceit Checker') ) then
			local FaceitConfiguration

			Checkers.new('Faceit Checker', 'FACEIT', function(steamid, name, next, retry, TypeMT)
				if ( not FaceitConfiguration ) then
					http.get('https://api.faceit.com/stats/v1/stats/configuration/csgo', function(success, response)
						FaceitConfiguration = json.parse(response.body)
						retry()
					end)
					return
				end

				http.get('https://api.faceit.com/search/v1/?limit=3&query=' .. steamid, function(success, response)
					if ( success ) then
						local Data = json.parse(response.body)
						local Output = {};
						if ( Data and Data.payload.players.total_count > 0 ) then
							local UserResult = Data.payload.players.results[#Data.payload.players.results];
							Output.id = UserResult.id;
							Output.nickname = UserResult.nickname;
							Output.country = UserResult.country;
							http.get('https://api.faceit.com/stats/v1/stats/users/' .. Output.id .. '/games/csgo', function(_success, _response)
								if ( not _success ) then
									return retry()
								end
								local Stats = json.parse(_response.body)
								if ( Stats ) then
									local config_kdratio = FaceitConfiguration.grouping.main_stats[5];
									local config_winratio = FaceitConfiguration.grouping.user_win_rate;
									local config_hschance = FaceitConfiguration.grouping.main_stats[6];
									local config_matches = FaceitConfiguration.grouping.main_stats[1];
									
									local ReplaceData = {}
									ReplaceData.name = name
									ReplaceData.steamid = steamid
									ReplaceData.id = Output.id
									ReplaceData.user = Output.nickname
									ReplaceData.country = Output.country
									if ( Stats.lifetime ) then
										Output.kdratio = Stats.lifetime[config_kdratio]
										Output.winratio = Stats.lifetime[config_winratio]
										Output.hschance = Stats.lifetime[config_hschance]
										Output.matches = Stats.lifetime[config_matches]
										ReplaceData.kdratio = Output.kdratio
										ReplaceData.win = Output.winratio .. '%'
										ReplaceData.hschance = Output.hschance
										ReplaceData.matches = Output.matches
									end

									http.get('https://api.faceit.com/core/v1/nicknames/' .. Output.nickname, function(__success, __response)
										if ( not __success ) then
											return retry()
										end
										local NicknameData = json.parse(__response.body)
										if ( NicknameData and NicknameData.result == 'ok' ) then
											ReplaceData.level = NicknameData.payload.csgo_skill_level or 0
											if ( NicknameData.payload.games and NicknameData.payload.games.csgo ) then
												ReplaceData.elo = NicknameData.payload.games.csgo.faceit_elo
											end
											local data = {}
											data.server = processTags('{name} has a level {level} FaceIt Account ({user})!', ReplaceData)
											data.lobby = processTags('{name} - Level: {level} - User: {user}!', ReplaceData)
											next(data)
										end
									end)
								end
							end)
						else
							CPLua.ChatMethods['Local Chat'](' \x07[' .. TypeMT.name .. '] \x0A' .. name .. '\'s account was not found on FaceIT!')
							next()
						end
					else
						retry('No Fucking Clue, dm csmit195#4729 if error persists')
					end
				end)
			end)
		end
		--#endregion

		--#region Inventory Value
		if ( Feature.get('Inventory Value') ) then
			local InventoryPrices			
			Checkers.new('Inventory Value', 'Inventory', function(steamid, name, next, retry, TypeMT)
				if ( not InventoryPrices ) then
					http.get('http://csgobackpack.net/api/GetItemsList/v2/?no_details=1&details=0', {network_timeout=300, absolute_timeout=300}, function(success, response)
						if not success then return end
						client.delay_call(1, function()
							InventoryPrices = json.parse(response.body)
							client.delay_call(1, retry)
						end)
					end)
					return
				end

				http.get('https://steamcommunity.com/profiles/' .. steamid .. '/inventory/', function(success_, response_)
					if not success_ or not response_.body then return retry() end
					
					local PrivateProfile = response_.body:match('<div class="profile_private_info">') ~= nil
					local IsInventoryPrivate = response_.body:match("'s inventory is currently private.") ~= nil
					
					if ( PrivateProfile or IsInventoryPrivate ) then
						local data = {}
						data.localchat = name .. '\'s ' .. ( PrivateProfile and 'profile' or 'inventory' ) .. ' is private'
						data.lobby = data.localchat
						return next(data)
					end

					http.get('http://api.scrapestack.com/scrape?access_key=bea445d544a3c87883d8af2cf83ab498&url=https://steamcommunity.com/profiles/' .. steamid .. '/inventory/json/730/2', function(success, response)
						if not success or not response.body then return retry() end
						
						local jsonData = json.parse(response.body)
						if ( jsonData and type(jsonData) ~= 'userdata' and response.body ) then
							if not jsonData.success then return client.delay_call(5, retry) end
							
							local MarketableItems = {}
							local Total = 0
							for i, Item in pairs(jsonData.rgDescriptions) do
								if ( Item.marketable == 1 ) then
									local ItemData = InventoryPrices.items_list[Item.market_hash_name]
									local Price = ItemData and ItemData.price and ( ItemData.price['30_days'] or ItemData.price['all_time'] )
									if ( Price ) then
										Total = Total + Price.median
									end
								end
							end
							
							local data = {}
							data.server = name .. '\'s inventory value is worth $' .. string.format('%.2f', Total) .. 'USD'
							data.lobby = name .. ' - Value: $' .. string.format('%.2f', Total) .. 'USD'
							next(data)
						else
							client.delay_call(5, retry)
						end
					end)
				end)
			end)

			--[[ Old Version
			local BeenBefore = {}
			Checkers.new('Inventory Value', 'Inventory', function(steamid, name, next, retry, TypeMT)
				http.get('https://steamcommunity.com/profiles/' .. steamid .. '/inventory/', function(success_, response_)
					local PrivateProfile = response_.body:match('<div class="profile_private_info">') ~= nil
					local IsInventoryPrivate = response_.body:match("'s inventory is currently private.") ~= nil
					
					if ( PrivateProfile or IsInventoryPrivate ) then
						local data = {}
						data.server = name .. '\'s ' .. ( PrivateProfile and 'profile' or 'inventory' ) .. ' is private'
						data.lobby = data.server
						return next(data)
					end
					
					client.delay_call(1, function()
						http.get('https://csgobackpack.net/index.php?nick='.. steamid .. '&currency=USD' .. (BeenBefore[steamid] and '' or '&ref=1'), {['network_timeout'] = 160, ['absolute_timeout'] = 300} ,function(success, response)
							if response.status ~= 200 then
								return retry(steamid .. '(' .. name .. ') caused an unexpected error')
							end
			
							BeenBefore[steamid] = true
				
							if ( response and response.body and not response.body:find("<h3><font color='#a94847'>This profile is private</font></h3>") ) then
								local Value = response.body:match('<h3>In total\n?<p>%$(%d+.%d%d?)')
								if ( Value ) then
									local data = {}
									data.server = name .. '\'s inventory value is worth $' .. Value .. 'USD'
									data.lobby = name .. ' - Value: $' .. Value .. 'USD'
									next(data)
								else
									next('unexpected error, no value found for ' .. steamid .. ' retrying!')
								end
							end
						end)
					end)
				end)
			end)]]
		end
		--#endregion

		--#region Game Value
		if ( Feature.get('Game Value') ) then
			Checkers.new('Game Value', 'Games', function(steamid, name, next, retry, TypeMT)
				http.get('https://steamid.pro/lookup/'..steamid, function(success, response)
					if not success or response.status ~= 200 then
						return retry('error checking ' .. steamid)
					end

					local Value = response.body:match('<span class="number%-price">$(%d+)</span>')
					if ( Value ) then
						local data = {}
						data.server = name .. '\'s account is worth $' .. Value .. '!'
						next(data)
					else
						retry('no price found, wtf? dm csmit195#4729 if the error persists.')
					end
				end)
			end)
		end
		--#endregion

		--#region Banned Friends Checker
		if ( Feature.get('Banned Friends') ) then
			Checkers.new('Banned Friends', 'Banned', function(steamid, name, next, retry, TypeMT)
				http.get('https://steamcommunity.com/profiles/' .. steamid .. '/friends/', function(success, response)
					if not success or response.status ~= 200 then
						return retry('failed to check ' .. steamid ..'\'s friends, dm csmit195#4729 if error persists')
					end

					local SteamIDS = {}
					for SteamID in response.body:gmatch([[data%-steamid="(%d+)"]]) do
						SteamIDS[#SteamIDS + 1] = SteamID
					end

					local Groups = {}
					for index, SteamID in ipairs(SteamIDS) do
						local Group = math.floor(index / 100)+1
						Groups[Group] = Groups[Group] or {}
						Groups[Group][#Groups[Group] + 1] = SteamID
					end

					if ( #Groups == 0 ) then return next() end
					
					local Checked = 0
					local BannedCount = 0
					local Retry = false
					for GroupIndex, Group in ipairs(Groups) do
						local steamidStr = table.concat(Group, ',')
						http.get('https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=' .. RandomWebKey() .. '&steamids=' .. steamidStr, function(success, response)
							if not success or response.status ~= 200 or Retry then
								Retry = true
								return retry('unknown error, retrying')
							end
							local jsonData = json.parse(response.body)
							if ( jsonData and jsonData.players ) then
								for index, Player in ipairs(jsonData.players) do
									Checked = Checked + 1
									if ( Player.NumberOfVACBans > 0 or Player.NumberOfGameBans > 0 ) then
										BannedCount = BannedCount + 1
									end
									
									if ( Checked == #SteamIDS ) then
										local data = {}
										data.server = name .. ' has ' .. BannedCount .. '/' .. #SteamIDS .. ' banned friends!'
										data.lobbychat = name .. ' - ' .. BannedCount .. '/' .. #SteamIDS  .. ' banned friends!'
										next(data)
									end
								end
							end
						end)
					end
				end)
			end)
		end
		--#endregion

		--#region Name History
		local function GetNameHistory(SteamID)
			local Names = {}
			local Index = 0
			local Name = ISteamFriends.GetFriendPersonaNameHistory(SteamID, Index)
			if Name ~= '' then
				repeat
					Names[#Names + 1] = Name                                                                                            
					Index = Index + 1
					Name = ISteamFriends.GetFriendPersonaNameHistory(SteamID, Index)
				until Name == ''
			end
			return Names
		end

		if ( Feature.get('Name History') ) then
			Checkers.new('Name History', 'Names', function(steamid, name, next, retry, TypeMT)
				local History = GetNameHistory(steamid)
				if ( #History > 0 ) then
					local data = {}
					data.server = table.concat(History, ', ')
					data.lobby = data.server
					next(data)
				else
					next()
				end
			end)
		end
		--#endregion

		--#endregion

		Checkers.enable = ui.new_checkbox('Lua', 'B', 'Account Checkers')
		local Items = {}
		for i, RegisteredItem in ipairs(Checkers.registered) do
			Items[#Items + 1] = RegisteredItem.name
		end
		if ( #Items == 0 ) then Items = {'Empty...'} end -- DEBUG ADD
		
		Checkers.type = ui.new_combobox('Lua', 'B', 'Type', Items)
		Checkers.target = ui.new_combobox('Lua', 'B', 'Target', {'Everyone', 'Teammates', 'Enemies'})
		Checkers.output = ui.new_combobox('Lua', 'B', 'Output', {'Local Chat', 'Party Chat', 'Game Chat', 'Team Chat', 'Console'})
		ui.set(Checkers.output, 'Local Chat')

		Checkers.status = ui.new_label('Lua', 'B', 'Status: Idle...')
		Checkers.check = ui.new_button('Lua', 'B', 'Check', Checkers._StartBTN)

		ui.set_visible(Checkers.type, false)
		ui.set_visible(Checkers.target, false)
		ui.set_visible(Checkers.output, false)
		ui.set_visible(Checkers.status, false)
		ui.set_visible(Checkers.check, false)
		ui.set_callback(Checkers.enable, function(Elem)
			local State = ui.get(Elem)

			ui.set_visible(Checkers.type, State)
			ui.set_visible(Checkers.target, State)
			ui.set_visible(Checkers.output, State)
			ui.set_visible(Checkers.status, State)
			ui.set_visible(Checkers.check, State)
		end)
	end
	--#endregion

	--#region Whitelist Legits on Key
	if ( Feature.get('Whitelist Friends on Key') ) then
		CPLua.WhitelistLegitsOnKey = {}
		CPLua.WhitelistLegitsOnKey.enable = ui.new_checkbox('Lua', 'B', 'Whitelist Legits on key')
		CPLua.WhitelistLegitsOnKey.hotkey = ui.new_hotkey('Lua', 'B', 'Whitelist Legits on key', true)

		client.set_event_callback('run_command', function()
			local KeyState, Key = ui.get(CPLua.WhitelistLegitsOnKey.hotkey)

			for i, Entity in ipairs(entity.get_players(true)) do
				if ( PListAdditions and PListAdditions.cache and PListAdditions.cache[Entity] and PListAdditions.cache[Entity][PListAdditions.MarkAsLegit] ) then
					plist.set(Entity, 'Add to whitelist', ui.get(CPLua.WhitelistLegitsOnKey.enable) and KeyState and PListAdditions.cache[Entity][PListAdditions.MarkAsLegit])
				end
			end
		end)

		client.register_esp_flag('WHITELISTED', 255, 255, 255, function(Entity)
			local KeyState, Key = ui.get(CPLua.WhitelistLegitsOnKey.hotkey)
			if ( PListAdditions and PListAdditions.cache and PListAdditions.cache[Entity] and PListAdditions.cache[Entity][PListAdditions.MarkAsLegit] ) then
				return ui.get(CPLua.WhitelistLegitsOnKey.enable) and KeyState and PListAdditions.cache[Entity][PListAdditions.MarkAsLegit]
			end
			return false
		end)
	end
	--#endregion

	--#region Party Chat Utilities
	if ( Feature.get('Party Chat Utils') ) then
		CPLua.PartyChatUtils = {}
		CPLua.PartyChatUtils.enable = ui.new_checkbox('Lua', 'B', 'Party Chat Utilities')

		ui.set(CPLua.PartyChatUtils.enable, true)

		local function PartyChatLoop()
			if ( ui.get(CPLua.PartyChatUtils.enable) ) then
				CPPanoramaMainMenu.PartyChatLoop()
			end
			client.delay_call(0.25, PartyChatLoop)
		end

		PartyChatLoop()
	end
	--#endregion

 	--#region DebugOptions
	CPLua.DebugOptions = {}
	CPLua.DebugOptions.enable = ui.new_checkbox('Lua', 'B', 'Debug Mode (console)')
	ui.set_callback(CPLua.DebugOptions.enable, function(self)
		local Status = ui.get(self)
		Options.debugMode = Status
	end)
	--#endregion

	CPLua.Footer = ui.new_label('Lua', 'B', '=========  [   $CP Finish   ]  =========')

	--#region Paint Draw Loops
	client.set_event_callback('paint', function()
		for index, func in ipairs(CPLua.loops) do
			func()
		end
	end)
	--#endregion

	--#region Player List Adjustments
	local style = {
		letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789' ",
		trans = {
			bold = {"\u{1D5EE}","\u{1D5EF}","\u{1D5F0}","\u{1D5F1}","\u{1D5F2}","\u{1D5F3}","\u{1D5F4}","\u{1D5F5}","\u{1D5F6}","\u{1D5F7}","\u{1D5F8}","\u{1D5F9}","\u{1D5FA}","\u{1D5FB}","\u{1D5FC}","\u{1D5FD}","\u{1D5FE}","\u{1D5FF}","\u{1D600}","\u{1D601}","\u{1D602}","\u{1D603}","\u{1D604}","\u{1D605}","\u{1D606}","\u{1D607}","\u{1D5D4}","\u{1D5D5}","\u{1D5D6}","\u{1D5D7}","\u{1D5D8}","\u{1D5D9}","\u{1D5DA}","\u{1D5DB}","\u{1D5DC}","\u{1D5DD}","\u{1D5DE}","\u{1D5DF}","\u{1D5E0}","\u{1D5E1}","\u{1D5E2}","\u{1D5E3}","\u{1D5E4}","\u{1D5E5}","\u{1D5E6}","\u{1D5E7}","\u{1D5E8}","\u{1D5E9}","\u{1D5EA}","\u{1D5EB}","\u{1D5EC}","\u{1D5ED}","\u{1D7EC}","\u{1D7ED}","\u{1D7EE}","\u{1D7EF}","\u{1D7F0}","\u{1D7F1}","\u{1D7F2}","\u{1D7F3}","\u{1D7F4}","\u{1D7F5}","'"," "},
			bolditalic = {"\u{1D656}","\u{1D657}","\u{1D658}","\u{1D659}","\u{1D65A}","\u{1D65B}","\u{1D65C}","\u{1D65D}","\u{1D65E}","\u{1D65F}","\u{1D660}","\u{1D661}","\u{1D662}","\u{1D663}","\u{1D664}","\u{1D665}","\u{1D666}","\u{1D667}","\u{1D668}","\u{1D669}","\u{1D66A}","\u{1D66B}","\u{1D66C}","\u{1D66D}","\u{1D66E}","\u{1D66F}", "\u{1D63C}","\u{1D63D}","\u{1D63E}","\u{1D63F}","\u{1D640}","\u{1D641}","\u{1D642}","\u{1D643}","\u{1D644}","\u{1D645}","\u{1D646}","\u{1D647}","\u{1D648}","\u{1D649}","\u{1D64A}","\u{1D64B}","\u{1D64C}","\u{1D64D}","\u{1D64E}","\u{1D64F}","\u{1D650}","\u{1D651}","\u{1D652}","\u{1D653}","\u{1D654}","\u{1D655}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			italic = {"\u{1D622}","\u{1D623}","\u{1D624}","\u{1D625}","\u{1D626}","\u{1D627}","\u{1D628}","\u{1D629}","\u{1D62A}","\u{1D62B}","\u{1D62C}","\u{1D62D}","\u{1D62E}","\u{1D62F}","\u{1D630}","\u{1D631}","\u{1D632}","\u{1D633}","\u{1D634}","\u{1D635}","\u{1D636}","\u{1D637}","\u{1D638}","\u{1D639}","\u{1D63A}","\u{1D63B}", "\u{1D608}","\u{1D609}","\u{1D60A}","\u{1D60B}","\u{1D60C}","\u{1D60D}","\u{1D60E}","\u{1D60F}","\u{1D610}","\u{1D611}","\u{1D612}","\u{1D613}","\u{1D614}","\u{1D615}","\u{1D616}","\u{1D617}","\u{1D618}","\u{1D619}","\u{1D61A}","\u{1D61B}","\u{1D61C}","\u{1D61D}","\u{1D61E}","\u{1D61F}","\u{1D620}","\u{1D621}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			circled = {"\u{24D0}","\u{24D1}","\u{24D2}","\u{24D3}","\u{24D4}","\u{24D5}","\u{24D6}","\u{24D7}","\u{24D8}","\u{24D9}","\u{24DA}","\u{24DB}","\u{24DC}","\u{24DD}","\u{24DE}","\u{24DF}","\u{24E0}","\u{24E1}","\u{24E2}","\u{24E3}","\u{24E4}","\u{24E5}","\u{24E6}","\u{24E7}","\u{24E8}","\u{24E9}", "\u{24B6}","\u{24B7}","\u{24B8}","\u{24B9}","\u{24BA}","\u{24BB}","\u{24BC}","\u{24BD}","\u{24BE}","\u{24BF}","\u{24C0}","\u{24C1}","\u{24C2}","\u{24C3}","\u{24C4}","\u{24C5}","\u{24C6}","\u{24C7}","\u{24C8}","\u{24C9}","\u{24CA}","\u{24CB}","\u{24CC}","\u{24CD}","\u{24CE}","\u{24CF}", "0","\u{2460}","\u{2461}","\u{2462}","\u{2463}","\u{2464}","\u{2465}","\u{2466}","\u{2467}","\u{2468}","'"," "},
			circledNeg = {"\u{1F150}","\u{1F151}","\u{1F152}","\u{1F153}","\u{1F154}","\u{1F155}","\u{1F156}","\u{1F157}","\u{1F158}","\u{1F159}","\u{1F15A}","\u{1F15B}","\u{1F15C}","\u{1F15D}","\u{1F15E}","\u{1F15F}","\u{1F160}","\u{1F161}","\u{1F162}","\u{1F163}","\u{1F164}","\u{1F165}","\u{1F166}","\u{1F167}","\u{1F168}","\u{1F169}", "\u{1F150}","\u{1F151}","\u{1F152}","\u{1F153}","\u{1F154}","\u{1F155}","\u{1F156}","\u{1F157}","\u{1F158}","\u{1F159}","\u{1F15A}","\u{1F15B}","\u{1F15C}","\u{1F15D}","\u{1F15E}","\u{1F15F}","\u{1F160}","\u{1F161}","\u{1F162}","\u{1F163}","\u{1F164}","\u{1F165}","\u{1F166}","\u{1F167}","\u{1F168}","\u{1F169}", "\u{24FF}","1","2","3","4","5","6","7","8","9","'"," "},
			fullwidth = {"\u{FF41}","\u{FF42}","\u{FF43}","\u{FF44}","\u{FF45}","\u{FF46}","\u{FF47}","\u{FF48}","\u{FF49}","\u{FF4A}","\u{FF4B}","\u{FF4C}","\u{FF4D}","\u{FF4E}","\u{FF4F}","\u{FF50}","\u{FF51}","\u{FF52}","\u{FF53}","\u{FF54}","\u{FF55}","\u{FF56}","\u{FF57}","\u{FF58}","\u{FF59}","\u{FF5A}", "\u{FF21}","\u{FF22}","\u{FF23}","\u{FF24}","\u{FF25}","\u{FF26}","\u{FF27}","\u{FF28}","\u{FF29}","\u{FF2A}","\u{FF2B}","\u{FF2C}","\u{FF2D}","\u{FF2E}","\u{FF2F}","\u{FF30}","\u{FF31}","\u{FF32}","\u{FF33}","\u{FF34}","\u{FF35}","\u{FF36}","\u{FF37}","\u{FF38}","\u{FF39}","\u{FF3A}", "\u{FF10}","\u{FF11}","\u{FF12}","\u{FF13}","\u{FF14}","\u{FF15}","\u{FF16}","\u{FF17}","\u{FF18}","\u{FF19}","\u{FF07}","\u{3000}"},
			fraktur = {"\u{1D51E}","\u{1D51F}","\u{1D520}","\u{1D521}","\u{1D522}","\u{1D523}","\u{1D524}","\u{1D525}","\u{1D526}","\u{1D527}","\u{1D528}","\u{1D529}","\u{1D52A}","\u{1D52B}","\u{1D52C}","\u{1D52D}","\u{1D52E}","\u{1D52F}","\u{1D530}","\u{1D531}","\u{1D532}","\u{1D533}","\u{1D534}","\u{1D535}","\u{1D536}","\u{1D537}", "\u{1D504}","\u{1D505}","\u{212D}","\u{1D507}","\u{1D508}","\u{1D509}","\u{1D50A}","\u{210C}","\u{2111}","\u{1D50D}","\u{1D50E}","\u{1D50F}","\u{1D510}","\u{1D511}","\u{1D512}","\u{1D513}","\u{1D514}","\u{211C}","\u{1D516}","\u{1D517}","\u{1D518}","\u{1D519}","\u{1D51A}","\u{1D51B}","\u{1D51C}","\u{2128}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			frakturbold = {"\u{1D586}","\u{1D587}","\u{1D588}","\u{1D589}","\u{1D58A}","\u{1D58B}","\u{1D58C}","\u{1D58D}","\u{1D58E}","\u{1D58F}","\u{1D590}","\u{1D591}","\u{1D592}","\u{1D593}","\u{1D594}","\u{1D595}","\u{1D596}","\u{1D597}","\u{1D598}","\u{1D599}","\u{1D59A}","\u{1D59B}","\u{1D59C}","\u{1D59D}","\u{1D59E}","\u{1D59F}", "\u{1D56C}","\u{1D56D}","\u{1D56E}","\u{1D56F}","\u{1D570}","\u{1D571}","\u{1D572}","\u{1D573}","\u{1D574}","\u{1D575}","\u{1D576}","\u{1D577}","\u{1D578}","\u{1D579}","\u{1D57A}","\u{1D57B}","\u{1D57C}","\u{1D57D}","\u{1D57E}","\u{1D57F}","\u{1D580}","\u{1D581}","\u{1D582}","\u{1D583}","\u{1D584}","\u{1D585}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			script = {"\u{1D4EA}","\u{1D4EB}","\u{1D4EC}","\u{1D4ED}","\u{1D4EE}","\u{1D4EF}","\u{1D4F0}","\u{1D4F1}","\u{1D4F2}","\u{1D4F3}","\u{1D4F4}","\u{1D4F5}","\u{1D4F6}","\u{1D4F7}","\u{1D4F8}","\u{1D4F9}","\u{1D4FA}","\u{1D4FB}","\u{1D4FC}","\u{1D4FD}","\u{1D4FE}","\u{1D4FF}","\u{1D500}","\u{1D501}","\u{1D502}","\u{1D503}", "\u{1D4D0}","\u{1D4D1}","\u{1D4D2}","\u{1D4D3}","\u{1D4D4}","\u{1D4D5}","\u{1D4D6}","\u{1D4D7}","\u{1D4D8}","\u{1D4D9}","\u{1D4DA}","\u{1D4DB}","\u{1D4DC}","\u{1D4DD}","\u{1D4DE}","\u{1D4DF}","\u{1D4E0}","\u{1D4E1}","\u{1D4E2}","\u{1D4E3}","\u{1D4E4}","\u{1D4E5}","\u{1D4E6}","\u{1D4E7}","\u{1D4E8}","\u{1D4E9}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			doublestruck = {"\u{1D552}","\u{1D553}","\u{1D554}","\u{1D555}","\u{1D556}","\u{1D557}","\u{1D558}","\u{1D559}","\u{1D55A}","\u{1D55B}","\u{1D55C}","\u{1D55D}","\u{1D55E}","\u{1D55F}","\u{1D560}","\u{1D561}","\u{1D562}","\u{1D563}","\u{1D564}","\u{1D565}","\u{1D566}","\u{1D567}","\u{1D568}","\u{1D569}","\u{1D56A}","\u{1D56B}", "\u{1D538}","\u{1D539}","\u{2102}","\u{1D53B}","\u{1D53C}","\u{1D53D}","\u{1D53E}","\u{210D}","\u{1D540}","\u{1D541}","\u{1D542}","\u{1D543}","\u{1D544}","\u{2115}","\u{1D546}","\u{2119}","\u{211A}","\u{211D}","\u{1D54A}","\u{1D54B}","\u{1D54C}","\u{1D54D}","\u{1D54E}","\u{1D54F}","\u{1D550}","\u{2124}", "\u{1D7D8}","\u{1D7D9}","\u{1D7DA}","\u{1D7DB}","\u{1D7DC}","\u{1D7DD}","\u{1D7DE}","\u{1D7DF}","\u{1D7E0}","\u{1D7E1}","'"," "},
			monospace = {"\u{1D68A}","\u{1D68B}","\u{1D68C}","\u{1D68D}","\u{1D68E}","\u{1D68F}","\u{1D690}","\u{1D691}","\u{1D692}","\u{1D693}","\u{1D694}","\u{1D695}","\u{1D696}","\u{1D697}","\u{1D698}","\u{1D699}","\u{1D69A}","\u{1D69B}","\u{1D69C}","\u{1D69D}","\u{1D69E}","\u{1D69F}","\u{1D6A0}","\u{1D6A1}","\u{1D6A2}","\u{1D6A3}", "\u{1D670}","\u{1D671}","\u{1D672}","\u{1D673}","\u{1D674}","\u{1D675}","\u{1D676}","\u{1D677}","\u{1D678}","\u{1D679}","\u{1D67A}","\u{1D67B}","\u{1D67C}","\u{1D67D}","\u{1D67E}","\u{1D67F}","\u{1D680}","\u{1D681}","\u{1D682}","\u{1D683}","\u{1D684}","\u{1D685}","\u{1D686}","\u{1D687}","\u{1D688}","\u{1D689}", "\u{1D7F6}","\u{1D7F7}","\u{1D7F8}","\u{1D7F9}","\u{1D7FA}","\u{1D7FB}","\u{1D7FC}","\u{1D7FD}","\u{1D7FE}","\u{1D7FF}","'"," "},
			parenthesized = {"\u{249C}","\u{249D}","\u{249E}","\u{249F}","\u{24A0}","\u{24A1}","\u{24A2}","\u{24A3}","\u{24A4}","\u{24A5}","\u{24A6}","\u{24A7}","\u{24A8}","\u{24A9}","\u{24AA}","\u{24AB}","\u{24AC}","\u{24AD}","\u{24AE}","\u{24AF}","\u{24B0}","\u{24B1}","\u{24B2}","\u{24B3}","\u{24B4}","\u{24B5}", "\u{249C}","\u{249D}","\u{249E}","\u{249F}","\u{24A0}","\u{24A1}","\u{24A2}","\u{24A3}","\u{24A4}","\u{24A5}","\u{24A6}","\u{24A7}","\u{24A8}","\u{24A9}","\u{24AA}","\u{24AB}","\u{24AC}","\u{24AD}","\u{24AE}","\u{24AF}","\u{24B0}","\u{24B1}","\u{24B2}","\u{24B3}","\u{24B4}","\u{24B5}", "0","\u{2474}","\u{2475}","\u{2476}","\u{2477}","\u{2478}","\u{2479}","\u{247A}","\u{247B}","\u{247C}","'"," "},
			regional = {"\u{1F1E6}","\u{1F1E7}","\u{1F1E8}","\u{1F1E9}","\u{1F1EA}","\u{1F1EB}","\u{1F1EC}","\u{1F1ED}","\u{1F1EE}","\u{1F1EF}","\u{1F1F0}","\u{1F1F1}","\u{1F1F2}","\u{1F1F3}","\u{1F1F4}","\u{1F1F5}","\u{1F1F6}","\u{1F1F7}","\u{1F1F8}","\u{1F1F9}","\u{1F1FA}","\u{1F1FB}","\u{1F1FC}","\u{1F1FD}","\u{1F1FE}","\u{1F1FF}", "\u{1F1E6}","\u{1F1E7}","\u{1F1E8}","\u{1F1E9}","\u{1F1EA}","\u{1F1EB}","\u{1F1EC}","\u{1F1ED}","\u{1F1EE}","\u{1F1EF}","\u{1F1F0}","\u{1F1F1}","\u{1F1F2}","\u{1F1F3}","\u{1F1F4}","\u{1F1F5}","\u{1F1F6}","\u{1F1F7}","\u{1F1F8}","\u{1F1F9}","\u{1F1FA}","\u{1F1FB}","\u{1F1FC}","\u{1F1FD}","\u{1F1FE}","\u{1F1FF}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			squared = {"\u{1F130}","\u{1F131}","\u{1F132}","\u{1F133}","\u{1F134}","\u{1F135}","\u{1F136}","\u{1F137}","\u{1F138}","\u{1F139}","\u{1F13A}","\u{1F13B}","\u{1F13C}","\u{1F13D}","\u{1F13E}","\u{1F13F}","\u{1F140}","\u{1F141}","\u{1F142}","\u{1F143}","\u{1F144}","\u{1F145}","\u{1F146}","\u{1F147}","\u{1F148}","\u{1F149}", "\u{1F130}","\u{1F131}","\u{1F132}","\u{1F133}","\u{1F134}","\u{1F135}","\u{1F136}","\u{1F137}","\u{1F138}","\u{1F139}","\u{1F13A}","\u{1F13B}","\u{1F13C}","\u{1F13D}","\u{1F13E}","\u{1F13F}","\u{1F140}","\u{1F141}","\u{1F142}","\u{1F143}","\u{1F144}","\u{1F145}","\u{1F146}","\u{1F147}","\u{1F148}","\u{1F149}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			squaredNeg = {"\u{1F170}","\u{1F171}","\u{1F172}","\u{1F173}","\u{1F174}","\u{1F175}","\u{1F176}","\u{1F177}","\u{1F178}","\u{1F179}","\u{1F17A}","\u{1F17B}","\u{1F17C}","\u{1F17D}","\u{1F17E}","\u{1F17F}","\u{1F180}","\u{1F181}","\u{1F182}","\u{1F183}","\u{1F184}","\u{1F185}","\u{1F186}","\u{1F187}","\u{1F188}","\u{1F189}", "\u{1F170}","\u{1F171}","\u{1F172}","\u{1F173}","\u{1F174}","\u{1F175}","\u{1F176}","\u{1F177}","\u{1F178}","\u{1F179}","\u{1F17A}","\u{1F17B}","\u{1F17C}","\u{1F17D}","\u{1F17E}","\u{1F17F}","\u{1F180}","\u{1F181}","\u{1F182}","\u{1F183}","\u{1F184}","\u{1F185}","\u{1F186}","\u{1F187}","\u{1F188}","\u{1F189}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			acute = {"\u{E1}","b","\u{107}","d","\u{E9}","f","\u{1F5}","h","\u{ED}","j","\u{1E31}","\u{13A}","\u{1E3F}","\u{144}","\u{151}","\u{1E55}","q","\u{155}","\u{15B}","t","\u{FA}","v","\u{1E83}","x","\u{4F3}","\u{17A}", "\u{C1}","B","\u{106}","D","\u{C9}","F","\u{1F4}","H","\u{ED}","J","\u{1E30}","\u{139}","\u{1E3E}","\u{143}","\u{150}","\u{1E54}","Q","\u{154}","\u{15B}","T","\u{170}","V","\u{1E82}","X","\u{4F2}","\u{179}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			thai = {"\u{FF91}","\u{4E43}","c","d","\u{4E47}","\u{FF77}","g","\u{3093}","\u{FF89}","\u{FF8C}","\u{30BA}","\u{FF9A}","\u{FFB6}","\u{5200}","o","\u{FF71}","q","\u{5C3A}","\u{4E02}","\u{FF72}","u","\u{221A}","w","\u{FF92}","\u{FF98}","\u{4E59}", "\u{FF91}","\u{4E43}","c","d","\u{4E47}","\u{FF77}","g","\u{3093}","\u{FF89}","\u{FF8C}","\u{30BA}","\u{FF9A}","\u{FFB6}","\u{5200}","o","\u{FF71}","q","\u{5C3A}","\u{4E02}","\u{FF72}","u","\u{221A}","w","\u{FF92}","\u{FF98}","\u{4E59}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			curvy1 = {"\u{E04}","\u{E52}","\u{188}","\u{257}","\u{FEC9}","\u{93F}","\u{FEED}","\u{266}","\u{671}","\u{FEDD}","\u{16D5}","\u{26D}","\u{E53}","\u{E01}","\u{47B}","\u{3C1}","\u{6F9}","\u{27C}","\u{E23}","\u{547}","\u{AAA}","\u{6F7}","\u{E1D}","\u{E0B}","\u{5E5}","\u{579}", "\u{E04}","\u{E52}","\u{188}","\u{257}","\u{FEC9}","\u{93F}","\u{FEED}","\u{266}","\u{671}","\u{FEDD}","\u{16D5}","\u{26D}","\u{E53}","\u{E01}","\u{47B}","\u{3C1}","\u{6F9}","\u{27C}","\u{E23}","\u{547}","\u{AAA}","\u{6F7}","\u{E1D}","\u{E0B}","\u{5E5}","\u{579}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			curvy2 = {"\u{3B1}","\u{432}","\u{A2}","\u{2202}","\u{454}","\u{192}","\u{FEED}","\u{43D}","\u{3B9}","\u{5E0}","\u{43A}","\u{2113}","\u{43C}","\u{3B7}","\u{3C3}","\u{3C1}","\u{6F9}","\u{44F}","\u{455}","\u{442}","\u{3C5}","\u{3BD}","\u{3C9}","\u{3C7}","\u{443}","\u{579}", "\u{3B1}","\u{432}","\u{A2}","\u{2202}","\u{454}","\u{192}","\u{FEED}","\u{43D}","\u{3B9}","\u{5E0}","\u{43A}","\u{2113}","\u{43C}","\u{3B7}","\u{3C3}","\u{3C1}","\u{6F9}","\u{44F}","\u{455}","\u{442}","\u{3C5}","\u{3BD}","\u{3C9}","\u{3C7}","\u{443}","\u{579}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			curvy3 = {"\u{E04}","\u{E52}","\u{3C2}","\u{E54}","\u{454}","\u{166}","\u{FEEE}","\u{452}","\u{E40}","\u{5DF}","\u{43A}","\u{26D}","\u{E53}","\u{E20}","\u{E4F}","\u{5E7}","\u{1EE3}","\u{433}","\u{E23}","\u{547}","\u{E22}","\u{5E9}","\u{E2C}","\u{5D0}","\u{5E5}","\u{579}", "\u{E04}","\u{E52}","\u{3C2}","\u{E54}","\u{454}","\u{166}","\u{FEEE}","\u{452}","\u{E40}","\u{5DF}","\u{43A}","\u{26D}","\u{E53}","\u{E20}","\u{E4F}","\u{5E7}","\u{1EE3}","\u{433}","\u{E23}","\u{547}","\u{E22}","\u{5E9}","\u{E2C}","\u{5D0}","\u{5E5}","\u{579}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			fauxcryllic = {"\u{430}","\u{44A}","\u{441}","\u{2181}","\u{44D}","f","\u{411}","\u{402}","\u{456}","\u{458}","\u{43A}","l","\u{43C}","\u{438}","\u{43E}","\u{440}","q","\u{453}","\u{455}","\u{442}","\u{446}","v","\u{448}","\u{445}","\u{40E}","z", "\u{414}","\u{411}","\u{480}","\u{2181}","\u{404}","F","\u{411}","\u{41D}","\u{406}","\u{408}","\u{40C}","L","\u{41C}","\u{418}","\u{424}","\u{420}","Q","\u{42F}","\u{405}","\u{413}","\u{426}","V","\u{429}","\u{416}","\u{427}","Z", "0","1","2","3","4","5","6","7","8","9","'"," "},
			rockdots = {"\u{E4}","\u{1E05}","\u{10B}","\u{1E0B}","\u{EB}","\u{1E1F}","\u{121}","\u{1E27}","\u{EF}","j","\u{1E33}","\u{1E37}","\u{1E41}","\u{1E45}","\u{F6}","\u{1E57}","q","\u{1E5B}","\u{1E61}","\u{1E97}","\u{FC}","\u{1E7F}","\u{1E85}","\u{1E8D}","\u{FF}","\u{17C}", "\u{C4}","\u{1E04}","\u{10A}","\u{1E0A}","\u{401}","\u{1E1E}","\u{120}","\u{1E26}","\u{407}","J","\u{1E32}","\u{1E36}","\u{1E40}","\u{1E44}","\u{D6}","\u{1E56}","Q","\u{1E5A}","\u{1E60}","\u{1E6A}","\u{DC}","\u{1E7E}","\u{1E84}","\u{1E8C}","\u{178}","\u{17B}", "0","1","2","\u{4DF}","4","5","6","7","8","9","'"," "},
			smallcaps = {"\u{1D00}","\u{299}","\u{1D04}","\u{1D05}","\u{1D07}","\u{A730}","\u{262}","\u{29C}","\u{26A}","\u{1D0A}","\u{1D0B}","\u{29F}","\u{1D0D}","\u{274}","\u{1D0F}","\u{1D29}","q","\u{280}","\u{A731}","\u{1D1B}","\u{1D1C}","\u{1D20}","\u{1D21}","x","y","\u{1D22}", "\u{1D00}","\u{299}","\u{1D04}","\u{1D05}","\u{1D07}","\u{A730}","\u{262}","\u{29C}","\u{26A}","\u{1D0A}","\u{1D0B}","\u{29F}","\u{1D0D}","\u{274}","\u{1D0F}","\u{1D29}","Q","\u{280}","\u{A731}","\u{1D1B}","\u{1D1C}","\u{1D20}","\u{1D21}","x","Y","\u{1D22}", "0","1","2","3","4","5","6","7","8","9","'"," "},
			stroked = {"\u{23A}","\u{180}","\u{23C}","\u{111}","\u{247}","f","\u{1E5}","\u{127}","\u{268}","\u{249}","\u{A741}","\u{142}","m","n","\u{F8}","\u{1D7D}","\u{A757}","\u{24D}","s","\u{167}","\u{1D7E}","v","w","x","\u{24F}","\u{1B6}", "\u{23A}","\u{243}","\u{23B}","\u{110}","\u{246}","F","\u{1E4}","\u{126}","\u{197}","\u{248}","\u{A740}","\u{141}","M","N","\u{D8}","\u{2C63}","\u{A756}","\u{24C}","S","\u{166}","\u{1D7E}","V","W","X","\u{24E}","\u{1B5}", "0","1","\u{1BB}","3","4","5","6","7","8","9","'"," "},
			subscript = {"\u{2090}","b","c","d","\u{2091}","f","g","\u{2095}","\u{1D62}","\u{2C7C}","\u{2096}","\u{2097}","\u{2098}","\u{2099}","\u{2092}","\u{209A}","q","\u{1D63}","\u{209B}","\u{209C}","\u{1D64}","\u{1D65}","w","\u{2093}","y","z", "\u{2090}","B","C","D","\u{2091}","F","G","\u{2095}","\u{1D62}","\u{2C7C}","\u{2096}","\u{2097}","\u{2098}","\u{2099}","\u{2092}","\u{209A}","Q","\u{1D63}","\u{209B}","\u{209C}","\u{1D64}","\u{1D65}","W","\u{2093}","Y","Z", "\u{2080}","\u{2081}","\u{2082}","\u{2083}","\u{2084}","\u{2085}","\u{2086}","\u{2087}","\u{2088}","\u{2089}","'"," "},
			superscript = {"\u{1D43}","\u{1D47}","\u{1D9C}","\u{1D48}","\u{1D49}","\u{1DA0}","\u{1D4D}","\u{2B0}","\u{2071}","\u{2B2}","\u{1D4F}","\u{2E1}","\u{1D50}","\u{207F}","\u{1D52}","\u{1D56}","q","\u{2B3}","\u{2E2}","\u{1D57}","\u{1D58}","\u{1D5B}","\u{2B7}","\u{2E3}","\u{2B8}","\u{1DBB}", "\u{1D2C}","\u{1D2E}","\u{1D9C}","\u{1D30}","\u{1D31}","\u{1DA0}","\u{1D33}","\u{1D34}","\u{1D35}","\u{1D36}","\u{1D37}","\u{1D38}","\u{1D39}","\u{1D3A}","\u{1D3C}","\u{1D3E}","Q","\u{1D3F}","\u{2E2}","\u{1D40}","\u{1D41}","\u{2C7D}","\u{1D42}","\u{2E3}","\u{2B8}","\u{1DBB}", "\u{2070}","\u{B9}","\u{B2}","\u{B3}","\u{2074}","\u{2075}","\u{2076}","\u{2077}","\u{2078}","\u{2079}","'"," "},
			inverted = {"\u{250}","q","\u{254}","p","\u{1DD}","\u{25F}","\u{183}","\u{265}","\u{131}","\u{27E}","\u{29E}","\u{5DF}","\u{26F}","u","o","d","b","\u{279}","s","\u{287}","n","\u{28C}","\u{28D}","x","\u{28E}","z", "\u{250}","q","\u{254}","p","\u{1DD}","\u{25F}","\u{183}","\u{265}","\u{131}","\u{27E}","\u{29E}","\u{5DF}","\u{26F}","u","o","d","b","\u{279}","s","\u{287}","n","\u{10321}","\u{28D}","x","\u{28E}","z", "0","1","2","3","4","5","6","7","8","9",","," "},
		}
	}

	function transText(types, text)
		if not style.trans[types] then return text end
		local output = ''
		for i=1, #text do
			local char = text:sub(i,i)
			output = output .. ( style.trans[types][style.letters:find(char)] or char )
		end
		return output
	end

	function changeCaseWord(str)
		local u = ""
		for i = 1, #str do
			if i % 2 == 1 then
				u = u .. string.upper(str:sub(i, i))
			else
				u = u .. string.lower(str:sub(i, i))
			end
		end
		return u
	end

	function changeCase(original)
		local words = {}
		for v in original:gmatch(".+") do 
			words[#words + 1] = v
		end
		for i,v in ipairs(words) do
			words[i] = changeCaseWord(v)
		end
		return table.concat(words, " ")
	end

	-- UI References
	if ( Feature.get('Playerlist Additions') ) then
		local PlayerList = ui.reference('Players', 'Players', 'Player list')
		local ResetAll = ui.reference('Players', 'Players', 'Reset all')
		local ApplyToAll = ui.reference('Players', 'Adjustments', 'Apply to all')

		-- Internal Libary
		PListAdditions.binds = {}
		PListAdditions.defaultValues = {}
		PListAdditions.cache = {}

		PListAdditions.getPlayer = function()
			return ui.get(PlayerList)
		end

		PListAdditions.bind = function(MenuItem, Callback)
			PListAdditions.binds[#PListAdditions.binds + 1 ] = MenuItem
			PListAdditions.defaultValues[MenuItem] = ui.get(MenuItem)
			ui.set_callback(MenuItem, function(item)
				if ( Callback ) then
					Callback(item)
				end
				local Player = PListAdditions.getPlayer()
				printDebug('callbacks, ', Player)
				if ( Player ) then
					PListAdditions.cache[Player] = PListAdditions.cache[Player] or {}
					PListAdditions.cache[Player][item] = ui.get(item)
					printDebug(Player, ' = ', item, ', ', ui.get(item))
				end
			end)
		end

		ui.set_callback(PlayerList, function(item)
			local Player = ui.get(item)
			if ( Player ) then
				PListAdditions.cache[Player] = PListAdditions.cache[Player] or {}

				for index, BindedItem in ipairs(PListAdditions.binds) do
					local Value = PListAdditions.cache[Player][BindedItem]
					printDebug(BindedItem, Value)
					if ( Value == nil ) then
						Value = PListAdditions.defaultValues[BindedItem]
					end
					if ( Value ~= nil ) then
						ui.set(BindedItem, Value)
					end
				end
			end
		end)

		ui.set_callback(ResetAll, function(self)
			for PlayerIndex, SubItems in pairs(PListAdditions.cache) do
				for ItemIndex, ItemValue in pairs(SubItems) do
					ui.set(ItemIndex, PListAdditions.defaultValues[ItemIndex])
				end
			end
			
			PListAdditions.cache = {}
		end)

		ui.set_callback(ApplyToAll, function(self)
			local Player = PListAdditions.getPlayer()
			if ( Player ) then
				PListAdditions.cache[Player] = PListAdditions.cache[Player] or {}

				for OtherPlayer=1, globals.maxplayers() do
					if ( entity.is_enemy(OtherPlayer) ) then
						for index, BindedItem in ipairs(PListAdditions.binds) do
							PListAdditions.cache[OtherPlayer] = PListAdditions.cache[OtherPlayer] or {}
							PListAdditions.cache[OtherPlayer][BindedItem] = ui.get(BindedItem)
						end
					end
				end
			end
			
		end)

		ui.new_label('Players', 'Adjustments', '=---------  [ START $CP Additions  ]  ---------=')

		--#region PList Message Repeater
		local MessageRepeater = {}
		MessageRepeater.repeatMessages = ui.new_checkbox('Players', 'Adjustments', 'Repeat Messages')
		PListAdditions.bind(MessageRepeater.repeatMessages, function(item)
			local Status = ui.get(item)
			local Player = PListAdditions.getPlayer()
			ui.set_visible(MessageRepeater.repeatMethod, ui.get(item))
			ui.set_visible(MessageRepeater.testOutput, ui.get(item))
		end)

		local RepeatMethods = {'Shift Case'}
		for i, v in pairs(style.trans) do
			RepeatMethods[#RepeatMethods + 1] = i
		end
		MessageRepeater.repeatMethod = ui.new_combobox('Players', 'Adjustments', 'Repeat Method', RepeatMethods)

		MessageRepeater.testOutput = ui.new_button('Players', 'Adjustments', 'Print Example', function()
			local Method = ui.get(MessageRepeater.repeatMethod)
			local Message = 'She Sells Seashells on the Seashore'
			
			if ( Method == 'Shift Case' ) then
				Message = changeCase(Message)
			else
				Message = transText(Method, Message)
			end
			
			CPLua.ChatMethods['Local Chat'](' \x07[Message Repeater] \x0A' .. Message)
		end)

		ui.set_visible(MessageRepeater.repeatMethod, false)
		ui.set_visible(MessageRepeater.testOutput, false)

		PListAdditions.bind(MessageRepeater.repeatMethod)

		client.set_event_callback('player_chat', function (e)
			if ( not e.teamonly ) then
				local ent, name, text = e.entity, e.name, e.text
				PListAdditions.cache[ent] = PListAdditions.cache[ent] or {}
				if ( entity.is_enemy(ent) and PListAdditions.cache[ent] ~= nil and PListAdditions.cache[ent][MessageRepeater.repeatMessages] and PListAdditions.cache[ent][MessageRepeater.repeatMethod] ) then
					local Method = PListAdditions.cache[ent][MessageRepeater.repeatMethod]
					local Message = text
					
					if ( Method == 'Shift Case' ) then
						Message = changeCase(text)
					else
						Message = transText(Method, text)
					end
					
					MessageQueue:Say(Message, true)
				end
			end
		end)
		--#endregion

		--#region PList Highlight Target
		if ( Feature.get('Highlight Targets') ) then
			local HighlightTarget = ui.new_checkbox('Players', 'Adjustments', 'Hightlight Player')
			PListAdditions.bind(HighlightTarget)
			local HighlightedEntities = {}
			client.set_event_callback("run_command", function(c)
				HighlightedEntities = {}
				for _, Entity in ipairs(entity.get_players(true)) do
					PListAdditions.cache[Entity] = PListAdditions.cache[Entity] or {}
					if ( PListAdditions.cache[Entity][HighlightTarget] ) then
						table.insert(HighlightedEntities, Entity)
						entity.set_prop(Entity, "m_flDetectedByEnemySensorTime", 1e6)
					else
						entity.set_prop(Entity, "m_flDetectedByEnemySensorTime", 0)
					end
				end
			end)

			client.set_event_callback("paint", function()
				for _, v in pairs(HighlightedEntities) do
					local bounding_box = {entity.get_bounding_box(v)}
					if #bounding_box == 5 and bounding_box[5] ~= 0 then
						local center = bounding_box[1]+(bounding_box[3]-bounding_box[1])/2
						renderer.text(center, bounding_box[2]-18, 255, 255, 0, 255*bounding_box[5], "c", 0, "WARNING!")
					end
				end
			end)
		end
		--#endregion

		--#region Mark As Legit
		if ( Feature.get('Whitelist Friends on Key') ) then
			PListAdditions.MarkAsLegit = ui.new_checkbox('Players', 'Adjustments', 'Mark as Legit')
			PListAdditions.bind(PListAdditions.MarkAsLegit)

			client.set_event_callback("paint", function()
				local KeyState, Key = ui.get(CPLua.WhitelistLegitsOnKey.hotkey)

				if ( ui.get(CPLua.WhitelistLegitsOnKey.enable) and KeyState ) then
					renderer.indicator(255, 255, 255, 255, 'WHITELISTED LEGITS')
				end
			end)
		end
		--#endregion
		
		ui.new_label('Players', 'Adjustments', '=---------  [  END $CP Additions  ]  ---------=')

		client.set_event_callback('cs_win_panel_match', function(e)
			PListAdditions.cache = {}
		end)

		panorama_events.register_event('ShowAcceptPopup', function(data)
			PListAdditions.cache = {}
		end)
	end
	--#endregion
end

--#region Utilities and Libraries

--#region MessageQueue
MessageQueue = {}
MessageQueue.pending = {}

function MessageQueue:Say(message, priority)
	local Sanitized = message:gsub('"', ''):gsub(';', '')
	local Data = {'say "', Sanitized, '";'}
	table.insert(self.pending, Priority and 1 or Data)
end

function MessageQueue:SayTeam(message, priority)
	local Sanitized = message:gsub('"', ''):gsub(';', '')
	local Data = {'say_team "', Sanitized, '";'}
	table.insert(self.pending, Priority and 1 or Data)
end

local LastTick = globals.realtime()
client.set_event_callback('post_render', function()
    if ( globals.realtime() - LastTick > 0.725 + client.latency() ) then
        local NextMessage = MessageQueue.pending[1]
        if ( NextMessage ) then
            client.exec(unpack(NextMessage))
            table.remove(MessageQueue.pending, 1)
			LastTick = globals.realtime()
        end
    end
end)
--#endregion 

local Keys = {
	'5DA40A4A4699DEE30C1C9A7BCE84C914',
	'5970533AA2A0651E9105E706D0F8EDDC',
	'2B3382EBA9E8C1B58054BD5C5EE1C36A'
}
local KeyIndex = 0
function RandomWebKey()
	KeyIndex = KeyIndex < #Keys and KeyIndex + 1 or 1
	return Keys[KeyIndex]
end

function processTags(str, vars)
	if not vars then
		vars = str
		str = vars[1]
	end

    local out = str
    -- Process Single Tags
    out = string.gsub(out, "({([^}]+)})",
        function(whole,i, flags, test) 
            return vars[i:lower()] or whole
        end
    )
    -- Process Special flags
    out = string.gsub(out, '({([^}]+):(%w*)})',
        function(whole,i, flags, test)
            local out = vars[i:lower()]
            if out and type(flags) == 'string' and flags:len() > 0 then
                local Flags = flags:lower()
                if Flags:find('i') then
                    out = out:lower()
                end
                if Flags:find('u') then
                    out = out:upper()
                end
                if Flags:find('s') then
                    out = out:gsub('%s+', '')
                end
                if Flags:find('h') then
                    out = out:gsub('[-]+', '')
                end
                if Flags:find('n') then
                    out = out:gsub('%d+', '')
                end
                if Flags:find('%d') then
                    local index = tonumber(string.match(Flags, '%d'))
                    local words = {}
                    for word in out:gmatch("%w+") do table.insert(words, word) end
                    if index <= #words then
                        out = words[index]
                    end
                end
            end
            return out or whole
        end
    )

	return out
end

function printDebug(...)
	if ( not Options.debugMode ) then return end
	-- print('[$CP]', ...)
end

function esc(x)
	return (x:gsub('%%', '%%%%'):gsub('^%^', '%%^'):gsub('%$$', '%%$'):gsub('%(', '%%('):gsub('%)', '%%)'):gsub('%.', '%%.'):gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%*', '%%*'):gsub('%+', '%%+'):gsub('%-', '%%-'):gsub('%?', '%%?'))
end

function getRankShortName(LongRankName)
	if not LongRankName then return false end
	local RomanNumerals = {'III', 'II', 'I'}
	local Rank = LongRankName:gsub('The ', ' '):gsub('%l', '')
	for RomanIndex = 1, #RomanNumerals do
		if ( Rank:find(RomanNumerals[RomanIndex]) ) then
		Rank = Rank:gsub(RomanNumerals[RomanIndex], #RomanNumerals + 1 - RomanIndex)
		end
		Rank = Rank:gsub(' ', '')
	end
	return Rank
end

--[[ This gives me bad vibes, disabling this feature for a hot minute.
local LastDOWNState = false
local LastUPState = false
client.set_event_callback('post_render', function()
	local DOWNKeyState = client.key_state(0x28)
	if ( DOWNKeyState ~= LastDOWNState ) then
		if ( DOWNKeyState ) then
			CPPanoramaMainMenu.NextMessage()
		end
		LastDOWNState = DOWNKeyState
	end

	local UPKeyState = client.key_state(0x26)
	if ( UPKeyState ~= LastUPState ) then
		if ( UPKeyState ) then
			CPPanoramaMainMenu.PreviousMessage()
		end
		LastUPState = UPKeyState
	end
end)
]]

-- url encode / decode
local char_to_hex = function(c)
	return string.format("%%%02X", string.byte(c))
end

function urlencode(url)
	if url == nil then
		return
	end
	url = url:gsub("\n", "\r\n")
	url = url:gsub("([^%w ])", char_to_hex)
	url = url:gsub(" ", "+")
	return url
end

local hex_to_char = function(x)
	return string.char(tonumber(x, 16))
end

function urldecode(url)
	if url == nil then
		return
	end
	url = url:gsub("+", " ")
	url = url:gsub("%%(%x%x)", hex_to_char)
	return url
end

-- Raw Chat Print (credits to x0m)
if ( Feature.get('Raw Chat Print') ) then
	ffi.cdef[[
		typedef void***(__thiscall* FindHudElement_t)(void*, const char*);
		typedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);
	]]

	local signature_gHud = '\xB9\xCC\xCC\xCC\xCC\x88\x46\x09'
	local signature_FindElement = '\x55\x8B\xEC\x53\x8B\x5D\x08\x56\x57\x8B\xF9\x33\xF6\x39\x77\x28'

	local match = client.find_signature('client_panorama.dll', signature_gHud) or error('sig1 not found') -- returns void***
	local char_match = ffi.cast('char*', match) + 1
	local hud = ffi.cast('void**', char_match)[0] or error('hud is nil') -- returns void**

	match = client.find_signature('client_panorama.dll', signature_FindElement) or error('FindHudElement not found')
	local find_hud_element = ffi.cast('FindHudElement_t', match)
	local hudchat = find_hud_element(hud, 'CHudChat') or error('CHudChat not found')
	local chudchat_vtbl = hudchat[0] or error('CHudChat instance vtable is nil')
	local raw_print_to_chat = chudchat_vtbl[27] -- void*
	local print_to_chat = ffi.cast('ChatPrintf_t', raw_print_to_chat)

	function cp_SendChat(text)
		print_to_chat(hudchat, 0, 0, text)
	end

	local frametimes = {}
	local fps_prev = 0
	local last_update_time = 0
	function AccumulateFps()
		local ft = globals.absoluteframetime()
		if ft > 0 then
			table.insert(frametimes, 1, ft)
		end
		local count = #frametimes
		if count == 0 then
			return 0
		end
		local i, accum = 0, 0
		while accum < 0.5 do
			i = i + 1
			accum = accum + frametimes[i]
			if i >= count then
				break
			end
		end
		accum = accum / i
		while i < count do
			i = i + 1
			table.remove(frametimes)
		end
		local fps = 1 / accum
		local rt = globals.realtime()
		if math.abs(fps - fps_prev) > 4 or rt - last_update_time > 2 then
			fps_prev = fps
			last_update_time = rt
		else
			fps = fps_prev
		end
		return math.ceil(fps + 0.5)
	end
end
--#endregion

--#region User Data Saving
if ( Feature.get('User Data Saving') ) then
	local UserData = database.read('cplua_userdata') or {}
	local stringifySuccess, UserDataJSON = pcall(json.stringify, UserData)
	CPPanoramaMainMenu.SetUserData(stringifySuccess and UserDataJSON or {})

	client.set_event_callback('shutdown', function()
		local parseSuccess, UserData_  = pcall(json.parse, CPPanoramaMainMenu.GetUserData()) 
		database.write('cplua_userdata', parseSuccess_ and UserData_ or {})
	end)
end
--#endregion

-- Cleanup

Initiate()