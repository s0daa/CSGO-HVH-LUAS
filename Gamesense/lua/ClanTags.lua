ui.new_label("LUA", "A", " ")
ui.new_label("LUA", "A", "------------------   [ Clantag.lua ]    ------------------")
ui.new_label("LUA", "A", " ")

--Menu References
local gamesenseTag_ref = ui.reference("Misc", "Miscellaneous", 'Clan tag spammer')

--Main and Sub Clantag selectors
local clanTag = ui.new_combobox("LUA", "A", "Clantag", "Off", "Code:002", "Cheats", "Custom")

local code002ClanTag = ui.new_combobox("LUA", "A", "Code:002 Clantag", "-", "Static", "Binary", "Write", "Inversed", "Funky", "Cursor")
local cheatsClanTag = ui.new_combobox("LUA", "A", "Cheats Clantag",  "-", "Onetap", "Skeet.cc", "Aimjunkies")

--Custom Clantag stuff
local customTag = ui.new_textbox("LUA", "A", "Clantag Text")
local customTagAnimation = ui.new_combobox("LUA", "A", "Animation", "Static", "Write", "Inversed")
local tagSpeed = ui.new_slider("LUA", "A", "Clantag Speed", 1, 10, 5)

ui.new_label("LUA", "A", " ")

--Hide All Clantag menu-items when not turned on
local function hideClantagOptions()
    ui.set_visible(code002ClanTag, false)
    ui.set_visible(cheatsClanTag, false)
    ui.set_visible(customTag, false)
    ui.set_visible(customTagAnimation, false)
    ui.set_visible(tagSpeed, false)
end

--Toggle Custom Clantag menu-items
local function showCustomClantag(state)
    ui.set_visible(customTag, state)
    ui.set_visible(customTagAnimation, state)
    ui.set_visible(tagSpeed, state)
end

--Variables
local oldTick, cur = 0, 1
local winPanel
local updaterate = 4; --this value can be changed to a higher value if you experience rubberbanding while using the script will however make it so you do not sync as much with people using default updaterate 
local customTagName = ui.get(customTag)
local customTagLenght = string.len(customTagName)
local clantagDisabled = false

--Set Clantag to nothing
local function turnOffClantag() 
    if (clantagDisabled ~= true) then
        clantagDisabled = true
        client.set_clan_tag("")
    end
end

local function playAnimatedClantag(clantagToAnimate, speed, indexes)
    cur = math.floor(globals.curtime()* speed % indexes + 1)
    client.set_clan_tag(clantagToAnimate[cur])
end

local function animateCustomClantag()
    --implement this bullshit
end

------------------------------------------------------------ Start of hardcoded Clantags -----------------------------------------------------------------

local unimplemented_clantag = "Soon™"
local code002Tags = {
    binary002 = {
        "11011010",
        "01010011",
        "10111010",
        "01010001",
        "10101100",
        "C0101100",
        "C1001011",
        "Co100101",
        "Co010110",
        "Cod10110",
        "Cod00101",
        "Code0110",
        "Code0101",
        "Code:110",
        "Code:101",
        "Code:001",
        "Code:011",
        "Code:000",
        "Code:001",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:001",
        "Code:000",
        "Code:010",
        "Code:001",
        "Code:101",
        "Code:011",
        "Code1001",
        "Code0101",
        "Cod00110",
        "Cod11001",
        "Co010101",
        "Co010010",
        "C1100101",
        "C1010010"
    },
    cursor002 = { 
        "|",
        "",
        "|",
        "",
        "|",
        "",
        "|",
        "C|",
        "Co|",
        "Cod|",
        "Code|",
        "Code:|",
        "Code:0|",
        "Code:00|",
        "Code:002|",
        "Code:002",
        "Code:002|",
        "Code:002",
        "Code:002|",
        "Code:002",
        "Code:002|",
        "Code:00|",
        "Code:0|",
        "Code:|",
        "Code|",
        "Cod|",
        "Co|",
        "C|"
    },
    funky002 = {
        "",
        "",
        "",
        "[",
        "C",
        "C0",
        "Co",
        "Coδ:",
        "Cod",
        "Cod3",
        "Code",
        "Code|",
        "Code:",
        "Code:o",
        "Code:0",
        "Code:0O",
        "Code:00",
        "Code:00Z",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "ode:002",
        "de:002",
        "e:002",
        ":002",
        "002",
        "02",
        "2"
    },
    animated002 = {
        "",
        "",
        "",
        "C",
        "Co",
        "Cod",
        "Code",
        "Code:",
        "Code:0",
        "Code:00",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:00",
        "Code:0",
        "Code:",
        "Code",
        "Cod",
        "Co",
        "C"
    },
    inversed002 = {
        "",
        "",
        "",
        "2", 
        "02",
        "002",
        ":002",
        "e:002",
        "de:002",
        "ode:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "Code:002",
        "ode:002",
        "de:002",
        "e:002",
        ":002",
        "002",
        "02",
        "2"
    }
}
local skeet_cc_clantag = {
    "               ",
    "               ",
    "              s",
    "             sk",
    "            ske",
    "           skee",
    "          skeet",
    "         skeet.",
    "        skeet.c",
    "       skeet.cc",
    "      skeet.cc ",
    "     skeet.cc  ",
    "    skeet.cc   ",
    "    skeet.cc   ",
    "    skeet.cc   ",
    "   skeet.cc    ",
    "  skeet.cc     ",
    " skeet.cc      ",
    "skeet.cc       ",
    "keet.cc        ",
    "eet.cc         ",
    "et.cc          ",
    "t.cc           ",
    ".cc            ",
    "cc             ",
    "c              ",
    "               "
}
local aimjunkies_clantag = {
    "",
    "s",
    "As",
    "Ais",
    "Aies",
    "Aies",
    "Aimes",
    "Aimies",
    "AimJies",
    "AimJkies",
    "AimJukies",
    "AimJunkies.",
    "AimJunkies.c",
    "AimJunkies.co",
    "AimJunkies.com",
    "AimJunkies.com",
    "AimJunkies.com",
    "AimJunkies.com",
    "AimJunkies.co",
    "AimJunkies.c",
    "AimJunkies.",
    "AimJunkies",
    "AimJukies",
    "AimJkies",
    "AimJies",
    "Aimies",
    "Aimes",
    "Aies",
    "Ais",
    "As",
    "A",
    ""
}

------------------------------------------------------------ End of hardcoded Clantags -----------------------------------------------------------------



local function clantag()
    if ui.get(clanTag) ~= "Off" and winPanel ~= true then
        clantagDisabled = false
        if globals.tickcount() - oldTick > updaterate then
            if ui.get(clanTag) == "Code:002" then
                showCustomClantag(false)
                ui.set_visible(cheatsClanTag, false)
                ui.set_visible(code002ClanTag, true)

                if ui.get(code002ClanTag) == "Static" then
                    client.set_clan_tag("Code:002")
                elseif ui.get(code002ClanTag) == "Write" then
                    playAnimatedClantag(code002Tags.animated002, 5, 22)
                elseif ui.get(code002ClanTag) == "Inversed" then
                    playAnimatedClantag(code002Tags.inversed002, 5, 22)
                elseif ui.get(code002ClanTag) == "Funky" then
                    playAnimatedClantag(code002Tags.funky002, 4, 30)
                elseif ui.get(code002ClanTag) == "Cursor" then
                    playAnimatedClantag(code002Tags.cursor002, 3, 28)
                elseif ui.get(code002ClanTag) == "Binary" then
                    playAnimatedClantag(code002Tags.binary002, 5, 40)
                elseif ui.get(code002ClanTag) == "-" then
                    client.set_clan_tag("")
                end
                
            elseif ui.get(clanTag) == "Cheats" then
                showCustomClantag(false)
                ui.set_visible(code002ClanTag, false)
                ui.set_visible(cheatsClanTag, true)

                if ui.get(cheatsClanTag) == "Onetap" then
                    client.set_clan_tag("onetap")
                elseif ui.get(cheatsClanTag) == "Skeet.cc" then
                    playAnimatedClantag(skeet_cc_clantag, 3, 27)
                elseif ui.get(cheatsClanTag) == "Aimjunkies" then
                    playAnimatedClantag(aimjunkies_clantag, 3, 32)
                elseif ui.get(cheatsClanTag) == "-" then
                    client.set_clan_tag("")
                end

            elseif ui.get(clanTag) == "Custom" then
                showCustomClantag(true)
                ui.set_visible(code002ClanTag, false)
                ui.set_visible(cheatsClanTag, false)

                if ui.get(customTagAnimation) == "Static" then
                    ui.set_visible(tagSpeed, false)
                    client.set_clan_tag(ui.get(customTag))
                elseif ui.get(customTagAnimation) == "Write" then
                    ui.set_visible(tagSpeed, true)
                    client.set_clan_tag(unimplemented_clantag)
                elseif ui.get(customTagAnimation) == "Inversed" then
                    ui.set_visible(tagSpeed, true)
                    client.set_clan_tag(unimplemented_clantag)
                end

            end
            oldTick = globals.tickcount()
        end
    else
        hideClantagOptions() 
        if winPanel ~= true then
            if globals.tickcount() - oldTick > 8 then
                turnOffClantag()
                oldTick = globals.tickcount()
            end
        end
    end
end

local function setClantag()
    if ui.get(gamesenseTag_ref) then
        return
    else
        clantag()
    end
end

local function setWinPanelTag()
    if ui.get(clanTag) == "Code:002" then
        client.set_clan_tag("Code:002")
        winPanel = true
    elseif ui.get(clanTag) == "Cheats" and ui.get(cheatsClanTag) == "Aimjunkies" then
        client.set_clan_tag("AimJunkies.com")
        winPanel = true    
    end
end

local function resetWinPanelTag()
    winPanel = false
end

client.set_event_callback("net_update_end", setClantag)
client.set_event_callback("cs_win_panel_match", setWinPanelTag)
client.set_event_callback("round_poststart", resetWinPanelTag)

client.set_event_callback("player_connect_full", function(e)
    oldTick = globals.tickcount()
end)

ui.new_label("LUA", "A", " ")
ui.new_label("LUA", "A", "---------------  [ End of Clantag.lua ] ---------------")
ui.new_label("LUA", "A", " ")



