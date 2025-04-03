local var_0_0 = false
local var_0_1 = false
local var_0_2 = false
local var_0_3 = false
local var_0_4 = false
local var_0_5 = false
local var_0_6 = false
local var_0_7 = false
local var_0_8 = false
local var_0_9 = true
local var_0_10 = ui.get
local var_0_11 = ui.set
local var_0_12 = ui.reference
local var_0_13 = ui.new_checkbox
local var_0_14 = ui.new_multiselect
local var_0_15 = ui.new_combobox
local var_0_16 = ui.new_listbox
local var_0_17 = ui.new_button
local var_0_18 = ui.set_visible
local var_0_19 = ui.set_callback
local var_0_20 = client.set_event_callback
local var_0_21 = client.unset_event_callback
local var_0_22 = client.set_clan_tag
local var_0_23 = client.userid_to_entindex
local var_0_24 = client.delay_call
local var_0_25 = client.exec
local var_0_26 = entity.get_local_player
local var_0_27 = entity.get_prop
local var_0_28 = globals.mapname
local var_0_29 = string.rep
local var_0_30 = string.len
local var_0_31 = string.sub
local var_0_32 = var_0_12("MISC", "Miscellaneous", "Steal player name")
local var_0_33 = var_0_12("MISC", "Miscellaneous", "Clan tag spammer")
local var_0_34 = var_0_22
local var_0_35 = cvar.name:get_string()

local function var_0_36(arg_1_0)
	cvar.name:set_string(arg_1_0)
end

local function var_0_37(arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_0 do
		if arg_2_0[iter_2_0] == arg_2_1 then
			return true
		end
	end

	return false
end

var_0_20("player_connect_full", function(arg_3_0)
	if var_0_23(arg_3_0.userid) == var_0_26() and var_0_28() ~= nil then
		var_0_9 = true
	end
end)

local var_0_38 = {
	" \x01",
	" \t",
	" \v"
}
local var_0_39 = {
	["Covert (Red)"] = "\a",
	["Industrial (LightBlue)"] = "\v",
	["Contraband (Orangeish)"] = "\x10",
	["Classified (PinkishPurple)"] = "\x0E",
	["Restricted (Pruple)"] = "\x03",
	["Mil spec (DarkBlue)"] = "\f"
}
local var_0_40 = {
	[1] = "received in a trade: ",
	[2] = "has opened a container and found: "
}
local var_0_41 = {
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
}
local var_0_42 = {
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
local var_0_43 = {
	"Show More (List)",
	"Bayonet",
	"Karambit",
	"M9 Bayonet",
	"AK-47",
	"AWP",
	"Desert Eagle",
	"Glock-18",
	"M4A4"
}
local var_0_44 = {
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
}
local var_0_45 = var_0_13("LUA", "A", "Enable Skin-Name")
local var_0_46 = var_0_13("LUA", "A", "CleanChat on initial change")
local var_0_47 = var_0_14("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Disconnect-Dmg", "Auto-Revert Name", "Hide Name Change", "StatTrak Weapon", "Unbox Message", "Use Skins List", "Custom Gap Value")
local var_0_48 = var_0_15("LUA", "A", "Weapon Type", var_0_43)
local var_0_49 = var_0_16("LUA", "A", "Weapons Extended", var_0_41)
local var_0_50 = var_0_15("LUA", "A", "Drop Rarity/Color", "Industrial (LightBlue)", "Mil spec (DarkBlue)", "Restricted (Pruple)", "Classified (PinkishPurple)", "Covert (Red)", "Contraband (Orangeish)")
local var_0_51 = ui.new_label("LUA", "A", "Skin Name")
local var_0_52 = ui.new_textbox("LUA", "A", "Skin")
local var_0_53 = var_0_16("LUA", "A", "Skins Extended", var_0_44)
local var_0_54 = ui.new_slider("LUA", "A", "Gap Value", 1, 20, 1, true)

local function var_0_55()
	var_0_0 = false
	var_0_2 = false
	var_0_3 = false
	var_0_4 = false
	var_0_5 = false
	var_0_6 = false
	var_0_7 = false
end

local function var_0_56()
	local var_5_0 = var_0_10(var_0_47)

	for iter_5_0 = 1, #var_5_0 do
		if var_5_0[iter_5_0] ~= "Auto-Disconnect" then
			var_0_0 = false
		end

		if var_5_0[iter_5_0] ~= "Auto-Disconnect-Dmg" then
			var_0_1 = false
		end

		if var_5_0[iter_5_0] ~= "Auto-Revert Name" then
			var_0_2 = false
		end

		if var_5_0[iter_5_0] ~= "Hide Name Change" then
			var_0_3 = false
		end

		if var_5_0[iter_5_0] ~= "StatTrak Weapon" then
			var_0_4 = false
		end

		if var_5_0[iter_5_0] ~= "Unbox Message" then
			var_0_5 = false
		end

		if var_5_0[iter_5_0] ~= "Use Skins List" then
			var_0_6 = false
		end

		if var_5_0[iter_5_0] ~= "Custom Gap Value" then
			var_0_7 = false
		end
	end

	for iter_5_1 = 1, #var_5_0 do
		if var_5_0[iter_5_1] == "Auto-Disconnect" then
			var_0_0 = true
		end

		if var_5_0[iter_5_1] == "Auto-Disconnect-Dmg" then
			var_0_1 = true
		end

		if var_5_0[iter_5_1] == "Auto-Revert Name" then
			var_0_2 = true
		end

		if var_5_0[iter_5_1] == "Hide Name Change" then
			var_0_3 = true
		end

		if var_5_0[iter_5_1] == "StatTrak Weapon" then
			var_0_4 = true
		end

		if var_5_0[iter_5_1] == "Unbox Message" then
			var_0_5 = true
		end

		if var_5_0[iter_5_1] == "Use Skins List" then
			var_0_6 = true
		end

		if var_5_0[iter_5_1] == "Custom Gap Value" then
			var_0_7 = true
		end
	end

	if next(var_0_10(var_0_47)) == nil then
		var_0_55()
	end
end

local function var_0_57()
	if var_0_10(var_0_45) then
		var_0_56()

		if var_0_6 then
			var_0_18(var_0_53, true)
			var_0_18(var_0_52, false)
		else
			var_0_18(var_0_53, false)
			var_0_18(var_0_52, true)
		end

		if var_0_7 then
			var_0_18(var_0_54, true)
		else
			var_0_18(var_0_54, false)
		end

		if var_0_10(var_0_48) == "Show More (List)" then
			var_0_18(var_0_49, true)
		else
			var_0_18(var_0_49, false)
		end

		if var_0_3 then
			var_0_11(var_0_33, false)
			var_0_18(var_0_46, true)
		else
			var_0_18(var_0_46, false)
		end
	else
		var_0_18(var_0_53, false)
		var_0_18(var_0_54, false)
		var_0_18(var_0_49, false)
		var_0_18(var_0_46, false)
	end
end

local var_0_58 = var_0_17("LUA", "A", "Set Name", function()
	local var_7_0 = var_0_26()
	local var_7_1 = var_0_10(var_0_48)
	local var_7_2 = var_0_10(var_0_52)
	local var_7_3 = var_0_40[1]
	local var_7_4 = var_0_38[var_0_27(var_7_0, "m_iTeamNum")]
	local var_7_5 = var_0_39[var_0_10(var_0_50)]
	local var_7_6 = var_0_10(var_0_54)
	local var_7_7 = ""
	local var_7_8 = "ᅠ"

	if var_0_10(var_0_48) == "Show More (List)" then
		var_7_1 = var_0_41[var_0_10(var_0_49) + 1]
	end

	if var_0_5 then
		var_7_3 = var_0_40[2]
	end

	if var_0_6 then
		var_7_2 = var_0_44[var_0_10(var_0_53) + 1]
	end

	local var_7_9 = var_0_37(var_0_42, var_7_1) and "★ " or ""

	var_7_9 = var_0_4 and var_7_9 .. "StatTrak™ " .. var_7_1 or var_7_9 .. var_7_1

	if var_0_7 then
		var_7_7 = var_0_29(var_7_8, var_7_6)
	else
		var_7_7 = " "
	end

	var_0_11(var_0_32, true)
	var_0_36("\n\xAD\xAD\xAD\xAD")
	var_0_24(0, function()
		if var_0_3 and var_0_9 and var_0_10(var_0_46) then
			var_0_24(0.01, var_0_25, "Say " .. var_0_29(" ﷽﷽", 40))
			print("Spammed the chat in an attempt to hide the initial name change.")
		end
	end)
	var_0_24(0.3, function()
		var_0_9 = false

		local var_9_0 = var_7_3 .. var_7_5 .. var_7_9 .. " | " .. var_7_2 .. "\n" .. var_7_7

		if var_0_0 then
			var_0_36(var_7_4 .. var_0_35 .. "\x01 " .. var_9_0 .. "? \x01")
			var_0_24(0.8, var_0_25, "disconnect")
			var_0_24(5.2, function()
				var_0_11(var_0_45, false)
				print("Automatically disconnected from the server after setting Skin-Name.")
			end)
		elseif var_0_3 then
			local var_9_1 = var_0_35

			if var_0_30(var_0_35) > 12 then
				var_9_1 = var_0_31(var_0_35, 0, 12)

				print("Clamped the clantag to prevent fuck up on scoreboard :).")
			end

			var_0_34(var_7_4 .. var_9_1 .. " \n")
			var_0_36("\n\x01" .. var_9_0 .. "\x01You")
		else
			var_0_34()
			var_0_36(var_7_4 .. var_0_35 .. "\x01 " .. var_9_0 .. "\x01You")
		end
	end)
end)

local function var_0_59()
	local var_11_0 = var_0_10(var_0_45)

	var_0_18(var_0_47, var_11_0)
	var_0_18(var_0_48, var_11_0)
	var_0_18(var_0_50, var_11_0)
	var_0_18(var_0_51, var_11_0)
	var_0_18(var_0_52, var_11_0)
	var_0_18(var_0_58, var_11_0)

	if var_11_0 then
		var_0_35 = cvar.name:get_string()
		var_0_8 = true
	elseif var_0_8 == true then
		var_0_34()
		var_0_36(var_0_35)
		var_0_55()

		var_0_8 = false
	end

	var_0_57()
end

local function var_0_60()
	var_0_57()
end

var_0_59()
var_0_19(var_0_47, var_0_57)
var_0_19(var_0_48, var_0_60)

local function var_0_61(arg_13_0)
	local var_13_0 = var_0_26()
	local var_13_1 = var_0_27(var_0_23(arg_13_0.userid), "m_iTeamNum") == var_0_27(var_13_0, "m_iTeamNum")

	if var_0_23(arg_13_0.attacker) == var_13_0 and var_13_1 then
		if var_0_2 then
			var_0_11(var_0_45, false)
			print("Reverted name back to normal and disabled the main checkbox for the script.")
		end

		if var_0_1 then
			var_0_11(var_0_45, false)
			var_0_25("Disconnect")
			print("Disconnected from the server after reverting name.")
		end
	end
end

local function var_0_62(arg_14_0)
	var_0_59()
	;(var_0_10(arg_14_0) and var_0_20 or var_0_21)("player_hurt", var_0_61)
end

var_0_20("shutdown", function()
	var_0_11(var_0_45, false)
end)
var_0_62(var_0_45)
var_0_19(var_0_45, var_0_62)
