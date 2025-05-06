-- local variables for API functions. any changes to the line below will be lost on re-generation
local bit_band, client_camera_angles, client_color_log, client_exec, client_eye_position, client_key_state, client_register_esp_flag, client_screen_size, client_trace_line, client_userid_to_entindex, entity_get_game_rules, entity_get_local_player, entity_get_origin, entity_get_prop, entity_is_alive, globals_curtime, globals_frametime, globals_mapname, globals_tickinterval, json_parse, json_stringify, math_abs, math_atan2, math_ceil, math_cos, math_deg, math_floor, math_min, math_rad, math_sin, math_sqrt, pairs, renderer_indicator, renderer_line, renderer_text, renderer_world_to_screen, string_format, string_len, type, ui_get, ui_new_button, ui_new_checkbox, ui_new_combobox, ui_new_hotkey, ui_new_multiselect, ui_new_slider, ui_new_textbox, ui_reference, tostring, readfile, ui_set, ui_set_callback, writefile, ipairs, ui_set_visible = bit.band, client.camera_angles, client.color_log, client.exec, client.eye_position, client.key_state, client.register_esp_flag, client.screen_size, client.trace_line, client.userid_to_entindex, entity.get_game_rules, entity.get_local_player, entity.get_origin, entity.get_prop, entity.is_alive, globals.curtime, globals.frametime, globals.mapname, globals.tickinterval, json.parse, json.stringify, math.abs, math.atan2, math.ceil, math.cos, math.deg, math.floor, math.min, math.rad, math.sin, math.sqrt, pairs, renderer.indicator, renderer.line, renderer.text, renderer.world_to_screen, string.format, string.len, type, ui.get, ui.new_button, ui.new_checkbox, ui.new_combobox, ui.new_hotkey, ui.new_multiselect, ui.new_slider, ui.new_textbox, ui.reference, tostring, readfile, ui.set, ui.set_callback, writefile, ipairs, ui.set_visible

-- Requires
local vector 	= require "vector"

-- Multicolor Function
local function color_print(...)
    local args = {...}
    local color, def = {255, 255, 255}
    local text, len = "No text", #args
    for k,v in pairs(args) do
        if type(v) == "table" then
            v[1] = v[1] or 255
            v[2] = v[2] or 255
            v[3] = v[3] or 255
            color = v
        else
            text = v
            client_color_log(color[1], color[2], color[3], text .. (k == len and "" or "\0"))
        end
    end
	return color_print
end

-- Jumpbug Data
local ducking 		= false
local jumping 		= false
local previous 		= nil
local bugged 		= false

-- Optimizer Data
local data = {
	last_yaw 		= 0,
	ideal_yaw 		= 0,
}

-- Bhop Mode data     
local s_bhop = {
	["Left SW"] 	= {-450, 450, 90},
	["Right SW"] 	= {-450, 450, -90},
	["BW"] 			= {-450, 450, 180},
	["W"] 			= {-450, 450, 90, -90},
	["A"] 			= {-450, 450, 0, 180},
	["S"] 			= {-450, 450, 180, 0},
	["D"] 			= {-450, 450, -90, 90}
}

-- State Responses
local record_state = {
	['0'] = "Cleared Recording",
	['1'] = "Started Recording",
	['2'] = "Stopped Recording"
}

local play_state = {
	['0'] = "Stopped Playback",
	['1'] = "Started Playback"
}

-- Recording Data
local starting
local ending
local recording 		= { }
local recording_state 	= 0
local playback_state	= 0
local alligned			= false
local playback			= false
local command_num		= 0
local index

-- Screen Resolution Stuff
local sc 				= {client_screen_size()}
local cw 				= sc[1]/2
local ch 				= sc[2]/2
local height_scale 		= sc[2] / 10

-- UI Elements

	-- Main toggle
	local master_switch = ui_new_checkbox("Misc", "Movement", "Crescent")

	-- Visual Indicators
	local indicators 	= ui_new_multiselect("Misc", "Movement", "\nIndicators", { "Recorder", "Bhop Style", "1HP Flash" })

	-- Chat stats & Jumpbug
	local jumpbug		= ui_new_hotkey("Misc", "Movement", "Jumpbug")
	local bhop 			= ui_reference("MISC", "Movement", "Bunny hop")

	-- Bhop Styles
	local style			= ui_new_checkbox("Misc", "Movement", "Bhop Styles")
	local hotkey		= ui_new_hotkey("Misc", "Movement", "Bind", true)
	local modes			= ui_new_combobox("Misc", "Movement", "\n", { "Left SW", "Right SW", "BW", "W", "A", "S", "D" })

	-- Strafe Optimizer
	local optimizer		= ui_new_checkbox("Misc", "Movement", "Optimizer")
	local strength		= ui_new_slider("Misc", "Movement", 'Strength', 0, 100, 50, true, '%')
	local theshold		= ui_new_slider("Misc", "Movement", 'Threshold', 250, 350, 280, true)

	-- Movement Recorder
	local recorder		= ui_new_checkbox("Misc", "Movement", "Recorder")
	local options 		= ui_new_multiselect("Misc", "Movement", "\nOptions", { "Auto Align", "Silent Angles", "Visualize Trail" })
	local start			= ui_new_button("Misc", "Movement", "Start/Stop Recording", function()
		recording_state = (recording_state + 1) % 3
		color_print({0,175,240}, "[Crescent] ", {255, 255, 255}, record_state[tostring(recording_state)])
		client_exec("playvol buttons\\blip1 1")
		if recording_state == 1 then 
			starting = vector(entity_get_prop(entity_get_local_player(), "m_vecOrigin"))
		elseif recording_state == 2 then
			ending = vector(entity_get_prop(entity_get_local_player(), "m_vecOrigin"))
		else
			starting, ending, recording = nil, nil, { }
		end
	end)
	local replay		= ui_new_button("Misc", "Movement", "Play/Stop Playback", function()
		playback_state = (playback_state + 1) % 2
		color_print({0,175,240}, "[Crescent] ", {255, 255, 255}, play_state[tostring(playback_state)])
		client_exec("playvol buttons\\blip1 1")
		alligned = playback_state == 0
	end)
	local clear			= ui_new_button("Misc", "Movement", "Clear Recording", function()
		starting, ending, recording, recording_state, playback_state, alligned, playback, command_num, index = nil, nil, { }, 0, 0, false, false, 0, 0
	end)
	local name			= ui_new_textbox("Misc", "Movement", "Name")
	local import		= ui_new_button("Misc", "Movement", "Import Recording", function()
		if ui_get(name) == '' then return end
		recording 		= { }
		local buffer 	= readfile("csgo\\"..ui_get(name)..".json")
		local imported 	= json_parse(buffer)
		for i = 1, #imported do
			recording[#recording+1] = {imported[i][1], imported[i][2], imported[i][3], imported[i][4], imported[i][5], imported[i][6], imported[i][7], imported[i][8], imported[i][9], imported[i][10], imported[i][11], imported[i][12]}
		end
		starting 		= vector(imported[1][13], imported[1][14], imported[1][15])
		ending			= vector(imported[1][16], imported[1][17], imported[1][18])
		alligned, command_num, playback, recording_state, index = false, 0, false, 2, 0
		color_print({0,175,240}, "[Crescent] ", {255, 255, 255}, "Imported Recording from ", {0, 175, 240}, "csgo\\"..ui_get(name)..".json")
		ui_set(name, '')
	end)
	local export		= ui_new_button("Misc", "Movement", "Export Recording", function()
		if ui_get(name) == '' and recording_state ~= 2 then return end
		local exported 	= { }
		for i = 1, #recording do
			exported[#exported+1] = {recording[i][1], recording[i][2], recording[i][3], recording[i][4], recording[i][5], recording[i][6], recording[i][7], recording[i][8], recording[i][9], recording[i][10], recording[i][11], recording[i][12], starting.x, starting.y, starting.z, ending.x, ending.y, ending.z}
		end
		local buffer 	= json_stringify(exported)
		writefile("csgo\\"..ui_get(name)..".json", buffer)
		client_exec("playvol buttons\\blip1 1")
		color_print({0,175,240}, "[Crescent] ", {255, 255, 255}, "Exported Recording to ", {0, 175, 240}, "csgo\\"..ui_get(name)..".json")
		ui_set(name, '')
	end)

-- Menu visibility Lists
local main_items 		= { indicators, jumpbug, style, optimizer, recorder }
local style_items		= { hotkey, modes }
local opti_items		= { strength, theshold }
local record_items		= { options, start, replay, clear, name, import, export }

-- Useful Functions
local function contains(table, key)
    for index, value in pairs(table) do
        if value == key then return true end -- , index
    end
    return false -- , nil
end

local function isNaN( v ) 
    return v ~= v
end

local function clamp(x, min, max)
	return x < min and min or x > max and max or x
end

local function normalize(angle)
	while angle >= 180 do angle = angle - 360 end
	while angle <= -180 do angle = angle + 360 end
	return angle
end

local function scale_from_angle_to(ang1, ang2, p)
	return ang1 + ((ang2 - ang1) * p)
end

local function transition(from, to, start, fully, value)
	return from - (clamp(((value - start) / -(start - fully)), 0, 1) * (from - to))
end

local function AngleVectors(x, y)
	local xRad, yRad = x * math.pi/180, y * math.pi/180
	local sy = math_sin(yRad);
	local cy = math_cos(yRad);

	local sp = math_sin(xRad);
	local cp = math_cos(xRad);

	return cp * cy, cp * sy, -sp
end

-- Jumpbug function
local function JBStatus(localplayer)
	local startDuckDist = 16
	local endDuckDist = 10
	local rangeMax, angMax = 10, 360
	local rangeSteps, angSteps = 10, 180

	local origin	= vector(entity_get_prop(localplayer, "m_vecOrigin"))
	local velocity	= vector(entity_get_prop(localplayer, "m_vecVelocity"))
	if not origin.x then return end
    if velocity.z == 0 then return end

    local tick = globals_tickinterval()

    px = origin.x + velocity.x * tick
    py = origin.y + velocity.y * tick
    pz = origin.z + velocity.z * tick

	local toDuck, toJump = false, false
	for range = 0, rangeMax, rangeMax/rangeSteps do
		for ang = 0, angMax, angMax/angSteps do
			local angleX, angleY, angleZ = AngleVectors(0, ang)
			local x = px + angleX * range
			local y = py + angleY * range
			local z = pz + angleZ * range

			local fraction = client_trace_line(localplayer, x, y, z, x, y, z - 256)

			if 256 * fraction < startDuckDist then 
				toDuck = true
			end

			if 256 * fraction < endDuckDist then 
				toJump = true
				return toDuck, toJump
			end

		end
	end

	return toDuck, toJump
end

-- Visual Functions
local function draw_circle_3d(x, y, z, radius, degrees, start_at, r, g, b, a)
	local accuracy = 40/10
	local old = { x, y }
	for rot=start_at, degrees+start_at, accuracy do
		local rot_t = math_rad(rot)
		local line_ = vector(radius * math_cos(rot_t) + x, radius * math_sin(rot_t) + y, z)
		local current = { x, y }
		current.x, current.y = renderer_world_to_screen(line_.x, line_.y, line_.z)
		if current.x and old.x then
			renderer_line(current.x, current.y, old.x, old.y, r, g, b, a)
		end
		old.x, old.y = current.x, current.y
	end
end

-- Paint Function
local function on_paint()

	local local_player = entity_get_local_player()
	if not entity_is_alive(local_player) then return end

	-- Draw Jumpbug indicator
	if ui_get(jumpbug) then renderer_indicator(117, 205, 13, 255, "JB") end

	-- Display Recorder Progress
	if contains(ui_get(indicators), "Recorder") and recording[index] ~= nil and not playback then
		renderer_text(cw, ch+height_scale, 255, 255, 255, 255, "cbd", 0, string_format(" %d / %d (%d%%)", index, #recording, math_ceil(index/#recording*100)))
	end

	-- Shows current bhop direction bases on style
	if contains(ui_get(indicators), "Bhop Style") and ui_get(style) then
		
		local flags 			= entity_get_prop(local_player, "m_fFlags")
		local onground 			= bit_band(flags, 1) ~= 0
		local c					= (ui_get(hotkey)) and {117,205,13,255} or {255, 0, 0, 100}
		renderer_text(cw, ch+height_scale+25, c[1], c[2], c[3], c[4], "cbd", 0, ui_get(modes))

	end

	-- Loops through all current recorded points to visualize a trail
	if ui_get(recorder) and contains(ui_get(options), "Visualize Trail") then
		
		if recording and #recording > 0 then

			for k, v in ipairs(recording) do

				if v[1] ~= globals_mapname() then return end
				local cur = {renderer_world_to_screen(v[4], v[5], v[6])}
				
				if k == 1 then

					if cur[1] and cur[2] then
						renderer_line(cur[1], cur[2], cur[1]-1, cur[2]-1, 255, 255, 255, 255)
					end

				else

					local old = {renderer_world_to_screen(recording[k-1][4], recording[k-1][5], recording[k-1][6])}
					if old[1] and old[2] then
						renderer_line(cur[1], cur[2], old[1], old[2], 255, 255, 255, 255)
					end

				end

			end

		end

	end

	-- Displays the current Recording's start & end position

	if starting and ending then

		local origin 				= vector(entity_get_origin(local_player))
		local starting_distance 	= origin:dist(starting)
		local ending_distance 		= origin:dist(ending)
		local s_color 				= starting_distance <= 40 and {74, 199, 113, 255} or {255, 110, 110, 255}
		local e_color 				= ending_distance <= 40 and {74, 199, 113, 255} or {255, 110, 110, 255}

		draw_circle_3d(starting.x, starting.y, starting.z, 25, 360, 0, s_color[1], s_color[2], s_color[3], s_color[4])
		draw_circle_3d(ending.x, ending.y, ending.z, 25, 360, 0, e_color[1], e_color[2], e_color[3], e_color[4])
	
	end

end

-- Setup Command Function
local function on_setup_command(cmd)

	local local_player 		= entity_get_local_player()
	local flags 			= entity_get_prop(local_player, "m_fFlags")
	local onground 			= bit_band(flags, 1) ~= 0
	local valve				= entity_get_prop(entity_get_game_rules(), "m_bIsValveDS")
	local origin			= vector(entity_get_prop(local_player, "m_vecOrigin"))
	local velocity			= vector(entity_get_prop(local_player, "m_vecVelocity"))
	local camera			= vector(client_camera_angles())
	local eye				= vector(client_eye_position())
	local speed 			= math_floor(math_sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))+0.5)

	-- Movement Recorder
	if recording_state == 1 then
		recording[#recording+1] = {globals_mapname(), cmd.in_jump, cmd.in_duck, origin.x, origin.y, origin.z, globals_curtime(), cmd.move_yaw, cmd.forwardmove, cmd.sidemove, camera.x, camera.y}
	elseif recording_state == 2 then

		if recording[1][1] ~= globals_mapname() then return end

		if playback_state == 1 then

			if contains(ui_get(options), "Auto Align") and not alligned then

				local dist	= origin:dist(starting)
				local aim	= vector(recording[1][11], recording[1][12], 0)
				local angd	= camera:dist(aim)

				if (1 > dist and dist > -1) and (1 > angd and angd > -1) then
					alligned 	= true
					playback 	= false
				else

					local dp			= vector(camera.x - aim.x, camera.y - aim.y, 0)
					local dist			= math_sqrt(dp.x*dp.x + dp.y*dp.y)
					dp.x, dp.y			= dp.x/dist, dp.y/dist
					local mp			= math_min(1, dist/3)*0.5
					local dmp			= (mp + math_abs(dist*(1 - mp))) * globals_frametime() * 15 * 2
					local p				= camera.x - dp.x*dmp*0.1
					local y				= camera.y - dp.y*dmp*0.1
					local delta 		= origin:to(starting)
					local _, yaw 		= delta:angles()
					local dist 			= origin:dist(starting)
					local multiplier 	= transition(450, 30, 500, 50, dist)

					client_camera_angles(p, y)
					cmd.move_yaw = yaw
					cmd.sidemove = 0
					cmd.forwardmove = math_min(450, delta:length()*multiplier)

				end

			else

				if command_num == 0 then
					if cmd.command_number ~= nil then command_num = cmd.command_number end
				else

					index = cmd.command_number - command_num

					if ( recording[index] ~= nil ) and (not playback) then

						cmd.in_jump 	= recording[index][2]
						cmd.in_duck		= recording[index][3]
						cmd.move_yaw 	= recording[index][8]
						cmd.forwardmove = recording[index][9]
						cmd.sidemove 	= recording[index][10]

						if contains(ui_get(options), "Silent Angles") then
							cmd.pitch 	= recording[index][11]
							cmd.yaw		= recording[index][12]
						else
							client_camera_angles( recording[index][11], recording[index][12] )
						end

						if index == #recording then

							alligned 		= false
							index			= 0
							command_num 	= 0
							playback 		= true
							ui_set(replay, true)

						end

					end

				end

			end

		end

	end

	-- Bhop Styles
	if (cmd.in_jump or not onground) and (ui_get(style) and ui_get(hotkey)) then 

		local current_style	= ui_get(modes)
		local bhop_info 	= s_bhop[current_style]


		if string_len(current_style) == 1 then

			if client_key_state(0x41) then

				cmd.sidemove 	= bhop_info[1]
				cmd.yaw			= cmd.yaw + bhop_info[3]

			elseif client_key_state(0x44) then

				cmd.sidemove 	= bhop_info[2]
				cmd.yaw			= cmd.yaw + bhop_info[4]

			end

		else

			cmd.yaw				= cmd.yaw + bhop_info[3]

			if client_key_state(0x41) then

				cmd.sidemove 	= bhop_info[1]

			elseif client_key_state(0x44) then

				cmd.sidemove 	= bhop_info[2]

			end
		end
	end

	-- Bhop Optimizer
	if ui_get(optimizer) and not onground then

		if playback_state == 1 then return end
		local str		= ui_get(strength)
		local the		= ui_get(theshold)
		local adaptive	= transition(str, 20, theshold, 1300, speed)
		local calc		= adaptive / 100
		local pred		= vector()
		pred.x 			= origin.x + ((velocity.x * globals_tickinterval()) * 3)
		pred.y 			= origin.y + ((velocity.y * globals_tickinterval()) * 3)

		if (cmd.forwardmove ~= 0) or (cmd.sidemove == 0) or the > speed or (math_abs(camera.y - data.last_yaw) < 0.1) then
			
			data.last_yaw = camera.y
			return

		else

			local vel	= math_atan2(velocity.y, velocity.x)
			local ideal = normalize(camera.y - math_deg(vel))

			if (cmd.sidemove < 0) then

				data.ideal_yaw		= camera.y + math_abs(ideal)
				cmd.in_moveright 	= 0

			elseif (cmd.sidemove > 0) then

				data.ideal_yaw		= camera.y - ideal
				cmd.in_moveleft		= 0

			end

			if data.ideal_yaw and camera.y and calc and speed > 0 then

				local yaw_calc 	= normalize(scale_from_angle_to(camera.y, data.ideal_yaw, calc))
				client_camera_angles(client_camera_angles(), yaw_calc)
				data.last_yaw 	= camera.y

			end

		end

	end

	-- Jumpbug
	if not ui_get(jumpbug) then

		if bugged then
			ui_set(bhop, previous)
			previous 	= nil
			bugged 		= false
		end
		if ducking then ducking = false end
		if jumping then jumping = false end
		return

	end

	if not previous then
		previous = ui_get(bhop)
	end

	local duck, jump = JBStatus(local_player)

	if jump and jumping then
		if velocity.z <= 0 then
			if cmd.command_number % 2 == 0 then
				cmd.in_jump = true
			else

				cmd.in_jump = false
			end
		end
	end

	if duck or ducking then

		cmd.in_duck = true
		ducking 	= true

	end

	if jump or jumping then

		ui_set(bhop, false)
		cmd.in_duck		= false
		cmd.in_jump		= true
		jumping			= true
		bugged			= true

	end

	if not duck and not jump and bugged then

		ui_set(bhop, previous)
		previous 	= nil
		bugged 		= false
		ducking 	= false
		jumping 	= false

	end

end

local function one_hit(target)
	local health = entity_get_prop(target, "m_iHealth")
	return (contains(ui_get(indicators), "1HP Flash") and health == 1)
end

-- Resets certain lua data
local function reset_data()
	starting, ending, recording, recording_state, playback_state, alligned, playback, command_num, index, data.last_yaw, data.ideal_yaw = nil, nil, { }, 0, 0, false, false, 0, 0, 0, 0
end

-- Callback handler
local function handle_callbacks(state)
	local call_back = (state) and client.set_event_callback or client.unset_event_callback

	-- Handles majority of movement features
	call_back("setup_command", on_setup_command)

	-- Draws trails and other things
	call_back("paint", on_paint)

	-- Resets Recording Data
	call_back("round_start", reset_data)
	call_back("client_disconnect", reset_data)
	call_back("level_init", reset_data)
	call_back("player_connect_full", function(e) if client_userid_to_entindex(e.userid) == entity_get_local_player() then reset_data() end end)
end

-- Checkbox handlers
local function handle_master_switch(ref)
	local enabled = ui_get(ref)

	for i = 1, #main_items do
		ui_set_visible(main_items[i], enabled)
	end

	handle_callbacks(enabled)
end

local function handle_recorder_switch(ref)
	local enabled = ui_get(ref)

	for i = 1, #record_items do
		ui_set_visible(record_items[i], enabled)
	end
end

local function handle_bhop_switch(ref)
	local enabled = ui_get(ref)

	for i = 1, #style_items do
		ui_set_visible(style_items[i], enabled)
	end
end

local function handle_optimizer_switch(ref)
	local enabled = ui_get(ref)

	for i = 1, #opti_items do
		ui_set_visible(opti_items[i], enabled)
	end
end

-- Ui Callbacks for visiblity
ui_set_callback(recorder, handle_recorder_switch)
ui_set_callback(master_switch, handle_master_switch)
ui_set_callback(style, handle_bhop_switch)
ui_set_callback(optimizer, handle_optimizer_switch)
client_register_esp_flag("1HP", 255, 0, 0, one_hit)

-- Initialize these on load
handle_optimizer_switch(optimizer)
handle_bhop_switch(style)
handle_recorder_switch(recorder)
handle_master_switch(master_switch)