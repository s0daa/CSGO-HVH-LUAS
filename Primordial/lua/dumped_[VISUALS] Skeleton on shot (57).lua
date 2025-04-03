--#ui
local pig = menu.add_checkbox("Skeleton on hit", "Enable")
local cow = pig:add_color_picker("Color")

--#var
local tShots = {}

--#ATTENTION
local tData = {
	{ 0, 1 },
	{ 1, 6 },
	{ 6, 5 },
	{ 5, 4 },
	{ 4, 3 },
	{ 3, 2 },
	{ 2, 8 },
	{ 2, 7 },
	{ 8, 10 },
	{ 10, 12 },
	{ 7, 9 },
	{ 9, 11 },
	{ 1, 17 },
	{ 1, 15 },
	{ 17, 18 },
	{ 18, 14 },
	{ 15, 16 },
	{ 16, 13 },
}

--#main
callbacks.add(e_callbacks.AIMBOT_SHOOT, function(s)
	if pig:get() then
		local tPos = {}
		
		for i=0, 18 do
			tPos[i] = s.player:get_hitbox_pos(i)
		end

		tShots[s.id] = { tPos = tPos, iTime = global_vars.real_time() + 1, iAlpha = 255 }
	end
end)

callbacks.add(e_callbacks.PAINT, function()
	if pig:get() then
		for _, v in pairs(tShots) do
			if v.iAlpha <= 0 and global_vars.real_time() > v.iTime then
				tShots[_] = nil
			end
			
			v.iAlpha = global_vars.real_time() < v.iTime and math.min(v.iAlpha + 5, 255) or math.max(v.iAlpha - 5, 0)
			
			for n, t in pairs(tData) do
				local chick1 = render.world_to_screen(v.tPos[t[1]])
				local chick2 = render.world_to_screen(v.tPos[t[2]])
				
				if chick1 and chick2 then
					render.push_alpha_modifier(v.iAlpha/255)
					render.line(chick1, chick2, cow:get())
					render.pop_alpha_modifier()
				end
			end
		end
	end
end)