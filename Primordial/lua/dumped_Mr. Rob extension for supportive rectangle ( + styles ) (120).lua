local httpFactory = require("primordial/Lightweight HTTP Library.46")

local http = httpFactory.new({
    task_interval = 0.3, -- polling intervals
    enable_debug = false, -- print http requests to the console
    timeout = 10 -- request expiration time
})

local master_switch = menu.add_checkbox('advanced mr. rob', 'master switch')

local menu_elems = {
    style = menu.add_selection('advanced mr. rob', 'what style we picking today sir', { 'default', 'elegant', 'neymar', 'minion' }),
    skin_color = menu.add_selection('advanced mr. rob', 'race', { 'primordial', 'white', 'black' }),
    minion_style = menu.add_selection('advanced mr. rob', 'minion style', { 'Bob', 'Carl' }),
}

render.multiple_lines = function( points, color )
    for i = 1, #points - 1 do
        local p1 = points[ i ]
        local p2 = points[ i + 1 ]

        render.line( p1, p2, color )
    end
end

local vars = {
    font = render.create_font('Arial Bold', 16, 400, e_font_flags.ANTIALIAS),

    minions_suit = nil,

    expression_offsets = {
        eyebrows = {
            ['outer'] = 0,
            ['inner'] = 0
        },
        eyelids = {
            ['side_mid'] = 2,
            ['most_mid'] = 4
        },
        mouth = false, -- false
    },
    last_kill_time = 0,
    saying = '',

    sayings = {
        elegant = {
            'Well done, ' .. user.name .. '!',
            'Please, enjoy this glass of wine with me.',
            'That was beautilous!',
            'Son of a gun, that was immaculate!',
            'You are an expreienced gentelman, mr. ' .. user.name .. '!',
            'Beatilous.',
            'Quite an amazing job',
            'Wonderful takedown!',
        },
        neymar = {
            'You got him!',
            'You must be drowning in pussy',
            'Fuck!',
            'I don\'t think they\'ll be alive after that.',
            'Good job!',
            'you > him',
            'You showed that dog its\' place :o'
        },
        minion = {
            'C’est banana! Hahaha! Miam Miam! Huh?',
            'No, no, no! Hey, a piñata!',
            'Banana!',
            'Uh, la cucaracha?',
            'Luk at u! Kan pai!',
            'Bee do! Bee do! Bee do! Bee do! Bee do!',
            'Underwear me want banana!',
            'Bee doo bee do la la la (farts)',
            'Ka ko wuddub mi jighum', -- okay some of these are made with translators and are shit because i cant think of any minion sayings oops
            'BANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANABANANA'
        }
    },

    expressions = {'surprised', 'happy'},
    current_expression = nil,

    expression_offsets_named = {
        ['surprised'] = {
            eyebrows = {
                ['outer'] = 3,
                ['inner'] = 5
            },
            eyelids = {
                ['side_mid'] = 4,
                ['most_mid'] = 4
            },
            mouth = 'surprised',
        },
        ['happy'] = {
            eyebrows = {
                ['outer'] = 2,
                ['inner'] = 2
            },
            eyelids = {
                ['side_mid'] = 3,
                ['most_mid'] = 4
            },
            mouth = 'happy',
        }
    },
}

http:get( 'https://shibe.host/LzyDnNjma3v0/direct', function( data )
    print( data.body )
    vars.minions_suit = render.load_image_buffer( data.body )
end )

local menu_handler = function( )
    for key, _ in pairs( menu_elems ) do
        menu_elems[ key ]:set_visible( master_switch:get( ) )
    end

    if not master_switch:get( ) then return end
    
    menu_elems.skin_color:set_visible( menu_elems.style:get( ) ~= 4 )
    menu_elems.minion_style:set_visible( menu_elems.style:get( ) == 4 )
end

local event_handler = function(event) 
    if event.name == 'player_death' then 
        if engine.get_player_index_from_user_id(event.attacker) == engine.get_local_player_index() then 
            vars.last_kill_time = client.get_unix_time()
            vars.current_expression = vars.expressions[client.random_int(1, #vars.expressions)]
            local sayings_table
            if menu_elems.style:get() == 2 then
                sayings_table = vars.sayings.elegant
            elseif menu_elems.style:get() == 4 then
                sayings_table = vars.sayings.minion
            else
                sayings_table = vars.sayings.neymar
            end
    
            local say = sayings_table[client.random_int(1, #sayings_table)]
            if say == vars.saying then
                say = sayings_table[client.random_int(1, #sayings_table)]
            end
            vars.saying = say
        end
    end
end

local expression_handler = function()
    if vars.last_kill_time + 4 > client.get_unix_time() then
        local expression_table_name = vars.current_expression

        vars.expression_offsets.eyelids['side_mid'] = vars.expression_offsets_named[expression_table_name].eyelids['side_mid']
        vars.expression_offsets.eyelids['most_mid'] = vars.expression_offsets_named[expression_table_name].eyelids['most_mid']

        vars.expression_offsets.eyebrows['outer'] = vars.expression_offsets_named[expression_table_name].eyebrows['outer']
        vars.expression_offsets.eyebrows['inner'] = vars.expression_offsets_named[expression_table_name].eyebrows['inner']

        vars.expression_offsets.mouth = vars.expression_offsets_named[expression_table_name].mouth
    else
        vars.expression_offsets.eyelids['side_mid'] = 2
        vars.expression_offsets.eyelids['most_mid'] = 4

        vars.expression_offsets.eyebrows['outer'] = 0
        vars.expression_offsets.eyebrows['inner'] = 0

        vars.expression_offsets.mouth = false

        vars.current_expression = nil
    end
end

local get_mouse_angle = function ( origin )
    local mouse_pos = input.get_mouse_pos( )

    local x = mouse_pos.x - origin.x
    local y = mouse_pos.y - origin.y

    return math.atan2( y, x )
end

local angle_to_vector = function( angle )
    return vec2_t( math.cos( angle ), math.sin( angle ) )
end

local draw_normal = function ( pos, size, mood, phrase, eye_offset)
    local color = menu_elems.skin_color:get() == 1 and color_t(31, 31, 31, 255) or menu_elems.skin_color:get() == 2 and color_t(232, 190, 172, 255) or menu_elems.skin_color:get() == 3 and color_t(134, 90, 72, 255)

    -- render race
    render.rect_filled(pos, size, color, 7)

    local eye_center = pos + vec2_t(size.x/2, size.y/3)
    local eyebrow_center = eye_center - vec2_t(0, 17)
    local mouth_center = pos + vec2_t(size.x/2, size.y/3 * 2)

    -- eyes
    -- eye bg
    render.circle_filled(eye_center - vec2_t(20, 0), 10, color_t(255, 255, 255, 255))
    render.circle_filled(eye_center + vec2_t(20, 0), 10, color_t(255, 255, 255, 255))

    -- pupil (? the colored part i dont englisk)
    render.circle_filled(eye_center - vec2_t(20, 0) + eye_offset, 7, color_t(10, 80, 111, 255))
    render.circle_filled(eye_center + vec2_t(20, 0)+ eye_offset, 7, color_t(10, 80, 111, 255))

    -- black dot in middle
    render.circle_filled(eye_center - vec2_t(20, 0) + eye_offset, 4, color_t(0, 0, 0, 255))
    render.circle_filled(eye_center + vec2_t(20, 0) + eye_offset, 4, color_t(0, 0, 0, 255))

    -- moods (eyebrows, eyelid modulating, mouth) make better later
    -- eyebrows
    render.polygon({ -- left
        eyebrow_center - vec2_t(30, vars.expression_offsets.eyebrows['outer'] - 4), -- outer top
        eyebrow_center - vec2_t(30, vars.expression_offsets.eyebrows['outer']), -- outer lower
        eyebrow_center - vec2_t(12, vars.expression_offsets.eyebrows['inner']), -- inner lower
        eyebrow_center - vec2_t(12, vars.expression_offsets.eyebrows['inner'] - 4), -- inner top

    }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    render.polygon({ -- right
        eyebrow_center + vec2_t(28, vars.expression_offsets.eyebrows['outer'] + 4), -- outer top
        eyebrow_center + vec2_t(28, vars.expression_offsets.eyebrows['outer']), -- outer lower
        eyebrow_center + vec2_t(10, vars.expression_offsets.eyebrows['inner']), -- inner lower
        eyebrow_center + vec2_t(10, vars.expression_offsets.eyebrows['inner'] + 4), -- inner top

    }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    --render.rect_filled(eyebrow_center - vec2_t(30, 0), vec2_t(18, 4), color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))
    --render.rect_filled(eyebrow_center + vec2_t(10, 0), vec2_t(18, 4), color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    -- eyelids
    -- left side one (left eyelid)
    render.polygon(
        {
            eye_center - vec2_t(32, 0), -- most left point
            eye_center - vec2_t(25, vars.expression_offsets.eyelids['side_mid']), -- right mid point
            eye_center - vec2_t(20, vars.expression_offsets.eyelids['most_mid']), -- mid point

            -- this is for the 'arc'
            eye_center - vec2_t(20, 12), -- top mid
            eye_center - vec2_t(22.5, 11),
            eye_center - vec2_t(25, 10),
            eye_center - vec2_t(27.5, 8),
            eye_center - vec2_t(30, 6),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    -- right side one (left eyelid)
    render.polygon(
        {
            eye_center - vec2_t(8, 0), -- most right point
            eye_center - vec2_t(15, vars.expression_offsets.eyelids['side_mid']), -- left mid point
            eye_center - vec2_t(20, vars.expression_offsets.eyelids['most_mid']), -- mid point

            -- this is for the 'arc'
            eye_center - vec2_t(20, 12), -- top mid
            eye_center - vec2_t(17.5, 11),
            eye_center - vec2_t(15, 10),
            eye_center - vec2_t(12.5, 8),
            eye_center - vec2_t(10, 6),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))


    -- left side one (right eyelid)
    render.polygon(
        {
            eye_center + vec2_t(8, 0), -- most left point
            eye_center + vec2_t(15, -vars.expression_offsets.eyelids['side_mid']), -- right mid point
            eye_center + vec2_t(20, -vars.expression_offsets.eyelids['most_mid']), -- mid point

            -- this is for the 'arc'
            eye_center + vec2_t(20, -12), -- top mid
            eye_center + vec2_t(17.5, -11),
            eye_center + vec2_t(15, -10),
            eye_center + vec2_t(12.5, -8),
            eye_center + vec2_t(10, -6),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    -- right side one (right eyelid)
    render.polygon(
        {
            eye_center + vec2_t(32, 0), -- most right point
            eye_center + vec2_t(25, -vars.expression_offsets.eyelids['side_mid']), -- left mid point
            eye_center + vec2_t(19, -vars.expression_offsets.eyelids['most_mid']), -- mid point

            -- this is for the 'arc'
            eye_center + vec2_t(19, -12), -- top mid
            eye_center + vec2_t(27.5, -8),
            eye_center + vec2_t(25, -7),
            eye_center + vec2_t(22.5, -6),
            eye_center + vec2_t(20, -4),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

    -- mouth
    if not vars.expression_offsets.mouth then
        render.rect_filled(mouth_center - vec2_t(10, 0), vec2_t(20, 5), color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))
    elseif vars.expression_offsets.mouth == 'surprised' then
        render.circle_filled(mouth_center, 10, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))
        render.circle_filled(mouth_center, 8, color_t(0, 0, 0, 255))
    elseif vars.expression_offsets.mouth == 'happy' then
        render.rect_filled(mouth_center - vec2_t(5, 0), vec2_t(10, 5), color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))
        render.polygon({
            mouth_center - vec2_t(5, 1),
            mouth_center - vec2_t(10, 2),
            mouth_center - vec2_t(7, -4),
            mouth_center - vec2_t(5, -4),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))

        render.polygon({
            mouth_center + vec2_t(5, -1),
            mouth_center + vec2_t(10, -2),
            mouth_center + vec2_t(7, 4),
            mouth_center + vec2_t(5, 4),
            
        }, color_t(math.floor(color.r * 1.5), math.floor(color.g * 1.5), math.floor(color.b * 1.5), 255))
    end

    if menu_elems.style:get() == 2 then -- elegant brrrrrrrr
        -- render elegant hat (max elegancy!)
        render.rect_filled(pos - vec2_t(10, 0), vec2_t(size.x + 20, 10), color_t(0, 0, 0, 255), 5)
        render.rect_filled(pos - vec2_t(0, 40), vec2_t(size.x, 50), color_t(0, 0, 0, 255), 5)

        -- yeah we need a monocle
        -- main eye part
        render.circle(eye_center - vec2_t(20, 0), 10, color_t(255, 215, 0, 255))
        render.circle(eye_center - vec2_t(20, 0), 11, color_t(255, 215, 0, 255))
        render.circle(eye_center - vec2_t(20, 0), 12, color_t(255, 215, 0, 255))
        -- trail to side
        local current_iterators = 3
        for i = -1, 1, 0.3 do
            render.circle(eye_center - vec2_t(27 + current_iterators, -10 - (3 - i*i*4)), 3, color_t(225, 215, 0, 255))
            current_iterators = current_iterators + 3
        end

        -- wine glass
        local wine_glass_start = pos + vec2_t(-15, 20)

        -- the drink inside of it
        render.polygon({
            wine_glass_start + vec2_t(0, 6), -- top right
            wine_glass_start + vec2_t(0, 10), -- lower right (for the right side line) 
            -- this here is for the curve
            wine_glass_start + vec2_t(1, 11),
            wine_glass_start + vec2_t(2, 11.5),
            wine_glass_start + vec2_t(3, 13),
            wine_glass_start + vec2_t(4, 11.5),
            wine_glass_start + vec2_t(5, 11),
            -- left side line
            wine_glass_start + vec2_t(5, 6)

        }, color_t(255, 215, 0, 100))

        -- outline
        render.polyline({
            wine_glass_start, -- top right
            wine_glass_start + vec2_t(0, 10), -- lower right (for the right side line) 
            -- this here is for the curve
            wine_glass_start + vec2_t(1, 11),
            wine_glass_start + vec2_t(2, 11.5),
            wine_glass_start + vec2_t(3, 13),
            wine_glass_start + vec2_t(4, 11.5),
            wine_glass_start + vec2_t(5, 11),
            -- left side line
            wine_glass_start + vec2_t(5, 0),

            -- all of this is needed to not close the glass
            wine_glass_start + vec2_t(5, 11),
            wine_glass_start + vec2_t(4, 11.5),
            wine_glass_start + vec2_t(3, 13),
            wine_glass_start + vec2_t(2, 11.5),
            wine_glass_start + vec2_t(1, 11),



        }, color_t(255, 255, 255, 255))
        
        -- glass 'leg'
        render.line(wine_glass_start + vec2_t(3, 13), wine_glass_start + vec2_t(3, 20), color_t(255, 255, 255, 255))
        render.line(wine_glass_start + vec2_t(0, 20), wine_glass_start + vec2_t(6, 20), color_t(255, 255, 255, 255))

    elseif menu_elems.style:get() == 3 then -- neymar
        -- cap
        render.push_clip(pos - vec2_t(0, size.y), size + vec2_t(0, 10))
        render.circle_filled(pos + vec2_t(size.x/2, 15), size.x/2, color.new(10, 10, 10, 255))
        render.pop_clip()
        render.rect_filled(pos - vec2_t(30, -5), vec2_t(40, 5), color_t(15, 15, 15, 255))
        -- glasses
        -- left side
        -- inner glasses
        render.rect_fade(eye_center - vec2_t(29, 5), vec2_t(20, 12.5), color_t(240, 20, 20, 255), color_t(200, 100, 100, 255), true)
        -- outer glasses
        render.push_clip(eye_center - vec2_t(34, 6), vec2_t(30, 15))
        render.circle(eye_center - vec2_t(20, 0), 10, color_t(200, 200, 200, 255))
        render.circle(eye_center - vec2_t(20, 0), 11, color_t(200, 200, 200, 255))
        render.pop_clip()
        -- upper outline
        render.rect_filled(eye_center - vec2_t(28, 7), vec2_t(17, 2), color_t(200, 200, 200, 255), 0)
        render.rect_filled(eye_center - vec2_t(26, 7.5), vec2_t(13, 2), color_t(200, 200, 200, 255), 0)
        -- lower outline
        render.rect_filled(eye_center - vec2_t(28, -7), vec2_t(16, 2), color_t(200, 200, 200, 255), 0)
        render.rect_filled(eye_center - vec2_t(26, -8), vec2_t(13, 2), color_t(200, 200, 200, 255), 0)

        -- right side
        render.rect_fade(eye_center + vec2_t(11, -5), vec2_t(19.5, 12.5), color_t(240, 20, 20, 255), color_t(200, 100, 100, 255), true)
        -- outer glasses
        render.push_clip(eye_center + vec2_t(8, -6), vec2_t(24, 14))
        render.circle(eye_center + vec2_t(20, 0), 10, color_t(200, 200, 200, 255))
        render.circle(eye_center + vec2_t(20, 0), 11, color_t(200, 200, 200, 255))
        render.pop_clip()
        -- upper outline
        render.rect_filled(eye_center + vec2_t(13, 7), vec2_t(15, 2), color_t(200, 200, 200, 255), 0)
        render.rect_filled(eye_center + vec2_t(15, 8), vec2_t(10, 2), color_t(200, 200, 200, 255), 0)
        -- lower outline
        render.rect_filled(eye_center + vec2_t(13, -7), vec2_t(15, 2), color_t(200, 200, 200, 255), 0)
        render.rect_filled(eye_center + vec2_t(15, -8), vec2_t(10, 2), color_t(200, 200, 200, 255), 0)

        -- side connector
        render.push_clip(eye_center - vec2_t(10, 10), vec2_t(20, 20))
        for i = 0, 5, 1 do
            render.circle(eye_center + vec2_t(0, 10 + i), 15, color_t(200, 200, 200, 255))
        end
        render.pop_clip()

        -- beard
        -- lower
        local iteration = -1
        for i = -5, 5.1, 0.1 do
            render.line(pos + vec2_t(iteration, size.y/3*2 + (25 - i*i)*0.45), pos + vec2_t(iteration, size.y/3 + 65 + (25 - i*i)), color_t(111, 78, 55, 255))
            iteration = iteration + 1
        end
        -- upper
        local iteration = -1
        for i = -5, 5, 0.1 do
            render.line(mouth_center - vec2_t(50 - iteration, (20 + (16-i*i)) - 30), mouth_center - vec2_t(50 - iteration, (20 + (16-i*i)) - 20), color_t(111, 78, 55, 255))
            iteration = iteration + 1
        end
    end
end

local draw_minion = function( pos, size, mood, phrase, eye_offset )
    local color = color_t( 245, 204, 76, 255 ) 

    local is_one_eyed = menu_elems.minion_style:get( ) == 2

    local padding = vec2_t( 5, 5 )

    render.push_clip( pos - padding, size + padding + padding )

    -- render race
    render.rect_filled(pos - padding, size + padding + padding, color, 15)

    local eye_center = pos + vec2_t(size.x/2, size.y/3)

    if is_one_eyed then
        eye_center = eye_center - vec2_t( 20, 0 )
    end
    local eyebrow_center = eye_center - vec2_t(0, 17)
    local mouth_center = pos + vec2_t(size.x/2, size.y/5 * 3)

    -- render face & expressions with offsets
    local offset = vars.expression_offsets.eyebrows.outer * 2

    local eyebrow_poly_upper_arc = { }
    eyebrow_poly_upper_arc[ '1' ] = { }
    eyebrow_poly_upper_arc[ '-1' ] = { }

    local eyebrow_poly_cleanup = { }
    eyebrow_poly_cleanup[ '1' ] = { }
    eyebrow_poly_cleanup[ '-1' ] = { }


    eyebrow_poly_upper_arc[ '-1' ][ #eyebrow_poly_upper_arc[ '-1' ] + 1] = eye_center + vec2_t( 4, 0 ) + vec2_t( 16, -7 - offset )
    eyebrow_poly_upper_arc[ '1' ][ #eyebrow_poly_upper_arc[ '1' ] + 1 ]  = eye_center + vec2_t( -4, 0 ) + vec2_t( -16, -7 - offset )
    eyebrow_poly_upper_arc[ '-1' ][ #eyebrow_poly_upper_arc[ '-1' ] + 1] = eye_center + vec2_t( 4, 0 ) + vec2_t( 11, -7 - offset/2 )
    eyebrow_poly_upper_arc[ '1' ][ #eyebrow_poly_upper_arc[ '1' ] + 1 ]  = eye_center + vec2_t( -4, 0 ) + vec2_t( -11, -7 - offset/2 )
    eyebrow_poly_upper_arc[ '-1' ][ #eyebrow_poly_upper_arc[ '-1' ] + 1] = eye_center + vec2_t( 4, 0 ) + vec2_t( 6, -7 - offset/4 )
    eyebrow_poly_upper_arc[ '1' ][ #eyebrow_poly_upper_arc[ '1' ] + 1 ]  = eye_center + vec2_t( -4, 0 ) + vec2_t( -6, -7 - offset/4 )

    for i = 10, 170, 10 do
        local y = -math.sin( math.rad( i ) ) * 10 - 5
        local progress = i / 180
        local x = progress * 32

        if progress < 0.5 then
            x = x + 1.5
        else
            x = x - 1.5
        end


        eyebrow_poly_upper_arc[ '-1' ][ #eyebrow_poly_upper_arc[ '-1' ] + 1] = eye_center + vec2_t( 4, 0 ) + vec2_t( x, y )
        eyebrow_poly_upper_arc[ '1' ][ #eyebrow_poly_upper_arc[ '1' ] + 1 ]  = eye_center + vec2_t( -4, 0 ) + vec2_t( -x, y )
    end

    render.rect_filled( pos + vec2_t( -padding.x, ( eye_center.y - pos.y ) - 3), vec2_t( size.x + padding.x + padding.x, 6 ), color_t(10, 10, 10, 255), 0 )

    for j = 1, 2 do
        local i = -j
        if i % 2 == 0 then i = 1 if is_one_eyed then break end end

        render.circle_filled(eye_center - vec2_t(20 * i, 0), 16, color_t(155, 155, 155, 255))

        -- eye bg
        render.circle_filled(eye_center - vec2_t(20 * i, 0), 13, color_t(255, 255, 255, 255))

        -- pupil
        render.circle_filled(eye_center - vec2_t(20 * i, 0) + eye_offset, 6, color_t(10, 80, 111, 255))

        -- black dot in middle
        render.circle_filled(eye_center - vec2_t(20 * i, 0) + eye_offset, 3, color_t(0, 0, 0, 255))

        render.polygon(  
            eyebrow_poly_upper_arc[ tostring( i ) ], color
        )

        render.polygon(  
            eyebrow_poly_cleanup[ tostring( i ) ], color_t(155, 155, 155, 255)
        )


    end

    -- draw suit
    if vars.minions_suit ~= nil then
        render.texture( vars.minions_suit.id, pos + vec2_t( 0, size.y - 40 ) - padding, vec2_t( size.x + 1, 60 ) + padding + padding )
    end

    render.multiple_lines( {
        mouth_center + vec2_t( -10, -offset/2 ),
        mouth_center + vec2_t( -6, -offset/5 ),
        mouth_center + vec2_t( 0, 0 ),
        mouth_center + vec2_t( 6, -offset/5 ),
        mouth_center + vec2_t( 10, -offset/2 ),
    }, color_t( 0, 0, 0, 255 ))

    render.pop_clip( )
end

local on_supportive_rectangle = function(pos, size, mood, phrase)
    if not master_switch:get() then return false end

    local eye_center = pos + vec2_t(size.x/2, size.y/3)
    local eye_offset = angle_to_vector( get_mouse_angle( eye_center ) ) 
    eye_offset = eye_offset + eye_offset

    if menu_elems.style:get( ) ~= 4 then
        draw_normal( pos, size, mood, phrase, eye_offset )
    else
        draw_minion( pos, size, mood, phrase, eye_offset )
    end

    -- saying 
    if vars.last_kill_time + 4 > client.get_unix_time() then
        local text_size = render.get_text_size(vars.font, vars.saying)
        render.rect_filled(pos + vec2_t(10 + size.x, -20), text_size + vec2_t(10, 10), color_t(41, 41, 41, 255), 5)
        render.text(vars.font, vars.saying, pos + vec2_t(15  + size.x, -text_size.y), color_t(255, 255, 255, 255))
        render.polygon({
            pos + vec2_t(15 + size.x, -15 + text_size.y),
            pos + vec2_t(14 + size.x, -5 + text_size.y),
            pos + vec2_t(10 + size.x, -3 + text_size.y),
            pos + vec2_t(8 + size.x, -1 + text_size.y),
            pos + vec2_t(14 + size.x, -3 + text_size.y),
            pos + vec2_t(16 + size.x, -5 + text_size.y),
            pos + vec2_t(20 + size.x, -10 + text_size.y),
            pos + vec2_t(20 + size.x, -15 + text_size.y),
        }, color_t(41, 41, 41, 255))
    end
    
    return true
end

callbacks.add( e_callbacks.SUPPORTIVE_RECTANGLE, on_supportive_rectangle )

callbacks.add( e_callbacks.PAINT, function( )
    expression_handler( )
    menu_handler( )
end )
callbacks.add( e_callbacks.EVENT, event_handler )