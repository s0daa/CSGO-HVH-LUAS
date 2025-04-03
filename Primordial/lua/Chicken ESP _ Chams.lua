local name_font = render.create_font( "Tahoma", 13, 400, e_font_flags.DROPSHADOW )

local name_esp = menu.add_checkbox( "main", "name esp" )
local chams = menu.add_checkbox( "chams", "enabled" )
local chams_color = chams:add_color_picker( "chams color" )
local ignorez = menu.add_checkbox( "chams", "ignore z" )
local wireframe = menu.add_checkbox( "chams", "wireframe" )

local function on_paint( )
    chickens = entity_list.get_entities_by_classid( 36 )

    if name_esp:get( ) then
        for _, chicken in pairs( chickens ) do
            origin = chicken:get_prop( "m_vecOrigin" )

            origin_screen = render.world_to_screen( origin )

            if origin_screen ~= nil then
                render.text( name_font, "chicken", origin_screen, color_t( 255, 255, 255, 255 ) )
            end
        end
    end


    -- chams
    materials.for_each(function(mat)
        if ( string.match( mat:get_name( ), "models/chicken" ) ) then
            mat:set_flag( e_material_flags.IGNOREZ, chams:get( ) and ignorez:get( )  )
            mat:set_flag( e_material_flags.WIREFRAME, chams:get( ) and wireframe:get( )  )
            mat:set_flag( e_material_flags.WIREFRAME, chams:get( ) and wireframe:get( )  )

            if chams:get( ) then
                chams_col = chams_color:get( )
                mat:color_modulate( chams_col.r, chams_col.g, chams_col.b )
            else
                mat:color_modulate( 50, 50, 50 )
            end
        end
    end)
end

callbacks.add( e_callbacks.PAINT, on_paint )