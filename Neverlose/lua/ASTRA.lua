local var_0_0 = require("neverlose/gradient")
local var_0_1 = require("neverlose/base64")
local var_0_2 = require("neverlose/clipboard")
local var_0_3 = require("neverlose/pui")
local var_0_4 = require("neverlose/get_defensive")
local var_0_5 = render.screen_size()
local var_0_6 = require("neverlose/smoothy")
local var_0_7 = require("neverlose/md5")
local var_0_8 = {}
local var_0_9 = var_0_6.new(anim_tbl)
local var_0_10 = require("neverlose/easing")
local var_0_11 = require("neverlose/drag_system")
local var_0_12 = 0
local var_0_13 = 1 - var_0_12
local var_0_14 = 1

alphadouble = 0
hsalpha = 0
dmgalpha = 0
firstvalue = 0
hidden = 0
hitted = 0
missed = 0

local var_0_15 = "5qCNIoce4PoD58tLYpmg8SvMUujkBnmM"
local var_0_16 = "http://cloudpusy.ct8.pl/cloud/api"
local var_0_17 = ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):get()
local var_0_18 = {
	color = "FFFFFFFF",
	build = "Stable",
	username = common.get_username()
}

local function var_0_19(arg_1_0)
	local var_1_0 = "iRP4IfuaqpK6astrapro"
	local var_1_1 = string.format("%s%s%s", var_0_18.username, var_0_18.build, var_1_0)

	return var_0_7.sumhexa(var_1_1)
end

function lerp(arg_2_0, arg_2_1, arg_2_2)
	return arg_2_1 * (1 - arg_2_0) + arg_2_2 * arg_2_0
end

local var_0_20 = ui.get_style("Button"):to_hex()

local function var_0_21(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, ...)
	local var_3_0 = table.concat({
		...
	})

	if var_0_8[arg_3_0] == nil then
		var_0_8[arg_3_0] = 0
		var_0_9 = var_0_6.new(var_0_8)
	end

	local var_3_1 = var_0_9(0.1, {
		[arg_3_0] = render.measure_text(arg_3_2, nil, ...)
	})[arg_3_0]
	local var_3_2 = render.measure_text(arg_3_2, nil, ...)

	render.text(arg_3_2, vector(arg_3_1.x - var_3_1.x / 2, arg_3_1.y - var_3_1.y / 2), arg_3_3, arg_3_4, ...)
end

local var_0_22 = {}
local var_0_23 = {
	defensive_ready = false,
	ticks = 0,
	slowdown_ind = false
}
local var_0_24 = 0
local var_0_25 = 0

function var_0_22.sim_diff(arg_4_0)
	local var_4_0 = 3

	var_0_24, var_0_25 = var_4_0 - var_0_25, var_4_0

	return var_0_24
end

drawthisshit = "no"
to_up = "no"
drawthisshit_ticks = 0

function simulation_ticks()
	if var_0_22.sim_diff() <= -1 then
		drawthisshit = "yes"
		to_up = "yes"
	end
end

local var_0_26 = {
	"you got baimed by the best hvher",
	"Why is Zadey here?",
	"oof",
	"lol 1",
	"Is this mm or hvh?",
	"You got tapped bitch",
	"Poof, youre dead",
	"Owned Bitch",
	"Maybe you should refund...",
	"L",
	"gtfo",
	"sit dog",
	"nice try, maybe next time",
	"u mad",
	"u really mad",
	"raging in 2k18?",
	"pu$$y pwnd",
	"nice body",
	"1 on my screen",
	"Get Good. Get IQ",
	"THATS A BIG 1 TAP",
	"Missed shot to spread? nah just a shit hek",
	"1",
	"𝕀´𝕄 𝕛𝕠𝕚𝕟 𝕤𝕖𝕣𝕧𝕖𝕣, 𝕤𝕖𝕒𝕣𝕔𝕙 𝕖𝕟𝕖𝕞𝕪, 𝕖𝕞𝕡𝕥𝕪. ♛",
	"(◣_◢) 𝚖𝚘𝚝𝚑𝚎𝚛 𝚜𝚊𝚢𝚎𝚍, 𝚗𝚘 𝚑𝚟𝚑 𝚒𝚗 𝚍𝚊𝚢 - 𝙼𝙴 𝙺𝙸𝙻𝙻𝙴𝚁 (◣_◢)",
	"ｙｏｕ´ｒｅ ｔｈｉｎｋｅｄ ｗｒｏｎｇ. ?",
	"𝕚´𝕞 5𝕧5 𝕨𝕚𝕟, 𝕟𝕠𝕨 𝕣𝕒𝕥 𝕚𝕥𝕤 𝔻𝔼𝔸𝔻",
	"ｙｏｕ ｔｈｉｎｋ ｙｏｕ´ｒｅ ｗｉｎ?. ｗｒｏｎｇ.",
	"𝕕𝕠𝕟´𝕥 𝕞𝕦𝕥𝕖𝕤 𝕗𝕠𝕣 𝕜𝕚𝕝𝕝𝕤𝕒𝕪𝕚𝕟𝕘𝕤, 𝕞𝕒𝕟𝕦𝕒𝕝 𝕥𝕪𝕡𝕖))",
	"𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕨𝕚𝕟 𝕚 𝕨𝕚𝕝𝕝 𝕣𝕠𝕝𝕝 𝕓𝕚𝕘 𝕔𝕒𝕣 𝕟𝕠𝕨 (◣_◢)",
	"ｚａｂｏｌｏｔｎｙ ｄｏｎｔ ａｐｐｒｏｖｉｎｇ, ｉｍ ｓｑｌ ｉｎｊｅｃｔ ｎｖｌｚ (◣_◢)",
	"𝕝𝕠𝕔𝕒𝕝 𝕖𝕟𝕖𝕞𝕪𝕚𝕢 = 𝕞𝕒𝕥𝕙.𝕣𝕒𝕟𝕕𝕠𝕞(0, 4)",
	"ᵇʳᵃⁱⁿ ᵒⁿ ? ",
	"𝕕𝕠𝕟´𝕥 𝕙𝕠𝕡𝕖𝕤. 𝕓𝕒𝕚𝕥𝕤 𝕒𝕝𝕨𝕒𝕪𝕤 𝕨𝕚𝕟𝕟𝕖𝕥 :)",
	"１０００-７ ♛ (◣_◢)",
	"𝕚𝕞 𝕡𝕦𝕤𝕙, 𝕜𝕚𝕝𝕝, 𝕟𝕚99𝕖𝕣𝕤 - 𝕤𝕠𝕦𝕗𝕚𝕨 𝕒𝕚𝕣 𝕤𝕦𝕡𝕡𝕠𝕣𝕥.",
	"ｂｉｔｃｈ ｉｍ ｏｎ ｍｙ ｄｅｍｏｎ ｔｉｍｅ  ♛ (◣_◢)",
	"𝐦𝐨𝐭𝐡𝐞𝐫 = 𝐞𝐧𝐭𝐢𝐭𝐲.𝐞𝐧𝐞𝐦𝐲_𝐦𝐨𝐭𝐡𝐞𝐫.𝐚𝐥𝐢𝐯𝐞() FALSE",
	"𝕪𝕠𝕦 𝕥𝕙𝕚𝕟𝕜 𝕘𝕒𝕞𝕖𝕤𝕖𝕟𝕤𝕖? 𝕚 𝕜𝕟𝕠𝕨 𝕔𝕙𝕖𝕖𝕤𝕖𝕔𝕒𝕥.𝕝𝕦𝕒",
	"𝕤𝕖𝕒𝕔𝕙𝕚𝕟𝕘 𝕞𝕠𝕥𝕙𝕖𝕣 𝕓𝕦𝕥 𝕕𝕠𝕟𝕥 𝕗𝕚𝕟𝕕𝕤 :-)",
	"𝕤𝕜𝕖𝕖𝕥.𝕔𝕔? 𝕍𝕀ℝ𝕌𝕊)",
	"𝕋𝔸𝕊𝕋𝔼 𝕄𝕐 𝕊ℙ𝔼ℝ𝕄 8==𝔻 ~~~",
	"𝕊𝕖𝕖 𝕒 𝕟𝕚𝕘𝕘𝕖𝕣, 𝕕𝕒𝕪 ℝ𝕌𝕀ℕ𝔼𝔻",
	"𝕡𝕦𝕤𝕙, 𝕜𝕚𝕝𝕝, 𝕜𝕚𝕝𝕝, 𝕓𝕒𝕚𝕥, 𝕂𝕀𝕃𝕃 ~ 𝕒𝕗𝕥𝕖𝕣𝕝𝕚𝕗𝕖𝕝𝕦𝕒.𝕩𝕪𝕫",
	"𝕥𝕣𝕪𝕖𝕤 𝕓𝕒𝕚𝕥𝕤 = 𝕕𝕠𝕟𝕥 𝕨𝕠𝕣𝕜 𝕠𝕟 𝕞𝕖 ;;))",
	"𝕦𝕟𝕞𝕒𝕥𝕔𝕙𝕖𝕣 𝕚𝕞 𝕨𝕚𝕟𝕟𝕖𝕥 )",
	"𝕌𝕨𝕌 𝕊𝕖𝕟𝕡𝕒𝕚~ (𝕚 𝕙𝕒𝕥𝕖 𝕟𝕚𝕘𝕘𝕖𝕣𝕤)",
	"𝕒𝕕𝕞𝕚𝕟 𝕥𝕙𝕚𝕟𝕜 𝕚𝕥𝕤 𝕜𝕚𝕝𝕝𝕤𝕒𝕪? 𝕚 𝕤𝕒𝕪 𝕚𝕥𝕤 𝕔𝕞𝕕 𝕔𝕠𝕞𝕞𝕒𝕟𝕕(◣_◢)(◣_◢)(◣_◢)",
	"𝖎𝖓𝖏𝖊𝖈𝖙 𝖆𝖋𝖙𝖊𝖗𝖑𝖎𝖋𝖊𝖑𝖚𝖆: 𝟏𝟎%, 𝟓𝟎%, 𝟏𝟎𝟎%",
	"𝐤𝐢𝐥𝐥𝐞𝐝 𝐛𝐲 𝐲𝐨𝐮𝐧𝐠 𝐜𝐞𝐨( ˘︹˘ ) (𝐢 𝐬𝐡𝐚𝐭 𝐦𝐲𝐬𝐞𝐥𝐟)",
	"dont try bait? (ㆆ_ㆆ)",
	"me mma BOXER king (ง︡'-'︠)ง",
	"𝙝𝙖𝙩𝙞𝙣𝙜? 𝙇𝙐𝘾𝙆𝙀𝙍𝙎 (◣◢)┌∩┐",
	"ESOTERIK t(>.<t)::SOUFIW (っ◔◡◔)っ ❤",
	"(►.◄) big man fatman (batman)",
	"（`_ゝ´) - nice bait (try of bait)",
	"v( ‘.’ )v resolver bosster ;)",
	"𝐋𝐮𝐜𝐤𝐤𝐢𝐧𝐠𝐬 𝐝𝐨𝐧𝐭 𝐡𝐚𝐯𝐞 𝐜𝐡𝐚𝐧𝐜𝐞 𝐯𝐬 𝐦𝐞 ( ≖.≖)",
	"𝙝𝙖𝙩𝙚𝙧 𝙨𝙖𝙮 𝙠𝙞𝙡𝙡𝙨𝙖𝙮? 𝙞 𝙨𝙖𝙮 𝙗𝙞𝙣𝙙 𝙇 '𝙨𝙖𝙮 𝙙𝙤𝙣𝙩 𝙩𝙧𝙮 𝙬𝙞𝙣'",
	"LUCKERS DONT ♛♛♛",
	"ｍｙ ｃｏｃｋ ｃｈｉｌｌ ｒｎ: (─‿─)",
	"ｓｔｏｐ ｌｕｃｋ?? ＩＤＩＯＴＳ ⊂◉‿◉つ",
	"ｎｉｃｅ ｐｒａｙ ｆｏｒ ｌｕｃｋ (▼-▼*)",
	"༼⌐■ل͟■༽ ₖᵢₗₗ by ᵢgₒᵣ",
	"(ﾒ▼_▼) ռɛʋɛʀʟօֆɛ.ƈƈ (ﾒ▼_▼)",
	"♥ヽ༼☯﹏☯༽ﾉ L♥U♥C♥K♥Y♥ B♥A♥S♥T♥A♥R♥D♥O♥",
	"𝚗𝚘 𝚙𝚛𝚊𝚢 𝚏𝚘𝚛 𝚕𝚞𝚌𝚔𝚜 𝚙𝚕𝚣 (¬_¬)",
	"𝖆𝖓𝖙𝖎-𝖆𝖎𝖒 𝖙𝖊𝖈𝖍𝖓𝖔𝖑𝖔𝖌𝖎𝖊𝖘 𝖑𝖔𝖆𝖉𝖊𝖉 ╭∩╮(︶ε︶*)chu ",
	"𝚔𝚒𝚕𝚕𝚎𝚝 𝚋𝚢 𝚋𝚘𝚜𝚜 （＾＿−）",
	"ｓｍａｌｌ ｂｏｙ? ＢＩＧ ＢＯＹ (￣^￣)ゞ",
	"ᴹᴱᴿᶜᴱᴰᴱᶻ ᵇᵉⁿᶻ hxh",
	"(⊃‿⊂) ｆｒｏｇ",
	"𝖽𝗈𝗇𝗍 𝗍𝗋𝗒 𝖿𝗂𝗀𝗁𝗍 ༼ง ͠ຈ ͟ل͜ ͠ຈ༽o:[]:::::::>",
	"𝗉𝖾𝖽𝗈𝖻𝖾𝖺𝗋 ʕ•ᴥ•ʔ",
	"𝖾𝗌𝗍𝗄=◖⚆ᴥ⚆◗",
	"𝗒𝗈𝗎 𝗍𝗋𝗂𝖾𝗌 𝗈𝖿 𝗍𝗂𝗋𝖾𝖽? 𝖭𝖨𝖢𝖤 𝗃𝗈𝖻（´＿｀）",
	"𝗃𝗎𝗌𝗍 𝖽𝗂𝖽 𝗂𝗍 𝖿𝗈𝗋 𝗍𝗁𝖾 𝗅𝗎𝗅𝗓 𝗂𝗀 ≖‿≖",
	"𝒾 𝓂𝒶𝓀𝑒 𝓇𝓊𝓁𝑒𝓈, 𝓎𝑜𝓊 𝒻𝑜𝓁𝓁𝑜𝓌 (•‿•)",
	"(˵◕ω◕˵✿) 𝓂𝒶𝓎𝒷𝑒 𝓉𝓇𝓎 𝒽𝒶𝓇𝒹𝑒𝓇, 𝒷𝓊𝓉 𝒾'𝓂 𝒽𝒶𝓇𝒹𝑒𝓈𝓉",
	"𝕪𝕠𝕦 𝕤𝕖𝕖𝕜 𝕨𝕚𝕟𝕤? 𝕀 𝕕𝕖𝕝𝕚𝕧𝕖𝕣 𝕕𝕖𝕒𝕥𝕙.",
	"𝔩𝔦𝔣𝔢'𝔰 𝔞 𝔤𝔞𝔪𝔢, 𝔞𝔫𝔡 𝔶𝔬𝔲'𝔯𝔢 𝔩𝔬𝔰𝔦𝔫𝔤 (¬_¬)",
	"ｄｏｎ´ｔ ｗａｓｔｅ ｔｉｍｅ, ｙｏｕ´ｒｅ ｏｕｔ ｏｆ ｌｕｃｋ :)",
	"𝕋𝕙𝕚𝕟𝕜 𝕚𝕥'𝕤 𝕖𝕒𝕤𝕪? 𝕋𝕣𝕪 𝕞𝕖 (ง'̀-'́)ง",
	"𝕀'𝕄 𝕪𝕠𝕦𝕣 𝕟𝕚𝕘𝕙𝕥𝕞𝕒𝕣𝕖. 𝕎𝕒𝕜𝕖 𝕦𝕡? (¬‿¬)",
	"ｉｔ´ｓ ｔｉｍｅ ｔｏ ｄｉｅ, ｇａｍｅ ｏｎ ٩(◕‿◕｡)۶",
	"𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕔𝕒𝕟 𝕓𝕖𝕒𝕥 𝕞𝕖? 𝕋𝕙𝕚𝕟𝕜 𝕒𝕘𝕒𝕚𝕟! (◣_◢)",
	"𝕘𝕒𝕞𝕖'𝕤 𝕠𝕧𝕖𝕣, 𝕥𝕚𝕞𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦𝕣 𝕖𝕟𝕕 :)",
	"𝒾 𝓂𝒶𝓀𝑒 𝓇𝓊𝓁𝑒𝓈, 𝓎𝑜𝓊 𝒻𝑜𝓁𝓁𝑜𝓌 (•‿•)",
	"(˵◕ω◕˵✿) 𝓂𝒶𝓎𝒷𝑒 𝓉𝓇𝓎 𝒽𝒶𝓇𝒹𝑒𝓇, 𝒷𝓊𝓉 𝒾'𝓂 𝒽𝒶𝓇𝒹𝑒𝓈𝓉",
	"𝕪𝕠𝕦 𝕤𝕖𝕖𝕜 𝕨𝕚𝕟𝕤? 𝕀 𝕕𝕖𝕝𝕚𝕧𝕖𝕣 𝕕𝕖𝕒𝕥𝕙.",
	"𝔩𝔦𝔣𝔢'𝔰 𝔞 𝔤𝔞𝔪𝔢, 𝔞𝔫𝔡 𝔶𝔬𝔲'𝔯𝔢 𝔩𝔬𝔰𝔦𝔫𝔤 (¬_¬)",
	"ｄｏｎ´ｔ ｗａｓｔｅ ｔｉｍｅ, ｙｏｕ´ｒｅ ｏｕｔ ｏｆ ｌｕｃｋ :)",
	"𝕋𝕙𝕚𝕟𝕜 𝕚𝕥'𝕤 𝕖𝕒𝕤𝕪? 𝕋𝕣𝕪 𝕞𝕖 (ง'̀-'́)ง",
	"𝕀'𝕄 𝕪𝕠𝕦𝕣 𝕟𝕚𝕘𝕙𝕥𝕞𝕒𝕣𝕖. 𝕎𝕒𝕜𝕖 𝕦𝕡? (¬‿¬)",
	"ｉｔ´ｓ ｔｉｍｅ ｔｏ ｄｉｅ, ｇａｍｅ ｏｎ ٩(◕‿◕｡)۶",
	"𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦 𝕔𝕒𝕟 𝕓𝕖𝕒𝕥 𝕞𝕖? 𝕋𝕙𝕚𝕟𝕜 𝕒𝕘𝕒𝕚𝕟! (◣_◢)",
	"𝕘𝕒𝕞𝕖'𝕤 𝕠𝕧𝕖𝕣, 𝕥𝕚𝕞𝕖 𝕗𝕠𝕣 𝕪𝕠𝕦𝕣 𝕖𝕟𝕕 :)",
	"𝗐𝗁𝗈'𝘀 𝘁𝗵𝗲 𝗻𝗲𝘄𝗯𝗶𝗲 𝗻𝗼𝘄? ┗(＾0＾)┓",
	"𝗍𝗁𝗶𝗻𝗸 𝗎 𝖼𝖺𝗇 𝖿𝗅𝗒? 𝗒𝗈𝗎'𝗋𝖾 𝗐𝗿𝗈𝗇𝗀. (︶︹︺)",
	"𝖳𝗋𝗒 𝗍𝗈 𝖽𝖾𝖿𝖾𝖺𝗍 𝗆𝖾? 𝖭𝖮𝖳 𝖳𝖮𝖣𝖠𝖸 ♛(◣_◢)",
	"𝖳𝗁𝖾 𝗋𝖾𝖺𝗅 𝗉𝗅𝖺𝗒𝖾𝗋𝗌 𝖺𝗋𝖾 𝗁𝖾𝗋𝖾 ◕‿↼",
	"𝗒𝗈𝗎 𝗍𝗁𝗶𝗇𝗄 𝗎 𝗄𝗇𝗈𝗐 𝗍𝗁𝖾 𝗀𝖺𝗆𝖾? 𝗍𝗁𝗂𝗇𝗄 𝖺𝗀𝖺𝗂𝗇. (─‿─)",
	"𝗀𝖺𝗆𝖾 𝗈𝗏𝖾𝗋, 𝖻𝗈𝗒𝗌 〠_〠",
	"𝗁𝗈𝗉𝖾 𝗎 𝖽𝗂𝖽𝗇'𝗍 𝖿𝗈𝗋𝗀𝖾𝗍 𝗍𝗈 𝗌𝖺𝗏𝖾, 𝗅𝗈𝗅 (っ◔◡◔)っ",
	"𝖺𝗐𝗐, 𝖽𝗈𝗇'𝗍 𝖼𝗋𝗒, 𝗂𝗍'𝗌 𝗃𝗎𝗌𝗍 𝖺 𝗀𝖺𝗆𝖾 ˘︹˘",
	"𝖿𝖾𝖾𝗅𝗌 𝗀𝗈𝗈𝖽 𝗍𝗈 𝖻𝖾 𝗍𝗁𝖾 𝗄𝗂𝗇𝗀 ♛",
	"𝖿𝖺𝖼𝖾 𝗂𝗍, 𝗎'𝗋𝖾 𝗃𝗎𝗌𝗍 𝖺 𝖻𝗂𝗀 𝖻𝗎𝗌𝗍 ˘︹˘",
	"𝔼𝕟𝕖𝕞𝕪 𝕓𝕖𝕝𝕚𝕖𝕧𝕖 𝕪𝕠𝕦'𝕣𝕖 𝕨𝕖𝕒𝕜? 𝕤𝕙𝕠𝕨 𝕥𝕙𝕖𝕞 𝕨𝕙𝕠'𝕤 𝕥𝕙𝕖 𝔹𝕆𝕊𝕊 (◣_◢)",
	"𝕄𝕒𝕥𝕔𝕙 𝕤𝕥𝕒𝕣𝕥𝕚𝕟𝕘, 𝕡𝕣𝕖𝕡𝕒𝕣𝕖 𝕥𝕠 𝔻𝕆𝕄𝕀ℕ𝔸𝕋𝔼 ♛",
	"𝔻𝕠𝕟´𝕥 𝕖𝕩𝕡𝕖𝕔𝕥 𝕖𝕒𝕤𝕪 𝕨𝕚𝕟𝕤, 𝕡𝕣𝕖𝕡𝕒𝕣𝕖 𝕗𝕠𝕣 𝕔𝕙𝕒𝕝𝕝𝕖𝕟𝕘𝕖. (ง︡'-'︠)ง",
	"ℍ𝕒𝕙𝕒, 𝕪𝕠𝕦 𝕥𝕙𝕠𝕦𝕘𝕙𝕥 𝕪𝕠𝕦 𝕨𝕚𝕟? 𝔻𝔼ℕ𝕀𝔼𝔻. （⌒▽⌒）",
	"ℂ𝕠𝕟𝕗𝕚𝕕𝕖𝕟𝕔𝕖 𝕚𝕤 𝕜𝕖𝕪, 𝕨𝕚𝕥𝕙𝕠𝕦𝕥 𝕚𝕥 𝕪𝕠𝕦´𝕣𝕖 𝕛𝕦𝕤𝕥 𝕒𝕟 𝕖𝕒𝕤𝕪 𝕥𝕒𝕣𝕘𝕖𝕥. 𝕂𝕖𝕖𝕡 𝕥𝕙𝕒𝕥 𝕚𝕟 𝕞𝕚𝕟𝕕 (◣_◢)",
	"𝕒𝕞 𝕓𝕠𝕞𝕓𝕖𝕣. 𝕤𝕒𝕗𝕖 𝕖𝕩𝕡𝕝𝕠𝕕𝕖 (⌐■_■)♛",
	"𝐮 𝐝𝐢𝐞𝐝? 𝐦𝐲 𝐭𝐚𝐜𝐭𝐢𝐜𝐬 𝐰𝐨𝐫𝐤𝐞𝐝 (◣_◢)",
	"𝔠𝔞𝔫'𝔱 𝔰𝔱𝔬𝔭 𝔪𝔢? 𝔠𝔞𝔱𝔠𝔥 𝔪𝔢 𝔣𝔦𝔯𝔰𝔱! (ʘ‿ʘ)",
	"𝙄'𝙢 𝙖 𝙗𝙖𝙞𝙩𝙚𝙧, 𝙮𝙤𝙪 𝙛𝙖𝙡𝙡? 𝙃𝙖! ♛",
	"𝕕𝕠𝕟'𝕥 𝕤𝕔𝕣𝕖𝕒𝕞, 𝕚𝕥'𝕤 𝕠𝕧𝕖𝕣 (‾⌣‾)♉",
	"𝙡𝙪𝙘𝙠 𝙞𝙨 𝙛𝙤𝙧 𝙡𝙤𝙨𝙚𝙧𝙨, 𝙄 𝙝𝙖𝙫𝙚 𝙨𝙠𝙞𝙡𝙡 (ᵔᴥᵔ)",
	"𝖞𝖔𝖚 𝖙𝖗𝖞 𝖙𝖔 𝖜𝖎𝖓? 𝖍𝖔𝖕𝖊 𝖞𝖔𝖚 𝖍𝖆𝖛𝖊 𝖆 𝖕𝖑𝖆𝖓 (•_•)∫",
	"𝖂𝖍𝖔'𝖘 𝖙𝖍𝖊 𝖇𝖔𝖘𝖘? 𝖄𝖔𝖚'𝖗𝖊 𝖑𝖔𝖔𝖐𝖎𝖓𝖌 𝖆𝖙 𝖍𝖎𝖒 (⌐■_■)⊃",
	"𝖙𝖍𝖎𝖓𝖐 𝖞𝖔𝖚'𝖗𝖊 𝖘𝖆𝖋𝖊? 𝕴'𝖒 𝖈𝖔𝖒𝖎𝖓𝖌 𝖋𝖔𝖗 𝖞𝖔𝖚 (╯°□°）╯︵ ┻━┻",
	"𝕙𝕒𝕙𝕒, 𝕦 𝕥𝕙𝕚𝕟𝕜 𝕦 𝕣 𝕤𝕒𝕗𝕖? ｔｈｉｎｋ ａｇａｉｎ (◣_◢)",
	"𝐃𝐚𝐝 𝐬𝐚𝐲𝐬, 𝐧𝐨 𝐩𝐥𝐚𝐲 𝐰𝐢𝐭𝐡 𝐟𝐨𝐨𝐥𝐬 - 𝐌𝐄 𝐑𝐔𝐋𝐄𝐑 (◣_◢)",
	"ｉ ｔｈｉｎｋ ｕ ａｒｅ ｂｌｉｎｄ? ",
	"𝐈'𝐦 𝐧𝐨𝐭 𝐲𝐨𝐮𝐫 𝐟𝐫𝐢𝐞𝐧𝐝, 𝐦𝐲 𝐠𝐮𝐧𝐬 𝐚𝐫𝐞 𝐋𝐎𝐀𝐃𝐄𝐃",
	"𝕤𝕥𝕠𝕡 𝕕𝕣𝕖𝕒𝕞𝕚𝕟𝕘, 𝕚𝕥'𝕤 𝕥𝕙𝕖 𝕣𝕖𝕒𝕝 𝕨𝕠𝕣𝕝𝕕 𝕠𝕦𝕥 𝕙𝕖𝕣𝕖, 𝕥𝕨𝕖𝕣𝕡.",
	"𝕤𝕠𝕦𝕟𝕕𝕤 𝕠𝕗 𝕪𝕠𝕦𝕣 𝕔𝕣𝕪𝕚𝕟𝕘, 𝕞𝕦𝕤𝕚𝕔 𝕥𝕠 𝕞𝕪 𝕖𝕒𝕣𝕤))",
	"𝕤𝕥𝕠𝕡 𝕔𝕣𝕪𝕚𝕟𝕘, 𝕚'𝕞 𝕛𝕦𝕤𝕥 𝕡𝕝𝕒𝕪𝕚𝕟𝕘 𝕥𝕙𝕖 𝕘𝕒𝕞𝕖 (◣_◢)",
	"ｕ ｔｈｉｎｋ ｉｍ ｓｏｆｔ? ｗａｉｔ ｔｉｌ ｉ ｓｈｏｗ ｍｙ ｒｅａｌ ｐｏｗｅｒ (◣_◢)",
	"𝕄𝔼 𝔹𝕀𝔾 𝔹𝕆𝕊𝕊, 𝔾𝔸𝕄𝔼𝔻𝔼𝔸𝔻. ♛",
	"(◣_◢) 𝓭𝓪𝓭𝓼𝓲𝓮𝓼 𝓼𝓪𝔂, 𝓷𝓸 𝓰𝓪𝓶𝓮𝓼𝓲𝓮𝓼 - 𝕀𝔸𝕄 𝕋ℍ𝔼 𝔹𝔼𝔸𝕊𝕋 (◣_◢)",
	"𝕪𝕠𝕦𝕣 𝔹ℝ𝔸𝕀ℕ 𝕨𝕣𝕠𝕟𝕘𝕚𝕖𝕕. ?",
	"𝕄𝔼 𝔹𝔼𝔸𝕋 𝔸𝕃𝕃, 𝔸𝕃𝕃 𝔻𝔼𝔸𝔻",
	"𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦𝕣 𝕎𝕀ℕ𝕀ℕ𝔾?. 𝕟𝕠𝕥𝕥𝕒.",
	"𝕕𝕠𝕟´𝕥 𝕤𝕚𝕝𝕖𝕟𝕔𝕖 𝕗𝕠𝕣 𝕕𝕖𝕒𝕥𝕙𝕪𝕖𝕝𝕝𝕤, 𝕞𝕒𝕟𝕦𝕒𝕝 𝕥𝕪𝕡𝕖))",
	"𝕕𝕠𝕟𝕥 𝕥𝕙𝕚𝕟𝕜 𝕪𝕠𝕦𝕣 𝕎𝕀ℕℕ𝕀ℕ𝔾, 𝕀´𝕝𝕝 𝕣𝕠𝕝𝕝 𝔹𝕀𝔾 𝕥𝕣𝕦𝕔𝕜 (◣_◢)",
	"𝕟𝕠 𝕝𝕠𝕧𝕖 𝕗𝕠𝕣 𝕓𝕒𝕕𝕘𝕦𝕪𝕤, 𝕀´𝕞 𝕤𝕠𝕦𝕣𝕔𝕖 𝕚𝕟𝕛𝕖𝕔𝕥 𝕠𝕦𝕥𝕝𝕒𝕨 (◣_◢)",
	"1 Tapped Pu$$y",
	"pTap",
	"How many 1taps am I gonna get?",
	"1 on my screen",
	"XD",
	"Juan",
	"KQLY",
	"am i playing against legits?",
	"You buy that cheat from reis?",
	"heavenly saint GOT TAPPED",
	"u using a paste?",
	"OWNED BITCH",
	"CUNT GOT DESTROYED",
	"ENRAGED DOG",
	"HAHAHAHA",
	"Trying is for niggers",
	"Nice 1 way queer",
	"tryharding cunt",
	"1way is the only way for this heavenly saint",
	"My aa was off",
	"my keyboard was unplugged",
	"my cat jumped on my keyboard",
	"I forgot to turn aimbot on",
	"sorry was fucking your mom",
	"eat a dick"
}
local var_0_27 = {
	"lucky dog"
}
local var_0_28 = {
	"Robimy fotki na imprezie, buty mi się błyszczą",
	"Świeże Nike prosto z sklepu, Vansy wszystkie niszczą",
	"Wszystkie suki tu od brokatu się błyszczą",
	"Od fazy mam schizę, jakieś głosy w głowie piszczą",
	"Mam chleb głupia suko",
	"Kasa, kasa, mnie po chuju maca",
	"W plecaku kosy widzimy się w nocy",
	"Kopne cię w chuja i rzucę o ścianę",
	"Ty jeździsz audi moja mama fiat",
	"Spójrz dziwko, jestem wielki, twój teammate trochę miękki",
	"Jebać ich opinie, o-jej",
	"Tysiąc papierosów zamieniłem na elf bara",
	"Me spodnie nadal nisko, bo mam temat, jebać po-po",
	"Mówisz, że jesteś złym facetem...",
	"Słyszałem, że sprzedajesz zaproszenia, trzymaj się zastrzyków",
	"Nietrafiony strzał z powodu mojej śmiertelnej śmiertelności",
	"Pieprz się dupku, aż karmelki wyjdą dupą",
	"Kapłan wie, że chodzisz odkopany?",
	"Szczerze zachęcam do aborcji bez względu na to, ile masz lat...",
	"Jak rucham cię w klatkę piersiową, twoje ramiona klaszczą",
	"Jak wyjmę swojego kutasa, wszystkie kobiety w ciąży usuwają płód",
	"Ty mały pedale",
	"Niech Bóg da ci krótkie ręce, żeby cie w dupie swędziało",
	"Pieprzyłbym cię, ale mój kutas jest mój",
	"Widzisz przybywający do mnie transport Turków?",
	"Ile kutasów cie złamało w nocy?",
	"zabijaj mnie, klawiatura mi się odłączyła",
	"Myszka mi wyszła za biurko, śmiało zabijaj",
	"Zamierzałem wpaść w twoją głupią cipkę",
	"Włóż te ciężkie jaja do swojej cipki",
	"Włoże swojego penisa do krypty, w której cie trzymam",
	"Zapytaj mnie, czy nadal boli mnie kolano po nocy z twoją matką",
	"Jak położę swojego penisa na Twoim ramieniu, powiesz, że nosiłeś kłody do domu",
	"Oho, konfigurowałem negeva",
	"nie chcesz kutasa w ustach, a ciągle go bierzesz",
	"Ty srasz kamieniami kolejowymi",
	"Wiesz, że jestem lichwiarzem, rozrywam na strzępy, a potem znikam",
	"Wkładam ci kutasa do ust, żeby dodać ci masy",
	"Lepiej zobacz jak ci naplułem do zupy",
	"Zrobisz mi loda, aż uderzę cię piętami w ramiona",
	"Obciągniesz mi, jak zabijesz mnie jeszcze raz!",
	"Ohooooo, zabiłeś mnie! Ssij mi ptaka, aż dojdę!",
	"Twoja matka też cię nie znosi, niewolniku...",
	"nie przejmuj się swoim martwym pyskiem",
	"masz średnią dla niewolników"
}
local var_0_29 = {
	hideshots = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots"),
	dt = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"),
	lag = ui.find("Aimbot", "Ragebot", "Main", "Double Tap", "Lag Options"),
	hsopt = ui.find("Aimbot", "Ragebot", "Main", "Hide Shots", "Options"),
	fd = ui.find("Aimbot", "Anti Aim", "Misc", "Fake Duck"),
	enable = ui.find("Aimbot", "Anti Aim", "Angles", "Enabled"),
	yaw = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw"),
	hidden = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Hidden"),
	yaw_base = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Base"),
	yaw_offset = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Offset"),
	yaw_mode = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier"),
	yaw_modoff = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw Modifier", "Offset"),
	bodyyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw"),
	inverter1 = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Inverter"),
	left_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Left Limit"),
	right_limit = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Right Limit"),
	options = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Options"),
	freestanding = ui.find("Aimbot", "Anti Aim", "Angles", "Body Yaw", "Freestanding"),
	pitch = ui.find("Aimbot", "Anti Aim", "Angles", "Pitch"),
	backstab = ui.find("Aimbot", "Anti Aim", "Angles", "Yaw", "Avoid Backstab"),
	freestand = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding"),
	disableyaw = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Disable Yaw Modifiers"),
	bodyfrees = ui.find("Aimbot", "Anti Aim", "Angles", "Freestanding", "Body Freestanding"),
	removesc = ui.find("Visuals", "World", "Main", "Override Zoom", "Scope Overlay"),
	slow = ui.find("Aimbot", "Anti Aim", "Misc", "Slow Walk"),
	legs = ui.find("Aimbot", "Anti Aim", "Misc", "Leg Movement"),
	strafe = ui.find("Miscellaneous", "Main", "Movement", "Air Strafe"),
	baim = ui.find("Aimbot", "Ragebot", "Safety", "Body Aim"),
	safe = ui.find("Aimbot", "Ragebot", "Safety", "Safe Points")
}
local var_0_30 = {
	main2 = var_0_3.create("\f<house>", "\f<house> Main ", 1),
	main = var_0_3.create("\f<house>", "\f<sliders-up> Config Location", 2),
	localconfigs = var_0_3.create("\f<house>", "\f<file> Local Configs", 2),
	cloudconfigs = var_0_3.create("\f<house>", "\f<cloud> Cloud Configs", 2),
	main3 = var_0_3.create("\f<house>", "\f<check> Verification", 2),
	aa1 = var_0_3.create("\f<shield>", "\f<sliders-up>     Enable     ", 1),
	antis = var_0_3.create("\f<shield>", "\f<sliders-up>     Defensive Builder     ", 1),
	anti2 = var_0_3.create("\f<shield>", "\f<sliders-up>  Builder   ", 2),
	cfg = var_0_3.create("\f<shield>", "\f<layer-plus>  Config System     ", 1),
	misc = var_0_3.create("\f<gear>", "\f<gear> Misc ", 2),
	visuals = var_0_3.create("\f<gear>", "\f<stars> Visuals ", 1)
}

username = var_0_30.main2:label("")
build = var_0_30.main2:label("")
update = var_0_30.main2:label("")

local var_0_31 = {}

antisetup = {}

local var_0_32 = {}
local var_0_33 = {}
local var_0_34 = {}

cfgselection = var_0_30.main:list("Current Location:", {
	"\f<file> Local",
	"\f<cloud> Cloud"
})

local function var_0_35()
	local var_6_0 = var_0_0.text_animate("A S T R A", -2, {
		color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
		color()
	})
	local var_6_1 = var_0_0.text_animate(var_0_18.username, -2, {
		color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
		color()
	})
	local var_6_2 = var_0_0.text_animate(var_0_18.build, -2, {
		color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
		color()
	})
	local var_6_3 = var_0_0.text_animate(" A S T R A", -2, {
		color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
		color()
	})
	local var_6_4 = var_0_3.get_style("Link Active")

	var_0_18.link_color = "\a" .. var_6_4:to_hex()

	var_0_3.sidebar(var_6_0:get_animated_text(), var_0_18.link_color .. "♛")
	username:name(var_0_18.link_color .. "\f<user> \aDEFAULT User:  " .. var_6_1:get_animated_text(), 2)
	build:name(var_0_18.link_color .. "\f<scroll> \aDEFAULTBuild: " .. var_6_2:get_animated_text(), 2)
	update:name(var_0_18.link_color .. "\f<crown>" .. var_6_3:get_animated_text() .. var_0_18.link_color .. " \f<crown>", 2)
	var_6_0:animate()
	var_6_1:animate()
	var_6_2:animate()
	var_6_3:animate()
end

local var_0_36 = network.get(var_0_16 .. "/neverlose/astra_menu_glow.png")
local var_0_37 = render.load_image(var_0_36)

var_0_30.main2:texture(var_0_37, vector(246, 246), 10)

verification = {
	verifytext = var_0_30.main2:label("How to get role in Astra discord server.\nPress 'Verify' then go to our discord server #verify-nl and type /verify [token]"),
	discord = var_0_30.main2:button("• \f<discord> \vDiscord ", function()
		panorama.SteamOverlayAPI.OpenExternalBrowserURL("https://discord.gg/EVEeDBBarY")
	end, true),
	verify = var_0_30.main2:button("• \f<circle-check> \vVerify ", function()
		network.post(var_0_16 .. "/verify/gen_verify.php", {
			key = "lEDCHG62E80fbiRP4IfuaqpK6FKFoEUa",
			username = var_0_18.username,
			build = var_0_18.build,
			signature = var_0_19({
				var_0_18.username,
				var_0_18.build
			})
		}, {
			["Content-Type"] = "application/json"
		}, function(arg_9_0)
			local var_9_0 = json.parse(arg_9_0)

			if var_9_0 and var_9_0.token then
				if var_9_0.token ~= "You are already a verified user." then
					print("Your verification code: \a" .. var_0_20, var_9_0.token .. " \a(Copied to clipboard)")
					print_dev("Your verification code: \a" .. var_0_20, var_9_0.token .. " \a(Copied to clipboard)")
					var_0_2.set(var_9_0.token)
				else
					print("You are already a verified user.")
					print_dev("You are already a verified user.")
				end
			else
				print("Verification failed. No token received.")
				print_dev("Verification failed. No token received.")
			end
		end)
	end, true)
}
var_0_32.indicators = var_0_30.visuals:switch("\f<pen-fancy>  Crosshair Indicators")
var_0_32.indicators_create = var_0_32.indicators:create()
var_0_32.indicators_pulsate = var_0_32.indicators_create:switch("\f<pen-fancy>  Pulsate")
var_0_32.indicators_color1 = var_0_32.indicators_create:color_picker("First", color(68, 68, 68)):depend(var_0_32.indicators)
var_0_32.indicators_color2 = var_0_32.indicators_create:color_picker("Second", color(255, 255, 255)):depend(var_0_32.indicators)
var_0_32.defensiveind = var_0_30.visuals:switch("\f<feather>  Defensive indicator")
var_0_32.defensiveind_create = var_0_32.defensiveind:create()
var_0_32.defensiveind_color1 = var_0_32.defensiveind_create:color_picker("First", color(177, 166, 237)):depend(var_0_32.defensiveind)
var_0_32.defensiveind_color2 = var_0_32.defensiveind_create:color_picker("Second", color(107, 58, 255)):depend(var_0_32.defensiveind)
var_0_32.velocityind = var_0_30.visuals:switch("\f<triangle-exclamation>  Velocity indicator")
var_0_32.velocityind_create = var_0_32.velocityind:create()
var_0_32.velocityind_color1 = var_0_32.velocityind_create:color_picker("First", color(177, 166, 237)):depend(var_0_32.velocityind)
var_0_32.velocityind_color2 = var_0_32.velocityind_create:color_picker("Second", color(107, 58, 255)):depend(var_0_32.velocityind)
var_0_32.viewmodel = var_0_30.visuals:switch("\f<sliders>  Viewmodel")
var_0_32.viewmodel_create = var_0_32.viewmodel:create()
var_0_32.viewmodel_fov = var_0_32.viewmodel_create:slider("FOV", -100, 100, 68):depend(var_0_32.viewmodel)
var_0_32.viewmodel_x = var_0_32.viewmodel_create:slider("X", -10, 10, 2.5):depend(var_0_32.viewmodel)
var_0_32.viewmodel_y = var_0_32.viewmodel_create:slider("Y", -10, 10, 0):depend(var_0_32.viewmodel)
var_0_32.viewmodel_z = var_0_32.viewmodel_create:slider("Z", -10, 10, -1.5):depend(var_0_32.viewmodel)
var_0_32.animations = var_0_30.visuals:switch("\f<wheelchair>  Animation Breaker")
var_0_32.anim_create = var_0_32.animations:create()
var_0_32.groundanims = var_0_32.anim_create:combo("Ground", {
	"Off",
	"Follow",
	"Jitter",
	"Micheal Jackson"
}):depend(var_0_32.animations)
var_0_32.aerialanims = var_0_32.anim_create:combo("Air", {
	"Off",
	"Static Legs"
}):depend(var_0_32.animations)
var_0_32.logs = var_0_30.visuals:switch("\f<list>  Ragebot logs")
var_0_33.aspect_ratio = var_0_30.misc:switch("\f<arrows-left-right-to-line>  Aspect Ratio")
var_0_33.aspect_ratio_create = var_0_33.aspect_ratio:create()
var_0_33.aspect_ratio_slider = var_0_33.aspect_ratio_create:slider("Aspect Ratio", 0, 200, 130):depend(var_0_33.aspect_ratio)
var_0_33.shittalk = var_0_30.misc:switch("\f<comments>  Trash Talk")
var_0_33.shittalk_create = var_0_33.shittalk:create()
var_0_33.shittalk_setts = var_0_33.shittalk_create:listable("Settings", {
	"On kill",
	"On death"
})
var_0_33.fast_ladder = var_0_30.misc:switch("\f<water-ladder>  Fast Ladder")
var_0_33.throw = var_0_30.misc:switch("\f<bomb>  Nade Fix")
var_0_33.shared_logo = var_0_30.misc:switch("\f<circle-info>  Shared Logo")
var_0_33.clearconsole = var_0_30.misc:switch("\f<square-terminal>  Clear console after round")
var_0_31.states = {
	"\vGlobal",
	"\vStanding",
	"\vMoving",
	"\vSlow-Walk",
	"\vCrouch",
	"\vAir",
	"\vAir+C"
}
var_0_31.aastate = {
	"GL",
	"ST",
	"MO",
	"SW",
	"CR",
	"AR",
	"A+C"
}
var_0_31.enablesetup = var_0_30.aa1:switch("Enable \vBuilder")
var_0_31.general = var_0_30.anti2:combo("", var_0_31.states):depend(var_0_31.enablesetup)
var_0_31.freestanding = var_0_30.aa1:switch("Freest\vanding"):depend(var_0_31.enablesetup)
var_0_31.enableextra = var_0_30.aa1:switch("Enable \vAdditionals")
var_0_31.extra = var_0_30.aa1:listable("", {
	"Safe Head",
	"Anti Backstab"
}):depend(var_0_31.enableextra)
var_0_31.manual_aa = var_0_30.aa1:combo("Manual \vAntiAim", "Off", "Left", "Right", "Forward")

for iter_0_0 = 1, #var_0_31.states do
	antisetup[iter_0_0] = {}
	antisetup[iter_0_0].enable = var_0_30.anti2:switch("\aDEFAULTOverride " .. var_0_31.states[iter_0_0] .. " \aDEFAULTState")
	antisetup[iter_0_0].yaw_typekurwa = var_0_30.anti2:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw Type", {
		"Default",
		"Slow Jitter",
		"Sway"
	})
	antisetup[iter_0_0].yaw_typekurwa2 = var_0_30.anti2:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw Mode", {
		"Normal",
		"L & R"
	})
	antisetup[iter_0_0].pitch = var_0_30.anti2:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw Pitch", var_0_29.pitch:list())
	antisetup[iter_0_0].yaw_base = var_0_30.anti2:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw Base", var_0_29.yaw:list())
	antisetup[iter_0_0].yaw_base_create = antisetup[iter_0_0].yaw_base:create()
	antisetup[iter_0_0].yaw_base_type = antisetup[iter_0_0].yaw_base_create:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTBase", var_0_29.yaw_base:list())
	antisetup[iter_0_0].yaw_general = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw", -180, 180, 0, 1, "°")
	antisetup[iter_0_0].yaw_l = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw (L)", -180, 180, 0, 1, "°")
	antisetup[iter_0_0].yaw_r = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw (R)", -180, 180, 0, 1, "°")
	antisetup[iter_0_0].jitterek_tryb = var_0_30.anti2:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw Modifier", var_0_29.yaw_mode:list())
	antisetup[iter_0_0].jitterek2_left = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULT Jitter (L)", -180, 180, 0, 1, "°")
	antisetup[iter_0_0].jitterek2_right = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULT Jitter (R)", -180, 180, 0, 1, "°")
	antisetup[iter_0_0].bodyyaw = var_0_30.anti2:switch("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTBody Yaw")
	antisetup[iter_0_0].bodyyaw_gear = antisetup[iter_0_0].bodyyaw:create()
	antisetup[iter_0_0].options = var_0_30.anti2:selectable("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTOptions", var_0_29.options:list())
	antisetup[iter_0_0].freestand = antisetup[iter_0_0].bodyyaw_gear:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTFreestanding", var_0_29.freestanding:list())
	antisetup[iter_0_0].left = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTDesync (L)", 0, 60, 60, 1, "°")
	antisetup[iter_0_0].right = var_0_30.anti2:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTDesync (R)", 0, 60, 60, 1, "°")
	antisetup[iter_0_0].defensive_aa = var_0_30.antis:switch("\v" .. var_0_31.states[iter_0_0] .. " • \aDEFAULTDefensive")
	antisetup[iter_0_0].defensive_create = antisetup[iter_0_0].defensive_aa:create()
	antisetup[iter_0_0].defensive_hardmode = var_0_30.antis:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTMode", {
		"Always on",
		"Hold Ticks",
		"Ideal"
	})
	antisetup[iter_0_0].defensive_yaw_type = var_0_30.antis:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTYaw", {
		"Spin",
		"Stage",
		"Maximum",
		"Static"
	})
	antisetup[iter_0_0].pitchtype = var_0_30.antis:combo("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTPitch", {
		"Zero",
		"Down",
		"Up",
		"Random",
		"Custom"
	})
	antisetup[iter_0_0].defensive_pitch = var_0_30.antis:slider("\v" .. var_0_31.aastate[iter_0_0] .. " • \aDEFAULTPitch", -89, 89, 0, 1, "°")
end

for iter_0_1, iter_0_2 in pairs(var_0_31.states) do
	enableaa = antisetup[iter_0_1].enable
	checkboxaa = {
		enableaa,
		function()
			if iter_0_1 == 1 then
				return true
			else
				return antisetup[iter_0_1].enable:get()
			end
		end
	}
	selector = {
		var_0_31.general,
		var_0_31.states[iter_0_1]
	}

	antisetup[1].enable:depend(true)
	antisetup[iter_0_1].enable:depend(var_0_31.enablesetup, selector, {
		var_0_31.general,
		function()
			return iter_0_1 ~= 1
		end
	})
	antisetup[iter_0_1].yaw_typekurwa:depend(var_0_31.enablesetup, selector, checkboxaa)
	antisetup[iter_0_1].yaw_typekurwa2:depend(var_0_31.enablesetup, selector, checkboxaa)
	antisetup[iter_0_1].pitch:depend(var_0_31.enablesetup, selector, checkboxaa)
	antisetup[iter_0_1].yaw_base:depend(var_0_31.enablesetup, selector, checkboxaa)
	antisetup[iter_0_1].yaw_general:depend(var_0_31.enablesetup, checkboxaa, selector, {
		antisetup[iter_0_1].yaw_typekurwa2,
		function()
			if antisetup[iter_0_1].yaw_typekurwa2:get() == "L & R" then
				return false
			else
				return true
			end
		end
	})
	antisetup[iter_0_1].yaw_l:depend(var_0_31.enablesetup, checkboxaa, selector, {
		antisetup[iter_0_1].yaw_typekurwa2,
		function()
			if antisetup[iter_0_1].yaw_typekurwa2:get() == "Normal" then
				return false
			else
				return true
			end
		end
	})
	antisetup[iter_0_1].yaw_r:depend(var_0_31.enablesetup, checkboxaa, selector, {
		antisetup[iter_0_1].yaw_typekurwa2,
		function()
			if antisetup[iter_0_1].yaw_typekurwa2:get() == "Normal" then
				return false
			else
				return true
			end
		end
	})
	antisetup[iter_0_1].jitterek_tryb:depend(var_0_31.enablesetup, checkboxaa, selector)
	antisetup[iter_0_1].jitterek2_left:depend(var_0_31.enablesetup, checkboxaa, selector, {
		antisetup[iter_0_1].jitterek_tryb,
		function()
			if antisetup[iter_0_1].jitterek_tryb:get() == "Disabled" then
				return false
			else
				return true
			end
		end
	})
	antisetup[iter_0_1].jitterek2_right:depend(var_0_31.enablesetup, checkboxaa, selector, {
		antisetup[iter_0_1].jitterek_tryb,
		function()
			if antisetup[iter_0_1].jitterek_tryb:get() == "Disabled" then
				return false
			else
				return true
			end
		end
	})
	antisetup[iter_0_1].bodyyaw:depend(var_0_31.enablesetup, checkboxaa, selector)
	antisetup[iter_0_1].left:depend(var_0_31.enablesetup, antisetup[iter_0_1].bodyyaw, checkboxaa, selector)
	antisetup[iter_0_1].right:depend(var_0_31.enablesetup, antisetup[iter_0_1].bodyyaw, checkboxaa, selector)
	antisetup[iter_0_1].options:depend(var_0_31.enablesetup, antisetup[iter_0_1].bodyyaw, checkboxaa, selector)
	antisetup[iter_0_1].freestand:depend(var_0_31.enablesetup, antisetup[iter_0_1].bodyyaw, checkboxaa, selector)
	antisetup[iter_0_1].defensive_aa:depend(var_0_31.enablesetup, checkboxaa, selector)
	antisetup[iter_0_1].defensive_hardmode:depend(var_0_31.enablesetup, antisetup[iter_0_1].defensive_aa, checkboxaa, selector)
	antisetup[iter_0_1].pitchtype:depend(var_0_31.enablesetup, antisetup[iter_0_1].defensive_aa, checkboxaa, selector)
	antisetup[iter_0_1].defensive_pitch:depend(var_0_31.enablesetup, antisetup[iter_0_1].defensive_aa, {
		antisetup[iter_0_1].pitchtype,
		"Custom"
	}, checkboxaa, selector)
	antisetup[iter_0_1].defensive_yaw_type:depend(var_0_31.enablesetup, antisetup[iter_0_1].defensive_aa, checkboxaa, selector)
end

local function var_0_38()
	if var_0_33.clearconsole:get() then
		utils.console_exec("clear")
	end
end

local function var_0_39(arg_18_0)
	var_0_29.backstab:set(var_0_31.extra:get("Anti Backstab") and var_0_31.enableextra:get())
end

local function var_0_40(arg_19_0)
	local var_19_0 = entity.get_local_player()

	if not var_19_0 or not var_19_0:is_alive() then
		return
	end

	local var_19_1

	var_19_1 = bit.band(var_19_0.m_fFlags, 1) == 1

	local var_19_2 = bit.band(var_19_0.m_fFlags, 1) == 0
	local var_19_3 = var_19_0.m_flDuckAmount > 0.5
	local var_19_4 = var_19_0.m_vecVelocity.x
	local var_19_5 = var_19_0.m_vecVelocity.y
	local var_19_6

	var_19_6 = math.sqrt(var_19_4^2 + var_19_5^2) > 5

	local var_19_7 = false
	local var_19_8 = entity.get_local_player():get_player_weapon():get_weapon_index()

	if var_0_31.extra:get("Safe head") and var_0_31.enableextra:get() then
		if var_19_8 == 508 and var_19_2 and var_19_3 or var_19_2 then
			var_19_7 = true
		end
	elseif var_0_31.extra:get("Safe head") and var_0_31.enableextra:get() then
		if var_19_8 == 31 and var_19_2 and var_19_3 or var_19_2 then
			var_19_7 = true
		end
	else
		var_19_7 = false
	end

	if var_19_7 and var_19_8 == 508 then
		var_0_29.yaw_offset:override(0)
		var_0_29.yaw_modoff:override(0)
		var_0_29.yaw_mode:override("Disabled")
		var_0_29.options:override("")
		var_0_29.disableyaw:set(true)
		var_0_29.hidden:set(false)
	else
		return
	end
end

local function var_0_41(arg_20_0)
	local var_20_0 = antisetup[state].defensive_aa:get()
	local var_20_1 = antisetup[state].defensive_yaw_type:get()
	local var_20_2 = antisetup[state].pitchtype:get()
	local var_20_3 = antisetup[state].defensive_pitch:get()
	local var_20_4 = antisetup[state].defensive_hardmode:get()

	if var_20_4 == "Always on" then
		stage2 = true
	elseif var_20_4 == "Hold Ticks" then
		stage2 = arg_20_0.tickcount % 5 < 3
	elseif var_20_4 == "Ideal" then
		stage2 = arg_20_0.tickcount % 10 < 3
	end

	if var_20_0 and stage2 then
		if var_20_2 == "Zero" then
			pitchs = 0
		elseif var_20_2 == "Down" then
			pitchs = 89
		elseif var_20_2 == "Up" then
			pitchs = -89
		elseif var_20_2 == "Random" then
			pitchs = math.random(-89, 89)
		else
			pitchs = var_20_3
		end

		rage.antiaim:override_hidden_pitch(pitchs)

		if var_20_1 == "Stage" then
			local var_20_5 = arg_20_0.tickcount % 3
			local var_20_6 = {
				[-1] = {
					max = -90,
					min = -110
				},
				[0] = {
					max = 120,
					min = 90
				},
				{
					max = -150,
					min = -180
				}
			}

			if var_20_6[var_20_5] then
				local var_20_7 = var_20_6[var_20_5]
				local var_20_8 = utils.random_int(var_20_7.min, var_20_7.max)

				rage.antiaim:override_hidden_yaw_offset(var_20_8)
			end
		elseif var_20_1 == "Maximum" then
			rage.antiaim:override_hidden_yaw_offset(-180)
		elseif var_20_1 == "Static" then
			rage.antiaim:override_hidden_yaw_offset(0)
		elseif var_20_1 == "Spin" then
			local var_20_9 = globals.curtime * 750

			rage.antiaim:override_hidden_yaw_offset(var_20_9)
		elseif var_20_1 == "Sideways" then
			local var_20_10 = arg_20_0.tickcount % 3

			if var_20_10 == 0 then
				rage.antiaim:override_hidden_yaw_offset(utils.random_int(-100, -90))
			elseif var_20_10 == 1 then
				rage.antiaim:override_hidden_yaw_offset(180)
			elseif var_20_10 == 2 then
				rage.antiaim:override_hidden_yaw_offset(utils.random_int(90, 100))
			end
		end

		var_0_29.hidden:override(var_20_0)
		var_0_29.lag:override("Always On")
		var_0_29.hsopt:override("Break LC")
	else
		var_0_29.lag:override()
		var_0_29.hsopt:override()
	end
end

local function var_0_42(arg_21_0)
	local var_21_0 = var_0_31.manual_aa:get()

	if var_21_0 == "Left" then
		var_0_29.yaw_offset:override(-90)
		var_0_29.options:override("")
	elseif var_21_0 == "Right" then
		var_0_29.yaw_offset:override(90)
		var_0_29.options:override("")
	elseif var_21_0 == "Forward" then
		var_0_29.yaw_offset:override(-180)
		var_0_29.options:override("")
	end
end

local function var_0_43(arg_22_0)
	var_0_29.freestand:override(var_0_31.freestanding:get())
	var_0_29.freestand:set(var_0_31.freestanding:get())

	if var_0_31.freestanding:get() then
		var_0_29.hidden:set(false)
		var_0_29.yaw_offset:set(0)
		var_0_29.disableyaw:set(true)
		var_0_29.options:set("")
		var_0_29.yaw_modoff:set(0)
	end
end

local function var_0_44()
	if var_0_33.throw:get() then
		local var_23_0 = entity.get_local_player():get_player_weapon():get_weapon_info().weapon_name

		if var_23_0 == "weapon_molotov" or var_23_0 == "weapon_hegrenade" or var_23_0 == "weapon_smokegrenade" then
			ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):reset()
		else
			ui.find("Miscellaneous", "Main", "Other", "Weapon Actions"):set(var_0_17)
		end
	end
end

local function var_0_45(arg_24_0)
	local var_24_0 = antisetup[state].yaw_typekurwa:get()
	local var_24_1 = antisetup[state].yaw_typekurwa2:get()
	local var_24_2 = antisetup[state].yaw_general:get()
	local var_24_3 = antisetup[state].yaw_l:get()
	local var_24_4 = antisetup[state].yaw_r:get()
	local var_24_5 = antisetup[state].jitterek_tryb:get()
	local var_24_6 = antisetup[state].jitterek2_left:get()
	local var_24_7 = antisetup[state].jitterek2_right:get()
	local var_24_8 = antisetup[state].bodyyaw:get()
	local var_24_9 = antisetup[state].options:get()
	local var_24_10 = antisetup[state].freestand:get()
	local var_24_11 = antisetup[state].right:get()
	local var_24_12 = antisetup[state].left:get()

	if not entity.get_local_player() then
		return
	end

	bodyyaw = entity.get_local_player().m_flPoseParameter[11] * 120 - 60
	side = bodyyaw > 0 and 1 or -1

	var_0_29.yaw_mode:override(var_24_5)
	var_0_29.yaw:override("Backward")
	var_0_29.bodyyaw:override(var_24_8)
	var_0_29.right_limit:override(antisetup[state].right:get())
	var_0_29.left_limit:override(antisetup[state].left:get())
	var_0_29.options:override(var_24_9)
	var_0_29.freestanding:override(var_24_10)
	var_0_29.pitch:override(antisetup[state].pitch:get())
	var_0_29.yaw:override(antisetup[state].yaw_base:get())
	var_0_29.yaw_base:override(antisetup[state].yaw_base_type:get())
	var_0_29.yaw_modoff:override(side == 1 and var_24_6 or var_24_7)

	if var_24_5 == "Disabled" then
		var_0_29.yaw_modoff:override(center)
	else
		var_0_29.yaw_modoff:override(side == 1 and var_24_6 or var_24_7)
		var_0_29.options:override("Jitter")
	end

	if var_24_0 == "Default" then
		if globals.tickcount % 1 == 1 then
			switch = not switch
		end

		if var_24_1 == "L & R" then
			if globals.choked_commands ~= 0 then
				return
			end

			var_0_29.yaw_offset:override(side == 1 and antisetup[state].yaw_l:get() or antisetup[state].yaw_r:get())
			var_0_29.options:set("Jitter")
		elseif var_24_1 == "Normal" then
			var_0_29.yaw_offset:override(var_24_2)
		end
	elseif var_24_0 == "Slow Jitter" then
		if globals.tickcount % 6 == 1 then
			switch = not switch
		end

		if var_24_1 == "L & R" then
			var_0_29.yaw_offset:override(switch and antisetup[state].yaw_l:get() or antisetup[state].yaw_r:get())
			var_0_29.yaw_mode:override("Disabled")
			var_0_29.options:override("")
		else
			var_0_29.yaw_offset:override(switch and 0 or 0)
			var_0_29.yaw_mode:override("Disabled")
			var_0_29.options:override("")
		end
	elseif var_24_0 == "Sway" then
		if globals.choked_commands ~= 0 then
			return
		end

		var_0_29.yaw_offset:override(side == 1 and antisetup[state].yaw_l:get() or antisetup[state].yaw_r:get())
		var_0_29.options:override("Jitter", "Randomize Jitter")
		var_0_29.yaw_mode:override("Disabled")
	end
end

local function var_0_46(arg_25_0)
	var_0_29.enable:set(var_0_31.enablesetup:get())

	if not var_0_31.enablesetup:get() then
		return
	end

	var_0_39(arg_25_0)

	local var_25_0 = entity.get_local_player()

	if not var_25_0 or not var_25_0:is_alive() then
		return
	end

	local var_25_1 = bit.band(var_25_0.m_fFlags, 1) == 1
	local var_25_2 = bit.band(var_25_0.m_fFlags, 1) == 0
	local var_25_3 = var_25_0.m_flDuckAmount > 0.5
	local var_25_4 = var_25_0.m_vecVelocity.x
	local var_25_5 = var_25_0.m_vecVelocity.y
	local var_25_6 = math.sqrt(var_25_4^2 + var_25_5^2) > 5

	if antisetup[2].enable:get() and var_25_1 and not var_25_6 and not var_25_3 then
		state = 2
	elseif antisetup[3].enable:get() and var_25_1 and var_25_6 and not var_25_3 then
		state = 3
	elseif antisetup[5].enable:get() and var_25_3 and not var_25_2 then
		state = 5
	elseif antisetup[6].enable:get() and var_25_2 and not var_25_3 then
		state = 6
	elseif antisetup[7].enable:get() and var_25_2 and var_25_3 then
		state = 7
	else
		state = 1
	end

	var_0_45(arg_25_0)
	var_0_41(arg_25_0)
	var_0_42(arg_25_0)
	var_0_43(arg_25_0)
	var_0_40(arg_25_0)
end

local var_0_47 = {
	type_from_string = function(arg_26_0)
		if type(arg_26_0) ~= "string" then
			return arg_26_0
		end

		local var_26_0 = arg_26_0:lower()

		if var_26_0 == "true" then
			return true
		elseif var_26_0 == "false" then
			return false
		elseif tonumber(var_26_0) ~= nil then
			return tonumber(var_26_0)
		else
			return tostring(arg_26_0)
		end
	end,
	lerp = function(arg_27_0, arg_27_1, arg_27_2)
		return arg_27_0 + (arg_27_1 - arg_27_0) * arg_27_2
	end,
	vec_angles = function(arg_28_0, arg_28_1)
		local var_28_0 = math.sin(math.rad(arg_28_1))
		local var_28_1 = math.cos(math.rad(arg_28_1))
		local var_28_2 = math.sin(math.rad(arg_28_0))
		local var_28_3 = math.cos(math.rad(arg_28_0))

		return var_28_3 * var_28_1, var_28_3 * var_28_0, -var_28_2
	end,
	hex = function(arg_29_0)
		local var_29_0 = "\a"

		for iter_29_0, iter_29_1 in next, arg_29_0 do
			local var_29_1 = ""

			while iter_29_1 > 0 do
				local var_29_2 = math.fmod(iter_29_1, 16) + 1

				iter_29_1 = math.floor(iter_29_1 / 16)
				var_29_1 = string.sub("0123456789ABCDEF", var_29_2, var_29_2) .. var_29_1
			end

			if #var_29_1 == 0 then
				var_29_1 = "00"
			elseif #var_29_1 == 1 then
				var_29_1 = "0" .. var_29_1
			end

			var_29_0 = var_29_0 .. var_29_1
		end

		return var_29_0 .. "FF"
	end,
	split = function(arg_30_0, arg_30_1)
		if arg_30_1 == nil then
			arg_30_1 = "%s"
		end

		local var_30_0 = {}

		for iter_30_0 in string.gmatch(arg_30_0, "([^" .. arg_30_1 .. "]+)") do
			table.insert(var_30_0, iter_30_0)
		end

		return var_30_0
	end,
	RGBAtoHEX = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
		return string.format("%.2x%.2x%.2x%.2x", arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	end,
	easeInOut = function(arg_32_0)
		return arg_32_0 > 0.5 and 4 * (arg_32_0 - 1)^3 + 1 or 4 * arg_32_0^3
	end,
	clamp = function(arg_33_0, arg_33_1, arg_33_2)
		return arg_33_0 < arg_33_1 and arg_33_1 or arg_33_2 < arg_33_0 and arg_33_2 or arg_33_0
	end
}

local function var_0_48(arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_0 = "\a" .. var_0_47.RGBAtoHEX(arg_34_1, arg_34_2, arg_34_3, arg_34_4)
	local var_34_1 = "\a" .. var_0_47.RGBAtoHEX(255, 255, 255, arg_34_4)
	local var_34_2 = ""

	for iter_34_0, iter_34_1 in ipairs(var_0_47.split(arg_34_0, "$")) do
		var_34_2 = var_34_2 .. (iter_34_0 % 2 == (arg_34_0:sub(1, 1) == "$" and 0 or 1) and var_34_1 or var_34_0) .. iter_34_1
	end

	return var_34_2
end

local var_0_49 = 0.3
local var_0_50 = 6
local var_0_51 = {}
local var_0_52 = {}

function notifications1(arg_35_0, arg_35_1)
	local var_35_0 = {
		duration = 4,
		alpha = 255,
		sender = arg_35_0,
		message = arg_35_1,
		startTime = globals.realtime
	}

	table.insert(var_0_52, var_35_0)
end

function math.lerp(arg_36_0, arg_36_1, arg_36_2)
	return arg_36_0 + (arg_36_1 - arg_36_0) * globals.frametime * arg_36_2
end

function notifications_setup()
	local var_37_0 = var_0_5.x / 2
	local var_37_1 = var_0_5.y / 1.4
	local var_37_2 = 0
	local var_37_3 = 7
	local var_37_4 = 20
	local var_37_5 = 0
	local var_37_6 = 1.5
	local var_37_7 = var_0_14 - 1
	local var_37_8 = 5
	local var_37_9 = 3
	local var_37_10 = {}

	for iter_37_0 = #var_0_52, 1, -1 do
		local var_37_11 = var_0_52[iter_37_0]

		if var_37_9 <= globals.realtime - var_37_11.startTime then
			var_37_11.markedForRemoval = true
		end
	end

	for iter_37_1 = #var_0_52, 1, -1 do
		local var_37_12 = var_0_52[iter_37_1]
		local var_37_13 = globals.realtime - var_37_12.startTime

		if var_37_13 < var_37_9 then
			local var_37_14 = var_0_10.linear(var_37_13, 0, 7, var_37_9)
			local var_37_15 = vector(var_37_0, var_37_1 - var_37_2)
			local var_37_16 = 255 * var_37_14

			if var_37_7 <= var_37_13 and var_37_12.fadeOutStart then
				local var_37_17 = globals.realtime - var_37_12.fadeOutStart
				local var_37_18 = var_0_10.quad_out(var_37_17, 0, 7, var_37_8)

				var_37_16 = math.lerp(var_37_16, 0, 10 * var_37_18)
			end

			if var_37_16 < 0.1 or not entity.get_local_player() then
				table.insert(var_37_10, iter_37_1)
			else
				local var_37_19 = color(255, 255, 255, var_37_16)

				var_37_2 = var_37_2 + var_37_4 + var_37_5 * var_37_14

				render.text(1, var_37_15, var_37_19, var_37_12.sender, var_37_12.message)
			end
		end
	end

	for iter_37_2 = #var_0_52, 1, -1 do
		local var_37_20 = var_0_52[iter_37_2]

		if var_37_20.markedForRemoval then
			if var_37_20.fadeOutStart == nil then
				var_37_20.fadeOutStart = globals.realtime
			end

			local var_37_21 = globals.realtime - var_37_20.fadeOutStart
			local var_37_22 = 255 * (1 - var_0_10.quad_out(var_37_21, 0, 5, var_37_8))

			if var_37_8 <= var_37_21 then
				table.remove(var_0_52, iter_37_2)
			else
				local var_37_23 = vector(var_37_0, var_37_1 - var_37_2)
				local var_37_24 = color(255, 255, 255, var_37_22)

				var_37_2 = var_37_2 + var_37_4 + var_37_5

				render.text(1, var_37_23, var_37_24, var_37_20.sender, var_37_20.message)
			end
		end
	end

	for iter_37_3, iter_37_4 in ipairs(var_37_10) do
		local var_37_25 = var_0_52[iter_37_4]

		if var_37_25.markedForRemoval then
			if var_37_25.fadeOutStart == nil then
				var_37_25.fadeOutStart = globals.realtime
			end

			local var_37_26 = globals.realtime - var_37_25.fadeOutStart
			local var_37_27 = 255 * (1 - var_0_10.quad_out(var_37_26, 0, 5, var_37_8))

			if var_37_8 <= var_37_26 then
				table.remove(var_0_52, i)
			else
				local var_37_28 = vector(var_37_0, var_37_1 - var_37_2)
				local var_37_29 = color(255, 255, 255, var_37_27)

				var_37_2 = var_37_2 + var_37_4 + var_37_5

				render.text(1, var_37_28, var_37_29, var_37_25.sender, var_37_25.message)
			end
		end
	end

	if var_37_3 < #var_0_52 then
		local var_37_30 = #var_0_52 - var_37_3

		for iter_37_5 = 1, var_37_30 do
			table.remove(var_0_52, 1)
		end
	end
end

local function var_0_53()
	notifications2.logs = {}
end

;(function()
	cvar.clear:call()

	local var_39_0 = var_0_0.text_animate("♛ A S T R A ♛ ", 2, {
		color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
		color()
	})

	var_39_0:animate()
	notifications1("c", var_39_0:get_animated_text())
end)()

local var_0_54 = {
	[0] = "generic",
	"head",
	"chest",
	"stomach",
	"left arm",
	"right arm",
	"left leg",
	"right leg",
	"neck",
	"generic",
	"gear"
}

local function var_0_55(arg_40_0)
	if var_0_32.logs:get() then
		if not entity.get_local_player() then
			return
		end

		local var_40_0 = entity.get(arg_40_0.target)
		local var_40_1 = arg_40_0.damage
		local var_40_2 = math.max(arg_40_0.target.m_iHealth, 0)
		local var_40_3 = tostring(var_40_2)
		local var_40_4 = var_0_54[arg_40_0.wanted_hitgroup]
		local var_40_5 = var_0_54[arg_40_0.hitgroup]
		local var_40_6 = arg_40_0.hitchance
		local var_40_7 = arg_40_0.state
		local var_40_8 = arg_40_0.backtrack

		if var_40_7 == nil then
			hitted = hitted + 1

			local var_40_9 = string.format("\aA1FF8FFF🎯 \aDEFAULTHit \aA1FF8FFF%s's \aDEFAULTin the \aA1FF8FFF%s \aDEFAULTfor \aA1FF8FFF%d \aDEFAULTdamage \aDEFAULT(\aA1FF8FFF%s \aDEFAULThealth remaining)", var_40_0:get_name(), var_40_5, var_40_1, var_40_3)

			notifications1("c", var_40_9)
		elseif var_40_7 == "unregistered shot" then
			return
		else
			local var_40_10 = var_0_54[arg_40_0.hitgroup]

			missed = missed + 1

			local var_40_11 = string.format("\aE42F2FFF☠️ Missed \aE42F2FFF%s's \aDEFAULTdue to \aE42F2FFF%s \aDEFAULT(hitchance: \aE42F2FFF%s\aDEFAULT)", var_40_0:get_name(), var_40_7, var_40_6)

			notifications1("c", var_40_11)
		end
	end
end

events.aim_ack:set(function(arg_41_0)
	var_0_55(arg_41_0)
end)
events.render:set(function()
	notifications_setup()
end)

local function var_0_56(arg_43_0)
	if var_0_33.fast_ladder:get() then
		local var_43_0 = entity.get_local_player()

		if var_43_0 == nil then
			return
		end

		if var_43_0.m_MoveType == 9 then
			arg_43_0.view_angles.y = math.floor(arg_43_0.view_angles.y + 0.5)

			if arg_43_0.forwardmove > 0 then
				if arg_43_0.view_angles.x < 45 then
					arg_43_0.view_angles.x = 89
					arg_43_0.in_moveright = 1
					arg_43_0.in_moveleft = 0
					arg_43_0.in_forward = 0
					arg_43_0.in_back = 1

					if arg_43_0.sidemove == 0 then
						arg_43_0.view_angles.y = arg_43_0.view_angles.y + 90
					elseif arg_43_0.sidemove < 0 then
						arg_43_0.view_angles.y = arg_43_0.view_angles.y + 150
					elseif arg_43_0.sidemove > 0 then
						arg_43_0.view_angles.y = arg_43_0.view_angles.y + 30
					end
				end
			elseif arg_43_0.forwardmove < 0 then
				arg_43_0.view_angles.x = 89
				arg_43_0.in_moveleft = 1
				arg_43_0.in_moveright = 0
				arg_43_0.in_forward = 1
				arg_43_0.in_back = 0

				if arg_43_0.sidemove == 0 then
					arg_43_0.view_angles.y = arg_43_0.view_angles.y + 90
				elseif arg_43_0.sidemove > 0 then
					arg_43_0.view_angles.y = arg_43_0.view_angles.y + 150
				elseif arg_43_0.sidemove < 0 then
					arg_43_0.view_angles.y = arg_43_0.view_angles.y + 30
				end
			end
		end
	end
end

local function var_0_57()
	if not var_0_32.indicators:get() then
		local var_44_0 = 1.5
		local var_44_1 = math.abs(math.sin(globals.realtime * var_44_0)) * 255

		if not globals.is_in_game then
			return
		end

		local var_44_2 = var_0_0.text_animate("♛ A S T R A", 2, {
			color(ui.get_style()["Link Active"].r, ui.get_style()["Link Active"].g, ui.get_style()["Link Active"].b, 255),
			color()
		})

		render.text(1, vector(45, render.screen_size().y / 2), color(), "c", var_44_2:get_animated_text() .. " ♛")
		var_44_2:animate()
	end
end

local var_0_58 = 0

local function var_0_59()
	local var_45_0 = var_0_0.text_animate("D  E  F  E  N  S  I  V  E ", 2, {
		var_0_32.defensiveind_color1:get(),
		var_0_32.defensiveind_color2:get()
	})

	if var_0_32.defensiveind:get() then
		local var_45_1 = entity.get_local_player()

		if not var_45_1 or not var_45_1:is_alive() then
			return
		end

		if var_0_4(entity.get_local_player(), true) > 2 then
			local var_45_2 = render.screen_size().x
			local var_45_3 = render.screen_size().y

			render.text(2, vector(var_45_2 / 2, var_45_3 / 2 - 149), color(), "c", var_45_0:get_animated_text())
			render.text(2, vector(var_45_2 / 2, var_45_3 / 2 - 160), color(), "c", math.random(0, 100) .. "%")

			draw_art = var_0_58 * 100 / 80

			local var_45_4 = vector(var_45_2 / 2 - 50, var_45_3 / 2 - 138)
			local var_45_5 = vector(var_45_2 / 2 + 50, var_45_3 / 2 - 134)
			local var_45_6 = vector(var_45_2 / 2 - 10 - draw_art / 2, var_45_3 / 2 - 138)
			local var_45_7 = vector(var_45_2 / 2 + 10 + draw_art / 2, var_45_3 / 2 - 134)

			render.rect(var_45_6, var_45_7, var_0_32.defensiveind_color2:get(), 2)
			render.shadow(var_45_4, var_45_5, var_0_32.defensiveind_color1:get(), 20, 0)
		end

		var_0_58 = var_0_58 + 1

		if var_0_58 > 70 then
			var_0_58 = 0
		end
	end

	var_45_0:animate()
end

function calculatePercentage(arg_46_0, arg_46_1)
	return arg_46_0 / arg_46_1 * 100
end

local function var_0_60()
	local var_47_0 = var_0_0.text_animate("VELOCITY  DECRESED", 2, {
		var_0_32.velocityind_color1:get(),
		var_0_32.velocityind_color2:get()
	})

	if var_0_32.velocityind:get() then
		local var_47_1 = entity.get_local_player()

		if not var_47_1 or not var_47_1:is_alive() then
			return
		end

		local var_47_2 = ui.find("Aimbot", "Ragebot", "Main", "Double Tap"):get()

		if entity.get_local_player() == nil then
			return
		end

		local var_47_3 = entity.get_local_player().m_flVelocityModifier * 100
		local var_47_4 = var_47_3 * 98 / 100

		if var_47_3 < 100 then
			local var_47_5 = render.screen_size().x
			local var_47_6 = render.screen_size().y

			render.text(2, vector(var_47_5 / 2, var_47_6 / 2 - 184), color(), "c", var_47_0:get_animated_text())

			local var_47_7 = vector(var_47_5 / 2 - 50, var_47_6 / 2 - 175)
			local var_47_8 = vector(var_47_5 / 2 + 50, var_47_6 / 2 - 171)
			local var_47_9 = vector(var_47_5 / 2 - 10 - var_47_3 / 2.5, var_47_6 / 2 - 175)
			local var_47_10 = vector(var_47_5 / 2 + 10 + var_47_3 / 2.5, var_47_6 / 2 - 171)

			render.rect(var_47_9, var_47_10, var_0_32.velocityind_color1:get(), 2)
			render.shadow(var_47_7, var_47_8, var_0_32.velocityind_color2:get(), 20, 0)
		end
	end

	var_47_0:animate()
end

local function var_0_61()
	local var_48_0 = render.screen_size().x
	local var_48_1 = render.screen_size().y

	if entity.get_local_player() == nil then
		return
	end

	if entity.get_local_player():is_alive() == false then
		return
	end

	if entity.get_local_player():get_player_weapon() == nil then
		return
	end

	local var_48_2 = entity.get_local_player():get_player_weapon():get_weapon_index()
	local var_48_3 = var_48_2 == 43 or var_48_2 == 44 or var_48_2 == 45 or var_48_2 == 46 or var_48_2 == 47 or var_48_2 == 48
	local var_48_4 = var_0_0.text_animate("ASTRA ", 1, {
		var_0_32.indicators_color1:get(),
		var_0_32.indicators_color2:get()
	})
	local var_48_5 = var_0_0.text_animate(string.upper(var_0_18.build), -1, {
		var_0_32.indicators_color1:get(),
		var_0_32.indicators_color2:get()
	})
	local var_48_6 = (function(arg_49_0)
		local var_49_0 = arg_49_0["m_vecVelocity[0]"]
		local var_49_1 = arg_49_0["m_vecVelocity[1]"]

		return (math.sqrt(var_49_0 * var_49_0 + var_49_1 * var_49_1))
	end)(entity.get_local_player())
	local var_48_7 = bit.band(entity.get_local_player().m_fFlags, bit.lshift(1, 0)) == 0
	local var_48_8 = entity.get_local_player().m_flDuckAmount > 0.8

	if var_48_6 < 5 and not var_48_8 and not var_48_7 then
		states = "STANDING"
	elseif not var_48_7 and var_48_6 > 4 and not var_48_8 then
		states = "MOVING"
	elseif var_48_7 and not var_48_8 then
		states = "AERIAL"
	elseif var_48_7 and var_48_8 then
		states = "AERO+C"
	elseif not var_48_7 and var_48_8 then
		states = "CROUCHING"
	elseif not var_48_7 and move and var_48_8 then
		states = "CROUCHING"
	elseif var_0_29.slow:get() then
		states = "SLOW-WALK"
	end

	local var_48_9 = 1.5

	state_alpha = math.abs(math.sin(globals.realtime * var_48_9)) * 255

	if state_alpha == 0 then
		state_alpha = 50
	end

	firstvalue = lerp(globals.frametime * 16, firstvalue, entity.get_local_player().m_bIsScoped and var_48_0 / 2 + 43 or var_48_0 / 2)
	alphadouble = lerp(globals.frametime * 8, alphadouble, var_0_29.dt:get() and (var_48_3 and 100 or 255) or 0)
	hsalpha = lerp(globals.frametime * 8, hsalpha, var_0_29.hideshots:get() and (var_48_3 and 100 or 255) or 0)
	dmgalpha = lerp(globals.frametime * 8, dmgalpha, override == true and (var_48_3 and 100 or 255) or 0)

	render.text(2, vector(firstvalue, var_48_1 / 2 + 20), color(), "c", var_48_4:get_animated_text() .. " " .. var_48_5:get_animated_text())

	if var_0_32.indicators_pulsate:get() then
		var_0_21("state", vector(firstvalue, var_48_1 / 2 + 30), 2, color(255, 255, 255, state_alpha), nil, states)
	else
		var_0_21("state", vector(firstvalue, var_48_1 / 2 + 30), 2, color(255, 255, 255, var_48_3 and 100 or 255 or 0), nil, states)
	end

	local var_48_10 = var_0_0.text_animate("READY", -0.5, {
		color(255, 255, 255, 255),
		color(154, 205, 50, 140)
	})
	local var_48_11 = var_0_0.text_animate("CHARGING", -0.5, {
		color(255, 255, 255, 255),
		color(255, 114, 114, 140)
	})
	local var_48_12 = var_0_0.text_animate("DEFENSIVE", -0.5, {
		color(255, 255, 255, 144),
		color(154, 205, 50, 140)
	})

	if var_0_29.dt:get() then
		var_0_21("dt", vector(firstvalue, var_48_1 / 2 + 40), 2 or 1, color(255, 255, 255, alphadouble), nil, rage.exploit:get() == 1 and "DT " .. (var_0_4(entity.get_local_player(), true) > 2 and var_48_12:get_animated_text() or "\aC0FF91FFREADY") or "DT " .. var_48_11:get_animated_text())
	elseif var_0_29.hideshots:get() and not var_0_29.dt:get() then
		var_0_21("onshotaa", vector(firstvalue, var_48_1 / 2 + 40), 2 or 1, color(255, 255, 255, hsalpha), nil, rage.exploit:get() == 1 and "OS " .. (var_0_4(entity.get_local_player(), true) > 2 and var_48_12:get_animated_text() or "\aC0FF91FFREADY") or "HIDE  " .. "\aFF9494FFCHARGING")
	end

	var_48_10:animate()
	var_48_5:animate()
	var_48_4:animate()
	var_48_11:animate()
	var_48_12:animate()
end

local function var_0_62()
	local var_50_0 = entity.get_local_player()

	if not var_50_0 or not var_50_0:is_alive() then
		return
	end

	move = math.sqrt(var_50_0.m_vecVelocity.x^2 + var_50_0.m_vecVelocity.y^2) > 5
	aerial = bit.band(var_50_0.m_fFlags, 1) == 0

	if var_0_32.groundanims:get() == "Follow" and var_0_32.animations:get() then
		var_50_0.m_flPoseParameter[0] = 1

		var_0_29.legs:set("Sliding")
	end

	if var_0_32.groundanims:get() == "Jitter" and var_0_32.animations:get() then
		var_50_0.m_flPoseParameter[0] = globals.tickcount % 4 > 1 and 0.5 or 1

		var_0_29.legs:set("Sliding")
	end

	if var_0_32.aerialanims:get() == "Static Legs" and var_0_32.animations:get() then
		var_50_0.m_flPoseParameter[6] = 1
	end

	if var_0_32.groundanims:get() == "Micheal Jackson" and var_0_32.animations:get() then
		var_50_0.m_flPoseParameter[7] = 1

		var_0_29.legs:set("Walking")
	end
end

events.post_update_clientside_animation(function()
	var_0_62()
end)

local function var_0_63(arg_52_0)
	if not var_0_33.shittalk:get() then
		return
	end

	local var_52_0 = entity.get_local_player()
	local var_52_1 = var_0_33.shittalk_setts:get("On kill")
	local var_52_2 = var_0_33.shittalk_setts:get("On death")

	if var_52_0 == nil or not var_52_0:is_alive() then
		return
	end

	local var_52_3 = entity.get(arg_52_0.attacker, true)
	local var_52_4 = entity.get(arg_52_0.userid, true)

	if var_52_0 == var_52_3 and var_52_4 ~= var_52_0 and var_52_1 then
		local var_52_5 = math.random(1, #var_0_26)

		utils.console_exec("say " .. var_0_26[var_52_5])
	end

	if var_52_4 == var_52_0 and var_52_3 ~= var_52_4 and var_52_2 then
		local var_52_6 = utils.random_int(1, #var_0_27)

		utils.console_exec("say " .. var_0_27[var_52_6])
	end
end

events.player_death:set(function(arg_53_0)
	var_0_63(arg_53_0)
end)

local function var_0_64()
	if var_0_32.viewmodel:get() then
		cvar.viewmodel_fov:int(var_0_32.viewmodel_fov:get(), true)
		cvar.viewmodel_offset_x:float(var_0_32.viewmodel_x:get(), true)
		cvar.viewmodel_offset_y:float(var_0_32.viewmodel_y:get(), true)
		cvar.viewmodel_offset_z:float(var_0_32.viewmodel_z:get(), true)
	else
		cvar.viewmodel_fov:int(68, true)
		cvar.viewmodel_offset_x:float(2.5, true)
		cvar.viewmodel_offset_y:float(0, true)
		cvar.viewmodel_offset_z:float(-1.5, true)
	end
end

aspect = 0

local function var_0_65()
	aspect = var_0_33.aspect_ratio_slider:get() / 100

	if var_0_33.aspect_ratio:get() then
		cvar.r_aspectratio:float(aspect)
	else
		cvar.r_aspectratio:float(0)
	end
end

local var_0_66 = 16680
local var_0_67 = var_0_16 .. "/neverlose/astra_icon.png"

var_0_33.shared_logo:set_callback(function(arg_56_0)
	local var_56_0 = entity.get_local_player()

	if var_56_0 == nil then
		return
	end

	if arg_56_0:get() then
		var_56_0:set_icon(var_0_67)
	else
		var_56_0:set_icon()
	end

	entity.get_players(false, true, function(arg_57_0)
		if not arg_56_0:get() then
			arg_57_0:set_icon()
		end
	end)
end)
events.voice_message(function(arg_58_0)
	if arg_58_0.buffer:read_bits(16) == var_0_66 then
		if var_0_33.shared_logo:get() then
			arg_58_0.entity:set_icon(var_0_67)
		else
			arg_58_0.entity:set_icon()
		end
	end
end)
events.voice_message:call(function(arg_59_0)
	if var_0_33.shared_logo:get() then
		arg_59_0:write_bits(var_0_66, 16)
	end
end)
events.round_start:set(function()
	events.voice_message:call(function(arg_61_0)
		arg_61_0:write_bits(var_0_66, 16)
	end)
	var_0_38()
end)
events.shutdown:set(function()
	cvar.viewmodel_fov:int(68)
	cvar.viewmodel_offset_x:float(2.5)
	cvar.viewmodel_offset_y:float(0)
	cvar.viewmodel_offset_z:float(-1.5)
	entity.get_players(false, true, function(arg_63_0)
		arg_63_0:set_icon()
	end)
end)
events.render:set(function()
	if var_0_32.indicators:get() then
		var_0_61()
	end

	var_0_59()
	var_0_60()
	var_0_57()
	var_0_35()
end)

local var_0_68 = var_0_3.setup({
	var_0_31,
	antisetup,
	var_0_33,
	var_0_32
}, true)
local var_0_69 = var_0_3.setup({
	var_0_31,
	antisetup
}, true)
local var_0_70 = {}
local var_0_71 = {}

configs_db = db.systemtable or {}
configs_db.cfg_list = configs_db.cfg_list or {}
configs_db.alloflist = configs_db.alloflist or {}
configs_db_cloud = db.systemtablecloud or {
	"Configs not found."
}
configs_db_cloudautors = db.systemtablecloudauthors or {
	"Unknown"
}
configs_db_cloudupdates = db.systemtablecloudupdates or {
	"Unknown"
}

function var_0_70.save_config(arg_65_0)
	if arg_65_0 == 0 or configs_db.alloflist[arg_65_0] == nil then
		return
	end

	local var_65_0 = var_0_68:save()

	configs_db.cfg_list[arg_65_0][2] = var_0_1.encode(json.stringify(var_65_0))
	db.systemtable = configs_db

	common.add_notify("Success", " Saved config!")
end

function var_0_70.create_config(arg_66_0)
	if type(arg_66_0) ~= "string" then
		return
	end

	if arg_66_0 == nil or arg_66_0 == "" or arg_66_0 == " " then
		return
	end

	for iter_66_0 = #configs_db.alloflist, 1, -1 do
		if configs_db.alloflist[iter_66_0] == arg_66_0 then
			common.add_notify("[Astra]", "Error: while naming config!")

			return
		end
	end

	if #configs_db.cfg_list > 6 then
		return
	end

	local var_66_0 = {
		arg_66_0,
		""
	}

	table.insert(configs_db.cfg_list, var_66_0)
	table.insert(configs_db.alloflist, arg_66_0)

	db.systemtable = configs_db

	common.add_notify("Success", "Created config!")
end

function var_0_70.removeconfig(arg_67_0)
	if arg_67_0 == 0 or configs_db.alloflist[arg_67_0] == nil then
		return
	end

	local var_67_0 = configs_db.cfg_list[arg_67_0][1]

	for iter_67_0 = #configs_db.cfg_list, 1, -1 do
		if configs_db.cfg_list[iter_67_0][1] == var_67_0 then
			table.remove(configs_db.cfg_list, iter_67_0)
			table.remove(configs_db.alloflist, iter_67_0)
		end
	end

	db.systemtable = configs_db

	common.add_notify("Success", "Removed config!")
end

function var_0_70.loadconfig(arg_68_0)
	if arg_68_0 == 0 or configs_db.alloflist[arg_68_0] == nil then
		return
	end

	if configs_db.cfg_list[arg_68_0][2] == nil or configs_db.cfg_list[arg_68_0][2] == "" then
		print(string.format("Error[data_base[%s]]", arg_68_0))

		return
	end

	if arg_68_0 > #configs_db.cfg_list then
		print(string.format("Error[data_base[%s]]", arg_68_0))

		return
	end

	var_0_68:load(json.parse(var_0_1.decode(configs_db.cfg_list[arg_68_0][2])))
	common.add_notify("Success", "Loaded config!")
end

configs = {
	selectedcfg = var_0_30.localconfigs:list("", configs_db.alloflist),
	name = var_0_30.localconfigs:input("Config \vname", "New Config"),
	create = var_0_30.localconfigs:button("• \v\f<circle-plus>\aDEFAULT Create \vconfig", function()
		var_0_70.create_config(configs.name:get())
		configs.selectedcfg:update(configs_db.alloflist)
	end, true),
	remove = var_0_30.localconfigs:button("• \v\f<trash>\aDEFAULT Remove \vconfig", function()
		var_0_70.removeconfig(configs.selectedcfg:get())
		configs.selectedcfg:update(configs_db.alloflist)
	end, true),
	save = var_0_30.localconfigs:button("• \v\f<file>\aDEFAULT Save \vconfig", function()
		var_0_70.save_config(configs.selectedcfg:get())
	end, true),
	load = var_0_30.localconfigs:button("• \v\f<circle-up>\aDEFAULT Load \vconfig", function()
		var_0_70.loadconfig(configs.selectedcfg:get())
		configs.selectedcfg:update(configs_db.alloflist)
	end, true),
	import = var_0_30.localconfigs:button("• \v\f<file-import>\aDEFAULT Import \vconfig", function()
		local var_73_0, var_73_1 = pcall(var_0_1.decode, var_0_2.get())

		if not var_73_0 then
			return
		end

		var_0_68:load(json.parse(var_0_1.decode(var_0_2.get())))
		common.add_notify("Success", "Imported config!")
	end, true),
	export = var_0_30.localconfigs:button("• \v\f<file-export>\aDEFAULT Export \vconfig", function()
		var_0_2.set(var_0_1.encode(json.stringify(var_0_68:save())))
		common.add_notify("Success", "Exported config!")
	end, true),
	uploadtocloud = var_0_30.localconfigs:button("• \v\f<upload>\aDEFAULT Share/Update config to \vcloud", function()
		local var_75_0 = configs.selectedcfg:get()

		if var_75_0 == 0 or configs_db.alloflist[var_75_0] == nil then
			return
		end

		if configs_db.cfg_list[var_75_0][2] == nil or configs_db.cfg_list[var_75_0][2] == "" then
			print(string.format("Error[data_base[%s]]", var_75_0))

			return
		end

		if var_75_0 > #configs_db.cfg_list then
			print(string.format("Error[data_base[%s]]", var_75_0))

			return
		end

		local var_75_1 = configs_db.cfg_list[var_75_0][2]
		local var_75_2 = configs_db.alloflist[var_75_0]

		network.post(var_0_16 .. "/neverlose/upload.php", {
			type = "save",
			key = var_0_15,
			username = var_0_18.username,
			build = var_0_18.build,
			configname = var_75_2,
			signature = var_0_19({
				var_0_18.username,
				var_0_18.build
			}),
			content = var_75_1
		}, {
			["Content-Type"] = "application/json"
		}, function(arg_76_0)
			local var_76_0 = json.parse(arg_76_0)

			if var_76_0.status == "success" then
				print(var_76_0.message)
				common.add_notify("Cloud Configs", var_76_0.message)
				var_0_71.refresh()
			else
				print(var_76_0.message)
				common.add_notify("Cloud Configs", var_76_0.message)
			end
		end)
	end, true)
}

local function var_0_72()
	local var_77_0 = cloudconfigs.selectedcfgcloud:get()

	if var_77_0 == nil then
		return
	end

	if db.systemtablecloudauthors == nil then
		return
	end

	local var_77_1 = db.systemtablecloudauthors[var_77_0]

	return cloudconfigs.currentuthor:name("\v\f<user>\aDEFAULT Created by: \v" .. var_77_1 .. "      ")
end

local function var_0_73()
	local var_78_0 = cloudconfigs.selectedcfgcloud:get()

	if var_78_0 == nil then
		return
	end

	if db.systemtablecloudupdates == nil then
		return
	end

	local var_78_1 = db.systemtablecloudupdates[var_78_0]

	return cloudconfigs.currentupdate:name("\v\f<calendar-days>\aDEFAULT Updated at: \v" .. var_78_1)
end

local function var_0_74(arg_79_0, arg_79_1)
	configs_db_cloud = db.systemtablecloud

	local var_79_0 = arg_79_0 .. " -📌"

	configs_db_cloud[arg_79_1] = var_79_0

	cloudconfigs.selectedcfgcloud:update(configs_db_cloud)
end

function var_0_71.refresh(arg_80_0)
	network.post(var_0_16 .. "/neverlose/refresh.php", {
		type = "refresh",
		key = var_0_15,
		username = var_0_18.username,
		build = var_0_18.build,
		signature = var_0_19({
			var_0_18.username,
			var_0_18.build
		})
	}, {
		["Content-Type"] = "application/json"
	}, function(arg_81_0)
		local var_81_0 = json.parse(arg_81_0)

		if arg_81_0 and var_81_0.configNames then
			db.systemtablecloud = var_81_0.configNames
			db.systemtablecloudauthors = var_81_0.configUsernames
			db.systemtablecloudupdates = var_81_0.configUpdates

			cloudconfigs.selectedcfgcloud:update(db.systemtablecloud)
			var_0_72()
			var_0_73()
			print("Successfully refreshed config list.")
			common.add_notify("Cloud Configs", "Successfully refreshed config list.")
		else
			print("Failed to refresh config list.")
			common.add_notify("Cloud Configs", "Failed to refresh config list.")
		end
	end)
end

cloudconfigs = {
	selectedcfgcloud = var_0_30.cloudconfigs:list("", configs_db_cloud),
	currentuthor = var_0_30.cloudconfigs:label("\v\f<user>\aDEFAULT Created by: \vUnknown"),
	currentupdate = var_0_30.cloudconfigs:label("\v\f<calendar-days>\aDEFAULT Updated at: \vUnknown"),
	refresh = var_0_30.cloudconfigs:button("• \v\f<loader>\aDEFAULT Refresh \vconfigs", function()
		var_0_71.refresh()
	end, true),
	remove = var_0_30.cloudconfigs:button("• \v\f<trash>\aDEFAULT Remove \vconfig ", function()
		local var_83_0 = cloudconfigs.selectedcfgcloud:get()
		local var_83_1 = db.systemtablecloud[var_83_0]

		network.post(var_0_16 .. "/neverlose/upload.php", {
			type = "delete",
			key = var_0_15,
			username = var_0_18.username,
			build = var_0_18.build,
			configname = var_83_1,
			signature = var_0_19({
				var_0_18.username,
				var_0_18.build
			})
		}, {
			["Content-Type"] = "application/json"
		}, function(arg_84_0)
			local var_84_0 = json.parse(arg_84_0)

			if var_84_0.status == "success" then
				print("Successfully deleted config.")
				common.add_notify("Cloud Configs", "Successfully deleted config.")
				var_0_71.refresh()
			else
				print(var_84_0.message)
				common.add_notify("Cloud Configs", var_84_0.message)
			end
		end)
	end, true),
	load = var_0_30.cloudconfigs:button("• \v\f<circle-up>\aDEFAULT Load \vconfig", function()
		local var_85_0 = cloudconfigs.selectedcfgcloud:get()
		local var_85_1 = db.systemtablecloud[var_85_0]

		network.post(var_0_16 .. "/neverlose/load.php", {
			type = "load",
			key = var_0_15,
			username = var_0_18.username,
			build = var_0_18.build,
			configname = var_85_1,
			signature = var_0_19({
				var_0_18.username,
				var_0_18.build
			})
		}, {
			["Content-Type"] = "application/json"
		}, function(arg_86_0)
			local var_86_0 = json.parse(arg_86_0)

			if var_86_0.status == "success" then
				var_0_74(var_85_1, var_85_0)
				var_0_69:load(json.parse(var_0_1.decode(var_86_0.configContent)))
				print("Successfully loaded config.")
				common.add_notify("Cloud Configs", "Successfully loaded config.")
			else
				print(var_86_0.message)
				common.add_notify("Cloud Configs", var_86_0.message)
				var_0_71.refresh()
			end
		end)
	end, true)
}

configs.selectedcfg:depend({
	cfgselection,
	1
})
configs.name:depend({
	cfgselection,
	1
})
configs.create:depend({
	cfgselection,
	1
})
configs.remove:depend({
	cfgselection,
	1
})
configs.save:depend({
	cfgselection,
	1
})
configs.load:depend({
	cfgselection,
	1
})
configs.import:depend({
	cfgselection,
	1
})
configs.export:depend({
	cfgselection,
	1
})
configs.uploadtocloud:depend({
	cfgselection,
	1
})
cloudconfigs.selectedcfgcloud:set_callback(function()
	var_0_72()
end)
cloudconfigs.selectedcfgcloud:set_callback(function()
	var_0_73()
end)
cloudconfigs.currentuthor:depend({
	cfgselection,
	2
})
cloudconfigs.currentupdate:depend({
	cfgselection,
	2
})
cloudconfigs.selectedcfgcloud:depend({
	cfgselection,
	2
})
cloudconfigs.remove:depend({
	cfgselection,
	2
})
cloudconfigs.refresh:depend({
	cfgselection,
	2
})
cloudconfigs.load:depend({
	cfgselection,
	2
})

local function var_0_75()
	var_0_71.refresh()
end

events.createmove:set(function(arg_90_0)
	var_0_46(arg_90_0)
	var_0_65()
	var_0_64()
	simulation_ticks()
	var_0_56(arg_90_0)
	var_0_44()
end)
var_0_75()
events.shutdown:set(function()
	db.systemtable = configs_db
end)
