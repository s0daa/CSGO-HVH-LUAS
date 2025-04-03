local function OnWeaponChanged(oldWeapon, newWeapon)
	if newWeapon ~= nil then
		newWeapon:set_current_ammo(9999)
	end
end

-- Uncomment the next line to set ammo to 9999 each time a new weapon is selected:
-- menu.register_callback('OnWeaponChanged', OnWeaponChanged)
