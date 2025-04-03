--by ivg

local menugroup = menu.set_group_column("Menu", 1) 
local offsetgroup = menu.set_group_column("Offsets", 1) 
local tptoggle = menu.add_text("Menu", "Thirdperson Fix", false)
local tpslider = menu.add_slider("Menu", "Thirdperson Distance", 20, 200, 1, 0)
local coltoggle = menu.add_checkbox("Menu", "Disable Thirdperson Collision", false)
local offsettoggle = menu.add_checkbox("Menu", "Enable Offsets", false)
local shoulderslider = menu.add_slider("Offsets", "Shoulder Offset", -20, 20, 1, 0)
local heightslider = menu.add_slider("Offsets", "Height Offset", -20, 20, 1, 0)

local realdist = 0

local keybind = tptoggle:add_keybind("Thirdperson Fix")
cvars.sv_cheats:set_int(1)


function tphandle()
	if not engine.is_connected() or not engine.is_in_game() then return end
	local entity = entity_list.get_local_player()
	if entity == nil then return end

    if keybind:get() and entity:is_alive() then
        cvars.cam_command:set_int(1)
    else
        cvars.cam_command:set_int(0)
    end

    if coltoggle:get() and entity:is_alive() then
        cvars.cam_collision:set_int(0)
    else 
        cvars.cam_collision:set_int(1)
    end

    local distance = tpslider:get()

    cvars.c_mindistance:set_int(distance)
    cvars.c_maxdistance:set_int(distance)

    if offsettoggle:get() then
        local height = heightslider:get()
        local offset = shoulderslider:get()
        cvars.c_thirdpersonshoulder:set_int(1)
        cvars.c_thirdpersonshoulderoffset:set_int(offset)
        cvars.c_thirdpersonshoulderheight:set_int(height)
    else
        cvars.c_thirdpersonshoulder:set_int(0)
        cvars.c_thirdpersonshoulderoffset:set_int(0)
        cvars.c_thirdpersonshoulderheight:set_int(0)
    end

end


function menuhandle()
    menu.set_group_visibility("Offsets", offsettoggle:get())
end



local function resettp(event)
    cvars.sv_cheats:set_int(1)
    print("thirdperson patched")
end

callbacks.add(e_callbacks.EVENT, resettp, "round_start")

callbacks.add(e_callbacks.PAINT, function()
    tphandle()
    menuhandle()
end)