slot0 = require("gamesense/csgo_weapons")
slot1 = require("gamesense/images")
slot2 = ui.new_checkbox("VISUALS", "Player ESP", "Show nades")
slot3 = ui.new_color_picker("VISUALS", "Player ESP", "Show nades", 255, 255, 255, 200)
slot4 = ui.new_slider("VISUALS", "Player ESP", "\nNade offset", 0, 20, 0, true, "px", 1, {
	[0] = "Off"
})
slot5 = ui.reference("misc", "Settings", "DPI scale")
slot6 = {
	["125%"] = 1.25,
	["100%"] = 1,
	["200%"] = 2,
	["175%"] = 1.75,
	["150%"] = 1.5
}

function slot7(slot0, slot1)
	slot2 = 10^(slot1 or 0)

	return math.floor(slot0 * slot2 + 0.5) / slot2
end

function slot8(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

function slot9(slot0)
	for slot5, slot6 in pairs(slot0) do
		slot1 = 0 + slot6
	end

	return slot1 / #slot0
end

slot10 = {}

client.set_event_callback("level_init", function ()
	uv0 = {}
end)
client.set_event_callback("player_death", function (slot0)
	uv0[client.userid_to_entindex(slot0.userid)] = {}
end)
client.set_event_callback("player_spawn", function (slot0)
	uv0[client.userid_to_entindex(slot0.userid)] = {}
end)

slot11 = {
	"weapon_molotov",
	"weapon_smokegrenade",
	"weapon_hegrenade",
	"weapon_incgrenade"
}
slot12 = {
	weapon_hegrenade = "nade",
	weapon_smokegrenade = "smoke",
	weapon_molotov = "moly",
	weapon_incgrenade = "incin"
}
slot13 = {
	moly = slot1.get_weapon_icon(slot11[1]),
	smoke = slot1.get_weapon_icon(slot11[2]),
	nade = slot1.get_weapon_icon(slot11[3]),
	incin = slot1.get_weapon_icon(slot11[4])
}
slot14 = {
	weapon_hegrenade = 1,
	weapon_smokegrenade = 3,
	weapon_molotov = 2,
	weapon_incgrenade = 2
}
slot15 = {
	nade = {
		slot17:measure(nil, 12)
	},
	smoke = {
		slot17:measure(nil, 12)
	},
	moly = {
		slot17:measure(nil, 12)
	},
	incin = {
		slot17:measure(nil, 12)
	}
}
slot17 = slot13.nade
slot17 = slot13.smoke
slot17 = slot13.moly
slot17 = slot13.incin

client.set_event_callback("item_remove", function (slot0)
	slot1 = client.userid_to_entindex(slot0.userid)
	slot2 = entity.get_player_name(slot1)

	if entity.is_enemy(slot1) then
		if uv0[slot1] ~= nil then
			slot4 = {}

			for slot8, slot9 in ipairs(uv0[slot1]) do
				if slot9 == "weapon_" .. slot0.item then
					slot3 = "nothin"
				else
					table.insert(slot4, slot9)
				end
			end

			uv0[slot1] = slot4
		else
			uv0[slot1] = {}
		end
	end
end)
client.set_event_callback("item_pickup", function (slot0)
	slot1 = client.userid_to_entindex(slot0.userid)
	slot2 = entity.get_player_name(slot1)

	if entity.is_enemy(slot1) then
		if uv0[slot1] == nil then
			uv0[slot1] = {}
		end

		if uv1(uv2, "weapon_" .. slot0.item) then
			table.insert(uv0[slot1], slot3)
		end
	end
end)
client.set_event_callback("paint", function ()
	slot0 = uv0[ui.get(uv1)]
	slot1 = false
	slot2 = entity.get_local_player()
	slot3 = entity.get_prop(slot2, "m_iObserverMode")

	if not entity.is_alive(slot2) and (slot3 == 4 or slot3 == 5) and entity.is_enemy(entity.get_prop(slot2, "m_hObserverTarget")) then
		slot1 = true
	end

	for slot8 = 1, globals.maxplayers() do
		if entity.get_prop(entity.get_player_resource(), "m_bConnected", slot8) == 1 and (entity.is_enemy(slot8) and not slot1 or not entity.is_enemy(slot8) and slot1) then
			if uv2[slot8] == nil then
				uv2[slot8] = {}
			end

			if entity.is_alive(slot8) then
				if not entity.is_dormant(slot8) then
					slot9 = {}

					for slot13 = 0, 64 do
						if entity.get_prop(slot8, "m_hMyWeapons", slot13) ~= nil and uv3(slot14) ~= nil and slot15.type == "grenade" and slot15.console_name ~= "weapon_flashbang" and slot15.console_name ~= "weapon_decoy" then
							table.insert(slot9, slot15.console_name)
						end
					end

					uv2[slot8] = slot9
				end

				if #uv2[slot8] > 0 and ui.get(uv4) then
					slot9, slot10, slot11, slot12, slot13 = entity.get_bounding_box(slot8)

					if slot13 == nil then
						slot13 = 1
					end

					if slot9 ~= nil and slot13 ~= 0 then
						if #uv2[slot8] > 1 then
							table.sort(slot14, function (slot0, slot1)
								return (uv0[slot0] ~= nil and uv0[slot0] or 0) < (uv0[slot1] ~= nil and uv0[slot1] or 0)
							end)
						end

						slot15 = slot9 + math.floor((slot11 - slot9) / 2)
						slot16, slot17 = renderer.measure_text("d", "qgftTyiOOPp")
						slot18, slot19, slot20, slot21 = ui.get(uv6)

						if entity.is_dormant(slot8) then
							slot22 = uv7(uv8({
								slot18,
								slot19,
								slot20
							})) * 0.75
							slot18 = slot22
							slot20 = slot22
							slot19 = slot22
						end

						slot22 = slot21 * slot13

						for slot27, slot28 in pairs(slot14) do
							if slot27 ~= #slot14 then
								slot23 = 0 + uv10[uv9[slot28]][1] * slot0 + 4 * slot0
							end
						end

						slot24 = 0

						for slot28, slot29 in pairs(slot14) do
							slot30 = uv9[slot29]

							uv11[slot30]:draw(uv7(slot15 - math.floor(slot23 / 2) + slot24), slot10 - slot17 - ui.get(uv12) - uv10[slot30][2] * slot0, uv10[slot30][1] * slot0, uv10[slot30][2] * slot0, slot18, slot19, slot20, slot22)

							if slot28 ~= #slot14 then
								slot24 = slot24 + uv10[slot30][1] * slot0 + 4 * slot0
							end
						end
					end
				end
			end
		end
	end
end)
