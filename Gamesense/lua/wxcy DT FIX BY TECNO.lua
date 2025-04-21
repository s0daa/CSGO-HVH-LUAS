
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
    if weapon_idx == nil or weapon_idx == 64 then return end
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


local dt_refs = {
    dt_enabled = ui.reference("RAGE", "Aimbot", "Double tap"),
    dt_hitchance = ui.reference("RAGE", "Aimbot", "Double tap hit chance"),
}

local ref = {
    misc = {
        max_ticks = ui.reference("misc", "Settings", "sv_maxusrcmdprocessticks2"),
    }
}

local last_target = nil
local last_shot_time = 0
local force_second_shot = false

local function should_force_dt()
    local local_player = entity.get_local_player()
    if not local_player or not entity.is_alive(local_player) then return false end
    
    local weapon = entity.get_player_weapon(local_player)
    if not weapon then return false end
    
    return ui.get(dt_refs.dt_enabled)
end

client.set_event_callback("aim_fire", function(e)
    if should_force_dt() then
        last_target = e.target
        last_shot_time = globals.curtime()
        force_second_shot = true
    end
end)

client.set_event_callback("setup_command", function(cmd)
    if should_force_dt() and force_second_shot and last_target and globals.curtime() - last_shot_time < 0.1 then
        local local_player = entity.get_local_player()
        local weapon = entity.get_player_weapon(local_player)
        entity.set_prop(weapon, "m_flNextSecondaryAttack", globals.curtime() - 0.05)
        entity.set_prop(local_player, "m_flNextAttack", globals.curtime() - 0.05)
        cmd.in_attack = 1  -- Эквивалент force_attack
        force_second_shot = false
    else
        -- Восстановление настроек
        force_second_shot = false
    end
end)


-- Double Tap Boost Script
-- Version 1.0
-- https://gamesense.pub

local enable_boost = ui.new_checkbox("Rage", "Aimbot", "Double Tap Boost")
local boost_type = ui.new_combobox("Rage", "Aimbot", "Boost Type", {"Default", "Safe", "Dangerous", "Adaptive", "Custom"})
local custom_boost = ui.new_slider("Rage", "Aimbot", "Custom Boost Amount", 6, 18, 16, true, "", 1, {[6] = "Slowest", [16] = "Default", [18] = "Fastest"})

local max_tick_ref = ui.reference("MISC", "Settings", "sv_maxusrcmdprocessticks2")

ui.set_visible(custom_boost, false)

ui.set_callback(boost_type, function()
    ui.set_visible(custom_boost, ui.get(boost_type) == "Custom")
end)

local function update_boost()
    if not ui.get(enable_boost) then return end
    
    local boost_mode = ui.get(boost_type)
    local ping = math.floor(client.latency() * 1000)
    
    if boost_mode == "Default" then
        client.set_cvar("sv_maxusrcmdprocessticks", "18")
        ui.set(max_tick_ref, 16)
    elseif boost_mode == "Safe" then
        client.set_cvar("sv_maxusrcmdprocessticks", "18")
        ui.set(max_tick_ref, 14)
    elseif boost_mode == "Dangerous" then
        client.set_cvar("sv_maxusrcmdprocessticks", "18")
        ui.set(max_tick_ref, 17)
    elseif boost_mode == "Adaptive" then
        client.set_cvar("sv_maxusrcmdprocessticks", "18")
        ui.set(max_tick_ref, ping <= 55 and 17 or 16)
    elseif boost_mode == "Custom" then
        client.set_cvar("sv_maxusrcmdprocessticks", 18)
        ui.set(max_tick_ref, ui.get(custom_boost))
    end
end


client.set_event_callback("run_command", function()
    update_boost()
end)

client.set_event_callback("shutdown", function()
    ui.set(max_tick_ref, 16) -- Reset to default value
    client.set_cvar("sv_maxusrcmdprocessticks", "16")
end)


-- def fix


local dtPeekFix = ui.new_checkbox("RAGE", "other", "Fix defensive in peek")

local function vec_3( _x, _y, _z ) 
	return { x = _x or 0, y = _y or 0, z = _z or 0 } 
end

local function ticks_to_time()
	return globals.tickinterval( ) * 16
end 

local refs = {
    dt = {ui.reference("RAGE", "Aimbot", "Double tap")},
}

local function player_will_peek( )
	local enemies = entity.get_players( true )
	if not enemies then
		return false
	end
	
	local eye_position = vec_3( client.eye_position( ) )
	local velocity_prop_local = vec_3( entity.get_prop( entity.get_local_player( ), "m_vecVelocity" ) )
	local predicted_eye_position = vec_3( eye_position.x + velocity_prop_local.x * ticks_to_time( predicted ), eye_position.y + velocity_prop_local.y * ticks_to_time( predicted ), eye_position.z + velocity_prop_local.z * ticks_to_time( predicted ) )

	for i = 1, #enemies do
		local player = enemies[ i ]
		
		local velocity_prop = vec_3( entity.get_prop( player, "m_vecVelocity" ) )
		
		-- Store and predict player origin
		local origin = vec_3( entity.get_prop( player, "m_vecOrigin" ) )
		local predicted_origin = vec_3( origin.x + velocity_prop.x * ticks_to_time(), origin.y + velocity_prop.y * ticks_to_time(), origin.z + velocity_prop.z * ticks_to_time() )
		
		-- Set their origin to their predicted origin so we can run calculations on it
		entity.get_prop( player, "m_vecOrigin", predicted_origin )
		
		-- Predict their head position and fire an autowall trace to see if any damage can be dealt
		local head_origin = vec_3( entity.hitbox_position( player, 0 ) )
		local predicted_head_origin = vec_3( head_origin.x + velocity_prop.x * ticks_to_time(), head_origin.y + velocity_prop.y * ticks_to_time(), head_origin.z + velocity_prop.z * ticks_to_time() )
		local trace_entity, damage = client.trace_bullet( entity.get_local_player( ), predicted_eye_position.x, predicted_eye_position.y, predicted_eye_position.z, predicted_head_origin.x, predicted_head_origin.y, predicted_head_origin.z )
		
		-- Restore their origin to their networked origin
		entity.get_prop( player, "m_vecOrigin", origin )
		
		-- Check if damage can be dealt to their predicted head
		if damage > 0 then
			return true
		end
	end
	
	return false
end

client.set_event_callback( "setup_command", function( cmd )
    if not ui.get(dtPeekFix) then
        return
    end

	local dt = ui.get(refs.dt[1]) and ui.get(refs.dt[2])

    if not dt then
        return
    end

    if player_will_peek() then
        cmd.force_defensive = true
    else
        cmd.force_defensive = false
    end
end)







