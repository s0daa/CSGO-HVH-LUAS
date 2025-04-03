local var_0_0 = client.screen_size
local var_0_1 = client.set_cvar
local var_0_2 = math.fmod
local var_0_3 = tonumber
local var_0_4 = ui.get
local var_0_5 = ui.new_slider
local var_0_6 = ui.set_callback
local var_0_7 = ui.set_visible

local function var_0_8(arg_1_0)
	local var_1_0, var_1_1 = var_0_0()
	local var_1_2 = var_1_0 * arg_1_0 / var_1_1

	if arg_1_0 == 1 then
		var_1_2 = 0
	end

	var_0_1("r_aspectratio", var_0_3(var_1_2))
end

local function var_0_9(arg_2_0, arg_2_1)
	while arg_2_0 ~= 0 do
		arg_2_0, arg_2_1 = var_0_2(arg_2_1, arg_2_0), arg_2_0
	end

	return arg_2_1
end

local var_0_10
local var_0_11
local var_0_12

local function var_0_13()
	local var_3_0 = 2 - var_0_4(var_0_12) * 0.01

	var_0_8(var_3_0)
end

local var_0_14 = 0.01
local var_0_15 = 200

local function var_0_16(arg_4_0, arg_4_1)
	var_0_10, var_0_11 = arg_4_0, arg_4_1

	local var_4_0 = {}

	for iter_4_0 = 1, var_0_15 do
		local var_4_1 = (var_0_15 - iter_4_0) * var_0_14
		local var_4_2 = var_0_9(var_0_10 * var_4_1, var_0_11)

		if var_0_10 * var_4_1 / var_4_2 < 100 or var_4_1 == 1 then
			var_4_0[iter_4_0] = var_0_10 * var_4_1 / var_4_2 .. ":" .. var_0_11 / var_4_2
		end
	end

	if var_0_12 ~= nil then
		var_0_7(var_0_12, false)
		var_0_6(var_0_12, function()
			return
		end)
	end

	var_0_12 = var_0_5("VISUALS", "Effects", "Force aspect ratio", 0, var_0_15 - 1, var_0_15 / 2, true, "%", 1, var_4_0)

	var_0_6(var_0_12, var_0_13)
end

var_0_16(var_0_0())

local function var_0_17(arg_6_0)
	local var_6_0, var_6_1 = var_0_0()

	if var_6_0 ~= var_0_10 or var_6_1 ~= var_0_11 then
		var_0_16(var_6_0, var_6_1)
	end
end

client.set_event_callback("paint", var_0_17)
