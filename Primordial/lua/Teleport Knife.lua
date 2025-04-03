--By remine
local dt_ref = menu.find("aimbot", "general", "exploits", "doubletap", "enable")
local key_pressed = input.is_key_pressed(e_keys.MOUSE_LEFT)
local function getweapon()
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end

    local weapon_name = nil

    if local_player:get_prop("m_iHealth") > 0 then
    
        local active_weapon = local_player:get_active_weapon()
        if active_weapon == nil then return end

        weapon_name = active_weapon:get_name()


    else return end

    return weapon_name

end

local function on_event(event)
    knife_damage = false
    if event.name == "player_hurt" then
    if event.weapon == "knife" then
        exploits.block_recharge()
        knife_damage = true
        end
    end
end


local function dt_knife()
    local key_pressed = input.is_key_pressed(e_keys.MOUSE_LEFT)
    local local_player = entity_list.get_local_player()
    if local_player == nil then return end
    if local_player:get_prop("m_iHealth") > 0 and getweapon()=="knife" then

        if dt_ref[2]:get() and key_pressed == true and not menu.is_open() then
            exploits.force_uncharge()
        end
        if dt_ref[2]:get() and knife_damage == true then

            exploits.force_uncharge()
            
        end
        exploits.allow_recharge()
    end
end

callbacks.add(e_callbacks.RUN_COMMAND, dt_knife)
callbacks.add(e_callbacks.EVENT, on_event)