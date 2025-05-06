local var_0_0 = require("gamesense/http")
local var_0_1 = require("gamesense/csgo_weapons")
local var_0_2 = require("gamesense/easing")
local var_0_3 = require("gamesense/pretty_json")
local var_0_4 = require("gamesense/images")
local var_0_5 = require("gamesense/table_gen")
local var_0_6 = require("table.clear")
local var_0_7 = require("vector")
local var_0_8

if false then
	var_0_8 = {
		inspect = require("gamesense/inspect")
	}

	client.set_event_callback("paint_ui", function()
		if var_0_8.debug_text ~= nil then
			renderer.text(150, 150, 255, 255, 255, 255, "+", 0, var_0_8.debug_text)
		end
	end)
end

local var_0_9 = {
	["local"] = "Local",
	local_file = "Local file",
	remote = "Remote"
}
local var_0_10 = {
	wallbang = "Wallbang",
	movement = "Movement",
	grenade = "Grenade"
}
local var_0_11 = {
	Right = -90,
	Left = 90,
	Back = 180,
	Forward = 0
}
local var_0_12 = {
	in_jump = "J",
	in_attack2 = "Z",
	in_attack = "A",
	in_speed = "S",
	in_use = "U",
	in_back = "B",
	in_moveright = "R",
	in_moveleft = "L",
	in_forward = "F",
	in_duck = "D"
}
local var_0_13 = {
	"in_forward",
	"in_moveright",
	"in_back",
	"in_moveleft"
}
local var_0_14 = setmetatable({
	[var_0_1.weapon_smokegrenade] = "Smoke",
	[var_0_1.weapon_flashbang] = "Flashbang",
	[var_0_1.weapon_hegrenade] = "HE",
	[var_0_1.weapon_molotov] = "Molotov"
}, {
	__index = function(arg_2_0, arg_2_1)
		if type(arg_2_1) == "table" and arg_2_1.name ~= nil then
			arg_2_0[arg_2_1] = arg_2_1.name

			return arg_2_0[arg_2_1]
		end
	end
})
local var_0_15 = setmetatable({
	[var_0_1.weapon_smokegrenade] = "Smoke",
	[var_0_1.weapon_flashbang] = "Flashbang",
	[var_0_1.weapon_hegrenade] = "High Explosive",
	[var_0_1.weapon_molotov] = "Molotov"
}, {
	__index = var_0_14
})
local var_0_16 = setmetatable({}, {
	__index = function(arg_3_0, arg_3_1)
		if arg_3_1 == nil then
			return
		end

		arg_3_0[arg_3_1] = var_0_4.get_weapon_icon(arg_3_1)

		return arg_3_0[arg_3_1]
	end
})
local var_0_17 = setmetatable({
	[var_0_16.weapon_smokegrenade] = {
		0.2,
		-0.1,
		0.35,
		0
	},
	[var_0_16.weapon_hegrenade] = {
		0.1,
		-0.12,
		0.2,
		0
	},
	[var_0_16.weapon_molotov] = {
		0,
		-0.04,
		0,
		0
	}
}, {
	__index = function(arg_4_0, arg_4_1)
		arg_4_0[arg_4_1] = {
			0,
			0,
			0,
			0
		}

		return arg_4_0[arg_4_1]
	end
})
local var_0_18 = {
	[var_0_1.weapon_incgrenade] = var_0_1.weapon_molotov,
	[var_0_1.weapon_firebomb] = var_0_1.weapon_molotov,
	[var_0_1.weapon_frag_grenade] = var_0_1.weapon_hegrenade
}

for iter_0_0, iter_0_1 in pairs(var_0_1) do
	if iter_0_1.type == "knife" then
		var_0_18[iter_0_1] = var_0_1.weapon_knife
	end
end

local var_0_19
local var_0_20 = 1
local var_0_21 = {}
local var_0_22 = setmetatable({}, {
	__mode = "k",
	__index = function(arg_5_0, arg_5_1)
		local var_5_0 = string.format("%.2f %.2f %.2f", arg_5_1:unpack())
		local var_5_1 = var_0_21[var_5_0]

		if var_5_1 == nil then
			var_5_1 = var_0_20
			var_0_21[var_5_0] = var_5_1
			var_0_20 = var_5_1 + 1
		end

		arg_5_0[arg_5_1] = var_5_1

		return var_5_1
	end
})
local var_0_23 = {
	select_fov_rage = 90,
	select_fov_legit = 8,
	fov_movement = 0.1,
	fov = 0.7,
	source_ttl = 5,
	destroy_text = "Break the object",
	max_dist = 6,
	visibility_offset = var_0_7(0, 0, 24)
}
local var_0_24 = "https://cdn.staticaly.com/gh/"
local var_0_25 = 1500
local var_0_26 = var_0_25 * var_0_25
local var_0_27 = 400
local var_0_28 = 650
local var_0_29 = 28
local var_0_30 = 15
local var_0_31 = 0.1
local var_0_32 = var_0_7(0, 0, 8)
local var_0_33 = 6
local var_0_34 = 1 / 0
local var_0_35 = var_0_7(0, 0, 0)
local var_0_36 = cvar.sensitivity
local var_0_37 = 1
local var_0_38 = 9
local var_0_39 = {
	255,
	16,
	16
}
local var_0_40
local var_0_41
local var_0_42 = 20
local var_0_43 = 16
local var_0_44 = {
	var_0_7(var_0_43 * 0.7, 0, var_0_42),
	var_0_7(-var_0_43 * 0.7, 0, var_0_42),
	var_0_7(0, var_0_43 * 0.7, var_0_42),
	var_0_7(0, -var_0_43 * 0.7, var_0_42)
}
local var_0_45 = {
	var_0_7(var_0_43 * 2, 0, 0),
	var_0_7(0, var_0_43 * 2, 0),
	var_0_7(-var_0_43 * 2, 0, 0),
	var_0_7(0, -var_0_43 * 2, 0)
}
local var_0_46 = {
	start_times = {},
	measure = function(arg_6_0, arg_6_1, ...)
		if not var_0_8 then
			return
		end

		local var_6_0 = client.timestamp()
		local var_6_1 = {
			arg_6_1(...)
		}

		client.log(string.format("%s took %fms", arg_6_0, client.timestamp() - var_6_0))

		return unpack(var_6_1)
	end,
	start = function(arg_7_0, arg_7_1)
		if not var_0_8 then
			return
		end

		if arg_7_0.start_times[arg_7_1] ~= nil then
			client.error_log("benchmark: " .. arg_7_1 .. " wasn't finished before starting again")
		end

		arg_7_0.start_times[arg_7_1] = client.timestamp()
	end,
	finish = function(arg_8_0, arg_8_1, arg_8_2)
		if not var_0_8 then
			return
		end

		if arg_8_0.start_times[arg_8_1] == nil then
			return
		end

		if not arg_8_2 then
			client.log(string.format("%s took %fms", arg_8_1, client.timestamp() - arg_8_0.start_times[arg_8_1]))
		end

		arg_8_0.start_times[arg_8_1] = nil
	end
}
local var_0_47 = {
	bhop = var_0_4.load_svg("<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg xmlns:svg=\"http://www.w3.org/2000/svg\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 158 200\" height=\"200mm\" width=\"158mm\">\n\t<g style=\"mix-blend-mode:normal\">\n\t\t<path d=\"m 27.692726,195.58287 c -2.00307,-2.00307 -2.362731,-5.63696 -1.252001,-12.64982 0.51631,-3.25985 0.938744,-6.15692 0.938744,-6.43794 0,-0.28102 -1.054647,-0.68912 -2.343659,-0.9069 -1.289012,-0.21778 -2.343659,-0.46749 -2.343659,-0.55491 0,-0.0874 0.894568,-2.10761 1.987932,-4.48934 4.178194,-9.10153 7.386702,-22.1671 7.386702,-30.07983 v -3.57114 l -3.439063,-0.65356 c -7.509422,-1.42712 -14.810239,-6.3854 -17.132592,-11.63547 -0.617114,-1.39509 -1.6652612,-5.2594 -2.3292172,-8.58736 -0.894299,-4.48252 -1.742757,-6.93351 -3.273486,-9.45625 -2.296839,-3.78538 -2.316583,-5.11371 -0.151099,-10.165583 0.632785,-1.47622 2.428356,-7.85932 3.990157,-14.18467 2.3650332,-9.578444 3.4874882,-12.902312 6.7157522,-19.887083 5.153317,-11.149867 5.357987,-11.987895 3.936721,-16.118875 -1.318135,-3.831228 -1.056436,-5.345174 1.69769,-9.821193 0.98924,-1.607722 2.121218,-4.129295 2.515508,-5.6035 C 25.28429,28.210324 25.23258,27.949807 23.35135,24.502898 21.710552,21.496527 21.306782,19.993816 20.889474,15.340532 20.614927,12.279129 20.380889,8.4556505 20.369393,6.8439185 l -0.02091,-2.930428 9.333915,0.83216 9.333914,0.832161 0.415652,4.4356115 c 0.228605,2.439587 0.232248,9.481725 0.0081,15.649196 l -0.407561,11.213581 3.401641,0.387936 c 1.8709,0.213363 4.456285,0.528941 5.745297,0.701283 l 2.343658,0.31335 0.01922,-4.58462 c 0.01523,-3.630049 0.300834,-5.120017 1.371678,-7.156027 3.087768,-5.870826 9.893488,-10.61208 17.039741,-11.87087 2.720173,-0.479148 4.160963,-0.409507 7.136663,0.344951 8.66897,2.197927 13.98192,9.621168 13.98192,19.535491 0,3.495649 -0.1404,3.901096 -1.99211,5.752805 -1.24394,1.243942 -2.56423,1.992111 -3.51549,1.992111 -1.49731,0 -1.52337,0.07107 -1.52337,4.153986 v 4.15399 l 8.9352,-0.237138 c 5.2858,-0.140285 11.170779,-0.674802 14.408789,-1.308719 l 5.4736,-1.071577 -0.38275,-2.552314 c -0.37145,-2.476984 -0.33603,-2.552315 1.19984,-2.552315 0.87041,0 1.91062,-0.448636 2.31157,-0.996969 0.68332,-0.93449 1.27483,-0.910186 9.43922,0.387872 4.86768,0.773912 12.32893,1.486871 16.91304,1.616118 4.51154,0.127203 8.93123,0.513358 9.82152,0.858128 2.24255,0.86843 2.71036,3.071333 1.03169,4.858196 -2.36272,2.515004 -4.22494,2.914196 -9.65444,2.069567 -6.49602,-1.010535 -9.48434,-0.608226 -12.89073,1.735433 -1.51944,1.045409 -3.78166,2.037422 -5.02716,2.204478 -2.12756,0.285364 -2.24441,0.404325 -1.93193,1.966706 0.54423,2.721143 -0.2472,4.489222 -3.68173,8.225132 -3.77119,4.102112 -4.63155,5.89093 -5.49449,11.423793 -0.94965,6.08886 -1.57396,7.52473 -5.32281,12.24226 -5.48499,6.90229 -11.865029,11.373083 -16.271159,11.401983 -2.96514,0.0195 -5.44164,-1.427403 -10.64598,-6.219683 -6.09285,-5.61044 -11.509723,-9.58715 -13.059111,-9.58715 -0.74413,0 -2.728788,1.56375 -5.069514,3.99435 -2.115662,2.19689 -4.279795,4.24027 -4.809188,4.54084 -0.873942,0.49619 -0.888303,0.97152 -0.156034,5.16456 0.443574,2.539953 1.213393,5.239093 1.710714,5.998093 1.234397,1.88393 4.464204,3.43033 10.249847,4.90755 11.894956,3.03704 24.227356,12.17082 28.700056,21.25618 3.277059,6.65665 3.756559,14.90456 1.06537,18.32585 -2.00495,2.54888 -4.71703,3.29933 -13.73034,3.79931 -12.02449,0.66702 -11.43259,0.30042 -25.191149,15.60203 -3.539415,3.93635 -4.947788,5.02545 -9.098134,7.03552 -6.030466,2.92066 -8.127669,5.18229 -9.759102,10.52427 -1.407053,4.60727 -3.889283,7.93618 -7.163048,9.60633 -3.066476,1.56439 -5.550268,1.48363 -7.270304,-0.2364 z M 99.119321,71.201503 c 3.729129,-4.724307 6.662059,-8.707839 6.517599,-8.852305 -0.14446,-0.144451 -2.7777,1.571678 -5.851649,3.813635 -4.38891,3.20102 -6.56642,4.363275 -10.1411,5.412849 -2.50365,0.73511 -4.68393,1.459682 -4.84506,1.610152 -0.31664,0.295703 6.47662,6.567603 7.13899,6.591103 0.22054,0.008 3.4521,-3.85113 7.18122,-8.575434 z\" style=\"fill:#ffffff;fill-opacity:1;stroke:none;stroke-width:0.585916;stroke-opacity:1\" />\n\t</g>\n</svg>\n")
}

local function var_0_48(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 == 0 then
		return arg_9_2, arg_9_2, arg_9_2
	end

	arg_9_0 = arg_9_0 / 60

	local var_9_0 = math.floor(arg_9_0)
	local var_9_1 = arg_9_0 - var_9_0
	local var_9_2 = arg_9_2 * (1 - arg_9_1)
	local var_9_3 = arg_9_2 * (1 - arg_9_1 * var_9_1)
	local var_9_4 = arg_9_2 * (1 - arg_9_1 * (1 - var_9_1))

	if var_9_0 == 0 then
		return arg_9_2, var_9_4, var_9_2
	elseif var_9_0 == 1 then
		return var_9_3, arg_9_2, var_9_2
	elseif var_9_0 == 2 then
		return var_9_2, arg_9_2, var_9_4
	elseif var_9_0 == 3 then
		return var_9_2, var_9_3, arg_9_2
	elseif var_9_0 == 4 then
		return var_9_4, var_9_2, arg_9_2
	elseif var_9_0 == 5 then
		return arg_9_2, var_9_2, var_9_3
	end
end

local function var_0_49(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = math.max(arg_10_0, arg_10_1, arg_10_2)
	local var_10_1 = var_10_0 - math.min(arg_10_0, arg_10_1, arg_10_2)

	if var_10_1 < 1 then
		return 0, 0, var_10_0
	end

	if var_10_0 == 0 then
		return -1, 0, var_10_0
	end

	local var_10_2 = var_10_1 / var_10_0
	local var_10_3

	if arg_10_0 == var_10_0 then
		var_10_3 = (arg_10_1 - arg_10_2) / var_10_1
	elseif arg_10_1 == var_10_0 then
		var_10_3 = 2 + (arg_10_2 - arg_10_0) / var_10_1
	else
		var_10_3 = 4 + (arg_10_0 - arg_10_1) / var_10_1
	end

	local var_10_4 = var_10_3 * 60

	if var_10_4 < 0 then
		var_10_4 = var_10_4 + 360
	end

	return var_10_4, var_10_2, var_10_0
end

local function var_0_50(arg_11_0, arg_11_1, arg_11_2)
	return arg_11_0 + (arg_11_1 - arg_11_0) * arg_11_2
end

local function var_0_51(arg_12_0, arg_12_1)
	for iter_12_0 = 1, #arg_12_0 do
		if arg_12_0[iter_12_0] == arg_12_1 then
			return true
		end
	end

	return false
end

local function var_0_52(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	if arg_13_8 == 0 then
		return arg_13_0, arg_13_1, arg_13_2, arg_13_3
	elseif arg_13_8 == 1 then
		return arg_13_4, arg_13_5, arg_13_6, arg_13_7
	end

	local var_13_0, var_13_1, var_13_2 = var_0_49(arg_13_0, arg_13_1, arg_13_2)
	local var_13_3, var_13_4, var_13_5 = var_0_49(arg_13_4, arg_13_5, arg_13_6)
	local var_13_6, var_13_7, var_13_8 = var_0_48(var_0_50(var_13_0, var_13_3, arg_13_8), var_0_50(var_13_1, var_13_4, arg_13_8), var_0_50(var_13_2, var_13_5, arg_13_8))
	local var_13_9 = var_0_50(arg_13_3, arg_13_7, arg_13_8)

	return var_13_6, var_13_7, var_13_8, var_13_9
end

local function var_0_53(arg_14_0, arg_14_1)
	if arg_14_1 ~= arg_14_1 or arg_14_1 == var_0_34 then
		arg_14_1 = 0
	elseif not (arg_14_1 > -180) or not (arg_14_1 <= 180) then
		arg_14_1 = math.fmod(math.fmod(arg_14_1 + 360, 360), 360)
		arg_14_1 = arg_14_1 > 180 and arg_14_1 - 360 or arg_14_1
	end

	return math.max(-89, math.min(89, arg_14_0)), arg_14_1
end

local function var_0_54(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if arg_15_2 == nil then
		arg_15_2 = {}
		arg_15_3 = ""
	end

	for iter_15_0, iter_15_1 in pairs(arg_15_0) do
		if type(iter_15_1) == "table" and (not arg_15_1 or #iter_15_1 == 0) then
			var_0_54(iter_15_1, arg_15_1, arg_15_2, arg_15_3 .. iter_15_0 .. ".")
		else
			arg_15_2[arg_15_3 .. iter_15_0] = iter_15_1
		end
	end

	return arg_15_2
end

local function var_0_55(arg_16_0, arg_16_1)
	if arg_16_0 == arg_16_1 then
		return true
	elseif type(arg_16_0) == "table" and type(arg_16_1) == "table" then
		for iter_16_0, iter_16_1 in pairs(arg_16_0) do
			local var_16_0 = arg_16_1[iter_16_0]

			if var_16_0 == nil then
				return false
			elseif iter_16_1 ~= var_16_0 then
				if type(iter_16_1) == "table" and type(var_16_0) == "table" then
					if not var_0_55(iter_16_1, var_16_0) then
						return false
					end
				else
					return false
				end
			end
		end

		for iter_16_2, iter_16_3 in pairs(arg_16_1) do
			if arg_16_0[iter_16_2] == nil then
				return false
			end
		end

		return true
	end

	return false
end

local function var_0_56(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	arg_17_8 = arg_17_8 or 1

	renderer.rectangle(arg_17_0, arg_17_1, arg_17_2, arg_17_8, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	renderer.rectangle(arg_17_0, arg_17_1 + arg_17_3 - arg_17_8, arg_17_2, arg_17_8, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	renderer.rectangle(arg_17_0, arg_17_1 + arg_17_8, arg_17_8, arg_17_3 - arg_17_8 * 2, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
	renderer.rectangle(arg_17_0 + arg_17_2 - arg_17_8, arg_17_1 + arg_17_8, arg_17_8, arg_17_3 - arg_17_8 * 2, arg_17_4, arg_17_5, arg_17_6, arg_17_7)
end

local function var_0_57(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = math.sin(arg_18_0)
	local var_18_1 = math.cos(arg_18_0)
	local var_18_2 = arg_18_1 * var_18_1 - arg_18_2 * var_18_0
	local var_18_3 = arg_18_1 * var_18_0 + arg_18_2 * var_18_1

	return var_18_2, var_18_3
end

local function var_0_58(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_2 - arg_19_0
	local var_19_1 = arg_19_3 - arg_19_1

	return math.sqrt(var_19_0 * var_19_0 + var_19_1 * var_19_1)
end

local function var_0_59(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8)
	local var_20_0, var_20_1 = var_0_57(arg_20_4, arg_20_2 / 2, 0)
	local var_20_2, var_20_3 = var_0_57(arg_20_4, 0, arg_20_3)
	local var_20_4, var_20_5 = var_0_57(arg_20_4, arg_20_2, arg_20_3)
	local var_20_6, var_20_7 = var_0_57(arg_20_4, -arg_20_2 / 2, -arg_20_3 / 2)

	arg_20_0, arg_20_1 = arg_20_0 + var_20_6, arg_20_1 + var_20_7

	renderer.triangle(arg_20_0 + var_20_0, arg_20_1 + var_20_1, arg_20_0 + var_20_2, arg_20_1 + var_20_3, arg_20_0 + var_20_4, arg_20_1 + var_20_5, arg_20_5, arg_20_6, arg_20_7, arg_20_8)
end

local function var_0_60(arg_21_0)
	local var_21_0 = ""

	for iter_21_0 = 1, arg_21_0 or 32 do
		var_21_0 = var_21_0 .. string.char(client.random_int(97, 122))
	end

	return var_21_0
end

local var_0_61 = {}

local function var_0_62(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or var_0_61

	local var_22_0
	local var_22_1
	local var_22_2

	if not arg_22_1[1] then
		for iter_22_0 = 1, 256 do
			local var_22_3 = iter_22_0 - 1

			for iter_22_1 = 1, 8 do
				local var_22_4 = -bit.band(var_22_3, 1)

				var_22_3 = bit.bxor(bit.rshift(var_22_3, 1), bit.band(3988292384, var_22_4))
			end

			arg_22_1[iter_22_0] = var_22_3
		end
	end

	local var_22_5 = 4294967295

	for iter_22_2 = 1, #arg_22_0 do
		local var_22_6 = string.byte(arg_22_0, iter_22_2)

		var_22_5 = bit.bxor(bit.rshift(var_22_5, 8), arg_22_1[bit.band(bit.bxor(var_22_5, var_22_6), 255) + 1])
	end

	return bit.band(bit.bnot(var_22_5), 4294967295)
end

local function var_0_63(arg_23_0, arg_23_1)
	local var_23_0 = {}

	for iter_23_0, iter_23_1 in pairs(arg_23_0) do
		var_23_0[iter_23_0] = arg_23_1(iter_23_1)
	end

	return var_23_0
end

local function var_0_64(arg_24_0, arg_24_1)
	local var_24_0 = {}

	for iter_24_0, iter_24_1 in pairs(arg_24_0) do
		local var_24_1, var_24_2 = arg_24_1(iter_24_0, iter_24_1)

		var_24_0[var_24_1] = var_24_2
	end

	return var_24_0
end

local function var_0_65(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = {
		"day",
		"hour",
		"minute"
	}
	local var_25_1 = ""
	local var_25_2 = 1

	arg_25_2 = arg_25_2 or 4

	for iter_25_0, iter_25_1 in ipairs({
		86400,
		3600,
		60
	}) do
		if arg_25_2 < var_25_2 then
			break
		end

		if iter_25_1 <= arg_25_0 then
			var_25_1 = var_25_1 .. math.floor(arg_25_0 / iter_25_1) .. " " .. var_25_0[iter_25_0] .. (math.floor(arg_25_0 / iter_25_1) > 1 and "s" or "") .. ", "
			arg_25_0 = arg_25_0 % iter_25_1
			var_25_2 = var_25_2 + 1
		end
	end

	if arg_25_0 == 0 or arg_25_1 or arg_25_2 < var_25_2 then
		return var_25_1:sub(1, -3)
	else
		arg_25_0 = math.floor(arg_25_0)

		return var_25_1 .. arg_25_0 .. (arg_25_0 > 1 and " seconds" or " second")
	end
end

local function var_0_66(arg_26_0, arg_26_1)
	local var_26_0 = entity.get_prop(arg_26_0, "m_bPinPulled")

	if var_26_0 ~= nil and (var_26_0 == 0 or arg_26_1.in_attack == 1 or arg_26_1.in_attack2 == 1) then
		local var_26_1 = entity.get_prop(arg_26_0, "m_fThrowTime")

		if var_26_1 ~= nil and var_26_1 > 0 and var_26_1 < globals.curtime() then
			return true
		end
	end

	return false
end

local function var_0_67(arg_27_0, arg_27_1, arg_27_2)
	arg_27_2 = arg_27_2 or 10

	local var_27_0 = 0
	local var_27_1 = -1
	local var_27_2 = arg_27_0
	local var_27_3 = 0

	while var_27_3 <= arg_27_2 and var_27_0 < 1 and (var_27_1 > -1 or var_27_3 == 0) do
		local var_27_4, var_27_5, var_27_6 = var_27_2:unpack()

		var_27_0, var_27_1 = client.trace_line(var_27_1, var_27_4, var_27_5, var_27_6, arg_27_1:unpack())
		var_27_2 = var_27_2:lerp(arg_27_1, var_27_0)
		var_27_3 = var_27_3 + 1
	end

	return arg_27_0:dist(var_27_2) / arg_27_0:dist(arg_27_1), var_27_1, var_27_2
end

local var_0_68 = vtable_bind("engine.dll", "VEngineClient014", 37, "struct {float m[4][4];}&(__thiscall*)(void*)")

local function var_0_69(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	arg_28_3 = arg_28_3 or var_0_68()

	local var_28_0 = arg_28_3.m[0][0] * arg_28_0 + arg_28_3.m[0][1] * arg_28_1 + arg_28_3.m[0][2] * arg_28_2 + arg_28_3.m[0][3]
	local var_28_1 = arg_28_3.m[1][0] * arg_28_0 + arg_28_3.m[1][1] * arg_28_1 + arg_28_3.m[1][2] * arg_28_2 + arg_28_3.m[1][3]
	local var_28_2 = arg_28_3.m[3][0] * arg_28_0 + arg_28_3.m[3][1] * arg_28_1 + arg_28_3.m[3][2] * arg_28_2 + arg_28_3.m[3][3]
	local var_28_3

	if var_28_2 < 0.001 then
		local var_28_4 = -1 / var_28_2

		var_28_3 = false
		var_28_0 = var_28_0 * var_28_4
		var_28_1 = var_28_1 * var_28_4
	else
		local var_28_5 = 1 / var_28_2

		var_28_3 = true
		var_28_0 = var_28_0 * var_28_5
		var_28_1 = var_28_1 * var_28_5
	end

	if type(var_28_0) ~= "number" or type(var_28_1) ~= "number" then
		return
	end

	if arg_28_4 == nil then
		arg_28_4, arg_28_5 = client.screen_size()
	end

	local var_28_6 = arg_28_4 / 2 + (0.5 * var_28_0 * arg_28_4 + 0.5)
	local var_28_7 = arg_28_5 / 2 - (0.5 * var_28_1 * arg_28_5 + 0.5)

	return var_28_6, var_28_7, var_28_3, var_28_2
end

local function var_0_70(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	local var_29_0, var_29_1, var_29_2 = var_0_69(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)

	if var_29_0 == nil then
		return
	end

	if var_29_0 < arg_29_6 or var_29_0 > arg_29_4 - arg_29_6 or var_29_1 < arg_29_6 or var_29_1 > arg_29_5 - arg_29_6 or not var_29_2 then
		local var_29_3 = arg_29_4 / 2
		local var_29_4 = arg_29_5 / 2
		local var_29_5 = math.atan2(var_29_1 - var_29_4, var_29_0 - var_29_3)
		local var_29_6 = math.min(arg_29_4, arg_29_5) / 2 - arg_29_6
		local var_29_7 = var_29_3 + var_29_6 * math.cos(var_29_5)
		local var_29_8 = var_29_4 + var_29_6 * math.sin(var_29_5)

		return var_29_7, var_29_8, true
	else
		return var_29_0, var_29_1, false
	end
end

local function var_0_71(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5, arg_30_6, arg_30_7)
	local var_30_0 = (arg_30_0 - arg_30_2) * (arg_30_5 - arg_30_7) - (arg_30_1 - arg_30_3) * (arg_30_4 - arg_30_6)
	local var_30_1 = arg_30_0 * arg_30_3 - arg_30_1 * arg_30_2
	local var_30_2 = arg_30_4 * arg_30_7 - arg_30_5 * arg_30_6
	local var_30_3 = (var_30_1 * (arg_30_4 - arg_30_6) - (arg_30_0 - arg_30_2) * var_30_2) / var_30_0
	local var_30_4 = (var_30_1 * (arg_30_5 - arg_30_7) - (arg_30_1 - arg_30_3) * var_30_2) / var_30_0

	return var_30_3, var_30_4
end

local function var_0_72(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6)
	local var_31_0, var_31_1, var_31_2 = var_0_69(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5)

	if var_31_0 == nil then
		return
	end

	if not var_31_2 or var_31_0 < arg_31_6 or var_31_0 > arg_31_4 - arg_31_6 or var_31_1 < arg_31_6 or var_31_1 > arg_31_5 - arg_31_6 then
		local var_31_3 = arg_31_4 / 2
		local var_31_4 = arg_31_5 / 2

		if not var_31_2 then
			local var_31_5 = math.atan2(var_31_1 - var_31_4, var_31_0 - var_31_3)
			local var_31_6 = math.max(arg_31_4, arg_31_5)

			var_31_0 = var_31_3 + var_31_6 * math.cos(var_31_5)
			var_31_1 = var_31_4 + var_31_6 * math.sin(var_31_5)
		end

		local var_31_7 = {
			arg_31_6,
			arg_31_6,
			arg_31_4 - arg_31_6,
			arg_31_6,
			arg_31_4 - arg_31_6,
			arg_31_6,
			arg_31_4 - arg_31_6,
			arg_31_5 - arg_31_6,
			arg_31_6,
			arg_31_6,
			arg_31_6,
			arg_31_5 - arg_31_6,
			arg_31_6,
			arg_31_5 - arg_31_6,
			arg_31_4 - arg_31_6,
			arg_31_5 - arg_31_6
		}

		for iter_31_0 = 1, #var_31_7, 4 do
			local var_31_8 = var_31_7[iter_31_0]
			local var_31_9 = var_31_7[iter_31_0 + 1]
			local var_31_10 = var_31_7[iter_31_0 + 2]
			local var_31_11 = var_31_7[iter_31_0 + 3]
			local var_31_12, var_31_13 = var_0_71(var_31_8, var_31_9, var_31_10, var_31_11, var_31_3, var_31_4, var_31_0, var_31_1)

			if iter_31_0 == 1 and var_31_1 < arg_31_6 and arg_31_6 <= var_31_12 and var_31_12 <= arg_31_4 - arg_31_6 or iter_31_0 == 5 and var_31_0 > arg_31_4 - arg_31_6 and arg_31_6 <= var_31_13 and var_31_13 <= arg_31_5 - arg_31_6 or iter_31_0 == 9 and var_31_0 < arg_31_6 and arg_31_6 <= var_31_13 and var_31_13 <= arg_31_5 - arg_31_6 or iter_31_0 == 13 and var_31_1 > arg_31_5 - arg_31_6 and arg_31_6 <= var_31_12 and var_31_12 <= arg_31_4 - arg_31_6 then
				return var_31_12, var_31_13, false
			end
		end

		return var_31_0, var_31_1, false
	end

	return var_31_0, var_31_1, true
end

local function var_0_73(arg_32_0)
	arg_32_0 = tostring(arg_32_0)
	arg_32_0 = arg_32_0:gsub("[%c]", "")

	return arg_32_0
end

local var_0_74 = panorama.loadstring("\tvar _GetTimestamp = function() {\n\t\treturn Date.now()/1000\n\t}\n\n\tvar _FormatTimestamp = function(timestamp) {\n\t\tvar date = new Date(timestamp * 1000)\n\n\t\treturn `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} ${date.getHours()}:${date.getMinutes()}`\n\t}\n\n\treturn {\n\t\tget_timestamp: _GetTimestamp,\n\t\tformat_timestamp: _FormatTimestamp\n\t}\n")()
local var_0_75 = setmetatable({}, {
	__index = function(arg_33_0, arg_33_1)
		arg_33_0[arg_33_1] = var_0_74.format_timestamp(arg_33_1)

		return arg_33_0[arg_33_1]
	end
})
local var_0_76 = var_0_74.get_timestamp() - globals.realtime()

local function var_0_77()
	return globals.realtime() + var_0_76
end

local function var_0_78(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	local var_35_0 = arg_35_0 - var_0_77()

	if var_35_0 < 0 or arg_35_1 then
		local var_35_1 = var_0_65(math.abs(var_35_0), arg_35_2, arg_35_3)

		return var_35_0 > 0 and "In " .. var_35_1 or var_35_1 .. " ago"
	else
		return var_0_75[arg_35_0]
	end
end

local var_0_79
local var_0_80

if pcall(client.create_interface) then
	local var_0_81 = require("ffi")
	local var_0_82 = vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)")
	local var_0_83 = vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)")
	local var_0_84 = vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)")
	local var_0_85 = var_0_81.typeof("char[?]")

	function var_0_79()
		local var_36_0 = var_0_82()

		if var_36_0 > 0 then
			local var_36_1 = var_0_85(var_36_0)

			var_0_84(0, var_36_1, var_36_0)

			return var_0_81.string(var_36_1, var_36_0 - 1)
		end
	end

	function var_0_80(arg_37_0)
		var_0_83(arg_37_0, arg_37_0:len())
	end
end

local var_0_86
local var_0_87 = var_0_64(var_0_12, function(arg_38_0, arg_38_1)
	return arg_38_1, arg_38_0
end)

var_0_86 = {
	calculate_move_from_button = function(arg_39_0, arg_39_1)
		return arg_39_0 and 450 or arg_39_1 and -450 or 0
	end,
	compress_usercmds = function(arg_40_0)
		local var_40_0 = {}
		local var_40_1 = {
			viewangles = {
				pitch = arg_40_0[1].pitch,
				yaw = arg_40_0[1].yaw
			},
			buttons = {}
		}

		for iter_40_0, iter_40_1 in pairs(var_0_12) do
			var_40_1.buttons[iter_40_0] = false
		end

		local var_40_2 = 0

		for iter_40_2, iter_40_3 in ipairs(arg_40_0) do
			local var_40_3 = ""

			for iter_40_4, iter_40_5 in pairs(var_40_1.buttons) do
				if iter_40_3[iter_40_4] and not iter_40_5 then
					var_40_3 = var_40_3 .. var_0_12[iter_40_4]
				elseif not iter_40_3[iter_40_4] and iter_40_5 then
					var_40_3 = var_40_3 .. var_0_12[iter_40_4]:lower()
				end

				var_40_1.buttons[iter_40_4] = iter_40_3[iter_40_4]
			end

			local var_40_4 = {
				iter_40_3.pitch - var_40_1.viewangles.pitch,
				iter_40_3.yaw - var_40_1.viewangles.yaw,
				var_40_3,
				iter_40_3.forwardmove,
				iter_40_3.sidemove
			}

			var_40_1.viewangles = {
				pitch = iter_40_3.pitch,
				yaw = iter_40_3.yaw
			}

			if var_40_4[#var_40_4] == var_0_86.calculate_move_from_button(iter_40_3.in_moveright, iter_40_3.in_moveleft) then
				var_40_4[#var_40_4] = nil

				if var_40_4[#var_40_4] == var_0_86.calculate_move_from_button(iter_40_3.in_forward, iter_40_3.in_back) then
					var_40_4[#var_40_4] = nil

					if var_40_4[#var_40_4] == "" then
						var_40_4[#var_40_4] = nil

						if var_40_4[#var_40_4] == 0 then
							var_40_4[#var_40_4] = nil

							if var_40_4[#var_40_4] == 0 then
								var_40_4[#var_40_4] = nil
							end
						end
					end
				end
			end

			if #var_40_4 > 0 then
				if var_40_2 > 0 then
					table.insert(var_40_0, var_40_2)

					var_40_2 = 0
				end

				table.insert(var_40_0, var_40_4)
			else
				var_40_2 = var_40_2 + 1
			end
		end

		if var_40_2 > 0 then
			table.insert(var_40_0, var_40_2)

			local var_40_5 = 0
		end

		return var_40_0
	end,
	parse_buttons_str = function(arg_41_0)
		local var_41_0 = {}
		local var_41_1 = {}

		for iter_41_0 in arg_41_0:gmatch(".") do
			if iter_41_0:lower() == iter_41_0 then
				table.insert(var_41_1, var_0_87[iter_41_0:upper()] or false)
			else
				table.insert(var_41_0, var_0_87[iter_41_0] or false)
			end
		end

		return var_41_0, var_41_1
	end,
	compute_move = function(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
		local var_42_0 = 1e-12

		if var_42_0 > math.abs(arg_42_0) and var_42_0 > math.abs(arg_42_1) then
			return arg_42_0, arg_42_1
		end

		local var_42_1 = var_0_7():init_from_angles(arg_42_2, arg_42_3)
		local var_42_2 = var_42_1:vectors()

		var_42_1.z = 0
		var_42_2.z = 0

		var_42_1:normalize()
		var_42_2:normalize()

		local var_42_3 = var_0_7():init_from_angles(arg_42_4, arg_42_5)
		local var_42_4 = var_42_3:vectors()

		var_42_3.z = 0
		var_42_4.z = 0

		var_42_3:normalize()
		var_42_4:normalize()

		local var_42_5 = var_0_7(var_42_3.x * arg_42_0 + var_42_4.x * arg_42_1, var_42_3.y * arg_42_0 + var_42_4.y * arg_42_1, 0)
		local var_42_6 = var_42_1.x
		local var_42_7 = var_42_2.x
		local var_42_8 = var_42_1.y
		local var_42_9 = var_42_2.y
		local var_42_10 = var_42_5.x
		local var_42_11 = var_42_5.y
		local var_42_12 = var_42_6 * var_42_9 - var_42_7 * var_42_8
		local var_42_13 = (var_42_9 * var_42_10 - var_42_7 * var_42_11) / var_42_12
		local var_42_14 = (var_42_6 * var_42_11 - var_42_8 * var_42_10) / var_42_12
		local var_42_15 = math.min(math.max(var_42_13, -450), 450)

		if var_42_0 > math.abs(var_42_15) then
			var_42_15 = 0
		end

		local var_42_16 = math.min(math.max(var_42_14, -450), 450)

		if var_42_0 > math.abs(var_42_16) then
			var_42_16 = 0
		end

		return var_42_15, var_42_16
	end
}

local function var_0_88()
	local var_43_0 = 0
	local var_43_1 = var_0_7(entity.get_prop(var_43_0, "m_WorldMins"))
	local var_43_2 = var_0_7(entity.get_prop(var_43_0, "m_WorldMaxs"))
	local var_43_3

	if var_43_1 ~= var_0_35 or var_43_2 ~= var_0_35 then
		var_43_3 = string.format("bomb_%.2f_%.2f_%.2f %.2f_%.2f_%.2f", var_43_1.x, var_43_1.y, var_43_1.z, var_43_2.x, var_43_2.y, var_43_2.z)
	end

	if var_43_3 ~= nil then
		return var_0_62(var_43_3)
	end

	return nil
end

local var_0_89 = {
	[1507960924] = "cs_agency",
	[1014664118] = "cs_office",
	[-923663825] = "dz_frostbite",
	[1463756432] = "cs_assault",
	[-1621571143] = "de_dust",
	[371013699] = "de_stmarc",
	[-1890957714] = "ar_shoots",
	[-2011174878] = "de_train",
	[-222265935] = "ar_baggage",
	[405708653] = "de_overpass",
	[790893427] = "dz_sirocco",
	[-542128589] = "ar_monastery",
	[878725495] = "de_bank",
	[-1218081885] = "de_guard",
	[1900771637] = "de_cache",
	[2056138930] = "gd_rialto",
	[2041417734] = "de_cbble",
	[1445192006] = "de_engage",
	[1476824995] = "de_vertigo",
	[-768791216] = "de_dust2",
	[899765791] = "de_safehouse",
	[1364328969] = "cs_militia",
	[-182586077] = "de_aztec",
	[-1411074561] = "de_tulip",
	[-1752602089] = "de_inferno",
	[1722587796] = "de_dust2_old",
	[792319475] = "de_ancient",
	[1563115098] = "de_nuke",
	[-1768287648] = "dz_blacksite",
	[-1541779215] = "de_sugarcane",
	[1238495690] = "ar_dizzy",
	[1850283081] = "de_anubis",
	[-1348292803] = "cs_apollo",
	[549370830] = "de_lake",
	[-1439577949] = "de_canals",
	[1964982021] = "de_elysion",
	[-1639993233] = "de_mirage",
	[-692592072] = "cs_italy"
}

var_0_89[-1482710900] = "de_dust2_old"

local var_0_90 = {
	de_shortnuke = "de_nuke",
	de_shortdust = "de_shortdust"
}
local var_0_91 = {}

local function var_0_92()
	local var_44_0 = globals.mapname()

	if var_44_0 == nil then
		return
	end

	if var_0_91[var_44_0] == nil then
		local var_44_1 = var_44_0:gsub("_scrimmagemap$", "")

		if var_0_90[var_44_1] ~= nil then
			var_44_1 = var_0_90[var_44_1]
		else
			local var_44_2 = false

			for iter_44_0, iter_44_1 in pairs(var_0_89) do
				if iter_44_1 == var_44_1 then
					var_44_2 = true

					break
				end
			end

			if not var_44_2 then
				local var_44_3 = var_0_88()

				if var_0_89[var_44_3] ~= nil then
					var_44_1 = var_0_89[var_44_3]
				end
			end
		end

		var_0_91[var_44_0] = var_44_1
	end

	return var_0_91[var_44_0]
end

if var_0_8 then
	ui.new_label("LUA", "A", "Helper: Debug")
	ui.new_button("LUA", "A", "Create helper map patterns", function()
		local var_45_0 = {
			"de_cache",
			"de_mirage",
			"de_dust2",
			"de_inferno",
			"de_overpass",
			"de_canals",
			"de_train",
			"cs_office",
			"cs_agency",
			"de_vertigo",
			"de_lake",
			"de_nuke",
			"de_safehouse",
			"dz_blacksite",
			"cs_assault",
			"ar_monastery",
			"de_cbble",
			"cs_italy",
			"cs_militia",
			"de_stmarc",
			"ar_baggage",
			"ar_shoots",
			"de_sugarcane",
			"ar_dizzy",
			"de_dust",
			"de_bank",
			"de_tulip",
			"de_aztec",
			"gd_rialto",
			"de_dust2_old",
			"dz_sirocco",
			"de_anubis",
			"cs_apollo",
			"de_ancient",
			"de_elysion",
			"de_engage",
			"dz_frostbite",
			"de_guard"
		}

		var_0_89 = {}
		var_0_8.create_map_patterns_count = #var_45_0
		var_0_8.create_map_patterns_next = {}
		var_0_8.create_map_patterns_index = {}
		var_0_8.create_map_patterns_failed = {}

		for iter_45_0 = 1, #var_45_0 do
			local var_45_1 = var_45_0[iter_45_0]

			if var_0_8.create_map_patterns_next[var_45_1] ~= nil then
				error("Duplicate map " .. var_45_1)
			end

			var_0_8.create_map_patterns_next[var_45_1] = var_45_0[iter_45_0 + 1]
			var_0_8.create_map_patterns_index[var_45_1] = iter_45_0
		end

		var_0_8.create_map_patterns = true
		var_0_8.debug_text = "create_map_patterns progress: " .. 1 .. " / " .. var_0_8.create_map_patterns_count

		client.delay_call(0.5, client.exec, "map ", var_45_0[1])
	end)
end

var_0_46:start("db_read")

local var_0_93 = database.read("helper") or {}

var_0_93.sources = var_0_93.sources or {}

var_0_46:finish("db_read")

local var_0_94 = {
	{
		builtin = true,
		id = "builtin_legit",
		name = "Built-in (Legit)",
		description = "Built-in legit grenades",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/builtin_legit.json",
		type = "remote"
	},
	{
		builtin = true,
		id = "builtin_sothatwemaybefree",
		name = "SoThatWeMayBeFree",
		description = "Grenades from sothatwemaybefree",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/sothatwemaybefree.json",
		type = "remote"
	},
	{
		builtin = true,
		id = "builtin_movement",
		name = "Built-in (Movement)",
		description = "Movement locations for popular maps",
		url = "https://raw.githubusercontent.com/sapphyrus/helper/master/locations/builtin_movement.json",
		type = "remote"
	},
	{
		builtin = true,
		id = "sigma_hvh",
		name = "sigma's HvH locations",
		description = "Revolutionizing spread HvH",
		url = "https://pastebin.com/raw/ewHvQ2tD",
		type = "remote"
	}
}
local var_0_95 = {
	builtin_local_file = true,
	builtin_hvh = true
}

for iter_0_2 = 1, #var_0_94 do
	var_0_95[var_0_94[iter_0_2].id] = true
end

for iter_0_3 = #var_0_93.sources, 1, -1 do
	local var_0_96 = var_0_93.sources[iter_0_3]

	if var_0_96 ~= nil and var_0_95[var_0_96.id] then
		table.remove(var_0_93.sources, iter_0_3)
	end
end

for iter_0_4 = 1, #var_0_94 do
	if var_0_93.sources[iter_0_4] == nil or var_0_93.sources[iter_0_4].id ~= var_0_94[iter_0_4].id then
		table.insert(var_0_93.sources, iter_0_4, var_0_94[iter_0_4])
	end
end

if var_0_8 and readfile("helper_data.json") then
	table.insert(var_0_93.sources, {
		builtin = true,
		id = "builtin_local_file",
		name = "helper_data.json",
		description = "Local file for testing",
		type = "local_file",
		filename = "helper_data.json"
	})

	local var_0_97 = database.read("helper_store") or {}

	var_0_97.locations = var_0_97.locations or {}
	var_0_97.locations.builtin_local_file = {}
end

local var_0_98 = {}
local var_0_99
local var_0_100
local var_0_101 = {}
local var_0_102

local function var_0_103(arg_46_0)
	var_0_102 = nil

	var_0_6(var_0_101)

	if var_0_8 then
		print("flush_active_locations(", arg_46_0, ")")
	end
end

local var_0_104 = {
	__index = function(arg_47_0, arg_47_1)
		if arg_47_0.tickrate ~= nil then
			return arg_47_1 / arg_47_0.tickrate
		end
	end
}
local var_0_105 = {
	__index = {
		get_type_string = function(arg_48_0)
			if arg_48_0.type == "grenade" then
				local var_48_0 = var_0_63(arg_48_0.weapons, function(arg_49_0)
					return var_0_14[arg_49_0]
				end)

				return table.concat(var_48_0, "/")
			elseif arg_48_0.type == "movement" and arg_48_0.weapons[1].type == "grenade" then
				return var_0_10[arg_48_0.type] .. " " .. var_0_14[arg_48_0.weapons[1]]
			else
				return var_0_10[arg_48_0.type] or arg_48_0.type
			end
		end,
		get_export_tbl = function(arg_50_0)
			local var_50_0 = {
				name = arg_50_0.name == arg_50_0.full_name and arg_50_0.name or {
					arg_50_0.full_name:match("^(.*) to (.*)$")
				},
				description = arg_50_0.description,
				weapon = #arg_50_0.weapons == 1 and arg_50_0.weapons[1].console_name or var_0_63(arg_50_0.weapons, function(arg_51_0)
					return arg_51_0.console_name
				end),
				position = {
					arg_50_0.position.x,
					arg_50_0.position.y,
					arg_50_0.position.z
				},
				viewangles = {
					arg_50_0.viewangles.pitch,
					arg_50_0.viewangles.yaw
				},
				target = arg_50_0.target and {
					arg_50_0.target.x,
					arg_50_0.target.y,
					arg_50_0.target.z
				} or nil
			}

			if getmetatable(arg_50_0.tickrates) == var_0_104 then
				if arg_50_0.tickrates.tickrate_set then
					var_50_0.tickrate = arg_50_0.tickrates.tickrate
				end
			elseif arg_50_0.tickrates.orig ~= nil then
				var_50_0.tickrate = arg_50_0.tickrates.orig
			end

			if arg_50_0.approach_accurate ~= nil then
				var_50_0.approach_accurate = arg_50_0.approach_accurate
			end

			if arg_50_0.duckamount ~= 0 then
				var_50_0.duck = arg_50_0.duckamount == 1 and true or arg_50_0.duckamount
			end

			if arg_50_0.position_visibility_different then
				var_50_0.position_visibility = {
					arg_50_0.position_visibility.x - arg_50_0.position.x,
					arg_50_0.position_visibility.y - arg_50_0.position.y,
					arg_50_0.position_visibility.z - arg_50_0.position.z
				}
			end

			if arg_50_0.type == "grenade" then
				var_50_0.grenade = {
					fov = arg_50_0.fov ~= var_0_23.fov and arg_50_0.fov or nil,
					jump = arg_50_0.jump and true or nil,
					strength = arg_50_0.throw_strength ~= 1 and arg_50_0.throw_strength or nil,
					run = arg_50_0.run_duration ~= nil and arg_50_0.run_duration or nil,
					run_yaw = arg_50_0.run_yaw ~= arg_50_0.viewangles.yaw and arg_50_0.run_yaw - arg_50_0.viewangles.yaw or nil,
					run_speed = arg_50_0.run_speed ~= nil and arg_50_0.run_speed or nil,
					recovery_yaw = arg_50_0.recovery_yaw ~= nil and arg_50_0.recovery_yaw - arg_50_0.run_yaw or nil,
					recovery_jump = arg_50_0.recovery_jump and true or nil,
					delay = arg_50_0.delay > 0 and arg_50_0.delay or nil
				}

				if next(var_50_0.grenade) == nil then
					var_50_0.grenade = nil
				end
			elseif arg_50_0.type == "movement" then
				local var_50_1 = {}

				var_50_0.movement = {
					frames = var_0_86.compress_usercmds(arg_50_0.movement_commands),
					endless = arg_50_0.endless and true or nil,
					air_strafe = arg_50_0.air_strafe and true or nil,
					infinite_duck = arg_50_0.infinite_duck and true or nil
				}
			end

			if arg_50_0.destroy_text ~= nil then
				var_50_0.destroy = {
					start = arg_50_0.destroy_start and {
						arg_50_0.destroy_start:unpack()
					} or nil,
					["end"] = {
						arg_50_0.destroy_end:unpack()
					},
					text = arg_50_0.destroy_text ~= var_0_23.destroy_text and arg_50_0.destroy_text or nil
				}
			end

			return var_50_0
		end,
		get_export = function(arg_52_0, arg_52_1)
			local var_52_0 = arg_52_0:get_export_tbl()
			local var_52_1 = "  "
			local var_52_2

			if arg_52_1 then
				local var_52_3 = {
					"name",
					"description",
					"weapon",
					"position",
					"viewangles",
					"position_visibility",
					"grenade"
				}
				local var_52_4 = {
					grenade = 1
				}
				local var_52_5 = {}
				local var_52_6 = {}

				for iter_52_0 = 1, #var_52_3 do
					local var_52_7 = var_52_3[iter_52_0]
					local var_52_8 = var_52_0[var_52_7]

					if var_52_8 ~= nil then
						local var_52_9 = var_52_4[var_52_7] == 1 and var_0_3.stringify(var_52_8, "\n", var_52_1) or json.stringify(var_52_8)

						if type(var_52_8[1]) == "number" and type(var_52_8[2]) == "number" and (var_52_8[3] == nil or type(var_52_8[3]) == "number") then
							var_52_9 = var_52_9:gsub(",", ", ")
						else
							var_52_9 = var_52_9:gsub("\",\"", "\", \"")
						end

						table.insert(var_52_6, string.format("\"%s\": %s", var_52_7, var_52_9))

						var_52_0[var_52_7] = nil
					end
				end

				for iter_52_1, iter_52_2 in pairs(var_52_0) do
					table.insert(var_52_6, string.format("\"%s\": %s", iter_52_1, var_0_3.stringify(var_52_0[iter_52_1], "\n", var_52_1)))
				end

				var_52_2 = "{\n" .. var_52_1 .. table.concat(var_52_6, ",\n"):gsub("\n", "\n" .. var_52_1) .. "\n}"
			else
				var_52_2 = json.stringify(var_52_0)
			end

			return var_52_2
		end
	}
}

local function var_0_106(arg_53_0)
	if type(arg_53_0) ~= "table" then
		return "wrong type, expected table"
	end

	if getmetatable(arg_53_0) == var_0_105 then
		return "trying to create an already created location"
	end

	local var_53_0 = {}

	if type(arg_53_0.name) == "string" and arg_53_0.name:len() > 0 then
		var_53_0.name = var_0_73(arg_53_0.name)
		var_53_0.full_name = var_53_0.name
	elseif type(arg_53_0.name) == "table" and #arg_53_0.name == 2 then
		var_53_0.name = var_0_73(arg_53_0.name[2])
		var_53_0.full_name = var_0_73(string.format("%s to %s", arg_53_0.name[1], arg_53_0.name[2]))
	else
		return "invalid name, expected string or table of length 2"
	end

	if type(arg_53_0.description) == "string" and arg_53_0.description:len() > 0 then
		var_53_0.description = arg_53_0.description
	elseif arg_53_0.description ~= nil then
		return "invalid description, expected nil or non-empty string"
	end

	if type(arg_53_0.weapon) == "string" and var_0_1[arg_53_0.weapon] ~= nil then
		var_53_0.weapons = {
			var_0_1[arg_53_0.weapon]
		}
		var_53_0.weapons_assoc = {
			[var_0_1[arg_53_0.weapon]] = true
		}
	elseif type(arg_53_0.weapon) == "table" and #arg_53_0.weapon > 0 then
		var_53_0.weapons = {}
		var_53_0.weapons_assoc = {}

		for iter_53_0 = 1, #arg_53_0.weapon do
			local var_53_1 = var_0_1[arg_53_0.weapon[iter_53_0]]

			if var_53_1 ~= nil then
				if var_53_0.weapons_assoc[var_53_1] then
					return "duplicate weapon: " .. arg_53_0.weapon[iter_53_0]
				else
					var_53_0.weapons[iter_53_0] = var_53_1
					var_53_0.weapons_assoc[var_53_1] = true
				end
			else
				return "invalid weapon: " .. arg_53_0.weapon[iter_53_0]
			end
		end
	else
		return string.format("invalid weapon (%s)", tostring(arg_53_0.weapon))
	end

	if type(arg_53_0.position) == "table" and #arg_53_0.position == 3 then
		local var_53_2, var_53_3, var_53_4 = unpack(arg_53_0.position)

		if type(var_53_2) == "number" and type(var_53_3) == "number" and type(var_53_4) == "number" then
			var_53_0.position = var_0_7(var_53_2, var_53_3, var_53_4)
			var_53_0.position_visibility = var_53_0.position + var_0_23.visibility_offset
			var_53_0.position_id = var_0_22[var_53_0.position]
		else
			return "invalid type in position"
		end
	else
		return "invalid position"
	end

	if type(arg_53_0.position_visibility) == "table" and #arg_53_0.position_visibility == 3 then
		local var_53_5, var_53_6, var_53_7 = unpack(arg_53_0.position_visibility)

		if type(var_53_5) == "number" and type(var_53_6) == "number" and type(var_53_7) == "number" then
			local var_53_8 = var_53_0.position

			var_53_0.position_visibility = var_0_7(var_53_8.x + var_53_5, var_53_8.y + var_53_6, var_53_8.z + var_53_7)
			var_53_0.position_visibility_different = true
		else
			return "invalid type in position_visibility"
		end
	elseif arg_53_0.position_visibility ~= nil then
		return "invalid position_visibility"
	end

	if type(arg_53_0.viewangles) == "table" and #arg_53_0.viewangles == 2 then
		local var_53_9, var_53_10 = unpack(arg_53_0.viewangles)

		if type(var_53_9) == "number" and type(var_53_10) == "number" then
			var_53_0.viewangles = {
				pitch = var_53_9,
				yaw = var_53_10
			}
			var_53_0.viewangles_forward = var_0_7():init_from_angles(var_53_9, var_53_10)
		else
			return "invalid type in viewangles"
		end
	else
		return "invalid viewangles"
	end

	if type(arg_53_0.approach_accurate) == "boolean" then
		var_53_0.approach_accurate = arg_53_0.approach_accurate
	elseif arg_53_0.approach_accurate ~= nil then
		return "invalid approach_accurate"
	end

	if arg_53_0.duck == nil or type(arg_53_0.duck) == "boolean" then
		var_53_0.duckamount = arg_53_0.duck and 1 or 0
	else
		return string.format("invalid duck value (%s)", tostring(arg_53_0.duck))
	end

	var_53_0.eye_pos = var_53_0.position + var_0_7(0, 0, 64 - var_53_0.duckamount * 18)

	if type(arg_53_0.tickrate) == "number" and arg_53_0.tickrate > 0 or arg_53_0.tickrate == nil then
		var_53_0.tickrates = setmetatable({
			tickrate = arg_53_0.tickrate or 64,
			tickrate_set = arg_53_0.tickrate ~= nil
		}, var_0_104)
	elseif type(arg_53_0.tickrate) == "table" and #arg_53_0.tickrate > 0 then
		var_53_0.tickrates = {
			orig = arg_53_0.tickrate
		}

		local var_53_11

		for iter_53_1 = 1, #arg_53_0.tickrate do
			local var_53_12 = arg_53_0.tickrate[iter_53_1]

			if type(var_53_12) == "number" and var_53_12 > 0 then
				if var_53_11 == nil then
					var_53_11 = var_53_12
					var_53_0.tickrates[var_53_12] = 1
				else
					var_53_0.tickrates[var_53_12] = var_53_11 / var_53_12
				end
			else
				return "invalid tickrate: " .. tostring(arg_53_0.tickrate[iter_53_1])
			end
		end
	else
		return string.format("invalid tickrate (%s)", tostring(arg_53_0.tickrate))
	end

	if type(arg_53_0.target) == "table" then
		local var_53_13, var_53_14, var_53_15 = unpack(arg_53_0.target)

		if type(var_53_13) == "number" and type(var_53_14) == "number" and type(var_53_15) == "number" then
			var_53_0.target = var_0_7(var_53_13, var_53_14, var_53_15)
		else
			return "invalid type in target"
		end
	elseif arg_53_0.target ~= nil then
		return "invalid target"
	end

	local var_53_16
	local var_53_17

	for iter_53_2 = 1, #var_53_0.weapons do
		if var_53_0.weapons[iter_53_2].type == "grenade" then
			var_53_16 = true
		else
			var_53_17 = true
		end
	end

	if var_53_16 and var_53_17 then
		return "can't have grenade and non-grenade in one location"
	end

	if arg_53_0.movement ~= nil then
		var_53_0.type = "movement"
		var_53_0.fov = var_0_23.fov_movement
	elseif var_53_16 then
		var_53_0.type = "grenade"
		var_53_0.throw_strength = 1
		var_53_0.fov = var_0_23.fov
		var_53_0.delay = 0
		var_53_0.jump = false
		var_53_0.run_yaw = var_53_0.viewangles.yaw
	elseif var_53_17 then
		var_53_0.type = "wallbang"
	else
		return "invalid type"
	end

	if var_53_0.viewangles_forward ~= nil and var_53_0.eye_pos ~= nil then
		local var_53_18 = var_53_0.eye_pos + var_53_0.viewangles_forward * 700
		local var_53_19, var_53_20, var_53_21 = var_0_67(var_53_0.eye_pos, var_53_18, 2)

		var_53_0.viewangles_target = var_53_19 > 0.05 and var_53_21 or var_53_18
	end

	if var_53_0.type == "grenade" and type(arg_53_0.grenade) == "table" then
		local var_53_22 = arg_53_0.grenade

		if type(var_53_22.strength) == "number" and var_53_22.strength >= 0 and var_53_22.strength <= 1 then
			var_53_0.throw_strength = var_53_22.strength
		elseif var_53_22.strength ~= nil then
			return string.format("invalid grenade.strength (%s)", tostring(var_53_22.strength))
		end

		if type(var_53_22.delay) == "number" and var_53_22.delay > 0 then
			var_53_0.delay = var_53_22.delay
		elseif var_53_22.delay ~= nil then
			return string.format("invalid grenade.delay (%s)", tostring(var_53_22.delay))
		end

		if type(var_53_22.fov) == "number" and var_53_22.fov >= 0 and var_53_22.fov <= 180 then
			var_53_0.fov = var_53_22.fov
		elseif var_53_22.fov ~= nil then
			return string.format("invalid grenade.fov (%s)", tostring(var_53_22.fov))
		end

		if type(var_53_22.jump) == "boolean" then
			var_53_0.jump = var_53_22.jump
		elseif var_53_22.jump ~= nil then
			return string.format("invalid grenade.jump (%s)", tostring(var_53_22.jump))
		end

		if type(var_53_22.run) == "number" and var_53_22.run > 0 and var_53_22.run < 512 then
			var_53_0.run_duration = var_53_22.run
		elseif var_53_22.run ~= nil then
			return string.format("invalid grenade.run (%s)", tostring(var_53_22.run))
		end

		if type(var_53_22.run_yaw) == "number" and var_53_22.run_yaw >= -180 and var_53_22.run_yaw <= 180 then
			var_53_0.run_yaw = var_53_0.viewangles.yaw + var_53_22.run_yaw
		elseif var_53_22.run_yaw ~= nil then
			return string.format("invalid grenade.run_yaw (%s)", tostring(var_53_22.run_yaw))
		end

		if type(var_53_22.run_speed) == "boolean" then
			var_53_0.run_speed = var_53_22.run_speed
		elseif var_53_22.run_speed ~= nil then
			return "invalid grenade.run_speed"
		end

		if type(var_53_22.recovery_yaw) == "number" then
			var_53_0.recovery_yaw = var_53_0.run_yaw + var_53_22.recovery_yaw
		elseif var_53_22.recovery_yaw ~= nil then
			return "invalid grenade.recovery_yaw"
		end

		if type(var_53_22.recovery_jump) == "boolean" then
			var_53_0.recovery_jump = var_53_22.recovery_jump
		elseif var_53_22.recovery_jump ~= nil then
			return "invalid grenade.recovery_jump"
		end
	elseif arg_53_0.grenade ~= nil then
		return "invalid grenade"
	end

	if var_53_0.type == "movement" and type(arg_53_0.movement) == "table" then
		local var_53_23 = arg_53_0.movement

		if type(var_53_23.fov) == "number" and var_53_23.fov > 0 and var_53_23.fov < 360 then
			var_53_0.fov = var_53_23.fov
		elseif var_53_23.fov ~= nil then
			return "invalid movement.fov"
		end

		if type(var_53_23.endless) == "boolean" then
			var_53_0.endless = var_53_23.endless
		elseif var_53_23.endless ~= nil then
			return "invalid movement.endless"
		end

		if type(var_53_23.air_strafe) == "boolean" then
			var_53_0.air_strafe = var_53_23.air_strafe
		elseif var_53_23.air_strafe ~= nil then
			return "invalid movement.air_strafe"
		end

		if type(var_53_23.infinite_duck) == "boolean" then
			var_53_0.infinite_duck = var_53_23.infinite_duck
		elseif var_53_23.infinite_duck ~= nil then
			return "invalid movement.infinite_duck"
		end

		if type(var_53_23.frames) == "table" then
			local var_53_24 = {}

			for iter_53_3, iter_53_4 in ipairs(var_53_23.frames) do
				if type(iter_53_4) == "number" then
					if var_53_23.frames[iter_53_3] > 0 then
						for iter_53_5 = 1, iter_53_4 do
							table.insert(var_53_24, {})
						end
					else
						return "invalid frame " .. tostring(iter_53_3)
					end
				elseif type(iter_53_4) == "table" then
					table.insert(var_53_24, iter_53_4)
				end
			end

			local var_53_25 = {
				viewangles = {
					pitch = var_53_0.viewangles.pitch,
					yaw = var_53_0.viewangles.yaw
				},
				buttons = {}
			}

			for iter_53_6, iter_53_7 in pairs(var_0_12) do
				var_53_25.buttons[iter_53_6] = false
			end

			for iter_53_8, iter_53_9 in ipairs(var_53_24) do
				local var_53_26, var_53_27, var_53_28, var_53_29, var_53_30 = unpack(iter_53_9)

				if var_53_26 ~= nil and type(var_53_26) ~= "number" then
					return string.format("invalid pitch in frame #%d", iter_53_8)
				elseif var_53_27 ~= nil and type(var_53_27) ~= "number" then
					return string.format("invalid yaw in frame #%d", iter_53_8)
				end

				var_53_25.viewangles.pitch = var_53_25.viewangles.pitch + (var_53_26 or 0)
				var_53_25.viewangles.yaw = var_53_25.viewangles.yaw + (var_53_27 or 0)

				if type(var_53_28) == "string" then
					local var_53_31, var_53_32 = var_0_86.parse_buttons_str(var_53_28)
					local var_53_33 = {}

					for iter_53_10, iter_53_11 in ipairs(var_53_31) do
						if iter_53_11 == false then
							return string.format("invalid button in frame #%d", iter_53_8)
						elseif var_53_33[iter_53_11] then
							return string.format("invalid frame #%d: duplicate button %s", iter_53_8, iter_53_11)
						end

						var_53_33[iter_53_11] = true
						var_53_25.buttons[iter_53_11] = true
					end

					for iter_53_12, iter_53_13 in ipairs(var_53_32) do
						if iter_53_13 == false then
							return string.format("invalid button in frame #%d", iter_53_8)
						elseif var_53_33[iter_53_13] then
							return string.format("invalid frame #%d: duplicate button %s", iter_53_8, iter_53_13)
						end

						var_53_33[iter_53_13] = true
						var_53_25.buttons[iter_53_13] = false
					end
				elseif var_53_28 ~= nil then
					return string.format("invalid buttons in frame #%d", iter_53_8)
				end

				if type(var_53_29) == "number" and var_53_29 >= -450 and var_53_29 <= 450 then
					var_53_25.forwardmove = var_53_29
				elseif var_53_29 ~= nil then
					return string.format("invalid forwardmove in frame #%d: %s", iter_53_8, tostring(var_53_29))
				else
					var_53_25.forwardmove = var_0_86.calculate_move_from_button(var_53_25.buttons.in_forward, var_53_25.buttons.in_back)
				end

				if type(var_53_30) == "number" and var_53_30 >= -450 and var_53_30 <= 450 then
					var_53_25.sidemove = var_53_30
				elseif var_53_30 ~= nil then
					return string.format("invalid sidemove in frame #%d: %s", iter_53_8, tostring(var_53_30))
				else
					var_53_25.sidemove = var_0_86.calculate_move_from_button(var_53_25.buttons.in_moveright, var_53_25.buttons.in_moveleft)
				end

				var_53_24[iter_53_8] = {
					pitch = var_53_25.viewangles.pitch,
					yaw = var_53_25.viewangles.yaw,
					forwardmove = var_53_25.forwardmove,
					sidemove = var_53_25.sidemove
				}

				for iter_53_14, iter_53_15 in pairs(var_53_25.buttons) do
					var_53_24[iter_53_8][iter_53_14] = iter_53_15
				end
			end

			var_53_0.movement_commands = var_53_24
		else
			return "invalid movement.frames"
		end
	elseif arg_53_0.movement ~= nil then
		return "invalid movement"
	end

	if type(arg_53_0.destroy) == "table" then
		local var_53_34 = arg_53_0.destroy

		var_53_0.destroy_text = "Break the object"

		if type(var_53_34.start) == "table" then
			local var_53_35, var_53_36, var_53_37 = unpack(var_53_34.start)

			if type(var_53_35) == "number" and type(var_53_36) == "number" and type(var_53_37) == "number" then
				var_53_0.destroy_start = var_0_7(var_53_35, var_53_36, var_53_37)
			else
				return "invalid type in destroy.start"
			end
		elseif var_53_34.start ~= nil then
			return "invalid destroy.start"
		end

		if type(var_53_34["end"]) == "table" then
			local var_53_38, var_53_39, var_53_40 = unpack(var_53_34["end"])

			if type(var_53_38) == "number" and type(var_53_39) == "number" and type(var_53_40) == "number" then
				var_53_0.destroy_end = var_0_7(var_53_38, var_53_39, var_53_40)
			else
				return "invalid type in destroy.end"
			end
		else
			return "invalid destroy.end"
		end

		if type(var_53_34.text) == "string" and var_53_34.text:len() > 0 then
			var_53_0.destroy_text = var_53_34.text
		elseif var_53_34.text ~= nil then
			return "invalid destroy.text"
		end
	elseif arg_53_0.destroy ~= nil then
		return "invalid destroy"
	end

	return setmetatable(var_53_0, var_0_105)
end

local function var_0_107(arg_54_0, arg_54_1)
	local var_54_0

	if type(arg_54_0) == "string" then
		local var_54_1
		local var_54_2, var_54_3 = pcall(json.parse, arg_54_0)

		var_54_0 = var_54_3

		if not var_54_2 then
			error(var_54_0)

			return
		end
	elseif type(arg_54_0) == "table" then
		var_54_0 = arg_54_0
	else
		assert(false)
	end

	if type(var_54_0) ~= "table" then
		error(string.format("invalid type %s, expected table", type(var_54_0)))

		return
	end

	local var_54_4 = {}

	for iter_54_0 = 1, #var_54_0 do
		local var_54_5 = var_0_106(var_54_0[iter_54_0])

		if type(var_54_5) == "table" then
			table.insert(var_54_4, var_54_5)
		else
			error(var_54_5 or "failed to parse")

			return
		end
	end

	return var_54_4
end

local function var_0_108(arg_55_0, arg_55_1)
	local var_55_0 = "  "
	local var_55_1 = {}

	for iter_55_0 = 1, #arg_55_0 do
		local var_55_2 = arg_55_0[iter_55_0]:get_export(arg_55_1)

		if arg_55_1 then
			var_55_2 = var_55_0 .. var_55_2:gsub("\n", "\n" .. var_55_0)
		end

		table.insert(var_55_1, var_55_2)
	end

	return (arg_55_1 and "[\n" or "[") .. table.concat(var_55_1, arg_55_1 and ",\n" or ",") .. (arg_55_1 and "\n]" or "]")
end

local function var_0_109(arg_56_0, arg_56_1)
	return arg_56_0.distsqr > arg_56_1.distsqr
end

local function var_0_110(arg_57_0, arg_57_1)
	return arg_57_1.distsqr > arg_57_0.distsqr
end

local function var_0_111(arg_58_0, arg_58_1)
	var_0_0.get(arg_58_0:gsub("^https://raw.githubusercontent.com/", var_0_24), {
		network_timeout = 5,
		absolute_timeout = 10,
		params = {
			ts = var_0_77()
		}
	}, function(arg_59_0, arg_59_1)
		local var_59_0 = {}

		if not arg_59_0 or arg_59_1.status ~= 200 or arg_59_1.body == "404: Not Found" then
			if arg_59_1.body == "404: Not Found" then
				arg_58_1("404 - Not Found")
			else
				arg_58_1(string.format("%s - %s", arg_59_1.status, arg_59_1.status_message))
			end

			return
		end

		local var_59_1, var_59_2 = pcall(json.parse, arg_59_1.body)

		if not var_59_1 then
			arg_58_1("Invalid JSON: " .. var_59_2)

			return
		end

		if type(var_59_2.name) == "string" then
			var_59_0.name = var_59_2.name
		else
			arg_58_1("Invalid name")

			return
		end

		if var_59_2.description == nil or type(var_59_2.description) == "string" then
			var_59_0.description = var_59_2.description
		else
			arg_58_1("Invalid description")

			return
		end

		if var_59_2.update_timestamp == nil or type(var_59_2.update_timestamp) == "number" then
			var_59_0.update_timestamp = var_59_2.update_timestamp
		else
			arg_58_1("Invalid update_timestamp")

			return
		end

		if var_59_2.url_format ~= nil then
			if type(var_59_2.url_format) ~= "string" or not var_59_2.url_format:match("^https?://.+$") then
				arg_58_1("Invalid url_format")

				return
			end

			if not var_59_2.url_format:find("%%map%%") then
				arg_58_1("Invalid url_format - %map% is required")

				return
			end

			var_59_0.url_format = var_59_2.url_format
		else
			var_59_0.url_format = nil
		end

		var_59_0.location_aliases = {}
		var_59_0.locations = {}

		if type(var_59_2.locations) == "table" then
			for iter_59_0, iter_59_1 in pairs(var_59_2.locations) do
				if type(iter_59_0) ~= "string" then
					arg_58_1("Invalid key in locations")

					return
				end

				if type(iter_59_1) == "string" then
					var_59_0.location_aliases[iter_59_0] = iter_59_1
				elseif type(iter_59_1) == "table" then
					var_59_0.locations[iter_59_0] = iter_59_1
				elseif var_59_2.url_format ~= nil then
					arg_58_1("Location data is forbidden for split locations")

					return
				end
			end
		elseif var_59_2.locations ~= nil then
			arg_58_1("Invalid locations")

			return
		end

		if next(var_59_0.location_aliases) == nil then
			var_59_0.location_aliases = nil
		end

		if next(var_59_0.locations) == nil then
			var_59_0.locations = nil
		end

		var_59_0.last_updated = var_0_77()

		arg_58_1(nil, var_59_0)
	end)
end

local var_0_112 = {
	__index = {
		update_remote_data = function(arg_60_0)
			if not arg_60_0.type == "remote" or arg_60_0.url == nil then
				return
			end

			arg_60_0.remote_status = "Loading index data..."

			var_0_111(arg_60_0.url, function(arg_61_0, arg_61_1)
				if arg_61_0 ~= nil then
					arg_60_0.remote_status = string.format("Error: %s", arg_61_0)

					var_0_99()

					return
				end

				arg_60_0.last_updated = arg_61_1.last_updated

				if arg_60_0.last_updated == nil then
					arg_60_0.remote_status = "Index data refreshed"

					var_0_99()

					arg_60_0.remote_status = nil
				else
					arg_60_0.remote_status = nil

					var_0_99()
				end

				local var_61_0 = {
					"name",
					"description",
					"update_timestamp",
					"url_format"
				}

				for iter_61_0 = 1, #var_61_0 do
					arg_60_0[var_61_0[iter_61_0]] = arg_61_1[var_61_0[iter_61_0]]
				end

				if arg_61_1.url ~= nil and arg_61_1.url ~= arg_60_0.url then
					arg_60_0.url = arg_61_1.url

					arg_60_0:update_remote_data()

					return
				end

				local var_61_1 = var_0_92()

				var_0_98[arg_60_0] = nil

				local var_61_2 = (database.read("helper_store") or {}).locations

				if var_61_2 ~= nil and type(var_61_2[arg_60_0.id]) == "table" then
					var_61_2[arg_60_0.id] = {}
				end

				var_0_103("update_remote_data")

				if arg_61_1.locations ~= nil then
					var_0_98[arg_60_0] = {}

					for iter_61_1, iter_61_2 in pairs(arg_61_1.locations) do
						local var_61_3, var_61_4 = pcall(var_0_107, iter_61_2, iter_61_1)

						if not var_61_3 then
							arg_60_0.remote_status = string.format("Invalid map data: %s", var_61_4)

							client.error_log(string.format("Failed to load map data for %s (%s): %s", arg_60_0.name, iter_61_1, var_61_4))
							var_0_99()

							return
						end

						var_0_98[arg_60_0][iter_61_1] = var_61_4

						arg_60_0:store_write(iter_61_1)

						if iter_61_1 == var_61_1 then
							var_0_103("B")
						else
							var_0_98[arg_60_0][iter_61_1] = nil
						end
					end
				end
			end)
		end,
		store_read = function(arg_62_0, arg_62_1)
			if arg_62_1 == nil then
				local var_62_0 = (database.read("helper_store") or {}).locations

				if var_62_0 ~= nil and type(var_62_0[arg_62_0.id]) == "table" then
					for iter_62_0, iter_62_1 in pairs(var_62_0[arg_62_0.id]) do
						arg_62_0:store_read(iter_62_0)
					end
				end

				return
			end

			local var_62_1 = (database.read("helper_store") or {}).locations

			if var_62_1 ~= nil and type(var_62_1[arg_62_0.id]) == "table" and type(var_62_1[arg_62_0.id][arg_62_1]) == "string" then
				local var_62_2, var_62_3 = pcall(var_0_107, var_62_1[arg_62_0.id][arg_62_1], arg_62_1)

				if not var_62_2 then
					arg_62_0.remote_status = string.format("Invalid map data for %s in database: %s", arg_62_1, var_62_3)

					client.error_log(string.format("Invalid map data for %s (%s) in database: %s", arg_62_0.name, arg_62_1, var_62_3))
					var_0_99()
				elseif #var_62_3 > 0 then
					var_0_98[arg_62_0][arg_62_1] = var_62_3
				end
			end
		end,
		store_write = function(arg_63_0, arg_63_1)
			if arg_63_1 == nil then
				if var_0_98[arg_63_0] ~= nil then
					for iter_63_0, iter_63_1 in pairs(var_0_98[arg_63_0]) do
						arg_63_0:store_write(iter_63_0)
					end
				end

				return
			end

			local var_63_0 = database.read("helper_store") or {}

			var_63_0.locations = var_63_0.locations or {}
			var_63_0.locations[arg_63_0.id] = var_63_0.locations[arg_63_0.id] or {}
			var_63_0.locations[arg_63_0.id][arg_63_1] = var_0_108(var_0_98[arg_63_0][arg_63_1])

			database.write("helper_store", var_63_0)
		end,
		get_locations = function(arg_64_0, arg_64_1, arg_64_2)
			if var_0_98[arg_64_0] == nil then
				var_0_98[arg_64_0] = {}
			end

			if var_0_98[arg_64_0][arg_64_1] == nil then
				arg_64_0:store_read(arg_64_1)

				local var_64_0 = var_0_98[arg_64_0][arg_64_1]

				if arg_64_0.type == "remote" and arg_64_2 and (arg_64_0.last_updated == nil or var_0_77() - arg_64_0.last_updated > (arg_64_0.ttl or var_0_23.source_ttl)) then
					arg_64_0:update_remote_data()
				end

				if arg_64_0.type == "local_file" and arg_64_1 ~= nil then
					client.delay_call(0.5, function()
						var_0_46:start("readfile")

						local var_65_0 = readfile(arg_64_0.filename)
						local var_65_1 = json.parse(var_65_0)
						local var_65_2 = var_0_92()

						for iter_65_0, iter_65_1 in pairs(var_65_1) do
							local var_65_3, var_65_4 = pcall(var_0_107, iter_65_1, iter_65_0)

							if not var_65_3 then
								arg_64_0.remote_status = string.format("Invalid map data: %s", var_65_4)

								client.error_log(string.format("Failed to load map data for %s (%s): %s", arg_64_0.name, iter_65_0, var_65_4))
								var_0_99()

								return
							end

							if var_0_8 then
								local var_65_5 = {
									"viewangles",
									"position"
								}

								for iter_65_2 = 1, #iter_65_1 do
									local var_65_6 = var_0_106(iter_65_1[iter_65_2])

									if type(var_65_6) ~= "table" then
										client.log("failed to create! ", var_65_6)
									else
										local var_65_7 = var_65_6:get_export_tbl()

										for iter_65_3 = 1, #var_65_5 do
											var_65_7[var_65_5[iter_65_3]] = nil
											iter_65_1[iter_65_2][var_65_5[iter_65_3]] = nil
										end

										if var_65_7.destroy ~= nil then
											var_65_7.destroy.start = nil
											var_65_7.destroy["end"] = nil
										end

										if iter_65_1[iter_65_2].destroy ~= nil then
											iter_65_1[iter_65_2].destroy.start = nil
											iter_65_1[iter_65_2].destroy["end"] = nil
										end

										local var_65_8 = json.stringify(var_65_7)
										local var_65_9 = json.stringify(iter_65_1[iter_65_2])

										if var_65_9:len() ~= var_65_8:len() then
											client.log("  orig: ", var_65_9)
											client.log("export: ", var_65_8)
										end
									end
								end
							end

							var_0_98[arg_64_0][iter_65_0] = var_65_4

							var_0_103()
							arg_64_0:store_write(iter_65_0)

							if iter_65_0 ~= var_65_2 then
								var_0_98[arg_64_0][iter_65_0] = nil
							end
						end

						var_0_46:finish("readfile")
					end)
				elseif var_64_0 == nil and arg_64_2 and arg_64_0.type == "remote" and arg_64_0.url_format ~= nil then
					local var_64_1 = arg_64_0.url_format:gsub("%%map%%", arg_64_1):gsub("^https://raw.githubusercontent.com/", var_0_24)

					arg_64_0.remote_status = string.format("Loading map data for %s...", arg_64_1)

					var_0_99()
					var_0_0.get(var_64_1, {
						network_timeout = 10,
						absolute_timeout = 15,
						params = {
							ts = var_0_77()
						}
					}, function(arg_66_0, arg_66_1)
						if not arg_66_0 or arg_66_1.status ~= 200 or arg_66_1.body == "404: Not Found" then
							if arg_66_1.status == 404 or arg_66_1.body == "404: Not Found" then
								arg_64_0.remote_status = string.format("No locations found for %s.", arg_64_1)
							else
								arg_64_0.remote_status = string.format("Failed to fetch %s: %s %s", arg_64_1, arg_66_1.status, arg_66_1.status_message)
							end

							var_0_99()

							return
						end

						local var_66_0, var_66_1 = pcall(var_0_107, arg_66_1.body, arg_64_1)

						if not var_66_0 then
							arg_64_0.remote_status = string.format("Invalid map data: %s", var_66_1)

							var_0_99()
							client.error_log(string.format("Failed to load map data for %s (%s): %s", arg_64_0.name, arg_64_1, var_66_1))

							return
						end

						if var_0_98[arg_64_0] ~= nil then
							var_0_98[arg_64_0][arg_64_1] = var_66_1

							arg_64_0:store_write(arg_64_1)

							arg_64_0.remote_status = nil

							var_0_99()
							var_0_103("C")
						end
					end)
				elseif var_64_0 == nil then
					-- block empty
				end

				var_0_98[arg_64_0][arg_64_1] = var_64_0 or {}
			end

			return var_0_98[arg_64_0][arg_64_1]
		end,
		get_all_locations = function(arg_67_0)
			local var_67_0 = {}
			local var_67_1 = (database.read("helper_store") or {}).locations

			if var_67_1 ~= nil and type(var_67_1[arg_67_0.id]) == "table" then
				for iter_67_0, iter_67_1 in pairs(var_67_1[arg_67_0.id]) do
					var_67_0[iter_67_0] = arg_67_0:get_locations(iter_67_0)
				end
			end

			return var_67_0
		end,
		cleanup = function(arg_68_0)
			arg_68_0.remote_status = nil

			setmetatable(arg_68_0, nil)
		end
	}
}

for iter_0_5 = 1, #var_0_93.sources do
	setmetatable(var_0_93.sources[iter_0_5], var_0_112)
end

local var_0_113 = ui.new_string("Helper: config", "{}")

local function var_0_114()
	local var_69_0 = json.parse(ui.get(var_0_113) or "{}")
	local var_69_1 = {}

	var_69_0.enabled = var_69_0.enabled or {}

	for iter_69_0 = 1, #var_0_93.sources do
		local var_69_2 = var_0_93.sources[iter_69_0]

		var_69_1[var_69_2.id] = true

		if var_69_0.enabled[var_69_2.id] == nil then
			var_69_0.enabled[var_69_2.id] = true
		end
	end

	for iter_69_1, iter_69_2 in pairs(var_69_0.enabled) do
		if var_69_1[iter_69_1] == nil then
			var_69_0.enabled[iter_69_1] = nil
		end
	end

	return var_69_0
end

local function var_0_115(arg_70_0)
	ui.set(var_0_113, json.stringify(arg_70_0))
end

local function var_0_116(arg_71_0, arg_71_1, arg_71_2, arg_71_3, arg_71_4)
	local var_71_0
	local var_71_1
	local var_71_2
	local var_71_3

	var_71_0 = ui.new_button(arg_71_0, arg_71_1, arg_71_2, function()
		ui.set_visible(var_71_0, false)
		ui.set_visible(var_71_1, true)
		ui.set_visible(var_71_2, true)

		local var_72_0 = globals.realtime()

		var_71_3 = var_72_0

		client.delay_call(5, function()
			if var_71_3 == var_72_0 then
				ui.set_visible(var_71_0, true)
				ui.set_visible(var_71_1, false)
				ui.set_visible(var_71_2, false)

				if arg_71_4 ~= nil then
					arg_71_4()
				end
			end
		end)
	end)
	var_71_1 = ui.new_button(arg_71_0, arg_71_1, arg_71_2 .. " (CANCEL)", function()
		ui.set_visible(var_71_0, true)
		ui.set_visible(var_71_1, false)
		ui.set_visible(var_71_2, false)

		if arg_71_4 ~= nil then
			arg_71_4()
		end

		var_71_3 = nil
	end)
	var_71_2 = ui.new_button(arg_71_0, arg_71_1, arg_71_2 .. " (CONFIRM)", function()
		ui.set_visible(var_71_0, true)
		ui.set_visible(var_71_1, false)
		ui.set_visible(var_71_2, false)

		var_71_3 = nil

		arg_71_3()

		if arg_71_4 ~= nil then
			arg_71_4()
		end
	end)

	return var_71_0, var_71_1, var_71_2
end

local var_0_117 = ui.reference("MISC", "Settings", "DPI scale")
local var_0_118 = ui.reference("MISC", "Movement", "Air strafe")
local var_0_119 = ui.reference("MISC", "Miscellaneous", "Automatic grenade release")
local var_0_120 = ui.reference("MISC", "Movement", "Easy strafe")
local var_0_121 = ui.reference("MISC", "Movement", "Avoid collisions")
local var_0_122 = ui.reference("MISC", "Movement", "Air duck")
local var_0_123 = ui.reference("MISC", "Miscellaneous", "Super toss")
local var_0_124 = ui.reference("MISC", "Settings", "Faster grenade toss")
local var_0_125 = ui.reference("MISC", "Movement", "Infinite duck")
local var_0_126 = ui.reference("AA", "Fake lag", "Limit")
local var_0_127 = ui.reference("AA", "Anti-aimbot angles", "Enabled")
local var_0_128 = ui.reference("AA", "Anti-aimbot angles", "Pitch")
local var_0_129 = ui.reference("AA", "Anti-aimbot angles", "Yaw base")
local var_0_130, var_0_131 = ui.reference("AA", "Anti-aimbot angles", "Yaw")
local var_0_132, var_0_133 = ui.reference("RAGE", "Aimbot", "Double tap")
local var_0_134, var_0_135 = ui.reference("AA", "Other", "On shot anti-aim")
local var_0_136 = ui.new_checkbox("VISUALS", "Other ESP", "Helper")
local var_0_137 = ui.new_hotkey("VISUALS", "Other ESP", "Helper hotkey", true)
local var_0_138 = ui.new_color_picker("VISUALS", "Other ESP", "Helper color", 120, 120, 255, 255)
local var_0_139 = ui.new_multiselect("VISUALS", "Other ESP", "\nHelper types\nv3", {
	"Smoke",
	"Flashbang",
	"High Explosive",
	"Molotov",
	"Movement",
	"Location",
	"Area"
})
local var_0_140 = ui.new_combobox("VISUALS", "Other ESP", "Aim at locations", {
	"Off",
	"Legit",
	"Legit (Silent)",
	"Rage"
})
local var_0_141 = ui.new_slider("VISUALS", "Other ESP", "\nHelper Aimbot FOV", 0, 200, 80, true, "°", 0.1)
local var_0_142 = ui.new_slider("VISUALS", "Other ESP", "\nHelper Aimbot Speed", 0, 100, 75, true, "%", 1, {
	[0] = "∞"
})
local var_0_143 = ui.new_checkbox("VISUALS", "Other ESP", "Show locations behind walls")
local var_0_144 = {
	title = ui.new_checkbox("LUA", "A", "Helper: Manage sources"),
	list = ui.new_listbox("LUA", "A", "Helper sources", {}),
	source_label1 = ui.new_label("LUA", "A", "Source label 1"),
	enabled = ui.new_checkbox("LUA", "A", "Enabled"),
	source_label2 = ui.new_label("LUA", "A", "Source label 2"),
	source_label3 = ui.new_label("LUA", "A", "Source label 3"),
	name = ui.new_textbox("LUA", "A", "New source name")
}
local var_0_145
local var_0_146
local var_0_147
local var_0_148
local var_0_149
local var_0_150 = {
	list = ui.new_listbox("LUA", "A", "Selected source locations", {}),
	show_all = ui.new_checkbox("LUA", "A", "Show all maps"),
	sort_by = ui.new_combobox("LUA", "A", "Sort by", {
		"Creation date",
		"Type",
		"Alphabetically"
	}),
	type_label = ui.new_label("LUA", "B", "Creating new location"),
	type = ui.new_combobox("LUA", "B", "\nLocation Type", {
		"Grenade",
		"Movement",
		"Location",
		"Area"
	}),
	from_label = ui.new_label("LUA", "B", "From"),
	from = ui.new_textbox("LUA", "B", "From"),
	to_label = ui.new_label("LUA", "B", "To"),
	to = ui.new_textbox("LUA", "B", "To"),
	description_label = ui.new_label("LUA", "B", "Description (Optional)"),
	description = ui.new_textbox("LUA", "B", "To"),
	grenade_properties = ui.new_multiselect("LUA", "B", "Grenade Properties", {
		"Jump",
		"Run",
		"Walk (Shift)",
		"Throw strength",
		"Force-enable recovery",
		"Tickrate dependent",
		"Destroy breakable object",
		"Delayed throw"
	}),
	throw_strength = ui.new_combobox("LUA", "B", "Throw strength", {
		"Left Click",
		"Left / Right Click",
		"Right Click"
	}),
	run_direction = ui.new_combobox("LUA", "B", "Run duration / direction", {
		"Forward",
		"Left",
		"Right",
		"Back",
		"Custom"
	}),
	run_direction_custom = ui.new_slider("LUA", "B", "\nCustom run direction", -180, 180, 0, true, "°"),
	run_duration = ui.new_slider("LUA", "B", "\nRun duration", 1, 256, 20, true, "t"),
	delay = ui.new_slider("LUA", "B", "Throw delay", 1, 40, 0, true, "t"),
	recovery_direction = ui.new_combobox("LUA", "B", "Recovery (after throw) direction", {
		"Back",
		"Forward",
		"Left",
		"Right",
		"Custom"
	}),
	recovery_direction_custom = ui.new_slider("LUA", "B", "\nCustom recovery direction", -180, 180, 0, true, "°", -1),
	recovery_duration = ui.new_slider("LUA", "B", "Recovery duration", 0, 128, 0, true, "t", 1, {
		[0] = "Auto"
	}),
	recovery_jump = ui.new_checkbox("LUA", "B", "Recovery bunny-hop"),
	record_label = ui.new_label("LUA", "B", "Record hotkey"),
	set = ui.new_button("LUA", "B", "Set location", function()
		var_0_148()
	end),
	set_hotkey = ui.new_hotkey("LUA", "B", "Helper set location hotkey", true),
	teleport = ui.new_button("LUA", "B", "Teleport", function()
		var_0_147()
	end),
	teleport_hotkey = ui.new_hotkey("LUA", "B", "Helper teleport hotkey", true),
	export = ui.new_button("LUA", "B", "Export to clipboard", function()
		var_0_149()
	end),
	save = ui.new_button("LUA", "B", "Save", function()
		var_0_145()
	end)
}

var_0_150.delete, var_0_150.delete_cancel, var_0_150.delete_confirm = var_0_116("LUA", "B", "Delete", function()
	var_0_146()
end, var_0_99)
var_0_150.delete_hotkey = ui.new_hotkey("LUA", "B", "Helper delete hotkey", true)

local var_0_151 = {}
local var_0_152 = false
local var_0_153 = false
local var_0_154
local var_0_155
local var_0_156
local var_0_157
local var_0_158
local var_0_159
local var_0_160
local var_0_161

var_0_144.edit = ui.new_button("LUA", "A", "Edit", function()
	var_0_155()
end)
var_0_144.update = ui.new_button("LUA", "A", "Update", function()
	var_0_157()
end)
var_0_144.delete, var_0_144.delete_cancel, var_0_144.delete_confirm = var_0_116("LUA", "A", "Delete", function()
	var_0_158()
end, var_0_99)
var_0_144.create = ui.new_button("LUA", "A", "Create", function()
	var_0_159()
end)
var_0_144.import = ui.new_button("LUA", "A", "Import from clipboard", function()
	var_0_160()
end)
var_0_144.export = ui.new_button("LUA", "A", "Export all to clipboard", function()
	var_0_161()
end)
var_0_144.back = ui.new_button("LUA", "A", "Back", function()
	var_0_156()
end)
var_0_144.source_label4 = ui.new_label("LUA", "A", "Ready.")

local var_0_162 = {}
local var_0_163 = false
local var_0_164 = false
local var_0_165
local var_0_166
local var_0_167 = setmetatable({}, {
	__mode = "k"
})
local var_0_168 = setmetatable({}, {
	__mode = "k"
})
local var_0_169 = setmetatable({}, {
	__mode = "k"
})
local var_0_170 = {
	[var_0_150.set_hotkey] = false,
	[var_0_150.teleport_hotkey] = false,
	[var_0_150.delete_hotkey] = false
}

local function var_0_171(arg_88_0)
	arg_88_0 = arg_88_0 or "add_local"

	if arg_88_0 == var_0_165 then
		return false
	end

	for iter_88_0 = 1, #var_0_162 do
		if var_0_162[iter_88_0] == arg_88_0 then
			ui.set(var_0_144.list, iter_88_0 - 1)

			var_0_164 = false

			return true
		end
	end

	return false
end

local function var_0_172(arg_89_0, arg_89_1, arg_89_2)
	local var_89_0

	if type(arg_89_0) == "string" then
		var_89_0 = {
			name = arg_89_0,
			type = arg_89_1,
			id = var_0_60(8)
		}
	elseif type(arg_89_0) == "table" then
		var_89_0 = arg_89_0
		var_89_0.type = arg_89_1
	else
		assert(false)
	end

	setmetatable(var_89_0, var_0_112)

	local var_89_1 = var_0_64(var_0_93.sources, function(arg_90_0, arg_90_1)
		return arg_90_1.id, true
	end)

	while var_89_1[var_89_0.id] do
		var_89_0.id = var_0_60(8)
	end

	table.insert(var_0_93.sources, var_89_0)
	var_0_115(var_0_114())

	return var_89_0
end

local function var_0_173(arg_91_0, arg_91_1)
	if arg_91_1 == "Creation date" then
		return arg_91_0
	elseif arg_91_1 == "Type" or arg_91_1 == "Alphabetically" then
		local var_91_0 = {}

		for iter_91_0 = 1, #arg_91_0 do
			table.insert(var_91_0, arg_91_0[iter_91_0])
		end

		table.sort(var_91_0, function(arg_92_0, arg_92_1)
			if arg_91_1 == "Type" then
				return arg_92_0:get_type_string() < arg_92_1:get_type_string()
			elseif arg_91_1 == "Alphabetically" then
				return arg_92_0.name < arg_92_1.name
			else
				return true
			end
		end)

		return var_91_0
	else
		return arg_91_0
	end
end

function var_0_99()
	local var_93_0 = {}

	for iter_93_0, iter_93_1 in pairs(var_0_144) do
		if iter_93_0 ~= "title" then
			var_93_0[iter_93_1] = false
		end
	end

	var_0_153 = true

	for iter_93_2, iter_93_3 in pairs(var_0_150) do
		var_93_0[iter_93_3] = false
	end

	if ui.get(var_0_136) and ui.get(var_0_144.title) then
		if var_0_164 and var_0_165 ~= nil then
			local var_93_1 = var_0_92()
			local var_93_2 = ui.get(var_0_150.show_all)

			if var_93_1 == nil then
				var_93_2 = true
			end

			var_93_0[var_0_144.source_label1] = true
			var_93_0[var_0_144.source_label2] = true

			ui.set(var_0_144.source_label1, string.format("Editing %s source: %s", (var_0_9[var_0_165.type] or var_0_165.type):lower(), var_0_165.name))
			ui.set(var_0_144.source_label2, var_93_2 and "Locations on all maps: " or string.format("Locations on %s:", var_93_1))

			var_93_0[var_0_144.import] = true
			var_93_0[var_0_144.export] = true
			var_93_0[var_0_144.back] = true
			var_93_0[var_0_150.list] = true
			var_93_0[var_0_150.show_all] = true
			var_93_0[var_0_150.sort_by] = true

			local var_93_3 = {}
			local var_93_4 = {}
			local var_93_5

			var_0_6(var_0_151)

			local var_93_6 = ui.get(var_0_150.sort_by)

			if var_93_2 then
				local var_93_7 = var_0_165:get_all_locations()
				local var_93_8 = 1

				for iter_93_4, iter_93_5 in pairs(var_93_7) do
					iter_93_5 = var_0_173(iter_93_5, var_93_6)

					for iter_93_6 = 1, #iter_93_5 do
						local var_93_9 = iter_93_5[iter_93_6]

						var_0_151[var_93_8] = var_93_9

						local var_93_10 = var_93_9:get_type_string()

						var_93_3[var_93_8] = string.format("[%s] %s: %s", iter_93_4, var_93_10, var_93_9.name)
						var_93_4[var_93_8] = iter_93_4
						var_93_8 = var_93_8 + 1
					end
				end
			else
				local var_93_11 = var_0_165:get_locations(var_93_1)
				local var_93_12 = var_0_173(var_93_11, var_93_6)

				for iter_93_7 = 1, #var_93_12 do
					local var_93_13 = var_93_12[iter_93_7]

					var_0_151[iter_93_7] = var_93_13

					local var_93_14 = var_93_13:get_type_string()

					var_93_3[iter_93_7] = string.format("%s: %s", var_93_14, var_93_13.full_name)
					var_93_4[iter_93_7] = var_93_1
				end
			end

			table.insert(var_93_3, "＋  Create new")
			table.insert(var_0_151, "create_new")
			ui.update(var_0_150.list, var_93_3)

			if var_0_154 == nil then
				var_0_154 = "create_new"

				var_0_100(true)
			end

			if var_0_154 == "create_new" then
				var_0_153 = false
			end

			for iter_93_8 = 1, #var_0_151 do
				if var_0_151[iter_93_8] == var_0_154 then
					ui.set(var_0_150.list, iter_93_8 - 1)

					if var_93_4[iter_93_8] == var_93_1 and var_93_1 ~= nil then
						var_0_153 = false
					end
				end
			end

			local var_93_15 = ui.get(var_0_150.type)

			var_93_0[var_0_150.type_label] = true
			var_93_0[var_0_150.type] = true
			var_93_0[var_0_150.from_label] = true
			var_93_0[var_0_150.from] = true
			var_93_0[var_0_150.to_label] = true
			var_93_0[var_0_150.to] = true
			var_93_0[var_0_150.description_label] = true
			var_93_0[var_0_150.description] = true
			var_93_0[var_0_150.grenade_properties] = true
			var_93_0[var_93_15 == "Movement" and var_0_150.record_label or var_0_150.set] = true
			var_93_0[var_0_150.set_hotkey] = true
			var_93_0[var_0_150.teleport] = true
			var_93_0[var_0_150.teleport_hotkey] = true
			var_93_0[var_0_150.export] = true
			var_93_0[var_0_150.save] = true

			if var_93_15 == "Grenade" then
				local var_93_16 = var_0_64(ui.get(var_0_150.grenade_properties), function(arg_94_0, arg_94_1)
					return arg_94_1, true
				end)

				if var_93_16.Run then
					var_93_0[var_0_150.run_direction] = true
					var_93_0[var_0_150.run_duration] = true

					if ui.get(var_0_150.run_direction) == "Custom" then
						var_93_0[var_0_150.run_direction_custom] = true
					end
				end

				if var_93_16.Jump or var_93_16["Force-enable recovery"] then
					var_93_0[var_0_150.recovery_direction] = true
					var_93_0[var_0_150.recovery_jump] = true

					if ui.get(var_0_150.recovery_direction) == "Custom" then
						var_93_0[var_0_150.recovery_direction_custom] = true
					end
				end

				if var_93_16["Delayed throw"] then
					var_93_0[var_0_150.delay] = true
				end

				if var_93_16["Throw strength"] then
					var_93_0[var_0_150.throw_strength] = true
				end
			end

			if var_0_154 ~= nil and var_0_154 ~= "create_new" then
				var_93_0[var_0_150.delete] = true
				var_93_0[var_0_150.delete_hotkey] = true
			end
		else
			local var_93_17 = var_0_114()
			local var_93_18 = {}
			local var_93_19

			var_0_6(var_0_162)

			for iter_93_9 = 1, #var_0_93.sources do
				local var_93_20 = var_0_93.sources[iter_93_9]

				var_0_162[iter_93_9] = var_93_20

				table.insert(var_93_18, string.format("%s  %s: %s", var_93_17.enabled[var_93_20.id] and "☑" or "☐", var_0_9[var_93_20.type] or var_93_20.type, var_93_20.name))

				if var_93_20 == var_0_165 then
					var_93_19 = iter_93_9
				end
			end

			table.insert(var_93_18, "＋  Add remote source")
			table.insert(var_0_162, "add_remote")

			if var_0_165 == "add_remote" then
				var_93_19 = #var_0_162
			end

			table.insert(var_93_18, "＋  Create local")
			table.insert(var_0_162, "add_local")

			if var_0_165 == "add_local" then
				var_93_19 = #var_0_162
			end

			if var_93_19 == nil then
				var_0_165 = var_0_162[1]
				var_93_19 = 1
			end

			ui.update(var_0_144.list, var_93_18)

			if var_93_19 ~= nil then
				ui.set(var_0_144.list, var_93_19 - 1)
			end

			var_93_0[var_0_144.list] = true

			if var_0_165 ~= nil then
				var_93_0[var_0_144.source_label1] = true

				if var_0_165 == "add_remote" then
					ui.set(var_0_144.source_label1, "Add new remote source")

					var_93_0[var_0_144.import] = true

					if var_0_166 ~= nil then
						ui.set(var_0_144.source_label4, var_0_166)

						var_93_0[var_0_144.source_label4] = true
					end
				elseif var_0_165 == "add_local" then
					ui.set(var_0_144.source_label1, "New source name:")

					var_93_0[var_0_144.name] = true
					var_93_0[var_0_144.create] = true
				elseif var_0_165 ~= nil then
					var_93_0[var_0_144.enabled] = true
					var_93_0[var_0_144.edit] = var_0_165.type == "local" and not var_0_165.builtin
					var_93_0[var_0_144.update] = var_0_165.type == "remote"
					var_93_0[var_0_144.delete] = not var_0_165.builtin
					var_0_163 = true

					ui.set(var_0_144.source_label1, string.format("%s source: %s", var_0_9[var_0_165.type] or var_0_165.type, var_0_165.name))

					if var_0_165.description ~= nil then
						var_93_0[var_0_144.source_label2] = true

						ui.set(var_0_144.source_label2, string.format("%s", var_0_165.description))
					end

					if var_0_165.remote_status ~= nil then
						var_93_0[var_0_144.source_label3] = true

						ui.set(var_0_144.source_label3, var_0_165.remote_status)
					elseif var_0_165.update_timestamp ~= nil then
						var_93_0[var_0_144.source_label3] = true

						ui.set(var_0_144.source_label3, string.format("Last updated: %s", var_0_78(var_0_165.update_timestamp, false, false, 1)))
					end

					ui.set(var_0_144.enabled, var_93_17.enabled[var_0_165.id] == true)

					var_0_163 = false
				end
			end
		end
	end

	for iter_93_10, iter_93_11 in pairs(var_93_0) do
		ui.set_visible(iter_93_10, iter_93_11)
	end
end

ui.set_callback(var_0_144.title, function()
	if not ui.get(var_0_144.title) then
		var_0_164 = false
	end

	var_0_99()
end)
ui.set_callback(var_0_144.list, function()
	local var_96_0 = var_0_165
	local var_96_1 = ui.get(var_0_144.list)

	if var_96_1 ~= nil then
		var_0_165 = var_0_162[var_96_1 + 1]

		if var_0_165 ~= var_96_0 then
			var_0_164 = false
			var_0_166 = nil

			var_0_99()
		end
	end
end)
ui.set_callback(var_0_144.enabled, function()
	if type(var_0_165) == "table" and not var_0_163 then
		local var_97_0 = var_0_114()

		var_97_0.enabled[var_0_165.id] = ui.get(var_0_144.enabled)

		var_0_115(var_97_0)
		var_0_99()
		var_0_103("D")
	end
end)
ui.set_callback(var_0_139, var_0_103)
ui.set_callback(var_0_150.show_all, function()
	var_0_99()
end)
ui.set_callback(var_0_150.sort_by, function()
	var_0_99()
end)

local var_0_174 = {
	function(arg_100_0)
		local var_100_0 = arg_100_0:match("^https://pastebin.com/(%w+)/?$")

		if var_100_0 ~= nil then
			return string.format("https://pastebin.com/raw/%s", var_100_0)
		end
	end,
	function(arg_101_0)
		local var_101_0, var_101_1, var_101_2, var_101_3 = arg_101_0:match("^https://github.com/(%w+)/(%w+)/blob/(%w+)/(.+)$")

		if var_101_0 ~= nil then
			return string.format("https://github.com/%s/%s/raw/%s/%s", var_101_0, var_101_1, var_101_2, var_101_3)
		end
	end
}

function var_0_158()
	if type(var_0_165) == "table" and not var_0_165.builtin then
		for iter_102_0 = 1, #var_0_93.sources do
			if var_0_93.sources[iter_102_0] == var_0_165 then
				table.remove(var_0_93.sources, iter_102_0)

				break
			end
		end

		var_0_115(var_0_114())
		var_0_103("source deleted")
		var_0_171()
	end
end

function var_0_157()
	if type(var_0_165) == "table" and var_0_165.type == "remote" then
		var_0_165:update_remote_data()
		var_0_99()
	end
end

function var_0_159()
	if var_0_165 == "add_local" then
		local var_104_0 = ui.get(var_0_144.name)

		if var_104_0:gsub(" ", "") == "" then
			return
		end

		local var_104_1 = var_0_64(var_0_93.sources, function(arg_105_0, arg_105_1)
			return arg_105_1.name, arg_105_1.type == "local"
		end)
		local var_104_2 = var_104_0
		local var_104_3 = 2

		while var_104_1[var_104_2] do
			var_104_2 = string.format("%s (%d)", var_104_0, var_104_3)
			var_104_3 = var_104_3 + 1
		end

		local var_104_4 = var_104_2
		local var_104_5 = var_0_172(var_104_4, "local")

		var_0_99()
		var_0_171(var_104_5)
		ui.set(var_0_144.name, "")
	end
end

local function var_0_175(arg_106_0, arg_106_1)
	local var_106_0 = {}

	for iter_106_0 = 1, #arg_106_0 do
		local var_106_1 = var_0_106(arg_106_0[iter_106_0])

		if type(var_106_1) ~= "table" then
			local var_106_2 = string.format("invalid location #%d: %s", iter_106_0, var_106_1)

			client.error_log("Failed to import " .. tostring(arg_106_1) .. ", " .. var_106_2)

			var_0_166 = var_106_2

			var_0_99()

			return
		end

		var_106_0[iter_106_0] = var_106_1
	end

	if #var_106_0 == 0 then
		client.error_log("Failed to import: No locations to import")

		var_0_166 = "No locations to import"

		var_0_99()

		return
	end

	local var_106_3 = var_0_165:get_locations(arg_106_1)

	if var_106_3 == nil then
		var_106_3 = {}
		var_0_98[var_0_165][arg_106_1] = var_106_3
	end

	for iter_106_1 = 1, #var_106_0 do
		table.insert(var_106_3, var_106_0[iter_106_1])
	end

	var_0_99()
	var_0_165:store_write()
	var_0_103()
end

function var_0_160()
	if var_0_164 and type(var_0_165) == "table" and var_0_165.type == "local" and var_0_79 then
		local var_107_0 = var_0_79()

		if var_107_0 == nil then
			local var_107_1 = "No text copied to clipboard"

			client.error_log("Failed to import: " .. var_107_1)

			var_0_166 = var_107_1

			var_0_99()

			return
		end

		if var_0_73(var_107_0):gsub(" ", ""):match("^https?://.+$") then
			client.error_log("Trying to import a URL as JSON")

			var_0_166 = "Trying to import a URL as JSON"

			var_0_99()

			return
		end

		local var_107_2, var_107_3 = pcall(json.parse, var_107_0)

		if var_107_2 and var_107_0:sub(1, 1) ~= "[" and var_107_0:sub(1, 1) ~= "{" then
			var_107_2, var_107_3 = false, "Expected object or array"
		end

		if not var_107_2 then
			local var_107_4 = string.format("Invalid JSON: %s", var_107_3)

			client.error_log("Failed to import: " .. var_107_4)

			var_0_166 = var_107_4

			var_0_99()

			return
		end

		local var_107_5 = var_107_0:sub(1, 1) == "["

		if not var_107_5 and (var_107_3.name ~= nil or var_107_3.grenade ~= nil or var_107_3.location ~= nil) then
			var_107_3 = {
				var_107_3
			}
			var_107_5 = true
		end

		if var_107_5 then
			local var_107_6 = var_0_92()

			if var_107_6 == nil then
				client.error_log("Failed to import: You need to be in-game")

				var_0_166 = "You need to be in-game"

				var_0_99()

				return
			end

			var_0_175(var_107_3, var_107_6)
		else
			for iter_107_0, iter_107_1 in pairs(var_107_3) do
				if type(iter_107_0) ~= "string" or iter_107_0:find(" ") then
					client.error_log("Failed to import: Invalid map name")

					var_0_166 = "Invalid map name"

					var_0_99()

					return
				end
			end

			for iter_107_2, iter_107_3 in pairs(var_107_3) do
				var_0_175(iter_107_3, iter_107_2)
			end
		end
	elseif var_0_165 == "add_remote" and var_0_79 then
		local var_107_7 = var_0_79()

		if var_107_7 == nil then
			client.error_log("Failed to import: Clipboard is empty")

			var_0_166 = "Clipboard is empty"

			var_0_99()

			return
		end

		local var_107_8 = var_0_73(var_107_7):gsub(" ", "")

		if not var_107_8:match("^https?://.+$") then
			client.error_log("Failed to import: Invalid URL")

			var_0_166 = "Invalid URL"

			var_0_99()

			return
		end

		for iter_107_4 = 1, #var_0_174 do
			var_107_8 = var_0_174[iter_107_4](var_107_8) or var_107_8
		end

		for iter_107_5 = 1, #var_0_93.sources do
			local var_107_9 = var_0_93.sources[iter_107_5]

			if var_107_9.type == "remote" and var_107_9.url == var_107_8 then
				client.error_log("Failed to import: A source with that URL already exists")

				var_0_166 = "A source with that URL already exists"

				var_0_99()

				return
			end
		end

		var_0_166 = "Loading index data..."

		var_0_99()
		var_0_111(var_107_8, function(arg_108_0, arg_108_1)
			if var_0_165 ~= "add_remote" then
				return
			end

			if arg_108_0 ~= nil then
				client.error_log(string.format("Failed to import: %s", arg_108_0))

				var_0_166 = arg_108_0

				var_0_99()

				return
			end

			local var_108_0 = var_0_172(arg_108_1.name, "remote")

			var_108_0.url = arg_108_1.url or var_107_8
			var_108_0.url_format = arg_108_1.url_format
			var_108_0.description = arg_108_1.description
			var_108_0.update_timestamp = arg_108_1.update_timestamp
			var_108_0.last_updated = arg_108_1.last_updated
			var_0_166 = string.format("Successfully imported %s", var_108_0.name)

			var_0_99()

			var_0_165 = nil

			var_0_171("add_remote")
			var_0_99()
		end)
	end
end

function var_0_161()
	if var_0_164 and type(var_0_165) == "table" and var_0_165.type == "local" then
		local var_109_0 = "  "
		local var_109_1 = var_0_92()
		local var_109_2 = ui.get(var_0_150.show_all)

		if var_109_1 == nil then
			var_109_2 = true
		end

		local var_109_3

		if var_109_2 then
			local var_109_4 = var_0_165:get_all_locations()
			local var_109_5 = {}

			for iter_109_0, iter_109_1 in pairs(var_109_4) do
				table.insert(var_109_5, iter_109_0)
			end

			table.sort(var_109_5)

			local var_109_6 = {}

			for iter_109_2 = 1, #var_109_5 do
				local var_109_7 = var_109_5[iter_109_2]
				local var_109_8 = var_109_4[var_109_7]
				local var_109_9 = {}

				for iter_109_3 = 1, #var_109_8 do
					local var_109_10 = var_109_8[iter_109_3]:get_export(true)

					table.insert(var_109_9, var_109_0 .. var_109_10:gsub("\n", "\n" .. var_109_0 .. var_109_0))
				end

				table.insert(var_109_6, json.stringify(var_109_7) .. ": [\n" .. var_109_0 .. table.concat(var_109_9, ",\n" .. var_109_0) .. "\n" .. var_109_0 .. "]")
			end

			var_109_3 = "{\n" .. var_109_0 .. table.concat(var_109_6, ",\n" .. var_109_0) .. "\n}"
		else
			local var_109_11 = var_0_165:get_locations(var_109_1)
			local var_109_12 = {}

			for iter_109_4 = 1, #var_109_11 do
				var_109_12[iter_109_4] = var_109_11[iter_109_4]:get_export(true):gsub("\n", "\n" .. var_109_0)
			end

			var_109_3 = "[\n" .. var_109_0 .. table.concat(var_109_12, ",\n" .. var_109_0) .. "\n]"
		end

		if var_109_3 ~= nil then
			if var_0_80 ~= nil then
				var_0_80(var_109_3)
				client.log("Exported location (Copied to clipboard):")
			else
				client.log("Exported location:")
			end

			var_0_3.print_highlighted(var_109_3)
		end
	end
end

local function var_0_176()
	if var_0_154 ~= nil then
		var_0_169[var_0_154] = nil
	end

	if var_0_164 and var_0_154 ~= nil and var_0_167[var_0_154] ~= nil then
		if type(var_0_154) == "table" then
			local var_110_0 = var_0_154:get_export_tbl()

			var_0_168[var_0_154] = not var_0_55(var_110_0, var_0_167[var_0_154])
		else
			var_0_168[var_0_154] = true
		end

		local var_110_1 = var_0_106(var_0_167[var_0_154])

		if type(var_110_1) == "string" then
			var_0_169[var_0_154] = var_110_1
		end
	end

	return var_0_168[var_0_154] == true
end

function var_0_100(arg_111_0)
	local var_111_0 = {}

	if var_0_164 and var_0_154 ~= nil and var_0_167[var_0_154] ~= nil then
		var_111_0 = var_0_167[var_0_154]
	end

	if var_0_153 and not arg_111_0 then
		var_111_0 = {}
	end

	local var_111_1 = var_0_64(var_0_11, function(arg_112_0, arg_112_1)
		return arg_112_1, arg_112_0
	end)

	var_0_152 = true

	ui.set(var_0_150.from, var_111_0.name and var_111_0.name[1] or "")
	ui.set(var_0_150.to, var_111_0.name and var_111_0.name[2] or "")
	ui.set(var_0_150.grenade_properties, {})
	ui.set(var_0_150.description, var_111_0.description or "")

	if var_0_153 then
		ui.set(var_0_150.type_label, "Can't edit location on a different map")
	else
		ui.set(var_0_150.type_label, var_0_154 == "create_new" and "Creating new location" or string.format("Editing %s to %s", var_111_0.name and var_111_0.name[1] or "Unnamed", var_111_0.name and var_111_0.name[2] or "Unnamed"))
	end

	local var_111_2 = var_0_106(var_111_0)

	if type(var_111_2) ~= "table" then
		var_111_2 = nil
	end

	if var_111_2 ~= nil then
		ui.set(var_0_150.type, var_0_10[var_111_2.type])
	end

	if var_111_0.grenade ~= nil then
		ui.set(var_0_150.recovery_direction, var_111_1[180])
		ui.set(var_0_150.recovery_direction_custom, 0)
		ui.set(var_0_150.recovery_jump, false)
		ui.set(var_0_150.run_duration, 20)
		ui.set(var_0_150.run_direction, var_111_1[0])
		ui.set(var_0_150.run_direction_custom, 0)
		ui.set(var_0_150.delay, 1)

		local var_111_3 = {}

		if var_111_0.grenade.jump then
			table.insert(var_111_3, "Jump")
		end

		if var_111_0.grenade.recovery_yaw ~= nil then
			if not var_111_0.grenade.jump then
				table.insert(var_111_3, "Force-enable recovery")
			end

			if var_111_1[var_111_0.grenade.recovery_yaw] ~= nil then
				ui.set(var_0_150.recovery_direction, var_111_1[var_111_0.grenade.recovery_yaw])
			else
				ui.set(var_0_150.recovery_direction, "Custom")
				ui.set(var_0_150.recovery_direction_custom, var_111_0.grenade.recovery_yaw)
			end
		end

		if var_111_0.grenade.recovery_jump then
			ui.set(var_0_150.recovery_jump, true)
		end

		if var_111_0.grenade.strength ~= nil and var_111_0.grenade.strength ~= 1 then
			table.insert(var_111_3, "Throw strength")
			ui.set(var_0_150.throw_strength, var_111_0.grenade.strength == 0.5 and "Left / Right Click" or "Left Click")
		end

		if var_111_0.grenade.delay ~= nil then
			table.insert(var_111_3, "Delayed throw")
			ui.set(var_0_150.delay, var_111_0.grenade.delay)
		end

		if var_111_0.grenade.run ~= nil then
			table.insert(var_111_3, "Run")

			if var_111_0.grenade.run ~= 20 then
				ui.set(var_0_150.run_duration, var_111_0.grenade.run)
			end

			if var_111_0.grenade.run_yaw ~= nil then
				if var_111_1[var_111_0.grenade.run_yaw] ~= nil then
					ui.set(var_0_150.run_direction, var_111_1[var_111_0.grenade.run_yaw])
				else
					ui.set(var_0_150.run_direction, "Custom")
					ui.set(var_0_150.run_direction_custom, var_111_0.grenade.run_yaw)
				end
			end

			if var_111_0.grenade.run_speed then
				table.insert(var_111_3, "Walk (Shift)")
			end
		end

		ui.set(var_0_150.grenade_properties, var_111_3)
	elseif var_111_0.movement ~= nil then
		-- block empty
	else
		ui.set(var_0_150.grenade_properties, {})
	end

	var_0_152 = false
end

local function var_0_177()
	if var_0_152 or var_0_153 then
		return
	end

	if not var_0_164 or var_0_167[var_0_154] ~= nil or var_0_154 == "create_new" then
		-- block empty
	elseif var_0_154 ~= nil then
		var_0_167[var_0_154] = var_0_154:get_export_tbl()

		var_0_100()
	end

	if var_0_164 and var_0_154 ~= nil and var_0_167[var_0_154] ~= nil then
		local var_113_0 = var_0_167[var_0_154]
		local var_113_1 = ui.get(var_0_150.from):gsub("%s+$", "")

		if var_113_1 == "" then
			var_113_1 = "Unnamed"
		end

		local var_113_2 = ui.get(var_0_150.to):gsub("%s+$", "")

		if var_113_2 == "" then
			var_113_2 = "Unnamed"
		end

		var_113_0.name = {
			var_113_1,
			var_113_2
		}

		local var_113_3 = ui.get(var_0_150.description):gsub("^%s+", ""):gsub("%s+$", "")

		if var_113_3 ~= "" then
			var_113_0.description = var_113_3
		else
			var_113_0.description = nil
		end

		var_113_0.grenade = var_113_0.grenade or {}

		local var_113_4 = var_0_64(ui.get(var_0_150.grenade_properties), function(arg_114_0, arg_114_1)
			return arg_114_1, true
		end)

		if var_113_4.Jump then
			var_113_0.grenade.jump = true
		else
			var_113_0.grenade.jump = nil
		end

		if var_113_4.Jump or var_113_4["Force-enable recovery"] then
			local var_113_5
			local var_113_6 = ui.get(var_0_150.recovery_direction)

			if var_113_6 == "Custom" then
				var_113_5 = ui.get(var_0_150.recovery_direction_custom)

				if var_113_5 == -180 then
					var_113_5 = 180
				end
			else
				var_113_5 = var_0_11[var_113_6]
			end

			var_113_0.grenade.recovery_yaw = var_113_5 ~= nil and var_113_5 ~= 180 and var_113_5 or not var_113_4.Jump and 180 or nil
			var_113_0.grenade.recovery_jump = ui.get(var_0_150.recovery_jump) and true or nil
		else
			var_113_0.grenade.recovery_yaw = nil
			var_113_0.grenade.recovery_jump = nil
		end

		if var_113_4.Run then
			var_113_0.grenade.run = ui.get(var_0_150.run_duration)

			local var_113_7
			local var_113_8 = ui.get(var_0_150.run_direction)

			if var_113_8 == "Custom" then
				var_113_7 = ui.get(var_0_150.run_direction_custom)
			else
				var_113_7 = var_0_11[var_113_8]
			end

			var_113_0.grenade.run_yaw = var_113_7 ~= nil and var_113_7 ~= 0 and var_113_7 or nil

			if var_113_4["Walk (Shift)"] then
				var_113_0.grenade.run_speed = true
			else
				var_113_0.grenade.run_speed = nil
			end
		else
			var_113_0.grenade.run = nil
			var_113_0.grenade.run_yaw = nil
			var_113_0.grenade.run_speed = nil
		end

		if var_113_4["Delayed throw"] then
			var_113_0.grenade.delay = ui.get(var_0_150.delay)
		else
			var_113_0.grenade.delay = nil
		end

		if var_113_4["Throw strength"] then
			local var_113_9 = ui.get(var_0_150.throw_strength)

			if var_113_9 == "Left / Right Click" then
				var_113_0.grenade.strength = 0.5
			elseif var_113_9 == "Right Click" then
				var_113_0.grenade.strength = 0
			else
				var_113_0.grenade.strength = nil
			end
		else
			var_113_0.grenade.strength = nil
		end

		if var_113_0.grenade ~= nil and next(var_113_0.grenade) == nil then
			var_113_0.grenade = nil
		end

		var_0_176()
		var_0_103("edit_update_has_changed")
	end

	var_0_99()
end

ui.set_callback(var_0_150.grenade_properties, var_0_177)
ui.set_callback(var_0_150.run_direction, var_0_177)
ui.set_callback(var_0_150.run_direction_custom, var_0_177)
ui.set_callback(var_0_150.run_duration, var_0_177)
ui.set_callback(var_0_150.recovery_direction, var_0_177)
ui.set_callback(var_0_150.recovery_direction_custom, var_0_177)
ui.set_callback(var_0_150.recovery_jump, var_0_177)
ui.set_callback(var_0_150.delay, var_0_177)
ui.set_callback(var_0_150.throw_strength, var_0_177)
client.delay_call(0, var_0_99)

function var_0_155()
	if type(var_0_165) == "table" and var_0_165.type == "local" and not var_0_165.builtin then
		var_0_164 = true

		var_0_99()
		var_0_103("on_source_edit")
	end
end

function var_0_156()
	var_0_164 = false
	var_0_154 = nil

	var_0_6(var_0_167)
	var_0_6(var_0_168)
	var_0_6(var_0_169)
	var_0_103("on_source_edit_back")
	var_0_99()
end

function var_0_147()
	if not var_0_153 and var_0_154 ~= nil and (var_0_154 == "create_new" or var_0_167[var_0_154] ~= nil) then
		if client.get_cvar("sv_cheats") == 0 then
			return
		end

		local var_117_0 = var_0_167[var_0_154]

		if var_117_0 ~= nil then
			local var_117_1 = entity.get_local_player()

			if var_117_0.weapon ~= nil and var_117_1 ~= nil and entity.is_alive(var_117_1) then
				for iter_117_0 = 0, 64 do
					local var_117_2 = var_0_1(entity.get_prop(var_117_1, "m_hMyWeapons", iter_117_0))

					if var_117_2 ~= nil and (var_0_18[var_117_2] ~= nil and var_0_18[var_117_2].console_name or var_117_2.console_name) == var_117_0.weapon then
						client.exec("use ", var_117_2.console_name)
					end
				end
			end

			if var_117_0.position ~= nil then
				client.exec(string.format("setpos_exact %f %f %f", unpack(var_117_0.position)))
				client.delay_call(0.1, function()
					if entity.get_prop(entity.get_local_player(), "m_MoveType") == 8 then
						local var_118_0, var_118_1, var_118_2 = unpack(var_117_0.position)

						client.exec(string.format("noclip off; setpos_exact %f %f %f", var_118_0, var_118_1, var_118_2 + 64))
					end
				end)
			end

			if var_117_0.viewangles ~= nil then
				client.camera_angles(unpack(var_117_0.viewangles))
			end
		end
	end
end

function var_0_148()
	if not var_0_153 and var_0_154 ~= nil then
		if var_0_167[var_0_154] == nil then
			var_0_167[var_0_154] = {}

			var_0_177()
		end

		local var_119_0 = var_0_167[var_0_154]

		var_119_0.duck = nil
		var_119_0.position = nil
		var_119_0.viewangles = nil
		var_119_0.weapon = nil

		local var_119_1 = entity.get_local_player()

		if bit.band(entity.get_prop(var_119_1, "m_fFlags"), var_0_37) == var_0_37 or entity.get_prop(var_119_1, "m_MoveType") == var_0_38 then
			local var_119_2 = entity.get_player_weapon(var_119_1)
			local var_119_3 = var_0_1[entity.get_prop(var_119_2, "m_iItemDefinitionIndex")]

			var_119_3 = var_0_18[var_119_3] or var_119_3
			var_119_0.position = {
				entity.get_prop(var_119_1, "m_vecAbsOrigin")
			}

			local var_119_4, var_119_5 = client.camera_angles()

			var_119_0.viewangles = {
				var_119_4,
				var_119_5
			}

			if entity.get_prop(var_119_1, "m_flDuckAmount") ~= 0 then
				var_119_0.duck = entity.get_prop(var_119_1, "m_flDuckAmount") == 1
			end

			var_119_0.weapon = var_119_3.console_name
		end

		var_0_176()
		var_0_103("edit_update_has_changed")
	end
end

function var_0_145()
	if not var_0_153 and var_0_154 ~= nil and var_0_167[var_0_154] ~= nil then
		local var_120_0 = var_0_106(var_0_167[var_0_154])

		if type(var_120_0) ~= "table" then
			client.error_log("failed to save: " .. var_120_0)

			return
		end

		local var_120_1 = var_0_92()

		if var_120_1 == nil then
			return
		end

		local var_120_2 = var_0_98[var_0_165][var_120_1]

		if var_120_2 == nil then
			var_120_2 = {}
			var_0_98[var_0_165][var_120_1] = var_120_2
		end

		if var_0_154 == "create_new" then
			table.insert(var_120_2, var_120_0)
			var_0_165:store_write()
			var_0_103()

			var_0_154 = var_120_0
			var_0_167[var_0_154] = var_0_167.create_new
			var_0_167.create_new = nil
		elseif type(var_0_154) == "table" then
			for iter_120_0 = 1, #var_120_2 do
				if var_120_2[iter_120_0] == var_0_154 then
					var_0_167[var_120_0] = var_0_167[var_120_2[iter_120_0]]
					var_0_167[var_120_2[iter_120_0]] = nil
					var_0_154 = var_120_0
					var_120_2[iter_120_0] = var_120_0

					var_0_165:store_write()
					var_0_103()

					break
				end
			end
		end

		database.flush()
		var_0_100()
		var_0_99()
		var_0_103()
	end
end

function var_0_149()
	if type(var_0_154) == "table" or var_0_167[var_0_154] ~= nil then
		local var_121_0 = var_0_106(var_0_167[var_0_154]) or var_0_154

		if type(var_121_0) == "table" then
			local var_121_1 = var_121_0:get_export(true)

			if var_0_80 ~= nil then
				var_0_80(var_121_1)
				client.log("Exported location (Copied to clipboard):")
			else
				client.log("Exported location:")
			end

			var_0_3.print_highlighted(var_121_1)
		else
			client.error_log(var_121_0)
		end
	end
end

function var_0_146()
	if not var_0_153 and var_0_154 ~= nil and type(var_0_154) == "table" then
		local var_122_0 = var_0_92()

		if var_122_0 == nil then
			return
		end

		local var_122_1 = var_0_98[var_0_165][var_122_0]

		for iter_122_0 = 1, #var_122_1 do
			if var_122_1[iter_122_0] == var_0_154 then
				table.remove(var_122_1, iter_122_0)

				var_0_167[var_0_154] = nil
				var_0_154 = nil

				var_0_99()
				var_0_165:store_write()
				database.flush()
				var_0_103()

				break
			end
		end
	end
end

ui.set_callback(var_0_150.list, function()
	local var_123_0 = var_0_154
	local var_123_1 = ui.get(var_0_150.list)

	if var_123_1 ~= nil then
		var_0_154 = var_0_151[var_123_1 + 1]
	else
		var_0_154 = "create_new"
	end

	var_0_99()

	if var_0_154 ~= var_123_0 and not var_0_153 then
		if type(var_0_154) == "table" and var_0_167[var_0_154] == nil then
			var_0_167[var_0_154] = var_0_154:get_export_tbl()
		end

		var_0_100()
		var_0_99()
		var_0_103()
	elseif var_0_154 ~= var_123_0 then
		var_0_100()
	end
end)

local var_0_178 = var_0_7().dist
local var_0_179 = var_0_7().distsqr

var_0_99()
client.delay_call(0, var_0_99)

local var_0_180 = 0
local var_0_181
local var_0_182
local var_0_183
local var_0_184
local var_0_185
local var_0_186 = var_0_4.get_panorama_image("icons/ui/edit.svg")
local var_0_187 = var_0_4.get_panorama_image("icons/ui/warning.svg")

local function var_0_188()
	local var_124_0 = {
		teleport_hotkey = var_0_147,
		delete_hotkey = var_0_146
	}

	if ui.get(var_0_150.type) == "Movement" and (not ui.get(var_0_150.set_hotkey) or true) then
		-- block empty
	else
		var_124_0.set_hotkey = var_0_148
	end

	for iter_124_0, iter_124_1 in pairs(var_124_0) do
		local var_124_1 = ui.get(var_0_150[iter_124_0])

		if var_0_170[iter_124_0] == nil then
			var_0_170[iter_124_0] = var_124_1
		end

		if var_124_1 and not var_0_170[iter_124_0] then
			iter_124_1()
		end

		var_0_170[iter_124_0] = var_124_1
	end

	local var_124_2 = var_0_167[var_0_154]

	if var_124_2 ~= nil then
		local var_124_3 = ui.get(var_0_150.from):gsub("%s+$", "")

		if var_124_3 == "" then
			var_124_3 = "Unnamed"
		end

		local var_124_4 = ui.get(var_0_150.to):gsub("%s+$", "")

		if var_124_4 == "" then
			var_124_4 = "Unnamed"
		end

		if var_124_3 ~= var_124_2.name[1] or var_124_4 ~= var_124_2.name[2] then
			var_0_177()
		end

		local var_124_5 = ui.get(var_0_150.description):gsub("^%s+", ""):gsub("%s+$", "")

		if var_124_5 == "" then
			var_124_5 = nil
		end

		if var_124_2.description ~= var_124_5 then
			var_0_177()
		end

		local var_124_6 = type(var_0_154) == "table" and var_0_154:get_export_tbl() or {}
		local var_124_7 = var_0_54(var_124_6, true)
		local var_124_8 = var_0_168[var_0_154]
		local var_124_9 = var_0_54(var_124_2, true)
		local var_124_10 = {}

		for iter_124_2, iter_124_3 in pairs(var_124_9) do
			local var_124_11 = false
			local var_124_12 = json.stringify(iter_124_3)

			if var_124_8 then
				var_124_11 = var_124_12 ~= json.stringify(var_124_7[iter_124_2])
			end

			local var_124_13 = var_0_3.highlight(var_124_12, var_124_11 and {
				244,
				147,
				134
			} or {
				221,
				221,
				221
			}, var_124_11 and {
				223,
				57,
				35
			} or {
				218,
				230,
				30
			}, var_124_11 and {
				209,
				42,
				62
			} or {
				180,
				230,
				30
			}, var_124_11 and {
				209,
				42,
				62
			} or {
				96,
				160,
				220
			})
			local var_124_14 = ""

			for iter_124_4 = 1, #var_124_13 do
				local var_124_15, var_124_16, var_124_17, var_124_18 = unpack(var_124_13[iter_124_4])

				var_124_14 = var_124_14 .. string.format("\a%02X%02X%02XFF%s", var_124_15, var_124_16, var_124_17, var_124_18)
			end

			if var_124_14:len() > 400 then
				var_124_14 = var_124_14:sub(1, 400):gsub("\a" .. string.rep(".?", 8) .. "$", "") .. "\a9F9F9FFF..."
			end

			if iter_124_2 == "movement.frames" and type(iter_124_3) == "table" then
				local var_124_19 = 0

				for iter_124_5, iter_124_6 in ipairs(iter_124_3) do
					if type(iter_124_6) == "number" then
						var_124_19 = var_124_19 + iter_124_6
					elseif type(iter_124_6) == "table" then
						var_124_19 = var_124_19 + 1
					end
				end

				var_124_14 = var_124_14 .. string.format(" (%d cmds)", var_124_19)
			end

			table.insert(var_124_10, {
				iter_124_2,
				var_124_14,
				var_124_11
			})
		end

		local var_124_20 = {
			weapon = "\x03",
			description = "\x02",
			name = "\x01",
			position = "\x04",
			viewangles = "\x05"
		}

		table.sort(var_124_10, function(arg_125_0, arg_125_1)
			return (var_124_20[arg_125_1[1]] or arg_125_1[1]) > (var_124_20[arg_125_0[1]] or arg_125_0[1])
		end)

		local var_124_21 = {
			{
				{
					var_0_186,
					0,
					0,
					12,
					12
				},
				255,
				255,
				255,
				220,
				"b",
				0,
				" Editing Location:"
			}
		}

		for iter_124_7 = 1, #var_124_10 do
			local var_124_22, var_124_23, var_124_24 = unpack(var_124_10[iter_124_7])

			table.insert(var_124_21, {
				255,
				255,
				255,
				220,
				"",
				0,
				var_124_22,
				": ",
				var_124_24 and "\aF21A3EFF" or "\aFFFFFFDC",
				var_124_23
			})
		end

		local var_124_25 = #var_124_21

		if var_124_8 then
			table.insert(var_124_21, {
				{
					var_0_187,
					0,
					0,
					12,
					12,
					255,
					54,
					0,
					255
				},
				234,
				64,
				18,
				220,
				"",
				0,
				"You have unsaved changes! Make sure to click Save."
			})
		end

		if var_124_2.weapon ~= nil then
			local var_124_26 = var_0_1[var_124_2.weapon]

			if var_124_26.type == "grenade" then
				local var_124_27 = var_0_64(ui.get(var_0_139), function(arg_126_0, arg_126_1)
					return arg_126_1, true
				end)
				local var_124_28 = var_0_15[var_124_26]

				if not var_124_27[var_124_28] then
					table.insert(var_124_21, {
						{
							var_0_187,
							0,
							0,
							12,
							12,
							255,
							54,
							0,
							255
						},
						234,
						64,
						18,
						220,
						"",
						0,
						"Location not shown because type \"",
						tostring(var_124_28),
						"\" is not enabled."
					})
				end
			end
		end

		if var_0_169[var_124_2] ~= nil then
			table.insert(var_124_21, {
				{
					var_0_187,
					0,
					0,
					12,
					12,
					255,
					54,
					0,
					255
				},
				234,
				64,
				18,
				220,
				"",
				0,
				"Location not valid: ",
				tostring(var_0_169[var_124_2])
			})
		end

		local var_124_29 = var_0_114()

		if var_0_165 ~= nil and not var_124_29.enabled[var_0_165.id] then
			table.insert(var_124_21, {
				{
					var_0_187,
					0,
					0,
					12,
					12,
					255,
					54,
					0,
					255
				},
				234,
				64,
				18,
				220,
				"",
				0,
				"Location not shown because source \"",
				tostring(var_0_165.name),
				"\" is not enabled."
			})
		end

		if var_124_25 < #var_124_21 then
			table.insert(var_124_21, var_124_25 + 1, {
				255,
				255,
				255,
				0,
				"",
				0,
				" "
			})
		end

		local var_124_30 = 0
		local var_124_31 = 0
		local var_124_32 = {}

		for iter_124_8 = 1, #var_124_21 do
			local var_124_33 = var_124_21[iter_124_8]
			local var_124_34 = type(var_124_33[1]) == "table"
			local var_124_35, var_124_36 = renderer.measure_text(select(var_124_34 and 7 or 6, unpack(var_124_33)))

			if var_124_34 then
				var_124_35 = var_124_35 + var_124_33[1][4]
			end

			if var_124_30 < var_124_35 then
				var_124_30 = var_124_35
			end

			var_124_32[iter_124_8] = var_124_31
			var_124_31 = var_124_31 + var_124_36

			if iter_124_8 == 1 then
				var_124_31 = var_124_31 + 2
			end
		end

		local var_124_37, var_124_38 = client.screen_size()
		local var_124_39 = var_124_37 / 2 - math.floor(var_124_30 / 2)
		local var_124_40 = 140

		renderer.rectangle(var_124_39 - 4, var_124_40 - 3, var_124_30 + 8, var_124_31 + 6, 16, 16, 16, 105)
		var_0_56(var_124_39 - 5, var_124_40 - 4, var_124_30 + 10, var_124_31 + 8, 16, 16, 16, 118.99999999999999)
		var_0_56(var_124_39 - 6, var_124_40 - 5, var_124_30 + 12, var_124_31 + 10, 16, 16, 16, 136.5)
		var_0_56(var_124_39 - 7, var_124_40 - 6, var_124_30 + 14, var_124_31 + 12, 16, 16, 16, 28)
		var_0_186:draw(var_124_39, var_124_40, 12, 12)
		renderer.rectangle(var_124_39 + 15, var_124_40, 1, 12, 255, 255, 255, 255)

		for iter_124_9 = 1, #var_124_21 do
			local var_124_41 = var_124_21[iter_124_9]
			local var_124_42 = type(var_124_41[1]) == "table"
			local var_124_43
			local var_124_44
			local var_124_45
			local var_124_46
			local var_124_47
			local var_124_48
			local var_124_49
			local var_124_50
			local var_124_51

			if var_124_42 then
				local var_124_52, var_124_53, var_124_54, var_124_55, var_124_56, var_124_57, var_124_58, var_124_59, var_124_60 = unpack(var_124_41[1])
				local var_124_61 = var_124_60
				local var_124_62 = var_124_59
				local var_124_63 = var_124_58
				local var_124_64 = var_124_57
				local var_124_65 = var_124_56

				var_124_46 = var_124_55

				local var_124_66 = var_124_54
				local var_124_67 = var_124_53

				var_124_52:draw(var_124_39 + var_124_67, var_124_40 + var_124_66 + var_124_32[iter_124_9], var_124_46, var_124_65, var_124_64, var_124_63, var_124_62, var_124_61)
			end

			renderer.text(var_124_39 + (var_124_46 or -3) + 3, var_124_40 + var_124_32[iter_124_9], select(var_124_42 and 2 or 1, unpack(var_124_21[iter_124_9])))
		end
	end
end

local function var_0_189(arg_127_0, arg_127_1)
	var_0_101[arg_127_1] = {}
	var_0_102 = var_0_101[arg_127_1]

	local var_127_0 = 1 / globals.tickinterval()
	local var_127_1 = var_0_92()
	local var_127_2 = var_0_114()
	local var_127_3 = var_0_64(ui.get(var_0_139), function(arg_128_0, arg_128_1)
		return arg_128_1, true
	end)

	for iter_127_0 = 1, #var_0_93.sources do
		local var_127_4 = var_0_93.sources[iter_127_0]

		if var_127_2.enabled[var_127_4.id] then
			local var_127_5 = var_127_4:get_locations(var_127_1, true)

			if var_0_164 and var_0_165 == var_127_4 then
				local var_127_6 = {}

				for iter_127_1 = 1, #var_127_5 do
					if var_127_5[iter_127_1] == var_0_154 and var_0_167[var_127_5[iter_127_1]] == nil then
						-- block empty
					end

					if var_127_5[iter_127_1] == var_0_154 and var_0_167[var_127_5[iter_127_1]] ~= nil then
						local var_127_7 = var_0_106(var_0_167[var_127_5[iter_127_1]])

						if type(var_127_7) == "table" then
							var_127_7.editing = var_0_164 and var_0_168[var_127_5[iter_127_1]]
							var_127_6[iter_127_1] = var_127_7
						end
					else
						var_127_6[iter_127_1] = var_127_5[iter_127_1]
					end
				end

				if var_0_154 == "create_new" and var_0_167.create_new ~= nil then
					local var_127_8 = var_0_106(var_0_167[var_0_154])

					if type(var_127_8) == "table" then
						var_127_8.editing = var_0_164 and var_0_168[var_0_154]

						table.insert(var_127_6, var_127_8)
					end
				end

				var_127_5 = var_127_6
			end

			for iter_127_2 = 1, #var_127_5 do
				local var_127_9 = var_127_5[iter_127_2]
				local var_127_10 = false

				if var_127_9.type == "grenade" then
					if var_127_9.tickrates[var_127_0] ~= nil then
						for iter_127_3 = 1, #var_127_9.weapons do
							if var_127_3[var_0_15[var_127_9.weapons[iter_127_3]]] then
								var_127_10 = true
							end
						end
					end
				elseif var_127_9.type == "movement" then
					if var_127_3.Movement then
						var_127_10 = true
					end
				else
					error("not yet implemented: " .. var_127_9.type)
				end

				if var_127_10 and var_127_9.weapons_assoc[arg_127_1] then
					local var_127_11 = var_0_102[var_127_9.position_id]

					if var_127_11 == nil then
						var_127_11 = {
							in_range_draw_mp = 0,
							distance_width_mp = 0,
							distance_alpha = 0,
							visible_alpha = 0,
							position = var_127_9.position,
							position_approach = var_127_9.position,
							position_visibility = var_127_9.position_visibility,
							position_world_bottom = var_127_9.position + var_0_32
						}
						var_0_102[var_127_9.position_id] = var_127_11
					end

					var_127_9.in_fov_select_mp = 0
					var_127_9.in_fov_mp = 0
					var_127_9.on_screen_mp = 0

					table.insert(var_127_11, var_127_9)

					var_127_9.set = var_127_11

					if var_127_9.position_visibility_different then
						var_127_11.position_visibility = var_127_9.position_visibility
					end

					if var_127_9.duckamount ~= 1 then
						var_127_11.has_only_duck = false
					elseif var_127_9.duckamount == 1 and var_127_11.has_only_duck == nil then
						var_127_11.has_only_duck = true
					end

					if var_127_9.approach_accurate ~= nil then
						if var_127_11.approach_accurate == nil or var_127_11.approach_accurate == var_127_9.approach_accurate then
							var_127_11.approach_accurate = var_127_9.approach_accurate
						else
							client.error_log("approach_accurate conflict found")
						end
					end
				end
			end
		end
	end

	local var_127_12 = 0

	for iter_127_4, iter_127_5 in pairs(var_0_102) do
		if var_127_12 < iter_127_4 then
			var_127_12 = iter_127_4
		end
	end

	for iter_127_6 = 1, var_127_12 do
		local var_127_13 = var_0_102[iter_127_6]

		if var_127_13 ~= nil then
			local var_127_14 = var_127_13.position

			for iter_127_7 = iter_127_6 + 1, var_127_12 do
				local var_127_15 = var_0_102[iter_127_7]

				if var_127_15 ~= nil then
					local var_127_16 = var_127_15.position

					if var_0_179(var_127_14, var_127_16) < var_0_27 then
						local var_127_17 = #var_127_15 > #var_127_13 and iter_127_7 or iter_127_6
						local var_127_18 = var_127_17 == iter_127_6 and iter_127_7 or iter_127_6
						local var_127_19 = var_0_102[var_127_17]
						local var_127_20 = var_0_102[var_127_18]

						if var_127_19 ~= nil and var_127_20 ~= nil then
							local var_127_21 = #var_127_19

							for iter_127_8 = 1, #var_127_20 do
								local var_127_22 = var_127_20[iter_127_8]

								var_127_19[var_127_21 + iter_127_8] = var_127_22
								var_127_22.set = var_127_19

								if var_127_22.duckamount ~= 1 then
									var_127_19.has_only_duck = false
								elseif var_127_22.duckamount == 1 and var_127_19.has_only_duck == nil then
									var_127_19.has_only_duck = true
								end
							end

							local var_127_23 = 0
							local var_127_24 = 0
							local var_127_25 = 0
							local var_127_26 = #var_127_19

							for iter_127_9 = 1, var_127_26 do
								local var_127_27 = var_127_19[iter_127_9].position

								var_127_23 = var_127_23 + var_127_27.x
								var_127_24 = var_127_24 + var_127_27.y
								var_127_25 = var_127_25 + var_127_27.z
							end

							var_127_19.position = var_0_7(var_127_23 / var_127_26, var_127_24 / var_127_26, var_127_25 / var_127_26)
							var_127_19.position_world_bottom = var_127_19.position + var_0_32
							var_0_102[var_127_18] = nil
						end
					end
				end
			end
		end
	end

	local function var_127_28(arg_129_0, arg_129_1)
		return arg_129_0.viewangles.yaw > arg_129_1.viewangles.yaw
	end

	for iter_127_10, iter_127_11 in pairs(var_0_102) do
		if #iter_127_11 > 1 then
			table.sort(iter_127_11, var_127_28)
		end

		if iter_127_11.approach_accurate == nil then
			local var_127_29 = 0

			for iter_127_12 = 1, #var_0_45 do
				if var_127_29 > 1 then
					break
				end

				local var_127_30 = var_0_45[iter_127_12]

				for iter_127_13 = 1, #var_0_44 do
					local var_127_31 = iter_127_11.position + var_0_44[iter_127_13]
					local var_127_32, var_127_33, var_127_34 = var_127_31:unpack()
					local var_127_35, var_127_36, var_127_37 = (var_127_31 + var_127_30):unpack()
					local var_127_38, var_127_39 = client.trace_line(arg_127_0, var_127_32, var_127_33, var_127_34, var_127_35, var_127_36, var_127_37)
					local var_127_40 = var_127_31 + var_127_30

					if var_127_39 == 0 and var_127_38 > 0.45 and var_127_38 < 0.6 then
						var_127_29 = var_127_29 + 1

						break
					end
				end
			end

			iter_127_11.approach_accurate = var_127_29 > 1
		end
	end
end

local var_0_190
local var_0_191
local var_0_192
local var_0_193
local var_0_194 = {}
local var_0_195 = {}

local function var_0_196(arg_130_0)
	for iter_130_0, iter_130_1 in pairs(var_0_195) do
		ui.set(iter_130_0, iter_130_1)
	end

	if var_0_192 then
		var_0_36:set_raw_float(var_0_192 == 0 and tonumber(var_0_36:get_string()) or var_0_192)

		var_0_192 = nil
	end

	var_0_6(var_0_195)
end

local var_0_197
local var_0_198

local function var_0_199()
	var_0_183 = nil
	var_0_184 = nil

	local var_131_0 = entity.get_local_player()

	if var_131_0 == nil then
		var_0_102 = nil

		if var_0_185 ~= nil then
			var_0_185 = nil

			var_0_196(true)
		end

		return
	end

	local var_131_1 = entity.get_player_weapon(var_131_0)

	if var_131_1 == nil then
		var_0_102 = nil

		if var_0_185 ~= nil then
			var_0_185 = nil

			var_0_196()
		end

		return
	end

	local var_131_2 = var_0_1[entity.get_prop(var_131_1, "m_iItemDefinitionIndex")]

	if var_131_2 == nil then
		var_0_102 = nil

		if var_0_185 ~= nil then
			var_0_185 = nil

			var_0_196()
		end

		return
	end

	if var_0_18[var_131_2] ~= nil then
		var_131_2 = var_0_18[var_131_2]
	end

	local var_131_3 = var_0_181 ~= var_131_2

	if var_131_3 then
		var_0_102 = nil
		var_0_181 = var_131_2
	end

	local var_131_4 = tonumber(ui.get(var_0_117):sub(1, -2) / 100)
	local var_131_5 = ui.get(var_0_137)
	local var_131_6 = ui.get(var_0_140)
	local var_131_7 = var_131_6 == "Legit (Silent)" or var_131_6 == "Rage" or var_131_6 == "Legit" and ui.get(var_0_142) == 0
	local var_131_8, var_131_9 = client.screen_size()
	local var_131_10 = math.floor(var_131_9 * 0.012) * var_131_4
	local var_131_11 = var_131_9 * 0.018 * var_131_4
	local var_131_12 = globals.realtime()
	local var_131_13 = globals.frametime()
	local var_131_14, var_131_15 = client.camera_angles()
	local var_131_16 = var_0_7(client.camera_position())
	local var_131_17 = var_0_7():init_from_angles(var_131_14 - 90, var_131_15)
	local var_131_18 = var_0_7(entity.get_prop(var_131_0, "m_vecAbsOrigin"))
	local var_131_19 = entity.get_prop(var_131_0, "m_MoveType")
	local var_131_20 = var_131_17 * var_0_33
	local var_131_21, var_131_22, var_131_23, var_131_24 = ui.get(var_0_138)
	local var_131_25 = var_131_24 / 255

	if var_0_185 ~= nil and (not var_131_5 or not entity.is_alive(var_131_0) or var_131_19 == 8) then
		var_0_185 = nil

		var_0_196()
	end

	if var_0_164 then
		var_0_188()
	end

	if var_0_102 == nil then
		var_0_46:start("create active_locations")

		var_0_102 = {}
		var_0_182 = {}
		var_0_180 = 0

		if var_0_101[var_131_2] == nil then
			var_0_189(var_131_0, var_131_2)
		else
			var_0_102 = var_0_101[var_131_2]

			if var_131_3 then
				for iter_131_0, iter_131_1 in pairs(var_0_102) do
					iter_131_1.visible_alpha = 0
					iter_131_1.distance_alpha = 0
					iter_131_1.distance_width_mp = 0
					iter_131_1.in_range_draw_mp = 0

					for iter_131_2 = 1, #iter_131_1 do
						iter_131_1[iter_131_2].set = iter_131_1
					end
				end
			end
		end

		var_0_46:finish("create active_locations", true)
	end

	if var_0_102 ~= nil then
		if var_131_12 > var_0_180 + 0.07 then
			var_0_6(var_0_182)

			var_0_180 = var_131_12

			for iter_131_3, iter_131_4 in pairs(var_0_102) do
				iter_131_4.distsqr = var_0_179(var_131_18, iter_131_4.position)
				iter_131_4.in_range = iter_131_4.distsqr <= var_0_26

				if iter_131_4.in_range then
					iter_131_4.distance = math.sqrt(iter_131_4.distsqr)

					local var_131_26, var_131_27, var_131_28 = var_131_16:unpack()
					local var_131_29, var_131_30 = client.trace_line(var_131_0, var_131_26, var_131_27, var_131_28, iter_131_4.position_visibility:unpack())

					iter_131_4.visible = var_131_30 == -1 or var_131_29 > 0.99
					iter_131_4.in_range_text = iter_131_4.distance <= var_0_28

					table.insert(var_0_182, iter_131_4)
				else
					iter_131_4.distance_alpha = 0
					iter_131_4.in_range_text = false
					iter_131_4.distance_width_mp = 0
				end
			end

			table.sort(var_0_182, var_0_109)
		end

		if #var_0_182 == 0 then
			return
		end

		for iter_131_5 = 1, #var_0_182 do
			local var_131_31 = var_0_182[iter_131_5]

			if var_0_183 == nil or var_131_31.distance < var_0_183.distance then
				var_0_183 = var_131_31
			end
		end

		local var_131_32 = var_0_185 ~= nil and var_0_185.set or nil
		local var_131_33 = var_131_19 == var_0_38 and var_0_29 * 3 or var_0_29
		local var_131_34 = 1

		if var_131_32 ~= nil then
			var_0_183 = var_131_32
			var_131_34 = 1
		elseif var_131_33 > var_0_183.distance then
			var_131_34 = 0.4 + var_0_2.quad_in_out(var_0_183.distance, 0, 0.6, var_131_33)
		else
			var_0_183 = nil
		end

		local var_131_35 = ui.get(var_0_143)
		local var_131_36 = {}

		for iter_131_6 = 1, #var_0_182 do
			local var_131_37 = var_0_182[iter_131_6]
			local var_131_38 = var_131_37 == var_0_183

			var_131_37.distance = var_131_18:dist(var_131_37.position)
			var_131_37.distance_alpha = var_131_32 == var_131_37 and 1 or var_0_2.quart_out(1 - var_131_37.distance / var_0_25, 0, 1, 1)

			local var_131_39 = var_131_37.in_range_text and (var_131_34 > 0.5 or var_131_38)

			if var_131_39 and var_131_37.distance_width_mp < 1 then
				var_131_37.distance_width_mp = math.min(1, var_131_37.distance_width_mp + var_131_13 * 7.5)
			elseif not var_131_39 and var_131_37.distance_width_mp > 0 then
				var_131_37.distance_width_mp = math.max(0, var_131_37.distance_width_mp - var_131_13 * 7.5)
			end

			local var_131_40 = var_0_2.quad_in_out(var_131_37.distance_width_mp, 0, 1, 1)
			local var_131_41 = var_131_35 and var_131_37.distance_width_mp > 0 and 0.45 or 0
			local var_131_42 = var_131_35 and var_131_37.distance_width_mp > 0 and not var_131_37.visible and 0.33 or 1

			if var_131_37.visible and var_131_37.visible_alpha < 1 or var_131_41 > var_131_37.visible_alpha then
				var_131_37.visible_alpha = math.min(1, var_131_37.visible_alpha + var_131_13 * 5.5 * var_131_42)
			elseif not var_131_37.visible and var_131_41 < var_131_37.visible_alpha then
				var_131_37.visible_alpha = math.max(var_131_41, var_131_37.visible_alpha - var_131_13 * 7.5 * var_131_42)
			end

			local var_131_43 = var_0_2.sine_in_out(var_131_37.visible_alpha, 0, 1, 1) * (var_131_38 and 1 or var_131_34) * var_131_37.distance_alpha

			if not var_131_38 then
				var_131_37.in_range_draw_mp = 0
			end

			if var_131_43 > 0 then
				local var_131_44 = var_131_37.position_world_bottom
				local var_131_45, var_131_46 = renderer.world_to_screen(var_131_44:unpack())

				if var_131_45 ~= nil then
					local var_131_47, var_131_48 = renderer.world_to_screen((var_131_44 + var_131_20):unpack())

					if var_131_47 ~= nil then
						local var_131_49 = 0
						local var_131_50 = 0
						local var_131_51 = {}

						for iter_131_7 = 1, #var_131_37 do
							local var_131_52 = var_131_37[iter_131_7]
							local var_131_53 = var_131_52.name
							local var_131_54 = var_131_21
							local var_131_55 = var_131_22
							local var_131_56 = var_131_23
							local var_131_57 = var_131_24 * var_131_43

							if var_131_52.editing then
								var_131_54, var_131_55, var_131_56 = unpack(var_0_39)
							end

							table.insert(var_131_51, {
								var_131_54,
								var_131_55,
								var_131_56,
								var_131_57,
								"d",
								var_131_53
							})
						end

						for iter_131_8 = 1, #var_131_51 do
							local var_131_58, var_131_59, var_131_60, var_131_61, var_131_62, var_131_63 = unpack(var_131_51[iter_131_8])
							local var_131_64, var_131_65 = renderer.measure_text(var_131_62, var_131_63)
							local var_131_66 = var_131_65 - 1

							if var_131_49 < var_131_64 then
								var_131_49 = var_131_64
							end

							var_131_51[iter_131_8].y_o = var_131_50 - 1
							var_131_50 = var_131_50 + var_131_66
							var_131_51[iter_131_8].width = var_131_64
							var_131_51[iter_131_8].height = var_131_66
						end

						if var_131_37.distance_width_mp < 1 then
							var_131_49 = var_131_49 * var_131_37.distance_width_mp
							var_131_50 = math.max(var_131_51[1] and var_131_51[1].height or 0, var_131_50 * math.min(1, var_131_37.distance_width_mp * 1))

							for iter_131_9 = 1, #var_131_51 do
								local var_131_67, var_131_68, var_131_69, var_131_70, var_131_71, var_131_72 = unpack(var_131_51[iter_131_9])

								for iter_131_10 = var_131_72:len(), 0, -1 do
									local var_131_73 = var_131_72:sub(1, iter_131_10)
									local var_131_74 = renderer.measure_text(var_131_71, var_131_73)

									if var_131_74 <= var_131_49 then
										var_131_51[iter_131_9][6] = var_131_73
										var_131_51[iter_131_9].width = var_131_74

										break
									end
								end
							end
						end

						if var_131_37.distance_width_mp > 0 then
							var_131_49 = var_131_49 + 2
						else
							var_131_49 = 0
						end

						local var_131_75
						local var_131_76
						local var_131_77
						local var_131_78
						local var_131_79
						local var_131_80
						local var_131_81
						local var_131_82 = var_131_37[1]

						if var_131_82.type == "movement" and var_131_82.weapons[1].type ~= "grenade" then
							var_131_81 = var_0_47.bhop
						else
							var_131_81 = var_0_16[var_131_37[1].weapons[1]]
						end

						local var_131_83
						local var_131_84
						local var_131_85
						local var_131_86

						if var_131_81 ~= nil then
							local var_131_87, var_131_88

							var_131_83, var_131_84, var_131_87, var_131_88 = unpack(var_0_17[var_131_81])

							local var_131_89 = math.min(var_131_11, math.max(var_131_10, var_131_50 + 2, math.abs(var_131_46 - var_131_48)))

							var_131_79, var_131_80 = var_131_81:measure(nil, var_131_89)
							var_131_83 = var_131_83 * var_131_79
							var_131_84 = var_131_84 * var_131_80
							var_131_77 = var_131_79 + var_131_87 * var_131_79
							var_131_78 = var_131_80 + var_131_88 * var_131_80
						end

						local var_131_90 = var_131_49
						local var_131_91 = var_131_50

						if var_131_77 ~= nil then
							var_131_90 = var_131_90 + var_131_37.distance_width_mp * 8 * var_131_4 + var_131_77
							var_131_91 = math.max(var_131_78, var_131_50)
						else
							var_131_91 = math.max(math.floor(15 * var_131_4), var_131_50)
						end

						local var_131_92 = math.floor(var_131_47 - var_131_90 / 2)
						local var_131_93 = math.floor(var_131_46 - var_131_91)

						for iter_131_11 = 1, #var_131_36 do
							local var_131_94, var_131_95, var_131_96, var_131_97 = unpack(var_131_36[iter_131_11])
						end

						if var_131_77 ~= nil then
							var_131_75 = var_131_45 - var_131_90 / 2 + var_131_83
							var_131_76 = var_131_46 - var_131_91 + var_131_84

							if var_131_78 < var_131_50 then
								var_131_76 = var_131_76 + (var_131_50 - var_131_78) / 2
							end
						end

						renderer.rectangle(var_131_92 - 2, var_131_93 - 2, var_131_90 + 4, var_131_91 + 4, 16, 16, 16, 180 * var_131_43 * var_131_25)
						var_0_56(var_131_92 - 3, var_131_93 - 3, var_131_90 + 6, var_131_91 + 6, 16, 16, 16, 170 * var_131_43 * var_131_25)
						var_0_56(var_131_92 - 4, var_131_93 - 4, var_131_90 + 8, var_131_91 + 8, 16, 16, 16, 195 * var_131_43 * var_131_25)
						var_0_56(var_131_92 - 5, var_131_93 - 5, var_131_90 + 10, var_131_91 + 10, 16, 16, 16, 40 * var_131_43 * var_131_25)

						local var_131_98 = var_131_21
						local var_131_99 = var_131_22
						local var_131_100 = var_131_23

						if var_131_37[1].editing and #var_131_37 == 1 then
							var_131_98, var_131_99, var_131_100 = unpack(var_0_39)
						end

						if var_131_37.distance_width_mp > 0 then
							if var_131_77 ~= nil then
								renderer.rectangle(var_131_92 + var_131_77 + 3, var_131_93 + 2, 1, var_131_91 - 3, var_131_98, var_131_99, var_131_100, var_131_24 * var_131_43)
							end

							local var_131_101 = var_131_92 + (var_131_77 == nil and 0 or var_131_77 + 8 * var_131_4)
							local var_131_102 = var_131_93

							if var_131_50 < var_131_91 then
								var_131_102 = var_131_102 + math.floor((var_131_91 - var_131_50) / 2)
							end

							for iter_131_12 = 1, #var_131_51 do
								local var_131_103, var_131_104, var_131_105, var_131_106, var_131_107, var_131_108 = unpack(var_131_51[iter_131_12])
								local var_131_109 = var_131_101
								local var_131_110 = var_131_102 + var_131_51[iter_131_12].y_o

								if var_131_50 < var_131_51[iter_131_12].y_o + var_131_51[iter_131_12].height - 4 then
									break
								end

								renderer.text(var_131_109, var_131_110, var_131_103, var_131_104, var_131_105, var_131_106, var_131_107, 0, var_131_108)
							end
						end

						if var_131_81 ~= nil then
							local var_131_111 = math.min(2, var_131_91 * 0.03)
							local var_131_112 = 1

							if var_131_111 > 0.6 and var_131_111 < 1 then
								var_131_112 = (var_131_111 - 0.6) / 0.4
								var_131_111 = 1
							else
								var_131_111 = math.floor(var_131_111)
							end

							local var_131_113 = 0
							local var_131_114 = 0
							local var_131_115 = 0
							local var_131_116 = 80 * var_131_112 * var_131_43 * var_131_25

							if var_131_111 > 0 then
								var_131_81:draw(var_131_75 - var_131_111, var_131_76, var_131_79, var_131_80, var_131_113, var_131_114, var_131_115, var_131_116, true)
								var_131_81:draw(var_131_75 + var_131_111, var_131_76, var_131_79, var_131_80, var_131_113, var_131_114, var_131_115, var_131_116, true)
								var_131_81:draw(var_131_75, var_131_76 - var_131_111, var_131_79, var_131_80, var_131_113, var_131_114, var_131_115, var_131_116, true)
								var_131_81:draw(var_131_75, var_131_76 + var_131_111, var_131_79, var_131_80, var_131_113, var_131_114, var_131_115, var_131_116, true)
							end

							var_131_81:draw(var_131_75, var_131_76, var_131_79, var_131_80, var_131_98, var_131_99, var_131_100, var_131_24 * var_131_43, true)
						end

						table.insert(var_131_36, {
							var_131_92 - 10,
							var_131_93 - 10,
							var_131_90 + 10,
							var_131_91 + 10
						})
					end
				end
			end
		end

		if var_0_183 ~= nil then
			if var_0_183.distance == nil then
				var_0_183.distance = var_131_18:dist(var_0_183.position)
			end

			local var_131_117 = var_0_183.distance < (var_131_19 == var_0_38 and var_0_30 * 3 or var_0_30)

			if var_0_183 == var_131_32 then
				local var_131_118 = var_0_185.type == "movement" and 80 or 180

				var_0_183.in_range_draw_mp = math.max(0, 1 - var_0_2.expo_in(var_0_183.distance / var_131_118, 0, 1, 1))
			elseif var_131_117 and var_0_183.in_range_draw_mp < 1 then
				var_0_183.in_range_draw_mp = math.min(1, var_0_183.in_range_draw_mp + var_131_13 * 8)
			elseif not var_131_117 and var_0_183.in_range_draw_mp > 0 then
				var_0_183.in_range_draw_mp = math.max(0, var_0_183.in_range_draw_mp - var_131_13 * 8)
			end

			if var_0_183.in_range_draw_mp > 0 then
				local var_131_119 = var_0_68()
				local var_131_120

				for iter_131_13 = 1, #var_0_183 do
					local var_131_121 = var_0_183[iter_131_13]

					if var_131_121.viewangles_target ~= nil then
						local var_131_122 = var_131_121.viewangles.pitch
						local var_131_123 = var_131_121.viewangles.yaw
						local var_131_124, var_131_125 = var_0_53(var_131_14 - var_131_122, var_131_15 - var_131_123)

						var_131_121.viewangles_dist = math.sqrt(var_131_124 * var_131_124 + var_131_125 * var_131_125)

						if var_131_120 == nil or var_131_120.viewangles_dist > var_131_121.viewangles_dist then
							var_131_120 = var_131_121
						end

						if var_131_6 == "Legit" or var_131_6 == "Legit (Silent)" and var_131_121.type == "movement" then
							var_131_121.is_in_fov_select = var_131_121.viewangles_dist <= ui.get(var_0_141) * 0.1
						else
							var_131_121.is_in_fov_select = var_131_121.viewangles_dist <= (var_131_121.fov_select or var_131_6 == "Rage" and var_0_23.select_fov_rage or var_0_23.select_fov_legit)
						end

						local var_131_126 = var_131_18:dist(var_131_121.position)
						local var_131_127 = var_131_18:dist2d(var_131_121.position)

						if var_131_19 == var_0_38 then
							local var_131_128 = var_0_7(entity.get_prop(var_131_0, "m_vecLadderNormal")):vectors()

							var_131_128:normalize()

							local var_131_129 = var_131_18 - var_131_128 * 50
							local var_131_130 = var_131_129 + var_131_128 * 100
							local var_131_131 = (var_131_130 - var_131_129) / var_131_129:dist(var_131_130)
							local var_131_132 = var_131_129 + var_131_131 * (var_131_121.position - var_131_129):dot(var_131_131)
							local var_131_133 = var_131_18:dist2d(var_131_132)
							local var_131_134 = math.abs(var_131_18.z - var_131_121.position.z)

							var_131_127 = var_131_133
							var_131_126 = math.sqrt(var_131_133 * var_131_133 + var_131_133 * var_131_133 + var_131_134 * var_131_134)
						elseif var_131_127 < 1.5 then
							var_131_126 = var_131_127
						end

						var_131_121.is_position_correct = var_131_126 < var_0_31 and entity.get_prop(var_131_0, "m_flDuckAmount") == var_131_121.duckamount

						if var_131_121.fov ~= nil then
							var_131_121.is_in_fov = var_131_121.is_in_fov_select and ((var_131_121.type ~= "movement" or var_131_6 ~= "Legit (Silent)") and var_131_7 or var_131_121.viewangles_dist <= var_131_121.fov)
						end
					end
				end

				local var_131_135 = var_0_2.cubic_in(var_0_183.in_range_draw_mp, 0, 1, 1)

				for iter_131_14 = 1, #var_0_183 do
					local var_131_136 = var_0_183[iter_131_14]

					if var_131_136.viewangles_target ~= nil then
						local var_131_137 = var_131_136 == var_131_120 and var_131_136.is_in_fov_select or var_131_136 == var_0_185
						local var_131_138 = 1

						if var_131_136.is_in_fov_select ~= nil then
							if var_131_137 and var_131_136.in_fov_select_mp < 1 then
								var_131_136.in_fov_select_mp = math.min(1, var_131_136.in_fov_select_mp + var_131_13 * 2.5 * (var_131_136.is_in_fov and 2 or 1))
							elseif not var_131_137 and var_131_136.in_fov_select_mp > 0 then
								var_131_136.in_fov_select_mp = math.max(0, var_131_136.in_fov_select_mp - var_131_13 * 4.5)
							end

							var_131_138 = var_131_136.in_fov_select_mp
						end

						local var_131_139 = 1

						if var_131_136.is_in_fov ~= nil then
							local var_131_140 = var_131_137 and var_131_136.is_in_fov

							if var_131_136 == var_0_185 then
								var_131_140 = false
							end

							local var_131_141 = var_131_136.is_position_correct and 1 or 0.45

							if var_131_140 and var_131_141 > var_131_136.in_fov_mp then
								var_131_136.in_fov_mp = math.min(var_131_141, var_131_136.in_fov_mp + var_131_13 * 6.5)
							elseif (not var_131_140 or var_131_141 < var_131_136.in_fov_mp) and var_131_136.in_fov_mp > 0 then
								var_131_136.in_fov_mp = math.max(0, var_131_136.in_fov_mp - var_131_13 * 5.5)
							end

							var_131_139 = var_131_136.in_fov_mp
						end

						if var_131_137 then
							var_0_184 = var_131_136
						end

						local var_131_142, var_131_143, var_131_144 = var_131_136.viewangles_target:unpack()
						local var_131_145, var_131_146, var_131_147 = var_0_72(var_131_142, var_131_143, var_131_144, var_131_119, var_131_8, var_131_9, 40)

						if var_131_145 ~= nil then
							local var_131_148, var_131_149 = math.floor(var_131_145 + 0.5), math.floor(var_131_146 + 0.5)

							if var_131_147 and var_131_136.on_screen_mp < 1 then
								var_131_136.on_screen_mp = math.min(1, var_131_136.on_screen_mp + var_131_13 * 3.5)
							elseif not var_131_147 and var_131_136.on_screen_mp > 0 then
								var_131_136.on_screen_mp = math.max(0, var_131_136.on_screen_mp - var_131_13 * 4.5)
							end

							local var_131_150 = (0.5 + var_131_136.on_screen_mp * 0.5) * var_131_135
							local var_131_151 = "»" .. var_131_136.name
							local var_131_152
							local var_131_153, var_131_154 = renderer.measure_text("bd", var_131_151)
							local var_131_155 = 0
							local var_131_156 = 0

							if var_131_136.description ~= nil then
								var_131_152 = var_131_136.description:upper():gsub(" ", "  ")
								var_131_155, var_131_156 = renderer.measure_text("d-", var_131_152 .. " ")
							end

							local var_131_157 = math.floor(var_131_156 / 2)
							local var_131_158 = var_131_157 - var_131_157 % 2
							local var_131_159 = math.max(var_131_153, var_131_155)
							local var_131_160 = var_131_154 + var_131_156
							local var_131_161 = var_131_21
							local var_131_162 = var_131_22
							local var_131_163 = var_131_23

							if var_131_136.editing then
								var_131_161, var_131_162, var_131_163 = unpack(var_0_39)
							end

							local var_131_164 = math.floor(var_131_154 / 2 - 1) * 2
							local var_131_165 = 0

							if var_131_136.on_screen_mp > 0 then
								var_131_165 = math.floor((var_131_164 + 8 * var_131_4) * var_131_136.on_screen_mp) + var_131_158
								var_131_159 = var_131_159 + var_131_165
							end

							local var_131_166, var_131_167 = var_131_148 - var_131_164 / 2 - var_131_158 / 2, var_131_149 - var_131_160 / 2
							local var_131_168 = math.min(var_131_166, var_131_8 - 40 - var_131_159)
							local var_131_169 = var_131_167
							local var_131_170 = var_0_2.sine_out(var_131_150, 0, 1, 1) * var_131_24 / 255

							renderer.rectangle(var_131_168 - 2, var_131_169 - 2, var_131_159 + 4, var_131_160 + 4, 16, 16, 16, 150 * var_131_170)
							var_0_56(var_131_168 - 3, var_131_169 - 3, var_131_159 + 6, var_131_160 + 6, 16, 16, 16, 170 * var_131_170)
							var_0_56(var_131_168 - 4, var_131_169 - 4, var_131_159 + 8, var_131_160 + 8, 16, 16, 16, 195 * var_131_170)
							var_0_56(var_131_168 - 5, var_131_169 - 5, var_131_159 + 10, var_131_160 + 10, 16, 16, 16, 40 * var_131_170)

							if not var_131_147 then
								local var_131_171 = 1 - var_131_136.on_screen_mp

								if var_131_171 > 0 then
									local var_131_172 = var_131_8 / 2
									local var_131_173 = var_131_9 / 2
									local var_131_174 = math.atan2(var_131_169 + var_131_160 / 2 - var_131_173, var_131_168 + var_131_159 / 2 - var_131_172) + math.rad(90)
									local var_131_175, var_131_176 = var_0_57(var_131_174, 0, -var_131_9 / 2 + 100)
									local var_131_177 = var_131_8 / 2 + var_131_175
									local var_131_178 = var_131_9 / 2 + var_131_176
									local var_131_179 = var_0_58(var_131_177, var_131_178, var_131_168 + var_131_159 / 2, var_131_169 + var_131_160 / 2)
									local var_131_180 = var_0_58(var_131_177, var_131_178, var_131_172, var_131_173)
									local var_131_181 = var_0_58(var_131_172, var_131_173, var_131_168 + var_131_159 / 2, var_131_169 + var_131_160 / 2)
									local var_131_182 = 1

									if var_131_179 < 40 then
										var_131_182 = (var_131_179 - 30) / 10
									end

									if var_131_180 < var_131_181 and var_131_182 > 0 then
										local var_131_183 = math.floor(var_131_154 * 1.5)
										local var_131_184 = 0.2 + math.abs(math.sin(globals.realtime() * math.pi * 0.8 + iter_131_14 * 0.1)) * 0.8

										var_0_59(var_131_177, var_131_178, var_131_183 * 1.66, var_131_183, var_131_174, var_131_161, var_131_162, var_131_163, var_131_24 * math.min(1, var_131_150 * 1.5) * var_131_171 * var_131_182 * var_131_184)
									end
								end
							end

							if var_131_136.on_screen_mp > 0.5 and var_131_135 > 0 then
								local var_131_185 = 255 * var_131_135 * var_0_2.expo_in(var_131_136.on_screen_mp, 0, 1, 1) * var_131_25
								local var_131_186 = 255
								local var_131_187 = 10
								local var_131_188 = 10
								local var_131_189 = 20
								local var_131_190 = 236
								local var_131_191 = 0
								local var_131_192 = 140
								local var_131_193 = 140
								local var_131_194 = 140
								local var_131_195 = 16
								local var_131_196 = 16
								local var_131_197 = 16
								local var_131_198 = 1

								if var_131_136 == var_0_185 then
									var_131_186, var_131_187, var_131_188 = var_131_161, var_131_162, var_131_163
									var_131_195, var_131_196, var_131_197, var_131_198 = 190, 190, 190, 0.35
								end

								local var_131_199, var_131_200, var_131_201 = var_0_52(var_131_186, var_131_187, var_131_188, 0, var_131_189, var_131_190, var_131_191, 0, var_131_139)
								local var_131_202, var_131_203, var_131_204 = var_0_52(var_131_192, var_131_193, var_131_194, 0, var_131_199, var_131_200, var_131_201, 0, var_131_138)
								local var_131_205 = var_131_166 + var_131_164 / 2 + var_131_158 / 2
								local var_131_206 = var_131_167 + var_131_160 / 2
								local var_131_207 = var_131_164 / 2

								renderer.circle_outline(var_131_205, var_131_206, 16, 16, 16, var_131_185 * 0.6, var_131_207 + 1, 0, 1, 2)
								renderer.circle(var_131_205, var_131_206, var_131_202, var_131_203, var_131_204, var_131_185, var_131_207, 0, 1)
								renderer.circle_outline(var_131_205, var_131_206, var_131_195, var_131_196, var_131_197, var_131_198 * var_131_185 * 0.3, var_131_207 + 1, 0, 1, 2)
								renderer.circle_outline(var_131_205, var_131_206, var_131_195, var_131_196, var_131_197, var_131_198 * var_131_185 * 0.2, var_131_207, 0, 1, 2)
								renderer.circle_outline(var_131_205, var_131_206, var_131_195, var_131_196, var_131_197, var_131_198 * var_131_185 * 0.1, var_131_207 - 1, 0, 1, 2)
							end

							if var_131_165 > 1 then
								renderer.rectangle(var_131_168 + var_131_165 - 4 * var_131_4, var_131_169 + 1, 1, var_131_160 - 1, var_131_161, var_131_162, var_131_163, var_131_24 * var_131_150 * var_131_136.on_screen_mp)
							end

							renderer.text(var_131_168 + var_131_165, var_131_167, var_131_161, var_131_162, var_131_163, var_131_24 * var_131_150, "bd", 0, var_131_151)

							if var_131_152 ~= nil then
								renderer.text(var_131_168 + var_131_165, var_131_167 + var_131_154, math.min(255, var_131_161 * 1.2), math.min(255, var_131_162 * 1.2), math.min(255, var_131_163 * 1.2), var_131_24 * var_131_150 * 0.92, "-d", 0, var_131_152)
							end
						end
					end
				end
			end
		end

		if var_131_5 and var_0_184 ~= nil and (var_0_184.type == "movement" and var_131_6 ~= "Rage" or var_0_184.type ~= "movement" and var_131_6 == "Legit") and (not var_0_184.is_in_fov or var_0_184.viewangles_dist > 0.05) then
			local var_131_208 = ui.get(var_0_142) / 100

			if var_131_208 == 0 then
				if var_0_184.type == "grenade" and entity.get_prop(entity.get_player_weapon(var_131_0), "m_bPinPulled") == 1 then
					client.camera_angles(var_0_184.viewangles.pitch, var_0_184.viewangles.yaw)
				end
			else
				local var_131_209 = var_0_184.viewangles.pitch
				local var_131_210 = var_0_184.viewangles.yaw
				local var_131_211, var_131_212 = var_0_53(var_131_14 - var_131_209, var_131_15 - var_131_210)
				local var_131_213 = var_0_184.viewangles_dist
				local var_131_214 = var_131_211 / var_131_213
				local var_131_215 = var_131_212 / var_131_213
				local var_131_216 = math.min(1, var_131_213 / 3) * 0.5
				local var_131_217 = (var_131_216 + math.abs(var_131_213 * (1 - var_131_216))) * globals.frametime() * 15 * var_131_208
				local var_131_218 = var_131_14 - var_131_214 * var_131_217 * client.random_float(0.7, 1.2)
				local var_131_219 = var_131_15 - var_131_215 * var_131_217 * client.random_float(0.7, 1.2)

				client.camera_angles(var_131_218, var_131_219)
			end
		end
	end
end

local function var_0_200(arg_132_0)
	arg_132_0.in_forward = 0
	arg_132_0.in_back = 0
	arg_132_0.in_moveleft = 0
	arg_132_0.in_moveright = 0
	arg_132_0.forwardmove = 0
	arg_132_0.sidemove = 0
	arg_132_0.in_jump = 0
	arg_132_0.in_speed = 0
end

local function var_0_201(arg_133_0, arg_133_1, arg_133_2)
	local var_133_0 = 1 / globals.tickinterval()
	local var_133_1 = var_0_185.tickrates[var_133_0]
	local var_133_2 = ui.get(var_0_140)
	local var_133_3 = entity.get_prop(arg_133_1, "m_MoveType")

	if var_0_190 == nil then
		var_0_190 = "prepare"

		var_0_6(var_0_194)

		if (var_133_2 == "Legit" or var_133_2 == "Off") and var_0_36:get_float() > 0 then
			var_0_192 = var_0_36:get_float()

			var_0_36:set_raw_float(0)
		end

		local var_133_4 = var_0_191

		client.delay_call((var_0_185.run_duration or 0) * var_133_1 * 2 + 2, function()
			if var_0_185 ~= nil and var_0_191 == var_133_4 then
				client.error_log("[helper] playback timed out")

				var_0_185 = nil

				var_0_196(true)
			end
		end)
	end

	if arg_133_2 ~= var_0_193 and var_0_190 ~= "finished" then
		var_0_185 = nil

		var_0_196()

		return
	end

	if var_0_190 ~= "finished" then
		var_0_200(arg_133_0, var_0_185)

		arg_133_0.in_duck = var_0_185.duckamount == 1 and 1 or 0
		arg_133_0.move_yaw = var_0_185.run_yaw
	elseif var_0_192 then
		var_0_36:set_raw_float(var_0_192 == 0 and tonumber(var_0_36:get_string()) or var_0_192)

		var_0_192 = nil
	end

	if var_0_190 == "prepare" or var_0_190 == "run" or var_0_190 == "thrown" then
		if var_0_185.throw_strength == 1 then
			arg_133_0.in_attack = 1
			arg_133_0.in_attack2 = 0
		elseif var_0_185.throw_strength == 0.5 then
			arg_133_0.in_attack = 1
			arg_133_0.in_attack2 = 1
		elseif var_0_185.throw_strength == 0 then
			arg_133_0.in_attack = 0
			arg_133_0.in_attack2 = 1
		end
	end

	if var_0_190 == "prepare" and entity.get_prop(arg_133_2, "m_flThrowStrength") == var_0_185.throw_strength then
		var_0_190 = "run"
		var_0_194.start_at = arg_133_0.command_number
	end

	if var_0_190 == "run" or var_0_190 == "throw" or var_0_190 == "thrown" then
		local var_133_5 = arg_133_0.command_number - var_0_194.start_at

		if var_0_185.run_duration ~= nil and var_133_5 < var_0_185.run_duration * var_133_1 then
			-- block empty
		elseif var_0_190 == "run" then
			var_0_190 = "throw"
		end

		if var_0_185.run_duration ~= nil then
			arg_133_0.forwardmove = 450
			arg_133_0.in_forward = 1
			arg_133_0.in_speed = var_0_185.run_speed and 1 or 0

			if ui.get(var_0_127) and ui.get(var_0_128) ~= "Off" then
				var_0_198 = entity.get_prop(arg_133_1, "m_nWaterLevel")

				entity.set_prop(arg_133_1, "m_nWaterLevel", 2)

				var_0_197 = entity.get_prop(arg_133_1, "m_MoveType")

				entity.set_prop(arg_133_1, "m_MoveType", 1)
			end
		end
	end

	if var_0_190 == "throw" then
		if var_0_185.jump then
			arg_133_0.in_jump = 1
		end

		var_0_190 = "thrown"
		var_0_194.throw_at = arg_133_0.command_number
	end

	if var_0_190 == "thrown" and arg_133_0.command_number - var_0_194.throw_at >= var_0_185.delay then
		arg_133_0.in_attack = 0
		arg_133_0.in_attack2 = 0
	end

	if var_0_190 == "finished" then
		if var_0_185.jump then
			if bit.band(entity.get_prop(arg_133_1, "m_fFlags"), var_0_37) == var_0_37 then
				var_0_190 = nil
				var_0_185 = nil

				var_0_196()
			else
				if ui.get(var_0_140) == "Rage" and arg_133_0.in_forward == 0 and arg_133_0.in_back == 0 and arg_133_0.in_moveleft == 0 and arg_133_0.in_moveright == 0 and arg_133_0.in_jump == 0 then
					var_0_200(arg_133_0)

					arg_133_0.move_yaw = var_0_185.recovery_yaw or var_0_185.run_yaw - 180
					arg_133_0.forwardmove = 450
					arg_133_0.in_forward = 1
					arg_133_0.in_jump = var_0_185.recovery_jump and 1 or 0
				end

				if var_0_195[var_0_118] then
					var_0_195[var_0_118] = nil

					client.delay_call(cvar.sv_airaccelerate:get_float() > 50 and 0 or 0.05, ui.set, var_0_118, true)
				end
			end
		elseif var_0_185.recovery_yaw ~= nil then
			if ui.get(var_0_140) == "Rage" and arg_133_0.in_forward == 0 and arg_133_0.in_back == 0 and arg_133_0.in_moveleft == 0 and arg_133_0.in_moveright == 0 and arg_133_0.in_jump == 0 then
				if var_0_194.recovery_start_at == nil then
					var_0_194.recovery_start_at = arg_133_0.command_number
				end

				local var_133_6 = math.min(32, var_0_185.run_duration or 16) + 13 + (var_0_185.recovery_jump and 10 or 0)

				if var_0_194.recovery_start_at + var_133_6 >= arg_133_0.command_number then
					arg_133_0.move_yaw = var_0_185.recovery_yaw
					arg_133_0.forwardmove = 450
					arg_133_0.in_forward = 1
					arg_133_0.in_jump = var_0_185.recovery_jump and 1 or 0
				end
			else
				var_0_185 = nil

				var_0_196()
			end
		end
	end

	if var_0_190 == "thrown" then
		if var_0_185.jump and ui.get(var_0_118) then
			var_0_195[var_0_118] = true

			ui.set(var_0_118, false)
		end

		if ui.get(var_0_119) then
			var_0_195[var_0_119] = true

			ui.set(var_0_119, false)
		end

		if ui.get(var_0_120) then
			var_0_195[var_0_120] = true

			ui.set(var_0_120, false)
		end

		if ui.get(var_0_121) then
			var_0_195[var_0_121] = true

			ui.set(var_0_121, false)
		end

		if ui.get(var_0_122) ~= "Off" then
			var_0_195[var_0_122] = ui.get(var_0_122)

			ui.set(var_0_122, "Off")
		end

		if ui.get(var_0_123) then
			var_0_195[var_0_123] = true

			ui.set(var_0_123, false)
		end

		local var_133_7 = ui.get(var_0_140)
		local var_133_8 = entity.get_prop(arg_133_2, "m_fThrowTime")

		if var_0_66(arg_133_2, arg_133_0) then
			var_0_194.thrown_at = arg_133_0.command_number

			if var_0_8 and var_0_185.run_duration ~= nil then
				local var_133_9 = var_0_7(entity.get_prop(arg_133_1, "m_vecAbsOrigin"))
				local var_133_10 = var_0_7(entity.get_prop(arg_133_1, "m_vecAbsVelocity"))

				client.log("throwing from ", var_133_9)
				client.log("throw velocity: ", var_133_10:length())

				local var_133_11, var_133_12 = var_0_185.position:to(var_133_9):angles()

				if var_133_12 ~= nil then
					client.log("resulting move yaw: ", var_133_12, " (offset: ", var_133_12 - var_0_185.run_yaw, ")")
				end

				local var_133_13 = entity.get_player_weapon(arg_133_1)

				client.log("throw strength: ", entity.get_prop(var_133_13, "m_flThrowStrength"))
			end

			if var_133_7 == "Legit (Silent)" or var_133_7 == "Rage" then
				arg_133_0.pitch = var_0_185.viewangles.pitch
				arg_133_0.yaw = var_0_185.viewangles.yaw
				arg_133_0.allow_send_packet = false
			end

			client.delay_call(0.8, var_0_196, true)
		elseif entity.get_prop(arg_133_2, "m_fThrowTime") == 0 and var_0_194.thrown_at ~= nil and var_0_194.thrown_at > var_0_194.throw_at then
			var_0_190 = "finished"

			local var_133_14 = var_0_191

			client.delay_call(0.6, function()
				if var_0_190 == "finished" and var_0_191 == var_133_14 then
					var_0_185 = nil

					var_0_196(true)
				end
			end)
		end
	end
end

local function var_0_202(arg_136_0, arg_136_1, arg_136_2)
	if var_0_190 == nil then
		var_0_190 = 1

		var_0_6(var_0_194)

		var_0_194.start_at = arg_136_0.command_number
		var_0_194.last_offset_swap = 0
	end

	local var_136_0 = var_0_185.weapons[1].type == "grenade"
	local var_136_1 = var_0_1[entity.get_prop(arg_136_2, "m_iItemDefinitionIndex")]

	if arg_136_2 ~= var_0_193 and (not var_136_0 or var_0_194.thrown_at == nil) then
		var_0_185 = nil

		var_0_196(true)

		return
	end

	local var_136_2 = arg_136_0.command_number - var_0_194.start_at + 1
	local var_136_3 = var_0_185.movement_commands[var_136_2]

	if var_136_3 == nil and var_0_185.endless then
		var_136_3 = var_0_185.movement_commands[#var_0_185.movement_commands]
	end

	if var_136_3 == nil then
		var_0_185 = nil

		var_0_196(true)

		return
	end

	local var_136_4 = ui.get(var_0_118)
	local var_136_5 = var_0_185.air_strafe == true

	if var_136_4 ~= var_136_5 then
		var_0_195[var_0_118] = var_136_4

		ui.set(var_0_118, var_136_5)
	end

	local var_136_6 = ui.get(var_0_125)
	local var_136_7 = var_0_185.infinite_duck == true

	if var_136_6 ~= var_136_7 then
		var_0_195[var_0_125] = var_136_6

		ui.set(var_0_125, var_136_7)
	end

	if ui.get(var_0_120) then
		var_0_195[var_0_120] = true

		ui.set(var_0_120, false)
	end

	if ui.get(var_0_121) then
		var_0_195[var_0_121] = true

		ui.set(var_0_121, false)
	end

	if ui.get(var_0_122) ~= "Off" then
		var_0_195[var_0_122] = ui.get(var_0_122)

		ui.set(var_0_122, "Off")
	end

	local var_136_8 = ui.get(var_0_140)
	local var_136_9 = ui.get(var_0_127) and ui.get(var_0_128) ~= "Off"
	local var_136_10 = bit.band(entity.get_prop(arg_136_1, "m_fFlags"), var_0_37) == var_0_37
	local var_136_11 = var_0_7(entity.get_prop(arg_136_1, "m_vecAbsOrigin"))
	local var_136_12 = var_0_7(entity.get_prop(arg_136_1, "m_vecAbsVelocity"))

	if var_136_9 then
		var_0_198 = entity.get_prop(arg_136_1, "m_nWaterLevel")

		entity.set_prop(arg_136_1, "m_nWaterLevel", 2)

		var_0_197 = entity.get_prop(arg_136_1, "m_MoveType")

		entity.set_prop(arg_136_1, "m_MoveType", 1)
	end

	for iter_136_0, iter_136_1 in pairs(var_136_3) do
		local var_136_13 = true

		if iter_136_0 == "pitch" or iter_136_0 == "yaw" then
			var_136_13 = false
		elseif iter_136_0 == "in_use" and iter_136_1 == false then
			var_136_13 = false
		elseif iter_136_0 == "in_attack" or iter_136_0 == "in_attack2" then
			if var_136_0 and var_136_1.type == "grenade" then
				var_136_13 = true
			elseif iter_136_1 == false then
				var_136_13 = false
			end
		end

		if var_136_13 then
			arg_136_0[iter_136_0] = iter_136_1
		end
	end

	arg_136_0.move_yaw = var_136_3.yaw

	if var_136_8 == "Rage" and (var_136_0 or arg_136_0.in_attack == 0 and arg_136_0.in_attack2 == 0) and (not var_136_0 or var_136_0 and var_0_194.thrown_at == nil) then
		if arg_136_0.command_number - var_0_194.last_offset_swap > 6 then
			local var_136_14 = arg_136_0.yaw

			if var_136_9 and arg_136_0.in_use == 0 then
				var_0_194.set_pitch = true

				local var_136_15 = 180

				if ui.get(var_0_130) == "180" then
					var_136_15 = -ui.get(var_0_131) + 180
				end

				var_136_14 = arg_136_0.yaw - var_136_15

				if ui.get(var_0_129) == "At targets" then
					local var_136_16 = entity.get_players(true)
					local var_136_17
					local var_136_18 = 1 / 0
					local var_136_19
					local var_136_20 = var_0_7(client.camera_position())
					local var_136_21 = var_0_7(client.camera_angles())
					local var_136_22 = var_0_7(0, 0, 48)

					for iter_136_2 = 1, #var_136_16 do
						local var_136_23 = var_0_7(entity.get_prop(var_136_16[iter_136_2], "m_vecAbsOrigin")) + var_136_22
						local var_136_24 = var_136_20:to(var_136_23)
						local var_136_25 = var_136_21:dist2d(var_136_24)

						if var_136_25 < var_136_18 then
							local var_136_26

							var_136_26, var_136_18 = var_136_16[iter_136_2], var_136_25
							var_136_19 = var_136_24.y
						end
					end

					if var_136_19 ~= nil then
						var_136_14 = var_136_19 - var_136_15
					end
				end
			else
				var_0_194.set_pitch = false
			end

			local var_136_27, var_136_28 = var_0_53(0, var_136_14)
			local var_136_29 = 90
			local var_136_30

			for iter_136_3 = -180, 180, 45 do
				local var_136_31, var_136_32 = var_0_53(0, var_136_3.yaw + iter_136_3)
				local var_136_33 = math.abs(var_136_32 - var_136_28)

				if var_136_33 < var_136_29 then
					var_136_29 = var_136_33
					var_136_30 = iter_136_3
				end
			end

			if var_136_30 ~= var_0_194.last_offset then
				if var_0_8 then
					client.log("offset switched from ", var_0_194.last_offset, " to ", var_136_30)
				end

				var_0_194.last_offset = var_136_30
				var_0_194.last_offset_swap = arg_136_0.command_number
			end
		end

		if var_0_194.last_offset ~= nil then
			arg_136_0.yaw = var_136_3.yaw + var_0_194.last_offset

			if var_0_194.set_pitch then
				arg_136_0.pitch = 89
			end
		end
	end

	if var_136_8 ~= "Rage" then
		if var_136_9 then
			local var_136_34 = var_0_185.movement_commands[var_136_2 + 1] or var_136_3

			client.camera_angles(var_136_34.pitch, var_136_34.yaw)
		else
			client.camera_angles(var_136_3.pitch, var_136_3.yaw)

			if math.abs(arg_136_0.pitch - var_136_3.pitch) < 1e-05 and math.abs(arg_136_0.yaw - var_136_3.yaw) < 1e-05 then
				arg_136_0.pitch = var_136_3.pitch + 1e-05
			else
				arg_136_0.pitch = var_136_3.pitch
			end

			arg_136_0.yaw = var_136_3.yaw
		end

		if var_0_36:get_float() > 0 then
			var_0_192 = var_0_36:get_float()

			var_0_36:set_raw_float(0)
		end
	elseif var_136_8 == "Rage" and var_136_0 and var_136_1.type == "grenade" and var_0_66(arg_136_2, arg_136_0) then
		arg_136_0.pitch = var_136_3.pitch
		arg_136_0.yaw = var_136_3.yaw
		arg_136_0.allow_send_packet = false
		var_0_194.thrown_at = arg_136_0.command_number
	end

	if var_0_8 then
		client.log(string.format("cmd #%03d onground: %5s in_jump: %5s origin: %s velocity: %s", var_136_2, var_136_10, arg_136_0.in_jump == 1, var_136_11, var_136_12))
	end
end

local function var_0_203(arg_137_0, arg_137_1, arg_137_2)
	if var_0_185.type == "grenade" then
		var_0_201(arg_137_0, arg_137_1, arg_137_2)
	elseif var_0_185.type == "movement" then
		var_0_202(arg_137_0, arg_137_1, arg_137_2)
	end
end

local function var_0_204(arg_138_0)
	if var_0_197 ~= nil or var_0_198 ~= nil then
		local var_138_0 = entity.get_local_player()

		if var_0_198 ~= nil then
			entity.set_prop(var_138_0, "m_nWaterLevel", var_0_198)

			var_0_198 = false
		end

		if var_0_197 ~= nil then
			entity.set_prop(var_138_0, "m_MoveType", var_0_197)

			var_0_197 = nil
		end
	end
end

local function var_0_205(arg_139_0)
	local var_139_0 = ui.get(var_0_124) and (ui.get(var_0_132) and ui.get(var_0_133) or ui.get(var_0_134) and ui.get(var_0_135))

	ui.set(var_0_124, true)

	local var_139_1 = entity.get_local_player()
	local var_139_2 = var_0_7(entity.get_prop(var_139_1, "m_vecAbsOrigin"))
	local var_139_3 = ui.get(var_0_137)
	local var_139_4 = entity.get_player_weapon(var_139_1)
	local var_139_5 = entity.get_prop(var_139_1, "m_MoveType")

	if var_0_185 ~= nil then
		ui.set(var_0_124, false)
		var_0_203(arg_139_0, var_139_1, var_139_4)
	elseif var_0_184 ~= nil and var_139_3 and var_0_184.is_in_fov and var_0_184.is_position_correct then
		local var_139_6 = var_0_7(entity.get_prop(var_139_1, "m_vecAbsVelocity")):length()
		local var_139_7 = entity.get_prop(var_139_4, "m_bPinPulled") == 1

		if var_0_184.duckamount == 1 or var_0_183.has_only_duck then
			arg_139_0.in_duck = 1
		end

		ui.set(var_0_124, false)

		local var_139_8 = var_0_184.weapons[1].type == "grenade"
		local var_139_9 = arg_139_0.in_attack == 1 or arg_139_0.in_attack2 == 1

		if (var_0_184.type == "movement" and var_139_6 < 2 and (not var_139_8 or var_139_9) or var_0_184.type == "grenade" and var_139_7 and var_139_9 and var_139_6 < 2) and var_0_184.duckamount == entity.get_prop(var_139_1, "m_flDuckAmount") and not var_139_0 then
			var_0_185 = var_0_184
			var_0_190 = nil
			var_0_193 = var_139_4
			var_0_191 = arg_139_0.command_number

			var_0_203(arg_139_0, var_139_1, var_139_4)
		elseif not var_139_7 and (arg_139_0.in_attack == 1 or arg_139_0.in_attack2 == 1) then
			if var_0_184.throw_strength == 1 then
				arg_139_0.in_attack = 1
				arg_139_0.in_attack2 = 0
			elseif var_0_184.throw_strength == 0.5 then
				arg_139_0.in_attack = 1
				arg_139_0.in_attack2 = 1
			elseif var_0_184.throw_strength == 0 then
				arg_139_0.in_attack = 0
				arg_139_0.in_attack2 = 1
			end
		end
	elseif var_0_183 ~= nil and var_139_3 then
		local var_139_10 = var_0_184 ~= nil and var_0_184.is_in_fov and var_0_184.position or var_0_183.position_approach
		local var_139_11 = var_139_2:dist(var_139_10)
		local var_139_12 = var_139_2:dist2d(var_139_10)
		local var_139_13 = var_139_11

		if (var_139_12 < 0.5 and var_139_13 > 0.08 and var_139_13 < 5 or var_0_183.inaccurate_position and var_139_13 < 40) and var_139_5 ~= var_0_38 then
			var_139_13 = var_139_12
		end

		if (var_0_184 ~= nil and var_0_184.duckamount == 1 or var_0_183.has_only_duck) and var_139_13 < 10 then
			arg_139_0.in_duck = 1
		end

		if arg_139_0.forwardmove == 0 and arg_139_0.sidemove == 0 and arg_139_0.in_forward == 0 and arg_139_0.in_back == 0 and arg_139_0.in_moveleft == 0 and arg_139_0.in_moveright == 0 and (var_139_13 < 32 or var_139_5 == var_0_38 and var_139_12 < 20) and var_139_11 >= var_0_31 * 0.5 then
			if var_139_5 == var_0_38 then
				if ui.get(var_0_140) ~= "Rage" then
					return
				end

				arg_139_0.allow_send_packet = false

				if arg_139_0.chokedcommands < ui.get(var_0_126) then
					local var_139_14, var_139_15 = var_0_7(var_139_2.x, var_139_2.y, 0):to(var_0_7(var_139_10.x, var_139_10.y, 0)):angles()

					if var_139_15 == nil then
						return
					end

					local var_139_16 = var_0_7(entity.get_prop(var_139_1, "m_vecLadderNormal"))
					local var_139_17, var_139_18 = (-var_139_16):angles()

					if var_139_18 == nil then
						return
					end

					local var_139_19 = false
					local var_139_20 = var_139_16:vectors()

					var_139_20:normalize()

					local var_139_21 = -var_139_20 * 50
					local var_139_22 = var_139_2 - var_139_21
					local var_139_23 = var_139_22 + var_139_21 * 2
					local var_139_24 = (var_139_23 - var_139_22) / var_139_22:dist(var_139_23)
					local var_139_25 = var_139_22 + var_139_24 * (var_139_10 - var_139_22):dot(var_139_24)
					local var_139_26 = var_139_2:dist2d(var_139_25)
					local var_139_27 = math.min(1, var_139_26 / 5)

					if var_139_27 < 0.001 then
						var_139_27 = 0
					end

					local var_139_28, var_139_29 = var_0_53(0, var_139_15 - var_139_18)
					local var_139_30 = var_139_18 + (var_139_29 > 0 and -1 or 1) * var_139_27 * 40
					local var_139_31 = var_139_10.z - var_139_2.z
					local var_139_32 = var_139_27 > 0.2 and 0 or math.max(0, math.min(1, math.abs(var_139_31) / 5))

					if var_139_32 < 0.01 then
						var_139_32 = 0
					end

					if var_139_27 > 0 or var_139_32 > 0 then
						local var_139_33 = 45 + var_139_17 + var_139_32 * 45

						if arg_139_0.in_duck == 1 then
							local var_139_34 = math.min(1, var_139_27 * 100)

							var_139_32 = math.min(1, var_139_32 * 100)
						end

						arg_139_0.forwardmove = var_139_32 == 0 and -450 or var_139_31 > 0 and -450 or 450
						arg_139_0.sidemove = 0

						if var_139_19 then
							arg_139_0.yaw = arg_139_0.yaw - 180
							arg_139_0.pitch = -arg_139_0.pitch
							arg_139_0.forwardmove = -arg_139_0.forwardmove
							arg_139_0.sidemove = -arg_139_0.sidemove
						end

						arg_139_0.in_forward = arg_139_0.forwardmove > 0
						arg_139_0.in_back = arg_139_0.forwardmove < 0
						arg_139_0.in_moveright = arg_139_0.sidemove > 0
						arg_139_0.in_moveleft = arg_139_0.sidemove < 0
						arg_139_0.pitch, arg_139_0.yaw = var_0_53(var_139_33, var_139_30)
					end
				end
			else
				local var_139_35, var_139_36 = (var_139_10 + (var_139_10 - var_139_2):normalized() * 10 - var_139_2):angles()

				if var_139_36 == nil then
					return
				end

				arg_139_0.move_yaw = var_139_36
				arg_139_0.in_speed = 0
				arg_139_0.in_moveleft, arg_139_0.in_moveright = 0, 0
				arg_139_0.sidemove = 0

				if var_0_183.approach_accurate then
					arg_139_0.in_forward, arg_139_0.in_back = 1, 0
					arg_139_0.forwardmove = 450
				elseif var_139_13 > 14 then
					arg_139_0.forwardmove = 450
				else
					local var_139_37 = math.min(450, math.max(1.1 + entity.get_prop(var_139_1, "m_flDuckAmount") * 10, var_139_13 * 9))
					local var_139_38 = var_0_7(entity.get_prop(var_139_1, "m_vecAbsVelocity")):length2d()

					if var_139_38 >= math.min(250, var_139_37) + 15 then
						arg_139_0.forwardmove = 0
						arg_139_0.in_forward = 0
					else
						arg_139_0.forwardmove = math.max(6, var_139_38 >= math.min(250, var_139_37) and var_139_37 * 0.9 or var_139_37)
						arg_139_0.in_forward = 1
					end
				end
			end
		end
	end
end

local function var_0_207()
	local var_141_0 = ui.get(var_0_136)

	if var_141_0 then
		client.set_event_callback("paint", var_0_199)
		client.set_event_callback("setup_command", var_0_205)
		client.set_event_callback("run_command", var_0_204)
	else
		client.unset_event_callback("paint", var_0_199)
		client.unset_event_callback("setup_command", var_0_205)
		client.unset_event_callback("run_command", var_0_204)
		var_0_196(true)
		ui.set(var_0_124, true)
	end

	ui.set_visible(var_0_139, var_141_0)
	ui.set_visible(var_0_138, var_141_0)
	ui.set_visible(var_0_140, var_141_0)
	ui.set_visible(var_0_143, var_141_0)
	ui.set_visible(var_0_144.title, var_141_0)
	var_0_99()

	local var_141_1 = var_141_0 and ui.get(var_0_140)

	ui.set_visible(var_0_141, var_141_0 and var_141_1 == "Legit")
	ui.set_visible(var_0_142, var_141_0 and var_141_1 == "Legit")
end

ui.set_callback(var_0_136, var_0_207)
ui.set_callback(var_0_140, var_0_207)
var_0_207()
client.set_event_callback("level_init", function()
	var_0_165 = nil

	if var_0_164 then
		var_0_156()
	end

	var_0_6(var_0_167)
	var_0_6(var_0_168)
	var_0_6(var_0_169)
	var_0_99()
	var_0_103()

	if var_0_8 and var_0_8.create_map_patterns then
		local var_142_0 = globals.mapname()
		local var_142_1 = var_0_88()

		var_0_8.debug_text = "create_map_patterns progress: " .. var_0_8.create_map_patterns_index[globals.mapname()] .. " / " .. var_0_8.create_map_patterns_count

		if var_142_1 ~= nil then
			if var_0_89[var_142_1] ~= nil then
				local var_142_2 = "collision: " .. var_142_0 .. " has the same pattern as " .. var_0_89[var_142_1]

				var_0_8.debug_text = var_142_2

				error(var_142_2)

				return
			end

			client.log("created pattern for ", var_142_0, ": ", tostring(var_142_1))

			var_0_89[var_142_1] = var_142_0

			if var_0_8.create_map_patterns_next[var_142_0] ~= nil then
				client.log("If you can read this, the map ", var_0_8.create_map_patterns_next[var_142_0], " failed to load")
				client.delay_call(2, client.exec, "map ", var_0_8.create_map_patterns_next[var_142_0])
			else
				var_0_8.debug_text = "DONE!"

				client.log("Done!")
				client.log(var_0_8.inspect(var_0_89))
				client.log("failed: ", var_0_8.inspect(var_0_8.create_map_patterns_failed))

				var_0_8.create_map_patterns = false
			end
		else
			table.insert(var_0_8.create_map_patterns_failed, var_142_0)
			client.error_log("failed to create pattern for " .. var_142_0)

			var_0_8.debug_text = "failed to create pattern for " .. var_142_0
		end
	end
end)
client.set_event_callback("round_end", function()
	var_0_185 = nil

	var_0_196(true)
end)
client.set_event_callback("shutdown", function()
	for iter_144_0 = 1, #var_0_93.sources do
		if var_0_93.sources[iter_144_0].cleanup ~= nil then
			var_0_93.sources[iter_144_0]:cleanup()
		end
	end

	var_0_196(true)
	ui.set(var_0_124, true)
	database.write("helper", var_0_93)
end)
