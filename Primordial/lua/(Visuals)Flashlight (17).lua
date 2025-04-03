local flash_light = menu.add_checkbox( "main", "flash light" )
local flash_light_key = flash_light:add_keybind( "flashlight key" )

function on_net_update( )
    local local_plyr = entity_list.get_local_player( )
    
    if local_plyr == nil then
        return
    end

    effects = local_plyr:get_prop( "m_fEffects" )

    if flash_light:get( ) and flash_light_key:get( ) then
        local_plyr:set_prop( "m_fEffects", bit.bor( effects, 4 ) )
    else
        local_plyr:set_prop( "m_fEffects", bit.band( effects, bit.bnot( 4 ) ) )
    end
end

callbacks.add( e_callbacks.NET_UPDATE, on_net_update )