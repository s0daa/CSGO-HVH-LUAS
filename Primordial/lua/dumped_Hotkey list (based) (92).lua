local g_font_main = render.create_font( 'Verdana', 12, 300, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW )
local g_font_secondary = render.create_font( 'Small Fonts', 8, 150, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW )

local draggable = ( function( )
    local draggable_mt = { }

    function draggable_mt:drag( )
        if not menu.is_open( ) then
            return
        end

        local mouse_position = input.get_mouse_pos( )
        local is_key_down = input.is_key_held( e_keys.MOUSE_LEFT )

        if not self.is_dragging and is_key_down and input.is_mouse_in_bounds( self:position( ), self:size( ) ) then
            self.is_dragging = true
            self.drag_start = mouse_position - self:position( )
        elseif self.is_dragging and is_key_down then
            self.x:set( mouse_position.x - self.drag_start.x )
            self.y:set( mouse_position.y - self.drag_start.y )
        else
            self.is_dragging = false
        end
    end

    function draggable_mt:position( )
        return vec2_t( self.x:get( ), self.y:get( ) )
    end

    function draggable_mt:size( )
        return vec2_t( self.w, self.h )
    end

    local draggable_index = 1

    local screen_dimensions = render.get_screen_size( )

    return function( size )
        local position_x = menu.add_slider( '\ndrag', ( '\ndrag_%d_x' ):format( draggable_index ), 0, screen_dimensions.x )
        local position_y = menu.add_slider( '\ndrag', ( '\ndrag_%d_y' ):format( draggable_index ), 0, screen_dimensions.y )

        draggable_index = draggable_index + 1

        position_x:set_visible( false )
        position_y:set_visible( false )

        return setmetatable( {
            x = position_x,
            y = position_y,

            w = size.x,
            h = size.y,

            is_dragging = false,
            drag_start = vec2_t( )
        }, {
            __index = draggable_mt
        } )
    end
end )( )

local g_hotkeys = ( function( )
    local hotkey_list = { }

    local add_hotkey = function( ref, name, weapon_config )
        table.insert( hotkey_list, {
            ref = ref,
            name = name,

            weapon_config = weapon_config,
            alpha = 0
        } )
    end

    add_hotkey( menu.find( 'aimbot', 'general', 'aimbot', 'enable', 0 ), 'Rage aimbot' )
    add_hotkey( menu.find( 'aimbot', 'general', 'misc', 'autopeek', 0 ), 'Auto peek' )
    add_hotkey( menu.find( 'aimbot', 'general', 'exploits', 'doubletap', 'enable', 0 ), 'Double tap' )
    add_hotkey( menu.find( 'aimbot', 'general', 'exploits', 'hideshots', 'enable', 0 ), 'Hide shots' )

    for iter, data in ipairs{
        { 'auto', e_ragebot_cfg.AUTO_SNIPER },
        { 'scout', e_ragebot_cfg.SCOUT },
        { 'awp', e_ragebot_cfg.AWP },
        { 'heavy pistols', e_ragebot_cfg.HEAVY_PISTOLS },
        { 'pistols', e_ragebot_cfg.PISTOLS },
        { 'other', e_ragebot_cfg.OTHER }
    } do
        local menu_group, weapon_config = unpack( data )

        add_hotkey( menu.find( 'aimbot', menu_group, 'target overrides', 'force lethal shot', 0 ), 'Lethal shot', weapon_config )
        add_hotkey( menu.find( 'aimbot', menu_group, 'target overrides', 'force min. damage', 0 ), 'Damage override', weapon_config )
        add_hotkey( menu.find( 'aimbot', menu_group, 'target overrides', 'force hitbox', 0 ), 'Force hitboxes', weapon_config )
        add_hotkey( menu.find( 'aimbot', menu_group, 'target overrides', 'force safepoint', 0 ), 'Force safe point', weapon_config )
        add_hotkey( menu.find( 'aimbot', menu_group, 'target overrides', 'force hitchance', 0 ), 'Force hit chance', weapon_config )
    end

    add_hotkey( menu.find( 'antiaim', 'main', 'general', 'enable', 0 ), 'Anti-aim' )
    add_hotkey( menu.find( 'antiaim', 'main', 'general', 'fake duck', 0 ), 'Fake duck' )
    add_hotkey( menu.find( 'antiaim', 'main', 'general', 'lock angle', 0 ), 'Lock angle' )

    add_hotkey( menu.find( 'antiaim', 'main', 'manual', 'invert desync', 0 ), 'Anti-aim inverter' )
    add_hotkey( menu.find( 'antiaim', 'main', 'manual', 'invert body lean', 0 ), 'Roll inverter' )

    add_hotkey( menu.find( 'antiaim', 'main', 'auto direction', 'enable', 0 ), 'Freestanding' )

    add_hotkey( menu.find( 'misc', 'main', 'movement', 'slow walk', 0 ), 'Slow motion' )
    add_hotkey( menu.find( 'misc', 'main', 'movement', 'edge jump', 0 ), 'Edge jump' )
    add_hotkey( menu.find( 'misc', 'main', 'movement', 'sneak', 0 ), 'Sneak' )
    add_hotkey( menu.find( 'misc', 'main', 'movement', 'edge bug helper', 0 ), 'Edgebug' )
    add_hotkey( menu.find( 'misc', 'main', 'movement', 'jump bug', 0 ), 'Jumpbug' )

    add_hotkey( menu.find( 'misc', 'utility', 'nade helper', 'enable', 0 ), 'Helper' )
    add_hotkey( menu.find( 'misc', 'utility', 'nade helper', 'autothrow', 0 ), 'Autothrow' )
    add_hotkey( menu.find( 'misc', 'utility', 'general', 'fire extinguisher', 0 ), 'Fire extinguisher' )
    add_hotkey( menu.find( 'misc', 'utility', 'general', 'freecam', 0 ), 'Freecam' )

    local menu_open_alpha = 0
    local ref_window_toggle = menu.find( 'misc', 'main', 'config', 'window toggle', 0 )

    local key_modes = {
        [ 0 ] = 'TOGGLED',
        [ 1 ] = 'HOLDING',
        [ 2 ] = 'OFF',
    }

    local keybind_sort_fn = function( l, r )
        local left_measured = render.get_text_size( g_font_main, l.name )
        local right_measured = render.get_text_size( g_font_main, r.name )

        return left_measured.x > right_measured.x
    end

    return {
        poll = function( )
            local ret = { }
            local frametime_multiplier = global_vars.frame_time( ) * 8

            if engine.is_connected( ) and engine.is_in_game( ) then
                local rage_config = ragebot.get_active_cfg( )

                for iter, keybind in ipairs( hotkey_list ) do repeat
                    local ref = keybind.ref
                    local mode = key_modes[ ref:get_mode( ) ]

                    if not mode then
                        break
                    end

                    local state = ref:get( )

                    if mode == 'DISABLED' then
                        state = not state
                    end

                    keybind.alpha = ( {
                        [ true ] = math.min( 1, keybind.alpha + frametime_multiplier ),
                        [ false ] = math.max( 0, keybind.alpha - frametime_multiplier )
                    } )[ state ]

                    if keybind.weapon_config and keybind.weapon_config ~= rage_config then
                        break -- I am aware this will result in animation glitches in some scenarios. Unfortunately, I don't give a shit. Cope.
                    end

                    if keybind.alpha <= 0 then
                        break
                    end

                    table.insert( ret, {
                        name = keybind.name,
                        alpha = keybind.alpha,
                        bind = mode,
                    } )
                until true end
            end

            menu_open_alpha = ( {
                [ true ] = math.min( 1, menu_open_alpha + frametime_multiplier ),
                [ false ] = math.max( 0, menu_open_alpha - frametime_multiplier )
            } )[ menu.is_open( ) and #ret == 0 ]

            if menu_open_alpha > 0 then
                table.insert( ret, 1, {
                    name = 'Menu opened',
                    alpha = menu_open_alpha,
                    bind = key_modes[ ref_window_toggle:get_mode( ) ],
                } )
            end

            table.sort( ret, keybind_sort_fn )

            return ret
        end
    }
end )( )

local g_master_switch = menu.add_checkbox( 'Main', 'Hotkey list', true )
local g_accent_color = g_master_switch:add_color_picker( 'Accent', color_t( 0x2e, 0xff, 0x00 ), false )

local keybinds = draggable( vec2_t( 175, 20 ) )
keybinds.alpha = 0

callbacks.add( e_callbacks.PAINT, function( )
    if not g_master_switch:get( ) then
        keybinds.alpha = 0
        return
    end

    local active_binds = g_hotkeys.poll( )
    local frametime_multiplier = global_vars.frame_time( ) * 8

    keybinds.alpha = ( {
        [ true ] = math.max( 0, keybinds.alpha - frametime_multiplier ),
        [ false ] = math.min( 1, keybinds.alpha + frametime_multiplier )
    } )[ #active_binds == 0 ]

    if keybinds.alpha == 0 then
        return
    end

    local accent = g_accent_color:get( )

    local pos = keybinds:position( )
    local size = keybinds:size( )

    render.push_alpha_modifier( 0.75 * keybinds.alpha )

    render.rect( pos, keybinds:size( ) - vec2_t( 1, 1 ), accent, 6 )
    render.triangle_filled( pos + vec2_t( size.x - 15, 5 ), 12, accent, 180 )

    render.pop_alpha_modifier( )

    render.push_alpha_modifier( keybinds.alpha )

    render.rect_filled( pos, size, color_t( 17, 17, 17, 200 ), 6 )

    render.rect_fade( pos + vec2_t( 6, size.y - 1 ), vec2_t( size.x * 0.5 - 6, 1 ), color_t( accent.r, accent.g, accent.b, 0 ), accent, true )
    render.rect_fade( pos + vec2_t( size.x * 0.5, size.y - 1 ), vec2_t( size.x * 0.5 - 6, 1 ), accent, color_t( accent.r, accent.g, accent.b, 0 ), true )

    render.text( g_font_main, 'Active keybinds', pos + vec2_t( 6, 4 ), color_t( 255, 255, 255, 200 ) )

    render.pop_alpha_modifier( )

    pos = pos + vec2_t( 6, size.y + 3 )
    local offset = vec2_t( )

    for iter, data in ipairs( active_binds ) do
        local bind_alpha = math.min( keybinds.alpha, data.alpha )

        render.push_alpha_modifier( bind_alpha )
        render.push_clip( pos + offset, vec2_t( size.x, 13 * bind_alpha ) )

        render.text( g_font_main, data.name, pos + offset, color_t( 255, 255, 255, 200 ) )
        render.text( g_font_secondary, data.bind, pos + vec2_t( size.x - 13 - render.get_text_size( g_font_secondary, data.bind ).x, offset.y + 3 ), color_t( accent.r, accent.g, accent.b, 175 ) )

        render.pop_clip( )
        render.pop_alpha_modifier( )

        offset.y = offset.y + 13 * bind_alpha
    end

    keybinds:drag( )
end )