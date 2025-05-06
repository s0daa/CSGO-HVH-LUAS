local Ideal_tick_switch = gui.add_checkbox("Ideal tick on autopeek", "LUA>TAB a")
autopeek = gui.get_config_item("Misc>Movement>Peek Assist")
doubletap = gui.get_config_item("Rage>Aimbot>Aimbot>Double tap")
freestand = gui.get_config_item("Rage>Anti-Aim>Angles>Freestand")
local powrot = (0)
savedd = doubletap:get_bool()
savedf = doubletap:get_bool()
function on_paint()
	if Ideal_tick_switch:get_bool() then 
		if autopeek:get_int() == 1 and getsave == (1) then
			savedd = doubletap:get_bool()
			savedf = freestand:get_bool()
			getsave = (0)
			end
       if autopeek:get_int() == 1 then
			doubletap:set_int(1)
			freestand:set_int(1)
			powrot = (1)
	   end
	   if autopeek:get_int() == 0 and powrot == (1) then 
		doubletap:set_bool(savedd)
		freestand:set_bool(savedf)
		powrot = (0)
		getsave = (1)
		end
	end
end