local success, surface = pcall(require, 'gamesense/surface')

if not success then
    error('\n\n - Surface library is required \n - https://gamesense.pub/forums/viewtopic.php?id=18793\n')
end

-- Initialization
local verdana = surface.create_font('Verdana', 12, 400, { 0x200 --[[ Outline ]] })
local small = surface.create_font('Small Fonts', 8, 450, { 0x200 --[[ Outline ]] })

-- Plugin elements
local refer = { 'Visuals', 'Player ESP' }
local health_bar = { 'off', 'default', 'custom color' }
local flag_list = { 'fake', 'delay', 'helm', 'scoped', 'duck', 'bomb', 'host', 'pin' }

local duck_ticks = { }
local menu = {
    team = ui.reference('Visuals', 'Player ESP', 'Teammates'),

    names = {
        ui.new_checkbox(refer[1], refer[2], 'names'),
        ui.new_color_picker(refer[1], refer[2], 'names color', 255, 255, 255, 150)
    },

    healthbar = { 
        ui.new_combobox(refer[1], refer[2], 'healthbar', health_bar),
        ui.new_color_picker(refer[1], refer[2], 'healthbar color', 255, 255, 255, 255)
    },

    flags = ui.new_multiselect(refer[1], refer[2], 'flags', flag_list),
}

-- Local variables & functions
local entity_get_local_player = entity.get_local_player
local entity_get_player_weapon = entity.get_player_weapon
local entity_get_player_resource = entity.get_player_resource

local entity_is_enemy = entity.is_enemy

local entity_get_prop = entity.get_prop
local entity_get_bounding_box = entity.get_bounding_box
local entity_get_player_name = entity.get_player_name
local entity_get_classname = entity.get_classname

local globals_tickcount = globals.tickcount
local globals_maxplayers = globals.maxplayers
local table_insert = table.insert
local math_min = math.min
local ui_get = ui.get


local surface_measure_text = surface.measure_text
local surface_draw_text = surface.draw_text
local surface_draw_filled_rect = surface.draw_filled_rect

local function get_entities(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
    local alive_only = alive_only ~= nil and alive_only or true
    
    local result = {}

    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()
    
	for player = 1, globals_maxplayers() do
		if entity_get_prop(player_resource, 'm_bConnected', player) == 1 then
            local is_enemy, is_alive = true, true
            
			if enemy_only and not entity_is_enemy(player) then is_enemy = false end
			if is_enemy then
				if alive_only and entity_get_prop(player_resource, 'm_bAlive', player) ~= 1 then is_alive = false end
				if is_alive then table_insert(result, player) end
			end
		end
	end

	return result
end

client.set_event_callback('paint', function()
    local me = entity_get_local_player()
    local player_resource = entity_get_player_resource()

	local observer_mode = entity_get_prop(me, "m_iObserverMode")
	local active_players = {}

	if (observer_mode == 0 or observer_mode == 1 or observer_mode == 2 or observer_mode == 6) then
		active_players = get_entities(true, true)
	elseif (observer_mode == 4 or observer_mode == 5) then
		local all_players = get_entities(false, true)
		local observer_target = entity_get_prop(me, "m_hObserverTarget")
		local observer_target_team = entity_get_prop(observer_target, "m_iTeamNum")

		for test_player = 1, #all_players do
			if (
				observer_target_team ~= entity_get_prop(all_players[test_player], "m_iTeamNum") and
				all_players[test_player ] ~= me
			) then
				table_insert(active_players, all_players[test_player])
			end
		end
	end

    if #active_players == 0 then
        return
    end

    for i=1, #active_players do
        local player = active_players[i]
        local x1, y1, x2, y2, a_multiplier = entity_get_bounding_box(c, player)

        if x1 ~= nil and a_multiplier > 0 then
            local center = x1 + (x2-x1)/2

            local pflags = ui_get(menu.flags)
            local weapon = entity_get_player_weapon(player)

            if ui_get(menu.names[1]) then
                local name = entity_get_player_name(player):lower()
                local w = surface_measure_text(nil, name)

                local r, g, b, a = ui_get(menu.names[2])

                a = a_multiplier*a

                if a_multiplier < 1 then
                    r, g, b, a = 255, 255, 255, a_multiplier*180
                end

                surface_draw_text(center - w/2, y1 - 15, r, g, b, a_multiplier*255, verdana, name)
            end

            if ui_get(menu.healthbar[1]) ~= 'off' then
                local health = entity_get_prop(player, 'm_iHealth')
                local hp = math_min(health, 100)

                hp = hp == 0 and 100 or hp

                local a = a_multiplier*255
                local r, g, b = 63, 208, 64

                if hp < 50 then r, g, b = 175, 163, 63 end
                if hp < 35 then r, g, b = 208, 35, 63 end

                if ui_get(menu.healthbar[1]) == health_bar[3] then
                    r, g, b, a = ui_get(menu.healthbar[2])
                    a = a_multiplier*a
                end

                if a_multiplier < 1 then
                    r, g, b, a = 255, 255, 255, a_multiplier*180
                end

                local height = y2 - y1 - 1
                local bar_height = (hp / 100) * height

                surface_draw_filled_rect(x1 - 6, y1 - 1, 4, height + 3, 0, 0, 0, a_multiplier*200)
                surface_draw_filled_rect(x1 - 5, y2 - bar_height - 1, 2, bar_height + 1, r, g, b, a)
        
                if hp <= 95 then
                    surface_draw_text(x1 - 9, y2 - bar_height - 6, 255, 255, 255, a_multiplier*255, small, tostring(hp))
                end
            end

            if #pflags ~= 0 then
                local offset = 0

                local m_iPlayerC4 = entity_get_prop(player_resource, 'm_iPlayerC4')
                local m_iPing = entity_get_prop(player_resource, 'm_iPing', player)

                -- { 'fake', 'delay', 'helm', 'scoped', 'blind', 'duck', 'bomb', 'host', 'pin', 'vulnerable' }

                for j=1, #pflags do
                    local flag = pflags[j]

                    if flag == 'fake' and plist.get(player, 'Correction active') then
                        surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 255, 255, a_multiplier*255, small, 'FAKE')
                        offset = offset + 1
                    end

                    if flag == 'delay' and m_iPing > 75 then
                        surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 103, 107, 142, a_multiplier*255, small, m_iPing .. ' MS')
                        offset = offset + 1
                    end

                    if flag == 'helm' then
                        local helm, kev = 
                            entity_get_prop(player, 'm_bHasHelmet') == 1, 
                            entity_get_prop(player, 'm_ArmorValue') ~= 0

                        if helm or kev then
                            local text = helm and 'HELM' or (kev and 'KEV' or '')
                            surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 255, 255, a_multiplier*255, small, text)
                            offset = offset + 1
                        end
                    end

                    if flag == 'scoped' and weapon ~= nil then
                        local wpn_name = entity_get_classname(weapon)
                        local zoom_lvl = entity_get_prop(weapon, 'm_zoomLevel')

                        if wpn_name ~= nil and zoom_lvl ~= 0 and (wpn_name:lower():match("ssg08") or wpn_name:lower():match("awp") or wpn_name:lower():match("scar20") or wpn_name:lower():match("g3sg1")) then
                            surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 242, 229, 176, a_multiplier*255, small, 'SCOPED')
                            offset = offset + 1
                        end
                    end

                    if flag == 'duck' then
                        local toBits = function(num) local t = { }; while num > 0 do rest = math.fmod(num,2); t[#t+1] = rest; num = (num-rest) / 2 end return t end

                        local duck_amt = entity_get_prop(player, 'm_flDuckAmount')
                        local duck_speed = entity_get_prop(player, 'm_flDuckSpeed')
                        local m_fFlags = entity_get_prop(player, 'm_fFlags')

                        if duck_ticks == nil then
                            duck_ticks = { }
                        end

                        if duck_ticks[player] == nil then duck_ticks[player] = 0 end
                        if duck_speed ~= nil and duck_amt ~= nil then
                            if duck_speed == 8 and duck_amt <= 0.9 and duck_amt > 0.01 and toBits(m_fFlags)[1] == 1 then
                                if storedTick ~= globals_tickcount() then
                                    duck_ticks[player] = duck_ticks[player] + 1
                                    storedTick = globals_tickcount()
                                end
            
                                if duck_ticks[player] >= 5 then 
                                    surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 255, 255, a_multiplier*255, small, 'DUCK')
                                    offset = offset + 1
                                end
                            else
                                duck_ticks[player] = 0
                            end
                        end
                    end

                    if flag == 'bomb' and m_iPlayerC4 == player then
                        surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 0, 0, a_multiplier*255, small, 'B')
                        offset = offset + 1
                    end

                    if flag == 'host' and entity_get_prop(player, 'm_hCarriedHostage') ~= nil then
                        surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 0, 0, a_multiplier*255, small, 'VIP')
                        offset = offset + 1
                    end

                    if flag == 'pin' and entity_get_prop(weapon, 'm_bPinPulled') == true then
                        surface_draw_text(x2 + 2, y1 + (offset * 10) - 2, 255, 0, 0, a_multiplier*255, small, 'PIN')
                        offset = offset + 1
                    end
                end
            end
        end
    end
end)
