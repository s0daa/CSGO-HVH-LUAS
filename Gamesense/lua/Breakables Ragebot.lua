local var_0_0 = require("vector")
local var_0_1 = require("gamesense/csgo_weapons")
local var_0_2 = ui.new_checkbox("MISC", "Miscellaneous", "Breakables Ragebot")
local var_0_3 = true
local var_0_4 = false

local function var_0_5(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if iter_1_1 == arg_1_1 then
			return true
		end
	end

	return false
end

local var_0_6 = false
local var_0_7 = {}
local var_0_8 = {
	"taser",
	"grenade",
	"c4"
}
local var_0_9 = 64

local function var_0_10(arg_2_0)
	if entity.get_prop(arg_2_0, "m_nModelIndex") == 824 then
		local var_2_0 = var_0_0(entity.get_origin(arg_2_0))

		var_2_0.x = var_2_0.x - 15

		return var_2_0
	end

	local var_2_1 = var_0_0(entity.get_origin(arg_2_0))
	local var_2_2 = var_0_0(entity.get_prop(arg_2_0, "m_vecMins"))
	local var_2_3 = var_0_0(entity.get_prop(arg_2_0, "m_vecMaxs"))

	return var_2_1 + (var_2_2 / 2 + var_2_3 / 2)
end

local function var_0_11()
	local var_3_0 = {}

	for iter_3_0 = 65, 1000 do
		local var_3_1, var_3_2 = pcall(entity.get_prop, iter_3_0, "m_MoveType")

		if var_3_1 and var_3_2 == 7 and bit.band(entity.get_prop(iter_3_0, "m_usSolidFlags"), 65535) == 2048 then
			var_3_0[#var_3_0 + 1] = iter_3_0
		end
	end

	return var_3_0
end

local function var_0_12()
	var_0_7 = {}

	local var_4_0 = var_0_11()

	if #var_4_0 > 0 then
		if var_0_6 then
			var_0_7 = var_4_0

			return
		end

		local var_4_1 = entity.get_local_player()
		local var_4_2 = var_0_0(client.eye_position())
		local var_4_3 = var_0_0(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))

		var_4_3.z = 0

		local var_4_4 = var_4_2 + var_4_3:scaled(globals.tickinterval() * 64)

		for iter_4_0, iter_4_1 in ipairs(var_4_0) do
			local var_4_5, var_4_6 = client.trace_line(var_4_1, var_4_2.x, var_4_2.y, var_4_2.z, var_4_4.x, var_4_4.y, var_4_4.z)

			if var_4_6 == iter_4_1 then
				var_0_7[#var_0_7 + 1] = iter_4_1

				break
			end
		end

		if #var_0_7 == 0 then
			local var_4_7 = var_0_0():init_from_angles(client.camera_angles())

			var_4_7:scale(var_0_9 / 2)

			local var_4_8 = var_4_7 + var_4_2

			for iter_4_2, iter_4_3 in ipairs(var_4_0) do
				local var_4_9, var_4_10 = client.trace_line(var_4_1, var_4_2.x, var_4_2.y, var_4_2.z, var_4_8.x, var_4_8.y, var_4_8.z)

				if var_4_10 == iter_4_3 then
					var_0_7[#var_0_7 + 1] = iter_4_3

					break
				end
			end
		end
	end
end

local function var_0_13(arg_5_0)
	local var_5_0 = var_0_0(entity.get_origin(arg_5_0))
	local var_5_1 = var_0_0(entity.get_prop(arg_5_0, "m_vecMins"))
	local var_5_2 = var_0_0(entity.get_prop(arg_5_0, "m_vecMaxs"))
	local var_5_3 = var_5_0 + var_5_1
	local var_5_4 = var_5_0 + var_5_2
	local var_5_5 = var_0_0(renderer.world_to_screen(var_0_10(arg_5_0):unpack()))
	local var_5_6 = var_0_0(renderer.world_to_screen(var_5_3:unpack()))
	local var_5_7 = var_0_0(renderer.world_to_screen(var_5_4:unpack()))

	renderer.line(var_5_6.x, var_5_6.y, var_5_7.x, var_5_7.y, 0, 0, 0, 255)
	renderer.circle(var_5_5.x, var_5_5.y, 50, 50, 50, 255, 3, 0, 100)
end

local function var_0_14(arg_6_0, arg_6_1)
	local var_6_0 = var_0_10(arg_6_0)
	local var_6_1 = var_6_0:dist(arg_6_1)
	local var_6_2 = math.min(1, 2 - var_6_1 / (var_0_9 * 2))

	if var_6_2 > 0 then
		local var_6_3
		local var_6_4
		local var_6_5
		local var_6_6 = var_6_1 > var_0_9 and 255 or 0
		local var_6_7 = var_6_2 == 1 and 255 or 0
		local var_6_8 = 0
		local var_6_9 = var_0_0(renderer.world_to_screen(var_6_0:unpack()))

		renderer.circle(var_6_9.x, var_6_9.y, var_6_6, var_6_7, var_6_8, 255 * var_6_2, 5, 0, 100)
	end
end

local function var_0_15()
	local var_7_0 = var_0_0(client.eye_position())

	for iter_7_0, iter_7_1 in ipairs(var_0_7) do
		var_0_14(iter_7_1, var_7_0)
	end

	if var_0_4 then
		for iter_7_2, iter_7_3 in ipairs(var_0_11()) do
			var_0_13(iter_7_3)
		end

		local var_7_1 = var_0_0(entity.get_prop(entity.get_local_player(), "m_vecVelocity"))

		var_7_1.z = 0

		local var_7_2 = var_7_0 + var_7_1:scaled(globals.tickinterval() * var_0_9)
		local var_7_3 = var_0_0(renderer.world_to_screen(var_7_0:unpack()))
		local var_7_4 = var_0_0(renderer.world_to_screen(var_7_2:unpack()))

		renderer.line(var_7_3.x, var_7_3.y, var_7_4.x, var_7_4.y, 255, 255, 255, 255)

		local var_7_5 = var_0_0():init_from_angles(client.camera_angles())

		var_7_5:scale(1024)

		local var_7_6 = var_7_5 + var_7_0
		local var_7_7, var_7_8 = client.trace_line(entity.get_local_player(), var_7_0.x, var_7_0.y, var_7_0.z, var_7_6.x, var_7_6.y, var_7_6.z)

		renderer.text(1280, 730, 255, 255, 255, 255, "cd", 0, string.format("%.2f %d", var_7_7, var_7_8))
		cvar.cl_pdump:set_int(var_7_8)

		if var_7_8 ~= -1 then
			print(bit.band(entity.get_prop(var_7_8, "m_nSolidType"), 65535))
			var_0_13(var_7_8)
		end
	end
end

local function var_0_16(arg_8_0)
	local var_8_0 = entity.get_local_player()
	local var_8_1 = entity.get_player_weapon(var_8_0)
	local var_8_2 = var_0_1(var_8_1)

	if var_8_2 == nil then
		return
	end

	if math.max(0, entity.get_prop(var_8_1, "m_flNextPrimaryAttack") or 0, entity.get_prop(var_8_0, "m_flNextAttack") or 0) - globals.curtime() < 0 and (var_8_2.type == "knife" or entity.get_prop(var_8_1, "m_iClip1") > 0) and not var_0_5(var_0_8, var_8_2.type) then
		local var_8_3 = var_0_0(client.eye_position())
		local var_8_4 = 256
		local var_8_5

		for iter_8_0, iter_8_1 in ipairs(var_0_7) do
			local var_8_6 = var_0_10(iter_8_1)
			local var_8_7 = var_8_3:dist(var_8_6)

			if var_8_7 < var_0_9 and var_8_7 < var_8_4 then
				local var_8_8, var_8_9 = client.trace_line(var_8_0, var_8_3.x, var_8_3.y, var_8_3.z, var_8_6.x, var_8_6.y, var_8_6.z)

				if var_8_8 >= 0.95 or var_8_9 == iter_8_1 then
					var_8_4 = var_8_7
					var_8_5 = var_8_6
				end
			end
		end

		if var_8_5 ~= nil then
			local var_8_10, var_8_11 = var_8_3:to(var_8_5):angles()

			arg_8_0.pitch = var_8_10
			arg_8_0.yaw = var_8_11
			arg_8_0.in_attack = 1
		end
	end
end

local function var_0_17()
	local var_9_0 = ui.get(var_0_2) and client.set_event_callback or client.unset_event_callback

	var_9_0("net_update_end", var_0_12)

	if var_0_3 then
		var_9_0("paint", var_0_15)
	end

	var_9_0("setup_command", var_0_16)
end

ui.set_callback(var_0_2, var_0_17)
var_0_17()
