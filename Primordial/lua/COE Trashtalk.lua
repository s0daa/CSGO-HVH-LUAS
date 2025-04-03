local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "COE Talk",
    phrases = {
        "1.",
        "чмо я тебя выебал как рюэн",
        "ez by coehvh",
        "фу, бездарь, где твоё iq?",
        "изи овнед бай классрум оф элит",
        "бегите, я конченый",
        "сосать дура 0 kd player",
        "АХПХААХПХАХПАХПХАХ ЕБАТЬ ТЫ УПАЛ",
        "COE > ALL HvH",
        "by qrnc x dayama x kiyotaka x qHaki4 (COE STAFF)",
        "nice aa выблядок",
        "1. здарова бездарь ебанный",
        "впитай мою пулю в ебало сын шалавы",
        "бля тебе с твоим плейстайлом стоит пойти в роблокс хвх",
        "owned by Classroom of Elite",
        "у тебя мозг иссуе, мудила",
        "ахпхаппа, иди нахуй. ",
        "падаешь от COE ебланище",
        "join in COE bitch",
        "ты не такой как я, ты не из COE",
        "u died by COE",
     
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