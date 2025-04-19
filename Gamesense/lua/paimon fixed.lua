local http = require "gamesense/http" or error("Missing gamesense/http")
local images = require "gamesense/images" or error("Missing gamesense/images")
local gif_decoder = require 'gamesense/gif_decoder' or error("Missing gamesense/gif_decoder")
local color_log = client.color_log

--local font = surface.create_font("TT_Skip-E 85W", 12, 1, {0x010}, {0x100}) --Genshin Impact font https://www.mediafire.com/file/x9732fvuwlbrwct/Genshin_Imapct_Fonts.rar/file

local hitgroup_names = {
    "generic",
    "head",
    "chest",
    "stomach",
    "left arm",
    "right arm",
    "left leg",
    "right leg",
    "neck",
    "?",
    "gear"
}

local menu = {
    ["paimon"] = ui.new_checkbox("MISC", "Settings", "Paimon"),
    ["chatBubble"] = ui.new_checkbox("MISC", "Settings", "Chat Bubbles"),
    ["logging"] = ui.new_checkbox("MISC", "Settings", "Paimon Logs"),
    ["consoleLogging"] = ui.new_checkbox("MISC", "Settings", "Log in Console"),
    ["showHC"] = ui.new_checkbox("MISC", "Settings", "Show Paimon HC%"),
}

local refs = {  --Dont really need anymore, but leaving it here
    ["fakeduck"] = ui.reference("Rage", "Other", "Duck peek assist")
}

local outputLogs = ''
local alphaNum = 255
local time_on_shot = 0

--On Miss
local function on_aim_missed( event )
    local missLogs = 'You missed ' .. entity.get_player_name( event.target ) .. ' because of ' .. event.reason .. '. You tried aiming for his '.. hitgroup_names[ event.hitgroup + 1 ] 
    if ui.get(menu.showHC) then
        missLogs = missLogs .. " with a Hit Chance of " .. event.hit_chance .. "%!"
    end
    alphaNum = 255
    time_on_shot = globals.realtime()
    -- so we can tell what it is without reading it
    if ui.get(menu.consoleLogging) then
        if event.reason == 'spread' then
        color_log( 255, 120, 0, "Paimon says: " .. missLogs)
        elseif event.reason == 'resolver' then
        color_log( 255, 0, 0, "Paimon says: " .. missLogs)
        else
        color_log( 255, 255, 255, "Paimon says: " .. missLogs)
        end
    end
    if not ui.get(menu.logging) then
        return
    end
    outputLogs = missLogs
end

client.set_event_callback( "aim_miss", on_aim_missed )

--On Hit
local function on_aim_hit( event )
    local hitLogs = 'You hit ' .. entity.get_player_name( event.target ) .. ' for ' .. event.damage .. ' damage! He has ' .. entity.get_prop( event.target, 'm_iHealth' ) .. ' HP left! You hit his ' .. hitgroup_names[ event.hitgroup + 1 ]
    if ui.get(menu.showHC) then
        hitLogs = hitLogs .. " with a Hit Chance of " .. event.hit_chance .. "%!"
    end
    alphaNum = 255
    time_on_shot = globals.realtime()
    if ui.get(menu.consoleLogging) then
        color_log( 0, 255, 0, "Paimon says: " .. hitLogs)
    end
    if not ui.get(menu.logging) then
        return
    end
    outputLogs = hitLogs
end

client.set_event_callback( "aim_hit", on_aim_hit )

local start_time = globals.realtime()

local paimonurl, paimon = "https://s3.gifyu.com/images/bbKlm.gif", nil
http.get(paimonurl, function(s, r)
    if s and r.status == 200 then
        paimon = gif_decoder.load_gif(r.body)
    end  
end)

client.set_event_callback("paint", function()
    if not entity.is_alive(entity.get_local_player()) or not ui.get(menu.paimon) or not paimon then return end
    local eyex, eyey, eyez = client.eye_position() 
    local camp, camy = client.camera_angles()
    local rad = math.rad(camy - 90)
    local px, py, pz = eyex + 25 * math.cos(rad), eyey + 25 * math.sin(rad), eyez + 20
    local sx, sy = renderer.world_to_screen(px, py, pz)
    if not sx or not sy then return end
    paimon:draw(globals.realtime()-start_time, sx, sy+10, 132, 155)
    if(ui.get(menu.chatBubble)) then
        local tw, th = renderer.measure_text("c", outputLogs) 
        if(globals.realtime() - time_on_shot >= 2 and (alphaNum <= 255 and alphaNum > 0)) then    --I'm retarded, this is my attempt at giving a delay to the chatbubble fading. Change the '2' to whatever to delay the fade
                alphaNum = alphaNum - 1
        end
        if(outputLogs ~= "") then   --Simple check to avoid invisible bubble
            renderer.circle(sx + 60 - tw / 2 - 3, sy - 21, 252, 252, 252, alphaNum, th - 4, 180, 0.5)       
            renderer.circle(sx + 68 + tw / 2 - 3, sy - 21, 252, 252, 252, alphaNum, th - 4, 0, 0.5)
            renderer.rectangle(sx + 60 - tw / 2 - 3, sy - 29, tw + 8, th + 4, 249, 249, 249, alphaNum)
            renderer.triangle((sx + tw/3)-30, (sy - 13), (sx + 8 + tw/3)-30, (sy - 13), (sx + tw/3)-30, (sy - 2), 249, 249, 249, alphaNum)
            renderer.text(sx + 60, sy - 22, 0, 0, 0, alphaNum, "c", 500, outputLogs)
            --surface.draw_text((sx + 60), (sy - 16), 0, 0, 0, 255, font, outputLogs) Was testing with custom font, but it looks ugly.
         end
    end
end)