local bebraui = menu.add_selection("skeet anim", "lean (like 2018 animfix)", {"Small", "Medium", "High", "Extreme"})
callbacks.add(e_callbacks.ANTIAIM, function(ctx)
    local lp = entity_list.get_local_player()
    if not lp or not lp:is_alive() then
        return
    end
	local bebracheck = lp:get_prop("m_vecVelocity[1]") ~= 0	
	if bebraui:get(1) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.35)
	end
	if bebraui:get(2) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.5)
	end
	if bebraui:get(3) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 0.75)
	end
	if bebraui:get(4) and bebracheck then
        ctx:set_render_animlayer(e_animlayers.LEAN, 1)
	end
end)