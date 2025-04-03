local fakeflick = menu.add_checkbox("lol", "Fake Flick");
local flickbind = fakeflick:add_keybind("fake flick");
local Inverter = menu.add_checkbox("lol", "Inverter");
local Inverterbind = Inverter:add_keybind("Inverter bind");
local yaw = menu.find("antiaim", "main", "angles", "yaw add")

local function on_antiaim(ctx)	

local TickcountModulo = global_vars.tick_count() % 17

if fakeflick:get() then
	Inverter:set_visible(true)
	local Flick = TickcountModulo == 10
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