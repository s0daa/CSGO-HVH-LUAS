local AutoDisconnect, AutoDisconnectD, AutoRevertName, HideNameChange, StatTrakWeapon, UnboxMessage, UseSkinsList, CustomGapValue, HasRan, ChatClean = false, false, false, false, false, false, false, false, false, true
local ui_get, ui_set, ui_reference, ui_new_checkbox, ui_new_multiselect, ui_new_combobox, ui_new_listbox, ui_new_button, ui_set_visible, ui_set_callback = ui.get, ui.set, ui.reference, ui.new_checkbox, ui.new_multiselect, ui.new_combobox, ui.new_listbox, ui.new_button, ui.set_visible, ui.set_callback
local client_set_event_callback, client_unset_event_callback, client_set_clan_tag, client_userid_to_entindex, client_delay_call, client_exec = client.set_event_callback, client.unset_event_callback, client.set_clan_tag, client.userid_to_entindex, client.delay_call, client.exec
local entity_get_local_player, entity_get_prop = entity.get_local_player, entity.get_prop
local globals_mapname = globals.mapname
local string_rep, string_len, string_sub = string.rep, string.len, string.sub

local NameSteal = ui_reference("MISC", "Miscellaneous", "Steal player name")
local ClanTag = ui_reference("MISC", "Miscellaneous", "Clan tag spammer")

local SetTag = client_set_clan_tag
local OrigName = cvar.name:get_string()

local function SetName(Name)
   cvar.name:set_string(Name)
end

local function table_contains(tbl, item)
   for i=1, #tbl do
	   if tbl[i] == item then
		   return true
	   end
   end
   return false
end

client_set_event_callback("player_connect_full", function(e)
   if client_userid_to_entindex(e.userid) == entity_get_local_player() and globals_mapname() ~= nil then
	   ChatClean = true
   end
end)

local TeamColors = {
   [1] = " \x01",
   [2] = " \x09",
   [3] = " \x0B"
}

local RarityColors = {
   ["Industrial (LightBlue)"] = "\x0B",
   ["Mil spec (DarkBlue)"] = "\x0C",
   ["Restricted (Pruple)"] = "\x03",
   ["Classified (PinkishPurple)"] = "\x0E",
   ["Covert (Red)"] = "\x07",
   ["Contraband (Orangeish)"] = "\x10"
}

local MessageTypes = {
   [1] = "received in a trade: ",
   [2] = "has opened a container and found: "
}

local WeaponsTable = {
   "AK-47", "AUG", "AWP", "CZ75-Auto", "Desert Eagle", "Dual Berettas", "FAMAS", "Five-SeveN", "G3SG1", "Galil AR",
   "Glock-18", "M4A1-S", "M4A4", "M249", "MAC-10", "MAG-7", "MP5-SD", "MP7", "MP9", "Negev", "Nova", "P90", "P250",
   "P2000", "PP-Bizon", "R8 Revolver", "Sawed-Off", "SCAR-20", "SG 553", "SSG 08", "Tec-9", "UMP-45", "USP-S", "XM1014",
   "Bayonet", "Bowie Knife", "Butterfly Knife", "Classic Knife", "Falchion Knife", "Flip Knife", "Gut Knife", "Huntsman Knife",
   "Karambit", "M9 Bayonet", "Navaja Knife", "Nomad Knife", "Paracord Knife", "Shadow Daggers", "Skeleton Knife", "Stiletto Knife",
   "Survival Knife", "Talon Knife", "Ursus Knife"
}

local KnivesTable = {
   "Bayonet", "Butterfly Knife", "Falchion Knife", "Flip Knife", "Gut Knife", "Huntsman Knife", "Karambit",
   "M9 Bayonet", "Shadow Daggers", "Bowie Knife", "Ursus Knife", "Navaja Knife", "Stiletto Knife", "Talon Knife",
   "Classic Knife", "Skeleton Knife", "Paracord Knife", "Survival Knife", "Nomad Knife"
}

local WeaponsTableC = {
	"Show More (List)", "Bayonet", "Karambit", "M9 Bayonet", "AK-47", "AWP", "Desert Eagle", "Glock-18", "M4A4"
}

local SkinTable = {
   "Abyss", "Acheron", "Acid Etched", "Acid Fade", "Acid Wash", "Aerial", "Afterimage", "Agent", "Airlock", "Akihabara Accept", "Akoben", "Aloha", "Amber Fade", "Amber Slipstream", "Angry Mob", "Anodized Gunmetal", "Arctic Camo", "Arctic Wolf", "Aristocrat", "Armor Core", "Army Mesh", "Arym Recon", "Army Sheen", "Ash Wood", "Asiimov", "Assault", "Asterion", "Astral Jörmungandr", "Atheris", "Atlas", "Atomic Alloy", "Autotronic", "Avalanche", "Aztec", "Azure Zebra", "BOOM", "Balance", "Bamboo Forest", "Bamboo Garden", "Bamboo Print", "Bamboo Shadow", "Bamboozle", "Banana Leaf", "Baroque Orange", "Baroque Purple", "Baroque Red", "Barricade", "Basilisk", "Bengal Tiger", "Big Iron", "Bioleak", "Black Laminate", "Black Limba", "Black Sand", "Black Tie", "Blaze", "Blaze Orange", "Blind Spot", "Blizzard Marbleized", "Blood Tiger", "Blood in the Water", "Bloodshot", "Bloodsport", "Bloomstick", "Blue Fissure", "Blue Laminate", "Blue Spruce", "Blue Steel", "Blue Streak", "Blue Titanium", "Blueprint", "Bone Machine", "Bone Mask", "Bone Pile", "Boreal Forest", "Boroque Sand", "Brake Light", "Brass", "Bratatat", "Briar", "Briefing", "Bright Water", "Bronze Deco", "Buddy", "Bulkhead", "Bulldozer", "Bullet Rain", "Bunsen Burner", "Business Class", "Buzz Kill", "Caged Steel", "Caiman", "Calf Skin", "CaliCamo", "Canal Spray", "Candy Apple", "Capillary", "Caramel", "Carbon Fiber", "Cardiac", "Carnivore", "Cartel", "Case Hardened", "Catacombs", "Cerberus", "Chainmail", "Chalice", "Chameleon", "Chantico's Fire", "Chatterbox", "Check Engine", "Chemical Green", "Chopper", "Chronos", "Cinquedea", "Cirrus", "Classic Crate", "Co-Processor", "Coach Class", "Colbalt Core", "Colbalt Disruption", "Colbalt Halftone", "Colbalt Quartz", "Cobra Strike", "Code Red", "Cold Blooded", "Cold Fusion", "Colony", "Colony IV", "Commemoration", "Commuter", "Condemned", "Conspiracy", "Containment Breach", "Contamination", "Contractor", "Contrast Spray", "Control Panel", "Converter", "Coolant", "Copper", "Copper Borre", "Copper Galaxy", "Copperhead", "Core Breach", "Corinthian", "Corporal", "Cortex", "Corticera", "Counter Terrace", "Cracked Opal", "Crimson Blossom", "Crimson Kimono", "Crimson Tsunami", "Crimson Web", "Crypsis", "Curse", "Cut Out", "Cyanospatter", "Cyrex", "Daedalus", "Damascus Steel", "Danger Close", "Dark Age", "Dark Blossom", "Dark Filigree", "Dark Water", "Dart", "Day Lily", "Daybreak", "Dazzle", "Deadly Poison", "Death Grip", "Death Rattle", "Death by Kitty", "Death by Puppy", "Death's Head", "Decimator", "Decommissioned", "Delusion", "Demeter", "Demolition", "Desert Storm", "Desert Warfare", "Desert-Strike", "Desolate Space", "Detour", "Devourer", "Directive", "Dirt Drop", "Djinn", "Doomkitty", "Doppler", "Dragon Lore", "Dragon Tattoo", "Dragonfire", "Dry Season", "Dualing Dragons", "Duelist", "Eco", "Electric Hive", "Elite 1.6", "Elite Build", "Embargo", "Emerald", "Emerald Dragon", "Emerald Jörmungandr", "Emerald Pinstripe", "Emerald Posion Dart", "Emerald Quartz", "Evil Daimyo", "Exchanger", "Exo", "Exposure", "Eye of Athena", "Facets", "Facility Dark", "Facility Draft", "Facility Negative", "Facility Sketch", "Fade", "Faded Zebra", "Fallout Warning", "Fever Dream", "Fire Elemental", "Fire Serpent", "Firefight", "Firestarter", "First Class", "Flame Jörmungandr", "Flame Test", "Flash Out", "Flashback", "Fleet Flock", "Flux", "Forest DDPAT", "Forest Leaves", "Forest Night", "Fowl Play", "Franklin", "Freehand", "Frontside Misty", "Frost Borre", "Fubar", "Fuel Injector", "Fuel Rod", "Full Stop", "Gamma Doppler", "Gator Mesh", "Golden Koi", "Goo", "Grand Prix", "Granite Marbleized", "Graphite", "Grassland", "Grassland Leaves", "Graven", "Green Apple", "Green Marine", "Green Plaid", "Griffin", "Grim", "Grinder", "Grip", "Grotto", "Groundwater", "Guardian", "Gungnir", "Gunsmoke", "Hades", "Hand Brake", "Hand Cannon", "Handgun", "Hard Water", "Harvester", "Hazard", "Heat", "Heaven Guard", "Heriloom", "Hellfire", "Hemoglobin", "Hexane", "High Beam", "High Roller", "High Seas", "Highwayman", "Hive", "Hot Rod", "Howl", "Hunter", "Hunting Blind", "Hydra", "Hydroponic", "Hyper Beast", "Hypnotic", "Icarus Fell", "Ice Cap", "Impact Drill", "Imperial", "Imperial Dragon", "Impire", "Imprint", "Incinegator", "Indigo", "Inferno", "Integrale", "Iron Clad", "Ironwork", "Irradiated Alert", "Isaac", "Ivory", "Jaguar", "Jambiya", "Jet Set", "Judgement of Anubis", "Jungle", "Jungle DDPAT", "Jungle Dashed", "Jungle Slipstream", "Jungle Spray", "Jungle Thicket", "Jungle Tiger", "Kami", "Kill Confirmed", "Knight", "Koi", "Kumicho Dragon", "Lab Rats", "Labyrinth", "Lapis Gator", "Last Dive", "Lead Conduit", "Leaded Glass", "Leather", "Lichen Dashed", "Light Rail", "Lightning Strike", "Limelight", "Lionfish", "Llama Cannon", "Lore", "Loudmouth", "Macabre", "Magma", "Magnesium", "Mainframe", "Malachite", "Man-o'-war", "Mandrel", "Marble Fade", "Marina", "Master Piece", "Mayan Dreams", "Mecha Industries", "Medusa", "Mehndi", "Memento", "Metal Flowers", "Metallic DDPAT", "Meteorite", "Midnight Lilly", "Midnight Storm", "Minotaur's Labyrinth", "Mint Kimono", "Mischief", "Mjölnir", "Modern Hunter", "Modest Threat", "Module", "Momentum", "Monkey Business", "Moon in Libra", "Moonrise", "Morris", "Mortis", "Mosaico", "Moss Quartz", "Motherboard", "Mudder", "Muertos", "Murky", "Naga", "Navy Murano", "Nebula Crusader", "Necropos", "Nemesis", "Neo-Noir", "Neon Kimono", "Neon Ply", "Neon Revolution", "Neon Rider", "Neural Net", "Nevermore", "Night", "Night Borre", "Night Ops", "Night Riot", "Night Stripe", "Nightmare", "Nightshade", "Nitro", "Nostalgia", "Nuclear Garden", "Nuclear Threat", "Nuclear Waste", "Obsidian", "Ocean Foam", "Oceanic", "Off World", "Olive Plaid", "Oni Taiji", "Orange Crash", "Orange DDPAT", "Orange Filigree", "Orange Kimono", "Orange Murano", "Orange Peel", "Orbit Mk01", "Origami", "Orion", "Osiris", "Outbreak", "Overgrowth", "Oxide Blaze", "Paw", "Palm", "Pandora's Box", "Panther", "Para Green", "Pathfinder", "Petroglyph", "Phantom", "Phobos", "Phosphor", "Photic Zone", "Pilot", "Pink DDPAT", "Pipe Down", "Pit Viper", "Plastique", "Plume", "Point Disarray", "Posion Dart", "Polar Camo", "Polar Mesh", "Polymer", "Popdog", "Poseidon", "Power Loader", "Powercore", "Praetorian", "Predator", "Primal Saber", "Pulse", "Pyre", "Quicksilver", "Radiation Hazar", "Random Access", "Rangeen", "Ranger", "Rat Rod", "Re-Entry", "Reactor", "Reboot", "Red Astor", "Red Filigree", "Red FragCam", "Red Laminate", "Red Leather", "Red Python", "Red Quartz", "Red Rock", "Red Stone", "Redline", "Remote Contol", "Retribution", "Ricochet", "Riot", "Ripple", "Rising Skull", "Road Rash", "Rocket Pop", "Roll Cage", "Rose Iron", "Royal Blue", "Royal Consorts", "Royal Legion", "Royal Paladin", "Ruby Posion Dart", "Rust Coat", "Rust Leaf", "SWAG-7", "Sacrifice", "Safari Mesh", "Safety Net", "Sage Spray", "Sand Dashed", "Sand Dune", "Sand Mesh", "Sand Scale", "Sand Spray", "Sandstorm", "Scaffold", "Scavenger", "Scorched", "Scorpion", "Scumbria", "Sea Calico", "Seabird", "Seasons", "See Ya Later", "Serenity", "Sergeant", "Serum", "Setting Sun", "Shallow Grave", "Shapewood", "Shattered", "Shipping Forecast", "Shred", "Signal", "Silver", "Silver Quartz", "Skull Crusher", "Skulls", "Slashed", "Slaughter", "Slide", "Slipstream", "Snake Camo", "Snek-9", "Sonar", "Special Delivery", "Spectre", "Spitfire", "Splash", "Splash Jam", "Stained", "Stained Glass", "Stainless", "Stalker", "Steel Disruption", "Stinger", "Stone Cold", "Stone Mosaico", "Storm", "Stymphalian", "Styx", "Sugar Rush", "Sun in Leo", "Sundown", "Sunset Lily", "Sunset Storm", "Supernova", "Surfwood", "Survivalist", "Survivor Z", "Sweeper", "Syd Mead", "Synth Leaf", "System Lock", "Tacticat", "Tatter", "Teal Blossom", "Teardown", "Teclu Burner", "Tempest", "Terrace", "Terrain", "The Battlestar", "The Emperor", "The Empress", "The Executioner", "The Fuschia Is Now", "The Kraken", "The Prince", "Tiger Moth", "Tiger Tooth", "Tigris", "Titanium Bit", "Torn", "Tornado", "Torque", "Toxic", "Toy Soldier", "Traction", "Tranquility", "Traveler", "Tread Plate", "Triarch", "Trigon", "Triqua", "Triumvierate", "Tropical Storm", "Turf", "Tuxedo", "Twilight Galaxy", "Twin Turbo", "Twist", "Ultraviolet", "Uncharted", "Undertow", "Urban DDPAT", "Urban Dashed", "Urban Hazard", "Urban Masked", "Urban Perforated", "Urban Rubble", "Urban Shock", "Valence", "VariCamo", "VariCamo Blue", "Ventilator", "Ventilators", "Verdigris", "Victoria", "Vino Primo", "Violent Daimyo", "Violet Murano", "Virus", "Vulcan", "Walnut", "Warbird", "Warhawk", "Wasteland Princess", "Wasteland Rebel", "Water Elemental", "Water Sigil", "Wave Spray", "Waves Perforated", "Weasel", "Whitefish", "Whiteout", "Wild Lily", "Wild Lotus", "Wild Six", "Wildfire", "Wings", "Wingshot", "Winter Forest", "Wood Fired", "Woodsman", "Worm God", "Wraiths", "X-Ray", "Xiangliu", "Yellow Jacket", "Yorick", "Zander", "Ziggy", "Zirka", "龍王 (Dragon King)"
}

local Enabled = ui_new_checkbox("LUA", "A", "Enable Skin-Name")
local ChatSpam = ui_new_checkbox("LUA", "A", "CleanChat on initial change")
local Multi = ui_new_multiselect("LUA", "A", "Modifiers", "Auto-Disconnect", "Auto-Disconnect-Dmg", "Auto-Revert Name", "Hide Name Change", "StatTrak Weapon", "Unbox Message", "Use Skins List", "Custom Gap Value")
local Weapon = ui_new_combobox("LUA", "A", "Weapon Type", WeaponsTableC)
local WeaponList = ui_new_listbox("LUA", "A", "Weapons Extended", WeaponsTable)
local Rarity = ui_new_combobox("LUA", "A", "Drop Rarity/Color", "Industrial (LightBlue)", "Mil spec (DarkBlue)", "Restricted (Pruple)", "Classified (PinkishPurple)", "Covert (Red)", "Contraband (Orangeish)")
local Label = ui.new_label("LUA", "A", "Skin Name")
local Skin = ui.new_textbox("LUA", "A", "Skin")
local SkinList = ui_new_listbox("LUA", "A", "Skins Extended", SkinTable)
local Slider = ui.new_slider("LUA", "A", "Gap Value", 1, 20, 1, true)

local function SetFalse()
   AutoDisconnect = false
   AutoRevertName = false
   HideNameChange = false
   StatTrakWeapon = false
   UnboxMessage   = false
   UseSkinsList   = false
   CustomGapValue = false
end

local function Sync()
   local Selected = ui_get(Multi)
   for i=1, #Selected do
	   if Selected[i] ~= "Auto-Disconnect"  then AutoDisconnect = false end
	   if Selected[i] ~= "Auto-Disconnect-Dmg"  then AutoDisconnectD = false end
	   if Selected[i] ~= "Auto-Revert Name" then AutoRevertName = false end
	   if Selected[i] ~= "Hide Name Change" then HideNameChange = false end
	   if Selected[i] ~= "StatTrak Weapon"  then StatTrakWeapon = false end
	   if Selected[i] ~= "Unbox Message"	then UnboxMessage   = false end
	   if Selected[i] ~= "Use Skins List"   then UseSkinsList   = false end
	   if Selected[i] ~= "Custom Gap Value" then CustomGapValue = false end
   end
   for i=1, #Selected do
	   if Selected[i] == "Auto-Disconnect"  then AutoDisconnect = true end
	   if Selected[i] == "Auto-Disconnect-Dmg" then AutoDisconnectD = true end
	   if Selected[i] == "Auto-Revert Name" then AutoRevertName = true end
	   if Selected[i] == "Hide Name Change" then HideNameChange = true end
	   if Selected[i] == "StatTrak Weapon"  then StatTrakWeapon = true end
	   if Selected[i] == "Unbox Message"	then UnboxMessage   = true end
	   if Selected[i] == "Use Skins List"   then UseSkinsList   = true end
	   if Selected[i] == "Custom Gap Value" then CustomGapValue = true end
   end
   if next(ui_get(Multi)) == nil then
	   SetFalse()
   end
end

local function SyncMenu()
   if ui_get(Enabled) then
	   Sync()
	   if UseSkinsList then
		   ui_set_visible(SkinList, true)
		   ui_set_visible(Skin, false)
	   else
		   ui_set_visible(SkinList, false)
		   ui_set_visible(Skin, true)
	   end

	   if CustomGapValue then
		   ui_set_visible(Slider, true)
	   else
		   ui_set_visible(Slider, false)
	   end

	   if ui_get(Weapon) == "Show More (List)" then
		   ui_set_visible(WeaponList, true)
	   else
		   ui_set_visible(WeaponList, false)
	   end

	   if HideNameChange then
		   ui_set(ClanTag, false)
		   ui_set_visible(ChatSpam, true)
	   else
		   ui_set_visible(ChatSpam, false)
	   end
   else
	   ui_set_visible(SkinList, false)
	   ui_set_visible(Slider, false)
	   ui_set_visible(WeaponList, false)
	   ui_set_visible(ChatSpam, false)
   end
end

local Button = ui_new_button("LUA", "A", "Set Name", function()
   local LocalPlayer  = entity_get_local_player()
   local ItemName	 = ui_get(Weapon)
   local SkinName	 = ui_get(Skin)
   local Message	  = MessageTypes[1]
   local TeamColor	= TeamColors[entity_get_prop(LocalPlayer, "m_iTeamNum")]
   local RarityColor  = RarityColors[ui_get(Rarity)]
   local GapValue	 = ui_get(Slider)
   local Char1		= ""
   local blankSpace   = "ᅠ"
   if ui_get(Weapon) == "Show More (List)" then ItemName = WeaponsTable[ui_get(WeaponList)+1] end
   if UnboxMessage then Message = MessageTypes[2] end
   if UseSkinsList then SkinName = SkinTable[ui_get(SkinList)+1] end
   local WeaponName   = table_contains(KnivesTable, ItemName) and "★ " or ""
   WeaponName		 = StatTrakWeapon and WeaponName .. "StatTrak™ " .. ItemName or WeaponName .. ItemName

   if CustomGapValue then
		Char1 = string_rep(blankSpace, GapValue)
   else
		Char1 = "\u{2028}"
   end

   ui_set(NameSteal, true)
   SetName("\n\xAD\xAD\xAD\xAD")

   client_delay_call(0, function()
	   if HideNameChange then
		   if ChatClean then 
			   if ui_get(ChatSpam) then
				   client_delay_call(0.01, client_exec, "Say " .. string_rep(" ﷽﷽", 40)) 
				   print("Spammed the chat in an attempt to hide the initial name change.")
			   end
		   end
	   end
   end)

   client_delay_call(0.3, function()
	   ChatClean = false
	   local autismName =  (Message .. RarityColor .. WeaponName .. " | " .. SkinName .. "\n" .. Char1)
	   if AutoDisconnect then
		   SetName(TeamColor .. OrigName .. "\x01 " .. autismName .. "? \x01")
		   client_delay_call(0.8, client_exec, "disconnect")
		   client_delay_call(5.2, function() 
			ui_set(Enabled, false)
				print("Automatically disconnected from the server after setting Skin-Name.")
			end)
	   elseif HideNameChange then
		   local TempOrig = OrigName
		   if string_len(OrigName) > 12 then TempOrig = string_sub(OrigName, 0, 12) print("Clamped the clantag to prevent fuck up on scoreboard :).") end
		   SetTag(TeamColor .. TempOrig .. " \n")
		   SetName("\n\x01" .. autismName .. "\x01You")
	   else
		   SetTag()
		   SetName(TeamColor .. OrigName .. "\x01 " .. autismName .. "\x01You")
	   end  
   end)
end)

local function HandleMenu()
   local BoxState = ui_get(Enabled)
   ui_set_visible(Multi, BoxState)
   ui_set_visible(Weapon, BoxState)
   ui_set_visible(Rarity, BoxState)
   ui_set_visible(Label, BoxState)
   ui_set_visible(Skin, BoxState)
   ui_set_visible(Button, BoxState)
   if BoxState then
	   OrigName = cvar.name:get_string()
	   HasRan   = true
   else
	   if HasRan == true then
		   SetTag()
		   SetName(OrigName)
		   SetFalse()
		   HasRan = false
	   end
   end
   SyncMenu()
end

local function CalledOnCombo()
   SyncMenu()
end
HandleMenu()
ui_set_callback(Multi, SyncMenu)
ui_set_callback(Weapon, CalledOnCombo)

local function revertName(e)
	local LocalPlayer = entity_get_local_player()
	local IsTeammate  = entity_get_prop(client_userid_to_entindex(e.userid), "m_iTeamNum") == entity_get_prop(LocalPlayer, "m_iTeamNum")
	local Attacker	= client_userid_to_entindex(e.attacker)
	if Attacker == LocalPlayer and IsTeammate then
		if AutoRevertName then
			ui_set(Enabled, false)
			print("Reverted name back to normal and disabled the main checkbox for the script.")
		end

		if AutoDisconnectD then
			ui_set(Enabled, false)
			client_exec("Disconnect")
			print("Disconnected from the server after reverting name.")
		end
	end
end

local function on_change(self)
	HandleMenu()
	local callback = ui_get(self) and client_set_event_callback or client_unset_event_callback
	callback("player_hurt", revertName)
end

client_set_event_callback("shutdown", function()
	ui_set(Enabled, false)
end)
on_change(Enabled)
ui_set_callback(Enabled, on_change)