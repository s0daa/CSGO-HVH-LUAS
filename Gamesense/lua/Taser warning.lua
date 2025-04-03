local var_0_0 = entity.get_classname
local var_0_1 = require("vector")
local var_0_2 = require("gamesense/entity")
local var_0_3 = require("gamesense/uilib")
local var_0_4 = renderer.load_svg
local var_0_5 = renderer.text
local var_0_6 = renderer.texture
local var_0_7 = renderer.measure_text
local var_0_8 = var_0_2.get_players
local var_0_9 = var_0_2.get_local_player
local var_0_10 = globals.curtime
local var_0_11 = table.unpack
local var_0_12 = math.abs
local var_0_13 = math.sin
local var_0_14 = var_0_4("<svg id=\"svg\" version=\"1.1\" width=\"608\" height=\"689\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" ><g id=\"svgg\"><path id=\"path0\" d=\"M185.803 18.945 C 184.779 19.092,182.028 23.306,174.851 35.722 C 169.580 44.841,157.064 66.513,147.038 83.882 C 109.237 149.365,100.864 163.863,93.085 177.303 C 88.686 184.901,78.772 202.072,71.053 215.461 C 63.333 228.849,53.959 245.069,50.219 251.505 C 46.480 257.941,43.421 263.491,43.421 263.837 C 43.421 264.234,69.566 264.530,114.025 264.635 L 184.628 264.803 181.217 278.618 C 179.342 286.217,174.952 304.128,171.463 318.421 C 167.974 332.714,160.115 364.836,153.999 389.803 C 147.882 414.770,142.934 435.254,143.002 435.324 C 143.127 435.452,148.286 428.934,199.343 364.145 C 215.026 344.243,230.900 324.112,234.619 319.408 C 238.337 314.704,254.449 294.276,270.423 274.013 C 286.397 253.750,303.090 232.582,307.519 226.974 C 340.870 184.745,355.263 166.399,355.263 166.117 C 355.263 165.937,323.554 165.789,284.798 165.789 C 223.368 165.789,214.380 165.667,214.701 164.831 C 215.039 163.949,222.249 151.366,243.554 114.474 C 280.604 50.317,298.192 19.768,298.267 19.444 C 298.355 19.064,188.388 18.576,185.803 18.945 \" stroke=\"none\" fill=\"#ffffff\" fill-rule=\"evenodd\"></path></g></svg>", 150, 150)
local var_0_15 = {}
local var_0_16 = 1
local var_0_17 = "visuals"
local var_0_18 = "player esp"
local var_0_19 = {
	enabled = var_0_3.new_combobox(var_0_17, var_0_18, "Taser warning", {
		"Off",
		"Icon",
		"Text",
		"Short text"
	}),
	clr = var_0_3.new_color_picker(var_0_17, var_0_18, "zeus_clr", 220, 220, 220, 255),
	clr2 = var_0_3.new_color_picker(var_0_17, var_0_18, "zeus_clr2", 230, 210, 20, 255),
	range_clr = var_0_3.new_checkbox(var_0_17, var_0_18, "Change color for in-range"),
	clr3 = var_0_3.new_color_picker(var_0_17, var_0_18, "zeus_clr3", 220, 50, 50, 255),
	dpi = var_0_3.reference("misc", "settings", "dpi scale")
}

local function var_0_20(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		if arg_1_1 == iter_1_1 then
			return true
		end
	end

	return false
end

local function var_0_21(arg_2_0)
	return var_0_12(var_0_13(var_0_10() * arg_2_0))
end

function var_0_2.get_all_weapons(arg_3_0)
	local var_3_0 = {}

	for iter_3_0 = 0, 64 do
		local var_3_1 = arg_3_0:get_prop("m_hMyWeapons", iter_3_0)

		if var_3_1 ~= nil then
			var_3_0[#var_3_0 + 1] = var_0_0(var_3_1)
		end
	end

	return var_3_0
end

local var_0_22 = {
	Icon = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
		var_0_6(var_0_14, arg_4_0 - 12 * var_0_16, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, "f")
	end,
	Text = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
		var_0_5(arg_5_0, arg_5_1, arg_5_4, arg_5_5, arg_5_6, arg_5_7, "rd-", 0, "ZEUS")
	end,
	["Short text"] = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
		var_0_5(arg_6_0, arg_6_1, arg_6_4, arg_6_5, arg_6_6, arg_6_7, "rd-", 0, "Z")
	end
}
local var_0_23 = {
	net_update_end = function()
		local var_7_0 = var_0_8(true)

		var_0_15 = {}

		for iter_7_0, iter_7_1 in pairs(var_7_0) do
			if not iter_7_1:is_alive() then
				return
			end

			local var_7_1 = iter_7_1:get_all_weapons()

			if not var_0_20(var_7_1, "CWeaponTaser") then
				-- block empty
			else
				var_0_15[iter_7_0] = iter_7_1
			end
		end
	end,
	paint = function()
		local var_8_0 = var_0_9()

		if var_8_0 == nil or var_8_0:is_alive() == false then
			return
		end

		local var_8_1 = var_0_1(var_8_0:get_origin())

		if var_8_1.x == 0 then
			return
		end

		local var_8_2 = {
			{
				var_0_19.clr()
			},
			{
				var_0_19.clr2()
			},
			{
				var_0_19.clr3()
			}
		}
		local var_8_3 = var_0_19.range_clr()
		local var_8_4 = var_0_22[var_0_19.enabled()]

		for iter_8_0, iter_8_1 in pairs(var_0_15) do
			local var_8_5 = {
				iter_8_1:get_bounding_box()
			}

			if var_8_5[1] == nil then
				-- block empty
			else
				local var_8_6 = iter_8_1:get_player_weapon()

				if var_8_6 == nil then
					-- block empty
				else
					local var_8_7 = var_0_1(iter_8_1:get_origin())

					if var_8_7.x == 0 then
						-- block empty
					else
						local var_8_8 = var_8_1:dist2d(var_8_7)
						local var_8_9, var_8_10, var_8_11, var_8_12 = var_0_11(var_8_2[1])

						if var_8_6:get_classname() == "CWeaponTaser" then
							var_8_9, var_8_10, var_8_11, var_8_12 = var_0_11(var_8_2[2])
						end

						if var_8_8 < 190 then
							if var_8_3 then
								var_8_9, var_8_10, var_8_11, var_8_12 = var_0_11(var_8_2[3])
							end

							var_8_12 = var_8_12 * var_0_21(8)
						end

						var_8_4(var_8_5[1] - 10, var_8_5[2], 20 * var_0_16, 20 * var_0_16, var_8_9, var_8_10, var_8_11, var_8_12 * var_8_5[5])
					end
				end
			end
		end
	end,
	round_start = function()
		var_0_15 = {}
	end
}

local function var_0_24()
	local var_10_0 = var_0_19.enabled() ~= "Off"

	var_0_19.range_clr.vis, var_0_19.clr3.vis = var_10_0, var_10_0
end

for iter_0_0, iter_0_1 in pairs(var_0_23) do
	var_0_19.enabled:add_event_callback(iter_0_0, iter_0_1, function(arg_11_0)
		return arg_11_0() ~= "Off"
	end)
end

var_0_19.enabled:add_callback(var_0_24)
var_0_19.enabled:invoke()
var_0_19.dpi:add_callback(function(arg_12_0)
	var_0_16 = tonumber(arg_12_0():sub(1, 3)) * 0.01
end)
var_0_19.dpi:invoke()
