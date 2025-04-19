slot0 = false
slot1 = false
slot2 = false
slot3 = false
slot4 = false
slot5 = false
slot6 = false
slot7 = false
slot8 = false
slot9 = true
slot10 = ui.get
slot11 = ui.set
slot12 = ui.reference
slot13 = ui.new_checkbox
slot15 = ui.new_combobox
slot16 = ui.new_listbox
slot18 = ui.set_visible
slot19 = ui.set_callback
slot20 = client.set_event_callback
slot21 = client.unset_event_callback
slot23 = client.userid_to_entindex
slot24 = client.delay_call
slot25 = client.exec
slot26 = entity.get_local_player
slot27 = entity.get_prop
slot28 = globals.mapname
slot29 = string.rep
slot30 = string.len
slot31 = string.sub
slot32 = slot12("MISC", "Miscellaneous", "Steal player name")
slot33 = slot12("MISC", "Miscellaneous", "Clan tag spammer")
slot34 = client.set_clan_tag
slot35 = cvar.name:get_string()

function slot36(slot0)
	cvar.name:set_string(slot0)
end

function slot37(slot0, slot1)
	for slot5 = 1, #slot0 do
		if slot0[slot5] == slot1 then
			return true
		end
	end

	return false
end

slot20("player_connect_full", function (slot0)
	if uv0(slot0.userid) == uv1() and uv2() ~= nil then
		uv3 = true
	end
end)

slot38 = {
	" ",
	" \t",
	" "
}
slot39 = {
	["Restricted (Pruple)"] = "",
	["Covert (Red)"] = "",
	["Mil spec (DarkBlue)"] = "",
	["Contraband (Orangeish)"] = "",
	["Industrial (LightBlue)"] = "",
	["Classified (PinkishPurple)"] = ""
}
slot40 = {
	[1.0] = "received in a trade: ",
	[2.0] = "has opened a container and found: "
}
slot42 = {
	"Bayonet",
	"Butterfly Knife",
	"Falchion Knife",
	"Flip Knife",
	"Gut Knife",
	"Huntsman Knife",
	"Karambit",
	"M9 Bayonet",
	"Shadow Daggers",
	"Bowie Knife",
	"Ursus Knife",
	"Navaja Knife",
	"Stiletto Knife",
	"Talon Knife",
	"Classic Knife",
	"Skeleton Knife",
	"Paracord Knife",
	"Survival Knife",
	"Nomad Knife"
}
slot45 = slot13("LUA", "A", "Enable Skin-Name")
slot46 = slot13("LUA", "A", "CleanChat on initial change")
slot49 = slot16("LUA", "A", "Weapons Extended", {
	"AK-47",
	"AUG",
	"AWP",
	"CZ75-Auto",
	"Desert Eagle",
	"Dual Berettas",
	"FAMAS",
	"Five-SeveN",
	"G3SG1",
	"Galil AR",
	"Glock-18",
	"M4A1-S",
	"M4A4",
	"M249",
	"MAC-10",
	"MAG-7",
	"MP5-SD",
	"MP7",
	"MP9",
	"Negev",
	"Nova",
	"P90",
	"P250",
	"P2000",
	"PP-Bizon",
	"R8 Revolver",
	"Sawed-Off",
	"SCAR-20",
	"SG 553",
	"SSG 08",
	"Tec-9",
	"UMP-45",
	"USP-S",
	"XM1014",
	"Bayonet",
	"Bowie Knife",
	"Butterfly Knife",
	"Classic Knife",
	"Falchion Knife",
	"Flip Knife",
	"Gut Knife",
	"Huntsman Knife",
	"Karambit",
	"M9 Bayonet",
	"Navaja Knife",
	"Nomad Knife",
	"Paracord Knife",
	"Shadow Daggers",
	"Skeleton Knife",
	"Stiletto Knife",
	"Survival Knife",
	"Talon Knife",
	"Ursus Knife"
})
slot50 = slot15("LUA", "A", "Drop Rarity/Color", "Industrial (LightBlue)", "Mil spec (DarkBlue)", "Restricted (Pruple)", "Classified (PinkishPurple)", "Covert (Red)", "Contraband (Orangeish)")
slot51 = ui.new_label("LUA", "A", "Skin Name")
slot52 = ui.new_textbox("LUA", "A", "Skin")
slot53 = slot16("LUA", "A", "Skins Extended", {
	"Abyss",
	"Acheron",
	"Acid Etched",
	"Acid Fade",
	"Acid Wash",
	"Aerial",
	"Afterimage",
	"Agent",
	"Airlock",
	"Akihabara Accept",
	"Akoben",
	"Aloha",
	"Amber Fade",
	"Amber Slipstream",
	"Angry Mob",
	"Anodized Gunmetal",
	"Arctic Camo",
	"Arctic Wolf",
	"Aristocrat",
	"Armor Core",
	"Army Mesh",
	"Arym Recon",
	"Army Sheen",
	"Ash Wood",
	"Asiimov",
	"Assault",
	"Asterion",
	"Astral Jörmungandr",
	"Atheris",
	"Atlas",
	"Atomic Alloy",
	"Autotronic",
	"Avalanche",
	"Aztec",
	"Azure Zebra",
	"BOOM",
	"Balance",
	"Bamboo Forest",
	"Bamboo Garden",
	"Bamboo Print",
	"Bamboo Shadow",
	"Bamboozle",
	"Banana Leaf",
	"Baroque Orange",
	"Baroque Purple",
	"Baroque Red",
	"Barricade",
	"Basilisk",
	"Bengal Tiger",
	"Big Iron",
	"Bioleak",
	"Black Laminate",
	"Black Limba",
	"Black Sand",
	"Black Tie",
	"Blaze",
	"Blaze Orange",
	"Blind Spot",
	"Blizzard Marbleized",
	"Blood Tiger",
	"Blood in the Water",
	"Bloodshot",
	"Bloodsport",
	"Bloomstick",
	"Blue Fissure",
	"Blue Laminate",
	"Blue Spruce",
	"Blue Steel",
	"Blue Streak",
	"Blue Titanium",
	"Blueprint",
	"Bone Machine",
	"Bone Mask",
	"Bone Pile",
	"Boreal Forest",
	"Boroque Sand",
	"Brake Light",
	"Brass",
	"Bratatat",
	"Briar",
	"Briefing",
	"Bright Water",
	"Bronze Deco",
	"Buddy",
	"Bulkhead",
	"Bulldozer",
	"Bullet Rain",
	"Bunsen Burner",
	"Business Class",
	"Buzz Kill",
	"Caged Steel",
	"Caiman",
	"Calf Skin",
	"CaliCamo",
	"Canal Spray",
	"Candy Apple",
	"Capillary",
	"Caramel",
	"Carbon Fiber",
	"Cardiac",
	"Carnivore",
	"Cartel",
	"Case Hardened",
	"Catacombs",
	"Cerberus",
	"Chainmail",
	"Chalice",
	"Chameleon",
	"Chantico's Fire",
	"Chatterbox",
	"Check Engine",
	"Chemical Green",
	"Chopper",
	"Chronos",
	"Cinquedea",
	"Cirrus",
	"Classic Crate",
	"Co-Processor",
	"Coach Class",
	"Colbalt Core",
	"Colbalt Disruption",
	"Colbalt Halftone",
	"Colbalt Quartz",
	"Cobra Strike",
	"Code Red",
	"Cold Blooded",
	"Cold Fusion",
	"Colony",
	"Colony IV",
	"Commemoration",
	"Commuter",
	"Condemned",
	"Conspiracy",
	"Containment Breach",
	"Contamination",
	"Contractor",
	"Contrast Spray",
	"Control Panel",
	"Converter",
	"Coolant",
	"Copper",
	"Copper Borre",
	"Copper Galaxy",
	"Copperhead",
	"Core Breach",
	"Corinthian",
	"Corporal",
	"Cortex",
	"Corticera",
	"Counter Terrace",
	"Cracked Opal",
	"Crimson Blossom",
	"Crimson Kimono",
	"Crimson Tsunami",
	"Crimson Web",
	"Crypsis",
	"Curse",
	"Cut Out",
	"Cyanospatter",
	"Cyrex",
	"Daedalus",
	"Damascus Steel",
	"Danger Close",
	"Dark Age",
	"Dark Blossom",
	"Dark Filigree",
	"Dark Water",
	"Dart",
	"Day Lily",
	"Daybreak",
	"Dazzle",
	"Deadly Poison",
	"Death Grip",
	"Death Rattle",
	"Death by Kitty",
	"Death by Puppy",
	"Death's Head",
	"Decimator",
	"Decommissioned",
	"Delusion",
	"Demeter",
	"Demolition",
	"Desert Storm",
	"Desert Warfare",
	"Desert-Strike",
	"Desolate Space",
	"Detour",
	"Devourer",
	"Directive",
	"Dirt Drop",
	"Djinn",
	"Doomkitty",
	"Doppler",
	"Dragon Lore",
	"Dragon Tattoo",
	"Dragonfire",
	"Dry Season",
	"Dualing Dragons",
	"Duelist",
	"Eco",
	"Electric Hive",
	"Elite 1.6",
	"Elite Build",
	"Embargo",
	"Emerald",
	"Emerald Dragon",
	"Emerald Jörmungandr",
	"Emerald Pinstripe",
	"Emerald Posion Dart",
	"Emerald Quartz",
	"Evil Daimyo",
	"Exchanger",
	"Exo",
	"Exposure",
	"Eye of Athena",
	"Facets",
	"Facility Dark",
	"Facility Draft",
	"Facility Negative",
	"Facility Sketch",
	"Fade",
	"Faded Zebra",
	"Fallout Warning",
	"Fever Dream",
	"Fire Elemental",
	"Fire Serpent",
	"Firefight",
	"Firestarter",
	"First Class",
	"Flame Jörmungandr",
	"Flame Test",
	"Flash Out",
	"Flashback",
	"Fleet Flock",
	"Flux",
	"Forest DDPAT",
	"Forest Leaves",
	"Forest Night",
	"Fowl Play",
	"Franklin",
	"Freehand",
	"Frontside Misty",
	"Frost Borre",
	"Fubar",
	"Fuel Injector",
	"Fuel Rod",
	"Full Stop",
	"Gamma Doppler",
	"Gator Mesh",
	"Golden Koi",
	"Goo",
	"Grand Prix",
	"Granite Marbleized",
	"Graphite",
	"Grassland",
	"Grassland Leaves",
	"Graven",
	"Green Apple",
	"Green Marine",
	"Green Plaid",
	"Griffin",
	"Grim",
	"Grinder",
	"Grip",
	"Grotto",
	"Groundwater",
	"Guardian",
	"Gungnir",
	"Gunsmoke",
	"Hades",
	"Hand Brake",
	"Hand Cannon",
	"Handgun",
	"Hard Water",
	"Harvester",
	"Hazard",
	"Heat",
	"Heaven Guard",
	"Heriloom",
	"Hellfire",
	"Hemoglobin",
	"Hexane",
	"High Beam",
	"High Roller",
	"High Seas",
	"Highwayman",
	"Hive",
	"Hot Rod",
	"Howl",
	"Hunter",
	"Hunting Blind",
	"Hydra",
	"Hydroponic",
	"Hyper Beast",
	"Hypnotic",
	"Icarus Fell",
	"Ice Cap",
	"Impact Drill",
	"Imperial",
	"Imperial Dragon",
	"Impire",
	"Imprint",
	"Incinegator",
	"Indigo",
	"Inferno",
	"Integrale",
	"Iron Clad",
	"Ironwork",
	"Irradiated Alert",
	"Isaac",
	"Ivory",
	"Jaguar",
	"Jambiya",
	"Jet Set",
	"Judgement of Anubis",
	"Jungle",
	"Jungle DDPAT",
	"Jungle Dashed",
	"Jungle Slipstream",
	"Jungle Spray",
	"Jungle Thicket",
	"Jungle Tiger",
	"Kami",
	"Kill Confirmed",
	"Knight",
	"Koi",
	"Kumicho Dragon",
	"Lab Rats",
	"Labyrinth",
	"Lapis Gator",
	"Last Dive",
	"Lead Conduit",
	"Leaded Glass",
	"Leather",
	"Lichen Dashed",
	"Light Rail",
	"Lightning Strike",
	"Limelight",
	"Lionfish",
	"Llama Cannon",
	"Lore",
	"Loudmouth",
	"Macabre",
	"Magma",
	"Magnesium",
	"Mainframe",
	"Malachite",
	"Man-o'-war",
	"Mandrel",
	"Marble Fade",
	"Marina",
	"Master Piece",
	"Mayan Dreams",
	"Mecha Industries",
	"Medusa",
	"Mehndi",
	"Memento",
	"Metal Flowers",
	"Metallic DDPAT",
	"Meteorite",
	"Midnight Lilly",
	"Midnight Storm",
	"Minotaur's Labyrinth",
	"Mint Kimono",
	"Mischief",
	"Mjölnir",
	"Modern Hunter",
	"Modest Threat",
	"Module",
	"Momentum",
	"Monkey Business",
	"Moon in Libra",
	"Moonrise",
	"Morris",
	"Mortis",
	"Mosaico",
	"Moss Quartz",
	"Motherboard",
	"Mudder",
	"Muertos",
	"Murky",
	"Naga",
	"Navy Murano",
	"Nebula Crusader",
	"Necropos",
	"Nemesis",
	"Neo-Noir",
	"Neon Kimono",
	"Neon Ply",
	"Neon Revolution",
	"Neon Rider",
	"Neural Net",
	"Nevermore",
	"Night",
	"Night Borre",
	"Night Ops",
	"Night Riot",
	"Night Stripe",
	"Nightmare",
	"Nightshade",
	"Nitro",
	"Nostalgia",
	"Nuclear Garden",
	"Nuclear Threat",
	"Nuclear Waste",
	"Obsidian",
	"Ocean Foam",
	"Oceanic",
	"Off World",
	"Olive Plaid",
	"Oni Taiji",
	"Orange Crash",
	"Orange DDPAT",
	"Orange Filigree",
	"Orange Kimono",
	"Orange Murano",
	"Orange Peel",
	"Orbit Mk01",
	"Origami",
	"Orion",
	"Osiris",
	"Outbreak",
	"Overgrowth",
	"Oxide Blaze",
	"Paw",
	"Palm",
	"Pandora's Box",
	"Panther",
	"Para Green",
	"Pathfinder",
	"Petroglyph",
	"Phantom",
	"Phobos",
	"Phosphor",
	"Photic Zone",
	"Pilot",
	"Pink DDPAT",
	"Pipe Down",
	"Pit Viper",
	"Plastique",
	"Plume",
	"Point Disarray",
	"Posion Dart",
	"Polar Camo",
	"Polar Mesh",
	"Polymer",
	"Popdog",
	"Poseidon",
	"Power Loader",
	"Powercore",
	"Praetorian",
	"Predator",
	"Primal Saber",
	"Pulse",
	"Pyre",
	"Quicksilver",
	"Radiation Hazar",
	"Random Access",
	"Rangeen",
	"Ranger",
	"Rat Rod",
	"Re-Entry",
	"Reactor",
	"Reboot",
	"Red Astor",
	"Red Filigree",
	"Red FragCam",
	"Red Laminate",
	"Red Leather",
	"Red Python",
	"Red Quartz",
	"Red Rock",
	"Red Stone",
	"Redline",
	"Remote Contol",
	"Retribution",
	"Ricochet",
	"Riot",
	"Ripple",
	"Rising Skull",
	"Road Rash",
	"Rocket Pop",
	"Roll Cage",
	"Rose Iron",
	"Royal Blue",
	"Royal Consorts",
	"Royal Legion",
	"Royal Paladin",
	"Ruby Posion Dart",
	"Rust Coat",
	"Rust Leaf",
	"SWAG-7",
	"Sacrifice",
	"Safari Mesh",
	"Safety Net",
	"Sage Spray",
	"Sand Dashed",
	"Sand Dune",
	"Sand Mesh",
	"Sand Scale",
	"Sand Spray",
	"Sandstorm",
	"Scaffold",
	"Scavenger",
	"Scorched",
	"Scorpion",
	"Scumbria",
	"Sea Calico",
	"Seabird",
	"Seasons",
	"See Ya Later",
	"Serenity",
	"Sergeant",
	"Serum",
	"Setting Sun",
	"Shallow Grave",
	"Shapewood",
	"Shattered",
	"Shipping Forecast",
	"Shred",
	"Signal",
	"Silver",
	"Silver Quartz",
	"Skull Crusher",
	"Skulls",
	"Slashed",
	"Slaughter",
	"Slide",
	"Slipstream",
	"Snake Camo",
	"Snek-9",
	"Sonar",
	"Special Delivery",
	"Spectre",
	"Spitfire",
	"Splash",
	"Splash Jam",
	"Stained",
	"Stained Glass",
	"Stainless",
	"Stalker",
	"Steel Disruption",
	"Stinger",
	"Stone Cold",
	"Stone Mosaico",
	"Storm",
	"Stymphalian",
	"Styx",
	"Sugar Rush",
	"Sun in Leo",
	"Sundown",
	"Sunset Lily",
	"Sunset Storm",
	"Supernova",
	"Surfwood",
	"Survivalist",
	"Survivor Z",
	"Sweeper",
	"Syd Mead",
	"Synth Leaf",
	"System Lock",
	"Tacticat",
	"Tatter",
	"Teal Blossom",
	"Teardown",
	"Teclu Burner",
	"Tempest",
	"Terrace",
	"Terrain",
	"The Battlestar",
	"The Emperor",
	"The Empress",
	"The Executioner",
	"The Fuschia Is Now",
	"The Kraken",
	"The Prince",
	"Tiger Moth",
	"Tiger Tooth",
	"Tigris",
	"Titanium Bit",
	"Torn",
	"Tornado",
	"Torque",
	"Toxic",
	"Toy Soldier",
	"Traction",
	"Tranquility",
	"Traveler",
	"Tread Plate",
	"Triarch",
	"Trigon",
	"Triqua",
	"Triumvierate",
	"Tropical Storm",
	"Turf",
	"Tuxedo",
	"Twilight Galaxy",
	"Twin Turbo",
	"Twist",
	"Ultraviolet",
	"Uncharted",
	"Undertow",
	"Urban DDPAT",
	"Urban Dashed",
	"Urban Hazard",
	"Urban Masked",
	"Urban Perforated",
	"Urban Rubble",
	"Urban Shock",
	"Valence",
	"VariCamo",
	"VariCamo Blue",
	"Ventilator",
	"Ventilators",
	"Verdigris",
	"Victoria",
	"Vino Primo",
	"Violent Daimyo",
	"Violet Murano",
	"Virus",
	"Vulcan",
	"Walnut",
	"Warbird",
	"Warhawk",
	"Wasteland Princess",
	"Wasteland Rebel",
	"Water Elemental",
	"Water Sigil",
	"Wave Spray",
	"Waves Perforated",
	"Weasel",
	"Whitefish",
	"Whiteout",
	"Wild Lily",
	"Wild Lotus",
	"Wild Six",
	"Wildfire",
	"Wings",
	"Wingshot",
	"Winter Forest",
	"Wood Fired",
	"Woodsman",
	"Worm God",
	"Wraiths",
	"X-Ray",
	"Xiangliu",
	"Yellow Jacket",
	"Yorick",
	"Zander",
	"Ziggy",
	"Zirka",
	"龍王 (Dragon King)"
})
slot54 = ui.new_slider("LUA", "A", "Gap Value", 1, 20, 1, true)

function slot55()
	uv0 = false
	uv1 = false
	uv2 = false
	uv3 = false
	uv4 = false
	uv5 = false
	uv6 = false
end

function slot56()
	for slot4 = 1, #uv0(uv1) do
		if slot0[slot4] ~= "Auto-Disconnect" then
			uv2 = false
		end

		if slot0[slot4] ~= "Auto-Disconnect-Dmg" then
			uv3 = false
		end

		if slot0[slot4] ~= "Auto-Revert Name" then
			uv4 = false
		end

		if slot0[slot4] ~= "Hide Name Change" then
			uv5 = false
		end

		if slot0[slot4] ~= "StatTrak Weapon" then
			uv6 = false
		end

		if slot0[slot4] ~= "Unbox Message" then
			uv7 = false
		end

		if slot0[slot4] ~= "Use Skins List" then
			uv8 = false
		end

		if slot0[slot4] ~= "Custom Gap Value" then
			uv9 = false
		end
	end

	for slot4 = 1, #slot0 do
		if slot0[slot4] == "Auto-Disconnect" then
			uv2 = true
		end

		if slot0[slot4] == "Auto-Disconnect-Dmg" then
			uv3 = true
		end

		if slot0[slot4] == "Auto-Revert Name" then
			uv4 = true
		end

		if slot0[slot4] == "Hide Name Change" then
			uv5 = true
		end

		if slot0[slot4] == "StatTrak Weapon" then
			uv6 = true
		end

		if slot0[slot4] == "Unbox Message" then
			uv7 = true
		end

		if slot0[slot4] == "Use Skins List" then
			uv8 = true
		end

		if slot0[slot4] == "Custom Gap Value" then
			uv9 = true
		end
	end

	if next(uv0(uv1)) == nil then
		uv10()
	end
end

slot58 = ui.new_button("LUA", "A", "Set Name", function ()
	slot1 = uv1(uv2)
	slot2 = uv1(uv3)
	slot3 = uv4[1]
	slot4 = uv5[uv6(uv0(), "m_iTeamNum")]
	slot5 = uv7[uv1(uv8)]
	slot6 = uv1(uv9)
	slot7 = ""
	slot8 = "ᅠ"

	if uv1(uv2) == "Show More (List)" then
		slot1 = uv10[uv1(uv11) + 1]
	end

	if uv12 then
		slot3 = uv4[2]
	end

	if uv13 then
		slot2 = uv14[uv1(uv15) + 1]
	end

	slot9 = uv16(uv17, slot1) and "★ " or ""
	slot9 = uv18 and slot9 .. "StatTrak™ " .. slot1 or slot9 .. slot1
	slot7 = (not uv19 or uv20(slot8, slot6)) and " "

	uv21(uv22, true)
	uv23("\n\\xad\\xad\\xad\\xad")
	uv24(0, function ()
		if uv0 and uv1 and uv2(uv3) then
			uv4(0.01, uv5, "Say " .. uv6(" ﷽﷽", 40))
			print("Spammed the chat in an attempt to hide the initial name change.")
		end
	end)
	uv24(0.3, function ()
		uv0 = false

		if uv6 then
			uv7(uv8 .. uv9 .. " " .. (uv1 .. uv2 .. uv3 .. " | " .. uv4 .. "\n" .. uv5) .. "? ")
			uv10(0.8, uv11, "disconnect")
			uv10(5.2, function ()
				uv0(uv1, false)
				print("Automatically disconnected from the server after setting Skin-Name.")
			end)
		elseif uv14 then
			slot1 = uv9

			if uv15(uv9) > 12 then
				slot1 = uv16(uv9, 0, 12)

				print("Clamped the clantag to prevent fuck up on scoreboard :).")
			end

			uv17(uv8 .. slot1 .. " \n")
			uv7("\n" .. slot0 .. "You")
		else
			uv17()
			uv7(uv8 .. uv9 .. " " .. slot0 .. "You")
		end
	end)
end)

function ()
	slot0 = uv0(uv1)

	uv2(uv3, slot0)
	uv2(uv4, slot0)
	uv2(uv5, slot0)
	uv2(uv6, slot0)
	uv2(uv7, slot0)
	uv2(uv8, slot0)

	if slot0 then
		uv9 = cvar.name:get_string()
		uv10 = true
	elseif uv10 == true then
		uv11()
		uv12(uv9)
		uv13()

		uv10 = false
	end

	uv14()
end()
slot19(ui.new_multiselect("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Disconnect-Dmg", "Auto-Revert Name", "Hide Name Change", "StatTrak Weapon", "Unbox Message", "Use Skins List", "Custom Gap Value"), function ()
	if uv0(uv1) then
		uv2()

		if uv3 then
			uv4(uv5, true)
			uv4(uv6, false)
		else
			uv4(uv5, false)
			uv4(uv6, true)
		end

		if uv7 then
			uv4(uv8, true)
		else
			uv4(uv8, false)
		end

		if uv0(uv9) == "Show More (List)" then
			uv4(uv10, true)
		else
			uv4(uv10, false)
		end

		if uv11 then
			uv12(uv13, false)
			uv4(uv14, true)
		else
			uv4(uv14, false)
		end
	else
		uv4(uv5, false)
		uv4(uv8, false)
		uv4(uv10, false)
		uv4(uv14, false)
	end
end)
slot19(slot15("LUA", "A", "Weapon Type", {
	"Show More (List)",
	"Bayonet",
	"Karambit",
	"M9 Bayonet",
	"AK-47",
	"AWP",
	"Desert Eagle",
	"Glock-18",
	"M4A4"
}), function ()
	uv0()
end)

function slot61(slot0)
	if uv2(slot0.attacker) == slot1 and uv1(uv2(slot0.userid), "m_iTeamNum") == uv1(uv0(), "m_iTeamNum") then
		if uv3 then
			uv4(uv5, false)
			print("Reverted name back to normal and disabled the main checkbox for the script.")
		end

		if uv6 then
			uv4(uv5, false)
			uv7("Disconnect")
			print("Disconnected from the server after reverting name.")
		end
	end
end

function slot62(slot0)
	uv0()
	uv1(slot0) and uv2 or uv3("player_hurt", uv4)
end

slot20("shutdown", function ()
	uv0(uv1, false)
end)
slot62(slot45)
slot19(slot45, slot62)
