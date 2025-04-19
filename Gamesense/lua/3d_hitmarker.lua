local client_userid_to_entindex, entity_get_local_player, entity_hitbox_position, globals_curtime, globals_tickcount, math_sqrt, renderer_line, renderer_world_to_screen, pairs, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_set_callback, ui_set_visible = client.userid_to_entindex, entity.get_local_player, entity.hitbox_position, globals.curtime, globals.tickcount, math.sqrt, renderer.line, renderer.world_to_screen, pairs, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.set_callback, ui.set_visible

local success, surface = pcall(require, 'gamesense/surface')

if not success then
    error('\n\n - Surface library is required \n - https://gamesense.pub/forums/viewtopic.php?id=18793\n')
end

local shot_data = {}
local segoe = surface.create_font('Verdana', 20, 500, { 0x010 })
local hit_marker = ui_new_checkbox("VISUALS", "Player ESP", "Hit marker 3D")

local function paint()
    if not ui_get(hit_marker) then
        return
    end

    local size = 2.5
    local size2 = 2.5

    for tick, data in pairs(shot_data) do
        if data.draw then
            if globals_curtime() >= data.time then
                data.alpha = data.alpha - 2
            end

            if data.alpha <= 0 then
                data.alpha = 0
                data.draw = false
            end

            local sx, sy = renderer_world_to_screen(data.x, data.y, data.z)
            if sx ~= nil then
                local color = { 255, 255, 255 }

                if data.hs then
                    color = { 255, 0, 0 }
                end

                local damage_text = data.damage .. ''
                local w, h = surface.get_text_size(segoe, damage_text)

           
                renderer_line(sx + size, sy + size, sx + (size * size2), sy + (size * size2), 0, 0, 0, data.alpha)
                renderer_line(sx + size, sy + size, sx + (size * size2), sy + (size * size2), 255, 255, 255, math.max(0, data.alpha-35))

                renderer_line(sx - size, sy + size, sx - (size * size2), sy + (size * size2), 0, 0, 0, data.alpha)
                renderer_line(sx - size, sy + size, sx - (size * size2), sy + (size * size2), 255, 255, 255, math.max(0, data.alpha-35))

                renderer_line(sx + size, sy - size, sx + (size * size2), sy - (size * size2), 0, 0, 0, data.alpha)
                renderer_line(sx + size, sy - size, sx + (size * size2), sy - (size * size2), 255, 255, 255, math.max(0, data.alpha-35))

                renderer_line(sx - size, sy - size, sx - (size * size2), sy - (size * size2), 0, 0, 0, data.alpha)
                renderer_line(sx - size, sy - size, sx - (size * size2), sy - (size * size2), 255, 255, 255, math.max(0, data.alpha-35))
            end
        end
    end
end

local function player_hurt(e)
    if not ui_get(hit_marker) then
        return
    end

    local victim_entindex = client_userid_to_entindex(e.userid)
    local attacker_entindex = client_userid_to_entindex(e.attacker)

    if attacker_entindex ~= entity_get_local_player() then
        return
    end

    local tick = globals_tickcount()
    local data = shot_data[tick]

    if shot_data[tick] == nil or data.impacts == nil then
        return
    end

    local hitgroups = { 
        [1] = {0, 1}, 
        [2] = {4, 5, 6}, 
        [3] = {2, 3}, 
        [4] = {13, 15, 16}, 
        [5] = {14, 17, 18}, 
        [6] = {7, 9, 11}, 
        [7] = {8, 10, 12}
    }

    local impacts = data.impacts
    local hitboxes = hitgroups[e.hitgroup]
    
    local hit = nil
    local closest = math.huge

    for i=1, #impacts do
        local impact = impacts[i]

        if hitboxes ~= nil then
            for j=1, #hitboxes do
                local x, y, z = entity_hitbox_position(victim_entindex, hitboxes[j])
                local distance = math_sqrt((impact.x - x)^2 + (impact.y - y)^2 + (impact.z - z)^2)

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

    shot_data[tick] = {
        x = hit.x,
        y = hit.y,
        z = hit.z,
        time = globals_curtime() + 1 - 0.25,
        alpha = 255,
        damage = e.dmg_health,
        hs = e.hitgroup == 0 or e.hitgroup == 1,
        draw = true,
    }
end

local function bullet_impact(e)
    if not ui_get(hit_marker) then
        return
    end

    if client_userid_to_entindex(e.userid) ~= entity_get_local_player() then
        return
    end

    local tick = globals_tickcount()

    if shot_data[tick] == nil then
        shot_data[tick] = {
            impacts = { }
        }
    end

    local impacts = shot_data[tick].impacts

    if impacts == nil then
        impacts = { }
    end

    impacts[#impacts + 1] = {
        x = e.x,
        y = e.y,
        z = e.z
    }
end

local function round_start()
    if not ui_get(hit_marker) then
        return
    end

    shot_data = { }
end

client.set_event_callback("paint", paint)
client.set_event_callback("player_hurt", player_hurt)
client.set_event_callback("round_start", round_start)
client.set_event_callback("bullet_impact", bullet_impact)