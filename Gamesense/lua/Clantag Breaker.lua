local var_0_0 = require("gamesense/inspect")
local var_0_1 = globals.chokedcommands
local var_0_2 = entity.get_local_player
local var_0_3 = entity.get_player_resource
local var_0_4 = entity.get_prop
local var_0_5 = table.insert
local var_0_6 = client.set_clan_tag

local function var_0_7()
	return client.random_int(0, 1) == 1
end

local function var_0_8(arg_2_0, arg_2_1)
	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		if iter_2_1 == arg_2_1 then
			return true
		end
	end

	return false
end

local function var_0_9(arg_3_0, arg_3_1)
	if not var_0_8(arg_3_0, arg_3_1) then
		var_0_5(arg_3_0, arg_3_1)
	end
end

local var_0_10 = {
	"\t\t\t  f",
	"\t\t\t fa",
	"\t\t\tfat",
	"\t\t   fata",
	"\t\t  fatal",
	"\t\t fatali",
	"\t\tfatalit",
	"\t   fatality",
	"\t  fatality ",
	"\t fatality  ",
	"\tfatality   ",
	"   fatality\t",
	"  fatality\t ",
	" fatality\t  ",
	"fatality\t   ",
	"atality\t\t",
	"tality\t\t ",
	"ality\t\t  ",
	"lity\t\t   ",
	"ity\t\t\t",
	"ty\t\t\t ",
	"y\t\t\t  ",
	"AIMWARE.NET ",
	"IMWARE.NET A",
	"MWARE.NET AI",
	"WARE.NET AIM",
	"ARE.NET AIMW",
	"RE.NET AIMWA",
	"E.NET AIMWAR",
	".NET AIMWARE",
	"NET AIMWARE.",
	"ET AIMWARE.N",
	"T AIMWARE.NE",
	" AIMWARE.NET",
	"AIMWARE.NET ",
	"AIMWARE.NET  ",
	"I\t\t ",
	"IN\t\t",
	"INI\t   ",
	"INIU\t  ",
	"INIUR\t ",
	"INIURI\t",
	"INIURIA   ",
	"INIURIA.  ",
	"INIURIA.U ",
	"INIURIA.US",
	"INIURIA.US",
	" NIURIA.US",
	"  IURIA.US",
	"   URIA.US",
	"\tRIA.US",
	"\t IA.US",
	"\t  A.US",
	"\t   .US",
	"\t\tUS",
	"\t\t S",
	"\t\t  ",
	"\t\t\t  g",
	"\t\t\t ga",
	"\t\t\tgam",
	"\t\t   game",
	"\t\t  games",
	"\t\t gamese",
	"\t\tgamesen",
	"\t   gamesens",
	"\t  gamesense",
	"\t gamesense ",
	"\tgamesense  ",
	"   gamesense   ",
	"  gamesense\t",
	" gamesense\t ",
	"gamesense\t  ",
	"amesense\t   ",
	"mesense\t\t",
	"esense\t\t ",
	"sense\t\t  ",
	"ense\t\t   ",
	"nse\t\t\t",
	"se\t\t\t ",
	"e\t\t\t  ",
	"\t\t\t  a",
	"\t\t\t aq",
	"\t\t\taqu",
	"\t\t   aqua",
	"\t\t  aquah",
	"\t\t aquaho",
	"\t\taquahol",
	"\t   aquaholi",
	"\t  aquaholic",
	"\t aquaholic ",
	"\taquaholic  ",
	"   aquaholic   ",
	"  aquaholic\t",
	" aquaholic\t ",
	"aquaholic\t  ",
	"quaholic\t   ",
	"uaholic\t\t",
	"aholic\t\t ",
	"holic\t\t  ",
	"olic\t\t   ",
	"lic\t\t\t",
	"ic\t\t\t ",
	"c\t\t\t  ",
	"\t\t\t  n",
	"\t\t\t ni",
	"\t\t\tnix",
	"\t\t   nixw",
	"\t\t  nixwa",
	"\t\t nixwar",
	"\t\tnixware",
	"\t   nixware.",
	"\t  nixware.c",
	"\t nixware.cc",
	"\tnixware.cc",
	"   nixware.c ",
	"  nixware.  ",
	" nixware   ",
	"nixwar\t",
	"nixwa\t ",
	"nixw\t  ",
	"nix\t   ",
	"ni\t\t",
	"n\t\t ",
	"N",
	"N3",
	"Ne",
	"Ne\\",
	"Ne\\/",
	"Nev",
	"Nev3",
	"Neve",
	"Neve|",
	"Neve|2",
	"Never",
	"Never|",
	"Never|_",
	"Neverl",
	"Neverl0",
	"Neverlo",
	"Neverlo5",
	"Neverlos",
	"Neverlos3",
	"Neverlose",
	"Neverlose.",
	"Neverlose.<",
	"Neverlose.c",
	"Neverlose.c<",
	"Neverlose.cc",
	"Neverlose.cc ",
	"Neverlose.cc ",
	"Neverlose.cc",
	"Neverlose.c<",
	"Neverlose.c",
	"Neverlose.<",
	"Neverlose.",
	"Neverlose",
	"Neverlos3",
	"Neverlos",
	"Neverlo5",
	"Neverlo",
	"Neverl0",
	"Neverl",
	"Never|_",
	"Never|",
	"Never",
	"Neve|2",
	"Neve|",
	"Neve",
	"Nev3",
	"Nev",
	"Ne\\/",
	"Ne\\",
	"Ne",
	"N3",
	"N",
	"onetap.su ",
	"netap.su o",
	"etap.su on",
	"tap.su one",
	"ap.su onet",
	"p.su oneta",
	".su onetap",
	"su onetap.",
	"u onetap.s",
	" onetap.su",
	"N ",
	"No ",
	"Nov",
	"Novo",
	"Novol",
	"Novoli",
	"Novolin",
	"Novoline",
	"Novolineh",
	"Novolineho",
	"Novolinehoo",
	"Novolinehook",
	"Novolinehook",
	"⌛ ",
	"⌛ p",
	"⌛ pr",
	"⌛ pri",
	"⌛ prim",
	"⌛ primo",
	"⌛ primor",
	"⌛ primord",
	"⌛ primordi",
	"⌛ primordia",
	"⌛ primordial",
	"⌛ primordial",
	"⌛ primordia",
	"⌛ primordi",
	"⌛ primord",
	"⌛ primor",
	"⌛ primo",
	"⌛ prim",
	"⌛ pri",
	"⌛ pr",
	"⌛ p",
	"⌛ ",
	"n3m3sis",
	"nemesis",
	"n3m3sis",
	"nemesis",
	"n3m3sis",
	"nemesis",
	"\t\tga",
	"\t   gam",
	"\t  game",
	"\t games",
	"\tgamese",
	"   gamesen",
	"  gamesens",
	" gamesense",
	" gamesense ",
	" amesense  ",
	" mesense   ",
	" esense\t",
	" sense\t ",
	" ense\t  ",
	" nse\t   ",
	" se\t\t",
	" e\t\t "
}

;(function()
	for iter_4_0 = 1, #var_0_10 do
		local var_4_0 = var_0_10[iter_4_0]
		local var_4_1 = var_4_0:len()
		local var_4_2 = {}

		for iter_4_1 = 1, var_4_1 do
			local var_4_3 = var_4_0:sub(iter_4_1, iter_4_1)

			var_4_2[iter_4_1] = var_0_7() and var_4_3:upper() or var_4_3:lower()
		end

		var_0_10[iter_4_0] = table.concat(var_4_2)
	end
end)()

local var_0_11 = {}

;(function()
	for iter_5_0 = 1, #var_0_10 do
		local var_5_0 = var_0_10[iter_5_0]
		local var_5_1 = var_5_0:len()
		local var_5_2 = {}

		for iter_5_1 = 1, var_5_1 do
			var_5_2[iter_5_1] = var_5_0:sub(iter_5_1, iter_5_1):lower()
		end

		var_0_11[iter_5_0] = table.concat(var_5_2)
	end
end)()

local var_0_12 = 1
local var_0_13 = {}

local function var_0_14()
	local var_6_0 = var_0_2()
	local var_6_1 = var_0_3()
	local var_6_2 = var_0_4(var_6_1, "m_szClan", var_6_0)
	local var_6_3 = var_0_1() == 0

	if var_0_12 >= #var_0_10 then
		var_0_12 = 1
	end

	local var_6_4 = var_0_10[var_0_12]

	if var_6_3 then
		var_0_6(var_6_4)

		local var_6_5 = var_6_4:lower()
		local var_6_6 = var_6_2:lower()

		if var_6_6 == var_6_5 then
			var_0_9(var_0_13, var_6_6)

			var_0_12 = var_0_12 + 1
		end
	end

	local var_6_7 = 1

	for iter_6_0, iter_6_1 in pairs(var_0_11) do
		if var_0_8(var_0_13, iter_6_1) then
			var_6_7 = var_6_7 + 1
		end
	end

	if var_6_7 == #var_0_11 then
		phase1 = false
	end
end

ui.set_callback(ui.new_checkbox("LUA", "B", "Break Clantags"), function(arg_7_0)
	if ui.get(arg_7_0) then
		client.set_event_callback("paint", var_0_14)
	else
		client.unset_event_callback("paint", var_0_14)
	end
end)
client.set_event_callback("level_init", function()
	var_0_12 = 1
	var_0_13 = {}
end)
