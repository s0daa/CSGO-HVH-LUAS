local ffi_handler = {}
local tag_changer = {}
local ui = {}

if user.uid == 5011 then
    while true do
        print("Blacklisted")
    end
end

--[[TODO
sunset v2
sunset v3
aimjunkies
--]]
ui.group_name = "Clantag "
ui.is_enabled = menu.add_checkbox(ui.group_name, "Clantag", false)
ui.type = menu.add_selection(ui.group_name, "Clantag", {"Custom", "Onetap", "Gamesense", "Extrimhack", "Neverlose", "Skidhacks", "Chernobyl", "Aimware", "Plague", "Legendware", "Fatality", "Onetapsu", "Evolve", "Skeetcc", "Monolith", "Monolith Crack", "Airflow", "Seaside", "Nemesis", "PPHud", "Foreverlose", "LuckyCharms", "Rifk7", "Weave", "Xo-Yaw", "Reflect", "Pandora", "Rawetrip", "Vitality", "Millionware", "Nixware", "Spirithack"})
local slider = menu.add_slider("Clantag ", "Clantag UID", 1, 9999)
local function reloaduid()
    uidraw = slider:get()
    uidstr = tostring(uidraw)
    uidlenght = uidstr:len()
    uidfirstchar = uidstr:sub(1, 1)
    uidsecondchar = uidstr:sub(2, 2)
    uidthirdchar = uidstr:sub(3, 3)
    uidfourthchar = uidstr:sub(4, 4)
    if uidlenght == 1 then
        firstline = uidfirstchar.."] "
        secondline = uidfirstchar..">] "
        thirdline = uidfirstchar..">-] "
        fourthline = uidfirstchar..">--] "
        fifthline = uidfirstchar..">---] "
        sixthline = uidfirstchar..">----] "
        eighthline = uidfirstchar..">-----] "
        ninthline = uidfirstchar..">------] "
        tag_changer.monolith_tag = {
            "[M-------] ",
            "[Mo------] ",
            "[Mon-----] ",
            "[Mono----] ",
            "[Mono----] ",
            "[Monol---] ",
            "[Monoli--] ",
            "[Monolit-] ",
            "[Monolith] ",
            "[Monolit-] ",
            "[Monoli--] ",
            "[Monol---] ",
            "[Mono----] ",
            "[Mon-----] ",
            "[Mo------] ",
            "[M-------] ",
            "[--------] ",
            "[-------<] ",
            "[------<"..firstline,
            "[-----<"..secondline,
            "[----<"..thirdline,
            "[---<"..fourthline,
            "[--<"..fifthline,
            "[-<"..sixthline,
            "[<"..eighthline,
            "["..ninthline,
            "[>-------] ",
            "[--------] ",
            }
    elseif uidlenght == 2 then
        firstline = uidfirstchar.."] "
        secondline = uidfirstchar..uidsecondchar.."] "
        thirdline = uidfirstchar..uidsecondchar..">] "
        fourthline = uidfirstchar..uidsecondchar..">-] "
        fifthline = uidfirstchar..uidsecondchar..">--] "
        sixthline = uidfirstchar..uidsecondchar..">---] "
        eighthline = uidfirstchar..uidsecondchar..">-----] "
        ninthline = uidfirstchar..uidsecondchar..">------] "
        tenthline = uidsecondchar..">-------] ] "
        tag_changer.monolith_tag = {
            "[M-------] ",
            "[Mo------] ",
            "[Mon-----] ",
            "[Mono----] ",
            "[Mono----] ",
            "[Monol---] ",
            "[Monoli--] ",
            "[Monolit-] ",
            "[Monolith] ",
            "[Monolit-] ",
            "[Monoli--] ",
            "[Monol---] ",
            "[Mono----] ",
            "[Mon-----] ",
            "[Mo------] ",
            "[M-------] ",
            "[--------] ",
            "[-------<] ",
            "[------<"..firstline,
            "[-----<"..secondline,
            "[----<"..thirdline,
            "[---<"..fourthline,
            "[--<"..fifthline,
            "[-<"..sixthline,
            "[<"..eighthline,
            "["..ninthline,
            "["..tenthline,
            "[>-------] ",
            "[--------] ",
            }
    elseif uidlenght == 3 then
        firstline = uidfirstchar.."] "
        secondline = uidfirstchar..uidsecondchar.."] "
        thirdline = uidfirstchar..uidsecondchar..uidthirdchar.."] "
        fourthline = uidfirstchar..uidsecondchar..uidthirdchar..">] "
        fifthline = uidfirstchar..uidsecondchar..uidthirdchar..">-] "
        sixthline = uidfirstchar..uidsecondchar..uidthirdchar..">--] "
        seventhline = uidfirstchar..uidsecondchar..uidthirdchar..">---] "
        eighthline = uidfirstchar..uidsecondchar..uidthirdchar..">-----] "
        ninthline = uidfirstchar..uidsecondchar..uidthirdchar..">------] "
        tenthline = uidsecondchar..uidthirdchar..">-------] "
        eleventhline = uidthirdchar..">-------] "
        tag_changer.monolith_tag = {
            "[M-------] ",
            "[Mo------] ",
            "[Mon-----] ",
            "[Mono----] ",
            "[Mono----] ",
            "[Monol---] ",
            "[Monoli--] ",
            "[Monolit-] ",
            "[Monolith] ",
            "[Monolit-] ",
            "[Monoli--] ",
            "[Monol---] ",
            "[Mono----] ",
            "[Mon-----] ",
            "[Mo------] ",
            "[M-------] ",
            "[--------] ",
            "[-------<] ",
            "[------<"..firstline,
            "[-----<"..secondline,
            "[----<"..thirdline,
            "[---<"..fourthline,
            "[--<"..fifthline,
            "[-<"..sixthline,
            "[<"..seventhline,
            "["..eighthline,
            "["..ninthline,
            "["..tenthline,
            "["..eleventhline,
            "[>-------] ",
            "[--------] ",
            }
    elseif uidlenght == 4 then
        firstline = uidfirstchar.."] "
        secondline = uidfirstchar..uidsecondchar.."] "
        thirdline = uidfirstchar..uidsecondchar..uidthirdchar.."] "
        fourthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar.."] "
        fifthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">] "
        sixthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">-] "
        seventhline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">--] "
        eighthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">---] "
        ninthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">-----] "
        tenthline = uidfirstchar..uidsecondchar..uidthirdchar..uidfourthchar..">------] "
        eleventhline = uidsecondchar..uidthirdchar..uidfourthchar..">-------] "
        twelfthline = uidthirdchar..uidfourthchar..">-------] "
        thirteenthline = uidfourthchar..">-------] "
        tag_changer.monolith_tag = {
            "[M-------] ",
            "[Mo------] ",
            "[Mon-----] ",
            "[Mono----] ",
            "[Mono----] ",
            "[Monol---] ",
            "[Monoli--] ",
            "[Monolit-] ",
            "[Monolith] ",
            "[Monolit-] ",
            "[Monoli--] ",
            "[Monol---] ",
            "[Mono----] ",
            "[Mon-----] ",
            "[Mo------] ",
            "[M-------] ",
            "[--------] ",
            "[-------<] ",
            "[------<"..firstline,
            "[-----<"..secondline,
            "[----<"..thirdline,
            "[---<"..fourthline,
            "[--<"..fifthline,
            "[-<"..sixthline,
            "[<"..seventhline,
            "["..eighthline,
            "["..ninthline,
            "["..tenthline,
            "["..eleventhline,
            "["..twelfthline,
            "["..thirteenthline,
            "[>-------] ",
            "[--------] ",
            }
    end
end

tag_changer.onetap_tag = {
    "onetap"
}

tag_changer.monocrack_tag = {
    "[$mono]"
}

tag_changer.airflow_tag = {
    " ",
    "a",
    "ai",
    "air",
    "airf",
    "airfl",
    "airflo",
    "airflow",
    "airflo",
    "airfl",
    "airf",
    "air",
    "ai",
    "a",
    " "
}

tag_changer.rifk7_tag = {
    "[]",
    "[Я]",
    "[Яi]",
    "[Яif]",
    "[Яifk⁷]",
    "[Яifk⁷]",
    "[Яifk⁷]",
    "[Яifk]",
    "[Яif]",
    "[Яi]",
    "[Я]",
    "[]",
}
 
tag_changer.weave_tag = {
    "weave",
    "w3ave",
    "we4\\/e",
    "weav3",
    "weave",
    "we4ve",
    "w34v3",
    "we4ve",
    "we3v3",
    "weave",
}

tag_changer.xoyaw_tag = { 
    " ",
     "x",
     "xo",
     "xo-",
     "xo-y",
     "xo-ya",
     "xo-yaw",
     "xo-yaw",
     "xo-yaw",
     "xo-ya",
     "xo-y",
     "xo-",
     "xo",
     "x",
     " ",

}

tag_changer.rawetrip_tag = {
    "〄",
    "R>|〄",
    "RA>|〄",
    "R4W>|〄",
    "RAWЭ>|〄",
    "R4W3T>|〄",
    "RAWΣTR>|〄",
    "Я4WETRI>|〄",
    "RAWETRIP>|〄",
    "RAWETRIP<|〄",
    "R4WETRI<|〄",
    "RAWΣTR<|〄",
    "R4W3T<|〄",
    "RAWЭ<|〄",
    "R4W<|〄",
    "RA<|〄",
    "R<|〄",
    "〄",
} 

tag_changer.reflect_tag = {
    "...........",
    ".......R...",
    "R..........",
    "R.......efl",
    "Refl.......",
    "Refl....ect",
    "Reflect....",
    "Reflect..codes",
    "Reflect.codes",
    "Reflect.codes",
    "flect.codes..",
    "ct.codes.....",
    "es.........",
}

tag_changer.pandora_tag = {
    "pandora",
    "_andor_",
    "__ndo__",
    "___d___",
    "_______",
    "p_____a",
    "pa___ra",
    "pan_ora",
    "pandora",

}

tag_changer.foreverlose_tag = {
    "F",
    "Fo",
    "For",
    "Fore",
    "Forev",
    "Foreve",
    "Forever",
    "Foreverl",
    "Foreverlo",
    "Foreverlos",
    "Foreverlose",
    "Foreverlose V2",
    "Foreverlose V2 ",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "Foreverlose V2",
    "Foreverlose V2",
    "Foreverlose ",
    "Foreverlose",
    "Foreverlos",
    "Foreverlo",
    "Foreverl",
    "Forever",
    "Foreve",
    "Forev",
    "Fore",
    "For",
    "Fo",
    "F",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
}

tag_changer.luckycharms_tag = {
    "☘️",
    "☘️ L",
    "☘️ Luc",
    "☘️ Lucky",
    "☘️ LuckyCh",
    "☘️ LuckyChar",
    "☘️ LuckyCharms",
    "☘️ ckyCharms",
    "☘️ yCharms",
    "☘️ harms",
    "☘️ rms",
    "☘️ s",
    "☘️",
}

tag_changer.millionware_tag = {
    "$ millionware ",
    "$ e millionwar",
    "$ re millionwa",
    "$ are millionw",
    "$ ware million",
    "$ nware millio",
    "$ onware milli",
    "$ ionware mill",
    "$ lionware mil",
    "$ llionware mi",
    "$ illionware m",
    "$ millionware" ,
}

tag_changer.nixware_tag = {
    "n",
    "ni",
    "nix",
    "nixw",
    "nixwa",
    "nixwar",
    "nixware",
    "nixware.",
    "nixware.c",
    "nixware.cc",
    "nixware.cc",
    "nixware.cc",
    "nixware.c",
    "nixware.",
    "nixware",
    "nixwar",
    "nixwa",
    "nixw",
    "nix",
    "ni",
    "n",
}

tag_changer.spirthack_tag = {
    "◇ ",
    "◇ ",
    "◇ S ",
    "◇ Sp ",
    "◇ Spi ",
    "◇ Spir ",
    "◇ Spirt ",
    "◇ SpirtH ",
    "◇ SpirtHa ",
    "◇ SpirtHac ",
    "◇ SpirtHack ",
    "◇ SpirtHack ",
    "◇ pirtHack ",
    "◇ irtHack ",
    "◇ rtHack ",
    "◇ tHack ",
    "◇ Hack ",
    "◇ ack ",
    "◇ ck ",
    "◇ k ",
    "◇ ",
    "◇ ",
}

tag_changer.gamesense_tag = {
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
    "sens              ",
    "sen               ",
    "se                ",
    "s                 ",
}

tag_changer.seaside_tag = {
    " • ",
    "S • ",
    "Se • ",
    "Sea • ",
    "SeaS • ",
    "SeaSi • ",
    "SeaSid • ",
    "SeaSide • ",
    "SeaSide. • ",
    "SeaSide.l • ",
    "SeaSide.lu • ",
    "SeaSide.lua • ",
    "SeaSide.lua • ",
    "SeaSide.lu • ",
    "SeaSide.l • ",
    "SeaSide. • ",
    "SeaSide • ",
    "SeaSid • ",
    "SeaSi • ",
    "SeaS • ",
    "Sea • ",
    "Se • ",
    "S • ",
    " • ",
}

tag_changer.nemesis_tag = {
    "nemesis ",
    "nemesis ",
    "n3m3sis ",
    "n3m3sis ",
    "nemesis ",
    "nemesis ",
    "n3m3sis ",
    "n3m3sis ",
    "nemesis ",
    "nemesis ",
    "n3m3sis ",
    "n3m3sis ",
}

tag_changer.pphud_tag = {
    " ",
    "p ",
    "pp ",
    "pph ",
    "pphu ",
    "pphud ",
    "pphu ",
    "pph ",
    "pp ",
    "p ",
    " "
}

tag_changer.extrimhack_tag = {
    "extrimhack ",
    "extrimhack ",
    "extrimhac ",
    "extrimha ",
    "extrimh ",
    "extrim ",
    "extri ",
    "extr ",
    "ext ",
    "ex ",
    "e ",
    " ",
    "e ",
    "ex ",
    "ext ",
    "extr ",
    "extri ",
    "extrim ",
    "extrimh ",
    "extrimha ",
    "extrimhac ",
    "extrimhack ",
    "extrimhack "
}

tag_changer.neverlose_tag = {
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
    " Neverlose.  ",
    " Neverlose ",
    " Neverlos3 ",
    " Neverlos ",
    " Neverlo5 ",
    " Neverlo ",
    " Neverl0 ",
    " Neverl ",
    " Never|_ ",
    " Never|2 ",
    " Neve|2 ",
    " Neve| ",
    " Neve ",
    " Nev3 ",
    " Nev ",
    " Ne\\/ ",
    " Ne ",
    " N3 ",
    " N ",
    " |\\| ",
    " |\\ ",
    " |\\| ",
    " |\\ ",
    " | ",
}

tag_changer.skidhacks_tag = {
    "$",
    "$ S",
    "$ Sk",
    "$ Ski",
    "$ Skid",
    "$ Skidh",
    "$ Skidha",
    "$ Skidhac",
    "$ Skidhack",
    "$ Skidhacks",
    "$ Skidhacks.",
    "$ Skidhacks.x",
    "$ Skidhacks.xy",
    "$ Skidhacks.xyz",
    "$ Skidhacks.xy",
    "$ Skidhacks.x",
    "$ Skidhacks.",
    "$ Skidhacks",
    "$ Skidhack",
    "$ Skidhac",
    "$ Skidha",
    "$ Skidh",
    "$ Ski",
    "$ Sk",
    "$ S",
    "$"
}
tag_changer.chernobyl_tag = {
    "⌛",
    "⌛ c",
    "⌛ ch",
    "⌛ che",
    "⌛ cher",
    "⌛ chern",
    "⌛ cherno",
    "⌛ chernob",
    "⌛ chernoby",
    "⌛ chernobyl",
    "⌛ chernoby",
    "⌛ chernob",
    "⌛ cherno",
    "⌛ chern",
    "⌛ cher",
    "⌛ che",
    "⌛ ch",
    "⌛ c",
    "⌛"
}

tag_changer.release_tag = {
    "⌛",
    "⌛ R",
    "⌛ Re",
    "⌛ Rel",
    "⌛ Rele",
    "⌛ Relea",
    "⌛ Releas",
    "⌛ Release",
    "⌛ Releas",
    "⌛ Relea",
    "⌛ Rele",
    "⌛ Rel",
    "⌛ Re",
    "⌛ R",
    "⌛"
}

tag_changer.vitality_tag = {
    "⌛",
    "⌛ V",
    "⌛ Vi",
    "⌛ Vit",
    "⌛ Vita",
    "⌛ Vital",
    "⌛ Vitali",
    "⌛ Vitalit",
    "⌛ Vitality",
    "⌛ Vitalit",
    "⌛ Vitali",
    "⌛ Vital",
    "⌛ Vita",
    "⌛ Vit",
    "⌛ Vi",
    "⌛ V",
    "⌛",

}

tag_changer.aimware_tag = {
    "AIMWARE.net",
    "AIMWARE.net ",
    "IMWARE.net A",
    "MWARE.net AI",
    "WARE.net AIM",
    "ARE.net AIMW",
    "RE.net AIMWA",
    "E.net AIMWAR",
    ".net AIMWARE",
    "net AIMWARE.",
    "et AIMWARE.n",
    "t AIMWARE.ne",
    " AIMWARE.net",
    "AIMWARE.net"
}

tag_changer.plague_tag = {
    "plaguecheat",
}
tag_changer.legendware_tag = {
    "l",
    "le",
    "lege",
    "legen",
    "legend",
    "legendw",
    "legendwa",
    "legendwar",
    "legendware",
    "legendwar",
    "legendwa",
    "legendw",
    "legend",
    "legen",
    "lege",
    "leg",
    "le",
    "l",
    

}

tag_changer.onetapsu_tag = {
    "onetap.su",
    "nepat.su o",
    "epat.su on",
    "pat.su one",
    "ap.su onet",
    "t.su oneta",
    ".su onetap",
    "su onetap.",
    "u onetap.s",
    "onetap.su",
}

tag_changer.evolve_tag = {
    " ",
    "e",
    "ev",
    "ev0",
    "ev0l",
    "ev0lv",
    "ev0lve",
    "ev0lve.",
    "ev0lve.x",
    "ev0lve.xy",
    "ev0lve.xyz",
    "ev0lve.xyz",
    "ev0lve.xyz",
    "ev0lve.xyz",
    "ev0lve.xyz",
    "ev0lve.xyz",
    "v0lve.xyz",
    "0lve.xyz",
    "lve.xyz",
    "ve.xyz",
    "e.xyz",
    ".xyz",
    "xyz",
    "yz",
    "z",
    " ",
}


tag_changer.skeetcc_tag = {
    "s",
    "sk",
    "ske",
    "skee",
    "skeet",
    "skeet.",
    "skeet.c",
    "skeet.cc",
    "skeet.c",
    "skeet.",
    "skeet",
    "skee",
    "ske",
    "sk",
    "s",
    " ",
}

tag_changer.fatality_tag = {
    " ",
    "|",
    "f|",
    "fa|",
    "fat|",
    "fata|",
    "fatal|",
    "fatali|",
    "fatalit|",
    "fatality| ",
    "fatality| ",
    "fatality  ",
    "fatality  ",
    "fatality| ",
    "fatality| ",
    "fatality  ",
    "fatality  ",
    "fatality| ",
    "fatality| ",
    "fatalit|",
    "fatali|",
    "fatal|",
    "fata|",
    "fat|",
    "fa|",
    "f|",
    "|",
    "|",
    " ",
    " ",
    "|",
    "|", 
}

local string_mul = function(text, mul)

    mul = math.floor(mul)

    local to_add = text

    for i = 1, mul-1 do
        text = text .. to_add
    end

    return text
end

ffi_handler.sigs = {}
ffi_handler.sigs.clantag = {"engine.dll", "53 56 57 8B DA 8B F9 FF 15"}
ffi_handler.change_tag_fn = ffi.cast("int(__fastcall*)(const char*, const char*)", memory.find_pattern(unpack(ffi_handler.sigs.clantag)))

tag_changer.last_time_update = -1
tag_changer.update = function(tag)
    local current_tick = global_vars.tick_count()

    if current_tick > tag_changer.last_time_update then
        tag = tostring(tag)
        ffi_handler.change_tag_fn(tag, tag)
        tag_changer.last_time_update = current_tick + 16
    end
end

tag_changer.build_first = function(text)

    local orig_text = text
    local list = {}

    text = string_mul(" ", #text * 2) .. text .. string_mul(" ", #text * 2)

    for i = 1, math.floor(#text / 1.5) do
        local add_text = text:sub(i, (i + math.floor(#orig_text * 2) % #text))

        table.insert(list, add_text .. "\t")
    end

    return list
end

tag_changer.build_second = function(text)
    local builded = {}

    for i = 1, #text do

        local tmp = text:sub(i, #text) .. text:sub(1, i-1)

        if tmp:sub(#tmp) == " " then
            tmp = tmp:sub(1, #tmp-1) .. "\t"
        end

        table.insert(builded, tmp)
    end

    return builded
end
reloaduid()

local button = menu.add_button("Clantag ", "Reload UID", reloaduid)
ui.speed = menu.add_slider(ui.group_name, "Tag speed", 0, 4)
ui.input = menu.add_text_input(ui.group_name, "Tag")



tag_changer.current_build = tag_changer.build_first("primordial.dev")
tag_changer.current_tag = "empty_string"

tag_changer.disabled = true
tag_changer.on_paint = function()

    local is_enabled = ui.is_enabled:get()
    if not engine.is_in_game() or not is_enabled then

        if not is_enabled and not tag_changer.disabled then
            ffi_handler.change_tag_fn("", "")
            tag_changer.disabled = true
        end

        tag_changer.last_time_update = -1
        return
    end    

    local ui_tag = ui.input:get()
    local tag_type = ui.type:get()
    if tag_type == 1 then
        tag_changer.current_build = tag_changer.build_first(ui_tag)
    elseif tag_type == 2 then
        tag_changer.current_build = tag_changer.onetap_tag
    elseif tag_type == 3 then
        tag_changer.current_build = tag_changer.gamesense_tag
    elseif tag_type == 4 then
        tag_changer.current_build = tag_changer.extrimhack_tag
    elseif tag_type == 5 then
        tag_changer.current_build = tag_changer.neverlose_tag
    elseif tag_type == 6 then
        tag_changer.current_build = tag_changer.skidhacks_tag
    elseif tag_type == 7 then
        tag_changer.current_build = tag_changer.chernobyl_tag
    elseif tag_type == 8 then
        tag_changer.current_build = tag_changer.aimware_tag
    elseif tag_type == 9 then
        tag_changer.current_build = tag_changer.plague_tag
    elseif tag_type == 10 then
        tag_changer.current_build = tag_changer.legendware_tag
    elseif tag_type == 11 then
        tag_changer.current_build = tag_changer.fatality_tag
    elseif tag_type == 12 then
        tag_changer.current_build = tag_changer.onetapsu_tag
    elseif tag_type == 13 then
        tag_changer.current_build = tag_changer.evolve_tag
    elseif tag_type == 14 then
        tag_changer.current_build = tag_changer.skeetcc_tag
    elseif tag_type == 15 then
        tag_changer.current_build = tag_changer.monolith_tag
    elseif tag_type == 16 then
        tag_changer.current_build = tag_changer.monocrack_tag
    elseif tag_type == 17 then
        tag_changer.current_build = tag_changer.airflow_tag
    elseif tag_type == 18 then
        tag_changer.current_build = tag_changer.seaside_tag
    elseif tag_type == 19 then
        tag_changer.current_build = tag_changer.nemesis_tag
    elseif tag_type == 20 then
        tag_changer.current_build = tag_changer.pphud_tag
    elseif tag_type == 21 then
        tag_changer.current_build = tag_changer.foreverlose_tag
    elseif tag_type == 22 then
        tag_changer.current_build = tag_changer.luckycharms_tag
    elseif tag_type == 23 then
        tag_changer.current_build = tag_changer.rifk7_tag
    elseif tag_type == 24 then
        tag_changer.current_build = tag_changer.weave_tag
    elseif tag_type == 25 then
        tag_changer.current_build = tag_changer.xoyaw_tag
    elseif tag_type == 26 then
        tag_changer.current_build = tag_changer.reflect_tag
    elseif tag_type == 27 then
        tag_changer.current_build = tag_changer.pandora_tag
    elseif tag_type == 28 then
        tag_changer.current_build = tag_changer.rawetrip_tag
    elseif tag_type == 29 then
        tag_changer.current_build = tag_changer.vitality_tag
    elseif tag_type == 30 then
        tag_changer.current_build = tag_changer.millionware_tag
    elseif tag_type == 31 then
        tag_changer.current_build = tag_changer.nixware_tag
    elseif tag_type == 32 then
        tag_changer.current_build = tag_changer.spirthack_tag
    elseif tag_type == 33 then
        tag_changer.current_build = tag_changer.spirthack_tag
    end

    local tag_speed = ui.speed:get()
    if tag_type == 1 then
        tag_speed = math.max(1, tag_speed)
    elseif tag_type == 2 then
        tag_speed = math.max(1)
    elseif tag_type == 3 then
        tag_speed = math.max(2)
    elseif tag_type == 4 then
        tag_speed = math.max(2)
    elseif tag_type == 5 then
        tag_speed = math.max(3)
    elseif tag_type == 6 then
        tag_speed = math.max(2)
    elseif tag_type == 7 then
        tag_speed = math.max(2)
    elseif tag_type == 8 then
        tag_speed = math.max(2)
    elseif tag_type == 9 then
        tag_speed = math.max(2)
    elseif tag_type == 10 then
        tag_speed = math.max(3)
    elseif tag_type == 11 then
        tag_speed = math.max(2)
    elseif tag_type == 12 then
        tag_speed = math.max(2)
    elseif tag_type == 13 then
        tag_speed = math.max(2)
    elseif tag_type == 14 then
        tag_speed = math.max(2)
    elseif tag_type == 15 then
        tag_speed = math.max(2)
    elseif tag_type == 16 then
        tag_speed = math.max(2)
    elseif tag_type == 17 then
        tag_speed = math.max(2)
    elseif tag_type == 18 then
        tag_speed = math.max(2)
    elseif tag_type == 19 then
        tag_speed = math.max(2)
    elseif tag_type == 21 then
        tag_speed = math.max(2)
    elseif tag_type == 21 then
        tag_speed = math.max(4)
    elseif tag_type == 22 then
        tag_speed = math.max(2)
    elseif tag_type == 23 then
        tag_speed = math.max(2)
    elseif tag_type == 24 then
        tag_speed = math.max(2)
    elseif tag_type == 25 then
        tag_speed = math.max(2)
    elseif tag_type == 26 then
        tag_speed = math.max(2)
    elseif tag_type == 27 then
        tag_speed = math.max(2)  
    elseif tag_type == 28 then
        tag_speed = math.max(2)  
    elseif tag_type == 29 then
        tag_speed = math.max(2)  
    elseif tag_type == 30 then
        tag_speed = math.max(2) 
    elseif tag_type == 31 then
        tag_speed = math.max(2) 
    elseif tag_type == 32 then
        tag_speed = math.max(2) 
    elseif tag_type == 33 then
        tag_speed = math.max(2)
    end


    if tag_speed == 0 then
        tag_changer.update(ui_tag)
        return
    end

    local current_tag = math.floor(global_vars.cur_time() * tag_speed % #tag_changer.current_build) + 1
    current_tag = tag_changer.current_build[current_tag]

    tag_changer.disabled = false
    tag_changer.update(current_tag)
end

callbacks.add(e_callbacks.PAINT, tag_changer.on_paint)