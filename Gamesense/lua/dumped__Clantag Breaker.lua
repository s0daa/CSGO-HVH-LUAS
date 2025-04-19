slot0 = require("gamesense/inspect")
slot1 = globals.chokedcommands
slot2 = entity.get_local_player
slot3 = entity.get_player_resource
slot4 = entity.get_prop
slot5 = table.insert
slot6 = client.set_clan_tag

function slot7()
	return client.random_int(0, 1) == 1
end

function slot8(slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		if slot6 == slot1 then
			return true
		end
	end

	return false
end

function slot9(slot0, slot1)
	if not uv0(slot0, slot1) then
		uv1(slot0, slot1)
	end
end

slot10 = {
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

function ()
	for slot3 = 1, #uv0 do
		for slot10 = 1, uv0[slot3]:len() do
			slot11 = slot4:sub(slot10, slot10)
		end

		uv0[slot3] = table.concat({
			[slot10] = uv1() and slot11:upper() or slot11:lower()
		})
	end
end()

slot12 = {}

function ()
	for slot3 = 1, #uv0 do
		for slot10 = 1, uv0[slot3]:len() do
		end

		uv1[slot3] = table.concat({
			[slot10] = slot4:sub(slot10, slot10):lower()
		})
	end
end()

slot14 = 1
slot15 = {}

function slot16()
	slot2 = uv2(uv1(), "m_szClan", uv0())
	slot3 = uv3() == 0

	if uv4 >= #uv5 then
		uv4 = 1
	end

	slot4 = uv5[uv4]

	if slot3 then
		uv6(slot4)

		if slot2:lower() == slot4:lower() then
			uv7(uv8, slot2)

			uv4 = uv4 + 1
		end
	end

	for slot9, slot10 in pairs(uv9) do
		if uv10(uv8, slot10) then
			slot5 = 1 + 1
		end
	end

	if slot5 == #uv9 then
		phase1 = false
	end
end

ui.set_callback(ui.new_checkbox("LUA", "B", "Break Clantags"), function (slot0)
	if ui.get(slot0) then
		client.set_event_callback("paint", uv0)
	else
		client.unset_event_callback("paint", uv0)
	end
end)
client.set_event_callback("level_init", function ()
	uv0 = 1
	uv1 = {}
end)
