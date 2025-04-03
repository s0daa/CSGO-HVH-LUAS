local welcome = [[
    
      ______      _____      ______       __         __         ______    ______     __         __  __    
     /\__   _\   /\  == \   /\  __ \     /\ \       /\ \       /\__  _\  /\  __ \   /\ \       /\ \/ /    
     \/_/\ \/   \  \  __<   \ \ \/\  \   \ \ \____  \ \ \____  \/_/\ \/  \ \  __ \  \ \ \____  \ \  _"-.   
        \ \_\    \  \_\ \_\  \ \______\   \ \_____\  \ \_____\    \ \_\   \ \_\ \_\  \ \_____\  \ \_\ \_\ 
         \/_/     \ /_/ /_/   \/_____ /    \/_____/   \/_____/     \/_/    \/_/\/_/   \/_____/   \/_/\/_/
                                                                                & server connector


     # primordial.dev | FREE LUA
                                                                                                
]]

local panorama = require 'primordial/panorama-library.248'
local troll_talk = {}
local menu_info = {}
local gui = {}
local build = "pub280922"

troll_talk.phrases = {}

print(welcome)
client.log(color_t(0, 255, 0), "license: " .. user.name .. " - " .. user.uid)
client.log(color_t(0, 222, 0), "build: " .. build .. " | v1.8")

-- 1. SPAM
table.insert(troll_talk.phrases, {
    name = "TrollTalk [SPAM]",
    phrases = {"primordial.dev > best cheat", 
    "primordial.dev > don't be an orphan",
    "primordial.dev > сan you buy a cheat already?", 
    "primordial.dev > i'm tired of messing with you",
    "primordial.dev > buy and cheat will not miss", 
    "primordial.dev > buy a brain",
    "primordial.dev > buy skills",
    "primordial.dev > i will kill you without AA",
    "primordial.dev > wget invite, weak",
    "primordial.dev > stop flying away from the first bullet, buy a cheat",
    "primordial.dev > buy it or you'll be humiliated", 
    "primordial.dev > cheat buy, weak",
    "primordial.dev > all cheats", 
    "primordial.dev > stop sucking cocks, buy a cheat",
    "primordial.dev > look, there's a new update",
    "primordial.dev > neverlose.cc",
    "primordial.dev > gamesense.pub",
    "primordial.dev > fatality.win",
    "primordial.dev > i am your owner",
    "primordial.dev > latest technologies", 
    "primordial.dev > maybe wget prim?",
    "primordial.dev > best of the best",
    "primordial.dev > why is it so easy",
    "primordial.dev > large and frequent updates",
    "primordial.dev > stop being my slave",
    "primordial.dev > on media",
    "primordial.dev > you belong to me",
    "primordial.dev > you very noob",
    "primordial.dev > i am a god",
    "primordial.dev > get good",
    "primordial.dev > get primordial",
    "primordial.dev > buy and relax",
    "primordial.dev > maybe stop missing out?",
    "primordial.dev > you're a disgrace",
    "primordial.dev > quit the game with that K/D",
    "primordial.dev > do you have a brain?",
    "primordial.dev > ducarii god",

    }
})

-- 2. ABSURD RUSSIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [ABSURD RUSSIAN]",
    phrases = {"С другой стороны, сплочённость команды профессионалов не оставляет шанса для прогресса профессионального сообщества.",
    "Безусловно, понимание сути ресурсосберегающих технологий требует анализа распределения внутренних резервов и ресурсов.",
    "Кстати, реплицированные с зарубежных источников, современные исследования неоднозначны и будут смешаны с не уникальными данными.",
    "Принимая во внимание показатели успешности, убеждённость некоторых оппонентов предопределяет высокую востребованность форм.",
    "Ясность нашей позиции очевидна: современная методология разработки играет важную роль в формировании модели развития.",
    "Но современная методология разработки играет важную роль в формировании направлений прогрессивного развития.",
    "Принимая во внимание показатели успешности, перспективное планирование предполагает независимые способы реализации рассуждений.",
    "Как уже неоднократно упомянуто, базовые сценарии поведения пользователей объявлены нарушающими общечеловеческие нормы этики.",
    "С учётом сложившейся международной обстановки, убеждённость некоторых оппонентов прекрасно подходит для реализации участия.",
    "В частности, сплочённость команды профессионалов в значительной степени обусловливает важность укрепления моральных ценностей.",
    "А также акционеры крупнейших компаний, превозмогая сложившуюся непростую экономическую ситуацию.",
    "Прежде всего, дальнейшее развитие различных форм деятельности создаёт предпосылки для вывода текущих активов.",
    "Есть над чем задуматься: базовые сценарии поведения пользователей объединены в целые кластеры себе подобных.",
    "Однозначно, реплицированные с зарубежных источников, современные исследования будут заблокированы в рамках своих ограничений.",
    "Имеется спорная точка зрения, гласящая примерно следующее: тщательные исследования конкурентов ассоциативно распределены.",
    "Господа, высококачественный прототип будущего проекта выявляет срочную потребность дальнейших направлений развития.",
    "Вот вам яркий пример современных тенденций — сложившаяся структура организации обеспечивает актуальность поставленных задач", 
    "Кстати, базовые сценарии поведения пользователей подвергнуты целой серии независимых исследований.",
    "Также как семантический разбор внешних противодействий прекрасно подходит для реализации дальнейших направлений развития!",
    "А также ключевые особенности структуры проекта и по сей день остаются уделом либералов, которые жаждут быть обнародованы.",
    "Следует отметить, что внедрение современных методик выявляет срочную потребность укрепления моральных ценностей.",
    "Кстати, активно развивающиеся страны третьего мира объективно рассмотрены соответствующими инстанциями.",
    "Лишь элементы политического процесса лишь добавляют фракционных разногласий и разоблачены.",
    "В частности, сплочённость команды профессионалов требует от нас анализа экспериментов, поражающих по своей масштабности.",
    "Лишь базовые сценарии поведения пользователей рассмотрены исключительно в разрезе маркетинговых и финансовых предпосылок.",
    "Но действия представителей оппозиции лишь добавляют фракционных разногласий и разоблачены!",
    "В частности, сложившаяся структура организации способствует подготовке и реализации прогресса профессионального сообщества.",
    "Господа, высококачественный прототип будущего проекта играет определяющее значение для глубокомысленных рассуждений.",
    "Но реализация намеченных плановых заданий позволяет оценить значение направлений прогрессивного развития.",
    "А также непосредственные участники технического прогресса неоднозначны и будут описаны максимально подробно.",
    "Предварительные выводы неутешительны: граница обучения кадров создаёт предпосылки для вывода текущих активов.",
    "Каждый из нас понимает очевидную вещь: повышение уровня гражданского сознания не оставляет шанса для модели развития.",
    "Задача организации, в особенности же выбранный нами инновационный путь требует определения и уточнения благоприятных перспектив.",
    "В целом, конечно, консультация с широким активом способствует подготовке и реализации своевременного выполнения сверхзадачи.",
    "Внезапно, явные признаки победы институционализации ассоциативно распределены по отраслям!",
    "Повседневная практика показывает, что новая модель организационной деятельности говорит о возможностях форм воздействия.",
    "С другой стороны, социально-экономическое развитие способствует повышению качества модели развития.",
    "Для современного мира разбавленное изрядной долей эмпатии, рациональное мышление обеспечивает актуальность форм воздействия.",
    "А ещё активно развивающиеся страны третьего мира неоднозначны и будут своевременно верифицированы.",
    "Но явные признаки победы институционализации неоднозначны и будут представлены в исключительно положительном свете.",
    "Безусловно, дальнейшее развитие различных форм деятельности способствует реализации соответствующих условий активизации.",
    "Есть над чем задуматься: базовые сценарии поведения пользователей представлены в исключительно положительном свете.",
    "Лишь независимые государства неоднозначны и будут обнародованы.",
    "Следует отметить, что сложившаяся структура организации не оставляет шанса для системы массового участия.",
    "И нет сомнений, что сделанные на базе интернет-аналитики выводы будут в равной степени предоставлены сами себе.",
    "Лишь элементы политического процесса, вне зависимости от их уровня, должны быть описаны максимально подробно.",
    "В целом, конечно, синтетическое тестирование требует определения и уточнения системы массового участия.",
    "Не следует, однако, забывать, что экономическая повестка сегодняшнего дня позволяет оценить значение направлений.",
    "Предварительные выводы неутешительны: существующая теория создаёт предпосылки для укрепления моральных ценностей.",
    "А также действия представителей оппозиции рассмотрены исключительно в разрезе маркетинговых и финансовых предпосылок.",
    "Но диаграммы связей, инициированные исключительно синтетически, разоблачены.",
    "В целом, конечно, дальнейшее развитие различных форм деятельности напрямую зависит от модели развития.",
    "Ясность нашей позиции очевидна: консультация с широким активом прекрасно подходит для реализации модели развития.",
    "Для современного мира перспективное планирование требует анализа системы массового участия.",
    "Безусловно, сложившаяся структура организации требует от нас анализа вывода текущих активов.",
    "Являясь всего лишь частью общей картины, ключевые особенности структуры проекта призваны к ответу.",
    "А также тщательные исследования конкурентов преданы социально-демократической анафеме.",

    }
})

-- 3. SPECIAL RUSSIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [SPECIAL RUSSIAN]",
    phrases = {"девушка это очень легко как раз что и машина торетто такая же простая но гиф это все же необычное событие 2013 года",
    "это ты на каком языке разговаривать начал, мне интересно",
    "сто рублей значит? убедил убраться дома но я конечно же живу Москва мой дом",
    "мне кажется что земля на самом деле квадратная, потому что я когда хожу я как будто чувствую левитациб как бута падаю в пропаст",
    "мне кажется земля параллелепипед ибо потому что когда я самолёт то масло стекает вниз но почему? я математические символы обожаю..",
    "ещё я недавно заметил такое интересное явление если ты покакаеш и долго будешь сидеть а туалете а говно засохнет на унитазе черкаш",
    "после смерти мы все увидим цветы жизни. я обещаю Москва будет основным государством жизни проживания в Китае",
    "нет, земля это воздух потому что когда я прыгаю я начинаю цепляется за воздух и мне это помогает высоко забраться только вверх",
    "все же я довольно хорошо принюхиваюсь к воздуху и понимаю что земля овальная и держится на хвосте одного хомяка",
    "настройки хвоста хомяка позволяют управлять cамолётом ac130 и истребителями России но Китай = США поэтому скит такой дорогой..",
    "если ты не знал вопрос это всего лишь слово на которое есть ответ",
    "всё же не понимаю что будет если яблоко съест собака..",
    "есть ли ответ на то что скит это кот в душе и на самом деле он падает на коробки?",
    "на самом деле я могу ментально сейчас подорвать карту мираж и доллар станет дороже в 2 раза",
    "а самое смешное то что если я начну щелкать пальцами то вы сможете увидеть радугу",
    "на самом деле повышения тона голоса зависит от стоимости на 12 айфон",
    "думаю с неверлузом все хорошо потому что когда яблоко с дуба падает начинается ядерная война",
    "скит вообще удивительная вещь когда начинаешь сидеть чтото писать и у тебя кончаются чернила понимаешь что твоя мать шлюха",
    "ну самое конечно же веселое это когда ты едешь по дороге и видишь как в квартире живут люди сажая своего ребенка на унитазный ёршик",
    "отец зайдя ко мне в квартиру, сказал что его первый вопрос будет такой что делает этот КАМАЗ в углу моей команты",
    "в камоде лежит запас семечек на тот случай когда Байден начнет принимать таблетки",
    "когда шестерёнка крутится с каждым ее оборотом наркотиков оружия и т.д умирает 3 человека от СПИДа",
    "прелестно, сказал Штирлиц бросьте ваши дурацкие шутки",
    "сегодня седьмое число 13 месяца и именно вчера меня осинило то что скит самый лучший чит на Плутоне",
    "спутник Ситилинк упал на мою ладонь перевернув всю планету",
    "нужно глубоко поразмыслить над поведением твоего питомца.. не просто так камаз аллен был джейсоном убийцей на самом деле?",
    "лежал я как-то на батарее и задался вопросом почему же Рэй Аллен играет с примордиал",
    "господи прости за то что я сейчас написал прошу мама умоляю бабушка",
    "кстати я вчера лежал и вдруг бац и релизнулся неверлуз в2",
    "да я кароче бежал ну потом упал и всё больше нету чайника на сковородке!",
    "капец крч мобилизировали соуфива",
    "я как чайник только умею летать вместе с ножами на машине аирбус",

    }
})

-- 4. RUSSIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [RUSSIAN]",
    phrases = {"слабак", "бери мой член себе в рот", "атсоси мне тут", "терпи", "жалкий", "ты телка",
    "лол тя в likee снял", "арууууу, Слит.", "не ной", "1", "вылил тваей матери на ебальник кипяток)",
    "атца тваево трахали", "тряпка", "ти сегодня мозг собираешся юзать?)", "проколол твоему отцу глаз нах",
    "твая мама на моём хую верх вниз))", "гиперна сасеш мне", "в падвале сасеш", "твою мать на сваём хую катал",
    "на людях сасеш", "хуйем тя акупиравал", "куда улетел??!", "куда лезеш пидарас ебливый!", "твою мать в кейсе закрыл",
    "ору ти так смешно падаешь)))", "асвежись арамотом духов дольче кабана", "нервична сасеш мне",
    "нимножинька тваю маму вытрахал", "афармляй свой фирменный отсос)", "маму твою на трассе выкупил",
    "ахуеть я тя красиво в рот вытрахал!)", "ты сколько мне сливаться будеш ещё)", "хахахх нахуй тя",
    "паймал тваю мать на рыбаловный крючок..", "ты пабил рекорд по атсосам мне!)", "ты ебаная биомаса)",
    "чота мамку тваю убил нах))", "винтажна сасеш", "за гарами ипу тя", "твоя мамаша мне ещо в переулках сасала)",
    "так тя буквой г поеп чиста", "несчастна сасеш", "тваю мать за углом убили", "упал как бич ебаный ару чета",
    "вкалол в тваю маму бешенства)", "куда ти лезеш малой", "чета патух слабина?)0 хаха", "десинк джойнер ебаний",
    "вытери сваи слёзы слабак", "сфоткал труп тваей мамы", "ебу тя магией хз", "ты терпила ебаная",
    "нимножинька тваю мамулю убил", "гариш чота)", "чета ты вяленький хз ебу тя(9", "не умирай сын шлюхи)",
    "твой чит made in China", "жри корм))", "пагуляй падыши воздухом", "ты же атсосешь тут сынок шлюхи хаха!",
    "нимножинька тваего атца арматурай атпиздил", "ну слабак куда ты убегаеш телочка?", "ты сынок трупа ебанава))",
    "пачитай гайды как играть ни знаю )", "300 кг ебу тя слабого оу ноу))!", "ты пиявка ебаная хуй отпусти",
    "я тя па IP вычислю!!", "немножинька атсасал мне", "вбил в тя свой хуй", "подсосись к хую моему",
    "расбил те ебала хуем", "просто трахаю тя слабейшего)00)", "нон-стопь сын шлюхи ахах", "спи бомж",
    "дубосил тя членам", "епать ти везжиш как сабака =)", "отродье шлюхи в чат скульни мине))",
    "пашел вон!", "школоло.", "атца тваего в мусарку выкинул", "шлюший сын проскулился перед моим оружием", -- венгерский
    "в хуй мне плач", "хех фемачку унизил))", "жир втяни или выкачай ару)0", "реще играй медляк ебаный",
    "тя при раждении в мусоропровод выкинули)", "ты зачем унижаешься, ливни нахуй с позором)0",
    "чета миссаешь слабачек", "чета убил тя", "мешок", "атсасал мне!!!!", "давай ускоряйся улитка ты ебаная ахах",
    "паучись сасать у сваей мамы", "ищи сибя в прашмандах масквы", "сперму глотай дочка шлюхи",
    "сперму аб твою кравать вытерал", "паскули))", "чета сасеш", "твая мать сасет забавна ару", "ипу тя лаха ару",
    "абассал тя тупитцу =)", "лоол как же я с тибя аруу", "че тухнешь сынишка шлюхи слабый",
    "залил те в рот мочу голубя)", "епать я топ", "хуясе в тя тапок прилетел)0", "падайдёш? тут твою мамзель ебут",
    "депортирован в ад к матушке шлюшечке", "чета упал", "залупой по губам те дрифтил хаха))",
    "иди паспи незнаю", "ару ну ты видел как я тя", "аутсайдер", "еу мухтар ты ебаный)",
    "ты в детдоме клювом об кафель бился??", "закрыли тя )", "слабака мамашу ебал чекайте",
    "к хахлам тя департировали", "хуем тибя щас пиздану)", "ты че сдуваешься слышиш ебать тузик ебаный епта)",
    "пизда тваей мамы радиактивна", "епать тя абасцал", "изи в 0!", "я тваю семейку на тот свет атправил XD)",
    "хуй мне палируй", "чета ти плоха сасёш", "пачему так легко))", "esc -> help & options -> how to play",
    "я тваей маме в тарелку драчил =))", "у тя ваще мозг есть?)", "ты сынок покойной шлюхи",
    "пачему ты хуй сасеш а потом пишеш что хуй сасать плоха", "ебало завали шестерка ебучая щас твае ебало под откос",
    "ебать мы тваю мамашку атпинали", "наа нахуй))", "trolltalk best talk",
    "куда те хвх )", "хуем тваю мамулю задушил", "твою мать на стуле резали",
    "может ти играть научишся ???", "спи нах дитё", "те руки отрезали нахуй??",
    "спустил прям на лицо тваей маме", "вышел в мир иной", "вырадок собаки",
    "без вапросав бери мой хуй се в ротик", "куда те да меня", "trolltalk.lua best",
    "тваю маму поездом переехала))", "патух твой батя =*", -- французский
    "я тваего атца ебал", "атсасал", "хех в нулину тя ваще", "я папулька а ты нн)",
    "твая мама в гараже задахнулась в гавняшках)", "ты алень ебучий", "гавгавгав чтоли)",
    "cасеш мне крутейшна", "епу тя как нада", "патухни ньюкам", "я тя бил шварцнигерйом",
    "епу тя как этой ночью))", "патухни украинец", "чета патух",
    "патух петух(", "патух 1", "атца тваево патушил", "текстом тя епу)",
    "закинул молик в пизду тваей матери))", "патушил тя)", "я щяс на тя натравлю керпич",
    "чета легко", "убил тя", "ну ты ваще попуск канечно",
    "тибя сделали на трасе путем секса за 20 грн)", "чета слаб",
    "атпизжен by primordial.dev", "ты точна челавек??",
    "вытираю сопли аб лицо тваей матери", "стёр тя в парашок",
    "тибя стоит паманить членом так ти сразу купишься на него",
    "твая мама была также убита", "прасти если выепал)", "падай",
    "как ьак палучаица я тя атпиздошил", "может купишь мозг?)",
    "на негативе ебал мать тваю ведь она заебала вырываться за что я ей уебал леща))",
    "ну чо будем твою мать ебать или ты апять решил мой хуй не с кем не делить??",
    "твою мать хуём высек за то что она твоему бати атсасать пыталась)",
    "не веришь мне что твая мамаша мой хуй безастановчно сосёт так приходи она даст те уроки отсоса ээ)",
    "я тваю дурную мамашу ща на хуе за такие движения проверну",
    "разворошил твою мамашку хуём и вынес от туда всё что можно",
    "твоя мать уже на мой хуй прыгает как на работу идёт",
    "твоя мамаша ща мой хуй за щеку пустила и не хочет высовывать",
    "не могу передать те чувства когда твоя спидозная мамаша мне сосёт",
    "без шуток если твоя мать не начнёт в темпе сосать я ей залупой по ебалу сезжу",
    "ты даже не заметишь как твоя мать на мой хуй жить переедет",
    "твоя мать легла под мой хуй и врёт что не может вылести)",
    "и чё твоя мать мне сосёт а ты немощ даже не можеш её заменить)",
    "ты думал что твоя мать на шалава мы её с пацанами за дворами хуями полосовали только не кому",
    "твоя мать уже давно на хуе моём сидит она думает что если пускает спермак по крови то это норма", -- болгарский
    "твою мать хуём так то до оргазма довёл а твой батя в это время в ахуе стоял",
    "твоя матуха с 5 лет на мой хуй малилась лявра ебучая)",
    "ты знал чо твою мать хуём из окна выкинул а она встала и дальше побежала?",
    "ты понимаешь, что клитор твоей матери это чрезвычайно опасная зона?",
    "я советую тебе пойти нахуй так как на большее чем отсос моего хуя ты не способен",
    "ты панимаешь чо я сейчас наматаю твой рот на свой член и задушу тебя нахуй?)",
    "эта всё на что ты способен сын шлюхи?) уйди нахуй не позорь свою мать шлюху)",
    "давай ты сейчас атсасешь мой хуй а потом я этим хуем выебу твою мать шлюху?!)",
    "твая мать очень обрадовалась когда я согласился ее бедняжку покормить своей спермой(",
        
    }
})

-- 5. UKRAINIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [UKRAINIAN]",
    phrases = {"Витери палі сльози слабак"," сфоткал труп тваей мами","ебу тя магією хз",
    "німножінька тваю мамулю вбив", "гаріш чота)"," подружжя ти в'яленький хз ебу тебе (9",
    "твій чит made in China", "жри корм))", "пагуляй падиші повітрям",
    "німножінька тваего атца арматурай атпізділ", " ну слабак куди ти втікаєш теличка?",
    "пачітай гайди як грати не знаю)", " 300 кг ебу тя слабкого оу ноу))!",
    "я тя па IP вирахую!!", "німножінька атсасал мені","вбив в тя свій хуй",
    "расбіл ті ебала хуем", "просто трахаю тя найслабшого) 00)",
    "дубосіл тя членам", " епать ти везжіш як сабака=)"," кодло повії в чат скучні міні))", " пашів геть!", "школоло.", "атца тваего в мусарку викинув",
    "в хуй мені плач", " хех фемачку принизив))", "жир втягни або викачай ару)0",
    "тебе при ражденіі в сміттєпровід викинули)", "ти навіщо принижуєшся, зливи нахуй з ганьбою) 0",
    "подружжя місаєш слабачек"," подружжя вбив тебе", "мішок",
    "павучись сасати у Палей мами","шукай сібя в прашмандах маскви",
    "сперму аб твою кравать витерал", " паскулі))"," подружжя сасеш"," твая мати сасет забавна ару", "ІПУ тя Лаха ару",
    "абасцал тя тупітцу =)", "лоол як же я з тібя аруу",
    "Залив ті в рот сечу голуба)", "епать я топ", "хуясе в тя тапок прилетів) 0",
    "депортований в пекло до матінки шлюшечке"," подружжя впав",
    "Іди паспорт незнаю", "ару ну ти бачив як я тебе",
    "ти в дитбудинку дзьобом об кахель бився??", "закрили тя )",
    "до хахлов тя департировали", "хрю-хрю", "хуем тибя щас пиздану)",
    "пизда тваей мами радіактивна"," епать тя абасцал", " Ізі в 0!",
    "хуй мені паліруй"," подружжя ти погана сасеш", " пачему так легко))",
    "я тваей мамі в тарілку драчив =))", "я украiнец хрю", " у тебе ваще мозок є?)",
    "пачему ти хуй сасеш а потім пишеш що хуй сасать погана",
    "ебать ми тваю матусю атпіналі"," ти мене абідел", "хрюк)",
    "куди ті хвх )", "хуем тваю матусю задушив",
    "може ти грати навчишся ???", "спи нах дитя",
    "спустив прям на обличчя твоїй мамі", "хрю", "вийшов в інший світ",
    "без вапросав бери мій хуй се в ротик", "куди ті та мене",
    "тваю маму поїздом переїхала))", "патух твій батя =*",
    "я тваего атца ебал", "атсасал", "хех в нулину тя ваще",
    "твая мама в гаражі задахнулась в гавняшках)",
    "сасеш мені крутейшна", "ЄПУ тебе як нада", "патухні ньюкам",
    "ЄПУ тя як цієї ночі))", "патухні українець", "подружжя патух",
    "патух ("," патух 1"," атца тваево патушил","текстом тя ЄПУ)",
    "закинув Молік в пизду тваей матері))", " патушил тя)",
    "подружжя легко"," убив тебе","ну ти ваще попуск канечно",
    "атпизжен by primordial.dev", "ти точна челавек??",
    "витираю соплі аб особа тваей матері", "стер тя в парашок",
    "тібя варто паманить членом так ти відразу купишся на нього",
        
    }
})

-- 6. BREAK AMERICAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [BREAK AMERICAN]",
    phrases = {"wuss", "suck me here", "bear with me", "pathetic", "you're a chick", "you're a pauper",
    "your father got fucked", "wuss", "are you gonna fuck with my brain today?", "trampled you",
    "your mom's on my dick, up and down.", "hypernasal sassing me.", "sassing me in the basement.",
    "in public, you sassed me,", "I fucked you up,", "where'd you go?!", "You rode my dick",
    "oroo you fall so funny))", "aswet by the aroma of dolce cabana perfume", "nervous sassesh me",
    "fucked your mother a little", "give me your trademark blowjob", "i tore your father's eye out",
    "I fucked you beautifully in the mouth!", "how much more of this shit are you gonna do to me?",
    "i got your mother on a fishing hook...", "you broke my sucking record!", "son of a fucking ant)",
    "you killed your mother...", "you're vintage...", "I'll fuck you up...", "you are worthless", 
    "that's how you fucked up clean", "miserable sassesh", "your mother was killed around the corner", "fell like a fucking scourge aru cheta",
    "poked your mother with rabies", "where are you going, kid", "chetah patuh weak?) 0 haha",
    "wipe your tears weakling", "took a picture of your mom's corpse", "fuck you with magic",
    "killed your mama a little bit", "you're a little bit gary", "you're a little bit sluggish", "I don't fucking know",
    "your cheat made in china", "eat your food", "walk the air", "you desyncjoiner(",
    "your daddy's armature fucked up", "wuss, where'd you run off to, girl?",
    "I don't know how to play!", "300 kg fuck you weak, oh no!", "esc -> help & options -> how to play",
    "I'm gonna find your IP!!", "you gave me a little pussy", "got my dick in you", 
    "smashed your dick with my dick", "just fucking you weakest",
    "fucked you with my dick", "fuck you like a dog =)", "brat of a whore to chat with me))",
    "get the fuck out!", "schoolboy.", "threw your father in the police department.",
    "fuck me cry", "heh fema humiliated)", "get fat or pump ara) 0",
    "you got thrown in the garbage chute at birth)", "why are you humiliating yourself, pour the fuck out in shame)0",
    "you're a pussy, you're a pussy", "you killed you", "sack",
    "learn to suck your mother's dick", "look for yourself in Moscow's mascovia",
    "sperm wiped on your mug", "passuli))", "cheta sasesh", "your mother sats funny aru", "Ipu tya laha aru",
    "abaszal you dumbass =)", "lool how I'm with you aruu.",
    "poured pigeon piss in your mouth", "fuck me top", "fuck you got a slipper in your mouth",
    "deported to motherfucking whore hell,", "fell down.",
    "go sleep with me", "aru, you've seen how I've seen you",
    "did you bang your beak on the tiles in the orphanage?", "they locked you up",
    "they deported you to the khahl", "i'm gonna fuck you up with a dick",
    "your mom's cunt is radioactive", "fuck you", "I'm fuckin' zero",
    "dick me paly", "you don't suck so good", "why is it so easy",
    "i puked in your mom's plate =))", "do you even have a brain?",
    "why do you suck a dick and then write that sucking a dick is bad",
    "we fuckin' kicked your mom", "you hurt my feelings.",
    "where the fuck did you go?", "you strangled your mother with your dick",
    "why don't you learn how to play???", "go to sleep, baby.",
    "got it right in your mom's face,", "gone to the next world.",
    "no questions asked, take my dick in your mouth", "where do you want me",
    "your mom got run over by a train", "your daddy's daddy =*",
    "i fucked your father", "you fucked me", "heh, fuck you",
    "your mom's in the garage shitting her pants",
    "you're a fucking badass", "I'm gonna fuck you up", "you're a fucking newcomer",
    "fuck you like this night))", "patukhni ukrainian", "cheta patukhni",
    "patuh(", "patuh 1", "atz your patuh", "fucking you with text",
    "threw a molly in your mother's cunt))", "patooted you)",
    "that's easy", "killed you", "you're a real pussy", "fuck you with text",
    "they made you on the track by having sex for 20 hryvnias", "you're weak",
    "you've been fucked by primordial.dev,", "are you sure you're a man?",
    "wiping snot on your mother's face", "wiped you out.",
    "you get lured by a dick, you'll buy it right away.",
    "your mother was also killed", "sorry if I fucked you",
    "how did I fuck you up?", "do you realize that your mother's clitoris is an extremely dangerous area?",
    "I advise you to go fuck yourself because you can't do more than suck my dick.",
    "do you understand that I'm about to wrap your mouth around my cock and strangle the fuck out of you?)",
    "that's all you're capable of, son of a whore?) go the fuck away, don't disgrace your whore mother)",
    "why don't you suck my dick and then I'll fuck your whore mother with it?)",
    "your mother was very happy when i agreed to feed her poor thing with my sperm(",

    }
})

-- 7. CURDISH
table.insert(troll_talk.phrases, {
    name = "TrollTalk [CURDISH]",
    phrases = {"Mîzê di devê min de rijand)", "Ez top dikenim", "Huyasa di dirûşmeyê de ket) 0",
    "Daxistin ku dojehê ji dayika çiyê", "Kevir qirêj e", "Hûn ji bo min pir lawaz in",
    "Herin ez nizanim", "aru baş te dît ku ez çawa me",
    "Hûn di ortan de bi bezek li ser tile bûn?",
    "To the Hachlahs hate dersînorkirin", "Dicky Tybi rast Pizdan)",
    "Pitika dayikê radyoyê", "ku jixweber tê xwarin", "Izi di 0!",
    "Pal Dick", "Heval Bad Sassyosh", "Pacem pir hêsan e))",
    "Min diya xwe li plakekê kir =))", "di dawiyê de mejî heye?)",
    "Dad You Dick Sashh û paşê dinivîse ku dîk xirab e", "Migo mêrhaba ji wera",
    "Fuck me dayika xwe li Atpinali", "Tie Me", "yê kûvî", "Lêrzî wêk bedana min ket",
    "Li ku derê wan XB) li ku derê", "Ez bi dîkek xwe bi dîk ketim",
    "Dibe ku hûn fêr bibin ka meriv çawa dilîze ???", "Xewa Neh bite",
    "Wî diya xwe rasterast ber bi rûyê xwe", "çû cîhanek din",
    "Bêyî Vagnes, dîk min di devê te de bîne", "Li ku derê Yes Me",
    "Ez dayika xwe bi trênê vekir)", "bavê te patetîk e", "Lêrzî wêk bedana min ket",
    "Min attza atsasal", "heh di dawiyê de di dawiyê de", "mina le bercekiye",
    "Dayikek li garazê xwe li Gavnyshki berevan kir)", "seba xatire min hatiye",
    "Consesh ji min re xweş e", "Epu, mîna Nada", "ket nav Newcom",
    "epu wekî vê şevê))", "patuhni ukrainian XD)", "cot patuh",
    "patuh(", "patuh, 1", "Attsea Twyevo Patuzhey", "Nivîsara epu)",
    "Molik avêtin nav pidiya diya xwe))", "patuhaî)",
    "Couple hêsan e", "Chai kuşt", "Welê, hûn di dawiyê de qebûl dikin",
    "Tybya li ser track ji hêla 20 uah ve hatî çêkirin)", "Heval qels e",
    "atpîzhen by primordial.dev", "Ti bi chela re rast e?",
    "Ez snotê rûyê dayikê digirîm", "Ez wê di parachusê de paqij dikim",
    "Tybya ew bi endam re hêja ye, ji ber vê yekê hûn ê yekser li wî bikirin",
    "Dayika Towing jî hate kuştin", "Prazhi heke min ew girt)",
    "Ma min çawa jarek dekek heye", "Nimnozhinka ya du Attz armatiyi Atpizdil", "Belê, qelsiyek ku hûn direvin?",
    "Rêbernameyên patchita ez dizanim çawa lîstin)", "300 kg qelsiya qels oh knou))!",
    "ez ê wê IP-ê hesab bikim!", "Dubedapî", "Van dîkên qirêj",
    "Patla It!", "shkololo eban0e)", "Attza Twa li Musarka avêtin", "Ma hûn hîn jî dikarin mêjiyê xwe bikirin?",
    "Li dîkek ku ez digirîm", "HYH ji jinê şermezar kir))", "Fat, Drag an Roll Out Out) 0",
    "Wan dema ku ew li hev ketin, ew avêtin nav garisan.",
    "Couple Missiz Simple", "Hevjîn Kevir", "bag", "Min çavên xwe li bavê xwe ohh xwar kir",
    "Li Pîla Momê bifroşe", "Siby li Maskva Prashmandy digerin", "Serê dayika we li dijî dîwêr belav bû",
    "Sperm ji we re tê dizîn", "pasculi))", "her çend sash", "dayika saset saset aura", "IPA Laha Ara",
    "Abaszal the Tu Tulk =)", "Lool, ez çawa bi Tybi Aruu re me",
    "Mîzê di devê min de rijand)", "Ez top dikenim", "Huyasa di dirûşmeyê de ket) 0",
    "Daxistin ku dojehê ji dayika çiyê", "Dayika te êrîşî koka min kir",
    "Herin ez nizanim", "aru baş te dît ku ez çawa me", "Li ser rûyê dayika xwe avê avê xwar",
    "Hûn di ortan de bi bezek li ser tile bûn?", "girtî)", "ez",
    "Qels", "jî min re li vir", "bîhnfireh", "xapînok", "tu çîçik",
    "Lol Tybye di Likee de hilkişiya", "Aruu ji hev tê", "naha", "1",
    "Attza Twaevo xeniqî", "TI Rak", "TI îro îro dê mêjî bikar bîne?)",
    "Dayika xwe li ser topa min xist)", "Hyperna Sases ji min re", "di nav sases padwal de",
    "Sasesh di gel", "Huyeme Akupir", "Ew li ku derê firiyan ??!",
    "Hûn ê bi vî rengî biqewimin)))", "ji xewa aramotê ruhên dola kaban", "Sasesh nerew e",
    "Nimnozhinka Ez ji dayika xwe re hat jêbirin", "AfarmLyai Supketa Pargîdaniya Wî",
    "Ahuh, min di devê xwe de xweşik hilweşand!)", "Ma ez çiqas ji min re dîsa meraq dikim)",
    "Paymal ez diya xwe li çokek masîvaniyê xist ..", "te tomar ji min re tomar kir!)",
    "Chota Mamka min nah kuşt))", "Vintage Sash", "li pişt Garah Ipu,",
    "Ji ber vê yekê tîpa G Paqijkirî ye", "Saziyên bêhêvî", "Ez li dora quncikê hatim kuştin", "mîna çirûskek Ara Fucking",
    "Min ew di diya diya xwe ya birçî de xist)", "piçûka piçûk e", "v 0 haha",
    "Turny Turns of lawness lawan", "wêneyek ji cesedê dayika dayikê girt", "wan sêrbaz xs bike",
    "Ma hûn fêm dikin ku klitoris diya we herêmek berbiçav e?",
    "Ez ji we re şîret dikim ku hûn herin we ji we re bişopînin ji ber ku hûn nekarin ji dîkên min bêtir bikin.",
    "Ma hûn fêm dikin ku ez ê li ser pêlika te bişewitînim û çentê min ji we re xist?)",
    "Ew her tiştê ku hûn jêhatî ne, kurê çûçikê", "trolltalk.lûa bêst",
    "Kî hûn dîkên min naxwin û ez ê diya te bi vî rengî bi xwe re bişikînim ?!)",
    "Ma hûn fam dikin ku klitoris diya we herêmek zehf xeternak e?",
    "Ez ji we re şîret dikim ku hûn biçin fuck ji ber ku hûn ne gengaz in ku hûn nekêşek dîkek min in",
    "Hûn cho, ez niha devê xwe li koka xwe dixeriqînim û te radikim?)",
    "Ev her tiştî ye ku hûn Kurê Kurê Kurê Kurê Qedexe ne?",
    "Werin, hûn dîk min in û wê hingê ez ê diya te bi vê dîkan bişikînim ?!)",
    "Dema ku min razî bû ku min razî bû ku ez tiştê xwe yê belengaz bi spermê xwe re bişikînim",

    }
})

-- 8. ROMANIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [ROMANIAN]",
    phrases = {'stai jos dog',  'futu-ti mortii ma-tii sa-ti fut de taran',
    'sugi pula', 'Juan ', 'ai corpul ala zici ca e lumanare de botez.',
    "Ai cumva cheat-ul ala de la Llama?", 'efortless',
    'foaie verde castravete ti-am dat 1 prin perete',
    'cand pun ochiu in luneta o vad pe ma-ta pe mocheta',
    'foaie verde si-o spatula ti-am dat cap cu ma-ta-n pula',
    'primordial.dev ez taps', '1 by esoterik bro',
    'mama coaie am dat click manual zici ca sunt alien cosminel',
    'foaie verde be the heda ti-ai luat tap de la wanheda',
    'fie viata cat de grea iti dau tap ce pula mea',
    'foaie verde butelie intra glontu in chelie',
    'hacker de sentimente sparg capuri si apartamente',
    'skeet in buzunare sa-i dau tap lui fleeekkk',
    'Priveste partea buna, macar ai dat 100 damage la peretele din spatele meu !',
    'esc -> help & options -> how to play', '1 1 very NeRvOs hEaDsHoT 1 1',
    'Pt fetele gravide recomand skeet cu vitamine.',
    '1 tie 1 lui ma-ta', '1 by pleata lui darth',
    'Asa a dat si ma-ta ochii peste cum ai dat tu cu capul',
    'Tragem pula in mamele voastre!!!', 'Te-ai speriat? Eu da!',
    'ai capul ala zici ca e made in china',
    'da-te ca-mi bag pula', 'ai gresit 1way-ul',
    'alo baiatu, te-ai pierdut ? iti bag waze-u ?',
    'Ai corpul ala zici ca e halba de bere.', 'VeRy NeRvoS BaIm',
    'primo peek', 'stai jos caine',
    'Tu si Oana Roman ce mai stati cu burta pe afara.',
    'apas f pt tine <3', 'scz eram cu legitbotu on',
    'rostogoli-mi-as pula-n ma-ta cum se rostogoleste crocodilu-n apa',
    'coaie ce corp ai zici ca esti desenat cu stanga',
    'foaie verde de cucuta hai la tata sa te futa', 'aleluia ai luat muia .!.',
    'Get Good. Get Primordial.dev', 'nice desync, esti cu eternity ?',
    'lol aveam resolver-ul off.', 'Cel mai nervos baim din viata mea',
    'asta ajunge la war montage ms ms', 'BaIm bAiM BaIm',
    'ceapa verde foaie iute uite baimu cum se duce',
    'Foaie verde praf de ciori iti iei baim pana mori', 'Foaie verde si-o lamaie iti dau baim si iei muie',
    'foaie verde acadea ia cu baim in pula mea',
    'sunt haiduc cunoscut, iti dau pula la pascut', 'sunt tac-tu, hai sa-ti dau lape',
    'ba..nu stiu cum sa-ti spun, dar...isi mai da ma-ta filme ca-i pompier de cand i-am pus pula peste umar?',
    'sa-ti pun pula pe piept ', "fraierii isi iau cap", "se sufocă în sperma mea",
    'hai back to canal boschetare', 'hai la gratar sa-ti frig o muie',
    "smecherii fut", "mama ta a sărit pe fereastră când a aflat că te joci.",
    "cap de puță tu", "dracu ești norocos ca un câine", "curvă jegoasă în camera mea de chat",
    "du-te dracului!", "școlarule.", "tatăl tău e în mop", "fiu de curvă s-a plâns în fața armei mele",
    "fuck me cry", "heh fema umilit", "get fat or get aruh", "play slower, fuckin' slow",
    "ai fost aruncat la gunoi de la naștere", "de ce te umilești, aruncă-ți rușinea pe mine",
    "Ești un fătălău nenorocit", "ești un ucigaș de fătălăi", "ești un ucigaș de fătălăi", "ești un ucigaș de fătălăi", "haide, grăbește-te, melc nenorocit, ahhh",
    "învață să sugi pula mamei tale", "caută-te în conacul masonic", "înghite-ți sperma, fiică de curvă",
    "Ți-am șters spermă pe cană", "ești un fătălău", "ești un fraier", "maică-ta e un fraier", "sunt un fraier",
    "Ți-am prins fundul ăla prost...", "lol, sunt atât de agățat de tine...", "ce naiba, fiu de curvă slabă...",
    "Ai pișat de porumbel în gură", "Dă-mi-o în cap", "Ți-a intrat papucul în tine", "Uite-o pe mămica ta aici",
    "deportat în iad cu o curvă nenorocită", "a căzut", "mi-am băgat pula în buzele tale haha",
    "du-te papi nu știi", "aru m-ai văzut", "outsider", "eu muhtar tu muhtar nenorocit",
    "Te-ai lovit de gresie în orfelinat?", "Te-au închis.", "Ești o muiere de pizdă.",
    "ai fost deportat la khazali", "o să ți-o tragi cu pula", "o să ți-o tragi, nenorocitule",
    "pizda mamei tale e radioactivă", "du-te dracului", "0 la naiba", "ți-am futut familia până la ceruri XD",
    "dă-mi-o în bară", "nu ești atât de bun", "de ce e atât de ușor",
    "Am vomitat în farfuria mamei tale", "Ai creier?", "Ești fiul unei târfe moarte",
    "de ce sugi o sculă și apoi scrii că e rău să sugi o sculă", "taci naibii din gură, nenorocitule, acum ți se duce fundul la fund",
    "am bătut-o pe maică-ta", "mi-ai rănit sentimentele", "du-te dracului",
    "unde dracu' te-ai dus?", "ți-ai strangulat mama cu puța", "mama ta a fost tăiată pe un scaun",
    "de ce nu înveți să joci????", "du-te dracului copil", "ți-au tăiat mâinile??",
    "a luat-o direct în fața mamei tale", "afară în lume", "bastard de câine",
    "fără întrebări, ia-mi scula în gură", "unde dracu' te duci cu mine",
    "mama ta a fost călcată de un tren", "tatăl tatălui tău =*",

    }
})

-- 9. POLISH
table.insert(troll_talk.phrases, {
    name = "TrollTalk [POLISH]",
    phrases = {"twoja matka wyskoczyła przez okno, gdy dowiedziała się, że grasz w gry.",
    "wycieranie smarków z twarzy mamy", "Jak ja cię wyruchałem?",
    "cipa twojej mamy jest radioaktywna", "pierdol się", "0 za 0",
    "zerżnij mnie", "nie ssiesz tak dobrze", "dlaczego to jest takie łatwe)",
    "walnąłem w talerz twojej matki", "czy ty w ogóle masz mózg?)",
    "dlaczego ssiesz kutasa, a potem piszesz, że ssanie kutasa jest złe?",
    "My, kurwa, skopaliśmy twoją mamę", "Zraniłeś moje uczucia",
    "Gdzie ty się, kurwa, podziewałeś?", "Udusiłeś mamę swoim kutasem",
    "Dlaczego nie nauczysz się grać?", "Idź spać, kochanie",
    "masz to prosto w twarz swojej mamie", "na świecie",
    "bez żadnych pytań, weź mojego kutasa do ust", "gdzie chcesz, żebym poszedł?",
    "twoją mamę przejechał pociąg", "tata twojego taty =*",
    "przeleciałem twojego ojca", "przeleciałeś mnie", "heh, pieprzę cię",
    "Twoja mama jest w garażu i sra w gacie)",
    "jesteś zajebisty", "zajebię cię", "jesteś zajebistym nowicjuszem",
    "fuck you like tonight))", "patukhni ukrainian", "cheta patukhni",
    "patukh(", "patukh 1", "atta tvaevo patukh", "tekstom tekstom)",
    "wrzucił miętusa w cipkę twojej matki", "zgasił cię)",
    "to proste", "zabił cię", "jesteś prawdziwą cipą",
    "zostałeś zrobiony na torze przez seks za 20 hrywien", "jesteś słaby",
    "You've been fucked by primordial.dev", "Are you sure you're sure you're a man?",
    "wycieranie smarków z twarzy twojej matki", "wycieranie ciebie",
    "zwabi cię kutas, to się na niego nabierzesz",
    "twoja matka też została zamordowana", "przepraszam, jeśli cię opieprzyłem)",
    "twoja mama jest na moim kutasie w górę i w dół", "hipernapastnik mnie molestuje", "molestowanie w piwnicy",
    "w miejscu publicznym mnie napastowałeś", "masz kutasa", "gdzie się podziewałeś?!",
    "oroo tak śmiesznie spadasz))", "mokry od zapachu perfum dolce cabana", "nerwowo mnie osaczasz",
    "zerżnij trochę swoją mamę", "zrób mi loda swoim znakiem firmowym)",
    "pięknie zerżnąłem cię w usta!", "jak długo jeszcze będziesz mi robił loda?)",
    "złapałeś swoją matkę na haczyk wędkarski...", "pobiłeś mój rekord chuja!)",
    "zabiłeś swoją matkę...", "jesteś winny...", "zajebię cię...",
    "tak to jest, jak się ma wyjebane", "nieszczęsny sassesh", "twoja matka zginęła za rogiem", "spadł jak pierdolona plaga aru cheta",
    "szturchnął twoją matkę wścieklizną", "gdzie ty kurwa idziesz?", "chetah patukh slack?)0 haha",
    "otrzyj łzy, słabeuszu", "zrobiłem zdjęcie zwłokom twojej mamy", "pieprzę cię za pomocą magii",
    "zabił trochę twoją mamę", "jesteś trochę ospały", "jesteś trochę ospały", "pieprzę cię",
    "your cheat made in china", "eat the food", "walk the air",
    "czarnuchu twój tatuś ma wyjebane na armaturę", "cipo, gdzie ty uciekłaś, laska?",
    "Nie umiem się bawić", "300 kg pierdoli cię słabo, o nie!)",
    "Znajdę cię na IP!", "Jesteś małą cipką", "Mam w tobie swojego kutasa", 

    }
})

-- 10. GERMAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [GERMAN]",
    phrases = {"Du hast deine Mutter am Angelhaken...", "Du hast den Saugerrekord für mich gebrochen!)",
    "Du hast deine Mutter umgebracht...", "Du bist Jahrgang...", "Ich mach dich fertig..." ,
    "So wird man verarscht", "elende Frechheit", "deine Mutter wurde um die Ecke umgebracht", "fiel wie eine verdammte Geißel aru cheta",
    "Deine Mutter mit Tollwut angesteckt", "Wo zum Teufel gehst du hin?", "chetah patukh slack?)0 haha",
    "Wisch dir die Tränen ab, Schwächling", "Mach ein Foto von der Leiche deiner Mutter", "Fick dich mit Magie",
    "hat deine Mama ein bisschen umgebracht", "du bist ein bisschen träge", "du bist ein bisschen träge", "fick dich",
    "Ihr Betrug made in China", "Essen Sie das Essen", "Gehen Sie die Luft",
    "Nigger, dein Vater hat die Armatur gefickt", "Weichei, wohin bist du abgehauen, Tussi?",
    "Ich weiß nicht, wie man spielt", "300 kg ficken dich schwach, oh nein!)",
    "Ich werde deinen I.P. finden!", "Ich habe eine kleine Muschi an mir", "Ich habe meinen Schwanz in dir", 
    "Ich habe deinen Schwanz mit meinem Schwanz zertrümmert", "Ich ficke dich nur, du Schwächster)",
    "Ich habe dich mit meinem Schwanz gefickt", "Fick dich wie ein Hund", "Hurenbock, der mit mir chattet)",
    "Verpiss dich!", "Schuljunge", "hat deinen Daddy in den Mopp geworfen",
    "Leck mich am Arsch", "Fema gedemütigt", "Werde fett oder werde ruhig",
    "Du wurdest bei der Geburt in den Müllschlucker geworfen", "warum erniedrigst du dich, schäm dich",
    "Du bist ein Weichei, du bist ein Weichei", "Du hast dich umgebracht", "Sack",
    "Lerne, die Muschi deiner Mutter zu lutschen", "suche dich im Männlichen",
    "Ich habe mein Sperma an deiner Tasse abgewischt", "Du bist ein Paskuli", "Du bist ein Weichei", "Deine Mutter ist ein komischer Typ", "Ipu tu laha aru",
    "Abaszal du Dummkopf =)", "lool wie ich mit dir aruuu",
    "Taubenpisse in den Mund geschüttet", "Fick mich oben", "Fick dich, du hast einen Pantoffel in dir",
    "in die verdammte Hurenhölle abgeschoben", "umgefallen",
    "Geh, Papi weiß es nicht", "aruh, du hast mich gesehen",
    "Ich habe in den Teller deiner Mutter gekotzt =))", "Hast du überhaupt ein Gehirn?",
    "Warum lutschen Sie einen Schwanz und schreiben dann, dass Schwanzlutschen schlecht ist?",
    "Wir haben deine Mama verprügelt", "Du hast meine Gefühle verletzt",
    "Wo zum Teufel bist du hin?", "Du hast deine Mama mit deinem Schwanz erwürgt.",
    "Warum lernst du nicht, wie man spielt?", "Geh schlafen, Baby.",
    "Du hast es deiner Mama direkt ins Gesicht gesagt", "draußen in der Welt",
    "Keine Fragen, nimm meinen Schwanz in den Mund", "Wo soll ich hin?",
    "Deine Mutter wurde von einem Zug überfahren", "Der Vater deines Vaters =*",
    "Ich habe deinen Vater gefickt", "Du hast mich gefickt", "Fick dich",
    "Deine Mutter ist in der Garage und scheißt sich in die Hose",
    "Du bist ein verdammt harter Kerl", "Ich mach dich fertig", "Du bist ein verdammter Neuling",
    "Fick dich wie heute Nacht))", "patukhni ukrainisch", "cheta patukhni",
    "patukh(", "patukh 1", "atta tvaevo patukh", "tekstom tekstom)",
    "hat deiner Mutter einen Moly in die Muschi geworfen", "hat dich umgelegt)",
    "Das ist einfach", "ich habe dich umgebracht", "du bist ein echtes Weichei",
    "Du bist durch Sex für 20 Griwna auf die Strecke gebracht worden", "Du bist schwach",
    "Du wurdest von primordial.dev gefickt", "Bist du sicher, dass du ein Mann bist?",
    "Rotz auf dem Gesicht deiner Mutter abwischen", "dich auswischen",
    "Wenn du von einem Schwanz angelockt wirst, fällst du drauf rein.",
    "Deine Mutter wurde auch getötet", "Tut mir leid, wenn ich dich verarscht habe)",
    "Wie habe ich es dir vermasselt?",

    }
})

-- 11. BREAK CHINESE
table.insert(troll_talk.phrases, {
    name = "TrollTalk [BREAK CHINESE]",
    phrases = {"你爸爸被操了","胆小鬼","你今天要把你的脑袋操出来吗)?",
    "你妈咪在我的小弟弟上上下下","低级趣味的小鬼在骚扰我","地下室骚扰",
    "在公共场合你取笑我","我他妈的向你扔鲨鱼","你去哪里了？)",
    "oroo你摔得好滑稽)","蘸着dolce cabana香水的香味","你紧张地鞭打我",
    "干你一下","给我你的招牌口活)",
    "我把你的嘴干得很漂亮！" ,"你要为我口交多长时间？",
    "把你妈妈放在鱼钩上.......", "你打破了我的口交记录！" ,"你打破了我的口交记录！)",
    "你杀了你的母亲......" ,"你的复古......" ,"我要把你干到死......" ,
    "这就是你被操的方式","你这个可悲的家伙","你妈妈在拐角处被杀了","你躺着就像一个Aruchetta Gop。",
    "给你妈妈打狂犬病疫苗","你他妈的要去哪里？",
    "擦擦眼泪吧，胆小鬼","给你妈妈的尸体拍了张照片","用魔法操自己",
    "杀了你妈妈一下","你有点窒息","你有点弱智","我和你做爱", 

    }
})

-- 12. SPANISH
table.insert(troll_talk.phrases, {
    name = "TrollTalk [SPANISH]",
    phrases = {"cobarde", "chúpame la polla", "aguanta", "patético", "maricón",
    "tu padre está en el culo", "vas a follar esta noche", "le has sacado un ojo a tu padre",
    "tu madre está en mi polla de arriba a abajo", 
    "Te pego delante de la gente", "dónde has estado, puto maricón?",
    "eres tan gracioso que te caes", "refréscate con el perfume Dolce Cabana", "me pones nervioso",
    "te has follado un poco a tu madre", "me has hecho una mamada obligatoria", "has comprado a tu madre fuera de la pista",
    "Te cogí maravillosamente en la boca!",
    "He cogido a tu madre con un anzuelo..", "has batido el récord de chupar pollas de tu madre",
    "mataste a tu madre..", "vendes salchichas..", "tu madre me chupó la polla en los callejones...",
    "así se cae", "apestas miserablemente", "tu madre fue asesinada a la vuelta de la esquina", "cayó como un puto látigo aru cheta aru",
    "a tu madre le ha dado la rabia", "a dónde coño vas?", "qué cobarde 0 jaja",
    "límpiate las lágrimas, debilucho", "hazle una foto al cadáver de tu madre", "jódete con la magia", "mataste un poco a tu madre",
    "mataste un poco a tu madre", "eres un poco vago", 
    "tu trampa made in china", "come tu comida", "camina en el aire",
    "negro, tu padre se ha follado a la armadura", "cobarde, a dónde has huido, chica?",
    "No sé jugar", "300 kilos de mierda débil, oh no!",
    "Encontraré tu IP!", "Tengo mi polla dentro de ti", "marica", "te has matado", "saco",
    "Aplasté tu polla con mis piernas", "Acabo de follar con el más débil",
    "Te he jodido con mi polla", "puta hablando conmigo",
    "jódeme", "colegial", "tu papá fue aplastado", "el hijo de puta se quejó frente a mi pistola",
    "tus padres te tiraron a la basura al nacer", "por qué te arrastras, date una puta ducha de vergüenza",
    "aprende a chuparle el coño a tu madre", "búscate en la mansión masónica",
    "Te limpié mi semen en la cara", "escoria", "maricón", "tu madre me chupa", "te daré un lakh aruh",
    "te ponen orina de paloma en la boca", "maldito zapatito",
    "deportado al puto infierno", "abajo 1", "aru me viste", "extraño",
    "Golpeaste las baldosas en el orfanato?", "te encerraron",
    "te han deportado a los kazajos", "te voy a follar con la polla",
    "el coño de tu madre es radiactivo", "te voy a follar",
    "No eres tan bueno", "por qué es tan fácil",
    "He vomitado en la cara de tu madre", "tienes siquiera un cerebro?",
    "Por qué chupas pollas y luego escribes que chupar pollas es malo?",
    "hemos pateado a tu madre", "me has hecho daño", "jódete", "dónde has ido",
    "dónde has estado?", "has estrangulado a tu madre con la polla", "tu madre se ha cortado con la silla", "por qué no aprendes a jugar con la polla de tu madre",
    "por qué no aprendes a jugar?", "jódete, chico", "¿te han cortado las manos?", "la cara roja de tu madre",
    "sin preguntas, coge mi polla en tu boca", "a tu madre la atropelló un tren", "el papá de tu papá =*",
    "Me he follado a tu padre", "oye, que te den",
    "tu madre está en el garaje cagándose en los pantalones", "maldito lisiado", "eres un puto asco",
    "me estás jodiendo", "te estoy jodiendo", "me estás jodiendo",
    "que os jodan como hoy))", "que os jodan los ucranianos", "cheta patuh",
    "patootch(", "patootch 1", "fuck you text",
    "echó a moli en el coño de tu madre", "te echó a patadas",
    "eso es fácil", "te he matado", "eres un auténtico marica",
    "te han jodido en la carretera por 20 hryvnias", "eres débil",
    "te han jodido", "estás seguro de que eres un hombre?",
    "limpiar los mocos en la cara de tu madre", "limpiar después de ti",
    "si te atraen las pollas, te enamoras de ellas",
    "Tu madre también fue asesinada", "Siento haberte jodido",
    "Cómo crees que te cogí?", "Puedes comprar un cerebro?)",
    "Tu madre lleva mucho tiempo con mi polla, cree que está bien que le salga semen",
    "Tu madre tuvo un orgasmo y tu padre folló",
    "Tu madre lleva follando con mi polla desde los cinco años, miserable",
    "¿Sabías que tiraste a tu madre por la ventana junto con su polla y se levantó y siguió corriéndose?",
    "¿Te das cuenta de que el clítoris de tu madre es una zona extremadamente peligrosa?", 
    "Te aconsejo que te vayas a la mierda porque no puedes hacer nada más que chuparme la polla",
    "¿Te das cuenta de que estoy a punto de rodear tu boca con mi polla y estrangularte?",
    "eso es lo mejor que puedes hacer, hijo de puta) vete a la mierda, no avergüences a tu puta madre)",
    "¿Por qué no me chupas la polla ahora y luego me follaré a tu puta madre con ella?",
    "Tu madre se puso muy contenta cuando acepté alimentar su pobre coñito con mi semen(",

    }
})

-- 13. TURKISH
table.insert(troll_talk.phrases, {
    name = "TrollTalk [TURKISH]",
    phrases = {"korkak", "sikimi yala", "bana katlan", "zavallı", "seni piliç",
    "Baban sikildi", "korkak", "bugün beynini mi sikeceksin?", "babanı gözünden dürttü",
    "Annen sikimin üzerinde bir aşağı bir yukarı", "hipernazal şımarıklık", "bodrumda şımarıklık", 
    "İnsanların önünde,", "Seni köpekbalığı yaptım", "Nereye gittin?!", "Nereye gittin, seni ibne?!",
    "Çok komiksin, düşüyorsun.)", "Dolce Cabana parfümü sürmüşsün.", "Beni sinirlendiriyorsun.",
    "anneni biraz siktim", "senin alametifarikan oral seks", "anneni pistten aldım",
    "Ağzını güzelce siktim!", "Bana daha ne kadar bok atmaya devam edeceksin",
    "Anneni oltaya taktım...", "Emme rekorumu kırdın...",
    "anneni öldürdün...", "sen eski bir sosissin...", "sen bir gara'sın...", "annen ara sokaklarda sikimi yalıyordu...",
    "işte böyle becerilirsin", "sefil sassesh", "annen köşede öldürüldü", "lanet bir bela gibi düştü aru cheta",
    "anneni kuduzla dürttü", "nereye gidiyorsun lan?", "chetah patukh slack?)0 haha",
    "gözyaşlarını sil, zayıf çocuk", "annenin cesedinin fotoğrafını çektim", "seni sihirle sikeyim",
    "Anneni biraz öldürdün", "biraz halsizsin", "biraz halsizsin", "siktir git",
    "hileleriniz Çin malı", "yemek yiyin", "havada yürüyün",
    "Zenci, babanın armatürü sikildi", "Ödlek, nereye kaçtın, piliç?",
    "Nasıl oynanacağını bilmiyorum", "300 kg seni zayıf sikerim, oh hayır!",
    "Kimliğini bulacağım!", "Bana biraz kızgınsın", "Aletimi içine soktum", 
    "sikini sikimle parçaladım", "sadece seni beceriyorum en zayıf",
    "seni sikimle siktim", "seni köpek gibi siktim", "benimle sohbet eden orospunun veledi",
    "Siktir git!", "okul çocuğu.", "baban paspasın içinde", "orospu çocuğu silahımın önünde mızmızlandı",
    "sik beni ağla", "heh fema aşağılandı", "şişmanla ya da aruh ol",
    "Doğarken çöp kutusuna atılmışsın", "Neden kendini küçük düşürüyorsun, utanç duşu al",
    "Sen bir korkaksın", "seni öldürdüm", "çuval", "beni kızdır!!!!",
    "Annenin amını yalamayı öğren.", "Kendini mason malikanesinde ara.",
    "Spermlerimi suratına sildim", "sen bir pisliksin", "sen bir hanım evladısın", "annen komiklik yapıyor", "sana bir laha aru vereceğim",
    "abaszal seni salak =)", "lool nasıl seninleyim aruuu",
    "ağzına güvercin sidiği döktüm", "sik beni üst", "sikeyim içinde terlik var",
    "Orospu cehennemine sürgün edildim.", "Düştüm.",
    "go papi don't know", "aru you saw me", "outsider",
    "Yetimhanedeki fayanslara mı vurdun?", "Seni kilitlediler.",
    "Hazarlara sürgün edildin", "Seni sikimle sikeceğim.",
    "Annenin amı radyoaktif", "Siktir git", "Seni sikeceğim",
    "sik beni", "o kadar da iyi emmiyorsun", "neden bu kadar kolay",
    "Annenin tabağına kustum.", "Senin beynin var mı ki?",
    "Neden bir sik emiyorsun ve sonra da sik emmenin kötü olduğunu yazıyorsun?",
    "Annene tekmeyi bastık", "Duygularımı incittin", "Siktir git)",
    "Nereye gittin lan sen?", "Anneni sikinle boğdun", "Annen sandalyede kesildi",
    "Neden oynamayı öğrenmiyorsun???", "Siktir git çocuk", "Ellerin mi kesildi?",
    "Annenin yüzüne doğru kızardı,", "dünyaya çıktı.",
    "Soru sormak yok, sikimi ağzına al", "benimle nereye gidiyorsun",
    "Anneni tren ezdi", "Babanın babası =*",
    "Babanı siktim", "beni siktin", "heh, siktir git",
    "Annen garajda altına sıçıyor.", "Sen lanet bir topalsın",
    "Beni mahvediyorsun", "Seni mahvediyorum", "Beni mahvediyorsun",
    "fuck you like this night)", "patouchny ukrainian", "cheta patouchny",
    "patukh(", "patukh 1", "atta tvaevo patukh", "tekstom tekstom)",
    "annenin amına bir moly attı", "seni söndürdü)",
    "Bu çok kolay", "Seni öldürdüm", "Sen gerçek bir korkaksın",
    "20 grivnaya seks yaparak piste çıktınız", "zayıfsınız",
    "primordial.dev tarafından becerildin", "erkek olduğuna emin misin?",
    "Annenin yüzündeki sümüğü silmek.", "Seni silmek.",
    "Bir sik tarafından ayartılırsan, ona kanarsın.",
    "senin annen de öldürüldü", "seni becerdiysem özür dilerim.)",
    "Seni nasıl mahvettiğimi düşünüyorsun?", "Bir beyin satın alabilir misin?)", 

    }
})

-- 14. FRENCH
table.insert(troll_talk.phrases, {
    name = "TrollTalk [FRENCH]",
    phrases = {"mauviette", "prends ma bite dans ta bouche", "suce ma bite ici", "supporte-moi", "pathétique", "t'es une gonzesse",
    "ton père s'est fait baiser", "mauviette", "tu vas te faire sauter la cervelle aujourd'hui ?", "j'ai mis ton père dans un putain d'oeil",
    "ta mère sur ma bite de haut en bas", "hypernasal sassing me", "dans la cave sassing me", "ta mère sur ma bite",
    "devant les gens", "je t'ai requinqué", "t'es passé où ? !", "t'es passé où, espèce de pédé", "je t'ai enfermé dans une caisse",
    "oroo tu tombes si drôlement))", "mouillé de parfum dolce cabana", "tu me rends nerveux",
    "baisé ta mère un peu", "tu as ta pipe de marque", "acheté ta mère sur la piste",
    "Je t'emmerde superbement dans la bouche !", "combien de temps tu vas continuer à me faire chier ?", "hahahahah je t'emmerde.",
    "ta mère est sur un hameçon...", "tu as battu mon record de suçage de bite !", "tu es un putain de biomasa...",
    "tu as tué ta mère...", "tu es vintage...", "je vais te baiser...", "ta mère m'a baisé dans les ruelles...",
    "c'est comme ça que tu te fais baiser", "misérable sassesh", "ta mère s'est fait tuer au coin de la rue", "tombé comme un putain de fléau aru cheta",
    "poke your mother with rabies", "where the fuck are you going ?", "chetah patukh slack ?)0 haha", "desink joiner fuckin'",
    "essuie tes larmes, mauviette", "a pris une photo du cadavre de ta mère", "te baise avec de la magie", "t'es un putain de patient",
    "tu as un peu tué ta maman", "tu es un enfoiré paresseux", "ne meurs pas, fils de pute",
    "ta triche fabriquée en Chine", "mange ta nourriture", "va papa papa air", "tu suce ici fils de pute haha !",
    "tête de noeud", "putain t'as de la chance comme un chien", "pute de merde dans mon salon de discussion",
    "Va te faire foutre !", "écolier.", "ton père est dans la serpillière", "fils de pute a pleurniché devant mon arme",
    "baise-moi pour pleurer", "heh fema m'a humilié", "deviens gros ou sois aruh", "joue plus lentement, putain de lentement",
    "Tu as été jeté dans le vide-ordures à la naissance", "pourquoi tu t'humilies, jette ta putain de honte sur moi",
    "tu es une putain de chatte", "tu es une tueuse de chatte", "tu es une tueuse de chatte", "je suis une tueuse de chatte", "allez, dépêche-toi, putain d'escargot",
    "apprends à sucer la bite de ta mère", "cherche toi-même dans le manoir maçonnique", "avale ton sperme, fille de pute",
    "J'ai mis du sperme sur ta tasse", "t'es une fiotte", "t'es une suceuse de fiotte", "ta mère est une suceuse de fiotte", "je suis une suceuse de fiotte",
    "J'ai ton cul...", "J'en ai marre de toi...", "C'est quoi ce bordel, espèce de faible fils de pute...",
    "t'as ta pisse de pigeon dans la bouche", "baise-moi le haut", "la putain de pantoufle t'a volé dessus", "ta mère est ici",
    "déporté en enfer avec une putain", "tombé", "j'ai ma bite dans tes lèvres haha", "trolltalk bést talk",
    "go papi don't know", "aru you seen me", "outsider", "eu muhtar you fuckin' muhtar",
    "Tu t'es cogné le bec sur le carrelage à l'orphelinat ?", "Ils t'ont enfermé.", "Tu es une putain de mauviette de maman.",
    "tu as été déporté chez les khazals", "tu vas te faire enculer par une bite", "tu vas te faire enculer, enfoiré",
    "la chatte de ta mère est radioactive", "va te faire foutre", "0 pour l'amour de Dieu", "j'ai baisé ta famille jusqu'à la fin des temps XD",
    "baise-moi", "tu ne suces pas si bien", "pourquoi c'est si facile",
    "j'ai vomi dans l'assiette de ta mère", "t'as un cerveau ?", "t'es le fils d'une pute morte",
    "pourquoi tu suces une bite et ensuite tu écris que sucer une bite est mauvais", "ferme ta gueule, putain de pack de six, maintenant ton putain de cul va tomber",
    "on a botté le cul de ta mère", "tu m'as blessé", "va te faire foutre",
    "Où t'es allé, putain ?", "t'as étranglé ta mère avec ta bite", "ta mère a été coupée sur une chaise",
    "Pourquoi n'apprends-tu pas à jouer ?", "va te faire foutre, gamin", "on t'a coupé les mains, putain ?",
    "Tu l'as eu en plein dans le visage de ta mère", "dans le monde", "bâtard de chien",
    "Pas de questions, prends ma bite dans ta bouche,", "Où est-ce que tu m'emmènes, putain ?",
    "ta maman s'est fait écraser par un train", "le papa de ton papa =*",

    }
})

-- 15. BREAK JAPANESE
table.insert(troll_talk.phrases, {
    name = "TrollTalk [BREAK JAPANESE]",
    phrases = {"チンカス野郎","犬みたいにラッキー","俺のチャットルームで売春婦のクズ",
    "失せろ","小学生","お前のパパはモップの中","売春婦の息子は私の銃の前で泣き喚いた",
    "「お前は生まれた時にゴミ箱に捨てられた」「なぜ恥をかかせるんだ？",
    "この野郎", "この野郎", "この野郎", "この野郎", "この野郎", "この野郎", "早くしろ", "この野郎", "早くしろ",
    "ママのチンコをしゃぶるのを覚えろ", "魔界屋敷で自分を探せ", "ザーメンを飲み込め 売春婦の娘め",
    "お前のマグカップに精子をかけた", "お前は女々しい", "お前の母親は女々しい", "私は女々しい",
    "お前のバカ野郎を捕まえたぞ", "お前にはうんざりだ", "何だこの弱虫は...",
    "鳩の小便が口に入った", "ファックミー・トップ", "クソッタレのスリッパが飛んできた", "お前のママはここにいる",
    "クソ売春婦と地獄へ強制送還", "転んだ", "お前の唇に俺のペニスを入れた",
    "go papi don't know", "aru you seen me", "outsider", "eu muhtar you fuckin' muhtar",
    "孤児院でクチバシを叩いたか？", "監禁されたんだぞ", "この弱虫が",
    "カザルスに強制送還された", "チンポコで犯される", "犯されるぞ マザーファッカー",
    "「お前のママのマンコは放射性物質だ」「くたばれ」「頼むから0にしてくれ」「お前の家族を王国まで犯してやったぜXD」)",
    "fuck me up", "you don't suck so good", "why is it so easy",
    "お前の母親の皿に吐いた", "脳みそあるのか？", "お前は死んだ娼婦の息子だ",
    "「なんでフェラしておいてフェラが悪いと書くんだ」「黙れクソシックスパック！今すぐクソケツを下げろ",
    "お前のママを蹴飛ばした", "俺の気持ちを傷つけた", "くそったれ",
    "どこに行った？", "お前のチンコでママを絞め殺した", "ママは椅子で切られた",
    "なぜ遊び方を覚えない？", "クソガキ", "手を切られたか？",
    "ママの顔に泥を塗った", "世界に出て行った", "犬の野郎",
    "問答無用で 俺のペニスを口に入れろ", "どこへ連れて行くんだ？",
    "「あなたのママは電車に轢かれた」「あなたのパパのパパ＝＊＊」",

    }
})

-- 16. BULGARIAN
table.insert(troll_talk.phrases, {
    name = "TrollTalk [BULGARIAN]",
    phrases = {"слабак", "вземи пениса ми в устата си", "смучи ми пениса тук", "потърпи ме", "жалък", "ти, пиленце",
    "баща ти е прецакан", "слабак", "тази вечер ли ще си изчукаш мозъка", "бръкна на баща ти в шибаното око",
    "майка ти върху члена ми нагоре-надолу", "хиперназално ме насилва", "в мазето ме насилва", "майка ти върху члена ми",
    "пред хората", "шибана акула", "къде си отишъл?!", "къде си отишъл, шибан педераст", "шибана кутия",
    "Орооо, ти си толкова смешен))", "мокър с парфюм Долче Кабана", "изнервяш ме", "1",
    "прецаках малко майка ти", "имаш си запазена марка за свирка", "купих майка ти от пистата",
    "ебах ти красиво в устата!", "докога ще продължаваш да ми даваш акъл?", "хахахах, ебах ти.",
    "закачи майка си на рибарска кука...", "счупи ми рекорда по ебане на кокалите!", "шибана биомаса",
    "ти си убил майка си...", "ти си реколта...", "аз ще те прецакам...", "майка ти ме прецака по улиците...",
    "така те ебават", "мизерен сас", "майка ти я убиха зад ъгъла", "падна като шибан бич ару чета",
    "побутна майка си с бяс", "къде, по дяволите, отиваш?",
    "избърши си сълзите, слабако", "снимах трупа на майка ти", "прецаках те с магия", "ти си шибан пациент",
    "убил си малко майка си", "ти си мърляв копеле", "не умирай, син на курва",
    "твоята измама, направена в Китай", "яжте храната си", "отидете на папа папа въздух", "вие смучете тук син на курва хаха!",
    "ти си син на шибан труп", "ти си син на шибан труп",
    "Ти си син на шибан труп", "Не знам как да играя", "300 кг те ебават, слаб си, о, не!", "Ти, шибана пиявица, пусни се!",
    "Ще те изпиша! Ще те изпиша! Ще те изпиша! Ще те изпиша! Ще те изпиша!",
    "разбих ти члена с моя член", "просто те чукам най-слабия", "нон-стоп син на курва ахах", "заспал задник",
    "ебах ти пича", "ебах ти късмета като куче", "курва брат в чата ме shultini",
    "Еби се!", "ученик.", "баща ти е в мопа", "курвенски син хленчи пред пистолета ми",
    "ебах ме, плача", "хех, Фема ме унижи", "стани дебел или се арух", "играй по-бавно, ебати бавното",
    "изхвърлили са те в коритото за боклук още при раждането", "защо се унижаваш, хвърли шибания си срам върху мен",
    "ти си шибан чичко", "ти си чичко убиец", "ти си чичко убиец", "аз съм чичко убиец", "хайде, побързай, ти шибан охлюв ахххх",
    "научи се да смучеш члена на майка си", "потърси себе си в масонското имение", "глътни спермата си, дъщеря на курва",
    "Изтрих спермата върху чашата ти", "пасули", "ти си слабак", "майка ти смуче смешното ару", "Ипу лаха ару",
    "Ще се изсипя върху тъпия ти задник", "Ще се изсипя върху тъпия ти задник", "Какво става, слаб курвенски син",
    "имаш в устата си гълъбова урина", "чукай ме отгоре", "шибаната пантофка полетя към теб", "майка ти е шибана тук",
    "депортиран в ада с майка шибана курва", "падна", "имам пениса си в устните си хаха",
    "Удари ли плочките в сиропиталището?", "Затвориха те", "Ти си шибана мамка", "esc -> help & options -> how to play",
    "депортираха те в хакалите", "ще те прецакам с пишка", "ти си шибан, мамка му", "ти си шибан, мамка му",
    "Пичката на майка ти е радиоактивна", "ебаси", "0 за ебаси", "Прецаках семейството ти до кралството XD",
    "Повърнах в чинията на майка ти =))", "Имаш ли изобщо мозък?", "Ти си син на мъртва курва",
    "Защо смучеш хуй, а после пишеш, че смученето на хуй е лошо", "Замълчи си, шибана шесторка, сега шибаният ти задник ще падне",
    "ние шибахме майка ти", "да те еба", "най-добре е да се говори за тролове",
    "Къде си, бе, ХГХ?", "Удушихме майка ти", "Майка ти е нарязана на стол",
    "Защо не се научиш да играеш???", "Майната ти, дете", "Отрязаха ли ти шибаните ръце??",
    "получи го право в лицето на майка си", "навън в света", "кучешко копеле",
    "без въпроси, вземи пениса ми в устата си", "къде ме водиш, дяволе", "trolltalk.lua best",
    "майка ти е прегазена от влак", "бащата на баща ти =*" , "да те еба като тази нощ)",
    "Прецаках баща ти", "путка", "хех, да те еба",
    "Майка ти е в гаража и се е насрала", "ти си шибан лаик",
    "ти ме прецака", "аз те прецаках", "ти ме прецака",
    "хвърли мола в путката на майка ти", "изхвърли те",
    "това е лесно", "убих те", "ти си истински чичко",
    "Направили са ви секс за 20 гривни", "слаб сте",
    "ти си бил прецакан от primordial.dev", "ти мъж ли си?",
    "избърсване на сополи по лицето на майка ти", "избърсване на теб",
    "ако те примами един пич, ще се поддадеш на него.",
    "Майка ти също е била убита", "съжалявам, ако съм те прецакал", "падни",
    "Как мислиш, че те прецаках?", "Можеш ли да си купиш мозък?",
    "на негативната шибана майка, защото тя е шибана, така че я шибах.",
    "Ще чукаме ли майка ти, или отново ще споделиш пениса ми?",
    "Майка ти е получила камшик за това, че се е опитала да смуче пениса на баща ти",
    "не ми вярваш, че майка ти ми смуче пениса, така че ела да ти дам уроци по смучене",
    "Ще ти изчукам пишката, мамо, за такъв ход",    
    "Ще издухам майка ти с пениса си и ще взема всичко от нея.",
    "майка ти вече скача върху члена ми, сякаш отива на работа",
    "майка ти вече е вкарала члена ми в бузата си и не иска да го изкара",
    "Не мога да ти опиша какво е усещането, когато твоята майка в спидо ми смуче пениса",
    "не се шегувам, ако майка ти не започне да смуче с нейното темпо, ще я ударя с пениса си по главата",
    "дори няма да забележиш, че майка ти се движи по моя пишка",
    "Майка ти лежи под пишката ми и лъже, че не може да се измъкне.",
    "а майка ти ми смуче пениса и дори не можеш да я замениш.",
    "ти си мислеше, че майка ти е курва, аз и момчетата ми й смучехме пишките на двора, но никой друг не го правеше.",
    "Майка ти седи на пениса ми от дълго време, мисли, че е нормално да кърви от спермата си.",

    }
})

-- 17. HUNGARIAN BETA
table.insert(troll_talk.phrases, {
    name = "TrollTalk [HUNGARIAN BETA]",
    phrases = {"tedd a farkam a szádba", "szopd le", "vedd el", "szánalmas", "te lány",
    "apádat megdugták", "nyuszi", "ma este szétbaszod az agyad", "kibaszottul szemen szúrtad apádat",
    "anyád fel és le a farkamon", "az anyád a farkamon",
    "emberek előtt", "kurvára megtapogattalak", "hova tűntél?!", "hova tűntél, te kibaszott buzi", "kurvára bezártalak egy dobozba",
    "Olyan vicces vagy", "csuromvizes vagy a Dolce Cabana parfümtől", "idegesítesz",
    "Kicsit megdugtam anyádat", "Elkaptam anyádat az autópályán",
    "Anyádat horgászhorogra akasztottam...", "megdöntötted a faszszopási rekordot", "te kibaszott biomassza...",
    "Megölted az anyádat...", "Megbaszlak...",
    "te nyomorult sasseh", "anyádat megölték a sarokban", "te buzi, te kibaszott kurva aru chet",
    "Baszd meg anyádat", "Hova a faszba mész?", "cheta patooch wussy?)0 haha", "dessink carpenter fucking",
    "Töröld le a könnyeidet te gyengécske", "lefényképeztem anyád holttestét", "baszd meg magad mágiával", "te kibaszott beteges",
    "Megöltem az anyádat", "te sánta szemétláda", "a csalásod Kínában készült", 
    "te kibaszott hulla", "300 kibaszott kiló, nyúl, ó ne!", "te kibaszott pióca, engedd el a farkam",
    "Én csak téged baszlak, nyuszi", "te faszszopó, szopd a farkam megállás nélkül", "te álmos seggfej",
    "Baszd meg", "te szerencsés kutya", "te fecsegő ribanc, baszd meg",
    "iskolás", "az utcán hagytad apádat", "a kibaszott anyád nyöszörög a farkam előtt",

    }
})

-- 18. CLASSIC
table.insert(troll_talk.phrases, {
    name = "TrollTalk [CLASSIC]",
    phrases = {"1",

    }
})
            
-- INFORMATION
gui.group_name = "TrollTalk [INFORMATION]"

local text_welcome = menu.add_text(gui.group_name, "- Hi, " .. user.name .. " [" .. user.uid .. "] ")
local date_build = menu.add_text(gui.group_name, "Build Date - " .. build)
local text_langinfo = menu.add_text(gui.group_name, "1. Modes: 18")
local text_servinfo = menu.add_text(gui.group_name, "2. Servers: 18")
local line_separator_info = menu.add_separator(gui.group_name)

menu.add_button("TrollTalk [INFORMATION]", "DEVELOPER", 
function()
    panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://primordial.dev/members/spoof.2644/")
end)
menu.add_button("TrollTalk [INFORMATION]", "FORUM THEME", 
function()
    panorama.open().SteamOverlayAPI.OpenExternalBrowserURL("https://primordial.dev/resources/trolltalker.362/")
end)


-- MAIN SERVERS
local text_infoservers = menu.add_text("TrollTalk [CONNECTS]", "- When connecting to a server")
local text_infoservers2 = menu.add_text("TrollTalk [CONNECTS]", "- the IP is written in the console")
local list = menu.add_list("TrollTalk [CONNECTS]", "Servers:", {
    "[MM] ReduxHub #1 | Mirage", -- 1
    "[MM] ReduxHub Only Scout | No Nades", -- 2
    "[MM] Sippin on SharkProject | Mirage", -- 3
    "[MM] eXpidors Only Scout | Mirage & Roll-Fix ", -- 4
    "[MM] eXpidors | Mirage & Roll-Fix", -- 5
    "[MM] sippin' on wok", -- 6
    "[MM] BRYANSK PROJECT", -- 7
    "[MM] Lightning HVH | Mirage", -- 8
    "[MM] Judensense | Mirage & No Nades", -- 9
    "[MM] RUSSIAN PUBLIC | Office", -- 10
    "[MM] GalaxyTaps | Mirage", -- 11
    "[MM] LUFTWAFFE | Mirage", -- 12
    "[DM] BCORE MSK", -- 13
    "[DM] ABOBA ONLY SCOUT", -- 14
    "[DM] FURIOS", -- 15
    "[DM] SHARKPROJECT", -- 16
    "[DM] FURIOS 1x1", -- 17
    "[DM] LoveSync 1x1" -- 18
})
local line_separator_servers = menu.add_separator("TrollTalk [CONNECTS]")

-- SERVERS CODE
local servers_name = {
    [1] = "connect 37.230.210.201:27015", --mm
    [2] = "connect 46.174.53.93:27015", --mm
    [3] = "connect 194.93.2.243:27015", --mm
    [4] = "connect 62.122.215.105:6666", --mm
    [5] = "connect 46.174.51.137:7777", --mm
    [6] = "connect 46.174.52.172:1488", --mm
    [7] = "connect 37.230.210.105:27015", --mm
    [8] = "connect 45.42.247.14:27030", --mm
    [9] = "connect 135.125.188.95:27015", --mm
    [10] = "connect 37.230.228.144:27015", --mm
    [11] = "connect 109.237.108.26:1337", --mm
    [12] = "connect 45.136.204.23:1337", --mm
    [13] = "connect 45.93.200.164:27015", --dm
    [14] = "connect 37.230.162.24:1337", --dm
    [15] = "connect 194.93.2.169:27015", --dm
    [16] = "connect 46.174.51.108:27015", --dm
    [17] = "connect 37.230.137.221:27015", --dm 1x1
    [18] = "connect 185.248.101.137:29100" --dm 1x1
}

menu.add_button("TrollTalk [CONNECTS]", "JOIN SERVER", function()
    print("The server you are connecting to: " .. servers_name[list:get()])
    engine.execute_cmd(servers_name[list:get()])
end)

-- MAIN TROLLTALK
gui.group_name = "TrollTalk [MANAGMENT]"

local script_enable = menu.add_checkbox(gui.group_name, "Enable Talker", false)
local enable_clantag = menu.add_checkbox(gui.group_name, "Enable ClanTag", false)

gui.selected_list = menu.add_selection(gui.group_name, "Modes:", (function()
    local tbl = {}
    for k, v in pairs(troll_talk.phrases) do
        table.insert(tbl, ("%d. %s"):format(k, v.name))
    end

    return tbl
end)())

-- TROLLTALK CODE
troll_talk.player_die = function(event)

    if event.attacker == event.userid or not script_enable:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local selected_trollsay_list = troll_talk.phrases[gui.selected_list:get()].phrases
    local selected_phrase = selected_trollsay_list[client.random_int(1, #selected_trollsay_list)]:gsub('\"', '')

    engine.execute_cmd(('say "%s"'):format(selected_phrase))
end

callbacks.add(e_callbacks.EVENT, troll_talk.player_die, "player_death")


-- CLANTAG
local ffi_handler = {}
local tagChange = {}

tagChange.script_tag = {
    "⏳         p",
    "⏳         pr",
    "⌛         pri",
    "⌛         prim",
    "⏳         primo",
    "⏳         prim",
    "⌛         pri",
    "⌛         pr",
    "⏳         p",

}

local str_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tagChange.last_time_update = -1
tagChange.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tagChange.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tagChange.last_time_update = current_tick + 16
    end
end

tagChange.current_tag = "empty_string"

tagChange.disabled = true
tagChange.on_paint = function()

    local is_enabled = enable_clantag:get()
    if not engine.is_in_game() or not is_enabled then
        if not is_enabled and not tagChange.disabled then
            ffi_handler.change_tag_fn("", "")
            tagChange.disabled = true
        end

        tagChange.last_time_update = -1
        return
    end    

    if tag_speed == 0 then
        tagChange.update(gui_tag)
        return
    end

    local current_tag = math.floor(global_vars.cur_time() * 1.2 % #tagChange.script_tag) + 1
    current_tag = tagChange.script_tag[current_tag]

    tagChange.disabled = false
    tagChange.update(current_tag)
end

callbacks.add(e_callbacks.PAINT, tagChange.on_paint)

-- OFF SCRIPT
local function shutdown_lua()
    client.log(color_t(0, 222, 0), "see you later ;)")
end

callbacks.add(e_callbacks.SHUTDOWN, shutdown_lua)