local ui_get = ui.get
local ui_set = ui.set
local client_visible = client.visible
local entity_get_local_player = entity.get_local_player
local entity_get_prop = entity.get_prop
local client_world_to_screen = client.world_to_screen
local client_screen_size = client.screen_size
local entity_get_players = entity.get_players
local entity_hitbox_position = entity.hitbox_position 
local entity_is_enemy = entity.is_enemy

local stored_target = nil
local old_minimum_damage = 0

local using_visible_dmg = false
local ref_minimum_damage = ui.reference("rage", "aimbot", "Minimum damage")
local custom_minimum_damage = ui.new_checkbox("rage", "aimbot", "Custom minimum damage")
local visible_minimum_damage = ui.new_slider("rage", "aimbot", "Visible minimum damage", 1, 126)
local override = ui.new_hotkey("rage", "aimbot", "Override visible damage")
local override_minimum_damage = ui.new_slider("rage", "aimbot", "Overrode visible minimum damage", 1, 126)

ui_set(custom_minimum_damage, false)
ui_set(visible_minimum_damage, 20)

--//helpers
local function vec2_distance(f_x, f_y, t_x, t_y)
	local delta_x, delta_y = f_x - t_x, f_y - t_y
	return math.sqrt(delta_x*delta_x + delta_y*delta_y)
end

local function get_all_player_positions(ctx, screen_width, screen_height, enemies_only)
	local player_indexes = {}
	local player_positions = {}

	local players = entity_get_players(enemies_only) -- true = enemies only
	if #players == 0 then
		return
	end

	for i=1, #players do
		local player = players[i]

		local px, py, pz = entity_get_prop(player, "m_vecOrigin")
		local vz = entity_get_prop(player, "m_vecViewOffset[2]")

		if pz ~= nil and vz ~= nil then
            pz = pz + (vz*0.5)

            local sx, sy = client_world_to_screen(ctx, px, py, pz)
            if sx ~= nil and sy ~= nil then
                if sx >= 0 and sx <= screen_width and sy >= 0 and sy <= screen_height then 
					player_indexes[#player_indexes+1] = player
                    player_positions[#player_positions+1] = {sx, sy}
                end
            end
		end
	end
	
	return player_indexes, player_positions
end

local function check_fov(ctx)
    local screen_width, screen_height = client_screen_size()
    local screen_center_x, screen_center_y = screen_width*0.5, screen_height*0.5
	local fov_limit = 250 --this value is in pixels	
	
	if get_all_player_positions(ctx, screen_width, screen_height, true) == nil then
		return
	end
	local enemy_indexes, enemy_coords = get_all_player_positions(ctx, screen_width, screen_height, true)
	
	if #enemy_indexes <= 0 then
		return true
	end
	
	if #enemy_coords == 0 then
		return true
	end
	
	local closest_fov = 133337
	local closest_entindex = 133337

	for i=1, #enemy_coords do
		local x = enemy_coords[i][1]
		local y = enemy_coords[i][2]

		local current_fov = vec2_distance(x, y, screen_center_x, screen_center_y)
		if current_fov < closest_fov then
			closest_fov = current_fov -- found a target that is closer to center of our screen
			closest_entindex = enemy_indexes[i]
		end
	end

	return closest_fov > fov_limit, closest_entindex
end

local function can_see(ent)	
    for i=0, 18 do
		if client_visible(entity_hitbox_position(ent, i)) then
			return true
		end
	end
	return false
end
local oldmindmg = 1
local function on_paint(ctx)
	
	if not ui.get(custom_minimum_damage) then
		return
	end
	if old_minimum_damage ~= ui.get(ref_minimum_damage) and not using_visible_dmg then
		old_minimum_damage = ui.get(ref_minimum_damage)
	end
	
	local local_entindex = entity_get_local_player()
	if entity_get_prop(local_entindex, "m_lifeState") ~= 0 then	
		using_visible_dmg = false
		ui_set(ref_minimum_damage,  old_minimum_damage)
		return
	end
	
	local enemy_visible, enemy_entindex = check_fov(ctx)

	if enemy_entindex == nil then
		return
	end
	
	if enemy_visible and enemy_entindex ~= nil and stored_target ~= enemy_entindex then
		stored_target = enemy_entindex
	end
	
	local visible = can_see(enemy_entindex)
	if visible then
		using_visible_dmg = true
		if (ui.get(override)) then
			ui.set(ref_minimum_damage, ui.get(override_minimum_damage))
			
		else
			ui_set(ref_minimum_damage,  ui.get(visible_minimum_damage))
		end
	else
		using_visible_dmg = false
		ui_set(ref_minimum_damage,  old_minimum_damage)
	end
	stored_target = enemy_entindex
end

function on_player_death(e)

	if not ui.get(custom_minimum_damage) then
		return
	end
	
	if stored_target == nil then
		return
	end
	
	local userid = e.userid
	
	if userid == nil then
		return
	end
	
	local victim_entindex = client.userid_to_entindex(userid)
		
	if victim_entindex == stored_target then
		stored_target = nil
		ui_set(ref_minimum_damage,  old_minimum_damage)
	end
end

client.set_event_callback('paint', on_paint)
client.set_event_callback("player_death", on_player_death)