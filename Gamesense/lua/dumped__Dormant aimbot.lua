slot0 = client.visible
slot1 = client.eye_position
slot2 = client.log
slot3 = client.trace_bullet
slot4 = entity.get_bounding_box
slot5 = entity.get_local_player
slot6 = entity.get_origin
slot7 = entity.get_player_name
slot8 = entity.get_player_resource
slot9 = entity.get_player_weapon
slot10 = entity.get_prop
slot11 = entity.is_dormant
slot12 = entity.is_enemy
slot13 = globals.curtime
slot14 = globals.maxplayers
slot15 = globals.tickcount
slot16 = math.max
slot17 = renderer.indicator
slot18 = string.format
slot19 = ui.get
slot21 = ui.new_hotkey
slot22 = ui.reference
slot23 = ui.set_callback
slot24 = sqrt
slot25 = unpack
slot26 = entity.is_alive
slot27 = plist.get
slot28 = require("ffi")
slot29 = require("vector")
slot30 = require("gamesense/csgo_weapons")
slot31 = vtable_bind("client_panorama.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*,int)")
slot32 = vtable_thunk(166, "bool(__thiscall*)(void*)")
slot33 = vtable_thunk(483, "float(__thiscall*)(void*)")
slot34 = {
	mindmg = slot22("RAGE", "Aimbot", "Minimum damage"),
	dormantEsp = slot22("VISUALS", "Player ESP", "Dormant")
}
slot35 = ui.new_checkbox("RAGE", "Aimbot", "Dormant aimbot")

for slot40 = 1, 26 do
end

slot37 = {
	dormantKey = slot21("RAGE", "Aimbot", "Dormant aimbot", true),
	dormantHitboxes = ui.new_multiselect("RAGE", "Aimbot", "Dormant target hitbox", "Head", "Chest", "Stomach", "Legs"),
	dormantAccuracy = ui.new_slider("RAGE", "Aimbot", "Dormant aimbot accuracy", 50, 100, 90, true, "%", 1),
	dormantMindmg = ui.new_slider("RAGE", "Aimbot", "Dormant minimum damage", 0, 126, 10, true, nil, 1, {
		[0] = "Inherited",
		[100 + slot40] = "HP + " .. slot40
	}),
	dormantLogs = ui.new_checkbox("RAGE", "Other", "Log dormant shots"),
	dormantIndicator = ui.new_checkbox("RAGE", "Other", "Dormant aimbot indicator")
}
slot38 = {
	"generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"?",
	"gear"
}
slot39 = {
	"",
	"Head",
	"Chest",
	"Stomach",
	"Chest",
	"Chest",
	"Legs",
	"Legs",
	"Head",
	"",
	""
}

function slot40(slot0, slot1, slot2)
	slot3, slot4 = slot0:to(slot1):angles()
	slot4 = math.rad(slot4 + 90)
	slot5 = uv0(math.cos(slot4), math.sin(slot4), 0) * slot2
	slot6 = uv0(0, 0, slot2)

	return {
		{
			text = "Middle",
			vec = slot1
		},
		{
			text = "Left",
			vec = slot1 + slot5
		},
		{
			text = "Right",
			vec = slot1 - slot5
		}
	}
end

function slot41(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

function slot42(slot0, slot1)
	if slot1 <= 0 or math.sqrt(slot0.forwardmove * slot0.forwardmove + slot0.sidemove * slot0.sidemove) <= 0 then
		return
	end

	if slot0.in_duck == 1 then
		slot1 = slot1 * 2.94117647
	end

	if slot2 <= slot1 then
		return
	end

	slot3 = slot1 / slot2
	slot0.forwardmove = slot0.forwardmove * slot3
	slot0.sidemove = slot0.sidemove * slot3
end

function slot43()
	slot0 = {}

	for slot5 = 1, globals.maxplayers() do
		if uv1(uv0(), "m_bConnected", slot5) == 1 then
			if uv2(slot5, "Add to whitelist") then
				-- Nothing
			elseif entity.is_dormant(slot5) and entity.is_enemy(slot5) then
				slot0[#slot0 + 1] = slot5
			end
		end
	end

	return slot0
end

slot44 = 0
slot45 = {}
slot46 = {
	{
		scale = 5,
		hitbox = "Stomach",
		vec = slot29(0, 0, 40)
	},
	{
		scale = 6,
		hitbox = "Chest",
		vec = slot29(0, 0, 50)
	},
	{
		scale = 3,
		hitbox = "Head",
		vec = slot29(0, 0, 58)
	},
	{
		scale = 4,
		hitbox = "Legs",
		vec = slot29(0, 0, 20)
	}
}
slot47 = 1
slot48, slot49, slot50, slot51, slot52 = nil
slot53 = false

function slot54(slot0)
	if not uv0(uv1) then
		return
	end

	if not uv0(uv2.dormantKey) then
		return
	end

	if not uv4(uv3()) then
		return
	end

	if not uv5(slot2) or not uv6(slot3) then
		return
	end

	if not uv7(slot3) then
		return
	end

	slot5 = uv8(uv9())
	slot6 = uv10(slot1, "m_flSimulationTime")
	slot8 = uv11(slot2)
	slot9 = uv10(slot1, "m_bIsScoped") == 1
	slot10 = bit.band(uv10(slot1, "m_fFlags"), bit.lshift(1, 0))

	if globals.tickcount() % #uv12() ~= 0 then
		uv13 = uv13 + 1
	else
		uv13 = 1
	end

	if not slot11[uv13] then
		uv14 = {}

		return
	end

	if slot7 < uv15 then
		uv14 = {}

		return
	end

	if slot8.type == "grenade" or slot8.type == "knife" then
		uv14 = {}

		return
	end

	if slot0.in_jump == 1 and slot10 == 0 then
		uv14 = {}

		return
	end

	slot14 = {}
	slot15 = uv0(uv2.dormantAccuracy)

	if (uv0(uv2.dormantMindmg) == 0 and uv0(uv16.mindmg) or uv0(uv2.dormantMindmg)) > 100 then
		slot17 = slot17 - 100 + entity.get_esp_data(slot13).health
	end

	slot18 = uv0(uv2.dormantHitboxes)

	for slot22, slot23 in ipairs(uv17) do
		if #slot18 ~= 0 then
			if uv18(slot18, slot23.hitbox) then
				table.insert(slot14, {
					vec = slot23.vec,
					scale = slot23.scale,
					hitbox = slot23.hitbox
				})
			end
		else
			table.insert(slot14, 1, {
				vec = slot23.vec,
				scale = slot23.scale,
				hitbox = slot23.hitbox
			})
		end
	end

	slot19 = nil

	if not (slot8.is_revolver and uv10(slot2, "m_flNextPrimaryAttack") < slot6 or uv19(uv10(slot1, "m_flNextAttack"), uv10(slot2, "m_flNextPrimaryAttack"), uv10(slot2, "m_flNextSecondaryAttack")) < slot6) then
		return
	end

	slot21, slot22, slot23, slot24, slot25 = entity.get_bounding_box(slot13)
	uv14[slot13] = nil

	if uv8(entity.get_origin(slot13)).x and slot25 > 0 then
		if not (slot15 < math.floor(slot25 * 100) + 5) then
			return
		end

		slot27, slot28, slot29 = nil

		for slot33, slot34 in ipairs(slot14) do
			for slot40, slot41 in ipairs(uv20(slot5, slot20 + slot34.vec, slot34.scale)) do
				slot42 = slot41.vec
				slot43, slot44 = uv21(slot1, slot5.x, slot5.y, slot5.z, slot42.x, slot42.y, slot42.z, true)

				if slot44 ~= 0 and slot17 < slot44 then
					slot27 = slot42
					slot28 = slot44
					uv22 = slot34.hitbox
					uv23 = slot41.text
					uv24 = slot13
					uv25 = slot25

					break
				end
			end

			if slot27 and slot28 then
				break
			end
		end

		if not slot28 then
			return
		end

		if not slot27 then
			return
		end

		if uv26(slot27.x, slot27.y, slot27.z) then
			return
		end

		uv27(slot0, (slot9 and slot8.max_player_speed_alt or slot8.max_player_speed) * 0.33)

		slot30, slot31 = slot5:to(slot27):angles()

		if not slot9 and slot8.type == "sniperrifle" and slot0.in_jump == 0 and slot10 == 1 then
			slot0.in_attack2 = 1
		end

		uv14[slot13] = true

		if slot4 < 0.01 then
			slot0.pitch = slot30
			slot0.yaw = slot31
			slot0.in_attack = 1
			uv28 = true
		end
	end
end

client.register_esp_flag("DA", 255, 255, 255, function (slot0)
	if ui.get(uv0) and entity.is_alive(uv1()) then
		return uv2[slot0]
	end
end)
client.set_event_callback("weapon_fire", function (slot0)
	client.delay_call(0.03, function ()
		if client.userid_to_entindex(uv0.userid) == entity.get_local_player() then
			if uv1 and not uv2 then
				client.fire_event("dormant_miss", {
					userid = uv3,
					aim_hitbox = uv4,
					aim_point = uv5,
					accuracy = uv6
				})
			end

			uv2 = false
			uv1 = false
			uv4 = nil
			uv5 = nil
			uv3 = nil
			uv6 = nil
		end
	end)
end)

function slot55(slot0)
	slot1 = client.userid_to_entindex(slot0.userid)
	slot3, slot4, slot5, slot6, slot7 = entity.get_bounding_box(client.userid_to_entindex(slot0.userid))

	if client.userid_to_entindex(slot0.attacker) == entity.get_local_player() and slot1 ~= nil and entity.is_dormant(slot1) and uv0 == true then
		uv1 = true

		client.fire_event("dormant_hit", {
			userid = slot1,
			attacker = slot2,
			health = slot0.health,
			armor = slot0.armor,
			weapon = slot0.weapon,
			dmg_health = slot0.dmg_health,
			dmg_armor = slot0.dmg_armor,
			hitgroup = slot0.hitgroup,
			accuracy = slot7,
			aim_hitbox = uv2
		})
	end
end

function slot56()
	uv0 = uv1() + (cvar.mp_freezetime:get_float() + 1) / globals.tickinterval()
end

slot23(slot35, function ()
	slot1 = uv0(uv1) and client.set_event_callback or client.unset_event_callback

	if slot0 then
		ui.set(uv2.dormantEsp, slot0)
	end

	slot1("setup_command", uv3)
	slot1("round_prestart", uv4)
	slot1("player_hurt", uv5)
	uv6()
end)
function ()
	for slot4, slot5 in pairs(uv1) do
		ui.set_visible(slot5, ui.get(uv0))
	end
end()
client.set_event_callback("paint", function ()
	slot0 = ({
		uv0(uv1.dormantKey)
	})[2]

	if not uv2(uv3()) then
		return
	end

	if uv0(uv4) and uv0(uv1.dormantKey) and uv0(uv1.dormantIndicator) then
		slot1 = {
			255,
			255,
			255,
			200
		}

		for slot5, slot6 in pairs(uv5) do
			if slot6 then
				slot1 = {
					143,
					194,
					21,
					255
				}

				break
			end
		end

		if #uv6() == 0 then
			slot1 = {
				255,
				0,
				50,
				255
			}
		end

		uv7(slot1[1], slot1[2], slot1[3], slot1[4], "DA")
	end
end)
client.set_event_callback("dormant_hit", function (slot0)
	if uv0(uv1.dormantLogs) then
		if uv2[slot0.hitgroup + 1] == slot0.aim_hitbox or uv3 == "Head" then
			print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) (%s accuracy)", entity.get_player_name(slot0.userid), uv4[slot0.hitgroup + 1], slot0.dmg_health, slot0.health, string.format("%.0f", slot0.accuracy * 100) .. "%"))
		else
			print(string.format("[DA] Hit %s in the %s for %i damage (%i health remaining) aimed=%s (%s accuracy)", slot1, uv4[slot0.hitgroup + 1], slot0.dmg_health, slot0.health, slot0.aim_hitbox, string.format("%.0f", slot0.accuracy * 100) .. "%"))
		end
	end
end)
client.set_event_callback("dormant_miss", function (slot0)
	if uv0(uv1.dormantLogs) then
		print(string.format("[DA] Missed %s's %s (mp=%s) (%s accuracy)", entity.get_player_name(slot0.userid), uv2, uv3, string.format("%.0f", slot0.accuracy * 100) .. "%"))
	end
end)
