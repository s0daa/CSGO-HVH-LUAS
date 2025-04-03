pen_dmg = ui.new_checkbox("MISC", "Miscellaneous", "Penetration damage")
pen_dmg_pos = ui.new_slider("MISC", "Miscellaneous", "Position", -20, 20, 0, true, "px", 1)

client.set_event_callback("paint", function()
	if not ui.get(pen_dmg) then return end

	if entity.get_local_player() == nil then
		return
	end

	local weap_classname = entity.get_classname(entity.get_player_weapon(entity.get_local_player()))

	if weap_classname == "CKnife" or weap_classname == "CSmokeGrenade" or weap_classname == "CFlashbang" or weap_classname == "CHEGrenade" or weap_classname == "CDecoyGrenade" or weap_classname == "CIncendiaryGrenade" then
		return
	end

	local screenX, screenY = client.screen_size()
	local xPos = screenX / 2 + 1
	local yPos = screenY / 2 + 20 - 15 * ui.get(pen_dmg_pos)

	
	local eyeX, eyeY, eyeZ = client.eye_position()
	local pitch, yaw = client.camera_angles()
	local ent_exists = false
	local wall_dmg = 0

	local sin_pitch = math.sin(math.rad(pitch))
	local cos_pitch = math.cos(math.rad(pitch))
	local sin_yaw = math.sin(math.rad(yaw))
	local cos_yaw = math.cos(math.rad(yaw))

	local dirVector = { cos_pitch * cos_yaw, cos_pitch * sin_yaw, -sin_pitch }
	

	local fraction, entindex = client.trace_line(entity.get_local_player(), eyeX, eyeY, eyeZ, eyeX + (dirVector[1] * 8192), eyeY + (dirVector[2] * 8192), eyeZ + (dirVector[3] * 8192))

	if fraction < 1 then
		local entindex_1, dmg = client.trace_bullet(entity.get_local_player(), eyeX, eyeY, eyeZ, eyeX + (dirVector[1] * (8192 * fraction + 128)), eyeY + (dirVector[2] * (8192 * fraction + 128)), eyeZ + (dirVector[3] * (8192 * fraction + 128)))

		if entindex_1 ~= nil then
			ent_exists = true
		end

		if wall_dmg < dmg then
			wall_dmg = dmg
		end
	end

	if wall_dmg > 0 then
		if ent_exists then
			renderer.text(xPos, yPos, 150, 200, 60, 255, "cb", 0, wall_dmg)
		else
			renderer.text(xPos, yPos, 150, 200, 60, 255, "cb", 0, wall_dmg)
		end
	end
end)