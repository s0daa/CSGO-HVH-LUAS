local popup_menu = { }

local font = render.get_default_font( )
local text_size = render.get_text_size( font, 'test' )

local charset = '1234567890qwertyuiopüõasdfghjklöäzxcvbnm,.-=!"#¤%&/()'

-- We use this to identify dropdowns
local generate_random_id = function( )
    local seed = math.randomseed( client.random_float( 0, 1000 ) * 1000 )

    local res = ''
    for i = 0, 10 do
        local place = client.random_int( 1, #charset - 1 )
        res = res .. string.sub( charset, place, place+1 )
    end

    return res
end

local accent_ref = menu.find('misc', 'main', 'config', 'accent color')[2]

math.clamp = function( value, min, max )
    return math.min( math.max( value, min ), max )
end

lerp = function( a, b, t )
    return a + ( b - a ) * t
end

popup_menu.e_menu_types = {
    [ 'CHECKBOX' ] = 0,
    [ 'DROPDOWN' ] = 1,
    [ 'MULTIDROPDOWN' ] = 2,
    [ 'SLIDER' ] = 3,
    [ 'BUTTON' ] = 4,
}

popup_menu.e_menu_open_types = {
    ['DOWN'] = 0,
    ['SIDE'] = 1
}

table.contains = function( table, entry )
    for _, tbl_entry in pairs( table ) do
        if tbl_entry == entry then return true end
    end
    return false
end

popup_menu.menu_t = function( args )
    local self = { }

    self.width = args[ 'width' ] or error( 'Please specify size to menu_t.' )
    self.menu_elements = { }
    self.options = args[ 'interaction_menu' ] or error( 'No interaction menu specified for menu_t.')
    self.visible = args[ 'visible' ] or false
    self.animation = args[ 'animation' ] or {
        last_time = 0,
        time = 1,
    }
    self.max_height = nil--args[ 'max_height' ]

    self.height = 0

    function self:add_button( name, func )
        self.menu_elements[ #self.menu_elements + 1 ] = popup_menu.option_button_t( name, func )
        return self.menu_elements[ #self.menu_elements ]
    end

    function self:add_checkbox( name, default )
        self.menu_elements[ #self.menu_elements + 1 ] = popup_menu.option_checkbox_t( name, default )
        return self.menu_elements[ #self.menu_elements ]
    end

    function self:add_dropdown( name, items, default )
        self.menu_elements[ #self.menu_elements + 1 ] = popup_menu.option_dropdown_t( name, items, default )
        return self.menu_elements[ #self.menu_elements ]
    end

    function self:add_multi_dropdown( name, items, defaults )
        self.menu_elements[ #self.menu_elements + 1 ] = popup_menu.option_multidropdown_t( name, items, defaults )
        return self.menu_elements[ #self.menu_elements ]
    end

    function self:add_slider( name, default, min, max, suffix )
        self.menu_elements[ #self.menu_elements + 1 ] = popup_menu.option_slider_t( name,default, min, max, suffix )
        return self.menu_elements[ #self.menu_elements ]
    end

    function self:show( )
        self.visible = not self.visible
        self.animation.last_time = globals.real_time( )
    end

    function self:render( )
        local reversed = not self.visible

        if ( reversed and ( 1 -  ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time ) ) < 0 ) then return end

        local extra_height = 17
        local height = extra_height + text_size.y

        for i = 1, #self.menu_elements do
            local option = self.menu_elements[ i ]

            if option.visible then
                height = height + option.height
            end
        end

        self.height = height

        local width = self.options.width
        local pos = self.options.pos

        if self.max_height ~= nil and height > self.max_height then
            height = self.max_height
        end

        local alpha = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )
        alpha = math.clamp( alpha, 0, 1 )
        render.push_alpha_modifier( lerp( 0, 1, reversed and ( 1 - alpha ) or alpha ) )
        
        local mask_height = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time ) * height
        mask_height = math.clamp( mask_height, 0, height )


        --render.push_clip( pos, vec2_t( width, height ) )
        render.rect_filled( pos, vec2_t( width, height ), color_t( 0, 0, 0, 255 ), 8 )
        render.rect_filled( pos + vec2_t( 1, 1 ), vec2_t( width - 2, height - 2 ), color_t( 36, 36, 36, 255 ), 8 )

        -- render header and primordial line
        render.rect_filled( pos + vec2_t( 1, 1 ), vec2_t( width - 2, extra_height ), color_t( 46, 46, 46, 255 ), 8 )
        render.rect_filled( pos + vec2_t( 1, 5 ), vec2_t( width - 2, extra_height - 4 ), color_t( 46, 46, 46, 255 ), 0 )

        local acc_c = accent_ref:get( )
        render.line( pos + vec2_t( 1, extra_height ), pos + vec2_t( width - 1, extra_height ), acc_c )

        -- title
        render.text( font, self.options.title, pos + vec2_t( width / 2, text_size.y/2 + 3 ), color_t( 255, 255, 255, 255 ), true )

        local elem_offset = 20
        local render_above = { }
        local selecting_in_dropdown = false
        local selecting_slider = false
        for i = 1, #self.menu_elements do
            local option = self.menu_elements[ i ]

            if option.visible then
                if option.type ~= popup_menu.e_menu_types.DROPDOWN and option.type ~= popup_menu.e_menu_types.MULTIDROPDOWN then
                    option:render( pos + vec2_t( 0, elem_offset ), vec2_t( 5, 5 ), width, ( not selecting_in_dropdown ) and ( not selecting_slider ), acc_c )

                    if option.type == popup_menu.e_menu_types.SLIDER and option.dragging_slider and not selecting_slider then
                        selecting_slider = true
                    end
                else
                    selecting_in_dropdown = selecting_in_dropdown and true or option.open

                    table.insert(render_above, {
                        option = option,
                        offset = elem_offset
                    })
                end

                -- for 1 row elements   
                elem_offset = elem_offset + option.height
            end
        end

        local selected_dropdown_id = nil
        selecting_in_dropdown = false
        for i = 1, #render_above do
            local option = render_above[ i ].option
            selecting_in_dropdown = selecting_in_dropdown and true or option.open
            selected_dropdown_id = selected_dropdown_id and selected_dropdown_id or ( selecting_in_dropdown and option.id or nil ) 
        end

        -- render after handleing menus
        for i = #render_above, 1, -1 do
            local option = render_above[ i ].option
            local offset = render_above[ i ].offset

            local is_clickable = ( not selecting_in_dropdown ) or ( selected_dropdown_id == option.id ) or false

            option:render( pos + vec2_t( 0, offset ), vec2_t( 5, 5 ), width, is_clickable, acc_c )
        end

        if ( not selecting_in_dropdown ) and ( not input.is_mouse_in_bounds( pos, vec2_t( width, height ) ) and input.is_key_pressed( e_keys.MOUSE_LEFT ) ) then
            self:show( )
        end

        render.pop_alpha_modifier( )
    end


    return self
end

popup_menu.option_button_t = function( name, callback )
    -- initialise the object table
    local self = { }

    self.height = 24


    -- give it defined values
    self.name = type( name ) == 'string' and name 
             or error( 
                string.format('Invalid name for option_button_t. Got "%s", expected "string".', type( name ) ) 
             )

    self.state = type( callback ) == 'function' and callback 
              or error(
                string.format('Invalid callback for option_button_t. Got "%s", expected "function".', type( default ) ) 
              )

    self.type = popup_menu.e_menu_types.BUTTON

    -- default visibility is always true
    self.visible = true

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.2,
    }

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click( )
        -- set checkbox value to the inverse of the current default
        if callback ~= nil then
            callback( )
        end

        for _, cb in pairs( self.callbacks ) do
            cb( )
        end
    end

    -- get the value of our checkbox
    function self:get( )
        return self.name
    end

    -- set the value of our checkbox
    function self:set( new_name )
        if not type( new_name ) == 'string' then 
            error( 
                string.format( 'Invalid parameter for option_button_t:set( string ). Got "%s", expected "string".', type( new_name ) )
            )    
        end
        
        self.name = new_name
    end

    function self:set_visible( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_button_t:set_visible( boolean ). Got "%s", expected "boolean".', type( bool ) )
            ) 
        end

        self.visible = bool
    end

    self.callbacks = { }
    function self:register_callback( fn )
        table.insert(
            self.callbacks,
            fn
        )
    end

    self.hovered = false

    function self:render( pos, padding, width, selectable, acc_c  )
        if self.visible then
            local reversed = not self.hovered

            local animation_perc = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )

            animation_perc = math.clamp( animation_perc, 0, 1 )

            animation_perc = reversed and 1 - animation_perc or animation_perc

            local add = math.floor( 15 * animation_perc )

            local button_start = pos + padding
            local button_size = vec2_t( width - 2 * padding.x, 18 )

            render.rect_filled( button_start, button_size, color_t( 45 + add, 45 + add, 45 + add, 255 ), 2 )
            render.rect_filled( button_start + vec2_t( 1, 1 ), button_size - vec2_t( 2, 2 ), color_t( 0, 0, 0, 255 ), 2 )

            render.rect_filled( button_start + vec2_t( 2, 2 ), button_size - vec2_t( 4, 4 ), color_t( 17, 17, 17, 255 ), 3 )

            local text_pos = pos + vec2_t( width / 2 + padding.x, padding.y * 3 )

            render.text( font, self.name, text_pos - vec2_t( 0, 1 ), color_t( 175 + add, 175 + add, 175 + add, 255 ), true )
            
            if  ( selectable ) and 
                ( input.is_mouse_in_bounds( pos + vec2_t( 0, padding.y - 1 ), vec2_t( width, text_size.y ) ) ) then
                if not self.hovered then
                    self.hovered = true
                    self.animation.last_time = globals.real_time( )
                end

                if input.is_key_pressed( e_keys.MOUSE_LEFT ) then
                    self:click( )
                end
            elseif self.hovered then
                self.hovered = false
                self.animation.last_time = globals.real_time( )
            end
        end
    end

    return self
end

popup_menu.option_checkbox_t = function( name, default )
    -- initialise the object table
    local self = { }

    self.height = 20

    self.size_y = 14

    local default_val = default
    if default_val then default_val = 1 else default_val = 0 end

    -- give it defined values
    self.name = type( name ) == 'string' and name 
             or error( 
                string.format('Invalid name for option_checkbox_t. Got "%s", expected "string".', type( name ) ) 
             )

    self.state = type( default ) == 'boolean' and default_val 
              or error(
                string.format('Invalid default state for option_checkbox_t. Got "%s", expected "boolean".', type( default ) ) 
              )

    -- set type to checkbox
    self.type = popup_menu.e_menu_types.CHECKBOX

    -- default visibility is always true
    self.visible = true

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.05,
    }

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click( )
        -- set checkbox value to the inverse of the current default
        self.state = not ( self.state == 1 )

        if #self.callbacks > 0 then
            for _, callback in pairs( self.callbacks ) do
                callback( )
            end
        end

        -- reset checkbox animation states
        self.animation.last_time = globals.real_time( )
    end

    -- get the value of our checkbox
    function self:get( )
        return ( self.state == 1 )
    end

    -- set the value of our checkbox
    function self:set( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_checkbox_t:set( boolean ). Got "%s", expected "boolean".', type( bool ) )
            )    
        end
        
        self.state = bool and 1 or 0
        self.animation.last_time = globals.real_time( )
    end

    function self:set_visible( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_checkbox_t:set_visible( boolean ). Got "%s", expected "boolean".', type( bool ) )
            ) 
        end

        self.visible = bool
    end

    self.callbacks = { }
    function self:register_callback( fn )
        table.insert(
            self.callbacks,
            fn
        )
    end

    function self:render( pos, padding, width, selectable, acc_c  )
        if self.visible then
            local reversed = not self:get( )

            local animation_perc = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )

            if reversed then animation_perc = 1 - animation_perc end

            animation_perc = math.clamp( animation_perc, 0, 1 )
            
            local alpha_option = math.floor( animation_perc * 255 )

            local checkbox_start = pos + padding
            local checkbox_size = vec2_t( 12, 12 )

            render.rect_filled( checkbox_start, checkbox_size, color_t( 50, 50, 50, 255 ), 2 )
            render.rect_filled( checkbox_start + vec2_t( 1, 1 ), checkbox_size - vec2_t( 2, 2 ), color_t( 0, 0, 0, 255 ), 2 )
            local c = color_t( acc_c.r, acc_c.g, acc_c.b, alpha_option )

            render.rect_filled( checkbox_start + vec2_t( 2, 2 ), checkbox_size - vec2_t( 4, 4 ), c, 3 )

            local text_pos = pos + vec2_t( padding.x + 14, padding.y )

            render.text( font, self.name, text_pos - vec2_t( 0, 1 ), color_t( 255, 255, 255, 255 ) )
            
            if  ( selectable ) and 
                ( input.is_mouse_in_bounds( pos + vec2_t( 0, padding.y - 1 ), vec2_t( width, text_size.y ) ) and input.is_key_pressed( e_keys.MOUSE_LEFT ) ) then
                self:set( reversed )
            end
        end
    end

    return self
end

popup_menu.option_dropdown_t = function( name, values, default_selected )
    -- initialise the object table
    local self = { }

    self.height = 36

    -- give it defined values
    self.name = type( name ) == 'string' and name 
             or error( 
                string.format( 'Invalid name for option_dropdown_t. Got "%s", expected "string".', type( name ) ) 
             )

    self.values = type( values ) == 'table' and values 
               or error( 
                string.format( 'Invalid default state for option_dropdown_t. Got "%s", expected "table".', type( values ) ) 
               )

    self.default_selected = default_selected ~= nil and math.clamp( default_selected, 1, #self.values ) or 1
    self.items = { }
    for i, entry in pairs( self.values ) do
        local is_selected = self.default_selected == i

        self.items[ i ] = {
            name = entry,
            selected = is_selected,
        }
    end

    self.id = generate_random_id( )

    -- set type to checkbox
    self.type = popup_menu.e_menu_types.DROPDOWN

    -- default visibility is always true
    self.visible = true

    -- default open state is always false
    self.open = false

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.05,

        name_offset = 0 -- this is for the menu element's name, if the width of our viewport is not big enough, it will scroll on hover
    }

    self.enabled_offset = 0

    local check_index = function( index )
        if type( index ) ~= 'number' then 
            error(
                string.format( 'Invalid parameter for option_dropdown_t:get( index ). Got "%s", expected "number".', type( index ) )
            ) 
        elseif index > #self.items then
            error(
                string.format( 'Invalid index for option_dropdown_t:get( index ). Got "%s", expected "1 .. %s".', index, #self.items )
            ) 
        end
    end

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click( index )
        self.open = not self.open

        -- reset checkbox animation states
        self.animation.last_time = globals.real_time( )
    end

    -- get the value of our checkbox
    function self:get( index )
        check_index( index )

        return self.items[ index ]
    end

    -- set the value of our checkbox
    function self:set( index )
        check_index( index )
        
        -- clean all previous entries
        for _, entry in pairs( self.items ) do
            entry.selected = false
        end

        self.items[ index ].selected = true
    end

    -- return all values
    function self:get_items( )
        return self.items
    end

    function self:set_visible( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_dropdown_t:set_visible( boolean ). Got "%s", expected "boolean".', type( bool ) )
            ) 
        end

        self.visible = bool
    end

    self.callbacks = { }
    function self:register_callback( fn )
        table.insert(
            self.callbacks,
            fn
        )
    end


    function self:render( pos, padding, width, selectable, acc_c  )
        if self.visible then
            local animation_perc = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )

            animation_perc = math.clamp( animation_perc, 0, 1 )
            animation_perc = self.open and animation_perc or 1 - animation_perc

            local alpha_option = math.floor( animation_perc * 255 )

            local text_x_offset = 0
            local text_start = pos + vec2_t( 8, 4 )
            local dropdown_start = text_start + vec2_t( -3, 14 )

            if ( input.is_mouse_in_bounds( text_start, vec2_t( width, text_size.x ) ) ) then
                local text_length = render.get_text_size( font, self.name ).x
                if text_length - width > ( self.animation.name_offset - 8 ) then
                    self.animation.name_offset = self.animation.name_offset + 1
                end
            else
                self.animation.name_offset = math.max( self.animation.name_offset - 1, 0 ) 
            end

            text_start = text_start - vec2_t( self.animation.name_offset, 0 )

            render.push_clip( pos + vec2_t( 0, -3 ), vec2_t( width, 20 ) )
            render.text( font, self.name, text_start, color_t( 255, 255, 255, 255 ) )
            render.pop_clip( )

            local dropdown_size = vec2_t( width - 10, 18 )

            render.rect_filled( dropdown_start, dropdown_size, color_t( 50, 50, 50, 255 ), 2 )
            render.rect_filled( dropdown_start + vec2_t( 1, 1 ), dropdown_size - vec2_t( 2, 2 ), color_t( 0, 0, 0, 255 ), 2 )

            local selected_options = ''
            local items = self:get_items( )
            for i = 1, #items do
                local item = items[ i ]
                if item.selected then
                    selected_options = selected_options .. item.name .. ', '
                end
            end

            selected_options = selected_options == '' and '-' or selected_options:sub( 1, -3 )
            local options_length = render.get_text_size( font, selected_options ).x

            if input.is_mouse_in_bounds( dropdown_start + vec2_t( 5, 3 ), vec2_t( width, 20 ) ) and ( width - 20 - options_length ) < 0 then
                self.enabled_offset = math.min( self.enabled_offset + 0.5, options_length - width + 20 )
            else
                self.enabled_offset = math.max( self.enabled_offset - 1, 0 )
            end

            render.push_clip( dropdown_start + vec2_t( 1, 3 ), vec2_t( width - 13, 20 ) )
            render.text( font, selected_options, dropdown_start + vec2_t( 5 - self.enabled_offset, 3 ), color_t( 180, 180, 180, 255 ) )
            render.pop_clip( )

            if selectable and input.is_key_pressed( e_keys.MOUSE_LEFT ) and input.is_mouse_in_bounds( dropdown_start, dropdown_size ) then
                self:click( )
            end

            local height = math.clamp( 15 * #self.items, 0, 100 ) * animation_perc
            render.push_clip( dropdown_start + vec2_t( 0, 18 ), vec2_t( width - 10, height ) )
            render.rect_filled( dropdown_start + vec2_t( 1, dropdown_size.y ), vec2_t( dropdown_size.x - 2, height ), color_t( 0, 0, 0, alpha_option ), 2 )

            local in_bounds_open = input.is_mouse_in_bounds( dropdown_start, dropdown_size + vec2_t( 0, height ) )
            if self.open and input.is_key_pressed( e_keys.MOUSE_LEFT ) and not in_bounds_open then
                self:click( )
            end

            -- calculate the hovered item mathematically
            self.scrolling_offset = math.clamp( self.scrolling_offset + input.get_scroll_delta( )*4, -15 * #self.items + 100, 0  )

            local hovered_item = in_bounds_open and math.floor( ( input.get_mouse_pos( ).y - dropdown_start.y - dropdown_size.y - self.scrolling_offset ) / 15 ) + 1 or nil
            if self.open and hovered_item ~= nil and hovered_item ~= 0 then
                local item = self.items[ hovered_item ]
                if item ~= nil then
                    local item_pos = dropdown_start + vec2_t( 1, dropdown_size.y + 15 * ( hovered_item - 1 ) + self.scrolling_offset )

                    if input.is_key_pressed( e_keys.MOUSE_LEFT ) and input.is_mouse_in_bounds( item_pos, vec2_t( dropdown_size.x, 15 ) ) then
                        self:set( hovered_item, not item.selected )
                    end
                end
            end

            if self.open then
                for i = 1, #self.items do
                    local item = self.items[ i ]
                    local item_pos = dropdown_start + vec2_t( 1, dropdown_size.y + 15 * ( i - 1 ) )
                    local c = item.selected and color_t( acc_c.r, acc_c.g, acc_c.b, alpha_option ) or color_t( 180, 180, 180, alpha_option )
                    render.text( font, item.name, item_pos + vec2_t( 5, self.scrolling_offset ), c )
                end  
            end
            render.pop_clip( )
        end
    end

    return self
end

popup_menu.option_multidropdown_t = function( name, values, default_selected )
    -- initialise the object table
    local self = { }

    self.height = 36

    -- give it defined values
    self.name = type( name ) == 'string' and name 
             or error( 
                string.format( 'Invalid name for option_dropdown_t. Got "%s", expected "string".', type( name ) ) 
             )

    self.values = type( values ) == 'table' and values 
               or error( 
                string.format( 'Invalid default state for option_dropdown_t. Got "%s", expected "table".', type( values ) ) 
               )
    
    self.default_selected = default_selected and ( type( default_selected ) == 'table' and default_selected 
                                                or error (
                                                    string.format( 'Invalid default values for option_dropdown_t. Got "%s", expected "table".', type( default_selected ) )
                                                ) )
                            or nil

    self.items = { }
    for i, entry in pairs( self.values ) do
        local is_selected = self.default_selected and table.contains( self.default_selected, i ) or false

        self.items[ i ] = {
            name = entry,
            selected = is_selected,
        }
    end

    self.id = generate_random_id( )

    -- set type to checkbox
    self.type = popup_menu.e_menu_types.MULTIDROPDOWN

    -- default visibility is always true
    self.visible = true

    -- default open state is always false
    self.open = false

    -- animation related variables
    self.animation = {
        last_time = 0,
        time = 0.05,

        name_offset = 0 -- this is for the menu element's name, if the width of our viewport is not big enough, it will scroll on hover
    }

    self.enabled_offset = 0

    local check_index_get = function( index )
        if type( index ) ~= 'number' then 
            error(
                string.format( 'Invalid parameter for option_multidropdown_t:get( index ). Got "%s", expected "number".', type( index ) )
            ) 
        elseif index > #self.items then
            error(
                string.format( 'Invalid index for option_multidropdown_t:get( index ). Got "%s", expected "1 .. %s".', index, #self.items )
            ) 
        end
    end

    local check_index_set = function( index )
        if type( index ) ~= 'number' then 
            error(
                string.format( 'Invalid index for option_multidropdown_t:set( index, bool ). Got "%s", expected "number".', type( index ) )
            ) 
        elseif index > #self.items then
            error(
                string.format( 'Invalid index for option_multidropdown_t:set( index, bool ). Got "%s", expected "1 .. %s".', index, #self.items )
            ) 
        end
    end

    -- scrolling offset
    self.scrolling_offset = 0

    function self:click( )
        self.open = not self.open

        -- reset checkbox animation states
        self.animation.last_time = globals.real_time( )
    end

    -- get the value of our checkbox
    function self:get( index )
        check_index_get( index )

        return self.items[ index ]
    end

    -- set the value of our checkbox
    function self:set( index, bool )
        check_index_set( index )
        if type( bool ) ~= 'boolean' then error(
            string.format( 'Invalid bool for option_dropdown_t:set( index, bool ). Got "%s", expected "boolean".', index, #self.items )
        ) end

        if #self.callbacks > 0 then
            for _, callback in pairs( self.callbacks ) do
                callback( )
            end
        end

        self.items[ index ].selected = bool
    end

    -- return all values
    function self:get_items( )
        return self.items
    end

    function self:set_visible( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_dropdown_t:set_visible( boolean ). Got "%s", expected "boolean".', type( bool ) )
            ) 
        end

        self.visible = bool
    end

    self.callbacks = { }
    function self:register_callback( fn )
        table.insert(
            self.callbacks,
            fn
        )
    end


    function self:render( pos, padding, width, selectable, acc_c  )
        if self.visible then
            local animation_perc = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )

            animation_perc = math.clamp( animation_perc, 0, 1 )
            animation_perc = self.open and animation_perc or 1 - animation_perc

            local alpha_option = math.floor( animation_perc * 255 )

            local text_x_offset = 0
            local text_start = pos + vec2_t( 8, 4 )
            local dropdown_start = text_start + vec2_t( -3, 14 )

            if ( input.is_mouse_in_bounds( text_start, vec2_t( width, text_size.x ) ) ) then
                local text_length = render.get_text_size( font, self.name ).x
                if text_length - width > ( self.animation.name_offset - 8 ) then
                    self.animation.name_offset = self.animation.name_offset + 1
                end
            else
                self.animation.name_offset = math.max( self.animation.name_offset - 1, 0 ) 
            end

            text_start = text_start - vec2_t( self.animation.name_offset, 0 )

            render.push_clip( pos + vec2_t( 0, -3 ), vec2_t( width, 20 ) )
            render.text( font, self.name, text_start, color_t( 255, 255, 255, 255 ) )
            render.pop_clip( )

            local dropdown_size = vec2_t( width - 10, 18 )

            render.rect_filled( dropdown_start, dropdown_size, color_t( 50, 50, 50, 255 ), 2 )
            render.rect_filled( dropdown_start + vec2_t( 1, 1 ), dropdown_size - vec2_t( 2, 2 ), color_t( 0, 0, 0, 255 ), 2 )

            local selected_options = ''
            local items = self:get_items( )
            for i = 1, #items do
                local item = items[ i ]
                if item.selected then
                    selected_options = selected_options .. item.name .. ', '
                end
            end

            selected_options = selected_options == '' and '-' or selected_options:sub( 1, -3 )
            local options_length = render.get_text_size( font, selected_options ).x

            if input.is_mouse_in_bounds( dropdown_start + vec2_t( 5, 3 ), vec2_t( width, 20 ) ) and ( width - 20 - options_length ) < 0 then
                self.enabled_offset = math.min( self.enabled_offset + 0.5, options_length - width + 20 )
            else
                self.enabled_offset = math.max( self.enabled_offset - 1, 0 )
            end

            render.push_clip( dropdown_start + vec2_t( 1, 3 ), vec2_t( width - 13, 20 ) )
            render.text( font, selected_options, dropdown_start + vec2_t( 5 - self.enabled_offset, 3 ), color_t( 180, 180, 180, 255 ) )
            render.pop_clip( )

            if selectable and input.is_key_pressed( e_keys.MOUSE_LEFT ) and input.is_mouse_in_bounds( dropdown_start, dropdown_size ) then
                self:click( )
            end

            local height = math.clamp( 15 * #self.items, 0, 100 ) * animation_perc
            render.push_clip( dropdown_start + vec2_t( 0, 18 ), vec2_t( width - 10, height ) )
            render.rect_filled( dropdown_start + vec2_t( 1, dropdown_size.y ), vec2_t( dropdown_size.x - 2, height ), color_t( 0, 0, 0, alpha_option ), 2 )

            local in_bounds_open = input.is_mouse_in_bounds( dropdown_start, dropdown_size + vec2_t( 0, height ) )
            if self.open and input.is_key_pressed( e_keys.MOUSE_LEFT ) and not in_bounds_open then
                self:click( )
            end

            -- calculate the hovered item mathematically
            self.scrolling_offset = math.clamp( self.scrolling_offset + input.get_scroll_delta( )*4, -15 * #self.items + 100, 0  )

            local hovered_item = in_bounds_open and math.floor( ( input.get_mouse_pos( ).y - dropdown_start.y - dropdown_size.y - self.scrolling_offset ) / 15 ) + 1 or nil
            if self.open and hovered_item ~= nil and hovered_item ~= 0 then
                local item = self.items[ hovered_item ]
                if item ~= nil then
                    local item_pos = dropdown_start + vec2_t( 1, dropdown_size.y + 15 * ( hovered_item - 1 ) + self.scrolling_offset )

                    if input.is_key_pressed( e_keys.MOUSE_LEFT ) and input.is_mouse_in_bounds( item_pos, vec2_t( dropdown_size.x, 15 ) ) then
                        self:set( hovered_item, not item.selected )
                    end
                end
            end

            if self.open then
                for i = 1, #self.items do
                    local item = self.items[ i ]
                    local item_pos = dropdown_start + vec2_t( 1, dropdown_size.y + 15 * ( i - 1 ) )
                    local c = item.selected and color_t( acc_c.r, acc_c.g, acc_c.b, alpha_option ) or color_t( 180, 180, 180, alpha_option )
                    render.text( font, item.name, item_pos + vec2_t( 5, self.scrolling_offset ), c )
                end  
            end
            render.pop_clip( )
        end
    end

    return self
end

popup_menu.option_slider_t = function( name, default, min, max, suffix )
    -- initialise the object table
    local self = { }

    self.height = 30

    -- give it defined values
    self.name = type( name ) == 'string' and name 
            or error( 
                string.format( 'Invalid name for option_slider_t. Got "%s", expected "string".', type( name ) ) 
            )

    self.default = type( default ) == 'number' and default 
            or error( 
                string.format( 'Invalid default for option_slider_t. Got "%s", expected "number".', type( default ) ) 
            )

    self.min = type( min ) == 'number' and min 
            or error( 
                string.format( 'Invalid min. value for option_slider_t. Got "%s", expected "number".', type( min ) ) 
            )

    self.max = type( max ) == 'number' and max 
            or error( 
                string.format( 'Invalid max. value for option_slider_t. Got "%s", expected "number".', type( max ) ) 
            )
    
    self.suffix = suffix or ''


    -- check if our min and max are okay, if not then switch them
    if self.max < self.min then 
        local buffer_max = self.max
        self.max = self.min
        self.min = buffer_max
    end

    -- check if default value is between min and max
    self.default = math.clamp( self.default, self.min, self.max )

    self.deep_name = string.format( '%s (%.0f%s)', self.name, self.default, self.suffix )

    -- find the delta of our values
    self.delta = self.max - self.min

    -- if we need the middle bar
    self.needs_middle_bar = self.min < 0 and self.max > 0

    self.lerped_value = self.default

    -- this variable is responsible if we go out of the slider area but are still holding down mouse 1
    self.dragging_slider = false

    self.animation = {
        last_time = 0,
        time = 0.05,

        name_offset = 0
    }

    -- set type to checkbox
    self.type = popup_menu.e_menu_types.SLIDER

    -- default visibility is always true
    self.visible = true

    -- default open state is always false
    self.open = false

    function self:set( new_value )
        if not type( new_value ) == 'number' then error(
            string.format( 'Invalid new_value for option_slider_t:set( new_value ). Got "%s", expected "number"', type( new_value ) )
        ) end

        if #self.callbacks > 0 then
            for _, callback in pairs( self.callbacks ) do
                callback( )
            end
        end

        self.default = new_value
        self.animation.last_time = global_vars.real_time( )
    end

    function self:get( )
        return self.default
    end

    function self:set_visible( bool )
        if not type( bool ) == 'boolean' then 
            error( 
                string.format( 'Invalid parameter for option_slider_t:set_visible( boolean ). Got "%s", expected "boolean".', type( bool ) )
            ) 
        end

        self.visible = bool
    end

    self.callbacks = { }
    function self:register_callback( fn )
        table.insert(
            self.callbacks,
            fn
        )
    end

    function self:render( pos, padding, width, selectable, acc_c  )
        if self.visible then
            local animation_perc = ( ( globals.real_time( ) - self.animation.last_time ) / self.animation.time )

            animation_perc = math.clamp( animation_perc, 0, 1 )
            animation_perc = self.open and animation_perc or 1 - animation_perc

            local alpha_option = math.floor( animation_perc * 255 )

            local text_x_offset = 0
            local text_start = pos + vec2_t( 8, 4 )

            -- check if mouse is i title bounds, if it is, scroll title
            if ( input.is_mouse_in_bounds( text_start, vec2_t( width, text_size.x ) ) ) then
                local text_length = render.get_text_size( font, self.deep_name ).x
                if text_length - width > ( self.animation.name_offset - 8 ) then
                    self.animation.name_offset = self.animation.name_offset + 1
                end
            else
                self.animation.name_offset = math.max( self.animation.name_offset - 1, 0 ) 
            end

            -- render title
            local text_start_ = text_start - vec2_t( self.animation.name_offset, 0 )

            render.push_clip( pos + vec2_t( 0, -3 ), vec2_t( width, 20 ) )
            render.text( font, self.deep_name, text_start_, color_t( 255, 255, 255, 255 ) )
            render.pop_clip( )

            local slider_start = text_start + vec2_t( -3, 14 )
            local slider_border_start = slider_start
            local slider_size = vec2_t( width - 10, 14 )

            render.rect_filled( slider_start + vec2_t( 1, 1 ), slider_size - vec2_t( 2, 4 ), color_t( 0, 0, 0, 255 ), 2 )
            
            -- get how many px correstpond to 1 value
            local slider_width = width - padding.x * 2 - 4
            local px_per_one_step = ( width - padding.x * 2 - 4 ) / self.delta
            local px_to_val = self.delta / width
            -- check if we need the middle bar
            if self.needs_middle_bar then
                local middle_bar_start = slider_start + vec2_t( math.abs( self.min ) * px_per_one_step + 1, 1 )
                local middle_bar_size = vec2_t( 2, slider_size.y - 4 )

                render.rect_filled( middle_bar_start, middle_bar_size, color_t( 50, 50, 50, 255 ) )

                slider_start = middle_bar_start
            end

            self.lerped_value = lerp( self.lerped_value, self.default, 0.1 )

            if selectable and input.is_key_held( e_keys.MOUSE_LEFT ) and ( self.dragging_slider or input.is_mouse_in_bounds( slider_border_start, slider_size ) ) then
                local x_in_slider = input.get_mouse_pos( ).x - slider_start.x + 5

                self.default = math.floor( px_to_val * x_in_slider )

                self.default = math.clamp( self.default, self.min, self.max )

                self.dragging_slider = true
            end

            if not input.is_key_held( e_keys.MOUSE_LEFT ) then
                self.dragging_slider = false
            end

            local bar_value_size_x = 0 - self.lerped_value * -1 * px_per_one_step

            if self.needs_middle_bar then
                if self.lerped_value > 0 then
                    slider_start = slider_start + vec2_t( 2, 0 )
                    render.push_clip( slider_start, vec2_t( math.abs( self.max ) * px_per_one_step, slider_size.y - 2 ) )
                    render.rect_filled( slider_start - vec2_t( 1, -1 ), vec2_t( bar_value_size_x, slider_size.y - 6 ), acc_c, 2 )
                elseif self.lerped_value < 0 then
                    --render.push_clip( slider_start, vec2_t( math.abs( self.min ) * px_per_one_step, slider_size.y - 2 ) )
                    render.push_clip( slider_start - vec2_t( math.abs( self.min ) * px_per_one_step, 0 ), vec2_t( math.abs( self.min ) * px_per_one_step, slider_size.y - 2 ) )
                    render.rect_filled( slider_start + vec2_t( bar_value_size_x + 1, 1 ), vec2_t( -bar_value_size_x + 10, slider_size.y - 6 ), acc_c, 3 )
                end
            else
                render.push_clip( slider_start, vec2_t( ( width - 10 ), slider_size.y - 1 ) )
                if math.floor( self.lerped_value ) > 0 then
                    render.rect_filled( slider_start + vec2_t( 2, 2 ), vec2_t( bar_value_size_x, slider_size.y - 6 ), acc_c, 2 )
                end
            end

            render.pop_clip( )

            render.rect( slider_border_start, slider_size - vec2_t( 0, 3 ), color_t( 50, 50, 50, 255 ), 2 )

            self.deep_name = string.format( '%s (%s%s)', self.name, self.default, self.suffix )
        end
    end

    return self
end

popup_menu.interaction_menu = function( args )
    local self = { }
    self.width = args[ 'width' ] or 100
    self.title = args[ 'title' ] or 'interaction menu'
    self.pos = vec2_t( 0, 0 )
    self.menu_t = popup_menu.menu_t({
        width = self.width,
        interaction_menu = self,
        visible = false,
        animation = {
            last_time = 0,
            time = 0.2,
        },
        max_height = args[ 'max_height' ],
    })

    function self:add_button( name, func )
        return self.menu_t:add_button( name, func )
    end

    function self:add_checkbox( name, default )
        return self.menu_t:add_checkbox( name, default )
    end

    function self:add_dropdown( name, items, default )
        return self.menu_t:add_dropdown( name, items, default )
    end

    function self:add_multi_dropdown( name, items, defaults )
        return self.menu_t:add_multi_dropdown( name, items, defaults )
    end

    function self:add_slider( name, default, min, max, suffix )
        return self.menu_t:add_slider( name, default, min, max, suffix )
    end

    return self
end

popup_menu.create = function( args )
    local self = { }

    self.pos = args[ 'pos' ] or vec2_t( 100, 100 )
    self.size = args[ 'size' ] or vec2_t( 100, 100 )
    self.title = args[ 'title' ] or 'popup menu'
    self.opens_to = args[ 'opens_to' ] or popup_menu.e_menu_open_types.DOWN

    self.interaction_menu = popup_menu.interaction_menu( {
        pos = self.pos,
        max_height = args[ 'max_height' ] or 600
    } )

    function self:add_button( name, func )
        return self.interaction_menu:add_button( name, func )
    end

    function self:add_checkbox( name, default )
        return self.interaction_menu:add_checkbox( name, default )
    end

    function self:add_dropdown( name, items, default )
        return self.interaction_menu:add_dropdown( name, items, default )
    end

    function self:add_multi_dropdown( name, items, defaults )
        return self.interaction_menu:add_multi_dropdown( name, items, defaults )
    end

    function self:add_slider( name, default, min, max, suffix )
        return self.interaction_menu:add_slider( name, default, min, max, suffix )
    end

    self.interaction_menu.width = args[ 'width' ] or 100
    self.custom_render_fn = nil

    if not self.interaction_menu.animation then self.interaction_menu.animation = { } end

    self.difference = vec2_t( 0, 0 )
    self.dragging = false

    function self:set_render_fn( func )
        self.custom_render_fn = func
    end

    self.handlers = { }
    function self:handle_dragging( )
        if not menu.is_open( ) then self.dragging = false return end

        if self.dragging or ( input.is_key_held( e_keys.MOUSE_LEFT ) and input.is_mouse_in_bounds( self.pos, self.size ) ) then
            self.pos = input.get_mouse_pos() - self.difference
            self.dragging = true
        else
            self.difference = input.get_mouse_pos() - self.pos
        end

        if not input.is_key_held( e_keys.MOUSE_LEFT ) then
            self.dragging = false
        end
    end

    function self:get_items( ) 
        return self.interaction_menu.menu_t.menu_elements
    end

    function self:get_option( name )
        local items = self:get_items( )

        for i = 1, #items do
            if items[ i ].name == name then
                return items[ i ]
            end
        end

        return nil
    end

    function self:get_pos( )
        return self.pos
    end

    function self:get_size( )
        return self.size
    end

    function self:handle_interaction_menu( )
        if self.dragging and self.interaction_menu.menu_t.visible then self.interaction_menu.menu_t:show( ) return end

        if not self.dragging and input.is_key_pressed( e_keys.MOUSE_RIGHT ) and input.is_mouse_in_bounds( self.pos, self.size ) then
            if not ( self.interaction_menu.menu_t.visible ) then
                if self.opens_to == popup_menu.e_menu_open_types.DOWN then
                    self.interaction_menu.pos = vec2_t( input.get_mouse_pos( ).x - self.interaction_menu.width / 2, self.pos.y + self.size.y + 5 )

                    local diff = self.interaction_menu.pos.x - self.pos.x 
                    if diff < 0 then
                        self.interaction_menu.pos.x = self.interaction_menu.pos.x - diff
                    else
                        diff = ( self.interaction_menu.pos.x + self.interaction_menu.width ) - ( self.pos.x + self.size.x )
                        if diff > 0 then
                            self.interaction_menu.pos.x = self.interaction_menu.pos.x - diff
                        end
                    end

                    local is_out_of_bounds_x = self.interaction_menu.pos.x + self.interaction_menu.width > render.get_screen_size( ).x
                    if is_out_of_bounds_x then
                        self.interaction_menu.pos.x = render.get_screen_size( ).x - self.interaction_menu.width - 10
                    end

                    local is_out_of_bounds_y = self.interaction_menu.pos.y + self.interaction_menu.menu_t.height > render.get_screen_size( ).y
                    if is_out_of_bounds_y then
                        self.interaction_menu.pos.y = self.pos.y - self.interaction_menu.menu_t.height - 5
                    end


                elseif self.opens_to == popup_menu.e_menu_open_types.SIDE then
                    self.interaction_menu.pos = vec2_t( self.pos.x + self.size.x + 5, self.pos.y )

                    local is_out_of_screen = self.interaction_menu.pos.x + self.interaction_menu.width + 5 > render.get_screen_size( ).x
                    if is_out_of_screen then
                        self.interaction_menu.pos.x = self.pos.x - self.interaction_menu.width - 5
                    end
                end
            end
            
            self.interaction_menu.menu_t:show( )
        end
    end

    function self:draw( )
        self:handle_dragging( )
        self:handle_interaction_menu( )

        if self.custom_render_fn then
            self.custom_render_fn( self )
        end

        self.interaction_menu.menu_t:render( )
    end

    return self
end

return popup_menu