
-- Исправленный скрипт Trash Talk на Lua
-- Сообщения теперь корректно соответствуют событиям убийства или смерти

local kill_messages = { 
    "Найс попытка уебан", 
    "изи", 
    "даже когда тебе везет я тебя ебу, задумайся", 
    "почему еще не купил мой кфг?", 
    "пиздец даже моя бабка лучше муваеться", 
    "блять кого я убил че за чпошник", 
    "www.youtube.com/watch?v=k4Tpy3a2cso",
	"Я не понял почему ты еще не ливнул ",	
	"фу блэ че за нефора убил",
	"мдэээ нахуй на отброса пулю потратил",
	"не вижу где у тебя пуля а не увидел",
	"видешь пожар? это так твоя мамка горит",
	"ливай пока не обоссали",
	"фу ебать ты немощь"
}

local death_messages = { 
    "блять ебать тебя в глотку немощь", 
    "сукаа лакерная", 
    "везение твое второе имя", 
    "ай ну и похуй", 
    "ладно", 
	"бля ну я ведь не смогу убить полоумного", 
    "радуйся ведь тебе повезло убить меня" 
}

local function delayed_message(message, delay)
    client.delay_call(delay, function()
        client.exec("say " .. message)
    end)
end

client.set_event_callback("player_death", function(event)
    local attacker = client.userid_to_entindex(event.attacker)
    local victim = client.userid_to_entindex(event.userid)
    local local_player = entity.get_local_player()

    if attacker == local_player then
        -- Вы убили кого-то
        delayed_message(kill_messages[client.random_int(1, #kill_messages)], 1) -- Сообщение для убийства
    elseif victim == local_player then
        -- Вас убили
        delayed_message(death_messages[client.random_int(1, #death_messages)], 1) -- Сообщение для смерти
    end
end)
