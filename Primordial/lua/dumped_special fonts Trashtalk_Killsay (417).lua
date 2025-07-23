-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local kill_say = {}
local ui = {}
kill_say.phrases = {}


table.insert(kill_say.phrases, {
    name = "skeet killsay (◣_◢)",
    phrases = {
        "𝕝𝕚𝕗𝕖 𝕚𝕤 𝕒 𝕘𝕒𝕞𝕖, 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕚𝕤 𝕙𝕠𝕨 𝕨𝕖 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕔𝕠𝕣𝕖 ♛ 𝕞𝕒𝕜𝕖 𝕣𝕚𝕔𝕙 𝕞𝕒𝕚𝕟𝕤, 𝕟𝕠𝕥 𝕗𝕣𝕚𝕖𝕟𝕕𝕤",
		"𝙒𝙝𝙚𝙣 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄'𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣'𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕",
		"𝒯𝒽𝑒 𝓅𝓇𝑜𝒷𝓁𝑒𝓂 𝒾𝓈 𝓉𝒽𝒶𝓉 𝒾 𝑜𝓃𝓁𝓎 𝒾𝓃𝒿𝑒𝒸𝓉 𝒸𝒽𝑒𝒶𝓉𝓈 𝑜𝓃 𝓂𝓎 𝓂𝒶𝒾𝓃 𝓉𝒽𝒶𝓉 𝒽𝒶𝓋𝑒 𝓃𝒶𝓂𝑒𝓈 𝓉𝒽𝒶𝓉 𝓈𝓉𝒶𝓇𝓉 𝓌𝒾𝓉𝒽 𝓰 𝒶𝓃𝒹 𝑒𝓃𝒹 𝓌𝒾𝓉𝒽 𝓪𝓶𝓮𝓼𝓮𝓷𝓼𝓮",
		"(◣_◢) 𝕐𝕠𝕦 𝕒𝕨𝕒𝕝𝕝 𝕗𝕚𝕣𝕤𝕥? 𝕆𝕜 𝕝𝕖𝕥𝕤 𝕗𝕦𝕟 slightsmile (◣_◢)",
		"ｉ ｃａｎｔ ｌｏｓｅ ｏｎ ｏｆｆｉｃｅ ｉｔ ｍｙ ｈｏｍｅ",
		"𝕞𝕒𝕚𝕟 𝕟𝕖𝕨= 𝕔𝕒𝕟 𝕓𝕦𝕪.. 𝕙𝕧𝕙 𝕨𝕚𝕟? 𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕚𝕞 𝕔𝕒𝕟, 𝕚𝕞 𝕝𝕠𝕒𝕕 𝕣𝕒𝕘𝕖 ♕",
		"♛Ａｌｌ   Ｆａｍｉｌｙ   ｉｎ   ｇｓ♛",
		"u will 𝕣𝕖𝕘𝕣𝕖𝕥 rage vs me when i go on ｌｏｌｚ．ｇｕｒｕ acc.",
		"𝔻𝕠𝕟𝕥 𝕒𝕕𝕕 𝕞𝕖 𝕥𝕠 𝕨𝕒𝕣 𝕠𝕟 𝕞𝕪 𝕤𝕞𝕦𝕣𝕗 (◣_◢) 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖 𝕒𝕝𝕨𝕒𝕪𝕤 𝕣𝕖𝕒𝕕𝕪 ♛",
		"♛ 𝓽𝓾𝓻𝓴𝓲𝓼𝓱 𝓽𝓻𝓾𝓼𝓽 𝓯𝓪𝓬𝓽𝓸𝓻 ♛",
		"𝕕𝕦𝕞𝕓 𝕕𝕠𝕘, 𝕪𝕠𝕦 𝕒𝕨𝕒𝕜𝕖 𝕥𝕙𝕖 ᴅʀᴀɢᴏɴ ʜᴠʜ ᴍᴀᴄʜɪɴᴇ, 𝕟𝕠𝕨 𝕪𝕠𝕦 𝕝𝕠𝕤𝕖 𝙖𝙘𝙘 𝕒𝕟𝕕 𝚐𝚊𝚖𝚎 ♕",
		"♛ 𝕞𝕪 𝕙𝕧𝕙 𝕥𝕖𝕒𝕞 𝕚𝕤 𝕣𝕖𝕒𝕕𝕪 𝕘𝕠 𝟙𝕩𝟙 𝟚𝕩𝟚 𝟛𝕩𝟛 𝟜𝕩𝟜 𝟝𝕩𝟝 (◣_◢)",
		"ᴀɢᴀɪɴ ɴᴏɴᴀᴍᴇ ᴏɴ ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ. ɪ ꜱᴇᴇ ᴀɢᴀɪɴ ᴀᴄᴛɪᴠɪᴛʏ.",
		"ɴᴏɴᴀᴍᴇ ʟɪꜱᴛᴇɴ ᴛᴏ ᴍᴇ ! ᴍʏ ꜱᴛᴇᴀᴍ ᴀᴄᴄᴏᴜɴᴛ ɪꜱ ɴᴏᴛ ʏᴏᴜʀ ᴘʀᴏᴘᴇʀᴛʏ.",
		"𝙋𝙤𝙤𝙧 𝙖𝙘𝙘 𝙙𝙤𝙣’𝙩 𝙘𝙤𝙢𝙢𝙚𝙣𝙩 𝙥𝙡𝙚𝙖𝙨𝙚 ♛",
		"𝕥𝕣𝕪 𝕥𝕠 𝕥𝕖𝕤𝕥 𝕞𝕖? (◣_◢) 𝕞𝕪 𝕞𝕚𝕕𝕕𝕝𝕖 𝕟𝕒𝕞𝕖 𝕚𝕤 𝕘𝕖𝕟𝕦𝕚𝕟𝕖 𝕡𝕚𝕟 ♛",
		"𝓭𝓸𝓷𝓽 𝓝𝓝",
		"ℕ𝕠 𝕆𝔾 𝕀𝔻? 𝔻𝕠𝕟'𝕥 𝕒𝕕𝕕 𝕞𝕖 𝓷𝓲𝓰𝓰𝓪",
		"𝐻𝒱𝐻 𝐿𝑒𝑔𝑒𝓃𝒹𝑒𝓃 𝟤𝟢𝟤𝟤 𝑅𝐼𝒫 𝐿𝒾𝓁 𝒫𝑒𝑒𝓅 & 𝒳𝓍𝓍𝓉𝑒𝒶𝓃𝒸𝒾𝑜𝓃 & 𝒥𝓊𝒾𝒸𝑒 𝒲𝓇𝓁𝒹",
		"𝕚 𝕘𝕤 𝕦𝕤𝕖𝕣, 𝕟𝕠 𝕘𝕤 𝕟𝕠 𝕥𝕒𝕝𝕜",
		"𝐨𝐮𝐫 𝐥𝐢𝐟𝐞 𝐦𝐨𝐭𝐨 𝐢𝐬 𝐖𝐈𝐍 > 𝐀𝐂𝐂",
		"𝕗𝕦𝕔𝕜 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕒𝕟𝕕 𝕗𝕣𝕚𝕖𝕟𝕕𝕤, 𝕜𝕖𝕖𝕡 𝕥𝕙𝕖 𝕤𝕥𝕖𝕒𝕞 𝕝𝕖𝕧𝕖𝕝 𝕦𝕡 ♚",
		"𝚜𝚎𝚖𝚒𝚛𝚊𝚐𝚎 𝚝𝚒𝚕𝚕 𝚢𝚘𝚞 𝚍𝚒𝚎, 𝚋𝚞𝚝 𝚠𝚎 𝚕𝚒𝚟𝚎 𝚏𝚘𝚛𝚎𝚟𝚎𝚛 (◣_◢)",
		"𝔂𝓸𝓾 𝓭𝓸𝓷𝓽 𝓷𝓮𝓮𝓭 𝓯𝓻𝓲𝓮𝓷𝓭𝓼 𝔀𝓱𝓮𝓷 𝔂𝓸𝓾 𝓱𝓪𝓿𝓮 𝓰𝓪𝓶𝓮𝓼𝓮𝓷𝓼𝓮",
		"-ᴀᴄᴄ? ᴡʜᴏ ᴄᴀʀꜱ ɪᴍ ʀɪᴄʜ ʜʜʜʜʜʜ",
		"𝚢𝚘𝚞 𝚊𝚠𝚊𝚕𝚕 𝚏𝚒𝚛𝚜𝚝? 𝚘𝚔 𝚕𝚎𝚝𝚜 𝚏𝚞𝚗 :)",
		"𝕤𝕠𝕣𝕣𝕪 𝕔𝕒𝕟𝕥 𝕙𝕖𝕒𝕣 𝕤𝕜𝕖𝕖𝕥𝕝𝕖𝕤𝕤",
		"𝔂𝓸𝓾 𝓬𝓪𝓶𝓽 𝓺𝓾𝓲𝓬𝓴 𝓹𝓮𝓪𝓴 𝓱𝓿𝓱 𝓴𝓲𝓷𝓰",
		"ｎｉｃｅ ｔｒｙ ｐｏｏｒ ｄｏｇ",
		"𝔸𝕃𝕃 𝔻𝕆𝔾𝕊 𝕃𝕆𝕊𝔼 𝕋𝕆 𝔾𝕊",
		"𝙼𝚈 𝙱𝙾𝚃𝙽𝙴𝚃 𝙳𝙾𝙴𝚂𝙽𝚃 𝙲𝙰𝚁𝙴 𝙰𝙱𝙾𝚄𝚃 𝚈𝙾𝚄𝚁 𝙵𝙴𝙴𝙻𝙸𝙽𝙶𝚂",
		"𝕚𝕟 𝟝𝕧𝕤𝟝 𝕚𝕞 𝕒𝕝𝕨𝕒𝕪𝕤 𝕤𝕡𝕖𝕒𝕜 𝕗𝕠𝕣 𝕥𝕖𝕒𝕞, 𝔻𝕆ℕ𝕋 𝕘𝕠𝕚𝕟𝕘 𝕗𝕠𝕣 𝕙𝕖𝕒𝕕𝕤, 𝔹𝕆𝔻𝕐𝔸𝕀𝕄𝕊, 𝕓𝕦𝕥 𝕕𝕠𝕘𝕤 𝕟𝕖𝕧𝕖𝕣 𝕨𝕒𝕟𝕥 𝕝𝕚𝕤𝕥𝕖𝕟",
		'Ｙｏｕｒ ｃｈｅａｔ ｉｓ ｎｏｔ ｔｈｅ ｐｒｏｂｌｅｍ， ｂｕｔ ｔｈａｔ ｙｏｕ ｗｅｒｅ ｂｏｒｎ．',
		'𝐓𝐡𝐞 𝐨𝐧𝐥𝐲 𝐭𝐡𝐢𝐧𝐠 𝐥𝐨𝐰𝐞𝐫 𝐭𝐡𝐚𝐧 𝐲𝐨𝐮𝐫 𝐤/𝐝 𝐫𝐚𝐭𝐢𝐨 𝐢𝐬 𝐲𝐨𝐮𝐫 𝐩𝐞𝐧𝐢𝐬 𝐬𝐢𝐳𝐞.',
		'˜”*°•.˜”*°• ʏᴏᴜʀ ᴍᴏᴛʜᴇʀ ᴡᴏᴜʟᴅ ʜᴀᴠᴇ ᴅᴏɴᴇ ʙᴇᴛᴛᴇʀ ᴛᴏ ꜱᴡᴀʟʟᴏᴡ ʏᴏᴜ. •°*”˜.•°*”˜',
		'𝓘 𝓯𝓾𝓬𝓴𝓮𝓭 𝔂𝓸𝓾 𝓾𝓹.',
    }
})

table.insert(kill_say.phrases, {
    name = "russian killsay (◣_◢)",
    phrases = {
    "еба тя расплющило жирнич", 
	"Создатель JS REZOLVER",
    "《AK•47•KILLER》☆",
    "Теперь я - Ютубер Омлет (◣_◢)",
    "Я играю на лайфхакерском конфиге от Шока (◣_◢)",
    "нищий улетел", 
    "*忍び 1 УПАЛ び忍", 
    "ХАХАХАХАХХАХА НИЩИЙ УЛЕТЕЛ (◣_◢)",
    "я ķ¤нɥåλ ϯβ¤£ü ɱåɱķ£ β Ƥ¤ϯ", 
    "Желток в деле! Белок на пределе! (◣_◢)",
    "опущены стяги, легион и.. А БЛЯТЬ ТЫЖ ТУТ ОПУЩ НАХУЙ ПХГАХААХАХАХАХА)))))))", 
    "але ты там из хрущевки выеди а потом выпрыгивай блять", 
    "ебать ты красиво на бутылку упал",
    "ты как ваще живешь в коробке 1х1м где ты деньги на акк взял нищ ахахах",
    "╭∩╮(◣_◢)╭∩╮",
    "co‌mm‌it‌ n‌ec‌k ‌ro‌pe‌ u‌r ‌to‌o ‌ba‌d ‌xa‌xa", 
    "who (кто) you (ты) ватофак мен))",
    "->‌> ‌si‌rg‌ay‌zo‌rh‌ac‌k.‌pw‌/в‌оз‌вр‌ат‌де‌не‌г.‌ph‌p ‌«‌-", 
    "в окно паунс сделай у тя даже юида нету ЛОООЛ",
    "земля те землей хуй до чиста еденицей отлетел))",
    "8====={Headshot beath]==0", 
    "ху‌я ‌ты‌ н‌а ‌бу‌ты‌лк‌у ‌уп‌ал‌ х‌ах‌ах‌ах‌а", 
    "I'm not using www.ezfrags.co.uk, you're just bad",
    "мн‌е ‌по‌ху‌й ‌на‌ к‌ри‌ти‌ку‌ о‌че‌ре‌дн‌ог‌о ‌ны‌ти‌ка‌, ‌со‌ м‌но‌й ‌мо‌и ‌лю‌ди‌, ‌мо‌й ‌ра‌йо‌н,‌ м‌оя‌ ",  
    "AHXAAP!! oNe.TaP.RU!*", 
    "Я играю на вкуснейшем конфиге от Омлета ツ", 
    "как ты на пк накопил даже не знаю )))))))))", 
    "найс 0.5х0.5м комната блять ХАХАХАХА ТЫ ТАМ ЖЕ ДАЖЕ ПОВЕСИТЬСЯ НЕ МОЖЕШЬ МЕСТА НЕТ ПХПХПХППХ",  
    "THIS IS OMLEEEEEEET (◣◢)", 
    "VAAAAAAAC в чат!!! (づ ◕‿◕ )づ", 
    "LIFEEEEHAAAACK BITCH!!! (◣_◢)", 
    "AXAXAXAXAXAXAXA (◣_◢)",
    "ЕБУЧЕСТЬ ВТОРОГО РАЗРЯДА ВЫДВИЖЕНЕЦ ОТКИС", 
	"але а противники то где???", 
	"ты по легиту играешь ?",
    "ХУЕПРЫГАЛО ТУСОВОЧНОЕ КУДА ПОЛЕТЕЛО", 
	"ты куда жертва козьего аборта",
    "iq?", 
	"·٠●•۩۞۩ОтДыХаЙ (ٿ) НуБяРа۩۞۩•●٠·", 
	"ты то куда лезешь сын фантомного стационарного спец изолированого металлформовочного механизма", 
	"╭∩╮( ⚆ ʖ ⚆)╭∩╮ ДоПрыГался(ت)ДрУжоЧеК",
	"держи зонтик ☂, тебя обоссали",
	"Держи ✈ и лети нахуй !", 
	"слишком сочный для Djamic.technologies",
    "сьебался нахуй таракан усатый", 
	"мать твою ебал", 
	" нахуй ты упал иди вставай и на завод",
    "не по сезону шуршишь фраер",
    "ИЗИ ЧМО ЕБАНОЕ",
    "ливай блять не позорься",
    "AХАХ ПИДОР УПАЛ С ВАНВЕЯ ХАХАХА ОНЛИ БАИМ В БОДИ ПОТЕЕТ НА ФД АХА", 
	"АХАХА УЛЕТЕЛ ЧМОШНИК",
    "1 МАТЬ ЖАЛЬ",
    "тебе права голоса не давали thirdworlder ебаный",
    "на завод иди",
    "не не он опять упал на колени",
    "вставай заебал , завтра в школу", 
	"гет гуд гет иди нахуй",
    "ну нет почему он ложится когда я прохожу", 
	"у тебя ник нейм адео?", 
	"by SANCHEZj hvh boss",
	"парень тебе ник придумать?",
    "такой тупой :(",
    "хватит получать хс ,лучше возьми свою руку и иди дрочи",
    "нет нет этот крякер такой смешной",
    "1 сын шлюхи",
    "1 мать твою ебал",
    "приобрети мой кфг клоун",
    "об кафель голову разбил?",
    "мать твою ебал",
    "хуесос дальше адайся ко мне",
    "ещё раз позови к себе на бекап",
    "не противник",
    "ник нейм дориан(",
    "упал = минус мать", 
	"не пиши мне",
    "$жаль конечно что против тебя играю, но куда деваться", 
	"единичкой упал", 
	"сынок зачем тебе это ?",
    "давно в рот берёшь?", 
	"мне можно", 
    "ты меня так заебал , ливни уже",
    "ничему жизнь не учит (", 
	"я не понял, ты такой жирный потому что дошики каждый день жрешь?",
    "братка го я тебе бекап позову", 
	"толстяк даже пройти спокойно не может",
	"улетел пидорас by ev0lve.xyz ",
	"все хуево братка, прикупи конфиг санчеза или виртуала хз ",
	"изи " ,
	"АХАХА ПОШЕЛ НАХУЙ ",
	"Иди посмотри nolove там ты научишься играть хотя бы долбоёб ебаный " ,
	"улетел в казахстан " ,
	" боже тебе не надоело быть мёртвым?? ",
	"owned by ХВХ ПОДМЫШКИ ",
    }
})

table.insert(kill_say.phrases, {
    name = "portuguese killsay (◣_◢)",
    phrases = {
    "ᴠᴏᴄᴇ ᴇ ᴘᴏʙʀᴇ. ɴᴀᴏ ꜱᴇ ʀᴇꜰɪʀᴀ ᴀ ᴍɪᴍ",
    "hdf é how de fuck em ingles  ?",
    "obrigado irmao continua com o bom serviço",
    "to colocando a mao no rego e muito gostoso",
    "pessoas bem sucedidas perdem tempo lendo livros assim como eu, nao tenho tempo para me informar sobre drogas",
    "me bostejei mim bostei",
    "ta duro dorme",
    "bachar memoria virtual ram funcionando 2022",
    "vão se foderem todos",
    "s2s2 coraçaozinho",
    "a firma é fortanecida fortalemente",
    "FILHO DA PUTA, VOU COMER SEU CU. ARROMBADO DO CARALHO",
    "mãe do ofendido trabalha pra cacete",
    "Gozei no meu Dreamcast é história ou copy pasta?",
    "quando eu falo kuzão, é kuzão mesmo",
    "lol e Dota fazem parte do gênero ASSFAGGOTS ou Aeon of Strife Styled Fortress Assault Game Going On Two Sides",
    "SaradaodoRJ: Oi minha gata, estou aqui para satisfazê-la.",
    "O MULEKE filha da mae!!! OLHA POR ONDE ANDA CARALEO!!!",
    "E QQ VC TÁ FAZENDO COM ESSA CUECA NA CABEÇA SEU RETARDADO??",
    "Nossa! q membro viril e maleavel! e como gira com desenvoltura e harmonia! ME POSSUA AGORA!!!",
    "Filósofo Pirocón",
    "sua posiçao esta tornando facil te matar e prejudicando o seu disparo",
	"EU VOU FODER SUA FAMÍLIA GAY MOTHERFUCKERS",
    }
})

table.insert(kill_say.phrases, {
    name = "german killsay (◣_◢)",
    phrases = {
	"AHAHAHA wie traurig.",
	"Heil Hitler du Hurensohn.",
	"1 du Bastard.",
	"Für das Deutsche Reich.",
	'Ich ficke deine Mutter du Hurensohn.',
	'1 du Fotze.',
	'1 du fettes Kind.',
	'Drecks Jude.',
	'Mit einer Deutschen Schutzweste wäre das nicht passiert.',
	'Deine Familie starb in Auschwitz.',
    '卐1tap卐',
    '卐 aufs maul du hurensohn 卐',
	'Verrecht scheiß Juden.',
	'1 du Hurensohn.',
	'1 du Jude.',
	'Wie oft soll ich dich noch töten bis du Rage Quitest?.',
	'AHAHAHAHAHHAHA 1.',
	'AHAHAHAHAHHAHA 1 du Hurensohn.',
	'AHAHAH verreck scheiß Ausländer.',
	'Untermenschen gehören vergast.',
	'Habe grade den übelsten Lachkick dank deiner Existenz.',
	'Mensch, ich bin besser als du',
	'Du bist so hässlich, dass man bei deiner Geburt ein dunkles Glas auf den Inkubator gestellt hat.',
	'Wer hat gefragt, was du willst? Du bist gestorben.',
	'Besser PC kaufen, aufhören in der Schulbibliothek zu spielen.',
	'Ich lüge nicht, es war zu einfach, dich zu töten.',
    }
})

table.insert(kill_say.phrases, {
    name = "romanian killsay (◣_◢)",
    phrases = {
	'mama ta a sărit pe fereastră când a aflat că te joci.',
	'ți-au tăiat mâinile??',
	'I-a picat fața.',
	'Face din rahat bici.',
	'A dat cu mucii-n fasole.',
	'La mama naibii.',
	'Bag pula-n gatu tau!',
	'Bagami-as pula in mata.',
	'Cacamas in gura ta.',
	'Dute-n pula mea.',
	'futu-ţi morţii mă-tii.',
	'Tiganu dracului!',
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