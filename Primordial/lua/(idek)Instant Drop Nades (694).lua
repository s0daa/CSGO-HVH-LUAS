--by ivg

local menugroup = menu.set_group_column("Menu", 1) 
local nadetoggles = menu.add_multi_selection("Menu","Nades to drop",{"HE Grenade","Molotov","Smoke"})
local nadedrop = menu.add_text("Menu","Drop Nades")
local keybind = nadedrop:add_keybind("Drop Nades")
local count = 0

local entity = entity_list.get_local_player()

local function delay_molly()
    if nadetoggles:get(2) then
            engine.execute_cmd("use weapon_knife; wait 1; use weapon_molotov; wait 1;use weapon_incgrenade;drop")
    end
end
local function delay_he()
    if nadetoggles:get(1) then
        engine.execute_cmd("use weapon_knife; wait 1;use weapon_hegrenade;drop")
    end
end
local function delay_smoke()
    if nadetoggles:get(3) then
        engine.execute_cmd("use weapon_knife; wait 1; use weapon_smokegrenade;drop")
    end
end

local function delay_switch()
        engine.execute_cmd("slot2;wait 1;slot1")
end

local function nadehandle()
    if keybind:get() and count < 1 then
        count = count + 1

        client.delay_call(delay_molly, 0.1)
        client.delay_call(delay_he, 0.2)
        client.delay_call(delay_smoke, 0.3)
        client.delay_call(delay_switch, 0.4)
      
    elseif not keybind:get() and count ~= 0 then
        count = 0
    end
end

callbacks.add(e_callbacks.PAINT, function()
    nadehandle()
end)