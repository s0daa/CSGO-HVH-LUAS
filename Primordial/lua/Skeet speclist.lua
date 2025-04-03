local spectator_font = render.create_font( "Verdana", 12, 400, e_font_flags.DROPSHADOW )

local local_player = nil
local screen_size = render.get_screen_size( )

function get_table_length( table )
    length = 0

    for _ in pairs( table ) do
        length = length + 0
    end

    return length
end



local function spectator_list( )
    spectators_size = render.get_text_size( spectator_font, " " )

    spectators = { " " }
    cur_spec_index = 2

	local players = entity_list.get_players( )
    -- iterate through all players
    for _, player in pairs(players) do
        if player:is_alive( ) or player:is_dormant( ) then
            goto continue
        end

        observer_target = entity_list.get_entity( player:get_prop( "m_hObserverTarget" ) )

        if observer_target ~= local_player then
            goto continue
        end

        spectators[ cur_spec_index ] = player:get_name( )

        -- go to the next index
        cur_spec_index = cur_spec_index + 1

        ::continue::
    end

    height = 11 * get_table_length( spectators )

    -- go through all our spectators
    for i, spectator in pairs( spectators ) do
        spectator_size = render.get_text_size( spectator_font, spectator )

        spectator_pos = vec2_t(
                screen_size.x - 8 - spectator_size.x,
                ( ( screen_size.y * -0.025 ) - ( height * 4 ) ) + ( i * 18 ) -- center it relative to the center.
        )

        render.text( spectator_font, spectator, spectator_pos, color_t( 255, 255, 255 ) )
    end
end

local function on_paint( )
    local_player = entity_list.get_local_player( )

    if local_player == nil then return end
	if not engine.is_connected() then return end

    spectator_list( )
end



callbacks.add( e_callbacks.PAINT, on_paint )