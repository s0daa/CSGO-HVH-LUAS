local httpFactory = require("primordial/Lightweight HTTP Library.46")
local json = require("primordial/JSON Library.97")
local chat_print = require("primordial/chat printing lib.128")

local LANGUAGES = { "Afrikaans - af", "Albanian - sq", "Amharic - am", "Arabic - ar", "Armenian - hy", "Azerbaijani - az", "Basque - eu", "Belarusian - be", "Bengali - bn", "Bosnian - bs", "Bulgarian - bg", "Catalan - ca", "Cebuano - ceb", "Chinese (Simplified) - zh", "Chinese (Traditional) - zh-tw", "Corsican - co", "Croatian - hr", "Czech - cs", "Danish - da", "Dutch - nl", "English - en", "Esperanto - eo", "Estonian - et", "Finnish - fi", "French - fr", "Frisian - fy", "Galician - gl", "Georgian - ka", "German - de", "Greek - el", "Gujarati - gu", "Haitian Creole - ha", "Haitian Creole - ht", "Hawaiian - haw", "Hebrew - iw", "Hindi - hi", "Hmong - hmn", "Hungarian - hu", "Icelandic - is", "Igbo - ig", "Indonesian - id", "Irish - ga", "Italian - it", "Japanese - ja", "Javanese - jv", "Kannada - kn", "Kazakh - kk", "Khmer - km", "Kinyarwanda - rw", "Korean - ko", "Kurdish - ku", "Kyrgyz - ky", "Lao - lo", "Latvian - lv", "Lithuanian - lt", "Luxembourgish - lb", "Macedonian - mk", "Malagasy - mg", "Malay - ms", "Malayalam - ml", "Maltese - mt", "Maori - mi", "Marathi - mr", "Mongolian - mn", "Myanmar (Burmese) - my", "Nepali - ne", "Norwegian - no", "Nyanja (Chichewa) - ny", "Odia (Oriya) - or", "Pashto - ps", "Persian - fa", "Polish - pl", "Portuguese (Portugal, Brazil) - pt", "Punjabi - pa", "Romanian - ro", "Russian - ru", "Samoan - sm", "Scots Gaelic - gd", "Serbian - sr", "Sesotho - st", "Shona - sn", "Sindhi - sd", "Sinhala (Sinhalese) - si", "Slovak - sk", "Slovenian - sl", "Somali - so", "Spanish - es", "Sundanese - su", "Swahili - sw", "Swedish - sv", "Tagalog (Filipino) - tl", "Tajik - tg", "Tamil - ta", "Tatar - tt", "Telugu - te", "Thai - th", "Turkish - tr", "Turkmen - tk", "Ukrainian - uk", "Urdu - ur", "Uyghur - ug", "Uzbek - uz", "Vietnamese - vi", "Welsh - cy", "Xhosa - xh", "Yiddish - yi", "Yoruba - yo", "Zulu - zu" }
local ISO_CODES = { "auto", "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs", "bg", "ca", "ceb", "zh-cn", "zh-tw", "zh", "co", "hr", "cs", "da", "nl", "en", "eo", "et", "fi", "fr", "fy", "gl", "ka", "de", "el", "gu", "ht", "ha", "haw", "iw", "hi", "hmn", "hu", "is", "ig", "id", "ga", "it", "ja", "jv", "kn", "kk", "km", "rw", "ko", "ku", "ky", "lo", "lv", "lt", "lb", "mk", "mg", "ms", "ml", "mt", "mi", "mr", "mn", "my", "ne", "no", "ny", "or", "ps", "fa", "pl", "pt", "pa", "ro", "ru", "sm", "gd", "sr", "st", "sn", "sd", "si", "sk", "sl", "so", "es", "su", "sw", "sv", "tl", "tg", "ta", "tt", "te", "th", "tr", "tk", "uk", "ur", "ug", "uz", "vi", "cy", "xh", "yi", "yo", "zu" }

local language_list = menu.add_list("Translator", "Incoming language", LANGUAGES)
local language_list_out = menu.add_list("Translator", "Outgoing language", LANGUAGES)
local text_area = menu.add_text_input("Translator", "Text to translate")


local player_cache = {}


local http = httpFactory.new({
    task_interval = 0.5,
    enable_debug = false,
    timeout = 5
})

local function get_goal_lang()
    return ISO_CODES[language_list:get() + 2]
end

local function get_outgoing_lang()
    return ISO_CODES[language_list_out:get() + 2]
end

local function send_translated(command)
    http:request('get', "https://clients5.google.com/translate_a/t", {
        params =
        { client = "dict-chrome-ex",
          sl = "auto",
          tl = get_outgoing_lang(),
          dt = "t",
          ie = "UTF-8",
          oe = "UTF-8",
          q = text_area:get()
        } }, function(data)
        -- print(data.status)
        if data:success() then
            local success, parsed = pcall(json.parse, data.body)
            -- print(data.body)
            if not success then
                print("Failed to parse JSON")
                print("Body: " .. data.body)
            else
                -- print(parsed[1][1])
                engine.execute_cmd(command .. " " .. parsed[1][1])
            end
        end
    end)
end

local function send_message()
    send_translated("say")
end

local function send_team_message()
    send_translated("say_team")
end

local function translate_message(message)
    http:request('get', "https://clients5.google.com/translate_a/t", {
        params =
        { client = "dict-chrome-ex",
          sl = "auto",
          tl = get_goal_lang(),
          dt = "t",
          ie = "UTF-8",
          oe = "UTF-8",
          q = message
        } }, function(data)
        --print(data.status)
        if data:success() then
            local success, parsed = pcall(json.parse, data.body)
            --print(data.body)
            if not success then
                print("Failed to parse JSON")
                print("Body: " .. data.body)
            else

                if parsed[1][2] == get_goal_lang() then return end
                -- print("translated from " .. parsed[1][2] .. ":" .. parsed[1][1])
                chat_print.print("{lightgreen}[" .. string.upper(parsed[1][2]) .. "]{white} " .. parsed[1][1])
            end
        end
    end)
end

local function OnEvent(event)
    if event.name == "player_chat" or event.name == "player_say" then
        -- print("Msg " .. event.text)
        local sender = event.entity
        if not sender then
            sender = engine.get_player_index_from_user_id(event.userid)
        end
        if sender == entity_list.get_local_player():get_index() then return end

        -- Anti spam limit
        if player_cache[sender] then
            if player_cache[sender].last_msg == event.text then
                return
            else
                player_cache[sender].last_msg = event.text
            end
        else
            player_cache[sender] = { last_msg = event.text }
        end

        translate_message(event.text)
    end
end

callbacks.add(e_callbacks.EVENT, OnEvent)
local send_button = menu.add_button("Translator", "Send", send_message)
local send_team_button = menu.add_button("Translator", "Send to team", send_team_message)