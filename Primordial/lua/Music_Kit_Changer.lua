local menu_items = {
    kit_selector = menu.add_list("Music kit changer", "Kit", {
        "Crimson Assault by Daniel Sadowski",
        "Sharpened by Noisia",
        "Insurgency by Robert Allaire",
        "A*D*8 by Sean Murray",
        "High Noon by Feed Me",
        "Death's Head Demolition by Dren",
        "Desert Fire by Austin Wintory",
        "LNOE by Sasha",
        "Metal by Skog",
        "All I Want for Christmas by Midnight Riders",
        "IsoRhythm by Matt Lange",
        "For No Mankind by Mateo Messina",
        "Hotline Miami by Various Artists",
        "Total Domination by Daniel Sadowski",
        "The Talos Principle by Damjan Mravunac",
        "Battlepack by Proxy",
        "MOLOTOV by Ki:Theory",
        "Uber Blasto Phone by Troels Folmann",
        "Hazardous Environments by Kelly Bailey",
        "II-Headshot by Skog",
        "The 8-Bit Kit by Daniel Sadowski",
        "I Am by AWOLNATION",
        "Diamonds by Mord Fustang",
        "Invasion! by Michael Bross",
        "Lion's Mouth by Ian Hultquist",
        "Sponge Fingerz by New Beat Fund",
        "Disgusting by Beartooth",
        "Java Havana Funkaloo by Lennie Moore",
        "Moments CSGO by Darude",
        "Aggressive by Beartooth",
        "The Good Youth by Blitz Kids",
        "FREE by Hundreth",
        "Life's Not Out To Get You by Neck Deep",
        "Backbone by Roam",
        "GLA by Twin Atlantic",
        "III-Arena by Skog",
        "EZ4ENCE by The Verkkars",
        "The Master Chief Collection by Halo",
        "King, Scar by Scarlxrd",
        "Anti-Citizen by Half-Life: Alyx",
        "Bachram by Austin Wintory",
        "Gunman Taco Truck by Dren",
        "Eye of the Dragon by Daniel Sadowski",
        "M.U.D.D. FORCE by Tree Adams and Ben Bromfield",
        "Neo Noir by Tim Huling",
        "Bodacious by Sam Marshall",
        "Drifter by Matt Levine",
        "All for Durst by Amon Tobin",
        "Hades Music Kit by Darren Korb",
        "The Lowlife Pack by Neck Deep",
        "CHAIN$AW-LXADXUT by Scarlxrd",
        "Mocha Petal by Austin Wintory",
        "~Yellow Magic~ by Chipzel",
        "VICI by Freaky DNA",
        "Astro Bellum by Jesse Harlin",
        "Work Hard, Play Hard by Laura Shigihara",
        "KOLIBRI by Sarah Schachner",
        "u mad! by bbno$",
        "Flashbang Dance by The Verkkars and n0thing",
        "Heading for the Source by 3kliksphilip",
        "Void by Humanity's Last Breath",
        "Shooters by Juelz",
        "dashstar* by Knock2",
        "Gothic Luxury by Meechy Darko",
        "Lock Me Up by Sullivan King",
        "花脸 Hua Lian (Painted Face) by Perfect World"

    })
}

local function OnUpdate(event)
    local lp = entity_list.get_local_player()
    if lp == nil then return end
    player_resource = lp:get_prop("CSPlayerResource")
    if player_resource == nil then return end
    if player_resource.get_prop("m_iMusicID", 1) ~= menu_items.kit_selector:get() + 2 then
        for i = 0, 4 do
            player_resource.set_prop("m_nMusicID", menu_items.kit_selector:get() + 2, i)
        end
    end
end


callbacks.add(e_callbacks.NET_UPDATE, OnUpdate)