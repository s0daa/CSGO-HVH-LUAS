ffi.cdef[[
    typedef bool(__thiscall* console_is_visible)(void*);
]]
local engine_client = ffi.cast(ffi.typeof("void***"), memory.create_interface("engine.dll", "VEngineClient014"))
local console_is_visible = ffi.cast("console_is_visible", engine_client[0][11])

local enabled = menu.add_checkbox("console", "enable custom console color")
local recolor_console = enabled:add_color_picker("console colour")

local console_materials = { "vgui_white", "vgui/hud/800corner1", "vgui/hud/800corner2", "vgui/hud/800corner3", "vgui/hud/800corner4" }
local found_materials = {}

materials.for_each(function(mat)
    for material = 1, #console_materials do
        if ( string.match( mat:get_name( ), console_materials[material] )) then
            found_materials[material] = mat
        end
    end
end)

local function on_paint()
    if not engine.is_app_active() then 
        return 
    end

    local console_color = recolor_console:get()
    for material = 1, #found_materials do
        mat = found_materials[material]

        if enabled:get() and console_is_visible(engine_client) then
            mat:color_modulate(console_color.r/255, console_color.g/255, console_color.b/255)
            mat:alpha_modulate(console_color.a/255)
        else
            mat:color_modulate(1, 1, 1)
            mat:alpha_modulate(1)
        end
    end
end

callbacks.add(e_callbacks.PAINT, on_paint)