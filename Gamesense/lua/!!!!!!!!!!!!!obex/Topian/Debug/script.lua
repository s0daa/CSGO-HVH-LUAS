-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local rolloverride = ui.new_hotkey("RAGE","Other","Roll override");
local state = false;
local mode = 0;
local images = require 'gamesense/images'

local hitgroup_names = {'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear'}

local data = {
    fired_shots = {},
    shots = {}
}

local function x()
    local x = ui.get(rolloverride);
    if x ~= state then;
        mode = mode ~= 2 and mode + 1 or 0;
        state = x;
    end;
end;

local function override(ent,roll)
    local _,yaw = entity.get_prop(ent, "m_angRotation");
    local pitch = 89*((2*entity.get_prop(ent, "m_flPoseParameter",12))-1);
    entity.set_prop(ent, "m_angEyeAngles", pitch, yaw, roll);
end;

client.set_event_callback("net_update_start",function()
    local e = client.current_threat();
    if e then
        for _,enemy in next, entity.get_players(true) do
            if enemy ~= e then;
                override(enemy,0);
            end;
        end;
        override(e, mode == 1 and 50 or mode == 2 and -50 or mode);
    end;
end);

client.set_event_callback("aim_miss", function(e)

local group = hitgroup_names[e.hitgroup + 1] or '?'
end)

client.set_event_callback('aim_miss', function()
if mode == 1 then
    mode = 2
    else mode = 1
end
end)

client.set_event_callback("paint",function()
    x();
    if mode ~= 0 then
        renderer.indicator(132,196,20,245,mode == 1 and "FUCKROLL" or "FUCKROLL");
    end;
end);

client.register_esp_flag("FUCKROLL",245, 10, 10,function(player)
    return mode == 1 and player == client.current_threat() and true or false;
end);

client.register_esp_flag("FUCKROLL",245, 10, 10,function(player)
    return mode == 2 and player == client.current_threat() and true or false;
end);