--by ivg

local menugroup = menu.set_group_column("Menu", 1) 
local tptoggle = menu.add_checkbox("Menu", "Thirdperson Fix", false)
local tpslider = menu.add_slider("Menu", "Thirdperson Distance", 20, 200, 1, 0)
local coltoggle = menu.add_checkbox("Menu", "Thirdperson Collision", false)

local keybind = tptoggle:add_keybind("Thirdperson Fix")
cvars.sv_cheats:set_int(1)


function tphandle()
    if keybind:get() then
        cvars.cam_command:set_int(1)
    else 
        cvars.cam_command:set_int(0)
    end

    if coltoggle:get() then
        cvars.cam_collision:set_int(1)
    else 
        cvars.cam_collision:set_int(0)
    end

    --player_resource.set_prop("m_hObserverTarget", 1)

    local distance = tpslider:get()

    cvars.c_mindistance:set_int(distance)
    cvars.c_maxdistance:set_int(distance)
end


local function resettp(event)
    cvars.sv_cheats:set_int(1)
    print("thirdperson updated")
end

callbacks.add(e_callbacks.EVENT, resettp, "round_start")

callbacks.add(e_callbacks.PAINT, function()
    tphandle()
end)