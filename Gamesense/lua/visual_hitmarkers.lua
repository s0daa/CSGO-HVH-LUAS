local shot_data = { }
local font = render.create_font( "verdana.ttf", 18 )
local hit_marker = gui.add_checkbox( "Enable world hitmarker", "lua>tab b" )
local hit_marker_color = gui.add_colorpicker( "lua>tab b>enable world hitmarker", false, render.color( 255, 255, 255 ) )
local hit_marker_hs_color = gui.add_colorpicker( "lua>tab b>enable world hitmarker", false, render.color( 255, 0, 0 ) )
local hit_marker_kill_color = gui.add_colorpicker( "lua>tab b>enable world hitmarker", false, render.color( 255, 250, 0 ) )

function on_paint( )
    if not hit_marker:get_bool( ) then
        return
    end

    local size = 3.5
    local size2 = 2.5

    for tick, data in pairs( shot_data ) do
        if data.draw then
            if global_vars.curtime >= data.time then
                data.alpha = data.alpha - 2
            end

            if data.alpha <= 0 then
                data.alpha = 0
                data.draw = false
            end

            local sx, sy = utils.world_to_screen( data.x, data.y, data.z )
            if sx ~= nil then
                local color

                if data.hs then
                    color = hit_marker_hs_color:get_color( )
                elseif data.kill then
                    color = hit_marker_kill_color:get_color( )
                else
                    color = hit_marker_color:get_color( )
                end

                local damage_text = data.damage .. ''
                local w, h = render.get_text_size( font, damage_text )

                render.text( font, sx - w / 2, sy - size * 2 - h * 1.1 + 12, damage_text, render.color( color.r, color.g, color.b, data.alpha ), render.align_top, render.align_center )

                render.line( sx - size, sy - size, sx - ( size * size2 ), sy - ( size * size2 ), render.color( 255, 255, 255, math.floor( data.alpha ) ) ) -- left upper
                render.line( sx - size, sy + size, sx - ( size * size2 ), sy + ( size * size2 ), render.color( 255, 255, 255, math.floor( data.alpha ) ) ) -- left down
                render.line( sx + size, sy + size, sx + ( size * size2 ), sy + ( size * size2 ), render.color( 255, 255, 255, math.floor( data.alpha ) ) ) -- right down
                render.line( sx + size, sy - size, sx + ( size * size2 ), sy - ( size * size2 ), render.color( 255, 255, 255, math.floor( data.alpha ) ) ) -- right upper

            end
        end
    end
end

function on_player_hurt( e )
    if not hit_marker:get_bool( ) then
        return
    end

    local victim_index = entities.get_entity( engine.get_player_for_user_id( e:get_int( "userid" ) ) )
    local attacker_index = engine.get_player_for_user_id( e:get_int( "attacker" ) )

    if attacker_index ~= engine.get_local_player( ) then
        return
    end

    local tick = global_vars.tickcount
    local data = shot_data[ tick ]

    if shot_data[ tick ] == nil or data.impacts == nil then
        return
    end

    local hitgroups = {
        [1] = { 0, 1 },
        [2] = { 4, 5, 6 },
        [3] = { 2, 3 },
        [4] = { 13, 15, 16 },
        [5] = { 14, 17, 18 },
        [6] = { 7, 9, 11 },
        [7] = { 8, 10, 12 }
    }

    local impacts = data.impacts
    local hitboxes = hitgroups[ e:get_int( "hitgroup" ) ]
    
    local hit = nil
    local closest = math.huge

    for i=1, #impacts do
        local impact = impacts[ i ]

        if hitboxes ~= nil then
            for j=1, #hitboxes do
                local x, y, z = victim_index:get_hitbox_position( hitboxes[ j ] )
                local distance = math.sqrt( ( impact.x - x )^2 + ( impact.y - y )^2 + ( impact.z - z )^2 )

                if distance < closest then
                    hit = impact
                    closest = distance
                end
            end
        end
    end

    if hit == nil then
        return
    end

    shot_data[ tick ] = {
        x = hit.x,
        y = hit.y,
        z = hit.z,
        time = global_vars.curtime + 1 - 0.25,
        alpha = 255,
        damage = e:get_int( "dmg_health" ),
        kill = e:get_int( "health" ) <= 0,
        hs = e:get_int( "hitgroup" ) == 0 or e:get_int( "hitgroup" ) == 1,
        draw = true,
    }
end

function on_bullet_impact( e )
    if not hit_marker:get_bool( ) then
        return
    end

    if engine.get_player_for_user_id( e:get_int( "userid" ) ) ~= engine.get_local_player( ) then
        return
    end

    local tick = global_vars.tickcount

    if shot_data[ tick ] == nil then
        shot_data[ tick ] = {
            impacts = { }
        }
    end

    local impacts = shot_data[ tick ].impacts

    if impacts == nil then
        impacts = { }
    end

    impacts[ #impacts + 1 ] = {
        x = e:get_int( "x" ),
        y = e:get_int( "y" ),
        z = e:get_int( "z" )
    }
end

function on_round_start( )
    if not hit_marker:get_bool( ) then
        return
    end

    shot_data = { }
end