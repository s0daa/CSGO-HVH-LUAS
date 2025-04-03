local var_0_0 = client.set_event_callback
local var_0_1 = entity.get_local_player
local var_0_2 = entity.get_player_weapon
local var_0_3 = entity.get_prop
local var_0_4 = math.abs
local var_0_5 = math.atan2
local var_0_6 = math.ceil
local var_0_7 = math.cos
local var_0_8 = math.floor
local var_0_9 = math.max
local var_0_10 = math.sin
local var_0_11 = math.sqrt
local var_0_12 = ui.get
local var_0_13 = ui.new_combobox
local var_0_14 = ui.reference
local var_0_15 = ui.set
local var_0_16 = ui.set_visible
local var_0_17 = var_0_14("AA", "Fake lag", "Limit")
local var_0_18 = var_0_14("AA", "Fake lag", "Variance")
local var_0_19, var_0_20 = var_0_14("AA", "Other", "Slow motion")
local var_0_21 = var_0_14("AA", "Anti-aimbot angles", "Fake yaw limit")
local var_0_22 = var_0_14("AA", "Other", "On shot anti-aim")
local var_0_23 = var_0_14("Misc", "Movement", "Fast walk")
local var_0_24 = var_0_13("AA", "Anti-aimbot angles", "Fakewalk mode", {
	"Opposite",
	"Extend",
	"Jitter"
})

local function var_0_25(arg_1_0, arg_1_1, arg_1_2)
	return {
		x = arg_1_0 or 0,
		y = arg_1_1 or 0,
		z = arg_1_2 or 0
	}
end

local function var_0_26(arg_2_0)
	return arg_2_0 * (math.pi / 180)
end

local function var_0_27(arg_3_0, arg_3_1)
	if arg_3_0.x == 0 and arg_3_0.y == 0 then
		if arg_3_0.z > 0 then
			arg_3_1.x = -90
		else
			arg_3_1.x = 90
		end

		arg_3_1.y = 0
	else
		arg_3_1.x = var_0_5(-arg_3_0.z, var_0_11(arg_3_0.x * arg_3_0.x + arg_3_0.y * arg_3_0.y)) * (180 / math.pi)
		arg_3_1.y = var_0_5(arg_3_0.y, arg_3_0.x) * (180 / math.pi)
	end

	arg_3_1.z = 0
end

local function var_0_28(arg_4_0, arg_4_1)
	local var_4_0 = var_0_10(var_0_26(arg_4_0.x))
	local var_4_1 = var_0_7(var_0_26(arg_4_0.x))
	local var_4_2 = var_0_10(var_0_26(arg_4_0.y))

	arg_4_1.x = var_4_1 * var_0_7(var_0_26(arg_4_0.y))
	arg_4_1.y = var_4_1 * var_4_2
	arg_4_1.z = -var_4_0
end

function round(arg_5_0)
	return arg_5_0 >= 0 and var_0_8(arg_5_0 + 0.5) or var_0_6(arg_5_0 - 0.5)
end

local function var_0_29(arg_6_0)
	if arg_6_0 > 180 or arg_6_0 < -180 then
		local var_6_0 = round(var_0_4(arg_6_0 / 360))

		if arg_6_0 < 0 then
			arg_6_0 = arg_6_0 + 360 * var_6_0
		else
			arg_6_0 = arg_6_0 - 360 * var_6_0
		end
	end

	return arg_6_0
end

local function var_0_30(arg_7_0)
	local var_7_0 = var_0_25(var_0_3(var_0_1(), "m_vecVelocity"))
	local var_7_1 = var_0_11(var_7_0.x * var_7_0.x + var_7_0.y * var_7_0.y)
	local var_7_2 = var_0_25(0, 0, 0)

	var_0_27(var_7_0, var_7_2)

	var_7_2.y = arg_7_0.yaw - var_7_2.y

	local var_7_3 = var_0_25(0, 0, 0)

	var_0_28(var_7_2, var_7_3)

	local var_7_4 = 450 / var_0_9(var_0_4(arg_7_0.forwardmove), var_0_4(arg_7_0.sidemove))
	local var_7_5 = var_0_25(var_7_3.x * -var_7_4, var_7_3.y * -var_7_4, var_7_3.z * -var_7_4)

	arg_7_0.forwardmove = var_7_5.x
	arg_7_0.sidemove = var_7_5.y
end

local var_0_31 = 0
local var_0_32 = ""

local function var_0_33()
	local var_8_0 = var_0_2(var_0_1())
	local var_8_1 = var_0_3(var_0_1(), "m_bIsScoped")

	if var_0_32 == "deagle" or var_0_32 == "aug" and var_8_1 == 1 then
		return 10
	end

	if var_0_32 == "negev" or var_0_32 == "sg556" and var_8_1 == 1 then
		return 9
	end

	return 8
end

local var_0_34 = false
local var_0_35 = var_0_12(var_0_22)
local var_0_36 = var_0_12(var_0_17)
local var_0_37 = var_0_12(var_0_18)
local var_0_38 = var_0_12(var_0_23)
local var_0_39 = 0

var_0_0("setup_command", function(arg_9_0)
	if var_0_12(var_0_19) then
		return
	end

	if not var_0_12(var_0_20) then
		if var_0_34 and var_0_36 > 0 then
			var_0_15(var_0_22, var_0_35)
			var_0_15(var_0_17, var_0_36)
			var_0_15(var_0_18, var_0_37)
			var_0_15(var_0_23, var_0_38)
		end

		var_0_35 = var_0_12(var_0_22)
		var_0_36 = var_0_12(var_0_17)
		var_0_37 = var_0_12(var_0_18)
		var_0_38 = var_0_12(var_0_23)
		var_0_34 = false

		return
	end

	local var_9_0 = var_0_25(var_0_3(var_0_1(), "m_angEyeAngles"))
	local var_9_1 = var_0_25(var_0_3(var_0_1(), "m_angAbsRotation"))
	local var_9_2 = var_0_29(var_9_1.y - var_9_0.y) > 0 and -1 or 1
	local var_9_3 = var_0_25(var_0_3(var_0_1(), "m_vecVelocity"))
	local var_9_4 = var_0_11(var_9_3.x * var_9_3.x + var_9_3.y * var_9_3.y)

	var_0_34 = true

	var_0_15(var_0_22, false)
	var_0_15(var_0_17, 14)
	var_0_15(var_0_18, 0)
	var_0_15(var_0_23, true)

	local var_9_5 = var_0_33()

	if arg_9_0.chokedcommands >= var_0_12(var_0_17) - var_9_5 and (arg_9_0.forwardmove ~= 0 or arg_9_0.sidemove ~= 0) then
		var_0_30(arg_9_0)
	end

	if arg_9_0.chokedcommands == var_0_12(var_0_17) - 3 then
		if var_9_4 <= 0 then
			arg_9_0.forwardmove = -1.01
		end

		var_0_39 = var_0_39 + 1

		if var_0_12(var_0_24) == "Opposite" then
			arg_9_0.yaw = var_0_29(var_9_0.y + 60 * var_9_2)
		elseif var_0_12(var_0_24) == "Extend" then
			arg_9_0.yaw = var_0_29(var_9_0.y + 90 * var_9_2)
		elseif var_0_12(var_0_24) == "Jitter" then
			arg_9_0.yaw = var_0_29(var_9_0.y + 60 * (var_0_39 % 2 == 0 and -1 or 1))
		end
	end
end)
var_0_0("item_equip", function(arg_10_0)
	var_0_32 = arg_10_0.item
	var_0_31 = arg_10_0.weptype
end)
var_0_0("pre_render", function()
	var_0_16(var_0_24, not var_0_12(var_0_19) and true or false)
end)
