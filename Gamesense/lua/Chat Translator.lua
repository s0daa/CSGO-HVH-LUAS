local var_0_0 = require("gamesense/http")
local var_0_1 = require("gamesense/chat")
local var_0_2 = require("gamesense/localize")
local var_0_3 = {
	"Afrikaans - af",
	"Albanian - sq",
	"Amharic - am",
	"Arabic - ar",
	"Armenian - hy",
	"Azerbaijani - az",
	"Basque - eu",
	"Belarusian - be",
	"Bengali - bn",
	"Bosnian - bs",
	"Bulgarian - bg",
	"Catalan - ca",
	"Cebuano - ceb",
	"Chinese (Simplified) - zh",
	"Chinese (Traditional) - zh-tw",
	"Corsican - co",
	"Croatian - hr",
	"Czech - cs",
	"Danish - da",
	"Dutch - nl",
	"English - en",
	"Esperanto - eo",
	"Estonian - et",
	"Finnish - fi",
	"French - fr",
	"Frisian - fy",
	"Galician - gl",
	"Georgian - ka",
	"German - de",
	"Greek - el",
	"Gujarati - gu",
	"Haitian Creole - ha",
	"Haitian Creole - ht",
	"Hawaiian - haw",
	"Hebrew - iw",
	"Hindi - hi",
	"Hmong - hmn",
	"Hungarian - hu",
	"Icelandic - is",
	"Igbo - ig",
	"Indonesian - id",
	"Irish - ga",
	"Italian - it",
	"Japanese - ja",
	"Javanese - jv",
	"Kannada - kn",
	"Kazakh - kk",
	"Khmer - km",
	"Kinyarwanda - rw",
	"Korean - ko",
	"Kurdish - ku",
	"Kyrgyz - ky",
	"Lao - lo",
	"Latvian - lv",
	"Lithuanian - lt",
	"Luxembourgish - lb",
	"Macedonian - mk",
	"Malagasy - mg",
	"Malay - ms",
	"Malayalam - ml",
	"Maltese - mt",
	"Maori - mi",
	"Marathi - mr",
	"Mongolian - mn",
	"Myanmar (Burmese) - my",
	"Nepali - ne",
	"Norwegian - no",
	"Nyanja (Chichewa) - ny",
	"Odia (Oriya) - or",
	"Pashto - ps",
	"Persian - fa",
	"Polish - pl",
	"Portuguese (Portugal, Brazil) - pt",
	"Punjabi - pa",
	"Romanian - ro",
	"Russian - ru",
	"Samoan - sm",
	"Scots Gaelic - gd",
	"Serbian - sr",
	"Sesotho - st",
	"Shona - sn",
	"Sindhi - sd",
	"Sinhala (Sinhalese) - si",
	"Slovak - sk",
	"Slovenian - sl",
	"Somali - so",
	"Spanish - es",
	"Sundanese - su",
	"Swahili - sw",
	"Swedish - sv",
	"Tagalog (Filipino) - tl",
	"Tajik - tg",
	"Tamil - ta",
	"Tatar - tt",
	"Telugu - te",
	"Thai - th",
	"Turkish - tr",
	"Turkmen - tk",
	"Ukrainian - uk",
	"Urdu - ur",
	"Uyghur - ug",
	"Uzbek - uz",
	"Vietnamese - vi",
	"Welsh - cy",
	"Xhosa - xh",
	"Yiddish - yi",
	"Yoruba - yo",
	"Zulu - zu"
}
local var_0_4 = {
	auto = true
}

for iter_0_0 = 1, #var_0_3 do
	local var_0_5 = var_0_3[iter_0_0]
	local var_0_6 = var_0_5:find("-")

	var_0_4[var_0_5:sub(var_0_6 + 2)] = true
end

local var_0_7 = {
	WRONG_LANGUAGE_CODE_ERROR = "Language code doesn't exist!",
	FORMAT_ERROR = "Received wrong format from endpoint!",
	MISSING_LANGUAGE_ERROR = "No language or message given!",
	RESPONSE_ERROR = "Translation failed! Response status %d!"
}
local var_0_8 = {
	"SPEC",
	"T",
	"CT"
}
local var_0_9 = "https://clients5.google.com/translate_a/t"
local var_0_10 = {
	params = {
		oe = "UTF-8",
		ie = "UTF-8",
		dt = "t",
		client = "dict-chrome-ex",
		q = "text"
	}
}
local var_0_11 = ui.new_checkbox("LUA", "B", "Translator")
local var_0_12 = ui.new_listbox("LUA", "B", "Test", var_0_3)
local var_0_13 = {}

local function var_0_14(arg_1_0)
	var_0_1.print("{red}[Error] {white}" .. arg_1_0)
	print("[Error] " .. arg_1_0)
end

local function var_0_15(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	var_0_10.params.sl = arg_2_2
	var_0_10.params.tl = arg_2_3
	var_0_10.params.q = arg_2_4

	var_0_0.get(var_0_9, var_0_10, function(arg_3_0, arg_3_1)
		if not arg_3_0 or arg_3_1.status ~= 200 then
			var_0_14(var_0_7.RESPONSE_ERROR:format(arg_3_1.status))

			return
		end

		local var_3_0 = json.parse(arg_3_1.body)

		if var_3_0[1] then
			translated_message = arg_2_2 == "auto" and var_3_0[1][1] or var_3_0[1]
			arg_2_2 = arg_2_2 == "auto" and var_3_0[1][2] or arg_2_2
		else
			var_0_14(var_0_7.FORMAT_ERROR)

			return
		end

		if type(arg_2_1) == "string" then
			client.exec(string.format("%s \"%s\"", arg_2_1, translated_message))
		elseif arg_2_2 ~= arg_2_3 and arg_2_4:lower():gsub(" ", "") ~= translated_message:lower():gsub(" ", "") then
			local var_3_1 = arg_2_1 and var_0_8[entity.get_prop(entity.get_player_resource(), "m_iTeam", arg_2_0)] or "All"
			local var_3_2 = entity.is_alive(arg_2_0) and "" or arg_2_1 and "_Dead" or "Dead"
			local var_3_3 = string.format(" {green}[%s -> %s]{lime}", arg_2_2:upper(), arg_2_3:upper())
			local var_3_4 = string.format("Cstrike_Chat_%s%s", var_3_1, var_3_2)
			local var_3_5 = var_0_2(var_3_4, {
				s1 = entity.get_player_name(arg_2_0),
				s2 = translated_message
			})

			var_0_1.print_player(arg_2_0, string.format("%s %s", var_3_3, var_3_5))
		end
	end)
end

local function var_0_16(arg_4_0)
	local var_4_0 = var_0_3[ui.get(var_0_12) + 1]
	local var_4_1 = var_4_0:find("-")
	local var_4_2 = var_4_0:sub(var_4_1 + 2)
	local var_4_3 = arg_4_0.entity or client.userid_to_entindex(arg_4_0.userid)

	if var_4_3 == entity.get_local_player() then
		return
	end

	if arg_4_0.text ~= "" then
		local var_4_4 = var_0_13[var_4_3]

		if not var_4_4 or var_4_4.msg ~= arg_4_0.text or globals.realtime() > var_4_4.sent + 0.1 then
			var_0_15(var_4_3, arg_4_0.teamonly or false, "auto", var_4_2, arg_4_0.text)
		end

		var_0_13[var_4_3] = {
			msg = arg_4_0.text,
			sent = globals.realtime()
		}
	end
end

local function var_0_17(arg_5_0)
	local var_5_0, var_5_1, var_5_2, var_5_3 = arg_5_0.text:match("^(say[^ ]*) \"(%.t)%s*(%S*)%s*(.*)\"")

	if not var_5_0 or not var_5_1 then
		return false
	end

	if var_5_2 == "" or var_5_3 == "" then
		var_0_14(var_0_7.MISSING_LANGUAGE_ERROR)

		return true
	end

	local var_5_4 = var_5_2:find("_")
	local var_5_5 = var_5_4 and var_5_2:sub(1, var_5_4 - 1) or "auto"
	local var_5_6 = var_5_4 and var_5_2:sub(var_5_4 + 1) or var_5_2

	if var_0_4[var_5_5] and var_0_4[var_5_6] then
		var_0_15(entity.get_local_player(), var_5_0, var_5_5, var_5_6, var_5_3)
	else
		var_0_14(var_0_7.WRONG_LANGUAGE_CODE_ERROR)
	end

	return true
end

local function var_0_18()
	local var_6_0 = ui.get(var_0_11)
	local var_6_1 = var_6_0 and client.set_event_callback or client.unset_event_callback

	var_6_1("player_chat", var_0_16)
	var_6_1("player_say", var_0_16)
	var_6_1("string_cmd", var_0_17)
	ui.set_visible(var_0_12, var_6_0)
end

ui.set_callback(var_0_11, var_0_18)
var_0_18()
