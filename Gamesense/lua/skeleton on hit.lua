local ui_get = ui.get

local localplayer, uid_to_entindex, hitbox_pos, is_enemy = entity.get_local_player, client.userid_to_entindex, entity.hitbox_position, entity.is_enemy

local draw_line, w2s = renderer.line, renderer.world_to_screen

local curtime = globals.curtime

local menu = {
    skelly = ui.new_checkbox("VISUALS", "Player Esp", "Draw skeleton on hit"),
    skelly_c = ui.new_color_picker("VISUALS", "Player Esp", "Draw skeleton on hit", 255, 255, 255, 255),
    hitfade = ui.new_slider("VISUALS", "Player Esp", "Fade time", 2, 10, 4, true, "s", 1),
}

local skellyparts = {  -- im makin it out of hitboxes stfuuu
	main = {0, 1, 6, 5, 4, 3, 2},
	left_arm = {14, 18, 17, 1},
	right_arm = {13, 16, 15, 1},
	left_leg = {12, 10, 8, 2},
	right_leg = {11, 9, 7, 2}
} 

local loggedskellys = {}

client.set_event_callback("player_hurt", function(event)
	local localplyr = localplayer()
	if ui_get(menu.skelly) and uid_to_entindex(event.attacker) == localplyr and is_enemy(uid_to_entindex(event.userid)) then
		if uid_to_entindex(event.userid) == localplyr then return end
			
		local skellypos = {}
		for i = 0, 18 do
			local x, y, z = hitbox_pos(uid_to_entindex(event.userid), i)

			skellypos[i] = {x = x, y = y, z = z}
		end

		table.insert(loggedskellys, {tick = curtime(), bones = skellypos})
	end
end)

client.set_event_callback("paint", function()
	if not ui_get(menu.skelly) then return end

	local r, g, b, a = ui_get(menu.skelly_c)

	for skellyindex, skelly in pairs(loggedskellys) do

		local alpha = a
		if skelly.tick + ui_get(menu.hitfade) - 1 <= curtime() then
			alpha = alpha * (1 - (curtime() - (skelly.tick + ui_get(menu.hitfade) - 1)))
		end

		if skelly.tick + ui_get(menu.hitfade) <= curtime() then
			table.remove(loggedskellys, skellyindex)
		else
			for group_name, group in pairs(skellyparts) do
				for index, part in pairs(group) do
					if index ~= #group then
						local x, y, z = skelly.bones[group[index]].x, skelly.bones[group[index]].y, skelly.bones[group[index]].z -- did this really bad cuz im lazy
						local parent_x, parent_y = w2s(x, y, z)

						local x1, y1, z1 = skelly.bones[group[index + 1]].x, skelly.bones[group[index + 1]].y, skelly.bones[group[index + 1]].z
						local child_X, child_y = w2s(x1, y1, z1)

						draw_line(parent_x, parent_y, child_X, child_y, r, g, b, alpha)
					end
				end
			end
		end
	end
end)