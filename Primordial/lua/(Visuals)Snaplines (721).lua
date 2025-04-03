local tp = menu.find("visuals", "view", "thirdperson", "enable")[2]
local snaptoggle = menu.add_checkbox("ESP", "Snaplines")
local snapdist = menu.add_slider("ESP", "Danger Distance", 50, 1000, 1, 0, "u")
local snapfp = menu.add_selection("ESP", "Firstperson Origin", {"Crosshair", "Bottom of Screen"})
local snaptp = menu.add_selection("ESP", "Thirdperson Origin", {"Localplayer", "Bottom of Screen"})
local dangercolor = snaptoggle:add_color_picker("Danger Color", true)
local snapcolor = snaptoggle:add_color_picker("Snaplines Color", true)




local function are_them_visibles(ent)
    local local_p = entity_list:get_local_player()
    local generic_pos = ent:get_hitbox_pos(e_hitgroups.GENERIC)
    local left_arm_pos = ent:get_hitbox_pos(e_hitgroups.LEFT_ARM)
    local right_arm_pos = ent:get_hitbox_pos(e_hitgroups.RIGHT_ARM)
    if local_p:is_point_visible(generic_pos) or local_p:is_point_visible(left_arm_pos) or local_p:is_point_visible(right_arm_pos) then return true else return false end
end

local function snap(ctx)
	local lplr = entity_list.get_local_player()
	local enemies = entity_list.get_players(true)
	local wep = lplr:get_active_weapon()
	if not snaptoggle:get() then return end
		local v = ctx.player
        if v == nil then return end
		if ctx.dormant then return end
        if not v:is_alive() then return end
        if not v:is_enemy() then return end
		pos = v:get_hitbox_pos(e_hitboxes.PELVIS)
		lpos = lplr:get_hitbox_pos(e_hitboxes.PELVIS)
		local enemypos = render.world_to_screen(pos)
		local localpos = render.world_to_screen(lpos)
		local x = render.get_screen_size().x
		local y = render.get_screen_size().y
		if lpos == nil or pos == nil then return end
		if tp:get() then
			if snaptp:get() == 1 then
				if are_them_visibles(v) or pos:dist(lpos) <= snapdist:get() then
					render.line(enemypos, localpos, dangercolor:get())
				else
					render.line(enemypos, localpos, snapcolor:get())
				end
			else
				if are_them_visibles(v) or pos:dist(lpos) <= snapdist:get() then
					render.line(enemypos, vec2_t(x/2, y), dangercolor:get())
				else
					render.line(enemypos, vec2_t(x/2, y), snapcolor:get())
				end
			end
		else
			if snapfp:get() == 1 then
				if are_them_visibles(v) or pos:dist(lpos) <= snapdist:get() then
					render.line(enemypos, vec2_t(x/2, y/2), dangercolor:get())
				else
					render.line(enemypos, vec2_t(x/2, y/2), snapcolor:get())
				end
			else
				if are_them_visibles(v) or pos:dist(lpos) <= snapdist:get() then
					render.line(enemypos, vec2_t(x/2, y), dangercolor:get())
				else
					render.line(enemypos, vec2_t(x/2, y), snapcolor:get())
				end
			end
		end
end

dangercolor:set(color_t(255, 255, 255))

callbacks.add(e_callbacks.PLAYER_ESP, snap)