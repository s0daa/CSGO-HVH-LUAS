slot0 = require("gamesense/http")
slot2 = require("ffi")
slot3 = require("bit")
slot4 = "https://sapphyr.us/looking-to-play/v5/"
slot5 = 60
slot6 = "848yujjEYLhPNLC3YX83WSHTm6sWa3nHELJFLWTLsR9g6RPvfkTT2BCq2gkgSMdh2rcNWU84qsXFbwXAC2WQ4KYThMWu535sbGmkhWhgCvvndRFDw5rzRwAuDC2ZD"
slot7 = 0
slot8 = 0
slot9, slot10, slot11, slot12 = nil
slot13 = slot3.band
slot14 = slot3.rshift
slot15 = slot3.bxor
slot16 = slot3.bnot
slot17 = string.format
slot18 = string.reverse
slot19 = string.byte
slot20 = slot2.copy
slot21 = slot2.new
slot22 = slot2.string
slot23 = json.stringify
slot24 = math.abs
slot25 = require("gamesense/base64").encode
slot26 = panorama.loadstring([[
	var _this = this
var toString_text = "function toString() { [native code] }"

var _GetLocalData = function() {
	var xuid = MyPersonaAPI.GetXuid()
	var members = []
	var prime = PartyListAPI.GetFriendPrimeEligible(xuid)

	var rank = FriendsListAPI.GetFriendCompetitiveRank(xuid, "competitive")
	var rank_count = 0
	if (rank > 0) { 
		rank_count = 1
	}
	var is_leader = true

	var checked = [
		// ["MyPersonaAPI", "GetXuid"],
		["LobbyAPI", "IsSessionActive"],
		["LobbyAPI", "BIsHost"],
		["PartyListAPI", "GetCount"],
		["PartyListAPI", "GetXuidByIndex"],
		["PartyListAPI", "GetFriendPrimeEligible"],
		["PartyListAPI", "GetFriendCompetitiveRank"]
	]

	try {
		for(i = 0; i < 6; i++) {
			var name = checked[i]
			var func = _this[ name[0] ][ name[1] ]
			if(func.toString() != `function ${name[1]}() { [native code] }` || func.toString.toString() != toString_text || func.toString.toString.toString() != toString_text){
				return {}
			}
		}
	} catch(e) {
		return {}
	}

	if(LobbyAPI.IsSessionActive()) {
		is_leader = LobbyAPI.BIsHost();
		
		for (i = 0; i < PartyListAPI.GetCount(); i++) {
			var member_xuid = PartyListAPI.GetXuidByIndex(i)

			if(member_xuid == xuid) {
				continue
			}

			members.push(member_xuid)

			prime = PartyListAPI.GetFriendPrimeEligible(member_xuid)

			var member_rank = PartyListAPI.GetFriendCompetitiveRank(member_xuid, "competitive")
			if(member_rank > 0) {
				rank += member_rank
				rank_count += 1
			}
			
		}
	}
	return {
		steamid: xuid,
		prime: prime,
		rank: Math.floor(rank/rank_count) || 0,
		members: members.join(","),
		is_leader: is_leader
	}
}

return {
	get_local_data: _GetLocalData
}
]], "")()
slot27 = panorama.loadstring([[
	var gamesense_LookingForGSPanel, gamesense_LookingForGSButton,  gamesense_RefreshButton
var csgo_LookingForButtonsParent, csgo_LookingForDZButton, csgo_LookingForCoopButton, csgo_RefreshButton

var gamesense_AdvertTogglePanel, gamesense_AdvertToggleBTN, gamesense_AdvertToggleIMG
var csgo_AdvertToggleContainer

var handler_InviteReceived, handler_PlayerUpdated, handler_MatchmakingSessionUpdate, handler_PartyBrowserRefresh

var tile_layout, chat_message_layout, advert_layout

var active_category = null
var players = []
var PPList = []
var PPData = {}
var reserved

var autoJoinToggle = false
var gamesense_AdvertTogglePanelID = Math.random().toString(36).substr(2, 10);

var CategoryNames = {
	legit: "Legit",
	semirage: "Semi-Rage",
	rage: "Full Rage",
	derank: "Deranking"
}

var CheckboxImages = {
	true: "file://{images}/icons/ui/checkbox.svg",
	false: "https://i.imgur.com/DyZtfUB.png"
}

var CountryNames = {
	KW: "Kuwait", MA: "Morocco ", AF: "Afghanistan", AL: "Albania", DZ: "Algeria", AS: "American Samoa", AD: "Andorra", AO: "Angola", AI: "Anguilla", AQ: "Antarctica", AG: "Antigua and Barbuda", AR: "Argentina", AM: "Armenia", AW: "Aruba", AU: "Australia", AT: "Austria", AZ: "Azerbaijan", BS: "Bahamas", BH: "Bahrain", BD: "Bangladesh", BB: "Barbados", BY: "Belarus", BE: "Belgium", BZ: "Belize", BJ: "Benin", BM: "Bermuda", BT: "Bhutan", BO: "Bolivia", BA: "Bosnia and Herzegovina", BW: "Botswana", BV: "Bouvet Island", BR: "Brazil", IO: "British Indian Ocean Territory", BN: "Brunei Darussalam", BG: "Bulgaria", BF: "Burkina Faso", BI: "Burundi", KH: "Cambodia", CM: "Cameroon", CA: "Canada", CV: "Cape Verde", KY: "Cayman Islands", CF: "Central African Republic", TD: "Chad", CL: "Chile", CN: "China", CX: "Christmas Island", CC: "Cocos (Keeling) Islands", CO: "Colombia", KM: "Comoros", CG: "Congo", CD: "Congo, the Democratic Republic of the", CK: "Cook Islands", CR: "Costa Rica", CI: "Cote D'Ivoire", HR: "Croatia", CU: "Cuba", CY: "Cyprus", CZ: "Czech Republic", DK: "Denmark", DJ: "Djibouti", DM: "Dominica", DO: "Dominican Republic", EC: "Ecuador", EG: "Egypt", SV: "El Salvador", GQ: "Equatorial Guinea", ER: "Eritrea", EE: "Estonia", ET: "Ethiopia", FK: "Falkland Islands (Malvinas)", FO: "Faroe Islands", FJ: "Fiji", FI: "Finland", FR: "France", GF: "French Guiana", PF: "French Polynesia", TF: "French Southern Territories", GA: "Gabon", GM: "Gambia", GE: "Georgia", DE: "Germany", GH: "Ghana", GI: "Gibraltar", GR: "Greece", GL: "Greenland", GD: "Grenada", GP: "Guadeloupe", GU: "Guam", GT: "Guatemala", GN: "Guinea", GW: "Guinea-Bissau", GY: "Guyana", HT: "Haiti", HM: "Heard Island and Mcdonald Islands", VA: "Holy See (Vatican City State)", HN: "Honduras", HK: "Hong Kong", HU: "Hungary", IS: "Iceland", IN: "India", ID: "Indonesia", IR: "Iran, Islamic Republic of", IQ: "Iraq", IE: "Ireland", IL: "Israel", IT: "Italy", JM: "Jamaica", JP: "Japan", JO: "Jordan", KZ: "Kazakhstan", KE: "Kenya", KI: "Kiribati", KP: "North Korea", KR: "South Korea", KW: "Kuwait", KG: "Kyrgyzstan", LA: "Lao People's Democratic Republic", LV: "Latvia", LB: "Lebanon", LS: "Lesotho", LR: "Liberia", LY: "Libya", LI: "Liechtenstein", LT: "Lithuania", LU: "Luxembourg", MO: "Macao", MG: "Madagascar", MW: "Malawi", MY: "Malaysia", MV: "Maldives", ML: "Mali", MT: "Malta", MH: "Marshall Islands", MQ: "Martinique", MR: "Mauritania", MU: "Mauritius", YT: "Mayotte", MX: "Mexico", FM: "Micronesia, Federated States of", MD: "Moldova, Republic of", MC: "Monaco", MN: "Mongolia", MS: "Montserrat", MA: "Morocco", MZ: "Mozambique", MM: "Myanmar", NA: "Namibia", NR: "Nauru", NP: "Nepal", NL: "Netherlands", NC: "New Caledonia", NZ: "New Zealand", NI: "Nicaragua", NE: "Niger", NG: "Nigeria", NU: "Niue", NF: "Norfolk Island", MK: "North Macedonia, Republic of", MP: "Northern Mariana Islands", NO: "Norway", OM: "Oman", PK: "Pakistan", PW: "Palau", PS: "Palestinian Territory, Occupied", PA: "Panama", PG: "Papua New Guinea", PY: "Paraguay", PE: "Peru", PH: "Philippines", PN: "Pitcairn", PL: "Poland", PT: "Portugal", PR: "Puerto Rico", QA: "Qatar", RE: "Reunion", RO: "Romania", RU: "Russia", RW: "Rwanda", SH: "Saint Helena", KN: "Saint Kitts and Nevis", LC: "Saint Lucia", PM: "Saint Pierre and Miquelon", VC: "Saint Vincent and the Grenadines", WS: "Samoa", SM: "San Marino", ST: "Sao Tome and Principe", SA: "Saudi Arabia", SN: "Senegal", SC: "Seychelles", SL: "Sierra Leone", SG: "Singapore", SK: "Slovakia", SI: "Slovenia", SB: "Solomon Islands", SO: "Somalia", ZA: "South Africa", GS: "South Georgia and the South Sandwich Islands", ES: "Spain", LK: "Sri Lanka", SD: "Sudan", SR: "Suriname", SJ: "Svalbard and Jan Mayen", SZ: "Eswatini", SE: "Sweden", CH: "Switzerland", SY: "Syrian Arab Republic", TW: "Taiwan", TJ: "Tajikistan", TZ: "Tanzania, United Republic of", TH: "Thailand", TL: "Timor-Leste", TG: "Togo", TK: "Tokelau", TO: "Tonga", TT: "Trinidad and Tobago", TN: "Tunisia", TR: "Turkey", TM: "Turkmenistan", TC: "Turks and Caicos Islands", TV: "Tuvalu", UG: "Uganda", UA: "Ukraine", AE: "United Arab Emirates", GB: "United Kingdom", US: "USA", UM: "United States Minor Outlying Islands", UY: "Uruguay", UZ: "Uzbekistan", VU: "Vanuatu", VE: "Venezuela", VN: "Vietnam", VG: "Virgin Islands, British", VI: "Virgin Islands, U.S.", WF: "Wallis and Futuna", EH: "Western Sahara", YE: "Yemen", ZM: "Zambia", ZW: "Zimbabwe", AX: "Åland Islands", BQ: "Bonaire, Sint Eustatius and Saba", CW: "Curaçao", GG: "Guernsey", IM: "Isle of Man", JE: "Jersey", ME: "Montenegro", BL: "Saint Barthélemy", MF: "Saint Martin (French part)", RS: "Serbia", SX: "Sint Maarten (Dutch part)", SS: "South Sudan", XK: "Kosovo"
}

var failed_images = {
	"file://{images}/flags/BZ.png": true,
	"file://{images}/flags/TN.png": true,
	"file://{images}/flags/CY.png": true,
	"file://{images}/flags/SC.png": true,
	"file://{images}/flags/GE.png": true,
	"file://{images}/flags/AM.png": true,
	"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/bz.svg": true,
	"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/cy.svg": true,
	"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/ge.svg": true,
	"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/am.svg": true,
	"https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/tn.svg": true
}

var gameModes = [
	{
		category: "legit",
		name: "Legit Cheating",
		img: "<img src='https://raw.githubusercontent.com/Karechta/looking_for_gs/master/legit.png' style='min-height: 200px !important; height: 200px !important;' class='' />"
	},
	{
		category: "semirage",
		name: "Semi-Raging",
		img: "<img src='file://{images}/icons/ui/quest.svg' />"
	},
	{
		category: "rage",
		name: "Full Raging",
		img: "<img src='https://raw.githubusercontent.com/Karechta/looking_for_gs/master/rage.png' />"
	},
	{
		category: "derank",
		name: "Derank",
		img: "<img src='file://{images}/icons/ui/bomb_arrow_segment.svg' />"
	}
]

var needsRefresh = 0
var gamesenseTabActive = false
var loadProgress = 100
var joinXuid = null
var inviteXuids = {}
var invitedByXuids = {}
var in_lobby_prev = null
var active_friendlobby_tooltip = null
var active_hire_toggle_context_menu = null

var PartyBrowserAPI_prev = {
	GetResultsCount: PartyBrowserAPI.GetResultsCount,
	GetXuidByIndex: PartyBrowserAPI.GetXuidByIndex,
	GetPartyMembersCount: PartyBrowserAPI.GetPartyMembersCount,
	GetPartyMemberXuid: PartyBrowserAPI.GetPartyMemberXuid,
	GetPartySessionSetting: PartyBrowserAPI.GetPartySessionSetting,
	SetSearchFilter: PartyBrowserAPI.SetSearchFilter,
	Refresh: PartyBrowserAPI.Refresh,
	GetProgress: PartyBrowserAPI.GetProgress,
	GetPartyType: PartyBrowserAPI.GetPartyType
}

var GameInterfaceAPI_prev = {
	SetSettingString: GameInterfaceAPI.SetSettingString
}

PartyBrowserAPI.SetSearchFilter = function (filter) {
	if (gamesenseTabActive) {
		needsRefresh = 1
		_SetLoadProgress(20)
	}

	return PartyBrowserAPI_prev.SetSearchFilter.call(PartyBrowserAPI, filter)
}

var _UpdateNoDataText = function () {
	var panel_list = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies").FindChild("JsFriendsList-List")
	if (panel_list) {
		var panel_nodata = panel_list.FindChildTraverse('JsFriendListNoData')
		if (panel_nodata) {
			var panel_nodatadesc = panel_nodata.FindChildTraverse("JsFriendsNoDataDesc")
			if (panel_nodatadesc) {
				panel_nodatadesc.text = gamesenseTabActive ? "Couldn't find any gamesense users looking to play at this time." : $.Localize("#FriendsList_nodata_advertising")
			}
		}
	}
}


var _ClearFallbackHandlers = function (info) {
	if (info.handler_failed) {
		$.UnregisterEventHandler("ImageFailedLoad", info.panel, info.handler_failed)
		info.handler_failed = null
	}

	if (info.handler_success) {
		$.UnregisterEventHandler("ImageLoaded", info.panel, info.handler_success)
		info.handler_success = null
	}
}

var _SetNextImage = function (info) {
	// info.images = info.images.filter(image => !failed_images[image])

	if (info.i >= info.images.length - 1) {
		_ClearFallbackHandlers(info)
		return
	}

	if (info.image) {
		// $.Msg("failed image: ", info.image, " (already failed: ", failed_images[info.image], ")")
		failed_images[info.image] = true
	}

	// use next image
	info.i++
	info.image = info.images[info.i]

	// set image
	switch (info.type) {
		case "image":
			info.panel.SetImage(info.image)
			break
		case "background":
			info.panel.style.backgroundImage = `url("${info.image}")`
			break
	}
}

var _InitFallbackImage = function (info) {
	info.handler_failed = $.RegisterEventHandler("ImageFailedLoad", info.panel, _SetNextImage.bind(undefined, info))
	$.RegisterEventHandler("ImageLoaded", info.panel, _ClearFallbackHandlers.bind(undefined, info))

	info.i = -1
	_SetNextImage(info)
}

var _SetImageWithFallback = function (panel, ...images) {
	return _InitFallbackImage({
		panel: panel,
		images: images,
		type: "image"
	})
}

var _SetBackgroundWithFallback = function (panel, ...images) {
	return _InitFallbackImage({
		panel: panel,
		images: images,
		type: "background"
	})
}

var _GetFlagIcons = function (country) {
	return [
		`file://{images}/regions/${country}.png`,
		`https://raw.githubusercontent.com/hampusborgos/country-flags/master/svg/${country.toLowerCase()}.svg`,
		`https://raw.githubusercontent.com/hampusborgos/country-flags/master/png100px/${country.toLowerCase()}.png`,
	]
}


PartyBrowserAPI.GetResultsCount = function () {
	_UpdateNoDataText()
	if (gamesenseTabActive) {
		return PPList.length
	} else {
		return PartyBrowserAPI_prev.GetResultsCount.call(PartyBrowserAPI)
	}
}

PartyBrowserAPI.GetProgress = function () {
	_UpdateNoDataText()
	if (gamesenseTabActive) {
		return loadProgress
	} else {
		return PartyBrowserAPI_prev.GetProgress.call(PartyBrowserAPI)
	}
}

PartyBrowserAPI.GetXuidByIndex = function (i) {
	if (gamesenseTabActive) {
		return PPList[i]
	} else {
		return PartyBrowserAPI_prev.GetXuidByIndex.call(PartyBrowserAPI, i)
	}
}

PartyBrowserAPI.GetPartyMembersCount = function (xuid) {
	if (gamesenseTabActive && PPData[xuid]) {
		return PPData[xuid].members ? PPData[xuid].members.length + 1 : 1
	} else {
		return PartyBrowserAPI_prev.GetPartyMembersCount.call(PartyBrowserAPI, xuid, i)
	}
}

PartyBrowserAPI.GetPartyType = function (xuid) {
	if (gamesenseTabActive && PPData[xuid]) {
		return null
	} else {
		return PartyBrowserAPI_prev.GetPartyType.call(PartyBrowserAPI, xuid)
	}
}

PartyBrowserAPI.GetPartyMemberXuid = function (xuid, i) {
	if (gamesenseTabActive && PPData[xuid]) {
		return i == 0 ? xuid : (PPData[xuid].members ? PPData[xuid].members[i - 1] : null)
	} else {
		return PartyBrowserAPI_prev.GetPartyMemberXuid.call(PartyBrowserAPI, xuid, i)
	}
}

PartyBrowserAPI.GetPartySessionSetting = function (xuid, setting) {
	if (gamesenseTabActive && PPData[xuid]) {
		if (setting == "game/loc") {
			var panel_list = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies").FindChild("JsFriendsList-List")
			var tile = panel_list.FindChild(xuid)

			if (tile) {
				if (PPData[xuid].members) {
					elFriendLobby = tile.FindChildTraverse("JsFriendAdvertiseGSLobby")
					var isFirst = false
					if (elFriendLobby == null) {
						tile.style.height = "100px"
						tile.Children().forEach(function (el) {
							el.visible = false
						})

						elFriendLobby = $.CreatePanel("Panel", tile, "JsFriendAdvertiseGSLobby")
						elFriendLobby.SetAttributeString('xuid', xuid)
						elFriendLobby.BLoadLayout('file://{resources}/layout/friendlobby.xml', false, false)
						isFirst = true
					}
					if (elFriendLobby != null) {
						FriendLobby_Init(elFriendLobby, xuid, isFirst)
					}
				}

				var country = PPData[xuid].country
				if (country) {
					var elFlagImgId = `JsFriendLobbyFlagCustom-${xuid}`
					var elFlagImg = tile.FindChildTraverse(elFlagImgId)
					if (elFlagImg == null) {
						var parent

						if (PPData[xuid].members) {
							parent = tile.FindChildTraverse("JsFriendLobbySkillGroup").GetParent()
						} else {
							parent = tile.FindChildTraverse("JsFriendAdvertiseSkillGroup").GetParent()
						}

						elFlagImg = $.CreatePanel("Label", parent, elFlagImgId)


						if (PPData[xuid].members) {
							parent.MoveChildBefore(elFlagImg, tile.FindChildTraverse('JsFriendLobbySkillGroup'))
						} else {
							parent.MoveChildAfter(elFlagImg, tile.FindChildTraverse("JsRegionLabel"))
						}

						var info = {
							element: elFlagImg,
							country: country
						}

						var elTTAnchor = elFlagImg.FindChildTraverse('region-tt-anchor');
						if (!elTTAnchor) {
							elTTAnchor = $.CreatePanel("Panel", elFlagImg, elFlagImg.id + '-region-tt-anchor');
						}

						elFlagImg.SetPanelEvent("onmouseout", _CountryMouseout)
						elFlagImg.SetPanelEvent("onmouseover", _CountryMouseover.bind(undefined, elTTAnchor.id, country))
						elFlagImg.style.tooltipPosition = "bottom"
						elFlagImg.style.margin = "0px 5px 0px 0px;"


						elFlagImg.text = country.toUpperCase();
						_SetBackgroundWithFallback(elFlagImg, ..._GetFlagIcons(country))

						elFlagImg.RemoveClass('hidden');
						elFlagImg.SetHasClass('world-region-label', true);
						elFlagImg.SetHasClass('world-region-label--image', true);

					}
				}

				var elCategory = tile.FindChildTraverse("JsFriendAdvertiseGSCategory")
				if (elCategory == null) {
					var parent
					if (PPData[xuid].members) {
						parent = tile.FindChildTraverse("JsFriendLobbySkillGroup").GetParent()
					} else {
						parent = tile.FindChildTraverse("JsRegionLabel").GetParent()
					}
					elCategory = $.CreatePanel("Panel", parent, "JsFriendAdvertiseGSCategory")

					if (PPData[xuid].members) {
						parent.MoveChildAfter(elCategory, parent.GetChild(parent.GetChildCount() - 3))
						elCategory.style.paddingRight = "4px;"
					}

					if (elCategory != null) {
						elCategory.BLoadLayoutFromString(tile_layout, false, false)
					}
				}

				if (elCategory != null && elCategory.FindChildTraverse("CategoryText")) {
					var cat = PPData[xuid].category
					elCategory.FindChildTraverse("CategoryText").text = CategoryNames[cat] || cat
				}
			}
		}

		switch (setting) {
			case "game/apr":
				return PPData[xuid].prime == 1
			case "game/mode":
				return "competitive"
			case "game/ark":
				return PPData[xuid].rank * 10
			case "game/mapgroupname":
				return "workshop"
			case "game/clanid":
			case "game/clantag":
				return "gamesense"
			default:
			//$.Msg(setting)
		}
	} else {
		return PartyBrowserAPI_prev.GetPartySessionSetting.call(PartyBrowserAPI, xuid, setting)
	}
}

PartyBrowserAPI.Refresh = function () {
	_UpdateNoDataText()
	if (!gamesenseTabActive) {
		return PartyBrowserAPI_prev.Refresh.call(PartyBrowserAPI)
	}
}


GameInterfaceAPI.SetSettingString = function (filter, value) {
	if (gamesenseTabActive && filter == 'ui_nearbylobbies_filter') {
		csgo_RefreshButton.visible = true
		gamesense_RefreshButton.visible = false
		gamesenseTabActive = false
		var panel_list = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies").FindChild("JsFriendsList-List")

		panel_list.Children().forEach(function (el) {
			try {
				var elFlagImgId = `JsFriendLobbyFlagCustom-${el.id}`
				el.FindChildTraverse(elFlagImgId).DeleteAsync(0.0)
				el.FindChildTraverse("JsFriendAdvertiseGSCategory").DeleteAsync(0.0)
			}
			catch (e) {

			}
		})
	}


	return GameInterfaceAPI_prev.SetSettingString.call(GameInterfaceAPI, filter, value)
}


//Lobby listing Below


var FriendLobby_OpenContextMenu = function (xuid) {
	$.DispatchEvent('SidebarContextMenuActive', true)

	var contextMenuPanel = UiToolkitAPI.ShowCustomLayoutContextMenuParametersDismissEvent(
		'',
		'',
		'file://{resources}/layout/context_menus/context_menu_playercard.xml',
		'xuid=' + xuid,
		function () {
			$.DispatchEvent('SidebarContextMenuActive', false)
		}
	);
	contextMenuPanel.AddClass("ContextMenu_NoArrow");
}

var FriendLobby_Join = function (xuid) {
	//Check if already in Lobby
	if (LobbyAPI.IsSessionActive()) {
		for (i = 0; i < PartyListAPI.GetCount(); i++) {
			var member_xuid = PartyListAPI.GetXuidByIndex(i)

			if (member_xuid == xuid) {
				return
			}
		}
	}
	//Set JoinXuid to be called by NeedsUpdate
	$.DispatchEvent('PlaySoundEffect', 'PanoramaUI.Lobby.Joined', 'MOUSE')
	joinXuid = xuid
}

var FriendLobby_SlotMouseover = function (id) {
	active_friendlobby_tooltip = id
	UiToolkitAPI.ShowTextTooltip(id, "Join game<font color='#95b806'>sense</font> lobby")
}

var FriendLobby_SlotMouseout = function (id) {
	active_friendlobby_tooltip = null
	UiToolkitAPI.HideTextTooltip()
}

var _CountryMouseover = function (id, country) {
	UiToolkitAPI.ShowTextTooltip(id, `${CountryNames[country] || country}`)
}

var _CountryMouseout = function (id, country) {
	UiToolkitAPI.HideTextTooltip()
}

var FriendLobby_Init = function (elFriendLobby, xuid, isFirst) {
	elFriendLobby.style.borderBottom = "1px solid rgba(255, 255, 255, 0) !important;"

	// La Familia de El
	var elPrime = elFriendLobby.FindChildTraverse('JsFriendLobbyPrime')
	var elSkillGroupImg = elFriendLobby.FindChildTraverse('JsFriendLobbySkillGroup')
	var elSettingsLabel = elFriendLobby.FindChildTraverse('JsFriendLobbySettings')
	var elGroupLBtn = elFriendLobby.FindChildTraverse('JsFriendLobbyGroupBtn')
	var elGroupLabel = elFriendLobby.FindChildTraverse('JsFriendLobbyGroupTxt')
	var elAvatarRow = elFriendLobby.FindChildTraverse('JsFriendLobbyAvatars')

	if (isFirst) {
		elFriendLobby.visible = true
		elFriendLobby.RemoveClass('hidden')

		var parent = elSkillGroupImg.GetParent()
		elPrime.SetParent(parent)
		parent.MoveChildBefore(elPrime, elSkillGroupImg)

		elFriendLobby.FindChildTraverse('JsFriendLobbyLeaderAvatar').steamid = xuid
		elFriendLobby.FindChildTraverse('JsFriendLobbyLeaderBtn').SetPanelEvent('onactivate', FriendLobby_OpenContextMenu.bind(undefined, xuid))
	}
	elFriendLobby.SetDialogVariable('friendname', FriendsListAPI.GetFriendName(xuid))
	elFriendLobby.FindChildTraverse('JsFriendLobbyLeaderName').text = "#tooltip_lobby_leader_name"
	elFriendLobby.FindChildTraverse('JsFriendLobbyLeaderName').style.fontWeight = "bold"

	elSkillGroupImg.RemoveClass('hidden')
	elSkillGroupImg.SetImage(`file://{images}/icons/skillgroups/skillgroup${PPData[xuid].rank}.svg`)

	elSettingsLabel.text = CategoryNames[PPData[xuid].category]
	elSettingsLabel.visible = false

	elGroupLBtn.visible = false
	elGroupLabel.visible = false

	elPrime.visible = PPData[xuid].prime;

	var inLobby = false
	for (var i = 0; i < PartyBrowserAPI.GetPartyMembersCount(xuid); i++) {
		if (PartyBrowserAPI.GetPartyMemberXuid(xuid, i) == MyPersonaAPI.GetXuid()) {
			inLobby = true
			break
		}
	}

	elFriendLobby.FindChildTraverse('JsFriendLobbyLeaderAvatar').style.margin = "0px 7px;"
	for (var i = 1; i <= 4; i++) {
		var _xuid = PartyBrowserAPI.GetPartyMemberXuid(xuid, i)
		var slotId = xuid + ':' + i
		var playerSlot = elAvatarRow.FindChild(slotId)

		if (!playerSlot) {
			playerSlot = $.CreatePanel('Panel', elAvatarRow, slotId);
			playerSlot.BLoadLayoutSnippet('FriendLobbyAvatarSlot');
		}

		playerSlot.style.margin = "0px 12px;"

		if (i === 1)
			playerSlot.AddClass('friendlobby__slot--first');

		var elAvatar = playerSlot.FindChildTraverse('JsFriendAvatar'),
			elJoinBtn = playerSlot.FindChildTraverse('JsFriendAvatarJoin');

		if (!_xuid) {
			if (inLobby) {
				elJoinBtn.enabled = false;
				elJoinBtn.visible = false;
				elAvatar.visible = false;
			} else {
				elJoinBtn.enabled = true;
				elJoinBtn.visible = true;
				elAvatar.visible = false;

				elJoinBtn.SetPanelEvent('onactivate', FriendLobby_Join.bind(undefined, xuid))
				elJoinBtn.SetPanelEvent('onmouseover', FriendLobby_SlotMouseover.bind(undefined, slotId))
				elJoinBtn.SetPanelEvent('onmouseout', FriendLobby_SlotMouseout.bind(undefined, slotId))
			}
		} else {
			elJoinBtn.visible = false;
			elAvatar.visible = true;
			elAvatar.steamid = _xuid;

			playerSlot.FindChild('JsFriendAvatarBtn').SetPanelEvent('onactivate', FriendLobby_OpenContextMenu.bind(undefined, _xuid));
		}
	}
}

// used to Change the active Category and update the Buttons Visuals
var _SetActiveCategory = function (_active_category) {
	active_category = _active_category

	if (active_category != null) {
		gamesense_AdvertToggleIMG.style.washColor = "#95b806;"
		gamesense_AdvertToggleIMG.style.backgroundColor = "rgba(0, 0, 0, 0.4);"
		gamesense_AdvertToggleIMG.style.boxShadow = "0px 0px 6px 5.0 rgba(0, 0, 0, 0.753);"
		gamesense_AdvertToggleIMG.style.imgShadow = "0px 0px 1px 1.0 white;"

		$.DispatchEventAsync(0.0, "PlaySoundEffect", "UIPanorama.mainmenu_press_quit", "MOUSE")
	} else {
		gamesense_AdvertToggleIMG.style.washColor = "white;"
		gamesense_AdvertToggleIMG.style.backgroundColor = "rgba(0, 0, 0, 0);"
		gamesense_AdvertToggleIMG.style.boxShadow = "0px 0px 0px 0 rgba(0, 0, 0, 0);"
		gamesense_AdvertToggleIMG.style.imgShadow = "0px 0px 0px 0.0 white;"
	}
}

var _OnActiveHireToggleContextMenuDismissed = function () {
	active_hire_toggle_context_menu = null
}

// Create Advert Button on the left NavBar in the Mainmenu
var _Create_Advert = function () {
	csgo_AdvertToggleContainer = $.GetContextPanel().FindChildTraverse("HireAdvertisingToggleContainer")
	var csgo_AdvertToggleContainerParent = csgo_AdvertToggleContainer.GetParent()

	csgo_AdvertToggleContainerParent.style.flowChildren = "down"
	csgo_AdvertToggleContainerParent.style.height = "192px"
	csgo_AdvertToggleContainer.style.height = "96px"

	gamesense_AdvertTogglePanel = $.CreatePanel("Panel", csgo_AdvertToggleContainerParent, gamesense_AdvertTogglePanelID)
	if (gamesense_AdvertTogglePanel.BLoadLayoutFromString(advert_layout, false, false)) {
		gamesense_AdvertTogglePanel.borderBottom = "1px solid rgba(255, 255, 255, 0.1)"

		gamesense_AdvertToggleBTN = gamesense_AdvertTogglePanel.FindChildTraverse("HireAdvertisingToggleGS")
		if (gamesense_AdvertToggleBTN != null) {
			gamesense_AdvertToggleBTN.SetPanelEvent("onactivate", _OnActivateToggle)
			gamesense_AdvertToggleBTN.SetPanelEvent("oncontextmenu", _OnActivateToggle)
			gamesense_AdvertToggleBTN.SetPanelEvent("onmouseover", _OnHover_toggle)
			gamesense_AdvertToggleBTN.SetPanelEvent("onmouseout", function () {
				UiToolkitAPI.HideTitleTextTooltip()
			})
		}
	}

	gamesense_AdvertToggleIMG = gamesense_AdvertTogglePanel.FindChildTraverse("HireAdvertisingToggleGSImage")

	/*$.GetContextPanel().FindChildTraverse("JsMainMenuNavBar").Children().forEach((panel) => {
		$.Msg(panel.id)
	})*/
}

// Function to check if Player is able to Advertise
var _CanAdvertise = function () {
	return !(PartyListAPI.GetCount() > 4 || FriendsListAPI.IsLocalPlayerPlayingMatch() || MyPersonaAPI.IsVacBanned() || CompetitiveMatchAPI.GetCooldownSecondsRemaining() > 0)
}

// returns active category and resets if above function returns false
var _GetActiveCategory = function () {
	if (active_category && !_CanAdvertise()) {
		_SetActiveCategory(null)
	}

	return active_category
}

// Called by clicking on the Advertise Button, lists the modes to look for
var _OnActivateToggle = function () {
	if (!_CanAdvertise()) {
		return
	}

	var items = []

	gameModes.forEach(entry => {
		var labelLoc
		if (entry.category === active_category) {
			labelLoc = `${entry.img} <b><font color='#95b806'>Looking for ${entry.name}</font></b>`
		} else {
			labelLoc = `${entry.img} Looking for ${entry.name}`
		}

		items.push({
			label: labelLoc,
			style: "Icon",
			jsCallback: _SetActiveCategory.bind(undefined, entry.category)
		})
	})

	if (!(PartyListAPI.GetCount() > 1)) {
		var checkLabel = `<img src="${CheckboxImages[autoJoinToggle]}" /> Auto-join`
		items.push({
			label: checkLabel,
			style: "Icon",
			jsCallback: function () {
				autoJoinToggle = !autoJoinToggle
				_OnActivateToggle()
			}
		})
	}

	if (active_category != null) {
		items.push({
			label: "Stop Looking",
			style: "TopSeparator",
			jsCallback: function () {
				_SetActiveCategory(null)

				$.DispatchEventAsync(0.0, "PlaySoundEffect", "UIPanorama.generic_button_press", "MOUSE")
			}
		})
	}

	// create new popup
	//active_hire_toggle_context_menu = UiToolkitAPI.ShowSimpleContextMenuWithDismissEvent('HireAdvertisingToggleGS', 'ControlLibSimpleContextMenu', items, _OnActiveHireToggleContextMenuDismissed)
	active_hire_toggle_context_menu = UiToolkitAPI.ShowSimpleContextMenuWithDismissEvent('', 'ControlLibSimpleContextMenu', items, _OnActiveHireToggleContextMenuDismissed)

	// try and find auto-join button
	var auto_join_toggle_btn
	active_hire_toggle_context_menu.FindChildTraverse("ContextMenuBody").Children().forEach(function (el) {
		if (el.GetChild(0) && el.GetChild(0).text && el.GetChild(0).text.includes("Auto-join")) {
			auto_join_toggle_btn = el
		}
	})

	// add our custom hover handlers
	if (auto_join_toggle_btn) {
		// $.Msg(auto_join_toggle_btn)
		// $.Msg(auto_join_toggle_btn.Children())
		// $.Msg(auto_join_toggle_btn.Children()[0].Children())

		auto_join_toggle_btn.SetPanelEvent("onactivate", function () {
			$.DispatchEvent('PlaySoundEffect', 'UIPanorama.generic_button_press', 'MOUSE')
			autoJoinToggle = !autoJoinToggle
			// $.Msg(autoJoinToggle)

			// update image
			if (auto_join_toggle_btn && auto_join_toggle_btn.GetChild(0) && auto_join_toggle_btn.GetChild(0).GetChild(0)) {
				auto_join_toggle_btn.GetChild(0).GetChild(0).SetImage(CheckboxImages[autoJoinToggle])
			}
		})
	}
}

// Tooltip on Hover
var _OnHover_toggle = function () {
	UiToolkitAPI.ShowTitleTextTooltip(gamesense_AdvertTogglePanelID, "Looking for game<font color='#95b806'>sense</font> users", "Enables other users to find you and invite you to a lobby")
}

// Create LTP Tab, to show GS users

var _Create_LTP_Tab = function (layout) {
	csgo_LookingForCoopButton = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies-toolbar-button-cooperative")
	csgo_LookingForDZButton = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies-toolbar-button-survival")
	csgo_LookingForButtonsParent = csgo_LookingForDZButton.GetParent()

	gamesense_LookingForGSPanel = $.CreatePanel('Button', csgo_LookingForButtonsParent, 'Gamesense_Lobbies')
	if (gamesense_LookingForGSPanel.BLoadLayoutFromString(layout, false, false)) {
		gamesense_LookingForGSPanel.visible = true
		csgo_LookingForButtonsParent.MoveChildAfter(gamesense_LookingForGSPanel, csgo_LookingForCoopButton ? csgo_LookingForCoopButton : csgo_LookingForDZButton)

		gamesense_LookingForGSButton = gamesense_LookingForGSPanel.FindChildTraverse("JsFriendsList-lobbies-toolbar-button-gamesense")
		if (gamesense_LookingForGSButton != null) {
			gamesense_LookingForGSButton.SetPanelEvent("onactivate", _OnActivate)
			gamesense_LookingForGSButton.SetPanelEvent("onmouseover", OnMouseOver)
			gamesense_LookingForGSButton.SetPanelEvent("onmouseout", OnMouseOut)
		}

		csgo_RefreshButton = csgo_LookingForButtonsParent.FindChildTraverse("JsFriendsList-lobbies-toolbar-button-refresh")
		gamesense_RefreshButton = gamesense_LookingForGSPanel.FindChildTraverse("JsFriendsList-lobbies-toolbar-button-gamesense-refresh")
		gamesense_RefreshButton.SetParent(csgo_RefreshButton.GetParent())
		if (gamesense_RefreshButton != null) {
			gamesense_RefreshButton.GetParent().MoveChildBefore(gamesense_RefreshButton, csgo_RefreshButton)
			gamesense_RefreshButton.visible = false

			gamesense_RefreshButton.SetPanelEvent("onactivate", function () {
				_SetLoadProgress(20)
				needsRefresh = 1
			})
		}
	}

}

// Disable default refresh / player buttons, and request a Playerlist refresh
var _OnActivate = function () {
	gamesenseTabActive = true
	_SetLoadProgress(10)
	needsRefresh = 1

	csgo_RefreshButton.visible = false
	gamesense_RefreshButton.visible = true
	$.DispatchEventAsync(0.0, "PanoramaComponent_PartyBrowser_Refresh")
}

//Tooltip On
var OnMouseOver = function () {
	UiToolkitAPI.ShowTextTooltip("JsFriendsList-lobbies-toolbar-button-gamesense", "game<font color='#95b806'>sense</font>")
}

//Tooltip Off
var OnMouseOut = function () {
	UiToolkitAPI.HideTextTooltip()
}

// i dont need to comment this
var _SetLoadProgress = function (progress) {
	loadProgress = progress
	$.DispatchEventAsync(0.0, "PanoramaComponent_PartyBrowser_Refresh")
}

// Uses data from the Server to convert it into a Playerlist useable in js
var _SetPP = function (data) {
	var panel_list = $.GetContextPanel().FindChildTraverse("JsFriendsList-lobbies").FindChild("JsFriendsList-List")
	if (panel_list) {
		panel_list.Children().forEach(function (tile) {
			try {
				if (!data[tile.id] || (!!PPData[tile.id].members != !!data[tile.id].members)) {
					tile.RemoveAndDeleteChildren()
					tile.DeleteAsync(0.0)
				}
			} catch (e) {
				$.Schedule(0.1, PartyBrowserAPI.Refresh)

			}

		})
	}

	PPList = []
	PPData = {}

	if (loadProgress < 100) {
		_SetLoadProgress(80)

		var first = 0.1 + Math.random() * 0.2
		$.Schedule(first, function () {
			_SetLoadProgress(90)
		})

		$.Schedule(first + 0.1 + Math.random() * 0.2, function () {
			_SetLoadProgress(100)
		})
	}
	for (var xuid in data) {
		if (data[xuid].members) {
			PPList.unshift(xuid)
		} else {
			PPList.push(xuid)
		}
		PPData[xuid] = data[xuid]
	}
	if (gamesenseTabActive) {
		$.DispatchEventAsync(0.0, "PanoramaComponent_PartyBrowser_Refresh")
	}
}

// Invites the Player, removes his Invite, and shows a cool message in chat
var _Invite = function (xuid, isReinvite, country) {
	if (isReinvite && invitedByXuids[xuid] != true) {
		return false
	}

	var delay = 0

	if (isReinvite && PartyListAPI.GetPartySessionSetting("game/mmqueue") == "searching") {
		LobbyAPI.StopMatchmaking()
		if (!LobbyAPI.BIsHost()) {
			delay = 1
		}
	}

	$.Schedule(delay, function () {
		FriendsListAPI.ActionInviteFriend(xuid, '')
	})

	if (isReinvite) {
		var numInvites = PartyBrowserAPI.GetInvitesCount()
		for (var i = 0; i < numInvites; i++) {
			var lobby_xuid = PartyBrowserAPI.GetInviteXuidByIndex(i)
			var _xuid = PartyBrowserAPI.GetPartyMemberXuid(lobby_xuid, 0)

			if (_xuid == xuid) {
				PartyBrowserAPI.ClearInvite(lobby_xuid)
				$.Schedule(0.5, function () {
					PartyBrowserAPI.ClearInvite(lobby_xuid)
				})
			}
		}

		var lines = $.GetContextPanel().FindChildTraverse("ChatLinesContainer")
		var message = $.CreatePanel("Panel", lines, "")
		if (message != null) {
			if (message.BLoadLayoutFromString(chat_message_layout, false, false)) {
				message.SetParent(lines)
				lines.MoveChildBefore(message, lines.GetChild(0))

				var elName = message.FindChildTraverse("name")
				elName.text = FriendsListAPI.GetFriendName(xuid)

				if (country) {
					var id = `flag-${lines.GetChildCount()}`
					var elFlag = $.CreatePanel("Label", elName.GetParent(), id)
					elName.GetParent().MoveChildAfter(elFlag, elName)

					var info = {
						element: elFlag,
						country: country
					}

					var elTTAnchor = elFlag.FindChildTraverse('region-tt-anchor');
					if (!elTTAnchor) {
						elTTAnchor = $.CreatePanel("Panel", elFlag, elFlag.id + '-region-tt-anchor');
					}

					elFlag.SetPanelEvent("onmouseout", _CountryMouseout)
					elFlag.SetPanelEvent("onmouseover", _CountryMouseover.bind(undefined, elTTAnchor.id, country))
					elFlag.style.tooltipPosition = "bottom"
					elFlag.style.margin = "0px 5px 0px 0px;"


					elFlag.text = country.toUpperCase();
					_SetBackgroundWithFallback(elFlag, ..._GetFlagIcons(country))

					elFlag.RemoveClass('hidden');
					elFlag.SetHasClass('world-region-label', true);
					elFlag.SetHasClass('world-region-label--image', true);

					elFlag.style.padding = "0px 0px 0px 6px"
					elFlag.style.height = "20px"
					elFlag.style.width = "32px"
					elFlag.style.fontSize = "25px"

				}
				message.FindChildTraverse("parent").style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from(#2E2E2D), to( rgba(0, 0, 0, 0.0)) );"
				$.Schedule(0.1, function () {
					lines.ScrollToBottom()
				})
			}
		}

		return true
	}
}

// Called when you receive an Invite
//Checks who invited you, and whether you join him or if its just an Event to refresh
var _OnInviteReceived = function () {

	var numInvites = PartyBrowserAPI.GetInvitesCount()

	for (i = 0; i < numInvites; i++) {

		var lobby_xuid = PartyBrowserAPI.GetInviteXuidByIndex(i)
		var xuid = PartyBrowserAPI.GetPartyMemberXuid(lobby_xuid, 0)
		var d = Date.now()
		if (inviteXuids[xuid] >= d - 7000) {
			PartyBrowserAPI.ActionJoinParty(lobby_xuid)
			PartyBrowserAPI.ClearInvite(xuid)
			inviteXuids[xuid] = null

			$.Schedule(0.7, function () {
				needsRefresh = 2
			})
		} else {
			invitedByXuids[xuid] = true
			if (gamesenseTabActive) {
				needsRefresh = 1
			}

			if (autoJoinToggle && active_category != null && !(PartyListAPI.GetCount() > 1)) {
				PartyBrowserAPI.ActionJoinParty(lobby_xuid)
				autoJoinToggle = false
			}
		}
	}

}

// sometimes the lobby is already full and not longer listed serversided
// This shows it for the client which sees its outdated state
var _OnJoinFail = function (xuid, message) {
	inviteXuids[xuid] = null

	if (active_friendlobby_tooltip != null) {
		UiToolkitAPI.ShowTextTooltip(active_friendlobby_tooltip, `<font color='#FF3C3C'>${message}</font>`)
	}
}

// Check if someone leaves/joins the Lobby, if so request a refresh
var _CheckLeaveLobby = function () {
	if (gamesenseTabActive) {
		var in_lobby = LobbyAPI.IsSessionActive() && PartyListAPI.GetCount() > 1

		if (!in_lobby && in_lobby_prev) {
			$.Schedule(0.7, function () {
				needsRefresh = 2
			})
		}
		in_lobby_prev = in_lobby
	}
}

// Returns The Xuid of the Player you are trying to join and/ or if the Script should refresh the listing
var _GetNeedsUpdate = function () {
	var result = {
		refresh: false
	}

	if (joinXuid) {
		result.join_xuid = joinXuid

		var d = Date.now()
		inviteXuids[joinXuid] = d
		joinXuid = null
	}
	if (reserved) {
		result.reserved = true
		reserved = null
	}

	if (needsRefresh > 0) {
		result.refresh = needsRefresh
		needsRefresh = 0

		if (needsRefresh == 1) {
			_SetLoadProgress(40)
		}
	}

	return result
}

//Sends the Server the Reserved Id when a game has been found
//var _ServerReserved = function(){
//	reserved = true
//}

// Initilizes the Panorama features of the Script
var _Create = function (layout, _tile_layout, _chat_message_layout, _advert_layout) {
	advert_layout = _advert_layout
	tile_layout = _tile_layout
	chat_message_layout = _chat_message_layout

	_Create_Advert()
	_Create_LTP_Tab(layout)

	handler_InviteReceived = $.RegisterForUnhandledEvent("PanoramaComponent_PartyBrowser_InviteReceived", _OnInviteReceived)
	handler_PlayerUpdated = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_PlayerUpdated", _CheckLeaveLobby)
	handler_MatchmakingSessionUpdate = $.RegisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", _CheckLeaveLobby)
	handler_PartyBrowserRefresh = $.RegisterForUnhandledEvent("PanoramaComponent_PartyBrowser_Refresh", _UpdateNoDataText)
	//handler_serverreserved = $.RegisterForUnhandledEvent("ServerReserved", _ServerReserved)
}

// Used on Unload or GameQuit to reset Panorama
var _Destroy = function () {
	if (gamesense_LookingForGSPanel != null) {
		gamesense_RefreshButton.SetParent(gamesense_LookingForGSPanel)
		gamesense_LookingForGSPanel.RemoveAndDeleteChildren()
		gamesense_LookingForGSPanel.DeleteAsync(0.0)
		gamesense_LookingForGSPanel = null
	}

	csgo_RefreshButton.visible = true

	for (var key in PartyBrowserAPI_prev) {
		PartyBrowserAPI[key] = PartyBrowserAPI_prev[key]
	}

	for (var key in GameInterfaceAPI_prev) {
		GameInterfaceAPI[key] = GameInterfaceAPI_prev[key]
	}

	if (gamesenseTabActive) {
		gamesenseTabActive = false
		PartyBrowserAPI.Refresh()
		$.DispatchEventAsync(0.0, "PanoramaComponent_PartyBrowser_Refresh")
	}

	if (handler_InviteReceived != null) {
		$.UnregisterForUnhandledEvent("PanoramaComponent_PartyBrowser_InviteReceived", handler_InviteReceived)
	}
	if (handler_PlayerUpdated != null) {
		$.UnregisterForUnhandledEvent("PanoramaComponent_Lobby_PlayerUpdated", handler_PlayerUpdated)
	}
	if (handler_MatchmakingSessionUpdate != null) {
		$.UnregisterForUnhandledEvent("PanoramaComponent_Lobby_MatchmakingSessionUpdate", handler_MatchmakingSessionUpdate)
	}
	if (handler_PartyBrowserRefresh != null) {
		$.UnregisterForUnhandledEvent("PanoramaComponent_PartyBrowser_Refresh", handler_PartyBrowserRefresh)
	}
	//if(handler_serverreserved != null) {
	//	$.UnregisterForUnhandledEvent("ServerReserved", handler_serverreserved)
	//}

	if (gamesense_AdvertTogglePanel != null) {
		gamesense_AdvertTogglePanel.RemoveAndDeleteChildren()
		gamesense_AdvertTogglePanel.DeleteAsync(0.0)
		gamesense_AdvertTogglePanel = null
	}

	csgo_AdvertToggleContainer.GetParent().style.border = null
	csgo_AdvertToggleContainer.GetParent().style.height = null
	csgo_AdvertToggleContainer.style.height = null
}

return {
	create: _Create,
	destroy: _Destroy,
	set_players: _SetPP,
	get_needs_update: _GetNeedsUpdate,
	invite: _Invite,
	on_join_fail: _OnJoinFail,
	get_active_category: _GetActiveCategory,
}
]], "CSGOMainMenu")()
slot28 = [[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/friendslist.css" />
		<include src="file://{resources}/styles/playercard.css" />
		<include src="file://{resources}/styles/friendtile.css" />
	</styles>
	<Panel class= "horizontal-align-left vertical-center left-right-flow" >
		<RadioButton id="JsFriendsList-lobbies-toolbar-button-gamesense"
			group="JsFriendsList-lobbies-toolbar-button-modegroup"
			class="IconButton friendslist-navbar-lobby-button">
			<Image style="border-radius: 100%; background-color: #272726; width: 26px; height: 26px; padding: -6px -6px;" >
			<Image src="https://raw.githubusercontent.com/Karechta/looking_for_gs/master/gs.png" style="wash-color: #95b806; width: 19px; height: 19px;"/>
			</Image>
		</RadioButton>
		<Button id="JsFriendsList-lobbies-toolbar-button-gamesense-refresh"
					class="IconButton"
					onmouseover="UiToolkitAPI.ShowTextTooltip( 'JsFriendsList-lobbies-toolbar-button-gamesense-refresh', 'Refresh' );"
			onmouseout="UiToolkitAPI.HideTextTooltip();">
			<Image src="file://{images}/icons/ui/refresh.svg"/>
		</Button>
	</Panel>
</root>
]]
slot29 = [[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/friendslist.css" />
		<include src="file://{resources}/styles/playercard.css" />
		<include src="file://{resources}/styles/friendtile.css" />
		<include src="file://{resources}/styles/friendlobby.css" />
	</styles>
	<scripts>
		<include src="file://{resources}/scripts/common/sessionutil.js" />
		<include src="file://{resources}/scripts/friendtile.js" />
		<include src="file://{resources}/scripts/friendlobby.js" />
		<include src="file://{resources}/scripts/friend_advertise_tile.js" />
		<include src="file://{resources}/scripts/common/teamcolor.js" />
		<include src="file://{resources}/scripts/avatar.js" />
	</scripts>
	<Panel>
		<Label id="CategoryText" text="" style="font-size: 16px; text-shadow: 0 0 6px black;"/>
	</Panel>
</root>
]]
slot30 = [[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/mainmenu.css" />
		<include src="file://{resources}/styles/chat.css" />
	</styles>
	<Panel>
		<Panel class="chat-entry">
			<Panel id="parent" class="chat-entry__player-invited">
				<Image textureheight="16" texturewidth="-1" src="file://{images}/icons/ui/broadcast.svg"/>
				<Label id="name" style="width: fit-children; padding-right: 0px;" />
				<Label html="true" text="joining via game&lt;font color='#95b806'&gt;sense&lt;/font&gt; lobby browser" acceptsinput="true" style="padding-left: 0px !important;" />
			</Panel>
		</Panel>
	</Panel>
</root>
]]
slot31 = [[
<root>
	<styles>
		<include src="file://{resources}/styles/csgostyles.css" />
		<include src="file://{resources}/styles/advertising_toggle.css" />
	</styles>
	<Panel class="btn_advertising MainMenuModeOnly" style="height: 96px; border-bottom: 1px solid rgba(255, 255, 255, 0) !important;">
		<Panel id="HireAdvertisingToggleContainerGS" class="full-width vertical-center" >
			<Button id="HireAdvertisingToggleGS" class="btn_advertising__toggle">
			<Image id="HireAdvertisingToggleGSImage" class="btn_advertising__img-pole" src="https://raw.githubusercontent.com/Karechta/looking_for_gs/master/gs.png" style="width: 56px; height: 56px; border-radius: 50%; padding: 12px 12px;" />
			</Button>
		</Panel>
	</Panel>
</root>
]]
slot32 = {}
slot33, slot34 = nil

for slot38 = 1, 256 do
	slot33 = slot38 - 1

	for slot42 = 1, 8 do
		slot33 = slot3.bxor(slot3.rshift(slot33, 1), slot3.band(3988292384.0, -slot3.band(slot33, 1)))
	end

	slot32[slot38] = slot33
end

function slot33(slot0)
	slot1 = 4294967295.0

	for slot5 = 1, #slot0 do
		slot1 = uv1(uv2(slot1, 8), uv3[uv4(uv1(slot1, uv0(slot0, slot5)), 255) + 1])
	end

	return uv4(uv5(slot1), 4294967295.0)
end

function slot34(slot0, slot1)
	slot2 = #slot1

	uv1(uv0("char[?]", slot2 + 1), slot1)
	uv1(uv0("char[?]", #slot0 + 1), slot0)

	for slot9 = 0, slot2 - 1 do
		slot4[slot9] = uv2(slot4[slot9], slot5[slot9 % slot3])
	end

	return uv3(slot4, slot2)
end

slot27.create(slot28, slot29, slot30, slot31)

function slot35(slot0, slot1, slot2, slot3)
	if slot0 == "POST" then
		slot4 = uv0(slot2)
		slot5 = uv1(slot4)

		uv7.request(slot0, uv8 .. slot1, {
			user_agent_info = "gamesense_player_finder",
			body = uv9(uv2(uv3, uv4("%s %s%d", slot4, uv5(tostring(uv6(slot5))), (slot5 % 81 + 14) % 9))),
			headers = {
				["Content-Type"] = "application/x-www-form-urlencoded"
			}
		}, slot3)
	else
		uv7.request(slot0, uv8 .. slot1, {
			user_agent_info = "gamesense_player_finder",
			params = slot2
		}, slot3)
	end
end

function slot36(slot0)
	client.delay_call(0, function ()
		uv0.set_players(uv1)
	end)
end

function slot37(slot0, slot1)
	client.error_log(slot0 .. " " .. slot1.status .. " " .. (slot1.body ~= nil and slot1.body:len() < 100 and slot1.body or slot1.status_message or ""))
end

function slot38()
	uv0("GET", "players", {
		token = uv1
	}, function (slot0, slot1)
		slot2 = nil

		if slot0 and slot1.status == 200 then
			slot2 = json.parse(slot1.body)
		else
			uv0("Failed to refresh players:", slot1)

			slot2 = {
				players = {}
			}
		end

		uv1 = globals.realtime() + 1

		uv2(slot2.players)

		if slot2.invites and uv3 ~= nil then
			for slot6 = 1, #slot2.invites do
				slot7 = slot2.invites[slot6]

				if not uv4.invite(slot7.steamid, true, slot7.country) then
					for slot12 = 1, 6 do
						client.delay_call(slot12, function ()
							if not uv0 then
								uv0 = uv1.invite(uv2.steamid, true, uv2.country)
							end
						end)
					end
				end
			end
		end
	end)
end

function slot39(slot0, slot1)
	if uv0 ~= nil then
		-- Nothing
	end

	if slot1.members ~= nil and slot1.members:len() > 0 then
		slot3.is_leader = slot1.is_leader and "1" or "0"
		slot3.members = slot1.members
	end

	uv1("POST", "add", {
		steamid = tonumber(slot1.steamid:sub(4)) - 61197960265728.0,
		prime = slot1.prime and "1" or "0",
		category = slot0,
		rank = tostring(slot1.rank),
		token = uv0
	}, function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			return uv0("Failed to advertise!", slot1)
		end

		slot2 = json.parse(slot1.body)
		uv1 = slot2.token

		uv2(slot2.players)

		uv3 = globals.realtime() + uv4
	end)
end

function slot40(slot0)
	if uv0 ~= nil then
		uv1("POST", "remove", {
			token = uv0,
			reason = slot0
		}, function (slot0, slot1)
			if not slot0 or slot1.status ~= 200 then
				return uv0("Failed to remove!", slot1)
			end

			uv1 = nil

			uv2(json.parse(slot1.body).players)
		end)
	end
end

client.set_event_callback("paint_ui", function ()
	slot0 = globals.realtime()
	uv0 = uv1.get_active_category()

	if uv0 ~= uv2 then
		uv3 = 0
		uv2 = uv0
	end

	slot1 = nil

	if uv0 ~= nil or uv4 == nil then
		slot1 = json.parse(tostring(uv5.get_local_data()))

		if uv4 ~= nil then
			for slot5, slot6 in pairs(slot1) do
				if uv4[slot5] ~= slot6 then
					uv3 = 0

					break
				end
			end
		end

		uv4 = slot1
	end

	if uv3 ~= nil and uv3 < slot0 then
		uv3 = nil

		if uv0 ~= nil then
			uv6(uv0, slot1)
		else
			uv7("active_category")
		end
	end

	if uv8 ~= nil and uv8 < slot0 then
		if json.parse(tostring(uv1.get_needs_update())).refresh == 1 or uv0 ~= nil and slot2.refresh == 2 then
			uv8 = slot0 + 10

			uv9()
		else
			uv8 = slot0 + 0.05
		end

		if slot2.join_xuid then
			uv10("POST", "join", {
				steamid = uv4.steamid,
				lobby = slot2.join_xuid
			}, function (slot0, slot1)
				if not slot0 or slot1.status ~= 200 then
					uv0.on_join_fail(uv1.join_xuid, slot1.status == 400 and slot1.body == "Bad Request: Lobby not found" and "Lobby not found" or "Failed to join lobby: " .. slot1.status .. " " .. (slot1.status_message or ""))
					uv2()

					return
				end

				uv0.invite(uv1.join_xuid)
			end)
		end
	end
end)
client.set_event_callback("shutdown", function ()
	uv0.destroy()

	if uv1 ~= nil then
		uv2("shutdown")
	end
end)
