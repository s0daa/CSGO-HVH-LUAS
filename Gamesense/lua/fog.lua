local fog_master_boolean = gui.add_checkbox( "Enable fog", "lua>tab a" )
local fog_color_picker = gui.add_colorpicker( "lua>tab a>enable fog", true, render.color( 255, 255, 255, 255 ) )
local fog_start_slider = gui.add_slider( "Fog start", "lua>tab a", -200, 5000, 1 )
local fog_distance_slider = gui.add_slider( "Fog distance", "lua>tab a", 0, 5000, 1 )
local fog_density_slider = gui.add_slider( "Fog density", "lua>tab a", 0, 100, 1 )

-- yop
if gui.get_config_item( "visuals>misc>various>disable post-processing" ):get_bool( ) == true then error( "Uncheck the disable post-processing checkbox in Visuals>Misc>Various" ) end

function on_paint( )
    if not engine.is_in_game( ) then return end
    
    local color = fog_color_picker:get_color( )

    cvar.fog_override:set_int( fog_master_boolean:get_bool( ) and 1 or 0 )
    cvar.fog_color:set_string( fog_master_boolean:get_bool( ) and string.format( "%s %s %s", color.r, color.g, color.b ) or "0, 0, 0" )
    cvar.fog_start:set_int( fog_master_boolean:get_bool( ) and fog_start_slider:get_int( ) or 0 )
    cvar.fog_end:set_int( fog_master_boolean:get_bool( ) and fog_distance_slider:get_int( ) or 0 )
    cvar.fog_maxdensity:set_float( fog_master_boolean:get_bool( ) and fog_density_slider:get_int( ) / 100 or 0 )
end