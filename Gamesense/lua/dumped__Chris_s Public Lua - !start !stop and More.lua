slot0 = require("ffi")
slot1 = require("gamesense/csgo_weapons")
slot2 = require("gamesense/http")
slot4 = require("gamesense/panorama_events")
slot5 = require("gamesense/clipboard")
slot6 = panorama.open()
slot7 = slot6["$"]
slot8 = slot6.CompetitiveMatchAPI
slot9 = slot6.GameStateAPI
slot10 = slot6.FriendsListAPI
slot11 = slot6.GameTypesAPI
slot12 = slot6.PartyListAPI
slot13 = slot6.MyPersonaAPI
slot14 = slot6.LobbyAPI
slot15 = slot6.SteamOverlayAPI
slot16 = slot6.TeammatesAPI
slot17 = require("gamesense/steamworks").ISteamFriends
slot18 = {
	items = {},
	new = function (slot0, slot1)
		slot2 = {
			name = slot0,
			state = slot1,
			state = false
		}

		if uv0[slot0] then
			-- Nothing
		end

		uv1.items[slot0] = slot2

		return slot2
	end,
	get = function (slot0)
		return uv0.items[slot0].state
	end
}
slot19 = database.read("cplua_overrides") or {}

slot18.new("Panorama Libraries", true)
slot18.new("LiveCheck Library", true)
slot18.new("Delayed Auto Accept", true)
slot18.new("Delayed Connect", true)
slot18.new("Auto Accept Detection", true)
slot18.new("Auto Derank Score", true)
slot18.new("Auto Open CsgoStats.gg", false)
slot18.new("Auto Invite Recents", true)
slot18.new("Match Start Beep", true)
slot18.new("Custom Clantag Builder", true)
slot18.new("Custom Killsay Builder", true)
slot18.new("Report Enemy Tool", true)
slot18.new("Account Checkers", true)
slot18.new("Crack Checker", false)
slot18.new("Faceit Checker", true)
slot18.new("Game Value", true)
slot18.new("Inventory Value", true)
slot18.new("Banned Friends", true)
slot18.new("Name History", true)
slot18.new("CSGOStats.gg", true)
slot18.new("Whitelist Friends on Key", true)
slot18.new("Playerlist Additions", true)
slot18.new("Highlight Targets", true)
slot18.new("Dev Report Bot", true)
slot18.new("Party Chat Utils", true)
slot18.new("Chat Commands", true)
slot18.new("Raw Chat Print", true)
slot18.new("User Data Saving", true)

slot20 = nil
slot21 = {}
slot22 = {
	debugMode = false
}

if slot18.get("Panorama Libraries") then
	CPPanoramaMainMenu = panorama.loadstring([[
		$.Schedule(5, $.Msg, 'test')

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
						if (ChatCommand.cmds[0] == 'sus')
							continue;
						const Title = `» ${ChatCommand.title}`;
						const Alias = ChatCommand.cmds;
						Utilities.SayParty(Title);
					}
				} else {
					for ( i=1; i<PartyChatCommands.length; i++ ) {
						let ChatCommand = PartyChatCommands[i];
						if (ChatCommand.cmds[0] == 'sus')
							continue;

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
			title: 'Sus (!\u{200B}Displays a sus Lua Coder)',
			cmds: ['sus'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;

				// todo: sus stuff below
				Utilities.SayParty(`${sender} did you know csmit is a sussy baka? >w<`)
			}
		});
		PartyChatCommands.push({
			title: 'Start Queue (!\u{200B}startq)',
			cmds: ['start', 'startq', 'startqueue', 'queue', 'q'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				if ( !LobbyAPI.BIsHost() ) return;
				
				LobbyAPI.StartMatchmaking(	MyPersonaAPI.GetMyOfficialTournamentName(),
					MyPersonaAPI.GetMyOfficialTeamName(),
					'',
					''
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
					/*let settings = LobbyAPI.IsSessionActive() ? LobbyAPI.GetSessionSettings() : null;
					let stage = '';
					if ( settings && settings.game && settings.options
						&& settings.options.server !== 'listen'
						&& settings.game.mode === 'competitive'
						&& settings.game.mapgroupname.includes( 'mg_lobby_mapveto' ) ) {
						stage = '';
					}*/

					LobbyAPI.StartMatchmaking(	MyPersonaAPI.GetMyOfficialTournamentName(),
						MyPersonaAPI.GetMyOfficialTeamName(),
						'',
						''
					);
				});
			}
		});
		PartyChatCommands.push({
			title: 'Posts a random chuck norris fact (!\u{200B}chucknorris)',
			cmds: ['cfact', 'fact', 'chucknorris'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				$.AsyncWebRequest('https://api.chucknorris.io/jokes/random', {
					type:"GET",
					complete:function(e){
						if ( e.status != 200 ) return;
						let Response = e.responseText.substring(0, e.responseText.length-1);
						let Data = JSON.parse(Response);
						if ( Data ) {
							Utilities.SayParty(Data.value)
						}
					}
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
						//chat_lines.RemoveAndDeleteChildren();
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
						Utilities.SayParty(`You are unable to kick the host!`);
					}
				}
			}
		});
		
		RandNumber = 3
		PartyChatCommands.push({
            title: 'Roll a number between 1 and 6 (!\u{200B}roll)',
            cmds: ['roll'],
            exec: (cmd, args, sender, steamid) => {
                if ( Utilities.IsBlacklisted(steamid) ) return;
                let currentNumber = Math.floor(Math.random() * (6-1)) + 1;
                if (currentNumber == 1 && currentNumber == RandNumber) {
                    Utilities.SayParty(`${sender} rolled a ${currentNumber} ... snake eyes!`)
                } else {
                    Utilities.SayParty(`${sender} rolled a ${currentNumber}`)
				}
                RandNumber = currentNumber;
            }
        });

		PartyChatCommands.push({
            title: 'Am i gay?! (!\u{200B}gay)',
            cmds: ['gay'],
            exec: (cmd, args, sender, steamid) => {
                if ( Utilities.IsBlacklisted(steamid) ) return;
                let currentNumber = Math.floor(Math.random() * (2-0)) + 1;
				if (currentNumber == 2) {
                    Utilities.SayParty(`${sender} is gay`)
				} else {
                    Utilities.SayParty(`${sender} is not gay`)
				}
                RandNumber = currentNumber;
            }
        });

		PartyChatCommands.push({
            title: 'Invades Issue??',
            cmds: ['invades'],
            exec: (cmd, args, sender, steamid) => {
                if ( Utilities.IsBlacklisted(steamid) ) return;
                Utilities.SayParty(`issue`)
            }
        });

		PartyChatCommands.push({
			title: 'check how much the person loves you! (!\u{200B}lovecalc <partial:name>|<steamid>|<friendcode>)',
			cmds: ['lovecalc', 'lc', 'love'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				UserData.mods = UserData.mods || [0];
				if ( typeof args[0] != 'undefined' ) {
					let LoveXUID = Utilities.FindPlayer(args[0]);
					if ( LoveXUID && LobbyAPI.GetHostSteamID() ) {
						let Name = FriendsListAPI.GetFriendName(LoveXUID);
						let currentNumber = ((Number(LoveXUID.substr(3)) + Number(steamid.substr(3)) + 8) % 100) + 1;
						if (currentNumber == 69 && RandNumber)
						Utilities.SayParty(`${Name} loves ${sender} to ${currentNumber}% Nice, haha funny number!`);
					else
						Utilities.SayParty(`${Name} loves ${sender} to ${currentNumber}%`);
						RandNumber = currentNumber;
					}
				}
			}
		});

		PartyChatCommands.push({
			title: 'check your pp size or someone elses! (!\u{200B}ppsize <partial:name>|<steamid>|<friendcode>)',
			cmds: ['ppsize', 'pp'],
			exec: (cmd, args, sender, steamid) => {
				if ( Utilities.IsBlacklisted(steamid) ) return;
				UserData.mods = UserData.mods || [0];
				if ( typeof args[0] != 'undefined' ) {
					let funnypp = Utilities.FindPlayer(args[0]);
					if ( funnypp && LobbyAPI.GetHostSteamID() ) {
						let Name = FriendsListAPI.GetFriendName(funnypp);
						let currentNumber = Math.floor(Math.random() * (30-1)) +1;
						if (currentNumber == 1 && RandNumber)
						Utilities.SayParty(`${Name}'s pp is ${currentNumber}cm >w< so cute`);
					else
						Utilities.SayParty(`${Name}'s pp is ${currentNumber}cm long`);
						RandNumber = currentNumber;
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
										//return el.RemoveAndDeleteChildren();
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
	]], "CSGOMainMenu")()

	if slot18.get("Crack Checker") then
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

	ReconnectBtn = panorama.loadstring([[
		var btnReconnect = $.GetContextPanel().FindChildTraverse( 'MatchmakingReconnect' );

		return {
			set:(text)=>{btnReconnect.text = text},
			reset:()=>{btnReconnect.text = 'RECONNECT'},
			get:()=>btnReconnect.text
		}
	]], "CSGOMainMenu")()

	if slot18.get("LiveCheck Library") then
		client.delay_call(0, function ()
			LiveCheck = {
				datawaiting = {},
				agecheck = {},
				dataready = {},
				buildRichPresence = function (slot0)
					return {
						version = uv0.GetFriendRichPresence(slot0, "version"),
						status = uv0.GetFriendRichPresence(slot0, "status"),
						state = uv0.GetFriendRichPresence(slot0, "game:state"),
						gamemode = uv0.GetFriendRichPresence(slot0, "game:mode"),
						mapgroupname = uv0.GetFriendRichPresence(slot0, "game:mapgroupname"),
						map = uv0.GetFriendRichPresence(slot0, "game:map")
					}
				end
			}

			function LiveCheck.start(slot0, slot1, slot2)
				if not slot1 then
					return
				end

				slot5 = uv0.GetFriendRichPresenceKeyCount(tostring(slot1)) > 0 and LiveCheck.buildRichPresence(slot3) or false
				LiveCheck.datawaiting[slot3] = true

				uv0.RequestFriendRichPresence(slot3)
				client.delay_call(5, function ()
					uv0(uv1, LiveCheck.dataready[uv1] or uv2)
				end)
			end

			uv1.set_callback("FriendRichPresenceUpdate_t", function (slot0)
				if LiveCheck.datawaiting[slot0.m_steamIDFriend:render_steam64()] then
					LiveCheck.dataready[slot1] = LiveCheck.buildRichPresence(slot1)
					LiveCheck.datawaiting[slot1] = false
				end
			end)

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
			]], "CSGOMainMenu")()

			function LiveCheck.loop()
				if not LiveCheck.panorama.getQueue then
					return
				end

				if LiveCheck.panorama.getQueue().length > 0 then
					for slot4 = 0, slot0.length - 1 do
						if slot0[slot4] then
							LiveCheck:start(slot5, function (slot0, slot1)
								LiveCheck.panorama.finished(slot0, slot1)
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
	slot0 = {
		loops = {},
		ChatMethods = {
			["Local Chat"] = function (slot0)
				cp_SendChat(slot0)
			end,
			["Party Chat"] = function (slot0)
				uv0.SessionCommand("Game::Chat", string.format("run all xuid %s chat %s", uv1.GetXuid(), slot0:gsub(" ", " ")))
			end,
			["Game Chat"] = function (slot0)
				MessageQueue:Say(slot0)
			end,
			["Team Chat"] = function (slot0)
				MessageQueue:SayTeam(slot0)
			end,
			Console = function (...)
				print(...)
			end
		},
		Header = ui.new_label("Lua", "B", "=========  [   $CP Start   ]  ========="),
		AutoAccept = {}
	}

	if uv2.get("Delayed Auto Accept") then
		slot0.AutoAccept.originalAutoAccept = ui.reference("MISC", "Miscellaneous", "Auto-accept matchmaking")
		slot0.AutoAccept.enable = ui.new_checkbox("Lua", "B", "Delayed Auto Accept")
		slot0.AutoAccept.delay = ui.new_slider("Lua", "B", "\nAuto Accept Delay", 1, 21, 3, true, "s")

		ui.set_visible(slot0.AutoAccept.delay, false)
		ui.set_callback(slot0.AutoAccept.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.AutoAccept.delay, slot1)

			if slot1 then
				ui.set(uv0.AutoAccept.originalAutoAccept, not slot1)
			end
		end)
		ui.set_callback(slot0.AutoAccept.originalAutoAccept, function (slot0)
			if ui.get(slot0) then
				ui.set(uv0.AutoAccept.enable, false)
			end
		end)

		slot1 = false

		uv3.register_event("ShowAcceptPopup", function (slot0)
			if not ui.get(uv0.AutoAccept.enable) then
				return
			end

			if uv1 and uv1.active then
				uv1:delete()
			end

			uv1 = Timer.set(ui.get(uv0.AutoAccept.delay), function ()
				print("ACCEPT")
				uv0.SetLocalPlayerReady("accept")
			end)
		end)
	end

	if uv2.get("Delayed Connect") then
		slot0.DelayedConnect = {
			enable = ui.new_checkbox("Lua", "B", "Delayed Connect"),
			delay = ui.new_slider("Lua", "B", "\nDelayed Connect Delay", 30, 415, 120, true, "s")
		}

		ui.set_visible(slot0.DelayedConnect.delay, false)
		ui.set_callback(slot0.DelayedConnect.enable, function (slot0)
			ui.set_visible(uv0.DelayedConnect.delay, ui.get(slot0))
		end)

		slot1 = false
		slot2 = false
		slot3 = false

		uv3.register_event("ShowAcceptPopup", function (slot0)
			if not ui.get(uv0.DelayedConnect.enable) then
				return
			end

			uv1 = 0

			print("Count = ", uv1)

			if uv2 and uv2.active then
				uv2:delete()
			end
		end)
		client.set_event_callback("player_connect_full", function (slot0)
			if not uv0 then
				return
			end

			if not uv1.HasOngoingMatch() then
				return
			end

			uv0 = uv0 + 1

			print("Count = ", uv0)

			if uv0 == 1 then
				client.exec("disconnect")
				print("disconnecting, starting timer")

				uv3 = Timer.set(ui.get(uv2.DelayedConnect.delay), function ()
					ReconnectBtn.set("RECONNECT")
					uv0.DerankScore.Reconnect()
					print("Timer Done!")
				end)

				function ()
					if uv0.active then
						ReconnectBtn.set("RECONNECT (" .. math.floor(uv0:remaining()) .. ")")
						client.delay_call(1, uv1)
					end
				end()
				uv4.CloseSession()

				return
			end

			if uv0 == 2 then
				uv3:delete()
				ReconnectBtn.set("RECONNECT")

				uv0 = false
			end
		end)
	end

	if uv2.get("Auto Accept Detection") then
		slot0.AutoAcceptDetection = {
			enable = ui.new_checkbox("Lua", "B", "Auto Accept Detection"),
			output = ui.new_multiselect("Lua", "B", "Output", {
				"Party Chat",
				"On-screen",
				"Console"
			})
		}

		ui.set_visible(slot0.AutoAcceptDetection.output, false)
		ui.set(slot0.AutoAcceptDetection.output, {
			"Party Chat",
			"Console"
		})
		ui.set_callback(slot0.AutoAcceptDetection.enable, function (slot0)
			ui.set_visible(uv0.AutoAcceptDetection.output, ui.get(slot0))
		end)

		slot1 = 1

		function slot2()
			uv0 = 1
		end

		uv3.register_event("ShowAcceptPopup", slot2)
		uv3.register_event("CloseAcceptPopup", slot2)
		uv3.register_event("QueueConnectToServer", slot2)

		slot3 = false
		slot4 = 0
		slot5 = false

		uv3.register_event("PanoramaComponent_Lobby_ReadyUpForMatch", function (slot0, slot1, slot2)
			if slot0 and slot1 == 0 then
				if ui.get(uv0.AutoAcceptDetection.enable) then
					print("Attempt accept")

					uv1 = true

					uv2.SetLocalPlayerReady("accept")
				end
			elseif uv1 and slot1 > 1 then
				for slot6, slot7 in ipairs(ui.get(uv0.AutoAcceptDetection.output)) do
					if slot7 == "Party Chat" then
						uv0.ChatMethods["Party Chat"]("[AUTOACCEPT] Detected " .. slot1 .. " possible auto accepts!")
					end

					if slot7 == "On-screen" then
						uv3 = true
						uv4 = slot1

						client.delay_call(15, function ()
							uv0 = false
							uv1 = 0
						end)
					end

					uv1 = false

					if slot7 == "Console" then
						print("[AUTOACCEPT] Detected " .. slot1 .. " possible auto accepts!")
					end
				end
			end

			uv5 = uv5 + 1

			if not slot0 then
				uv6()
			end
		end)
		client.set_event_callback("paint_ui", function ()
			if uv0 and uv1 > 0 then
				slot0, slot1 = client.screen_size()

				renderer.text(slot0 / 2, slot1 / 2, 255, 0, 0, 255, "+c", 0, "Total auto accepts: " .. uv1)
			end
		end)
	end

	if uv2.get("Auto Derank Score") then
		slot0.DerankScore = {
			enable = ui.new_checkbox("Lua", "B", "Auto Derank Score"),
			delay = ui.new_slider("Lua", "B", "\nAuto Derank Delay", 0, 15, 0, true, "s"),
			method = ui.new_multiselect("Lua", "B", "Method", {
				"On Connect (beta)",
				"Round Prestart",
				"Round Start",
				"During Timeout",
				"Round End"
			})
		}

		ui.set_visible(slot0.DerankScore.method, false)
		ui.set_visible(slot0.DerankScore.delay, false)
		ui.set_callback(slot0.DerankScore.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.DerankScore.method, slot1)
			ui.set_visible(uv0.DerankScore.delay, slot1)
		end)

		function slot0.DerankScore.MethodState(slot0)
			for slot4, slot5 in ipairs(ui.get(uv0.DerankScore.method)) do
				if slot5 == slot0 then
					return true
				end
			end

			return Found
		end

		function slot0.DerankScore.Reconnect()
			if uv0.HasOngoingMatch() then
				client.delay_call(ui.get(uv1.DerankScore.delay), function ()
					client.exec("disconnect")
					uv0.ActionReconnectToOngoingMatch()
				end)
			end
		end

		client.set_event_callback("player_connect_full", function ()
			if ui.get(uv0.DerankScore.enable) and uv0.DerankScore.MethodState("On Connect (beta)") and not uv1.IsGameInWarmup() then
				uv0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_start", function ()
			if ui.get(uv0.DerankScore.enable) and uv0.DerankScore.MethodState("Round Prestart") then
				uv0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_end", function ()
			if entity.is_alive(entity.get_local_player()) and ui.get(uv0.DerankScore.enable) and uv0.DerankScore.MethodState("Round End") then
				uv0.DerankScore.Reconnect()
			end
		end)
		client.set_event_callback("round_freeze_end", function ()
			if entity.is_alive(entity.get_local_player()) and ui.get(uv0.DerankScore.enable) and uv0.DerankScore.MethodState("Round Start") then
				uv0.DerankScore.Reconnect()
			end
		end)

		slot0.DerankScore.Deranking = false

		slot0.loops[#slot0.loops + 1] = function ()
			if not uv0.DerankScore.Deranking and ui.get(uv0.DerankScore.enable) and uv0.DerankScore.MethodState("During Timeout") and uv1.IsGamePaused() and entity.is_alive(entity.get_local_player()) then
				slot1 = 0

				if (entity.get_prop(entity.get_game_rules(), "m_bCTTimeOutActive") == 1 and "CT" or entity.get_prop(entity.get_game_rules(), "m_bTerroristTimeOutActive") == 1 and "T" or false) == "CT" then
					slot1 = entity.get_prop(entity.get_game_rules(), "m_flCTTimeOutRemaining")
				elseif slot0 == "T" then
					slot1 = entity.get_prop(entity.get_game_rules(), "m_flTerroristTimeOutRemaining")
				end

				if slot1 > 0 then
					uv0.DerankScore.Deranking = true

					uv0.DerankScore.Reconnect()
				end
			end
		end

		client.set_event_callback("player_connect_full", function (slot0)
			if entity.get_local_player() == client.userid_to_entindex(slot0.userid) then
				uv0.DerankScore.Deranking = false
			end
		end)
	end

	if uv2.get("Auto Open CsgoStats.gg") then
		slot0.AutoCSGOStats = {
			enable = ui.new_checkbox("Lua", "B", "Auto CSGOStats.gg")
		}

		uv3.register_event("ShowAcceptPopup", function (slot0)
			uv0.AutoCSGOStats.FirstJoin = true

			printDebug("==> I am watching now")
		end)
		uv3.register_event("QueueConnectToServer", function ()
			printDebug("==> Queue Connect To Server", ui.get(uv0.AutoCSGOStats.enable), uv1.HasOngoingMatch())

			if uv0.AutoCSGOStats.FirstJoin and ui.get(uv0.AutoCSGOStats.enable) and uv1.HasOngoingMatch() then
				uv0.AutoCSGOStats.FirstJoin = false

				uv2.OpenExternalBrowserURL("https://csgostats.gg/player/" .. uv3.GetXuid() .. "#/live")
			end
		end)
	end

	if uv2.get("Auto Invite Recents") then
		slot0.InviteRecents = {
			enable = ui.new_checkbox("Lua", "B", "Auto Invite Recents"),
			autostart = ui.new_checkbox("Lua", "B", "Start Queue On Join")
		}

		ui.set_visible(slot0.InviteRecents.autostart, false)
		ui.set_callback(slot0.InviteRecents.enable, function (slot0)
			printDebug(slot0)
			ui.set_visible(uv0.InviteRecents.autostart, ui.get(uv0.InviteRecents.enable))
		end)

		slot1 = ""
		slot2 = false

		uv3.register_event("EndOfMatch_Shutdown", function (slot0)
			uv0 = uv1.GetGameModeName(false)

			if uv0 and uv2.HasOngoingMatch() then
				uv3.InviteRecents.Reinvite = true
				uv3.InviteRecents.SessionReady = false

				if not uv4.IsSessionActive() and ui.get(uv3.InviteRecents.enable) then
					uv4.CreateSession()
					uv5.SessionCommand("MakeOnline", "")

					uv6 = true
				end
			end
		end)
		uv3.register_event("PanoramaComponent_Lobby_MatchmakingSessionUpdate", function (slot0)
			if slot0 == "ready" and uv0 then
				slot1 = {
					update = {
						Game = {}
					}
				}
				slot2 = uv1.GetConfig()

				if uv2 == "Competitive" then
					slot1.update.Game.mode = "competitive"
					slot1.update.Game.type = "classic"
				elseif uv2 == "Wingman" then
					slot1.update.Game.mode = "scrimcomp2v2"
					slot1.update.Game.type = "classic"
				end

				slot1.update.Game.mapgroupname = slot2.gameTypes[slot1.update.Game.type].gameModes[slot1.update.Game.mode].mapgroupsMP

				uv3.UpdateSessionSettings(slot1)

				uv0 = false

				uv4.Refresh()

				uv5.InviteRecents.SessionReady = true
			end
		end)
		uv3.register_event("PanoramaComponent_Teammates_Refresh", function ()
			if not uv0.BIsHost() then
				return
			end

			panorama.loadstring([[
				let Recents = $.GetContextPanel().FindChildTraverse('JsFriendsList-recents').FindChild('JsFriendsList-List' );
				Recents.ScrollToBottom() 
				Recents.ScrollToTop()
			]], "CSGOMainMenu")()

			uv1.InviteRecents.InviteCount = uv2 == "Competitive" and 3 or 0

			if uv1.InviteRecents.Reinvite and uv1.InviteRecents.SessionReady then
				if ui.get(uv1.InviteRecents.enable) then
					for slot3 = 0, uv1.InviteRecents.InviteCount do
						uv4.ActionInviteFriend(uv3.GetXuidByIndex(slot3), "")
					end
				end

				uv1.InviteRecents.Reinvite = false
			end
		end)
		uv3.register_event("PanoramaComponent_Lobby_PlayerJoined", function (slot0)
			if not uv0.BIsHost() then
				return
			end

			slot1 = uv0.GetSessionSettings().members.numSlots

			if ui.get(uv2.InviteRecents.enable) and ui.get(uv2.InviteRecents.autostart) and uv3.GetCount() == (uv1 == "Wingman" and 2 or 5) then
				uv0.StartMatchmaking("", "", "", "")
			end
		end)
	end

	if uv2.get("Match Start Beep") then
		slot0.MatchStartBeep = {
			enable = ui.new_checkbox("Lua", "B", "Match Start Beep"),
			repeatTimes = ui.new_slider("Lua", "B", "Times (x)", 1, 30, 1),
			repeatInterval = ui.new_slider("Lua", "B", "Interval (ms)", 0, 1000, 250, true, "ms")
		}
		slot6 = 0
		slot7 = 100
		slot0.MatchStartBeep.delay = ui.new_slider("Lua", "B", "% of Match Freezetime", slot6, slot7, 75, true, "%")
		slot0.MatchStartBeep.sounds = {
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
		slot1 = {}
		slot2 = {
			[slot7[2]] = slot7[1]
		}

		for slot6, slot7 in pairs(slot0.MatchStartBeep.sounds) do
			slot1[#slot1 + 1] = slot7[2]
		end

		slot0.MatchStartBeep.sounds = ui.new_listbox("Lua", "B", "Sounds", slot1)
		slot0.MatchStartBeep.testsound = ui.new_button("Lua", "B", "Test Sound", function ()
			slot0 = uv0[ui.get(uv1.MatchStartBeep.sounds) + 1]

			printDebug(slot0, ">", uv2[slot0])

			if slot0 and slot0 ~= "" and uv2[slot0] then
				uv1.MatchStartBeep.PlaySound()
			end
		end)

		ui.set_visible(slot0.MatchStartBeep.delay, false)
		ui.set_visible(slot0.MatchStartBeep.sounds, false)
		ui.set_visible(slot0.MatchStartBeep.testsound, false)
		ui.set_visible(slot0.MatchStartBeep.repeatTimes, false)
		ui.set_visible(slot0.MatchStartBeep.repeatInterval, false)
		ui.set_callback(slot0.MatchStartBeep.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.MatchStartBeep.delay, slot1)
			ui.set_visible(uv0.MatchStartBeep.sounds, slot1)
			ui.set_visible(uv0.MatchStartBeep.testsound, slot1)
			ui.set_visible(uv0.MatchStartBeep.repeatTimes, slot1)
			ui.set_visible(uv0.MatchStartBeep.repeatInterval, ui.get(uv0.MatchStartBeep.repeatTimes) ~= 1 and slot1)
		end)

		function slot0.MatchStartBeep.PlaySound()
			if (uv0[ui.get(uv1.MatchStartBeep.sounds) + 1] or "Default (Beep)") and slot0 ~= "" and uv2[slot0] then
				slot2 = ui.get(uv1.MatchStartBeep.repeatInterval)

				if ui.get(uv1.MatchStartBeep.repeatTimes) == 1 then
					uv3.DispatchEvent("PlaySoundEffect", uv2[slot0], "MOUSE")
				else
					for slot6 = 1, slot1 do
						client.delay_call(slot1 == 1 and 0 or (slot6 - 1) * slot2 / 1000, function ()
							printDebug("done")
							uv0.DispatchEvent("PlaySoundEffect", uv1[uv2], "MOUSE")
						end)
					end
				end
			end
		end

		ui.set_callback(slot0.MatchStartBeep.repeatTimes, function (slot0)
			ui.set_visible(uv0.MatchStartBeep.repeatInterval, ui.get(slot0) ~= 1 and ui.get(uv0.MatchStartBeep.enable))
		end)
		client.set_event_callback("round_start", function ()
			if ui.get(uv0.MatchStartBeep.enable) then
				client.delay_call(cvar.mp_freezetime:get_int() * ui.get(uv0.MatchStartBeep.delay) / 100, function ()
					uv0.MatchStartBeep.PlaySound()
				end)
			end
		end)
	end

	if uv2.get("Custom Clantag Builder") then
		slot0.Clantag = {
			last = "",
			enable = ui.new_checkbox("Lua", "B", "Clantag Builder [BETA]"),
			template = ui.new_textbox("Lua", "B", "\nClantag Template"),
			helper1 = ui.new_label("Lua", "B", "Helper: Type { or anything"),
			helper2 = ui.new_label("Lua", "B", "\n"),
			helper3 = ui.new_label("Lua", "B", "\n"),
			helper4 = ui.new_label("Lua", "B", "\n"),
			helper5 = ui.new_label("Lua", "B", "\n"),
			processedData = {},
			data = {
				{
					"rank",
					"competitive ranking",
					300,
					function ()
						if entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", entity.get_local_player()) == 0 then
							return "N/A"
						end

						if slot0 then
							return getRankShortName(uv1.Localize(uv0.GetGameModeInternalName(true) == "survival" and "#skillgroup_" .. slot0 .. "dangerzone" or "RankName_" .. slot0))
						end
					end,
					0
				},
				{
					"wins",
					"competitive wins",
					300,
					function ()
						return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", entity.get_local_player()) or ""
					end,
					0
				},
				{
					"hp",
					"current health",
					0.5,
					function ()
						return entity.get_prop(entity.get_local_player(), "m_iHealth") or 0
					end,
					0
				},
				{
					"amr",
					"current armor",
					0.5,
					function ()
						return entity.get_prop(entity.get_local_player(), "m_ArmorValue") or 0
					end,
					0
				},
				{
					"loc",
					"current location",
					0.5,
					function ()
						return uv0.Localize(entity.get_prop(entity.get_local_player(), "m_szLastPlaceName")) or ""
					end,
					0
				},
				{
					"kills",
					"current kills",
					1,
					function ()
						return entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0
					end,
					0
				},
				{
					"deaths",
					"current deaths",
					1,
					function ()
						return entity.get_prop(entity.get_player_resource(), "m_iDeaths", entity.get_local_player()) or 0
					end,
					0
				},
				{
					"assists",
					"current assists",
					1,
					function ()
						return entity.get_prop(entity.get_player_resource(), "m_iAssists", entity.get_local_player()) or 0
					end,
					0
				},
				{
					"hschance",
					"current headshot chance",
					1,
					function ()
						slot0 = entity.get_local_player()
						slot2 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", entity.get_local_player())

						if uv0.Clantag.processedData.kills and slot2 then
							return math.ceil(slot2 / slot1 * 100)
						end
					end,
					0
				},
				{
					"c4",
					"displays BOMB if carrying bomb",
					1,
					function ()
						uv0.Clantag.last = ""
					end,
					0
				},
				{
					"wep",
					"current weapon name",
					0.25,
					function ()
						if entity.get_player_weapon(entity.get_local_player()) == nil then
							return
						end

						if entity.get_prop(slot1, "m_iItemDefinitionIndex") == nil then
							return
						end

						if uv0[slot2] == nil then
							return
						end

						return slot3.name
					end,
					0
				},
				{
					"ammo",
					"current weapon ammo",
					0.25,
					function ()
						if entity.get_player_weapon(entity.get_local_player()) == nil then
							return
						end

						if entity.get_prop(slot1, "m_iClip1") == nil then
							return
						end

						return slot2
					end,
					0
				},
				{
					"id",
					"current steam id",
					9999,
					function ()
						return uv0.GetXuid()
					end,
					0
				},
				{
					"bomb",
					"bomb timer countdown",
					1,
					function ()
						if entity.get_all("CPlantedC4")[1] == nil or entity.get_prop(slot0, "m_bBombDefused") == 1 or entity.get_local_player() == nil then
							return ""
						end

						return entity.get_prop(slot0, "m_flC4Blow") - globals.curtime() ~= nil and slot1 > 0 and math.floor(slot1) or ""
					end,
					0
				},
				{
					"doa",
					"displays DEAD or ALIVE",
					0.5,
					function ()
						return entity.is_alive(entity.get_local_player()) and "ALIVE" or "DEAD"
					end,
					0
				},
				{
					"fps",
					"current FPS",
					0.05,
					function ()
						return AccumulateFps()
					end,
					0
				},
				{
					"ping",
					"current ping",
					0.5,
					function ()
						return math.floor(client.latency() * 1000)
					end,
					0
				},
				{
					"date",
					"current date (DD/MM/YY)",
					300,
					function ()
						slot0 = Date(client.unix_time())

						return string.format("%s/%s/%s", string.format("%02d", slot0.getDate()), string.format("%02d", slot0.getMonth() + 1), tostring(slot0.getFullYear()):sub(3, 4))
					end,
					0
				},
				{
					"shortday",
					"current name of the day (Mon, Wed, Tue)",
					300,
					function ()
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
					function ()
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
					function ()
						return string.format("%02d", Date(client.unix_time()).getDate())
					end,
					0
				},
				{
					"month",
					"current month number",
					300,
					function ()
						return string.format("%02d", Date(client.unix_time()).getMonth() + 1)
					end,
					0
				},
				{
					"year",
					"current year number",
					300,
					function ()
						return tostring(Date(client.unix_time()).getFullYear()):sub(3, 4)
					end,
					0
				},
				{
					"time12",
					"current time in 12 hour time",
					1,
					function ()
						return string.format("%s:%s:%s %s", string.format("%02d", slot1 > 12 and slot1 - 12 or slot1), string.format("%02d", slot0.getMinutes()), string.format("%02d", slot0.getSeconds()), Date(client.unix_time()).getHours() > 12 and "PM" or "AM")
					end,
					0
				},
				{
					"time24",
					"current time in 24 hour time",
					1,
					function ()
						slot0 = Date(client.unix_time())

						return string.format("%s:%s:%s", string.format("%02d", slot0.getHours()), string.format("%02d", slot0.getMinutes()), string.format("%02d", slot0.getSeconds()))
					end,
					0
				},
				{
					"hour12",
					"hour in 12 hour time",
					1,
					function ()
						return string.format("%02d", Date(client.unix_time()).getHours() > 12 and slot1 - 12 or slot1)
					end,
					0
				},
				{
					"hour24",
					"hour in 24 hour time",
					1,
					function ()
						return Date(client.unix_time()).getHours()
					end,
					0
				},
				{
					"mins",
					"current minutes in system time",
					1,
					function ()
						return string.format("%02d", Date(client.unix_time()).getMinutes())
					end,
					0
				},
				{
					"secs",
					"current seconds in system time",
					1,
					function ()
						return string.format("%02d", Date(client.unix_time()).getSeconds())
					end,
					0
				},
				{
					"timesuffix",
					"12 hour time suffix",
					1,
					function ()
						return Date(client.unix_time()).getHours() > 12 and "PM" or "AM"
					end,
					0
				}
			}
		}

		ui.set_visible(slot0.Clantag.template, false)
		ui.set_visible(slot0.Clantag.helper1, false)
		ui.set_visible(slot0.Clantag.helper2, false)
		ui.set_visible(slot0.Clantag.helper3, false)
		ui.set_visible(slot0.Clantag.helper4, false)
		ui.set_visible(slot0.Clantag.helper5, false)

		slot1 = false

		client.set_event_callback("pre_config_load", function ()
			uv0 = true
		end)
		client.set_event_callback("post_config_load", function ()
			uv0 = false
		end)
		ui.set_callback(slot0.Clantag.enable, function (slot0)
			if not ui.get(slot0) and not uv0 then
				client.set_clan_tag(" ")
			end

			uv1.Clantag.last = ""

			ui.set_visible(uv1.Clantag.template, slot1)
			ui.set(uv1.Clantag.helper1, "Helper: type { to get suggestions")
			ui.set_visible(uv1.Clantag.helper1, slot1)
			ui.set_visible(uv1.Clantag.helper2, false)
			ui.set_visible(uv1.Clantag.helper3, false)
			ui.set_visible(uv1.Clantag.helper4, false)
			ui.set_visible(uv1.Clantag.helper5, false)
		end)

		slot2 = ui.get(slot0.Clantag.template)

		client.set_event_callback("post_render", function ()
			if ui.get(uv0.Clantag.template) ~= uv1 then
				uv1 = slot0

				if slot0:match("{(%a*%d*)$") then
					slot2 = false

					if slot1:len() > 0 then
						for slot6, slot7 in ipairs(uv0.Clantag.data) do
							if slot7[1]:sub(1, slot1:len()) == slot1:lower() then
								slot2 = slot7

								break
							end
						end

						if slot2 then
							ui.set(uv0.Clantag.helper1, "{" .. slot2[1] .. "} - " .. slot2[2])
						else
							ui.set(uv0.Clantag.helper1, "no matches found for {" .. slot1 .. "}")
						end

						ui.set_visible(uv0.Clantag.helper2, false)
						ui.set_visible(uv0.Clantag.helper3, false)
						ui.set_visible(uv0.Clantag.helper4, false)
						ui.set_visible(uv0.Clantag.helper5, false)
					else
						slot3 = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {}
						}
						slot4 = {}

						for slot8, slot9 in ipairs(uv0.Clantag.data) do
							slot4[#slot4 + 1] = slot9[1]
						end

						for slot8 = 1, 7 do
							if slot4[slot8] then
								slot3.helper1[#slot3.helper1 + 1] = slot9
							end
						end

						for slot8 = 8, 14 do
							if slot4[slot8] then
								slot3.helper2[#slot3.helper2 + 1] = slot9
							end
						end

						for slot8 = 15, 21 do
							if slot4[slot8] then
								slot3.helper3[#slot3.helper3 + 1] = slot9
							end
						end

						for slot8 = 22, 28 do
							if slot4[slot8] then
								slot3.helper4[#slot3.helper4 + 1] = slot9
							end
						end

						for slot8 = 29, 35 do
							if slot4[slot8] then
								slot3.helper5[#slot3.helper5 + 1] = slot9
							end
						end

						ui.set(uv0.Clantag.helper1, table.concat(slot3.helper1, ", "))
						ui.set(uv0.Clantag.helper2, table.concat(slot3.helper2, ", "))
						ui.set(uv0.Clantag.helper3, table.concat(slot3.helper3, ", "))
						ui.set(uv0.Clantag.helper4, table.concat(slot3.helper4, ", "))
						ui.set(uv0.Clantag.helper5, table.concat(slot3.helper5, ", "))
						ui.set_visible(uv0.Clantag.helper1, #slot3.helper1 > 0)
						ui.set_visible(uv0.Clantag.helper2, #slot3.helper2 > 0)
						ui.set_visible(uv0.Clantag.helper3, #slot3.helper3 > 0)
						ui.set_visible(uv0.Clantag.helper4, #slot3.helper4 > 0)
						ui.set_visible(uv0.Clantag.helper5, #slot3.helper5 > 0)
					end
				else
					ui.set(uv0.Clantag.helper1, "Helper: " .. slot0 .. "_")
					ui.set_visible(uv0.Clantag.helper2, false)
					ui.set_visible(uv0.Clantag.helper3, false)
					ui.set_visible(uv0.Clantag.helper4, false)
					ui.set_visible(uv0.Clantag.helper5, false)
				end
			end
		end)

		slot0.loops[#slot0.loops + 1] = function ()
			if not ui.get(uv0.Clantag.enable) then
				return
			end

			if not entity.get_local_player() then
				return
			end

			for slot3, slot4 in ipairs(uv0.Clantag.data) do
				slot6 = slot4[2]
				slot7 = slot4[3]

				if slot4[5] < globals.curtime() then
					if slot4[4]() == nil then
						uv0.Clantag.processedData[slot4[1]] = ""
					elseif slot9 then
						uv0.Clantag.processedData[slot5] = slot9
					end

					slot4[5] = globals.curtime() + slot7
				end
			end

			if uv0.Clantag.last ~= processTags(ui.get(uv0.Clantag.template), uv0.Clantag.processedData) and slot0 ~= "" then
				client.set_clan_tag(slot0)

				uv0.Clantag.last = slot0
			end
		end

		client.set_event_callback("player_connect_full", function ()
			uv0.Clantag.last = ""

			for slot3, slot4 in ipairs(uv0.Clantag.data) do
				slot4[5] = 0
			end
		end)
		client.set_event_callback("round_start", function ()
			uv0.Clantag.last = ""
		end)
	end

	if uv2.get("Custom Killsay Builder") then
		slot0.CustomKillSay = {
			enable = ui.new_checkbox("Lua", "B", "Killsay Builder [BETA]"),
			template = ui.new_textbox("Lua", "B", "\nKillsay Template"),
			helper1 = ui.new_label("Lua", "B", "Helper: type { to get suggestions"),
			helper2 = ui.new_label("Lua", "B", "\n"),
			helper3 = ui.new_label("Lua", "B", "\n"),
			helper4 = ui.new_label("Lua", "B", "\n"),
			helper5 = ui.new_label("Lua", "B", "\n"),
			helper6 = ui.new_label("Lua", "B", "\n"),
			helper7 = ui.new_label("Lua", "B", "\n"),
			processedData = {}
		}

		ui.set_visible(slot0.CustomKillSay.template, false)
		ui.set_visible(slot0.CustomKillSay.helper1, false)
		ui.set_visible(slot0.CustomKillSay.helper2, false)
		ui.set_visible(slot0.CustomKillSay.helper3, false)
		ui.set_visible(slot0.CustomKillSay.helper4, false)
		ui.set_visible(slot0.CustomKillSay.helper5, false)
		ui.set_visible(slot0.CustomKillSay.helper6, false)
		ui.set_visible(slot0.CustomKillSay.helper7, false)
		ui.set_callback(slot0.CustomKillSay.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.CustomKillSay.template, slot1)
			ui.set(uv0.CustomKillSay.helper1, "Helper: type { to get suggestions")
			ui.set_visible(uv0.CustomKillSay.helper1, slot1)
			ui.set_visible(uv0.CustomKillSay.helper2, false)
			ui.set_visible(uv0.CustomKillSay.helper3, false)
			ui.set_visible(uv0.CustomKillSay.helper4, false)
			ui.set_visible(uv0.CustomKillSay.helper5, false)
			ui.set_visible(uv0.CustomKillSay.helper6, false)
			ui.set_visible(uv0.CustomKillSay.helper7, false)
		end)

		slot1 = {
			{
				"vname",
				"victims kills",
				function (slot0, slot1)
					return entity.get_player_name(slot0)
				end
			},
			{
				"myname",
				"victims kills",
				function (slot0, slot1)
					return entity.get_player_name(slot1)
				end
			},
			{
				"vuserid",
				"victims userid",
				function (slot0, slot1, slot2, slot3)
					return slot2
				end
			},
			{
				"myuserid",
				"my userid",
				function (slot0, slot1, slot2, slot3)
					return slot3
				end
			},
			{
				"ventid",
				"victims entity id",
				function (slot0, slot1, slot2, slot3)
					return slot0
				end
			},
			{
				"myentid",
				"victims entity id",
				function (slot0, slot1, slot2, slot3)
					return slot1
				end
			},
			{
				"myname",
				"victims kills",
				function (slot0, slot1)
					return entity.get_player_name(slot1)
				end
			},
			{
				"vdeaths",
				"victims deaths",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iDeaths", slot0) + 1 or 0
				end
			},
			{
				"vkills",
				"victims kills",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iKills", slot0) or 0
				end
			},
			{
				"vassists",
				"victims assists",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iAssists", slot0) or 0
				end
			},
			{
				"mykills",
				"my kills",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0
				end
			},
			{
				"mydeaths",
				"my kills",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iDeaths", entity.get_local_player()) or 0
				end
			},
			{
				"myassists",
				"my kills",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iAssists", entity.get_local_player()) or 0
				end
			},
			{
				"vrank",
				"victims competitive ranking",
				function (slot0, slot1)
					if entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", slot0) == 0 then
						return "N/A"
					end

					if slot2 then
						return getRankShortName(uv1.Localize(uv0.GetGameModeInternalName(true) == "survival" and "#skillgroup_" .. slot2 .. "dangerzone" or "RankName_" .. slot2))
					end
				end
			},
			{
				"myrank",
				"my competitive ranking",
				function (slot0, slot1)
					if entity.get_prop(entity.get_player_resource(), "m_iCompetitiveRanking", entity.get_local_player()) == 0 then
						return "N/A"
					end

					if slot2 then
						return getRankShortName(uv1.Localize(uv0.GetGameModeInternalName(true) == "survival" and "#skillgroup_" .. slot2 .. "dangerzone" or "RankName_" .. slot2))
					end
				end
			},
			{
				"vwins",
				"victims competitive wins",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", slot0) or ""
				end
			},
			{
				"mywins",
				"my competitive wins",
				function (slot0, slot1)
					return entity.get_prop(entity.get_player_resource(), "m_iCompetitiveWins", entity.get_local_player()) or ""
				end
			},
			{
				"vhp",
				"my current health",
				function (slot0, slot1)
					return entity.get_prop(slot0, "m_iHealth") or 0
				end
			},
			{
				"myhp",
				"my current health",
				function (slot0, slot1)
					return entity.get_prop(entity.get_local_player(), "m_iHealth") or 0
				end
			},
			{
				"vamr",
				"victim current armor",
				function (slot0, slot1)
					return entity.get_prop(slot0, "m_ArmorValue") or 0
				end
			},
			{
				"myamr",
				"current armor",
				function (slot0, slot1)
					return entity.get_prop(entity.get_local_player(), "m_ArmorValue") or 0
				end
			},
			{
				"vloc",
				"victim current location",
				function (slot0, slot1)
					return uv0.Localize(entity.get_prop(slot0, "m_szLastPlaceName")) or ""
				end
			},
			{
				"myloc",
				"current location",
				function (slot0, slot1)
					return uv0.Localize(entity.get_prop(entity.get_local_player(), "m_szLastPlaceName")) or ""
				end
			},
			{
				"vheadchance",
				"victim current headshot chance",
				function (slot0, slot1)
					slot3 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", slot0) or 0

					if (entity.get_prop(entity.get_player_resource(), "m_iKills", slot0) or 0) and slot3 then
						return math.ceil(slot3 / slot2 * 100)
					end
				end
			},
			{
				"myheadchance",
				"current headshot chance",
				function (slot0, slot1)
					slot3 = entity.get_prop(entity.get_player_resource(), "m_iMatchStats_HeadShotKills_Total", entity.get_local_player())

					if (entity.get_prop(entity.get_player_resource(), "m_iKills", entity.get_local_player()) or 0) and slot3 then
						return math.ceil(slot3 / slot2 * 100)
					end
				end
			},
			{
				"mywep",
				"current weapon name",
				function (slot0, slot1)
					if entity.get_player_weapon(entity.get_local_player()) == nil then
						return
					end

					if entity.get_prop(slot3, "m_iItemDefinitionIndex") == nil then
						return
					end

					if uv0[slot4] == nil then
						return
					end

					return slot5.name
				end
			},
			{
				"vwep",
				"current weapon name",
				function (slot0, slot1)
					if entity.get_prop(uv0.CustomKillSay.vwep[slot0], "m_iItemDefinitionIndex") == nil then
						return
					end

					if uv1[slot3] == nil then
						return
					end

					return slot4.name
				end
			},
			{
				"ammo",
				"current weapon ammo",
				function (slot0, slot1)
					if entity.get_player_weapon(entity.get_local_player()) == nil then
						return
					end

					if entity.get_prop(slot3, "m_iClip1") == nil then
						return
					end

					return slot4
				end
			},
			{
				"vsteam64",
				"victim steam id",
				function (slot0, slot1)
					return uv0.GetPlayerXuidStringFromEntIndex(slot0)
				end
			},
			{
				"mysteam64",
				"my steam id",
				function (slot0, slot1)
					return uv0.GetXuid()
				end
			},
			{
				"bomb",
				"bomb timer countdown",
				function (slot0, slot1)
					if entity.get_all("CPlantedC4")[1] == nil or entity.get_prop(slot2, "m_bBombDefused") == 1 or entity.get_local_player() == nil then
						return ""
					end

					return entity.get_prop(slot2, "m_flC4Blow") - globals.curtime() ~= nil and slot3 > 0 and math.floor(slot3) or ""
				end
			},
			{
				"doa",
				"displays DEAD or ALIVE",
				function (slot0, slot1)
					return entity.is_alive(entity.get_local_player()) and "ALIVE" or "DEAD"
				end
			},
			{
				"ping",
				"current ping",
				function (slot0, slot1)
					return math.floor(client.latency() * 1000)
				end
			},
			{
				"date",
				"current date (DD/MM/YY)",
				function (slot0, slot1)
					slot2 = Date(client.unix_time())

					return string.format("%s/%s/%s", string.format("%02d", slot2.getDate()), string.format("%02d", slot2.getMonth() + 1), tostring(slot2.getFullYear()):sub(3, 4))
				end
			},
			{
				"shortday",
				"current name of the day (Mon, Wed, Tue)",
				function (slot0, slot1)
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
				function (slot0, slot1)
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
				function (slot0, slot1)
					return string.format("%02d", Date(client.unix_time()).getDate())
				end
			},
			{
				"month",
				"current month number",
				function (slot0, slot1)
					return string.format("%02d", Date(client.unix_time()).getMonth() + 1)
				end
			},
			{
				"year",
				"current year number",
				function (slot0, slot1)
					return tostring(Date(client.unix_time()).getFullYear()):sub(3, 4)
				end
			},
			{
				"time12",
				"current time in 12 hour time",
				function (slot0, slot1)
					return string.format("%s:%s:%s %s", string.format("%02d", slot3 > 12 and slot3 - 12 or slot3), string.format("%02d", slot2.getMinutes()), string.format("%02d", slot2.getSeconds()), Date(client.unix_time()).getHours() > 12 and "PM" or "AM")
				end
			},
			{
				"time24",
				"current time in 24 hour time",
				function (slot0, slot1)
					slot2 = Date(client.unix_time())

					return string.format("%s:%s:%s", string.format("%02d", slot2.getHours()), string.format("%02d", slot2.getMinutes()), string.format("%02d", slot2.getSeconds()))
				end
			},
			{
				"hour12",
				"hour in 12 hour time",
				function (slot0, slot1)
					return string.format("%02d", Date(client.unix_time()).getHours() > 12 and slot3 - 12 or slot3)
				end
			},
			{
				"hour24",
				"hour in 24 hour time",
				function (slot0, slot1)
					return Date(client.unix_time()).getHours()
				end
			},
			{
				"mins",
				"current minutes in system time",
				function (slot0, slot1)
					return string.format("%02d", Date(client.unix_time()).getMinutes())
				end
			},
			{
				"secs",
				"current seconds in system time",
				function (slot0, slot1)
					return string.format("%02d", Date(client.unix_time()).getSeconds())
				end
			},
			{
				"timesuffix",
				"12 hour time suffix",
				function (slot0, slot1)
					return Date(client.unix_time()).getHours() > 12 and "PM" or "AM"
				end
			}
		}
		slot0.CustomKillSay.vwep = {}

		client.set_event_callback("run_command", function ()
			for slot3 = 1, globals.maxplayers() do
				if entity.get_prop(slot3, "m_hActiveWeapon") then
					uv0.CustomKillSay.vwep[slot3] = slot4
				end
			end
		end)

		slot2 = ui.get(slot0.CustomKillSay.template)

		client.set_event_callback("post_render", function ()
			if ui.get(uv0.CustomKillSay.template) ~= uv1 then
				uv1 = slot0

				if slot0:match("{(%a*%d*)$") then
					slot2 = false

					if slot1:len() > 0 then
						for slot6, slot7 in ipairs(uv2) do
							if slot7[1]:sub(1, slot1:len()) == slot1:lower() then
								slot2 = slot7

								break
							end
						end

						if slot2 then
							ui.set(uv0.CustomKillSay.helper1, "{" .. slot2[1] .. "} - " .. slot2[2])
						else
							ui.set(uv0.CustomKillSay.helper1, "no matches found for {" .. slot1 .. "}")
						end

						ui.set_visible(uv0.CustomKillSay.helper2, false)
						ui.set_visible(uv0.CustomKillSay.helper3, false)
						ui.set_visible(uv0.CustomKillSay.helper4, false)
						ui.set_visible(uv0.CustomKillSay.helper5, false)
						ui.set_visible(uv0.CustomKillSay.helper6, false)
						ui.set_visible(uv0.CustomKillSay.helper7, false)
					else
						slot3 = {
							helper1 = {},
							helper2 = {},
							helper3 = {},
							helper4 = {},
							helper5 = {},
							helper6 = {},
							helper7 = {}
						}
						slot4 = {}

						for slot8, slot9 in ipairs(uv2) do
							slot4[#slot4 + 1] = slot9[1]
						end

						for slot8 = 1, 7 do
							if slot4[slot8] then
								slot3.helper1[#slot3.helper1 + 1] = slot9
							end
						end

						for slot8 = 8, 14 do
							if slot4[slot8] then
								slot3.helper2[#slot3.helper2 + 1] = slot9
							end
						end

						for slot8 = 15, 21 do
							if slot4[slot8] then
								slot3.helper3[#slot3.helper3 + 1] = slot9
							end
						end

						for slot8 = 22, 28 do
							if slot4[slot8] then
								slot3.helper4[#slot3.helper4 + 1] = slot9
							end
						end

						for slot8 = 29, 35 do
							if slot4[slot8] then
								slot3.helper5[#slot3.helper5 + 1] = slot9
							end
						end

						for slot8 = 36, 42 do
							if slot4[slot8] then
								slot3.helper6[#slot3.helper6 + 1] = slot9
							end
						end

						for slot8 = 43, 49 do
							if slot4[slot8] then
								slot3.helper7[#slot3.helper7 + 1] = slot9
							end
						end

						ui.set(uv0.CustomKillSay.helper1, table.concat(slot3.helper1, ", "))
						ui.set(uv0.CustomKillSay.helper2, table.concat(slot3.helper2, ", "))
						ui.set(uv0.CustomKillSay.helper3, table.concat(slot3.helper3, ", "))
						ui.set(uv0.CustomKillSay.helper4, table.concat(slot3.helper4, ", "))
						ui.set(uv0.CustomKillSay.helper5, table.concat(slot3.helper5, ", "))
						ui.set(uv0.CustomKillSay.helper6, table.concat(slot3.helper6, ", "))
						ui.set(uv0.CustomKillSay.helper7, table.concat(slot3.helper7, ", "))
						ui.set_visible(uv0.CustomKillSay.helper1, #slot3.helper1 > 0)
						ui.set_visible(uv0.CustomKillSay.helper2, #slot3.helper2 > 0)
						ui.set_visible(uv0.CustomKillSay.helper3, #slot3.helper3 > 0)
						ui.set_visible(uv0.CustomKillSay.helper4, #slot3.helper4 > 0)
						ui.set_visible(uv0.CustomKillSay.helper5, #slot3.helper5 > 0)
						ui.set_visible(uv0.CustomKillSay.helper6, #slot3.helper6 > 0)
						ui.set_visible(uv0.CustomKillSay.helper7, #slot3.helper7 > 0)
					end
				else
					ui.set(uv0.CustomKillSay.helper1, "Helper: " .. slot0 .. "_")
					ui.set_visible(uv0.CustomKillSay.helper2, false)
					ui.set_visible(uv0.CustomKillSay.helper3, false)
					ui.set_visible(uv0.CustomKillSay.helper4, false)
					ui.set_visible(uv0.CustomKillSay.helper5, false)
					ui.set_visible(uv0.CustomKillSay.helper6, false)
					ui.set_visible(uv0.CustomKillSay.helper7, false)
				end
			end
		end)
		client.set_event_callback("player_death", function (slot0)
			if not ui.get(uv0.CustomKillSay.enable) then
				return
			end

			if client.userid_to_entindex(slot0.attacker) == entity.get_local_player() and slot2 ~= client.userid_to_entindex(slot0.userid) then
				for slot8, slot9 in ipairs(uv1) do
					slot11 = slot9[2]
				end

				MessageQueue:Say(processTags(ui.get(uv0.CustomKillSay.template), {
					[slot9[1]] = slot9[3](slot3, slot2, slot0.userid, slot0.attacker)
				}))
			end
		end)
	end

	if uv2.get("Report Enemy Tool") then
		slot0.ReportTool = {
			enable = ui.new_checkbox("Lua", "B", "Report Tool")
		}
		slot7 = true
		slot0.ReportTool.hotkey = ui.new_hotkey("Lua", "B", "Report Tool", slot7)
		slot2 = {}
		slot3 = {
			[slot8[2]] = slot8[1]
		}

		for slot7, slot8 in ipairs({
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
		}) do
			slot2[#slot2 + 1] = slot8[2]
		end

		slot0.ReportTool.types = ui.new_multiselect("Lua", "B", "Types", slot2)

		ui.set(slot0.ReportTool.types, {
			"Aim Hacking",
			"Wall Hacking",
			"Other Hacking"
		})

		slot4 = nil

		client.set_event_callback("net_update_end", function ()
			slot0, slot1 = ui.get(uv0.ReportTool.hotkey)

			if slot0 and not ui.is_menu_open() then
				uv1()
			end
		end)

		slot0.ReportTool.submit = ui.new_button("Lua", "B", "Report!", function ()
			if uv0 or not ui.get(uv1.ReportTool.enable) then
				return
			end

			for slot5, slot6 in pairs(ui.get(uv1.ReportTool.types)) do
				slot1 = slot5 == 1 and uv2[slot6] or "" .. "," .. uv2[slot6]
			end

			slot2 = {}

			for slot6 = 1, globals.maxplayers() do
				if uv3.GetPlayerXuidStringFromEntIndex(slot6):len() > 5 and entity.is_enemy(slot6) then
					slot2[#slot2 + 1] = slot7
				end
			end

			for slot6, slot7 in ipairs(slot2) do
				uv0 = true

				client.delay_call((slot6 - 1) * 1, function ()
					uv0.SubmitPlayerReport(uv1, uv2)

					if uv3 == #uv4 then
						client.delay_call(1, function ()
							uv0 = false
						end)
					end
				end)
			end
		end)

		ui.set_callback(slot0.ReportTool.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.ReportTool.types, slot1)
			ui.set_visible(uv0.ReportTool.submit, slot1)
		end)
		ui.set_visible(slot0.ReportTool.types, false)
		ui.set_visible(slot0.ReportTool.submit, false)
	end

	if uv2.get("Account Checkers") then
		slot2 = false

		if uv2.get("Crack Checker") then
			function slot3(slot0, slot1)
				if uv0 == nil then
					uv0 = LolzPanorama.get_data()

					if uv0 ~= nil then
						uv0 = json.parse(tostring(uv0))
					else
						client.delay_call(0.1, uv1, slot0, slot1)

						return
					end
				end

				if uv0 ~= nil then
					uv2.get("https://lolz.guru/market", {
						params = {
							_itemCount = "1",
							_xfResponseType = "json",
							_xfNoRedirect = "1",
							new = true,
							_xfRequestUri = "/market/steam/",
							order_by = "pdate_to_down",
							_formSubmitted = "true",
							category_id = "1",
							user_id = "",
							title = slot0
						},
						headers = {
							Cookie = uv0.cookie
						}
					}, function (slot0, slot1)
						if slot1.status == 200 then
							uv0(slot0, slot1, json.parse(slot1.body))
						else
							uv0(slot0, slot1)
						end
					end)
				end
			end

			function slot4(...)
				if uv0 == nil then
					LolzPanorama.create()
					client.delay_call(0.1, uv1, ...)
				else
					uv1(...)
				end
			end

			({
				registered = {},
				new = function (slot0, slot1, slot2)
					slot3 = {
						name = slot0,
						desc = slot1,
						callback = slot2,
						cache = {},
						start = function (slot0)
						end,
						stop = function (slot0)
						end,
						isRunning = function (slot0)
						end
					}
					uv0.registered[#uv0.registered + 1] = slot3

					return slot3
				end,
				_StartBTN = function ()
					if uv0 then
						return
					end

					uv0 = true
					slot1, slot2 = nil

					for slot6, slot7 in ipairs(uv1.registered) do
						if slot7.name == ui.get(uv1.type) then
							slot1 = slot7
						end
					end

					if slot1 then
						slot3 = ui.get(uv1.target)
						slot4 = {}

						if uv2.IsConnectedOrConnectingToServer() then
							for slot8 = 1, globals.maxplayers() do
								slot10 = uv2.GetPlayerXuidStringFromEntIndex(slot8)
								slot11 = uv2.ArePlayersEnemies(uv2.GetLocalPlayerXuid(), slot10)

								if slot10 and slot10:len() == 17 and (slot3 == "Everyone" or slot3 == "Teammates" and not slot11 or slot3 == "Enemies" and slot11) then
									slot4[#slot4 + 1] = {
										slot10,
										entity.get_player_name(slot8)
									}
								end
							end
						elseif uv3.IsSessionActive() then
							IsLobby = true

							for slot8 = 0, uv4.GetCount() - 1 do
								slot9 = uv4.GetXuidByIndex(slot8)
								slot4[#slot4 + 1] = {
									slot9,
									uv4.GetFriendName(slot9)
								}
							end
						end

						if #slot4 > 0 then
							ui.set(uv1.status, "Status: Checking 0/" .. #slot4 .. "!")

							function DispatchMessageOut(slot0, slot1, slot2)
								ui.set(uv0.status, "Status: Checking " .. slot1 .. "/" .. #slot2 .. "!")

								if uv1.cache[slot0] then
									if uv2.IsConnectedOrConnectingToServer() then
										slot4 = ui.get(uv0.output)
										slot5 = slot3.server

										if slot3.localchat and not slot3.server then
											slot5 = slot3.localchat
											slot4 = "Local Chat"
										end

										uv3.ChatMethods[slot4](slot5)
									elseif slot3.lobby and uv4.IsSessionActive() then
										if ui.get(uv0.output) ~= "Console" then
											slot4 = "Party Chat"
										end

										uv3.ChatMethods[slot4](uv1.cache[slot0].lobby)
									end
								end

								if uv5 == #slot2 then
									uv6 = false

									ui.set(uv0.status, "Status: Finished " .. slot1 .. "/" .. #slot2 .. "!")
								end
							end

							function CheckTarget(slot0)
								if uv0[slot0] then
									slot2 = uv0[slot0][2]

									if uv1.cache[uv0[slot0][1]] then
										DispatchMessageOut(slot1, slot0, uv0)

										uv2 = uv2 + 1

										CheckTarget(uv2)
									else
										uv1.callback(slot1, slot2, function (slot0)
											if slot0 then
												uv0.cache[uv1] = uv0.cache[uv1] or {}
												uv0.cache[uv1].server = slot0.server and "[" .. uv0.name .. "] " .. slot0.server
												uv0.cache[uv1].localchat = slot0.localchat and " [" .. uv0.name .. "] \n" .. slot0.localchat
												uv0.cache[uv1].lobby = slot0.lobby and "[" .. uv0.desc .. "] " .. slot0.lobby
											end

											DispatchMessageOut(uv1, uv2, uv3)

											uv4 = uv4 + 1

											CheckTarget(uv4)
										end, function (slot0)
											if slot0 then
												if uv0.IsConnectedOrConnectingToServer() then
													uv2.ChatMethods[ui.get(uv1.output)](slot0)
												elseif uv3.IsSessionActive() then
													uv2.ChatMethods["Party Chat"](slot0)
												end
											end

											CheckTarget(uv4)
										end, function ()
											uv0 = false

											ui.set(uv1.status, "Status: Finished " .. #uv2 .. "/" .. #uv2 .. "!")
										end, uv1)
									end
								end
							end

							CheckTarget(1)
						end
					end
				end
			}).new("Crack Checker", "CrackCheck", function (slot0, slot1, slot2, slot3, slot4, slot5)
				uv0(slot0, function (slot0, slot1, slot2)
					if slot1.status == 200 then
						slot4 = {}

						for slot9 in slot2.templateHtml:gmatch("(<div id=\"marketItem%-%-.+\">.+class=\"marketIndexItem%-%-topContainer\")") do
							slot4[#slot4 + 1] = {
								slot9:match("<div id=\"marketItem%-%-(%d+)\""),
								math.floor(slot9:match("<span class=\"Value\">(%d+,?.?%d+)</span>"):gsub(",", ".") * 100) / 100
							}
						end

						if #slot4 > 0 then
							slot6 = {
								name = uv0,
								id = uv1,
								times = #slot4,
								price = string.format("%.2f", slot4[1][2]),
								marketid = slot4[1][1]
							}
							slot6.link = "https://lolz.guru/market/" .. slot6.marketid
							slot7 = {}
							slot8 = {}

							for slot12, slot13 in ipairs(slot4) do
								slot7[#slot7 + 1] = slot13[2]
								slot8[#slot8 + 1] = slot13[1]
							end

							slot6.min = math.min(unpack(slot7))
							slot6.max = math.max(unpack(slot7))
							slot6.links = table.concat(slot8, ", ")

							uv2({
								server = processTags("Acc {name} sold {times} times for {price}usd on LolzTeam, market ID: {marketID}", slot6),
								lobby = processTags("Acc {name} - {price}USD - ID: {marketID}", slot6)
							})
						else
							uv2({
								localchat = uv0 .. "'s account was not sold on Lolz.Team."
							})
						end
					else
						uv2({
							localchat = uv0 .. "'s failed to check with Lolz.guru, is Lolz offline?"
						})
					end
				end)
			end)
		end

		if uv2.get("Faceit Checker") then
			slot3 = nil

			slot1.new("Faceit Checker", "FACEIT", function (slot0, slot1, slot2, slot3, slot4, slot5)
				if not uv0 then
					uv1.get("https://api.faceit.com/stats/v1/stats/configuration/csgo", function (slot0, slot1)
						uv0 = json.parse(slot1.body)

						uv1()
					end)

					return
				end

				uv1.get("https://api.faceit.com/search/v1/?limit=3&query=" .. slot0, function (slot0, slot1)
					if slot0 then
						if json.parse(slot1.body) and slot2.payload.players.total_count > 0 then
							slot4 = slot2.payload.players.results[#slot2.payload.players.results]

							uv0.get("https://api.faceit.com/stats/v1/stats/users/" .. ({
								id = slot4.id,
								nickname = slot4.nickname,
								country = slot4.country
							}).id .. "/games/csgo", function (slot0, slot1)
								if not slot0 then
									return uv0()
								end

								if json.parse(slot1.body) then
									slot7 = {
										name = uv2,
										steamid = uv3,
										id = uv4.id,
										user = uv4.nickname,
										country = uv4.country,
										kdratio = uv4.kdratio,
										win = uv4.winratio .. "%",
										hschance = uv4.hschance,
										matches = uv4.matches
									}

									if slot2.lifetime then
										uv4.kdratio = slot2.lifetime[uv1.grouping.main_stats[5]]
										uv4.winratio = slot2.lifetime[uv1.grouping.user_win_rate]
										uv4.hschance = slot2.lifetime[uv1.grouping.main_stats[6]]
										uv4.matches = slot2.lifetime[uv1.grouping.main_stats[1]]
									end

									uv5.get("https://api.faceit.com/users/v1/nicknames/" .. uv4.nickname, function (slot0, slot1)
										if not slot0 then
											return uv0()
										end

										if json.parse(slot1.body) and slot2.result == "OK" then
											if slot2.payload.games and slot2.payload.games.csgo then
												uv1.level = slot2.payload.games.csgo.skill_level or 0
												uv1.elo = slot2.payload.games.csgo.faceit_elo
											end

											uv2({
												server = processTags("{name} has a level {level} FaceIt Account ({user})!", uv1),
												lobby = processTags("{name} - Level: {level} - User: {user}!", uv1)
											})
										end
									end)
								end
							end)
						else
							uv6.ChatMethods["Local Chat"](" [" .. uv7.name .. "] \n" .. uv3 .. "'s account was not found on FaceIT!")
							uv5()
						end

						return
					end

					uv1("No Fucking Clue, dm csmit195#4729 if error persists")
				end)
			end)
		end

		if uv2.get("Inventory Value") then
			slot3 = nil
			slot4 = {
				"",
				"https://api.codetabs.com/v1/proxy/?quest=",
				"https://thingproxy.freeboard.io/fetch/"
			}
			slot5 = 1

			function slot6()
				uv0 = uv0 + 1

				if uv0 > #uv1 then
					uv0 = 1
				end

				print("new proxy: ", uv0, " : ", uv1[uv0])
			end

			slot1.new("Inventory Value", "Inventory", function (slot0, slot1, slot2, slot3, slot4, slot5)
				if not uv0 then
					uv1.get("http://csgobackpack.net/api/GetItemsList/v2/?no_details=1&details=0", {
						network_timeout = 300,
						absolute_timeout = 300
					}, function (slot0, slot1)
						if not slot0 then
							return
						end

						client.delay_call(1, function ()
							uv0 = json.parse(uv1.body)

							client.delay_call(1, uv2)
						end)
					end)

					return
				end

				uv1.get("https://steamcommunity.com/profiles/" .. slot0 .. "/inventory/", function (slot0, slot1)
					if not slot0 or not slot1.body then
						return uv0()
					end

					if slot1.body:match("<div class=\"profile_private_info\">") ~= nil or slot1.body:match("'s inventory is currently private.") ~= nil then
						slot4 = {
							localchat = uv1 .. "'s " .. (slot2 and "profile" or "inventory") .. " is private"
						}
						slot4.lobby = slot4.localchat

						return uv2(slot4)
					end

					print("requesting: ", uv3[uv4] .. "https://steamcommunity.com/profiles/" .. uv5 .. "/inventory/json/730/2")
					uv6.get(uv3[uv4] .. "https://steamcommunity.com/profiles/" .. uv5 .. "/inventory/json/730/2", function (slot0, slot1)
						if not slot0 or not slot1.body then
							uv0()

							return uv1()
						end

						if json.parse(slot1.body) and type(slot2) ~= "userdata" and slot1.body then
							if not slot2.success then
								uv0()

								return client.delay_call(5, uv1)
							end

							slot3 = {}

							for slot8, slot9 in pairs(slot2.rgDescriptions) do
								if slot9.marketable == 1 and uv2.items_list[slot9.market_hash_name] and slot10.price and (slot10.price["30_days"] or slot10.price.all_time) then
									slot4 = 0 + slot11.median
								end
							end

							uv4({
								server = uv3 .. "'s inventory value is worth $" .. string.format("%.2f", slot4) .. "USD",
								lobby = uv3 .. " - Value: $" .. string.format("%.2f", slot4) .. "USD"
							})
						else
							uv0()
							uv1()
						end
					end)
				end)
			end)
		end

		if uv2.get("Game Value") then
			slot1.new("Game Value", "Games", function (slot0, slot1, slot2, slot3, slot4, slot5)
				uv0.get("https://steamid.pro/lookup/" .. slot0, function (slot0, slot1)
					if not slot0 or slot1.status ~= 200 then
						return uv0("error checking " .. uv1)
					end

					if slot1.body:match("<span class=\"number%-price\">$(%d+)</span>") then
						uv3({
							server = uv2 .. "'s account is worth $" .. slot2 .. "!"
						})
					else
						uv0("no price found, wtf? dm csmit195#4729 if the error persists.")
					end
				end)
			end)
		end

		slot1.new("Live Checker", "Games", function (slot0, slot1, slot2, slot3, slot4, slot5)
			LiveCheck:start(slot0, function (slot0, slot1)
				if {} then
					slot2.server = "[LiveCheck] " .. uv0 .. " == " .. slot1.state
				else
					slot2.server = "[LiveCheck] " .. uv0 .. " == No response"
				end

				uv1(slot2)
			end)
		end)

		if uv2.get("Banned Friends") then
			slot1.new("Banned Friends", "Banned", function (slot0, slot1, slot2, slot3, slot4, slot5)
				uv0.get("https://steamcommunity.com/profiles/" .. slot0 .. "/friends/", function (slot0, slot1)
					if not slot0 or slot1.status ~= 200 then
						return uv0("failed to check " .. uv1 .. "'s friends, dm csmit195#4729 if error persists")
					end

					slot2 = {}

					for slot6 in slot1.body:gmatch("data%-steamid=\"(%d+)\"") do
						slot2[#slot2 + 1] = slot6
					end

					slot3 = {}

					for slot7, slot8 in ipairs(slot2) do
						slot3[slot9] = slot3[math.floor(slot7 / 100) + 1] or {}
						slot3[slot9][#slot3[slot9] + 1] = slot8
					end

					if #slot3 == 0 then
						return uv2()
					end

					slot4 = 0
					slot5 = 0
					slot6 = false

					for slot10, slot11 in ipairs(slot3) do
						uv3.get("https://api.steampowered.com/ISteamUser/GetPlayerBans/v1/?key=" .. RandomWebKey() .. "&steamids=" .. table.concat(slot11, ","), function (slot0, slot1)
							if not slot0 or slot1.status ~= 200 or uv0 then
								uv0 = true

								return uv1("unknown error, retrying")
							end

							if json.parse(slot1.body) and slot2.players then
								for slot6, slot7 in ipairs(slot2.players) do
									uv2 = uv2 + 1

									if slot7.NumberOfVACBans > 0 or slot7.NumberOfGameBans > 0 then
										uv3 = uv3 + 1
									end

									if uv2 == #uv4 then
										uv6({
											server = uv5 .. " has " .. uv3 .. "/" .. #uv4 .. " banned friends!",
											lobbychat = uv5 .. " - " .. uv3 .. "/" .. #uv4 .. " banned friends!"
										})
									end
								end
							end
						end)
					end
				end)
			end)
		end

		function slot3(slot0)
			slot1 = {}

			if uv0.GetFriendPersonaNameHistory(slot0, 0) ~= "" then
				repeat
					slot1[#slot1 + 1] = slot3
				until uv0.GetFriendPersonaNameHistory(slot0, slot2 + 1) == ""
			end

			return slot1
		end

		if uv2.get("Name History") then
			slot1.new("Name History", "Names", function (slot0, slot1, slot2, slot3, slot4, slot5)
				if #uv0(slot0) > 0 then
					slot7 = {
						server = table.concat(slot6, ", ")
					}
					slot7.lobby = slot7.server

					slot2(slot7)
				else
					slot2()
				end
			end)
		end

		slot1.enable = ui.new_checkbox("Lua", "B", "Account Checkers")
		slot4 = {}

		for slot8, slot9 in ipairs(slot1.registered) do
			slot4[#slot4 + 1] = slot9.name
		end

		if #slot4 == 0 then
			slot4 = {
				"Empty..."
			}
		end

		slot1.type = ui.new_combobox("Lua", "B", "Type", slot4)
		slot1.target = ui.new_combobox("Lua", "B", "Target", {
			"Everyone",
			"Teammates",
			"Enemies"
		})
		slot1.output = ui.new_combobox("Lua", "B", "Output", {
			"Local Chat",
			"Party Chat",
			"Game Chat",
			"Team Chat",
			"Console"
		})

		ui.set(slot1.output, "Local Chat")

		slot1.status = ui.new_label("Lua", "B", "Status: Idle...")
		slot1.check = ui.new_button("Lua", "B", "Check", slot1._StartBTN)

		ui.set_visible(slot1.type, false)
		ui.set_visible(slot1.target, false)
		ui.set_visible(slot1.output, false)
		ui.set_visible(slot1.status, false)
		ui.set_visible(slot1.check, false)
		ui.set_callback(slot1.enable, function (slot0)
			slot1 = ui.get(slot0)

			ui.set_visible(uv0.type, slot1)
			ui.set_visible(uv0.target, slot1)
			ui.set_visible(uv0.output, slot1)
			ui.set_visible(uv0.status, slot1)
			ui.set_visible(uv0.check, slot1)
		end)
	end

	if uv2.get("Whitelist Friends on Key") then
		slot0.WhitelistLegitsOnKey = {
			enable = ui.new_checkbox("Lua", "B", "Whitelist Legits on key"),
			hotkey = ui.new_hotkey("Lua", "B", "Whitelist Legits on key", true)
		}

		client.set_event_callback("run_command", function ()
			slot0, slot1 = ui.get(uv0.WhitelistLegitsOnKey.hotkey)

			for slot5, slot6 in ipairs(entity.get_players(true)) do
				if uv1 and uv1.cache and uv1.cache[slot6] and uv1.cache[slot6][uv1.MarkAsLegit] then
					plist.set(slot6, "Add to whitelist", ui.get(uv0.WhitelistLegitsOnKey.enable) and slot0 and uv1.cache[slot6][uv1.MarkAsLegit])
				end
			end
		end)
		client.register_esp_flag("WHITELISTED", 255, 255, 255, function (slot0)
			slot1, slot2 = ui.get(uv0.WhitelistLegitsOnKey.hotkey)

			if uv1 and uv1.cache and uv1.cache[slot0] and uv1.cache[slot0][uv1.MarkAsLegit] then
				return ui.get(uv0.WhitelistLegitsOnKey.enable) and slot1 and uv1.cache[slot0][uv1.MarkAsLegit]
			end

			return false
		end)
	end

	if uv2.get("Chat Commands") then
		slot0.ChatCommands = {
			enable = ui.new_checkbox("Lua", "B", "In-game Chat Commands")
		}

		ui.set_callback(slot0.ChatCommands.enable, function (slot0)
			ui.set_visible(uv0.ChatCommands.commands, ui.get(slot0))
		end)

		slot1 = {
			register = function (slot0, slot1, slot2, slot3)
				slot4 = {
					name = slot0,
					desc = slot1,
					alias = slot2,
					exec = slot3
				}
				uv0.commands = uv0.commands or {}
				uv0.commands[#uv0.commands + 1] = slot4

				return slot4
			end
		}
		slot2 = {
			register = function (slot0, slot1)
				slot2 = {
					name = slot0,
					hex = slot1
				}
				uv0.colors = uv0.colors or {}
				uv0.colors[#uv0.colors + 1] = slot2

				return slot2
			end,
			fromHex = function (slot0, slot1)
				slot2 = slot1:gsub("#", "")

				for slot6, slot7 in ipairs(uv0.colors) do
					slot8 = slot7.hex:gsub("#", "")

					if slot2:lower() == slot2:lower() then
						return slot7
					end
				end
			end,
			fromName = function (slot0, slot1)
				for slot5, slot6 in ipairs(uv0.colors) do
					if slot6.name:lower() == slot1:lower() then
						return slot6
					end
				end
			end
		}

		slot2.register("yellow", "#F8F62D")
		slot2.register("purple", "#A119F0")
		slot2.register("green", "#00B562")
		slot2.register("blue", "#5CA8FF")
		slot2.register("orange", "#FF9B25")

		function slot3(slot0)
			if not slot0 or type(slot0) ~= "string" or type(slot0) ~= "number" then
				return
			end

			slot1 = nil

			if tonumber(slot0) and client.userid_to_entindex(slot0) then
				slot1 = slot2
			end

			slot2 = uv0:fromName(slot0)

			for slot6 = 1, globals.maxplayers() do
				if slot2 and uv0:fromHex(uv1.GetPlayerColor(uv1.GetPlayerXuidStringFromEntIndex(slot6))) == slot2 then
					slot1 = slot6

					break
				end

				if entity.get_player_name(slot6):lower():find(slot0:lower()) then
					slot1 = slot6

					break
				end
			end

			if slot1 then
				slot4 = {
					xuid = uv1.GetPlayerXuidStringFromEntIndex(slot1),
					entid = slot1,
					name = entity.get_player_name(slot1),
					enemy = uv1.ArePlayersEnemies(uv1.GetLocalPlayerXuid(), SteamXUID)
				}
				slot4.color = uv1.GetPlayerColor(slot4.xuid)

				return slot4
			end
		end

		slot1.register("kick", "call vote kick", {
			"kick",
			"k",
			"votekick",
			"vk"
		}, function (slot0, slot1, slot2)
			slot3 = uv0(slot2[1])

			print("test", slot3)

			if slot3 then
				print("hello...")
				client.exec("callvote ", "kick ", getPlayerInfo(slot3.entid).userid)
			end
		end)
		slot1.register("mute", "mutes the player", {
			"mute",
			"m",
			"silence",
			"ignore",
			"i",
			"block"
		}, function (slot0, slot1, slot2)
			if uv0(slot2[1]) then
				uv1.ToggleMute(slot3.xuid)
			end
		end)
		slot1.register("map", "calls map vote", {
			"map",
			"m",
			"votemap",
			"vm"
		}, function (slot0, slot1, slot2)
			print("test", slot2[1])

			if slot2[1] then
				client.exec("callvote ", "ChangeLevel ", slot2[1])
			end
		end)
		slot1.register("timeout", "calls timeout", {
			"timeout",
			"pause",
			"t",
			"p",
			"calltimeout"
		}, function (slot0, slot1, slot2)
			client.exec("callvote ", "StartTimeOut")
		end)
		slot1.register("surrender", "calls surrender", {
			"forfeit",
			"ff",
			"surrender",
			"surr",
			"giveup",
			"kms",
			"kys"
		}, function (slot0, slot1, slot2)
			client.exec("callvote ", "Surrender")
		end)
		slot1.register("gay", "checks gay status", {
			"gay"
		}, function (slot0, slot1, slot2)
			return slot1 .. " is " .. (math.random(1, 2) == 1 and "gay" or "not gay") .. "!"
		end)
		slot1.register("techtimeout", "leaves for 1 min 45s", {
			"techtimeout",
			"tt"
		}, function (slot0, slot1, slot2)
			if uv0.HasOngoingMatch() then
				client.exec("disconnect")
				client.delay_call(105, function ()
					uv0.ActionReconnectToOngoingMatch()
				end)
			end
		end)

		slot4 = {}
		slot5 = {
			[slot11.name] = slot12
		}
		slot6 = {
			[slot12] = slot11.name
		}

		for slot10, slot11 in ipairs(slot1.commands) do
			slot4[#slot4 + 1] = "!" .. slot11.name .. " - " .. slot11.desc
		end

		slot0.ChatCommands.commands = ui.new_multiselect("Lua", "B", "\n", slot4)

		ui.set(slot0.ChatCommands.commands, {
			slot5.timeout,
			slot5.gay
		})
		ui.set_visible(slot0.ChatCommands.commands, false)
		client.set_event_callback("player_chat", function (slot0)
			if not ui.get(uv0.ChatCommands.enable) then
				return
			end

			slot1 = slot0.entity
			slot2 = slot0.name
			slot4 = entity.get_local_player()
			slot5, slot6 = string.match(slot0.text, "^!(%w+)[%s]?(.*)$")

			if slot5 ~= nil then
				for slot11 in slot6:gmatch("%S+") do
					table.insert({}, slot11)
				end

				slot8 = {
					[uv1[slot13]] = true
				}

				for slot12, slot13 in ipairs(ui.get(uv0.ChatCommands.commands)) do
					-- Nothing
				end

				for slot12, slot13 in ipairs(uv2.commands) do
					if slot8[slot13.name] then
						for slot17, slot18 in ipairs(slot13.alias) do
							if slot18 == slot5:lower() then
								slot19 = slot13.exec(slot1, slot2, slot7)
								slot20 = 0

								if slot4 == slot1 then
									slot20 = 0.75
								end

								client.delay_call(slot20, function ()
									MessageQueue:Say(uv0)
								end)

								break
							end
						end
					end
				end
			end
		end)
	end

	if uv2.get("Party Chat Utils") then
		slot0.PartyChatUtils = {
			enable = ui.new_checkbox("Lua", "B", "In-lobby Chat Commands")
		}

		ui.set(slot0.PartyChatUtils.enable, true)
		function ()
			if ui.get(uv0.PartyChatUtils.enable) then
				CPPanoramaMainMenu.PartyChatLoop()
			end

			client.delay_call(0.25, uv1)
		end()
	end

	slot0.DebugOptions = {
		enable = ui.new_checkbox("Lua", "B", "Debug Mode (console)")
	}

	ui.set_callback(slot0.DebugOptions.enable, function (slot0)
		uv0.debugMode = ui.get(slot0)
	end)

	slot0.Footer = ui.new_label("Lua", "B", "=========  [   $CP Finish   ]  =========")

	client.set_event_callback("paint", function ()
		for slot3, slot4 in ipairs(uv0.loops) do
			slot4()
		end
	end)

	slot1 = {
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

	function transText(slot0, slot1)
		if not uv0.trans[slot0] then
			return slot1
		end

		for slot6 = 1, #slot1 do
			slot2 = "" .. (uv0.trans[slot0][uv0.letters:find(slot1:sub(slot6, slot6))] or slot7)
		end

		return slot2
	end

	function changeCaseWord(slot0)
		slot1 = ""

		for slot5 = 1, #slot0 do
			slot1 = slot5 % 2 == 1 and slot1 .. string.upper(slot0:sub(slot5, slot5)) or slot1 .. string.upper(slot0:sub(slot5, slot5)) .. string.lower(slot0:sub(slot5, slot5))
		end

		return slot1
	end

	function changeCase(slot0)
		slot1 = {}

		for slot5 in slot0:gmatch(".+") do
			slot1[#slot1 + 1] = slot5
		end

		for slot5, slot6 in ipairs(slot1) do
			slot1[slot5] = changeCaseWord(slot6)
		end

		return table.concat(slot1, " ")
	end

	if uv2.get("Playerlist Additions") then
		uv16.binds = {}
		uv16.defaultValues = {}
		uv16.cache = {}

		function uv16.getPlayer()
			return ui.get(uv0)
		end

		function uv16.bind(slot0, slot1)
			uv0.binds[#uv0.binds + 1] = slot0
			uv0.defaultValues[slot0] = ui.get(slot0)

			ui.set_callback(slot0, function (slot0)
				if uv0 then
					uv0(slot0)
				end

				slot1 = uv1.getPlayer()

				printDebug("callbacks, ", slot1)

				if slot1 then
					uv1.cache[slot1] = uv1.cache[slot1] or {}
					uv1.cache[slot1][slot0] = ui.get(slot0)

					printDebug(slot1, " = ", slot0, ", ", ui.get(slot0))
				end
			end)
		end

		ui.set_callback(ui.reference("Players", "Players", "Player list"), function (slot0)
			if ui.get(slot0) then
				uv0.cache[slot1] = uv0.cache[slot1] or {}

				for slot5, slot6 in ipairs(uv0.binds) do
					slot7 = uv0.cache[slot1][slot6]

					printDebug(slot6, slot7)

					if slot7 == nil then
						slot7 = uv0.defaultValues[slot6]
					end

					if slot7 ~= nil then
						ui.set(slot6, slot7)
					end
				end
			end
		end)
		ui.set_callback(ui.reference("Players", "Players", "Reset all"), function (slot0)
			for slot4, slot5 in pairs(uv0.cache) do
				for slot9, slot10 in pairs(slot5) do
					ui.set(slot9, uv0.defaultValues[slot9])
				end
			end

			uv0.cache = {}
		end)
		ui.set_callback(ui.reference("Players", "Adjustments", "Apply to all"), function (slot0)
			if uv0.getPlayer() then
				uv0.cache[slot1] = uv0.cache[slot1] or {}

				for slot5 = 1, globals.maxplayers() do
					if entity.is_enemy(slot5) then
						for slot9, slot10 in ipairs(uv0.binds) do
							uv0.cache[slot5] = uv0.cache[slot5] or {}
							uv0.cache[slot5][slot10] = ui.get(slot10)
						end
					end
				end
			end
		end)
		ui.new_label("Players", "Adjustments", "=---------  [ START $CP Additions  ]  ---------=")

		slot10 = "Repeat Messages"

		uv16.bind(({
			repeatMessages = ui.new_checkbox("Players", "Adjustments", slot10)
		}).repeatMessages, function (slot0)
			slot1 = ui.get(slot0)
			slot2 = uv0.getPlayer()

			ui.set_visible(uv1.repeatMethod, ui.get(slot0))
			ui.set_visible(uv1.testOutput, ui.get(slot0))
		end)

		slot6 = {
			"Shift Case"
		}

		for slot10, slot11 in pairs(slot1.trans) do
			slot6[#slot6 + 1] = slot10
		end

		slot5.repeatMethod = ui.new_combobox("Players", "Adjustments", "Repeat Method", slot6)
		slot5.testOutput = ui.new_button("Players", "Adjustments", "Print Example", function ()
			slot1 = "She Sells Seashells on the Seashore"

			uv1.ChatMethods["Local Chat"](" [Message Repeater] \n" .. ((ui.get(uv0.repeatMethod) ~= "Shift Case" or changeCase(slot1)) and transText(slot0, slot1)))
		end)

		ui.set_visible(slot5.repeatMethod, false)
		ui.set_visible(slot5.testOutput, false)
		uv16.bind(slot5.repeatMethod)
		client.set_event_callback("player_chat", function (slot0)
			if not slot0.teamonly then
				slot2 = slot0.name
				slot3 = slot0.text
				uv0.cache[slot1] = uv0.cache[slot0.entity] or {}

				if entity.is_enemy(slot1) and uv0.cache[slot1] ~= nil and uv0.cache[slot1][uv1.repeatMessages] and uv0.cache[slot1][uv1.repeatMethod] then
					slot5 = slot3

					MessageQueue:Say((uv0.cache[slot1][uv1.repeatMethod] ~= "Shift Case" or changeCase(slot3)) and transText(slot4, slot3), true)
				end
			end
		end)

		if uv2.get("Highlight Targets") then
			uv16.bind(ui.new_checkbox("Players", "Adjustments", "Hightlight Player"))

			slot8 = {}

			client.set_event_callback("run_command", function (slot0)
				uv0 = {}

				for slot4, slot5 in ipairs(entity.get_players(true)) do
					uv1.cache[slot5] = uv1.cache[slot5] or {}

					if uv1.cache[slot5][uv2] then
						table.insert(uv0, slot5)
						entity.set_prop(slot5, "m_flDetectedByEnemySensorTime", 1000000)
					else
						entity.set_prop(slot5, "m_flDetectedByEnemySensorTime", 0)
					end
				end
			end)
			client.set_event_callback("paint", function ()
				for slot3, slot4 in pairs(uv0) do
					if #{
						entity.get_bounding_box(slot4)
					} == 5 and slot5[5] ~= 0 then
						renderer.text(slot5[1] + (slot5[3] - slot5[1]) / 2, slot5[2] - 18, 255, 255, 0, 255 * slot5[5], "c", 0, "WARNING!")
					end
				end
			end)
		end

		if uv2.get("Whitelist Friends on Key") then
			uv16.MarkAsLegit = ui.new_checkbox("Players", "Adjustments", "Mark as Legit")

			uv16.bind(uv16.MarkAsLegit)
			client.set_event_callback("paint", function ()
				slot0, slot1 = ui.get(uv0.WhitelistLegitsOnKey.hotkey)

				if ui.get(uv0.WhitelistLegitsOnKey.enable) and slot0 then
					renderer.indicator(255, 255, 255, 255, "WHITELISTED LEGITS")
				end
			end)
		end

		ui.new_label("Players", "Adjustments", "=---------  [  END $CP Additions  ]  ---------=")
		client.set_event_callback("cs_win_panel_match", function (slot0)
			uv0.cache = {}
		end)
		uv3.register_event("ShowAcceptPopup", function (slot0)
			uv0.cache = {}
		end)
	end
end

Timer = {
	q = {}
}

function Timer.set(slot0, slot1)
	slot3 = {
		expiry = globals.realtime() + slot0,
		callback = slot1,
		duration = slot0,
		active = true,
		update = function (slot0, slot1)
			slot0.expiry = globals.realtime() + slot1
		end,
		increase = function (slot0, slot1)
			slot0.expiry = slot0.expiry + slot1
		end,
		decrease = function (slot0, slot1)
			slot0.expiry = slot0.expiry - slot1
		end,
		reset = function (slot0)
			slot0.expiry = globals.realtime() + slot0.duration
		end,
		delete = function (slot0)
			if not slot0.active then
				return
			end

			slot0.active = false

			table.remove(Timer.q, uv0)
		end,
		remaining = function (slot0)
			return slot0.active and slot0.expiry - globals.realtime() or 0
		end
	}
	Timer.q[#Timer.q + 1] = slot3

	return slot3
end

client.set_event_callback("post_render", function ()
	for slot3 = 1, #Timer.q do
		if Timer.q[slot3].expiry <= globals.realtime() then
			slot4.active = false

			slot4.callback()
			table.remove(Timer.q, slot3)

			break
		end
	end
end)

MessageQueue = {
	pending = {},
	Say = function (slot0, slot1, slot2)
		if slot1 then
			table.insert(slot0.pending, Priority and 1 or {
				"say \"",
				slot1:gsub("\"", ""):gsub(";", ""),
				"\";"
			})
		end
	end,
	SayTeam = function (slot0, slot1, slot2)
		if slot1 then
			table.insert(slot0.pending, Priority and 1 or {
				"say_team \"",
				slot1:gsub("\"", ""):gsub(";", ""),
				"\";"
			})
		end
	end
}
slot23 = globals.realtime()

client.set_event_callback("post_render", function ()
	if globals.realtime() - uv0 > 0.725 + client.latency() and MessageQueue.pending[1] then
		client.exec(unpack(slot0))
		table.remove(MessageQueue.pending, 1)

		uv0 = globals.realtime()
	end
end)

slot24 = {
	"5DA40A4A4699DEE30C1C9A7BCE84C914",
	"5970533AA2A0651E9105E706D0F8EDDC",
	"2B3382EBA9E8C1B58054BD5C5EE1C36A"
}
slot25 = 0

function RandomWebKey()
	uv0 = uv0 < #uv1 and uv0 + 1 or 1

	return uv1[uv0]
end

function processTags(slot0, slot1)
	if not slot1 then
		slot0 = slot0[1]
	end

	return string.gsub(string.gsub(slot0, "({([^}]+)})", function (slot0, slot1, slot2, slot3)
		return uv0[slot1:lower()] or slot0
	end), "({([^}]+):(%w*)})", function (slot0, slot1, slot2, slot3)
		if uv0[slot1:lower()] and type(slot2) == "string" and slot2:len() > 0 then
			if slot2:lower():find("i") then
				slot4 = slot4:lower()
			end

			if slot5:find("u") then
				slot4 = slot4:upper()
			end

			if slot5:find("s") then
				slot4 = slot4:gsub("%s+", "")
			end

			if slot5:find("h") then
				slot4 = slot4:gsub("[-]+", "")
			end

			if slot5:find("n") then
				slot4 = slot4:gsub("%d+", "")
			end

			if slot5:find("%d") then
				slot6 = tonumber(string.match(slot5, "%d"))
				slot7 = {}

				for slot11 in slot4:gmatch("%w+") do
					table.insert(slot7, slot11)
				end

				if slot6 <= #slot7 then
					slot4 = slot7[slot6]
				end
			end
		end

		return slot4 or slot0
	end)
end

function printDebug(...)
	if not uv0.debugMode then
		return
	end
end

function esc(slot0)
	return slot0:gsub("%%", "%%%%"):gsub("^%^", "%%^"):gsub("%$$", "%%$"):gsub("%(", "%%("):gsub("%)", "%%)"):gsub("%.", "%%."):gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%*", "%%*"):gsub("%+", "%%+"):gsub("%-", "%%-"):gsub("%?", "%%?")
end

function getRankShortName(slot0)
	if not slot0 then
		return false
	end

	slot2 = slot0:gsub("The ", " "):gsub("%l", "")

	for slot6 = 1, #{
		"III",
		"II",
		"I"
	} do
		if slot2:find(slot1[slot6]) then
			slot2 = slot2:gsub(slot1[slot6], #slot1 + 1 - slot6)
		end

		slot2 = slot2:gsub(" ", "")
	end

	return slot2
end

function slot26(slot0)
	return string.format("%%%02X", string.byte(slot0))
end

function urlencode(slot0)
	if slot0 == nil then
		return
	end

	return slot0:gsub("\n", "\r\n"):gsub("([^%w ])", uv0):gsub(" ", "+")
end

function slot27(slot0)
	return string.char(tonumber(slot0, 16))
end

function urldecode(slot0)
	if slot0 == nil then
		return
	end

	return slot0:gsub("+", " "):gsub("%%(%x%x)", uv0)
end

slot0.cdef([[
  typedef struct
  {
    int64_t pad_0;
    union {
      int xuid;
      struct {
        int xuidlow;
        int xuidhigh;
      };
    };
    char name[128];
    int userid;
    char guid[33];
    unsigned int friendsid;
    char friendsname[128];
    bool fakeplayer;
    bool ishltv;
    unsigned int customfiles[4];
    unsigned char filesdownloaded;
  } S_playerInfo_t;

  typedef bool(__thiscall* fnGetPlayerInfo)(void*, int, S_playerInfo_t*);
]])

slot29 = slot0.cast("fnGetPlayerInfo", slot0.cast(slot0.typeof("void***"), client.create_interface("engine.dll", "VEngineClient014"))[0][8])

function getPlayerInfo(slot0)
	slot1 = uv0.new("S_playerInfo_t[1]")

	uv1(uv2, slot0, slot1)

	return slot1[0]
end

if slot18.get("Raw Chat Print") then
	slot0.cdef("\t\ttypedef void***(__thiscall* FindHudElement_t)(void*, const char*);\n\t\ttypedef void(__cdecl* ChatPrintf_t)(void*, int, int, const char*, ...);\n\t")

	slot39 = slot0.cast("ChatPrintf_t", ((slot0.cast("FindHudElement_t", client.find_signature("client_panorama.dll", "U\\x8b\\xecS\\x8b]VW\\x8b\\xf93\\xf69w(") or error("FindHudElement not found"))(slot0.cast("void**", slot0.cast("char*", client.find_signature("client_panorama.dll", "\\xb9\\xcc\\xcc\\xcc̈F\t") or error("sig1 not found")) + 1)[0] or error("hud is nil"), "CHudChat") or error("CHudChat not found"))[0] or error("CHudChat instance vtable is nil"))[27])

	function cp_SendChat(slot0)
		uv0(uv1, 0, 0, slot0)
	end

	slot40 = {}
	slot41 = 0
	slot42 = 0

	function AccumulateFps()
		if globals.absoluteframetime() > 0 then
			table.insert(uv0, 1, slot0)
		end

		if #uv0 == 0 then
			return 0
		end

		slot2 = 0
		slot3 = 0

		while slot3 < 0.5 do
			slot2 = slot2 + 1
			slot3 = slot3 + uv0[slot2]

			if slot1 <= slot2 then
				break
			end
		end

		slot3 = slot3 / slot2

		while slot2 < slot1 do
			slot2 = slot2 + 1

			table.remove(uv0)
		end

		slot5 = globals.realtime()

		if math.abs(1 / slot3 - uv1) > 4 or slot5 - uv2 > 2 then
			uv1 = slot4
			uv2 = slot5
		else
			slot4 = uv1
		end

		return math.ceil(slot4 + 0.5)
	end
end

if slot18.get("User Data Saving") then
	slot31, slot32 = pcall(json.stringify, database.read("cplua_userdata") or {})

	CPPanoramaMainMenu.SetUserData(slot31 and slot32 or {})
	client.set_event_callback("shutdown", function ()
		slot0, slot1 = pcall(json.parse, CPPanoramaMainMenu.GetUserData())

		database.write("cplua_userdata", parseSuccess_ and slot1 or {})
	end)
end

Initiate()
