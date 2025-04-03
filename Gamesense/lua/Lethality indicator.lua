local var_0_0 = require("bit")
local var_0_1 = require("vector")
local var_0_2 = require("gamesense/uilib")
local var_0_3 = require("gamesense/entity")
local var_0_4 = require("gamesense/images")
local var_0_5 = renderer.text
local var_0_6 = var_0_3.get_local_player
local var_0_7 = var_0_3.get_player_resource
local var_0_8 = globals.maxplayers
local var_0_9 = client.camera_angles
local var_0_10 = client.register_esp_flag
local var_0_11 = ui.reference
local var_0_12 = ui.get
local var_0_13 = plist.get
local var_0_14 = math.cos
local var_0_15 = math.sin
local var_0_16 = math.rad
local var_0_17 = math.sqrt
local var_0_18 = math.acos
local var_0_19 = math.max
local var_0_20 = math.ceil
local var_0_21 = {}
local var_0_22 = 1
local var_0_23
local var_0_24
local var_0_25
local var_0_26
local var_0_27 = {
	bullet = var_0_4.get_panorama_image("icons/ui/bullet.svg")
}
local var_0_28 = {
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
	[2048] = "Hit",
	[256] = "Defuse",
	[4096] = "Occluded",
	[32] = "Reload",
	[64] = "Bomb",
	[8192] = "Exploiter",
	[128] = "Vip",
	[131072] = "Defensive dt",
	[1024] = "Pin pulled",
	[512] = "Fakeduck"
}
local var_0_29 = {
	min_dmg = var_0_2.reference("rage", "aimbot", "minimum damage"),
	min_dmg_ovr = {
		var_0_2.reference("rage", "aimbot", "minimum damage override")
	},
	dpi = var_0_2.reference("misc", "settings", "dpi scale"),
	name = {
		var_0_2.reference("visuals", "player esp", "name")
	},
	weapon_text = {
		var_0_2.reference("visuals", "player esp", "weapon text")
	},
	weapon_icon = {
		var_0_2.reference("visuals", "player esp", "weapon icon")
	}
}
local var_0_30

if pcall(function()
	var_0_11("visuals", "player esp", "show nades")
end) then
	var_0_30 = var_0_11("visuals", "player esp", "show nades")
end

local var_0_31 = "\adcdcdcff"
local var_0_32 = "\a808080c8»" .. var_0_31
local var_0_33 = "visuals"
local var_0_34 = "player esp"
local var_0_35 = {
	enabled = var_0_2.new_checkbox(var_0_33, var_0_34, "Show lethality"),
	options = var_0_2.new_multiselect(var_0_33, var_0_34, "\nlethality_options", {
		"Lethal flag",
		"Force flag",
		"Bullet icon",
		"Force body aim"
	}),
	only_closest = var_0_2.new_checkbox(var_0_33, var_0_34, "Lethal " .. var_0_32 .. " Limit to closest to crosshair"),
	move_icon = var_0_2.new_combobox(var_0_33, var_0_34, "Lethal " .. var_0_32 .. " Icon position", {
		"Default",
		"Above name",
		"Below weapons",
		"Next to health",
		"Top left",
		"Top right",
		"Bottom left",
		"Bottom right"
	}),
	force = var_0_2.new_slider(var_0_33, var_0_34, "Lethal " .. var_0_32 .. " Force body aim shots", 1, 5, 1, true, "x", 1, {
		[1] = "Lethal"
	})
}

local function var_0_36(arg_2_0)
	local var_2_0 = var_0_17(arg_2_0.x * arg_2_0.x + arg_2_0.y * arg_2_0.y + arg_2_0.z * arg_2_0.z)

	if var_2_0 == 0 then
		return var_0_1(0, 0, 0)
	end

	local var_2_1 = 1 / var_2_0

	return var_0_1(arg_2_0.x * var_2_1, arg_2_0.y * var_2_1, arg_2_0.z * var_2_1)
end

local function var_0_37(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = var_0_36(var_0_1(arg_3_0.x - arg_3_1.x, arg_3_0.y - arg_3_1.y, 0)):dot(arg_3_2)
	local var_3_1 = var_0_18(var_3_0)

	return 180 / math.pi * var_3_1
end

local function var_0_38(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = var_0_7()

	for iter_4_0 = 1, var_0_8() do
		if var_4_0:get_prop("m_bConnected", iter_4_0) then
			local var_4_1 = var_0_3.new(iter_4_0)

			if var_4_1 and (not arg_4_0:find("A") or var_4_1:is_alive()) and (not arg_4_0:find("D") or not var_4_1:is_dormant()) and (not arg_4_0:find("E") or var_4_1:is_enemy()) then
				arg_4_1(var_4_1)

				goto label_4_0
			end
		end

		if arg_4_2 then
			arg_4_2(iter_4_0)
		end

		::label_4_0::
	end
end

local function var_0_39(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = {}

	for iter_5_0 = arg_5_1 + 1, arg_5_2 + arg_5_1, arg_5_3 do
		local var_5_1 = var_0_16(iter_5_0)

		var_5_0[#var_5_0 + 1] = var_0_1(arg_5_4 * var_0_14(var_5_1) + arg_5_0.x, arg_5_4 * var_0_15(var_5_1) + arg_5_0.y, arg_5_0.z)
	end

	return var_5_0
end

local function var_0_40(arg_6_0)
	local var_6_0 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		var_6_0 = var_6_0 + 1
	end

	return var_6_0
end

function var_0_3.has_nade(arg_7_0)
	if arg_7_0 == nil then
		return false
	end

	local var_7_0 = arg_7_0:get_player_weapon()

	if var_7_0 == nil then
		return false
	end

	local var_7_1 = var_7_0:get_classname()

	if var_7_1 == "CSmokeGrenade" or var_7_1 == "CHEGrenade" or var_7_1 == "CMolotovGrenade" or var_7_1 == "CFlashGrenade" or var_7_1 == "CDecoyGrenade" or var_7_1 == "CIncendiaryGrenade" then
		return true
	end

	return false
end

function var_0_3.has_short_range_weapon(arg_8_0)
	if arg_8_0 == nil then
		return false
	end

	local var_8_0 = arg_8_0:get_player_weapon()

	if var_8_0 == nil then
		return false
	end

	local var_8_1 = var_8_0:get_classname()

	if var_8_1 == "CKnife" or var_8_1 == "CWeaponTaser" or arg_8_0:has_nade() then
		return true
	end

	return false
end

local var_0_41 = {
	setup_command = function(arg_9_0)
		local var_9_0 = var_0_6()

		if var_9_0 == nil or var_9_0:has_short_range_weapon() or not var_9_0:is_alive() then
			var_0_21.targets = {}

			return
		end

		if arg_9_0.chokedcommands > 0 then
			return
		end

		var_0_21.targets = {}

		local var_9_1 = var_0_29.min_dmg()

		if var_0_29.min_dmg_ovr[1]() and var_0_29.min_dmg_ovr[2]() then
			var_9_1 = var_0_29.min_dmg_ovr[3]()
		end

		local var_9_2 = {
			var_0_9()
		}
		local var_9_3 = var_0_1(var_9_0:get_origin())
		local var_9_4 = {
			var_0_3,
			fov = math.huge
		}
		local var_9_5 = var_0_1():init_from_angles(unpack(var_9_2))
		local var_9_6 = var_0_39(var_9_3 + var_0_1(0, 0, 56), var_9_2[2] + 90, 180, 40, 40)

		if var_0_35.only_closest() then
			var_0_38("ADE", function(arg_10_0)
				local var_10_0 = var_0_37(var_0_1(arg_10_0:get_origin()), var_9_3, var_9_5)

				if var_10_0 < var_9_4.fov then
					var_9_4 = {
						entity = arg_10_0,
						fov = var_10_0
					}
				end
			end)
		end

		var_0_38("ADE", function(arg_11_0)
			if arg_11_0 == nil then
				return
			end

			if var_9_4.entity ~= nil and var_9_4.entity ~= arg_11_0 then
				-- block empty
			else
				local var_11_0 = arg_11_0:get_entindex()

				if not var_0_21.targets[var_11_0] then
					var_0_21.targets[var_11_0] = {
						dmg = 0,
						is = false,
						bullets = 0,
						entity = arg_11_0
					}
				end

				local var_11_1 = var_0_1(arg_11_0:hitbox_position(5))
				local var_11_2 = arg_11_0:get_prop("m_iHealth")

				for iter_11_0, iter_11_1 in ipairs(var_9_6) do
					local var_11_3, var_11_4 = var_9_0:trace_bullet(iter_11_1.x, iter_11_1.y, iter_11_1.z, var_11_1.x, var_11_1.y, var_11_1.z)

					if var_11_4 ~= nil and (var_11_4 > var_9_1 or var_11_2 < var_11_4) then
						var_0_21.targets[var_11_0].dmg = var_11_4
					end
				end

				var_0_21.targets[var_11_0].is, var_0_21.targets[var_11_0].bullets = var_11_2 < var_0_21.targets[var_11_0].dmg, var_0_19(1, var_0_20(var_11_2 / var_0_21.targets[var_11_0].dmg, 0))

				if var_0_26 then
					local var_11_5 = var_0_21.targets[var_11_0].bullets <= var_0_35.force() and "Force" or "-"

					arg_11_0:plist_set("Override prefer body aim", var_11_5)
				end
			end
		end)
	end,
	paint = function()
		local var_12_0 = var_0_6()

		if not var_12_0 or not var_12_0:is_alive() or var_0_21.targets == nil then
			return
		end

		local var_12_1 = var_0_35.move_icon()

		var_0_22 = tonumber(var_0_29.dpi():sub(1, 3)) * 0.01

		if var_0_25 then
			for iter_12_0, iter_12_1 in pairs(var_0_21.targets) do
				if iter_12_1.entity == nil or iter_12_1.entity:is_alive() == false or iter_12_1.dmg <= 0 then
					-- block empty
				else
					local var_12_2 = {
						iter_12_1.entity:get_bounding_box()
					}

					if var_12_2[1] == nil then
						-- block empty
					else
						local var_12_3 = var_0_1(0, 0)

						if var_12_1 == "Default" then
							local var_12_4 = iter_12_1.entity:get_esp_data()
							local var_12_5 = 0

							for iter_12_2 = 0, var_0_40(var_0_28) do
								if var_0_0.band(var_12_4.flags, var_0_0.lshift(1, iter_12_2)) ~= 0 then
									var_12_5 = var_12_5 + 1
								end
							end

							var_12_3 = var_0_1(var_12_2[3], var_12_2[2]) + var_0_1(2, var_12_5 * 8)
						else
							local var_12_6 = 16

							if var_12_1 == "Above name" then
								if var_0_30 and var_0_12(var_0_30) then
									var_12_6 = var_12_6 + 10
								end

								if var_0_29.name[1]() then
									var_12_6 = var_12_6 + 10
								end
							elseif var_12_1 == "Below weapons" then
								var_12_6 = 8

								if var_0_29.weapon_icon[1]() then
									var_12_6 = var_12_6 + 15
								end

								if var_0_29.weapon_text[1]() then
									var_12_6 = var_12_6 + 8
								end
							end

							local var_12_7 = {
								["Above name"] = {
									(var_12_2[1] + var_12_2[3]) * 0.5 - 8 * var_0_22,
									var_12_2[2] - var_12_6 * var_0_22
								},
								["Below weapons"] = {
									(var_12_2[1] + var_12_2[3]) * 0.5 - 8 * var_0_22,
									var_12_2[4] + var_12_6 * var_0_22
								},
								["Next to health"] = {
									var_12_2[1] - 24,
									(var_12_2[2] + var_12_2[4]) * 0.5 - 8 * var_0_22
								},
								["Top left"] = {
									var_12_2[1] - 24 * var_0_22,
									var_12_2[2] - 14 * var_0_22
								},
								["Top right"] = {
									var_12_2[3] + 6 * var_0_22,
									var_12_2[2] - 14 * var_0_22
								},
								["Bottom left"] = {
									var_12_2[1] - 16 * var_0_22,
									var_12_2[4]
								},
								["Bottom right"] = {
									var_12_2[3],
									var_12_2[4]
								}
							}

							var_12_3.x, var_12_3.y = unpack(var_12_7[var_12_1])
						end

						var_0_5(var_12_3.x + 6 * var_0_22, var_12_3.y + 5 * var_0_22, 220, 220, 220, 255 * var_12_2[5], "d-", 0, "x" .. iter_12_1.bullets)
						var_0_27.bullet:draw(var_12_3.x + 1, var_12_3.y + 4, 12 * var_0_22, 10 * var_0_22, 0, 0, 0, 255 * var_12_2[5])
						var_0_27.bullet:draw(var_12_3.x, var_12_3.y + 3, 12 * var_0_22, 10 * var_0_22, 220, 220, 220, 255 * var_12_2[5])
					end
				end
			end
		end
	end
}

var_0_10("-", 255, 0, 0, function(arg_13_0)
	if not var_0_35.enabled() or not var_0_23 then
		return false
	end

	if var_0_21.targets == nil then
		return false
	end

	local var_13_0 = var_0_21.targets[arg_13_0]

	if var_13_0 == nil then
		return false
	end

	return tostring(var_13_0.bullets) ~= "inf", var_13_0.bullets <= 1 and "L" or "x" .. var_13_0.bullets
end)
var_0_10("B", 255, 255, 255, function(arg_14_0)
	if not var_0_35.enabled() or not var_0_24 then
		return false
	end

	return var_0_13(arg_14_0, "Override prefer body aim") == "Force"
end)

local function var_0_42()
	local var_15_0 = var_0_35.enabled()

	var_0_23, var_0_24, var_0_25, var_0_26 = var_0_35.options:contains("Lethal flag"), var_0_35.options:contains("Force flag"), var_0_35.options:contains("Bullet icon"), var_0_35.options:contains("Force body aim")
	var_0_35.options.vis = var_15_0
	var_0_35.only_closest.vis = var_15_0
	var_0_35.move_icon.vis = var_15_0 and var_0_35.options:contains("Bullet icon")
	var_0_35.force.vis = var_15_0 and var_0_35.options:contains("Force body aim")
end

var_0_35.enabled:add_callback(var_0_42)
var_0_35.options:add_callback(var_0_42)
var_0_35.enabled:add_event_callback("paint", var_0_41.paint)
var_0_35.enabled:add_event_callback("setup_command", var_0_41.setup_command)
var_0_35.enabled:invoke()

local var_0_43 = {
	get_data = function()
		return var_0_21.targets
	end
}

package.preload["gamesense/lethality"] = function()
	return var_0_43
end
