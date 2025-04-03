local ref = { }

ref.kill_say = menu.add_checkbox("killsay", "enable", false)
ref.kill_say_text = menu.add_text_input("killsay", "custom phrases")
ref.kill_say_mode = menu.add_selection('phrases', 'mode', { 'incremental', 'random' })
ref.kill_say_phrases = menu.add_list('phrases', 'phrases', { })
ref.kill_say_add = menu.add_button('killsay', 'add', function()
    local text = ref.kill_say_text:get()
    if text ~= "" then
        local phrases = ref.kill_say_phrases:get_items()
        table.insert(phrases, text)
        ref.kill_say_phrases:set_items(phrases)
    end
end)
ref.kill_say_remove = menu.add_button('killsay', 'remove', function()
    local phrases = ref.kill_say_phrases:get_items()
    local index = ref.kill_say_phrases:get()
    if index ~= -1 or index > #phrases then
        table.remove(phrases, index)
        ref.kill_say_phrases:set_items(phrases)
    end
end)

local get_phrase = function()
    local phrases = ref.kill_say_phrases:get_items()
    if #phrases == 0 then return "" end

    if ref.kill_say_mode:get() == 2 then
        return phrases[math.random(0, #phrases)]
    else
        local phrase = phrases[ref.kill_say_phrases:get()]
        if ref.kill_say_phrases:get() + 1 > #phrases then
            ref.kill_say_phrases:set(0)
        else
            ref.kill_say_phrases:set(ref.kill_say_phrases:get() + 1)
        end
        return phrase
    end
end

local last_chat_time = 0
local on_player_death = function(event)
    if not ref.kill_say:get() then return end

    local userid, attackerid = event.userid, event.attacker
    if not userid or not attackerid then return end

    local victim, attacker, local_player = entity_list.get_player_from_userid(userid), entity_list.get_player_from_userid(attackerid), entity_list.get_local_player()
    if not victim or not attacker or not local_player then return end

    if attacker == local_player and victim ~= local_player then
        if game_rules.get_prop("m_bIsValveDS") and (last_chat_time > global_vars.cur_time() + 0.3) then
            return 
        end

        local phrase = get_phrase()
        if phrase == '' then return end

        engine.execute_cmd(('say "%s"'):format(phrase)
    end
end

local on_player_chat = function(event)
    local player = event.entity
    if not player or (not game_rules.get_prop("m_bIsValveDS")) then return end

    if player == entity_list.get_local_player() then
        last_chat_time = global_vars.cur_time()
    end
end

callbacks.add(e_callbacks.EVENT, on_player_chat, "player_chat")
callbacks.add(e_callbacks.EVENT, on_player_death, "player_death")