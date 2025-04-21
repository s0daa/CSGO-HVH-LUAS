local refs = {
    rage_cb = { ui.reference("RAGE", "Aimbot", "Enabled") },
    dt = { ui.reference("RAGE", "Aimbot", "Double tap") },
    fake_duck = ui.reference("RAGE","Other","Duck peek assist"),
}

local vars = {
    dt_charged = false,
}

client.set_event_callback('setup_command', function(cmd)
    local tickbase = entity.get_prop(entity.get_local_player(), "m_nTickBase") - globals.tickcount()
    local doubletap_ref = ui.get(refs.dt[1]) and ui.get(refs.dt[2]) and not ui.get(refs.fake_duck)
    local active_weapon = entity.get_prop(entity.get_local_player(), "m_hActiveWeapon")
    if active_weapon == nil then return end
    local weapon_idx = entity.get_prop(active_weapon, "m_iItemDefinitionIndex")
    if weapon_idx == nil then return end
    local LastShot = entity.get_prop(active_weapon, "m_fLastShotTime")
    if LastShot == nil then return end
    local single_fire_weapon = weapon_idx == 40 or weapon_idx == 9 or weapon_idx == 64 or weapon_idx == 27 or weapon_idx == 29 or weapon_idx == 35
    local value = single_fire_weapon and 1.50 or 0.50
    local in_attack = globals.curtime() - LastShot <= value

    if tickbase > 0 and doubletap_ref then
        if in_attack then
            ui.set(refs.rage_cb[2], "Always on")
        else
            ui.set(refs.rage_cb[2], "On hotkey")
        end
    else
        ui.set(refs.rage_cb[2], "Always on")
    end
end)
