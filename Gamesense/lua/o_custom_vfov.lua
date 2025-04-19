local override_fov, override_zoom_fov = 
    ui.reference('MISC', 'Miscellaneous', 'Override FOV'), 
    ui.reference('MISC', 'Miscellaneous', 'Override zoom FOV')

local ui_fov = ui.new_slider('CONFIG', 'Presets', 'Override FOV', 1, 135, ui.get(override_fov), true, '°')
local ui_zoom_fov = ui.new_slider('CONFIG', 'Presets', 'Override zoom FOV', 0, 100, ui.get(override_zoom_fov), true, '%')

local zoom_lvl_old = 0
local materials = {
    "dev/scope_bluroverlay",
    "dev/blurfilterx_nohdr",
    "dev/blurfiltery_nohdr",
    "dev/clearalpha"
}

local set_blur_state = function(no_draw)
    no_draw = no_draw or false

    for i=1, #materials do
        local material = materialsystem.find_material(materials[i])
    
        if material ~= nil then
            material:set_material_var_flag(2, no_draw)
        end
    end
end

local function g_handler(c)
    local me = entity.get_local_player()
    local wpn = entity.get_player_weapon(me)

    local view_fov, view_zoom_fov = 
        ui.get(ui_fov),
        ui.get(ui_zoom_fov)

    local m_bScoped = entity.get_prop(me, 'm_bIsScoped') == 1
    local m_zoomLevel = entity.get_prop(wpn, 'm_zoomLevel') or 0

    m_zoomLevel = m_bScoped and m_zoomLevel or 0

    local zoom_lvl = ({
        [0] = view_fov,
        [1] = view_fov-50,
        [2] = view_fov-75
    })[m_zoomLevel]

    if m_zoomLevel > 0 then
        local zoom_delta = view_fov-zoom_lvl
        local fov_sub = zoom_delta/100*view_zoom_fov

        zoom_lvl = view_fov - fov_sub
    end

    if m_zoomLevel ~= zoom_lvl_old then
        set_blur_state(m_zoomLevel > 0)
        zoom_lvl_old = m_zoomLevel
    end

    ui.set(override_fov, 90)
    ui.set(override_zoom_fov, 100)

    c.fov = zoom_lvl
end

local function g_shutdown()
    ui.set(override_fov, ui.get(ui_fov))
    ui.set(override_zoom_fov, ui.get(ui_zoom_fov))

    ui.set_visible(override_fov, true)
    ui.set_visible(override_zoom_fov, true)

    set_blur_state()
end

client.set_event_callback('override_view', g_handler)
client.set_event_callback('shutdown', g_shutdown)

ui.set_visible(override_fov, false)
ui.set_visible(override_zoom_fov, false)