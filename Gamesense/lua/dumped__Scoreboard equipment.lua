slot0 = require("gamesense/csgo_weapons")
slot1 = require("table.clear")
slot2 = setmetatable({}, {
	__index = function (slot0, slot1)
		slot0[slot1] = uv0[tonumber(slot1)] or false

		return slot0[slot1]
	end
})
slot3 = slot0.item_kevlar
slot4 = slot0.item_assaultsuit
slot5 = slot0.item_heavyassaultsuit
slot6 = slot0.item_cutters
slot7 = slot0.item_defuser
slot8 = slot0.weapon_taser
slot9 = slot0.weapon_c4
slot10 = 2
slot11 = 3

function slot12(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot1[slot5] == nil then
			return false
		elseif slot6 ~= slot7 then
			if type(slot6) == "table" and type(slot7) == "table" then
				if not uv0(slot6, slot7) then
					return false
				end
			else
				return false
			end
		end
	end

	for slot5, slot6 in pairs(slot1) do
		if slot0[slot5] == nil then
			return false
		end
	end

	return true
end

function slot13(slot0, slot1)
	slot3 = 1

	for slot7 = 1, #slot0 do
		if slot1(slot0[slot7]) ~= nil then
			slot3 = slot3 + 1
		end
	end

	return {
		[slot3] = slot8
	}
end

function slot14(slot0, slot1)
	slot2 = {}

	for slot6, slot7 in pairs(slot0) do
		slot8, slot2[slot8] = slot1(slot6, slot7)
	end

	return slot2
end

function slot15(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot16(slot0, slot1)
	for slot5 = #slot0, 1, -1 do
		if slot0[slot5] == slot1 then
			table.remove(slot0, slot5)
		end
	end
end

slot17 = {
	item_equip = 2,
	item_pickup = 2,
	player_spawn = 1,
	player_death = 0,
	player_disconnect = 0,
	item_remove = 0
}

function slot18(slot0, slot1)
	return (uv0[slot0[1]] or slot0[1]:byte()) < (uv0[slot1[1]] or slot1[1]:byte())
end

slot19 = {}
slot20 = {}
slot21 = {}
slot22 = nil

function slot23()
	if uv0 ~= nil then
		table.sort(uv1, uv2)

		for slot3 = 1, #uv1 do
			slot4, slot5, slot6 = unpack(uv1[slot3])

			for slot11 = 1, #uv3[slot4] do
				xpcall(slot7[slot11], client.error_log, slot5)
			end
		end

		uv4(uv1)

		uv0 = nil
	end
end

function slot24(slot0, slot1)
	if uv0[slot0] == nil then
		uv1[slot0] = function (slot0)
			if uv0 == nil then
				uv0 = globals.curtime()
			elseif uv0 ~= slot1 then
				uv1()

				uv0 = slot1
			end

			table.insert(uv2, {
				uv3,
				slot0
			})
		end

		client.set_event_callback(slot0, uv1[slot0])

		uv0[slot0] = {}
	end

	table.insert(uv0[slot0], slot1)
end

function slot25()
	for slot3, slot4 in pairs(uv0) do
		client.unset_event_callback(slot3, slot4)
	end

	uv1(uv0)
	uv1(uv2)
	uv1(uv3)

	uv4 = nil
end

slot26 = panorama.open("CSGOHud")
slot27 = slot26.FriendsListAPI
slot28 = slot26.MyPersonaAPI
slot29 = slot26.GameStateAPI
slot30 = panorama.loadstring([[
	let entity_panels = {}
	let entity_flair_panels = {}
	let entity_data = {}
	let event_callbacks = {}

	let unmuted_players = {}

	let TEAM_COLORS = {
		CT: "#B5D4EE40",
		TERRORIST: "#EAD18A61"
	}

	let SHADOW_COLORS = {
		CT: "#393C40",
		TERRORIST: "#4C4844"
	}

	let HIDDEN_IDS = ["id-sb-name__commendations__leader", "id-sb-name__commendations__teacher", "id-sb-name__commendations__friendly", "id-sb-name__musickit"]

	let SLOT_LAYOUT = `
		<root>
			<Panel style="min-width: 3px; padding-top: 2px; padding-left: 2px; overflow: noclip;">
				<Image id="smaller" textureheight="15" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;"  />
				<Image id="small" textureheight="17" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px;" />
				<Image id="medium" textureheight="18" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -4px;" />
				<Image id="large" textureheight="21" style="horizontal-align: center; opacity: 0.01; transition: opacity 0.1s ease-in-out 0.0s, img-shadow 0.12s ease-in-out 0.0s; overflow: noclip; padding: 3px 5px; margin: -3px -5px; margin-top: -5px;" />
			</Panel>
		</root>
	`

	let MIN_WIDTHS = {}
	let MAX_WIDTHS = {}
	let SLOT_OVERRIDE = {}

	let GameStateAPI_IsLocalPlayerPlayingMatch_prev
	let FriendsListAPI_IsSelectedPlayerMuted_prev
	let GameStateAPI_IsSelectedPlayerMuted_prev
	let my_xuid = MyPersonaAPI.GetXuid()

	let _SetMinMaxWidth = function(weapon, min_width, max_width, slot_override) {
		if(min_width)
			MIN_WIDTHS[weapon] = min_width

		if(max_width)
			MAX_WIDTHS[weapon] = max_width

		if(slot_override)
			SLOT_OVERRIDE[weapon] = slot_override
	}

	let _DestroyEntityPanels = function() {
		for(key in entity_panels){
			let panel = entity_panels[key]

			if(panel != null && panel.IsValid()) {
				var parent = panel.GetParent()

				HIDDEN_IDS.forEach(id => {
					let panel = parent.FindChildTraverse(id)

					if(panel != null) {
						panel.style.maxWidth = "28px"
						panel.style.margin = "0px 5px 0px 5px"
					}
				})

				if(parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
					parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 0px"
				}

				panel.DeleteAsync(0.0)
			}

			delete entity_panels[key]
		}
	}

	let _GetOrCreateCustomPanel = function(xuid) {
		if(entity_panels[xuid] == null || !entity_panels[xuid].IsValid()){
			entity_panels[xuid] = null

			// $.Msg("creating panel for ", xuid)
			let scoreboard_context_panel = $.GetContextPanel().FindChildTraverse("ScoreboardContainer").FindChildTraverse("Scoreboard") || $.GetContextPanel().FindChildTraverse("id-eom-scoreboard-container").FindChildTraverse("Scoreboard")

			if(scoreboard_context_panel == null){
				// usually happens if end of match scoreboard is open. clean up everything?

				_Clear()
				_DestroyEntityPanels()

				return
			}

			scoreboard_context_panel.FindChildrenWithClassTraverse("sb-row").forEach(function(el){
				let scoreboard_el

				if(el.m_xuid == xuid) {
					el.Children().forEach(function(child_frame){
						let stat = child_frame.GetAttributeString("data-stat", "")
						if(stat == "name") {
							scoreboard_el = child_frame.GetChild(0)
						} else if(stat == "flair") {
							entity_flair_panels[xuid] = child_frame.GetChild(0)
						}
					})

					if(scoreboard_el) {
						let scoreboard_el_parent = scoreboard_el.GetParent()

						// fix some style. this is not restored
						// scoreboard_el_parent.style.overflow = "clip clip;"

						// create panel
						let custom_weapons = $.CreatePanel("Panel", scoreboard_el_parent, "custom-weapons", {
							style: "overflow: noclip; width: fit-children; margin: 0px 0px 0px 0px; padding: 1px 0px 0px 0px; height: 100%; flow-children: left; min-width: 30px;"
						})

						HIDDEN_IDS.forEach(id => {
							let panel = scoreboard_el_parent.FindChildTraverse(id)

							if(panel != null) {
								panel.style.maxWidth = "0px"
								panel.style.margin = "0px"
							}
						})

						if(scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image") != null) {
							scoreboard_el_parent.FindChildTraverse("id-sb-skillgroup-image").style.margin = "0px 0px 0px 5px"
						}

						scoreboard_el_parent.MoveChildBefore(custom_weapons, scoreboard_el_parent.GetChild(1))

						// create child panels
						let panel_armor = $.CreatePanel("Image", custom_weapons, "armor", {
							textureheight: "17",
							style: "padding-left: 2px; padding-top: 3px; opacity: 0.2; padding-left: 5px;"
						})
						panel_armor.visible = false

						let panel_helmet = $.CreatePanel("Image", custom_weapons, "helmet", {
							textureheight: "22",
							style: "padding-left: 2px; padding-top: 0px; opacity: 0.2; padding-left: 0px; margin-left: 3px; margin-right: -3px;"
						})
						panel_helmet.visible = false
						panel_helmet.SetImage("file://{images}/icons/equipment/helmet.svg")

						for(i=24; i >= 0; i--) {
							let panel_slot_parent = $.CreatePanel("Panel", custom_weapons, `weapon-${i}`)

							panel_slot_parent.visible = false
							panel_slot_parent.BLoadLayoutFromString(SLOT_LAYOUT, false, false)
						}

						// custom_weapons.style.border = "1px solid red;"
						entity_panels[xuid] = custom_weapons

						return custom_weapons
					}
				}
			})
		}

		return entity_panels[xuid]
	}

	let _UpdatePlayer = function(entindex, weapons, selected_weapon, armor) {
		if(entindex == null || entindex == 0)
			return

		entity_data[entindex] = arguments
	}

	let _ApplyPlayer = function(entindex, weapons, selected_weapon, armor) {
		let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

		// $.Msg("applying for ", entindex, ": ", weapons)
		let panel = _GetOrCreateCustomPanel(xuid)

		if(panel == null)
			return

		let team = GameStateAPI.GetPlayerTeamName(xuid)
		let wash_color = TEAM_COLORS[team] || "#ffffffff"

		// panel.style.marginRight = entity_flair_panels[entindex].actuallayoutwidth < 4 ? "-25px" : "0px"

		for(i=0; i < 24; i++) {
			let panel_slot_parent = panel.FindChild(`weapon-${i}`)

			if(weapons && weapons[i]) {
				let weapon = weapons[i]
				let selected = weapon == selected_weapon
				panel_slot_parent.visible = true

				let slot_override = SLOT_OVERRIDE[weapon] || "small"

				let panel_slot
				panel_slot_parent.Children().forEach(function(el){
					if(el.id == slot_override){
						el.visible = true
						panel_slot = el
					} else {
						el.visible = false
					}
				})

				panel_slot.style.opacity = selected ? "0.85" : "0.35"

				let shadow_color = SHADOW_COLORS[team] || "#58534D"
				// shadow_color = "rgba(64, 64, 64, 0.1)"
				panel_slot.style.imgShadow = selected ? (shadow_color + " 0px 0px 3px 3.75") : "none"

				panel_slot.style.washColorFast = wash_color
				panel_slot.SetImage("file://{images}/icons/equipment/" + weapon + ".svg")
				// panel_slot.style.border = "1px solid red;"

				panel_slot.style.marginLeft = "-5px"
				panel_slot.style.marginRight = "-5px"

				if(weapon == "knife_ursus") {
					panel_slot.style.marginLeft = "-2px"
				} else if(weapon == "knife_widowmaker") {
					panel_slot.style.marginLeft = "-3px"
				} else if(weapon == "hkp2000") {
					panel_slot.style.marginRight = "-4px"
				} else if(weapon == "incgrenade") {
					panel_slot.style.marginLeft = "-6px"
				} else if(weapon == "flashbang") {
					panel_slot.style.marginLeft = "-5px"
				}

				panel_slot_parent.style.minWidth = MIN_WIDTHS[weapon] || "0px"
				panel_slot_parent.style.maxWidth = MAX_WIDTHS[weapon] || "1000px"
			} else if(panel_slot_parent.visible) {
				// $.Msg("removed!")
				panel_slot_parent.visible = false
				let panel_slot = panel_slot_parent.GetChild(0)
				panel_slot.style.opacity = "0.01"
			}
		}

		let panel_armor = panel.FindChild("armor")
		let panel_helmet = panel.FindChild("helmet")

		if(armor != null){
			panel_armor.visible = true
			panel_armor.style.washColorFast = wash_color

			if(armor == "helmet") {
				panel_armor.SetImage("file://{images}/icons/equipment/kevlar.svg")

				panel_helmet.visible = true
				panel_helmet.style.washColorFast = wash_color
			} else {
				panel_armor.SetImage("file://{images}/icons/equipment/" + armor + ".svg")
			}
		} else {
			panel_armor.visible = false
			panel_helmet.visible = false
		}

		return true
	}

	let _ApplyData = function() {
		for(entindex in entity_data) {
			entindex = parseInt(entindex)
			let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

			if(!entity_data[entindex].applied || entity_panels[xuid] == null || !entity_panels[xuid].IsValid()) {
				if(_ApplyPlayer.apply(null, entity_data[entindex])) {
					// $.Msg("successfully appied for ", entindex)
					entity_data[entindex].applied = true
				}
			}
		}
	}

	let _EnablePlayingMatchHook = function() {
		if(GameStateAPI_IsLocalPlayerPlayingMatch_prev == null) {
			GameStateAPI_IsLocalPlayerPlayingMatch_prev = GameStateAPI.IsLocalPlayerPlayingMatch

			GameStateAPI.IsLocalPlayerPlayingMatch = function() {
				if(GameStateAPI.IsDemoOrHltv()) {
					return true
				}

				return GameStateAPI_IsLocalPlayerPlayingMatch_prev.call(GameStateAPI)
			}
		}
	}

	let _DisablePlayingMatchHook = function() {
		if(GameStateAPI_IsLocalPlayerPlayingMatch_prev != null) {
			GameStateAPI.IsLocalPlayerPlayingMatch = GameStateAPI_IsLocalPlayerPlayingMatch_prev
			GameStateAPI_IsLocalPlayerPlayingMatch_prev = null
		}
	}

	let _EnableSelectedPlayerMutedHook = function() {
		if(FriendsListAPI_IsSelectedPlayerMuted_prev == null) {
			FriendsListAPI_IsSelectedPlayerMuted_prev = FriendsListAPI.IsSelectedPlayerMuted

			FriendsListAPI.IsSelectedPlayerMuted = function(xuid) {
				if(xuid == my_xuid) {
					return false
				}

				return FriendsListAPI_IsSelectedPlayerMuted_prev.call(FriendsListAPI, xuid)
			}
		}

		if(GameStateAPI_IsSelectedPlayerMuted_prev == null) {
			GameStateAPI_IsSelectedPlayerMuted_prev = GameStateAPI.IsSelectedPlayerMuted

			GameStateAPI.IsSelectedPlayerMuted = function(xuid) {
				if(xuid == my_xuid) {
					return false
				}

				return GameStateAPI_IsSelectedPlayerMuted_prev.call(GameStateAPI, xuid)
			}
		}
	}

	let _DisableSelectedPlayerMutedHook = function() {
		if(FriendsListAPI_IsSelectedPlayerMuted_prev != null) {
			FriendsListAPI.IsSelectedPlayerMuted = FriendsListAPI_IsSelectedPlayerMuted_prev
			FriendsListAPI_IsSelectedPlayerMuted_prev = null
		}

		if(GameStateAPI_IsSelectedPlayerMuted_prev != null) {
			GameStateAPI.IsSelectedPlayerMuted = GameStateAPI_IsSelectedPlayerMuted_prev
			GameStateAPI_IsSelectedPlayerMuted_prev = null
		}
	}

	let _UnmutePlayer = function(xuid) {
		if(GameStateAPI.IsSelectedPlayerMuted(xuid)) {
			GameStateAPI.ToggleMute(xuid)
			unmuted_players[xuid] = true

			return true
		}

		return false
	}

	let _RestoreUnmutedPlayers = function(xuid) {
		for(xuid in unmuted_players) {
			if(!GameStateAPI.IsSelectedPlayerMuted(xuid) && GameStateAPI.IsPlayerConnected(xuid)) {
				GameStateAPI.ToggleMute(xuid)
			}
		}
		unmuted_players = {}
	}

	let _GetAllPlayers = function() {
		let result = []

		for(entindex=1; entindex <= 64; entindex++) {
			let xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

			if(xuid && xuid != "0") {
				result.push(xuid)
			}
		}

		return result
	}

	let _Create = function() {
		event_callbacks["OnOpenScoreboard"] = $.RegisterForUnhandledEvent("OnOpenScoreboard", _ApplyData)
		event_callbacks["Scoreboard_UpdateEverything"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateEverything", function(){
			// $.Msg("cleared applied data")
			for(entindex in entity_data) {
				// entity_data[entindex].applied = false
			}
			_ApplyData()
		})
		event_callbacks["Scoreboard_UpdateJob"] = $.RegisterForUnhandledEvent("Scoreboard_UpdateJob", _ApplyData)
	}

	let _Clear = function() {
		entity_data = {}
	}

	let _Destroy = function() {
		// clear entity data
		_Clear()
		_DestroyEntityPanels()

		for(event in event_callbacks){
			$.UnregisterForUnhandledEvent(event, event_callbacks[event])

			delete event_callbacks[event]
		}

		// $.GetContextPanel().FindChildTraverse("TeamSmallContainerCT").style.width = "400px"
		// $.GetContextPanel().FindChildTraverse("TeamSmallContainerT").style.width = "400px"
	}

	return {
		create: _Create,
		set_min_max_width: _SetMinMaxWidth,
		destroy: _Destroy,
		clear: _Clear,
		update_player: _UpdatePlayer,
		enable_playing_match_hook: _EnablePlayingMatchHook,
		disable_playing_match_hook: _DisablePlayingMatchHook,
		enable_selected_player_muted_hook: _EnableSelectedPlayerMutedHook,
		disable_selected_player_muted_hook: _DisableSelectedPlayerMutedHook,
		unmute_player: _UnmutePlayer,
		restore_unmuted_players: _RestoreUnmutedPlayers,
		get_all_players: _GetAllPlayers
	}
]], "CSGOHud")()
slot31 = {
	[slot0.weapon_hegrenade] = 10,
	[slot0.weapon_decoy] = slot0.weapon_molotov.idx - 1,
	[slot0.weapon_smokegrenade] = slot0.weapon_smokegrenade.idx - 1,
	[slot0.weapon_taser] = 3
}
slot32 = {
	[slot38] = slot39
}

for slot37, slot38 in pairs(slot0) do
	slot33 = math.max(string.byte(slot38.name), 0)

	if slot38.type == "pistol" then
		slot30.set_min_max_width(slot38.console_name:gsub("^item_", ""):gsub("^weapon_", ""), "31px")
	elseif slot38.type == "knife" and slot38 ~= slot8 then
		slot30.set_min_max_width(slot40, "45px", "45px", "smaller")
	end
end

slot30.set_min_max_width("knife", nil, , "small")
slot30.set_min_max_width("knife_t", nil, , "small")
slot30.set_min_max_width("knife_widowmaker", nil, , "small")
slot30.set_min_max_width("knife_butterfly", nil, , "small")
slot30.set_min_max_width("knife_survival_bowie", nil, , "large")
slot30.set_min_max_width("knife_gut", nil, , "medium")
slot30.set_min_max_width("knife_karambit", nil, , "medium")
slot30.set_min_max_width("knife_ursus", nil, , "small")

slot38 = "medium"

slot30.set_min_max_width("hkp2000", nil, , slot38)
slot30.set_min_max_width("incgrenade", "12px")
slot30.set_min_max_width("smokegrenade", "9px")

slot37 = "12px"

slot30.set_min_max_width("flashbang", "9px", slot37)

for slot37, slot38 in pairs(slot0) do
	if slot31[slot38] == nil then
		if slot38.type == "rifle" or slot38.type == "machinegun" or slot38.type == "sniperrifle" or slot38.type == "smg" or slot38.type == "shotgun" then
			slot31[slot38] = 0 + slot32[slot38] / slot33
		elseif slot38.type == "pistol" then
			slot31[slot38] = 1 + slot39
		elseif slot38.type == "knife" or slot38.type == "fists" or slot38.type == "melee" then
			slot31[slot38] = 2 + slot39
		else
			slot31[slot38] = slot38.idx
		end
	end
end

function slot34(slot0, slot1)
	return (uv0[slot0] or slot0.idx) < (uv0[slot1] or slot1.idx)
end

slot36 = ui.new_multiselect("VISUALS", "Other ESP", "\nScoreboard equipment filter", {
	"Primary",
	"Secondary",
	"Knife",
	"Taser",
	"Grenades",
	"Bomb",
	"Defuse Kit",
	"Armor",
	"Other"
})

ui.set(slot36, {
	"Primary",
	"Secondary",
	"Grenades",
	"Bomb"
})

slot39 = {}
slot40 = {}
slot41 = false
slot42 = false

function slot43(slot0)
	return uv0[slot0]
end

function slot44(slot0)
	slot1 = uv0[slot0]
	slot2 = ui.get(uv1) and not entity.is_dormant(slot0) and not entity.is_enemy(slot0)
	slot3 = slot0

	if entity.get_prop(entity.get_player_resource(), "m_bControllingBot", slot0) == 1 then
		slot3 = entity.get_prop(slot4, "m_iControlledPlayer", slot0)

		uv2.update_player(slot0, nil, , )
	end

	if slot1 == nil or slot2 then
		uv2.update_player(slot3, nil, , )
	else
		uv2.update_player(slot3, slot1.weapons and uv3(slot1.weapons, uv4) or nil, slot1.active_weapon and uv5[slot1.active_weapon] or nil, uv6 and slot1.armor or nil)
	end
end

function slot46()
	uv0()

	slot0 = entity.get_player_resource()
	slot1 = cvar.mp_free_armor:get_int() > 0
	slot2 = cvar.mp_free_armor:get_int() > 1

	for slot7 = 1, 64 do
		if entity.get_classname(slot7) == "CCSPlayer" then
			slot8 = nil

			if not entity.is_dormant(slot7) then
				if entity.is_alive(slot7) then
					slot8 = {
						weapons = {}
					}

					if entity.get_player_weapon(slot7) ~= nil then
						if not (cvar.mp_defuser_allocation:get_int() >= 2) and entity.get_prop(slot7, "m_bHasDefuser") == 1 then
							table.insert(slot8.weapons, uv1)
						end

						for slot13 = 0, 63 do
							if entity.get_prop(slot7, "m_hMyWeapons", slot13) ~= nil then
								table.insert(slot8.weapons, uv2[entity.get_prop(slot14, "m_iItemDefinitionIndex")])

								if slot14 == slot9 then
									slot8.active_weapon = slot15
								end
							end
						end

						table.sort(slot8.weapons, uv3)
					end
				else
					slot8 = nil
				end
			else
				slot8 = uv4[slot7]
			end

			if slot8 ~= nil then
				if entity.get_prop(slot0, "m_iArmor", slot7) > 0 then
					if entity.get_prop(slot0, "m_bHasHelmet", slot7) == 1 then
						if not slot2 then
							slot8.armor = "helmet"
						end
					elseif not slot1 then
						slot8.armor = "kevlar"
					end
				else
					slot8.armor = nil
				end
			end

			if uv4[slot7] == nil and slot8 ~= nil or slot8 == nil and uv4[slot7] ~= nil or slot8 ~= nil and uv4[slot7] ~= nil and not uv5(slot8, uv4[slot7]) then
				uv4[slot7] = slot8

				uv6(slot7)
			end
		end
	end
end

function slot47()
	if uv0 then
		uv1.destroy()
	end
end

function slot48()
	uv0(uv1)
	uv2.clear()
end

function slot49(slot0)
	if client.userid_to_entindex(slot0.userid) == entity.get_local_player() then
		client.delay_call(0.1, uv0)
	elseif slot1 > 0 then
		uv1(slot1)
	end
end

function slot50(slot0)
	slot1 = client.userid_to_entindex(slot0.userid)
	uv0[slot1] = nil

	uv1(slot1)
end

function slot51(slot0)
	if uv0[client.userid_to_entindex(slot0.userid)] ~= nil and entity.is_dormant(slot1) then
		uv0[slot1] = nil

		uv1(slot1)
	end
end

function slot52(slot0)
	if uv0[client.userid_to_entindex(slot0.userid)] == nil then
		uv0[slot1] = {
			weapons = {}
		}
	elseif uv0[slot1].weapons ~= nil then
		uv1(uv0[slot1].weapons, uv2)
	end

	uv3(slot1)
end

function slot53(slot0)
	slot2 = uv0[slot0.defindex]

	if uv1[client.userid_to_entindex(slot0.userid)] ~= nil and entity.is_dormant(slot1) and slot2 and slot2 ~= uv2 and slot2 ~= uv3 then
		uv4(uv1[slot1].weapons, slot2)
		uv5(slot1)
	end
end

function slot54(slot0)
	slot2 = uv0[slot0.defindex]

	if uv1[client.userid_to_entindex(slot0.userid)] ~= nil and entity.is_dormant(slot1) and slot2 then
		if slot2 == uv2 or slot2 == uv3 then
			slot3 = cvar.mp_free_armor:get_int() > 0

			if slot2 == uv2 then
				if not (cvar.mp_free_armor:get_int() > 1) and uv1[slot1].armor == nil then
					uv1[slot1].armor = "kevlar"
				end
			elseif not slot3 then
				uv1[slot1].armor = "helmet"
			end
		elseif (slot2 == uv4 or slot2 == uv5) and cvar.mp_defuser_allocation:get_int() >= 2 then
			return
		elseif not uv6(uv1[slot1].weapons, slot2) then
			table.insert(uv1[slot1].weapons, slot2)
			table.sort(uv1[slot1].weapons, uv7)
			uv8(slot1)
		end
	end
end

function slot55(slot0)
	slot2 = uv0[slot0.defindex]

	if uv1[client.userid_to_entindex(slot0.userid)] ~= nil and entity.is_dormant(slot1) and slot2 then
		uv1[slot1].active_weapon = slot2

		uv2(slot1)
	end
end

function slot56(slot0)
	slot1 = client.userid_to_entindex(slot0.userid)
	slot2 = client.userid_to_entindex(slot0.botid)
	slot3 = entity.get_player_resource()

	entity.set_prop(slot3, "m_bControllingBot", 1, slot1)
	entity.set_prop(slot3, "m_iControlledPlayer", slot2, slot1)
	uv0(slot2)
	uv0(slot1)
end

function slot57()
	slot0 = ui.get(uv0)

	ui.set_visible(uv1, slot0)
	ui.set_visible(uv2, slot0)

	if slot0 and not uv3 then
		client.set_event_callback("paint", uv4)
		client.set_event_callback("shutdown", uv5)
		client.set_event_callback("level_init", uv6)
		client.set_event_callback("player_team", uv7)
		uv8("player_disconnect", uv9)
		uv8("player_death", uv10)
		uv8("player_spawn", uv11)
		uv8("item_remove", uv12)
		uv8("item_pickup", uv13)
		uv8("item_equip", uv14)
		uv8("bot_takeover", uv15)
		uv16()
		uv17.create()
	elseif not slot0 and uv3 then
		client.unset_event_callback("paint", uv4)
		client.unset_event_callback("shutdown", uv5)
		client.unset_event_callback("level_init", uv6)
		client.unset_event_callback("player_team", uv7)
		uv18()
		uv19(uv20)
		uv19(uv21)
		uv17.destroy()
	end

	uv3 = slot0
end

function slot58(slot0, slot1)
	if slot1 == nil then
		slot1 = uv0(ui.get(uv1), function (slot0, slot1)
			return slot1, true
		end)
	end

	if type(slot0) == "table" then
		if (slot0.userid ~= nil and client.userid_to_entindex(slot0.userid)) ~= nil then
			if type(uv2.GetPlayerXuidStringFromEntIndex(slot2)) ~= "string" or slot0 == "0" then
				return
			end
		else
			return
		end
	end

	if (slot1["All players"] or slot1.Self and slot0 == uv3.GetXuid() or slot1.Friends and uv4.GetFriendRelationship(slot0) == "friend") and uv5.unmute_player(slot0) then
		-- Nothing
	end
end

function ()
	for slot5 = 1, #json.parse(tostring(uv2.get_all_players())) do
		uv3(slot1[slot5], uv0(ui.get(uv1), function (slot0, slot1)
			return slot1, true
		end))
	end
end()

function slot60()
	uv0()
	client.delay_call(5, uv0)
end

ui.set_callback(ui.new_multiselect("VISUALS", "Other ESP", "Auto unmute players", {
	"Self",
	"Friends",
	"All players"
}), function ()
	uv2.restore_unmuted_players()

	if next(uv0(ui.get(uv1), function (slot0, slot1)
		return slot1, true
	end)) then
		uv3()
		client.set_event_callback("level_init", uv4)
		client.set_event_callback("player_connect_full", uv5)

		if not slot0.Self then
			uv2.disable_selected_player_muted_hook()
		end
	else
		client.unset_event_callback("level_init", uv4)
		client.unset_event_callback("player_connect_full", uv5)
		uv2.disable_selected_player_muted_hook()
	end
end)
slot30.enable_playing_match_hook()
client.set_event_callback("shutdown", function ()
	uv0.disable_playing_match_hook()
	uv0.disable_selected_player_muted_hook()
	uv0.restore_unmuted_players()
end)
ui.set_callback(ui.new_checkbox("VISUALS", "Other ESP", "Enemies only"), function ()
	for slot3, slot4 in pairs(uv0) do
		if not entity.is_dormant(slot3) and not entity.is_enemy(slot3) then
			uv0[slot3] = nil
		end
	end
end)
ui.set_callback(slot36, function ()
	uv0(uv1)

	if ui.get(uv2) then
		uv5 = uv3(ui.get(uv4), function (slot0, slot1)
			return slot1, true
		end).Armor
		slot1 = nil

		if entity.get_local_player() ~= nil then
			slot1 = entity.get_prop(slot2, "m_iTeamNum")
		end

		for slot6, slot7 in pairs(uv6) do
			slot8 = false

			if slot7.type == "rifle" or slot7.type == "machinegun" or slot7.type == "sniperrifle" or slot7.type == "smg" or slot7.type == "shotgun" then
				slot8 = slot0.Primary
			elseif slot7.type == "pistol" then
				slot8 = slot0.Secondary
			elseif slot7 == uv7 then
				slot8 = slot0.Taser
			elseif slot7.type == "c4" then
				if slot1 ~= uv8 then
					slot8 = slot0.Bomb
				else
					slot8 = false
				end
			elseif slot7 == uv9 or slot7 == uv10 then
				if slot1 ~= uv11 then
					slot8 = slot0["Defuse Kit"]
				else
					slot8 = false
				end
			elseif slot7.type == "knife" or slot7.type == "fists" or slot7.type == "melee" then
				slot8 = slot0.Knife
			elseif slot7.type == "grenade" or slot7.type == "breachcharge" then
				slot8 = slot0.Grenades
			elseif slot7 ~= uv12 and slot7 ~= uv13 and slot7 ~= uv14 then
				slot8 = slot0.Other
			end

			if slot8 then
				uv1[slot7] = slot7.console_name:gsub("^item_", ""):gsub("^weapon_", "")
			end
		end

		for slot6, slot7 in pairs(uv15) do
			uv16(slot6)
		end
	end
end)
ui.set_callback(ui.new_checkbox("VISUALS", "Other ESP", "Display equipment on scoreboard"), slot57)
slot57()
