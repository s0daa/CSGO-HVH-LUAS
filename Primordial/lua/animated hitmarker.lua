local screen_size = render.get_screen_size()
local screen_x, screen_y = screen_size.x / 2, screen_size.y / 2

local hitmark_cb = menu.add_checkbox("yes", "animated hitmarker")
local colly = hitmark_cb:add_color_picker("yes")
local colly2 = hitmark_cb:add_color_picker("yes2")

local function on_screen_hitmarker(screen_pos, alpha_factor, is_lethal, is_headshot)
	local fadejuttu = math.floor(alpha_factor * 255)
	
	local anim = fadejuttu * 0.06
	local def_color 

	if hitmark_cb:get() then 

		if is_headshot then 
			def_color = colly:get()
		else
			def_color = colly2:get()
		end

			render.line(vec2_t(screen_x - 15, screen_y - 15), vec2_t(screen_x - 3 - anim, screen_y - 3 - anim ), def_color)
			render.line(vec2_t(screen_x + 15, screen_y - 15), vec2_t(screen_x + 3 + anim , screen_y - 3 - anim ), def_color)
			render.line(vec2_t(screen_x + 15, screen_y + 15), vec2_t(screen_x + 3 + anim, screen_y + 3 + anim), def_color)
			render.line(vec2_t(screen_x - 15, screen_y + 15), vec2_t(screen_x - 3 - anim , screen_y + 3 + anim ), def_color)

		return true
	end
end

callbacks.add(e_callbacks.SCREEN_HITMARKER, on_screen_hitmarker)