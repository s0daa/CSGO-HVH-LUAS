-- Downloaded from https://github.com/s0daa/CSGO-HVH-LUAS

local userid_to_entindex = client.userid_to_entindex
local get_player_name = entity.get_player_name
local get_local_player = entity.get_local_player
local is_enemy = entity.is_enemy
local console_cmd = client.exec
local ui_get = ui.get
local trashtalk = ui.new_checkbox("MISC", "Settings", "Killsay")

local baimtable = {
	'ｉ ｈｓ ｓｉｎｃｅ ｍｙ ｍｏｔｈｅｒ ｂｏｒｎｅｄ ｍｅ',
	'i live and laugh knowing u die.',
	'my spotlight is bigger then united states of 𝒦𝒪𝒮𝒪𝒱𝒪 𝑅𝐸𝒫𝒰𝐵𝐿𝐼𝒞',
	'I AM LEGEND TO MY FAMILY',
	'tommorow lighton will suffer his last blow after gsense ban',
	'𝗲𝗻𝗷𝗼𝘆 𝗱𝗶𝗲 𝘁𝗼 𝗚 𝗟𝗢𝗦𝗦 𝗟𝗨𝗔',
	'𝕥𝕙𝕚𝕤 𝕠𝕟𝕖 𝕚𝕤 𝕗𝕠𝕣 𝕞𝕪 𝕄𝕌𝕄𝕄ℤ𝕐 𝕖𝕟𝕛𝕠𝕪 𝕕𝕚𝕖',
	'𝓽𝓱𝓲𝓼 𝔀𝓮𝓪𝓴 𝓭𝓸𝓰 "VAX" 𝓌𝒶𝓈 𝒹𝑒𝓅𝑜𝓇𝓉𝑒𝒹 𝓉𝑜 ""𝒦𝐿𝒜𝒟𝒪𝒱𝒪""',
	'after killing "ReDD" 𝕚 𝕘𝕠𝕥 𝕡𝕣𝕖𝕤𝕚𝕕𝕖𝕟𝕥 𝕠𝕗 𝕒𝕔𝕖𝕥𝕠𝕝',
	'by funny color player',
    'you think you are 𝔰𝔦𝔤𝔪𝔞 𝔭𝔯𝔢𝔡𝔦𝔠𝔱𝔦𝔬𝔫 but no.',
    'neverlose will always use as long father esotartliko has my back.',
    'after winning 1vALL i went on vacation to 𝒢𝒜𝐵𝐸𝒩 𝐻𝒪𝒰𝒮𝐸',
    'i superior resolver(selling shoppy.gg/@KURAC))',
    'ＹＯＵ ＨＡＤ ＦＵＮ ＬＡＵＧＨＩＮＧ ＵＮＴＩＬ ＮＯＷ',
    'once this game started 𝔂𝓸𝓾 𝓵𝓸𝓼𝓮𝓭 𝓪𝓵𝓻𝓮𝓭𝔂',
    'WOMANBOSS VS 𝙀𝙑𝙀𝙍𝙔𝙊𝙉𝙀(𝙌𝙏𝙍𝙐𝙀,𝙍𝙊𝙊𝙏,𝙍𝘼𝙕𝙊,𝙍𝙀𝘿𝘿,𝙍𝙓𝙕𝙀𝙔,𝘽𝙀𝘼𝙕𝙏,𝙎𝙄𝙂𝙈𝘼,𝙂𝙍𝙄𝙈𝙕𝙒𝘼𝙍𝙀)',
	'𝕖𝕤𝕠𝕥𝕒𝕣𝕥𝕝𝕚𝕜 𝔸𝕃 ℙ𝕌𝕋𝕆 𝕊𝕌𝔼𝕃𝕆!',
	'𝘨𝘢𝘮𝘦𝘴𝘯𝘴𝘦 𝘪𝘴 𝘥𝘪𝘦 𝘵𝘰 𝘶.',
	'𝙨𝙬𝙖𝙢𝙥𝙢𝙤𝙣𝙨𝙩𝙚𝙧 𝙤𝙛 𝙢𝙚 𝙞𝙨 𝙘𝙤𝙢𝙚 𝙤𝙪𝙩',
	'weak gay femboy "cho" is depression after lose https://gamesense.pub/forums/viewtopic.php?id=35658',
	'after ban from galaxy i go on all servers to 𝓂𝒶𝓀𝑒 𝑒𝓋𝑒𝓇𝓎𝑜𝓃𝑒 𝓅𝒶𝓎 𝒻𝑜𝓇 𝒷𝒶𝓃 𝑜𝒻 𝓂𝑒',
	'𝚠𝚎𝚊𝚔 𝚍𝚘𝚐(𝚖𝚋𝚢 𝚋𝚕𝚊𝚌𝚔) 𝚐𝚘 𝚑𝚎𝚕𝚕 𝚊𝚏𝚝𝚎𝚛 𝚔𝚒𝚕𝚕',
	'𝔻𝕠𝕟’𝕥 𝕡𝕝𝕒𝕪 𝕓𝕒𝕟𝕜 𝕧𝕤 𝕞𝕖, 𝕚𝕞 𝕝𝕚𝕧𝕖 𝕥𝕙𝕖𝕣𝕖.',
	'𝙙𝙖𝙮 666 𝙃𝙑𝙃𝙔𝘼𝙒 𝙨𝙩𝙞𝙡𝙡 𝙣𝙤 𝙧𝙞𝙫𝙖𝙡𝙨',
	'𝕌 ℂ𝔸ℕ 𝔹𝕌𝕐 𝔸 ℕ𝔼𝕎 𝔸ℂℂ𝕆𝕌ℕ𝕋 𝔹𝕌𝕋 𝕌 ℂ𝔸ℕ𝕋 𝔹𝕌𝕐 𝔸 𝕎𝕀ℕ',
	'my config better than your',
	'1 STFU NN WHO.RU $$$ UFF YA UID?',
	'𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣 𝕁ℤ 𝕤𝕠𝕠𝕟.',
	'𝕀 𝔸𝕄 𝕃𝔸𝕍𝔸 𝕐𝕆𝕌 𝔸ℝ𝔼 𝔽ℝ𝕆𝔾',
	'game vs you is free win',
	'𝙖𝙛𝙩𝙚𝙧 𝙠𝙞𝙡𝙡𝙞𝙣𝙜 𝙜𝙧𝙞𝙢𝙯𝙬𝙖𝙧𝙚 𝙞 𝙘𝙡𝙖𝙞𝙢𝙚𝙙 𝙢𝙮 𝙥𝙡𝙖𝙘𝙚 𝙖𝙨 𝙋𝙍𝙀𝙕𝙄𝘿𝙀𝙉𝙏 𝙊𝙁 𝘾𝙍𝙊𝘼𝙏𝙄𝘼',
	'𝘴𝘩𝘰𝘱𝘱𝘺.𝘨𝘨/@𝘢𝘧𝘳𝘪𝘤𝘬𝘢𝘴𝘭𝘫𝘪𝘷𝘢 𝘵𝘰 𝘪𝘯𝘤𝘳𝘦𝘢𝘴𝘦 𝘩𝘷𝘩 𝘱𝘰𝘵𝘦𝘯𝘵𝘪𝘢𝘭',
	'𝔦 𝔰𝔱𝔬𝔭 𝔲 𝔴𝔦𝔱𝔥 𝔱𝔥𝔦𝔰 ℌ$',
	'𝔲 𝔫𝔢𝔢𝔡 𝔱𝔯𝔞𝔫𝔰𝔩𝔞𝔱𝔬𝔯 𝔱𝔬 𝔥𝔦𝔱 𝔪𝔶 𝔞𝔫𝔱𝔦 𝔞𝔦𝔪𝔟𝔬𝔱',
	'𝒻𝒶𝓃𝒸𝒾𝑒𝓈𝓉 𝒽𝓋𝒽 𝓇𝑒𝓈𝑜𝓁𝓋𝑒𝓇 𝒾𝓃 𝒾𝓃𝒹𝓊𝓈𝓉𝓇𝓎 𝑜𝒻 𝓋𝒾𝓉𝓂𝒶',
	'𝕒𝕗𝕥𝕖𝕣 𝕝𝕖𝕒𝕧𝕚𝕟𝕘 𝕣𝕠𝕞𝕒𝕟𝕚𝕒 𝕚 𝕓𝕖𝕔𝟘𝕞𝕖 = 𝕝𝕖𝕘𝕖𝕟𝕕𝕒',
	'gσ∂ вℓєѕѕ υηιтє∂ ѕтαтєѕ σƒ яσмαηι & ѕєявια',
	'ur lua cracked like egg',
	'i am america after doing u like japan in HVH',
	'winning not possibility, sry.',
	'after this ＨＥＡＤＳＨＯＲＴ i become sigma',
	'𝕘𝕠𝕕 𝕘𝕒𝕧𝕖 𝕞𝕖 𝕡𝕠𝕨𝕖𝕣 𝕠𝕗 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣 𝕁𝔸𝕍𝔸𝕊ℂℝ𝕀ℙ𝕋𝔸',
	'ｉ ａｍ ａｍｂａｓｓａｄｏｒ ｏｆ ｇｓｅｎｓｅ',
	'𝓼𝓴𝓮𝓮𝓽 𝓬𝓻𝓪𝓬𝓴 𝓷𝓸 𝔀𝓸𝓻𝓴 𝓪𝓷𝔂𝓶𝓸𝓻𝓮 𝔀𝓱𝓪𝓽 𝓾 𝓾𝓼𝓮 𝓷𝓸𝔀',
	'𝕡𝕠𝕠𝕣 𝕕𝟘𝕘 𝕊ℙ𝔸𝔻𝔼𝔻 𝕟𝕖𝕖𝕕 𝟚𝟘$ 𝕥𝕠 𝕓𝕦𝕪 𝕟𝕖𝕨 𝕒𝕚𝕣 𝕞𝕒𝕥𝕥𝕣𝕖𝕤𝕤.',
	'i am KING go slave for me',
	'Don"t cry, say ᶠᵘᶜᵏ ʸᵒᵘ and smile.',
	'My request for 150 ETH was not filled in. It passed almost 48 hours, I gave them 72...',
    '𝒶𝒻𝓉𝑒𝓇 𝒷𝒶𝓃 𝒻𝓇𝑜𝓂 𝓈𝓀𝑒𝑒𝓉(𝑔𝓈𝑒𝓃𝓈𝑒) 𝒾 𝒷𝒶𝓃 𝓎𝑜𝓊 𝒻𝓇𝑜𝓂 𝒽𝑒𝒶𝓋𝑒𝓃.𝓁𝓊𝒶',
    '𝘨𝘰𝘥 𝘣𝘭𝘦𝘴𝘴𝘦𝘥 𝘨𝘢𝘮𝘦𝘴𝘦𝘯𝘴𝘦 𝘢𝘯𝘥 𝘳𝘦𝘨𝘦𝘭𝘦 𝘰𝘧 𝘸𝘰𝘳𝘭𝘥(𝘮𝘦)',
   	'𝕒𝕗𝕥𝕖𝕣 𝕣𝕖𝕔𝕚𝕖𝕧𝕖 𝕤𝕜𝕖𝕖𝕥𝕓𝕖𝕥𝕒 𝕚 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦',
    'ｅｖｅｎ ｓｉｇｍａ ｃａｎｔ ｔｏｕｃｈ ｍｙ ａｎｔｉ ｒｅｓｏｌｖｅｒ',
    '𝓊 𝑔𝑜 𝓈𝓁𝑒𝑒𝓅 𝓁𝒾𝓀𝑒 𝓎𝑜𝓊𝓇 *𝒟𝐸𝒜𝒟* 𝓂𝑜𝓉𝒽𝑒𝓇𝓈',
   	'𝒾 𝓀𝒾𝓁𝓁𝑒𝒹 𝓊 𝒻𝓇𝑜𝓂 𝓂𝑜𝑜𝓃',
   	'𝕖𝕝𝕖𝕡𝕙𝕒𝕟𝕥 𝕝𝕠𝕠𝕜 𝕒𝕝𝕚𝕜𝕖 "𝕎𝕀𝕊ℍ" 𝕕𝕚𝕖𝕕 𝕥𝕠 𝕞𝕖 𝕤𝕠 𝕨𝕚𝕝𝕝 𝕪𝕠𝕦',
    'ᵍᵒᵒᵈ ᵈᵃʸ ᵗᵒ ʰˢ ⁿᵒⁿᵃᵐᵉˢ.',
    '𝙖𝙛𝙩𝙚𝙧 𝙘𝙖𝙧𝙙𝙞𝙣𝙜 𝙛𝙤𝙤𝙙 𝙛𝙤𝙧 𝙭𝙖𝙉𝙚 𝙞 𝙧𝙚𝙘𝙞𝙚𝙫𝙚𝙙 𝙨𝙠𝙚𝙚𝙩𝙗𝙚𝙩𝙖',
	'𝔫𝔢𝔳𝔢𝔯 𝔱𝔥𝔦𝔫𝔨 𝔶𝔬𝔲𝔯 𝔠𝔬𝔦𝔫𝔟𝔞𝔰𝔢 𝔦𝔰 𝔰𝔞𝔣𝔢',
	'𝓲 𝔀𝓲𝓵𝓵 𝓼𝓲𝓶𝓼𝔀𝓪𝓹 𝔂𝓸𝓾𝓻 𝓯𝓪𝓶𝓲𝓵𝔂',
	'𝕗𝕣𝕖𝕖 𝕙𝕧𝕙 𝕝𝕖𝕤𝕤𝕠𝕟𝕤 𝕪𝕠𝕦𝕥𝕦𝕓𝕖.𝕔𝕠𝕞/𝕊𝕖𝕣𝕓𝕚𝕒𝕟𝔾𝕒𝕞𝕖𝕤𝔹𝕃',
	'(っ◔◡◔)っ ♥ enjoy this H$ and spectate me ♥',
	'𝕚 𝕒𝕞 𝕜𝕝𝕒𝕕𝕠𝕧𝕠 𝕡𝕖𝕖𝕜 (◣_◢)',
	'𝓎𝑜𝓊𝓇 𝒹𝑜𝓍 𝒾𝓈 𝒶𝓁𝓇𝑒𝒶𝒹𝓎 𝓅𝑜𝓈𝓉𝑒𝒹.',
    '𝔦 𝔥$ 𝔞𝔫𝔡 𝔰𝔪𝔦𝔩𝔢',
	'ｙｏｕ ｃｒｙ？',
	'𝙞 𝙚𝙣𝙩𝙚𝙧𝙚𝙙 𝙧𝙪𝙧𝙪𝙧𝙪 𝙨𝙩𝙖𝙩𝙚 𝙤𝙛 𝙢𝙞𝙣𝙙',
    '𝓇𝑒𝓏𝑜𝓁𝓋𝑒𝓇 𝑜𝓃 𝓎𝑜𝓊 = 𝐹𝒪𝑅𝒞𝐸 𝐻$',
	'𝔸𝔽𝕋𝔼ℝ 𝔼𝕊ℂ𝔸ℙ𝕀ℕ𝔾 𝕊𝔼ℂ𝕌ℝ𝕀𝕋𝕐 𝕀 𝕎𝔼ℕ𝕋 𝕆ℕ 𝕂𝕀𝕃𝕃𝕀ℕ𝔾 𝕊ℙℝ𝔼𝔸𝕂 𝕌ℝ 𝕀ℕ 𝕀𝕋',
	'𝘪 𝘩𝘴 𝘺𝘰𝘶. 𝘦𝘷𝘦𝘳𝘺𝘵𝘪𝘮𝘦 𝘫𝘶𝘴𝘵 𝘩𝘴. 𝘣𝘶𝘺 𝘮𝘺 𝘬𝘧𝘨.',
	'cu@gsense/spotlight section of forum by MOGYORO',
	'u die while i talk with prezident of 𝙰𝙵𝙶𝙷𝙰𝙽𝙸𝚂𝚃𝙰𝙽𝙸 making $$$',
	'my coinbase is thicker then the hs i gave u',
	'olympics every 4 years next chance to kill me is in 100',
	'stop talk u *DEAD*',
	'𝒩𝐸𝒱𝐸𝑅 𝒯𝐻𝐼𝒩𝒦 𝒴𝒪𝒰 "yerebko"',
	'𝕟𝕠 𝕤𝕜𝕚𝕝𝕝 𝕟𝕖𝕖𝕕 𝕥𝕠 𝕜𝕚𝕝𝕝 𝕪𝕠𝕦',
	'𝕥𝕙𝕚𝕤 𝕓𝕠𝕥𝕟𝕖𝕥 𝕨𝕚𝕝𝕝 𝕖𝕟𝕕 𝕦 𝕙𝕒𝕣𝕕𝕖𝕣 𝕥𝕙𝕖𝕟 𝕞𝕪 𝕓𝕦𝕝𝕝𝕖𝕥',
	'𝘸𝘰𝘮𝘢𝘯𝘣𝘰$$ 𝘰𝘸𝘯𝘪𝘯𝘨 𝘲𝘶𝘢𝘥𝘳𝘶𝘱𝘭𝘦𝘵 𝘪𝘯𝘥𝘪𝘢𝘯𝘴 𝘢𝘯𝘥 𝘨𝘺𝘱𝘴𝘪𝘴 𝘴𝘪𝘯𝘤𝘦 2001',
	'𝘺𝘰𝘶 𝘫𝘶𝘴𝘵 𝘨𝘰𝘵 𝘵𝘢𝘱𝘱𝘦𝘥 𝘣𝘺 𝘢 𝘴𝘶𝘱𝘦𝘳𝘪𝘰𝘳 𝘱𝘭𝘢𝘺𝘦𝘳, 𝘨𝘰 𝘤𝘰𝘮𝘮𝘪𝘵 𝘩𝘰𝘮𝘪𝘤𝘪𝘥𝘦',
	'𝕪𝕠𝕦 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕞𝕖 𝕠𝕟𝕔𝕖 , 𝕚 𝕒𝕦𝕥𝕠𝕨𝕒𝕝𝕝 𝕪𝕠𝕦 𝕥𝕨𝕚𝕔𝕖 (◣_◢) ',
	'𝓫𝔂 𝔀𝓸𝓶𝓪𝓷𝓫𝓸𝓼𝓼 𝓻𝓮𝓼𝓸𝓵𝓿𝓮𝓻 $',
	'𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘵𝘩𝘦 𝘨𝘰𝘥𝘴, 𝘸𝘰𝘳𝘴𝘩𝘪𝘱 𝘮𝘦',
	'1',
	'𝟙,𝟚,𝟛 𝕚𝕟𝕥𝕠 𝕥𝕙𝕖 𝟜, 𝕨𝕠𝕞𝕒𝕟 𝕞𝕗𝕚𝕟𝕘 𝕓𝕠𝕤𝕤 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕔𝕙𝕣𝕠𝕞𝕖 𝕥𝕠 𝕪𝕒 𝕕𝕠𝕞𝕖',
	'𝔧𝔢𝔴𝔦𝔰𝔥 𝔱𝔢𝔯𝔪𝔦𝔫𝔞𝔱𝔬𝔯',
	'𝕐𝕠𝕦 𝕜𝕚𝕝𝕝 𝕞𝕖 𝕀 𝕖𝕩𝕥𝕠𝕣𝕥 𝕪𝕠𝕦 𝕗𝕠𝕣 𝟙𝟝𝟘 𝕖𝕥𝕙',
	'𝘢𝘭𝘸𝘢𝘺𝘴 𝘩𝘴, 𝘯𝘦𝘷𝘦𝘳 𝘣𝘢𝘮𝘦.',
	'𝘒𝘪𝘉𝘪𝘛 𝘷𝘚 𝘰𝘊𝘪𝘖 (𝘨𝘖𝘖𝘥𝘌𝘭𝘌𝘴𝘴 𝘥0𝘨) 𝘰𝘞𝘯𝘌𝘥 𝘐𝘯 3𝘹3',
	'𝕪𝕠𝕦𝕣 𝕒𝕟𝕥𝕚𝕒𝕚𝕞 𝕤𝕠𝕝𝕧𝕖𝕕 𝕝𝕚𝕜𝕖 𝕒𝕝𝕘𝕖𝕓𝕣𝕒 𝕖𝕢𝕦𝕒𝕥𝕚𝕠𝕟',
	'ｗｅａｋ ｂｏｔ ｍａｌｖａ ａｌｗａｙｓ ｄｏｇ',
	'𝙥𝙧𝙞𝙫𝙖𝙩𝙚 𝙞𝙙𝙚𝙖𝙡 𝙩𝙞𝙘𝙠 𝙩𝙚𝙘𝙝𝙣𝙤𝙡𝙤𝙜𝙞𝙚𝙨 ◣_◢',
	'𝕓𝕖𝕤𝕥 𝕤𝕖𝕣𝕓𝕚𝕒𝕟 𝕝𝕠𝕘 𝕞𝕖𝕥𝕙𝕠𝕕𝕤 𝕥𝕒𝕡 𝕚𝕟',
	'UHQ DoorDash logs tap in!',
	'cheap mcdonald giftcard method ◣_◢ selly.gg/mcsauce',
	'womanboss>all',
	'𝕨𝕙𝕒𝕥 𝕚𝕤 𝕒 𝕘𝕚𝕣𝕝 𝕥𝕠 𝕒 𝕨𝕠𝕞𝕒𝕟?',
	'drain balls for superior womanboss.technology invite',
	'𝚒𝚏 𝚢𝚘𝚞 𝚠𝚊𝚗t 𝚜𝚎𝚎 𝚖𝚢 𝚌𝚊𝚝 𝚢𝚘𝚞  𝚔𝚒𝚕𝚕 𝚖𝚎',
	'ミ💖 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 𝔫ᎥĞĞєⓡ 💖彡',
	'▄︻デ 𝔦 𝔱𝔲𝔯𝔫 𝔶𝔬𝔲 𝔴𝔞𝔱𝔢𝔯 𝔲𝔫𝔡𝔢𝔯 𝔟𝔯𝔦𝔡𝔤𝔢 ══━一',
	'died to a womän',
	'get fucked in the ass by serb gods, u can freely commit genocide just like eren yeager did $$$ kukubra simulator inreallif',
	'weak dog attend quandale dingle academic',
	'24 btc`d',
	'天安门广场抗议 黑人使我不舒服 I LOVE VALORATN 天安门广场抗议 黑人使我不舒服 Glory to China long live Xi Jinping',
	'𝟩 𝐼𝓃𝓉𝓇𝑒𝓈𝓉𝒾𝓃𝑔 𝐹𝒶𝒸𝓉𝓈 𝒶𝒷𝑜𝓊𝓉 𝒞𝑜𝓈𝓉𝒶 𝑅𝒾𝒸𝒶',
	'Black nigga balls HD',
	'when round is end i kill ghost.',
	'i swim entire mediterranean sea and atlantic ocean to 1 weak NA dogs',
	'🅆🄷🅈 🄳🄾 🅈🄾🅄 🅂🄾 🅂🄷🄸🅃.',
	'sowwy >_<',
	'Approved feminist  ◣_◢',
	'ХАХАХАХАХХАХА НИЩИЙ УЛЕТЕЛ (◣_◢)',
	'so i recive KILLSEY BOOST SYSTEM and now it"S dead all',
	'𝑴𝒚 𝒈𝒊𝒓𝒍𝒇𝒓𝒊𝒆𝒏𝒅𝒔 𝒂𝒏𝒅 𝑰 𝒋𝒖𝒔𝒕 𝒘𝒂𝒏𝒕𝒆𝒅 𝒕𝒐 𝒉𝒂𝒗𝒆 𝒂 𝒈𝒊𝒓𝒍𝒔 𝒏𝒊𝒈𝒉𝒕 𝒐𝒖𝒕 𝒃𝒖𝒕 𝒊𝒕 𝒕𝒖𝒓𝒏𝒆𝒅 𝒊𝒏𝒕𝒐 𝒎𝒆 𝒈𝒆𝒕𝒕𝒊𝒏𝒈 FREE HELL TIKET',
	'𝕀𝕋 𝕎𝔸𝕊 𝔸 𝕄𝕀𝕊𝕋𝔸𝕂𝔼 𝕋𝕆 𝔹𝔸ℕ ℙ𝔼𝕋ℝ𝔼ℕ𝕂𝕆 𝕋ℍ𝔼 ℂ𝔸𝕋 𝔽ℝ𝕆𝕄 𝔹ℝ𝔸ℤ𝕀𝕃 ℕ𝕆𝕎 𝔼𝕊𝕆𝕋𝕀𝕃𝔸ℝℂ𝕆 𝕊ℍ𝔸𝕃𝕃 ℙ𝔸𝕐',
	'𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝘾𝙤𝙣𝙛𝙞𝙧𝙢 𝙩𝙧𝙖𝙣𝙨𝙛𝙚𝙧 𝙧𝙚𝙦𝙪𝙚𝙨𝙩. 𝘾𝙤𝙞𝙣𝙗𝙖𝙨𝙚: 𝙔𝙤𝙪 𝙨𝙚𝙣𝙩 10.244 𝙀𝙏𝙃 𝙩𝙤 𝙬𝙤𝙢𝙖𝙣𝙗𝙤𝙨𝙨.𝙚𝙩𝙝',
	'ᴊᴀʀᴠɪs: ɴɴ ᴅᴏɢ ᴛᴀᴘᴘᴇᴅ sɪʀ',
	'𝙜𝙖𝙢𝙚𝙨𝙚𝙣𝙨𝙚.𝙥𝙪𝙗 𝙚𝙧𝙧𝙤𝙧 404 𝙙𝙪𝙚 𝙩𝙤  𝕔𝕝𝕠𝕦𝕕𝕗𝕝𝕒𝕣𝕖 𝕓𝕪𝕡𝕒𝕤𝕤𝕖𝕤 ◣_◢',
	'game-sense is a reaaly good against nevelooss and some other',
	'the server shivers when the when 𝐰𝐨𝐦𝐚𝐧𝐛𝐨𝐬𝐬 𝐭𝐞𝐚𝐦 connect..',
	'𝕟𝕠 𝕞𝕒𝕥𝕔𝕙 𝕗𝕠𝕣 𝕜𝕦𝕣𝕒𝕔 𝕣𝕖𝕤𝕠𝕝𝕧𝕖𝕣',
	'𝕋𝕙𝕚𝕤 𝕕𝕠𝕘 𝕤𝕠𝕗𝕚 𝕥𝕙𝕚𝕟𝕜 𝕙𝕖 𝕙𝕒𝕤 𝕓𝕖𝕤𝕥 𝕙𝕒𝕔𝕜 𝕓𝕦𝕥 𝕙𝕖 𝕙𝕒𝕤𝕟”𝕥 𝕓𝕖𝕖𝕟 𝕥𝕠 𝕞𝕒𝕝𝕕𝕚𝕧𝕖𝕤 𝕌𝕊𝔸 𝕖𝕤𝕠𝕥𝕒𝕝𝕜𝕚𝕜',
	'𝕚𝕞 𝕒𝕝𝕨𝕒𝕪𝕤 𝟙𝕧𝕤𝟛𝟠 𝕤𝕥𝕒𝕔𝕜 𝕘𝕠𝕠𝕕𝕝𝕖𝕤𝕤 𝕓𝕦𝕥 𝕥𝕙𝕖𝕪 𝕚𝕥𝕤 𝕟𝕠𝕥 𝕨𝕚𝕟 𝕧𝕤 𝕄𝔼',
	'𝕚𝕞 +𝕨 𝕚𝕟𝕥𝕠 𝕪𝕠𝕦 𝕨𝕙𝕖𝕟 𝕚 𝕨𝕒𝕤 𝕣𝕖𝕔𝕚𝕧𝕖𝕕 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕗𝕣𝕠𝕞 𝕖𝕤𝕠𝕥𝕒𝕝𝕚𝕜',
	'𝕘𝕠𝕕 𝕟𝕚𝕘𝕙𝕥 - 𝕗𝕣𝕠𝕞 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕫.𝕦𝕫𝕓𝕖𝕜𝕚𝕤𝕥𝕒𝕟',
	'𝘶𝘯𝘧𝘰𝘳𝘵𝘶𝘯𝘢𝘵𝘦 𝘮𝘦𝘮𝘣𝘦𝘳 𝘬𝘯𝘦𝘦 𝘢𝘨𝘢𝘪𝘯𝘴𝘵 𝘸𝘰𝘮𝘢𝘯𝘣𝘰𝘴𝘴',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕕𝕠𝕟𝕥 𝕘𝕠 𝕗𝕠𝕣 𝕙𝕖𝕒𝕕 𝕒𝕚𝕞 𝕠𝕟𝕝𝕪 𝕚𝕕𝕖𝕒𝕝 𝕥𝕚𝕜 𝕥𝕖𝕔𝕟𝕠𝕝𝕠𝕛𝕚𝕤 ◣_◢',
	'+𝕨 𝕨𝕚𝕥𝕙 𝕚𝕞𝕡𝕝𝕖𝕞𝕖𝕟𝕥 𝕠𝕗 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤.𝕤𝕖𝕣𝕓𝕚𝕒',
	'𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕪𝕝𝕪 𝕪𝕠𝕦 𝕚𝕥𝕤 𝕣𝕖𝕔𝕚𝕧𝕖 𝔽𝕣𝕖𝕖 𝕙𝕖𝕝𝕝 𝕖𝕩𝕡𝕖𝕕𝕚𝕥𝕚𝕠𝕟',
	'𝚗𝚘 𝚋𝚊𝚖𝚎𝚜 𝚠𝚒𝚝𝚑 𝚞𝚜𝚎 𝚘𝚏 𝚔𝚞𝚛𝚊𝚌 𝚛𝚎𝚣𝚘𝚕𝚟𝚎𝚛 𝚝𝚎𝚌𝚑𝚗𝚘𝚕𝚘𝚓𝚒𝚎𝚜',
	'ℕ𝕖𝕨 𝕗𝕣𝕖𝕖 +𝕨 𝕥𝕣𝕚𝕔𝕜 𝕔𝕠𝕞𝕚𝕟𝕘 𝕤𝕠𝕠𝕟 𝕚𝕟 𝕤𝕖𝕣𝕓𝕚𝕒 𝕦𝕡𝕕𝕒𝕥𝕖 𝕠𝕗 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖 𝕤𝕖𝕟𝕤𝕖𝕣𝕚𝕟𝕘',
	'𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕘𝕠 𝟙𝕧𝟛𝟞 𝕧𝕤 𝕦𝕟𝕗𝕠𝕣𝕥𝕦𝕟𝕒𝕥𝕖 𝕞𝕖𝕞𝕓𝕖𝕣𝕤… 𝕒𝕝𝕨𝕒𝕪𝕤 𝕚 𝕒𝕞 𝕧𝕚𝕔𝕥𝕠𝕣𝕪  ◣_◢',
	'(っ◔◡◔)っ ♥ fnay”ed ♥',
	'𝕚 𝕒𝕞 𝕚𝕥”𝕤 𝕕𝕠𝕟𝕥 𝕝𝕠𝕤𝕖  ◣_◢',
	'𝕣𝕠𝕞𝕒𝕟𝕪 𝕓𝕖𝕘 𝕞𝕖 𝕗𝕠𝕣 𝕜𝕗𝕘 𝕓𝕦𝕥 𝕚𝕞 𝕤𝕒𝕪 𝟝 𝕡𝕖𝕤𝕠𝕤',
	'𝕚𝕞 𝕔𝕒𝕟 𝕙𝕒𝕔𝕜 𝕗𝕟𝕒𝕪 𝕒𝕟𝕕 𝕡𝕣𝕖𝕕𝕚𝕔𝕥𝕚𝕠𝕟 𝕒𝕝𝕝 𝕟𝕖𝕩𝕥 𝕣𝕠𝕦𝕟𝕕..',
	'𝕡𝕣𝕖𝕞𝕚𝕦𝕞 𝕗𝕚𝕧𝕖 𝕟𝕚𝕘𝕙𝕥𝕤 𝕒𝕥 𝕗𝕣𝕖𝕕𝕕𝕪𝕤 𝕙𝕒𝕔𝕜𝕤 @𝕤𝕙𝕠𝕡𝕡𝕪.𝕘𝕘/𝕥𝕦𝕣𝕜𝕝𝕚𝕗𝕖𝕤𝕥𝕪𝕝𝕖',
	'𝕀𝔾𝔸𝕄𝔼𝕊𝔼ℕ𝕊𝔼 𝔸ℕ𝕋𝕀-𝔸𝕀𝕄 ℍ𝔼𝔸𝔻𝕊ℍ𝕆𝕋 ℙℝ𝔼𝔻𝕀ℂ𝕋+',
	'𝟙𝔸ℕ𝕋𝕀-ℕ𝔼𝕎-𝕋𝔼ℂℍℕ𝕆𝕃𝕆𝔾𝕐 𝕀𝕊 ℙℝ𝔼𝕊𝔼ℕ𝕋𝔼𝔻!',
	'!𝔹𝕐 𝕄𝕌𝕊𝕋𝔸𝔹𝔸ℝ𝔹𝔸𝔸ℝ𝕀𝟙𝟛𝟛𝟟𝟙-',
	'!𝔽ℝ𝔼𝔼 𝕃𝕌𝔸 𝕋𝕆𝕄𝕆ℝℝ𝕆𝕎!',
	'𝕆𝕎ℕ𝔼𝔻 𝔸𝕃𝕃!',
	'развертывать freddy fazbear',
	'𝕓𝕦𝕘𝕤 𝕔𝕒𝕞𝕖 𝕗𝕣𝕠𝕞 𝕤𝕚𝕘𝕞𝕒’𝕤 𝕟𝕠𝕤𝕖 𝕒𝕟𝕕 𝕙𝕚𝕤 𝕖𝕪𝕖𝕤 𝕥𝕦𝕣𝕟𝕖𝕕 𝕓𝕝𝕒𝕔𝕜 ◣_◢',
	'𝕤𝕠 𝕒 𝕨𝕖𝕒𝕜 𝕗𝕣𝕖𝕕𝕕𝕪 𝕗𝕒𝕫𝕓𝕖𝕒𝕣 𝕋𝕋 𝕤𝕠 𝕚 𝕤𝕡𝕖𝕟𝕕 𝟙𝟘 𝕟𝕚𝕘𝕙𝕥”𝕤 𝕨𝕚𝕥𝕙 𝕙𝕚𝕞 𝕞𝕠𝕥𝕙𝕖𝕣',
	'𝕤𝕡𝕖𝕔𝕚𝕒𝕝 𝕞𝕖𝕤𝕤𝕒𝕘𝕖 𝕥𝕠 𝕝𝕚𝕘𝕙𝕥𝕠𝕟 𝕙𝕧𝕙 𝕨𝕖 𝕨𝕚𝕝𝕝 𝕔𝕠𝕞𝕖 𝕥𝕠 𝕦𝕣 𝕙𝕠𝕦𝕤𝕖 𝕒𝕘𝕒𝕚𝕟 𝕒𝕟𝕕 𝕥𝕙𝕚𝕤 𝕥𝕚𝕞𝕖 𝕚𝕥 𝕨𝕚𝕝𝕝 𝕟𝕠𝕥 𝕓𝕖 𝕡𝕖𝕒𝕔𝕖𝕗𝕦𝕝 ◣_◢',
	'𝐞𝐩𝐢𝐜𝐟𝐨𝐧𝐭𝐬.𝐬𝐞𝐫𝐛𝐢𝐚 𝐩𝐫𝐞𝐦𝐢𝐮𝐢𝐦 𝐮𝐬𝐞𝐫',
	'𝕒𝕔𝕔𝕠𝕣𝕕𝕚𝕟𝕘 𝕥𝕠 𝕪𝕠𝕦𝕥𝕦𝕓𝕖 𝕒𝕟𝕒𝕝𝕚𝕥𝕚𝕔𝕤, 𝟟𝟘% 𝕒𝕣𝕖 𝕟𝕠𝕥 𝕤𝕦𝕓𝕤𝕔𝕣𝕚𝕓𝕖𝕤... ◣_◢',
	'FATALITY.WIN Finish Him and Everyone',
	'𝖘𝖔 𝖙𝖍𝖊𝖞 𝖗𝖊𝖆𝖑𝖑𝖞 𝖙𝖍𝖔𝖚𝖌𝖍𝖙 𝖙𝖍𝖊𝖞 𝖈𝖆𝖓 𝖘𝖍𝖔𝖈𝖐 𝖙𝖍𝖊 𝖐𝖎𝖓𝖌, 𝖘𝖔 𝖎 𝖘𝖍𝖔𝖈𝖐𝖊𝖉 𝖙𝖍𝖊𝖎𝖗 𝖎𝖓𝖋𝖆𝖓𝖙 𝖈𝖍𝖎𝖑𝖉𝖘',
	'ℍ𝕖𝕣𝕠𝕓𝕣𝕚𝕟𝕖 𝕞𝕚𝕘𝕙𝕥 𝕓𝕖 𝕔𝕙𝕖𝕒𝕥𝕚𝕟𝕘 𝕚𝕟 ℂ𝕊:𝔾𝕆...',
	'ɪ ᴄᴀʟʟ ᴀʟʟᴀʜ ᴛᴏ ᴘᴀʀᴛ ꜱᴇᴠᴇɴ ꜱᴇᴀꜱ ᴡʜᴇɴ ɪ ᴛʀᴀᴠᴇʟ ᴛᴏ ᴋɪʟʟ ᴡᴇᴀᴋ ɴᴀ ʀᴀᴛꜱ ◣_◢',
	'𝓼𝓸 𝓲 𝓶𝓲𝓰𝓱𝓽 𝓫𝓮 𝓼𝓮𝓵𝓵𝓲𝓷𝓰 𝓷𝓮𝓿𝓮𝓻𝓵𝓸𝓼𝓮 𝓲𝓷𝓿𝓲𝓽𝓪𝓽𝓲𝓸𝓷...',
	'ＴＨＥＲＥ ＩＳ ＮＯ  ＷＡＹ ＴＨＡＴＳ ＬＥＧＩＴ．．．ಠ_ಠ',
	'𝕊𝕠 𝕀 𝕗𝕚𝕟𝕒𝕝𝕝𝕪 𝕙𝕒𝕕 𝕤𝕖𝕩 𝕚𝕟 ℍ𝕦𝕟𝕚𝕖ℙ𝕠𝕡...',
	'𝐚𝐟𝐭𝐞𝐫 𝐟𝐢𝐯𝐞 𝐧𝐢𝐠𝐡𝐭𝐬 𝐟𝐫𝐞𝐝𝐝𝐲 𝐟𝐚𝐳𝐛𝐞𝐚𝐫 𝐠𝐚𝐯𝐞 𝐭𝐡𝐞𝐬𝐞 𝐭𝐞𝐜𝐡𝐧𝐨𝐥𝐨𝐠𝐢𝐜𝐚𝐥  ◣_◢',
	'𝖘𝖔 𝖙𝖍𝖎𝖘 𝖜𝖊𝖆𝖐 𝖗𝖆𝖙 𝖇𝖆𝖓𝖓𝖊𝖉 𝖒𝖎𝖓𝖊 𝖋𝖗𝖎𝖊𝖓𝖉 (𝖓𝖔𝖘𝖙𝖆𝖑𝖌𝖎𝖆) 𝖓𝖔𝖜 𝖎 𝖆𝖗𝖊 𝖚𝖘𝖊𝖉 𝖔𝖋 𝖆𝖓𝖙𝖎-𝖕𝖗𝖎𝖒𝖔𝖗𝖉𝖎𝖆𝖑 𝖙𝖊𝖈𝖍𝖓𝖔𝖑𝖔𝖌𝖎𝖈𝖆𝖑 ◣_◢',
	'𝐒𝐨 𝐈 𝐜𝐚𝐥𝐥𝐞𝐝 𝐭𝐡𝐞 𝐖𝐎𝐌𝐀𝐍𝐁𝐎𝐒𝐒 𝐚𝐭 𝟒𝐚𝐦... 𝐢𝐭 𝐰𝐚𝐬 𝐩𝐫𝐞𝐭𝐭𝐲 𝐬𝐜𝐚𝐫𝐲',
	'𝗞𝗜𝗭𝗔𝗥𝗨 𝗪𝗔𝗡𝗧𝗦 𝗪𝗢𝗠𝗔𝗡𝗕𝗢𝗦𝗦𝗘𝗦 𝗧𝗢 𝗝𝗢𝗜𝗡 𝗚𝗢𝗗𝗘𝗟𝗘𝗦𝗦?! (𝗴𝗼𝗶𝗻𝗴 𝗽𝗿𝗼)',
	'UNDERAGE? CALL ME',
	'ＦＯＯＬ ＭＥ ＯＮＣＥ， ＳＨＡＭＥ ＯＮ ＹＯＵ， ＦＯＯＬ ＭＥ ＴＷＩＣＥ， Ｉ ＴＲＯＬＬ ＹＯＵ．',
	'go buy Nixware for the best hacker facing hacker gone wrong experience.',
	'UFF SilenZIO$$$ U have Ben 1TAPED by PORTUGAL Technology',
	'you"re are poor go bay beter turkish cheat (onetap su) ',
	'Romanian Technology I steal real model and REZOLVE.',
	'ᴡᴀʀɴɪɴɢ: ɢᴏɪɴɢ ᴛᴏ ꜱʟᴇᴇᴘ ᴏɴ ꜱᴜɴᴅᴀʏ ᴡɪʟʟ ᴄᴀᴜꜱᴇ ᴍᴏɴᴅᴀʏ',
	'BICH...dont test gangster in me',
	'ᴡᴀɴɴᴀʙᴇ ᴀᴡᴘ ɢᴏᴅ ᴍᴀx(?) ᴄᴀᴍᴇ ᴛᴏ ꜰᴀᴄᴇ ʀᴇᴀʟ ᴀᴡᴘ ɢᴏᴅ ʀᴀᴢᴏ',
	'𝔾𝔻𝔼 𝕍𝔸𝕄 𝕁𝔼 𝕊𝕌ℕ ℙℝ𝕆𝕋𝔼𝕂𝕊𝕆ℕ?',
	'scrabble bot owned by wordle king',
	'𝕀 ℂ𝔸𝕄𝔼 𝔹𝔸ℂ𝕂 𝕋𝕆 ℝ𝕆𝕄𝔸ℕ𝕀𝔸 𝕋𝕆 𝕄𝕌ℝ𝔻𝔼ℝ 𝕋ℍ𝕀𝕊 𝔻𝕆𝔾 ℂ𝔸𝕃𝕃𝔼𝔻 "ℕ𝕌𝔹𝔹𝔼ℝ𝕊" 𝔸ℕ𝔻 ℍ𝕀𝕊 𝔼𝔹𝔽 "𝕗𝕦𝕤𝕚𝕠𝕟"',
	'ɪ ᴄᴀᴍᴇ ᴛᴏ 10ꜰᴘꜱ ᴛᴏ ᴅᴇꜱᴛʀᴏʏ ɴᴏꜱᴛᴀʟɢɪᴀ"ꜱ ᴅᴏɢɢᴏꜱ',
	'𝕀 𝕔𝕒𝕞𝕖 𝔹𝔸ℂ𝕂 𝕥𝕠 ℝ𝕆 𝕊𝕖𝕣𝕧𝕖𝕣 𝕥𝕠 𝕕𝕖𝕤𝕥𝕣𝕠𝕪 𝔹ℝ𝔸ℕ𝔻𝕆ℕ 𝔸ℕ𝔻 𝕃𝔸𝕌ℝ 𝔼ℂ𝕆𝕌ℙ𝕃𝔼',
	'ᴵ ᶜᵒᵐᵉ ᵇᵃᶜᵏ ᶠʳᵒᵐ ᴮʳᵃˢⁱˡ ᶠᵒʳ ᵖˡᵃʸ ᴴⱽᴴ ᵃⁿᵈ ᵈᵉˢᵗʳᵒʸ ᵈᵒᵍˢ',
	'ROLL VS ME? I KILL YOUR MOTHER FATHER SISTER BROTHER BUTCHER THEM AND ROLL ON THEIR GRAVE',
	'brutality,onlybaim,godeless,nuk3s,maverick it dont matter... all will dye to womanboss',
	'ɪ ʙᴇᴄᴀᴍᴇ ᴘʀɪᴍᴇ ᴍɪɴɪꜱᴛᴇʀ ᴏꜰ ᴄʀᴏᴀᴛɪᴀ ᴛᴏ ꜰʀᴇᴇ ᴍʏ ʙʀᴏᴛʜᴇʀ ɢʀɪᴍᴢ',
	'GIGACHAD FEMALE DETECTED, GAME DODGED GIGACHAD FEMALE DETECTED, GAME DODGED GIGACHAD FEMALE DETECTED, GAME DODGED GIGACHAD FEMALE DETECTED, GAME DODGED',
	'it ain"t gonna suck itself',
	'𝕀 𝕃𝕆𝕍𝔼 $C𝔸R𝔻𝕀N𝔾$ 𝕋H𝕀𝕊 𝕀𝕊 𝕄𝕐 𝕃𝕀𝔽𝔼$𝕋𝕃𝕐𝔼',
	'dont play roll vs me,im miss there',
	'no rare fish no talk',
	'god may forgive you but gamesense resolver won"t (◣_◢)',
	'You Just Got Tapped! #fyp #foryou #viral #fy',
	'𝔻ỖℕŦ 𝕄𝒶Ќ𝑒 𝓶𝓔 şｈㄖω 𝕋Ｈє 𝐦𝕠ⓃＳ𝐓乇𝓻 𝐢𝕟sι𝒹𝔼, เ 𝕊ţ𝐨𝓹 ʷ𝒆𝔞к яᗩ𝐭𝐒 ŴⒾtʰ ❶ʘ１ 𝔪Įᑎ ∂Μ𝕘 ☆',
	'𝕟𝟘 𝕔𝕦𝕣𝕒𝕛 𝕗𝕠𝕣 𝕡𝕝𝔸𝕪 𝕕𝕖_𝕟𝕦𝕜𝕖 𝕧𝕤 𝕄𝔼.. .... 𝕥𝕙𝕒𝕥 𝕚𝕤 𝕞𝕖 𝕙𝕠𝕦𝕤𝕖',
	'ｈａ－ｈａ－ｈａ ｙｏｕ＇ｒｅ ａｒｅ ｐｏｏｒ',
	'𝕟𝟘𝕤𝕥𝕒𝕝𝕘𝕚𝕒 𝕔𝕠𝕞𝕖 𝕓𝕒𝕔𝕜 𝕨𝕚𝕥𝕙 𝕞𝕚𝕝𝕜 𝕓𝕦𝕥 𝕞𝕖 𝕕𝕖𝕔𝕝𝕚𝕟𝕖 𝕠𝕗𝕗𝕖𝕣..',
	'ｗｏｍａｎｂｏｓｓ ｉｓ ｍａｎ？！ ｏｈ ｍｅ ｇｏｄ．．',
	'𝕓𝕒𝕫𝕚𝕔𝕒𝕝𝕝𝕪 𝕞𝕖 𝕚𝕟𝕛𝕖𝕔𝕥𝕖𝕕 𝕘𝕒𝕞𝕖-𝕤𝕖𝕟𝕤 𝕨𝕚𝕥𝕙𝕠𝕦𝕥 𝕍𝔸ℂ 𝔹𝕐ℙ𝔸𝕊𝕊... 𝕞𝕖 𝕘𝕠𝕥 𝕧𝕒𝕔𝕖𝕕 𝕟𝕖𝕩𝕥 𝕥𝕠𝕞𝕠𝕣𝕣𝕠𝕨',
	'𝙒𝙝𝙚𝙣 𝙄"𝙢 𝙥𝙡𝙖𝙮 𝙈𝙈 𝙄"𝙢 𝙥𝙡𝙖𝙮 𝙛𝙤𝙧 𝙬𝙞𝙣, 𝙙𝙤𝙣"𝙩 𝙨𝙘𝙖𝙧𝙚 𝙛𝙤𝙧 𝙨𝙥𝙞𝙣, 𝙞 𝙞𝙣𝙟𝙚𝙘𝙩 𝙧𝙖𝙜𝙚 ♕',
	'ℙ𝕖𝕣𝕤𝕠𝕟𝕒𝕝𝕝𝕪, 𝕞𝕖 𝕨𝕠𝕦𝕝𝕕 𝕤𝕒𝕪 𝕥𝕙𝕚𝕤 𝕔𝕙𝕖𝕒𝕥 𝕒𝕣𝕖 𝕓𝕖𝕥𝕥𝕖𝕣 𝕥𝕙𝕖𝕟 𝕆𝕋ℂ𝕍𝟛, 𝕆𝕊𝕀ℝ𝕀𝕊, ℙ𝕖𝕟𝕚𝕤ℍ𝕌𝔻, 𝕒𝕟𝕕 𝕊𝕆𝕄𝔼 𝕆𝕋ℍ𝔼ℝ.',
	'it"s morbin" time',
	'𝗜𝗜 𝗗𝗔𝗨 𝗠𝗨𝗜𝗘 𝗟𝗨𝗜 𝗢𝗩𝗜𝗗𝗜𝗨',
	'it"s just a game" is such a weak mindset',
	'Keep calm and tap on.',
	'2 lines a day keeps the doctor away',
	'They ain"t believe in us, GOD DID',
	'don"t problem',
	'Headshots speak louder than words',
	'Every tap is a step closer to glory',
	'once you tap you can"t stop',
	'When the tap success, victory follows suit',
	'𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜 𝕚𝕥𝕤 𝕨𝕚𝕟𝕟𝕚𝕟𝕘𝕤 𝕓𝕦𝕥 𝕒𝕨𝕒𝕝𝕝 𝕔𝕠𝕞𝕖 𝕗𝕚𝕣𝕤𝕥',
	'Turning cheats into defeat, one headshot at a time',
	'The way of wins is dont losing',
	'ℕ𝕖𝕧𝕖𝕣 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕨𝕠𝕟 𝕓𝕖𝕔𝕒𝕦𝕤𝕖 𝕪𝕠𝕦 𝕤𝕙𝕠𝕥 𝕗𝕚𝕣𝕤𝕥, 𝕠𝕟𝕤𝕙𝕠𝕥 𝕔𝕠𝕞𝕖𝕤 𝕟𝕖𝕩𝕥.',
	'Baiming win rounds, headshots win hearts',
	'𝚝𝚑𝚎 𝚝𝚊𝚙𝚏𝚎𝚜𝚝 𝚑𝚊𝚜 𝚓𝚞𝚜𝚝 𝚋𝚎𝚐𝚞𝚗, 𝚋𝚎 𝚙𝚛𝚎𝚙𝚊𝚛𝚎𝚍',
	'What is happened on cs2 is remain on cs2 (◣_◢)',
	'𝐒𝐨𝐮𝐟𝐢𝐰 𝐲𝐨𝐮 𝐚𝐫𝐞 𝐚 𝐰𝐞𝐚𝐤 𝐝𝐨𝐠 𝐚𝐧𝐝 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝𝐬 𝐰𝐢𝐥𝐥 𝐛𝐞 𝐤𝐢𝐥𝐥𝐞𝐝',
	'𝕓𝕪 𝕤𝕚𝕘𝕟𝕚𝕟𝕘 𝕒 𝕔𝕠𝕟𝕥𝕒𝕔𝕥 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕕𝕖𝕧𝕚𝕝 𝕪𝕠𝕦 𝕒𝕣𝕖 𝕕𝕠𝕠𝕞𝕖𝕕 𝕥𝕠 𝕕𝕚𝕖',
	'ɪ ʙᴇᴄᴀᴍᴇ ᴛʜᴇ ᴘʀᴇsɪᴅᴇɴᴛ ᴏꜰ ᴛʜᴇ ʀᴜssɪᴀɴ ꜰᴇᴅᴇʀᴀᴛɪᴏɴᴀɴᴅ sɪɢɴᴇᴅ ᴀɴ ᴀɢʀᴇᴇᴍᴇɴᴛ ᴛʜᴀᴛ ᴘᴇᴏᴘʟᴇ ᴄᴀɴ ʙᴇ sʜᴏᴛ ᴅᴏᴡɴ',
	'𝐢 𝐤𝐢𝐥𝐥𝐞𝐝 𝐭𝐡𝐞𝐦 𝐚𝐧𝐝 𝐝𝐨 𝐧𝐨𝐭 𝐫𝐞𝐠𝐫𝐞𝐭 𝐢𝐭',
	'𝔸𝕝𝕝 𝕕𝕠𝕘𝕤 𝕦𝕤𝕖𝕣𝕤 𝟙𝕧𝟛𝟞 𝕨𝕖𝕟𝕥 𝕒𝕘𝕒𝕚𝕟𝕤𝕥 𝕞𝕖 𝕒𝕟𝕕 𝕚 𝕙𝕒𝕕 𝕥𝕠 𝕜𝕚𝕝𝕝 𝕖𝕧𝕖𝕣𝕪𝕠𝕟𝕖 𝕒𝕟𝕕 𝕥𝕙𝕖𝕚𝕣 𝕝𝕠𝕧𝕖𝕕 𝕠𝕟𝕖𝕤',
	'ｗｅａｋ ｄｏｇｓ ａｇａｉｎｓｔ ｔｈｅ ＫＩＮＧ ｉｔ ｃａｍｅ ｔｏ ｍｅ ｔｏ ｅｘｅｃｕｔｅ ｅｖｅｒｙｏｎｅ ｔｈｅｙ ｃｒｉｅｄ ｌｉｋｅ ｇｉｒｌｓ ＨＡＨＡＨ',
	'𝕍𝕝𝕒𝕕𝕚𝕞𝕚𝕣 ℙ𝕦𝕥𝕚𝕟 𝕒𝕨𝕒𝕣𝕕𝕖𝕕 𝕞𝕖 𝕨𝕚𝕥𝕙 𝕥𝕙𝕖 𝕒𝕨𝕒𝕣𝕕 𝕀 𝕒𝕞 𝕟𝕠𝕨 𝕚𝕞𝕡𝕖𝕣𝕒𝕥𝕠𝕣',
	'Ｉ ＷＩＬＬ ＫＩＬＬ ＡＬＬ ＮＥＶＥＲＬＯＳＥ ＵＳＥＲＳ １ ＢＹ １',
	'ᴀʟʟ ɴᴇᴠᴇʀʟᴏꜱᴇ ᴜꜱᴇʀꜱ ᴄʀʏ ᴡʜᴇɴ ɢᴀᴍᴇꜱᴇɴꜱᴇ ɢᴇᴛꜱ ᴜᴘᴅᴀᴛᴇᴅ',
	'𝔸𝕃𝕃 ℂℝ𝔸ℂ𝕂 𝕌𝕊𝔼ℝ𝕊 𝕎𝕀𝕊ℍ 𝔽𝕆ℝ 𝕋ℍ𝔼 ℝ𝔼𝔸𝕃 𝕋ℍ𝕀ℕ𝔾',
	'ＹＯＵ ＷＩＳＨ ＹＯＵ ＨＡＤ ＧＡＭＥＳＥＮＳＥ Ｕ ＨＲＳＮ',
	'₲₳₥Ɇ₴Ɇ₦₴Ɇ 1 ₦ɆVɆⱤ₩ł₦ 0',
	
}
local hstable = baimtable

local deathtable = {
    'you think you win?',
	'im no trying.',
	'lucky monkey.',
	'my teammate bait for you.',
	'𝕒𝕟𝕥𝕚 𝕣𝕖𝕫𝕠𝕝𝕧𝕖𝕣 𝕨𝕒𝕤 𝕠𝕗𝕗.',
	'𝕜𝕚𝕝𝕝 𝕞𝕖 𝕟𝕠𝕨 𝕚 𝕤𝕚𝕞𝕤𝕨𝕒𝕡 𝕪𝕠𝕦 𝕗𝕠𝕣 𝕔𝕠𝕚𝕟𝕓𝕒𝕤𝕖 𝕔𝕠𝕟𝕗𝕚𝕣𝕞𝕒𝕥𝕚𝕠𝕟𝕤',
	'how u live on luck.',
	'bot u will see me next round...',
	'luckbased player enjoy DDO$.',
	'𝐲𝐨𝐮 𝐤𝐢𝐥𝐥 𝐦𝐞 𝐛𝐮𝐭 𝐢 𝐤𝐢𝐥𝐥 𝐲𝐨𝐮𝐫 𝐬𝐢𝐦 𝐜𝐚𝐫𝐝',
	'𝕪𝕠𝕦 𝕜𝕚𝕝𝕝𝕖𝕕 𝕞𝕖 𝕓𝕦𝕥 𝕪𝕠𝕦𝕣 𝕗𝕒𝕞𝕚𝕝𝕪 𝕨𝕚𝕝𝕝 𝕓𝕖 𝕜𝕚𝕝𝕝𝕖𝕕 𝕤𝕠𝕠𝕟',
	'GO 5ᐯ5 YOᑌ ᔕTᑌᑭIᗪ ᗪOG ᒪITTᒪE GIᖇᒪ ᗩᕼᗩᕼᗩᗩᕼ',
	'𝕐𝕆𝕌 𝔸ℝ𝔼 𝕊𝕆 𝕃𝕌ℂ𝕂𝕐 𝕊ℍ𝕀𝕋 ℕℕ',
	'ℕ𝔼𝕏𝕋 ℙ𝕃𝔸ℕ𝔼 ℂℝ𝔸𝕊ℍ 𝕀ℕ𝕋𝕆 𝕐𝕆𝕌ℝ ℍ𝕆𝕌𝕊𝔼 𝕃𝕀𝕂𝔼 𝕌𝕂ℝ𝔸𝕀ℕ𝔼 𝔹𝕆𝕄𝔹',
	'𝔦𝔣 𝔶𝔬𝔲 𝔢𝔳𝔢𝔯 𝔰𝔢𝔢 𝔪𝔢 𝔬𝔫 𝔠𝔬𝔪𝔪𝔲𝔫𝔦𝔱𝔶 𝔰𝔢𝔯𝔳𝔢𝔯𝔰 𝔞𝔤𝔞𝔦𝔫 𝔶𝔬𝔲 𝔰𝔥𝔬𝔲𝔩𝔡 𝔯𝔲𝔫',
	'𝕚 𝕔𝕙𝕒𝕝𝕝𝕖𝕟𝕘𝕖 𝕐𝕆𝕌 𝕥𝕠 𝕒 𝕘𝕒𝕞𝕖 𝕠𝕗 𝟙𝕧𝟙',
	'𝕥𝕙𝕚𝕤 𝕥𝕚𝕞𝕖 𝕝𝕦𝕔𝕜 𝕟𝕖𝕩𝕥 𝕥𝕚𝕞𝕖 𝕙𝕖𝕒𝕕𝕤𝕙𝕠𝕣𝕥 𝕘𝕖𝕥 𝕗𝕦𝕔𝕜𝕖𝕕',
	'𝕪𝕠𝕦 𝕞𝕚𝕘𝕙𝕥 𝕙𝕒𝕧𝕖 𝕕𝕖𝕗𝕖𝕟𝕤𝕚𝕧𝕖 𝕒𝕒 𝕓𝕦𝕥 𝕪𝕠𝕦 𝕔𝕒𝕟"𝕥 𝕕𝕖𝕗𝕖𝕟𝕕 𝕗𝕣𝕠𝕞 𝕓𝕦𝕝𝕝𝕖𝕥𝕤 𝕚𝕣𝕝',
	'𝔹𝔸𝔻 𝕀ℕ𝕁𝔼ℂ𝕋 𝔻𝕆𝔾 𝔾𝕆 𝕀ℕ𝕁𝔼ℂ𝕋 𝔼𝕊𝕋ℝ𝕆𝔾𝔼ℕ 𝕋ℝ𝔸ℕ𝕊',
	'𝔻𝕆ℕ"𝕋 𝕄𝔼 ℝ𝔼𝕀ℕ𝕁𝔼ℂ𝕋 𝕐𝕆𝕌 𝕊ℍ𝕀𝕋 ℙ𝔸𝕊𝕋𝔼ℝ',
	'𝓘𝓕 𝓜𝓔 𝓓𝓘𝓔 𝓘 𝓒𝓞𝓜𝓔 𝓣𝓞 𝓨𝓞𝓤 𝓗𝓞𝓤𝓢𝓔 ',
	'𝔻𝕆ℕ"𝕋 𝕄𝔸𝕂𝔼 𝕃𝕆𝔸𝔻 𝔼ℕ𝔻𝔼ℝℍ𝕍ℍ ℂ𝕆ℕ𝔽𝕀𝔾',
	'ℕ𝔼𝕏𝕋 ℝ𝕆𝕌ℕ𝔻 𝕀𝕊 𝕂𝔸ℤ𝔸𝕂ℍ𝕊𝕋𝔸ℕ 𝔽𝕆ℝ 𝔻𝕆𝔾(𝕐𝕆𝕌)',
	'𝔸𝔽𝕋𝔼ℝ 𝕀 𝕄𝕀𝕊𝕊𝔼𝔻 𝕐𝕆𝕌 𝟙𝟘 𝕋𝕀𝕄𝔼𝕊 𝕀 𝕌ℕ𝕃𝕆𝔸𝔻𝔼𝔻 ℍ𝔸ℂ𝕂',
	'𝕐𝕆𝕌 𝕎𝕀𝕃𝕃 ℕ𝔼𝕍𝔼ℝ 𝕂𝕀𝕃𝕃 𝕄𝔼 𝔸𝔾𝔸𝕀ℕ 𝕐𝕆𝕌 𝕊𝕂𝔼𝔼𝕋𝕃𝔼𝕊𝕊 𝕄𝕆ℕ𝕂𝔼𝕐' ,
	'𝔻𝕆ℕ𝕋 𝕊𝔸𝕐 𝕐𝕆𝕌 𝕊𝕂𝔼𝔼𝕋 𝕎ℍ𝔼ℕ 𝕐𝕆𝕌 𝕀𝕊 𝕏(𝕋𝕎𝕀𝕋𝕋𝔼ℝ ℝ𝔼ℕ𝔸𝕄𝔼) 𝕁𝕆𝕀ℕ𝔼ℝ',
	'𝔻𝕆ℕ"𝕋 𝕋ℍ𝕀ℕ𝕂 𝕐𝕆𝕌 𝔸ℝ𝔼 𝕆𝔾 𝕀𝔽 𝕐𝕆𝕌 𝔸ℝ𝔼 𝟙𝟛.𝟝𝕂 𝕌𝕀𝔻',
	'ＤＯＲＭＡＮＴ ＭＩＳＳ ＰＩＬＯＴ ＣＲＡＳＨ ＨＩＳ ＰＬＡＮＥ',
	'https://gamesense.pub/forums/login.php?action=out',
	'𝕀𝔽 𝕐𝕆𝕌 𝕂𝕀𝕃𝕃  𝔸𝔾𝔸𝕀ℕ 𝕀 𝕎𝕀𝕃𝕃 𝔽𝕀ℕ𝔻 𝕐𝕆𝕌 𝔸ℕ𝔻 ℍ𝔼𝔸𝔻𝕊ℍ𝕆𝕋 𝕐𝕆𝕌 𝔽𝔸𝕄𝕀𝕃𝕐',
	'ℂ𝕆𝕄𝔼𝔹𝔸ℂ𝕂 𝕀𝕊 𝕆ℕ ℂ𝕊𝟚 𝔹𝕐 𝔼𝕊𝕆𝕋𝔸𝕃ℝ𝔸𝕋𝕃𝕂𝕀𝔼𝕋',
	
}


local function get_table_length(data)
  if type(data) ~= 'table' then
    return 0
  end
  local count = 0
  for _ in pairs(data) do
    count = count + 1
  end
  return count
end

local num_quotes_baim = get_table_length(baimtable)
local num_quotes_hs = get_table_length(hstable)
local num_quotes_death = get_table_length(deathtable)

local function on_player_death(e)
	if not ui_get(trashtalk) then
		return
	end
	local victim_userid, attacker_userid = e.userid, e.attacker
	if victim_userid == nil or attacker_userid == nil then
		return
	end

	local victim_entindex   = userid_to_entindex(victim_userid)
	local attacker_entindex = userid_to_entindex(attacker_userid)
	if attacker_entindex == get_local_player() and is_enemy(victim_entindex) then
		if e.headshot then
			    local commandhs = 'say ' .. hstable[math.random(num_quotes_hs)]
                console_cmd(commandhs)
		else
			    local commandbaim = 'say ' .. baimtable[math.random(num_quotes_baim)]
                console_cmd(commandbaim)
		end
	end
	if victim_entindex == get_local_player() and attacker_entindex ~= get_local_player() then
          local commandbaim = 'say ' .. deathtable[math.random(num_quotes_death)]
          console_cmd(commandbaim)
	elseif victim_entindex == get_local_player() and attacker_entindex == get_local_player() then
			console_cmd("say I had to die to make it fair.")
	end
end

client.set_event_callback("player_death", on_player_death)