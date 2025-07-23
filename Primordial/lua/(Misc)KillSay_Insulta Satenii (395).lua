-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

print("-> Initializing Insulta_Satanii_v2...")
print("-> ...")
print("-> ..")
print("-> .")
print(" _____________________________________")
print("|        Insulta_Satanii_v2           |")
print("|_____________________________________|")
print("|           Version: 1.3              |")
print("|_____________________________________|")
print("|        Dev: blanktnt#6221           |")
print("|_____________________________________|")

--add

menu.add_text("info", "Welcome "..user.name.. " to Insulta satenii by x22")

local kill_say = {}
local ui = {}
kill_say.phrases = {}

table.insert(kill_say.phrases, {
    name = "Romanian", 
    phrases = {
    "Foaie verde castravete ti-am dat resolve prin perete.",
    "Foaie verde si-o lalea mars d-aici in pula mea.",
    "Foaie verde de marar dai Doamne resolver la taran.",
    "Foaie verde de kkt du-te drq de carat.",
    "Foaie verde si-un carat in ma-ta pula mi-am bagat.",
    "Foaie verde ce carat direct in glontu meu s-a bagat.",
    "Foaie verde si 2 gay dute si tu sa fiti 3.",
    "Foaie verde si 2 lei iti dau 1 si ai 3",
    "Foaie verde 2 missuri cfg sau resolver issue?",
    "Foaie verde si-un taran de pe harta te-am zburat.",
    "Foaie verde si-o aluna plutesti pe harta de zici ca esti pe luna.",
    "Foaie verde 2 pitici esti si slab si te si oftici.",
    "Foaie verde si-o lalea i-a mai da-te in pula mea.",
    "Foaie verde patrunjel mai stai si pe burta nitel.",    
    "Foaie verde pastrav mort du-te si da refund la cod.",
    "Foaie verde si-un topor iti dau cu jocu in cap pana te omor.",
    "Foaie verde si-o lalea ne-am bagat pula in mata",
    "Foaie verde kkt purpuriu du-te drq de pedofil",
    "Foaie verde floci pe pula direct coiu la mata-n gura",
    "Foaie verde piept de curcan fututi mortii matii de taran.",
    "Foaie verde kkt  uscat du-te drq de carat.",
    "Foaie verde cap taiat fututi mortii matii de retardat.",
    "Foaie verde gura de leu ti-am dat cap si tu rateu.",
    "Foaie verde KD de kkt i-am dat cap la kkt",
    "Foaie verde copil adoptat te-am trimis ianpoi la orfelinat.",
    "Foaie verde si-o curva stai, seamana cu mata aia ciunga!",
    "Foaie verde paster obosit eu dau cap da tu cand?",
    "Foaie verde vrajitor ti-am dat predict la picior",
    "Foaie verde walkbot prost eu trag la cap da tu?",
    "Daca imi vezi pula ca paru poti sa canti ca Dan Spataru",
    "Hai la gratar sa-ti frig o muie",
    "Sa iti dea dumnezu maini scurte si mancarimi in cur",
    "Da-mi limbi in varf la pula pana ramai fara dantura",
    "Arunca tactu cu sabia dupa tine sa zici ca te joci shadow fight 2",
   "Baga-mi-as pula-n ma-ta aia oloaga ca ti-am aratat pula ai intrebat de ce are banana vene",
  "Isi dau sobolanii interval la tine in stomac",
     "Sa ii dau lu ma-ta fatalitate ca la mortal kombat X",
  "Daca iti pun pula pe frunte te vezi cocos de munte",
      "Sa imi trag pula-n rinichii ma-tii",
       "Ce urat vorbesti da-ti-as pula sa mi-o freci",
   "Rasa ma-tii de handicapat ca iti face foamea patinaj artistic in tine",
            "Ai corpu ala zici ca-i curba deosebit de periculoasa", 
            "Are ma-ta mare nasu ala zici ca-i capitanu knakals",
 "Intra pula-n curu tau ca metrou in depou"
        
    }
})

table.insert(kill_say.phrases, {
    name = "English",
    phrases = { 
    "Your resistance only makes my penis harder!",
    "Grab them, squeeze them, pinch them, pull them, lick them, bite them, suck them!",
    "It feels like his dick is sliding into a slimy pile of macaroni!",
    "Cum, you naughty cock! Do it! Do it! DO IT!!!",
    "Ahhhh... It's like a dream come true... I get to stick my dick inside Tatsuki Chan's ass...!",
    "This is the cock block police! Hold it right there!",
    "Y-You'll break M-my womb M-Master",
    "Ohoo, getting creampied made you cum? What a lewd bitch you are!",
    "I've jerked off every single day... Given birth to countless snails... All while fantasizing about the day I'd get to fuck you!",
    "You're looking at porn when you could be using your little sister instead!",
    "Umm... I don't wanna sound rude, but have you had a bath? Your panties look a bit yellow...",
    "H-hey, hey S-Sempai... W-wanna cuddle? UwU",
    "F-fuck my bussy M-Master!",
    "Hey, who wants a piece of this plump 19-year-old boy-pussy? Single file, boys, come get it while it's hot!",
    "Kouji-Kun, if you keep thrusting that hard, my boobs will fall off!",
    "Papa you liar! How could you say that while having such a HUGE erection.",
    "I-I just wanna borrow y-your dick...",
    "Hehe don't touch me there Onii-chann UwU",
    "Your cum is all over my wet clit M-Master",
    "It Feels like you're pounding me with the force of a thousand suns Senpai",
    "I like when Y-you fill me with your baby water S-Senpai",
    "Y-yes right there S-Sempai hooyah",
    "P-please keep filling my baby chamber S-Sempai",
    "O-Onii-chan it felt so good when you punded my bussy",
    "P-please Onii-chan keep filling my baby chamber with your melty juice",
    "O-Onii-chan you just one shot my baby chamber",
    "I-Im nothing but a F-fucktoy slut for your M-monster fuckmeat!",
    "Dominate my ovaries with your vicious swimmers!",
    "Impregnate me with your viral stud genes!",
    "M-My body yearns for your sweet dick milk",
    "Y-Your meat septer has penetrated my tight boy hole",
    "M-My nipples are being tantalized",
    "Mnn FASTER... HARDER! Turn me into your femboy slut~!",
    "Penetrate me until I bust!",
    "Mmmm- soothe me, caress me, Fuck me, breed me!",
    "Probe your thick, wet, throbbing cock deeper and deeper into my boipussy~!!",
    "I'm your personal cum bucket!!",
    "Hya! Not my ears! Ah... It tickles! Ah!",
    "Can you really blame me for getting a boner after seeing that?",
    "The two of us will cover my sis with our cum!",
    "Kouta... I can't believe how BIG his... Wait! Forget about that!! Is Nyuu-chan really giving him a Tit-Fuck!?",
    "Senpai shove deeper your penis in m-my pussy (>ω<) please",
    "This... This is almost like... like somehow I'm the one raping him!",
    "I'm coming fwom you fwuking my asshole mmyyy!",
    "Boys just can't consider themselves an adult... Until they've had a chance to cum with a girl's ampit.",
    "P-Please be gentle, Goku-Senpai!",
    "We're both gonna fuck your pussy at the same time!"
       
        
    }
})
table.insert(kill_say.phrases, {
    name = "Russian",
    phrases = { 
        "Ниже твоего кд только твой iq",
        "Купи себе ПК, хватит играть на компе из школьной библиотеки",
        "Назвать тебя дауном это комплимент, учитыавя то, насколько ты на самом деле туп.",
        "В твоём теле около 37 миллионов клеток, и ты, прямо сейчас, разочаровываешь их всех.",
        "Если бы я спрыгнул с тоего чсв на твой iq я бы умер на полпути от голода.",
        "Я не trashtalk'аю тебя, я просто говорю с trash'эм",
        "Учёные придумали число 0 когда подсчитали твои шансы сделать что-нибудь полезное.",
        "Ты из тех людей которые занимают третье место, играя 1 v 1",
        "Ты причина легализации абортов.",
        "Кто поставил сложность ботов на мирную?",
        "Я бы назвал тебя раком, но рак убивает.",
        "Я бы спросил сколько тебе лет, но я знаю что ты не умеешь считать до таких больших чисел.",
        "Некоторым  платят за оральный cekc, но ты делаешь это бесплатно.",
        "Две ошибки всегда приводят к третьей. Твои родители наглядный тому пример.",
        "Я бы посоветовал тебе застрелиться, но уверен что ты промажешь.",
        "Посоветуй сайт где можно скинуться тебе на лечение.",
        "Дешевле тебя был только тот рваный гандон который использовал твой отец.",
        "Бог юморист: не веришь — посмотри на себя в зеркало.",
        "Любое сходство между тобой и человеком является чисто случайным.",
        "Твой плейстайл доказательство того, что мастурбация вызывает слепоту",
        "Сразу видно: мать не хотела, отец не старался.",
        "Я уверен что твоя дакимакура гордиться тобой",
        "Некоторых детей роняли на голову, но тебя явно кидали об стену.",
        "Даже если ты выстрелишь в землю, ты промажешь.",
        "Ты знаешь что акулы убивают 5 человек за год? Похоже у тебя есть серьёзные конкуренты.",
        "Выключи кс. Просто выйди на улицу и подойди к ближайшему дереву и извинись за то, что тратишь кислород."
    }
})


table.insert(kill_say.phrases, {
    name = "Fancy",
    phrases = {
        "𝕨𝕙𝕖𝕟 𝕞𝕖 𝕞𝕠𝕟𝕖𝕪, 𝕪𝕠𝕦 𝕡𝕠𝕠𝕣. 𝕎𝕙𝕖𝕟 𝕞𝕖 𝕙𝕒𝕡𝕡𝕪, 𝕪𝕠𝕦 𝕤𝕒𝕕. 𝕎𝕙𝕖𝕟 𝕒𝕝𝕝𝕒𝕙 𝕘𝕠𝕠𝕕, 𝕒𝕝𝕨𝕒𝕪𝕤.",
        "𝕒𝕝𝕝𝕒𝕙 𝕒𝕟𝕕 𝕪𝕠𝕦 𝕚𝕤 𝕤𝕚𝕞𝕚𝕝𝕒𝕣. 𝕪𝕠𝕦 𝕓𝕠𝕥𝕙 𝕕𝕖𝕒𝕕 𝕒𝕝𝕝 𝕥𝕚𝕞𝕖, 𝕪𝕠𝕦 𝕓𝕠𝕥𝕙 𝕙𝕒𝕤 𝕗𝕒𝕜𝕖 𝕚𝕕𝕖𝕒 𝕠𝕗 𝕨𝕚𝕟, 𝕒𝕟𝕕 𝕪𝕠𝕦 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕝𝕝 𝕕𝕖𝕒𝕕. 𝕓𝕦𝕥 𝕠𝕟𝕖 𝕚𝕤 𝕕𝕚𝕗𝕗𝕖𝕣𝕖𝕟𝕥, 𝕒𝕝𝕝𝕒𝕙 𝕔𝕒𝕟 𝕜𝕚𝕝𝕝 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕕𝕣𝕖𝕒𝕞 𝕠𝕗 𝕚𝕥",
        "𝕣𝕒𝕞𝕒𝕕𝕒𝕞 𝕙𝕒𝕤 𝕓𝕖𝕘𝕚𝕟 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕓𝕠𝕥. 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕓𝕖𝕘𝕚𝕟 𝕕𝕚𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕤𝕥𝕒𝕣𝕥 𝕤𝕡𝕚𝕟𝕓𝕠𝕥 𝕥𝕠 𝕘𝕚𝕧𝕖 𝕙𝕖𝕝𝕝",
        "𝔸𝕝𝕝𝕒𝕙 𝕝𝕚𝕧𝕖 𝔸𝕝𝕝𝕒𝕙 𝕕𝕚𝕖, 𝕒𝕝𝕝 𝕪𝕠𝕦 𝕕𝕠 𝕚𝕤 𝕕𝕚𝕖. ℂ𝕙𝕠𝕠𝕤𝕖 𝕒𝕝𝕝𝕒𝕙",
        "𝕘𝕣𝕒𝕤𝕤 𝕙𝕚𝕝𝕝 𝕚𝕤 𝕨𝕙𝕖𝕣𝕖 𝕪𝕠𝕦 𝕘𝕠 𝕓𝕒𝕔𝕜 𝕒𝕗𝕥𝕖𝕣 𝕥𝕙𝕚𝕤 𝕝𝕠𝕤𝕖, 𝕚 𝕠𝕨𝕟 𝕥𝕙𝕒𝕥 𝕙𝕚𝕝𝕝 𝕪𝕠𝕦 𝕔𝕒𝕝𝕝 𝕙𝕠𝕞 𝕤𝕠 𝕕𝕠𝕟𝕥 𝕓𝕖 𝕘𝕠𝕚𝕟𝕘 𝕓𝕒𝕔𝕜 𝕒𝕗𝕥𝕖𝕣 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕔𝕣𝕪𝕚𝕟𝕘 𝕥𝕠 𝕪𝕠𝕦 𝕕𝕠𝕘",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕨𝕠𝕣𝕜 𝕔𝕠𝕥𝕥𝕠𝕟 𝕚 𝕒𝕞 𝕨𝕠𝕣𝕜 𝕔𝕠𝕟𝕗𝕚𝕘 𝕠𝕟 𝕤𝕖𝕝𝕝𝕪.𝕘𝕘",
        "𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕤𝕔𝕒𝕣𝕖𝕕 𝕒𝕥 𝕟𝕚𝕘𝕙𝕥 𝕓𝕖𝕔𝕠𝕠𝕤𝕖 𝕞𝕠𝕟𝕥𝕖𝕣 𝕦𝕟𝕕𝕖𝕣 𝕓𝕖𝕕? 𝕨𝕖𝕝𝕝 𝕚 𝕙𝕒𝕤 𝕤𝕠𝕞𝕖𝕥𝕙𝕚𝕟𝕘 𝕥𝕖𝕝𝕝 𝕪𝕠𝕦. 𝕪𝕠𝕦 𝕚𝕤 𝕥𝕙𝕖 𝕞𝕠𝕟𝕤𝕥𝕖𝕣 𝕙𝕚𝕟𝕕𝕚𝕟𝕘 𝕚𝕟 𝕡𝕒𝕝𝕒𝕔𝕖 𝕒𝕟𝕕 𝕚 𝕙𝕤 𝕪𝕠𝕦",
        "𝕀𝕟 𝕕𝕖𝕤𝕡𝕖𝕣𝕒𝕥𝕖 𝕥𝕚𝕞𝕖𝕤, 𝕚𝕟 𝕕𝕖𝕤𝕡𝕖𝕣𝕒𝕥𝕖 𝕟𝕖𝕖𝕕, 𝔸𝕝𝕝𝕒𝕙 𝕚𝕤 𝕙𝕖𝕣𝕖, 𝕒𝕟𝕕 𝕥𝕙𝕚𝕤 𝕓𝕦𝕝𝕝𝕖𝕥 𝕥𝕠... ℍ$!!!",
        "𝕜𝕖𝕪𝕓𝕠𝕣𝕕 𝕔𝕝𝕚𝕔𝕜? 𝕟𝕠𝕥 𝕛𝕦𝕤𝕥 𝕞𝕪 𝕙𝕚𝕥𝕥𝕚𝕟𝕘 𝕤𝕠𝕦𝕟𝕕 𝕦𝕤𝕚𝕟𝕘 𝕊𝕀𝔾𝕄𝔸.𝕃𝕌𝔸#",
        "𝕞𝕪 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕔𝕙𝕒𝕤𝕖 𝕪𝕠𝕦 𝕝𝕚𝕜𝕖 𝕪𝕠𝕦 𝕔𝕙𝕒𝕤𝕖 𝕓𝕒𝕘, 𝕠𝕟𝕝𝕪 𝕕𝕚𝕗𝕗𝕖𝕣𝕖𝕟𝕥 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕞𝕪 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕘𝕖𝕥𝕤 𝕪𝕠𝕦 𝕙𝕤 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕕𝕠 𝕚𝕤 𝕟𝕠𝕥 𝕘𝕖𝕥 𝕥𝕙𝕖 𝕓𝕒𝕘",
        "𝔼ℤ 𝕗𝕠𝕣 𝕞𝕖 𝕥𝕙𝕒𝕟𝕜 𝕪𝕠𝕦 𝕗𝕠𝕣 𝕥𝕚𝕜𝕥𝕠𝕜 𝕙𝕒𝕔𝕜𝕖𝕣𝕧𝕙 𝕞𝕖𝕕𝕚𝕒",
        "𝕝𝕖𝕥 𝕪𝕠𝕦 𝕡𝕒𝕣𝕖𝕟𝕥𝕤 𝕜𝕟𝕠𝕨 𝕪𝕠𝕦 𝕕𝕚𝕖 𝕒𝕗𝕥𝕖𝕣 𝕥𝕙𝕚𝕤 𝕝𝕠𝕤𝕖, 𝕤𝕚𝕘𝕞𝕒 𝕡𝕣𝕖𝕕𝕚𝕔𝕥𝕚𝕠𝕟 𝕨𝕠𝕟𝕥 𝕤𝕒𝕧𝕚𝕟𝕘 𝕪𝕠𝕦 𝕟𝕠𝕨 𝕨𝕠𝕣𝕥𝕙 𝕝𝕖𝕤𝕤 𝕓𝕠𝕥",
        "𝕕𝕠𝕘 𝟛𝕣𝕕 𝕨𝕠𝕣𝕝𝕕𝕖𝕣𝕤 𝕤𝕖𝕟𝕥 𝕓𝕒𝕔𝕜 𝕥𝕠 𝕤𝕝𝕦𝕞 𝕓𝕪 𝟙𝕤𝕥 𝕨𝕠𝕣𝕝𝕕 𝕘𝕠𝕕 𝕓𝕪 𝕥𝕙𝕚𝕤 𝕙𝕤",
        "𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕔𝕠𝕟𝕗𝕚𝕘𝕦𝕣𝕒𝕥𝕚𝕠𝕟 𝕚𝕤𝕤𝕦𝕖? 𝕟𝕠, 𝕪𝕠𝕦 𝕙𝕒𝕧𝕖 𝕞𝕠𝕟𝕖𝕪 𝕚𝕤𝕤𝕦𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕪𝕠𝕦 𝕨𝕠𝕣𝕜 𝕒𝕝𝕝 𝕕𝕒𝕪 𝕨𝕚𝕥𝕙 𝕟𝕠 𝕣𝕖𝕥𝕦𝕣𝕟 𝕨𝕙𝕚𝕝𝕖 𝕚 𝕡𝕝𝕒𝕪 𝕒𝕟𝕕 𝕞𝕒𝕜𝕖 𝕞𝕚𝕝𝕝𝕚𝕠𝕟 𝕨𝕠𝕣𝕜𝕚𝕟𝕘 𝕪𝕠𝕦 𝕗𝕒𝕞𝕚𝕝𝕪 𝕠𝕦𝕥 𝕚𝕟 𝕥𝕙𝕖 𝕗𝕚𝕖𝕝𝕕",
        "𝕥𝕙𝕖 𝕓𝕣𝕠𝕨𝕤𝕖𝕣 𝕙𝕒𝕤 𝕪𝕠𝕦 𝕡𝕒𝕤𝕤𝕨𝕠𝕣𝕕 𝕤𝕒𝕧𝕖. 𝕚 𝕘𝕖𝕥 𝕪𝕠𝕦 𝕡𝕒𝕤𝕤𝕨𝕠𝕣𝕕𝕤 𝕥𝕠 𝕦𝕤𝕖 𝕠𝕟 𝕒𝕔𝕔𝕠𝕦𝕟𝕥𝕤 𝕒𝕟𝕕 𝕞𝕒𝕜𝕖 𝕒𝕝𝕝 𝕪𝕠𝕦 𝕝𝕚𝕥𝕥𝕝𝕖 𝕞𝕠𝕟𝕖𝕪 𝕥𝕠 𝕞𝕪 𝕒𝕔𝕔𝕠𝕦𝕟𝕥?",
        "𝕥𝕪𝕡𝕚𝕔𝕒𝕝 𝕓𝕠𝕥𝕥𝕪𝕤 𝕟𝕖𝕖𝕕 𝕥𝕠 𝕖𝕒𝕥 𝕗𝕠𝕠𝕕 𝕨𝕙𝕖𝕟 𝕪𝕠𝕦 𝕡𝕝𝕒𝕪. 𝕓𝕦𝕥 𝕔𝕒𝕟𝕥 𝕙𝕖𝕝𝕡 𝕞𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕔𝕒𝕟 𝕡𝕝𝕒𝕪 𝕖𝕧𝕖𝕣𝕪𝕕𝕒𝕪 𝕚 𝕙𝕒𝕧𝕖 𝕤𝕝𝕒𝕧𝕖 𝕥𝕠 𝕖𝕒𝕥 𝕗𝕠𝕣 𝕞𝕖 𝕒𝕟𝕕 𝕥𝕙𝕒𝕥 𝕤𝕝𝕒𝕧𝕖 𝕪𝕠𝕦 𝕓𝕠𝕥",
        "𝔸𝕗𝕣𝕚𝕔𝕒 𝕣𝕚𝕔𝕙𝕖𝕤𝕥 𝕔𝕠𝕦𝕟𝕥𝕣𝕪 𝕚𝕟 𝕨𝕠𝕣𝕝𝕕 𝕨𝕙𝕚𝕝𝕖 𝕒𝕝𝕝 𝕣𝕦𝕤𝕤𝕚𝕒𝕟 𝕒𝕟𝕕 𝔼𝕌 𝕕𝕠𝕘𝕤 𝕤𝕖𝕟𝕥 𝕓𝕒𝕔𝕜 𝕥𝕠 𝕤𝕝𝕠𝕧𝕒𝕜𝕚𝕒 𝕠𝕟 𝕥𝕣𝕒𝕚𝕟 𝕥𝕠 𝕘𝕖𝕣𝕞𝕒𝕟𝕪 𝕨𝕙𝕚𝕝𝕖 𝕓𝕖𝕘 𝕗𝕠𝕣 𝕗𝕠𝕣𝕘𝕚𝕧𝕖𝕣𝕟𝕖𝕤𝕤 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖𝕪 𝕗𝕒𝕞𝕚𝕝𝕪",
        "𝕐𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕚𝕤 𝕡𝕠𝕠𝕣, 𝕪𝕠𝕦𝕣 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕚𝕤 𝕡𝕠𝕠𝕣. 𝕦𝕟𝕝𝕚𝕜𝕖 𝕊𝕀𝔾𝕄𝔸.𝕃𝕌𝔸 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕔𝕒𝕟𝕥 𝕒𝕗𝕗𝕠𝕣𝕕 (𝕒𝕞𝕖𝕟). 𝔸𝕝𝕝 𝕓𝕣𝕠𝕥𝕙𝕖𝕣 𝕖𝕒𝕥 𝕒𝕝𝕝 𝕓𝕣𝕠𝕥𝕙𝕖𝕣 𝕕𝕚𝕖 ℍ𝕊",
        "ℂ𝕠𝕦𝕟𝕥𝕖𝕣 𝕥𝕖𝕣𝕣𝕠𝕣𝕚𝕤𝕥 𝕨𝕚𝕟? 𝕥𝕣𝕦𝕖 𝕙𝕖𝕣𝕖 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕪𝕠𝕦 𝕔𝕠𝕦𝕟𝕥𝕣𝕪 𝕚𝕤 𝕥𝕖𝕣𝕣𝕠𝕣𝕚𝕤𝕥 𝕓𝕦𝕥 𝕞𝕪 𝕔𝕠𝕦𝕟𝕥𝕣𝕪 𝕚𝕤 𝕣𝕚𝕔𝕙 𝕒𝕟𝕕 𝕪𝕠𝕦 𝕝𝕚𝕧𝕖 𝕤𝕝𝕦𝕞𝕤",
        "𝔹𝕦𝕝𝕝𝕖𝕥 𝕔𝕠𝕞𝕖 𝕓𝕦𝕝𝕝𝕖𝕥 𝕘𝕠, 𝕚 𝕤𝕥𝕒𝕪 𝕠𝕨𝕟𝕚𝕟𝕘. ℍ𝕤 𝕙𝕖𝕣𝕖 ℍ𝕤 𝕥𝕙𝕖𝕣𝕖 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕙𝕖𝕣𝕖.",
        "𝕋𝕙𝕒𝕟𝕜𝕤 𝕘𝕠𝕕𝕤 𝕗𝕠𝕣 𝕙𝕚𝕞 𝕞𝕒𝕜𝕚𝕟𝕘 𝕞𝕖 𝕙𝕤 𝕪𝕠𝕦, 𝕁𝕆𝕂𝔼 𝕚 𝕒𝕝𝕨𝕒𝕪𝕤 𝕜𝕚𝕝𝕝",
        "𝕀 𝕠𝕨𝕟 𝕕𝕖𝕧𝕖𝕝𝕠𝕡𝕠𝕣 𝕥𝕙𝕚𝕤 𝕘𝕒𝕞𝕖 𝕒𝕟𝕕 𝕪𝕠𝕦 𝕠𝕟𝕝𝕪 𝕓𝕖𝕘 𝕗𝕣𝕠𝕞 𝕗𝕠𝕣𝕘𝕚𝕧𝕖 𝕗𝕣𝕠𝕞 𝕞𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕘𝕚𝕧𝕖 𝕪𝕠𝕦 𝕒𝕝𝕝 𝕙𝕤 𝕗𝕠𝕣 𝕗𝕣𝕖𝕖",
        "𝔸𝕗𝕣𝕚𝕔𝕒 𝕣𝕚𝕔𝕙𝕖𝕤𝕥 𝕔𝕠𝕦𝕟𝕥𝕣𝕪 𝕚𝕟 𝕨𝕠𝕣𝕝𝕕 𝕨𝕙𝕚𝕝𝕖 𝕒𝕝𝕝 𝕣𝕦𝕤𝕤𝕚𝕒𝕟 𝕒𝕟𝕕 𝔼𝕌 𝕕𝕠𝕘𝕤 𝕤𝕖𝕟𝕥 𝕓𝕒𝕔𝕜 𝕥𝕠 𝕤𝕝𝕠𝕧𝕒𝕜𝕚𝕒 𝕠𝕟 𝕥𝕣𝕒𝕚𝕟 𝕥𝕠 𝕘𝕖𝕣𝕞𝕒𝕟𝕪 𝕨𝕙𝕚𝕝𝕖 𝕓𝕖𝕘 𝕗𝕠𝕣 𝕗𝕠𝕣𝕘𝕚𝕧𝕖𝕣𝕟𝕖𝕤𝕤 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖𝕪 𝕗𝕒𝕞𝕚𝕝𝕪",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "ℕ𝕖𝕧𝕖𝕣𝕝𝕠𝕤𝕖 𝕞𝕠𝕣𝕖 𝕝𝕚𝕜𝕖𝕤 𝕒𝕝𝕨𝕒𝕪𝕤𝕘𝕖𝕥𝕙𝕤? 𝕪𝕠𝕦 𝕚𝕤 𝕓𝕖𝕘 𝕗𝕠𝕣 𝕚𝕥 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕠𝕟𝕝𝕪 𝕣𝕖𝕔𝕚𝕧𝕖 𝕨𝕙𝕖𝕟 𝕪𝕠𝕦 𝕡𝕒𝕪 𝕗𝕠𝕣 𝕚𝕥, 𝕝𝕚𝕜𝕖 𝕊𝕀𝔾𝕄𝔸.𝕃𝕌𝔸 𝕪𝕠𝕦 𝕨𝕚𝕝𝕝 𝕨𝕚𝕟 𝕨𝕙𝕖𝕟 𝕪𝕠𝕦 𝕙𝕒𝕤 𝕚𝕥 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕔𝕒𝕟𝕥 𝕘𝕖𝕥 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕡𝕦𝕓𝕝𝕚𝕔 𝕦𝕤𝕖𝕣",
        "𝕔𝕙𝕠𝕡𝕡𝕒 𝕚𝕟 𝕞𝕪 𝕙𝕒𝕟𝕕 𝕓𝕦𝕥 𝕒𝕝𝕝𝕒𝕙 𝕚𝕤 𝕚𝕟 𝕥𝕙𝕖 𝕤𝕒𝕟𝕕",
        "𝕐𝕠𝕦 𝕨𝕒𝕤 𝕦𝕜𝕣𝕒𝕚𝕟e, 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕓𝕠𝕞𝕓 (𝕣𝕠𝕤𝕖), 𝕪𝕠𝕦 𝕘𝕦𝕟 𝕓𝕦𝕥 𝕞𝕚𝕤𝕤. 𝕚 𝕨𝕒𝕤 𝕓𝕖𝕙𝕚𝕟𝕕 𝕨𝕒𝕝𝕝 𝕙𝕖𝕒𝕕 𝕨𝕙𝕖𝕣𝕖?",
        "𝕞𝕚𝕕𝕕𝕝𝕖 𝕖𝕒𝕤𝕥 𝕟𝕖𝕖𝕕𝕤 𝕥𝕠 𝕝𝕖𝕒𝕣𝕟 𝕓𝕠𝕞𝕓 𝕕𝕖𝕗𝕦𝕤𝕦𝕖𝕝 𝕥𝕒𝕔𝕜𝕥𝕚𝕔𝕤 𝕗𝕠𝕣 𝕔𝕠𝕦𝕟𝕥𝕖𝕣 𝕥𝕖𝕣𝕣𝕠𝕣𝕚𝕤𝕥 𝕒𝕟𝕕 𝕒𝕝𝕝 𝕔𝕠𝕦𝕟𝕥𝕣𝕪𝕖𝕤 𝕓𝕠𝕨 𝕕𝕠𝕨𝕟 𝕥𝕠 𝕞𝕖 𝕝𝕖𝕓𝕒𝕟𝕠𝕟 𝕜𝕚𝕟𝕘",
        "ℝ𝕒𝕞𝕒𝕕𝕒𝕟 𝕞𝕠𝕟𝕥𝕙 𝕠𝕧𝕖𝕣, 𝕛𝕦𝕤𝕥 𝕝𝕚𝕜𝕖 𝕪𝕠𝕦. ℕ𝕠𝕨 𝕚 𝕗𝕠𝕠𝕕, 𝕪𝕠𝕦 𝕟𝕠𝕥. 𝕀 𝕒𝕞 𝕠𝕧𝕖𝕣 𝕪𝕠𝕦, 𝕪𝕠𝕦 𝕓𝕖𝕝𝕠𝕨!",
        "𝔸𝕝𝕝𝕒𝕙 𝕝𝕚𝕧𝕖 𝔸𝕝𝕝𝕒𝕙 𝕕𝕚𝕖, 𝕒𝕝𝕝 𝕪𝕠𝕦 𝕕𝕠 𝕚𝕤 𝕕𝕚𝕖. ℂ𝕙𝕠𝕠𝕤𝕖 𝕒𝕝𝕝𝕒𝕙",
        "𝔸 𝕘𝕖𝕥 𝕓𝕠𝕞𝕓𝕕, 𝔸 𝕒𝕡𝕒𝕣𝕥𝕞𝕖𝕟𝕥 𝕟𝕠 𝕞𝕠𝕣𝕖. 𝔸 𝕔𝕠𝕞𝕡𝕝𝕒𝕚𝕟. 𝔸 𝕡𝕠𝕠𝕣, 𝕝𝕖𝕓𝕒𝕟𝕠𝕟 𝕤𝕥𝕒𝕪 𝕞𝕒𝕕",
        "𝕙𝕖𝕒𝕕𝕤𝕙𝕠𝕥 𝕥𝕠𝕡 𝕤𝕔𝕣𝕖𝕖𝕟 𝕥𝕙𝕒𝕥 𝕪𝕠𝕦 𝕕𝕖𝕒𝕕 𝕪𝕠𝕦 𝕤𝕡𝕖𝕔𝕥𝕠𝕖𝕣 𝕞𝕖 𝕪𝕠𝕦 𝕗𝕒𝕟?",
        "𝕒𝕝𝕝𝕒𝕙 𝕨𝕚𝕟𝕤 𝕪𝕠𝕦 𝕙𝕠𝕦𝕤𝕖 𝕚𝕟 𝕣𝕒𝕗𝕗𝕖𝕝 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕨𝕚𝕟 𝕙𝕤 𝕚𝕟 𝕣𝕒𝕗𝕗𝕖𝕝",
        "𝕪𝕠𝕦 𝕝𝕦𝕔𝕜𝕖𝕣 𝕨𝕙𝕖𝕟 𝕚 𝕙𝕤 𝕚 𝕨𝕠𝕦𝕝𝕕 𝕟𝕚𝕗𝕖 𝕪𝕠𝕦 𝕚𝕟 𝕓𝕒𝕔𝕜𝕤𝕥𝕒𝕓 (◣◢)",
        "𝕪𝕠𝕦 𝕝𝕦𝕔𝕜 𝕨𝕙𝕖𝕟 𝕪𝕠𝕦 𝕤𝕡𝕚𝕟 𝕨𝕖𝕖𝕝 𝕚𝕤 𝟙𝟘𝟘 𝕡𝕖𝕣𝕤𝕖𝕟𝕥 𝕙𝕤 𝕗𝕣𝕠𝕞 𝕞𝕖",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪 𝕪𝕠𝕦",
        "𝕐𝕠𝕦 𝕝𝕦𝕔𝕜𝕪 𝕘𝕖𝕥 𝕜𝕚𝕝𝕝 𝕓𝕪 𝕞𝕖. 𝕚𝕥𝕤 𝕞𝕖 𝕨𝕙𝕠 𝕜𝕚𝕝𝕝 𝕓𝕖𝕔𝕒𝕤𝕦𝕤𝕖 𝕚 𝕤𝕙𝕠𝕠𝕥. 𝕤𝕠𝕞𝕖𝕥𝕚𝕞𝕖𝕤 𝕞𝕚𝕤𝕤 𝕤𝕠𝕞𝕖𝕥𝕚𝕞𝕖𝕤 𝕙𝕚𝕥 𝕚𝕥𝕤 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣",
        "𝕟𝕚𝕗𝕖𝕕 𝕪𝕠𝕦 𝕝𝕚𝕜𝕖 𝕚 𝕡𝕖𝕖𝕜𝕪 𝕓𝕝𝕚𝕟𝕕𝕖𝕣𝕤, 𝕪𝕠𝕦 𝕕𝕚𝕖 𝕝𝕚𝕜𝕖 𝕞𝕠𝕙𝕒𝕞𝕞𝕖𝕕 𝕓𝕒𝕔𝕜 𝕚𝕟 𝕥𝕙𝕖 𝕕𝕒𝕪𝕤 𝕨𝕙𝕖𝕟 𝕪𝕠𝕦 𝕪𝕠𝕦𝕟𝕘𝕖𝕣 𝕓𝕠𝕥",
        "𝕀𝕟 𝕞𝕚𝕣𝕒𝕘𝕖 𝕡𝕖𝕠𝕡𝕝𝕖 𝕤𝕙𝕠𝕠𝕥, 𝕚𝕟 𝕞𝕚𝕣𝕒𝕘𝕖 𝕡𝕖𝕠𝕡𝕝𝕖 𝕕𝕚𝕖. 𝕀𝕟 𝕞𝕚𝕣𝕒𝕘𝕖 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕓𝕣𝕖𝕒𝕜 𝕚𝕟 𝕞𝕚𝕣𝕒𝕘𝕖 𝕡𝕖𝕠𝕡𝕝𝕖 𝕙𝕒𝕥𝕖",
        "𝕓𝕝𝕠𝕠𝕕 𝕡𝕠𝕣𝕖𝕤 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖 𝕥𝕠𝕡 𝕠𝕗 𝔻𝔼_𝕄𝕀ℝ𝔸𝔾𝔼 𝕓𝕦𝕥 𝕡𝕠𝕝𝕚𝕔𝕖 𝕨𝕠𝕟𝕣𝕕𝕖𝕣 𝕨𝕙𝕠 𝕓𝕝𝕠𝕠𝕕 𝕚𝕤? 𝕚𝕥 𝕪𝕠𝕦 𝕓𝕝𝕠𝕠𝕕 𝕚 𝕖𝕩𝕡𝕝𝕠𝕕𝕖 𝕪𝕠𝕦 𝕨𝕚𝕥𝕙 𝕤𝕙𝕠𝕠𝕥𝕘𝕦𝕟",
        "𝕎𝕙𝕖𝕟 𝕚 𝕨𝕒𝕝𝕜 𝕦𝕡 𝕝𝕒𝕕𝕕𝕖𝕣 𝕒𝕟𝕕 𝕪𝕠𝕦 𝕝𝕠𝕠𝕜 𝕨𝕚𝕥𝕙 𝕣𝕚𝕗𝕖𝕝. 𝕀 𝕤𝕙𝕠𝕠𝕥 𝕓𝕖𝕗𝕠𝕣 𝕒𝕟𝕕 𝕤𝕟𝕚𝕡𝕖𝕣 𝕪𝕠𝕦. 𝕐𝕠𝕦 𝕒𝕣𝕖 𝕟𝕠𝕨 𝕠𝕟 𝕘𝕣𝕠𝕦𝕟𝕕 𝕨𝕚𝕥𝕙 𝕗𝕒𝕞𝕚𝕝𝕪 (𝔻𝕆𝔾)",
        "𝕚 𝕨𝕚𝕡𝕖 𝕥𝕙𝕖 𝕗𝕝𝕠𝕠𝕣 𝕒𝕗𝕥𝕖𝕣 𝕚 𝕜𝕚𝕝𝕝 𝕪𝕠𝕦 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕣𝕖𝕤𝕡𝕖𝕔𝕥 𝕪𝕠𝕦 𝕗𝕒𝕞𝕚𝕝𝕪",
        "𝔽𝕒𝕞𝕚𝕝𝕪 𝕒𝕝𝕨𝕒𝕪𝕤 𝕗𝕚𝕣𝕤𝕥 (𝕔𝕒𝕝𝕝 𝕞𝕖 𝕧𝕚𝕟 𝕕𝕚𝕖𝕤𝕖𝕝) 𝕥𝕙𝕖 𝕨𝕒𝕪 𝕚 𝕞𝕒𝕜𝕖 𝕥𝕙𝕖𝕤𝕖 𝕙𝕠𝕖𝕤 𝕨𝕖𝕒𝕤𝕖𝕝",
        "𝕙𝕚𝕥𝕞𝕒𝕟 𝕝𝕚𝕜𝕖 𝕞𝕖 𝕕𝕠𝕟𝕥 𝕘𝕠 𝕓𝕪 𝕣𝕖𝕒𝕝 𝕟𝕒𝕞𝕖, 𝕠𝕟𝕝𝕪 𝕓𝕚𝕘 𝕟𝕒𝕞𝕖 𝕓𝕪 𝕌ℕ𝕄𝔸𝕋ℂℍ𝔼𝔻 𝔾𝔾",
        "𝕌𝕊𝔼𝕃𝔼𝕊𝕊 𝔹𝟘𝕋 𝕠𝕨𝕟𝕖𝕕 𝕙𝕒𝕣𝕕 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝔾𝔸𝕄𝔼𝕊𝔼ℕ𝕊𝔼 𝔹𝔼𝕋𝔸 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣... 𝕪𝕠𝕦 𝕟𝕖𝕖𝕕 𝕥𝕖𝕝𝕝 𝕗𝕒𝕞𝕚𝕝𝕪 𝕪𝕠𝕦 𝕝𝕠𝕧𝕖 𝕓𝕖𝕗𝕠𝕣𝕖 𝕚 𝕜𝕚𝕝𝕝𝕖𝕕 𝕪𝕠𝕦",
        "𝕏𝕔𝕔 𝕒𝕟𝕕 𝕠𝕥𝕙𝕖𝕣 𝕡𝕖𝕡𝕠𝕝 𝕒𝕣𝕖 𝕤𝕙𝕠𝕠𝕥𝕚𝕟𝕘 𝕒𝕖𝕣. 𝕓𝕦𝕥 𝕞𝕖 ℍ𝕊 𝕪𝕠𝕦. 𝕟𝕠𝕨 𝕒𝕝𝕝 𝕗𝕒𝕞𝕚𝕝𝕪 𝕕𝕚𝕤𝕣𝕖𝕤𝕡𝕖𝕔𝕥 𝕓𝕦𝕥 𝕚𝕥𝕤 𝕗𝕚𝕟𝕖 𝕓𝕖𝕔𝕦𝕤𝕖 𝕥𝕙𝕖 𝕨𝕠𝕣𝕝𝕕 𝕚𝕤 𝕨𝕙𝕒𝕥 𝕚𝕤!",
        "𝕊𝕥𝕒𝕣𝕥 𝕥𝕠 𝕣𝕖𝕤𝕡𝕖𝕔𝕥 𝕪𝕠𝕦 𝕖𝕝𝕕𝕖𝕣𝕤 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕔𝕒𝕟𝕥 𝕣𝕖𝕤𝕡𝕖𝕔𝕥 𝕞𝕖 𝕚𝕗 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖𝕒𝕕 𝕓𝕠𝕥",
        "𝕓𝕠𝕥𝕥𝕪 𝕘𝕖𝕥 𝕤𝕙𝕠𝕥 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕤𝕙𝕠𝕥𝕥𝕪 𝕟𝕠𝕨 𝕚𝕞 𝕤𝕚𝕥𝕥𝕚𝕟𝕘 𝕠𝕟 𝕥𝕙𝕖 𝕡𝕠𝕥𝕥𝕪 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕙𝕒𝕧𝕖 𝕤𝕖𝕧𝕖𝕣𝕖 𝕕𝕚𝕒𝕓𝕖𝕥𝕖𝕤",
        "𝕐𝕠𝕦 𝕝𝕚𝕗𝕖 𝕘𝕠 𝕝𝕚𝕜𝕖 𝕪𝕠𝕦 𝕞𝕠𝕥𝕙𝕖𝕣 𝕠𝕨𝕟 𝕪𝕠𝕦 𝕙𝕚𝕞 𝕞𝕠𝕥𝕙𝕖𝕣 𝕠𝕨𝕟 𝕙𝕚𝕞 𝕥𝕙𝕖𝕟 𝕚 𝕠𝕨𝕟 𝕙𝕚𝕞 𝕒𝕤 𝕞𝕪 𝕤𝕝𝕒𝕧𝕖 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕚 𝕓𝕦𝕪𝕖𝕕 𝕚𝕥 𝕒𝕟𝕕 𝕥𝕙𝕖𝕟 𝕜𝕚𝕝𝕝 𝕒𝕝𝕝",
        "𝕃𝕚𝕗𝕖𝕙𝕒𝕔𝕜 𝕓𝕚𝕥𝕔𝕙 𝕤𝕒𝕪 𝕥𝕙𝕖 𝕣𝕦𝕤𝕤𝕚𝕒𝕟, 𝕨𝕙𝕖𝕣𝕖 𝕝𝕚𝕗𝕖 𝕙𝕒𝕔𝕜? 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕕𝕖𝕒𝕕 (𝕒𝕣𝕖 𝕕𝕖𝕒𝕕)",
        "Just because i wear black and keep a private journal, that doesn't mean I'm going to blow up the school. Or terrorize mindless cheerleaders, for that matter",
        "𝕀 𝔸𝕞 𝕊𝕒𝕕 𝕥𝕠 𝕥𝕙𝕖 𝕥𝕠𝕦𝕔𝕙, 𝕓𝕦𝕥𝕥 𝕞𝕪 𝕞𝕚𝕟𝕕 𝕚𝕤 𝕗𝕦𝕣𝕖𝕪𝕠𝕦𝕤 𝕝𝕚𝕜𝕖 𝕒 𝕥𝕪𝕘𝕖𝕣. 𝕪𝕠𝕦 𝕕𝕠𝕟𝕥 𝕞𝕖𝕤𝕤 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕓𝕠$$ 𝕠𝕗 𝕥𝕙𝕖 𝕨𝕠𝕣𝕝𝕕",
        "𝕎𝕙𝕖𝕟 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕠𝕟 𝕘𝕣𝕠𝕦𝕟𝕕 𝕙𝕒𝕧𝕚𝕟𝕘 𝕓𝕠𝕣𝕚𝕟𝕘 𝕚 𝕒𝕞 𝕦𝕡 𝕚𝕟 𝕘𝕠𝕝𝕕𝕖𝕟 𝕛𝕖𝕥 𝕨𝕚𝕥𝕙 𝕞𝕪 𝕓𝕒𝕟𝕕𝕤",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕠𝕠𝕞𝕖𝕕 𝕝𝕚𝕜𝕖 𝕥𝕙𝕚𝕤 𝕓𝕠𝕠𝕝𝕖𝕥 𝕔𝕠𝕞𝕚𝕟𝕘 𝕚𝕟 𝕙𝕚𝕘𝕙 𝕤𝕡𝕖𝕖𝕕𝕤 𝕥𝕠 𝕪𝕠𝕦𝕣 𝕓𝕣𝕒𝕚𝕟, 𝕀ℕ𝕊𝔸ℕ𝔼 𝕀ℕ 𝕋ℍ𝔼 𝔹ℝ𝔸𝕀ℕ. 𝕀 𝕒𝕞 𝕔𝕙𝕚𝕝𝕝",
        "𝔾𝕝𝕒𝕤𝕤𝕖𝕤 𝕖𝕟𝕙𝕒𝕟𝕤𝕖 𝕞𝕪 𝕘𝕒𝕞𝕖𝕡𝕝𝕒𝕪 𝕒𝕟𝕕 𝕫𝕠𝕠𝕞 𝕚𝕟 𝕪𝕠𝕦 𝕨𝕙𝕖𝕟 𝕚 ℍ$ 𝕪𝕠𝕦 𝕚𝕟 ℍ𝔻 𝕒𝕟𝕕 𝕘𝕖𝕥 𝕖𝕒𝕤𝕪 𝕨𝕚𝕟 𝕗𝕠𝕣 𝕞𝕪 𝕗𝕒𝕞𝕚𝕝𝕪",
        "𝕊𝕙𝕖 𝕔𝕒𝕟 𝕡𝕒𝕚𝕟𝕥 𝕒 𝕡𝕣𝕖𝕥𝕥𝕪 𝕡𝕚𝕔𝕥𝕦𝕣𝕖 𝕓𝕦𝕥 𝕥𝕙𝕚𝕤 𝕤𝕥𝕠𝕣𝕪 𝕙𝕒𝕤 𝕒 𝕥𝕨𝕚𝕤𝕥. 𝕋𝕙𝕖 𝕡𝕒𝕚𝕟𝕥𝕓𝕣𝕦𝕤𝕙 𝕚𝕤 𝕒 𝕣𝕒𝕫𝕠𝕣 𝕒𝕟𝕕 𝕥𝕙𝕖 𝕔𝕒𝕟𝕧𝕒𝕤 𝕚𝕤 𝕙𝕖𝕣 𝕨𝕣𝕚𝕤𝕥",
        "𝕏𝕔𝕔 𝕒𝕟𝕕 𝕠𝕥𝕙𝕖𝕣 𝕡𝕖𝕡𝕠𝕝 𝕒𝕣𝕖 𝕤𝕙𝕠𝕠𝕥𝕚𝕟𝕘 𝕒𝕖𝕣. 𝕓𝕦𝕥 𝕞𝕖 ℍ𝕊 𝕪𝕠𝕦. 𝕟𝕠𝕨 𝕒𝕝𝕝 𝕗𝕒𝕞𝕚𝕝𝕪 𝕕𝕚𝕤𝕣𝕖𝕤𝕡𝕖𝕔𝕥 𝕓𝕦𝕥 𝕚𝕥𝕤 𝕗𝕚𝕟𝕖 𝕓𝕖𝕔𝕦𝕤𝕖 𝕥𝕙𝕖 𝕨𝕠𝕣𝕝𝕕 𝕚𝕤 𝕨𝕙𝕒𝕥 𝕚𝕤!",
    }
})

ui.group_name = "Insulta Satenii"
ui.is_enabled = menu.add_checkbox(ui.group_name, "Insulta Satenii", false)

ui.current_list = menu.add_selection(ui.group_name, "List", (function()
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