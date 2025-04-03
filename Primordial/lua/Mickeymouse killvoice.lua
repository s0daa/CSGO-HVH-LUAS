local loopback = cvars.voice_loopback
local cTime = 0
local len = 5
local handler = nil
local enabled = true 
local timer = 0


local siggy = {"engine.dll", "55 8B EC 83 EC 0C 83 3D ? ? ? ? ? 56 57"}
local voice_record_start = ffi.cast('void(__fastcall*)(const char*, const char*, const char*)', memory.find_pattern(unpack(siggy)))

handler = function() 
    cTime = global_vars.real_time()
    if cTime >= timer then 
        timer = global_vars.real_time() + len 
        if enabled then 
            loopback:set_int(0)
            engine.execute_cmd("-voicerecord")
            enabled = false 
        end
    end
end


local function death_event(event_info)
    local attacker = entity_list.get_player_from_userid(event_info.attacker)
    local victim = entity_list.get_player_from_userid(event_info.userid)
    if attacker == nil then return end
    if(attacker:get_name() ~= entity_list.get_local_player():get_name()) then
        return
    end
    local rdm = client.random_int(1, 7)
    loopback:set_int(1)
    voice_record_start(nil, nil, "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Counter-Strike Global Offensive\\csgo\\sound\\killsays\\mickey"..rdm..".wav")

    timer, enabled = global_vars.real_time() + len, true 

end

callbacks.add(e_callbacks.PAINT, handler)
callbacks.add(e_callbacks.EVENT,death_event,"player_death")