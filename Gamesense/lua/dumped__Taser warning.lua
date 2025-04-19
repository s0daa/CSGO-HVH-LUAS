slot0 = entity.get_classname
slot1 = require("vector")
slot2 = require("gamesense/entity")
slot3 = require("gamesense/uilib")
slot5 = renderer.text
slot6 = renderer.texture
slot7 = renderer.measure_text
slot8 = slot2.get_players
slot9 = slot2.get_local_player
slot10 = globals.curtime
slot11 = table.unpack
slot12 = math.abs
slot13 = math.sin
slot14 = renderer.load_svg("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#ffffff\" fill-rule=\"evenodd\"></path></g></svg>", 150, 150)
slot15 = {}
slot16 = 1
slot17 = "visuals"
slot18 = "player esp"
slot19 = {
	enabled = slot3.new_combobox(slot17, slot18, "Taser warning", {
		"Off",
		"Icon",
		"Text",
		"Short text"
	}),
	clr = slot3.new_color_picker(slot17, slot18, "zeus_clr", 220, 220, 220, 255),
	clr2 = slot3.new_color_picker(slot17, slot18, "zeus_clr2", 230, 210, 20, 255),
	range_clr = slot3.new_checkbox(slot17, slot18, "Change color for in-range"),
	clr3 = slot3.new_color_picker(slot17, slot18, "zeus_clr3", 220, 50, 50, 255),
	dpi = slot3.reference("misc", "settings", "dpi scale")
}

function slot20(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot1 == slot6 then
			return true
		end
	end

	return false
end

function slot21(slot0)
	return uv0(uv1(uv2() * slot0))
end

function slot2.get_all_weapons(slot0)
	slot1 = {}

	for slot5 = 0, 64 do
		if slot0:get_prop("m_hMyWeapons", slot5) ~= nil then
			slot1[#slot1 + 1] = uv0(slot6)
		end
	end

	return slot1
end

slot22 = {
	Icon = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0(uv1, slot0 - 12 * uv2, slot1, slot2, slot3, slot4, slot5, slot6, slot7, "f")
	end,
	Text = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0(slot0, slot1, slot4, slot5, slot6, slot7, "rd-", 0, "ZEUS")
	end,
	["Short text"] = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6, slot7)
		uv0(slot0, slot1, slot4, slot5, slot6, slot7, "rd-", 0, "Z")
	end
}

function slot24()
	slot0 = uv0.enabled() ~= "Off"
	uv0.clr3.vis = slot0
	uv0.range_clr.vis = slot0
end

for slot28, slot29 in pairs({
	net_update_end = function ()
		uv1 = {}

		for slot4, slot5 in pairs(uv0(true)) do
			if not slot5:is_alive() then
				return
			end

			if uv2(slot5:get_all_weapons(), "CWeaponTaser") then
				uv1[slot4] = slot5
			end
		end
	end,
	paint = function ()
		if uv0() == nil or slot0:is_alive() == false then
			return
		end

		if uv1(slot0:get_origin()).x == 0 then
			return
		end

		slot2 = {
			{
				uv2.clr()
			},
			{
				uv2.clr2()
			},
			{
				uv2.clr3()
			}
		}
		slot3 = uv2.range_clr()
		slot4 = uv3[uv2.enabled()]

		for slot8, slot9 in pairs(uv4) do
			if ({
				slot9:get_bounding_box()
			})[1] == nil then
				-- Nothing
			elseif slot9:get_player_weapon() == nil then
				-- Nothing
			elseif uv1(slot9:get_origin()).x ~= 0 then
				slot13 = slot1:dist2d(slot12)
				slot14, slot15, slot16, slot17 = uv5(slot2[1])

				if slot11:get_classname() == "CWeaponTaser" then
					slot14, slot15, slot16, slot17 = uv5(slot2[2])
				end

				if slot13 < 190 then
					if slot3 then
						slot14, slot15, slot16, slot17 = uv5(slot2[3])
					end

					slot17 = slot17 * uv6(8)
				end

				slot4(slot10[1] - 10, slot10[2], 20 * uv7, 20 * uv7, slot14, slot15, slot16, slot17 * slot10[5])
			end
		end
	end,
	round_start = function ()
		uv0 = {}
	end
}) do
	slot19.enabled:add_event_callback(slot28, slot29, function (slot0)
		return slot0() ~= "Off"
	end)
end

slot19.enabled:add_callback(slot24)
slot19.enabled:invoke()
slot19.dpi:add_callback(function (slot0)
	uv0 = tonumber(slot0():sub(1, 3)) * 0.01
end)
slot19.dpi:invoke()
