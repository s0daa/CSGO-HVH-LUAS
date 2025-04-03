-- local variables for API functions. any changes to the line below will be lost on re-generation
local callbacks_add, client_time_to_ticks, engine_is_connected, engine_is_in_game, entity_list_get_local_player, entity_list_get_players, global_vars_frame_time, global_vars_interval_per_tick, math_floor, menu_add_text, render_create_font, render_get_screen_size, render_text, render_world_to_screen, pairs, trace_line = callbacks.add, client.time_to_ticks, engine.is_connected, engine.is_in_game, entity_list.get_local_player, entity_list.get_players, global_vars.frame_time, global_vars.interval_per_tick, math.floor, menu.add_text, render.create_font, render.get_screen_size, render.text, render.world_to_screen, pairs, trace.line

local sv_gravity = cvars.sv_gravity
local sv_jump_impulse = cvars.sv_jump_impulse
local g_net_data = {}
local g_sim_ticks = {}
local g_esp_data = {}
local vector = {}

local w2s, line = render_world_to_screen, render.line
local text = menu_add_text("lagcomp debug", "lagcomp color")
local box_color = text:add_color_picker("color", color_t(47, 117, 221, 255))

local function copy_vec(v) return vec3_t(v.x, v.y, v.z) end
function length_sqr(x, y, z)
    return x * x + y * y + z * z
end

local extrapolate = function(ent, ticks)
    local tickinterval = global_vars_interval_per_tick()

    local sv_gravity = sv_gravity:get_float() * tickinterval
    local sv_jump_impulse = sv_jump_impulse:get_float() * tickinterval

    local p_origin, prev_origin = ent:get_render_origin(), ent:get_render_origin()

    local velocity = ent:get_prop("m_vecVelocity")
    local gravity = velocity.z > 0 and -sv_gravity or sv_jump_impulse

    for i=1, ticks do
        prev_origin = p_origin
        p_origin.x = p_origin.x + (velocity.x * tickinterval)
        p_origin.y = p_origin.y + (velocity.y * tickinterval)
        p_origin.z = p_origin.z + (velocity.z+gravity) * tickinterval

        local fraction = trace_line(prev_origin, p_origin, ent, 0x1).fraction

        if fraction <= 0.99 then
            return prev_origin
        end
    end

    return p_origin
end

callbacks_add(e_callbacks.NET_UPDATE, function()
    local local_player = entity_list_get_local_player()
    if not local_player then return end
    if not engine_is_in_game() or not engine_is_connected() then return end

    local players = entity_list_get_players(true)
    for _, player in pairs(players) do
        local idx = player:get_index()
        if player:is_dormant() or not player:is_alive() then
            g_net_data[idx] = nil
            g_sim_ticks[idx] = nil
            g_esp_data[idx] = nil
        else
            local prev_tick = g_sim_ticks[idx]
            local simulation_time = client_time_to_ticks(player:get_prop("m_flSimulationTime"))
            local origin = copy_vec(player:get_render_origin())

            if prev_tick ~= nil then
                local delta = simulation_time - prev_tick.tick

                if delta < 0 or delta > 0 and delta <= 64 then
                    local teleport_distance = length_sqr(prev_tick.origin.x - origin.x, prev_tick.origin.y - origin.y, prev_tick.origin.z - origin.z)
                    local extrapolated = extrapolate(player, delta - 1)

                    if delta < 0 then
                        g_esp_data[idx] = 1
                    end

                    g_net_data[idx] = {
                        tick = delta-1,

                        player = player,
                        delta = delta,
                        origin = origin,
                        extrapolated = extrapolated,

                        lagcomp = teleport_distance > 4096,
                        tickbase = delta < 3
                    }
                end
            end

            if g_esp_data[idx] == nil then
                g_esp_data[idx] = 0
            end

            g_sim_ticks[idx] = {
                tick = simulation_time,
                origin = origin
            }
        end
    end
end)

local edges = {
    {0, 1}, {1, 2}, {2, 3}, {3, 0}, {5, 6}, {6, 7}, {1, 4}, {4, 8},
    {0, 4}, {1, 5}, {2, 6}, {3, 7}, {5, 8}, {7, 8}, {3, 4}
}

callbacks_add(e_callbacks.PAINT, function()
    local local_player = entity_list_get_local_player()
    if not local_player then return end
    if not engine_is_in_game() or not engine_is_connected() then return end
    for idx, data in pairs(g_net_data) do
        if data ~= nil and data.player ~= nil and data.lagcomp and data.player:is_alive() then
            local min = data.player:get_prop("m_vecMins") + data.extrapolated
            local max = data.player:get_prop("m_vecMaxs") + data.extrapolated

            local points = {
                min, vec3_t(min.x, max.y, min.z),
                vec3_t(max.x, max.y, min.z), vec3_t(max.x, min.y, min.z),
                vec3_t(min.x, min.y, max.z), vec3_t(min.x, max.y, max.z),
                max, vec3_t(max.x, min.y, max.z)
            }

            for k, v in pairs(edges) do
                if k == 1 then
                    local origin = data.origin
                    local origin_w2s = w2s(origin)
                    local min_w2s = w2s(min)

                    if origin_w2s ~= nil and min_w2s ~= nil then
                        line(origin_w2s, min_w2s, color_t(box_color:get()[0], box_color:get()[1], box_color:get()[2], 255))
                    end
                end
                if points[v[1]] ~= nil and points[v[2]] ~= nil then
                    local p1 = w2s(points[v[1]])
                    local p2 = w2s(points[v[2]])

                    if p1 ~= nil and p2 ~= nil then
                        line(p1, p2, color_t(box_color:get()[0], box_color:get()[1], box_color:get()[2], 255))
                    end
                end
            end
        end
    end
end)
local verdana = render_create_font('Verdana', 12, 350, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)
callbacks_add(e_callbacks.PLAYER_ESP, function(ctx)
    local player_origin = render_world_to_screen(ctx.render_origin)
    if (not player_origin or player_origin.x < 0 or player_origin.x > render_get_screen_size().x or player_origin.y < 0 or player_origin.y > render_get_screen_size().y) then return end
    local text = {
        [0] = '', [1] = 'LAG COMP BREAKER',
        [2] = 'SHIFTING TICKBASE'
    }

    local x1, y1, x2, y2, a = ctx.bbox_start.x, ctx.bbox_start.y, ctx.bbox_size.x, ctx.bbox_size.y, ctx.alpha_modifier
    local palpha = 0

    if g_esp_data[ctx.player:get_index()] ~= nil and g_esp_data[ctx.player:get_index()] > 0 then
        g_esp_data[ctx.player:get_index()] = g_esp_data[ctx.player:get_index()] - global_vars_frame_time()*2
        g_esp_data[ctx.player:get_index()] = g_esp_data[ctx.player:get_index()] < 0 and 0 or g_esp_data[ctx.player:get_index()]

        palpha = g_esp_data[ctx.player:get_index()]
    end
    if g_net_data[ctx.player:get_index()] then
        local tb = g_net_data[ctx.player:get_index()].tickbase
        local lc = g_net_data[ctx.player:get_index()].lagcomp

        if not tb or g_net_data[ctx.player:get_index()].lagcomp then
            palpha = a
        end

        if ctx.bbox_start ~= nil and a > 0 then
            local name = ctx.player:get_name()
            
            local y_add = (name == '  ' or name == ' ' or name == '' or name == '   ') and 8 or 0
            render_text(verdana, text[tb and 2 or (lc and 1 or 0)], vec2_t(x1 + x2/2, y1 - 18 + y_add), color_t(255, 45, 45, math_floor(palpha*255)), true)
        end
    end
end)

callbacks_add(e_callbacks.EVENT, function(e)
    if e.name == "round_start" then
        g_net_data = {}
    end
end)