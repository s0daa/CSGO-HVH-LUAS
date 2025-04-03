local checkbox1 = menu.add_checkbox("say's", "miss say")
local checkbox2 = menu.add_checkbox("say's", "tickbase say")
local checkbox3 = menu.add_checkbox("say's", "kill say")
local checkbox4 = menu.add_checkbox("spams", "clear chat")

--the paster (me) https://primordial.dev/members/dr_coomer.1014/
--I cant code, here is my stupid paste no one will use

--// Thnx for crent revise script B)
local talk_timer = 0; --// don't get smoked by csgo rate limit B)
local hi = 0
local strings = {}
local strings2 = {}
local http = require('http')
local new_request = http.new({0.3,true,10})

------------------------------------------------------------------- [miss say] ------------------------------------------------------------------- 
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



    new_request:get('https://pastebin.com/raw/C5cyzzpf',function(data) --stupid dumb pastebin shit, idk put your own paste bin to say other funny stuff
        local success = data.status == 200

       if not success then
        return;
        end

        for key, value in pairs(mysplit(data.body, '\r\n')) do
            table.insert(strings, value)
        end
    end)


    local function on_aimbot_miss() --start of the function
        if checkbox1:get() then
                engine.execute_cmd("say "..strings[client.random_int(1, #strings)]); --says the shit
            end
        end
            talk_timer = global_vars.real_time() + 20.5/100;

    callbacks.add(e_callbacks.AIMBOT_MISS, on_aimbot_miss) --when you miss it will run everything in the function

------------------------------------------------------------------- [recharge say] -------------------------------------------------------------------------
local function mysplit (inputstr2, sep2) --//Function stolen from stackoverflow, just adds a seperator for strings.
    if sep2 == nil then
            sep2 = "%s"
    end
    local t2={}
    for str2 in string.gmatch(inputstr2, "([^"..sep2.."]+)") do
            table.insert(t2, str2)
    end
    return t2
end

new_request:get('https://pastebin.com/raw/N13Ar3Uv',function(data2)
    local success = data2.status == 200

    if not success then
        return;
    end

    for key, value2 in pairs(mysplit(data2.body, '\r\n')) do
        table.insert(strings2, value2)
    end
end)

local function my_tickbase_manipulation_has_charged()
    if (game_rules.get_prop('m_bFreezePeriod') ~= 0) then --// 
        return;
    end

    if (exploits.get_charge() >= 14 and global_vars.real_time() >= talk_timer and exploits.get_max_charge() ~= hi) then 
        if (#strings2 ~= 0) then
        if checkbox2:get() then
            engine.execute_cmd("say "..strings2[client.random_int(1, #strings2)]);
        end
    end
        
        talk_timer = global_vars.real_time() + 20.5/100;
    end

    hi = exploits.get_charge();
end

callbacks.add(e_callbacks.NET_UPDATE, my_tickbase_manipulation_has_charged)
------------------------------------------------------------------- [kill say] -------------------------------------------------------------------------
local killsays = {
    'Breaking Bad',
    'died to time hack',
    '(insert really cringe shit a gs user would put here)',
    'bruh wtf',
    'hehehehaw',
    'died to primordial',
    '?',
    'problem?',
    'how did you die?',
    '0_o',
    'o_0',
    'O_o',
    'o_O'
    -- add as many as you want
}

local function table_lengh(data3) --grabbing how many killsay quotes are in our table
    if type(data3) ~= 'table' then
        return 0                                                    
    end
    local count = 0
    for _ in pairs(data3) do
        count = count + 1
    end
    return count
end

local function on_event(event3)
    local lp = entity_list.get_local_player() --grabbing out local player
    local kill_cmd = 'say ' .. killsays[math.random(table_lengh(killsays))] --randomly selecting a killsay
    if entity_list.get_player_from_userid(event3.attacker) ~= entity_list.get_local_player() then return end --checking if the killer is us
    if checkbox3:get() then
    engine.execute_cmd(kill_cmd) --executing the killsay command
    end
end

callbacks.add(e_callbacks.EVENT, on_event, "player_death") -- calling the function only when a player dies

local function on_paint()
    if checkbox4:get() then
    engine.execute_cmd("say ﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽ ﷽﷽﷽﷽")
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)