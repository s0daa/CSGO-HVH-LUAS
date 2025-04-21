local var_0_0 = assert
local var_0_1 = bit.band
local var_0_2 = globals.curtime
local var_0_3 = globals.tickcount
local var_0_4 = globals.tickinterval
local var_0_5 = math.abs
local var_0_6 = math.floor
local var_0_7 = math.fmod
local var_0_8 = math.max
local var_0_9 = math.min
local var_0_10 = math.pow
local var_0_11 = table.remove
local var_0_12 = unpack
local var_0_13 = setmetatable
local var_0_14 = type
local var_0_15 = require("ffi")
local var_0_16 = require("vector")
local var_0_17 = require("gamesense/entity")
local var_0_18 = client.find_signature("engine.dll", "\xFF\xE2")

local function var_0_19(arg_1_0, arg_1_1)
	local var_1_0 = var_0_15.typeof(arg_1_1)

	return function(arg_2_0, ...)
		var_0_0(arg_2_0 ~= nil)

		if arg_2_0 then
			return var_0_15.cast(var_1_0, var_0_18)(arg_2_0, var_0_15.cast("void***", arg_2_0)[0][arg_1_0], ...)
		end
	end
end

local var_0_20 = vtable_thunk(442, "float(__thiscall*)(void*)")

local function var_0_21(arg_3_0, arg_3_1, arg_3_2)
	return var_0_8(arg_3_1, var_0_9(arg_3_2, arg_3_0))
end

local function var_0_22(arg_4_0)
	return 0.0054931640625 * var_0_1(var_0_6(arg_4_0 * 182.04444444444445), 65535)
end

local function var_0_23(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0 = var_0_22(arg_5_0)
	arg_5_1 = var_0_22(arg_5_1)

	local var_5_0 = arg_5_0 - arg_5_1

	if arg_5_2 < 0 then
		arg_5_2 = -arg_5_2
	end

	if var_5_0 < -180 then
		var_5_0 = var_5_0 + 360
	elseif var_5_0 > 180 then
		var_5_0 = var_5_0 - 360
	end

	if arg_5_2 < var_5_0 then
		arg_5_1 = arg_5_1 + arg_5_2
	elseif var_5_0 < -arg_5_2 then
		arg_5_1 = arg_5_1 - arg_5_2
	else
		arg_5_1 = arg_5_0
	end

	return arg_5_1
end

local function var_0_24(arg_6_0)
	while arg_6_0 > 180 do
		arg_6_0 = arg_6_0 - 360
	end

	while arg_6_0 < -180 do
		arg_6_0 = arg_6_0 + 360
	end

	return arg_6_0
end

local function var_0_25(arg_7_0, arg_7_1)
	local var_7_0 = var_0_7(arg_7_0 - arg_7_1, 360)

	if arg_7_1 < arg_7_0 then
		if var_7_0 >= 180 then
			var_7_0 = var_7_0 - 360
		end
	elseif var_7_0 <= -180 then
		var_7_0 = var_7_0 + 360
	end

	return var_7_0
end

local function var_0_26(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1 - arg_8_2
	local var_8_1 = var_8_0:length()

	if var_8_1 <= arg_8_0 then
		if var_8_1 >= -arg_8_0 then
			return arg_8_1
		else
			return arg_8_2 - var_8_0 * (1 / (var_8_1 + 1.1920929e-07)) * arg_8_0
		end
	else
		return arg_8_2 + var_8_0 * (1 / (var_8_1 + 1.1920929e-07)) * arg_8_0
	end
end

local var_0_27 = var_0_19(145, "void(__fastcall*)(void*, void*, float*)")
local var_0_28 = {
	desync = 0,
	desync_exact = 0,
	server_feet_yaw = 0,
	feet_yaw = 0,
	abs_yaw = 0,
	tickbase = {
		phase_tickbase = 0,
		last_tickbase = 0,
		shifting = 0,
		list = (function()
			local var_9_0 = {}
			local var_9_1 = 16

			for iter_9_0 = 1, var_9_1 do
				var_9_0[#var_9_0 + 1] = 0

				if iter_9_0 == var_9_1 then
					return var_9_0
				end
			end
		end)()
	},
	balance_adjust = {
		next_update = 0,
		updating = false
	}
}
local var_0_29 = var_0_15.new("float[3]")
local var_0_30 = var_0_28
local var_0_31 = 0
local var_0_32 = 0
local var_0_33 = 0
local var_0_34
local var_0_35
local var_0_36 = var_0_15.typeof("void***")

local function var_0_37(arg_10_0)
	local var_10_0 = var_0_2()
	local var_10_1 = var_0_4()
	local var_10_2 = var_0_17.get_local_player()

	if var_10_2 == nil then
		return
	end

	local var_10_3 = var_10_2:get_anim_state()

	if var_10_3.anim_update_timer <= 0 then
		var_0_31, var_0_32, var_0_33 = 0, 0, 0
		var_0_34, var_0_35 = nil
		var_0_28 = var_0_30

		return
	end

	if var_0_34 == nil or var_0_35 == nil then
		var_0_34 = var_10_3.eye_angles_y
		var_0_35 = var_10_3.goal_feet_yaw
	end

	if arg_10_0.chokedcommands == 0 then
		var_0_31 = var_10_3.stop_to_full_running_fraction
		var_0_32 = var_10_3.duck_amount
		var_0_34 = var_10_3.eye_angles_y

		var_0_27(var_10_2, var_0_29)

		local var_10_4 = var_0_16(var_0_29[0], var_0_29[1], var_0_29[2])
		local var_10_5 = var_0_16(var_10_2:get_prop("m_vecVelocity"))

		if var_10_4:lengthsqr() > var_0_10(312, 2) then
			var_10_4 = var_10_4:normalized() * 312
		end

		var_10_4.z = 0

		local var_10_6 = var_0_26(var_10_1 * 2000, var_10_4, var_10_5)

		var_0_33 = var_0_9(var_10_6:length(), 260)
	end

	local var_10_7 = var_10_2:get_anim_overlay(3)
	local var_10_8 = var_10_2:get_player_weapon()
	local var_10_9 = var_10_8 and var_0_8(var_0_20(var_0_15.cast(var_0_36, var_10_8)), 0.001) or 260
	local var_10_10 = var_0_21(var_0_33 / (var_10_9 * 0.52), 0, 1)
	local var_10_11 = (var_0_31 * -0.3 - 0.2) * var_10_10 + 1

	if var_0_32 > 0 then
		local var_10_12 = var_0_21(var_0_33 / (var_10_9 * 0.34), 0, 1)

		var_10_11 = var_10_11 + var_0_32 * var_10_12 * (0.5 - var_10_11)
	end

	var_0_35 = var_0_21(var_0_35, -360, 360)

	local var_10_13 = var_0_25(var_0_34, var_0_35)
	local var_10_14 = var_10_11 * 58
	local var_10_15 = var_10_11 * -58

	if var_10_13 <= var_10_14 then
		if var_10_13 < var_10_15 then
			var_0_35 = var_0_5(var_10_15) + var_0_34
		end
	else
		var_0_35 = var_0_34 - var_0_5(var_10_14)
	end

	if var_0_33 > 0.1 then
		var_0_35 = var_0_23(var_0_34, var_0_24(var_0_35), (var_0_31 * 20 + 30) * var_10_1)
	else
		var_0_35 = var_0_23(var_10_2:get_prop("m_flLowerBodyYawTarget"), var_0_24(var_0_35), var_10_1 * 100)
	end

	if not var_0_28.balance_adjust.updating then
		var_0_28.balance_adjust.next_update = var_10_0 + 0.22
	elseif var_10_2:get_sequence_activity(var_10_7.sequence) == 979 and var_10_0 > var_0_28.balance_adjust.next_update and var_10_7.weight > 0 then
		var_0_28.balance_adjust.next_update = var_10_0 + 1.1
	end

	if arg_10_0.chokedcommands == 0 then
		local var_10_16 = var_0_5(var_0_25(var_10_3.eye_angles_y, var_10_3.goal_feet_yaw))

		var_0_28.balance_adjust.updating = var_10_3.on_ground and var_10_3.m_velocity < 0.1 and var_10_3.anim_update_timer > 0
		var_0_28.abs_yaw = var_10_3.eye_angles_y
		var_0_28.feet_yaw = var_10_3.goal_feet_yaw
		var_0_28.server_feet_yaw = var_0_35
		var_0_28.desync_exact = var_0_25(var_0_35, var_10_3.goal_feet_yaw)
		var_0_28.desync = var_0_21(var_0_28.desync_exact, -var_10_16, var_10_16)
	end
end

local function var_0_38()
	local var_11_0 = var_0_17.get_local_player()

	if var_11_0 == nil or not var_11_0:is_alive() then
		return
	end

	local var_11_1 = var_11_0:get_prop("m_flSimulationTime")

	if var_11_1 == nil then
		return
	end

	local var_11_2 = var_0_3()
	local var_11_3 = var_0_8(var_0_12(var_0_28.tickbase.list))
	local var_11_4 = var_11_3 < 0 and var_0_5(var_11_3) or 0

	if var_11_4 <= 0 then
		var_0_28.tickbase.shifting = 0
		var_0_28.tickbase.last_tickbase = 0
		var_0_28.tickbase.phase_tickbase = 0
	else
		if var_0_28.tickbase.phase_tickbase == 0 or var_11_4 > var_0_28.tickbase.shifting then
			var_0_28.tickbase.shifting = var_11_4
		end

		if var_11_4 < var_0_28.tickbase.last_tickbase then
			var_0_28.tickbase.shifting = var_0_28.tickbase.last_tickbase
			var_0_28.tickbase.phase_tickbase = 1
		end

		var_0_28.tickbase.last_tickbase = var_11_4
	end

	var_0_28.tickbase.list[#var_0_28.tickbase.list + 1] = var_11_1 / var_0_4() - var_11_2

	var_0_11(var_0_28.tickbase.list, 1)
end

client.set_event_callback("setup_command", var_0_37)
client.set_event_callback("net_update_start", var_0_38)

local var_0_39 = {}

local function var_0_40(arg_12_0, ...)
	local var_12_0 = {}
	local var_12_1 = {
		...
	}

	for iter_12_0 = 1, #var_12_1 do
		var_12_0[#var_12_0 + 1] = var_12_1[iter_12_0]
	end

	if var_12_0[arg_12_0] == nil then
		return var_0_12(var_12_1)
	end

	return var_12_0[arg_12_0]
end

local function var_0_41(arg_13_0)
	return var_0_2() - arg_13_0 * var_0_4()
end

local function var_0_42()
	local var_14_0 = var_0_17.get_local_player()

	if var_14_0 == nil or not var_14_0:is_alive() then
		return
	end

	local var_14_1 = var_14_0:get_player_weapon()

	if var_14_1 == nil then
		return false
	end

	if var_0_41(16) < var_14_0:get_prop("m_flNextAttack") then
		return false
	end

	if var_0_41(0) < var_14_1:get_prop("m_flNextPrimaryAttack") then
		return false
	end

	return true
end

return {
	approach_angle = function(arg_15_0, arg_15_1, arg_15_2)
		return var_0_23(arg_15_0, arg_15_1, arg_15_2)
	end,
	angle_diff = function(arg_16_0, arg_16_1)
		return var_0_25(arg_16_0, arg_16_1)
	end,
	normalize_angle = function(arg_17_0)
		return var_0_24(arg_17_0)
	end,
	get_abs_yaw = function()
		return var_0_28.abs_yaw
	end,
	get_balance_adjust = function()
		return var_0_28.balance_adjust
	end,
	get_body_yaw = function(arg_20_0)
		return var_0_40(arg_20_0, var_0_28.feet_yaw, var_0_28.server_feet_yaw)
	end,
	get_desync = function(arg_21_0)
		return var_0_40(arg_21_0, var_0_28.desync, var_0_28.desync_exact)
	end,
	get_tickbase_shifting = function()
		return var_0_28.tickbase.shifting
	end,
	get_double_tap = function()
		return var_0_42() and var_0_28.tickbase.shifting > 0
	end,
	get_overlap = function(arg_24_0)
		local var_24_0 = var_0_28.feet_yaw
		local var_24_1 = var_0_28.server_feet_yaw
		local var_24_2 = var_0_25(var_0_28.abs_yaw, var_0_28.feet_yaw)

		if var_0_14(arg_24_0) == "number" then
			local var_24_3 = var_0_5(var_24_2)

			var_24_0 = var_0_21(arg_24_0, var_0_28.abs_yaw - var_24_3, var_0_28.abs_yaw + var_24_3)
		end

		if arg_24_0 == true then
			var_24_0 = var_0_28.abs_yaw + var_24_2
		end

		return 1 - var_0_5(var_0_25(var_24_0, var_24_1)) / 120 * 1, var_24_0
	end
}
