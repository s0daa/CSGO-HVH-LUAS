local components = {}
local paint = {}

components.enable = menu.add_checkbox("ROLL", "Indicate Roll")
components.roll_ref = menu.find("aimbot", "general", "aimbot", "body lean resolver")
components.screensize = render.get_screen_size()

paint.handle = function ()
    if not components.enable:get() or not components.roll_ref[2]:get() then return end

    render.text(render.get_default_font(), "ROLL RESOLVER", vec2_t(components.screensize.x / 2, components.screensize.y / 2 + 15), color_t(255, 255, 255, 255))
    
end

callbacks.add(e_callbacks.PAINT, paint.handle)