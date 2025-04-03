--[[
   _____                         ____                                 _   _______ _____  
  / ____|                       |  _ \                               | | |__   __|  __ \ 
 | (___  _   _ ___  __ _ _ __   | |_) | __ _ _ __ _ __ _____      __ | |    | |  | |  | |
  \___ \| | | / __|/ _` | '_ \  |  _ < / _` | '__| '__/ _ \ \ /\ / / | |    | |  | |  | |
  ____) | |_| \__ \ (_| | | | | | |_) | (_| | |  | | | (_) \ V  V /  | |____| |  | |__| |
 |_____/ \__,_|___/\__,_|_| |_| |____/ \__,_|_|  |_|  \___/ \_/\_/   |______|_|  |_____/ 
                                                                                         
                                                                                         
    HIT AND MISS LOGGER VISUAL BY SLXYX SUSAN BARROW LTD
]]--

local enableSwag = menu.add_checkbox("susan barrow ltd | general", "enable logger", false)
local printtoConsole = menu.add_checkbox("susan barrow ltd | general", "print logs to console", false)

local amountonscreen = menu.add_slider("susan barrow ltd | modifiers", "amount of logs on screen at one time", 1, 10)
local timelogs = menu.add_slider("susan barrow ltd | modifiers", "time before logs fade", 0, 10)
local fontstyle = menu.add_selection("susan barrow ltd | modifiers", "font style", {"normal", "bold"})

local logs = {}
local logrender = {}
local logtime = {}
local boollog = {true,true,true,true,true}
local curTime = {}
local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}


local fonts = {
    normal = render.create_font("Tahoma", 12, 100, e_font_flags.ANTIALIAS),
    bold = render.create_font("Tahoma Bold", 13, 500, e_font_flags.ANTIALIAS)
}

function drawLog()
    if not enableSwag:get() then return end
    local screen_size = render.get_screen_size()
    for i = 1, #logs do
        if logrender[i] then
            if not logtime[i] or not logs[i] then return end
            render.text(fontstyle:get() == 1 and fonts.normal or fonts.bold, logs[i], vec2_t(screen_size.x/2, screen_size.y/(1.25+i/45)), color_t(255, 255, 255, logtime[i]), true)
        end
    end
end

function onHit(e)
    local hitString = string.format("Hit %s in the %s [%s] for %s [%s] (hc: %s bt: %s)", e.player:get_name(), hitgroup_names[e.hitgroup + 1] or '?', hitgroup_names[e.aim_hitgroup + 1], e.damage, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, hitString); table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(hitString)
    end
    boollog[#logs] = true
end

function onMiss(e)
    local missString = string.format("Missed %s %s due to %s [%s] (hc: %s bt: %s)", e.player:get_name().."'s", hitgroup_names[e.aim_hitgroup + 1] or '?', e.reason_string, e.aim_damage, math.floor(e.aim_hitchance).."%", e.backtrack_ticks)
    table.insert(logs, missString)
    table.insert(logrender, true)
    if #logs > amountonscreen:get() then
        table.remove(logs, 1); table.remove(logrender, 1); table.remove(logtime, 1); table.remove(boollog, 1); table.remove(curTime, 1)
    end
    if printtoConsole:get() then
        client.log(missString)
    end
    boollog[#logs] = true
end

function handleVisibility()
    for i = 1, #logs do
        if boollog[i] then
            curTime[i] = client.get_unix_time() + timelogs:get()
            boollog[i] = false
            logtime[i] = 255
        end
        if not curTime[i] then goto endrendering end
        if curTime[i] < client.get_unix_time() then
            logtime[i] = logtime[i] - 1
        end
        if logtime[i] == 10 then
            table.remove(logs, i);table.remove(logrender, i);table.remove(logtime, i);table.remove(boollog, i);table.remove(curTime, i)
        end
        ::endrendering::
    end 
end

callbacks.add(e_callbacks.AIMBOT_MISS, onMiss)
callbacks.add(e_callbacks.AIMBOT_HIT, onHit)

callbacks.add(e_callbacks.PAINT, function()
    drawLog(); handleVisibility()
end)