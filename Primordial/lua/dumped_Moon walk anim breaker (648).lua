local multi_selection = menu.add_multi_selection("Breaker", "THIS ANIM BREAKER ONLY FOR LOCAL PLAYER (NO SERVER SIDE!)", {"Moon walk", "Moon walk static air", "Rofl"})

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	if multi_selection:get(1) then
		ctx:set_render_pose(e_poses.MOVE_YAW, 0)
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
	end
	if multi_selection:get(2) then
		ctx:set_render_pose(e_poses.MOVE_YAW, 0)
		ctx:set_render_pose(e_poses.JUMP_FALL, 1)
	end
	if multi_selection:get(3) then
		ctx:set_render_pose(e_poses.MOVE_YAW, 0)
		ctx:set_render_pose(e_poses.MOVE_BLEND_RUN, 1)		
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
	end	
end)