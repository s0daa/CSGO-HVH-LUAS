local mainswitch = menu.add_checkbox("Trails", "Enable")
local addswitch = menu.add_checkbox("Trails", "[Debug]")
--local showbt = menu.add_checkbox("Show backtrack", "Enable")
local options1 = menu.add_selection("Trails", "Color type",{"Static color picker", "RGB"})
local color = mainswitch:add_color_picker("Color")
local slider = menu.add_slider("Trails", "RGB speed", 0.0, 10.0)
local slider2 = menu.add_slider("Trails", "Decay [s]", 0, 5)
local alpha = menu.add_slider("Trails", "Alpha", 0, 255)
local delay_slider = menu.add_slider("Trails", "Delay [s]", 1, 5)
local options2 = menu.add_selection("Trails","Trails type",{"Empty rectangle","Filled rectangle"})
local renderspot = menu.add_selection("Trails", "Render origin",{"Localplayer render origin", "Pelvis hitbox pos"})
local boxsize = menu.add_slider("Trails", "Rectangle size", 5, 100)

local RenderSpots = {}

local function checks()
	if (options1:get() == 1) then 
		slider:set_visible(false)
		color:set_visible(true)
	else
		slider:set_visible(true)
		color:set_visible(false)
	end
end

callbacks.add(e_callbacks.PAINT, checks)

local function rgb() 
	local speed = slider:get()
    local timer = global_vars.tick_count()
    local result = {0, 0, 0, 255}

    result[0] = math.floor(math.sin(timer * speed/25 + 0) * 127 + 128)
    result[1] = math.floor(math.sin(timer * speed/25 + 2) * 127 + 128)
    result[2] = math.floor(math.sin(timer * speed/25 + 4) * 127 + 128)
	color2 = color_t(result[0], result[1], result[2], 255)
end

callbacks.add(e_callbacks.PAINT, rgb)

local Positions = {
	{ 1, 2 }
}

callbacks.add(e_callbacks.PAINT, function(one)
	if mainswitch:get() then
	if (not engine.is_connected() and not engine.is_in_game()) then
		return
	end
	if (global_vars.server_tick() % delay_slider:get() == 0) then 
			if (predkosc > 10) then
			local savedPositions = {}
			local s = entity_list.get_local_player()
			for i=0, 2 do
				if (renderspot:get() == 1) then 
					savedPositions[i] = s:get_render_origin(i)
				else
					savedPositions[i] = s:get_hitbox_pos(i)
				end
			end
			
			RenderSpots[s] = { savedPositions = savedPositions, RenderTime = global_vars.real_time() + slider2:get(), Alpha = alpha:get() }
			end
			end
	end
end)

local function kwadr(liczba)
	return liczba*liczba
end

callbacks.add(e_callbacks.PAINT, function(two)
	if (not engine.is_connected() and not engine.is_in_game()) then
		return
	end
	local s = entity_list.get_local_player()
	if (s == nil) then
		return
	end
	local origin = s:get_hitbox_pos(2)
	local speed1 = s:get_prop("m_vecVelocity[0]")
	local speed2 = s:get_prop("m_vecVelocity[1]")
	predkosc = (math.sqrt(kwadr(speed1) + kwadr(speed2)))
	if mainswitch:get() then
		for i, v in pairs(RenderSpots) do
			if v.Alpha <= 1 and global_vars.real_time() > v.RenderTime then
				RenderSpots[i] = nil
			end
			
			v.Alpha = global_vars.real_time() < v.RenderTime and math.min(v.Alpha + 5, alpha:get()) or math.max(v.Alpha - 5, 0)
			
			for n, t in pairs(Positions) do
				local two = render.world_to_screen(v.savedPositions[t[2]])
				
				if two then
					render.push_alpha_modifier(v.Alpha/255)
					
					if (options1:get() == 2 and options2:get() == 1) then
						render.rect(vec2_t.new(two.x, two.y), vec2_t(boxsize:get(), boxsize:get()), color2)
					else if (options1:get() == 2 and options2:get() == 2) then
						render.rect_fade(vec2_t.new(two.x, two.y), vec2_t(boxsize:get(), boxsize:get()), color2, color2)
						render.pop_alpha_modifier()
					else if (options1:get() == 1 and options2:get() == 1) then
						render.rect(vec2_t.new(two.x, two.y), vec2_t(boxsize:get(), boxsize:get()), color:get())
					else if (options2:get() == 1 and options2:get() == 2) then
						render.rect_fade(vec2_t.new(two.x, two.y), vec2_t(boxsize:get(), boxsize:get()), color:get(), color:get())
						render.pop_alpha_modifier()
						end
						end
						end
					end
				end
			end
		end
	end
end)