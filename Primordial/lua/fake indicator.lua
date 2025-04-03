-- same font as supremacys
local main_font = render.create_font("Verdana", 26, 700, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

function is_alive()
	local local_player = entity_list.get_local_player()
	if not local_player then
		return false
	end
	return local_player:get_prop("m_lifeState") == 0
end

callbacks.add(e_callbacks.PAINT, function()
	if not is_alive() or (not engine.is_connected()) then
		return
	end
	local color
	local range = antiaim.get_max_desync_range()
	-- max desync range is heavily decreased after running / walking etc, i found 53 was best, ..
	if range < 53 then
		color = color_t(255, 0, 0)
	else
		color = color_t(0, 255, 0)
	end

	-- math is literally stolen from supremacy LOL
	render.text(main_font, "FAKE", vec2_t(20, 1080 - 80 - 30), color)
end)