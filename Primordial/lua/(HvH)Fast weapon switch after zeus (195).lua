--thanks the thought from other forum
--paste by Remine again hahahahaha
local switch_id = menu.add_selection( "Fast Switch After Zues ", "Weapon",  {"Primary", "Secondry", "Knife" } )

local function new_wpn()
    local choice = switch_id:get()
    if choice == 1 then return "slot1" end
    if choice == 2 then return "slot2" end
    if choice == 3 then return "slot3" end
end

local function on_aimbot_shoot(shot)
local local_player = entity_list:get_local_player()
local weapon = entity_list.get_entity(local_player:get_prop("m_hActiveWeapon"))
local weapon_name = weapon:get_name()
if weapon_name ~= "taser" then return end
    engine.execute_cmd(new_wpn())
end
    
callbacks.add(e_callbacks.AIMBOT_SHOOT, on_aimbot_shoot)