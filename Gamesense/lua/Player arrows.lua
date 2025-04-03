local var_0_0 = require("vector")
local var_0_1 = require("gamesense/images")
local var_0_2 = require("gamesense/uilib")
local var_0_3 = client.screen_size
local var_0_4 = client.camera_angles
local var_0_5 = client.trace_bullet
local var_0_6 = globals.curtime
local var_0_7 = globals.realtime
local var_0_8 = globals.maxplayers
local var_0_9 = entity.get_local_player
local var_0_10 = entity.get_player_resource
local var_0_11 = entity.is_alive
local var_0_12 = entity.hitbox_position
local var_0_13 = entity.is_enemy
local var_0_14 = entity.get_prop
local var_0_15 = entity.get_player_weapon
local var_0_16 = entity.get_classname
local var_0_17 = entity.get_bounding_box
local var_0_18 = entity.is_dormant
local var_0_19 = entity.get_player_name
local var_0_20 = renderer.triangle
local var_0_21 = renderer.text
local var_0_22 = renderer.measure_text
local var_0_23 = renderer.rectangle
local var_0_24 = renderer.circle_outline
local var_0_25 = renderer.circle
local var_0_26 = math.abs
local var_0_27 = math.sin
local var_0_28 = math.cos
local var_0_29 = math.min
local var_0_30 = math.max
local var_0_31 = math.rad
local var_0_32 = "Player arrow \a808080c8»\adcdcdcff "
local var_0_33 = "visuals"
local var_0_34 = "player esp"
local var_0_35 = var_0_2.reference("misc", "settings", "dpi scale")
local var_0_36 = {
	enabled = var_0_2.new_checkbox(var_0_33, var_0_34, "Player arrow"),
	clr = var_0_2.new_color_picker(var_0_33, var_0_34, "player_arrow_color1", 160, 200, 45, 255),
	clr_dormant = var_0_2.new_color_picker(var_0_33, var_0_34, "player_arrow_color_dormant", 120, 120, 120, 255),
	type = var_0_2.new_combobox(var_0_33, var_0_34, "\nplayer_arrow_type", {
		"Default",
		"Half-circle",
		"Circle"
	}),
	options = var_0_2.new_multiselect(var_0_33, var_0_34, var_0_32 .. "Options", {
		"Pulse",
		"Out of fov",
		"Warn about threats",
		"Show dormant",
		"Player name",
		"Player esp",
		"Multiply size by dist",
		"Multiply radius by dist",
		"Multiply alpha by dist"
	}),
	threat_reason = var_0_2.new_checkbox(var_0_33, var_0_34, var_0_32 .. "Warning icon"),
	clr_warn = var_0_2.new_color_picker(var_0_33, var_0_34, "player_arrow_color2", 255, 0, 0, 255),
	size = var_0_2.new_slider(var_0_33, var_0_34, var_0_32 .. "Size", 1, 35, 15, true, "px"),
	radius = var_0_2.new_slider(var_0_33, var_0_34, var_0_32 .. "Radius", 0, 150, 25, true, "%")
}
local var_0_37 = var_0_0(var_0_3())
local var_0_38 = {}
local var_0_39 = 1
local var_0_40 = 2048
local var_0_41
local var_0_42
local var_0_43
local var_0_44
local var_0_45
local var_0_46
local var_0_47
local var_0_48
local var_0_49
local var_0_50 = {
	warning = var_0_1.get_panorama_image("icons/ui/warning.svg")
}

local function var_0_51(arg_1_0)
	return var_0_26(var_0_27(var_0_6() * arg_1_0))
end

local function var_0_52(arg_2_0, arg_2_1, arg_2_2)
	return var_0_29(arg_2_2, var_0_30(arg_2_1, arg_2_0))
end

local function var_0_53(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_27(arg_3_2)
	local var_3_1 = var_0_28(arg_3_2)

	arg_3_1.x, arg_3_1.y = arg_3_1.x - arg_3_0.x, arg_3_1.y - arg_3_0.y

	local var_3_2 = arg_3_1.x * var_3_1 - arg_3_1.y * var_3_0
	local var_3_3 = arg_3_1.x * var_3_0 + arg_3_1.y * var_3_1

	return var_0_0(var_3_2 + arg_3_0.x, var_3_3 + arg_3_0.y)
end

local var_0_54 = {
	paint = function()
		local var_4_0 = var_0_9()

		if var_4_0 == nil or var_0_11(var_4_0) == false then
			return
		end

		local var_4_1 = var_0_10()

		if var_4_1 == nil then
			return
		end

		local var_4_2 = var_0_7()
		local var_4_3 = var_0_46 and function()
			return var_0_51(3)
		end or function()
			return 1
		end
		local var_4_4 = var_0_44 and 18 or 10
		local var_4_5 = {
			var_0_36.clr()
		}
		local var_4_6 = {
			var_0_36.clr_warn()
		}
		local var_4_7 = {
			var_0_36.clr_dormant()
		}
		local var_4_8 = 8 * var_0_36.radius()
		local var_4_9 = var_0_36.threat_reason()
		local var_4_10 = var_0_36.type()
		local var_4_11 = var_0_36.size()
		local var_4_12 = var_4_8 + var_4_11
		local var_4_13 = var_0_0(var_0_4())

		if var_4_13.x == 0 then
			return
		end

		local var_4_14 = var_0_0(var_0_12(var_4_0, 0))

		if var_4_14.x == 0 then
			return
		end

		for iter_4_0 = 1, var_0_8() do
			repeat
				if var_0_14(var_4_1, "m_bConnected", iter_4_0) ~= 1 or not var_0_11(iter_4_0) or not var_0_13(iter_4_0) then
					break
				end

				if not var_0_38[iter_4_0] then
					var_0_38[iter_4_0] = {}
				end

				local var_4_15 = var_0_38[iter_4_0]
				local var_4_16 = var_0_15(iter_4_0)

				if var_4_16 == nil then
					break
				end

				local var_4_17 = var_0_16(var_4_16)
				local var_4_18 = var_0_14(var_4_16, "m_iItemDefinitionIndex")
				local var_4_19 = var_0_1.get_weapon_icon(var_4_18)
				local var_4_20 = var_4_5[1]
				local var_4_21 = var_4_5[2]
				local var_4_22 = var_4_5[3]
				local var_4_23 = var_4_5[4] * var_4_3()
				local var_4_24 = var_0_0(var_0_12(iter_4_0, 0))
				local var_4_25 = var_0_52(var_4_14:dist(var_4_24), 0, var_0_40) / var_0_40
				local var_4_26 = var_4_12
				local var_4_27 = {
					var_0_17(iter_4_0)
				}
				local var_4_28 = var_0_18(iter_4_0)

				if not var_4_28 or var_4_27[5] > 0 then
					var_4_15.dormant = var_4_2 + 2.5
				end

				if var_0_41 and var_4_27[5] > 0 then
					break
				end

				if var_0_42 then
					local var_4_29 = var_4_24 + var_0_0(var_0_14(iter_4_0, "m_vecVelocity")) * 0.4

					if var_4_17:find("Grenade") ~= nil then
						var_4_15.threat = {
							ticks = var_4_2,
							icon = var_4_19
						}
					else
						local var_4_30, var_4_31 = var_0_5(iter_4_0, var_4_29.x, var_4_29.y, var_4_29.z, var_4_14.x, var_4_14.y, var_4_14.z)

						if var_4_31 > 0 then
							var_4_15.threat = {
								ticks = var_4_2 + 3.5,
								icon = var_0_50.warning
							}
						end
					end

					if var_4_15.threat and var_4_2 <= var_4_15.threat.ticks then
						var_4_20, var_4_21, var_4_22, var_4_23 = unpack(var_4_6)
						var_4_23 = var_4_23 * var_4_3()
					end
				end

				if var_0_43 and var_4_28 then
					if var_4_15.dormant and var_4_2 < var_4_15.dormant then
						var_4_20, var_4_21, var_4_22, var_4_23 = unpack(var_4_7)
						var_4_23 = var_4_23 * var_0_51(8)
					else
						break
					end
				end

				if var_0_48 then
					var_4_11 = var_0_30(5, var_4_11 * (1 - var_4_25))
				end

				if var_0_47 then
					var_4_26 = var_0_30(var_4_11 + 25, var_4_26 * var_4_25)
				end

				if var_0_49 then
					var_4_23 = var_4_23 * (1 - var_4_25)
				end

				local var_4_32, var_4_33 = var_4_14:to(var_4_24):angles()

				if not var_4_33 then
					break
				end

				local var_4_34 = 270 - var_4_33 + var_4_13.y
				local var_4_35 = var_0_31(var_4_34)
				local var_4_36 = var_0_0(var_0_29(var_0_37.x - 18, var_0_30(18, var_0_37.x / 2 + var_0_28(var_4_35) * var_4_26)), var_0_29(var_0_37.y - 18, var_0_30(25, var_0_37.y / 2 + var_0_27(var_4_35) * var_4_26)))

				if var_4_10 == "Default" then
					local var_4_37 = {
						var_4_36,
						var_0_53(var_4_36, var_0_0(var_4_36.x - var_4_11 / 2, var_4_36.y - var_4_11), var_0_31(var_4_34 - 90)),
						var_0_53(var_4_36, var_0_0(var_4_36.x + var_4_11 / 2, var_4_36.y - var_4_11), var_0_31(var_4_34 - 90))
					}

					var_0_20(var_4_37[1].x, var_4_37[1].y, var_4_37[2].x, var_4_37[2].y, var_4_37[3].x, var_4_37[3].y, var_4_20, var_4_21, var_4_22, var_4_23)

					local var_4_38 = var_4_37[1].y
					local var_4_39 = var_4_37[1].x
					local var_4_40 = var_4_37[1].x

					if var_4_38 > var_4_37[2].y then
						var_4_38 = var_4_37[2].y
					end

					if var_4_38 > var_4_37[3].y then
						var_4_38 = var_4_37[3].y
					end

					var_4_36.y = var_4_38 - (4 + 3 * var_0_39)

					if var_4_39 > var_4_37[2].x then
						var_4_39 = var_4_37[2].x
					elseif var_4_40 < var_4_37[2].x then
						var_4_40 = var_4_37[2].x
					end

					if var_4_39 > var_4_37[3].x then
						var_4_39 = var_4_37[3].x
					elseif var_4_40 < var_4_37[3].x then
						var_4_40 = var_4_37[3].x
					end

					var_4_36.x = var_4_39 + (var_4_40 - var_4_39) * 0.5
				elseif var_4_10 == "Half-circle" then
					var_4_26 = var_0_52(var_4_26, 0, (var_4_36.y == 25 or var_4_36.y == var_0_37.y - 25) and 525 or 925)

					var_0_24(var_0_37.x * 0.5, var_0_37.y * 0.5, var_4_20, var_4_21, var_4_22, var_4_23, var_4_26, var_4_34 - var_4_11 * 0.5, var_4_11 * 0.002, 2)

					var_4_36 = var_0_0(var_0_29(var_0_37.x - 25, var_0_30(25, var_0_37.x / 2 + var_0_28(var_4_35) * var_4_26)), var_0_29(var_0_37.y - 25, var_0_30(45, var_0_37.y / 2 + var_0_27(var_4_35) * var_4_26)))
				else
					var_4_36 = var_0_0(var_0_29(var_0_37.x - 25, var_0_30(25, var_0_37.x / 2 + var_0_28(var_4_35) * var_4_26)), var_0_29(var_0_37.y - var_4_11 - 25, var_0_30(25, var_0_37.y / 2 + var_0_27(var_4_35) * var_4_26)))

					var_0_25(var_4_36.x, var_4_36.y + var_4_11 * 0.5 + 8, var_4_20, var_4_21, var_4_22, var_4_23, var_4_11 * 0.5, 0, 1)
				end

				if var_0_42 and var_4_9 and var_4_15.threat and var_4_2 < var_4_15.threat.ticks and var_4_15.threat.icon then
					local var_4_41 = {
						var_4_15.threat.icon:measure() * 0.4 * var_0_39
					}

					var_4_15.threat.icon:draw(var_4_36.x - var_4_41[1] * 0.5, var_4_36.y - var_4_4 * var_0_39, var_4_41[1], var_4_41[2], 230, 210, 20, var_4_23)
				end

				if var_0_44 then
					var_0_21(var_4_36.x, var_4_36.y, 220, 220, 220, var_4_23, "cd", 0, var_0_19(iter_4_0))
				end

				if var_0_45 then
					local var_4_42 = var_0_14(iter_4_0, "m_iHealth")
					local var_4_43 = var_0_52(var_4_42, 0, 100) / 100
					local var_4_44 = var_0_22("cd", var_0_19(iter_4_0)) + var_4_11 * 0.5

					if var_4_19 then
						local var_4_45 = {
							var_4_19:measure() * 0.4 * var_0_39
						}

						var_4_19:draw(var_4_36.x - var_4_45[1] * 0.5, var_4_36.y + var_4_11 + 10, var_4_45[1], var_4_45[2], 220, 220, 220, var_4_23)
					end

					var_0_23(var_4_36.x - var_4_44 * 0.5 - 6, var_4_36.y - 2, 4, var_4_11 + 8, 0, 0, 0, var_4_23 * 0.5)
					var_0_23(var_4_36.x - var_4_44 * 0.5 - 5, var_4_36.y - 1 + (var_4_11 + 6) * (1 - var_4_43), 2, (var_4_11 + 6) * var_4_43, 167, 220, 15, var_4_23)

					if var_4_42 <= 92 then
						var_0_21(var_4_36.x - var_4_44 * 0.5 - 6, var_4_36.y - 1 + (var_4_11 + 6) * (1 - var_4_43), 220, 220, 220, var_4_23, "-cd", 0, var_4_42)
					end
				end
			until true
		end
	end,
	round_start = function()
		var_0_38 = {}
	end
}

local function var_0_55()
	local var_8_0 = var_0_36.enabled()

	for iter_8_0, iter_8_1 in pairs(var_0_36) do
		repeat
			if iter_8_0 == "enabled" or iter_8_0 == "clr_warn" or iter_8_0 == "threat_reason" then
				break
			end

			iter_8_1.vis = var_8_0
		until true
	end

	var_0_41, var_0_42, var_0_43, var_0_44, var_0_45, var_0_46, var_0_48, var_0_47, var_0_49 = var_0_36.options:contains("Out of fov"), var_0_36.options:contains("Warn about threats"), var_0_36.options:contains("Show dormant"), var_0_36.options:contains("Player name"), var_0_36.options:contains("Player esp"), var_0_36.options:contains("Pulse"), var_0_36.options:contains("Multiply size by dist"), var_0_36.options:contains("Multiply radius by dist"), var_0_36.options:contains("Multiply alpha by dist")
	var_0_36.clr_warn.vis, var_0_36.threat_reason.vis = var_8_0 and var_0_42, var_8_0 and var_0_42
end

var_0_36.enabled:add_callback(var_0_55)
var_0_36.options:add_callback(var_0_55)

for iter_0_0, iter_0_1 in pairs(var_0_54) do
	var_0_36.enabled:add_event_callback(iter_0_0, iter_0_1)
end

var_0_36.enabled:invoke()
var_0_35:add_callback(function(arg_9_0)
	var_0_39 = tonumber(arg_9_0():sub(1, 3)) * 0.01
end)
var_0_35:invoke()
