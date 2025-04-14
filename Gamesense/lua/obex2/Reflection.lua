-- only retards change this links
print('https://discord.gg/b37eKFbkPE <- scriptleaks new server')
-- https://discord.gg/b37eKFbkPE <- scriptleaks new server
local bit = require "bit"
local antiaim_funcs = require("gamesense/antiaim_funcs")
local ffi = require("ffi") or error("Failed to require FFI, please make sure Allow unsafe scripts is enabled!", 2)
local vector = require("vector") or error("missing vector",2)
local base64 = require("gamesense/base64")
local images = require("gamesense/images")
local anti_aim = require('gamesense/antiaim_funcs')
local csgo_weapons = require("gamesense/csgo_weapons")
local clipboard = require("gamesense/clipboard") or error("download clipboard from workshop")
local easing = require("gamesense/easing")
local js = panorama.open()
local api = js.MyPersonaAPI
local name = api.GetName()
local menu = {"AA", "Anti-aimbot angles"}

local void_banner = [[

██████╗ ███████╗███████╗██╗     ███████╗ ██████╗████████╗██╗ ██████╗ ███╗   ██╗║
██╔══██╗██╔════╝██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝██║██╔═══██╗████╗  ██║║
██████╔╝█████╗  █████╗  ██║     █████╗  ██║        ██║   ██║██║   ██║██╔██╗ ██ ║
██╔══██╗██╔══╝  ██╔══╝  ██║     ██╔══╝  ██║        ██║   ██║██║   ██║██║╚██╗██ ╝
██║  ██║███████╗██║     ███████╗███████╗╚██████╗   ██║   ██║╚██████╔╝██║ ╚████
  ═╝  ╚═╝╚══════╝╚═╝     ╚══════╝╚══════╝ ╚═════╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══        
                         welcome Reflection.TECH    
]]
print(void_banner)

local lua_label = ui.new_label(menu[1], menu[2], "Username: \aA4B6FFFF"..name.."")
local lua_label2 = ui.new_label(menu[1], menu[2], "Update Date: \aFF6347FF23/02/05")
local lua_label3 = ui.new_label(menu[1], menu[2], "Version: \aCFF00FF0Alpha")

local USERNAME = sauron_user_data and sauron_user_data.user or '-> Enjoy! '
local BUILD    =  'dev'

local antiaim = { } --lol

local ffi = require 'ffi'
local vector = require 'vector'
local http = require 'gamesense/http'
local aa_lib = require 'gamesense/antiaim_funcs'



local multi_references = {
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Yaw' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Yaw jitter' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Body yaw' ) },
    { ui.reference( 'AA', 'Anti-aimbot angles', 'Freestanding' ) },
    { ui.reference( 'RAGE', 'Other', 'Double tap' ) },
    { ui.reference( 'AA', 'Other', 'On shot anti-aim' ) },
}

local references = {
    slow_walk = { ui.reference( 'AA', 'Other', 'Slow motion' ) },
    antiaim = {
        ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        ui.reference('AA', 'Anti-aimbot angles', 'Yaw base'),
        ui.reference('AA', 'Anti-aimbot angles', 'Roll'),
        multi_references[ 1 ][ 1 ],
        multi_references[ 1 ][ 2 ],
        multi_references[ 2 ][ 1 ],
        multi_references[ 2 ][ 2 ],
        multi_references[ 3 ][ 1 ],
        multi_references[ 3 ][ 2 ],
        ui.reference('AA', 'Anti-aimbot angles', 'Fake yaw limit'),
        ui.reference('AA', 'Anti-aimbot angles', 'Freestanding body yaw'),
        multi_references[ 4 ][ 1 ],
        multi_references[ 4 ][ 2 ],
        ui.reference('AA', 'Anti-aimbot angles', 'Edge yaw'),
        ui.reference( 'AA', 'Anti-aimbot angles', 'Enabled' )
        
    },
    baim = ui.reference( 'RAGE', 'Other', 'Force body aim' ),
    safepoints = ui.reference('RAGE', 'Aimbot', 'Force safe point' ),
    doubletap = multi_references[ 5 ][ 2 ],
    hideshots = multi_references[ 6 ][ 2 ],
    leg_movement = ui.reference( 'AA', 'Other', 'Leg movement' ),
    ticks = ui.reference('MISC', 'Settings', 'sv_maxusrcmdprocessticks'),
    fakeduck = ui.reference( 'RAGE', 'Other', 'Duck peek assist' ),
    menu_color = ui.reference('MISC', 'Settings', 'Menu color'),
}

---------------------- CLAN TAG ----------------------

clantag_array = {"","Grey.lua","Gr","Gre","Grey","Grey","Greyl","Grey.lu","Grey.lua"}
clantag_array_changer = 1
curtimez = 0
to_switch = false

clan_tag = function()


    ui.set_visible(gui.menu.clan_tag,ui.get(gui.menu.lua_enable) and ui.get(gui.menu.lua_tab) == "Misc")

    if ui.get(gui.menu.clan_tag) then
        if clantag_array_changer <= 1 then
            switch = false
        elseif clantag_array_changer >= #clantag_array then
            switch = true
        end

        if switch and curtimez + 0.7 < globals.curtime() then
        	clantag_array_changer = clantag_array_changer - 1
        	curtimez = globals.curtime()
        elseif switch == false and curtimez + 0.7 < globals.curtime() then
            clantag_array_changer = clantag_array_changer + 1
            curtimez = globals.curtime()
        else
            curtimez = globals.curtime()
        end

        if curtimez > globals.curtime() then
            curtimez = globals.curtime()
        end

        client.set_clan_tag(clantag_array[clantag_array_changer])
        to_switch = true

    elseif ui.get(gui.menu.clan_tag) == false and to_switch == true then
        client.set_clan_tag("")
        clantag_array_changer = 1
        curtimez = 1
        to_switch = false
    end
end

----------------------    END   ----------------------

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
    accent_color = { ui.get( references.menu_color ) },
    sections = { 'Anti aim', 'Visuals','Misc', 'Config' }
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

    config = 'Reflection_gs_debug' .. config

    config = base64.encode( config )

    return config

    --ffi_funcs.set_clipboard( config )
end

UI.import = function( from )
    local config = from -- ffi_funcs.get_clipboard( )

    if not config then
        return
    end

    config = base64.decode( config )

    local s, e = string.find( config, 'Reflection_gs_debug' )

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

helpers.text_gradient = function( text, weight, color, _color, inverted )
    local result = ""
    local text_length = text:len( )
    local step = 1 / text_length

    if inverted then
        weight = 1 - weight

        for i = 1, text_length do
            local start = ( i - 1 ) * step

            local wgt = 1 - helpers.clamp( ( weight - start ) / step, 0, 1 )

            local clr = helpers.color_swap( wgt, color, _color )

            result = result .. helpers.colored_text( string.sub( text, i, i ), clr )
        end
    else
        for i = 1, text_length do
            local start = ( i - 1 ) * step

            local wgt = helpers.clamp( ( weight - start ) / step, 0, 1 )

            local clr = helpers.color_swap( wgt, color, _color )

            result = result .. helpers.colored_text( string.sub( text, i, i ), clr )
        end
    end

    return result
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
local NATIVE_ANTIAIM_PRESETS = { 'Tank', 'Custom' }
local ANTIAIM_PRESETS        = { 'Global', unpack( NATIVE_ANTIAIM_PRESETS ) }


ui.new_label( 'AA', 'Anti-aimbot angles', '' .. helpers.colored_text( '                 Reflection', UI.accent_color ) .. '\aFF8C00FF.Tech' )
--ui.new_label( 'AA', 'Anti-aimbot angles', ' ' )--这里换行 为了UI好看

UI.Push( {
    element = ui.new_combobox( 'AA', 'Anti-aimbot angles', '\aFF6347FFFunction page', UI.sections ),
    index = 'tab',
    flags = ''
} )

--ui.new_label( 'AA', 'Anti-aimbot angles', ' ' )--这里换行 为了UI好看

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Manual ', UI.accent_color ) .. ' \aFF8C00FFEnable' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'yaw_enable',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFLeft' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'manual_left',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFRight' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'manual_right',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFReset' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'manual_reset',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFfreestanding' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'freestanding',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFYaw flick' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'yaw_flick',
} )

UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Manual \aBA55D3FFEdge yaw' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
        function( ) return ( UI.Get( 'yaw_enable' ) ) end,
    },
    flags = '',
    index = 'yaw_flick',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Anti Aim Builder', UI.accent_color ) .. ' \aFF8C00FFEnable' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
    },
    index = 'desync_enable',
} )

UI.Push( {
    element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Desync', UI.accent_color ) .. ' \aFF8C00FFCondition[+]', ANTIAIM_CONDITIONS ),
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

    -- UI.Push( {
    --     element = ui.new_label( 'AA', 'Anti-aimbot angles', '  ' .. helpers.colored_text( ANTIAIM_CONDITIONS[ i ], UI.accent_color ) ),
    --     conditions = _conditions,
    --     flags = '',
    --     index = index .. 'text',
    -- } )
    local adding_ = string.rep( ' ', i )
    UI.Push( {
        element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Preset ', UI.accent_color ) .. '\aFF8C00FF<' .. ANTIAIM_CONDITIONS[ i ]:lower( ) .. '>[+]', i == 1 and NATIVE_ANTIAIM_PRESETS or ANTIAIM_PRESETS ),
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
        element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Yaw', UI.accent_color ) .. ' \aFF8C00FFModificators[+]' .. adding_, {
            'Left/right', 'Center', 'Offset', 'Random', 'Sway', 'Step'
        } ),
        conditions = conditions,
        index = index .. 'yaw_modificators',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' left' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Left/right' )  ) end,
        },
        index = index .. 'yaw_left',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' right' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Left/right' )  ) end,
        },
        index = index .. 'yaw_right',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' center' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Center' )  ) end,
        },
        index = index .. 'yaw_jitter',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' offset' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Offset' )  ) end,
        },
        index = index .. 'yaw_offset',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' random' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Random' )  ) end,
        },
        index = index .. 'yaw_random',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' sway' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Sway' )  ) end,
        },
        index = index .. 'yaw_sway',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Yaw', UI.accent_color ) .. ' step' .. adding_, -180, 180, 0 ),
        conditions = {
            function( ) return ( UI.Get( 'tab' ) == UI.sections[ 1 ] ) end,
            function( ) return ( UI.Get( 'desync_enable' ) ) end,
            function( ) return ( UI.Get( 'desync_condition' ) == ANTIAIM_CONDITIONS[ i ] ) end,
            function( ) return ( UI.Get( index .. 'preset' ) == 'Custom' ) end,
            function( ) return ( UI.Contains( index .. 'yaw_modificators', 'Step' )  ) end,
        },
        index = index .. 'yaw_step',
    } )


    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Desync', UI.accent_color ) .. ' \aFF8C00FFLeft[+]' .. adding_, 0, 60, 0 ),
        conditions = conditions,
        index = index .. 'desync_left',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Desync', UI.accent_color ) .. ' \aFF8C00FFRight[+]' .. adding_, 0, 60, 0 ),
        conditions = conditions,
        index = index .. 'desync_right',
    } )

    UI.Push( {
        element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Body', UI.accent_color ) .. ' \aFF8C00FFType[+]' .. adding_, {
            'Static', 'Jitter', 'Sway'
        } ),
        conditions = conditions,
        index = index .. 'body_type',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Body', UI.accent_color ) .. ' \aFF8C00FFLeft[+]' .. adding_, 0, 180, 0 ),
        conditions = conditions,
        index = index .. 'body_left',
    } )

    UI.Push( {
        element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Body', UI.accent_color ) .. ' \aFF8C00FFRight[+]' .. adding_, 0, 180, 0 ),
        conditions = conditions,
        index = index .. 'body_right',
    } )

    UI.Push( {
        element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Desync', UI.accent_color ) .. ' \aFF8C00FFJitter' .. adding_ ),
        conditions = conditions,
        index = index .. 'desync_jitter',
    } )

    UI.Push( {
        element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Desync', UI.accent_color ) .. ' \aFF8C00FFRandom' .. adding_ ),
        conditions = conditions,
        index = index .. 'desync_random',
    } )

    UI.Push( {
        element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Desync', UI.accent_color ) .. ' \aFF8C00FFFreestanding' .. adding_ ),
        conditions = conditions,
        index = index .. 'desync_freestanding',
    } )
end

UI.Push( {
    element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Debug', UI.accent_color ) .. ' \aFF8C00FFindicators', {
        'Centered', 'Notifications', 'Info panel', 'Manual arrows'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
    },
    index = 'indicators',
} )

UI.Push( {
    element = ui.new_color_picker( 'AA', 'Anti-aimbot angles', 'aboba lol', 255, 255, 255, 255, false ),
    index = 'indicators_color',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Centered' ) or UI.Contains( 'indicators', 'Notifications' ) ) end,
    },
    flags = 'sc'
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '->Centered', UI.accent_color ) .. ' \aFF8C00FFAlternative Font' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return UI.Contains( 'indicators', 'Centered' ) end,
    },
    index = 'indicators_font',
} )

UI.Push( {
    element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Windows', UI.accent_color ) .. ' \aFF8C00FFStyle', {
        'Classic', 'Progressive'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Notifications' ) or UI.Contains( 'indicators', 'Info panel' ) ) end,
    },
    index = 'indicators_style',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '*Windows*', UI.accent_color ) .. ' glow' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Notifications' ) or UI.Contains( 'indicators', 'Info panel' ) ) end,
        function( ) return ( UI.Get( 'indicators_style' ) == 'Progressive' ) end,
    },
    index = 'indicators_glow',
} )

UI.Push( {
    element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Notifications', UI.accent_color ) .. ' \aFF8C00FFTriggers', {
        'Hit', 'Miss'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Notifications' ) ) end,
    },
    index = 'indicators_notifications_triggers',
} )

UI.Push( {
    element = ui.new_slider( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Notifications', UI.accent_color ) .. ' \aFF8C00FFRounding', 0, 100, 50 ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
        function( ) return ( UI.Contains( 'indicators', 'Notifications' ) ) end,
    },
    index = 'indicators_notifications_rounding',
} )

UI.Push( {
    element = ui.new_multiselect( 'AA', 'Anti-aimbot angles', helpers.colored_text( '-> Global', UI.accent_color ) .. ' \aFF8C00FFAnimations Breakers', {
        'On ground', 'In air', 'On landing'
    } ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 2 ] ) end,
    },
    index = 'animations_breakers',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Global', UI.accent_color ) .. ' \aFF8C00FFAutomatic Teleport[+]' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
    },
    index = 'teleport_enable',
} )



UI.Push( {
    element = ui.new_hotkey( 'AA', 'Anti-aimbot angles', 'Teleport bind' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
    },
    flags = '',
    index = 'teleport_bind',
} )



UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '*Anti-knife*', UI.accent_color ) .. ' enable' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'backstab',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Global ', UI.accent_color ) .. ' \aFF8C00FFAutomatic Teleport[+]' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
    },
    index = 'teleport_enable',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '*Anti backstab*', UI.accent_color ) .. ' enable' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'backstab',
} )

UI.Push( {
    element = ui.new_checkbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( '[-]Clan Tag', UI.accent_color ) .. ' \aFF8C00FFEnable[+]' ),
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
        function( ) return ( UI.Get( 'desync_enable' ) ) end,
    },
    index = 'backstab',
} )




UI.Push( {
    element = ui.new_label( 'AA', 'Anti-aimbot angles', helpers.colored_text( '\a00FA9AAAImport Settings System', UI.accent_color ) ),
    index = 'local_text',
    flags = '',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 4 ] ) end,
    }
} )

UI.Push( {
    element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Export', UI.accent_color ) .. ' config', UI.export ),
    index = 'export',
    flags = '',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 4 ] ) end,
    }
} )

UI.Push( {
    element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Import', UI.accent_color ) .. ' config', UI.import ),
    index = 'import',
    flags = '',
    conditions = {
        function( ) return ( UI.Get( 'tab' ) == UI.sections[ 4 ] ) end,
    }
} )

ui.set_callback( UI.list[ 'export' ].element, function( )
    local config = UI.export( )

    ffi_funcs.set_clipboard( config )
end )

ui.set_callback( UI.list[ 'import' ].element, function( )
    local config = ffi_funcs.get_clipboard( )

    UI.import( config )
end )


-- Saving lua config
-- local function _onloadcfg( )
--     local config = database.read( 'Reflection-debug-config1' )

--     if not config then
--         return
--     end

--     UI.import( config )
-- end
-- _onloadcfg( )

-- local function _onunloadcfg( )
--     local config = UI.export( )

--     if not config then
--         return
--     end

--     database.write( 'Reflection-debug-config1', config )
-- end
-- client.set_event_callback( 'shutdown', _onunloadcfg )

-- Saving lua config

-- UI.Push( {
--     element = ui.new_label( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Online', UI.accent_color ) ),
--     index = 'server_text',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- local online_configs = {
--     host = '',
-- }

-- online_configs.export = function( )
--     local uuid = '1xj4hk'

--     ffi_funcs.set_clipboard( uuid )

--     client.log( 'Config successfully exported to cloud service' )

--     return uuid
-- end

-- online_configs.import = function( )
--     local config = '' --get(uuid)

--     client.log( 'Config successfully imported from cloud service' )
-- end

-- UI.Push( {
--     element = ui.new_textbox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Config', UI.accent_color ) .. ' key' ),
--     index = 'online_uuid',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- UI.Push( {
--     element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Config', UI.accent_color ) .. ' action', {
--         'None', 'Export', 'Import'
--     } ),
--     index = 'online_action',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- ui.set_callback( UI.list[ 'online_action' ].element, function( self_id )
--     local value = ui.get( self_id )

--     if value == 'Export' then
--         local uuid = online_configs.export( )

--         ui.set( UI.list[ 'online_uuid' ].element, uuid )
--     elseif value == 'Import' then
--         local uuid = UI.Get( 'online_uuid' )

--         if not uuid or uuid == '' then
--             client.error_log( 'Invalid config' )
--         else
--             online_configs.import( uuid )

--             ui.set( UI.list[ 'online_uuid' ].element, '' )
--         end
--     end

--     ui.set( self_id, 'None' )
-- end )

-- local configs = {
--     [ 'list' ] = { },
--     [ 'names' ] = {
--         'Default'
--     },
-- }

-- local function handle_configs( )
--     local offline_configs = database.read( 'Reflection-configs' ) or { }

--     -- if not offline_configs then
--     --     database.write( 'Reflection-debug-configs', { } )
--     -- end

--     for i = 1, #offline_configs do
--         local config_index = offline_configs[ i ]

--         if not config_index or type( config_index ) ~= 'string' then
--             goto skip
--         end

--         local config = database.read( config_index )

--         if not config then
--             goto skip
--         end

--         table.insert( configs[ 'list' ], {
--             [ 'offline' ] = true,
--             [ 'name' ] = config[ 'name' ],
--             [ 'version' ] = config[ 'version' ],
--             [ 'data' ] = config[ 'data' ]
--         } )

--         table.insert( configs[ 'names' ], config[ 'name' ] .. ' - local' )

--         ::skip::
--     end
-- end
-- handle_configs( )

-- UI.Push( {
--     element = ui.new_combobox( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Config', UI.accent_color ) .. ' managment', configs[ 'names' ] ),
--     index = 'config_managment',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- local function _a( )
-- end

-- UI.Push( {
--     element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Copy', UI.accent_color ) .. ' config', _a ),
--     index = 'configs_copy',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- UI.Push( {
--     element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Copy', UI.accent_color ) .. ' config', _a ),
--     index = 'configs_copy',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

-- UI.Push( {
--     element = ui.new_button( 'AA', 'Anti-aimbot angles', helpers.colored_text( 'Load', UI.accent_color ) .. ' config', UI.import ),
--     index = 'import',
--     flags = '',
--     conditions = {
--         function( ) return ( UI.Get( 'tab' ) == UI.sections[ 3 ] ) end,
--     }
-- } )

local centered_indicator = {
    side_wish_fraction = 0,
    side_in_fraction = false,
    build_wish_fraction = 0,
}

centered_indicator.binds = {
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'DT', anim = function( ) return ( ui.get( references.doubletap ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'OS-AA', anim = function( ) return ( ui.get( references.hideshots ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'TP', anim = function( ) return ( UI.Get( "teleport_enable" ) and UI.Get( "teleport_bind" ) ) end, },
    { fraction = 0, color = { 255, 255, 255, 255 }, name = 'YAW', anim = function( ) return ( antiaim.flags.in_freestanding ) end, },
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

    local alternative_font = UI.Get( 'indicators_font' )

    if true then
        local logotype_text  = 'Reflection'
        local logotype_flags = '-'

        if alternative_font then
            logotype_text = logotype_text:lower( )
            logotype_flags = ''
        end

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

        helpers.rounded_box( start_position_x - logotype_length / 2 * opposite_scope_fraction, start_position_y, logotype_length, logotype_height, logotype_height * 3 / 4, 1, true, color_active[ 1 ], color_active[ 2 ], color_active[ 3 ], 255 * 0.2 * global_alpha )
        for i = 1, 8 do
            helpers.rounded_box( start_position_x - logotype_length / 2 * opposite_scope_fraction - i, start_position_y - i, logotype_length + i * 2, logotype_height + i * 2, logotype_height * 3 / 4, 1, false, color_active[ 1 ], color_active[ 2 ], color_active[ 3 ], 255 * ( ( 8 - i ) / 8 ) * 0.2 * global_alpha )
        end

        -- renderer.gradient( start_position_x - logotype_length / 2 * opposite_scope_fraction, start_position_y, logotype_length, logotype_height + 2, color_2[ 1 ], color_2[ 2 ], color_2[ 3 ], color_2[ 4 ] * 0.1, color_1[ 1 ], color_1[ 2 ], color_1[ 3 ], color_1[ 4 ] * 0.1, true )

        renderer.text( start_position_x - logotype_length / 2 * opposite_scope_fraction, start_position_y, 255, 255, 255, 255 * global_alpha, logotype_flags, nil, logotype_hex )

        start_position_y = start_position_y + logotype_height
    end

    if true then
        if animations[ 'centered_build' ] == 1 or animations[ 'centered_build' ] == 0 then
            data.build_wish_fraction = math.abs( animations[ 'centered_build' ] - 1 )
        end

        local build_text  = BUILD:upper( )
        local build_flags = '-'

        if alternative_font then
            build_text = build_text:lower( )
            build_flags = ''
        end

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

    if true then
        local modifier = entity.get_prop( localplayer, "m_flVelocityModifier" )

        animations.animate( 'slowdown', modifier == 1 and 0 or 1, frametime * 12, 'lerp', 0, 0, 1 )

        if animations[ 'slowdown' ] > 0 then
            local slow_text  = 'SLOW: ' .. helpers.colored_text( tostring( math.floor( modifier * 100 ) ) .. '%', { color_active[ 1 ], color_active[ 2 ], color_active[ 3 ], 255 * animations[ 'slowdown' ] * global_alpha } )
            local slow_flags = '-'

            if alternative_font then
                slow_text = slow_text:lower( )
                slow_flags = ''
            end

            local slow_length, slow_height = renderer.measure_text( slow_flags, slow_text )

            renderer.text( start_position_x - slow_length / 2 * opposite_scope_fraction, start_position_y, 255, 255, 255, 255 * animations[ 'slowdown' ] * global_alpha, slow_flags, nil, slow_text )

            start_position_y = start_position_y + slow_height * animations[ 'slowdown' ]
        end
    end


    
    local bind_flags = '-'

    for i = 1, #data.binds do
        local v = data.binds[ i ]

        v.fraction = animations.linear( v.fraction, 0, 1, globals.frametime( ) * 8, v.anim( ) and 1 or 0 )

        if v.fraction > 0 then
            local bind_text = v.name

            if alternative_font then
                bind_text = bind_text:lower( )
                bind_flags = ''
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
    local style = UI.Get( 'indicators_style' )
    local text_flags = ''
    local rounding = UI.Get( 'indicators_notifications_rounding' ) / 100
    local start_position_x, start_position_y = SCREEN_SIZE[ 1 ] / 2, SCREEN_SIZE[ 2 ] * 3 / 4

    for i = 1, #data.list do
        local notify = data.list[ i ]

        if not notify then
            goto continue
        end

        -- local previous_notify = data.list[ i + 1 ]
        -- local anim_lock = false
        -- if previous_notify then
        --     anim_lock = globals.realtime( ) - notify.time > 5 and previous_notify.fraction > 0
        -- end

        notify.fraction = animations.lerp( frametime * 12, notify.fraction, ( globals.realtime( ) - notify.time < 5 and i < 5 ) and 1 or 0 )

        if notify.fraction == 0 then
            table.remove( data.list, i )

            goto continue
        end

        if style == 'Classic' then
            local text = helpers.colored_text( '[Reflection] ', { r, g, b, 255 * notify.fraction } ) .. helpers.colored_text( notify.text, { wr, wg, wb, wa * notify.fraction } )

            local text_length, text_height = renderer.measure_text( text_flags, text )

            local rounding_px = math.floor( text_height * rounding )

            helpers.rounded_box( start_position_x - text_length / 2 - text_height, start_position_y, text_length + text_height * 2, text_height * 2, rounding_px, 1, true, 0, 0, 0, a * notify.fraction )

            helpers.rounded_box( start_position_x - text_length / 2 - text_height, start_position_y, text_length + text_height * 2, text_height * 2, rounding_px, 1, false, r, g, b, 255 * notify.fraction )
            renderer.text( start_position_x - text_length / 2, start_position_y + text_height / 2, wr, wg, wb, wa * notify.fraction, text_flags, nil, text )

            start_position_y = start_position_y + 4 + ( text_height * 2 ) * notify.fraction
        elseif style == 'Progressive' then
            local text = ' -> ' .. notify.text

            text = helpers.colored_text( 'Reflection', { r, g, b, 255 * notify.fraction } ) .. helpers.colored_text( text, { wr, wg, wb, wa * notify.fraction } )

            local text_length, text_height = renderer.measure_text( text_flags, text )

            local rounding_px = math.floor( ( text_height + 4 ) / 2 * rounding )

            if UI.Get( 'indicators_glow' ) then
                for i = 1, 8 do
                    helpers.rounded_box( start_position_x - text_length / 2 - 8 - i, start_position_y - i, text_length + 8 * 2 + i * 2, text_height + 4 * 2 + i * 2, rounding_px, 1, false, r, g, b, 255 * ( ( 8 - i ) / 8 ) * 0.2 * notify.fraction )
                end
            end

            helpers.rounded_box( start_position_x - text_length / 2 - 8, start_position_y, text_length + 8 * 2, text_height + 4 * 2, rounding_px, 1, true, r * 0.75, g * 0.75, b * 0.75, 50 * notify.fraction )
            -- renderer.blur( start_position_x - text_length / 2 - 8, start_position_y, text_length + 8 * 2, text_height + 4 * 2 )

            helpers.rounded_box( start_position_x - text_length / 2 - 8, start_position_y, text_length + 8 * 2, text_height + 4 * 2, rounding_px, 1, false, r, g, b, 255 * notify.fraction )
            renderer.text( start_position_x - text_length / 2, start_position_y + 4, wr, wg, wb, wa * notify.fraction, text_flags, nil, text )

            start_position_y = start_position_y + 4 + ( text_height + 4 * 2 ) * notify.fraction
        end

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

local info_panel = {
    anim_cache = 1,
    render_position = { 10, SCREEN_SIZE[ 2 ] / 2 },
    header = 'Reflection',
    header_margin = 4,
    header_cache = 1,
    header_invert = false,
    counter = 0,
}

info_panel.data = {
    [ 'Username' ] = USERNAME,
    [ 'Build' ] = BUILD,
}

info_panel.render_order_map = {
    'Username', 'Build'
}

info_panel.alpha_anims = {
    ['Username'] = false,
    ['Build'] = true
}

client.set_event_callback( 'paint_ui', function( )
    if not UI.Contains( 'indicators', 'Info panel' ) then
        return
    end

    animations.animate( 'info_panel', info_panel.anim_cache, globals.frametime( ) * 0.75, 'linear', 1, 0, 1 )

    if animations[ 'info_panel' ] == 1 or animations[ 'info_panel' ] == 0 then
        info_panel.anim_cache = math.abs( animations[ 'info_panel' ] - 1 )
    end

    local r, g, b, a = unpack( { ui.get( UI.list[ 'indicators_color' ].element ) } )
    local anim_alpha = helpers.clamp( animations[ 'info_panel' ] / 0.25, 0, 1 )

    local header_size = { renderer.measure_text( '', info_panel.header ) }

    animations.animate( 'header_anim', info_panel.header_cache, globals.frametime( ) * 2.5, 'lerp', 0, 0, 1 )

    if animations[ 'header_anim' ] == 1 or animations[ 'header_anim' ] == 0 then
        info_panel.header_cache = 1 - info_panel.header_cache
        info_panel.counter = info_panel.counter + 1

        if info_panel.counter % 3 == 0 then
            info_panel.header_invert = not info_panel.header_invert
        end
    end

    info_panel.header = helpers.text_gradient( 'Reflection ' .. BUILD:lower( ), animations[ 'header_anim' ], COLOR_WHITE, { r, g, b, 255 }, info_panel.header_invert )

    local gap = 10
    local text_size = {
        gap,
        header_size[ 2 ] + info_panel.header_margin,
    }

    local highest = {
        prefix = 0,
        value = 0,
    }
    local sizes = { }

    for k, v in pairs( info_panel.data ) do
        local prefix_size, value_size = { renderer.measure_text( '', k ) }, { renderer.measure_text( '', v ) }
        sizes[ k ] = { prefix_size, value_size }

        if prefix_size[ 1 ] > highest.prefix then
            highest.prefix = prefix_size[ 1 ]
        end

        if value_size[ 1 ] > highest.value then
            highest.value = value_size[ 1 ]
        end

        text_size[ 2 ] = text_size[ 2 ] + math.max( prefix_size[ 2 ], value_size[ 2 ] )
    end

    text_size[ 1 ] = text_size[ 1 ] + highest.prefix + highest.value

    local render_position = {
        info_panel.render_position[ 1 ],
        info_panel.render_position[ 2 ] - text_size[ 2 ] / 2
    }

    local style = UI.Get( 'indicators_style' )

    local padding = style == 'Classic' and 8 or 4
    local rounding_px = ( math.min( text_size[ 1 ], text_size[ 2 ] ) + padding * 2 ) * ( style == 'Classic' and 1 / 4 or 1 / 6 )

    if style == 'Progressive' then
        if UI.Get( 'indicators_glow' ) then
            for i = 1, 8 do
                helpers.rounded_box( render_position[ 1 ] - i, render_position[ 2 ] - i, text_size[ 1 ] + padding * 2 + i * 2, text_size[ 2 ] + padding * 2 + i * 2, rounding_px, 1, false, r, g, b, 255 * ( ( 8 - i ) / 8 ) * 0.2 )
            end
        end

        helpers.rounded_box( render_position[ 1 ], render_position[ 2 ], text_size[ 1 ] + padding * 2, text_size[ 2 ] + padding * 2, rounding_px, 1, true, r * 0.75, g * 0.75, b * 0.75, 50 )
        -- renderer.blur( render_position[ 1 ], render_position[ 2 ], text_size[ 1 ] + padding * 2, text_size[ 2 ] + padding * 2 )
    elseif style == 'Classic' then
        helpers.rounded_box( render_position[ 1 ], render_position[ 2 ], text_size[ 1 ] + padding * 2, text_size[ 2 ] + padding * 2, rounding_px, 1, true, 10, 10, 10, a )
        helpers.rounded_box( render_position[ 1 ], render_position[ 2 ], text_size[ 1 ] + padding * 2, text_size[ 2 ] + padding * 2, rounding_px, 1, false, r, g, b, 255 )
    end

    helpers.rounded_box( render_position[ 1 ], render_position[ 2 ], text_size[ 1 ] + padding * 2, text_size[ 2 ] + padding * 2, rounding_px, 1, false, r, g, b, 255 )

    renderer.text( render_position[ 1 ] + padding + text_size[ 1 ] / 2 - header_size[ 1 ] / 2, render_position[ 2 ] + padding, COLOR_WHITE[ 1 ], COLOR_WHITE[ 2 ], COLOR_WHITE[ 3 ], 255, '', nil, info_panel.header )

    local adding = header_size[ 2 ] + info_panel.header_margin
    for i = 1, #info_panel.render_order_map do
        local k, v = info_panel.render_order_map[ i ], info_panel.data[ info_panel.render_order_map[ i ] ]

        local height = math.max( sizes[ k ][ 1 ][ 2 ], sizes[ k ][ 2 ][ 2 ] )

        renderer.text( render_position[ 1 ] + padding, render_position[ 2 ] + padding + adding, COLOR_WHITE[ 1 ], COLOR_WHITE[ 2 ], COLOR_WHITE[ 3 ], 255, '', nil, k )
        renderer.text( render_position[ 1 ] + padding + highest.prefix + gap, render_position[ 2 ] + padding + adding, r, g, b, info_panel.alpha_anims[ k ] and anim_alpha * 255 or 255, '', nil, v )

        adding = adding + height
    end
end )

antiaim.flags = {
    in_legit = false,
    in_backstab = false,
    in_manual = false,
    in_freestanding = false,

    jitter = 1,
    step = 0,
    manual_mode = 0,

    index = 0,
    previous_on_ground = false,
    last_landing_time = 0,
}

client.set_event_callback( "setup_command", function( )
    local localplayer = entity.get_local_player( )

    local velocity           = helpers.velocity_2d( localplayer )
    local on_ground          = helpers.check_bit( entity.get_prop( localplayer, "m_fFlags" ), 0 )
    local previous_on_ground = antiaim.flags.previous_on_ground
    local in_air             = not on_ground or not previous_on_ground
    local in_duck            = helpers.check_bit( entity.get_prop( localplayer, "m_fFlags" ), 1 )

    if on_ground and not previous_on_ground then
        antiaim.flags.last_landing_time = globals.realtime( )
    end

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

local ANTIAIM_KEYS = { 'preset', 'desync_left', 'desync_right', 'body_type', 'body_left', 'body_right', 'desync_jitter', 'desync_random', 'desync_freestanding', 'yaw_modificators', 'yaw_left', 'yaw_right', 'yaw_jitter', 'yaw_offset', 'yaw_random', 'yaw_sway', 'yaw_step' }

antiaim.presets = {
    [ 'Tank' ] = {
        [ "Legit" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 25,
            [ "body_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_offset" ] = 0,
            [ "yaw_random" ] = 0,
        },
        [ "Slow walk" ] = {
            [ "desync_left" ] = 38,
            [ "desync_right" ] = 41,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 67,
            [ "body_right" ] = 53,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_offset" ] = 0,
            [ "yaw_random" ] = 0,
        },
        [ "Air" ] = {
            [ "desync_left" ] = 39,
            [ "desync_right" ] = 39,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 44,
            [ "body_right" ] = 43,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 46,
            [ "yaw_offset" ] = 9,
            [ "yaw_random" ] = 1,
        },
        [ "Air crouch" ] = {
            [ "desync_left" ] = 24,
            [ "desync_right" ] = 22,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 45,
            [ "body_right" ] = 45,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = -25,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 5,
            [ "yaw_offset" ] = 25,
            [ "yaw_random" ] = 0,
        },
        [ "Crouch" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 25,
            [ "body_right" ] = 25,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 55,
            [ "yaw_offset" ] = 0,
            [ "yaw_random" ] = 0,
        },
        [ "Stand" ] = {
            [ "desync_left" ] = 45,
            [ "desync_right" ] = 25,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 50,
            [ "body_right" ] = 50,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = -10,
            [ "yaw_right" ] = 1,
            [ "yaw_jitter" ] = 28,
            [ "yaw_offset" ] = 10,
            [ "yaw_random" ] = 0,
        },
        [ "Move" ] = {
            [ "desync_left" ] = 25,
            [ "desync_right" ] = 25,
            [ "body_type" ] = 'Static',
            [ "body_left" ] = 30,
            [ "body_right" ] = 30,
            [ "desync_jitter" ] = true,
            [ "desync_freestanding" ] = false,
            [ "yaw_modificators" ] = { 'Left/right', 'Center', 'Offset', 'Random' },
            [ "yaw_left" ] = 0,
            [ "yaw_right" ] = 0,
            [ "yaw_jitter" ] = 48,
            [ "yaw_offset" ] = 14,
            [ "yaw_random" ] = 2,
        },
    }
}

function table.has( tbl, arg )
    for k, v in ipairs( tbl ) do
        if v == arg then
            return true 
        end
    end
end

client.set_event_callback( "setup_command", function( cmd )
    if not UI.Get( 'desync_enable' ) then
        return
    end

    if globals.chokedcommands( ) == 0 then
        antiaim.flags.jitter = antiaim.flags.jitter * -1
        antiaim.flags.random_jitter = client.random_int( 0, 1 ) == 1 and 1 or -1
        antiaim.flags.step = antiaim.flags.step >= 1 and 0 or antiaim.flags.step + 1 / 5
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

    if preset[ 'desync_random' ] then
        inverter = antiaim.flags.random_jitter
    end

    local desync_degree = preset[ inverter == -1 and 'desync_left' or 'desync_right' ] * ( preset[ 'body_type' ] == 'Sway' and animations[ 'antiaim_sway' ] or 1 )

    if animations[ 'antiaim_sway' ] == 1 then
        animations[ 'antiaim_sway' ] = 0
    end

    animations.animate( 'antiaim_sway', 1, 0.1, 'lerp', 0, 0, 1 )

    local yaw_step     = ( table.has( preset[ 'yaw_modificators' ], 'Step' ) and ( preset[ 'yaw_step' ] or 0 ) * antiaim.flags.step or 0 ) * antiaim.flags.jitter
    local yaw_sway     = table.has( preset[ 'yaw_modificators' ], 'Sway' ) and ( preset[ 'yaw_sway' ] * animations[ 'antiaim_sway' ] ) or 0
    local yaw_offset   = table.has( preset[ 'yaw_modificators' ], 'Offset' ) and ( antiaim.flags.jitter == 1 and preset[ 'yaw_offset' ] or 0 ) or 0
    local yaw_jitter   = table.has( preset[ 'yaw_modificators' ], 'Center' ) and ( preset[ 'yaw_jitter' ] / 2 * antiaim.flags.jitter ) or 0
    local yaw_random   = table.has( preset[ 'yaw_modificators' ], 'Random' ) and ( client.random_int( math.abs( preset[ 'yaw_random' ] ) * -1, math.abs( preset[ 'yaw_random' ] ) ) ) or 0
    local yaw_manual   = antiaim.flags.in_manual and antiaim.flags.manual_mode * 90 or 0
    local yaw_side     = table.has( preset[ 'yaw_modificators' ], 'Left/right' ) and preset[ inverter == -1 and 'yaw_left' or 'yaw_right' ] or 0
    local body_yaw     = preset[ inverter == -1 and 'body_left' or 'body_right' ]
    local yaw_backstab = antiaim.flags.in_backstab and 180 or 0
    local yaw_adding   = yaw_jitter + yaw_random + yaw_manual + yaw_side + yaw_backstab + yaw_offset + yaw_sway + yaw_step

    yaw_adding = helpers.normalize_degree( yaw_adding )

    if UI.Get( 'yaw_flick' ) and cmd.command_number % client.random_int( 15, 20 ) == 0 then
        local random = client.random_int( 0, 1 ) == 1
        desync_degree = 60
        body_yaw = 60
        inverter = random  and 1 or -1
        yaw_adding = random and -50 or 50
    end

    -- ui.set( references.antiaim[ 1 ], "Default" )
    ui.set( references.antiaim[ 3 ], ( antiaim.flags.in_manual and not antiaim.flags.in_backstab ) and "Local view" or "At targets" )
    ui.set( references.antiaim[ 5 ], "180" )
    ui.set( references.antiaim[ 6 ], yaw_adding )
    ui.set( references.antiaim[ 8 ], 0 )
    ui.set( references.antiaim[ 9 ], "Static" )
    ui.set( references.antiaim[ 11 ], desync_degree )

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
        antiaim.flags.in_freestanding = false

        return
    end

    local freestanding = UI.Get( "freestanding" ) and not antiaim.flags.in_backstab and not antiaim.flags.in_manual

    antiaim.flags.in_freestanding = freestanding

    ui.set( references.antiaim[ 13 ], ( freestanding and { "Default" } or { } ) )
    ui.set( references.antiaim[ 14 ], "Always on" )
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

client.set_event_callback( "pre_render", function( )
    local localplayer = entity.get_local_player( )

    if not localplayer then
        return
    end

    if UI.Contains( 'animations_breakers', 'On ground' ) then
        entity.set_prop( localplayer, "m_flPoseParameter", client.random_float( 0.75, 1 ), 0 )

        ui.set( references.leg_movement, client.random_int( 1, 3 ) == 1 and "Off" or "Always slide" )
    end

    local on_ground = helpers.check_bit( entity.get_prop( localplayer, "m_fFlags" ), 0 )

    if not on_ground and UI.Contains( 'animations_breakers', 'In air' ) then
        entity.set_prop( localplayer, "m_flPoseParameter", 0.45, 6 )
    end

    if UI.Contains( 'animations_breakers', 'On landing' ) and on_ground and antiaim.flags.previous_on_ground and globals.realtime( ) - antiaim.flags.last_landing_time <= 1.5 then
        entity.set_prop( localplayer, "m_flPoseParameter", 0.5, 12 )
    end
end )

local manual_arrows = {
    position = { SCREEN_SIZE[ 1 ] / 2, SCREEN_SIZE[ 2 ] / 2 },
    margin = 30,
    color = { 25, 25, 25, 128 },
}

client.set_event_callback( 'paint', function( )
    if not UI.Contains( 'indicators', 'Manual arrows' ) then
        return
    end

    animations.animate( 'manual_global', antiaim.manuals.active ~= 'none' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )
    animations.animate( 'manual_left', antiaim.manuals.active == 'left' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )
    animations.animate( 'manual_right', antiaim.manuals.active == 'right' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )

    if animations[ 'manual_global' ] == 0 then
        return
    end

    local arrows_size = { renderer.measure_text( '', '◀' ) }
    local render_position = { manual_arrows.position[ 1 ], manual_arrows.position[ 2 ] - arrows_size[ 2 ] / 2 }

    local color = { ui.get( UI.list[ 'indicators_color' ].element ) }
    color[ 4 ] = animations[ 'manual_global' ] * 240

    local left_color = helpers.color_swap(
        animations[ 'manual_left' ], manual_arrows.color, color
    )
    local right_color = helpers.color_swap(
        animations[ 'manual_right' ], manual_arrows.color, color
    )

    renderer.text( render_position[ 1 ] + manual_arrows.margin, render_position[ 2 ], right_color[ 1 ], right_color[ 2 ], right_color[ 3 ], animations[ 'manual_global' ] * right_color[ 4 ], '', nil, '▶' )
    renderer.text( render_position[ 1 ] - manual_arrows.margin - arrows_size[ 1 ], render_position[ 2 ], left_color[ 1 ], left_color[ 2 ], left_color[ 3 ], animations[ 'manual_global' ] * left_color[ 4 ], '', nil, '◀' )
end )

-- local manual_arrows = {
--     position = { SCREEN_SIZE[ 1 ] / 2, SCREEN_SIZE[ 2 ] / 2 },
--     margin = 30,
--     color = { 25, 25, 25, 128 },
--     size = 12,
--     original_size = 16,
--     ids = { },
-- }

-- http.get( "https://i.imgur.com/cqxdSNH.png", function( success, response )
--     if response.body ~= nil then
--         manual_arrows.ids.left = renderer.load_png( response.body, manual_arrows.original_size, manual_arrows.original_size )
--     end
-- end )

-- http.get( "https://i.imgur.com/zfIWV7b.png", function( success, response )
--     if response.body ~= nil then
--         manual_arrows.ids.right = renderer.load_png( response.body, manual_arrows.original_size, manual_arrows.original_size )
--     end
-- end )

-- client.set_event_callback( 'paint', function( )
--     if not UI.Contains( 'indicators', 'Manual arrows' ) or not manual_arrows.ids.left or not manual_arrows.ids.right then
--         return
--     end

--     animations.animate( 'manual_global', antiaim.manuals.active ~= 'none' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )
--     animations.animate( 'manual_left', antiaim.manuals.active == 'left' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )
--     animations.animate( 'manual_right', antiaim.manuals.active == 'right' and 1 or 0, globals.frametime( ) * 16, 'lerp', 0, 0, 1 )

--     if animations[ 'manual_global' ] == 0 then
--         return
--     end

--     local arrows_size = { manual_arrows.size, manual_arrows.size }
--     local render_position = { manual_arrows.position[ 1 ], manual_arrows.position[ 2 ] - arrows_size[ 2 ] / 2 }

--     local color = { ui.get( UI.list[ 'indicators_color' ].element ) }
--     color[ 4 ] = animations[ 'manual_global' ] * 240

--     local left_color = helpers.color_swap(
--         animations[ 'manual_left' ], manual_arrows.color, color
--     )
--     local right_color = helpers.color_swap(
--         animations[ 'manual_right' ], manual_arrows.color, color
--     )

--     -- renderer.text( render_position[ 1 ] + manual_arrows.margin, render_position[ 2 ], right_color[ 1 ], right_color[ 2 ], right_color[ 3 ], animations[ 'manual_global' ] * right_color[ 4 ], '', nil, '▶' )
--     -- renderer.text( render_position[ 1 ] - manual_arrows.margin - arrows_size[ 1 ], render_position[ 2 ], left_color[ 1 ], left_color[ 2 ], left_color[ 3 ], animations[ 'manual_global' ] * left_color[ 4 ], '', nil, '◀' )

--     renderer.texture( manual_arrows.ids.right, render_position[ 1 ] + manual_arrows.margin, render_position[ 2 ], manual_arrows.size, manual_arrows.size, right_color[ 1 ], right_color[ 2 ], right_color[ 3 ], animations[ 'manual_global' ] * right_color[ 4 ] )
--     renderer.texture( manual_arrows.ids.left, render_position[ 1 ] - manual_arrows.margin - arrows_size[ 1 ], render_position[ 2 ], manual_arrows.size, manual_arrows.size, left_color[ 1 ], left_color[ 2 ], left_color[ 3 ], animations[ 'manual_global' ] * left_color[ 4 ] )
-- end )

local iolkreset = 0
client.set_event_callback( "setup_command", function( cmd )
    if globals.realtime( ) - iolkreset < 0.4 then
        cmd.in_jump = false
        ui.set( multi_references[ 5 ][ 1 ], true )
    end

    if not UI.Get( "teleport_enable" ) or not UI.Get( "teleport_bind" ) then
        return
    end

    local charged = aa_lib.get_tickbase_shifting( ) > 0

    if not charged then
        return
    end

    local localplayer = entity.get_local_player( )

    if not localplayer then
        return
    end

    local players = entity.get_all( "CCSPlayer" )
    local eye_pos = vector( client.eye_position( ) )

    local velocity = vector( entity.get_prop( localplayer, 'm_vecVelocity' ) )
    local extrapolation = 7 * globals.tickinterval( )
    local eye_pos_extrapolated = vector( eye_pos.x + velocity.x * extrapolation, eye_pos.y + velocity.y * extrapolation, eye_pos.z + velocity.z * extrapolation )

    for i = 1, #players do
        local player = players[ i ]

        if not entity.is_enemy( player ) or not entity.is_alive( player ) or entity.is_dormant( player ) or localplayer == player then
            goto skip
        end

        local pos = vector( entity.hitbox_position( player, 2 ) )
        local _velocity = vector( entity.get_prop( player, 'm_vecVelocity' ) )
        local pos_extrapolated = vector( pos.x + _velocity.x * extrapolation, pos.y + _velocity.y * extrapolation, pos.z + _velocity.z * extrapolation )

        local i_1, d_1 = client.trace_bullet( localplayer, eye_pos_extrapolated.x, eye_pos_extrapolated.y, eye_pos_extrapolated.z, pos.x, pos.y, pos.z, false )

        if i_1 and d_1 > 0 then
            ui.set( multi_references[ 5 ][ 1 ], false )
            iolkreset = globals.realtime( )
            cmd.in_jump = false

            break
        end

        local i_2, d_2 = client.trace_bullet( localplayer, eye_pos_extrapolated.x, eye_pos_extrapolated.y, eye_pos_extrapolated.z, pos_extrapolated.x, pos_extrapolated.y, pos_extrapolated.z, false )

        if i_2 and d_2 > 0 then
            ui.set( multi_references[ 5 ][ 1 ], false )
            iolkreset = globals.realtime( )
            cmd.in_jump = false

            break
        end

        ::skip::
    end
end )