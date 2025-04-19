--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_hitbox_position, globals_curtime, globals_tickcount, math_sqrt, renderer_line, renderer_world_to_screen, pairs, ui_get, ui_new_checkbox, ui_new_color_picker, ui_new_slider, ui_set_callback, ui_set_visible = client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.hitbox_position, globals.curtime, globals.tickcount, math.sqrt, renderer.line, renderer.world_to_screen, pairs, ui.get, ui.new_checkbox, ui.new_color_picker, ui.new_slider, ui.set_callback, ui.set_visible
 
--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local hitgroups = {
    [1] = {0, 1},
    [2] = {4, 5, 6},
    [3] = {2, 3},
    [4] = {13, 15, 16},
    [5] = {14, 17, 18},
    [6] = {7, 9, 11},
    [7] = {8, 10, 12}
}
 
local shot_data = {}
 
--------------------------------------------------------------------------------
-- Menu handling
--------------------------------------------------------------------------------
local hit_marker        = ui_new_checkbox("LUA", "A", "Hit marker 3D")
local hit_marker_size   = ui_new_slider("LUA", "A", "\n", 1, 10, 3, true, "px")
local hit_marker_color  = ui_new_color_picker("LUA", "A", "Hit marker color", 255, 255, 255, 255)
 
local function handle_menu()
    local state = ui_get(hit_marker)
    ui_set_visible(hit_marker_size, state)
end
 
handle_menu()
ui_set_callback(hit_marker, handle_menu)
 
--------------------------------------------------------------------------------
-- Game event handling
--------------------------------------------------------------------------------
local function paint()
    if not ui_get(hit_marker) then
        return
    end
    local size      = ui_get(hit_marker_size)
    local r, g, b   = ui_get(hit_marker_color)
    for tick, data in pairs(shot_data) do
        if data.draw then
            if globals_curtime() >= data.time then
                data.alpha = data.alpha - 1
            end
            if data.alpha <= 0 then
                data.draw = false
            end
            local sx, sy = renderer_world_to_screen(data.x, data.y, data.z)
            if sx ~= nil then
                renderer_line(sx + size, sy + size, sx + (size * 2), sy + (size * 2), r, g, b, data.alpha)
                renderer_line(sx - size, sy + size, sx - (size * 2), sy + (size * 2), r, g, b, data.alpha)
                renderer_line(sx + size, sy - size, sx + (size * 2), sy - (size * 2), r, g, b, data.alpha)
                renderer_line(sx - size, sy - size, sx - (size * 2), sy - (size * 2), r, g, b, data.alpha)
            end
        end
    end
end
 
local function player_hurt(e)
    if not ui_get(hit_marker) then
        return
    end
    local victim_entindex   = client_userid_to_entindex(e.userid)
    local attacker_entindex = client_userid_to_entindex(e.attacker)
    if attacker_entindex ~= entity_get_local_player() then
        return
    end
    local tick  = globals_tickcount()
    local data  = shot_data[tick]
    if shot_data[tick] == nil then
        return
    end
    local impacts   = data.impacts
    local hitboxes  = hitgroups[e.hitgroup]
    local hit       = nil
    local closest   = math.huge
    for i=1, #impacts do
        local impact = impacts[i]
        for j=1, #hitboxes do
            local x, y, z   = entity_hitbox_position(victim_entindex, hitboxes[j])
            local distance  = math_sqrt((impact.x - x) ^ 2 + (impact.y - y) ^ 2 + (impact.z - z) ^ 2)
            if distance < closest then
                hit     = impact
                closest = distance
            end
        end
    end
    shot_data[tick] = {
        x       = hit.x,
        y       = hit.y,
        z       = hit.z,
        time    = globals_curtime() + 2,
        alpha   = 255,
        draw    = true,
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
            impacts = {}
        }
    end
    local impacts = shot_data[tick].impacts
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
    shot_data = {}
end
 
client_set_event_callback("paint", paint)
client_set_event_callback("player_hurt", player_hurt)
client_set_event_callback("round_start", round_start)
client_set_event_callback("bullet_impact", bullet_impact)