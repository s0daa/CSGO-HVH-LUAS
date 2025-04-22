-- @region: script

local script = { };

script.name = "bloodedge";

script.build = "ragebot";

-- @region: libraries

local libraries = { };

libraries.ffi = require("ffi");

-- @region: ffi

libraries.ffi.cdef[[ struct animation_layer_t { char pad20[24]; uint32_t m_nSequence; float m_flPrevCycle; float m_flWeight; float m_flWeightDeltaRate; float m_flPlaybackRate; float m_flCycle; uintptr_t m_pOwner; char pad_0038[ 4 ]; }; ]];

-- @region: menu

local menu = { };

menu.elements = { }; menu.sub_elements = { };

menu.sub_elements.label = ui.new_label("RAGE", "Other", " ");

menu.elements.selection = ui.new_multiselect("RAGE", "Other", "Bloodedge Ragebot" .. "\a99999998" ..  " [Beta]", {"Anti-aim correction", "Force body on lethal", "Prefer body on override"});

menu.elements.body_aim_lethality = ui.new_slider("RAGE", "Other", "Body aim lethality", 1, 92, 92, true, "HP");

menu.sub_elements.label = ui.new_label("RAGE", "Other", "  ");

-- @region: custom math

math.clamp = function(x, min, max)
    return math.max(min, math.min(x, max));
end;

-- @region: utility

local utility = { };

utility.get_client_entity = vtable_bind("client.dll", "VClientEntityList003", 3, "void*(__thiscall*)(void*, int)");

utility.get_anim_layer = function(b, c)
    c = c or 1; b = libraries.ffi.cast(libraries.ffi.typeof('void***'), b);

    return libraries.ffi.cast('struct animation_layer_t**', libraries.ffi.cast('char*', b) + 0x2990)[0][c];
end;

utility.contains = function(table, argument)
    for index, value in next, table do 
        if value == argument then 
            return true;
        end;
    end;

    return false;
end;

-- @region: functions

local functions = { };

functions.elements_visibility = function()
    ui.set_visible(menu.elements.body_aim_lethality, (utility.contains(ui.get(menu.elements.selection), "Force body on lethal")));
end;

functions.jitter_records = { };

functions.resolve_jitter = function(player)
    if not utility.contains(ui.get(menu.elements.selection), "Anti-aim correction") then
        functions.jitter_records[player] = { side = 1, side_count = 0, desync = 0, temp_pitch = 0, parts = { }, layers = { } };

        plist.set(player, "Correction active", true); plist.set(player, "Force body yaw", false); plist.set(player, "Force pitch", false);
    else
        if not functions.jitter_records[player] then
            functions.jitter_records[player] = { side = 1, side_count = 0, desync = 0, temp_pitch = 0, parts = { }, layers = { } };
        else
            for u = 1, 13, 1 do
                functions.jitter_records[player].layers[u] = { };
    
                functions.jitter_records[player].layers[u]["Main"] = utility.get_anim_layer(utility.get_client_entity(player), 6);
    
                functions.jitter_records[player].layers[u]["m_flPrevCycle"] = functions.jitter_records[player].layers[u]["Main"].m_flPrevCycle;
    
                functions.jitter_records[player].layers[u]["m_flWeight"] = functions.jitter_records[player].layers[u]["Main"].m_flWeight;
                
                functions.jitter_records[player].layers[u]["m_flWeightDeltaRate"] = functions.jitter_records[player].layers[u]["Main"].m_flWeightDeltaRate;
    
                functions.jitter_records[player].layers[u]["m_flPlaybackRate"] = functions.jitter_records[player].layers[u]["Main"].m_flPlaybackRate;
                
                functions.jitter_records[player].layers[u]["m_flCycle"] = functions.jitter_records[player].layers[u]["Main"].m_flCycle;
    
                functions.jitter_records[player].parts[u] = { };
    
                for y, val in pairs({"m_flPrevCycle", "m_flWeight", "m_flWeightDeltaRate", "m_flPlaybackRate", "m_flCycle"}) do
                    functions.jitter_records[player].parts[u][val] = { };
    
                    for i = 1, 13, 1 do
                        functions.jitter_records[player].parts[u][val][i] = math.floor(functions.jitter_records[player].layers[u][val] * (10 ^ i)) - (math.floor(functions.jitter_records[player].layers[u][val] * (10 ^ (i - 1))) * 10);
                    end;
                end;
            end;
    
            local right_side = functions.jitter_records[player].parts[6]["m_flPlaybackRate"][4] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][5] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][6] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][7];
            
            local left_side = functions.jitter_records[player].parts[6]["m_flPlaybackRate"][6] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][7] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][8] + functions.jitter_records[player].parts[6]["m_flPlaybackRate"][9];
    
            local temp;
    
            if functions.jitter_records[player].parts[6]["m_flPlaybackRate"][3] == 0 then
                temp = -3.4117 * left_side + 98.9393;
    
                if temp < 64 then
                    functions.jitter_records[player].desync = temp;
                end;
            else
                temp = -3.4117 * right_side + 98.9393;
    
                if temp < 64 then
                    functions.jitter_records[player].desync = temp;
                end;
            end;
    
            local temp_weight = tonumber(functions.jitter_records[player].parts[6]["m_flWeight"][4] .. functions.jitter_records[player].parts[6]["m_flWeight"][5]);
    
            if functions.jitter_records[player].parts[6]["m_flWeight"][2] == 0 then
                if (functions.jitter_records[player].layers[6]["m_flWeight"] * 10 ^ 5 > 300) then
                    functions.jitter_records[player].side_count = functions.jitter_records[player].side_count + 1;
                else
                    functions.jitter_records[player].side_count = 0;
                end;
            elseif functions.jitter_records[player].parts[6]["m_flWeight"][1] == 9 then
                if temp_weight == 29 then
                    functions.jitter_records[player].side = "Left";
                elseif temp_weight == 30 then
                    functions.jitter_records[player].side = "Right";
                elseif functions.jitter_records[player].parts[6]["m_flWeight"][2] == 9 then
                    functions.jitter_records[player].side_count = functions.jitter_records[player].side_count + 2;
                else
                    functions.jitter_records[player].side_count = 0;
                end;
            end;
    
            if functions.jitter_records[player].side_count >= 4 then
                if functions.jitter_records[player].side == "Left" then
                    functions.jitter_records[player].side = "Right";
                else
                    functions.jitter_records[player].side = "Left";
                end;
    
                functions.jitter_records[player].side_count = 0;
            end;
    
            functions.jitter_records[player].desync = math.clamp(math.abs(math.floor(functions.jitter_records[player].desync)), 0, 60);
    
            local pitch = ({entity.get_prop(player, "m_angEyeAngles")})[1];
    
            if pitch < 0 and functions.jitter_records[player].temp_pitch > 0 then
                plist.set(player, "Force pitch", true);
    
                plist.set(player, "Force pitch value", functions.jitter_records[player].temp_pitch);
            else
                plist.set(player, "Force pitch", false);
    
                functions.jitter_records[player].temp_pitch = pitch;
            end;
    
            if functions.jitter_records[player].side == "Right" then
                plist.set(player, "Force body yaw value", functions.jitter_records[player].desync);
            else
                plist.set(player, "Force body yaw value", -functions.jitter_records[player].desync);
            end;
    
            plist.set(player, "Force body yaw", true);
        
            plist.set(player, "Correction active", true);
        end;
    end;
end;

functions.body_aim = function(player)
    local minimum_damage_override = { ui.reference("Rage", "Aimbot", "Minimum damage override") };

    if not utility.contains(ui.get(menu.elements.selection), "Force body on lethal") and not (utility.contains(ui.get(menu.elements.selection), "Prefer body on override") and ui.get(minimum_damage_override[1]) and ui.get(minimum_damage_override[2])) then
        plist.set(player, "Override prefer body aim", "-");
    else
        if entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSSG08" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponG3SG1" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponSCAR20" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CWeaponAWP" and entity.get_classname(entity.get_player_weapon(entity.get_local_player())) ~= "CDEagle" then
            plist.set(player, "Override prefer body aim", "-");
        else
            if entity.get_prop(player, "m_iHealth") <= ui.get(menu.elements.body_aim_lethality) and utility.contains(ui.get(menu.elements.selection), "Force body on lethal") then
                plist.set(player, "Override prefer body aim", "Force");
            else
                if (utility.contains(ui.get(menu.elements.selection), "Prefer body on override") and ui.get(minimum_damage_override[1]) and ui.get(minimum_damage_override[2])) then
                    plist.set(player, "Override prefer body aim", "On");
                else
                    plist.set(player, "Override prefer body aim", "-");
                end;
            end;
        end;
    end;
end;

functions.update_players = function()
    client.update_player_list();

    local players = entity.get_players(true);

    for id, player in pairs(players) do
        functions.resolve_jitter(player);

        functions.body_aim(player);
    end;
end;

-- @region: callbacks

local callbacks = { };

callbacks.paint_ui = client.set_event_callback("paint_ui", function()
    functions.elements_visibility();
end);

callbacks.net_update_end = client.set_event_callback("net_update_end", function()
    functions.update_players();
end);