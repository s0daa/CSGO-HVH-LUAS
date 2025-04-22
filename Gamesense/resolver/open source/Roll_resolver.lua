local g_player_list =
{
    reference = ui.reference ( 'Players', 'Players', 'Player List' ),
    reset_reference = ui.reference ( 'Players', 'Players', 'Reset all' ),
    controls = { },

    init = function ( self )
        ui.set_callback ( self.reference, function ( )
            local target = ui.get ( self.reference )

            if ( #self.controls > 0 ) then
                for i = 1, #self.controls do
                    if ( #self.controls [ i ].cache > 0) then
                        for f = 1, #self.controls [ i ].cache do
                            if ( self.controls [ i ].cache [ f ].entity == target ) then
                                ui.set ( self.controls [ i ].reference, self.controls [ i ].cache [ f ].value)
                                goto skip
                            end
                        end
                    end
                    
                    ui.set ( self.controls [ i ].reference, self.controls [ i ].default )

                    ::skip::
                end
            end
        end )

        ui.set_callback ( self.reset_reference, function ( )
        	if ( #self.controls > 0 ) then
                for i = 1, #self.controls do
                    self.controls [ i ].cache = { }
                    ui.set ( self.controls [ i ].reference, self.controls [ i ].default )
                end
            end
        end )
    end,

    add_control = function ( self, field_name, control, default )
        local control_tbl =
        {
            field_name = field_name,
            reference = control,
            cache = { },
            default = default
        }

        table.insert ( self.controls, control_tbl )

        ui.set_callback ( control, function ( )
            local value = ui.get ( control )
            local target = ui.get ( self.reference )

            for i = 1, #control_tbl.cache do
                if control_tbl.cache [ i ].entity == target then
                    control_tbl.cache [ i ].value = value
                    return
                end
            end
    
            table.insert ( control_tbl.cache, { entity = target, value = value } )
        end )
    end,

    get_value = function ( self, target, field_name )
        for _, c in pairs ( self.controls ) do
            if c.field_name == field_name then
                for __, v in pairs ( c.cache ) do
                    if v.entity == target then
                        return v.value
                    end
                end

                return c.default
            end
        end

        return nil
    end
}

local g_roll_resolver =
{
	sides = { },
	unload = false,

	init = function ( self )
		g_player_list:add_control ( 'Roll override', ui.new_checkbox ( 'Players', 'Adjustments', '» Roll override' ), false )
		g_player_list:add_control ( 'Roll override flag', ui.new_checkbox ( 'Players', 'Adjustments', '» Roll override flag' ), false )
		g_player_list:add_control ( 'Roll degree', ui.new_slider ( 'Players', 'Adjustments', '» Roll degree', -90, 90, 45, true, '°' ), 45 )
		g_player_list:add_control ( 'Roll bruteforce', ui.new_checkbox ( 'Players', 'Adjustments', '» Roll bruteforce' ), false )
	end,

	override = function ( self, idx, deg )
		local _ , yaw = entity.get_prop ( idx, 'm_angRotation' )
		local pitch = 89 * ( ( 2 * entity.get_prop ( idx, 'm_flPoseParameter', 12 ) ) - 1 )
		entity.set_prop ( idx, 'm_angEyeAngles', pitch, yaw, deg )
	end,

	on_net_update_start = function ( self )
		if self.unload then
			return
		end

		local e = entity.get_local_player ( )
		if e then
			for _, idx in pairs ( entity.get_players ( true ) ) do
				if idx ~= e then
					if g_player_list:get_value ( idx, 'Roll override' ) then
						local side = ( g_player_list:get_value ( idx, 'Roll bruteforce' ) and ( self.sides [ idx ] or false ) or false )
						self:override ( idx, ( side and g_player_list:get_value ( idx, 'Roll degree' ) or -g_player_list:get_value ( idx, 'Roll degree' ) ) )
					else
						self:override ( idx, 0 )
					end
				end
			end
		end
	end,

	on_flag_renderer = function ( self, idx )
		if self.unload then
			return
		end

		return g_player_list:get_value ( idx, 'Roll override' ) and g_player_list:get_value ( idx, 'Roll override flag' )
	end,

	on_aim_miss = function ( self, shot )
		if self.unload then
			return
		end

		if not g_player_list:get_value ( shot.target, 'Roll bruteforce' ) or shot.reason ~= '?' then
			return
		end

		self.sides [ shot.target ] = not ( self.sides [ shot.target ] or false )
	end,

	on_shutdown = function ( self )
		self.unload = true
		self.sides = { }

		local e = entity.get_local_player ( )
		if e then
			for _, idx in pairs ( entity.get_players ( true ) ) do
				if idx ~= e and entity.is_alive ( idx )  then
					self:override ( idx, 0 )
				end
			end
		end
	end
}

g_player_list:init ( )
g_roll_resolver:init ( )

client.set_event_callback ( 'net_update_start', function ( )
	g_roll_resolver:on_net_update_start ( )
end )

client.set_event_callback ( 'aim_miss', function ( shot )
	g_roll_resolver:on_aim_miss ( shot )
end )

client.set_event_callback ( 'shutdown', function ( )
	g_roll_resolver:on_shutdown ( )
end )

client.register_esp_flag ( 'ROLL', 255, 255, 255, function ( idx )
	return g_roll_resolver:on_flag_renderer ( idx )
end )