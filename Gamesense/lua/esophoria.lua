local USERNAME = 'scriptleaks'
local BUILD    = 'Boosters'

local ffi = require 'ffi'
local vector = require 'vector'
local http = require 'gamesense/http'
local aa_lib = require 'gamesense/antiaim_funcs'

local multi_references = {
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Yaw' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Yaw jitter' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Body yaw' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Freestanding' ) },
    { ui.reference( 'RAGE', 'Aimbot', 'Double tap' ) },
    { ui.reference( 'AA', 'Other', 'On shot anti-aim' ) },
}

local references = {
    slow_walk = { ui.reference( 'AA', 'Other', 'Slow motion' ) },
    antiaim = {
        ui.reference( 'AA', 'Anti-aimbot angles', 'Pitch' ),
        ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
        ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
        multi_references[ 1 ][ 1 ],
        multi_references[ 1 ][ 2 ],
        multi_references[ 2 ][ 1 ],
        multi_references[ 2 ][ 2 ],
        multi_references[ 3 ][ 1 ],
        multi_references[ 3 ][ 2 ],
        ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
        multi_references[ 4 ][ 1 ],
        multi_references[ 4 ][ 2 ],
        ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
    },
    baim = ui.reference( 'RAGE', 'Aimbot', 'Force body aim' ),
    safepoints = ui.reference('RAGE', 'Aimbot', 'Force safe point' ),
    doubletap = multi_references[ 5 ][ 2 ],
    hideshots = multi_references[ 6 ][ 2 ],
    leg_movement = ui.reference( 'AA', 'Other', 'Leg movement' ),
    fakelag_limit = ui.reference('AA', 'Fake lag', 'Limit'),
    ticks = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks2'),
    fakeduck = ui.reference( 'RAGE', 'Other', 'Duck peek assist' ),
}

local function set_aa_visible( arg )
    for k, v in pairs( references.antiaim ) do
        ui.set_visible( v, arg )
    end
end

client.set_event_callback( "paint_ui", function( )
    if not ui.is_menu_open( ) then
        return
    end

    set_aa_visible( false )
end )

client.set_event_callback( "shutdown", function( )
    set_aa_visible( true )
end )

local COLOR_WHITE = { 255, 255, 255, 255 }
local COLOR_RED = { 255, 50, 50, 255 }
local SCREEN_SIZE = { client.screen_size( ) }

local base64 = {
    key = 'QREWTUYIOPLHJKGFDSAZXCVBNMabcdefghijklmnopqrstuvwxyz2345678901+/',
}

base64.encode = function( data )
    return ((data:gsub(
        '.',
        function(x)
            local r, b = '', x:byte()
            for i = 8, 1, -1 do
                r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and '1' or '0')
            end
            return r
        end
    ) .. '0000'):gsub(
        '%d%d%d?%d?%d?%d?',
        function(x)
            if (#x < 6) then
                return ''
            end
            local c = 0
            for i = 1, 6 do
                c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
            end
            return base64.key:sub(c + 1, c + 1)
        end
    ) .. ({'', '==', '='})[#data % 3 + 1])
end

base64.decode = function( data )
    data = string.gsub(data, '[^' .. base64.key .. '=]', '')
    return (data:gsub(
        '.',
        function(x)
            if (x == '=') then
                return ''
            end
            local r, f = '', (base64.key:find(x) - 1)
            for i = 6, 1, -1 do
                r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
            end
            return r
        end
    ):gsub(
        '%d%d%d?%d?%d?%d?%d?%d?',
        function(x)
            if (#x ~= 8) then
                return ''
            end
            local c = 0
            for i = 1, 8 do
                c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
            end
            return string.char(c)
        end
    ))
end

ffi.cdef[[
    typedef int(__thiscall* get_clipboard_text_count)(void*);
    typedef void(__thiscall* set_clipboard_text)(void*, const char*, int);
    typedef void(__thiscall* get_clipboard_text)(void*, int, const char*, int);
]]

local ffi_funcs = { }

ffi_funcs.data = {
    VGUI_System = ffi.cast( 'void***', client.create_interface( 'vgui2.dll', 'VGUI_System010' ) ),
}

ffi_funcs.get_clipboard_text_count = ffi.cast( 'get_clipboard_text_count', ffi_funcs.data.VGUI_System[ 0 ][ 7 ] )
ffi_funcs.set_clipboard_text_fn = ffi.cast( 'set_clipboard_text', ffi_funcs.data.VGUI_System[ 0 ][ 9 ] )
ffi_funcs.get_clipboard_text_fn = ffi.cast( 'get_clipboard_text', ffi_funcs.data.VGUI_System[ 0 ][ 11 ] )

ffi_funcs.get_clipboard = function( )
    local clipboard_text_length = ffi_funcs.get_clipboard_text_count( ffi_funcs.data.VGUI_System )
    local clipboard_data = ''

    if clipboard_text_length > 0 then
        buffer = ffi.new('char[?]', clipboard_text_length)
        size = clipboard_text_length * ffi.sizeof('char[?]', clipboard_text_length)

        ffi_funcs.get_clipboard_text_fn( ffi_funcs.data.VGUI_System, 0, buffer, size )

        clipboard_data = ffi.string( buffer, clipboard_text_length-1 )
    end

    return clipboard_data
end

ffi_funcs.set_clipboard = function( str )
    ffi_funcs.set_clipboard_text_fn( ffi_funcs.data.VGUI_System, str, str:len( ) )
end

local UI = {
    list = { },
    accent_color = { 100, 80, 255, 255 },
    sections = { 'Anti aim', 'Global' }
}

UI.Push = function( args )
    UI.list[ args.index ] = {
        element = args.element,
        flags = args.flags or 's',
        visible_state = function( )
            if not args.conditions then
                return true
            end
    
            for k, v in pairs( args.conditions ) do
                if not v( ) then
                    return false
                end
            end
    
            return true
        end
    }

    ui.set_callback( UI.list[ args.index ].element, UI.UpdateVisibility )

    UI.UpdateVisibility( )
end

UI.UpdateVisibility = function( )
    for k, v in pairs( UI.list ) do
        ui.set_visible( v.element, v.visible_state( ) )
    end
end

UI.Get = function( index )
    return UI.list[ index ] and ui.get( UI.list[ index ].element )
end

UI.Contains = function( var, val )
    var = UI.Get( var )

    if type( var ) ~= 'table' then
        return false
    end

    for i = 1, #var do
        if var[ i ] == val then
            return true
        end
    end

    return false
end

UI.export = function( )
    local config = { }

    for k, v in pairs( UI.list ) do
        if not string.find( v.flags, 's' ) then
            goto skip
        end

        if string.find( v.flags, 'c' ) then
            config[ k ] = { ui.get( v.element ) }
        else
            config[ k ] = ui.get( v.element )
        end

        ::skip::
    end

    config = json.stringify( config )

    config = 'esophoria_gs' .. config

    config = base64.encode( config )

    ffi_funcs.set_clipboard( config )
end

UI.import = function( )
    local config = ffi_funcs.get_clipboard( )

    if not config then
        return
    end

    config = base64.decode( config )

    local s, e = string.find( config, 'esophoria_gs' )

    if not s or not e then
        return
    end

    config = string.sub( config, e + 1, config:len( ) )

    config = json.parse( config )

    for k, v in pairs( config ) do
        if not UI.list[ k ] then
            goto skip
        end

        if string.find( UI.list[ k ].flags, 'c' ) then
            ui.set( UI.list[ k ].element, unpack( v ) )
        else
            ui.set( UI.list[ k ].element, v )
        end

        ::skip::
    end
end

local helpers = { }

helpers.color_swap = function( strength, color, _color )
    local new_color = { }

    for i = 1, 4 do
        new_color[ i ] = color[ i ] * ( 1 - strength ) + _color[ i ] * strength
    end 

    return new_color
end

helpers.colored_text = function( text, color )
    return ( ('\a%02x%02x%02x%02x%s'):format(
        color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ], text
    ) .. ('\a%02x%02x%02x%02x%s'):format(
        255, 255, 255, 255, ''
    ) )
end

helpers.rounded_box = function( x, y, length, height, rounding, thickness, fill, r, g, b, a )
    local max_rounding = math.min( length, height ) / 2

    rounding = helpers.clamp( rounding, 0, max_rounding )

    local line_start_x, line_start_y = x + rounding, y + rounding
    local line_end_x, line_end_y = x + length - rounding, y + height - rounding

    if fill then
        if line_end_x - line_start_x > 0 then
            renderer.rectangle( line_start_x, y, line_end_x - line_start_x, height, r, g, b, a )
        end

        if line_end_y - line_start_y > 0 then
            renderer.rectangle( x, line_start_y, rounding, line_end_y - line_start_y, r, g, b, a )
            renderer.rectangle( x + length - rounding, line_start_y, rounding, line_end_y - line_start_y, r, g, b, a )
        end

        renderer.circle( x + rounding, y + rounding, r, g, b, a, rounding, 180, 0.25 )
        renderer.circle( x + length - rounding, y + rounding, r, g, b, a, rounding, 90, 0.25 )
        renderer.circle( x + rounding, y + height - rounding, r, g, b, a, rounding, 270, 0.25 )
        renderer.circle( x + length - rounding, y + height - rounding, r, g, b, a, rounding, 0, 0.25 )
    else
        if line_end_x - line_start_x > 0 then
            renderer.rectangle( line_start_x, y, line_end_x - line_start_x, thickness, r, g, b, a )
            renderer.rectangle( line_start_x, y + height - thickness, line_end_x - line_start_x, thickness, r, g, b, a )
        end

        if line_end_y - line_start_y > 0 then
            renderer.rectangle( x, line_start_y, thickness, line_end_y - line_start_y, r, g, b, a )
            renderer.rectangle( x + length - thickness, line_start_y, thickness, line_end_y - line_start_y, r, g, b, a )
        end

        renderer.circle_outline( x + rounding, y + rounding, r, g, b, a, rounding, 180, 0.25, thickness )
        renderer.circle_outline( x + length - rounding, y + rounding, r, g, b, a, rounding, 270, 0.25, thickness )
        renderer.circle_outline( x + rounding, y + height - rounding, r, g, b, a, rounding, 90, 0.25, thickness )
        renderer.circle_outline( x + length - rounding, y + height - rounding, r, g, b, a, rounding, 0, 0.25, thickness )
    end
end

helpers.velocity_2d = function( index )
    local vector_velocity = vector( entity.get_prop( index, 'm_vecVelocity' ) )

    return math.sqrt( math.pow( vector_velocity.x, 2) + math.pow( vector_velocity.y, 2 ) )
end

helpers.check_bit = function( data, bit_num )
    return bit.band( data, bit.lshift( 1, bit_num ) ) ~= 0
end

helpers.is_knife = function( index )
    if index == 41 or index == 42 or index == 59 or ( index >= 500 and index <= 525 ) then
        return true
    end

    return false
end

helpers.clamp = function( val, min, max )
    if val < min then
        return min
    end

    if val > max then
        return max
    end

    return val
end

helpers.normalize_degree = function( deg )
    while deg < -180 do
        deg = deg + 360
    end

    while deg > 180 do
        deg = deg - 360
    end

    return deg
end

local animations = { }

animations.lerp = function( time, a, b )
    return (
        math.abs( a - b ) > 0.01 and
        a * ( 1 - time ) + b * time or
        b
    )
end

animations.linear = function( cur, min, max, speed, to )
    if cur == to then
        return cur
    end

    return helpers.clamp( cur + speed * ( to > cur and 1 or -1 ), min, max )
end

animations.animate = function( index, to, speed, type, init_val, min, max )
    if not animations[ index ] then
        animations[ index ] = init_val

        return
    end

    if type == 'lerp' then
        animations[ index ] = animations.lerp( speed, animations[ index ], to )
    elseif type == 'linear' then
        animations[ index ] = animations.linear( animations[ index ], min, max, speed, to )
    end
end

local ANTIAIM_CONDITIONS     = { 'Global', 'Legit', 'Slow walk', 'Air', 'Air crouch', 'Crouch', 'Stand', 'Move' }
local NATIVE_ANTIAIM_PRESETS = { 'Esophoria', 'Custom' }
local ANTIAIM_PRESETS        = { 'Global', unpack( NATIVE_ANTIAIM_PRESETS ) }

UI.Push( {
    element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Esophoria', UI.accent_color ) .. ' -> tab', UI.sections ),
    index = 'tab',
    flags = ''
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Anti aim', UI.accent_color ) .. ' -> yaw overridings' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'yaw_enable',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' -> manual left' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    index = 'manual_left',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' -> manual right' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    index = 'manual_right',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' -> manual reset' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    index = 'manual_reset',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' -> freestand' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    index = 'freestand',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Anti aim', UI.accent_color ) .. ' -> anti backstab' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'backstab',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Anti aim', UI.accent_color ) .. ' -> desync' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
    },
    index = 'desync_enable',
} )

UI.Push( {
    element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Desync', UI.accent_color ) .. ' -> condition', ANTIAIM_CONDITIONS ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'desync_condition',
} )

for i = 1, #ANTIAIM_CONDITIONS do
    local index =  'desync_' .. ANTIAIM_CONDITIONS[ i ] .. '_'
    local _conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
    }

    UI.Push( {
        element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> preset', i == 1 and NATIVE_ANTIAIM_PRESETS or ANTIAIM_PRESETS ),
        conditions = _conditions,
        index = index .. 'preset',
    } )

    local conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
        function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
    }
    
    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> desync left', 0, 60, 0 ),
        conditions = conditions,
        index = index .. 'desync_left',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> desync right', 0, 60, 0 ),
        conditions = conditions,
        index = index .. 'desync_right',
    } )

    UI.Push( {
        element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> desync jitter' ),
        conditions = conditions,
        index = index .. 'desync_jitter',
    } )

    UI.Push( {
        element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> desync freestand' ),
        conditions = conditions,
        index = index .. 'desync_freestand',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> yaw left', -180, 180, 0 ),
        conditions = conditions,
        index = index .. 'yaw_left',
    } )
    
    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> yaw right', -180, 180, 0 ),
        conditions = conditions,
        index = index .. 'yaw_right',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> yaw jitter', -180, 180, 0 ),
        conditions = conditions,
        index = index .. 'yaw_jitter',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) .. ' -> yaw random', -180, 180, 0 ),
        conditions = conditions,
        index = index .. 'yaw_random',
    } )
end

UI.Push( {
    element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Global', UI.accent_color ) .. ' -> indicators', {
        'Centered', 'Notifications'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
    },
    index = 'indicators',
} )

UI.Push( {
    element = ui.new_color_picker( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Global', UI.accent_color ) .. ' -> indicators color', 255, 255, 255, 255, false ),
    index = 'indicators_color',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Centered' ) or UI.Contains( 'indicators', 'Notifications' ) ) end,
    },
    flags = 'sc'
} )

UI.Push( {
    element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Notifications', UI.accent_color ) .. ' -> triggers', {
        'Hit', 'Miss'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Notifications' ) ) end,
    },
    index = 'indicators_notifications_triggers',
} )

UI.Push( {
    element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Global', UI.accent_color ) .. ' -> export config', UI.export ),
    index = 'export',
    flags = '',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
    }
} )

UI.Push( {
    element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Global', UI.accent_color ) .. ' -> import config', UI.import ),
    index = 'import',
    flags = '',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
    }
} )

ui.set_callback( UI.list[ 'export' ].element, UI.export )
ui.set_callback( UI.list[ 'import' ].element, UI.import )

local centered_indicator = {
    side_wish_fraction = 0,
    side_in_fraction = false,
    build_wish_fraction = 0,
}

centered_indicator.binds = {
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'DT', anim = function( ) return ( ui.get( references.doubletap ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'OS-AA', anim = function( ) return ( ui.get( references.hideshots ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'BAIM', anim = function( ) return ( ui.get( references.baim ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'SP', anim = function( ) return ( ui.get( references.safepoints ) ) end, },
}

client.set_event_callback( 'paint', function( )
    local localplayer = entity.get_local_player( )

    if not localplayer then
        return
    end

    local data = centered_indicator
    local frametime = globals.frametime( )

    local should_draw = UI.Contains( 'indicators', 'Centered' ) and entity.is_alive( localplayer )

    animations.animate( 'centered_fraction', should_draw and 1 or 0, frametime * 12, 'lerp', 0, 0, 1 )

    if animations[ 'centered_fraction' ] == 0 then
        return
    end

    local side    = aa_lib.get_desync( ) > 0 and 1 or 0
    local scoped  = entity.get_prop( localplayer, 'm_bIsScoped' ) ~= 0
    local charged = aa_lib.get_tickbase_shifting( ) > 0

    if data.side_in_fraction and animations[ 'centered_side' ] == data.side_wish_fraction then
        data.side_in_fraction = false
    end

    if not data.side_in_fraction and data.side_wish_fraction ~= side then
        data.side_in_fraction = true
        data.side_wish_fraction = side
    end

    animations.animate( 'centered_side', data.side_wish_fraction, frametime * 6, 'linear', 0, 0, 1 )
    animations.animate( 'centered_scope', scoped and 1 or 0, frametime * 12, 'lerp', 0, 0, 1 )
    animations.animate( 'centered_doubletap', charged and 1 or 0, frametime * 12, 'lerp', 0, 0, 1 )
    animations.animate( 'centered_build', data.build_wish_fraction, frametime * 0.75, 'linear', 1, 0, 1 )

    data.binds[ 1 ].color = helpers.color_swap( animations[ 'centered_doubletap' ], COLOR_RED, COLOR_WHITE )

    local global_alpha = animations[ 'centered_fraction' ]

    local color_active = { ui.get( UI.list[ 'indicators_color' ].element ) }
    local screen_width, screen_height = unpack( SCREEN_SIZE )
    local opposite_scope_fraction = 1 - animations[ 'centered_scope' ]

    local start_position_x = screen_width / 2 + 15 * animations[ 'centered_scope' ]
    local start_position_y = screen_height / 2 + 20

    if true then
        local logotype_text  = 'ESOPHORIA'
        local logotype_flags = '-'

        local logotype_space = string.find( logotype_text, ' ' )

        local logotype_symbols = logotype_text:len( )
        local logotype_middle  = logotype_space or math.floor(
            logotype_symbols / 2
        )

        local color_1 = helpers.color_swap( animations[ 'centered_side' ], COLOR_WHITE, color_active )
        local color_2 = helpers.color_swap( 1 - animations[ 'centered_side' ], COLOR_WHITE, color_active )

        color_1[ 4 ], color_2[ 4 ] = 255 * global_alpha, 255 * global_alpha

        local logotype_hex =
            helpers.colored_text( string.sub( logotype_text, 1, logotype_middle ), color_1 ) ..
            helpers.colored_text( string.sub( logotype_text, logotype_middle + 1, logotype_symbols ), color_2 )

        -- local part_length = logotype_middle
        -- local part_offset = math.floor( ( logotype_middle + 1 ) * animations[ 'centered_side' ] )
        -- local logotype_hex = ''

        -- for i = 1, logotype_symbols do
        --     local offset_start, offset_end = ( i - 1 ) / logotype_symbols, i / logotype_symbols
        --     local color = helpers.color_swap( ( i >= part_offset and i <= part_offset + part_length ) and 1 or 0, COLOR_WHITE, color_active )

        --     color[ 4 ] = 255 * global_alpha

        --     logotype_hex = logotype_hex .. helpers.colored_text( logotype_text:sub( i, i ), color )
        -- end

        local logotype_length, logotype_height = renderer.measure_text( logotype_flags, logotype_text )

        renderer.text( start_position_x - logotype_length / 2 * opposite_scope_fraction, start_position_y, 255, 255, 255, 255 * global_alpha, logotype_flags, nil, logotype_hex )

        start_position_y = start_position_y + logotype_height
    end

    if true then
        if animations[ 'centered_build' ] == 1 or animations[ 'centered_build' ] == 0 then
            data.build_wish_fraction = math.abs( animations[ 'centered_build' ] - 1 )
        end

        local build_text  = 'DEF'
        local build_flags = '-'

        local build_length, build_height = renderer.measure_text( build_flags, build_text )

        renderer.text( start_position_x - build_length / 2 * opposite_scope_fraction, start_position_y, color_active[ 1 ], color_active[ 2 ], color_active[ 3 ], 255 * helpers.clamp( animations[ 'centered_build' ] / 0.25, 0, 1 ) * global_alpha, build_flags, nil, build_text )

        start_position_y = start_position_y + build_height
    end

    -- if UI.Contains( 'misc_indicator_elements', 'Player condition' ) then
    --     local condition_text  = data.conditions[ antiaim.condition.index ]
    --     local condition_flags = alternative_font and '-' or ''

    --     if alternative_font then
    --         condition_text = condition_text:upper( )
    --     end

    --     local condition_length, condition_height = renderer.measure_text( condition_flags, condition_text )

    --     renderer.text( start_position_x - condition_length / 2 * opposite_scope_fraction, start_position_y, 255, 255, 255, 255 * global_alpha, condition_flags, nil, condition_text )

    --     start_position_y = start_position_y + condition_height
    -- end

    local bind_flags = '-'

    for i = 1, #data.binds do
        local v = data.binds[ i ]

        v.fraction = animations.linear( v.fraction, 0, 1, globals.frametime( ) * 8, v.anim( ) and 1 or 0 )

        if v.fraction > 0 then
            local bind_text = v.name

            if alternative_font then
                bind_text = bind_text:upper( )
            end

            local bind_length, bind_height = renderer.measure_text( bind_flags, bind_text )

            renderer.text( start_position_x - bind_length / 2 * opposite_scope_fraction, start_position_y - ( bind_height * ( 1 - v.fraction ) ), v.color[ 1 ], v.color[ 2 ], v.color[ 3 ], v.color[ 4 ] * v.fraction * global_alpha, bind_flags, nil, bind_text )

            start_position_y = start_position_y + bind_height * v.fraction
        end
    end
end )

local notifications = {
    list = { },
    hitgroups = { 'generic', 'head', 'chest', 'stomach', 'left arm', 'right arm', 'left leg', 'right leg', 'neck', '?', 'gear' },
    fired_shots = { },
}

notifications.push = function( text )
    table.insert( notifications.list, 1, {
        text = text,
        fraction = 0,
        time = globals.realtime( ),
    } )
end

client.set_event_callback( 'paint_ui', function( )
    if not UI.Contains( 'indicators', 'Notifications' ) then
        return
    end

    local data = notifications
    local frametime = globals.frametime( )
    local wr, wg, wb, wa = unpack( COLOR_WHITE )
    local r, g, b, a = unpack( { ui.get( UI.list[ 'indicators_color' ].element ) } )
    local text_flags = ''

    local start_position_x, start_position_y = SCREEN_SIZE[ 1 ] / 2, SCREEN_SIZE[ 2 ] * 3 / 4

    for i = 1, #data.list do
        local notify = data.list[ i ]

        if not notify then
            goto continue
        end

        notify.fraction = animations.lerp( frametime * 12, notify.fraction, ( globals.realtime( ) - notify.time < 5 and i < 5 ) and 1 or 0 )

        if notify.fraction == 0 then
            table.remove( data.list, i )

            goto continue
        end

        local text = ' -> ' .. notify.text

        text = helpers.colored_text( 'Esophoria', { r, g, b, 255 * notify.fraction } ) .. helpers.colored_text( text, { wr, wg, wb, wa * notify.fraction } )

        local text_length, text_height = renderer.measure_text( text_flags, text )

        local rounding_px = ( text_height + 4 * 2 ) * 3 / 4

        helpers.rounded_box( start_position_x - text_length / 2 - 8, start_position_y, text_length + 8 * 2, text_height + 4 * 2, rounding_px, 1, true, 0, 0, 0, a * notify.fraction )
        helpers.rounded_box( start_position_x - text_length / 2 - 8, start_position_y, text_length + 8 * 2, text_height + 4 * 2, rounding_px, 1, false, r, g, b, 255 * notify.fraction )
        renderer.text( start_position_x - text_length / 2, start_position_y + 4, wr, wg, wb, wa * notify.fraction, text_flags, nil, text )

        start_position_y = start_position_y + 4 + ( text_height + 4 * 2 ) * notify.fraction

        ::continue::
    end
end )

client.set_event_callback( 'aim_fire', function( shot )
    notifications.fired_shots[ shot.id ] = {
        hitchance = shot.hit_chance,
        hitgroup = shot.hitgroup,
        damage = shot.damage,
        backtrack = shot.backtrack,
    }
end )

client.set_event_callback( 'aim_hit', function( shot )
    if not UI.Contains( 'indicators', 'Notifications' ) or not UI.Contains( 'indicators_notifications_triggers', 'Hit' ) then
        return
    end

    if not notifications.fired_shots[ shot.id ] then
        return
    end

    local wanted = notifications.fired_shots[ shot.id ]

    local hitchance = math.floor( shot.hit_chance )
    local hitgroup = shot.hitgroup
    local damage = shot.damage

    local mismatched = hitgroup ~= wanted.hitgroup
    local killed = entity.get_prop( shot.target, 'm_iHealth' ) <= 0
    local under_dmged = damage < wanted.damage
    local hit = not under_dmged and not mismatched and not killed and not missed

    local name = entity.get_player_name( shot.target )
    local text = ''

    if hit then
        text = string.format( "Hit in %s's %s ( -%shp, %sbt )", name, notifications.hitgroups[ hitgroup + 1 ], damage, wanted.backtrack )
    end

    if under_dmged then
        text = string.format( "Hit under damage in %s's %s ( -%shp, %sbt aimed: %s, %shp, %shc )", name, notifications.hitgroups[ hitgroup + 1 ], damage, wanted.backtrack, notifications.hitgroups[ wanted.hitgroup + 1 ], wanted.damage, hitchance )
    end

    if mismatched then
        text = string.format( "Mismatched at %s's %s ( -%shp, %sbt aimed: %s, %shp, %shc )", name, notifications.hitgroups[ hitgroup + 1 ], damage, wanted.backtrack, notifications.hitgroups[ wanted.hitgroup + 1 ], wanted.damage, hitchance )
    end

    if killed then
        text = string.format( "Killed %s in %s ( -%shp, %sbt, %shc )", name, notifications.hitgroups[ hitgroup + 1 ], damage, wanted.backtrack, hitchance )
    end

    notifications.push( text )

    client.log( text )
end )

client.set_event_callback( 'aim_miss', function( shot )
    if not UI.Contains( 'indicators', 'Notifications' ) or not UI.Contains( 'indicators_notifications_triggers', 'Miss' ) then
        return
    end

    if not notifications.fired_shots[ shot.id ] then
        return
    end

    local wanted = notifications.fired_shots[ shot.id ]
    local name = entity.get_player_name( shot.target )
    local reason = shot.reason == '?' and 'resolver' or shot.reason

    local text = string.format( "Missed shot at %s due to %s ( aimed: %s, %shp, %sbt, %shc )", name, reason, notifications.hitgroups[ wanted.hitgroup + 1 ], wanted.damage, wanted.backtrack, math.floor( wanted.hitchance ) )

    notifications.push( text )

    client.log( text )
end )

local antiaim = { }

antiaim.flags = {
    in_legit = false,
    in_backstab = false,
    in_manual = false,
    in_freestand = false,

    jitter = 1,
    manual_mode = 0,

    index = 0,
    previous_on_ground = false,
}

client.set_event_callback( "setup_command", function( )
    local localplayer = entity.get_local_player( )

    local velocity           = helpers.velocity_2d( localplayer )
    local on_ground          = helpers.check_bit( entity.get_prop( localplayer, "m_fFlags" ), 0 )
    local previous_on_ground = antiaim.flags.previous_on_ground
    local in_air             = not on_ground or not previous_on_ground
    local in_duck            = helpers.check_bit( entity.get_prop( localplayer, "m_fFlags" ), 1 )

    antiaim.flags.previous_on_ground = on_ground

    if antiaim.flags.in_legit then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ 2 ]

        return
    end

    if ui.get( references.slow_walk[ 1 ] ) and ui.get( references.slow_walk[ 2 ] ) and velocity > 5 and not in_air then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ 3 ]

        return
    end

    if in_air then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ in_duck and 5 or 4 ]

        return
    end

    if in_duck then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ 6 ]

        return
    end

    if velocity <= 5 then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ 7 ]

        return
    end

    if velocity > 5 then
        antiaim.flags.index = ANTIAIM_CONDITIONS[ 8 ]

        return
    end
end )

local ANTIAIM_KEYS = { 'preset', 'desync_left', 'desync_right', 'desync_jitter', 'desync_freestand', 'yaw_left', 'yaw_right', 'yaw_jitter', 'yaw_random' }

antiaim.presets = {
    [ 'Esophoria' ] = {
        [ "Legit" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Slow walk" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Air" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Air crouch" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Crouch" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Stand" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
        [ "Move" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestand" ] = false,
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_random" ] = 0,
        },
    }
}

client.set_event_callback( "setup_command", function( cmd )
    if not UI.Get( 'desync_enable' ) then
        return
    end

    if globals.chokedcommands( ) == 0 then
        antiaim.flags.jitter = antiaim.flags.jitter * -1
    end

    local _preset = { }

    for k, v in pairs( ANTIAIM_KEYS ) do
        _preset[ v ] = UI.Get( string.format(
            'desync_%s_%s', antiaim.flags.index, v
        ) )
    end

    if _preset[ 'preset' ] == 'Global' then
        for k, v in pairs( ANTIAIM_KEYS ) do
            _preset[ v ] = UI.Get( string.format(
                'desync_Global_%s', v
            ) )
        end
    end

    local preset = { }

    if _preset[ 'preset' ] == 'Custom' then
        preset = _preset
    else
        for k, v in pairs( ANTIAIM_KEYS ) do
            preset[ v ] = antiaim.presets[ _preset[ 'preset' ] ][ antiaim.flags.index ][ v ] or 1
        end
    end

    local inverter = 1

    if preset[ 'desync_jitter' ] then
        inverter = antiaim.flags.jitter
    end

    local desync_degree = preset[ inverter == -1 and 'desync_left' or 'desync_right' ]

    local yaw_jitter   = preset[ 'yaw_jitter' ] / 2 * antiaim.flags.jitter
    local yaw_random   = client.random_int( math.abs( preset[ 'yaw_random' ] ) * -1, math.abs( preset[ 'yaw_random' ] ) )
    local yaw_manual   = antiaim.flags.in_manual and antiaim.flags.manual_mode * 90 or 0
    local yaw_side     = preset[ inverter == -1 and 'yaw_left' or 'yaw_right' ]
    local yaw_backstab = antiaim.flags.in_backstab and 180 or 0
    local yaw_adding   = yaw_jitter + yaw_random + yaw_manual + yaw_side + yaw_backstab

    yaw_adding = helpers.normalize_degree( yaw_adding )

    ui.set( references.fakelag_limit, ( ui.get( references.hideshots ) and not ui.get( references.fakeduck ) ) and 1 or 15 )
    ui.set( references.antiaim[ 1 ], "Default" )
    ui.set( references.antiaim[ 3 ], ( antiaim.flags.in_manual and not antiaim.flags.in_backstab ) and "Local view" or "At targets" )
    ui.set( references.antiaim[ 5 ], "180" )
    ui.set( references.antiaim[ 6 ], yaw_adding )
    ui.set( references.antiaim[ 8 ], 0 )
    ui.set( references.antiaim[ 9 ], "Static" )
    ui.set( references.antiaim[ 10 ], 60 * inverter )
    --ui.set( references.antiaim[ 11 ], desync_degree )
    ui.set( references.antiaim[ 12 ], false )
end )

antiaim.manuals = {
    active = "none",
    left = false,
    right = false,
    reset = false,
}

client.set_event_callback( "setup_command", function( )
    if not UI.Get( "yaw_enable" ) then
        antiaim.flags.in_manual = false
        antiaim.flags.manual_mode = 0

        return
    end

    ui.set( UI.list[ "manual_left" ].element, "On hotkey" )
    ui.set( UI.list[ "manual_right" ].element, "On hotkey" )
    ui.set( UI.list[ "manual_reset" ].element, "On hotkey" )

    local left, right, reset = UI.Get( "manual_left" ), UI.Get( "manual_right" ), UI.Get( "manual_reset" )

    local left_held, right_held, reset_held = left and antiaim.manuals.left, right and antiaim.manuals.right, reset and antiaim.manuals.reset

    antiaim.manuals.left, antiaim.manuals.back, antiaim.manuals.right, antiaim.manuals.reset = left, back, right, reset

    if left and not left_held then
        antiaim.manuals.active = antiaim.manuals.active == "left" and "none" or "left"
    end

    if right and not right_held then
        antiaim.manuals.active = antiaim.manuals.active == "right" and "none" or "right"
    end

    if reset and not reset_held then
        antiaim.manuals.active = "none"
    end

    antiaim.flags.in_manual = antiaim.manuals.active ~= "none" and not antiaim.flags.in_backstab
    antiaim.flags.manual_mode = antiaim.manuals.active == "left" and -1 or 1
end )

client.set_event_callback( "setup_command", function( )
    if not UI.Get( "yaw_enable" ) then
        antiaim.flags.in_freestand = false

        return
    end

    local freestand = UI.Get( "freestand" ) and not antiaim.flags.in_backstab and not antiaim.flags.in_manual

    antiaim.flags.in_freestand = freestand

end )

client.set_event_callback( "setup_command", function( )
    if not UI.Get( "backstab" ) then
        antiaim.flags.in_backstab = false

        return
    end

    local localplayer = entity.get_local_player( )

    if not localplayer then
        return
    end

    local players = entity.get_all( "CCSPlayer" )
    local local_position = vector( entity.get_prop( localplayer, "m_vecOrigin" ) )
    local_position.z = local_position.z + 35
    local eye_x, eye_y, eye_z = client.eye_position( )

    local should_work = false

    for i = 1, #players do
        local player = players[ i ]

        if not entity.is_enemy( player ) or not entity.is_alive( player ) or entity.is_dormant( player ) or localplayer == player then
            goto skip
        end

        local weapon = entity.get_player_weapon( player )

        if not weapon then
            goto skip
        end

        weapon = entity.get_prop( weapon, "m_iItemDefinitionIndex" )

        if not helpers.is_knife( weapon ) then
            goto skip
        end

        local position = vector( entity.get_prop( player, "m_vecOrigin" ) )

        local distance = local_position:dist( position )

        if distance > 250 then
            goto skip
        end

        should_work = true

        break

        ::skip::
    end

    antiaim.flags.in_backstab = should_work
end )