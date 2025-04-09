-- downloaded from dsc.gg/southwestcfgs

local ui_get, ui_set = ui.get, ui.set
local e_get_all, e_get_prop = entity.get_all, entity.get_prop
local ps_warning = ui.new_checkbox("VISUALS", "Other ESP", "Ping spike warning")
local dormancy = ui.new_combobox("VISUALS", "Other ESP", "Dormancy", "Fade with dormant", "Dont fade with dormant")
local ps_warning_ext = ui.new_checkbox("VISUALS", "Other ESP", "Extended info")
local js = panorama.open()
local GameStateAPI = js.GameStateAPI

local function handleGUI()
	local getstate = ui.get(ps_warning)
	ui.set_visible(ps_warning_ext, getstate)
end
client.set_event_callback("paint_ui", handleGUI)

local function g_Math(int, max, declspec)
	local int = (int > max and max or int)

	local tmp = max / int;
	local i = (declspec / tmp)
	i = (i >= 0 and math.floor(i + 0.5) or math.ceil(i - 0.5))

	return i
end

local function g_ColorByInt(number, max)
	local Colors = {
		{ 124, 195, 13 },
		{ 176, 205, 10 },
		{ 213, 201, 19 },
		{ 220, 169, 16 },
		{ 228, 126, 10 },
		{ 229, 104, 8 },
		{ 235, 63, 6 },
		{ 237, 27, 3 },
		{ 255, 0, 0 }
	}

	i = g_Math(number, max, #Colors)
	return
		Colors[i <= 1 and 1 or i][1], 
		Colors[i <= 1 and 1 or i][2],
		Colors[i <= 1 and 1 or i][3]
end

local function g_DormantPlayers(enemy_only, alive_only)
	local enemy_only = enemy_only ~= nil and enemy_only or false
	local alive_only = alive_only ~= nil and alive_only or true
	local result = {}

	local player_resource = e_get_all("CCSPlayerResource")[1]
	for player=1, globals.maxplayers() do
		if e_get_prop(player_resource, "m_bConnected", player) == 1 then
			local local_player_team, is_enemy, is_alive = nil, true, true
			if enemy_only then local_player_team = e_get_prop(entity.get_local_player(), "m_iTeamNum") end
			if enemy_only and e_get_prop(player, "m_iTeamNum") == local_player_team then is_enemy = false end
			if is_enemy then
				if alive_only and e_get_prop(player_resource, "m_bAlive", player) ~= 1 then is_alive = false end
				if is_alive then table.insert(result, player) end
			end
		end
	end

	return result
end

local g_PlayerState = {}
local function setPlayerState(entity, t, element)
	if element then 
		g_PlayerState[entity][element] = t
	else 
		g_PlayerState[entity] = t
	end
end

local function setAlphaLimit(number)
	local i = number
	i = i >= 255 and 255 or i
	i = i <= 0 and 0 or i
	return i
end

client.set_event_callback("paint", function(c)
	local g_Local = entity.get_local_player()
	if not ui_get(ps_warning) or not g_Local or not entity.is_alive(g_Local) then
		return
	end

	local g_Players = g_DormantPlayers(true, true)
	local g_CSPlayerResource = e_get_all("CCSPlayerResource")[1]

	if #g_Players == 0 then return end
	for i=1, #g_Players do
		local xuid = GameStateAPI.GetPlayerXuidStringFromEntIndex(g_Players[i])
		local is_bot = GameStateAPI.IsFakePlayer(xuid)

		local latency = e_get_prop(g_CSPlayerResource, string.format("%03d", g_Players[i]))
		local max_latency = (latency > 400 and 350 or latency)
		local g_CurState = g_PlayerState[i]

		if not g_CurState then
			setPlayerState(i, { ["ping"] = latency, ["curtime"] = globals.realtime(), ["alpha"] = 0 })
			g_CurState = g_PlayerState[i]
		end

		if g_CurState.ping ~= latency and g_CurState.curtime < globals.realtime() then
			d = g_CurState.ping > latency and -1 or 1
			setPlayerState(i, globals.realtime() + 0.01, "curtime")
			setPlayerState(i, g_CurState.ping + d, "ping")
		end

		if g_CurState.ping < 75 then
			setPlayerState(i, setAlphaLimit(g_CurState.alpha - 1), "alpha")
		else
			setPlayerState(i, setAlphaLimit(g_CurState.alpha + 1), "alpha")
		end

		local name = entity.get_player_name(g_Players[i])
		local y_additional = name == "" and -8 or 0
		local x1, y1, x2, y2, a_multiplier = entity.get_bounding_box(c, g_Players[i])
		if x1 ~= nil and entity.is_alive(g_Players[i]) and a_multiplier > 0 and not is_bot then
			local x_center = x1 + (x2-x1)/2
			local r, g, b = g_ColorByInt(g_CurState.ping, 450)

			if x_center ~= nil then
				local n, ping_state, alpha_state = 0, g_CurState.ping, g_CurState.alpha
				local fat
				local dormant_state = (a_multiplier * 255)

				if dormant_state <= 150 and alpha_state > 150 then
					n = dormant_state
					fat = false
				elseif (ping_state > 75 and dormant_state > 75) or ping_state <= 75 then
					n = alpha_state
					fat = false
				elseif (ping_state < 25 and dormant_state < 25) or ping_state <= 25 then
					fat = true
				end
				
				if ui.get(dormancy) == "Fade with dormant" then
					if ui.get(ps_warning_ext) then
						if (g_CurState.ping < 10) then
							client.draw_text(c, x_center - 7, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 25, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "(    )")
							client.draw_text(c, x_center + 25, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, g_CurState.ping)
							client.draw_text(c, x_center + 39, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
						elseif (g_CurState.ping < 26) then
							client.draw_text(c, x_center - 7, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 27, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "(       )")
							client.draw_text(c, x_center + 27, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, g_CurState.ping)
							client.draw_text(c, x_center + 44, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
						else
							client.draw_text(c, x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state, " MS")
						end
					else
						if (g_CurState.ping < 25) then
							client.draw_text(c, x_center, y1 - 15 + y_additional, 255, 75, 75, dormant_state, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 35, y1 - 18 + y_additional, 255, 0, 0, dormant_state, "c-", 0, "⚠️")
						else
							client.draw_text(c, x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state, " MS")
						end
					end
				else
					if ui.get(ps_warning_ext) then
						if (g_CurState.ping < 10) then
							client.draw_text(c, x_center - 7, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 25, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "(    )")
							client.draw_text(c, x_center + 25, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, g_CurState.ping)
							client.draw_text(c, x_center + 39, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
						elseif (g_CurState.ping < 26) then
							client.draw_text(c, x_center - 7, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 27, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "(       )")
							client.draw_text(c, x_center + 27, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, g_CurState.ping)
							client.draw_text(c, x_center + 44, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
						else
							client.draw_text(c, x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state, " MS")
						end
					else
						if (g_CurState.ping < 25) then
							client.draw_text(c, x_center, y1 - 15 + y_additional, 255, 75, 75, 255, "c-", 0, "PING CARRIED")
							client.draw_text(c, x_center + 35, y1 - 18 + y_additional, 255, 0, 0, 255, "c-", 0, "⚠️")
						else
							client.draw_text(c, x_center, y1 - 15 + y_additional, r, g, b, n, "c-", 0, ping_state, " MS")
						end
					end
				end
			end
		end
	end
end)