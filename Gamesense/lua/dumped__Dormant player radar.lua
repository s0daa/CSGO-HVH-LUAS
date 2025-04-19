slot0 = require("ffi")
slot1 = slot0.cast
slot4 = panorama.loadstring([[
	var _ClearStylesRecursive = function(panel) {
		if(panel == "Selected")
			return

		delete panel.style.backgroundPosition
		delete panel.style.backgroundSize
		delete panel.style.backgroundRepeat
		delete panel.style.paddingLeft
		delete panel.style.x

		try {
			for (var key in panel.style) {
				panel.style[key] = null
				delete panel.style[key]
			}
		} catch(e) {
			// $.Msg("[DormantRadar] Error clearing styles on " + panel.id + ": " + e)
		}

		for (var i = 0; i < panel.GetChildCount(); i++) {
			_ClearStylesRecursive(panel.GetChild(i))
		}
	}

	var _UpdatePlayers = function(players_associative, teammates_are_enemies, local_alive, bomb_player) {
		var radar = $.GetContextPanel().FindChildrenWithClassTraverse("hud-radar")[0].FindChild("Radar")

		if(radar == null)
			return

		// make sure RI_BombDefuserPackage is the last child
		var last_child = radar.GetChild(radar.GetChildCount() - 1)
		if(last_child && last_child.id != "RI_BombDefuserPackage") {
			if(radar.FindChild("RI_BombDefuserPackage"))
				radar.MoveChildAfter(radar.FindChild("RI_BombDefuserPackage"), last_child)
		}

		var last_child
		var bomb_child

		radar.Children().forEach(panel => {
			if(panel.entindex == null) {
				var match = panel.id.match(/^Player(\d+)$/)

				panel.entindex = match ? (match[1] || -1) : -1
			}

			// hide the default carried bomb for dormant players. we create our own icon
			if(panel.id == "RI_BombDefuserPackage") {
				var bomb = panel.FindChild("CreateBombPack")
				bomb.style.transition = bomb_player ? "opacity 0.2s ease-in-out 0.0s" : null
				bomb.style.opacity = bomb_player ? 0 : 1

				// $.Msg("default ", bomb)
			}

			if(panel.entindex == -1)
				return

			last_child = panel

			var images = panel.FindChildTraverse("PI_FirstRotated")
			var custom_bomb_icon = panel.FindChildTraverse("Custom_BombIcon")

			var player = players_associative[panel.id]

			if(!local_alive && (images.FindChild("ViewFrustrum").visible || images.FindChild("Selected").visible)){
				// $.Msg("ignoring player M1 ", panel.entindex)
				player = null
			}

			// images.FindChild("EnemyOnMap").visible = null
			if(teammates_are_enemies && player != null) {
				// I hate myself but I hate valve even more
				// var transform = images.style.transform
				// if(transform.includes("rotate3d"))
				//	 images.style.transform = transform.split("\n").filter(line => !line.startsWith("rotate3d")).map(line => line.replace(/(.*px) (.*px) (.*px)/, "$1, $2, $3")).join(" ")

				var ids = ["TOnMap", "CTOnMap"]
				ids.forEach((id) => {
					var image = images.FindChild(id)

					image.style.width = "14px"
					image.style.height = "14px"
					image.style.padding = "7px"
					image.style.saturation = "0"
					image.style.backgroundImage = "url(\"file://{images}/hud/radar/icon-enemy-on-map.png\")"
					image.style.backgroundPosition = "center center"
					image.style.backgroundRepeat = "no-repeat no-repeat"
					image.style.backgroundSize = "100%"
				})
			}

			if(player) {
				var offmap = images.FindChild("EnemyOffMap")
				var onmap = images.FindChild("EnemyOnMap")

				// images.visible = player.alive

				images.style.saturation = "0"
				images.style.washColor = player.dormant ? "#B2B2B2FF" : "#FF1919FF"
				images.style.transition = player.alpha > 0 ? "wash-color 0.2s ease-in-out 0.0s" : null
				images.style.opacity = player.alpha

				var enemy_ghost = images.FindChild("EnemyGhost")
				enemy_ghost.visible = false

				// onmap.style.maxHeight = (!offmap.visible && !enemy_ghost.visible && player.alive) ? null : 0
				// onmap.style.maxHeight = (!enemy_ghost.visible && player.alive) ? null : 0

				images.FindChild("AbovePlayer").style.maxHeight = 0
				images.FindChild("BelowPlayer").style.maxHeight = 0
				// images.FindChild("CTGhost").style.maxHeight = 0
				// images.FindChild("TGhost").style.maxHeight = 0
				// images.FindChild("EnemyDeath").visible = false

				if(player.entindex == bomb_player) {
					if(custom_bomb_icon == null) {
						// $.Msg("creating custom_bomb_icon ", panel.id)
						custom_bomb_icon = $.CreatePanel("Image", images, "Custom_BombIcon", {
							src: "file://{images}/hud/radar/C4_sml.png",
							style: "width: 15px; height: 11px; horizontal-align: center; vertical-align: center; wash-color: #C9C9C9FF; img-shadow: 0px 0px 1px 2 #11111111;"
						})
					}

					// $.Msg("custom ", custom_bomb_icon)
					custom_bomb_icon.visible = true
					custom_bomb_icon.style.opacity = Math.min(1, player.alpha * 1.2)
					bomb_child = panel
				} else if(custom_bomb_icon != null) {
					custom_bomb_icon.visible = false
				}
			} else {
				// clean up
				if(custom_bomb_icon != null) {
					custom_bomb_icon.DeleteAsync(0.0)
					custom_bomb_icon.visible = false
					custom_bomb_icon.SetParent($.GetContextPanel())
				}

				_ClearStylesRecursive(panel)
			}

			// fix csgo bug #81237123761236: the circle when spectating is off center
			images.FindChild("Selected").style.position = "0px -10px 0px"
		})

		// move the player with the bomb to the top
		if(last_child != null && bomb_child != null && last_child != bomb_child) {
			radar.MoveChildAfter(bomb_child, last_child)
		}
	}

	return {
		update_players: _UpdatePlayers
	}
]], "CSGOHud")()
slot5 = vtable_bind("client.dll", "VClient018", 8, "void*(__thiscall*)(void*)")
slot6 = slot0.typeof([[
	struct {
		int pad[2];
		char* name;
		void* recv_table;
		void* next;
		int class_id;
	} *
]])
slot7 = {}

function ()
	table.clear(uv0)

	if entity.get_local_player() == nil then
		return
	end

	slot0 = uv1()

	while slot0 ~= nil do
		if uv2(uv3, slot0).class_id > 0 and slot1.recv_table ~= nil then
			uv0[uv4.string(slot1.name)] = slot1.class_id
		end

		slot0 = slot1.next
	end
end()
assert(slot1("int*", slot1("char*", client.find_signature("client.dll", "h\\xcc\\xcc\\xcc\\xccAE\\xe4A \\xf3~E\\xccf\\xd6ẢA8\\xb9\\xcc\\xcc\\xcc\\xcc\\xe8\\xcc\\xcc\\xcc\\xccj\\xccj\\xccjj`")) + 1)[0] == 2432)

slot10 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
slot13 = slot1("uintptr_t", slot1("void***(__thiscall*)(void*, const char*)", client.find_signature("client.dll", "U\\x8b\\xecS\\x8b]VW\\x8b\\xf93\\xf69w("))(slot1("void**", slot1("char*", client.find_signature("client.dll", "\\xb9\\xcc\\xcc\\xcc̈F\t") or error("HUD signature outdated")) + 1)[0], "CCSGO_HudRadar"))
slot14 = slot1("bool(__thiscall*)(void*, int*)", client.find_signature("client.dll", "U\\x8b\\xec\\x83\\xecSV\\x8buW\\x8b\\xf9\\xc7E"))

function slot15(slot0, slot1)
	slot2 = uv0.new("uint8_t[32]")

	if uv1.CCSPlayer == nil then
		uv2()

		return
	end

	uv3("bool*", slot2 + 24)[0] = slot0
	uv3("int*", slot2 + 12)[0] = #slot1
	slot8 = uv0.new("int[?]", #slot1)
	uv3("int*", slot2 + 8)[0] = uv3("int", slot8)

	for slot8, slot9 in ipairs(slot1) do
		slot10 = uv0.new("uint8_t[?]", #slot1 * 100) + (slot8 - 1) * 100
		slot3[slot8 - 1] = uv3("int", slot10)
		uv3("int*", slot10 + 8)[0] = slot9.entindex
		uv3("int*", slot10 + 12)[0] = uv1[entity.get_classname(slot9.entindex)]
		uv3("int*", slot10 + 16)[0] = slot9.x / 4
		uv3("int*", slot10 + 20)[0] = slot9.y / 4
		uv3("int*", slot10 + 24)[0] = slot9.z / 4
		uv3("int*", slot10 + 28)[0] = slot9.yaw
		uv3("bool*", slot10 + 32)[0] = slot9.defuser
		uv3("bool*", slot10 + 34)[0] = slot9.player_has_c4
	end

	uv4(uv3("void*", uv5 - 20), uv3("int*", slot2))
end

slot16 = nil

client.set_event_callback("level_init", function ()
	uv0 = nil

	client.delay_call(1, uv1)
end)
client.set_event_callback("round_end", slot8)
client.set_event_callback("player_connect_full", slot8)

function slot17()
	slot0 = {}
	slot1 = {}

	if entity.get_local_player() == nil then
		return
	end

	slot3, slot4 = nil
	slot5 = cvar.mp_teammates_are_enemies:get_int() ~= 0
	slot7 = nil

	if not (entity.get_prop(slot2, "deadflag") == 0) then
		slot7 = entity.get_prop(slot2, "m_hObserverTarget")
	end

	if slot5 then
		slot3 = select(3, entity.get_origin(slot2))
		slot4 = entity.get_prop(slot2, "m_iTeamNum")
	end

	slot9 = entity.get_prop(entity.get_player_resource(), "m_iPlayerC4")
	slot10 = nil

	for slot14 = 1, globals.maxplayers() do
		if slot14 ~= slot2 and entity.get_classname(slot14) == "CCSPlayer" and entity.is_enemy(slot14) then
			if slot5 then
				slot16 = uv1("int64_t*", uv1("char*", uv0(slot14)) + uv2)
				slot16[0] = bit.bor(slot16[0], bit.lshift(1, slot2 - 1))
			end

			entity.set_prop(slot14, "m_bSpotted", 1)

			slot16 = entity.is_alive(slot14)
			slot0[string.format("Player%d", slot14 - 1)] = {
				name = entity.get_player_name(slot14),
				entindex = slot14,
				dormant = slot15,
				alive = slot16,
				alpha = entity.is_dormant(slot14) and math.floor(entity.get_esp_data(slot14).alpha * 80 + 0.5) / 80 or 1,
				observed = slot14 == slot7
			}

			if slot16 and (not slot15 or slot17.alpha > 0) then
				slot19, slot20, slot21 = entity.get_origin(slot14)

				if slot5 and slot14 ~= slot7 and entity.get_prop(slot14, "m_iTeamNum") == slot4 then
					slot21 = slot3 - 500
				end

				table.insert(slot1, {
					player_has_c4 = false,
					player_has_defuser = false,
					defuser = false,
					yaw = 0,
					entindex = slot14,
					x = slot19,
					y = slot20,
					z = slot21
				})

				if slot9 == slot14 and entity.is_dormant(slot14) then
					slot10 = slot14
				end
			end
		end
	end

	uv3(false, slot1)

	if json.stringify(slot0) ~= uv4 then
		uv4 = slot11

		uv5.update_players(slot0, slot5, slot6, slot10)
	end
end

function slot18()
	uv0 = nil
end

function slot19()
	uv0 = nil

	uv1.update_players({}, false, false, nil)
end

function slot20()
	if ui.get(uv0) and ui.get(uv1) then
		client.set_event_callback("pre_render", uv2)
		client.set_event_callback("shutdown", uv3)
		client.set_event_callback("spec_target_updated", uv4)
	else
		client.unset_event_callback("pre_render", uv2)
		client.unset_event_callback("shutdown", uv3)
		client.unset_event_callback("spec_target_updated", uv4)
		uv3()
	end
end

ui.set_callback(ui.reference("VISUALS", "Player ESP", "Dormant"), slot20)
ui.set_callback(ui.reference("VISUALS", "Other ESP", "Radar"), slot20)
slot20()
