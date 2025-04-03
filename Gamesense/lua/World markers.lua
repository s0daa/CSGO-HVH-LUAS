local var_0_0 = require("vector")
local var_0_1 = require("gamesense/uilib")
local var_0_2 = require("gamesense/entity")
local var_0_3 = require("gamesense/images")
local var_0_4 = renderer.world_to_screen
local var_0_5 = renderer.text
local var_0_6 = renderer.line
local var_0_7 = renderer.circle_outline
local var_0_8 = var_0_2.get_local_player
local var_0_9 = var_0_2.new_from_userid
local var_0_10 = globals.realtime
local var_0_11 = globals.frametime
local var_0_12 = globals.tickcount
local var_0_13 = math.min
local var_0_14 = math.max
local var_0_15 = math.cos
local var_0_16 = math.pi
local var_0_17
local var_0_18
local var_0_19
local var_0_20
local var_0_21 = "cd"
local var_0_22 = 1
local var_0_23 = {}
local var_0_24 = {}
local var_0_25 = {}
local var_0_26 = "World markers \a808080c8»\adcdcdcff "
local var_0_27 = "visuals"
local var_0_28 = "effects"
local var_0_29 = {
	enabled = var_0_1.new_checkbox(var_0_27, var_0_28, "World markers"),
	miss_clr = var_0_1.new_color_picker(var_0_27, var_0_28, "world_hm_miss_clr", 230, 210, 20, 255),
	options = var_0_1.new_multiselect(var_0_27, var_0_28, "\nworld_hm_options", {
		"Cross",
		"Damage",
		"Misses",
		"Damage \a808080c8»\adcdcdcff Dynamic color"
	}),
	time = var_0_1.new_slider(var_0_27, var_0_28, var_0_26 .. "Time", 1, 200, 50, true, "s", 0.1),
	cross_size = var_0_1.new_slider(var_0_27, var_0_28, var_0_26 .. "Cross size", 1, 25, 10, true, "px"),
	cross_clr = var_0_1.new_color_picker(var_0_27, var_0_28, "world_hm_cross_clr", 220, 220, 220, 255),
	dmg_font = var_0_1.new_combobox(var_0_27, var_0_28, var_0_26 .. "Damage text", {
		"Default",
		"Big",
		"Small",
		"Bold"
	}),
	dmg_clr1 = var_0_1.new_color_picker(var_0_27, var_0_28, "world_hm_dmg_clr", 165, 220, 15, 255),
	dmg_clr2 = var_0_1.new_color_picker(var_0_27, var_0_28, "world_hm_dmg_clr2", 220, 50, 50, 255),
	dpi = var_0_1.reference("misc", "settings", "dpi scale")
}

local function var_0_30(arg_1_0, arg_1_1, arg_1_2)
	return arg_1_0 + (arg_1_1 - arg_1_0) * arg_1_2
end

local function var_0_31(arg_2_0, arg_2_1, arg_2_2)
	return var_0_13(arg_2_2, var_0_14(arg_2_1, arg_2_0))
end

local function var_0_32(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return -arg_3_2 * var_0_15(arg_3_0 / arg_3_3 * (var_0_16 / 2)) + arg_3_2 + arg_3_1
end

local function var_0_33(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	arg_4_2 = arg_4_2 * 0.5

	local var_4_0 = arg_4_2 * 0.5

	var_0_6(arg_4_0 - arg_4_2, arg_4_1 - arg_4_2, arg_4_0 - var_4_0, arg_4_1 - var_4_0, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	var_0_6(arg_4_0 + arg_4_2, arg_4_1 + arg_4_2, arg_4_0 + var_4_0, arg_4_1 + var_4_0, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	var_0_6(arg_4_0 - arg_4_2, arg_4_1 + arg_4_2, arg_4_0 - var_4_0, arg_4_1 + var_4_0, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	var_0_6(arg_4_0 + arg_4_2, arg_4_1 - arg_4_2, arg_4_0 + var_4_0, arg_4_1 - var_4_0, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
end

local var_0_34 = {
	["prediction error"] = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
		var_0_3.get_panorama_image("icons/ui/warning.svg"):draw(arg_5_0 - arg_5_2 / 2, arg_5_1 - arg_5_3 / 2, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7)
	end,
	["unregistered shot"] = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
		var_0_5(arg_6_0, arg_6_1, arg_6_4, arg_6_5, arg_6_6, arg_6_7, "bcd", 0, "X")
	end,
	death = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
		var_0_3.get_panorama_image("hud/voicestatus/skull.png"):draw(arg_7_0 - arg_7_2 / 2, arg_7_1 - arg_7_3 / 2, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6, arg_7_7)
	end,
	spread = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8)
		local var_8_0 = var_0_32(arg_8_8, 0, -1, 2)

		var_0_7(arg_8_0, arg_8_1, arg_8_4, arg_8_5, arg_8_6, arg_8_7 * var_8_0, arg_8_2 * 0.2 * arg_8_8, 0, 1, 1)
	end,
	unknown = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
		var_0_5(arg_9_0, arg_9_1, arg_9_4, arg_9_5, arg_9_6, arg_9_7, "bcd", 0, "?")
	end
}
local var_0_35 = {
	bullet_impact = function(arg_10_0)
		local var_10_0 = var_0_8()

		if var_10_0 == nil then
			return
		end

		local var_10_1 = var_0_9(arg_10_0.userid)
		local var_10_2 = var_0_12()

		if var_10_1 == var_10_0 then
			if #var_0_24 > 150 and var_0_24[#var_0_24].tick ~= var_10_2 then
				var_0_24 = {}
			end

			var_0_24[#var_0_24 + 1] = {
				tick = var_10_2,
				origin = var_0_0(arg_10_0.x, arg_10_0.y, arg_10_0.z)
			}
		end
	end,
	player_hurt = function(arg_11_0)
		if not var_0_17 and not var_0_18 then
			return
		end

		local var_11_0 = var_0_8()

		if var_11_0 == nil then
			return
		end

		local var_11_1 = var_0_9(arg_11_0.userid)
		local var_11_2 = var_0_9(arg_11_0.attacker)

		if var_11_1 == nil or var_11_2 == nil or var_11_1 == var_11_0 or var_11_2 ~= var_11_0 or var_11_1:is_enemy() == false then
			return
		end

		local var_11_3 = var_0_0(var_11_1:hitbox_position(3))

		if var_11_3.x == 0 then
			return
		end

		local var_11_4 = {
			origin = var_11_3,
			distance = math.huge
		}
		local var_11_5 = var_0_12()

		for iter_11_0, iter_11_1 in ipairs(var_0_24) do
			if iter_11_1.tick == var_11_5 then
				local var_11_6 = iter_11_1.origin:dist2d(var_11_3)

				if var_11_6 < var_11_4.distance then
					var_11_4 = {
						origin = iter_11_1.origin,
						distance = var_11_6
					}
				end
			end
		end

		var_0_24 = {}
		var_0_23[#var_0_23 + 1] = {
			a = 0,
			origin = var_11_4.origin,
			dmg = arg_11_0.dmg_health,
			time = var_0_10() + var_0_29.time() * 0.1
		}
	end,
	aim_fire = function(arg_12_0)
		if arg_12_0.id >= 150 then
			var_0_25 = {}
		end

		var_0_25[arg_12_0.id] = {
			origin = var_0_0(arg_12_0.x, arg_12_0.y, arg_12_0.z)
		}
	end,
	aim_miss = function(arg_13_0)
		if not var_0_19 then
			return
		end

		if not var_0_17 and not var_0_18 then
			return
		end

		local var_13_0 = var_0_25[arg_13_0.id]

		if var_0_2(arg_13_0.target) == nil then
			return
		end

		local var_13_1 = var_13_0.origin

		if var_13_1.x == 0 then
			return
		end

		var_0_23[#var_0_23 + 1] = {
			loop = 0,
			a = 0,
			origin = var_13_1,
			reason = arg_13_0.reason,
			time = var_0_10() + var_0_29.time() * 0.1
		}
	end,
	paint = function()
		local var_14_0 = var_0_11()
		local var_14_1 = var_0_10()
		local var_14_2 = {
			{
				var_0_29.cross_clr()
			},
			{
				var_0_29.dmg_clr1()
			},
			{
				var_0_29.dmg_clr2()
			},
			{
				var_0_29.miss_clr()
			}
		}
		local var_14_3 = var_0_21 == "cd+" and 8 * var_0_22 or 4 * var_0_22
		local var_14_4 = var_0_29.cross_size()
		local var_14_5 = var_0_17 and var_14_4 + var_14_3 or 15 + var_14_3

		for iter_14_0, iter_14_1 in pairs(var_0_23) do
			if var_14_1 > iter_14_1.time then
				var_0_23[iter_14_0] = nil
			end

			local var_14_6, var_14_7 = var_0_4(iter_14_1.origin:unpack())

			if var_14_6 == nil then
				-- block empty
			else
				if var_0_18 and iter_14_1.dmg then
					local var_14_8 = var_14_2[2]

					if var_0_20 then
						local var_14_9 = var_0_31(iter_14_1.dmg * 0.01, 0, 1)

						var_14_8 = {
							var_0_30(var_14_2[2][1], var_14_2[3][1], var_14_9),
							var_0_30(var_14_2[2][2], var_14_2[3][2], var_14_9),
							var_0_30(var_14_2[2][3], var_14_2[3][3], var_14_9),
							var_0_30(var_14_2[2][4], var_14_2[3][4], var_14_9)
						}
					end

					var_0_5(var_14_6, var_14_7 - var_14_5 * iter_14_1.a, var_14_8[1], var_14_8[2], var_14_8[3], var_14_8[4] * iter_14_1.a, var_0_21, 0, iter_14_1.dmg)
				end

				if var_0_19 and iter_14_1.reason then
					(var_0_34[iter_14_1.reason] or var_0_34.unknown)(var_14_6, var_14_7 - 15 * iter_14_1.a, 15, 15, var_14_2[4][1], var_14_2[4][2], var_14_2[4][3], var_14_2[4][4] * iter_14_1.a, iter_14_1.loop)

					if iter_14_1.reason == "spread" then
						iter_14_1.loop = iter_14_1.loop < 2 and iter_14_1.loop + var_14_0 * 2 or 0
					end
				end

				if var_0_17 then
					var_0_33(var_14_6, var_14_7, var_14_4 * iter_14_1.a, var_14_2[1][1], var_14_2[1][2], var_14_2[1][3], var_14_2[1][4] * iter_14_1.a)
				end

				iter_14_1.a = var_0_31(iter_14_1.a + (var_14_1 < iter_14_1.time - 0.5 and var_14_0 * 6 or -var_14_0 * 6), 0, 1)
			end
		end
	end,
	round_start = function()
		var_0_23, var_0_24, var_0_25 = {}, {}, {}
	end
}

local function var_0_36()
	local var_16_0 = var_0_29.enabled()
	local var_16_1 = var_0_29.dmg_font()

	var_0_17, var_0_18, var_0_19, var_0_20 = var_0_29.options:contains("Cross"), var_0_29.options:contains("Damage"), var_0_29.options:contains("Misses"), var_0_29.options:contains("Damage \a808080c8»\adcdcdcff Dynamic color")
	var_0_29.options.vis, var_0_29.time.vis = var_16_0, var_16_0 and (var_0_17 or var_0_18)
	var_0_29.miss_clr.vis = var_16_0 and var_0_19
	var_0_29.cross_size.vis, var_0_29.cross_clr.vis = var_16_0 and var_0_17, var_16_0 and var_0_17
	var_0_29.dmg_font.vis, var_0_29.dmg_clr1.vis, var_0_29.dmg_clr2.vis = var_16_0 and var_0_18, var_16_0 and var_0_18, var_16_0 and var_0_18 and var_0_20
	var_0_21 = var_16_1 == "Big" and "cd+" or var_16_1 == "Small" and "cd-" or var_16_1 == "Bold" and "bcd" or "cd"
end

var_0_29.enabled:add_callback(var_0_36)

for iter_0_0, iter_0_1 in pairs(var_0_35) do
	var_0_29.enabled:add_event_callback(iter_0_0, iter_0_1)
end

var_0_29.enabled:invoke()
var_0_29.options:add_callback(var_0_36)
var_0_29.dmg_font:add_callback(var_0_36)
var_0_29.dpi:add_callback(function(arg_17_0)
	var_0_22 = tonumber(arg_17_0():sub(1, 3)) * 0.01
end)
var_0_29.dpi:invoke()
