local zoom_level = 0
local materials = {
    "overlays/scope_lens",
    "dev/scope_bluroverlay",
    "dev/blurfilterx_nohdr",
    "dev/blurfiltery_nohdr",
    "dev/clearalpha",
}

local find_material = materialsystem.find_material
local entity_get_local_player = entity.get_local_player
local entity_get_player_weapon = entity.get_player_weapon
local entity_get_prop = entity.get_prop
local entity_is_alive = entity.is_alive

local set_blur_state = function(no_draw)
    no_draw = no_draw or false

    for i=1, #materials do
        local material = find_material(materials[i])
    
        if material ~= nil then
            material:set_material_var_flag(2, no_draw)
        end
    end
end

local function g_handler()
    local me = entity_get_local_player()
    local wpn = entity_get_player_weapon(me)

    local entity_checks = entity.is_alive(me) and wpn

    local m_bScoped = entity_checks and entity_get_prop(me, 'm_bIsScoped') == 1
    local m_zoomLevel = entity_get_prop(wpn, 'm_zoomLevel') or 0

    m_zoomLevel = m_bScoped and m_zoomLevel or 0

    if m_zoomLevel ~= zoom_level then
        set_blur_state(m_zoomLevel > 0)
        zoom_level = m_zoomLevel
    end
end

client.set_event_callback('paint', g_handler)
client.set_event_callback('shutdown', set_blur_state)
