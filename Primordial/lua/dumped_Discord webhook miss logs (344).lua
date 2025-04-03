-- made by stars#3787
-- CHANGE STUFF IN THE SCRIPT FOR IT TO WORK
-- read the notes pls
local enable     = menu.add_checkbox("Webhook miss logs", "enable")
local chat_notif = menu.add_checkbox("Webhook miss logs", "chat notification on send")

local httpFactory = require('Lightweight HTTP Library') -- download the http library lua, name it Lightweight HTTP Library.lua, and put it in your includes folder
local Discord = require('webhook') -- download the webhook library lua, name it webhook.lua, and put it in your includes folder
local json = require('json') -- download the json library lua, name it json.lua, and put it in your includes folder


local Webhook = Discord.new('') -- IN ORDER FOR THE SCRIPT TO WORK AT ALL YOU NEED TO PUT YOUR OWN WEBHOOK LINK HERE
local RichEmbed = Discord.newEmbed()


Webhook:setUsername('Webhook miss logs') -- Name of the bot (obv)
Webhook:setAvatarURL('') -- For a custom avatar/pfp put a link to the image into here


-- includes
local ffi = require("ffi") -- this stuff is just for chat printing, ignore it if you are just looking at the webhook stuff 
-- (primordial.dev/resources/print-in-chat.24/) This is the lib i used, not made by a tranny and easy to put into a script and not need an include. would reccomend

local FindElement = ffi.cast("unsigned long(__thiscall*)(void*, const char*)", memory.find_pattern("client.dll", "55 8B EC 53 8B 5D 08 56 57 8B F9 33 F6 39 77 28")) -- this stuff is just for chat printing, ignore it if you are just looking at the webhook stuff
local CHudChat = FindElement(ffi.cast("unsigned long**", ffi.cast("uintptr_t", memory.find_pattern("client.dll", "B9 ? ? ? ? E8 ? ? ? ? 8B 5D 08")) + 1)[0], "CHudChat") 
local FFI_ChatPrint = ffi.cast("void(__cdecl*)(int, int, int, const char*, ...)", ffi.cast("void***", CHudChat)[0][27]) 

local function PrintInChat(text) -- this stuff is just for chat printing, ignore it if you are just looking at the webhook stuff
    FFI_ChatPrint(CHudChat, 0, 0, string.format("%s ", text))
end

local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local function on_aimbot_miss(miss)

    -- All this stuff needs to be set every time you miss, so that you change the miss reason and stuff based on the reason
    RichEmbed:setTitle('Miss log') -- title of embed (bold text above description)
    RichEmbed:setDescription(user.name .. ' just missed ' .. miss.player:get_name() .. ' due to ' .. miss.reason_string .. '.\n ' .. "--| safe: " .. tostring(miss.aim_safepoint) .. " | damage: " .. miss.aim_damage .. " | bt ticks: " .. miss.backtrack_ticks - 1 .. " |--") -- the miss log
    RichEmbed:setColor(0x5C0000) -- This is the hex value of any color you want the embed accent to be, go to an online color picker if you want to change it from red

    if enable:get() then
        Webhook:send(RichEmbed) -- Sends the message to your webhook link

        if chat_notif:get() then -- chat notification
            PrintInChat('Webhook message sent.')
        end
    end
end

-- miss callback
callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss)