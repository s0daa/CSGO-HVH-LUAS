slot0 = require("gamesense/uilib")
slot1 = require("gamesense/csgo_weapons")
slot2 = {
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
slot3 = {
	"-",
	"CZ75/Tec9/FiveSeven",
	"P250",
	"Deagle/Revolver",
	"Dualies"
}
slot4 = {
	"HE Grenade",
	"Molotov",
	"Smoke",
	"Flash",
	"Flash",
	"Decoy"
}
slot5 = {
	"Armor",
	"Helmet",
	"Zeus",
	"Defuser"
}
slot6 = {
	["-"] = 0,
	AWP = slot1.weapon_awp.in_game_price,
	["SCAR20/G3SG1"] = slot1.weapon_scar20.in_game_price,
	Scout = slot1.weapon_ssg08.in_game_price,
	["M4/AK47"] = slot1.weapon_m4a1.in_game_price,
	["Famas/Galil"] = slot1.weapon_famas.in_game_price,
	["Aug/SG553"] = slot1.weapon_aug.in_game_price,
	M249 = slot1.weapon_m249.in_game_price,
	Negev = slot1.weapon_negev.in_game_price,
	["Mag7/SawedOff"] = slot1.weapon_mag7.in_game_price,
	Nova = slot1.weapon_nova.in_game_price,
	XM1014 = slot1.weapon_xm1014.in_game_price,
	["MP9/Mac10"] = slot1.weapon_mp9.in_game_price,
	UMP45 = slot1.weapon_ump45.in_game_price,
	PPBizon = slot1.weapon_bizon.in_game_price,
	MP7 = slot1.weapon_mp7.in_game_price,
	["CZ75/Tec9/FiveSeven"] = slot1.weapon_tec9.in_game_price,
	P250 = slot1.weapon_p250.in_game_price,
	["Deagle/Revolver"] = slot1.weapon_deagle.in_game_price,
	Dualies = slot1.weapon_elite.in_game_price,
	["HE Grenade"] = slot1.weapon_hegrenade.in_game_price,
	Molotov = slot1.weapon_molotov.in_game_price,
	Smoke = slot1.weapon_smokegrenade.in_game_price,
	Flash = slot1.weapon_flashbang.in_game_price,
	Decoy = slot1.weapon_decoy.in_game_price,
	Armor = slot1.item_kevlar.in_game_price,
	Helmet = slot1.item_assaultsuit.in_game_price,
	Zeus = slot1.weapon_taser.in_game_price,
	Defuser = slot1.item_cutters.in_game_price
}
slot7 = {
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
	Zeus = "buy taser;",
	Defuser = "buy defuser;",
	Helmet = "buy vesthelm;",
	Armor = "buy vest;",
	Decoy = "buy decoy;",
	Flash = "buy flashbang;",
	Smoke = "buy smokegrenade;",
	Molotov = "buy molotov;",
	["HE Grenade"] = "buy hegrenade;",
	Dualies = "buy elite;",
	["Deagle/Revolver"] = "buy deagle;",
	P250 = "buy p250;",
	["CZ75/Tec9/FiveSeven"] = "buy tec9;",
	MP7 = "buy mp7;",
	PPBizon = "buy bizon;",
	UMP45 = "buy ump45;"
}
slot8 = "MISC"
slot9 = "Miscellaneous"
slot13 = {
	primary = slot0.new_combobox(slot8, slot9, "Primary", slot2),
	secondary = slot0.new_combobox(slot8, slot9, "Secondary", slot3),
	grenades = slot0.new_multiselect(slot8, slot9, "Grenades", slot4),
	utilities = slot0.new_multiselect(slot8, slot9, "Utilities", slot5)
}
slot15 = slot0.new_slider(slot8, slot9, "Balance override", 0, 16000, 0, true, "$", 1, {
	[0] = "Auto"
})

function slot17()
	uv0.vis = uv1.state
	uv2.vis = uv1.state and not uv0.state

	for slot4, slot5 in pairs(uv3) do
		slot5.vis = slot0
	end

	uv4.vis = slot0 and not uv2.state
	uv5.vis = slot0 and uv4.state and not uv2.state

	for slot5, slot6 in pairs(uv6) do
		slot6.vis = slot1
	end
end

slot0.new_checkbox(slot8, slot9, "Automatic purchase"):add_callback(slot17)
slot0.new_checkbox(slot8, slot9, "Fast purchase"):add_callback(slot17)
slot0.new_checkbox(slot8, slot9, "Hide purchase"):add_callback(slot17)
slot0.new_checkbox(slot8, slot9, "Cost based"):add_callback(slot17)

slot18 = {}

function slot19(slot0)
	if #slot0.value > 4 then
		slot0.value = uv0[slot0.name]
	else
		uv0[slot0.name] = slot1
	end
end

slot13.grenades:add_callback(slot19)
({
	primary = slot0.new_combobox(slot8, slot9, "Backup Primary", slot2),
	secondary = slot0.new_combobox(slot8, slot9, "Backup Secondary", slot3),
	grenades = slot0.new_multiselect(slot8, slot9, "Backup Grenades", slot4),
	utilities = slot0.new_multiselect(slot8, slot9, "Backup Utilities", slot5)
}).grenades:add_callback(slot19)

slot20 = ""
slot21 = ""
slot22 = 0

for slot27, slot28 in pairs(slot13) do
	slot28:add_callback(function ()
		uv0 = ""
		uv1 = ""
		uv2 = 0
		uv0 = uv0 .. uv3[uv4.secondary.value]
		uv2 = uv2 + uv5[uv4.secondary.value]

		for slot3, slot4 in ipairs(uv4.utilities.value) do
			uv0 = uv0 .. uv3[slot4]
			uv2 = uv2 + uv5[slot4]
		end

		uv0 = uv0 .. uv3[uv4.primary.value]
		uv2 = uv2 + uv5[uv4.primary.value]

		for slot3, slot4 in ipairs(uv4.grenades.value) do
			uv0 = uv0 .. uv3[slot4]
			uv2 = uv2 + uv5[slot4]
		end

		uv1 = uv1 .. uv3[uv6.secondary.value]

		for slot3, slot4 in ipairs(uv6.utilities.value) do
			uv1 = uv1 .. uv3[slot4]
		end

		uv1 = uv1 .. uv3[uv6.primary.value]

		for slot3, slot4 in ipairs(uv6.grenades.value) do
			uv1 = uv1 .. uv3[slot4]
		end
	end)
end

for slot27, slot28 in pairs(slot16) do
	slot28:add_callback(slot23)
end

function slot24(slot0, slot1)
	client.exec(slot1 or "")

	return slot0 > 0 and client.delay_call(0.0001, uv0, slot0 - 1)
end

slot25 = false
slot26 = false

function slot27()
	if uv0.state then
		slot0 = entity.get_prop(entity.get_local_player(), "m_iAccount")

		if uv1.value == 0 then
			slot1 = uv2
		end

		if slot0 < slot1 then
			uv3(16, uv4)
		else
			uv3(16, uv5)
		end
	else
		uv3(16, uv5)
	end

	uv6 = true

	client.unset_event_callback("net_update_end", uv7)
end

slot10:add_event_callback("enter_buyzone", function (slot0)
	if not uv0 and client.userid_to_entindex(slot0.userid) == entity.get_local_player() and slot0.canbuy then
		uv1()
	end
end)
slot10:add_event_callback("cs_pre_restart", function ()
	uv0 = true
	uv1 = false

	if uv2.state then
		client.delay_call(0.3 - (client.latency() + totime(8)), uv3, 16, uv4)
	end
end)
slot10:add_event_callback("round_poststart", function ()
	uv0 = false

	if not uv1.state then
		client.delay_call(0, client.set_event_callback, "net_update_end", uv2)
	end
end)
slot10:add_event_callback("player_spawn", function (slot0)
	if not uv0 and client.userid_to_entindex(slot0.userid) == entity.get_local_player() then
		uv1()
	end
end)
slot10:invoke()
