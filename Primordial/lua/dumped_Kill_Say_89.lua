local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "Default",
    phrases = {
        "1",
 
    }
})

table.insert(kill_say.phrases, {
    name = "Anime lewd",
    phrases = {
        "1 за кортеза",
        "1 за идк",
        "1 за корсу",
        "1 за блухгенг",
        "1 за эпсилона",
        "1 за godeless2020",
        "1 за нищих",
        "1 за сыновей шлюх",
        "1 за нищих подзаборных даунов",

    }
})

ui.group_name = "Kill Say"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Kill Say", false)

ui.current_list = menu.add_selection(ui.group_name, "Phrase List", (function()
    local tbl = {}
    for k, v in pairs(kill_say.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

kill_say.player_death = function(event)

    if event.attacker == event.userid or not ui.is_enabled:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[ui.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")