local var_0_0 = require("ffi")
local var_0_1 = var_0_0.cast
local var_0_2 = ui.reference("VISUALS", "Player ESP", "Dormant")
local var_0_3 = ui.reference("VISUALS", "Other ESP", "Radar")
local var_0_4 = panorama.loadstring("\tvar _ClearStylesRecursive = function(panel) {\n\t\tif(panel == \"Selected\")\n\t\t\treturn\n\n\t\tdelete panel.style.backgroundPosition\n\t\tdelete panel.style.backgroundSize\n\t\tdelete panel.style.backgroundRepeat\n\t\tdelete panel.style.paddingLeft\n\t\tdelete panel.style.x\n\n\t\ttry {\n\t\t\tfor (var key in panel.style) {\n\t\t\t\tpanel.style[key] = null\n\t\t\t\tdelete panel.style[key]\n\t\t\t}\n\t\t} catch(e) {\n\t\t\t// $.Msg(\"[DormantRadar] Error clearing styles on \" + panel.id + \": \" + e)\n\t\t}\n\n\t\tfor (var i = 0; i < panel.GetChildCount(); i++) {\n\t\t\t_ClearStylesRecursive(panel.GetChild(i))\n\t\t}\n\t}\n\n\tvar _UpdatePlayers = function(players_associative, teammates_are_enemies, local_alive, bomb_player) {\n\t\tvar radar = $.GetContextPanel().FindChildrenWithClassTraverse(\"hud-radar\")[0].FindChild(\"Radar\")\n\n\t\tif(radar == null)\n\t\t\treturn\n\n\t\t// make sure RI_BombDefuserPackage is the last child\n\t\tvar last_child = radar.GetChild(radar.GetChildCount() - 1)\n\t\tif(last_child && last_child.id != \"RI_BombDefuserPackage\") {\n\t\t\tif(radar.FindChild(\"RI_BombDefuserPackage\"))\n\t\t\t\tradar.MoveChildAfter(radar.FindChild(\"RI_BombDefuserPackage\"), last_child)\n\t\t}\n\n\t\tvar last_child\n\t\tvar bomb_child\n\n\t\tradar.Children().forEach(panel => {\n\t\t\tif(panel.entindex == null) {\n\t\t\t\tvar match = panel.id.match(/^Player(\\d+)$/)\n\n\t\t\t\tpanel.entindex = match ? (match[1] || -1) : -1\n\t\t\t}\n\n\t\t\t// hide the default carried bomb for dormant players. we create our own icon\n\t\t\tif(panel.id == \"RI_BombDefuserPackage\") {\n\t\t\t\tvar bomb = panel.FindChild(\"CreateBombPack\")\n\t\t\t\tbomb.style.transition = bomb_player ? \"opacity 0.2s ease-in-out 0.0s\" : null\n\t\t\t\tbomb.style.opacity = bomb_player ? 0 : 1\n\n\t\t\t\t// $.Msg(\"default \", bomb)\n\t\t\t}\n\n\t\t\tif(panel.entindex == -1)\n\t\t\t\treturn\n\n\t\t\tlast_child = panel\n\n\t\t\tvar images = panel.FindChildTraverse(\"PI_FirstRotated\")\n\t\t\tvar custom_bomb_icon = panel.FindChildTraverse(\"Custom_BombIcon\")\n\n\t\t\tvar player = players_associative[panel.id]\n\n\t\t\tif(!local_alive && (images.FindChild(\"ViewFrustrum\").visible || images.FindChild(\"Selected\").visible)){\n\t\t\t\t// $.Msg(\"ignoring player M1 \", panel.entindex)\n\t\t\t\tplayer = null\n\t\t\t}\n\n\t\t\t// images.FindChild(\"EnemyOnMap\").visible = null\n\t\t\tif(teammates_are_enemies && player != null) {\n\t\t\t\t// I hate myself but I hate valve even more\n\t\t\t\t// var transform = images.style.transform\n\t\t\t\t// if(transform.includes(\"rotate3d\"))\n\t\t\t\t//\t images.style.transform = transform.split(\"\\n\").filter(line => !line.startsWith(\"rotate3d\")).map(line => line.replace(/(.*px) (.*px) (.*px)/, \"$1, $2, $3\")).join(\" \")\n\n\t\t\t\tvar ids = [\"TOnMap\", \"CTOnMap\"]\n\t\t\t\tids.forEach((id) => {\n\t\t\t\t\tvar image = images.FindChild(id)\n\n\t\t\t\t\timage.style.width = \"14px\"\n\t\t\t\t\timage.style.height = \"14px\"\n\t\t\t\t\timage.style.padding = \"7px\"\n\t\t\t\t\timage.style.saturation = \"0\"\n\t\t\t\t\timage.style.backgroundImage = \"url(\\\"file://{images}/hud/radar/icon-enemy-on-map.png\\\")\"\n\t\t\t\t\timage.style.backgroundPosition = \"center center\"\n\t\t\t\t\timage.style.backgroundRepeat = \"no-repeat no-repeat\"\n\t\t\t\t\timage.style.backgroundSize = \"100%\"\n\t\t\t\t})\n\t\t\t}\n\n\t\t\tif(player) {\n\t\t\t\tvar offmap = images.FindChild(\"EnemyOffMap\")\n\t\t\t\tvar onmap = images.FindChild(\"EnemyOnMap\")\n\n\t\t\t\t// images.visible = player.alive\n\n\t\t\t\timages.style.saturation = \"0\"\n\t\t\t\timages.style.washColor = player.dormant ? \"#B2B2B2FF\" : \"#FF1919FF\"\n\t\t\t\timages.style.transition = player.alpha > 0 ? \"wash-color 0.2s ease-in-out 0.0s\" : null\n\t\t\t\timages.style.opacity = player.alpha\n\n\t\t\t\tvar enemy_ghost = images.FindChild(\"EnemyGhost\")\n\t\t\t\tenemy_ghost.visible = false\n\n\t\t\t\t// onmap.style.maxHeight = (!offmap.visible && !enemy_ghost.visible && player.alive) ? null : 0\n\t\t\t\t// onmap.style.maxHeight = (!enemy_ghost.visible && player.alive) ? null : 0\n\n\t\t\t\timages.FindChild(\"AbovePlayer\").style.maxHeight = 0\n\t\t\t\timages.FindChild(\"BelowPlayer\").style.maxHeight = 0\n\t\t\t\t// images.FindChild(\"CTGhost\").style.maxHeight = 0\n\t\t\t\t// images.FindChild(\"TGhost\").style.maxHeight = 0\n\t\t\t\t// images.FindChild(\"EnemyDeath\").visible = false\n\n\t\t\t\tif(player.entindex == bomb_player) {\n\t\t\t\t\tif(custom_bomb_icon == null) {\n\t\t\t\t\t\t// $.Msg(\"creating custom_bomb_icon \", panel.id)\n\t\t\t\t\t\tcustom_bomb_icon = $.CreatePanel(\"Image\", images, \"Custom_BombIcon\", {\n\t\t\t\t\t\t\tsrc: \"file://{images}/hud/radar/C4_sml.png\",\n\t\t\t\t\t\t\tstyle: \"width: 15px; height: 11px; horizontal-align: center; vertical-align: center; wash-color: #C9C9C9FF; img-shadow: 0px 0px 1px 2 #11111111;\"\n\t\t\t\t\t\t})\n\t\t\t\t\t}\n\n\t\t\t\t\t// $.Msg(\"custom \", custom_bomb_icon)\n\t\t\t\t\tcustom_bomb_icon.visible = true\n\t\t\t\t\tcustom_bomb_icon.style.opacity = Math.min(1, player.alpha * 1.2)\n\t\t\t\t\tbomb_child = panel\n\t\t\t\t} else if(custom_bomb_icon != null) {\n\t\t\t\t\tcustom_bomb_icon.visible = false\n\t\t\t\t}\n\t\t\t} else {\n\t\t\t\t// clean up\n\t\t\t\tif(custom_bomb_icon != null) {\n\t\t\t\t\tcustom_bomb_icon.DeleteAsync(0.0)\n\t\t\t\t\tcustom_bomb_icon.visible = false\n\t\t\t\t\tcustom_bomb_icon.SetParent($.GetContextPanel())\n\t\t\t\t}\n\n\t\t\t\t_ClearStylesRecursive(panel)\n\t\t\t}\n\n\t\t\t// fix csgo bug #81237123761236: the circle when spectating is off center\n\t\t\timages.FindChild(\"Selected\").style.position = \"0px -10px 0px\"\n\t\t})\n\n\t\t// move the player with the bomb to the top\n\t\tif(last_child != null && bomb_child != null && last_child != bomb_child) {\n\t\t\tradar.MoveChildAfter(bomb_child, last_child)\n\t\t}\n\t}\n\n\treturn {\n\t\tupdate_players: _UpdatePlayers\n\t}\n", "CSGOHud")()
local var_0_5 = vtable_bind("client.dll", "VClient018", 8, "void*(__thiscall*)(void*)")
local var_0_6 = var_0_0.typeof("\tstruct {\n\t\tint pad[2];\n\t\tchar* name;\n\t\tvoid* recv_table;\n\t\tvoid* next;\n\t\tint class_id;\n\t} *\n")
local var_0_7 = {}

local function var_0_8()
	table.clear(var_0_7)

	if entity.get_local_player() == nil then
		return
	end

	local var_1_0 = var_0_5()

	while var_1_0 ~= nil do
		local var_1_1 = var_0_1(var_0_6, var_1_0)

		if var_1_1.class_id > 0 and var_1_1.recv_table ~= nil then
			var_0_7[var_0_0.string(var_1_1.name)] = var_1_1.class_id
		end

		var_1_0 = var_1_1.next
	end
end

var_0_8()

local var_0_9 = var_0_1("int*", var_0_1("char*", client.find_signature("client.dll", "h\xCC\xCC\xCC\xCC\x0F\x11A\x10\x0F\x10E\xE4\x0F\x11A \xF3\x0F~E\xCCf\x0F\xD6ẢA8\xB9\xCC\xCC\xCC\xCC\xE8\xCC\xCC\xCC\xCCj\xCCj\xCCj\x01j`")) + 1)[0]

assert(var_0_9 == 2432)

local var_0_10 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
local var_0_11 = var_0_1("void**", var_0_1("char*", client.find_signature("client.dll", "\xB9\xCC\xCC\xCC̈F\t") or error("HUD signature outdated")) + 1)[0]
local var_0_12 = var_0_1("void***(__thiscall*)(void*, const char*)", client.find_signature("client.dll", "U\x8B\xECS\x8B]\bVW\x8B\xF93\xF69w("))
local var_0_13 = var_0_1("uintptr_t", var_0_12(var_0_11, "CCSGO_HudRadar"))
local var_0_14 = var_0_1("bool(__thiscall*)(void*, int*)", client.find_signature("client.dll", "U\x8B\xEC\x83\xEC\x18SV\x8Bu\bW\x8B\xF9\xC7E"))

local function var_0_15(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0.new("uint8_t[32]")

	if var_0_7.CCSPlayer == nil then
		var_0_8()

		return
	end

	var_0_1("bool*", var_2_0 + 24)[0] = arg_2_0
	var_0_1("int*", var_2_0 + 12)[0] = #arg_2_1

	local var_2_1 = var_0_0.new("int[?]", #arg_2_1)
	local var_2_2 = var_0_0.new("uint8_t[?]", #arg_2_1 * 100)

	var_0_1("int*", var_2_0 + 8)[0] = var_0_1("int", var_2_1)

	for iter_2_0, iter_2_1 in ipairs(arg_2_1) do
		local var_2_3 = var_2_2 + (iter_2_0 - 1) * 100

		var_2_1[iter_2_0 - 1] = var_0_1("int", var_2_3)
		var_0_1("int*", var_2_3 + 8)[0] = iter_2_1.entindex
		var_0_1("int*", var_2_3 + 12)[0] = var_0_7[entity.get_classname(iter_2_1.entindex)]
		var_0_1("int*", var_2_3 + 16)[0] = iter_2_1.x / 4
		var_0_1("int*", var_2_3 + 20)[0] = iter_2_1.y / 4
		var_0_1("int*", var_2_3 + 24)[0] = iter_2_1.z / 4
		var_0_1("int*", var_2_3 + 28)[0] = iter_2_1.yaw
		var_0_1("bool*", var_2_3 + 32)[0] = iter_2_1.defuser
		var_0_1("bool*", var_2_3 + 34)[0] = iter_2_1.player_has_c4
	end

	var_0_14(var_0_1("void*", var_0_13 - 20), var_0_1("int*", var_2_0))
end

local var_0_16

client.set_event_callback("level_init", function()
	var_0_16 = nil

	client.delay_call(1, var_0_8)
end)
client.set_event_callback("round_end", var_0_8)
client.set_event_callback("player_connect_full", var_0_8)

local function var_0_17()
	local var_4_0 = {}
	local var_4_1 = {}
	local var_4_2 = entity.get_local_player()

	if var_4_2 == nil then
		return
	end

	local var_4_3
	local var_4_4
	local var_4_5 = cvar.mp_teammates_are_enemies:get_int() ~= 0
	local var_4_6 = entity.get_prop(var_4_2, "deadflag") == 0
	local var_4_7

	if not var_4_6 then
		var_4_7 = entity.get_prop(var_4_2, "m_hObserverTarget")
	end

	if var_4_5 then
		var_4_3 = select(3, entity.get_origin(var_4_2))
		var_4_4 = entity.get_prop(var_4_2, "m_iTeamNum")
	end

	local var_4_8 = entity.get_player_resource()
	local var_4_9 = entity.get_prop(var_4_8, "m_iPlayerC4")
	local var_4_10

	for iter_4_0 = 1, globals.maxplayers() do
		if iter_4_0 ~= var_4_2 and entity.get_classname(iter_4_0) == "CCSPlayer" and entity.is_enemy(iter_4_0) then
			if var_4_5 then
				local var_4_11 = var_0_10(iter_4_0)
				local var_4_12 = var_0_1("int64_t*", var_0_1("char*", var_4_11) + var_0_9)

				var_4_12[0] = bit.bor(var_4_12[0], bit.lshift(1, var_4_2 - 1))
			end

			entity.set_prop(iter_4_0, "m_bSpotted", 1)

			local var_4_13 = entity.is_dormant(iter_4_0)
			local var_4_14 = entity.is_alive(iter_4_0)
			local var_4_15 = entity.get_esp_data(iter_4_0)
			local var_4_16 = var_4_13 and math.floor(var_4_15.alpha * 80 + 0.5) / 80 or 1

			var_4_0[string.format("Player%d", iter_4_0 - 1)] = {
				name = entity.get_player_name(iter_4_0),
				entindex = iter_4_0,
				dormant = var_4_13,
				alive = var_4_14,
				alpha = var_4_16,
				observed = iter_4_0 == var_4_7
			}

			if var_4_14 and (not var_4_13 or var_4_15.alpha > 0) then
				local var_4_17, var_4_18, var_4_19 = entity.get_origin(iter_4_0)

				if var_4_5 and iter_4_0 ~= var_4_7 and entity.get_prop(iter_4_0, "m_iTeamNum") == var_4_4 then
					var_4_19 = var_4_3 - 500
				end

				table.insert(var_4_1, {
					player_has_defuser = false,
					defuser = false,
					yaw = 0,
					player_has_c4 = false,
					entindex = iter_4_0,
					x = var_4_17,
					y = var_4_18,
					z = var_4_19
				})

				if var_4_9 == iter_4_0 and entity.is_dormant(iter_4_0) then
					var_4_10 = iter_4_0
				end
			end
		end
	end

	var_0_15(false, var_4_1)

	local var_4_20 = json.stringify(var_4_0)

	if var_4_20 ~= var_0_16 then
		var_0_16 = var_4_20

		var_0_4.update_players(var_4_0, var_4_5, var_4_6, var_4_10)
	end
end

local function var_0_18()
	var_0_16 = nil
end

local function var_0_19()
	var_0_16 = nil

	var_0_4.update_players({}, false, false, nil)
end

local function var_0_20()
	if ui.get(var_0_2) and ui.get(var_0_3) then
		client.set_event_callback("pre_render", var_0_17)
		client.set_event_callback("shutdown", var_0_19)
		client.set_event_callback("spec_target_updated", var_0_18)
	else
		client.unset_event_callback("pre_render", var_0_17)
		client.unset_event_callback("shutdown", var_0_19)
		client.unset_event_callback("spec_target_updated", var_0_18)
		var_0_19()
	end
end

ui.set_callback(var_0_2, var_0_20)
ui.set_callback(var_0_3, var_0_20)
var_0_20()
