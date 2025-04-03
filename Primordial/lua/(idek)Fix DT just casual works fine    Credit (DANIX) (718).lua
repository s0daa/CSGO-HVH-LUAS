local function fix_dt() 
    if not exploits.get_charge() == 0 then return end 

    local lp = entity_list.get_local_player()
    if not lp or lp == nil then return end

    local weapon = lp:get_active_weapon()
    if not weapon or weapon == nil then return end

    local weapon_name = weapon:get_name()

    if weapon_name == 'knife' then 
        if exploits.get_charge() == 0 then 
            exploits.allow_recharge() exploits.block_recharge() 
        end 
        return
    end

    exploits.allow_recharge()
end
callbacks.add(e_callbacks.SETUP_COMMAND, fix_dt)