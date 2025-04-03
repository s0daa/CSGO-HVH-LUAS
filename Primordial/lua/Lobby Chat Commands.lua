local panorama = require("primordial/panorama-library.248")

local js = panorama.loadstring([[
    let Prefix = '!';
    let MsgSteamID = false;
    let MySteamID = MyPersonaAPI.GetXuid();
    let UserData = {};
    UserData.mods = [];
    UserData.blacklist = [];
    let MuteUsers = [];
    const Utilities = {};
    Utilities.IsBlacklisted = (SteamXUID) => {
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
        let regex_steamid64 = /(765\d{14})/i;
        let regex_steamid3 = / /i;
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
                Utilities.SayParty(`This player is not found.`)
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
        title: 'Clearchat (!\u{200B}clearchat)',
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
                        UserData.mods = [];
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
                                    Utilities.SayParty(`Cannot add ${FriendName} (${BlacklistXUID}) to blacklist!`)
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
                        UserData.blacklist = [];
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
            let XUID = Utilities.FindPlayer(args[0]);
            if ( XUID ) {
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
            let XUID = Utilities.FindPlayer(args[0]);
            if ( XUID ) {
                let friendName = FriendsListAPI.GetFriendName(XUID);
                if (XUID == MySteamID) {
                    Utilities.SayParty(`You can't mute ${friendName}!`);
                    return;
                }
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
                    Utilities.SayParty(`[PING] My ping is: ${MyPing}`);
                    break;
                case 1:
                    let RequestedPing = Math.trunc(args[0]);
                    if ( RequestedPing == '0' ) {
                        RequestedPing = '0 0 0 4'
                    }
                    GameInterfaceAPI.ConsoleCommand(`${BaseCMD} ${RequestedPing}`)
                    Utilities.SayParty(`[PING] I set ping to: ${RequestedPing}`);
                    break;
                case 2:
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
    let answers_8ball = ["It is certain", "It is decidedly so", "Without a doubt", "Yes - definitely", "You may rely on it", "As I see it, yes", "Most likely", "Outlook good", "Yes", "Signs point to yes", "Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Very doubtful", "Reply hazy, try again", "Ask again later", "Better not tell you now", "Cannot predict now", "Concentrate and ask again"];
    PartyChatCommands.push({
        title: '8ball (!\u{200B}8ball <question>)',
        cmds: ['8ball', '8b'],
        exec: (cmd, args, sender, steamid) => {
            if ( Utilities.IsBlacklisted(steamid) ) return;
            if (args.length == 0) {
                Utilities.SayParty("Please enter a question.");
                return;
            }
            let num = Math.floor(Math.random() * Math.floor(answers_8ball.length));
            Utilities.SayParty(answers_8ball[num]);
        }
    });
    let answers_dice = ["1", "2", "3", "4", "5", "6"];
    PartyChatCommands.push({
        title: 'Dice (!\u{200B}dice)',
        cmds: ['dice', 'd'],
        exec: (cmd, args, sender, steamid) => {
            if ( Utilities.IsBlacklisted(steamid) ) return;
            let num = Math.floor(Math.random() * Math.floor(answers_dice.length));
            Utilities.SayParty(answers_dice[num]);
        }
    });
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
                                if ( child.GetChildCount() == 2 ) {
                                    MsgSteamID = child.Children()[0].steamid;
                                }
                                if ( MuteUsers.includes(MsgSteamID) ) {
                                    return el.RemoveAndDeleteChildren();
                                }
                                if (!Message.startsWith(Prefix)) return;
                                if ( Utilities.IsBlacklisted(MsgSteamID) ) return;
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
                        try {
                            if ( child ) child.AddClass('cp_processed');
                        } catch(err) {
                            // ignore
                        }
                    }
                })
            }
        }	
    }
    return {
        PartyChatLoop: ()=>{
            PartyChatLoop();
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

local timestamp = 0

local function on_paint()
    if not engine.is_in_game() and not engine.is_connected() then
        local now = client.get_unix_time()
        if now >= (timestamp + 1.5) then
            js.PartyChatLoop()
            timestamp = now
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)