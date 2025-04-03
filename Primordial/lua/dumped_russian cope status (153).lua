local http = require 'http'.new{
        task_interval = 0.3,
        timeout = 10,
        enable_debug = false
    }

    local g_data, g_last_data_update = nil, 0

    local g_data_received_callback = function( data )
        if data:success( ) then
            local total, destroyed, damaged, abandoned, captured = data.body:match 'Russia %- (%d+), of which: destroyed: (%d+), damaged: (%d+), abandoned: (%d+), captured: (%d+)'

            g_data = {
                { 'Russian cope status: ' },
                { 'Total: ', total },
                { 'Destroyed: ', destroyed },
                { 'Damaged: ', damaged },
                { 'Abandoned: ', abandoned },
                { 'Captured: ', captured }
            }
        end
    end

    local g_default_font = render.get_default_font( )

    local g_render = function( )
        local rt = global_vars.real_time( )

        if rt > g_last_data_update then
            http:get( 'https://www.oryxspioenkop.com/2022/02/attack-on-europe-documenting-equipment.html', g_data_received_callback )
            g_last_data_update = rt + 20
        end

        if not g_data then
            return
        end

        local render_position_start = render.get_screen_size( ) * vec2_t( 0.5, 0.75 )

        for iter, data in ipairs( g_data ) do
            render.text(
                g_default_font,
                table.concat( data ),
                render_position_start + vec2_t( 0, 13 * ( iter - 1 ) ),
                color_t( 255, 255, 255 ),
                true
            )
        end
    end

    callbacks.add( e_callbacks.PAINT, g_render )