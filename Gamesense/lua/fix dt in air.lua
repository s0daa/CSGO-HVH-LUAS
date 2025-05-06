local antiaim_funcs = require("gamesense/antiaim_funcs")

local vars = {
    ref = {
        aimbot = ui.reference("RAGE", "Aimbot", "Enabled"),

        dt = ui.reference("RAGE", "Aimbot", "Double tap"),
        dt_key = select(2, ui.reference("RAGE", "Aimbot", "Double tap")),

        flags = ui.reference("VISUALS", "Player ESP", "Flags"),
    },
    globals = {
        local_vulnerable = nil,
        tickbase = nil,
        
        charged = false,

        data = {},
        index = 1,
    },
}

local func = {
    update_vulnerable_state = function(local_player)
        local th = client.current_threat()

        if th == nil then 
            vars.globals.local_vulnerable = false 
            return 
        end

        if ui.get(vars.ref.flags) then 
            vars.globals.local_vulnerable = (bit.band(entity.get_esp_data(th).flags, bit.lshift(1, 11)) == 2048) 
            return
        else
            if entity.is_dormant(th) then 
                vars.globals.local_vulnerable = false 
                return 
            end

            local start_pos = {entity.hitbox_position(th, 0)}
            local end_pos = {entity.get_prop(local_player, "m_vecOrigin")}
            end_pos[3] = end_pos[3] + 32

            local _, dmg = client.trace_bullet(th, start_pos[1], start_pos[2], start_pos[3], end_pos[1], end_pos[2], end_pos[3], false)

            vars.globals.local_vulnerable = dmg > 1
        end
    end,
    weapon_can_fire = function(ent)
	    local active_weapon = entity.get_prop(ent, "m_hActiveWeapon")
	    local nextAttack = entity.get_prop(active_weapon, "m_flNextPrimaryAttack")
	    return globals.curtime() >= nextAttack
    end,
}

client.set_event_callback('net_update_end', function()
    local local_player = entity.get_local_player()
    if local_player == nil then return end 

    if vars.globals.tickbase == nil then
        vars.globals.tickbase = entity.get_prop(local_player, 'm_nTickBase')
        return
    end

    local current_tickbase = entity.get_prop(local_player, 'm_nTickBase')

    vars.globals.data[vars.globals.index] = current_tickbase - vars.globals.tickbase
    vars.globals.index = vars.globals.index + 1
    vars.globals.index = vars.globals.index % 16

    vars.globals.charged = false 

    for i=1, 15 do 
       if vars.globals.data[i] ~= nil and vars.globals.data[i] < 0 then
            vars.globals.charged = true
            return
       end
    end

    if vars.globals.charged == false and antiaim_funcs.get_tickbase_shifting() > 0 then
        vars.globals.charged = true
    end

    vars.globals.tickbase = current_tickbase
end)

client.set_event_callback("setup_command", function(e)
    local local_player = entity.get_local_player()
    if local_player == nil then return end 

    if bit.band(entity.get_prop(local_player, "m_fFlags"), 1) == 1 then 
        ui.set(vars.ref.aimbot, true) 
        return 
    end

    func.update_vulnerable_state(local_player)
        
    if not ui.get(vars.ref.dt) or not ui.get(vars.ref.dt_key) or vars.globals.local_vulnerable == false then
        ui.set(vars.ref.aimbot, true) 
        return 
    end
    
    local weapon = entity.get_player_weapon(local_player)

    if weapon == nil then 
        ui.set(vars.ref.aimbot, true) 
        return 
    end

    if func.weapon_can_fire(local_player) and entity.get_classname(weapon) == 'CKnife' then 
        ui.set(vars.ref.aimbot, true)
    end
    
    ui.set(vars.ref.aimbot, vars.globals.charged) 
end)
 
client.set_event_callback("shutdown", function()
    ui.set(vars.ref.aimbot, true) 
end)
 