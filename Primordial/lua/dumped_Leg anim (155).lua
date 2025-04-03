local multi_selection = menu.add_multi_selection("Leg Anim", "selection", {"Reverse Slide", "Static when slow walk"})
local find_slow_walk_name, find_slow_walk_key = unpack(menu.find("misc","main","movement","slow walk"))

callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	if multi_selection:get(1) then
		ctx:set_render_pose(e_poses.RUN, 0)
	end

	if find_slow_walk_key:get() and multi_selection:get(2) then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 0.0, 0.0)
	end
end)