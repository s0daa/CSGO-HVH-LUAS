local var_0_0 = require("gamesense/http")
local var_0_1 = require("gamesense/base64")
local var_0_2 = require("ffi")
local var_0_3 = require("bit")
local var_0_4 = "https://sapphyr.us/looking-to-play/v5/"
local var_0_5 = 60
local var_0_6 = "848yujjEYLhPNLC3YX83WSHTm6sWa3nHELJFLWTLsR9g6RPvfkTT2BCq2gkgSMdh2rcNWU84qsXFbwXAC2WQ4KYThMWu535sbGmkhWhgCvvndRFDw5rzRwAuDC2ZD"
local var_0_7 = 0
local var_0_8 = 0
local var_0_9
local var_0_10
local var_0_11
local var_0_12
local var_0_13 = var_0_3.band
local var_0_14 = var_0_3.rshift
local var_0_15 = var_0_3.bxor
local var_0_16 = var_0_3.bnot
local var_0_17 = string.format
local var_0_18 = string.reverse
local var_0_19 = string.byte
local var_0_20 = var_0_2.copy
local var_0_21 = var_0_2.new
local var_0_22 = var_0_2.string
local var_0_23 = json.stringify
local var_0_24 = math.abs
local var_0_25 = var_0_1.encode
local var_0_26 = panorama.loadstring("\tvar _this = this\nvar toString_text = \"function toString() { [native code] }\"\n\nvar _GetLocalData = function() {\n\tvar xuid = MyPersonaAPI.GetXuid()\n\tvar members = []\n\tvar prime = PartyListAPI.GetFriendPrimeEligible(xuid)\n\n\tvar rank = FriendsListAPI.GetFriendCompetitiveRank(xuid, \"competitive\")\n\tvar rank_count = 0\n\tif (rank > 0) { \n\t\trank_count = 1\n\t}\n\tvar is_leader = true\n\n\tvar checked = [\n\t\t// [\"MyPersonaAPI\", \"GetXuid\"],\n\t\t[\"LobbyAPI\", \"IsSessionActive\"],\n\t\t[\"LobbyAPI\", \"BIsHost\"],\n\t\t[\"PartyListAPI\", \"GetCount\"],\n\t\t[\"PartyListAPI\", \"GetXuidByIndex\"],\n\t\t[\"PartyListAPI\", \"GetFriendPrimeEligible\"],\n\t\t[\"PartyListAPI\", \"GetFriendCompetitiveRank\"]\n\t]\n\n\ttry {\n\t\tfor(i = 0; i < 6; i++) {\n\t\t\tvar name = checked[i]\n\t\t\tvar func = _this[ name[0] ][ name[1] ]\n\t\t\tif(func.toString() != `function ${name[1]}() { [native code] }` || func.toString.toString() != toString_text || func.toString.toString.toString() != toString_text){\n\t\t\t\treturn {}\n\t\t\t}\n\t\t}\n\t} catch(e) {\n\t\treturn {}\n\t}\n\n\tif(LobbyAPI.IsSessionActive()) {\n\t\tis_leader = LobbyAPI.BIsHost();\n\t\t\n\t\tfor (i = 0; i < PartyListAPI.GetCount(); i++) {\n\t\t\tvar member_xuid = PartyListAPI.GetXuidByIndex(i)\n\n\t\t\tif(member_xuid == xuid) {\n\t\t\t\tcontinue\n\t\t\t}\n\n\t\t\tmembers.push(member_xuid)\n\n\t\t\tprime = PartyListAPI.GetFriendPrimeEligible(member_xuid)\n\n\t\t\tvar member_rank = PartyListAPI.GetFriendCompetitiveRank(member_xuid, \"competitive\")\n\t\t\tif(member_rank > 0) {\n\t\t\t\trank += member_rank\n\t\t\t\trank_count += 1\n\t\t\t}\n\t\t\t\n\t\t}\n\t}\n\treturn {\n\t\tsteamid: xuid,\n\t\tprime: prime,\n\t\trank: Math.floor(rank/rank_count) || 0,\n\t\tmembers: members.join(\",\"),\n\t\tis_leader: is_leader\n\t}\n}\n\nreturn {\n\tget_local_data: _GetLocalData\n}\n", "")()
local var_0_27 = panorama.loadstring("\tvar gamesense_LookingForGSPanel, gamesense_LookingForGSButton,  gamesense_RefreshButton\nvar csgo_LookingForButtonsParent, csgo_LookingForDZButton, csgo_LookingForCoopButton, csgo_RefreshButton\n\nvar gamesense_AdvertTogglePanel, gamesense_AdvertToggleBTN, gamesense_AdvertToggleIMG\nvar csgo_AdvertToggleContainer\n\nvar handler_InviteReceived, handler_PlayerUpdated, handler_MatchmakingSessionUpdate, handler_PartyBrowserRefresh\n\nvar tile_layout, chat_message_layout, advert_layout\n\nvar active_category = null\nvar players = []\nvar PPList = []\nvar PPData = {}\nvar reserved\n\nvar autoJoinToggle = false\nvar gamesense_AdvertTogglePanelID = Math.random().toString(36).substr(2, 10);\n\nvar CategoryNames = {\n\tlegit: \"Legit\",\n\tsemirage: \"Semi-Rage\",\n\trage: \"Full Rage\",\n\tderank: \"Deranking\"\n}\n\nvar CheckboxImages = {\n\ttrue: \"file://{images}/icons/ui/checkbox.svg\",\n\tfalse: \"https://i.imgur.com/DyZtfUB.png\"\n}\n\nvar CountryNames = {\n\tKW: \"Kuwait\", MA: \"Morocco \", AF: \"Afghanistan\", AL: \"Albania\", DZ: \"Algeria\", AS: \"American Samoa\", AD: \"Andorra\", AO: \"Angola\", AI: \"Anguilla\", AQ: \"Antarctica\", AG: \"Antigua and Barbuda\", AR: \"Argentina\", AM: \"Armenia\", AW: \"Aruba\", AU: \"Australia\", AT: \"Austria\", AZ: \"Azerbaijan\", BS: \"Bahamas\", BH: \"Bahrain\", BD: \"Bangladesh\", BB: \"Barbados\", BY: \"Belarus\", BE: \"Belgium\", BZ: \"Belize\", BJ: \"Benin\", BM: \"Bermuda\", BT: \"Bhutan\", BO: \"Bolivia\", BA: \"Bosnia and Herzegovina\", BW: \"Botswana\", BV: \"Bouvet Island\", BR: \"Brazil\", IO: \"British Indian Ocean Territory\", BN: \"Brunei Darussalam\", BG: \"Bulgaria\", BF: \"Burkina Faso\", BI: \"Burundi\", KH: \"Cambodia\", CM: \"Cameroon\", CA: \"Canada\", CV: \"Cape Verde\", KY: \"Cayman Islands\", CF: \"Central African Republic\", TD: \"Chad\", CL: \"Chile\", CN: \"China\", CX: \"Christmas Island\", CC: \"Cocos (Keeling) Islands\", CO: \"Colombia\", KM: \"Comoros\", CG: \"Congo\", CD: \"Congo, the Democratic Republic of the\", CK: \"Cook Islands\", CR: \"Costa Rica\", CI: \"Cote D'Ivoire\", HR: \"Croatia\", CU: \"Cuba\", CY: \"Cyprus\", CZ: \"Czech Republic\", DK: \"Denmark\", DJ: \"Djibouti\", DM: \"Dominica\", DO: \"Dominican Republic\", EC: \"Ecuador\", EG: \"Egypt\", SV: \"El Salvador\", GQ: \"Equatorial Guinea\", ER: \"Eritrea\", EE: \"Estonia\", ET: \"Ethiopia\", FK: \"Falkland Islands (Malvinas)\", FO: \"Faroe Islands\", FJ: \"Fiji\", FI: \"Finland\", FR: \"France\", GF: \"French Guiana\", PF: \"French Polynesia\", TF: \"French Southern Territories\", GA: \"Gabon\", GM: \"Gambia\", GE: \"Georgia\", DE: \"Germany\", GH: \"Ghana\", GI: \"Gibraltar\", GR: \"Greece\", GL: \"Greenland\", GD: \"Grenada\", GP: \"Guadeloupe\", GU: \"Guam\", GT: \"Guatemala\", GN: \"Guinea\", GW: \"Guinea-Bissau\", GY: \"Guyana\", HT: \"Haiti\", HM: \"Heard Island and Mcdonald Islands\", VA: \"Holy See (Vatican City State)\", HN: \"Honduras\", HK: \"Hong Kong\", HU: \"Hungary\", IS: \"Iceland\", IN: \"India\", ID: \"Indonesia\", IR: \"Iran, Islamic Republic of\", IQ: \"Iraq\", IE: \"Ireland\", IL: \"Israel\", IT: \"Italy\", JM: \"Jamaica\", JP: \"Japan\", JO: \"Jordan\", KZ: \"Kazakhstan\", KE: \"Kenya\", KI: \"Kiribati\", KP: \"North Korea\", KR: \"South Korea\", KW: \"Kuwait\", KG: \"Kyrgyzstan\", LA: \"Lao People's Democratic Republic\", LV: \"Latvia\", LB: \"Lebanon\", LS: \"Lesotho\", LR: \"Liberia\", LY: \"Libya\", LI: \"Liechtenstein\", LT: \"Lithuania\", LU: \"Luxembourg\", MO: \"Macao\", MG: \"Madagascar\", MW: \"Malawi\", MY: \"Malaysia\", MV: \"Maldives\", ML: \"Mali\", MT: \"Malta\", MH: \"Marshall Islands\", MQ: \"Martinique\", MR: \"Mauritania\", MU: \"Mauritius\", YT: \"Mayotte\", MX: \"Mexico\", FM: \"Micronesia, Federated States of\", MD: \"Moldova, Republic of\", MC: \"Monaco\", MN: \"Mongolia\", MS: \"Montserrat\", MA: \"Morocco\", MZ: \"Mozambique\", MM: \"Myanmar\", NA: \"Namibia\", NR: \"Nauru\", NP: \"Nepal\", NL: \"Netherlands\", NC: \"New Caledonia\", NZ: \"New Zealand\", NI: \"Nicaragua\", NE: \"Niger\", NG: \"Nigeria\", NU: \"Niue\", NF: \"Norfolk Island\", MK: \"North Macedonia, Republic of\", MP: \"Northern Mariana Islands\", NO: \"Norway\", OM: \"Oman\", PK: \"Pakistan\", PW: \"Palau\", PS: \"Palestinian Territory, Occupied\", PA: \"Panama\", PG: \"Papua New Guinea\", PY: \"Paraguay\", PE: \"Peru\", PH: \"Philippines\", PN: \"Pitcairn\", PL: \"Poland\", PT: \"Portugal\", PR: \"Puerto Rico\", QA: \"Qatar\", RE: \"Reunion\", RO: \"Romania\", RU: \"Russia\", RW: \"Rwanda\", SH: \"Saint Helena\", KN: \"Saint Kitts and Nevis\", LC: \"Saint Lucia\", PM: \"Saint Pierre and Miquelon\", VC: \"Saint Vincent and the Grenadines\", WS: \"Samoa\", SM: \"San Marino\", ST: \"Sao Tome and Principe\", SA: \"Saudi Arabia\", SN: \"Senegal\", SC: \"Seychelles\", SL: \"Sierra Leone\", SG: \"Singapore\", SK: \"Slovakia\", SI: \"Slovenia\", SB: \"Solomon Islands\", SO: \"Somalia\", ZA: \"South Africa\", GS: \"South Georgia and the South Sandwich Islands\", ES: \"Spain\", LK: \"Sri Lanka\", SD: \"Sudan\", SR: \"Suriname\", SJ: \"Svalbard and Jan Mayen\", SZ: \"Eswatini\", SE: \"Sweden\", CH: \"Switzerland\", SY: \"Syrian Arab Republic\", TW: \"Taiwan\", TJ: \"Tajikistan\", TZ: \"Tanzania, United Republic of\", TH: \"Thailand\", TL: \"Timor-Leste\", TG: \"Togo\", TK: \"Tokelau\", TO: \"Tonga\", TT: \"Trinidad and Tobago\", TN: \"Tunisia\", TR: \"Turkey\", TM: \"Turkmenistan\", TC: \"Turks and Caicos Islands\", TV: \"Tuvalu\", UG: \"Uganda\", UA: \"Ukraine\", AE: \"United Arab Emirates\", GB: \"United Kingdom\", US: \"USA\", UM: \"United States Minor Outlying Islands\", UY: \"Uruguay\", UZ: \"Uzbekistan\", VU: \"Vanuatu\", VE: \"Venezuela\", VN: \"Vietnam\", VG: \"Virgin Islands, British\", VI: \"Virgin Islands, U.S.\", WF: \"Wallis and Futuna\", EH: \"Western Sahara\", YE: \"Yemen\", ZM: \"Zambia\", ZW: \"Zimbabwe\", AX: \"Åland Islands\", BQ: \"Bonaire, Sint Eustatius and Saba\", CW: \"Curaçao\", GG: \"Guernsey\", IM: \"Isle of Man\", JE: \"Jersey\", ME: \"Montenegro\", BL: \"Saint Barthélemy\", MF: \"Saint Martin (French part)\", RS: \"Serbia\", SX: \"Sint Maarten (Dutch part)\", SS: \"South Sudan\", XK: \"Kosovo\"\n}\n\nvar failed_images = {\n\t\"file://{images}/flags/BZ.png\": true,\n\t\"file://{images}/flags/TN.png\": true,\n\t\"file://{images}/flags/CY.png\": true,\n\t\"file://{images}/flags/SC.png\": true,\n\t\"file://{images}/flags/GE.png\": true,\n\t\"file://{images}/flags/AM.png\": true,\n\t\"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/bz.svg\": true,\n\t\"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/cy.svg\": true,\n\t\"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/ge.svg\": true,\n\t\"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/am.svg\": true,\n\t\"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/tn.svg\": true\n}\n\nvar gameModes = [\n\t{\n\t\tcategory: \"legit\",\n\t\tname: \"Legit Cheating\",\n\t\timg: \"<img src='https://raw.githubusercontent.com/Karechta/looking_for_gs/master/legit.png' style='min-height: 200px !important; height: 200px !important;' class='' />\"\n\t},\n\t{\n\t\tcategory: \"semirage\",\n\t\tname: \"Semi-Raging\",\n\t\timg: \"<img src='file://{images}/icons/ui/quest.svg' />\"\n\t},\n\t{\n\t\tcategory: \"rage\",\n\t\tname: \"Full Raging\",\n\t\timg: \"<img src='https://raw.githubusercontent.com/Karechta/looking_for_gs/master/rage.png' />\"\n\t},\n\t{\n\t\tcategory: \"derank\",\n\t\tname: \"Derank\",\n\t\timg: \"<img src='file://{images}/icons/ui/bomb_arrow_segment.svg' />\"\n\t}\n]\n\nvar needsRefresh = 0\nvar gamesenseTabActive = false\nvar loadProgress = 100\nvar joinXuid = null\nvar inviteXuids = {}\nvar invitedByXuids = {}\nvar in_lobby_prev = null\nvar active_friendlobby_tooltip = null\nvar active_hire_toggle_context_menu = null\n\nvar PartyBrowserAPI_prev = {\n\tGetResultsCount: PartyBrowserAPI.GetResultsCount,\n\tGetXuidByIndex: PartyBrowserAPI.GetXuidByIndex,\n\tGetPartyMembersCount: PartyBrowserAPI.GetPartyMembersCount,\n\tGetPartyMemberXuid: PartyBrowserAPI.GetPartyMemberXuid,\n\tGetPartySessionSetting: PartyBrowserAPI.GetPartySessionSetting,\n\tSetSearchFilter: PartyBrowserAPI.SetSearchFilter,\n\tRefresh: PartyBrowserAPI.Refresh,\n\tGetProgress: PartyBrowserAPI.GetProgress,\n\tGetPartyType: PartyBrowserAPI.GetPartyType\n}\n\nvar GameInterfaceAPI_prev = {\n\tSetSettingString: GameInterfaceAPI.SetSettingString\n}\n\nPartyBrowserAPI.SetSearchFilter = function (filter) {\n\tif (gamesenseTabActive) {\n\t\tneedsRefresh = 1\n\t\t_SetLoadProgress(20)\n\t}\n\n\treturn PartyBrowserAPI_prev.SetSearchFilter.call(PartyBrowserAPI, filter)\n}\n\nvar _UpdateNoDataText = function () {\n\tvar panel_list = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies\").FindChild(\"JsFriendsList-List\")\n\tif (panel_list) {\n\t\tvar panel_nodata = panel_list.FindChildTraverse('JsFriendListNoData')\n\t\tif (panel_nodata) {\n\t\t\tvar panel_nodatadesc = panel_nodata.FindChildTraverse(\"JsFriendsNoDataDesc\")\n\t\t\tif (panel_nodatadesc) {\n\t\t\t\tpanel_nodatadesc.text = gamesenseTabActive ? \"Couldn't find any gamesense users looking to play at this time.\" : $.Localize(\"#FriendsList_nodata_advertising\")\n\t\t\t}\n\t\t}\n\t}\n}\n\n\nvar _ClearFallbackHandlers = function (info) {\n\tif (info.handler_failed) {\n\t\t$.UnregisterEventHandler(\"ImageFailedLoad\", info.panel, info.handler_failed)\n\t\tinfo.handler_failed = null\n\t}\n\n\tif (info.handler_success) {\n\t\t$.UnregisterEventHandler(\"ImageLoaded\", info.panel, info.handler_success)\n\t\tinfo.handler_success = null\n\t}\n}\n\nvar _SetNextImage = function (info) {\n\t// info.images = info.images.filter(image => !failed_images[image])\n\n\tif (info.i >= info.images.length - 1) {\n\t\t_ClearFallbackHandlers(info)\n\t\treturn\n\t}\n\n\tif (info.image) {\n\t\t// $.Msg(\"failed image: \", info.image, \" (already failed: \", failed_images[info.image], \")\")\n\t\tfailed_images[info.image] = true\n\t}\n\n\t// use next image\n\tinfo.i++\n\tinfo.image = info.images[info.i]\n\n\t// set image\n\tswitch (info.type) {\n\t\tcase \"image\":\n\t\t\tinfo.panel.SetImage(info.image)\n\t\t\tbreak\n\t\tcase \"background\":\n\t\t\tinfo.panel.style.backgroundImage = `url(\"${info.image}\")`\n\t\t\tbreak\n\t}\n}\n\nvar _InitFallbackImage = function (info) {\n\tinfo.handler_failed = $.RegisterEventHandler(\"ImageFailedLoad\", info.panel, _SetNextImage.bind(undefined, info))\n\t$.RegisterEventHandler(\"ImageLoaded\", info.panel, _ClearFallbackHandlers.bind(undefined, info))\n\n\tinfo.i = -1\n\t_SetNextImage(info)\n}\n\nvar _SetImageWithFallback = function (panel, ...images) {\n\treturn _InitFallbackImage({\n\t\tpanel: panel,\n\t\timages: images,\n\t\ttype: \"image\"\n\t})\n}\n\nvar _SetBackgroundWithFallback = function (panel, ...images) {\n\treturn _InitFallbackImage({\n\t\tpanel: panel,\n\t\timages: images,\n\t\ttype: \"background\"\n\t})\n}\n\nvar _GetFlagIcons = function (country) {\n\treturn [\n\t\t`file://{images}/regions/${country}.png`,\n\t\t`https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/${country.toLowerCase()}.svg`,\n\t\t`https://raw.githubusercontent.com/hampusborgos/country-flags/master/png100px/${country.toLowerCase()}.png`,\n\t]\n}\n\n\nPartyBrowserAPI.GetResultsCount = function () {\n\t_UpdateNoDataText()\n\tif (gamesenseTabActive) {\n\t\treturn PPList.length\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetResultsCount.call(PartyBrowserAPI)\n\t}\n}\n\nPartyBrowserAPI.GetProgress = function () {\n\t_UpdateNoDataText()\n\tif (gamesenseTabActive) {\n\t\treturn loadProgress\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetProgress.call(PartyBrowserAPI)\n\t}\n}\n\nPartyBrowserAPI.GetXuidByIndex = function (i) {\n\tif (gamesenseTabActive) {\n\t\treturn PPList[i]\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetXuidByIndex.call(PartyBrowserAPI, i)\n\t}\n}\n\nPartyBrowserAPI.GetPartyMembersCount = function (xuid) {\n\tif (gamesenseTabActive && PPData[xuid]) {\n\t\treturn PPData[xuid].members ? PPData[xuid].members.length + 1 : 1\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetPartyMembersCount.call(PartyBrowserAPI, xuid, i)\n\t}\n}\n\nPartyBrowserAPI.GetPartyType = function (xuid) {\n\tif (gamesenseTabActive && PPData[xuid]) {\n\t\treturn null\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetPartyType.call(PartyBrowserAPI, xuid)\n\t}\n}\n\nPartyBrowserAPI.GetPartyMemberXuid = function (xuid, i) {\n\tif (gamesenseTabActive && PPData[xuid]) {\n\t\treturn i == 0 ? xuid : (PPData[xuid].members ? PPData[xuid].members[i - 1] : null)\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetPartyMemberXuid.call(PartyBrowserAPI, xuid, i)\n\t}\n}\n\nPartyBrowserAPI.GetPartySessionSetting = function (xuid, setting) {\n\tif (gamesenseTabActive && PPData[xuid]) {\n\t\tif (setting == \"game/loc\") {\n\t\t\tvar panel_list = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies\").FindChild(\"JsFriendsList-List\")\n\t\t\tvar tile = panel_list.FindChild(xuid)\n\n\t\t\tif (tile) {\n\t\t\t\tif (PPData[xuid].members) {\n\t\t\t\t\telFriendLobby = tile.FindChildTraverse(\"JsFriendAdvertiseGSLobby\")\n\t\t\t\t\tvar isFirst = false\n\t\t\t\t\tif (elFriendLobby == null) {\n\t\t\t\t\t\ttile.style.height = \"100px\"\n\t\t\t\t\t\ttile.Children().forEach(function (el) {\n\t\t\t\t\t\t\tel.visible = false\n\t\t\t\t\t\t})\n\n\t\t\t\t\t\telFriendLobby = $.CreatePanel(\"Panel\", tile, \"JsFriendAdvertiseGSLobby\")\n\t\t\t\t\t\telFriendLobby.SetAttributeString('xuid', xuid)\n\t\t\t\t\t\telFriendLobby.BLoadLayout('file://{resources}/layout/friendlobby.xml', false, false)\n\t\t\t\t\t\tisFirst = true\n\t\t\t\t\t}\n\t\t\t\t\tif (elFriendLobby != null) {\n\t\t\t\t\t\tFriendLobby_Init(elFriendLobby, xuid, isFirst)\n\t\t\t\t\t}\n\t\t\t\t}\n\n\t\t\t\tvar country = PPData[xuid].country\n\t\t\t\tif (country) {\n\t\t\t\t\tvar elFlagImgId = `JsFriendLobbyFlagCustom-${xuid}`\n\t\t\t\t\tvar elFlagImg = tile.FindChildTraverse(elFlagImgId)\n\t\t\t\t\tif (elFlagImg == null) {\n\t\t\t\t\t\tvar parent\n\n\t\t\t\t\t\tif (PPData[xuid].members) {\n\t\t\t\t\t\t\tparent = tile.FindChildTraverse(\"JsFriendLobbySkillGroup\").GetParent()\n\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\tparent = tile.FindChildTraverse(\"JsFriendAdvertiseSkillGroup\").GetParent()\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\telFlagImg = $.CreatePanel(\"Label\", parent, elFlagImgId)\n\n\n\t\t\t\t\t\tif (PPData[xuid].members) {\n\t\t\t\t\t\t\tparent.MoveChildBefore(elFlagImg, tile.FindChildTraverse('JsFriendLobbySkillGroup'))\n\t\t\t\t\t\t} else {\n\t\t\t\t\t\t\tparent.MoveChildAfter(elFlagImg, tile.FindChildTraverse(\"JsRegionLabel\"))\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\tvar info = {\n\t\t\t\t\t\t\telement: elFlagImg,\n\t\t\t\t\t\t\tcountry: country\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\tvar elTTAnchor = elFlagImg.FindChildTraverse('region-tt-anchor');\n\t\t\t\t\t\tif (!elTTAnchor) {\n\t\t\t\t\t\t\telTTAnchor = $.CreatePanel(\"Panel\", elFlagImg, elFlagImg.id + '-region-tt-anchor');\n\t\t\t\t\t\t}\n\n\t\t\t\t\t\telFlagImg.SetPanelEvent(\"onmouseout\", _CountryMouseout)\n\t\t\t\t\t\telFlagImg.SetPanelEvent(\"onmouseover\", _CountryMouseover.bind(undefined, elTTAnchor.id, country))\n\t\t\t\t\t\telFlagImg.style.tooltipPosition = \"bottom\"\n\t\t\t\t\t\telFlagImg.style.margin = \"0px 5px 0px 0px;\"\n\n\n\t\t\t\t\t\telFlagImg.text = country.toUpperCase();\n\t\t\t\t\t\t_SetBackgroundWithFallback(elFlagImg, ..._GetFlagIcons(country))\n\n\t\t\t\t\t\telFlagImg.RemoveClass('hidden');\n\t\t\t\t\t\telFlagImg.SetHasClass('world-region-label', true);\n\t\t\t\t\t\telFlagImg.SetHasClass('world-region-label--image', true);\n\n\t\t\t\t\t}\n\t\t\t\t}\n\n\t\t\t\tvar elCategory = tile.FindChildTraverse(\"JsFriendAdvertiseGSCategory\")\n\t\t\t\tif (elCategory == null) {\n\t\t\t\t\tvar parent\n\t\t\t\t\tif (PPData[xuid].members) {\n\t\t\t\t\t\tparent = tile.FindChildTraverse(\"JsFriendLobbySkillGroup\").GetParent()\n\t\t\t\t\t} else {\n\t\t\t\t\t\tparent = tile.FindChildTraverse(\"JsRegionLabel\").GetParent()\n\t\t\t\t\t}\n\t\t\t\t\telCategory = $.CreatePanel(\"Panel\", parent, \"JsFriendAdvertiseGSCategory\")\n\n\t\t\t\t\tif (PPData[xuid].members) {\n\t\t\t\t\t\tparent.MoveChildAfter(elCategory, parent.GetChild(parent.GetChildCount() - 3))\n\t\t\t\t\t\telCategory.style.paddingRight = \"4px;\"\n\t\t\t\t\t}\n\n\t\t\t\t\tif (elCategory != null) {\n\t\t\t\t\t\telCategory.BLoadLayoutFromString(tile_layout, false, false)\n\t\t\t\t\t}\n\t\t\t\t}\n\n\t\t\t\tif (elCategory != null && elCategory.FindChildTraverse(\"CategoryText\")) {\n\t\t\t\t\tvar cat = PPData[xuid].category\n\t\t\t\t\telCategory.FindChildTraverse(\"CategoryText\").text = CategoryNames[cat] || cat\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\n\t\tswitch (setting) {\n\t\t\tcase \"game/apr\":\n\t\t\t\treturn PPData[xuid].prime == 1\n\t\t\tcase \"game/mode\":\n\t\t\t\treturn \"competitive\"\n\t\t\tcase \"game/ark\":\n\t\t\t\treturn PPData[xuid].rank * 10\n\t\t\tcase \"game/mapgroupname\":\n\t\t\t\treturn \"workshop\"\n\t\t\tcase \"game/clanid\":\n\t\t\tcase \"game/clantag\":\n\t\t\t\treturn \"gamesense\"\n\t\t\tdefault:\n\t\t\t//$.Msg(setting)\n\t\t}\n\t} else {\n\t\treturn PartyBrowserAPI_prev.GetPartySessionSetting.call(PartyBrowserAPI, xuid, setting)\n\t}\n}\n\nPartyBrowserAPI.Refresh = function () {\n\t_UpdateNoDataText()\n\tif (!gamesenseTabActive) {\n\t\treturn PartyBrowserAPI_prev.Refresh.call(PartyBrowserAPI)\n\t}\n}\n\n\nGameInterfaceAPI.SetSettingString = function (filter, value) {\n\tif (gamesenseTabActive && filter == 'ui_nearbylobbies_filter') {\n\t\tcsgo_RefreshButton.visible = true\n\t\tgamesense_RefreshButton.visible = false\n\t\tgamesenseTabActive = false\n\t\tvar panel_list = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies\").FindChild(\"JsFriendsList-List\")\n\n\t\tpanel_list.Children().forEach(function (el) {\n\t\t\ttry {\n\t\t\t\tvar elFlagImgId = `JsFriendLobbyFlagCustom-${el.id}`\n\t\t\t\tel.FindChildTraverse(elFlagImgId).DeleteAsync(0.0)\n\t\t\t\tel.FindChildTraverse(\"JsFriendAdvertiseGSCategory\").DeleteAsync(0.0)\n\t\t\t}\n\t\t\tcatch (e) {\n\n\t\t\t}\n\t\t})\n\t}\n\n\n\treturn GameInterfaceAPI_prev.SetSettingString.call(GameInterfaceAPI, filter, value)\n}\n\n\n//Lobby listing Below\n\n\nvar FriendLobby_OpenContextMenu = function (xuid) {\n\t$.DispatchEvent('SidebarContextMenuActive', true)\n\n\tvar contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(\n\t\t'',\n\t\t'',\n\t\t'file://{resources}/layout/context_menus/context_menu_playercard.xml',\n\t\t'xuid=' + xuid,\n\t\tfunction () {\n\t\t\t$.DispatchEvent('SidebarContextMenuActive', false)\n\t\t}\n\t);\n\tcontextMenuPanel.AddClass(\"ContextMenu_NoArrow\");\n}\n\nvar FriendLobby_Join = function (xuid) {\n\t//Check if already in Lobby\n\tif (LobbyAPI.IsSessionActive()) {\n\t\tfor (i = 0; i < PartyListAPI.GetCount(); i++) {\n\t\t\tvar member_xuid = PartyListAPI.GetXuidByIndex(i)\n\n\t\t\tif (member_xuid == xuid) {\n\t\t\t\treturn\n\t\t\t}\n\t\t}\n\t}\n\t//Set JoinXuid to be called by NeedsUpdate\n\t$.DispatchEvent('PlaySoundEffect', 'PanoramaUI.Lobby.Joined', 'MOUSE')\n\tjoinXuid = xuid\n}\n\nvar FriendLobby_SlotMouseover = function (id) {\n\tactive_friendlobby_tooltip = id\n\tUiToolkitAPI.ShowTextTooltip(id, \"Join game<font color='#95b806'>sense</font> lobby\")\n}\n\nvar FriendLobby_SlotMouseout = function (id) {\n\tactive_friendlobby_tooltip = null\n\tUiToolkitAPI.HideTextTooltip()\n}\n\nvar _CountryMouseover = function (id, country) {\n\tUiToolkitAPI.ShowTextTooltip(id, `${CountryNames[country] || country}`)\n}\n\nvar _CountryMouseout = function (id, country) {\n\tUiToolkitAPI.HideTextTooltip()\n}\n\nvar FriendLobby_Init = function (elFriendLobby, xuid, isFirst) {\n\telFriendLobby.style.borderBottom = \"1px solid rgba(255, 255, 255, 0) !important;\"\n\n\t// La Familia de El\n\tvar elPrime = elFriendLobby.FindChildTraverse('JsFriendLobbyPrime')\n\tvar elSkillGroupImg = elFriendLobby.FindChildTraverse('JsFriendLobbySkillGroup')\n\tvar elSettingsLabel = elFriendLobby.FindChildTraverse('JsFriendLobbySettings')\n\tvar elGroupLBtn = elFriendLobby.FindChildTraverse('JsFriendLobbyGroupBtn')\n\tvar elGroupLabel = elFriendLobby.FindChildTraverse('JsFriendLobbyGroupTxt')\n\tvar elAvatarRow = elFriendLobby.FindChildTraverse('JsFriendLobbyAvatars')\n\n\tif (isFirst) {\n\t\telFriendLobby.visible = true\n\t\telFriendLobby.RemoveClass('hidden')\n\n\t\tvar parent = elSkillGroupImg.GetParent()\n\t\telPrime.SetParent(parent)\n\t\tparent.MoveChildBefore(elPrime, elSkillGroupImg)\n\n\t\telFriendLobby.FindChildTraverse('JsFriendLobbyLeaderAvatar').steamid = xuid\n\t\telFriendLobby.FindChildTraverse('JsFriendLobbyLeaderBtn').SetPanelEvent('onactivate', FriendLobby_OpenContextMenu.bind(undefined, xuid))\n\t}\n\telFriendLobby.SetDialogVariable('friendname', FriendsListAPI.GetFriendName(xuid))\n\telFriendLobby.FindChildTraverse('JsFriendLobbyLeaderName').text = \"#tooltip_lobby_leader_name\"\n\telFriendLobby.FindChildTraverse('JsFriendLobbyLeaderName').style.fontWeight = \"bold\"\n\n\telSkillGroupImg.RemoveClass('hidden')\n\telSkillGroupImg.SetImage(`file://{images}/icons/skillgroups/skillgroup${PPData[xuid].rank}.svg`)\n\n\telSettingsLabel.text = CategoryNames[PPData[xuid].category]\n\telSettingsLabel.visible = false\n\n\telGroupLBtn.visible = false\n\telGroupLabel.visible = false\n\n\telPrime.visible = PPData[xuid].prime;\n\n\tvar inLobby = false\n\tfor (var i = 0; i < PartyBrowserAPI.GetPartyMembersCount(xuid); i++) {\n\t\tif (PartyBrowserAPI.GetPartyMemberXuid(xuid, i) == MyPersonaAPI.GetXuid()) {\n\t\t\tinLobby = true\n\t\t\tbreak\n\t\t}\n\t}\n\n\telFriendLobby.FindChildTraverse('JsFriendLobbyLeaderAvatar').style.margin = \"0px 7px;\"\n\tfor (var i = 1; i <= 4; i++) {\n\t\tvar _xuid = PartyBrowserAPI.GetPartyMemberXuid(xuid, i)\n\t\tvar slotId = xuid + ':' + i\n\t\tvar playerSlot = elAvatarRow.FindChild(slotId)\n\n\t\tif (!playerSlot) {\n\t\t\tplayerSlot = $.CreatePanel('Panel', elAvatarRow, slotId);\n\t\t\tplayerSlot.BLoadLayoutSnippet('FriendLobbyAvatarSlot');\n\t\t}\n\n\t\tplayerSlot.style.margin = \"0px 12px;\"\n\n\t\tif (i === 1)\n\t\t\tplayerSlot.AddClass('friendlobby__slot--first');\n\n\t\tvar elAvatar = playerSlot.FindChildTraverse('JsFriendAvatar'),\n\t\t\telJoinBtn = playerSlot.FindChildTraverse('JsFriendAvatarJoin');\n\n\t\tif (!_xuid) {\n\t\t\tif (inLobby) {\n\t\t\t\telJoinBtn.enabled = false;\n\t\t\t\telJoinBtn.visible = false;\n\t\t\t\telAvatar.visible = false;\n\t\t\t} else {\n\t\t\t\telJoinBtn.enabled = true;\n\t\t\t\telJoinBtn.visible = true;\n\t\t\t\telAvatar.visible = false;\n\n\t\t\t\telJoinBtn.SetPanelEvent('onactivate', FriendLobby_Join.bind(undefined, xuid))\n\t\t\t\telJoinBtn.SetPanelEvent('onmouseover', FriendLobby_SlotMouseover.bind(undefined, slotId))\n\t\t\t\telJoinBtn.SetPanelEvent('onmouseout', FriendLobby_SlotMouseout.bind(undefined, slotId))\n\t\t\t}\n\t\t} else {\n\t\t\telJoinBtn.visible = false;\n\t\t\telAvatar.visible = true;\n\t\t\telAvatar.steamid = _xuid;\n\n\t\t\tplayerSlot.FindChild('JsFriendAvatarBtn').SetPanelEvent('onactivate', FriendLobby_OpenContextMenu.bind(undefined, _xuid));\n\t\t}\n\t}\n}\n\n// used to Change the active Category and update the Buttons Visuals\nvar _SetActiveCategory = function (_active_category) {\n\tactive_category = _active_category\n\n\tif (active_category != null) {\n\t\tgamesense_AdvertToggleIMG.style.washColor = \"#95b806;\"\n\t\tgamesense_AdvertToggleIMG.style.backgroundColor = \"rgba(0, 0, 0, 0.4);\"\n\t\tgamesense_AdvertToggleIMG.style.boxShadow = \"0px 0px 6px 5.0 rgba(0, 0, 0, 0.753);\"\n\t\tgamesense_AdvertToggleIMG.style.imgShadow = \"0px 0px 1px 1.0 white;\"\n\n\t\t$.DispatchEventAsync(0.0, \"PlaySoundEffect\", \"UIPanorama.mainmenu_press_quit\", \"MOUSE\")\n\t} else {\n\t\tgamesense_AdvertToggleIMG.style.washColor = \"white;\"\n\t\tgamesense_AdvertToggleIMG.style.backgroundColor = \"rgba(0, 0, 0, 0);\"\n\t\tgamesense_AdvertToggleIMG.style.boxShadow = \"0px 0px 0px 0 rgba(0, 0, 0, 0);\"\n\t\tgamesense_AdvertToggleIMG.style.imgShadow = \"0px 0px 0px 0.0 white;\"\n\t}\n}\n\nvar _OnActiveHireToggleContextMenuDismissed = function () {\n\tactive_hire_toggle_context_menu = null\n}\n\n// Create Advert Button on the left NavBar in the Mainmenu\nvar _Create_Advert = function () {\n\tcsgo_AdvertToggleContainer = $.GetContextPanel().FindChildTraverse(\"HireAdvertisingToggleContainer\")\n\tvar csgo_AdvertToggleContainerParent = csgo_AdvertToggleContainer.GetParent()\n\n\tcsgo_AdvertToggleContainerParent.style.flowChildren = \"down\"\n\tcsgo_AdvertToggleContainerParent.style.height = \"192px\"\n\tcsgo_AdvertToggleContainer.style.height = \"96px\"\n\n\tgamesense_AdvertTogglePanel = $.CreatePanel(\"Panel\", csgo_AdvertToggleContainerParent, gamesense_AdvertTogglePanelID)\n\tif (gamesense_AdvertTogglePanel.BLoadLayoutFromString(advert_layout, false, false)) {\n\t\tgamesense_AdvertTogglePanel.borderBottom = \"1px solid rgba(255, 255, 255, 0.1)\"\n\n\t\tgamesense_AdvertToggleBTN = gamesense_AdvertTogglePanel.FindChildTraverse(\"HireAdvertisingToggleGS\")\n\t\tif (gamesense_AdvertToggleBTN != null) {\n\t\t\tgamesense_AdvertToggleBTN.SetPanelEvent(\"onactivate\", _OnActivateToggle)\n\t\t\tgamesense_AdvertToggleBTN.SetPanelEvent(\"oncontextmenu\", _OnActivateToggle)\n\t\t\tgamesense_AdvertToggleBTN.SetPanelEvent(\"onmouseover\", _OnHover_toggle)\n\t\t\tgamesense_AdvertToggleBTN.SetPanelEvent(\"onmouseout\", function () {\n\t\t\t\tUiToolkitAPI.HideTitleTextTooltip()\n\t\t\t})\n\t\t}\n\t}\n\n\tgamesense_AdvertToggleIMG = gamesense_AdvertTogglePanel.FindChildTraverse(\"HireAdvertisingToggleGSImage\")\n\n\t/*$.GetContextPanel().FindChildTraverse(\"JsMainMenuNavBar\").Children().forEach((panel) => {\n\t\t$.Msg(panel.id)\n\t})*/\n}\n\n// Function to check if Player is able to Advertise\nvar _CanAdvertise = function () {\n\treturn !(PartyListAPI.GetCount() > 4 || FriendsListAPI.IsLocalPlayerPlayingMatch() || MyPersonaAPI.IsVacBanned() || CompetitiveMatchAPI.GetCooldownSecondsRemaining() > 0)\n}\n\n// returns active category and resets if above function returns false\nvar _GetActiveCategory = function () {\n\tif (active_category && !_CanAdvertise()) {\n\t\t_SetActiveCategory(null)\n\t}\n\n\treturn active_category\n}\n\n// Called by clicking on the Advertise Button, lists the modes to look for\nvar _OnActivateToggle = function () {\n\tif (!_CanAdvertise()) {\n\t\treturn\n\t}\n\n\tvar items = []\n\n\tgameModes.forEach(entry => {\n\t\tvar labelLoc\n\t\tif (entry.category === active_category) {\n\t\t\tlabelLoc = `${entry.img} <b><font color='#95b806'>Looking for ${entry.name}</font></b>`\n\t\t} else {\n\t\t\tlabelLoc = `${entry.img} Looking for ${entry.name}`\n\t\t}\n\n\t\titems.push({\n\t\t\tlabel: labelLoc,\n\t\t\tstyle: \"Icon\",\n\t\t\tjsCallback: _SetActiveCategory.bind(undefined, entry.category)\n\t\t})\n\t})\n\n\tif (!(PartyListAPI.GetCount() > 1)) {\n\t\tvar checkLabel = `<img src=\"${CheckboxImages[autoJoinToggle]}\" /> Auto-join`\n\t\titems.push({\n\t\t\tlabel: checkLabel,\n\t\t\tstyle: \"Icon\",\n\t\t\tjsCallback: function () {\n\t\t\t\tautoJoinToggle = !autoJoinToggle\n\t\t\t\t_OnActivateToggle()\n\t\t\t}\n\t\t})\n\t}\n\n\tif (active_category != null) {\n\t\titems.push({\n\t\t\tlabel: \"Stop Looking\",\n\t\t\tstyle: \"TopSeparator\",\n\t\t\tjsCallback: function () {\n\t\t\t\t_SetActiveCategory(null)\n\n\t\t\t\t$.DispatchEventAsync(0.0, \"PlaySoundEffect\", \"UIPanorama.generic_button_press\", \"MOUSE\")\n\t\t\t}\n\t\t})\n\t}\n\n\t// create new popup\n\t//active_hire_toggle_context_menu = UiToolkitAPI.ShowSimpleContextMenuWithDismissEvent('HireAdvertisingToggleGS', 'ControlLibSimpleContextMenu', items, _OnActiveHireToggleContextMenuDismissed)\n\tactive_hire_toggle_context_menu = UiToolkitAPI.ShowSimpleContextMenuWithDismissEvent('', 'ControlLibSimpleContextMenu', items, _OnActiveHireToggleContextMenuDismissed)\n\n\t// try and find auto-join button\n\tvar auto_join_toggle_btn\n\tactive_hire_toggle_context_menu.FindChildTraverse(\"ContextMenuBody\").Children().forEach(function (el) {\n\t\tif (el.GetChild(0) && el.GetChild(0).text && el.GetChild(0).text.includes(\"Auto-join\")) {\n\t\t\tauto_join_toggle_btn = el\n\t\t}\n\t})\n\n\t// add our custom hover handlers\n\tif (auto_join_toggle_btn) {\n\t\t// $.Msg(auto_join_toggle_btn)\n\t\t// $.Msg(auto_join_toggle_btn.Children())\n\t\t// $.Msg(auto_join_toggle_btn.Children()[0].Children())\n\n\t\tauto_join_toggle_btn.SetPanelEvent(\"onactivate\", function () {\n\t\t\t$.DispatchEvent('PlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE')\n\t\t\tautoJoinToggle = !autoJoinToggle\n\t\t\t// $.Msg(autoJoinToggle)\n\n\t\t\t// update image\n\t\t\tif (auto_join_toggle_btn && auto_join_toggle_btn.GetChild(0) && auto_join_toggle_btn.GetChild(0).GetChild(0)) {\n\t\t\t\tauto_join_toggle_btn.GetChild(0).GetChild(0).SetImage(CheckboxImages[autoJoinToggle])\n\t\t\t}\n\t\t})\n\t}\n}\n\n// Tooltip on Hover\nvar _OnHover_toggle = function () {\n\tUiToolkitAPI.ShowTitleTextTooltip(gamesense_AdvertTogglePanelID, \"Looking for game<font color='#95b806'>sense</font> users\", \"Enables other users to find you and invite you to a lobby\")\n}\n\n// Create LTP Tab, to show GS users\n\nvar _Create_LTP_Tab = function (layout) {\n\tcsgo_LookingForCoopButton = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies-toolbar-button-cooperative\")\n\tcsgo_LookingForDZButton = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies-toolbar-button-survival\")\n\tcsgo_LookingForButtonsParent = csgo_LookingForDZButton.GetParent()\n\n\tgamesense_LookingForGSPanel = $.CreatePanel('Button', csgo_LookingForButtonsParent, 'Gamesense_Lobbies')\n\tif (gamesense_LookingForGSPanel.BLoadLayoutFromString(layout, false, false)) {\n\t\tgamesense_LookingForGSPanel.visible = true\n\t\tcsgo_LookingForButtonsParent.MoveChildAfter(gamesense_LookingForGSPanel, csgo_LookingForCoopButton ? csgo_LookingForCoopButton : csgo_LookingForDZButton)\n\n\t\tgamesense_LookingForGSButton = gamesense_LookingForGSPanel.FindChildTraverse(\"JsFriendsList-lobbies-toolbar-button-gamesense\")\n\t\tif (gamesense_LookingForGSButton != null) {\n\t\t\tgamesense_LookingForGSButton.SetPanelEvent(\"onactivate\", _OnActivate)\n\t\t\tgamesense_LookingForGSButton.SetPanelEvent(\"onmouseover\", OnMouseOver)\n\t\t\tgamesense_LookingForGSButton.SetPanelEvent(\"onmouseout\", OnMouseOut)\n\t\t}\n\n\t\tcsgo_RefreshButton = csgo_LookingForButtonsParent.FindChildTraverse(\"JsFriendsList-lobbies-toolbar-button-refresh\")\n\t\tgamesense_RefreshButton = gamesense_LookingForGSPanel.FindChildTraverse(\"JsFriendsList-lobbies-toolbar-button-gamesense-refresh\")\n\t\tgamesense_RefreshButton.SetParent(csgo_RefreshButton.GetParent())\n\t\tif (gamesense_RefreshButton != null) {\n\t\t\tgamesense_RefreshButton.GetParent().MoveChildBefore(gamesense_RefreshButton, csgo_RefreshButton)\n\t\t\tgamesense_RefreshButton.visible = false\n\n\t\t\tgamesense_RefreshButton.SetPanelEvent(\"onactivate\", function () {\n\t\t\t\t_SetLoadProgress(20)\n\t\t\t\tneedsRefresh = 1\n\t\t\t})\n\t\t}\n\t}\n\n}\n\n// Disable default refresh / player buttons, and request a Playerlist refresh\nvar _OnActivate = function () {\n\tgamesenseTabActive = true\n\t_SetLoadProgress(10)\n\tneedsRefresh = 1\n\n\tcsgo_RefreshButton.visible = false\n\tgamesense_RefreshButton.visible = true\n\t$.DispatchEventAsync(0.0, \"PanoramaComponent_PartyBrowser_Refresh\")\n}\n\n//Tooltip On\nvar OnMouseOver = function () {\n\tUiToolkitAPI.ShowTextTooltip(\"JsFriendsList-lobbies-toolbar-button-gamesense\", \"game<font color='#95b806'>sense</font>\")\n}\n\n//Tooltip Off\nvar OnMouseOut = function () {\n\tUiToolkitAPI.HideTextTooltip()\n}\n\n// i dont need to comment this\nvar _SetLoadProgress = function (progress) {\n\tloadProgress = progress\n\t$.DispatchEventAsync(0.0, \"PanoramaComponent_PartyBrowser_Refresh\")\n}\n\n// Uses data from the Server to convert it into a Playerlist useable in js\nvar _SetPP = function (data) {\n\tvar panel_list = $.GetContextPanel().FindChildTraverse(\"JsFriendsList-lobbies\").FindChild(\"JsFriendsList-List\")\n\tif (panel_list) {\n\t\tpanel_list.Children().forEach(function (tile) {\n\t\t\ttry {\n\t\t\t\tif (!data[tile.id] || (!!PPData[tile.id].members != !!data[tile.id].members)) {\n\t\t\t\t\ttile.RemoveAndDeleteChildren()\n\t\t\t\t\ttile.DeleteAsync(0.0)\n\t\t\t\t}\n\t\t\t} catch (e) {\n\t\t\t\t$.Schedule(0.1, PartyBrowserAPI.Refresh)\n\n\t\t\t}\n\n\t\t})\n\t}\n\n\tPPList = []\n\tPPData = {}\n\n\tif (loadProgress < 100) {\n\t\t_SetLoadProgress(80)\n\n\t\tvar first = 0.1 + Math.random() * 0.2\n\t\t$.Schedule(first, function () {\n\t\t\t_SetLoadProgress(90)\n\t\t})\n\n\t\t$.Schedule(first + 0.1 + Math.random() * 0.2, function () {\n\t\t\t_SetLoadProgress(100)\n\t\t})\n\t}\n\tfor (var xuid in data) {\n\t\tif (data[xuid].members) {\n\t\t\tPPList.unshift(xuid)\n\t\t} else {\n\t\t\tPPList.push(xuid)\n\t\t}\n\t\tPPData[xuid] = data[xuid]\n\t}\n\tif (gamesenseTabActive) {\n\t\t$.DispatchEventAsync(0.0, \"PanoramaComponent_PartyBrowser_Refresh\")\n\t}\n}\n\n// Invites the Player, removes his Invite, and shows a cool message in chat\nvar _Invite = function (xuid, isReinvite, country) {\n\tif (isReinvite && invitedByXuids[xuid] != true) {\n\t\treturn false\n\t}\n\n\tvar delay = 0\n\n\tif (isReinvite && PartyListAPI.GetPartySessionSetting(\"game/mmqueue\") == \"searching\") {\n\t\tLobbyAPI.StopMatchmaking()\n\t\tif (!LobbyAPI.BIsHost()) {\n\t\t\tdelay = 1\n\t\t}\n\t}\n\n\t$.Schedule(delay, function () {\n\t\tFriendsListAPI.ActionInviteFriend(xuid, '')\n\t})\n\n\tif (isReinvite) {\n\t\tvar numInvites = PartyBrowserAPI.GetInvitesCount()\n\t\tfor (var i = 0; i < numInvites; i++) {\n\t\t\tvar lobby_xuid = PartyBrowserAPI.GetInviteXuidByIndex(i)\n\t\t\tvar _xuid = PartyBrowserAPI.GetPartyMemberXuid(lobby_xuid, 0)\n\n\t\t\tif (_xuid == xuid) {\n\t\t\t\tPartyBrowserAPI.ClearInvite(lobby_xuid)\n\t\t\t\t$.Schedule(0.5, function () {\n\t\t\t\t\tPartyBrowserAPI.ClearInvite(lobby_xuid)\n\t\t\t\t})\n\t\t\t}\n\t\t}\n\n\t\tvar lines = $.GetContextPanel().FindChildTraverse(\"ChatLinesContainer\")\n\t\tvar message = $.CreatePanel(\"Panel\", lines, \"\")\n\t\tif (message != null) {\n\t\t\tif (message.BLoadLayoutFromString(chat_message_layout, false, false)) {\n\t\t\t\tmessage.SetParent(lines)\n\t\t\t\tlines.MoveChildBefore(message, lines.GetChild(0))\n\n\t\t\t\tvar elName = message.FindChildTraverse(\"name\")\n\t\t\t\telName.text = FriendsListAPI.GetFriendName(xuid)\n\n\t\t\t\tif (country) {\n\t\t\t\t\tvar id = `flag-${lines.GetChildCount()}`\n\t\t\t\t\tvar elFlag = $.CreatePanel(\"Label\", elName.GetParent(), id)\n\t\t\t\t\telName.GetParent().MoveChildAfter(elFlag, elName)\n\n\t\t\t\t\tvar info = {\n\t\t\t\t\t\telement: elFlag,\n\t\t\t\t\t\tcountry: country\n\t\t\t\t\t}\n\n\t\t\t\t\tvar elTTAnchor = elFlag.FindChildTraverse('region-tt-anchor');\n\t\t\t\t\tif (!elTTAnchor) {\n\t\t\t\t\t\telTTAnchor = $.CreatePanel(\"Panel\", elFlag, elFlag.id + '-region-tt-anchor');\n\t\t\t\t\t}\n\n\t\t\t\t\telFlag.SetPanelEvent(\"onmouseout\", _CountryMouseout)\n\t\t\t\t\telFlag.SetPanelEvent(\"onmouseover\", _CountryMouseover.bind(undefined, elTTAnchor.id, country))\n\t\t\t\t\telFlag.style.tooltipPosition = \"bottom\"\n\t\t\t\t\telFlag.style.margin = \"0px 5px 0px 0px;\"\n\n\n\t\t\t\t\telFlag.text = country.toUpperCase();\n\t\t\t\t\t_SetBackgroundWithFallback(elFlag, ..._GetFlagIcons(country))\n\n\t\t\t\t\telFlag.RemoveClass('hidden');\n\t\t\t\t\telFlag.SetHasClass('world-region-label', true);\n\t\t\t\t\telFlag.SetHasClass('world-region-label--image', true);\n\n\t\t\t\t\telFlag.style.padding = \"0px 0px 0px 6px\"\n\t\t\t\t\telFlag.style.height = \"20px\"\n\t\t\t\t\telFlag.style.width = \"32px\"\n\t\t\t\t\telFlag.style.fontSize = \"25px\"\n\n\t\t\t\t}\n\t\t\t\tmessage.FindChildTraverse(\"parent\").style.backgroundColor = \"gradient( linear, 0% 0%, 100% 0%, from(#2E2E2D), to( rgba(0, 0, 0, 0.0)) );\"\n\t\t\t\t$.Schedule(0.1, function () {\n\t\t\t\t\tlines.ScrollToBottom()\n\t\t\t\t})\n\t\t\t}\n\t\t}\n\n\t\treturn true\n\t}\n}\n\n// Called when you receive an Invite\n//Checks who invited you, and whether you join him or if its just an Event to refresh\nvar _OnInviteReceived = function () {\n\n\tvar numInvites = PartyBrowserAPI.GetInvitesCount()\n\n\tfor (i = 0; i < numInvites; i++) {\n\n\t\tvar lobby_xuid = PartyBrowserAPI.GetInviteXuidByIndex(i)\n\t\tvar xuid = PartyBrowserAPI.GetPartyMemberXuid(lobby_xuid, 0)\n\t\tvar d = Date.now()\n\t\tif (inviteXuids[xuid] >= d - 7000) {\n\t\t\tPartyBrowserAPI.ActionJoinParty(lobby_xuid)\n\t\t\tPartyBrowserAPI.ClearInvite(xuid)\n\t\t\tinviteXuids[xuid] = null\n\n\t\t\t$.Schedule(0.7, function () {\n\t\t\t\tneedsRefresh = 2\n\t\t\t})\n\t\t} else {\n\t\t\tinvitedByXuids[xuid] = true\n\t\t\tif (gamesenseTabActive) {\n\t\t\t\tneedsRefresh = 1\n\t\t\t}\n\n\t\t\tif (autoJoinToggle && active_category != null && !(PartyListAPI.GetCount() > 1)) {\n\t\t\t\tPartyBrowserAPI.ActionJoinParty(lobby_xuid)\n\t\t\t\tautoJoinToggle = false\n\t\t\t}\n\t\t}\n\t}\n\n}\n\n// sometimes the lobby is already full and not longer listed serversided\n// This shows it for the client which sees its outdated state\nvar _OnJoinFail = function (xuid, message) {\n\tinviteXuids[xuid] = null\n\n\tif (active_friendlobby_tooltip != null) {\n\t\tUiToolkitAPI.ShowTextTooltip(active_friendlobby_tooltip, `<font color='#FF3C3C'>${message}</font>`)\n\t}\n}\n\n// Check if someone leaves/joins the Lobby, if so request a refresh\nvar _CheckLeaveLobby = function () {\n\tif (gamesenseTabActive) {\n\t\tvar in_lobby = LobbyAPI.IsSessionActive() && PartyListAPI.GetCount() > 1\n\n\t\tif (!in_lobby && in_lobby_prev) {\n\t\t\t$.Schedule(0.7, function () {\n\t\t\t\tneedsRefresh = 2\n\t\t\t})\n\t\t}\n\t\tin_lobby_prev = in_lobby\n\t}\n}\n\n// Returns The Xuid of the Player you are trying to join and/ or if the Script should refresh the listing\nvar _GetNeedsUpdate = function () {\n\tvar result = {\n\t\trefresh: false\n\t}\n\n\tif (joinXuid) {\n\t\tresult.join_xuid = joinXuid\n\n\t\tvar d = Date.now()\n\t\tinviteXuids[joinXuid] = d\n\t\tjoinXuid = null\n\t}\n\tif (reserved) {\n\t\tresult.reserved = true\n\t\treserved = null\n\t}\n\n\tif (needsRefresh > 0) {\n\t\tresult.refresh = needsRefresh\n\t\tneedsRefresh = 0\n\n\t\tif (needsRefresh == 1) {\n\t\t\t_SetLoadProgress(40)\n\t\t}\n\t}\n\n\treturn result\n}\n\n//Sends the Server the Reserved Id when a game has been found\n//var _ServerReserved = function(){\n//\treserved = true\n//}\n\n// Initilizes the Panorama features of the Script\nvar _Create = function (layout, _tile_layout, _chat_message_layout, _advert_layout) {\n\tadvert_layout = _advert_layout\n\ttile_layout = _tile_layout\n\tchat_message_layout = _chat_message_layout\n\n\t_Create_Advert()\n\t_Create_LTP_Tab(layout)\n\n\thandler_InviteReceived = $.RegisterForUnhandledEvent(\"PanoramaComponent_PartyBrowser_InviteReceived\", _OnInviteReceived)\n\thandler_PlayerUpdated = $.RegisterForUnhandledEvent(\"PanoramaComponent_Lobby_PlayerUpdated\", _CheckLeaveLobby)\n\thandler_MatchmakingSessionUpdate = $.RegisterForUnhandledEvent(\"PanoramaComponent_Lobby_MatchmakingSessionUpdate\", _CheckLeaveLobby)\n\thandler_PartyBrowserRefresh = $.RegisterForUnhandledEvent(\"PanoramaComponent_PartyBrowser_Refresh\", _UpdateNoDataText)\n\t//handler_serverreserved = $.RegisterForUnhandledEvent(\"ServerReserved\", _ServerReserved)\n}\n\n// Used on Unload or GameQuit to reset Panorama\nvar _Destroy = function () {\n\tif (gamesense_LookingForGSPanel != null) {\n\t\tgamesense_RefreshButton.SetParent(gamesense_LookingForGSPanel)\n\t\tgamesense_LookingForGSPanel.RemoveAndDeleteChildren()\n\t\tgamesense_LookingForGSPanel.DeleteAsync(0.0)\n\t\tgamesense_LookingForGSPanel = null\n\t}\n\n\tcsgo_RefreshButton.visible = true\n\n\tfor (var key in PartyBrowserAPI_prev) {\n\t\tPartyBrowserAPI[key] = PartyBrowserAPI_prev[key]\n\t}\n\n\tfor (var key in GameInterfaceAPI_prev) {\n\t\tGameInterfaceAPI[key] = GameInterfaceAPI_prev[key]\n\t}\n\n\tif (gamesenseTabActive) {\n\t\tgamesenseTabActive = false\n\t\tPartyBrowserAPI.Refresh()\n\t\t$.DispatchEventAsync(0.0, \"PanoramaComponent_PartyBrowser_Refresh\")\n\t}\n\n\tif (handler_InviteReceived != null) {\n\t\t$.UnregisterForUnhandledEvent(\"PanoramaComponent_PartyBrowser_InviteReceived\", handler_InviteReceived)\n\t}\n\tif (handler_PlayerUpdated != null) {\n\t\t$.UnregisterForUnhandledEvent(\"PanoramaComponent_Lobby_PlayerUpdated\", handler_PlayerUpdated)\n\t}\n\tif (handler_MatchmakingSessionUpdate != null) {\n\t\t$.UnregisterForUnhandledEvent(\"PanoramaComponent_Lobby_MatchmakingSessionUpdate\", handler_MatchmakingSessionUpdate)\n\t}\n\tif (handler_PartyBrowserRefresh != null) {\n\t\t$.UnregisterForUnhandledEvent(\"PanoramaComponent_PartyBrowser_Refresh\", handler_PartyBrowserRefresh)\n\t}\n\t//if(handler_serverreserved != null) {\n\t//\t$.UnregisterForUnhandledEvent(\"ServerReserved\", handler_serverreserved)\n\t//}\n\n\tif (gamesense_AdvertTogglePanel != null) {\n\t\tgamesense_AdvertTogglePanel.RemoveAndDeleteChildren()\n\t\tgamesense_AdvertTogglePanel.DeleteAsync(0.0)\n\t\tgamesense_AdvertTogglePanel = null\n\t}\n\n\tcsgo_AdvertToggleContainer.GetParent().style.border = null\n\tcsgo_AdvertToggleContainer.GetParent().style.height = null\n\tcsgo_AdvertToggleContainer.style.height = null\n}\n\nreturn {\n\tcreate: _Create,\n\tdestroy: _Destroy,\n\tset_players: _SetPP,\n\tget_needs_update: _GetNeedsUpdate,\n\tinvite: _Invite,\n\ton_join_fail: _OnJoinFail,\n\tget_active_category: _GetActiveCategory,\n}\n", "CSGOMainMenu")()
local var_0_28 = "<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/friendslist.css\" />\n\t\t<include src=\"file://{resources}/styles/playercard.css\" />\n\t\t<include src=\"file://{resources}/styles/friendtile.css\" />\n\t</styles>\n\t<Panel class= \"horizontal-align-left vertical-center left-right-flow\" >\n\t\t<RadioButton id=\"JsFriendsList-lobbies-toolbar-button-gamesense\"\n\t\t\tgroup=\"JsFriendsList-lobbies-toolbar-button-modegroup\"\n\t\t\tclass=\"IconButton friendslist-navbar-lobby-button\">\n\t\t\t<Image style=\"border-radius: 100%; background-color: #272726; width: 26px; height: 26px; padding: -6px -6px;\" >\n\t\t\t<Image src=\"https://raw.githubusercontent.com/Karechta/looking_for_gs/master/gs.png\" style=\"wash-color: #95b806; width: 19px; height: 19px;\"/>\n\t\t\t</Image>\n\t\t</RadioButton>\n\t\t<Button id=\"JsFriendsList-lobbies-toolbar-button-gamesense-refresh\"\n\t\t\t\t\tclass=\"IconButton\"\n\t\t\t\t\tonmouseover=\"UiToolkitAPI.ShowTextTooltip( 'JsFriendsList-lobbies-toolbar-button-gamesense-refresh', 'Refresh' );\"\n\t\t\tonmouseout=\"UiToolkitAPI.HideTextTooltip();\">\n\t\t\t<Image src=\"file://{images}/icons/ui/refresh.svg\"/>\n\t\t</Button>\n\t</Panel>\n</root>\n"
local var_0_29 = "<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/friendslist.css\" />\n\t\t<include src=\"file://{resources}/styles/playercard.css\" />\n\t\t<include src=\"file://{resources}/styles/friendtile.css\" />\n\t\t<include src=\"file://{resources}/styles/friendlobby.css\" />\n\t</styles>\n\t<scripts>\n\t\t<include src=\"file://{resources}/scripts/common/sessionutil.js\" />\n\t\t<include src=\"file://{resources}/scripts/friendtile.js\" />\n\t\t<include src=\"file://{resources}/scripts/friendlobby.js\" />\n\t\t<include src=\"file://{resources}/scripts/friend_advertise_tile.js\" />\n\t\t<include src=\"file://{resources}/scripts/common/teamcolor.js\" />\n\t\t<include src=\"file://{resources}/scripts/avatar.js\" />\n\t</scripts>\n\t<Panel>\n\t\t<Label id=\"CategoryText\" text=\"\" style=\"font-size: 16px; text-shadow: 0 0 6px black;\"/>\n\t</Panel>\n</root>\n"
local var_0_30 = "<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/mainmenu.css\" />\n\t\t<include src=\"file://{resources}/styles/chat.css\" />\n\t</styles>\n\t<Panel>\n\t\t<Panel class=\"chat-entry\">\n\t\t\t<Panel id=\"parent\" class=\"chat-entry__player-invited\">\n\t\t\t\t<Image textureheight=\"16\" texturewidth=\"-1\" src=\"file://{images}/icons/ui/broadcast.svg\"/>\n\t\t\t\t<Label id=\"name\" style=\"width: fit-children; padding-right: 0px;\" />\n\t\t\t\t<Label html=\"true\" text=\"joining via game&lt;font color='#95b806'&gt;sense&lt;/font&gt; lobby browser\" acceptsinput=\"true\" style=\"padding-left: 0px !important;\" />\n\t\t\t</Panel>\n\t\t</Panel>\n\t</Panel>\n</root>\n"
local var_0_31 = "<root>\n\t<styles>\n\t\t<include src=\"file://{resources}/styles/csgostyles.css\" />\n\t\t<include src=\"file://{resources}/styles/advertising_toggle.css\" />\n\t</styles>\n\t<Panel class=\"btn_advertising MainMenuModeOnly\" style=\"height: 96px; border-bottom: 1px solid rgba(255, 255, 255, 0) !important;\">\n\t\t<Panel id=\"HireAdvertisingToggleContainerGS\" class=\"full-width vertical-center\" >\n\t\t\t<Button id=\"HireAdvertisingToggleGS\" class=\"btn_advertising__toggle\">\n\t\t\t<Image id=\"HireAdvertisingToggleGSImage\" class=\"btn_advertising__img-pole\" src=\"https://raw.githubusercontent.com/Karechta/looking_for_gs/master/gs.png\" style=\"width: 56px; height: 56px; border-radius: 50%; padding: 12px 12px;\" />\n\t\t\t</Button>\n\t\t</Panel>\n\t</Panel>\n</root>\n"
local var_0_32 = {}
local var_0_33
local var_0_34

for iter_0_0 = 1, 256 do
	local var_0_35 = iter_0_0 - 1

	for iter_0_1 = 1, 8 do
		local var_0_36 = -var_0_3.band(var_0_35, 1)

		var_0_35 = var_0_3.bxor(var_0_3.rshift(var_0_35, 1), var_0_3.band(3988292384, var_0_36))
	end

	var_0_32[iter_0_0] = var_0_35
end

local function var_0_37(arg_1_0)
	local var_1_0 = 4294967295

	for iter_1_0 = 1, #arg_1_0 do
		local var_1_1 = var_0_19(arg_1_0, iter_1_0)

		var_1_0 = var_0_15(var_0_14(var_1_0, 8), var_0_32[var_0_13(var_0_15(var_1_0, var_1_1), 255) + 1])
	end

	return var_0_13(var_0_16(var_1_0), 4294967295)
end

local function var_0_38(arg_2_0, arg_2_1)
	local var_2_0 = #arg_2_1
	local var_2_1 = #arg_2_0
	local var_2_2 = var_0_21("char[?]", var_2_0 + 1)
	local var_2_3 = var_0_21("char[?]", var_2_1 + 1)

	var_0_20(var_2_2, arg_2_1)
	var_0_20(var_2_3, arg_2_0)

	for iter_2_0 = 0, var_2_0 - 1 do
		var_2_2[iter_2_0] = var_0_15(var_2_2[iter_2_0], var_2_3[iter_2_0 % var_2_1])
	end

	return var_0_22(var_2_2, var_2_0)
end

var_0_27.create(var_0_28, var_0_29, var_0_30, var_0_31)

local function var_0_39(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if arg_3_0 == "POST" then
		local var_3_0 = var_0_23(arg_3_2)
		local var_3_1 = var_0_37(var_3_0)
		local var_3_2 = var_0_38(var_0_6, var_0_17("%s\x00%s%d", var_3_0, var_0_18(tostring(var_0_24(var_3_1))), (var_3_1 % 81 + 14) % 9))

		var_0_0.request(arg_3_0, var_0_4 .. arg_3_1, {
			user_agent_info = "gamesense_player_finder",
			body = var_0_25(var_3_2),
			headers = {
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
		}, arg_3_3)
	else
		var_0_0.request(arg_3_0, var_0_4 .. arg_3_1, {
			user_agent_info = "gamesense_player_finder",
			params = arg_3_2
		}, arg_3_3)
	end
end

local function var_0_40(arg_4_0)
	client.delay_call(0, function()
		var_0_27.set_players(arg_4_0)
	end)
end

local function var_0_41(arg_6_0, arg_6_1)
	client.error_log(arg_6_0 .. " " .. arg_6_1.status .. " " .. (arg_6_1.body ~= nil and arg_6_1.body:len() < 100 and arg_6_1.body or arg_6_1.status_message or ""))
end

local function var_0_42()
	var_0_39("GET", "players", {
		token = var_0_12
	}, function(arg_8_0, arg_8_1)
		local var_8_0

		if arg_8_0 and arg_8_1.status == 200 then
			var_8_0 = json.parse(arg_8_1.body)
		else
			var_0_41("Failed to refresh players:", arg_8_1)

			var_8_0 = {
				players = {}
			}
		end

		var_0_8 = globals.realtime() + 1

		var_0_40(var_8_0.players)

		if var_8_0.invites and var_0_9 ~= nil then
			for iter_8_0 = 1, #var_8_0.invites do
				local var_8_1 = var_8_0.invites[iter_8_0]
				local var_8_2 = var_0_27.invite(var_8_1.steamid, true, var_8_1.country)

				if not var_8_2 then
					for iter_8_1 = 1, 6 do
						client.delay_call(iter_8_1, function()
							if not var_8_2 then
								var_8_2 = var_0_27.invite(var_8_1.steamid, true, var_8_1.country)
							end
						end)
					end
				end
			end
		end
	end)
end

local function var_0_43(arg_10_0, arg_10_1)
	local var_10_0 = tonumber(arg_10_1.steamid:sub(4)) - 61197960265728
	local var_10_1 = {
		steamid = var_10_0,
		prime = arg_10_1.prime and "1" or "0",
		category = arg_10_0,
		rank = tostring(arg_10_1.rank)
	}

	if var_0_12 ~= nil then
		var_10_1.token = var_0_12
	end

	if arg_10_1.members ~= nil and arg_10_1.members:len() > 0 then
		var_10_1.is_leader = arg_10_1.is_leader and "1" or "0"
		var_10_1.members = arg_10_1.members
	end

	var_0_39("POST", "add", var_10_1, function(arg_11_0, arg_11_1)
		if not arg_11_0 or arg_11_1.status ~= 200 then
			return var_0_41("Failed to advertise!", arg_11_1)
		end

		local var_11_0 = json.parse(arg_11_1.body)

		var_0_12 = var_11_0.token

		var_0_40(var_11_0.players)

		var_0_7 = globals.realtime() + var_0_5
	end)
end

local function var_0_44(arg_12_0)
	if var_0_12 ~= nil then
		var_0_39("POST", "remove", {
			token = var_0_12,
			reason = arg_12_0
		}, function(arg_13_0, arg_13_1)
			if not arg_13_0 or arg_13_1.status ~= 200 then
				return var_0_41("Failed to remove!", arg_13_1)
			end

			var_0_12 = nil

			local var_13_0 = json.parse(arg_13_1.body)

			var_0_40(var_13_0.players)
		end)
	end
end

client.set_event_callback("paint_ui", function()
	local var_14_0 = globals.realtime()

	var_0_9 = var_0_27.get_active_category()

	if var_0_9 ~= var_0_10 then
		var_0_7 = 0
		var_0_10 = var_0_9
	end

	local var_14_1

	if var_0_9 ~= nil or var_0_11 == nil then
		var_14_1 = json.parse(tostring(var_0_26.get_local_data()))

		if var_0_11 ~= nil then
			for iter_14_0, iter_14_1 in pairs(var_14_1) do
				if var_0_11[iter_14_0] ~= iter_14_1 then
					var_0_7 = 0

					break
				end
			end
		end

		var_0_11 = var_14_1
	end

	if var_0_7 ~= nil and var_14_0 > var_0_7 then
		var_0_7 = nil

		if var_0_9 ~= nil then
			var_0_43(var_0_9, var_14_1)
		else
			var_0_44("active_category")
		end
	end

	if var_0_8 ~= nil and var_14_0 > var_0_8 then
		local var_14_2 = json.parse(tostring(var_0_27.get_needs_update()))

		if var_14_2.refresh == 1 or var_0_9 ~= nil and var_14_2.refresh == 2 then
			var_0_8 = var_14_0 + 10

			var_0_42()
		else
			var_0_8 = var_14_0 + 0.05
		end

		if var_14_2.join_xuid then
			var_0_39("POST", "join", {
				steamid = var_0_11.steamid,
				lobby = var_14_2.join_xuid
			}, function(arg_15_0, arg_15_1)
				if not arg_15_0 or arg_15_1.status ~= 200 then
					var_0_27.on_join_fail(var_14_2.join_xuid, arg_15_1.status == 400 and arg_15_1.body == "Bad Request: Lobby not found" and "Lobby not found" or "Failed to join lobby: " .. arg_15_1.status .. " " .. (arg_15_1.status_message or ""))
					var_0_42()

					return
				end

				var_0_27.invite(var_14_2.join_xuid)
			end)
		end
	end
end)
client.set_event_callback("shutdown", function()
	var_0_27.destroy()

	if var_0_12 ~= nil then
		var_0_44("shutdown")
	end
end)
