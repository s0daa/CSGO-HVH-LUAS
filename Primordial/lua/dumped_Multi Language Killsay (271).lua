local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "english",
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
        "Are you that stupid, or is someone helping you?"
    }
})

table.insert(kill_say.phrases, {
    name = "german",
    phrases = {
    "Das Einzige, was niedriger als Ihr k/d-Verhältnis ist, ist Ihre Penisgröße.",
    "Warum vermisst du? Ich bin nicht deine Freundin.",
    "Deine Mutter hätte besser daran getan, dich zu schlucken.",
    "Du bist so hässlich, dass man bei deiner Geburt ein dunkles Glas auf den Inkubator gestellt hat.",
    "Warst du auf der Toilette, als Gott Informationen herausgab?",
    "Wenn dein IQ zwei höher wäre, könntest du ein Pommes Frites sein.",
    "Fragen Sie so bald wie möglich nach einer Rückerstattung für Ihren Hack.",
    "Warum bist du hier? Die Schwulenbar ist zwei Blocks entfernt.",
    "Wer hat Bots in dieses Match eingesetzt?",
    "Viele Leute saugen für Geld, warum machst du es umsonst?",
    "Du bist der Typ Spieler, der in einem 1-gegen-1-Match den 3. Platz belegt.",
    "Mein k/d-Verhältnis ist höher als dein IQ.",
    "Du bist wie die Treppe: dunkel und eng.",
    "Warum hast du das Streichholz angenommen, du wusstest, dass du scheiße bist.",
    "Benutze EzFrags nicht mehr, kaufe normalen Cheat.",
    "Kauf einen besseren Hack mit dem OnlyFans-Geld deiner Mutter.",
    "Ich verstehe nicht, warum du weinst, es sind nur 24 cm.",
    "Du bist wie ein Kondom, du bist am Arsch.",
    "Hast du wirklich deine anale Jungfräulichkeit für diesen Betrug verkauft?",
    "Du bist der Grund, warum Abtreibung legalisiert wurde.",
    "Wenn ich von deinem Ego zu deiner Intelligenz springen würde, würde ich auf halber Höhe verhungern.",
    "Das Einzige, was unzuverlässiger ist als du, ist das Kondom, das dein Vater benutzt hat.",
    "Besser PC kaufen, aufhören in der Schulbibliothek zu spielen.",
    "Manche Babys wurden auf den Kopf geworfen, aber Sie wurden eindeutig gegen eine Wand geschleudert.",
    "Vielleicht hat Gott dich etwas zu besonders gemacht.",
    "Ich sage nicht, dass ich dich hasse, aber ich würde deine Lebenserhaltung ausstecken, um mein Handy aufzuladen.",
    "Ich bin ehrlich, du bist zurückgeblieben!",
    "Ich lüge nicht, es war zu einfach, dich zu töten.",
    "Du bist wie ein Ball, ich könnte dich treten.",
    "+1",
    "Dein Betrug ist nicht das Problem, sondern dass du geboren wurdest.",
    "Als ich deine Schwester fickte, hörte ich deinen Vater im Schrank masturbieren.",
    "Boooooooooom, du bist gestorben.",
    "Mein k/d-Verhältnis ist höher als deine Kills.",
    "Wer hat gefragt, was du willst? Du bist gestorben.",
    "Hast du für diesen Cheat bezahlt? Schade...",
    "Wie ich sehe, benutzen Sie AA. Wie wäre es, wenn Sie Ihr Gehirn benutzen?",
    "Mensch, ich bin besser als du.",
    "Wenn du so viel IQ hättest, wie du gestorben bist, würdest du vielleicht nicht sabbern.",
    "Wie ich sehe, schaust du gerne Killcam, weil du immer stirbst.",
    "Du bist tot, Zeit, vom Computer aufzustehen und eine Freundin zu finden.",
    "Als ich deine Mutter gefickt habe, wusste ich nicht, was ich getan habe. Nach 9 Monaten … bist du geboren.",
    "Ziehen Sie das Stromkabel von Ihrem Computer ab. Pinkeln Sie hinein, es passiert dasselbe wie jetzt. Sie werden sterben.",
    "Haben Sie jemals versucht, normal zu sein?",
    "Bist du so dumm, oder hilft dir jemand?"
    }
})

table.insert(kill_say.phrases, {
    name = "kurdish",
    phrases = {
        "Tişta ku ji rêjeya weya k/d kêmtir e, mezinahiya penîsê we ye.",
        "Tu çima bêriya te kiriye? Ez ne hevala te me.",
        "Diya te çêtir e ku te daqurtanda.",
        "Tu ew qas pîs î ku gava ku tu ji dayik bûyî şûşeyek tarî danîbûn ser inkubatorê.",
        "Dema ku Xwedê îstîxbarat da, hûn di tuwaletê de bûn?",
        "Heke IQ-ya we du IQ bilindtir bû, hûn dikarin bibin efsûnek fransî.",
        "Her ku zû dibe, ji bo hacka xwe vegerandinek bixwaze.",
        "Tu çima li vir î? Barê hevzayendan du blokên dûr e.",
        "Kê bot di vê maçê de danîn?",
        "Gelek kes ji bo drav dimijin, çima hûn wiya belaş dikin?",
        "Hûn ew celeb lîstikvan in ku di maçeke 1v1 de cîhê 3yemîn digire.",
        "Rêjeya min a k/d ji IQ-ya we mezintir e.",
        "Tu mîna derenceyê yî: tarî û girtî.",
        "Te çima maçê qebûl kir, te dizanibû ku tu şirîkî.",
        "Bikaranîna EzFrags rawestînin, xapandina normal bikirin.",
        "Bi pereyên OnlyFans yên diya xwe hackek çêtir bikirin.",
        "Ez fêm nakim çima tu digirî, tenê 24 cm ye.",
        "Tu wek kondomê yî, tu bi ken î.",
        "Ma bi rastî te ji bo wê xapandinê keçika xwe ya anal firot?",
        "Hûn sedemê ku kurtaj hat qanûnîkirin.",
        "Eger ez ji egoya te biçim ser aqilê te, ezê ji birçîna nîvê rê bimirim.",
        "Tiştê ku ji we ne pêbawertir e, kondoma ku bavê we bikar aniye.",
        "Çêtir PC bikirin, li pirtûkxaneya dibistanê lîstin rawestînin.",
        "Hin zarok avêtin ser serê wan, lê hûn bi eşkere avêtin ser dîwarekî.",
        "Dibe ku Xwedê tu piçek pir taybet çêkir.",
        "Ez nabêjim ku ez ji we nefret dikim, lê ez ê piştgiriya jiyana we jê bikim da ku têlefona xwe şarj bikim.",
        "Ez ê rast bibêjim, tu paşdemayî yî!",
        "Ez derewan nakim, kuştina te pir hêsan bû.",
        "Tu mîna topê yî, ez dikarim pê li te bikim.",

        "Pirsgirêka xapandina te ne, lê ew e ku hûn ji dayik bûne.",
        "Dema ku min xûşka te kir, min bihîst ku bavê te di dolabê de masturbat dike.",
        "Boooooooooom, tu mir.",
        "Rêjeya min a k/d ji kuştinên we bilindtir e.",
        "Kê pirsî tu çi dixwazî? Tu mir.",
        "We heqê vê xapandinê da? Heyf bû...",
        "Ez dibînim ku hûn AA bikar tînin. Çawa mejiyê xwe bikar tînin?",
        "Şeeeesh, ez ji te çêtir im.",
        "Ger bi qasî ku we mir IQ-ya we hebûya, belkî we nexapiya.",
        "Ez dibînim ku hûn ji temaşekirina killcamê hez dikin ji ber ku hûn her gav dimirin.",
        "Tu mirî yî, dem hatiye ku hûn ji kompîturê rabin û hevala xwe bibînin.",
        "Dema ku min li diya te kir, min nizanibû min çi kir. Piştî 9 mehan..... tu ji dayik bû.",
        "Kabloya elektrîkê ji komputera xwe veqetîne. Binêre wê, heman tişt dê bibe wekî niha. Hûn ê bimirin.",
        "We qet hewl daye ku hûn normal bin?",
        "Tu ew qas bêaqil î, an kesek alîkariya te dike?"
    }
})

table.insert(kill_say.phrases, {
    name = "indian",
    phrases = {
        "aapake k/d anupaat se keval ek hee cheez kam hai, vah hai aapake ling ka aakaar.",
        "tum kyon yaad karate ho? main tumhaaree premika nahin hoon.",
        "tumhaaree maan ne tumhen nigalane ke lie behatar kiya hoga.",
        "aap itane badasoorat hain ki jab aap paida hue the to unhonne inakyoobetar par ek kaala gilaas daal diya.",
        "jab bhagavaan ne buddhi dee, to kya aap shauchaalay mein the?",
        "yadi aapaka aaeekyoo do aaeekyoo adhik tha, to aap phrench phraee ho sakate hain.",
        "jitanee jaldee ho sake, apane haik ke lie dhanavaapasee maangen.",
        "tum yahaan kyon ho? samalaingik baar do blok door hai.",
        "is maich mein bots kisane lagae?",
        "bahut se log paise ke lie choosate hain, aap ise mupht mein kyon karate hain?",
        "aap 1v1 maich mein teesara sthaan paane vaale khilaadee hain.",
        "mera k/d anupaat aapake iq se adhik hai.",
        "aap seedhee kee tarah hain: andhera aur seemit.",
        "tumane maich kyon sveekaar kiya, tumhen pata tha ki tumane choosa.",
        "aizfrags ka upayog band karo, saamaany dhokha khareedo.",
        "apanee maan ke keval prashansakon ke paise se ek behatar haik khareeden.",
        "mujhe samajh mein nahin aa raha hai ki tum kyon ro rahe ho, yah keval 24 semee hai.",
        "tum ek kandom kee tarah ho, tum gadabad ho.",
        "kya tumane sach mein us dhokhe ke lie apana guda kaumaary bech diya?",
        "aap hee kaaran hain ki garbhapaat ko vaidh kar diya gaya.",
        "agar main tumhaare ahankaar se tumhaaree buddhi mein kood gaya, to eed aadhee-adhooree bhookh se mar jaegee.",
        "keval ek cheej jo aapase jyaada avishvasaneey hai vah hai vah kandom jo aapake pitaajee ne istemaal kiya tha.",
        "behatar hoga peesee khareeden, skool kee laibreree mein khelana band karen.",
        "kuchh bachchon ko unake sir par gira diya gaya tha lekin aapako spasht roop se ek deevaar par phenk diya gaya tha.",
        "ho sakata hai bhagavaan ne aapako kuchh jyaada hee khaas banaaya ho.",
        "main yah nahin kah raha hoon ki main tumase napharat karata hoon, lekin main apana phon chaarj karane ke lie aapake jeevan samarthan ko anaplag kar doonga.",
        "main eemaanadaar rahoonga, tum mandabuddhi ho!",
        "main jhooth nahin bol raha hoon, tumhen maarana bahut aasaan tha.",
        "tum ek gend kee tarah ho, main tumhen laat maar sakata hoon.",

        "aapaka dhokha samasya nahin hai, balki yah hai ki aap paida hue the.",
        "jab mainne tumhaaree bahan ko choda, to mainne tumhaare pita ko kotharee mein hastamaithun karate suna.",
        "boououom, tum mar gae.",
        "mera k/d anupaat aapakee hatyaon ko adhik karata hai.",
        "kisane poochha ki tum kya chaahate ho? tum mar gae.",
        "kya aapane is dhokhe ke lie bhugataan kiya? yah afasos kee baat thee...",
        "main dekh raha hoon ki aap aa ka upayog karate hain. apane mastishk ka upayog kaise karen?",
        "sheesh, main tumase behatar hoon.",
        "yadi aapake paas utana hee iq hota jitana ki aap mar chuke hain, to shaayad aap nahin dolate.",
        "main dekhata hoon ki aap kilakaim dekhana pasand karate hain kyonki aap hamesha marate hain.",
        "aap mar chuke hain, kampyootar se uthane aur premika paane ka samay aa gaya hai.",
        "jab mainne tumhaaree maan ko choda to mujhe nahin pata tha ki mainne kya kiya. 9 maheene ke baad .... tumhaara janm hua.",
        "apane kampyootar se paavar kebal ko anaplag karen. isamen peshaab karen, vahee hoga jo abhee hoga. aap mar jaenge.",
        "kya aapane kabhee saamaany hone kee koshish kee hai?",
        "kya tum itane moorkh ho, ya koee tumhaaree madad kar raha hai?",
    }
})

table.insert(kill_say.phrases, {
    name = "african",
    phrases = {
        "Die enigste ding wat laer is as jou k/d-verhouding is jou penisgrootte.",
        "Hoekom mis jy? Ek is nie jou vriendin nie.",
        "Jou ma sou beter gedoen het om jou in te sluk.",
        "Jy is so lelik dat hulle 'n donker glas op die broeikas gesit het toe jy gebore is.",
        "Toe God intelligensie uitgegee het, was jy in die toilet?",
        "As jou IK twee IK's hoër was, kan jy 'n Franse braai wees.",
        "Vra so gou as moontlik vir 'n terugbetaling vir jou hack.",
        "Hoekom is jy hier? Die gay kroeg is twee blokke weg.",
        "Wie het bots in hierdie wedstryd gesit?",
        "Baie mense suig vir geld, hoekom doen jy dit gratis?",
        "Jy is die tipe speler wat 'n 3de plek in 'n 1v1-wedstryd kry.",
        "My k/d-verhouding hoër as jou IK.",
        "Jy is soos die trap: donker en ingeperk.",
        "Hoekom het jy die wedstryd aanvaar, jy het geweet jy het gesuig.",
        "Hou op om EzFrags te gebruik, koop normale cheat.",
        "Koop 'n beter hack met jou ma se OnlyFans-geld.",
        "Ek verstaan nie hoekom jy huil nie, dis net 24cm.",
        "Jy is soos 'n kondoom, jy is befok.",
        "Het jy regtig jou anale maagdelikheid verkoop vir daardie kullery?",
        "Jy is die rede waarom aborsie gewettig is.",
        "As ek van jou ego na jou intelligensie gespring het, sal ek halfpad af van die honger sterf.",
        "Die enigste ding wat meer onbetroubaar is as jy, is die kondoom wat jou pa gebruik het.",
        "Kop beter rekenaar, hou op om by skoolbiblioteek te speel.",
        "Sommige babas is op hul koppe laat val, maar jy is duidelik teen 'n muur gegooi.",
        "Miskien het God jou 'n bietjie te spesiaal gemaak.",
        "Ek sê nie ek haat jou nie, maar ek sal jou lewensondersteuning ontkoppel om my foon te laai.",
        "Ek sal eerlik wees, jy is vertraag!",
        "Ek lieg nie, dit was te maklik om jou dood te maak.",
        "Jy is soos 'n bal, ek kan jou skop.",

        "Jou cheat is nie die probleem nie, maar dat jy gebore is.",
        "Toe ek jou suster genaai het, het ek jou pa in die kas hoor masturbeer.",
        "Booooooooom, jy het gesterf.",
        "My k/d-verhouding hoër jou doodslae.",
        "Wie het gevra wat jy wil hê? Jy is dood.",
        "Het jy vir hierdie cheat betaal? Dit was jammer...",
        "Ek sien jy gebruik AA. Hoe gaan dit met die gebruik van jou brein?",
        "Sheeeesh, ek is beter as jy.",
        "As jy soveel IK gehad het as wat jy gesterf het, sou jy dalk nie kwyl nie.",
        "Ek sien jy hou daarvan om killcam te kyk, want jy sterf altyd.",
        "Jy is dood, tyd om van die rekenaar af op te staan en 'n vriendin te kry.",
        "Toe ek jou ma genaai het, het ek nie geweet wat ek gedoen het nie. Na 9 maande..... is jy gebore.",
        "Trek die kragkabel uit jou rekenaar. Pis daarin, dieselfde ding sal gebeur as nou. Jy sal doodgaan.",
        "Het jy al ooit probeer om normaal te wees?",
        "Is jy so dom, of help iemand jou?",
    }
})

table.insert(kill_say.phrases, {
    name = "arabic",
    phrases = {
        "الشيء الوحيد الأقل من نسبة k / d هو حجم قضيبك.",
        "لماذا تفتقد؟ أنا لست صديقتك.",
        "والدتك كان من الأفضل أن تبتلعك",
        "أنت قبيح جدًا لدرجة أنهم وضعوا زجاجًا داكنًا على الحاضنة عندما ولدت.",
        "عندما قدم الله معلومات, هل كنت في المرحاض؟",
        "إذا كان معدل ذكائك أعلى بمعدلين لمعدل الذكاء, فيمكنك أن تكون زريعة فرنسية.",
        "في أقرب وقت ممكن, اطلب استرداد أموال الاختراق الخاص بك.",
        "لماذا أنت هنا؟ شريط المثليين على بعد كتلتين من الأبنية.",
        "من وضع الروبوتات في هذه المباراة؟",
        "كثير من الناس سيئون من أجل المال, لماذا تفعل ذلك مجانًا؟",
        "أنت من نوع اللاعب الذي حصل على المركز الثالث في مباراة 1v1.",
        "نسبة k / d الخاصة بي أعلى من معدل الذكاء الخاص بك.",
        "أنت مثل الدرج: مظلم ومحصور.",
        "لماذا قبلت المباراة, كنت تعلم أنك مقرف.",
        "توقف عن استخدام EzFrags, اشتر غشًا عاديًا.",
        "اشترِ اختراقًا أفضل بأموال OnlyFans لوالدتك.",
        "لا أفهم لماذا تبكين, طولها 24 سم فقط.",
        "أنت مثل الواقي الذكري, لقد انتهيت.",
        "هل حقا بعت عذريتك الشرجية لهذا الغش؟",
        "أنت سبب تشريع الإجهاض.",
        "إذا قفزت من غرورك إلى ذكاءك, فإن Id يموت من الجوع في منتصف الطريق.",
        "الشيء الوحيد الذي لا يمكن الاعتماد عليه أكثر منك هو الواقي الذكري الذي استخدمه والدك.",
        "شراء أفضل لجهاز الكمبيوتر, توقف عن اللعب في مكتبة المدرسة.",
        "سقط بعض الأطفال على رؤوسهم لكن من الواضح أنك ألقيت على الحائط.",
        "ربما جعلك الله شيئًا مميزًا جدًا.",
        "أنا لا أقول إنني أكرهك, لكنني سأفصل دعم حياتك لشحن هاتفي.",
        "سأكون صادقًا, أنت متخلف!",
        "أنا لا أكذب, كان من السهل جدًا قتلك.",
        "أنت مثل الكرة, يمكنني ركلك",

        "خداعك ليس هو المشكلة, لكنك ولدت.",
        "عندما ضاجعت أختك, سمعت والدك يستمني في الخزانة",
        "بوووووووم, ماتت.",
        "نسبة k / d الخاصة بي تزيد من قتلك.",
        "من سأل ماذا تريد؟ ماتت.",
        "هل دفعت ثمن هذا الغش؟ لقد كان مؤسفًا ...",
        "أراك تستخدم AA. ماذا عن استخدام عقلك؟",
        "شيش أنا أفضل منك",
        "إذا كان لديك معدل ذكاء كما ماتت, فربما لن يسيل لعابك.",
        "أراك تحب مشاهدة killcam لأنك تموت دائمًا.",
        "لقد مات, حان الوقت للاستيقاظ من جهاز الكمبيوتر والحصول على صديقة.",
        "عندما ضاجعت والدتك لم أكن أعرف ماذا فعلت. بعد 9 أشهر ..... ولدت.",
        "افصل كابل الطاقة من جهاز الكمبيوتر الخاص بك. تبول فيه, سيحدث نفس الشيء كما هو الحال الآن. ستموت.",
        "هل سبق لك أن حاولت أن تكون طبيعيًا؟",
        "هل أنت بهذا الغبي, أم أن هناك من يساعدك؟",
    }
})

table.insert(kill_say.phrases, {
    name = "chinese",
    phrases = {
        "唯一低於你的 k/d 比率的是你的陰莖大小。",
        "你為什麼想念？我不是你的女朋友。",
        "你媽媽吞下你會更好。",
        "你太醜了,你出生的時候,他們在孵化器上放了一個深色玻璃。",
        "當上帝給出情報時,你在廁所嗎？",
        "如果你的智商高出兩個智商,你就可以成為炸薯條了。",
        "盡快為您的黑客請求退款。",
        "你為什麼在這裡？同性戀酒吧就在兩個街區之外。",
        "誰在這場比賽中放置了機器人？",
        "很多人貪錢,你為什麼要免費做？",
        "你是那種在 1v1 比賽中獲得第三名的球員。",
        "我的k/d比比你的智商高。",
        "你就像樓梯：黑暗而狹窄。",
        "你為什麼接受比賽,你知道你很爛。",
        "停止使用 EzFrags,購買普通作弊器。",
        "用你媽媽的 OnlyFans 錢買一個更好的黑客。",
        "我不明白你為什麼哭,才24cm。",
        "你就像一個避孕套,你完蛋了。",
        "你真的為了那個作弊出賣了你的肛門處女嗎？",
        "你是墮胎合法化的原因。",
        "如果我從你的自我跳到你的智慧,我會在中途餓死。",
        "唯一比你更不靠譜的就是你爸用的避孕套了。",
        "最好買電腦,別在學校圖書館玩了。",
        "有些嬰兒是摔在頭上的,但你顯然是被扔在牆上的。",
        "也許上帝讓你有點太特別了。",
        "我不是說我討厭你,但我會拔掉你的生命支持來給我的手機充電。",
        "老實說,你是智障！",
        "我沒有說謊,殺你太容易了。",
        "你就像一個球,我可以踢你。",

        "你的作弊不是問題,而是你出生的問題。",
        "當我操你妹妹時,我聽到你父親在壁櫥裡自慰。",
        "嗚嗚嗚,你死了。",
        "我的 k/d 比率更高你的殺戮。",
        "誰問你想要什麼？你死了。",
        "你為這個作弊付出了代價嗎？很遺憾......",
        "我看到你用AA。用你的大腦怎麼樣？",
        "Sheeeeesh,我比你好。",
        "如果你的智商和你死的一樣多,也許你就不會流口水了。",
        "我看你喜歡看killcam,因為你總是死。",
        "你死定了,該從電腦上起來找個女朋友了。",
        "當我操你媽媽的時候,我不知道我做了什麼。9個月後......你出生了。",
        "從你的電腦上拔下電源線。在裡面小便,會發生和現在一樣的事情。你會死的。",
        "你有沒有嘗試過成為正常人？",
        "你這麼笨,還是有人幫你？"
    }
})

table.insert(kill_say.phrases, {
    name = "russian",
    phrases = {
    "сьебался нахуй таракан усатый", "мать твою ебал", "нахуй ты упал иди вставай и на завод",
    "не по сезону шуршишь фраер",
    "ИЗИ ЧМО ЕБАНОЕ",
    "ливай блять не позорься",
    "AХАХ ПИДОР УПАЛ С ВАНВЕЯ ХАХАХА ОНЛИ БАИМ В БОДИ ПОТЕЕТ НА ФД АХА", "АХАХА УЛЕТЕЛ ЧМОШНИК",
    "1 МАТЬ ЖАЛЬ",
    "тебе права голоса не давали thirdworlder ебаный",
    "на завод иди",
    "не не он опять упал на конлени",
    "вставай заебал, завтра в школу", "гет гуд гет иди нахуй",
    "ну нет почему он ложится когда я прохожу", "у тебя ник нейм адео?", "парень тебе ник придумать?",
    "такой тупой :(",
    "хватит получать хс,лучше возьми свою руку и иди дрочи",
    "нет нет этот крякер такой смешной",
    "1 сын шлюхи",
    "1 мать твою ебал",
    "преобрети мой кфг клоун",
    "об кафель голову разбил?",
    "мать твою ебал",
    "хуесос дальше адайся ко мне",
    "ещё раз позови к себе на бекап",
    "не противник",
    "ник нейм дориан(",
    "iq ?",
    "упал = минус мать", "не пиши мне",
    "жаль конечно что против тебя играю, но куда деваться", "адиничкой упал", "сынок зачем тебе это ?",
    "давно в рот берёшь?", "мне можно", "ты меня так заебал, ливни уже",
    "ничему жизнь не учит (", "я не понял, ты такой жирный потомучто дошики каждый день жрешь?",
    "братка го я тебе бекап позову", "толстяк даже пройти спокойно не может"
    }
})

table.insert(kill_say.phrases, {
    name = "turkish",
    phrases = {
        "Maymun turk 1",
        "fukara turco",
        "taliban member turks",
        "ucube turkler",
        "ucube turkler hvh",
        "essek turkler",
        "public user turco",
        "primless turko",
        "gazi babanın protez bacağını sikeyim xd",
       "1 orospu evladı.",
       "al ağzına oğlum",
       "Türk milleti zekidir!",
       "afiyet olsun kardeşim.",
       "yunanistan kralı maymun tarafından götünden ısırılarak öldürülmüştür.",
       "fakir orospu evladı refund.",
       "Valla onu bunu bilmem ben Tayyipçiyim arkadaş! -M.Kemal Atatürk",
       "bi kızı seviyon - açılıyon - reddedilion - hvh oynuyon .",
       "zargana orospu evladı.",
       "yat lan orospu oğlu",
       "açlıktan ağzın kokuyor fakir orospu çocuğu.",
       "Ku Klux Klan'a alımlar başlamıştır.",
       "Bu sunucudan kalıcı olarak yasaklandınız.",
       "amogus.",
       "git minecraft oyna beceriksiz ucube.",
       "midget aa.",
       "abusing turks with AllahınınAmı.lua",
       "yatırım yapmazsan bu gün 100tln var ama yaparsan yarın 10tln var",
       "franfort zort.",
       "allahi yedim",
       "alevi babani yedim",
       "muhammedi siktim",
       "9 yasindaki ayseyi yedim",
       "dun zekiydim dunyayi kurtarmak istedim bugun ise bilgeyim turkleri gotunden sikeyim.",
       "kenafir gozlu kahpe seni"
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