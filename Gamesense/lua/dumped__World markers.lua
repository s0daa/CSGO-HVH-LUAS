slot0 = require("vector")
slot1 = require("gamesense/uilib")
slot2 = require("gamesense/entity")
slot3 = require("gamesense/images")
slot4 = renderer.world_to_screen
slot5 = renderer.text
slot6 = renderer.line
slot7 = renderer.circle_outline
slot8 = slot2.get_local_player
slot9 = slot2.new_from_userid
slot10 = globals.realtime
slot11 = globals.frametime
slot12 = globals.tickcount
slot13 = math.min
slot14 = math.max
slot15 = math.cos
slot16 = math.pi
slot17, slot18, slot19, slot20 = nil
slot21 = "cd"
slot22 = 1
slot23 = {}
slot24 = {}
slot25 = {}
slot26 = "World markers 808080c8»dcdcdcff "
slot27 = "visuals"
slot28 = "effects"

function slot30(slot0, slot1, slot2)
	return slot0 + (slot1 - slot0) * slot2
end

function slot31(slot0, slot1, slot2)
	return uv0(slot2, uv1(slot1, slot0))
end

function slot32(slot0, slot1, slot2, slot3)
	return -slot2 * uv0(slot0 / slot3 * uv1 / 2) + slot2 + slot1
end

function slot33(slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot2 = slot2 * 0.5
	slot7 = slot2 * 0.5

	uv0(slot0 - slot2, slot1 - slot2, slot0 - slot7, slot1 - slot7, slot3, slot4, slot5, slot6)
	uv0(slot0 + slot2, slot1 + slot2, slot0 + slot7, slot1 + slot7, slot3, slot4, slot5, slot6)
	uv0(slot0 - slot2, slot1 + slot2, slot0 - slot7, slot1 + slot7, slot3, slot4, slot5, slot6)
	uv0(slot0 + slot2, slot1 - slot2, slot0 + slot7, slot1 - slot7, slot3, slot4, slot5, slot6)
end

slot34 = {
	["prediction error"] = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0.get_panorama_image("icons/ui/warning.svg"):draw(slot0 - slot2 / 2, slot1 - slot3 / 2, slot2, slot3, slot4, slot5, slot6, slot7)
	end,
	["unregistered shot"] = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0(slot0, slot1, slot4, slot5, slot6, slot7, "bcd", 0, "X")
	end,
	death = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0.get_panorama_image("hud/voicestatus/skull.png"):draw(slot0 - slot2 / 2, slot1 - slot3 / 2, slot2, slot3, slot4, slot5, slot6, slot7)
	end,
	spread = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8)
		uv1(slot0, slot1, slot4, slot5, slot6, slot7 * uv0(slot8, 0, -1, 2), slot2 * 0.2 * slot8, 0, 1, 1)
	end,
	unknown = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0(slot0, slot1, slot4, slot5, slot6, slot7, "bcd", 0, "?")
	end
}

({
	enabled = slot1.new_checkbox(slot27, slot28, "World markers"),
	miss_clr = slot1.new_color_picker(slot27, slot28, "world_hm_miss_clr", 230, 210, 20, 255),
	options = slot1.new_multiselect(slot27, slot28, "\nworld_hm_options", {
		"Cross",
		"Damage",
		"Misses",
		"Damage 808080c8»dcdcdcff Dynamic color"
	}),
	time = slot1.new_slider(slot27, slot28, slot26 .. "Time", 1, 200, 50, true, "s", 0.1),
	cross_size = slot1.new_slider(slot27, slot28, slot26 .. "Cross size", 1, 25, 10, true, "px"),
	cross_clr = slot1.new_color_picker(slot27, slot28, "world_hm_cross_clr", 220, 220, 220, 255),
	dmg_font = slot1.new_combobox(slot27, slot28, slot26 .. "Damage text", {
		"Default",
		"Big",
		"Small",
		"Bold"
	}),
	dmg_clr1 = slot1.new_color_picker(slot27, slot28, "world_hm_dmg_clr", 165, 220, 15, 255),
	dmg_clr2 = slot1.new_color_picker(slot27, slot28, "world_hm_dmg_clr2", 220, 50, 50, 255),
	dpi = slot1.reference("misc", "settings", "dpi scale")
}).enabled:add_callback(function ()
	slot0 = uv0.enabled()
	slot1 = uv0.dmg_font()
	uv4 = uv0.options:contains("Damage 808080c8»dcdcdcff Dynamic color")
	uv3 = uv0.options:contains("Misses")
	uv2 = uv0.options:contains("Damage")
	uv1 = uv0.options:contains("Cross")
	uv0.time.vis = slot0 and (uv1 or uv2)
	uv0.options.vis = slot0
	uv0.miss_clr.vis = slot0 and uv3
	uv0.cross_clr.vis = slot0 and uv1
	uv0.cross_size.vis = slot0 and uv1
	uv0.dmg_clr2.vis = slot0 and uv2 and uv4
	uv0.dmg_clr1.vis = slot0 and uv2
	uv0.dmg_font.vis = slot0 and uv2
	uv5 = slot1 == "Big" and "cd+" or slot1 == "Small" and "cd-" or slot1 == "Bold" and "bcd" or "cd"
end)

for slot40, slot41 in pairs({
	bullet_impact = function (slot0)
		if uv0() == nil then
			return
		end

		slot3 = uv2()

		if uv1(slot0.userid) == slot1 then
			if #uv3 > 150 and uv3[#uv3].tick ~= slot3 then
				uv3 = {}
			end

			uv3[#uv3 + 1] = {
				tick = slot3,
				origin = uv4(slot0.x, slot0.y, slot0.z)
			}
		end
	end,
	player_hurt = function (slot0)
		if not uv0 and not uv1 then
			return
		end

		if uv2() == nil then
			return
		end

		slot3 = uv3(slot0.attacker)

		if uv3(slot0.userid) == nil or slot3 == nil or slot2 == slot1 or slot3 ~= slot1 or slot2:is_enemy() == false then
			return
		end

		if uv4(slot2:hitbox_position(3)).x == 0 then
			return
		end

		for slot10, slot11 in ipairs(uv6) do
			if slot11.tick == uv5() and slot11.origin:dist2d(slot4) < ({
				origin = slot4,
				distance = math.huge
			}).distance then
				slot5 = {
					origin = slot11.origin,
					distance = slot12
				}
			end
		end

		uv6 = {}
		uv7[#uv7 + 1] = {
			a = 0,
			origin = slot5.origin,
			dmg = slot0.dmg_health,
			time = uv8() + uv9.time() * 0.1
		}
	end,
	aim_fire = function (slot0)
		if slot0.id >= 150 then
			uv0 = {}
		end

		uv0[slot0.id] = {
			origin = uv1(slot0.x, slot0.y, slot0.z)
		}
	end,
	aim_miss = function (slot0)
		if not uv0 then
			return
		end

		if not uv1 and not uv2 then
			return
		end

		slot1 = uv3[slot0.id]

		if uv4(slot0.target) == nil then
			return
		end

		if slot1.origin.x == 0 then
			return
		end

		uv5[#uv5 + 1] = {
			loop = 0,
			a = 0,
			origin = slot3,
			reason = slot0.reason,
			time = uv6() + uv7.time() * 0.1
		}
	end,
	paint = function ()
		slot0 = uv0()
		slot2 = {
			{
				uv2.cross_clr()
			},
			{
				uv2.dmg_clr1()
			},
			{
				uv2.dmg_clr2()
			},
			{
				uv2.miss_clr()
			}
		}
		slot3 = uv3 == "cd+" and 8 * uv4 or 4 * uv4
		slot5 = uv5 and uv2.cross_size() + slot3 or 15 + slot3

		for slot9, slot10 in pairs(uv6) do
			if slot10.time < uv1() then
				uv6[slot9] = nil
			end

			slot11, slot12 = uv7(slot10.origin:unpack())

			if slot11 ~= nil then
				if uv8 and slot10.dmg then
					slot13 = slot2[2]

					if uv9 then
						slot14 = uv10(slot10.dmg * 0.01, 0, 1)
						slot13 = {
							uv11(slot2[2][1], slot2[3][1], slot14),
							uv11(slot2[2][2], slot2[3][2], slot14),
							uv11(slot2[2][3], slot2[3][3], slot14),
							uv11(slot2[2][4], slot2[3][4], slot14)
						}
					end

					uv12(slot11, slot12 - slot5 * slot10.a, slot13[1], slot13[2], slot13[3], slot13[4] * slot10.a, uv3, 0, slot10.dmg)
				end

				if uv13 and slot10.reason then
					uv14[slot10.reason] or uv14.unknown(slot11, slot12 - 15 * slot10.a, 15, 15, slot2[4][1], slot2[4][2], slot2[4][3], slot2[4][4] * slot10.a, slot10.loop)

					if slot10.reason == "spread" then
						slot10.loop = slot10.loop < 2 and slot10.loop + slot0 * 2 or 0
					end
				end

				if uv5 then
					uv15(slot11, slot12, slot4 * slot10.a, slot2[1][1], slot2[1][2], slot2[1][3], slot2[1][4] * slot10.a)
				end

				slot10.a = uv10(slot10.a + (slot1 < slot10.time - 0.5 and slot0 * 6 or -slot0 * 6), 0, 1)
			end
		end
	end,
	round_start = function ()
		uv2 = {}
		uv1 = {}
		uv0 = {}
	end
}) do
	slot29.enabled:add_event_callback(slot40, slot41)
end

slot29.enabled:invoke()
slot29.options:add_callback(slot36)
slot29.dmg_font:add_callback(slot36)
slot29.dpi:add_callback(function (slot0)
	uv0 = tonumber(slot0():sub(1, 3)) * 0.01
end)
slot29.dpi:invoke()
