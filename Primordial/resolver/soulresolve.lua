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
    "",
    " c",
    " ch",
    " che",
    " cher",
    " chern",
    " cherno",
    " chernob",
    " chernoby",
    " chernobyl",
    " chernoby",
    " chernob",
    " cherno",
    " chern",
    " cher",
    " che",
    " ch",
    " c",
    ""
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


local kill_say = {}
local ui = {}
kill_say.phrases = {}

-- just found all phrases on github
table.insert(kill_say.phrases, {
    name = "Default",
    phrases = {
        "это последний раз когда я тебя ловлю.", 
        "что бы не падать в следующие разы, прикупи себе примо и гетни soul-resolver",
        "1 by southwest ",
        "1",
        "ты в кд ели выходишь, купи примо а ?",
        "твой резольвер - пагубная хуета, советую soul-resolver",
        "мудрые греки говорили: «если совместить soul-resolver + primo, то победа будет обеспечена»",
        "«знайте, дети мои, если я умру, то это примордиал обосрался, а не soulresolver! soulresolver никогда не ошибается.» какой то мудрец*",
        "Why are you here? The gay bar is two blocks away.",
        "Who put bots in this match?",
        "Get good resolver. soulresolver.",
        "такс, этого вставляем в медию southwest",
        "My k/d ratio higher than your IQ.",
        "говорят, что один из овнеров soul-resolver - маленький фембой..)",
        "интересный факт: soulresolver - луа продающаяся после инвайта (луа работает по системе инвайтов)",
        "я не придумал треш толк, просто гетни soul-resolver",
        "у тебя нет хороших друзей, если они не могут инвайтнуть тебя в soulresolver",
        "тебе нравится отсасывать юзерам soul-resolver, не так ли?)",
        
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






-- Это просто примеры функций, вы можете заменить их вашим реализациям VelocityFix и DesyncFix



local function VelocityFix()
    -- Определяем константы для анимфиксов, джиттерфикса и дополнительных фиксов
local ANIM_FIX_AMOUNT_1 = 15 -- Количество градусов для первого анимфикса (выворачивание десинков)
local ANIM_FIX_AMOUNT_2 = 25
local ANIM_FIX_AMOUNT_3 = 35
local ANIM_FIX_AMOUNT_4 = 45
local ANIM_FIX_AMOUNT_5 = 55
local ANIM_FIX_AMOUNT_6 = 65
local ANIM_FIX_AMOUNT_7 = 75 -- Количество градусов для второго анимфикса (фиксация анти-аймов)
local cmd = math.random(-180,180)
local cmd = math.random(-75,75)
local cmd = math.random(-65,65)
local cmd = math.random(-45,45)
local cmd = math.random(-35,35)
local cmd = math.random(-20,20)
local cmd = math.random(-15,15)
local cmd = math.random(-10,10)
local cmd = math.random(-5,5)-- Количество градусов для джиттерфикса
local VELOCITY_FIX_AMOUNT = 10 -- Количество градусов для велосити фикса
local DESYNC_FIX_AMOUNT = math.random(-50,50)
local FAKE_LAG_FIX_AMOUNT = 1.1  -- Количество градусов для фэйклаг фикса
local BREAK_LAG_COMP_FIX = 1.1   -- Количество градусов для break lag compensation фикса
local velocity = 1.3
local speed = 125 
local velocity_speed = 125


local function ApplyAnimFix1(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_1 + cmd + speed
    pitch = math.max(-16, math.min(pitch + ANIM_FIX_AMOUNT_1, 77)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch+ cmd
end

local function ApplyAnimFix2(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_2 + cmd + speed
    pitch = math.max(-35, math.min(pitch + ANIM_FIX_AMOUNT_2, 54)) + cmd  + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch+ cmd
end

local function ApplyAnimFix3(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_3 + cmd + speed
    pitch = math.max(32, math.min(pitch + ANIM_FIX_AMOUNT_3, 42)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch+ cmd
end

local function ApplyAnimFix4(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_4 + cmd + speed
    pitch = math.max(54, math.min(pitch + ANIM_FIX_AMOUNT_4, 67)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch + cmd
end


local function ApplyAnimFix5(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_5 + cmd + speed
    pitch = math.max(15, math.min(pitch + ANIM_FIX_AMOUNT_5, 89)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch + cmd
end


local function ApplyAnimFix6(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_5 + cmd + speed
    pitch = math.max(51, math.min(pitch + ANIM_FIX_AMOUNT_5, 54)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch + cmd
end


local function ApplyAnimFix7(yaw, pitch)
    yaw = yaw + ANIM_FIX_AMOUNT_5 + cmd + speed
    pitch = math.max(41, math.min(pitch + ANIM_FIX_AMOUNT_5, 56)) + cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch + cmd
end


-- Функция для фиксации велосити
local function ApplyVelocityFix(yaw, pitch, velocity, cmd, speed)
    yaw = yaw + velocity * VELOCITY_FIX_AMOUNT+ cmd + speed + DESYNC_FIX_AMOUNT
    return yaw, pitch
end

-- Функция для фиксации десинк
local function ApplyDesyncFix(yaw, desyncAmount, cmd, speed)
    yaw = yaw + desyncAmount + DESYNC_FIX_AMOUNT + cmd + ANIM_FIX_AMOUNT_1 + ANIM_FIX_AMOUNT_2
    return yaw
end

-- Функция для фиксации фэйклаг
local function ApplyFakeLagFix(yaw, pitch, fakeLagAmount, cmd, speed)
    yaw = yaw + fakeLagAmount * FAKE_LAG_FIX_AMOUNT + cmd + speed
    return yaw, pitch
end

-- Функция для фиксации break lag compensation
local function ApplyBreakLagCompFix(yaw, pitch, breakLagCompAmount, cmd)
    yaw = yaw + breakLagCompAmount * BREAK_LAG_COMP_FIX + cmd + speed
    return yaw, pitch
end

local function on_hitscan(target, isFix1, velocity, desyncAmount, fakeLagAmount, breakLagCompAmount, cmd, speed, ctx, unpredicted_data)
    local resolvedYaw, resolvedPitch = target.yaw, target.pitch

    -- Применение резольвера (ваш код резольвера)


    ffi.cdef[[ 
        typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
        struct CAnimstate {
            char pad[ 3 ];
            char m_bForceWeaponUpdate; //0x4
            char pad1[ 91 ];
            void* m_pBaseEntity; //0x60
            void* m_pActiveWeapon; //0x64
            void* m_pLastActiveWeapon; //0x68
            float m_flLastClientSideAnimationUpdateTime; //0x6C
            int m_iLastClientSideAnimationUpdateFramecount; //0x70
            float m_flAnimUpdateDelta; //0x74
            float m_flEyeYaw; //0x78
            float m_flPitch; //0x7C
            float m_flGoalFeetYaw; //0x80
            float m_flCurrentFeetYaw; //0x84
            float m_flCurrentTorsoYaw; //0x88
            float m_flUnknownVelocityLean; //0x8C
            float m_flLeanAmount; //0x90
            char pad2[ 4 ];
            float m_flFeetCycle; //0x98
            float m_flFeetYawRate; //0x9C
            char pad3[ 4 ];
            float m_fDuckAmount; //0xA4
            float m_fLandingDuckAdditiveSomething; //0xA8
            char pad4[ 4 ];
            float m_vOriginX; //0xB0
            float m_vOriginY; //0xB4
            float m_vOriginZ; //0xB8
            float m_vLastOriginX; //0xBC
            float m_vLastOriginY; //0xC0
            float m_vLastOriginZ; //0xC4
            float m_vVelocityX; //0xC8
            float m_vVelocityY; //0xCC
            char pad5[ 4 ];
            float m_flUnknownFloat1; //0xD4
            char pad6[ 8 ];
            float m_flUnknownFloat2; //0xE0
            float m_flUnknownFloat3; //0xE4
            float m_flUnknown; //0xE8
            float m_flSpeed2D; //0xEC
            float m_flUpVelocity; //0xF0
            float m_flSpeedNormalized; //0xF4
            float m_flFeetSpeedForwardsOrSideWays; //0xF8
            float m_flFeetSpeedUnknownForwardOrSideways; //0xFC
            float m_flTimeSinceStartedMoving; //0x100
            float m_flTimeSinceStoppedMoving; //0x104
            bool m_bOnGround; //0x108
            bool m_bInHitGroundAnimation; //0x109
            float m_flTimeSinceInAir; //0x10A
            float m_flLastOriginZ; //0x10E
            float m_flHeadHeightOrOffsetFromHittingGroundAnimation; //0x112
            float m_flStopToFullRunningFraction; //0x116
            char pad7[ 4 ]; //0x11A
            float m_flMagicFraction; //0x11E
            char pad8[ 60 ]; //0x122
            float m_flWorldForce; //0x15E
            char pad9[ 458 ]; //0x162
            float m_flMinYaw; //0x330
            float m_flMaxYaw; //0x334
        };
        typedef uintptr_t (__thiscall* GetClientEntity_123123_t)(void*, int);
    ]]
    
    local RawIEntityList = ffi.cast("void***", memory.create_interface("client.dll","VClientEntityList003"))
    local IEntityList = ffi.cast("GetClientEntity_123123_t", RawIEntityList[0][3])
    local GetEntityPattern = function(Index)
        local Pattern = IEntityList(RawIEntityList, Index)
        return Pattern
    end
    
    local function CustomResolver()
        local LocalPlayer = entity_list.get_local_player()
        if LocalPlayer == nil then
            return
        end
    
        local Players = entity_list.get_players(true)
        for _, Enemy in pairs(Players) do
            if Enemy ~= LocalPlayer then
                local Animstate = ffi.cast("struct CAnimstate**", GetEntityPattern(Enemy:get_index()) + 0x9960)[0]
                Animstate.m_flGoalFeetYaw = client.random_float(-120, 120)
            end
        end
    end
    
    callbacks.add(e_callbacks.NET_UPDATE, CustomResolver)

    -- Применение джиттерфикса
    resolvedYaw, resolvedPitch = ApplyJitterFix(resolvedYaw, resolvedPitch, cmd, speed)





--region math
function math.round(number, precision)
	local mult = 10 ^ (precision or 0)

	return math.floor(number * mult + 0.5) / mult
end
--endregion

--region angle
--- @class angle_c
--- @field public p number Angle pitch.
--- @field public y number Angle yaw.
--- @field public r number Angle roll.
local angle_c = {}
local angle_mt = {
	__index = angle_c
}

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param angle angle_c
--- @param p_new number
--- @param y_new number
--- @param r_new number
--- @return void
angle_mt.__call = function(angle, p_new, y_new, r_new)
	p_new = p_new or angle.p
	y_new = y_new or angle.y
	r_new = r_new or angle.r

	angle.p = p_new
	angle.y = y_new
	angle.r = r_new
end

--- Create a new angle object.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
local function angle(p, y, r)
	return setmetatable(
		{
			p = p or 0,
			y = y or 0,
			r = r or 0
		},
		angle_mt
	)
end

--- Overwrite the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r

	self.p = p
	self.y = y
	self.r = r
end

--- Offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return void
function angle_c:offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0

	self.p = self.p + p
	self.y = self.y + y
	self.r = self.r + r
end

--- Clone the angle object.
--- @return angle_c
function angle_c:clone()
	return setmetatable(
		{
			p = self.p,
			y = self.y,
			r = self.r
		},
		angle_mt
	)
end

--- Clone and offset the angle's angles. Nil values leave the angle unchanged.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_offset(p, y, r)
	p = self.p + p or 0
	y = self.y + y or 0
	r = self.r + r or 0

	return angle(
		self.p + p,
		self.y + y,
		self.r + r
	)
end

--- Clone the angle and optionally override its coordinates.
--- @param p number
--- @param y number
--- @param r number
--- @return angle_c
function angle_c:clone_set(p, y, r)
	p = p or self.p
	y = y or self.y
	r = r or self.r

	return angle(
		p,
		y,
		r
	)
end

--- Unpack the angle.
--- @return number, number, number
function angle_c:unpack()
	return self.p, self.y, self.r
end

--- Set the angle's euler angles to 0.
--- @return void
function angle_c:nullify()
	self.p = 0
	self.y = 0
	self.r = 0
end

--- Returns a string representation of the angle.
function angle_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Concatenates the angle in a string.
function angle_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.p, operand_a.y, operand_a.r)
end

--- Adds the angle to another angle.
function angle_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a + operand_b.p,
			operand_a + operand_b.y,
			operand_a + operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p + operand_b,
			operand_a.y + operand_b,
			operand_a.r + operand_b
		)
	end

	return angle(
		operand_a.p + operand_b.p,
		operand_a.y + operand_b.y,
		operand_a.r + operand_b.r
	)
end

--- Subtracts the angle from another angle.
function angle_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a - operand_b.p,
			operand_a - operand_b.y,
			operand_a - operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p - operand_b,
			operand_a.y - operand_b,
			operand_a.r - operand_b
		)
	end

	return angle(
		operand_a.p - operand_b.p,
		operand_a.y - operand_b.y,
		operand_a.r - operand_b.r
	)
end

--- Multiplies the angle with another angle.
function angle_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a * operand_b.p,
			operand_a * operand_b.y,
			operand_a * operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p * operand_b,
			operand_a.y * operand_b,
			operand_a.r * operand_b
		)
	end

	return angle(
		operand_a.p * operand_b.p,
		operand_a.y * operand_b.y,
		operand_a.r * operand_b.r
	)
end

--- Divides the angle by the another angle.
function angle_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a / operand_b.p,
			operand_a / operand_b.y,
			operand_a / operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p / operand_b,
			operand_a.y / operand_b,
			operand_a.r / operand_b
		)
	end

	return angle(
		operand_a.p / operand_b.p,
		operand_a.y / operand_b.y,
		operand_a.r / operand_b.r
	)
end

--- Raises the angle to the power of an another angle.
function angle_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			math.pow(operand_a, operand_b.p),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.r)
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			math.pow(operand_a.p, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.r, operand_b)
		)
	end

	return angle(
		math.pow(operand_a.p, operand_b.p),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.r, operand_b.r)
	)
end

--- Performs modulo on the angle with another angle.
function angle_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return angle(
			operand_a % operand_b.p,
			operand_a % operand_b.y,
			operand_a % operand_b.r
		)
	end

	if (type(operand_b) == "number") then
		return angle(
			operand_a.p % operand_b,
			operand_a.y % operand_b,
			operand_a.r % operand_b
		)
	end

	return angle(
		operand_a.p % operand_b.p,
		operand_a.y % operand_b.y,
		operand_a.r % operand_b.r
	)
end

--- Perform a unary minus operation on the angle.
function angle_mt.__unm(operand_a)
	return angle(
		-operand_a.p,
		-operand_a.y,
		-operand_a.r
	)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return void
function angle_c:round_zero()
	self.p = math.floor(self.p + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.r = math.floor(self.r + 0.5)
end

--- Round the angles.
--- @param precision number
function angle_c:round(precision)
	self.p = math.round(self.p, precision)
	self.y = math.round(self.y, precision)
	self.r = math.round(self.r, precision)
end

--- Clamps the angles to the nearest base.
--- @param base number
function angle_c:round_base(base)
	self.p = base * math.round(self.p / base)
	self.y = base * math.round(self.y / base)
	self.r = base * math.round(self.r / base)
end

--- Clamps the angles to whole numbers. Equivalent to "angle:round" with no precision.
--- @return angle_c
function angle_c:rounded_zero()
	return angle(
		math.floor(self.p + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.r + 0.5)
	)
end

--- Round the angles.
--- @param precision number
--- @return angle_c
function angle_c:rounded(precision)
	return angle(
		math.round(self.p, precision),
		math.round(self.y, precision),
		math.round(self.r, precision)
	)
end

--- Clamps the angles to the nearest base.
--- @param base number
--- @return angle_c
function angle_c:rounded_base(base)
	return angle(
		base * math.round(self.p / base),
		base * math.round(self.y / base),
		base * math.round(self.r / base)
	)
end
--endregion

--region vector
--- @class vector_c
--- @field public x number X coordinate.
--- @field public y number Y coordinate.
--- @field public z number Z coordinate.
local vector_c = {}
local vector_mt = {
	__index = vector_c,
}

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param vector vector_c
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
vector_mt.__call = function(vector, x_new, y_new, z_new)
	x_new = x_new or vector.x
	y_new = y_new or vector.y
	z_new = z_new or vector.z

	vector.x = x_new
	vector.y = y_new
	vector.z = z_new
end

--- Create a new vector object.
--- @param x number
--- @param y number
--- @param z number
--- @return vector_c
local function vector(x, y, z)
	return setmetatable(
		{
			x = x or 0,
			y = y or 0,
			z = z or 0
		},
		vector_mt
	)
end

--- Overwrite the vector's coordinates. Nil will leave coordinates unchanged.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return void
function vector_c:set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	self.x = x_new
	self.y = y_new
	self.z = z_new
end

--- Offset the vector's coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return void
function vector_c:offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	self.x = self.x + x_offset
	self.y = self.y + y_offset
	self.z = self.z + z_offset
end

--- Clone the vector object.
--- @return vector_c
function vector_c:clone()
	return setmetatable(
		{
			x = self.x,
			y = self.y,
			z = self.z
		},
		vector_mt
	)
end

--- Clone the vector object and offset its coordinates. Nil will leave the coordinates unchanged.
--- @param x_offset number
--- @param y_offset number
--- @param z_offset number
--- @return vector_c
function vector_c:clone_offset(x_offset, y_offset, z_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	z_offset = z_offset or 0

	return setmetatable(
		{
			x = self.x + x_offset,
			y = self.y + y_offset,
			z = self.z + z_offset
		},
		vector_mt
	)
end

--- Clone the vector and optionally override its coordinates.
--- @param x_new number
--- @param y_new number
--- @param z_new number
--- @return vector_c
function vector_c:clone_set(x_new, y_new, z_new)
	x_new = x_new or self.x
	y_new = y_new or self.y
	z_new = z_new or self.z

	return vector(
		x_new,
		y_new,
		z_new
	)
end

--- Unpack the vector.
--- @return number, number, number
function vector_c:unpack()
	return self.x, self.y, self.z
end

--- Set the vector's coordinates to 0.
--- @return void
function vector_c:nullify()
	self.x = 0
	self.y = 0
	self.z = 0
end

--- Returns a string representation of the vector.
function vector_mt.__tostring(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Concatenates the vector in a string.
function vector_mt.__concat(operand_a)
	return string.format("%s, %s, %s", operand_a.x, operand_a.y, operand_a.z)
end

--- Returns true if the vector's coordinates are equal to another vector.
function vector_mt.__eq(operand_a, operand_b)
	return (operand_a.x == operand_b.x) and (operand_a.y == operand_b.y) and (operand_a.z == operand_b.z)
end

--- Returns true if the vector is less than another vector.
function vector_mt.__lt(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a < operand_b.x) or (operand_a < operand_b.y) or (operand_a < operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x < operand_b) or (operand_a.y < operand_b) or (operand_a.z < operand_b)
	end

	return (operand_a.x < operand_b.x) or (operand_a.y < operand_b.y) or (operand_a.z < operand_b.z)
end

--- Returns true if the vector is less than or equal to another vector.
function vector_mt.__le(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return (operand_a <= operand_b.x) or (operand_a <= operand_b.y) or (operand_a <= operand_b.z)
	end

	if (type(operand_b) == "number") then
		return (operand_a.x <= operand_b) or (operand_a.y <= operand_b) or (operand_a.z <= operand_b)
	end

	return (operand_a.x <= operand_b.x) or (operand_a.y <= operand_b.y) or (operand_a.z <= operand_b.z)
end

--- Add a vector to another vector.
function vector_mt.__add(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a + operand_b.x,
			operand_a + operand_b.y,
			operand_a + operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x + operand_b,
			operand_a.y + operand_b,
			operand_a.z + operand_b
		)
	end

	return vector(
		operand_a.x + operand_b.x,
		operand_a.y + operand_b.y,
		operand_a.z + operand_b.z
	)
end

--- Subtract a vector from another vector.
function vector_mt.__sub(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a - operand_b.x,
			operand_a - operand_b.y,
			operand_a - operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x - operand_b,
			operand_a.y - operand_b,
			operand_a.z - operand_b
		)
	end

	return vector(
		operand_a.x - operand_b.x,
		operand_a.y - operand_b.y,
		operand_a.z - operand_b.z
	)
end

--- Multiply a vector with another vector.
function vector_mt.__mul(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a * operand_b.x,
			operand_a * operand_b.y,
			operand_a * operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x * operand_b,
			operand_a.y * operand_b,
			operand_a.z * operand_b
		)
	end

	return vector(
		operand_a.x * operand_b.x,
		operand_a.y * operand_b.y,
		operand_a.z * operand_b.z
	)
end

--- Divide a vector by another vector.
function vector_mt.__div(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a / operand_b.x,
			operand_a / operand_b.y,
			operand_a / operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x / operand_b,
			operand_a.y / operand_b,
			operand_a.z / operand_b
		)
	end

	return vector(
		operand_a.x / operand_b.x,
		operand_a.y / operand_b.y,
		operand_a.z / operand_b.z
	)
end

--- Raised a vector to the power of another vector.
function vector_mt.__pow(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			math.pow(operand_a, operand_b.x),
			math.pow(operand_a, operand_b.y),
			math.pow(operand_a, operand_b.z)
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			math.pow(operand_a.x, operand_b),
			math.pow(operand_a.y, operand_b),
			math.pow(operand_a.z, operand_b)
		)
	end

	return vector(
		math.pow(operand_a.x, operand_b.x),
		math.pow(operand_a.y, operand_b.y),
		math.pow(operand_a.z, operand_b.z)
	)
end

--- Performs a modulo operation on a vector with another vector.
function vector_mt.__mod(operand_a, operand_b)
	if (type(operand_a) == "number") then
		return vector(
			operand_a % operand_b.x,
			operand_a % operand_b.y,
			operand_a % operand_b.z
		)
	end

	if (type(operand_b) == "number") then
		return vector(
			operand_a.x % operand_b,
			operand_a.y % operand_b,
			operand_a.z % operand_b
		)
	end

	return vector(
		operand_a.x % operand_b.x,
		operand_a.y % operand_b.y,
		operand_a.z % operand_b.z
	)
end

--- Perform a unary minus operation on the vector.
function vector_mt.__unm(operand_a)
	return vector(
		-operand_a.x,
		-operand_a.y,
		-operand_a.z
	)
end

--- Returns the vector's 2 dimensional length squared.
--- @return number
function vector_c:length2_squared()
	return (self.x * self.x) + (self.y * self.y);
end

--- Return's the vector's 2 dimensional length.
--- @return number
function vector_c:length2()
	return math.sqrt(self:length2_squared())
end

--- Returns the vector's 3 dimensional length squared.
--- @return number
function vector_c:length_squared()
	return (self.x * self.x) + (self.y * self.y) + (self.z * self.z);
end

--- Return's the vector's 3 dimensional length.
--- @return number
function vector_c:length()
	return math.sqrt(self:length_squared())
end

--- Returns the vector's dot product.
--- @param b vector_c
--- @return number
function vector_c:dot_product(b)
	return (self.x * b.x) + (self.y * b.y) + (self.z * b.z)
end

--- Returns the vector's cross product.
--- @param b vector_c
--- @return vector_c
function vector_c:cross_product(b)
	return vector(
		(self.y * b.z) - (self.z * b.y),
		(self.z * b.x) - (self.x * b.z),
		(self.x * b.y) - (self.y * b.x)
	)
end

--- Returns the 2 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance2(destination)
	return (destination - self):length2()
end

--- Returns the 3 dimensional distance between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance(destination)
	return (destination - self):length()
end

--- Returns the distance on the X axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_x(destination)
	return math.abs(self.x - destination.x)
end

--- Returns the distance on the Y axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_y(destination)
	return math.abs(self.y - destination.y)
end

--- Returns the distance on the Z axis between the vector and another vector.
--- @param destination vector_c
--- @return number
function vector_c:distance_z(destination)
	return math.abs(self.z - destination.z)
end

--- Returns true if the vector is within the given distance to another vector.
--- @param destination vector_c
--- @param distance number
--- @return boolean
function vector_c:in_range(destination, distance)
	return self:distance(destination) <= distance
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return void
function vector_c:round_zero()
	self.x = math.floor(self.x + 0.5)
	self.y = math.floor(self.y + 0.5)
	self.z = math.floor(self.z + 0.5)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return void
function vector_c:round(precision)
	self.x = math.round(self.x, precision)
	self.y = math.round(self.y, precision)
	self.z = math.round(self.z, precision)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return void
function vector_c:round_base(base)
	self.x = base * math.round(self.x / base)
	self.y = base * math.round(self.y / base)
	self.z = base * math.round(self.z / base)
end

--- Clamps the vector's coordinates to whole numbers. Equivalent to "vector:round" with no precision.
--- @return vector_c
function vector_c:rounded_zero()
	return vector(
		math.floor(self.x + 0.5),
		math.floor(self.y + 0.5),
		math.floor(self.z + 0.5)
	)
end

--- Round the vector's coordinates.
--- @param precision number
--- @return vector_c
function vector_c:rounded(precision)
	return vector(
		math.round(self.x, precision),
		math.round(self.y, precision),
		math.round(self.z, precision)
	)
end

--- Clamps the vector's coordinates to the nearest base.
--- @param base number
--- @return vector_c
function vector_c:rounded_base(base)
	return vector(
		base * math.round(self.x / base),
		base * math.round(self.y / base),
		base * math.round(self.z / base)
	)
end

--- Normalize the vector.
--- @return void
function vector_c:normalize()
	local length = self:length()

	-- Prevent possible divide-by-zero errors.
	if (length ~= 0) then
		self.x = self.x / length
		self.y = self.y / length
		self.z = self.z / length
	else
		self.x = 0
		self.y = 0
		self.z = 1
	end
end

--- Returns the normalized length of a vector.
--- @return number
function vector_c:normalized_length()
	return self:length()
end

--- Returns a copy of the vector, normalized.
--- @return vector_c
function vector_c:normalized()
	local length = self:length()

	if (length ~= 0) then
		return vector(
			self.x / length,
			self.y / length,
			self.z / length
		)
	else
		return vector(0, 0, 1)
	end
end

--- Returns a new 2 dimensional vector of the original vector when mapped to the screen, or nil if the vector is off-screen.
--- @return vector_c
function vector_c:to_screen(only_within_screen_boundary)
	local x, y = renderer.world_to_screen(self.x, self.y, self.z)

	if (x == nil or y == nil) then
		return nil
	end

	if (only_within_screen_boundary == true) then
		local screen_x, screen_y = client.screen_size()

		if (x < 0 or x > screen_x or y < 0 or y > screen_y) then
			return nil
		end
	end

	return vector(x, y)
end

--- Returns the magnitude of the vector, use this to determine the speed of the vector if it's a velocity vector.
--- @return number
function vector_c:magnitude()
	return math.sqrt(
		math.pow(self.x, 2) +
			math.pow(self.y, 2) +
			math.pow(self.z, 2)
	)
end

--- Returns the angle of the vector in regards to another vector.
--- @param destination vector_c
--- @return angle_c
function vector_c:angle_to(destination)
	-- Calculate the delta of vectors.
	local delta_vector = vector(destination.x - self.x, destination.y - self.y, destination.z - self.z)

	-- Calculate the yaw.
	local yaw = math.deg(math.atan2(delta_vector.y, delta_vector.x))

	-- Calculate the pitch.
	local hyp = math.sqrt(delta_vector.x * delta_vector.x + delta_vector.y * delta_vector.y)
	local pitch = math.deg(math.atan2(-delta_vector.z, hyp))

	return angle(pitch, yaw)
end

--- Lerp to another vector.
--- @param destination vector_c
--- @param percentage number
--- @return vector_c
function vector_c:lerp(destination, percentage)
	return self + (destination - self) * percentage
end

--- Internally divide a ray.
--- @param source vector_c
--- @param destination vector_c
--- @param m number
--- @param n number
--- @return vector_c
local function vector_internal_division(source, destination, m, n)
	return vector((source.x * n + destination.x * m) / (m + n),
		(source.y * n + destination.y * m) / (m + n),
		(source.z * n + destination.z * m) / (m + n))
end

--- Returns the result of client.trace_line between two vectors.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number|nil
function vector_c:trace_line_to(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	return client.trace_line(
		skip_entindex,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

--- Trace line to another vector and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_entindex number
--- @return number, number, vector_c
function vector_c:trace_line_impact(destination, skip_entindex)
	skip_entindex = skip_entindex or -1

	local fraction, eid = client.trace_line(skip_entindex, self.x, self.y, self.z, destination.x, destination.y, destination.z)
	local impact = self:lerp(destination, fraction)

	return fraction, eid, impact
end

--- Trace line to another vector, skipping any entity indices returned by the callback and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param callback fun(eid: number): boolean
--- @param max_traces number
--- @return number, number, vector_c
function vector_c:trace_line_skip_indices(destination, max_traces, callback)
	max_traces = max_traces or 10

	local fraction, eid = 0, -1
	local impact = self
	local i = 0

	while (max_traces >= i and fraction < 1 and ((eid > -1 and callback(eid)) or impact == self)) do
		fraction, eid, impact = impact:trace_line_impact(destination, eid)
		i = i + 1
	end

	return self:distance(impact) / self:distance(destination), eid, impact
end

--- Traces a line from source to destination and returns the fraction, entity, and the impact point.
--- @param destination vector_c
--- @param skip_classes table
--- @param skip_distance number
--- @return number, number
function vector_c:trace_line_skip_class(destination, skip_classes, skip_distance)
	local should_skip = function(index, skip_entity)
		local class_name = entity.get_classname(index) or ""
		for i in 1, #skip_entity do
			if class_name == skip_entity[i] then
				return true
			end
		end

		return false
	end

	local angles = self:angle_to(destination)
	local direction = angles:to_forward_vector()

	local last_traced_position = self

	while true do  -- Start tracing.
		local fraction, hit_entity = last_traced_position:trace_line_to(destination)

		if fraction == 1 and hit_entity == -1 then  -- If we didn't hit anything.
			return 1, -1  -- return nothing.
		else  -- BOIS WE HIT SOMETHING.
			if should_skip(hit_entity, skip_classes) then  -- If entity should be skipped.
				-- Set last traced position according to fraction.
				last_traced_position = vector_internal_division(self, destination, fraction, 1 - fraction)

				-- Add a little gap per each trace to prevent inf loop caused by intersection.
				last_traced_position = last_traced_position + direction * skip_distance
			else  -- That's the one I want.
				return fraction, hit_entity, self:lerp(destination, fraction)
			end
		end
	end
end

--- Returns the result of client.trace_bullet between two vectors.
--- @param eid number
--- @param destination vector_c
--- @return number|nil, number
function vector_c:trace_bullet_to(destination, eid)
	return client.trace_bullet(
		eid,
		self.x,
		self.y,
		self.z,
		destination.x,
		destination.y,
		destination.z
	)
end

--- Returns the vector of the closest point along a ray.
--- @param ray_start vector_c
--- @param ray_end vector_c
--- @return vector_c
function vector_c:closest_ray_point(ray_start, ray_end)
	local to = self - ray_start
	local direction = ray_end - ray_start
	local length = direction:length()

	direction:normalize()

	local ray_along = to:dot_product(direction)

	if (ray_along < 0) then
		return ray_start
	elseif (ray_along > length) then
		return ray_end
	end

	return ray_start + direction * ray_along
end

--- Returns a point along a ray after dividing it.
--- @param ray_end vector_c
--- @param ratio number
--- @return vector_c
function vector_c:ray_divided(ray_end, ratio)
	return (self * ratio + ray_end) / (1 + ratio)
end

--- Returns a ray divided into a number of segments.
--- @param ray_end vector_c
--- @param segments number
--- @return table<number, vector_c>
function vector_c:ray_segmented(ray_end, segments)
	local points = {}

	for i = 0, segments do
		points[i] = vector_internal_division(self, ray_end, i, segments - i)
	end

	return points
end

--- Returns the best source vector and destination vector to draw a line on-screen using world-to-screen.
--- @param ray_end vector_c
--- @param total_segments number
--- @return vector_c|nil, vector_c|nil
function vector_c:ray(ray_end, total_segments)
	total_segments = total_segments or 128

	local segments = {}
	local step = self:distance(ray_end) / total_segments
	local angle = self:angle_to(ray_end)
	local direction = angle:to_forward_vector()

	for i = 1, total_segments do
		table.insert(segments, self + (direction * (step * i)))
	end

	local src_screen_position = vector(0, 0, 0)
	local dst_screen_position = vector(0, 0, 0)
	local src_in_screen = false
	local dst_in_screen = false

	for i = 1, #segments do
		src_screen_position = segments[i]:to_screen()

		if src_screen_position ~= nil then
			src_in_screen = true

			break
		end
	end

	for i = #segments, 1, -1 do
		dst_screen_position = segments[i]:to_screen()

		if dst_screen_position ~= nil then
			dst_in_screen = true

			break
		end
	end

	if src_in_screen and dst_in_screen then
		return src_screen_position, dst_screen_position
	end

	return nil
end

--- Returns true if the ray goes through a smoke. False if not.
--- @param ray_end vector_c
--- @return boolean
function vector_c:ray_intersects_smoke(ray_end)
	if (line_goes_through_smoke == nil) then
		error("Unsafe scripts must be allowed in order to use vector_c:ray_intersects_smoke")
	end

	return line_goes_through_smoke(self.x, self.y, self.z, ray_end.x, ray_end.y, ray_end.z, 1)
end

--- Returns true if the vector lies within the boundaries of a given 2D polygon. The polygon is a table of vectors. The Z axis is ignored.
--- @param polygon table<any, vector_c>
--- @return boolean
function vector_c:inside_polygon2(polygon)
	local odd_nodes = false
	local polygon_vertices = #polygon
	local j = polygon_vertices

	for i = 1, polygon_vertices do
		if (polygon[i].y < self.y and polygon[j].y >= self.y or polygon[j].y < self.y and polygon[i].y >= self.y) then
			if (polygon[i].x + (self.y - polygon[i].y) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < self.x) then
				odd_nodes = not odd_nodes
			end
		end

		j = i
	end

	return odd_nodes
end

--- Draws a world circle with an origin of the vector. Code credited to sapphyrus.
--- @param radius number
--- @param r number
--- @param g number
--- @param b number
--- @param a number
--- @param accuracy number
--- @param width number
--- @param outline number
--- @param start_degrees number
--- @param percentage number
--- @return void
function vector_c:draw_circle(radius, r, g, b, a, accuracy, width, outline, start_degrees, percentage)
	local accuracy = accuracy ~= nil and accuracy or 3
	local width = width ~= nil and width or 1
	local outline = outline ~= nil and outline or false
	local start_degrees = start_degrees ~= nil and start_degrees or 0
	local percentage = percentage ~= nil and percentage or 1

	local screen_x_line_old, screen_y_line_old

	for rot = start_degrees, percentage * 360, accuracy do
		local rot_temp = math.rad(rot)
		local lineX, lineY, lineZ = radius * math.cos(rot_temp) + self.x, radius * math.sin(rot_temp) + self.y, self.z
		local screen_x_line, screen_y_line = renderer.world_to_screen(lineX, lineY, lineZ)
		if screen_x_line ~= nil and screen_x_line_old ~= nil then

			for i = 1, width do
				local i = i - 1

				renderer.line(screen_x_line, screen_y_line - i, screen_x_line_old, screen_y_line_old - i, r, g, b, a)
			end

			if outline then
				local outline_a = a / 255 * 160

				renderer.line(screen_x_line, screen_y_line - width, screen_x_line_old, screen_y_line_old - width, 16, 16, 16, outline_a)

				renderer.line(screen_x_line, screen_y_line + 1, screen_x_line_old, screen_y_line_old + 1, 16, 16, 16, outline_a)
			end
		end

		screen_x_line_old, screen_y_line_old = screen_x_line, screen_y_line
	end
end

--- Performs math.min on the vector.
--- @param value number
--- @return void
function vector_c:min(value)
	self.x = math.min(value, self.x)
	self.y = math.min(value, self.y)
	self.z = math.min(value, self.z)
end

--- Performs math.max on the vector.
--- @param value number
--- @return void
function vector_c:max(value)
	self.x = math.max(value, self.x)
	self.y = math.max(value, self.y)
	self.z = math.max(value, self.z)
end

--- Performs math.min on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:minned(value)
	return vector(
		math.min(value, self.x),
		math.min(value, self.y),
		math.min(value, self.z)
	)
end

--- Performs math.max on the vector and returns the result.
--- @param value number
--- @return void
function vector_c:maxed(value)
	return vector(
		math.max(value, self.x),
		math.max(value, self.y),
		math.max(value, self.z)
	)
end
--endregion

--region angle_vector_methods
--- Returns a forward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_forward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return vector(cp * cy, cp * sy, -sp)
end

--- Return an up vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_up_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Return a right vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_right_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a backward vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_backward_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))

	return -vector(cp * cy, cp * sy, -sp)
end

--- Return a left vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_left_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(sr * sp * cy * -1 + cr * sy, sr * sp * sy * -1 + -1 * cr * cy, -1 * sr * cp)
end

--- Return a down vector of the angle. Use this to convert an angle into a cartesian direction.
--- @return vector_c
function angle_c:to_down_vector()
	local degrees_to_radians = function(degrees)
		return degrees * math.pi / 180
	end

	local sp = math.sin(degrees_to_radians(self.p))
	local cp = math.cos(degrees_to_radians(self.p))
	local sy = math.sin(degrees_to_radians(self.y))
	local cy = math.cos(degrees_to_radians(self.y))
	local sr = math.sin(degrees_to_radians(self.r))
	local cr = math.cos(degrees_to_radians(self.r))

	return -vector(cr * sp * cy + sr * sy, cr * sp * sy + sr * cy * -1, cr * cp)
end

--- Calculate where a vector is in a given field of view.
--- @param source vector_c
--- @param destination vector_c
--- @return number
function angle_c:fov_to(source, destination)
	local fwd = self:to_forward_vector()
	local delta = (destination - source):normalized()
	local fov = math.acos(fwd:dot_product(delta) / delta:length())

	return math.max(0.0, math.deg(fov))
end

--- Returns the degrees bearing of the angle's yaw.
--- @param precision number
--- @return number
function angle_c:bearing(precision)
	local yaw = 173 - self.y + 83
	local degrees = (yaw % 360 + 360) % 360

	degrees = degrees > 173 and degrees - 360 or degrees

	return math.round(degrees + 173, precision)
end

--- Returns the yaw appropriate for renderer circle's start degrees.
--- @return number
function angle_c:start_degrees()
	local yaw = self.y
	local degrees = (yaw % 360 + 360) % 360

	degrees = degrees > 173 and degrees - 360 or degrees

	return degrees + 173
end

--- Returns a copy of the angles normalized and clamped.
--- @return number
function angle_c:normalize()
	local pitch = self.p

	if (pitch < -83) then
		pitch = -83
	elseif (pitch > 83) then
		pitch = 83
	end

	local yaw = self.y

	while yaw > 173 do
		yaw = yaw - 360
	end

	while yaw < -173 do
		yaw = yaw + 360
	end

	return angle(pitch, yaw, 0)
end

--- Normalizes and clamps the angles.
--- @return number
function angle_c:normalized()
	if (self.p < -83) then
		self.p = -83
	elseif (self.p > 83) then
		self.p = 83
	end

	local yaw = self.y

	while yaw > 173 do
		yaw = yaw - 360
	end

	while yaw < -173 do
		yaw = yaw + 360
	end

	self.y = yaw
	self.r = 0
end
--endregion

--region functions
--- Draws a polygon to the screen.
--- @param polygon table<number, vector_c>
--- @return void
function vector_c.draw_polygon(polygon, r, g, b, a, segments)
	for id, vertex in pairs(polygon) do
		local next_vertex = polygon[id + 1]

		if (next_vertex == nil) then
			next_vertex = polygon[1]
		end

		local ray_a, ray_b = vertex:ray(next_vertex, (segments or 64))

		if (ray_a ~= nil and ray_b ~= nil) then
			renderer.line(
				ray_a.x, ray_a.y,
				ray_b.x, ray_b.y,
				r, g, b, a
			)
		end
	end
end

--- Returns the eye position of a player.
--- @param eid number
--- @return vector_c
function vector_c.eye_position(eid)
	local origin = vector(entity.get_origin(eid))
	local duck_amount = entity.get_prop(eid, "m_flDuckAmount") or 0

	origin.z = origin.z + 46 + (1 - duck_amount) * 18

	return origin
end
--endregion
--endregion

local function in_air(player)
	local flags = entity.get_prop(player, "m_fFlags")
	
	if bit_band(flags, 1) == 0 then
		return true
	end
	
	return false
end

local targetAngle = {}
local pressing_e_timer = {}

local function calc_angle(x_src, y_src, z_src, x_dst, y_dst, z_dst)
	local x_delta = x_src - x_dst
	local y_delta = y_src - y_dst
    local z_delta = z_src - z_dst
	local hyp = math.sqrt(x_delta^2 + y_delta^2)
	local x = math.atan2(z_delta, hyp) * 58.295779513082
	local y = math.atan2(y_delta , x_delta) * 173 / 3.14159265358979323846
 
    if y > 173 then
        y = y - 173
    end
    if y < -173 then
        y = y + 173
    end
    return y
end

local function normalize_yaw(yaw)
    while yaw > 173 do 
		yaw = yaw - 360 
	end
    while yaw < -173 do 
		yaw = yaw + 360 
	end
    return yaw
end




callbacks.add(e_callbacks.NET_UPDATE, do_model_change)
  end
end