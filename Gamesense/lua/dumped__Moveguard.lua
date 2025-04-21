local var_0_0 = require("gamesense/trace").hull
local var_0_1 = require("vector")
local var_0_2 = unpack
local var_0_3 = next
local var_0_4 = renderer.line
local var_0_5 = renderer.world_to_screen
local var_0_6 = var_0_1().unpack
local var_0_7 = globals.tickinterval
local var_0_8 = client.camera_angles
local var_0_9 = bit.band
local var_0_10 = entity.get_local_player
local var_0_11 = entity.get_prop
local var_0_12 = math.floor
local var_0_13 = totime
local var_0_14

local function var_0_15(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {
		var_0_1(arg_1_0.x + arg_1_1.x, arg_1_0.y + arg_1_1.y, arg_1_0.z + arg_1_1.z),
		var_0_1(arg_1_0.x + arg_1_2.x, arg_1_0.y + arg_1_1.y, arg_1_0.z + arg_1_1.z),
		var_0_1(arg_1_0.x + arg_1_2.x, arg_1_0.y + arg_1_2.y, arg_1_0.z + arg_1_1.z),
		var_0_1(arg_1_0.x + arg_1_1.x, arg_1_0.y + arg_1_2.y, arg_1_0.z + arg_1_1.z)
	}

	for iter_1_0 = 1, 4 do
		local var_1_1 = var_1_0[iter_1_0]

		var_1_0[#var_1_0 + 1] = var_0_1(var_1_1.x, var_1_1.y, var_1_1.z + arg_1_1.z + arg_1_2.z)
	end

	for iter_1_1 = 1, 8 do
		var_1_0[iter_1_1] = {
			var_0_5(var_0_6(var_1_0[iter_1_1]))
		}
	end

	return var_1_0
end

local function var_0_16(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
	local var_2_0 = {
		var_0_1(arg_2_0.x + arg_2_1.x, arg_2_0.y + arg_2_1.y, arg_2_0.z + arg_2_1.z),
		var_0_1(arg_2_0.x + arg_2_2.x, arg_2_0.y + arg_2_1.y, arg_2_0.z + arg_2_1.z),
		var_0_1(arg_2_0.x + arg_2_2.x, arg_2_0.y + arg_2_2.y, arg_2_0.z + arg_2_1.z),
		var_0_1(arg_2_0.x + arg_2_1.x, arg_2_0.y + arg_2_2.y, arg_2_0.z + arg_2_1.z)
	}

	for iter_2_0 = 1, 4 do
		local var_2_1 = var_2_0[iter_2_0]

		var_2_0[#var_2_0 + 1] = var_0_1(var_2_1.x, var_2_1.y, var_2_1.z + arg_2_1.z + arg_2_2.z)
	end

	for iter_2_1 = 1, 8 do
		var_2_0[iter_2_1] = {
			var_0_5(var_0_6(var_2_0[iter_2_1]))
		}
	end

	local var_2_2 = {
		{
			2,
			4,
			5
		},
		{
			3,
			6
		},
		{
			4,
			7
		},
		{
			8
		},
		{
			6,
			8
		},
		{
			7
		},
		{
			8
		}
	}

	for iter_2_2, iter_2_3 in var_0_3, var_2_2 do
		local var_2_3, var_2_4 = var_0_2(var_2_0[iter_2_2])

		for iter_2_4, iter_2_5 in var_0_3, iter_2_3 do
			local var_2_5, var_2_6 = var_0_2(var_2_0[iter_2_5])

			var_0_4(var_2_3, var_2_4, var_2_5, var_2_6, arg_2_3, arg_2_4, arg_2_5, arg_2_6)
		end
	end
end

local var_0_17
local var_0_18 = error
local var_0_19 = var_0_3
local var_0_20 = string.sub
local var_0_21 = string.lower
local var_0_22 = tostring
local var_0_23 = type
local var_0_24 = var_0_2
local var_0_25 = ui.set_callback
local var_0_26 = ui.get
local var_0_27 = ui.set
local var_0_28 = setmetatable
local var_0_29 = ui.reference
local var_0_30 = {}

local function var_0_31(arg_3_0)
	if var_0_30[arg_3_0] then
		return {}
	end

	var_0_30[arg_3_0] = true

	local var_3_0 = {}

	for iter_3_0, iter_3_1 in var_0_19, arg_3_0 do
		if var_0_23(iter_3_1) == "table" then
			var_3_0[iter_3_0] = var_0_31(iter_3_1)
		else
			var_3_0[iter_3_0] = iter_3_1
		end
	end

	return var_3_0
end

local var_0_32 = var_0_31(client)
local var_0_33 = {}
local var_0_34 = {}

for iter_0_0, iter_0_1 in var_0_19, ui do
	if var_0_20(iter_0_0, 1, 4) ~= "new_" then
		var_0_34[iter_0_0] = function(arg_4_0, ...)
			return iter_0_1(arg_4_0.reference, ...)
		end
	else
		var_0_33[var_0_20(iter_0_0, 5)] = iter_0_1
	end
end

var_0_34.is_menu_open = nil
var_0_34.menu_position = nil
var_0_34.menu_size = nil
var_0_34.mouse_position = nil
var_0_34.reference = nil

local function var_0_35(arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in var_0_19, arg_5_0 do
		if iter_5_1 == arg_5_1 then
			return true
		end
	end

	return false
end

local function var_0_36(arg_6_0)
	return var_0_23(arg_6_0) == "table" and var_0_23(arg_6_0.reference) == "number" and var_0_23(arg_6_0.reveals) == "table" and var_0_23(arg_6_0.callbacks) == "table"
end

local function var_0_37(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	var_0_18(arg_7_0 .. " received an incorrect type for " .. arg_7_1 .. ", got '" .. arg_7_2 .. "' expected '" .. arg_7_3 .. "'\ntemplate:\n" .. arg_7_0 .. "(" .. arg_7_4 .. ")")
end

local function var_0_38(arg_8_0, arg_8_1)
	local var_8_0
	local var_8_1 = 0

	for iter_8_0 in var_0_19, arg_8_0 do
		local var_8_2 = 0

		for iter_8_1 = 1, #iter_8_0 do
			if iter_8_1 > #arg_8_1 then
				break
			end

			if var_0_20(arg_8_1, iter_8_1, iter_8_1) == var_0_20(iter_8_0, iter_8_1, iter_8_1) then
				var_8_2 = var_8_2 + 1
			end
		end

		if var_8_1 < var_8_2 then
			var_8_1 = var_8_2
			var_8_0 = iter_8_0
		end
	end

	return var_8_0 == nil and "" or "\ndid you mean '" .. var_8_0 .. "'?"
end

function var_0_34.set_callback(arg_9_0, arg_9_1)
	arg_9_0.callbacks[#arg_9_0.callbacks + 1] = arg_9_1
end

function var_0_34.get(arg_10_0, arg_10_1)
	if arg_10_0.get_override_default ~= nil then
		if arg_10_0:type() == "combobox" then
			return ""
		end

		return var_0_24(arg_10_0.default)
	end

	local var_10_0 = {
		var_0_26(arg_10_0.reference)
	}

	if var_0_23(var_10_0[1]) == "table" then
		var_10_0 = var_10_0[1]
	end

	if arg_10_1 then
		return var_0_35(var_10_0, arg_10_1)
	end

	return var_0_24(var_10_0)
end

function var_0_34.register_event_callback(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = "match: any, event: string, callback: function"

	if var_0_23(arg_11_2) ~= "function" and arg_11_3 ~= nil then
		if var_0_23(arg_11_2) ~= "string" then
			return var_0_37(":register_event_callback", "event", var_0_23(arg_11_2), "string", var_11_0)
		elseif var_0_23(arg_11_3) ~= "function" then
			return var_0_37(":register_event_callback", "callback", var_0_23(arg_11_3), "function", var_11_0)
		end
	end

	local function var_11_1()
		if var_0_23(arg_11_2) == "function" and arg_11_3 == nil then
			return var_0_32[(arg_11_0:get() and "" or "un") .. "set_event_callback"](arg_11_1, arg_11_2)
		end

		local var_12_0 = {
			arg_11_0:get()
		}

		if var_0_23(var_12_0[1]) == "table" then
			var_12_0 = var_12_0[1]
		end

		var_0_32[(var_0_35(var_12_0, arg_11_1) and "" or "un") .. "set_event_callback"](arg_11_2, arg_11_3)
	end

	arg_11_0:set_callback(var_11_1)
	var_11_1()
end

function var_0_34.update_visibility(arg_13_0, arg_13_1)
	local var_13_0 = {
		arg_13_0:get()
	}

	if var_0_23(var_13_0[1]) == "table" then
		var_13_0 = var_13_0[1]
	end

	arg_13_0:invoke_callback()

	for iter_13_0, iter_13_1 in var_0_19, arg_13_0.reveals do
		local var_13_1 = var_0_35(var_13_0, iter_13_0)

		for iter_13_2, iter_13_3 in var_0_19, iter_13_1 do
			local var_13_2 = false

			if arg_13_1 ~= nil then
				var_13_2 = arg_13_1 and var_13_1
			else
				var_13_2 = var_13_1
			end

			iter_13_2:set_visible(var_13_2)

			if var_13_2 == false then
				iter_13_2.get_override_default = true
			else
				iter_13_2.get_override_default = nil
			end

			iter_13_2:update_visibility(var_13_2)
		end
	end
end

function var_0_34.invoke_callback(arg_14_0)
	for iter_14_0, iter_14_1 in var_0_19, arg_14_0.callbacks do
		iter_14_1(arg_14_0)
	end
end

function var_0_34.reveal(arg_15_0, arg_15_1, arg_15_2)
	if var_0_23(arg_15_2) == "number" then
		arg_15_2 = arg_15_0:create(arg_15_2)
	elseif var_0_23(arg_15_2) == "table" and not var_0_36(arg_15_2) then
		for iter_15_0, iter_15_1 in var_0_19, arg_15_2 do
			if var_0_36(iter_15_0) then
				arg_15_0:reveal(arg_15_1, iter_15_0)
			end

			if var_0_36(iter_15_1) then
				arg_15_0:reveal(arg_15_1, iter_15_1)
			end
		end

		return
	end

	local var_15_0 = arg_15_0.reveals[arg_15_1]

	if not var_15_0 then
		var_15_0 = {}
		arg_15_0.reveals[arg_15_1] = var_15_0
	end

	var_15_0[arg_15_2] = true

	arg_15_0:update_visibility()
end

function var_0_34.create(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = var_0_28({
		reference = arg_16_1,
		reveals = {},
		callbacks = {},
		name = arg_16_2
	}, arg_16_0)

	arg_16_0.__index = arg_16_0

	return var_16_0
end

local var_0_39 = {
	rage = {
		aimbot = true,
		["weapon type"] = true,
		other = true
	},
	aa = {
		["fake lag"] = true,
		["anti-aimbot angles"] = true,
		other = true
	},
	legit = {
		aimbot = true,
		["weapon type"] = true,
		triggerbot = true,
		other = true
	},
	visuals = {
		["player esp"] = true,
		effects = true,
		["other esp"] = true,
		["colored models"] = true
	},
	misc = {
		settings = true,
		movement = true,
		miscellaneous = true
	},
	skins = {
		["weapon skin"] = true,
		["model options"] = true
	},
	players = {
		adjustments = true,
		players = true
	},
	config = {
		lua = true,
		presets = true
	},
	lua = {
		b = true,
		a = true
	}
}
local var_0_40 = {
	from_reference = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
		arg_17_1 = var_0_21(arg_17_1)
		arg_17_2 = var_0_21(arg_17_2)

		local var_17_0 = var_0_39[arg_17_1]

		if var_17_0 == nil then
			var_0_18(":from_reference received an invalid gamesense menu tab\ngot: " .. arg_17_1 .. var_0_38(var_17_0, arg_17_1))
		elseif var_17_0[arg_17_2] == nil then
			var_0_18(":from_reference received an invalid gamesense menu group\ngot: " .. arg_17_2 .. var_0_38(var_17_0[arg_17_2], arg_17_1))
		end

		local var_17_1 = {}
		local var_17_2 = {
			var_0_29(arg_17_1, arg_17_2, arg_17_3)
		}

		for iter_17_0, iter_17_1 in var_0_19, var_17_2 do
			var_17_1[#var_17_1 + 1] = var_0_34:create(iter_17_1, arg_17_3)
		end

		return var_0_24(var_17_1)
	end,
	create_tab = function(arg_18_0, arg_18_1, arg_18_2)
		arg_18_1 = var_0_21(arg_18_1)
		arg_18_2 = var_0_21(arg_18_2)

		local var_18_0 = var_0_39[arg_18_1]

		if var_18_0 == nil then
			var_0_18(":create_tab received an invalid gamesense menu tab\ngot: " .. arg_18_1 .. var_0_38(var_18_0, arg_18_1))
		elseif var_18_0[arg_18_2] == nil then
			var_0_18(":create_tab received an invalid gamesense menu group\ngot: " .. arg_18_2 .. var_0_38(var_18_0[arg_18_2], arg_18_1))
		end

		local var_18_1 = var_0_28({
			tab = var_0_21(arg_18_1),
			group = var_0_21(arg_18_2)
		}, arg_18_0)

		function arg_18_0.__index(arg_19_0, arg_19_1)
			if arg_19_1 == "reference" then
				return function(arg_20_0, arg_20_1)
					local var_20_0 = {}
					local var_20_1 = {
						var_0_29(arg_20_0.tab, arg_20_0.group, arg_20_1)
					}

					for iter_20_0, iter_20_1 in var_0_19, var_20_1 do
						var_20_0[#var_20_0 + 1] = var_0_34:create(iter_20_1, arg_20_1)
					end

					return var_0_24(var_20_0)
				end
			end

			local var_19_0 = var_0_33[arg_19_1]

			if not var_19_0 then
				return var_0_18("invalid ui object '" .. arg_19_1 .. "'" .. var_0_38(var_0_33, arg_19_1))
			end

			return function(arg_21_0, arg_21_1, ...)
				local var_21_0 = var_0_34:create(var_19_0(arg_21_0.tab, arg_21_0.group, arg_21_1, ...), arg_21_1)

				var_21_0.default = {
					var_21_0:get()
				}

				var_0_25(var_21_0.reference, function()
					var_21_0:update_visibility()
				end)

				return var_21_0
			end
		end

		return var_18_1
	end
}
local var_0_41 = {
	ONGROUND = bit.lshift(1, 0)
}
local var_0_42 = cvar.sv_gravity
local var_0_43 = var_0_42.get_float
local var_0_44 = var_0_40:create_tab("MISC", "Movement")
local var_0_45 = var_0_44:checkbox("MoveGuard")
local var_0_46 = var_0_44:checkbox("Edgebug")
local var_0_47 = var_0_44:hotkey("Edgebug", true)
local var_0_48 = var_0_44:checkbox("Tap crouch")
local var_0_49 = var_0_44:checkbox("Lock onto edgebug")
local var_0_50 = var_0_44:combobox("Lock type", "Movement", "View angles", "View angles (silent)")
local var_0_51 = var_0_44:checkbox("Lock pitch")
local var_0_52 = var_0_44:slider("Tick prediction limit", 2, 256, 128, true, "t")
local var_0_53 = var_0_44:slider("Edge detection height limit", 1, 16, 8, true, "u")
local var_0_54 = var_0_44:checkbox("Visualize prediction")
local var_0_55 = var_0_44:reference("Bunny hop")
local var_0_56 = var_0_44:checkbox("Jumpbug")
local var_0_57 = var_0_44:hotkey("Jumpbug", true)

var_0_45:reveal(true, {
	var_0_46,
	var_0_56
})
var_0_46:reveal(true, {
	var_0_47,
	var_0_48,
	var_0_49,
	var_0_54
})
var_0_49:reveal(true, {
	var_0_50,
	var_0_52,
	var_0_53
})
var_0_50:reveal("View angles", var_0_51)
var_0_56:reveal(true, var_0_57)

local var_0_58 = false
local var_0_59 = false
local var_0_60 = false
local var_0_61 = var_0_1(1, 1, 0)
local var_0_62 = {}
local var_0_63 = false
local var_0_64 = 0
local var_0_65 = var_0_1(var_0_8())
local var_0_66 = false

local function var_0_67(arg_23_0, arg_23_1)
	local var_23_0 = var_0_10()
	local var_23_1 = var_0_11(var_23_0, "m_fFlags")
	local var_23_2 = var_0_9(var_23_1, var_0_41.ONGROUND) ~= 0

	if var_23_2 then
		return var_23_2, arg_23_0.in_jump == 1
	end

	local var_23_3 = var_0_1(var_0_11(var_23_0, "m_vecOrigin"))
	local var_23_4 = var_0_1(var_0_11(var_23_0, "m_vecVelocity"))
	local var_23_5 = var_0_1(var_0_11(var_23_0, "m_vecMins")) * var_0_61
	local var_23_6 = var_0_1(var_0_11(var_23_0, "m_vecMaxs")) * var_0_61
	local var_23_7 = var_23_3
	local var_23_8 = var_0_42:get_float()
	local var_23_9 = var_0_13(arg_23_1)
	local var_23_10 = var_23_3 + var_23_4 * var_23_9

	var_23_10.z = var_23_10.z - 0.5 * var_23_8 * var_23_9^2

	local var_23_11 = var_0_0(var_23_3, var_23_10, var_23_5, var_23_6, {
		mask = "MASK_PLAYERSOLID_BRUSHONLY",
		skip = var_23_0
	}).fraction
	local var_23_12 = var_0_0(var_23_3, var_0_1(var_23_3.x, var_23_3.y, var_23_10.z), var_23_5, var_23_6, {
		mask = "MASK_PLAYERSOLID_BRUSHONLY",
		skip = var_23_0
	}).fraction
	local var_23_13 = var_0_0(var_23_3, var_0_1(var_23_10.x, var_23_10.y, var_23_3.z), var_23_5, var_23_6, {
		mask = "MASK_PLAYERSOLID_BRUSHONLY",
		skip = var_23_0
	}).fraction

	return var_23_2, var_23_11 ~= 1 and var_0_12(var_23_11 * 1000) ~= var_0_12(var_23_13 * 1000) or var_23_11 ~= 1 and var_23_12 ~= 1
end

var_0_56:register_event_callback("setup_command", function(arg_24_0)
	local var_24_0, var_24_1 = var_0_67(arg_24_0, 2)

	if var_24_0 == false and var_24_1 == true and var_0_59 == false then
		if var_0_57:get() then
			arg_24_0.in_duck = 1
			var_0_59 = true
		end
	elseif var_0_59 then
		var_0_55:set(false)

		arg_24_0.in_jump = 1
		var_0_59 = false
	else
		var_0_55:set(true)
	end

	if var_0_60 and var_24_0 and arg_24_0.in_jump == 1 and var_0_58 == 1 then
		arg_24_0.in_jump = 0
	end

	var_0_58 = arg_24_0.in_jump
	var_0_60 = var_24_0
end)

local function var_0_68(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = var_0_1(var_0_11(arg_25_0, "m_vecOrigin"))
	local var_25_1 = var_0_1(var_0_11(arg_25_0, "m_vecVelocity"))
	local var_25_2 = var_0_1(var_0_11(arg_25_0, "m_vecMins")) * var_0_61
	local var_25_3 = var_0_1(var_0_11(arg_25_0, "m_vecMaxs")) * var_0_61
	local var_25_4 = var_0_43(var_0_42)
	local var_25_5 = var_0_7()
	local var_25_6 = var_25_0
	local var_25_7 = var_0_1()
	local var_25_8 = 0

	for iter_25_0 = 1, arg_25_1 do
		local var_25_9 = var_25_0 + var_25_1 * var_25_5 * iter_25_0

		var_25_9.z = var_25_9.z - 0.5 * var_25_4 * (var_25_5 * iter_25_0)^2

		if arg_25_2 then
			if var_25_7.x == 0 then
				local var_25_10 = var_0_0(var_25_6, var_0_1(var_25_9.x, var_25_6.y, var_25_6.z), var_25_2, var_25_3, {
					mask = "MASK_PLAYERSOLID_BRUSHONLY",
					skip = arg_25_0
				})

				if var_25_10.fraction ~= 1 then
					var_25_7.x = var_25_10.end_pos.x
				end
			end

			if var_25_7.y == 0 then
				local var_25_11 = var_0_0(var_25_6, var_0_1(var_25_6.x, var_25_9.y, var_25_6.z), var_25_2, var_25_3, {
					mask = "MASK_PLAYERSOLID_BRUSHONLY",
					skip = arg_25_0
				})

				if var_25_11.fraction ~= 1 then
					var_25_7.y = var_25_11.end_pos.y
				end
			end

			local var_25_12 = var_0_0(var_25_6, var_0_1(var_25_6.x, var_25_6.y, var_25_9.z), var_25_2, var_25_3, {
				mask = "MASK_PLAYERSOLID_BRUSHONLY",
				skip = arg_25_0
			})

			if var_25_12.fraction ~= 1 then
				var_25_7.z = var_25_12.end_pos.z

				if var_25_7.z <= var_25_6.z then
					var_25_6 = var_25_9

					break
				end
			end

			var_25_6 = var_25_9
		end

		var_25_8 = iter_25_0
	end

	if var_25_7.x == 0 then
		var_25_7.x = var_25_6.x
	end

	if var_25_7.y == 0 then
		var_25_7.y = var_25_6.y
	end

	return var_25_7, var_25_8
end

var_0_54:register_event_callback("paint", function()
	for iter_26_0, iter_26_1 in var_0_3, var_0_62 do
		var_0_16(var_0_2(iter_26_1))
	end
end)
var_0_46:register_event_callback("override_view", function(arg_27_0)
	if not var_0_47:get() then
		return
	end

	if not var_0_66 then
		return
	end

	if var_0_51:get() then
		var_0_8(var_0_65.x, var_0_65.y)
	else
		var_0_8(arg_27_0.pitch, var_0_65.y)
	end
end)
var_0_46:register_event_callback("setup_command", function(arg_28_0)
	var_0_62 = {}

	if not var_0_47:get() then
		return
	end

	var_0_65 = var_0_1(arg_28_0.pitch, arg_28_0.yaw)

	local var_28_0 = var_0_10()
	local var_28_1 = var_0_11(var_28_0, "m_fFlags")

	if var_0_9(var_28_1, var_0_41.ONGROUND) ~= 0 then
		return
	end

	local var_28_2 = var_0_52:get()
	local var_28_3, var_28_4 = var_0_68(var_28_0, var_28_2, true)

	if var_28_4 == var_28_2 then
		return
	end

	local var_28_5 = var_0_1(var_0_11(var_28_0, "m_vecOrigin"))
	local var_28_6 = var_0_1(var_0_11(var_28_0, "m_vecVelocity"))
	local var_28_7 = var_0_43(var_0_42)
	local var_28_8 = var_0_7()
	local var_28_9 = var_28_8
	local var_28_10 = var_28_3 + var_28_6 * var_28_9

	var_28_10.z = var_28_3.z - 0.5 * var_28_7 * var_28_9^2

	local var_28_11 = var_28_3 + var_28_6 * (var_28_8 - var_28_9)

	var_28_11.z = var_28_3.z - 0.5 * var_28_7 * (var_28_8 - var_28_9)^2

	local var_28_12 = var_0_1(var_0_11(var_28_0, "m_vecMins")) * var_0_61
	local var_28_13 = var_0_1(var_0_11(var_28_0, "m_vecMaxs")) * var_0_61
	local var_28_14 = var_0_1(0, 0, var_0_53:get())
	local var_28_15 = var_0_0(var_28_10, var_28_10 - var_28_14, var_28_12, var_28_13, {
		mask = "MASK_PLAYERSOLID_BRUSHONLY",
		skip = var_28_0
	}).fraction == 1
	local var_28_16 = var_0_0(var_28_11, var_28_11 - var_28_14, var_28_12, var_28_13, {
		mask = "MASK_PLAYERSOLID_BRUSHONLY",
		skip = var_28_0
	}).fraction == 1

	if var_0_54:get() then
		var_0_62[#var_0_62 + 1] = {
			var_28_10 - var_28_14,
			var_28_12,
			var_28_13,
			var_28_15 and 255 or 0,
			var_28_15 and 0 or 255,
			0,
			255
		}
		var_0_62[#var_0_62 + 1] = {
			var_28_11 - var_28_14,
			var_28_12,
			var_28_13,
			var_28_16 and 255 or 0,
			var_28_16 and 0 or 255,
			0,
			255
		}
	end

	if var_28_15 and var_28_16 then
		if var_0_49:get() then
			arg_28_0.sidemove = 0
			arg_28_0.forwardmove = 0

			local var_28_17 = var_0_50:get()

			if var_28_17 == "View angles" then
				var_0_66 = true
			elseif var_28_17 == "View angles (silent)" then
				var_0_63 = true

				if var_0_51:get() then
					arg_28_0.pitch = var_0_65.x
				end

				arg_28_0.yaw = var_0_65.y
			end
		end

		var_0_64 = arg_28_0.command_number + var_28_4 - 1
	else
		var_0_65 = var_0_1(arg_28_0.pitch, arg_28_0.yaw)
		var_0_63 = false
		var_0_66 = false
	end

	if var_0_64 == arg_28_0.command_number and var_0_48:get() then
		arg_28_0.in_duck = 1
	end
end)
