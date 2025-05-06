local process = ui.reference("Misc", "Settings", "sv_maxusrcmdprocessticks")
local angle = ({ui.reference("AA", "Anti-aimbot angles", "Yaw")})[2]
local lag = ui.reference("AA", "Fake lag", "Limit")
local anti_aim = require 'gamesense/antiaim_funcs'
local hideshot = {ui.reference("AA", "Other", "On shot anti-aim")}
local dt = {ui.reference("Rage", "Other", "Double tap")}


local in_flick = false
local delay_dt = globals.realtime()
local length_dt = globals.realtime()
local delay = 0.211
local length = 0.02
ui.set(process, 16)
client.set_event_callback("setup_command", function(e)
    
    
    if ui.get(dt[2]) then 
        return 
    end

    if not ui.get(hideshot[1]) and not ui.get(hideshot[2]) then
        return
    end

    if ((not in_flick) and (globals.realtime() > delay_dt + delay)) then
        ui.set(lag, 8)
        e.allow_send_packet = false
        in_flick = true;
        delay_dt = globals.realtime(); -- reset it
        length_dt = delay_dt; -- start it here nigga
        ui.set(lag, 8)
        print(e.chokedcommands)
        ui.set(angle, 110)
    end
    
    
    
-- -20 jitter, jitter_fake 0, 60, favor aa slowwalk

    if (in_flick) then
        ui.set(process, 6)
        e.allow_send_packet = true
        
        if (globals.realtime() > length_dt + length) then
            
            --if (anti_aim.get_desync(1) <= 3) then
            ui.set(angle, 0)
            if ui.get(lag) ~= 15 then
                --e.allow_send_packet = true
                --print(anti_aim.get_desync(1))
                ui.set(process, 16)
                ui.set(lag, 13)            
                ui.set(lag, 8)
                in_flick = false;
            end
            --end
        end
    end
    --print("Times flicked: " .. timesflicked)
    --print("Times IN: " .. timesin)
end)