local fog = {
    color = cvar.fog_color,
    start = cvar.fog_start,
    send = cvar.fog_end,
    maxdensity = cvar.fog_maxdensity
}

local dir = { 'VISUALS', 'Effects' }
local active = ui.new_checkbox(dir[1], dir[2], 'FOG Correction')
local color = ui.new_color_picker(dir[1], dir[2], 'FOG Correction color', 52, 57, 71, 0)
local start_distance = ui.new_slider(dir[1], dir[2], 'FOG Start Distance', 0, 2500, 500)
local distance = ui.new_slider(dir[1], dir[2], 'FOG Distance', 0, 2500, 1420)
local density = ui.new_slider(dir[1], dir[2], 'FOG Density', 0, 100, 70)

local g_paint = function()
    if not ui.get(active) then
        client.set_cvar('fog_override', 0)
        return
    end

    client.set_cvar('fog_override', 1)

    fog.start:set_int(ui.get(start_distance))
    fog.send:set_int(ui.get(distance))
    fog.maxdensity:set_float(ui.get(density)/100)
    fog.color:set_string(string.format('%s %s %s', ui.get(color)))
end

local g_callback = function()
    local enabled = ui.get(active)

    ui.set_visible(start_distance, enabled)
    ui.set_visible(distance, enabled)
    ui.set_visible(density, enabled)
end

client.set_event_callback('paint', g_paint)
ui.set_callback(active, g_callback)

g_callback()