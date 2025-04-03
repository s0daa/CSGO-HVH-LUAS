local gui = {}

gui.kills = menu.add_text_input("scoreboard changer", "kills")
gui.deaths = menu.add_text_input("scoreboard changer", "deaths")
gui.assists = menu.add_text_input("scoreboard changer", "assists")

gui.mvp = menu.add_text_input("scoreboard changer", "mvp")
gui.score = menu.add_text_input("scoreboard changer", "score")

gui.rank = menu.add_selection("scoreboard changer", "rank",
    {"None", "Silver I", "Silver 2", "Silver III", "Silver IV", "Silver Elite", "Silver Elite Master", "Gold Nova I",
     "Gold Nova II", "Gold Nova III", "Gold Nova Master", "Master Guardian I", "Master Guardian II",
     "Master Guardian Elite", "DMG", "Legendary Eagle", "Legendary Eagle Master", "Supreme Master", "Global Elite"})

gui.private_rank = menu.add_selection("scoreboard changer", "private rank",
    {"None", "Private Rank 1", "Private Rank 2", "Private Rank 3", "Private Rank 4", "Corporal Rank 5",
     "Corporal Rank 6", "Corporal Rank 7", "Corporal Rank 8", "Sergeant Rank 9", "Sergeant Rank 10", "Sergeant Rank 11",
     "Sergeant Rank 12", "Master Sergeant Rank 13", "Master Sergeant Rank 14", "Master Sergeant Rank 15",
     "Master Sergeant Rank 16", "Sergeant Major Rank 17", "Sergeant Major Rank 18", "Sergeant Major Rank 19",
     "Sergeant Major Rank 20", "Lieutenant Rank 21", "Lieutenant Rank 22", "Lieutenant Rank 23", "Lieutenant Rank 24",
     "Captain Rank 25", "Captain Rank 26", "Captain Rank 27", "Captain Rank 28", "Major Rank 29", "Major Rank 30",
     "Major Rank 31", "Major Rank 32", "Colonel Rank 33", "Colonel Rank 34", "Colonel Rank 35",
     "Brigadier General Rank 36", "Major General Rank 37", "Lieutenant General Rank 38", "General Rank 39",
     "Global General Rank 40"})

gui.apply = menu.add_button("scoreboard changer", "apply", function()
    local player_index = entity_list.get_local_player():get_index()

    player_resource.set_prop("m_iKills", tonumber(gui.kills:get()), player_index)
    player_resource.set_prop("m_iDeaths", tonumber(gui.deaths:get()), player_index)
    player_resource.set_prop("m_iAssists", tonumber(gui.assists:get()), player_index)

    player_resource.set_prop("m_iMVPs", tonumber(gui.mvp:get()), player_index)
    player_resource.set_prop("m_iScore", tonumber(gui.score:get()), player_index)

    player_resource.set_prop("m_iCompetitiveRanking", gui.rank:get() - 1, player_index)
    player_resource.set_prop("m_nPersonaDataPublicLevel", gui.private_rank:get() - 1, player_index)
end)

callbacks.add(e_callbacks.SHUTDOWN, function()
end)