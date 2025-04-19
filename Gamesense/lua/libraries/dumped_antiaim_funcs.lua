slot0 = assert
slot1 = bit.band
slot2 = globals.curtime
slot3 = globals.tickcount
slot4 = globals.tickinterval
slot5 = math.abs
slot6 = math.floor
slot7 = math.fmod
slot8 = math.max
slot9 = math.min
slot10 = math.pow
slot11 = table.remove
slot12 = unpack
slot13 = setmetatable
slot14 = type
slot15 = require("ffi")
slot16 = require("vector")
slot17 = require("gamesense/entity")
slot18 = client.find_signature("engine.dll", "\\xff\\xe2")
slot20 = vtable_thunk(442, "float(__thiscall*)(void*)")

function slot21(slot0, slot1, slot2)
	return uv0(slot1, uv1(slot2, slot0))
end

function slot22(slot0)
	return 0.0054931640625 * uv0(uv1(slot0 * 182.04444444444445), 65535)
end

function slot23(slot0, slot1, slot2)
	slot3 = uv0(slot0) - uv0(slot1)

	if slot2 < 0 then
		slot2 = -slot2
	end

	if slot3 < -180 then
		slot3 = slot3 + 360
	elseif slot3 > 180 then
		slot3 = slot3 - 360
	end

	return slot2 < slot3 and slot1 + slot2 or slot3 < -slot2 and slot1 - slot2 or slot0
end

function slot24(slot0)
	while slot0 > 180 do
		slot0 = slot0 - 360
	end

	while slot0 < -180 do
		slot0 = slot0 + 360
	end

	return slot0
end

function slot25(slot0, slot1)
	slot2 = uv0(slot0 - slot1, 360)

	if slot1 < slot0 then
		if slot2 >= 180 then
			slot2 = slot2 - 360
		end
	elseif slot2 <= -180 then
		slot2 = slot2 + 360
	end

	return slot2
end

function slot26(slot0, slot1, slot2)
	if (slot1 - slot2):length() <= slot0 then
		if slot4 >= -slot0 then
			return slot1
		else
			return slot2 - slot3 * 1 / (slot4 + 1.1920929e-07) * slot0
		end
	else
		return slot2 + slot3 * 1 / (slot4 + 1.1920929e-07) * slot0
	end
end

slot27 = function (slot0, slot1)
	slot2 = uv0.typeof(slot1)

	return function (slot0, ...)
		uv0(slot0 ~= nil)

		if slot0 then
			return uv1.cast(uv2, uv3)(slot0, uv1.cast("void***", slot0)[0][uv4], ...)
		end
	end
end(145, "void(__fastcall*)(void*, void*, float*)")
slot29 = slot15.new("float[3]")
slot30 = {
	desync = 0,
	desync_exact = 0,
	server_feet_yaw = 0,
	feet_yaw = 0,
	abs_yaw = 0,
	tickbase = {
		phase_tickbase = 0,
		last_tickbase = 0,
		shifting = 0,
		list = function ()
			slot0 = {}

			for slot5 = 1, 16 do
				slot0[#slot0 + 1] = 0

				if slot5 == slot1 then
					return slot0
				end
			end
		end()
	},
	balance_adjust = {
		next_update = 0,
		updating = false
	}
}
slot31 = 0
slot32 = 0
slot33 = 0
slot34, slot35 = nil
slot36 = slot15.typeof("void***")

client.set_event_callback("setup_command", function (slot0)
	slot1 = uv0()
	slot2 = uv1()

	if uv2.get_local_player() == nil then
		return
	end

	if slot3:get_anim_state().anim_update_timer <= 0 then
		uv5 = 0
		uv4 = 0
		uv3 = 0
		uv7 = nil
		uv6 = nil
		uv8 = uv9

		return
	end

	if uv6 == nil or uv7 == nil then
		uv6 = slot4.eye_angles_y
		uv7 = slot4.goal_feet_yaw
	end

	if slot0.chokedcommands == 0 then
		uv3 = slot4.stop_to_full_running_fraction
		uv4 = slot4.duck_amount
		uv6 = slot4.eye_angles_y

		uv10(slot3, uv11)

		slot6 = uv12(slot3:get_prop("m_vecVelocity"))

		if uv13(312, 2) < uv12(uv11[0], uv11[1], uv11[2]):lengthsqr() then
			slot5 = slot5:normalized() * 312
		end

		slot5.z = 0
		uv5 = uv15(uv14(slot2 * 2000, slot5, slot6):length(), 260)
	end

	slot5 = slot3:get_anim_overlay(3)
	slot9 = (uv3 * -0.3 - 0.2) * uv20(uv5 / ((slot3:get_player_weapon() and uv16(uv17(uv18.cast(uv19, slot6)), 0.001) or 260) * 0.52), 0, 1) + 1

	if uv4 > 0 then
		slot9 = slot9 + uv4 * uv20(uv5 / (slot7 * 0.34), 0, 1) * (0.5 - slot9)
	end

	uv7 = uv20(uv7, -360, 360)
	slot12 = slot9 * -58

	if uv21(uv6, uv7) <= slot9 * 58 then
		if slot10 < slot12 then
			uv7 = uv22(slot12) + uv6
		end
	else
		uv7 = uv6 - uv22(slot11)
	end

	if uv5 > 0.1 then
		uv7 = uv23(uv6, uv24(uv7), (uv3 * 20 + 30) * slot2)
	else
		uv7 = uv23(slot3:get_prop("m_flLowerBodyYawTarget"), uv24(uv7), slot2 * 100)
	end

	if not uv8.balance_adjust.updating then
		uv8.balance_adjust.next_update = slot1 + 0.22
	elseif slot3:get_sequence_activity(slot5.sequence) == 979 and uv8.balance_adjust.next_update < slot1 and slot5.weight > 0 then
		uv8.balance_adjust.next_update = slot1 + 1.1
	end

	if slot0.chokedcommands == 0 then
		slot13 = uv22(uv21(slot4.eye_angles_y, slot4.goal_feet_yaw))
		uv8.balance_adjust.updating = slot4.on_ground and slot4.m_velocity < 0.1 and slot4.anim_update_timer > 0
		uv8.abs_yaw = slot4.eye_angles_y
		uv8.feet_yaw = slot4.goal_feet_yaw
		uv8.server_feet_yaw = uv7
		uv8.desync_exact = uv21(uv7, slot4.goal_feet_yaw)
		uv8.desync = uv20(uv8.desync_exact, -slot13, slot13)
	end
end)
client.set_event_callback("net_update_start", function ()
	if uv0.get_local_player() == nil or not slot0:is_alive() then
		return
	end

	if slot0:get_prop("m_flSimulationTime") == nil then
		return
	end

	slot2 = uv1()

	if (uv2(uv3(uv4.tickbase.list)) < 0 and uv5(slot3) or 0) <= 0 then
		uv4.tickbase.shifting = 0
		uv4.tickbase.last_tickbase = 0
		uv4.tickbase.phase_tickbase = 0
	else
		if uv4.tickbase.phase_tickbase == 0 or uv4.tickbase.shifting < slot4 then
			uv4.tickbase.shifting = slot4
		end

		if slot4 < uv4.tickbase.last_tickbase then
			uv4.tickbase.shifting = uv4.tickbase.last_tickbase
			uv4.tickbase.phase_tickbase = 1
		end

		uv4.tickbase.last_tickbase = slot4
	end

	uv4.tickbase.list[#uv4.tickbase.list + 1] = slot1 / uv6() - slot2

	uv7(uv4.tickbase.list, 1)
end)

slot39 = {}

function slot40(slot0, ...)
	slot1 = {}

	for slot6 = 1, #{
		...
	} do
		slot1[#slot1 + 1] = slot2[slot6]
	end

	if slot1[slot0] == nil then
		return uv0(slot2)
	end

	return slot1[slot0]
end

function slot41(slot0)
	return uv0() - slot0 * uv1()
end

function slot42()
	if uv0.get_local_player() == nil or not slot0:is_alive() then
		return
	end

	if slot0:get_player_weapon() == nil then
		return false
	end

	if uv1(16) < slot0:get_prop("m_flNextAttack") then
		return false
	end

	if uv1(0) < slot1:get_prop("m_flNextPrimaryAttack") then
		return false
	end

	return true
end

return {
	approach_angle = function (slot0, slot1, slot2)
		return uv0(slot0, slot1, slot2)
	end,
	angle_diff = function (slot0, slot1)
		return uv0(slot0, slot1)
	end,
	normalize_angle = function (slot0)
		return uv0(slot0)
	end,
	get_abs_yaw = function ()
		return uv0.abs_yaw
	end,
	get_balance_adjust = function ()
		return uv0.balance_adjust
	end,
	get_body_yaw = function (slot0)
		return uv0(slot0, uv1.feet_yaw, uv1.server_feet_yaw)
	end,
	get_desync = function (slot0)
		return uv0(slot0, uv1.desync, uv1.desync_exact)
	end,
	get_tickbase_shifting = function ()
		return uv0.tickbase.shifting
	end,
	get_double_tap = function ()
		return uv0() and uv1.tickbase.shifting > 0
	end,
	get_overlap = function (slot0)
		slot1 = uv0.feet_yaw
		slot2 = uv0.server_feet_yaw

		if uv2(slot0) == "number" then
			slot4 = uv3(uv1(uv0.abs_yaw, uv0.feet_yaw))
			slot1 = uv4(slot0, uv0.abs_yaw - slot4, uv0.abs_yaw + slot4)
		end

		if slot0 == true then
			slot1 = uv0.abs_yaw + slot3
		end

		return 1 - uv3(uv1(slot1, slot2)) / 120 * 1, slot1
	end
}
