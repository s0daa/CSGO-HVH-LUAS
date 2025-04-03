local var_0_0 = require("ffi")
local var_0_1 = panorama.open().GameStateAPI
local var_0_2 = 0
local var_0_3 = 0
local var_0_4 = 0
local var_0_5 = false
local var_0_6 = cvar.cl_downloadfilter

local function var_0_7()
	local var_1_0 = vtable_bind("vstdlib.dll", "VEngineCvar007", 35, "void(__thiscall*)(void*, int, char*, unsigned int)")
	local var_1_1 = 1048576
	local var_1_2 = var_0_0.typeof("char[$]", var_1_1)()

	var_1_0(0, var_1_2, var_1_1)

	return var_0_0.string(var_1_2)
end

local function var_0_8(arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_0 do
		if arg_2_0[iter_2_0] == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_9()
	if var_0_7():find("Download finished") then
		if var_0_1.IsConnectedOrConnectingToServer() then
			client.exec("disconnect")
			client.delay_call(0.9, function()
				if var_0_2 < 1 then
					var_0_6:set_string("none")
					client.exec("retry")

					var_0_2 = 1
				end
			end)
		end
	else
		client.delay_call(0.8, var_0_9)
	end
end

local function var_0_10(arg_5_0, arg_5_1)
	local var_5_0 = {}

	for iter_5_0 in (arg_5_0 .. arg_5_1):gmatch("(.-)" .. arg_5_1) do
		table.insert(var_5_0, iter_5_0)
	end

	return var_5_0
end

client.set_event_callback("paint_ui", function()
	if var_0_1.IsConnectedOrConnectingToServer() and not globals.mapname() then
		local var_6_0 = var_0_1.GetMapBSPName()

		if var_6_0 ~= "" and var_0_6:get_string() == "mapsonly" and var_0_3 == 0 and var_0_2 == 0 then
			if var_6_0:find("/") then
				local var_6_1 = var_0_10(var_6_0, "/")

				if readfile("csgo\\maps\\workshop\\" .. var_6_1[2] .. "\\" .. var_6_1[3] .. ".bsp") then
					var_0_6:set_string("none")

					var_0_3 = 1
					var_0_5 = false
				end
			elseif readfile("csgo\\maps\\" .. var_6_0 .. ".bsp") then
				var_0_6:set_string("none")

				var_0_3 = 1
				var_0_5 = false
			else
				var_0_5 = false

				client.exec("clear")
				client.delay_call(0.5, function()
					var_0_9()

					var_0_3 = 1
				end)
			end
		end
	elseif globals.mapname() and not var_0_5 then
		if var_0_6:get_string() ~= "all" and (var_0_3 > 0 or var_0_2 > 0) then
			var_0_6:set_string("all")

			var_0_4 = 1
		end
	else
		var_0_5 = false

		if var_0_3 > 0 or var_0_2 > 0 or var_0_4 > 0 then
			client.delay_call(0, function()
				if not globals.mapname() and not var_0_1.IsConnectedOrConnectingToServer() then
					var_0_6:set_string("mapsonly")

					var_0_3 = 0
					var_0_2 = 0
					var_0_4 = 0
				end
			end)
		end
	end
end)
client.set_event_callback("shutdown", function()
	if var_0_2 > 0 or var_0_3 > 0 or var_0_4 > 0 then
		var_0_6:set_string("mapsonly")
	end
end)
client.set_event_callback("nextlevel_changed", function()
	if var_0_2 > 0 or var_0_3 > 0 or var_0_4 > 0 then
		var_0_2 = 0
		var_0_3 = 0
		var_0_4 = 0
		var_0_5 = true

		var_0_6:set_string("mapsonly")
	end
end)
