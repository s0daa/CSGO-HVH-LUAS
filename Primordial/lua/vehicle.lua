local function OnVehicleChanged(oldVehicle, newVehicle)
	if newVehicle ~= nil then
		if newVehicle:get_model_hash() == 0x586765fb then
			newVehicle:set_number_plate_text('outatime')
		end
	
		-- newVehicle:set_health(1000)
	end
end

menu.register_callback('OnVehicleChanged', OnVehicleChanged)
