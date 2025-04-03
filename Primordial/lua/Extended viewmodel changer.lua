--#UI
local mainswitch = menu.add_checkbox("Viewmodel changer", "Enable", false)
local FOV = menu.add_slider("Viewmodel changer", "FOV", 0, 180)
local offset_x = menu.add_slider("Viewmodel changer", "X offset", -180, 180)
local offset_y = menu.add_slider("Viewmodel changer", "Y offset", -180, 180)
local offset_z = menu.add_slider("Viewmodel changer", "Z offset", -180, 180)
local roll = menu.add_slider("Viewmodel changer", "Roll", -180, 180)

--#OLDCFG
local old_fov_add = menu.find("visuals", "other", "general", "viewmodel fov add")
local old_x_add = menu.find("visuals", "other", "general", "viewmodel offsets", "x add")
local old_y_add = menu.find("visuals", "other", "general", "viewmodel offsets", "y add")
local old_z_add = menu.find("visuals", "other", "general", "viewmodel offsets", "z add")
local old_roll_add = menu.find("visuals", "other", "general", "viewmodel offsets", "roll add")

local function viewmodel()
	if mainswitch:get() then
		cvars.sv_competitive_minspec:set_int(0)
		cvars.viewmodel_fov:set_int(FOV:get())
		cvars.viewmodel_offset_x:set_int(offset_x:get())
		cvars.viewmodel_offset_y:set_int(offset_y:get())
		cvars.viewmodel_offset_z:set_int(offset_z:get())
		old_roll_add:set(roll:get())
	end
end

local function destroy()
	
end

callbacks.add(e_callbacks.PAINT, viewmodel)