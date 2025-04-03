--\
--/    working on this shit as a new project
--\    started at like 2am 6/5/22
--/                             
--| MENU ELEMENTS |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\       i thought these seperators and shit would look way nicer than they do
-- MAIN
---------------
-- welcome
local text = menu.add_text("    --== Welcome ==--", "----     Kuro.lua     ----")
local text = menu.add_text("    --== Welcome ==--", 'Current user: ' .. user.name)
local text = menu.add_text("    --== Welcome ==--", 'UID: ' .. user.uid)
local text = menu.add_text("    --== Welcome ==--", "Build: [Release]")
local text = menu.add_text("    --== Welcome ==--", "Last updated: 06/14/2022") -- one week of development got me 1741 lines of shit
local text = menu.add_text("    --== Welcome ==--", "Enjoy!")

-- main
local master_switch  = menu.add_checkbox("-- Main --", "master switch")

-- set column
menu.set_group_column("-- Main --", 1)
---------------

-- ANTI-AIM
---------------    boring menu shit :barf emoji:
    -- master switch
local antiaim         = menu.add_checkbox("-- Anti Aim --", "enable anti aim")
    -- presets
local presets         = menu.add_selection("-- Anti Aim --", "presets", {"none", "aggressive 1", "aggressive 2", "jitter 1", "jitter 2", "hs only 1", "hs only 2", "rotate", "velocity 1", "velocity 2"})
    -- jitter stuff
local menu_condition  = menu.add_selection("-- Anti Aim --", "jitter condition", {"stand", "move", "slow walk"})
local jitter          = menu.add_checkbox("-- Anti Aim --", "custom jitter")
local override_move   = menu.add_checkbox("-- Anti Aim --", "override stand (moving)")
local override_slow   = menu.add_checkbox("-- Anti Aim --", "override stand (slow walk)")
-- stand
local jitter_angle_1  = menu.add_slider("-- Anti Aim --", "jitter angle 1", -180, 180, 1, 0, "°")
local jitter_angle_2  = menu.add_slider("-- Anti Aim --", "jitter angle 2", -180, 180, 1, 0, "°")
local desync_amount_1 = menu.add_slider("-- Anti Aim --", "desync amount 1", -100, 100, 1, 0, "%")
local desync_amount_2 = menu.add_slider("-- Anti Aim --", "desync amount 2", -100, 100, 1, 0, "%")
-- slow walk
local jitter_angle_1move  = menu.add_slider("-- Anti Aim --", "jitter angle 1 ", -180, 180, 1, 0, "°")
local jitter_angle_2move  = menu.add_slider("-- Anti Aim --", "jitter angle 2 ", -180, 180, 1, 0, "°")
local desync_amount_1move = menu.add_slider("-- Anti Aim --", "desync amount 1 ", -100, 100, 1, 0, "%")
local desync_amount_2move = menu.add_slider("-- Anti Aim --", "desync amount 2 ", -100, 100, 1, 0, "%")
-- move
local jitter_angle_1slow  = menu.add_slider("-- Anti Aim --", "jitter angle 1  ", -180, 180, 1, 0, "°")
local jitter_angle_2slow  = menu.add_slider("-- Anti Aim --", "jitter angle 2  ", -180, 180, 1, 0, "°")
local desync_amount_1slow = menu.add_slider("-- Anti Aim --", "desync amount 1  ", -100, 100, 1, 0, "%")
local desync_amount_2slow = menu.add_slider("-- Anti Aim --", "desync amount 2  ", -100, 100, 1, 0, "%")

local jitter_speed    = menu.add_slider("-- Anti Aim --", "jitter speed", 0, 5)

    -- rotate stuff
local rotate          = menu.add_checkbox("-- Anti Aim --", "rotate")
local rotate_angle    = menu.add_slider("-- Anti Aim --", "rotate range", 0, 360, 1, 0, "°")
local rotate_speed1   = menu.add_slider("-- Anti Aim --", "rotate speed", 0, 100, 1, 0, "%")
    -- velocity jitter stuff
local velocity_jitter = menu.add_checkbox("-- Anti Aim --", "velocity jitter")
local vel_max_angle   = menu.add_slider("-- Anti Aim --", "velocity jitter max angle", 0, 180, 1, 0, "°")
local vel_min_angle   = menu.add_slider("-- Anti Aim --", "velocity jitter min angle", 0, 180, 1, 0, "°")
local vel_multiplier  = menu.add_slider("-- Anti Aim --", "velocity multiplier", 0, 100, 1, 0, "%")

-- fake flick stuff
local fake_flick      = menu.add_checkbox("-- Anti Aim --", "fake flick")
local flick_freq      = menu.add_slider("-- Anti Aim --", "fake flick frequency", 0, 4, 1, 0, "/s")
local flick_angle     = menu.add_slider("-- Anti Aim --", "fake flick angle", 0, 180, 1, 0, "°")

-- Anti Aim Extras
local pitch1          = menu.add_selection("-- Anti Aim Extras --", "pitch", {"none", "down", "up", "zero", "jitter"})
local onshot1         = menu.add_selection("-- Anti Aim Extras --", "onshot", {"off", "opposite", "same side", "random"})
local leg_slide1      = menu.add_selection("-- Anti Aim Extras --", "leg slide", {"neutral", "never", "always", "jitter"})
local do_auto_direct  = menu.add_selection("-- Anti Aim Extras --", "auto direction mode", {"none", "viewangle", "at targets (crosshair)", "at targets (distance)", "velocity"})
local do_antibrute    = menu.add_checkbox("-- Anti Aim Extras --", "anti bruteforce")

-- set column(s)
menu.set_group_column("-- Anti Aim --", 2)
menu.set_group_column("-- Anti Aim Extras --", 2)
---------------

-- MISC
---------------
local enable_misc    = menu.add_checkbox("-- Misc --", "enable misc")
local text1          = menu.add_text("-- Misc --", "menu bar accent")
local bar_color1     = text1:add_color_picker("bar color")
local bar_color      = text1:add_color_picker("bar color 2")
local fast_autobuy   = menu.add_selection("-- Misc --", "faster autobuy", {"off", "scout", "awp"})
local event_says     = menu.add_multi_selection("-- Misc --", "event says", {"kill say (overrides mvp/win say sometimes)", "death say", "hurt say (overrides deathsay)", "chicken kill say", "fall damage", "hostage picked up", "hostage rescued", "round mvp (overrides round win)", "weapon inspect", "pick up item", "round won", "defuse start", "plant start", "bomb explosion", "grenade thrown"})
local animations     = menu.add_multi_selection("-- Misc --", "animations", {"zero pitch on land", "static legs in air"})
local tp_on_key      = menu.add_text("-- Misc --", "teleport on key")
local tp_bind        = tp_on_key:add_keybind("Teleport")
local menu_bg        = menu.add_checkbox("-- Misc --", "menu background")
local halo           = menu.add_checkbox("-- Misc --", "head dot")
local dot_color      = halo:add_color_picker("-- Misc --", "dot color")
local remove_sleeves = menu.add_checkbox("-- Misc --", "remove sleeves")
local prim_watermark = menu.add_checkbox("-- Misc --", "remove primordial watermark")
local hs_ideal_tick  = menu.add_checkbox("-- Misc --", "hideshots ideal tick")
local disable_blur   = menu.add_checkbox("-- Misc --", "disable panorama blur")
local disable_chat   = menu.add_checkbox("-- Misc --", "hide chat")
local quit_on_death  = menu.add_checkbox("-- Misc --", "quit game on death")
local chat_logs      = menu.add_checkbox("-- Misc --", "chat aimbot logs")
-- set column
menu.set_group_column("-- Misc --", 1)
---------------

-- CUSTOM GAME OPTIONS
---------------
local custom_game_enable = menu.add_checkbox("-- Custom Game --", "enable custom game options")
    -- CHEATS
local sv_cheats          = menu.add_button("-- Custom Game --", "sv_cheats 1", function()
    engine.execute_cmd("sv_cheats 1")
end)
    --AIR ACCELERATE
local sv_airaccelerate   = menu.add_button("-- Custom Game --", "sv_airaccelerate 10000", function()
    engine.execute_cmd("sv_airaccelerate 10000")
end)  
    -- MAXVELOCITY
local sv_maxvelocity     = menu.add_button("-- Custom Game --", "sv_maxvelocity 10000", function()
    engine.execute_cmd("sv_maxvelocity 10000")
end)  
    -- ROUND TIME
local mp_roundtime       = menu.add_button("-- Custom Game --", "mp_roundtime 60", function()
    engine.execute_cmd("mp_roundtime 60")
    engine.execute_cmd("mp_roundtime_defuse 60")
    engine.execute_cmd("mp_roundtime_hostage 60")
end)
    -- MAX ROUNDS
local mp_maxrounds       = menu.add_button("-- Custom Game --", "mp_maxrounds 10000", function()
    engine.execute_cmd("mp_maxrounds 10000")
end)
    -- LIMIT TEAMS
local mp_limitteams      = menu.add_button("-- Custom Game --", "mp_limitteams 0", function()
    engine.execute_cmd("mp_limitteams 0")
end)
    -- TEAM BALANCE
local mp_autoteambalance = menu.add_button("-- Custom Game --", "mp_autoteambalance 0", function()
    engine.execute_cmd("mp_autoteambalance 0")
end) -- hi script mod
    -- BUY TIME
local mp_buytime         = menu.add_button("-- Custom Game --", "mp_buytime 10000", function()
    engine.execute_cmd("mp_buytime 10000")
end)
    -- MAXMONEY
local mp_maxmoney        = menu.add_button("-- Custom Game --", "mp_maxmoney 64000", function()
    engine.execute_cmd("mp_maxmoney 64000")
end)
    -- BUY ANYWHERE
local mp_buy_anywhere    = menu.add_button("-- Custom Game --", "mp_buy_anywhere 1", function()
    engine.execute_cmd("mp_buy_anywhere 1")
end)
    -- IMPULSE 101 / GIVE MAX MONEY
local impulse            = menu.add_button("-- Custom Game --", "impulse 101 (give max money)", function()
    engine.execute_cmd("impulse 101")
end)
    -- KICK BOTS
local bot_kick           = menu.add_button("-- Custom Game --", "bot_kick", function()
    engine.execute_cmd("bot_kick")
end)
    -- ADD CT BOT
local bot_add_ct         = menu.add_button("-- Custom Game --", "bot_add_ct", function()
    engine.execute_cmd("bot_add_ct")
end)
    -- ADD T BOT
local bot_add_t          = menu.add_button("-- Custom Game --", "bot_add_t", function()
    engine.execute_cmd("bot_add_t")
end)

-- set column
menu.set_group_column("-- Custom Game --", 1)
---------------

-- INDICATORS
---------------
local indicators = menu.add_checkbox("-- Indicators --", "enable indicators")

local indicator_bar      = menu.add_checkbox("-- Indicators --", "indicator bar")
local barcolor           = indicator_bar:add_color_picker("outline color")

local shot_stats         = menu.add_checkbox("-- Indicators --", "shot stats")
local stats_x            = menu.add_slider("-- Indicators --", "stats x pos", 0, 1920)
local stats_y            = menu.add_slider("-- Indicators --", "stats y pos", 0, 1080)

local watermark          = menu.add_checkbox("-- Indicators --", "custom watermark")
local watermark_color    = watermark:add_color_picker("accent color")
local watermark_style    = menu.add_selection("-- Indicators --", "watermark style", {"style 1", "style 2", "supremacy (best)"})

local jitter_side        = menu.add_checkbox("-- Indicators --", "jitter side arrows")
local jitter_color       = jitter_side:add_color_picker("color")
local jitter_style       = menu.add_selection("-- Indicators --", "arrow style", {"style 1", "style 2", "style 3"})
local jitter_size        = menu.add_slider("-- Indicators --", "jitter side arrow size", 0, 100)
local jitter_side_offset = menu.add_slider("-- Indicators --", "jitter side arrow offset", -25, 200)


-- set column
menu.set_group_column("-- Indicators --", 2)
---------------

-- SERVER PICKER
---------------
local servers     = menu.add_checkbox("-- Server Browser --", "enable server browser")
local server_list = menu.add_list("-- Server Browser --", "Servers:", {"NoHyper HvH | SCOUT ONLY (NA)", -- eu, na, jp, iran, sa, im so inclusive!
                                                                "Lucky's HvH Spread | Mirage/D2_OLD (NA)", 
                                                                "Big Steppa HvH DM (NA)", 
                                                                "d0c HvH (NA)", 
                                                                "Profit$ Mirage only (NA)", 
                                                                "DesyncHvH HS Only (NA)", 
                                                                "ChairHvH Scout HS Only (NA)", 
                                                                "Noob Dog's Software Showdown (NA)",
                                                                "NoHyper HvH | NO AWP (NA)",
                                                                "Noble nospread (NA)",
                                                                "NoBrain scout only (NA)",
                                                                "Rantei$ mirage spread (EU)",
                                                                "Desolate mirage spread (EU)",
                                                                "Desolate mirage deathmatch (EU)",
                                                                "uwujka.pl (EU)",
                                                                "NeonHvH (EU)",
                                                                "GalaxyHvH (EU)",
                                                                "Dark Project (EU)",
                                                                "GenesisHvH (EU)",
                                                                "Sharkproject (EU)",
                                                                "JereHvH | Office Only (EU)",
                                                                "JereHvH | Mirage Only (EU)",
                                                                "CatoHvH (BRAZIL/SA)",
                                                                "SA Central (BRAZIL/SA)",
                                                                "GalaxyHvH (JP)",
                                                                "RemboHvH (IRAN)"
}) -- putting this down here so pressing tab doesnt do some massive jump

local join_server = menu.add_button("-- Server Browser --", "join selected server", function()
    local serverip = {
        "192.223.24.31:27015", -- nohyper scout only
        "192.223.26.36:27015", -- luckys
        "74.91.124.24:27015", -- big steppa
        "74.91.124.40:27015", -- d0c
        "135.148.53.7:27015", -- profit$
        "74.91.112.131:27015", -- desynchvh
        "192.223.30.223:27015", -- chair hs only
        "51.79.39.133:27046", -- noob dog
        "74.91.123.177:27015", -- nohyper no awp
        "135.148.136.239:27016", -- Noble NA nospread 
        "162.255.87.210:27011", -- NoBrain scout only
        "181.214.231.125:27015", -- Rantei$ EU mirage spread
        "64.52.81.119:27035", -- Desolate EU mirage spread
        "64.52.81.119:27045", -- Desolate EU mirage deathmatch
        "54.38.198.99:27015", -- uwujka
        "188.212.101.13:27015", -- neonhvh
        "89.40.104.225:27015", -- galaxy eu
        "37.230.228.178:1337", -- dark project
        "45.235.98.233:27080", -- genesishvh
        "37.230.228.116:27015", -- sharkproject
        "65.108.42.222:27030", -- jere office
        "95.217.61.238:27015", -- jere mirage
        "20.226.34.230:27015", -- cato
        "177.54.144.122:27302", -- sa central
        "52.185.184.11:27015", -- galaxy jp
        "185.141.133.16:28812" -- rembohvh
    }

    local connect_cmd = "connect " .. serverip[server_list:get()] -- such good code
    engine.execute_cmd(connect_cmd)
end)
---------------

-- OTHER
---------------
local text = menu.add_text("-- Help (READ THIS) --", "This tab is just stuff to know before using.")
local text = menu.add_text("-- Help (READ THIS) --", "")
local text = menu.add_text("-- Help (READ THIS) --", "(1) If you have any questions about the script,")
local text = menu.add_text("-- Help (READ THIS) --", "ask them either on my discord (stars 3787)")
local text = menu.add_text("-- Help (READ THIS) --", "or in the script comments. (give 5 stars <3)")
local text = menu.add_text("-- Help (READ THIS) --", "")
local text = menu.add_text("-- Help (READ THIS) --", "(2) Velocity jitter multiplier is multiplying your")
local text = menu.add_text("-- Help (READ THIS) --", "speed in units/s by whatever value you put there.")
local text = menu.add_text("-- Help (READ THIS) --", "For example, if you are going 250 u/s with a 10%")
local text = menu.add_text("-- Help (READ THIS) --", "multiplier you will have 25 -25 jitter.")

-- set column
menu.set_group_column("-- Help (READ THIS) --", 1)
---------------

-- MENU.FIND
---------------
local yaw_base        = menu.find("antiaim", "main", "angles", "yaw add"                 )
local rotate_enable   = menu.find("antiaim", "main", "angles", "rotate"                  )
local rotate_range    = menu.find("antiaim", "main", "angles", "rotate range"            )
local rotate_speed    = menu.find("antiaim", "main", "angles", "rotate speed"            )
local desync_side     = menu.find("antiaim", "main", "desync", "side"                    ) 
local desync_amount_l = menu.find("antiaim", "main", "desync", "left amount"             )
local desync_amount_r = menu.find("antiaim", "main", "desync", "right amount"            ) 
local antibrute       = menu.find("antiaim", "main", "desync", "anti bruteforce"         )
local cheat_jitter    = menu.find("antiaim", "main", "angles", "jitter mode"             )
local auto_direct     = menu.find("antiaim", "main", "angles", "yaw base"                )
local pitch           = menu.find("antiaim", "main", "angles", "pitch"                   )
local onshot          = menu.find("antiaim", "main", "desync", "on shot"                 )
local override_stand  = menu.find("antiaim", "main", "desync", "override stand#move"     )
local override_stand1 = menu.find("antiaim", "main", "desync", "override stand#slow walk")
local leg_slide       = menu.find("antiaim", "main", "general", "leg slide"              )
local fake_lag_value  = menu.find("antiaim", "main", "fakelag", "amount"                 )
local slowwalk_key    = menu.find("misc", "main", "movement", "slow walk"                )[2]
local dt_key          = menu.find("aimbot", "general", "exploits", "doubletap", "enable" )[2]
local hs_key          = menu.find("aimbot", "general", "exploits", "hideshots", "enable" )[2]
---------------

-- GLOBAL SHIT
---------------
-- chat printing lib (no include cus im cool) also using the one made by a normal person instead of the weird tranny furry
local ffi = require("ffi")

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28"))
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat")
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27])

local function PrintInChat(text)
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end


-- save initial settings
local sYaw_base        = yaw_base:get()
local sRotate_enable   = rotate_enable:get()
local sMrotate_range   = rotate_range:get()
local sMrotate_speed   = rotate_speed:get()
local sDesync_side     = desync_side:get()
local sDesync_amount_l = desync_amount_l:get()
local sDesync_amount_r = desync_amount_r:get()
local sAntibrute       = antibrute:get()
local sCheat_jitter    = cheat_jitter:get()
local sAuto_direct     = auto_direct:get()
local sPitch           = pitch:get()
local sOnshot          = onshot:get()
local sOverride_stand  = override_stand:get()
local sLeg_slide       = leg_slide:get()
-- uses these to revert settings on shutdown

local bg_alpha    = 0
local ground_tick = 1
local end_time    = 0
local uncharge    = 0
local occlusion_misses = 0
local body_misses = 0
local head_misses = 0
local pred_misses = 0
local spread_misses    = 0
local resolver_misses  = 0
local misses = 0
local hits   = 0
local condition    = 0
local default_font = render.get_default_font()
local tahoma       = render.create_font("Tahoma", 15, 20)
local flick_state  = 0
local side   = 0
local state  = 0
---------------

-- TABLES
---------------
local replacements = {
    ["{white}"] = "\x01",
    ["{darkred}"] = "\x02",
    ["{team}"] = "\x03",
    ["{green}"] = "\x04",
    ["{lightgreen}"] = "\x05",
    ["{lime}"] = "\x06",
    ["{red}"] = "\x07",
    ["{grey}"] = "\x08",
    ["{yellow}"] = "\x09",
    ["{bluegrey}"] = "\x0A",
    ["{blue}"] = "\x0B",
    ["{darkblue}"] = "\x0C",
    ["{purple}"] = "\x0D",
    ["{violet}"] = "\x0E",
    ["{lightred}"] = "\x0F",
    ["{orange}"] = "\x10",
    ["  +"] = function(c)
        return " " .. ("\x18 "):rep(c:len()-1)
    end
}

local hitboxes = {
    "head",
    "neck",
    "pelvis",
    "stomach",
    "lower chest",
    "chest",
    "upper chest",
    "right leg",
    "left leg",
    "right leg",
    "left leg",
    "right foot",
    "left foot",
    "right hand",
    "left hand",
    "right arm",
    "right arm",
    "left arm",
    "left arm",
    "max"
}

local mvp_says = {
    "I just got round MVP on you dumbass niggas!",
    "BOO-YAH! Another MVP in the bag!",
    "Most. Valuable. Player. EVER.",
    "EVERYONE IS WORSE THAN ME. I AM THE MVP!",
    "I am the most valuable, bow down before me peasants.",
    "me > u. i am MVP, u are LVP",
    "All hvher less than mvp god",
    "I just raped the enemy team, now i MVP",
    "WOOOO! I WIN!!! GET FUCKED!!",
    "i mvp, u trash"
}

local kill_says = {
    "i hvh god for family",
    "no1 bettr than me, god",
    "my software > your software",
    "Kuro.lua is my favorite <33",
    "weak south american rat killed by ugandan goddess",
    "my ip is 192.168.1.1 ddos me",
    "my gun shoot u and u perish",
    "me: 6'3. you: 4'2",
    "racecar is a palendrome",
    "a palendrome is a word that is spelled the same way forwards and backwards",
    "feminine boy hvher ran over by my tonka.",
    "//w//",
    "i wore 'programming socks' when i made this lua :3",
    "bow down to master",
    "i am lord jesus christ savior of humanity",
    "praise god or burn in hell",
    "hs 1 hdf nn dog weak rat i kill you and u perish bow down to me i legend hvh god best player no1 bettr",
    "this is the 18th killsay in Kuro.lua",
    "'if we catch you in the lift we gon lift you out the lift' - courvix the real nigga", -- real courvix quote btw
    "this killsay is at line 455 in Kuro.lua",
    "what am i doing with my life...",
    "i wish everyone would forget about me and i would just die",
    "uwu 1 owo hdf nn :3",
    "transgender people are mentally ill and should seek help",
    "i kill trannies for a living",
    "u fat me not",
    "goo goo gaa gaa",
    "u just got bombed harder than ukraine.",
    "im listening to nightcore rn",
    "this is the 28th killsay in Kuro.lua",
    "many ppl claim my lua bad, but Kuro.lua defeat u",
    "ducarii the boss update femboy hack so i hit p on you",
    "i hvh legende for family and friends",
    "u just got popped harder than i popped your mom's pussy",
    "this is a killsay im not actually toxic, calm down",
    "i enjoy gay porn",
    "i enjoy femboy porn"
}

local death_says = {
    "ouchieee u just killed me!",
    "why u kill me u bitch",
    "u kill me this time, but i will be back next round",
    "you just owned me master!~~",
    "ur bullet in my head",
    "onii-chan yameteee!~~",
    "trans player kill me, i will be back",
    "i just got 1'd by the better player",
    "my antiaimz configuration was insufficient...",
    "i die, i fix cfg. only cfg issue not skill issue, i am pro.",
    "Kuro.lua carries me but it cant account for my lack of skill",
    "'''''''''111'''''''''",
    "YOU DEFEAT ME THIS OCCURENCE BUT NEXT I BE RETURNING",
    "ping carried dog ax me and i die",
    "please stop killing my im sorry im new to hvh",
    "i was just humiliated by the better player",
    "owwieee whyd u do that???",
    "if u keep killing me like that im gonna get turned on....",
    "im gonna need to kiss you if you keep doing that to me!~~~",
    "i put a rubber glove into a pringles can and i fuck it",
    "bot get lucky to kill me, jesus christ the lord.",
    "i use cum as mouthwash",
    "pepsi is pretty tasty tbh, maybe even better than coke...",
    "u just bottle flipped ontop my head and killed me",
    "u kill me cus u gay",
    "this death say is at line 501 in Kuro.lua"
}

local hurt_says = {
    "owwie u shot me",
    "that huwt!!~",
    "stop shoot me bot",
    "i have ur bullet inside me~~",
    "weak bot hurt me, i get revenge",
    "i will kill u for hurting lord and savior jesus christ",
    "u shoot me, u gay.",
    "stop attacking me",
    "my hp is under 100 now, thanks to you",
    "i just got shot by a tranny loving bitch",
    "uwu u just shot me owo :3"
}

local chicken_says = {
    "I JUST SMOKED A FUCKING CHICKEN. GET REKT.",
    "chicken nuggiessssss",
    "chicken tendieessss",
    "CHICKEN DOWN. I REPEAT, CHICKEN DOWN.",
    "CLUCK CLUCK SAID THE CHICKEN, I KILL CHICKEN.",
    "i kill chicken for family to eat",
    "poultry exterminated",
    "stop clucking at me you stupid fucking chicken",
    "i am chikin murderer",
    "i just murdered an innocent chicken",
    "bawk bawk said the chikin, until i shot it",
    "im making a pillow out of dead chicken feathers",
    "big fat chikin going in my tummy tonight :belly emoji:",
    "black, white, orange, i dont care. i still kill chicken." -- no racism here
}

local falldamage_says = {
    "i just took fall damage cus im a fucking retard",
    "i fell off a ledge and now i have less than 100hp",
    "owwie! im retarded and took fall damage!!",
    "i just broke my fucking legs"
}

local falldamage1_says = {
    "SOME DUMBASS NIGGA JUST TOOK FALL DAMAGE LOL",
    "which retard just too fall damage",
    "some dumbass just fell off a ledge and took fall damage",
    "how dumb do you have to be to take fall damage..."
}

local hostage_says = {
    "i just stole your hostage retards",
    "MY HOSTAGE NOW BITCH!",
    "im gonna rape this hostage when i get it back to safety ;)",
    "fuck you terrorists, im stealing the hostage",
    "how u silly ass niggas let me steal ur hostage?",
    "ew this hostage smell like shit, wtf did you guys do to it?",
    "uwu im taking ur pwecious hostage what u gonna do about it?~~"
}

local hostage1_says = {
    "I JUST RESCUED THE HOSTAGE. GET FUCKED",
    "I WIN U LOSE",
    "i GOD u RAT. my hostage now!",
    "hostage rescued and safe. i win",
    "ez hostage you niggas trash",
    "this hostage fat as fuck, i can finally put it down now that i won the round.",
    "counter terrorists > terrorists. cry",
    "i rescue hostage, u rescue no1"
}

local inspect_says = {
    "im admiring my weapon rn cus yall so trash im bored",
    "staring at the beautiful metal on my firearm rn",
    "inspecting my weapon is so mezmerizing",
    "i just inspected the weapon held by the #1 player",
    "so tired of u trash ass mfs that im looking at my gun instead of playing"
}

local pickup_says = {
    "i just picked up some dead niggas gun lol",
    "your gun, my hands. ez",
    "gun = mine now. i take, u die",
    "some fatass died, now im stealing his gun."
}

local win_says = {
    "i just won the round cus you guys suck ass at the game.",
    "i god, u loser. i win",
    "get fucked on trash playerz i won",
    "ez win stay mard",
    "uwu so ez nyaa ez round win :3"
}

local defuse_says = {
    "who just started defusing the bomb?",
    "why defuse u monkey? i come for u and kill",
    "defusing initiated, bomb scheduled to be defused in 5 seconds.",
    "snip wire on bomb, bomb no more boom(b)"
}

local plant_says = {
    "bomb start plant, allahu ackbar",
    "praise allah brother. bomb plant initiated",
    "HONOR TO ISIS, HONOR TO AL QAEDA!!!!!!",
    "bomb plant start, defusers will be shot"
}

local explode_says = {
    "ALLAHU ACKBAR! HONOR TO ISIS! BOMB EXPLODED!!",
    "PRAISE ALLAH REJECT WESTERN CULTURE. BOMB BOOOM BOOOOOM",
    "BOMB. BOMB. BOMB. BOOOOOOMMMM!!!",
    "Weapons cache destroyed. Mission complete. Well done soldier!"
}

local throw_says = {
    "I throw grenade, u go boom",
    "feel the wrath of my hand-held explosion machine!",
    "this go boom on u, i win round.",
    "i throw nade cus i best hvh, u throw nade cus worst hvh."
}

local throw1_says = {
    "some retard just threw a nade",
    "which shitter just threw a nade cus they cant hvh normally?",
    "you nade cus trash, i nade cus good",
    "stop throwing grenades you fat fuck",
    "so bad that u cant win without nades, thats why u just threw one.",
    "no1 kill me without nade, that why u throw nade just now"
}
---------------

--///////////////////////////////////////////////










--| MAIN |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function main(cmd)
    if master_switch:get() then
        local local_player     = entity_list.get_local_player()
        local vjitter_angle_1  = jitter_angle_1:get()
        local vjitter_angle_2  = jitter_angle_2:get()
        local vdesync_amount_1 = desync_amount_1:get()
        local vdesync_amount_2 = desync_amount_2:get()

        -- Hideshots ideal tick (doing it here with a variable makes it so it waits until auto peek starts instead of teleporting out)
        if uncharge == 1 and not dt_key:get() and hs_key:get() then 
            exploits.force_uncharge() -- best misc feature in like 10 lines total
            uncharge = 0
        end

        -- velocity jitter shit
        local vel_mult              = vel_multiplier:get() / 100
        local vel_min               = vel_min_angle:get()
        local vel_max               = vel_max_angle:get()
        local velocity              = local_player:get_prop("m_vecVelocity"):length()   
        local velocity_jitter_angle = velocity * vel_mult
        
        
        if velocity_jitter_angle < vel_min then
            velocity_jitter_angle = vel_min
        end
        if velocity_jitter_angle > vel_max then
            velocity_jitter_angle = vel_max
        end

        -- set condition
        if velocity == 0 then
            condition = 1 -- stand
        end
        if velocity > 0 then
            condition = 2 -- move
        end
        if override_slow:get() then
            if slowwalk_key:get() then
                condition = 3 -- slow walk
            end
        end

        if override_move:get() then
            if condition == 2 then
                vjitter_angle_1  = jitter_angle_1move:get()
                vjitter_angle_2  = jitter_angle_2move:get()
                vdesync_amount_1 = desync_amount_1move:get()
                vdesync_amount_2 = desync_amount_2move:get()
            end
        end

        if override_slow:get() then
            if condition == 3 then 
                vjitter_angle_1  = jitter_angle_1slow:get()
                vjitter_angle_2  = jitter_angle_2slow:get()
                vdesync_amount_1 = desync_amount_1slow:get()
                vdesync_amount_2 = desync_amount_2slow:get()
            end
        end

        if velocity_jitter:get() then
            vjitter_angle_1 = velocity_jitter_angle
            vjitter_angle_2 = velocity_jitter_angle * -1
            vdesync_amount_1 = desync_amount_1:get()
            vdesync_amount_2 = desync_amount_2:get()
        end
    
        if jitter:get() then -- might be pasted from my other script, but at least i added conditions and fake flick
            override_stand:set(false)
            override_stand1:set(false)
            cheat_jitter:set(1)
        

            -- makes it so 5 is fastest instead of slowest (5 = 1, 4 = 2, and so on.)
            local jitter_speed1 = jitter_speed:get() * -1 + 7
            -- if its 0 i dont want it to be +7, so make it 0 again
            if jitter_speed:get() == 0 then
                jitter_speed1 = 0
            end
        
            if state > 0 then
                yaw_base:set(vjitter_angle_1)
                
                -- set side for indicator
                if vjitter_angle_1 > 0 then
                    side = 1
                else
                    side = 0
                end
        
                if vdesync_amount_1 < 0 then 
                    desync_side:set(2)
                    desync_amount_l:set(vdesync_amount_1 * -1)
                    desync_amount_r:set(vdesync_amount_1 * -1)
                else
                    desync_side:set(3)
                    desync_amount_l:set(vdesync_amount_1)
                    desync_amount_r:set(vdesync_amount_1)
                end
        
            else
                yaw_base:set(vjitter_angle_2)
                
                -- set side for indicator
                if vjitter_angle_2 > 0 then
                    side = 1
                else
                    side = 0
                end
        
                if vdesync_amount_2 < 0 then 
                    desync_side:set(2)
                    desync_amount_l:set(vdesync_amount_2 * -1)
                    desync_amount_r:set(vdesync_amount_2 * -1)
                else
                    desync_side:set(3)
                    desync_amount_l:set(vdesync_amount_2)
                    desync_amount_r:set(vdesync_amount_2)
                end
            end

            state = state + 1
            if state > jitter_speed1 then state = jitter_speed1 * -1 
            end
        end

        if fake_flick:get() then
            local g_vars_tick = global_vars.tick_count()
            local flick_speed = flick_freq:get() * -1 + 5
            if flick_freq:get() == 0 then
                flick_speed = 0
            end

            local freq = flick_speed * 16
            if freq ~= 0 then

                if g_vars_tick % freq > freq - 7 then
                    fake_lag_value:set(14)
                end

                -- dont feel like explaining this shit, but its timing
                if g_vars_tick % freq > freq - 2 then
                    fake_lag_value:set(15)
                    -- switch left then right
                    if flick_state == 0 then
                        yaw_base:set(flick_angle:get())
                    elseif flick_state == 1 then
                        yaw_base:set(flick_angle:get() * -1)
                    end
                    flick_state = flick_state + 1
                    if flick_state > 1 then
                        flick_state = 0
                    end
                end

            
            end
        end



        if tp_bind:get() then -- TP on key
            exploits.force_uncharge()
            exploits.block_recharge()
        else
            exploits.allow_recharge()
        end

    end -- master switch
end -- main
--///////////////////////////////////////////////










--| INDICATORS / ON_PAINT |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function on_paint()
    -- master switch
    if master_switch:get() then
        local preset = presets:get()

        -- PRESET STUFF, JUST MORE MENU THINGS
        if preset == 2 then   -- Agressive 1
            jitter_angle_1:set(26)
            jitter_angle_2:set(-20)
            desync_amount_1:set(90)
            desync_amount_2:set(-80)

            jitter_angle_1move:set(35)
            jitter_angle_2move:set(-30)
            desync_amount_1move:set(95)
            desync_amount_2move:set(-85)

            jitter_angle_1slow:set(15)
            jitter_angle_2slow:set(-15)
            desync_amount_1slow:set(90)
            desync_amount_2slow:set(-80)

            jitter:set(true)
            rotate:set(false)
            velocity_jitter:set(false)
            override_slow:set(true)
            override_move:set(true)
        end
    
        if preset == 3 then   -- Aggressive 2
            jitter_angle_1:set(33)
            jitter_angle_2:set(-30)
            desync_amount_1:set(90)
            desync_amount_2:set(-85)

            jitter_angle_1move:set(41)
            jitter_angle_2move:set(-36)
            desync_amount_1move:set(95)
            desync_amount_2move:set(-90)

            jitter_angle_1slow:set(24)
            jitter_angle_2slow:set(-20)
            desync_amount_1slow:set(85)
            desync_amount_2slow:set(-80)

            jitter:set(true)
            rotate:set(false)
            velocity_jitter:set(false)
            override_slow:set(true)
            override_move:set(true)
        end
    
        if preset == 4 then   -- jitter 1
            jitter_angle_1:set(20)
            jitter_angle_2:set(-17)
            desync_amount_1:set(92)
            desync_amount_2:set(-92)

            jitter_angle_1move:set(29)
            jitter_angle_2move:set(-25)
            desync_amount_1move:set(92)
            desync_amount_2move:set(-92)

            jitter_angle_1slow:set(15)
            jitter_angle_2slow:set(-15)
            desync_amount_1slow:set(90)
            desync_amount_2slow:set(-80)
    
            jitter:set(true)
            rotate:set(true)
            rotate_angle:set(2)
            rotate_speed1:set(100)
            override_slow:set(true)
            override_move:set(true)
        end
    
        if preset == 5 then   -- Jitter 2
            jitter_angle_1:set(22)
            jitter_angle_2:set(-20)
            desync_amount_1:set(-80)
            desync_amount_2:set(90)

            jitter_angle_1move:set(27)
            jitter_angle_2move:set(-22)
            desync_amount_1move:set(85)
            desync_amount_2move:set(-95)

            jitter_angle_1slow:set(15)
            jitter_angle_2slow:set(-15)
            desync_amount_1slow:set(80)
            desync_amount_2slow:set(-80)
    
            jitter:set(true)
            rotate:set(true)
            rotate_angle:set(1)
            rotate_speed1:set(50)
            override_slow:set(true)
            override_move:set(true)
        end
    
        if preset == 6 then   -- HS only 1
            jitter_angle_1:set(15)
            jitter_angle_2:set(-15)
            desync_amount_1:set(100)
            desync_amount_2:set(-100)

            jitter_angle_1move:set(30)
            jitter_angle_2move:set(-27)
            desync_amount_1move:set(85)
            desync_amount_2move:set(-95)

            jitter:set(true)
            rotate:set(true)
            rotate_angle:set(1)
            rotate_speed1:set(50)
            velocity_jitter:set(false)
            override_slow:set(false)
            override_move:set(true)
        end

        if preset == 7 then   -- HS only 2
            jitter_angle_1:set(13)
            jitter_angle_2:set(-3)
            desync_amount_1:set(100)
            desync_amount_2:set(7)

            jitter:set(true)
            rotate:set(false)
            velocity_jitter:set(false)
            override_slow:set(false)
            override_move:set(false)
        end

        if preset == 8 then   -- Rotate
            jitter_angle_1:set(5)
            jitter_angle_2:set(-5)
            desync_amount_1:set(100)
            desync_amount_2:set(-100)

            jitter:set(true)
            rotate:set(true)
            rotate_angle:set(20)
            rotate_speed1:set(100)
            velocity_jitter:set(false)
            override_slow:set(false)
            override_move:set(false)
        end

        if preset == 9 then   -- Velocity jitter 1
            jitter_angle_1:set(0)
            jitter_angle_2:set(0)
            desync_amount_1:set(97)
            desync_amount_2:set(-85)

            jitter:set(true)
            rotate:set(false)
            velocity_jitter:set(true)
            vel_max_angle:set(38)
            vel_min_angle:set(8)
            vel_multiplier:set(65)
            override_slow:set(false)
            override_move:set(false)
        end

        if preset == 10 then   -- Velocity jitter 2
            jitter_angle_1:set(0)
            jitter_angle_2:set(0)
            desync_amount_1:set(95)
            desync_amount_2:set(-90)

            jitter:set(true)
            rotate:set(false)
            velocity_jitter:set(true)
            vel_max_angle:set(40)
            vel_min_angle:set(10)
            vel_multiplier:set(30)
            override_slow:set(false)
            override_move:set(false)
        end

        if menu_condition:get() == 1 then
            jitter_angle_1:set_visible(true)
            jitter_angle_2:set_visible(true)
            desync_amount_1:set_visible(true)
            desync_amount_2:set_visible(true)

            jitter_angle_1move:set_visible(false)
            jitter_angle_2move:set_visible(false)
            desync_amount_1move:set_visible(false)
            desync_amount_2move:set_visible(false)

            jitter_angle_1slow:set_visible(false)
            jitter_angle_2slow:set_visible(false)
            desync_amount_1slow:set_visible(false)
            desync_amount_2slow:set_visible(false)

            override_move:set_visible(false)
            override_slow:set_visible(false)
        end

        if menu_condition:get() == 2 then
            jitter_angle_1:set_visible(false)
            jitter_angle_2:set_visible(false)
            desync_amount_1:set_visible(false)
            desync_amount_2:set_visible(false)

            jitter_angle_1move:set_visible(true)
            jitter_angle_2move:set_visible(true)
            desync_amount_1move:set_visible(true)
            desync_amount_2move:set_visible(true)

            jitter_angle_1slow:set_visible(false)
            jitter_angle_2slow:set_visible(false)
            desync_amount_1slow:set_visible(false)
            desync_amount_2slow:set_visible(false)

            override_move:set_visible(true)
            override_slow:set_visible(false)
        end
    
        if menu_condition:get() == 3 then
            jitter_angle_1:set_visible(false)
            jitter_angle_2:set_visible(false)
            desync_amount_1:set_visible(false)
            desync_amount_2:set_visible(false)

            jitter_angle_1move:set_visible(false)
            jitter_angle_2move:set_visible(false)
            desync_amount_1move:set_visible(false)
            desync_amount_2move:set_visible(false)

            jitter_angle_1slow:set_visible(true)
            jitter_angle_2slow:set_visible(true)
            desync_amount_1slow:set_visible(true)
            desync_amount_2slow:set_visible(true)

            override_move:set_visible(false)
            override_slow:set_visible(true)
        end

        if not jitter:get() or not antiaim:get() then
            jitter_angle_1:set_visible(false)
            jitter_angle_2:set_visible(false)
            desync_amount_1:set_visible(false)
            desync_amount_2:set_visible(false)

            jitter_angle_1move:set_visible(false)
            jitter_angle_2move:set_visible(false)
            desync_amount_1move:set_visible(false)
            desync_amount_2move:set_visible(false)

            jitter_angle_1slow:set_visible(false)
            jitter_angle_2slow:set_visible(false)
            desync_amount_1slow:set_visible(false)
            desync_amount_2slow:set_visible(false)
        end

            -- more fucking menu stuff i have to spread out because of "more than 60 upvalues". kys.
        if not jitter:get() or not antiaim:get() then
            override_move:set_visible(false)
            override_slow:set_visible(false)
        end

        hs_ideal_tick:set_visible(enable_misc:get())

        -- END OF MENU ELEMENTS AND OTHER STUFF, PAINT SHIT STARTS HERE
        local menu_pos      = menu.get_pos()
        local menu_size     = menu.get_size()
        local fps           = client.get_fps()
        local ping          = math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000)
        local hr, min, sec  = client.get_local_time()
        local time          = ("%02d:%02d:%02d"):format(hr, min, sec)
        local local_player  = entity_list.get_local_player()
        local barclr        = barcolor:get()
        local tickrate      = client.get_tickrate()
        local divide_by     = misses + hits
        local miss_ratio    = misses / divide_by
        local hit_ratio     = hits / divide_by
        local miss_divide   = resolver_misses + spread_misses + pred_misses + occlusion_misses
        local resolver_ratio  = resolver_misses / miss_divide
        local occlusion_ratio = occlusion_misses / miss_divide
        local spread_ratio  = spread_misses / miss_divide
        local pred_ratio    = pred_misses / miss_divide
        local hitbox_divide = head_misses + body_misses
        local head_ratio    = head_misses / hitbox_divide
        local baim_ratio    = body_misses / hitbox_divide
        local offset        = jitter_side_offset:get()
        local size          = jitter_size:get()
        local hr, min, sec  = client.get_local_time()
        local time          = ("%02d:%02d:%02d"):format(hr, min, sec)
        local text_size     = render.get_text_size(default_font, "[Kuro.lua] | " .. "fps: " .. client.get_fps() .. " | rtt: " .. math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000) .. " | tick: " .. client.get_tickrate() .. " | " .. time)
        local text_size1    = render.get_text_size(tahoma, "supremacy | rtt: " .. math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000) .. " | rate: " .. client.get_tickrate() .. " | " .. time)

        local aa        = ""
        local misc      = ""
        local indicator = ""
        local custom    = ""

        if antiaim:get() then
            aa = "on"
        else
            aa = "off"
        end

        if enable_misc:get() then
            misc = "on"
        else
            misc = "off"
        end

        if indicators:get() then
            indicator = "on"
        else
            indicator = "off"
        end

        if custom_game_enable:get() then
            custom = "on"
        else
            custom = "off"
        end


                


        if menu.is_open() and enable_misc:get() and menu_bg:get() then -- render background first so it doesnt overlap other shit
            bg_alpha = bg_alpha + 10
            if bg_alpha > 175 then bg_alpha = 175 end
            render.rect_filled(vec2_t(0, 0), render.get_screen_size(), color_t(6, 6, 6, bg_alpha))
        end

        if not menu.is_open() and enable_misc:get() and menu_bg:get() then
            bg_alpha = bg_alpha - 6
            if bg_alpha < 0 then bg_alpha = 0 end

            render.rect_filled(vec2_t(0, 0), render.get_screen_size(), color_t(6, 6, 6, bg_alpha))
        end

        -- In menu tab thing
        if menu.is_open() then
            render.rect_filled(menu_pos+vec2_t(0, -60), vec2_t(menu_size[0], 55), color_t(20, 20, 21), 6)
            render.rect_filled(menu_pos+vec2_t(0, -60), vec2_t(menu_size[0], 17), color_t(40, 41, 40), 6)
            render.rect_filled(menu_pos+vec2_t(0, -47), vec2_t(menu_size[0], 4), color_t(20, 20, 21))
            render.rect_filled(menu_pos+vec2_t(0, -47), vec2_t(menu_size[0], 1), color_t(55, 55, 55))
            render.rect_fade(menu_pos+vec2_t(0, -47), vec2_t(menu_size[0], 1), bar_color:get(), bar_color1:get(), true)

            render.text(default_font, "Kuro.lua [ Release build ]", menu_pos+vec2_t(10, -40), color_t(255, 255, 255, 255))
            render.text(default_font, 'Current user: ' .. user.name, menu_pos+vec2_t(10, -25), color_t(255, 255, 255, 255))

            render.text(default_font, "Anti-Aim: " .. aa, menu_pos+vec2_t(menu_size[0] * 0.3, -40), color_t(255, 255, 255, 255))
            render.text(default_font, "Misc: " .. misc, menu_pos+vec2_t(menu_size[0] * 0.3, -25), color_t(255, 255, 255, 255))

            render.text(default_font, "Indicators: " .. indicator, menu_pos+vec2_t(menu_size[0] * 0.4, -40), color_t(255, 255, 255, 255))
            render.text(default_font, "Custom game: " .. custom  , menu_pos+vec2_t(menu_size[0] * 0.4, -25), color_t(255, 255, 255, 255))

            render.text(default_font, tostring(fps), menu_pos+vec2_t(menu_size[0] - 25, -40), color_t(255, 255, 255, 255))
            render.text(default_font, tostring(tickrate), menu_pos+vec2_t(menu_size[0] - 25, -25), color_t(255, 255, 255, 255))
        end

        if indicators:get() and indicator_bar:get() and entity_list.get_local_player() ~= nil and local_player:is_alive() then
            -- main fading bar thing
            render.rect_filled(vec2_t(840, 1020), vec2_t(240, 60), color_t(6, 6, 6, 155))
            render.rect_fade(vec2_t(640, 1020), vec2_t(200, 60), color_t(6, 6, 6, 0), color_t(6, 6, 6, 200), true)
            render.rect_fade(vec2_t(1080, 1020), vec2_t(200, 60), color_t(6, 6, 6, 200), color_t(6, 6, 6, 0), true)

            -- accent line
            render.rect_fade(vec2_t(960, 1020), vec2_t(320, 1), barclr, color_t(barclr[0], barclr[1], barclr[2], 0), true)
            render.rect_fade(vec2_t(640, 1020), vec2_t(320, 1), color_t(barclr[0], barclr[1], barclr[2], 0), barclr, true)

            -- text n shit
            render.text(default_font, "fps: " .. tostring(fps), vec2_t(960, 1050), color_t(255, 255, 255, 255), true) -- fps
            render.text(default_font, "rtt: " .. tostring(ping), vec2_t(1080, 1050), color_t(255, 255, 255, 255), true) -- ping
            render.text(default_font, "tick: " .. tostring(tickrate), vec2_t(840, 1050), color_t(255, 255, 255, 255), true) 

        end


        if enable_misc:get() then
            if halo:get() and local_player ~= nil and local_player:is_alive() and client.is_in_thirdperson() then
                local screen_pos = render.world_to_screen(local_player:get_hitbox_pos(e_hitboxes.HEAD) + vec3_t(0, 0, 8))

                if screen_pos ~= nil then
                    render.circle_filled(screen_pos+vec2_t.new(0, 0), 5, dot_color:get())
                end
            end

        end

        if shot_stats:get() and indicators:get() and engine.is_connected() then
            render.rect_filled(vec2_t(stats_x:get(), stats_y:get()), vec2_t(240, 100), color_t(6, 6, 6, 180))
            render.rect(vec2_t(stats_x:get() + 2, stats_y:get() + 2), vec2_t(236, 96), color_t(6, 6, 6, 225))
            render.text(default_font, 'misses: ' .. tostring(misses) .. "  (" .. tostring(math.floor(miss_ratio * 100)) .. "%)", vec2_t(stats_x:get() + 20, stats_y:get() + 15), color_t(255, 255, 255, 255))
            render.text(default_font, 'hits: ' .. tostring(hits) .. "  (" .. tostring(math.floor(hit_ratio * 100)) .. "%)", vec2_t(stats_x:get() + 20, stats_y:get() + 35), color_t(255, 255, 255, 255)) 

            render.text(default_font, 'head misses: ' .. tostring(head_misses) .. ' (' .. math.floor(head_ratio * 100) .. '%)', vec2_t(stats_x:get() + 20, stats_y:get() + 55), color_t(255, 255, 255, 255))
            render.text(default_font, 'body misses: ' .. tostring(body_misses) .. ' (' .. math.floor(baim_ratio * 100) .. '%)', vec2_t(stats_x:get() + 20, stats_y:get() + 75), color_t(255, 255, 255, 255))

            render.text(default_font, 'resolver: ' .. tostring(resolver_misses) .. '  (' .. math.floor(resolver_ratio * 100) .. '%)', vec2_t(stats_x:get() + 135, stats_y:get() + 15), color_t(255, 255, 255, 255))
            render.text(default_font, 'pred: ' .. tostring(pred_misses) .. '  (' .. math.floor(pred_ratio * 100) .. '%)', vec2_t(stats_x:get() + 135, stats_y:get() + 35), color_t(255, 255, 255, 255))
            render.text(default_font, 'occlusion: ' .. tostring(occlusion_misses) .. '  (' .. math.floor(occlusion_ratio * 100) .. '%)', vec2_t(stats_x:get() + 135, stats_y:get() + 55), color_t(255, 255, 255, 255))
            render.text(default_font, 'spread: ' .. tostring(spread_misses) .. '  (' .. math.floor(spread_ratio * 100) .. '%)', vec2_t(stats_x:get() + 135, stats_y:get() + 75), color_t(255, 255, 255, 255))
        end

        if indicators:get() and watermark:get() then
            if watermark_style:get() == 1 then -- Style 1
                render.rect_filled(vec2_t(1905 - text_size[0], 5), vec2_t(10 + text_size[0], 20), color_t(6, 6, 6, 215))
                render.rect(vec2_t(1905 - text_size[0], 5), vec2_t(10 + text_size[0], 1), watermark_color:get())

                render.text(default_font, "[Kuro.lua] | " .. "fps: " .. client.get_fps() .. " | rtt: " .. math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000) .. " | tick: " .. client.get_tickrate() .. " | " .. time, vec2_t(1910 - text_size[0], 8), color_t(255, 255, 255))
          
            elseif watermark_style:get() == 2 then -- Style 2
                render.rect_filled(vec2_t(1905 - text_size[0], 5), vec2_t(10 + text_size[0], 20), color_t(6, 6, 6, 215), 3)

                render.text(default_font, "[Kuro.lua] | " .. "fps: " .. client.get_fps() .. " | rtt: " .. math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000) .. " | tick: " .. client.get_tickrate() .. " | " .. time, vec2_t(1910 - text_size[0], 8), color_t(255, 255, 255))
         
            elseif watermark_style:get() == 3 then -- SUPREMACY <3333333
                render.rect_filled(vec2_t(1905 - text_size1[0], 5), vec2_t(10 + text_size1[0], 20), color_t(240, 110, 140, 130))

                render.text(tahoma, "supremacy | rtt: " .. math.floor(engine.get_latency(e_latency_flows.OUTGOING) * 1000) .. " | rate: " .. client.get_tickrate() .. " | " .. time, vec2_t(1910 - text_size1[0], 8), color_t(240, 160, 180, 250))
            end
        end

        if jitter_side:get() and indicators:get() and engine.is_connected() and local_player:is_alive() then
            if jitter_style:get() ~= 3 then
            render.triangle_filled(vec2_t.new(910  - jitter_side_offset:get(), 540), jitter_size:get(), color_t.new(6, 6, 6, 155), -90)
            render.triangle_filled(vec2_t.new(1010 + jitter_side_offset:get(), 540), jitter_size:get(), color_t.new(6, 6, 6, 155),  90)
            end

            if side == 0 then
                if jitter_style:get() == 1 then
                    render.triangle_filled(vec2_t.new(910 - offset, 540), jitter_size:get(), jitter_color:get(), -90)
                elseif jitter_style:get() == 2 then
                    render.rect_filled(vec2_t(910 - offset + math.floor(size * 0.1), 540 - size / 2), vec2_t(math.floor(size * 0.2), size), jitter_color:get(), 2)
                elseif jitter_style:get() == 3 then
                    render.triangle_filled(vec2_t.new(890 - offset, 540), jitter_size:get(), jitter_color:get(), -90)
                    render.rect_filled(vec2_t(890 - offset, 540 - math.floor(size * 0.075)), vec2_t(size * 1.5, size * 0.15), jitter_color:get())
                end
            else
                if jitter_style:get() == 1 then
                    render.triangle_filled(vec2_t.new(1010 + offset, 540), jitter_size:get(), jitter_color:get(), 90)
                elseif jitter_style:get() == 2 then
                    render.rect_filled(vec2_t(1010 + offset - math.floor(size * 0.35), 540 - size / 2), vec2_t(math.floor(size * 0.2), size), jitter_color:get(), 2)
                elseif jitter_style:get() == 3 then
                    render.triangle_filled(vec2_t.new(1030 + offset, 540), jitter_size:get(), jitter_color:get(), 90)
                    render.rect_filled(vec2_t(1030 + offset - size * 1.5, 540 - math.floor(size * 0.075)), vec2_t(size * 1.52, size * 0.15), jitter_color:get())
                end
            end

        end

    end -- master switch
end -- on_paint
--///////////////////////////////////////////////










--| ON EVENT |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function on_event(event)
    local local_player = entity_list.get_local_player()
    local say          = ""

    if master_switch:get() then
        --  player_falldamage
        --  cs_win_panel_round
        --  weapon_zoom
        --  bomb_begindefuse
        --  bomb_abortdefuse
        --  bomb_beginplant
        --  bomb_abortplant
        --  bomb_exploded
        --  player_hurt
        --  player_death
        --  other_death (chicken death)
        --  round_prestart
        --  item_pickup
        --  inspect_weapon
        --  hostage_follows
        --  hostage_rescued
        --  round_mvp 
        --  grenade_thrown

    --| EVENT SAYS |--
    -----------------------
        -- kill says + death says (1) (2)
        if event.name == "player_death" then
            if event_says:get(2) then -- death say selected
                if entity_list.get_player_from_userid(event.userid) == entity_list.get_local_player() then
                    local death_cmd = 'say ' .. death_says[math.random(1, 26)]
                    engine.execute_cmd(death_cmd)

                    if quit_on_death:get() then
                        engine.execute_cmd(quit)
                    end
                end
            end



            if event_says:get(1) then -- if killsay is selected
                if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit

                local kill_cmd = 'say ' .. kill_says[math.random(1, 37)]
                engine.execute_cmd(kill_cmd)
            end
        end
        

        -- hurt says (3)
        if event.name == "player_hurt" then
            if event_says:get(3) then -- if hurtsay is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit

                local hurt_cmd = 'say ' .. hurt_says[math.random(1, 11)]
                engine.execute_cmd(hurt_cmd)
            end
        end

        -- chicken kill says (4)
        if event.name == "other_death" then
            if event_says:get(4) then -- if hurtsay is selected
                if engine.get_level_name_short() == "de_inferno" then
                    if entity_list.get_player_from_userid(event.attacker) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit

                    local chicken_cmd = 'say ' .. chicken_says[math.random(1, 14)]
                    engine.execute_cmd(chicken_cmd)
                end
            end
        end

        -- fall damage says (for self) (5)
        if event.name == "player_falldamage" then
            if event_says:get(5) then -- if hurtsay is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit
    
                local falldamage_cmd = 'say ' .. falldamage_says[math.random(1, 4)]
                engine.execute_cmd(falldamage_cmd)
            end
        end

        -- fall damage says (for others) (5)
        if event.name == "player_falldamage" then
            if event_says:get(5) then -- if hurtsay is selected
                if entity_list.get_player_from_userid(event.userid) == entity_list.get_local_player() then return end -- if its us, dont do the shit
    
                local falldamage1_cmd = 'say ' .. falldamage1_says[math.random(1, 4)]
                engine.execute_cmd(falldamage1_cmd)
            end
        end

        -- hostage picked up says (6)
        if event.name == "hostage_follows" then
            if event_says:get(6) then -- if hostage say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit
        
                local hostage_cmd = 'say ' .. hostage_says[math.random(1, 7)]
                engine.execute_cmd(hostage_cmd)
            end
        end

        -- hostage rescued says (7)
        if event.name == "hostage_rescued" then
            if event_says:get(7) then -- if hostage resuced say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit
        
                local hostage1_cmd = 'say ' .. hostage1_says[math.random(1, 8)]
                engine.execute_cmd(hostage1_cmd)
            end
        end

        -- mvp says (8)
        if event.name == "round_mvp" then
            if event_says:get(8) then -- if mvp say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit

                local mvp_cmd = 'say ' .. mvp_says[math.random(1, 10)]
                engine.execute_cmd(mvp_cmd)
            end
        end

        -- weapon inspect says (9)
        if event.name == "inspect_weapon" then
            if event_says:get(9) then -- if weapon inspect say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit
        
                local inspect_cmd = 'say ' .. inspect_says[math.random(1, 5)]
                engine.execute_cmd(inspect_cmd)
            end
        end

        -- pick up item says (10)
        if event.name == "inspect_weapon" then
            if event_says:get(10) then -- if item pickup say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit
        
                local pickup_cmd = 'say ' .. pickup_says[math.random(1, 4)]
                engine.execute_cmd(pickup_cmd)
            end
        end

        -- round win says (11)
        if event.name == "round_end" then
            if entity_list.get_player_from_userid(event.winner) ~= entity_list.get_local_player() then return end
            if event_says:get(11) then -- if round win say is selected


                local win_cmd = 'say ' .. win_says[math.random(1, 5)]
                engine.execute_cmd(win_cmd)
            end
        end

        -- defuse says (12)
        if event.name == "bomb_begindefuse" then
            if event_says:get(12) then -- if defuse say is selected

                local defuse_cmd = 'say ' .. defuse_says[math.random(1, 4)]
                engine.execute_cmd(defuse_cmd)
            end
        end
      
        -- bomb plant says (13)
        if event.name == "bomb_beginplant" then
            if event_says:get(13) then -- if plant say is selected

                local plant_cmd = 'say ' .. plant_says[math.random(1, 4)]
                engine.execute_cmd(plant_cmd)
            end
        end

        -- explode says (14)
        if event.name == "bomb_exploded" then
            if event_says:get(14) then -- if explode say is selected

                local explode_cmd = 'say ' .. explode_says[math.random(1, 4)]
                engine.execute_cmd(explode_cmd)
            end
        end        

        -- grenade thrown says (15)
        if event.name == "grenade_thrown" then
            if event_says:get(15) then -- if grenade say is selected
                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then
                    local throw1_cmd = 'say ' .. throw1_says[math.random(1, 6)]
                    engine.execute_cmd(throw1_cmd) -- script mod do u read these?
                end

                if entity_list.get_player_from_userid(event.userid) ~= entity_list.get_local_player() then return end -- if its not us, dont do the shit

                local throw_cmd = 'say ' .. throw_says[math.random(1, 4)]
                engine.execute_cmd(throw_cmd) -- hi script mod :3
            end
        end            

    -----------------------

        -- faster autobuy
        if event.name == "round_prestart" then
            if enable_misc:get() then
                if fast_autobuy:get() == 2 then
                    engine.execute_cmd("buy ssg08")
                end

                if fast_autobuy:get() == 3 then
                    engine.execute_cmd("buy awp")
                end
            end
        end



    end 
end
--///////////////////////////////////////////////










--| on_shutdown |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function on_shutdown()
    -- restore settings so u dont fuck up the user's cfg
    yaw_base:set(sYaw_base)    
    rotate_enable:set(sRotate_enable)     
    rotate_range:set(sMrotate_range)     
    rotate_speed:set(sMrotate_speed)     
    desync_side:set(sDesync_side)       
    desync_amount_l:set(sDesync_amount_l)       
    desync_amount_r:set(sDesync_amount_r)       
    antibrute:set(sAntibrute)         
    cheat_jitter:set(sCheat_jitter)      
    auto_direct:set(sAuto_direct)       
    pitch:set(sPitch)             
    onshot:set(sOnshot)            
    override_stand:set(sOverride_stand)    
    leg_slide:set(sLeg_slide)      


    engine.execute_cmd("sv_cheats 1")
    engine.execute_cmd("@panorama_disable_blur 0") 
    cvars.cl_chatfilters:set_int(63)
end
--///////////////////////////////////////////////






local function menu_shit_2() -- more than 60 upvalues = menu shit #2
    jitter:set_visible(antiaim:get())
    presets:set_visible(antiaim:get())
    rotate:set_visible(antiaim:get())
    velocity_jitter:set_visible(antiaim:get())
    fake_flick:set_visible(antiaim:get())

    jitter_side:set_visible(indicators:get())
    watermark:set_visible(indicators:get())

    tp_on_key:set_visible(enable_misc:get())
    fast_autobuy:set_visible(enable_misc:get())
    event_says:set_visible(enable_misc:get())
    remove_sleeves:set_visible(enable_misc:get())
    prim_watermark:set_visible(enable_misc:get())
    chat_logs:set_visible(enable_misc:get())
    text1:set_visible(enable_misc:get())
    disable_blur:set_visible(enable_misc:get())
    disable_chat:set_visible(enable_misc:get())
    quit_on_death:set_visible(enable_misc:get())
    halo:set_visible(enable_misc:get())


    mp_autoteambalance:set_visible(custom_game_enable:get())
    mp_buy_anywhere:set_visible(custom_game_enable:get())
    mp_buytime:set_visible(custom_game_enable:get())
    mp_limitteams:set_visible(custom_game_enable:get())
    mp_maxmoney:set_visible(custom_game_enable:get())
    mp_maxrounds:set_visible(custom_game_enable:get())
    mp_roundtime:set_visible(custom_game_enable:get())
    sv_cheats:set_visible(custom_game_enable:get())
    sv_airaccelerate:set_visible(custom_game_enable:get())
    sv_maxvelocity:set_visible(custom_game_enable:get())
    impulse:set_visible(custom_game_enable:get())
    bot_add_ct:set_visible(custom_game_enable:get())
    bot_add_t:set_visible(custom_game_enable:get())
    bot_kick:set_visible(custom_game_enable:get())
    tp_on_key:set_visible(enable_misc:get())
    menu_condition:set_visible(antiaim:get())

    animations:set_visible(enable_misc:get())
    menu_bg:set_visible(enable_misc:get())
end

local function menu_shit() -- out of place but idc, fuck you, fuck how i organized all this shit, its all schizocode

    menu.set_group_visibility("-- Anti Aim --", master_switch:get())
    menu.set_group_visibility("-- Anti Aim Extras --", master_switch:get())
    menu.set_group_visibility("-- Indicators --", master_switch:get())
    menu.set_group_visibility("-- Misc --", master_switch:get())
    menu.set_group_visibility("-- Custom Game --", master_switch:get())
    menu.set_group_visibility("-- Server Browser --", master_switch:get())
    
    server_list:set_visible(servers:get())
    join_server:set_visible(servers:get())
    indicator_bar:set_visible(indicators:get())
    shot_stats:set_visible(indicators:get())

    if master_switch:get() then -- hide the sliders and shit for stuff if the master switch for this category is off but the option for it is on
        menu.set_group_visibility("-- Anti Aim Extras --", antiaim:get())
    else
        menu.set_group_visibility("-- Anti Aim Extras --", false)
    end

    if indicators:get() then -- hide the sliders and shit for stuff if the master switch for this category is off but the option for it is on
        stats_x:set_visible(shot_stats:get())
        stats_y:set_visible(shot_stats:get())

        jitter_size:set_visible(jitter_side:get())
        jitter_side_offset:set_visible(jitter_side:get())
        jitter_style:set_visible(jitter_side:get())
        watermark_style:set_visible(watermark:get())

    else
        stats_x:set_visible(false)
        stats_y:set_visible(false)
        watermark_style:set_visible(false)

        jitter_size:set_visible(false)
        jitter_side_offset:set_visible(false)
        jitter_style:set_visible(false)
    end

    if antiaim:get() then -- hide the sliders and shit for stuff if the master switch for this category is off but the option for it is on
        vel_max_angle:set_visible(velocity_jitter:get())
        vel_min_angle:set_visible(velocity_jitter:get())
        vel_multiplier:set_visible(velocity_jitter:get())

        jitter_speed:set_visible(jitter:get())
        rotate_angle:set_visible(rotate:get())
        rotate_speed1:set_visible(rotate:get())
        flick_angle:set_visible(fake_flick:get())
        flick_freq:set_visible(fake_flick:get())

    else
        vel_max_angle:set_visible(false)
        vel_min_angle:set_visible(false)
        vel_multiplier:set_visible(false)

        jitter_speed:set_visible(false)
        rotate_angle:set_visible(false)
        rotate_speed1:set_visible(false)
        flick_angle:set_visible(false)
        flick_freq:set_visible(false)
    end

    if antiaim:get() and master_switch:get() then -- antiaim extras + aa menu control things
        auto_direct:set(do_auto_direct:get())
        antibrute:set(do_antibrute:get())
        pitch:set(pitch1:get())
        onshot:set(onshot1:get())
        leg_slide:set(leg_slide1:get())
        rotate_enable:set(rotate:get())
        rotate_range:set(rotate_angle:get())
        rotate_speed:set(rotate_speed1:get())
    end
end

--| ON_DRAW_WATERMARK |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function on_draw_watermark(watermark_text)
    menu_shit()
    menu_shit_2()

     -- asdasdasdasdasdasdasdasdasd
    if enable_misc:get() then

        if not engine.is_connected() then
            if disable_blur:get() then
                engine.execute_cmd("sv_cheats 1")
                engine.execute_cmd("@panorama_disable_blur 1")
            else
                engine.execute_cmd("sv_cheats 1")
                engine.execute_cmd("@panorama_disable_blur 0")
            end
        end

        if disable_chat:get() and enable_misc:get() then
            cvars.cl_chatfilters:set_int(0)
        else
            cvars.cl_chatfilters:set_int(63)   									
        end	

        if prim_watermark:get() then
            return ""
        end
    end

    return "Kuro.lua - " .. user.name
end
--///////////////////////////////////////////////










--| ON_DRAW_MODEL |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
function on_draw_model(ctx)
    if enable_misc:get() then
        if remove_sleeves:get() then
            if ctx.model_name:find("v_sleeve") == nil then 
            return
            end

            ctx.override_original = true
        end
    end
end
--///////////////////////////////////////////////









--| ON AIMBOT SHIT |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
-- ON SHOT
local function on_aimbot_shoot(shot)
    if enable_misc:get() and hs_ideal_tick:get() then
        uncharge = 1
    end
end

-- ON HIT
local function on_aimbot_hit(hit)
    hits = hits + 1
end

-- ON MISS
local function on_aimbot_miss(miss)
    local miss_reason = "\x07" .. miss.reason_string
    local player      = "\x0A" .. "?"
    local miss_hitbox = "\x0D" .. hitboxes[miss.aim_hitbox + 1] -- god i wanna kill myself it took me too long to figure out i had to do +1
    local hitchance   = tostring(miss.aim_hitchance) -- why tf does this just give me 0 over and over??
    local safe        = tostring(miss.aim_safepoint)
    local damage      = tostring(miss.aim_damage)    -- yes i know i dont have to do tostring for everything BUT IT LOOKS NICE OK
    local bt_ticks    = tostring(miss.backtrack_ticks - 1)
    
    if miss.player then
        player = "\x0A" .. miss.player:get_name()
    end

    -- Miss counter
    misses = misses + 1 -- revolutionary code

    if miss.reason_string == "resolver" then
        resolver_misses = resolver_misses + 1
        misses = misses + 1 -- still dont know why i have to do this here too...
    end

    if miss.reason_string == "prediction error" then
        pred_misses = pred_misses + 1
        misses = misses + 1 -- apparently it doesnt add to misses if its a pred error or something?
    end

    if miss.reason_string == "spread (missed safe)" or "spread" then
        spread_misses = spread_misses + 1 -- im probably just retarded...
    end

    if miss.reason_string == "occlusion" then
        occlusion_misses = occlusion_misses + 1
        misses = misses + 1 -- im probably just retarded...
    end

    if miss.aim_hitbox == 0 then -- at least this works without some stupid change
        head_misses = head_misses + 1
    else
        body_misses = body_misses + 1
    end
        
    -- Chat logs
    if chat_logs:get() and engine.is_connected() then
        PrintInChat(" \x0C [Kuro.lua]  " .. "\x01  Missed " .. player .. "\x01's " .. miss_hitbox .. "\x01 due to " .. miss_reason .. ".") -- stfu i know theres better ways to do this
        PrintInChat(" \x0C [Kuro.lua]  " .. "\x01| safe: " .. safe .. " | damage: " .. damage .. " | bt ticks: " .. bt_ticks .. " |") -- stfu i know theres better ways to do this
    end
end
--///////////////////////////////////////////////









--| ON ANTIAIM |--
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
local function on_antiaim(ctx)
    local lp = entity_list.get_local_player()
    local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
    local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
    local curtime = global_vars.cur_time()

    if on_land == true then
        ground_tick = ground_tick + 1
    else
        ground_tick = 0
        end_time = curtime + 1
    end

    if animations:get(1) and enable_misc:get() then
        if ground_tick > 1 and end_time > global_vars.cur_time()  then
            ctx:set_render_pose(e_poses.BODY_PITCH, 0.5)
        end
    end

    if animations:get(2) and enable_misc:get() then
        if in_air then
            ctx:set_render_pose(e_poses.JUMP_FALL, 1)
            ctx:set_render_pose(e_poses.RUN, 0)
        end
    end
end
--///////////////////////////////////////////////

--===| Callbacks |===--
callbacks.add(e_callbacks.EVENT, on_event)
callbacks.add(e_callbacks.SHUTDOWN, on_shutdown)
callbacks.add(e_callbacks.SETUP_COMMAND, main)
callbacks.add(e_callbacks.PAINT, on_paint)
callbacks.add(e_callbacks.DRAW_WATERMARK, on_draw_watermark)
callbacks.add(e_callbacks.DRAW_MODEL, on_draw_model)
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)
callbacks.add(e_callbacks.AIMBOT_HIT, on_aimbot_hit)
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)
callbacks.add(e_callbacks.ANTIAIM, on_antiaim)
--===| Callbacks |===--