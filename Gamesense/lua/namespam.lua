local credits = ui.new_label('LUA', 'A', 't.me/neverlosehost');
local spamenabled = ui.new_checkbox('LUA', 'A', 'nickname change spammer');
local n0 = ui.new_label('LUA', 'A', 'please, click on Steal Player Name IN MISC');
local n1 = ui.new_label('LUA', 'A', 'to get it work ONE-TIME!!!!')
local name = ui.new_label('LUA', 'A', 'SET CUSTOM NAME BEFORE JOINING SERVER HERE!!!');
local nameg = ui.new_textbox('LUA', 'A', 'Custom Name');


pname = "t.me/neverlosehost"

client.set_event_callback("paint", function()
    if ui.get(spamenabled) then
        local getcname = ui.get(nameg)

        if getcname and getcname ~= '' then
            pname = getcname
        end
        client.set_cvar("name", "\x81 "..pname)
        client.set_cvar("voice_loopback", client.get_cvar("voice_loopback") == "0" and "1" or "0")
end
end)
