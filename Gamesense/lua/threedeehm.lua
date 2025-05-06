local log = client.log
local floor = math.floor
local table_insert = table.insert
local uid_to_entindex = client.userid_to_entindex
local entity_get_prop = entity.get_prop
local get_all_players = entity.get_players
local get_localplayer = entity.get_local_player

local bullet_impact = { }
local hitmarker_queue = { }
local getUI = ui.get
local setUI = ui.set

local customhitmarker = ui.new_checkbox("VISUALS", "Player ESP", "3D Hitmarker")
local color = ui.new_color_picker("VISUALS", "Player ESP", "Hitmarker Color",255,255,255)
local hitmarkersize = ui.new_slider("VISUALS", "Player ESP", "3D Hitmarker Size", 1, 15)
local fadeout = ui.new_checkbox("VISUALS", "Player ESP", "Fade Out")
local hitmarkerduration = ui.new_slider("VISUALS", "Player ESP", "Duration", 1, 5)

setUI(hitmarkersize, 4)
setUI(fadeout, true)
setUI(hitmarkerduration, 3)

local function on_bullet_impact(e)
	local attacker_uid = e.userid
	local attacker_entid = uid_to_entindex(attacker_uid)

	if attacker_entid == get_localplayer() then
		local originX = e.x
		local originY = e.y
		local originZ = e.z
		
		table_insert(bullet_impact, {originX, originY, originZ , globals.realtime()})
	end
end

local function vectordistance(x1,y1,z1,x2,y2,z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow( y1 - y2, 2) + math.pow( z1 - z2 , 2) )
end

local function on_player_hurt(e)
	local attacker_uid = e.attacker
	local attacker_entid = uid_to_entindex(attacker_uid)
	local victim_uid = e.userid
	local victim_entid = uid_to_entindex(victim_uid)
	local bestdistance = 100
	local bestX,bestY,bestZ = 0,0,0
	local duration = getUI(hitmarkerduration)
	if attacker_entid == get_localplayer() then
		local realtime = floor(globals.realtime())
		local victimX, victimY, victimZ = entity_get_prop(victim_entid, "m_vecOrigin")
		
		for i = 1,#bullet_impact,1 do
			if bullet_impact[i][4] + duration >= floor(realtime) then
				local originX = bullet_impact[i][1]
				local originY = bullet_impact[i][2]
				local originZ = bullet_impact[i][3]
				
				local distance = vectordistance(victimX,victimY,victimZ,originX,originY,originZ)
				if distance < bestdistance then
					bestdistance = distance
					bestX = originX
					bestY = originY
					bestZ = originZ
				end 
			end
		end
		if bestX == 0 and bestY == 0 and bestZ == 0 then
			victimZ = victimZ + 50
			bestX = victimX
			bestY = victimY
			bestZ = victimZ
		end
		for i = 1,#bullet_impact,1 do 
			bullet_impact[i] = { 0 , 0 , 0 , 0 }
		end
		table_insert(hitmarker_queue, {bestX, bestY, bestZ , globals.realtime()})
	end
end

local function on_paint(context)
	if getUI(customhitmarker) then
		local realtime = globals.realtime()
		local duration = getUI(hitmarkerduration)
		local max_time_delta = getUI(hitmarkerduration) / 2
		local maxtime = realtime - max_time_delta / 2
		for i = 1,#hitmarker_queue,1 do
		if hitmarker_queue[i][4] + duration > maxtime then
			if hitmarker_queue[i][1] ~= nil then
			local x, y = client.world_to_screen(context, hitmarker_queue[i][1], hitmarker_queue[i][2], hitmarker_queue[i][3])
			
				if x ~= nil and y ~= nil then
				local size = getUI(hitmarkersize)
				r, g, b, a = getUI(color)
				a = 255
				if getUI(fadeout) then
					if (hitmarker_queue[i][4] - (realtime - duration)) < (duration / 2) then
						a = (hitmarker_queue[i][4] - (realtime - duration)) / (duration / 2) * 255
						if a < 5 then
							hitmarker_queue[i] = { 0 , 0 , 0 , 0 }
						end
					end
				end
				client.draw_line(context, x - size * 2, y - size * 2, x - ( size ), y - ( size ), r, g, b, a)
				client.draw_line(context, x - size * 2, y + size * 2, x - ( size ), y + ( size ), r, g, b, a)
				client.draw_line(context, x + size * 2, y + size * 2, x + ( size ), y + ( size ), r, g, b, a)
				client.draw_line(context, x + size * 2, y - size * 2, x + ( size ), y - ( size ), r, g, b, a)
				end
			end
		end
		end
	end
end

local function on_round_prestart(e)
	for i = 1,#bullet_impact,1 do 
		bullet_impact[i] = { 0 , 0 , 0 , 0 }
	end
	for i = 1,#hitmarker_queue,1 do 
		hitmarker_queue[i] = { 0 , 0 , 0 , 0 }
	end
end

local function on_round_start(e)
	for i = 1,#bullet_impact,1 do 
		bullet_impact[i] = { 0 , 0 , 0 , 0 }
	end
	for i = 1,#hitmarker_queue,1 do 
		hitmarker_queue[i] = { 0 , 0 , 0 , 0 }
	end
end

local function on_player_spawned(e)
	local userid = e.userid
	local entid = uid_to_entindex(userid)
	if entid == get_localplayer() then
		for i = 1,#bullet_impact,1 do 
			bullet_impact[i] = { 0 , 0 , 0 , 0 }
		end
		for i = 1,#hitmarker_queue,1 do 
			hitmarker_queue[i] = { 0 , 0 , 0 , 0 }
		end
	end
end

local err = client.set_event_callback("bullet_impact", on_bullet_impact) or client.set_event_callback("round_start", on_round_start) or client.set_event_callback("player_spawned", on_player_spawned) or client.set_event_callback("round_prestart", on_round_prestart) or client.set_event_callback('player_hurt', on_player_hurt) or client.set_event_callback('paint', on_paint) 
			
if err then
    client.log("set_event_callback failed: ", err)
end