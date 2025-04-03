--// Thnx for crent revise script B)
local talk_timer = 0; --// don't get smoked by csgo rate limit B)
local hi = 0
local strings = {}
local http = require('http')
local new_request = http.new({0.3,true,10})

local function mysplit (inputstr, sep) --//Function stolen from stackoverflow, just adds a seperator for strings.
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

new_request:get('https://pastebin.com/raw/KJRWPD4e',function(data)
    local success = data.status == 200

    if not success then
        return;
    end

    for key, value in pairs(mysplit(data.body, '\r\n')) do
        table.insert(strings, value)
    end
end)

local function my_tickbase_manipulation_has_charged()
    if (game_rules.get_prop('m_bFreezePeriod') ~= 0) then --// 
        return;
    end

    if (exploits.get_charge() >= 14 and global_vars.real_time() >= talk_timer and exploits.get_max_charge() ~= hi) then 
        if (#strings ~= 0) then
            engine.execute_cmd("say "..strings[client.random_int(1, #strings)]);
        end
        
        talk_timer = global_vars.real_time() + 20.5/100;
    end

    hi = exploits.get_charge();
end

callbacks.add(e_callbacks.NET_UPDATE, my_tickbase_manipulation_has_charged)