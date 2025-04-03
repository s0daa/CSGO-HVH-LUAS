local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "Default",
    phrases = {
        "The only thing lower than your k/d ratio is your penis size.",
        "Why you miss? Im not your girlfriend.",
        "Your mother would have done better to swallow you.",
        "You are so ugly that they put a dark glass on the incubator when you were born.",
        "When God gave out intelligence, were you in the toilet?",
        "If your IQ was two IQ's higher, you could be a French fry.",
        "As soon as possible, ask for a refund for your hack.",
        "Why are you here? The gay bar is two blocks away.",
        "Who put bots in this match?",
        "Many people suck for money, why do you do it for free?",
        "You're the type of player to get 3rd place in a 1v1 match.",
        "My k/d ratio higher than your IQ.",
        "You're like the staircase: dark and confined.",
        "Why did you accept the match, you knew you sucked.",
        "Stop using EzFrags, buy normal cheat.",
        "Buy a better hack with your mother's OnlyFans money.",
        "I don't understand why you're crying, it's only 24cm.",
        "You're like a condom, you're fucked.",
        "Did you really sold your anal virginity for that cheat?",
        "You're the reason abortion was legalized.",
        "If I jumped from your ego to your intelligence, Id die of starvation half-way down.",
        "The only thing more unreliable than you is the condom your dad used.",
        "Better buy PC, stop playing at school library.",
        "Some babies were dropped on their heads but you were clearly thrown at a wall.",
        "Maybe God made you a bit too special.",
        "I'm not saying I hate you, but I would unplug your life support to charge my phone.",
        "I'll be honest, you're retarded!",
        "I'm not lying, it was too easy to kill you.",
        "You're like a ball, I could kick you.",
        "+1",
        "Your cheat is not the problem, but that you were born.",
        "When I fucked your sister, I heard your father masturbating in the closet.",
        "Boooooooooom, u died.",
        "My k/d ratio higher your kills.",
        "Who asked what u wannt? You died.",
        "Did you pay for this cheat? It was a pity...",
        "I see you use AA. How about using your brain?",
        "Sheeeeesh, I am better than you.",
        "If you had as much IQ as you've died, maybe you wouldn't drool.",
        "I see you like watching killcam because you always die.",
        "You're dead, time to get up from the computer and get a girlfriend.",
        "When I fucked your mother I didn't know what i did. After 9 month..... u born.",
        "Unplug the power cable from your computer. Pee in it, the same thing will happen as now. You will die.",
        "Have you ever tried being normal?",
        "Are you that stupid, or is someone helping you?",
    }
})

table.insert(kill_say.phrases, {
    name = "Anime lewd",
    phrases = {
        "S-Sorry onii-chan p-please d-do me harder ;w;",
        "Y-You got me all wet now Senpai!",
        "D-Don't t-touch me there Senpai",
        "P-Please l-love me harder oniichan ohh grrh aahhhh~!",
        "Give me all your cum Senpai ahhhhh~",
        "F-Fuck me harder chan!",
        "Oh my god I hate you so much Senpai but please k-keep fucking me harder! ahhh~",
        "D-Do you like my stripped panties getting soaked by you and your hard cock? ehhh Master you're so lewd ^0^~",
        "Kun your cute little dick between my pussy lips looks really cute, I'm blushing",
        "M-Master does it feel good when I slide by tits up and down on your cute manly part?",
        "O-Oniichan my t-toes are so warm with your cum all over them uwu~",
        "Lets take this swimsuit off already <3 i'll drink your unknown melty juice",
        "S-Stop Senpai if we keep making these lewd sounds im going to cum~~",
        "You're such a pervert for filling me up with your baby batter Senpai~~",
        "Fill up my baby chamber with your semen kun ^-^",
        "M-Master d-dont spank my petite butt so hard ahhhH~~~ you're getting me so w-wet~",
        "Senpai your cock is already throbbing from my huge tits~",
        "Hey kun, Can I have some semen?",
        "M-My baby chamber is overflowing with your semen M-Master",
        "Y-Yes M-Master right there",
        "Oh do you wanna eat? Do you wanna take a bath? Or do you want me!",
        "it's not gay if you swallow the evidence S-Sempai",
        "Fill my throat pussy with your semen kun",
        "It-It's not gay if you're wearing thigh highs M-Master",
        "I-I need somewhere to blow my load. Can i borrow your bussy?",
        "A-ah shit... Y-your cock is big and in my ass already~?!",
        "I-I'm cumming, I'm cumming, CUM with me too!",
        "Drench me and I'll do the same!",
        "I'll swallow your sticky essence along with you~!",
        "You're my personal cum bucket!!",
        "B-baka please let me be your femboy sissy cum slut!",
        "That's a penis UwU you towd me you wewe a giww!!",
        "You are cordially invited to fuck my ass!",
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