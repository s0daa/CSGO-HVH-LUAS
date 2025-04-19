slot0 = require("bit")
slot1 = require("vector")
slot2 = require("gamesense/uilib")
slot3 = require("gamesense/entity")
slot5 = renderer.text
slot6 = slot3.get_local_player
slot7 = slot3.get_player_resource
slot8 = globals.maxplayers
slot9 = client.camera_angles
slot10 = client.register_esp_flag
slot12 = ui.get
slot13 = plist.get
slot14 = math.cos
slot15 = math.sin
slot16 = math.rad
slot17 = math.sqrt
slot18 = math.acos
slot19 = math.max
slot20 = math.ceil
slot21 = {}
slot22 = 1
slot23, slot24, slot25, slot26 = nil
slot27 = {
	bullet = require("gamesense/images").get_panorama_image("icons/ui/bullet.svg")
}
slot28 = {
	"Helmet",
	"Kevlar",
	nil,
	"Helmet + Kevlar",
	nil,
	nil,
	nil,
	"Zoom",
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	"Blind",
	[2048.0] = "Hit",
	[256.0] = "Defuse",
	[4096.0] = "Occluded",
	[32.0] = "Reload",
	[64.0] = "Bomb",
	[8192.0] = "Exploiter",
	[128.0] = "Vip",
	[131072.0] = "Defensive dt",
	[1024.0] = "Pin pulled",
	[512.0] = "Fakeduck"
}
slot29 = {
	min_dmg = slot2.reference("rage", "aimbot", "minimum damage"),
	min_dmg_ovr = {
		slot2.reference("rage", "aimbot", "minimum damage override")
	},
	dpi = slot2.reference("misc", "settings", "dpi scale"),
	name = {
		slot2.reference("visuals", "player esp", "name")
	},
	weapon_text = {
		slot2.reference("visuals", "player esp", "weapon text")
	},
	weapon_icon = {
		slot2.reference("visuals", "player esp", "weapon icon")
	}
}
slot30 = nil

if pcall(function ()
	uv0("visuals", "player esp", "show nades")
end) then
	slot30 = ui.reference("visuals", "player esp", "show nades")
end

slot32 = "808080c8»" .. "dcdcdcff"
slot33 = "visuals"
slot34 = "player esp"
slot35 = {
	enabled = slot2.new_checkbox(slot33, slot34, "Show lethality"),
	options = slot2.new_multiselect(slot33, slot34, "\nlethality_options", {
		"Lethal flag",
		"Force flag",
		"Bullet icon",
		"Force body aim"
	}),
	only_closest = slot2.new_checkbox(slot33, slot34, "Lethal " .. slot32 .. " Limit to closest to crosshair"),
	move_icon = slot2.new_combobox(slot33, slot34, "Lethal " .. slot32 .. " Icon position", {
		"Default",
		"Above name",
		"Below weapons",
		"Next to health",
		"Top left",
		"Top right",
		"Bottom left",
		"Bottom right"
	}),
	force = slot2.new_slider(slot33, slot34, "Lethal " .. slot32 .. " Force body aim shots", 1, 5, 1, true, "x", 1, {
		[1.0] = "Lethal"
	})
}

function slot36(slot0)
	if uv0(slot0.x * slot0.x + slot0.y * slot0.y + slot0.z * slot0.z) == 0 then
		return uv1(0, 0, 0)
	end

	slot2 = 1 / slot1

	return uv1(slot0.x * slot2, slot0.y * slot2, slot0.z * slot2)
end

function slot37(slot0, slot1, slot2)
	return 180 / math.pi * uv2(uv0(uv1(slot0.x - slot1.x, slot0.y - slot1.y, 0)):dot(slot2))
end

function slot38(slot0, slot1, slot2)
	for slot7 = 1, uv1() do
		if uv0():get_prop("m_bConnected", slot7) and uv2.new(slot7) and (not slot0:find("A") or slot8:is_alive()) and (not slot0:find("D") or not slot8:is_dormant()) and (not slot0:find("E") or slot8:is_enemy()) then
			slot1(slot8)
		elseif slot2 then
			slot2(slot7)
		end
	end
end

function slot39(slot0, slot1, slot2, slot3, slot4)
	slot5 = {}

	for slot9 = slot1 + 1, slot2 + slot1, slot3 do
		slot10 = uv0(slot9)
		slot5[#slot5 + 1] = uv1(slot4 * uv2(slot10) + slot0.x, slot4 * uv3(slot10) + slot0.y, slot0.z)
	end

	return slot5
end

function slot40(slot0)
	for slot5, slot6 in pairs(slot0) do
		slot1 = 0 + 1
	end

	return slot1
end

function slot3.has_nade(slot0)
	if slot0 == nil then
		return false
	end

	if slot0:get_player_weapon() == nil then
		return false
	end

	if slot1:get_classname() == "CSmokeGrenade" or slot2 == "CHEGrenade" or slot2 == "CMolotovGrenade" or slot2 == "CFlashGrenade" or slot2 == "CDecoyGrenade" or slot2 == "CIncendiaryGrenade" then
		return true
	end

	return false
end

function slot3.has_short_range_weapon(slot0)
	if slot0 == nil then
		return false
	end

	if slot0:get_player_weapon() == nil then
		return false
	end

	if slot1:get_classname() == "CKnife" or slot2 == "CWeaponTaser" or slot0:has_nade() then
		return true
	end

	return false
end

slot41 = {
	setup_command = function (slot0)
		if uv0() == nil or slot1:has_short_range_weapon() or not slot1:is_alive() then
			uv1.targets = {}

			return
		end

		if slot0.chokedcommands > 0 then
			return
		end

		uv1.targets = {}
		slot2 = uv2.min_dmg()

		if uv2.min_dmg_ovr[1]() and uv2.min_dmg_ovr[2]() then
			slot2 = uv2.min_dmg_ovr[3]()
		end

		slot3 = {
			uv3()
		}
		slot5 = {
			uv5,
			fov = math.huge
		}
		slot6 = uv4():init_from_angles(unpack(slot3))
		slot7 = uv6(uv4(slot1:get_origin()) + uv4(0, 0, 56), slot3[2] + 90, 180, 40, 40)

		if uv7.only_closest() then
			uv8("ADE", function (slot0)
				if uv0(uv1(slot0:get_origin()), uv2, uv3) < uv4.fov then
					uv4 = {
						entity = slot0,
						fov = slot1
					}
				end
			end)
		end

		uv8("ADE", function (slot0)
			if slot0 == nil then
				return
			end

			if uv0.entity == nil or uv0.entity == slot0 then
				if not uv1.targets[slot0:get_entindex()] then
					uv1.targets[slot1] = {
						dmg = 0,
						is = false,
						bullets = 0,
						entity = slot0
					}
				end

				slot2 = uv2(slot0:hitbox_position(5))
				slot3 = slot0:get_prop("m_iHealth")

				for slot7, slot8 in ipairs(uv3) do
					slot9, slot10 = uv4:trace_bullet(slot8.x, slot8.y, slot8.z, slot2.x, slot2.y, slot2.z)

					if slot10 ~= nil and (uv5 < slot10 or slot3 < slot10) then
						uv1.targets[slot1].dmg = slot10
					end
				end

				uv1.targets[slot1].bullets = uv6(1, uv7(slot3 / uv1.targets[slot1].dmg, 0))
				uv1.targets[slot1].is = slot3 < uv1.targets[slot1].dmg

				if uv8 then
					slot0:plist_set("Override prefer body aim", uv1.targets[slot1].bullets <= uv9.force() and "Force" or "-")
				end
			end
		end)
	end,
	paint = function ()
		if not uv0() or not slot0:is_alive() or uv1.targets == nil then
			return
		end

		slot1 = uv2.move_icon()
		uv3 = tonumber(uv4.dpi():sub(1, 3)) * 0.01

		if uv5 then
			for slot5, slot6 in pairs(uv1.targets) do
				if slot6.entity ~= nil and slot6.entity:is_alive() ~= false then
					if slot6.dmg <= 0 then
						-- Nothing
					elseif ({
						slot6.entity:get_bounding_box()
					})[1] ~= nil then
						slot8 = uv6(0, 0)

						if slot1 == "Default" then
							for slot14 = 0, uv7(uv8) do
								if uv9.band(slot6.entity:get_esp_data().flags, uv9.lshift(1, slot14)) ~= 0 then
									slot10 = 0 + 1
								end
							end

							slot8 = uv6(slot7[3], slot7[2]) + uv6(2, slot10 * 8)
						else
							if slot1 == "Above name" then
								if uv10 and uv11(uv10) then
									slot9 = 16 + 10
								end

								if uv4.name[1]() then
									slot9 = slot9 + 10
								end
							elseif slot1 == "Below weapons" then
								if uv4.weapon_icon[1]() then
									slot9 = 8 + 15
								end

								if uv4.weapon_text[1]() then
									slot9 = slot9 + 8
								end
							end

							slot8.x, slot8.y = unpack(({
								["Above name"] = {
									(slot7[1] + slot7[3]) * 0.5 - 8 * uv3,
									slot7[2] - slot9 * uv3
								},
								["Below weapons"] = {
									(slot7[1] + slot7[3]) * 0.5 - 8 * uv3,
									slot7[4] + slot9 * uv3
								},
								["Next to health"] = {
									slot7[1] - 24,
									(slot7[2] + slot7[4]) * 0.5 - 8 * uv3
								},
								["Top left"] = {
									slot7[1] - 24 * uv3,
									slot7[2] - 14 * uv3
								},
								["Top right"] = {
									slot7[3] + 6 * uv3,
									slot7[2] - 14 * uv3
								},
								["Bottom left"] = {
									slot7[1] - 16 * uv3,
									slot7[4]
								},
								["Bottom right"] = {
									slot7[3],
									slot7[4]
								}
							})[slot1])
						end

						uv12(slot8.x + 6 * uv3, slot8.y + 5 * uv3, 220, 220, 220, 255 * slot7[5], "d-", 0, "x" .. slot6.bullets)
						uv13.bullet:draw(slot8.x + 1, slot8.y + 4, 12 * uv3, 10 * uv3, 0, 0, 0, 255 * slot7[5])
						uv13.bullet:draw(slot8.x, slot8.y + 3, 12 * uv3, 10 * uv3, 220, 220, 220, 255 * slot7[5])
					end
				end
			end
		end
	end
}

slot10("-", 255, 0, 0, function (slot0)
	if not uv0.enabled() or not uv1 then
		return false
	end

	if uv2.targets == nil then
		return false
	end

	if uv2.targets[slot0] == nil then
		return false
	end

	return tostring(slot1.bullets) ~= "inf", slot1.bullets <= 1 and "L" or "x" .. slot1.bullets
end)
slot10("B", 255, 255, 255, function (slot0)
	if not uv0.enabled() or not uv1 then
		return false
	end

	return uv2(slot0, "Override prefer body aim") == "Force"
end)

function slot42()
	slot0 = uv0.enabled()
	uv4 = uv0.options:contains("Force body aim")
	uv3 = uv0.options:contains("Bullet icon")
	uv2 = uv0.options:contains("Force flag")
	uv1 = uv0.options:contains("Lethal flag")
	uv0.options.vis = slot0
	uv0.only_closest.vis = slot0
	uv0.move_icon.vis = slot0 and uv0.options:contains("Bullet icon")
	uv0.force.vis = slot0 and uv0.options:contains("Force body aim")
end

slot35.enabled:add_callback(slot42)
slot35.options:add_callback(slot42)
slot35.enabled:add_event_callback("paint", slot41.paint)
slot35.enabled:add_event_callback("setup_command", slot41.setup_command)
slot35.enabled:invoke()

slot43 = {
	get_data = function ()
		return uv0.targets
	end
}

package.preload["gamesense/lethality"] = function ()
	return uv0
end
