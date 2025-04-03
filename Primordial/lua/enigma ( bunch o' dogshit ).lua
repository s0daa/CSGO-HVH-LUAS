local refs = {
    isDT = menu.find("aimbot", "general", "exploits", "doubletap", "enable"), -- get doubletap
    isHS = menu.find("aimbot", "general", "exploits", "hideshots", "enable"), -- get hideshots
    isAP = menu.find("aimbot", "general", "misc", "autopeek", "enable"), -- get autopeek
    isSW = menu.find("misc","main","movement","slow walk", "enable"), -- get Slow Walk
    isFD = menu.find("antiaim", "main", "general", "fake duck"),
    isLean = menu.find("anitaim", "main", "angles", "bodylean"), -- get body lean
    isExtending = menu.find("antiaim", "main", "extended angles", "enable"), -- get extended angles
    axNoob = menu.find("aimbot", "general", "exploits", "force prediction"),
   
    min_damage_a = menu.find("aimbot", "auto", "target overrides", "force min. damage"),
    min_damage_s = menu.find("aimbot", "scout", "target overrides", "force min. damage"),
    min_damage_d = menu.find("aimbot", "deagle", "target overrides", "force min. damage"),
    min_damage_r = menu.find("aimbot", "revolver", "target overrides", "force min. damage"),
    min_damage_p = menu.find("aimbot", "pistols", "target overrides", "force min. damage"),
    min_damage_awp = menu.find("aimbot", "awp", "target overrides", "force min. damage"),
    safepoint_a = menu.find("aimbot", "auto", "target overrides", "force safepoint"),
    safepoint_s = menu.find("aimbot", "scout", "target overrides", "force safepoint"),
    safepoint_r = menu.find("aimbot", "revolver", "target overrides", "force safepoint"),
    safepoint_d = menu.find('aimbot', 'deagle', 'target overrides', 'force safepoint'),
    safepoint_p = menu.find("aimbot", "pistols", "target overrides", "force safepoint"),
    safepoint_awp = menu.find("aimbot", "awp", "target overrides", "force safepoint"),
   
    pingSpike = menu.find('aimbot', 'general', 'fake ping', 'enable'),

     mRandom_midget_mode    = menu.find("visuals", "other", "thirdperson", "midget mode"),
     mRandom_paper_mode = menu.find("visuals", "other", "thirdperson", "paper mode"),
   }

   -- killsays ignore --
local kill_say = {}
local ui = {}
kill_say.phrases = {}

table.insert(kill_say.phrases, {
    name = "normal",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
})
table.insert(kill_say.phrases, {
    name = "multi-color text",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "	You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "	The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "	ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "	allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "	I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "	Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "	Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
       
    }
})
table.insert(kill_say.phrases, {
    name = "red text",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
}
)
table.insert(kill_say.phrases,{
    name = "blue text",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
}
)
table.insert(kill_say.phrases, {
    name = "green text",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
})
table.insert(kill_say.phrases, {
    name = "purple text",
    phrases = {
        "when me money, you poor. When me happy, you sad. When allah good? Always.",
        "Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "Allah live, allah die. all you do is die. Choose allah",
        "Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "You are work cotton i am work KFG on Selly.GG",
        "You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "Keybored click? not just my hitting sound",
        "My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "EZ 4 me thank you for HVH medier",
        "Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "dog 3rd worlders sent back to slum by first world god by this HS",
        "you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "Thanks allah for him making Me HS you, JOKE i always kill....",
        "I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "Choppa in my hand but allah is in the sand",
        "You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "Allah live allah die, all you do is die. Choose allah",
        "A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "Head shoot top screen that you spectaor me you fan?",
        "allah wins you house in raffel but you win hs in raffe",
        "You luckyer that when i hs i would nife you in backstab",
        "You luck when you spin weel is 100 persent HS from me,",
        "𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "I wipe floor after i kill you because i respect you family",
        "Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "Start to respect you elders but you cant respect me if you are dead bot",
        "Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "When you are on ground having boring i an in my golden jet with my bands",
        "【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
})
table.insert(kill_say.phrases, {
    name = "gold text",
    phrases = {
        "	when me money, you poor. When me happy, you sad. When allah good? Always.",
        "	Allah and you is similar. You both is dead all time, you both has fake idea of win, and you family all dead. but one is different, Allah can kill but you can dream of it",
        "	ramadam has begin, but you bot. you begin die because i start the spinbot to give hells",
        "	Allah live, allah die. all you do is die. Choose allah",
        "	Grass hill is where you go back to after this lose, I own that hill you can call hom so dont be going back after you are crying to you dog",
        "	You are work cotton i am work KFG on Selly.GG",
        "	You think you scared at night becoose monter under bed? will i has someting to telling you. you is the monster under hinding in palase and i hs you",
        "	In desperate time, in desperate need, allah is here , and this bulet to... HS!!",
        "	Keybored click? not just my hitting sound",
        "	My rezolver chase you like you chase bag, Only differents because my rezolver get you HS but you dont get the bag.",
        "	EZ 4 me thank you for HVH medier",
        "	Let you parents know you dye after this loze, prediction wont save you now worth less bot,",
        "	dog 3rd worlders sent back to slum by first world god by this HS",
        "	you have configuation issue? no, you has money issue becaues you work all day with not return while i play and making million working you family out in the field",
        "	The browser has you password save. I get you pasword to use on account and make all you little money to my account?",
        "	Typikal bottys need to eat food when you play. but cant help me because i play evryday i have slave to eat for me and that slave you bot.",
        "	Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "	You family is poor, You rezolver is poor. Unlike my rezolver that HS you all brother eat all brother die HS",
        "	Counter terrorst win ? true here beavuse you country is terrorist but my counrty is rich and you live slums",
        "	Bullot come, bullet go, i stay owning. Hs Here Hs There you are not here.",
        "	Thanks allah for him making Me HS you, JOKE i always kill....",
        "	I Own develepor this game and you only beg from forgive from me because i have give all hs for free",
        "	Africa richest country in world while all russian and EU dogs sent back to slovakia on train to germany while beg for forgiverness from they family.",
        "	ℙ𝕠𝕚𝕟𝕥𝕚𝕟𝕘 𝕥𝕙𝕖 𝕓𝕝𝕚𝕔𝕜𝕪, 𝕚𝕥'𝕝𝕝 𝕘𝕖𝕥 𝕤𝕥𝕚𝕔𝕜𝕪",
        "	Nevrlose more likes Nevr win. You is beg but only you recive when you pay. Just like my rezolver you will win when you has it but you cant get you are public user",
        "	Choppa in my hand but allah is in the sand",
        "	You was ukraine, you family bomb (rose), you gun muss. I was behind wall head where",
        "	Midle east need to learn bomb defusual tacktiks for counter terrosits and all countryes bow down to me lebanon king",
        "	Ramadam month over, Just like you. Now i food, you not. I am over you, You below!",
        "	Allah live allah die, all you do is die. Choose allah",
        "	A get bombd, A aparetment no more. A complain. A poor. Lebanon dog stay mad",
        "	Head shoot top screen that you spectaor me you fan?",
        "	allah wins you house in raffel but you win hs in raffe",
        "	You luckyer that when i hs i would nife you in backstab",
        "	You luck when you spin weel is 100 persent HS from me,",
        "	𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕖_𝕞𝕚𝕣𝕒𝕘𝕖 𝕓𝕦𝕥 𝕟𝕠𝕨 𝕚 𝕕𝕖_𝕤𝕥𝕣𝕠𝕪",
        "	you lucky get kill by me, it me who kill becose i shoot. sometimes miss sometimes hit its resolver",
        "	Nifed you like i peeky blinders, you die like mohammed back in the days when you younger bot",
        "	In mirage people shoot, in mirage peolp die. In mirage resolver break in mirage people hate",
        "	Blood pores from top of DE_MIRAGE but police wonrder who blood is? it you blood i explode you with shootgun",
        "	When i walk up ladder you look with rifel. I shoot befor and sniper you. You are now on ground with family (DOG)",
        "	I wipe floor after i kill you because i respect you family",
        "	Family always first (Call me vin diesiel) the way i make these hoes weasel",
        "	Hitman like me dont go by real name, Only big name by UNMATCHED.GG",
        "	USELESS BOT owned hard with the REZOLVER.... you need tell family you love before i killed you",
        "	Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        "	Start to respect you elders but you cant respect me if you are dead bot",
        "	Botty get shot with the shotty now im sitting on the potty because i have severe diabeates",
        "	You life go like you mother own you him mother own him then i own him as my slave because i buyed it all then kill alll",
        "	Likehack bitch says the russian, Where  life hack? you are not dead (are dead)",
        "	Just because i were black and keep private life journal, that doesnt mean i will blow up house or terrorires mindless peopl, for that matter",
        "	I am sad to the touch butt my mind is fureyous like a tyger. you dont mess with the bo$$ of the world",
        "	When you are on ground having boring i an in my golden jet with my bands",
        "	【ｗｅａｋ　ｂｏｔ　ｙｏｕ　ａｒｅ　ｂｏｔ　ｙｏｕ　ｇｅｔ　ｈｓ　ｂｙ　ｍｙ　ｓｉｇｍａ．ｌｕａ　ｒｅｓｏｌｖｅｒ】",
        "	you are doomed like this boolet coming in high speed to you brain, INSANE IN THE BRAIN. I am chill.",
        "	Glasses enhanse my gameplay and zoom in when i H$ you in HD and get easy win for my family",
        "	She can paint a pretrty pikture but story has a twist. Da paintbursh is razer and canvas is a wrist",
        "	Other pepol are shooting aer. But me HS you. now all family disrespect but it fine because the world what it is!",
        
    }
})

--tags ignore
getzeus = {
    "                  ",
    "                 g",
    "                ge",
    "               get",
    "              getz",
    "             getze",
    "            getze.",
    "           getze.u",
    "          getze.us",
    "         getze.us ",
    "        getze.us  ",
    "       getze.us   ",
    "      getze.us    ",
    "     getze.us     ",
    "    getze.us      ",
    "   getze.us       ",
    "  getze.us        ",
    " getze.us         ",
    "getze.us          ",
    "etze.us           ",
    "tze.us            ",
    "ze.us             ",
    "e.us              ",
    ".us               ",
    "us                ",
    "s                 ",
}
pandoraanim = {
    "_______",
    "p_____a",
    "pa___ra",
    "pan_ora",
    "pandora",
    "_andor_",
    "__ndo__",
    "___d___",
    "_______"
}
onetapanim = {
    "o",
    "on",
    "one",
    "onet",
    "oneta",
    "onetap",
    "onetap.",
    "onetap.s",
    "onetap.su",
    "onetap.su ",
    "netap.su",
    "etap.su",
    "tap.su",
    "ap.su",
    "p.su",
    ".su",
    "su",
    "u",
    ""
}
gamesenseanim = {
    "                  ",
    "                 g",
    "                ga",
    "               gam",
    "              game",
    "             games",
    "            gamese",
    "           gamesen",
    "          gamesens",
    "         gamesense",
    "        gamesense ",
    "       gamesense  ",
    "      gamesense   ",
    "     gamesense    ",
    "    gamesense     ",
    "   gamesense      ",
    "  gamesense       ",
    " gamesense        ",
    "gamesense         ",
    "amesense          ",
    "mesense           ",
    "esense            ",
    "sense             ",
    "ense              ",
    "nse               ",
    "se                ",
    "e                 "
}

skeetccanim = {
    "                  ",
    "                 s",
    "                sk",
    "               ske",
    "              skee",
    "             skeet",
    "            skeet.",
    "           skeet.c",
    "          skeet.cc",
    "         skeet.cc ",
    "        skeet.cc  ",
    "       skeet.cc   ",
    "      skeet.cc    ",
    "     skeet.cc     ",
    "    skeet.cc      ",
    "   skeet.cc       ",
    "  skeet.cc        ",
    " skeet.cc         ",
    "skeet.cc          ",
    "keet.cc           ",
    "eet.cc            ",
    "et.cc             ",
    "t.cc              ",
    ".cc               ",
    "cc                ",
    "c                 "
}

fatalanim = {
    "            ",
    "           f",
    "          fa",
    "         fat",
    "        fata",
    "       fatal",
    "      fatali",
    "     fatalit",
    "    fatality",
    "   fatality.",
    "  fatality.w",
    " fatality.wi",
    "fatality.win",
    "atality.win ",
    "tality.win  ",
    "ality.win   ",
    "lity.win    ",
    "ity.win     ",
    "ty.win      ",
    "y.win       ",
    ".win        ",
    "win         ",
    "in          ",
    "n           "
}



aimware = {
    " ",
    "A ",
    "AI ",
    "AIM ",
    "AIMW ",
    "AIMWA ",
    "AIMWAR ",
    "AIMWARE ",
    "AIMWARE. ",
    "AIMWARE.N ",
    "AIMWARE.NE ",
    "AIMWARE.NET ",
    "IMWARE.NET ",
    "MWARE.NET ",
    "WARE.NET ",
    "ARE.NET ",
    "RE.NET ",
    "E.NET ",
    ".NET ",
    "NET ",
    "ET ",
    "T "
}

mutiny = {
    "         ",
    "        m",
    "       mu",
    "      mut",
    "     muti",
    "    mutin",
    "   mutiny",
    "  mutiny.",
    " mutiny.p",
    "mutiny.pw",
    "utiny.pw ",
    "tiny.pw  ",
    "iny.pw   ",
    "ny.pw    ",
    "y.pw     ",
    ".pw      ",
    "pw       ",
    "w        ",
}

rektanim = { 
    "t            ",
    "kt           ",
    "ekt          ",
    "rekt         ",
    ".rekt        ",
    "t.rekt       ",
    "et.rekt      ",
    "get.rekt     ",
    " get.rekt    ",
    "  get.rekt   ",
    "   get.rekt  ",
    "    get.rekt ",
    "     get.rekt",
    "      get.rek",
    "       get.re",
    "        get.r",
    "         get.",
    "          get",
    "           ge",
    "            g",
    "             "
}
iniuriascroll = {
    "          ",
    "         I",
    "        IN",
    "       INI",
    "      INIU",
    "     INIUR",
    "    INIURI",
    "   INIURIA",
    "  INIURIA.",
    " INIURIA.U",
    "INIURIA.US",
    "NIURIA.US ",
    "IURIA.US  ",
    "URIA.US   ",
    "RIA.US    ",
    "IA.US     ",
    "A.US      ",
    ".US       ",
    "US        ",
    "S         "

}
iniuriaglide = {
    "..........",
    ".........I",
    "........IN",
    ".......INI",
    "......INIU",
    ".....INIUR",
    "....INIURI",
    "...INIURIA",
    "..INIURIA.",
    ".INIURIA.U",
    "INIURIA.US",
    "NIURIA.US.",
    "IURIA.US..",
    "URIA.US...",
    "RIA.US....",
    "IA.US.....",
    "A.US......",
    ".US.......",
    "US........",
    "S........."
}

brightside = {
    "brightside",
    "br1gh7s1d3"
}

hyperion = {
    "/Hyperion.vip\\",
    "-Hyperion.vip-",
    "\\Hyperion.vip/",
    "|Hyperion.vip|"
}

codanim = {
    "...o",
    "..o.",
    ".o..",
    "o...",
    "o...",
    ".o..",
    "..o.",
    "...o"
}
personaTag = {
    "    persona    ",
    "    persona    ",
    "    persona    ",
    "    persona    ",
    "    persona    ",
    "    person    ",
    "    perso    ",
    "    pers    ",
    "    per    ",
    "    pe    ",
    "    p    ",
    "        ",
    "        ",
    "    p    ",
    "    pe    ",
    "    per    ",
    "    pers    ",
    "    perso    ",
    "    person    ",
    "    persona    ",
    "    persona    ",
    "    persona    ",
    "    persona    "
}

ouijaTag = {
	'',
	'o',
	'ou',
	'oui',
	'ouij',
	'ouija',
	'ouija.',
	'ouija.666',
	'ouija.   ',
	'ouija.666',
	'ouija.   ',
	'ouija.666',
	'ouija.   ',
	'ouija',
	'ouij',
	'oui',
	'ou',
	'o'
}

ftb = {
	'>',
	'.>',
	'..>',
	'...>',
	'....>',
	'.....>',
	'......>',
	'.......>',
	'........>',
	'.........>',
	'..........>',
	'...........>',
	'f..........',
	'fb.........',
	'fbe........',
	'fbe$.......',
	'fbe$a......',
	'fbe$ag.....',
	'fbe$agy....',
	'fbe$agya...',
	'fbe$agyak..',
	'fbe$agyako.',
	'fbe$agyakot',
	'fbe$agyakot|',
	'fbe$agyakot',
	'fbe$a|gyakot',
	'fbe$gyakot',
	'f|be$agyakot',
	'fabe$agyakot',
	'fa|be$agyakot',
	'fabe$agyakot',
	'fabe$agyak|ot',
	'fabe$agyaot',
	'fak|be$agyaot',
	'fakbe$agyaot',
	'fakbe|$agyaot',
	'fakbe$agyaot',
	'fakb$agyaot',
	'fake|b$agyaot',
	'fakeb$agyaot',
	'fake|b$agyaot',
	'fakeb$agyaot|',
	'fakeb$agyao',
	'fakeb$agyao|',
	'faket|b$agyao',
	'faketb$agyao',
	'faket|b$agyao',
	'faketb$a|gyao',
	'faketb$agyao',
	'faketb$a|gyao',
	'faketb$gyao',
	'faketa|b$gyo',
	'faketab$gyo',
	'faketab$g|yo',
	'faketag|b$yo',
	'faketagb$yo',
	'faketagb$yo|',
	'faketagb$y',
	'faketagb|$y',
	'faketagbo|$y',
	'faketagbo$y',
	'faketagbo$y|',
	'faketagbo$y',
	'faketagbo$',
	'faketagboy|$',
	'faketagboy$',
	'faketagboy$',
	'faketagboy$<',
	'faketagboy<',
	'faketagbo<',
	'faketagb<',
	'faketag<',
	'faketa<',
	'faket<',
	'fake<',
	'fak<',
	'fa<',
	'f<',
	'<',
	''
}

hotwheelVIP = {
    "",
    "h",
    "ho",
    "hot",
    "hotw",
    "hotwh",
    "hotwhe",
    "hotwhee",
    "hotwheel",
    "hotwheels",
    "hotwheels.",
    "hotwheels.v",
    "hotwheels.vi",
    "hotwheels.vip",
    "otwheels.vip",
    "twheels.vip",
    "wheels.vip",
    "heels.vip",
    "eels.vip",
    "els.vip",
    "ls.vip",
    "s.vip",
    ".vip",
    "vip",
    "ip",
    "p"
}
million = {
    "",
    "m",
    "mi",
    "mil",
    "mill",
    "milli",
    "millio",
    "million",
    "millionw",
    "millionwa",
    "millionwar",
    "millionware",
    "millionwar",
    "millionwa",
    "millionw",
    "million",
    "millio",
    "milli",
    "mill",
    "mil",
    "mi",
    "m"
}

nvlanim = {
    "  ",
    " | ",
    " |\\ ",
    " |\\| ",
    " N ",
    " N3 ",
    " Ne ",
    " Ne\\ ",
    " Ne\\/ ",
    " Nev ",
    " Nev3 ",
    " Neve ",
    " Neve| ",
    " Neve|2 ",
    " Never|_ ",
    " Neverl ",
    " Neverl0 ",
    " Neverlo ",
    " Neverlo5 ",
    " Neverlos ",
    " Neverlos3 ",
    " Neverlose ",
    " Neverlose. ",
    " Neverlose.< ",
    " Neverlose.c< ",
    " Neverlose.cc ",
    " Neverlose.cc ",
    " Neverlose.c< ",
    " Neverlose.< ",
    " Neverlose. ",
    " Neverlose ",
    " Neverlos3 ",
    " Neverlos ",
    " Neverlo5 ",
    " Neverlo ",
    " Neverl0 ",
    " Neverl ",
    " Never|_ ",
    " Neve|2 ",
    " Neve| ",
    " Neve ",
    " Nev3 ",
    " Nev ",
    " Ne\\/ ",
    " Ne\\ ",
    " Ne ",
    " N3 ",
    " N ",
    " |\\| ",
    " |\\ ",
    " | ",
    "  ",
    " "
}
clarity = {
    "☣",
    "☣c",
    "☣cl",
    "☣cla",
    "☣clar",
    "☣clari",
    "☣clarit",
    "☣clarity",
    "☣clarity.",
    "☣clarity.t",
    "☣clarity.tk",
    "☣larity.tk",
    "☣arity.tk",
    "☣rity.tk",
    "☣ity.tk",
    "☣ty.tk",
    "☣y.tk",
    "☣.tk",
    "☣tk",
    "☣k",
    "☣",
}
lctag = {
    "  LuckyCh4rm$  ",
    " LuckyCh4rm$   ",
    "LuckyCh4rm$    ",
    "uckyCh4rm$     ",
    "ckyCh4rm$     L",
    "kyCh4rm$     Lu",
    "yCh4rm$     Luc",
    "Ch4rm$     Luck",
    "h4rm$     Lucky",
    "4rm$     LuckyC",
    "rm$     LuckyCh",
    "m$     LuckyCh4",
    "$     LuckyCh4r",
    "     LuckyCh4rm",
    "    LuckyCh4rm$",
    "   LuckyCh4rm$ ",

}
ibuanim = {
    '   ',
    ' i ',
    ' ib ',
    ' ibu ',
    ' ibup ',
    ' ibupr ',
    ' ibupro ',
    ' ibuprof ',
    ' ibuprofe ',
    ' ibuprofen ',
    ' ibuprofe ',
    ' ibuprof ',
    ' ibupro ',
    ' ibupr ',
    ' ibup ',
    ' ibu ',
    ' ib ',
    ' i ',
    ' in ',
    ' iben',
    ' ibufen',
    ' ibupofen ',
    ' ibuprofen ',
    ' ibuprofe ',
    ' ibuprof ',
    ' ibupro ',
    ' ibupr ',
    ' ibup ',
    ' ibu ',
    ' ib ',
    ' i ',
}

japPrim = {
    "⌛ ",
    "⌛ 原",
    "⌛ 原始",
    "⌛ 原始的",
    "⌛ 原始的.",
    "⌛ 原始的.d",
    "⌛ 原始的.de",
    "⌛ 原始的.dev",
    "⌛ 始的.dev",
    "⌛ 的.dev",
    "⌛ .dev",
    "⌛ dev",
    "⌛ ev",
    "⌛ v",
}

estonianprim = {
    "⌛ ",
    "⌛ ü",
    "⌛ ür",
    "⌛ ürg",
    "⌛ ürgn",
    "⌛ ürgne",
    "⌛ ürgne.",
    "⌛ ürgne.d",
    "⌛ ürgne.de",
    "⌛ ürgne.dev",
    "⌛ rgne.dev",
    "⌛ gne.dev",
    "⌛ ne.dev",
    "⌛ e.dev",
    "⌛ .dev",
    "⌛ dev",
    "⌛ ev",
    "⌛ v",
}
--end ignoring of tags
-- b64 decode
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local decode_base64 = function( data ) -- http://lua-users.org/wiki/BaseSixtyFour
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end


-- main groups
local welcomeGroup = "enigma"
local creditGroup = 'welcome'
local clantagGroup = 'clantags'
local visualGroup = 'visuals'
local miscGroup = 'miscellaneous'
local logs = {}
local fonts = nil

local menu = {
    masterSwitch = menu.add_checkbox(welcomeGroup, 'master switch'),
    masterSelect = menu.add_multi_selection(welcomeGroup, 'features', {'clantags', 'visuals', 'misc'}),
   
    clantagsSelect = menu.add_selection(clantagGroup, 'tag types', {'disabled','cheat tags', 'lua tags', 'steam groups','custom tag'}),
    cheatSelect = menu.add_list(clantagGroup, " ", {"getze.us", "pandora classic", "pandora live", "onetap classic", "onetap live", "gamesense", "skeet.cc", "fatality.win", "aimware", "mutiny.pw","get.rekt", "neverlose", "iniuria scroll", "iniuria glide", "iniuria static", "hyperion.vip", ".o..", "hotwheels.vip", "millionware", "clarity.tk", "og luckycharms", 'estonian primordial', 'japanese primordial'}),
    cheatDelay = menu.add_slider(clantagGroup, 'speed', 1, 100),
    luatagSelect = menu.add_list(clantagGroup, '', {"brightside", "persona", "ouija", "faketagboy$"}),
    luaDelay = menu.add_slider(clantagGroup, 'speed', 1, 100),
    steamSelect = menu.add_list(clantagGroup, '', {"crimwalkers","unfortunate","dmt", "h0tgirlz", "bodyaimers", "auf nusse $", "stainless", "rich", "juul industries", "fsx", "simswap", "kidua", "ow bypass", "evolve", "monolith", "bhopconfig", "output", "cybercrime", "heart emoji", "skateman$", "180 grad", "180treehouse", "thighs", "souljahook", "$teppa", "Invalid Text", "in denial", "learncpp.com", "xtc", 'sbdsm', 'ibuprofen'}),
    customInput = menu.add_text_input(clantagGroup, 'input'),
    customAnimate = menu.add_checkbox(clantagGroup, 'animate'),
   
    indicatorOpt = menu.add_multi_selection(visualGroup, 'indicators', {'logo','dt', 'hideshots', 'auto peek', 'ax', 'fd', 'min dmg', 'safepoint', 'ping spike'}),
    scopeAnim = menu.add_checkbox(visualGroup, 'scope animation'),
    pulseLogo = menu.add_checkbox(visualGroup, 'pulsate logo'),
    worldMisses = menu.add_checkbox(visualGroup, 'world miss indicator'),
    specSwitch = menu.add_checkbox(visualGroup, 'spectator list'),
    renderWatermark = menu.add_checkbox(visualGroup, 'watermark'),
    cheat_name = menu.add_text_input(visualGroup, "cheat name"),
    color_override = menu.add_checkbox( visualGroup, "override color", false ),
   
    anim_selection = menu.add_multi_selection(miscGroup, "character things", {"reversed legs", "static when slow walk", "static legs in air", "lean while running", "mega midget", "paper midget", 'zero pitch on land'}),
    mass_slider = menu.add_slider(miscGroup, "mass slider", 0, 200, 1, 1, "kg"),
    find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc", "main", "movement", "slow walk")),
    debugSwitch = menu.add_checkbox(miscGroup, 'debug panel'),
    debugOpt = menu.add_multi_selection(miscGroup, 'debug options', {'fps', 'latency'}),
    enableSay = menu.add_checkbox(miscGroup, 'enable kill say'),
    current_list = menu.add_selection(miscGroup, "phrase options", (function()
        local tbl = {}
        for k, v in pairs(kill_say.phrases) do
            table.insert(tbl, ("%s"):format(v.name))
        end
    
        return tbl
    end)()),
   
   
    welc1 = menu.add_text(creditGroup, 'glad to see you again, '.. user.name .. ' ' .. user.uid),
    welc2 = menu.add_text(creditGroup, 'enigma [debug]'),
    welc3 = menu.add_text(creditGroup, 'built 9 27 2022 8:28 pm'),
    welc4 = menu.add_text(creditGroup, ''),
    welc5 = menu.add_text(creditGroup, 'be sure to leave a review   ♥'),
}
local logoColor = menu.indicatorOpt:add_color_picker('logo color')
local indColor = menu.indicatorOpt:add_color_picker('indicator color')
local color_picker = menu.color_override:add_color_picker( "8F87DE" )
color_picker:set( color_t( 143, 135, 222, 255 ) )


local vars = { }
vars.cheat_name = ''
vars.border_padding = vec2_t( 11, 8 )
vars.text_padding = vars.border_padding + vec2_t( 8, 6 )
vars.bold_font = render.create_font( "Verdana", 12, 500, e_font_flags.ANTIALIAS )
vars.default_font = render.create_font( "Verdana", 12, 500, e_font_flags.ANTIALIAS )

vars.accent_color = color_t( 143, 135, 222, 255 )
vars.default_color = color_t( 80, 80, 80, 255 )

-- loading image from base64
vars.logo_image = render.load_image_buffer( decode_base64( 'iVBORw0KGgoAAAANSUhEUgAAAVwAAAHSCAYAAACgrHOEAAAgAElEQVR4nO2d+XMc6XGms9G4TxIgeA+vGc6tGUmj0UiybMmWZTtsx8buhr3nH7cR+4M3YtdrS7u2vNZY0uiak8NzSA5vErxAECRBEvfVGx/1tFTG4OiuruP7qt4nooPgBVRXd72dlflmZqVWq1lAtJvZQTM7ZGbb+X3bJocf1JMTogUqZrZiZvNmtszvjetj2sxum9kMf7fCtbHK1+7PlnjomkmR9sCO170ZtpnZn5jZX3D8lQb+nxBloBYR0/p14UT1iZndNbP7ZvbYzGYR1wV+P2VmD/n7af7skd4xyROa4Dr6zOx5M3vNg2MRIhRWEN7ZSBS8RNQ7w9/VxfghEfGDyOMx/88J8lO96vEITXCrZjZoZl1rPsWFEFtfO9t5bMUcouui4ptmdsvMJhBbJ74X+Lu6eCsd0SChCa473l1mNurBsQhRVHrMbJ+Z7TGzVxHVBaJkJ8bXEd2rZjaGOE/w+zm9KzYmNMGt8CbYo+hWiNRxBbdeHlGOmtmXzWycvK9LMdwxszNmdsXM7hEJz/GY1Uv1G0ITXJdOeM7MdnhwLEKUmdE1d5rTRLuXzewaAjxJSuICAjxT9ndMSIJbQWyf45ZHCOEP/aQfDhPVLhD9niPy/dzMziPIS2V93UIS3HYi2+1KJwjhLT2RgGgPueA3KbJdNLNPzewSLohJLGmlISTB7cGD2+3BsQghGmOExytm9g0z+z0z+wzR/Zyvr5GSKDwhCe4An5b9HhyLEKJ5XPHtdTM7QqHNie5HPM6SAy50njckwXVCu3OdiqkQIhwqNC/1EfkeMLN3cDe8Z2af0OV2n+aMQhFahHtAEa4QhaGD2Sju8U0ze4EOUufzPU6R7UmRGipCElxnQXlJgitEIWkn0n0NS9mvzewXpBquIrzBE4rg9mAH27vFdDAhRLh0RNqPh83sDaLcX+FuuIWfN1hCEVyXTthN3kcIUXzqHaVOdF8m8v3QzI7RTBFkfjcUwR3kUfXgWIQQ2eGK5G/TUPECd7q/NLNTZrYY2usQguC2cYsxpIYHIUpJO3e438FS5qLdfzKzk1jJghHeUAS3bp5W/laI8jLEw9Vy9hPpfkC0OxnCWQlFcEfx4EpwhRCuoPaHpBhcI8WPzOxfaB/22kIWSg53J3NwJbhCCMPRcIR04y5+/QUpBm+dDL4LboXo9oiGjgsh1sEJ7bdwMLkGivdxM9z2Mdr1XXCrVCeP4lIQQoi1dJrZWzgYDiPCP2cU5KpPZ8t3wW0jST4oh4IQYhPacDJ8lwK7+/ofKait+HLifBfcbsS204NjEUL4zzZahIep/fyQgTiPfThy3wV3AAuI5icIIRqlk+0Tu6n99OBiWMg7xeC74PbR3qeWXiFEM1RILXyb4tkwc3ev5Lnix3fB7SXCVcFMCBEHF+H+EYHbAEKc26BznwW3bgk7rAhXCBGTTnK5g7QAd0bGPs5lfVJ9Ftw+/LfPyaEghGiRbnaq1QvwK9jGnmZ5Yn0W3F4iXKUThBBJ4FIKX0FsK4x4/DzLnK7vEW6/RjIKIRJkkHU+NYR2mUg3E9H1VXDr+dtRCa4QImF68OpW0Zp2RDf1nK6vglvFQ7dbgiuESAF39/w1It1FHrdxL6Q2g8HnlMKIRjIKIVKkLrqPyev+mh1qpRPcamSZnARXCJEWA8xfcFo4ZWbXzGw2rR/mo+C20ezgLGE7PDgeIUSx2YZlbNzMrpvZibSKaD4KbgfjGF9kUpgQQqSNC+7+2MweIrZn0tgM7KPgduNO2O7BsQghysMBM/v3DLmZN7MLSQ+78VVwt2HdEEKIrGhjT9r3cSy4YtqdJH+2jwWpbsJ7Ca4QIg9cSvNPyevuSFInfYxwe7CDaWCNECIPhtmT9oDUwsdJrWH3tWg2qqHjQoicqLAJ2BXRnpBWSERwfUspdNJdtkcpBSFEzhwys+8Q7SayNdw3wXWphNfx4arhQQiRN18ys39jZm8zwbAlfBM157vdTw5FCCHyxt11v8GEsVfRptjzuX3L4br8bRcPIYTwATfS8fcpok3THBELnyLcCiF7r9IJQgiPcJr0dUY67iUwjIVPwtZGwWyfRjIKITyiQhHfpRW+Z2YH46YVfBLcGlYMCa4QwkcOYhV7K24BzSfB7aCld0hLI4UQnnIEm9jhOIfni+C2sZ33kIbWCCE8ZhsFtG9jY20KXwS3nXD9oFp6hRAe47TqJQT3dTpiG74j90VwO7BeDHhwLEIIsRm9NER8k7vyhu21vghuN4ZiRbdCiBA4QpS7v5kivy+C24MlTIIrhAiBfsY4Hm5m7osvgtuLHWzQg2MRQohGGMYidrjRPK5PgvscFUAhhAiBfvK4f0DAuCU+CG474xj3MyhCCCFCoINc7ldZert9q3yuD4Lr0gjPx/G0CSFEznThVHiDoHFTx4IPgrtNBTMhRKBUGNv4TYpnS5s9DR8Et58oVxPChBAhMkJKYcuFkz6I3BDVPh/3qwkhRCM4DfsKaYUNHQs+CO5uDjL2jEkhhMiZURoh3thskljegrs9Yh7WSEYhRKj00O770mYbx/MW3N0I7h6NZBRCBI6Lcg+Q012XvAW3hyhX6QQhROh04st9fqM79jwFt8rQGjU7CCGKwlHyuKPrPZ88Bbebg5L/VghRFJwB4MtEul9wXuUpuH3kO7ThQQhRFHroPDu4nlshT8HtkeAKIQrINowAX3Ar5CW4FQ7qORofhBCiKPSTWvhCujQvwe0g7D6sHK4QomBso3g2vPZp5RnhbmdCmGYoCCGKRDfWsBfX7mnMS+w6SShv2AInhBABs5spYrujTyEvwd3GZB01PAghiogLJneRVvhtF21egruDg9H8BCFEEanS4jsS1bm8RiJuo+lBEW7xqTGUeZGvozMzanzod+vDVxSMNqxhO3mfPyNPwR3WRVYKJszsipndRHjrr3ldiOtGcVdEXdnkhKwi1kkMOapfAJXI72sxv38tekFFvkct8oESpRr5s9qa/9PGo8rfdXCdKDAJD/c67mW5ZEf9vZ2H4I5wge3R0PFScNrMfmhmZ81seY0ALbMTaifV3NU14hVlbXScNK18/7WCG/3ztd+zukboLSK4UdHtIvW2k40o9c0o9btD7QD0H6d1L2N/veTe71kLXgXVf5FfZQkrNk/N7ISZ/bOZXS77yWiSHuoc/XjVhyO1DxewvBYx1/fx73Q9+UU3Yutm5I7lJbj9RLeDvp8t0RIuZ3vBzC6a2aROZdPMmdn1SNTbwaOLa+gFWuN3E8C8wZ8NJHwcojX6+bB0r9tcHrf0K5HbJlFcpszsEzP7DPEQ8ahxzbjHPHcNk0RMg7TG78Xz+RXE98BGraUic9q5W3G/VrIW3A7eJF163QuPK5adIpWwUPaTkQKrfKi5xw3O9QcIrlv18jUze51c74YrX0Tq9JEGcr7cR1kL7iBJ5F16nQuNE4NbuBOelP1kZMSsmZ0nDXGSuwuXZviWmb1FxCuyZzttvu5O5F7WgtvDC6+RjMXmHqmESzgRRDbUEN7rvAbnyKGPIbyvUcgR2dGLW8FpX1vWglslgazEfrG5gjvh7iY2L5EucwjtFOJ7293SEvWOyAOfGXWLnyt+rmYtuPU5kXIoFJdlItsLOBVEvjzhw8/9epVI9/vketVQkT5VAkwX4XZkKbi9ESuLPl2LiYtm71Aou1f2k+ER86QW7iC6Tnz/DGeDCmrpM8rKnYksBXcAE/CGO9tF8MyTu3XFm8d6Ob1iiZTCycjXf25m7+iOM3WGaFa5n6Xg9tOWqLXoxeUhF7Qr1kyX/WR4ygpt1o+IdF2O8Rvy7KZKB9q3PUvBrc/A1fyE4nKfW9dxFcu8ZoVhQv+C0HbRNCHRTYc2As6hrAV3lxL1hWWB/OAFrEnCf5xX+sek+/polND1mTwValj9WQluhdytZuAWF9ftdAzBXSr7yQiEVRwlP8Wu2cPyQxW1k6WC/7knK8EdZcjGgGYoFJYztJY+KvuJCIxVXrv2yKAVjX5Mlgq1q+4sxK9CKuEwOdw0Z5qKfKhPtrqp8x8kM3h1f8b8YqWEkqUe4WYiuFVsJwcZyyjBLRYuQrpGJ5OG1ITLDA6T9yh8rpb9hCRIhVRqZxaC24EPbUi5oULirEXHuVgflv1kBI7Lw39EimGq7CcjYZ6NpM1CcOurQnozfXoiK55ygZ7XrWjwzOOh/gWvp+5YEiYrwd2rCWGFpEYL7wVFRIXhLoL7oZk9KPvJSJBny0GzEtx9VD9FsXBDxj8mwlU0VAxq5ONP8vqK1vntktC0BbcdO9hz6tcuJGN4b++os6xQLPLaXqOYJhIibcHtYdr5c1qrUzhWsIJd1ZDxwrFCauETGiPkWGidTIpm3RTMdmTxjESmTCC497lARXGor0j6kOlv6hxsnWoWOdweUgla61EslrnlvIDgKp1QPObY3HFN7pNEqGQR4fbQLqh23mIxjX3oDCu7RTGZontQ/urWqGSVUujCfyvBLRYPye9dUXRbaKbJ0d9UWqFlMnEp7GGtTk8GT0hkwzIFlTGaHkRxWSVPf4zUkYiPu26W0xTcKg6F1yS4heI+GwNkii8Hkwy2GS/7iWiBGncIi2kK7g4iXK1ELxZXGcN4RXawUrDIvIz5sp+IBKilOQ+3PnBcDoXisETV+rxuMUtDPUcvL24CpBXhtjM7YVRDawpDjdxtfd22KAcrpI+0hTk+NT6wVtMS3C6GjmtgTXGYJ3d7nIE1ohwsk0a6TXpBxCPVolknazo0P6E4zNF1dEkXXqmosTbpgRogYpN60aydopkEtxiskrO9LBN8KWljiM102U9ETGpM05tLM6Wwm9XoInwek064rulRpaRGdCvBjUeNlFwqgtvJdLCDinALgxtUc4pcntIJ5WSJhzoL47GYVkrBRbeHzGy/RjIWhnEG1dzVZDAhYuHScitpRbhDcigUhiV66W9QOBPlpBJ5iOZYTTOl0IvgKroNn2UaHT4lnaDbyfKyorub2ExzlziehuAO0mWWZhebyIY5xPYT8rgS3PJSF1y9B5rnMQ6fS2kJ7k5SCyJspnEnjOl1LD1VBVGxmaM781YagjtMwUwTwsJnmlUrj8p+IkrOKjNRekw53DjMY6tLPIcbtYR1ZPNcRErUFwne1qSo0tOvRqbYrOJdX01j48MoM3D3ZviERDo8Ip2gMYzCNTHtUyNTLObpzpxPY3hNP3YwTQgLHzeg5nO18gpSCcNyHsViliHuiQuu+159yt0WgvpqlYv0gIty06a51rGZZQ7JXNKC28GthxoewucBQ8YvSXBLTzuBlGoy8ahHuHNJd5p1kucZzfLZiMRZQmhPUTCT77LcdJFOUIQbjznqIYmmFKo0OxzgxRHhskDu9oLcCQKhleDG5xHdmk54a0kJbjtie1jWkeCZIp2gNTrCqMmMklYQzXMLt8+z1FxSgrvCdt7nJbhBU08nfELeSQh3Pb/IHaxojscELk/rqbmkBLdGUn1ELb1B84CdZXInCOOa3qdAKjaTPH6rs0kJbjce3Gq2z0ckjMs1neATWQh313oE95Gu7eaor6W6H52ylpTg1hseNNwiXOqjGC9q7q2AfsRW6YTmWWEk4700BHeQxLrSCWFSY27CeQaNa+6pMFp5d6pzNBa1SEphtf4NkhJc98LskXUkWJYQ29PcAgnRwaqsA7pzjcU8Ee5k1MuelOAO88KorTdM5vDeXlGjgwCXSnidgpnyt83jxPYcg/t/SxKCW7eDHVJKIVjGcSfcLfuJEM+okCJ8GZdCGnOzi8wSqbkv7AFM4kTuxqe3T8OJg2SBdMJxDRoX0MH82wOyg8XiCQXoJ2v/c6uCW6HXekidKMHiqqifkbtVOkEYd61HKZiJ5pkiPfd47f9sVXDdBbqoAdVBcxXv7XTZT4R4Rg8pwtc1+S82M6QTEhfcKg4FRbdhMkuf9ykJrgB3Pb9hZq9x5yqao4bQTq7nZ29VcJ0x+mtm9pJelOBYIbo9ra28IkIfBfCjsnnG4hEDa+bXS9G1Krgd3H7sz+75iIRYIbF/jaqqEIO08j6P1VNF8OapNxBNrPc/WxHcChHukPy3QfIUn+Dtsp8I8Vtckezr5G/V7NA8LqK9aWZnuGv8Qm2rFcHt5rbjgFr/gsSlE95jd5kQFfK3XzKzF+S9jUX9rvHyRtP2WjmpXXhv96gTJTieYgW7QOFMiB6E9nnlbmMzTRPRhpuuWxHcTlIKciiEh4tqj2kMo4AKhbI/MrPndFJiscJ1dXOzIKYVwe3Fp6d23vC4jOBOlf1EiGe4YtnbZvYHGsUYG+dO+BSb5YYWy1YEd0AjGYOkvgL9ohpWBOw1s7eoxyg9GI9HNBBd3ey6alVwdynfExSrCO259bpgRCnpRmzfxOYpmqdGIHN9qzRdK4KrGbjhMY/YXtbcBMHdqesq+x6/ygoWj2laeSe38rTHFdxBbkOG9SIFxRMi3JtlPxHiWTS7m8j2dQIoEY97zJO+u1UgE0dwK7xQR9SNEhT1nWUXNrOtiNLQjg3sba5nEZ+rzCO5l4bgVimWHWBmpgiD+1RRPye1IMpNLzNQviPBbYkVrqmzGzU7RIkruEPcgijJHg4P1lv5IUrJNgplv2dmh5UWjI0rQt+hjbchi2VcwR1Uw0NQ1FsOz2oFeump0E325wiuxDY+7lo6SUphsZHvEkdw20kpKMkeDvdodDjVyG2PKDTu7vTLZvYOaUHVYOLzkNVUZxvt2ozz6Vavbip/GwYrFMrOyHtberoR2z9hQaQG1LTGBKt0xrnOtqSVCFf7jsJgjkE1V8p+IkpOO84iNy/hW7pDbZnHdGxeaaYIHSfCrbGzZ5Lbk3rhrMrtSUW3KV4xwS3PjbKfiBJTwTf/ezwULLWOax76ANFtKH9rMQXXdVX8gIu4myi5gs3kEJ+cNf68yq9tkWh6lb+PinM00q6s8zC+VzXyb6L/vi3y9Qrffz8V2DKL/wxviHPrrWwWpaGKBeyPaHTQ/JPWucF19aiZ7xRHcN3osZ/ziOKE7RWmDa1GBLI9IsqGGK5GhLKy5u8t8vvooxo53mgUXVkzcGOFD4K/4AOgzIL7kIEaN9TKW2oOmtkfss1B08BaYxVP+2dxhvcnaQmpofgdkQjWNkgx1NaJUtdj7b9p5N/VGKrzpooCzzyCp9RZVmrcvJPvE4AcLPvJSABXE/nEzH7FssimSMOD58NCwvvaZPDsjXGW7rKyn4uy0kfO9t/hStDoxdaZJYi5HGe8aRFNz23Y1sq+U/8e+dub3AaJ8tCG2H6FyPbrytsmwhLX06W4FssiCm4nnTT7PDiWvFhmKtjlRv2BolC41VdfM7O/JMKVBSwZJmh0uEJBummKmONsx/ay3YNjyYsZUglnyvn0S88O1uX8GYVjkQxuZsJHRLgNW8GiFFFwK9xOlXV1+wq3PSd5g8idUC52MAHse9zpacBUMiwgtOfoQYh1XRUxpdBNhFvW26hpkvqXPClgiuwYZCjNf2VWgsQ2GeqrqU4QxMRO0xUtwq131Bwp8ayHB6QSxj04FpEdPWb2DTP7D/wqsU2Op3SVfYQDKjZFi3DbKZYdpnBQNlZJ6H+szrJS0UtE+x+Zk6DRqcmxTIPDMe4aW5q2VzTB7SKVsKOkHWZT5G6Py3tbGuqR7X/BAlbmYnEa3KfR4XyjIxg3o2iC28mnexk9hzWGjH9OdKtiWfEZMLNvEtn+GR2WIlncNfVLrqtYzoQoRcvhdpFKKGNLbw13wm21NJcCF9l+1cz+2sz+lNqFSI4ad4xncSY8SCKIKdqF2c8m4S4PjiVrpmh0uKXOssLTSWPDX5nZH5e8ySctFvGyf0QBOpE7xqKlFAa5rer24FiyZIEc0/uaDFZ42mnZ/c90kkls02Ga4nPLzoQoRRPc7VjCytb0MEuO6TxvFFFM+liR81f4bZ/T65wK01xLn5GmS2wPYJEEtxrx4JYtwh3HndDQqmYRJH0UyP4asd2vlzE1nA3sp2k0DxVJcHfivy2bLWaVT+Kfau5tYdnObIR/yyBxiW16LLH2/Bg1kUS3XBdJcIdLmr910e1p3hwt21aEV3Tzvn6HDrLvMHpUpMMqUe37dGs2tT6nEYoiuG28OXtL5lCoIbSXVSgrHM729SJphO/z656yn5SUeYrY/iytpatFEdwqJvC+knWYLWEDuy0rWKFw9sYXsHy5NMLrGqifCWN0lV1NK4ApkuBuR3TLxCTphGsS3MLgrI2vsWHXFcfeKqmvPGsm6Cj7NM05JEUR3I4SDh2vb3X4JM4yO+EV9QakEfK1Llf7Xfy22kOWPsvMH/kxdrDUaiFFEdx2CmZlGsn4ECvYTQ+ORcSng/ftMB7bv2QYzV6JbSasELh8gNimOvSpSC6FkZLt3Hf5pneT7IIRmVPfTvI8hbFvm9kbJZ7lnAczdJS5dMLdtH9+EQS3wkjG3SWagbvAUI2P1OwQNM5P+yqLHl332CtlPyEZs0JU+x5e9pbHL25FEQS3G/vMgZLcgtWtYCeyeIOIVKiw3PG7jFX8Ou9fkS03yNv+kgJ06hRBcHt5sw57cCxZUCGdkJp1RaRGD+/Xw4xU/B6FMa0xz5575G1/SR0kk2upKBHuYIl2OM2xRudGK8vsROb04a2tpxC+z+81uzh75ukk+7mZXcjyOiqC4PZgCi/LlofbWMEuyXsbDMMI7beIbN8sWYHXJ1aJaD/FCnYny+uoKCmF4ZII7hyfyJf4WvhNH4Wx38db+wpNDWWb9+ETD0kjvEstZDnLYyuC4PbjUCjDDNxJimX3PDgWsTGd1BXeYDPDH5KrVcdYviyyLudn3CVmvtm6CIK7nan3PR4cS9rc4lZovNhPM1jch/8oYvtdimIv8R4tS43BV1aJaD/gLjGXQf2hC+42TOP7SlB8mOaNclYr0L1kG1HsN4hqX8OuWMZ1/T7ylGDlvTwdPqEL7ih+xjLMULiLSVvRrR+0I6b9tOG+Q1HsHQpkch/4wzJDnn5KO/yDvI4sZMFtYzrYUAnSCfXByOextIh8GWE2rXvvvUyO9usMUBqQ2HqHSyX8I7nbXOsfoQtuf0lm4D6h3/uEvLe5Urcgvkbq4A2aGF7CCy78w9kof21mH/J1rs1CoQtudwkqvyvknE5oDGNuDFIIezEisG/hp9VEL3+ZJVB5l2ah3H3rRUgpFD3CfUJXzG0PjqUsVKkP9PN4iRU3b1Mz6OMhsfUXF6h8TpHsQ2ogEtwW6OJCOFxwwZ1mbbOmgqVPfa7yPgpfr7J2fxdCu0+ug2Bw80b+wcx+wp2hF6m40CNcd5v3nAfHkharvFnOprFBVDyLUHvJy27HYniUX58nV6vFjeHhZkT/s5n9MOtZCVsRsuB2UsQosqF8ChuL5t4mQyWSLhgmN7ufO6VXGSazJzKbQ51h4TFHzvZvScVl2rq7FaEKbgephN0Fv8W7Hmnl1aCa5qli4apPlNvJHdFR7o5GaFjYSdqgbEtIi8ZcpLnhHFutvSJUwe0ip7azwIIb9d6GLLbd3IlUiTZWSQfVeLTxGjbyOtb4d/Wmg1rk/7YTldZ/Xg+iupe0wTa+Pojo7lS7baGYJ33wLkFKLq27WxGq4PaQcyvy1KVJqqzXfPykbpA2rFSvEz3OMkCkA+Fd5T3Y3oTgVnndo80FHfzZEOmCnfw6SmTbzv9r59/KXVAsagQn70Zm3EpwE6SHHFxRBXeBN80Z9uWHSoVW1//E7fsSBYy1EW4zAlhZR6DrYtqNXau/RPORxW/mJDi/7Y+oeXi7eipUwR0giilqS+8c0e3VgKNbY/vs28yD1e27SIM5Ri2+i9g+9vksh9rzPRDJzRWR+1jBQo5uXZ79SzgAJLYiDZbZ2vA/zewXITh5QhbcfQUV3FnE9tdZbRJNiRHSCdpGK9KgRkT7twymuRvCWQ5RcNsphuwqaPHjNvmoi+RyQ6QNT+u3SCsIkSQ1ro+/I28bTNt7iII7gFm9qGvRXbX1VOA7ywZIJ7xBAUuIpKhF2nZ/yPUSDKEVzSoIbVELZgu08t70rUOmSfaRu9VmWpE0N5iP8OM8NzfEJbQIt4KBfaiA6YRVbo0u0lkW1BspwkCkTVbFMpEkj9i4+0Pyt4uhnd3QItw2jOwDBewwW6BYdhKXQqjsZbfXUTUYiASpi+0/MG4xyGskNMGt0mE2VEDBnaaN92bA0W0baYRXybNrlKFIgge4dv4W0Q02IAmxaDZC5btoF/Mt3Akhe2+7Edr9BW+7FtnxiNXmf8cSyCDsXxsRmuD24evcVTDBnaGN93jAYxgrpBO+SlFTiFZ5Svrg75kAFvzWk5AEt4LYvoLgFokbTDjKbX1zAvSz4+vbBXx9RPZMc038iG27Y0V4DUKLcLcTPRVtMImzt3wWcKODUcw8ijtBg7tFKyziRXduhH8JvK7xrwipaFbFZlQ0q9Ece/MvBS64O7kD0RBv0QorpNd+gCPhcpGG74cU4XbjwS1S9FQjL+Umg93x4Hhawe0Ae1nRrWiRC+Rs/8GX1eZJElKE289KnSINrHER7WkEN+QxjKN4b1+R91a0gGv6+R8I7sUirpUKSXAHaRktUm++8xP+ik/yUKkS2b7JB6IQzbLMZDzns/0bahqFJLQId0/BItyrGLrHPTiWuGxjnbjGMIo4rJKz/d94bQsrthaY4HbR9FAUwX1KQeB2wINqunAlvKXoVsRgkXb2vyOVUGixtYAEt40pYXsKZAm7zid7yGMY+2njfRPLnhCNMk/9wrkR/i/XQ+EJRXB7WIv+XEE6zFb5ZHddNE88OJ64DPG6HAp4P57IHtfU8CmR7f8rohthI0IS3JECeTwnIu6EkOfejiK28t6KRpli6aOLbP/JzK6V6cyFIriDzFEoAivkbi/6vmF0C7pJJ7yq6FY0yGMG0fw9HWSlSCNECeFCaaOLaWfASy+jzCK2N/05pKZxr8MRlkS+JMEVDeDmhLxPu+5PmL4NkGIAABc9SURBVB9SiHbdZgjhQqmSThguSP72AXNvQ+4scymeFxFbpRPEVtxjju0PWGd+q4xia4EIbo2UwlABItxlclZnA1+B3ovY7vXgWITf3Gbil3t8FPo821YJQXA7KM6MFEBw7zFy7nNsMaEyghVMgis2Y4wUwn8jjTZT9rPlu+C2YwU7guiGzjWsYCF/ym9nyPiXClTIFMlzGrH9AUFG6bEABLfKupYjtJCGzDwzb48HHt26D8BvFcgTLZJljo6xv2E2QshzQhInhJRCFwWzkMf+1bDAnCqAFeYwU8EU3Yq1PCSa/Uci21J5bBshhAi3qwAzVhfx3l7FhxsiFVqrX+GuQ2MYRZ1VIlmXLnuX/WMh2x5Tw3fB7cJ2FPqWhxkGK4e8BK/KkPFX8UQrnSAMX/kV9o79E11kIe/mSxXfBbeHleg9HhxLK4xjBbsV7lN4NqjmBR5DHhyPyJ9FBPZnzHX+NOCt05ngu+D2Ek2FPJLRjWE8R8HsqQfHE4d25t1+ScUyAY8Q2B/R1HAx8EFMmRBChLsn8C0PDxHc2wFPROrCKfJlCpiivCzRtPMLbF+nyNeGGkxkis+CW+Hi3h+44N5CcEN+Q/YzFezFgm3cEM0xT9POz1ny+AE2sFKMVkwCnwXX+W6Pcisb6nAUN/fzZOSNGSo7iXCVuy0vj2lm+Gcz+zE1idmyn5Rm8VnIBsgX7vDgWOIyzlaHsTAP/xkuun2dvWWhu0VEPG4z4csVxz7GcROqvTFXQmjtDXWlzgwm8EseHEsr7KGV99UCrTcSjbFCSuz/mNl/J6pdUAohPr4Lbi3QivgCqYT/xW1YyHSzIFLe23LxiIDhXZwIn0loW8dXwW0jstoT6ISwR4yi+yDwMYz1rbwHCjL8XWzNDO3nJ8nVvhd4SswrfBVcd1wv00Ya4m3sHYaMh26V2Wdmf0r+VhSbGo0Mx1js+CH1B3WNJYjPEe42RgGGFlnNsT7kBqmFUHHDad4ws68z/1YUlwXmfJxhDc77ciGkg6+Cu8ztbGgtvTWi2zO8gRc9OKa4bCey3RPm4YsGGaew+xFOhGtslZbYpoCvgltv6d3uwbE0wzItjp8S4YZaZKjQcHJUYxgLyzIOhJ+QRjhNkWy+rPvGssBHwW1nKtWRAC/2ZcYwXubrUBnBe/tyAQYHiS8yi5/25wyfOc8WkpCbc4LAR8F1RbKDWJFCmrm6yu3ZdeYnhIqLbnchuM9rBXqhWCRlcJJRih/wXn2kRoZs8PFi6qJg1u3BsTTDDLnby4Evy+sgnfBC4F1+4ncskyo4jdXrZ7xXH+kcZYuPgtvDLW1ot7KT7Cs7H3jBoYdUwiEPjkW0zgxC+wmTvc7IgZAfvgruzsDytzXSCRfJhYV6e9ZJGuFtrUAPniXGJp4lV/tTHDSzEtv88DWlMBqY4E4x0ONK4N5bNw3sa2b2ZoAOEfEb5hkEfpEusWOMVLyKCIscUQ63dVYiPsYLgb+p3QfdSxQsRXgskZ89QWrrY+64ZlUU8wPfBHeIW9q9AbX0rjJg/DgzQ0Olj7ztIQ0ZD44nfNhfjAhu6G6ZQuKb4I7S3bQ/IDvSDE0O4x4cSyvs4Ny/oDGMwTDLh/wnkY25U7gPJLYe4puouQt9kEcI1H2NdwPP3Vb5sHuF7jJ5b/3nBh2NJ3AenObPKhqj6C++XVjt+EBDueAfkSc7F3jlt8pksIPqLPOaGs6Dy4jt+zQxPOROS0LrOT4JW4V1LgMBDbq+H/HehjyKcVsklSP8Y579eJfpDvs1+dqbpBBEIPgkuG1s6R0JaCTjBMWJkItlVQqVX2WHnPCLcdIFx2lcOEsaa1YRbXj4FuHuYhxgCCmFCS6Ey4FbbvpYf/6i0gneMM+WhTFW23xMrvYOjgQRKD4JW43CTQhrdWqkET7kogg10qiSt32NDzuRL0+5WzqLyB7H430r8LsoAT4JbjsphRA6nBYjvseQxzC63O2XzewtPNAiPy5h6zoZ6Vq8zshEpQ4Kgi+C20b+cE8gt7WPKViEvCCywgecG8P4JXlvc+EBoupysr/CeXCNQtisBoEXD18Et4Nb210BOBRWSSPcCNyZUGFI0CFSOSIb6s0KE6QMPiFPe1ppg+Ljk+AOBTKwZgqj+bnACxi9kRXoIhseYuv6OLK08QYeWg2WKQG+CG4P0e2AB8eyFXe4aK4Enltz8yq+iSVMpIMT0dukCe4grh9SFHsoD2358E1w+z04ls1YYtTdx4Hf/nUQ3X5F6YTEmaFJ4TFCewz/7FU8tROKZsuLL4LbSUrB95GMt6kiXwu8oDGM4O704FiKQt07ew5v9i2cB6dpAZ/XiEThk+COBhDhXuZ2cNqDY2mF3bgTtoX7FLyg7se+gKiepUFhgt8/0iZcEcUHwW0nnbDf8zms89wW3vDgWFqhnYlgXw3gA843ZiiUPiX/OkZO9kTEKjhR9pMkNsYHwe2ncLPP87Xod7hFnAi8WLaTZodXNYaxIVbJud7CvvU5wjrG1/cjGxWUMhCb4sMF14sI+Hx7+5TCx0nM6qHSxofbS5qbsCkz5OvHENf7uFKcwN4jup0KfAayyAEfBLePgeM+dzo9QXAvkVoIle208b4Q8HNImjk+UKf5+glpo7PkZq9yV3M/8NdeeIAPgrudkYw+pxMecuGF7Jusj2F8p6SCW4s8FhHYu0Sx13mMU+iaILJ9zL/VLAORCHkLbgXB3eGx4E5yK3mXiy9U+iLphDIVy2ax8dW3ItT3fd3kjuUBv39EpDuvVIFIi7wFt0YOd8BjwR3DvH4z8MlgI7gTirQCfSmSCljgA3GJxzwieh1hneTfPuDP7waejxcBkrfgRkcy+ii4q1ywp8jrhdwhNIT1ztdcef2Wf5VHNAVgkaFGqwjnJCmA25FC1hP+biYSxd5HiFf4v3U3gSZxiczJW3CdO+ENMzvs6dDxpwjtzQIUTNr5wLiOQK2sETSLiFpU5NYKXlKsFbxFRPMhkWd9ROEyPzv6mCdCrW9AmImkAhZ5zMmmJXwjb8HdxrQqH4eOLyNO5wpiZneR3ntU3tsiYlQX3cqaKLISWbldSUlwa5Hvu4DIPiB6fYSQrhXcKsc0pWKWCI28BbfT43U6T/HdnipIru8WHxz18+3bLXVNt/yi6OQpuB1EuF2enuPHiO1YQS7+FfX1C5EveUaX3R7PwF0iPzhWgEE1QghPyFNwe9lh5uPywvv0zd/R7FIhRFL4ILiDHr6azij/Ef3zIXtvhRAekWcOt5OUgm+CW8MGVp8EpeKNECIR8opwK6QS9nnWZlrDkXCFdILEVgiRGHkJbgfruQ961mE2zybVTzDWCyFEYuQZ4Q54mE5wjoTjpBM0wEQIkSh5CW6np00PDyMTpIQQIlHyErw9tPR2ePRyztONdU+DpoUQaZCX4I7gUPBpp9Z9VlpfDXzurRDCU/IS3B7cCT4VzK5RLLsiwRVCpEFegjvEhDCfItxrTAab8eBYhBAFJA/BcwNrniOP60OEWyOdMEbRTAghUiGPCHc3q172eOJSmGcq2EVN0xJCpEnWglf33+4h0vWBJ+wsOxn4Vl4hhOdkLbhVxjL2euTBnSK6HdOgGiFEmmQteu24E3zx3y7iSriiYpkQIm2yFtwuPLi+DKxxCyI/pLtMCweFEKmSteB2ezaS0S2JPKFWXiFEFuQhuM4SNuzBq7tAK++4olshRBZkLbgulXDYA8FdolB2me28QgiROlkKbg8Da3YzKSxPFhnBeJrV4Ro0LoRInSw7zZzg7qelN2+eUChzovtIbzMhRBZkGeE6ce/zxKFw28zOE90KIUQmZCm4XTQ85J1OeEJk+5m8t0KILMlScAdJJ+TdYXaH2Qk35E4QQmRJluLnxHanB11mNzSGUQiRB1kK7pAHglvfWXZDcxOEEFmTleC63O2+nNfqrOC7PUOzw2pOxyGEKClZCG4FsT2a89DxacT2lKxgQog8yCrC7Uds8+wwe4wVbEzRrRAiD7IQ3PoM3IEcLWFuq8MFrGCPczoGIUTJyUJwO3Ao9OV4qsfZyHvWzGZzPA4hRInJUnB7czzN93EnKHcrhMiNLATXpRF25NjSu0yEe0dWMCFEnmQhuN1MCMtraeQ9WnnHmBImhBC5kFWEm5fgLlAs+9TMbmoMoxAiT9IW3HaaHfbmlMNdpFB2Vq28Qoi8SVtwnci+QONDHg0P9RXo4zn8bCGE+FekLbhu6PhoTumEacR2TFYwIYQPZBHhDubU8OCKZR+b2VV2mAkhRK6kLbh9CG4e6QS3kfcYq9AluEKI3ElbcLsR3TwE9x4phekcfrYQQnyBtEcljlAw68rw1K+yq+wcu8uEEMIL0o5wnSXsEJFuViwxN+EjtfIKIXwii5RC1i29c0S3lzP+uUIIsSlpCu4wlrAso9tVcrfXFd0KIXwjLcF13/cA6YQsI9wZotur6iwTQvhGWoLbHolwezJ8zq5YdpJRjAsZ/lwhhNiSNAV3iC0PWW4GvsVWh3ENqhFC+EZaYthJdDuQ4fN9whjGC6zUEUIIr0hTcHdmOEPBrUC/YmbH+VXRrRDCO9IS3A5m4G7P6AmvkrdVdCuE8Ja0BNfNT9jPr1kwheDe1VtNCOEraQhuFbHdk9GUsDlyt2dxKQghhJekIbgDeHBHMnrCD83sBIKrQTVCCG9JQ3AHcShktVJnErG9qa28QgifSUNwe+guS3sSWZ17OBOeZvTzhBAiFmkIbheCm8UM3Ac0OlzAGiaEEN6ShuD20dbbkfKTruFM+JS5t/LeCiG8Jg3BHcWlkPaUMOe3Pa9GByFEKCQtuDvM7EUzO5hBDncSsb2X8s8RQohESFpwt2EJc5seKim+RHNEt+c191YIEQpJC24Fl0Jfys//Hit0TsmdIIQIhSQFt4JDIYvusro74S5zFIQQwnuSFNwOCmZDKT/pFfK3EyyMFEKIIEhScLvJ346m/MRvRXK3im6FEMGQpOB2MrBmOMUnv8gK9J+Y2ZgEVwgREklat9oQ2zS3PMzTVfaZ3AlCiNBIMsLtwYebpuBO8tCQcSFEcCQluBXSCQdTtIS5iPYYW3mfpPQzhBAiNZIS3DZ2mO1KcWjNJN5bVzCbTelnCCFEaiQluN2kEtKcn3CfYTWPU/wZQgiRGkkJbn3oeFdKB+pSCNdpdFhM6WcIIUSqJCm4O1PsMrtO7nZcVjAhRKgkJbhpzsB1Ee05CmbjKXx/IYTIhKQEt5+lkWlEuE8Zw3hdO8uEECHTauNDhdkJB3EoJC24q2xz+JyBNUIIESytRrhOcPea2ctmti+FoeMuuj1DSkHeWyFE0LQquDV8t6MIb9JDx+8xO+Fmwt9XCCEyJ6kcblcKHtxVbGAufzud8PcWQojMaVVwqyk2PEwhtuPy3gohikCrgtuOHWww4XOxiivhhJldZei4EEIETauC20HDw/aET0IbQusKZg8T/t5CCJELSQju7hSGjk/hTLiW8PcVQojc8DHCXWDA+McUzYQQohC0Irguf7ufPWZJDh1/ShvvRS2JFEIUiVYE13WVHUJ0k5wSdi+yJFIIIQpDK4JbZWhNktHtLMUy51CYSfD7CiFE7rQiuDXsW0k1T9SYm+DGMF6W91YIUTRaEcv+hEcyViJzb2/JeyuEKBqtCK5bGvlKgk0PK0S4NxXdCiGKSKsR7p6E2npXyN06d8INvdOEEEUkruC2E9n2JzSScQbfrdvKO6F3mhCiiMQVXJe7PZzg0PGHNDuo0UEIUVjiCK4rbm1DcPcnNAP3CWIrK5gQorDEFVznvd2B8LbKPGMYx/haCCEKSRzBrc/A7U3ohFwys1+SUljQ20wIUVTiCG5bwoLr3AmnzWyS5gchhCgkcQS3PnR8KIETMov39r7eXkKIohNXcEcTyN8uk7t1Ee5jRbdCiKITV3B3JDADd5pUgns80DtNCFF04vpwhxJo6X3CzrKz2sorhCgDcQS3h+i2r8Xz84C5t/f0ThNClIFmBbeXgTUHWmx4eMgIxsd6lwkhykKzgutmJ7zIHrNWuM7chAf4eoUQovA0K7g9uBNamZ9Qo9nhY4RXe8uEEKWg2Ulf9aHjrQjuY4RWrbxCiFLRbITrnAm7iXTjsEzu9oKZTemtJoQoE3EEd18LgvsUK9gZbGFCCFEamhXcPrrM4u4xm8J3O6bOMiFE2WhGcHtxJ8Rt6V0gnXBa0a0Qoow0I7gud3ukhQ4zN6DmuJmdU7FMCFFGGhXcNiLbHS0sjRwnwlV0K4QoJY0KbhU72LaYjQqLTAa7woZeIYQoHY0Kbgf52+EYLb2uOHbHzE6a2UXEVwghJLgbUCW6jZO/ncd3e0aDaoQQZaZRwa0xISzODNx5CmVXaXwQQohS0ojg1rf0uglhIzFO0gNSCRN6iwkhykwjguvyt0fN7IUYM3CfIrY3zGxG7zQhRJlpRHDdoJq9WMKa7UxzVrBjZnZNU8GEEGWnUcHtjdnOO4Y74absYEKIstOI4PZiB+tq8lwtILTXlU4QQojGBLcfD24zHWYrCO0pM7ul8yyEEI0Jbg8TwpoZyTjPGMZPmaEghBClp9EId7TJCNetPf8Md4IQQpQea0Bwu/DfHmlirc4Srbw3NKhGCCF+x1aCO4DYHmxiaM0U0a3L4c7pXAshxG/YSnB7EN1mHAp3yd9e1qAaIYT4HZsJrmvpHaK7rJl1OHdYozOpNTpCCPE7NhPcduxgI02MZKyv0bmsQTVCCPGv2Upw95jZrgbdDCuMYTxOw4MQQogIW6UUdvJoJMKte2/PaW6CEEJ8kc0E1/lv9+HBbYQn5G7VWSaEEOuwmeC6CWGHmKPQCHfJ3U7qRAshxBfZSHDb2O4w2qD/9gFTwS5TOBNCCLGOsK5HFe9to+28bt7trxjHKIQQYh02EtxOcriNzsC9zpJItfIKIcQGtG/w5/3YwbaaEOasYLeJcKfV6CCEEBuzUYTbh0Ohf4tzt4z39nPmJjS7gkcIIUrDRgK5DZfCVksjF4huz9PSqwhXCCE2YL2UghtW8zxTwrYS3EkE97aaHYQQYnPWi3B7GMd4aIsZuPOsQHfNDo90noUQYnPWE9w2crcjW/zfCXaWfUbBTAghxCasJ7gdeHC3soSNMzdhQrlbIYTYmrWCW5+BO7CFiC6RTjitIeNCCNEYawW3iv92dAuL1x1aec+qWCaEEI2xnuDuZQ7uRoJbj24vSmyFEKJx1hPVHUS4G83Adc0OVzSGUQghmmOt4HaTUhjeQHBreG/P470VQgjRIGsF16USXqDTbD3cCvSPzewTeW+FEKI5ooLbRnS7e5OGhweI7RXlb4UQojmiguu8t4ObiK1LJ9xjFOOszrMQQjRHVHB76C7baOj4BLnbMW11EEKI5okKbi8betebgbvM+pxjRLjLOtdCCNEcayPcnQjvWpaYeXuCll618gohRJOsjXBHN4hwXQrhBt5bia0QQsSgLri9bHjYvU6Eu0ze9nNsYUIIIVoQXFcse8nM9q/jUnAi+yFjGOVOEEKImLTRUdbLDIW963SY3aFYNq6TLIQQ8alHuF2s01mvYDaJQ0FDxoUQogXaiWh7EN0orjg2g9jeUmeZEEK0RhuPAR5RnMC+b2bvmtlNnWchhGiNNmbg1kcyViPfbdXMzrDVYV7nWQghWqNeNNuLQyEquC5ne9/MHuscCyFE67SRx93No84CGx1ua26CEEIkQxuR7T5Wo9dxzoSPaHaY07kWQojWcYJ7hDm4Ucbx3l5UhCuEEMlQdyj0r/lud7CDPdF5FkKIZGij2SHaznuXNt4bOsdCCJEcbcxRiE4IO2tmn5LHFUIIkRBOcA+a2RDfzuVrz5nZBTNb0UkWQojkcIL7vJlt5ztO0egwpnMshBDJ0oYlrJtW3vM8VCwTQoiEaYtEt24j768ZVCOEECIFwd3P1w/J32qrgxBCpEA7+dpBCmWu4WFRJ1oIIRLGzP4/p6h7UAtSSboAAAAASUVORK5CYII=' ) )

local text_offset = { 
    0, -- "enigma"
    0, -- " / user "
    0, -- "0"
    0, -- " ms"
}

local text = {
    'enigma.tech', -- c
    ' / ' .. user.name .. '.' .. user.uid .. ' / ',
    '04:20', -- c
    ' am',
}

local total_offset = 0
for i = 1, #text do
    text_offset[ i ] = total_offset
    local font = i % 2 == 1 and vars.bold_font or vars.default_font
    total_offset = total_offset + render.get_text_size( font, tostring( text[ i ] ) ).x
end

local function on_draw_watermark(watermark_text)
if menu.renderWatermark:get() then
    return ""
else 
    return "enigma.tech / " .. user.name .. '.' .. user.uid
end
end
local on_paint = function( )
    if menu.renderWatermark:get() then
    vars.accent_color = color_picker:get( )

    vars.cheat_name = menu.cheat_name:get( )
    vars.cheat_name = vars.cheat_name == '' and 'enigma.tech' or vars.cheat_name
    local hours, minutes, _ = client.get_local_time( )
    local am_pm = hours > 12 and 'pm' or 'am'
    hours = hours > 12 and hours - 12 or hours

    hours = hours < 10 and '0' .. hours or hours
    minutes = minutes < 10 and '0' .. minutes or minutes

    text[ 1 ] = vars.cheat_name
--    text[ 3 ] = math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 )
    text[ 3 ] = hours .. ':' .. minutes .. ' '
    text[ 4 ] = am_pm

    local text_size = vec2_t( 0, 0 )
    total_offset = 0

    for i = 1, #text do
        text_offset[ i ] = total_offset
        local font = i % 2 == 1 and vars.bold_font or vars.default_font
        total_offset = total_offset + render.get_text_size( font, tostring( text[ i ] ) ).x
    end

    text_size.x = total_offset
    text_size.y = render.get_text_size( vars.bold_font, vars.cheat_name ).y

    local text_start = vec2_t( render.get_screen_size( ).x - vars.text_padding.x - text_size.x, vars.text_padding.y )

    -- rendering bg
    render.rect_filled( text_start - ( vars.text_padding - vars.border_padding ), text_size + ( vars.text_padding - vars.border_padding ) + ( vars.text_padding - vars.border_padding ), color_t( 8, 8, 8, 255 ), 3 )
    render.rect( text_start - ( vars.text_padding - vars.border_padding ) + vec2_t( 1, 1 ), text_size + ( vars.text_padding - vars.border_padding  ) + ( vars.text_padding - vars.border_padding ) - vec2_t( 1, 1 ) - vec2_t( 1, 1 ) - vec2_t( 1, 1 ), color_t( 50, 50, 50, 200 ), 3 )

    render.push_alpha_modifier( 0.015 )
    render.push_clip( text_start - vec2_t( 10, 4 ), text_size + vec2_t( 20, 8 ) )
    if vars.logo_image ~= nil then
        local logo_size = vars.logo_image.size
        -- get percentage of logo size to fit in text area
        local scale = text_size.x / vars.logo_image.size.x 
        local size_x = logo_size.x * scale
        local size_y = logo_size.y * scale

        render.texture( vars.logo_image.id, text_start - vec2_t( 9, size_y / 3 - 5 ), vec2_t( size_x - 4, size_y ), vars.accent_color )
    end

    render.pop_clip( )
    render.pop_alpha_modifier( )

    for i = 1, #text do
        local current_text = tostring( text[ i ] )
        local offset = text_offset[ i ]
        local color = i % 2 == 1 and vars.accent_color or vars.default_color
        local font = i % 2 == 1 and vars.bold_font or vars.default_font

        render.text( font, current_text, text_start + vec2_t( offset, 0 ), color )
    end
end
end

-- tags
local send_clan_tag_addr = memory.find_pattern( "engine.dll", "53 56 57 8B DA 8B F9 FF 15" )
local _set_clantag = ffi.cast( "void( __fastcall* )( const char*, const char* )", send_clan_tag_addr )
local _last_clantag = nil

function set_clantag(v)
    if v == _last_clantag then return end
    _set_clantag(v, v)
    _last_clantag = v
end
local function time_to_ticks(time)
    return math.floor(time / global_vars.interval_per_tick() + .5)
end

local function builder(text, indices)
	local text_anim = "               " .. menu.customInput:get() .. "                      " 
	local tickinterval = global_vars.interval_per_tick()
    local client_latency = math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 )
	local tickcount = global_vars.tick_count() + time_to_ticks(client_latency)
	local i = tickcount / time_to_ticks(0.45)
	i = math.floor(i % #indices)
	i = indices[i+1]+1

	return string.sub(menu.customInput:get(), i, i+15)
end
local clan_tag_prev = ""

local function run_tag_animation()
    if menu.clantagsSelect:get() == 5 then
	if menu.customAnimate:get() then
		--don't advertise other cheats using this or drone strike
		local clan_tag = builder(menu.customInput:get(), {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 11, 11, 11, 11, 11, 11, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22})
		if clan_tag ~= clan_tag_prev then
			set_clantag(clan_tag)
		end
		clan_tag_prev = clan_tag
    else set_clantag(menu.customInput:get())
	end
    end
end
local function tagAnim() 
    -- disabled if disabled lmao
    if menu.masterSelect:get('clantags') then
        if menu.clantagsSelect:get() == 1 then
            set_clantag('')
        end
    end


    local latency = engine.get_latency(e_latency_flows.OUTGOING) / global_vars.interval_per_tick()
    local tickcount = global_vars.tick_count() + latency
    local iter = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #getzeus) + 1)
    local iter2 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #pandoraanim) + 1)
    local iter3 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #onetapanim) + 1)
    local iter4 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #gamesenseanim) + 1)
    local iter5 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #skeetccanim) + 1)
    local iter6 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #fatalanim) + 1)
    local iter7 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #aimware) + 1)
    local iter8 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #mutiny) + 1)
    local iter9 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #rektanim) + 1)
    local iter10 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #nvlanim) + 1)
    local iter11 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #iniuriascroll) + 1)
    local iter12 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #iniuriaglide) + 1)
    local iter13 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #hyperion) + 1)
    local iter14 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #codanim) + 1)
    local iter15 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #hotwheelVIP) + 1)
    local iter16 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #million) + 1)
    local iter17 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #clarity) + 1)
    local iter18 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #lctag) + 1)
    local iter19 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #estonianprim) + 1)
    local iter20 = math.floor(math.fmod(tickcount / menu.cheatDelay:get(), #japPrim) + 1)
if menu.clantagsSelect:get() == 2 then
    if menu.cheatSelect:get() == 1 then
        set_clantag(getzeus[iter])
    elseif menu.cheatSelect:get() == 2 then
        set_clantag(pandoraanim[iter2])
    elseif menu.cheatSelect:get() == 3 then
        set_clantag('pandora')
    elseif menu.cheatSelect:get() == 4 then
        set_clantag(onetapanim[iter3])
    elseif menu.cheatSelect:get() == 5 then
        set_clantag('onetap')
    elseif menu.cheatSelect:get() == 6 then
        set_clantag(gamesenseanim[iter4])
    elseif menu.cheatSelect:get() == 7 then
        set_clantag(skeetccanim[iter5])
    elseif menu.cheatSelect:get() == 8 then
        set_clantag(fatalanim[iter6])
    elseif menu.cheatSelect:get() == 9 then
        set_clantag(aimware[iter7])
    elseif menu.cheatSelect:get() == 10 then
        set_clantag(mutiny[iter8])
    elseif menu.cheatSelect:get() == 11 then
        set_clantag(rektanim[iter9])
    elseif menu.cheatSelect:get() == 12 then
        set_clantag(nvlanim[iter10])
    elseif menu.cheatSelect:get() == 13 then
        set_clantag(iniuriascroll[iter11])
    elseif menu.cheatSelect:get() == 14 then
        set_clantag(iniuriaglide[iter12])
    elseif menu.cheatSelect:get() == 15 then
        set_clantag('INIURIA.US')
    elseif menu.cheatSelect:get() == 16 then
        set_clantag(hyperion[iter13])
    elseif menu.cheatSelect:get() == 17 then
        set_clantag(codanim[iter14])
    elseif menu.cheatSelect:get() == 18 then
        set_clantag(hotwheelVIP[iter15])
    elseif menu.cheatSelect:get() == 19 then
        set_clantag(million[iter16])
    elseif menu.cheatSelect:get() == 20 then
        set_clantag(clarity[iter17])
    elseif menu.cheatSelect:get() == 21 then
        set_clantag(lctag[iter18])
    elseif menu.cheatSelect:get() == 22 then
        set_clantag(estonianprim[iter19])
    elseif menu.cheatSelect:get() == 23 then
        set_clantag(japPrim[iter20])
    end
end
        local luaiter1 = math.floor(math.fmod(tickcount / menu.luaDelay:get(), #brightside) + 1)
		local luaiter2 = math.floor(math.fmod(tickcount / menu.luaDelay:get(), #personaTag) + 1)
		local luaiter3 = math.floor(math.fmod(tickcount / menu.luaDelay:get(), #ouijaTag) + 1)
		local luaiter4 = math.floor(math.fmod(tickcount / menu.luaDelay:get(), #ftb) + 1)
if menu.clantagsSelect:get() == 3 then
    if menu.luatagSelect:get() == 1 then
        set_clantag(brightside[luaiter1])
    elseif menu.luatagSelect:get() == 2 then
        set_clantag(personaTag[luaiter2])
    elseif menu.luatagSelect:get() == 3 then
        set_clantag(ouijaTag[luaiter3])
    elseif menu.luatagSelect:get() == 4 then
        set_clantag(ftb[luaiter4])
    end
end

if menu.clantagsSelect:get() == 4 then
    if menu.steamSelect:get() == 1 then
        set_clantag("crimwalkers")
    elseif menu.steamSelect:get() == 2 then
        set_clantag("unfortunate")
    elseif menu.steamSelect:get() == 3 then
        set_clantag("dmt")
    elseif menu.steamSelect:get() == 4 then
        set_clantag("h0tgirlz")
    elseif menu.steamSelect:get() == 5 then
        set_clantag("bodyaimers")
    elseif menu.steamSelect:get() == 6 then
        set_clantag("auf nusse $")
    elseif menu.steamSelect:get() == 7 then
        set_clantag("STAINLESS'")
    elseif menu.steamSelect:get() == 8 then
        set_clantag("rich")
    elseif menu.steamSelect:get() == 9 then
        set_clantag("JUUL")
    elseif menu.steamSelect:get() == 10 then
        set_clantag("FSX")
    elseif menu.steamSelect:get() == 11 then
        set_clantag("simswap")
    elseif menu.steamSelect:get() == 12 then
        set_clantag("KIDUAHOOK")
    elseif menu.steamSelect:get() == 13 then
        set_clantag("ow bypass")
    elseif menu.steamSelect:get() == 14 then
        set_clantag("ev0lve.xyz")
    elseif menu.steamSelect:get() == 15 then
        set_clantag("~~Monolith~~")
    elseif menu.steamSelect:get() == 16 then
        set_clantag("BhopConfig")
    elseif menu.steamSelect:get() == 17 then
        set_clantag("output")
    elseif menu.steamSelect:get() == 18 then
        set_clantag("cybercrime")
    elseif menu.steamSelect:get() == 19 then
        set_clantag("♥")
    elseif menu.steamSelect:get() == 20 then
        set_clantag("skateman$")
    elseif menu.steamSelect:get() == 21 then
        set_clantag("180grad")
    elseif menu.steamSelect:get() == 22 then
        set_clantag("180treehouse")
    elseif menu.steamSelect:get() == 23 then
        set_clantag("thighs")
    elseif menu.steamSelect:get() == 24 then
        set_clantag("souljahook")
    elseif menu.steamSelect:get() == 25 then
        set_clantag("$teppa")
    elseif menu.steamSelect:get() == 26 then
        set_clantag("Invalid Text")
    elseif menu.steamSelect:get() == 27 then
        set_clantag("in denail")
    elseif menu.steamSelect:get() == 28 then
        set_clantag("learncpp.com")
    elseif menu.steamSelect:get() == 29 then
        set_clantag("xtc")
    elseif menu.steamSelect:get() == 30 then
        set_clantag("sbdsm")
    elseif menu.steamSelect:get() == 31 then
        set_clantag("ibuprofen.cc")
    end
end

end -- func end
--tags end

kill_say.player_death = function(event)
    
    if event.attacker == event.userid or not menu.enableSay:get() then
        return
    end

    local attacker = entity_list.get_player_from_userid(event.attacker)
    local localplayer = entity_list.get_local_player()

    if attacker ~= localplayer then
        return
    end

    local current_killsay_list = kill_say.phrases[menu.current_list:get()].phrases
    local current_phrase = current_killsay_list[client.random_int(1, #current_killsay_list)]:gsub('\"', '')
    
    engine.execute_cmd(('say "%s"'):format(current_phrase))
end

callbacks.add(e_callbacks.EVENT, kill_say.player_death, "player_death")

local ground_tick = 1
local end_time = 0
   callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local localPlayer = entity_list.get_local_player()
    local lp = entity_list.get_local_player()
    local sexgod = lp:get_prop("m_vecVelocity[1]") ~= 0	
    local flags = localPlayer:get_prop("m_fFlags")
    local on_land = bit.band(flags, bit.lshift(1, 0)) ~= 0
    local curtime = global_vars.cur_time()
    if on_land == true then
        ground_tick = ground_tick + 1
    else
        ground_tick = 0
        end_time = curtime + 1
    end
    if menu.anim_selection:get(1) then
        ctx:set_render_pose(e_poses.RUN, 0)
    end

    if refs.isSW[2]:get() and menu.anim_selection:get(2) then
        ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
    end

    if menu.anim_selection:get(4) then
        if sexgod then
            ctx:set_render_animlayer(e_animlayers.LEAN, 1)
        end
    end

    if refs.isSW[2]:get() then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0)
    end

    if menu.anim_selection:get(3) then
        ctx:set_render_pose(e_poses.JUMP_FALL, 1)
    end
    if menu.anim_selection:get(7) and ground_tick > 1 and end_time > curtime then
        ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
    end
end)

   if menu.mass_slider:get() == 0 then menu.mass_slider:set(50) end
   local function on_setup_command()
       -- Return if the local player isn't alive
       local local_player = entity_list.get_local_player()
       if not local_player or not local_player:is_alive() then
           return
       end
   
       -- Set the model scale ^-^
       local_player:set_prop("m_flModelScale", menu.mass_slider:get() / 50)
       local_player:set_prop("m_ScaleType", 1)
       local state = math.random(0, 1)
       if menu.anim_selection:get(5) then
           if state == 0 then
            refs.mRandom_midget_mode:set(true)
           elseif state == 1 then
            refs.mRandom_midget_mode:set(false) 
           end
       end
       if menu.anim_selection:get(6)then
           if state == 0 then
               refs.mRandom_midget_mode:set(true)
               refs.mRandom_paper_mode:set(true)
           elseif state == 1 then
            refs.mRandom_midget_mode:set(false) 
            refs.mRandom_paper_mode:set(false)
           end
       end
   end
   
   --| The shutdown callback
   local function on_shutdown()
       -- Return if the local player isn't alive
       local local_player = entity_list.get_local_player()
       if not local_player or not local_player:is_alive() then
           return
       end
   
       -- Set the model scale ^-^
       local_player:set_prop("m_flModelScale", 1)
       local_player:set_prop("m_ScaleType", 0)
   end



   local function debugPanelFunc ()
    local function getweapon()
        local local_player = entity_list.get_local_player()
        if local_player == nil then return end
    
        local weapon_name = nil
    
        if local_player:get_prop("m_iHealth") > 0 then
        
            local active_weapon = local_player:get_active_weapon()
            if active_weapon == nil then return end
    
            weapon_name = active_weapon:get_name()
    
    
        else return end
    
        return weapon_name
    
    end
   local safepoint = {}
   safepoint = 'default'
    --safe point bullshit
    if getweapon() == 'ssg08' then
    if refs.safepoint_s[2]:get() then
            safepoint = 'forced'
        end
    end
    if getweapon() == 'scar20' or getweapon() == 'g3sg1' then
        if refs.safepoint_a[2]:get() then
            safepoint = 'forced'
        end
    end
    if getweapon() == 'awp' then
        if refs.safepoint_awp[2]:get() then
            safepoint = 'forced'
        end
    end
    if getweapon() == 'deagle' then
        if refs.safepoint_d[2]:get() then
            safepoint = 'forced'
        end
    end
    if getweapon() == 'revolver' then 
        if refs.safepoint_r[2]:get() then
            safepoint = 'forced'
        end
    end
    if getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
        if refs.safepoint_p[2]:get() then
            safepoint = 'forced'
        end
    end



    fps = client.get_fps()
    ping = math.floor( engine.get_latency( e_latency_flows.OUTGOING ) * 1000 )
    local real = antiaim.get_real_angle()
    local fake = antiaim.get_fake_angle()

    --water mark
    textFPS = "fps [" .. fps .. "]"
    textPING = "ping [" .. ping .. "]"

    local local_player = entity_list.get_local_player()

    --screen size
    local x1 = render.get_screen_size().x * 0.5 - 800
    local x = render.get_screen_size().x 
    local y = render.get_screen_size().y

    --invert state
    if antiaim.is_inverting_desync() == false then
        invert ="right"
        clr1 = color_t(89, 171, 227 ,255)
    else
        invert ="left"
        clr1 = color_t(89, 171, 227 ,255)
    end
    local function clamp(min, max, value)
        return math.min(math.max(value, min), max)
    end
    local fake_mins_real = fake - real
    local desync_amt = clamp(-60, 60, fake_mins_real)
    --screen size
    local ay = 40
    local alpha = math.floor( math.sin( global_vars.real_time() * 2 ) * ( 255 / 2 - 1 ) + 255 / 2 ) or 255
    local pixel = render.create_font("Tahoma Bold", 12, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)

    --text sizes
    local enigmaTs = render.get_text_size(pixel, '» enigma [')
    local build = 'debug'
    local fakelag = math.floor(engine.get_choked_commands() * 1.5)
    local fakelagTs = render.get_text_size(pixel, '» fake lag: '.. fakelag.. ' ')
    local exploitsTs = render.get_text_size(pixel, '» exploits: ')
    local sideTs = render.get_text_size(pixel, '» side: ')

    local velocity_history = {}
    if engine.is_connected() then
    local velocity = local_player:get_prop("m_vecVelocity"):length()
    velocity = math.floor(velocity + 0.5)
    local runningg = velocity >= 210
    local walking = velocity >= 112
    local still = velocity <= 110
    local stage = ""
    local airflag = local_player:get_prop('m_fFlags')
    if bit.band(airflag, 1) == 0  then
        stage = 'in air'
    elseif refs.isSW[2]:get() then
        stage = "slow walking"
    elseif runningg then 
        stage = "running"
    elseif walking then 
        stage = "walking"
    elseif still then 
        stage = "still"
    end
if menu.debugOpt:get('fps') then
    render.text(pixel, textFPS, vec2_t(x- 55, y - 1030), color_t(255, 200, 50, 255), 10, true)
end
if menu.debugOpt:get('latency') then
    render.text(pixel, textPING, vec2_t(x- 55, y - 1045), color_t(255, 200, 50, 255), 10, true)
end

    if menu.debugSwitch:get() then
        --enigma main line
        render.text(pixel, 'debug panel', vec2_t(x1, y*0.5), color_t(255,255,255,255))
        render.text(pixel, '» enigma [      ] - user: ' .. user.uid, vec2_t(x1, y * 0.5+12), color_t(237,159,203, 255))
        render.text(pixel, 'live', vec2_t(x1 + enigmaTs.x, y*0.5+12), color_t(237,159,203,alpha))
        render.text(pixel, '» fake lag: '.. fakelag, vec2_t(x1, y*0.5+84), color_t(178,166,231, 255))
        render.text(pixel, '» desync: ' .. math.floor(desync_amt * 1) .. '°', vec2_t(x1, y *0.5 +36), color_t(242,131,131, 255))
        render.text(pixel, '» condition: ' ..stage, vec2_t(x1,y*0.5+24), color_t(176,214,18,255))
        -- exploit charge
        if exploits.get_charge() == 0 then
        render.text(pixel, '» exploits: ', vec2_t(x1,y*0.5+48), color_t(255,255,255,255))
        render.text(pixel, 'uncharged', vec2_t(x1+exploitsTs.x,y*0.5+48), color_t(230,23,81,255))
        else 
            render.text(pixel, '» exploits: ', vec2_t(x1,y*0.5+48), color_t(255,255,255,255))
            render.text(pixel, 'charged', vec2_t(x1+exploitsTs.x,y*0.5+48), color_t(73,227,73,255))
        end
        render.text(pixel, '» safety: ' .. safepoint, vec2_t(x1, y*0.5+60), color_t(78,196,211,255))
        --invert the aa
        if antiaim.is_inverting_desync() == true then
            render.text(pixel, '» side: ', vec2_t(x1,y*0.5+72), color_t(142,212,152,255))
            render.text(pixel, 'right',vec2_t(x1+sideTs.x,y*0.5+72), color_t(142,212,152,255))
        else
            render.text(pixel, '» side: ', vec2_t(x1,y*0.5+72), color_t(142,212,152,255))
            render.text(pixel, 'left',vec2_t(x1+sideTs.x,y*0.5+72), color_t(142,212,152,255))
        end

    end
end
end

local function Animation(check, name, value, speed) 
    if check then 
        return name + (value - name) * global_vars.frame_time() * speed
    else 
        return name - (value + name) * global_vars.frame_time() * speed / 2;
    end
end

local x = render.get_screen_size().x
local y = render.get_screen_size().y
local tahoma = render.create_font("Candara Italic", 21, 500, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE, e_font_flags.DROPSHADOW)
local tahoma2 = render.create_font("Open Sans Regular", 11, 200, e_font_flags.ANTIALIAS, e_font_flags.OUTLINE)
local fadealpha = math.min(math.floor(math.sin((global_vars.frame_time() %3) * 1) * 150 + 25), 255)

local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end
local data = {}
local font = render.create_font('Small Fonts', 12, 200, e_font_flags.OUTLINE)
local font_x = render.create_font('Comic Sans MS Bold', 15, 550, e_font_flags.OUTLINE)

local on_miss = function(e)
    for index, value in pairs(data) do
        if data[index].id == e.id then
            data[index].reason = e.reason_string
            data[index].hitbox = client.get_hitbox_name(e.aim_hitbox)
            data[index].world_pos = e.player:get_hitbox_pos(e.aim_hitbox)
        end
    end
end

local on_shoot = function (e)
    table.insert(data, 1, {id=e.id, world_pos=nil, reason='null', hitbox='null', time=client.get_unix_time(), opacity = 255})
end
anim = -20
local function indicators_func()
    if menu.worldMisses:get() then
    for index, value in pairs(data) do
        local world_pos = data[index].world_pos
        local reason = data[index].reason
        local hitbox = data[index].hitbox
        local opacity = data[index].opacity

        if world_pos then
            if client.get_unix_time() > data[index].time + 2 then
                data[index].opacity = data[index].opacity - 10

                if opacity < 1 then
                    table.remove(data, index)
                end
            end

            if opacity > 1 then
                local screen_pos = render.world_to_screen(world_pos)
                if reason and screen_pos then
                    render.text(font_x, 'x ', screen_pos + vec2_t(0, -render.get_text_size(font_x, 'x ').y/2), color_t(255, 0, 0, opacity))
                    render.text(font, reason .. ' ' .. hitbox, screen_pos + vec2_t(0 + render.get_text_size(font_x, 'x ').x, -render.get_text_size(font_x, 'x ').y/2 + 1), color_t(255, 0, 0, opacity))
                end
            end
        end
    end
end



    local local_player = entity_list.get_local_player()

    local c_x = x * 0.5
    local c_y = y * 0.5
    local menuCol = logoColor:get()
    local bindsCol = indColor:get()
    local alpha = math.floor( math.sin( global_vars.real_time() * 2 ) * ( 255 / 2 - 1 ) + 255 / 2 ) or 255
    local logoCol = color_t(menuCol.r, menuCol.g, menuCol.b, menuCol.a)
    local fadeCol = color_t(menuCol.r, menuCol.g, menuCol.b, alpha)
    local bindCol = color_t(bindsCol.r, bindsCol.g, bindsCol.b, bindsCol.a)

    local weap = local_player:get_active_weapon()
    if weap == nil then return end
    local is_scoped = weap:get_prop("m_zoomLevel")
    local scoped_prop = local_player:get_prop("m_bIsScoped")
    local in_scope = scoped_prop == 1 and true or false


    nebunie = 20
    if menu.masterSelect:get('visuals') then
        if menu.scopeAnim:get() then
            anim = Animation(in_scope, anim, 22, 8)
        else
            anim = -22
        end
        
        if menu.indicatorOpt:get('logo') then
            if menu.pulseLogo:get() then
                render.text(tahoma, "enigma", vec2_t(c_x + anim - 3  , c_y - 5 + nebunie), fadeCol)
            else
                render.text(tahoma, "enigma", vec2_t(c_x + anim - 3  , c_y - 5 + nebunie), logoCol)
            end
        end
        if menu.indicatorOpt:get('dt') then
            if refs.isDT[2]:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "tap 2x", vec2_t(c_x + anim + 10, c_y + 7 + nebunie), bindCol)
            end
        end
        if menu.indicatorOpt:get('hideshots') then
            if refs.isHS[2]:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "hide", vec2_t(c_x + anim + 12, c_y + 7 + nebunie), bindCol)
            end
        end
        if menu.indicatorOpt:get('auto peek') then
            if refs.isAP[2]:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "peek", vec2_t(c_x + anim + 12, c_y + 7 + nebunie), bindCol)
            end
        end
        if menu.indicatorOpt:get('ax') then
            if refs.axNoob:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "pred", vec2_t(c_x + anim + 12, c_y + 7 + nebunie), bindCol)
            end
        end
        if menu.indicatorOpt:get('fd') then
            if refs.isFD[2]:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "duck", vec2_t(c_x + anim + 12, c_y + 7 + nebunie), bindCol)
            end
        end

        if menu.indicatorOpt:get('safepoint') then
            if getweapon() == "ssg08" then
                if refs.safepoint_s[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "deagle"  then
                if refs.safepoint_d[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "revolver" then
                if refs.safepoint_r[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "awp" then
                if refs.safepoint_awp[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                if refs.safepoint_a[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
                if refs.safepoint_p[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "safe", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            end
        end
        if menu.indicatorOpt:get('min dmg') then
            if getweapon() == "ssg08" then
                if refs.min_damage_s[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "deagle" then
                if refs.min_damage_d[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "revolver" then
                if refs.min_damage_r[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "awp" then
                if refs.min_damage_awp[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "scar20" or getweapon() == "g3sg1" then
                if refs.min_damage_a[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            elseif getweapon() == "glock" or getweapon() == "p250" or getweapon() == "cz75a" or getweapon() == "usp-s" or getweapon() == "tec9" or getweapon() == "p2000" or getweapon() == "fiveseven" or getweapon() == "elite" then
                if refs.min_damage_p[2]:get() then
                    nebunie = nebunie + 10
                    render.text(tahoma2, "dmg", vec2_t(c_x + anim + 13, c_y + 7 + nebunie), bindCol)
                end
            end
        end
        if menu.indicatorOpt:get('ping spike') then
            if refs.pingSpike[2]:get() then
                nebunie = nebunie + 10
                render.text(tahoma2, "ping", vec2_t(c_x + anim + 14, c_y + 7 + nebunie), bindCol)
            end
        end

        end
    end



local spectator_font = render.create_font( "Tahoma", 12, 400, e_font_flags.DROPSHADOW )

local local_player = entity_list.get_local_player()
local screen_size = render.get_screen_size( )

function get_table_length( table )
    length = 0

    for _ in pairs( table ) do
        length = length + 1
    end

    return length
end
function get_table_length( table )
    length = 0

    for _ in pairs( table ) do
        length = length + 1
    end

    return length
end
local function spectator_list( )
    spectators_size = render.get_text_size( spectator_font, "spectators" )

    spectators = { "spectators" }
    cur_spec_index = 2

    -- iterate through all players
    for _, player in pairs( entity_list.get_players( ) ) do
        if player:is_alive( ) or player:is_dormant( ) then
            goto continue
        end

        observer_target = entity_list.get_entity( player:get_prop( "m_hObserverTarget" ) )

        if observer_target ~= local_player then
            goto continue
        end

        spectators[ cur_spec_index ] = player:get_name( )

        -- go to the next index
        cur_spec_index = cur_spec_index + 1

        ::continue::
    end

    height = 11 * get_table_length( spectators )

    -- go through all our spectators
    for i, spectator in pairs( spectators ) do
        spectator_size = render.get_text_size( spectator_font, spectator )

        spectator_pos = vec2_t(
                screen_size.x - 20 - spectator_size.x,
                ( ( screen_size.y * 0.5 ) - ( height * 0.5 ) ) + ( i * 11 ) -- center it relative to the center.
        )

        render.text( spectator_font, spectator, spectator_pos, color_t( 255, 255, 255 ) )
    end
end










local function menuElms()
menu.masterSelect:set_visible(menu.masterSwitch:get())
menu.cheatSelect:set_visible(menu.clantagsSelect:get() == 2)
menu.clantagsSelect:set_visible(menu.masterSelect:get('clantags'))
menu.cheatDelay:set_visible(menu.clantagsSelect:get() == 2)
menu.luatagSelect:set_visible(menu.clantagsSelect:get() == 3)
menu.luaDelay:set_visible(menu.clantagsSelect:get() == 3)
menu.steamSelect:set_visible(menu.clantagsSelect:get() == 4)
menu.customInput:set_visible(menu.clantagsSelect:get() == 5)
menu.customAnimate:set_visible(menu.clantagsSelect:get() == 5)


menu.indicatorOpt:set_visible(menu.masterSelect:get('visuals'))
logoColor:set_visible(menu.indicatorOpt:get('logo'))
indColor:set_visible(menu.indicatorOpt:get('dt'))
menu.scopeAnim:set_visible(menu.masterSelect:get('visuals'))
menu.worldMisses:set_visible(menu.masterSelect:get('visuals'))
menu.pulseLogo:set_visible(menu.masterSelect:get('visuals'))
menu.specSwitch:set_visible(menu.masterSelect:get('visuals'))
menu.renderWatermark:set_visible(menu.masterSelect:get('visuals'))
menu.cheat_name:set_visible(menu.renderWatermark:get())
menu.color_override:set_visible(menu.renderWatermark:get())
color_picker:set_visible(menu.color_override:get())

menu.anim_selection:set_visible(menu.masterSelect:get('misc'))
menu.mass_slider:set_visible(menu.masterSelect:get('misc'))
menu.debugSwitch:set_visible(menu.masterSelect:get('misc'))
menu.debugOpt:set_visible(menu.debugSwitch:get())
menu.enableSay:set_visible(menu.masterSelect:get('misc'))
menu.current_list:set_visible(menu.enableSay:get())
if menu.masterSwitch:get() then 
    menu.welc1:set_visible(false)
    menu.welc2:set_visible(false)
    menu.welc3:set_visible(false)
    menu.welc4:set_visible(false)
    menu.welc5:set_visible(false)
else
menu.masterSelect:set('clantags', false)
menu.masterSelect:set('visuals', false)
menu.masterSelect:set('misc', false)
menu.debugSwitch:set(false)
menu.renderWatermark:set(false)
menu.clantagsSelect:set(1)
end
if menu.masterSelect:get('clantags') then
    tagAnim()
    run_tag_animation()
else
end
if menu.renderWatermark:get() then
    on_paint()
else
end
if menu.debugSwitch:get() then
    debugPanelFunc()
else
end
if not local_player then 
    return
end
if menu.specSwitch:get() then
    spectator_list()
else 
end
if menu.masterSelect:get('visuals') then
    indicators_func()
else
end

end
callbacks.add(e_callbacks.AIMBOT_MISS, on_miss)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_shoot)
callbacks.add(e_callbacks.PAINT, menuElms)
callbacks.add(e_callbacks.SETUP_COMMAND, on_setup_command)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)