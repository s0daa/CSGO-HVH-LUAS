local g_menu_vars =
{
	main = {
		masterswitch = menu.add_checkbox ( "Main", "Master switch", true ),
		info = menu.add_text ( "Main", "Logging.lua from anty" )
	},

	logging = {
		logs = menu.add_multi_selection ( "Logging", "Logs", { "Aimbot miss", "Aimbot hit", "Aimbot shoot", "Item bought", "Bomb" } ),
		font = menu.add_selection ( "Logging", "Font", { "Arial", "Verdana", "Lucida Console", "Consolas" } ),
		time = menu.add_slider ( "Logging", "Logs time", 1, 30, nil, nil, "s" ),
		scale = menu.add_slider ( "Logging", "Scale", 1, 100, nil, nil, "%" ),
		output = menu.add_multi_selection ( "Logging", "Output", { "Screen", "Console" } )
	}
}

local g_util =
{
	_data =
	{
		_hitboxes =
		{
			[e_hitboxes.HEAD] = "head",
			[e_hitboxes.NECK] = "neck",
			[e_hitboxes.PELVIS] = "pelvis",
			[e_hitboxes.BODY] = "body",
			[e_hitboxes.THORAX] = "thorax",
			[e_hitboxes.CHEST] = "chest",
			[e_hitboxes.UPPER_CHEST] = "upper chest",
			[e_hitboxes.RIGHT_THIGH] = "right thigh",
			[e_hitboxes.LEFT_THIGH] = "left thigh",
			[e_hitboxes.RIGHT_CALF] = "right calf",
			[e_hitboxes.LEFT_CALF] = "left calf",
			[e_hitboxes.RIGHT_FOOT] = "right foot",
			[e_hitboxes.LEFT_FOOT] = "left foot",
			[e_hitboxes.RIGHT_HAND] = "right hand",
			[e_hitboxes.LEFT_HAND] = "left hand",
			[e_hitboxes.RIGHT_UPPER_ARM] = "right upper arm",
			[e_hitboxes.RIGHT_FOREARM] = "right forearm",
			[e_hitboxes.LEFT_UPPER_ARM] = "left upper arm",
			[e_hitboxes.LEFT_FOREARM] = "left forearm"
		},

		_hitgroups =
		{
			[e_hitgroups.GENERIC] = "generic",
			[e_hitgroups.HEAD] = "head",
			[e_hitgroups.CHEST] = "chest",
			[e_hitgroups.STOMACH] = "stomach",
			[e_hitgroups.LEFT_ARM] = "left arm",
			[e_hitgroups.RIGHT_ARM] = "right arm",
			[e_hitgroups.LEFT_LEG] = "left leg",
			[e_hitgroups.RIGHT_LEG] = "right leg",
			[e_hitgroups.NECK] = "neck",
			[e_hitgroups.GEAR] = "gear"
		},

		_fonts =
		{
			[1] = 'Arial',
			[2] = 'Verdana',
			[3] = 'Lucida Console',
			[4] = 'Consolas'
		}
	},

	get_hitbox_string = function ( self, hb )
		return self._data._hitboxes [ hb ] or 'unknown'
	end,

	get_hitgroup_string = function ( self, hg )
		return self._data._hitgroups [ hg ] or 'unknown'
	end,

	font_to_string = function ( self, f )
		return self._data._fonts [ f ] or 'Verdana'
	end,

	lerp_pos = function ( self, first, second, percentage )
		local x = ( second.x - first.x ) * percentage + first.x
		local y = ( second.y - first.y ) * percentage + first.y
		local z = ( second.z - first.z ) * percentage + first.z
		
		return vec3_t ( x, y, z )
	end,

	get_site_name = function ( self, site )
		local bomb_center_a = player_resource.get_prop ( 'm_bombsiteCenterA' )
		local bomb_center_b = player_resource.get_prop ( 'm_bombsiteCenterB' )
		
		local ent = entity_list.get_entity ( site )
		
		local mins = ent:get_prop ( 'm_vecMins' )
		local maxs = ent:get_prop ( 'm_vecMaxs' )
		
		local pos = self:lerp_pos ( mins, maxs, 0.5 )
		
		local dist_a = pos:dist ( bomb_center_a )
		local dist_b = pos:dist ( bomb_center_b )
		
		return dist_b > dist_a and 'A' or 'B'
	end
}

local g_logging =
{
	_data =
	{
		_shots = 0,
		_hits = 0
	},

	_font =
	{
		_font = nil,
		_str = g_util:font_to_string ( g_menu_vars.logging.font:get ( ) ),
		_size = 12
	},
	_logs = { },

	is_enabled_log = function ( self, item ) return g_menu_vars.main.masterswitch:get ( ) and g_menu_vars.logging.logs:get ( item ) end,
	is_enabled_output = function ( self, item ) return g_menu_vars.main.masterswitch:get ( ) and g_menu_vars.logging.output:get ( item ) end,

	on_paint = function ( self )
		local enabled = self:is_enabled_output ( 'Screen' )

		if enabled then
			local scale = math.floor ( ( g_menu_vars.logging.scale:get ( ) / 100 ) * 20 )
			local selected_font = g_util:font_to_string ( g_menu_vars.logging.font:get ( ) )

			if self._font._size ~= scale or self._font._str ~= selected_font or self._font._font == nil then
				self._font._size = scale
				self._font._str = selected_font

				self._font._font = render.create_font ( selected_font, scale, 0, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW )
			end
		end

		local y_offset = 5
		for _, v in pairs ( self._logs ) do
			if globals.real_time ( ) > ( v.b + g_menu_vars.logging.time:get ( ) ) then
				table.remove ( self._logs, _ )
			end

			if enabled then
				local text_size = render.get_text_size ( self._font._font, v.a )

				render.text ( self._font._font, v.a, vec2_t ( 5, y_offset ), color_t ( 240, 240, 240, 255 ) )

				y_offset = y_offset + text_size.y + 3
			end
		end
	end,

	on_shoot = function ( self, shoot )
		self._data._shots = self._data._shots + 1

		if not self:is_enabled_log ( "Aimbot shoot" ) then
			return
		end

		local log = ( '[%d/%d] Shoot%sat %s\'s %s for %i hp' ):format (
			self._data._hits,
			self._data._shots,
			( shoot.safepoint and ' safe ' or ' ' ),
			shoot.player:get_name ( ):lower ( ),
			g_util:get_hitbox_string ( shoot.hitbox ),
			shoot.damage
		)

		if shoot.backtrack_ticks > 1 then
			log = log .. ( ", %d bt" ):format ( shoot.backtrack_ticks )
		end

		table.insert (
			self._logs,
			{
				['a'] = log,
				['b'] = globals.real_time ( )
			}
		)

		if self:is_enabled_output ( 'Console' )	then
			print ( log )
		end
	end,

	on_hit = function ( self, hit )
		self._data._hits = self._data._hits + 1

		if not self:is_enabled_log ( "Aimbot hit" ) then
			return
		end

		local log = ( '[%d/%d] Hit %s\'s %s for %i(%i) (%i remaining) aimed=%s(%i%%)' ):format (
			self._data._hits,
			self._data._shots,
			hit.player:get_name ( ):lower ( ),
			g_util:get_hitgroup_string ( hit.hitgroup ),
			hit.damage,
			hit.aim_damage,
			hit.player:get_prop ( 'm_iHealth' ),
			g_util:get_hitgroup_string ( hit.aim_hitgroup ),
			hit.aim_hitchance
		)

		table.insert (
			self._logs,
			{
				['a'] = log,
				['b'] = globals.real_time ( )
			}
		)

		if self:is_enabled_output ( 'Console' )	then
			print ( log )
		end
	end,

	on_miss = function ( self, miss )
		if not self:is_enabled_log ( "Aimbot miss" ) then
			return
		end

		local log = ( '[%d/%d] Missed %s\'s %s(%i)(%i%%) due to %s ' ):format (
			self._data._hits,
			self._data._shots,
			miss.player:get_name ( ):lower ( ),
			g_util:get_hitgroup_string ( miss.aim_hitgroup ),
			miss.aim_damage,
			miss.aim_hitchance,
			miss.reason_string:lower ( )
		)

		table.insert (
			self._logs,
			{
				['a'] = log,
				['b'] = globals.real_time ( )
			}
		)

		if self:is_enabled_output ( 'Console' )	then
			print ( log )
		end
	end,

	on_event = function ( self, event )
		if event.name == 'item_purchase' and self:is_enabled_log ( "Item bought" ) then
			local ent = entity_list.get_player_from_userid ( event.userid )
			if ent ~= nil and ent:is_enemy ( ) then
				local weapon_str = event.weapon

				if string.len ( weapon_str ) > 7 then
					if weapon_str:sub ( 0, 7 ) == 'weapon_' then
						weapon_str = weapon_str:sub ( 8, weapon_str:len ( ) )
					elseif weapon_str:sub ( 0, 5 ) == 'item_' then
						weapon_str = weapon_str:sub ( 6, weapon_str:len ( ) )
					end
				end

				local log = ( '%s bought %s' ):format (
					ent:get_name ( ):lower ( ),
					weapon_str
				)

				table.insert (
					self._logs,
					{
						['a'] = log,
						['b'] = globals.real_time ( )
					}
				)

				if self:is_enabled_output ( 'Console' )	then
					print ( log )
				end
			end
		elseif event.name == 'bomb_beginplant' and self:is_enabled_log ( "Bomb" ) then
			local ent = entity_list.get_player_from_userid ( event.userid )
			if ent ~= nil then
				local log = ( '%s planting on %s' ):format (
					ent:get_name ( ):lower ( ),
					g_util:get_site_name ( event.site )
				)

				table.insert (
					self._logs,
					{
						['a'] = log,
						['b'] = globals.real_time ( )
					}
				)

				if self:is_enabled_output ( 'Console' )	then
					print ( log )
				end
			end
		elseif event.name == 'bomb_abortplant' and self:is_enabled_log ( "Bomb" ) then
			local ent = entity_list.get_player_from_userid ( event.userid )
			if ent ~= nil then
				local log = ( '%s abort plant on %s' ):format (
					ent:get_name ( ):lower ( ),
					g_util:get_site_name ( event.site )
				)

				table.insert (
					self._logs,
					{
						['a'] = log,
						['b'] = globals.real_time ( )
					}
				)

				if self:is_enabled_output ( 'Console' )	then
					print ( log )
				end
			end
		elseif event.name == 'bomb_planted' and self:is_enabled_log ( "Bomb" ) then
			local ent = entity_list.get_player_from_userid ( event.userid )
			if ent ~= nil then
				local log = ( '%s planted on %s' ):format (
					ent:get_name ( ):lower ( ),
					g_util:get_site_name ( event.site )
				)
				
				table.insert (
					self._logs,
					{
						['a'] = log,
						['b'] = globals.real_time ( )
					}
				)

				if self:is_enabled_output ( 'Console' )	then
					print ( log )
				end
			end
		elseif event.name == 'bomb_defused' and self:is_enabled_log ( "Bomb" ) then
			local ent = entity_list.get_player_from_userid ( event.userid )
			if ent ~= nil then
				local log = ( '%s defused bomb on %s' ):format (
					ent:get_name ( ):lower ( ),
					g_util:get_site_name ( event.site )
				)
				
				table.insert (
					self._logs,
					{
						['a'] = log,
						['b'] = globals.real_time ( )
					}
				)

				if self:is_enabled_output ( 'Console' )	then
					print ( log )
				end
			end
		end
	end
}

callbacks.add ( e_callbacks.PAINT, function ( )
	local ret, res = pcall ( g_logging.on_paint, g_logging )
	if not ret then
		print ( 'Error: ' .. res )
	end
end )

callbacks.add ( e_callbacks.AIMBOT_SHOOT, function ( shoot )
	local ret, res = pcall ( g_logging.on_shoot, g_logging, shoot )
	if not ret then
		print ( 'Error: ' .. res )
	end
end )

callbacks.add ( e_callbacks.AIMBOT_HIT, function ( hit )
	local ret, res = pcall ( g_logging.on_hit, g_logging, hit )
	if not ret then
		print ( 'Error: ' .. res )
	end
end )

callbacks.add ( e_callbacks.AIMBOT_MISS, function ( miss )
	local ret, res = pcall ( g_logging.on_miss, g_logging, miss )
	if not ret then
		print ( 'Error: ' .. res )
	end
end )

callbacks.add ( e_callbacks.EVENT, function ( event )
	local ret, res = pcall ( g_logging.on_event, g_logging, event )
	if not ret then
		print ( 'Error: ' .. res )
	end
end )