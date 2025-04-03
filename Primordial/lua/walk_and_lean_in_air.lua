callbacks.add(e_callbacks.ANTIAIM, function(ctx)
	local lp = entity_list.get_local_player()
	local in_air = lp:get_prop("m_vecVelocity[2]") ~= 0	
	if in_air then
		ctx:set_render_animlayer(e_animlayers.MOVEMENT_MOVE, 1)
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
	end
end)