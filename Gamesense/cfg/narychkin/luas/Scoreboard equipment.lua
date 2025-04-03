--
-- dependencies
--

local csgo_weapons = require "gamesense/csgo_weapons"
local table_clear = require "table.clear"

--
-- constants
--

local EVENT_IDX_TO_WEAPON = setmetatable({}, {
	__index = function(tbl, idx)
		tbl[idx] = csgo_weapons[tonumber(idx)] or false
		return tbl[idx]
	end
})

local ITEM_KEVLAR = csgo_weapons["item_kevlar"]
local ITEM_ASSAULTSUIT = csgo_weapons["item_assaultsuit"]
local ITEM_HEAVYASSAULTSUIT = csgo_weapons["item_heavyassaultsuit"]
local ITEM_CUTTERS = csgo_weapons["item_cutters"]
local ITEM_DEFUSER = csgo_weapons["item_defuser"]
local WEAPON_TASER = csgo_weapons["weapon_taser"]
local WEAPON_C4 = csgo_weapons["weapon_c4"]

local TEAM_T = 2
local TEAM_CT = 3

--
-- utility functions
--

local function deep_compare(tbl1, tbl2)
	for key1, value1 in pairs(tbl1) do
		local value2 = tbl2[key1]

		if value2 == nil then
			-- avoid the type call for missing keys in tbl2 by directly comparing with nil
			return false
		elseif value1 ~= value2 then
			if type(value1) == "table" and type(value2) == "table" then
				if not deep_compare(value1, value2) then
					return false
				end
			else
				return false
			end
		end
	end

	-- check for missing keys in tbl1
	for key2, _ in pairs(tbl2) do
		if tbl1[key2] == nil then
			return false
		end
	end

	return true
end

local function table_map_filter(tbl, callback)
	local new, j = {}, 1

	for i=1, #tbl do
		local value = callback(tbl[i])
		if value ~= nil then
			new[j] = value
			j = j + 1
		end
	end

	return new
end

local function table_map_assoc(tbl, callback)
	local new = {}
	for key, value in pairs(tbl) do
		local new_key, new_value = callback(key, value)
		new[new_key] = new_value
	end
	return new
end

local function table_contains(tbl, val)
	for i=1,#tbl do
		if tbl[i] == val then
			return true
		end
	end
	return false
end

local function table_remove_item(tbl, item)
	for i=#tbl, 1, -1 do
		if tbl[i] == item then
			table.remove(tbl, i)
		end
	end
end

--
-- since events are unordered, we sort them here
--

local event_sort_pos = {
	item_remove = 0,
	player_disconnect = 0,
	player_death = 0,
	player_spawn = 1,
	item_pickup = 2,
	item_equip = 2,
}

local function sort_events_cb(a, b)
	local a_i = event_sort_pos[a[1]] or a[1]:byte()
	local b_i = event_sort_pos[b[1]] or b[1]:byte()

	return a_i < b_i
end

local delayed_events = {}
local event_callbacks = {}
local event_callbacks_orig = {}
local delayed_events_curtime

local function run_pending_callbacks()
	if delayed_events_curtime ~= nil then
		table.sort(delayed_events, sort_events_cb)

		for i=1, #delayed_events do
			local event, e, curtime = unpack(delayed_events[i])

			local handlers = event_callbacks[event]
			for j=1, #handlers do
				xpcall(handlers[j], client.error_log, e)
			end
		end

		table_clear(delayed_events)
		delayed_events_curtime = nil
	end
end

local function add_delayed_callback(event, callback)
	if event_callbacks[event] == nil then
		local handlers = {}

		event_callbacks_orig[event] = function(e)
			local curtime = globals.curtime()

			-- if curtime changed dispatch all pending events right now
			if delayed_events_curtime == nil then
				delayed_events_curtime = curtime
			elseif delayed_events_curtime ~= curtime then
				run_pending_callbacks()

				delayed_events_curtime = curtime
			end

			table.insert(delayed_events, {event, e})
		end
		client.set_event_callback(event, event_callbacks_orig[event])

		event_callbacks[event] = handlers
	end

	table.insert(event_callbacks[event], callback)
end

local function clear_delayed_callbacks()
	for event, callback_orig in pairs(event_callbacks_orig) do
		client.unset_event_callback(event, callback_orig)
	end

	table_clear(event_callbacks_orig)
	table_clear(event_callbacks)
	table_clear(delayed_events)

	delayed_events_curtime = nil
end

--
-- js context / code block
--

local jsc = panorama.open("CSGOHud")
local FriendsListAPI, MyPersonaAPI, GameStateAPI = jsc.FriendsListAPI, jsc.MyPersonaAPI, jsc.GameStateAPI

local js = panorama.loadstring([[
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

--
-- logic for sorting weapons
--

local sort_pos = {
	[csgo_weapons["weapon_hegrenade"]] = 10,
	[csgo_weapons["weapon_decoy"]] = csgo_weapons["weapon_molotov"].idx-1,
	[csgo_weapons["weapon_smokegrenade"]] = csgo_weapons["weapon_smokegrenade"].idx-1,
	[csgo_weapons["weapon_taser"]] = 3,
}

local name_add_weapon, name_add_max = {}, 0
for idx, weapon in pairs(csgo_weapons) do
	local name_add = string.byte(weapon.name)

	name_add_weapon[weapon] = name_add

	name_add_max = math.max(name_add, name_add_max)

	local name_panorama = weapon.console_name:gsub("^item_", ""):gsub("^weapon_", "")

	-- align pistols
	if weapon.type == "pistol" then
		js.set_min_max_width(name_panorama, "31px") -- 29px
	elseif weapon.type == "knife" and weapon ~= WEAPON_TASER then
		js.set_min_max_width(name_panorama, "45px", "45px",  "smaller")
	end
end

-- fix knife icons
js.set_min_max_width("knife", nil, nil, "small")
js.set_min_max_width("knife_t", nil, nil, "small")
js.set_min_max_width("knife_widowmaker", nil, nil, "small")
js.set_min_max_width("knife_butterfly", nil, nil, "small")
js.set_min_max_width("knife_survival_bowie", nil, nil, "large")
js.set_min_max_width("knife_gut", nil, nil, "medium")
js.set_min_max_width("knife_karambit", nil, nil, "medium")
js.set_min_max_width("knife_ursus", nil, nil, "small")

js.set_min_max_width("hkp2000", nil, nil, "medium")

-- grenades
js.set_min_max_width("incgrenade", "12px")
js.set_min_max_width("smokegrenade", "9px")
js.set_min_max_width("flashbang", "9px", "12px")

for idx, weapon in pairs(csgo_weapons) do
	if sort_pos[weapon] == nil then
		local name_add = name_add_weapon[weapon] / name_add_max

		if weapon.type == "rifle" or weapon.type == "machinegun" or weapon.type == "sniperrifle" or weapon.type == "smg" or weapon.type == "shotgun" then
			sort_pos[weapon] = 0+name_add
		elseif weapon.type == "pistol" then
			sort_pos[weapon] = 1+name_add
		elseif weapon.type == "knife" or weapon.type == "fists" or weapon.type == "melee" then
			sort_pos[weapon] = 2+name_add
		else
			-- print(weapon.console_name, " ", weapon.type)
			sort_pos[weapon] = weapon.idx
		end
	end
end

local function sort_weapons_cb(a, b)
	local a_i = sort_pos[a] or a.idx
	local b_i = sort_pos[b] or b.idx

	return a_i < b_i
end

--
-- actual script logic
--

local enabled_reference = ui.new_checkbox("VISUALS", "Other ESP", "Display equipment on scoreboard")
local filter_reference = ui.new_multiselect("VISUALS", "Other ESP", "\nScoreboard equipment filter", {"Primary", "Secondary", "Knife", "Taser", "Grenades", "Bomb", "Defuse Kit", "Armor", "Other"})
local enemy_only_reference = ui.new_checkbox("VISUALS", "Other ESP", "Enemies only")
local auto_unmute_reference = ui.new_multiselect("VISUALS", "Other ESP", "Auto unmute players", {"Self", "Friends", "All players"})

ui.set(filter_reference, {"Primary", "Secondary", "Grenades", "Bomb"})

local player_data = {}
local filter_weapon_name = {}
local filter_armor_enabled = false
local enabled_prev = false

local function filter_cb(weapon)
	return filter_weapon_name[weapon]
end

local function update_player_data(player)
	-- print("update_player_data(", player, ")")

	local current_player_data = player_data[player]

	local ignore_teammate = ui.get(enemy_only_reference) and not entity.is_dormant(player) and not entity.is_enemy(player)

	local player_scoreboard = player
	local player_resource = entity.get_player_resource()
	if entity.get_prop(player_resource, "m_bControllingBot", player) == 1 then
		player_scoreboard = entity.get_prop(player_resource, "m_iControlledPlayer", player)
		js.update_player(player, nil, nil, nil)

		-- print(player, " is controlling ", player_scoreboard)
	end

	if current_player_data == nil or ignore_teammate then
		js.update_player(player_scoreboard, nil, nil, nil)
	else
		js.update_player(
			player_scoreboard,
			current_player_data.weapons and table_map_filter(current_player_data.weapons, filter_cb) or nil,
			current_player_data.active_weapon and filter_weapon_name[current_player_data.active_weapon] or nil,
			filter_armor_enabled and current_player_data.armor or nil
		)
	end
end

local function update_filters()
	table_clear(filter_weapon_name)

	if ui.get(enabled_reference) then
		local filters_enabled = table_map_assoc(ui.get(filter_reference), function(i, typ) return typ, true end)

		filter_armor_enabled = filters_enabled["Armor"]

		local team
		local local_player = entity.get_local_player()
		if local_player ~= nil then
			team = entity.get_prop(local_player, "m_iTeamNum")
		end

		for idx, weapon in pairs(csgo_weapons) do
			local include = false

			-- print(weapon.console_name, ": ", weapon.type)

			if weapon.type == "rifle" or weapon.type == "machinegun" or weapon.type == "sniperrifle" or weapon.type == "smg" or weapon.type == "shotgun" then
				include = filters_enabled["Primary"]
			elseif weapon.type == "pistol" then
				include = filters_enabled["Secondary"]
			elseif weapon == WEAPON_TASER then
				include = filters_enabled["Taser"]
			elseif weapon.type == "c4" then
				include = team ~= TEAM_T and filters_enabled["Bomb"]
			elseif weapon == ITEM_CUTTERS or weapon == ITEM_DEFUSER then
				include = team ~= TEAM_CT and filters_enabled["Defuse Kit"]
			elseif weapon.type == "knife" or weapon.type == "fists" or weapon.type == "melee" then
				include = filters_enabled["Knife"]
			elseif weapon.type == "grenade" or weapon.type == "breachcharge" then
				include = filters_enabled["Grenades"]
			elseif weapon ~= ITEM_ASSAULTSUIT and weapon ~= ITEM_KEVLAR and weapon ~= ITEM_HEAVYASSAULTSUIT then
				include = filters_enabled["Other"]
			end

			if include then
				filter_weapon_name[weapon] = weapon.console_name:gsub("^item_", ""):gsub("^weapon_", "")
			end
		end

		for player, data in pairs(player_data) do
			update_player_data(player)
		end
	end
end

--
-- event callbacks
--

local function on_paint()
	run_pending_callbacks()

	local player_resource = entity.get_player_resource()
	local free_kevlar = cvar.mp_free_armor:get_int() > 0
	local free_helmet = cvar.mp_free_armor:get_int() > 1
	local free_defuser = cvar.mp_defuser_allocation:get_int() >= 2

	for player=1, 64 do
		if entity.get_classname(player) == "CCSPlayer" then
			local current_player_data
			if not entity.is_dormant(player) then
				if entity.is_alive(player) then
					current_player_data = {
						weapons = {}
					}

					local active_weapon = entity.get_player_weapon(player)
					if active_weapon ~= nil then
						if not free_defuser and entity.get_prop(player, "m_bHasDefuser") == 1 then
							table.insert(current_player_data.weapons, ITEM_DEFUSER)
						end

						for slot=0, 63 do
							local weapon_ent = entity.get_prop(player, "m_hMyWeapons", slot)

							if weapon_ent ~= nil then
								local weapon = csgo_weapons[entity.get_prop(weapon_ent, "m_iItemDefinitionIndex")]

								table.insert(current_player_data.weapons, weapon)

								if weapon_ent == active_weapon then
									current_player_data.active_weapon = weapon
								end
							end
						end
						table.sort(current_player_data.weapons, sort_weapons_cb)
					end
				else
					current_player_data = nil
				end
			else
				current_player_data = player_data[player]
			end

			if current_player_data ~= nil then
				if entity.get_prop(player_resource, "m_iArmor", player) > 0 then
					if entity.get_prop(player_resource, "m_bHasHelmet", player) == 1 then
						if not free_helmet then
							current_player_data.armor = "helmet"
						end
					elseif not free_kevlar then
						current_player_data.armor = "kevlar"
					end
				else
					current_player_data.armor = nil
				end
			end

			if (player_data[player] == nil and current_player_data ~= nil) or (current_player_data == nil and player_data[player] ~= nil) or (current_player_data ~= nil and player_data[player] ~= nil and not deep_compare(current_player_data, player_data[player])) then
				player_data[player] = current_player_data

				update_player_data(player)
			end
		end
	end
end

local function on_shutdown()
	if enabled_prev then
		js.destroy()
	end
end

local function on_level_init()
	table_clear(player_data)
	js.clear()
end

local function on_player_team(e)
	local player = client.userid_to_entindex(e.userid)

	if player == entity.get_local_player() then
		client.delay_call(0.1, update_filters)
	elseif player > 0 then
		-- update_filters will already call update_player_data for everyone
		update_player_data(player)
	end
end

--
-- game event callbacks for dormant data
--

local function on_player_disconnect(e)
	local player = client.userid_to_entindex(e.userid)

	player_data[player] = nil

	update_player_data(player)
end

local function on_player_death(e)
	local player = client.userid_to_entindex(e.userid)

	if player_data[player] ~= nil and entity.is_dormant(player) then
		player_data[player] = nil

		update_player_data(player)
	end
end

local function on_player_spawn(e)
	local player = client.userid_to_entindex(e.userid)

	if player_data[player] == nil then
		player_data[player] = {
			weapons = {}
		}
	elseif player_data[player].weapons ~= nil then
		table_remove_item(player_data[player].weapons, WEAPON_C4)
	end

	update_player_data(player)
end

local function on_item_remove(e)
	local player = client.userid_to_entindex(e.userid)
	local weapon = EVENT_IDX_TO_WEAPON[e.defindex]

	if player_data[player] ~= nil and entity.is_dormant(player) and weapon then
		if weapon ~= ITEM_KEVLAR and weapon ~= ITEM_ASSAULTSUIT then
			table_remove_item(player_data[player].weapons, weapon)

			update_player_data(player)
		end
	end
end

local function on_item_pickup(e)
	local player = client.userid_to_entindex(e.userid)
	local weapon = EVENT_IDX_TO_WEAPON[e.defindex]

	if player_data[player] ~= nil and entity.is_dormant(player) and weapon then
		if weapon == ITEM_KEVLAR or weapon == ITEM_ASSAULTSUIT then
			local free_kevlar = cvar.mp_free_armor:get_int() > 0
			local free_helmet = cvar.mp_free_armor:get_int() > 1

			if weapon == ITEM_KEVLAR then
				if not free_helmet and player_data[player].armor == nil then
					player_data[player].armor = "kevlar"
				end
			elseif not free_kevlar then
				player_data[player].armor = "helmet"
			end
		elseif (weapon == ITEM_CUTTERS or weapon == ITEM_DEFUSER) and cvar.mp_defuser_allocation:get_int() >= 2 then
			return
		elseif not table_contains(player_data[player].weapons, weapon) then
			table.insert(player_data[player].weapons, weapon)
			table.sort(player_data[player].weapons, sort_weapons_cb)

			update_player_data(player)
		end
	end
end

local function on_item_equip(e)
	local player = client.userid_to_entindex(e.userid)
	local weapon = EVENT_IDX_TO_WEAPON[e.defindex]

	if player_data[player] ~= nil and entity.is_dormant(player) and weapon then
		player_data[player].active_weapon = weapon

		update_player_data(player)
	end
end

local function on_bot_takeover(e)
	local player = client.userid_to_entindex(e.userid)
	local bot = client.userid_to_entindex(e.botid)

	local player_resource = entity.get_player_resource()
	entity.set_prop(player_resource, "m_bControllingBot", 1, player)
	entity.set_prop(player_resource, "m_iControlledPlayer", bot, player)

	-- print("takeover -> update_player_data")

	update_player_data(bot)
	update_player_data(player)
end

local function on_enabled_changed()
	local enabled = ui.get(enabled_reference)

	ui.set_visible(filter_reference, enabled)
	ui.set_visible(enemy_only_reference, enabled)

	if enabled and not enabled_prev then
		client.set_event_callback("paint", on_paint)
		client.set_event_callback("shutdown", on_shutdown)
		client.set_event_callback("level_init", on_level_init)
		client.set_event_callback("player_team", on_player_team)

		add_delayed_callback("player_disconnect", on_player_disconnect)
		add_delayed_callback("player_death", on_player_death)
		add_delayed_callback("player_spawn", on_player_spawn)
		add_delayed_callback("item_remove", on_item_remove)
		add_delayed_callback("item_pickup", on_item_pickup)
		add_delayed_callback("item_equip", on_item_equip)
		add_delayed_callback("bot_takeover", on_bot_takeover)

		update_filters()
		js.create()
	elseif not enabled and enabled_prev then
		client.unset_event_callback("paint", on_paint)
		client.unset_event_callback("shutdown", on_shutdown)
		client.unset_event_callback("level_init", on_level_init)
		client.unset_event_callback("player_team", on_player_team)

		clear_delayed_callbacks()
		table_clear(player_data)
		table_clear(filter_weapon_name)

		js.destroy()
	end

	enabled_prev = enabled
end

--
-- auto unmute players stuff
-- filters: "Self", "Friends", "All players"
--

local function auto_unmute_update_player(xuid, filters)
	if filters == nil then
		filters = table_map_assoc(ui.get(auto_unmute_reference), function(i, typ) return typ, true end)
	end

	-- handle player_connect_full event
	if type(xuid) == "table" then
		local entindex = xuid.userid ~= nil and client.userid_to_entindex(xuid.userid)
		if entindex ~= nil then
			xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(entindex)

			-- return if not a valid xuid (bot for example)
			if type(xuid) ~= "string" or xuid == "0" then
				return
			end
		else
			return
		end
	end

	if (filters["All players"]) or (filters["Self"] and xuid == MyPersonaAPI.GetXuid()) or (filters["Friends"] and FriendsListAPI.GetFriendRelationship(xuid) == "friend") then
		if js.unmute_player(xuid) then
			-- print("unmuted ", xuid)
		else
			-- print(xuid, " isn't muted")
		end
	end
end

local function auto_unmute_update_all()
	local filters = table_map_assoc(ui.get(auto_unmute_reference), function(i, typ) return typ, true end)
	local all_players = json.parse(tostring(js.get_all_players()))

	-- print("updating all players")

	for i=1, #all_players do
		auto_unmute_update_player(all_players[i], filters)
	end
end
auto_unmute_update_all()

local function auto_unmute_level_init()
	auto_unmute_update_all()
	client.delay_call(5, auto_unmute_update_all)
end

ui.set_callback(auto_unmute_reference, function()
	local unmute_enabled = table_map_assoc(ui.get(auto_unmute_reference), function(i, typ) return typ, true end)

	js.restore_unmuted_players()

	-- one or more filters are enabled
	if next(unmute_enabled) then
		auto_unmute_update_all()

		client.set_event_callback("level_init", auto_unmute_level_init)
		client.set_event_callback("player_connect_full", auto_unmute_update_player)

		if unmute_enabled["Self"] then
			-- js.enable_selected_player_muted_hook()
		else
			js.disable_selected_player_muted_hook()
		end
	else
		client.unset_event_callback("level_init", auto_unmute_level_init)
		client.unset_event_callback("player_connect_full", auto_unmute_update_player)

		js.disable_selected_player_muted_hook()
	end
end)

js.enable_playing_match_hook()
client.set_event_callback("shutdown", function()
	js.disable_playing_match_hook()
	js.disable_selected_player_muted_hook()
	js.restore_unmuted_players()
end)

ui.set_callback(enemy_only_reference, function()
	for player, value in pairs(player_data) do
		if not entity.is_dormant(player) and not entity.is_enemy(player) then
			player_data[player] = nil
		end
	end
end)

ui.set_callback(filter_reference, update_filters)
ui.set_callback(enabled_reference, on_enabled_changed)
on_enabled_changed()