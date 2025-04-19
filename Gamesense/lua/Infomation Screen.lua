local client_key_state, client_set_event_callback, database_read, database_write, entity_get_all, entity_get_bounding_box, entity_get_classname, entity_get_local_player, entity_get_player_name, entity_get_player_weapon, entity_get_players, entity_get_prop, globals_maxplayers, math_min, renderer_rectangle, renderer_text, string_gsub, string_len, string_sub, table_insert, ui_get, ui_is_menu_open, ui_mouse_position, ui_new_checkbox, ui_new_color_picker, ui_reference, ui_set_callback, ui_set_visible, unpack = client.key_state, client.set_event_callback, database.read, database.write, entity.get_all, entity.get_bounding_box, entity.get_classname, entity.get_local_player, entity.get_player_name, entity.get_player_weapon, entity.get_players, entity.get_prop, globals.maxplayers, math.min, renderer.rectangle, renderer.text, string.gsub, string.len, string.sub, table.insert, ui.get, ui.is_menu_open, ui.mouse_position, ui.new_checkbox, ui.new_color_picker, ui.reference, ui.set_callback, ui.set_visible, unpack

local uix = require 'gamesense/uix'

local wnd = { }
local db = database.read("InfoScreen") or {}
wnd.x = db.x or 150
wnd.y = db.y or 150

wnd.dragging = false


local enabled_reference = uix.new_checkbox("MISC", "Miscellaneous", "Info Screen")
local color_reference = ui_new_color_picker("MISC", "Miscellaneous", "Info Screen", 193, 255, 107, 255)
local location_reference = ui_new_checkbox("MISC", "Miscellaneous", "Info Screen: Location")

local teammates_reference = ui_reference("VISUALS", "Player ESP", "Teammates")

local function contains(table, val)
	for i=1,#table do
		if table[i] == val then 
			return true
		end
	end
	return false
end

local function get_dormant_players(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
	local alive_only = alive_only ~= nil and alive_only or true
	local result = {}

	local player_resource = entity_get_all("CCSPlayerResource")[1]

	for player=1, globals_maxplayers() do
		if entity_get_prop(player_resource, "m_bConnected", player) == 1 then
			local local_player_team
			if enemy_only then
				local_player_team = entity_get_prop(entity_get_local_player(), "m_iTeamNum")
			end

			local is_enemy = true
			if enemy_only and entity_get_prop(player, "m_iTeamNum") == local_player_team then
				is_enemy = false
			end

			if is_enemy then
				local is_alive = true
				if alive_only and entity_get_prop(player_resource, "m_bAlive", player) ~= 1 then
					is_alive = false
				end

				if is_alive then
					table_insert(result, player)
				end
			end
		end
	end

	return result
end

local function on_enabled_changed()
	local enabled = enabled_reference:get()
	ui_set_visible(location_reference, enabled)
end
enabled_reference:on("change", on_enabled_changed)
on_enabled_changed()

local mouse = { }

local function intersect(x, y, w, h, debug) 
    local mousex, mousey = ui_mouse_position()
    debug = debug or false
    if debug then 
        renderer_rectangle(x, y, w, h, 255, 0, 0, 50)
    end
    return mousex >= x and mousex <= x + w and mousey >= y and mousey <= y + h
end

local function paint()
	if enabled_reference:get() then
		local location_enabled = ui_get(location_reference)
		local teammates = ui_get(teammates_reference)
		local column_data = {}
		local line_color = {}

		local columns = {"PLAYER", "HEALTH", "WEAPON"}
		local col_width = 2
		wnd.w = 220

		if location_enabled then 
			columns = {"PLAYER", "HEALTH", "WEAPON", "LOCATION"}
			col_width = 3
			wnd.w = 300
		end

		local enemy_players = get_dormant_players(not teammates)
		if #enemy_players == 0 then
			return
		end
		local enemy_players_nondormant = entity_get_players(not teammates)

		local player_resource = entity_get_all("CCSPlayerResource")[1]
		if player_resource == nil then
			return
		end
		local c4_holder = entity_get_prop(player_resource, "m_iPlayerC4")

		--calculate table height
		wnd.h = (#enemy_players * 15) + 30
		wnd.h = math_min(wnd.h, 145)
		--draw background rectangle
		renderer_rectangle(wnd.x, wnd.y, wnd.w, wnd.h, 29, 31, 38, 170)
		renderer_rectangle(wnd.x, wnd.y, wnd.w, 20, 29, 31, 38, 100)

		--loop all players and fill the column data
		for i=1, #enemy_players do
			local enemy = enemy_players[i]
			local name = entity_get_player_name(enemy)	
			local health = entity_get_prop(enemy, "m_iHealth")
			local weapon = entity_get_player_weapon(enemy)

			local weapon_name = entity_get_classname(weapon) or "Unknown"
			if weapon_name ~= nil and weapon_name ~= "Unknown" and string_len(weapon_name) > 2 then
				weapon_name = string_sub(weapon_name, 2)
				weapon_name = string_gsub(weapon_name, "Weapon", "")
            end
            
            local hasdefuser  = entity_get_prop(enemy , "m_bHasDefuser")
            

			--check if enemy has c4 and draw him as red if he does
			line_color[i] = {255, 255, 255, 255}
			if c4_holder ~= nil and enemy == c4_holder then
				line_color[i] = {255, 0, 0, 255}
            end

            if hasdefuser == 1 then
                line_color[i] = {50, 50, 255, 255}
            end

			if not contains(enemy_players_nondormant, enemy) then
				local _, _, _, _, alpha_multiplier = entity_get_bounding_box(ctx, enemy)
				if alpha_multiplier == nil or alpha_multiplier < 0.15 then
					alpha_multiplier = 0.15
				end
				local r, g, b, a = unpack(line_color[i])
				line_color[i] = {r, g, b, a*alpha_multiplier}
			end
			
			if location_enabled then
                local replacements = {
                    ["^ "] = "",
                    ["of "] = " of "
                }
    
                local enemy_position = ((entity.get_prop(enemy, "m_szLastPlaceName")  or " ").. " " ):gsub("%u[%l ]", function(c) return " " .. c end):sub(1, -2)
                for res, rep in pairs(replacements) do
                    place_name = name:gsub(res, rep)
                end

				column_data[i] = {name, health, weapon_name, enemy_position}
			else
				column_data[i] = {name, health, weapon_name}
			end
		end

		local r_header, g_header, b_header, a_header = ui_get(color_reference)
		
		for i=0, col_width do		
			renderer_text((wnd.x + 31) + (i * 75), wnd.y + 11, r_header, g_header, b_header, a_header, "-c", 70, columns[i+1])
			if #enemy_players >= 1 then
				for j = 1, #enemy_players do
					local r, g, b, a = 255, 255, 255, 255
					if line_color[j] ~= nil then
						r, g, b, a = unpack(line_color[j])
					end
					renderer_text((wnd.x + 31) + (i * 75), wnd.y + (15 + (j*12)), r, g, b, a, "c", 70, column_data[j][i+1])
				end	
			end
		end
	    if ui_is_menu_open() then 
            mouse.x, mouse.y = ui_mouse_position()
            local left_click = client_key_state(0x01)

            renderer_text(wnd.x, wnd.y-1, 255, 255, 255, 255, "b", 999, "Drag here to move info screen")

            if wnd.dragging and not left_click then
                wnd.dragging = false
            end

            if wnd.dragging and left_click then
                wnd.x = mouse.x - wnd.drag_x
                wnd.y = mouse.y - wnd.drag_y
            end

            if intersect(wnd.x, wnd.y, wnd.w, 10, true) and left_click then 
                wnd.dragging = true
                wnd.drag_x = mouse.x - wnd.x
                wnd.drag_y = mouse.y - wnd.y
            end
        end
	end
end

enabled_reference:on("paint", paint)

client_set_event_callback("shutdown", function()
    database_write("InfoScreen", {
        x = wnd.x,
        y = wnd.y
    })
end)