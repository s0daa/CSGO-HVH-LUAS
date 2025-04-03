local function OnPlayerChanged(oldPlayer, newPlayer)
	-- When switching player, instantly refill health and armor
	if newPlayer ~= nil then
		newPlayer:set_armour(100)
		newPlayer:set_health(newPlayer:get_max_health())
		menu.max_all_ammo()
	end
end

-- Uncomment the next line to call the OnPlayerChanged function when switching between player character:
-- menu.register_callback('OnPlayerChanged', OnPlayerChanged)
