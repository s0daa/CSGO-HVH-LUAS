local main_font = render.create_font("Arial", 18, 600, e_font_flags.ANTIALIAS)

callbacks.add(e_callbacks.WORLD_HITMARKER, function(screen_pos, world_pos, alpha_factor, damage, is_lethal, is_headshot)
	options = {
		size = 6,
		escp = 3
	}

	render.push_alpha_modifier(alpha_factor)

	color = is_lethal and color_t(255, 0, 0) or color_t(255, 255, 255)

	render.line(vec2_t(screen_pos.x - options.escp - options.size, screen_pos.y - options.escp - options.size), vec2_t(screen_pos.x - options.escp, screen_pos.y - options.escp), color_t(255, 255, 255))
	render.line(vec2_t(screen_pos.x + options.escp, screen_pos.y + options.escp), vec2_t(screen_pos.x + options.escp + options.size, screen_pos.y + options.escp + options.size), color_t(255, 255, 255))
	render.line(vec2_t(screen_pos.x + options.escp, screen_pos.y - options.escp), vec2_t(screen_pos.x + options.escp + options.size, screen_pos.y - options.escp - options.size), color_t(255, 255, 255))
	render.line(vec2_t(screen_pos.x - options.escp, screen_pos.y + options.escp), vec2_t(screen_pos.x - options.escp - options.size, screen_pos.y + options.escp + options.size), color_t(255, 255, 255))

	render.text(main_font, tostring(damage), vec2_t(screen_pos.x, screen_pos.y - options.size * options.escp - 2), color, true)

	render.pop_alpha_modifier()
	return true
end)

callbacks.add(e_callbacks.SCREEN_HITMARKER, function(screen_pos, alpha_factor, is_lethal, is_headshot)
	options = {
		size = alpha_factor * 5,
		escp = 6
	}

	render.push_alpha_modifier(alpha_factor)

	color = is_lethal and color_t(255, 0, 0) or color_t(255, 255, 255)

    render.line(vec2_t(screen_pos.x - options.escp - options.size, screen_pos.y - options.escp - options.size), vec2_t(screen_pos.x - options.escp, screen_pos.y - options.escp), color)
	render.line(vec2_t(screen_pos.x + options.escp, screen_pos.y + options.escp), vec2_t(screen_pos.x + options.escp + options.size, screen_pos.y + options.escp + options.size), color)
	render.line(vec2_t(screen_pos.x + options.escp, screen_pos.y - options.escp), vec2_t(screen_pos.x + options.escp + options.size, screen_pos.y - options.escp - options.size), color)
	render.line(vec2_t(screen_pos.x - options.escp, screen_pos.y + options.escp), vec2_t(screen_pos.x - options.escp - options.size, screen_pos.y + options.escp + options.size), color)

    render.pop_alpha_modifier()
    return true
end)