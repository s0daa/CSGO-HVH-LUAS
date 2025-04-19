local ffi = require 'ffi'
local find_material = materialsystem.find_material

local engine_client = ffi.cast(ffi.typeof('void***'), client.create_interface('engine.dll', 'VEngineClient014'))
local console_is_visible = ffi.cast(ffi.typeof('bool(__thiscall*)(void*)'), engine_client[0][11])

ui.new_label('misc', 'settings', 'VGUI Color')

local recolor_console = ui.new_color_picker('misc', 'settings', 'VGUI Color picker', 81, 81, 81, 210)
local materials = { 'vgui_white', 'vgui/hud/800corner1', 'vgui/hud/800corner2', 'vgui/hud/800corner3', 'vgui/hud/800corner4' }

client.set_event_callback('paint', function()
    local r, g, b, a = ui.get(recolor_console)

    if not console_is_visible(engine_client) then
        r, g, b, a = 255, 255, 255, 255
    end

    for _, mat in pairs(materials) do
        find_material(mat):alpha_modulate(a)
        find_material(mat):color_modulate(r, g, b)
    end
end)
