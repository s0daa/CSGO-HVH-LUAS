local var_0_0 = {
	"Default",
	nil,
	"Crimson Assault",
	"Sharpened",
	"Insurgency",
	"A*D*8",
	"High Noon",
	"Death's Head Demolition",
	"Desert Fire",
	"LNOE",
	"Metal",
	"All I Want for Christmas",
	"IsoRhythm",
	"For No Mankind",
	"Hotline Miami",
	"Total Domination",
	"The Talos Principle",
	"Battlepack",
	"MOLOTOV",
	"Uber Blasto Phone",
	"Hazardous Environments",
	"Headshot",
	"The 8-Bit Kit",
	"I Am",
	"Diamonds",
	"Invasion!",
	"Lion's Mouth",
	"Sponge Fingerz",
	"Disgusting",
	"Java Havana Funkaloo",
	"Moments CSGO",
	"Aggressive",
	"The Good Youth",
	"FREE",
	"Life's Not Out To Get You",
	"Backbone",
	"GLA",
	"III-Arena",
	"EZ4ENCE",
	"The Master Chief Collection",
	"Scar",
	"Anti Citizen",
	"Bachram",
	"Gunman Taco Truck",
	"Eye of the Dragon",
	"M.U.D.D. FORCE",
	"Neo Noir",
	"Bodacious",
	"Drifter",
	"All for Dust",
	"Hades Music Kit",
	"The Lowlife Pack",
	"CHAIN$AW.LXADXUT.",
	"Mocha Petal",
	"~Yellow Magic~",
	"Vici",
	"Astro Bellum",
	"Work Hard, Play Hard",
	"KOLIBRI",
	"u mad!",
	"Flashbang Dance",
	"Heading for the Source",
	"Void",
	"Shooters",
	"dashstar*",
	"Gothic Luxury",
	"Lock Me Up",
	"花脸 Hua Lian (Painted Face)",
	"ULTIMATE"
}

ui.new_label("LUA", "B", "Music Kits")

local var_0_1 = ui.new_listbox("LUA", "B", "Music Kits", var_0_0)

local function var_0_2()
	if entity.get_local_player() ~= nil then
		local var_1_0 = entity.get_local_player()
		local var_1_1 = ui.get(var_0_1)
		local var_1_2 = var_1_1 == 0 and 1 or var_1_1 + 2

		if entity.get_prop(entity.get_player_resource(), "m_nMusicID", var_1_0) ~= var_1_2 then
			entity.set_prop(entity.get_player_resource(), "m_nMusicID", var_1_2, var_1_0)
		end
	end
end

ui.set_callback(var_0_1, var_0_2)
client.set_event_callback("round_start", var_0_2)
