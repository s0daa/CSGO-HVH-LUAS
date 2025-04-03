local enable = ui.new_checkbox("VISUALS", "Other ESP", "Show hit/miss ratio indicator")

local stats = {
	total_shots = 0,
	hits = 0
}

client.set_event_callback("paint", function()
	local lp = entity.get_local_player()
	
	if not ui.get(enable) then return end
	if not lp then return end
	if entity.get_prop(lp, "m_lifeState") ~= 0 then return end

	renderer.indicator(200, 200, 200, 255, string.format("%s/%s (%s)", stats.hits, stats.total_shots, string.format("%.1f", stats.total_shots ~= 0 and (stats.hits/stats.total_shots*100) or 0)))
end)

client.set_event_callback("aim_hit", function()
	stats.total_shots = stats.total_shots + 1
	stats.hits = stats.hits + 1
end)

client.set_event_callback("aim_miss", function(e)
	if e.reason ~= "death" and e.reason ~= "unregistered shot" then
		stats.total_shots = stats.total_shots + 1
	end
end)

client.set_event_callback("player_connect_full", function(e)
	if client.userid_to_entindex(e.userid) == entity.get_local_player() then
		stats = {
			total_shots = 0,
			hits = 0
		}
	end
end)