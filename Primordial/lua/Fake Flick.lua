local fakeflick = menu.add_checkbox("Fake Flick", "Fake Flick");
local flickbind = fakeflick:add_keybind("fake flick");
local slider = menu.add_slider("Fake Flick", "Flick Speed", 0, 16)
local Inverter = menu.add_checkbox("Fake Flick", "Inverter");
local Inverterbind = Inverter:add_keybind("Inverter bind");
local indis = menu.add_checkbox("Indicators", "Indicators");
local colorpicker = indis:add_color_picker("Indicators");
local yaw = menu.find("antiaim", "main", "angles", "yaw add")
local font = render.create_font("Smallest-Pixel-7", 8, 100, e_font_flags.OUTLINE)





local function on_paint()
    if fakeflick:get() then
        local indis = indis:get()
        if (flickbind:get()) then
            if indis then
                render.text(font, ">>>", vec2_t(2, 589), colorpicker:get())
                render.text(font, "<<<", vec2_t(53, 589), colorpicker:get())
                render.text(font, "FAKEFLICK", vec2_t(13, 590), color_t(255, 255, 255, 255))
                render.text(font, ">>>", vec2_t(2, 599), colorpicker:get())
                render.text(font, "INVERTED:", vec2_t(13, 600), color_t(255, 255, 255, 255))
                if Inverterbind:get() then
                    render.text(font, "YES", vec2_t(50, 600), colorpicker:get())
                else 
                    render.text(font, "NO", vec2_t(50, 600), colorpicker:get())
                end
        end
    end
end
end

callbacks.add(e_callbacks.PAINT, on_paint)



local function on_antiaim(ctx)	

local speed = slider:get()   
local TickcountModulo = global_vars.tick_count() % 17

if fakeflick:get() then
	Inverter:set_visible(true)
	local Flick = TickcountModulo == speed
	if (flickbind:get()) then
		if Flick then
			if Inverterbind:get() then
				yaw:set(-90)
			else
				
				yaw:set(90)
			end
		else
			yaw:set(0)
		end
	end
else
	Inverter:set_visible(false)
end
end

callbacks.add(e_callbacks.ANTIAIM, on_antiaim)