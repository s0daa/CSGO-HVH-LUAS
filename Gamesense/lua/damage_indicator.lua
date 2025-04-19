--------------------------------------------------------------------------------
-- Caching common functions
--------------------------------------------------------------------------------
local client_set_event_callback, client_userid_to_entindex, entity_get_local_player, entity_get_prop, renderer_text, renderer_world_to_screen, ui_get, ui_new_checkbox, ui_new_color_picker = client.set_event_callback, client.userid_to_entindex, entity.get_local_player, entity.get_prop, renderer.text, renderer.world_to_screen, ui.get, ui.new_checkbox, ui.new_color_picker

--------------------------------------------------------------------------------
-- Menu
--------------------------------------------------------------------------------
local damage_indicator  = ui_new_checkbox("LUA", "A", "Damage indicator")
local damage_color      = ui_new_color_picker("LUA", "A", "Damage color", 255, 255, 255, 255)

--------------------------------------------------------------------------------
-- Constants and variables
--------------------------------------------------------------------------------
local shot_data = {}

--------------------------------------------------------------------------------
-- Game event handling
--------------------------------------------------------------------------------
local function paint()
    if not ui_get(damage_indicator) then
        return
    end
    local r, g, b = ui_get(damage_color)
    for i=1, #shot_data do
        local shot = shot_data[i]
        if shot.draw then
            if shot.z >= shot.target then
                shot.alpha = shot.alpha - 1
            end
            if shot.alpha <= 0 then
                shot.draw = false
            end
            local sx, sy = renderer_world_to_screen(shot.x, shot.y, shot.z)
            if sx ~= nil then
                renderer_text(sx, sy, r, g, b, shot.alpha, "cb", 0, shot.damage)
            end
            shot.z = shot.z + 0.25
        end
    end
end

local function player_hurt(e)
    if not ui_get(damage_indicator) then
        return
    end
    local attacker_entindex = client_userid_to_entindex(e.attacker)
    local victim_entindex   = client_userid_to_entindex(e.userid)
    if attacker_entindex ~= entity_get_local_player() then
        return
    end
    local x, y, z       = entity_get_prop(victim_entindex, "m_vecOrigin")
    local duck_amount   = entity_get_prop(victim_entindex, "m_flDuckAmount")
    z = z + (46 + (1 - duck_amount) * 18)
    shot_data[#shot_data + 1] = {
        x       = x,
        y       = y,
        z       = z,
        target  = z + 25,
        damage  = e.dmg_health,
        alpha   = 255,
        draw    = true
    }
end

local function round_start()
    if not ui_get(damage_indicator) then
        return
    end
    shot_data = {}
end

client_set_event_callback("paint", paint)
client_set_event_callback("player_hurt", player_hurt)
client_set_event_callback("round_start", round_start)