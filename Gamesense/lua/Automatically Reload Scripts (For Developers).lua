local var_0_0 = vtable_bind("engine.dll", "VEngineClient014", 196, "bool(__thiscall*)(void*)")
local var_0_1 = {}
local var_0_2 = {}

local function var_0_3(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or var_0_2

	local var_1_0
	local var_1_1
	local var_1_2

	if not arg_1_1[1] then
		for iter_1_0 = 1, 256 do
			local var_1_3 = iter_1_0 - 1

			for iter_1_1 = 1, 8 do
				local var_1_4 = -bit.band(var_1_3, 1)

				var_1_3 = bit.bxor(bit.rshift(var_1_3, 1), bit.band(3988292384, var_1_4))
			end

			arg_1_1[iter_1_0] = var_1_3
		end
	end

	local var_1_5 = 4294967295

	for iter_1_2 = 1, #arg_1_0 do
		local var_1_6 = string.byte(arg_1_0, iter_1_2)

		var_1_5 = bit.bxor(bit.rshift(var_1_5, 8), arg_1_1[bit.band(bit.bxor(var_1_5, var_1_6), 255) + 1])
	end

	return bit.band(bit.bnot(var_1_5), 4294967295)
end

local function var_0_4()
	for iter_2_0, iter_2_1 in pairs(package.loaded) do
		local var_2_0 = readfile(iter_2_0 .. ".lua")

		if var_2_0 then
			local var_2_1 = var_0_3(var_2_0)

			if var_0_1[iter_2_0] then
				if var_0_1[iter_2_0] ~= var_2_1 then
					print(string.format("%s was changed, reloading active scripts!", iter_2_0))
					client.reload_active_scripts()

					return
				end
			else
				var_0_1[iter_2_0] = var_2_1
			end
		end
	end
end

local var_0_5 = false

client.set_event_callback("paint_ui", function()
	local var_3_0 = var_0_0()

	if var_0_5 == false and var_3_0 then
		var_0_4()
		client.delay_call(0.5, var_0_4)
	end

	var_0_5 = var_3_0
end)
