local client_set_event_callback, client_unset_event_callback = client.set_event_callback, client.unset_event_callback
local entity_get_local_player, entity_get_player_weapon, entity_get_prop = entity.get_local_player, entity.get_player_weapon, entity.get_prop

label4 = ui.new_label('PLAYERS', 'Adjustments', '----------------------')
local trashtalk = ui.new_checkbox('PLAYERS', 'Adjustments', 'Trash Talk')

local killsay_pharases = {
    {'⠀1', 'nice iq'},
    {'cgb gblfhfc', 'спи пидорас'},
    {'пздц', 'игрок'},
    {'1 моча', 'изи'},
    {'куда ты', 'сынок ебаный'},
    {'найс аа хуесос', 'долго делал?'},
    {'ебать что', 'как я убил ахуеть'},
    {'over all pidoras'},
    {'nice iq', 'churka)'},
    {'1 чмо', 'нищий без майтулса'},
    {'лол', 'как же я тебя выебал'},
    {'че за луашку юзаешь'},
    {'чей кфг юзаешь'},
    {'найс айкью', 'хуесос'},
    {']f]f]f]f]f]f]', 'хахахаха'},
    {'jq ,kz', 'ой бля', 'найс кфг уебище'},
    {'jq', 'я в афк чит настраивал хаха'},
    {'какой же у тебя сочный ник'},
    {'хуйсос анимешный', 'думал не убью тебя?)'},
    {'моча ебаная', 'кого ты пытаешься убить'},
    {'mad cuz bad?', 'hhhhhh retardw'},
    {'учись пока я жив долбаеб'},
    {'еблан', 'включи монитор'},
    {'1', 'опять умер моча'},
    {'egc', 'упссс', 'сорри'},
    {'хахаха ебать я тебя трахнул'},
    {'nice iq', 'u sell'},
    {'изи шлюха', 'че в хуй?'},
    {'получай тварь ебаная', 'фу нахуй'},
    {']f]f]f]f]f]]f]f', 'как же мне похуй долбаеб'},
    {'изи моча', 'я ору с тебя какой же ты сочный'},
    {'ez owned', 'weak dog + rat'},
    {'пиздец ты легкий ботик'},
    {'1', 'не отвечаю?', 'мне похуй'},
    {'как же мне похуй', 'ботик'},
    {'retard', 'just fucking bot'},
    {'♕ M Y T O O L S > A L L ♕'},
    {'нюхай пятку сын шаболды ёбаной','сосешь хуже мегионских цыпочек'},
    {'омг nice small pisunchik','ты нихуя не ледженд'},
    {'OWNED, сын шлюхи ёбаной','позволь моей писечке исследовать недры шахты твоей матери'},
    {'целуй писичку fucking no legend','твоя писичка такая же маленькая как и iqshe4ka'},
    {'в следущей раз выйграешь ледженда','Are you legend? ','ВЫ ТАКОЙ ЖЕ ТАНЦОР КАК ЛЯСТИЧКИ NOLEGENDICKI'},
    {'Твоя мать такая же жирная как idle nolegend (140)','накончал на твою лысинку она как у батька шамелисика'},
    {'твоя мамаша приготовила мне вкусные бутербродики как у gachi nolegend','ты очень хорошо лижешь пяточки научи клокедика legendicka'},
    {'шлюха ебаная так же сдохла как бабка фиппа и маута','сын шлюхи у тебя такие же компьютерики как у vanino nolegend'},
    {'твоя мамаша лижет мороженное ой блять это же моя писечка','у твоей матери такая же узкая пизда как глаза d4ssh legend'},
    {'ты такой же ебаный пес как  l4fn nolegend','мда играешь ты конечно хуево не то что virtual legendick'},
    {'разбомбил тебе ебасосину как бомбят walper nolegend','ты никогда не будешь legend с такой small pise4ka'},
    {'пока ты сосешь хуй мы чилим на острове legendickov','шлюха ебаная так же сдохла как бабка фиппа и маута'},
    {'хочешь купить config by legendick? ПОШЕЛ НАХУЙ СЫН ШЛЮХИ ЁБАНОЙ','ЭХХХ КАК ЖЕ АХУЕННО СОСЕТ ТВОЯ МАМАША МОЙ PISUN4IK'},
    {'e1','рандерандерандеву твоя мать шлюха сосала наяву','пузо твоей матери шлюхи такое же большое как у shirazu nolegend'},
    {'АХАХХАА БЛЯ ЧЕЛ ТЫ ИГРАЕШЬ ХУЖЕ HOLATV','NEW META FUCKING NO LEGEND?','ебать я тя ебнул как бабку маута'},
    {'СОСИ ХУЙ ПЛАКСА ЁБАНАЯ','ИЗВИНЯЙСЯ СЫН ШЛЮХИ ЁБАНОЙ','шлюха ебаная так же сдохла как бабка фиппа и маута'},
    {'ВЫЕБАНА В ПОПЭПНЦИЮ FUCKING NO LEGEND','ЁБАНЫЙ СЫН ШЛЮХИ ТЫ ХОЧЕШЬ КАК ВИТМА И СТИВАХА МНЕ ПРОЕАТЬ'},
}
    
local death_say = {
    {'ну фу', 'хуесос'},
    {'что ты делаешь', 'моча умалишенная'},
    {'бля', 'я стрелял вообще чи шо?'},
    {'чит подвел'},
    {'БЛЯЯЯЯЯЯЯЯЯЯЯЯТЬ', 'как же ты меня заебал'},
    {'ну и зачем', 'дал бы клип', 'пиздец клоун'},
    {'ахахахах', 'ну да', 'опять сын шлюхи убил бестолковый'},
    {'м', 'пон)', 'найс чит'},
    {'да блять', 'какой джиттер поставить сука'},
    {'ну фу', 'ублюдок', 'ебаный'},
    {'да сука', 'где тимейты блять', 'как же сука они меня бесят'},
    {'lf ,kznm', 'да блять', 'опять я мисснул'},
    {'да блять', 'ало', 'я вообще стрелять буду нет'},
    {'хех', 'ты сам то хоть понял', 'как меня убил'},
    {'сука', 'опять по дезу ебаному'},
    {'бля', 'клиентнуло', 'лаки'},
    {'понятно', 'ик ак ты так играешь', 'еблан бестолковый'},
    {'ну блять', 'он просто пошел', 'пиздец'},
    {'&', 'и че это', 'откуда ты меня убил?'},
    {'тварь', 'ебаная', 'ЧТО ТЫ ДЕЛАЕШЬ'},
    {'YE LF', 'ну да', 'хуесос', 'норм играешь'},
    {'сочник ебаный', 'как же ты меня заебал уже', 'что ты делаешь'},
    {'хуевый без скита', 'как ты меня убиваешь с пастой своей'},
    {'подпивас ебаный', 'как же ты меня переиграл'},
    {'бля', 'признаю, переиграл'},
    {'как ты меня убиваешь', 'ебаный owosh'},
    {'дефектус че ты делаешь', 'пиздец'},
    {'хуйсосик анимешный', 'как ты убиваешь', 'эт пздц'},
    {'бля ну бро', 'посмотри на мою команду', 'это пзиидец'},
    {'ммм', 'хуесосы бездарные в команде'},
    {'ik.[f', 'шлюха пошла нахуй'},
    {'ndfhm t,fyfz', 'тварь ебаная как же ты меня бесишь'},
    {'фу нахуй', 'опять в бекшут'},
    {'только так и умеешь да?', 'блядь ебаная'},
    {'нахуй ты меня трешкаешь', 'шлюха ебаная'},
    {'ну повезло тебе', 'дальше то что хуесос'},
    {'ебанная ты мразь', 'которая мне все проебала'},
    {'ujcgjlb', 'господи', 'мразь убогая'},
    {'хахахах', 'ну бля заебись фристенд в чите)'},
    {'фу ты заебал конч'},
    {')', 'хорош)'},
    {'норм трекаешь', 'ублюдина'},
    {'а че', 'хайдшоты на фд уже не работают?'},
    {'всмысле', 'ты же ебучий иван золо', 'ты как играть научился?'}
}

    
client.set_event_callback('player_death', function(e)
    delayed_msg = function(delay, msg)
        return client.delay_call(delay, function() client.exec('say ' .. msg) end)
    end

    local delay = 2.3
    local me = entity_get_local_player()
    local victim = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)

    local killsay_delay = 0
    local deathsay_delay = 0

    if (victim ~= attacker and attacker == me) then
        local phase_block = killsay_pharases[math.random(1, #killsay_pharases)]

            for i=1, #phase_block do
                local phase = phase_block[i]
                local interphrase_delay = #phase_block[i]/24*delay
                killsay_delay = killsay_delay + interphrase_delay

                delayed_msg(killsay_delay, phase)
            end
        end
            
    if (victim == me and attacker ~= me) then
        local phase_block = death_say[math.random(1, #death_say)]

        for i=1, #phase_block do
            local phase = phase_block[i]
            local interphrase_delay = #phase_block[i]/20*delay
            deathsay_delay = deathsay_delay + interphrase_delay

            delayed_msg(deathsay_delay, phase)
        end
    end
end)