local fake = gui.get_config_item('rage>anti-aim>desync>fake')
local fakelag = gui.get_config_item('rage>anti-aim>fakelag>mode')
local dt = gui.get_config_item('rage>aimbot>aimbot>double tap')
local hs = gui.get_config_item('rage>aimbot>aimbot>hide shot')

local save_fake = fake:get_int()
local save_fakelag = fakelag:get_int()

function on_create_move(cmd)
	if dt:get_int() == 1 then
	    fakelag:set_int(0)
	    fake:set_int(0)
	elseif hs:get_int() == 1 then
	    fakelag:set_int(0)
	    fake:set_int(0)
	else
	    fakelag:set_int(save_fakelag)
	    fake:set_int(save_fake)
	end
end

-- xDDDDDDDDDDDDDDD