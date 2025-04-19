-- Cache common functions
local bit_band, client_set_event_callback, entity_get_bounding_box, entity_get_local_player, entity_get_players, entity_get_prop, entity_hitbox_position, entity_is_alive, math_ceil, math_pow, math_sqrt, renderer_line, renderer_text, renderer_world_to_screen, ui_get, ui_new_checkbox = bit.band, client.set_event_callback, entity.get_bounding_box, entity.get_local_player, entity.get_players, entity.get_prop, entity.hitbox_position, entity.is_alive, math.ceil, math.pow, math.sqrt, renderer.line, renderer.text, renderer.world_to_screen, ui.get, ui.new_checkbox

local revolver_helper = ui_new_checkbox("lua", "a", "Enable revolver helper")

local function Vector(x,y,z) 
	return {x=x or 0,y=y or 0,z=z or 0} 
end

local function Distance(from_x,from_y,from_z,to_x,to_y,to_z)  
  return math_ceil(math_sqrt(math_pow(from_x - to_x, 2) + math_pow(from_y - to_y, 2) + math_pow(from_z - to_z, 2)))
end

local function check_revolver_distance(player,victim)
	if player == nil then return end
	if victim == nil then return end
	
	local weap = entity_get_prop(entity_get_prop(player, "m_hActiveWeapon"), "m_iItemDefinitionIndex")
	if weap == nil then return end
	local vnum = bit_band(weap, 0xFFFF)
	local player_origin = Vector(entity_get_prop(player, "m_vecOrigin"))
	local victim_origin = Vector(entity_get_prop(victim, "m_vecOrigin"))

	local units = Distance(player_origin.x, player_origin.y, player_origin.z, victim_origin.x, victim_origin.y, victim_origin.z)
	local no_kevlar = entity_get_prop(victim, "m_ArmorValue") == 0	

	if not (vnum == 64 and no_kevlar) then
		return 0
	end
	
	if units < 585 and units > 511 then
		return 1
	elseif units < 511 then
		return 2
	else
		return 0
	end
end


local function draw_status(player, status)
	local x1, y1, x2, y2, alpha_multiplier = entity_get_bounding_box(player)

	if (x1 == nil or alpha_multiplier == 0) then
		return
	end
	
	local x_center = x1 / 2 + x2 / 2
	local y_additional = name == "" and -8 or 0

	if status == 1 then
		renderer_text(x_center, y1 - 20 + y_additional, 255, 0, 0, 255, "cb", 0, "DMG")
	else
		renderer_text(x_center, y1 - 20 + y_additional, 50, 205, 50, 255, "cb", 0, "DMG+")
	end
end

local function paint()
	if not ui_get(revolver_helper) then return end
	local lp = entity_get_local_player()
	if lp == nil then return end
	if not entity_is_alive(lp) then return end
	
    local players = entity_get_players(true)
	if #players == nil or #players == 0 then
		return
	end
	for i = 1, #players do
		local entindex = players[i]	
		if (entindex ~= nil and entindex ~= entity_get_local_player()) then
			local line_start = Vector(entity_hitbox_position(entindex, 13))
			local line_stop = Vector(entity_hitbox_position(lp, 3))
			local x1, y1 = renderer_world_to_screen(line_start.x,line_start.y,line_start.z)
			local x2, y2 = renderer_world_to_screen(line_stop.x,line_stop.y,line_stop.z)

			local revolver = check_revolver_distance(lp,entindex)
			local enemy_revolver = check_revolver_distance(entindex,lp)
			
			if revolver ~= 0 and revolver ~= nil then
				draw_status(entindex,revolver)
			end
			
			if enemy_revolver ~= 0 and enemy_revolver ~= nil then
				if x1 ~= nil and x2 ~= nil and y1 ~= nil and y2 ~= nil then
					renderer_line(x1, y1, x2, y2, 255,0,0,255)
				end
			end
		end
	end
	
end

local function setup_callback(i)
    if ui.get(i) then
        client.set_event_callback("paint", paint)
    else
        client.unset_event_callback("paint", paint)
    end
end

ui.set_callback(revolver_helper, setup_callback)