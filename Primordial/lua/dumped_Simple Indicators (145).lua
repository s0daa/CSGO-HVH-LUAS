local screen_size = render.get_screen_size()
local verdana = render.create_font("verdana", 26, 800, e_font_flags.ANTIALIAS, e_font_flags.DROPSHADOW)

local ind = menu.add_checkbox("Indicators", "Enable")
local ind_col = ind:add_color_picker("Indicators Color", color_t(52, 143, 235))

local clamp = function(x, min, max)
	return x < min and min or x > max and max or x
end

local function indicators()
    local local_player = entity_list.get_local_player()
	if local_player == nil then return end
    if not ind:get() then return end

    local forcepred = menu.find("aimbot", "general", "exploits", "force prediction")
    local doubletap = menu.find("aimbot","general","exploits","doubletap","enable")
    local hideshots = menu.find("aimbot","general","exploits","hideshots","enable")
    local damage_override = menu.find("aimbot", "auto", "target overrides", "force min. damage")
    local hitbox_override = menu.find("aimbot", "auto", "target overrides", "force hitbox")

	local dt_col = ind_col:get()
	local hs_col = ind_col:get()
    local fp_col = ind_col:get()
    local fh_col = ind_col:get()
	local dmg_col = ind_col:get()
	local offset = 1
    local bruhfd = clamp(30.4 / exploits.get_charge(), 0, 3)

	if doubletap[2]:get() then
		if exploits.get_charge() > 0 then
			dt_col = ind_col:get()
		else
			dt_col = color_t(255, 0, 0)
		end

		render.text(verdana, "DT", vec2_t(12, screen_size[1]/2 + 64 + offset), dt_col)
		offset = offset + render.get_text_size(verdana, "DT")[1] - 1

        render.push_alpha_modifier(100)
        render.rect_filled(vec2_t(14, screen_size[1]/2 + 63 + offset), vec2_t(32, 5), color_t(0, 0, 0))
        render.pop_alpha_modifier()

        render.rect_filled(vec2_t(15, screen_size[1]/2 + 64 + offset), vec2_t(exploits.get_charge() * bruhfd, 3), dt_col)
	end

	if hideshots[2]:get() then
		render.text(verdana, "HS", vec2_t(12, screen_size[1]/2 + 64 + offset), hs_col)
		offset = offset + render.get_text_size(verdana, "HS")[1] - 4
	end

    if forcepred:get() then
        render.text(verdana, "FP", vec2_t(12, screen_size[1]/2 + 64 + offset), fp_col)
        offset = offset + render.get_text_size(verdana, "FP")[1] - 4
    end

    if hitbox_override[2]:get() then
        render.text(verdana, "FH", vec2_t(12, screen_size[1]/2 + 64 + offset), fh_col)
        offset = offset + render.get_text_size(verdana, "FH")[1] - 4
    end

	if damage_override[2]:get() then
		render.text(verdana, "DMG", vec2_t(12, screen_size[1]/2 + 64 + offset), dmg_col)
		offset = offset + render.get_text_size(verdana, "DMG")[1] - 4
	end
end

callbacks.add(e_callbacks.PAINT, function()
    local ind_enabled = ind:get()
    ind_col:set_visible(ind_enabled)

    indicators()
end)