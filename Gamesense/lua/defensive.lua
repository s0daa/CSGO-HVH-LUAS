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