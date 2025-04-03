local e_keys, input, render, vec2_t, color_t, callbacks, e_callbacks, e_font_flags, menu
= e_keys, input, render, vec2_t, color_t, callbacks, e_callbacks, e_font_flags, menu
-- cba to actually set up visual studio code 

local refs = {
    accent = menu.find( 'misc', 'main', 'personalization', 'accent color' )[ 2 ]
}

local images = {
    primordial_outline = render.load_image_buffer([[<svg width="3414" height="5915" viewBox="0 0 3414 5915" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path fill-rule="evenodd" clip-rule="evenodd" d="M684.299 1722.07C-174.968 549.792 1334.88 3.54513 1334.88 3.54513C1125.91 -13.8695 889.271 59.6302 723.653 126.472C525.728 206.352 348.715 332.953 217.537 501.321C-3.21193 784.656 -22.6679 1082.47 16.4921 1315.11C51.9281 1525.64 146.211 1721.43 280.625 1887.28C598.725 2279.79 1076.75 2695.13 1386.3 2948.27C1007.9 3252.6 395.303 3774.84 188.732 4121.88C188.732 4121.88 -351.377 4944.32 397.412 5588.77C397.412 5588.77 827.044 5901.79 1342.6 5914.06C1342.6 5914.06 -1.53345 5472.15 556.989 4373.52C556.989 4373.52 900.696 3735.21 1654.21 3233.91C1671.95 3222.1 1689.55 3210.1 1707 3197.89C1724.45 3210.1 1742.05 3222.1 1759.79 3233.91C2513.31 3735.21 2857.01 4373.52 2857.01 4373.52C3415.53 5472.15 2071.4 5914.06 2071.4 5914.06C2586.96 5901.79 3016.59 5588.77 3016.59 5588.77C3765.38 4944.32 3225.27 4121.88 3225.27 4121.88C3018.7 3774.84 2406.1 3252.6 2027.7 2948.27C2337.25 2695.13 2815.28 2279.79 3133.37 1887.28C3267.79 1721.43 3362.07 1525.64 3397.51 1315.11C3436.67 1082.47 3417.21 784.656 3196.46 501.321C3065.29 332.953 2888.27 206.352 2690.35 126.472C2524.73 59.6302 2288.09 -13.8695 2079.12 3.54513C2079.12 3.54513 3588.97 549.792 2729.7 1722.07C2729.7 1722.07 2455.56 2154.61 1707 2697.99C958.437 2154.61 684.299 1722.07 684.299 1722.07ZM1707 2697.99C1706.29 2698.51 1705.58 2699.03 1704.87 2699.54C1704.13 2700.08 1703.39 2700.61 1702.65 2701.15C1701.3 2702.13 1699.94 2703.11 1698.59 2704.09C1698.59 2704.09 1570.06 2800.49 1386.3 2948.27C1468.95 3015.86 1539.6 3071.88 1591.98 3112.82C1629.57 3142.2 1667.92 3170.56 1707 3197.89C1746.08 3170.56 1784.43 3142.2 1822.02 3112.82C1874.4 3071.88 1945.05 3015.86 2027.7 2948.27C1843.95 2800.49 1715.42 2704.09 1715.42 2704.09C1712.6 2702.06 1709.8 2700.03 1707 2697.99Z" fill="#D7D7D7"/>
    <path d="M1707 2697.99L1704.87 2699.54L1702.65 2701.15C1701.3 2702.13 1699.94 2703.11 1698.59 2704.09C1698.59 2704.09 1570.06 2800.49 1386.3 2948.27C1468.95 3015.86 1539.6 3071.88 1591.98 3112.82C1629.57 3142.2 1667.92 3170.56 1707 3197.89C1746.08 3170.56 1784.43 3142.2 1822.02 3112.82C1874.4 3071.88 1945.05 3015.86 2027.7 2948.27C1843.95 2800.49 1715.42 2704.09 1715.42 2704.09C1712.6 2702.06 1709.8 2700.03 1707 2697.99Z" fill="#D7D7D7"/>
    </svg>]]),
    primordial_inside = render.load_image_buffer([[<svg width="3414" height="5915" viewBox="0 0 3414 5915" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path d="M839.196 1488.69C831.596 1469.89 836.03 1460.19 839.196 1457.69C845.196 1450.49 874.363 1468.02 888.196 1477.69C1146.7 1613.69 1582.7 1676.69 1777.7 1674.19C1933.7 1672.19 2340.7 1656.36 2524.7 1648.69C2530.3 1649.49 2532.03 1656.36 2532.2 1659.69C2514.7 1766.69 2220.7 2088.69 2151.7 2146.19C2082.7 2203.69 1750.7 2468.69 1748.7 2471.19C1746.7 2473.69 1745.2 2474.69 1738.7 2475.19C1733.5 2475.59 1729.86 2472.69 1728.7 2471.19L1350.2 2146.19C1164.2 2005.69 957.696 1710.69 919.196 1649.69C880.696 1588.69 848.696 1512.19 839.196 1488.69Z" fill="#FFFFFF"/>
    <path d="M1849 4883.5C1805 4822.3 1785.33 4720 1781 4676.5C1675 4848.5 1568.17 4968.5 1528 5007C1486.83 5053.17 1369.8 5164.8 1231 5242C1057.5 5338.5 912 5335.5 863.5 5337C824.7 5338.2 826.667 5359.5 832.5 5370C991.5 5569 1364 5780.5 1741.5 5767.5C2119 5754.5 2445 5484 2518.5 5394C2592 5304 2568 5288.5 2562 5272.5C2556 5256.5 2484 5212 2335 5164C2186 5116 2126.5 5102 2047 5068.5C1967.5 5035 1904 4960 1849 4883.5Z" fill="#FFFFFF"/>
    </svg>]])
}

menu_is_open = menu.is_open

local ease = { }
function ease.out_exponent( t )
    return t == 1 and 1 or 1 - ( 2 ^ ( -10 * t ) )
end

local element_types = {
    checkbox = 1,
    slider = 2,
    combo = 3,
    multicombo = 4,
    text_input = 5,
    keybind = 6,
    colorpicker = 7,
    separator = 8,
    list = 9,
    text = 10,
    button = 11,
}

local element_id_to_name = {
    [ element_types.checkbox ] = 'checkbox',
    [ element_types.slider ] = 'slider',
    [ element_types.combo ] = 'combo',
    [ element_types.multicombo ] = 'multicombo',
    [ element_types.text_input ] = 'text_input',
    [ element_types.keybind ] = 'keybind',
    [ element_types.colorpicker ] = 'colorpicker',
    [ element_types.separator ] = 'separator',
    [ element_types.list ] = 'list',
    [ element_types.text ] = 'text',
    [ element_types.button ] = 'button',
}

function table.shallow_has_value( table, value )
    for _, v in pairs( table ) do
        if v == value then
            return true
        end
    end

    return false
end

function table.shallow_find( table, value )
    for k, v in pairs( table ) do
        if v == value then
            return k
        end
    end

    return nil
end

function math.clamp( value, min, max )
    if value < min then
        return min
    elseif value > max then
        return max
    end

    return value
end

local function hue_to_rgb( hue_degrees )
    local hue = hue_degrees / 360

    local r, g, b = 0, 0, 0

    if hue < 1 / 6 then
        r = 1
        g = hue * 6
    elseif hue < 2 / 6 then
        r = 1 - ( hue - 1 / 6 ) * 6
        g = 1
    elseif hue < 3 / 6 then
        g = 1
        b = ( hue - 2 / 6 ) * 6
    elseif hue < 4 / 6 then
        g = 1 - ( hue - 3 / 6 ) * 6
        b = 1
    elseif hue < 5 / 6 then
        r = ( hue - 4 / 6 ) * 6
        b = 1
    else
        r = 1
        b = 1 - ( hue - 5 / 6 ) * 6
    end

    return color_t.new( math.floor( r * 255 ), math.floor( g * 255 ), math.floor( b * 255 ) )
end

local function rbg_to_hex( color )
    return string.format( '#%02X%02X%02X%02X', color.r, color.g, color.b, color.a )
end

local function rgb_to_hsb( color )
    local hue, saturation, brightness = 0, 0, 0

    local r = color.r / 255
    local g = color.g / 255
    local b = color.b / 255

    local max = math.max( r, g, b )
    local min = math.min( r, g, b )

    brightness = max

    if max == 0 then
        saturation = 0
    else
        saturation = ( max - min ) / max
    end

    if max == min then
        hue = 0
    else
        local delta = max - min

        if max == r then
            hue = ( g - b ) / delta
        elseif max == g then
            hue = 2 + ( b - r ) / delta
        elseif max == b then
            hue = 4 + ( r - g ) / delta
        end

        hue = hue * 60

        if hue < 0 then
            hue = hue + 360
        end
    end

    return hue, saturation, brightness
end

local function hsb_to_rgb( h, s, b )
    local rgb = { r = 0, g = 0, b = 0 }

    if s == 0 then
        rgb.r = b * 255
        rgb.g = b * 255
        rgb.b = b * 255
    else
        local hue = ( h == 360 ) and 0 or h

        local sector = math.floor( hue / 60 )
        local sector_pos = ( hue / 60 ) - sector

        local p = b * ( 1 - s )
        local q = b * ( 1 - s * sector_pos )
        local t = b * ( 1 - s * ( 1 - sector_pos ) )

        if sector == 0 then
            rgb.r = b * 255
            rgb.g = t * 255
            rgb.b = p * 255
        elseif sector == 1 then
            rgb.r = q * 255
            rgb.g = b * 255
            rgb.b = p * 255
        elseif sector == 2 then
            rgb.r = p * 255
            rgb.g = b * 255
            rgb.b = t * 255
        elseif sector == 3 then
            rgb.r = p * 255
            rgb.g = q * 255
            rgb.b = b * 255
        elseif sector == 4 then
            rgb.r = t * 255
            rgb.g = p * 255
            rgb.b = b * 255
        elseif sector == 5 then
            rgb.r = b * 255
            rgb.g = p * 255
            rgb.b = q * 255
        end
    end

    return color_t.new(
        math.floor( rgb.r ),
        math.floor( rgb.g ),
        math.floor( rgb.b )
    )
end

local function set_visibility_requirement( self, args )
    local menu_element_ref = args[ 1 ]
    local value = args[ 2 ]
    local math = args[ 3 ]
    local invisibility = args[ 4 ]

    local index = #self.visibility_requirements + 1

    self.visibility_requirements[ index ] = false

    local function handle_visible( )
        local elem_value = menu_element_ref._type == element_types.multicombo and menu_element_ref:get( value ) or menu_element_ref:get( )

        if menu_element_ref._type == element_types.multicombo then
            self.visibility_requirements[ index ] = elem_value
        elseif math == nil then
            self.visibility_requirements[ index ] = elem_value == value
        else
            self.visibility_requirements[ index ] = math == '<=' and elem_value <= value or
                                                    math == '>=' and elem_value >= value or
                                                    math == '<'  and elem_value <  value or
                                                    math == '>'  and elem_value >  value or
                                                    math == '==' and elem_value == value or
                                                    math == '~=' and elem_value ~= value
        end

        if invisibility then
            self.visibility_requirements[ index ] = not self.visibility_requirements[ index ]
        end

        local vis = true
        for i = 1, #self.visibility_requirements do
            if not self.visibility_requirements[ i ] then
                vis = false
                break
            end
        end
    
        self:set_visible( vis )
    end

    menu_element_ref:register_callback( handle_visible )

    table.insert( self.visibility_callbacks, handle_visible )
    handle_visible( )
end

local key = {
    KEY_NONE = e_keys.KEY_NONE,
    KEY_0 	 = e_keys.KEY_0,
    KEY_1 	 = e_keys.KEY_1,
    KEY_2 	 = e_keys.KEY_2,
    KEY_3 	 = e_keys.KEY_3,
    KEY_4 	 = e_keys.KEY_4,
    KEY_5 	 = e_keys.KEY_5,
    KEY_6 	 = e_keys.KEY_6,
    KEY_7 	 = e_keys.KEY_7,
    KEY_8 	 = e_keys.KEY_8,
    KEY_9 	 = e_keys.KEY_9,
    KEY_A 	 = e_keys.KEY_A,
    KEY_B 	 = e_keys.KEY_B,
    KEY_C 	 = e_keys.KEY_C,
    KEY_D 	 = e_keys.KEY_D,
    KEY_E 	 = e_keys.KEY_E,
    KEY_F 	 = e_keys.KEY_F,
    KEY_G 	 = e_keys.KEY_G,
    KEY_H 	 = e_keys.KEY_H,
    KEY_I 	 = e_keys.KEY_I,
    KEY_J 	 = e_keys.KEY_J,
    KEY_K 	 = e_keys.KEY_K,
    KEY_L 	 = e_keys.KEY_L,
    KEY_M 	 = e_keys.KEY_M,
    KEY_N 	 = e_keys.KEY_N,
    KEY_O 	 = e_keys.KEY_O,
    KEY_P 	 = e_keys.KEY_P,
    KEY_Q 	 = e_keys.KEY_Q,
    KEY_R 	 = e_keys.KEY_R,
    KEY_S 	 = e_keys.KEY_S,
    KEY_T 	 = e_keys.KEY_T,
    KEY_U 	 = e_keys.KEY_U,
    KEY_V 	 = e_keys.KEY_V,
    KEY_W 	 = e_keys.KEY_W,
    KEY_X 	 = e_keys.KEY_X,
    KEY_Y 	 = e_keys.KEY_Y,
    KEY_Z 	 = e_keys.KEY_Z,
    KEY_PAD_0 	 = e_keys.KEY_PAD_0,
    KEY_PAD_1 	 = e_keys.KEY_PAD_1,
    KEY_PAD_2 	 = e_keys.KEY_PAD_2,
    KEY_PAD_3 	 = e_keys.KEY_PAD_3,
    KEY_PAD_4 	 = e_keys.KEY_PAD_4,
    KEY_PAD_5 	 = e_keys.KEY_PAD_5,
    KEY_PAD_6 	 = e_keys.KEY_PAD_6,
    KEY_PAD_7 	 = e_keys.KEY_PAD_7,
    KEY_PAD_8 	 = e_keys.KEY_PAD_8,
    KEY_PAD_9 	 = e_keys.KEY_PAD_9,
    KEY_PAD_DIVIDE 	 = e_keys.KEY_PAD_DIVIDE,
    KEY_PAD_MULTIPLY 	 = e_keys.KEY_PAD_MULTIPLY,
    KEY_PAD_MINUS 	 = e_keys.KEY_PAD_MINUS,
    KEY_PAD_PLUS 	 = e_keys.KEY_PAD_PLUS,
    KEY_PAD_ENTER 	 = e_keys.KEY_PAD_ENTER,
    KEY_PAD_DECIMAL 	 = e_keys.KEY_PAD_DECIMAL,
    KEY_LBRACKET 	 = e_keys.KEY_LBRACKET,
    KEY_RBRACKET 	 = e_keys.KEY_RBRACKET,
    KEY_SEMICOLON 	 = e_keys.KEY_SEMICOLON,
    KEY_APOSTROPHE 	 = e_keys.KEY_APOSTROPHE,
    KEY_BACKQUOTE 	 = e_keys.KEY_BACKQUOTE,
    KEY_COMMA 	 = e_keys.KEY_COMMA,
    KEY_PERIOD 	 = e_keys.KEY_PERIOD,
    KEY_SLASH 	 = e_keys.KEY_SLASH,
    KEY_BACKSLASH 	 = e_keys.KEY_BACKSLASH,
    KEY_MINUS 	 = e_keys.KEY_MINUS,
    KEY_EQUAL 	 = e_keys.KEY_EQUAL,
    KEY_ENTER 	 = e_keys.KEY_ENTER,
    KEY_SPACE 	 = e_keys.KEY_SPACE,
    KEY_BACKSPACE 	 = e_keys.KEY_BACKSPACE,
    KEY_TAB 	 = e_keys.KEY_TAB,
    KEY_CAPSLOCK 	 = e_keys.KEY_CAPSLOCK,
    KEY_NUMLOCK 	 = e_keys.KEY_NUMLOCK,
    KEY_ESCAPE 	 = e_keys.KEY_ESCAPE,
    KEY_SCROLLLOCK 	 = e_keys.KEY_SCROLLLOCK,
    KEY_INSERT 	 = e_keys.KEY_INSERT,
    KEY_DELETE 	 = e_keys.KEY_DELETE,
    KEY_HOME 	 = e_keys.KEY_HOME,
    KEY_END 	 = e_keys.KEY_END,
    KEY_PAGEUP 	 = e_keys.KEY_PAGEUP,
    KEY_PAGEDOWN 	 = e_keys.KEY_PAGEDOWN,
    KEY_BREAK 	 = e_keys.KEY_BREAK,
    KEY_LSHIFT 	 = e_keys.KEY_LSHIFT,
    KEY_RSHIFT 	 = e_keys.KEY_RSHIFT,
    KEY_LALT 	 = e_keys.KEY_LALT,
    KEY_RALT 	 = e_keys.KEY_RALT,
    KEY_LCONTROL 	 = e_keys.KEY_LCONTROL,
    KEY_RCONTROL 	 = e_keys.KEY_RCONTROL,
    KEY_LWIN 	 = e_keys.KEY_LWIN,
    KEY_RWIN 	 = e_keys.KEY_RWIN,
    KEY_APP 	 = e_keys.KEY_APP,
    KEY_UP 	 = e_keys.KEY_UP,
    KEY_LEFT 	 = e_keys.KEY_LEFT,
    KEY_DOWN 	 = e_keys.KEY_DOWN,
    KEY_RIGHT 	 = e_keys.KEY_RIGHT,
    KEY_F1 	 = e_keys.KEY_F1,
    KEY_F2 	 = e_keys.KEY_F2,
    KEY_F3 	 = e_keys.KEY_F3,
    KEY_F4 	 = e_keys.KEY_F4,
    KEY_F5 	 = e_keys.KEY_F5,
    KEY_F6 	 = e_keys.KEY_F6,
    KEY_F7 	 = e_keys.KEY_F7,
    KEY_F8 	 = e_keys.KEY_F8,
    KEY_F9 	 = e_keys.KEY_F9,
    KEY_F10 	 = e_keys.KEY_F10,
    KEY_F11 	 = e_keys.KEY_F11,
    KEY_F12 	 = e_keys.KEY_F12,
    KEY_CAPSLOCKTOGGLE 	 = e_keys.KEY_CAPSLOCKTOGGLE,
    KEY_NUMLOCKTOGGLE 	 = e_keys.KEY_NUMLOCKTOGGLE,
    KEY_SCROLLLOCKTOGGLE 	 = e_keys.KEY_SCROLLLOCKTOGGLE,
    MOUSE_LEFT 	 = e_keys.MOUSE_LEFT,
    MOUSE_RIGHT 	 = e_keys.MOUSE_RIGHT,
    MOUSE_MIDDLE 	 = e_keys.MOUSE_MIDDLE,
    MOUSE_4 	 = e_keys.MOUSE_4,
    MOUSE_5 	 = e_keys.MOUSE_5,
    MOUSE_WHEEL_UP 	 = e_keys.MOUSE_WHEEL_UP,
    MOUSE_WHEEL_DOWN = e_keys.MOUSE_WHEEL_DOWN
}

local input_keys = { 
    KEY_0 	 = '0',
    KEY_1 	 = '1',
    KEY_2 	 = '2',
    KEY_3 	 = '3',
    KEY_4 	 = '4',
    KEY_5 	 = '5',
    KEY_6 	 = '6',
    KEY_7 	 = '7',
    KEY_8 	 = '8',
    KEY_9 	 = '9',
    KEY_A 	 = 'A',
    KEY_B 	 = 'B',
    KEY_C 	 = 'C',
    KEY_D 	 = 'D',
    KEY_E 	 = 'E',
    KEY_F 	 = 'F',
    KEY_G 	 = 'G',
    KEY_H 	 = 'H',
    KEY_I 	 = 'I',
    KEY_J 	 = 'J',
    KEY_K 	 = 'K',
    KEY_L 	 = 'L',
    KEY_M 	 = 'M',
    KEY_N 	 = 'N',
    KEY_O 	 = 'O',
    KEY_P 	 = 'P',
    KEY_Q 	 = 'Q',
    KEY_R 	 = 'R',
    KEY_S 	 = 'S',
    KEY_T 	 = 'T',
    KEY_U 	 = 'U',
    KEY_V 	 = 'V',
    KEY_W 	 = 'W',
    KEY_X 	 = 'X',
    KEY_Y 	 = 'Y',
    KEY_Z 	 = 'Z',
    KEY_PAD_0 	 = '0',
    KEY_PAD_1 	 = '1',
    KEY_PAD_2 	 = '2',
    KEY_PAD_3 	 = '3',
    KEY_PAD_4 	 = '4',
    KEY_PAD_5 	 = '5',
    KEY_PAD_6 	 = '6',
    KEY_PAD_7 	 = '7',
    KEY_PAD_8 	 = '8',
    KEY_PAD_9 	 = '9',
    KEY_PAD_DIVIDE 	 = '/',
    KEY_PAD_MULTIPLY 	 = '*',
    KEY_PAD_MINUS 	 = '-',
    KEY_PAD_PLUS 	 = '+',
    KEY_PAD_DECIMAL 	 = '.',
    KEY_LBRACKET 	 = '(',
    KEY_RBRACKET 	 = ')',
    KEY_SEMICOLON 	 = ';',
    KEY_APOSTROPHE 	 = '\'',
    KEY_BACKQUOTE 	 = '`',
    KEY_COMMA 	 = ',',
    KEY_PERIOD 	 = '.',
    KEY_SLASH 	 = '/',
    KEY_BACKSLASH 	 = '\\',
    KEY_MINUS 	 = '-',
    KEY_EQUAL 	 = '=',
    KEY_SPACE 	 = ' ',
}

local other_keys = {
    KEY_NONE       = 'none',
    KEY_SPACE 	   = 'Space',
    KEY_BACKSPACE  = 'Backspace',
    KEY_TAB 	   = 'Tab',
    KEY_CAPSLOCK   = 'Caps',
    KEY_NUMLOCK    = 'Numlock',
    KEY_ESCAPE 	   = 'Esc',
    KEY_SCROLLLOCK = 'Scroll Lock',
    KEY_INSERT 	   = 'Ins',
    KEY_DELETE 	   = 'Del',
    KEY_HOME 	   = 'Home',
    KEY_END 	   = 'End',
    KEY_PAGEUP 	   = 'PG UP',
    KEY_PAGEDOWN   = 'PG DN',
    KEY_BREAK 	   = 'BREAK',
    KEY_LSHIFT 	   = 'LSHIFT',
    KEY_RSHIFT 	   = 'RSHIFT',
    KEY_LALT 	   = 'LALT',
    KEY_RALT 	   = 'RALT',
    KEY_LCONTROL   = 'LCONTROL',
    KEY_RCONTROL   = 'RCONTROL',
    KEY_LWIN 	   = 'LWIN',
    KEY_RWIN 	   = 'RWIN',
    KEY_APP 	   = 'APP',
    KEY_UP 	       = 'Up',
    KEY_LEFT 	   = 'Left',
    KEY_DOWN 	   = 'Down',
    KEY_RIGHT 	   = 'Right',
    KEY_F1 	 = 'F1',
    KEY_F2 	 = 'F2',
    KEY_F3 	 = 'F3',
    KEY_F4 	 = 'F4',
    KEY_F5 	 = 'F5',
    KEY_F6 	 = 'F6',
    KEY_F7 	 = 'F7',
    KEY_F8 	 = 'F8',
    KEY_F9 	 = 'F9',
    KEY_F10  = 'F10',
    KEY_F11  = 'F11',
    KEY_F12  = 'F12',
    KEY_CAPSLOCKTOGGLE 	 = 'Caps',
    KEY_NUMLOCKTOGGLE 	 = 'Numlock',
    KEY_SCROLLLOCKTOGGLE = 'Scroll Lock',
    MOUSE_LEFT 	     = 'Mouse1',
    MOUSE_RIGHT 	 = 'Mouse2',
    MOUSE_MIDDLE 	 = 'Mouse3',
    MOUSE_4 	     = 'Mouse4',
    MOUSE_5 	     = 'Mouse5',
    MOUSE_WHEEL_UP 	 = 'MWheel up',
    MOUSE_WHEEL_DOWN = 'MWheel down'
}

function input.get_input_text( )
    local uppercase = input.is_key_held( key.KEY_LSHIFT ) or input.is_key_held( key.KEY_RSHIFT )
    for k, v in pairs( input_keys ) do
        if input.is_key_pressed( key[ k ] ) then
            local key = v

            if not uppercase then
                key = key:lower( )
            end

            return key
        end
    end

    return ""
end

function input.get_new_keybind_key( )
    for k, v in pairs( input_keys ) do
        if input.is_key_pressed( key[ k ] ) then
            return key[ k ]
        end
    end

    for k, v in pairs( other_keys ) do
        if input.is_key_pressed( key[ k ] ) then
            return key[ k ]
        end
    end

    return nil
end

function input.get_key_name( e_key )
    for k, v in pairs( input_keys ) do
        if e_key == key[ k ] then
            return v
        end
    end

    for k, v in pairs( other_keys ) do
        if e_key == key[ k ] then
            return v
        end
    end

    return ""
end

local fonts = {
    default    = render.get_default_font( ),
    element    = render.get_default_font( ),
    page       = render.create_font( "Arial", 24, 800, e_font_flags.ANTIALIAS ),
    page_title = render.create_font( "Arial", 12, 800, e_font_flags.ANTIALIAS ),
}

local colors = {
    inactive_outline = color_t.new( 40, 40, 40 ),
    inactive_text = color_t.new( 123, 123, 123 ),

    hovering_text = color_t.new( 181, 181, 181 ),
    active_text = color_t.new( 200, 200, 200 ),

    hovering_outline = color_t.new( 58, 58, 58 ),

    active_outline = color_t.new( 58, 58, 58 ),

    dark_background = color_t.new( 29, 29, 29 ),
    subtab_background = color_t.new( 34, 34, 34 ),
    section_background = color_t.new( 34, 34, 34 ),
    footer_background = color_t.new( 41, 41, 41 ),

    black = color_t.new( 0, 0, 0 ),
    white = color_t.new( 255, 255, 255 ),
    accent = color_t.new( 193, 154, 164 ),
    red = color_t.new( 255, 0, 0 ),

    white10 = color_t.new( 255, 255, 255, 10 ),
    white30 = color_t.new( 255, 255, 255, 30 ),
    white100 = color_t.new( 255, 255, 255, 50 ),

    black10 = color_t.new( 0, 0, 0, 10 ),

    transparent = color_t.new( 0, 0, 0, 0 ),
}

-- to reset menu colors
local colors_backup = { }
for k, v in pairs( colors ) do
    colors_backup[ k ] = v
end

local elements = { }

local keybind_modes = {
    none = 0,
    always = 1,
    hold = 2,
    toggle = 3
}

function elements.create_keybind( parent, name, mode, default_key, locked )
    local keybind = { _type = element_types.keybind }

    keybind.parent = parent
    keybind.page = parent.page
    keybind.tab = parent.tab
    keybind.section = parent.section

    keybind.name = name
    keybind.mode = mode ~= nil and mode or keybind_modes.none

    keybind.mode = math.clamp( keybind.mode, 0, 3 )

    keybind.key = default_key or key.KEY_NONE
    keybind.locked = locked or false

    keybind.state = false
    keybind.visible = true
    keybind.mode_menu_open = false
    keybind.binding_new_key = false

    keybind.render_topmost = false
    keybind.key_name = input.get_key_name( keybind.key )

    keybind.height = 16

    keybind.visibility_callbacks = { }
    keybind.visibility_requirements = { }

    keybind.callbacks = { }
    
    function keybind:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function keybind:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function keybind:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end
    
    function keybind:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    function keybind:get( )
        return keybind.state
    end

    function keybind:update( )
        if self.mode == keybind_modes.none then
            self.state = false
        elseif self.mode == keybind_modes.always then
            self.state = true
        elseif self.mode == keybind_modes.hold then
            self.state = input.is_key_held( self.key )

            if self.state then
                self:invoke_callbacks( )
            end
        elseif self.mode == keybind_modes.toggle then
            if input.is_key_pressed( self.key ) then
                self.state = not self.state
            end

            if self.state then
                self:invoke_callbacks( )
            end
        end
    end

    function keybind:set_mode( new_mode )
        keybind.mode = math.clamp( new_mode, 0, 3 )
    end

    function keybind:get_mode( )
        return keybind.mode
    end

    function keybind:lock_mode( )
        keybind.locked = true
    end

    function keybind:unlock_mode( )
        keybind.locked = false
    end

    function keybind:set_key( new_key )
        keybind.key = new_key
        keybind.key_name = input.get_key_name( new_key )
    end

    function keybind:get_key( )
        return keybind.key
    end

    function keybind:set_visible( boolean )
        keybind.visible = boolean
    end

    function keybind:handle( pos, width, interacting )
        if not self.visible then
            return false
        end

        local gui_y = self.parent.gui.pos.y

        if pos.y < gui_y then
            self.mode_menu_open = false
            self.binding_new_key = false

            return false
        end


        local keybind_mode = self.mode == keybind_modes.always and 'Always on: '  or
                    self.mode == keybind_modes.hold   and 'Hold on: '  or
                    self.mode == keybind_modes.toggle and 'Toggle: '   or
                                                            'Always off'
        
        local total_text = ( self.mode == keybind_modes.none or self.mode == keybind_modes.always ) and keybind_mode or keybind_mode .. ( self.binding_new_key and '...' or self.key_name )

        local text_width = render.get_text_size( fonts.default, total_text ).x

        local start_pos = pos + vec2_t.new( width - 20 - text_width, 0 )
        local size = vec2_t.new( text_width + 10, keybind.height )

        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local in_bounds = input.is_mouse_in_bounds( start_pos, size )
        local in_mode_menu_bounds = input.is_mouse_in_bounds( start_pos + vec2_t.new( 0, keybind.height ), vec2_t.new( size.x, keybind.height * 4 ) )

        if in_bounds and is_mouse_1_pressed and not self.binding_new_key and ( self.mode == keybind_modes.hold or self.mode == keybind_modes.toggle ) then
            self.binding_new_key = true
        elseif self.binding_new_key then
            local new_key = input.get_new_keybind_key( )

            if new_key ~= nil then
                self.key = new_key
                self.key_name = input.get_key_name( self.key )

                self.binding_new_key = false
            end
        elseif not in_bounds and self.binding_new_key and is_mouse_1_pressed then
            self.binding_new_key = false
        end

        -- mode menu
        local is_mouse_2_pressed = input.is_key_pressed( e_keys.MOUSE_RIGHT )

        if in_bounds and is_mouse_2_pressed and not self.locked and not self.binding_new_key then
            self.mode_menu_open = not self.mode_menu_open
        elseif not in_bounds and not in_mode_menu_bounds and ( is_mouse_1_pressed or is_mouse_2_pressed ) then
            self.mode_menu_open = false
        end

        if self.mode_menu_open then
            local mode_pos = start_pos + vec2_t.new( 0, keybind.height )

            if is_mouse_1_pressed then
                local mouse_pos_y = input.get_mouse_pos( ).y

                local index = math.floor( ( mouse_pos_y - mode_pos.y ) / keybind.height ) + 1
                
                if index == 1 then
                    self.mode = keybind_modes.none
                elseif index == 2 then
                    self.mode = keybind_modes.always
                elseif index == 3 then
                    self.mode = keybind_modes.hold
                elseif index == 4 then
                    self.mode = keybind_modes.toggle
                end

                self.mode_menu_open = false
            end

            return true
        end

        return self.binding_new_key or self.mode_menu_open
    end

    function keybind:in_bounds( pos, width )
        if not self.visible or not self.parent.visible then
            return false, vec2_t.new( 0, 0 )
        end

        local keybind_mode = self.mode == keybind_modes.always and 'Always on: '  or
                    self.mode == keybind_modes.hold   and 'Hold on: '  or
                    self.mode == keybind_modes.toggle and 'Toggle: '   or
                                                            'Always off'
        
        local total_text = self.mode == keybind_modes.none and keybind_mode or keybind_mode .. self.key_name

        local text_width = render.get_text_size( fonts.default, total_text ).x

        local start_pos = pos + vec2_t.new( width - 20 - text_width, 0 )
        local size = vec2_t.new( text_width + 10, keybind.height ) + vec2_t.new( 3, 0 )

        return input.is_mouse_in_bounds( start_pos, size ), size
    end

    function keybind:render( pos, width, interacting )
        if not self.visible or not self.parent.visible then
            return
        end

        local keybind_mode = self.mode == keybind_modes.always and 'Always on'  or
                    self.mode == keybind_modes.hold   and 'Hold on: '  or
                    self.mode == keybind_modes.toggle and 'Toggle: '   or
                                                        'Always off'
        local gui_y = self.parent.gui.pos.y

        local total_text = ( self.mode == keybind_modes.none or self.mode == keybind_modes.always ) and keybind_mode or keybind_mode .. ( self.binding_new_key and '...' or self.key_name )

        local text_width = render.get_text_size( fonts.default, total_text ).x

        local start_pos = pos + vec2_t.new( width - 10 - text_width - 10    , 0 )
        local size = vec2_t.new( text_width + 10, keybind.height )

        if start_pos.y > gui_y then
            local in_bounds = input.is_mouse_in_bounds( start_pos, size )

            local outline_color = in_bounds and self.parent.gui.colors.hovering_outline or
                                                self.parent.gui.colors.inactive_outline

            local text_color = self.binding_new_key and self.parent.gui.colors.hovering_text or
                                                        self.parent.gui.colors.inactive_text

            -- render bind box
            render.rect_filled(
                start_pos,
                size,
                self.parent.gui.colors.dark_background,
                3
            )

            -- render bind outline
            render.rect(
                start_pos,
                size,
                outline_color,
                3
            )

            -- render bind total text
            render.text(
                fonts.default,
                total_text,
                start_pos + vec2_t.new( 5, 0 ),
                text_color
            )

            if self.mode_menu_open then
                local strings = {
                    'Always Off',
                    'Always On',
                    'On Hold',
                    'Toggle'
                }

                local mode_height = keybind.height * #strings

                local mode_pos = start_pos + vec2_t.new( 0, keybind.height )
                
                render.rect_filled(
                    mode_pos,
                    vec2_t.new( size.x, mode_height ),
                    self.parent.gui.colors.dark_background,
                    3
                )

                render.rect(
                    mode_pos,
                    vec2_t.new( size.x, mode_height ),
                    self.parent.gui.colors.inactive_outline,
                    3
                )

                for i = 1, #strings do
                    local string = strings[ i ]
                    local string_pos = mode_pos + vec2_t.new( 5, keybind.height * ( i - 1 ) )

                    local in_text_bounds = input.is_mouse_in_bounds( string_pos, vec2_t.new( size.x - 10, keybind.height ) )

                    local text_color = self.mode == i - 1 and colors.accent or
                                    in_text_bounds     and self.parent.gui.colors.hovering_text or
                                                            self.parent.gui.colors.inactive_text

                    render.text(
                        fonts.default,
                        string,
                        string_pos,
                        text_color
                    )
                end
            end
        end
    end

    function keybind:to_string( )
        return string.format( '[ keybind ][ %s->%s->%s ] %s', self.page, self.tab, self.section, self.name, self.key_name )
    end

    table.insert( parent.gui.keybinds, keybind )
    return keybind
end

function elements.create_colorpicker( parent, name, default_color )
    local colorpicker = { _type = element_types.colorpicker }

    colorpicker.parent = parent
    colorpicker.page = parent.page
    colorpicker.tab = parent.tab
    colorpicker.section = parent.section

    colorpicker.name = name

    colorpicker.color = default_color == nil and color_t.new( 255, 255, 255 ) or default_color

    colorpicker.visible = true

    colorpicker.render_topmost = false

    colorpicker.height = 16

    colorpicker.open = false

    colorpicker.visibility_callbacks = { }
    colorpicker.visibility_requirements = { }

    colorpicker.callbacks = { }
    
    function colorpicker:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function colorpicker:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function colorpicker:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end
    
    function colorpicker:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    colorpicker.size = vec2_t.new( 20, 13 )

    colorpicker.picker_size = vec2_t.new( 180, 200 )
    colorpicker.picker_area = vec2_t.new( colorpicker.picker_size.x - 20, ( colorpicker.picker_size.x - 20 ) * 0.8 )

    colorpicker.hue, colorpicker.saturation, colorpicker.brightness = rgb_to_hsb( colorpicker.color )
    colorpicker.alpha = default_color == nil and 255 or colorpicker.color.a

    colorpicker.stored = {
        positions = {
            window = vec2_t.new( 0, 0 ),
            picker = vec2_t.new( 0, 0 ),
            hue_slider = vec2_t.new( 0, 0 ),
            alpha_slider = vec2_t.new( 0, 0 ),
            copy_button = vec2_t.new( 0, 0 ),
            paste_button = vec2_t.new( 0, 0 )
        },
        sizes = {
            picker = vec2_t.new( 0, 0 ),
            hue_slider = vec2_t.new( 0, 0 ),
            alpha_slider = vec2_t.new( 0, 0 ),
            copy_button = vec2_t.new( 0, 0 ),
            paste_button = vec2_t.new( 0, 0 )
        }
    }

    colorpicker.changing = {
        main = false,
        hue = false,
        alpha = false
    }

    colorpicker.clicked_outside = false

    function colorpicker:get( )
        return colorpicker.color
    end

    function colorpicker:set( new_color )
        colorpicker.color = new_color

        colorpicker.hue, colorpicker.saturation, colorpicker.brightness = rgb_to_hsb( colorpicker.color )
        colorpicker.alpha = colorpicker.color.a
    end

    function colorpicker:set_visible( boolean )
        colorpicker.visible = boolean
    end

    function colorpicker:in_bounds( pos, width )
        if not self.visible or not self.parent.visible then
            return false, vec2_t.new( 0, 0 )
        end

        local start_pos = pos + vec2_t.new( width - 10 - self.size.x, 0 )

        return input.is_mouse_in_bounds( start_pos, self.size ), self.size + vec2_t.new( 5, 0 )
    end

    function colorpicker:handle( pos, width, interacting )
        if not self.visible or not self.parent.visible then
            return false
        end

        local gui_y = self.parent.gui.pos.y

        if pos.y < gui_y then
            self.open = false
            self.changing = {
                main = false,
                hue = false,
                alpha = false
            }

            return false
        end

        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local in_bounds = self:in_bounds( pos, width )

        if in_bounds and is_mouse_1_pressed then
            self.open = not self.open

            return true
        end

        local in_picker_bounds = input.is_mouse_in_bounds( self.stored.positions.window, self.picker_size )

        if not in_bounds and not in_picker_bounds and is_mouse_1_pressed then
            self.open = false
        end

        if self.open then
            local is_mouse_1_held = input.is_key_held( e_keys.MOUSE_LEFT )

            local picker_start = self.stored.positions.picker
            local picker_size  = self.stored.sizes.picker

            local hue_start = self.stored.positions.hue_slider
            local hue_size  = self.stored.sizes.hue_slider

            local alpha_start = self.stored.positions.alpha_slider
            local alpha_size  = self.stored.sizes.alpha_slider

            local in_color_bounds = {
                main = input.is_mouse_in_bounds( picker_start, picker_size ),
                hue = input.is_mouse_in_bounds( hue_start, hue_size ),
                alpha = input.is_mouse_in_bounds( alpha_start, alpha_size )
            }

            if is_mouse_1_pressed and not in_color_bounds.main  and
                                    not in_color_bounds.hue   and
                                    not in_color_bounds.alpha then
                self.clicked_outside = true
            end

            local mouse_pos = input.get_mouse_pos( )

            if not self.clicked_outside then
                if self.changing.main or ( is_mouse_1_held and in_color_bounds.main and not self.changing.alpha and not self.changing.hue ) then
                    self.changing.main = true

                    local main_perc = vec2_t.new(
                        ( mouse_pos.x - picker_start.x ) / picker_size.x,
                        ( mouse_pos.y - picker_start.y ) / picker_size.y
                    )

                    self.saturation = math.clamp( main_perc.x, 0, 1 )
                    self.brightness = 1 - math.clamp( main_perc.y, 0, 1 )
                elseif self.changing.hue or ( is_mouse_1_held and in_color_bounds.hue and not self.changing.alpha ) then
                    self.changing.hue = true

                    local hue_perc = ( mouse_pos.x - hue_start.x ) / hue_size.x

                    self.hue = math.clamp( hue_perc, 0, 1 ) * 360

                    self.color = hsb_to_rgb( self.hue, self.saturation, self.brightness )
                elseif self.changing.alpha or ( is_mouse_1_held and in_color_bounds.alpha ) then
                    self.changing.alpha = true

                    local alpha_perc = ( mouse_pos.x - alpha_start.x ) / alpha_size.x

                    self.alpha = math.clamp( alpha_perc, 0, 1 ) * 255
                end
            end

            if self.changing.main or self.changing.hue or self.changing.alpha then
                self:invoke_callbacks( )
            end

            if not is_mouse_1_held and not is_mouse_1_pressed then
                self.changing.main = false
                self.changing.hue = false
                self.changing.alpha = false

                colorpicker.clicked_outside = false
            end

            self.color = hsb_to_rgb( self.hue, self.saturation, self.brightness )
            self.color.a = math.floor( self.alpha + 0.5 )

            local in_button_bounds = {
                copy = input.is_mouse_in_bounds( self.stored.positions.copy_button, self.stored.sizes.copy_button ),
                paste = input.is_mouse_in_bounds( self.stored.positions.paste_button, self.stored.sizes.paste_button )
            }

            if is_mouse_1_pressed and in_button_bounds.copy then
                self.hue, self.saturation, self.brightness = rgb_to_hsb( self.color )

                local color = color_t.new(
                    self.color.r,
                    self.color.g,
                    self.color.b,
                    math.floor( self.alpha )
                )

                self.parent.gui:set_stored_color( color )
                self:invoke_callbacks( )
            end

            if is_mouse_1_pressed and in_button_bounds.paste then
                local rgb_color = self.parent.gui:get_stored_color( )
            
                if rgb_color ~= nil then
                    self.hue, self.saturation, self.brightness = rgb_to_hsb( rgb_color )
                    self.alpha = rgb_color.a

                    self:invoke_callbacks( )
                end
            end
        end

        if self.changing.main or self.changing.hue or self.changing.alpha then
            self:invoke_callbacks( )
        end

        return self.open
    end

    function colorpicker:render( pos, width, interacting )
        if not self.visible or not self.parent.visible then
            return
        end

        local gui_y = self.parent.gui.pos.y

        if pos.y < gui_y then
            return
        end

        local start_pos = pos + vec2_t.new( width - 10 - self.size.x, 1 )

        local in_bounds = input.is_mouse_in_bounds( start_pos, self.size )

        local outline_color = in_bounds and self.parent.gui.colors.hovering_outline or
                                            self.parent.gui.colors.inactive_outline
                                
        -- render bind box
        render.rect_filled(
            start_pos,
            self.size,
            self.color,
            3
        )

        -- render bind outline
        render.rect(
            start_pos,
            self.size,
            outline_color,
            3
        )

        if self.open then
            self.stored.positions.window = start_pos + vec2_t.new( self.size.x + 5, 0 )

            -- render bg
            render.rect_filled(
                self.stored.positions.window,
                self.picker_size,
                self.parent.gui.colors.subtab_background,
                3
            )


            -- black outline
            render.rect(
                self.stored.positions.window,
                self.picker_size,
                self.parent.gui.colors.black,
                3
            )

            local picker_start = self.stored.positions.window + vec2_t.new( ( self.picker_size.x - self.picker_area.x ) / 2, ( self.picker_size.x - self.picker_area.x ) / 2 )
            colorpicker.stored.positions.picker = vec2_t.new( picker_start.x, picker_start.y )

            -- render black to white area
            render.rect_fade(
                picker_start,
                self.picker_area,
                self.parent.gui.colors.white,
                self.parent.gui.colors.black,
                false
            )

            -- render current hue 0 -> 255 opacity
            local color = hue_to_rgb( self.hue )
            local color2 = color_t.new( color.r, color.g, color.b, 0 )

            render.rect_fade(
                picker_start,
                self.picker_area,
                color2,
                color,
                true
            )

            -- render black to white area
            render.rect_fade(
                picker_start,
                self.picker_area,
                self.parent.gui.colors.black10,
                self.parent.gui.colors.black,
                false
            )

            -- render the picker head
            local picker_head_start = picker_start + vec2_t.new(
                math.floor( self.saturation * self.picker_area.x + 0.5 ),
                math.floor( ( 1 - self.brightness ) * self.picker_area.y + 0.5 )
            )

            render.circle_filled(
                picker_head_start,
                3,
                self.parent.gui.colors.white
            )

            -- render the hue slider
            local hue_slider_start = picker_start + vec2_t.new( 0, self.picker_area.y + 5 )
            local hue_slider_size = vec2_t.new( self.picker_area.x, 10 )
            colorpicker.stored.positions.hue_slider = vec2_t.new( hue_slider_start.x, hue_slider_start.y )

            for i = 0, 300, 60 do
                local color_1 = hue_to_rgb( i )
                local color_2 = hue_to_rgb( i + 60 )

                render.rect_fade(
                    hue_slider_start + vec2_t.new( math.floor( i / 360 * hue_slider_size.x + 0.5 ), 0 ),
                    vec2_t.new( hue_slider_size.x / 6 + ( i == 300 and 1 or 5 ), hue_slider_size.y ),
                    color_1,
                    color_2,
                    true
                )
            end
            
            render.rect(
                hue_slider_start,
                hue_slider_size,
                self.parent.gui.colors.black,
                2
            )

            -- render hue head
            local hue_head_start = hue_slider_start + vec2_t.new( math.floor( self.hue / 360 * hue_slider_size.x + 0.5 ), -2 )
            local hue_head_size = vec2_t.new( 3, hue_slider_size.y + 4 )

            render.rect_filled(
                hue_head_start,
                hue_head_size,
                self.parent.gui.colors.white
            )
            render.rect(
                hue_head_start,
                hue_head_size,
                self.parent.gui.colors.black
            )

            -- render alpha slider
            local alpha_slider_start = hue_slider_start + vec2_t.new( 0, hue_slider_size.y + 5 )
            local alpha_slider_size = vec2_t.new( self.picker_area.x, 10 )
            colorpicker.stored.positions.alpha_slider = vec2_t.new( alpha_slider_start.x, alpha_slider_start.y )

            render.rect_fade(
                alpha_slider_start,
                alpha_slider_size,
                color_t.new( self.color.r, self.color.g, self.color.b, 0 ),
                color_t.new( self.color.r, self.color.g, self.color.b, 255 ),
                true
            )
            -- outline
            render.rect(
                alpha_slider_start,
                alpha_slider_size,
                self.parent.gui.colors.black,
                2
            )

            -- render alpha head
            local alpha_head_start = alpha_slider_start + vec2_t.new( math.floor( self.alpha / 255 * alpha_slider_size.x + 0.5 ), -2 )
            local alpha_head_size = vec2_t.new( 3, alpha_slider_size.y + 4 )

            render.rect_filled(
                alpha_head_start,
                alpha_head_size,
                self.parent.gui.colors.white
            )

            render.rect(
                alpha_head_start,
                alpha_head_size,
                self.parent.gui.colors.black
            )

            local buttons_start = alpha_slider_start + vec2_t.new( 0, alpha_slider_size.y + 5 )
            -- current color represented as hex
            -- bg for it
            local hex_representation_start = buttons_start
            local hex_representation_size = vec2_t.new( ( self.picker_area.x - 10 ) / 2, 19 )

            local hex_text = rbg_to_hex( self.color )
            
            render.rect_filled(
                hex_representation_start,
                hex_representation_size,
                self.parent.gui.colors.dark_background
            )

            render.rect(
                hex_representation_start,
                hex_representation_size,
                self.parent.gui.colors.black,
                2
            )

            -- render hex text
            render.text(
                fonts.default,
                hex_text,
                hex_representation_start + vec2_t.new( 
                    math.floor( hex_representation_size.x / 2 ),
                    math.floor( hex_representation_size.y / 2 ) - 1
                ),
                self.parent.gui.colors.inactive_text,
                true
            )

            -- copy and paste button
            local buttons = { 'Copy', 'Paste' }
            local button_start = hex_representation_start + vec2_t.new( hex_representation_size.x + 5, 0 )
            local button_size = vec2_t.new( hex_representation_size.x / 2, hex_representation_size.y )
            for i = 1, 2 do
                local in_copy_bounds = input.is_mouse_in_bounds( button_start, button_size )
    
                local copy_button_color = in_copy_bounds and self.parent.gui.colors.hovering_outline or
                                                            self.parent.gui.colors.inactive_outline
    
                render.rect_filled(
                    button_start,
                    button_size,
                    copy_button_color,
                    2
                )
    
                render.rect(
                    button_start,
                    button_size,
                    self.parent.gui.colors.black,
                    2
                )
    
                render.text(
                    fonts.default,
                    buttons[ i ],
                    button_start + vec2_t.new(
                        math.floor( button_size.x / 2 ) + 1,
                        math.floor( button_size.y / 2 ) - 1
                    ),
                    self.parent.gui.colors.inactive_text,
                    true
                )

                if i == 1 then
                    colorpicker.stored.positions.copy_button = vec2_t.new( button_start.x, button_start.y )
                else
                    colorpicker.stored.positions.paste_button = vec2_t.new( button_start.x, button_start.y )
                end

                button_start.x = button_start.x + button_size.x + 5
            end

            colorpicker.stored.sizes.picker = self.picker_area
            colorpicker.stored.sizes.hue_slider = hue_slider_size
            colorpicker.stored.sizes.alpha_slider = alpha_slider_size
            colorpicker.stored.sizes.copy_button = button_size
            colorpicker.stored.sizes.paste_button = button_size
        end
    end

    function colorpicker:to_string( )
        return string.format( '[ colorpicker ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, self.color )
    end

    return colorpicker
end

function elements.create_checkbox( gui_obj, page, tab, section, name, o_default_state )
    local checkbox = { _type = element_types.checkbox }

    checkbox.gui = gui_obj

    checkbox.page = page
    checkbox.tab = tab
    checkbox.section = section
    checkbox.name = name
    checkbox.state = o_default_state

    if checkbox.state == nil then
        checkbox.state = false
    end

    checkbox.visible = true
    checkbox.render_topmost = false

    checkbox.check_size = vec2_t.new( 13, 13 )

    checkbox.visibility_callbacks = { }
    checkbox.visibility_requirements = { }

    checkbox.callbacks = { }
    
    function checkbox:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function checkbox:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function checkbox:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end
    
    function checkbox:set_visibility_requirement( ... )
        local args = { ... }

        set_visibility_requirement( self, args )
    end

    checkbox.extras = { }

    function checkbox:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function checkbox:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function checkbox:get_visual_height( )
        if not checkbox.visible then
            return 0
        end

        return 20
    end

    function checkbox:click( )
        self.state = not self.state

        self:invoke_callbacks( )
    end

    function checkbox:set( boolean )
        self.state = boolean

        self:invoke_callbacks( )
    end

    function checkbox:set_visible( boolean )
        self.visible = boolean
    end

    function checkbox:get( )
        return self.state
    end
                                                    
    function checkbox:handle( pos, width )
        if not self.visible then
            return false
        end

        if pos.y < self.gui.pos.y then
            return false
        end


        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local in_bounds = input.is_mouse_in_bounds( pos, vec2_t.new( width, checkbox:get_visual_height( ) ) )

        if in_bounds and is_mouse_1_pressed then
            self:click( )

            return true
        end

        return false
    end

    function checkbox:render( pos, width, interacting )
        if not checkbox.visible then
            return
        end

        local size = vec2_t.new( width, checkbox:get_visual_height( ) )
        local in_bounds = input.is_mouse_in_bounds( pos, size ) or interacting

        -- checkbox background
        local checkbox_start = pos + vec2_t.new( 10, 0 )

        local gui_y = self.gui.pos.y

        if checkbox_start.y > gui_y then
            local outline_color = checkbox.state and self.gui.colors.active_outline or
                                in_bounds and self.gui.colors.hovering_outline or
                                                self.gui.colors.inactive_outline

            -- render outline
            render.rect(
                checkbox_start,
                checkbox.check_size,
                outline_color,
                2
            )

            -- render inside
            render.rect_filled(
                checkbox_start + vec2_t.new( 1, 1 ),
                checkbox.check_size - vec2_t.new( 2, 2 ),
                self.gui.colors.dark_background
            )

            if checkbox.state then
                -- render check
                render.rect_filled(
                    checkbox_start + vec2_t.new( 2, 2 ),
                    checkbox.check_size - vec2_t.new( 4, 4 ),
                    colors.accent,
                    1
                )
            end

            render.push_clip( checkbox_start, vec2_t.new( width - 10, 15 ) )
            -- render text
            local text_color = checkbox.state and self.gui.colors.active_text or
                            in_bounds  and self.gui.colors.hovering_text or
                                            self.gui.colors.inactive_text
            local text_start = checkbox_start + vec2_t.new( checkbox.check_size.x + 5, 0 )
            render.text(
                fonts.element,
                checkbox.name,
                text_start,
                text_color
            )

            render.pop_clip( )
        end
    end

    function checkbox:to_string( )
        return string.format( '[ checkbox ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, self.state )
    end

    return checkbox
end

function elements.create_slider( gui_obj, page, tab, section, name, min, max, default, suffix )
    local slider = { _type = element_types.slider }

    slider.gui = gui_obj

    slider.page = page
    slider.tab = tab
    slider.section = section
    slider.name = name
    slider.min = math.min( min, max )
    slider.max = math.max( min, max )
    slider.value = math.min( math.max( default, slider.min ), slider.max )
    slider.visual_value = slider.value
    slider.suffix = suffix == nil and "" or suffix

    slider.render_topmost = false
    slider.visible = true

    slider.height = 13
    slider.title_width = render.get_text_size( fonts.element, slider.name ).x
    slider.delta = slider.max - slider.min

    slider.heights = {
        text = 16,
        slider = 13
    }

    slider.visibility_callbacks = { }
    slider.visibility_requirements = { }

    slider.callbacks = { }
    
    function slider:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function slider:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function slider:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end
    
    function slider:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    slider.extras = { }

    function slider:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function slider:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function slider:get_visual_height( )
        if not slider.visible then
            return 0
        end

        return slider.heights.text + slider.heights.slider + 3
    end

    function slider:set( value )
        slider.value = math.min( math.max( value, slider.min ), slider.max )
    end

    function slider:set_visible( boolean )
        slider.visible = boolean
    end

    function slider:get( )
        return slider.value
    end

    function slider:handle( pos, width, interacting )
        if not slider.visible then
            return false
        end

        local gui_y = self.gui.pos.y

        if pos.y < gui_y then
            return false
        end

        local is_mouse_1_held = input.is_key_held( e_keys.MOUSE_LEFT )
        -- in SLIDER bounds not the whole element ok?
        local in_bounds = input.is_mouse_in_bounds( pos + vec2_t( 0, slider.heights.text ), vec2_t.new( width - 10, slider.heights.slider ) )


        if ( in_bounds and is_mouse_1_held ) or interacting then
            local mouse_pos = input.get_mouse_pos( ) - vec2_t( 5, 0 )

            if mouse_pos.x < pos.x then
                slider.value = slider.min
                return
            end

            if mouse_pos.x > pos.x + ( width - 20 ) then
                slider.value = slider.max
                return
            end

            local difference = mouse_pos.x - pos.x
            local percentage = difference / ( width - 20 )

            slider.value = math.floor( slider.min + ( slider.max - slider.min ) * percentage + 0.5 )

            self:invoke_callbacks( )

            return true
        end

        return false
    end

    function slider:render( pos, width, interacting )
        if not slider.visible then
            return
        end

        local gui_y = self.gui.pos.y

        if pos.y > gui_y then
            -- render slider title
            render.text(
                fonts.element,
                slider.name,
                pos + vec2_t.new( 10, 0 ),
                self.gui.colors.hovering_text
            )

            render.text(
                fonts.element,
                ' - ' .. slider.value .. slider.suffix,
                pos + vec2_t.new( 10 + slider.title_width, 0 ),
                self.gui.colors.white100
            )
        end
    
        local size = vec2_t.new( width - 20, slider.heights.slider )
        local slider_start = pos + vec2_t.new( 10, slider.heights.text )

        local in_bounds = input.is_mouse_in_bounds( slider_start - vec2_t( 10, 0 ), size + vec2_t.new( 10, 0 ) ) or interacting

        local outline_color = in_bounds and self.gui.colors.hovering_outline or
                                            self.gui.colors.inactive_outline

        if slider_start.y > gui_y then
            -- render slider background
            render.rect_filled(
                slider_start,
                size,
                self.gui.colors.dark_background,
                3
            )

            -- render slider outline
            render.rect(
                slider_start,
                size,
                outline_color,
                3
            )

            slider.visual_value = slider.visual_value + ( slider.value - slider.visual_value ) * 0.1

            -- render slider ( the colored bar thing )
            local percentage = ( slider.visual_value - slider.min ) / slider.delta
            local slider_size = vec2_t.new( percentage * ( size.x - 4 ), slider.heights.slider - 4 )

            if slider_size.x < 4 then
                slider_size.x = 4
            end

            local has_middle_line = slider.min < 0 and slider.max > 0

            if has_middle_line then
                local perc = math.abs( slider.min ) / slider.delta
                local center_pos = slider_start + vec2_t.new( perc * size.x, 0 )
                local line_pos = center_pos

                local actual_size = vec2_t.new( slider.visual_value / slider.delta * size.x, slider_size.y )

                if actual_size.x < 0 then
                    actual_size.x = ( actual_size.x - 1 )
                    center_pos = center_pos + vec2_t.new( actual_size.x, 0 )
                    center_pos.x = center_pos.x + 2
                    actual_size.x = math.abs( actual_size.x )
                end

                if actual_size.x ~= 0 then
                    -- render slider from center pos
                    render.rect_filled(
                        center_pos + vec2_t.new( 1, 2 ),
                        actual_size - vec2_t.new( 2, 0 ),
                        colors.accent,
                        2
                    )

                    -- render slider line
                    render.rect_filled(
                        line_pos,
                        vec2_t.new( 2, size.y ),
                        outline_color
                    )
                end
            else
                render.rect_filled(
                    slider_start + vec2_t.new( 2, 2 ),
                    slider_size,
                    colors.accent,
                    2
                )
            end
        end
    end

    function slider:to_string( )
        return string.format( '[ slider ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, self.value )
    end

    return slider
end

function elements.create_combo( gui_obj, page, tab, section, name, items, default_value )
    local combo = { _type = element_types.combo }

    combo.gui = gui_obj

    combo.page = page
    combo.tab = tab
    combo.section = section
    combo.name = name

    combo.visible = true

    combo.items = items

    combo.name_to_index = { }

    for i = 1, #items do
        local item = items[ i ]
        combo.name_to_index[ item ] = i
    end

    combo.value = default_value == nil and 1 or
                type( default_value ) == "string" and combo.name_to_index[ default_value ] or
                default_value

    combo.open = false
    combo.render_topmost = true

    combo.last_interaction_time = 0
    combo.open_time = 0.5

    combo.heights = {
        text = 16,
        combo = 18,
        item = 18
    }

    combo.visibility_callbacks = { }
    combo.visibility_requirements = { }

    combo.callbacks = { }
    
    function combo:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function combo:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function combo:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function combo:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    combo.extras = { }

    function combo:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function combo:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end


    function combo:get_visual_height( )
        if not self.visible then
            return 0
        end

        return 40
    end

    function combo:set_visible( boolean )
        self.visible = boolean
    end

    function combo:set( new_value )
        if type( new_value ) == "string" then
            self.value = self.name_to_index[ new_value ] or 1
        elseif type( new_value ) == "number" then
            self.value = new_value
        else
            self.value = 1
        end

        self:invoke_callbacks( )
    end

    function combo:get( )
        return self.value, self.items[ self.value ]
    end

    function combo:update_items( new_items )
        self.items = new_items

        self.name_to_index = { }

        for i = 1, #new_items do
            local item = new_items[ i ]
            self.name_to_index[ item ] = i
        end

        self.value = 1
    end

    function combo:get_items( )
        return self.items
    end

    function combo:handle( pos, width, interacting )
        if not self.visible then
            return false
        end

        local gui_y = self.gui.pos.y

        if pos.y < gui_y then
            self.open = false
        
            return false
        end

        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local in_combo_open_close_bounds = input.is_mouse_in_bounds( pos + vec2_t( 0, combo.heights.text ), vec2_t.new( width, self.heights.combo ) )
        local in_combo_bounds = input.is_mouse_in_bounds( pos + vec2_t( 0, self.heights.text + self.heights.item ), vec2_t.new( width, self.heights.item * #self.items ) )

        local animation_stopped = ( globals.real_time( ) - self.last_interaction_time ) / self.open_time >= .5

        if in_combo_open_close_bounds and is_mouse_1_pressed then
            self.open = not self.open

            self.last_interaction_time = globals.real_time( )

            return true
        elseif animation_stopped and in_combo_bounds and is_mouse_1_pressed and self.open then
            local mouse_pos = input.get_mouse_pos( )

            local difference = mouse_pos.y - pos.y - ( self.heights.text + self.heights.item ) - 1
            local index = math.floor( difference / self.heights.item ) + 1

            self:set( index )
            self.open = false

            self.last_interaction_time = globals.real_time( )

            return true
        elseif is_mouse_1_pressed and self.open then
            self.open = false

            self.last_interaction_time = globals.real_time( )
        end

        return not animation_stopped
    end

    function combo:render( pos, width, interacting )
        if not self.visible then
            return
        end

        local gui_y = self.gui.pos.y

        if pos.y > gui_y then
            -- render combo title
            render.text(
                fonts.element,
                self.name,
                pos + vec2_t.new( 10, 0 ),
                self.gui.colors.hovering_text
            )
        end

        local size = vec2_t.new( width - 20, self.heights.combo )
        local combo_start = pos + vec2_t.new( 10, self.heights.text )

        local in_bounds = input.is_mouse_in_bounds( combo_start - vec2_t( 10, 0 ), size + vec2_t.new( 10, 0 ) ) or interacting

        local outline_color = ( in_bounds or self.open ) and self.gui.colors.hovering_outline or
                                            self.gui.colors.inactive_outline

        local animation_delta = ( globals.real_time( ) - self.last_interaction_time ) / self.open_time
        local animation_percentage = ease.out_exponent( animation_delta )

        if not self.open then
            animation_percentage = 1 - animation_percentage
        end

        -- if open or animating then make the size fit elements
        if self.open or animation_delta < 1 then
            size.y = size.y * ( #self.items + 1 )
        end

        -- open and close animation logic
        if animation_delta < 1 or self.open then
            size.y = size.y * animation_percentage

            -- we still want to render the base combo
            if size.y < 18 then
                size.y = 18
            end
        end

        local clip_start_y = math.max( combo_start.y, gui_y )

        -- clip it so text doesnt go outside of the combo
        render.push_clip( vec2_t.new( combo_start.x, clip_start_y ), size - vec2_t( 1, 1 ) ) -- -1 so it doesnt clip text ( sorry it infuriates me so much )
        -- https://wxcoy.cc/fail/79eb8cc7-653c-4a06-a388-971e04a7963e LOOK HOW MUCH BETTER IT LOOKS

        if combo_start.y + size.y > gui_y then
            -- render combo background
            render.rect_filled(
                combo_start,
                size,
                self.gui.colors.dark_background,
                3
            )

            -- render combo outline
            render.rect(
                combo_start,
                size - vec2_t.new( 1, 1 ),
                outline_color,
                3
            )

            -- render combo current selection 
            local text_color = in_bounds and self.gui.colors.hovering_text or
                                            self.gui.colors.inactive_text
            
            combo_start.y = combo_start.y + 1 -- text y offset so it looks nicer :D

            self.value = math.clamp( self.value, 1, #self.items )

            render.text(
                fonts.element,
                self.items[ self.value ],
                combo_start + vec2_t.new( 8, 0 ),
                text_color
            )

        end
        render.pop_clip( )

        if animation_delta < 1 or self.open then
            -- clip it so text doesnt go outside of the combo
            render.push_clip( combo_start, size - vec2_t( 1, 1 ) ) 

            -- render every element
            for i = 1, #self.items do
                local item = self.items[ i ]

                local item_pos = combo_start + vec2_t.new( 0, self.heights.item * i )

                local in_selection_bounds = input.is_mouse_in_bounds( item_pos, vec2_t.new( size.x, self.heights.item ) )

                local item_color = i == self.value     and colors.accent        or
                                in_selection_bounds and self.gui.colors.hovering_text or
                                                        self.gui.colors.inactive_text

                if item_pos.y > gui_y then
                    render.text(
                        fonts.element,
                        item,
                        item_pos + vec2_t.new( 8, 0 ),
                        item_color
                    )
                end
            end

            render.pop_clip( )
        end
        
        if combo_start.y > gui_y then
            -- rect fade the end so we dont see items text actually going off screen
            render.rect_fade(
                combo_start + vec2_t.new( size.x - 60, 1 ),
                vec2_t.new( 58, size.y - 4 ),
                color_t.new( self.gui.colors.dark_background.r, self.gui.colors.dark_background.g, self.gui.colors.dark_background.b, 0 ),
                self.gui.colors.dark_background,
                true
            )

            -- animated line to seperate current element and items
            if animation_delta < 1 or self.open then
                local line_color = color_t.new(
                    math.floor( outline_color.r ),
                    math.floor( outline_color.g ),
                    math.floor( outline_color.b ),
                    math.floor( math.clamp( 255 * animation_percentage, 0, 255 ) )
                )

                render.line(
                    combo_start + vec2_t.new( size.x / 2 * ( 1 - animation_percentage ), self.heights.item ),
                    combo_start + vec2_t.new( size.x / 2 + animation_percentage * size.x / 2, self.heights.item ),
                    line_color
                )
            end
        end

        -- render little arrow on the right to indicate opened or closed state
        local arrow_color = in_bounds and self.gui.colors.hovering_text or
        self.gui.colors.inactive_text

        local arrow_size  = vec2_t.new( 6, 3 )
        local arrow_start = combo_start + vec2_t.new( size.x - arrow_size.x * 2, 0 )
        local arrow_pos   = arrow_start + vec2_t.new( 0, 6 )

        local arrow_points = {
            vec2_t.new( arrow_pos.x, arrow_pos.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x, arrow_pos.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x / 2, arrow_pos.y + arrow_size.y )
        }

        local inverted_points = {
            vec2_t.new( arrow_pos.x + 1, arrow_pos.y + arrow_size.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x - 1, arrow_pos.y + arrow_size.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x / 2, arrow_pos.y + 1 )
        }

        if arrow_pos.y > gui_y then
            render.polygon( self.open and inverted_points or arrow_points, arrow_color )
        end

        render.pop_clip( )
    end

    function combo:to_string( )
        return string.format( '[ combo ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, self.items[ self.value ] )
    end

    return combo
end

function elements.create_multi_combo( gui_obj, page, tab, section, name, items, default_value_s )
    local multicombo = { _type = element_types.multicombo }

    multicombo.gui = gui_obj

    multicombo.page = page
    multicombo.tab = tab
    multicombo.section = section
    multicombo.name = name

    multicombo.visible = true

    multicombo.items = items

    multicombo.name_to_index = { }

    multicombo.open = false
    multicombo.render_topmost = true

    multicombo.last_interaction_time = 0
    multicombo.open_time = 0.5

    multicombo.heights = {
        text = 16,
        combo = 18,
        item = 18,
        lower_pad = 3
    }

    multicombo.visibility_callbacks = { }
    multicombo.visibility_requirements = { }

    multicombo.callbacks = { }
    
    function multicombo:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function multicombo:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function multicombo:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function multicombo:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    multicombo.extras = { }

    function multicombo:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function multicombo:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    multicombo.values = { }
    for i = 1, #items do
        local item = items[ i ]
        multicombo.name_to_index[ item ] = i
        multicombo.values[ i ] = false
    end
 
    if default_value_s == nil then
        -- do nun
    elseif type( default_value_s ) == 'string' then
        local index = multicombo.name_to_index[ default_value_s ]

        if index ~= nil then 
            multicombo.values[ index ] = true
        end
    elseif type( default_value_s ) == 'number' then
        multicombo.values[ default_value_s ] = true
    elseif type( default_value_s ) == 'table' then
        for i = 1, #default_value_s do
            local value = default_value_s[ i ]

            if type( value ) == 'number' then
                multicombo.values[ value ] = true
            else
                local index = multicombo.name_to_index[ default_value_s ]

                if index ~= nil then 
                    multicombo.values[ index ] = true
                end
            end
        end
    end -- i wanted to do bitwise but then lua said no, https://wxcoy.cc/fail/1ec14ec2-a6fb-4dbb-95d2-36dc9a517cac cool thing supporting my claim on why i didnt want to do it bitwise!

    function multicombo:get_visual_height( )
        if not self.visible then
            return 0
        end

        return self.heights.text + self.heights.combo + self.heights.lower_pad
    end

    function multicombo:set_visible( boolean )
        self.visible = boolean
    end

    function multicombo:set( name_or_index, boolean )
        if type( name_or_index ) == "string" then
            name_or_index = self.name_to_index[ name_or_index ]
        end

        self.values[ name_or_index ] = boolean

        self:invoke_callbacks( )
    end

    function multicombo:toggle( name_or_index )
        if type( name_or_index ) == "string" then
            name_or_index = self.name_to_index[ name_or_index ]
        end

        self.values[ name_or_index ] = not self.values[ name_or_index ]

        self:invoke_callbacks( )
    end

    function multicombo:get( name_or_index )
        if type( name_or_index ) == "string" then
            name_or_index = self.name_to_index[ name_or_index ]
        end
        
        return self.values[ name_or_index ]
    end

    function multicombo:get_items( )
        return self.items
    end

    function multicombo:update_items( new_items )
        self.items = new_items
        self.values = { }
        self.name_to_index = { }
    
        for i = 1, #new_items do
            local item = new_items[ i ]
            self.name_to_index[ item ] = i
            self.values[ i ] = false
        end
    end

    function multicombo:handle( pos, width, interacting )
        if not self.visible then
            return false
        end

        local gui_y = self.gui.pos.y

        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local open_close_start = pos + vec2_t( 0, self.heights.text )
        local in_combo_open_close_bounds = input.is_mouse_in_bounds( open_close_start, vec2_t.new( width, self.heights.combo ) )
        local combo_start = pos + vec2_t( 0, self.heights.text + self.heights.item )
        local in_combo_bounds = input.is_mouse_in_bounds( combo_start, vec2_t.new( width, self.heights.item * #self.items ) )

        local animation_stopped = ( globals.real_time( ) - self.last_interaction_time ) / self.open_time >= .5

        -- select all button
        local all_selected = true
        for i = 1, #self.values do
            if not self.values[ i ] then
                all_selected = false
                break
            end
        end

        local text_size = render.get_text_size( fonts.element, all_selected and 'deselect all' or 'select all' )
        local bg_start = pos + vec2_t.new( width, self.heights.text ) - vec2_t.new( text_size.x + 10 + 12 + 10, 0 )
        local bg_size = vec2_t.new( text_size.x, self.heights.combo )
    
        local in_select_all_bounds = input.is_mouse_in_bounds( bg_start, bg_size )
        if in_select_all_bounds and is_mouse_1_pressed and animation_stopped and self.open then
            for i = 1, #self.items do
                self:set( i, not all_selected )
            end

            self.open = false
            self.last_interaction_time = globals.real_time( )

            return true
        end

        if combo_start.y < gui_y then
            self.open = false
        
            return false
        end

        if in_combo_open_close_bounds and is_mouse_1_pressed and open_close_start.y > gui_y then
            self.open = not self.open

            self.last_interaction_time = globals.real_time( )

            return true
        elseif animation_stopped and in_combo_bounds and is_mouse_1_pressed and self.open and combo_start.y > gui_y then
            local mouse_pos = input.get_mouse_pos( )

            local difference = mouse_pos.y - pos.y - ( self.heights.text + self.heights.item ) - 1
            local index = math.floor( difference / self.heights.item ) + 1

            self:toggle( index )

            return true
        elseif is_mouse_1_pressed and self.open then
            self.open = false

            self.last_interaction_time = globals.real_time( )
        end

        return ( not animation_stopped ) or ( self.open and in_combo_bounds )
    end

    function multicombo:render( pos, width, interacting )
        if not self.visible then
            return
        end

        local gui_y = self.gui.pos.y

        if pos.y > gui_y then
            -- render combo title
            render.text(
                fonts.element,
                self.name,
                pos + vec2_t.new( 10, 0 ),
                self.gui.colors.hovering_text
            )
        end

        local size = vec2_t.new( width - 20, self.heights.combo )
        local combo_start = pos + vec2_t.new( 10, self.heights.text )

        if combo_start.y < gui_y then
            return
        end

        local in_bounds = input.is_mouse_in_bounds( combo_start - vec2_t( 10, 0 ), size + vec2_t.new( 10, 0 ) ) or interacting

        local outline_color = ( in_bounds or self.open ) and self.gui.colors.hovering_outline or
                                            self.gui.colors.inactive_outline

        local animation_delta = ( globals.real_time( ) - self.last_interaction_time ) / self.open_time
        local animation_percentage = ease.out_exponent( animation_delta )

        if not self.open then
            animation_percentage = 1 - animation_percentage
        end

        -- if open or animating then make the size fit elements
        if self.open or animation_delta < 1 then
            size.y = size.y * ( #self.items + 1 )
        end

        -- open and close animation logic
        if animation_delta < 1 or self.open then
            size.y = size.y * animation_percentage

            -- we still want to render the base combo
            if size.y < 18 then
                size.y = 18
            end
        end

        -- render combo background
        render.rect_filled(
            combo_start,
            size,
            self.gui.colors.dark_background,
            3
        )

        -- render combo outline
        render.rect(
            combo_start,
            size,
            outline_color,
            3
        )

        -- clip it so text doesnt go outside of the combo
        render.push_clip( combo_start, size - vec2_t( 1, 1 ) ) -- -1 so it doesnt clip text ( sorry it infuriates me so much )
        -- https://wxcoy.cc/fail/79eb8cc7-653c-4a06-a388-971e04a7963e LOOK HOW MUCH BETTER IT LOOKS

        -- render combo current selection 
        local text_color = ( in_bounds and not self.open ) and self.gui.colors.hovering_text or
                                        self.gui.colors.inactive_text
        
        combo_start.y = combo_start.y + 1 -- text y offset so it looks nicer :D
        
        -- render all items
        local items_text = { }

        for i = 1, #self.items do
            local selected = self.values[ i ]
            
            if selected then
                table.insert( items_text, self.items[ i ] )
            end
        end

        if #items_text == 0 then
            table.insert( items_text, '-' )
        end

        render.text(
            fonts.element,
            table.concat( items_text, ", " ),
            combo_start + vec2_t.new( 8, 0 ),
            text_color
        )

        if animation_delta < 1 or self.open then
            -- render every element
            for i = 1, #self.items do
                local item = self.items[ i ]

                local item_pos = combo_start + vec2_t.new( 0, self.heights.item * i )

                local in_selection_bounds = input.is_mouse_in_bounds( item_pos, vec2_t.new( size.x, self.heights.item ) )

                local selected = self.values[ i ]

                local item_color = selected and colors.accent or
                                   in_selection_bounds and self.gui.colors.hovering_text or
                                                           self.gui.colors.inactive_text

                render.text(
                    fonts.element,
                    item,
                    item_pos + vec2_t.new( 8, 0 ),
                    item_color
                )
            end
        end

        
        -- rect fade the end so we dont see items text actually going off screen
        render.rect_fade(
            combo_start + vec2_t.new( size.x - 60, 2 ),
            vec2_t.new( 59, size.y - 6 ),
            color_t.new( self.gui.colors.dark_background.r, self.gui.colors.dark_background.g, self.gui.colors.dark_background.b, 0 ),
            self.gui.colors.dark_background,
            true
        )

        -- render little arrow on the right to indicate opened or closed state
        local arrow_color = in_bounds and self.gui.colors.hovering_text or
                            self.gui.colors.inactive_text

        local arrow_size  = vec2_t.new( 6, 3 )
        local arrow_start = combo_start + vec2_t.new( size.x - arrow_size.x * 2, 0 )
        local arrow_pos   = arrow_start + vec2_t.new( 0, 6 )

        local arrow_points = {
            vec2_t.new( arrow_pos.x, arrow_pos.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x, arrow_pos.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x / 2, arrow_pos.y + arrow_size.y )
        }

        local inverted_points = {
            vec2_t.new( arrow_pos.x + 1, arrow_pos.y + arrow_size.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x - 1, arrow_pos.y + arrow_size.y ),
            vec2_t.new( arrow_pos.x + arrow_size.x / 2, arrow_pos.y + 1 )
        }

        if arrow_pos.y > gui_y then
            render.polygon( self.open and inverted_points or arrow_points, arrow_color )
        end

        -- select all button
        if animation_delta < 1 or self.open then
            local alpha = math.floor( math.clamp( animation_percentage * 255, 0, 255 ) )
            local all_selected = true
            for i = 1, #self.values do
                if not self.values[ i ] then
                    all_selected = false
                    break
                end
            end

            local text = all_selected and 'deselect all' or 'select all'
            local text_size = render.get_text_size( fonts.element, text )
            local text_pos = arrow_start - vec2_t.new( text_size.x + 8, -2   )

            local bg_start = text_pos - vec2_t.new( 6, 2 ) 
            local bg_size = vec2_t.new( text_size.x + 8 + 6, self.heights.combo )

            local bg_color = color_t.new( self.gui.colors.dark_background.r, self.gui.colors.dark_background.g, self.gui.colors.dark_background.b, alpha )

            render.rect_filled(
                bg_start,
                bg_size,
                bg_color,
                2
            )

            local line_color = color_t.new(
                self.gui.colors.active_outline.r,
                self.gui.colors.active_outline.g,
                self.gui.colors.active_outline.b,
                alpha
            )

            render.line(
                bg_start,
                bg_start + vec2_t.new( 0, bg_size.y ),
                line_color
            )

            local text_color = input.is_mouse_in_bounds( text_pos, bg_size ) and self.gui.colors.hovering_text or
                                                                                self.gui.colors.inactive_text

            text_color = color_t.new( text_color.r, text_color.g, text_color.b, alpha ) -- dont do it by reference tyty

            render.text(
                fonts.element,
                text,
                text_pos,
                text_color
            )
        end

        -- animated line to seperate current element and items
        if animation_delta < 1 or self.open then
            local line_color = color_t.new(
                math.floor( outline_color.r ),
                math.floor( outline_color.g ),
                math.floor( outline_color.b ),
                math.floor( 255 * animation_percentage )
            )

            render.line(
                combo_start + vec2_t.new( size.x / 2 * ( 1 - animation_percentage ), self.heights.item ),
                combo_start + vec2_t.new( size.x / 2 + animation_percentage * size.x / 2, self.heights.item ),
                line_color
            )
        end


        render.pop_clip( )
    end

    function multicombo:to_string( )
        return string.format( '[ multicombo ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, table.concat( self.values, ", " ) )
    end

    return multicombo
end

function elements.create_text_input( gui_obj, page, tab, section, name, default )
    local text_input = { _type = element_types.text_input }

    text_input.gui = gui_obj

    text_input.page = page
    text_input.tab = tab
    text_input.section = section
    text_input.name = name

    text_input.visible = true

    text_input.focusing = false

    text_input.heights = {
        text = 16,
        input = 18,
        lower_pad = 3
    }

    text_input.visibility_callbacks = { }
    text_input.visibility_requirements = { }

    text_input.callbacks = { }
    
    function text_input:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function text_input:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function text_input:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function text_input:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    text_input.extras = { }

    function text_input:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function text_input:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    text_input.render_topmost = false

    text_input.last_backspace_input = 0

    text_input.value = default or ""

    function text_input:set( text )
        text_input.value = text
    end

    function text_input:get( )
        return text_input.value
    end

    function text_input:set_visible( boolean )
        text_input.visible = boolean
    end

    function text_input:get_visual_height( )
        if not self.visible then
            return 0
        end

        return self.heights.text + self.heights.input + self.heights.lower_pad
    end

    function text_input:handle( pos, width, interacting )
        if not self.visible then
            return false
        end

        local gui_y = self.gui.pos.y

        local text_input_start = pos + vec2_t( 0, self.heights.text )

        if text_input_start.y < gui_y then
            self.focusing = false

            return false
        end

        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local in_bounds = input.is_mouse_in_bounds( text_input_start, vec2_t.new( width, self.heights.input ) )

        if in_bounds and is_mouse_1_pressed then
            self.focusing = true
        elseif is_mouse_1_pressed then
            self:invoke_callbacks( )
            self.focusing = false
        end

        if self.focusing then
            local is_backspace_pressed = input.is_key_pressed( e_keys.KEY_BACKSPACE )
            local is_enter_pressed = input.is_key_pressed( e_keys.KEY_ENTER )

            if is_backspace_pressed then
                self.last_backspace_input = globals.real_time( )
            end

            if is_backspace_pressed then
                self.value = self.value:sub( 1, #self.value - 1 )
            elseif is_enter_pressed then
                self:invoke_callbacks( )
                self.focusing = false
            else
                local input_text = input.get_input_text( )

                if input_text ~= "" then
                    self.value = self.value .. input_text
                end
            end

            local is_backspace_held = input.is_key_held( e_keys.KEY_BACKSPACE )

            if is_backspace_held and globals.real_time( ) - self.last_backspace_input > 0.15 then
                self.value = self.value:sub( 1, #self.value - 1 )
                self.last_backspace_input = globals.real_time( )
            end
        end

        return self.focusing
    end

    function text_input:render( pos, width, interacting )
        if not self.visible then
            return
        end

        local gui_y = self.gui.pos.y

        if pos.y > gui_y then
            -- render text input title
            render.text(
                fonts.element,
                self.name,
                pos + vec2_t.new( 10, 0 ),
                self.gui.colors.hovering_text
            )
        end

        local size = vec2_t.new( width - 20, self.heights.input )
        local input_start = pos + vec2_t.new( 10, self.heights.text )

        if input_start.y > gui_y then
            local in_bounds = input.is_mouse_in_bounds( input_start - vec2_t( 10, 0 ), size + vec2_t.new( 10, 0 ) ) or interacting

            local outline_color = in_bounds and self.gui.colors.hovering_outline or
                                                self.gui.colors.inactive_outline

            -- render text input background
            render.rect_filled(
                input_start,
                size,
                self.gui.colors.dark_background,
                3
            )

            -- render text input outline
            render.rect(
                input_start,
                size,
                outline_color,
                3
            )

            render.push_clip( input_start, size - vec2_t( 1, 1 ) ) -- -1 so it doesnt clip text ( sorry it infuriates me so much )

            local written_text = self.focusing and self.value .. ( globals.real_time( ) % 1 > 0.5 and "_" or "  " ) or
                                    self.value

            local text_width = render.get_text_size( fonts.element, written_text ).x

            if text_width > width - 25 then
                local difference = text_width - ( width - 35 )
                input_start.x = input_start.x - difference
            end

            -- render text input text
            local text_color = ( in_bounds or self.focusing ) and self.gui.colors.hovering_text or
                                            self.gui.colors.inactive_text

            render.text(
                fonts.element,
                written_text,
                input_start + vec2_t.new( 8, 1 ),
                text_color
            )

            render.pop_clip( )
        end
    end

    function text_input:to_string( )
        return string.format( '[ text_input ][ %s->%s->%s ] %s : %s', self.page, self.tab, self.section, self.name, self.value )
    end

    return text_input
end

function elements.create_text( gui_obj, page, tab, section, name )
    local text = { _type = element_types.text }

    text.gui = gui_obj

    text.page = page
    text.tab = tab
    text.section = section
    text.name = name

    text.visible = true
    text.render_topmost = false

    text.visibility_callbacks = { }
    text.visibility_requirements = { }

    text.callbacks = { }
    
    function text:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function text:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function text:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function text:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    text.extras = { }

    function text:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function text:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function text:get_visual_height( )
        if not self.visible then
            return 0
        end

        return 20
    end

    function text:set( new_name )
        self.name = new_name
    end

    function text:set_visible( boolean )
        self.visible = boolean
    end

    function text:get( )
        return self.name
    end
                                                    
    function text:handle( pos, width )
        return false -- purely here not to cause an issue when handleing all elements
    end

    function text:render( pos, width, interacting )
        if not self.visible then
            return
        end

        if pos.y > self.gui.pos.y then
            render.push_clip( pos, vec2_t.new( width, 20 ) )

            -- render text
            render.text(
                fonts.element,
                self.name,
                pos + vec2_t.new( 10, 0 ),
                self.gui.colors.hovering_text
            )

            render.pop_clip( )
        end
    end

    function text:to_string( )
        return string.format( '[ text ][ %s->%s->%s ] %s', self.page, self.tab, self.section, self.name )
    end

    return text
end

function elements.create_button( gui_obj, page, tab, section, name )
    local button = { _type = element_types.button }

    button.gui = gui_obj

    button.page = page
    button.tab = tab
    button.section = section
    button.name = name

    button.visible = true
    button.render_topmost = false

    button.visibility_callbacks = { }
    button.visibility_requirements = { }

    button.callbacks = { }
    
    function button:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function button:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function button:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function button:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    button.extras = { }

    function button:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function button:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function button:get_visual_height( )
        if not self.visible then
            return 0
        end

        return 20
    end

    function button:set( new_name )
        self.name = new_name
    end

    function button:set_visible( boolean )
        self.visible = boolean
    end

    function button:get( )
        return self.name
    end
                                                    
    function button:handle( pos, width )
        if not self.visible then
            return
        end

        if pos.y > self.gui.pos.y then
            local start_pos = pos + vec2_t.new( 10, 0 )
            local size = vec2_t.new( width - 20, 18 )

            local in_bounds = input.is_mouse_in_bounds( start_pos, size )
            local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )

            if in_bounds and is_mouse_1_pressed then
                self:invoke_callbacks( )

                return true
            end 
        end

        return false -- purely here not to cause an issue when handleing all elements
    end

    function button:render( pos, width, interacting )
        if not self.visible then
            return
        end

        if pos.y > self.gui.pos.y then
            local start_pos = pos + vec2_t.new( 10, 0 )
            local size = vec2_t.new( width - 20, 18 )

            local in_bounds = input.is_mouse_in_bounds( start_pos, size )

            local outline_color = in_bounds and self.gui.colors.hovering_outline or
                                                self.gui.colors.inactive_outline

            local text_color = in_bounds and self.gui.colors.hovering_text or
                                            self.gui.colors.inactive_text

            render.rect_filled(
                start_pos,
                size,
                self.gui.colors.dark_background,
                3
            )

            render.rect(
                start_pos,
                size,
                outline_color,
                3
            )

            render.push_clip( start_pos, size - vec2_t( 1, 1 ) ) -- -1 so it doesnt clip text ( sorry it infuriates me so much )

            render.text(
                fonts.element,
                self.name,
                start_pos + vec2_t.new( size.x / 2, size.y / 2 ),
                text_color,
                true
            )

            render.pop_clip( )
        end
    end

    function button:to_string( )
        return string.format( '[ button ][ %s->%s->%s ] %s', self.page, self.tab, self.section, self.name )
    end

    return button
end

function elements.create_separator( gui_obj, page, tab, section )
    local sep = { _type = element_types.separator }

    sep.gui = gui_obj

    sep.page = page
    sep.tab = tab
    sep.section = section

    sep.visible = true
    sep.render_topmost = false

    sep.visibility_callbacks = { }
    sep.visibility_requirements = { }

    sep.callbacks = { }
    
    function sep:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function sep:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function sep:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function sep:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    sep.extras = { }

    function sep:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function sep:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function sep:get_visual_height( )
        if not self.visible then
            return 0
        end

        return 10
    end

    function sep:set( )
        
    end

    function sep:set_visible( boolean )
        self.visible = boolean
    end

    function sep:get( )
        return
    end
                                                    
    function sep:handle( pos, width )
        return false -- purely here not to cause an issue when handleing all elements
    end

    function sep:render( pos, width, interacting )
        if not self.visible then
            return
        end

        if pos.y > self.gui.pos.y then
            render.rect_filled(
                pos + vec2_t.new( 10, 2 ),
                vec2_t.new( width - 20, 2 ),
                self.gui.colors.active_outline
            )
        end
    end

    function sep:to_string( )
        return string.format( '[ text ][ %s->%s->%s ] %s', self.page, self.tab, self.section, self.name )
    end

    return sep
end

function elements.create_list( gui_obj, page, tab, section, items )
    local list = { _type = element_types.list }

    list.gui = gui_obj

    list.page = page
    list.tab = tab
    list.section = section

    list.name = 'list' .. tostring( #gui_obj.pages[ page ][ tab ][ section ]  )

    list.items = items
    list.selected = #items == 0 and nil or 1

    list.visible = true
    list.render_topmost = false

    list.visibility_callbacks = { }
    list.visibility_requirements = { }

    list.callbacks = { }

    list.scroll_offset = 0

    list.height = 130
    list.entry_height = 14
    
    function list:register_callback( func )
        table.insert( self.callbacks, func )
    end

    function list:invoke_callbacks( )
        for i = 1, #self.callbacks do
            self.callbacks[ i ]( )
        end
    end

    function list:invoke_visibility_callbacks( )
        for i = 1, #self.visibility_callbacks do
            self.visibility_callbacks[ i ]( )
        end
    end

    function list:set_visibility_requirement( ... )
        local args = { ... }
        
        set_visibility_requirement( self, args )
    end

    list.extras = { }

    function list:add_keybind( keybind_name, keybind_mode, default_key, locked )
        local keybind = self.gui:add_keybind( self, keybind_name, keybind_mode, default_key, locked )

        table.insert( self.extras, keybind )

        return keybind
    end

    function list:add_color_picker( colorpicker_name, default_color )
        local colorpicker = self.gui:add_colorpicker( self, colorpicker_name, default_color )

        table.insert( self.extras, colorpicker )

        return colorpicker
    end

    function list:get_visual_height( )
        if not self.visible then
            return 0
        end

        return self.height + 10
    end

    function list:set( index_or_name )
        if type( index_or_name ) == "string" then
            for i = 1, #self.items do
                if self.items[ i ] == index_or_name then
                    self.selected = i
                    break
                end
            end
        else
            self.selected = index_or_name
        end
    end

    function list:set_visible( boolean )
        self.visible = boolean
    end

    function list:get( )
        return list.selected, list.selected == nil and nil or list.items[ list.selected ]
    end

    function list:get_items( )
        return list.items
    end

    function list:update_items( new_items )
        list.items = new_items

        if #new_items == 0 then
            self.selected = nil
        else
            self.selected = 1
        end
    end
                                                    
    function list:handle( pos, width )
        if not self.visible then
            return
        end

        if pos.y + self.height < self.gui.pos.y then
            return false, false
        end

        local max_y_pos = self.gui.pos.y + self.gui.size.y - self.gui.footer_size.y

        local height_to_max_y_pos = max_y_pos - pos.y

        local height = math.min( self.height, height_to_max_y_pos )

        local size = vec2_t.new( width - 20, height )

        local in_bounds = input.is_mouse_in_bounds( pos + vec2_t.new( 10, 0 ), size )
        local is_mouse_1_pressed = input.is_key_pressed( e_keys.MOUSE_LEFT )
        local scroll_delta = input.get_scroll_delta( )

        local text_start = pos + vec2_t.new( 10, 5 )
        
        local do_we_need_scrollbar = #self.items > math.floor( self.height / self.entry_height )

        if in_bounds and is_mouse_1_pressed then
            local mouse = input.get_mouse_pos( )
            local index = math.floor( ( mouse.y - text_start.y ) / self.entry_height ) + 1

            if mouse.y < self.gui.pos.y then
                return false, false
            end

            index = index + self.scroll_offset

            if index > 0 and index <= #self.items then
                self.selected = index
                self:invoke_callbacks( )
            end

            return true, false
        elseif in_bounds and scroll_delta ~= 0 and do_we_need_scrollbar then
            local new_val = self.scroll_offset - scroll_delta

            if new_val < 0 or new_val > #self.items - math.floor( self.height / self.entry_height ) + 1 then
                new_val = 0 -- dont down up menu scrolling when we cant scroll aka we on top or bottom then we indicate script that oh scroll menu not this list pls kthx
                return false, false
            else
                self.scroll_offset = new_val
                return true, true
            end
        end

        return false, false
    end

    function list:render( pos, width, interacting )
        if not self.visible then
            return
        end

        local max_y_pos = self.gui.pos.y + self.gui.size.y - self.gui.footer_size.y

        local height_to_max_y_pos = max_y_pos - pos.y + 5

        local height = math.min( self.height, height_to_max_y_pos )

        local size = vec2_t.new( width - 20, height )

        local render_pos = pos + vec2_t.new( 10, 0 )

        if render_pos.y < self.gui.pos.y and render_pos.y + self.height > self.gui.pos.y then
            local diff = self.gui.pos.y - render_pos.y
            size.y = size.y - diff
            render_pos.y = self.gui.pos.y
        end

        if size.y < 0 then
            return
        end

        render.rect_filled(
            render_pos,
            size,
            self.gui.colors.dark_background,
            3
        )

        local in_bounds = input.is_mouse_in_bounds( pos + vec2_t.new( 10, 0 ), size )

        local outline_c = in_bounds and self.gui.colors.hovering_outline or
                                        self.gui.colors.inactive_outline

        render.rect(
            render_pos,
            size,
            outline_c,
            3
        )

        render.push_clip(
            render_pos + vec2_t.new( 0, 3 ),
            size
        )

        local text_start = pos + vec2_t.new( 10, 5 - self.scroll_offset * self.entry_height )
        for i = 1, #self.items do
            local bounds = in_bounds and input.is_mouse_in_bounds( text_start, vec2_t.new( size.x - 10, self.entry_height ) )
            local is_selected = i == self.selected

            local text_color = is_selected and colors.accent or
                            bounds      and self.gui.colors.hovering_text or
                                            self.gui.colors.inactive_text
            
            render.text(
                fonts.element,
                self.items[ i ],
                text_start + vec2_t.new( 5, 0 ),
                text_color
            )

            text_start.y = text_start.y + self.entry_height

            if text_start.y > pos.y + height then
                break
            end
        end

        -- render scrollbar
        local do_we_need_scrollbar = #self.items > math.floor( self.height / self.entry_height )

        if do_we_need_scrollbar then
            local items = #self.items
            local max_items = math.floor( self.height / self.entry_height )

            local scroll_bar_height = self.height - 8

            scroll_bar_height = math.floor( scroll_bar_height / items * max_items )
            local scroll_width = 3
            local scroll_bar_pos = math.floor( height / items * self.scroll_offset )
            local scroll_bar_color = colors.accent

            -- render bg
            render.rect_filled(
                pos + vec2_t.new( width - 10 - scroll_width - 4, 10 ),
                vec2_t.new( 3, height - 10 ),
                self.gui.self.gui.colors.inactive_outline
            )

            render.rect_filled(
                pos + vec2_t.new( width - 10 - scroll_width - 4, 10 + scroll_bar_pos ),
                vec2_t.new( 3, scroll_bar_height - 20 ),
                scroll_bar_color
            )
        end

        render.pop_clip( )
    end

    function list:to_string( )
        return string.format( '[ list ][ %s->%s->%s ] %s', self.page, self.tab, self.section, self.name )
    end

    return list
end

local menu = { }
function menu.create( )
    local gui = { }

    gui.colors = colors
    gui.changed_colors = colors
    gui.colors_backup = colors_backup

    gui.pos = vec2_t.new( 100, 100 )
    gui.size = vec2_t.new( 628, 513 )
    gui.subtab_size = vec2_t( 200, gui.size.y )
    gui.subtab_entry_size = vec2_t( gui.subtab_size.x, 44 )
    gui.footer_size = vec2_t( gui.size.x, 70 )
    gui.page_icon_size = vec2_t( 70, 60 )
    gui.footer_icon_gap = 10

    gui.title = 'primordial.dev'

    gui.section_width = 200

    gui.min_size = vec2_t.new( 628, 513 )

    gui.resizable = true
    gui.is_resizing = false
    gui.resize_mouse_difference = vec2_t.new( 0, 0 )
    gui.mouse_difference = vec2_t.new( 0, 0 )
    gui.dragging = false
    gui.can_drag = true

    gui.resizable = true
    gui.current_page = nil
    gui.current_subtab = nil

    gui.keybinds = { } -- so we can update the state regardless if the menu is open

    gui.page_icons = { }

    gui.pages = { }
    gui.subtab_sections = { }
    gui.page_order = { }
    gui.stored_page_subtabs = { }

    gui.subtab_order = { }

    gui.stored_color = nil

    gui.interacting_element = {
        page = nil,
        tab = nil,
        section = nil,
        element = nil,
        interacting = false
    }

    gui.scroll = { }

    gui.can_scroll = true

    gui.page_icon_animation_timers = { }
    gui.page_icon_animation_time = 0.15
    gui.page_icon_animations = false

    gui.custom_logo_function = nil

    function gui:set_min_size( new_size )
        self.min_size = new_size

        if self.size.x < self.min_size.x then
            self.size.x = self.min_size.x
        end

        if self.size.y < self.min_size.y then
            self.size.y = self.min_size.y
        end

        self.subtab_size = vec2_t.new( 200, self.size.y )
        self.footer_size = vec2_t.new( self.size.x, 70 )
        self.section_width = ( self.size.x - self.subtab_size.x - 10 - 10 - 10 ) / 2
    end

    function gui:set_custom_logo( func )
        self.custom_logo_function = func
    end

    function gui:reset_colors( )
        self.colors = self.colors_backup
    end

    function gui:use_custom_colors( should_use )
        if should_use then
            self.colors = self.changed_colors
        else
            self.colors = self.colors_backup
        end
    end

    function gui:set_page_icon_animation( new_state )
        self.page_icon_animations = new_state
    end

    function gui:set_size( new_size )
        self.size = new_size

        if self.size.x < self.min_size.x then
            self.size.x = self.min_size.x
        end

        if self.size.y < self.min_size.y then
            self.size.y = self.min_size.y
        end

        self.subtab_size = vec2_t.new( 200, self.size.y )
        self.footer_size = vec2_t.new( self.size.x, 70 )
        self.section_width = ( self.size.x - self.subtab_size.x - 10 - 10 - 10 ) / 2
    end

    function gui:get_accent_color( )
        return colors.accent
    end

    function gui:set_title( title )
        self.title = title
    end

    function gui:set_page_icon( page, icon )
        self.page_icons[ page ] = icon
    end

    function gui:set_stored_color( color )
        self.stored_color = color
    end

    function gui:get_stored_color( )
        return self.stored_color
    end

    function gui:set_resizability( boolean )
        self.resizable = boolean
    end

    function gui:setup_page( page, tab, section )
        if gui.pages[ page ] == nil then
            gui.pages[ page ] = { }

            if gui.current_page == nil then
                gui.current_page = page
            end

            if gui.page_icon_animation_timers[ page ] == nil then
                gui.page_icon_animation_timers[ page ] = global_vars.real_time( )
            end

            if gui.subtab_order[ page ] == nil then
                gui.subtab_order[ page ] = { }
            end

            if gui.subtab_sections[ page ] == nil then
                gui.subtab_sections[ page ] = { }
            end

            if not table.shallow_has_value( gui.page_order, page ) then
                table.insert( gui.page_order, page )
            end

            if gui.scroll[ page ] == nil then
                gui.scroll[ page ] = { }
            end
        end

        if gui.pages[ page ][ tab ] == nil then
            gui.pages[ page ][ tab ] = { }

            if gui.current_subtab == nil then
                gui.current_subtab = tab
            end

            if not table.shallow_has_value( gui.subtab_order[ page ], tab ) then
                table.insert( gui.subtab_order[ page ], tab )
            end

            if gui.subtab_sections[ page ][ tab ] == nil then
                gui.subtab_sections[ page ][ tab ] = { }
            end

            if gui.scroll[ page ][ tab ] == nil then
                gui.scroll[ page ][ tab ] = 0
            end
        end

        if not table.shallow_has_value( gui.subtab_sections[ page ][ tab ], section ) then
            table.insert( gui.subtab_sections[ page ][ tab ], section )
        end

        -- stored page subtabs so it wont be the first subtab every time
        if gui.stored_page_subtabs[ page ] == nil then
            gui.stored_page_subtabs[ page ] = tab
        end

        if gui.pages[ page ][ tab ][ section ] == nil then
            gui.pages[ page ][ tab ][ section ] = { }
        end
    end

    function gui:add_checkbox( page, tab, section, name, o_default_state )
        gui:setup_page( page, tab, section )

        local checkbox = elements.create_checkbox(
            self,
            page,
            tab,
            section,
            name,
            o_default_state
        )

        table.insert( gui.pages[ page ][ tab ][ section ], checkbox )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_slider( page, tab, section, name, min, max, default, suffix )
        gui:setup_page( page, tab, section )

        local slider = elements.create_slider(
            self,
            page,
            tab,
            section,
            name,
            min,
            max,
            default,
            suffix
        )

        table.insert( gui.pages[ page ][ tab ][ section ], slider )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_combo( page, tab, section, name, items, default_value )
        gui:setup_page( page, tab, section )

        local combo = elements.create_combo(
            self,
            page,
            tab,
            section,
            name,
            items,
            default_value
        )

        table.insert( gui.pages[ page ][ tab ][ section ], combo )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_multicombo( page, tab, section, name, items, default_value_s )
        gui:setup_page( page, tab, section )

        local multicombo = elements.create_multi_combo(
            self,
            page,
            tab,
            section,
            name,
            items,
            default_value_s
        )

        table.insert( gui.pages[ page ][ tab ][ section ], multicombo )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_text_input( page, tab, section, name, default )
        gui:setup_page( page, tab, section )

        local text_input = elements.create_text_input(
            self,
            page,
            tab,
            section,
            name,
            default
        )

        table.insert( gui.pages[ page ][ tab ][ section ], text_input )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_text( page, tab, section, name )
        gui:setup_page( page, tab, section )

        local text = elements.create_text(
            self,
            page,
            tab,
            section,
            name
        )

        table.insert( gui.pages[ page ][ tab ][ section ], text )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_button( page, tab, section, name )
        gui:setup_page( page, tab, section )

        local button = elements.create_button(
            self,
            page,
            tab,
            section,
            name
        )

        table.insert( gui.pages[ page ][ tab ][ section ], button )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_separator( page, tab, section )
        gui:setup_page( page, tab, section )

        local separator = elements.create_separator(
            self,
            page,
            tab,
            section
        )

        table.insert( gui.pages[ page ][ tab ][ section ], separator )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_list( page, tab, section, items )
        gui:setup_page( page, tab, section )

        local list = elements.create_list(
            self,
            page,
            tab,
            section,
            items
        )

        table.insert( gui.pages[ page ][ tab ][ section ], list )

        return gui.pages[ page ][ tab ][ section ][ #gui.pages[ page ][ tab ][ section ] ]
    end

    function gui:add_keybind( parent, name, mode, default_key, locked )
        local keybind = elements.create_keybind(
            parent,
            name,
            mode,
            default_key,
            locked
        )

        table.insert( gui.pages[ parent.page ][ parent.tab ][ parent.section ], keybind )
        table.insert( gui.keybinds, keybind )

        return gui.pages[ parent.page ][ parent.tab ][ parent.section ][ #gui.pages[ parent.page ][ parent.tab ][ parent.section ] ]
    end

    function gui:add_colorpicker( parent, colorpicker_name, default_color )
        local colorpicker = elements.create_colorpicker(
            parent,
            colorpicker_name,
            default_color
        )

        table.insert( gui.pages[ parent.page ][ parent.tab ][ parent.section ], colorpicker )

        return gui.pages[ parent.page ][ parent.tab ][ parent.section ][ #gui.pages[ parent.page ][ parent.tab ][ parent.section ] ]
    end

    function gui:get_config( )
        local config = { }

        for page, tabs in pairs( gui.pages ) do
            config[ page ] = { }

            for tab, sections in pairs( tabs ) do
                config[ page ][ tab ] = { }

                for section, section_elements in pairs( sections ) do
                    config[ page ][ tab ][ section ] = { }

                    for i = 1, #section_elements do
                        local element = section_elements[ i ]

                        if element._type == element_types.checkbox then
                            config[ page ][ tab ][ section ][ element.name ] = element:get( )
                        elseif element._type == element_types.slider then
                            config[ page ][ tab ][ section ][ element.name ] = element:get( )
                        elseif element._type == element_types.combo then
                            config[ page ][ tab ][ section ][ element.name ] = element:get( )
                        elseif element._type == element_types.multicombo then
                            local selected_items = { }
                            local items = element:get_items( )
                            for j = 1, #items do
                                if element:get( j ) then
                                    table.insert( selected_items, items[ j ] )
                                end
                            end
                            config[ page ][ tab ][ section ][ element.name ] = selected_items
                        elseif element._type == element_types.text_input then
                            config[ page ][ tab ][ section ][ element.name ] = element:get( )
                        elseif element._type == element_types.list then
                            config[ page ][ tab ][ section ][ element.name ] = element:get( )
                        elseif element._type == element_types.colorpicker then
                            local color = element:get( )

                            config[ page ][ tab ][ section ][ element.name ] = {
                                color.r,
                                color.g,
                                color.b,
                                color.a
                            }
                        elseif element._type == element_types.keybind then
                            local kufti = {
                                mode = element:get_mode( ),
                                key = element:get_key( )
                            }
                            config[ page ][ tab ][ section ][ element.name ] = kufti
                        elseif element._type == element_types.text then -- i could make them in one if statement but this is more readable
                            -- nothing
                        elseif element._type == element_types.button then
                            -- nothing
                        elseif element._type == element_types.separator then
                            -- nothing
                        end
                    end
                end
            end
        end

        return config
    end

    function gui:load_config( config )
        for page, tabs in pairs( gui.pages ) do
            if config[ page ] then
                for tab, sections in pairs( tabs ) do
                    if config[ page ][ tab ] then
                        for section, section_elements in pairs( sections ) do
                            if config[ page ][ tab ][ section ] then
                                for i = 1, #section_elements do
                                    local element = section_elements[ i ]
                                    local data = config[ page ][ tab ][ section ][ element.name ]
                                    if data and element then
                                        element:invoke_visibility_callbacks( )

                                        if element._type == element_types.checkbox then
                                            element:set( data )
                                        elseif element._type == element_types.slider then
                                            element:set( data )
                                        elseif element._type == element_types.combo then
                                            element:set( data )
                                        elseif element._type == element_types.multicombo then
                                            local items = element:get_items( )
                                            for j = 1, #items do
                                                element:set( j, false )
                                            end

                                            for j = 1, #data do
                                                element:set( data[ j ], true )
                                            end
                                        elseif element._type == element_types.text_input then
                                            element:set( data )
                                        elseif element._type == element_types.list then
                                            element:set( data )
                                        elseif element._type == element_types.colorpicker then
                                            local color = color_t.new( data[ 1 ], data[ 2 ], data[ 3 ], data[ 4 ] )

                                            element:set( color )
                                        elseif element._type == element_types.keybind then
                                            local saved_mode = data.mode
                                            local saved_key = data.key

                                            element:set_mode( saved_mode )
                                            element:set_key( saved_key )
                                        end
                                    else
                                        -- print( 'couldnt load ' .. element_id_to_name[ element._type ] .. ' ' .. tostring( element.name ) .. ' from ' .. page .. '->' .. tab .. '->' .. section )
                                        -- (actually means that they werent in the config but idc!)

                                        -- okay maybe we set some of them to defaults sowwy
                                        if element._type == element_types.checkbox then
                                            element:set( false )
                                        elseif element._type == element_types.combo then
                                            element:set( 0 )
                                        elseif element._type == element_types.multicombo then
                                            local items = element:get_items( )
                                            for j = 1, #items do
                                                element:set( j, false )
                                            end
                                        end
                                    end
                                end
                            else
                                print( 'couldnt load ' .. page .. '->' .. tab .. '->' .. section )
                            end
                        end
                    else
                        print( 'couldnt load ' .. page .. '->' .. tab )
                    end
                end
            else
                print( 'couldnt load ' .. page )
            end
        
        end
    end

    function gui:handle_pages( )
        local pages = gui.page_order
        local page_count = #pages

        local start_pos = gui.pos + vec2_t.new( math.floor( gui.size.x / 2 ), gui.size.y - gui.footer_size.y )
        
        local total_width = page_count * gui.page_icon_size.x + ( page_count - 1 ) * gui.footer_icon_gap

        start_pos.x = start_pos.x - total_width / 2

        local page_start_pos = vec2_t.new( start_pos.x, start_pos.y )

        local real_time = global_vars.real_time( )

        for i = 1, page_count do
            local page = pages[ i ]
            local selected = gui.current_page == page

            local animation_time = gui.page_icon_animation_timers[ page ]
            local animation_delta = real_time - animation_time

            local animation_perc = math.clamp( animation_delta / gui.page_icon_animation_time, 0, 1 )

            if not selected then
                animation_perc = 1 - animation_perc
            end

            local pos = page_start_pos + vec2_t.new( 0, ( self.footer_size.y - self.page_icon_size.y ) / 2 )

            local in_bounds = input.is_mouse_in_bounds( page_start_pos, gui.page_icon_size )
            local is_mouse_1_pressed = input.is_key_pressed( key.MOUSE_LEFT )

            if in_bounds and is_mouse_1_pressed and not selected then
                -- cache subtab and update animation times
                gui.stored_page_subtabs[ gui.current_page ] = gui.current_subtab
                gui.page_icon_animation_timers[ gui.current_page ] = real_time
                gui.page_icon_animation_timers[ page ] = real_time

                gui.current_page = page
                gui.current_subtab = gui.stored_page_subtabs[ gui.current_page ]
            end

            local alpha_animation_perc = animation_perc
            if in_bounds and not selected then
                alpha_animation_perc = 0.2
            elseif selected and animation_perc < 0.2 then
                alpha_animation_perc = 0.2
            end 

            render.push_alpha_modifier( alpha_animation_perc )

            -- render gradient background
            render.rect_filled(
                pos,
                gui.page_icon_size,
                self.colors.white30,
                10
            )

            local pad_x = 20

            -- render accent line
            render.rect_filled(
                pos + vec2_t.new( pad_x, gui.page_icon_size.y - 3 - 1 ),
                vec2_t.new( gui.page_icon_size.x - pad_x * 2, 3 ),
                colors.accent
            )

            render.pop_alpha_modifier( )

            local icon = self.page_icons[ page ]

            if icon == nil then
                -- render tab text
                render.text(
                    fonts.page,
                    page:sub( 1, 1 ):upper( ),
                    pos + vec2_t.new( gui.page_icon_size.x / 2, gui.page_icon_size.y / 2 ),
                    self.colors.white,
                    true
                )
            else
                local pad = vec2_t.new( 20, 10 )

                local center = pos + vec2_t.new( gui.page_icon_size.x / 2, gui.page_icon_size.y / 2 )
                local text_pos = center + vec2_t.new( 0, gui.page_icon_size.y / 2 )

                local offset = selected and 14 or 12

                text_pos.y = text_pos.y - offset

                local texture_size = vec2_t.new( 35, 30 )

                local texture_start = vec2_t.new(
                    center.x - texture_size.x / 2,
                    center.y - texture_size.y / 2 - 10
                )

                if animation_perc > 0 and self.page_icon_animations then
                    local y_raise = 3 * animation_perc

                    render.texture(
                        icon.id,
                        texture_start,
                        texture_size,
                        self.colors.black
                    )

                    render.text(
                        fonts.page_title,
                        page:sub( 1, 1 ):upper( ) .. page:sub( 2, #page ),
                        text_pos,
                        self.colors.black,
                        true
                    )

                    render.texture(
                        icon.id,
                        texture_start - vec2_t.new( 0, y_raise ),
                        texture_size,
                        not selected and self.colors.white100 or self.colors.white
                    )


                    -- render tab text
                    render.text(
                        fonts.page_title,
                        page:sub( 1, 1 ):upper( ) .. page:sub( 2, #page ),
                        text_pos - vec2_t.new( 0, y_raise ),
                        not selected and self.colors.white100 or
                                        self.colors.white,
                        true
                    )
                else
                    render.texture(
                        icon.id,
                        texture_start,
                        texture_size,
                        not selected and self.colors.white100 or self.colors.white
                    )


                    -- render tab text
                    render.text(
                        fonts.page_title,
                        page:sub( 1, 1 ):upper( ) .. page:sub( 2, #page ),
                        text_pos,
                        not selected and self.colors.white100 or
                                        self.colors.white,
                        true
                    )
                end
            end

            page_start_pos.x = page_start_pos.x + gui.page_icon_size.x + gui.footer_icon_gap
        end

        if input.is_mouse_in_bounds( start_pos, vec2_t.new( total_width, gui.page_icon_size.y ) ) then
            gui.can_drag = false
        end
    end

    function gui:handle_subtabs( )
        if gui.current_page == nil then
            print( "gui:handle_subtabs | gui.current_page is nil" )
            return
        end

        local subtab_order = gui.subtab_order[ gui.current_page ]

        local subtab_start_pos = gui.pos + vec2_t.new( 0, 200 )
        local start_y = subtab_start_pos.y
        for i = 1, #subtab_order do
            local tab = subtab_order[ i ]

            local in_bounds = input.is_mouse_in_bounds( subtab_start_pos, gui.subtab_entry_size )
            local is_mouse_1_pressed = input.is_key_pressed( key.MOUSE_LEFT )

            if in_bounds and is_mouse_1_pressed then
                gui.current_subtab = tab
            end

            local selected = gui.current_subtab == tab

            if in_bounds or selected then
                if in_bounds and not selected then
                    render.push_alpha_modifier( 0.2 )
                end

                -- render gradient background
                render.rect_fade(
                    subtab_start_pos,
                    gui.subtab_entry_size,
                    self.colors.white100,
                    self.colors.white30,
                    true
                )

                -- render accent line
                render.rect_filled(
                    subtab_start_pos,
                    vec2_t.new( 3, gui.subtab_entry_size.y ),
                    colors.accent
                )

                render.pop_alpha_modifier( )
            end

            local text_color = gui.current_subtab == tab and self.colors.active_text or
                            in_bounds and self.colors.hovering_text or
                                            self.colors.inactive_text

            render.text(
                fonts.element,
                tab,
                subtab_start_pos + vec2_t.new( 10, gui.subtab_entry_size.y / 2 - 8 ),
                text_color
            )

            subtab_start_pos.y = subtab_start_pos.y + gui.subtab_entry_size.y
        end

        local total_height = subtab_start_pos.y - start_y

        if input.is_mouse_in_bounds( gui.pos + vec2_t.new( 0, 200 ), vec2_t.new( gui.subtab_size.x, total_height ) ) then
            gui.can_drag = false
        end
    end

    function gui:handle_elements( )
        local can_drag = true
        if gui.current_page == nil then
            print( "gui:handle_elements | gui.current_page is nil" )
            return can_drag
        end

        if gui.current_subtab == nil then
            print( "gui:handle_elements | gui.current_subtab is nil" )
            return can_drag
        end

        local section_order = gui.subtab_sections[ gui.current_page ][ gui.current_subtab ]
        local items = gui.pages[ gui.current_page ][ gui.current_subtab ]

        local scroll_amount = self.scroll[ self.current_page ][ self.current_subtab ]

        local element_pos_left = gui.pos + vec2_t.new( gui.subtab_size.x + 10, 40 + scroll_amount )
        local element_pos_right = gui.pos + vec2_t.new( gui.subtab_size.x + 10 + gui.section_width + 10, 40 + scroll_amount )

        local last_side = 0
        local interaction_table = gui.interacting_element

        local interacting_with_extra = false

        local max_height = gui.size.y - ( gui.footer_size.y + 20 )

        gui.can_scroll = true

        for i = 1, #section_order do
            local _section = section_order[ i ]
            local subtab_elements = items[ _section ]

            local element_start_pos = last_side % 2 == 0 and vec2_t.new(
                element_pos_left.x,
                element_pos_left.y + 10
            ) or vec2_t.new(
                element_pos_right.x,
                element_pos_right.y + 10
            )
            
            for _, element in pairs( subtab_elements ) do
                if element._type == element_types.keybind or element._type == element_types.colorpicker then
                    goto continue
                end
                
                local total_right_offset = 0

                local y_pos = element_start_pos.y
                
                if ( y_pos + element:get_visual_height( ) < gui.pos.y + max_height and element._type ~= element_types.list ) or ( element._type == element_types.list and y_pos < self.pos.y + self.size.y - self.footer_size.y and ( y_pos - 1 ) > self.pos.y - element.height ) then                  
                    for kb_iter = 1, #element.extras do
                        local extra = element.extras[ kb_iter ]
    
                        local is_interacting_this_extra = interaction_table.interacting and
                                                            interaction_table.element._type == extra._type and
                                                            interaction_table.page == extra.parent.page and
                                                            interaction_table.tab == extra.parent.tab and
                                                            interaction_table.section == extra.parent.section
    
                        local pos, width = element_start_pos - vec2_t.new( total_right_offset, 0 ), gui.section_width
    
                        local interacting = extra:handle( pos, width, is_interacting_this_extra )
                        if interacting then
                            gui.interacting_element.page = extra.page
                            gui.interacting_element.tab = extra.tab
                            gui.interacting_element.section = extra.section
                            gui.interacting_element.element = extra
                            
                            gui.interacting_element.interacting = true
    
                            interacting_with_extra = true
                        end
    
                        local _, extra_size = extra:in_bounds( pos, width )
    
                        total_right_offset = total_right_offset + extra_size.x
                    end
    
                    local is_interacting_this_element = interaction_table.interacting and
                                                        interaction_table.page == element.page and
                                                        interaction_table.tab == element.tab and
                                                        interaction_table.section == element.section and
                                                        interaction_table.element.name == element.name
    
                    if not gui.dragging and ( not gui.interacting_element.interacting or is_interacting_this_element ) then
                        if not interacting_with_extra then
                            local interacting, scrolling = element:handle( element_start_pos, gui.section_width, is_interacting_this_element )
                            
                            if scrolling then
                                gui.can_scroll = false
                            end

                            if interacting then
                                gui.interacting_element.page = element.page
                                gui.interacting_element.tab = element.tab
                                gui.interacting_element.section = element.section
                                gui.interacting_element.element = element
    
                                gui.interacting_element.interacting = true
                            end
                        end
                    end
                end
                
                element_start_pos.y = element_start_pos.y + element:get_visual_height( )

                ::continue::
            end

            -- render section background
            local pos = last_side % 2 == 0 and element_pos_left or element_pos_right
            pos.y = pos.y - 10
            local total_height = element_start_pos.y - pos.y

            if total_height > max_height and gui.can_scroll and input.is_mouse_in_bounds( self.pos, self.size ) then
                self.scroll[ self.current_page ][ self.current_subtab ] = self.scroll[ self.current_page ][ self.current_subtab ] + input.get_scroll_delta( ) * 20

                local max_scroll = -total_height + max_height - 50

                if self.scroll[ self.current_page ][ self.current_subtab ] > 0 then
                    self.scroll[ self.current_page ][ self.current_subtab ] = 0
                elseif self.scroll[ self.current_page ][ self.current_subtab ] < max_scroll then
                    self.scroll[ self.current_page ][ self.current_subtab ] = max_scroll
                end
            end

            if total_height > 20 then
                render.push_clip( self.pos + vec2_t( 0, 21 ), vec2_t.new( self.size.x, self.size.y - 20 - self.footer_size.y ) )

                render.rect_filled(
                    pos,
                    vec2_t.new( gui.section_width, total_height ),
                    self.colors.section_background,
                    10
                )

                render.pop_clip( )

                -- render section name
                if pos.y > self.pos.y then
                    render.text(
                        fonts.element,
                        _section,
                        pos + vec2_t.new( 10, 3 ),
                        self.colors.white
                    )
                end
                
                if last_side % 2 == 0 then
                    element_pos_left.y = element_pos_left.y + total_height + 20
                else
                    element_pos_right.y = element_pos_right.y + total_height + 20
                end
            end

            last_side = last_side + 1
        end

        can_drag = not gui.interacting_element.interacting

        if not input.is_key_held( key.MOUSE_LEFT ) then
            gui.interacting_element.interacting = false

            gui.interacting_element.page = nil
            gui.interacting_element.tab = nil
            gui.interacting_element.section = nil
            gui.interacting_element.element = nil
        end

        return gui.dragging or can_drag
    end

    function gui:handle_keybinds( )
        for i = 1, #self.keybinds do
            local keybind = self.keybinds[ i ]

            if keybind.visible then
                keybind:update( )
            end
        end
    end

    function gui:handle_drag( )
        if not gui.can_drag then
            return
        end

        local mouse_pos = input.get_mouse_pos( )
        local in_bounds = input.is_mouse_in_bounds( self.pos, self.size )
        local is_mouse_1_held = input.is_key_held( key.MOUSE_LEFT )

        if gui.dragging or
        ( is_mouse_1_held and in_bounds ) then
            self.dragging = true

            self.pos = mouse_pos - self.mouse_difference
        else
            self.mouse_difference = mouse_pos - self.pos
        end
        
        if not is_mouse_1_held then
            self.dragging = false
        end
    end

    function gui:render_header( )
        render.rect_filled(
            gui.pos,
            vec2_t.new( gui.size.x, 20 ),
            self.colors.footer_background,
            10
        )

        -- fill bottom left and right
        render.rect_filled(
            gui.pos + vec2_t( 0, 10 ),
            vec2_t.new( gui.size.x, 10 ),
            self.colors.footer_background
        )

        -- accent line
        render.line(
            gui.pos + vec2_t( 0, 20 ),
            gui.pos + vec2_t( gui.size.x, 20 ),
            colors.accent
        )

        -- render name
        render.text(
            fonts.default,
            self.title,
            gui.pos + vec2_t( self.size.x / 2, 10 ),
            self.colors.white,
            true
        )
    end

    function gui:render_background( )
        -- background
        render.rect_filled(
            self.pos,
            self.size,
            self.colors.dark_background,
            10
        )

        -- black outline
        render.rect(
            self.pos - vec2_t.new( 1, 1 ),
            self.size + vec2_t.new( 2, 2 ),
            self.colors.black,
            10
        )

        -- render left hand side subtab menu with logo
        render.rect_filled(
            self.pos,
            self.subtab_size,
            self.colors.subtab_background,
            10
        )

        -- fill rounding on the left hand side
        render.rect_filled(
            self.pos + vec2_t.new( self.subtab_size.x - 10, 0 ),
            vec2_t.new( 10, self.size.y ),
            self.colors.subtab_background
        )

        if self.custom_logo_function == nil then
            local pad = 25

            local pos = self.pos + vec2_t.new( pad, 20 + pad )
            local size = vec2_t.new( self.subtab_size.x - pad * 2, self.subtab_size.x - 20 - pad * 2 )

            if images.primordial_outline then
                local texture_size = images.primordial_outline.size

                local aspect_ratio = texture_size.x / texture_size.y

                local size_x = size.y * aspect_ratio
                local actual_pos = pos + vec2_t.new( size.x / 2 - size_x / 2, 0 )
                local actual_size = vec2_t.new( size_x, size.y )

                render.texture(
                    images.primordial_outline.id,
                    actual_pos,
                    actual_size,
                    colors.white
                )
            end

            if images.primordial_inside then
                local texture_size = images.primordial_inside.size

                local aspect_ratio = texture_size.x / texture_size.y

                local size_x = size.y * aspect_ratio
                local actual_pos = pos + vec2_t.new( size.x / 2 - size_x / 2, 0 )
                local actual_size = vec2_t.new( size_x, size.y )

                render.texture(
                    images.primordial_inside.id,
                    actual_pos,
                    actual_size,
                    colors.accent
                )
            end
        else
            self.custom_logo_function( gui.pos + vec2_t.new( 0, 20 ), vec2_t.new( self.subtab_size.x, self.subtab_size.x - 20 ) )
        end

        -- render black line on the right of the subtab menu
        render.line(
            gui.pos + vec2_t.new( self.subtab_size.x, 0 ),
            gui.pos + vec2_t.new( self.subtab_size.x, self.size.y ),
            self.colors.black
        )
    end

    function gui:render_footer( )
        -- resizable corner on bottom right
        local points = { }
        local color = self.colors.dark_background
        if self.resizable then
            local in_bounds = input.is_mouse_in_bounds( self.pos + self.size - vec2_t.new( 30, 30 ), vec2_t.new( 30, 30 ) )

            color = in_bounds and colors.accent or
                                  self.colors.dark_background


            if in_bounds or gui.is_resizing then
                self.can_drag = false

                if gui.is_resizing or input.is_key_held( key.MOUSE_LEFT ) then
                    self.size = input.get_mouse_pos( ) - self.pos - self.resize_mouse_difference
                    gui.is_resizing = true
                else
                    self.resize_mouse_difference = input.get_mouse_pos( ) - ( self.pos + self.size )
                end

                if self.size.x < self.min_size.x then
                    self.size.x = self.min_size.x
                end

                if self.size.y < self.min_size.y then
                    self.size.y = self.min_size.y
                end
            end

            if not input.is_key_held( key.MOUSE_LEFT ) and gui.is_resizing then
                gui.is_resizing = false

                gui.subtab_size = vec2_t.new( 200, gui.size.y )
                gui.footer_size = vec2_t.new( gui.size.x, 70 )
                gui.section_width = ( self.size.x - gui.subtab_size.x - 10 - 10 - 10 ) / 2
            end

            if gui.is_resizing then
                gui.subtab_size = vec2_t.new( 200, gui.size.y )
                gui.footer_size = vec2_t.new( gui.size.x, 70 )

                gui.section_width = ( self.size.x - gui.subtab_size.x - 10 - 10 - 10 ) / 2
            end

            local start_pos = self.pos + self.size

            points = {
                vec2_t.new( start_pos.x - 13, start_pos.y ),
                vec2_t.new( start_pos.x, start_pos.y - 13 ),
                vec2_t.new( start_pos.x, start_pos.y - 6 ),
                vec2_t.new( start_pos.x - 6, start_pos.y ),
            }
        end

        -- render footer background
        render.rect_filled(
            gui.pos + vec2_t.new( 0, self.size.y - self.footer_size.y ),
            self.footer_size,
            self.colors.footer_background,
            10
        )

        -- fill rounding on top of the footer
        render.rect_filled(
            gui.pos + vec2_t.new( 0, self.size.y - self.footer_size.y ),
            vec2_t.new( self.size.x, 10 ),
            self.colors.footer_background
        )

        -- render black line on the top of the footer
        render.line(
            gui.pos + vec2_t.new( 0, self.size.y - self.footer_size.y ),
            gui.pos + vec2_t.new( self.size.x, self.size.y - self.footer_size.y ),
            colors.accent
        )

        if #points > 0 then
            render.polygon(
                points,
                color
            )
        end
    end

    function gui:render_elements( )
        local section_order = gui.subtab_sections[ gui.current_page ][ gui.current_subtab ]
        local items = gui.pages[ gui.current_page ][ gui.current_subtab ]

        local scroll_amount = self.scroll[ self.current_page ][ self.current_subtab ]

        local element_pos_left = gui.pos + vec2_t.new( gui.subtab_size.x + 10, 40 + scroll_amount )
        local element_pos_right = gui.pos + vec2_t.new( gui.subtab_size.x + 10 + gui.section_width + 10, 40 + scroll_amount )

        local draw_topmost = { }

        local max_height = gui.size.y - ( gui.footer_size.y - 40 )

        local last_side = 0
        local interaction_table = gui.interacting_element
        for i = 1, #section_order do
            local _section = section_order[ i ]
            local subtab_elements = items[ _section ]

            local element_start_pos = last_side % 2 == 0 and vec2_t.new(
                element_pos_left.x,
                element_pos_left.y + 10
            ) or vec2_t.new(
                element_pos_right.x,
                element_pos_right.y + 10
            )
            
            for _, element in pairs( subtab_elements ) do
                -- skip keybinds and colorpickers 
                if element._type == element_types.keybind or element._type == element_types.colorpicker then
                    goto continue
                end

                local is_interacting_this_element = interaction_table.interacting and
                                                    interaction_table.page == element.page and
                                                    interaction_table.tab == element.tab and
                                                    interaction_table.section == element.section and
                                                    interaction_table.element == element

                local y_pos = element_start_pos.y

                -- if element is out of bounds
                -- or if element is a list, we apply different logic
                -- this is because smaller elements will be covered by the footer, list is too big (wait nvm i can just fuck the height uwu the height)
                if ( y_pos + element:get_visual_height( ) < gui.pos.y + max_height and element._type ~= element_types.list ) or ( element._type == element_types.list and y_pos < self.pos.y + self.size.y - self.footer_size.y and ( y_pos - 1 ) > self.pos.y - element.height ) then                  
                    if not element.render_topmost then
                        element:render( element_start_pos, gui.section_width, is_interacting_this_element )
                    else
                        table.insert( draw_topmost, {
                            element = element,
                            pos = vec2_t.new( element_start_pos.x, element_start_pos.y ),
                            width = gui.section_width,
                            interacting = is_interacting_this_element
                        } )
                    end

                    local total_right_offset = 0

                    local extras_to_draw = { }

                    for extras_iter = 1, #element.extras do
                        local extra = element.extras[ extras_iter ]
                        local pos = vec2_t.new( element_start_pos.x - total_right_offset, element_start_pos.y )
                        table.insert( extras_to_draw, {
                            element = extra,
                            pos = pos,
                            width = gui.section_width,
                            interacting = is_interacting_this_element
                        } )

                        local _, extra_size = extra:in_bounds( pos, gui.section_width )

                        total_right_offset = total_right_offset + extra_size.x
                    end

                    for extra_iter = #extras_to_draw, 1, -1 do
                        table.insert( draw_topmost, extras_to_draw[ extra_iter ] )
                    end
                end
                                    
                element_start_pos.y = element_start_pos.y + element:get_visual_height( )

                ::continue::
            end

            -- render section background
            local pos = last_side % 2 == 0 and element_pos_left or element_pos_right
            pos.y = pos.y - 10
            local total_height = element_start_pos.y - pos.y
            
            if last_side % 2 == 0 then
                element_pos_left.y = element_pos_left.y + total_height + 20
            else
                element_pos_right.y = element_pos_right.y + total_height + 20
            end

            last_side = last_side + 1
        end

        for i = #draw_topmost, 1, -1 do
            local element = draw_topmost[ i ].element
            local pos = draw_topmost[ i ].pos
            local width = draw_topmost[ i ].width
            local interacting = draw_topmost[ i ].interacting

            element:render( pos, width, interacting )
        end
    end

    function gui:render( )
        gui:handle_keybinds( )
        if not menu_is_open( ) then return end

        -- rendering background, subtab sidebar, logo
        gui:render_background( )

        -- handle and render subtabs
        gui:handle_subtabs( )

        -- we also render the sections here
        -- returns true/false based on if we can drag
        local draggable = gui:handle_elements( )

        -- logic to not drag when interacting with menu elements
        if not draggable then
            gui.can_drag = false
        end

        if not input.is_key_held( key.MOUSE_LEFT ) and draggable then
            gui.can_drag = true
        end

        -- render elements
        gui:render_elements( )

        -- render header and footer
        gui:render_header( )
        gui:render_footer( )

        -- handle and render pages
        gui:handle_pages( )

        -- handle every menu element input before rendering and handleing dragging
        gui:handle_drag( )
    end

    return gui
end

callbacks.add( e_callbacks.PAINT, function ( )
    colors.accent = refs.accent:get( )
end)

return menu