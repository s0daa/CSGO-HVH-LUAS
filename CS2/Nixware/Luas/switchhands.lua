local wasSwitching = false

register_callback("paint", function()
    local pawn = entitylist.get_local_player_pawn()
    if pawn == nil then return end

    local weapon_services = pawn.m_pWeaponServices
    if weapon_services == nil then return end

    local weapon = weapon_services.m_hActiveWeapon
    if weapon == nil then return end

    local weapondata = weapon.m_pWeaponData
    if weapondata == nil then return end

    local weaponPrice = weapondata.m_nPrice

    if weaponPrice == 0 then
        if not wasSwitching then
            engine.execute_client_cmd("switchhandsleft")
            wasSwitching = true
        end
    else
        if wasSwitching then
            engine.execute_client_cmd("switchhandsright")
            wasSwitching = false
        end
    end
end)
