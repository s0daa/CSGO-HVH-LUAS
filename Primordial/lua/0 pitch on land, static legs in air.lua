local ground_tick = 1
local end_time = 0

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	local lp = entity_list.get_local_player()
	local on_land = bit.band(lp:get_prop("m_fFlags"), bit.lshift(1,0)) ~= 0
	local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
	local curtime = global_vars.cur_time() 

	if in_air then
		ctx:set_render_pose(e_poses.JUMP_FALL, 1)
	end
	
end)