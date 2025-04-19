slot0 = require("gamesense/http")
slot1 = require("gamesense/chat")
slot2 = require("gamesense/localize")
slot4 = {
	auto = true,
	[slot9:sub(slot9:find("-") + 2)] = true
}

for slot8 = 1, #{
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
} do
	slot9 = slot3[slot8]
end

slot5 = {
	RESPONSE_ERROR = "Translation failed! Response status %d!",
	WRONG_LANGUAGE_CODE_ERROR = "Language code doesn't exist!",
	FORMAT_ERROR = "Received wrong format from endpoint!",
	MISSING_LANGUAGE_ERROR = "No language or message given!"
}
slot6 = {
	"SPEC",
	"T",
	"CT"
}
slot7 = "https://clients5.google.com/translate_a/t"
slot8 = {
	params = {
		oe = "UTF-8",
		ie = "UTF-8",
		dt = "t",
		client = "dict-chrome-ex",
		q = "text"
	}
}
slot10 = ui.new_listbox("LUA", "B", "Test", slot3)
slot11 = {}

function slot12(slot0)
	uv0.print("{red}[Error] {white}" .. slot0)
	print("[Error] " .. slot0)
end

function slot13(slot0, slot1, slot2, slot3, slot4)
	uv0.params.sl = slot2
	uv0.params.tl = slot3
	uv0.params.q = slot4

	uv1.get(uv2, uv0, function (slot0, slot1)
		if not slot0 or slot1.status ~= 200 then
			uv0(uv1.RESPONSE_ERROR:format(slot1.status))

			return
		end

		if json.parse(slot1.body)[1] then
			translated_message = uv2 == "auto" and slot2[1][1] or slot2[1]
			uv2 = uv2 == "auto" and slot2[1][2] or uv2
		else
			uv0(uv1.FORMAT_ERROR)

			return
		end

		if type(uv3) == "string" then
			client.exec(string.format("%s \"%s\"", uv3, translated_message))
		elseif uv2 ~= uv4 and uv5:lower():gsub(" ", "") ~= translated_message:lower():gsub(" ", "") then
			uv9.print_player(uv7, string.format("%s %s", string.format(" {green}[%s -> %s]{lime}", uv2:upper(), uv4:upper()), uv8(string.format("Cstrike_Chat_%s%s", uv3 and uv6[entity.get_prop(entity.get_player_resource(), "m_iTeam", uv7)] or "All", entity.is_alive(uv7) and "" or uv3 and "_Dead" or "Dead"), {
				s1 = entity.get_player_name(uv7),
				s2 = translated_message
			})))
		end
	end)
end

function slot14(slot0)
	slot1 = uv0[ui.get(uv1) + 1]
	slot3 = slot1:sub(slot1:find("-") + 2)

	if (slot0.entity or client.userid_to_entindex(slot0.userid)) == entity.get_local_player() then
		return
	end

	if slot0.text ~= "" then
		if not uv2[slot4] or slot5.msg ~= slot0.text or globals.realtime() > slot5.sent + 0.1 then
			uv3(slot4, slot0.teamonly or false, "auto", slot3, slot0.text)
		end

		uv2[slot4] = {
			msg = slot0.text,
			sent = globals.realtime()
		}
	end
end

function slot15(slot0)
	slot1, slot2, slot3, slot4 = slot0.text:match("^(say[^ ]*) \"(%.t)%s*(%S*)%s*(.*)\"")

	if not slot1 or not slot2 then
		return false
	end

	if slot3 == "" or slot4 == "" then
		uv0(uv1.MISSING_LANGUAGE_ERROR)

		return true
	end

	slot7 = slot5 and slot3:sub(slot5 + 1) or slot3

	if uv2[slot3:find("_") and slot3:sub(1, slot5 - 1) or "auto"] and uv2[slot7] then
		uv3(entity.get_local_player(), slot1, slot6, slot7, slot4)
	else
		uv0(uv1.WRONG_LANGUAGE_CODE_ERROR)
	end

	return true
end

function slot16()
	slot1 = ui.get(uv0) and client.set_event_callback or client.unset_event_callback

	slot1("player_chat", uv1)
	slot1("player_say", uv1)
	slot1("string_cmd", uv2)
	ui.set_visible(uv3, slot0)
end

ui.set_callback(ui.new_checkbox("LUA", "B", "Translator"), slot16)
slot16()
