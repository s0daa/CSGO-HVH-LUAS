local var_0_0 = require("gamesense/uilib")
local var_0_1 = require("gamesense/csgo_weapons")
local var_0_2 = {
	"-",
	"AWP",
	"SCAR20/G3SG1",
	"Scout",
	"M4/AK47",
	"Famas/Galil",
	"Aug/SG553",
	"M249",
	"Negev",
	"Mag7/SawedOff",
	"Nova",
	"XM1014",
	"MP9/Mac10",
	"UMP45",
	"PPBizon",
	"MP7"
}
local var_0_3 = {
	"-",
	"CZ75/Tec9/FiveSeven",
	"P250",
	"Deagle/Revolver",
	"Dualies"
}
local var_0_4 = {
	"HE Grenade",
	"Molotov",
	"Smoke",
	"Flash",
	"Flash",
	"Decoy"
}
local var_0_5 = {
	"Armor",
	"Helmet",
	"Zeus",
	"Defuser"
}
local var_0_6 = {
	["-"] = 0,
	AWP = var_0_1.weapon_awp.in_game_price,
	["SCAR20/G3SG1"] = var_0_1.weapon_scar20.in_game_price,
	Scout = var_0_1.weapon_ssg08.in_game_price,
	["M4/AK47"] = var_0_1.weapon_m4a1.in_game_price,
	["Famas/Galil"] = var_0_1.weapon_famas.in_game_price,
	["Aug/SG553"] = var_0_1.weapon_aug.in_game_price,
	M249 = var_0_1.weapon_m249.in_game_price,
	Negev = var_0_1.weapon_negev.in_game_price,
	["Mag7/SawedOff"] = var_0_1.weapon_mag7.in_game_price,
	Nova = var_0_1.weapon_nova.in_game_price,
	XM1014 = var_0_1.weapon_xm1014.in_game_price,
	["MP9/Mac10"] = var_0_1.weapon_mp9.in_game_price,
	UMP45 = var_0_1.weapon_ump45.in_game_price,
	PPBizon = var_0_1.weapon_bizon.in_game_price,
	MP7 = var_0_1.weapon_mp7.in_game_price,
	["CZ75/Tec9/FiveSeven"] = var_0_1.weapon_tec9.in_game_price,
	P250 = var_0_1.weapon_p250.in_game_price,
	["Deagle/Revolver"] = var_0_1.weapon_deagle.in_game_price,
	Dualies = var_0_1.weapon_elite.in_game_price,
	["HE Grenade"] = var_0_1.weapon_hegrenade.in_game_price,
	Molotov = var_0_1.weapon_molotov.in_game_price,
	Smoke = var_0_1.weapon_smokegrenade.in_game_price,
	Flash = var_0_1.weapon_flashbang.in_game_price,
	Decoy = var_0_1.weapon_decoy.in_game_price,
	Armor = var_0_1.item_kevlar.in_game_price,
	Helmet = var_0_1.item_assaultsuit.in_game_price,
	Zeus = var_0_1.weapon_taser.in_game_price,
	Defuser = var_0_1.item_cutters.in_game_price
}
local var_0_7 = {
	Smoke = "buy smokegrenade;",
	Molotov = "buy molotov;",
	["HE Grenade"] = "buy hegrenade;",
	Dualies = "buy elite;",
	["Deagle/Revolver"] = "buy deagle;",
	P250 = "buy p250;",
	["CZ75/Tec9/FiveSeven"] = "buy tec9;",
	MP7 = "buy mp7;",
	PPBizon = "buy bizon;",
	UMP45 = "buy ump45;",
	["MP9/Mac10"] = "buy mp9;",
	XM1014 = "buy xm1014;",
	Nova = "buy nova;",
	["Mag7/SawedOff"] = "buy mag7;",
	Negev = "buy negev;",
	M249 = "buy m249;",
	["Aug/SG553"] = "buy aug;",
	["Famas/Galil"] = "buy famas;",
	["M4/AK47"] = "buy m4a1;",
	Scout = "buy ssg08;",
	["SCAR20/G3SG1"] = "buy scar20;",
	AWP = "buy awp;",
	["-"] = "",
	Defuser = "buy defuser;",
	Zeus = "buy taser;",
	Helmet = "buy vesthelm;",
	Armor = "buy vest;",
	Decoy = "buy decoy;",
	Flash = "buy flashbang;"
}
local var_0_8 = "MISC"
local var_0_9 = "Miscellaneous"
local var_0_10 = var_0_0.new_checkbox(var_0_8, var_0_9, "Automatic purchase")
local var_0_11 = var_0_0.new_checkbox(var_0_8, var_0_9, "Hide purchase")
local var_0_12 = var_0_0.new_checkbox(var_0_8, var_0_9, "Fast purchase")
local var_0_13 = {
	primary = var_0_0.new_combobox(var_0_8, var_0_9, "Primary", var_0_2),
	secondary = var_0_0.new_combobox(var_0_8, var_0_9, "Secondary", var_0_3),
	grenades = var_0_0.new_multiselect(var_0_8, var_0_9, "Grenades", var_0_4),
	utilities = var_0_0.new_multiselect(var_0_8, var_0_9, "Utilities", var_0_5)
}
local var_0_14 = var_0_0.new_checkbox(var_0_8, var_0_9, "Cost based")
local var_0_15 = var_0_0.new_slider(var_0_8, var_0_9, "Balance override", 0, 16000, 0, true, "$", 1, {
	[0] = "Auto"
})
local var_0_16 = {
	primary = var_0_0.new_combobox(var_0_8, var_0_9, "Backup Primary", var_0_2),
	secondary = var_0_0.new_combobox(var_0_8, var_0_9, "Backup Secondary", var_0_3),
	grenades = var_0_0.new_multiselect(var_0_8, var_0_9, "Backup Grenades", var_0_4),
	utilities = var_0_0.new_multiselect(var_0_8, var_0_9, "Backup Utilities", var_0_5)
}

local function var_0_17()
	var_0_11.vis = var_0_10.state

	local var_1_0 = var_0_10.state and not var_0_11.state

	var_0_12.vis = var_1_0

	for iter_1_0, iter_1_1 in pairs(var_0_13) do
		iter_1_1.vis = var_1_0
	end

	var_0_14.vis = var_1_0 and not var_0_12.state

	local var_1_1 = var_1_0 and var_0_14.state and not var_0_12.state

	var_0_15.vis = var_1_1

	for iter_1_2, iter_1_3 in pairs(var_0_16) do
		iter_1_3.vis = var_1_1
	end
end

var_0_10:add_callback(var_0_17)
var_0_12:add_callback(var_0_17)
var_0_11:add_callback(var_0_17)
var_0_14:add_callback(var_0_17)

local var_0_18 = {}

local function var_0_19(arg_2_0)
	local var_2_0 = arg_2_0.value

	if #var_2_0 > 4 then
		arg_2_0.value = var_0_18[arg_2_0.name]
	else
		var_0_18[arg_2_0.name] = var_2_0
	end
end

var_0_13.grenades:add_callback(var_0_19)
var_0_16.grenades:add_callback(var_0_19)

local var_0_20 = ""
local var_0_21 = ""
local var_0_22 = 0

local function var_0_23()
	var_0_20 = ""
	var_0_21 = ""
	var_0_22 = 0
	var_0_20 = var_0_20 .. var_0_7[var_0_13.secondary.value]
	var_0_22 = var_0_22 + var_0_6[var_0_13.secondary.value]

	for iter_3_0, iter_3_1 in ipairs(var_0_13.utilities.value) do
		var_0_20 = var_0_20 .. var_0_7[iter_3_1]
		var_0_22 = var_0_22 + var_0_6[iter_3_1]
	end

	var_0_20 = var_0_20 .. var_0_7[var_0_13.primary.value]
	var_0_22 = var_0_22 + var_0_6[var_0_13.primary.value]

	for iter_3_2, iter_3_3 in ipairs(var_0_13.grenades.value) do
		var_0_20 = var_0_20 .. var_0_7[iter_3_3]
		var_0_22 = var_0_22 + var_0_6[iter_3_3]
	end

	var_0_21 = var_0_21 .. var_0_7[var_0_16.secondary.value]

	for iter_3_4, iter_3_5 in ipairs(var_0_16.utilities.value) do
		var_0_21 = var_0_21 .. var_0_7[iter_3_5]
	end

	var_0_21 = var_0_21 .. var_0_7[var_0_16.primary.value]

	for iter_3_6, iter_3_7 in ipairs(var_0_16.grenades.value) do
		var_0_21 = var_0_21 .. var_0_7[iter_3_7]
	end
end

for iter_0_0, iter_0_1 in pairs(var_0_13) do
	iter_0_1:add_callback(var_0_23)
end

for iter_0_2, iter_0_3 in pairs(var_0_16) do
	iter_0_3:add_callback(var_0_23)
end

local function var_0_24(arg_4_0, arg_4_1)
	client.exec(arg_4_1 or "")

	return arg_4_0 > 0 and client.delay_call(0.0001, var_0_24, arg_4_0 - 1)
end

local var_0_25 = false
local var_0_26 = false

local function var_0_27()
	if var_0_14.state then
		local var_5_0 = entity.get_prop(entity.get_local_player(), "m_iAccount")
		local var_5_1 = var_0_15.value

		if var_5_1 == 0 then
			var_5_1 = var_0_22
		end

		if var_5_0 < var_5_1 then
			var_0_24(16, var_0_21)
		else
			var_0_24(16, var_0_20)
		end
	else
		var_0_24(16, var_0_20)
	end

	var_0_25 = true

	client.unset_event_callback("net_update_end", var_0_27)
end

local function var_0_28()
	var_0_26 = true
	var_0_25 = false

	if var_0_12.state then
		client.delay_call(0.3 - (client.latency() + totime(8)), var_0_24, 16, var_0_20)
	end
end

local function var_0_29()
	var_0_26 = false

	if not var_0_12.state then
		client.delay_call(0, client.set_event_callback, "net_update_end", var_0_27)
	end
end

local function var_0_30(arg_8_0)
	if not var_0_26 and client.userid_to_entindex(arg_8_0.userid) == entity.get_local_player() then
		var_0_27()
	end
end

local function var_0_31(arg_9_0)
	if not var_0_25 and client.userid_to_entindex(arg_9_0.userid) == entity.get_local_player() and arg_9_0.canbuy then
		var_0_27()
	end
end

var_0_10:add_event_callback("enter_buyzone", var_0_31)
var_0_10:add_event_callback("cs_pre_restart", var_0_28)
var_0_10:add_event_callback("round_poststart", var_0_29)
var_0_10:add_event_callback("player_spawn", var_0_30)
var_0_10:invoke()
