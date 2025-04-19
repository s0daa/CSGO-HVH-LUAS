local client_set_event_callback, client_userid_to_entindex, entity_get_bounding_box, entity_get_local_player, entity_get_origin, entity_get_player_name, entity_get_player_resource, entity_get_prop, entity_is_alive, entity_is_dormant, entity_is_enemy, globals_maxplayers, math_floor, math_min, pairs, ipairs, renderer_rectangle, renderer_text, renderer_world_to_screen = client.set_event_callback, client.userid_to_entindex, entity.get_bounding_box, entity.get_local_player, entity.get_origin, entity.get_player_name, entity.get_player_resource, entity.get_prop, entity.is_alive, entity.is_dormant, entity.is_enemy, globals.maxplayers, math.floor, math.min, pairs, ipairs, renderer.rectangle, renderer.text, renderer.world_to_screen

local vector = require "vector"

local vis_check = ui.new_checkbox("visuals", "Player ESP", "Last dormant position")
local vis = ui.new_color_picker("visuals", "Player ESP", "Last seen", 255, 0, 0, 150)

local function getEnemies()
	local player_resource = entity_get_player_resource()
	local list = {}
	for player=1, globals_maxplayers() do
		if entity_get_prop(player_resource, "m_bConnected", player) == 1 and entity_is_enemy(player) then
			list[#list+1] = player
		end
	end
	return list
end

local function rectangle_outline(x, y, w, h, r, g, b, a, s)
	s = s or 1
	renderer_rectangle(x, y, w, s, r, g, b, a)
	renderer_rectangle(x, y+h-s, w, s, r, g, b, a)
	renderer_rectangle(x, y+s, s, h-s*2, r, g, b, a)
	renderer_rectangle(x+w-s, y+s, s, h-s*2, r, g, b, a)
end

local lastPos = {}

client_set_event_callback("paint", function()
	local r, g, b, a = ui.get(vis)
	if not entity_is_alive(entity_get_local_player()) then return end

	for i, ent in ipairs(getEnemies()) do
		local alpha = entity.get_esp_data(ent).alpha
		local origin = vector(entity.get_origin(ent))

		if alpha > 0.05 then
			lastPos[ent] = nil
		elseif alpha ~= 0 then
			lastPos[ent] = origin
		end
	end

	for key, vec in pairs(lastPos) do
		local x,y = renderer_world_to_screen(vec.x, vec.y, vec.z)
		local selfOrigin = vector(entity_get_origin(entity_get_local_player()))

		local dist = selfOrigin:dist(vec)
		dist = 4 - (math_min(3, dist/1000))

		local length = 10*dist
		local height = 20*dist

		if x and ui.get(vis) then
			renderer_text(x+length/2, y-height-3, r, g, b, a, "-", nil, "WARNING")
			renderer_text(x+length/2, y-height+5, r, g, b, a, "-", nil, entity_get_player_name(key):upper())

			rectangle_outline(x-length/2, y-height, length, height, r, g, b, a)
			rectangle_outline(x-length/2-1, y-height-1, length+2, height+2, 0, 0, 0, a/1.875)
			rectangle_outline(x-length/2+1, y-height+1, length-2, height-2, 0, 0, 0, a/1.875)
		end
	end
end)

client_set_event_callback("round_prestart", function()
	lastPos = {}
end)
client_set_event_callback("player_death", function(e)
	local ent = client_userid_to_entindex(e.userid)
	lastPos[ent] = nil
end)